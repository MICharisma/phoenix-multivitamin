# Testing · 08 · Dunedin fuel ledger

Clerk Hamish posts ATR 72 litres into the Otago bay. DataCase opens the SQL
sandbox around every Repo write. A serial suite shows rollback between tests;
an `async: true` suite totals in-memory entries without touching SQLite.

**What it teaches**

- `use PhoenixMultivitamin.DataCase` checks out a sandbox owner per test.
- Writes through the ledger vanish when the test ends — the next test sees an
  empty table.
- SQLite keeps Repo tests on `async: false`. Pure in-memory helpers use a
  second `ExUnit.Case, async: true` module so they never open the sandbox.
- ConnCase LiveView clicks also run inside the sandbox.

**Files**

| File | Role |
| --- | --- |
| [`fuel_entry.ex`](fuel_entry.ex) | Schema |
| [`fuel_ledger.ex`](fuel_ledger.ex) | Context |
| [`fuel_ledger_live.ex`](fuel_ledger_live.ex) | Catalog LiveView |
| [`fuel_ledger_test.exs`](fuel_ledger_test.exs) | DataCase sandbox and async |
| [`fuel_ledger_live_test.exs`](fuel_ledger_live_test.exs) | ConnCase click through the ledger |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/08-dunedin-fuel-ledger](http://localhost:4000/features/25-testing/08-dunedin-fuel-ledger).
Post Otago fuel.

```sh
mix test features/25-testing/08-dunedin-fuel-ledger/
```
