# Ecto queries and contexts · 13 · Doha composed desk

Clerk Fatima composes Airbus A350-1000 leg filters at Doha through private context functions; the LiveView never builds a query.

**What it teaches**

- Composable `with_airline/2`, `with_status/2`, `with_min_cargo/2` that take and return queries.
- Capstone: the context is the only Repo door the web layer uses.

**Files**

| File | Role |
| --- | --- |
| [`leg.ex`](leg.ex) | Leg schema |
| [`composed_desk.ex`](composed_desk.ex) | Composable query door |
| [`composed_desk_live.ex`](composed_desk_live.ex) | Filter board |
| [`composed_desk_live_test.exs`](composed_desk_live_test.exs) | Default and widened filters |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/13-doha-composed-desk/composed_desk_live_test.exs
```
