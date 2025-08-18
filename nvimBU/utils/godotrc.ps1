# # godotrc.ps1
#
# # Accept arguments passed from Godot
# param (
#     [string]$FilePath,
#     [int]$LineNumber
# )
#
# # Simple logging
# $logFile = "$env:TEMP\nvim_debug_log.txt"
# Add-Content -Path $logFile -Value "`n[$(Get-Date)] ✅ Script called with: $FilePath $LineNumber"
#
# # Config
# $termExec = "C:\Program\ Files\WezTerm\wezterm-gui.exe"
# $nvimExec = "C:\Program\ Files\Neovim\bin\nvim.exe"
# $serverPath = "\\.\pipe\nvim-godot"
# $serverStartupDelay = 0.2
#
# function Start-Server {
#     Add-Content -Path $logFile -Value "Starting Neovim server..."
#     "$nvimExec --listen $serverPath"
# }
#
# function Open-File-In-Server {
#     Add-Content -Path $logFile -Value "Opening file: $FilePath at line $LineNumber"
#     $escapedPath = $FilePath -replace '\\', '\\\\'
#     $remoteCommand = "<C-\\><C-n>:e $escapedPath<CR>:call cursor($LineNumber, 1)<CR>"
#     Start-Process $nvimExec "--server $serverPath --remote-send $remoteCommand)
#
#   # filename=$(printf %q "$1")
#   "$term_exec" -e "$nvim_exec" --server "$server_path" --remote-send "<C-\><C-n>:n $filename<CR>:call cursor($2)<CR>"
# }
#
# # Check if pipe exists
# if (-not (Test-Path $serverPath)) {
#     Add-Content -Path $logFile -Value "Pipe not found — starting new server"
#     Start-Server
#     Start-Sleep -Seconds $serverStartupDelay
# }
#
# Open-File-In-Server
# Add-Content -Path $logFile -Value "✅ Script completed"
