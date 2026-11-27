# Channels · 05 · Perpignan tramontane queue

Tower controller Montserrat Puig posts the tramontane at Perpignan–Rivesaltes; each departure checks the crosswind against its own limit.

**What it teaches**

- `intercept/1` routes one broadcast event through `handle_out/3` in every subscribed channel.
- `handle_out/3` guards on each socket's own crosswind limit: hold one departure, release another.
- A LiveView form publishes with `Endpoint.broadcast!/3`; the channels never see the tower.
- The JS client gives each departure strip a class with private fields and its own socket.

**Files**

| File | Role |
| --- | --- |
| [`tramontane_socket.ex`](tramontane_socket.ex) | Queue UserSocket |
| [`tramontane_channel.ex`](tramontane_channel.ex) | intercept and per-socket handle_out |
| [`tramontane_queue_live.ex`](tramontane_queue_live.ex) | Tower form and DepartureStrip JS class |
| [`tramontane_queue_test.exs`](tramontane_queue_test.exs) | One broadcast rewritten per departure |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/05-perpignan-tramontane-queue](http://localhost:4000/features/17-channels/05-perpignan-tramontane-queue).

```sh
mix test features/17-channels/05-perpignan-tramontane-queue/tramontane_queue_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
