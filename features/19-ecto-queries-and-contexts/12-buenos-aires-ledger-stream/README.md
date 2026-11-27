# Ecto queries and contexts · 12 · Buenos Aires ledger stream

Clerk Valentina streams Boeing 737-800 fuel ledger lines at Buenos Aires inside a transaction and sums litres without loading the whole list first.

**What it teaches**

- `Repo.stream/2` inside `Repo.transaction/2` with `Enum.reduce/3`.
- Streaming outside a transaction raises (confirmed in the test).

**Files**

| File | Role |
| --- | --- |
| [`ledger_line.ex`](ledger_line.ex) | Ledger schema |
| [`ledger_desk.ex`](ledger_desk.ex) | Stream-in-transaction context |
| [`ledger_stream_live.ex`](ledger_stream_live.ex) | Sum board |
| [`ledger_stream_live_test.exs`](ledger_stream_live_test.exs) | Sum; outside-tx raise |

**Try it**

```sh
mix test features/19-ecto-queries-and-contexts/12-buenos-aires-ledger-stream/ledger_stream_live_test.exs
```
