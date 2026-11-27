# Mailers with Swoosh · 03 · Belém Ver-o-Peso mailer

Rafaela releases Ver-o-Peso market freighter slots at Val de Cans through
`PhoenixMultivitamin.Mailer.deliver/1`. Only the Caravan and Brasilia clear
the lane.

**What it teaches**

- Delivering through the application mailer configured per environment.
- `case` on `{:ok, metadata}` from `Mailer.deliver/1`.
- Guarded function heads that refuse a craft before any adapter call.

**Files**

| File | Role |
| --- | --- |
| [`ver_o_peso_mailer_live.ex`](ver_o_peso_mailer_live.ex) | Dispatch board |
| [`ver_o_peso_mailer.ex`](ver_o_peso_mailer.ex) | Guarded deliver |
| [`ver_o_peso_mailer_live_test.exs`](ver_o_peso_mailer_live_test.exs) | Deliver and hold paths |

**Try it**

```sh
mix phx.server
```

Open
[/features/22-mailers-with-swoosh/03-belem-ver-o-peso-mailer](http://localhost:4000/features/22-mailers-with-swoosh/03-belem-ver-o-peso-mailer).

```sh
mix test features/22-mailers-with-swoosh/03-belem-ver-o-peso-mailer/ver_o_peso_mailer_live_test.exs
```
