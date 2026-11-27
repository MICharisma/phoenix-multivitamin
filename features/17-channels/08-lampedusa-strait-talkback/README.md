# Channels · 08 · Lampedusa strait talkback

Coordinator Rosaria Matina at MRCC Roma acknowledges each transmission from Guardia Costiera ATR 42MP Manta 10-01 over the Strait of Sicily.

**What it teaches**

- `join/3` builds its assigns from connect assigns, the topic, and the join payload.
- A guard on `is_map_key/2` defaults a missing `last_seq` by calling `join/3` again.
- The reply replays only transmissions after `last_seq`; `handle_in/3` accepts acknowledgements in order.
- The JS client passes join params as a closure, so every rejoin sends the latest acknowledged seq.

**Files**

| File | Role |
| --- | --- |
| [`strait_socket.ex`](strait_socket.ex) | Console-scoped connect/3 |
| [`strait_channel.ex`](strait_channel.ex) | Join replay and ordered acknowledgements |
| [`talkback_log.ex`](talkback_log.ex) | Strait transmission log |
| [`strait_talkback_live.ex`](strait_talkback_live.ex) | LiveView page and rejoin-aware JS client |
| [`strait_talkback_test.exs`](strait_talkback_test.exs) | Replay windows and sequence guards |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/08-lampedusa-strait-talkback](http://localhost:4000/features/17-channels/08-lampedusa-strait-talkback).

```sh
mix test features/17-channels/08-lampedusa-strait-talkback/strait_talkback_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
