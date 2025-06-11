# Utilise l'image officielle n8n (version stable)
FROM n8nio/n8n:latest

# L'image n8n utilise déjà USER node (non-root)
# C'est une bonne pratique de sécurité

# Créer les répertoires avec les bonnes permissions
USER root
RUN mkdir -p /home/node/.n8n/custom && \
    chown -R node:node /home/node/.n8n/custom

# Repasser en utilisateur node
USER node

# Copier avec les bonnes permissions
COPY --chown=node:node ./custom_node /home/node/.n8n/custom

# Expose le port par défaut (5678)
EXPOSE 5678

# La commande par défaut est déjà définie dans l'image officielle (n8n)
# CMD ["n8n"]
