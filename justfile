# build rust binary
alias b := build

build:
    cargo build --release

run *ARGS:
    RUST_LOG=info cargo run --release -- {{ARGS}}

# Example usage with webhook URL
run-with-webhook:
    RUST_LOG=info cargo run --release -- --webhook-url "http://hyperstate-utxos:5557/hook"

# Example usage with all parameters
run-full:
    RUST_LOG=info cargo run --release -- \
        --webhook-url "http://hyperstate-utxos:5557/hook" \
        --rpc-user "user" \
        --rpc-password "password" \
        --rpc-host "bitcoin" \
        --rpc-port "18443" \
        --start-height "0"