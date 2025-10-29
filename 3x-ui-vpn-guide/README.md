# 3x-ui installation with self-signed certs



Debian based linux (apt):
```
apt update && apt upgrade -y
```

Download and install [3X-UI](https://github.com/MHSanaei/3x-ui):

```
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
```

Access cli management using ``x-ui`` command:

Go for **x-ui** and option `10. View Current Settings`, use login and password to login into the web panel - click to `Access URL`  after option drops info:

```
Please enter your selection [0-25]: 10  
[INF] current panel settings as follows:
SSL is not installed or smth like that
username: user
password: pass
port: 22222
webBasePath: /bababababa/ 
Access URL: https://xx.xx.xx.xx:22222/bababababa/
```

Now it's time to setup your self-signed certs. You can use this [script](https://github.com/Roguelied/the-stash/blob/main/3x-ui-vpn-guide/create-self-signed-certs.sh) - it will create keys for you in `/etc/ssl/self_signed_cert/` directory.
```
bash <(curl -Ls https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/3x-ui-vpn-guide/create-self-signed-certs.sh)
```

When script is finish the work for certs, copy the filepaths and go to Web Panel.
Navigate to **Panel Settings** on left menu. In **General** find 2 fields: **Public Key Path** and **Private Key Path** - fill them with paths script gives you. **Restart Panel** after changing this value. 

Now panel should have self-signed certs.

After that you probably need to change port, panel unique url, panel login and password using ``6. Reset Username & Password & Secret Token`` in ``x-ui`` menu.

Go for ``x-ui``, choose ``20. IP Limit Management``, then go ``1. Install Fail2ban and configure IP Limit``. That will setup fail2ban and ip limit for your web-panel and vpn connections.

Also there is ``21. Firewall Management``. Choosing ``1. Install Firewall`` will install [ufw](https://en.wikipedia.org/wiki/Uncomplicated_Firewall#:~:text=Uncomplicated%20Firewall%20(UFW)%20is%20a,Ubuntu%20installations%20since%208.04%20LTS.) on your server, but do not forget to exclude your web-panel port from ufw block list, use ``3. Open Ports`` to add it.

That is all for cli management for now. Check option 10 if you forgot something.


For config creation log in Web Panel and go for **Inbounds** -> **Add Inbound**
```
Protocol: vless
Port: 443 (https)

Security: Reality
Dest (Target): google.com:433
SNI: google.com,www.google.com

Click Get New Cert for keys

Client:
	Email: Set its value to a human-readable thing or leave it, it's like an id
	Flow: xtls-rprx-vision
```

After that copy your vless config at **More information** button.


