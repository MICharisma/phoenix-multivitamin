# Ecto queries and contexts · 06 · Santiago late preload

Clerk Camila fetches Airbus A330-200F manifests at Santiago first, then preloads the airline in a second query.

**What it teaches**

- `Repo.all/1` then `Repo.preload/2` — contrast with Tokyo join-preload.
- Same template access shape, different query shape.

**Files**

| File | Role |
| --- | --- |
| [`airline.ex`](airline.ex) | Carrier schema |
| [`manifest.ex`](manifest.ex) | AWB schema |
| [`manifest_desk.ex`](manifest_desk.ex) | Late preload context |
| [`late_preload_live.ex`](late_preload_live.ex) | Manifest board |
| [`late_preload_live_test.exs`](late_preload_live_test.exs) | Airline names after preload |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/06-santiago-late-preload/late_preload_live_test.exs
```
