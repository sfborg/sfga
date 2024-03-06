# sfgma
 
Provides intermediate schema to convert from one format to another.

# Usage

To import latest

```bash
git clone git@github.com/sfborg/sfgma
cd sfgma
cp schema.db dest/schema.db
```

To import a particular tag

```bash
git clone -b v1.0.0 git@github.com/sfborg/sfgma
cd sfgma
cp schema.db dest/schema.db
```

To update schema and also create text-ony sql file

```bash
sqlite3 schema.db
> // do you things
> .ouput shema.sql
> .dump
```

# Tags

When creating new tags use semantic versioning ideas:

incompatible change: increment major number

backward compatible change: increment minor number

change in indices etc: increment bug number
