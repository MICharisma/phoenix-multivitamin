# PubSub · 11 · Madinah Hijaz hold wire

Abdullah stacks Hajj arrivals over the Hijaz fixes at Prince Mohammad bin Abdulaziz. This bottle runs one node, so cluster, node, and direct reaches land on the same desks.

**What it teaches**

- `broadcast/3` reaches the cluster, `local_broadcast/3` this node, `direct_broadcast/4` one named node.
- `node_name/1` names this node; on a single node every reach lands on the same desks.
- A map of function captures picks the reach; `with`/`else` turns an unknown reach into a flash.

**Files**

| File | Role |
| --- | --- |
| [`hijaz_hold_wire_live.ex`](hijaz_hold_wire_live.ex) | Reach captures, hold form, and node details |
| [`hijaz_hold_wire_live_test.exs`](hijaz_hold_wire_live_test.exs) | Each reach, adapter relay timing, absent nodes, and rejected holds |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/11-madinah-hijaz-hold-wire](http://localhost:4000/features/15-pubsub/11-madinah-hijaz-hold-wire).

Issue holds on each reach. Cluster, node, and direct all land here. "Riyadh ACC node" names a node that is not connected: `direct_broadcast/4` still returns `:ok`, and nothing arrives.

Run the scenario tests:

```sh
mix test features/15-pubsub/11-madinah-hijaz-hold-wire/hijaz_hold_wire_live_test.exs
```
