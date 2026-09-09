#!/bin/bash

utils=/opt/supervisor-scripts/utils
. "${utils}/logging.sh"
. "${utils}/cleanup_generic.sh"
. "${utils}/environment.sh"
. "${utils}/exit_portal.sh" "Musubi H3 Dashboard"

. /venv/main/bin/activate

/usr/local/lib/musubi/workspace-layout.sh

export HF_HOME=/workspace/.cache/huggingface
export HF_HUB_CACHE=/workspace/.cache/huggingface/hub
export HF_XET_CACHE=/workspace/.cache/huggingface/xet
export TORCH_HOME=/workspace/.cache/torch
export PYTHONUNBUFFERED=1
export PYTHONPATH=/opt/musubi-tuner/src

while [[ -f /.provisioning ]]; do
    echo "Musubi dashboard startup paused until provisioning completes"
    sleep 5
done

echo "Starting Musubi H3 Dashboard"
cd /workspace/projects
pty /venv/main/bin/python -m musubi_tuner.gui_dashboard \
    --host 127.0.0.1 \
    --port 17860 2>&1
