FROM node:20-slim

RUN corepack enable

RUN mkdir -p /app
WORKDIR /app
