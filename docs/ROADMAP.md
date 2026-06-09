# Roadmap — MicroSIP G4F

Direção do projeto: o que já foi feito e o que está planejado.
Documento vivo — atualizar conforme as features evoluem.

> ⚠️ **Não** colocar segredos aqui (senhas de admin, credenciais, tokens, etc.).

---

## ✅ Pronto (versão 3.22.5)

- **Login simplificado** — só ramal, login e senha editáveis; resto fixo/travado.
- **Configurações travadas** — só dispositivos de áudio editáveis.
- **"Bloquear chamada entrante"** removido (sempre "Não", oculto).
- **Verificar atualizações** fixo em "Nunca" e travado.
- **Idioma português (BR)** embutido no executável.
- **Ícone** com a logo da G4F.
- **Codec G.729** (bcg729) + G.711.
- **Build de voz** (sem vídeo), **executável único** (OpenSSL/CRT/MFC/G.729 estáticos).
- **Instalador** (Inno Setup), instalação **por usuário** (sem admin).
- Correção do registro SIP atrás de NAT (`rport`).
- **Log de suporte sempre ativo** (`microsip_log.txt` na pasta de instalação) — para diagnóstico.
- **"Tornar Ativo" oculto + conta sempre ativa** (bloqueada a desativação por clique).
- README + Release no GitHub com download do instalador.

---

## 🛠️ Planejado

### 1. Modo administrador (escopo local) — *prioritário*
Permitir que um usuário admin destrave as configurações, ajuste, e os valores
passem a valer (travados) para quem usar aquele MicroSIP.
→ Design detalhado em [`docs/admin-mode.md`](admin-mode.md).

**Status:** desenhado, aguardando implementação.
**Precisa definir antes:** senha do admin (vai como hash no exe) e se a política
vale por usuário Windows (AppData) ou por máquina (ProgramData).

### 2. Assinatura digital (code signing) — *opcional*
Eliminar o aviso do **SmartScreen** ("editor desconhecido") no exe e no instalador.
**Requer:** certificado de Code Signing (processo pago/externo).
**Impacto:** só comodidade na instalação; não afeta funcionamento.

### 3. (Futuro) Política centralizada — *se crescer*
Caso um dia se queira "muda uma vez, vale para todos os PCs": hospedar um arquivo
de política num servidor (URL/HTTPS ou pasta de rede) e os clientes lerem no boot.
Reaproveitaria o download que o MicroSIP já faz (`URLGetAsync`).
**Status:** ideia registrada; fora de escopo no momento (optou-se por local).

### 4. Remover item de menu "Verificar atualizações" — *pequeno*
Hoje a checagem automática está desativada, mas ainda existe a opção manual no menu.
Avaliar ocultar/remover para impedir qualquer busca de atualização.

---

## 💡 Ideias / a avaliar

- Pré-preencher o **prefixo de discagem** ou plano de discagem padrão do PBX.
- Empacotar mais de um perfil/PBX no mesmo build (seleção por parâmetro).
- Telemetria mínima de versão instalada (sem dados sensíveis) para saber o parque.

---

## Como propor/registrar novas ideias
- Para **discussão e design**: adicionar aqui ou criar um `docs/<feature>.md`.
- Para **acompanhamento de tarefas**: usar *Issues* do GitHub.
- Lembrar: cada feature nova → atualizar este arquivo e, ao lançar, criar uma
  nova **Release** (ex.: `v3.22.4`).
