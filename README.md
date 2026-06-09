# MicroSIP G4F

Versão customizada do **[MicroSIP](https://www.microsip.org/)** 3.22.3 (softphone SIP para Windows) preparada para os ramais do PBX **G4F / Advance Telecom**.

O objetivo é um cliente **pré-configurado e travado**: o usuário final só precisa digitar **ramal, login e senha** — todo o resto já vem definido e não pode ser alterado, reduzindo erro de configuração no atendimento.

---

## ⬇️ Download

**[➡️ Baixar o instalador (última versão)](https://github.com/alexlael/microsip-G4F/releases/latest)**

Na página de *Releases*, baixe o arquivo **`MicroSIP-G4F-Setup-3.22.3.exe`**.

- Instalação **por usuário** (não pede senha de administrador).
- Cria atalhos (Menu Iniciar / Área de Trabalho) e desinstalador.
- Na primeira vez, o Windows pode mostrar o aviso do **SmartScreen** ("editor desconhecido"), pois o instalador não é assinado digitalmente → **Mais informações → Executar assim mesmo**.

> Distribua **apenas o instalador**. Evite copiar o `microsip.exe` avulso, pois rodando "solto" ele entra em modo portátil e cria um `.ini` ao lado do executável.

---

## ✨ Diferenças em relação ao MicroSIP oficial

| Área | MicroSIP oficial | **MicroSIP G4F** |
|---|---|---|
| **Tela de Conta** | Todos os campos editáveis | Só **Usuário, Login e Senha** editáveis. Servidor/Proxy/Domínio (`g4f.advancetelecom.com.br:21225`), transporte (UDP+TCP), porta, etc. **fixos e travados** |
| **Nome de Exibição** | Manual | Preenchido automaticamente = ramal |
| **Configurações** | Tudo editável | **Travadas**. Só os 3 dispositivos de áudio (toque / alto-falante / microfone) são editáveis |
| **Codecs** | Configurável | Fixo: **G.711 A-law, G.711 u-law, G.729** |
| **Bloquear chamada entrante** | Visível/configurável | **Removido** da tela (sempre "Não") |
| **Verificar atualizações** | Semanal por padrão | Fixo em **"Nunca"** e travado |
| **Idioma** | Pacote externo (`langpack_*.txt`) | **Português (BR) embutido** no executável |
| **Ícone** | Logo MicroSIP | **Logo da G4F** |
| **Vídeo** | Sim | **Desabilitado** (build voz) |
| **Distribuição** | Instalador + DLLs | **Executável único** (OpenSSL, runtime C/C++, MFC e G.729 todos estáticos) — sem DLLs, sem Visual C++ Redistributable |

Os valores fixos da conta ficam em [`define.h`](MicroSIP-3.22.3-src/define.h) (`_GLOBAL_ACC_*`); os ajustes fixos das Configurações ficam no fim de `AccountSettings::Init` em [`settings.cpp`](MicroSIP-3.22.3-src/settings.cpp).

---

## 🛠️ Como compilar (reproduzir o build)

O MicroSIP é compilado **dentro** da árvore do PJSIP (pjproject). Resumo do ambiente que funciona:

### Pré-requisitos
- **Visual Studio 2022/2026** com a carga **"Desenvolvimento para desktop com C++"** + componente **C++ MFC** + **Windows SDK 10**.
- **pjproject 2.15.1** — código-fonte: <https://github.com/pjsip/pjproject/releases/tag/2.15.1>
- **OpenSSL Win32** (pacote de desenvolvedor): <https://slproweb.com/products/Win32OpenSSL.html>
- **bcg729** (codec G.729): <https://github.com/BelledonneCommunications/bcg729>
- **Inno Setup 6** (para gerar o instalador): <https://jrsoftware.org/isdl.php>

### Montagem das pastas
1. Extraia o `pjproject-2.15.1`.
2. Coloque este repositório (a pasta `MicroSIP-3.22.3-src`) **dentro** do pjproject, com o nome `microsip` (pode ser uma junção/`mklink /J`), de forma que `..\pjlib`, `..\pjsip` etc. resolvam a partir dela.
3. Crie `pjlib/include/pj/config_site.h` com:
   ```c
   #define PJ_HAS_SSL_SOCK 1
   #define PJMEDIA_HAS_VIDEO 0
   #define PJMEDIA_HAS_BCG729 1
   ```
4. Compile a **bcg729** como lib estática `/MT` (`bcg729.lib`).

### Compilar
Toolset **v145**, **Release-Static | Win32** para o pjproject e **Release | Win32** para o MicroSIP, injetando os caminhos de OpenSSL/bcg729 e `BCG729_STATIC`:

```bat
:: 1) pjproject (gera libpjproject-...-Release-Static.lib)
MSBuild pjproject-vs14.sln /t:libpjproject /p:Configuration=Release-Static /p:Platform=Win32 ^
  /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0.26100.0 ^
  /p:ForceImportBeforeCppTargets=<...>\deps.props

:: 2) MicroSIP (gera microsip.exe)
MSBuild microsip\microsip.vcxproj /p:Configuration=Release /p:Platform=Win32 ^
  /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0.26100.0 ^
  /p:ForceImportBeforeCppTargets=<...>\deps.props
```

Onde `deps.props` adiciona `IncludePath`/`LibraryPath` do OpenSSL e da bcg729 e define `BCG729_STATIC`.

### Gerar o instalador
```bat
ISCC.exe MicroSIP-3.22.3-src\installer\microsip-g4f.iss
```
Saída: `MicroSIP-G4F-Setup-3.22.3.exe`.

> A "receita" completa (toolset, props, comandos) está documentada nos commits e no histórico do projeto.

---

## 📁 Estrutura do repositório

```
MicroSIP-3.22.3-src/
├── *.cpp / *.h            Código-fonte (C++/MFC)
├── define.h               Valores fixos da conta G4F (_GLOBAL_ACC_*)
├── const.h                Versão, nome, vídeo on/off
├── settings.cpp           Configurações fixas/travadas (AccountSettings::Init)
├── AccountDlg.cpp         Tela de conta simplificada (ApplyDefaultsAndLock)
├── SettingsDlg.cpp        Tela de configurações travada
├── lib/langpack.cpp       Carregamento do idioma embutido
├── res/
│   ├── microsip.ico       Ícone (logo G4F)
│   └── langpack_portuguesebr.txt   Tradução pt-BR (embutida via RCDATA)
└── installer/
    └── microsip-g4f.iss   Script do instalador (Inno Setup)
```

---

## 🎯 Principais customizações no código

- **Login simplificado:** `AccountDlg::ApplyDefaultsAndLock` + bloco fixo em `AccountDlg::OnBnClickedOk`; constantes em `define.h`.
- **Configurações travadas:** bloco no fim de `AccountSettings::Init` (`settings.cpp`) + desabilitação dos controles em `SettingsDlg::OnInitDialog`.
- **Idioma embutido:** `res/langpack_portuguesebr.txt` como recurso `IDR_LANGPACK_PTBR` (`main.rc`), carregado por `LoadLangPackModule` (`lib/langpack.cpp`).
- **G.729:** `PJMEDIA_HAS_BCG729` + lib `bcg729` estática.
- **Build voz/único:** `_GLOBAL_VIDEO` desativado em `const.h`; OpenSSL/CRT/MFC/G729 estáticos.

---

## 🗺️ Roadmap e documentação

- [`docs/ROADMAP.md`](docs/ROADMAP.md) — o que já foi feito e o que está planejado.
- [`docs/admin-mode.md`](docs/admin-mode.md) — design da feature de **modo administrador** (destravar configurações com login de admin).

> Documentação de direção/arquitetura fica em `docs/`. Nenhum dado sensível (senhas, credenciais) é versionado.

---

## 📜 Licença

O MicroSIP é distribuído sob a **GNU GPL v2**. Este projeto é um *fork* customizado e segue a mesma licença. Bibliotecas de terceiros (PJSIP, OpenSSL, bcg729) mantêm suas respectivas licenças.

Projeto base: © MicroSIP (https://www.microsip.org). Customização: G4F / Advance Telecom.
