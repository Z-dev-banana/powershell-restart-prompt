$ConnectionStatus = Get-NetConnectionProfile

if ($ConnectionStatus -contains "Public") {
    Get-NetConnectionProfile -NetworkCategory "Public" | Set-NetConnectionProfile -NetworkCategory Private
} else {
    echo "No active public connections detected"
}