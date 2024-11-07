# Build stage
FROM rust:1.81-slim-bookworm as builder

# Create a new empty shell project
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y pkg-config libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy manifests
COPY Cargo.toml Cargo.lock ./

# Copy source code
COPY src ./src
COPY justfile ./

# Build the application
RUN cargo build --release

# Final stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary from builder
COPY --from=builder /usr/src/app/target/release/hyperstate-indexer /usr/local/bin/

# Create a non-root user with specific UID
RUN useradd -m -u 1001 service
USER service

# Set environment variables
ENV RUST_LOG=info

# Set default values for arguments
ENV WEBHOOK_URL="http://hyperstate-utxos:5557/hook" \
    RPC_HOST="bitcoin" \
    RPC_PORT="18443" \
    RPC_USER="user" \
    RPC_PASSWORD="password"

# Use ENTRYPOINT and CMD combination for better argument handling
ENTRYPOINT ["hyperstate-indexer"]
CMD ["--webhook-url", "$WEBHOOK_URL", \
     "--rpc-host", "$RPC_HOST", \
     "--rpc-port", "$RPC_PORT", \
     "--rpc-user", "$RPC_USER", \
     "--rpc-password", "$RPC_PASSWORD"]