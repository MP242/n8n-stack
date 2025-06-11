FROM n8nio/n8n:1.60.1

# Passer à l'utilisateur node dès le début pour la sécurité
USER node

# Vérifier et installer pnpm@10.12.1 si nécessaire (normalement déjà présent dans l'image n8n)
RUN command -v pnpm >/dev/null 2>&1 || npm install -g pnpm@10.12.1

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