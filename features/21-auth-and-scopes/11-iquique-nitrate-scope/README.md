# Auth and scopes · 11 · Iquique nitrate scope

Clerk Valentina posts on the nitrate-era hangar board at Iquique (IQQ) for a Basler BT-67. Notes and station logout ride the scoped PubSub topic `iquique:IQQ:nitrate`.

**What it teaches**

- Scoped PubSub topics + logout broadcast
- Subscribe on the connected mount
- Event `"post_nitrate_note"` broadcasts a note on the station topic
- Event `"sign_out_station"` broadcasts `{:nitrate_logout, station_id}`; `handle_info` clears the scope

**Files**

| File | Role |
| --- | --- |
| [`nitrate_scope.ex`](nitrate_scope.ex) | Scope with `station_id` |
| [`nitrate_boards.ex`](nitrate_boards.ex) | Topic, subscribe, and broadcast helpers |
| [`nitrate_scope_live.ex`](nitrate_scope_live.ex) | LiveView subscribe, post, logout |
| [`nitrate_scope_live_test.exs`](nitrate_scope_live_test.exs) | Note broadcast and logout handle_info |

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/21-auth-and-scopes/11-iquique-nitrate-scope](http://localhost:4000/features/21-auth-and-scopes/11-iquique-nitrate-scope).

```sh
mix test features/21-auth-and-scopes/11-iquique-nitrate-scope
```
