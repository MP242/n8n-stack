#!/bin/bash
set -e

echo "Initializing custom nodes..."

# Vérifier si le répertoire custom existe déjà
if [ ! -d "/home/node/.n8n/custom" ]; then
    echo "Creating custom directory..."
    mkdir -p /home/node/.n8n/custom
    
    # Copier les nodes custom depuis /tmp
    if [ -d "/tmp/custom_node" ] && [ "$(ls -A /tmp/custom_node)" ]; then
        echo "Copying custom nodes..."
        cp -r /tmp/custom_node/* /home/node/.n8n/custom/
        echo "Custom nodes copied successfully!"
    else
        echo "No custom nodes found in /tmp/custom_node"
    fi
else
    echo "Custom directory already exists, skipping initialization"
fi

echo "Custom nodes initialization completed"