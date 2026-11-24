#define AppName "The Sea Life"
#define AppVersion "26.06"
#define AppPublisher "Personal custom build"
#define AppExeName "7zFM.exe"

[Setup]
AppId={{F6B5A537-4EC6-4803-94C2-5196AEB17BAC}}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={localappdata}\Programs\{#AppName}
DefaultGroupName={#AppName}
OutputDir=..\releases
OutputBaseFilename={#AppName}-{#AppVersion}-x64-Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=lowest
WizardStyle=modern
UninstallDisplayIcon={app}\{#AppExeName}
ChangesAssociations=yes

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Files]
Source: "..\build\staging\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\scripts\Set-Associations.ps1"" -Root ""{app}"""; Flags: runhidden waituntilterminated; StatusMsg: "Registering file associations..."

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\scripts\Remove-Associations.ps1"" -Root ""{app}"""; Flags: runhidden waituntilterminated
