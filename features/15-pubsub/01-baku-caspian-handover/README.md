# PubSub · 01 · Baku Caspian handover

Leyla posts sector handovers at Heydar Aliyev approach; every open desk, including hers, hears them from the same broadcast.

**What it teaches**

- `Phoenix.PubSub.subscribe/2` only after `connected?/1`, never in the static render.
- The posting desk hears its own handover from the broadcast, like every other desk.
- A guarded event head rejects a sector the board does not own.

**Files**

| File | Role |
| --- | --- |
| [`caspian_handover_live.ex`](caspian_handover_live.ex) | Subscription, broadcast, and handover board |
| [`caspian_handover_live_test.exs`](caspian_handover_live_test.exs) | Static render, two-desk delivery, and rejected-sector scaffolding |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/01-baku-caspian-handover](http://localhost:4000/features/15-pubsub/01-baku-caspian-handover).

Open the page in two windows. Post a handover in one; both boards list it, because the posting desk updates only from `handle_info/2`. A plain GET shows the static render, which is not subscribed.

Run the scenario tests:

```sh
mix test features/15-pubsub/01-baku-caspian-handover/caspian_handover_live_test.exs
```
