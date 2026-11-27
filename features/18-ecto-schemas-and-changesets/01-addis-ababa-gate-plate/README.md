# Ecto schemas and changesets · 01 · Addis Ababa gate plate

Clerk Tigist posts an Ethiopian Airlines Boeing 787-8 gate plate at Bole International.

**What it teaches**

- `embedded_schema/1` holds typed fields with no database table.
- `cast/3` and `validate_number/3` still run on the embedded card.

**Files**

| File | Role |
| --- | --- |
| [`gate_plate.ex`](gate_plate.ex) | Embedded gate plate schema |
| [`gate_plate_live.ex`](gate_plate_live.ex) | Form driven by the embed |
| [`gate_plate_live_test.exs`](gate_plate_live_test.exs) | Rejects zero souls, posts the gate |

**Try it**

```sh
mix phx.server
```

Open
[/features/18-ecto-schemas-and-changesets/01-addis-ababa-gate-plate](http://localhost:4000/features/18-ecto-schemas-and-changesets/01-addis-ababa-gate-plate).

```sh
mix test features/18-ecto-schemas-and-changesets/01-addis-ababa-gate-plate/gate_plate_live_test.exs
```
