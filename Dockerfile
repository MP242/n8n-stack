FROM n8nio/n8n:latest

# Passer à l'utilisateur node dès le début pour la sécurité
USER node

# Vérifier et installer pnpm si nécessaire (normalement déjà présent dans l'image n8n)
RUN command -v pnpm >/dev/null 2>&1 || npm install -g pnpm

# Créer le répertoire custom s'il n'existe pas
RUN mkdir -p /home/node/.n8n/custom

# Copier les custom nodes dans n8n
COPY --chown=node:node custom_node/ /home/node/.n8n/custom/

# Installer les dépendances des custom nodes avec pnpm
WORKDIR /home/node/.n8n/custom
RUN find . -name "package.json" -type f \
    -execdir sh -c 'echo "Installation des dépendances dans $(pwd)" && pnpm install --prod --frozen-lockfile --prefer-offline' \; || \
    find . -name "package.json" -type f \
    -execdir sh -c 'echo "Fallback: installation avec pnpm install" && pnpm install --prod' \; || true

# Nettoyer le cache pnpm pour réduire la taille de l'image
RUN pnpm store prune || true

# Définir le répertoire de travail final
WORKDIR /home/node

# Exposer le port par défaut de n8n
EXPOSE 5678