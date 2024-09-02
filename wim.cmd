::chcp 65001
@echo off

echo 加载配置
.\configs\default.cmd

echo 创建日志文件
md .\log

echo 开始执行安装脚本
.\script\wim.cmd |.\tools\tee  .\log\log.txt

echo 安装脚本结束
pause

