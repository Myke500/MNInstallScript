#/bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=6

COINNAME="PRiVCY Tip Bot"
COINGITHUB="https://github.com/boyroywax/BOXYBotTEST.git"
COINGITFOLDER=BOXYBotTEST
GITBRANCH=privcy
COINCONFIGSRC="https://raw.githubusercontent.com/boyroywax/tbconfig.git"
SWAPSIZE=4000
UBUNTUVERSION=18.04

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
   sleep 3
    if [[ `cat /etc/issue.net`  == *$UBUNTUVERSION* ]]; then
        echo -e "${GREEN}* You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
    else
        echo -e "${RED}* You are not running Ubuntu 16.04.X. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

updateAndUpgrade() {
    echo
    echo "[2/${MAX}] Running update and upgrade. Please wait..."
    sleep 3
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

installSwap() {
    echo
    echo -e "[3/${MAX}] Installing SwapFile. Please wait..."
    sleep 3
    sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=$SWAPSIZE > /dev/null 2>&1
    sudo mkswap /var/swap.img > /dev/null 2>&1
    sudo swapon /var/swap.img > /dev/null 2>&1
    sudo chmod 0600 /var/swap.img > /dev/null 2>&1
    sudo chown root:root /var/swap.img > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installMysql() {
    echo
    echo -e "[4/${MAX}] Installing Mysql. Please wait..."
    sleep 3
    sudo apt-get install mysql-server -y
    mysql_secure_installation
    systemctl status mysql.service
}

configMysql() {
   sudo mysql
   echo -e "${BOLD}"
   read -p "Enter you Mysql root password: " responsepass
   echo -e "${NONE}"
   ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$responsepass';
   FLUSH PRIVILEGES;
   quit;
   echo -e "${NONE}${GREEN}* Done${NONE}";
}

installPython() {
    echo
    echo -e "[5/${MAX}] Installing Python and Pip. Please wait..."
    sleep 3
    sudo add-apt-repository ppa:jonathonf/python-3.6 -qq -y > /dev/null 2>&1
    sudo apt update -qq -y > /dev/null 2>&1
    sudo apt-get install python3.6 -qq -y > /dev/null 2>&1
    sudo apt-get install python3.6-dev -qq -y > /dev/null 2>&1
    sudo apt-get install python3.6-venv -qq -y > /dev/null 2>&1
    sudo apt-get install software-properties-common -qq -y > /dev/null 2>&1
    wget https://bootstrap.pypa.io/get-pip.py > /dev/null 2>&1
    sudo python3.6 get-pip.py > /dev/null 2>&1
    sudo ln -s /usr/bin/python3.6 /usr/local/bin/python3 > /dev/null 2>&1
    python3 -m pip install -U discord.py > /dev/null 2>&1
    pip install PyMySQL -y  > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installTipbot() {
    echo
    echo -e "loading config.json."
    sleep 3
    git clone $COINGITHUB -b $GITBRANCH > /dev/null 2>&1
    git config --global credential.helper cache
    git clone $COINCONFIGSRC -b $GITBRANCH > /dev/null 2>&1
    rm ~/$COINGITFOLDER/config.json > /dev/null 2>&1
    cd ~/tbconfig/ > /dev/null 2>&1
    cp config.json.$GITBRANCH ~/$COINGITFOLDER/config.json > /dev/null 2>&1
    cd .. > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}


clear
cd

echo
echo -e "-----------------------------------------------------------------------------"
echo -e "|                                                                           |"
echo -e "|   ${BOLD}----- $COINNAME Ubuntu Install script -----${NONE}               |"
echo -e "|                                                                           |"
echo -e "|           ${CYAN}__________ ________  ____  ________.___.${NONE}          |" 
echo -e "|           ${CYAN}\______   \\_____  \ \   \/  /\__  |   |${NONE}          |"                   
echo -e "|           ${CYAN} |    |  _/ /   |   \ \     /  /   |   |${NONE}          |"
echo -e "|           ${CYAN} |    |   \/    |    \/     \  \____   | ${NONE}          |"
echo -e "|           ${CYAN} |______  /\_______  /___/\  \ / ______|${NONE}          |"
echo -e "|           ${CYAN}        \/         \/      \_/ \/       ${NONE}          |"
echo -e "|                                                                           |"
echo -e "-----------------------------------------------------------------------------"

echo -e "${BOLD}"
read -p "This script will setup your $COINNAME Ubuntu $UBUNTUVERSION Wallet (CommandLine Only). Do you wish to continue? (y/n)? " response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    checkForUbuntuVersion
    updateAndUpgrade
    installSwap
    installMysql
    configMysql
    installPython
    installTipbot

    echo
    echo -e "${BOLD}Your $COINNAME Wallet is Installed${NONE}".
    echo -e "${BOLD}Happy STAKING¡¡¡¡.${NONE}".
    echo 
    echo -e "${CYAN}Script By SoyBtc - Modified by lowerj${NONE}".
    echo
    else
    echo && echo "Installation cancelled" && echo
fi
