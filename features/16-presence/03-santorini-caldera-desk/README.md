# Presence · 03 · Santorini caldera desk

Nikos staffs a counter at Santorini while the Sky Express ATR 72-600 turns around for Heraklion. The desk log shows who took the desk, who opened another console, and who really left.

**What it teaches**

- A presence module with `init/1` and `handle_metas/4` acts as a presence client inside the tracker.
- `handle_metas/4` receives the full presences map, so it can tell a desk departure from a closed second console.
- The LiveView subscribes to domain events, not `presence_diff`, and streams them with a bounded log.

**Files**

| File | Role |
| --- | --- |
| [`caldera_desk_live.ex`](caldera_desk_live.ex) | LiveView that tracks the agent and streams desk events |
| [`santorini_caldera_presence.ex`](santorini_caldera_presence.ex) | Presence module with `init/1` and `handle_metas/4` |
| [`caldera_desk_live_test.exs`](caldera_desk_live_test.exs) | Arrival, second console, closed console, and departure |

The tracker is started by the feature's [`PresenceTrackers`](../presence_trackers.ex) supervisor.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?agent=Nikos&counter=gate](http://localhost:4000/features/16-presence/03-santorini-caldera-desk?agent=Nikos&counter=gate)
in two windows, then
[?agent=Maria](http://localhost:4000/features/16-presence/03-santorini-caldera-desk?agent=Maria).
Close one of Nikos's windows, then the other, and compare the two log lines.

```sh
mix test features/16-presence/03-santorini-caldera-desk/caldera_desk_live_test.exs
```
