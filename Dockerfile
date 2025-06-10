# Étape de build
FROM n8nio/n8n:latest AS builder

USER node
RUN command -v pnpm >/dev/null 2>&1 || npm install -g pnpm

# Copier et builder
COPY --chown=node:node custom_node/n8n-custom-nodes/ /tmp/build/
WORKDIR /tmp/build
RUN pnpm install --no-optional && pnpm run build

# Étape finale - image propre
FROM n8nio/n8n:latest

USER node
RUN mkdir -p /home/node/.n8n/custom/n8n-nodes-clickup-tasks

# Copier seulement le build et package.json
COPY --from=builder --chown=node:node /tmp/build/dist/ /home/node/.n8n/custom/
COPY --from=builder --chown=node:node /tmp/build/package.json /home/node/.n8n/custom/

WORKDIR /home/node
EXPOSE 5678