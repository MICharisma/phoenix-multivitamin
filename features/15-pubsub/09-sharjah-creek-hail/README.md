# PubSub · 09 · Sharjah creek hail

Fatima logs helicopter hails over the Sharjah creek reporting points. A hail appears on the board only after it is saved, whoever saved it.

**What it teaches**

- The context broadcasts after `Repo.insert/1` succeeds; the LiveView never broadcasts.
- The context owns the topic: `subscribe/0` hides it, and messages are tagged with its module.
- A streamed board is filled by `handle_info/2`, so writes from anywhere reach every desk.

**Files**

| File | Role |
| --- | --- |
| [`sharjah_creek_hail.ex`](sharjah_creek_hail.ex) | Schema and changeset for a hail |
| [`sharjah_creek_hails.ex`](sharjah_creek_hails.ex) | Context: query, insert, and broadcast after the write |
| [`creek_hail_live.ex`](creek_hail_live.ex) | Form, validation, and streamed hail board |
| [`creek_hail_live_test.exs`](creek_hail_live_test.exs) | Form writes, context-only writes, rejected hails, and mount loading |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/09-sharjah-creek-hail](http://localhost:4000/features/15-pubsub/09-sharjah-creek-hail).

Log a hail such as `A6-SHJ` over Mamzar at 1,000 ft. The migration `priv/repo/migrations/20261126203007_create_sharjah_creek_hails.exs` creates the table. A hail written from `iex -S mix phx.server` through `PhoenixMultivitamin.SharjahCreekHails.log_hail/1` also appears on every open board.

Run the scenario tests:

```sh
mix test features/15-pubsub/09-sharjah-creek-hail/creek_hail_live_test.exs
```
