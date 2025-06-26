#!/bin/bash
# This script generates a modified values.yaml file for the nextcloud helm chart. 
# Namely, it generates secrtets for : 
# DATABASE_PASSWORD, FULLTEXTSEARCH_PASSWORD, IMAGINARY_SECRET, NEXTCLOUD_PASSWORD, ONLYOFFICE_SECRET, RECORDING_SECRET, REDIS_PASSWORD, SIGNALING_SECRET, TALK_INTERNAL_SECRET, TURN_SECRET, WHITEBOARD_SECRET
# and creates an secret_values.yaml file with these secrets. 

set -e

SECRET_KEYS=(
  DATABASE_PASSWORD
  FULLTEXTSEARCH_PASSWORD
  IMAGINARY_SECRET
  NEXTCLOUD_PASSWORD
  ONLYOFFICE_SECRET
  RECORDING_SECRET
  REDIS_PASSWORD
  SIGNALING_SECRET
  TALK_INTERNAL_SECRET
  TURN_SECRET
  WHITEBOARD_SECRET
)

# Function to generate a random secret without @, : , /, \ and trim to 32 characters
generate_secret() {
  # Generate base64, remove @ and :, trim to 32 chars
  openssl rand -base64 64 | tr -d '@:/\\' | head -c 32
}

# Copy values.yaml to secret_values.yaml
cp values.yaml secret_values.yaml

# Update each secret key in secret_values.yaml
for key in "${SECRET_KEYS[@]}"; do
  secret=$(generate_secret)
  # Replace the value for the key (assumes YAML format: KEY: value)
  sed -i "s/^\($key:\s*\).*/\1\"$secret\"/" secret_values.yaml
done