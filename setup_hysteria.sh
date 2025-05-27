#!/usr/bin/env bash

# Exit on error
set -e

# Default DNS propagation wait time (in seconds)
WAIT_TIME=600  # 10 minutes

# Function to show usage
show_usage() {
    echo "Usage: $0 -d DOMAIN -s SUBDOMAIN -i IP -p DDNS_PASSWORD -e EMAIL -m MASQUERADE_URL -a AUTH_PASSWORD [-w WAIT_TIME]"
    echo "  -d : Domain name (e.g., example.com)"
    echo "  -s : Subdomain name"
    echo "  -i : Instance public IP"
    echo "  -p : Namecheap Dynamic DNS password"
    echo "  -e : Email address for SSL certificate"
    echo "  -m : Masquerade URL"
    echo "  -a : Auth password for Hysteria"
    echo "  -w : Wait time in seconds for DNS propagation (default: 600)"
    exit 1
}

# Parse command line arguments
while getopts "d:s:i:p:e:m:a:w:h" opt; do
    case $opt in
        d) DOMAIN="$OPTARG" ;;
        s) SUBDOMAIN="$OPTARG" ;;
        i) INSTANCE_PUBLIC_IP="$OPTARG" ;;
        p) NAMECHEAP_DDNS_PASS="$OPTARG" ;;
        e) EMAIL="$OPTARG" ;;
        m) MASQUERADE_URL="$OPTARG" ;;
        a) AUTH_PASSWORD="$OPTARG" ;;
        w) WAIT_TIME="$OPTARG" ;;
        h) show_usage ;;
        ?) show_usage ;;
    esac
done

# Check required parameters
if [[ -z "$DOMAIN" ]] || [[ -z "$SUBDOMAIN" ]] || [[ -z "$INSTANCE_PUBLIC_IP" ]] || \
   [[ -z "$NAMECHEAP_DDNS_PASS" ]] || [[ -z "$EMAIL" ]] || \
   [[ -z "$MASQUERADE_URL" ]] || [[ -z "$AUTH_PASSWORD" ]]; then
    echo "Error: Missing required parameters"
    show_usage
fi

echo "1. Updating DNS records..."
./configure_namecheap_dns.sh "$DOMAIN" "$SUBDOMAIN" "$INSTANCE_PUBLIC_IP" "$NAMECHEAP_DDNS_PASS"

echo "2. Generating Hysteria configuration..."
./write_hysteria_config.sh "${SUBDOMAIN}.${DOMAIN}" "$EMAIL" "$MASQUERADE_URL" "$AUTH_PASSWORD"

echo "3. Waiting ${WAIT_TIME} seconds for DNS propagation..."
sleep "$WAIT_TIME"

echo "4. Starting Hysteria server..."
docker compose up -d

echo "Setup complete! Hysteria server is starting..."
