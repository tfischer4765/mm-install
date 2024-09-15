#!/bin/bash

# prerequisites:
#  - pi must have a (fresh) Raspbian lite installed
#  - user must be set up correctly to be able to sudo without password
#  - pi must have internet access

#functions
fatal() {
    echo -e "\e[1;31m$1\e[0m"
    exit 1
}

banner() {
    echo
    echo -e "\e[1;37m$(printf '%.0s-' {1..80})\e[0m"
    echo -e "\e[1;4;37m$1\e[0m"
    echo -e "\e[1;37m$(printf '%.0s-' {1..80})\e[0m"
    echo
}


warn() {
    # Print the first argument in red and bold
    echo -e "\e[1;33m$1\e[0m"
}


consent() {
    local max_tries="${2:-3}"
     local input=""
    local attempts=0
    local matchphrase=$1
    echo -n "Please enter '$matchphrase' to continue: "
    while [ "$attempts" -lt "$max_tries" ]; do
         read -r input
         if [ "$input" == "$matchphrase" ]; then
            return 0
        fi

        attempts=$((attempts + 1))
        echo -n "Please enter '$matchphrase' to continue ($((max_tries - attempts)) tries left): "
    done

    echo "Consent not given, exiting."
    exit 1
}

# Function to get user confirmation
yes_no() {
    local max_tries="${1:-3}"
    local input=""
    local attempts=0

    # List of variants for "yes" in different languages
    local yes_variants=(
        "yes" "y" "ja" "j" "1"       # English, Dutch, German, Swedish
        "si" "oui" "sim" "da"        # Spanish, French, Portuguese, Danish
        "ano" "sì" "hai"             # Czech, Italian, Thai
    )
    # List of variants for "no" in different languages
    local no_variants=(
        "no" "n" "nein" "0"          # English, Dutch, German
        "non" "não" "ne" "nie"       # French, Portuguese, Hungarian, Polish
        "não" "nem" "b"              # Portuguese, Croatian, Finnish
    )

    echo -n " (y/N): "

    while [ "$attempts" -lt "$max_tries" ]; do
        read -r input
        # Convert input to lowercase
        input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

        # Check if input is in the list of yes variants
        for yes in "${yes_variants[@]}"; do
            if [ "$input" == "$yes" ]; then
                return 1
            fi
        done

        # Check if input is in the list of no variants
        for no in "${no_variants[@]}"; do
            if [ "$input" == "$no" ]; then
                return 0
            fi
        done

        attempts=$((attempts + 1))
        if [ "$attempts" -lt "$max_tries" ]; then echo "Please enter 'yes' or 'no' to continue $((max_tries - attempts)) tries left."; fi
    done

    # If maximum attempts are exceeded, assume 'no'
    return 0
}

if [ -e /usr/local/share/mm-support -o -e /usr/local/share/magicmirror -o -e /etc/magicmirror -o -e /tmp/mm-install ]; then
  fatal "Some of the files and directories this script is supposed to run already exist. Refusing to run to avoid clobbering existing files. Please run this script on a PRISTINE PiOS lite image"
fi

# embedded files
mkdir /tmp/mm-install


# #!/bin/sh

# xset s off         # don't activate screensaver
# xset -dpms         # disable DPMS (Energy Star) features.
# xset s noblank     # don't blank the video device

# if [ -r "/etc/magicmirror/xrandr_opts" ]; then
#        echo "running xrandr with arguments \"$(cat /etc/magicmirror/xrandr_opts)\""
#        DISPLAY=:0 xrandr $(cat /etc/magicmirror/xrandr_opts)
# else
#         echo "not running xrandr"
# fi

# xsetroot -solid black

# if [ -r "/etc/magicmirror/x_background_image" ] && [ -r "$(cat /etc/magicmirror/x_background_image)" ]; then
#         xli -onroot $(cat /etc/magicmirror/x_background_image)
# fi

# while :; do sleep 10000; done

base64 -d > /tmp/mm-install/xinitrc <<< 'IyEvYmluL3NoCgp4c2V0IHMgb2ZmICAgICAgICAgIyBkb24ndCBhY3RpdmF0ZSBzY3JlZW5zYXZl
cgp4c2V0IC1kcG1zICAgICAgICAgIyBkaXNhYmxlIERQTVMgKEVuZXJneSBTdGFyKSBmZWF0dXJl
cy4KeHNldCBzIG5vYmxhbmsgICAgICMgZG9uJ3QgYmxhbmsgdGhlIHZpZGVvIGRldmljZQoKaWYg
WyAtciAiL2V0Yy9tYWdpY21pcnJvci94cmFuZHJfb3B0cyIgXTsgdGhlbgogICAgICAgZWNobyAi
cnVubmluZyB4cmFuZHIgd2l0aCBhcmd1bWVudHMgXCIkKGNhdCAvZXRjL21hZ2ljbWlycm9yL3hy
YW5kcl9vcHRzKVwiIgogICAgICAgRElTUExBWT06MCB4cmFuZHIgJChjYXQgL2V0Yy9tYWdpY21p
cnJvci94cmFuZHJfb3B0cykKZWxzZQoJZWNobyAibm90IHJ1bm5pbmcgeHJhbmRyIgpmaQoKeHNl
dHJvb3QgLXNvbGlkIGJsYWNrCgppZiBbIC1yICIvZXRjL21hZ2ljbWlycm9yL3hfYmFja2dyb3Vu
ZF9pbWFnZSIgXSAmJiBbIC1yICIkKGNhdCAvZXRjL21hZ2ljbWlycm9yL3hfYmFja2dyb3VuZF9p
bWFnZSkiIF07IHRoZW4KCXhsaSAtb25yb290ICQoY2F0IC9ldGMvbWFnaWNtaXJyb3IveF9iYWNr
Z3JvdW5kX2ltYWdlKQpmaQoKd2hpbGUgOjsgZG8gc2xlZXAgMTAwMDA7IGRvbmUKCg=='

# [Unit]
# Description=Minimal X Server
# After=network.target

# [Service]
# Type=simple
# ExecStart=/usr/bin/xinit /etc/magicmirror/xinitrc -- -nocursor :0
# Restart=on-failure

# [Install]
# WantedBy=multi-user.target

base64 -d > /tmp/mm-install/xserver.service <<< 'W1VuaXRdCkRlc2NyaXB0aW9uPU1pbmltYWwgWCBTZXJ2ZXIKQWZ0ZXI9bmV0d29yay50YXJnZXQK
CltTZXJ2aWNlXQpUeXBlPXNpbXBsZQpFeGVjU3RhcnQ9L3Vzci9iaW4veGluaXQgL2V0Yy9tYWdp
Y21pcnJvci94aW5pdHJjIC0tIC1ub2N1cnNvciA6MApSZXN0YXJ0PW9uLWZhaWx1cmUKCltJbnN0
YWxsXQpXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAoK'

cat << 'EOF' >/tmp/mm-install/magicmirror.service
[Unit]
Requires=xserver.service
After=xserver.service
Description=MagicMirror
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=magicmirror
WorkingDirectory=/usr/local/share/magicmirror/
ExecStart=/usr/bin/npm start

[Install]
WantedBy=multi-user.target
EOF


cat << 'EOF' >/tmp/mm-install/99-vc4.conf
Section "OutputClass"
    Identifier "vc4"
    MatchDriver "vc4"
    Driver "modesetting"
    Option "PrimaryGPU" "true"
EndSection
EOF


#Check if we are running with root access

if [ "$EUID" -ne 0 ]
  then echo "This script needs to install software and change system files. It needs to run with elevated privileges"
  exit 1
fi

#Bug the user with various caveats:

echo "This script will set up your raspberry pi to run a minimal X setup suitable for MagicMirror and not much else."
echo "Do not run it if you plan on using this pi for any other graphical stuff"
echo
echo "For technical reasons, the X server will have to start as root. This can cause security issues and become an"
echo "entry point for malicious elements and privilege escalation. It is essential that you secure your system"
echo "properly against unauthorized access"
echo

if ! consent "I understand"; then
    exit 1
fi
echo
echo -n "The install process can set up and install nodejs and npm for you. Do you want it to do that?"
yes_no 2
if [ $? -eq 1 ] ; then
    INSTALL_NODE=1
fi
echo
echo -n "The install process can also clone and install MagicMirror. Do you want that to happen?"
yes_no 2
if [ $? -eq 1 ] ; then
    INSTALL_MM=1
fi

if [ "$INSTALL_MM" -eq 1 ]; then
    echo
    echo "We can link the configuration and modules directory of MagicMirror into /etc for easy access."
    echo "the /modules and /config directories will be made available in /etc/magicmirror."
    echo -n "Do you want that to happen?"
    yes_no 2
    if [ $? -eq 1 ] ; then
        LINK_CONFIG=1
    fi
    echo
    echo -n "Should we configure systemd to start MM2 automatically?"
    yes_no 2
    if [ $? -eq 1 ] ; then
        AUTOSTART_MM=1
    fi

fi
echo
echo
banner "Summary:"
echo -e "\t We will install a bare-bones X server and configure it to run at startup"
if [[ -v INSTALL_NODE ]]; then echo -e "\t- We will configure nodejs repositories and install node.js and npm"; fi
if [[ -v INSTALL_MM ]]; then echo   -e "\t- We will clone MagicMirror2"; fi
if [[ -v INSTALL_MM && -v INSTALL_NODE ]]; then echo -e "\t- We will install and configure MagicMirror2"; else echo -e "\t- You will need to install MM2 manually after installing node.js"; fi
if [[ -v LINK_CONFIG ]]; then echo  -e "\t- We will link config and modules directory into /etc/magicmirror"; fi
if [[ -v AUTOSTART_MM ]]; then echo -e "\t- We will install a systemd service to start MM2 at startup"; fi
echo
echo Do you want to proceed?
if ! consent "Proceed"; then
    exit 1
fi

#install the necessary software



banner "Installing required system packages"

apt-get install -y --no-install-recommends xserver-xorg-core xserver-xorg-legacy x11-xserver-utils xinit git ca-certificates curl gnupg libatk1.0-0 libatk-bridge2.0-0 libcups2 libgtk-3-0 python3-pip xli





#copy stuff where it needs to be
#TODO xinitrc should probably be in mm-support, but I'm too lazy to re-create the base64 for the unit file AGAIN right now
mkdir -p /usr/local/share/mm-support && \
mkdir /etc/magicmirror && \
cp /tmp/mm-install/xserver.service /usr/local/share/mm-support/xserver.service && \
ln -s /usr/local/share/mm-support/xserver.service /etc/systemd/system/xserver.service && \
cp /tmp/mm-install/xinitrc /usr/local/share/mm-support/xinitrc && \
ln -s  /usr/local/share/mm-support/xinitrc /etc/magicmirror/xinitrc && \
cp /tmp/mm-install/99-vc4.conf /usr/local/share/mm-support/99-vc4.conf
ln -s /usr/local/share/mm-support/99-vc4.conf /etc/X11/xorg.conf.d/99-vc4.conf
echo -e 'allowed_users=rootonly\nneeds_root_rights=no' > /etc/X11/Xwrapper.config && \
systemctl daemon-reload && \
systemctl enable xserver.service && \
echo "Xserver has been installed and configured to run at startup" || \
fatal "Something went wrong installing the Xserver"

# install node and npm on raspbian
if [[ -v INSTALL_NODE ]]; then
  # TODO use nvm instead?
    banner "Installing Node.js"

  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
  apt update && apt install --no-install-recommends -y nodejs && \
  echo "Node.js has been installed" || \
  fatal "Something went wrong installing Node.js"
fi


if [[ -v INSTALL_MM ]]; then
  banner "Installing MagicMirror2"  
  sudo useradd --system --shell /usr/sbin/nologin magicmirror
  mkdir -p /usr/local/share/magicmirror && \
  cd /usr/local/share/magicmirror && \
  git clone https://github.com/MagicMirrorOrg/MagicMirror . && \
  [[ -v INSTALL_NODE ]] && npm run install-mm || \
  warn "You requested not to install node.js, please execute \"cd /usr/local/share/magicmirror && npm run install\" manually after this script completes and nodejs is installed"

  
  if [[  -v LINK_CONFIG ]]; then
    banner "Linking config directories"
    ln -s /usr/local/share/magicmirror/config /etc/magicmirror/config && \
    ln -s /usr/local/share/magicmirror/modules /etc/magicmirror/modules && \
    echo "Config and modules directory have been linked to /etc/magicmirror" ||
    warn "Could not link config directories"
  fi

 

  if [[ -v AUTOSTART_MM ]]; then
     banner "Setting up MagicMirror to start on boot"
     cp /tmp/mm-install/magicmirror.service /usr/local/share/mm-support/magicmirror.service && \
     ln -s /usr/local/share/mm-support/magicmirror.service /etc/systemd/system/magicmirror.service && \
     systemctl daemon-reload && \
     systemctl enable magicmirror.service && \
     echo "MagicMirror2 has been set up to start at boot" || \
     warn "Something went wrong setting up MagicMirror2 to run at startup"

  fi

fi

rm -rf /tmp/mm-install

echo
banner "Install is done. System is ready to use."
echo -e "Your remaining chores:"
if [[ ! -v INSTALL_NODE ]]; then echo -e "\t- Install node.js"; fi
if [[ ! -v INSTALL_MM ]]; then echo -e "\t- Download MagicMirror2"; fi
if [[ -v INSTALL_MM && ! -v INSTALL_NODE ]]; then echo -e "\t- Install MM"; fi
echo -e "\t- Install whatever modules you like"
echo -e "\t- Create a magicmirror configuration"
echo -e "\t- Reboot your system"
echo
echo Enjoy!

