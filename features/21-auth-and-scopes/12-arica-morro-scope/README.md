# Auth and scopes · 12 · Arica Morro scope

Marshaller Diego and clerk Pilar share the Morro cliff VFR desk at Arica (ARI). Diego can clear runway 02; Pilar cannot. A Tacna (TCQ) scope is refused for the Arica board.

**What it teaches**

- Role/permission checks on the scope with `can?/2`
- `defguard` helpers and multi-head `can?/2`
- Marshaller can clear the runway; clerk gets `{:error, :forbidden}`
- Wrong-station scopes cannot open the Arica board

**Files**

| File | Role |
| --- | --- |
| [`morro_scope.ex`](morro_scope.ex) | Scope with role and station |
| [`morro_auth.ex`](morro_auth.ex) | `can?/2`, guards, and board/runway checks |
| [`morro_scope_live.ex`](morro_scope_live.ex) | VFR desk LiveView |
| [`morro_scope_live_test.exs`](morro_scope_live_test.exs) | Diego, Pilar, and Tacna cases |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/12-arica-morro-scope](http://localhost:4000/features/21-auth-and-scopes/12-arica-morro-scope).

```sh
mix test features/21-auth-and-scopes/12-arica-morro-scope
```
