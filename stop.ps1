Set-Location c:/azp

$azpToken = "$(Get-Content ./.token)"

Write-Host "Cleanup. Removing Azure Pipelines agent..." -ForegroundColor Cyan

.\\agent\config.cmd remove --unattended --auth PAT --token "$azpToken"
