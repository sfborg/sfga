PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

CREATE TABLE version (id);

INSERT INTO
  version
VALUES
  ('v0.3.14');

-- fields starting with `gn_` belong to GlobalNames namespace.

-- Metadata start
CREATE TABLE metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  doi TEXT DEFAULT '',
  title TEXT NOT NULL,
  alias TEXT DEFAULT '',
  description TEXT DEFAULT '',
  issued TEXT DEFAULT '',
  version TEXT DEFAULT '',
  keywords TEXT DEFAULT '',
  geographic_scope TEXT DEFAULT '',
  taxonomic_scope TEXT DEFAULT '',
  temporal_scope TEXT DEFAULT '',
  confidence INTEGER DEFAULT 0,
  completeness INTEGER DEFAULT 0,
  license TEXT DEFAULT '',
  url TEXT DEFAULT '',
  logo TEXT DEFAULT '',
  label TEXT DEFAULT '',
  citation TEXT DEFAULT '',
  private INTEGER DEFAULT 0
);

CREATE TABLE contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 0,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT NOT NULL,
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
);

CREATE TABLE editor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 0,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
);

CREATE TABLE creator (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 0,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
);

CREATE TABLE publisher (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 0,
  orcid TEXT DEFAULT '',
  given TEXT DEFAULT '',
  family TEXT DEFAULT '',
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
);

CREATE TABLE contributor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 0,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
);

CREATE TABLE source (
  id TEXT PRIMARY KEY,
  metadata_id INTEGER DEFAULT 0,
  type TEXT DEFAULT '',
  title TEXT DEFAULT '',
  authors TEXT DEFAULT '',
  issued TEXT DEFAULT '',
  isbn TEXT DEFAULT ''
);

-- Metadata end

-- Data start
CREATE TABLE author (
  id TEXT PRIMARY KEY,
  source_id TEXT REFERENCES source DEFAULT '',
  alternative_id TEXT DEFAULT '', -- sep by ','
  given TEXT DEFAULT '',
  family TEXT NOT NULL,
  -- f. for filius,  Jr., etc
  suffix TEXT DEFAULT '',
  abbreviation_botany TEXT DEFAULT '',
  alternative_names TEXT DEFAULT '', -- separated by '|'
  sex_id TEXT REFERENCES sex DEFAULT '',
  country TEXT DEFAULT '',
  birth TEXT DEFAULT '',
  birth_place TEXT DEFAULT '',
  death TEXT DEFAULT '',
  affiliation TEXT DEFAULT '',
  interest TEXT DEFAULT '',
  reference_id TEXT DEFAULT '', -- sep by ','
  -- url
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE reference (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '', -- sep by ',', scope:id, id, URI/URN
  source_id TEXT REFERENCES source DEFAULT '',
  citation TEXT DEFAULT '',
  type TEXT REFERENCES reference_type DEFAULT '',
  -- author/s in format of either
  -- family1, given1; family2, given2; ..
  -- or
  -- given1 family1, given2 family2, ...
  author TEXT DEFAULT '',
  author_id TEXT DEFAULT '', -- 'ref' author, sep ','
  editor TEXT DEFAULT '', -- 'ref' author, sep ','
  editor_id TEXT DEFAULT '', -- 'ref' author, sep ','
  title TEXT DEFAULT '',
  title_short TEXT DEFAULT '',
  -- container_author is an author or a parent volume (book, journal) 
  container_author TEXT DEFAULT '',
  -- container_title of the parent container
  container_title TEXT DEFAULT '',
  -- container_title_short of the parent container
  container_title_short TEXT DEFAULT '',
  issued TEXT DEFAULT '', -- yyyy-mm-dd
  accessed TEXT DEFAULT '', -- yyyy-mm-dd
  -- collection_title of the parent volume
  collection_title TEXT DEFAULT '',
  -- collection_editor of the parent volume
  collection_editor TEXT DEFAULT '',
  volume TEXT DEFAULT '',
  issue TEXT DEFAULT '',
  -- edition number
  edition TEXT DEFAULT '',
  -- page number
  page INTEGER DEFAULT 0,
  publisher TEXT DEFAULT '',
  publisher_place TEXT DEFAULT '',
  -- version of the reference
  version TEXT DEFAULT '',
  isbn TEXT DEFAULT '',
  issn TEXT DEFAULT '',
  doi TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE name (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '',
  source_id TEXT DEFAULT '',
  -- basionym_id TEXT DEFAULT '', -- use name_relation instead
  gn_full_scientific_name TEXT NOT NULL, -- full name with authorship (if given)
  scientific_name TEXT NOT NULL, -- full canonical form
  authorship TEXT DEFAULT '', -- verbatim authorship
  rank_id INTEGER REFERENCES rank DEFAULT '',
  uninomial TEXT DEFAULT '',
  genus TEXT DEFAULT '',
  infrageneric_epithet TEXT DEFAULT '',
  specific_epithet TEXT DEFAULT '',
  infraspecific_epithet TEXT DEFAULT '',
  cultivar_epithet TEXT DEFAULT '',
  notho_id TEXT DEFAULT '', -- ref name_part
  original_spelling INTEGER DEFAULT 0, -- bool
  combination_authorship TEXT DEFAULT '', -- separated by '|'
  combination_authorship_id TEXT DEFAULT '', -- separated by '|'
  combination_ex_authorship TEXT DEFAULT '', -- separated by '|'
  combination_ex_authorship_id TEXT DEFAULT '', -- separated by '|'
  combination_authorship_year TEXT DEFAULT '',
  basionym_authorship TEXT DEFAULT '', -- separated by '|'
  basionym_authorship_id TEXT DEFAULT '', -- separated by '|'
  basionym_ex_authorship TEXT DEFAULT '', -- separated by '|'
  basionym_ex_authorship_id TEXT DEFAULT '', -- separated by '|'
  basionym_authorship_year TEXT DEFAULT '',
  code_id TEXT REFERENCES nom_code DEFAULT '',
  status_id TEXT REFERENCES nom_status DEFAULT '',
  reference_id TEXT DEFAULT '', -- refs about taxon sep ','
  published_in_year TEXT DEFAULT '',
  published_in_page TEXT DEFAULT '',
  published_in_page_link TEXT DEFAULT '',
  gender_id TEXT REFERENCES gender DEFAULT '',
  gender_agreement INTEGER DEFAULT 0, -- bool
  etymology TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE taxon (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '', -- scope:id, id sep ','
  gn_local_id TEXT DEFAULT '', -- internal ID from the source
  gn_global_id TEXT DEFAULT '', -- GUID attached to the record.
  source_id TEXT REFERENCES source DEFAULT '',
  parent_id TEXT REFERENCES taxon DEFAULT '',
  ordinal INTEGER DEFAULT 0, -- for sorting
  branch_length INTEGER DEFAULT 0, --length of 'bread crumbs'
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  name_phrase TEXT DEFAULT '', -- eg `sensu stricto` and other annotations
  according_to_id TEXT REFERENCES reference DEFAULT '',
  according_to_page TEXT DEFAULT '',
  according_to_page_link TEXT DEFAULT '',
  scrutinizer TEXT DEFAULT '',
  scrutinizer_id TEXT DEFAULT '', -- ORCID usually
  scrutinizer_date TEXT DEFAULT '',
  provisional INTEGER DEFAULT 0, -- bool
  reference_id TEXT DEFAULT '', -- list of references about the taxon hypothesis
  extinct INTEGER DEFAULT 0, -- bool
  temporal_range_start_id TEXT REFERENCES geo_time DEFAULT '',
  temporal_range_end_id TEXT REFERENCES geo_time DEFAULT '',
  environment_id TEXT DEFAULT '', -- environment ids sep by ','
  species TEXT DEFAULT '',
  section TEXT DEFAULT '',
  subgenus TEXT DEFAULT '',
  genus TEXT DEFAULT '',
  subtribe TEXT DEFAULT '',
  tribe TEXT DEFAULT '',
  subfamily TEXT DEFAULT '',
  family TEXT DEFAULT '',
  superfamily TEXT DEFAULT '',
  suborder TEXT DEFAULT '',
  "order" TEXT DEFAULT '',
  subclass TEXT DEFAULT '',
  class TEXT DEFAULT '',
  subphylum TEXT DEFAULT '',
  phylum TEXT DEFAULT '',
  kingdom TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE synonym (
  id TEXT, -- optional
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  name_phrase TEXT DEFAULT '', -- annotation (eg `sensu lato` etc)
  according_to_id TEXT REFERENCES reference DEFAULT '',
  status_id TEXT REFERENCES taxonomic_status DEFAULT '',
  reference_id TEXT DEFAULT '', -- ids, sep by ',' about this synonym
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE INDEX idx_synonym_id ON synonym (id);
CREATE INDEX idx_synonym_taxon_id ON synonym (taxon_id);

CREATE TABLE vernacular (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  name TEXT NOT NULL,
  transliteration TEXT DEFAULT '',
  language TEXT DEFAULT '',
  preferred INTEGER DEFAULT 0, -- bool
  country TEXT DEFAULT '',
  area TEXT DEFAULT '',
  sex_id TEXT REFERENCES sex DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE INDEX idx_vernacular_taxon_id ON vernacular (taxon_id);

CREATE TABLE name_relation (
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  related_name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  source_id TEXT REFERENCES source,
  -- nom_rel_type enum
  type_id TEXT NOT NULL REFERENCES nom_rel_type DEFAULT '',
  -- starting page number for the nomenclatural event
  page INTEGER DEFAULT 0,
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE type_material (
  id TEXT DEFAULT '', -- optional
  source_id TEXT REFERENCES source DEFAULT '',
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  citation TEXT DEFAULT '',
  status_id TEXT REFERENCES type_status DEFAULT '',
  institution_code TEXT DEFAULT '',
  catalog_number TEXT DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  locality TEXT DEFAULT '',
  country TEXT DEFAULT '',
  latitude REAL DEFAULT 0,
  longitude REAL DEFAULT 0,
  altitude INTEGER DEFAULT 0,
  host TEXT DEFAULT '',
  sex_id TEXT REFERENCES sex DEFAULT '',
  date TEXT DEFAULT '',
  collector TEXT DEFAULT '',
  associated_sequences TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE INDEX idx_type_material_id ON type_material (id);

CREATE TABLE distribution (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  area TEXT DEFAULT '',
  area_id TEXT DEFAULT '',
  gazetteer_id TEXT REFERENCES gazetteer DEFAULT '',
  status_id TEXT REFERENCES distribution_status DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE media (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  url TEXT NOT NULL, -- in CoLDP media is always a link
  type TEXT DEFAULT '', -- MIME type
  format TEXT DEFAULT '',
  title TEXT DEFAULT '',
  created TEXT DEFAULT '',
  creator TEXT DEFAULT '',
  license TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

-- treatment files are on file system.
CREATE TABLE treatment (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  document TEXT NOT NULL,
  format TEXT DEFAULT '', -- HTML, XML, TXT
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE species_estimate (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  estimate INTEGER NOT NULL, -- estimated number of species
  type TEXT NOT NULL REFERENCES estimate_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

-- for arbitrary properties assigned to taxon
CREATE TABLE taxon_property (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  property TEXT NOT NULL, -- name of the property
  value TEXT NOT NULL,
  reference_id TEXT REFERENCES reference DEFAULT '',
  page INTEGER DEFAULT 0,
  ordinal INTEGER DEFAULT 0, -- sorting value
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE species_interaction (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  related_taxon_id NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  related_taxon_scientific_name TEXT DEFAULT '', -- id or hardcoded name?
  type TEXT NOT NULL REFERENCES species_interaction_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

CREATE TABLE taxon_concept_relation (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  related_taxon_id TEXT NOT NULL,
  source_id TEXT REFERENCES source DEFAULT '',
  type TEXT REFERENCES taxon_concept_rel_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
);

-- ENUMS --

CREATE TABLE nom_code (id TEXT PRIMARY KEY);

INSERT INTO
  nom_code (id)
VALUES
  (''),
  ('BACTERIAL'),
  ('BOTANICAL'),
  ('CULTIVARS'),
  ('PHYTOSOCIOLOGICAL'),
  ('VIRUS'),
  ('ZOOLOGICAL');

CREATE TABLE name_part (id TEXT PRIMARY KEY);

INSERT INTO
  name_part (id)
VALUES
  (''),
  ('GENERIC'),
  ('INFRAGENERIC'),
  ('SPECIFIC'),
  ('INFRASPECIFIC');

CREATE TABLE gender (id TEXT PRIMARY KEY);

INSERT INTO
  gender (id)
VALUES
  (''),
  ('MASCULINE'),
  ('FEMININE'),
  ('NEUTRAL');

CREATE TABLE sex (id TEXT PRIMARY KEY);

INSERT INTO
  sex (id)
VALUES
  (''),
  ('MALE'),
  ('FEMALE'),
  ('HERMAPHRODITE');

CREATE TABLE estimate_type (id TEXT PRIMARY KEY);

INSERT INTO
  estimate_type (id)
VALUES
  (''),
  ('SPECIES_EXTINCT'),
  ('SPECIES_LIVING'), -- only described species
  ('ESTIMATED_SPECIES' -- includes not described living species
);

CREATE TABLE distribution_status (id TEXT PRIMARY KEY);

INSERT INTO
  distribution_status (id)
VALUES
  (''),
  ('NATIVE'),
  ('DOMESTICATED'),
  ('ALIEN'),
  ('UNCERTAIN');

CREATE TABLE type_status (
  id TEXT PRIMARY KEY,
  name TEXT,
  root TEXT REFERENCES type_status,
  "primary" INTEGER, -- bool
  codes TEXT -- nom codes sep ',' 
);

INSERT INTO type_status (id, name, root, codes, "primary")
VALUES
('', '', '', '', 0),
('OTHER', 'other', 'OTHER', '', 0),
('HOMOEOTYPE', 'homoeotype', 'HOMOEOTYPE', 'ZOOLOGICAL', 0),
('PLESIOTYPE', 'plesiotype', 'PLESIOTYPE', 'ZOOLOGICAL', 0),
('PLASTOTYPE', 'plastotype', 'PLASTOTYPE', 'BOTANICAL,ZOOLOGICAL', 0),
('PLASTOSYNTYPE', 'plastosyntype', 'SYNTYPE', 'BOTANICAL,ZOOLOGICAL', 0),
('PLASTOPARATYPE', 'plastoparatype', 'PARATYPE', 'BOTANICAL,ZOOLOGICAL', 0),
('PLASTONEOTYPE', 'plastoneotype', 'NEOTYPE', '', 0),
('PLASTOLECTOTYPE', 'plastolectotype', 'LECTOTYPE', '', 0),
('PLASTOISOTYPE', 'plastoisotype', 'HOLOTYPE', '', 0),
('PLASTOHOLOTYPE', 'plastoholotype', 'HOLOTYPE', '', 0),
('ALLOTYPE', 'allotype', 'PARATYPE', 'ZOOLOGICAL', 0),
('ALLONEOTYPE', 'alloneotype', 'NEOTYPE', 'ZOOLOGICAL', 0),
('ALLOLECTOTYPE', 'allolectotype', 'LECTOTYPE', 'ZOOLOGICAL', 0),
('PARANEOTYPE', 'paraneotype', 'NEOTYPE', 'ZOOLOGICAL', 0),
('PARALECTOTYPE', 'paralectotype', 'LECTOTYPE', 'ZOOLOGICAL', 0),
('ISOSYNTYPE', 'isosyntype', 'SYNTYPE', 'BOTANICAL', 0),
('ISOPARATYPE', 'isoparatype', 'PARATYPE', 'BOTANICAL', 0),
('ISONEOTYPE', 'isoneotype', 'NEOTYPE', 'BOTANICAL', 0),
('ISOLECTOTYPE', 'isolectotype', 'LECTOTYPE', 'BOTANICAL', 0),
('ISOEPITYPE', 'isoepitype', 'EPITYPE', 'BOTANICAL', 0),
('ISOTYPE', 'isotype', 'HOLOTYPE', 'BOTANICAL', 0),
('TOPOTYPE', 'topotype', 'TOPOTYPE', 'BOTANICAL,ZOOLOGICAL', 0),
('SYNTYPE', 'syntype', 'SYNTYPE', 'BOTANICAL,ZOOLOGICAL', 1),
('PATHOTYPE', 'pathotype', 'PATHOTYPE', 'BACTERIAL', 0),
('PARATYPE', 'paratype', 'PARATYPE', 'BOTANICAL,ZOOLOGICAL', 1),
('ORIGINAL_MATERIAL', 'original material', 'ORIGINAL_MATERIAL', 'BOTANICAL', 1),
('NEOTYPE', 'neotype', 'NEOTYPE', 'BACTERIAL,BOTANICAL,ZOOLOGICAL', 1),
('LECTOTYPE', 'lectotype', 'LECTOTYPE', 'BACTERIAL,BOTANICAL,ZOOLOGICAL', 1),
('ICONOTYPE', 'iconotype', 'ICONOTYPE', 'BOTANICAL', 0),
('HOLOTYPE', 'holotype', 'HOLOTYPE', 'BACTERIAL,BOTANICAL,ZOOLOGICAL', 1),
('HAPANTOTYPE', 'hapantotype', 'HAPANTOTYPE', 'ZOOLOGICAL', 0),
('EX_TYPE', 'ex type', 'EX_TYPE', 'BOTANICAL,ZOOLOGICAL', 0),
('ERGATOTYPE', 'ergatotype', 'ERGATOTYPE', 'ZOOLOGICAL', 0),
('EPITYPE', 'epitype', 'EPITYPE', 'BOTANICAL', 0);

CREATE TABLE nom_rel_type (id TEXT PRIMARY KEY);

INSERT INTO
  nom_rel_type (id)
VALUES
  (''),
  ('SPELLING_CORRECTION'),
  ('BASIONYM'),
  ('BASEDON'),
  ('REPLACEMENT_NAME'),
  ('CONSERVED'),
  ('LATER_HOMONYM'),
  ('SUPERFLUOUS'),
  ('HOMOTYPIC'),
  ('TYPE');

CREATE TABLE nom_status (id TEXT PRIMARY KEY);

INSERT INTO
  nom_status (id)
VALUES
  (''),
  ('ESTABLISHED'),
  ('ACCEPTABLE'),
  ('UNACCEPTABLE'),
  ('CONSERVED'),
  ('REJECTED'),
  ('DOUBTFUL'),
  ('MANUSCRIPT'),
  ('CHRESONYM');

CREATE TABLE reference_type(id TEXT PRIMARY KEY);

INSERT INTO reference_type VALUES
(''),
('ARTICLE'),
('ARTICLE_JOURNAL'),
('ARTICLE_MAGAZINE'),
('ARTICLE_NEWSPAPER'),
('BILL'),
('BOOK'),
('BROADCAST'),
('CHAPTER'),
('DATASET'),
('ENTRY'),
('ENTRY_DICTIONARY'),
('ENTRY_ENCYCLOPEDIA'),
('FIGURE'),
('GRAPHIC'),
('INTERVIEW'),
('LEGAL_CASE'),
('LEGISLATION'),
('MANUSCRIPT'),
('MAP'),
('MOTION_PICTURE'),
('MUSICAL_SCORE'),
('PAMPHLET'),
('PAPER_CONFERENCE'),
('PATENT'),
('PERSONAL_COMMUNICATION'),
('POST'),
('POST_WEBLOG'),
('REPORT'),
('REVIEW'),
('REVIEW_BOOK'),
('SONG'),
('SPEECH'),
('THESIS'),
('TREATY'),
('WEBPAGE');

CREATE TABLE taxonomic_status (
  id TEXT PRIMARY KEY,
  value TEXT DEFAULT '',
  name TEXT DEFAULT '',
  bare_name INTEGER DEFAULT 0, -- bool
  description TEXT DEFAULT '',
  majorStatus TEXT DEFAULT '',
  synonym INTEGER DEFAULT 0, -- bool
  taxon INTEGER -- bool
);

INSERT INTO
  taxonomic_status (
    id,
    name,
    bare_name,
    description,
    majorStatus,
    synonym,
    taxon
  )
VALUES
('', '', 0, '', '', 0, 0),
('ACCEPTED', 'accepted', 0, 'A taxonomically accepted, current name', 'ACCEPTED', 0, 1),
('PROVISIONALLY_ACCEPTED', 'provisionally accepted', 0, 'Treated as accepted, but doubtful whether this is correct.', 'ACCEPTED', 0, 1),
('SYNONYM', 'synonym', 0, 'Names which point unambiguously at one species (not specifying whether homo- or heterotypic).Synonyms, in the CoL sense, include also orthographic variants and published misspellings.', 'SYNONYM', 1, 0),
('AMBIGUOUS_SYNONYM', 'ambiguous synonym', 0, 'Names which are ambiguous because they point at the current species and one or more others e.g. homonyms, pro-parte synonyms (in other words, names which appear more than in one place in the Catalogue).', 'SYNONYM', 1, 0),
('MISAPPLIED', 'misapplied', 0, 'A misapplied name. Usually accompanied with an accordingTo on the synonym to indicate the source the misapplication can be found in.', 'SYNONYM', 1, 0),
('BARE_NAME', 'bare name', 1, 'A name alone without any usage, neither a synonym nor a taxon.', 'BARE_NAME', 0, 0);

CREATE TABLE species_interaction_type (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  inverse TEXT REFERENCES species_interaction_type,
  superTypes TEXT DEFAULT '', -- ids sep ','
  obo TEXT DEFAULT '',
  symmetrical INTEGER DEFAULT 0, -- bool
  description TEXT DEFAULT ''
);

INSERT INTO species_interaction_type (
  id, name, inverse, superTypes, obo, symmetrical, description
)
VALUES
('', '', '', '', '', 0, ''),
('MUTUALIST_OF', 'mutualist of', 'MUTUALIST_OF', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0002442', 1, 'An interaction relationship between two organisms living together in more or less intimate association in a relationship in which both organisms benefit from each other (GO).'),
('COMMENSALIST_OF', 'commensalist of', 'COMMENSALIST_OF', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0002441', 1, 'An interaction relationship between two organisms living together in more or less intimate association in a relationship in which one benefits and the other is unaffected (GO).'),
('HAS_EPIPHYTE', 'has epiphyte', 'EPIPHYTE_OF', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0008502', 0, 'Inverse of epiphyte of'),
('EPIPHYTE_OF', 'epiphyte of', 'HAS_EPIPHYTE', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0008501', 0, 'An interaction relationship wherein a plant or algae is living on the outside surface of another plant.'),
('HAS_EGGS_LAYED_ON_BY', 'has eggs layed on by', 'LAYS_EGGS_ON', 'HOST_OF', 'http://purl.obolibrary.org/obo/RO_0008508', 0, 'Inverse of lays eggs on'),
('LAYS_EGGS_ON', 'lays eggs on', 'HAS_EGGS_LAYED_ON_BY', 'HAS_HOST', 'http://purl.obolibrary.org/obo/RO_0008507', 0, 'An interaction relationship in which organism a lays eggs on the outside surface of organism b. Organism b is neither helped nor harmed in the process of egg laying or incubation.'),
('POLLINATED_BY', 'pollinated by', 'POLLINATES', 'FLOWERS_VISITED_BY', 'http://purl.obolibrary.org/obo/RO_0002456', 0, 'Inverse of pollinates'),
('POLLINATES', 'pollinates', 'POLLINATED_BY', 'VISITS_FLOWERS_OF', 'http://purl.obolibrary.org/obo/RO_0002455', 0, 'This relation is intended to be used for biotic pollination - e.g. a bee pollinating a flowering plant. '),
('FLOWERS_VISITED_BY', 'flowers visited by', 'VISITS_FLOWERS_OF', 'VISITED_BY', 'http://purl.obolibrary.org/obo/RO_0002623', 0, 'Inverse of visits flowers of'),
('VISITS_FLOWERS_OF', 'visits flowers of', 'FLOWERS_VISITED_BY', 'VISITS', 'http://purl.obolibrary.org/obo/RO_0002622', 0, ''),
('VISITED_BY', 'visited by', 'VISITS', 'HOST_OF', 'http://purl.obolibrary.org/obo/RO_0002619', 0, 'Inverse of visits'),
('VISITS', 'visits', 'VISITED_BY', 'HAS_HOST', 'http://purl.obolibrary.org/obo/RO_0002618', 0, ''),
('HAS_HYPERPARASITOID', 'has hyperparasitoid', 'HYPERPARASITOID_OF', 'HAS_PARASITOID', 'http://purl.obolibrary.org/obo/RO_0002554', 0, 'Inverse of hyperparasitoid of'),
('HYPERPARASITOID_OF', 'hyperparasitoid of', 'HAS_HYPERPARASITOID', 'PARASITOID_OF', 'http://purl.obolibrary.org/obo/RO_0002553', 0, 'X is a hyperparasite of y if x is a parasite of a parasite of the target organism y'),
('HAS_PARASITOID', 'has parasitoid', 'PARASITOID_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0002209', 0, 'Inverse of parasitoid of'),
('PARASITOID_OF', 'parasitoid of', 'HAS_PARASITOID', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0002208', 0, 'A parasite that kills or sterilizes its host'),
('HAS_KLEPTOPARASITE', 'has kleptoparasite', 'KLEPTOPARASITE_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0008503', 0, 'Inverse of kleptoparasite of'),
('KLEPTOPARASITE_OF', 'kleptoparasite of', 'HAS_KLEPTOPARASITE', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0008503', 0, 'A sub-relation of parasite of in which a parasite steals resources from another organism, usually food or nest material'),
('HAS_HYPERPARASITE', 'has hyperparasite', 'HYPERPARASITE_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0002554', 0, 'Inverse of hyperparasite of'),
('HYPERPARASITE_OF', 'hyperparasite of', 'HAS_HYPERPARASITE', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0002553', 0, 'X is a hyperparasite of y iff x is a parasite of a parasite of the target organism y'),
('HAS_ECTOPARASITE', 'has ectoparasite', 'ECTOPARASITE_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0002633', 0, 'Inverse of ectoparasite of'),
('ECTOPARASITE_OF', 'ectoparasite of', 'HAS_ECTOPARASITE', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0002632', 0, 'A sub-relation of parasite-of in which the parasite lives on or in the integumental system of the host'),
('HAS_ENDOPARASITE', 'has endoparasite', 'ENDOPARASITE_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0002635', 0, 'Inverse of endoparasite of'),
('ENDOPARASITE_OF', 'endoparasite of', 'HAS_ENDOPARASITE', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0002634', 0, 'A sub-relation of parasite-of in which the parasite lives inside the host, beneath the integumental system'),
('HAS_VECTOR', 'has vector', 'VECTOR_OF', 'HAS_HOST', 'http://purl.obolibrary.org/obo/RO_0002460', 0, 'Inverse of vector of'),
('VECTOR_OF', 'vector of', 'HAS_VECTOR', 'HOST_OF', 'http://purl.obolibrary.org/obo/RO_0002459', 0, 'a is a vector for b if a carries and transmits an infectious pathogen b into another living organism'),
('HAS_PATHOGEN', 'has pathogen', 'PATHOGEN_OF', 'HAS_PARASITE', 'http://purl.obolibrary.org/obo/RO_0002557', 0, 'Inverse of pathogen of'),
('PATHOGEN_OF', 'pathogen of', 'HAS_PATHOGEN', 'PARASITE_OF', 'http://purl.obolibrary.org/obo/RO_0002556', 0, ''),
('HAS_PARASITE', 'has parasite', 'PARASITE_OF', 'EATEN_BY,HOST_OF', 'http://purl.obolibrary.org/obo/RO_0002445', 0, 'Inverse of parasite of'),
('PARASITE_OF', 'parasite of', 'HAS_PARASITE', 'EATS,HAS_HOST', 'http://purl.obolibrary.org/obo/RO_0002444', 0, ''),
('HAS_HOST', 'has host', 'HOST_OF', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0002454', 0, 'Inverse of host of'),
('HOST_OF', 'host of', 'HAS_HOST', 'SYMBIONT_OF', 'http://purl.obolibrary.org/obo/RO_0002453', 0, 'The term host is usually used for the larger (macro) of the two members of a symbiosis'),
('PREYED_UPON_BY', 'preyed upon by', 'PREYS_UPON', 'EATEN_BY,KILLED_BY', 'http://purl.obolibrary.org/obo/RO_0002458', 0, 'Inverse of preys upon'),
('PREYS_UPON', 'preys upon', 'PREYED_UPON_BY', 'EATS,KILLS', 'http://purl.obolibrary.org/obo/RO_0002439', 0, 'An interaction relationship involving a predation process, where the subject kills the object in order to eat it or to feed to siblings, offspring or group members'),
('KILLED_BY', 'killed by', 'KILLS', 'INTERACTS_WITH', 'http://purl.obolibrary.org/obo/RO_0002627', 0, 'Inverse of kills'),
('KILLS', 'kills', 'KILLED_BY', 'INTERACTS_WITH', 'http://purl.obolibrary.org/obo/RO_0002626', 0, ''),
('EATEN_BY', 'eaten by', 'EATS', 'INTERACTS_WITH', 'http://purl.obolibrary.org/obo/RO_0002471', 0, 'Inverse of eats'),
('EATS', 'eats', 'EATEN_BY', 'INTERACTS_WITH', 'http://purl.obolibrary.org/obo/RO_0002470', 0, 'Herbivores, fungivores, predators or other forms of organims eating or feeding on the related taxon.'),
('SYMBIONT_OF', 'symbiont of', 'SYMBIONT_OF', 'INTERACTS_WITH', 'http://purl.obolibrary.org/obo/RO_0002440', 1, 'A symbiotic relationship, a more or less intimate association, with another organism. The various forms of symbiosis include parasitism, in which the association is disadvantageous or destructive to one of the organisms; mutualism, in which the association is advantageous, or often necessary to one or both and not harmful to either; and commensalism, in which one member of the association benefits while the other is not affected. However, mutualism, parasitism, and commensalism are often not discrete categories of interactions and should rather be perceived as a continuum of interaction ranging from parasitism to mutualism. In fact, the direction of a symbiotic interaction can change during the lifetime of the symbionts due to developmental changes as well as changes in the biotic/abiotic environment in which the interaction occurs. '),
('ADJACENT_TO', 'adjacent to', 'ADJACENT_TO', 'CO_OCCURS_WITH', 'http://purl.obolibrary.org/obo/RO_0002220', 1, 'X adjacent to y if and only if x and y share a boundary.'),
('INTERACTS_WITH', 'interacts with', 'INTERACTS_WITH', 'CO_OCCURS_WITH', 'http://purl.obolibrary.org/obo/RO_0002437', 1, 'An interaction relationship in which at least one of the partners is an organism and the other is either an organism or an abiotic entity with which the organism interacts.'),
('CO_OCCURS_WITH', 'co occurs with', 'CO_OCCURS_WITH', 'RELATED_TO', 'http://purl.obolibrary.org/obo/RO_0008506', 1, 'An interaction relationship describing organisms that often occur together at the same time and space or in the same environment.'),
('RELATED_TO', 'related to', 'RELATED_TO', '', 'http://purl.obolibrary.org/obo/RO_0002321', 1, 'Ecologically related to');

CREATE TABLE taxon_concept_rel_type (
  id TEXT PRIMARY KEY,
  name TEXT DEFAULT '',
  rcc5 TEXT DEFAULT '',
  description TEXT
);

INSERT INTO
  taxon_concept_rel_type (id, name, rcc5, description)
VALUES
('', '', '', ''),
('EQUALS', 'equals', 'equal (EQ)', 'The circumscription of this taxon is (essentially) identical to the related taxon.'),
('INCLUDES', 'includes', 'proper part inverse (PPi)', 'The related taxon concept is a subset of this taxon concept.'),
('INCLUDED_IN', 'included in', 'proper part (PP)', 'This taxon concept is a subset of the related taxon concept.'),
('OVERLAPS', 'overlaps', 'partially overlapping (PO)', 'Both taxon concepts share some members/children in common, and each contain some members not shared with the other.'),
('EXCLUDES', 'excludes', 'disjoint (DR)', 'The related taxon concept is not a subset of this concept.');

CREATE TABLE gazetteer(
  id TEXT PRIMARY KEY,
  name TEXT,
  title TEXT,
  link TEXT,
  areaLinkTemplate TEXT,
  description TEXT
);

INSERT into gazetteer ( id, name, title, link, areaLinkTemplate, description)
VALUES
('', '', '', '', '', ''),
('TDWG', 'tdwg', 'World Geographical Scheme for Recording Plant Distributions', 'http://www.tdwg.org/standards/109', '', 'World Geographical Scheme for Recording Plant Distributions published by TDWG at level 1, 2, 3 or 4.  Level 1 = Continents, Level 2 = Regions, Level 3 = Botanical countries, Level 4 = Basic recording units.'),
('ISO', 'iso', 'ISO 3166 Country Codes', 'https://en.wikipedia.org/wiki/ISO_3166', 'https://www.iso.org/obp/ui/#iso:code:3166:', 'ISO 3166 codes for the representation of names of countries and their subdivisions. Codes for current countries (ISO 3166-1), country subdivisions (ISO 3166-2) and formerly used names of countries (ISO 3166-3). Country codes can be given either as alpha-2, alpha-3 or numeric codes.'),
('FAO', 'fao', 'FAO Major Fishing Areas', 'http://www.fao.org/fishery/cwp/handbook/H/en', 'https://www.fao.org/fishery/en/area/', 'FAO Major Fishing Areas'),
('LONGHURST', 'longhurst', 'Longhurst Biogeographical Provinces', 'http://www.marineregions.org/sources.php#longhurst', '', 'Longhurst Biogeographical Provinces, a partition of the world oceans into provinces as defined by Longhurst, A.R. (2006). Ecological Geography of the Sea. 2nd Edition.'),
('TEOW', 'teow', 'Terrestrial Ecoregions of the World', 'https://www.worldwildlife.org/publications/terrestrial-ecoregions-of-the-world', '', 'Terrestrial Ecoregions of the World is a biogeographic regionalization of the Earth''s terrestrial biodiversity. See Olson et al. 2001. Terrestrial ecoregions of the world: a new map of life on Earth. Bioscience 51(11):933-938.'),
('IHO', 'iho', 'International Hydrographic Organization See Areas', '', '', 'Sea areas published by the International Hydrographic Organization as boundaries of the major oceans and seas of the world. See Limits of Oceans & Seas, Special Publication No. 23 published by the International Hydrographic Organization in 1953.'),
('MRGID', 'mrgid', 'Marine Regions Geographic Identifier', 'https://www.marineregions.org/gazetteer.php', 'http://marineregions.org/mrgid/', 'Standard, relational list of geographic names developed by VLIZ covering mainly marine names such as seas, sandbanks, ridges, bays or even standard sampling stations used in marine research.The geographic cover is global; however the gazetteer is focused on the Belgian Continental Shelf, the Scheldt Estuary and the Southern Bight of the North Sea.'),
('TEXT', 'text', 'Free Text', '', '', 'Free text not following any standard');

CREATE TABLE rank(
  id TEXT PRIMARY KEY,
  name TEXT DEFAULT '',
  plural TEXT DEFAULT '',
  marker TEXT DEFAULT '',
  major_rank_id TEXT REFERENCES rank,
  ambiguous_marker INTEGER DEFAULT 0, -- bool
  family_group INTEGER DEFAULT 0, -- bool
  genus_group INTEGER DEFAULT 0, -- bool
  infraspecific INTEGER DEFAULT 0, -- bool
  legacy INTEGER DEFAULT 0, -- bool
  linnean INTEGER DEFAULT 0, -- bool
  suprageneric INTEGER DEFAULT 0, -- bool
  supraspecific INTEGER DEFAULT 0, -- bool
  uncomparable INTEGER DEFAULT 0 -- bool
);

INSERT INTO
  rank(
    id,
    name,
    plural,
    marker,
    major_rank_id,
    ambiguous_marker,
    family_group,
    genus_group,
    infraspecific,
    legacy,
    linnean,
    suprageneric,
    supraspecific,
    uncomparable
  )
VALUES
('', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0),
('SUPERDOMAIN', 'superdomain', 'superdomains', 'superdom.', 'DOMAIN', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('DOMAIN', 'domain', 'domains', 'dom.', 'DOMAIN', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBDOMAIN', 'subdomain', 'subdomains', 'subdom.', 'DOMAIN', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRADOMAIN', 'infradomain', 'infradomains', 'infradom.', 'DOMAIN', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('EMPIRE', 'empire', 'empires', 'imp.', 'EMPIRE', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('REALM', 'realm', 'realms', 'realm', 'REALM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBREALM', 'subrealm', 'subrealms', 'subrealm', 'REALM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERKINGDOM', 'superkingdom', 'superkingdoms', 'superreg.', 'KINGDOM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('KINGDOM', 'kingdom', 'kingdoms', 'regn.', 'KINGDOM', 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBKINGDOM', 'subkingdom', 'subkingdoms', 'subreg.', 'KINGDOM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAKINGDOM', 'infrakingdom', 'infrakingdoms', 'infrareg.', 'KINGDOM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERPHYLUM', 'superphylum', 'superphyla', 'superphyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PHYLUM', 'phylum', 'phyla', 'phyl.', 'PHYLUM', 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBPHYLUM', 'subphylum', 'subphyla', 'subphyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAPHYLUM', 'infraphylum', 'infraphyla', 'infraphyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVPHYLUM', 'parvphylum', 'parvphyla', 'parvphyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MICROPHYLUM', 'microphylum', 'microphyla', 'microphyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('NANOPHYLUM', 'nanophylum', 'nanophyla', 'nanophyl.', 'PHYLUM', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('CLAUDIUS', 'claudius', 'claudius', 'claud.', 'CLAUDIUS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GIGACLASS', 'gigaclass', 'gigaclasses', 'gigacl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGACLASS', 'megaclass', 'megaclasses', 'megacl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERCLASS', 'superclass', 'superclasses', 'supercl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('CLASS', 'class', 'classes', 'cl.', 'CLASS', 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBCLASS', 'subclass', 'subclasses', 'subcl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRACLASS', 'infraclass', 'infraclasses', 'infracl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBTERCLASS', 'subterclass', 'subterclasses', 'subtercl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVCLASS', 'parvclass', 'parvclasses', 'parvcl.', 'CLASS', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERDIVISION', 'superdivision', 'superdivisions', 'superdiv.', 'DIVISION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('DIVISION', 'division', 'divisions', 'div.', 'DIVISION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBDIVISION', 'subdivision', 'subdivisions', 'subdiv.', 'DIVISION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRADIVISION', 'infradivision', 'infradivisions', 'infradiv.', 'DIVISION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERLEGION', 'superlegion', 'superlegions', 'superleg.', 'LEGION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('LEGION', 'legion', 'legions', 'leg.', 'LEGION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBLEGION', 'sublegion', 'sublegions', 'subleg.', 'LEGION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRALEGION', 'infralegion', 'infralegions', 'infraleg.', 'LEGION', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGACOHORT', 'megacohort', 'megacohorts', 'megacohort', 'COHORT', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERCOHORT', 'supercohort', 'supercohorts', 'supercohort', 'COHORT', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('COHORT', 'cohort', 'cohorts', 'cohort', 'COHORT', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBCOHORT', 'subcohort', 'subcohorts', 'subcohort', 'COHORT', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRACOHORT', 'infracohort', 'infracohorts', 'infracohort', 'COHORT', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GIGAORDER', 'gigaorder', 'gigaorders', 'gigaord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MAGNORDER', 'magnorder', 'magnorders', 'magnord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GRANDORDER', 'grandorder', 'grandorders', 'grandord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MIRORDER', 'mirorder', 'mirorders', 'mirord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERORDER', 'superorder', 'superorders', 'superord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('ORDER', 'order', 'orders', 'ord.', 'ORDER', 0, 0, 0, 0, 0, 1, 1, 1, 0),
('NANORDER', 'nanorder', 'nanorders', 'nanord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('HYPOORDER', 'hypoorder', 'hypoorders', 'hypoord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MINORDER', 'minorder', 'minorders', 'minord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBORDER', 'suborder', 'suborders', 'subord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAORDER', 'infraorder', 'infraorders', 'infraord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVORDER', 'parvorder', 'parvorders', 'parvord.', 'ORDER', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERSECTION_ZOOLOGY', 'supersection zoology', 'supersection_zoologys', 'supersect.', 'SECTION_ZOOLOGY', 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SECTION_ZOOLOGY', 'section zoology', 'section_zoologys', 'sect.', 'SECTION_ZOOLOGY', 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBSECTION_ZOOLOGY', 'subsection zoology', 'subsection_zoologys', 'subsect.', 'SECTION_ZOOLOGY', 1, 0, 0, 0, 0, 0, 1, 1, 0),
('FALANX', 'falanx', 'falanges', 'falanx', 'FALANX', 0, 0, 0, 0, 1, 0, 1, 1, 0),
('GIGAFAMILY', 'gigafamily', 'gigafamilies', 'gigafam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGAFAMILY', 'megafamily', 'megafamilies', 'megafam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GRANDFAMILY', 'grandfamily', 'grandfamilies', 'grandfam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERFAMILY', 'superfamily', 'superfamilies', 'superfam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('EPIFAMILY', 'epifamily', 'epifamilies', 'epifam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('FAMILY', 'family', 'families', 'fam.', 'FAMILY', 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBFAMILY', 'subfamily', 'subfamilies', 'subfam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAFAMILY', 'infrafamily', 'infrafamilies', 'infrafam.', 'FAMILY', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERTRIBE', 'supertribe', 'supertribes', 'supertrib.', 'TRIBE', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('TRIBE', 'tribe', 'tribes', 'trib.', 'TRIBE', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBTRIBE', 'subtribe', 'subtribes', 'subtrib.', 'TRIBE', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRATRIBE', 'infratribe', 'infratribes', 'infratrib.', 'TRIBE', 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPRAGENERIC_NAME', 'suprageneric name', 'suprageneric_names', 'supragen.', 'SUPRAGENERIC_NAME', 0, 0, 0, 0, 0, 0, 1, 1, 1),
('SUPERGENUS', 'supergenus', 'supergenera', 'supergen.', 'GENUS', 0, 0, 1, 0, 0, 0, 1, 1, 0),
('GENUS', 'genus', 'genera', 'gen.', 'GENUS', 0, 0, 1, 0, 0, 1, 0, 1, 0),
('SUBGENUS', 'subgenus', 'subgenera', 'subgen.', 'GENUS', 0, 0, 1, 0, 0, 0, 0, 1, 0),
('INFRAGENUS', 'infragenus', 'infragenera', 'infrag.', 'GENUS', 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SUPERSECTION_BOTANY', 'supersection botany', 'supersection_botanys', 'supersect.', 'SECTION_BOTANY', 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SECTION_BOTANY', 'section botany', 'section_botanys', 'sect.', 'SECTION_BOTANY', 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SUBSECTION_BOTANY', 'subsection botany', 'subsection_botanys', 'subsect.', 'SECTION_BOTANY', 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SUPERSERIES', 'superseries', 'superseries', 'superser.', 'SERIES', 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SERIES', 'series', 'series', 'ser.', 'SERIES', 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SUBSERIES', 'subseries', 'subseries', 'subser.', 'SERIES', 0, 0, 1, 0, 0, 0, 0, 1, 0),
('INFRAGENERIC_NAME', 'infrageneric name', 'infrageneric_names', 'infragen.', 'GENUS', 0, 0, 1, 0, 0, 0, 0, 1, 1),
('SPECIES_AGGREGATE', 'species aggregate', 'species_aggregates', 'agg.', 'SPECIES', 0, 0, 0, 0, 0, 0, 0, 0, 0),
('SPECIES', 'species', 'species', 'sp.', 'SPECIES', 0, 0, 0, 0, 0, 1, 0, 0, 0),
('INFRASPECIFIC_NAME', 'infraspecific name', 'infraspecific_names', 'infrasp.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 1),
('GREX', 'grex', 'grexs', 'gx', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('KLEPTON', 'klepton', 'kleptons', 'klepton', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('SUBSPECIES', 'subspecies', 'subspecies', 'subsp.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CULTIVAR_GROUP', 'cultivar group', '', '', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CONVARIETY', 'convariety', 'convarieties', 'convar.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('INFRASUBSPECIFIC_NAME', 'infrasubspecific name', 'infrasubspecific_names', 'infrasubsp.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 1),
('PROLES', 'proles', 'proles', 'prol.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('NATIO', 'natio', 'natios', 'natio', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('ABERRATION', 'aberration', 'aberrations', 'ab.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('MORPH', 'morph', 'morphs', 'morph', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('SUPERVARIETY', 'supervariety', 'supervarieties', 'supervar.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('VARIETY', 'variety', 'varieties', 'var.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUBVARIETY', 'subvariety', 'subvarieties', 'subvar.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUPERFORM', 'superform', 'superforms', 'superf.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('FORM', 'form', 'forms', 'f.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUBFORM', 'subform', 'subforms', 'subf.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('PATHOVAR', 'pathovar', 'pathovars', 'pv.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('BIOVAR', 'biovar', 'biovars', 'biovar', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CHEMOVAR', 'chemovar', 'chemovars', 'chemovar', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('MORPHOVAR', 'morphovar', 'morphovars', 'morphovar', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('PHAGOVAR', 'phagovar', 'phagovars', 'phagovar', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SEROVAR', 'serovar', 'serovars', 'serovar', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CHEMOFORM', 'chemoform', 'chemoforms', 'chemoform', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('FORMA_SPECIALIS', 'forma specialis', 'forma_specialiss', 'f.sp.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('LUSUS', 'lusus', 'lusi', 'lusus', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 1, 0, 0, 0, 0),
('CULTIVAR', 'cultivar', 'cultivars', 'cv.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('MUTATIO', 'mutatio', 'mutatios', 'mut.', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('STRAIN', 'strain', 'strains', 'strain', 'INFRASPECIFIC_NAME', 0, 0, 0, 1, 0, 0, 0, 0, 0),
('OTHER', 'other', '', '', 'OTHER', 0, 0, 0, 0, 0, 0, 0, 0, 1),
('UNRANKED', 'unranked', '', '', 'UNRANKED', 0, 0, 0, 0, 0, 0, 0, 0, 1);

CREATE TABLE geo_time (
  id TEXT PRIMARY KEY,
  parent_id TEXT REFERENCES geo_time,
  name TEXT DEFAULT '',
  type TEXT DEFAULT '',
  start REAL DEFAULT 0,
  end REAL);

INSERT INTO
  geo_time (id, name, type, start, end, parent_id)
VALUES
('', '', '', 0, 0, ''),
('HADEAN', 'Hadean', 'eon', 4567.0, 4000.0, 'PRECAMBRIAN'),
('PRECAMBRIAN', 'Precambrian', 'supereon', 4567.0, 541.0, ''),
('ARCHEAN', 'Archean', 'eon', 4000.0, 2500.0, 'PRECAMBRIAN'),
('EOARCHEAN', 'Eoarchean', 'era', 4000.0, 3600.0, 'ARCHEAN'),
('PALEOARCHEAN', 'Paleoarchean', 'era', 3600.0, 3200.0, 'ARCHEAN'),
('MESOARCHEAN', 'Mesoarchean', 'era', 3200.0, 2800.0, 'ARCHEAN'),
('NEOARCHEAN', 'Neoarchean', 'era', 2800.0, 2500.0, 'ARCHEAN'),
('PROTEROZOIC', 'Proterozoic', 'eon', 2500.0, 541.0, 'PRECAMBRIAN'),
('PALEOPROTEROZOIC', 'Paleoproterozoic', 'era', 2500.0, 1600.0, 'PROTEROZOIC'),
('SIDERIAN', 'Siderian', 'period', 2500.0, 2300.0, 'PALEOPROTEROZOIC'),
('RHYACIAN', 'Rhyacian', 'period', 2300.0, 2050.0, 'PALEOPROTEROZOIC'),
('OROSIRIAN', 'Orosirian', 'period', 2050.0, 1800.0, 'PALEOPROTEROZOIC'),
('STATHERIAN', 'Statherian', 'period', 1800.0, 1600.0, 'PALEOPROTEROZOIC'),
('MESOPROTEROZOIC', 'Mesoproterozoic', 'era', 1600.0, 1000.0, 'PROTEROZOIC'),
('CALYMMIAN', 'Calymmian', 'period', 1600.0, 1400.0, 'MESOPROTEROZOIC'),
('ECTASIAN', 'Ectasian', 'period', 1400.0, 1200.0, 'MESOPROTEROZOIC'),
('STENIAN', 'Stenian', 'period', 1200.0, 1000.0, 'MESOPROTEROZOIC'),
('TONIAN', 'Tonian', 'period', 1000.0, 720.0, 'NEOPROTEROZOIC'),
('NEOPROTEROZOIC', 'Neoproterozoic', 'era', 1000.0, 541.0, 'PROTEROZOIC'),
('CRYOGENIAN', 'Cryogenian', 'period', 720.0, 635.0, 'NEOPROTEROZOIC'),
('EDIACARAN', 'Ediacaran', 'period', 635.0, 541.0, 'NEOPROTEROZOIC'),
('CAMBRIAN', 'Cambrian', 'period', 541.0, 485.4, 'PALEOZOIC'),
('FORTUNIAN', 'Fortunian', 'age', 541.0, 529.0, 'TERRENEUVIAN'),
('PALEOZOIC', 'Paleozoic', 'era', 541.0, 251.902, 'PHANEROZOIC'),
('PHANEROZOIC', 'Phanerozoic', 'eon', 541.0, 0.0, ''),
('TERRENEUVIAN', 'Terreneuvian', 'epoch', 541.0, 521.0, 'CAMBRIAN'),
('CAMBRIANSTAGE2', 'CambrianStage2', 'age', 529.0, 521.0, 'TERRENEUVIAN'),
('CAMBRIANSERIES2', 'CambrianSeries2', 'epoch', 521.0, 509.0, 'CAMBRIAN'),
('CAMBRIANSTAGE3', 'CambrianStage3', 'age', 521.0, 514.0, 'CAMBRIANSERIES2'),
('CAMBRIANSTAGE4', 'CambrianStage4', 'age', 514.0, 509.0, 'CAMBRIANSERIES2'),
('WULIUAN', 'Wuliuan', 'age', 509.0, 504.5, 'MIAOLINGIAN'),
('MIAOLINGIAN', 'Miaolingian', 'epoch', 509.0, 497.0, 'CAMBRIAN'),
('DRUMIAN', 'Drumian', 'age', 504.5, 500.5, 'MIAOLINGIAN'),
('GUZHANGIAN', 'Guzhangian', 'age', 500.5, 497.0, 'MIAOLINGIAN'),
('FURONGIAN', 'Furongian', 'epoch', 497.0, 485.4, 'CAMBRIAN'),
('PAIBIAN', 'Paibian', 'age', 497.0, 494.0, 'FURONGIAN'),
('JIANGSHANIAN', 'Jiangshanian', 'age', 494.0, 489.5, 'FURONGIAN'),
('CAMBRIANSTAGE10', 'CambrianStage10', 'age', 489.5, 485.4, 'FURONGIAN'),
('TREMADOCIAN', 'Tremadocian', 'age', 485.4, 477.7, 'LOWER_ORDOVICIAN'),
('LOWER_ORDOVICIAN', 'LowerOrdovician', 'epoch', 485.4, 470.0, 'ORDOVICIAN'),
('ORDOVICIAN', 'Ordovician', 'period', 485.4, 443.8, 'PALEOZOIC'),
('FLOIAN', 'Floian', 'age', 477.7, 470.0, 'LOWER_ORDOVICIAN'),
('DAPINGIAN', 'Dapingian', 'age', 470.0, 467.3, 'MIDDLE_ORDOVICIAN'),
('MIDDLE_ORDOVICIAN', 'MiddleOrdovician', 'epoch', 470.0, 458.4, 'ORDOVICIAN'),
('DARRIWILIAN', 'Darriwilian', 'age', 467.3, 458.4, 'MIDDLE_ORDOVICIAN'),
('SANDBIAN', 'Sandbian', 'age', 458.4, 453.0, 'UPPER_ORDOVICIAN'),
('UPPER_ORDOVICIAN', 'UpperOrdovician', 'epoch', 458.4, 443.8, 'ORDOVICIAN'),
('KATIAN', 'Katian', 'age', 453.0, 445.2, 'UPPER_ORDOVICIAN'),
('HIRNANTIAN', 'Hirnantian', 'age', 445.2, 443.8, 'UPPER_ORDOVICIAN'),
('LLANDOVERY', 'Llandovery', 'epoch', 443.8, 433.4, 'SILURIAN'),
('RHUDDANIAN', 'Rhuddanian', 'age', 443.8, 440.8, 'LLANDOVERY'),
('SILURIAN', 'Silurian', 'period', 443.8, 419.2, 'PALEOZOIC'),
('AERONIAN', 'Aeronian', 'age', 440.8, 438.5, 'LLANDOVERY'),
('TELYCHIAN', 'Telychian', 'age', 438.5, 433.4, 'LLANDOVERY'),
('SHEINWOODIAN', 'Sheinwoodian', 'age', 433.4, 430.5, 'WENLOCK'),
('WENLOCK', 'Wenlock', 'epoch', 433.4, 427.4, 'SILURIAN'),
('HOMERIAN', 'Homerian', 'age', 430.5, 427.4, 'WENLOCK'),
('LUDLOW', 'Ludlow', 'epoch', 427.4, 423.0, 'SILURIAN'),
('GORSTIAN', 'Gorstian', 'age', 427.4, 425.6, 'LUDLOW'),
('LUDFORDIAN', 'Ludfordian', 'age', 425.6, 423.0, 'LUDLOW'),
('PRIDOLI', 'Pridoli', 'age', 423.0, 419.2, 'SILURIAN'),
('DEVONIAN', 'Devonian', 'period', 419.2, 358.9, 'PALEOZOIC'),
('LOWER_DEVONIAN', 'LowerDevonian', 'epoch', 419.2, 393.3, 'DEVONIAN'),
('LOCHKOVIAN', 'Lochkovian', 'age', 419.2, 410.8, 'LOWER_DEVONIAN'),
('PRAGIAN', 'Pragian', 'age', 410.8, 407.6, 'LOWER_DEVONIAN'),
('EMSIAN', 'Emsian', 'age', 407.6, 393.3, 'LOWER_DEVONIAN'),
('EIFELIAN', 'Eifelian', 'age', 393.3, 387.7, 'MIDDLE_DEVONIAN'),
('MIDDLE_DEVONIAN', 'MiddleDevonian', 'epoch', 393.3, 382.7, 'DEVONIAN'),
('GIVETIAN', 'Givetian', 'age', 387.7, 382.7, 'MIDDLE_DEVONIAN'),
('UPPER_DEVONIAN', 'UpperDevonian', 'epoch', 382.7, 358.9, 'DEVONIAN'),
('FRASNIAN', 'Frasnian', 'age', 382.7, 372.2, 'UPPER_DEVONIAN'),
('FAMENNIAN', 'Famennian', 'age', 372.2, 358.9, 'UPPER_DEVONIAN'),
('LOWER_MISSISSIPPIAN', 'LowerMississippian', 'epoch', 358.9, 346.7, 'MISSISSIPPIAN'),
('TOURNAISIAN', 'Tournaisian', 'age', 358.9, 346.7, 'LOWER_MISSISSIPPIAN'),
('MISSISSIPPIAN', 'Mississippian', 'subperiod', 358.9, 323.2, 'CARBONIFEROUS'),
('CARBONIFEROUS', 'Carboniferous', 'period', 358.9, 298.9, 'PALEOZOIC'),
('MIDDLE_MISSISSIPPIAN', 'MiddleMississippian', 'epoch', 346.7, 330.9, 'MISSISSIPPIAN'),
('VISEAN', 'Visean', 'age', 346.7, 330.9, 'MIDDLE_MISSISSIPPIAN'),
('SERPUKHOVIAN', 'Serpukhovian', 'age', 330.9, 323.2, 'UPPER_MISSISSIPPIAN'),
('UPPER_MISSISSIPPIAN', 'UpperMississippian', 'epoch', 330.9, 298.9, 'MISSISSIPPIAN'),
('BASHKIRIAN', 'Bashkirian', 'age', 323.2, 315.2, 'LOWER_PENNSYLVANIAN'),
('PENNSYLVANIAN', 'Pennsylvanian', 'subperiod', 323.2, 298.9, 'CARBONIFEROUS'),
('LOWER_PENNSYLVANIAN', 'LowerPennsylvanian', 'epoch', 323.2, 315.2, 'PENNSYLVANIAN'),
('MIDDLE_PENNSYLVANIAN', 'MiddlePennsylvanian', 'epoch', 315.2, 307.0, 'PENNSYLVANIAN'),
('MOSCOVIAN', 'Moscovian', 'age', 315.2, 307.0, 'MIDDLE_PENNSYLVANIAN'),
('KASIMOVIAN', 'Kasimovian', 'age', 307.0, 303.7, 'UPPER_PENNSYLVANIAN'),
('UPPER_PENNSYLVANIAN', 'UpperPennsylvanian', 'epoch', 307.0, 298.9, 'PENNSYLVANIAN'),
('GZHELIAN', 'Gzhelian', 'age', 303.7, 298.9, 'UPPER_PENNSYLVANIAN'),
('CISURALIAN', 'Cisuralian', 'epoch', 298.9, 272.95, 'PERMIAN'),
('ASSELIAN', 'Asselian', 'age', 298.9, 295.0, 'CISURALIAN'),
('PERMIAN', 'Permian', 'period', 298.9, 251.902, 'PALEOZOIC'),
('SAKMARIAN', 'Sakmarian', 'age', 295.0, 290.1, 'CISURALIAN'),
('ARTINSKIAN', 'Artinskian', 'age', 290.1, 283.5, 'CISURALIAN'),
('KUNGURIAN', 'Kungurian', 'age', 283.5, 272.95, 'CISURALIAN'),
('ROADIAN', 'Roadian', 'age', 272.95, 268.8, 'GUADALUPIAN'),
('GUADALUPIAN', 'Guadalupian', 'epoch', 272.95, 259.1, 'PERMIAN'),
('WORDIAN', 'Wordian', 'age', 268.8, 265.1, 'GUADALUPIAN'),
('CAPITANIAN', 'Capitanian', 'age', 265.1, 259.1, 'GUADALUPIAN'),
('LOPINGIAN', 'Lopingian', 'epoch', 259.1, 251.902, 'PERMIAN'),
('WUCHIAPINGIAN', 'Wuchiapingian', 'age', 259.1, 254.14, 'LOPINGIAN'),
('CHANGHSINGIAN', 'Changhsingian', 'age', 254.14, 251.902, 'LOPINGIAN'),
('INDUAN', 'Induan', 'age', 251.902, 251.2, 'LOWER_TRIASSIC'),
('LOWER_TRIASSIC', 'LowerTriassic', 'epoch', 251.902, 247.2, 'TRIASSIC'),
('MESOZOIC', 'Mesozoic', 'era', 251.902, 66.0, 'PHANEROZOIC'),
('TRIASSIC', 'Triassic', 'period', 251.902, 201.3, 'MESOZOIC'),
('OLENEKIAN', 'Olenekian', 'age', 251.2, 247.2, 'LOWER_TRIASSIC'),
('ANISIAN', 'Anisian', 'age', 247.2, 242.0, 'MIDDLE_TRIASSIC'),
('MIDDLE_TRIASSIC', 'MiddleTriassic', 'epoch', 247.2, 237.0, 'TRIASSIC'),
('LADINIAN', 'Ladinian', 'age', 242.0, 237.0, 'MIDDLE_TRIASSIC'),
('CARNIAN', 'Carnian', 'age', 237.0, 227.0, 'UPPER_TRIASSIC'),
('UPPER_TRIASSIC', 'UpperTriassic', 'epoch', 237.0, 201.3, 'TRIASSIC'),
('NORIAN', 'Norian', 'age', 227.0, 208.5, 'UPPER_TRIASSIC'),
('RHAETIAN', 'Rhaetian', 'age', 208.5, 201.3, 'UPPER_TRIASSIC'),
('JURASSIC', 'Jurassic', 'period', 201.3, 145.0, 'MESOZOIC'),
('HETTANGIAN', 'Hettangian', 'age', 201.3, 199.3, 'LOWER_JURASSIC'),
('LOWER_JURASSIC', 'LowerJurassic', 'epoch', 201.3, 174.1, 'JURASSIC'),
('SINEMURIAN', 'Sinemurian', 'age', 199.3, 190.8, 'LOWER_JURASSIC'),
('PLIENSBACHIAN', 'Pliensbachian', 'age', 190.8, 182.7, 'LOWER_JURASSIC'),
('TOARCIAN', 'Toarcian', 'age', 182.7, 174.1, 'LOWER_JURASSIC'),
('MIDDLE_JURASSIC', 'MiddleJurassic', 'epoch', 174.1, 163.5, 'JURASSIC'),
('AALENIAN', 'Aalenian', 'age', 174.1, 170.3, 'MIDDLE_JURASSIC'),
('BAJOCIAN', 'Bajocian', 'age', 170.3, 168.3, 'MIDDLE_JURASSIC'),
('BATHONIAN', 'Bathonian', 'age', 168.3, 166.1, 'MIDDLE_JURASSIC'),
('CALLOVIAN', 'Callovian', 'age', 166.1, 163.5, 'MIDDLE_JURASSIC'),
('OXFORDIAN', 'Oxfordian', 'age', 163.5, 157.3, 'UPPER_JURASSIC'),
('UPPER_JURASSIC', 'UpperJurassic', 'epoch', 163.5, 145.0, 'JURASSIC'),
('KIMMERIDGIAN', 'Kimmeridgian', 'age', 157.3, 152.1, 'UPPER_JURASSIC'),
('TITHONIAN', 'Tithonian', 'age', 152.1, 145.0, 'UPPER_JURASSIC'),
('LOWER_CRETACEOUS', 'LowerCretaceous', 'epoch', 145.0, 100.5, 'CRETACEOUS'),
('CRETACEOUS', 'Cretaceous', 'period', 145.0, 66.0, 'MESOZOIC'),
('BERRIASIAN', 'Berriasian', 'age', 145.0, 139.8, 'LOWER_CRETACEOUS'),
('VALANGINIAN', 'Valanginian', 'age', 139.8, 132.9, 'LOWER_CRETACEOUS'),
('HAUTERIVIAN', 'Hauterivian', 'age', 132.9, 129.4, 'LOWER_CRETACEOUS'),
('BARREMIAN', 'Barremian', 'age', 129.4, 125.0, 'LOWER_CRETACEOUS'),
('APTIAN', 'Aptian', 'age', 125.0, 113.0, 'LOWER_CRETACEOUS'),
('ALBIAN', 'Albian', 'age', 113.0, 100.5, 'LOWER_CRETACEOUS'),
('CENOMANIAN', 'Cenomanian', 'age', 100.5, 93.9, 'UPPER_CRETACEOUS'),
('UPPER_CRETACEOUS', 'UpperCretaceous', 'epoch', 100.5, 66.0, 'CRETACEOUS'),
('TURONIAN', 'Turonian', 'age', 93.9, 89.8, 'UPPER_CRETACEOUS'),
('CONIACIAN', 'Coniacian', 'age', 89.8, 86.3, 'UPPER_CRETACEOUS'),
('SANTONIAN', 'Santonian', 'age', 86.3, 83.6, 'UPPER_CRETACEOUS'),
('CAMPANIAN', 'Campanian', 'age', 83.6, 72.1, 'UPPER_CRETACEOUS'),
('MAASTRICHTIAN', 'Maastrichtian', 'age', 72.1, 66.0, 'UPPER_CRETACEOUS'),
('PALEOCENE', 'Paleocene', 'epoch', 66.0, 56.0, 'PALEOGENE'),
('PALEOGENE', 'Paleogene', 'period', 66.0, 23.03, 'CENOZOIC'),
('CENOZOIC', 'Cenozoic', 'era', 66.0, 0.0, 'PHANEROZOIC'),
('DANIAN', 'Danian', 'age', 66.0, 61.6, 'PALEOCENE'),
('SELANDIAN', 'Selandian', 'age', 61.6, 59.2, 'PALEOCENE'),
('THANETIAN', 'Thanetian', 'age', 59.2, 56.0, 'PALEOCENE'),
('EOCENE', 'Eocene', 'epoch', 56.0, 33.9, 'PALEOGENE'),
('YPRESIAN', 'Ypresian', 'age', 56.0, 47.8, 'EOCENE'),
('LUTETIAN', 'Lutetian', 'age', 47.8, 41.2, 'EOCENE'),
('BARTONIAN', 'Bartonian', 'age', 41.2, 37.8, 'EOCENE'),
('PRIABONIAN', 'Priabonian', 'age', 37.8, 33.9, 'EOCENE'),
('RUPELIAN', 'Rupelian', 'age', 33.9, 28.1, 'OLIGOCENE'),
('OLIGOCENE', 'Oligocene', 'epoch', 33.9, 23.03, 'PALEOGENE'),
('CHATTIAN', 'Chattian', 'age', 27.82, 23.03, 'OLIGOCENE'),
('AQUITANIAN', 'Aquitanian', 'age', 23.03, 20.44, 'MIOCENE'),
('NEOGENE', 'Neogene', 'period', 23.03, 2.58, 'CENOZOIC'),
('MIOCENE', 'Miocene', 'epoch', 23.03, 5.333, 'NEOGENE'),
('BURDIGALIAN', 'Burdigalian', 'age', 20.44, 15.97, 'MIOCENE'),
('LANGHIAN', 'Langhian', 'age', 15.97, 13.82, 'MIOCENE'),
('SERRAVALLIAN', 'Serravallian', 'age', 13.82, 11.63, 'MIOCENE'),
('TORTONIAN', 'Tortonian', 'age', 11.63, 7.246, 'MIOCENE'),
('MESSINIAN', 'Messinian', 'age', 7.246, 5.333, 'MIOCENE'),
('ZANCLEAN', 'Zanclean', 'age', 5.333, 3.6, 'PLIOCENE'),
('PLIOCENE', 'Pliocene', 'epoch', 5.333, 2.58, 'NEOGENE'),
('PIACENZIAN', 'Piacenzian', 'age', 3.6, 2.58, 'PLIOCENE'),
('QUATERNARY', 'Quaternary', 'period', 2.58, 0.0, 'CENOZOIC'),
('GELASIAN', 'Gelasian', 'age', 2.58, 1.8, 'PLEISTOCENE'),
('PLEISTOCENE', 'Pleistocene', 'epoch', 2.58, 0.0117, 'QUATERNARY'),
('CALABRIAN', 'Calabrian', 'age', 1.8, 0.781, 'PLEISTOCENE'),
('MIDDLE_PLEISTOCENE', 'MiddlePleistocene', 'age', 0.781, 0.126, 'PLEISTOCENE'),
('UPPER_PLEISTOCENE', 'UpperPleistocene', 'age', 0.126, 0.0117, 'PLEISTOCENE'),
('HOLOCENE', 'Holocene', 'epoch', 0.0117, 0.0, 'QUATERNARY'),
('GREENLANDIAN', 'Greenlandian', 'age', 0.0117, 0.0082, 'HOLOCENE'),
('NORTHGRIPPIAN', 'Northgrippian', 'age', 0.0082, 0.0042, 'HOLOCENE'),
('MEGHALAYAN', 'Meghalayan', 'age', 0.0042, 0.0, 'HOLOCENE');



COMMIT;
