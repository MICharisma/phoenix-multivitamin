# Gettext translations · 07 · Oslo extract hangar

Clerk Ingrid stamps Norwegian 737 plates at Oslo Gardermoen. The `gettext/1`
macros in the LiveView are what `mix gettext.extract --merge` harvests into
`default.pot` and merges into the Norwegian `.po`.

**What it teaches**

- Extractable msgids come from Gettext macros at compile time.
- The `.pot` is the template; the `.po` holds locale msgstr after merge.
- A `@enforce_keys` hangar plate carries the domain values the board prints.

**Files**

| File | Role |
| --- | --- |
| [`extract_hangar_live.ex`](extract_hangar_live.ex) | LiveView whose macros feed extract |
| [`hangar_plate.ex`](hangar_plate.ex) | `defstruct` plate with `@enforce_keys` |
| [`oslo_gettext.ex`](oslo_gettext.ex) | Norwegian example-local backend |
| [`extract_hangar_live_test.exs`](extract_hangar_live_test.exs) | Asserts `.pot`, `.po`, and translations |

**Try it**

```sh
mix gettext.extract --merge priv/gettext_24/07-oslo-extract-hangar
mix test features/24-gettext-translations/07-oslo-extract-hangar/extract_hangar_live_test.exs
```
