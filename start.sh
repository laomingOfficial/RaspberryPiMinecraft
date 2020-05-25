#!/bin/bash
# James Chambers - V1.0 - March 24th 2018
# Marc Tönsing - V1.2 - September 16th 2019
# 老明 - V1.9 - May 23th 2020
# Minecraft Server startup script using screen
echo "Starting Minecraft server.  To view window type screen -r minecraft."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"
cd /home/pi/minecraft/
/usr/bin/screen -dmS minecraft /usr/bin/java -jar -Xms400M -XmxmemselectM /home/pi/minecraft/paperclip.jar
