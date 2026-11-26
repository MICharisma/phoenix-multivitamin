# Channels · 03 · Brest Iroise orders

De-icing coordinator Erwan Guéguen orders glycol for HOP! ATR 72-600 F-HOPZ on stand 4 while a sleet band crosses the Iroise.

**What it teaches**

- `handle_in/3` answers `{:ok, map}` and `{:error, map}`, a bare `:ok`, nothing at all, or a reply-then-stop.
- `is_map_key/2` guards pick the fluid clause; `cond` checks litres against a per-fluid ceiling.
- The JS client wraps `push`/`receive` in a Promise so a form handler can await ok, error, or timeout.

**Files**

| File | Role |
| --- | --- |
| [`iroise_socket.ex`](iroise_socket.ex) | Stand-scoped UserSocket |
| [`iroise_channel.ex`](iroise_channel.ex) | Four handle_in reply shapes |
| [`iroise_orders_live.ex`](iroise_orders_live.ex) | LiveView page and Promise-based JS client |
| [`iroise_orders_test.exs`](iroise_orders_test.exs) | Reply shapes and channel stop |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/03-brest-iroise-orders](http://localhost:4000/features/17-channels/03-brest-iroise-orders).

```sh
mix test features/17-channels/03-brest-iroise-orders/iroise_orders_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
