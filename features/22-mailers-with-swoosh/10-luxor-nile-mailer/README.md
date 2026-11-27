# Mailers with Swoosh · 10 · Luxor Nile mailer

Nour's Nile tower at Luxor shows deliver error tuples: a missing `from`
(`{:error, :from_not_set}`) and a runway-closed refusal from a tiny custom
adapter.

**What it teaches**

- `Mailer.deliver/1` returning `{:error, :from_not_set}` before any adapter runs.
- `deliver/2` with a failing adapter yielding `{:error, {:runway_closed, to}}`.
- `with/else` mapping both shapes for the board without raising.

**Files**

| File | Role |
| --- | --- |
| [`nile_mailer_live.ex`](nile_mailer_live.ex) | Error-surface board |
| [`nile_mailer.ex`](nile_mailer.ex) | Missing-from and adapter paths |
| [`nile_failing_adapter.ex`](nile_failing_adapter.ex) | Domain-failure adapter |
| [`nile_mailer_live_test.exs`](nile_mailer_live_test.exs) | Error tuple coverage |

**Try it**

```sh
mix test features/22-mailers-with-swoosh/10-luxor-nile-mailer/nile_mailer_live_test.exs
```
