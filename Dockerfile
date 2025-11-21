FROM node:22-alpine AS builder

WORKDIR /app

# Copiar package.json
COPY apps/OpenSign/package.json ./

# Instalar dependências (sem lock file)
RUN npm install

# Copiar código-fonte
COPY apps/OpenSign/ .

# Build
RUN npm run build

# Stage 2
FROM node:22-alpine

WORKDIR /app

RUN npm install -g serve

COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
