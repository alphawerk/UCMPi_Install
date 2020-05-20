curl -sSL https://get.docker.com | sh


sudo usermod -aG docker pi

mkdir ~/alphawerk/homeassistant

docker run --init -d --name="home-assistant"  -v /home/pi/alphawerk/homeassistant:/config -v /etc/timezone:/etc/timezone --net=host homeassistant/raspberrypi3-homeassistant:stable

