# add-git-profile.ps1
# git 终端配置
$windowsterminal_exe = "C:\'Program Files'\WindowsApps\Microsoft.WindowsTerminal_1.12.10983.0_x64__8wekyb3d8bbwe\wt.exe"
$windowsterminal_settings = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('LocalApplicationData'), 'Packages', 'Microsoft.WindowsTerminal_8wekyb3d8bbwe', 'LocalState', 'settings.json')
$git_bash_path = "C:\Program Files\Git\bin\bash.exe"
$git_bash_icon = "C:\Program Files\Git\mingw64\share\git\git-for-windows.ico"
$git_profile_name = "Git Bash"

# git 环境变量
$GitEnvPath = "C:\Program Files\Git\bin"
$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)

# git ssh 密钥
$ssh_config = ".\.ssh"
$destinationPath = "$env:USERPROFILE\.ssh"
$backupPath = "$env:USERPROFILE\.ssh_backup"

# git 用户名 邮箱
$git_user_name = "v2vv"
$git_user_email = "v2vvcn@gmail.com"

# Obsidian 笔记文件夹
$Obsidian_Folder = "E:\obsidian\Obsidian"



# 首次运行 WindowsTerminal
Invoke-Expression $windowsterminal_exe
Start-Sleep -Seconds 3

# 使用 PowerShell 读取 settings.json 文件
$config = Get-Content -Path $windowsterminal_settings -Raw | ConvertFrom-Json

# 检查是否已经存在 Git Bash 配置
$gitProfileExists = $config.profiles.list | Where-Object { $_.name -eq "$git_profile_name" }

if ($gitProfileExists) {
  Write-Host "Git Bash profile already exists. No changes made."
}
else {
  # 生成新的 GUID
  $newGuid = [guid]::NewGuid().ToString()

  # 创建新的 Git Bash profile
  $newProfile = @{
    name              = "$git_profile_name"
    guid              = "{$newGuid}"
    commandline       = "$git_bash_path -l -i"
    icon              = "$git_bash_icon"
    hidden            = $false
    startingDirectory = $null
  }

  # 将新的 profile 添加到 profiles 列表中
  $config.profiles.list += $newProfile

  # 将修改后的配置写回 settings.json 文件，确保以 UTF-8 编码写入
  $config | ConvertTo-Json -Depth 32 | Set-Content -Path $WindowsTerminal_settings -Encoding UTF8

  # 提示用户重启 Windows Terminal
  Write-Host "Git Bash profile added! Please restart Windows Terminal to apply changes."
}


# 添加 git路径到环境变量
if ($envPath -notlike "*$GitEnvPath*") {
  $newPath = "$envPath;$GitEnvPath"
  [System.Environment]::SetEnvironmentVariable("PATH", $newPath, [System.EnvironmentVariableTarget]::User)
  Write-Output "Path added."
  $env:Path += ";" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) # 更新当前会话中的系统环境变量
  $env:Path += ";" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) # 更新当前会话中的用户环境变量
}
else {
  Write-Output "envPath already exists."
}

# Copy-Item -Path ".ssh" -Destination "$env:USERPROFILE" -Recurse

# 复制 ssh 公私钥



if (Test-Path -Path $destinationPath) {
    # 如果目标文件夹存在，检查 .ssh_backup 是否已经存在
    if (Test-Path -Path $backupPath) {
        # 如果 .ssh_backup 已经存在，删除它
        Remove-Item -Path $backupPath -Recurse -Force
    }
    Write-Output "将之前的.ssh 文件夹备份为 .ssh_backup"
    # 将目标文件夹重命名为 .ssh_backup
    Rename-Item -Path $destinationPath -NewName ".ssh_backup"
}

# 执行复制操作
Copy-Item -Path $ssh_config -Destination $destinationPath -Recurse
Write-Output ".ssh 文件夹已复制"

git config --global user.email $git_user_email # 配置 git 提交邮箱
git config --global user.name $git_user_name # 配置 git 提交用户名
git config --global --add safe.directory $Obsidian_Folder # 增加 git 安全仓库