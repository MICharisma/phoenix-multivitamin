# Ecto migrations and multis · 05 · A Coruña Hercules cabinet

Clerk Breogán logs Sikorsky S-92 lamp hours on the Tower of Hercules
cabinet at A Coruña. The alter that added `lamp_hours` needed a default;
SQLite refuses `NOT NULL` without one on a populated table.

**What it teaches**

- `alter table/2` adding a column with `default:`.
- SQLite refuses `ADD COLUMN … NOT NULL` without a DEFAULT when rows exist.
- A `defstruct` probe reads `PRAGMA table_info`.

**Files**

| File | Role |
| --- | --- |
| [`hercules_cabinet_migration.ex`](hercules_cabinet_migration.ex) | create then alter |
| [`cabinet.ex`](cabinet.ex) | Schema |
| [`column_probe.ex`](column_probe.ex) | Pragma probe and SQLite refusal |
| [`hercules_cabinet_live.ex`](hercules_cabinet_live.ex) | Logs cabinets and probes the limit |
| [`hercules_cabinet_live_test.exs`](hercules_cabinet_live_test.exs) | Default and refusal |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/05-a-coruna-hercules-cabinet/hercules_cabinet_live_test.exs
```
