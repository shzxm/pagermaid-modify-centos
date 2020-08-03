#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
if [[ $EUID -ne 0 ]]; then
    clear
    echo "Error: This script must be run as root!" 1>&2
    exit 1
fi
clear
echo "        Auto install PagerMaid--Modif(centos7)         "
echo "                                                       "
echo "   .__             .  .      .     .  .     . ._       "
echo "   [__) _. _  _ ._.|\/| _.* _| ___ |\/| _  _|*|,  .    "
echo "   |   (_](_](/,[  |  |(_]|(_]     |  |(_)(_]|| \_|    "
echo "          ._|                                   ._|    "
echo "                                                       "
echo "        Thanks: KLDGodY                                "
echo "        Thanks: mcnb.top/yum.sh                        "
echo "                                                       "
while true; do
    read -p "Do you wish to install this program?(y/n)" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
yum update -y
yum upgrade -y
yum install wget nano zip unzip git yum-utils screen -y
yum install epel-release -y
wget -T 2 -O /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
yum install python-devel python3-devel python python-pip python3 python3-pip gcc gcc-c++ zbar zbar-devel make ImageMagick neofetch -y
yum groupinstall "Development Tools" -y
yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/CentOS_7/
sudo rpm --import https://build.opensuse.org/projects/home:Alexander_Pozdnyakov/public_key
yum update
yum install tesseract tesseract-langpack-chi-sim tesseract-langpack-eng figlet -y
cd /root
git clone https://github.com/xtaodada/PagerMaid-Modify.git && cd PagerMaid-Modify
pip3 install --upgrade pip
pip3 install -r requirements.txt
cp config.gen.yml config.yml
echo -n "Please enter App api_id  (my.telegram.org):"
read api_id
echo "Writting App api_id..."
sed -i -e 's/api_key\: \"ID_HERE\"/api_key\: \"'${api_id}'\"/g' config.yml
echo "Please enter App api_hash   (my.telegram.org):"
read api_hash
echo "Writting App api_hash..."
sed -i -e 's/api_hash\: \"HASH_HERE\"/api_hash\: \"'${api_hash}'\"/g' config.yml
screen -dmS userbot
screen -x -S userbot -p 0 -X stuff "cd /root/PagerMaid-Modify && python3 -m pagermaid"
screen -x -S userbot -p 0 -X stuff $'\n'
read -p "请输入您的 Telegram 手机号码: " phonenum
screen -x -S userbot -p 0 -X stuff "$phonenum"
screen -x -S userbot -p 0 -X stuff $'\n'
read -p "请输入您的登录验证码: " checknum
screen -x -S userbot -p 0 -X stuff "$checknum"
screen -x -S userbot -p 0 -X stuff $'\n'
read -p "您是否有二次登录验证码(y或n): " choi
if [ "$choi" == "y" ]; then
	read -p "请输入您的二次登录验证码: " twotimepwd
	screen -x -S userbot -p 0 -X stuff "$twotimepwd"
	screen -x -S userbot -p 0 -X stuff $'\n'
fi
cd /etc/systemd/system/
echo "[Unit]
Description=PagerMaid-Modify telegram utility daemon
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
WorkingDirectory=/root/PagerMaid-Modify
ExecStart=/usr/bin/python3 -m pagermaid
Restart=always
">pagermaid.service
chmod 755 pagermaid.service
systemctl daemon-reload
systemctl start pagermaid
systemctl enable pagermaid
echo "PagerMaid 已经安装完毕 在telegram对话框中输入 -help 并发送查看帮助列表"