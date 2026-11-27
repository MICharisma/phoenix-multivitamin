# Mailers with Swoosh · 11 · Khartoum confluence mailer

Samira relays the Nile confluence leg from Khartoum with an `X-Flight-Leg`
header and a verified `url(~p)` board link in both HTML and text bodies.

**What it teaches**

- `header/3` custom headers on `Swoosh.Email`.
- `url(~p"...")` verified routes inside mail bodies with no conn.

**Files**

| File | Role |
| --- | --- |
| [`confluence_mailer_live.ex`](confluence_mailer_live.ex) | Relay board |
| [`confluence_mailer.ex`](confluence_mailer.ex) | Headers and verified URL |
| [`confluence_html.ex`](confluence_html.ex) | HEEx body with href |
| [`confluence_mailer_live_test.exs`](confluence_mailer_live_test.exs) | Header and URL asserts |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/11-khartoum-confluence-mailer/confluence_mailer_live_test.exs
```
