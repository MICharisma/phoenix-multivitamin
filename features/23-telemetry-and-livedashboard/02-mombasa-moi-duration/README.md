# Telemetry and LiveDashboard · 02 · Mombasa Moi duration

Ramp lead Juma clears Boeing turnarounds at Moi International. Each clearance
runs inside `:telemetry.span/3` so start and stop share a span context.

**What it teaches**

- `:telemetry.span/3` emits `EventPrefix ++ [start]` then `[stop]`.
- The span function may return `{result, measurements, metadata}`.
- Stop carries `duration`; both events share `telemetry_span_context`.

**Files**

| File | Role |
| --- | --- |
| [`moi_turnaround.ex`](moi_turnaround.ex) | Span-wrapped stand clearance |
| [`moi_duration_live.ex`](moi_duration_live.ex) | Board that listens for start/stop |
| [`moi_duration_live_test.exs`](moi_duration_live_test.exs) | Asserts paired span events |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/02-mombasa-moi-duration/moi_duration_live_test.exs
```
