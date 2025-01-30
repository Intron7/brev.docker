# Use an official NVIDIA CUDA image as the base
FROM nvidia/cuda:12.8.0-devel-ubuntu24.04

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    UV_NO_CACHE=1 \
    PATH="/root/.local/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.12 python3.12-venv python3-pip curl git \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager
RUN curl -fsSL https://astral.sh/uv/install.sh | sh

# Set up a virtual environment and install packages
WORKDIR /workspace

RUN uv venv
RUN uv pip install --upgrade pip
RUN uv pip install "jupyterlab"

# Expose JupyterLab default port
EXPOSE 8888

# Start JupyterLab on container startup
CMD ["uv", "pip", "install", "jupyterlab"] && \
    ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
