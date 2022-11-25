param(
    [parameter()]
    [String]$BackupPath
)
$BackupJsons = Get-ChildItem $BackupPath -Recurse -Include *.json
foreach ($Json in $BackupJsons) {
    $PolicyID = $Json.BaseName
    Write-Output "Removing $PolicyID"
    Remove-AzureADMSConditionalAccessPolicy -PolicyId $PolicyID
}