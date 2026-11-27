# Presence · 12 · Turku archipelago crew

Aino coordinates the Cessna 208 Caravan on floats shuttling between Turku and the outer islands. When a crew tablet drops off, the crew member stays under radio silence for a while instead of vanishing.

**What it teaches**

- Presence leaves no ghost: a crashed or killed tab produces a leave diff because the tracker links the tracked process.
- The board keeps its own short-lived ghost, "radio silence", with `Process.send_after/3` and cancels it on a rejoin.
- `Map.drop/2` finds who went quiet between two lists; `Map.pop/2` moves them out of radio silence on a rejoin or a fade.

**Files**

| File | Role |
| --- | --- |
| [`archipelago_crew_live.ex`](archipelago_crew_live.ex) | On-air and radio-silence board |
| [`archipelago_crew_live_test.exs`](archipelago_crew_live_test.exs) | Killed tab, fading silence, and a returning crew member |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?crew=Aino](http://localhost:4000/features/16-presence/12-turku-archipelago-crew?crew=Aino)
and
[?crew=Eero&post=Korpo+pontoon](http://localhost:4000/features/16-presence/12-turku-archipelago-crew?crew=Eero&post=Korpo+pontoon).
Close Eero's window: he moves to radio silence for 90 seconds unless his window is reopened.

```sh
mix test features/16-presence/12-turku-archipelago-crew/archipelago_crew_live_test.exs
```
