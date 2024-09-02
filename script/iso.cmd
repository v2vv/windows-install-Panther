chcp 65001
::iso 文件路径,驱动文件目录, 无人值守应答文件
set isoPath=C:\系统备份\ISO\zh-cn_windows_11_business_editions_version_23h2_updated_aug_2024_x64_dvd_6ca91c94.iso
set importDriverPath=C:\系统备份\driver\导出
set unattendPath=E:\安装包\auto\Panther\unattend.xml

::光盘驱动盘符, EFI 引导盘符, 系统盘符
set isoDriver=R
set efiDriver=H:
set imageDriver=I:

::格式化硬盘
diskpart /s diskpart.txt

::安装系统
imdisk -a -f "%isoPath%" -m %isoDriver%: 
dism /Get-WimInfo /WimFile:"%isoDriver%:\sources\install.wim"
dism /Apply-Image /ImageFile:"%isoDriver%:\sources\install.wim" /Index:3 /ApplyDir:%imageDriver%\

::添加驱动
dism /Image:%imageDriver%\ /Add-Driver /Driver:%importDriverPath% /recurse 

:: 添加无人值守应答文件
::dism /Image:%imageDriver%\  /Apply-Unattend:"%unattendPath%"
xcopy /E /Y "%unattendPath%" "%imageDriver%\Windows\Panther\"

dism /Image:%imageDriver%\ /Add-ProvisionedAppxPackage /PackagePath:M:\restore1\Microsoft.UI.Xaml.2.8.x64.appx /SkipLicense

::重建 EFI 引导
rmdir /s /q %efiDriver%\EFI
bcdboot %imageDriver%\windows /s %efiDriver% /f uefi /l zh-cn

::重启
TIMEOUT /NOBREAK 5
shutdown -r

