# Gettext translations · 03 · Casablanca RAM domain

Clerk Yasmine posts Royal Air Maroc gate states at Mohammed V. Gate phrases
live in the `gates` domain; the ramp line stays in `default`.

**What it teaches**

- `dgettext/2` scopes a msgid to a named domain.
- Domains keep gate copy out of the default catalog.
- `with/1` threads a fallible gate lookup into the translated announcement.

**Files**

| File | Role |
| --- | --- |
| [`ram_domain_live.ex`](ram_domain_live.ex) | LiveView with `dgettext/2` on the gates domain |
| [`casablanca_gettext.ex`](casablanca_gettext.ex) | French example-local backend |
| [`ram_domain_live_test.exs`](ram_domain_live_test.exs) | Asserts domain isolation |

**Try it**

```sh
mix test features/24-gettext-translations/03-casablanca-ram-domain/ram_domain_live_test.exs
```
