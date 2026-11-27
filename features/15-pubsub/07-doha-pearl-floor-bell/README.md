# PubSub · 07 · Doha Pearl floor bell

Maryam rings the transfer-floor bell at Hamad when a gate needs a wheelchair team. Every supervisor screen on the floor lights the same gate.

**What it teaches**

- `Endpoint.subscribe/1` and `Endpoint.broadcast!/3` use the endpoint's configured `:pubsub_server`.
- Endpoint broadcasts arrive as `%Phoenix.Socket.Broadcast{}` structs, matched by event.
- The local PG2 adapter here; a Redis adapter changes the child spec, not this code.

**Files**

| File | Role |
| --- | --- |
| [`pearl_floor_bell_live.ex`](pearl_floor_bell_live.ex) | Endpoint subscription, ring and silence events, and gate lamps |
| [`pearl_floor_bell_live_test.exs`](pearl_floor_bell_live_test.exs) | Two screens, the `Broadcast` struct, atom events, and unknown gates |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/07-doha-pearl-floor-bell](http://localhost:4000/features/15-pubsub/07-doha-pearl-floor-bell).

Open two windows and ring a gate in one; it lights in both. `PhoenixMultivitamin.PubSub` starts with the default `Phoenix.PubSub.PG2` adapter. Switching to Redis (`phoenix_pubsub_redis`) or another adapter changes that child spec in `application.ex`, not this LiveView.

Run the scenario tests:

```sh
mix test features/15-pubsub/07-doha-pearl-floor-bell/pearl_floor_bell_live_test.exs
```
