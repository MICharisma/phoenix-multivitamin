# Presence · 13 · Visby Gotland radio

Visby Radio keeps the Gotland radio net open while the Saab 340 air ambulance shuttles between Visby and Stockholm. Stations join, retune, open a second console, and sign off; the log records it.

**What it teaches**

- Capstone: track on connect, `update/4` from a validated form, untrack and track again, and two consoles under one call sign.
- A `fetch/2` overlay adds each station's site and operator, so the LiveView never looks them up.
- Each `presence_diff` rebuilds an enforced-key net struct; comparing two snapshots yields the radio log, idempotently.

**Files**

| File | Role |
| --- | --- |
| [`gotland_radio_live.ex`](gotland_radio_live.ex) | Net table, retune form, sign-on and sign-off, and the streamed log |
| [`visby_gotland_presence.ex`](visby_gotland_presence.ex) | Presence module with the station `fetch/2` overlay |
| [`gotland_radio_net.ex`](gotland_radio_net.ex) | Enforced-key net snapshot and snapshot comparison |
| [`gotland_radio_live_test.exs`](gotland_radio_live_test.exs) | Overlay, unlisted station, retune, refused frequency, second console, sign-off and sign-on |

The tracker is started by the feature's [`PresenceTrackers`](../presence_trackers.ex) supervisor.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?station=Visby+Radio](http://localhost:4000/features/16-presence/13-visby-gotland-radio?station=Visby+Radio)
twice and
[?station=Fårö+Relay](http://localhost:4000/features/16-presence/13-visby-gotland-radio?station=F%C3%A5r%C3%B6+Relay)
once. Retune one Visby console to 121.500, then sign it off and back on.

```sh
mix test features/16-presence/13-visby-gotland-radio/gotland_radio_live_test.exs
```
