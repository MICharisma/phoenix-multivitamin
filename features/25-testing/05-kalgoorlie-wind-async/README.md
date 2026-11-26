# Testing · 05 · Kalgoorlie wind async

Clerk Tarni fetches Goldfields wind for a King Air 350 at Kalgoorlie.
`assign_async` starts only after the socket connects. The test waits with
`render_async/1`.

**What it teaches**

- A disconnected `get/2` never starts the async task.
- `live/2` starts the task; the first HTML may still show loading.
- `render_async(view)` waits for the assign without `Process.sleep/1`.
- `has_element?/3` locks the wind value once the task finishes.

**Files**

| File | Role |
| --- | --- |
| [`wind_async_live.ex`](wind_async_live.ex) | Connected-only assign_async |
| [`wind_async_live_test.exs`](wind_async_live_test.exs) | get/2 dead render and render_async |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/05-kalgoorlie-wind-async](http://localhost:4000/features/25-testing/05-kalgoorlie-wind-async).
Watch the Goldfields wind fill after connect.

```sh
mix test features/25-testing/05-kalgoorlie-wind-async/wind_async_live_test.exs
```
