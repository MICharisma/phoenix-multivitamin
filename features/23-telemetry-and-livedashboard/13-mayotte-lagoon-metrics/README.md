# Telemetry and LiveDashboard · 13 · Mayotte lagoon metrics

Nazouati keeps the pulse of Dzaoudzi–Pamandzi: ferry crossings, lagoon depth,
and quay clearances. The capstone wires custom events, a full Telemetry.Metrics
set, LiveDashboard metrics config, and test handlers that send to `self()`.

**What it teaches**

- Counter, sum, last_value, summary, and distribution for one station.
- Summary/distribution `tags` and `tag_values` keyed by quay name.
- Attached handlers in tests assert on messages to `self()`.
- `PhoenixMultivitaminWeb.Telemetry.metrics/0` exposes the Mayotte set to the
  dashboard.

**Files**

| File | Role |
| --- | --- |
| [`lagoon_metrics.ex`](lagoon_metrics.ex) | Events, emitters, and dashboard metrics |
| [`lagoon_metrics_live.ex`](lagoon_metrics_live.ex) | Capstone board with attach_many |
| [`lagoon_metrics_live_test.exs`](lagoon_metrics_live_test.exs) | Metric kinds and self() probes |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/13-mayotte-lagoon-metrics/lagoon_metrics_live_test.exs
```
