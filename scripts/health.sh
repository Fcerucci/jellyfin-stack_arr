#!/usr/bin/env bash

# ==============================================================================
# Homelab Media Stack
# ------------------------------------------------------------------------------
# Arquivo.......: health.sh
# Descrição.....: Verifica rapidamente o status dos containers da stack.
# Autor.........: Fabio
# Versão........: 1.0
# ==============================================================================

source "$(dirname "$0")/common.sh"

SERVICES=(
    gluetun
    qbittorrent
    flaresolverr

    prowlarr
    sonarr
    radarr
    lidarr
    bazarr

    jellyfin
    jellyseerr

    recyclarr
    unpackerr
)

echo
echo "==========================================="
echo " Homelab Media Stack - Health Check"
echo "==========================================="
echo

for service in "${SERVICES[@]}"; do

    if docker ps --format "{{.Names}}" | grep -q "^${service}$"; then
        printf "✅ %-15s Running\n" "$service"
    else
        printf "❌ %-15s Stopped\n" "$service"
    fi

done

echo