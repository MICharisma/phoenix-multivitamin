# Telemetry and LiveDashboard · 10 · Beira Sofala duration

Freight clerk Esperança checks the An-26 desk at Beira harbour in Sofala with
`SELECT 1`. Ecto emits `[:phoenix_multivitamin, :repo, :query]` carrying
`total_time`, `query_time`, and related measurements.

**What it teaches**

- Ecto repo queries emit `[:phoenix_multivitamin, :repo, :query]`.
- `with` branches `Repo.query/1`; columns and rows are pattern-matched.
- Tests attach a handler and `assert_receive` measurements with `total_time`.

**Files**

| File | Role |
| --- | --- |
| [`sofala_duration.ex`](sofala_duration.ex) | `run_ping/0` via `Repo.query` |
| [`sofala_duration_live.ex`](sofala_duration_live.ex) | Board that triggers and lists pings |
| [`sofala_duration_live_test.exs`](sofala_duration_live_test.exs) | Query telemetry probe |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/10-beira-sofala-duration/sofala_duration_live_test.exs
```
