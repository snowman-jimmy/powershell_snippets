Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
[void]$FolderBrowser.ShowDialog()

$StartingFolder = $FolderBrowser.SelectedPath
$FileHashes = @{}

Get-ChildItem -Recurse $StartingFolder | ForEach-Object {
    if ($_ -isnot [System.IO.DirectoryInfo]) {
        $ThisHash = Get-FileHash $_.FullName -Algorithm MD5
        if ($ThisHash.Hash -notin $FileHashes.Keys) {
            $FileHashes.Add($ThisHash.Hash, [System.Collections.ArrayList]@()) | Out-Null
        }
        $FileHashes.($ThisHash.Hash).Add($_.FullName) | Out-Null
    }
}

$FileHashes.Values | ForEach-Object { 
    if ( $_.Count -gt 1) {
        Write-Host "`nDUPLICATE FILES FOUND: " $_  -ForegroundColor Red
    }
}