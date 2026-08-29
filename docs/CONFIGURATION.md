# CONFIGURATION.md

# Configuração da Homelab Media Stack

Este documento descreve a configuração inicial de todos os serviços da Homelab Media Stack.

A ordem apresentada deve ser seguida para evitar dependências não resolvidas entre os serviços.

---

# Fluxo de Configuração

```
Gluetun
    ↓
qBittorrent
    ↓
Prowlarr
    ↓
FlareSolverr
    ↓
Sonarr
    ↓
Radarr
    ↓
Lidarr
    ↓
Bazarr
    ↓
Recyclarr
    ↓
Unpackerr
    ↓
Jellyfin
    ↓
Jellyseerr
```

---

# 1. Gluetun

## Objetivo

Responsável por proteger todo o tráfego do qBittorrent através da VPN.

## Verificar

- Container iniciado
- VPN conectada
- IP público alterado
- Kill Switch ativo

## Testes

Verificar logs.

```
docker logs gluetun
```

Deverá existir uma mensagem semelhante:

```
Connected to WireGuard
```

---

# 2. qBittorrent

## Acesso

```
http://IP:8080
```

## Configurar

### Downloads

```
/data/downloads/torrents/incomplete
```

### Downloads concluídos

```
/data/downloads/torrents/complete
```

### Categoria

Nenhuma.

As categorias serão criadas posteriormente pelos aplicativos Servarr.

### Interface Web

Alterar:

- usuário
- senha

### Verificações

- Download funcionando
- Interface acessível
- Comunicação com Gluetun

---

# 3. Prowlarr

## Objetivo

Centralizar todos os indexadores.

## Configurar

Adicionar:

- Indexadores
- API Keys
- FlareSolverr (quando necessário)

## Integrações

Adicionar:

- Sonarr
- Radarr
- Lidarr

Sincronizar.

---

# 4. FlareSolverr

Necessário apenas para indexadores protegidos pelo Cloudflare.

Verificar:

```
http://IP:8191
```

---

# 5. Sonarr

## Root Folder

```
/data/media/TV
```

## Download Client

Adicionar:

qBittorrent

Categoria:

```
tv
```

## Indexadores

Recebidos automaticamente do Prowlarr.

---

# 6. Radarr

## Root Folder

```
/data/media/Movies
```

Categoria:

```
movies
```

Download Client:

qBittorrent

---

# 7. Lidarr

## Root Folder

```
/data/media/Music
```

Categoria

```
music
```

---

# 8. Bazarr

Adicionar:

- Sonarr
- Radarr

Configurar idiomas.

Exemplo.

```
Italiano

Português

Inglês
```

---

# 9. Recyclarr

Objetivo:

Sincronizar automaticamente os perfis TRaSH Guides.

Verificar logs.

```
docker logs recyclarr
```

---

# 10. Unpackerr

Adicionar APIs:

Sonarr

Radarr

Lidarr

Configurar:

```
/data/downloads
```

---

# 11. Jellyfin

Criar bibliotecas.

Filmes

```
/data/media/Movies
```

Séries

```
/data/media/TV
```

Anime

```
/data/media/Anime
```

Música

```
/data/media/Music
```

Audiobooks

```
/data/media/Audiobooks
```

Livros

```
/data/media/Books
```

---

# 12. Jellyseerr

Adicionar:

Servidor Jellyfin

API Key

Configurar usuários.

---

# Comunicação entre Serviços

```
Prowlarr
    ↓
Sonarr

Prowlarr
    ↓
Radarr

Prowlarr
    ↓
Lidarr

Sonarr
    ↓
qBittorrent

Radarr
    ↓
qBittorrent

Lidarr
    ↓
qBittorrent

Bazarr
    ↓
Sonarr

Bazarr
    ↓
Radarr

Jellyseerr
    ↓
Jellyfin
```

---

# Categorias utilizadas

| Categoria | Aplicação |
|------------|-----------|
| tv | Sonarr |
| movies | Radarr |
| music | Lidarr |

---

# Root Folders

| Serviço | Caminho |
|----------|----------|
| Sonarr | /data/media/TV |
| Radarr | /data/media/Movies |
| Lidarr | /data/media/Music |

---

# Download Folder

Todos os serviços utilizam:

```
/data/downloads
```

---

# Checklist

## VPN

- [ ] Gluetun conectado

## Downloads

- [ ] qBittorrent funcionando

## Indexadores

- [ ] Prowlarr sincronizado

## Servarr

- [ ] Sonarr

- [ ] Radarr

- [ ] Lidarr

## Legendas

- [ ] Bazarr

## Perfis

- [ ] Recyclarr

## Extração

- [ ] Unpackerr

## Streaming

- [ ] Jellyfin

- [ ] Jellyseerr