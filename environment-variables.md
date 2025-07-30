# Variáveis de Ambiente - WhatsApp MCP Server

Este documento lista todas as variáveis de ambiente necessárias e opcionais para o WhatsApp MCP Server.

## 🔧 **Variáveis Obrigatórias**

### Configuração Básica
```bash
# Timezone para a aplicação
TZ=UTC

# Ambiente (production, development, staging)
NODE_ENV=production
```

### Configuração do WhatsApp Bridge
```bash
# Porta para a API do Go bridge (padrão: 9090)
WHATSAPP_BRIDGE_PORT=9090

# Host para a API do Go bridge (padrão: localhost)
WHATSAPP_BRIDGE_HOST=localhost

# URL base para a API do WhatsApp (usado pelo servidor Python MCP)
WHATSAPP_API_BASE_URL=http://localhost:9090/api
```

## 📊 **Variáveis Opcionais**

### Configuração de Banco de Dados
```bash
# Caminho do banco SQLite (relativo a /app/store/)
MESSAGES_DB_PATH=/app/store/messages.db

# Caminho do banco de sessão do WhatsApp
WHATSAPP_DB_PATH=/app/store/whatsapp.db
```

### Configuração de Mídia
```bash
# Diretório de armazenamento de mídia
MEDIA_STORAGE_PATH=/app/media

# Tamanho máximo de arquivo para uploads (em bytes, padrão: 100MB)
MAX_MEDIA_SIZE=104857600

# Tipos de mídia suportados (separados por vírgula)
SUPPORTED_MEDIA_TYPES=image/jpeg,image/png,image/gif,video/mp4,audio/mpeg,audio/ogg,application/pdf
```

### Configuração de Conversão de Áudio (FFmpeg)
```bash
# Taxa de bits para conversão de áudio (padrão: 32k)
AUDIO_BITRATE=32k

# Taxa de amostragem de áudio (padrão: 24000)
AUDIO_SAMPLE_RATE=24000

# Tipo de aplicação de áudio (padrão: voip)
AUDIO_APPLICATION=voip
```

### Configuração de Logs
```bash
# Nível de log (debug, info, warn, error)
LOG_LEVEL=info

# Caminho do arquivo de log
LOG_FILE_PATH=/app/logs/whatsapp-mcp.log

# Habilitar logs no console
ENABLE_CONSOLE_LOGGING=true
```

### Segurança e Rate Limiting
```bash
# Habilitar rate limiting (true/false)
ENABLE_RATE_LIMITING=true

# Limite de requisições por minuto
RATE_LIMIT_REQUESTS_PER_MINUTE=60

# Habilitar CORS (true/false)
ENABLE_CORS=true

# Origens CORS permitidas (separadas por vírgula)
CORS_ALLOWED_ORIGINS=*
```

### Configuração do Servidor MCP
```bash
# Nome do servidor MCP
MCP_SERVER_NAME=whatsapp

# Descrição do servidor MCP
MCP_SERVER_DESCRIPTION="WhatsApp MCP Server for Claude/Cursor integration"

# Versão do servidor MCP
MCP_SERVER_VERSION=1.0.0
```

### Performance e Recursos
```bash
# Número máximo de conexões concorrentes
MAX_CONCURRENT_CONNECTIONS=100

# Timeout de requisição em segundos
REQUEST_TIMEOUT=30

# Intervalo de health check em segundos
HEALTH_CHECK_INTERVAL=30
```

## 🌐 **Configuração para Deploy no Coolify**

### Configuração Mínima
```bash
# Variáveis obrigatórias para Coolify
TZ=UTC
NODE_ENV=production
WHATSAPP_BRIDGE_PORT=9090
WHATSAPP_API_BASE_URL=http://localhost:9090/api
```

### Configuração Recomendada
```bash
# Configuração completa recomendada
TZ=UTC
NODE_ENV=production
WHATSAPP_BRIDGE_PORT=9090
WHATSAPP_API_BASE_URL=http://localhost:9090/api
LOG_LEVEL=info
ENABLE_RATE_LIMITING=true
RATE_LIMIT_REQUESTS_PER_MINUTE=60
ENABLE_CORS=true
MAX_MEDIA_SIZE=104857600
HEALTH_CHECK_INTERVAL=30
```

## 🔒 **Variáveis Sensíveis**

**⚠️ IMPORTANTE:** O WhatsApp MCP Server não requer credenciais externas ou chaves de API. Todas as autenticações são feitas via QR code do WhatsApp.

### Variáveis que NÃO devem ser expostas:
- Não há variáveis sensíveis neste projeto
- As sessões do WhatsApp são armazenadas localmente no banco SQLite
- Não há necessidade de chaves de API ou tokens

## 🚀 **Configuração no Coolify**

### 1. Variáveis Básicas
No dashboard do Coolify, configure estas variáveis de ambiente:

```bash
TZ=UTC
NODE_ENV=production
WHATSAPP_BRIDGE_PORT=8080
```

### 2. Variáveis Avançadas (Opcional)
Para configuração avançada, adicione:

```bash
LOG_LEVEL=info
ENABLE_RATE_LIMITING=true
RATE_LIMIT_REQUESTS_PER_MINUTE=60
ENABLE_CORS=true
MAX_MEDIA_SIZE=104857600
HEALTH_CHECK_INTERVAL=30
```

### 3. Configuração de Volumes
Configure os volumes para persistência:

```bash
# Volume para dados do WhatsApp
whatsapp_data:/app/store

# Volume para mídia (opcional)
./media:/app/media:ro
```

## 🔍 **Verificação das Variáveis**

### Teste Local
```bash
# Verificar se as variáveis estão sendo carregadas
docker run --rm -e TZ=UTC -e NODE_ENV=production whatsapp-mcp-server env | grep -E "(TZ|NODE_ENV|WHATSAPP)"
```

### Teste no Coolify
1. Acesse os logs da aplicação no Coolify
2. Verifique se as variáveis estão sendo aplicadas
3. Teste a conectividade: `curl http://seu-servidor:9090/api/health`

## 📝 **Exemplo de Arquivo .env**

```bash
# WhatsApp MCP Server - Environment Variables
TZ=UTC
NODE_ENV=production
WHATSAPP_BRIDGE_PORT=9090
WHATSAPP_API_BASE_URL=http://localhost:9090/api
LOG_LEVEL=info
ENABLE_RATE_LIMITING=true
RATE_LIMIT_REQUESTS_PER_MINUTE=60
ENABLE_CORS=true
MAX_MEDIA_SIZE=104857600
HEALTH_CHECK_INTERVAL=30
```

## 🆘 **Troubleshooting**

### Problemas Comuns

1. **Container não inicia**
   - Verifique se `TZ` e `NODE_ENV` estão definidos
   - Verifique se a porta 8080 está disponível

2. **WhatsApp não conecta**
   - Verifique os logs para o QR code
   - Certifique-se de que `WHATSAPP_API_BASE_URL` está correto

3. **MCP não funciona**
   - Verifique se `WHATSAPP_BRIDGE_PORT` está correto (deve ser 9090)
   - Teste a conectividade da API

4. **Problemas de mídia**
   - Verifique se `MAX_MEDIA_SIZE` está adequado
   - Verifique se `MEDIA_STORAGE_PATH` existe e tem permissões 