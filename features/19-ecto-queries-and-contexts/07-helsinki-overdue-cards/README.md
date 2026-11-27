# Ecto queries and contexts · 07 · Helsinki overdue cards

Clerk Aino keeps ATR 72-600 tails at Helsinki that still have an overdue work card, via a correlated `exists` subquery.

**What it teaches**

- `exists(subquery(...))` with `parent_as(:aircraft)`.
- Outer query returns only aircraft that still carry an overdue card.

**Files**

| File | Role |
| --- | --- |
| [`aircraft.ex`](aircraft.ex) | Tail schema |
| [`work_card.ex`](work_card.ex) | Maintenance card schema |
| [`overdue_desk.ex`](overdue_desk.ex) | Exists subquery context |
| [`overdue_cards_live.ex`](overdue_cards_live.ex) | Overdue board |
| [`overdue_cards_live_test.exs`](overdue_cards_live_test.exs) | Clean tail excluded |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/07-helsinki-overdue-cards/overdue_cards_live_test.exs
```
