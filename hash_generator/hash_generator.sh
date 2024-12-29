#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Output file for hashed passwords
OUTPUT_FILE="/hashes/.env.caddy"

echo "Generating bcrypt hashed passwords..."

# Function to generate bcrypt hash using htpasswd
generate_hash() {
    # Usage: generate_hash username password
    htpasswd -nbBC 12 "$1" "$2" | cut -d':' -f2 | sed 's/\$/$$/g'
}

# Generate hashes for Caddy basic_auth
PIHOLE_WEBPASSWORD_HASH=$(generate_hash "admin" "$PIHOLE_WEBPASSWORD")
HOMEASSISTANT_PASSWORD_HASH=$(generate_hash "$HOMEASSISTANT_USERNAME" "$HOMEASSISTANT_PASSWORD")
CALIBRE_PASSWORD_HASH=$(generate_hash "$CALIBRE_USERNAME" "$CALIBRE_PASSWORD")
STATIC_SITE_PASSWORD_HASH=$(generate_hash "$STATIC_SITE_USERNAME" "$STATIC_SITE_PASSWORD")

# Write hashed passwords to output file
cat <<EOF > "$OUTPUT_FILE"
PIHOLE_WEBPASSWORD_HASH=$PIHOLE_WEBPASSWORD_HASH
HOMEASSISTANT_PASSWORD_HASH=$HOMEASSISTANT_PASSWORD_HASH
CALIBRE_PASSWORD_HASH=$CALIBRE_PASSWORD_HASH
STATIC_SITE_PASSWORD_HASH=$STATIC_SITE_PASSWORD_HASH
EOF

echo "Hashed passwords written to $OUTPUT_FILE"
