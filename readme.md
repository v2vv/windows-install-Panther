# windows install 脚本
## 功能

1. 格式化磁盘
2. wim 镜像安装
3. 可添加驱动
4. 可添加 appx 软件
5. 可添加无人值守文件

## 使用说明

执行 wim.cmd 执行脚本

### 配置文件

配置文件在configs 目录

``` cmd
:: EFI 卷符
set efiDriver=H:
:: Windows 卷符
set imageDriver=L:
:: wim Image 路径
set wimPath=.\wim\win11-2024-8.wim
:: 驱动程序目录
set importDriverPath=.\driver\导出
:: 无人值守应答路径
set unattendPath=.\Panther\unattend.xml
:: Microsoft.UI.Xaml.2.8  appx 
set MicrosoftUIXamlPath=.\appx\Microsoft.UI.Xaml.2.8.x64.appx
::是否重建引导文件 (0:不重建 1:重建)
set rebuildEFI=1
::引导文件重建是否保存原有系统引导 (0:不保留 1:保留）
set otherBOOT=0 
:: 完成后重启 (0:不重启 1:重启)
set reboot=1
::是否添加驱动  (0:不添加 1:添加) 
set addDriver=0
::是否添加无人值守 (0:不添加 1:添加) 
set addAttend=1
::是否安装 Microsoft.UI.Xaml.2.8  apx (0:不安装 1:安装) 
set addMicrosoftUIXaml=1
```
