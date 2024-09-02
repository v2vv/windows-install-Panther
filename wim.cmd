::chcp 65001
@echo off

echo.
echo --- 1. 创建日志文件夹 ---
echo 日志文件夹 .\log
md .\log

echo.
echo --- 2. 加载配置 ---
echo 配置文件: .\configs\default.cmd
call .\configs\default.cmd

echo.
echo --- 3. 执行安装脚本 ---
echo 脚本文件: .\script\wim.cmd
.\script\wim.cmd |.\tools\tee  .\log\log.txt

echo.
echo --- 4. 结束安装脚本 ---
pause

