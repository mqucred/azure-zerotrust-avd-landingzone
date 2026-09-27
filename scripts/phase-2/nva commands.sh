# --- Linux shell commands run ON vm-hub-nva-01 (not PowerShell, included for completeness) ---
# sudo sysctl -w net.ipv4.ip_forward=1
# echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
# sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# sudo iptables -A FORWARD -j ACCEPT
# sudo apt install -y iptables-persistent && sudo netfilter-persistent save