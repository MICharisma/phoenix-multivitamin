# Testing · 01 · Port Moresby ATIS desk

Clerk Kila posts Information Charlie at Jacksons International for a
Dash 8-200. The catalog page links an HTML board and a JSON export.
ConnCase asserts both shapes with `get/2`, `html_response/2`, and
`json_response/2`.

**What it teaches**

- `use PhoenixMultivitaminWeb.ConnCase` builds a conn and opens the SQL
  sandbox for every test.
- `get(conn, path)` plus `html_response(conn, 200)` locks the paper ATIS.
- `json_response(conn, 200)` locks the export map. The JSON action never
  asks the HTML view for a template.
- The catalog LiveView is only a map; the lesson lives in the controller
  assertions.

**Files**

| File | Role |
| --- | --- |
| [`atis_desk_live.ex`](atis_desk_live.ex) | Catalog map with links to HTML and JSON |
| [`atis_desk_controller.ex`](atis_desk_controller.ex) | `show/2` HTML and `export/2` JSON |
| [`atis_desk_html.ex`](atis_desk_html.ex) | HTML board for the controller |
| [`atis_desk_test.exs`](atis_desk_test.exs) | ConnCase: get, html_response, json_response |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/25-testing/01-port-moresby-atis-desk](http://localhost:4000/features/25-testing/01-port-moresby-atis-desk).
Follow the HTML board, then the JSON export.

Run the test with the rest of the bottle:

```sh
mix test features/25-testing/01-port-moresby-atis-desk/atis_desk_test.exs
```
