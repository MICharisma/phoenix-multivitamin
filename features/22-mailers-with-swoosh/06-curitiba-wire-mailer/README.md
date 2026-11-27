# Mailers with Swoosh · 06 · Curitiba wire mailer

Otávio files A320 torque cook cards from the Afonso Pena wire loft as regular
CSV attachments built with `Swoosh.Attachment.new/2`.

**What it teaches**

- Regular (`type: :attachment`) attachments from `{:data, binary}`.
- `Enum.reduce/3` accumulating attachments onto one email.
- Pattern-matching `%Swoosh.Attachment{}` after delivery.

**Files**

| File | Role |
| --- | --- |
| [`wire_mailer_live.ex`](wire_mailer_live.ex) | Filing board |
| [`wire_mailer.ex`](wire_mailer.ex) | Attachment reduce pipeline |
| [`wire_mailer_live_test.exs`](wire_mailer_live_test.exs) | Attachment assertions |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/06-curitiba-wire-mailer/wire_mailer_live_test.exs
```
