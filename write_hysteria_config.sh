#!/usr/bin/env bash

# Get the domain name from the environment variable
DOMAIN_NAME="$1"

# Check if DOMAIN_NAME is provided
if [ -z "$DOMAIN_NAME" ]; then
  echo "Error: DOMAIN_NAME is not provided."
  echo "Usage: $0 <your_domain>"
  exit 1
fi
# Get the email address from the environment variable
EMAIL_ADDRESS="$2"

# Check if EMAIL_ADDRESS is provided
if [ -z "$EMAIL_ADDRESS" ]; then
  echo "Error: EMAIL_ADDRESS is not provided."
  echo "Usage: $0 <your_domain> <your_email>"
  exit 1
fi

# Get the masquerade URL from the environment variable
MASQUERADE_URL="$3"

# Check if MASQUERADE_URL is provided
if [ -z "$MASQUERADE_URL" ]; then
  echo "Error: MASQUERADE_URL is not provided."
  echo "Usage: $0 <your_domain> <your_email> <your_masquerade_url>"
  exit 1
fi

# Get the auth password from the environment variable
AUTH_PASSWORD="$4"

# Check if AUTH_PASSWORD is provided
if [ -z "$AUTH_PASSWORD" ]; then
  echo "Error: AUTH_PASSWORD is not provided."
  echo "Usage: $0 <your_domain> <your_email> <your_masquerade_url> <your_auth_password>"
  exit 1
fi

# Define the config file path
CONFIG_FILE_SAMPLE="hysteria_config_sample.yaml"
CONFIG_FILE="hysteria_config.yaml"

# Copy the sample config file
cat "$CONFIG_FILE_SAMPLE" > "$CONFIG_FILE"

# Detect OS for sed compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS/BSD sed requires a backup extension (can be empty), but use -i '' as two separate arguments
  SED_INPLACE=(sed -i '')
else
  # GNU sed (Linux) allows -i without extension
  SED_INPLACE=(sed -i)
fi

# Replace the placeholder with the actual domain name
"${SED_INPLACE[@]}" "s/PLACEHOLDER_YOUR_DOMAIN/$DOMAIN_NAME/g" "$CONFIG_FILE"
echo "Successfully updated $CONFIG_FILE with domain: $DOMAIN_NAME"

# Replace the placeholder with the actual email address
"${SED_INPLACE[@]}" "s/PLACEHOLDER_YOUR_EMAIL/$EMAIL_ADDRESS/g" "$CONFIG_FILE"
echo "Successfully updated $CONFIG_FILE with email: $EMAIL_ADDRESS"

# Replace the placeholder with the actual auth password
"${SED_INPLACE[@]}" "s/PLACEHOLDER_AUTH_PASSWORD/$AUTH_PASSWORD/g" "$CONFIG_FILE"
echo "Successfully updated $CONFIG_FILE with auth password."

# Replace the placeholder with the actual masquerade URL
"${SED_INPLACE[@]}" "s|PLACEHOLDER_MASQUERADE_URL|$MASQUERADE_URL|g" "$CONFIG_FILE"
echo "Successfully updated $CONFIG_FILE with masquerade URL: $MASQUERADE_URL"


