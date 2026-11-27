# Presence · 05 · Split Diocletian watch

Ante holds Split Approach while a Croatia Airlines Dash 8-Q400 descends over the old town. The watch roster is kept from presence diffs alone after the first list.

**What it teaches**

- `Presence.list/1` seeds the roster once; every later `presence_diff` is folded in without listing again.
- The view's own join diff arrives after the seeding list already holds it, so joins are de-duplicated by `phx_ref`.
- Leaves are removed by `phx_ref` before joins are added, so a meta update (a leave and a join for one key) lands cleanly.
- Multi-clause reducers with `Enum.reduce/3` and `Map.update/4` keep the merge a pure function of roster and diff.

**Files**

| File | Role |
| --- | --- |
| [`diocletian_watch_live.ex`](diocletian_watch_live.ex) | LiveView that merges presence diffs into its roster |
| [`diocletian_watch_live_test.exs`](diocletian_watch_live_test.exs) | Joins, leaves, an updated frequency, and the single seeding list |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?controller=Ante](http://localhost:4000/features/16-presence/05-split-diocletian-watch?controller=Ante)
and
[?controller=Marija](http://localhost:4000/features/16-presence/05-split-diocletian-watch?controller=Marija)
in two windows. The diff counter rises as controllers connect and leave.

```sh
mix test features/16-presence/05-split-diocletian-watch/diocletian_watch_live_test.exs
```
