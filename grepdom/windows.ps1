$VSN = "1.0.0"

# build the filename for the Zip archive and exe file
$FileName = "grepdom_$($VSN)_windows_amd64"
$ZipFileName = "$($FileName).zip"

# download and extract zip
Invoke-WebRequest -Uri "https://github.com/ipinfo/cli/releases/download/grepdom-$VSN/$FileName.zip" -OutFile ./$ZipFileName
Unblock-File ./$ZipFileName
Expand-Archive -Path ./$ZipFileName  -DestinationPath $env:LOCALAPPDATA\ipinfo -Force

# delete if already exists
if (Test-Path "$env:LOCALAPPDATA\ipinfo\grepdom.exe") {
    Remove-Item "$env:LOCALAPPDATA\ipinfo\grepdom.exe"
}
Rename-Item -Path "$env:LOCALAPPDATA\ipinfo\$FileName.exe" -NewName "grepdom.exe"

# setting up env. 
$PathContent = [Environment]::GetEnvironmentVariable('path', 'Machine')
$IPinfoPath = "$env:LOCALAPPDATA\ipinfo"

# if Path already exists
if ($PathContent -ne $null) {
    if (-Not($PathContent -split ';' -contains $IPinfoPath)) {
        [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";$env:LOCALAPPDATA\ipinfo", "Machine")
    }
}
else {
    [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";$env:LOCALAPPDATA\ipinfo", "Machine")
}

# cleaning files
Remove-Item -Path ./$ZipFileName
"You can use grepdom now."