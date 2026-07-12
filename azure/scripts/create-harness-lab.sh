#!/bin/bash
set -euo pipefail

# --- Configuration ---
LOCATION="centralindia"
RESOURCE_GROUP="rg-harness-lab"
AKS_NAME="aks-harness-lab"
ACR_NAME="acrakashharnesslab"
TAGS="Environment=Lab Project=Harness"

# --- Functions ---
log() { echo -e "\n[$(date +'%H:%M:%S')] $1"; }

ensure_rg() {
    log "Ensuring Resource Group exists..."
    az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" --tags $TAGS > /dev/null
}

create_acr() {
    if ! az acr show --name "${ACR_NAME}" --resource-group "${RESOURCE_GROUP}" &>/dev/null; then
        log "Creating ACR..."
        az acr create --resource-group "${RESOURCE_GROUP}" --name "${ACR_NAME}" --sku Basic --admin-enabled true --tags $TAGS
    else
        log "ACR already exists."
    fi
}

show_acr_credentials() {
    log "Retrieving ACR Credentials..."
    
    # Using 'table' output instead of JSON to avoid needing jq
    echo "------------------------------------------"
    az acr credential show --name "${ACR_NAME}" --resource-group "${RESOURCE_GROUP}" --output table
    echo "------------------------------------------"
}

login_acr() {
    log "Logging into ACR..."
    az acr login --name "${ACR_NAME}"
}

create_aks() {
    if ! az aks show --name "${AKS_NAME}" --resource-group "${RESOURCE_GROUP}" &>/dev/null; then
        log "Creating AKS Cluster (Spot Instances, Scale-to-Zero)..."
        az aks create \
            --resource-group "${RESOURCE_GROUP}" \
            --name "${AKS_NAME}" \
            --location "${LOCATION}" \
            --tier Free \
            --node-count 1 \
            --node-vm-size "Standard_B2als_v2" \
            --enable-managed-identity \
            --attach-acr "${ACR_NAME}" \
            --enable-cluster-autoscaler \
            --min-count 0 \
            --max-count 2 \
            --priority Spot \
            --eviction-policy Delete \
            --generate-ssh-keys \
            --tags $TAGS
    else
        log "AKS Cluster already exists."
    fi
    log "Downloading kubeconfig..."
    az aks get-credentials --resource-group "${RESOURCE_GROUP}" --name "${AKS_NAME}" --overwrite-existing
}

# --- Mandatory Pre-check ---
ensure_rg

# --- Argument Parsing ---
if [ $# -eq 0 ]; then
    echo "Usage: $0 [--acr | --creds | --login | --aks | --all]"
    exit 1
fi

for arg in "$@"; do
    case $arg in
        --acr)    create_acr ;;
        --creds)  show_acr_credentials ;;
        --login)  login_acr ;;
        --aks)    create_aks ;;
        --all)    create_acr; show_acr_credentials; login_acr; create_aks ;;
        *)        echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

log "Operation complete."