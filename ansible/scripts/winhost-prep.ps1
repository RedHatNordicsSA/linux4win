#setup winrm for ansible
$ansurl = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$ansfile = "c:\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($ansurl, $ansfile)
powershell.exe -ExecutionPolicy ByPass -File $ansfile
$myPassword = "Password1"
$Secure_String_Pwd = ConvertTo-SecureString $myPassword -AsPlainText -Force
New-LocalUser "wsadder" -Password $Secure_String_Pwd -FullName "Workstation Adder" -Description "The extra account for managing the server."
Add-LocalGroupMember -Group Administrators -Member wsadder
