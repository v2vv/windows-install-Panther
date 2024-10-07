@echo off
:: EFI 卷符
set efiDriver=H:
:: Windows 卷符
set imageDriver=G:
:: wim Image 路径
set wimPath=.\wim\win11-2024-10.wim
::选择安装系统版本索引
set wimIndex=5
:: 驱动程序目录
set importDriverPath=.\driver\导出
:: 无人值守应答路径
set unattendPath=.\Panther\unattend.xml
:: Microsoft.UI.Xaml 路径
set MicrosoftUIXamlPath=.\appx\Microsoft.UI.Xaml.2.8.x64.appx
::是否格式化(0:不格式化 1:格式化)
set format=1
::是否安装镜像 (0:不安装 1:安装)
set installImage=1
::是否更新引导文件 (0:不重建 1:重建)
set rebuildEFI=1
::引导文件更新是否保存原有系统引导 (0:不保留 1:保留）
set otherBOOT=0
:: 完成后重启 (0:不重启 1:重启)
set reboot=1
::是否添加驱动  (0:不添加 1:添加) 
set addDriver=1
::是否添加无人值守 (0:不添加 1:添加) 
set addAttend=1
::是否安装 Microsoft.UI.Xaml.2.8 apx (0:不安装 1:安装) 
set addMicrosoftUIXaml=1