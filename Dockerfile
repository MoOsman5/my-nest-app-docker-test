# Stage 1 - Build
FROM node:20-alpine AS builder

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy package files
COPY pnpm-lock.yaml package.json ./

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Copy project files
COPY . .

# Build NestJS
RUN pnpm run build


# Stage 2 - Run (production)
FROM node:20-alpine

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["pnpm", "start:prod"]
