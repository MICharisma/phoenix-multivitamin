# Ecto schemas and changesets · 03 · Dar es Salaam cargo bay

Clerk Asha balances forward and aft kilograms on a Precision Air ATR 72-600 at Julius Nyerere.

**What it teaches**

- `embeds_one/3` nests a single bay layout on the cargo card.
- A custom balance check on the embed keeps forward and aft within 400 kg.

**Files**

| File | Role |
| --- | --- |
| [`cargo_bay.ex`](cargo_bay.ex) | Nested bay embed |
| [`cargo_card.ex`](cargo_card.ex) | Card with embeds_one |
| [`cargo_bay_live.ex`](cargo_bay_live.ex) | Form for the bay |
| [`cargo_bay_live_test.exs`](cargo_bay_live_test.exs) | Rejects an unbalanced bay |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/03-dar-es-salaam-cargo-bay/cargo_bay_live_test.exs
```
