# Auth and scopes · 04 · Sucre white-city scope

Load clerk Mateo lists fuel slips only for Sucre (SRE). The boards context takes `%WhiteCityScope{}` as its first argument, so a Viru Viru badge never sees Sucre litres.

**What it teaches**

- Context functions take `%Scope{}` as the first argument
- Multiple function heads on the scope station
- Wrong station returns `[]` or raises on `get_slip!/2`

**Files**

| File | Role |
| --- | --- |
| [`white_city_scope.ex`](white_city_scope.ex) | Scope struct |
| [`white_city_boards.ex`](white_city_boards.ex) | Scoped fuel-slip context |
| [`white_city_scope_live.ex`](white_city_scope_live.ex) | LiveView board |
| [`white_city_scope_live_test.exs`](white_city_scope_live_test.exs) | SRE slips vs empty foreign station |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/04-sucre-white-city-scope](http://localhost:4000/features/21-auth-and-scopes/04-sucre-white-city-scope).

```sh
mix test features/21-auth-and-scopes/04-sucre-white-city-scope
```
