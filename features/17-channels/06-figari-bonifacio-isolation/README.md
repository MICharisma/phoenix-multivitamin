# Channels · 06 · Figari Bonifacio isolation

Marshal Paul-Antoine Santoni isolates a stand at Figari–Sud Corse after a spill; he gets the checklist, the fuel truck and fire tender get the notice.

**What it teaches**

- One `handle_in/3` can reply to the sender, `push/3` to the sender alone, and `broadcast_from!/3` to the rest.
- `broadcast!/3` includes the sender; `broadcast_from!/3` skips the sending channel's transport.
- The socket implements `connect/2` because it never reads `connect_info`.
- The JS client delegates clicks from one listener and detaches a handler with `channel.off(event, ref)`.

**Files**

| File | Role |
| --- | --- |
| [`bonifacio_socket.ex`](bonifacio_socket.ex) | connect/2 unit socket |
| [`bonifacio_channel.ex`](bonifacio_channel.ex) | reply, push, and broadcast_from together |
| [`bonifacio_isolation_live.ex`](bonifacio_isolation_live.ex) | LiveView page and off()-aware JS client |
| [`bonifacio_isolation_test.exs`](bonifacio_isolation_test.exs) | Sender-only push versus broadcast_from |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/06-figari-bonifacio-isolation](http://localhost:4000/features/17-channels/06-figari-bonifacio-isolation).

```sh
mix test features/17-channels/06-figari-bonifacio-isolation/bonifacio_isolation_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
