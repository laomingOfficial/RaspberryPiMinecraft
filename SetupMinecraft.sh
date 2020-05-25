#!/bin/bash
# Original Minecraft Server Installation Script - James A. Chambers - https://www.jamesachambers.com.
# Changes and simplifications by Marc Tönsing
# V1.1 - Dec 15th 2019 https://github.com/mtoensing/RaspberryPiMinecraft
# V1.9 - May 23th 2020 老明 https://github.com/laomingOfficial/RaspberryPiMinecraft

echo "Minecraft Server installation script by James Chambers, Marc Tönsing & 老明 - V1.9"
echo "Latest version always at https://github.com/laomingOfficial/RaspberryPiMinecraft"

# 读取total内存
Get_ServerMemory(){
	TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
	AvailableMemory=$(awk '/MemAvailable/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
	echo "Total memory: $TotalMemory - Available Memory: $AvailableMemory"
	
	if [ $TotalMemory -lt 3000 ]; then
		echo "树莓派内存低于3GB，自动设置Minecraft最高内存为800MB"
		MemSelected=800
	else
		echo "树莓派内存高于3GB，自动设置Minecraft最高内存为2600MB"
		MemSelected=2600
	fi
}

# 更新脚本
Update_Scripts() {
	# 移除全部脚本
	rm minecraft/start.sh minecraft/stop.sh minecraft/restart.sh
	
	# 下载start.sh
	echo "下载start.sh ..."
	wget -O start.sh https://raw.githubusercontent.com/laomingOfficial/RaspberryPiMinecraft/master/start.sh
	chmod +x start.sh
	sed -i "s:memselect:$MemSelected:g" start.sh
	
	# 下载stop.sh
	echo "下载stop.sh ..."
	wget -O stop.sh https://raw.githubusercontent.com/laomingOfficial/RaspberryPiMinecraft/master/stop.sh
	chmod +x stop.sh
	sed -i "s:dirname:$DirName:g" stop.sh

	# 下载restart.sh
	echo "下载restart.sh ..."
	wget -O restart.sh https://raw.githubusercontent.com/laomingOfficial/RaspberryPiMinecraft/master/restart.sh
	chmod +x restart.sh
}

Read_LatestMCVersion() {
	response=$(curl -s https://papermc.io/api/v1/paper)
	temp=${response#*'"versions":["'}
	latestVersion=${temp%%'"'*}
}

Update_LatestMC() {
	echo "开始下载Paper Minecraft server V${latestVersion}"
	wget -q -O /home/pi/minecraft/paperclip.jar https://papermc.io/api/v1/paper/${latestVersion}/latest/download
	echo "下载好啦"
}

Get_ServerMemory
Read_LatestMCVersion

# 如果文件夹存在，更新最新脚本
if [ -d "minecraft" ]; then
	echo "Minecraft文件夹存在"
	echo "如果要继续更新V${latestVersion}吗(minecraft会自动关闭)？ (y/n)"
	
	read answer
	
	if [ "$answer" != "${answer#[Yy]}" ]; then
		if screen -list | grep -q "minecraft"; then
			screen -Rd minecraft -X stuff "stop $(printf '\r')"
			sleep 15s
			echo "Minecraft服务器已关闭。"
			break
		fi
	
		Update_LatestMC
		Update_Scripts
		
		echo "Minecraft脚本更新好啦... .____."
	fi
	
	exit 0
fi

echo "重新获取软件包列表 。。。"
sudo apt-get update

echo "安装Java OpenJDK 11。。。"
sudo apt-get install openjdk-11-jre-headless -y

echo "安装screen。。。 "
sudo apt-get install screen -y

echo "创建minecraft服务器文件夹。。。"
mkdir minecraft
cd minecraft

Update_LatestMC

echo "构建Minecraft服务器。。。 "
java -jar -Xms800M -Xmx800M paperclip.jar

echo "接受EULA。。。 "
echo eula=true > eula.txt

Update_Scripts

echo "输入你的Minecraft服务器名称 "
read -p '服务器名称: ' servername
echo "server-name=$servername" >> server.properties
echo "motd=$servername" >> server.properties

echo "服务器设置完成。进入minecraft服务器目录，然后输入./start.sh 开启服务器"
echo "如果要开放外网的话，记得在路由器设置端口转发(port forwarding)，端口: 25565"
