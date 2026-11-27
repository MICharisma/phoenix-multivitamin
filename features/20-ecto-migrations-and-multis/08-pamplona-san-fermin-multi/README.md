# Ecto migrations and multis · 08 · Pamplona San Fermín multi

Clerk Ainhoa stamps Embraer E190 plates at Pamplona during San Fermín. A
`Multi.run/3` step prices the gate fee; an update writes it back.

**What it teaches**

- `Multi.run/3` for a step that is not a schema write.
- The run callback receives prior named changes (`%{plate: plate}`).
- Guarded desk heads reject bad litres before Multi starts.

**Files**

| File | Role |
| --- | --- |
| [`plate.ex`](plate.ex) | Plate schema |
| [`fermin_desk.ex`](fermin_desk.ex) | insert + run + update |
| [`san_fermin_multi_live.ex`](san_fermin_multi_live.ex) | Stamps plates |
| [`san_fermin_multi_live_test.exs`](san_fermin_multi_live_test.exs) | Fee band and rejection |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/08-pamplona-san-fermin-multi/san_fermin_multi_live_test.exs
```
