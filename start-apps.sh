#!/bin/bash

# Stop and remove existing containers if they exist
docker stop app-postgres app-python app-angular 2>/dev/null
docker rm app-postgres app-python app-angular 2>/dev/null

# Build Docker images
docker build -t app-postgres ./postgres
docker build -t app-python ./python
docker build -t app-angular ./angular

# Start PostgreSQL
echo "Starting PostgreSQL..."
docker run -d --name app-postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=appdb \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:latest

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 5

# Start Python backend
echo "Starting Python backend..."
docker run -d --name app-python \
  -p 8000:8000 \
  -e DATABASE_URL=postgresql://postgres:postgres@host.docker.internal:5432/appdb \
  app-python

# Start Angular frontend
echo "Starting Angular frontend..."
docker run -d --name app-angular \
  -p 4200:4200 \
  app-angular

echo "All services started!"
echo "PostgreSQL is running on port 5432"
echo "Python backend is running on port 8000"
echo "Angular frontend is running on port 4200" 