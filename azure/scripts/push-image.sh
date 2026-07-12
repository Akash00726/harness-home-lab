#!/usr/bin/env bash

set -Eeuo pipefail

#############################################
# Configuration
#############################################

ACR_NAME="acrakashharnesslab"
DEFAULT_IMAGE_NAME="sample-app"
DEFAULT_IMAGE_TAG="v1.0.0"

#############################################
# Arguments
#############################################

IMAGE_NAME="${1:-$DEFAULT_IMAGE_NAME}"
IMAGE_TAG="${2:-$DEFAULT_IMAGE_TAG}"

#############################################
# Colors
#############################################

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

START_TIME=$(date +%s)

#############################################
# Logging Functions
#############################################

step() {
    echo
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}"
}

info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

fail() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

#############################################
# Error Handler
#############################################

trap 'fail "Script failed at line $LINENO"' ERR

#############################################
# Banner
#############################################

echo
echo "============================================================"
echo "        Harness Home Lab - Push Image to ACR"
echo "============================================================"

#############################################
# Prerequisites
#############################################

step "Step 1 - Checking prerequisites"

command -v az >/dev/null || fail "Azure CLI is not installed."

success "Azure CLI found."

command -v docker >/dev/null || fail "Docker is not installed."

success "Docker found."

#############################################
# Azure Login
#############################################

step "Step 2 - Azure Login"

if az account show >/dev/null 2>&1; then
    ACCOUNT=$(az account show --query user.name -o tsv)
    success "Already logged in as ${ACCOUNT}"
else
    info "Logging into Azure..."
    az login
fi

#############################################
# Check Local Image
#############################################

step "Step 3 - Docker Image"

if docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
    success "Local image found:"
    echo "  ${IMAGE_NAME}:${IMAGE_TAG}"
else
    info "Image not found."
    info "Building Docker image..."

    docker build \
        --progress=plain \
        -t "${IMAGE_NAME}:${IMAGE_TAG}" \
        .

    success "Docker image built successfully."
fi

#############################################
# Get Login Server
#############################################

step "Step 4 - Azure Container Registry"

LOGIN_SERVER=$(
    az acr show \
        --name "${ACR_NAME}" \
        --query loginServer \
        --output tsv | tr -d '\r'
)

info "Login Server : ${LOGIN_SERVER}"

#############################################
# Login ACR
#############################################

info "Logging into Azure Container Registry..."

az acr login \
    --name "${ACR_NAME}"

success "ACR login successful."

#############################################
# Tag Image
#############################################

step "Step 5 - Tagging Image"

FULL_IMAGE_NAME="${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"

echo
echo "${IMAGE_NAME}:${IMAGE_TAG}"
echo "        ↓"
echo "${FULL_IMAGE_NAME}"
echo

docker tag \
    "${IMAGE_NAME}:${IMAGE_TAG}" \
    "${FULL_IMAGE_NAME}"

success "Image tagged."

#############################################
# Push Image
#############################################

step "Step 6 - Pushing Image"

docker push "${FULL_IMAGE_NAME}"

success "Image pushed successfully."

#############################################
# Verify Repository
#############################################

step "Step 7 - Verifying ACR"

echo
echo "Repositories:"
az acr repository list \
    --name "${ACR_NAME}" \
    --output table

echo
echo "Available Tags:"
az acr repository show-tags \
    --name "${ACR_NAME}" \
    --repository "${IMAGE_NAME}" \
    --output table

#############################################
# Summary
#############################################

END_TIME=$(date +%s)
DURATION=$((END_TIME-START_TIME))

echo
echo "============================================================"
echo "                    SUMMARY"
echo "============================================================"

printf "%-18s %s\n" "ACR" "${ACR_NAME}"
printf "%-18s %s\n" "Image" "${IMAGE_NAME}"
printf "%-18s %s\n" "Tag" "${IMAGE_TAG}"
printf "%-18s %s\n" "Repository" "${FULL_IMAGE_NAME}"
printf "%-18s %s seconds\n" "Duration" "${DURATION}"

echo
success "Completed successfully!"
echo



# Uses defaults
#./push-image.sh

# Custom tag
#./push-image.sh v1.0.1

# Custom image and tag
#./push-image.sh sample-app v1.0.1