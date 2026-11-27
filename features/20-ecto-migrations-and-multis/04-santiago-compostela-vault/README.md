# Ecto migrations and multis · 04 · Santiago Compostela vault

Clerk Xoán seals Airbus A320neo fuel vault tickets at Santiago de
Compostela. A unique index guards the vault code. SQLite refuses
`ALTER TABLE ADD CONSTRAINT` for a check, so litres are validated in
the changeset.

**What it teaches**

- `unique_index/3` and `unique_constraint/3` after the write.
- SQLite does not support `ALTER TABLE ADD CONSTRAINT`.
- `validate_number/3` stands in for the CHECK the adapter will not add.

**Files**

| File | Role |
| --- | --- |
| [`compostela_vault_migration.ex`](compostela_vault_migration.ex) | Unique index; documents the refused check |
| [`vault_ticket.ex`](vault_ticket.ex) | Schema with unique_constraint |
| [`sqlite_constraint_probe.ex`](sqlite_constraint_probe.ex) | Probes ADD CONSTRAINT |
| [`compostela_vault_live.ex`](compostela_vault_live.ex) | Seals vaults |
| [`compostela_vault_live_test.exs`](compostela_vault_live_test.exs) | Duplicate, zero litres, SQLite refusal |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/04-santiago-compostela-vault/compostela_vault_live_test.exs
```
