# Testing · 09 · Christchurch watch session

The Plains controller arrives in the Plug session, not the URL. ConnTest
seeds Aroha or Tane with `init_test_session/2` before `live/2`. Without a
session the board opens on relief.

**What it teaches**

- `init_test_session(conn, %{...})` must run before `get/2` or `live/2`.
- LiveView `mount/3` receives the session map as its second argument.
- String keys match what Plug stores; atom keys will not appear.
- A missing key is a first-class path — the relief watch — not an error.

**Files**

| File | Role |
| --- | --- |
| [`watch_session_live.ex`](watch_session_live.ex) | Session-driven watch board |
| [`watch_session_live_test.exs`](watch_session_live_test.exs) | init_test_session before live/2 |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/09-christchurch-watch-session](http://localhost:4000/features/25-testing/09-christchurch-watch-session).
The browser opens on relief; the tests seed Aroha and Tane.

```sh
mix test features/25-testing/09-christchurch-watch-session/watch_session_live_test.exs
```
