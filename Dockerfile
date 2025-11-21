# Multi-stage build for OpenSign Frontend
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar package.json
COPY apps/OpenSign/package.json ./

# Instalar dependências (sem lock file)
RUN npm install

# Copiar código-fonte
COPY apps/OpenSign/ .

# Argumentos de build para variáveis de ambiente
ARG REACT_APP_SERVERURL
ARG REACT_APP_APPID

# Exportar como variáveis de ambiente para o build
ENV REACT_APP_SERVERURL=${REACT_APP_SERVERURL}
ENV REACT_APP_APPID=${REACT_APP_APPID}

# Build da aplicação
RUN npm run build

# Stage 2: Servir a aplicação
FROM node:22-alpine

WORKDIR /app

# Instalar serve globalmente
RUN npm install -g serve

# Copiar build do stage anterior
COPY --from=builder /app/build ./build

# Copiar script de injeção de variáveis
COPY --from=builder /app/inject-env.sh /app/inject-env.sh

# Tornar o script executável
RUN chmod +x /app/inject-env.sh || true

EXPOSE 3000

# Usar script que injeta variáveis e inicia o servidor
CMD ["/bin/sh", "-c", "if [ -f /app/inject-env.sh ]; then /app/inject-env.sh; fi && serve -s build -l 3000"]
