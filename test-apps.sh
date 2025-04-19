#!/bin/bash

echo "Testing all applications..."

# Test PostgreSQL
echo -e "\nTesting PostgreSQL..."
if docker exec app-postgres pg_isready -U postgres; then
    echo "✅ PostgreSQL is running and accepting connections"
else
    echo "❌ PostgreSQL is not responding"
fi

# Test Python Backend
echo -e "\nTesting Python Backend..."
if curl -s http://localhost:8000 > /dev/null; then
    RESPONSE=$(curl -s http://localhost:8000)
    if [ "$RESPONSE" = "Hello Jupiter!" ]; then
        echo "✅ Python Backend is running and returning correct response"
    else
        echo "❌ Python Backend is running but returned unexpected response: $RESPONSE"
    fi
else
    echo "❌ Python Backend is not responding"
fi

# Test React Frontend
echo -e "\nTesting React Frontend..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ React Frontend is running"
    echo "   Open http://localhost:3000 in your browser to see the application"
else
    echo "❌ React Frontend is not responding"
fi

# Check container status
echo -e "\nContainer Status:"
docker ps --filter "name=app-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 