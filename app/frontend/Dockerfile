# ---- Build stage ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# ---- Production image ----
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV production

# Hardened line: Copies public folder only if it contains elements, preventing crash
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Running safe copy if directory is tracked
COPY --from=builder /app/public* ./public

EXPOSE 3000
CMD ["node", "server.js"]