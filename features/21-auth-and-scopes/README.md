# Auth and scopes

current_scope, assign_scope, scoped routes, and the Phoenix 1.8 scope pattern that keeps a controller's data from leaking across stations. This app has no `mix phx.gen.auth` install; each scenario bottles a minimal example-local equivalent of the generated Scope / UserAuth patterns.

Official reference: [Auth and scopes](https://hexdocs.pm/phoenix/scopes.html)

## Examples (13 of 13 bottled)

01. [Córdoba Mezquita scope](01-cordoba-mezquita-scope/) — available
02. [Arequipa Misti scope](02-arequipa-misti-scope/) — available
03. [La Paz altiplano scope](03-la-paz-altiplano-scope/) — available
04. [Sucre white-city scope](04-sucre-white-city-scope/) — available
05. [Santa Cruz oriente scope](05-santa-cruz-oriente-scope/) — available
06. [Asunción Paraguay scope](06-asuncion-paraguay-scope/) — available
07. [Montevideo Rambla scope](07-montevideo-rambla-scope/) — available
08. [Córdoba Sierras scope](08-cordoba-ar-sierras-scope/) — available
09. [Valdivia Los Ríos scope](09-valdivia-los-rios-scope/) — available
10. [Concepción Biobío scope](10-concepcion-biobio-scope/) — available
11. [Iquique nitrate scope](11-iquique-nitrate-scope/) — available
12. [Arica Morro scope](12-arica-morro-scope/) — available
13. [Cartagena walled scope](13-cartagena-walled-scope/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | A `%Scope{}` defstruct with `@enforce_keys`; `for_controller/2` becomes `:current_scope` on the socket |
| 02 | Module plug `assign_scope`: `init/1` maps opts; `call/2` reads the session and assigns scope or nil |
| 03 | Require-authenticated plug with `with`, `redirect/2`, and `halt/1`; leaky redirect without halt |
| 04 | Context functions that take `%Scope{}` first; heads return slips or raise on the wrong station |
| 05 | Ledger "queries" filtered by `station_id` via `for` / `Enum.reduce` — never a raw all |
| 06 | `on_mount` that returns `{:halt, redirect(...)}` when the scope is missing |
| 07 | Multi-clause `on_mount` like gen.auth: `:mount_current_scope` and `:require_authenticated` |
| 08 | Public versus authenticated access on one LiveView; optional mount always continues |
| 09 | Magic-link token mint/redeem that becomes a Scope, not a `:current_user` assign |
| 10 | Sudo mode via `DateTime.diff` on `authenticated_at`; renew refreshes the window |
| 11 | Scoped PubSub topics; note broadcast and logout broadcast clear the board |
| 12 | Role/permission `can?/2` with guards; marshaller clears the runway, clerk cannot |
| 13 | Capstone: fetch plug, on_mount require, scoped harbour context, renew, logout, refused station |
