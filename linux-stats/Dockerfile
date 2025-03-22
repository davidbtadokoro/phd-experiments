# Use a minimal base image
FROM debian@sha256:1209d8fd77def86ceb6663deef7956481cc6c14a25e1e64daec12c0ceffcc19d

# Set non-interactive mode to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Bash and Python
RUN apt update && apt install -y \
    bash \
    git \
    cloc \
    gawk \
    python3 \
    python3-pip \
    python3-venv \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /linux-stats

# Copy necessary artifacts to container
COPY run_experiments.sh utils.sh plot.py ./

# Install Python dependencies
RUN python3 -m venv /linux-stats/venv && \
    /linux-stats/venv/bin/pip install --no-cache-dir numpy==2.2.4 pandas==2.2.3 matplotlib==3.10.1

# Ensure execution permissions
RUN chmod +x run_experiments.sh utils.sh

# Guarantee that the Linux mainline repo is capable of being manipulated
RUN git config --global --add safe.directory /linux-stats/linux-mainline

# Define entrypoint as `run_experiments.sh`
CMD ["bash", "run_experiments.sh", "linux-mainline", "v3.19", "v6.13"]
