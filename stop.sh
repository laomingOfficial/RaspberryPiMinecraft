#!/bin/bash
# James Chambers - December 20th 2019
# 老明 - V1.9 - May 23th 2020

# Check if server is running
if ! screen -list | grep -q "minecraft"; then
  echo "Minecraft服务器没在运行!"
  exit 1
fi

# Stop the server
echo "关闭服务器。。。"
screen -Rd minecraft -X stuff "say Closing server (stop.sh called)...$(printf '\r')"
screen -Rd minecraft -X stuff "stop$(printf '\r')"

# Wait up to 30 seconds for server to close
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "minecraft"; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done

# Force quit if server is still open
if screen -list | grep -q "minecraft"; then
  echo "30秒了Minecraft服务器还没关闭，直接关闭screen"
  screen -S minecraft -X quit
fi

echo "Minecraft服务器已关闭。"

# Sync all filesystem changes out of temporary RAM
sync