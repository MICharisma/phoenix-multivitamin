# Gettext translations · 04 · Dubai Emirates context

Clerk Layla paints Emirates A380 states at Dubai International. The English
word *open* needs a `pgettext/2` context so Arabic can choose the gate form
versus the stand form.

**What it teaches**

- `pgettext/2` attaches a msgctxt that disambiguates identical English words.
- Without context, one msgid cannot carry two Arabic senses.
- `cond` picks the surface before the macro runs.

**Files**

| File | Role |
| --- | --- |
| [`emirates_context_live.ex`](emirates_context_live.ex) | LiveView with contextual `pgettext/2` |
| [`dubai_gettext.ex`](dubai_gettext.ex) | Arabic example-local backend |
| [`emirates_context_live_test.exs`](emirates_context_live_test.exs) | Asserts gate vs stand translations |

**Try it**

```sh
mix test features/24-gettext-translations/04-dubai-emirates-context/emirates_context_live_test.exs
```
