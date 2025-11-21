#!/bin/sh
# Script para injetar variáveis de ambiente em runtime no index.html

# Arquivo de destino
INDEX_FILE="/app/build/index.html"

# Criar objeto JavaScript com variáveis de ambiente
cat > /app/build/env-config.js << EOF
window.RUNTIME_ENV = {
  REACT_APP_SERVERURL: "${REACT_APP_SERVERURL}",
  REACT_APP_APPID: "${REACT_APP_APPID}"
};
EOF

# Injetar o script no index.html (antes do fechamento do </head>)
if [ -f "$INDEX_FILE" ]; then
  # Fazer backup
  cp "$INDEX_FILE" "$INDEX_FILE.bak"
  
  # Injetar script antes do </head>
  sed -i 's|</head>|<script src="/env-config.js"></script></head>|g' "$INDEX_FILE"
  
  echo "✅ Variáveis de ambiente injetadas com sucesso!"
  echo "REACT_APP_SERVERURL: ${REACT_APP_SERVERURL}"
  echo "REACT_APP_APPID: ${REACT_APP_APPID}"
else
  echo "⚠️ Arquivo index.html não encontrado em $INDEX_FILE"
fi
