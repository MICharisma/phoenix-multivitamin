# Channels · 11 · Constanța Black Sea wire

Offshore flight follower Andreea Popescu at Mihail Kogălniceanu tracks AW139 YR-BSA out to the gas platforms with nine-byte binary frames.

**What it teaches**

- `handle_in/3` receives `{:binary, bytes}` and pattern-matches a fixed-width tracker frame.
- Clause order separates a bad heading, a wrong frame size, and a JSON payload that should be binary.
- A reply can be `{:ok, {:binary, bytes}}`; a binary comprehension packs the platform table.
- The JS client builds frames with `DataView` and reads `ArrayBuffer` replies.

**Files**

| File | Role |
| --- | --- |
| [`black_sea_socket.ex`](black_sea_socket.ex) | Tracks UserSocket |
| [`black_sea_channel.ex`](black_sea_channel.ex) | Binary frame decode and reply |
| [`black_sea_wire_live.ex`](black_sea_wire_live.ex) | LiveView page and DataView JS client |
| [`black_sea_wire_test.exs`](black_sea_wire_test.exs) | Binary reply and error clauses |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/11-constanta-black-sea-wire](http://localhost:4000/features/17-channels/11-constanta-black-sea-wire).

```sh
mix test features/17-channels/11-constanta-black-sea-wire/black_sea_wire_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
