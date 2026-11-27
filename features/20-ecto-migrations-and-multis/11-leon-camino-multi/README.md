# Ecto migrations and multis · 11 · León Camino multi

Clerk Froilán walks a Pilatus PC-12 Camino leg from León. `Multi.merge/2`
composes a leg Multi and a stamp Multi into one transaction.

**What it teaches**

- `Multi.merge/2` composing two smaller Multis.
- `Map.fetch!/2` reading the merged leg before stamping.
- Pattern match on the combined result map.

**Files**

| File | Role |
| --- | --- |
| [`camino_leg.ex`](camino_leg.ex) | Leg schema |
| [`camino_stamp.ex`](camino_stamp.ex) | Stamp schema |
| [`camino_desk.ex`](camino_desk.ex) | merge-built Multi |
| [`camino_multi_live.ex`](camino_multi_live.ex) | Walks the leg |
| [`camino_multi_live_test.exs`](camino_multi_live_test.exs) | Leg and stamp together |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/11-leon-camino-multi/camino_multi_live_test.exs
```
