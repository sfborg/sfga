# sfga

Provides schema for Species File Archive format.

# Usage

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

````bash
# (REMEMBER to change version.id value)
# it will create schema.sqlite and restore database to it.
rm schema.sqlite && sqlite3 schema.sqlite '.read schema.sql' && echo "DID YOU CHANGE VERSION in schema.sql??"
```

To dump database to a sql file

```bash
sqlite3 schema.sqlite
> // do you things
> .ouput shema.sql
> .dump
````

# Tags

When creating new tags use semantic versioning ideas:

incompatible change: increment major number

backward compatible change: increment minor number

change in indices etc: increment bug number
