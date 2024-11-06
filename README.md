# Bitcoin UTXO Indexer

A Bitcoin UTXO indexer that monitors and tracks the creation and spending of UTXOs. This tool processes Bitcoin blocks in real-time and sends updates to a specified webhook endpoint.

## Features

- Processes blocks in batches
- Configurable polling interval
- Webhook notifications
- Efficient transaction processing

## Build and Run the Service
Run the following command to build and start the service:
```sh
cargo run --release
```
or if you have Just installed:

```sh
just run
```

## Configuration

```rust
let indexer = BitcoinIndexer::new(
    Network::Regtest,
    "rpc_username",
    "rpc_password",
    "localhost",
    18443,
    "http://your-webhook-url/endpoint",
    0, // Start from genesis block
)?;

indexer.run(Duration::from_secs(10)).await?;
```

## Data Schema

### Block Update
```rust
struct BlockUpdate {
    height: i32,
    hash: String,
    timestamp: DateTime,
    utxo_updates: Vec,
}
```

### UTXO Update
```rust
struct UtxoUpdate {
    id: String,              // txid:vout
    address: String,         // Bitcoin address
    public_key: Option,
    txid: String,
    vout: i32,
    amount: i64,            // Amount in satoshis
    script_pub_key: String,
    script_type: String,    // P2PKH, P2SH, P2WPKH, etc.
    created_at: DateTime,
    block_height: i32,
    spent_txid: Option,
    spent_at: Option<DateTime>,
    spent_block: Option,
}
```

## Webhook Format

The indexer sends POST requests to the configured webhook URL with the following JSON structure:
```json
{
    "height": 123456,
    "hash": "000000000000a3a588e95a2f328cdcd29e591f9e3172095239c1eec2a89b4ef7",
    "timestamp": "2024-01-01T00:00:00Z",
    "utxo_updates": [
        {
            "id": "7a6d3b2a1c8f4e5d9b0c1a2b3c4d5e6f7a8b9c0d:0",
            "address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
            "public_key": "02a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef01",
            "txid": "7a6d3b2a1c8f4e5d9b0c1a2b3c4d5e6f7a8b9c0d",
            "vout": 0,
            "amount": 5000000000,
            "script_pub_key": "0014a1b2c3d4e5f67890123456789abcdef01234567",
            "script_type": "P2WPKH",
            "created_at": "2024-01-01T00:00:00Z",
            "block_height": 123456,
            "spent_txid": "8b7c4d3e2f1a9b8c7d6e5f4a3b2c1d0e9f8a7b6c",
            "spent_at": "2024-01-01T01:00:00Z",
            "spent_block": 123457
        },
        {
            "id": "8b7c4d3e2f1a9b8c7d6e5f4a3b2c1d0e9f8a7b6c:1",
            "address": "3D2oetdNuZUqQHPJmcMDDHYoqkyNVsFk9r",
            "public_key": null,
            "txid": "8b7c4d3e2f1a9b8c7d6e5f4a3b2c1d0e9f8a7b6c",
            "vout": 1,
            "amount": 1000000000,
            "script_pub_key": "a914b472a266d0bd89c13706a4132ccfb16f7c3b9fcb87",
            "script_type": "P2SH",
            "created_at": "2024-01-01T01:00:00Z",
            "block_height": 123457,
            "spent_txid": null,
            "spent_at": null,
            "spent_block": null
        }
    ]
}
```