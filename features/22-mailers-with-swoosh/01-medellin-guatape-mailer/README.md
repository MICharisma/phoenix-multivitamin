# Mailers with Swoosh · 01 · Medellín Guatapé mailer

Controller Valentina drafts the Guatapé ridge brief for an ATR 72-600 at
José María Córdova. The mailer builds a text-only `Swoosh.Email` from an
enforced watch brief before any adapter runs.

**What it teaches**

- `Swoosh.Email.new/0` piped through `to/2`, `from/2`, `subject/2`, and
  `text_body/2`.
- A domain `defstruct` with `@enforce_keys`, plus `String.Chars`, so the
  brief joins the text body through `to_string/1`.

**Files**

| File | Role |
| --- | --- |
| [`guatape_mailer_live.ex`](guatape_mailer_live.ex) | Board that composes the draft |
| [`guatape_mailer.ex`](guatape_mailer.ex) | Email pipeline |
| [`watch_brief.ex`](watch_brief.ex) | Enforced brief struct |
| [`watch_brief_chars.ex`](watch_brief_chars.ex) | String.Chars for the brief |
| [`guatape_mailer_live_test.exs`](guatape_mailer_live_test.exs) | Struct body and LiveView compose |

**Try it**

```sh
mix phx.server
```

Open
[/features/22-mailers-with-swoosh/01-medellin-guatape-mailer](http://localhost:4000/features/22-mailers-with-swoosh/01-medellin-guatape-mailer)
and compose the brief.

```sh
mix test features/22-mailers-with-swoosh/01-medellin-guatape-mailer/guatape_mailer_live_test.exs
```
