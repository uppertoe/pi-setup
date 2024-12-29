#!/bin/bash

# Base directory containing WireGuard configuration files
WG_CONFIG_DIR="./wireguard/config"

# Ensure qrencode is installed and functional
if ! qrencode --version &> /dev/null; then
    echo "qrencode is not installed or not in PATH. Please install it first (e.g., sudo apt install qrencode)."
    exit 1
fi

# Function to list available peers (recursively)
list_peers() {
    echo "Available peers:"
    echo "Looking recursively in directory: $WG_CONFIG_DIR"
    if [[ ! -d "$WG_CONFIG_DIR" ]]; then
        echo "Directory $WG_CONFIG_DIR does not exist."
        exit 1
    fi

    # Find all .conf files recursively
    conf_files=$(find "$WG_CONFIG_DIR" -type f -name "*.conf")

    if [[ -z "$conf_files" ]]; then
        echo "No .conf files found in $WG_CONFIG_DIR or its subdirectories."
        exit 1
    fi

    echo "$conf_files" | while read -r file; do
        echo "$(basename "$file") (in $(dirname "$file"))"
    done
}

# Function to generate QR code
generate_qr() {
    local peer="$1"

    # Find the full path of the specified peer configuration file
    local peer_config
    peer_config=$(find "$WG_CONFIG_DIR" -type f -name "$peer" 2>/dev/null)

    if [[ -z "$peer_config" ]]; then
        echo "Error: Peer configuration file '$peer' not found in $WG_CONFIG_DIR or its subdirectories."
        exit 1
    fi

    echo "Generating QR code for peer '$peer'..."
    qrencode -t ansiutf8 < "$peer_config"

    # Optionally save as an image
    local output_file="${peer%.conf}.png"
    qrencode -o "$output_file" < "$peer_config"
    echo "QR code saved as $output_file."
}

# Script usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -l               List available peers"
    echo "  -p <peer.conf>   Generate QR code for the specified peer"
    echo "  -h               Show this help message"
    exit 0
}

# Parse command-line arguments
while getopts ":lp:h" opt; do
    case $opt in
        l)
            list_peers
            exit 0
            ;;
        p)
            generate_qr "$OPTARG"
            exit 0
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

# Default behavior if no arguments are provided
echo "No options provided. Use -h for help."
