# Multi-stage build for WhatsApp MCP Server
FROM golang:1.24-alpine AS go-builder

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    sqlite-dev \
    git

# Set working directory
WORKDIR /app

# Copy Go module files
COPY whatsapp-bridge/go.mod whatsapp-bridge/go.sum ./

# Download Go dependencies
RUN go mod download

# Copy Go source code
COPY whatsapp-bridge/ ./

# Build the Go application
RUN CGO_ENABLED=1 GOOS=linux go build -a -installsuffix cgo -o whatsapp-bridge .

# Python stage
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install UV package manager
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy Go binary from builder stage
COPY --from=go-builder /app/whatsapp-bridge ./whatsapp-bridge

# Copy Python project files
COPY whatsapp-mcp-server/ ./whatsapp-mcp-server/

# Set working directory to Python project
WORKDIR /app/whatsapp-mcp-server

# Install Python dependencies using UV
RUN uv sync --frozen

# Create store directory for WhatsApp data
RUN mkdir -p ../whatsapp-bridge/store

# Expose port for the Go bridge API
EXPOSE 9090

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Install netcat for health checks
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Set the startup script as entrypoint
ENTRYPOINT ["/app/start.sh"] 