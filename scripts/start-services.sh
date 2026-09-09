#!/usr/bin/env bash
set -Eeuo pipefail

/usr/local/lib/musubi/workspace-layout.sh

export HF_HOME=/workspace/.cache/huggingface
export HF_HUB_CACHE=/workspace/.cache/huggingface/hub
export HF_XET_CACHE=/workspace/.cache/huggingface/xet
export TORCH_HOME=/workspace/.cache/torch
export PYTHONUNBUFFERED=1
export PYTHONPATH=/opt/musubi-tuner/src

mkdir -p /var/log/portal /workspace/logs

DASHBOARD_PID=/workspace/.musubi-dashboard.pid
DASHBOARD_LOG=/var/log/portal/musubi-dashboard.log

dashboard_running() {
  [[ -s "${DASHBOARD_PID}" ]] \
    && kill -0 "$(cat "${DASHBOARD_PID}")" 2>/dev/null
}

if ! dashboard_running; then
  rm -f "${DASHBOARD_PID}"
  cd /workspace/projects
  nohup /venv/main/bin/python -m musubi_tuner.gui_dashboard \
    --host 127.0.0.1 \
    --port 17860 \
    >>"${DASHBOARD_LOG}" 2>&1 &
  echo $! > "${DASHBOARD_PID}"
fi

for _ in $(seq 1 30); do
  if curl --fail --silent --show-error http://127.0.0.1:17860/ >/dev/null; then
    echo "Musubi H3 dashboard is ready on internal port 17860."
    exit 0
  fi
  sleep 1
done

echo "Musubi dashboard did not become ready. Recent log output:" >&2
tail -n 100 "${DASHBOARD_LOG}" >&2 || true
exit 1

