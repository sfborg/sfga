# sfga

Provides schema for Species File Archive format.

## Usage

To import latest

```bash
git clone git@github.com/sfborg/sfga
cd sfga
cp schema.db dest/schema.sqlite
```

To import a particular tag

```bash
git clone -b v1.0.0 git@github.com/sfborg/sfga
cd sfga
cp schema.db dest/schema.sqlite
```

To convert sql file to database

```bash
# (REMEMBER to change version.id value)
# it will create schema.sqlite and restore database to it.
rm schema.sqlite && sqlite3 schema.sqlite '.read schema.sql' && echo "DID YOU CHANGE VERSION in schema.sql??"
```

To get shasum

```bash
shasum -a 256 schema.sql
```

## Tags

When creating new tags use semantic versioning ideas:

- incompatible change: increment major number

- backward compatible change: increment minor number

- change in indices etc: increment bug number

However while the schema is in development with versions v0.x.x, increments
are not regulated, for example it is ok to make breaking change and
increment bug number (e.g., v0.2.3 -> v0.2.4).
