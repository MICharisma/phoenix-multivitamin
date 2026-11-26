# Auth and scopes · 05 · Santa Cruz oriente scope

Cargo clerk Renata keeps the Viru Viru (VVI) ledger. Shipments for LPB and SRE sit in the same private list, but every query filters by `station_id` from the scope — never a raw all/1.

**What it teaches**

- Never raw all/1 — filter by `station_id` in queries
- `for` comprehension filters the shipment list
- `Enum.reduce` totals only the scoped rows

**Files**

| File | Role |
| --- | --- |
| [`oriente_scope.ex`](oriente_scope.ex) | Scope with `station_id` |
| [`oriente_ledger.ex`](oriente_ledger.ex) | Scoped shipment "queries" |
| [`oriente_scope_live.ex`](oriente_scope_live.ex) | LiveView cargo board |
| [`oriente_scope_live_test.exs`](oriente_scope_live_test.exs) | Asserts other stations never appear |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/05-santa-cruz-oriente-scope](http://localhost:4000/features/21-auth-and-scopes/05-santa-cruz-oriente-scope).

```sh
mix test features/21-auth-and-scopes/05-santa-cruz-oriente-scope
```
