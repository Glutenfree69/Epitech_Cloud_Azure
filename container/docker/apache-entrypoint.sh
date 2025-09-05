#!/bin/bash
set -e

echo "🔧 Preparing Laravel application..."

# Créer le dossier si nécessaire avec les bonnes permissions
if [ ! -d /var/www/html/storage/database ]; then
    mkdir -p /var/www/html/database
fi

# IMPORTANT : Donner les permissions au DOSSIER d'abord
chown -R www-data:www-data /var/www/html/storage/database
chmod -R 777 /var/www/html/database

# Créer la DB si elle n'existe pas
if [ ! -f /var/www/html/storage/database/database.sqlite ]; then
    echo "📦 Creating new SQLite database..."
    # Créer le fichier en tant que www-data directement
    touch /var/www/html/database/database.sqlite
fi

# S'assurer que le fichier a les bonnes permissions
chown www-data:www-data /var/www/html/database/database.sqlite
chmod 777 /var/www/html/database/database.sqlite

# Exécuter les migrations en tant que www-data
echo "🚀 Running migrations..."
php artisan migrate --force

# Cache en tant que www-data
php artisan config:cache
php artisan route:cache

echo "✅ Application ready!"

# Lancer Apache (qui va utiliser www-data)
exec apache2-foreground