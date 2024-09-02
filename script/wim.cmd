@echo off
::chcp 65001
echo.
echo ------ 安装信息 -----
echo EFI 引导卷为 %efiDriver%
echo Windows 安装卷为 %imageDriver%
echo wim 文件路径为 %wimPath%
echo driver 文件路径为 %importDriverPath%
echo unattend 文件路径为 %unattendPath%
echo Microsoft.UI.Xaml.2.8 文件路径为 %MicrosoftUIXamlPath%
echo 是否格式化(0:不格式化 1:格式化) 值: %format%
echo 是否安装镜像 (0:不安装 1:安装) 值: %installImage%
echo 是否更新引导文件 (0:不重建 1:重建) 值:%rebuildEFI%
echo 引导文件更新是否保存原有系统引导 (0:不保留 1:保留) 值: %otherBOOT%
echo 完成后关机 (0:不重启 1:重启) 值: %reboot%
echo 是否添加驱动 (0:不添加 1:添加) 值: %addDriver%
echo 是否添加无人值守 (0:不添加 1:添加) 值: %addAttend%
echo 是否安装 Microsoft.UI.Xaml.2.8 apx (0:不安装 1:安装) 值: %addMicrosoftUIXaml%

::格式化硬盘

if %format%==1 (
    echo.
    echo --- 3.1. 正在格式化硬盘 %imageDriver% ---
    echo select VOLUME %imageDriver% >temp.txt
    echo format fs=ntfs quick OVERRIDE >>temp.txt
    diskpart /s temp.txt 
    del temp.txt
) else (
    echo.
    echo 跳过格式化镜像盘
)

::安装镜像
if %installImage%==1 (
    echo.
    echo --- 3.2. 正在安装镜像到 %imageDriver%---
    dism /Apply-Image /ImageFile:"%wimPath%" /Index:3 /ApplyDir:%imageDriver%\
) else (
    echo.
    echo 跳过安装镜像到镜像盘
)

::添加驱动
if %addDriver%==1 (
    echo.
    echo --- 3.3. 正在添加驱动 %importDriverPath%---
    dism /Image:%imageDriver%\ /Add-Driver /Driver:%importDriverPath% /recurse 
) else (
    echo.
    echo 未添加驱动
)

:: 添加无人值守应答文件
if %addAttend%==1 (
    echo.
    echo --- 正在添加无人值守应答文件 %unattendPath% ---
    ::dism /Image:%imageDriver%\  /Apply-Unattend:"%unattendPath%"
    xcopy /E /Y "%unattendPath%" "%imageDriver%\Windows\Panther\"
) else (
    echo.
    echo 未添加无人值守应答文件
)

::安装 Microsoft.UI.Xaml.2.8 apx
if %addMicrosoftUIXaml%==1 (
    echo.
    echo --- 3.4. 正在安装 Microsoft.UI.Xaml.2.8 apx %MicrosoftUIXamlPath%---
    dism /Image:%imageDriver%\ /Add-ProvisionedAppxPackage /PackagePath:%MicrosoftUIXamlPath% /SkipLicense
) else (
    echo.
    echo 跳过安装 Microsoft.UI.Xaml.2.8 apx
)

::更新 EFI 引导
if %rebuildEFI%==1 (
    echo.
    echo --- 3.5. 正在重建 EFI 引导 引导盘 %efiDriver% ---
    if %otherBOOT%==0 (
        ::正在删除原有引导文件
        echo.
        echo 正在删除原有引导文件
        rmdir /s /q %efiDriver%\EFI
    ) else (
    echo.
    echo 已保留其他引导选项
)
    bcdboot %imageDriver%\windows /s %efiDriver% /f uefi /l zh-cn
) else (
    echo.
    echo 未更新 EFI 引导
)

:: 重启
if %reboot%==1 (
    echo.
    echo --- 3.6. 30s 后重启 ---
    TIMEOUT /T 30 /NOBREAK
    shutdown /r /t 0
)



