$GUIforClash_exe = "I:\Programs\GUI.for.Clash-windows-amd64\GUI.for.Clash.exe" # GUI.for.Clash 程序
$Mihomo_exe = "I:\Programs\GUI.for.Clash-windows-amd64\data\mihomo\mihomo-windows-amd64.exe" # mihomo 内核程序

$winget_package = ".\apps\winget.msixbundle" # winget 安装包
$microsoftuixaml_package = ".\apps\Microsoft.UI.Xaml.2.8.x64.appx" # Microsoft.UI.Xaml.2.8 安装包
$chrome_package = ".\apps\googlechromestandaloneenterprise64.msi"  # chrome 安装包
$activation_script = ".\apps\activation.cmd /HWID" # 数字激活脚本

$git_config_script = ".\configs\gitconfig" #git 配置脚本
$vscode_config_reg = ".\configs\vscode.reg" # vsocde 右键注册表文件


#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force # 允许执行自定义脚本
New-NetFirewallRule -DisplayName "GUI.for.Clash" -Direction Inbound -Program $Mihomo_exe -Action Allow # 将代理软件加入防火墙允许访问网络
Invoke-Expression $GUIforClash_exe # 运行代理软件
(Get-AppxPackage -AllUsers).PackageFamilyName | ForEach-Object {CheckNetIsolation.exe LoopbackExempt -a -n="$_"| Out-Null} #解除所有 Window 的 UWP 应用本地回环限制
#Add-AppxPackage -Path $microsoftuixaml_package # 安装 Microsoft.UI.Xaml.2.8
Add-AppxPackage -Path $winget_package # 更新 winget
Start-Process powershell.exe -ArgumentList $activation_script #在新 powershell 窗口中激活 windows
Invoke-Expression  $chrome_package # 谷歌浏览器
Start-Sleep -Seconds 10

winget install --id=Git.Git -e -s winget --accept-source-agreements --accept-package-agreements # 安装 git
. $git_config_script # git 配置
winget install --id=Casey.Just -e -s winget                       # just
# winget install --id Google.Chrome -e -s winget                  # 谷歌浏览器 20240829 验证 hash 值失败
winget install --id=PuTTY.PuTTY -e -s winget                      # putty
winget install --id=jqlang.jq -s winget                           # jq 读取json文件 windows
winget install --id=Tonec.InternetDownloadManager -e -s winget    # idm 下载器
winget install --id=7zip.7zip  -e -s winget                       # 7-zip
winget install --id Microsoft.VisualStudioCode -e -s winget       # VSCode
regedit.exe /s $vscode_config_reg # 增加注册表 Vscode 文件管理器 右键菜单启动 # reg import $vscode_config_reg
winget install --id=Obsidian.Obsidian  -e -s winget               # Obsidian
winget install --id=Microsoft.Office  -e -s winget                # Office365
winget install --id Microsoft.DevHome -e -s winget                # DevHome