# Ecto schemas and changesets · 12 · Mahé NOTAM draft

Clerk Liz files an Air Seychelles De Havilland DHC-6 NOTAM draft at Mahé International.

**What it teaches**

- Schemaless changesets: `{%{}, types}` plus `cast/4` with no schema module.
- `apply_action/2` returns a plain map, not a struct.

**Files**

| File | Role |
| --- | --- |
| [`notam_draft.ex`](notam_draft.ex) | Schemaless changeset helper |
| [`notam_draft_live.ex`](notam_draft_live.ex) | Draft form |
| [`notam_draft_live_test.exs`](notam_draft_live_test.exs) | Files a map draft |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/12-mahe-notam-draft/notam_draft_live_test.exs
```
