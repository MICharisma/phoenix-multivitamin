# Telemetry and LiveDashboard · 03 · Pemba clove counters

Mwanaidi weighs clove lots on Pemba before the Twin Otter hops to Zanzibar.
`Telemetry.Metrics.counter/2` and `sum/2` both listen to the same weigh event.

**What it teaches**

- `counter/2` counts event executions.
- `sum/2` accumulates a named measurement such as `:kilograms`.
- Metric definitions are structs LiveDashboard and reporters consume.

**Files**

| File | Role |
| --- | --- |
| [`clove_counters.ex`](clove_counters.ex) | Metric definitions and weigh emitter |
| [`clove_counters_live.ex`](clove_counters_live.ex) | Board that weighs sacks |
| [`clove_counters_live_test.exs`](clove_counters_live_test.exs) | Struct shape and event probe |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/03-pemba-clove-counters/clove_counters_live_test.exs
```
