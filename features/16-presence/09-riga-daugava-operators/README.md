# Presence · 09 · Riga Daugava operators

Licence LV-OCC-4420 opens the Riga operations room while an airBaltic A220-300 waits for a crew swap. Names, desks, and languages come from the roster in one lookup per presence change.

**What it teaches**

- A `fetch/2` override overlays roster profiles onto presences in one batched lookup, keeping metas small.
- The overlay reaches `list/1` and both sides of every `presence_diff`, so the arrivals ticker names who left.
- An unrostered licence gets a `nil` profile, which a function head turns into a visible warning.

**Files**

| File | Role |
| --- | --- |
| [`daugava_operators_live.ex`](daugava_operators_live.ex) | Ops room table and arrivals ticker |
| [`riga_daugava_presence.ex`](riga_daugava_presence.ex) | Presence module with the `fetch/2` overlay |
| [`riga_operator_roster.ex`](riga_operator_roster.ex) | Roster standing in for a batched database query |
| [`daugava_operators_live_test.exs`](daugava_operators_live_test.exs) | Listed profiles, profiles on leaves, and an unrostered licence |

The tracker is started by the feature's [`PresenceTrackers`](../presence_trackers.ex) supervisor.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?licence=LV-OCC-4420](http://localhost:4000/features/16-presence/09-riga-daugava-operators?licence=LV-OCC-4420)
and
[?licence=LV-OCC-2207&console=OCC-2](http://localhost:4000/features/16-presence/09-riga-daugava-operators?licence=LV-OCC-2207&console=OCC-2),
then close the second window. The ticker names Ilze on the way out.

```sh
mix test features/16-presence/09-riga-daugava-operators/daugava_operators_live_test.exs
```
