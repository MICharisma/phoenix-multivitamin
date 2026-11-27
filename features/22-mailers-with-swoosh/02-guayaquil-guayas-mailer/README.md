# Mailers with Swoosh · 02 · Guayaquil Guayas mailer

Marisol's tide desk at José Joaquín de Olmedo mails the Guayas mangrove hop
with HTML and text bodies, a river-desk cc, archive bcc, and a hydrologist
reply-to.

**What it teaches**

- `html_body/2` beside `text_body/2` on one email.
- `cc/2`, `bcc/2`, and `reply_to/2` with tuple and bare-address recipients.
- `with/else` rejecting an unknown duty officer before the pipeline runs.

**Files**

| File | Role |
| --- | --- |
| [`guayas_mailer_live.ex`](guayas_mailer_live.ex) | Board with compose and reject paths |
| [`guayas_mailer.ex`](guayas_mailer.ex) | Recipient validation and email fields |
| [`guayas_mailer_live_test.exs`](guayas_mailer_live_test.exs) | Field coverage and LiveView clicks |

**Try it**

```sh
mix phx.server
```

Open
[/features/22-mailers-with-swoosh/02-guayaquil-guayas-mailer](http://localhost:4000/features/22-mailers-with-swoosh/02-guayaquil-guayas-mailer).

```sh
mix test features/22-mailers-with-swoosh/02-guayaquil-guayas-mailer/guayas_mailer_live_test.exs
```
