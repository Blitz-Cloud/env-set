if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
Write-Output "Downloads started..."

$defaultPackages = @("Cloudflare.Warp","Cloudflare.cloudflared")

$packages =  Get-Content("~/Desktop/install.txt") 



if(!$packages){
  Write-Output "Nici o lista cu pachete a fost data se instaleaza cele default"
  $packages = $defaultPackages 
}else{
  Write-Output "Se vor instala urmatoarele pachete:"
  foreach($pack in $packages){
    Write-Output $pack
  }
}


$isCert = Get-ChildItem -Path Cert:\CurrentUser\AuthRoot | Where-Object {$_.Thumbprint -eq "BB2DB63D6BDEDA064ECACB40F6F26140B710F06C"}
 
# check if certificate is allready installed  
if ( ! $isCert) {
  $cert = Start-Job -ScriptBlock {Invoke-WebRequest -Uri "https://developers.cloudflare.com/cloudflare-one/static/documentation/connections/Cloudflare_CA.crt" -OutFile "~/Desktop/installDir/Cloudflare_CA.crt"}
  Wait-Job -Job $cert
  Import-Certificate -FilePath "~/Desktop/installDir/Cloudflare_CA.crt" -CertStoreLocation Cert:\CurrentUser\AuthRoot -Confirm
  Write-Output "Certificatul Cloudflare a fost instalat"
}else{
  Write-Output "Certificatul de la Cloudflare este deja instalat"
}

 
foreach ($pack in $packages) {
  winget install $pack
}

}
# Get-ChildItem -Path Cert:\CurrentUser\AuthRoot | Where-Object {$_.Thumbprint -eq "83EDC96EC3D55125EFFC77BC815F9133E268D5EB"}


