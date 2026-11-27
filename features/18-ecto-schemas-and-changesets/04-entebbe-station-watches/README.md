# Ecto schemas and changesets · 04 · Entebbe station watches

Clerk Namazzi opens night watches on the Bombardier CRJ900 station at Entebbe International.

**What it teaches**

- `has_many/3` on the station and `belongs_to/3` on each watch.
- `Repo.insert/1` plus `preload/2` reads the association back.

**Files**

| File | Role |
| --- | --- |
| [`station.ex`](station.ex) | Station schema with has_many |
| [`watch.ex`](watch.ex) | Watch schema with belongs_to |
| [`station_watches_live.ex`](station_watches_live.ex) | Opens watches under HUEN |
| [`station_watches_live_test.exs`](station_watches_live_test.exs) | Watch appears on the station |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/04-entebbe-station-watches/station_watches_live_test.exs
```
