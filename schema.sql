PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v0.3.8');

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
  id TEXT PRIMARY KEY,
  metadata_id INTEGER,
  type TEXT, 
  title TEXT, 
  authors TEXT,
  issued TEXT,
  isbn TEXT 
);

-- Metadata end

CREATE TABLE taxon (
   id TEXT PRIMARY KEY,
   alternative_id TEXT,
   source_id TEXT,
   parent_id TEXT,
   ordinal TEXT,
   branch_length INTEGER,
   name_id TEXT,
   name_phrase TEXT,
   according_to_id TEXT,
   according_to_page TEXT,
   according_to_page_link TEXT,
   scrutinizer TEXT,
   scrutinizer_id TEXT,
   scrutinizer_date TEXT,
   provisional INTEGER,
   reference_id TEXT,
   extinct INTEGER,
   temporal_range_start INTEGER,
   temporal_range_end INTEGER,
   environment TEXT,
   species TEXT,
   section TEXT,
   subgenus TEXT,
   subtribe TEXT,
   tribe TEXT,
   subfamily TEXT,
   family TEXT,
   supberfamily TEXT,
   suborder TEXT,
   ordr TEXT,
   subclass TEXT,
   class TEXT,
   subphylum TEXT,
   phylum TEXT,
   kingdom TEXT,
   link TEXT,
   remarks TEXT,
   modified TEXT,
   modified_by TEXT
);

CREATE TABLE reference (
   -- id is a local id used as reference_id in other tables
   id TEXT PRIMARY KEY,
   -- alternative_id is a list of other ids with comma as separator
   alternative_id TEXT,
   -- source_id from metadata
   source_id TEXT,
   -- citation from bibliography
   citation TEXT,
   -- type according to JSON CSL types
   type TEXT,
   -- author/s in format of either
   -- amily1, given1; family2, given2; ..
   -- or
   -- given1 family1, given2 family2, ...
   author TEXT,
   -- author_ids separated by comma
   author_id TEXT,
   -- editor/s of the work (same format as for authors)
   editor TEXT,
   -- editor_id/s separated by comma
   editor_id TEXT,
   -- title of the work
   title TEXT,
   -- title_short of the work
   title_short TEXT,
   -- container_author is an author or a parent volume (book, journal) 
   container_author TEXT,
   -- container_title of the parent container
   container_title TEXT,
   -- container_title_short of the parent container
   container_title_short TEXT,
   -- date when reference was issued
   issued TEXT,
   -- date when the reference was accessed
   accessed TEXT,
   -- collection_title of the parent volume
   collection_title TEXT,
   -- collection_editor of the parent volume
   collection_editor TEXT,
   -- volume number of the reference
   volume TEXT,
   -- issue number of the reference
   issue TEXT,
   -- edition number
   edition TEXT,
   -- page number
   page TEXT,
   -- publisher name
   publisher TEXT,
   -- publisher_place
   publisher_place TEXT,
   -- verion of the reference
   version TEXT,
   -- isbn ID
   isbn TEXT,
   -- issn ID
   issn TEXT,
   -- doi
   doi TEXT,
   -- link (URL) to the reference
   link TEXT,
   -- remarks or notes about the reference
   remarks TEXT
);

CREATE TABLE name (
   id TEXT PRIMARY KEY,
   alternative_id TEXT,
   source_id TEXT,
   basionym_id TEXT,
   scientific_name TEXT,
   authorship TEXT,
   rank TEXT,
   uninomial TEXT,
   genus TEXT,
   infrageneric_epithet TEXT,
   specific_epithet TEXT,
   infraspecific_epithet TEXT,
   cultivar_epithet TEXT,
   notho INTEGER,
   -- original_spelling bool
   original_spelling INTEGER,
   combination_authorship TEXT,
   combination_authorship_id TEXT,
   combination_ex_authorship TEXT,
   combination_ex_authorship_id TEXT,
   combination_authorship_year TEXT,
   basionym_authorship TEXT,
   basionym_authorship_id TEXT,
   basionym_ex_authorship TEXT,
   basionym_ex_authorship_id TEXT,
   basionym_authorship_year TEXT,
   -- code is nomenclatural code, it corresponds to IDs from nomcode.
   code INTEGER,
   -- status is enumeration of name statuses
   status INTEGER,
   reference_id TEXT,
   published_in_year TEXT,
   published_in_page TEXT,
   published_in_page_link TEXT,
   gender INTEGER,
   -- gender_agreement bool
   gender_agreement INTEGER,
   etymology TEXT,
   link TEXT,
   remarks TEXT,
   modified TEXT,
   modified_by TEXT
);


CREATE TABLE name_relation (
  name_id TEXT NOT NULL,
  related_name_id TEXT,
  source_id TEXT,
  type TEXT NOT NULL,
  reference_id TEXT,
  remarks TEXT
);

CREATE TABLE synonym (
   id TEXT PRIMARY KEY,
   taxon_id TEXT,
   source_id TEXT,
   name_id TEXT,
   name_phrase TEXT,
   according_to_id TEXT,
   status INTEGER,
   reference_id TEXT,
   link TEXT,
   remarks TEXT,
   modified TEXT,
   modified_by TEXT
);

CREATE TABLE vernacular (
   taxon_id TEXT,
   source_id TEXT,
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

CREATE TABLE type_material (
  id TEXT PRIMARY KEY,
  source_id TEXT,
  name_id TEXT NOT NULL,
  citation TEXT,
  status TEXT,
  institution_code TEXT,
  catalog_number TEXT,
  reference_id TEXT,
  locality TEXT,
  country TEXT,
  latitude REAL,
  longitude REAL,
  altitude INTEGER,
  host TEXT,
  sex TEXT,
  date TEXT,
  collector TEXT,
  associated_sequences TEXT,
  link TEXT,
  remarks TEXT
);

CREATE TABLE distribution (
  taxon_id TEXT NOT NULL,
  source_id TEXT,
  area TEXT NOT NULL,
  area_id TEXT,
  gazetteer TEXT,
  status TEXT,
  reference_id TEXT,
  remarks TEXT
);

CREATE TABLE media (
  taxon_id TEXT NOT NULL REFERENCES name_usage,
  source_id TEXT,
  url TEXT NOT NULL,
  type TEXT,
  format TEXT,
  title TEXT,
  created TEXT,
  creator TEXT,
  license TEXT,
  link TEXT,
  remarks TEXT  
);

CREATE TABLE treatment (
  taxon_id TEXT NOT NULL,
  source_id TEXT,
  document TEXT NOT NULL,
  format TEXT
);

CREATE TABLE species_estimate (
  taxon_id TEXT NOT NULL,
  source_id TEXT,
  estimate INTEGER NOT NULL,
  type TEXT NOT NULL,
  reference_id TEXT,
  remarks TEXT
);

CREATE TABLE taxon_property (
  taxon_id TEXT NOT NULL,
  source_id TEXT,
  property TEXT NOT NULL,
  value TEXT NOT NULL,
  reference_id TEXT,
  page TEXT,
  ordinal INTEGER,
  remarks TEXT
);

CREATE TABLE species_interaction (
  taxon_id TEXT NOT NULL,
  related_taxon_id TEXT,
  source_id TEXT,
  related_taxon_scientific_name TEXT,
  type TEXT NOT NULL,
  reference_id TEXT,
  remarks TEXT
);

CREATE TABLE taxon_concept_relation (
  taxon_id TEXT NOT NULL,
  related_taxon_id TEXT,
  source_id TEXT,
  type TEXT NOT NULL,
  reference_id TEXT,
  remarks TEXT
);

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
