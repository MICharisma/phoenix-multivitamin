# Gettext translations · 06 · São Paulo put_locale

Clerk Márcia sets the Congonhas pushback line for GOL. The `locale` query
drives `Gettext.put_locale/2` inside `handle_params/3`, with a guard that
rejects unsupported tags.

**What it teaches**

- `put_locale/2` switches the process locale from a URL param.
- Function-head guards keep unsupported locales off the board.
- Locale state lives in the process dictionary for that LiveView process.

**Files**

| File | Role |
| --- | --- |
| [`put_locale_live.ex`](put_locale_live.ex) | LiveView with guarded `handle_params/3` |
| [`sao_paulo_gettext.ex`](sao_paulo_gettext.ex) | Portuguese example-local backend |
| [`put_locale_live_test.exs`](put_locale_live_test.exs) | Asserts pt, en, and rejection |

**Try it**

```sh
mix test features/24-gettext-translations/06-sao-paulo-put-locale/put_locale_live_test.exs
```
