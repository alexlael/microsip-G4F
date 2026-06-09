; Instalador do MicroSIP G4F (Inno Setup 6)
; Empacota o microsip.exe customizado (logo G4F, configuracoes travadas).
; Compilar a partir desta pasta: ISCC.exe microsip-g4f.iss
; O exe vem de ..\Release\microsip.exe (saida do build Release|Win32).

#define MyAppName "MicroSIP G4F"
#define MyAppVersion "3.22.5"
#define MyAppPublisher "G4F / Advance Telecom"
#define MyAppExeName "microsip.exe"

[Setup]
AppId={{7F3A9C21-4B5E-4D8A-9C2F-1E6B0A4D7C88}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://www.advancetelecom.com.br/
DefaultDirName={autopf}\MicroSIP G4F
DefaultGroupName=MicroSIP G4F
DisableProgramGroupPage=yes
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
OutputDir=C:\Users\alex.lira\Documents\msip-build\installer
OutputBaseFilename=MicroSIP-G4F-Setup-{#MyAppVersion}
SetupIconFile=..\res\microsip.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
CloseApplications=yes
ArchitecturesAllowed=x86 x64compatible
; app de 32 bits -> instala em Program Files (x86) em sistemas 64 bits
ArchitecturesInstallIn64BitMode=

[Languages]
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "startupicon"; Description: "Iniciar o {#MyAppName} automaticamente com o Windows"; GroupDescription: "Inicializacao:"; Flags: unchecked

[Files]
Source: "..\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Desinstalar {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Parameters: "/minimized"; Tasks: startupicon

[Registry]
; Registra o caminho da instalacao para o MicroSIP rodar em modo "instalado"
; (config em %APPDATA%\MicroSIP, sem criar .ini junto do exe / na area de trabalho).
Root: HKA; Subkey: "Software\MicroSIP"; ValueType: string; ValueName: ""; ValueData: "{app}"; Flags: uninsdeletekey

; Protocolos de chamada (tel/sip/callto) -> abrem no MicroSIP G4F
Root: HKA; Subkey: "Software\Classes\tel"; ValueType: string; ValueName: ""; ValueData: "URL:tel Protocol"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\tel"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKA; Subkey: "Software\Classes\tel\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\tel\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\sip"; ValueType: string; ValueName: ""; ValueData: "URL:sip Protocol"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\sip"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKA; Subkey: "Software\Classes\sip\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\sip\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\callto"; ValueType: string; ValueName: ""; ValueData: "URL:callto Protocol"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\callto"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKA; Subkey: "Software\Classes\callto\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\callto\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
