apt -y update
apt -y upgrade
sudo apt install wget gnupg software-properties-common
wget https://packages.ntop.org/apt/20.04/all/apt-ntop.deb
sudo dpkg -i apt-ntop.deb
sudo apt install pfring-dkms nprobe ntopng n2disk cento
echo -i=2 | sudo tee /etc/ntopng/ntopng.conf
echo -w=3000 | sudo tee /etc/ntopng/ntopng.conf
sudo systemctl start ntopng
sudo systemctl enable ntopng
echo ntopng should be available at: http://0.0.0.0:3000
echo default admin login is: admin / admin