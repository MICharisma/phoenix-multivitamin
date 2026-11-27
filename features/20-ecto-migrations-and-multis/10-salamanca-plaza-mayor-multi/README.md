# Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi

Clerk Jimena places Cessna Citation CJ4 parts orders on Salamanca's Plaza
Mayor apron. A bad line short-circuits the Multi: `changes_so_far` still
holds the order struct, but the database does not.

**What it teaches**

- Error short-circuit on the second `Multi.insert/3`.
- Inspecting `failed_operation`, `failed_value`, and `changes_so_far`.
- `changes_so_far` is not the same as a committed row.

**Files**

| File | Role |
| --- | --- |
| [`plaza_order.ex`](plaza_order.ex) | Order schema |
| [`plaza_line.ex`](plaza_line.ex) | Line schema |
| [`plaza_desk.ex`](plaza_desk.ex) | Multi and failure summary |
| [`plaza_mayor_multi_live.ex`](plaza_mayor_multi_live.ex) | Places orders |
| [`plaza_mayor_multi_live_test.exs`](plaza_mayor_multi_live_test.exs) | Happy path and short-circuit |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/10-salamanca-plaza-mayor-multi/plaza_mayor_multi_live_test.exs
```
