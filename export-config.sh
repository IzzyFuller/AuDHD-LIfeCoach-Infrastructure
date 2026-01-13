#!/bin/bash
# Export Terraform topology configuration as JSON for component consumption

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Output file
OUTPUT_FILE="${SCRIPT_DIR}/topology-config.json"

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "Error: Terraform not initialized. Run 'terraform init' first."
    exit 1
fi

# Export the topology_config output as JSON
echo "Exporting topology configuration..."
terraform output -json topology_config > "$OUTPUT_FILE"

echo "✓ Topology configuration exported to: $OUTPUT_FILE"
echo ""
echo "Components can consume this configuration at startup to discover:"
echo "  - Exchange names and configuration"
echo "  - Queue names and configuration"
echo "  - Bindings (routing topology)"
echo "  - Connection details (endpoint, vhost)"
