# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY apps/backend/package*.json ./apps/backend/
COPY apps/frontend/package*.json ./apps/frontend/

RUN npm install

COPY . .

# Build backend
RUN npm run build:backend

# Build frontend
RUN npm run build:frontend

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install only production dependencies
COPY package*.json ./
COPY apps/backend/package*.json ./apps/backend/

RUN npm install --omit=dev && \
    npm install -g prisma

# Copy built backend from builder
COPY --from=builder /app/apps/backend/dist ./apps/backend/dist
COPY --from=builder /app/apps/backend/prisma ./apps/backend/prisma

# Copy built frontend
COPY --from=builder /app/apps/frontend/dist ./apps/frontend/dist

# Copy environment files if they exist (optional)
COPY apps/backend/.env* ./apps/backend/
COPY .env* ./

# Set NODE_ENV to production
ENV NODE_ENV=production
ENV PORT=3000

# Expose ports
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start application
CMD ["node", "apps/backend/dist/index.js"]
