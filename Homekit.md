# Add Apple Homekit to Node-Red
Installation instructions for adding Apple HomeKit support to Node-Red on the UCM/Pi

## Getting Started

To get started, you will need to have completed the [Quick Start](Quick%20Start.md) process and have logged in to a shell either via SSH or using a keyboard and monitor plugged into the UCM/Pi

## Installing Apple HomeKit Support.

Apple HomeKit support is via a [community managed node-red module](https://github.com/NRCHKB/node-red-contrib-homekit-bridged).

To install it, go to the command line and execute the following commands:

```
cd ~/.node-red
npm install NRCHKB/node-red-contrib-homekit-bridged
pm2 restart node red
```
 
If you want to make use of the RTSP streaming capability, you will also need some other optional components as below
```

# install build tools
cd ~
sudo apt-get install git pkg-config autoconf automake libtool libx264-dev

# download and build fdk-aac
git clone https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
./autogen.sh
./configure --prefix=/usr/local --enable-shared --enable-static
make -j4
sudo make install
sudo ldconfig
cd ..

# download and build ffmpeg
git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
./configure --prefix=/usr/local --arch=armel --target-os=linux --enable-omx-rpi --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-mmal --enable-libx264 --enable-decoder=h264 --enable-network --enable-protocol=tcp --enable-demuxer=rtsp
make -j4
sudo make install
https://github.com/NRCHKB/node-red-contrib-homekit-bridged
```

