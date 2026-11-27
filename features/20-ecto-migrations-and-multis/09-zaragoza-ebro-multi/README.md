# Ecto migrations and multis · 09 · Zaragoza Ebro multi

Clerk Pilar files Airbus A330-200 drafts along the Ebro at Zaragoza.
`Enum.reduce/3` builds named `insert_draft` and `file_draft` steps.

**What it teaches**

- Named Multi steps assembled with `Enum.reduce/3`.
- `Multi.update/3` flips status after insert.
- `with` unpacks the transaction map by step name.

**Files**

| File | Role |
| --- | --- |
| [`ebro_draft.ex`](ebro_draft.ex) | Draft schema |
| [`ebro_desk.ex`](ebro_desk.ex) | Reduce-built Multi |
| [`ebro_multi_live.ex`](ebro_multi_live.ex) | Files the route |
| [`ebro_multi_live_test.exs`](ebro_multi_live_test.exs) | Named steps and filed status |

**Try it**

```sh
mix test features/20-ecto-migrations-and-multis/09-zaragoza-ebro-multi/ebro_multi_live_test.exs
```
