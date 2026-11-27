# Gettext translations · 10 · Riyadh with_locale

Clerk Fahad keeps the Saudia desk in Arabic at King Khalid, then borrows
English for a brief with `Gettext.with_locale/3` without leaving the
process on English.

**What it teaches**

- `with_locale/3` runs a function under a temporary locale.
- The process locale is restored after the function returns.
- Nested `with_locale` keeps an English brief inside an Arabic desk.

**Files**

| File | Role |
| --- | --- |
| [`with_locale_live.ex`](with_locale_live.ex) | LiveView demonstrating restore and nesting |
| [`riyadh_gettext.ex`](riyadh_gettext.ex) | Arabic/English example-local backend |
| [`with_locale_live_test.exs`](with_locale_live_test.exs) | Asserts restore and nested locale |

**Try it**

```sh
mix test features/24-gettext-translations/10-riyadh-with-locale/with_locale_live_test.exs
```
