# Channels · 01 · Alderney Casquets wire

Dispatcher Morwenna Le Page opens the Casquets weather wire on the north desk before clearing Aurigny Dornier 228 G-SAYE into Alderney.

**What it teaches**

- `connect/3` verifies a signed `Phoenix.Token` from the client params before any channel joins.
- `connect/3` can refuse with `:error` or with `{:error, reason}`; an expired shift is not a missing one.
- `id/1` names every socket of one desk, so a `disconnect` broadcast to that id drops them all.
- The JS client reads params from a closure on every reconnect, so a cleared token stays out.

**Files**

| File | Role |
| --- | --- |
| [`casquets_socket.ex`](casquets_socket.ex) | UserSocket connect/3, id/1, and shift signing |
| [`casquets_channel.ex`](casquets_channel.ex) | Wire join reply with the Casquets reading |
| [`casquets_wire_live.ex`](casquets_wire_live.ex) | LiveView page and colocated JS socket client |
| [`casquets_wire_test.exs`](casquets_wire_test.exs) | ChannelTest connect, join, and desk disconnect |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/01-alderney-casquets-wire](http://localhost:4000/features/17-channels/01-alderney-casquets-wire).

```sh
mix test features/17-channels/01-alderney-casquets-wire/casquets_wire_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
