# Ecto queries and contexts · 05 · Tokyo join preload

Clerk Haruto join-preloads the airline on each Boeing 787-9 crew row at Tokyo in one query.

**What it teaches**

- `join: airline in assoc(...)` with `preload: [tokyo_airline: airline]`.
- Association comes from the join binding, not a follow-up SELECT.

**Files**

| File | Role |
| --- | --- |
| [`airline.ex`](airline.ex) | Carrier schema |
| [`crew.ex`](crew.ex) | Crew schema |
| [`crew_desk.ex`](crew_desk.ex) | Join-preload query |
| [`join_preload_live.ex`](join_preload_live.ex) | Crew board with airline |
| [`join_preload_live_test.exs`](join_preload_live_test.exs) | Airline names present |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/05-tokyo-join-preload/join_preload_live_test.exs
```
