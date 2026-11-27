# Auth and scopes · 13 · Cartagena walled scope

Clerk Catalina runs the walled-harbour seaplane desk at Cartagena (CTG) for a DHC-6 Twin Otter. This capstone ties together a fetch-scope plug, `on_mount` require, a scoped harbour context, session renewal, logout broadcast, and a refused Barranquilla board.

**What it teaches**

- Capstone: plug (`Plug.call`), `on_mount` require, scoped context
- `list_harbour_slips/1` only returns slips for CTG
- Session renewal updates `authenticated_at`
- Logout broadcasts on the scoped harbour topic
- Wrong station (Barranquilla / BAQ) is refused

**Files**

| File | Role |
| --- | --- |
| [`walled_scope.ex`](walled_scope.ex) | Scope struct |
| [`walled_auth.ex`](walled_auth.ex) | Plug + on_mount + PubSub helpers |
| [`walled_harbour.ex`](walled_harbour.ex) | Scoped harbour context |
| [`walled_scope_live.ex`](walled_scope_live.ex) | Capstone LiveView |
| [`walled_scope_test.exs`](walled_scope_test.exs) | Plug, context, renew, logout, refusal |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/13-cartagena-walled-scope](http://localhost:4000/features/21-auth-and-scopes/13-cartagena-walled-scope).

```sh
mix test features/21-auth-and-scopes/13-cartagena-walled-scope
```
