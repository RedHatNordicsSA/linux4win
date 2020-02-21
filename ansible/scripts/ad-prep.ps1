<powershell>
$myPassword = "Password1"
$Secure_String_Pwd = ConvertTo-SecureString $myPassword -AsPlainText -Force
$myDomain = "linux4win.local"
$myNetbios = "LINUX4WIN"
$myScript = "c:\usersgrops.ps1"

$daScript = @'
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Import-module ActiveDirectory
$Secure_String_Pwd = ConvertTo-SecureString "Password1" -AsPlainText -Force
New-ADUser -Name "Hakan Hagenrud" -SamAccountName "hger" -UserPrincipalName "hger@linux4win.local" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Daniel Svensson" -SamAccountName "vsda" -UserPrincipalName "vsda@linux4win.local" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Mister Manager" -SamAccountName "mgmt" -UserPrincipalName "mgmt@linux4win.local" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Mister Intern" -SamAccountName "intr" -UserPrincipalName "intr@linux4win.local" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Workstation Adder" -SamAccountName "wsadder" -UserPrincipalName "wsadder@linux4win.local" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADGroup "Managers" -GroupCategory Security -GroupScope Global
New-ADGroup "Minions" -GroupCategory Security -GroupScope Global
Add-ADGroupMember -Identity "Domain Admins" -Members "CN=Workstation Adder,CN=Users,DC=linux4win,DC=local"
Add-ADGroupMember -Identity "Minions" -Members "CN=Hakan Hagenrud,CN=Users,DC=linux4win,DC=local", "CN=Daniel Svensson,CN=Users,DC=linux4win,DC=local"
Add-ADGroupMember -Identity "Managers" -Members "CN=Mister Manager,CN=Users,DC=linux4win,DC=local"
'@

echo $daScript > $myScript
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name "addusers" -Value "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file $myScript" -PropertyType ExpandString
Start-Sleep -s 5
#net user /passwordreq:yes Administrator $myPassword
Set-LocalUser -Name "Administrator" -Password $Secure_String_Pwd
#Install-Windowsfeature AD-Domain-Services
#Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Start-Sleep -s 20
Install-WindowsFeature DNS -IncludeManagementTools
Start-Sleep -s 20
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName $myDomain -DomainNetbiosName $myNetbios -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword:$Secure_String_Pwd
Rename-Computer -NewName mydc -Force
Restart-Computer
</powershell>

