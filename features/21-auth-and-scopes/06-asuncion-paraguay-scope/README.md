# Auth and scopes · 06 · Asunción Paraguay scope

Controller Thiago runs the Silvio Pettirossi (ASU) night ops board. The `ParaguayAuth` on_mount hook returns `{:halt, redirect(socket, to: "/")}` when the Paraguay token is missing, and `{:cont, socket}` with a scope when it is present.

**What it teaches**

- `on_mount` hook redirects with `{:halt, ...}` when scope is missing
- `{:cont, socket}` continues with `:current_scope` assigned
- LiveView tests assert `{:error, {:redirect, %{to: "/"}}}`

**Files**

| File | Role |
| --- | --- |
| [`paraguay_scope.ex`](paraguay_scope.ex) | Scope struct |
| [`paraguay_auth.ex`](paraguay_auth.ex) | on_mount `:require` hook |
| [`paraguay_scope_live.ex`](paraguay_scope_live.ex) | Protected night ops LiveView |
| [`paraguay_scope_live_test.exs`](paraguay_scope_live_test.exs) | Redirect vs Thiago board |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/06-asuncion-paraguay-scope](http://localhost:4000/features/21-auth-and-scopes/06-asuncion-paraguay-scope)
with a `paraguay_token` session.

```sh
mix test features/21-auth-and-scopes/06-asuncion-paraguay-scope
```
