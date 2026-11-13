# Terminal Games launcher. The server replaces the URL placeholder when serving this file.
$ErrorActionPreference = "Stop"
$BaseUrl = "__SERVER_BASE_URL__".TrimEnd("/")

function Show-Header {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              TERMINAL GAME CENTER            ║" -ForegroundColor Cyan
    Write-Host "║                   v1.0                       ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host " Server: $BaseUrl" -ForegroundColor DarkGray
    Write-Host ""
}

function Invoke-RemoteGame {
    param([Parameter(Mandatory)][string]$GameId)

    $GameUrl = "$BaseUrl/games/$GameId.ps1"
    try {
        Write-Host "Loading $GameId..." -ForegroundColor DarkGray
        $Code = (Invoke-WebRequest -Uri $GameUrl -UseBasicParsing -TimeoutSec 15).Content
        if ([string]::IsNullOrWhiteSpace($Code)) { throw "The server returned an empty game." }
        $GameScript = [scriptblock]::Create($Code)
        & $GameScript
    }
    catch {
        Write-Host "Could not launch game: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to continue" | Out-Null
    }
}

while ($true) {
    Show-Header
    try {
        $Catalog = Invoke-RestMethod -Uri "$BaseUrl/games.json" -TimeoutSec 15
    }
    catch {
        Write-Host "Cannot reach the game server: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Check the server URL and try again."
        break
    }

    foreach ($Game in $Catalog.games) {
        Write-Host (" [{0}] {1,-14} {2}" -f $Game.id, $Game.name, $Game.description) -ForegroundColor White
    }
    Write-Host ""
    Write-Host " [R] Refresh catalogue     [Q] Quit" -ForegroundColor Yellow
    $Choice = (Read-Host "Choose a game").Trim().ToLowerInvariant()

    if ($Choice -eq "q") { break }
    if ($Choice -eq "r" -or $Choice -eq "") { continue }

    $Selected = $Catalog.games | Where-Object { $_.id -eq $Choice } | Select-Object -First 1
    if (-not $Selected) {
        Write-Host "Unknown game. Enter one of the listed IDs." -ForegroundColor Red
        Start-Sleep -Seconds 1
        continue
    }

    Invoke-RemoteGame -GameId $Selected.id
    Read-Host "`nPress Enter to return to the menu" | Out-Null
}

Write-Host "Thanks for playing Terminal Games!" -ForegroundColor Cyan
