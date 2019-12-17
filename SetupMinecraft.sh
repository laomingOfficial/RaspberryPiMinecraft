#!/bin/bash
# Original Minecraft Server Installation Script - James A. Chambers - https://www.jamesachambers.com.
# Changes and simplifications by Marc Tönsing
# V1.1 - Dec 15th 2019
# GitHub Repository: https://github.com/mtoensing/RaspberryPiMinecraft

echo "Minecraft Server installation script by James Chambers and Marc Tönsing - V1.0"
echo "Latest version always at https://github.com/mtoensing/RaspberryPiMinecraft"

if [ -d "minecraft" ]; then
  echo "Directory minecraft already exists!  Exiting... "
  exit 1
fi

echo "Updating packages..."
sudo apt-get update

echo "Installing latest Java OpenJDK 11..."
sudo apt-get install openjdk-11-jre-headless -y

echo "Installing screen... "
sudo apt-get install screen -y

echo "Creating minecraft server directory..."
mkdir minecraft
cd minecraft

echo "Getting latest Paper Minecraft server..."
wget -O paperclip.jar https://papermc.io/api/v1/paper/1.15/latest/download

echo "Building the Minecraft server... "
java -jar -Xms800M -Xmx800M paperclip.jar

echo "Accepting the EULA... "
echo eula=true > eula.txt

echo "Grabbing start.sh from repository... "
wget -O start.sh https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraft/master/start.sh
chmod +x start.sh

echo "Oh wait. Checking for total memory available..."
TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
if [ $TotalMemory -lt 3000 ]; then
  echo "Sorry, have to grab low spec start.sh from repository... "
  wget -O start.sh https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraft/master/start_lowspec.sh
fi

echo "Grabbing restart.sh from repository... "
wget -O restart.sh https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraft/master/restart.sh
chmod +x restart.sh

echo "Enter a name for your server "
read -p 'Server Name: ' servername
echo "server-name=$servername" >> server.properties
echo "motd=$servername" >> server.properties

echo "Setup is complete. To run the server go to the minecraft directory and type ./start.sh"
echo "Don't forget to set up port forwarding on your router. The default port is 25565"
