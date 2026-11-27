# Telemetry and LiveDashboard · 09 · Maputo Indian Ocean wait

Dispatcher Anchia times Dash 8 Q400 turns at Maputo harbour facing the Indian
Ocean. Every HTTP request through the Phoenix endpoint fires built-in
`[:phoenix, :endpoint, *]` and `[:phoenix, :router_dispatch, *]` events.

**What it teaches**

- `Plug.Telemetry` emits `[:phoenix, :endpoint, :start]` and
  `[:phoenix, :endpoint, :stop]`.
- The router emits `[:phoenix, :router_dispatch, :start]` and
  `[:phoenix, :router_dispatch, :stop]`.
- Tests `attach_many` handlers to `self()`, then `get/2` and `assert_receive`.

**Files**

| File | Role |
| --- | --- |
| [`indian_ocean_wait_live.ex`](indian_ocean_wait_live.ex) | Event catalogue and connected probe |
| [`indian_ocean_wait_live_test.exs`](indian_ocean_wait_live_test.exs) | HTTP get probe + LiveView board |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/09-maputo-indian-ocean-wait/indian_ocean_wait_live_test.exs
```
