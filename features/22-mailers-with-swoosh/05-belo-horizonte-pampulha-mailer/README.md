# Mailers with Swoosh · 05 · Belo Horizonte Pampulha mailer

Igor's Pampulha lagoon board releases only the lagoon lane through the Test
adapter, or holds the board so `refute_email_sent/0` can prove silence.

**What it teaches**

- The Test adapter configured in `config/test.exs`.
- `Swoosh.TestAssertions.assert_email_sent/1` and `refute_email_sent/0`.
- A filtered `for` comprehension choosing which legs go out.

**Files**

| File | Role |
| --- | --- |
| [`pampulha_mailer_live.ex`](pampulha_mailer_live.ex) | Release and hold board |
| [`pampulha_mailer.ex`](pampulha_mailer.ex) | Filtered lagoon delivers |
| [`pampulha_mailer_live_test.exs`](pampulha_mailer_live_test.exs) | assert/refute coverage |

**Try it**

```sh
mix phx.server
```

Open
[/features/22-mailers-with-swoosh/05-belo-horizonte-pampulha-mailer](http://localhost:4000/features/22-mailers-with-swoosh/05-belo-horizonte-pampulha-mailer).

```sh
mix test features/22-mailers-with-swoosh/05-belo-horizonte-pampulha-mailer/pampulha_mailer_live_test.exs
```
