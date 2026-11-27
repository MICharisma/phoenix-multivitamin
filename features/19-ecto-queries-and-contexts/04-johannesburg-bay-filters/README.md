# Ecto queries and contexts · 04 · Johannesburg bay filters

Clerk Thabo builds optional Airbus A320neo bay filters at Johannesburg with `dynamic/2`.

**What it teaches**

- `dynamic/2` folded with `Enum.reduce/3` for optional bay and status filters.
- Empty params leave `dynamic(true)` so every card still lists.

**Files**

| File | Role |
| --- | --- |
| [`bay_card.ex`](bay_card.ex) | Maintenance card schema |
| [`bay_desk.ex`](bay_desk.ex) | Dynamic filter context |
| [`bay_filters_live.ex`](bay_filters_live.ex) | Filter form board |
| [`bay_filters_live_test.exs`](bay_filters_live_test.exs) | Narrow then clear |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/04-johannesburg-bay-filters/bay_filters_live_test.exs
```
