# Channels · 04 · Pau Pyrenees callback

Dispatcher Lucie Etcheverry pages the Sécurité Civile EC145 Dragon 64 crew from Pau–Pyrénées into a Pyrenean valley.

**What it teaches**

- `broadcast!/3` from `handle_in/3` reaches every socket on the topic, the sender included.
- A function head matching `%{assigns: %{role: "dispatcher"}}` gates who may page the crew.
- `Map.new/2` with a capture shapes the callout; `Map.fetch/2` with `case` refuses an unknown valley.
- The JS client renders `channel.on` events from a `<template>` with `Intl.DateTimeFormat`.

**Files**

| File | Role |
| --- | --- |
| [`pyrenees_socket.ex`](pyrenees_socket.ex) | Role and callsign connect/3 |
| [`pyrenees_channel.ex`](pyrenees_channel.ex) | Dispatcher-only broadcast callouts |
| [`pyrenees_callback_live.ex`](pyrenees_callback_live.ex) | LiveView page and template-driven JS client |
| [`pyrenees_callback_test.exs`](pyrenees_callback_test.exs) | Broadcast to every crew socket |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/04-pau-pyrenees-callback](http://localhost:4000/features/17-channels/04-pau-pyrenees-callback).

```sh
mix test features/17-channels/04-pau-pyrenees-callback/pyrenees_callback_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
