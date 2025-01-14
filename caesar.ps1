<#
.SYNOPSIS
    A simple Caesar cipher in PowerShell that outputs to the pipeline.

.DESCRIPTION
    This version reads a text file, applies a Caesar shift, 
    and writes the transformed text to stdout (the pipeline).

.PARAMETER Shift
    Integer shift: positive to encrypt, negative to decrypt.

.PARAMETER InputFile
    The path to the input text file.

.EXAMPLE
    .\caesar.ps1 -Shift 3 -InputFile "rtest.txt"
    Encrypts "rtest.txt" by shifting letters 3 forward 
    and writes the result to the pipeline.

.EXAMPLE
    # Capture decrypted text into a variable:
    $decryptedText = .\caesar.ps1 -Shift -3 -InputFile "rtestenc.txt"

.EXAMPLE
    # Pipe the decrypted text to another command inline:
    Some-Command -Param (.\caesar.ps1 -Shift -3 -InputFile "rtestenc.txt")
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [int]$Shift,

    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

function ConvertTo-CaesarCipher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $true)]
        [int]$Shift
    )

    $result = New-Object System.Text.StringBuilder
    $lowercase = "abcdefghijklmnopqrstuvwxyz"
    $uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    for ($i = 0; $i -lt $Text.Length; $i++) {
        $char = $Text[$i]

        if ($lowercase.Contains($char)) {
            $originalIndex = $lowercase.IndexOf($char)
            $newIndex = ($originalIndex + $Shift) % 26
            if ($newIndex -lt 0) { $newIndex += 26 }
            $result.Append($lowercase[$newIndex]) | Out-Null
        }
        elseif ($uppercase.Contains($char)) {
            $originalIndex = $uppercase.IndexOf($char)
            $newIndex = ($originalIndex + $Shift) % 26
            if ($newIndex -lt 0) { $newIndex += 26 }
            $result.Append($uppercase[$newIndex]) | Out-Null
        }
        else {
            $result.Append($char) | Out-Null
        }
    }

    return $result.ToString()
}

# Read the file as one string
$text = Get-Content -Path $InputFile -Raw

# Transform it
$transformedText = ConvertTo-CaesarCipher -Text $text -Shift $Shift

# Output to the pipeline
Write-Output $transformedText
