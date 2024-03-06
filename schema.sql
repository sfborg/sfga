PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v1.0.0');
CREATE TABLE name_strings ( 	"id" TEXT, 
	"name" TEXT, 
	"year" INTEGER, 
	"cardinality" INTEGER, 
	"canonical_id" TEXT, 
	"canonical_full_id" TEXT, 
	"canonical_stem_id" TEXT, 
	"virus" TEXT, 
	"bacteria" TEXT, 
	"surrogate" TEXT, 
	"parse_quality" INTEGER, 
	PRIMARY KEY (id) );
CREATE TABLE name_string_indices ( 	"data_source_id" INTEGER, 
	"record_id" TEXT, 
	"name_string_id" TEXT, 
	"outlink_id" TEXT, 
	"global_id" TEXT, 
	"local_id" TEXT, 
	"code_id" INTEGER, 
	"rank" TEXT, 
	"accepted_record_id" TEXT, 
	"classification" TEXT, 
	"classification_ids" TEXT, 
	"classification_ranks" TEXT, 
	PRIMARY KEY (data_source_id, record_id, name_string_id) );
CREATE TABLE data_sources ( 	"id" INTEGER, 
	"uuid" TEXT, 
	"title" TEXT, 
	"title_short" TEXT, 
	"version" TEXT, 
	"revision_date" TEXT, 
	"doi" TEXT, 
	"citation" TEXT, 
	"authors" TEXT, 
	"description" TEXT, 
	"website_url" TEXT, 
	"data_url" TEXT, 
	"outlink_url" TEXT, 
	"is_outlink_ready" TEXT, 
	"is_curated" TEXT, 
	"is_auto_curated" TEXT, 
	"record_count" INTEGER, 
	"updated_at" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE canonicals ( 	"id" TEXT, 
	"name" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE canonical_stems ( 	"id" TEXT, 
	"name" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE canonical_fulls ( 	"id" TEXT, 
	"name" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE vernacular_strings ( 	"id" TEXT, 
	"name" TEXT, 
	PRIMARY KEY (id) );
CREATE TABLE vernacular_string_indices ( 	"data_source_id" INTEGER, 
	"record_id" TEXT, 
	"vernacular_string_id" TEXT, 
	"language" TEXT, 
	"lang_code" TEXT, 
	"locality" TEXT, 
	"country_code" TEXT, 
	PRIMARY KEY (data_source_id, record_id, vernacular_string_id) );
COMMIT;

