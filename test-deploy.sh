#!/bin/bash

# Test script for WhatsApp MCP Server deployment
set -e

echo "🧪 Testing WhatsApp MCP Server deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "error")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "info")
            echo -e "ℹ️  $message"
            ;;
    esac
}

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_status "error" "Docker is not running"
    exit 1
fi

print_status "success" "Docker is running"

# Build the image
print_status "info" "Building Docker image..."
if docker build -t whatsapp-mcp-server .; then
    print_status "success" "Docker image built successfully"
else
    print_status "error" "Failed to build Docker image"
    exit 1
fi

# Test docker-compose
print_status "info" "Testing docker-compose..."
if docker-compose config >/dev/null 2>&1; then
    print_status "success" "docker-compose configuration is valid"
else
    print_status "error" "docker-compose configuration is invalid"
    exit 1
fi

# Check if required files exist
required_files=(
    "Dockerfile"
    "docker-compose.yml"
    "start.sh"
    "whatsapp-mcp-server/main.py"
    "whatsapp-mcp-server/whatsapp.py"
    "whatsapp-bridge/main.go"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_status "success" "File exists: $file"
    else
        print_status "error" "Missing file: $file"
        exit 1
    fi
done

# Test Python dependencies
print_status "info" "Testing Python dependencies..."
cd whatsapp-mcp-server
if python3 -c "import sys; print('Python version:', sys.version)" >/dev/null 2>&1; then
    print_status "success" "Python is available"
else
    print_status "error" "Python is not available"
    exit 1
fi

# Test if UV is available
if command -v uv >/dev/null 2>&1; then
    print_status "success" "UV package manager is available"
else
    print_status "warning" "UV package manager is not available (will be installed in container)"
fi

cd ..

# Test Go dependencies (if Go is available)
if command -v go >/dev/null 2>&1; then
    print_status "success" "Go is available"
    cd whatsapp-bridge
    if go mod download >/dev/null 2>&1; then
        print_status "success" "Go dependencies downloaded successfully"
    else
        print_status "warning" "Failed to download Go dependencies (will be handled in container)"
    fi
    cd ..
else
    print_status "warning" "Go is not available (will be installed in container)"
fi

# Test FFmpeg (if available)
if command -v ffmpeg >/dev/null 2>&1; then
    print_status "success" "FFmpeg is available"
else
    print_status "warning" "FFmpeg is not available (will be installed in container)"
fi

print_status "success" "All tests passed! Ready for deployment."

echo ""
echo "📋 Next steps:"
echo "1. Push this code to your Git repository"
echo "2. Configure the application in Coolify"
echo "3. Deploy using the Coolify dashboard"
echo "4. Check the logs for the QR code to authenticate WhatsApp"
echo ""
echo "📖 For detailed instructions, see DEPLOY.md" 