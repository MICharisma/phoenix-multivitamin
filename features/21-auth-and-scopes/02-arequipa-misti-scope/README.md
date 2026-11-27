# Auth and scopes · 02 · Arequipa Misti scope

Dispatcher Inés sits the Misti volcanic ash desk at Arequipa Rodríguez Ballón (AQP). A module plug assigns `:current_scope` from the `misti_token` session key the same way the LiveView mount does.

**What it teaches**

- Module plug `init/1` / `call/2` that assigns `:current_scope`
- `init/1` turns keyword opts into a map
- Plug tests call `Module.call(conn, Module.init(opts))` directly

**Files**

| File | Role |
| --- | --- |
| [`misti_scope.ex`](misti_scope.ex) | Scope struct and `from_token/1` |
| [`misti_assign_scope.ex`](misti_assign_scope.ex) | assign_scope plug |
| [`misti_scope_live.ex`](misti_scope_live.ex) | Catalog LiveView |
| [`misti_scope_test.exs`](misti_scope_test.exs) | Plug.call and LiveView coverage |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/02-arequipa-misti-scope](http://localhost:4000/features/21-auth-and-scopes/02-arequipa-misti-scope).

```sh
mix test features/21-auth-and-scopes/02-arequipa-misti-scope
```
