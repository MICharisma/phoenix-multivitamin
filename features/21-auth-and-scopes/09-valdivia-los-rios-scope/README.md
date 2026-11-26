# Auth and scopes · 09 · Valdivia Los Ríos scope

Clerk Pascual redeems a magic fog-link token at Valdivia (ZAL) on the river estuary desk. The token becomes a `%LosRiosScope{}` on `:current_scope` — never a `:current_user` assign.

**What it teaches**

- Magic-link / token flow where a token becomes a Scope
- `mint_login_token/1` and `redeem_login_token/1` via `Base.encode64` / decode
- `with` for the redeem pipeline steps
- Session key `"los_rios_token"`; socket has `:current_scope` and does not have `:current_user`

**Files**

| File | Role |
| --- | --- |
| [`los_rios_scope.ex`](los_rios_scope.ex) | Scope struct |
| [`los_rios_tokens.ex`](los_rios_tokens.ex) | Mint and redeem helpers |
| [`los_rios_scope_live.ex`](los_rios_scope_live.ex) | Fog desk LiveView |
| [`los_rios_scope_live_test.exs`](los_rios_scope_live_test.exs) | Token round-trip and assign keys |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/09-valdivia-los-rios-scope](http://localhost:4000/features/21-auth-and-scopes/09-valdivia-los-rios-scope).

```sh
mix test features/21-auth-and-scopes/09-valdivia-los-rios-scope
```
