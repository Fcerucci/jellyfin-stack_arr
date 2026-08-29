# INSTALL.md

# Instalação

Este documento descreve o processo completo para instalar a Homelab Media Stack em um servidor Linux utilizando Docker Compose.

---

# Pré-requisitos

Antes de iniciar, certifique-se de possuir:

- Linux (Ubuntu Server recomendado)
- Docker Engine
- Docker Compose Plugin
- Git (opcional)
- Acesso sudo
- VPN WireGuard (opcional, mas recomendado)

---

# Estrutura do Projeto

A stack deverá estar organizada da seguinte forma:

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

# 1. Criar as redes Docker

Antes de iniciar qualquer container, crie as redes externas.

```bash
docker network create media

docker network create proxy
```

Verifique:

```bash
docker network ls
```

Deverão existir:

```
media

proxy
```

---

# 2. Criar a estrutura de diretórios

Crie a estrutura principal.

```bash
mkdir -p /srv/docker/medida
cd /srv/docker/media
```

Estrutura recomendada:

```
config/

cache/

data/

backups/

compose/

scripts/

docs/
```

---

# 3. Copiar os arquivos

Copie todos os arquivos do projeto para:

```
/srv/docker/media
```

---

# 4. Configurar o arquivo .env

Copie o arquivo de exemplo.

```bash
cp .env.example .env
```

Edite:

```bash
nano .env
```

Configure no mínimo:

```
TZ

PUID

PGID

VPN

WireGuard

Portas
```

---

# 5. Ajustar permissões

Verifique o UID/GID do usuário.

```bash
id
```

Exemplo:

```
uid=1000

gid=1000
```

Configure os mesmos valores no arquivo `.env`.

---

# 6. Tornar os scripts executáveis

```bash
chmod +x scripts/*.sh
```

---

# 7. Validar a configuração

Verifique se o Docker Compose reconhece todos os arquivos.

```bash
./scripts/status.sh
```

Caso ainda não existam containers, o comando deverá executar sem erros.

---

# 8. Iniciar a stack

```bash
./scripts/up.sh
```

A primeira inicialização poderá levar alguns minutos.

---

# 9. Verificar os containers

```bash
./scripts/status.sh
```

ou

```bash
docker ps
```

Todos os containers deverão estar em execução.

---

# 10. Verificar a saúde da stack

Execute:

```bash
./scripts/health.sh
```

Resultado esperado:

```
✅ gluetun

✅ qbittorrent

✅ prowlarr

...

✅ jellyfin
```

---

# Primeira configuração

Após iniciar os containers, configure os serviços na seguinte ordem.

1. Gluetun

2. qBittorrent

3. Prowlarr

4. FlareSolverr

5. Sonarr

6. Radarr

7. Lidarr

8. Bazarr

9. Recyclarr

10. Unpackerr

11. Jellyfin

12. Jellyseerr

---

# Atualizações

Para atualizar todas as imagens Docker:

```bash
./scripts/update.sh
```

---

# Reiniciar toda a stack

```bash
./scripts/restart.sh
```

---

# Parar toda a stack

```bash
./scripts/down.sh
```

---

# Logs

Logs completos:

```bash
./scripts/logs.sh
```

Logs de um container específico:

```bash
docker logs -f sonarr
```

---

# Backup

Antes de atualizar a stack, recomenda-se realizar backup de:

```
config/

backups/

.env
```

Os diretórios `cache/` e `data/downloads/` normalmente não precisam ser incluídos no backup da configuração.

---

## Checklist de Instalação

- [ ] Docker instalado
- [ ] Docker Compose instalado
- [ ] Redes `media` e `proxy` criadas
- [ ] Estrutura de diretórios criada
- [ ] Arquivo `.env` configurado
- [ ] Scripts executáveis
- [ ] Stack iniciada
- [ ] Todos os containers em execução
- [ ] `health.sh` sem erros
- [ ] Acesso às interfaces Web confirmado


# Próximos passos

Após concluir a instalação:

1. Configurar os serviços (CONFIGURATION.md)

2. Configurar backups (BACKUP.md)

3. Consultar a arquitetura (ARCHITECTURE.md)

4. Solução de problemas (TROUBLESHOOTING.md)

