# Ecto migrations and multis · 13 · Logroño Rioja handover

Clerk Laia seals Bombardier CRJ900 Rioja batches at Logroño. A unique
index guards the batch code; a four-step context Multi inserts, runs a
clock, updates to sealed, and writes the note.

**What it teaches**

- Capstone migration with `unique_index` and a referenced notes table.
- Context Multi: `insert`, `run`, `update`, and another `insert`.
- Duplicate `batch_code` reports the failed step name.

**Files**

| File | Role |
| --- | --- |
| [`rioja_migration.ex`](rioja_migration.ex) | Unique index + notes table |
| [`rioja_batch.ex`](rioja_batch.ex) | Batch schema |
| [`rioja_note.ex`](rioja_note.ex) | Note schema |
| [`rioja_desk.ex`](rioja_desk.ex) | Four-step Multi |
| [`rioja_handover_live.ex`](rioja_handover_live.ex) | Seals batches |
| [`rioja_handover_live_test.exs`](rioja_handover_live_test.exs) | Seal and duplicate |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/13-logrono-rioja-handover/rioja_handover_live_test.exs
```
