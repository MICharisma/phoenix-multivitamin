# Ecto schemas and changesets

schema, field, embeds, associations, and changesets that cast, validate, and refuse a card that is not ready to write.

Official reference: [Ecto schemas and changesets](https://hexdocs.pm/ecto/Ecto.Schema.html)

## Examples (13 of 13 bottled)

01. [Addis Ababa gate plate](01-addis-ababa-gate-plate/) — available
02. [Nairobi bag tags](02-nairobi-bag-tags/) — available
03. [Dar es Salaam cargo bay](03-dar-es-salaam-cargo-bay/) — available
04. [Entebbe station watches](04-entebbe-station-watches/) — available
05. [Lusaka hold remaining](05-lusaka-hold-remaining/) — available
06. [Windhoek friction code](06-windhoek-friction-code/) — available
07. [Cape Town duty enum](07-cape-town-duty-enum/) — available
08. [Johannesburg turnaround crew](08-johannesburg-turnaround-crew/) — available
09. [Maputo callsign validate](09-maputo-callsign-validate/) — available
10. [Antananarivo designator](10-antananarivo-designator/) — available
11. [Mauritius fuel prepare](11-mauritius-fuel-prepare/) — available
12. [Mahé NOTAM draft](12-mahe-notam-draft/) — available
13. [Réunion credential card](13-reunion-credential-card/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | `embedded_schema/1` with typed fields and no table |
| 02 | `embeds_many/3` and `cast_embed/3` for bag tags |
| 03 | `embeds_one/3` with a balanced cargo bay |
| 04 | `belongs_to/3` and `has_many/3` on a station and its watches |
| 05 | Virtual fields that survive insert and vanish on reload |
| 06 | A custom `Ecto.Type` for runway friction codes |
| 07 | `Ecto.Enum` for duty status |
| 08 | `cast_assoc/3` for nested crew legs |
| 09 | `validate_change/3` with an ICAO callsign check |
| 10 | `unique_constraint/3` after a race at Ivato |
| 11 | `prepare_changes/2` converting gallons to litres |
| 12 | Schemaless changesets that return a map |
| 13 | Capstone: `change/2` versus `cast/3`, plus `redact: true` |
