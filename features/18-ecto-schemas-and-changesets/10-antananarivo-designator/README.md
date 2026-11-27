# Ecto schemas and changesets · 10 · Antananarivo designator

Clerk Voahangy reserves a unique Air Madagascar ATR 72-500 callsign at Ivato.

**What it teaches**

- `unique_constraint/3` does not check uniqueness during validate.
- The second `Repo.insert/1` against the unique index adds `"has already been taken"`.

**Files**

| File | Role |
| --- | --- |
| [`designator.ex`](designator.ex) | Schema with unique_constraint |
| [`designator_live.ex`](designator_live.ex) | Reserves callsigns |
| [`designator_live_test.exs`](designator_live_test.exs) | Second MDG441 is blocked |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/10-antananarivo-designator/designator_live_test.exs
```
