# Seerr Migration Guide

## Overview

This document describes the migration from **Jellyseerr** to **Seerr** in the `jellyfin-stack_arr` Docker stack.

The migration replaces:

```text
fallenbagel/jellyseerr:latest
```

with:

```text
ghcr.io/seerr-team/seerr:latest
```

The existing Jellyseerr configuration and database are preserved.

The migration is designed to keep the existing:

* Jellyfin integration
* Sonarr integration
* Radarr integration
* users
* requests
* history
* Seerr/Jellyseerr configuration

while changing only the application image and container runtime.

---

# 1. Why migrate?

The previous stack used:

```text
Jellyfin 12.x
Jellyseerr 2.7.3
```

The combination developed an authentication compatibility problem with Jellyfin.

Jellyseerr could connect to Jellyfin, but authentication failed with errors similar to:

```text
HTTP 400
```

and Jellyfin reported:

```text
System.ArgumentNullException:
Value cannot be null.
(Parameter 'request.App')
```

The problem was therefore not primarily Docker networking or DNS.

The migration to Seerr provides the current maintained application while retaining the existing configuration directory.

---

# 2. Existing configuration

The configuration directory is:

```text
${CONFIG_PATH}/jellyseerr
```

On the current server this corresponds to:

```text
/srv/docker/media/config/jellyseerr
```

The important principle is:

> Do not delete or recreate this directory during migration.

The existing database and configuration are required for preserving the Jellyseerr installation.

Typical contents include:

```text
config/jellyseerr/
├── cache/
├── db/
├── logs/
├── settings.json
└── settings.old.json
```

The exact contents may vary between versions.

---

# 3. Create a backup before migration

Always create a backup before changing the application image.

From the media stack directory:

```bash
cd /srv/docker/media
```

Create a timestamped backup:

```bash
tar -czf jellyseerr-config-backup-$(date +%Y%m%d-%H%M%S).tar.gz \
  ${CONFIG_PATH}/jellyseerr
```

If `${CONFIG_PATH}` is not available in the current shell, use the absolute path:

```bash
sudo tar -czf \
  jellyseerr-config-backup-$(date +%Y%m%d-%H%M%S).tar.gz \
  /srv/docker/media/config/jellyseerr
```

Verify that the backup exists:

```bash
ls -lh jellyseerr-config-backup-*.tar.gz
```

The backup should be retained until the new Seerr installation has been fully validated.

---

# 4. Stop the old Jellyseerr container

Stop only the Jellyseerr container:

```bash
docker stop jellyseerr
```

Do not remove the configuration directory.

Do not use:

```bash
docker compose down -v
```

The `-v` option can remove Docker volumes and is unnecessary for this migration.

---

# 5. Update the Compose configuration

The service remains in:

```text
compose/10-jellyseerr.yml
```

The filename does not need to be renamed simply because the application changed.

The service can also continue to use the existing service name:

```yaml
services:
  jellyseerr:
```

The important changes are the image and container name.

The relevant configuration is:

```yaml
services:

  jellyseerr:

    image: ghcr.io/seerr-team/seerr:latest

    container_name: seerr

    hostname: seerr

    init: true

    restart: unless-stopped

    depends_on:

      jellyfin:
        condition: service_started

      sonarr:
        condition: service_started

      radarr:
        condition: service_started

    environment:

      - TZ=${TZ}

      - LOG_LEVEL=info

    volumes:

      - ${CONFIG_PATH}/jellyseerr:/app/config

    ports:

      - "5055:5055"
```

The existing external networks should remain unchanged:

```yaml
networks:
  media:
    external: true

  proxy:
    external: true
```

The existing Traefik configuration can also remain unchanged if the same hostname and port are being used.

---

# 6. Container naming

The old container was:

```text
jellyseerr
```

The new container is:

```text
seerr
```

The Compose service name can remain:

```text
jellyseerr
```

This is intentional.

Therefore the resulting relationship is:

```text
Compose service:
jellyseerr

Container:
seerr

Image:
ghcr.io/seerr-team/seerr:latest
```

This avoids unnecessary changes to the rest of the stack.

---

# 7. Important: Seerr runs as a non-root user

One of the important differences between the old Jellyseerr container and the new Seerr container is the user running the application.

The old Jellyseerr installation may have created configuration files owned by:

```text
root:root
```

The Seerr container runs the application as UID 1000.

Therefore, after changing the image, Seerr may fail with:

```text
EACCES: permission denied
```

For example:

```text
Error: EACCES: permission denied,
open '/app/config/logs/seerr-YYYY-MM-DD.log'
```

If this occurs, correct ownership of the existing configuration directory.

First inspect:

```bash
ls -ldn /srv/docker/media/config/jellyseerr
ls -ldn /srv/docker/media/config/jellyseerr/logs
```

Then:

```bash
sudo chown -R 1000:1000 /srv/docker/media/config/jellyseerr
```

Verify:

```bash
ls -ldn /srv/docker/media/config/jellyseerr
ls -ldn /srv/docker/media/config/jellyseerr/logs
```

Expected ownership:

```text
1000 1000
```

Do not delete the directory or recreate the database.

---

# 8. Security options

The Seerr deployment intentionally does not currently use:

```yaml
security_opt:
  - no-new-privileges:true

cap_drop:
  - ALL
```

These options were removed from this deployment because they previously caused integration/configuration problems.

They should not be added automatically during the migration.

The current deployment should first be validated without them.

If hardening is evaluated later, test each change separately and verify:

* container startup
* healthcheck
* Seerr configuration
* Jellyfin authentication
* Sonarr integration
* Radarr integration
* notifications
* scheduled jobs

Do not combine security changes with another migration or application upgrade.

---

# 9. Deploy the new container

The stack provides update/status scripts.

Use the existing stack update mechanism rather than manually running Compose commands without the stack environment loaded.

From:

```bash
cd /srv/docker/media
```

run:

```bash
./scripts/update.sh
```

Then check the stack:

```bash
./scripts/status.sh
```

The expected container should be:

```text
seerr
```

with:

```text
ghcr.io/seerr-team/seerr:latest
```

and:

```text
healthy
```

---

# 10. Check Seerr logs

Check the container logs:

```bash
docker logs --tail 100 seerr
```

A successful startup should eventually contain messages similar to:

```text
Starting Seerr version 3.x.x
```

followed by:

```text
[Notifications]: Registered notification agents
[Jobs]: Scheduled jobs loaded
[Server]: Server ready on port 5055
```

The exact version and commit hash may change.

The important message is:

```text
Server ready on port 5055
```

---

# 11. Healthcheck

The container healthcheck uses:

```text
http://localhost:5055/api/v1/status
```

The container may initially show:

```text
health: starting
```

Immediately after startup.

Wait for the healthcheck to complete and run:

```bash
./scripts/status.sh
```

Expected result:

```text
seerr ... Up ... (healthy)
```

Do not assume that `health: starting` indicates failure immediately after deployment.

---

# 12. Access Seerr

The direct local address is:

```text
http://192.168.1.40:5055
```

If Traefik is configured, the normal Seerr hostname can also be used.

The application should open without requiring creation of a new database.

---

# 13. Validate the migrated configuration

After Seerr starts successfully, verify that the existing configuration was preserved.

Check:

### Authentication

Confirm that the existing Seerr/Jellyfin authentication configuration is present.

### Jellyfin

Verify:

```text
Seerr → Settings → Jellyfin
```

Confirm that the existing Jellyfin server is still configured.

### Sonarr

Verify the existing Sonarr server and settings.

### Radarr

Verify the existing Radarr server and settings.

### Users

Confirm that existing users are still present.

### Requests

Confirm that previous requests/history are still available.

### Notifications

Confirm that existing notification agents are still configured.

### Scheduled jobs

Check the Seerr logs for:

```text
Scheduled jobs loaded
```

---

# 14. Validate Jellyfin authentication

The most important functional test is the Jellyfin integration.

The original problem was authentication between Jellyseerr and Jellyfin.

Test the Jellyfin connection from Seerr.

The expected result is a successful connection/authentication without errors such as:

```text
HTTP 400
```

or:

```text
request.App
```

If authentication works, the original Jellyseerr/Jellyfin compatibility problem has been resolved.

---

# 15. Validate Sonarr and Radarr

After Jellyfin authentication works, test:

```text
Seerr
 ├── Jellyfin
 ├── Sonarr
 └── Radarr
```

Verify that Seerr can:

* retrieve media information;
* search for media;
* submit requests;
* communicate with Sonarr;
* communicate with Radarr.

Do not change Sonarr or Radarr configuration unless a specific integration test fails.

---

# 16. Docker networking

Seerr continues to use the existing Docker networks:

```text
media
proxy
```

Jellyfin, Sonarr and Radarr should remain reachable using their Docker service/container names.

For example:

```text
http://jellyfin:8096
http://sonarr:8989
http://radarr:7878
```

Do not replace Docker service names with host IP addresses unless there is a specific networking requirement.

The existing Docker network architecture should be preserved.

---

# 17. Rollback procedure

If the migration fails, do not delete the new configuration.

First stop Seerr:

```bash
docker stop seerr
```

The original backup should be available:

```text
jellyseerr-config-backup-YYYYMMDD-HHMMSS.tar.gz
```

Before restoring anything, preserve the current failed state for troubleshooting.

For example:

```bash
sudo mv /srv/docker/media/config/jellyseerr \
  /srv/docker/media/config/jellyseerr-seerr-failed
```

Then restore the backup:

```bash
sudo tar -xzf jellyseerr-config-backup-YYYYMMDD-HHMMSS.tar.gz \
  -C /
```

Restore the old Jellyseerr Compose image/container configuration and deploy it using the normal stack scripts.

Do not perform a rollback by deleting the database.

---

# 18. Migration checklist

Use this checklist whenever migrating another installation.

```text
[ ] Stop old Jellyseerr
[ ] Create configuration backup
[ ] Verify backup exists
[ ] Change image to ghcr.io/seerr-team/seerr:latest
[ ] Set container_name to seerr
[ ] Add init: true
[ ] Keep existing /app/config volume
[ ] Keep existing port 5055
[ ] Keep existing Docker networks
[ ] Do not delete the existing database
[ ] Do not use docker compose down -v
[ ] Correct configuration ownership to UID 1000 if required
[ ] Start/deploy Seerr
[ ] Check docker logs
[ ] Wait for healthy status
[ ] Open Seerr
[ ] Verify existing configuration
[ ] Verify Jellyfin
[ ] Verify Sonarr
[ ] Verify Radarr
[ ] Verify users
[ ] Verify requests/history
[ ] Verify notifications
[ ] Keep backup until migration is confirmed
```

---

# 19. Current deployment architecture

The resulting architecture is:

```text
                    Docker media network
                            │
       ┌────────────────────┼────────────────────┐
       │                    │                    │
    Jellyfin              Seerr                Sonarr
    :8096                 :5055                :8989
       │                    │                    │
       │                    ├────────────────────┤
       │                    │
       │                  Radarr
       │                  :7878
       │
       └──────────── Media services
```

Seerr uses:

```text
Image:
ghcr.io/seerr-team/seerr:latest

Container:
seerr

Config:
${CONFIG_PATH}/jellyseerr

Port:
5055

Networks:
media
proxy
```

---

# 20. Operational recommendations

### Keep the configuration directory

Do not remove:

```text
${CONFIG_PATH}/jellyseerr
```

### Keep the migration backup

Retain the backup until the new Seerr installation has been tested in normal operation.

### Use the stack scripts

Prefer:

```bash
./scripts/update.sh
./scripts/status.sh
```

instead of manually invoking Compose without loading the stack environment.

### Avoid destructive Docker commands

Do not use:

```bash
docker compose down -v
```

for routine updates or migrations.

### Test one change at a time

If security hardening, image changes, network changes or other configuration changes are introduced later, test them separately.

This makes troubleshooting significantly easier.

---

# 21. Migration result

A successful migration should result in:

```text
Old:

Jellyseerr 2.x
    │
    └── Jellyfin authentication problem


New:

Seerr 3.x
    │
    ├── Existing configuration
    ├── Existing database
    ├── Jellyfin
    ├── Sonarr
    └── Radarr
```

The migration does not require rebuilding the media stack or changing Jellyfin, Sonarr, Radarr, qBittorrent, or the other media services.

The primary changes are:

```text
Jellyseerr image
      ↓
Seerr image

jellyseerr container
      ↓
seerr container

old root-owned config
      ↓
UID 1000-owned config
```

Once the Seerr container is healthy and all integrations have been tested successfully, the migration is considered complete.
