# Ecto migrations and multis · 03 · Vigo Rías Baixas migration

Clerk Carme moors Dash 8-400 bay cards at Vigo against Bouzas harbour
stands. The migration's `references/2` owns the foreign key and its index.

**What it teaches**

- `references/2` with `on_delete: :delete_all`.
- `create index/2` on the foreign key column.
- Nested `then/2` inserts and a filtered `for` of heavy bays.

**Files**

| File | Role |
| --- | --- |
| [`rias_baixas_migration.ex`](rias_baixas_migration.ex) | Parent + child tables with references |
| [`stand.ex`](stand.ex) | Harbour stand |
| [`bay_card.ex`](bay_card.ex) | Bay card with belongs_to |
| [`rias_baixas_migration_live.ex`](rias_baixas_migration_live.ex) | Moors a bay |
| [`rias_baixas_migration_live_test.exs`](rias_baixas_migration_live_test.exs) | Happy path; SQLite nil FK name raises |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/03-vigo-rias-baixas-migration/rias_baixas_migration_live_test.exs
```
