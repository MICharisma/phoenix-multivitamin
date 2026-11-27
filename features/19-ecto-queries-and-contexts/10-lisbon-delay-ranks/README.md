# Ecto queries and contexts · 10 · Lisbon delay ranks

Clerk Inês ranks Embraer E190 delays at Lisbon per airline with a window `row_number`, without collapsing the rows.

**What it teaches**

- `over(row_number(), partition_by: ..., order_by: ...)`.
- Window ranks keep every delay row; they do not group.

**Files**

| File | Role |
| --- | --- |
| [`delay.ex`](delay.ex) | Delay schema |
| [`delay_ranks.ex`](delay_ranks.ex) | Window query context |
| [`delay_ranks_live.ex`](delay_ranks_live.ex) | Ranked board |
| [`delay_ranks_live_test.exs`](delay_ranks_live_test.exs) | Per-airline ranks |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/10-lisbon-delay-ranks/delay_ranks_live_test.exs
```
