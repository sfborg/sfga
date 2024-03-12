PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v1.1.2');
CREATE TABLE core (
	-- usually corresponds to taxonID term of Darwin Core
	"record_id" TEXT,
	-- GN UUID5 generated from the scientific name
	"name_id" TEXT, 
	-- scientific name-string (with authorship if given)
	"name" TEXT, 
	-- authorship of the name
	"authorship" TEXT,
	-- year of publication of the name
	"year" INTEGER, 
	-- number of elements in the canonical form of the name
	"cardinality" INTEGER, 
	-- GN UUID5 generated from the canonical form of the name
	"canonical_id" TEXT, 
	-- simplified canonical form of the name
	"canonical" TEXT,
	-- GN UUID5 generated from the full canonical form of the name
	"canonical_full_id" TEXT, 
	-- full canonical form of the name (with ranks and hybrid markers)
	"canonical_full" TEXT,
	-- GN UUID5 generated from the stem of the stemmed canonical form of the name
	"canonical_stem_id" TEXT, 
	-- Stemmed canonical form of the name
	"canonical_stem" TEXT,
	-- ID of the currently accepted name according to the data source
	"accepted_record_id" TEXT,
	-- breadcrumb of the name classification according to the data source
	"classification" TEXT,
	-- classification ids of the name according to the data source
	"classification_ids" TEXT,
	-- classification ranks of the name according to the data source
	"classification_ranks" TEXT,
	-- rank of the name according to the data source
	"rank" TEXT,
	-- 1 if the name is a virus name
	"is_virus" TEXT, 
	-- 1 if the name is a bacterial name
	"is_bacteria" TEXT, 
	-- 1 if the name is not a "normal" scientific name
	"is_surrogate" TEXT, 
	-- nomenclatural code of the name (ICBN, ICZN, ICN, etc.)
	"nomen_code" TEXT,
	-- 0 when name is not parseable, 1 for good quality parsing,
  -- 2 for parsing with some issues, 3 for parsing with many issues
  -- 4 for parsing with critical issues
	"parse_quality" INTEGER, 
	PRIMARY KEY (record_id) );
CREATE TABLE data_sources ( 
	-- id is a global unique identifier of the data source
	"id" TEXT, 
	-- gn_id is an id used by the Global Names project
	"gn_id" INTEGER,
	-- title of the data source
	"title" TEXT, 
	-- short title of the data source
	"title_short" TEXT, 
	-- version of the data source if given 
	"version" TEXT, 
	-- revision date of the data source if given
	"revision_date" TEXT, 
	-- DOI of the data source if given
	"doi" TEXT, 
	-- citation of the data source
	"citation" TEXT, 
	-- authors of the data source
	"authors" TEXT, 
	-- description of the data source
	"description" TEXT, 
	-- URL to the website that presents the data source
	"website_url" TEXT, 
	-- URL used to download the data from the source
	"data_url" TEXT, 
	-- the number of records in the data
	"record_count" INTEGER, 
	-- the data when this archive was created
	"updated_at" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE vernaculars ( 	"data_source_id" INTEGER, 
	-- record_id from the core table
	"record_id" TEXT, 
	-- name_id is a gn uuid5 generated from the vernacular name
	"name_id" TEXT,
	-- vernacular name in utf-8 encoding
	"name" TEXT,
	-- verbatim language from the source
	"language" TEXT, 
	-- lang_code is the ISO 639-3 language code 
	"lang_code" TEXT, 
	-- locality is the place where the vernacular name was recorded
	"locality" TEXT, 
	-- country_code is the ISO 3166-1 alpha-2 country code
	"country_code" TEXT, 
	PRIMARY KEY (record_id, name_id) );
COMMIT;

