# Auth and scopes · 01 · Córdoba Mezquita scope

Controller Lucía clips a Mezquita badge at the Córdoba (COR) hangar desk. The session key becomes a typed `%MezquitaScope{}` on `:current_scope`, not a bare user assign.

**What it teaches**

- Scope `defstruct` with `@enforce_keys [:controller, :station]`
- `for_controller/2` builds the scope from a session badge
- Assign `:current_scope` on the socket and pattern match `%MezquitaScope{}`

**Files**

| File | Role |
| --- | --- |
| [`mezquita_scope.ex`](mezquita_scope.ex) | Scope struct and `for_controller/2` |
| [`mezquita_scope_live.ex`](mezquita_scope_live.ex) | LiveView that assigns `:current_scope` |
| [`mezquita_scope_live_test.exs`](mezquita_scope_live_test.exs) | Guest board vs Lucía at COR |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/01-cordoba-mezquita-scope](http://localhost:4000/features/21-auth-and-scopes/01-cordoba-mezquita-scope).

```sh
mix test features/21-auth-and-scopes/01-cordoba-mezquita-scope
```
