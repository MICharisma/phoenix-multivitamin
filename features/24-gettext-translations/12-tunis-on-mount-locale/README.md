# Gettext translations · 12 · Tunis on_mount locale

Clerk Amira opens the Tunisair pushback brief at Tunis–Carthage.
`on_mount` reads the session locale and calls `Gettext.put_locale/2` before
`mount/3` paints the line.

**What it teaches**

- LiveView `on_mount` can set the Gettext locale from the session.
- `on_mount` runs in both the disconnected and connected processes.
- Missing session locale keeps the French default.

**Files**

| File | Role |
| --- | --- |
| [`on_mount_locale_live.ex`](on_mount_locale_live.ex) | LiveView that declares `on_mount` |
| [`on_mount_locale.ex`](on_mount_locale.ex) | Hook that puts locale from session |
| [`tunis_gettext.ex`](tunis_gettext.ex) | French/Arabic example-local backend |
| [`on_mount_locale_live_test.exs`](on_mount_locale_live_test.exs) | Asserts fr default and ar session |

**Try it**

```sh
mix test features/24-gettext-translations/12-tunis-on-mount-locale/on_mount_locale_live_test.exs
```
