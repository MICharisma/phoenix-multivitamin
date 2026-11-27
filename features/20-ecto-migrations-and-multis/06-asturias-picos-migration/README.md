# Ecto migrations and multis · 06 · Asturias Picos migration

Clerk Covadonga replays a Leonardo AW139 phase backfill under the Picos
de Europa. The migration's `execute/2` carries reversible up and down SQL.

**What it teaches**

- `execute/2` for a reversible data migration inside `change/0`.
- A context replays the same SQL and tallies with `Enum.frequencies_by/2`.
- Bare `execute/1` inside `change/0` cannot be rolled back.

**Files**

| File | Role |
| --- | --- |
| [`picos_migration.ex`](picos_migration.ex) | execute/2 backfill |
| [`picos_card.ex`](picos_card.ex) | Schema |
| [`picos_desk.ex`](picos_desk.ex) | Seed and replay |
| [`picos_migration_live.ex`](picos_migration_live.ex) | Seeds and replays |
| [`picos_migration_live_test.exs`](picos_migration_live_test.exs) | Unknown then climb/cruise |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/06-asturias-picos-migration/picos_migration_live_test.exs
```
