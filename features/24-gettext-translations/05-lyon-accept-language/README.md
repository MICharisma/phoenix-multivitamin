# Gettext translations · 05 · Lyon Accept-Language

Clerk Camille serves the Air France ATIS line at Lyon–Saint-Exupéry. A
locale plug reads Accept-Language, picks fr / en / de, and
`Gettext.put_locale/2` stamps the request process before the controller
renders.

**What it teaches**

- A Plug parses Accept-Language quality values and picks a supported tag.
- `put_locale/2` in the plug makes `gettext/1` speak that language in the action.
- Unsupported tags fall back to English.

**Files**

| File | Role |
| --- | --- |
| [`accept_language_live.ex`](accept_language_live.ex) | Catalog map onto the ATIS desk |
| [`accept_language_plug.ex`](accept_language_plug.ex) | Accept-Language locale plug |
| [`accept_language_controller.ex`](accept_language_controller.ex) | Renders the translated ATIS line |
| [`accept_language_html.ex`](accept_language_html.ex) | Desk template |
| [`accept_language_test.exs`](accept_language_test.exs) | Asserts fr, de, and English fallback |

**Try it**

```sh
mix test features/24-gettext-translations/05-lyon-accept-language/accept_language_test.exs
```
