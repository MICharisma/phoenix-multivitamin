# Ecto schemas and changesets · 07 · Cape Town duty enum

Clerk Thandi posts a FlySafair Boeing 737-800 duty status at Cape Town International.

**What it teaches**

- `Ecto.Enum` with mapped string values on an embedded schema.
- Unknown status strings become `"is invalid"`; known ones become atoms.

**Files**

| File | Role |
| --- | --- |
| [`duty_card.ex`](duty_card.ex) | Embedded card with Ecto.Enum |
| [`duty_enum_live.ex`](duty_enum_live.ex) | Select driven by the enum |
| [`duty_enum_live_test.exs`](duty_enum_live_test.exs) | Rejects diverted, posts airborne |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/07-cape-town-duty-enum/duty_enum_live_test.exs
```
