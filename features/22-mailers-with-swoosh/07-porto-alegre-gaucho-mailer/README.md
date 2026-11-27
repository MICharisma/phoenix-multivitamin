# Mailers with Swoosh · 07 · Porto Alegre gaúcho mailer

Lorena wraps the pampeiro hold notice in a shared HEEx mail layout before it
leaves Salgado Filho for the 737-800.

**What it teaches**

- An HTML email layout as a function component with a named inner slot.
- Rendering HEEx to a string for `html_body/2`, with a plain `text_body/2` twin.

**Files**

| File | Role |
| --- | --- |
| [`gaucho_mailer_live.ex`](gaucho_mailer_live.ex) | Send board |
| [`gaucho_mailer.ex`](gaucho_mailer.ex) | Deliver with layout HTML |
| [`gaucho_html.ex`](gaucho_html.ex) | Layout and wind notice components |
| [`gaucho_mailer_live_test.exs`](gaucho_mailer_live_test.exs) | Layout marker assertions |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/07-porto-alegre-gaucho-mailer/gaucho_mailer_live_test.exs
```
