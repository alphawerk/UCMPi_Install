#!/bin/bash
# Quickstart Script for UCM/Pi Node-Red Installation
# (c) 2019 alphaWerk Ltd

SCRIPTVERSION=1.1.1.3
NODEVERSION=v10.16.0
DISTRO="linux-$(uname -m)"
LOCALIP="$(hostname -I | xargs)"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
error_exit()
{
	echo -e "${RED}An error occurred, cancelling operation"
	echo -e "please report this error to matt.brain@alphawerk.co.uk including the output above and error message(s) below${NC}"
	echo -e "script version ${SCRIPTVERSION}"
	echo -e "$1" 1>&2
	exit 0
}

error_warn()
{
	echo -e "${RED}A warning was raised, but it isn't terminal${NC}"
	echo -e "$1" 1>&2
}

no_npm()
{
	echo -e "${GREEN}installing NPM{NC}"
	#sudo apt install npm || error_exit "Unable to install NPM"
}

echo -e "${GREEN}Starting QuickStart for UCM/Pi Node-Red Installation${NC}"
echo -e "${GREEN}Distro ${DISTRO} Script Version ${SCRIPTVERSION} Local IP ${LOCALIP}"
echo -e "${GREEN}Updating package manager${NC}"
sudo apt update -y --allow-releaseinfo-change || error_exit "Unable to update package manager"

echo -e "${GREEN}Upgrading O/S ${NC}"
sudo apt-get upgrade -qq -y || error_exit "Unable to update package manager"

echo -e "${GREEN}Installing node.js${NC}"
cd ~ || error_exit "Unable to change to home directory"

echo -e "${GREEN} downloading node.js${NC}"
curl -o node_source.tar.xz https://nodejs.org/dist/$NODEVERSION/node-$NODEVERSION-$DISTRO.tar.xz || error_exit "Unable to download node package"
sudo mkdir -p /usr/local/lib/nodejs || error_exit "Unable to create destination dir"

echo -e "${GREEN} unpacking node.js${NC}"
sudo tar -xJf node_source.tar.xz -C /usr/local/lib/nodejs || error_exit "Unable to untar node into place"

echo -e "${GREEN} setting up node.js environment${NC}"
if test -h /usr/bin/node; then
	sudo rm /usr/bin/node || error_exit "Unable to remove old /usr/bin/node symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/node /usr/bin/node || error_exit "Unable to create symlink for node"

if test -h /usr/bin/npm; then
	sudo rm /usr/bin/npm || error_exit "Unable to remove old /usr/bin/npm symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/npm /usr/bin/npm || error_exit "Unable to create symlink for npm"

if test -h /usr/bin/npx; then
	sudo rm /usr/bin/npx || error_exit "Unable to remove old /usr/bin/npx symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/npx /usr/bin/npx || error_exit "Unable to create symlink for npx"

if test -h /usr/lib/node_modules; then
	sudo rm /usr/lib/node_modules || error_exit "Unable to remove old /usr/lib/node_modules symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/lib/node_modules /usr/lib/node_modules || error_exit "Unable to create symlink for libs"

#if grep -q
#echo -e "NODEVERSION=$NODEVERSION\nDISTRO=$DISTRO\nexport PATH=/usr/local/lib/nodejs/node-\$NODEVERSION-\$DISTRO/bin:\$PATH" >> ~/.profile
#export PATH=/usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin:$PATH
echo -e "${GREEN} cleaning up${NC}"

rm node_source.tar.xz

echo -e "${GREEN} checking for node or npm${NC}"
node -v || error_exit "Failed to install node.js"
npm -v  || error_exit "Failed tocd / install npm"

echo -e "${GREEN}Installing build tools${NC}"
sudo apt-get install -qq -y gcc g++ make > /dev/null 2>&1 || error_exit "Unable to install node.js or other dependancies"

echo -e "${GREEN}Installing Yarn${NC}"
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - > /dev/null 2>&1|| error_exit "Unable to add Yarn public key to repository"
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list || error_exit "Unable to set Yarn repository"
sudo apt-get update -qq -y && sudo apt-get install -qq -y yarn --no-install-recommends || error_exit "Unable to install Yarn"

echo -e "${GREEN}Installing libavahi${NC}"
sudo apt-get install -qq -y libavahi-compat-libdnssd-dev > /dev/null 2>&1 || error_exit "Unable to install libavahi"



echo -e "${GREEN}Installing pm2${NC}"
sudo npm install --silent -g pm2 || error_exit "Unable to install pm2"

if test -h /usr/bin/pm2; then
	sudo rm /usr/bin/pm2 || error_exit "Unable to remove old /usr/bin/pm2 symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/pm2 /usr/bin/pm2 || error_exit "Unable to create symlink for pm2"


echo -e "${GREEN}configuring pm2${NC}"
#sudo pm2 startup || error_exit "Unable to configure pm2 to start at boot"
pm2 startup | tail -1 | sudo -E bash - > /dev/null 2>&1 || error_exit "Unable to configure pm2 to start at boot"

echo -e "${GREEN}Installing Node-Red${NC}"
sudo npm install --silent -g --unsafe-perm node-red@0.19.4 > /dev/null 2>&1 || error_exit "Unable to install node-red"
sudo npm install --silent -g mqtt > /dev/null 2>&1 || error_exit "Unable to install mqtt"

if test -h /usr/bin/node-red; then
	sudo rm /usr/bin/node-red || error_exit "Unable to remove old /usr/bin/node-red symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/node-red /usr/bin/node-red || error_warn "Unable to create symlink for node-red"

if test -h /usr/bin/node-red-pi; then
	sudo rm /usr/bin/node-red-pi || error_exit "Unable to remove old /usr/bin/node-red symlink"
fi
sudo ln -s /usr/local/lib/nodejs/node-$NODEVERSION-$DISTRO/bin/node-red-pi /usr/bin/node-red-pi || error_exit "Unable to create symlink for node-red-pi"

echo -e "${GREEN}Preparing Destination Environment ${NC}"
if test ! -d ~/alphawerk; then
	mkdir ~/alphawerk || error_exit "Unable to create alphawerk home directory"
fi
if test ! -d ~/alphawerk/update; then
	mkdir ~/alphawerk/update || error_exit "Unable to create update directory"
fi

if test -d ~/alphawerk/node_modules; then
	rm -r ~/alphawerk/node_modules || error_exit "Unable to remove old node_modules directory"
	if test -f ~/alphawerk/package.json; then
		sudo rm ~/alphawerk/package.json || error_exit "Unable to remove old package.json"
	fi
	if test -f ~/alphawerk/package.json; then
		sudo rm ~/alphawerk/package-lock.json || error_exit "Unable to remove old package.json"
	fi
fi

if test ! -d /etc/alphawerk; then
	sudo mkdir /etc/alphawerk || error_exit "Unable to create alphawerk config directory"
fi
sudo chown pi:pi /etc/alphawerk || error_exit "Unable to change ownership of alphawerk config directory"
if test ! -d /etc/alphawerk/core; then
	mkdir /etc/alphawerk/core || error_exit "Unable to create alphawerk/core config directory"
fi

curl -sL https://uhai.alphawerk.co.uk/scripts/config.json > /etc/alphawerk/core/config.json || error_exit "Unable to download config.json"
cd ~/alphawerk || error_exit "Unable to change to alphawerk home directory"

if test ! -d /usr/lib/node_modules/node-red/nodes/alphawerk; then
	sudo mkdir /usr/lib/node_modules/node-red/nodes/alphawerk || error_exit "Unable to create cytech node directory"
fi

echo -e "${GREEN}Installing dependancies ${NC}"
npm install epoll mqtt serialport mitt xml2js bcrypt express express-ws express-handlebars@3.0.0 express-handlebars-layouts express-session memorystore body-parser cookie-parser request express-fileupload xml2js fs-extra path uid-safe https rpi-gpio os child_process > /dev/null 2>&1|| error_exit "Error installing dependancies"

echo -e "${GREEN}Installing mosquitto ${NC}"
sudo apt-get install -qq -y mosquitto > /dev/null 2>&1|| error_exit "Unable to install mosquitto"
if test -f /etc/mosquitto/conf.d/localhost.conf; then
	sudo rm /etc/mosquitto/conf.d/localhost.conf || error_exit "Unable to delete old mosquitto configuration"
fi
sudo service mosquitto start || error_exit "Unable to start mosquitto"
echo "bind_address localhost" | sudo tee /etc/mosquitto/conf.d/localhost.conf > /dev/null 2>&1|| error_exit "Unable to write mosquitto configuration"
sudo service mosquitto restart || error_exit "Unable to restart mosquitto"

echo -e "${GREEN}Installing Cytech Modules ${NC}"
echo -e "${GREEN}Getting Packages Cytech Modules ${NC}"
cd update  || error_exit "Cannot cd to ~/alphawerk/update, Aborting"
wget --quiet https://uhai.alphawerk.co.uk/scripts/core_1.1.0.tar.gz || error_exit "Cannot get core_1.1.0.tar.gz, Aborting"
wget --quiet https://uhai.alphawerk.co.uk/scripts/node-red-home_1.1.0.tar.gz || error_exit "Cannot get node-red-home_1.1.0.tar.gz, Aborting"
wget --quiet https://uhai.alphawerk.co.uk/scripts/node-red_1.1.0.tar.gz || error_exit "Cannot get node-red_1.1.0.tar.gz, Aborting"

echo -e "${GREEN}Copying components into place ${NC}"

tar -xf core_1.1.0.tar.gz -C ~ || error_exit "Cannot untar core_1.1.0.tar.gz to destination, Aborting"
tar -xf node-red-home_1.1.0.tar.gz -C ~ || error_exit "Cannot untar node-red-home_1.1.0.tar.gz to destination, Aborting"
sudo tar -xf node-red_1.1.0.tar.gz -C /usr/lib/node_modules || error_exit "Cannot untar node-red_1.1.0.tar.gz to destination, Aborting"

echo -e "${GREEN}Cleaning up ${NC}"
rm core_1.1.0.tar.gz || error_exit "Unable to remove tar"
rm node-red-home_1.1.0.tar.gz || error_exit "Unable to remove tar"
rm node-red_1.1.0.tar.gz || error_exit "Unable to remove tar"

echo -e "${GREEN}Installing Node-Red Modules${NC}"
pm2 start node-red
sleep 10
cd ~/.node-red || error_exit "Unable to change directory to ~/.node-red"
npm install --save --silent node-red-dashboard || error_exit "Unable to install node-red-dashboard"

echo -e "${GREEN}Starting Components ${NC}"
cd ~/alphawerk || error_exit "Unable to change to home dir"
pm2 stop all || error_warn "Unable to stop existing components"
pm2 start core.js logger.js configuration.js UCMEth.js netserver.js manager.js node-red || error_exit "Unable to start components"
#pm2 list
pm2 save  || error_exit "Unable to save pm2 start up script"

touch ~/alphawerk/QuickStart$SCRIPTVERSION || error_warn "Unable to write script marker"
echo -e "${RED}All Done!!"
echo -e "${GREEN}You may now connect to HTTP:${LOCALIP}:1080 to access the management console and HTTP://${LOCALIP}:1880 to access Node-Red ${NC}"
echo -e "${GREEN}You will need to create a user account in the management console before accessing Node-Red ${NC}"
exit 0
