FROM vastai/pytorch:2.11.0-cuda-12.8.1-py312-24.04-2026-09-08

ARG MUSUBI_REPOSITORY=https://github.com/AkaneTendo25/musubi-tuner.git
ARG MUSUBI_COMMIT=f55e37c8557765851a406f9db1cbc6599fe1b184

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=utf-8 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/workspace/.cache/huggingface \
    HF_HUB_CACHE=/workspace/.cache/huggingface/hub \
    HF_XET_CACHE=/workspace/.cache/huggingface/xet \
    TORCH_HOME=/workspace/.cache/torch \
    MUSUBI_ROOT=/opt/musubi-tuner \
    MUSUBI_WORKSPACE=/workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
        aria2 \
        build-essential \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        git-lfs \
        libgl1 \
        libglib2.0-0 \
        libsndfile1 \
        nano \
        rsync \
        tmux \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --filter=blob:none --no-checkout "${MUSUBI_REPOSITORY}" "${MUSUBI_ROOT}" \
    && cd "${MUSUBI_ROOT}" \
    && git fetch --depth 1 origin "${MUSUBI_COMMIT}" \
    && git checkout --detach "${MUSUBI_COMMIT}" \
    && /venv/main/bin/python -m pip install --no-cache-dir -e ".[dashboard]" \
    && /venv/main/bin/python -m pip install --no-cache-dir \
        ascii-magic \
        hf_xet \
        matplotlib \
        prompt-toolkit \
        tensorboard \
    && git rev-parse HEAD > /opt/musubi-version.txt

COPY scripts/start-services.sh /usr/local/bin/start-musubi-services
COPY scripts/verify-install.py /usr/local/lib/musubi/verify-install.py
COPY scripts/workspace-layout.sh /usr/local/lib/musubi/workspace-layout.sh

RUN chmod 0755 \
        /usr/local/bin/start-musubi-services \
        /usr/local/lib/musubi/workspace-layout.sh \
    && /venv/main/bin/python /usr/local/lib/musubi/verify-install.py --build

WORKDIR /workspace

# Vast's Jupyter/SSH launch modes replace the image entrypoint. The template's
# on-start command invokes start-musubi-services after Vast finishes its setup.
CMD ["bash"]
