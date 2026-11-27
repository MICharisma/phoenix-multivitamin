# PubSub · 05 · Muscat khareef alert

Salim watches monsoon gusts on Muscat's runway 08L. Amber and red alerts hold for fifteen minutes unless a newer alert replaces them.

**What it teaches**

- `handle_info/2` clauses for broadcast tuples, guarded by alert level and gust speed.
- A broadcast and a `Process.send_after/3` timer arrive through the same callback.
- A repeated variable in the head matches the clear timer to the current alert serial.

**Files**

| File | Role |
| --- | --- |
| [`khareef_alert_live.ex`](khareef_alert_live.ex) | Gust classification with `cond`, alert clauses, and the clear timer |
| [`khareef_alert_live_test.exs`](khareef_alert_live_test.exs) | Classification, stale clear timers, and malformed broadcasts |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/05-muscat-khareef-alert](http://localhost:4000/features/15-pubsub/05-muscat-khareef-alert).

Report a 34 kt or 48 kt gust for an alert, or 18 kt for an advisory. A second alert gets a new serial, so the first alert's fifteen-minute clear timer no longer matches.

Run the scenario tests:

```sh
mix test features/15-pubsub/05-muscat-khareef-alert/khareef_alert_live_test.exs
```
