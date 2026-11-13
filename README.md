# Terminal Games

A small PowerShell terminal game centre. The launcher downloads the catalogue and the selected game from your server and runs the game code in memory.

## Requirements
- Windows PowerShell 5.1 or PowerShell 7+
- The server host needs PowerShell 5.1+ and permission to listen on TCP 8080.

## Start the server
From the extracted `terminal-games` folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\server\index.ps1
```

By default it listens on `http://+:8080/`. Allow inbound TCP 8080 in the host firewall if clients on your LAN need to connect. To use a different port:

```powershell
.\server\index.ps1 -Prefix "http://+:8090/"
```

## Launch a client
On a client PC, run (replace the address with your server's LAN IP):

```powershell
irm http://192.168.1.123:8080/ | iex
```

The root URL returns the launcher with the server address filled in. Games are fetched only when selected. No game files are saved to the client disk.

## Add a game
1. Add a `.ps1` file under `games/`, using a simple ID such as `mygame.ps1`.
2. Add an entry to `server/games.json` with matching `id`, `name`, and `description`.
3. Restart is not required; the catalogue is read on every menu refresh.

## Security
This is a demo for a trusted LAN. The server uses plain HTTP and does not authenticate clients. Anyone who can reach it can download the scripts. The launcher executes downloaded PowerShell code in memory, so only use a server you control and trust. Inspect scripts before running them. Do not expose this server directly to the public internet without adding HTTPS, authentication, and access controls.
