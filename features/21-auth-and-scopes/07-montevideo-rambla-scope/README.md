# Auth and scopes · 07 · Montevideo Rambla scope

Clerk Sofía keeps the Carrasco (MVD) Rambla coastal METAR desk. `RamblaAuth` exposes multi-clause `on_mount/4` hooks — `:mount_current_scope` always assigns `:current_scope` (possibly nil), and `:require_authenticated` redirects to `/` when the scope is missing.

**What it teaches**

- Multi-clause `on_mount/4` like `mix phx.gen.auth`
- `:mount_current_scope` always assigns `:current_scope`
- LiveView uses `on_mount {RamblaAuth, :require_authenticated}`

**Files**

| File | Role |
| --- | --- |
| [`rambla_scope.ex`](rambla_scope.ex) | Scope struct |
| [`rambla_auth.ex`](rambla_auth.ex) | Multi-clause on_mount hooks |
| [`rambla_scope_live.ex`](rambla_scope_live.ex) | Protected METAR LiveView |
| [`rambla_scope_live_test.exs`](rambla_scope_live_test.exs) | Redirect, board, and mount clause |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/07-montevideo-rambla-scope](http://localhost:4000/features/21-auth-and-scopes/07-montevideo-rambla-scope)
with a `rambla_token` session.

```sh
mix test features/21-auth-and-scopes/07-montevideo-rambla-scope
```
