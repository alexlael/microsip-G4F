# Roadmap — MicroSIP G4F

Direção do projeto: o que já foi feito e o que está planejado.
Documento vivo — atualizar conforme as features evoluem.

> ⚠️ **Não** colocar segredos aqui (senhas de admin, credenciais, tokens, etc.).

---

## ✅ Produção (versão 3.22.8)

- **Identidade própria G4FSIP** — pasta de instalação, `%APPDATA%\G4FSIP` e `Software\G4FSIP` totalmente independentes de qualquer MicroSIP já presente na máquina.
- **Modo administrador** — item de menu + senha (somente o *hash* no exe) destrava Conta e Configurações na sessão; o que o admin salvar persiste no `.ini` (`policySeeded`) e vira a configuração travada do usuário.
- **Configurações travadas, nada oculto** — usuário comum vê tudo mas só altera a **barra de volume do toque**; o resto só no modo admin.
- **Padrões da empresa forçados (semear uma vez)** — codecs **G.711 A/u-law + G.729**, **atendimento automático "todas as chamadas" (3 s)**, **gravação MP3**, bloquear entrante "botão de controle", tons do teclado, aparecer no topo, etc.
- **Conta** — usuário comum só edita **ramal e senha**; "Tornar Ativo" só muda no modo admin (conta sempre ativa para o usuário).
- **Assinatura digital** (code signing G4F) do executável e do instalador.

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

### 1. Certificado de code signing comercial — *recomendado*
Hoje o exe e o instalador são assinados com certificado **autoassinado** da G4F
(a TI precisa distribuir o `.cer` como Raiz/Editor Confiável nas máquinas). Um
certificado **OV de CA pública** tornaria o binário confiável em qualquer máquina
sem instalar nada antes, e ajuda a evitar bloqueios de microfone por EDR.

### 2. (Futuro) Política centralizada — *se crescer*
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
