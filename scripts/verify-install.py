from __future__ import annotations

import argparse
import importlib.util
import pathlib
import subprocess
import sys


def require(module: str) -> None:
    if importlib.util.find_spec(module) is None:
        raise SystemExit(f"Required module is missing: {module}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build", action="store_true")
    args = parser.parse_args()

    for module in (
        "accelerate",
        "av",
        "bitsandbytes",
        "diffusers",
        "fastapi",
        "huggingface_hub",
        "musubi_tuner",
        "safetensors",
        "sse_starlette",
        "torch",
        "transformers",
        "uvicorn",
    ):
        require(module)

    import torch

    version_file = pathlib.Path("/opt/musubi-version.txt")
    commit = version_file.read_text(encoding="utf-8").strip() if version_file.exists() else "unknown"
    print(f"Musubi commit: {commit}")
    print(f"Python: {sys.version.split()[0]}")
    print(f"PyTorch: {torch.__version__}")
    print(f"PyTorch CUDA build: {torch.version.cuda}")

    if not args.build:
        if not torch.cuda.is_available():
            raise SystemExit("CUDA is not available to PyTorch")
        print(f"GPU: {torch.cuda.get_device_name(0)}")
        print(f"Compute capability: {torch.cuda.get_device_capability(0)}")
        subprocess.run(["nvidia-smi"], check=True)


if __name__ == "__main__":
    main()

