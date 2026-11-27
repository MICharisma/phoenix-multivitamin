# Telemetry and LiveDashboard · 01 · Kisumu Winam metrics

Dispatcher Achieng counts lake ferries leaving Kisumu International across
Winam Gulf. Each crossing calls `:telemetry.execute/3`; the board attaches a
handler MFA and detaches when the LiveView ends.

**What it teaches**

- `:telemetry.execute/3` emits a named event with measurements and metadata.
- `:telemetry.attach/4` registers a handler MFA with opaque config; duplicate
  ids return `{:error, :already_exists}`.
- `:telemetry.detach/1` removes the handler; a second detach returns
  `{:error, :not_found}`.

**Files**

| File | Role |
| --- | --- |
| [`winam_emitter.ex`](winam_emitter.ex) | Domain emit of the Winam ferry event |
| [`winam_metrics_live.ex`](winam_metrics_live.ex) | Attach on connect, detach on terminate |
| [`winam_metrics_live_test.exs`](winam_metrics_live_test.exs) | Probe handlers and attach/detach results |

**Try it**

```sh
mix phx.server
```

Open
[/features/23-telemetry-and-livedashboard/01-kisumu-winam-metrics](http://localhost:4000/features/23-telemetry-and-livedashboard/01-kisumu-winam-metrics).

```sh
mix test features/23-telemetry-and-livedashboard/01-kisumu-winam-metrics/winam_metrics_live_test.exs
```
