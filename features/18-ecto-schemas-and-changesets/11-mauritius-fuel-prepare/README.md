# Ecto schemas and changesets · 11 · Mauritius fuel prepare

Clerk Priya uplifts an Air Mauritius Airbus A330-200 at Sir Seewoosagur Ramgoolam.

**What it teaches**

- `prepare_changes/2` runs inside the Repo write path.
- US gallons become litres only when the changeset is valid and inserted.

**Files**

| File | Role |
| --- | --- |
| [`fuel_ticket.ex`](fuel_ticket.ex) | Schema with prepare_changes |
| [`fuel_prepare_live.ex`](fuel_prepare_live.ex) | Uplift form |
| [`fuel_prepare_live_test.exs`](fuel_prepare_live_test.exs) | 1000 US gal → 3785 L |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/11-mauritius-fuel-prepare/fuel_prepare_live_test.exs
```
