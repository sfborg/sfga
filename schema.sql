PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v1.2.6');
CREATE TABLE core (
	-- usually corresponds to taxonID term of Darwin Core
	"dwc_taxon_id" TEXT NOT NULL DEFAULT '',
	-- (GN) corresponds to some local id used in the data-source
	"local_id" TEXT NOT NULL DEFAULT '',
	-- (GN) corresponds to id used in data-source that was designed to be
	-- unique globally
	"global_id" TEXT NOT NULL DEFAULT '',
	-- (GN) UUID5 generated from the scientific name
	"dwc_scientific_name_id" TEXT NOT NULL DEFAULT '', 
	-- scientific name-string (with authorship if given)
	"dwc_scientific_name" TEXT NOT NULL DEFAULT '', 
	-- authorship of the name
	"dwc_scientific_name_authorship" TEXT NOT NULL DEFAULT '',
	-- year of publication of the name
	"dwc_name_published_in_year" INTEGER NOT NULL DEFAULT 0, 
	-- number of elements in the canonical form of the name
	"cardinality" INTEGER NOT NULL DEFAULT 0, 
	-- GN UUID5 generated from the canonical form of the name
	"canonical_id" TEXT NOT NULL DEFAULT '', 
	-- simplified canonical form of the name
	"canonical" TEXT NOT NULL DEFAULT '',
	-- GN UUID5 generated from the full canonical form of the name
	"canonical_full_id" TEXT NOT NULL DEFAULT '', 
	-- full canonical form of the name (with ranks and hybrid markers)
	"canonical_full" TEXT NOT NULL DEFAULT '',
	-- GN UUID5 generated from the stem of the stemmed canonical form of the name
	"canonical_stem_id" TEXT NOT NULL DEFAULT '',
	-- Stemmed canonical form of the name
	"canonical_stem" TEXT NOT NULL DEFAULT '',
	-- ID of the currently accepted name according to the data source
	"dwc_accepted_name_usage_id" TEXT NOT NULL DEFAULT '',
	-- breadcrumb of the name classification according to the data source
	"dwc_higher_classification" TEXT NOT NULL DEFAULT '',
	-- classification ids of the name according to the data source
	"higher_classification_ids" TEXT NOT NULL DEFAULT '',
	-- classification ranks of the name according to the data source
	"higher_classification_ranks" TEXT NOT NULL DEFAULT '',
	-- rank of the name according to the data source
	"dwc_taxon_rank" TEXT NOT NULL DEFAULT '',
	-- 1 if the name is a virus name
	"is_virus" TEXT NOT NULL DEFAULT '', 
	-- 1 if the name is a bacterial name
	"is_bacteria" TEXT NOT NULL DEFAULT '', 
	-- 1 if the name is not a "normal" scientific name
	"is_surrogate" TEXT NOT NULL DEFAULT '', 
	-- nomenclatural code of the name (ICBN, ICZN, ICN, etc.)
	"dwc_nomenclatural_code" TEXT NOT NULL DEFAULT '',
	-- 0 when name is not parseable, 1 for good quality parsing,
	-- 2 for parsing with some issues, 3 for parsing with many issues
	-- 4 for parsing with critical issues
	"parse_quality" INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_dwc_taxon_id ON core (dwc_taxon_id);

-- data_source supposed to have one record that shows information about
-- the creator of the dataset.
CREATE TABLE data_source ( 
	-- id is a global unique identifier of the data source
	"id" TEXT NOT NULL DEFAULT '', 
	-- gn_id is an id used by the Global Names project
	"gn_id" INTEGER NOT NULL DEFAULT 0,
	-- title of the data source
	"title" TEXT NOT NULL DEFAULT '', 
	-- short title of the data source
	"title_short" TEXT NOT NULL DEFAULT '', 
	-- version of the data source if given 
	"version" TEXT NOT NULL DEFAULT '', 
	-- revision date of the data source if given
	"revision_date" TEXT NOT NULL DEFAULT '', 
	-- DOI of the data source if given
	"doi" TEXT NOT NULL DEFAULT '', 
	-- citation of the data source
	"citation" TEXT NOT NULL DEFAULT '', 
	-- authors of the data source
	"authors" TEXT NOT NULL DEFAULT '', 
	-- description of the data source
	"description" TEXT NOT NULL DEFAULT '', 
	-- URL to the website that presents the data source
	"website_url" TEXT NOT NULL DEFAULT '', 
	-- URL used to download the data from the source
	"data_url" TEXT NOT NULL DEFAULT '', 
	-- the number of records in the data
	"record_count" INTEGER NOT NULL DEFAULT 0, 
	-- the data when this archive was created
	"updated_at" TEXT NOT NULL DEFAULT '' 
);
CREATE TABLE vernaculars ( 	"data_source_id" INTEGER NOT NULL DEFAULT 0, 
	-- record_id from the core table
	"dwc_taxon_id" TEXT NOT NULL DEFAULT '', 
	-- name_id is a gn uuid5 generated from the vernacular name
	"vernacular_name_id" TEXT NOT NULL DEFAULT '',
	-- vernacular name in utf-8 encoding
	"dwc_vernacular_name" TEXT NOT NULL DEFAULT '',
	-- verbatim language from the source
	"dcterms_language" TEXT NOT NULL DEFAULT '', 
	-- lang_code is the ISO 639-3 language code 
	"lang_code" TEXT NOT NULL DEFAULT '', 
	-- name of the language in English
	"lang_eng_name" TEXT NOT NULL DEFAULT '',
	-- locality is the place where the vernacular name was recorded
	"dwc_locality" TEXT NOT NULL DEFAULT '', 
	-- country_code is the ISO 3166-1 alpha-2 country code
	"dwc_country_code" TEXT NOT NULL DEFAULT ''
	);	
	CREATE INDEX idx_taxon_name ON vernaculars (dwc_taxon_id, vernacular_name_id);
COMMIT;

