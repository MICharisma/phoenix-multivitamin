# Channels · 12 · Varna Golden Sands talk

Slot coordinator Desislava Petrova at Varna asks CFMU for CTOTs while Wizz Air A321neo HA-LZA boards for the Golden Sands charter season.

**What it teaches**

- `handle_in/3` returns `:noreply` while a `Task.async/3` works; `socket_ref/1` keeps the reply path.
- `handle_info/2` matches the task result and calls `reply/2` with `{:ok, map}` or `{:error, map}`.
- `ChannelCase` imports `Phoenix.ChannelTest` and sets `@endpoint` for connect/join/assert_reply.
- The JS client sets a push timeout shorter than the desk latency so a slow CFMU answer times out.

**Files**

| File | Role |
| --- | --- |
| [`golden_sands_socket.ex`](golden_sands_socket.ex) | Slot-desk UserSocket |
| [`golden_sands_channel.ex`](golden_sands_channel.ex) | socket_ref async replies |
| [`varna_slot_desk.ex`](varna_slot_desk.ex) | CFMU calculation with simulated latency |
| [`golden_sands_talk_live.ex`](golden_sands_talk_live.ex) | LiveView page and timeout-aware JS client |
| [`golden_sands_talk_test.exs`](golden_sands_talk_test.exs) | ChannelCase async reply scaffolding |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/12-varna-golden-sands-talk](http://localhost:4000/features/17-channels/12-varna-golden-sands-talk).

```sh
mix test features/17-channels/12-varna-golden-sands-talk/golden_sands_talk_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
