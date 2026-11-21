FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci || npm install
COPY . .
RUN npm run build

FROM php:8.3-cli
WORKDIR /app
RUN apt-get update && apt-get install -y libpq-dev unzip git \
 && docker-php-ext-install pdo_pgsql pcntl bcmath \
 && rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY . .
COPY --from=assets /app/public/build ./public/build
RUN composer install --no-dev --optimize-autoloader --no-interaction
EXPOSE 8080
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
