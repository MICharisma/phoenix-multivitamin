# Testing · 02 · Cairns reef click board

Clerk Marlee posts reef hazards for a Twin Otter out of Cairns. LiveViewTest
connects with `live/2`, finds buttons with `element/3`, and posts clicks with
`render_click/1`. `has_element?/3` locks clerk, craft, and hazard lines.

**What it teaches**

- `live(conn, path)` returns `{:ok, view, html}` for the connected mount.
- `has_element?(view, "#id", "text")` asserts presence and content together.
- `element(view, "#id") |> render_click()` drives `phx-click` handlers.
- Multi-clause `handle_event/3` rejects a clear on an already-empty reef.

**Files**

| File | Role |
| --- | --- |
| [`reef_click_board_live.ex`](reef_click_board_live.ex) | Click board with bommie, turtle, and clear |
| [`reef_click_board_live_test.exs`](reef_click_board_live_test.exs) | live/2, element/3, has_element?/3, render_click |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/02-cairns-reef-click-board](http://localhost:4000/features/25-testing/02-cairns-reef-click-board).
Log a bommie, then a turtle raft, then clear.

```sh
mix test features/25-testing/02-cairns-reef-click-board/reef_click_board_live_test.exs
```
