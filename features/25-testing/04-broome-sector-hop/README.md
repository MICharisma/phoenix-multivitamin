# Testing · 04 · Broome sector hop

Clerk Jarrah patches a Dash 8-300 between Cable Beach and Pearl, then
navigates to the hold. Tests lock the patch with `assert_patch/2` and the
navigate with `follow_redirect/3`.

**What it teaches**

- `push_patch` keeps the LiveView process; `assert_patch(view, path)` waits
  for the new URL.
- `push_navigate` leaves the process; `render_click` returns a redirect that
  `follow_redirect(conn, path)` follows onto another LiveView.
- `handle_params/3` reads the sector query after the patch.

**Files**

| File | Role |
| --- | --- |
| [`sector_hop_live.ex`](sector_hop_live.ex) | Patch and navigate from the sector board |
| [`hold_live.ex`](hold_live.ex) | Hold board for follow_redirect |
| [`sector_hop_live_test.exs`](sector_hop_live_test.exs) | assert_patch and follow_redirect |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/04-broome-sector-hop](http://localhost:4000/features/25-testing/04-broome-sector-hop).
Open Pearl, then the hold.

```sh
mix test features/25-testing/04-broome-sector-hop/sector_hop_live_test.exs
```
