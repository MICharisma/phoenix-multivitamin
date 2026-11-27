# PubSub · 04 · Tehran Alborz wire

Shirin watches the Imam Khomeini and Mehrabad wires under the Alborz. Each station has its own topic; Mashhad traffic goes out on a topic this desk never joined.

**What it teaches**

- Topics named for the station (`"alborz:IKA"`), built and decoded with binary patterns.
- A `for` comprehension subscribes one desk to every station it watches.
- `handle_info/2` destructures the socket so a guard can test the station against the board.

**Files**

| File | Role |
| --- | --- |
| [`alborz_wire_live.ex`](alborz_wire_live.ex) | Station topics, wire form, and per-station columns |
| [`alborz_wire_live_test.exs`](alborz_wire_live_test.exs) | Per-station delivery, the unwatched MHD topic, and empty wires |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/04-tehran-alborz-wire](http://localhost:4000/features/15-pubsub/04-tehran-alborz-wire).

Send a wire to IKA or THR and it lands in that column. Send one to MHD: it is broadcast on `alborz:MHD`, which this desk never subscribed to, so the board does not change.

Run the scenario tests:

```sh
mix test features/15-pubsub/04-tehran-alborz-wire/alborz_wire_live_test.exs
```
