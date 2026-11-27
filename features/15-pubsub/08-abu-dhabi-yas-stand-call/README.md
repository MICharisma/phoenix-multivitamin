# PubSub · 08 · Abu Dhabi Yas stand call

Khalid calls marshals to stands on the Zayed International apron. Each marshal panel is its own LiveView process listening on the same topic.

**What it teaches**

- Two LiveView modules on one topic: the ramp dispatcher and each nested stand marshal.
- `live_render/3` children are separate processes; PubSub reaches them, parent assigns do not.
- Both directions share the topic, so each side ignores the other's message shape.

**Files**

| File | Role |
| --- | --- |
| [`yas_stand_call_live.ex`](yas_stand_call_live.ex) | Ramp dispatcher that calls stands and lists ready marshals |
| [`yas_stand_marshal_live.ex`](yas_stand_marshal_live.ex) | Nested marshal LiveView with a pinned stand match |
| [`yas_stand_call_live_test.exs`](yas_stand_call_live_test.exs) | Per-stand delivery, ready replies, and refused calls |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/08-abu-dhabi-yas-stand-call](http://localhost:4000/features/15-pubsub/08-abu-dhabi-yas-stand-call).

Call stand 31 for EY17. Only Rashid's panel shows the aircraft; pressing "Wands up" broadcasts back on the same topic, and the dispatcher lists stand 31 as ready.

Run the scenario tests:

```sh
mix test features/15-pubsub/08-abu-dhabi-yas-stand-call/yas_stand_call_live_test.exs
```
