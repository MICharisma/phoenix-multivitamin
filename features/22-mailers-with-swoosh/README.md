# Mailers with Swoosh

Swoosh.Email building, HEEx mail templates, attachments, Local/Test adapters,
`Swoosh.TestAssertions`, `/dev/mailbox` preview, Task-based async delivery, and
`deliver`/`deliver_many` error tuples — never a real SMTP send.

Official reference: [Mailers with Swoosh](https://hexdocs.pm/swoosh/Swoosh.html)

## Examples (13 of 13 bottled)

01. [Medellín Guatapé mailer](01-medellin-guatape-mailer/) — available
02. [Guayaquil Guayas mailer](02-guayaquil-guayas-mailer/) — available
03. [Belém Ver-o-Peso mailer](03-belem-ver-o-peso-mailer/) — available
04. [Salvador Pelourinho mailer](04-salvador-pelourinho-mailer/) — available
05. [Belo Horizonte Pampulha mailer](05-belo-horizonte-pampulha-mailer/) — available
06. [Curitiba wire mailer](06-curitiba-wire-mailer/) — available
07. [Porto Alegre gaúcho mailer](07-porto-alegre-gaucho-mailer/) — available
08. [Florianópolis ilha mailer](08-florianopolis-ilha-mailer/) — available
09. [Campo Grande Pantanal mailer](09-campo-grande-pantanal-mailer/) — available
10. [Luxor Nile mailer](10-luxor-nile-mailer/) — available
11. [Khartoum confluence mailer](11-khartoum-confluence-mailer/) — available
12. [Kumasi garden mailer](12-kumasi-garden-mailer/) — available
13. [Lalibela rock mailer](13-lalibela-rock-mailer/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | `new/0`, `to/2`, `from/2`, `subject/2`, `text_body/2`; enforced brief + `String.Chars` |
| 02 | `html_body/2` beside text; `cc/2`, `bcc/2`, `reply_to/2`; `with` recipient validation |
| 03 | `Mailer.deliver/1` through the application mailer; guarded craft heads |
| 04 | Local adapter override; `Memory` storage; `/dev/mailbox` preview path |
| 05 | Test adapter; `assert_email_sent` / `refute_email_sent`; filtered `for` |
| 06 | Regular `Swoosh.Attachment` via `Enum.reduce/3` |
| 07 | HEEx mail layout with a named slot wrapping the HTML body |
| 08 | `Email.assign/3` driving a HEEx mail template |
| 09 | Sync `deliver/1` versus Oban-free `Task.async` delivery |
| 10 | `{:error, :from_not_set}` and custom-adapter error tuples |
| 11 | `header/3` plus verified `url(~p)` inside HTML and text |
| 12 | Station `from` identity; `deliver_many/1`; `assert_emails_sent` |
| 13 | Capstone: dual bodies, inline + regular attachments, Local preview, env adapter |

Every scenario uses `Swoosh.Adapters.Test` (test) or `Swoosh.Adapters.Local`
(dev / explicit override). Nothing sends real email.

```sh
mix test features/22-mailers-with-swoosh
mix precommit
```
