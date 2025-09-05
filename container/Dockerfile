FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    sqlite3 \
    libsqlite3-dev \
    git \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Working directory
WORKDIR /var/www/html

# Copier l'application
COPY . .

# Installer les dépendances
RUN composer install --no-dev --optimize-autoloader

# Créer le dossier pour la DB (qui sera monté avec Azure Files)
RUN mkdir -p storage/database

# Permissions Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Configuration Apache pour Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Activer mod_rewrite pour Laravel
RUN a2enmod rewrite

# Optionnel : Script d'init pour les migrations
COPY docker/apache-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/apache-entrypoint.sh

EXPOSE 80

# Utiliser le script d'init ou directement Apache
CMD ["apache-entrypoint.sh"]
# OU si tu veux pas de script :
# CMD ["apache2-foreground"]