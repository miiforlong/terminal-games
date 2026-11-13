# Snake - turn-based terminal edition. Enter W/A/S/D each turn.
$ErrorActionPreference = "Stop"
$Width = 18; $Height = 10
$Snake = @(@{X=5;Y=5}, @{X=4;Y=5}, @{X=3;Y=5})
$Direction = "D"; $Score = 0
function Get-PointKey($X,$Y) { "$X,$Y" }

while ($true) {
    Clear-Host
    Write-Host "SNAKE  |  Score: $Score" -ForegroundColor Green
    Write-Host "Move with W/A/S/D, Q to quit. Each key advances one turn." -ForegroundColor DarkGray
    $Food = $script:Food
    if (-not $Food -or ($Snake | Where-Object { $_.X -eq $Food.X -and $_.Y -eq $Food.Y })) {
        do { $Food = @{X=(Get-Random -Minimum 0 -Maximum $Width);Y=(Get-Random -Minimum 0 -Maximum $Height)} }
        while ($Snake | Where-Object { $_.X -eq $Food.X -and $_.Y -eq $Food.Y })
        $script:Food = $Food
    }
    for ($y=0; $y -lt $Height; $y++) {
        $Line = ""
        for ($x=0; $x -lt $Width; $x++) {
            if ($x -eq $Food.X -and $y -eq $Food.Y) { $Line += "*" }
            elseif ($Snake[0].X -eq $x -and $Snake[0].Y -eq $y) { $Line += "@" }
            elseif ($Snake | Where-Object { $_.X -eq $x -and $_.Y -eq $y }) { $Line += "o" }
            else { $Line += " " }
        }
        Write-Host "|$Line|"
    }
    $Move = (Read-Host "Direction").Trim().ToUpperInvariant()
    if ($Move -eq "Q") { break }
    if ($Move -match '^[WASD]$') {
        $Opposite = @{W="S";S="W";A="D";D="A"}
        if ($Move -ne $Opposite[$Direction]) { $Direction = $Move }
    }
    $Head = @{X=$Snake[0].X;Y=$Snake[0].Y}
    switch ($Direction) { W {$Head.Y--} S {$Head.Y++} A {$Head.X--} D {$Head.X++} }
    if ($Head.X -lt 0 -or $Head.X -ge $Width -or $Head.Y -lt 0 -or $Head.Y -ge $Height) { break }
    $Eating = ($Head.X -eq $Food.X -and $Head.Y -eq $Food.Y)
    $CheckBody = if ($Eating) { $Snake } else { $Snake | Select-Object -First ($Snake.Count - 1) }
    if ($CheckBody | Where-Object { $_.X -eq $Head.X -and $_.Y -eq $Head.Y }) { break }
    $Snake = @($Head) + @($Snake)
    if ($Eating) { $Score += 10; $script:Food = $null } else { $Snake = @($Snake | Select-Object -First ($Snake.Count - 1)) }
}
Write-Host "Game over! Final score: $Score" -ForegroundColor Yellow
