::chcp 65001
@echo off

echo ��������
.\configs\default.cmd

echo ������־�ļ�
md .\log

echo ��ʼִ�а�װ�ű�
.\script\wim.cmd |.\tools\tee  .\log\log.txt

echo ��װ�ű�����
pause

