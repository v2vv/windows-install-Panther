@echo off
::chcp 65001


echo EFI 引导卷为 %efiDriver%
echo Windows 安装卷为 %imageDriver%
echo wim 文件路径为 %wimPath%
echo driver 文件路径为 %importDriverPath%
echo unattend 文件路径为 %unattendPath%
echo Microsoft.UI.Xaml.2.8 文件路径为 %MicrosoftUIXamlPath%
echo 是否重建引导文件 (0:不重建 1:重建) 值:%rebuildEFI%
echo 引导文件重建是否保存原有系统引导 (0:不保留 1:保留) 值: %otherBOOT%
echo 完成后关机 (0:不重启 1:重启) 值: %reboot%
echo 是否添加驱动 (0:不添加 1:添加) 值: %addDriver%
echo 是否添加无人值守 (0:不添加 1:添加) 值: %addAttend%
echo 是否安装 Microsoft.UI.Xaml.2.8 apx (0:不安装 1:安装) 值: %addMicrosoftUIXaml%

::格式化硬盘
echo 正在格式化硬盘 %imageDriver%
echo select VOLUME %imageDriver% >temp.txt
echo format fs=ntfs quick OVERRIDE >>temp.txt
diskpart /s temp.txt 
del temp.txt

::安装镜像
dism /Apply-Image /ImageFile:"%wimPath%" /Index:3 /ApplyDir:%imageDriver%\

::添加驱动
if %addDriver%==1 (
    dism /Image:%imageDriver%\ /Add-Driver /Driver:%importDriverPath% /recurse 
)

:: 添加无人值守应答文件
if %addAttend%==1 (
	::dism /Image:%imageDriver%\  /Apply-Unattend:"%unattendPath%"
	xcopy /E /Y "%unattendPath%" "%imageDriver%\Windows\Panther\"
)

:: 添加 Microsoft.UI.Xaml.2.8 appx 软件包
if %addMicrosoftUIXaml%==1 (
    dism /Image:%imageDriver%\ /Add-ProvisionedAppxPackage /PackagePath:%MicrosoftUIXamlPath% /SkipLicense
)

::重建 EFI 引导
if %rebuildEFI%==1 (
    echo 正在重建 EFI 引导
    if %otherBOOT%==0 (
        ::正在删除原有引导文件
        echo 正在删除原有引导文件
        rmdir /s /q %efiDriver%\EFI
    )
    bcdboot %imageDriver%\windows /s %efiDriver% /f uefi /l zh-cn
)

:: 重启
if %reboot%==1 (
    echo 30s 后重启
    TIMEOUT /T 30 /NOBREAK
    shutdown /r /t 0
)



