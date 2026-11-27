# Mailers with Swoosh · 04 · Salvador Pelourinho mailer

Caetano posts the Pelourinho plaza brief into `Swoosh.Adapters.Local` so the
`/dev/mailbox` preview can show it, even though the app's test config keeps
the Test adapter as the default.

**What it teaches**

- `Mailer.deliver/2` with `adapter: Swoosh.Adapters.Local` overriding env config.
- Reading `Swoosh.Adapters.Local.Storage.Memory` after a Local push.
- The `/dev/mailbox` preview path wired in the router for development.

**Files**

| File | Role |
| --- | --- |
| [`pelourinho_mailer_live.ex`](pelourinho_mailer_live.ex) | Board showing adapter vs Local |
| [`pelourinho_mailer.ex`](pelourinho_mailer.ex) | Local deliver and Memory lookup |
| [`pelourinho_mailer_live_test.exs`](pelourinho_mailer_live_test.exs) | Memory storage and refute_email_sent |

**Try it**

```sh
mix phx.server
```

Open the scenario, post the plaza brief, then visit
[/dev/mailbox](http://localhost:4000/dev/mailbox).

```sh
mix test features/22-mailers-with-swoosh/04-salvador-pelourinho-mailer/pelourinho_mailer_live_test.exs
```
