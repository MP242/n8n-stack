# Utilise l'image officielle n8n (version stable)
FROM n8nio/n8n:latest

# Passer en root pour les opérations système
USER root

# Copier les nodes custom dans un répertoire temporaire
COPY --chown=node:node ./custom_node /tmp/custom_node

# Copier le script d'initialisation
COPY --chown=root:root ./init-custom.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-custom.sh

# Repasser en utilisateur node
USER node

# Expose le port par défaut
EXPOSE 5678

# Exécuter le script d'init puis n8n
CMD ["/bin/sh", "-c", "/usr/local/bin/init-custom.sh && n8n"]