# Deploy WhatsApp MCP Server no Coolify

Este guia explica como fazer o deploy do WhatsApp MCP Server no Coolify.

## 📋 Pré-requisitos

- Coolify instalado e configurado
- Repositório Git com o código do projeto
- Acesso ao servidor onde o Coolify está rodando

## 🚀 Deploy no Coolify

### 1. Preparar o Repositório

1. Faça push do código para seu repositório Git
2. Certifique-se de que todos os arquivos estão incluídos:
   - `Dockerfile`
   - `docker-compose.yml`
   - `start.sh`
   - `nginx.conf` (opcional)
   - `coolify.yml`

### 2. Configurar no Coolify

1. **Acesse o Coolify Dashboard**
2. **Criar Nova Aplicação**
   - Tipo: `Application`
   - Fonte: `Git Repository`
   - Repositório: Seu repositório Git
   - Branch: `main`

3. **Configurações de Build**
   - Dockerfile: `Dockerfile`
   - Context: `.`
   - Build Arguments: `BUILDKIT_INLINE_CACHE=1`

4. **Configurações de Deploy**
   - Port: `9090`
   - Environment Variables:
     ```
     TZ=UTC
     NODE_ENV=production
     ```

5. **Volumes (Opcional)**
   - Para persistir dados do WhatsApp:
     - Source: `whatsapp_data`
     - Destination: `/app/whatsapp-bridge/store`
   - Para compartilhar mídia:
     - Source: `./media`
     - Destination: `/app/media`
     - Read Only: `true`

### 3. Deploy

1. Clique em "Deploy"
2. Aguarde o build e deploy completar
3. Verifique os logs para garantir que tudo está funcionando

## 🔧 Configuração Pós-Deploy

### 1. Autenticação WhatsApp

Após o primeiro deploy, você precisará autenticar com o WhatsApp:

1. Acesse os logs do container
2. Procure pelo QR code
3. Escaneie com seu WhatsApp mobile
4. Aguarde a sincronização das mensagens

### 2. Configurar MCP Client

Configure seu cliente MCP (Claude Desktop ou Cursor) para conectar ao servidor:

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
```

## 🔍 Troubleshooting

### Problemas Comuns

1. **Build Falha**
   - Verifique se o Go e Python estão sendo compilados corretamente
   - Verifique os logs de build no Coolify

2. **Container não inicia**
   - Verifique se a porta 8080 está disponível
   - Verifique os logs do container

3. **WhatsApp não conecta**
   - Verifique se o QR code aparece nos logs
   - Certifique-se de que o WhatsApp mobile está conectado à internet

4. **MCP não funciona**
   - Verifique se o servidor está respondendo na porta 9090
   - Teste com: `curl http://seu-servidor:9090/api/health`

### Logs Úteis

```bash
# Ver logs do container
docker logs whatsapp-mcp-server

# Ver logs do Coolify
# Acesse o dashboard do Coolify > Applications > Logs
```

## 🔒 Segurança

### Recomendações

1. **Use HTTPS**: Configure SSL/TLS no Coolify
2. **Firewall**: Restrinja acesso à porta 8080
3. **Autenticação**: Considere adicionar autenticação ao API
4. **Backup**: Configure backup dos volumes de dados

### Variáveis de Ambiente Sensíveis

Não exponha informações sensíveis em variáveis de ambiente. O WhatsApp MCP Server não requer credenciais externas.

## 📊 Monitoramento

### Health Checks

O container inclui health checks automáticos:
- Endpoint: `http://localhost:8080/api/health`
- Intervalo: 30 segundos
- Timeout: 10 segundos
- Retries: 3

### Métricas

Monitore:
- Uso de CPU e memória
- Conexões ativas
- Taxa de erro
- Tempo de resposta

## 🔄 Atualizações

Para atualizar o servidor:

1. Faça push das mudanças para o repositório
2. No Coolify, clique em "Redeploy"
3. Aguarde o novo build e deploy
4. Verifique se tudo está funcionando

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs do Coolify
2. Verifique os logs do container
3. Teste localmente primeiro
4. Consulte a documentação do WhatsApp MCP Server original 