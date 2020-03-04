. .\LinkLocal.ps1

$pathway=":\Users\$env:UserName"
$cuser="C$pathway"
$duser="D$pathway"

$directories = Get-ChildItem -Path $cuser -Attributes Directory | Select -exp Name
foreach ($directory in $directories) {
	LinkLocal $directory
}

$directories = Get-ChildItem -Path $duser -Attributes Directory | Select -exp Name
foreach ($directory in $directories) {
	LinkLocal $directory
}