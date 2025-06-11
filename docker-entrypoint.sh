#!/bin/bash
set -e

echo "Starting n8n with custom initialization..."

# Exécuter tous les scripts d'initialisation dans /docker-entrypoint.d/
if [ -d "/docker-entrypoint.d" ]; then
    echo "Running initialization scripts..."
    for f in /docker-entrypoint.d/*.sh; do
        if [ -f "$f" ]; then
            echo "Executing $f..."
            bash "$f"
        fi
    done
    echo "Initialization scripts completed"
fi

# Assurer que les permissions sont correctes pour l'utilisateur node
if [ "$(id -u)" = "0" ]; then
    echo "Fixing permissions for node user..."
    chown -R node:node /home/node/.n8n 2>/dev/null || true
    
    echo "Switching to node user and starting n8n..."
    # Utiliser su-exec pour changer d'utilisateur et exécuter la commande
    exec su-exec node "$@"
else
    echo "Already running as non-root user, starting n8n..."
    # Exécuter directement la commande
    exec "$@"
fi 