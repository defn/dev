```
cd etc/openvn
easyrsa init-pki
easyrsa gen-dh
easyrsa build-ca
easyrsa build-server-full server
openssl rsa -in pki/private/server.key  -out pki/private/server2.key
sudo openvpn server.conf
```
