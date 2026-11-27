# Ecto migrations and multis · 12 · Vitoria Basque multi

Clerk Amaia hands over ATR 42-600 bays at Vitoria-Gasteiz. The context
owns the Multi and returns an `@enforce_keys` result with `String.Chars`.

**What it teaches**

- Multi lives only inside the context module.
- `@enforce_keys` defstruct as the public return shape.
- `String.Chars` renders the result for the LiveView.

**Files**

| File | Role |
| --- | --- |
| [`handover.ex`](handover.ex) | Handover schema |
| [`receipt.ex`](receipt.ex) | Receipt schema |
| [`handover_result.ex`](handover_result.ex) | Result struct |
| [`handover_result_chars.ex`](handover_result_chars.ex) | String.Chars implementation |
| [`basque_desk.ex`](basque_desk.ex) | Context Multi |
| [`basque_multi_live.ex`](basque_multi_live.ex) | Calls the context |
| [`basque_multi_live_test.exs`](basque_multi_live_test.exs) | Result line and persistence |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/12-vitoria-basque-multi/basque_multi_live_test.exs
```
