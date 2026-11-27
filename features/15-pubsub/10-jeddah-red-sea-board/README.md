# PubSub · 10 · Jeddah Red Sea board

Reem moves gates at King Abdulaziz Terminal 1. Every desk already holds each flight's 240-seat manifest, so a gate move sends only the flight and the new gate.

**What it teaches**

- Broadcast the change (`{:gate_moved, flight, gate}`), not the whole flight with its manifest.
- `:erlang.external_size/1` measures what a subscriber would copy for each payload.
- A multi-clause anonymous function with a pinned flight number rewrites one board row.

**Files**

| File | Role |
| --- | --- |
| [`red_sea_board_live.ex`](red_sea_board_live.ex) | Board built by comprehension, gate parsing, and slim broadcasts |
| [`red_sea_board_live_test.exs`](red_sea_board_live_test.exs) | Slim delivery, measured sizes, and rejected gates |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/10-jeddah-red-sea-board](http://localhost:4000/features/15-pubsub/10-jeddah-red-sea-board).

Move SV1458 to `D7`. Every board changes one gate, and the page shows how many bytes the slim tuple took against the whole flight. Each subscriber gets its own copy of the message.

Run the scenario tests:

```sh
mix test features/15-pubsub/10-jeddah-red-sea-board/red_sea_board_live_test.exs
```
