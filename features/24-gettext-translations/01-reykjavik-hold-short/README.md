# Gettext translations · 01 · Reykjavík hold-short

Clerk Sigríður paints the hold-short line at Reykjavík Domestic for an Air
Iceland Connect Dash 8-200. The button and the line are `gettext/1` msgids
on an example-local Gettext backend that speaks Icelandic.

**What it teaches**

- `gettext/1` marks a compile-time msgid the backend resolves at runtime.
- An example-local `Gettext.Backend` keeps `.po` files under
  `priv/gettext_24/` for this scenario alone.
- `Gettext.put_locale/2` selects Icelandic for the LiveView process.

**Files**

| File | Role |
| --- | --- |
| [`hold_short_live.ex`](hold_short_live.ex) | LiveView with `gettext/1` on the button and line |
| [`reykjavik_gettext.ex`](reykjavik_gettext.ex) | Example-local Gettext backend |
| [`hold_short_live_test.exs`](hold_short_live_test.exs) | Asserts the Icelandic hold-short string |

**Try it**

```sh
mix phx.server
```

Open
[/features/24-gettext-translations/01-reykjavik-hold-short](http://localhost:4000/features/24-gettext-translations/01-reykjavik-hold-short).

```sh
mix test features/24-gettext-translations/01-reykjavik-hold-short/hold_short_live_test.exs
```
