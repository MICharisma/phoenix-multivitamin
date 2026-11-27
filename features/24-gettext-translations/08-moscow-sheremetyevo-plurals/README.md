# Gettext translations · 08 · Moscow Sheremetyevo plurals

Clerk Irina counts Aeroflot free stands at Sheremetyevo. Russian
`ngettext/3` uses three forms, and 21 returns to the singular.

**What it teaches**

- Russian plural forms diverge at 1, 2–4, and 5+ (with teen exceptions).
- `Enum.reduce/3` builds a ledger of `{count, line}` tuples.
- Spotlighting a row pattern-matches the ledger tuple.

**Files**

| File | Role |
| --- | --- |
| [`sheremetyevo_plurals_live.ex`](sheremetyevo_plurals_live.ex) | LiveView with Russian `ngettext/3` |
| [`moscow_gettext.ex`](moscow_gettext.ex) | Russian example-local backend |
| [`sheremetyevo_plurals_live_test.exs`](sheremetyevo_plurals_live_test.exs) | Asserts 1, 2, 5, 21, 22 |

**Try it**

```sh
mix test features/24-gettext-translations/08-moscow-sheremetyevo-plurals/sheremetyevo_plurals_live_test.exs
```
