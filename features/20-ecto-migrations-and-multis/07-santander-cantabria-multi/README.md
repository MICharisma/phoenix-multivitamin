# Ecto migrations and multis · 07 · Santander Cantabria multi

Clerk Itziar files a Boeing 737-800 manifest and fuel slip together at
Santander. `Ecto.Multi.insert/3` twice, then `Repo.transaction/1`.

**What it teaches**

- `Multi.insert/3` then another `insert/3` that reads the first result.
- `Repo.transaction/1` commits both or neither.
- Named result map unpacking with `%{manifest: _, fuel_slip: _}`.

**Files**

| File | Role |
| --- | --- |
| [`manifest.ex`](manifest.ex) | Manifest schema |
| [`fuel_slip.ex`](fuel_slip.ex) | Fuel slip schema |
| [`cantabria_desk.ex`](cantabria_desk.ex) | Multi builder |
| [`cantabria_multi_live.ex`](cantabria_multi_live.ex) | Files the pair |
| [`cantabria_multi_live_test.exs`](cantabria_multi_live_test.exs) | Both land; zero litres rolls back |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/07-santander-cantabria-multi/cantabria_multi_live_test.exs
```
