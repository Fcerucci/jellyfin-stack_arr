# TROUBLESHOOTING.md

# Solução de Problemas

Este documento reúne os problemas mais comuns encontrados durante a instalação e utilização da Homelab Media Stack.

Os tópicos estão organizados por sintoma para facilitar o diagnóstico.

---

# Índice

1. Containers não iniciam
2. VPN não conecta
3. qBittorrent não baixa
4. Sonarr/Radarr não importam arquivos
5. Hardlinks não funcionam
6. Jellyfin não encontra mídia
7. Jellyseerr não adiciona solicitações
8. Prowlarr não sincroniza indexadores
9. FlareSolverr não responde
10. Problemas de permissões
11. Redes Docker
12. Health Check

---

# Containers não iniciam

## Sintoma

Um ou mais containers permanecem em estado:

```
Exited
```

ou

```
Restarting
```

## Verificações

Verifique:

```bash
./scripts/status.sh
```

Depois:

```bash
docker logs <container>
```

Verifique:

- Arquivo `.env`
- Volumes
- Networks
- Permissões

---

# VPN não conecta

## Sintoma

Gluetun permanece reiniciando.

## Verificar

```bash
docker logs gluetun
```

Possíveis causas:

- Chave WireGuard inválida
- Endpoint incorreto
- Servidor VPN indisponível
- Firewall

---

# qBittorrent não baixa

## Verificar

- Gluetun conectado
- Internet funcionando
- Indexador disponível
- Categoria correta

Executar:

```bash
docker exec qbittorrent ping 1.1.1.1
```

---

# Sonarr/Radarr não importam arquivos

## Sintoma

Download concluído, mas não aparece na biblioteca.

Verificar:

- Root Folder
- Categoria
- Download Client
- Permissões

Confirmar:

```
/data/downloads

/data/media
```

são exatamente iguais em todos os containers.

---

# Hardlinks não funcionam

## Sintoma

Os arquivos são copiados em vez de movidos instantaneamente.

Verificar:

```
downloads/

media/
```

Devem estar no mesmo filesystem.

Também confirmar que todos utilizam:

```
/data
```

como diretório raiz.

---

# Jellyfin não encontra filmes

## Verificar

Bibliotecas.

Exemplo:

```
Movies

/data/media/Movies
```

Depois:

```
Dashboard

↓

Libraries

↓

Scan All Libraries
```

Verificar permissões.

---

# Jellyseerr não funciona

Verificar:

- URL do Jellyfin
- API Key
- Usuário administrador

Executar teste de conexão.

---

# Prowlarr não envia indexadores

Verificar:

Settings

↓

Apps

↓

Test

↓

Sync

Conferir API Key do Sonarr, Radarr e Lidarr.

---

# FlareSolverr não responde

Verificar:

```bash
docker logs flaresolverr
```

Executar:

```
http://IP:8191
```

Se não responder:

Reiniciar:

```bash
docker restart flaresolverr
```

---

# Problemas de permissões

Verificar:

```bash
id
```

Confirmar:

```
PUID

PGID
```

Conferir proprietário dos diretórios.

```bash
ls -la
```

---

# Problemas de rede

Verificar:

```bash
docker network ls
```

Devem existir:

```
media

proxy
```

Depois:

```bash
docker network inspect media
```

Confirmar que todos os serviços pertencem à rede.

---

# Health Check

Executar:

```bash
./scripts/health.sh
```

Todos deverão aparecer como:

```
Running
```

Caso contrário:

Consultar os logs.

---

# Comandos úteis

Status

```bash
./scripts/status.sh
```

Logs

```bash
./scripts/logs.sh
```

Atualizar

```bash
./scripts/update.sh
```

Reiniciar

```bash
./scripts/restart.sh
```

Parar

```bash
./scripts/down.sh
```

Subir

```bash
./scripts/up.sh
```

---

# Fluxo de Diagnóstico

Problema observado
        │
        ▼
health.sh
        │
        ▼
status.sh
        │
        ▼
docker logs <container>
        │
        ▼
Verificar volumes
        │
        ▼
Verificar redes
        │
        ▼
Verificar permissões
        │
        ▼
Testar comunicação entre containers

# Checklist de Diagnóstico

- [ ] Docker em execução
- [ ] Docker Compose funcionando
- [ ] Redes criadas
- [ ] Containers iniciados
- [ ] Health Check aprovado
- [ ] VPN conectada
- [ ] Prowlarr sincronizado
- [ ] qBittorrent conectado
- [ ] Servarr configurado
- [ ] Jellyfin acessível
- [ ] Jellyseerr acessível