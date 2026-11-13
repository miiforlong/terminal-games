param(
    [string]$Prefix = "http://+:8080/"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Listener = [System.Net.HttpListener]::new()
$Listener.Prefixes.Add($Prefix)

try {
    $Listener.Start()
    Write-Host ""
    Write-Host " TERMINAL GAMES SERVER" -ForegroundColor Cyan
    Write-Host " Listening on $Prefix" -ForegroundColor Green
    Write-Host " Press Ctrl+C to stop." -ForegroundColor DarkGray
    Write-Host ""

    while ($Listener.IsListening) {
        $Context = $Listener.GetContext()
        $Request = $Context.Request
        $Response = $Context.Response
        $Path = [Uri]::UnescapeDataString($Request.Url.AbsolutePath)
        $Status = 200
        $ContentType = "text/plain; charset=utf-8"
        $Body = ""

        try {
            if ($Request.HttpMethod -ne "GET") {
                $Status = 405
                $Body = "Method not allowed"
            }
            elseif ($Path -eq "/" -or $Path -eq "/index.ps1") {
                $ContentType = "text/plain; charset=utf-8"
                $Body = Get-Content -Raw -LiteralPath (Join-Path $ProjectRoot "launcher/install.ps1")
                $BaseUrl = $Request.Url.GetLeftPart([UriPartial]::Authority)
                $Body = $Body.Replace("__SERVER_BASE_URL__", $BaseUrl)
            }
            elseif ($Path -eq "/games.json") {
                $ContentType = "application/json; charset=utf-8"
                $Body = Get-Content -Raw -LiteralPath (Join-Path $ProjectRoot "server/games.json")
            }
            elseif ($Path -match '^/games/([a-z0-9_-]+)\.ps1$') {
                $GameFile = Join-Path (Join-Path $ProjectRoot "games") ($Matches[1] + ".ps1")
                if (Test-Path -LiteralPath $GameFile -PathType Leaf) {
                    $ContentType = "text/plain; charset=utf-8"
                    $Body = Get-Content -Raw -LiteralPath $GameFile
                } else {
                    $Status = 404
                    $Body = "Game not found"
                }
            }
            else {
                $Status = 404
                $Body = "Not found"
            }
        }
        catch {
            $Status = 500
            $Body = "Server error: $($_.Exception.Message)"
        }

        $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
        $Response.StatusCode = $Status
        $Response.ContentType = $ContentType
        $Response.ContentEncoding = [System.Text.Encoding]::UTF8
        $Response.ContentLength64 = $Bytes.Length
        try { $Response.OutputStream.Write($Bytes, 0, $Bytes.Length) } finally { $Response.Close() }

        Write-Host ("{0} {1} -> {2}" -f (Get-Date -Format "HH:mm:ss"), $Path, $Status)
    }
}
finally {
    if ($Listener.IsListening) { $Listener.Stop() }
    $Listener.Close()
}
