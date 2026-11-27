# Auth and scopes · 10 · Concepción Biobío scope

Clerk Ignacio keeps Carriel Sur (CCP) approach plates for an Airbus A320. Unlocking the master plate drawer needs sudo — a recent `authenticated_at` on the scope. Renewing the session refreshes the stamp.

**What it teaches**

- Sudo mode via recent `authenticated_at` on the scope
- `sudo_valid?/1` with `DateTime.diff` inside a window
- Event `"unlock_master_plates"` fails when the stamp is stale
- Event `"renew_session"` refreshes `authenticated_at` with `DateTime.utc_now`

**Files**

| File | Role |
| --- | --- |
| [`biobio_scope.ex`](biobio_scope.ex) | Scope with `authenticated_at` |
| [`biobio_sudo.ex`](biobio_sudo.ex) | `sudo_valid?/1` and ISO8601 parsing |
| [`biobio_scope_live.ex`](biobio_scope_live.ex) | Unlock and renew events |
| [`biobio_scope_live_test.exs`](biobio_scope_live_test.exs) | Fresh unlock, stale fail, renew |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/10-concepcion-biobio-scope](http://localhost:4000/features/21-auth-and-scopes/10-concepcion-biobio-scope).

```sh
mix test features/21-auth-and-scopes/10-concepcion-biobio-scope
```
