# PubSub · 12 · Amman Nabatean hail

Rania hails the southern watches from Amman Marka. Every watch shares one station topic; a sender module decides which hails reach which watch.

**What it teaches**

- One station topic instead of a topic per watch: `subscribe/3` with a `:sender` filters per watch.
- A `Phoenix.PubSub.Sender` runs in the broadcaster and decides what each subscriber gets.
- `handle_params/3` swaps the watch with `unsubscribe_sender/3` and a fresh `subscribe/3`.

**Files**

| File | Role |
| --- | --- |
| [`nabatean_watch_sender.ex`](nabatean_watch_sender.ex) | Sender that delivers station hails and the subscriber's own watch hails |
| [`nabatean_hail_live.ex`](nabatean_hail_live.ex) | Watch switching by patch, hail form, and hail log |
| [`nabatean_hail_live_test.exs`](nabatean_hail_live_test.exs) | Per-watch filtering, sender swaps, plain subscribers, and unknown watches |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/12-amman-nabatean-hail](http://localhost:4000/features/15-pubsub/12-amman-nabatean-hail).

Open `?watch=wadi-rum` in a second window. A station hail reaches both; a Wadi Rum hail reaches only that watch. A topic per watch would need one subscription per watch plus the station topic. Phoenix.PubSub 2.4 deprecates custom dispatchers in favor of the `:sender` option.

Run the scenario tests:

```sh
mix test features/15-pubsub/12-amman-nabatean-hail/nabatean_hail_live_test.exs
```
