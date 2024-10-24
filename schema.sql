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
  source_id TEXT, -- ref source
  parent_id TEXT,
  ordinal INTEGER,
  branch_length INTEGER,
  name_id TEXT, -- ref name
  name_phrase TEXT,
  according_to_id TEXT, -- ref reference
  according_to_page TEXT,
  according_to_page_link TEXT,
  scrutinizer TEXT,
  scrutinizer_id TEXT, -- ORIC usually
  scrutinizer_date TEXT,
  provisional INTEGER, -- bool
  reference_id TEXT, -- list of references about the taxon hypothesis
  extinct INTEGER, -- bool
  temporal_range_start_id INTEGER, -- ref geo_time
  temporal_range_end_id INTEGER, -- ref geo_time
  environment_id INTEGER, -- ref environment
  species TEXT,
  section TEXT,
  subgenus TEXT,
  subtribe TEXT,
  tribe TEXT,
  subfamily TEXT,
  family TEXT,
  supberfamily TEXT,
  suborder TEXT,
  ordr TEXT, -- cannot use keyword `order`
  subclass TEXT,
  class TEXT,
  subphylum TEXT,
  phylum TEXT,
  kingdom TEXT,
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT,
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (parent_id) REFERENCES taxon (id),
  FOREIGN KEY (name_id) REFERENCES name (id),
  FOREIGN KEY (according_to_id) REFERENCES reference (id),
  FOREIGN KEY (temporal_range_start_id) REFERENCES geo_time (id),
  FOREIGN KEY (temporal_range_end_id) REFERENCES geo_time (id),
  FOREIGN KEY (environment_id) REFERENCES environment (id)
);

CREATE TABLE name (
  id TEXT PRIMARY KEY,
  alternative_id TEXT,
  source_id TEXT,
  basionym_id TEXT, -- use nom_rel_type instead
  scientific_name TEXT, -- vull canonical form
  authorship TEXT, -- verbatim authorship
  rank_id INTEGER, -- ref rank
  uninomial TEXT,
  genus TEXT,
  infrageneric_epithet TEXT,
  specific_epithet TEXT,
  infraspecific_epithet TEXT,
  cultivar_epithet TEXT,
  notho_id INTEGER, -- ref name_part
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
  code_id INTEGER, -- ref nom_code
  status_id INTEGER, -- ref nom_status
  reference_id TEXT,
  published_in_year TEXT,
  published_in_page TEXT,
  published_in_page_link TEXT,
  gender_id INTEGER, -- ref gender
  gender_agreement INTEGER, -- bool
  etymology TEXT,
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT,
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (basionym_id) REFERENCES name (id),
  FOREIGN KEY (rank_id) REFERENCES rank(id),
  FOREIGN KEY (notho_id) REFERENCES name_part (id),
  FOREIGN KEY (status_id) REFERENCES nom_status (id),
  FOREIGN KEY (gender_id) REFERENCES gender (id)
);

CREATE TABLE synonym (
  id TEXT PRIMARY KEY,
  taxon_id TEXT, -- ref taxon
  source_id TEXT, -- ref source
  name_id TEXT, -- ref name
  name_phrase TEXT,
  according_to_id TEXT, -- ref reference
  status_id INTEGER, -- ref taxonomic_status
  reference_id TEXT, -- ids, sep by ',' about this synonym
  link TEXT,
  remarks TEXT,
  modified TEXT,
  modified_by TEXT,
  FOREIGN KEY (taxon_id) REFERENCES taxon (id),
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (name_id) REFERENCES name (id),
  FOREIGN KEY (according_to_id) REFERENCES reference (id),
  FOREIGN KEY (status_id) REFERENCES taxonomic_status (id)
);

CREATE TABLE vernacular (
  taxon_id TEXT, -- ref taxon
  source_id TEXT, -- ref source
  name TEXT,
  transliteration TEXT,
  language TEXT,
  preferred INTEGER, -- bool
  country TEXT,
  area TEXT,
  sex_id INTEGER, -- ref sex
  reference_id INTEGER, -- ref reference
  remarks TEXT,
  modified TEXT,
  modified_by TEXT,
  FOREIGN KEY (taxon_id) REFERENCES taxon (id),
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (sex_id) REFERENCES sex (id),
  FOREIGN KEY (reference_id) REFERENCES reference (id)
);

CREATE INDEX idx_vernacular_id ON vernacular (taxon_id);

CREATE TABLE reference (
  id TEXT PRIMARY KEY,
  alternative_id TEXT, -- sep by ',', scope:id, id, URI/URN
  source_id TEXT, -- ref source
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
  modified_by TEXT,
  FOREIGN KEY (source_id) REFERENCES source (id)
);

CREATE TABLE author (
  id TEXT PRIMARY KEY,
  source_id TEXT, -- ref source
  alternative_id TEXT, -- sep by ','
  given TEXT,
  family TEXT,
  -- f. for filius,  Jr., etc
  suffix TEXT,
  abbreviation_botany TEXT,
  alternative_names TEXT, -- separated by '|'
  sex_id INTEGER, -- ref sex
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
  modified_by TEXT,
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (sex_id) REFERENCES sex (id)
);

CREATE TABLE name_relation (
  name_id TEXT NOT NULL, -- ref name
  related_name_id TEXT, -- ref name
  source_id TEXT, -- ref source
  -- nom_rel_type enum
  type_id INTEGER NOT NULL, -- nom_rel_type
  -- starting page number for the nomenclatural event
  page INTEGER,
  reference_id TEXT, -- ref reference
  remarks TEXT,
  modified TEXT,
  modified_by TEXT,
  FOREIGN KEY (name_id) REFERENCES name (id),
  FOREIGN KEY (related_name_id) REFERENCES name (id),
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (type_id) REFERENCES nom_rel_type (id),
  FOREIGN KEY (reference_id) REFERENCES reference (id)
);

CREATE TABLE type_material (
  id TEXT PRIMARY KEY,
  source_id TEXT, -- ref source
  name_id TEXT NOT NULL, -- ref name
  citation TEXT,
  status TEXT,
  institution_code TEXT,
  catalog_number TEXT,
  reference_id TEXT, -- ref reference
  locality TEXT,
  country TEXT,
  latitude REAL,
  longitude REAL,
  altitude INTEGER,
  host TEXT,
  sex_id INTEGER, -- ref sex
  date TEXT,
  collector TEXT,
  associated_sequences TEXT,
  link TEXT,
  remarks TEXT,
  FOREIGN KEY (name_id) REFERENCES name (id),
  FOREIGN KEY (reference_id) REFERENCES reference (id),
  FOREIGN KEY (sex_id) REFERENCES sex (id)
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

-- ENUMS --

CREATE TABLE nom_code (id TEXT PRIMARY KEY);

INSERT INTO
  nom_code (id)
VALUES
  ('Bacterial'),
  ('Botanical'),
  ('Cultivars'),
  ('Phytosociological'),
  ('Virus'),
  ('Zoological');

CREATE TABLE name_part (id TEXTZ PRIMARY KEY);

INSERT INTO
  name_part (id)
VALUES
  ('Generic'),
  ('Infrageneric'),
  ('Specific'),
  ('Infraspecific');

CREATE TABLE gender (id TEXT PRIMARY KEY);

INSERT INTO
  gender (id)
VALUES
  ('Masculine'),
  ('Feminine'),
  ('Neutral');

CREATE TABLE sex (id TEXT PRIMARY KEY);

INSERT INTO
  sex (id)
VALUES
  ('Female'),
  ('Male'),
  ('Hermaphrodite');

CREATE TABLE nom_rel_type (id TEXT PRIMARY KEY);

INSERT INTO
  nom_rel_type (id)
VALUES
  ('SpellingCorrection'),
  ('Basionym'),
  ('BasedOn'),
  ('ReplacementName'),
  ('Conserved'),
  ('LaterHomonym'),
  ('Superfluous'),
  ('Homotypic'),
  ('Type');

CREATE TABLE nom_status (id TEXT PRIMARY KEY);

INSERT INTO
  nom_status (id)
VALUES
  ('Established'),
  ('Acceptable'),
  ('Unacceptable'),
  ('Conserved'),
  ('Rejected'),
  ('Doubtful'),
  ('Manuscript'),
  ('Chresonym');

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
('Accepted', 'accepted', 0, 'A taxonomically accepted, current name', 1, 0, 1),
('ProvisionallyAccepted', 'provisionally accepted', 0, 'Treated as accepted, but doubtful whether this is correct.', 1, 0, 1),
('Synonym', 'synonym', 0, 'Names which point unambiguously at one species (not specifying whether homo- or heterotypic).Synonyms, in the CoL sense, include also orthographic variants and published misspellings.', 3, 1, 0),
('AmbiguousSynonym', 'ambiguous synonym', 0, 'Names which are ambiguous because they point at the current species and one or more others e.g. homonyms, pro-parte synonyms (in other words, names which appear more than in one place in the Catalogue).', 3, 1, 0),
('Misapplied', 'misapplied', 0, 'A misapplied name. Usually accompanied with an accordingTo on the synonym to indicate the source the misapplication can be found in.', 3, 1, 0),
('BareName', 'bare name', 1, 'A name alone without any usage, neither a synonym nor a taxon.', 6, 0, 0);

CREATE TABLE rank(
  id TEXT PRIMARY KEY,
  name TEXT,
  plural TEXT,
  marker TEXt,
  major_rank_id INTEGER,
  ambiguous_marker INTEGER,
  family_group INTEGER,
  genus_group INTEGER,
  infraspecific INTEGER,
  legacy INTEGER,
  linnean INTEGER,
  suprageneric INTEGER,
  supraspecific INTEGER,
  uncomparable INTEGER
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
('Superdomain', 'superdomain', 'superdomains', 'superdom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Domain', 'domain', 'domains', 'dom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subdomain', 'subdomain', 'subdomains', 'subdom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infradomain', 'infradomain', 'infradomains', 'infradom.', 2, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Empire', 'empire', 'empires', 'imp.', 5, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Realm', 'realm', 'realms', 'realm', 6, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subrealm', 'subrealm', 'subrealms', 'subrealm', 6, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superkingdom', 'superkingdom', 'superkingdoms', 'superreg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Kingdom', 'kingdom', 'kingdoms', 'regn.', 9, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('Subkingdom', 'subkingdom', 'subkingdoms', 'subreg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infrakingdom', 'infrakingdom', 'infrakingdoms', 'infrareg.', 9, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superphylum', 'superphylum', 'superphyla', 'superphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Phylum', 'phylum', 'phyla', 'phyl.', 13, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('Subphylum', 'subphylum', 'subphyla', 'subphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infraphylum', 'infraphylum', 'infraphyla', 'infraphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Parvphylum', 'parvphylum', 'parvphyla', 'parvphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Microphylum', 'microphylum', 'microphyla', 'microphyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Nanophylum', 'nanophylum', 'nanophyla', 'nanophyl.', 13, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Claudius', 'claudius', 'claudius', 'claud.', 19, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Gigaclass', 'gigaclass', 'gigaclasses', 'gigacl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Megaclass', 'megaclass', 'megaclasses', 'megacl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superclass', 'superclass', 'superclasses', 'supercl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Class', 'class', 'classes', 'cl.', 23, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('subclass', 'subclass', 'subclasses', 'subcl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infraclass', 'infraclass', 'infraclasses', 'infracl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subterclass', 'subterclass', 'subterclasses', 'subtercl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Parvclass', 'parvclass', 'parvclasses', 'parvcl.', 23, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superdivision', 'superdivision', 'superdivisions', 'superdiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Division', 'division', 'divisions', 'div.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subdivision', 'subdivision', 'subdivisions', 'subdiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infradivision', 'infradivision', 'infradivisions', 'infradiv.', 29, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superlegion', 'superlegion', 'superlegions', 'superleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Legion', 'legion', 'legions', 'leg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Sublegion', 'sublegion', 'sublegions', 'subleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infralegion', 'infralegion', 'infralegions', 'infraleg.', 33, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Megacohort', 'megacohort', 'megacohorts', 'megacohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Supercohort', 'supercohort', 'supercohorts', 'supercohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Cohort', 'cohort', 'cohorts', 'cohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subcohort', 'subcohort', 'subcohorts', 'subcohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infracohort', 'infracohort', 'infracohorts', 'infracohort', 38, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Gigaorder', 'gigaorder', 'gigaorders', 'gigaord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Magnorder', 'magnorder', 'magnorders', 'magnord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Grandorder', 'grandorder', 'grandorders', 'grandord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Mirorder', 'mirorder', 'mirorders', 'mirord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superorder', 'superorder', 'superorders', 'superord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Order', 'order', 'orders', 'ord.', 46, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('Nanorder', 'nanorder', 'nanorders', 'nanord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Hypoorder', 'hypoorder', 'hypoorders', 'hypoord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Minorder', 'minorder', 'minorders', 'minord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Suborder', 'suborder', 'suborders', 'subord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infraorder', 'infraorder', 'infraorders', 'infraord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Parvorder', 'parvorder', 'parvorders', 'parvord.', 46, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SupersectionZoology', 'supersection zoology', 'supersection_zoologys', 'supersect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SectionZoology', 'section zoology', 'section_zoologys', 'sect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('SubsectionZoology', 'subsection zoology', 'subsection_zoologys', 'subsect.', 54, 1, 0, 0, 0, 0, 0, 1, 1, 0),
('Falanx', 'falanx', 'falanges', 'falanx', 56, 0, 0, 0, 0, 1, 0, 1, 1, 0),
('Gigafamily', 'gigafamily', 'gigafamilies', 'gigafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Megafamily', 'megafamily', 'megafamilies', 'megafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Grandfamily', 'grandfamily', 'grandfamilies', 'grandfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Superfamily', 'superfamily', 'superfamilies', 'superfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Epifamily', 'epifamily', 'epifamilies', 'epifam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Family', 'family', 'families', 'fam.', 62, 0, 0, 0, 0, 0, 1, 1, 1, 0),
('Subfamily', 'subfamily', 'subfamilies', 'subfam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infrafamily', 'infrafamily', 'infrafamilies', 'infrafam.', 62, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Supertribe', 'supertribe', 'supertribes', 'supertrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Tribe', 'tribe', 'tribes', 'trib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Subtribe', 'subtribe', 'subtribes', 'subtrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('Infratribe', 'infratribe', 'infratribes', 'infratrib.', 66, 0, 0, 0, 0, 0, 0, 1, 1, 0),
('SupragenericName', 'suprageneric name', 'suprageneric_names', 'supragen.', 69, 0, 0, 0, 0, 0, 0, 1, 1, 1),
('Supergenus', 'supergenus', 'supergenera', 'supergen.', 71, 0, 0, 1, 0, 0, 0, 1, 1, 0),
('Genus', 'genus', 'genera', 'gen.', 71, 0, 0, 1, 0, 0, 1, 0, 1, 0),
('Subgenus', 'subgenus', 'subgenera', 'subgen.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('Infragenus', 'infragenus', 'infragenera', 'infrag.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('SupersectionBotany', 'supersection botany', 'supersection_botanys', 'supersect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SectionBotany', 'section botany', 'section_botanys', 'sect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('SubsectionBotany', 'subsection botany', 'subsection_botanys', 'subsect.', 75, 1, 0, 1, 0, 0, 0, 0, 1, 0),
('Superseries', 'superseries', 'superseries', 'superser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('Series', 'series', 'series', 'ser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('Subseries', 'subseries', 'subseries', 'subser.', 78, 0, 0, 1, 0, 0, 0, 0, 1, 0),
('InfragenericName', 'infrageneric name', 'infrageneric_names', 'infragen.', 71, 0, 0, 1, 0, 0, 0, 0, 1, 1),
('SpeciesAggregate', 'species aggregate', 'species_aggregates', 'agg.', 82, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('Species', 'species', 'species', 'sp.', 82, 0, 0, 0, 0, 0, 1, 0, 0, 0),
('InfraspecificName', 'infraspecific name', 'infraspecific_names', 'infrasp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 1),
('Grex', 'grex', 'grexs', 'gx', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Klepton', 'klepton', 'kleptons', 'klepton', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Subspecies', 'subspecies', 'subspecies', 'subsp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('CultivarGroup', 'cultivar group', '', '', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Convariety', 'convariety', 'convarieties', 'convar.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('InfrasubspecificName', 'infrasubspecific name', 'infrasubspecific_names', 'infrasubsp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 1),
('Proles', 'proles', 'proles', 'prol.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Natio', 'natio', 'natios', 'natio', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Aberration', 'aberration', 'aberrations', 'ab.', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Morph', 'morph', 'morphs', 'morph', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Supervariety', 'supervariety', 'supervarieties', 'supervar.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Variety', 'variety', 'varieties', 'var.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Subvariety', 'subvariety', 'subvarieties', 'subvar.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Superform', 'superform', 'superforms', 'superf.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Form', 'form', 'forms', 'f.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Subform', 'subform', 'subforms', 'subf.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Pathovar', 'pathovar', 'pathovars', 'pv.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Biovar', 'biovar', 'biovars', 'biovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Chemovar', 'chemovar', 'chemovars', 'chemovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Morphovar', 'morphovar', 'morphovars', 'morphovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Phagovar', 'phagovar', 'phagovars', 'phagovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Serovar', 'serovar', 'serovars', 'serovar', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Chemoform', 'chemoform', 'chemoforms', 'chemoform', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('FormaSpecialis', 'forma specialis', 'forma_specialiss', 'f.sp.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Lusus', 'lusus', 'lusi', 'lusus', 83, 0, 0, 0, 1, 1, 0, 0, 0, 0),
('Cultivar', 'cultivar', 'cultivars', 'cv.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Mutatio', 'mutatio', 'mutatios', 'mut.', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Strain', 'strain', 'strains', 'strain', 83, 0, 0, 0, 1, 0, 0, 0, 0, 0),
('Other', 'other', '', '', 112, 0, 0, 0, 0, 0, 0, 0, 0, 1),
('Unranked', 'unranked', '', '', 113, 0, 0, 0, 0, 0, 0, 0, 0, 1),
CREATE TABLE geo_time (id TEXT PRIMARY KEY, parent_id INTEGER, name TEXT, type TEXT, start REAL, END REAL);

INSERT INTO
  geo_time (id, name, type, start, END, parent_id)
VALUES
  ('Hadean', 'Hadean', 'eon', 4567.0, 4000.0, 2),
  ('Precambrian', 'Precambrian', 'supereon', 4567.0, 541.0,),
  ('Archean', 'Archean', 'eon', 4000.0, 2500.0, 2),
  ('Eoarchean', 'Eoarchean', 'era', 4000.0, 3600.0, 3),
  ('Paleoarchean', 'Paleoarchean', 'era', 3600.0, 3200.0, 3),
  ('Mesoarchean', 'Mesoarchean', 'era', 3200.0, 2800.0, 3),
  ('Neoarchean', 'Neoarchean', 'era', 2800.0, 2500.0, 3),
  ('Proterozoic', 'Proterozoic', 'eon', 2500.0, 541.0, 2),
  ('Paleoproterozoic', 'Paleoproterozoic', 'era', 2500.0, 1600.0, 8),
  ('Siderian', 'Siderian', 'period', 2500.0, 2300.0, 9),
  ('Rhyacian', 'Rhyacian', 'period', 2300.0, 2050.0, 9),
  ('Orosirian', 'Orosirian', 'period', 2050.0, 1800.0, 9),
  ('Statherian', 'Statherian', 'period', 1800.0, 1600.0, 9),
  ('Mesoproterozoic', 'Mesoproterozoic', 'era', 1600.0, 1000.0, 8),
  ('Calymmian', 'Calymmian', 'period', 1600.0, 1400.0, 14),
  ('Ectasian', 'Ectasian', 'period', 1400.0, 1200.0, 14),
  ('Stenian', 'Stenian', 'period', 1200.0, 1000.0, 14),
  ('Tonian', 'Tonian', 'period', 1000.0, 720.0, 19),
  ('Neoproterozoic', 'Neoproterozoic', 'era', 1000.0, 541.0, 8),
  ('Cryogenian', 'Cryogenian', 'period', 720.0, 635.0, 19),
  ('Ediacaran', 'Ediacaran', 'period', 635.0, 541.0, 19),
  ('Cambrian', 'Cambrian', 'period', 541.0, 485.4, 24),
  ('Fortunian', 'Fortunian', 'age', 541.0, 529.0, 26),
  ('Paleozoic', 'Paleozoic', 'era', 541.0, 251.902, 25),
  ('Phanerozoic', 'Phanerozoic', 'eon', 541.0, 0.0,),
  ('Terreneuvian', 'Terreneuvian', 'epoch', 541.0, 521.0, 22),
  ('CambrianStage2', 'CambrianStage', 'age', 529.0, 521.0, 26),
  ('CambrianSeries2', 'CambrianSeries', 'epoch', 521.0, 509.0, 22),
  ('CambrianStage3', 'CambrianStage', 'age', 521.0, 514.0, 28),
  ('CambrianStage4', 'CambrianStage', 'age', 514.0, 509.0, 28),
  ('Wuliuan', 'Wuliuan', 'age', 509.0, 504.5, 32),
  ('Miaolingian', 'Miaolingian', 'epoch', 509.0, 497.0, 22),
  ('Drumian', 'Drumian', 'age', 504.5, 500.5, 32),
  ('Guzhangian', 'Guzhangian', 'age', 500.5, 497.0, 32),
  ('Furongian', 'Furongian', 'epoch', 497.0, 485.4, 22),
  ('Paibian', 'Paibian', 'age', 497.0, 494.0, 35),
  ('Jiangshanian', 'Jiangshanian', 'age', 494.0, 489.5, 35),
  ('CambrianStage1', 'CambrianStage', 'age', 489.5, 485.4, 35),
  ('Tremadocian', 'Tremadocian', 'age', 485.4, 477.7, 40),
  ('LowerOrdovician', 'LowerOrdovician', 'epoch', 485.4, 470.0, 41),
  ('Ordovician', 'Ordovician', 'period', 485.4, 443.8, 24),
  ('Floian', 'Floian', 'age', 477.7, 470.0, 40),
  ('Dapingian', 'Dapingian', 'age', 470.0, 467.3, 44),
  ('MiddleOrdovician', 'MiddleOrdovician', 'epoch', 470.0, 458.4, 41),
  ('Darriwilian', 'Darriwilian', 'age', 467.3, 458.4, 44),
  ('Sandbian', 'Sandbian', 'age', 458.4, 453.0, 47),
  ('UpperOrdovician', 'UpperOrdovician', 'epoch', 458.4, 443.8, 41),
  ('Katian', 'Katian', 'age', 453.0, 445.2, 47),
  ('Hirnantian', 'Hirnantian', 'age', 445.2, 443.8, 47),
  ('Llandovery', 'Llandovery', 'epoch', 443.8, 433.4, 52),
  ('Rhuddanian', 'Rhuddanian', 'age', 443.8, 440.8, 50),
  ('Silurian', 'Silurian', 'period', 443.8, 419.2, 24),
  ('Aeronian', 'Aeronian', 'age', 440.8, 438.5, 50),
  ('Telychian', 'Telychian', 'age', 438.5, 433.4, 50),
  ('Sheinwoodian', 'Sheinwoodian', 'age', 433.4, 430.5, 56),
  ('Wenlock', 'Wenlock', 'epoch', 433.4, 427.4, 52),
  ('Homerian', 'Homerian', 'age', 430.5, 427.4, 56),
  ('Ludlow', 'Ludlow', 'epoch', 427.4, 423.0, 52),
  ('Gorstian', 'Gorstian', 'age', 427.4, 425.6, 58),
  ('Ludfordian', 'Ludfordian', 'age', 425.6, 423.0, 58),
  ('Pridoli', 'Pridoli', 'age', 423.0, 419.2, 52),
  ('Devonian', 'Devonian', 'period', 419.2, 358.9, 24),
  ('LowerDevonian', 'LowerDevonian', 'epoch', 419.2, 393.3, 62),
  ('Lochkovian', 'Lochkovian', 'age', 419.2, 410.8, 63),
  ('Pragian', 'Pragian', 'age', 410.8, 407.6, 63),
  ('Emsian', 'Emsian', 'age', 407.6, 393.3, 63),
  ('Eifelian', 'Eifelian', 'age', 393.3, 387.7, 68),
  ('MiddleDevonian', 'MiddleDevonian', 'epoch', 393.3, 382.7, 62),
  ('Givetian', 'Givetian', 'age', 387.7, 382.7, 68),
  ('UpperDevonian', 'UpperDevonian', 'epoch', 382.7, 358.9, 62),
  ('Frasnian', 'Frasnian', 'age', 382.7, 372.2, 70),
  ('Famennian', 'Famennian', 'age', 372.2, 358.9, 70),
  ('LowerMississippian', 'LowerMississippian', 'epoch', 358.9, 346.7, 75),
  ('Tournaisian', 'Tournaisian', 'age', 358.9, 346.7, 73),
  ('Mississippian', 'Mississippian', 'subperiod', 358.9, 323.2, 76),
  ('Carboniferous', 'Carboniferous', 'period', 358.9, 298.9, 24),
  ('MiddleMississippian', 'MiddleMississippian', 'epoch', 346.7, 330.9, 75),
  ('Visean', 'Visean', 'age', 346.7, 330.9, 77),
  ('Serpukhovian', 'Serpukhovian', 'age', 330.9, 323.2, 80),
  ('UpperMississippian', 'UpperMississippian', 'epoch', 330.9, 298.9, 75),
  ('Bashkirian', 'Bashkirian', 'age', 323.2, 315.2, 83),
  ('Pennsylvanian', 'Pennsylvanian', 'subperiod', 323.2, 298.9, 76),
  ('LowerPennsylvanian', 'LowerPennsylvanian', 'epoch', 323.2, 315.2, 82),
  ('MiddlePennsylvanian', 'MiddlePennsylvanian', 'epoch', 315.2, 307.0, 82),
  ('Moscovian', 'Moscovian', 'age', 315.2, 307.0, 84),
  ('Kasimovian', 'Kasimovian', 'age', 307.0, 303.7, 87),
  ('UpperPennsylvanian', 'UpperPennsylvanian', 'epoch', 307.0, 298.9, 82),
  ('Gzhelian', 'Gzhelian', 'age', 303.7, 298.9, 87),
  ('Cisuralian', 'Cisuralian', 'epoch', 298.9, 272.95, 91),
  ('Asselian', 'Asselian', 'age', 298.9, 295.0, 89),
  ('Permian', 'Permian', 'period', 298.9, 251.902, 24),
  ('Sakmarian', 'Sakmarian', 'age', 295.0, 290.1, 89),
  ('Artinskian', 'Artinskian', 'age', 290.1, 283.5, 89),
  ('Kungurian', 'Kungurian', 'age', 283.5, 272.95, 89),
  ('Roadian', 'Roadian', 'age', 272.95, 268.8, 96),
  ('Guadalupian', 'Guadalupian', 'epoch', 272.95, 259.1, 91),
  ('Wordian', 'Wordian', 'age', 268.8, 265.1, 96),
  ('Capitanian', 'Capitanian', 'age', 265.1, 259.1, 96),
  ('Lopingian', 'Lopingian', 'epoch', 259.1, 251.902, 91),
  ('Wuchiapingian', 'Wuchiapingian', 'age', 259.1, 254.14, 99),
  ('Changhsingian', 'Changhsingian', 'age', 254.14, 251.902, 99),
  ('Induan', 'Induan', 'age', 251.902, 251.2, 103),
  ('LowerTriassic', 'LowerTriassic', 'epoch', 251.902, 247.2, 105),
  ('Mesozoic', 'Mesozoic', 'era', 251.902, 66.0, 25),
  ('Triassic', 'Triassic', 'period', 251.902, 201.3, 104),
  ('Olenekian', 'Olenekian', 'age', 251.2, 247.2, 103),
  ('Anisian', 'Anisian', 'age', 247.2, 242.0, 108),
  ('MiddleTriassic', 'MiddleTriassic', 'epoch', 247.2, 237.0, 105),
  ('Ladinian', 'Ladinian', 'age', 242.0, 237.0, 108),
  ('Carnian', 'Carnian', 'age', 237.0, 227.0, 111),
  ('UpperTriassic', 'UpperTriassic', 'epoch', 237.0, 201.3, 105),
  ('Norian', 'Norian', 'age', 227.0, 208.5, 111),
  ('Rhaetian', 'Rhaetian', 'age', 208.5, 201.3, 111),
  ('Jurassic', 'Jurassic', 'period', 201.3, 145.0, 104),
  ('Hettangian', 'Hettangian', 'age', 201.3, 199.3, 116),
  ('LowerJurassic', 'LowerJurassic', 'epoch', 201.3, 174.1, 114),
  ('Sinemurian', 'Sinemurian', 'age', 199.3, 190.8, 116),
  ('Pliensbachian', 'Pliensbachian', 'age', 190.8, 182.7, 116),
  ('Toarcian', 'Toarcian', 'age', 182.7, 174.1, 116),
  ('MiddleJurassic', 'MiddleJurassic', 'epoch', 174.1, 163.5, 114),
  ('Aalenian', 'Aalenian', 'age', 174.1, 170.3, 120),
  ('Bajocian', 'Bajocian', 'age', 170.3, 168.3, 120),
  ('Bathonian', 'Bathonian', 'age', 168.3, 166.1, 120),
  ('Callovian', 'Callovian', 'age', 166.1, 163.5, 120),
  ('Oxfordian', 'Oxfordian', 'age', 163.5, 157.3, 126),
  ('UpperJurassic', 'UpperJurassic', 'epoch', 163.5, 145.0, 114),
  ('Kimmeridgian', 'Kimmeridgian', 'age', 157.3, 152.1, 126),
  ('Tithonian', 'Tithonian', 'age', 152.1, 145.0, 126),
  ('LowerCretaceous', 'LowerCretaceous', 'epoch', 145.0, 100.5, 130),
  ('Cretaceous', 'Cretaceous', 'period', 145.0, 66.0, 104),
  ('Berriasian', 'Berriasian', 'age', 145.0, 139.8, 129),
  ('Valanginian', 'Valanginian', 'age', 139.8, 132.9, 129),
  ('Hauterivian', 'Hauterivian', 'age', 132.9, 129.4, 129),
  ('Barremian', 'Barremian', 'age', 129.4, 125.0, 129),
  ('Aptian', 'Aptian', 'age', 125.0, 113.0, 129),
  ('Albian', 'Albian', 'age', 113.0, 100.5, 129),
  ('Cenomanian', 'Cenomanian', 'age', 100.5, 93.9, 138),
  ('UpperCretaceous', 'UpperCretaceous', 'epoch', 100.5, 66.0, 130),
  ('Turonian', 'Turonian', 'age', 93.9, 89.8, 138),
  ('Coniacian', 'Coniacian', 'age', 89.8, 86.3, 138),
  ('Santonian', 'Santonian', 'age', 86.3, 83.6, 138),
  ('Campanian', 'Campanian', 'age', 83.6, 72.1, 138),
  ('Maastrichtian', 'Maastrichtian', 'age', 72.1, 66.0, 138),
  ('Paleocene', 'Paleocene', 'epoch', 66.0, 56.0, 145),
  ('Paleogene', 'Paleogene', 'period', 66.0, 23.03, 146),
  ('Cenozoic', 'Cenozoic', 'era', 66.0, 0.0, 25),
  ('Danian', 'Danian', 'age', 66.0, 61.6, 144),
  ('Selandian', 'Selandian', 'age', 61.6, 59.2, 144),
  ('Thanetian', 'Thanetian', 'age', 59.2, 56.0, 144),
  ('Eocene', 'Eocene', 'epoch', 56.0, 33.9, 145),
  ('Ypresian', 'Ypresian', 'age', 56.0, 47.8, 150),
  ('Lutetian', 'Lutetian', 'age', 47.8, 41.2, 150),
  ('Bartonian', 'Bartonian', 'age', 41.2, 37.8, 150),
  ('Priabonian', 'Priabonian', 'age', 37.8, 33.9, 150),
  ('Rupelian', 'Rupelian', 'age', 33.9, 28.1, 156),
  ('Oligocene', 'Oligocene', 'epoch', 33.9, 23.03, 145),
  ('Chattian', 'Chattian', 'age', 27.82, 23.03, 156),
  ('Aquitanian', 'Aquitanian', 'age', 23.03, 20.44, 160),
  ('Neogene', 'Neogene', 'period', 23.03, 2.58, 146),
  ('Miocene', 'Miocene', 'epoch', 23.03, 5.333, 159),
  ('Burdigalian', 'Burdigalian', 'age', 20.44, 15.97, 160),
  ('Langhian', 'Langhian', 'age', 15.97, 13.82, 160),
  ('Serravallian', 'Serravallian', 'age', 13.82, 11.63, 160),
  ('Tortonian', 'Tortonian', 'age', 11.63, 7.246, 160),
  ('Messinian', 'Messinian', 'age', 7.246, 5.333, 160),
  ('Zanclean', 'Zanclean', 'age', 5.333, 3.6, 167),
  ('Pliocene', 'Pliocene', 'epoch', 5.333, 2.58, 159),
  ('Piacenzian', 'Piacenzian', 'age', 3.6, 2.58, 167),
  ('Quaternary', 'Quaternary', 'period', 2.58, 0.0, 146),
  ('Gelasian', 'Gelasian', 'age', 2.58, 1.8, 171),
  ('Pleistocene', 'Pleistocene', 'epoch', 2.58, 0.0117, 169),
  ('Calabrian', 'Calabrian', 'age', 1.8, 0.781, 171),
  ('MiddlePleistocene', 'MiddlePleistocene', 'age', 0.781, 0.126, 171),
  ('UpperPleistocene', 'UpperPleistocene', 'age', 0.126, 0.0117, 171),
  ('Holocene', 'Holocene', 'epoch', 0.0117, 0.0, 169),
  ('Greenlandian', 'Greenlandian', 'age', 0.0117, 0.0082, 175),
  ('Northgrippian', 'Northgrippian', 'age', 0.0082, 0.0042, 175),
  ('Meghalayan', 'Meghalayan', 'age', 0.0042, 0.0, 175);

COMMIT;
