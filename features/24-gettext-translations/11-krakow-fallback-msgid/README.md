# Gettext translations · 11 · Kraków fallback msgid

Clerk Ola posts the Balice de-ice pad for LOT. The de-ice line has a Polish
msgstr; the snow NOTAM msgid has none, so Gettext returns the English msgid.

**What it teaches**

- A missing translation falls back to the msgid itself.
- An empty `msgstr ""` counts as untranslated.
- `case` classifies which lines fell back.

**Files**

| File | Role |
| --- | --- |
| [`fallback_msgid_live.ex`](fallback_msgid_live.ex) | LiveView comparing translated vs fallback |
| [`krakow_gettext.ex`](krakow_gettext.ex) | Polish example-local backend |
| [`fallback_msgid_live_test.exs`](fallback_msgid_live_test.exs) | Asserts msgid fallback |

**Try it**

```sh
mix test features/24-gettext-translations/11-krakow-fallback-msgid/fallback_msgid_live_test.exs
```
