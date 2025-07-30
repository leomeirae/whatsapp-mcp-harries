#!/bin/bash

# WhatsApp MCP Server Startup Script
set -e

echo "🚀 Starting WhatsApp MCP Server..."

# Function to check if a service is ready
wait_for_service() {
    local host=$1
    local port=$2
    local service_name=$3
    
    echo "⏳ Waiting for $service_name to be ready..."
    
    for i in {1..30}; do
        if nc -z $host $port 2>/dev/null; then
            echo "✅ $service_name is ready!"
            return 0
        fi
        echo "   Attempt $i/30..."
        sleep 2
    done
    
    echo "❌ $service_name failed to start within 60 seconds"
    return 1
}

# Create necessary directories
mkdir -p /app/store
mkdir -p /app/media

# Set permissions
chmod +x /app/whatsapp-bridge

# Start the Go bridge in background
echo "🔧 Starting WhatsApp bridge..."
cd /app
./whatsapp-bridge &
BRIDGE_PID=$!

# Wait for bridge to be ready
if ! wait_for_service localhost 9090 "WhatsApp Bridge"; then
    echo "❌ Failed to start WhatsApp bridge"
    exit 1
fi

# Check if bridge is responding
echo "🔍 Testing bridge connectivity..."
if curl -f http://localhost:9090/api/health >/dev/null 2>&1; then
    echo "✅ Bridge API is responding"
else
    echo "⚠️  Bridge API health check failed, but continuing..."
fi

# Start the Python MCP server
echo "🐍 Starting Python MCP server..."
cd /app/whatsapp-mcp-server

# Run the MCP server
exec uv run main.py 