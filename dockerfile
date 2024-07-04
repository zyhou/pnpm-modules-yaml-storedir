FROM node:20-slim

RUN corepack enable
RUN corepack prepare pnpm@9.4.0 --activate;

RUN mkdir -p /app
WORKDIR /app
