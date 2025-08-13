# NVIM

My NeoVim config for Windows

## Symlink

| mklink syntax         | PowerShell equivalent                                     |
| --------------------- | --------------------------------------------------------- |
| mklink Link Target    | New-Item -ItemType SymbolicLink -Name Link -Target Target |
| mklink /D Link Target | New-Item -ItemType SymbolicLink -Name Link -Target Target |
| mklink /H Link Target | New-Item -ItemType HardLink -Name Link -Target Target     |
| mklink /J Link Target | New-Item -ItemType Junction -Name Link -Target Target     |

- Link = Destination
- Target = Origin

Note: You must write the full file name and/or folder name
