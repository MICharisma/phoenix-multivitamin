# Telemetry and LiveDashboard · 04 · Kilimanjaro Kibo cycle

Dispatcher Neema logs Cessna Caravan legs around Kibo from Kilimanjaro
International. One `:telemetry.attach_many/4` handler id covers ascent,
descent, and summit; `:telemetry.detach/1` clears them together.

**What it teaches**

- `:telemetry.attach_many/4` attaches one handler id to several event names.
- `:telemetry.detach/1` removes that id for every event at once; a second
  detach returns `{:error, :not_found}`.
- A handler that raises is detached by telemetry; later events stay silent.

**Files**

| File | Role |
| --- | --- |
| [`kibo_cycle.ex`](kibo_cycle.ex) | Emitter for ascent, descent, and summit |
| [`kibo_cycle_live.ex`](kibo_cycle_live.ex) | Board that attaches many and tracks a MapSet of phases |
| [`kibo_cycle_live_test.exs`](kibo_cycle_live_test.exs) | attach_many, detach, and raising-handler discovery |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/04-kilimanjaro-kibo-cycle/kibo_cycle_live_test.exs
```
