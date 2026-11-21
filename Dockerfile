FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci || npm install
COPY . .
RUN npm run build

FROM php:8.3-cli
WORKDIR /app
RUN apt-get update && apt-get install -y libpq-dev unzip git \
 && docker-php
