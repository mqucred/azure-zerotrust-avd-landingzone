# --- Linux commands run ON vm-hub-nva-01 (not PowerShell, included for completeness) ---
# sysctl net.ipv4.ip_forward
# sudo iptables -t nat -S POSTROUTING
# sudo iptables -S FORWARD
# curl -m 10 -sS -o /dev/null -w "%{http_code}\n" https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03519.1433.zip
# sudo tcpdump -nni any 'host 10.210.2.4 or host 20.60.153.129'
