FROM n8nio/n8n:latest

# Copier les custom nodes dans un dossier temporaire
COPY --chown=node:node custom_node/ /tmp/custom_nodes/

# Copier le script d'entrypoint personnalisé
USER root
RUN mkdir -p /opt/scripts
COPY docker-entrypoint.sh /opt/scripts/
RUN chmod +x /opt/scripts/docker-entrypoint.sh

ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]
CMD ["n8n"] 