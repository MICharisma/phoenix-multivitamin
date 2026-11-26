# Channels · 10 · Ohrid lake talk

Tower controller Biljana Trajkovska at Ohrid listens to several sectors at once while Wizz Air A321neo HA-LVA flies the approach over the lake.

**What it teaches**

- `channel "ohrid:*"` routes every topic with that prefix; an exact `"ohrid:tower"` line above it wins first.
- `join/3` splits the topic and matches the segment list in private function heads.
- A topic the socket has no channel line for never reaches a `join/3`.
- The tower channel broadcasts into another topic with `Endpoint.broadcast!/3`.
- The JS client keeps several channels on one socket in a `Map` and joins or leaves them by checkbox.

**Files**

| File | Role |
| --- | --- |
| [`ohrid_socket.ex`](ohrid_socket.ex) | Exact and splat channel lines |
| [`ohrid_lake_channel.ex`](ohrid_lake_channel.ex) | Topic segment matching |
| [`ohrid_tower_channel.ex`](ohrid_tower_channel.ex) | Tower closing a sector topic |
| [`lake_talk_live.ex`](lake_talk_live.ex) | LiveView page and multi-channel JS client |
| [`lake_talk_test.exs`](lake_talk_test.exs) | Splat routing and missing channel lines |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/10-ohrid-lake-talk](http://localhost:4000/features/17-channels/10-ohrid-lake-talk).

```sh
mix test features/17-channels/10-ohrid-lake-talk/lake_talk_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
