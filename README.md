# blake2b-pow-bench

## Usage

First, run a node (useful to benchmark with work peers), or a standalone [work server](https://github.com/nanocurrency/nano-work-server/releases/latest).

```bash
./nano-work-server --gpu 0:0 --cpu-threads 0 --listen-address [::1]:7076
```

For other options such as not using a GPU use `--help`.

Once started, the benchmark can be started:

```bash
./benchmark.sh multiplier N worker_uri [use_peers=true] [simultaneous_processes=1]
```

## Using for low multipliers

Use `simultaneous_processes` with a value of `5` or higher to launch many simultaneous processes, minimizing the effect of latency.

**Note**: if `simultaneous_processes` is higher than `1`, it will not be possible to stop the benchmark without closing the window (SIGINT is not handled correctly).