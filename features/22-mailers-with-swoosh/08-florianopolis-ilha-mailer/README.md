# Mailers with Swoosh · 08 · Florianópolis ilha mailer

Bianca builds ferry-roster assigns on the `Swoosh.Email` with `assign/3`, then
renders them through a HEEx template for the Hercílio Luz ilha desk.

**What it teaches**

- `Swoosh.Email.assign/3` accumulating template assigns on the email struct.
- HEEx mail templates reading those assigns, including a `:for` over ferry legs.

**Files**

| File | Role |
| --- | --- |
| [`ilha_mailer_live.ex`](ilha_mailer_live.ex) | Roster board |
| [`ilha_mailer.ex`](ilha_mailer.ex) | assign/3 pipeline and deliver |
| [`ilha_html.ex`](ilha_html.ex) | HEEx roster template |
| [`ilha_mailer_live_test.exs`](ilha_mailer_live_test.exs) | Assign and HTML coverage |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/08-florianopolis-ilha-mailer/ilha_mailer_live_test.exs
```
