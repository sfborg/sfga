PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

CREATE TABLE version (id);

INSERT INTO
  version
VALUES
  ('v0.3.10');

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
  source_id TEXT REFERENCES source,
  parent_id TEXT REFERENCES taxon,
  ordinal INTEGER,
  branch_length INTEGER,
  name_id TEXT REFERENCES name,
  name_phrase TEXT,
  according_to_id TEXT REFERENCES reference,
  according_to_page TEXT,
  according_to_page_link TEXT,
  scrutinizer TEXT,
  scrutinizer_id TEXT, -- ORIC usually
  scrutinizer_date TEXT,
  provisional INTEGER, -- bool
  reference_id TEXT, -- list of references about the taxon hypothesis
  extinct INTEGER, -- bool
  temporal_range_start_id TEXT REFERENCES geo_time,
  temporal_range_end_id TEXT REFERENCES geo_time,
  environment_id TEXT, -- environment ids sep by ','
  species TEXT,
  section TEXT,
  subgenus TEXT,
  subtribe TEXT,
  tribe TEXT,
  subfamily TEXT,
  family TEXT,
  supberfamily TEXT,
  suborder TEXT,
  "order" TEXT,
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

CREATE TABLE name (
  id TEXT PRIMARY KEY,
  alternative_id TEXT,
  source_id TEXT,
  basionym_id TEXT, -- use nom_rel_type instead
  scientific_name TEXT, -- full canonical form
  authorship TEXT, -- verbatim authorship
  rank_id INTEGER REFERENCES rank,
  uninomial TEXT,
  genus TEXT,
  infrageneric_epithet TEXT,
  specific_epithet TEXT,
  infraspecific_epithet TEXT,
  cultivar_epithet TEXT,
  notho_id TEXT, -- ref name_part
  original_spelling INTEGER, -- bool
  combination_authorship TEXT, -- separated by '|'
  combination_authorship_id TEXT, -- separated by '|'
  combination_ex_authorship TEXT, -- separated by '|'
  combination_ex_authorship_id TEXT, -- separated by '|'
  combination_authorship_year TEXT,
  basionym_authorship TEXT, -- separated by '|'
  basionym_authorship_id TEXT, -- separated by '|'
  basionym_ex_authorship TEXT, -- separated by '|'
  basionym_ex_authorship_id TEXT, -- separated by '|'
  basionym_authorship_year TEXT,
  code_id TEXT REFERENCES nom_code,
  status_id TEXT REFERENCES nom_status,
  reference_id TEXT,
  published_in_year TEXT,
  published_in_page TEXT,
  published_in_page_link TEXT,
  gender_id TEXT REFERENCES gender,
  gender_agreement INTEGER, -- bool
  etymology TEXT,
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE TABLE synonym (
  id TEXT PRIMARY KEY,
  taxon_id TEXT REFERENCES taxon,
  source_id TEXT REFERENCES source,
  name_id TEXT REFERENCES name,
  name_phrase TEXT,
  according_to_id TEXT REFERENCES reference,
  status_id TEXT REFERENCES taxonomic_status,
  reference_id TEXT, -- ids, sep by ',' about this synonym
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE TABLE vernacular (
  taxon_id TEXT REFERENCES taxon,
  source_id TEXT REFERENCES source,
  name TEXT,
  transliteration TEXT,
  language TEXT,
  preferred INTEGER, -- bool
  country TEXT,
  area TEXT,
  sex_id TEXT REFERENCES sex,
  reference_id TEXT REFERENCES reference,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE INDEX idx_vernacular_id ON vernacular (taxon_id);

CREATE TABLE reference (
  id TEXT PRIMARY KEY,
  alternative_id TEXT, -- sep by ',', scope:id, id, URI/URN
  source_id TEXT REFERENCES source,
  citation TEXT,
  type TEXT,
  -- author/s in format of either
  -- amily1, given1; family2, given2; ..
  -- or
  -- given1 family1, given2 family2, ...
  author TEXT,
  author_id TEXT, -- 'ref' author, sep ','
  editor TEXT, -- 'ref' author, sep ','
  editor_id TEXT, -- 'ref' author, sep ','
  title TEXT,
  title_short TEXT,
  -- container_author is an author or a parent volume (book, journal) 
  container_author TEXT,
  -- container_title of the parent container
  container_title TEXT,
  -- container_title_short of the parent container
  container_title_short TEXT,
  issued TEXT, -- yyyy-mm-dd
  accessed TEXT, -- yyyy-mm-dd
  -- collection_title of the parent volume
  collection_title TEXT,
  -- collection_editor of the parent volume
  collection_editor TEXT,
  volume TEXT,
  issue TEXT,
  -- edition number
  edition TEXT,
  -- page number
  page INTEGER,
  publisher TEXT,
  publisher_place TEXT,
  -- version of the reference
  version TEXT,
  isbn TEXT,
  issn TEXT,
  doi TEXT,
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE TABLE author (
  id TEXT PRIMARY KEY,
  source_id TEXT REFERENCES source,
  alternative_id TEXT, -- sep by ','
  given TEXT,
  family TEXT,
  -- f. for filius,  Jr., etc
  suffix TEXT,
  abbreviation_botany TEXT,
  alternative_names TEXT, -- separated by '|'
  sex_id TEXT REFERENCES sex,
  country TEXT,
  birth TEXT,
  birth_place TEXT,
  death TEXT,
  affiliation TEXT,
  interest TEXT,
  reference_id TEXT, -- sep by ','
  -- url
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE TABLE name_relation (
  name_id TEXT NOT NULL REFERENCES name,
  related_name_id TEXT REFERENCES name,
  source_id TEXT REFERENCES source,
  -- nom_rel_type enum
  type_id TEXT NOT NULL REFERENCES nom_rel_type,
  -- starting page number for the nomenclatural event
  page INTEGER,
  reference_id TEXT REFERENCES reference,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT
);

CREATE TABLE type_material (
  id TEXT PRIMARY KEY,
  source_id TEXT REFERENCES source(id),
  name_id TEXT NOT NULL REFERENCES name(id),
  citation TEXT,
  status TEXT,
  institution_code TEXT,
  catalog_number TEXT,
  reference_id TEXT REFERENCES reference(id), -- ref reference
  locality TEXT,
  country TEXT,
  latitude REAL,
  longitude REAL,
  altitude INTEGER,
  host TEXT,
  sex_id TEXT REFERENCES sex(id),
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
  gazetteer_id TEXT REFERENCES gazetteer(id),
  status_id TEXT REFERENCES distribution_status(id),
  reference_id TEXT REFERENCES reference(id),
  remarks TEXT
);

CREATE TABLE media (
  taxon_id TEXT NOT NULL REFERENCES taxon(id),
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
  taxon_id TEXT NOT NULL REFERENCES taxon,
  related_taxon_id TEXT,
  source_id TEXT REFERENCES source,
  type TEXT NOT NULL,
  reference_id TEXT,
  remarks TEXT
);

-- ENUMS --

CREATE TABLE nom_code (id TEXT PRIMARY KEY);

INSERT INTO
  nom_code (id)
VALUES
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
  ('GENERIC'),
  ('INFRAGENERIC'),
  ('SPECIFIC'),
  ('INFRASPECIFIC');

CREATE TABLE gender (id TEXT PRIMARY KEY);

INSERT INTO
  gender (id)
VALUES
  ('MASCULINE'),
  ('FEMININE'),
  ('NEUTRAL');

CREATE TABLE sex (id TEXT PRIMARY KEY);

INSERT INTO
  sex (id)
VALUES
  ('MALE'),
  ('FEMALE'),
  ('HERMAPHRODITE');

CREATE TABLE distribution_status (id TEXT PRIMARY KEY);

INSERT INTO
  distribution_status (id)
VALUES
  ('NATIVE'),
  ('DOMESTICATED'),
  ('ALIEN'),
  ('UNCERTAIN');

CREATE TABLE nom_rel_type (id TEXT PRIMARY KEY);

INSERT INTO
  nom_rel_type (id)
VALUES
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
  ('ESTABLISHED'),
  ('ACCEPTABLE'),
  ('UNACCEPTABLE'),
  ('CONSERVED'),
  ('REJECTED'),
  ('DOUBTFUL'),
  ('MANUSCRIPT'),
  ('CHRESONYM');

CREATE TABLE taxonomic_status (
  id TEXT PRIMARY KEY,
  value TEXT,
  name TEXT,
  bare_name INTEGER,
  description TEXT,
  majorStatus TEXT,
  synonym INTEGER,
  taxon INTEGER
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
('ACCEPTED', 'accepted', 0, 'A taxonomically accepted, current name', 1, 0, 1),
('PROVISIONALLY_ACCEPTED', 'provisionally accepted', 0, 'Treated as accepted, but doubtful whether this is correct.', 1, 0, 1),
('SYNONYM', 'synonym', 0, 'Names which point unambiguously at one species (not specifying whether homo- or heterotypic).Synonyms, in the CoL sense, include also orthographic variants and published misspellings.', 3, 1, 0),
('AMBIGUOUS_SYNONYM', 'ambiguous synonym', 0, 'Names which are ambiguous because they point at the current species and one or more others e.g. homonyms, pro-parte synonyms (in other words, names which appear more than in one place in the Catalogue).', 3, 1, 0),
('MISAPPLIED', 'misapplied', 0, 'A misapplied name. Usually accompanied with an accordingTo on the synonym to indicate the source the misapplication can be found in.', 3, 1, 0),
('BARE_NAME', 'bare name', 1, 'A name alone without any usage, neither a synonym nor a taxon.', 6, 0, 0);

CREATE TABLE rank(
  id TEXT PRIMARY KEY,
  name TEXT,
  plural TEXT,
  marker TEXT,
  major_rank_id INTEGER,  -- TODO change to text
  ambiguous_marker INTEGER, -- bool
  family_group INTEGER, -- bool
  genus_group INTEGER, -- bool
  infraspecific INTEGER, -- bool
  legacy INTEGER, -- bool
  linnean INTEGER, -- bool
  suprageneric INTEGER, -- bool
  supraspecific INTEGER, -- bool
  uncomparable INTEGER -- bool
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
('SUPERDOMAIN', 'superdomain', 'superdomains', 'superdom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('DOMAIN', 'domain', 'domains', 'dom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBDOMAIN', 'subdomain', 'subdomains', 'subdom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRADOMAIN', 'infradomain', 'infradomains', 'infradom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('EMPIRE', 'empire', 'empires', 'imp.', 5, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('REALM', 'realm', 'realms', 'realm', 6, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBREALM', 'subrealm', 'subrealms', 'subrealm', 6, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERKINGDOM', 'superkingdom', 'superkingdoms', 'superreg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('KINGDOM', 'kingdom', 'kingdoms', 'regn.', 9, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBKINGDOM', 'subkingdom', 'subkingdoms', 'subreg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAKINGDOM', 'infrakingdom', 'infrakingdoms', 'infrareg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERPHYLUM', 'superphylum', 'superphyla', 'superphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PHYLUM', 'phylum', 'phyla', 'phyl.', 13, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBPHYLUM', 'subphylum', 'subphyla', 'subphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAPHYLUM', 'infraphylum', 'infraphyla', 'infraphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVPHYLUM', 'parvphylum', 'parvphyla', 'parvphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MICROPHYLUM', 'microphylum', 'microphyla', 'microphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('NANOPHYLUM', 'nanophylum', 'nanophyla', 'nanophyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('CLAUDIUS', 'claudius', 'claudius', 'claud.', 19, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GIGACLASS', 'gigaclass', 'gigaclasses', 'gigacl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGACLASS', 'megaclass', 'megaclasses', 'megacl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERCLASS', 'superclass', 'superclasses', 'supercl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('CLASS', 'class', 'classes', 'cl.', 23, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBCLASS', 'subclass', 'subclasses', 'subcl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRACLASS', 'infraclass', 'infraclasses', 'infracl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBTERCLASS', 'subterclass', 'subterclasses', 'subtercl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVCLASS', 'parvclass', 'parvclasses', 'parvcl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERDIVISION', 'superdivision', 'superdivisions', 'superdiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('DIVISION', 'division', 'divisions', 'div.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBDIVISION', 'subdivision', 'subdivisions', 'subdiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRADIVISION', 'infradivision', 'infradivisions', 'infradiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERLEGION', 'superlegion', 'superlegions', 'superleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('LEGION', 'legion', 'legions', 'leg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBLEGION', 'sublegion', 'sublegions', 'subleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRALEGION', 'infralegion', 'infralegions', 'infraleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGACOHORT', 'megacohort', 'megacohorts', 'megacohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERCOHORT', 'supercohort', 'supercohorts', 'supercohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('COHORT', 'cohort', 'cohorts', 'cohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBCOHORT', 'subcohort', 'subcohorts', 'subcohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRACOHORT', 'infracohort', 'infracohorts', 'infracohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GIGAORDER', 'gigaorder', 'gigaorders', 'gigaord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MAGNORDER', 'magnorder', 'magnorders', 'magnord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GRANDORDER', 'grandorder', 'grandorders', 'grandord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MIRORDER', 'mirorder', 'mirorders', 'mirord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERORDER', 'superorder', 'superorders', 'superord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('ORDER', 'order', 'orders', 'ord.', 46, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('NANORDER', 'nanorder', 'nanorders', 'nanord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('HYPOORDER', 'hypoorder', 'hypoorders', 'hypoord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MINORDER', 'minorder', 'minorders', 'minord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBORDER', 'suborder', 'suborders', 'subord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAORDER', 'infraorder', 'infraorders', 'infraord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('PARVORDER', 'parvorder', 'parvorders', 'parvord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERSECTION_ZOOLOGY', 'supersection zoology', 'supersection_zoologys', 'supersect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SECTION_ZOOLOGY', 'section zoology', 'section_zoologys', 'sect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBSECTION_ZOOLOGY', 'subsection zoology', 'subsection_zoologys', 'subsect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('FALANX', 'falanx', 'falanges', 'falanx', 56, 0, 0, 0, 0, 1, 0, 1, 1, 0),
('GIGAFAMILY', 'gigafamily', 'gigafamilies', 'gigafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('MEGAFAMILY', 'megafamily', 'megafamilies', 'megafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('GRANDFAMILY', 'grandfamily', 'grandfamilies', 'grandfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERFAMILY', 'superfamily', 'superfamilies', 'superfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('EPIFAMILY', 'epifamily', 'epifamilies', 'epifam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('FAMILY', 'family', 'families', 'fam.', 62, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('SUBFAMILY', 'subfamily', 'subfamilies', 'subfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRAFAMILY', 'infrafamily', 'infrafamilies', 'infrafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPERTRIBE', 'supertribe', 'supertribes', 'supertrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('TRIBE', 'tribe', 'tribes', 'trib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUBTRIBE', 'subtribe', 'subtribes', 'subtrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('INFRATRIBE', 'infratribe', 'infratribes', 'infratrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SUPRAGENERIC_NAME', 'suprageneric name', 'suprageneric_names', 'supragen.', 69, 0, 0, 0, 0, 0, 0, 1, 1, 1),
('SUPERGENUS', 'supergenus', 'supergenera', 'supergen.', 71, 0, 0, 1, 0, 0, 0, 1, 1, 0),
('GENUS', 'genus', 'genera', 'gen.', 71, 0, 0, 1, 0, 0, 1, 0, 1, 0),
('SUBGENUS', 'subgenus', 'subgenera', 'subgen.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('INFRAGENUS', 'infragenus', 'infragenera', 'infrag.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SUPERSECTION_BOTANY', 'supersection botany', 'supersection_botanys', 'supersect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SECTION_BOTANY', 'section botany', 'section_botanys', 'sect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SUBSECTION_BOTANY', 'subsection botany', 'subsection_botanys', 'subsect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SUPERSERIES', 'superseries', 'superseries', 'superser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SERIES', 'series', 'series', 'ser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SUBSERIES', 'subseries', 'subseries', 'subser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('INFRAGENERIC_NAME', 'infrageneric name', 'infrageneric_names', 'infragen.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 1),
('SPECIES_AGGREGATE', 'species aggregate', 'species_aggregates', 'agg.', 82, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('SPECIES', 'species', 'species', 'sp.', 82, 0, 0, 0, 0, 0, 1, 0, 0, 0),
('INFRASPECIFIC_NAME', 'infraspecific name', 'infraspecific_names', 'infrasp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 1),
('GREX', 'grex', 'grexs', 'gx', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('KLEPTON', 'klepton', 'kleptons', 'klepton', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('SUBSPECIES', 'subspecies', 'subspecies', 'subsp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CULTIVARGROUP', 'cultivar group', '', '', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CONVARIETY', 'convariety', 'convarieties', 'convar.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('INFRASUBSPECIFIC_NAME', 'infrasubspecific name', 'infrasubspecific_names', 'infrasubsp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 1),
('PROLES', 'proles', 'proles', 'prol.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('NATIO', 'natio', 'natios', 'natio', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('ABERRATION', 'aberration', 'aberrations', 'ab.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('MORPH', 'morph', 'morphs', 'morph', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('SUPERVARIETY', 'supervariety', 'supervarieties', 'supervar.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('VARIETY', 'variety', 'varieties', 'var.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUBVARIETY', 'subvariety', 'subvarieties', 'subvar.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUPERFORM', 'superform', 'superforms', 'superf.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('FORM', 'form', 'forms', 'f.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SUBFORM', 'subform', 'subforms', 'subf.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('PATHOVAR', 'pathovar', 'pathovars', 'pv.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('BIOVAR', 'biovar', 'biovars', 'biovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CHEMOVAR', 'chemovar', 'chemovars', 'chemovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('MORPHOVAR', 'morphovar', 'morphovars', 'morphovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('PHAGOVAR', 'phagovar', 'phagovars', 'phagovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('SEROVAR', 'serovar', 'serovars', 'serovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CHEMOFORM', 'chemoform', 'chemoforms', 'chemoform', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('FORMA_SPECIALIS', 'forma specialis', 'forma_specialiss', 'f.sp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('LUSUS', 'lusus', 'lusi', 'lusus', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('CULTIVAR', 'cultivar', 'cultivars', 'cv.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('MUTATIO', 'mutatio', 'mutatios', 'mut.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('STRAIN', 'strain', 'strains', 'strain', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('OTHER', 'other', '', '', 112, 0, 0, 0, 0, 0, 0, 0, 0, 1),
('UNRANKED', 'unranked', '', '', 113, 0, 0, 0, 0, 0, 0, 0, 0, 1);

CREATE TABLE geo_time (id TEXT PRIMARY KEY, parent_id INTEGER, name TEXT, type TEXT, start REAL, END REAL);

INSERT INTO
  geo_time (id, name, type, start, END, parent_id)
VALUES
  ('HADEAN', 'Hadean', 'eon', 4567.0, 4000.0, 2),
  ('PRECAMBRIAN', 'Precambrian', 'supereon', 4567.0, 541.0, 0),
  ('ARCHEAN', 'Archean', 'eon', 4000.0, 2500.0, 2),
  ('EOARCHEAN', 'Eoarchean', 'era', 4000.0, 3600.0, 3),
  ('PALEOARCHEAN', 'Paleoarchean', 'era', 3600.0, 3200.0, 3),
  ('MESOARCHEAN', 'Mesoarchean', 'era', 3200.0, 2800.0, 3),
  ('NEOARCHEAN', 'Neoarchean', 'era', 2800.0, 2500.0, 3),
  ('PROTEROZOIC', 'Proterozoic', 'eon', 2500.0, 541.0, 2),
  ('PALEOPROTEROZOIC', 'Paleoproterozoic', 'era', 2500.0, 1600.0, 8),
  ('SIDERIAN', 'Siderian', 'period', 2500.0, 2300.0, 9),
  ('RHYACIAN', 'Rhyacian', 'period', 2300.0, 2050.0, 9),
  ('OROSIRIAN', 'Orosirian', 'period', 2050.0, 1800.0, 9),
  ('STATHERIAN', 'Statherian', 'period', 1800.0, 1600.0, 9),
  ('MESOPROTEROZOIC', 'Mesoproterozoic', 'era', 1600.0, 1000.0, 8),
  ('CALYMMIAN', 'Calymmian', 'period', 1600.0, 1400.0, 14),
  ('ECTASIAN', 'Ectasian', 'period', 1400.0, 1200.0, 14),
  ('STENIAN', 'Stenian', 'period', 1200.0, 1000.0, 14),
  ('TONIAN', 'Tonian', 'period', 1000.0, 720.0, 19),
  ('NEOPROTEROZOIC', 'Neoproterozoic', 'era', 1000.0, 541.0, 8),
  ('CRYOGENIAN', 'Cryogenian', 'period', 720.0, 635.0, 19),
  ('EDIACARAN', 'Ediacaran', 'period', 635.0, 541.0, 19),
  ('CAMBRIAN', 'Cambrian', 'period', 541.0, 485.4, 24),
  ('FORTUNIAN', 'Fortunian', 'age', 541.0, 529.0, 26),
  ('PALEOZOIC', 'Paleozoic', 'era', 541.0, 251.902, 25),
  ('PHANEROZOIC', 'Phanerozoic', 'eon', 541.0, 0.0, 0),
  ('TERRENEUVIAN', 'Terreneuvian', 'epoch', 541.0, 521.0, 22),
  ('CAMBRIAN_STAGE2', 'CambrianStage', 'age', 529.0, 521.0, 26),
  ('CAMBRIAN_SERIES2', 'CambrianSeries', 'epoch', 521.0, 509.0, 22),
  ('CAMBRIAN_STAGE3', 'CambrianStage', 'age', 521.0, 514.0, 28),
  ('CAMBRIAN_STAGE4', 'CambrianStage', 'age', 514.0, 509.0, 28),
  ('WULIUAN', 'Wuliuan', 'age', 509.0, 504.5, 32),
  ('MIAOLINGIAN', 'Miaolingian', 'epoch', 509.0, 497.0, 22),
  ('DRUMIAN', 'Drumian', 'age', 504.5, 500.5, 32),
  ('GUZHANGIAN', 'Guzhangian', 'age', 500.5, 497.0, 32),
  ('FURONGIAN', 'Furongian', 'epoch', 497.0, 485.4, 22),
  ('PAIBIAN', 'Paibian', 'age', 497.0, 494.0, 35),
  ('JIANGSHANIAN', 'Jiangshanian', 'age', 494.0, 489.5, 35),
  ('CAMBRIAN_STAGE1', 'CambrianStage', 'age', 489.5, 485.4, 35),
  ('TREMADOCIAN', 'Tremadocian', 'age', 485.4, 477.7, 40),
  ('LOWER_ORDOVICIAN', 'LowerOrdovician', 'epoch', 485.4, 470.0, 41),
  ('ORDOVICIAN', 'Ordovician', 'period', 485.4, 443.8, 24),
  ('FLOIAN', 'Floian', 'age', 477.7, 470.0, 40),
  ('DAPINGIAN', 'Dapingian', 'age', 470.0, 467.3, 44),
  ('MIDDLE_ORDOVICIAN', 'MiddleOrdovician', 'epoch', 470.0, 458.4, 41),
  ('DARRIWILIAN', 'Darriwilian', 'age', 467.3, 458.4, 44),
  ('SANDBIAN', 'Sandbian', 'age', 458.4, 453.0, 47),
  ('UPPER_ORDOVICIAN', 'UpperOrdovician', 'epoch', 458.4, 443.8, 41),
  ('KATIAN', 'Katian', 'age', 453.0, 445.2, 47),
  ('HIRNANTIAN', 'Hirnantian', 'age', 445.2, 443.8, 47),
  ('LLANDOVERY', 'Llandovery', 'epoch', 443.8, 433.4, 52),
  ('RHUDDANIAN', 'Rhuddanian', 'age', 443.8, 440.8, 50),
  ('SILURIAN', 'Silurian', 'period', 443.8, 419.2, 24),
  ('AERONIAN', 'Aeronian', 'age', 440.8, 438.5, 50),
  ('TELYCHIAN', 'Telychian', 'age', 438.5, 433.4, 50),
  ('SHEINWOODIAN', 'Sheinwoodian', 'age', 433.4, 430.5, 56),
  ('WENLOCK', 'Wenlock', 'epoch', 433.4, 427.4, 52),
  ('HOMERIAN', 'Homerian', 'age', 430.5, 427.4, 56),
  ('LUDLOW', 'Ludlow', 'epoch', 427.4, 423.0, 52),
  ('GORSTIAN', 'Gorstian', 'age', 427.4, 425.6, 58),
  ('LUDFORDIAN', 'Ludfordian', 'age', 425.6, 423.0, 58),
  ('PRIDOLI', 'Pridoli', 'age', 423.0, 419.2, 52),
  ('DEVONIAN', 'Devonian', 'period', 419.2, 358.9, 24),
  ('LOWER_DEVONIAN', 'LowerDevonian', 'epoch', 419.2, 393.3, 62),
  ('LOCHKOVIAN', 'Lochkovian', 'age', 419.2, 410.8, 63),
  ('PRAGIAN', 'Pragian', 'age', 410.8, 407.6, 63),
  ('EMSIAN', 'Emsian', 'age', 407.6, 393.3, 63),
  ('EIFELIAN', 'Eifelian', 'age', 393.3, 387.7, 68),
  ('MIDDLE_DEVONIAN', 'MiddleDevonian', 'epoch', 393.3, 382.7, 62),
  ('GIVETIAN', 'Givetian', 'age', 387.7, 382.7, 68),
  ('UPPER_DEVONIAN', 'UpperDevonian', 'epoch', 382.7, 358.9, 62),
  ('FRASNIAN', 'Frasnian', 'age', 382.7, 372.2, 70),
  ('FAMENNIAN', 'Famennian', 'age', 372.2, 358.9, 70),
  ('LOWER_MISSISSIPPIAN', 'LowerMississippian', 'epoch', 358.9, 346.7, 75),
  ('TOURNAISIAN', 'Tournaisian', 'age', 358.9, 346.7, 73),
  ('MISSISSIPPIAN', 'Mississippian', 'subperiod', 358.9, 323.2, 76),
  ('CARBONIFEROUS', 'Carboniferous', 'period', 358.9, 298.9, 24),
  ('MIDDLE_MISSISSIPPIAN', 'MiddleMississippian', 'epoch', 346.7, 330.9, 75),
  ('VISEAN', 'Visean', 'age', 346.7, 330.9, 77),
  ('SERPUKHOVIAN', 'Serpukhovian', 'age', 330.9, 323.2, 80),
  ('UPPER_MISSISSIPPIAN', 'UpperMississippian', 'epoch', 330.9, 298.9, 75),
  ('BASHKIRIAN', 'Bashkirian', 'age', 323.2, 315.2, 83),
  ('PENNSYLVANIAN', 'Pennsylvanian', 'subperiod', 323.2, 298.9, 76),
  ('LOWER_PENNSYLVANIAN', 'LowerPennsylvanian', 'epoch', 323.2, 315.2, 82),
  ('MIDDLE_PENNSYLVANIAN', 'MiddlePennsylvanian', 'epoch', 315.2, 307.0, 82),
  ('MOSCOVIAN', 'Moscovian', 'age', 315.2, 307.0, 84),
  ('KASIMOVIAN', 'Kasimovian', 'age', 307.0, 303.7, 87),
  ('UPPER_PENNSYLVANIAN', 'UpperPennsylvanian', 'epoch', 307.0, 298.9, 82),
  ('GZHELIAN', 'Gzhelian', 'age', 303.7, 298.9, 87),
  ('CISURALIAN', 'Cisuralian', 'epoch', 298.9, 272.95, 91),
  ('ASSELIAN', 'Asselian', 'age', 298.9, 295.0, 89),
  ('PERMIAN', 'Permian', 'period', 298.9, 251.902, 24),
  ('SAKMARIAN', 'Sakmarian', 'age', 295.0, 290.1, 89),
  ('ARTINSKIAN', 'Artinskian', 'age', 290.1, 283.5, 89),
  ('KUNGURIAN', 'Kungurian', 'age', 283.5, 272.95, 89),
  ('ROADIAN', 'Roadian', 'age', 272.95, 268.8, 96),
  ('GUADALUPIAN', 'Guadalupian', 'epoch', 272.95, 259.1, 91),
  ('WORDIAN', 'Wordian', 'age', 268.8, 265.1, 96),
  ('CAPITANIAN', 'Capitanian', 'age', 265.1, 259.1, 96),
  ('LOPINGIAN', 'Lopingian', 'epoch', 259.1, 251.902, 91),
  ('WUCHIAPINGIAN', 'Wuchiapingian', 'age', 259.1, 254.14, 99),
  ('CHANGHSINGIAN', 'Changhsingian', 'age', 254.14, 251.902, 99),
  ('INDUAN', 'Induan', 'age', 251.902, 251.2, 103),
  ('LOWER_TRIASSIC', 'LowerTriassic', 'epoch', 251.902, 247.2, 105),
  ('MESOZOIC', 'Mesozoic', 'era', 251.902, 66.0, 25),
  ('TRIASSIC', 'Triassic', 'period', 251.902, 201.3, 104),
  ('OLENEKIAN', 'Olenekian', 'age', 251.2, 247.2, 103),
  ('ANISIAN', 'Anisian', 'age', 247.2, 242.0, 108),
  ('MIDDLE_TRIASSIC', 'MiddleTriassic', 'epoch', 247.2, 237.0, 105),
  ('LADINIAN', 'Ladinian', 'age', 242.0, 237.0, 108),
  ('CARNIAN', 'Carnian', 'age', 237.0, 227.0, 111),
  ('UPPER_TRIASSIC', 'UpperTriassic', 'epoch', 237.0, 201.3, 105),
  ('NORIAN', 'Norian', 'age', 227.0, 208.5, 111),
  ('RHAETIAN', 'Rhaetian', 'age', 208.5, 201.3, 111),
  ('JURASSIC', 'Jurassic', 'period', 201.3, 145.0, 104),
  ('HETTANGIAN', 'Hettangian', 'age', 201.3, 199.3, 116),
  ('LOWER_JURASSIC', 'LowerJurassic', 'epoch', 201.3, 174.1, 114),
  ('SINEMURIAN', 'Sinemurian', 'age', 199.3, 190.8, 116),
  ('PLIENSBACHIAN', 'Pliensbachian', 'age', 190.8, 182.7, 116),
  ('TOARCIAN', 'Toarcian', 'age', 182.7, 174.1, 116),
  ('MIDDLE_JURASSIC', 'MiddleJurassic', 'epoch', 174.1, 163.5, 114),
  ('AALENIAN', 'Aalenian', 'age', 174.1, 170.3, 120),
  ('BAJOCIAN', 'Bajocian', 'age', 170.3, 168.3, 120),
  ('BATHONIAN', 'Bathonian', 'age', 168.3, 166.1, 120),
  ('CALLOVIAN', 'Callovian', 'age', 166.1, 163.5, 120),
  ('OXFORDIAN', 'Oxfordian', 'age', 163.5, 157.3, 126),
  ('UPPERJURASSIC', 'UpperJurassic', 'epoch', 163.5, 145.0, 114),
  ('KIMMERIDGIAN', 'Kimmeridgian', 'age', 157.3, 152.1, 126),
  ('TITHONIAN', 'Tithonian', 'age', 152.1, 145.0, 126),
  ('LOWER_CRETACEOUS', 'LowerCretaceous', 'epoch', 145.0, 100.5, 130),
  ('CRETACEOUS', 'Cretaceous', 'period', 145.0, 66.0, 104),
  ('BERRIASIAN', 'Berriasian', 'age', 145.0, 139.8, 129),
  ('VALANGINIAN', 'Valanginian', 'age', 139.8, 132.9, 129),
  ('HAUTERIVIAN', 'Hauterivian', 'age', 132.9, 129.4, 129),
  ('BARREMIAN', 'Barremian', 'age', 129.4, 125.0, 129),
  ('APTIAN', 'Aptian', 'age', 125.0, 113.0, 129),
  ('ALBIAN', 'Albian', 'age', 113.0, 100.5, 129),
  ('CENOMANIAN', 'Cenomanian', 'age', 100.5, 93.9, 138),
  ('UPPER_CRETACEOUS', 'UpperCretaceous', 'epoch', 100.5, 66.0, 130),
  ('TURONIAN', 'Turonian', 'age', 93.9, 89.8, 138),
  ('CONIACIAN', 'Coniacian', 'age', 89.8, 86.3, 138),
  ('SANTONIAN', 'Santonian', 'age', 86.3, 83.6, 138),
  ('CAMPANIAN', 'Campanian', 'age', 83.6, 72.1, 138),
  ('MAASTRICHTIAN', 'Maastrichtian', 'age', 72.1, 66.0, 138),
  ('PALEOCENE', 'Paleocene', 'epoch', 66.0, 56.0, 145),
  ('PALEOGENE', 'Paleogene', 'period', 66.0, 23.03, 146),
  ('CENOZOIC', 'Cenozoic', 'era', 66.0, 0.0, 25),
  ('DANIAN', 'Danian', 'age', 66.0, 61.6, 144),
  ('SELANDIAN', 'Selandian', 'age', 61.6, 59.2, 144),
  ('THANETIAN', 'Thanetian', 'age', 59.2, 56.0, 144),
  ('EOCENE', 'Eocene', 'epoch', 56.0, 33.9, 145),
  ('YPRESIAN', 'Ypresian', 'age', 56.0, 47.8, 150),
  ('LUTETIAN', 'Lutetian', 'age', 47.8, 41.2, 150),
  ('BARTONIAN', 'Bartonian', 'age', 41.2, 37.8, 150),
  ('PRIABONIAN', 'Priabonian', 'age', 37.8, 33.9, 150),
  ('RUPELIAN', 'Rupelian', 'age', 33.9, 28.1, 156),
  ('OLIGOCENE', 'Oligocene', 'epoch', 33.9, 23.03, 145),
  ('CHATTIAN', 'Chattian', 'age', 27.82, 23.03, 156),
  ('AQUITANIAN', 'Aquitanian', 'age', 23.03, 20.44, 160),
  ('NEOGENE', 'Neogene', 'period', 23.03, 2.58, 146),
  ('MIOCENE', 'Miocene', 'epoch', 23.03, 5.333, 159),
  ('BURDIGALIAN', 'Burdigalian', 'age', 20.44, 15.97, 160),
  ('LANGHIAN', 'Langhian', 'age', 15.97, 13.82, 160),
  ('SERRAVALLIAN', 'Serravallian', 'age', 13.82, 11.63, 160),
  ('TORTONIAN', 'Tortonian', 'age', 11.63, 7.246, 160),
  ('MESSINIAN', 'Messinian', 'age', 7.246, 5.333, 160),
  ('ZANCLEAN', 'Zanclean', 'age', 5.333, 3.6, 167),
  ('PLIOCENE', 'Pliocene', 'epoch', 5.333, 2.58, 159),
  ('PIACENZIAN', 'Piacenzian', 'age', 3.6, 2.58, 167),
  ('QUATERNARY', 'Quaternary', 'period', 2.58, 0.0, 146),
  ('GELASIAN', 'Gelasian', 'age', 2.58, 1.8, 171),
  ('PLEISTOCENE', 'Pleistocene', 'epoch', 2.58, 0.0117, 169),
  ('CALABRIAN', 'Calabrian', 'age', 1.8, 0.781, 171),
  ('MIDDLE_PLEISTOCENE', 'MiddlePleistocene', 'age', 0.781, 0.126, 171),
  ('UPPER_PLEISTOCENE', 'UpperPleistocene', 'age', 0.126, 0.0117, 171),
  ('HOLOCENE', 'Holocene', 'epoch', 0.0117, 0.0, 169),
  ('GREENLANDIAN', 'Greenlandian', 'age', 0.0117, 0.0082, 175),
  ('NORTHGRIPPIAN', 'Northgrippian', 'age', 0.0082, 0.0042, 175),
  ('MEGHALAYAN', 'Meghalayan', 'age', 0.0042, 0.0, 175);

COMMIT;
