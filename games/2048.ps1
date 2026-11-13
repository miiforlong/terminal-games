# 2048 - move with W/A/S/D. Enter Q to quit.
$Size=4
$Grid=@()
for($r=0;$r -lt $Size;$r++){ $Grid += ,@(0,0,0,0) }
function Add-Tile {
    $Empty=@()
    for($r=0;$r -lt 4;$r++){for($c=0;$c -lt 4;$c++){if($Grid[$r][$c] -eq 0){$Empty+= ,@($r,$c)}}}
    if($Empty.Count -gt 0){$P=$Empty[(Get-Random -Maximum $Empty.Count)];$Grid[$P[0]][$P[1]]=if((Get-Random -Maximum 10)-eq 0){4}else{2}}
}
function Move-Line($Line) {
    $Values=@($Line | Where-Object {$_ -ne 0})
    $Out=@();$i=0
    while($i -lt $Values.Count){
        if($i+1 -lt $Values.Count -and $Values[$i] -eq $Values[$i+1]){$Out+=($Values[$i]*2);$i+=2}
        else{$Out+=$Values[$i];$i++}
    }
    while($Out.Count -lt 4){$Out+=0}
    return ,$Out
}
Add-Tile;Add-Tile
while($true){
    Clear-Host;Write-Host "2048" -ForegroundColor Cyan
    for($r=0;$r -lt 4;$r++){Write-Host (($Grid[$r] | ForEach-Object {if($_ -eq 0){" . "}else{("{0,3}" -f $_)}}) -join " | ")}
    $Move=(Read-Host "Move W/A/S/D, Q quits").Trim().ToUpperInvariant()
    if($Move -eq "Q"){break}
    if($Move -notin @("W","A","S","D")){continue}
    $Old=($Grid | ForEach-Object {$_ -join ","}) -join ";"
    if($Move -in @("A","D")){
        for($r=0;$r -lt 4;$r++){
            $Line=@($Grid[$r]);if($Move -eq "D"){[array]::Reverse($Line)}
            $New=Move-Line $Line;if($Move -eq "D"){[array]::Reverse($New)}
            $Grid[$r]=$New
        }
    }else{
        for($c=0;$c -lt 4;$c++){
            $Line=@();for($r=0;$r -lt 4;$r++){$Line+= $Grid[$r][$c]}
            if($Move -eq "S"){[array]::Reverse($Line)}
            $New=Move-Line $Line;if($Move -eq "S"){[array]::Reverse($New)}
            for($r=0;$r -lt 4;$r++){$Grid[$r][$c]=$New[$r]}
        }
    }
    $Now=($Grid | ForEach-Object {$_ -join ","}) -join ";"
    if($Now -ne $Old){Add-Tile}
    if(($Grid | ForEach-Object {$_ -contains 2048}) -contains $true){Clear-Host;Write-Host "YOU REACHED 2048! YOU WIN!" -ForegroundColor Green;break}
}
