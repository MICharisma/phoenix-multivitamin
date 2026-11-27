# Mailers with Swoosh · 12 · Kumasi garden mailer

Ama's garden tower at Kumasi pushes the whole Dash 8 crew roster through
`Mailer.deliver_many/1`, from the station address rather than `noreply@`.

**What it teaches**

- `from/2` (and `reply_to/2`) as a station identity.
- `deliver_many/1` for a crew roster in one adapter call.
- `assert_emails_sent/1` versus singular `assert_email_sent/1`.

**Files**

| File | Role |
| --- | --- |
| [`garden_mailer_live.ex`](garden_mailer_live.ex) | Roster board |
| [`garden_mailer.ex`](garden_mailer.ex) | Station from + deliver_many |
| [`garden_mailer_live_test.exs`](garden_mailer_live_test.exs) | Many vs singular asserts |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/12-kumasi-garden-mailer/garden_mailer_live_test.exs
```
