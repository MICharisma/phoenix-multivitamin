# Testing · 07 · Launceston tower channel

Clerk Nerida joins the Tamar tower topic for a Saab 340. ChannelCase
connects the scenario socket, joins `tower:14`, pushes an inbound call, and
asserts the reply plus the broadcast.

**What it teaches**

- `use PhoenixMultivitaminWeb.ChannelCase` imports `Phoenix.ChannelTest`.
- `connect/3` opens the UserSocket with a desk name.
- `subscribe_and_join/3` joins the topic and returns the join reply.
- `push/3` plus `assert_reply/3` locks the synchronous reply.
- `assert_broadcast/2` locks what every subscriber on the topic receives.

**Files**

| File | Role |
| --- | --- |
| [`tower_socket.ex`](tower_socket.ex) | Scenario UserSocket |
| [`tower_channel.ex`](tower_channel.ex) | join and call_inbound |
| [`tower_channel_live.ex`](tower_channel_live.ex) | Catalog explanation |
| [`tower_channel_test.exs`](tower_channel_test.exs) | ChannelCase assertions |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/07-launceston-tower-channel](http://localhost:4000/features/25-testing/07-launceston-tower-channel)
for the map. The lesson is the ChannelCase file.

```sh
mix test features/25-testing/07-launceston-tower-channel/tower_channel_test.exs
```
