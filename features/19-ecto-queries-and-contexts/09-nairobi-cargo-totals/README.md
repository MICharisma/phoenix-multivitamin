# Ecto queries and contexts · 09 · Nairobi cargo totals

Clerk Wanjiku groups Boeing 747-400F shipments at Nairobi by airline and keeps totals that clear three tonnes.

**What it teaches**

- `group_by` with `having: sum(...) >= ^min_kg`.
- Select map of airline, total kilograms, and leg count.

**Files**

| File | Role |
| --- | --- |
| [`shipment.ex`](shipment.ex) | Shipment schema |
| [`cargo_totals.ex`](cargo_totals.ex) | Group/having context |
| [`cargo_totals_live.ex`](cargo_totals_live.ex) | Totals board |
| [`cargo_totals_live_test.exs`](cargo_totals_live_test.exs) | Threshold filter |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/09-nairobi-cargo-totals/cargo_totals_live_test.exs
```
