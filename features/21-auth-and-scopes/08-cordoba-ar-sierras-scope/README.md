# Auth and scopes · 08 · Córdoba Sierras scope

Clerk Emilia runs the scenic-flight desk over the Córdoba Sierras in a Cessna 208B Caravan. Anyone can read the winds-aloft board; only an authenticated scope opens her charter desk.

**What it teaches**

- Public versus authenticated access on one LiveView
- `on_mount {SierrasAuth, :mount_optional}` always continues, assigning nil or a scope
- The public winds board always renders; the charter panel only when a scope is present
- Event `"open_charter_desk"` is rejected without a scope via handle_event heads

**Files**

| File | Role |
| --- | --- |
| [`sierras_scope.ex`](sierras_scope.ex) | Scope struct and `for_clerk/1` |
| [`sierras_auth.ex`](sierras_auth.ex) | Optional `on_mount` that always continues |
| [`sierras_scope_live.ex`](sierras_scope_live.ex) | Public board plus authenticated charter desk |
| [`sierras_scope_live_test.exs`](sierras_scope_live_test.exs) | Guest rejection vs Emilia at COR |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/08-cordoba-ar-sierras-scope](http://localhost:4000/features/21-auth-and-scopes/08-cordoba-ar-sierras-scope).

```sh
mix test features/21-auth-and-scopes/08-cordoba-ar-sierras-scope
```
