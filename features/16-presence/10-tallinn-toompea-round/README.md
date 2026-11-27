# Presence · 10 · Tallinn Toompea round

Kadri drives the dawn runway inspection at Tallinn before the first Finnair ATR 72-500 from Helsinki. Every inspector out on the round appears once, with their vehicle and segment.

**What it teaches**

- Presences rendered through a LiveView stream: the diff names the changed keys, and `get_by_key/2` decides insert or delete.
- `stream_delete_by_dom_id/3` removes an inspector by a computed DOM id; `stream_configure/3` makes inserts use the same id.
- Streams cannot be counted, so a `MapSet` assign of keys on the round carries the headcount.

**Files**

| File | Role |
| --- | --- |
| [`toompea_round_live.ex`](toompea_round_live.ex) | Streamed inspection round |
| [`toompea_round_live_test.exs`](toompea_round_live_test.exs) | Stream insert and delete, an updated segment, and a closed second screen |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?inspector=Kadri](http://localhost:4000/features/16-presence/10-tallinn-toompea-round?inspector=Kadri)
and
[?inspector=Rasmus&vehicle=Sweeper+1](http://localhost:4000/features/16-presence/10-tallinn-toompea-round?inspector=Rasmus&vehicle=Sweeper+1).
Close the second window; Rasmus's row is deleted from the stream.

```sh
mix test features/16-presence/10-tallinn-toompea-round/toompea_round_live_test.exs
```
