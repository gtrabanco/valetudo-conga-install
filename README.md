## WARNING
**WARNING!** These scripts could damage your vacuum!

## INDEX

- [UNTESTED](#untested)
- [WARRANTY](#warranty)
- [Introduction](#introduction)
- [Usage](#usage)
  - [Reqirements](#reqirements)
  - [General usage](#general-usage)
  - [Manually Knowing the ip address of your conga](#manually-knowing-the-ip-address-of-your-conga)
  - [Full automate installation instructions](#full-automate-installation-instructions)
  - [Install ssh public key manually](#install-ssh-public-key-manually)
  - [Install valetudo manually](#install-valetudo-manually)
- [TESTING](#testing)


## WARRANTY
Disclaimer of Software Warranty. LICENSES THE LICENSED SOFTWARE "AS IS," AND MAKES NO EXPRESS OR IMPLIED WARRANTY OF ANY KIND. SPECIFICALLY DISCLAIMS ALL INDIRECT OR IMPLIED WARRANTIES TO THE FULL EXTENT ALLOWED BY APPLICABLE LAW, INCLUDING WITHOUT LIMITATION ALL IMPLIED WARRANTIES OF, NON-INFRINGEMENT, MERCHANTABILITY, TITLE OR FITNESS FOR ANY PARTICULAR PURPOSE. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY ANY PERSON IN ANY ISSUE OR BY THE DOC OF THIS REPOSITORY, ITS MANTAINERS OR COLLABORATORS OF ANY KIND SHALL CREATE A WARRANTY.
## Introduction

These scripts are intended to make easier the instalation of Valetudo in Congas.

## Usage

### Reqirements

* This required a bash shell to work so you must use these scripts under WSL, Linux, Cygwin, macOS or similar.
* curl, awk, ssh, ssh-keygen, ssh-add & git.
* Know the ip address of your conga (there is a script to guess which is the ip address).

### General usage

To use these scripts they must be downloaded:

```bash
CONGA_INSTALL_PATH="${HOME}/valetudo-conga-install"
git clone https://github.com/gtrabanco/valetudo-conga-install.git "$CONGA_INSTALL_PATH"
```

This readme will be redacted as this repository were downloaded in `CONGA_INSTALL_PATH` variable

### Manually Knowing the ip address of your conga

Some routers have a admin webpage and some of those also includes a webpage where you can see the leased local ip address of dhcp server. If this is not you case you can use nmap but you need to know which ip range is serving your dhcp server:

To know your ip address supposing `eth0` is your network adapter. On macOS the default wifi adapter name is `en0`, on linux used to be `wlan0`. If you do not know which is your adapter name just simply use `ifconfig` and look for your ip address as in sample code:

```bash
ifconfig | awk '/inet [0-9\.]+/ {print $2}' | grep -v '127.0.0' | cut -d. -f1-3
```

Normally the netmask is `255.255.255.0` if you did not set other setting in your router.

Now to look for your conga you can use [nmap](https://nmap.org/) (needs to be installed because it is not a default tool):

```bash
IP_RANGE="$(ifconfig eth0 | awk '/inet [0-9\.]+/ {print $2}' | cut -d. -f1-3).2-254"
nmap -Pn -p 22,53,6000 "$IP_RANGE" -oG - | awk '/\/open\// { print $2 }'
```

One of the given results if the conga so you should see a reduced result...

### Full automate installation instructions

Execute on your computer (not in the conga):

```bash
curl -fsL "https://raw.githubusercontent.com/gtrabanco/valetudo-conga-install/HEAD/remote_install_from_computer" | bash
```

You need to know the ip address of your Conga.

### Install ssh public key manually

After we know the possible ip addresses we can install to the conga the ssh public key, if you do not have it generated already the script will do it for you:

```bash
"${CONGA_INSTALL_PATH}/bin/conga-install-ssh" "$CONGA_IP"
```

If you have a new conga that password is not known by the script but you know the password you can define an array of with the password or all possible passwords by defining an eviroment variable before calling the script:

```
export KNOWN_CONGA_PASSWORDS=(
  "1newpossiblepassword"
  "anotherpossiblecongapassword"
)

"${CONGA_INSTALL_PATH}/bin/conga-install-ssh" "$CONGA_IP"
```

### Install valetudo manually

To install valetudo in the conga use:

```bash
"${CONGA_INSTALL_PATH}/bin/conga-install-valetudo" "$CONGA_IP"
```

For more advanced options use `--help` option.

## TESTING

The compilation process previous to uploading was not tested, if you do please open an issue with the issues or notifing that works

The `remote_install_from_computer` was not tested but should work as `conga-full-install` do.
