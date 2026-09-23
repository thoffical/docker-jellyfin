# Switch to the LinuxServer image which handles ARM64 servers flawlessly
FROM linuxserver/jellyfin:latest

# Install rclone and fuse dependencies inside the LinuxServer Ubuntu base
RUN apt-get update && apt-get install -y rclone fuse3 && rm -rf /var/lib/apt/lists/*

# Cloud web platforms use port 8000 for standard web routing
EXPOSE 8000
ENV JELLYFIN_HTTP_PORT=8000

# Setup open workspace paths matching LinuxServer directory standards
RUN mkdir -p /workspace/config /workspace/cache /workspace/data /workspace/music
RUN chmod -R 777 /workspace

# Copy your local rclone config token and entry script
COPY rclone.conf /workspace/rclone.conf
COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

# LinuxServer images use specific environment variables for directory layouts
ENV JELLYFIN_DATA_DIR=/workspace/data
ENV JELLYFIN_CONFIG_DIR=/workspace/config
ENV JELLYFIN_CACHE_DIR=/workspace/cache

ENTRYPOINT ["/workspace/entrypoint.sh"]
