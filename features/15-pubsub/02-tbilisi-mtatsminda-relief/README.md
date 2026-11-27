# PubSub · 02 · Tbilisi Mtatsminda relief

Nino runs the relief rota below Mtatsminda. Her desk only publishes; the tower cab listens for each relief.

**What it teaches**

- `Phoenix.PubSub.broadcast/3` from `handle_event/3` on a desk that never subscribes.
- An enforced-key struct is the message; `with`/`else` turns bad relief fields into reasons.
- The broadcast's `:ok` result, not a `handle_info` echo, confirms the desk's log.

**Files**

| File | Role |
| --- | --- |
| [`mtatsminda_relief.ex`](mtatsminda_relief.ex) | Enforced-key relief struct and its `with` validation |
| [`mtatsminda_relief_live.ex`](mtatsminda_relief_live.ex) | Publishing form and sent-relief log |
| [`mtatsminda_relief_live_test.exs`](mtatsminda_relief_live_test.exs) | Struct delivery, rejected reliefs, and a publisher-only subscriber list |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/02-tbilisi-mtatsminda-relief](http://localhost:4000/features/15-pubsub/02-tbilisi-mtatsminda-relief).

Send a relief for Tower, Ground, or Approach between 10 and 90 minutes. Nothing on this page subscribes; the tests subscribe in the tower's place and match the `%MtatsmindaRelief{}` struct.

Run the scenario tests:

```sh
mix test features/15-pubsub/02-tbilisi-mtatsminda-relief/mtatsminda_relief_live_test.exs
```
