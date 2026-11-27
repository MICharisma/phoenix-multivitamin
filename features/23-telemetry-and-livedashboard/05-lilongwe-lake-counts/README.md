# Telemetry and LiveDashboard · 05 · Lilongwe lake counts

Dispatcher Chisomo posts Lake Malawi visibility from Lilongwe International
before the ATR 42 departs. `Telemetry.Metrics.last_value/2` keeps the latest
metres as a gauge; a `defstruct` reading and its `String.Chars` impl format
the board.

**What it teaches**

- `last_value/2` is the Telemetry.Metrics gauge for the latest measurement.
- `@enforce_keys` on a domain struct keeps metres and waterbody honest.
- `String.Chars` lives in a separate file; never nest `defimpl` beside the struct.

**Files**

| File | Role |
| --- | --- |
| [`lake_reading.ex`](lake_reading.ex) | Enforced visibility struct and band case |
| [`lake_reading_chars.ex`](lake_reading_chars.ex) | String.Chars for lake readings |
| [`lake_counts.ex`](lake_counts.ex) | last_value metric and emit |
| [`lake_counts_live.ex`](lake_counts_live.ex) | Board that reports visibility |
| [`lake_counts_live_test.exs`](lake_counts_live_test.exs) | Metric shape, protocol, and board probe |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/05-lilongwe-lake-counts/lake_counts_live_test.exs
```
