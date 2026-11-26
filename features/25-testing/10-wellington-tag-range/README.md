# Testing · 10 · Wellington tag range

Clerk Moana boards a Dash 8-300 on Cook Strait or Harbour. The lesson is the
ExUnit file: `setup_all`, per-describe `setup`, `@describetag`, and `@tag`
merge into the test context.

**What it teaches**

- `setup_all/1` runs once per module and seeds shared context.
- `setup/1` runs per test and can read tags already on the context.
- `@describetag sector: :harbour` applies to every test in the describe.
- `@tag souls: 12` merges into that one test's context map.
- `@moduletag` marks the whole module for filtered runs.

**Files**

| File | Role |
| --- | --- |
| [`range_log.ex`](range_log.ex) | Domain struct for boarding |
| [`tag_range_live.ex`](tag_range_live.ex) | Catalog page |
| [`tag_range_test.exs`](tag_range_test.exs) | describe / setup / setup_all / tags |
| [`tag_range_live_test.exs`](tag_range_live_test.exs) | Catalog smoke test |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/10-wellington-tag-range](http://localhost:4000/features/25-testing/10-wellington-tag-range).

```sh
mix test features/25-testing/10-wellington-tag-range/tag_range_test.exs
```
