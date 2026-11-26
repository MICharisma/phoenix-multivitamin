# Telemetry and LiveDashboard · 12 · Réunion Piton tickets

Dispatcher Gaëlle tracks ash holds at Roland Garros while Piton de la Fournaise
steams. A custom LiveDashboard page lists the same tickets.

**What it teaches**

- `Phoenix.LiveDashboard.PageBuilder` defines `init/1`, `menu_link/2`, `mount/3`,
  and `render/1`.
- `menu_link/2` can return `{:ok, text}` or `{:disabled, text}`.
- `live_dashboard/2` registers the page through `additional_pages`.

**Files**

| File | Role |
| --- | --- |
| [`piton_tickets_page.ex`](piton_tickets_page.ex) | Custom LiveDashboard page |
| [`piton_tickets_live.ex`](piton_tickets_live.ex) | Catalog board and dashboard link |
| [`piton_tickets_live_test.exs`](piton_tickets_live_test.exs) | Menu contract and dashboard HTML |

**Try it**

```sh
mix phx.server
```

Open the catalog scenario, then
[/dev/dashboard/piton_tickets](http://localhost:4000/dev/dashboard/piton_tickets).

```sh
mix test features/23-telemetry-and-livedashboard/12-reunion-piton-tickets/piton_tickets_live_test.exs
```
