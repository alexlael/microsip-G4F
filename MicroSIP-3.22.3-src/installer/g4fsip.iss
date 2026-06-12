; Instalador do G4FSIP (Inno Setup 6)
; Softphone da G4F baseado no MicroSIP oficial 3.22.3, com identidade propria
; (G4FSIP): pasta de instalacao, %APPDATA%\G4FSIP e registro Software\G4FSIP
; totalmente independentes do MicroSIP padrao.
; Compilar a partir desta pasta: ISCC.exe g4fsip.iss
; O exe vem de ..\Release\microsip.exe (saida do build Release|Win32).

#define MyAppName "G4FSIP"
#define MyAppVersion "3.22.8"
#define MyAppPublisher "G4F / Advance Telecom"
#define MyAppExeName "microsip.exe"

[Setup]
; AppId proprio (diferente do "MicroSIP G4F" antigo e do MicroSIP oficial)
AppId={{2717F467-9AB3-4DF2-8C9D-C9200DF1D4F4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://www.advancetelecom.com.br/
DefaultDirName={autopf}\G4FSIP
DefaultGroupName=G4FSIP
DisableProgramGroupPage=yes
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
OutputDir=C:\Users\alex.lira\Documents\msip-build\installer
OutputBaseFilename=G4FSIP-Setup-{#MyAppVersion}
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
; Registra o caminho da instalacao para o G4FSIP rodar em modo "instalado"
; (config em %APPDATA%\G4FSIP, sem criar .ini junto do exe).
; Chave propria (G4FSIP), separada do MicroSIP oficial: nada e compartilhado
; com o Software\MicroSIP das maquinas que ja tem o MicroSIP padrao.
Root: HKA; Subkey: "Software\G4FSIP"; ValueType: string; ValueName: ""; ValueData: "{app}"; Flags: uninsdeletekey

; Protocolos de chamada (tel/sip/callto) -> abrem no G4FSIP
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
