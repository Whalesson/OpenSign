# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm ci

# Copiar código-fonte
COPY . .

# Build da aplicação React
RUN npm run build

# Stage 2: Serve
FROM node:22-alpine

WORKDIR /app

# Instalar serve para servir arquivos estáticos
RUN npm install -g serve

# Copiar arquivos buildados do stage anterior
COPY --from=builder /app/build ./build

# Expor porta
EXPOSE 3000

# Comando para iniciar o servidor
CMD ["serve", "-s", "build", "-l", "3000"]
