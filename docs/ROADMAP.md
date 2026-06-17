# Roadmap — MicroSIP G4F

Direção do projeto: o que já foi feito e o que está planejado.
Documento vivo — atualizar conforme as features evoluem.

> ⚠️ **Não** colocar segredos aqui (senhas de admin, credenciais, tokens, etc.).

---

## ✅ Produção (versão 3.22.10)

- **Sinais sonoros** — o instalador acompanha os 6 `.wav` do MicroSIP (bip de chamada entrando, som de encerramento, toque, mensagens). Antes da 3.22.10 o build de exe único não os incluía e não havia sinalização sonora — inclusive o bip de chamada entrando com atendimento automático ligado.
- **Identidade própria G4FSIP** — pasta de instalação, `%APPDATA%\G4FSIP` e `Software\G4FSIP` totalmente independentes de qualquer MicroSIP já presente na máquina.
- **Modo administrador** — item de menu + senha (somente o *hash* no exe) destrava Conta e Configurações na sessão; o que o admin salvar persiste no `.ini` (`policySeeded`) e vira a configuração travada do usuário.
- **Configurações travadas** — usuário comum altera apenas os **dispositivos de áudio** (Ouvir toque em, Ouvir chamada em, Microfone) e a **barra de volume do toque**; o resto só no modo admin.
- **Padrões da empresa forçados (semear uma vez)** — codecs **G.711 A/u-law + G.729**, **atendimento automático "todas as chamadas" (3 s)**, **gravação MP3**, tons do teclado, aparecer no topo, etc.
- **Bloquear chamada entrante** — sempre **"Não"** e **oculto** da interface (inclusive no modo admin).
- **Verificar atualizações** — padrão **"Nunca"**.
- **Conta única (usuário comum)** — só edita **ramal e senha**; a conta aparece uma vez no menu (sem duplicação) e não há rótulo "Tornar Ativo" — clicar na conta a mantém ativa, sem cair por clique acidental. Múltiplas contas só no modo admin.
- **Assinatura digital** (code signing G4F) do executável e do instalador.

### Histórico (versão 3.22.9)

- Correções de UI: "Bloquear chamada entrante" sempre "Não" e oculto; dispositivos de áudio + volume sempre editáveis; "Verificar atualizações" padrão "Nunca"; conta única (sem duplicação no menu, sem rótulo "Tornar Ativo"). Ainda **sem** os sinais sonoros — adicionados na 3.22.10.

### Histórico (versão 3.22.8)

- Primeira versão de produção com identidade própria, modo administrador e configuração travada. Nesta versão "Bloquear chamada entrante" vinha como "Botão de controle" e "Verificar atualizações" como "Semanalmente" — ambos ajustados na 3.22.9.

### Histórico (versão 3.22.5)

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

### 1. Integração nativa com a Advance Telecom (pausas) — *prioridade*
Permitir **iniciar e encerrar pausas** do agente direto pelo G4FSIP, sem precisar
abrir outro sistema. A ideia é um botão/menu de **Pausa** na janela principal que
chama a API da Advance Telecom (autenticando com o ramal/credenciais já
configurados) para marcar entrada/saída de pausa, refletindo o estado atual na UI.

Pontos a definir:
- **API da Advance Telecom** — endpoint(s), autenticação (token/ramal), tipos de
  pausa (almoço, banheiro, treinamento, etc.) e como consultar o estado atual.
- **UI** — onde colocar o controle (barra inferior, menu ou botão dedicado) e como
  sinalizar "em pausa" (ícone/cor/tooltip), idealmente reaproveitando o status do agente.
- **Rede** — reutilizar o `URLGetAsync`/cliente HTTP que o MicroSIP já tem, com
  tratamento de erro e timeout para não travar a interface.

**Status:** desejado; aguardando a especificação da API da Advance Telecom.

### 2. Atualização automática a partir do GitHub (releases) — *prioridade*
Fazer o G4FSIP **buscar atualizações no repositório oficial** (`alexlael/microsip-G4F`)
em vez do microsip.org: a cada **Release** publicada, o app instalado nas máquinas
detecta a nova versão e se atualiza.

Esboço de implementação:
- Apontar a checagem de versão para a **API de releases do GitHub**
  (`https://api.github.com/repos/alexlael/microsip-G4F/releases/latest`) e comparar
  a `tag_name` com `_GLOBAL_VERSION`.
- Baixar o instalador assinado (`G4FSIP-Setup-x.y.z.exe`) do *asset* da release e
  executá-lo (instalação por usuário, silenciosa quando possível).
- Como a 3.22.9 deixa "Verificar atualizações" em **"Nunca"** por padrão, este
  mecanismo seria um **canal próprio** (independente do updater do microsip.org),
  para a TI controlar o rollout pelo repositório.
- Reaproveitar a assinatura de código G4F para validar o binário baixado.

**Status:** desejado; substitui/!complementa o updater original do MicroSIP.

### 3. Certificado de code signing comercial — *recomendado*
Hoje o exe e o instalador são assinados com certificado **autoassinado** da G4F
(a TI precisa distribuir o `.cer` como Raiz/Editor Confiável nas máquinas). Um
certificado **OV de CA pública** tornaria o binário confiável em qualquer máquina
sem instalar nada antes, e ajuda a evitar bloqueios de microfone por EDR.

### 4. (Futuro) Política centralizada — *se crescer*
Caso um dia se queira "muda uma vez, vale para todos os PCs": hospedar um arquivo
de política num servidor (URL/HTTPS ou pasta de rede) e os clientes lerem no boot.
Reaproveitaria o download que o MicroSIP já faz (`URLGetAsync`).
**Status:** ideia registrada; fora de escopo no momento (optou-se por local).

### 5. Remover item de menu "Verificar atualizações" — *pequeno*
Hoje a checagem automática está desativada, mas ainda existe a opção manual no menu.
Avaliar ocultar/remover para impedir qualquer busca de atualização (considerar junto
com o item 2, que troca o updater para o GitHub).

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
