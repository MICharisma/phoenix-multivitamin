# PubSub · 03 · Yerevan Ararat relay

Armen relays the visibility toward Ararat between Armenian tower desks. The relaying desk logs its own report once, without waiting for an echo.

**What it teaches**

- `Phoenix.PubSub.broadcast_from/4` with `self()` so the relaying desk skips its own echo.
- The sender logs locally and receivers log from `handle_info/2` through one shared function.
- `mount/3` clauses match an optional desk query parameter.

**Files**

| File | Role |
| --- | --- |
| [`ararat_relay_live.ex`](ararat_relay_live.ex) | Desk selection, `broadcast_from/4`, and the shared logger |
| [`ararat_relay_live_test.exs`](ararat_relay_live_test.exs) | One entry per desk, rejected visibility, and outside reports |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/03-yerevan-ararat-relay](http://localhost:4000/features/15-pubsub/03-yerevan-ararat-relay).

Open `?desk=gyumri` in a second window. Relay a visibility from Zvartnots; it logs "You relayed" once there and the Gyumri desk logs it under Zvartnots' name.

Run the scenario tests:

```sh
mix test features/15-pubsub/03-yerevan-ararat-relay/ararat_relay_live_test.exs
```
