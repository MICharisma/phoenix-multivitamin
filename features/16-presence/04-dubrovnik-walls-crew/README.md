# Presence · 04 · Dubrovnik walls crew

Ramp lead Ivana checks which apron stands have a full turnaround crew before the Croatia Airlines A220-300 blocks in from Zagreb.

**What it teaches**

- The presence key is the apron stand, not a person, so every agent's meta merges under one key.
- An enforced-key struct summarizes each stand; a separate `String.Chars` implementation prints its crew roll.
- `MapSet.difference/2` compares the metas' roles with the roles a turnaround needs.

**Files**

| File | Role |
| --- | --- |
| [`walls_crew_live.ex`](walls_crew_live.ex) | LiveView that tracks each tablet under its stand |
| [`stand_crew.ex`](stand_crew.ex) | Enforced-key stand summary and missing-role check |
| [`stand_crew_chars.ex`](stand_crew_chars.ex) | `String.Chars` implementation for the crew roll |
| [`walls_crew_live_test.exs`](walls_crew_live_test.exs) | Merged metas, separate stands, and a refused role |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?agent=Ivana&stand=4&role=marshaller](http://localhost:4000/features/16-presence/04-dubrovnik-walls-crew?agent=Ivana&stand=4&role=marshaller),
[?agent=Marko&stand=4&role=loader](http://localhost:4000/features/16-presence/04-dubrovnik-walls-crew?agent=Marko&stand=4&role=loader),
and
[?agent=Petra&stand=4&role=fueller](http://localhost:4000/features/16-presence/04-dubrovnik-walls-crew?agent=Petra&stand=4&role=fueller).
Stand 4 turns ready once all three roles are connected.

```sh
mix test features/16-presence/04-dubrovnik-walls-crew/walls_crew_live_test.exs
```
