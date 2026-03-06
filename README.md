# sfga

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18890275.svg)](https://doi.org/10.5281/zenodo.18890275)

Provides schema for Species File Group Archive (SFGA) format.

## Introduction

Biodiversity checklists and taxonomic datasets are exchanged today through
formats such as [Darwin Core Archive (DwCA)][dwca] and the
[Catalogue of Life Data Package (ColDP)][coldp]. These formats bundle multiple
CSV, JSON, or XML files into a single compressed archive. While widely adopted,
this approach has a fundamental limitation: the data is effectively inert until
a recipient imports it into a database. Generating an archive is error-prone,
and inconsistencies introduced during export can create significant problems on
the receiving end. There is also no standard mechanism to detect what has
changed between two successive releases of the same dataset.

**SFGA (Species File Group Archive)** addresses these problems by using
[SQLite][sqlite] as the archive format. An SFGA file is a self-contained
SQLite database — recipients can query and modify data immediately using
standard SQL tools, with no import step required. Because SQLite databases are
single files, they are easy to copy, version, and distribute alongside existing
workflows.

SFGA table structure is a superset of [CoLDP][coldp], and is heavily based on
CoLDP file structure and fields. The SFGA format is still experimental and
might have backward incompatible changes until it reaches v1.0.0.

The SFGA schema is the foundation of the **SFBorg** ecosystem, a suite of
open-source tools built around this format:

- **[SF]** — a universal converter between DwCA, ColDP, and SFGA, with
  built-in diff support to identify added, modified, or removed taxa, names,
  and synonyms between two archive versions.
- **[Harvester]** — ingests non-standard or legacy sources into SFGA.
- **[GNdb]** — loads SFGA archives directly into the GNverifier PostgreSQL
  database.
- **[SFlib]** — a shared Go library that centralises SFGA read/write,
  normalisation, and diff logic for all tools.

This repository contains the canonical SFGA schema definition (`schema.sql`)
and a pre-built `schema.db` SQLite file ready to copy and use.

### Schema overview

The schema includes tables for:

- **taxa** — accepted taxa information 
- **names** — information about scientific names, usually connected to taxa
- **references** — bibliographic sources
- **distributions** — geographic occurrence data
- **vernacular_names** — common names per taxon
- **metadata** — dataset-level provenance and version information

## Usage

### Using the schema in your project

`schema.db` is an empty SQLite database with the full SFGA schema applied,
ready to be populated with data. Copy it to your project:

```bash
git clone git@github.com:sfborg/sfga
cp sfga/schema.db dest/schema.sqlite
```

To pin to a specific version (replace `vX.Y.Z` with the desired tag):

```bash
git clone -b vX.Y.Z git@github.com:sfborg/sfga
cp sfga/schema.db dest/schema.sqlite
```

### For maintainers

**Versioning:** when creating new tags follow semantic versioning:

- incompatible change: increment major number
- backward compatible change: increment minor number
- index/performance-only change: increment patch number

While the schema is pre-v1.0.0, breaking changes may appear in any release.

**Rebuilding `schema.db` from `schema.sql`:**

Update the `version.id` value in `schema.sql` first, then run:

```bash
rm -f schema.db && sqlite3 schema.db '.read schema.sql' && \
  echo "Built schema.db — version: $(sqlite3 schema.db 'SELECT id FROM version')"
```

**Verifying schema integrity:**

```bash
shasum -a 256 schema.sql
```

This hash is used in [SFlib] to ensure that the right version of the schema is
uploaded.

**Bug reports and contributions:** use the [issue tracker] on GitHub.

## Authors

* [Dmitry Mozzherin]
* [Geoffrey Ower]

## License

Released under [MIT license]

[dwca]: https://dwc.tdwg.org/text/
[coldp]: https://github.com/CatalogueOfLife/coldp
[sqlite]: https://www.sqlite.org/
[SF]: https://github.com/sfborg/sf
[Harvester]: https://github.com/sfborg/harvester
[GNdb]: https://github.com/sfborg/gndb
[SFlib]: https://github.com/sfborg/sflib
[Dmitry Mozzherin]: https://github.com/dimus
[Geoffrey Ower]: https://github.com/gdower
[MIT license]: LICENSE
[issue tracker]: https://github.com/sfborg/sfga/issues
