# Testing · 12 · Taupō beacon receive

Clerk Hine listens for ZK-HNZ volcanic ticks on a Squirrel AS350. A GenServer
beacon pings subscribers. The suite uses `assert_receive` and
`start_supervised!/1` — never `Process.sleep/1`.

**What it teaches**

- `start_supervised!/1` starts the beacon and guarantees cleanup.
- `assert_receive message, timeout` waits for the mailbox, not a sleep.
- A second linked process can `assert_receive` the same broadcast shape.
- The LiveView `handle_info/2` paints the same tuple the unit test locks.

**Files**

| File | Role |
| --- | --- |
| [`beacon.ex`](beacon.ex) | GenServer beacon |
| [`beacon_receive_live.ex`](beacon_receive_live.ex) | LiveView subscriber |
| [`beacon_test.exs`](beacon_test.exs) | assert_receive suite |
| [`beacon_receive_live_test.exs`](beacon_receive_live_test.exs) | Click paints a tick |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/12-taupo-beacon-receive](http://localhost:4000/features/25-testing/12-taupo-beacon-receive).
Ping the ash plume.

```sh
mix test features/25-testing/12-taupo-beacon-receive/
```
