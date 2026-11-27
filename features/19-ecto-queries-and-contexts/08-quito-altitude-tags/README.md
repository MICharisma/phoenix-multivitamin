# Ecto queries and contexts · 08 · Quito altitude tags

Clerk Lucía matches Boeing 767-300F cargo labels at Quito with a SQLite-safe `lower(?)` fragment and builds a display string in SQL.

**What it teaches**

- `fragment("lower(?)", tag.label)` for case-insensitive match on SQLite.
- Concat fragment for a display label with altitude.

**Files**

| File | Role |
| --- | --- |
| [`cargo_tag.ex`](cargo_tag.ex) | Tag schema |
| [`tag_desk.ex`](tag_desk.ex) | Fragment query context |
| [`altitude_tags_live.ex`](altitude_tags_live.ex) | Matched tag board |
| [`altitude_tags_live_test.exs`](altitude_tags_live_test.exs) | Mixed-case match; display |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/08-quito-altitude-tags/altitude_tags_live_test.exs
```
