#!/bin/sh

# Initialisation des custom nodes en tant que root si nécessaire
if [ -d "/tmp/custom_nodes" ] && [ -n "$(ls -A /tmp/custom_nodes 2>/dev/null)" ]; then
  echo "Copying custom nodes..."
  mkdir -p /home/node/.n8n/custom
  cp -r /tmp/custom_nodes/* /home/node/.n8n/custom/
  chown -R node:node /home/node/.n8n/custom
  echo "Installing custom node dependencies..."
  cd /home/node/.n8n/custom
  for pkg in $(find . -name "package.json" -type f); do
    dir=$(dirname "$pkg")
    echo "Installing dependencies in $dir"
    cd "$dir" && npm install 2>/dev/null || true
    cd /home/node/.n8n/custom
  done
  echo "Custom nodes setup complete"
fi

# Passer à l'utilisateur node et démarrer n8n
echo "Starting n8n..."
su node -c "/usr/local/bin/docker-entrypoint.sh $*" 