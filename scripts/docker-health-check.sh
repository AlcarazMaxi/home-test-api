#!/bin/bash

# Enhanced Docker Health Check Script
# Provides comprehensive health verification for Docker containers

set -e

CONTAINER_NAME=${1:-"demo-app"}
HEALTH_URL=${2:-"http://localhost:3100"}
MAX_ATTEMPTS=${3:-30}
BASE_DELAY=${4:-2}

echo "🔍 Starting enhanced Docker health check..."
echo "Container: $CONTAINER_NAME"
echo "URL: $HEALTH_URL"
echo "Max attempts: $MAX_ATTEMPTS"

# Function to check container status
check_container_status() {
    local status=$(docker inspect --format='{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "not_found")
    echo "Container status: $status"
    
    if [ "$status" = "not_found" ]; then
        echo "❌ Container $CONTAINER_NAME not found"
        return 1
    elif [ "$status" = "exited" ]; then
        echo "❌ Container $CONTAINER_NAME has exited"
        docker logs "$CONTAINER_NAME" --tail 20
        return 1
    elif [ "$status" = "running" ]; then
        echo "✅ Container $CONTAINER_NAME is running"
        return 0
    else
        echo "⚠️  Container $CONTAINER_NAME is in $status state"
        return 1
    fi
}

# Function to check application health
check_app_health() {
    local url="$1"
    local attempt="$2"
    
    echo "🌐 Health check attempt $attempt: $url"
    
    # Try multiple methods for health check
    if curl -f -s --connect-timeout 5 --max-time 10 "$url" >/dev/null 2>&1; then
        echo "✅ Application health check passed"
        return 0
    elif curl -f -s --connect-timeout 5 --max-time 10 "$url/api" >/dev/null 2>&1; then
        echo "✅ API health check passed"
        return 0
    elif curl -f -s --connect-timeout 5 --max-time 10 "$url/health" >/dev/null 2>&1; then
        echo "✅ Health endpoint check passed"
        return 0
    else
        echo "❌ Health check failed for $url"
        return 1
    fi
}

# Function to get container logs for debugging
get_container_logs() {
    echo "📋 Container logs (last 20 lines):"
    docker logs "$CONTAINER_NAME" --tail 20 || echo "No logs available"
    
    echo "📊 Container stats:"
    docker stats "$CONTAINER_NAME" --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" || echo "Stats not available"
    
    echo "🔍 Container inspect:"
    docker inspect "$CONTAINER_NAME" --format='{{json .State.Health}}' 2>/dev/null || echo "Health info not available"
}

# Main health check loop
echo "🚀 Starting health check loop..."

for i in $(seq 1 $MAX_ATTEMPTS); do
    echo "--- Attempt $i/$MAX_ATTEMPTS ---"
    
    # Check container status first
    if ! check_container_status; then
        echo "Container not ready, waiting..."
        sleep $BASE_DELAY
        continue
    fi
    
    # Check application health
    if check_app_health "$HEALTH_URL" "$i"; then
        echo "🎉 Application is healthy and ready!"
        exit 0
    fi
    
    # Calculate exponential backoff delay
    delay=$((BASE_DELAY + i/5))
    echo "⏳ Waiting ${delay}s before next attempt..."
    sleep $delay
done

# Final failure - get debug information
echo "❌ Health check failed after $MAX_ATTEMPTS attempts"
get_container_logs

echo "🔧 Debugging information:"
echo "Docker version: $(docker --version)"
echo "Docker info:"
docker info --format '{{.ServerVersion}}' || echo "Docker info not available"

echo "🌐 Network connectivity test:"
ping -c 3 localhost || echo "Ping test failed"

echo "🔍 Port binding check:"
netstat -tlnp | grep :3100 || echo "Port 3100 not bound"

exit 1
