Set shl = WScript.CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set shl = CreateObject("WScript.Shell")

path = shl.ExpandEnvironmentStrings("%appdata%") & "\growers"

if ( fso.FolderExists(path) ) then 
    shl.Run "growersd.exe", 0, false
    MsgBox "GrowersCoin is running now. If you want to stop it, run the 'Stop daemon' script."
else
    MsgBox "Data directory not found. Please run growersd from a command prompt and follow instructions."
end if
