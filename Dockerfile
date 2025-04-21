# Step 1: Build Angular app
FROM node:23-slim AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Angular app in production mode
RUN npm run build -- --configuration production

# Step 2: Serve the built app with Nginx
FROM nginx:alpine

# Copy the built Angular app to Nginx's web directory
COPY --from=builder /app/dist/my-app/browser /usr/share/nginx/html

# Optional: copy custom nginx config (if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
