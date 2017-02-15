#https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_10
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Restart-Computer -Force
md "$env:TEMP`\docker"
cd "$env:TEMP`\docker"

Register-PSRepository -Name DockerPS-Dev -SourceLocation "https://ci.appveyor.com/nuget/docker-powershell-dev"
Install-Module Docker -Repository DockerPS-Dev -Scope CurrentUser
Update-Module Docker