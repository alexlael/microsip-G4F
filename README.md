# G4FSIP

Softphone SIP para Windows da **G4F / Advance Telecom**, baseado no **[MicroSIP](https://www.microsip.org/)** 3.22.3, com **identidade própria (G4FSIP)** e instalação **totalmente independente** de qualquer MicroSIP já presente na máquina.

O objetivo é um cliente **pré-configurado e travado**: o usuário final só digita **ramal e senha** — todo o resto já vem definido pela empresa e só pode ser alterado no **Modo administrador** (protegido por senha). Reduz erro de configuração e padroniza o parque de atendimento.

---

## ⬇️ Download

**[➡️ Baixar o instalador (última versão)](https://github.com/alexlael/microsip-G4F/releases/latest)**

Instalador mais recente: **`G4FSIP-Setup-3.22.11.exe`**.

- No início, o instalador deixa **escolher o modo de instalação**: **somente para mim** (padrão, **não** pede admin, instala em `%LocalAppData%\Programs\G4FSIP` + HKCU) ou **para todos os usuários** (pede admin/UAC, instala em `Program Files\G4FSIP` + HKLM).
- Instala em pasta própria (`G4FSIP`), **sem herdar** configurações do MicroSIP oficial. A configuração fica no `%APPDATA%` de cada usuário do Windows nos dois modos.
- Exe e instalador são **assinados digitalmente** (editor *G4F*). Em máquinas onde o certificado da G4F ainda não é confiável, o SmartScreen/Defender pode avisar até o certificado ser distribuído pela TI.

> Distribua **apenas o instalador**. Rodar o `microsip.exe` avulso entra em modo portátil, cria um `.ini` ao lado do executável e fica **sem os sinais sonoros** (os `.wav` só são instalados pelo instalador).

---

## ✨ Diferenças em relação ao MicroSIP oficial

| Área | MicroSIP oficial | **G4FSIP** |
|---|---|---|
| **Identidade / instalação** | `MicroSIP`, `%APPDATA%\MicroSIP`, `Software\MicroSIP` | **`G4FSIP`**, `%APPDATA%\G4FSIP`, `Software\G4FSIP` — **independente** do MicroSIP padrão da máquina |
| **Tela de Conta** | Todos os campos editáveis | Só **Usuário (ramal) e Senha** editáveis. Servidor/Proxy/Domínio (`g4f.advancetelecom.com.br:21225`), transporte, etc. pré-preenchidos e travados |
| **Nome de Exibição** | Manual | Preenchido automaticamente = ramal |
| **Configurações** | Tudo editável | **Travadas** para o usuário comum (nada oculto, apenas desabilitado). Exceções sempre liberadas: **dispositivos de áudio** (Ouvir toque em, Ouvir chamada em, Microfone) e a **barra de volume do toque** |
| **Modo administrador** | — | Menu **"Modo administrador…"** (senha por *hash* no exe) destrava Conta e Configurações na sessão; o que o admin salvar persiste e passa a valer (travado) para o usuário |
| **Política de configuração** | — | "Semear uma vez": na 1ª execução aplica os padrões da empresa no `.ini` (`policySeeded=1`); depois vale o `.ini`, que só o admin altera |
| **Codecs** | Configurável | Padrão: **G.711 A-law, G.711 u-law, G.729** |
| **Atendimento automático** | Desligado | **Todas as chamadas**, com demora de **3 s** |
| **Gravação de chamada** | Opcional | **Ativa** (MP3) por padrão |
| **Bloquear chamada entrante** | Configurável | Sempre **"Não"** e **oculto** da interface (inclusive no Modo administrador) |
| **Verificar atualizações** | Configurável | Padrão **"Nunca"** |
| **Conta / "Tornar Ativo"** | Múltiplas contas; clicar desativa | Usuário comum tem **conta única** (sem duplicação no menu); a conta aparece uma vez pelo nome e clicar nela a mantém ativa — não há rótulo "Tornar Ativo" e a conta não cai por clique acidental. Múltiplas contas só no Modo administrador |
| **Idioma** | Pacote externo | **Português (BR) embutido** no executável |
| **Ícone** | Logo MicroSIP | **Logo da G4F** |
| **Vídeo** | Sim | **Desabilitado** (build de voz) |
| **Distribuição** | Instalador + DLLs | **Executável único** (OpenSSL, runtime C/C++, MFC e G.729 estáticos) — sem DLLs. O instalador acompanha apenas os 6 `.wav` de sinalização sonora (bip de chamada, encerramento, toque, mensagens) |
| **Assinatura** | Assinado pelo autor | **Assinado pela G4F** (code signing) |

Os valores fixos da conta ficam em [`define.h`](MicroSIP-3.22.3-src/define.h) (`_GLOBAL_ACC_*`); os padrões forçados das Configurações ficam no bloco `policySeeded` no fim de `AccountSettings::Init` em [`settings.cpp`](MicroSIP-3.22.3-src/settings.cpp). A identidade (`_GLOBAL_NAME`) e o *hash* da senha de admin ficam em [`const.h`](MicroSIP-3.22.3-src/const.h).

---

## 🔐 Modo administrador

- Menu principal → **"Modo administrador…"** → digitar a senha (apenas o **hash SHA-256** vai no binário; trocar a senha = recompilar).
- Com o modo ativo: **Editar Conta** e **Configurações** abrem totalmente editáveis. O que for salvo persiste no `.ini` e vira a configuração travada do usuário daquela máquina.
- Selecionar o item de novo (fica com ✔) ou fechar o app desativa o modo.

> A senha **não** fica no código nem na documentação — somente o seu hash em `const.h`.

---

## 🛠️ Como compilar (reproduzir o build)

O MicroSIP é compilado **dentro** da árvore do PJSIP (pjproject).

### Pré-requisitos
- **Visual Studio 2022/2026** com **"Desenvolvimento para desktop com C++"** + **C++ MFC** + **Windows SDK 10**.
- **pjproject 2.15.1** — <https://github.com/pjsip/pjproject/releases/tag/2.15.1>
- **OpenSSL Win32** (dev) — <https://slproweb.com/products/Win32OpenSSL.html>
- **bcg729** (G.729) — <https://github.com/BelledonneCommunications/bcg729>
- **Inno Setup 6** — <https://jrsoftware.org/isdl.php>

### Compilar
Toolset **v145**, **Release | Win32** para o MicroSIP, dentro do pjproject:
```bat
MSBuild microsip\microsip.vcxproj /p:Configuration=Release /p:Platform=Win32 ^
  /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0.22621.0
```

### Assinar (code signing da G4F)
```bat
signtool sign /sha1 <thumbprint-do-cert-G4F> /fd SHA256 ^
  /tr http://timestamp.digicert.com /td SHA256 Release\microsip.exe
```

### Gerar e assinar o instalador
```bat
ISCC.exe MicroSIP-3.22.3-src\installer\g4fsip.iss
signtool sign /sha1 <thumbprint-do-cert-G4F> /fd SHA256 ^
  /tr http://timestamp.digicert.com /td SHA256 G4FSIP-Setup-3.22.11.exe
```
Saída: `G4FSIP-Setup-3.22.11.exe`.

---

## 📁 Estrutura do repositório

```
MicroSIP-3.22.3-src/
├── *.cpp / *.h            Código-fonte (C++/MFC)
├── define.h               Valores fixos da conta G4F (_GLOBAL_ACC_*)
├── const.h                Versão, identidade (G4FSIP), hash da senha de admin
├── global.cpp             Verificação da senha de admin (msip_verify_admin_password)
├── settings.cpp           Padrões forçados ("semear uma vez") em AccountSettings::Init
├── AccountDlg.cpp         Conta simplificada (ApplyDefaults / LockFields)
├── SettingsDlg.cpp        Configurações travadas (exceto volume) / destravadas p/ admin
├── mainDlg.cpp            Item de menu + diálogo do Modo administrador
├── lib/langpack.cpp       Idioma embutido
├── res/                   Ícone (logo G4F) + langpack pt-BR
├── sounds/                Sinais sonoros (.wav): bip de chamada, encerramento, toque, mensagens
└── installer/
    └── g4fsip.iss         Script do instalador (Inno Setup)
```

---

## 🗺️ Documentação

- [`docs/ROADMAP.md`](docs/ROADMAP.md) — o que já foi feito e o que está planejado.
- [`docs/admin-mode.md`](docs/admin-mode.md) — design do **modo administrador**.

> Nenhum dado sensível (senhas, credenciais) é versionado — apenas o *hash* da senha de admin.

---

## 📜 Licença

O MicroSIP é distribuído sob a **GNU GPL v2**. Este projeto é um *fork* customizado e segue a mesma licença. Bibliotecas de terceiros (PJSIP, OpenSSL, bcg729) mantêm suas respectivas licenças.

Projeto base: © MicroSIP (https://www.microsip.org). Customização: G4F / Advance Telecom.
