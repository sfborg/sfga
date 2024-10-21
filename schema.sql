PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v0.3.6');

-- Metadata start

CREATE TABLE metadata (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   doi TEXT,
   title TEXT,
   alias TEXT,
   description TEXT,
   issued TEXT,
   version TEXT,
   keywords TEXT,
   geographic_scope TEXT,
   taxonomic_scope TEXT,
   temporal_scope TEXT,
   confidence INTEGER,
   completeness INTEGER,
   license TEXT,
   url TEXT,
   logo TEXT,
   label TEXT,
   citation TEXT,
   private INTEGER
);

CREATE TABLE contact (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   metadata_id INTEGER,
   orcid TEXT,
   given TEXT,
   family TEXT,
   rorid TEXT,
   name TEXT,
   email TEXT,
   url TEXT,
   note TEXT 
);

CREATE TABLE editor (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   metadata_id INTEGER,
   orcid TEXT,
   given TEXT,
   family TEXT,
   rorid TEXT,
   name TEXT,
   email TEXT,
   url TEXT,
   note TEXT
);

CREATE TABLE creator (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   metadata_id INTEGER,
   orcid TEXT,
   given TEXT,
   family TEXT,
   rorid TEXT,
   name TEXT,
   email TEXT,
   url TEXT,
   note TEXT
);

CREATE TABLE publisher (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   metadata_id INTEGER,
   orcid TEXT,
   given TEXT,
   family TEXT,
   rorid TEXT,
   name TEXT,
   email TEXT,
   url TEXT,
   note TEXT
);

CREATE TABLE contributor (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   metadata_id INTEGER,
   orcid TEXT,
   given TEXT,
   family TEXT,
   rorid TEXT,
   name TEXT,
   email TEXT,
   url TEXT,
   note TEXT
);

CREATE TABLE source (
  id TEXT,
  metadata_id INTEGER,
  type TEXT, 
  title TEXT, 
  authors TEXT,
  issued TEXT,
  isbn TEXT 
);

-- Metadata end

CREATE TABLE taxon (
   id TEXT,
   name_id TEXT,
   parent_id TEXT,
   according_to_id TEXT,
   scrutinizer TEXT,
   scrutinizer_id TEXT,
   scrutinizer_date TEXT,
   reference_id TEXT,
   link TEXT
);
CREATE INDEX idx_taxon_id ON taxon (id);

CREATE TABLE reference (
   id TEXT,
   citation TEXT,
   link TEXT,
   doi TEXT,
   remarks TEXT
);
CREATE INDEX idx_reference_id ON reference (id);

CREATE TABLE name (
   id TEXT,
   alternative_id TEXT,
   basionym_id TEXT,
   scientific_name TEXT,
   authorship TEXT,
   rank TEXT,
   uninomial TEXT,
   genus TEXT,
   infrageneric_epithet TEXT,
   specific_epithet TEXT,
   infraspecific_epithet TEXT,
   -- code is nomenclatural code, it corresponds to IDs from nomcode.
   code INTEGER,
   referenceID TEXT,
   publishedInYear TEXT,
   link TEXT
);
CREATE INDEX idx_name_id ON name (id);

CREATE TABLE synonym (
   id TEXT,
   taxon_id TEXT,
   name_id TEXT,
   according_to_id TEXT,
   reference_id TEXT,
   link TEXT
);
CREATE INDEX idx_synonym_id ON synonym (id);

CREATE TABLE vernacular (
   taxon_id TEXT,
   name TEXT,
   transliteration TEXT,
   language TEXT,
   preferred INTEGER,
   country TEXT,
   area TEXT,
   sex TEXT,
   reference_id TEXT,
   remarks TEXT,
   modified TEXT,
   modified_by TEXT
);
CREATE INDEX idx_vernacular_id ON vernacular (taxon_id);

CREATE TABLE nomcode (
   id INTEGER,
   value TEXT
);
INSERT INTO nomcode (id, value) VALUES
  (1, 'BACTERIAL'),
  (2, 'BOTANICAL'),
  (3, 'CULTIVARS'),
  (4, 'PHYTOSOCIOLOGICAL'),
  (5, 'VIRUS'),
  (6, 'ZOOLOGICAL');

CREATE TABLE gender (
   id INTEGER,
   value TEXT
);
INSERT INTO gender (id, value) VALUES
  (1, 'MASCULINE'),
  (2, 'FEMININE'),
  (3, 'NEUTRAL');

CREATE TABLE name_status (
   id INTEGER,
   value TEXT
);
INSERT INTO name_status (id, value) VALUES
	(1, 'Established'),
	(1, 'Acceptable'),
	(1, 'Unacceptable'),
	(1, 'CoervedNS'),
	(1, 'Rejected'),
	(1, 'Doubtful'),
	(1, 'Manuscript'),
	(1, 'Chresonym');

COMMIT;
