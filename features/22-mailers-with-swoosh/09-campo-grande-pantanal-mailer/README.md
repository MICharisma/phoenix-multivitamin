# Mailers with Swoosh · 09 · Campo Grande Pantanal mailer

Davi sends the Baía Grande wetland brief either through a synchronous
`Mailer.deliver/1` or an Oban-free `Task.async` hop at Campo Grande.

**What it teaches**

- Synchronous delivery versus `Task.async` + `Task.await/2`.
- Returning the same email shape from both paths, tagged `:sync` or `:async`.

**Files**

| File | Role |
| --- | --- |
| [`pantanal_mailer_live.ex`](pantanal_mailer_live.ex) | Sync/async board |
| [`pantanal_mailer.ex`](pantanal_mailer.ex) | Both delivery paths |
| [`pantanal_mailer_live_test.exs`](pantanal_mailer_live_test.exs) | Mode tags and asserts |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/09-campo-grande-pantanal-mailer/pantanal_mailer_live_test.exs
```
