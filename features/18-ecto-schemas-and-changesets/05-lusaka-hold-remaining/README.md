# Ecto schemas and changesets · 05 · Lusaka hold remaining

Clerk Chileshe computes remaining hold minutes for a Proflight Zambia Embraer E190 at Kenneth Kaunda.

**What it teaches**

- `field :remaining_min, :integer, virtual: true` is cast and put_change'd.
- `Repo.insert/1` returns the virtual value; `Repo.get/2` loads `nil` for it.

**Files**

| File | Role |
| --- | --- |
| [`hold_card.ex`](hold_card.ex) | Schema with a virtual remaining field |
| [`hold_remaining_live.ex`](hold_remaining_live.ex) | Writes and reloads the card |
| [`hold_remaining_live_test.exs`](hold_remaining_live_test.exs) | Insert keeps 17; reload is nil |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/05-lusaka-hold-remaining/hold_remaining_live_test.exs
```
