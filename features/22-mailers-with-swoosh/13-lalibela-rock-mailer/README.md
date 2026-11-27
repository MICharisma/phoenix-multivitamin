# Mailers with Swoosh · 13 · Lalibela rock mailer

Kidist's rock-hewn desk at Lalibela sends a pilgrimage brief with HTML, text,
an inline crest (`cid:`), and a CSV itinerary — then previews the same mail in
the Local `/dev/mailbox`.

**What it teaches**

- Capstone composition: dual bodies, inline and regular attachments, headers.
- Local mailbox preview beside the Test-env default adapter.
- Reading the configured mailer adapter per environment.

**Files**

| File | Role |
| --- | --- |
| [`rock_mailer_live.ex`](rock_mailer_live.ex) | Capstone board |
| [`rock_mailer.ex`](rock_mailer.ex) | Full email + Local/Test paths |
| [`rock_html.ex`](rock_html.ex) | HEEx body with cid image |
| [`rock_mailer_live_test.exs`](rock_mailer_live_test.exs) | Capstone coverage |

**Try it**

```sh
mix phx.server
```

Open the scenario, preview locally, then visit
[/dev/mailbox](http://localhost:4000/dev/mailbox).

```sh
mix test features/22-mailers-with-swoosh/13-lalibela-rock-mailer/rock_mailer_live_test.exs
```
