# Tetris-lite: choose a column for each falling block. A/D move, S drops, Q quits.
$Width=10; $Height=12; $Board=@()
for($y=0;$y -lt $Height;$y++){ $Board += ,(@(".", ".", ".", ".", ".", ".", ".", ".", ".", ".")) }
$Score=0
while($true){
    Clear-Host
    Write-Host "TETRIS-LITE | Score: $Score" -ForegroundColor Cyan
    for($y=0;$y -lt $Height;$y++){ Write-Host ("|"+($Board[$y] -join " ")+"|") }
    Write-Host "+-------------------+"
    Write-Host "Enter a column 0-9 to drop a block, A/D change selected column, S drops, Q quits."
    $Column=Get-Random -Minimum 0 -Maximum $Width
    while($true){
        $InputMove=(Read-Host "Column $Column").Trim().ToLowerInvariant()
        if($InputMove -eq "q"){ return }
        if($InputMove -eq "a"){ $Column=[Math]::Max(0,$Column-1); continue }
        if($InputMove -eq "d"){ $Column=[Math]::Min($Width-1,$Column+1); continue }
        if($InputMove -match '^\d$'){ $Column=[int]$InputMove }
        if($InputMove -eq "s" -or $InputMove -match '^\d$'){ break }
    }
    $Row=-1
    for($y=$Height-1;$y -ge 0;$y--){ if($Board[$y][$Column] -eq "."){ $Row=$y; break } }
    if($Row -lt 0){ break }
    $Board[$Row][$Column]="#"
    $Full=@()
    for($y=0;$y -lt $Height;$y++){ if(@($Board[$y] | Where-Object {$_ -eq "#"}).Count -eq $Width){ $Full += $y } }
    foreach($r in ($Full | Sort-Object -Descending)){
        $Board=@($Board | Where-Object {$_ -ne $Board[$r]})
        $Board=@((@(".", ".", ".", ".", ".", ".", ".", ".", ".", ".")) + $Board)
        $Score+=100
    }
}
Write-Host "Game over! Final score: $Score" -ForegroundColor Yellow
