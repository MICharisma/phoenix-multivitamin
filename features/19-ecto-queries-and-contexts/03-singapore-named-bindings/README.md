# Ecto queries and contexts · 03 · Singapore named bindings

Clerk Mei Ling filters Airbus A350-900 legs at Singapore by a named airline binding IATA, not join position.

**What it teaches**

- `as: :flight` / `as: :airline` named bindings on `from` and `join`.
- `where: as(:airline).iata == ^iata` and `order_by` on named bindings.

**Files**

| File | Role |
| --- | --- |
| [`airline.ex`](airline.ex) | Carrier schema |
| [`flight.ex`](flight.ex) | Leg schema |
| [`hub_desk.ex`](hub_desk.ex) | Named-binding query |
| [`named_bindings_live.ex`](named_bindings_live.ex) | IATA-filtered board |
| [`named_bindings_live_test.exs`](named_bindings_live_test.exs) | SQ rows only |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/03-singapore-named-bindings/named_bindings_live_test.exs
```
