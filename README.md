# Rubeus AMSI tickets dump
 AMSI evasion combined with in-memory loading of Rubeus, allowing dumping of Kerberos tickets through a PowerShell-based workflow.

This project attempts to utilize the stealthiest option to target Kerberos tickets by running Rubeus through a PowerShell wrapper.
base64 and caesar cipher are used in order to decrypt and run the scripts on the fly.

1. Compile Rubeus and get the executable (preferably a x64 version). Instructions: https://github.com/GhostPack/Rubeus?tab=readme-ov-file#compile-instructions
2. Encode Rubeus and the AMSI CLR bypass. Set the Rubeus executable name ($RPath) and bypass name ($CPath) in encode_files.ps1.  
    Then in a powershell session:  
    <code>Set-ExecutionPolicy Bypass -Scope Process  
    .\encode_files.ps1</code>  
3. The encoded Rubeus (renc.txt) and bypass (clrbp.ps1.txt) are ready to be used alongside with caesar.ps1 to the target.
4. Run .\dec_exe.ps1 to the target. The tickets will be extracted in rubeus_dump.txt.
