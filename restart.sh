#!/bin/sh
# James Chambers - V1.0 - March 24th 2018
# Marc Tönsing - V1.1 - May 18th 2018
# 老明 - V1.9 - May 23th 2020

# Check if server is running
if ! screen -list | grep -q "minecraft"; then
	echo "Minecraft服务器没在运行!"
	exit 1
fi

echo "关闭服务器，30秒倒数。。。"
screen -Rd minecraft -X stuff "say Server is restarting in 30 seconds! $(printf '\r')"
sleep 23s
screen -Rd minecraft -X stuff "say Server is restarting in 7 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 6 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 5 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 4 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 3 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 2 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 1 second! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Closing server...$(printf '\r')"
screen -Rd minecraft -X stuff "stop $(printf '\r')"

# 等待30秒确保服务器已关闭
echo "检查服务器是否已关闭。。。"
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "minecraft"; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done

echo "服务器已关闭。"
echo "重启。"
sudo reboot
