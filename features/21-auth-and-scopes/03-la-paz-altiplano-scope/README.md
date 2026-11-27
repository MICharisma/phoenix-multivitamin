# Auth and scopes · 03 · La Paz altiplano scope

High-altitude oxygen clerk Camila works El Alto (LPB). A require-authenticated plug redirects to the altiplano roster and `halt/1`s when the session token is missing; a leaky `call_without_halt/2` shows why halt matters.

**What it teaches**

- Require-authenticated plug: `redirect/2` + `halt/1` when scope is missing
- Leaky redirect without halt still leaves the response sent
- `with` for session token lookup on both plug and LiveView `on_mount`

**Files**

| File | Role |
| --- | --- |
| [`altiplano_scope.ex`](altiplano_scope.ex) | Scope struct |
| [`altiplano_require_auth.ex`](altiplano_require_auth.ex) | Require-auth plug + leaky twin |
| [`altiplano_scope_live.ex`](altiplano_scope_live.ex) | LiveView with on_mount require pattern |
| [`altiplano_scope_test.exs`](altiplano_scope_test.exs) | Plug.call and LiveView coverage |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/03-la-paz-altiplano-scope](http://localhost:4000/features/21-auth-and-scopes/03-la-paz-altiplano-scope).

```sh
mix test features/21-auth-and-scopes/03-la-paz-altiplano-scope
```
