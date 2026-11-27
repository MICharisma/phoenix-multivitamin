# Gettext translations · 09 · Cairo EgyptAir bindings

Clerk Nour posts EgyptAir stand assignments at Cairo International. The
Arabic line interpolates `%{flight}` and `%{stand}` — never concatenates
English fragments.

**What it teaches**

- `gettext/2` fills named bindings from a map.
- A capture builds the binding map from the call sheet.
- Missing binding keys leave `%{flight}` in the msgstr and log an error;
  they do not raise.

**Files**

| File | Role |
| --- | --- |
| [`egyptair_bindings_live.ex`](egyptair_bindings_live.ex) | LiveView with interpolated bindings |
| [`cairo_gettext.ex`](cairo_gettext.ex) | Arabic example-local backend |
| [`egyptair_bindings_live_test.exs`](egyptair_bindings_live_test.exs) | Asserts interpolation and missing keys |

**Try it**

```sh
mix test features/24-gettext-translations/09-cairo-egyptair-bindings/egyptair_bindings_live_test.exs
```
