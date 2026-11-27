# Ecto schemas and changesets · 08 · Johannesburg turnaround crew

Clerk Sipho opens a South African Airways Airbus A320 turnaround at OR Tambo with nested crew.

**What it teaches**

- `cast_assoc/3` validates and inserts child crew legs with the parent.
- An invalid role on a child fails the whole turnaround write.

**Files**

| File | Role |
| --- | --- |
| [`crew_leg.ex`](crew_leg.ex) | Child crew leg schema |
| [`turnaround.ex`](turnaround.ex) | Parent with cast_assoc |
| [`turnaround_crew_live.ex`](turnaround_crew_live.ex) | Nested form |
| [`turnaround_crew_live_test.exs`](turnaround_crew_live_test.exs) | Writes Lindiwe as captain |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/08-johannesburg-turnaround-crew/turnaround_crew_live_test.exs
```
