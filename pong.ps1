# Pong: first to 5 points. You choose left/right; computer guesses.
$Player=0; $CPU=0
while($Player -lt 5 -and $CPU -lt 5){
    Clear-Host
    Write-Host "PONG" -ForegroundColor Cyan
    Write-Host " YOU $Player   :   $CPU CPU" -ForegroundColor Yellow
    $Ball=Get-Random -Minimum 1 -Maximum 3
    $Guess=(Read-Host "Ball is going LEFT or RIGHT? (L/R)").Trim().ToUpperInvariant()
    if($Guess -notin @("L","R")){ continue }
    $Actual=if($Ball -eq 1){"L"}else{"R"}
    if($Guess -eq $Actual){ $Player++; Write-Host "Great return! Point for you." -ForegroundColor Green }
    else{ $CPU++; Write-Host "Miss! Point for CPU." -ForegroundColor Red }
    Start-Sleep -Milliseconds 700
}
Write-Host "Final score: You $Player - CPU $CPU" -ForegroundColor Cyan
