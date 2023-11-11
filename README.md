# Born2beRoot
## Virtual box network configuration

|Mode      | VM→Host | VM←Host    | VM1↔VM2 | VM→Net/LAN| VM←Net/LAN |
|:---------|:-------:|:----------:|:-------:|:---------:|:----------:|
|Host-only |+        |+           |+        |–          |–           |
|Internal  |–        |–           |+        |–          |–           |
|Bridged   |+        |+           |+        |+          |+           |
|NAT       |+        |Port forward|–        |+          |Port forward|
|NATservice|+        |Port forward|+        |+          |Port forward|



### minimu installation



### git installation

I decide to keep in a git repository the script to configure de server as requested in de proyect

```bash
apt install sudo
adduser luicasad sudo    //logout and login
```


`apt-get install git`

### ssh-server

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl enable ssh



sudo apt install ufw
sudo ufw enable
sudo ufw limit ssh

`ip addr show`
