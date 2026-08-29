# BACKUP.md

# Backup e Restauração

Este documento descreve a estratégia oficial de backup da Homelab Media Stack.

O objetivo é permitir a recuperação completa da stack em caso de falha do servidor, migração para um novo hardware ou reinstalação do sistema operacional.

---

# Estratégia

A stack foi projetada para separar claramente:

- Configuração
- Dados
- Cache
- Downloads temporários

Isso permite reduzir significativamente o tamanho dos backups.

---

# Estrutura

```
/srv/docker

config/
cache/
data/
backups/
compose/
scripts/
docs/

.env
```

---

# O que deve ser salvo

## Obrigatório

```
config/
```

Contém toda a configuração dos containers.

---

```
compose/
```

Todos os Docker Compose.

---

```
scripts/
```

Scripts de gerenciamento.

---

```
docs/
```

Documentação do projeto.

---

```
.env
```

Configuração específica da instalação.

---

```
backups/
```

Caso existam backups gerados pelos próprios serviços.

---

# Backup opcional

## Biblioteca de mídia

```
data/media/
```

Este diretório normalmente representa a maior parte do armazenamento.

Caso a biblioteca possa ser recriada através dos downloads, seu backup pode ser opcional.

Caso contenha arquivos pessoais, recomenda-se backup completo.

---

# Não é necessário

## Cache

```
cache/
```

Pode ser recriado automaticamente.

---

## Downloads incompletos

```
data/downloads/torrents/incomplete
```

Nunca devem ser incluídos.

---

## Downloads concluídos

```
data/downloads/torrents/complete
```

Opcional.

Após importação pelo Servarr normalmente podem ser removidos.

---

## Transcodes

```
cache/jellyfin/transcodes
```

Nunca precisam de backup.

---

# Backup manual

Exemplo utilizando tar.

```
tar czf homelab-backup.tar.gz \
config \
compose \
scripts \
docs \
.env
```

---

# Backup da biblioteca

```
tar czf media-backup.tar.gz \
data/media
```

---

# Restaurando a Stack

## 1.

Instale:

- Docker
- Docker Compose

---

## 2.

Crie:

```
/srv/docker
```

---

## 3.

Extraia os arquivos.

```
tar xzf homelab-backup.tar.gz
```

---

## 4.

Verifique:

```
.env
```

Caso tenha mudado de servidor:

- TZ
- PUID
- PGID
- WireGuard
- Portas

---

## 5.

Crie as redes Docker.

```
docker network create media

docker network create proxy
```

---

## 6.

Suba toda a stack.

```
./scripts/up.sh
```

---

## 7.

Execute:

```
./scripts/health.sh
```

Todos os serviços deverão aparecer como Running.

---

# Migração para outro servidor

Ordem recomendada.

1. Backup

↓

2. Instalar Docker

↓

3. Restaurar arquivos

↓

4. Restaurar biblioteca

↓

5. Criar redes

↓

6. Executar up.sh

↓

7. Validar health.sh

---

# Frequência recomendada

| Item | Frequência |
|--------|------------|
| config | Diária |
| .env | Após alterações |
| compose | Após alterações |
| scripts | Após alterações |
| docs | Após alterações |
| media | Semanal ou conforme necessidade |

---

# Verificação do Backup

Após gerar o backup:

- Verificar tamanho do arquivo
- Testar descompressão
- Validar integridade
- Confirmar presença do `.env`

Nunca considere um backup válido sem testar a restauração.

---

# Disaster Recovery Checklist

- [ ] Backup disponível
- [ ] Docker instalado
- [ ] Docker Compose instalado
- [ ] Redes Docker criadas
- [ ] Arquivos restaurados
- [ ] Biblioteca restaurada
- [ ] Stack iniciada
- [ ] Health Check aprovado
- [ ] Interfaces Web acessíveis
