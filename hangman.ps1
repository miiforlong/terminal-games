# Hangman
$Words=@("POWERSHELL","TERMINAL","COMPUTER","KEYBOARD","NETWORK","PROGRAMMING","SERVER","ROCKET")
$Word=$Words[(Get-Random -Maximum $Words.Count)]
$Guessed=@();$Lives=6
while($Lives -gt 0){
    Clear-Host
    Write-Host "HANGMAN" -ForegroundColor Cyan
    Write-Host "Lives: $Lives   Guessed: $($Guessed -join ', ')" -ForegroundColor Yellow
    $Display=($Word.ToCharArray() | ForEach-Object {if($Guessed -contains "$_"){"$_"}else{"_"}}) -join " "
    Write-Host "`n$Display`n"
    if($Display -notmatch "_"){Write-Host "YOU WIN!" -ForegroundColor Green;break}
    $Guess=(Read-Host "Guess one letter (or Q to quit)").Trim().ToUpperInvariant()
    if($Guess -eq "Q"){break}
    if($Guess -notmatch '^[A-Z]$' -or $Guessed -contains $Guess){continue}
    $Guessed+= $Guess
    if($Word -notlike "*$Guess*"){$Lives--}
}
if($Lives -le 0){Write-Host "Game over! The word was $Word." -ForegroundColor Red}
