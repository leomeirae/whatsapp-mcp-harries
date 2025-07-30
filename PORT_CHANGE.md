# Mudança de Porta - WhatsApp MCP Server

## 🔄 **Alteração Realizada**

**Porta alterada de `8080` para `9090`**

### 📋 **Motivo da Mudança**
- As portas 8080, 8081, 3000, 3001 estavam sendo usadas
- Porta 9090 foi escolhida por ser menos comum e estar disponível

## 📝 **Arquivos Atualizados**

### 1. **Docker e Container**
- `Dockerfile` - EXPOSE 9090
- `docker-compose.yml` - Porta 9090:9090
- `start.sh` - Health checks na porta 9090

### 2. **Configuração do Coolify**
- `coolify.yml` - Porta 9090
- `coolify-deploy.json` - Porta 9090
- `coolify-env.txt` - Variáveis com porta 9090

### 3. **Documentação**
- `environment-variables.md` - Todas as referências atualizadas
- `DEPLOY.md` - Instruções de deploy atualizadas
- `mcp-config.json` - Configuração do cliente MCP

### 4. **Variáveis de Ambiente**
```bash
# Antes
WHATSAPP_BRIDGE_PORT=8080
WHATSAPP_API_BASE_URL=http://localhost:8080/api

# Depois
WHATSAPP_BRIDGE_PORT=9090
WHATSAPP_API_BASE_URL=http://localhost:9090/api
```

## 🚀 **Como Usar**

### Deploy no Coolify
1. Configure a porta `9090` no dashboard do Coolify
2. Use as variáveis de ambiente atualizadas
3. Teste a conectividade: `curl http://seu-servidor:9090/api/health`

### Configuração do Cliente MCP
```json
{
  "mcpServers": {
    "whatsapp": {
      "command": "curl",
      "args": [
        "-X", "POST",
        "http://seu-servidor:9090/api/mcp",
        "-H", "Content-Type: application/json",
        "-d"
      ]
    }
  }
}
```

## ✅ **Verificação**

### Teste Local
```bash
# Verificar se a porta está livre
lsof -i :9090

# Testar o container
docker-compose up

# Testar conectividade
curl http://localhost:9090/api/health
```

### Teste no Coolify
1. Deploy a aplicação
2. Verifique os logs
3. Teste: `curl http://seu-servidor:9090/api/health`

## 🔍 **Troubleshooting**

### Se a porta 9090 também estiver ocupada:
1. Escolha outra porta (ex: 9091, 9092, 9093)
2. Atualize todos os arquivos listados acima
3. Verifique se a nova porta está livre

### Comandos para verificar portas:
```bash
# Verificar portas em uso
lsof -i :9090
netstat -an | grep 9090

# Verificar portas específicas
lsof -i :8080
lsof -i :8081
lsof -i :3000
lsof -i :3001
```

## 📊 **Resumo das Mudanças**

| Arquivo | Alteração |
|---------|-----------|
| `Dockerfile` | EXPOSE 9090 |
| `docker-compose.yml` | Porta 9090:9090 |
| `start.sh` | Health checks na porta 9090 |
| `coolify.yml` | Porta 9090 |
| `coolify-deploy.json` | Porta 9090 |
| `environment-variables.md` | Todas as referências |
| `DEPLOY.md` | Instruções atualizadas |
| `mcp-config.json` | URL da API |
| `coolify-env.txt` | Variáveis de ambiente |

**✅ Todas as alterações foram aplicadas com sucesso!** 