# Ecto queries and contexts · 01 · Reykjavik crew board

Clerk Sigríður opens the posted Boeing 757-200 crew board at Reykjavik through a keyword `from`/`where`/`order_by` that never leaves the context.

**What it teaches**

- Keyword `from/2` with `where` and `order_by` stays inside a context module.
- The LiveView calls `list_posted_assignments/0` and never imports `Ecto.Query`.

**Files**

| File | Role |
| --- | --- |
| [`crew_assignment.ex`](crew_assignment.ex) | Posted crew schema |
| [`crew_board.ex`](crew_board.ex) | Keyword query context |
| [`crew_board_live.ex`](crew_board_live.ex) | Board that lists posted roles |
| [`crew_board_live_test.exs`](crew_board_live_test.exs) | Posted rows only; role order |

**Try it**

```sh
mix phx.server
```

Open
[/features/19-ecto-queries-and-contexts/01-reykjavik-crew-board](http://localhost:4000/features/19-ecto-queries-and-contexts/01-reykjavik-crew-board).

```sh
mix test features/19-ecto-queries-and-contexts/01-reykjavik-crew-board/crew_board_live_test.exs
```
