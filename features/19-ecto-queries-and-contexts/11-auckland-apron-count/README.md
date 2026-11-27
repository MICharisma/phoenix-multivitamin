# Ecto queries and contexts · 11 · Auckland apron count

Clerk Mere counts occupied and free ATR 72-500 stands at Auckland with `Repo.aggregate`, without loading the rows.

**What it teaches**

- `Repo.aggregate(:count)` on a filtered query.
- Empty apron returns `0`, not `nil`.

**Files**

| File | Role |
| --- | --- |
| [`apron_stand.ex`](apron_stand.ex) | Stand schema |
| [`apron_desk.ex`](apron_desk.ex) | Aggregate context |
| [`apron_count_live.ex`](apron_count_live.ex) | Count board |
| [`apron_count_live_test.exs`](apron_count_live_test.exs) | Occupied/free; empty zero |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/11-auckland-apron-count/apron_count_live_test.exs
```
