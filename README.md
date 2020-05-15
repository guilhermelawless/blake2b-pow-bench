# blake2b-pow-bench

## Usage

First, run a node (useful to benchmark with work peers), or a standalone work server.

Included are binaries of [nano-work-server](https://github.com/nanocurrency/nano-work-server) in `bin/`. Run a work server as:

```bash
./nano-work-server --gpu 0:0 --cpu-threads 0 --listen-address [::1]:7076
```

For other options such as not using a GPU use `--help`.

Once started, the benchmark can be started:

```bash
./benchmark.sh MULTIPLIER N WORKER_URI USE_PEERS
```

All values are optional but sequential:
- `multiplier` defaults to 1.0 (make sure the base difficulty of the server is correct)
- `N` defaults to 50 and is the number of requests to perform
- `worker_uri` defaults to `[::1]:7076`
- `use_peers` defaults to `true`

## Using for low multipliers

The benchmark is sequential, meaning network latency must be taken into account for low multipliers, if using a remote work server. 
