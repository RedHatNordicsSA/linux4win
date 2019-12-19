$url = "https://raw.githubusercontent.com/RedHatNordicsSA/linux4win/master/vagrant/ansibles/setup_ad.ps1"
$file = "$env:temp\setup_ad.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose
