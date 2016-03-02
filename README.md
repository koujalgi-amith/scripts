# scripts

Post Ubuntu-installation script
```sh
sudo wget https://raw.githubusercontent.com/koujalgi-amith/scripts/master/ubuntu-setup.sh -v -O ubuntu-setup.sh; sudo chmod 777 ubuntu-setup.sh; ./ubuntu-setup.sh; rm -rf ubuntu-setup.sh
```

Post Ubuntu Server setup
```sh
sudo wget https://raw.githubusercontent.com/koujalgi-amith/scripts/master/new-ubuntu-server.sh -v -O new-ubuntu-server.sh; sudo chmod 777 new-ubuntu-server.sh; ./new-ubuntu-server.sh; rm -rf new-ubuntu-server.sh
```

Setup aliases:
```sh
wget https://raw.githubusercontent.com/koujalgi-amith/scripts/master/aliases.sh -v -O aliases.sh; chmod 777 aliases.sh; ./aliases.sh; rm -rf aliases.sh; source ~/.bash_profile;
```
l - lists all files of a directory

fkill <process-name> - kills all processes by <process-name>
