# Use NVIDIA CUDA base image with Python support
# Using CUDA 12.6 as mentioned in the example
FROM nvidia/cuda:12.6.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    git \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a symbolic link for python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Upgrade pip
RUN pip install --upgrade pip

# Set working directory
WORKDIR /app

# Install PyTorch with CUDA 12.6 support
RUN pip install torch --index-url https://download.pytorch.org/whl/cu126

# Install CuPy for CUDA 12.x
RUN pip install cupy-cuda12x

# Install torchpq
RUN pip install torchpq

# Install PLAS from GitHub
RUN pip install git+https://github.com/fraunhoferhhi/PLAS.git

# Copy project files
COPY . .

# Install SOGS and its dependencies from pyproject.toml
RUN pip install .

# Create directories for input and output
RUN mkdir -p /data/input /data/output

# Set the default command to show help
CMD ["sogs-compress", "--help"]