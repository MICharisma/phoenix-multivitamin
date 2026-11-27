# Gettext translations · 02 · Warsaw LOT apron

Clerk Basia tallies LOT Embraer 195s on the Warsaw Chopin apron. Polish
`ngettext/3` has three plural forms, so 1, 2–4, and 5+ (and 22) each pick a
different msgstr.

**What it teaches**

- `ngettext/3` chooses a plural form from the count.
- Polish needs three msgstr indices; English's two-form habit is wrong here.
- A `for` comprehension builds the apron board from counts.

**Files**

| File | Role |
| --- | --- |
| [`lot_apron_live.ex`](lot_apron_live.ex) | LiveView that maps counts through `ngettext/3` |
| [`warsaw_gettext.ex`](warsaw_gettext.ex) | Polish example-local backend |
| [`lot_apron_live_test.exs`](lot_apron_live_test.exs) | Asserts forms for 1, 2, 5, and 22 |

**Try it**

```sh
mix test features/24-gettext-translations/02-warsaw-lot-apron/lot_apron_live_test.exs
```
