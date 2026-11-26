# Ecto migrations and multis · 01 · Granada Sierra Nevada migration

Clerk Inés files ATR 72-600 METARs at Granada under the Sierra Nevada.
The table came from a reversible `change/0`.

**What it teaches**

- `change/0` that Ecto can reverse automatically.
- `create table/2` with `null: false` columns and `timestamps(type: :utc_datetime)`.
- `with/else` maps a failed insert onto the form.

**Files**

| File | Role |
| --- | --- |
| [`metar_cards_migration.ex`](metar_cards_migration.ex) | Reversible `change/0` |
| [`metar_card.ex`](metar_card.ex) | Schema matching the table |
| [`sierra_nevada_migration_live.ex`](sierra_nevada_migration_live.ex) | Files a METAR through Repo |
| [`sierra_nevada_migration_live_test.exs`](sierra_nevada_migration_live_test.exs) | change/0 export; valid and zero visibility |

**Try it**

```sh
mix phx.server
```

Open
[/features/20-ecto-migrations-and-multis/01-granada-sierra-nevada-migration](http://localhost:4000/features/20-ecto-migrations-and-multis/01-granada-sierra-nevada-migration).

```sh
mix test features/20-ecto-migrations-and-multis/01-granada-sierra-nevada-migration/sierra_nevada_migration_live_test.exs
```
