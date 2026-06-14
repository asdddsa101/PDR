# Create RDP user with strong password
Add-Type -AssemblyName System.Security
$charSet = @{
  Upper   = [char[]](65..90)
  Lower   = [char[]](97..122)
  Number  = [char[]](48..57)
  Special = ([char[]](33..47) + [char[]](58..64) + [char[]](91..96) + [char[]](123..126))
}
$rawPassword = @()
$rawPassword += $charSet.Lower | Get-Random -Count 3
$rawPassword += $charSet.Upper | Get-Random -Count 3
$rawPassword += $charSet.Number | Get-Random -Count 2
$password = -join ($rawPassword | Sort-Object { Get-Random })
$securePass = ConvertTo-SecureString $password -AsPlainText -Force
New-LocalUser -Name "zzz" -Password $securePass -AccountNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member "zzz"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "zzz"
echo "RDP_CREDS=User: zzz | Password: $password" >> $env:GITHUB_ENV
if (-not (Get-LocalUser -Name "zzz")) { throw "User creation failed" }
