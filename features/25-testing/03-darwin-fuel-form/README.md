# Testing · 03 · Darwin fuel form

Clerk Jedda posts a Cessna Caravan fuel slip at Darwin. LiveViewTest builds
the slip with `form/3`, validates with `render_change/1`, and posts with
`render_submit/1`.

**What it teaches**

- `form(view, "#fuel-slip-form", fuel_slip: %{...})` nests params under the
  schema name.
- `render_change/1` fires `phx-change` and surfaces changeset errors.
- `render_submit/1` fires `phx-submit` and asserts the posted slip id.
- An embedded schema is enough; no Repo write is required for the lesson.

**Files**

| File | Role |
| --- | --- |
| [`fuel_slip.ex`](fuel_slip.ex) | Embedded schema and changeset |
| [`fuel_form_live.ex`](fuel_form_live.ex) | Form LiveView |
| [`fuel_form_live_test.exs`](fuel_form_live_test.exs) | form/3, render_change, render_submit |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/03-darwin-fuel-form](http://localhost:4000/features/25-testing/03-darwin-fuel-form).
Try 5000 litres, then post 1800 on the south bay.

```sh
mix test features/25-testing/03-darwin-fuel-form/fuel_form_live_test.exs
```
