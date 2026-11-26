# Ecto schemas and changesets · 06 · Windhoek friction code

Clerk Ndapewa logs runway MU codes for an Air Namibia Airbus A319 at Hosea Kutako.

**What it teaches**

- A custom `Ecto.Type` with `cast/1`, `load/1`, and `dump/1`.
- Unknown codes become changeset `"is invalid"`; known codes normalize case.

**Files**

| File | Role |
| --- | --- |
| [`friction_code.ex`](friction_code.ex) | Custom Ecto.Type |
| [`friction_reading.ex`](friction_reading.ex) | Schema using the type |
| [`friction_code_live.ex`](friction_code_live.ex) | Logs a reading |
| [`friction_code_live_test.exs`](friction_code_live_test.exs) | Rejects ICE, stores MEDIUM |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/06-windhoek-friction-code/friction_code_live_test.exs
```
