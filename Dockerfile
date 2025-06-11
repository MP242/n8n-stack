FROM n8nio/n8n:1.97.0

# Passer à l'utilisateur root pour les installations globales
USER root

# Désactiver Corepack qui cause les problèmes de signature
RUN corepack disable

# Installer pnpm manuellement via npm
RUN npm install -g pnpm@10.12.1

# Repasser à l'utilisateur node
USER node

# Créer le répertoire custom s'il n'existe pas
RUN mkdir -p /home/node/.n8n/custom

# Copier les custom nodes dans n8n
COPY --chown=node:node custom_node/ /home/node/.n8n/custom/

# Installation des dépendances de production
WORKDIR /home/node/.n8n/custom
RUN for dir in */; do \
        echo "=== Installation dans $dir ==="; \
        cd "$dir" && pnpm install --prod --no-optional && cd ..; \
    done || true

# Définir le répertoire de travail final
WORKDIR /home/node

# Exposer le port par défaut de n8n
EXPOSE 5678