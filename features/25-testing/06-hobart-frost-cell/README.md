# Testing · 06 · Hobart frost cell

Clerk Elspeth taps Derwent frost on a Dash 8-200 from a LiveComponent.
LiveViewTest clicks `#tap-frost` (routed with `phx-target={@myself}`) and
asserts the cell id. A parent button uses `send_update/3` to post a note.

**What it teaches**

- LiveComponent events stay on the cell when `phx-target={@myself}`.
- `element("#tap-frost") |> render_click()` still reaches the component.
- `send(self(), {:frost_tapped, taps})` lets the parent observe the cell.
- `send_update/3` refreshes the cell without changing the parent assign.

**Files**

| File | Role |
| --- | --- |
| [`frost_cell.ex`](frost_cell.ex) | Stateful LiveComponent |
| [`frost_cell_live.ex`](frost_cell_live.ex) | Parent LiveView |
| [`frost_cell_live_test.exs`](frost_cell_live_test.exs) | Component click and send_update |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/06-hobart-frost-cell](http://localhost:4000/features/25-testing/06-hobart-frost-cell).
Tap frost, then post the Derwent note.

```sh
mix test features/25-testing/06-hobart-frost-cell/frost_cell_live_test.exs
```
