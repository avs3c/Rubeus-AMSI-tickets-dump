<#
.SYNOPSIS
    A simple Caesar cipher in PowerShell for text files.

.DESCRIPTION
    This script reads a text file, shifts letters by a given integer,
    and writes the result to a new file. 
    Non-letter characters (spaces, punctuation, digits, etc.) are not changed.

.PARAMETER Shift
    Integer shift for the Caesar cipher:
    - Positive shift -> Encrypt
    - Negative shift -> Decrypt (or equivalently, 26 - SHIFT)

.PARAMETER InputFile
    The path to the input text file.

.PARAMETER OutputFile
    The path to write the transformed text file.

.EXAMPLE
    .\caesar_to_output_file.ps1 -Shift 3 -InputFile "rtest.txt" -OutputFile "rtestenc.txt"
    Encrypts "rtest.txt" by shifting letters 3 forward and writes output to "rtestenc.txt".

.EXAMPLE
    .\caesar_to_output_file.ps1 -Shift -3 -InputFile "rtestenc.txt" -OutputFile "rtest.txt"
    Decrypts "rtestenc.txt" by shifting letters 3 backward and writes to "rtest.txt".
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [int]$Shift,

    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

function ConvertTo-CaesarCipher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $true)]
        [int]$Shift
    )

    # For appending characters efficiently
    $result = New-Object System.Text.StringBuilder

    # Reference alphabets
    $lowercase = "abcdefghijklmnopqrstuvwxyz"
    $uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    for ($i = 0; $i -lt $Text.Length; $i++) {
        $char = $Text[$i]

        if ($lowercase.Contains($char)) {
            # Find original index in [a-z]
            $originalIndex = $lowercase.IndexOf($char)
            # Calculate new index with modulo 26
            $newIndex = ($originalIndex + $Shift) % 26
            if ($newIndex -lt 0) {
                $newIndex += 26
            }
            $result.Append($lowercase[$newIndex]) | Out-Null
        }
        elseif ($uppercase.Contains($char)) {
            # Find original index in [A-Z]
            $originalIndex = $uppercase.IndexOf($char)
            $newIndex = ($originalIndex + $Shift) % 26
            if ($newIndex -lt 0) {
                $newIndex += 26
            }
            $result.Append($uppercase[$newIndex]) | Out-Null
        }
        else {
            # Leave non-alphabetic characters as-is
            $result.Append($char) | Out-Null
        }
    }

    return $result.ToString()
}

# Read the entire file as text (including line breaks)
$text = Get-Content -Path $InputFile -Raw

# Apply the Caesar cipher
$transformedText = ConvertTo-CaesarCipher -Text $text -Shift $Shift

# Write the transformed text to the output file
Set-Content -Path $OutputFile -Value $transformedText -Encoding UTF8

Write-Host "Done! The transformed text has been saved to '$OutputFile'."
