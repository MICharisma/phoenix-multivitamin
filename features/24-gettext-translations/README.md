# Gettext translations

gettext, ngettext, dgettext, pgettext, locales, domains, and extracted
messages for copy that a watch actually speaks.

Official reference: [Gettext translations](https://hexdocs.pm/gettext/Gettext.html)

## Examples (13 of 13 bottled)

01. [Reykjavík hold-short](01-reykjavik-hold-short/) — available
02. [Warsaw LOT apron](02-warsaw-lot-apron/) — available
03. [Casablanca RAM domain](03-casablanca-ram-domain/) — available
04. [Dubai Emirates context](04-dubai-emirates-context/) — available
05. [Lyon Accept-Language](05-lyon-accept-language/) — available
06. [São Paulo put_locale](06-sao-paulo-put-locale/) — available
07. [Oslo extract hangar](07-oslo-extract-hangar/) — available
08. [Moscow Sheremetyevo plurals](08-moscow-sheremetyevo-plurals/) — available
09. [Cairo EgyptAir bindings](09-cairo-egyptair-bindings/) — available
10. [Riyadh with_locale](10-riyadh-with-locale/) — available
11. [Kraków fallback msgid](11-krakow-fallback-msgid/) — available
12. [Tunis on_mount locale](12-tunis-on-mount-locale/) — available
13. [Doha Hamad capstone](13-doha-hamad-capstone/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | `gettext/1` on a button the clerk presses |
| 02 | Polish `ngettext/3` with three plural forms |
| 03 | `dgettext/2` in a `gates` domain other than default |
| 04 | `pgettext/2` disambiguating gate vs stand "open" |
| 05 | A locale plug that reads Accept-Language |
| 06 | `Gettext.put_locale/2` in LiveView `handle_params/3` |
| 07 | `mix gettext.extract --merge` with `.pot` and `.po` |
| 08 | Russian plural forms including the teen rule |
| 09 | Interpolated `%{flight}` / `%{stand}` bindings |
| 10 | `Gettext.with_locale/3` restore and nesting |
| 11 | Missing translation falling back to the msgid |
| 12 | LiveView `on_mount` locale from the session |
| 13 | Capstone: params/session/Accept-Language plug, Arabic plurals, domains, Ecto errors |

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a slot in another feature.
