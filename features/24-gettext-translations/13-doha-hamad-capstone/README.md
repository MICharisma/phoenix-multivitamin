# Gettext translations · 13 · Doha Hamad capstone

Clerk Noor closes the Qatar Airways load sheet at Hamad International. A
locale plug resolves params, then session, then Accept-Language. Arabic
`ngettext` covers six plural forms for bag counts, the gates domain paints
the boarding line, and Ecto changeset errors translate through the errors
domain.

**What it teaches**

- Locale resolution order: params → session → Accept-Language.
- Arabic plurals need six msgstr forms.
- `Gettext.dgettext/4` on the errors domain translates Ecto messages.
- Capstone ties plug, plural, domain, and changeset translation together.

**Files**

| File | Role |
| --- | --- |
| [`hamad_capstone_live.ex`](hamad_capstone_live.ex) | Catalog map onto the desk |
| [`locale_plug.ex`](locale_plug.ex) | Params/session/Accept-Language plug |
| [`hamad_capstone_controller.ex`](hamad_capstone_controller.ex) | Desk action |
| [`hamad_capstone_html.ex`](hamad_capstone_html.ex) | Desk template |
| [`load_sheet.ex`](load_sheet.ex) | Embedded schema + error translation |
| [`doha_gettext.ex`](doha_gettext.ex) | Arabic/English example-local backend |
| [`hamad_capstone_test.exs`](hamad_capstone_test.exs) | Asserts locale order, plurals, errors |

**Try it**

```sh
mix test features/24-gettext-translations/13-doha-hamad-capstone/hamad_capstone_test.exs
```
