# Design — Modo Administrador (escopo local)

**Implementado (produção, v3.22.8).** Permite que um **admin** destrave as
configurações fixas, ajuste-as, e os novos valores fiquem (travados) para quem
usar aquele G4FSIP.

## Como está implementado
- Menu principal → **"Modo administrador…"** abre um diálogo (`IDD_ADMIN_LOGIN`) pedindo a senha.
- A senha é comparada por **hash SHA-256** (`msip_verify_admin_password` em `global.cpp`) com `_GLOBAL_ADMIN_PASSWORD_HASH` em `const.h`. Só o hash vai no binário; trocar a senha = recompilar.
- Sucesso → `msip_admin_mode = true` (flag de sessão). As travas de `SettingsDlg` e `AccountDlg` respeitam `if (!msip_admin_mode)`.
- Persistência: padrões aplicados via "semear uma vez" (`policySeeded=1` no `.ini`, em `AccountSettings::Init`). O que o admin salva sobrescreve e persiste.

> ⚠️ Este documento descreve **como** fazer. A senha de admin **não** fica aqui
> nem em texto no código — apenas o seu *hash*.

---

## Conceito

Hoje as travas são "hard-coded": a cada inicialização o app **força** os valores
do código e trava a interface. Isso impede que o admin altere algo de forma
persistente (o próximo boot apagaria).

A mudança central é trocar **"forçar sempre"** por **"semear uma vez"**:

```
1ª execução  : aplica os defaults do código (semente) e grava no .ini
demais boots : lê do .ini (= o que o admin configurou) e trava a UI
```

Como a interface fica **travada para o usuário comum**, ninguém além do admin
altera o `.ini` → os valores permanecem como o admin definiu, para todos que
usarem aquele MicroSIP.

---

## Componentes

### 1. Login de administrador
- Item de menu **"Modo administrador…"** que abre um diálogo pedindo a senha.
- A senha é comparada por **hash** (reaproveitar `lib/Crypto`). Só o hash vai no
  binário; trocar a senha = recompilar.
- Sucesso → ativa uma flag de sessão `g_adminMode = true`.

### 2. Destravar condicional (reuso do que já existe)
- `AccountDlg::ApplyDefaultsAndLock` e os `EnableWindow(FALSE)` da `SettingsDlg`
  passam a respeitar `if (!g_adminMode)`.
- Admin logado → todos os campos editáveis. Usuário comum → travado como hoje.

### 3. Persistência
- Admin edita e salva pelo fluxo normal (que já grava no `.ini`).
- O bloco "forçado" em `AccountSettings::Init` vira "semear se ainda não existe"
  (ex.: marca uma chave `policySeeded=1` no `.ini` na primeira vez).

---

## Onde guardar a política

| Cenário | Local | Observação |
|---|---|---|
| 1 usuário Windows por PC (comum) | `%APPDATA%\MicroSIP\*.ini` | já é assim; vale p/ todo agente naquele MicroSIP |
| Vários usuários Windows no PC | `%ProgramData%\MicroSIP-G4F\policy.ini` | lido "por cima" no boot; vale p/ todos os usuários da máquina |

---

## Segurança (limites conhecidos)
- O `.ini` é editável pelo dono da sessão Windows. A trava é de **interface**
  (protegida por senha), **não** à prova de edição manual do arquivo.
- Blindagem opcional: **assinar/criptografar** a seção de política no `.ini`
  (via `Crypto`), de forma que edição manual seja detectada e ignorada.
- Para um call center, o modelo "trava de UI + senha de admin" costuma bastar.

---

## Mudanças previstas no código

| Peça | Arquivo | Mudança |
|---|---|---|
| "Forçar" → "semear" | `settings.cpp` | aplicar defaults só se a política ainda não foi semeada |
| Flag de sessão | global | `bool g_adminMode` |
| Login admin | menu + diálogo | item de menu + verificação de hash (`Crypto`) |
| Destravar | `AccountDlg.cpp`, `SettingsDlg.cpp` | `if (!g_adminMode)` nas travas existentes |
| (opcional) política de máquina | `settings.cpp` | ler `%ProgramData%\...\policy.ini` por cima |

---

## Definições necessárias antes de implementar
1. **Senha do admin** (entra como hash no exe; informada fora do Git).
2. Escopo de persistência: **por usuário Windows** (AppData) ou **por máquina** (ProgramData).
