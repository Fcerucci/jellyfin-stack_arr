# Homelab Media Stack

Uma stack Docker modular para gerenciamento, automação e streaming de mídia, construída com foco em simplicidade, segurança e facilidade de manutenção.

---

## Objetivos

Este projeto tem como objetivo fornecer uma plataforma completa para gerenciamento de mídia utilizando Docker Compose.

Os princípios adotados durante o desenvolvimento foram:

- Arquitetura modular
- Fácil manutenção
- Containers independentes
- Segurança por padrão
- Compatibilidade com Traefik
- Suporte a VPN (Gluetun + WireGuard)
- Hardlinks para evitar duplicação de arquivos
- Estrutura preparada para expansão futura

---

# Arquitetura

```
                Internet
                     │
             WireGuard VPN
                     │
                 Gluetun
                     │
      network_mode: service:gluetun
                     │
               qBittorrent
                     │
      ┌──────────────┴──────────────┐
      │                             │
   Sonarr                      Radarr
      │                             │
      ├──────────────┐              │
      │              │              │
   Lidarr         Bazarr       Prowlarr
      │              │              │
      └──────────────┴──────────────┘
                     │
                 Jellyseerr
                     │
                  Jellyfin
```

---

# Serviços

| Serviço | Função |
|----------|--------|
| Gluetun | VPN (WireGuard/OpenVPN) |
| qBittorrent | Cliente BitTorrent |
| FlareSolverr | Bypass Cloudflare |
| Prowlarr | Gerenciamento de indexadores |
| Sonarr | Séries |
| Radarr | Filmes |
| Lidarr | Música |
| Bazarr | Legendas |
| Jellyfin | Streaming |
| Jellyseerr | Solicitações de mídia |
| Recyclarr | Sincronização de perfis TRaSH |
| Unpackerr | Extração automática |

---

# Estrutura do Projeto

```
homelab-media/

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

# Estrutura da Biblioteca

```
data/

├── media/
│   ├── Movies/
│   ├── TV/
│   ├── Anime/
│   ├── Music/
│   ├── Audiobooks/
│   └── Books/
│
└── downloads/
    ├── torrents/
    │   ├── incomplete/
    │   └── complete/
    └── usenet/
```

---

# Características

- Docker Compose modular
- Compose independentes
- Main Compose simplificado
- Scripts de gerenciamento
- Configuração centralizada via `.env`
- Hardlinks compatíveis
- Backup simplificado
- Arquitetura documentada
- Pronto para Traefik

---

# Scripts

| Script | Função |
|----------|--------|
| up.sh | Inicia toda a stack |
| down.sh | Interrompe a stack |
| restart.sh | Reinicia a stack |
| status.sh | Exibe o status dos containers |
| logs.sh | Exibe os logs |
| update.sh | Atualiza as imagens Docker |
| health.sh | Verifica rapidamente os serviços |

---

# Redes Docker

A stack utiliza duas redes Docker externas.

| Rede | Utilização |
|--------|------------|
| media | Comunicação interna entre os containers |
| proxy | Publicação via Traefik |

---

# Documentação

| Documento | Descrição |
|------------|-----------|
| INSTALL.md | Instalação completa |
| CONFIGURATION.md | Configuração dos serviços |
| BACKUP.md | Backup e restauração |
| TROUBLESHOOTING.md | Solução de problemas |
| ARCHITECTURE.md | Documentação técnica |

---

# Roadmap

## v1.0

- Arquitetura modular
- Stack completa
- Scripts de gerenciamento
- Documentação
- Diagramas Mermaid

## Futuro

- Grafana
- Prometheus
- Authentik
- Immich
- Paperless-ngx
- Monitoramento
- Backup automatizado

---

# Licença

MIT License

---

Desenvolvido para uso em Homelab utilizando Docker Compose.