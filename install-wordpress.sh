#!/bin/bash

# Variables
CONFIG_URL="https://raw.githubusercontent.com/yourusername/yourrepo/main/configs/site-plugins.yaml"
CONFIG_FILE="site-plugins.yaml"
YQ=~/yq
PHP_CLI="/usr/bin/php8.0-cli"
WP_CLI="./wp-cli.phar"

# Determine parent directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
WP_CLI="$SCRIPT_DIR/wp-cli.phar"

echo "Installing WordPress in: $PARENT_DIR"

# Download plugin config
echo "Downloading plugin config from $CONFIG_URL..."
curl -o "$CONFIG_FILE" "$CONFIG_URL"

# Install yq if not present
if [ ! -f "$YQ" ]; then
  echo "Installing yq YAML processor..."
  wget https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_linux_amd64 -O $YQ
  chmod +x $YQ
fi

# Install WP-CLI if not present
if [ ! -f "$WP_CLI" ]; then
  echo "Downloading WP-CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi

# Prompt for DB details
read -p "Enter database name: " DB_NAME
read -p "Enter database user: " DB_USER
read -s -p "Enter database password: " DB_PASS
echo
read -p "Enter database host (default: localhost): " DB_HOST
DB_HOST=${DB_HOST:-localhost}

# Prompt for site details
read -p "Enter site URL (https://yourdomain.com): " SITE_URL
read -p "Enter site title: " SITE_TITLE
read -p "Enter admin username: " ADMIN_USER
read -s -p "Enter admin password: " ADMIN_PASS
echo
read -p "Enter admin email: " ADMIN_EMAIL

echo "Starting WordPress installation at $SITE_URL with title '$SITE_TITLE'..."

# Move into the parent directory to install WordPress
cd "$PARENT_DIR"

# Download WordPress core
$PHP_CLI $WP_CLI core download

# Create wp-config.php
$PHP_CLI $WP_CLI config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST"

# Install WordPress core
$PHP_CLI $WP_CLI core install --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL"

# Install free plugins
for plugin in $($YQ e '.plugins.free[]' "$SCRIPT_DIR/$CONFIG_FILE"); do
  echo "Installing plugin: $plugin"
  $PHP_CLI $WP_CLI plugin install "$plugin" --activate
done

# Install ZIP plugins
ZIP_COUNT=$($YQ e '.plugins.zips | length' "$SCRIPT_DIR/$CONFIG_FILE")
if [ "$ZIP_COUNT" -gt 0 ]; then
  for i in $(seq 0 $(($ZIP_COUNT - 1))); do
    PLUGIN_URL=$($YQ e ".plugins.zips[$i].url" "$SCRIPT_DIR/$CONFIG_FILE")
    PLUGIN_NAME=$($YQ e ".plugins.zips[$i].name" "$SCRIPT_DIR/$CONFIG_FILE")
    echo "Installing premium plugin: $PLUGIN_NAME from $PLUGIN_URL"
    $PHP_CLI $WP_CLI plugin install "$PLUGIN_URL" --activate
  done
fi

# Use default WordPress theme — no theme install needed
echo "Using default WordPress theme."

echo "✅ WordPress installation complete in $PARENT_DIR."
