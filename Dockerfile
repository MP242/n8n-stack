# Utilise l'image officielle n8n (version stable)
FROM n8nio/n8n:latest

# (Optionnel) Copier des fichiers personnalisés dans le container
COPY ./custom_node /home/node/.n8n/custom

# Expose le port par défaut (5678)
EXPOSE 5678

# La commande par défaut est déjà définie dans l'image officielle (n8n)
# CMD ["n8n"]
