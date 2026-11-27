# Channels · 13 · Burgas Strandzha orders

Tower controller Nadezhda Ivanova orders water drops for Mi-17 CU-17 over Strandzha; a second tab as the helicopter or lookout sees the same topic rewritten per role.

**What it teaches**

- `auth_token: true` belongs on `socket/3` itself; `connect/3` then reads `auth_token` and `user_agent` from `connect_info`.
- `id/1` names only the tower sockets so a desk broadcast can drop every tower browser.
- `intercept ["drop_order"]` lets `handle_out/3` redact the discrete frequency for the lookout.
- `join/3` schedules `:after_join` so `net_join` is broadcast only after the socket is joined.
- A second client on the same topic sees `net_join` and `drop_order`; the helicopter accepts with `broadcast!`.
- LongPoll answers HTTP 200 with `status` 410 or 403 in the JSON body.
- The endpoint mounts both websocket and longpoll; the JS client picks one with the `transport` option.

**Files**

| File | Role |
| --- | --- |
| [`strandzha_socket.ex`](strandzha_socket.ex) | auth_token connect/3 and tower id/1 |
| [`strandzha_channel.ex`](strandzha_channel.ex) | Join, order, intercept, and accept |
| [`strandzha_orders_live.ex`](strandzha_orders_live.ex) | LiveView page with role and transport pickers |
| [`strandzha_orders_test.exs`](strandzha_orders_test.exs) | Two clients, redaction, and longpoll 410 |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/17-channels/13-burgas-strandzha-orders](http://localhost:4000/features/17-channels/13-burgas-strandzha-orders).

```sh
mix test features/17-channels/13-burgas-strandzha-orders/strandzha_orders_test.exs
```

`Phoenix.ChannelTest` drives the socket and channel. LiveViewTest checks the
page markup the JS client reads; it does not execute the colocated JavaScript.
