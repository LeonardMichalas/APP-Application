From node:18-alpine

WORKDIR /app

# Install dependencies first (better caching)
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build --prod

# Install serve to run the built application
RUN npm install -g serve

# The build output will be in /app/dist/mean-app
EXPOSE 4200

# Serve the built application
CMD ["serve", "-s", "dist/mean-app", "-l", "4200"]
