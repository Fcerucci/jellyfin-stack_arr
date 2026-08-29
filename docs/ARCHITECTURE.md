# ARCHITECTURE.md

# Arquitetura da Homelab Media Stack

Este documento descreve a arquitetura oficial da Homelab Media Stack versão 1.0.

Todas as decisões arquiteturais, padrões de desenvolvimento e organização dos serviços estão documentados aqui.

---

# Objetivos

A arquitetura foi desenvolvida seguindo cinco princípios.

- Modularidade
- Simplicidade
- Segurança
- Facilidade de manutenção
- Escalabilidade

Todo o projeto foi construído para permitir expansão futura sem necessidade de alterar a estrutura existente.

---

# Visão Geral

```

Internet
│
▼
WireGuard VPN
│
▼
Gluetun
│
▼
qBittorrent
│
▼
Downloads
│
▼
Servarr
│
▼
Biblioteca
│
▼
Jellyfin
│
▼
Jellyseerr

```

---

# Componentes

## Infraestrutura

| Serviço | Responsabilidade |
|----------|------------------|
| Gluetun | VPN |
| qBittorrent | Downloads |
| FlareSolverr | Cloudflare |

---

## Gerenciamento

| Serviço | Responsabilidade |
|----------|------------------|
| Prowlarr | Indexadores |
| Sonarr | Séries |
| Radarr | Filmes |
| Lidarr | Música |
| Bazarr | Legendas |

---

## Streaming

| Serviço | Responsabilidade |
|----------|------------------|
| Jellyfin | Streaming |
| Jellyseerr | Solicitações |

---

## Automação

| Serviço | Responsabilidade |
|----------|------------------|
| Recyclarr | Perfis TRaSH |
| Unpackerr | Extração automática |

---

# Estrutura Física

```

/srv/docker/

├── compose/
├── scripts/
├── config/
├── cache/
├── data/
├── backups/
├── docs/
├── .env
└── .env.example

```

---

# Organização dos Dados

```

data/

├── media/
│
├── Movies/
├── TV/
├── Anime/
├── Music/
├── Audiobooks/
└── Books/

downloads/

├── torrents/
│
├── incomplete/
└── complete/

```

---

# Fluxo de Dados

```

Indexadores
│
▼
Prowlarr
│
▼
Sonarr/Radarr/Lidarr
│
▼
qBittorrent
│
▼
Downloads
│
▼
Unpackerr
│
▼
Importação
│
▼
Biblioteca
│
▼
Jellyfin

```

---

# Fluxo de Rede

```

Internet
│
▼
WireGuard
│
▼
Gluetun
│
▼
qBittorrent

```

Os demais containers comunicam-se através da rede Docker interna.

---

# Redes Docker

## media

Rede interna utilizada por todos os containers da stack.

Objetivo:

- Comunicação entre serviços
- DNS interno do Docker
- Isolamento da aplicação

---

## proxy

Rede utilizada exclusivamente para publicação através do Traefik.

---

# Docker Compose

Cada serviço possui seu próprio arquivo Compose.

```

compose/

gluetun.yml

qbittorrent.yml

prowlarr.yml

sonarr.yml

radarr.yml

lidarr.yml

bazarr.yml

jellyfin.yml

jellyseerr.yml

recyclarr.yml

unpackerr.yml

flaresolverr.yml

main-compose.yml

```

---

# Scripts

Todos os scripts utilizam a biblioteca comum:

```

scripts/

common.sh

```

Scripts disponíveis.

| Script | Função |
|----------|--------|
| up.sh | Inicia a stack |
| down.sh | Para a stack |
| restart.sh | Reinicia |
| status.sh | Status |
| logs.sh | Logs |
| update.sh | Atualização |
| health.sh | Verificação |

---

# Estrutura dos Volumes

Todos os containers seguem o mesmo padrão.

```

config/

/data

/cache

```

Isso garante compatibilidade entre todos os serviços.

---

# Convenções

## Compose

Um serviço por arquivo.

---

## Volumes

Sempre utilizando bind mounts.

---

## Networks

Apenas duas redes.

```

media

proxy

```

---

## Configuração

Centralizada no arquivo:

```

.env

```

---

# ADRs

As principais decisões arquiteturais encontram-se documentadas em:

```

docs/ADR/

```

Principais decisões.

- Arquitetura modular
- Compose independentes
- Main Compose
- VPN obrigatória para downloads
- Hardlinks
- Docker Networks
- Scripts compartilhados
- Configuração centralizada

---

# Roadmap

## Versão 1.0

- Stack completa
- Scripts
- Documentação
- Diagramas
- Testes

---

## Versão 1.1

Melhorias incrementais mantendo compatibilidade.

---

## Versão 2.0

Novas funcionalidades sem alterar a arquitetura base.

---

# Filosofia do Projeto

A arquitetura foi desenvolvida priorizando:

- Clareza
- Reutilização
- Modularidade
- Facilidade de manutenção
- Baixo acoplamento
- Evolução incremental

Todas as alterações futuras deverão preservar esses princípios.
