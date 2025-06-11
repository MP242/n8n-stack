# Utilise l'image officielle n8n (version stable)
FROM n8nio/n8n:latest

# Passer en root pour les opérations système
USER root

# Installer su-exec pour changer d'utilisateur de manière sécurisée
RUN apk add --no-cache su-exec

# Créer le répertoire pour les scripts d'initialisation
RUN mkdir -p /docker-entrypoint.d

# Copier les nodes custom dans un répertoire temporaire
COPY --chown=node:node ./custom_node /tmp/custom_node

# Copier le script d'initialisation
COPY --chown=root:root ./init-custom.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/init-custom.sh

# Modifier l'entrypoint pour exécuter nos scripts d'init
COPY --chown=root:root ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Repasser en utilisateur node
USER node

# Expose le port par défaut
EXPOSE 5678

# Utiliser notre entrypoint personnalisé
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["n8n"]