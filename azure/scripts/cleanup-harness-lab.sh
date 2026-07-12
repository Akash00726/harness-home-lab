#!/bin/bash

set -euo pipefail

RESOURCE_GROUP="rg-harness-lab"

echo "This will permanently delete:"
echo "  - AKS"
echo "  - ACR"
echo "  - All resources in ${RESOURCE_GROUP}"
echo ""

read -rp "Continue? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
    echo "Cancelled."
    exit 0
fi

az group delete \
    --name "${RESOURCE_GROUP}" \
    --yes \
    --no-wait

echo ""
echo "Deletion has been initiated."
echo "You can monitor progress using:"
echo ""
echo "az group exists --name ${RESOURCE_GROUP}"