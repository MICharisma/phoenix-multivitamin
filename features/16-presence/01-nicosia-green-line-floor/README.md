# Presence · 01 · Nicosia Green Line floor

Andreas signs on to a sector at the Nicosia control centre while a Cyprus Airways A220-300 climbs out of Larnaca. The floor list shows every controller whose console is connected right now.

**What it teaches**

- `Presence.track/4` runs only on the connected mount; the disconnected render has no process worth tracking.
- The floor subscribes to the same topic it tracks on and re-reads `Presence.list/1` for each `presence_diff`.
- Query params pick the controller and sector, with a guarded default for an unknown sector.

**Files**

| File | Role |
| --- | --- |
| [`green_line_floor_live.ex`](green_line_floor_live.ex) | LiveView that tracks the console and lists the floor |
| [`green_line_floor_live_test.exs`](green_line_floor_live_test.exs) | Disconnected render, arrival, departure, and sector fallback |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/16-presence/01-nicosia-green-line-floor?controller=Andreas](http://localhost:4000/features/16-presence/01-nicosia-green-line-floor?controller=Andreas)
and, in a second window,
[?controller=Eleni&sector=Paphos+Approach](http://localhost:4000/features/16-presence/01-nicosia-green-line-floor?controller=Eleni&sector=Paphos+Approach).
Close the second window and watch Eleni leave the first one's floor list.

```sh
mix test features/16-presence/01-nicosia-green-line-floor/green_line_floor_live_test.exs
```
