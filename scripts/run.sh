#!/usr/bin/env bash
set -e

# ------------------------------------------------------------------------------
# Run the prebuilt memory-management-chatbot-dev Docker image interactively
# Passes host UID/GID for runtime remapping (matches DevContainer behavior)
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"
IMAGE_NAME="memory-management-chatbot-dev:latest"

# ------------------------------------------------------------------------------
# Ensure image exists
# ------------------------------------------------------------------------------
if ! docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo "[INFO] Image '$IMAGE_NAME' not found. Building it first..."
    "${SCRIPT_DIR}/build_image.sh"
fi

# ------------------------------------------------------------------------------
# Run the container with DevContainer-compatible settings
# Pass HOST_UID and HOST_GID for runtime remapping
# ------------------------------------------------------------------------------
docker run --rm -it \
    --hostname memory-management-chatbot-devcontainer \
    --name "memory-management-chatbot-dev-${USER}" \
    --env "HOST_UID=$(id -u)" \
    --env "HOST_GID=$(id -g)" \
    --env "DISPLAY=${DISPLAY}" \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume "$PROJECT_ROOT:/workspaces/$PROJECT_NAME" \
    --gpus all \
    --workdir /workspaces/$PROJECT_NAME \
    "$IMAGE_NAME"
