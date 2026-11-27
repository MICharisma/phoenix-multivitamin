# Channels · 07 · Pantelleria channel desk

Forecaster Salvatore Gabriele watches three anemometers across Pantelleria's ridge while DAT ATR 42-500 I-ADLV holds for a gap in the shear.

**What it teaches**

- `join/3` sends itself `:after_join`, so the wind table is pushed only after the join reply.
- `handle_info/2` pushes on a `Process.send_after/3` cadence that the join payload clamps.
- Repeating `generation` in one function head drops a stale tick after `pause_sampling`.
- `with/1` chains two guarded matches to decide whether a headwind change is windshear.
- The JS client registers handlers from an object map and draws an SVG polyline.

**Files**

| File | Role |
| --- | --- |
| [`pantelleria_socket.ex`](pantelleria_socket.ex) | Anemometer UserSocket |
| [`pantelleria_channel.ex`](pantelleria_channel.ex) | after_join, cadence, and generation |
| [`channel_desk_live.ex`](channel_desk_live.ex) | LiveView page and SVG JS client |
| [`channel_desk_test.exs`](channel_desk_test.exs) | Cadence, pause, and windshear |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/07-pantelleria-channel-desk](http://localhost:4000/features/17-channels/07-pantelleria-channel-desk).

```sh
mix test features/17-channels/07-pantelleria-channel-desk/channel_desk_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
