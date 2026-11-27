# Presence · 11 · Helsinki Malmi menders

Tuula runs Hangar 2 at Malmi, where a DHC-2 Beaver is in for its annual. The board counts menders and screens by trade without keeping anyone's metas.

**What it teaches**

- Counting without listing: one `Enum.reduce/3` over `Presence.list/1` keeps only integers, never the metas.
- Keys count people and metas count screens, so a mender with two tablets counts once per trade.
- A shift lead's page observes without tracking; `cond` grades the hangar from the tallies.

**Files**

| File | Role |
| --- | --- |
| [`malmi_menders_live.ex`](malmi_menders_live.ex) | Hangar tally for menders and the shift lead |
| [`malmi_menders_live_test.exs`](malmi_menders_live_test.exs) | Observer view, people versus screens, staffing grades, and a refused trade |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open the shift lead's
[board](http://localhost:4000/features/16-presence/11-helsinki-malmi-menders), then menders such as
[?mender=Antti&trade=powerplant](http://localhost:4000/features/16-presence/11-helsinki-malmi-menders?mender=Antti&trade=powerplant)
in other windows. Open Antti twice: menders stay at one, screens rise to two.

```sh
mix test features/16-presence/11-helsinki-malmi-menders/malmi_menders_live_test.exs
```
