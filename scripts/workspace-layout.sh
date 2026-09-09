#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p \
  /workspace/.cache/huggingface/hub \
  /workspace/.cache/huggingface/xet \
  /workspace/.cache/torch \
  /workspace/cache/latents \
  /workspace/cache/text \
  /workspace/datasets \
  /workspace/models/MiniMax-H3/adapters \
  /workspace/models/MiniMax-H3/diffusion_models \
  /workspace/models/MiniMax-H3/text_encoders \
  /workspace/models/MiniMax-H3/vae \
  /workspace/output \
  /workspace/projects \
  /workspace/logs

# Convenient read-only-looking path in Jupyter. The software itself remains in
# the image; user data and generated projects remain on persistent storage.
if [[ ! -e /workspace/musubi-tuner ]]; then
  ln -s /opt/musubi-tuner /workspace/musubi-tuner
fi

