# Presence · 06 · Ljubljana Triple Bridge relief

Mojca hands over Ljubljana tower while a LOT Embraer 195 lines up on runway 30. Each controller updates their relief status on the shared board without signing off.

**What it teaches**

- `Presence.update/4` with a function rewrites the tracked meta in place; the key and process stay the same.
- Guarded `handle_event` clauses accept only known relief statuses and flash the rejected one.
- An updated meta carries `phx_ref_prev`, which the board uses to mark a changed status.

**Files**

| File | Role |
| --- | --- |
| [`triple_bridge_relief_live.ex`](triple_bridge_relief_live.ex) | Relief board and status buttons |
| [`triple_bridge_relief_live_test.exs`](triple_bridge_relief_live_test.exs) | Status update, the update diff's shape, and a refused status |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?controller=Mojca](http://localhost:4000/features/16-presence/06-ljubljana-triple-bridge-relief?controller=Mojca)
and
[?controller=Rok](http://localhost:4000/features/16-presence/06-ljubljana-triple-bridge-relief?controller=Rok).
Press "Briefing the relief" in one window and watch the other board mark the change.

```sh
mix test features/16-presence/06-ljubljana-triple-bridge-relief/triple_bridge_relief_live_test.exs
```
