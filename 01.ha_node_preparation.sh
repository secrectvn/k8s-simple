# install docker
curl -Lso- https://raw.githubusercontent.com/rancher/install-docker/master/18.09.1.sh | sudo bash
sudo usermod -aG docker $USER

# enable modules
for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp;
do
    if ! lsmod | grep -q $module; then
        echo "module $module is not present";
        sudo modprobe $module
    fi;
done

# Setting sysctl
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1

# Config ssh server settings
echo "AllowTcpForwarding yes" | sudo tee -a /etc/ssh/sshd_config
sudo service sshd restart