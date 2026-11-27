# Ecto queries and contexts · 02 · Dubai cargo holds

Clerk Amira pipes sealed Boeing 777F holds at Dubai through `where` and `order_by` before `Repo.all`.

**What it teaches**

- Pipe-syntax queries: `Schema |> where(...) |> order_by(...) |> Repo.all()`.
- Same listing job as keyword `from`, different code shape.

**Files**

| File | Role |
| --- | --- |
| [`cargo_hold.ex`](cargo_hold.ex) | Hold schema |
| [`cargo_holds.ex`](cargo_holds.ex) | Pipe query context |
| [`cargo_holds_live.ex`](cargo_holds_live.ex) | Sealed hold board |
| [`cargo_holds_live_test.exs`](cargo_holds_live_test.exs) | Sealed rows; hold-code order |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/02-dubai-cargo-holds/cargo_holds_live_test.exs
```
