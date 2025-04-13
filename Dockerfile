# Stage 1: Build environment
FROM node:14 as builder

WORKDIR /app
COPY . .

# If you were using a framework like React/Vue, you would build here
# RUN npm install && npm run build

# Stage 2: Production image
FROM httpd:2.4

# Copy built files from builder stage to Apache root
COPY --from=builder /app /usr/local/apache2/htdocs/

# For simple static sites, you can just copy directly
# COPY . /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd-foreground"]
