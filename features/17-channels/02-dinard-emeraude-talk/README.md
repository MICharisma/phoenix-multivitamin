# Channels · 02 · Dinard Émeraude talk

Ramp lead Gwenaëlle Le Bihan reports to a stand at Dinard–Pleurtuy for a Ryanair turnaround; the stand channel only admits rostered crew.

**What it teaches**

- `join/3` matches `"emeraude:stand:" <> stand` and authorizes it against the crew assigned on connect.
- A guard rejects unknown stands; `cond` explains which rule a rostered crew member broke.
- `{:error, reply}` refuses the join; the JS client must `leave()` or it keeps rejoining.
- `handle_in/3` matches the crew role in the socket assigns before calling chocks.

**Files**

| File | Role |
| --- | --- |
| [`emeraude_socket.ex`](emeraude_socket.ex) | Badge roster connect/3 |
| [`emeraude_channel.ex`](emeraude_channel.ex) | Stand join authorization and chocks |
| [`emeraude_talk_live.ex`](emeraude_talk_live.ex) | LiveView page and colocated JS client |
| [`emeraude_talk_test.exs`](emeraude_talk_test.exs) | Join refusals and role-gated handle_in |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/02-dinard-emeraude-talk](http://localhost:4000/features/17-channels/02-dinard-emeraude-talk).

```sh
mix test features/17-channels/02-dinard-emeraude-talk/emeraude_talk_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
