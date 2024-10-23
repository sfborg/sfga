PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id);
INSERT INTO version VALUES('v0.3.9');

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
   -- use nom_rel_type instead
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
   -- authors separated by '|'
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

CREATE TABLE author (
   id TEXT PRIMARY KEY,
   source_id TEXT,
   -- comma-separated
   alternative_id TEXT,
   given TEXT,
   family TEXT,
   -- f. for filius,  jr, etc
   suffix TEXT,
   abbreviation_botany TEXT,
   -- separated by '|'
   alternative_names TEXT,
   -- biological sex
   sex INTEGER,
   country TEXT,
   birth TEXT,
   birth_place TEXT,
   death TEXT,
   affiliation TEXT,
   interest TEXT,
   reference_id TEXT,
   -- url
   link TEXT,
   remarks TEXT,
   modified TEXT,
   modified_by TEXT
);

CREATE TABLE name_relation (
   name_id TEXT NOT NULL,
   related_name_id TEXT,
   source_id TEXT,
   -- nom_rel_type enum
   type INTEGER NOT NULL,
   -- starting page number for the nomenclatural event
   page TEXT,
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

CREATE TABLE nom_code (
   id INTEGER,
   value TEXT
);
INSERT INTO nom_code (id, value) VALUES
   (1, 'Bacterial'),
   (2, 'Botanical'),
   (3, 'Cultivars'),
   (4, 'Phytosociological'),
   (5, 'Virus'),
   (6, 'Zoological');

CREATE TABLE gender (
   id INTEGER,
   value TEXT
);
INSERT INTO gender (id, value) VALUES
   (1, 'Masculine'),
   (2, 'Feminine'),
   (3, 'Neutral');


CREATE TABLE sex (
   id INTEGER,
   value TEXT
);
INSERT INTO sex (id, value) VALUES
  (1, 'Female'),
  (2, 'Male'),
  (3, 'Hermaphrodite');

CREATE TABLE nom_rel_type (
   id INTEGER,
   value TEXT
);
INSERT INTO nom_rel_type (id, value) VALUES
  (1, 'SpellingCorrection'),
  (2, 'Basionym'),
  (3, 'BasedOn'),
  (4, 'ReplacementName'),
  (5, 'Conserved'),
  (6, 'LaterHomonym'),
  (7, 'Superfluous'),
  (8, 'Homotypic'),
  (9, 'Type');

CREATE TABLE nom_status (
   id INTEGER,
   value TEXT
);
INSERT INTO nom_status (id, value) VALUES
   (1, 'Established'),
   (2, 'Acceptable'),
   (3, 'Unacceptable'),
   (4, 'Conserved'),
   (5, 'Rejected'),
   (6, 'Doubtful'),
   (7, 'Manuscript'),
   (8, 'Chresonym');

CREATE TABLE rank (
   id INTEGER,
   value TEXT
);
INSERT INTO rank (id, value) VALUES
   (1, 'Aberration'),
   (2, 'Biovar'),
   (3, 'Chemoform'),
   (4, 'Chemovar'),
   (5, 'Class'),
   (6, 'Cohort'),
   (7, 'Convariety'),
   (8, 'Cultivar'),
   (9, 'CultivarGroup'),
   (10, 'Division'),
   (11, 'Domain'),
   (12, 'Epifamily'),
   (13, 'Falanx'),
   (14, 'Family'),
   (15, 'Form'),
   (16, 'FormaSpecialis'),
   (17, 'Genus'),
   (18, 'Gigaclass'),
   (19, 'Gigaorder'),
   (20, 'Grandfamily'),
   (21, 'Grandorder'),
   (22, 'Grex'),
   (23, 'Hypoorder'),
   (24, 'Infraclass'),
   (25, 'Infracohort'),
   (26, 'Infradivision'),
   (27, 'Infrafamily'),
   (28, 'InfragenericName'),
   (29, 'Infragenus'),
   (30, 'Infrakingdom'),
   (31, 'Infralegion'),
   (32, 'Infraorder'),
   (33, 'Infraphylum'),
   (34, 'InfraspecificName'),
   (35, 'InfrasubspecificName'),
   (36, 'Infratribe'),
   (37, 'Kingdom'),
   (38, 'Klepton'),
   (39, 'Legion'),
   (40, 'Lusus'),
   (41, 'Magnorder'),
   (42, 'Megaclass'),
   (43, 'Megacohort'),
   (44, 'Megafamily'),
   (45, 'Microphylum'),
   (46, 'Minorder'),
   (47, 'Mirorder'),
   (48, 'Morph'),
   (49, 'Morphovar'),
   (50, 'Mutatio'),
   (51, 'Nanophylum'),
   (52, 'Nanorder'),
   (53, 'Natio'),
   (54, 'Order'),
   (55, 'Other'),
   (56, 'Parvclass'),
   (57, 'Parvorder'),
   (58, 'Parvphylum'),
   (59, 'Pathovar'),
   (60, 'Phagovar'),
   (61, 'Phylum'),
   (62, 'Proles'),
   (63, 'Realm'),
   (64, 'Section'),
   (65, 'Series'),
   (66, 'Serovar'),
   (67, 'Species'),
   (68, 'SpeciesAggregate'),
   (69, 'Strain'),
   (70, 'Subclass'),
   (71, 'Subcohort'),
   (72, 'Subdivision'),
   (73, 'Subfamily'),
   (74, 'Subform'),
   (75, 'Subgenus'),
   (76, 'Subkingdom'),
   (77, 'Sublegion'),
   (78, 'Suborder'),
   (79, 'Subphylum'),
   (80, 'Subrealm'),
   (81, 'Subsection'),
   (82, 'Subseries'),
   (83, 'Subspecies'),
   (84, 'Subterclass'),
   (85, 'Subtribe'),
   (86, 'Subvariety'),
   (87, 'Superclass'),
   (88, 'Supercohort'),
   (89, 'Superdivision'),
   (90, 'Superdomain'),
   (91, 'Superfamily'),
   (92, 'Superform'),
   (93, 'Supergenus'),
   (94, 'Superkingdom'),
   (95, 'Superlegion'),
   (96, 'Superorder'),
   (97, 'Superphylum'),
   (98, 'Supersection'),
   (99, 'Superseries'),
   (100, 'Supertribe'),
   (101, 'Supervariety'),
   (102, 'SupragenericName'),
   (103, 'Tribe'),
   (104, 'Unranked'),
   (105, 'Variety');

CREATE TABLE geo_time (
   id INTEGER PRIMARY KEY,
   parent_id INTEGER,
   name TEXT,
   type TEXT,
   start REAL,
   end REAL
);
INSERT INTO geo_time (id, name, type, start, end, parent_id) VALUES
(1, 'Hadean', 'eon', 4567.0, 4000.0, 2),
(2, 'Precambrian', 'supereon', 4567.0, 541.0, null),
(3, 'Archean', 'eon', 4000.0, 2500.0, 2),
(4, 'Eoarchean', 'era', 4000.0, 3600.0, 3),
(5, 'Paleoarchean', 'era', 3600.0, 3200.0, 3),
(6, 'Mesoarchean', 'era', 3200.0, 2800.0, 3),
(7, 'Neoarchean', 'era', 2800.0, 2500.0, 3),
(8, 'Proterozoic', 'eon', 2500.0, 541.0, 2),
(9, 'Paleoproterozoic', 'era', 2500.0, 1600.0, 8),
(10, 'Siderian', 'period', 2500.0, 2300.0, 9),
(11, 'Rhyacian', 'period', 2300.0, 2050.0, 9),
(12, 'Orosirian', 'period', 2050.0, 1800.0, 9),
(13, 'Statherian', 'period', 1800.0, 1600.0, 9),
(14, 'Mesoproterozoic', 'era', 1600.0, 1000.0, 8),
(15, 'Calymmian', 'period', 1600.0, 1400.0, 14),
(16, 'Ectasian', 'period', 1400.0, 1200.0, 14),
(17, 'Stenian', 'period', 1200.0, 1000.0, 14),
(18, 'Tonian', 'period', 1000.0, 720.0, 19),
(19, 'Neoproterozoic', 'era', 1000.0, 541.0, 8),
(20, 'Cryogenian', 'period', 720.0, 635.0, 19),
(21, 'Ediacaran', 'period', 635.0, 541.0, 19),
(22, 'Cambrian', 'period', 541.0, 485.4, 24),
(23, 'Fortunian', 'age', 541.0, 529.0, 26),
(24, 'Paleozoic', 'era', 541.0, 251.902, 25),
(25, 'Phanerozoic', 'eon', 541.0, 0.0, null),
(26, 'Terreneuvian', 'epoch', 541.0, 521.0, 22),
(27, 'CambrianStage2', 'age', 529.0, 521.0, 26),
(28, 'CambrianSeries2', 'epoch', 521.0, 509.0, 22),
(29, 'CambrianStage3', 'age', 521.0, 514.0, 28),
(30, 'CambrianStage4', 'age', 514.0, 509.0, 28),
(31, 'Wuliuan', 'age', 509.0, 504.5, 32),
(32, 'Miaolingian', 'epoch', 509.0, 497.0, 22),
(33, 'Drumian', 'age', 504.5, 500.5, 32),
(34, 'Guzhangian', 'age', 500.5, 497.0, 32),
(35, 'Furongian', 'epoch', 497.0, 485.4, 22),
(36, 'Paibian', 'age', 497.0, 494.0, 35),
(37, 'Jiangshanian', 'age', 494.0, 489.5, 35),
(38, 'CambrianStage10', 'age', 489.5, 485.4, 35),
(39, 'Tremadocian', 'age', 485.4, 477.7, 40),
(40, 'LowerOrdovician', 'epoch', 485.4, 470.0, 41),
(41, 'Ordovician', 'period', 485.4, 443.8, 24),
(42, 'Floian', 'age', 477.7, 470.0, 40),
(43, 'Dapingian', 'age', 470.0, 467.3, 44),
(44, 'MiddleOrdovician', 'epoch', 470.0, 458.4, 41),
(45, 'Darriwilian', 'age', 467.3, 458.4, 44),
(46, 'Sandbian', 'age', 458.4, 453.0, 47),
(47, 'UpperOrdovician', 'epoch', 458.4, 443.8, 41),
(48, 'Katian', 'age', 453.0, 445.2, 47),
(49, 'Hirnantian', 'age', 445.2, 443.8, 47),
(50, 'Llandovery', 'epoch', 443.8, 433.4, 52),
(51, 'Rhuddanian', 'age', 443.8, 440.8, 50),
(52, 'Silurian', 'period', 443.8, 419.2, 24),
(53, 'Aeronian', 'age', 440.8, 438.5, 50),
(54, 'Telychian', 'age', 438.5, 433.4, 50),
(55, 'Sheinwoodian', 'age', 433.4, 430.5, 56),
(56, 'Wenlock', 'epoch', 433.4, 427.4, 52),
(57, 'Homerian', 'age', 430.5, 427.4, 56),
(58, 'Ludlow', 'epoch', 427.4, 423.0, 52),
(59, 'Gorstian', 'age', 427.4, 425.6, 58),
(60, 'Ludfordian', 'age', 425.6, 423.0, 58),
(61, 'Pridoli', 'age', 423.0, 419.2, 52),
(62, 'Devonian', 'period', 419.2, 358.9, 24),
(63, 'LowerDevonian', 'epoch', 419.2, 393.3, 62),
(64, 'Lochkovian', 'age', 419.2, 410.8, 63),
(65, 'Pragian', 'age', 410.8, 407.6, 63),
(66, 'Emsian', 'age', 407.6, 393.3, 63),
(67, 'Eifelian', 'age', 393.3, 387.7, 68),
(68, 'MiddleDevonian', 'epoch', 393.3, 382.7, 62),
(69, 'Givetian', 'age', 387.7, 382.7, 68),
(70, 'UpperDevonian', 'epoch', 382.7, 358.9, 62),
(71, 'Frasnian', 'age', 382.7, 372.2, 70),
(72, 'Famennian', 'age', 372.2, 358.9, 70),
(73, 'LowerMississippian', 'epoch', 358.9, 346.7, 75),
(74, 'Tournaisian', 'age', 358.9, 346.7, 73),
(75, 'Mississippian', 'subperiod', 358.9, 323.2, 76),
(76, 'Carboniferous', 'period', 358.9, 298.9, 24),
(77, 'MiddleMississippian', 'epoch', 346.7, 330.9, 75),
(78, 'Visean', 'age', 346.7, 330.9, 77),
(79, 'Serpukhovian', 'age', 330.9, 323.2, 80),
(80, 'UpperMississippian', 'epoch', 330.9, 298.9, 75),
(81, 'Bashkirian', 'age', 323.2, 315.2, 83),
(82, 'Pennsylvanian', 'subperiod', 323.2, 298.9, 76),
(83, 'LowerPennsylvanian', 'epoch', 323.2, 315.2, 82),
(84, 'MiddlePennsylvanian', 'epoch', 315.2, 307.0, 82),
(85, 'Moscovian', 'age', 315.2, 307.0, 84),
(86, 'Kasimovian', 'age', 307.0, 303.7, 87),
(87, 'UpperPennsylvanian', 'epoch', 307.0, 298.9, 82),
(88, 'Gzhelian', 'age', 303.7, 298.9, 87),
(89, 'Cisuralian', 'epoch', 298.9, 272.95, 91),
(90, 'Asselian', 'age', 298.9, 295.0, 89),
(91, 'Permian', 'period', 298.9, 251.902, 24),
(92, 'Sakmarian', 'age', 295.0, 290.1, 89),
(93, 'Artinskian', 'age', 290.1, 283.5, 89),
(94, 'Kungurian', 'age', 283.5, 272.95, 89),
(95, 'Roadian', 'age', 272.95, 268.8, 96),
(96, 'Guadalupian', 'epoch', 272.95, 259.1, 91),
(97, 'Wordian', 'age', 268.8, 265.1, 96),
(98, 'Capitanian', 'age', 265.1, 259.1, 96),
(99, 'Lopingian', 'epoch', 259.1, 251.902, 91),
(100, 'Wuchiapingian', 'age', 259.1, 254.14, 99),
(101, 'Changhsingian', 'age', 254.14, 251.902, 99),
(102, 'Induan', 'age', 251.902, 251.2, 103),
(103, 'LowerTriassic', 'epoch', 251.902, 247.2, 105),
(104, 'Mesozoic', 'era', 251.902, 66.0, 25),
(105, 'Triassic', 'period', 251.902, 201.3, 104),
(106, 'Olenekian', 'age', 251.2, 247.2, 103),
(107, 'Anisian', 'age', 247.2, 242.0, 108),
(108, 'MiddleTriassic', 'epoch', 247.2, 237.0, 105),
(109, 'Ladinian', 'age', 242.0, 237.0, 108),
(110, 'Carnian', 'age', 237.0, 227.0, 111),
(111, 'UpperTriassic', 'epoch', 237.0, 201.3, 105),
(112, 'Norian', 'age', 227.0, 208.5, 111),
(113, 'Rhaetian', 'age', 208.5, 201.3, 111),
(114, 'Jurassic', 'period', 201.3, 145.0, 104),
(115, 'Hettangian', 'age', 201.3, 199.3, 116),
(116, 'LowerJurassic', 'epoch', 201.3, 174.1, 114),
(117, 'Sinemurian', 'age', 199.3, 190.8, 116),
(118, 'Pliensbachian', 'age', 190.8, 182.7, 116),
(119, 'Toarcian', 'age', 182.7, 174.1, 116),
(120, 'MiddleJurassic', 'epoch', 174.1, 163.5, 114),
(121, 'Aalenian', 'age', 174.1, 170.3, 120),
(122, 'Bajocian', 'age', 170.3, 168.3, 120),
(123, 'Bathonian', 'age', 168.3, 166.1, 120),
(124, 'Callovian', 'age', 166.1, 163.5, 120),
(125, 'Oxfordian', 'age', 163.5, 157.3, 126),
(126, 'UpperJurassic', 'epoch', 163.5, 145.0, 114),
(127, 'Kimmeridgian', 'age', 157.3, 152.1, 126),
(128, 'Tithonian', 'age', 152.1, 145.0, 126),
(129, 'LowerCretaceous', 'epoch', 145.0, 100.5, 130),
(130, 'Cretaceous', 'period', 145.0, 66.0, 104),
(131, 'Berriasian', 'age', 145.0, 139.8, 129),
(132, 'Valanginian', 'age', 139.8, 132.9, 129),
(133, 'Hauterivian', 'age', 132.9, 129.4, 129),
(134, 'Barremian', 'age', 129.4, 125.0, 129),
(135, 'Aptian', 'age', 125.0, 113.0, 129),
(136, 'Albian', 'age', 113.0, 100.5, 129),
(137, 'Cenomanian', 'age', 100.5, 93.9, 138),
(138, 'UpperCretaceous', 'epoch', 100.5, 66.0, 130),
(139, 'Turonian', 'age', 93.9, 89.8, 138),
(140, 'Coniacian', 'age', 89.8, 86.3, 138),
(141, 'Santonian', 'age', 86.3, 83.6, 138),
(142, 'Campanian', 'age', 83.6, 72.1, 138),
(143, 'Maastrichtian', 'age', 72.1, 66.0, 138),
(144, 'Paleocene', 'epoch', 66.0, 56.0, 145),
(145, 'Paleogene', 'period', 66.0, 23.03, 146),
(146, 'Cenozoic', 'era', 66.0, 0.0, 25),
(147, 'Danian', 'age', 66.0, 61.6, 144),
(148, 'Selandian', 'age', 61.6, 59.2, 144),
(149, 'Thanetian', 'age', 59.2, 56.0, 144),
(150, 'Eocene', 'epoch', 56.0, 33.9, 145),
(151, 'Ypresian', 'age', 56.0, 47.8, 150),
(152, 'Lutetian', 'age', 47.8, 41.2, 150),
(153, 'Bartonian', 'age', 41.2, 37.8, 150),
(154, 'Priabonian', 'age', 37.8, 33.9, 150),
(155, 'Rupelian', 'age', 33.9, 28.1, 156),
(156, 'Oligocene', 'epoch', 33.9, 23.03, 145),
(157, 'Chattian', 'age', 27.82, 23.03, 156),
(158, 'Aquitanian', 'age', 23.03, 20.44, 160),
(159, 'Neogene', 'period', 23.03, 2.58, 146),
(160, 'Miocene', 'epoch', 23.03, 5.333, 159),
(161, 'Burdigalian', 'age', 20.44, 15.97, 160),
(162, 'Langhian', 'age', 15.97, 13.82, 160),
(163, 'Serravallian', 'age', 13.82, 11.63, 160),
(164, 'Tortonian', 'age', 11.63, 7.246, 160),
(165, 'Messinian', 'age', 7.246, 5.333, 160),
(166, 'Zanclean', 'age', 5.333, 3.6, 167),
(167, 'Pliocene', 'epoch', 5.333, 2.58, 159),
(168, 'Piacenzian', 'age', 3.6, 2.58, 167),
(169, 'Quaternary', 'period', 2.58, 0.0, 146),
(170, 'Gelasian', 'age', 2.58, 1.8, 171),
(171, 'Pleistocene', 'epoch', 2.58, 0.0117, 169),
(172, 'Calabrian', 'age', 1.8, 0.781, 171),
(173, 'MiddlePleistocene', 'age', 0.781, 0.126, 171),
(174, 'UpperPleistocene', 'age', 0.126, 0.0117, 171),
(175, 'Holocene', 'epoch', 0.0117, 0.0, 169),
(176, 'Greenlandian', 'age', 0.0117, 0.0082, 175),
(177, 'Northgrippian', 'age', 0.0082, 0.0042, 175),
(178, 'Meghalayan', 'age', 0.0042, 0.0, 175);

COMMIT;

