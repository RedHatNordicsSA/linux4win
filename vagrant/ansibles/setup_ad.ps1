#Super admin will get this password
$myPassword = "Password1"
$Secure_String_Pwd = ConvertTo-SecureString $myPassword -AsPlainText -Force
$myDomain = "hger.org"
$myNetbios = "HGER"
$myScript = "c:\usersgrops.ps1"

New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name "addusers" -Value "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file $myScript" -PropertyType ExpandString
$daScript = @'
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Import-module ActiveDirectory
$Secure_String_Pwd = ConvertTo-SecureString "Password1" -AsPlainText -Force
New-ADUser -Name "Hakan Hagenrud" -SamAccountName "hger" -UserPrincipalName "hger@hger.org" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Daniel Svensson" -SamAccountName "vsda" -UserPrincipalName "vsda@hger.org" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Mister Manager" -SamAccountName "mgmt" -UserPrincipalName "mgmt@hger.org" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Mister Intern" -SamAccountName "intr" -UserPrincipalName "intr@hger.org" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADUser -Name "Workstation Adder" -SamAccountName "wsadder" -UserPrincipalName "wsadder@hger.org" -Company "Furniture Heaven" -AccountPassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon $false
New-ADGroup "Managers" -GroupCategory Security -GroupScope Global
New-ADGroup "Minions" -GroupCategory Security -GroupScope Global
Add-ADGroupMember -Identity "Domain Admins" -Members "CN=Workstation Adder,CN=Users,DC=hger,DC=org"
Add-ADGroupMember -Identity "Minions" -Members "CN=Hakan Hagenrud,CN=Users,DC=hger,DC=org", "CN=Daniel Svensson,CN=Users,DC=hger,DC=org"
Add-ADGroupMember -Identity "Managers" -Members "CN=Mister Manager,CN=Users,DC=hger,DC=org"
Rename-Computer -NewName dc -Force -Restart
'@
#setup winrm for ansible
$ansurl = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$ansfile = "c:\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($ansurl, $ansfile)
powershell.exe -ExecutionPolicy ByPass -File $ansfile

echo $daScript > $myScript
net user /passwordreq:yes Administrator $myPassword
#Install-Windowsfeature AD-Domain-Services
#Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature DNS -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName $myDomain -DomainNetbiosName $myNetbios -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword:$Secure_String_Pwd
Rename-Computer -NewName mydc -Force


