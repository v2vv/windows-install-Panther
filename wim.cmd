::chcp 65001
@echo off

echo.
echo --- 1. ������־�ļ��� ---
echo ��־�ļ��� .\log
md .\log

echo.
echo --- 2. �������� ---
echo �����ļ�: .\configs\default.cmd
call .\configs\default.cmd

echo.
echo --- 3. ִ�а�װ�ű� ---
echo �ű��ļ�: .\script\wim.cmd
.\script\wim.cmd |.\tools\tee  .\log\log.txt

echo.
echo --- 4. ������װ�ű� ---
pause

