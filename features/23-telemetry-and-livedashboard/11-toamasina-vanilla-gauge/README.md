# Telemetry and LiveDashboard · 11 · Toamasina vanilla gauge

Clerk Fara logs vanilla crates at Toamasina, Madagascar, before the Twin Otter
leaves. LiveView mount and handle_event run as telemetry spans
(`[:phoenix, :live_view, :mount, :start|:stop]` and
`[:phoenix, :live_view, :handle_event, :start|:stop]`).

**What it teaches**

- LiveView emits mount and handle_event spans (start/stop).
- Mount fires twice under `live/2`: disconnected HTTP render then connected
  socket (two start/stop pairs). Do not assume a single mount span.
- `attach_many` to `self()`, then `live/2` and `render_click/1`.

**Files**

| File | Role |
| --- | --- |
| [`vanilla_gauge_live.ex`](vanilla_gauge_live.ex) | Vanilla crate board |
| [`vanilla_gauge_live_test.exs`](vanilla_gauge_live_test.exs) | Mount + handle_event span probes |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/11-toamasina-vanilla-gauge/vanilla_gauge_live_test.exs
```
