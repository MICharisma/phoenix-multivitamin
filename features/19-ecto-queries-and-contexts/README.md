# Ecto queries and contexts

from, where, preload, compose, and a context module that is the only door the web layer uses to reach the Repo.

Official reference: [Ecto queries and contexts](https://hexdocs.pm/ecto/Ecto.Query.html)

## Examples (13 of 13 bottled)

01. [Reykjavik crew board](01-reykjavik-crew-board/) — available
02. [Dubai cargo holds](02-dubai-cargo-holds/) — available
03. [Singapore named bindings](03-singapore-named-bindings/) — available
04. [Johannesburg bay filters](04-johannesburg-bay-filters/) — available
05. [Tokyo join preload](05-tokyo-join-preload/) — available
06. [Santiago late preload](06-santiago-late-preload/) — available
07. [Helsinki overdue cards](07-helsinki-overdue-cards/) — available
08. [Quito altitude tags](08-quito-altitude-tags/) — available
09. [Nairobi cargo totals](09-nairobi-cargo-totals/) — available
10. [Lisbon delay ranks](10-lisbon-delay-ranks/) — available
11. [Auckland apron count](11-auckland-apron-count/) — available
12. [Buenos Aires ledger stream](12-buenos-aires-ledger-stream/) — available
13. [Doha composed desk](13-doha-composed-desk/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | Keyword `from`/`where`/`order_by` behind a context door |
| 02 | Pipe-syntax `Schema |> where |> order_by |> Repo.all` |
| 03 | Named bindings with `as:` / `as(:name)` on joins |
| 04 | `dynamic/2` optional bay and status filters |
| 05 | Join-preload: `join` + `preload: [assoc: binding]` |
| 06 | Late `Repo.preload/2` after fetch (contrast with 05) |
| 07 | Correlated `exists` subquery with `parent_as/1` |
| 08 | SQLite-safe `fragment("lower(?)", ...)` and concat |
| 09 | `group_by` / `having` airline cargo totals |
| 10 | Window `over(row_number(), partition_by: ...)` |
| 11 | `Repo.aggregate/3` occupied and free counts |
| 12 | `Repo.stream/2` inside `Repo.transaction/2` |
| 13 | Capstone: composable context functions as the only door |

Planned titles are proposals, not commitments. See
[CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a slot.
