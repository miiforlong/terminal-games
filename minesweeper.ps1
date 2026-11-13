# Minesweeper 5x5 with 5 mines. Commands: R row col (reveal), F row col (flag), Q.
$N=5;$MineCount=5;$Mines=@{}
while($Mines.Count -lt $MineCount){$Mines["$(Get-Random -Maximum $N),$(Get-Random -Maximum $N)"]=$true}
$Revealed=@{};$Flags=@{}
function Show-Board {
    Write-Host "    0 1 2 3 4"
    for($r=0;$r -lt $N;$r++){
        $Line="$r | "
        for($c=0;$c -lt $N;$c++){
            $K="$r,$c"
            if($Flags.ContainsKey($K)){$Line+="F "}
            elseif($Revealed.ContainsKey($K)){
                if($Mines.ContainsKey($K)){$Line+="* "}
                else{$Count=0;foreach($dr in -1..1){foreach($dc in -1..1){if($dr -ne 0 -or $dc -ne 0){if($Mines.ContainsKey("$($r+$dr),$($c+$dc)")){$Count++}}}};$Line+="$Count "}
            }else{$Line+=". "}
        }
        Write-Host $Line
    }
}
while($true){
    Clear-Host;Write-Host "MINESWEEPER | 5x5, 5 mines" -ForegroundColor Cyan;Show-Board
    $Cmd=(Read-Host "R row col = reveal, F row col = flag, Q = quit").Trim().ToUpperInvariant()
    if($Cmd -eq "Q"){break}
    if($Cmd -match '^([RF])\s+([0-4])\s+([0-4])$'){
        $K="$($Matches[2]),$($Matches[3])"
        if($Matches[1] -eq "F"){if($Flags.ContainsKey($K)){$Flags.Remove($K)}else{$Flags[$K]=$true}}
        else{
            if($Mines.ContainsKey($K)){Clear-Host;Write-Host "BOOM! You hit a mine." -ForegroundColor Red;Show-Board;break}
            $Revealed[$K]=$true
            if($Revealed.Count -ge ($N*$N-$MineCount)){Clear-Host;Write-Host "YOU WIN!" -ForegroundColor Green;Show-Board;break}
        }
    }
}
