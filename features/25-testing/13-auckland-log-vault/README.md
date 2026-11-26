# Testing · 13 · Auckland log vault

Clerk Mere archives Waitematā METARs for an A320. The METAR client is a
behaviour swapped through application config — no Mox. Tests write under
`@tag :tmp_dir` and lock warnings with `ExUnit.CaptureLog`.

**What it teaches**

- `Application.get_env/3` picks the behaviour implementation.
- `AucklandMetarClient.Fake` is a real `@behaviour` module used only in test.
- `@tag :tmp_dir` injects a fresh directory into the test context.
- `capture_log/1` asserts Logger output for the refused station.

**Files**

| File | Role |
| --- | --- |
| [`metar_client.ex`](metar_client.ex) | Behaviour and Application lookup |
| [`metar_client_http.ex`](metar_client_http.ex) | Default offline HTTP stub |
| [`metar_client_fake.ex`](metar_client_fake.ex) | Fake used from `config/test.exs` |
| [`log_vault.ex`](log_vault.ex) | Archive + Logger |
| [`log_vault_live.ex`](log_vault_live.ex) | Catalog LiveView |
| [`log_vault_test.exs`](log_vault_test.exs) | Fake, CaptureLog, tmp_dir |
| [`log_vault_live_test.exs`](log_vault_live_test.exs) | Click archives NZAA |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/13-auckland-log-vault](http://localhost:4000/features/25-testing/13-auckland-log-vault).
Archive NZAA (tests put the Fake client in config).

```sh
mix test features/25-testing/13-auckland-log-vault/
```
