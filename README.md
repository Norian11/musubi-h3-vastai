# Musubi MiniMax-H3 template for Vast.ai

This project builds a reproducible Vast.ai image containing the
`AkaneTendo25/musubi-tuner` MiniMax-H3 fork at commit
`f55e37c8557765851a406f9db1cbc6599fe1b184`.

The image contains the trainer and dashboard, but deliberately does not contain
model weights, datasets, captions, caches, tokens, or training output. Those all
belong under `/workspace`, which is the persistent storage location on Vast.ai.

## Included

- CUDA 12.8 runtime and PyTorch 2.11
- Python 3.12
- Akane's MiniMax-H3 fork and prebuilt dashboard
- FFmpeg, Git, aria2, rsync, tmux, TensorBoard, and Hugging Face Xet
- Automatic persistent workspace layout
- Authenticated Vast Instance Portal route for the Musubi dashboard
- Runtime GPU verification command

## Persistent layout

```text
/workspace/
  datasets/
  models/MiniMax-H3/
    adapters/
    diffusion_models/
    text_encoders/
    vae/
  cache/
    latents/
    text/
  output/
  projects/
```

## Build and publish with GitHub

1. Create an empty GitHub repository named `musubi-h3-vastai`.
2. Upload this project's contents to the repository's `main` branch.
3. Open **Actions**, select **Build Musubi H3 image**, and run the workflow.
4. When it finishes, make the generated GHCR package public, or configure Vast
   with GHCR authentication for a private package.
5. The image will be:

  `ghcr.io/norian11/musubi-h3-vastai:cu128-portal-v2`

## Vast.ai fields

The exact intended settings are recorded in `vast-template.json`. Important
choices:

- Launch mode: **Jupyter + SSH**
- Enable **JupyterLab** and direct HTTPS
- Jupyter directory: `/workspace`
- On-start script:

  ```bash
  entrypoint.sh
  ```

- Recommended disk: 250 GB, adjusted upward for your datasets and caches
- Keep the template private until it has been tested

The dashboard is a Supervisor-managed service bound to `127.0.0.1:17860`.
Vast's authenticated portal proxies external port 7860 to it. Do not start the
dashboard on `0.0.0.0:7860`; it can launch arbitrary training processes with
root's permissions.

## First-instance verification

Run this in the Jupyter terminal:

```bash
/venv/main/bin/python /usr/local/lib/musubi/verify-install.py
```

Then open **Musubi H3 Dashboard** from the Instance Portal. Do not begin a long
training run until the verification succeeds and a short cache/train smoke test
has completed.

## Updating the fork

Do not run `git pull` inside a rented instance. Change `MUSUBI_COMMIT` in the
Dockerfile, rebuild the image, test a short job, and only then update the Vast
template tag. This preserves reproducibility and leaves existing instances
unchanged.
