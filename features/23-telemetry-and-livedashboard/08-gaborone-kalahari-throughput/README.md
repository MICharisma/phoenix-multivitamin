# Telemetry and LiveDashboard · 08 · Gaborone Kalahari throughput

Ramp clerk Keabetswe counts CRJ-900s on the Kalahari apron at Gaborone
Sir Seretse Khama. An Agent holds the apron count; `telemetry_poller` calls
`measure_apron/0`, which reads that Agent and fires `:telemetry.execute/3`.

**What it teaches**

- `telemetry_poller` invokes an MFA on a period; that MFA must call
  `:telemetry.execute/3`.
- `Telemetry.Metrics.last_value/2` keeps the latest apron aircraft count.
- Tests start a short-period poller with `start_supervised!/1` and
  `assert_receive` the measurement.

**Files**

| File | Role |
| --- | --- |
| [`kalahari_throughput.ex`](kalahari_throughput.ex) | Agent counter, `measure_apron/0`, last_value metric |
| [`kalahari_throughput_live.ex`](kalahari_throughput_live.ex) | Board that parks aircraft and starts a 100 ms poller |
| [`kalahari_throughput_live_test.exs`](kalahari_throughput_live_test.exs) | Poller + probe assertions |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/08-gaborone-kalahari-throughput/kalahari_throughput_live_test.exs
```
