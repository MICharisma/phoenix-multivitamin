# Ecto migrations and multis · 02 · Beja Alentejo migration

Clerk Rui posts Lockheed C-130H apron slips at Beja Air Base on the
Alentejo plain. The migration speaks `up/0` and `down/0`, not `change/0`.

**What it teaches**

- Explicit `up/0` and `down/0` when `change/0` is not enough.
- `create index/2` in up; `drop_if_exists` in down.
- `cond` labels the exported direction from `function_exported?/3`.

**Files**

| File | Role |
| --- | --- |
| [`apron_slips_migration.ex`](apron_slips_migration.ex) | up/down migration |
| [`apron_slip.ex`](apron_slip.ex) | Schema |
| [`alentejo_migration_live.ex`](alentejo_migration_live.ex) | Posts a slip |
| [`alentejo_migration_live_test.exs`](alentejo_migration_live_test.exs) | Direction exports and a write |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/02-beja-alentejo-migration/alentejo_migration_live_test.exs
```
