# Use an official NVIDIA CUDA image as the base
FROM nvidia/cuda:12.8.0-devel-ubuntu24.04

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]
# The installer requires curl (and certificates) to download the release archive
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN uv venv /opt/venv --python 3.12
# Use the virtual environment automatically
ENV VIRTUAL_ENV=/opt/venv
# Ensure CUDA paths are set properly
ENV PATH "/usr/local/cuda/bin:$PATH"
ENV CUDA_HOME "/usr/local/cuda"
ENV LD_LIBRARY_PATH "/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
ENV LIBRARY_PATH "/usr/local/cuda/lib64:$LIBRARY_PATH"
ENV PATH "/opt/venv/bin:$PATH"
ENV UV_HTTP_TIMEOUT 120
RUN uv pip install jupyterlab 'rapids-singlecell[rapids12]' ipywidgets --extra-index-url=https://pypi.nvidia.com --index-strategy=unsafe-best-match

# Expose JupyterLab default port
EXPOSE 8888

# Start JupyterLab on container startup
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser","--allow-root","--NotebookApp.token=''", "--NotebookApp.password=''"]
