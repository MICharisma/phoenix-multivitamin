# Channels · 09 · Kotor bay radio room

Controller Jelena Vujošević works the visual circling approach into Tivat; everyone in the room hears how each operator left.

**What it teaches**

- `terminate/2` runs on leave, on a closed socket, and after `handle_in/3` returns `{:stop, reason, reply, socket}`.
- Multi-clause private functions turn `{:shutdown, :left}`, `{:shutdown, :closed}`, and custom reasons into words.
- `join/3` cannot broadcast; `send(self(), :after_join)` announces the operator once the socket is joined.
- `broadcast_from!/3` in `terminate/2` tells everyone except the operator who left.
- The JS client tells `channel.leave()`, `socket.disconnect(code, reason)`, and `onClose` apart.

**Files**

| File | Role |
| --- | --- |
| [`kotor_socket.ex`](kotor_socket.ex) | Operator connect/3 |
| [`kotor_channel.ex`](kotor_channel.ex) | terminate/2 sign-off reasons |
| [`radio_room_live.ex`](radio_room_live.ex) | LiveView page and leave/disconnect JS client |
| [`radio_room_test.exs`](radio_room_test.exs) | Leave, close, and hand-over terminate paths |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/09-kotor-bay-radio-room](http://localhost:4000/features/17-channels/09-kotor-bay-radio-room).

```sh
mix test features/17-channels/09-kotor-bay-radio-room/radio_room_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
