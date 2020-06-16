# 树莓派安装Minecraft 1.15.2 PC版服务器
这个Minecraft PC版服务器是采用PaperMC，是目前最好的MC服务器。  
我在SetupMinecraft.sh里增加了检测和显示最新PaperMC版本，也汉化了里面显示的文字。

影片教程: [点这里](https://youtu.be/SZJCu7h-YQk)

安装步骤指令(Command):  
1) wget -O SetupMinecraft.sh https://raw.githubusercontent.com/laomingOfficial/RaspberryPiMinecraft/master/SetupMinecraft.sh
2) chmod +x SetupMinecraft.sh
3) ./SetupMinecraft.sh

Service服务指令:  
```
# 重载所有修改过的配置文件
sudo systemctl daemon-reload

# 启动服务
sudo systemctl start minecraft

# 将服务设置为开机启动
sudo systemctl enable minecraft

# 停止运行服务
sudo systemctl stop minecraft

# 将服务设置为禁止开机启动
sudo systemctl disable minecraft

# 检测服务状态
sudo systemctl status minecraft
```

PaperMC: [https://papermc.io/](https://papermc.io/)

这个repo是从以下2个repo fork过来滴，感谢  
[https://github.com/mtoensing/RaspberryPiMinecraft](https://github.com/mtoensing/RaspberryPiMinecraft)  
[https://github.com/TheRemote/RaspberryPiMinecraft](https://github.com/TheRemote/RaspberryPiMinecraft)
