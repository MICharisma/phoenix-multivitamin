# Ecto schemas and changesets · 02 · Nairobi bag tags

Clerk Wanjiku stamps bag tags onto a Kenya Airways Boeing 737-800 load at Jomo Kenyatta.

**What it teaches**

- `embeds_many/3` nests a list of bag tags on the load card.
- `cast_embed/3` validates every tag before the load stamps.

**Files**

| File | Role |
| --- | --- |
| [`bag_tag.ex`](bag_tag.ex) | Nested bag tag embed |
| [`load_card.ex`](load_card.ex) | Load card with embeds_many |
| [`bag_tags_live.ex`](bag_tags_live.ex) | inputs_for over the tags |
| [`bag_tags_live_test.exs`](bag_tags_live_test.exs) | Rejects overweight tags |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/02-nairobi-bag-tags/bag_tags_live_test.exs
```
