--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: https_taxref_mnhn_fr_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA https_taxref_mnhn_fr_sparql;


--
-- Name: SCHEMA https_taxref_mnhn_fr_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA https_taxref_mnhn_fr_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE FUNCTION https_taxref_mnhn_fr_sparql.tapprox(integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select concat(
	case cc when 0 then nn::text else round(ll::decimal,2-lsize)::text end,
case cc when 5 then 'P' when 4 then 'T' when 3 then 'G' 
	   	when 2 then 'M' when 1 then 'K' when 0 then '' else '' end) as ee
from
(select nn, cc, (c-cc*3)::integer as lsize, pp*(pow(10,c-cc*3)::integer) as ll from
(select nn, round((nn/pow(10,c))::decimal,2) as pp, floor(c/3) as cc, c from
(select case $1 when 0 then 0 else floor(log10($1)) end as c, $1 as nn) bb) aa) bb
$_$;


--
-- Name: tapprox(bigint); Type: FUNCTION; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE FUNCTION https_taxref_mnhn_fr_sparql.tapprox(bigint) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select concat(
	case cc when 0 then nn::text else round(ll::decimal,2-lsize)::text end,
case cc when 5 then 'P' when 4 then 'T' when 3 then 'G' 
	   	when 2 then 'M' when 1 then 'K' when 0 then '' else '' end) as ee
from
(select nn, cc, (c-cc*3)::integer as lsize, pp*(pow(10,c-cc*3)::integer) as ll from
(select nn, round((nn/pow(10,c))::decimal,2) as pp, floor(c/3) as cc, c from
(select case $1 when 0 then 0 else floor(log10($1)) end as c, $1 as nn) bb) aa) bb
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _h_classes; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COMMENT ON TABLE https_taxref_mnhn_fr_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.classes (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt bigint,
    data jsonb,
    props_in_schema boolean DEFAULT false NOT NULL,
    ns_id integer,
    local_name text,
    display_name text,
    classification_property_id integer,
    classification_property text,
    classification_adornment text,
    is_literal boolean DEFAULT false,
    datatype_id integer,
    instance_name_pattern jsonb,
    indirect_members boolean DEFAULT false NOT NULL,
    is_unique boolean DEFAULT false NOT NULL,
    large_superclass_id integer,
    hide_in_main boolean DEFAULT false,
    principal_super_class_id integer,
    self_cp_rels boolean DEFAULT true,
    cp_ask_endpoint boolean DEFAULT false,
    in_cnt bigint
);


--
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COMMENT ON COLUMN https_taxref_mnhn_fr_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cp_rels (
    id integer NOT NULL,
    class_id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    object_cnt bigint,
    data_cnt_calc bigint GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality bigint,
    min_cardinality bigint,
    cover_set_index integer,
    add_link_slots integer DEFAULT 1 NOT NULL,
    details_level integer DEFAULT 0 NOT NULL,
    sub_cover_complete boolean DEFAULT false NOT NULL,
    data_cnt bigint,
    principal_class_id integer,
    cnt_base bigint
);


--
-- Name: properties; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.properties (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt bigint,
    data jsonb,
    ns_id integer,
    display_name text,
    local_name text,
    is_unique boolean DEFAULT false NOT NULL,
    object_cnt bigint,
    data_cnt_calc bigint GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality bigint,
    inverse_max_cardinality bigint,
    source_cover_complete boolean DEFAULT false NOT NULL,
    target_cover_complete boolean DEFAULT false NOT NULL,
    domain_class_id integer,
    range_class_id integer,
    data_cnt bigint,
    classes_in_schema boolean DEFAULT true NOT NULL,
    is_classifier boolean DEFAULT false,
    use_in_class boolean,
    classif_prefix text,
    values_have_cp boolean,
    props_in_schema boolean DEFAULT true,
    pp_ask_endpoint boolean DEFAULT false,
    pc_ask_endpoint boolean DEFAULT false
);


--
-- Name: c_links; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((https_taxref_mnhn_fr_sparql.classes c1
     JOIN https_taxref_mnhn_fr_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN https_taxref_mnhn_fr_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN https_taxref_mnhn_fr_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN https_taxref_mnhn_fr_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.instances (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text,
    local_name_lowercase text,
    class_id integer,
    class_iri text,
    test tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, local_name)) STORED
);


--
-- Name: instances_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE TABLE https_taxref_mnhn_fr_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE https_taxref_mnhn_fr_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_taxref_mnhn_fr_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_cc_rels AS
 SELECT r.id,
    r.class_1_id,
    r.class_2_id,
    r.type_id,
    r.cnt,
    r.data,
    c1.iri AS iri1,
    c1.classification_property AS cprop1,
    c2.iri AS iri2,
    c2.classification_property AS cprop2
   FROM https_taxref_mnhn_fr_sparql.cc_rels r,
    https_taxref_mnhn_fr_sparql.classes c1,
    https_taxref_mnhn_fr_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_classes_ns AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.classification_adornment, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    https_taxref_mnhn_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_taxref_mnhn_fr_sparql.classes c
     LEFT JOIN https_taxref_mnhn_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_classes_ns_main AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint,
    v.in_cnt
   FROM https_taxref_mnhn_fr_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM https_taxref_mnhn_fr_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_classes_ns_plus AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    https_taxref_mnhn_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM https_taxref_mnhn_fr_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_taxref_mnhn_fr_sparql.classes c
     LEFT JOIN https_taxref_mnhn_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_classes_ns_main_plus AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.has_subclasses,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint,
    v.in_cnt
   FROM https_taxref_mnhn_fr_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM https_taxref_mnhn_fr_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_classes_ns_main_v01 AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.in_cnt
   FROM (https_taxref_mnhn_fr_sparql.v_classes_ns v
     LEFT JOIN https_taxref_mnhn_fr_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_cp_rels AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc AS data_cnt,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    https_taxref_mnhn_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    https_taxref_mnhn_fr_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    https_taxref_mnhn_fr_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
    r.cnt_base,
        CASE
            WHEN (COALESCE(r.cnt_base, (0)::bigint) = 0) THEN r.cnt
            ELSE ((((r.cnt / r.cnt_base) * c.cnt))::integer)::bigint
        END AS cnt_estimate,
    c.iri AS class_iri,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    p.iri AS property_iri
   FROM https_taxref_mnhn_fr_sparql.cp_rels r,
    https_taxref_mnhn_fr_sparql.classes c,
    https_taxref_mnhn_fr_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_cp_rels_card AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    r.data_cnt,
    COALESCE(r.max_cardinality,
        CASE r.type_id
            WHEN 2 THEN p.max_cardinality
            ELSE p.inverse_max_cardinality
        END, '-1'::bigint) AS x_max_cardinality,
    r.principal_class_id
   FROM https_taxref_mnhn_fr_sparql.cp_rels r,
    https_taxref_mnhn_fr_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_properties_ns AS
 SELECT p.id,
    p.iri,
    p.cnt,
    p.ns_id,
    n.name AS prefix,
    p.display_name,
    p.local_name,
    p.is_unique,
    p.object_cnt,
    p.data_cnt_calc AS data_cnt,
    p.source_cover_complete,
    p.target_cover_complete,
    concat(n.name, ',', p.local_name, ',', p.display_name, ',', lower(p.display_name)) AS namestring,
    https_taxref_mnhn_fr_sparql.tapprox(p.cnt) AS cnt_x,
    https_taxref_mnhn_fr_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    https_taxref_mnhn_fr_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
    n.is_local,
    p.domain_class_id,
    p.range_class_id,
    p.classes_in_schema,
    p.is_classifier,
    p.use_in_class,
    p.classif_prefix,
    p.values_have_cp,
    p.props_in_schema,
    p.pp_ask_endpoint,
    p.pc_ask_endpoint,
    n.basic_order_level,
        CASE
            WHEN (p.max_cardinality IS NOT NULL) THEN p.max_cardinality
            ELSE '-1'::bigint
        END AS max_cardinality,
        CASE
            WHEN (p.inverse_max_cardinality IS NOT NULL) THEN p.inverse_max_cardinality
            ELSE '-1'::bigint
        END AS inverse_max_cardinality
   FROM (https_taxref_mnhn_fr_sparql.properties p
     LEFT JOIN https_taxref_mnhn_fr_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_cp_sources_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((https_taxref_mnhn_fr_sparql.v_cp_rels_card r
     JOIN https_taxref_mnhn_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_taxref_mnhn_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_cp_targets_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((https_taxref_mnhn_fr_sparql.v_cp_rels_card r
     JOIN https_taxref_mnhn_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_taxref_mnhn_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    https_taxref_mnhn_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM https_taxref_mnhn_fr_sparql.pp_rels r,
    https_taxref_mnhn_fr_sparql.properties p1,
    https_taxref_mnhn_fr_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_properties_sources AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (https_taxref_mnhn_fr_sparql.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM https_taxref_mnhn_fr_sparql.cp_rels r,
            https_taxref_mnhn_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_properties_sources_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (https_taxref_mnhn_fr_sparql.v_properties_ns v
     LEFT JOIN https_taxref_mnhn_fr_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_properties_targets AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (https_taxref_mnhn_fr_sparql.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM https_taxref_mnhn_fr_sparql.cp_rels r,
            https_taxref_mnhn_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE VIEW https_taxref_mnhn_fr_sparql.v_properties_targets_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (https_taxref_mnhn_fr_sparql.v_properties_ns v
     LEFT JOIN https_taxref_mnhn_fr_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	757	1	\N	\N
2	2	757	1	\N	\N
3	3	1125	1	\N	\N
4	4	1125	1	\N	\N
5	5	1125	1	\N	\N
6	6	1139	1	\N	\N
7	7	757	1	\N	\N
8	8	1140	1	\N	\N
9	9	757	1	\N	\N
10	10	757	1	\N	\N
11	11	1139	1	\N	\N
12	12	1140	1	\N	\N
13	13	757	1	\N	\N
14	14	1140	1	\N	\N
15	15	1139	1	\N	\N
16	16	757	1	\N	\N
17	17	1140	1	\N	\N
18	18	1125	1	\N	\N
19	19	1125	1	\N	\N
20	20	1125	1	\N	\N
21	21	1125	1	\N	\N
22	22	757	1	\N	\N
23	23	1140	1	\N	\N
24	24	757	1	\N	\N
25	25	1125	1	\N	\N
26	27	26	1	\N	\N
27	42	907	1	\N	\N
28	43	907	1	\N	\N
29	44	1118	1	\N	\N
30	46	1125	1	\N	\N
31	47	1125	1	\N	\N
32	48	1140	1	\N	\N
33	49	1139	1	\N	\N
34	50	757	1	\N	\N
35	51	1140	1	\N	\N
36	52	1140	1	\N	\N
37	53	1139	1	\N	\N
38	54	757	1	\N	\N
39	55	1140	1	\N	\N
40	56	1125	1	\N	\N
41	61	748	1	\N	\N
42	62	757	1	\N	\N
43	63	1140	1	\N	\N
44	64	1140	1	\N	\N
45	65	757	1	\N	\N
46	66	1140	1	\N	\N
47	67	757	1	\N	\N
48	68	757	1	\N	\N
49	69	757	1	\N	\N
50	70	1140	1	\N	\N
51	71	1139	1	\N	\N
52	72	1139	1	\N	\N
53	73	1139	1	\N	\N
54	74	1140	1	\N	\N
55	75	1140	1	\N	\N
56	76	1139	1	\N	\N
57	77	1139	1	\N	\N
58	78	757	1	\N	\N
59	79	1139	1	\N	\N
60	80	1139	1	\N	\N
61	81	1140	1	\N	\N
62	82	757	1	\N	\N
63	83	757	1	\N	\N
64	84	1139	1	\N	\N
65	85	757	1	\N	\N
66	86	757	1	\N	\N
67	87	757	1	\N	\N
68	88	1125	1	\N	\N
69	89	1125	1	\N	\N
70	90	1125	1	\N	\N
71	91	1125	1	\N	\N
72	92	1125	1	\N	\N
73	93	1125	1	\N	\N
74	94	1139	1	\N	\N
75	95	757	1	\N	\N
76	96	1139	1	\N	\N
77	97	757	1	\N	\N
78	98	1140	1	\N	\N
79	99	757	1	\N	\N
80	100	1140	1	\N	\N
81	101	1140	1	\N	\N
82	102	757	1	\N	\N
83	103	1140	1	\N	\N
84	104	757	1	\N	\N
85	105	1140	1	\N	\N
86	106	1139	1	\N	\N
87	107	1139	1	\N	\N
88	108	757	1	\N	\N
89	109	1139	1	\N	\N
90	110	1140	1	\N	\N
91	111	757	1	\N	\N
92	112	1139	1	\N	\N
93	113	1140	1	\N	\N
94	114	1139	1	\N	\N
95	115	1140	1	\N	\N
96	116	1125	1	\N	\N
97	117	1125	1	\N	\N
98	118	1125	1	\N	\N
99	119	1125	1	\N	\N
100	120	1125	1	\N	\N
101	121	1125	1	\N	\N
102	122	1125	1	\N	\N
103	123	757	1	\N	\N
104	124	1139	1	\N	\N
105	125	1139	1	\N	\N
106	126	757	1	\N	\N
107	127	757	1	\N	\N
108	128	1139	1	\N	\N
109	129	1139	1	\N	\N
110	130	757	1	\N	\N
111	131	1140	1	\N	\N
112	132	757	1	\N	\N
113	133	1139	1	\N	\N
114	134	1140	1	\N	\N
115	135	1139	1	\N	\N
116	136	1140	1	\N	\N
117	137	757	1	\N	\N
118	138	1139	1	\N	\N
119	139	1139	1	\N	\N
120	140	757	1	\N	\N
121	141	1140	1	\N	\N
122	142	1139	1	\N	\N
123	143	1140	1	\N	\N
124	144	1139	1	\N	\N
125	145	1139	1	\N	\N
126	146	1139	1	\N	\N
127	147	1140	1	\N	\N
128	148	1125	1	\N	\N
129	149	1125	1	\N	\N
130	150	1125	1	\N	\N
131	151	1125	1	\N	\N
132	152	1125	1	\N	\N
133	153	1140	1	\N	\N
134	154	757	1	\N	\N
135	155	1140	1	\N	\N
136	156	757	1	\N	\N
137	157	757	1	\N	\N
138	158	1140	1	\N	\N
139	159	757	1	\N	\N
140	160	757	1	\N	\N
141	161	757	1	\N	\N
142	162	757	1	\N	\N
143	163	757	1	\N	\N
144	164	757	1	\N	\N
145	165	757	1	\N	\N
146	166	757	1	\N	\N
147	167	1125	1	\N	\N
148	168	1125	1	\N	\N
149	169	1125	1	\N	\N
150	170	1125	1	\N	\N
151	171	757	1	\N	\N
152	172	757	1	\N	\N
153	173	757	1	\N	\N
154	174	757	1	\N	\N
155	175	757	1	\N	\N
156	176	1139	1	\N	\N
157	177	1139	1	\N	\N
158	178	1140	1	\N	\N
159	179	1139	1	\N	\N
160	180	757	1	\N	\N
161	181	757	1	\N	\N
162	182	1140	1	\N	\N
163	183	1139	1	\N	\N
164	184	1140	1	\N	\N
165	185	757	1	\N	\N
166	186	757	1	\N	\N
167	187	757	1	\N	\N
168	188	1139	1	\N	\N
169	189	757	1	\N	\N
170	190	1140	1	\N	\N
171	191	1140	1	\N	\N
172	192	1140	1	\N	\N
173	193	1140	1	\N	\N
174	194	1139	1	\N	\N
175	195	1125	1	\N	\N
176	196	1140	1	\N	\N
177	197	757	1	\N	\N
178	198	1140	1	\N	\N
179	199	1140	1	\N	\N
180	200	1140	1	\N	\N
181	201	757	1	\N	\N
182	202	1139	1	\N	\N
183	203	1139	1	\N	\N
184	204	757	1	\N	\N
185	205	1139	1	\N	\N
186	206	757	1	\N	\N
187	207	1125	1	\N	\N
188	208	1125	1	\N	\N
189	209	757	1	\N	\N
190	210	1125	1	\N	\N
191	211	1140	1	\N	\N
192	212	1125	1	\N	\N
193	213	1139	1	\N	\N
194	214	1125	1	\N	\N
195	215	757	1	\N	\N
196	216	1140	1	\N	\N
197	217	1125	1	\N	\N
198	218	757	1	\N	\N
199	219	757	1	\N	\N
200	220	1125	1	\N	\N
201	221	1139	1	\N	\N
202	222	1125	1	\N	\N
203	223	1125	1	\N	\N
204	224	757	1	\N	\N
205	225	1125	1	\N	\N
206	226	1125	1	\N	\N
207	227	1139	1	\N	\N
208	229	1139	1	\N	\N
209	230	1140	1	\N	\N
210	231	1140	1	\N	\N
211	232	757	1	\N	\N
212	233	757	1	\N	\N
213	234	1140	1	\N	\N
214	235	1140	1	\N	\N
215	236	757	1	\N	\N
216	237	1125	1	\N	\N
217	238	757	1	\N	\N
218	239	1125	1	\N	\N
219	240	757	1	\N	\N
220	241	757	1	\N	\N
221	242	1140	1	\N	\N
222	243	1140	1	\N	\N
223	244	1140	1	\N	\N
224	245	1140	1	\N	\N
225	246	1140	1	\N	\N
226	247	1139	1	\N	\N
227	248	1125	1	\N	\N
228	249	1140	1	\N	\N
229	250	757	1	\N	\N
230	251	1140	1	\N	\N
231	252	1140	1	\N	\N
232	253	757	1	\N	\N
233	254	1139	1	\N	\N
234	258	256	1	\N	\N
235	261	1117	1	\N	\N
236	262	1118	1	\N	\N
237	263	1118	1	\N	\N
238	264	1118	1	\N	\N
239	267	1125	1	\N	\N
240	268	1125	1	\N	\N
241	269	1125	1	\N	\N
242	270	1125	1	\N	\N
243	271	1139	1	\N	\N
244	272	757	1	\N	\N
245	273	1139	1	\N	\N
246	274	1140	1	\N	\N
247	275	757	1	\N	\N
248	276	757	1	\N	\N
249	277	1139	1	\N	\N
250	278	1139	1	\N	\N
251	279	757	1	\N	\N
252	280	757	1	\N	\N
253	281	757	1	\N	\N
254	282	757	1	\N	\N
255	283	1139	1	\N	\N
256	284	757	1	\N	\N
257	285	1139	1	\N	\N
258	286	757	1	\N	\N
259	287	1140	1	\N	\N
260	288	757	1	\N	\N
261	289	757	1	\N	\N
262	290	1139	1	\N	\N
263	291	757	1	\N	\N
264	292	757	1	\N	\N
265	293	1139	1	\N	\N
266	294	1139	1	\N	\N
267	295	757	1	\N	\N
268	296	1140	1	\N	\N
269	297	757	1	\N	\N
270	298	757	1	\N	\N
271	299	1140	1	\N	\N
272	300	757	1	\N	\N
273	301	1140	1	\N	\N
274	303	1170	1	\N	\N
275	304	1139	1	\N	\N
276	305	757	1	\N	\N
277	306	757	1	\N	\N
278	307	1139	1	\N	\N
279	308	1139	1	\N	\N
280	309	1139	1	\N	\N
281	310	1139	1	\N	\N
282	311	757	1	\N	\N
283	312	757	1	\N	\N
284	313	757	1	\N	\N
285	314	1139	1	\N	\N
286	315	1139	1	\N	\N
287	316	757	1	\N	\N
288	317	757	1	\N	\N
289	318	1139	1	\N	\N
290	319	1140	1	\N	\N
291	320	757	1	\N	\N
292	321	1140	1	\N	\N
293	322	1139	1	\N	\N
294	323	1139	1	\N	\N
295	324	1140	1	\N	\N
296	325	1140	1	\N	\N
297	326	757	1	\N	\N
298	327	1139	1	\N	\N
299	328	757	1	\N	\N
300	329	757	1	\N	\N
301	330	757	1	\N	\N
302	331	1140	1	\N	\N
303	332	1139	1	\N	\N
304	333	757	1	\N	\N
305	334	1139	1	\N	\N
306	335	757	1	\N	\N
307	336	1139	1	\N	\N
308	337	1140	1	\N	\N
309	338	1139	1	\N	\N
310	339	1139	1	\N	\N
311	340	1139	1	\N	\N
312	341	1140	1	\N	\N
313	342	1140	1	\N	\N
314	343	757	1	\N	\N
315	344	1139	1	\N	\N
316	345	757	1	\N	\N
317	346	757	1	\N	\N
318	347	1139	1	\N	\N
319	348	1140	1	\N	\N
320	349	1139	1	\N	\N
321	350	1140	1	\N	\N
322	351	1140	1	\N	\N
323	352	1140	1	\N	\N
324	353	1139	1	\N	\N
325	354	757	1	\N	\N
326	355	1125	1	\N	\N
327	356	1125	1	\N	\N
328	357	1125	1	\N	\N
329	358	1125	1	\N	\N
330	359	1140	1	\N	\N
331	360	1139	1	\N	\N
332	361	1139	1	\N	\N
333	362	1140	1	\N	\N
334	363	757	1	\N	\N
335	364	1140	1	\N	\N
336	365	1139	1	\N	\N
337	366	1140	1	\N	\N
338	367	757	1	\N	\N
339	368	757	1	\N	\N
340	369	757	1	\N	\N
341	370	1140	1	\N	\N
342	371	1139	1	\N	\N
343	372	757	1	\N	\N
344	373	757	1	\N	\N
345	374	1140	1	\N	\N
346	375	1139	1	\N	\N
347	376	1140	1	\N	\N
348	377	1140	1	\N	\N
349	378	757	1	\N	\N
350	379	757	1	\N	\N
351	380	1140	1	\N	\N
352	381	1140	1	\N	\N
353	382	1139	1	\N	\N
354	383	1125	1	\N	\N
355	384	1125	1	\N	\N
356	385	1125	1	\N	\N
357	386	1125	1	\N	\N
358	387	1125	1	\N	\N
359	388	1139	1	\N	\N
360	389	1139	1	\N	\N
361	390	1139	1	\N	\N
362	391	1140	1	\N	\N
363	392	1139	1	\N	\N
364	393	1140	1	\N	\N
365	394	1139	1	\N	\N
366	395	1140	1	\N	\N
367	396	1140	1	\N	\N
368	397	1139	1	\N	\N
369	398	1140	1	\N	\N
370	399	1139	1	\N	\N
371	400	757	1	\N	\N
372	401	1140	1	\N	\N
373	402	757	1	\N	\N
374	403	1139	1	\N	\N
375	404	757	1	\N	\N
376	405	757	1	\N	\N
377	406	757	1	\N	\N
378	407	1140	1	\N	\N
379	408	757	1	\N	\N
380	409	1140	1	\N	\N
381	410	757	1	\N	\N
382	411	1140	1	\N	\N
383	412	1125	1	\N	\N
384	413	1125	1	\N	\N
385	414	1125	1	\N	\N
386	415	1125	1	\N	\N
387	416	1125	1	\N	\N
388	417	757	1	\N	\N
389	418	1140	1	\N	\N
390	419	1140	1	\N	\N
391	420	1139	1	\N	\N
392	421	1139	1	\N	\N
393	422	1140	1	\N	\N
394	423	1139	1	\N	\N
395	424	757	1	\N	\N
396	425	757	1	\N	\N
397	426	757	1	\N	\N
398	427	757	1	\N	\N
399	428	1139	1	\N	\N
400	429	1139	1	\N	\N
401	430	757	1	\N	\N
402	431	1139	1	\N	\N
403	432	757	1	\N	\N
404	433	1140	1	\N	\N
405	434	1140	1	\N	\N
406	435	757	1	\N	\N
407	436	1140	1	\N	\N
408	437	1139	1	\N	\N
409	438	1125	1	\N	\N
410	439	1125	1	\N	\N
411	440	757	1	\N	\N
412	441	1139	1	\N	\N
413	442	1140	1	\N	\N
414	443	1139	1	\N	\N
415	444	1139	1	\N	\N
416	445	1140	1	\N	\N
417	446	1140	1	\N	\N
418	447	757	1	\N	\N
419	448	1140	1	\N	\N
420	449	757	1	\N	\N
421	450	1125	1	\N	\N
422	451	1125	1	\N	\N
423	452	1125	1	\N	\N
424	453	1140	1	\N	\N
425	454	757	1	\N	\N
426	455	1139	1	\N	\N
427	456	757	1	\N	\N
428	457	1140	1	\N	\N
429	458	1125	1	\N	\N
430	459	1139	1	\N	\N
431	460	1139	1	\N	\N
432	461	1140	1	\N	\N
433	462	1125	1	\N	\N
434	463	1125	1	\N	\N
435	464	757	1	\N	\N
436	465	757	1	\N	\N
437	466	1140	1	\N	\N
438	467	1139	1	\N	\N
439	468	1140	1	\N	\N
440	469	757	1	\N	\N
441	477	257	1	\N	\N
442	479	478	1	\N	\N
443	482	1140	1	\N	\N
444	483	757	1	\N	\N
445	484	1139	1	\N	\N
446	485	757	1	\N	\N
447	486	757	1	\N	\N
448	487	1139	1	\N	\N
449	488	1139	1	\N	\N
450	489	1139	1	\N	\N
451	490	1125	1	\N	\N
452	491	1125	1	\N	\N
453	492	1125	1	\N	\N
454	493	1125	1	\N	\N
455	494	1125	1	\N	\N
456	495	1125	1	\N	\N
457	496	1125	1	\N	\N
458	497	1125	1	\N	\N
459	498	1125	1	\N	\N
460	499	1125	1	\N	\N
461	500	1125	1	\N	\N
462	501	757	1	\N	\N
463	502	757	1	\N	\N
464	503	1125	1	\N	\N
465	504	1139	1	\N	\N
466	505	757	1	\N	\N
467	506	1140	1	\N	\N
468	507	1139	1	\N	\N
469	508	1139	1	\N	\N
470	509	1139	1	\N	\N
471	510	1140	1	\N	\N
472	511	757	1	\N	\N
473	512	1140	1	\N	\N
474	513	1140	1	\N	\N
475	514	1140	1	\N	\N
476	515	757	1	\N	\N
477	516	757	1	\N	\N
478	517	757	1	\N	\N
479	518	757	1	\N	\N
480	519	1139	1	\N	\N
481	520	1140	1	\N	\N
482	521	757	1	\N	\N
483	522	757	1	\N	\N
484	523	757	1	\N	\N
485	524	757	1	\N	\N
486	525	757	1	\N	\N
487	526	1125	1	\N	\N
488	527	1125	1	\N	\N
489	528	1125	1	\N	\N
490	529	1125	1	\N	\N
491	530	1125	1	\N	\N
492	531	1125	1	\N	\N
493	532	1125	1	\N	\N
494	533	1125	1	\N	\N
495	534	757	1	\N	\N
496	535	1139	1	\N	\N
497	536	757	1	\N	\N
498	537	1139	1	\N	\N
499	538	1140	1	\N	\N
500	539	757	1	\N	\N
501	540	757	1	\N	\N
502	541	1139	1	\N	\N
503	542	1140	1	\N	\N
504	543	1140	1	\N	\N
505	544	1140	1	\N	\N
506	545	1139	1	\N	\N
507	546	757	1	\N	\N
508	547	757	1	\N	\N
509	548	1140	1	\N	\N
510	549	1139	1	\N	\N
511	550	1140	1	\N	\N
512	551	757	1	\N	\N
513	552	1140	1	\N	\N
514	553	1139	1	\N	\N
515	554	1140	1	\N	\N
516	555	1140	1	\N	\N
517	556	1140	1	\N	\N
518	557	1139	1	\N	\N
519	558	1140	1	\N	\N
520	559	1140	1	\N	\N
521	560	1125	1	\N	\N
522	561	1125	1	\N	\N
523	562	1125	1	\N	\N
524	563	1125	1	\N	\N
525	564	1125	1	\N	\N
526	565	1125	1	\N	\N
527	566	1125	1	\N	\N
528	567	1125	1	\N	\N
529	568	1139	1	\N	\N
530	569	1139	1	\N	\N
531	570	1140	1	\N	\N
532	571	1140	1	\N	\N
533	572	757	1	\N	\N
534	573	1139	1	\N	\N
535	574	1139	1	\N	\N
536	575	1140	1	\N	\N
537	576	1139	1	\N	\N
538	577	757	1	\N	\N
539	578	1139	1	\N	\N
540	579	1140	1	\N	\N
541	580	1140	1	\N	\N
542	581	757	1	\N	\N
543	582	1139	1	\N	\N
544	583	1139	1	\N	\N
545	584	1140	1	\N	\N
546	585	1140	1	\N	\N
547	586	1140	1	\N	\N
548	587	757	1	\N	\N
549	588	1140	1	\N	\N
550	589	1140	1	\N	\N
551	590	1140	1	\N	\N
552	591	757	1	\N	\N
553	592	757	1	\N	\N
554	593	1139	1	\N	\N
555	594	1140	1	\N	\N
556	595	757	1	\N	\N
557	596	1140	1	\N	\N
558	597	1125	1	\N	\N
559	598	1125	1	\N	\N
560	599	1125	1	\N	\N
561	600	1125	1	\N	\N
562	601	1125	1	\N	\N
563	602	1125	1	\N	\N
564	603	1125	1	\N	\N
565	604	1125	1	\N	\N
566	605	1140	1	\N	\N
567	606	1139	1	\N	\N
568	607	1139	1	\N	\N
569	608	1140	1	\N	\N
570	609	1140	1	\N	\N
571	610	1140	1	\N	\N
572	611	1140	1	\N	\N
573	612	1139	1	\N	\N
574	613	1139	1	\N	\N
575	614	1139	1	\N	\N
576	615	1139	1	\N	\N
577	616	1125	1	\N	\N
578	617	1125	1	\N	\N
579	618	1125	1	\N	\N
580	619	1139	1	\N	\N
581	620	1139	1	\N	\N
582	621	757	1	\N	\N
583	622	1140	1	\N	\N
584	623	1139	1	\N	\N
585	624	757	1	\N	\N
586	625	1139	1	\N	\N
587	626	1139	1	\N	\N
588	627	757	1	\N	\N
589	628	1139	1	\N	\N
590	629	757	1	\N	\N
591	630	757	1	\N	\N
592	631	1140	1	\N	\N
593	632	757	1	\N	\N
594	633	757	1	\N	\N
595	634	1139	1	\N	\N
596	635	757	1	\N	\N
597	636	757	1	\N	\N
598	637	1139	1	\N	\N
599	638	1139	1	\N	\N
600	639	1139	1	\N	\N
601	640	1139	1	\N	\N
602	641	1139	1	\N	\N
603	642	1139	1	\N	\N
604	643	757	1	\N	\N
605	644	1139	1	\N	\N
606	645	1140	1	\N	\N
607	646	757	1	\N	\N
608	647	757	1	\N	\N
609	648	1139	1	\N	\N
610	649	1140	1	\N	\N
611	650	1139	1	\N	\N
612	651	1140	1	\N	\N
613	652	1140	1	\N	\N
614	653	757	1	\N	\N
615	654	1139	1	\N	\N
616	655	1140	1	\N	\N
617	656	1125	1	\N	\N
618	657	1125	1	\N	\N
619	658	1125	1	\N	\N
620	661	1140	1	\N	\N
621	662	1140	1	\N	\N
622	663	757	1	\N	\N
623	664	1140	1	\N	\N
624	665	757	1	\N	\N
625	666	1139	1	\N	\N
626	667	1125	1	\N	\N
627	668	1139	1	\N	\N
628	669	1140	1	\N	\N
629	670	1140	1	\N	\N
630	671	1139	1	\N	\N
631	672	1139	1	\N	\N
632	673	1139	1	\N	\N
633	674	1139	1	\N	\N
634	675	1140	1	\N	\N
635	676	1125	1	\N	\N
636	677	1125	1	\N	\N
637	678	1125	1	\N	\N
638	679	757	1	\N	\N
639	680	1139	1	\N	\N
640	681	1140	1	\N	\N
641	682	1140	1	\N	\N
642	683	1140	1	\N	\N
643	684	757	1	\N	\N
644	685	1139	1	\N	\N
645	686	1125	1	\N	\N
646	687	1139	1	\N	\N
647	688	1125	1	\N	\N
648	689	757	1	\N	\N
649	692	1125	1	\N	\N
650	693	1125	1	\N	\N
651	694	1125	1	\N	\N
652	695	1140	1	\N	\N
653	696	757	1	\N	\N
654	697	1139	1	\N	\N
655	698	1125	1	\N	\N
656	699	1140	1	\N	\N
657	700	1139	1	\N	\N
658	701	1140	1	\N	\N
659	702	757	1	\N	\N
660	703	757	1	\N	\N
661	704	757	1	\N	\N
662	705	1140	1	\N	\N
663	706	1125	1	\N	\N
664	707	1125	1	\N	\N
665	708	1125	1	\N	\N
666	709	1125	1	\N	\N
667	710	1125	1	\N	\N
668	711	1140	1	\N	\N
669	712	1125	1	\N	\N
670	713	1125	1	\N	\N
671	714	1125	1	\N	\N
672	715	757	1	\N	\N
673	716	1139	1	\N	\N
674	717	1140	1	\N	\N
675	718	1125	1	\N	\N
676	719	757	1	\N	\N
677	720	757	1	\N	\N
678	721	757	1	\N	\N
679	722	1125	1	\N	\N
680	723	757	1	\N	\N
681	724	1139	1	\N	\N
682	725	757	1	\N	\N
683	726	757	1	\N	\N
684	727	1139	1	\N	\N
685	728	757	1	\N	\N
686	729	1140	1	\N	\N
687	730	1140	1	\N	\N
688	731	757	1	\N	\N
689	732	1125	1	\N	\N
690	733	1140	1	\N	\N
691	734	1125	1	\N	\N
692	735	757	1	\N	\N
693	741	1112	1	\N	\N
694	746	1118	1	\N	\N
695	747	1118	1	\N	\N
696	752	1125	1	\N	\N
697	753	1125	1	\N	\N
698	754	1125	1	\N	\N
699	755	1125	1	\N	\N
700	756	1125	1	\N	\N
701	758	757	1	\N	\N
702	759	757	1	\N	\N
703	760	1140	1	\N	\N
704	761	1139	1	\N	\N
705	762	757	1	\N	\N
706	763	1139	1	\N	\N
707	764	1140	1	\N	\N
708	765	1139	1	\N	\N
709	766	1140	1	\N	\N
710	767	1140	1	\N	\N
711	768	757	1	\N	\N
712	769	1140	1	\N	\N
713	770	1140	1	\N	\N
714	771	757	1	\N	\N
715	772	757	1	\N	\N
716	773	1139	1	\N	\N
717	774	757	1	\N	\N
718	775	1140	1	\N	\N
719	776	757	1	\N	\N
720	777	1140	1	\N	\N
721	778	1139	1	\N	\N
722	779	1140	1	\N	\N
723	780	757	1	\N	\N
724	781	1139	1	\N	\N
725	782	1139	1	\N	\N
726	783	1139	1	\N	\N
727	784	1140	1	\N	\N
728	785	1139	1	\N	\N
729	786	1139	1	\N	\N
730	787	1140	1	\N	\N
731	788	757	1	\N	\N
732	789	1139	1	\N	\N
733	790	1139	1	\N	\N
734	791	757	1	\N	\N
735	792	1140	1	\N	\N
736	793	1140	1	\N	\N
737	794	1140	1	\N	\N
738	795	1140	1	\N	\N
739	796	1140	1	\N	\N
740	797	1140	1	\N	\N
741	798	1139	1	\N	\N
742	799	757	1	\N	\N
743	800	757	1	\N	\N
744	801	1139	1	\N	\N
745	802	1140	1	\N	\N
746	803	1139	1	\N	\N
747	804	1140	1	\N	\N
748	805	1139	1	\N	\N
749	806	1139	1	\N	\N
750	807	757	1	\N	\N
751	808	757	1	\N	\N
752	809	1140	1	\N	\N
753	810	1139	1	\N	\N
754	811	1139	1	\N	\N
755	812	1140	1	\N	\N
756	813	1125	1	\N	\N
757	814	1125	1	\N	\N
758	815	1125	1	\N	\N
759	816	1125	1	\N	\N
760	817	1125	1	\N	\N
761	818	1125	1	\N	\N
762	819	757	1	\N	\N
763	820	1140	1	\N	\N
764	821	1139	1	\N	\N
765	822	757	1	\N	\N
766	823	1140	1	\N	\N
767	824	1140	1	\N	\N
768	825	757	1	\N	\N
769	826	1139	1	\N	\N
770	827	757	1	\N	\N
771	828	1139	1	\N	\N
772	829	1140	1	\N	\N
773	830	1139	1	\N	\N
774	831	1140	1	\N	\N
775	832	1139	1	\N	\N
776	833	757	1	\N	\N
777	834	757	1	\N	\N
778	835	1140	1	\N	\N
779	836	757	1	\N	\N
780	837	1140	1	\N	\N
781	838	1125	1	\N	\N
782	839	1125	1	\N	\N
783	840	757	1	\N	\N
784	841	1139	1	\N	\N
785	842	1139	1	\N	\N
786	843	1140	1	\N	\N
787	844	1140	1	\N	\N
788	845	757	1	\N	\N
789	846	757	1	\N	\N
790	847	757	1	\N	\N
791	848	1139	1	\N	\N
792	849	757	1	\N	\N
793	850	1140	1	\N	\N
794	851	1140	1	\N	\N
795	852	1139	1	\N	\N
796	853	1140	1	\N	\N
797	854	757	1	\N	\N
798	855	1140	1	\N	\N
799	856	757	1	\N	\N
800	857	1140	1	\N	\N
801	858	757	1	\N	\N
802	859	1139	1	\N	\N
803	860	1139	1	\N	\N
804	861	757	1	\N	\N
805	862	1125	1	\N	\N
806	863	1125	1	\N	\N
807	864	1140	1	\N	\N
808	865	1140	1	\N	\N
809	866	1140	1	\N	\N
810	867	1139	1	\N	\N
811	868	757	1	\N	\N
812	869	757	1	\N	\N
813	870	1140	1	\N	\N
814	871	757	1	\N	\N
815	872	1140	1	\N	\N
816	873	1140	1	\N	\N
817	874	1125	1	\N	\N
818	875	1125	1	\N	\N
819	876	1125	1	\N	\N
820	877	1125	1	\N	\N
821	878	1139	1	\N	\N
822	879	757	1	\N	\N
823	880	1140	1	\N	\N
824	881	1140	1	\N	\N
825	882	1139	1	\N	\N
826	883	1139	1	\N	\N
827	884	1139	1	\N	\N
828	885	757	1	\N	\N
829	886	1140	1	\N	\N
830	887	1139	1	\N	\N
831	888	1140	1	\N	\N
832	889	1139	1	\N	\N
833	890	1125	1	\N	\N
834	891	1139	1	\N	\N
835	892	1139	1	\N	\N
836	893	1139	1	\N	\N
837	894	757	1	\N	\N
838	895	1139	1	\N	\N
839	896	1125	1	\N	\N
840	897	1125	1	\N	\N
841	898	757	1	\N	\N
842	899	1139	1	\N	\N
843	900	757	1	\N	\N
844	901	1139	1	\N	\N
845	902	1140	1	\N	\N
846	903	757	1	\N	\N
847	904	1140	1	\N	\N
848	905	1139	1	\N	\N
849	909	738	1	\N	\N
850	914	907	1	\N	\N
851	916	257	1	\N	\N
852	921	481	1	\N	\N
853	923	1125	1	\N	\N
854	924	1125	1	\N	\N
855	925	1125	1	\N	\N
856	926	1125	1	\N	\N
857	927	1125	1	\N	\N
858	928	1139	1	\N	\N
859	929	1125	1	\N	\N
860	930	757	1	\N	\N
861	931	1125	1	\N	\N
862	932	1125	1	\N	\N
863	933	1125	1	\N	\N
864	934	1125	1	\N	\N
865	935	1139	1	\N	\N
866	936	1140	1	\N	\N
867	937	1140	1	\N	\N
868	938	1140	1	\N	\N
869	939	1140	1	\N	\N
870	940	757	1	\N	\N
871	941	1125	1	\N	\N
872	942	1125	1	\N	\N
873	943	1125	1	\N	\N
874	944	1125	1	\N	\N
875	945	1125	1	\N	\N
876	946	1139	1	\N	\N
877	947	1139	1	\N	\N
878	948	1125	1	\N	\N
879	949	1125	1	\N	\N
880	950	1140	1	\N	\N
881	951	1125	1	\N	\N
882	952	1125	1	\N	\N
883	953	757	1	\N	\N
884	954	478	1	\N	\N
885	966	1125	1	\N	\N
886	967	1125	1	\N	\N
887	968	1139	1	\N	\N
888	969	1140	1	\N	\N
889	970	1139	1	\N	\N
890	971	757	1	\N	\N
891	972	757	1	\N	\N
892	973	757	1	\N	\N
893	974	1140	1	\N	\N
894	975	1140	1	\N	\N
895	976	757	1	\N	\N
896	977	1140	1	\N	\N
897	979	1117	1	\N	\N
898	982	748	1	\N	\N
899	983	757	1	\N	\N
900	984	757	1	\N	\N
901	985	1140	1	\N	\N
902	986	757	1	\N	\N
903	987	1140	1	\N	\N
904	988	1125	1	\N	\N
905	989	1125	1	\N	\N
906	990	1125	1	\N	\N
907	991	1125	1	\N	\N
908	992	1125	1	\N	\N
909	993	1125	1	\N	\N
910	994	1125	1	\N	\N
911	995	1125	1	\N	\N
912	996	1125	1	\N	\N
913	997	1140	1	\N	\N
914	998	1140	1	\N	\N
915	999	1139	1	\N	\N
916	1000	1125	1	\N	\N
917	1001	1125	1	\N	\N
918	1002	757	1	\N	\N
919	1003	1140	1	\N	\N
920	1004	1125	1	\N	\N
921	1005	1125	1	\N	\N
922	1007	476	1	\N	\N
923	1008	1139	1	\N	\N
924	1009	1125	1	\N	\N
925	1010	1125	1	\N	\N
926	1011	1125	1	\N	\N
927	1012	1125	1	\N	\N
928	1013	1125	1	\N	\N
929	1014	757	1	\N	\N
930	1015	1140	1	\N	\N
931	1016	1139	1	\N	\N
932	1017	1140	1	\N	\N
933	1018	1139	1	\N	\N
934	1019	757	1	\N	\N
935	1020	1139	1	\N	\N
936	1021	1139	1	\N	\N
937	1022	757	1	\N	\N
938	1023	1139	1	\N	\N
939	1024	1139	1	\N	\N
940	1025	1125	1	\N	\N
941	1026	1139	1	\N	\N
942	1027	1125	1	\N	\N
943	1028	1125	1	\N	\N
944	1029	1125	1	\N	\N
945	1030	1139	1	\N	\N
946	1031	757	1	\N	\N
947	1032	1140	1	\N	\N
948	1033	1125	1	\N	\N
949	1034	1125	1	\N	\N
950	1035	1125	1	\N	\N
951	1036	757	1	\N	\N
952	1037	1139	1	\N	\N
953	1038	1140	1	\N	\N
954	1039	478	1	\N	\N
955	1040	1125	1	\N	\N
956	1041	1139	1	\N	\N
957	1042	1140	1	\N	\N
958	1043	1140	1	\N	\N
959	1044	1125	1	\N	\N
960	1045	1139	1	\N	\N
961	1046	1139	1	\N	\N
962	1047	1139	1	\N	\N
963	1048	1139	1	\N	\N
964	1049	1125	1	\N	\N
965	1050	1125	1	\N	\N
966	1051	1139	1	\N	\N
967	1052	1139	1	\N	\N
968	1053	1125	1	\N	\N
969	1054	1125	1	\N	\N
970	1055	1125	1	\N	\N
971	1056	1140	1	\N	\N
972	1057	1139	1	\N	\N
973	1058	1125	1	\N	\N
974	1059	1140	1	\N	\N
975	1060	1125	1	\N	\N
976	1061	1125	1	\N	\N
977	1062	757	1	\N	\N
978	1064	1139	1	\N	\N
979	1065	1140	1	\N	\N
980	1066	757	1	\N	\N
981	1067	1125	1	\N	\N
982	1068	1140	1	\N	\N
983	1069	1139	1	\N	\N
984	1070	757	1	\N	\N
985	1071	1125	1	\N	\N
986	1072	1139	1	\N	\N
987	1073	757	1	\N	\N
988	1074	1139	1	\N	\N
989	1075	1140	1	\N	\N
990	1076	1140	1	\N	\N
991	1077	1140	1	\N	\N
992	1078	1139	1	\N	\N
993	1079	1125	1	\N	\N
994	1080	1125	1	\N	\N
995	1081	757	1	\N	\N
996	1082	1125	1	\N	\N
997	1083	1125	1	\N	\N
998	1084	1140	1	\N	\N
999	1085	757	1	\N	\N
1000	1086	1125	1	\N	\N
1001	1087	757	1	\N	\N
1002	1088	1139	1	\N	\N
1003	1089	1125	1	\N	\N
1004	1090	1140	1	\N	\N
1005	1091	1139	1	\N	\N
1006	1092	1140	1	\N	\N
1007	1093	1139	1	\N	\N
1008	1094	1125	1	\N	\N
1009	1095	1139	1	\N	\N
1010	1096	757	1	\N	\N
1011	1097	1140	1	\N	\N
1012	1098	1140	1	\N	\N
1013	1099	1140	1	\N	\N
1014	1100	757	1	\N	\N
1015	1101	1139	1	\N	\N
1016	1102	1125	1	\N	\N
1017	1103	757	1	\N	\N
1018	1104	757	1	\N	\N
1019	1105	1139	1	\N	\N
1020	1106	1139	1	\N	\N
1021	1119	1118	1	\N	\N
1022	1120	1118	1	\N	\N
1023	1121	1118	1	\N	\N
1024	1122	1118	1	\N	\N
1025	1126	1125	1	\N	\N
1026	1127	1125	1	\N	\N
1027	1128	1125	1	\N	\N
1028	1129	1125	1	\N	\N
1029	1130	1125	1	\N	\N
1030	1131	1125	1	\N	\N
1031	1132	1125	1	\N	\N
1032	1133	1125	1	\N	\N
1033	1134	1125	1	\N	\N
1034	1135	1125	1	\N	\N
1035	1137	757	1	\N	\N
1036	1138	1139	1	\N	\N
1037	1141	1140	1	\N	\N
1038	1142	1139	1	\N	\N
1039	1143	1140	1	\N	\N
1040	1144	1140	1	\N	\N
1041	1145	1139	1	\N	\N
1042	1146	1139	1	\N	\N
1043	1147	757	1	\N	\N
1044	1148	757	1	\N	\N
1045	1149	1140	1	\N	\N
1046	1150	1139	1	\N	\N
1047	1151	1140	1	\N	\N
1048	1152	757	1	\N	\N
1049	1153	1139	1	\N	\N
1050	1154	1140	1	\N	\N
1051	1155	1140	1	\N	\N
1052	1156	1139	1	\N	\N
1053	1157	1140	1	\N	\N
1054	1158	1139	1	\N	\N
1055	1159	757	1	\N	\N
1056	1160	1139	1	\N	\N
1057	1161	1140	1	\N	\N
1058	1162	1139	1	\N	\N
1059	1163	1140	1	\N	\N
1060	1164	1139	1	\N	\N
1061	1165	1139	1	\N	\N
1062	1166	1140	1	\N	\N
1063	1167	1139	1	\N	\N
1064	1168	1140	1	\N	\N
1065	1169	1139	1	\N	\N
1066	1171	1170	1	\N	\N
1067	1172	757	1	\N	\N
1068	1173	1140	1	\N	\N
1069	1174	1140	1	\N	\N
1070	1175	757	1	\N	\N
1071	1176	757	1	\N	\N
1072	1177	757	1	\N	\N
1073	1178	1140	1	\N	\N
1074	1179	757	1	\N	\N
1075	1180	757	1	\N	\N
1076	1181	757	1	\N	\N
1077	1182	757	1	\N	\N
1078	1183	757	1	\N	\N
1079	1184	1140	1	\N	\N
1080	1185	757	1	\N	\N
1081	1186	757	1	\N	\N
1082	1187	1139	1	\N	\N
1083	1188	757	1	\N	\N
1084	1189	1139	1	\N	\N
1085	1190	1140	1	\N	\N
1086	1191	1139	1	\N	\N
1087	1192	1140	1	\N	\N
1088	1193	1139	1	\N	\N
1089	1194	1140	1	\N	\N
1090	1195	1140	1	\N	\N
1091	1196	1140	1	\N	\N
1092	1197	1139	1	\N	\N
1093	1198	757	1	\N	\N
1094	1199	1139	1	\N	\N
1095	1200	1140	1	\N	\N
1096	1201	1140	1	\N	\N
1097	1202	1139	1	\N	\N
1098	1203	1140	1	\N	\N
1099	1204	1139	1	\N	\N
1100	1205	1139	1	\N	\N
1101	1206	757	1	\N	\N
1102	1207	1139	1	\N	\N
1103	1208	1140	1	\N	\N
1104	1209	1139	1	\N	\N
1105	1210	757	1	\N	\N
1106	1211	1139	1	\N	\N
1107	1212	757	1	\N	\N
1108	1213	1139	1	\N	\N
1109	1214	1139	1	\N	\N
1110	1215	1139	1	\N	\N
1111	1216	1139	1	\N	\N
1112	1217	1139	1	\N	\N
1113	1218	1139	1	\N	\N
1114	1219	757	1	\N	\N
1115	1220	1125	1	\N	\N
1116	1221	1125	1	\N	\N
1117	1222	1125	1	\N	\N
1118	1223	1125	1	\N	\N
1119	1224	1125	1	\N	\N
1120	1225	1125	1	\N	\N
1121	1226	757	1	\N	\N
1122	1227	1140	1	\N	\N
1123	1228	1140	1	\N	\N
1124	1229	757	1	\N	\N
1125	1230	1139	1	\N	\N
1126	1231	1139	1	\N	\N
1127	1232	757	1	\N	\N
1128	1233	1140	1	\N	\N
1129	1234	1139	1	\N	\N
1130	1235	1140	1	\N	\N
1131	1236	757	1	\N	\N
1132	1237	1140	1	\N	\N
1133	1238	1139	1	\N	\N
1134	1239	757	1	\N	\N
1135	1240	1139	1	\N	\N
1136	1241	757	1	\N	\N
1137	1242	1140	1	\N	\N
1138	1243	1140	1	\N	\N
1139	1244	757	1	\N	\N
1140	1245	1139	1	\N	\N
1141	1246	1125	1	\N	\N
1142	1247	1125	1	\N	\N
1143	1248	1125	1	\N	\N
1144	1249	1125	1	\N	\N
1145	1250	1139	1	\N	\N
1146	1251	1139	1	\N	\N
1147	1252	1139	1	\N	\N
1148	1253	757	1	\N	\N
1149	1254	757	1	\N	\N
1150	1255	1140	1	\N	\N
1151	1256	1140	1	\N	\N
1152	1257	757	1	\N	\N
1153	1258	757	1	\N	\N
1154	1259	1139	1	\N	\N
1155	1260	1139	1	\N	\N
1156	1261	757	1	\N	\N
1157	1262	757	1	\N	\N
1158	1263	757	1	\N	\N
1159	1264	1139	1	\N	\N
1160	1265	1140	1	\N	\N
1161	1266	1139	1	\N	\N
1162	1267	1139	1	\N	\N
1163	1268	1140	1	\N	\N
1164	1269	1140	1	\N	\N
1165	1270	757	1	\N	\N
1166	1271	1140	1	\N	\N
1167	1272	1140	1	\N	\N
1168	1273	1140	1	\N	\N
1169	1274	757	1	\N	\N
1170	1275	757	1	\N	\N
1171	1276	1140	1	\N	\N
1172	1277	1125	1	\N	\N
1173	1278	1125	1	\N	\N
1174	1279	1125	1	\N	\N
1175	1280	1125	1	\N	\N
1176	1281	1139	1	\N	\N
1177	1282	757	1	\N	\N
1178	1283	1140	1	\N	\N
1179	1284	1139	1	\N	\N
1180	1285	757	1	\N	\N
1181	1286	757	1	\N	\N
1182	1287	1140	1	\N	\N
1183	1288	757	1	\N	\N
1184	1289	757	1	\N	\N
1185	1290	757	1	\N	\N
1186	1291	1140	1	\N	\N
1187	1292	1125	1	\N	\N
1188	1293	1125	1	\N	\N
1189	1294	1170	1	\N	\N
1190	1295	757	1	\N	\N
1191	1296	1140	1	\N	\N
1192	1297	757	1	\N	\N
1193	1298	1140	1	\N	\N
1194	1299	1139	1	\N	\N
1195	1300	757	1	\N	\N
1196	1301	1140	1	\N	\N
1197	1302	1139	1	\N	\N
1198	1303	1140	1	\N	\N
1199	1304	1125	1	\N	\N
1200	1305	1125	1	\N	\N
1201	1306	1139	1	\N	\N
1202	1307	1139	1	\N	\N
1203	1308	1139	1	\N	\N
1204	1309	757	1	\N	\N
1205	1310	1140	1	\N	\N
1206	1311	1139	1	\N	\N
1207	1312	1139	1	\N	\N
1208	1313	1125	1	\N	\N
1209	1314	1139	1	\N	\N
1210	1315	1125	1	\N	\N
1211	1316	1125	1	\N	\N
1212	1317	1125	1	\N	\N
1213	1318	757	1	\N	\N
1214	1319	1139	1	\N	\N
1215	1321	738	1	\N	\N
1216	1322	738	1	\N	\N
1217	1332	907	1	\N	\N
1218	1337	757	1	\N	\N
1219	1338	1140	1	\N	\N
1220	1339	1140	1	\N	\N
1221	1340	757	1	\N	\N
1222	1341	1140	1	\N	\N
1223	1342	1139	1	\N	\N
1224	1343	1139	1	\N	\N
1225	1344	1139	1	\N	\N
1226	1345	1139	1	\N	\N
1227	1346	757	1	\N	\N
1228	1347	1139	1	\N	\N
1229	1348	1140	1	\N	\N
1230	1349	757	1	\N	\N
1231	1350	1139	1	\N	\N
1232	1351	757	1	\N	\N
1233	1352	1140	1	\N	\N
1234	1353	757	1	\N	\N
1235	1354	1140	1	\N	\N
1236	1355	1139	1	\N	\N
1237	1356	1125	1	\N	\N
1238	1357	1125	1	\N	\N
1239	1358	1125	1	\N	\N
1240	1359	1140	1	\N	\N
1241	1361	1140	1	\N	\N
1242	1362	1140	1	\N	\N
1243	1363	757	1	\N	\N
1244	1364	1139	1	\N	\N
1245	1365	757	1	\N	\N
1246	1366	1140	1	\N	\N
1247	1367	1140	1	\N	\N
1248	1368	757	1	\N	\N
1249	1369	1140	1	\N	\N
1250	1370	757	1	\N	\N
1251	1371	757	1	\N	\N
1252	1372	1139	1	\N	\N
1253	1373	1139	1	\N	\N
1254	1374	1140	1	\N	\N
1255	1375	1125	1	\N	\N
1256	1376	1140	1	\N	\N
1257	1377	1140	1	\N	\N
1258	1378	1125	1	\N	\N
1259	1379	757	1	\N	\N
1260	1380	757	1	\N	\N
1261	1381	1125	1	\N	\N
1262	1382	1125	1	\N	\N
1263	1383	1125	1	\N	\N
1264	1384	1139	1	\N	\N
1265	1385	1139	1	\N	\N
1266	1386	1139	1	\N	\N
1267	1387	1125	1	\N	\N
1268	1388	1140	1	\N	\N
1269	1389	1125	1	\N	\N
1270	1390	1139	1	\N	\N
1271	1391	1125	1	\N	\N
1272	1392	1125	1	\N	\N
1273	1393	1125	1	\N	\N
1274	1394	1125	1	\N	\N
1275	1395	757	1	\N	\N
1276	1396	1125	1	\N	\N
1277	1397	1140	1	\N	\N
1278	1398	1125	1	\N	\N
1279	1399	1125	1	\N	\N
1280	1400	1125	1	\N	\N
1281	1401	1125	1	\N	\N
1282	1402	1140	1	\N	\N
1283	1403	757	1	\N	\N
1284	1404	1125	1	\N	\N
1285	1405	1139	1	\N	\N
1286	1406	1140	1	\N	\N
1287	1407	1139	1	\N	\N
1288	1408	757	1	\N	\N
1289	1409	757	1	\N	\N
1290	1410	1125	1	\N	\N
1291	1411	1140	1	\N	\N
1292	1412	1140	1	\N	\N
1293	1413	1125	1	\N	\N
1294	1414	1125	1	\N	\N
1295	1415	1140	1	\N	\N
1296	1416	757	1	\N	\N
1297	1417	1139	1	\N	\N
1298	1418	1125	1	\N	\N
1299	1419	1125	1	\N	\N
1300	1420	1125	1	\N	\N
1301	1421	1139	1	\N	\N
1302	1422	1125	1	\N	\N
1303	1423	1125	1	\N	\N
1304	1424	1140	1	\N	\N
1305	1425	757	1	\N	\N
1306	1426	1139	1	\N	\N
1307	1429	757	1	\N	\N
1308	1430	1139	1	\N	\N
1309	1431	757	1	\N	\N
1310	1432	757	1	\N	\N
1311	1433	1125	1	\N	\N
1312	1434	1125	1	\N	\N
1313	1435	1125	1	\N	\N
1314	1436	1140	1	\N	\N
1315	1437	757	1	\N	\N
1316	1438	1140	1	\N	\N
1317	1439	1140	1	\N	\N
1318	1440	1140	1	\N	\N
1319	1441	757	1	\N	\N
1320	1442	1139	1	\N	\N
1321	1443	1139	1	\N	\N
1322	1444	1125	1	\N	\N
1323	1445	1140	1	\N	\N
1324	1446	1139	1	\N	\N
1325	1447	1140	1	\N	\N
1326	1448	1139	1	\N	\N
1327	1449	1139	1	\N	\N
1328	1450	1139	1	\N	\N
1329	1451	1139	1	\N	\N
1330	1452	1139	1	\N	\N
1331	1453	1125	1	\N	\N
1332	1455	757	1	\N	\N
1333	1456	1140	1	\N	\N
1334	1457	1139	1	\N	\N
1335	1458	1139	1	\N	\N
1336	1459	757	1	\N	\N
1337	1460	757	1	\N	\N
1338	1461	1140	1	\N	\N
1339	1462	1170	1	\N	\N
1340	1463	1139	1	\N	\N
1341	1464	1140	1	\N	\N
1342	1465	1125	1	\N	\N
1343	1466	1140	1	\N	\N
1344	1467	1140	1	\N	\N
1345	1468	1140	1	\N	\N
1346	1469	1139	1	\N	\N
1347	1470	1139	1	\N	\N
1348	1471	1140	1	\N	\N
1349	1472	1139	1	\N	\N
1350	1473	1140	1	\N	\N
1351	1474	1140	1	\N	\N
1352	1475	1125	1	\N	\N
1353	1476	1139	1	\N	\N
1354	1477	1139	1	\N	\N
1355	1478	1125	1	\N	\N
1356	1479	1125	1	\N	\N
1357	1480	1125	1	\N	\N
1358	1481	1140	1	\N	\N
1359	1482	757	1	\N	\N
1360	1483	757	1	\N	\N
1361	1484	1125	1	\N	\N
1362	1485	1139	1	\N	\N
1363	1486	757	1	\N	\N
1364	1487	757	1	\N	\N
1365	1488	1139	1	\N	\N
1366	1489	1125	1	\N	\N
1367	1490	1125	1	\N	\N
1368	1491	1125	1	\N	\N
1369	1492	1140	1	\N	\N
1370	1493	757	1	\N	\N
1371	1494	1140	1	\N	\N
1372	1495	1140	1	\N	\N
1373	1496	1125	1	\N	\N
1374	1497	1125	1	\N	\N
1375	1498	1139	1	\N	\N
1376	1499	757	1	\N	\N
1377	1500	757	1	\N	\N
1378	1501	757	1	\N	\N
1379	1502	1139	1	\N	\N
1380	1503	1125	1	\N	\N
1381	1504	1140	1	\N	\N
1382	1505	1140	1	\N	\N
1383	1506	1125	1	\N	\N
1384	1507	1125	1	\N	\N
1385	1508	1125	1	\N	\N
1386	1509	1139	1	\N	\N
1387	1510	1139	1	\N	\N
1388	1512	1118	1	\N	\N
1389	1513	1139	1	\N	\N
1390	1515	1140	1	\N	\N
1391	1516	1140	1	\N	\N
1392	1517	757	1	\N	\N
1393	1518	1140	1	\N	\N
1394	1519	1140	1	\N	\N
1395	1520	1125	1	\N	\N
1396	1521	757	1	\N	\N
1397	1522	757	1	\N	\N
1398	1523	1139	1	\N	\N
1399	1524	757	1	\N	\N
1400	1525	757	1	\N	\N
1401	1526	1125	1	\N	\N
1402	1527	757	1	\N	\N
1403	1528	757	1	\N	\N
1404	1529	1125	1	\N	\N
1405	1530	1125	1	\N	\N
1406	1531	1139	1	\N	\N
1407	1532	1140	1	\N	\N
1408	1533	1140	1	\N	\N
1409	1534	757	1	\N	\N
1410	1535	1125	1	\N	\N
1411	1539	1125	1	\N	\N
1412	1540	1125	1	\N	\N
1413	1541	1140	1	\N	\N
1414	1542	1125	1	\N	\N
1415	1543	1139	1	\N	\N
1416	1544	757	1	\N	\N
1417	1545	757	1	\N	\N
1418	1546	1139	1	\N	\N
1419	1547	757	1	\N	\N
1420	1548	757	1	\N	\N
1421	1549	1140	1	\N	\N
1422	1550	1125	1	\N	\N
1423	1551	1139	1	\N	\N
1424	1552	1139	1	\N	\N
1425	1553	757	1	\N	\N
1426	1554	1140	1	\N	\N
1427	1555	1139	1	\N	\N
1428	1556	1125	1	\N	\N
1429	1557	1125	1	\N	\N
1430	1558	1125	1	\N	\N
1431	1560	1139	1	\N	\N
1432	1561	757	1	\N	\N
1433	1562	1139	1	\N	\N
1434	1563	757	1	\N	\N
1435	1564	1139	1	\N	\N
1436	1565	1125	1	\N	\N
1437	1566	1125	1	\N	\N
1438	1567	1139	1	\N	\N
1439	1568	757	1	\N	\N
1440	1569	1125	1	\N	\N
1441	1570	1140	1	\N	\N
1442	1571	757	1	\N	\N
1443	1572	1139	1	\N	\N
1444	1573	1139	1	\N	\N
1445	1574	1139	1	\N	\N
1446	1575	1125	1	\N	\N
1447	1576	1125	1	\N	\N
1448	1577	1125	1	\N	\N
1449	1578	757	1	\N	\N
1450	1579	1140	1	\N	\N
1451	1581	1139	1	\N	\N
1452	1582	757	1	\N	\N
1453	1583	1139	1	\N	\N
1454	1584	1139	1	\N	\N
1455	1585	1139	1	\N	\N
1456	1586	757	1	\N	\N
1457	1587	1140	1	\N	\N
1458	1588	1140	1	\N	\N
1459	1589	1140	1	\N	\N
1460	1590	757	1	\N	\N
1461	1591	1140	1	\N	\N
1462	1592	757	1	\N	\N
1463	1593	1140	1	\N	\N
1464	1594	1140	1	\N	\N
1465	1595	1140	1	\N	\N
1466	1596	757	1	\N	\N
1467	1597	757	1	\N	\N
1468	1598	1139	1	\N	\N
1469	1599	1125	1	\N	\N
1470	1600	1125	1	\N	\N
1471	1601	1125	1	\N	\N
1472	1602	1139	1	\N	\N
1473	1603	1140	1	\N	\N
1474	1604	1139	1	\N	\N
1475	1605	1140	1	\N	\N
1476	1606	1140	1	\N	\N
1477	1607	1125	1	\N	\N
1478	1608	1140	1	\N	\N
1479	1609	1125	1	\N	\N
1480	1610	1140	1	\N	\N
1481	1611	1139	1	\N	\N
1482	1612	1140	1	\N	\N
1483	1613	757	1	\N	\N
1484	1614	1139	1	\N	\N
1485	1615	1125	1	\N	\N
1486	1616	1140	1	\N	\N
1487	1617	1140	1	\N	\N
1488	1618	757	1	\N	\N
1489	1619	1140	1	\N	\N
1490	1620	757	1	\N	\N
1491	1621	757	1	\N	\N
1492	1622	1139	1	\N	\N
1493	1623	1125	1	\N	\N
1494	1624	1125	1	\N	\N
1495	1625	1140	1	\N	\N
1496	1626	1139	1	\N	\N
1497	1627	1125	1	\N	\N
1498	1628	1139	1	\N	\N
1499	1629	1139	1	\N	\N
1500	1630	757	1	\N	\N
1501	1631	1140	1	\N	\N
1502	1632	1125	1	\N	\N
1503	1633	1139	1	\N	\N
1504	1634	1125	1	\N	\N
1505	1635	1125	1	\N	\N
1506	1636	1125	1	\N	\N
1507	1637	1140	1	\N	\N
1508	1638	1139	1	\N	\N
1509	1639	1140	1	\N	\N
1510	1640	757	1	\N	\N
1511	1641	757	1	\N	\N
1512	1643	757	1	\N	\N
1513	1644	1125	1	\N	\N
1514	1645	1139	1	\N	\N
1515	1646	1125	1	\N	\N
1516	1647	1140	1	\N	\N
1517	1648	757	1	\N	\N
1518	1649	757	1	\N	\N
1519	1650	1139	1	\N	\N
1520	1651	1140	1	\N	\N
1521	1652	757	1	\N	\N
1522	1653	1125	1	\N	\N
1523	1654	757	1	\N	\N
1524	1655	757	1	\N	\N
1525	1656	1139	1	\N	\N
1526	1657	1125	1	\N	\N
1527	1658	1140	1	\N	\N
1528	1659	757	1	\N	\N
1529	1660	1125	1	\N	\N
1530	1661	1140	1	\N	\N
1531	1662	1140	1	\N	\N
1532	1663	1125	1	\N	\N
1533	1664	1125	1	\N	\N
1534	1665	1139	1	\N	\N
1535	1666	1140	1	\N	\N
1536	1667	757	1	\N	\N
1537	1668	1125	1	\N	\N
1538	1669	757	1	\N	\N
1539	1670	1139	1	\N	\N
1540	1671	1140	1	\N	\N
1541	1672	1125	1	\N	\N
1542	1673	1125	1	\N	\N
1543	1674	1125	1	\N	\N
1544	1675	757	1	\N	\N
1545	1676	1139	1	\N	\N
1546	1677	1125	1	\N	\N
1547	1678	1125	1	\N	\N
1548	1679	1125	1	\N	\N
1549	1680	1125	1	\N	\N
1550	1681	1140	1	\N	\N
1551	1682	757	1	\N	\N
1552	1683	757	1	\N	\N
1553	1684	1125	1	\N	\N
1554	1685	1140	1	\N	\N
1555	1686	1140	1	\N	\N
1556	1687	1140	1	\N	\N
1557	1688	1125	1	\N	\N
1558	1689	1140	1	\N	\N
1559	1690	757	1	\N	\N
1560	1691	1139	1	\N	\N
1561	1692	1139	1	\N	\N
1562	1693	757	1	\N	\N
1563	1694	1125	1	\N	\N
1564	1695	757	1	\N	\N
1565	1696	1125	1	\N	\N
1566	1697	757	1	\N	\N
1567	1698	1139	1	\N	\N
1568	1699	757	1	\N	\N
1569	1700	1140	1	\N	\N
1570	1701	1139	1	\N	\N
1571	1702	1125	1	\N	\N
1572	1703	1140	1	\N	\N
1573	1704	1140	1	\N	\N
1574	1705	1139	1	\N	\N
1575	1706	1140	1	\N	\N
1576	1707	1139	1	\N	\N
1577	1708	757	1	\N	\N
1578	1709	1140	1	\N	\N
1579	1710	1140	1	\N	\N
1580	1711	1140	1	\N	\N
1581	1712	1125	1	\N	\N
1582	1713	1125	1	\N	\N
1583	1714	1125	1	\N	\N
1584	1715	1140	1	\N	\N
1585	1716	1139	1	\N	\N
1586	1717	1125	1	\N	\N
1587	1718	757	1	\N	\N
1588	1719	757	1	\N	\N
1589	1720	1139	1	\N	\N
1590	1721	757	1	\N	\N
1591	1722	1139	1	\N	\N
1592	1723	1140	1	\N	\N
1593	1724	757	1	\N	\N
1594	1725	1139	1	\N	\N
1595	1726	757	1	\N	\N
1596	1727	1140	1	\N	\N
1597	1728	1140	1	\N	\N
1598	1729	1125	1	\N	\N
1599	1731	1140	1	\N	\N
1600	1732	1125	1	\N	\N
1601	1733	1125	1	\N	\N
1602	1734	757	1	\N	\N
1603	1735	1139	1	\N	\N
1604	1736	1139	1	\N	\N
1605	1737	757	1	\N	\N
1606	1738	1140	1	\N	\N
1607	1739	1139	1	\N	\N
1608	1740	757	1	\N	\N
1609	1741	757	1	\N	\N
1610	1742	1140	1	\N	\N
1611	1743	1140	1	\N	\N
1612	1744	757	1	\N	\N
1613	1745	1125	1	\N	\N
1614	1746	1125	1	\N	\N
1615	1747	1125	1	\N	\N
1616	1748	1125	1	\N	\N
1617	1749	1140	1	\N	\N
1618	1750	1140	1	\N	\N
1619	1751	1139	1	\N	\N
1620	1752	1125	1	\N	\N
1621	1753	1139	1	\N	\N
1622	1754	1139	1	\N	\N
1623	1755	1125	1	\N	\N
1624	1756	1125	1	\N	\N
1625	1758	1140	1	\N	\N
1626	1759	1139	1	\N	\N
1627	1760	1139	1	\N	\N
1628	1761	1139	1	\N	\N
1629	1762	1140	1	\N	\N
1630	1763	1139	1	\N	\N
1631	1764	1140	1	\N	\N
1632	1765	1125	1	\N	\N
1633	1766	1140	1	\N	\N
1634	1767	1140	1	\N	\N
1635	1768	1125	1	\N	\N
1636	1769	1140	1	\N	\N
1637	1770	1125	1	\N	\N
1638	1771	757	1	\N	\N
1639	1772	1139	1	\N	\N
1640	1773	757	1	\N	\N
1641	1776	1140	1	\N	\N
1642	1777	1139	1	\N	\N
1643	1778	1139	1	\N	\N
1644	1779	1125	1	\N	\N
1645	1780	757	1	\N	\N
1646	1781	1139	1	\N	\N
1647	1782	1139	1	\N	\N
1648	1783	1140	1	\N	\N
1649	1784	757	1	\N	\N
1650	1785	1139	1	\N	\N
1651	1786	1125	1	\N	\N
1652	1787	1139	1	\N	\N
1653	1788	1139	1	\N	\N
1654	1789	1125	1	\N	\N
1655	1793	1139	1	\N	\N
1656	1794	1139	1	\N	\N
1657	1795	1139	1	\N	\N
1658	1796	757	1	\N	\N
1659	1797	1125	1	\N	\N
1660	1798	1140	1	\N	\N
1661	1799	1139	1	\N	\N
1662	1800	1139	1	\N	\N
1663	1801	757	1	\N	\N
1664	1802	757	1	\N	\N
1665	1803	1125	1	\N	\N
1666	1804	1125	1	\N	\N
1667	1805	757	1	\N	\N
1668	1806	1139	1	\N	\N
1669	1807	1139	1	\N	\N
1670	1808	1140	1	\N	\N
1671	1809	1139	1	\N	\N
1672	1810	1139	1	\N	\N
1673	1811	1125	1	\N	\N
1674	1812	1125	1	\N	\N
1675	1813	1125	1	\N	\N
1676	1814	1125	1	\N	\N
1677	1815	1139	1	\N	\N
1678	1816	1140	1	\N	\N
1679	1817	1140	1	\N	\N
1680	1818	1140	1	\N	\N
1681	1819	1140	1	\N	\N
1682	1820	1125	1	\N	\N
1683	1821	757	1	\N	\N
1684	1822	1139	1	\N	\N
1685	1823	757	1	\N	\N
1686	1824	1125	1	\N	\N
1687	1825	1139	1	\N	\N
1688	1826	1139	1	\N	\N
1689	1827	757	1	\N	\N
1690	1828	1139	1	\N	\N
1691	1829	1140	1	\N	\N
1692	1830	1139	1	\N	\N
1693	1831	1125	1	\N	\N
1694	1832	1139	1	\N	\N
1695	1833	1140	1	\N	\N
1696	1834	1139	1	\N	\N
1697	1835	757	1	\N	\N
1698	1836	757	1	\N	\N
1699	1837	1125	1	\N	\N
1700	1838	1125	1	\N	\N
1701	1839	757	1	\N	\N
1702	1840	1139	1	\N	\N
1703	1841	1140	1	\N	\N
1704	1845	757	1	\N	\N
1705	1847	1125	1	\N	\N
1706	1848	1139	1	\N	\N
1707	1849	1125	1	\N	\N
1708	1850	1139	1	\N	\N
1709	1851	757	1	\N	\N
1710	1852	1140	1	\N	\N
1711	1853	1139	1	\N	\N
1712	1854	1125	1	\N	\N
1713	1855	1125	1	\N	\N
1714	1856	757	1	\N	\N
1715	1857	1140	1	\N	\N
1716	1858	1140	1	\N	\N
1717	1859	757	1	\N	\N
1718	1860	1139	1	\N	\N
1719	1861	757	1	\N	\N
1720	1862	1139	1	\N	\N
1721	1863	1125	1	\N	\N
1722	1864	1125	1	\N	\N
1723	1865	757	1	\N	\N
1724	1866	1125	1	\N	\N
1725	1867	757	1	\N	\N
1726	1868	1125	1	\N	\N
1727	1869	1125	1	\N	\N
1728	1870	1140	1	\N	\N
1729	1871	1140	1	\N	\N
1730	1872	1140	1	\N	\N
1731	1873	1125	1	\N	\N
1732	1874	1140	1	\N	\N
1733	1875	1125	1	\N	\N
1734	1876	757	1	\N	\N
1735	1877	1125	1	\N	\N
1736	1878	1140	1	\N	\N
1737	1879	1140	1	\N	\N
1738	1880	1125	1	\N	\N
1739	1881	1140	1	\N	\N
1740	1882	1139	1	\N	\N
1741	1883	757	1	\N	\N
1742	1884	1140	1	\N	\N
1743	1885	1140	1	\N	\N
1744	1886	1125	1	\N	\N
1745	1887	1125	1	\N	\N
1746	1888	1140	1	\N	\N
1747	1889	1139	1	\N	\N
1748	1890	1140	1	\N	\N
1749	1891	1140	1	\N	\N
1750	1892	1125	1	\N	\N
1751	1893	757	1	\N	\N
1752	1894	1125	1	\N	\N
1753	1895	1125	1	\N	\N
1754	1896	1125	1	\N	\N
1755	1897	1125	1	\N	\N
1756	1898	1125	1	\N	\N
1757	1899	1140	1	\N	\N
1758	1900	1125	1	\N	\N
1759	1901	1125	1	\N	\N
1760	1902	1139	1	\N	\N
1761	1903	757	1	\N	\N
1762	1904	1125	1	\N	\N
1763	1905	1139	1	\N	\N
1764	1906	1139	1	\N	\N
1765	1907	1140	1	\N	\N
1766	1908	1140	1	\N	\N
1767	1909	1125	1	\N	\N
1768	1910	1125	1	\N	\N
1769	1911	757	1	\N	\N
1770	1912	1140	1	\N	\N
1771	1913	1139	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	30	8	Primary Grouping Principle Type Term	\N
2	31	8	Primary Purpose Type Term	\N
3	33	8	GeographicRegionLevel4Term	\N
4	34	8	GeographicRegionLevel2Term	\N
5	35	8	GeographicRegionLevel3Term	\N
6	36	8	Institution Type Term	\N
7	37	8	Publication Citation	\N
8	38	8	Kind Of Specimen Term	\N
9	39	8	Nomenclatural Note Type Term	\N
10	40	8	Basis Of Record Term	\N
11	257	8	Ontology	\N
12	257	8	Ontology	\N
13	258	8	OntologyProperty	\N
14	258	8	OntologyProperty	\N
15	259	8	administrative territorial entity of France (Wikidata)	\N
16	259	8	administrative territorial entity of France (Wikidata)	\N
17	260	8	island (Wikidata)	\N
18	260	8	island (Wikidata)	\N
19	261	8	Taxon Name	\N
20	302	8	Area	\N
21	303	8	BinomialNameID	\N
22	479	8	TaxonRank	\N
23	480	8	Introduced Occurrence Status Term	\N
24	659	8	Nomenclatural Code Term	\N
25	690	8	DataRange	\N
26	690	8	DataRange	\N
27	691	8	Status of a taxon attested by a legal document	en
28	738	8	Class	\N
29	740	8	Class	\N
30	740	8	Class	\N
31	742	8	commune of France (Wikidata)	\N
32	742	8	commune of France (Wikidata)	\N
33	743	8	archipelago (Wikidata)	\N
34	743	8	archipelago (Wikidata)	\N
35	744	8	region of France (Wikidata)	\N
36	744	8	region of France (Wikidata)	\N
37	745	8	overseas collectivity (Wikidata)	\N
38	745	8	overseas collectivity (Wikidata)	\N
39	748	8	SpeciesConcept	\N
40	757	8	Identification	\N
41	906	8	InverseFunctionalProperty	\N
42	906	8	InverseFunctionalProperty	\N
43	907	8	ObjectProperty	\N
44	907	8	ObjectProperty	\N
45	914	8	SymmetricProperty	\N
46	914	8	SymmetricProperty	\N
47	915	8	FunctionalProperty	\N
48	915	8	FunctionalProperty	\N
49	918	8	Native Occurrence Status Term	\N
50	919	8	Present Occurrence Status Term	\N
51	954	8	Sex	\N
52	960	8	Development Status Term	\N
53	961	8	Collection Type Term	\N
54	962	8	Cyclicity Term	\N
55	963	8	Taxon Relationship Term	\N
56	964	8	Nomenclatural Type Type	\N
57	979	8	phase of life	\N
58	1006	8	conservation status (Wikidata)	\N
59	1006	8	conservation status (Wikidata)	\N
60	1109	8	Restriction	\N
61	1109	8	Restriction	\N
62	1110	8	DatatypeProperty	\N
63	1110	8	DatatypeProperty	\N
64	1111	8	AnnotationProperty	\N
65	1111	8	AnnotationProperty	\N
66	1114	8	department of France (Wikidata)	\N
67	1114	8	department of France (Wikidata)	\N
68	1115	8	territorial entity (Wikidata)	\N
69	1115	8	territorial entity (Wikidata)	\N
70	1116	8	Maritime area	en
71	1139	8	Occurrence	\N
72	1140	8	SpeciesIndividual	\N
73	1170	8	TaxonNameID	\N
74	1171	8	TrinomialNameID	\N
75	1294	8	SurrogateNameID	\N
76	1332	8	TransitiveProperty	\N
77	1332	8	TransitiveProperty	\N
78	1333	8	Taxon Rank Term	\N
79	1334	8	Absent Occurrence Status Term	\N
80	1537	8	AllDifferent	\N
81	1537	8	AllDifferent	\N
82	1538	8	IUCN Red List status of a taxon in a geographical area, according to a bibliographic source	en
83	1580	8	sovereign state (Wikidata)	\N
84	1580	8	sovereign state (Wikidata)	\N
85	1757	8	Biogeographical status of a taxon in a geographical area, according to a bibliographic source	en
86	1774	8	Kingdom Type Term	\N
87	1775	8	Conservation Status Type Term	\N
88	1842	8	Institution Type Term	\N
89	1843	8	GeographicRegionLevel1Term	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
266	http://www.openlinksw.com/schemas/VAD#	4	\N	f	311			287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1033	http://lod.taxonconcept.org/ses/VVYMq.html#Image	1	\N	f	883	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1115	http://www.wikidata.org/entity/Q1496967	17	\N	t	12	Q1496967	[territorial entity (Wikidata) (Q1496967)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3121382
1694	http://lod.taxonconcept.org/ses/e4rKE.html#Image	1	\N	f	1256	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1	http://lod.taxonconcept.org/ses/Tf8vT.html#Identification	2	\N	f	78	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
2	http://lod.taxonconcept.org/ses/KDldJ.html#Identification	3	\N	f	79	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
3	http://lod.taxonconcept.org/ses/lGGpI.html#Image	1	\N	f	80	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
4	http://lod.taxonconcept.org/ses/RTuSD.html#Image	1	\N	f	81	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
5	http://lod.taxonconcept.org/ses/dJ8Bq.html#Image	1	\N	f	82	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://lod.taxonconcept.org/ses/G4Qkr.rdf#Occurrence	4	\N	f	83	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
7	http://lod.taxonconcept.org/ses/V39Te.html#Identification	1	\N	f	84	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	http://lod.taxonconcept.org/ses/OvsHQ.rdf#Individual	1	\N	f	85	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
9	http://lod.taxonconcept.org/ses/onbrF.html#Identification	2	\N	f	86	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
10	http://lod.taxonconcept.org/ses/VvUQc.html#Identification	1	\N	f	87	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	http://lod.taxonconcept.org/ses/HsAta.rdf#Occurrence	1	\N	f	88	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
12	http://lod.taxonconcept.org/ses/eYgn3.rdf#Individual	2	\N	f	89	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
13	http://lod.taxonconcept.org/ses/JSfMW.html#Identification	1	\N	f	90	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
14	http://lod.taxonconcept.org/ses/JSfMW.rdf#Individual	1	\N	f	91	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
15	http://lod.taxonconcept.org/ses/nHt7g.rdf#Occurrence	1	\N	f	92	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
16	http://lod.taxonconcept.org/ses/DNnGE.html#Identification	2	\N	f	93	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://lod.taxonconcept.org/ses/DNnGE.rdf#Individual	2	\N	f	94	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://lod.taxonconcept.org/ses/XIVcc.html#Image	1	\N	f	95	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
19	http://lod.taxonconcept.org/ses/55wtq.html#Image	1	\N	f	96	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
20	http://lod.taxonconcept.org/ses/7Ro3R.html#Image	1	\N	f	97	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
21	http://lod.taxonconcept.org/ses/4E57e.html#Image	1	\N	f	98	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://lod.taxonconcept.org/ses/76jBF.html#Identification	3	\N	f	99	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	http://lod.taxonconcept.org/ses/ZZaxg.rdf#Individual	2	\N	f	100	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
24	http://lod.taxonconcept.org/ses/ieRRx.html#Identification	1	\N	f	101	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
25	http://lod.taxonconcept.org/ses/sK3lK.html#Image	1	\N	f	102	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
26	http://rdf.geospecies.org/ont/geospecies#Location	40	\N	t	69	Location	Location	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	156
27	http://purl.org/dc/terms/Location	39	\N	t	5	Location	Location	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	155
28	http://rdf.geospecies.org/ont/geospecies#Observation	13	\N	t	69	Observation	Observation	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91
29	http://usefulinc.com/ns/doap#Project	1	\N	f	76	Project	Project	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
30	http://rs.tdwg.org/ontology/voc/Collection#PrimaryGroupingPrincipleTypeTerm	12	\N	t	103	PrimaryGroupingPrincipleTypeTerm	PrimaryGroupingPrincipleTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
31	http://rs.tdwg.org/ontology/voc/Collection#PrimaryPurposeTypeTerm	9	\N	f	103	PrimaryPurposeTypeTerm	PrimaryPurposeTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
32	http://rs.tdwg.org/ontology/voc/ContactDetails#ContactTypeTerm	14	\N	t	104	ContactTypeTerm	ContactTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
33	http://rs.tdwg.org/ontology/voc/GeographicRegion#GeographicRegionLevel4Term	609	\N	t	105	GeographicRegionLevel4Term	GeographicRegionLevel4Term	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
34	http://rs.tdwg.org/ontology/voc/GeographicRegion#GeographicRegionLevel2Term	52	\N	t	105	GeographicRegionLevel2Term	GeographicRegionLevel2Term	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	369
35	http://rs.tdwg.org/ontology/voc/GeographicRegion#GeographicRegionLevel3Term	369	\N	t	105	GeographicRegionLevel3Term	GeographicRegionLevel3Term	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	609
36	http://rs.tdwg.org/ontology/voc/InstitutionType#InstitutionTypeTerm	26	\N	t	106	InstitutionTypeTerm	InstitutionTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
37	http://rs.tdwg.org/ontology/voc/PublicationCitation#PublicationTypeTerm	22	\N	t	107	PublicationTypeTerm	PublicationTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
38	http://rs.tdwg.org/ontology/voc/Specimen#KindOfSpecimenTerm	7	\N	f	108	KindOfSpecimenTerm	KindOfSpecimenTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
39	http://rs.tdwg.org/ontology/voc/TaxonName#NomenclaturalNoteTypeTerm	7	\N	f	109	NomenclaturalNoteTypeTerm	NomenclaturalNoteTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
40	http://rs.tdwg.org/ontology/voc/TaxonOccurrence#BasisOfRecordTerm	7	\N	f	110	BasisOfRecordTerm	BasisOfRecordTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://rs.tdwg.org/ontology/voc/TaxonOccurrenceInteraction#InteractionTerm	15	\N	t	111	InteractionTerm	InteractionTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
42	http://www.w3.org/2002/07/owl#IrreflexiveProperty	4	\N	f	7	IrreflexiveProperty	IrreflexiveProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
43	http://www.w3.org/2002/07/owl#ReflexiveProperty	1	\N	f	7	ReflexiveProperty	ReflexiveProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
44	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#Human_Malarial_Pathogen_with_Mosquito_Vector	5	\N	f	112	Human_Malarial_Pathogen_with_Mosquito_Vector	Human_Malarial_Pathogen_with_Mosquito_Vector	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
45	http://rdf.geospecies.org/ont/geospecies#OpenCycConcept	48	\N	t	69	OpenCycConcept	OpenCycConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68
46	http://lod.taxonconcept.org/ses/2B4yu.html#Image	1	\N	f	113	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
47	http://lod.taxonconcept.org/ses/cASOl.html#Image	1	\N	f	114	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
48	http://lod.taxonconcept.org/ses/3d2Xq.rdf#Individual	3	\N	f	115	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
49	http://lod.taxonconcept.org/ses/H83ZL.rdf#Occurrence	2	\N	f	116	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
50	http://lod.taxonconcept.org/ses/kuDfK.html#Identification	2	\N	f	117	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
51	http://lod.taxonconcept.org/ses/hHgqU.rdf#Individual	8	\N	f	118	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
52	http://lod.taxonconcept.org/ses/a2eUs.rdf#Individual	1	\N	f	119	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://lod.taxonconcept.org/ses/QEBQB.rdf#Occurrence	3	\N	f	120	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
54	http://lod.taxonconcept.org/ses/iur2i.html#Identification	3	\N	f	121	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
55	http://lod.taxonconcept.org/ses/iur2i.rdf#Individual	3	\N	f	122	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
56	http://lod.taxonconcept.org/ses/q2tpr.html#Image	1	\N	f	123	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
57	http://schema.org/Person	56710	\N	t	9	Person	Person	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56722
58	http://www.w3.org/ns/prov#Activity	1	\N	f	26	Activity	Activity	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
59	http://www.w3.org/ns/dcat#DataService	1	\N	f	15	DataService	DataService	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
60	http://purl.org/ontology/bibo/AcademicArticle	3	\N	f	31	AcademicArticle	AcademicArticle	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
61	http://lod.taxonconcept.org/ontology/mos_path.owl#Human_Viral_Pathogen_with_Mosquito_Vector	3	\N	f	124	Human_Viral_Pathogen_with_Mosquito_Vector	Human_Viral_Pathogen_with_Mosquito_Vector	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
62	http://lod.taxonconcept.org/ses/2tyCC.html#Identification	3	\N	f	125	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
63	http://lod.taxonconcept.org/ses/lPpMB.rdf#Individual	1	\N	f	126	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
64	http://lod.taxonconcept.org/ses/22wQv.rdf#Individual	1	\N	f	127	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
65	http://lod.taxonconcept.org/ses/CQJBJ.html#Identification	4	\N	f	128	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
66	http://lod.taxonconcept.org/ses/u7nsW.rdf#Individual	1	\N	f	129	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
67	http://lod.taxonconcept.org/ses/Badsm.html#Identification	4	\N	f	130	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
68	http://lod.taxonconcept.org/ses/pC9k6.html#Identification	1	\N	f	131	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
69	http://lod.taxonconcept.org/ses/5lVeo.html#Identification	9	\N	f	132	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
70	http://lod.taxonconcept.org/ses/BYWpt.rdf#Individual	1	\N	f	133	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
71	http://lod.taxonconcept.org/ses/n78LR.rdf#Occurrence	9	\N	f	134	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
72	http://lod.taxonconcept.org/ses/7fYuR.rdf#Occurrence	1	\N	f	135	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
73	http://lod.taxonconcept.org/ses/Hak3o.rdf#Occurrence	8	\N	f	136	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
74	http://lod.taxonconcept.org/ses/lUyDP.rdf#Individual	5	\N	f	137	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://lod.taxonconcept.org/ses/iRnzQ.rdf#Individual	1	\N	f	138	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
76	http://lod.taxonconcept.org/ses/ZoeKQ.rdf#Occurrence	2	\N	f	139	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
77	http://lod.taxonconcept.org/ses/xowGc.rdf#Occurrence	2	\N	f	140	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
78	http://lod.taxonconcept.org/ses/RxQZ9.html#Identification	1	\N	f	141	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
79	http://lod.taxonconcept.org/ses/7fvpi.rdf#Occurrence	1	\N	f	142	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
80	http://lod.taxonconcept.org/ses/ar4Fe.rdf#Occurrence	1	\N	f	143	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
81	http://lod.taxonconcept.org/ses/47C3Q.rdf#Individual	2	\N	f	144	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
82	http://lod.taxonconcept.org/ses/PEOGy.html#Identification	4	\N	f	145	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
83	http://lod.taxonconcept.org/ses/9OwwE.html#Identification	13	\N	t	146	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
84	http://lod.taxonconcept.org/ses/yqkNV.rdf#Occurrence	3	\N	f	147	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
85	http://lod.taxonconcept.org/ses/NKoA6.html#Identification	1	\N	f	148	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
86	http://lod.taxonconcept.org/ses/AoOQH.html#Identification	4	\N	f	149	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
87	http://lod.taxonconcept.org/ses/5xLy9.html#Identification	2	\N	f	150	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
88	http://lod.taxonconcept.org/ses/Y2xzp.html#Image	1	\N	f	151	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
89	http://lod.taxonconcept.org/ses/krVXP.html#Image	1	\N	f	152	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
90	http://lod.taxonconcept.org/ses/jv8CV.html#Image	1	\N	f	153	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
91	http://lod.taxonconcept.org/ses/opdWv.html#Image	1	\N	f	154	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
92	http://lod.taxonconcept.org/ses/pyaxa.html#Image	1	\N	f	155	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
93	http://lod.taxonconcept.org/ses/oQgef.html#Image	1	\N	f	156	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
94	http://lod.taxonconcept.org/ses/XbTtl.rdf#Occurrence	4	\N	f	157	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
95	http://lod.taxonconcept.org/ses/6JCRu.html#Identification	3	\N	f	158	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
96	http://lod.taxonconcept.org/ses/pC9k6.rdf#Occurrence	1	\N	f	159	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
97	http://lod.taxonconcept.org/ses/DEwaC.html#Identification	3	\N	f	160	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
98	http://lod.taxonconcept.org/ses/5lVeo.rdf#Individual	9	\N	f	161	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
99	http://lod.taxonconcept.org/ses/gf8Bh.html#Identification	3	\N	f	162	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
100	http://lod.taxonconcept.org/ses/gf8Bh.rdf#Individual	3	\N	f	163	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
101	http://lod.taxonconcept.org/ses/KfOVX.rdf#Individual	4	\N	f	164	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
102	http://lod.taxonconcept.org/ses/3EQhU.html#Identification	2	\N	f	165	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
103	http://lod.taxonconcept.org/ses/3EQhU.rdf#Individual	2	\N	f	166	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
104	http://lod.taxonconcept.org/ses/2iG3r.html#Identification	2	\N	f	167	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
105	http://lod.taxonconcept.org/ses/S75nv.rdf#Individual	1	\N	f	168	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
106	http://lod.taxonconcept.org/ses/S75nv.rdf#Occurrence	1	\N	f	168	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
107	http://lod.taxonconcept.org/ses/EcTQM.rdf#Occurrence	1	\N	f	169	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
108	http://lod.taxonconcept.org/ses/4PDlb.html#Identification	2	\N	f	170	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
109	http://lod.taxonconcept.org/ses/4PDlb.rdf#Occurrence	2	\N	f	171	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
110	http://lod.taxonconcept.org/ses/xowGc.rdf#Individual	2	\N	f	140	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
111	http://lod.taxonconcept.org/ses/E4TKF.html#Identification	3	\N	f	172	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
112	http://lod.taxonconcept.org/ses/5Vv5k.rdf#Occurrence	1	\N	f	173	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
113	http://lod.taxonconcept.org/ses/PPOlM.rdf#Individual	1	\N	f	174	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
114	http://lod.taxonconcept.org/ses/BGfwX.rdf#Occurrence	2	\N	f	175	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
115	http://lod.taxonconcept.org/ses/JEjhv.rdf#Individual	3	\N	f	176	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
116	http://lod.taxonconcept.org/ses/kQmp4.html#Image	1	\N	f	177	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
117	http://lod.taxonconcept.org/ses/zIYJR.html#Image	1	\N	f	178	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
118	http://lod.taxonconcept.org/ses/Q2isl.html#Image	1	\N	f	179	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
119	http://lod.taxonconcept.org/ses/TDlyP.html#Image	1	\N	f	180	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
120	http://lod.taxonconcept.org/ses/ggUul.html#Image	1	\N	f	181	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
121	http://lod.taxonconcept.org/ses/LsXcv.html#Image	1	\N	f	182	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
122	http://lod.taxonconcept.org/ses/aw8Ao.html#Image	1	\N	f	183	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
123	http://lod.taxonconcept.org/ses/QXRSb.html#Identification	3	\N	f	184	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
124	http://lod.taxonconcept.org/ses/PQLdJ.rdf#Occurrence	3	\N	f	185	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
125	http://lod.taxonconcept.org/ses/uDNbR.rdf#Occurrence	1	\N	f	186	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
126	http://lod.taxonconcept.org/ses/ELuqP.html#Identification	1	\N	f	187	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
127	http://lod.taxonconcept.org/ses/HsAta.html#Identification	1	\N	f	188	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
128	http://lod.taxonconcept.org/ses/dGOc2.rdf#Occurrence	2	\N	f	189	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
129	http://lod.taxonconcept.org/ses/WKNeI.rdf#Occurrence	1	\N	f	190	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
130	http://lod.taxonconcept.org/ses/BS2sL.html#Identification	1	\N	f	191	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
131	http://lod.taxonconcept.org/ses/im3e6.rdf#Individual	2	\N	f	192	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
132	http://lod.taxonconcept.org/ses/LGFPI.html#Identification	3	\N	f	193	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
133	http://lod.taxonconcept.org/ses/LGFPI.rdf#Occurrence	3	\N	f	194	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
134	http://lod.taxonconcept.org/ses/7fvpi.rdf#Individual	1	\N	f	142	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
135	http://lod.taxonconcept.org/ses/76jBF.rdf#Occurrence	3	\N	f	195	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
136	http://lod.taxonconcept.org/ses/gjg3k.rdf#Individual	2	\N	f	196	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
137	http://lod.taxonconcept.org/ses/tyYjt.html#Identification	1	\N	f	197	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
138	http://lod.taxonconcept.org/ses/QXRSb.rdf#Occurrence	3	\N	f	198	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
139	http://lod.taxonconcept.org/ses/Iq3nt.rdf#Occurrence	1	\N	f	199	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
140	http://lod.taxonconcept.org/ses/PfzSj.html#Identification	5	\N	f	200	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
141	http://lod.taxonconcept.org/ses/O2AUE.rdf#Individual	1	\N	f	201	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
142	http://lod.taxonconcept.org/ses/ITmfL.rdf#Occurrence	6	\N	f	202	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
143	http://lod.taxonconcept.org/ses/AFYz2.rdf#Individual	1	\N	f	203	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
144	http://lod.taxonconcept.org/ses/24NNq.rdf#Occurrence	3	\N	f	204	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
145	http://lod.taxonconcept.org/ses/vMHzJ.rdf#Occurrence	2	\N	f	205	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
146	http://lod.taxonconcept.org/ses/ITHVA.rdf#Occurrence	1	\N	f	206	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
147	http://lod.taxonconcept.org/ses/HefRJ.rdf#Individual	1	\N	f	207	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
148	http://lod.taxonconcept.org/ses/TGRxf.html#Image	1	\N	f	208	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
149	http://lod.taxonconcept.org/ses/osHpy.html#Image	1	\N	f	209	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
150	http://lod.taxonconcept.org/ses/vxTjv.html#Image	1	\N	f	210	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
151	http://lod.taxonconcept.org/ses/sMXn9.html#Image	1	\N	f	211	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
152	http://lod.taxonconcept.org/ses/rQgRD.html#Image	1	\N	f	212	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
153	http://lod.taxonconcept.org/ses/XaS5Y.rdf#Individual	2	\N	f	213	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
154	http://lod.taxonconcept.org/ses/iVwKh.html#Identification	2	\N	f	214	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
155	http://lod.taxonconcept.org/ses/EkAt6.rdf#Individual	2	\N	f	215	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
156	http://lod.taxonconcept.org/ses/3kr7b.html#Identification	3	\N	f	216	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
157	http://lod.taxonconcept.org/ses/x6gDo.html#Identification	1	\N	f	217	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
158	http://lod.taxonconcept.org/ses/LTQnq.rdf#Individual	4	\N	f	218	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
159	http://lod.taxonconcept.org/ses/bBKp5.html#Identification	1	\N	f	219	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
160	http://lod.taxonconcept.org/ses/8fG4V.html#Identification	1	\N	f	220	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
161	http://lod.taxonconcept.org/ses/NwonD.html#Identification	4	\N	f	221	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
162	http://lod.taxonconcept.org/ses/7V2jK.html#Identification	2	\N	f	222	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
163	http://lod.taxonconcept.org/ses/QXRZr.html#Identification	1	\N	f	223	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
164	http://lod.taxonconcept.org/ses/D8qet.html#Identification	1	\N	f	224	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
165	http://lod.taxonconcept.org/ses/VnzyW.html#Identification	1	\N	f	225	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
166	http://lod.taxonconcept.org/ses/DF5Ct.html#Identification	1	\N	f	226	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
167	http://lod.taxonconcept.org/ses/J3wHF.html#Image	1	\N	f	227	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
168	http://lod.taxonconcept.org/ses/ijKNL.html#Image	1	\N	f	228	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
169	http://lod.taxonconcept.org/ses/8fhlX.html#Image	1	\N	f	229	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
170	http://lod.taxonconcept.org/ses/3rDWv.html#Image	1	\N	f	230	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
171	http://lod.taxonconcept.org/ses/pLLpu.html#Identification	2	\N	f	231	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
172	http://lod.taxonconcept.org/ses/EfxcN.html#Identification	1	\N	f	232	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
173	http://lod.taxonconcept.org/ses/olWBu.html#Identification	2	\N	f	233	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
174	http://lod.taxonconcept.org/ses/3g4bi.html#Identification	2	\N	f	234	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
175	http://lod.taxonconcept.org/ses/5tLPt.html#Identification	3	\N	f	235	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
176	http://lod.taxonconcept.org/ses/EMkPp.rdf#Occurrence	3	\N	f	236	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
177	http://lod.taxonconcept.org/ses/AoOQH.rdf#Occurrence	4	\N	f	237	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
178	http://lod.taxonconcept.org/ses/YM43a.rdf#Individual	4	\N	f	238	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
179	http://lod.taxonconcept.org/ses/YM43a.rdf#Occurrence	4	\N	f	238	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
180	http://lod.taxonconcept.org/ses/xLFBZ.html#Identification	1	\N	f	239	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
181	http://lod.taxonconcept.org/ses/JGok6.html#Identification	2	\N	f	240	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
182	http://lod.taxonconcept.org/ses/Bk9pZ.rdf#Individual	3	\N	f	241	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
183	http://lod.taxonconcept.org/ses/Bk9pZ.rdf#Occurrence	3	\N	f	241	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
184	http://lod.taxonconcept.org/ses/iVwKh.rdf#Individual	2	\N	f	242	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
185	http://lod.taxonconcept.org/ses/mVX7P.html#Identification	1	\N	f	243	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
186	http://lod.taxonconcept.org/ses/EkAt6.html#Identification	2	\N	f	244	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
187	http://lod.taxonconcept.org/ses/wxdNW.html#Identification	1	\N	f	245	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
188	http://lod.taxonconcept.org/ses/cWJQQ.rdf#Occurrence	2	\N	f	246	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
189	http://lod.taxonconcept.org/ses/QEBQB.html#Identification	3	\N	f	247	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
190	http://lod.taxonconcept.org/ses/74owc.rdf#Individual	2	\N	f	248	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
191	http://lod.taxonconcept.org/ses/XmjNm.rdf#Individual	1	\N	f	249	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
192	http://lod.taxonconcept.org/ses/Q7pVA.rdf#Individual	2	\N	f	250	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
193	http://lod.taxonconcept.org/ses/umNwC.rdf#Individual	1	\N	f	251	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
194	http://lod.taxonconcept.org/ses/PEOGy.rdf#Occurrence	4	\N	f	252	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
195	http://lod.taxonconcept.org/ses/6bIB4.html#Image	1	\N	f	253	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
196	http://lod.taxonconcept.org/ses/olWBu.rdf#Individual	2	\N	f	254	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
197	http://lod.taxonconcept.org/ses/926R4.html#Identification	1	\N	f	255	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
198	http://lod.taxonconcept.org/ses/EQZJW.rdf#Individual	5	\N	f	256	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
199	http://lod.taxonconcept.org/ses/u6Qgt.rdf#Individual	2	\N	f	257	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
200	http://lod.taxonconcept.org/ses/W5fWB.rdf#Individual	1	\N	f	258	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
201	http://lod.taxonconcept.org/ses/5Vv5k.html#Identification	1	\N	f	259	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
202	http://lod.taxonconcept.org/ses/VmbzI.rdf#Occurrence	1	\N	f	260	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
203	http://lod.taxonconcept.org/ses/mYtsK.rdf#Occurrence	1	\N	f	261	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
204	http://lod.taxonconcept.org/ses/HaAJw.html#Identification	1	\N	f	262	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
205	http://lod.taxonconcept.org/ses/pOpJI.rdf#Occurrence	2	\N	f	263	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
206	http://lod.taxonconcept.org/ses/igYj6.html#Identification	1	\N	f	264	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
207	http://lod.taxonconcept.org/ses/2BQq2.html#Image	1	\N	f	265	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
208	http://lod.taxonconcept.org/ses/3ufgM.html#Image	1	\N	f	266	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
209	http://lod.taxonconcept.org/ses/u7nsW.html#Identification	1	\N	f	267	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
210	http://lod.taxonconcept.org/ses/9BRBU.html#Image	1	\N	f	268	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
211	http://lod.taxonconcept.org/ses/e6dPZ.rdf#Individual	1	\N	f	269	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
212	http://lod.taxonconcept.org/ses/Dr525.html#Image	1	\N	f	270	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
213	http://lod.taxonconcept.org/ses/Msb9D.rdf#Occurrence	4	\N	f	271	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
214	http://lod.taxonconcept.org/ses/ioT3D.html#Image	1	\N	f	272	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
215	http://lod.taxonconcept.org/ses/dGA7c.html#Identification	2	\N	f	273	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
216	http://lod.taxonconcept.org/ses/tyYjt.rdf#Individual	1	\N	f	274	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
217	http://lod.taxonconcept.org/ses/fGg5g.html#Image	1	\N	f	275	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
218	http://lod.taxonconcept.org/ses/nSZro.html#Identification	1	\N	f	276	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
219	http://lod.taxonconcept.org/ses/XIHap.html#Identification	2	\N	f	277	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
220	http://lod.taxonconcept.org/ses/Kmtil.html#Image	1	\N	f	278	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
221	http://lod.taxonconcept.org/ses/N7mve.rdf#Occurrence	1	\N	f	279	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
222	http://lod.taxonconcept.org/ses/tTEIq.html#Image	1	\N	f	280	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
223	http://lod.taxonconcept.org/ses/opxLi.html#Image	1	\N	f	281	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
224	http://lod.taxonconcept.org/ses/HVNCA.html#Identification	2	\N	f	282	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
225	http://lod.taxonconcept.org/ses/48haV.html#Image	1	\N	f	283	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
226	http://lod.taxonconcept.org/ses/ofV9x.html#Image	1	\N	f	284	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
227	http://lod.taxonconcept.org/ses/itdft.rdf#Occurrence	1	\N	f	285	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
228	http://www.w3.org/2002/07/owl#Axiom	386552	\N	t	7	Axiom	Axiom	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
229	http://lod.taxonconcept.org/ses/BCAVn.rdf#Occurrence	2	\N	f	286	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
230	http://lod.taxonconcept.org/ses/s32nE.rdf#Individual	1	\N	f	287	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
231	http://lod.taxonconcept.org/ses/XNbWx.rdf#Individual	1	\N	f	288	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
232	http://lod.taxonconcept.org/ses/NwID5.html#Identification	1	\N	f	289	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
233	http://lod.taxonconcept.org/ses/kvjFY.html#Identification	2	\N	f	290	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
234	http://lod.taxonconcept.org/ses/YEqea.rdf#Individual	3	\N	f	291	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
235	http://lod.taxonconcept.org/ses/QmJnc.rdf#Individual	1	\N	f	292	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
236	http://lod.taxonconcept.org/ses/iWJLJ.html#Identification	2	\N	f	293	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
237	http://lod.taxonconcept.org/ses/VhPqt.html#Image	1	\N	f	294	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
238	http://lod.taxonconcept.org/ses/ArS7W.html#Identification	1	\N	f	295	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
239	http://lod.taxonconcept.org/ses/SOBUF.html#Image	1	\N	f	296	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
240	http://lod.taxonconcept.org/ses/DhWpJ.html#Identification	1	\N	f	297	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
241	http://lod.taxonconcept.org/ses/ogw3l.html#Identification	1	\N	f	298	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
242	http://lod.taxonconcept.org/ses/H83ZL.rdf#Individual	2	\N	f	116	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
243	http://lod.taxonconcept.org/ses/yMju3.rdf#Individual	1	\N	f	299	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
244	http://lod.taxonconcept.org/ses/ELuqP.rdf#Individual	1	\N	f	300	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
245	http://lod.taxonconcept.org/ses/bBKp5.rdf#Individual	1	\N	f	301	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
246	http://lod.taxonconcept.org/ses/CQJBJ.rdf#Individual	4	\N	f	302	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
247	http://lod.taxonconcept.org/ses/57Kew.rdf#Occurrence	1	\N	f	303	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
248	http://lod.taxonconcept.org/ses/5WPW2.html#Image	1	\N	f	304	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
249	http://lod.taxonconcept.org/ses/4krYG.rdf#Individual	1	\N	f	305	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
250	http://lod.taxonconcept.org/ses/tnJr6.html#Identification	1	\N	f	306	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
251	http://lod.taxonconcept.org/ses/kvjFY.rdf#Individual	2	\N	f	307	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
252	http://lod.taxonconcept.org/ses/fFwMo.rdf#Individual	1	\N	f	308	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
253	http://lod.taxonconcept.org/ses/qDzwF.html#Identification	2	\N	f	309	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
254	http://lod.taxonconcept.org/ses/9m9L2.rdf#Occurrence	1	\N	f	310	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
255	http://www.w3.org/ns/sparql-service-description#GraphCollection	1	\N	f	27	GraphCollection	GraphCollection	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
256	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	380	\N	t	1	Property	Property	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32
257	http://www.w3.org/2002/07/owl#Ontology	34	\N	t	7	Ontology	Ontology	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1081712
258	http://www.w3.org/2002/07/owl#OntologyProperty	8	\N	f	7	OntologyProperty	OntologyProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
261	http://rs.tdwg.org/ontology/voc/TaxonName#TaxonName	657609	\N	t	109	TaxonName	TaxonName	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2042976
262	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Graminoid	873	\N	t	69	USDA_Growth_Habit_Graminoid	USDA_Growth_Habit_Graminoid	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	47240
263	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Subshrub	365	\N	t	69	USDA_Growth_Habit_Subshrub	USDA_Growth_Habit_Subshrub	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19159
264	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#Mosquito_Vector_of_Viral_Human_Pathogen	64	\N	t	112	Mosquito_Vector_of_Viral_Human_Pathogen	Mosquito_Vector_of_Viral_Human_Pathogen	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	925
260	http://www.wikidata.org/entity/Q23442	140	\N	t	12	Q23442	[island (Wikidata) (Q23442)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31
265	http://www.w3.org/2004/02/skos/core#ConceptScheme	3	\N	f	4	ConceptScheme	ConceptScheme	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
267	http://lod.taxonconcept.org/ses/pZDDU.html#Image	1	\N	f	312	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
268	http://lod.taxonconcept.org/ses/Zn8um.html#Image	1	\N	f	313	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
269	http://lod.taxonconcept.org/ses/v6n7p.html#Image	1	\N	f	314	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
270	http://lod.taxonconcept.org/ses/HC5Y9.html#Image	1	\N	f	315	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
271	http://lod.taxonconcept.org/ses/moenk.rdf#Occurrence	7	\N	f	316	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
272	http://lod.taxonconcept.org/ses/SKsMC.html#Identification	2	\N	f	317	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
273	http://lod.taxonconcept.org/ses/aF5ti.rdf#Occurrence	10	\N	t	318	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
274	http://lod.taxonconcept.org/ses/VkWnD.rdf#Individual	8	\N	f	319	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
275	http://lod.taxonconcept.org/ses/i7irQ.html#Identification	1	\N	f	320	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
276	http://lod.taxonconcept.org/ses/8mAUx.html#Identification	6	\N	f	321	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
277	http://lod.taxonconcept.org/ses/m8DFR.rdf#Occurrence	1	\N	f	322	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
278	http://lod.taxonconcept.org/ses/G7BFS.rdf#Occurrence	2	\N	f	323	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
279	http://lod.taxonconcept.org/ses/LTQnq.html#Identification	4	\N	f	324	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
280	http://lod.taxonconcept.org/ses/qxOIT.html#Identification	17	\N	t	325	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
281	http://lod.taxonconcept.org/ses/rKPgM.html#Identification	3	\N	f	326	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
282	http://lod.taxonconcept.org/ses/BnOrx.html#Identification	3	\N	f	327	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
283	http://lod.taxonconcept.org/ses/6uwCW.rdf#Occurrence	5	\N	f	328	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
284	http://lod.taxonconcept.org/ses/eIFFU.html#Identification	6	\N	f	329	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
285	http://lod.taxonconcept.org/ses/TT6Fu.rdf#Occurrence	5	\N	f	330	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
286	http://lod.taxonconcept.org/ses/im3e6.html#Identification	2	\N	f	331	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
287	http://lod.taxonconcept.org/ses/4HNHz.rdf#Individual	2	\N	f	332	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
288	http://lod.taxonconcept.org/ses/HaRqa.html#Identification	4	\N	f	333	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
289	http://lod.taxonconcept.org/ses/PCxUF.html#Identification	1	\N	f	334	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
290	http://lod.taxonconcept.org/ses/D5UkV.rdf#Occurrence	1	\N	f	335	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
291	http://lod.taxonconcept.org/ses/b2wr9.html#Identification	1	\N	f	336	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
292	http://lod.taxonconcept.org/ses/YM43a.html#Identification	4	\N	f	337	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
293	http://lod.taxonconcept.org/ses/IwXXi.rdf#Occurrence	5	\N	f	338	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
294	http://lod.taxonconcept.org/ses/wFWTd.rdf#Occurrence	1	\N	f	339	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
295	http://lod.taxonconcept.org/ses/mVFrg.html#Identification	3	\N	f	340	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
296	http://lod.taxonconcept.org/ses/mVFrg.rdf#Individual	3	\N	f	341	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
297	http://lod.taxonconcept.org/ses/9BRBU.html#Identification	2	\N	f	268	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
298	http://lod.taxonconcept.org/ses/wTt3u.html#Identification	6	\N	f	342	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
299	http://lod.taxonconcept.org/ses/2jFf6.rdf#Individual	2	\N	f	343	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
300	http://lod.taxonconcept.org/ses/6pjs3.html#Identification	1	\N	f	344	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
301	http://lod.taxonconcept.org/ses/adEE4.rdf#Individual	10	\N	t	345	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
302	http://lod.taxonconcept.org/ontology/txn.owl#Area	224	\N	t	346	Area	Area	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1440
303	http://lod.taxonconcept.org/ontology/txn.owl#BinomialNameID	117050	\N	t	346	BinomialNameID	BinomialNameID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	117052
304	http://lod.taxonconcept.org/ses/KfOVX.rdf#Occurrence	4	\N	f	164	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
305	http://lod.taxonconcept.org/ses/qcAAy.html#Identification	4	\N	f	347	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
306	http://lod.taxonconcept.org/ses/bFIVX.html#Identification	12	\N	t	348	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
307	http://lod.taxonconcept.org/ses/qcAAy.rdf#Occurrence	4	\N	f	349	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
308	http://lod.taxonconcept.org/ses/OlIuv.rdf#Occurrence	1	\N	f	350	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
309	http://lod.taxonconcept.org/ses/xEeq9.rdf#Occurrence	2	\N	f	351	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
310	http://lod.taxonconcept.org/ses/6KkDY.rdf#Occurrence	1	\N	f	352	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
311	http://lod.taxonconcept.org/ses/XRkR8.html#Identification	4	\N	f	353	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
312	http://lod.taxonconcept.org/ses/VkWnD.html#Identification	8	\N	f	354	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
313	http://lod.taxonconcept.org/ses/t59dV.html#Identification	4	\N	f	355	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
314	http://lod.taxonconcept.org/ses/i7irQ.rdf#Occurrence	1	\N	f	356	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
315	http://lod.taxonconcept.org/ses/qxOIT.rdf#Occurrence	17	\N	t	357	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
316	http://lod.taxonconcept.org/ses/m8DFR.html#Identification	1	\N	f	358	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
317	http://lod.taxonconcept.org/ses/V6TNl.html#Identification	7	\N	f	359	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
318	http://lod.taxonconcept.org/ses/V6TNl.rdf#Occurrence	7	\N	f	360	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
319	http://lod.taxonconcept.org/ses/G7BFS.rdf#Individual	2	\N	f	323	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
320	http://lod.taxonconcept.org/ses/wQT7j.html#Identification	1	\N	f	361	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
321	http://lod.taxonconcept.org/ses/VVYMq.rdf#Individual	4	\N	f	362	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
322	http://lod.taxonconcept.org/ses/VVYMq.rdf#Occurrence	4	\N	f	362	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
323	http://lod.taxonconcept.org/ses/3NTpp.rdf#Occurrence	6	\N	f	363	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
324	http://lod.taxonconcept.org/ses/6uwCW.rdf#Individual	5	\N	f	328	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
325	http://lod.taxonconcept.org/ses/TT6Fu.rdf#Individual	5	\N	f	330	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
326	http://lod.taxonconcept.org/ses/GUXTh.html#Identification	5	\N	f	364	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
327	http://lod.taxonconcept.org/ses/GUXTh.rdf#Occurrence	5	\N	f	365	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
328	http://lod.taxonconcept.org/ses/IwXXi.html#Identification	5	\N	f	366	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
329	http://lod.taxonconcept.org/ses/D5UkV.html#Identification	1	\N	f	367	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
330	http://lod.taxonconcept.org/ses/mv8S9.html#Identification	1	\N	f	368	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
331	http://lod.taxonconcept.org/ses/b2wr9.rdf#Individual	1	\N	f	369	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
332	http://lod.taxonconcept.org/ses/b2wr9.rdf#Occurrence	1	\N	f	369	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
333	http://lod.taxonconcept.org/ses/ZuWgm.html#Identification	3	\N	f	370	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
334	http://lod.taxonconcept.org/ses/ZuWgm.rdf#Occurrence	3	\N	f	371	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
335	http://lod.taxonconcept.org/ses/feXFK.html#Identification	4	\N	f	372	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
336	http://lod.taxonconcept.org/ses/mVFrg.rdf#Occurrence	3	\N	f	341	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
337	http://lod.taxonconcept.org/ses/9BRBU.rdf#Individual	2	\N	f	373	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
338	http://lod.taxonconcept.org/ses/9BRBU.rdf#Occurrence	2	\N	f	373	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
339	http://lod.taxonconcept.org/ses/6pjs3.rdf#Occurrence	1	\N	f	374	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
340	http://lod.taxonconcept.org/ses/VHz69.rdf#Occurrence	2	\N	f	375	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
341	http://lod.taxonconcept.org/ses/dXEgr.rdf#Individual	2	\N	f	376	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
342	http://lod.taxonconcept.org/ses/kMccV.rdf#Individual	1	\N	f	377	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
343	http://lod.taxonconcept.org/ses/wwzn2.html#Identification	5	\N	f	378	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
344	http://lod.taxonconcept.org/ses/a2eUs.rdf#Occurrence	1	\N	f	119	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
345	http://lod.taxonconcept.org/ses/2jFf6.html#Identification	2	\N	f	379	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
346	http://lod.taxonconcept.org/ses/BpPu3.html#Identification	2	\N	f	380	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
347	http://lod.taxonconcept.org/ses/kq5Oa.rdf#Occurrence	2	\N	f	381	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
348	http://lod.taxonconcept.org/ses/4PDlb.rdf#Individual	2	\N	f	171	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
349	http://lod.taxonconcept.org/ses/dxKfG.rdf#Occurrence	3	\N	f	382	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
350	http://lod.taxonconcept.org/ses/raMe2.rdf#Individual	1	\N	f	383	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
351	http://lod.taxonconcept.org/ses/9jbcc.rdf#Individual	5	\N	f	384	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
352	http://lod.taxonconcept.org/ses/aFRYB.rdf#Individual	2	\N	f	385	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
353	http://lod.taxonconcept.org/ses/9OwwE.rdf#Occurrence	13	\N	t	386	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
354	http://lod.taxonconcept.org/ses/Nv6eI.html#Identification	6	\N	f	387	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
355	http://lod.taxonconcept.org/ses/5B5MS.html#Image	1	\N	f	388	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
356	http://lod.taxonconcept.org/ses/ELjI3.html#Image	1	\N	f	389	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
357	http://lod.taxonconcept.org/ses/jAAwG.html#Image	1	\N	f	390	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
358	http://lod.taxonconcept.org/ses/dwOyR.html#Image	1	\N	f	391	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
359	http://lod.taxonconcept.org/ses/jYrH5.rdf#Individual	2	\N	f	392	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
360	http://lod.taxonconcept.org/ses/VkWnD.rdf#Occurrence	8	\N	f	319	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
361	http://lod.taxonconcept.org/ses/z9oqP.rdf#Occurrence	6	\N	f	393	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
362	http://lod.taxonconcept.org/ses/n78LR.rdf#Individual	9	\N	f	134	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
363	http://lod.taxonconcept.org/ses/waK4b.html#Identification	8	\N	f	394	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
364	http://lod.taxonconcept.org/ses/ivggI.rdf#Individual	1	\N	f	395	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
365	http://lod.taxonconcept.org/ses/Axncx.rdf#Occurrence	1	\N	f	396	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
366	http://lod.taxonconcept.org/ses/wTt3u.rdf#Individual	6	\N	f	397	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
367	http://lod.taxonconcept.org/ses/OFtuS.html#Identification	2	\N	f	398	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
368	http://lod.taxonconcept.org/ses/m2FE4.html#Identification	1	\N	f	399	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
369	http://lod.taxonconcept.org/ses/zWOlX.html#Identification	4	\N	f	400	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
370	http://lod.taxonconcept.org/ses/k7HvH.rdf#Individual	3	\N	f	401	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
371	http://lod.taxonconcept.org/ses/k7HvH.rdf#Occurrence	3	\N	f	401	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
372	http://lod.taxonconcept.org/ses/FFnq3.html#Identification	6	\N	f	402	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
373	http://lod.taxonconcept.org/ses/iBxm9.html#Identification	4	\N	f	403	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
374	http://lod.taxonconcept.org/ses/tnVcv.rdf#Individual	5	\N	f	404	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
375	http://lod.taxonconcept.org/ses/tnVcv.rdf#Occurrence	5	\N	f	404	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
376	http://lod.taxonconcept.org/ses/wwzn2.rdf#Individual	5	\N	f	405	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
377	http://lod.taxonconcept.org/ses/kq5Oa.rdf#Individual	2	\N	f	381	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
378	http://lod.taxonconcept.org/ses/9jbcc.html#Identification	5	\N	f	406	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
379	http://lod.taxonconcept.org/ses/ejeV7.html#Identification	2	\N	f	407	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
380	http://lod.taxonconcept.org/ses/Nv6eI.rdf#Individual	6	\N	f	408	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
381	http://lod.taxonconcept.org/ses/QQNTS.rdf#Individual	2	\N	f	409	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
382	http://lod.taxonconcept.org/ses/QQNTS.rdf#Occurrence	2	\N	f	409	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
383	http://lod.taxonconcept.org/ses/WKNeI.html#Image	1	\N	f	410	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
384	http://lod.taxonconcept.org/ses/D4nPw.html#Image	1	\N	f	411	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
385	http://lod.taxonconcept.org/ses/XT77q.html#Image	1	\N	f	412	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
386	http://lod.taxonconcept.org/ses/EaJig.html#Image	1	\N	f	413	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
387	http://lod.taxonconcept.org/ses/UylfK.html#Image	1	\N	f	414	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
388	http://lod.taxonconcept.org/ses/s3USA.rdf#Occurrence	3	\N	f	415	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
389	http://lod.taxonconcept.org/ses/NV5w5.rdf#Occurrence	1	\N	f	416	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
390	http://lod.taxonconcept.org/ses/vaHId.rdf#Occurrence	2	\N	f	417	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
391	http://lod.taxonconcept.org/ses/zXvuQ.rdf#Individual	3	\N	f	418	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
392	http://lod.taxonconcept.org/ses/LRi6u.rdf#Occurrence	1	\N	f	419	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
393	http://lod.taxonconcept.org/ses/2oeGw.rdf#Individual	2	\N	f	420	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
394	http://lod.taxonconcept.org/ses/T7Vjr.rdf#Occurrence	9	\N	f	421	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
395	http://lod.taxonconcept.org/ses/LVxnZ.rdf#Individual	12	\N	t	422	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
396	http://lod.taxonconcept.org/ses/wXh5E.rdf#Individual	2	\N	f	423	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
397	http://lod.taxonconcept.org/ses/rKPgM.rdf#Occurrence	3	\N	f	424	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
398	http://lod.taxonconcept.org/ses/igYj6.rdf#Individual	1	\N	f	425	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
399	http://lod.taxonconcept.org/ses/3d2Xq.rdf#Occurrence	3	\N	f	115	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
400	http://lod.taxonconcept.org/ses/XaS5Y.html#Identification	2	\N	f	426	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
401	http://lod.taxonconcept.org/ses/lichW.rdf#Individual	3	\N	f	427	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
402	http://lod.taxonconcept.org/ses/CpatK.html#Identification	2	\N	f	428	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
403	http://lod.taxonconcept.org/ses/CpatK.rdf#Occurrence	2	\N	f	429	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
404	http://lod.taxonconcept.org/ses/cWJQQ.html#Identification	2	\N	f	430	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
405	http://lod.taxonconcept.org/ses/AOVKM.html#Identification	5	\N	f	431	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
406	http://lod.taxonconcept.org/ses/z3Rtq.html#Identification	1	\N	f	432	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
407	http://lod.taxonconcept.org/ses/NV5w5.rdf#Individual	1	\N	f	416	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
408	http://lod.taxonconcept.org/ses/vaHId.html#Identification	2	\N	f	433	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
409	http://lod.taxonconcept.org/ses/bFIVX.rdf#Individual	12	\N	t	434	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
410	http://lod.taxonconcept.org/ses/QwB2u.html#Identification	2	\N	f	435	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
411	http://lod.taxonconcept.org/ses/LRi6u.rdf#Individual	1	\N	f	419	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
412	http://lod.taxonconcept.org/ses/4pYdM.html#Image	1	\N	f	436	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
413	http://lod.taxonconcept.org/ses/zaeNk.html#Image	1	\N	f	437	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
414	http://lod.taxonconcept.org/ses/GcDa5.html#Image	1	\N	f	438	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
415	http://lod.taxonconcept.org/ses/7x6R9.html#Image	1	\N	f	439	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
416	http://lod.taxonconcept.org/ses/WcRD3.html#Image	1	\N	f	440	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
417	http://lod.taxonconcept.org/ses/57Kew.html#Identification	1	\N	f	441	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
418	http://lod.taxonconcept.org/ses/57Kew.rdf#Individual	1	\N	f	303	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
419	http://lod.taxonconcept.org/ses/rOFB9.rdf#Individual	3	\N	f	442	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
420	http://lod.taxonconcept.org/ses/BS2sL.rdf#Occurrence	1	\N	f	443	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
421	http://lod.taxonconcept.org/ses/IL2k3.rdf#Occurrence	2	\N	f	444	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
422	http://lod.taxonconcept.org/ses/8qL4Z.rdf#Individual	2	\N	f	445	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
423	http://lod.taxonconcept.org/ses/qsSwX.rdf#Occurrence	1	\N	f	446	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
424	http://lod.taxonconcept.org/ses/wVMFV.html#Identification	4	\N	f	447	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
425	http://lod.taxonconcept.org/ses/tTEIq.html#Identification	4	\N	f	280	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
426	http://lod.taxonconcept.org/ses/adEE4.html#Identification	10	\N	t	448	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
427	http://lod.taxonconcept.org/ses/EVSmX.html#Identification	4	\N	f	449	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
428	http://lod.taxonconcept.org/ses/EVSmX.rdf#Occurrence	4	\N	f	450	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
429	http://lod.taxonconcept.org/ses/kMccV.rdf#Occurrence	1	\N	f	377	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
430	http://lod.taxonconcept.org/ses/CFMiq.html#Identification	6	\N	f	451	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
431	http://lod.taxonconcept.org/ses/CFMiq.rdf#Occurrence	6	\N	f	452	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
432	http://lod.taxonconcept.org/ses/sPCCJ.html#Identification	1	\N	f	453	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
756	http://lod.taxonconcept.org/ses/ysPDD.html#Image	1	\N	f	697	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
433	http://lod.taxonconcept.org/ses/RilaW.rdf#Individual	3	\N	f	454	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
434	http://lod.taxonconcept.org/ses/aaZRA.rdf#Individual	2	\N	f	455	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
435	http://lod.taxonconcept.org/ses/WZI5c.html#Identification	2	\N	f	456	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
436	http://lod.taxonconcept.org/ses/T7Vjr.rdf#Individual	9	\N	f	421	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
437	http://lod.taxonconcept.org/ses/Pvfap.rdf#Occurrence	3	\N	f	457	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
438	http://lod.taxonconcept.org/ses/n3v6Z.html#Image	1	\N	f	458	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
439	http://lod.taxonconcept.org/ses/ULKMn.html#Image	1	\N	f	459	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
440	http://lod.taxonconcept.org/ses/SeecQ.html#Identification	6	\N	f	460	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
441	http://lod.taxonconcept.org/ses/4HNHz.rdf#Occurrence	2	\N	f	332	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
442	http://lod.taxonconcept.org/ses/zWOlX.rdf#Individual	4	\N	f	461	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
443	http://lod.taxonconcept.org/ses/VvUQc.rdf#Occurrence	1	\N	f	462	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
444	http://lod.taxonconcept.org/ses/YArSj.rdf#Occurrence	2	\N	f	463	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
445	http://lod.taxonconcept.org/ses/2GDsl.rdf#Individual	1	\N	f	464	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
446	http://lod.taxonconcept.org/ses/926R4.rdf#Individual	1	\N	f	465	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
447	http://lod.taxonconcept.org/ses/O3CW8.html#Identification	2	\N	f	466	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
448	http://lod.taxonconcept.org/ses/O3CW8.rdf#Individual	2	\N	f	467	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
449	http://lod.taxonconcept.org/ses/GpZ38.html#Identification	2	\N	f	468	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
450	http://lod.taxonconcept.org/ses/BGfwX.html#Image	1	\N	f	469	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
451	http://lod.taxonconcept.org/ses/zFh46.html#Image	1	\N	f	470	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
452	http://lod.taxonconcept.org/ses/CRORc.html#Image	1	\N	f	471	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
453	http://lod.taxonconcept.org/ses/G4Qkr.rdf#Individual	4	\N	f	83	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
454	http://lod.taxonconcept.org/ses/OoCD3.html#Identification	2	\N	f	472	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
455	http://lod.taxonconcept.org/ses/PoSYA.rdf#Occurrence	1	\N	f	473	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
456	http://lod.taxonconcept.org/ses/YEqea.html#Identification	3	\N	f	474	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
457	http://lod.taxonconcept.org/ses/KDldJ.rdf#Individual	3	\N	f	475	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
458	http://lod.taxonconcept.org/ses/ebFKJ.html#Image	1	\N	f	476	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
459	http://lod.taxonconcept.org/ses/VJgNC.rdf#Occurrence	1	\N	f	477	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
460	http://lod.taxonconcept.org/ses/tJoHY.rdf#Occurrence	1	\N	f	478	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
461	http://lod.taxonconcept.org/ses/9OwwE.rdf#Individual	13	\N	t	386	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
462	http://lod.taxonconcept.org/ses/qY4v4.html#Image	1	\N	f	479	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
463	http://lod.taxonconcept.org/ses/8joQg.html#Image	1	\N	f	480	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
464	http://lod.taxonconcept.org/ses/pDWjR.html#Identification	1	\N	f	481	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
465	http://lod.taxonconcept.org/ses/xj7z8.html#Identification	1	\N	f	482	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
466	http://lod.taxonconcept.org/ses/ELE4Z.rdf#Individual	2	\N	f	483	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
467	http://lod.taxonconcept.org/ses/vJgoS.rdf#Occurrence	3	\N	f	484	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
468	http://lod.taxonconcept.org/ses/6JCRu.rdf#Individual	3	\N	f	485	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
469	http://lod.taxonconcept.org/ses/qVPNy.html#Identification	1	\N	f	486	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
470	http://purl.org/goodrelations/v1#Offering	3	\N	f	36	Offering	Offering	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
471	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	f	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
472	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	f	487	C_AKE112003-tax	C_AKE112003-tax	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
473	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	4	\N	f	7	inverseFunctionalProperty	inverseFunctionalProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
474	http://rdf.geospecies.org/ont/geospecies#CoL_LSID	52	\N	t	69	CoL_LSID	CoL_LSID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	62
475	http://rdf.geospecies.org/ont/geospecies#Ubio_LSID	1673	\N	t	69	Ubio_LSID	Ubio_LSID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1491
476	http://rdfs.org/ns/void#Dataset	12	\N	t	16	Dataset	Dataset	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1139883
477	http://labs.mondeca.com/vocab/voaf#Vocabulary	1	\N	f	488	Vocabulary	Vocabulary	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
478	http://www.w3.org/2002/07/owl#NamedIndividual	42	\N	t	7	NamedIndividual	NamedIndividual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2089
479	http://lod.taxonconcept.org/ontology/txn.owl#TaxonRank	31	\N	t	346	TaxonRank	TaxonRank	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73
480	http://rs.tdwg.org/ontology/voc/SPMInfoItems#IntroducedOccurrenceStatusTerm	5	\N	f	489	IntroducedOccurrenceStatusTerm	IntroducedOccurrenceStatusTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
481	http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement	43374	\N	t	1	Statement	Statement	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
482	http://lod.taxonconcept.org/ses/oihlQ.rdf#Individual	1	\N	f	490	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
483	http://lod.taxonconcept.org/ses/22wQv.html#Identification	1	\N	f	491	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
484	http://lod.taxonconcept.org/ses/22wQv.rdf#Occurrence	1	\N	f	127	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
485	http://lod.taxonconcept.org/ses/ZLA8X.html#Identification	1	\N	f	492	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
486	http://lod.taxonconcept.org/ses/cXZAR.html#Identification	1	\N	f	493	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
487	http://lod.taxonconcept.org/ses/rVPHV.rdf#Occurrence	1	\N	f	494	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
488	http://lod.taxonconcept.org/ses/F9yxJ.rdf#Occurrence	1	\N	f	495	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
489	http://lod.taxonconcept.org/ses/bBKp5.rdf#Occurrence	1	\N	f	301	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
490	http://lod.taxonconcept.org/ses/MMP3S.html#Image	1	\N	f	496	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
491	http://lod.taxonconcept.org/ses/eqJae.html#Image	1	\N	f	497	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
492	http://lod.taxonconcept.org/ses/oZXgE.html#Image	1	\N	f	498	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
493	http://lod.taxonconcept.org/ses/8dhcM.html#Image	1	\N	f	499	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
494	http://lod.taxonconcept.org/ses/Xud8H.html#Image	1	\N	f	500	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
495	http://lod.taxonconcept.org/ses/oKHtF.html#Image	1	\N	f	501	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
496	http://lod.taxonconcept.org/ses/t7A6t.html#Image	1	\N	f	502	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
497	http://lod.taxonconcept.org/ses/QfP97.html#Image	1	\N	f	503	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
498	http://lod.taxonconcept.org/ses/cD9gH.html#Image	1	\N	f	504	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
499	http://lod.taxonconcept.org/ses/u7nsW.html#Image	1	\N	f	267	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
500	http://lod.taxonconcept.org/ses/Hak3o.html#Image	1	\N	f	505	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
501	http://lod.taxonconcept.org/ses/4HNHz.html#Identification	2	\N	f	506	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
502	http://lod.taxonconcept.org/ses/wbbPl.html#Identification	1	\N	f	507	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
503	http://lod.taxonconcept.org/ses/n5Qdb.html#Image	1	\N	f	508	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
504	http://lod.taxonconcept.org/ses/iWJLJ.rdf#Occurrence	2	\N	f	509	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
505	http://lod.taxonconcept.org/ses/Hak3o.html#Identification	8	\N	f	505	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
506	http://lod.taxonconcept.org/ses/7V2jK.rdf#Individual	2	\N	f	510	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
507	http://lod.taxonconcept.org/ses/2AD3s.rdf#Occurrence	4	\N	f	511	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
508	http://lod.taxonconcept.org/ses/mD3sJ.rdf#Occurrence	1	\N	f	512	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
509	http://lod.taxonconcept.org/ses/3EQhU.rdf#Occurrence	2	\N	f	166	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
510	http://lod.taxonconcept.org/ses/IxueZ.rdf#Individual	3	\N	f	513	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
511	http://lod.taxonconcept.org/ses/xEeq9.html#Identification	2	\N	f	514	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
512	http://lod.taxonconcept.org/ses/2iG3r.rdf#Individual	2	\N	f	515	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
513	http://lod.taxonconcept.org/ses/IL2k3.rdf#Individual	2	\N	f	444	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
514	http://lod.taxonconcept.org/ses/wmVJY.rdf#Individual	2	\N	f	516	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
515	http://lod.taxonconcept.org/ses/XbTtl.html#Identification	4	\N	f	517	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
516	http://lod.taxonconcept.org/ses/EcTQM.html#Identification	1	\N	f	518	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
517	http://lod.taxonconcept.org/ses/2wS2P.html#Identification	1	\N	f	519	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
518	http://lod.taxonconcept.org/ses/IL2k3.html#Identification	2	\N	f	520	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
519	http://lod.taxonconcept.org/ses/y9pGW.rdf#Occurrence	1	\N	f	521	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
520	http://lod.taxonconcept.org/ses/ORKio.rdf#Individual	2	\N	f	522	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
521	http://lod.taxonconcept.org/ses/PPOlM.html#Identification	1	\N	f	523	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
522	http://lod.taxonconcept.org/ses/z2ilb.html#Identification	1	\N	f	524	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
523	http://lod.taxonconcept.org/ses/IB4Hf.html#Identification	1	\N	f	525	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
524	http://lod.taxonconcept.org/ses/VJgNC.html#Identification	1	\N	f	526	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
525	http://lod.taxonconcept.org/ses/j5NVr.html#Identification	6	\N	f	527	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
526	http://lod.taxonconcept.org/ses/4Qydt.html#Image	1	\N	f	528	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
527	http://lod.taxonconcept.org/ses/i4JZY.html#Image	1	\N	f	529	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
528	http://lod.taxonconcept.org/ses/4ghrW.html#Image	1	\N	f	530	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
529	http://lod.taxonconcept.org/ses/5fK3d.html#Image	1	\N	f	531	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
530	http://lod.taxonconcept.org/ses/IK5fE.html#Image	1	\N	f	532	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
531	http://lod.taxonconcept.org/ses/Z3GJ8.html#Image	1	\N	f	533	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
532	http://lod.taxonconcept.org/ses/8mLck.html#Image	1	\N	f	534	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
533	http://lod.taxonconcept.org/ses/AofkF.html#Image	1	\N	f	535	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
534	http://lod.taxonconcept.org/ses/cYWxg.html#Identification	1	\N	f	536	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
535	http://lod.taxonconcept.org/ses/cYWxg.rdf#Occurrence	1	\N	f	537	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
536	http://lod.taxonconcept.org/ses/3d2Xq.html#Identification	3	\N	f	538	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
537	http://lod.taxonconcept.org/ses/TFUb8.rdf#Occurrence	1	\N	f	539	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
538	http://lod.taxonconcept.org/ses/ZoeKQ.rdf#Individual	2	\N	f	139	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
539	http://lod.taxonconcept.org/ses/oihlQ.html#Identification	1	\N	f	540	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
540	http://lod.taxonconcept.org/ses/ZCzx2.html#Identification	3	\N	f	541	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
541	http://lod.taxonconcept.org/ses/ZCzx2.rdf#Occurrence	3	\N	f	542	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
542	http://lod.taxonconcept.org/ses/2tyCC.rdf#Individual	3	\N	f	543	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
543	http://lod.taxonconcept.org/ses/pC9k6.rdf#Individual	1	\N	f	159	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
544	http://lod.taxonconcept.org/ses/DEwaC.rdf#Individual	3	\N	f	544	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
545	http://lod.taxonconcept.org/ses/SeecQ.rdf#Occurrence	6	\N	f	545	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
546	http://lod.taxonconcept.org/ses/IxueZ.html#Identification	3	\N	f	546	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
547	http://lod.taxonconcept.org/ses/wmVJY.html#Identification	2	\N	f	547	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
548	http://lod.taxonconcept.org/ses/RxQZ9.rdf#Individual	1	\N	f	548	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
549	http://lod.taxonconcept.org/ses/RxQZ9.rdf#Occurrence	1	\N	f	548	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
550	http://lod.taxonconcept.org/ses/E4TKF.rdf#Individual	3	\N	f	549	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
551	http://lod.taxonconcept.org/ses/y9pGW.html#Identification	1	\N	f	550	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
552	http://lod.taxonconcept.org/ses/5Vv5k.rdf#Individual	1	\N	f	173	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
553	http://lod.taxonconcept.org/ses/PPOlM.rdf#Occurrence	1	\N	f	174	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
554	http://lod.taxonconcept.org/ses/yqkNV.rdf#Individual	3	\N	f	147	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
555	http://lod.taxonconcept.org/ses/BGfwX.rdf#Individual	2	\N	f	175	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
556	http://lod.taxonconcept.org/ses/NKoA6.rdf#Individual	1	\N	f	551	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
557	http://lod.taxonconcept.org/ses/NKoA6.rdf#Occurrence	1	\N	f	551	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
558	http://lod.taxonconcept.org/ses/j5NVr.rdf#Individual	6	\N	f	552	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
559	http://lod.taxonconcept.org/ses/5xLy9.rdf#Individual	2	\N	f	553	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
560	http://lod.taxonconcept.org/ses/4fx89.html#Image	1	\N	f	554	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
561	http://lod.taxonconcept.org/ses/R9Fn8.html#Image	1	\N	f	555	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
562	http://lod.taxonconcept.org/ses/ORKio.html#Image	1	\N	f	556	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
563	http://lod.taxonconcept.org/ses/tknII.html#Image	1	\N	f	557	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
564	http://lod.taxonconcept.org/ses/rDsSo.html#Image	1	\N	f	558	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
565	http://lod.taxonconcept.org/ses/5Lwrj.html#Image	1	\N	f	559	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
566	http://lod.taxonconcept.org/ses/UPL7f.html#Image	1	\N	f	560	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
567	http://lod.taxonconcept.org/ses/lLjsp.html#Image	1	\N	f	561	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
568	http://lod.taxonconcept.org/ses/ndTgB.rdf#Occurrence	1	\N	f	562	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
569	http://lod.taxonconcept.org/ses/XIHap.rdf#Occurrence	2	\N	f	563	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
570	http://lod.taxonconcept.org/ses/3g4bi.rdf#Individual	2	\N	f	564	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
571	http://lod.taxonconcept.org/ses/MYQMc.rdf#Individual	1	\N	f	565	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
572	http://lod.taxonconcept.org/ses/O2AUE.html#Identification	1	\N	f	566	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
573	http://lod.taxonconcept.org/ses/nM3cP.rdf#Occurrence	1	\N	f	567	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
574	http://lod.taxonconcept.org/ses/RUeOo.rdf#Occurrence	1	\N	f	568	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
575	http://lod.taxonconcept.org/ses/VJgNC.rdf#Individual	1	\N	f	477	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
576	http://lod.taxonconcept.org/ses/XRkR8.rdf#Occurrence	4	\N	f	569	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
577	http://lod.taxonconcept.org/ses/pOpJI.html#Identification	2	\N	f	570	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
578	http://lod.taxonconcept.org/ses/ORKio.rdf#Occurrence	2	\N	f	522	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
579	http://lod.taxonconcept.org/ses/ExW6Q.rdf#Individual	6	\N	f	571	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
580	http://lod.taxonconcept.org/ses/PQLdJ.rdf#Individual	3	\N	f	185	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
581	http://lod.taxonconcept.org/ses/ndTgB.html#Identification	1	\N	f	572	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
582	http://lod.taxonconcept.org/ses/ELE4Z.rdf#Occurrence	2	\N	f	483	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
583	http://lod.taxonconcept.org/ses/O2AUE.rdf#Occurrence	1	\N	f	201	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
584	http://lod.taxonconcept.org/ses/BolZ6.rdf#Individual	1	\N	f	573	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
585	http://lod.taxonconcept.org/ses/nM3cP.rdf#Individual	1	\N	f	567	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
586	http://lod.taxonconcept.org/ses/xLFBZ.rdf#Individual	1	\N	f	574	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
587	http://lod.taxonconcept.org/ses/iRs57.html#Identification	1	\N	f	575	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
588	http://lod.taxonconcept.org/ses/axLDl.rdf#Individual	1	\N	f	576	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
589	http://lod.taxonconcept.org/ses/2p3It.rdf#Individual	1	\N	f	577	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
590	http://lod.taxonconcept.org/ses/EMkPp.rdf#Individual	3	\N	f	236	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
591	http://lod.taxonconcept.org/ses/nzNSq.html#Identification	3	\N	f	578	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
592	http://lod.taxonconcept.org/ses/s3USA.html#Identification	3	\N	f	579	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
593	http://lod.taxonconcept.org/ses/2GDsl.rdf#Occurrence	1	\N	f	464	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
594	http://lod.taxonconcept.org/ses/JGok6.rdf#Individual	2	\N	f	580	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
595	http://lod.taxonconcept.org/ses/UhTds.html#Identification	2	\N	f	581	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
596	http://lod.taxonconcept.org/ses/ieRRx.rdf#Individual	1	\N	f	582	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
597	http://lod.taxonconcept.org/ses/ICmLC.html#Image	1	\N	f	583	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
598	http://lod.taxonconcept.org/ses/wbbPl.html#Image	1	\N	f	507	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
599	http://lod.taxonconcept.org/ses/yATrt.html#Image	1	\N	f	584	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
600	http://lod.taxonconcept.org/ses/3dk3a.html#Image	1	\N	f	585	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
601	http://lod.taxonconcept.org/ses/OPM5j.html#Image	1	\N	f	586	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
602	http://lod.taxonconcept.org/ses/rxX5V.html#Image	1	\N	f	587	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
603	http://lod.taxonconcept.org/ses/Biw4V.html#Image	1	\N	f	588	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
604	http://lod.taxonconcept.org/ses/abqET.html#Image	1	\N	f	589	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
605	http://lod.taxonconcept.org/ses/mVX7P.rdf#Individual	1	\N	f	590	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
606	http://lod.taxonconcept.org/ses/mddSP.rdf#Occurrence	3	\N	f	591	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
607	http://lod.taxonconcept.org/ses/HVNCA.rdf#Occurrence	2	\N	f	592	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
608	http://lod.taxonconcept.org/ses/wxdNW.rdf#Individual	1	\N	f	593	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
609	http://lod.taxonconcept.org/ses/QNRma.rdf#Individual	2	\N	f	594	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
610	http://lod.taxonconcept.org/ses/qcAAy.rdf#Individual	4	\N	f	349	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
611	http://lod.taxonconcept.org/ses/Badsm.rdf#Individual	4	\N	f	595	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
612	http://lod.taxonconcept.org/ses/7V2jK.rdf#Occurrence	2	\N	f	510	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
613	http://lod.taxonconcept.org/ses/47C3Q.rdf#Occurrence	2	\N	f	144	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
614	http://lod.taxonconcept.org/ses/Q7pVA.rdf#Occurrence	2	\N	f	250	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
615	http://lod.taxonconcept.org/ses/DF5Ct.rdf#Occurrence	1	\N	f	596	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
616	http://lod.taxonconcept.org/ses/a4VnR.html#Image	1	\N	f	597	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
617	http://lod.taxonconcept.org/ses/rScby.html#Image	1	\N	f	598	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
618	http://lod.taxonconcept.org/ses/kKOIv.html#Image	1	\N	f	599	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
619	http://lod.taxonconcept.org/ses/HaAJw.rdf#Occurrence	1	\N	f	600	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
620	http://lod.taxonconcept.org/ses/m2FE4.rdf#Occurrence	1	\N	f	601	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
621	http://lod.taxonconcept.org/ses/sG4oi.html#Identification	1	\N	f	602	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
622	http://lod.taxonconcept.org/ses/sG4oi.rdf#Individual	1	\N	f	603	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
623	http://lod.taxonconcept.org/ses/dXEgr.rdf#Occurrence	2	\N	f	376	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
624	http://lod.taxonconcept.org/ses/kYBc4.html#Identification	1	\N	f	604	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
625	http://lod.taxonconcept.org/ses/3g4bi.rdf#Occurrence	2	\N	f	564	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
626	http://lod.taxonconcept.org/ses/X6aiO.rdf#Occurrence	3	\N	f	605	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
627	http://lod.taxonconcept.org/ses/axLDl.html#Identification	1	\N	f	606	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
628	http://lod.taxonconcept.org/ses/axLDl.rdf#Occurrence	1	\N	f	576	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
629	http://lod.taxonconcept.org/ses/EMkPp.html#Identification	3	\N	f	607	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
630	http://lod.taxonconcept.org/ses/fxDuZ.html#Identification	1	\N	f	608	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
631	http://lod.taxonconcept.org/ses/fxDuZ.rdf#Individual	1	\N	f	609	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
632	http://lod.taxonconcept.org/ses/4pZxA.html#Identification	2	\N	f	610	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
633	http://lod.taxonconcept.org/ses/2CXsb.html#Identification	2	\N	f	611	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
634	http://lod.taxonconcept.org/ses/2CXsb.rdf#Occurrence	2	\N	f	612	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
635	http://lod.taxonconcept.org/ses/HefRJ.html#Identification	1	\N	f	613	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
636	http://lod.taxonconcept.org/ses/PJIJ8.html#Identification	3	\N	f	614	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
637	http://lod.taxonconcept.org/ses/PJIJ8.rdf#Occurrence	3	\N	f	615	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
638	http://lod.taxonconcept.org/ses/xLFBZ.rdf#Occurrence	1	\N	f	574	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
639	http://lod.taxonconcept.org/ses/mVX7P.rdf#Occurrence	1	\N	f	590	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
640	http://lod.taxonconcept.org/ses/EkAt6.rdf#Occurrence	2	\N	f	215	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
641	http://lod.taxonconcept.org/ses/3kr7b.rdf#Occurrence	3	\N	f	616	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
642	http://lod.taxonconcept.org/ses/wxdNW.rdf#Occurrence	1	\N	f	593	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
643	http://lod.taxonconcept.org/ses/nlvkB.html#Identification	2	\N	f	617	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
644	http://lod.taxonconcept.org/ses/eVSXV.rdf#Occurrence	2	\N	f	618	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
645	http://lod.taxonconcept.org/ses/65KiB.rdf#Individual	1	\N	f	619	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
646	http://lod.taxonconcept.org/ses/DJEZ3.html#Identification	1	\N	f	620	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
647	http://lod.taxonconcept.org/ses/OJEaQ.html#Identification	1	\N	f	621	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
648	http://lod.taxonconcept.org/ses/ZLA8X.rdf#Occurrence	1	\N	f	622	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
649	http://lod.taxonconcept.org/ses/3LYsH.rdf#Individual	2	\N	f	623	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
650	http://lod.taxonconcept.org/ses/UARq7.rdf#Occurrence	1	\N	f	624	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
651	http://lod.taxonconcept.org/ses/cXZAR.rdf#Individual	1	\N	f	625	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
652	http://lod.taxonconcept.org/ses/F9yxJ.rdf#Individual	1	\N	f	495	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
653	http://lod.taxonconcept.org/ses/4fx89.html#Identification	1	\N	f	554	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
654	http://lod.taxonconcept.org/ses/4fx89.rdf#Occurrence	1	\N	f	626	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
655	http://lod.taxonconcept.org/ses/t59dV.rdf#Individual	4	\N	f	627	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
656	http://lod.taxonconcept.org/ses/EY8Z6.html#Image	1	\N	f	628	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
657	http://lod.taxonconcept.org/ses/SkX3l.html#Image	1	\N	f	629	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
658	http://lod.taxonconcept.org/ses/Uc2wY.html#Image	1	\N	f	630	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
659	http://rs.tdwg.org/ontology/voc/TaxonName#NomenclaturalCodeTerm	5	\N	f	109	NomenclaturalCodeTerm	NomenclaturalCodeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
660	http://rdf.geospecies.org/ont/geospecies#Country	1	\N	f	69	Country	Country	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
661	http://lod.taxonconcept.org/ses/7fYuR.rdf#Individual	1	\N	f	135	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
662	http://lod.taxonconcept.org/ses/CFMiq.rdf#Individual	6	\N	f	452	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
663	http://lod.taxonconcept.org/ses/QZUKm.html#Identification	1	\N	f	631	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
664	http://lod.taxonconcept.org/ses/OlIuv.rdf#Individual	1	\N	f	350	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
665	http://lod.taxonconcept.org/ses/S75nv.html#Identification	1	\N	f	632	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
666	http://lod.taxonconcept.org/ses/E4TKF.rdf#Occurrence	3	\N	f	549	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
667	http://lod.taxonconcept.org/ses/QnVp3.html#Image	1	\N	f	633	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
668	http://lod.taxonconcept.org/ses/6JCRu.rdf#Occurrence	3	\N	f	485	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
669	http://lod.taxonconcept.org/ses/y9pGW.rdf#Individual	1	\N	f	521	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
670	http://lod.taxonconcept.org/ses/VvUQc.rdf#Individual	1	\N	f	462	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
671	http://lod.taxonconcept.org/ses/8joQg.rdf#Occurrence	5	\N	f	634	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
672	http://lod.taxonconcept.org/ses/4pZxA.rdf#Occurrence	2	\N	f	635	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
673	http://lod.taxonconcept.org/ses/sPCCJ.rdf#Occurrence	1	\N	f	636	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
674	http://lod.taxonconcept.org/ses/QXRZr.rdf#Occurrence	1	\N	f	637	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
675	http://lod.taxonconcept.org/ses/VnzyW.rdf#Individual	1	\N	f	638	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
676	http://lod.taxonconcept.org/ses/VhGI9.html#Image	1	\N	f	639	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
677	http://lod.taxonconcept.org/ses/uHoTn.html#Image	1	\N	f	640	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
678	http://lod.taxonconcept.org/ses/lHg5m.html#Image	1	\N	f	641	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
679	http://lod.taxonconcept.org/ses/ICmLC.html#Identification	1	\N	f	583	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
680	http://lod.taxonconcept.org/ses/F8kQB.rdf#Occurrence	1	\N	f	642	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
681	http://lod.taxonconcept.org/ses/kYBc4.rdf#Individual	1	\N	f	643	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
682	http://lod.taxonconcept.org/ses/ArS7W.rdf#Individual	1	\N	f	644	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
683	http://lod.taxonconcept.org/ses/TOKln.rdf#Individual	1	\N	f	645	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
684	http://lod.taxonconcept.org/ses/VHz69.html#Identification	2	\N	f	646	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
685	http://lod.taxonconcept.org/ses/O3CW8.rdf#Occurrence	2	\N	f	467	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
686	http://lod.taxonconcept.org/ses/cdMUI.html#Image	1	\N	f	647	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
687	http://lod.taxonconcept.org/ses/QTYha.rdf#Occurrence	1	\N	f	648	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
688	http://lod.taxonconcept.org/ses/JTV2N.html#Image	1	\N	f	649	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
689	http://lod.taxonconcept.org/ses/7fYuR.html#Identification	1	\N	f	650	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
690	http://www.w3.org/2002/07/owl#DataRange	2	\N	f	7	DataRange	DataRange	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
691	http://taxref.mnhn.fr/lod/status/LegalStatus	220129	\N	t	651	LegalStatus	LegalStatus	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	220129
692	http://lod.taxonconcept.org/ses/6Hyrh.html#Image	1	\N	f	652	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
693	http://lod.taxonconcept.org/ses/XsNMK.html#Image	1	\N	f	653	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
694	http://lod.taxonconcept.org/ses/hXpqy.html#Image	1	\N	f	654	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
695	http://lod.taxonconcept.org/ses/OJayI.rdf#Individual	1	\N	f	655	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
696	http://lod.taxonconcept.org/ses/xmwfI.html#Identification	1	\N	f	656	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
697	http://lod.taxonconcept.org/ses/ELuqP.rdf#Occurrence	1	\N	f	300	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
698	http://lod.taxonconcept.org/ses/V8QpQ.html#Image	1	\N	f	657	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
699	http://lod.taxonconcept.org/ses/QTYha.rdf#Individual	1	\N	f	648	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
700	http://lod.taxonconcept.org/ses/Imlsn.rdf#Occurrence	1	\N	f	658	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
701	http://lod.taxonconcept.org/ses/76MPI.rdf#Individual	1	\N	f	659	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
702	http://lod.taxonconcept.org/ses/t5Fmw.html#Identification	1	\N	f	660	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
703	http://lod.taxonconcept.org/ses/gtvtr.html#Identification	1	\N	f	661	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
704	http://lod.taxonconcept.org/ses/G4Qkr.html#Identification	4	\N	f	662	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
705	http://lod.taxonconcept.org/ses/Msb9D.rdf#Individual	4	\N	f	271	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
706	http://lod.taxonconcept.org/ses/4xejT.html#Image	1	\N	f	663	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
707	http://lod.taxonconcept.org/ses/bLTgP.html#Image	1	\N	f	664	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
708	http://lod.taxonconcept.org/ses/8V5bw.html#Image	1	\N	f	665	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
709	http://lod.taxonconcept.org/ses/aJaIP.html#Image	1	\N	f	666	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
710	http://lod.taxonconcept.org/ses/AjWPP.html#Image	1	\N	f	667	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
711	http://lod.taxonconcept.org/ses/5tLPt.rdf#Individual	3	\N	f	668	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
712	http://lod.taxonconcept.org/ses/iRbjb.html#Image	1	\N	f	669	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
713	http://lod.taxonconcept.org/ses/rKFVI.html#Image	1	\N	f	670	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
714	http://lod.taxonconcept.org/ses/2Oqz2.html#Image	1	\N	f	671	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
715	http://lod.taxonconcept.org/ses/y6jvL.html#Identification	1	\N	f	672	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
716	http://lod.taxonconcept.org/ses/pLLpu.rdf#Occurrence	2	\N	f	673	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
717	http://lod.taxonconcept.org/ses/kJ8FO.rdf#Individual	1	\N	f	674	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
718	http://lod.taxonconcept.org/ses/4Bgim.html#Image	1	\N	f	675	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
719	http://lod.taxonconcept.org/ses/76MPI.html#Identification	1	\N	f	676	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
720	http://lod.taxonconcept.org/ses/t7NOj.html#Identification	1	\N	f	677	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
721	http://lod.taxonconcept.org/ses/RUeOo.html#Identification	1	\N	f	678	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
722	http://lod.taxonconcept.org/ses/6vZHr.html#Image	1	\N	f	679	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
723	http://lod.taxonconcept.org/ses/BCAVn.html#Identification	2	\N	f	680	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
724	http://lod.taxonconcept.org/ses/nBmiL.rdf#Occurrence	2	\N	f	681	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
725	http://lod.taxonconcept.org/ses/gjg3k.html#Identification	2	\N	f	682	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
726	http://lod.taxonconcept.org/ses/mD3sJ.html#Identification	1	\N	f	683	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
727	http://lod.taxonconcept.org/ses/J8XNW.rdf#Occurrence	3	\N	f	684	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
728	http://lod.taxonconcept.org/ses/uDbnq.html#Identification	1	\N	f	685	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
729	http://lod.taxonconcept.org/ses/RUeOo.rdf#Individual	1	\N	f	568	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
730	http://lod.taxonconcept.org/ses/SKsMC.rdf#Individual	2	\N	f	686	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
731	http://lod.taxonconcept.org/ses/w2O2N.html#Identification	1	\N	f	687	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
732	http://lod.taxonconcept.org/ses/LTUGJ.html#Image	1	\N	f	688	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
733	http://lod.taxonconcept.org/ses/NwID5.rdf#Individual	1	\N	f	689	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
734	http://lod.taxonconcept.org/ses/28Dma.html#Image	1	\N	f	690	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
735	http://lod.taxonconcept.org/ses/yKMjt.html#Identification	1	\N	f	691	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
736	http://www.w3.org/2008/05/skos-xl#Label	743558	\N	t	71	Label	Label	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	974688
737	http://schema.org/PropertyValue	2365569	\N	t	9	PropertyValue	PropertyValue	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4726810
738	http://www.w3.org/2000/01/rdf-schema#Class	91	\N	t	2	Class	Class	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4155609
739	http://www.w3.org/ns/sparql-service-description#Service	2	\N	f	27	Service	Service	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
740	http://www.w3.org/2002/07/owl#Class	2075314	\N	t	7	Class	Class	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6328698
741	http://schema.org/CreativeWork	43622	\N	t	9	CreativeWork	CreativeWork	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1207170
863	http://lod.taxonconcept.org/ses/YOlcx.html#Image	1	\N	f	771	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
743	http://www.wikidata.org/entity/Q33837	3	\N	f	12	Q33837	[archipelago (Wikidata) (Q33837)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
745	http://www.wikidata.org/entity/Q719487	8	\N	f	12	Q719487	[overseas collectivity (Wikidata) (Q719487)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
746	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Shrub	483	\N	t	69	USDA_Growth_Habit_Shrub	USDA_Growth_Habit_Shrub	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23055
747	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#Mosquito_Vector_of_Human_Malarial_Pathogen	1	\N	f	112	Mosquito_Vector_of_Human_Malarial_Pathogen	Mosquito_Vector_of_Human_Malarial_Pathogen	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
748	http://lod.taxonconcept.org/ontology/txn.owl#SpeciesConcept	116507	\N	t	346	SpeciesConcept	SpeciesConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	353842
749	http://lod.taxonconcept.org/ontology/usda_plants.owl#Growth_Habit_Forb_Herb	14224	\N	t	692	Growth_Habit_Forb_Herb	Growth_Habit_Forb_Herb	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	149193
750	http://lod.taxonconcept.org/ontology/usda_plants.owl#Growth_Habit_Shrub	4136	\N	t	692	Growth_Habit_Shrub	Growth_Habit_Shrub	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25593
751	http://lod.taxonconcept.org/ontology/usda_plants.owl#Growth_Habit_Tree	2474	\N	t	692	Growth_Habit_Tree	Growth_Habit_Tree	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19496
752	http://lod.taxonconcept.org/ses/tXHPR.html#Image	1	\N	f	693	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
753	http://lod.taxonconcept.org/ses/oJIpA.html#Image	1	\N	f	694	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
754	http://lod.taxonconcept.org/ses/FRbxU.html#Image	1	\N	f	695	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
755	http://lod.taxonconcept.org/ses/8DeCK.html#Image	1	\N	f	696	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
757	http://lod.taxonconcept.org/ontology/txn.owl#Identification	1004	\N	t	346	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2008
758	http://lod.taxonconcept.org/ses/Axncx.html#Identification	1	\N	f	698	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
759	http://lod.taxonconcept.org/ses/8qL4Z.html#Identification	2	\N	f	699	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
760	http://lod.taxonconcept.org/ses/caIZp.rdf#Individual	2	\N	f	700	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
761	http://lod.taxonconcept.org/ses/bFIVX.rdf#Occurrence	12	\N	t	434	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
762	http://lod.taxonconcept.org/ses/tnVcv.html#Identification	5	\N	f	701	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
763	http://lod.taxonconcept.org/ses/eIFFU.rdf#Occurrence	6	\N	f	702	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
764	http://lod.taxonconcept.org/ses/OHpAN.rdf#Individual	2	\N	f	703	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
765	http://lod.taxonconcept.org/ses/LVxnZ.rdf#Occurrence	12	\N	t	422	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
766	http://lod.taxonconcept.org/ses/V6TNl.rdf#Individual	7	\N	f	360	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
767	http://lod.taxonconcept.org/ses/z9oqP.rdf#Individual	6	\N	f	393	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
768	http://lod.taxonconcept.org/ses/Q7pVA.html#Identification	2	\N	f	704	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
769	http://lod.taxonconcept.org/ses/iD4vM.rdf#Individual	17	\N	t	705	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
770	http://lod.taxonconcept.org/ses/yjsfm.rdf#Individual	5	\N	f	706	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
771	http://lod.taxonconcept.org/ses/PdWOo.html#Identification	3	\N	f	707	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
772	http://lod.taxonconcept.org/ses/jSdoN.html#Identification	1	\N	f	708	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
773	http://lod.taxonconcept.org/ses/jQzGP.rdf#Occurrence	4	\N	f	709	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
774	http://lod.taxonconcept.org/ses/LAn6h.html#Identification	3	\N	f	710	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
775	http://lod.taxonconcept.org/ses/GUXTh.rdf#Individual	5	\N	f	365	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
776	http://lod.taxonconcept.org/ses/EQZJW.html#Identification	5	\N	f	711	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
777	http://lod.taxonconcept.org/ses/mv8S9.rdf#Individual	1	\N	f	712	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
778	http://lod.taxonconcept.org/ses/lUyDP.rdf#Occurrence	5	\N	f	137	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
779	http://lod.taxonconcept.org/ses/feXFK.rdf#Individual	4	\N	f	713	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
780	http://lod.taxonconcept.org/ses/6uwCW.html#Identification	5	\N	f	714	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
781	http://lod.taxonconcept.org/ses/2oeGw.rdf#Occurrence	2	\N	f	420	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
782	http://lod.taxonconcept.org/ses/nmWc7.rdf#Occurrence	1	\N	f	715	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
783	http://lod.taxonconcept.org/ses/mCcSp.rdf#Occurrence	2	\N	f	716	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
784	http://lod.taxonconcept.org/ses/obd3m.rdf#Individual	2	\N	f	717	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
785	http://lod.taxonconcept.org/ses/obd3m.rdf#Occurrence	2	\N	f	717	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
786	http://lod.taxonconcept.org/ses/mTlAd.rdf#Occurrence	1	\N	f	718	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
787	http://lod.taxonconcept.org/ses/xEeq9.rdf#Individual	2	\N	f	351	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
788	http://lod.taxonconcept.org/ses/hHgqU.html#Identification	8	\N	f	719	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
789	http://lod.taxonconcept.org/ses/hHgqU.rdf#Occurrence	8	\N	f	118	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
790	http://lod.taxonconcept.org/ses/HOaYm.rdf#Occurrence	5	\N	f	720	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
791	http://lod.taxonconcept.org/ses/6KkDY.html#Identification	1	\N	f	721	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
792	http://lod.taxonconcept.org/ses/XRkR8.rdf#Individual	4	\N	f	569	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
793	http://lod.taxonconcept.org/ses/mdkiV.rdf#Individual	1	\N	f	722	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
794	http://lod.taxonconcept.org/ses/aF5ti.rdf#Individual	10	\N	t	318	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
795	http://lod.taxonconcept.org/ses/i7irQ.rdf#Individual	1	\N	f	356	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
796	http://lod.taxonconcept.org/ses/m8DFR.rdf#Individual	1	\N	f	322	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
797	http://lod.taxonconcept.org/ses/TbdII.rdf#Individual	2	\N	f	723	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
798	http://lod.taxonconcept.org/ses/jSdoN.rdf#Occurrence	1	\N	f	724	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
799	http://lod.taxonconcept.org/ses/jQzGP.html#Identification	4	\N	f	725	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
800	http://lod.taxonconcept.org/ses/N6mpR.html#Identification	2	\N	f	726	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
801	http://lod.taxonconcept.org/ses/HaRqa.rdf#Occurrence	4	\N	f	727	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
802	http://lod.taxonconcept.org/ses/6pjs3.rdf#Individual	1	\N	f	374	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
803	http://lod.taxonconcept.org/ses/8mAUx.rdf#Occurrence	6	\N	f	728	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
804	http://lod.taxonconcept.org/ses/xb4r5.rdf#Individual	2	\N	f	729	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
805	http://lod.taxonconcept.org/ses/qDzwF.rdf#Occurrence	2	\N	f	730	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
806	http://lod.taxonconcept.org/ses/olWBu.rdf#Occurrence	2	\N	f	254	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
807	http://lod.taxonconcept.org/ses/e6dPZ.html#Identification	1	\N	f	731	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
808	http://lod.taxonconcept.org/ses/GoFRJ.html#Identification	6	\N	f	732	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
809	http://lod.taxonconcept.org/ses/PJIJ8.rdf#Individual	3	\N	f	615	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
810	http://lod.taxonconcept.org/ses/kYBc4.rdf#Occurrence	1	\N	f	643	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
811	http://lod.taxonconcept.org/ses/jKbtO.rdf#Occurrence	6	\N	f	733	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
812	http://lod.taxonconcept.org/ses/YArSj.rdf#Individual	2	\N	f	463	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
813	http://lod.taxonconcept.org/ses/hS934.html#Image	1	\N	f	734	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
814	http://lod.taxonconcept.org/ses/tXb2W.html#Image	1	\N	f	735	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
815	http://lod.taxonconcept.org/ses/6EoSC.html#Image	1	\N	f	736	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
816	http://lod.taxonconcept.org/ses/4deYk.html#Image	1	\N	f	737	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
817	http://lod.taxonconcept.org/ses/kJ8FO.html#Image	1	\N	f	738	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
818	http://lod.taxonconcept.org/ses/4qyn7.html#Image	1	\N	f	739	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
819	http://lod.taxonconcept.org/ses/vJgoS.html#Identification	3	\N	f	740	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
820	http://lod.taxonconcept.org/ses/O5CP2.rdf#Individual	2	\N	f	741	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
821	http://lod.taxonconcept.org/ses/iur2i.rdf#Occurrence	3	\N	f	122	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
822	http://lod.taxonconcept.org/ses/ivggI.html#Identification	1	\N	f	742	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
823	http://lod.taxonconcept.org/ses/Tf8vT.rdf#Individual	2	\N	f	743	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
824	http://lod.taxonconcept.org/ses/Axncx.rdf#Individual	1	\N	f	396	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
825	http://lod.taxonconcept.org/ses/caIZp.html#Identification	2	\N	f	744	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
826	http://lod.taxonconcept.org/ses/Badsm.rdf#Occurrence	4	\N	f	595	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
827	http://lod.taxonconcept.org/ses/iXnvQ.html#Identification	2	\N	f	745	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
828	http://lod.taxonconcept.org/ses/iXnvQ.rdf#Occurrence	2	\N	f	746	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
829	http://lod.taxonconcept.org/ses/4pZxA.rdf#Individual	2	\N	f	635	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
830	http://lod.taxonconcept.org/ses/xb4r5.rdf#Occurrence	2	\N	f	729	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
831	http://lod.taxonconcept.org/ses/TSZLI.rdf#Individual	3	\N	f	747	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
832	http://lod.taxonconcept.org/ses/BpPu3.rdf#Occurrence	2	\N	f	748	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
833	http://lod.taxonconcept.org/ses/kq5Oa.html#Identification	2	\N	f	749	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
834	http://lod.taxonconcept.org/ses/fcYdD.html#Identification	2	\N	f	750	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
835	http://lod.taxonconcept.org/ses/fcYdD.rdf#Individual	2	\N	f	751	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
836	http://lod.taxonconcept.org/ses/jKbtO.html#Identification	6	\N	f	752	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
837	http://lod.taxonconcept.org/ses/jKbtO.rdf#Individual	6	\N	f	733	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
838	http://lod.taxonconcept.org/ses/9tBVB.html#Image	1	\N	f	753	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
839	http://lod.taxonconcept.org/ses/LdtMp.html#Image	1	\N	f	754	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
840	http://lod.taxonconcept.org/ses/CsmOq.html#Identification	6	\N	f	755	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
841	http://lod.taxonconcept.org/ses/QwB2u.rdf#Occurrence	2	\N	f	756	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
842	http://lod.taxonconcept.org/ses/AhnLm.rdf#Occurrence	3	\N	f	757	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
843	http://lod.taxonconcept.org/ses/XbTtl.rdf#Individual	4	\N	f	157	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
844	http://lod.taxonconcept.org/ses/mddSP.rdf#Individual	3	\N	f	591	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
845	http://lod.taxonconcept.org/ses/T7Vjr.html#Identification	9	\N	f	758	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
846	http://lod.taxonconcept.org/ses/wXh5E.html#Identification	2	\N	f	759	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
847	http://lod.taxonconcept.org/ses/3LYsH.html#Identification	2	\N	f	760	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
848	http://lod.taxonconcept.org/ses/3LYsH.rdf#Occurrence	2	\N	f	623	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
849	http://lod.taxonconcept.org/ses/nBmiL.html#Identification	2	\N	f	761	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
850	http://lod.taxonconcept.org/ses/nBmiL.rdf#Individual	2	\N	f	681	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
851	http://lod.taxonconcept.org/ses/tFejO.rdf#Individual	3	\N	f	762	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
852	http://lod.taxonconcept.org/ses/MYQMc.rdf#Occurrence	1	\N	f	565	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
853	http://lod.taxonconcept.org/ses/x6gDo.rdf#Individual	1	\N	f	763	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
854	http://lod.taxonconcept.org/ses/Vts5z.html#Identification	1	\N	f	764	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
855	http://lod.taxonconcept.org/ses/AOVKM.rdf#Individual	5	\N	f	765	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
856	http://lod.taxonconcept.org/ses/LRi6u.html#Identification	1	\N	f	766	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
857	http://lod.taxonconcept.org/ses/AhnLm.rdf#Individual	3	\N	f	757	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
858	http://lod.taxonconcept.org/ses/yMju3.html#Identification	1	\N	f	767	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
859	http://lod.taxonconcept.org/ses/CuKKT.rdf#Occurrence	1	\N	f	768	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
860	http://lod.taxonconcept.org/ses/EQZJW.rdf#Occurrence	5	\N	f	256	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
861	http://lod.taxonconcept.org/ses/z9oqP.html#Identification	6	\N	f	769	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
862	http://lod.taxonconcept.org/ses/mCcSp.html#Image	1	\N	f	770	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
864	http://lod.taxonconcept.org/ses/tTEIq.rdf#Individual	4	\N	f	772	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
865	http://lod.taxonconcept.org/ses/iRs57.rdf#Individual	1	\N	f	773	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
866	http://lod.taxonconcept.org/ses/nzNSq.rdf#Individual	3	\N	f	774	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
867	http://lod.taxonconcept.org/ses/nzNSq.rdf#Occurrence	3	\N	f	774	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
868	http://lod.taxonconcept.org/ses/lichW.html#Identification	3	\N	f	775	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
869	http://lod.taxonconcept.org/ses/RilaW.html#Identification	3	\N	f	776	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
870	http://lod.taxonconcept.org/ses/JzyMo.rdf#Individual	2	\N	f	777	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
871	http://lod.taxonconcept.org/ses/65KiB.html#Identification	1	\N	f	778	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
872	http://lod.taxonconcept.org/ses/WZI5c.rdf#Individual	2	\N	f	779	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
873	http://lod.taxonconcept.org/ses/CuKKT.rdf#Individual	1	\N	f	768	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
874	http://lod.taxonconcept.org/ses/4h8D9.html#Image	1	\N	f	780	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
875	http://lod.taxonconcept.org/ses/5o3zj.html#Image	1	\N	f	781	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
876	http://lod.taxonconcept.org/ses/jZipn.html#Image	1	\N	f	782	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
877	http://lod.taxonconcept.org/ses/28FRg.html#Image	1	\N	f	783	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
878	http://lod.taxonconcept.org/ses/IJVMg.rdf#Occurrence	1	\N	f	784	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
879	http://lod.taxonconcept.org/ses/moenk.html#Identification	7	\N	f	785	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
880	http://lod.taxonconcept.org/ses/EfxcN.rdf#Individual	1	\N	f	786	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
881	http://lod.taxonconcept.org/ses/kuDfK.rdf#Individual	2	\N	f	787	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
882	http://lod.taxonconcept.org/ses/OoCD3.rdf#Occurrence	2	\N	f	788	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
883	http://lod.taxonconcept.org/ses/zseFr.rdf#Occurrence	1	\N	f	789	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
884	http://lod.taxonconcept.org/ses/tyYjt.rdf#Occurrence	1	\N	f	274	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
885	http://lod.taxonconcept.org/ses/2GDsl.html#Identification	1	\N	f	790	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
886	http://lod.taxonconcept.org/ses/ZoFhA.rdf#Individual	1	\N	f	791	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
887	http://lod.taxonconcept.org/ses/PdWOo.rdf#Occurrence	3	\N	f	792	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
888	http://lod.taxonconcept.org/ses/GpZ38.rdf#Individual	2	\N	f	793	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
889	http://lod.taxonconcept.org/ses/IxueZ.rdf#Occurrence	3	\N	f	513	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
890	http://lod.taxonconcept.org/ses/LAOy5.html#Image	1	\N	f	794	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
891	http://lod.taxonconcept.org/ses/tTEIq.rdf#Occurrence	4	\N	f	772	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
892	http://lod.taxonconcept.org/ses/MdROc.rdf#Occurrence	1	\N	f	795	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
893	http://lod.taxonconcept.org/ses/2p3It.rdf#Occurrence	1	\N	f	577	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
894	http://lod.taxonconcept.org/ses/umNwC.html#Identification	1	\N	f	796	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
895	http://lod.taxonconcept.org/ses/kIZ8s.rdf#Occurrence	1	\N	f	797	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
896	http://lod.taxonconcept.org/ses/kvthV.html#Image	1	\N	f	798	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
897	http://lod.taxonconcept.org/ses/gIoD2.html#Image	1	\N	f	799	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
898	http://lod.taxonconcept.org/ses/I2qdX.html#Identification	1	\N	f	800	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
899	http://lod.taxonconcept.org/ses/ExW6Q.rdf#Occurrence	6	\N	f	571	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
900	http://lod.taxonconcept.org/ses/2JU3c.html#Identification	1	\N	f	801	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
901	http://lod.taxonconcept.org/ses/FFnq3.rdf#Occurrence	6	\N	f	802	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
902	http://lod.taxonconcept.org/ses/JYUlw.rdf#Individual	2	\N	f	803	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
903	http://lod.taxonconcept.org/ses/ELE4Z.html#Identification	2	\N	f	804	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
904	http://lod.taxonconcept.org/ses/uVdxi.rdf#Individual	1	\N	f	805	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
905	http://lod.taxonconcept.org/ses/qVPNy.rdf#Occurrence	1	\N	f	806	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
906	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	3	\N	f	7	InverseFunctionalProperty	InverseFunctionalProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
907	http://www.w3.org/2002/07/owl#ObjectProperty	891	\N	t	7	ObjectProperty	ObjectProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43043
908	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	f	36	BusinessEntity	BusinessEntity	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
909	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	f	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
910	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	f	487	C_AAB316003-tax	C_AAB316003-tax	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
911	http://purl.org/ontology/wo/Species	309	\N	t	807	Species	Species	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	309
912	http://rdf.geospecies.org/ont/geospecies#County	3	\N	f	69	County	County	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
913	http://rdf.geospecies.org/ont/geospecies#UniprotTaxon	12347	\N	t	69	UniprotTaxon	UniprotTaxon	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13798
914	http://www.w3.org/2002/07/owl#SymmetricProperty	23	\N	t	7	SymmetricProperty	SymmetricProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4049
915	http://www.w3.org/2002/07/owl#FunctionalProperty	12	\N	t	7	FunctionalProperty	FunctionalProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
916	http://purl.org/vocommons/voaf#Vocabulary	1	\N	f	35	Vocabulary	Vocabulary	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
917	http://xmlns.com/foaf/0.1/Organization	9	\N	f	8	Organization	Organization	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
918	http://rs.tdwg.org/ontology/voc/SPMInfoItems#NativeOccurrenceStatusTerm	3	\N	f	489	NativeOccurrenceStatusTerm	NativeOccurrenceStatusTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
919	http://rs.tdwg.org/ontology/voc/SPMInfoItems#PresentOccurrenceStatusTerm	1	\N	f	489	PresentOccurrenceStatusTerm	PresentOccurrenceStatusTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
920	http://www.w3.org/ns/prov#Entity	2	\N	f	26	Entity	Entity	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
921	http://purl.org/biotop/biotop.owl#OrganismInteraction	43374	\N	t	808	OrganismInteraction	OrganismInteraction	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
922	http://www.w3.org/ns/dcat#Dataset	2	\N	f	15	Dataset	Dataset	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
923	http://lod.taxonconcept.org/ses/46cUS.html#Image	1	\N	f	809	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
924	http://lod.taxonconcept.org/ses/uUeFV.html#Image	1	\N	f	810	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
925	http://lod.taxonconcept.org/ses/jW7WG.html#Image	1	\N	f	811	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
926	http://lod.taxonconcept.org/ses/LHPTE.html#Image	1	\N	f	812	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
927	http://lod.taxonconcept.org/ses/MAVwR.html#Image	1	\N	f	813	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
928	http://lod.taxonconcept.org/ses/e6dPZ.rdf#Occurrence	1	\N	f	269	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
929	http://lod.taxonconcept.org/ses/3AuTD.html#Image	1	\N	f	814	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
930	http://lod.taxonconcept.org/ses/HPseh.html#Identification	2	\N	f	815	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
931	http://lod.taxonconcept.org/ses/HkYGc.html#Image	1	\N	f	816	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
932	http://lod.taxonconcept.org/ses/aL9o3.html#Image	1	\N	f	817	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
933	http://lod.taxonconcept.org/ses/7dODo.html#Image	1	\N	f	818	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
934	http://lod.taxonconcept.org/ses/42v62.html#Image	1	\N	f	819	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
935	http://lod.taxonconcept.org/ses/V39Te.rdf#Occurrence	1	\N	f	820	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
936	http://lod.taxonconcept.org/ses/J8XNW.rdf#Individual	3	\N	f	684	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
937	http://lod.taxonconcept.org/ses/gBmxL.rdf#Individual	4	\N	f	821	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
938	http://lod.taxonconcept.org/ses/dxKfG.rdf#Individual	3	\N	f	382	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
939	http://lod.taxonconcept.org/ses/UhTds.rdf#Individual	2	\N	f	822	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
940	http://lod.taxonconcept.org/ses/ASpsq.html#Identification	1	\N	f	823	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
941	http://lod.taxonconcept.org/ses/8CvZO.html#Image	1	\N	f	824	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
942	http://lod.taxonconcept.org/ses/tWMmY.html#Image	1	\N	f	825	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
943	http://lod.taxonconcept.org/ses/KnNJn.html#Image	1	\N	f	826	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
944	http://lod.taxonconcept.org/ses/dmGKK.html#Image	1	\N	f	827	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
945	http://lod.taxonconcept.org/ses/KFRc2.html#Image	1	\N	f	828	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
946	http://lod.taxonconcept.org/ses/t7NOj.rdf#Occurrence	1	\N	f	829	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
947	http://lod.taxonconcept.org/ses/kQmp4.rdf#Occurrence	2	\N	f	830	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
948	http://lod.taxonconcept.org/ses/tXGh9.html#Image	1	\N	f	831	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
949	http://lod.taxonconcept.org/ses/GX4oF.html#Image	1	\N	f	832	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
950	http://lod.taxonconcept.org/ses/vMHzJ.rdf#Individual	2	\N	f	205	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
951	http://lod.taxonconcept.org/ses/tcmif.html#Image	1	\N	f	833	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
952	http://lod.taxonconcept.org/ses/3xUwR.html#Image	1	\N	f	834	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
953	http://lod.taxonconcept.org/ses/Ku8fW.html#Identification	1	\N	f	835	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
954	http://lod.taxonconcept.org/ontology/txn.owl#Sex	5	\N	f	346	Sex	Sex	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
955	http://purl.org/ontology/bibo/Conference	2	\N	f	31	Conference	Conference	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
956	http://rdf.geospecies.org/ont/geospecies#ClassConcept	50	\N	t	69	ClassConcept	ClassConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21213
957	http://rdf.geospecies.org/ont/geospecies#KingdomConcept	8	\N	f	69	KingdomConcept	KingdomConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
958	http://rdf.geospecies.org/ont/geospecies#OrderConcept	217	\N	t	69	OrderConcept	OrderConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23092
959	http://rdf.geospecies.org/ont/geospecies#PhylumConcept	78	\N	t	69	PhylumConcept	PhylumConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21336
960	http://rs.tdwg.org/ontology/voc/Collection#DevelopmentStatusTypeTerm	8	\N	f	103	DevelopmentStatusTypeTerm	DevelopmentStatusTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
961	http://rs.tdwg.org/ontology/voc/CollectionType#CollectionTypeTerm	16	\N	t	836	CollectionTypeTerm	CollectionTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
962	http://rs.tdwg.org/ontology/voc/SPMInfoItems#CyclicityTerm	5	\N	f	489	CyclicityTerm	CyclicityTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
963	http://rs.tdwg.org/ontology/voc/TaxonConcept#TaxonRelationshipTerm	24	\N	t	837	TaxonRelationshipTerm	TaxonRelationshipTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
964	http://rs.tdwg.org/ontology/voc/TaxonName#NomenclaturalTypeTypeTerm	38	\N	t	109	NomenclaturalTypeTypeTerm	NomenclaturalTypeTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
965	http://rdf.geospecies.org/ont/geospecies#State	4	\N	f	69	State	State	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
966	http://lod.taxonconcept.org/ses/mA4st.html#Image	1	\N	f	838	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
967	http://lod.taxonconcept.org/ses/CAUoW.html#Image	1	\N	f	839	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
968	http://lod.taxonconcept.org/ses/2JU3c.rdf#Occurrence	1	\N	f	840	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
969	http://lod.taxonconcept.org/ses/Hak3o.rdf#Individual	8	\N	f	136	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
970	http://lod.taxonconcept.org/ses/Ku8fW.rdf#Occurrence	1	\N	f	841	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
971	http://lod.taxonconcept.org/ses/Sw7iu.html#Identification	1	\N	f	842	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
972	http://lod.taxonconcept.org/ses/htm2P.html#Identification	1	\N	f	843	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
973	http://lod.taxonconcept.org/ses/a2eUs.html#Identification	1	\N	f	844	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
974	http://lod.taxonconcept.org/ses/EVSmX.rdf#Individual	4	\N	f	450	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
975	http://lod.taxonconcept.org/ses/TM9SC.rdf#Individual	1	\N	f	845	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
976	http://lod.taxonconcept.org/ses/ITmfL.html#Identification	6	\N	f	846	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
977	http://lod.taxonconcept.org/ses/2JU3c.rdf#Individual	1	\N	f	840	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
978	http://rdfs.org/ns/void#Linkset	10	\N	t	16	Linkset	Linkset	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10
980	http://xmlns.com/foaf/0.1/Person	4	\N	f	8	Person	Person	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
981	http://purl.org/ontology/bibo/Website	5	\N	f	31	Website	Website	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
982	http://lod.taxonconcept.org/ontology/mos_path.owl#Mosquito_Vectored_Pathogens	3	\N	f	124	Mosquito_Vectored_Pathogens	Mosquito_Vectored_Pathogens	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
983	http://lod.taxonconcept.org/ses/TFUb8.html#Identification	1	\N	f	847	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
984	http://lod.taxonconcept.org/ses/ZoeKQ.html#Identification	2	\N	f	848	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
985	http://lod.taxonconcept.org/ses/nSZro.rdf#Individual	1	\N	f	849	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
986	http://lod.taxonconcept.org/ses/mTlAd.html#Identification	1	\N	f	850	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
987	http://lod.taxonconcept.org/ses/N7mve.rdf#Individual	1	\N	f	279	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
988	http://lod.taxonconcept.org/ses/WYa5u.html#Image	1	\N	f	851	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
989	http://lod.taxonconcept.org/ses/2POKF.html#Image	1	\N	f	852	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
990	http://lod.taxonconcept.org/ses/YjzOP.html#Image	1	\N	f	853	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
991	http://lod.taxonconcept.org/ses/nQB9K.html#Image	1	\N	f	854	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
992	http://lod.taxonconcept.org/ses/sdaPW.html#Image	1	\N	f	855	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
993	http://lod.taxonconcept.org/ses/2T4So.html#Image	1	\N	f	856	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
994	http://lod.taxonconcept.org/ses/Xutcc.html#Image	1	\N	f	857	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
995	http://lod.taxonconcept.org/ses/sEMkb.html#Image	1	\N	f	858	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
996	http://lod.taxonconcept.org/ses/9PTlD.html#Image	1	\N	f	859	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
997	http://lod.taxonconcept.org/ses/I2qdX.rdf#Individual	1	\N	f	860	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
998	http://lod.taxonconcept.org/ses/DhWpJ.rdf#Individual	1	\N	f	861	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
999	http://lod.taxonconcept.org/ses/RilaW.rdf#Occurrence	3	\N	f	454	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1000	http://lod.taxonconcept.org/ses/VzVyR.html#Image	1	\N	f	862	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1001	http://lod.taxonconcept.org/ses/LGyLC.html#Image	1	\N	f	863	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1002	http://lod.taxonconcept.org/ses/2p3It.html#Identification	1	\N	f	864	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1003	http://lod.taxonconcept.org/ses/wbbPl.rdf#Individual	1	\N	f	865	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1004	http://lod.taxonconcept.org/ses/6Yons.html#Image	1	\N	f	866	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1005	http://lod.taxonconcept.org/ses/txX8v.html#Image	1	\N	f	867	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1007	http://schema.org/Dataset	1	\N	f	9	Dataset	Dataset	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1008	http://lod.taxonconcept.org/ses/wbbPl.rdf#Occurrence	1	\N	f	865	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1009	http://lod.taxonconcept.org/ses/XaS5Y.html#Image	1	\N	f	426	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1010	http://lod.taxonconcept.org/ses/aV5eZ.html#Image	1	\N	f	868	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1011	http://lod.taxonconcept.org/ses/TofbR.html#Image	1	\N	f	869	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1012	http://lod.taxonconcept.org/ses/5dTwp.html#Image	1	\N	f	870	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1013	http://lod.taxonconcept.org/ses/hs8WL.html#Image	1	\N	f	871	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1014	http://lod.taxonconcept.org/ses/OvsHQ.html#Identification	1	\N	f	872	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1015	http://lod.taxonconcept.org/ses/UARq7.rdf#Individual	1	\N	f	624	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1016	http://lod.taxonconcept.org/ses/onbrF.rdf#Occurrence	2	\N	f	873	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1017	http://lod.taxonconcept.org/ses/dGOc2.rdf#Individual	2	\N	f	189	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1018	http://lod.taxonconcept.org/ses/eYgn3.rdf#Occurrence	2	\N	f	89	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1019	http://lod.taxonconcept.org/ses/MdROc.html#Identification	1	\N	f	874	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1020	http://lod.taxonconcept.org/ses/UhTds.rdf#Occurrence	2	\N	f	822	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1021	http://lod.taxonconcept.org/ses/4E57e.rdf#Occurrence	1	\N	f	875	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1022	http://lod.taxonconcept.org/ses/74owc.html#Identification	2	\N	f	876	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1023	http://lod.taxonconcept.org/ses/74owc.rdf#Occurrence	2	\N	f	248	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1024	http://lod.taxonconcept.org/ses/yMju3.rdf#Occurrence	1	\N	f	299	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1025	http://lod.taxonconcept.org/ses/JEjhv.html#Image	1	\N	f	877	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1026	http://lod.taxonconcept.org/ses/iRs57.rdf#Occurrence	1	\N	f	773	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1027	http://lod.taxonconcept.org/ses/yCkp9.html#Image	1	\N	f	878	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1028	http://lod.taxonconcept.org/ses/eZs9Q.html#Image	1	\N	f	879	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1029	http://lod.taxonconcept.org/ses/OqNd2.html#Image	1	\N	f	880	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1030	http://lod.taxonconcept.org/ses/ZcfSK.rdf#Occurrence	2	\N	f	881	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1031	http://lod.taxonconcept.org/ses/kbHmd.html#Identification	2	\N	f	882	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1032	http://lod.taxonconcept.org/ses/4E57e.rdf#Individual	1	\N	f	875	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1034	http://lod.taxonconcept.org/ses/I3KlC.html#Image	1	\N	f	884	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1035	http://lod.taxonconcept.org/ses/g67jC.html#Image	1	\N	f	885	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1036	http://lod.taxonconcept.org/ses/87FpO.html#Identification	2	\N	f	886	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1037	http://lod.taxonconcept.org/ses/HPseh.rdf#Occurrence	2	\N	f	887	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1038	http://lod.taxonconcept.org/ses/87FpO.rdf#Individual	2	\N	f	888	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1039	http://xmlns.com/foaf/0.1/Project	2	\N	f	8	Project	Project	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1040	http://lod.taxonconcept.org/ses/ePG6H.html#Image	1	\N	f	889	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1041	http://lod.taxonconcept.org/ses/ieRRx.rdf#Occurrence	1	\N	f	582	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1042	http://lod.taxonconcept.org/ses/eIFFU.rdf#Individual	6	\N	f	702	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1043	http://lod.taxonconcept.org/ses/dFsc7.rdf#Individual	1	\N	f	890	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1044	http://lod.taxonconcept.org/ses/2OVJR.html#Image	1	\N	f	891	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1045	http://lod.taxonconcept.org/ses/2tyCC.rdf#Occurrence	3	\N	f	543	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1046	http://lod.taxonconcept.org/ses/wmVJY.rdf#Occurrence	2	\N	f	516	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1047	http://lod.taxonconcept.org/ses/g3pnZ.rdf#Occurrence	1	\N	f	892	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1048	http://lod.taxonconcept.org/ses/j5NVr.rdf#Occurrence	6	\N	f	552	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1049	http://lod.taxonconcept.org/ses/45G3w.html#Image	1	\N	f	893	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1050	http://lod.taxonconcept.org/ses/4xaly.html#Image	1	\N	f	894	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1051	http://lod.taxonconcept.org/ses/jYrH5.rdf#Occurrence	2	\N	f	392	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1052	http://lod.taxonconcept.org/ses/TM9SC.rdf#Occurrence	1	\N	f	845	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1053	http://lod.taxonconcept.org/ses/ruKFm.html#Image	1	\N	f	895	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1054	http://lod.taxonconcept.org/ses/S75nv.html#Image	1	\N	f	632	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1055	http://lod.taxonconcept.org/ses/a43ba.html#Image	1	\N	f	896	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1056	http://lod.taxonconcept.org/ses/Uc2wY.rdf#Individual	1	\N	f	897	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1057	http://lod.taxonconcept.org/ses/AbVPk.rdf#Occurrence	1	\N	f	898	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1058	http://lod.taxonconcept.org/ses/ldYvw.html#Image	1	\N	f	899	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1059	http://lod.taxonconcept.org/ses/2wS2P.rdf#Individual	1	\N	f	900	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1060	http://lod.taxonconcept.org/ses/pmaz9.html#Image	1	\N	f	901	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1061	http://lod.taxonconcept.org/ses/UkNOJ.html#Image	1	\N	f	902	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1062	http://lod.taxonconcept.org/ses/itdft.html#Identification	1	\N	f	903	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1063	https://data.archives-ouvertes.fr/doctype/Article	2	\N	f	904	Article	Article	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1064	http://lod.taxonconcept.org/ses/NwonD.rdf#Occurrence	4	\N	f	905	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1065	http://lod.taxonconcept.org/ses/kIc5N.rdf#Individual	1	\N	f	906	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1066	http://lod.taxonconcept.org/ses/OJayI.html#Identification	1	\N	f	907	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1067	http://lod.taxonconcept.org/ses/2bDWt.html#Image	1	\N	f	908	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1068	http://lod.taxonconcept.org/ses/wNzoi.rdf#Individual	1	\N	f	909	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1069	http://lod.taxonconcept.org/ses/QmJnc.rdf#Occurrence	1	\N	f	292	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1070	http://lod.taxonconcept.org/ses/dxKfG.html#Identification	3	\N	f	910	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1071	http://lod.taxonconcept.org/ses/wQF9v.html#Image	1	\N	f	911	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1072	http://lod.taxonconcept.org/ses/HfMaF.rdf#Occurrence	1	\N	f	912	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1073	http://lod.taxonconcept.org/ses/OHpAN.html#Identification	2	\N	f	913	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1074	http://lod.taxonconcept.org/ses/m3Ozp.rdf#Occurrence	1	\N	f	914	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1075	http://lod.taxonconcept.org/ses/m3Ozp.rdf#Individual	1	\N	f	914	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1076	http://lod.taxonconcept.org/ses/xj7z8.rdf#Individual	1	\N	f	915	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1077	http://lod.taxonconcept.org/ses/qVPNy.rdf#Individual	1	\N	f	806	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1078	http://lod.taxonconcept.org/ses/zfotr.rdf#Occurrence	2	\N	f	916	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1079	http://lod.taxonconcept.org/ses/8PXcL.html#Image	1	\N	f	917	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1080	http://lod.taxonconcept.org/ses/OpeLP.html#Image	1	\N	f	918	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1081	http://lod.taxonconcept.org/ses/s32nE.html#Identification	1	\N	f	919	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1082	http://lod.taxonconcept.org/ses/UmjVg.html#Image	1	\N	f	920	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1083	http://lod.taxonconcept.org/ses/sBSUL.html#Image	1	\N	f	921	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1084	http://lod.taxonconcept.org/ses/kQmp4.rdf#Individual	2	\N	f	830	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1085	http://lod.taxonconcept.org/ses/ar4Fe.html#Identification	1	\N	f	922	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1086	http://lod.taxonconcept.org/ses/2hSQr.html#Image	1	\N	f	923	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1087	http://lod.taxonconcept.org/ses/AvyKU.html#Identification	1	\N	f	924	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1088	http://lod.taxonconcept.org/ses/HefRJ.rdf#Occurrence	1	\N	f	207	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1089	http://lod.taxonconcept.org/ses/hHckq.html#Image	1	\N	f	925	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1090	http://lod.taxonconcept.org/ses/VEbVW.rdf#Individual	1	\N	f	926	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1091	http://lod.taxonconcept.org/ses/EfxcN.rdf#Occurrence	1	\N	f	786	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1092	http://lod.taxonconcept.org/ses/IB4Hf.rdf#Individual	1	\N	f	927	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1093	http://lod.taxonconcept.org/ses/4ADEI.rdf#Occurrence	1	\N	f	928	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1094	http://lod.taxonconcept.org/ses/pheD9.html#Image	1	\N	f	929	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1095	http://lod.taxonconcept.org/ses/W5fWB.rdf#Occurrence	1	\N	f	258	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1096	http://lod.taxonconcept.org/ses/m3Ozp.html#Identification	1	\N	f	930	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1097	http://lod.taxonconcept.org/ses/gtvtr.rdf#Individual	1	\N	f	931	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1098	http://lod.taxonconcept.org/ses/PoSYA.rdf#Individual	1	\N	f	473	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1099	http://lod.taxonconcept.org/ses/BS2sL.rdf#Individual	1	\N	f	443	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1100	http://lod.taxonconcept.org/ses/nmWc7.html#Identification	1	\N	f	932	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1101	http://lod.taxonconcept.org/ses/VEbVW.rdf#Occurrence	1	\N	f	926	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1102	http://lod.taxonconcept.org/ses/yPMp6.html#Image	1	\N	f	933	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1103	http://lod.taxonconcept.org/ses/raMe2.html#Identification	1	\N	f	934	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1104	http://lod.taxonconcept.org/ses/7DOvU.html#Identification	1	\N	f	935	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1105	http://lod.taxonconcept.org/ses/4xaly.rdf#Occurrence	1	\N	f	936	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1106	http://lod.taxonconcept.org/ses/Y647H.rdf#Occurrence	1	\N	f	937	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1107	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	2229	\N	t	1	List	List	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2229
1108	http://www.w3.org/ns/dcat#Distribution	1	\N	f	15	Distribution	Distribution	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1109	http://www.w3.org/2002/07/owl#Restriction	628	\N	t	7	Restriction	Restriction	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1710
1110	http://www.w3.org/2002/07/owl#DatatypeProperty	326	\N	t	7	DatatypeProperty	DatatypeProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	103
1111	http://www.w3.org/2002/07/owl#AnnotationProperty	191	\N	t	7	AnnotationProperty	AnnotationProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1454194
1112	http://purl.org/ontology/bibo/Document	44626	\N	t	31	Document	Document	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1218934
1113	http://purl.org/ontology/bibo/DocumentPart	534	\N	t	31	DocumentPart	DocumentPart	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	866422
1116	http://taxref.mnhn.fr/lod/loc/MaritimeArea	90	\N	t	938	MaritimeArea	MaritimeArea	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1117	http://www.w3.org/2004/02/skos/core#Concept	690454	\N	t	4	Concept	Concept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6605893
1118	http://rdf.geospecies.org/ont/geospecies#SpeciesConcept	18878	\N	t	69	SpeciesConcept	SpeciesConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	395279
1119	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Forb_Herb	2896	\N	t	69	USDA_Growth_Habit_Forb_Herb	USDA_Growth_Habit_Forb_Herb	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	156761
1120	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Tree	402	\N	t	69	USDA_Growth_Habit_Tree	USDA_Growth_Habit_Tree	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19358
1121	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Vine	192	\N	t	69	USDA_Growth_Habit_Vine	USDA_Growth_Habit_Vine	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8756
1122	http://rdf.geospecies.org/ont/geospecies#USDA_Growth_Habit_Nonvascular	1	\N	f	69	USDA_Growth_Habit_Nonvascular	USDA_Growth_Habit_Nonvascular	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1123	http://lod.taxonconcept.org/ontology/usda_plants.owl#Growth_Habit_Graminoid	3221	\N	t	692	Growth_Habit_Graminoid	Growth_Habit_Graminoid	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	42992
1124	http://lod.taxonconcept.org/ontology/usda_plants.owl#Growth_Habit_Subshrub	2897	\N	t	692	Growth_Habit_Subshrub	Growth_Habit_Subshrub	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20690
1125	http://xmlns.com/foaf/0.1/Image	474	\N	t	8	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	474
1126	http://lod.taxonconcept.org/ses/7iUem.html#Image	1	\N	f	939	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1127	http://lod.taxonconcept.org/ses/z3VMA.html#Image	1	\N	f	940	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1128	http://lod.taxonconcept.org/ses/IJVMg.html#Image	1	\N	f	941	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1129	http://lod.taxonconcept.org/ses/4EHzr.html#Image	1	\N	f	942	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1130	http://lod.taxonconcept.org/ses/l8qzl.html#Image	1	\N	f	943	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1131	http://lod.taxonconcept.org/ses/mh4ez.html#Image	1	\N	f	944	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1132	http://lod.taxonconcept.org/ses/DVkdS.html#Image	1	\N	f	945	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1133	http://lod.taxonconcept.org/ses/dTcrt.html#Image	1	\N	f	946	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1134	http://lod.taxonconcept.org/ses/EwpcL.html#Image	1	\N	f	947	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1135	http://lod.taxonconcept.org/ses/qBelG.html#Image	1	\N	f	948	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1136	http://purl.org/ontology/bibo/Webpage	136412	\N	t	31	Webpage	Webpage	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	194114
1137	http://lod.taxonconcept.org/ses/VzwRC.html#Identification	1	\N	f	949	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1138	http://lod.taxonconcept.org/ses/Tf8vT.rdf#Occurrence	2	\N	f	743	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1139	http://lod.taxonconcept.org/ontology/txn.owl#Occurrence	1004	\N	t	346	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2008
1140	http://lod.taxonconcept.org/ontology/txn.owl#SpeciesIndividual	1004	\N	t	346	SpeciesIndividual	SpeciesIndividual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2008
1141	http://lod.taxonconcept.org/ses/PEOGy.rdf#Individual	4	\N	f	252	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1142	http://lod.taxonconcept.org/ses/tkMBF.rdf#Occurrence	2	\N	f	950	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1143	http://lod.taxonconcept.org/ses/qxOIT.rdf#Individual	17	\N	t	357	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
1144	http://lod.taxonconcept.org/ses/pDWjR.rdf#Individual	1	\N	f	951	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1145	http://lod.taxonconcept.org/ses/TbdII.rdf#Occurrence	2	\N	f	723	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1146	http://lod.taxonconcept.org/ses/wQT7j.rdf#Occurrence	1	\N	f	952	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1147	http://lod.taxonconcept.org/ses/VVYMq.html#Identification	4	\N	f	883	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1148	http://lod.taxonconcept.org/ses/yqkNV.html#Identification	3	\N	f	953	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1149	http://lod.taxonconcept.org/ses/3NTpp.rdf#Individual	6	\N	f	363	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1150	http://lod.taxonconcept.org/ses/YVZ2V.rdf#Occurrence	1	\N	f	954	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1151	http://lod.taxonconcept.org/ses/wVrLq.rdf#Individual	1	\N	f	955	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1152	http://lod.taxonconcept.org/ses/EoIzu.html#Identification	2	\N	f	956	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1153	http://lod.taxonconcept.org/ses/IdV8v.rdf#Occurrence	2	\N	f	957	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1154	http://lod.taxonconcept.org/ses/N6mpR.rdf#Individual	2	\N	f	958	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1155	http://lod.taxonconcept.org/ses/IwXXi.rdf#Individual	5	\N	f	338	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1156	http://lod.taxonconcept.org/ses/VnzyW.rdf#Occurrence	1	\N	f	638	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1157	http://lod.taxonconcept.org/ses/Ku8fW.rdf#Individual	1	\N	f	841	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1158	http://lod.taxonconcept.org/ses/6CpaW.rdf#Occurrence	1	\N	f	959	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1159	http://lod.taxonconcept.org/ses/AbVPk.html#Identification	1	\N	f	960	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1160	http://lod.taxonconcept.org/ses/AvyKU.rdf#Occurrence	1	\N	f	961	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1161	http://lod.taxonconcept.org/ses/8mAUx.rdf#Individual	6	\N	f	728	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1162	http://lod.taxonconcept.org/ses/5tLPt.rdf#Occurrence	3	\N	f	668	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1163	http://lod.taxonconcept.org/ses/ZuWgm.rdf#Individual	3	\N	f	371	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1164	http://lod.taxonconcept.org/ses/zWOlX.rdf#Occurrence	4	\N	f	461	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1165	http://lod.taxonconcept.org/ses/xj7z8.rdf#Occurrence	1	\N	f	915	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1166	http://lod.taxonconcept.org/ses/GoFRJ.rdf#Individual	6	\N	f	962	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1167	http://lod.taxonconcept.org/ses/JYUlw.rdf#Occurrence	2	\N	f	803	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1168	http://lod.taxonconcept.org/ses/j3zOQ.rdf#Individual	7	\N	f	963	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1169	http://lod.taxonconcept.org/ses/wXh5E.rdf#Occurrence	2	\N	f	423	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1170	http://lod.taxonconcept.org/ontology/txn.owl#TaxonNameID	117093	\N	t	346	TaxonNameID	TaxonNameID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	117095
1171	http://lod.taxonconcept.org/ontology/txn.owl#TrinomialNameID	37	\N	t	346	TrinomialNameID	TrinomialNameID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37
1172	http://lod.taxonconcept.org/ses/KfOVX.html#Identification	4	\N	f	964	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1173	http://lod.taxonconcept.org/ses/nmWc7.rdf#Individual	1	\N	f	715	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1174	http://lod.taxonconcept.org/ses/QZUKm.rdf#Individual	1	\N	f	965	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1175	http://lod.taxonconcept.org/ses/OlIuv.html#Identification	1	\N	f	966	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1176	http://lod.taxonconcept.org/ses/n78LR.html#Identification	9	\N	f	967	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1177	http://lod.taxonconcept.org/ses/ORKio.html#Identification	2	\N	f	556	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1178	http://lod.taxonconcept.org/ses/HOaYm.rdf#Individual	5	\N	f	720	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1179	http://lod.taxonconcept.org/ses/mYtsK.html#Identification	1	\N	f	968	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1180	http://lod.taxonconcept.org/ses/mdkiV.html#Identification	1	\N	f	969	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1181	http://lod.taxonconcept.org/ses/aF5ti.html#Identification	10	\N	t	970	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
1182	http://lod.taxonconcept.org/ses/G7BFS.html#Identification	2	\N	f	971	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1183	http://lod.taxonconcept.org/ses/TbdII.html#Identification	2	\N	f	972	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1184	http://lod.taxonconcept.org/ses/wQT7j.rdf#Individual	1	\N	f	952	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1185	http://lod.taxonconcept.org/ses/3NTpp.html#Identification	6	\N	f	973	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1186	http://lod.taxonconcept.org/ses/iD4vM.html#Identification	17	\N	t	974	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
1187	http://lod.taxonconcept.org/ses/iD4vM.rdf#Occurrence	17	\N	t	705	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
1188	http://lod.taxonconcept.org/ses/yjsfm.html#Identification	5	\N	f	975	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1189	http://lod.taxonconcept.org/ses/yjsfm.rdf#Occurrence	5	\N	f	706	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1190	http://lod.taxonconcept.org/ses/EoIzu.rdf#Individual	2	\N	f	976	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1191	http://lod.taxonconcept.org/ses/EoIzu.rdf#Occurrence	2	\N	f	976	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1192	http://lod.taxonconcept.org/ses/BnOrx.rdf#Individual	3	\N	f	977	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1193	http://lod.taxonconcept.org/ses/BnOrx.rdf#Occurrence	3	\N	f	977	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1194	http://lod.taxonconcept.org/ses/jSdoN.rdf#Individual	1	\N	f	724	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1195	http://lod.taxonconcept.org/ses/jQzGP.rdf#Individual	4	\N	f	709	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1196	http://lod.taxonconcept.org/ses/LAn6h.rdf#Individual	3	\N	f	978	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1197	http://lod.taxonconcept.org/ses/LAn6h.rdf#Occurrence	3	\N	f	978	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1198	http://lod.taxonconcept.org/ses/TT6Fu.html#Identification	5	\N	f	979	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1199	http://lod.taxonconcept.org/ses/N6mpR.rdf#Occurrence	2	\N	f	958	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1200	http://lod.taxonconcept.org/ses/HaRqa.rdf#Individual	4	\N	f	727	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1201	http://lod.taxonconcept.org/ses/PCxUF.rdf#Individual	1	\N	f	980	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1202	http://lod.taxonconcept.org/ses/PCxUF.rdf#Occurrence	1	\N	f	980	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1203	http://lod.taxonconcept.org/ses/D5UkV.rdf#Individual	1	\N	f	335	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1204	http://lod.taxonconcept.org/ses/mv8S9.rdf#Occurrence	1	\N	f	712	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1205	http://lod.taxonconcept.org/ses/feXFK.rdf#Occurrence	4	\N	f	713	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1206	http://lod.taxonconcept.org/ses/j3zOQ.html#Identification	7	\N	f	981	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1207	http://lod.taxonconcept.org/ses/j3zOQ.rdf#Occurrence	7	\N	f	963	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1208	http://lod.taxonconcept.org/ses/MdROc.rdf#Individual	1	\N	f	795	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1209	http://lod.taxonconcept.org/ses/aFRYB.rdf#Occurrence	2	\N	f	385	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1210	http://lod.taxonconcept.org/ses/ZZaxg.html#Identification	2	\N	f	982	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1211	http://lod.taxonconcept.org/ses/TSZLI.rdf#Occurrence	3	\N	f	747	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1212	http://lod.taxonconcept.org/ses/AhnLm.html#Identification	3	\N	f	983	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1213	http://lod.taxonconcept.org/ses/9jbcc.rdf#Occurrence	5	\N	f	384	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1214	http://lod.taxonconcept.org/ses/fcYdD.rdf#Occurrence	2	\N	f	751	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1215	http://lod.taxonconcept.org/ses/ejeV7.rdf#Occurrence	2	\N	f	984	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1216	http://lod.taxonconcept.org/ses/Z8Qbe.rdf#Occurrence	1	\N	f	985	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1217	http://lod.taxonconcept.org/ses/waK4b.rdf#Occurrence	8	\N	f	986	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1218	http://lod.taxonconcept.org/ses/JSfMW.rdf#Occurrence	1	\N	f	91	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1219	http://lod.taxonconcept.org/ses/QQNTS.html#Identification	2	\N	f	987	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1220	http://lod.taxonconcept.org/ses/HHEk3.html#Image	1	\N	f	988	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1221	http://lod.taxonconcept.org/ses/BnOrx.html#Image	1	\N	f	327	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1222	http://lod.taxonconcept.org/ses/ejrfw.html#Image	1	\N	f	989	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1223	http://lod.taxonconcept.org/ses/hM7ra.html#Image	1	\N	f	990	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1224	http://lod.taxonconcept.org/ses/s7qFS.html#Image	1	\N	f	991	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1225	http://lod.taxonconcept.org/ses/UENfF.html#Image	1	\N	f	992	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1226	http://lod.taxonconcept.org/ses/jYrH5.html#Identification	2	\N	f	993	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1227	http://lod.taxonconcept.org/ses/vJgoS.rdf#Individual	3	\N	f	484	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1228	http://lod.taxonconcept.org/ses/mCcSp.rdf#Individual	2	\N	f	716	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1229	http://lod.taxonconcept.org/ses/O5CP2.html#Identification	2	\N	f	994	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1230	http://lod.taxonconcept.org/ses/caIZp.rdf#Occurrence	2	\N	f	700	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1231	http://lod.taxonconcept.org/ses/adEE4.rdf#Occurrence	10	\N	t	345	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
1232	http://lod.taxonconcept.org/ses/qsSwX.html#Identification	1	\N	f	995	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1233	http://lod.taxonconcept.org/ses/OFtuS.rdf#Individual	2	\N	f	996	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1234	http://lod.taxonconcept.org/ses/5lVeo.rdf#Occurrence	9	\N	f	161	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1235	http://lod.taxonconcept.org/ses/HfMaF.rdf#Individual	1	\N	f	912	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1236	http://lod.taxonconcept.org/ses/WKNeI.html#Identification	1	\N	f	410	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1237	http://lod.taxonconcept.org/ses/FFnq3.rdf#Individual	6	\N	f	802	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1238	http://lod.taxonconcept.org/ses/iBxm9.rdf#Occurrence	4	\N	f	997	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1239	http://lod.taxonconcept.org/ses/xb4r5.html#Identification	2	\N	f	998	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1240	http://lod.taxonconcept.org/ses/wwzn2.rdf#Occurrence	5	\N	f	405	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1241	http://lod.taxonconcept.org/ses/TSZLI.html#Identification	3	\N	f	999	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1242	http://lod.taxonconcept.org/ses/BpPu3.rdf#Individual	2	\N	f	748	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1243	http://lod.taxonconcept.org/ses/ejeV7.rdf#Individual	2	\N	f	984	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1244	http://lod.taxonconcept.org/ses/YArSj.html#Identification	2	\N	f	1000	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1245	http://lod.taxonconcept.org/ses/Nv6eI.rdf#Occurrence	6	\N	f	408	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1246	http://lod.taxonconcept.org/ses/vRXWD.html#Image	1	\N	f	1001	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1247	http://lod.taxonconcept.org/ses/mVFrg.html#Image	1	\N	f	340	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1248	http://lod.taxonconcept.org/ses/G6Mof.html#Image	1	\N	f	1002	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1249	http://lod.taxonconcept.org/ses/gwKUF.html#Image	1	\N	f	1003	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1250	http://lod.taxonconcept.org/ses/LTQnq.rdf#Occurrence	4	\N	f	218	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1251	http://lod.taxonconcept.org/ses/AOVKM.rdf#Occurrence	5	\N	f	765	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1252	http://lod.taxonconcept.org/ses/926R4.rdf#Occurrence	1	\N	f	465	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1253	http://lod.taxonconcept.org/ses/LVxnZ.html#Identification	12	\N	t	1004	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
1254	http://lod.taxonconcept.org/ses/mddSP.html#Identification	3	\N	f	1005	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1255	http://lod.taxonconcept.org/ses/waK4b.rdf#Individual	8	\N	f	986	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1256	http://lod.taxonconcept.org/ses/y6jvL.rdf#Individual	1	\N	f	1006	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1257	http://lod.taxonconcept.org/ses/6CpaW.html#Identification	1	\N	f	1007	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1258	http://lod.taxonconcept.org/ses/JEjhv.html#Identification	3	\N	f	877	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1259	http://lod.taxonconcept.org/ses/tFejO.rdf#Occurrence	3	\N	f	762	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1260	http://lod.taxonconcept.org/ses/6AiWm.rdf#Occurrence	7	\N	f	1008	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1261	http://lod.taxonconcept.org/ses/MYQMc.html#Identification	1	\N	f	1009	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1262	http://lod.taxonconcept.org/ses/kMccV.html#Identification	1	\N	f	1010	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1263	http://lod.taxonconcept.org/ses/k7HvH.html#Identification	3	\N	f	1011	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1264	http://lod.taxonconcept.org/ses/igYj6.rdf#Occurrence	1	\N	f	425	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1265	http://lod.taxonconcept.org/ses/s3USA.rdf#Individual	3	\N	f	415	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1266	http://lod.taxonconcept.org/ses/XaS5Y.rdf#Occurrence	2	\N	f	213	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1267	http://lod.taxonconcept.org/ses/lichW.rdf#Occurrence	3	\N	f	427	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1268	http://lod.taxonconcept.org/ses/Vts5z.rdf#Individual	1	\N	f	1012	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1269	http://lod.taxonconcept.org/ses/cWJQQ.rdf#Individual	2	\N	f	246	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1270	http://lod.taxonconcept.org/ses/NV5w5.html#Identification	1	\N	f	1013	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1271	http://lod.taxonconcept.org/ses/vaHId.rdf#Individual	2	\N	f	417	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1272	http://lod.taxonconcept.org/ses/DJEZ3.rdf#Individual	1	\N	f	1014	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1273	http://lod.taxonconcept.org/ses/QwB2u.rdf#Individual	2	\N	f	756	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1274	http://lod.taxonconcept.org/ses/2oeGw.html#Identification	2	\N	f	1015	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1275	http://lod.taxonconcept.org/ses/Pvfap.html#Identification	3	\N	f	1016	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1276	http://lod.taxonconcept.org/ses/HPseh.rdf#Individual	2	\N	f	887	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1277	http://lod.taxonconcept.org/ses/74owc.html#Image	1	\N	f	876	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1278	http://lod.taxonconcept.org/ses/5Tpbq.html#Image	1	\N	f	1017	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1279	http://lod.taxonconcept.org/ses/UtAjU.html#Image	1	\N	f	1018	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1280	http://lod.taxonconcept.org/ses/OZDTr.html#Image	1	\N	f	1019	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1281	http://lod.taxonconcept.org/ses/OJEaQ.rdf#Occurrence	1	\N	f	1020	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1282	http://lod.taxonconcept.org/ses/YVZ2V.html#Identification	1	\N	f	1021	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1283	http://lod.taxonconcept.org/ses/YVZ2V.rdf#Individual	1	\N	f	954	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1284	http://lod.taxonconcept.org/ses/wVMFV.rdf#Occurrence	4	\N	f	1022	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1285	http://lod.taxonconcept.org/ses/2AD3s.html#Identification	4	\N	f	1023	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1286	http://lod.taxonconcept.org/ses/mQ9Bq.html#Identification	3	\N	f	1024	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1287	http://lod.taxonconcept.org/ses/mQ9Bq.rdf#Individual	3	\N	f	1025	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1288	http://lod.taxonconcept.org/ses/aaZRA.html#Identification	2	\N	f	1026	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1289	http://lod.taxonconcept.org/ses/QTYha.html#Identification	1	\N	f	1027	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1290	http://lod.taxonconcept.org/ses/CuKKT.html#Identification	1	\N	f	1028	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1291	http://lod.taxonconcept.org/ses/Pvfap.rdf#Individual	3	\N	f	457	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1292	http://lod.taxonconcept.org/ses/JXuUT.html#Image	1	\N	f	1029	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1293	http://lod.taxonconcept.org/ses/PSZQp.html#Image	1	\N	f	1030	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1294	http://lod.taxonconcept.org/ontology/txn.owl#SurrogateNameID	5	\N	f	346	SurrogateNameID	SurrogateNameID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1295	http://lod.taxonconcept.org/ses/IJVMg.html#Identification	1	\N	f	941	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1296	http://lod.taxonconcept.org/ses/76jBF.rdf#Individual	3	\N	f	195	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1297	http://lod.taxonconcept.org/ses/zXvuQ.html#Identification	3	\N	f	1031	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1298	http://lod.taxonconcept.org/ses/moenk.rdf#Individual	7	\N	f	316	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1299	http://lod.taxonconcept.org/ses/GoFRJ.rdf#Occurrence	6	\N	f	962	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1300	http://lod.taxonconcept.org/ses/Z8Qbe.html#Identification	1	\N	f	1032	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1301	http://lod.taxonconcept.org/ses/Z8Qbe.rdf#Individual	1	\N	f	985	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1302	http://lod.taxonconcept.org/ses/CsmOq.rdf#Occurrence	6	\N	f	1033	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1303	http://lod.taxonconcept.org/ses/PdWOo.rdf#Individual	3	\N	f	792	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1304	http://lod.taxonconcept.org/ses/xRff3.html#Image	1	\N	f	1034	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1305	http://lod.taxonconcept.org/ses/HHAha.html#Image	1	\N	f	1035	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1306	http://lod.taxonconcept.org/ses/lPpMB.rdf#Occurrence	1	\N	f	126	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1307	http://lod.taxonconcept.org/ses/8qL4Z.rdf#Occurrence	2	\N	f	445	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1308	http://lod.taxonconcept.org/ses/wTt3u.rdf#Occurrence	6	\N	f	397	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1309	http://lod.taxonconcept.org/ses/vMHzJ.html#Identification	2	\N	f	1036	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1310	http://lod.taxonconcept.org/ses/QEBQB.rdf#Individual	3	\N	f	120	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1311	http://lod.taxonconcept.org/ses/umNwC.rdf#Occurrence	1	\N	f	251	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1312	http://lod.taxonconcept.org/ses/YEqea.rdf#Occurrence	3	\N	f	291	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1313	http://lod.taxonconcept.org/ses/iOj2u.html#Image	1	\N	f	1037	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1314	http://lod.taxonconcept.org/ses/xdmBh.rdf#Occurrence	1	\N	f	1038	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1315	http://lod.taxonconcept.org/ses/dmy7u.html#Image	1	\N	f	1039	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1316	http://lod.taxonconcept.org/ses/KRLYP.html#Image	1	\N	f	1040	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1317	http://lod.taxonconcept.org/ses/hcxFU.html#Image	1	\N	f	1041	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1318	http://lod.taxonconcept.org/ses/uVdxi.html#Identification	1	\N	f	1042	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1319	http://lod.taxonconcept.org/ses/gBmxL.rdf#Occurrence	4	\N	f	821	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1320	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	f	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1321	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	f	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1322	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	f	36	PriceSpecification	PriceSpecification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1323	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	f	36	TypeAndQuantityNode	TypeAndQuantityNode	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1324	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	f	487	C_AKJ315005-tax	C_AKJ315005-tax	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1325	http://purl.org/goodrelations/v1#Manufacturer	1	\N	f	36	Manufacturer	Manufacturer	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1326	http://www.openlinksw.com/ontology/acl#Scope	1	\N	f	1043	Scope	Scope	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1327	http://rdf.geospecies.org/ont/geospecies#DBpediaResource	12876	\N	t	69	DBpediaResource	DBpediaResource	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39225
1328	http://rdf.geospecies.org/ont/geospecies#FreebaseGUID	151	\N	t	69	FreebaseGUID	FreebaseGUID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	175
1329	http://www.geonames.org/ontology#Feature	7	\N	f	72	Feature	Feature	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1330	http://rdf.geospecies.org/ont/geospecies#BugGuidePage	3827	\N	t	69	BugGuidePage	BugGuidePage	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7666
1331	http://rdf.geospecies.org/ont/geospecies#Bio2RDFtaxon	12583	\N	t	69	Bio2RDFtaxon	Bio2RDFtaxon	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25226
1332	http://www.w3.org/2002/07/owl#TransitiveProperty	34	\N	t	7	TransitiveProperty	TransitiveProperty	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	100
1333	http://rs.tdwg.org/ontology/voc/TaxonRank#TaxonRankTerm	61	\N	t	1044	TaxonRankTerm	TaxonRankTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	83
1334	http://rs.tdwg.org/ontology/voc/SPMInfoItems#AbsentOccurrenceStatusTerm	2	\N	f	489	AbsentOccurrenceStatusTerm	AbsentOccurrenceStatusTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1335	http://www.w3.org/ns/dcat#Catalog	1	\N	f	15	Catalog	Catalog	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1336	http://www.w3.org/ns/prov#SoftwareAgent	1	\N	f	26	SoftwareAgent	SoftwareAgent	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1337	http://lod.taxonconcept.org/ses/zseFr.html#Identification	1	\N	f	1045	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1338	http://lod.taxonconcept.org/ses/WKNeI.rdf#Individual	1	\N	f	190	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1339	http://lod.taxonconcept.org/ses/X6aiO.rdf#Individual	3	\N	f	605	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1340	http://lod.taxonconcept.org/ses/ITHVA.html#Identification	1	\N	f	1046	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1341	http://lod.taxonconcept.org/ses/ITHVA.rdf#Individual	1	\N	f	206	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1342	http://lod.taxonconcept.org/ses/JGok6.rdf#Occurrence	2	\N	f	580	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1343	http://lod.taxonconcept.org/ses/t59dV.rdf#Occurrence	4	\N	f	627	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1344	http://lod.taxonconcept.org/ses/z3Rtq.rdf#Occurrence	1	\N	f	1047	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1345	http://lod.taxonconcept.org/ses/zTYd3.rdf#Occurrence	2	\N	f	1048	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1346	http://lod.taxonconcept.org/ses/lPpMB.html#Identification	1	\N	f	1049	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1347	http://lod.taxonconcept.org/ses/dFsc7.rdf#Occurrence	1	\N	f	890	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1348	http://lod.taxonconcept.org/ses/D8qet.rdf#Individual	1	\N	f	1050	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1349	http://lod.taxonconcept.org/ses/J8XNW.html#Identification	3	\N	f	1051	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1350	http://lod.taxonconcept.org/ses/rOFB9.rdf#Occurrence	3	\N	f	442	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1351	http://lod.taxonconcept.org/ses/wFWTd.html#Identification	1	\N	f	1052	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1352	http://lod.taxonconcept.org/ses/rKPgM.rdf#Individual	3	\N	f	424	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1353	http://lod.taxonconcept.org/ses/rVPHV.html#Identification	1	\N	f	1053	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1354	http://lod.taxonconcept.org/ses/nlvkB.rdf#Individual	2	\N	f	1054	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1355	http://lod.taxonconcept.org/ses/nlvkB.rdf#Occurrence	2	\N	f	1054	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1356	http://lod.taxonconcept.org/ses/z9oqP.html#Image	1	\N	f	769	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1357	http://lod.taxonconcept.org/ses/zxUAV.html#Image	1	\N	f	1055	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1358	http://lod.taxonconcept.org/ses/ngNtd.html#Image	1	\N	f	1056	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1359	http://lod.taxonconcept.org/ses/VHz69.rdf#Individual	2	\N	f	375	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1360	http://schema.org/ImageObject	56706	\N	t	9	ImageObject	ImageObject	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56706
1361	http://lod.taxonconcept.org/ses/ZLA8X.rdf#Individual	1	\N	f	622	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1362	http://lod.taxonconcept.org/ses/g3pnZ.rdf#Individual	1	\N	f	892	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1363	http://lod.taxonconcept.org/ses/xowGc.html#Identification	2	\N	f	1057	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1364	http://lod.taxonconcept.org/ses/5xLy9.rdf#Occurrence	2	\N	f	553	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1365	http://lod.taxonconcept.org/ses/HfMaF.html#Identification	1	\N	f	1058	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1366	http://lod.taxonconcept.org/ses/iWJLJ.rdf#Individual	2	\N	f	509	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1367	http://lod.taxonconcept.org/ses/WVwE7.rdf#Individual	1	\N	f	1059	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1368	http://lod.taxonconcept.org/ses/7fvpi.html#Identification	1	\N	f	1060	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1369	http://lod.taxonconcept.org/ses/iXnvQ.rdf#Individual	2	\N	f	746	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1370	http://lod.taxonconcept.org/ses/8joQg.html#Identification	5	\N	f	480	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1371	http://lod.taxonconcept.org/ses/GsOo4.html#Identification	1	\N	f	1061	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1372	http://lod.taxonconcept.org/ses/CaK98.rdf#Occurrence	1	\N	f	1062	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1373	http://lod.taxonconcept.org/ses/uVdxi.rdf#Occurrence	1	\N	f	805	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1374	http://lod.taxonconcept.org/ses/HsAta.rdf#Individual	1	\N	f	88	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1375	http://lod.taxonconcept.org/ses/xEFUR.html#Image	1	\N	f	1063	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1376	http://lod.taxonconcept.org/ses/z2ilb.rdf#Individual	1	\N	f	1064	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1377	http://lod.taxonconcept.org/ses/nnt7Z.rdf#Individual	1	\N	f	1065	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1378	http://lod.taxonconcept.org/ses/4hZMP.html#Image	1	\N	f	1066	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1379	http://lod.taxonconcept.org/ses/kIc5N.html#Identification	1	\N	f	1067	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1380	http://lod.taxonconcept.org/ses/KOlsc.html#Identification	2	\N	f	1068	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1381	http://lod.taxonconcept.org/ses/4QNQ3.html#Image	1	\N	f	1069	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1382	http://lod.taxonconcept.org/ses/9wxsa.html#Image	1	\N	f	1070	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1383	http://lod.taxonconcept.org/ses/QMUrD.html#Image	1	\N	f	1071	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1384	http://lod.taxonconcept.org/ses/GpZ38.rdf#Occurrence	2	\N	f	793	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1385	http://lod.taxonconcept.org/ses/JzyMo.rdf#Occurrence	2	\N	f	777	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1386	http://lod.taxonconcept.org/ses/nSZro.rdf#Occurrence	1	\N	f	849	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1387	http://lod.taxonconcept.org/ses/lrwfL.html#Image	1	\N	f	1072	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1388	http://lod.taxonconcept.org/ses/Y647H.rdf#Individual	1	\N	f	937	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1389	http://lod.taxonconcept.org/ses/JGQFa.html#Image	1	\N	f	1073	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1390	http://lod.taxonconcept.org/ses/yRW2E.rdf#Occurrence	1	\N	f	1074	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1391	http://lod.taxonconcept.org/ses/HefRJ.html#Image	1	\N	f	613	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1392	http://lod.taxonconcept.org/ses/4sOTC.html#Image	1	\N	f	1075	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1393	http://lod.taxonconcept.org/ses/IA3ZS.html#Image	1	\N	f	1076	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1394	http://lod.taxonconcept.org/ses/7s8nk.html#Image	1	\N	f	1077	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1395	http://lod.taxonconcept.org/ses/H83ZL.html#Identification	2	\N	f	1078	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1396	http://lod.taxonconcept.org/ses/tnJr6.html#Image	1	\N	f	306	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1397	http://lod.taxonconcept.org/ses/pOpJI.rdf#Individual	2	\N	f	263	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1398	http://lod.taxonconcept.org/ses/ViTHS.html#Image	1	\N	f	1079	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1399	http://lod.taxonconcept.org/ses/x8xCX.html#Image	1	\N	f	1080	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1400	http://lod.taxonconcept.org/ses/zjxo4.html#Image	1	\N	f	1081	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1401	http://lod.taxonconcept.org/ses/g5ray.html#Image	1	\N	f	1082	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1402	http://lod.taxonconcept.org/ses/fnhuq.rdf#Individual	1	\N	f	1083	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1403	http://lod.taxonconcept.org/ses/JzyMo.html#Identification	2	\N	f	1084	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1404	http://lod.taxonconcept.org/ses/mcWUg.html#Image	1	\N	f	1085	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1405	http://lod.taxonconcept.org/ses/py5ST.rdf#Occurrence	1	\N	f	1086	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1406	http://lod.taxonconcept.org/ses/py5ST.rdf#Individual	1	\N	f	1086	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1407	http://lod.taxonconcept.org/ses/yKMjt.rdf#Occurrence	1	\N	f	1087	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1408	http://lod.taxonconcept.org/ses/W5fWB.html#Identification	1	\N	f	1088	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1409	http://lod.taxonconcept.org/ses/CaK98.html#Identification	1	\N	f	1089	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1410	http://lod.taxonconcept.org/ses/z3dMP.html#Image	1	\N	f	1090	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1411	http://lod.taxonconcept.org/ses/z3Rtq.rdf#Individual	1	\N	f	1047	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1412	http://lod.taxonconcept.org/ses/VzwRC.rdf#Individual	1	\N	f	1091	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1413	http://lod.taxonconcept.org/ses/G9WHN.html#Image	1	\N	f	1092	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1414	http://lod.taxonconcept.org/ses/KtY5J.html#Image	1	\N	f	1093	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1415	http://lod.taxonconcept.org/ses/DF5Ct.rdf#Individual	1	\N	f	596	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1416	http://lod.taxonconcept.org/ses/Zom2X.html#Identification	1	\N	f	1094	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1417	http://lod.taxonconcept.org/ses/r8QqF.rdf#Occurrence	1	\N	f	1095	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1418	http://lod.taxonconcept.org/ses/Lb2PC.html#Image	1	\N	f	1096	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1419	http://lod.taxonconcept.org/ses/J8IR3.html#Image	1	\N	f	1097	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1420	http://lod.taxonconcept.org/ses/34X66.html#Image	1	\N	f	1098	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1421	http://lod.taxonconcept.org/ses/fJamf.rdf#Occurrence	1	\N	f	1099	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1422	http://lod.taxonconcept.org/ses/f9DFp.html#Image	1	\N	f	1100	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1423	http://lod.taxonconcept.org/ses/qhAsM.html#Image	1	\N	f	1101	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1424	http://lod.taxonconcept.org/ses/zTYd3.rdf#Individual	2	\N	f	1048	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1425	http://lod.taxonconcept.org/ses/R5Pkg.html#Identification	1	\N	f	1102	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1426	http://lod.taxonconcept.org/ses/R5Pkg.rdf#Occurrence	1	\N	f	1103	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1427	http://rdf.geospecies.org/ont/geospecies#Continent	1	\N	f	69	Continent	Continent	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1428	http://www.w3.org/2004/02/skos/core#Collection	6	\N	f	4	Collection	Collection	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1429	http://lod.taxonconcept.org/ses/F8kQB.html#Identification	1	\N	f	1104	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1430	http://lod.taxonconcept.org/ses/sG4oi.rdf#Occurrence	1	\N	f	603	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1431	http://lod.taxonconcept.org/ses/BGfwX.html#Identification	2	\N	f	469	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1432	http://lod.taxonconcept.org/ses/HOaYm.html#Identification	5	\N	f	1105	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1433	http://lod.taxonconcept.org/ses/E4TKF.html#Image	1	\N	f	172	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1434	http://lod.taxonconcept.org/ses/5IHYs.html#Image	1	\N	f	1106	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1435	http://lod.taxonconcept.org/ses/VLdbe.html#Image	1	\N	f	1107	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1436	http://lod.taxonconcept.org/ses/TyNjg.rdf#Individual	2	\N	f	1108	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1437	http://lod.taxonconcept.org/ses/6AiWm.html#Identification	7	\N	f	1109	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1438	http://lod.taxonconcept.org/ses/PfzSj.rdf#Individual	5	\N	f	1110	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1439	http://lod.taxonconcept.org/ses/OoCD3.rdf#Individual	2	\N	f	788	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1440	http://lod.taxonconcept.org/ses/Iq3nt.rdf#Individual	1	\N	f	199	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1441	http://lod.taxonconcept.org/ses/nM3cP.html#Identification	1	\N	f	1111	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1442	http://lod.taxonconcept.org/ses/WVwE7.rdf#Occurrence	1	\N	f	1059	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1443	http://lod.taxonconcept.org/ses/qw2tb.rdf#Occurrence	1	\N	f	1112	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1444	http://lod.taxonconcept.org/ses/wbUJ4.html#Image	1	\N	f	1113	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1445	http://lod.taxonconcept.org/ses/NwonD.rdf#Individual	4	\N	f	905	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1446	http://lod.taxonconcept.org/ses/Zom2X.rdf#Occurrence	1	\N	f	1114	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1447	http://lod.taxonconcept.org/ses/4xaly.rdf#Individual	1	\N	f	936	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1448	http://lod.taxonconcept.org/ses/ICmLC.rdf#Occurrence	1	\N	f	1115	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1449	http://lod.taxonconcept.org/ses/dwAmr.rdf#Occurrence	1	\N	f	1116	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1450	http://lod.taxonconcept.org/ses/OHpAN.rdf#Occurrence	2	\N	f	703	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1451	http://lod.taxonconcept.org/ses/ogw3l.rdf#Occurrence	1	\N	f	1117	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1452	http://lod.taxonconcept.org/ses/ZoFhA.rdf#Occurrence	1	\N	f	791	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1453	http://lod.taxonconcept.org/ses/2Dqxa.html#Image	1	\N	f	1118	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1454	http://www.w3.org/2003/11/swrl#AtomList	57	\N	t	70	AtomList	AtomList	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
1455	http://lod.taxonconcept.org/ses/rdubQ.html#Identification	1	\N	f	1119	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1456	http://lod.taxonconcept.org/ses/IdV8v.rdf#Individual	2	\N	f	957	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1457	http://lod.taxonconcept.org/ses/MLtJ8.rdf#Occurrence	1	\N	f	1120	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1458	http://lod.taxonconcept.org/ses/KOlsc.rdf#Occurrence	2	\N	f	1121	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1459	http://lod.taxonconcept.org/ses/ZcfSK.html#Identification	2	\N	f	1122	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1460	http://lod.taxonconcept.org/ses/QmJnc.html#Identification	1	\N	f	1123	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1461	http://lod.taxonconcept.org/ses/kIZ8s.rdf#Individual	1	\N	f	797	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1462	http://lod.taxonconcept.org/ontology/txn.owl#HybridNameID	1	\N	f	346	HybridNameID	HybridNameID	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1463	http://lod.taxonconcept.org/ses/GrQWJ.rdf#Occurrence	1	\N	f	1124	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1464	http://lod.taxonconcept.org/ses/R5Pkg.rdf#Individual	1	\N	f	1103	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1465	http://lod.taxonconcept.org/ses/UflQJ.html#Image	1	\N	f	1125	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1466	http://lod.taxonconcept.org/ses/wFWTd.rdf#Individual	1	\N	f	339	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1467	http://lod.taxonconcept.org/ses/sPCCJ.rdf#Individual	1	\N	f	636	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1468	http://lod.taxonconcept.org/ses/CpatK.rdf#Individual	2	\N	f	429	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1469	http://lod.taxonconcept.org/ses/XNbWx.rdf#Occurrence	1	\N	f	288	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1470	http://lod.taxonconcept.org/ses/htm2P.rdf#Occurrence	1	\N	f	1126	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1471	http://lod.taxonconcept.org/ses/ogw3l.rdf#Individual	1	\N	f	1117	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1472	http://lod.taxonconcept.org/ses/XmjNm.rdf#Occurrence	1	\N	f	249	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1473	http://lod.taxonconcept.org/ses/cYWxg.rdf#Individual	1	\N	f	537	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1474	http://lod.taxonconcept.org/ses/OJEaQ.rdf#Individual	1	\N	f	1020	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1475	http://lod.taxonconcept.org/ses/QqiZf.html#Image	1	\N	f	1127	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1476	http://lod.taxonconcept.org/ses/LnT5s.rdf#Occurrence	1	\N	f	1128	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1477	http://lod.taxonconcept.org/ses/4krYG.rdf#Occurrence	1	\N	f	305	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1478	http://lod.taxonconcept.org/ses/4GtQh.html#Image	1	\N	f	1129	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1479	http://lod.taxonconcept.org/ses/VpJ5l.html#Image	1	\N	f	1130	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1480	http://lod.taxonconcept.org/ses/ECftr.html#Image	1	\N	f	1131	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1481	http://lod.taxonconcept.org/ses/uDbnq.rdf#Individual	1	\N	f	1132	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1482	http://lod.taxonconcept.org/ses/dFsc7.html#Identification	1	\N	f	1133	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1483	http://lod.taxonconcept.org/ses/uDNbR.html#Identification	1	\N	f	1134	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1484	http://lod.taxonconcept.org/ses/JHVvp.html#Image	1	\N	f	1135	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1485	http://lod.taxonconcept.org/ses/Sw7iu.rdf#Occurrence	1	\N	f	1136	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1486	http://lod.taxonconcept.org/ses/kIZ8s.html#Identification	1	\N	f	1137	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1487	http://lod.taxonconcept.org/ses/4ADEI.html#Identification	1	\N	f	1138	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1488	http://lod.taxonconcept.org/ses/76MPI.rdf#Occurrence	1	\N	f	659	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1489	http://lod.taxonconcept.org/ses/9QkhN.html#Image	1	\N	f	1139	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1490	http://lod.taxonconcept.org/ses/6rlfn.html#Image	1	\N	f	1140	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1491	http://lod.taxonconcept.org/ses/bPQnF.html#Image	1	\N	f	1141	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1492	http://lod.taxonconcept.org/ses/Sw7iu.rdf#Individual	1	\N	f	1136	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1493	http://lod.taxonconcept.org/ses/eYgn3.html#Identification	2	\N	f	1142	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1494	http://lod.taxonconcept.org/ses/itdft.rdf#Individual	1	\N	f	285	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1495	http://lod.taxonconcept.org/ses/7DOvU.rdf#Individual	1	\N	f	1143	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1496	http://lod.taxonconcept.org/ses/JnCq2.html#Image	1	\N	f	1144	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1497	http://lod.taxonconcept.org/ses/tDVRu.html#Image	1	\N	f	1145	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1498	http://lod.taxonconcept.org/ses/nnt7Z.rdf#Occurrence	1	\N	f	1065	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1499	http://lod.taxonconcept.org/ses/GyhRg.html#Identification	1	\N	f	1146	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1500	http://lod.taxonconcept.org/ses/4krYG.html#Identification	1	\N	f	1147	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1501	http://lod.taxonconcept.org/ses/q8iz4.html#Identification	1	\N	f	1148	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1502	http://lod.taxonconcept.org/ses/kg5kx.rdf#Occurrence	2	\N	f	1149	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1503	http://lod.taxonconcept.org/ses/3JMAC.html#Image	1	\N	f	1150	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1504	http://lod.taxonconcept.org/ses/nHt7g.rdf#Individual	1	\N	f	92	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1505	http://lod.taxonconcept.org/ses/8fG4V.rdf#Individual	1	\N	f	1151	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1506	http://lod.taxonconcept.org/ses/EG3o2.html#Image	1	\N	f	1152	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1507	http://lod.taxonconcept.org/ses/nOhRO.html#Image	1	\N	f	1153	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1508	http://lod.taxonconcept.org/ses/3kr7b.html#Image	1	\N	f	216	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1509	http://lod.taxonconcept.org/ses/cXZAR.rdf#Occurrence	1	\N	f	625	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1510	http://lod.taxonconcept.org/ses/OhvDL.rdf#Occurrence	1	\N	f	1154	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1511	http://rdf.geospecies.org/ont/geospecies#FamilyConcept	1650	\N	t	69	FamilyConcept	FamilyConcept	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48943
1512	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#Human_Viral_Pathogen_with_Mosquito_Vector	3	\N	f	112	Human_Viral_Pathogen_with_Mosquito_Vector	Human_Viral_Pathogen_with_Mosquito_Vector	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1513	http://lod.taxonconcept.org/ses/pDWjR.rdf#Occurrence	1	\N	f	951	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1514	https://data.archives-ouvertes.fr/doctype/Report	1	\N	f	904	Report	Report	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1515	http://lod.taxonconcept.org/ses/2AD3s.rdf#Individual	4	\N	f	511	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1516	http://lod.taxonconcept.org/ses/ZCzx2.rdf#Individual	3	\N	f	542	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1517	http://lod.taxonconcept.org/ses/xdmBh.html#Identification	1	\N	f	1155	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1518	http://lod.taxonconcept.org/ses/LGFPI.rdf#Individual	3	\N	f	194	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1519	http://lod.taxonconcept.org/ses/SeecQ.rdf#Individual	6	\N	f	545	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1520	http://lod.taxonconcept.org/ses/i7irQ.html#Image	1	\N	f	320	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1521	http://lod.taxonconcept.org/ses/BolZ6.html#Identification	1	\N	f	1156	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1522	http://lod.taxonconcept.org/ses/dwAmr.html#Identification	1	\N	f	1157	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1523	http://lod.taxonconcept.org/ses/BolZ6.rdf#Occurrence	1	\N	f	573	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1524	http://lod.taxonconcept.org/ses/AFYz2.html#Identification	1	\N	f	1158	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1525	http://lod.taxonconcept.org/ses/dGOc2.html#Identification	2	\N	f	1159	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1526	http://lod.taxonconcept.org/ses/AFvhh.html#Image	1	\N	f	1160	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1527	http://lod.taxonconcept.org/ses/dXEgr.html#Identification	2	\N	f	1161	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1528	http://lod.taxonconcept.org/ses/py5ST.html#Identification	1	\N	f	1162	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1529	http://lod.taxonconcept.org/ses/3ZiXC.html#Image	1	\N	f	1163	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1530	http://lod.taxonconcept.org/ses/aE6v7.html#Image	1	\N	f	1164	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1531	http://lod.taxonconcept.org/ses/QNRma.rdf#Occurrence	2	\N	f	594	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1532	http://lod.taxonconcept.org/ses/mD3sJ.rdf#Individual	1	\N	f	512	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1533	http://lod.taxonconcept.org/ses/4fx89.rdf#Individual	1	\N	f	626	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1534	http://lod.taxonconcept.org/ses/fnhuq.html#Identification	1	\N	f	1165	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1535	http://lod.taxonconcept.org/ses/okb3g.html#Image	1	\N	f	1166	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1536	http://www.w3.org/2003/11/swrl#Imp	16	\N	t	70	Imp	Imp	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1537	http://www.w3.org/2002/07/owl#AllDifferent	1	\N	f	7	AllDifferent	AllDifferent	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1538	http://taxref.mnhn.fr/lod/status/RedListStatus	221958	\N	t	651	RedListStatus	RedListStatus	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	221956
1539	http://lod.taxonconcept.org/ses/rrljI.html#Image	1	\N	f	1167	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1540	http://lod.taxonconcept.org/ses/T6N6t.html#Image	1	\N	f	1168	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1541	http://lod.taxonconcept.org/ses/9m9L2.rdf#Individual	1	\N	f	310	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1542	http://lod.taxonconcept.org/ses/vuoEA.html#Image	1	\N	f	1169	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1543	http://lod.taxonconcept.org/ses/ifobC.rdf#Occurrence	1	\N	f	1170	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1544	http://lod.taxonconcept.org/ses/ifobC.html#Identification	1	\N	f	1171	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1545	http://lod.taxonconcept.org/ses/aJize.html#Identification	1	\N	f	1172	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1546	http://lod.taxonconcept.org/ses/kIc5N.rdf#Occurrence	1	\N	f	906	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1547	http://lod.taxonconcept.org/ses/XNbWx.html#Identification	1	\N	f	1173	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1548	http://lod.taxonconcept.org/ses/LnT5s.html#Identification	1	\N	f	1174	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1549	http://lod.taxonconcept.org/ses/zfotr.rdf#Individual	2	\N	f	916	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1550	http://lod.taxonconcept.org/ses/EQZJW.html#Image	1	\N	f	711	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1551	http://lod.taxonconcept.org/ses/GyhRg.rdf#Occurrence	1	\N	f	1175	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1552	http://lod.taxonconcept.org/ses/2jFf6.rdf#Occurrence	2	\N	f	343	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1553	http://lod.taxonconcept.org/ses/N7mve.html#Identification	1	\N	f	1176	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1554	http://lod.taxonconcept.org/ses/Imlsn.rdf#Individual	1	\N	f	658	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1555	http://lod.taxonconcept.org/ses/Uc2wY.rdf#Occurrence	1	\N	f	897	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1556	http://lod.taxonconcept.org/ses/vDLFB.html#Image	1	\N	f	1177	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1557	http://lod.taxonconcept.org/ses/CTZ8z.html#Image	1	\N	f	1178	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1558	http://lod.taxonconcept.org/ses/Moj7i.html#Image	1	\N	f	1179	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1559	https://schema.org/ScholarlyArticle	2	\N	f	1180	ScholarlyArticle	ScholarlyArticle	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1560	http://lod.taxonconcept.org/ses/GsOo4.rdf#Occurrence	1	\N	f	1181	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1561	http://lod.taxonconcept.org/ses/IdV8v.html#Identification	2	\N	f	1182	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1562	http://lod.taxonconcept.org/ses/O5CP2.rdf#Occurrence	2	\N	f	741	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1563	http://lod.taxonconcept.org/ses/zfotr.html#Identification	2	\N	f	1183	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1564	http://lod.taxonconcept.org/ses/q8iz4.rdf#Occurrence	1	\N	f	1184	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1565	http://lod.taxonconcept.org/ses/GFUyO.html#Image	1	\N	f	1185	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1566	http://lod.taxonconcept.org/ses/Yfjoo.html#Image	1	\N	f	1186	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1567	http://lod.taxonconcept.org/ses/WZI5c.rdf#Occurrence	2	\N	f	779	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1568	http://lod.taxonconcept.org/ses/MLtJ8.html#Identification	1	\N	f	1187	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1569	http://lod.taxonconcept.org/ses/IASf2.html#Image	1	\N	f	1188	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1570	http://lod.taxonconcept.org/ses/mTlAd.rdf#Individual	1	\N	f	718	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1571	http://lod.taxonconcept.org/ses/wNzoi.html#Identification	1	\N	f	1189	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1572	http://lod.taxonconcept.org/ses/BYWpt.rdf#Occurrence	1	\N	f	133	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1573	http://lod.taxonconcept.org/ses/D8qet.rdf#Occurrence	1	\N	f	1050	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1574	http://lod.taxonconcept.org/ses/d3gmb.rdf#Occurrence	1	\N	f	1190	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1575	http://lod.taxonconcept.org/ses/XpCne.html#Image	1	\N	f	1191	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1576	http://lod.taxonconcept.org/ses/hazSC.html#Image	1	\N	f	1192	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1577	http://lod.taxonconcept.org/ses/eoA5c.html#Image	1	\N	f	1193	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1578	http://lod.taxonconcept.org/ses/qw2tb.html#Identification	1	\N	f	1194	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1579	http://lod.taxonconcept.org/ses/qw2tb.rdf#Individual	1	\N	f	1112	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1580	http://www.wikidata.org/entity/Q3624078	1	\N	f	12	Q3624078	Q3624078	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1581	http://lod.taxonconcept.org/ses/im3e6.rdf#Occurrence	2	\N	f	192	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1582	http://lod.taxonconcept.org/ses/kQmp4.html#Identification	2	\N	f	177	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1583	http://lod.taxonconcept.org/ses/kvjFY.rdf#Occurrence	2	\N	f	307	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1584	http://lod.taxonconcept.org/ses/JEjhv.rdf#Occurrence	3	\N	f	176	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1585	http://lod.taxonconcept.org/ses/mQ9Bq.rdf#Occurrence	3	\N	f	1025	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1586	http://lod.taxonconcept.org/ses/lUyDP.html#Identification	5	\N	f	1195	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1587	http://lod.taxonconcept.org/ses/8joQg.rdf#Individual	5	\N	f	634	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1588	http://lod.taxonconcept.org/ses/6AiWm.rdf#Individual	7	\N	f	1008	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1589	http://lod.taxonconcept.org/ses/QXRSb.rdf#Individual	3	\N	f	198	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1590	http://lod.taxonconcept.org/ses/TyNjg.html#Identification	2	\N	f	1196	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1591	http://lod.taxonconcept.org/ses/2CXsb.rdf#Individual	2	\N	f	612	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1592	http://lod.taxonconcept.org/ses/4E57e.html#Identification	1	\N	f	98	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1593	http://lod.taxonconcept.org/ses/ICmLC.rdf#Individual	1	\N	f	1115	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1594	http://lod.taxonconcept.org/ses/pLLpu.rdf#Individual	2	\N	f	673	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1595	http://lod.taxonconcept.org/ses/OhvDL.rdf#Individual	1	\N	f	1154	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1596	http://lod.taxonconcept.org/ses/d3gmb.html#Identification	1	\N	f	1197	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1597	http://lod.taxonconcept.org/ses/kJ8FO.html#Identification	1	\N	f	738	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1598	http://lod.taxonconcept.org/ses/fFwMo.rdf#Occurrence	1	\N	f	308	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1599	http://lod.taxonconcept.org/ses/gfGoP.html#Image	1	\N	f	1198	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1600	http://lod.taxonconcept.org/ses/PCvHu.html#Image	1	\N	f	1199	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1601	http://lod.taxonconcept.org/ses/6iNmT.html#Image	1	\N	f	1200	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1602	http://lod.taxonconcept.org/ses/pFZTS.rdf#Occurrence	1	\N	f	1201	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1603	http://lod.taxonconcept.org/ses/ASpsq.rdf#Individual	1	\N	f	1202	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1604	http://lod.taxonconcept.org/ses/JhEQA.rdf#Occurrence	1	\N	f	1203	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1605	http://lod.taxonconcept.org/ses/V39Te.rdf#Individual	1	\N	f	820	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1606	http://lod.taxonconcept.org/ses/GyhRg.rdf#Individual	1	\N	f	1175	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1607	http://lod.taxonconcept.org/ses/bQVv3.html#Image	1	\N	f	1204	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1608	http://lod.taxonconcept.org/ses/qsSwX.rdf#Individual	1	\N	f	446	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1609	http://lod.taxonconcept.org/ses/Vs8zU.html#Image	1	\N	f	1205	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1610	http://lod.taxonconcept.org/ses/t5Fmw.rdf#Individual	1	\N	f	1206	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1611	http://lod.taxonconcept.org/ses/z2ilb.rdf#Occurrence	1	\N	f	1064	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1612	http://lod.taxonconcept.org/ses/GrQWJ.rdf#Individual	1	\N	f	1124	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1613	http://lod.taxonconcept.org/ses/tkMBF.html#Identification	2	\N	f	1207	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1614	http://lod.taxonconcept.org/ses/65KiB.rdf#Occurrence	1	\N	f	619	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1615	http://lod.taxonconcept.org/ses/I8M9f.html#Image	1	\N	f	1208	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1616	http://lod.taxonconcept.org/ses/kbHmd.rdf#Individual	2	\N	f	1209	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1617	http://lod.taxonconcept.org/ses/aJize.rdf#Individual	1	\N	f	1210	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1618	http://lod.taxonconcept.org/ses/nHt7g.html#Identification	1	\N	f	1211	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1619	http://lod.taxonconcept.org/ses/t7NOj.rdf#Individual	1	\N	f	829	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1620	http://lod.taxonconcept.org/ses/rOFB9.html#Identification	3	\N	f	1212	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1621	http://lod.taxonconcept.org/ses/JhEQA.html#Identification	1	\N	f	1213	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1622	http://lod.taxonconcept.org/ses/dGA7c.rdf#Occurrence	2	\N	f	1214	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1623	http://lod.taxonconcept.org/ses/CsmOq.html#Image	1	\N	f	755	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1624	http://lod.taxonconcept.org/ses/jQzGP.html#Image	1	\N	f	725	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1625	http://lod.taxonconcept.org/ses/AvyKU.rdf#Individual	1	\N	f	961	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1626	http://lod.taxonconcept.org/ses/8fG4V.rdf#Occurrence	1	\N	f	1151	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1627	http://lod.taxonconcept.org/ses/uej8m.html#Image	1	\N	f	1215	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1628	http://lod.taxonconcept.org/ses/ivggI.rdf#Occurrence	1	\N	f	395	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1629	http://lod.taxonconcept.org/ses/kuDfK.rdf#Occurrence	2	\N	f	787	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1630	http://lod.taxonconcept.org/ses/yJV4R.html#Identification	1	\N	f	1216	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1631	http://lod.taxonconcept.org/ses/4ADEI.rdf#Individual	1	\N	f	928	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1632	http://lod.taxonconcept.org/ses/N5gCO.html#Image	1	\N	f	1217	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1633	http://lod.taxonconcept.org/ses/ucHx6.rdf#Occurrence	1	\N	f	1218	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1634	http://lod.taxonconcept.org/ses/Lr3Ym.html#Image	1	\N	f	1219	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1635	http://lod.taxonconcept.org/ses/slHlq.html#Image	1	\N	f	1220	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1636	http://lod.taxonconcept.org/ses/Fpnvz.html#Image	1	\N	f	1221	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1637	http://lod.taxonconcept.org/ses/GsOo4.rdf#Individual	1	\N	f	1181	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1638	http://lod.taxonconcept.org/ses/7DOvU.rdf#Occurrence	1	\N	f	1143	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1639	http://lod.taxonconcept.org/ses/AbVPk.rdf#Individual	1	\N	f	898	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1640	http://lod.taxonconcept.org/ses/GTgtA.html#Identification	1	\N	f	1222	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1641	http://lod.taxonconcept.org/ses/XmjNm.html#Identification	1	\N	f	1223	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1642	http://www.w3.org/2001/vcard-rdf/3.0#internet	6	\N	f	1224	internet	internet	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1643	http://lod.taxonconcept.org/ses/Msb9D.html#Identification	4	\N	f	1225	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1644	http://lod.taxonconcept.org/ses/3wxvo.html#Image	1	\N	f	1226	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1645	http://lod.taxonconcept.org/ses/NwID5.rdf#Occurrence	1	\N	f	689	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1646	http://lod.taxonconcept.org/ses/Z2OP8.html#Image	1	\N	f	1227	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1647	http://lod.taxonconcept.org/ses/wVMFV.rdf#Individual	4	\N	f	1022	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1648	http://lod.taxonconcept.org/ses/gBmxL.html#Identification	4	\N	f	1228	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1649	http://lod.taxonconcept.org/ses/obd3m.html#Identification	2	\N	f	1229	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1650	http://lod.taxonconcept.org/ses/gf8Bh.rdf#Occurrence	3	\N	f	163	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1651	http://lod.taxonconcept.org/ses/TFUb8.rdf#Individual	1	\N	f	539	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1652	http://lod.taxonconcept.org/ses/g3pnZ.html#Identification	1	\N	f	1230	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1653	http://lod.taxonconcept.org/ses/u8oxZ.html#Image	1	\N	f	1231	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1654	http://lod.taxonconcept.org/ses/tFejO.html#Identification	3	\N	f	1232	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1655	http://lod.taxonconcept.org/ses/Iq3nt.html#Identification	1	\N	f	1233	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1656	http://lod.taxonconcept.org/ses/ZZaxg.rdf#Occurrence	2	\N	f	100	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1657	http://lod.taxonconcept.org/ses/XH8es.html#Image	1	\N	f	1234	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1658	http://lod.taxonconcept.org/ses/BCAVn.rdf#Individual	2	\N	f	286	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1659	http://lod.taxonconcept.org/ses/QNRma.html#Identification	2	\N	f	1235	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1660	http://lod.taxonconcept.org/ses/wWxWA.html#Image	1	\N	f	1236	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1661	http://lod.taxonconcept.org/ses/LnT5s.rdf#Individual	1	\N	f	1128	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1662	http://lod.taxonconcept.org/ses/rdubQ.rdf#Individual	1	\N	f	1237	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1663	http://lod.taxonconcept.org/ses/cU7WZ.html#Image	1	\N	f	1238	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1664	http://lod.taxonconcept.org/ses/ZdhkS.html#Image	1	\N	f	1239	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1665	http://lod.taxonconcept.org/ses/I2qdX.rdf#Occurrence	1	\N	f	860	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1666	http://lod.taxonconcept.org/ses/zseFr.rdf#Individual	1	\N	f	789	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1667	http://lod.taxonconcept.org/ses/u6Qgt.html#Identification	2	\N	f	1240	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1668	http://lod.taxonconcept.org/ses/3yF9U.html#Image	1	\N	f	1241	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1669	http://lod.taxonconcept.org/ses/fFwMo.html#Identification	1	\N	f	1242	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1670	http://lod.taxonconcept.org/ses/SKsMC.rdf#Occurrence	2	\N	f	686	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1671	http://lod.taxonconcept.org/ses/Zom2X.rdf#Individual	1	\N	f	1114	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1672	http://lod.taxonconcept.org/ses/PDdyp.html#Image	1	\N	f	1243	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1673	http://lod.taxonconcept.org/ses/NoloC.html#Image	1	\N	f	1244	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1674	http://lod.taxonconcept.org/ses/uh3Rg.html#Image	1	\N	f	1245	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1675	http://lod.taxonconcept.org/ses/Zwn8A.html#Identification	1	\N	f	1246	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1676	http://lod.taxonconcept.org/ses/fnhuq.rdf#Occurrence	1	\N	f	1083	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1677	http://lod.taxonconcept.org/ses/k9fVp.html#Image	1	\N	f	1247	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1678	http://lod.taxonconcept.org/ses/ZZSyS.html#Image	1	\N	f	1248	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1679	http://lod.taxonconcept.org/ses/BAhHL.html#Image	1	\N	f	1249	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1680	http://lod.taxonconcept.org/ses/6ATjy.html#Image	1	\N	f	1250	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1681	http://lod.taxonconcept.org/ses/MLtJ8.rdf#Individual	1	\N	f	1120	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1682	http://lod.taxonconcept.org/ses/iRnzQ.html#Identification	1	\N	f	1251	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1683	http://lod.taxonconcept.org/ses/IHHNf.html#Identification	2	\N	f	1252	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1684	http://lod.taxonconcept.org/ses/WmSCQ.html#Image	1	\N	f	1253	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1685	http://lod.taxonconcept.org/ses/uDNbR.rdf#Individual	1	\N	f	186	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1686	http://lod.taxonconcept.org/ses/yRW2E.rdf#Individual	1	\N	f	1074	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1687	http://lod.taxonconcept.org/ses/yJV4R.rdf#Individual	1	\N	f	1254	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1688	http://lod.taxonconcept.org/ses/Zpm2A.html#Image	1	\N	f	1255	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1689	http://lod.taxonconcept.org/ses/yKMjt.rdf#Individual	1	\N	f	1087	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1690	http://lod.taxonconcept.org/ses/ECftr.html#Identification	1	\N	f	1131	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1691	http://lod.taxonconcept.org/ses/gtvtr.rdf#Occurrence	1	\N	f	931	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1692	http://lod.taxonconcept.org/ses/DJEZ3.rdf#Occurrence	1	\N	f	1014	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1693	http://lod.taxonconcept.org/ses/mCcSp.html#Identification	2	\N	f	770	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1695	http://lod.taxonconcept.org/ses/eVSXV.html#Identification	2	\N	f	1257	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1696	http://lod.taxonconcept.org/ses/PRL6j.html#Image	1	\N	f	1258	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1697	http://lod.taxonconcept.org/ses/OhvDL.html#Identification	1	\N	f	1259	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1698	http://lod.taxonconcept.org/ses/vS5nY.rdf#Occurrence	1	\N	f	1260	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1699	http://lod.taxonconcept.org/ses/Y647H.html#Identification	1	\N	f	1261	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1700	http://lod.taxonconcept.org/ses/mYtsK.rdf#Individual	1	\N	f	261	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1701	http://lod.taxonconcept.org/ses/cCZRL.rdf#Occurrence	1	\N	f	1262	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1702	http://lod.taxonconcept.org/ses/Vo6he.html#Image	1	\N	f	1263	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1703	http://lod.taxonconcept.org/ses/EcTQM.rdf#Individual	1	\N	f	169	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1704	http://lod.taxonconcept.org/ses/m2FE4.rdf#Individual	1	\N	f	601	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1705	http://lod.taxonconcept.org/ses/AFYz2.rdf#Occurrence	1	\N	f	203	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1706	http://lod.taxonconcept.org/ses/AoOQH.rdf#Individual	4	\N	f	237	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1707	http://lod.taxonconcept.org/ses/fxDuZ.rdf#Occurrence	1	\N	f	609	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1708	http://lod.taxonconcept.org/ses/Bk9pZ.html#Identification	3	\N	f	1264	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1709	http://lod.taxonconcept.org/ses/3kr7b.rdf#Individual	3	\N	f	616	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1710	http://lod.taxonconcept.org/ses/F8kQB.rdf#Individual	1	\N	f	642	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1711	http://lod.taxonconcept.org/ses/HVNCA.rdf#Individual	2	\N	f	592	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1712	http://lod.taxonconcept.org/ses/u2iJX.html#Image	1	\N	f	1265	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1713	http://lod.taxonconcept.org/ses/dwAmr.html#Image	1	\N	f	1157	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1714	http://lod.taxonconcept.org/ses/yEPuc.html#Image	1	\N	f	1266	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1715	http://lod.taxonconcept.org/ses/pFZTS.rdf#Individual	1	\N	f	1201	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1716	http://lod.taxonconcept.org/ses/ASpsq.rdf#Occurrence	1	\N	f	1202	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1717	http://lod.taxonconcept.org/ses/RKFoG.html#Image	1	\N	f	1267	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1718	http://lod.taxonconcept.org/ses/r8QqF.html#Identification	1	\N	f	1268	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1719	http://lod.taxonconcept.org/ses/tJoHY.html#Identification	1	\N	f	1269	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1720	http://lod.taxonconcept.org/ses/OFtuS.rdf#Occurrence	2	\N	f	996	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1721	http://lod.taxonconcept.org/ses/fJamf.html#Identification	1	\N	f	1270	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1722	http://lod.taxonconcept.org/ses/MI82U.rdf#Occurrence	1	\N	f	1271	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1723	http://lod.taxonconcept.org/ses/htm2P.rdf#Individual	1	\N	f	1126	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1724	http://lod.taxonconcept.org/ses/4xaly.html#Identification	1	\N	f	894	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1725	http://lod.taxonconcept.org/ses/gjg3k.rdf#Occurrence	2	\N	f	196	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1726	http://lod.taxonconcept.org/ses/F9yxJ.html#Identification	1	\N	f	1272	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1727	http://lod.taxonconcept.org/ses/VmbzI.rdf#Individual	1	\N	f	260	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1728	http://lod.taxonconcept.org/ses/Zwn8A.rdf#Individual	1	\N	f	1273	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1729	http://lod.taxonconcept.org/ses/Cmm3r.html#Image	1	\N	f	1274	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1730	http://www.w3.org/2003/11/swrl#IndividualPropertyAtom	51	\N	t	70	IndividualPropertyAtom	IndividualPropertyAtom	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51
1731	http://lod.taxonconcept.org/ses/q8iz4.rdf#Individual	1	\N	f	1184	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1732	http://lod.taxonconcept.org/ses/XSZsk.html#Image	1	\N	f	1275	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1733	http://lod.taxonconcept.org/ses/KdO4e.html#Image	1	\N	f	1276	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1734	http://lod.taxonconcept.org/ses/kg5kx.html#Identification	2	\N	f	1277	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1735	http://lod.taxonconcept.org/ses/IHHNf.rdf#Occurrence	2	\N	f	1278	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1736	http://lod.taxonconcept.org/ses/wVrLq.rdf#Occurrence	1	\N	f	955	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1737	http://lod.taxonconcept.org/ses/MI82U.html#Identification	1	\N	f	1279	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1738	http://lod.taxonconcept.org/ses/XIHap.rdf#Individual	2	\N	f	563	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1739	http://lod.taxonconcept.org/ses/zXvuQ.rdf#Occurrence	3	\N	f	418	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1740	http://lod.taxonconcept.org/ses/VEbVW.html#Identification	1	\N	f	1280	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1741	http://lod.taxonconcept.org/ses/yRW2E.html#Identification	1	\N	f	1281	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1742	http://lod.taxonconcept.org/ses/onbrF.rdf#Individual	2	\N	f	873	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1743	http://lod.taxonconcept.org/ses/u5z7k.rdf#Individual	1	\N	f	1282	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1744	http://lod.taxonconcept.org/ses/ucHx6.html#Identification	1	\N	f	1283	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1745	http://lod.taxonconcept.org/ses/lNKo8.html#Image	1	\N	f	1284	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1746	http://lod.taxonconcept.org/ses/UEIab.html#Image	1	\N	f	1285	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1747	http://lod.taxonconcept.org/ses/wPxH9.html#Image	1	\N	f	1286	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1748	http://lod.taxonconcept.org/ses/Swiii.html#Image	1	\N	f	1287	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1749	http://lod.taxonconcept.org/ses/ECftr.rdf#Individual	1	\N	f	1288	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1750	http://lod.taxonconcept.org/ses/ifobC.rdf#Individual	1	\N	f	1170	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1751	http://lod.taxonconcept.org/ses/aJize.rdf#Occurrence	1	\N	f	1210	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1752	http://lod.taxonconcept.org/ses/bfHCN.html#Image	1	\N	f	1289	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1753	http://lod.taxonconcept.org/ses/2wS2P.rdf#Occurrence	1	\N	f	900	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1754	http://lod.taxonconcept.org/ses/x6gDo.rdf#Occurrence	1	\N	f	763	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1755	http://lod.taxonconcept.org/ses/MYQMc.html#Image	1	\N	f	1009	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1756	http://lod.taxonconcept.org/ses/IGhqK.html#Image	1	\N	f	1290	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1757	http://taxref.mnhn.fr/lod/status/BioGeographicalStatus	1311780	\N	t	651	BioGeographicalStatus	BioGeographicalStatus	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1311780
1758	http://lod.taxonconcept.org/ses/JhEQA.rdf#Individual	1	\N	f	1203	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1759	http://lod.taxonconcept.org/ses/CQJBJ.rdf#Occurrence	4	\N	f	302	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1760	http://lod.taxonconcept.org/ses/uDbnq.rdf#Occurrence	1	\N	f	1132	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1761	http://lod.taxonconcept.org/ses/xmwfI.rdf#Occurrence	1	\N	f	1291	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1762	http://lod.taxonconcept.org/ses/tkMBF.rdf#Individual	2	\N	f	950	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1763	http://lod.taxonconcept.org/ses/Vts5z.rdf#Occurrence	1	\N	f	1012	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1764	http://lod.taxonconcept.org/ses/xdmBh.rdf#Individual	1	\N	f	1038	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1765	http://lod.taxonconcept.org/ses/JiAUZ.html#Image	1	\N	f	1292	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1766	http://lod.taxonconcept.org/ses/tJoHY.rdf#Individual	1	\N	f	478	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1767	http://lod.taxonconcept.org/ses/w2O2N.rdf#Individual	1	\N	f	1293	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1768	http://lod.taxonconcept.org/ses/EkjTj.html#Image	1	\N	f	1294	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1769	http://lod.taxonconcept.org/ses/CsmOq.rdf#Individual	6	\N	f	1033	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1770	http://lod.taxonconcept.org/ses/sZNTx.html#Image	1	\N	f	1295	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1771	http://lod.taxonconcept.org/ses/zTYd3.html#Identification	2	\N	f	1296	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1772	http://lod.taxonconcept.org/ses/kbHmd.rdf#Occurrence	2	\N	f	1209	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1773	http://lod.taxonconcept.org/ses/VmbzI.html#Identification	1	\N	f	1297	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1774	http://rs.tdwg.org/ontology/voc/Collection#KingdomTypeTerm	6	\N	f	103	KingdomTypeTerm	KingdomTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1775	http://rs.tdwg.org/ontology/voc/Collection#ConservationStatusTypeTerm	10	\N	t	103	ConservationStatusTypeTerm	ConservationStatusTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1776	http://lod.taxonconcept.org/ses/ITmfL.rdf#Individual	6	\N	f	202	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1777	http://lod.taxonconcept.org/ses/oihlQ.rdf#Occurrence	1	\N	f	490	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1778	http://lod.taxonconcept.org/ses/DEwaC.rdf#Occurrence	3	\N	f	544	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1779	http://lod.taxonconcept.org/ses/Imlsn.html#Image	1	\N	f	1298	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1780	http://lod.taxonconcept.org/ses/ExW6Q.html#Identification	6	\N	f	1299	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1781	http://lod.taxonconcept.org/ses/TyNjg.rdf#Occurrence	2	\N	f	1108	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1782	http://lod.taxonconcept.org/ses/PfzSj.rdf#Occurrence	5	\N	f	1110	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1783	http://lod.taxonconcept.org/ses/24NNq.rdf#Individual	3	\N	f	204	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1784	http://lod.taxonconcept.org/ses/WVwE7.html#Identification	1	\N	f	1300	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1785	http://lod.taxonconcept.org/ses/VzwRC.rdf#Occurrence	1	\N	f	1091	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1786	http://lod.taxonconcept.org/ses/3uE4e.html#Image	1	\N	f	1301	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1787	http://lod.taxonconcept.org/ses/ECftr.rdf#Occurrence	1	\N	f	1288	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1788	http://lod.taxonconcept.org/ses/u7nsW.rdf#Occurrence	1	\N	f	129	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1789	http://lod.taxonconcept.org/ses/B4grE.html#Image	1	\N	f	1302	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1790	http://www.w3.org/2001/vcard-rdf/3.0#work	6	\N	f	1224	work	work	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1791	http://www.w3.org/2001/vcard-rdf/3.0#voice	6	\N	f	1224	voice	voice	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1792	http://www.w3.org/2003/11/swrl#ClassAtom	6	\N	f	70	ClassAtom	ClassAtom	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1793	http://lod.taxonconcept.org/ses/OJayI.rdf#Occurrence	1	\N	f	655	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1794	http://lod.taxonconcept.org/ses/t5Fmw.rdf#Occurrence	1	\N	f	1206	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1795	http://lod.taxonconcept.org/ses/DhWpJ.rdf#Occurrence	1	\N	f	861	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1796	http://lod.taxonconcept.org/ses/JYUlw.html#Identification	2	\N	f	1303	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1797	http://lod.taxonconcept.org/ses/HvnDP.html#Image	1	\N	f	1304	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1798	http://lod.taxonconcept.org/ses/qDzwF.rdf#Individual	2	\N	f	730	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1799	http://lod.taxonconcept.org/ses/yJV4R.rdf#Occurrence	1	\N	f	1254	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1800	http://lod.taxonconcept.org/ses/w2O2N.rdf#Occurrence	1	\N	f	1293	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1801	http://lod.taxonconcept.org/ses/Uc2wY.html#Identification	1	\N	f	630	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1802	http://lod.taxonconcept.org/ses/pFZTS.html#Identification	1	\N	f	1305	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1803	http://lod.taxonconcept.org/ses/EvygK.html#Image	1	\N	f	1306	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1804	http://lod.taxonconcept.org/ses/ulNqc.html#Image	1	\N	f	1307	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1805	http://lod.taxonconcept.org/ses/TOKln.html#Identification	1	\N	f	1308	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1806	http://lod.taxonconcept.org/ses/TOKln.rdf#Occurrence	1	\N	f	645	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1807	http://lod.taxonconcept.org/ses/raMe2.rdf#Occurrence	1	\N	f	383	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1808	http://lod.taxonconcept.org/ses/iBxm9.rdf#Individual	4	\N	f	997	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1809	http://lod.taxonconcept.org/ses/OvsHQ.rdf#Occurrence	1	\N	f	85	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1810	http://lod.taxonconcept.org/ses/KDldJ.rdf#Occurrence	3	\N	f	475	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1811	http://lod.taxonconcept.org/ses/CTjra.html#Image	1	\N	f	1309	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1812	http://lod.taxonconcept.org/ses/XEpNj.html#Image	1	\N	f	1310	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1813	http://lod.taxonconcept.org/ses/RT7qP.html#Image	1	\N	f	1311	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1814	http://lod.taxonconcept.org/ses/jxIU7.html#Image	1	\N	f	1312	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1815	http://lod.taxonconcept.org/ses/87FpO.rdf#Occurrence	2	\N	f	888	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1816	http://lod.taxonconcept.org/ses/ZcfSK.rdf#Individual	2	\N	f	881	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1817	http://lod.taxonconcept.org/ses/KOlsc.rdf#Individual	2	\N	f	1121	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1818	http://lod.taxonconcept.org/ses/fJamf.rdf#Individual	1	\N	f	1099	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1819	http://lod.taxonconcept.org/ses/ar4Fe.rdf#Individual	1	\N	f	143	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1820	http://lod.taxonconcept.org/ses/OKN8Y.html#Image	1	\N	f	1313	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1821	http://lod.taxonconcept.org/ses/vS5nY.html#Identification	1	\N	f	1314	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1822	http://lod.taxonconcept.org/ses/mdkiV.rdf#Occurrence	1	\N	f	722	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1823	http://lod.taxonconcept.org/ses/u5z7k.html#Identification	1	\N	f	1315	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1824	http://lod.taxonconcept.org/ses/hC5xg.html#Image	1	\N	f	1316	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1825	http://lod.taxonconcept.org/ses/GTgtA.rdf#Occurrence	1	\N	f	1317	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1826	http://lod.taxonconcept.org/ses/DNnGE.rdf#Occurrence	2	\N	f	94	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1827	http://lod.taxonconcept.org/ses/aFRYB.html#Identification	2	\N	f	1318	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1828	http://lod.taxonconcept.org/ses/QZUKm.rdf#Occurrence	1	\N	f	965	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1829	http://lod.taxonconcept.org/ses/IJVMg.rdf#Individual	1	\N	f	784	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1830	http://lod.taxonconcept.org/ses/tnJr6.rdf#Occurrence	1	\N	f	1319	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1831	http://lod.taxonconcept.org/ses/BiEsG.html#Image	1	\N	f	1320	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1832	http://lod.taxonconcept.org/ses/aaZRA.rdf#Occurrence	2	\N	f	455	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1833	http://lod.taxonconcept.org/ses/dwAmr.rdf#Individual	1	\N	f	1116	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1834	http://lod.taxonconcept.org/ses/u6Qgt.rdf#Occurrence	2	\N	f	257	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1835	http://lod.taxonconcept.org/ses/GrQWJ.html#Identification	1	\N	f	1321	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1836	http://lod.taxonconcept.org/ses/wVrLq.html#Identification	1	\N	f	1322	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1837	http://lod.taxonconcept.org/ses/xFcQi.html#Image	1	\N	f	1323	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1838	http://lod.taxonconcept.org/ses/x6gDo.html#Image	1	\N	f	217	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1839	http://lod.taxonconcept.org/ses/TM9SC.html#Identification	1	\N	f	1324	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1840	http://lod.taxonconcept.org/ses/kJ8FO.rdf#Occurrence	1	\N	f	674	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1841	http://lod.taxonconcept.org/ses/ucHx6.rdf#Individual	1	\N	f	1218	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1842	http://rs.tdwg.org/ontology/voc/Collection#SpecimenPreservationMethodTypeTerm	21	\N	t	103	SpecimenPreservationMethodTypeTerm	SpecimenPreservationMethodTypeTerm	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1843	http://rs.tdwg.org/ontology/voc/GeographicRegion#GeographicRegionLevel1Term	9	\N	f	105	GeographicRegionLevel1Term	GeographicRegionLevel1Term	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1844	http://www.w3.org/2003/11/swrl#Variable	14	\N	t	70	Variable	Variable	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	108
1845	http://lod.taxonconcept.org/ses/PQLdJ.html#Identification	3	\N	f	1325	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1846	https://schema.org/Article	1	\N	f	1180	Article	Article	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1847	http://lod.taxonconcept.org/ses/2fPxZ.html#Image	1	\N	f	1326	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1848	http://lod.taxonconcept.org/ses/2iG3r.rdf#Occurrence	2	\N	f	515	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1849	http://lod.taxonconcept.org/ses/irCf3.html#Image	1	\N	f	1327	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1850	http://lod.taxonconcept.org/ses/wNzoi.rdf#Occurrence	1	\N	f	909	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1851	http://lod.taxonconcept.org/ses/24NNq.html#Identification	3	\N	f	1328	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1852	http://lod.taxonconcept.org/ses/ndTgB.rdf#Individual	1	\N	f	562	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1853	http://lod.taxonconcept.org/ses/iVwKh.rdf#Occurrence	2	\N	f	242	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1854	http://lod.taxonconcept.org/ses/QNRma.html#Image	1	\N	f	1235	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1855	http://lod.taxonconcept.org/ses/SSFw3.html#Image	1	\N	f	1329	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1856	http://lod.taxonconcept.org/ses/47C3Q.html#Identification	2	\N	f	1330	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1857	http://lod.taxonconcept.org/ses/HaAJw.rdf#Individual	1	\N	f	600	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1858	http://lod.taxonconcept.org/ses/d3gmb.rdf#Individual	1	\N	f	1190	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1859	http://lod.taxonconcept.org/ses/9m9L2.html#Identification	1	\N	f	1331	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1860	http://lod.taxonconcept.org/ses/Zwn8A.rdf#Occurrence	1	\N	f	1273	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1861	http://lod.taxonconcept.org/ses/ZoFhA.html#Identification	1	\N	f	1332	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1862	http://lod.taxonconcept.org/ses/iRnzQ.rdf#Occurrence	1	\N	f	138	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1863	http://lod.taxonconcept.org/ses/6GTSq.html#Image	1	\N	f	1333	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1864	http://lod.taxonconcept.org/ses/RqaGd.html#Image	1	\N	f	1334	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1865	http://lod.taxonconcept.org/ses/BYWpt.html#Identification	1	\N	f	1335	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1866	http://lod.taxonconcept.org/ses/22wQv.html#Image	1	\N	f	491	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1867	http://lod.taxonconcept.org/ses/nnt7Z.html#Identification	1	\N	f	1336	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1868	http://lod.taxonconcept.org/ses/G92Fi.html#Image	1	\N	f	1337	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1869	http://lod.taxonconcept.org/ses/QZUKm.html#Image	1	\N	f	631	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1870	http://lod.taxonconcept.org/ses/IHHNf.rdf#Individual	2	\N	f	1278	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1871	http://lod.taxonconcept.org/ses/xmwfI.rdf#Individual	1	\N	f	1291	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1872	http://lod.taxonconcept.org/ses/kg5kx.rdf#Individual	2	\N	f	1149	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1873	http://lod.taxonconcept.org/ses/BPoM4.html#Image	1	\N	f	1338	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1874	http://lod.taxonconcept.org/ses/MI82U.rdf#Individual	1	\N	f	1271	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1875	http://lod.taxonconcept.org/ses/eZAe8.html#Image	1	\N	f	1339	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1876	http://lod.taxonconcept.org/ses/cCZRL.html#Identification	1	\N	f	1340	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1877	http://lod.taxonconcept.org/ses/iuCXz.html#Image	1	\N	f	1341	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1878	http://lod.taxonconcept.org/ses/GTgtA.rdf#Individual	1	\N	f	1317	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1879	http://lod.taxonconcept.org/ses/rVPHV.rdf#Individual	1	\N	f	494	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1880	http://lod.taxonconcept.org/ses/hE3Lu.html#Image	1	\N	f	1342	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1881	http://lod.taxonconcept.org/ses/tnJr6.rdf#Individual	1	\N	f	1319	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1882	http://lod.taxonconcept.org/ses/u5z7k.rdf#Occurrence	1	\N	f	1282	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1883	http://lod.taxonconcept.org/ses/X6aiO.html#Identification	3	\N	f	1343	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1884	http://lod.taxonconcept.org/ses/dGA7c.rdf#Individual	2	\N	f	1214	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1885	http://lod.taxonconcept.org/ses/eVSXV.rdf#Individual	2	\N	f	618	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1886	http://lod.taxonconcept.org/ses/rjjZx.html#Image	1	\N	f	1344	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1887	http://lod.taxonconcept.org/ses/PGFS2.html#Image	1	\N	f	1345	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1888	http://lod.taxonconcept.org/ses/QXRZr.rdf#Individual	1	\N	f	637	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1889	http://lod.taxonconcept.org/ses/ArS7W.rdf#Occurrence	1	\N	f	644	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1890	http://lod.taxonconcept.org/ses/cCZRL.rdf#Individual	1	\N	f	1262	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1891	http://lod.taxonconcept.org/ses/vS5nY.rdf#Individual	1	\N	f	1260	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1892	http://lod.taxonconcept.org/ses/e62Ou.html#Image	1	\N	f	1346	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1893	http://lod.taxonconcept.org/ses/Imlsn.html#Identification	1	\N	f	1298	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1894	http://lod.taxonconcept.org/ses/yCpDA.html#Image	1	\N	f	1347	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1895	http://lod.taxonconcept.org/ses/TtUUO.html#Image	1	\N	f	1348	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1896	http://lod.taxonconcept.org/ses/DM53s.html#Image	1	\N	f	1349	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1897	http://lod.taxonconcept.org/ses/DpTKa.html#Image	1	\N	f	1350	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1898	http://lod.taxonconcept.org/ses/WhSxv.html#Image	1	\N	f	1351	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1899	http://lod.taxonconcept.org/ses/6CpaW.rdf#Individual	1	\N	f	959	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1900	http://lod.taxonconcept.org/ses/AFYz2.html#Image	1	\N	f	1158	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1901	http://lod.taxonconcept.org/ses/VjYO7.html#Image	1	\N	f	1352	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1902	http://lod.taxonconcept.org/ses/y6jvL.rdf#Occurrence	1	\N	f	1006	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1903	http://lod.taxonconcept.org/ses/PoSYA.html#Identification	1	\N	f	1353	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1904	http://lod.taxonconcept.org/ses/Hq5OE.html#Image	1	\N	f	1354	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1905	http://lod.taxonconcept.org/ses/rdubQ.rdf#Occurrence	1	\N	f	1237	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1906	http://lod.taxonconcept.org/ses/s32nE.rdf#Occurrence	1	\N	f	287	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1907	http://lod.taxonconcept.org/ses/CaK98.rdf#Individual	1	\N	f	1062	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1908	http://lod.taxonconcept.org/ses/r8QqF.rdf#Individual	1	\N	f	1095	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1909	http://lod.taxonconcept.org/ses/z5bSA.html#Image	1	\N	f	1355	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1910	http://lod.taxonconcept.org/ses/ibUB4.html#Image	1	\N	f	1356	Image	Image	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1911	http://lod.taxonconcept.org/ses/UARq7.html#Identification	1	\N	f	1357	Identification	Identification	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1912	http://lod.taxonconcept.org/ses/6KkDY.rdf#Individual	1	\N	f	352	Individual	Individual	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1913	http://lod.taxonconcept.org/ses/IB4Hf.rdf#Occurrence	1	\N	f	927	Occurrence	Occurrence	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
259	http://www.wikidata.org/entity/Q192498	8	\N	f	12	Q192498	[administrative territorial entity of France (Wik.. (Q192498)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
742	http://www.wikidata.org/entity/Q484170	35061	\N	t	12	Q484170	[commune of France (Wikidata) (Q484170)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4305
744	http://www.wikidata.org/entity/Q36784	18	\N	t	12	Q36784	[region of France (Wikidata) (Q36784)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	66224
979	http://www.wikidata.org/entity/Q1811014	30	\N	t	12	Q1811014	[phase of life (Q1811014)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60
1006	http://www.wikidata.org/entity/Q82673	3	\N	f	12	Q82673	[conservation status (Wikidata) (Q82673)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1114	http://www.wikidata.org/entity/Q6465	101	\N	t	12	Q6465	[department of France (Wikidata) (Q6465)]	287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	69162
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	57	2	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
2	1117	3	2	3892831	\N	3892831	\N	\N	1	1	2	f	0	\N	\N
3	740	3	2	1690781	\N	1690781	\N	\N	2	1	2	f	0	\N	\N
4	741	3	2	14048	\N	14048	\N	\N	3	1	2	f	0	\N	\N
5	907	3	2	8	\N	0	\N	\N	4	1	2	f	8	\N	\N
6	1111	3	2	5	\N	0	\N	\N	5	1	2	f	5	\N	\N
7	476	3	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
8	1118	3	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
9	748	3	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
10	261	3	2	3892828	\N	3892828	\N	\N	0	1	2	f	0	\N	\N
11	1112	3	2	14048	\N	14048	\N	\N	0	1	2	f	0	\N	\N
12	1113	3	2	117	\N	117	\N	\N	0	1	2	f	0	\N	\N
13	914	3	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
14	257	3	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
15	476	4	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
16	257	4	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
17	261	5	2	12546	\N	0	\N	\N	1	1	2	f	12546	\N	\N
18	740	5	2	11335	\N	0	\N	\N	2	1	2	f	11335	\N	\N
19	1117	5	2	12546	\N	0	\N	\N	0	1	2	f	12546	\N	\N
20	1136	6	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
21	736	7	2	2163	\N	2163	\N	\N	1	1	2	f	0	\N	\N
22	736	7	1	2163	\N	2163	\N	\N	1	1	2	f	\N	\N	\N
23	1118	8	2	3244	\N	3244	\N	\N	1	1	2	f	0	\N	\N
24	1511	8	2	589	\N	589	\N	\N	2	1	2	f	0	\N	\N
25	264	8	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
26	1330	8	1	3833	\N	3833	\N	\N	1	1	2	f	\N	\N	\N
27	1117	9	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
28	1117	9	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
29	27	10	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
30	26	10	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
31	476	11	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
32	257	11	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
33	476	12	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
34	257	12	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
35	1117	13	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
36	1117	13	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
37	736	14	2	27	\N	27	\N	\N	1	1	2	f	0	\N	\N
38	736	14	1	27	\N	27	\N	\N	1	1	2	f	\N	\N	\N
39	748	15	2	320	\N	320	\N	\N	1	1	2	f	0	\N	\N
40	749	15	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
41	751	15	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
42	1117	16	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
43	1117	16	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
44	1118	17	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
45	264	17	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
46	1118	18	2	14592	\N	0	\N	\N	1	1	2	f	14592	\N	\N
47	1119	18	2	2889	\N	0	\N	\N	0	1	2	f	2889	\N	\N
48	262	18	2	871	\N	0	\N	\N	0	1	2	f	871	\N	\N
49	746	18	2	482	\N	0	\N	\N	0	1	2	f	482	\N	\N
50	1120	18	2	401	\N	0	\N	\N	0	1	2	f	401	\N	\N
51	263	18	2	364	\N	0	\N	\N	0	1	2	f	364	\N	\N
52	1121	18	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
53	264	18	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
54	740	19	2	552710	\N	552710	\N	\N	1	1	2	f	0	\N	\N
55	1118	20	2	11467	\N	11467	\N	\N	1	1	2	f	0	\N	\N
56	1511	20	2	1158	\N	1158	\N	\N	2	1	2	f	0	\N	\N
57	958	20	2	188	\N	188	\N	\N	3	1	2	f	0	\N	\N
58	959	20	2	69	\N	69	\N	\N	4	1	2	f	0	\N	\N
59	956	20	2	43	\N	43	\N	\N	5	1	2	f	0	\N	\N
60	1119	20	2	1581	\N	1581	\N	\N	0	1	2	f	0	\N	\N
61	746	20	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
62	1120	20	2	322	\N	322	\N	\N	0	1	2	f	0	\N	\N
63	262	20	2	296	\N	296	\N	\N	0	1	2	f	0	\N	\N
64	263	20	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
65	1121	20	2	116	\N	116	\N	\N	0	1	2	f	0	\N	\N
66	264	20	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
67	475	21	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
68	740	22	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
69	748	23	2	10225	\N	10225	\N	\N	1	1	2	f	0	\N	\N
70	749	23	2	2005	\N	2005	\N	\N	0	1	2	f	0	\N	\N
71	1123	23	2	638	\N	638	\N	\N	0	1	2	f	0	\N	\N
72	750	23	2	268	\N	268	\N	\N	0	1	2	f	0	\N	\N
73	751	23	2	247	\N	247	\N	\N	0	1	2	f	0	\N	\N
74	1124	23	2	200	\N	200	\N	\N	0	1	2	f	0	\N	\N
75	476	24	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
76	257	24	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
77	476	25	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
78	257	25	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
79	27	26	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
80	26	26	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
81	1118	27	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
82	956	27	2	50	\N	0	\N	\N	2	1	2	f	50	\N	\N
83	1119	27	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
84	262	27	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
85	746	27	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
86	1120	27	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
87	263	27	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
88	1121	27	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
89	264	27	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
90	257	28	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
91	907	28	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
92	1118	29	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
93	1511	29	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
94	958	29	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
95	956	29	2	50	\N	50	\N	\N	4	1	2	f	0	\N	\N
96	1119	29	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
97	262	29	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
98	746	29	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
99	1120	29	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
100	263	29	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
101	1121	29	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
102	264	29	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
103	959	29	1	20788	\N	20788	\N	\N	1	1	2	f	\N	\N	\N
104	736	30	2	648800	\N	0	\N	\N	1	1	2	f	648800	\N	\N
105	1117	30	2	32706	\N	0	\N	\N	2	1	2	f	32706	\N	\N
106	257	31	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
107	1117	32	2	160	\N	160	\N	\N	1	1	2	f	0	\N	\N
108	1117	32	1	160	\N	160	\N	\N	1	1	2	f	\N	\N	\N
109	740	33	2	833640	\N	833640	\N	\N	1	1	2	f	0	\N	\N
110	1117	33	1	833638	\N	833638	\N	\N	1	1	2	f	\N	\N	\N
111	27	34	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
112	28	34	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
113	26	34	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
114	1117	35	2	832	\N	832	\N	\N	1	1	2	f	0	\N	\N
115	1117	35	1	832	\N	832	\N	\N	1	1	2	f	\N	\N	\N
116	27	36	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
117	26	36	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
118	740	37	2	552710	\N	552710	\N	\N	1	1	2	f	0	\N	\N
119	476	37	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
120	257	37	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
121	57	37	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
122	1117	38	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
123	1117	38	1	317	\N	317	\N	\N	1	1	2	f	\N	\N	\N
124	740	39	2	297	\N	0	\N	\N	1	1	2	f	297	\N	\N
125	907	39	2	51	\N	0	\N	\N	2	1	2	f	51	\N	\N
126	1111	39	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
127	915	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
128	261	40	2	16593	\N	0	\N	\N	1	1	2	f	16593	\N	\N
129	740	40	2	8857	\N	0	\N	\N	2	1	2	f	8857	\N	\N
130	1117	40	2	16593	\N	0	\N	\N	0	1	2	f	16593	\N	\N
131	748	41	2	102446	\N	102446	\N	\N	1	1	2	f	0	\N	\N
132	749	41	2	14184	\N	14184	\N	\N	0	1	2	f	0	\N	\N
133	750	41	2	4126	\N	4126	\N	\N	0	1	2	f	0	\N	\N
134	1123	41	2	3202	\N	3202	\N	\N	0	1	2	f	0	\N	\N
135	1124	41	2	2891	\N	2891	\N	\N	0	1	2	f	0	\N	\N
136	751	41	2	2466	\N	2466	\N	\N	0	1	2	f	0	\N	\N
137	261	42	2	998616	\N	0	\N	\N	1	1	2	f	998616	\N	\N
138	740	42	2	455413	\N	0	\N	\N	2	1	2	f	455413	\N	\N
139	1117	42	2	998616	\N	0	\N	\N	0	1	2	f	998616	\N	\N
140	1118	43	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
141	1511	43	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
142	1119	43	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
143	262	43	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
144	746	43	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
145	1120	43	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
146	263	43	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
147	1121	43	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
148	264	43	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
149	958	43	1	20460	\N	20460	\N	\N	1	1	2	f	\N	\N	\N
150	748	44	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
151	1139	44	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
152	749	44	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
153	750	44	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
154	1123	44	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
155	1124	44	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
156	751	44	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
157	315	44	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
158	1187	44	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
159	353	44	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
160	761	44	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
161	765	44	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
162	273	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
163	1231	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
164	741	45	2	5372	\N	0	\N	\N	1	1	2	f	5372	\N	\N
165	1112	45	2	5372	\N	0	\N	\N	0	1	2	f	5372	\N	\N
166	261	46	2	42732	\N	0	\N	\N	1	1	2	f	42732	\N	\N
167	740	46	2	10955	\N	0	\N	\N	2	1	2	f	10955	\N	\N
168	1117	46	2	42732	\N	0	\N	\N	0	1	2	f	42732	\N	\N
169	261	47	2	184519	\N	0	\N	\N	1	1	2	f	184519	\N	\N
170	740	47	2	66067	\N	0	\N	\N	2	1	2	f	66067	\N	\N
171	1117	47	2	184519	\N	0	\N	\N	0	1	2	f	184519	\N	\N
172	261	48	2	7613	\N	0	\N	\N	1	1	2	f	7613	\N	\N
173	740	48	2	1680	\N	0	\N	\N	2	1	2	f	1680	\N	\N
174	1117	48	2	7613	\N	0	\N	\N	0	1	2	f	7613	\N	\N
175	1757	49	2	1311780	\N	1311780	\N	\N	1	1	2	f	0	\N	\N
176	1538	49	2	221958	\N	221958	\N	\N	2	1	2	f	0	\N	\N
177	1117	49	1	1311780	\N	1311780	\N	\N	1	1	2	f	\N	\N	\N
178	748	51	2	43723	\N	43723	\N	\N	1	1	2	f	0	\N	\N
179	749	51	2	5356	\N	5356	\N	\N	0	1	2	f	0	\N	\N
180	750	51	2	1679	\N	1679	\N	\N	0	1	2	f	0	\N	\N
181	751	51	2	1354	\N	1354	\N	\N	0	1	2	f	0	\N	\N
182	1124	51	2	1019	\N	1019	\N	\N	0	1	2	f	0	\N	\N
183	1123	51	2	733	\N	733	\N	\N	0	1	2	f	0	\N	\N
184	740	54	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
185	264	55	2	229	\N	229	\N	\N	1	1	2	f	0	\N	\N
186	1118	55	2	229	\N	229	\N	\N	0	1	2	f	0	\N	\N
187	748	56	2	91418	\N	91418	\N	\N	1	1	2	f	0	\N	\N
188	1123	56	2	3202	\N	3202	\N	\N	0	1	2	f	0	\N	\N
189	749	56	2	2458	\N	2458	\N	\N	0	1	2	f	0	\N	\N
190	750	56	2	216	\N	216	\N	\N	0	1	2	f	0	\N	\N
191	751	56	2	180	\N	180	\N	\N	0	1	2	f	0	\N	\N
192	1124	56	2	167	\N	167	\N	\N	0	1	2	f	0	\N	\N
193	907	57	2	702	\N	702	\N	\N	1	1	2	f	0	\N	\N
194	1111	57	2	100	\N	100	\N	\N	2	1	2	f	0	\N	\N
195	256	57	2	88	\N	88	\N	\N	3	1	2	f	0	\N	\N
196	1110	57	2	38	\N	38	\N	\N	4	1	2	f	0	\N	\N
197	1332	57	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
198	914	57	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
199	915	57	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
200	738	57	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
201	907	57	1	627	\N	627	\N	\N	1	1	2	f	\N	\N	\N
202	1111	57	1	208	\N	208	\N	\N	2	1	2	f	\N	\N	\N
203	1110	57	1	49	\N	49	\N	\N	3	1	2	f	\N	\N	\N
204	256	57	1	20	\N	20	\N	\N	4	1	2	f	\N	\N	\N
205	914	57	1	101	\N	101	\N	\N	0	1	2	f	\N	\N	\N
206	1332	57	1	43	\N	43	\N	\N	0	1	2	f	\N	\N	\N
207	738	57	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
208	1117	58	2	10436	\N	10436	\N	\N	1	1	2	f	0	\N	\N
209	1117	58	1	211	\N	211	\N	\N	1	1	2	f	\N	\N	\N
210	736	59	2	646333	\N	0	\N	\N	1	1	2	f	646333	\N	\N
211	740	60	2	37	\N	22	\N	\N	1	1	2	f	15	\N	\N
212	740	60	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
213	736	61	2	163	\N	163	\N	\N	1	1	2	f	0	\N	\N
214	736	61	1	163	\N	163	\N	\N	1	1	2	f	\N	\N	\N
215	1107	62	2	2229	\N	2229	\N	\N	1	1	2	f	0	\N	\N
216	1454	62	2	57	\N	57	\N	\N	2	1	2	f	0	\N	\N
217	1109	62	1	1319	\N	1319	\N	\N	1	1	2	f	\N	\N	\N
218	740	62	1	1181	\N	1181	\N	\N	2	1	2	f	\N	\N	\N
219	907	62	1	252	\N	252	\N	\N	3	1	2	f	\N	\N	\N
220	1730	62	1	51	\N	51	\N	\N	4	1	2	f	\N	\N	\N
221	1332	62	1	28	\N	28	\N	\N	0	1	2	f	\N	\N	\N
222	478	62	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
223	914	62	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
224	740	63	2	300	\N	0	\N	\N	1	1	2	f	300	\N	\N
225	257	63	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
226	907	63	2	4	\N	0	\N	\N	3	1	2	f	4	\N	\N
227	1117	65	2	310943	\N	0	\N	\N	1	1	2	f	310943	\N	\N
228	740	65	2	148651	\N	0	\N	\N	2	1	2	f	148651	\N	\N
229	261	65	2	310941	\N	0	\N	\N	0	1	2	f	310941	\N	\N
230	1118	66	2	37	\N	37	\N	\N	1	1	2	f	0	\N	\N
231	1120	66	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
232	27	66	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
233	26	66	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
234	740	67	2	80	\N	80	\N	\N	1	1	2	f	0	\N	\N
235	740	67	1	68	\N	68	\N	\N	1	1	2	f	\N	\N	\N
236	1110	68	2	115	\N	0	\N	\N	1	1	2	f	115	\N	\N
237	907	68	2	14	\N	0	\N	\N	2	1	2	f	14	\N	\N
238	740	68	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
239	1360	69	2	56706	\N	0	\N	\N	1	1	2	f	56706	\N	\N
240	1118	71	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
241	1119	71	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
242	262	71	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
243	746	71	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
244	1120	71	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
245	263	71	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
246	1121	71	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
247	264	71	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
248	978	72	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
249	476	72	1	14	\N	14	\N	\N	1	1	2	f	\N	\N	\N
250	907	73	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
251	1111	75	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
252	476	76	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
253	257	76	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
254	740	76	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
255	740	77	2	32934	\N	0	\N	\N	1	1	2	f	32934	\N	\N
256	921	78	2	41092	\N	41092	\N	\N	1	1	2	f	0	\N	\N
257	481	78	2	41092	\N	41092	\N	\N	0	1	2	f	0	\N	\N
258	740	78	1	36880	\N	36880	\N	\N	1	1	2	f	\N	\N	\N
259	33	79	2	609	\N	0	\N	\N	1	1	2	f	609	\N	\N
260	35	79	2	369	\N	0	\N	\N	2	1	2	f	369	\N	\N
261	1333	79	2	60	\N	0	\N	\N	3	1	2	f	60	\N	\N
262	34	79	2	52	\N	0	\N	\N	4	1	2	f	52	\N	\N
263	964	79	2	38	\N	0	\N	\N	5	1	2	f	38	\N	\N
264	740	79	2	38	\N	0	\N	\N	6	1	2	f	38	\N	\N
265	36	79	2	26	\N	0	\N	\N	7	1	2	f	26	\N	\N
266	257	79	2	26	\N	0	\N	\N	8	1	2	f	26	\N	\N
267	963	79	2	24	\N	0	\N	\N	9	1	2	f	24	\N	\N
268	37	79	2	22	\N	0	\N	\N	10	1	2	f	22	\N	\N
269	1842	79	2	21	\N	0	\N	\N	11	1	2	f	21	\N	\N
270	961	79	2	16	\N	0	\N	\N	12	1	2	f	16	\N	\N
271	41	79	2	15	\N	0	\N	\N	13	1	2	f	15	\N	\N
272	30	79	2	12	\N	0	\N	\N	14	1	2	f	12	\N	\N
273	1775	79	2	10	\N	0	\N	\N	15	1	2	f	10	\N	\N
274	476	80	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
275	257	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
276	27	82	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
277	26	82	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
278	1110	85	2	24	\N	0	\N	\N	1	1	2	f	24	\N	\N
279	907	85	2	9	\N	0	\N	\N	2	1	2	f	9	\N	\N
280	740	85	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
281	228	86	2	297092	\N	297092	\N	\N	1	1	2	f	0	\N	\N
282	1111	86	1	297090	\N	297090	\N	\N	1	1	2	f	\N	\N	\N
283	27	87	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
284	26	87	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
285	1114	88	2	96	\N	0	\N	\N	1	1	2	f	96	\N	\N
286	744	88	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
287	1115	88	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
288	257	89	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
289	256	90	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
290	257	90	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
291	740	91	2	74155	\N	0	\N	\N	1	1	2	f	74155	\N	\N
292	1111	91	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
293	907	91	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
294	476	92	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
295	257	92	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
296	27	95	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
297	26	95	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
298	1117	96	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
299	1117	97	2	187	\N	187	\N	\N	1	1	2	f	0	\N	\N
300	1117	97	1	187	\N	187	\N	\N	1	1	2	f	\N	\N	\N
301	1118	98	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
302	1119	98	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
303	262	98	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
304	746	98	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
305	1120	98	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
306	263	98	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
307	1121	98	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
308	264	98	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
309	1118	101	2	1115	\N	0	\N	\N	1	1	2	f	1115	\N	\N
310	1511	101	2	419	\N	0	\N	\N	2	1	2	f	419	\N	\N
311	958	101	2	60	\N	0	\N	\N	3	1	2	f	60	\N	\N
312	959	101	2	42	\N	0	\N	\N	4	1	2	f	42	\N	\N
313	956	101	2	41	\N	0	\N	\N	5	1	2	f	41	\N	\N
314	264	101	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
315	1120	101	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
316	746	101	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
317	1119	101	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
318	262	101	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
319	263	101	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
320	740	102	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
321	1360	102	1	56706	\N	56706	\N	\N	1	1	2	f	\N	\N	\N
322	736	103	2	648800	\N	648800	\N	\N	1	1	2	f	0	\N	\N
323	1117	103	2	32707	\N	32707	\N	\N	2	1	2	f	0	\N	\N
324	691	104	2	220129	\N	220129	\N	\N	1	1	2	f	0	\N	\N
325	1117	104	1	220129	\N	220129	\N	\N	1	1	2	f	\N	\N	\N
326	1117	106	2	60	\N	60	\N	\N	1	1	2	f	0	\N	\N
327	1117	106	1	60	\N	60	\N	\N	1	1	2	f	\N	\N	\N
328	1332	107	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
329	907	107	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
330	1118	108	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
331	1511	108	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
332	958	108	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
333	959	108	2	78	\N	78	\N	\N	4	1	2	f	0	\N	\N
334	956	108	2	50	\N	50	\N	\N	5	1	2	f	0	\N	\N
335	1119	108	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
336	262	108	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
337	746	108	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
338	1120	108	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
339	263	108	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
340	1121	108	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
341	264	108	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
342	748	109	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
343	1139	109	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
344	749	109	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
345	750	109	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
346	1123	109	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
347	1124	109	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
348	751	109	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
349	315	109	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
350	1187	109	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
351	353	109	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
352	761	109	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
353	765	109	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
354	273	109	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
355	1231	109	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
356	1117	111	2	543	\N	543	\N	\N	1	1	2	f	0	\N	\N
357	1117	111	1	543	\N	543	\N	\N	1	1	2	f	\N	\N	\N
358	256	112	2	138	\N	138	\N	\N	1	1	2	f	0	\N	\N
359	738	112	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
360	1118	113	2	58850	\N	58850	\N	\N	1	1	2	f	0	\N	\N
361	1119	113	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
362	262	113	2	874	\N	874	\N	\N	0	1	2	f	0	\N	\N
363	746	113	2	484	\N	484	\N	\N	0	1	2	f	0	\N	\N
364	1120	113	2	401	\N	401	\N	\N	0	1	2	f	0	\N	\N
365	263	113	2	366	\N	366	\N	\N	0	1	2	f	0	\N	\N
366	1121	113	2	191	\N	191	\N	\N	0	1	2	f	0	\N	\N
367	264	113	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
368	958	114	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
369	1511	114	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
370	740	115	2	94758	\N	94758	\N	\N	1	1	2	f	0	\N	\N
371	736	115	1	94758	\N	94758	\N	\N	1	1	2	f	\N	\N	\N
372	740	116	2	192	\N	192	\N	\N	1	1	2	f	0	\N	\N
373	1107	116	1	1113	\N	1113	\N	\N	1	1	2	f	\N	\N	\N
374	1118	117	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
375	1119	117	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
376	262	117	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
377	746	117	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
378	1120	117	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
379	263	117	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
380	1121	117	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
381	264	117	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
382	907	118	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
383	740	120	2	5992	\N	5992	\N	\N	1	1	2	f	0	\N	\N
384	740	120	1	5988	\N	5988	\N	\N	1	1	2	f	\N	\N	\N
385	27	122	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
386	26	122	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
387	1118	123	1	21665	\N	21665	\N	\N	1	1	2	f	\N	\N	\N
388	1119	123	1	5198	\N	5198	\N	\N	0	1	2	f	\N	\N	\N
389	262	123	1	1554	\N	1554	\N	\N	0	1	2	f	\N	\N	\N
390	746	123	1	1050	\N	1050	\N	\N	0	1	2	f	\N	\N	\N
391	1120	123	1	848	\N	848	\N	\N	0	1	2	f	\N	\N	\N
392	263	123	1	700	\N	700	\N	\N	0	1	2	f	\N	\N	\N
393	1121	123	1	399	\N	399	\N	\N	0	1	2	f	\N	\N	\N
394	264	123	1	164	\N	164	\N	\N	0	1	2	f	\N	\N	\N
395	740	124	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
396	1117	125	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
397	1117	125	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
398	1117	126	2	143595	\N	143595	\N	\N	1	1	2	f	0	\N	\N
399	736	126	1	143595	\N	143595	\N	\N	1	1	2	f	\N	\N	\N
400	1118	127	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
401	1119	127	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
402	262	127	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
403	746	127	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
404	1120	127	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
405	263	127	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
406	1121	127	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
407	264	127	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
408	1118	128	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
409	1118	128	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
410	748	129	2	95904	\N	0	\N	\N	1	1	2	f	95904	\N	\N
411	749	129	2	14130	\N	0	\N	\N	0	1	2	f	14130	\N	\N
412	750	129	2	4119	\N	0	\N	\N	0	1	2	f	4119	\N	\N
413	1123	129	2	3195	\N	0	\N	\N	0	1	2	f	3195	\N	\N
414	1124	129	2	2879	\N	0	\N	\N	0	1	2	f	2879	\N	\N
415	751	129	2	2464	\N	0	\N	\N	0	1	2	f	2464	\N	\N
416	261	130	2	52936	\N	0	\N	\N	1	1	2	f	52936	\N	\N
417	740	130	2	44989	\N	0	\N	\N	2	1	2	f	44989	\N	\N
418	1117	130	2	52936	\N	0	\N	\N	0	1	2	f	52936	\N	\N
419	1117	131	2	341	\N	341	\N	\N	1	1	2	f	0	\N	\N
420	1117	131	1	341	\N	341	\N	\N	1	1	2	f	\N	\N	\N
421	748	132	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
422	1139	132	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
423	749	132	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
424	750	132	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
425	1123	132	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
426	1124	132	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
427	751	132	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
428	315	132	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
429	1187	132	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
430	353	132	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
431	761	132	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
432	765	132	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
433	273	132	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
434	1231	132	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
435	736	133	2	709	\N	709	\N	\N	1	1	2	f	0	\N	\N
436	736	133	1	709	\N	709	\N	\N	1	1	2	f	\N	\N	\N
437	1111	134	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
438	736	135	2	71	\N	0	\N	\N	1	1	2	f	71	\N	\N
439	228	136	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
440	228	137	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
441	33	138	2	609	\N	0	\N	\N	1	1	2	f	609	\N	\N
442	35	138	2	369	\N	0	\N	\N	2	1	2	f	369	\N	\N
443	34	138	2	52	\N	0	\N	\N	3	1	2	f	52	\N	\N
444	228	139	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
445	476	140	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
446	257	140	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
447	57	140	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
448	748	141	2	582525	\N	582525	\N	\N	1	1	2	f	0	\N	\N
449	749	141	2	70920	\N	70920	\N	\N	0	1	2	f	0	\N	\N
450	750	141	2	20630	\N	20630	\N	\N	0	1	2	f	0	\N	\N
451	1123	141	2	16010	\N	16010	\N	\N	0	1	2	f	0	\N	\N
452	1124	141	2	14455	\N	14455	\N	\N	0	1	2	f	0	\N	\N
453	751	141	2	12330	\N	12330	\N	\N	0	1	2	f	0	\N	\N
454	740	142	2	2174	\N	2174	\N	\N	1	1	2	f	0	\N	\N
455	740	142	1	2052	\N	2052	\N	\N	1	1	2	f	\N	\N	\N
456	740	143	2	2052	\N	2052	\N	\N	1	1	2	f	0	\N	\N
457	740	143	1	2174	\N	2174	\N	\N	1	1	2	f	\N	\N	\N
458	261	144	2	257	\N	0	\N	\N	1	1	2	f	257	\N	\N
459	740	144	2	227	\N	0	\N	\N	2	1	2	f	227	\N	\N
460	1117	144	2	257	\N	0	\N	\N	0	1	2	f	257	\N	\N
461	740	145	2	5988	\N	5988	\N	\N	1	1	2	f	0	\N	\N
462	740	145	1	5992	\N	5992	\N	\N	1	1	2	f	\N	\N	\N
463	740	146	2	1064	\N	1064	\N	\N	1	1	2	f	0	\N	\N
464	740	146	1	1087	\N	1087	\N	\N	1	1	2	f	\N	\N	\N
465	1332	147	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
466	907	147	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
467	907	147	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
468	1332	147	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
469	476	148	2	2	\N	1	\N	\N	1	1	2	f	1	\N	\N
470	257	148	2	2	\N	1	\N	\N	0	1	2	f	1	\N	\N
471	261	149	2	1996	\N	0	\N	\N	1	1	2	f	1996	\N	\N
472	740	149	2	1887	\N	0	\N	\N	2	1	2	f	1887	\N	\N
473	1117	149	2	1996	\N	0	\N	\N	0	1	2	f	1996	\N	\N
474	261	150	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
475	740	150	2	202	\N	0	\N	\N	2	1	2	f	202	\N	\N
476	1117	150	2	213	\N	0	\N	\N	0	1	2	f	213	\N	\N
477	33	151	2	609	\N	0	\N	\N	1	1	2	f	609	\N	\N
478	35	151	2	369	\N	0	\N	\N	2	1	2	f	369	\N	\N
479	476	152	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
480	257	152	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
481	257	152	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
482	28	153	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
483	1118	153	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
484	1120	153	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
485	1118	154	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
486	264	154	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
487	1118	155	2	72	\N	72	\N	\N	1	1	2	f	0	\N	\N
488	737	156	2	2365569	\N	0	\N	\N	1	1	2	f	2365569	\N	\N
489	34	158	2	52	\N	52	\N	\N	1	1	2	f	0	\N	\N
490	907	159	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
491	1332	159	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
492	907	159	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
493	907	160	2	247	\N	247	\N	\N	1	1	2	f	0	\N	\N
494	1332	160	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
495	907	160	1	257	\N	257	\N	\N	1	1	2	f	\N	\N	\N
496	1332	160	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
497	915	160	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
498	748	161	2	116946	\N	116946	\N	\N	1	1	2	f	0	\N	\N
499	1136	161	2	19907	\N	19907	\N	\N	2	1	2	f	0	\N	\N
500	1118	161	2	18878	\N	18878	\N	\N	3	1	2	f	0	\N	\N
501	757	161	2	2008	\N	2008	\N	\N	4	1	2	f	0	\N	\N
502	1139	161	2	2008	\N	2008	\N	\N	5	1	2	f	0	\N	\N
503	1140	161	2	2008	\N	2008	\N	\N	6	1	2	f	0	\N	\N
504	1511	161	2	1644	\N	1644	\N	\N	7	1	2	f	0	\N	\N
505	1112	161	2	1170	\N	1170	\N	\N	8	1	2	f	0	\N	\N
506	1113	161	2	534	\N	534	\N	\N	9	1	2	f	0	\N	\N
507	302	161	2	448	\N	448	\N	\N	10	1	2	f	0	\N	\N
508	1125	161	2	415	\N	415	\N	\N	11	1	2	f	0	\N	\N
509	958	161	2	217	\N	217	\N	\N	12	1	2	f	0	\N	\N
510	959	161	2	78	\N	78	\N	\N	13	1	2	f	0	\N	\N
511	956	161	2	50	\N	50	\N	\N	14	1	2	f	0	\N	\N
512	749	161	2	14283	\N	14283	\N	\N	0	1	2	f	0	\N	\N
513	750	161	2	4177	\N	4177	\N	\N	0	1	2	f	0	\N	\N
514	1123	161	2	3223	\N	3223	\N	\N	0	1	2	f	0	\N	\N
515	1124	161	2	2920	\N	2920	\N	\N	0	1	2	f	0	\N	\N
516	1119	161	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
517	751	161	2	2506	\N	2506	\N	\N	0	1	2	f	0	\N	\N
518	262	161	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
519	746	161	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
520	1120	161	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
521	263	161	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
522	1121	161	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
523	741	161	2	166	\N	166	\N	\N	0	1	2	f	0	\N	\N
524	264	161	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
525	1143	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
526	280	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
527	769	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
528	315	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
529	1186	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
530	1187	161	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
531	353	161	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
532	461	161	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
533	83	161	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
534	761	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
535	765	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
536	306	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
537	1253	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
538	395	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
539	409	161	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
540	273	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
541	301	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
542	1181	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
543	794	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
544	1231	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
545	426	161	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
546	476	161	1	58837	\N	58837	\N	\N	1	1	2	f	\N	\N	\N
547	748	161	1	415	\N	415	\N	\N	2	1	2	f	\N	\N	\N
548	741	161	1	368	\N	368	\N	\N	3	1	2	f	\N	\N	\N
549	1112	161	1	368	\N	368	\N	\N	0	1	2	f	\N	\N	\N
550	749	161	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
551	751	161	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
552	750	161	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
553	1124	161	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
554	1123	161	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
555	736	162	2	238	\N	0	\N	\N	1	1	2	f	238	\N	\N
556	1107	163	2	2229	\N	2229	\N	\N	1	1	2	f	0	\N	\N
557	1454	163	2	57	\N	57	\N	\N	2	1	2	f	0	\N	\N
558	1107	163	1	1116	\N	1116	\N	\N	1	1	2	f	\N	\N	\N
559	1454	163	1	25	\N	25	\N	\N	2	1	2	f	\N	\N	\N
560	740	164	2	2785	\N	2785	\N	\N	1	1	2	f	0	\N	\N
561	740	164	1	2541	\N	2541	\N	\N	1	1	2	f	\N	\N	\N
562	748	165	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
563	1139	165	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
564	749	165	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
565	750	165	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
566	1123	165	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
567	1124	165	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
568	751	165	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
569	315	165	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
570	1187	165	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
571	353	165	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
572	761	165	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
573	765	165	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
574	273	165	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
575	1231	165	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
576	740	166	2	2541	\N	2541	\N	\N	1	1	2	f	0	\N	\N
577	740	166	1	2785	\N	2785	\N	\N	1	1	2	f	\N	\N	\N
578	1117	167	2	1887	\N	1806	\N	\N	1	1	2	f	81	\N	\N
579	740	168	2	3818	\N	3818	\N	\N	1	1	2	f	0	\N	\N
580	740	168	1	3675	\N	3675	\N	\N	1	1	2	f	\N	\N	\N
581	740	169	2	3675	\N	3675	\N	\N	1	1	2	f	0	\N	\N
582	740	169	1	3818	\N	3818	\N	\N	1	1	2	f	\N	\N	\N
583	907	170	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
584	1111	170	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
585	740	170	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
586	914	170	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
587	1332	170	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
588	907	171	2	319	\N	0	\N	\N	1	1	2	f	319	\N	\N
589	740	171	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
590	1111	171	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
591	1332	171	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
592	914	171	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
593	915	171	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
594	907	172	2	116	\N	116	\N	\N	1	1	2	f	0	\N	\N
595	1111	172	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
596	1332	172	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
597	914	172	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
598	915	172	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
599	1511	173	2	18880	\N	18880	\N	\N	1	1	2	f	0	\N	\N
600	958	173	2	1606	\N	1606	\N	\N	2	1	2	f	0	\N	\N
601	956	173	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
602	959	173	2	49	\N	49	\N	\N	4	1	2	f	0	\N	\N
603	1118	173	1	18878	\N	18878	\N	\N	1	1	2	f	\N	\N	\N
604	1511	173	1	1606	\N	1606	\N	\N	2	1	2	f	\N	\N	\N
605	958	173	1	217	\N	217	\N	\N	3	1	2	f	\N	\N	\N
606	959	173	1	78	\N	78	\N	\N	4	1	2	f	\N	\N	\N
607	956	173	1	49	\N	49	\N	\N	5	1	2	f	\N	\N	\N
608	1119	173	1	2896	\N	2896	\N	\N	0	1	2	f	\N	\N	\N
609	262	173	1	873	\N	873	\N	\N	0	1	2	f	\N	\N	\N
610	746	173	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
611	1120	173	1	402	\N	402	\N	\N	0	1	2	f	\N	\N	\N
612	263	173	1	365	\N	365	\N	\N	0	1	2	f	\N	\N	\N
613	1121	173	1	192	\N	192	\N	\N	0	1	2	f	\N	\N	\N
614	264	173	1	64	\N	64	\N	\N	0	1	2	f	\N	\N	\N
615	740	174	2	1085	\N	0	\N	\N	1	1	2	f	1085	\N	\N
616	907	174	2	348	\N	0	\N	\N	2	1	2	f	348	\N	\N
617	1111	174	2	44	\N	0	\N	\N	3	1	2	f	44	\N	\N
618	1332	174	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
619	914	174	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
620	915	174	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
621	907	175	2	95	\N	0	\N	\N	1	1	2	f	95	\N	\N
622	1111	175	2	7	\N	0	\N	\N	2	1	2	f	7	\N	\N
623	740	175	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
624	1332	175	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
625	914	175	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
626	907	176	2	58	\N	0	\N	\N	1	1	2	f	58	\N	\N
627	1111	176	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
628	740	176	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
629	914	176	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
630	1332	176	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
631	1117	177	2	159	\N	159	\N	\N	1	1	2	f	0	\N	\N
632	1117	177	1	159	\N	159	\N	\N	1	1	2	f	\N	\N	\N
633	907	178	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
634	736	179	2	50094	\N	50094	\N	\N	1	1	2	f	0	\N	\N
635	736	179	1	50094	\N	50094	\N	\N	1	1	2	f	\N	\N	\N
636	1330	180	2	3833	\N	3833	\N	\N	1	1	2	f	0	\N	\N
637	1118	180	1	3244	\N	3244	\N	\N	1	1	2	f	\N	\N	\N
638	1511	180	1	589	\N	589	\N	\N	2	1	2	f	\N	\N	\N
639	264	180	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
640	476	181	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
641	257	181	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
642	740	182	2	552883	\N	552883	\N	\N	1	1	2	f	0	\N	\N
643	741	182	2	43622	\N	43622	\N	\N	2	1	2	f	0	\N	\N
644	742	182	2	35061	\N	35061	\N	\N	3	1	2	f	0	\N	\N
645	1113	182	2	534	\N	534	\N	\N	4	1	2	f	0	\N	\N
646	1110	182	2	259	\N	259	\N	\N	5	1	2	f	0	\N	\N
647	907	182	2	246	\N	246	\N	\N	6	1	2	f	0	\N	\N
648	256	182	2	189	\N	189	\N	\N	7	1	2	f	0	\N	\N
649	260	182	2	140	\N	140	\N	\N	8	1	2	f	0	\N	\N
650	1114	182	2	101	\N	101	\N	\N	9	1	2	f	0	\N	\N
651	1116	182	2	90	\N	90	\N	\N	10	1	2	f	0	\N	\N
652	478	182	2	41	\N	41	\N	\N	11	1	2	f	0	\N	\N
653	1111	182	2	26	\N	26	\N	\N	12	1	2	f	0	\N	\N
654	744	182	2	18	\N	18	\N	\N	13	1	2	f	0	\N	\N
655	1115	182	2	17	\N	17	\N	\N	14	1	2	f	0	\N	\N
656	257	182	2	12	\N	12	\N	\N	15	1	2	f	0	\N	\N
657	1112	182	2	43622	\N	43622	\N	\N	0	1	2	f	0	\N	\N
658	479	182	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
659	738	182	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
660	1117	182	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
661	914	182	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
662	1332	182	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
663	257	182	1	373614	\N	373614	\N	\N	1	1	2	f	\N	\N	\N
664	476	182	1	372936	\N	372936	\N	\N	0	1	2	f	\N	\N	\N
665	27	183	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
666	1118	183	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
667	26	183	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
668	1120	183	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
669	28	183	1	39	\N	39	\N	\N	1	1	2	f	\N	\N	\N
670	907	184	2	88	\N	0	\N	\N	1	1	2	f	88	\N	\N
671	1111	184	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
672	1332	184	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
673	914	184	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
674	907	185	2	103	\N	48	\N	\N	1	1	2	f	55	\N	\N
675	1111	185	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
676	740	185	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
677	1332	185	2	9	\N	3	\N	\N	0	1	2	f	6	\N	\N
678	914	185	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
679	740	186	2	3515	\N	3515	\N	\N	1	1	2	f	0	\N	\N
680	740	186	1	3515	\N	3515	\N	\N	1	1	2	f	\N	\N	\N
681	907	187	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
682	914	187	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
683	740	188	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
684	740	188	1	49	\N	49	\N	\N	1	1	2	f	\N	\N	\N
685	740	189	2	102	\N	102	\N	\N	1	1	2	f	0	\N	\N
686	740	189	1	102	\N	102	\N	\N	1	1	2	f	\N	\N	\N
687	907	190	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
688	27	191	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
689	26	191	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
690	907	192	2	125	\N	125	\N	\N	1	1	2	f	0	\N	\N
691	1332	192	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
692	914	192	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
693	748	193	2	50453	\N	0	\N	\N	1	1	2	f	50453	\N	\N
694	1139	193	2	809	\N	0	\N	\N	2	1	2	f	809	\N	\N
695	749	193	2	14027	\N	0	\N	\N	0	1	2	f	14027	\N	\N
696	750	193	2	4076	\N	0	\N	\N	0	1	2	f	4076	\N	\N
697	1124	193	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
698	1123	193	2	2809	\N	0	\N	\N	0	1	2	f	2809	\N	\N
699	751	193	2	2430	\N	0	\N	\N	0	1	2	f	2430	\N	\N
700	1187	193	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
701	353	193	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
702	761	193	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
703	765	193	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
704	273	193	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
705	1231	193	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
706	740	194	2	1087	\N	1087	\N	\N	1	1	2	f	0	\N	\N
707	740	194	1	1064	\N	1064	\N	\N	1	1	2	f	\N	\N	\N
708	27	195	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
709	28	195	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
710	26	195	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
711	1117	196	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
712	1117	196	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
713	740	197	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
714	740	197	1	19	\N	19	\N	\N	1	1	2	f	\N	\N	\N
715	1117	199	2	2414	\N	2414	\N	\N	1	1	2	f	0	\N	\N
716	1117	199	1	2414	\N	2414	\N	\N	1	1	2	f	\N	\N	\N
717	740	200	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
718	27	201	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
719	28	201	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
720	26	201	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
721	257	202	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
722	476	202	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
723	476	203	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
724	740	204	2	1752892	\N	1752892	\N	\N	1	1	2	f	0	\N	\N
725	1757	204	1	1311780	\N	1311780	\N	\N	1	1	2	f	\N	\N	\N
726	1538	204	1	221956	\N	221956	\N	\N	2	1	2	f	\N	\N	\N
727	691	204	1	220129	\N	220129	\N	\N	3	1	2	f	\N	\N	\N
728	33	206	2	609	\N	0	\N	\N	1	1	2	f	609	\N	\N
729	35	206	2	369	\N	0	\N	\N	2	1	2	f	369	\N	\N
730	34	206	2	52	\N	0	\N	\N	3	1	2	f	52	\N	\N
731	257	207	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
732	1111	210	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
733	740	212	2	1249820	\N	0	\N	\N	1	1	2	f	1249820	\N	\N
734	1111	212	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
735	907	212	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
736	1117	214	2	23	\N	23	\N	\N	1	1	2	f	0	\N	\N
737	1117	214	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
738	736	215	2	265	\N	265	\N	\N	1	1	2	f	0	\N	\N
739	736	215	1	265	\N	265	\N	\N	1	1	2	f	\N	\N	\N
740	740	216	2	1013604	\N	1013604	\N	\N	1	1	2	f	0	\N	\N
741	740	216	1	1013151	\N	1013151	\N	\N	1	1	2	f	\N	\N	\N
742	1117	217	2	33905	\N	33905	\N	\N	1	1	2	f	0	\N	\N
743	479	217	2	25	\N	25	\N	\N	2	1	2	f	0	\N	\N
744	740	217	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
745	478	217	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
746	1117	217	1	33905	\N	33905	\N	\N	1	1	2	f	\N	\N	\N
747	479	217	1	25	\N	25	\N	\N	2	1	2	f	\N	\N	\N
748	740	217	1	25	\N	25	\N	\N	0	1	2	f	\N	\N	\N
749	478	217	1	25	\N	25	\N	\N	0	1	2	f	\N	\N	\N
750	1136	219	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
751	1117	220	2	920	\N	920	\N	\N	1	1	2	f	0	\N	\N
752	1117	220	1	920	\N	920	\N	\N	1	1	2	f	\N	\N	\N
753	476	221	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
754	1117	222	2	194	\N	194	\N	\N	1	1	2	f	0	\N	\N
755	261	222	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
756	476	222	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
757	257	222	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
758	1118	223	2	267	\N	267	\N	\N	1	1	2	f	0	\N	\N
759	1119	223	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
760	264	223	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
761	263	223	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
762	1118	224	2	24814	\N	24814	\N	\N	1	1	2	f	0	\N	\N
763	1119	224	2	9264	\N	9264	\N	\N	0	1	2	f	0	\N	\N
764	262	224	2	2810	\N	2810	\N	\N	0	1	2	f	0	\N	\N
765	746	224	2	1364	\N	1364	\N	\N	0	1	2	f	0	\N	\N
766	1120	224	2	1153	\N	1153	\N	\N	0	1	2	f	0	\N	\N
767	263	224	2	1124	\N	1124	\N	\N	0	1	2	f	0	\N	\N
768	1121	224	2	556	\N	556	\N	\N	0	1	2	f	0	\N	\N
769	264	224	2	208	\N	208	\N	\N	0	1	2	f	0	\N	\N
770	27	224	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
771	26	224	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
772	1117	225	1	81	\N	81	\N	\N	1	1	2	f	\N	\N	\N
773	979	225	1	30	\N	30	\N	\N	0	1	2	f	\N	\N	\N
774	738	227	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
775	257	228	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
776	907	228	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
777	1111	228	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
778	740	228	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
779	261	229	2	416	\N	0	\N	\N	1	1	2	f	416	\N	\N
780	740	229	2	242	\N	0	\N	\N	2	1	2	f	242	\N	\N
781	1117	229	2	416	\N	0	\N	\N	0	1	2	f	416	\N	\N
782	741	230	2	43400	\N	0	\N	\N	1	1	2	f	43400	\N	\N
783	256	230	2	178	\N	0	\N	\N	2	1	2	f	178	\N	\N
784	257	230	2	24	\N	0	\N	\N	3	1	2	f	24	\N	\N
785	476	230	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
786	1112	230	2	43400	\N	0	\N	\N	0	1	2	f	43400	\N	\N
787	1113	230	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
788	738	230	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
789	476	231	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
790	257	231	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
791	26	232	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
792	27	232	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
793	736	233	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
794	736	233	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
795	27	234	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
796	26	234	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
797	27	235	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
798	26	235	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
799	1117	236	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
800	1117	236	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
801	256	237	2	178	\N	178	\N	\N	1	1	2	f	0	\N	\N
802	738	237	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
803	1118	238	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
804	1119	238	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
805	262	238	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
806	746	238	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
807	1120	238	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
808	263	238	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
809	1121	238	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
810	264	238	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
811	741	239	2	14048	\N	14048	\N	\N	1	1	2	f	0	\N	\N
812	57	239	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
813	1112	239	2	14048	\N	14048	\N	\N	0	1	2	f	0	\N	\N
814	1113	239	2	117	\N	117	\N	\N	0	1	2	f	0	\N	\N
815	740	240	2	577843	\N	577843	\N	\N	1	1	2	f	0	\N	\N
816	907	241	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
817	1332	241	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
818	740	242	2	277428	\N	0	\N	\N	1	1	2	f	277428	\N	\N
819	27	243	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
820	26	243	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
821	1110	245	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
822	907	245	2	7	\N	0	\N	\N	2	1	2	f	7	\N	\N
823	740	245	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
824	1757	246	2	1311780	\N	0	\N	\N	1	1	2	f	1311780	\N	\N
825	1538	246	2	224402	\N	0	\N	\N	2	1	2	f	224402	\N	\N
826	691	246	2	220129	\N	0	\N	\N	3	1	2	f	220129	\N	\N
827	921	246	2	41102	\N	0	\N	\N	4	1	2	f	41102	\N	\N
828	1136	246	2	18878	\N	0	\N	\N	5	1	2	f	18878	\N	\N
829	256	246	2	161	\N	0	\N	\N	6	1	2	f	161	\N	\N
830	1111	246	2	11	\N	0	\N	\N	7	1	2	f	11	\N	\N
831	907	246	2	6	\N	0	\N	\N	8	1	2	f	6	\N	\N
832	257	246	2	3	\N	0	\N	\N	9	1	2	f	3	\N	\N
833	478	246	2	3	\N	0	\N	\N	10	1	2	f	3	\N	\N
834	481	246	2	41102	\N	0	\N	\N	0	1	2	f	41102	\N	\N
835	738	246	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
836	740	246	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
837	476	246	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
838	1360	247	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
839	1111	248	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
840	1111	248	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
841	228	249	2	386552	\N	386552	\N	\N	1	1	2	f	0	\N	\N
842	740	249	1	385640	\N	385640	\N	\N	1	1	2	f	\N	\N	\N
843	907	249	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
844	1111	249	1	4	\N	4	\N	\N	3	1	2	f	\N	\N	\N
845	256	249	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
846	915	249	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
847	1117	250	2	690715	\N	690715	\N	\N	1	1	2	f	0	\N	\N
848	736	250	2	94758	\N	94758	\N	\N	2	1	2	f	0	\N	\N
849	261	250	2	657610	\N	657610	\N	\N	0	1	2	f	0	\N	\N
850	979	250	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
851	476	250	1	708084	\N	708084	\N	\N	1	1	2	f	\N	\N	\N
852	257	250	1	708084	\N	708084	\N	\N	0	1	2	f	\N	\N	\N
853	27	251	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
854	26	251	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
855	476	252	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
856	257	252	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
857	740	253	2	789038	\N	789038	\N	\N	1	1	2	f	0	\N	\N
858	261	253	2	657527	\N	657527	\N	\N	2	1	2	f	0	\N	\N
859	1117	253	2	657527	\N	657527	\N	\N	0	1	2	f	0	\N	\N
860	1117	253	1	1446523	\N	1446523	\N	\N	1	1	2	f	\N	\N	\N
861	907	254	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
862	740	254	2	20	\N	20	\N	\N	2	1	2	f	0	\N	\N
863	1332	254	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
864	914	254	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
865	915	254	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
866	1111	254	1	129	\N	129	\N	\N	1	1	2	f	\N	\N	\N
867	28	255	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
868	476	256	2	8	\N	1	\N	\N	1	1	2	f	7	\N	\N
869	257	256	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
870	748	256	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
871	476	257	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
872	257	257	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
873	33	258	2	609	\N	609	\N	\N	1	1	2	f	0	\N	\N
874	35	258	2	369	\N	369	\N	\N	2	1	2	f	0	\N	\N
875	34	258	2	52	\N	52	\N	\N	3	1	2	f	0	\N	\N
876	35	258	1	609	\N	609	\N	\N	1	1	2	f	\N	\N	\N
877	34	258	1	369	\N	369	\N	\N	2	1	2	f	\N	\N	\N
878	921	260	2	13100	\N	13100	\N	\N	1	1	2	f	0	\N	\N
879	481	260	2	13100	\N	13100	\N	\N	0	1	2	f	0	\N	\N
880	1117	260	1	13100	\N	13100	\N	\N	1	1	2	f	\N	\N	\N
881	907	261	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
882	256	261	2	236	\N	236	\N	\N	2	1	2	f	0	\N	\N
883	1110	261	2	228	\N	228	\N	\N	3	1	2	f	0	\N	\N
884	1111	261	2	17	\N	17	\N	\N	4	1	2	f	0	\N	\N
885	915	261	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
886	1332	261	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
887	914	261	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
888	740	261	1	188	\N	188	\N	\N	1	1	2	f	\N	\N	\N
889	1109	261	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
890	738	261	1	81	\N	81	\N	\N	0	1	2	f	\N	\N	\N
891	257	262	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
892	736	263	2	127128	\N	127128	\N	\N	1	1	2	f	0	\N	\N
893	736	263	1	127128	\N	127128	\N	\N	1	1	2	f	\N	\N	\N
894	476	264	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
895	257	264	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
896	1118	266	2	1155	\N	0	\N	\N	1	1	2	f	1155	\N	\N
897	264	266	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
898	740	267	2	291	\N	0	\N	\N	1	1	2	f	291	\N	\N
899	907	267	2	49	\N	0	\N	\N	2	1	2	f	49	\N	\N
900	1111	267	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
901	915	267	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
902	1118	268	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
903	1511	268	2	1644	\N	0	\N	\N	2	1	2	f	1644	\N	\N
904	1119	268	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
905	262	268	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
906	746	268	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
907	1120	268	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
908	263	268	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
909	1121	268	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
910	264	268	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
911	1118	269	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
912	1511	269	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
913	958	269	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
914	1119	269	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
915	262	269	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
916	746	269	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
917	1120	269	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
918	263	269	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
919	1121	269	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
920	264	269	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
921	956	269	1	20738	\N	20738	\N	\N	1	1	2	f	\N	\N	\N
922	256	271	2	33	\N	33	\N	\N	1	1	2	f	0	\N	\N
923	738	271	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
924	748	272	2	64	\N	64	\N	\N	1	1	2	f	0	\N	\N
925	748	272	1	64	\N	64	\N	\N	1	1	2	f	\N	\N	\N
926	1117	273	2	651662	\N	0	\N	\N	1	1	2	f	651662	\N	\N
927	261	273	2	651661	\N	0	\N	\N	0	1	2	f	651661	\N	\N
928	1136	274	2	19889	\N	19889	\N	\N	1	1	2	f	0	\N	\N
929	1511	274	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
930	1112	274	2	1004	\N	1004	\N	\N	3	1	2	f	0	\N	\N
931	959	274	2	78	\N	78	\N	\N	4	1	2	f	0	\N	\N
932	257	274	2	6	\N	6	\N	\N	5	1	2	f	0	\N	\N
933	476	274	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
934	478	274	1	2011	\N	2011	\N	\N	1	1	2	f	\N	\N	\N
935	1117	275	2	104	\N	104	\N	\N	1	1	2	f	0	\N	\N
936	1117	275	1	104	\N	104	\N	\N	1	1	2	f	\N	\N	\N
937	742	276	2	35061	\N	35061	\N	\N	1	1	2	f	0	\N	\N
938	260	276	2	140	\N	140	\N	\N	2	1	2	f	0	\N	\N
939	1114	276	2	101	\N	101	\N	\N	3	1	2	f	0	\N	\N
940	1116	276	2	90	\N	90	\N	\N	4	1	2	f	0	\N	\N
941	744	276	2	18	\N	18	\N	\N	5	1	2	f	0	\N	\N
942	1115	276	2	17	\N	17	\N	\N	6	1	2	f	0	\N	\N
943	1114	276	1	34964	\N	34964	\N	\N	1	1	2	f	\N	\N	\N
944	742	276	1	131	\N	131	\N	\N	2	1	2	f	\N	\N	\N
945	744	276	1	52	\N	52	\N	\N	3	1	2	f	\N	\N	\N
946	1115	276	1	36	\N	36	\N	\N	4	1	2	f	\N	\N	\N
947	260	276	1	20	\N	20	\N	\N	5	1	2	f	\N	\N	\N
948	1118	277	2	4565	\N	0	\N	\N	1	1	2	f	4565	\N	\N
949	1119	277	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
950	262	277	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
951	746	277	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
952	1120	277	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
953	263	277	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
954	1121	277	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
955	740	278	2	320	\N	320	\N	\N	1	1	2	f	0	\N	\N
956	740	278	1	334	\N	334	\N	\N	1	1	2	f	\N	\N	\N
957	740	280	2	442	\N	442	\N	\N	1	1	2	f	0	\N	\N
958	740	280	1	428	\N	428	\N	\N	1	1	2	f	\N	\N	\N
959	261	281	2	5419	\N	0	\N	\N	1	1	2	f	5419	\N	\N
960	740	281	2	5340	\N	0	\N	\N	2	1	2	f	5340	\N	\N
961	1117	281	2	5419	\N	0	\N	\N	0	1	2	f	5419	\N	\N
962	911	282	2	309	\N	309	\N	\N	1	1	2	f	0	\N	\N
963	1118	282	1	309	\N	309	\N	\N	1	1	2	f	\N	\N	\N
964	1119	282	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
965	1120	282	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
966	740	283	2	428	\N	428	\N	\N	1	1	2	f	0	\N	\N
967	740	283	1	442	\N	442	\N	\N	1	1	2	f	\N	\N	\N
968	740	284	2	334	\N	334	\N	\N	1	1	2	f	0	\N	\N
969	740	284	1	320	\N	320	\N	\N	1	1	2	f	\N	\N	\N
970	1110	285	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
971	907	285	2	7	\N	0	\N	\N	2	1	2	f	7	\N	\N
972	740	285	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
973	1118	286	2	15504	\N	15504	\N	\N	1	1	2	f	0	\N	\N
974	1119	286	2	2893	\N	2893	\N	\N	0	1	2	f	0	\N	\N
975	262	286	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
976	746	286	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
977	1120	286	2	400	\N	400	\N	\N	0	1	2	f	0	\N	\N
978	263	286	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
979	1121	286	2	191	\N	191	\N	\N	0	1	2	f	0	\N	\N
980	264	286	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
981	737	287	2	2365569	\N	2365569	\N	\N	1	1	2	f	0	\N	\N
982	740	287	2	2075400	\N	2075400	\N	\N	2	1	2	f	0	\N	\N
983	1117	287	2	1348099	\N	1348099	\N	\N	3	1	2	f	0	\N	\N
984	1757	287	2	1311780	\N	1311780	\N	\N	4	1	2	f	0	\N	\N
985	736	287	2	743558	\N	743558	\N	\N	5	1	2	f	0	\N	\N
986	228	287	2	386552	\N	386552	\N	\N	6	1	2	f	0	\N	\N
987	1170	287	2	234186	\N	234186	\N	\N	7	1	2	f	0	\N	\N
988	1538	287	2	221958	\N	221958	\N	\N	8	1	2	f	0	\N	\N
989	691	287	2	220129	\N	220129	\N	\N	9	1	2	f	0	\N	\N
990	748	287	2	143382	\N	143382	\N	\N	10	1	2	f	0	\N	\N
991	1136	287	2	136412	\N	136412	\N	\N	11	1	2	f	0	\N	\N
992	1112	287	2	88414	\N	88414	\N	\N	12	1	2	f	0	\N	\N
993	921	287	2	86748	\N	86748	\N	\N	13	1	2	f	0	\N	\N
994	57	287	2	56710	\N	56710	\N	\N	14	1	2	f	0	\N	\N
995	1360	287	2	56706	\N	56706	\N	\N	15	1	2	f	0	\N	\N
996	742	287	2	35061	\N	35061	\N	\N	16	1	2	f	0	\N	\N
997	749	287	2	30385	\N	30385	\N	\N	17	1	2	f	0	\N	\N
998	1118	287	2	24163	\N	24163	\N	\N	18	1	2	f	0	\N	\N
999	1327	287	2	12876	\N	12876	\N	\N	19	1	2	f	0	\N	\N
1000	1331	287	2	12583	\N	12583	\N	\N	20	1	2	f	0	\N	\N
1001	913	287	2	12347	\N	12347	\N	\N	21	1	2	f	0	\N	\N
1002	750	287	2	11040	\N	11040	\N	\N	22	1	2	f	0	\N	\N
1003	751	287	2	6541	\N	6541	\N	\N	23	1	2	f	0	\N	\N
1004	1123	287	2	6472	\N	6472	\N	\N	24	1	2	f	0	\N	\N
1005	1330	287	2	3827	\N	3827	\N	\N	25	1	2	f	0	\N	\N
1006	1107	287	2	2229	\N	2229	\N	\N	26	1	2	f	0	\N	\N
1007	757	287	2	2008	\N	2008	\N	\N	27	1	2	f	0	\N	\N
1008	1139	287	2	2008	\N	2008	\N	\N	28	1	2	f	0	\N	\N
1009	1140	287	2	2008	\N	2008	\N	\N	29	1	2	f	0	\N	\N
1010	475	287	2	1673	\N	1673	\N	\N	30	1	2	f	0	\N	\N
1011	1511	287	2	1650	\N	1650	\N	\N	31	1	2	f	0	\N	\N
1012	907	287	2	965	\N	965	\N	\N	32	1	2	f	0	\N	\N
1013	1125	287	2	889	\N	889	\N	\N	33	1	2	f	0	\N	\N
1014	1113	287	2	866	\N	866	\N	\N	34	1	2	f	0	\N	\N
1015	1109	287	2	628	\N	628	\N	\N	35	1	2	f	0	\N	\N
1016	33	287	2	609	\N	609	\N	\N	36	1	2	f	0	\N	\N
1017	256	287	2	463	\N	463	\N	\N	37	1	2	f	0	\N	\N
1018	35	287	2	369	\N	369	\N	\N	38	1	2	f	0	\N	\N
1019	1110	287	2	338	\N	338	\N	\N	39	1	2	f	0	\N	\N
1020	1111	287	2	335	\N	335	\N	\N	40	1	2	f	0	\N	\N
1021	911	287	2	309	\N	309	\N	\N	41	1	2	f	0	\N	\N
1022	302	287	2	224	\N	224	\N	\N	42	1	2	f	0	\N	\N
1023	958	287	2	217	\N	217	\N	\N	43	1	2	f	0	\N	\N
1024	1328	287	2	151	\N	151	\N	\N	44	1	2	f	0	\N	\N
1025	260	287	2	140	\N	140	\N	\N	45	1	2	f	0	\N	\N
1026	478	287	2	121	\N	121	\N	\N	46	1	2	f	0	\N	\N
1027	1114	287	2	101	\N	101	\N	\N	47	1	2	f	0	\N	\N
1028	1116	287	2	90	\N	90	\N	\N	48	1	2	f	0	\N	\N
1029	26	287	2	79	\N	79	\N	\N	49	1	2	f	0	\N	\N
1030	959	287	2	78	\N	78	\N	\N	50	1	2	f	0	\N	\N
1031	1333	287	2	61	\N	61	\N	\N	51	1	2	f	0	\N	\N
1032	1454	287	2	57	\N	57	\N	\N	52	1	2	f	0	\N	\N
1033	474	287	2	52	\N	52	\N	\N	53	1	2	f	0	\N	\N
1034	34	287	2	52	\N	52	\N	\N	54	1	2	f	0	\N	\N
1035	1730	287	2	51	\N	51	\N	\N	55	1	2	f	0	\N	\N
1036	956	287	2	50	\N	50	\N	\N	56	1	2	f	0	\N	\N
1037	45	287	2	48	\N	48	\N	\N	57	1	2	f	0	\N	\N
1038	257	287	2	43	\N	43	\N	\N	58	1	2	f	0	\N	\N
1039	964	287	2	38	\N	38	\N	\N	59	1	2	f	0	\N	\N
1040	36	287	2	26	\N	26	\N	\N	60	1	2	f	0	\N	\N
1041	963	287	2	24	\N	24	\N	\N	61	1	2	f	0	\N	\N
1042	37	287	2	22	\N	22	\N	\N	62	1	2	f	0	\N	\N
1043	1842	287	2	21	\N	21	\N	\N	63	1	2	f	0	\N	\N
1044	744	287	2	18	\N	18	\N	\N	64	1	2	f	0	\N	\N
1045	476	287	2	17	\N	17	\N	\N	65	1	2	f	0	\N	\N
1046	1115	287	2	17	\N	17	\N	\N	66	1	2	f	0	\N	\N
1047	961	287	2	16	\N	16	\N	\N	67	1	2	f	0	\N	\N
1048	1536	287	2	16	\N	16	\N	\N	68	1	2	f	0	\N	\N
1049	41	287	2	15	\N	15	\N	\N	69	1	2	f	0	\N	\N
1050	32	287	2	14	\N	14	\N	\N	70	1	2	f	0	\N	\N
1051	1844	287	2	14	\N	14	\N	\N	71	1	2	f	0	\N	\N
1052	28	287	2	13	\N	13	\N	\N	72	1	2	f	0	\N	\N
1053	30	287	2	12	\N	12	\N	\N	73	1	2	f	0	\N	\N
1054	1775	287	2	10	\N	10	\N	\N	74	1	2	f	0	\N	\N
1055	978	287	2	10	\N	10	\N	\N	75	1	2	f	0	\N	\N
1056	261	287	2	1315219	\N	1315219	\N	\N	0	1	2	f	0	\N	\N
1057	303	287	2	234100	\N	234100	\N	\N	0	1	2	f	0	\N	\N
1058	741	287	2	87410	\N	87410	\N	\N	0	1	2	f	0	\N	\N
1059	481	287	2	86748	\N	86748	\N	\N	0	1	2	f	0	\N	\N
1060	1124	287	2	8519	\N	8519	\N	\N	0	1	2	f	0	\N	\N
1061	1119	287	2	6127	\N	6127	\N	\N	0	1	2	f	0	\N	\N
1062	262	287	2	1752	\N	1752	\N	\N	0	1	2	f	0	\N	\N
1063	746	287	2	1307	\N	1307	\N	\N	0	1	2	f	0	\N	\N
1064	1120	287	2	1042	\N	1042	\N	\N	0	1	2	f	0	\N	\N
1065	263	287	2	1014	\N	1014	\N	\N	0	1	2	f	0	\N	\N
1066	1121	287	2	528	\N	528	\N	\N	0	1	2	f	0	\N	\N
1067	264	287	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
1068	738	287	2	124	\N	124	\N	\N	0	1	2	f	0	\N	\N
1069	479	287	2	93	\N	93	\N	\N	0	1	2	f	0	\N	\N
1070	27	287	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
1071	1171	287	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
1072	1332	287	2	70	\N	70	\N	\N	0	1	2	f	0	\N	\N
1073	979	287	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1074	914	287	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1075	1143	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1076	280	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1077	769	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1078	315	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1079	1186	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1080	1187	287	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1081	353	287	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1082	461	287	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1083	83	287	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1084	761	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1085	765	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1086	306	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1087	1253	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1088	395	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1089	409	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1090	915	287	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1091	273	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1092	301	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1093	1181	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1094	794	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1095	1231	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1096	426	287	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1097	740	287	1	1920110	\N	1920110	\N	\N	1	1	2	f	\N	\N	\N
1098	738	287	1	4155025	\N	4155025	\N	\N	0	1	2	f	\N	\N	\N
1099	958	288	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1100	1118	290	1	126865	\N	126865	\N	\N	1	1	2	f	\N	\N	\N
1101	1119	290	1	82429	\N	82429	\N	\N	0	1	2	f	\N	\N	\N
1102	262	290	1	24436	\N	24436	\N	\N	0	1	2	f	\N	\N	\N
1103	746	290	1	11421	\N	11421	\N	\N	0	1	2	f	\N	\N	\N
1104	263	290	1	10295	\N	10295	\N	\N	0	1	2	f	\N	\N	\N
1105	1120	290	1	9829	\N	9829	\N	\N	0	1	2	f	\N	\N	\N
1106	1121	290	1	4120	\N	4120	\N	\N	0	1	2	f	\N	\N	\N
1107	257	293	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1108	740	294	2	1359693	\N	0	\N	\N	1	1	2	f	1359693	\N	\N
1109	228	294	2	104339	\N	0	\N	\N	2	1	2	f	104339	\N	\N
1110	1136	295	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1111	1757	296	2	318899	\N	318899	\N	\N	1	1	2	f	0	\N	\N
1112	1538	296	2	231562	\N	231562	\N	\N	2	1	2	f	0	\N	\N
1113	691	296	2	220129	\N	220129	\N	\N	3	1	2	f	0	\N	\N
1114	921	296	2	39592	\N	39592	\N	\N	4	1	2	f	0	\N	\N
1115	736	296	2	33204	\N	33204	\N	\N	5	1	2	f	0	\N	\N
1116	481	296	2	39592	\N	39592	\N	\N	0	1	2	f	0	\N	\N
1117	741	296	1	623197	\N	623197	\N	\N	1	1	2	f	\N	\N	\N
1118	1113	296	1	433211	\N	433211	\N	\N	2	1	2	f	\N	\N	\N
1119	1112	296	1	623197	\N	623197	\N	\N	0	1	2	f	\N	\N	\N
1120	736	297	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1121	736	297	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1122	1118	298	2	65647	\N	65647	\N	\N	1	1	2	f	0	\N	\N
1123	1119	298	2	42386	\N	42386	\N	\N	0	1	2	f	0	\N	\N
1124	262	298	2	13418	\N	13418	\N	\N	0	1	2	f	0	\N	\N
1125	746	298	2	6239	\N	6239	\N	\N	0	1	2	f	0	\N	\N
1126	1120	298	2	4954	\N	4954	\N	\N	0	1	2	f	0	\N	\N
1127	263	298	2	4934	\N	4934	\N	\N	0	1	2	f	0	\N	\N
1128	1121	298	2	2507	\N	2507	\N	\N	0	1	2	f	0	\N	\N
1129	1117	300	2	285864	\N	0	\N	\N	1	1	2	f	285864	\N	\N
1130	261	300	2	285863	\N	0	\N	\N	0	1	2	f	285863	\N	\N
1131	228	301	2	386552	\N	386552	\N	\N	1	1	2	f	0	\N	\N
1132	1111	301	1	1156728	\N	1156728	\N	\N	1	1	2	f	\N	\N	\N
1133	256	301	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1134	740	302	2	28502	\N	0	\N	\N	1	1	2	f	28502	\N	\N
1135	1117	303	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
1136	1117	303	1	49	\N	49	\N	\N	1	1	2	f	\N	\N	\N
1137	1117	304	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1138	1117	304	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1139	907	305	2	40	\N	39	\N	\N	1	1	2	f	1	\N	\N
1140	1332	305	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1141	914	305	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1142	1136	306	2	18901	\N	18901	\N	\N	1	1	2	f	0	\N	\N
1143	1330	306	2	3833	\N	3833	\N	\N	2	1	2	f	0	\N	\N
1144	1118	306	1	41008	\N	41008	\N	\N	1	1	2	f	\N	\N	\N
1145	1511	306	1	2233	\N	2233	\N	\N	2	1	2	f	\N	\N	\N
1146	958	306	1	220	\N	220	\N	\N	3	1	2	f	\N	\N	\N
1147	959	306	1	79	\N	79	\N	\N	4	1	2	f	\N	\N	\N
1148	956	306	1	61	\N	61	\N	\N	5	1	2	f	\N	\N	\N
1149	27	306	1	39	\N	39	\N	\N	6	1	2	f	\N	\N	\N
1150	28	306	1	13	\N	13	\N	\N	7	1	2	f	\N	\N	\N
1151	476	306	1	1	\N	1	\N	\N	8	1	2	f	\N	\N	\N
1152	1119	306	1	5792	\N	5792	\N	\N	0	1	2	f	\N	\N	\N
1153	262	306	1	1746	\N	1746	\N	\N	0	1	2	f	\N	\N	\N
1154	746	306	1	966	\N	966	\N	\N	0	1	2	f	\N	\N	\N
1155	1120	306	1	804	\N	804	\N	\N	0	1	2	f	\N	\N	\N
1156	263	306	1	730	\N	730	\N	\N	0	1	2	f	\N	\N	\N
1157	1121	306	1	384	\N	384	\N	\N	0	1	2	f	\N	\N	\N
1158	264	306	1	180	\N	180	\N	\N	0	1	2	f	\N	\N	\N
1159	26	306	1	39	\N	39	\N	\N	0	1	2	f	\N	\N	\N
1160	1136	308	2	116505	\N	116505	\N	\N	1	1	2	f	0	\N	\N
1161	1360	308	2	56706	\N	56706	\N	\N	2	1	2	f	0	\N	\N
1162	1125	308	2	415	\N	415	\N	\N	3	1	2	f	0	\N	\N
1163	476	308	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
1164	257	308	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1165	27	310	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1166	26	310	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1167	1111	311	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1168	1109	312	2	628	\N	628	\N	\N	1	1	2	f	0	\N	\N
1169	907	312	1	675	\N	675	\N	\N	1	1	2	f	\N	\N	\N
1170	1332	312	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1171	1118	313	1	58850	\N	58850	\N	\N	1	1	2	f	\N	\N	\N
1172	1119	313	1	2896	\N	2896	\N	\N	0	1	2	f	\N	\N	\N
1173	262	313	1	874	\N	874	\N	\N	0	1	2	f	\N	\N	\N
1174	746	313	1	484	\N	484	\N	\N	0	1	2	f	\N	\N	\N
1175	1120	313	1	401	\N	401	\N	\N	0	1	2	f	\N	\N	\N
1176	263	313	1	366	\N	366	\N	\N	0	1	2	f	\N	\N	\N
1177	1121	313	1	191	\N	191	\N	\N	0	1	2	f	\N	\N	\N
1178	264	313	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
1179	740	314	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
1180	963	315	2	24	\N	0	\N	\N	1	1	2	f	24	\N	\N
1181	907	315	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
1182	740	315	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1183	476	316	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1184	257	316	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1185	748	317	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
1186	1139	317	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
1187	749	317	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
1188	750	317	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
1189	1123	317	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
1190	1124	317	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
1191	751	317	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
1192	315	317	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1193	1187	317	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1194	353	317	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1195	761	317	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1196	765	317	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1197	273	317	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1198	1231	317	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1199	736	318	2	273068	\N	0	\N	\N	1	1	2	f	273068	\N	\N
1200	907	319	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
1201	1111	319	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
1202	740	319	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1203	1332	319	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1204	256	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1205	740	321	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1206	740	321	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1207	256	324	2	178	\N	0	\N	\N	1	1	2	f	178	\N	\N
1208	738	324	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1209	1117	325	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1210	1117	325	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1211	741	326	2	5372	\N	0	\N	\N	1	1	2	f	5372	\N	\N
1212	1112	326	2	5372	\N	0	\N	\N	0	1	2	f	5372	\N	\N
1213	261	327	2	167539	\N	0	\N	\N	1	1	2	f	167539	\N	\N
1214	740	327	2	31806	\N	0	\N	\N	2	1	2	f	31806	\N	\N
1215	1117	327	2	167539	\N	0	\N	\N	0	1	2	f	167539	\N	\N
1216	1511	328	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1217	1117	329	2	2357661	\N	2357661	\N	\N	1	1	2	f	0	\N	\N
1218	740	329	2	1025765	\N	1025765	\N	\N	2	1	2	f	0	\N	\N
1219	741	329	2	4356	\N	4356	\N	\N	3	1	2	f	0	\N	\N
1220	261	329	2	2357659	\N	2357659	\N	\N	0	1	2	f	0	\N	\N
1221	1112	329	2	4356	\N	4356	\N	\N	0	1	2	f	0	\N	\N
1222	737	329	1	4726810	\N	4726810	\N	\N	1	1	2	f	\N	\N	\N
1223	748	330	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
1224	1139	330	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
1225	749	330	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
1226	750	330	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
1227	1123	330	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
1228	1124	330	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
1229	751	330	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
1230	315	330	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1231	1187	330	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1232	353	330	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1233	761	330	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1234	765	330	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1235	273	330	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1236	1231	330	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1237	1136	331	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
1238	256	333	2	178	\N	0	\N	\N	1	1	2	f	178	\N	\N
1239	738	333	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1240	1118	334	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
1241	959	334	2	78	\N	0	\N	\N	2	1	2	f	78	\N	\N
1242	1119	334	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
1243	262	334	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
1244	746	334	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
1245	1120	334	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
1246	263	334	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
1247	1121	334	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1248	264	334	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
1249	26	335	2	41	\N	2	\N	\N	1	1	2	f	39	\N	\N
1250	28	335	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
1251	27	335	2	40	\N	1	\N	\N	0	1	2	f	39	\N	\N
1252	740	336	2	85647	\N	85647	\N	\N	1	1	2	f	0	\N	\N
1253	740	336	1	59594	\N	59594	\N	\N	1	1	2	f	\N	\N	\N
1254	1109	336	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1255	738	337	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1256	1117	338	2	9905	\N	0	\N	\N	1	1	2	f	9905	\N	\N
1257	1118	340	2	10898	\N	0	\N	\N	1	1	2	f	10898	\N	\N
1258	1119	340	2	2130	\N	0	\N	\N	0	1	2	f	2130	\N	\N
1259	262	340	2	610	\N	0	\N	\N	0	1	2	f	610	\N	\N
1260	746	340	2	356	\N	0	\N	\N	0	1	2	f	356	\N	\N
1261	1120	340	2	303	\N	0	\N	\N	0	1	2	f	303	\N	\N
1262	263	340	2	235	\N	0	\N	\N	0	1	2	f	235	\N	\N
1263	1121	340	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
1264	264	340	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1265	1118	341	2	10143	\N	10143	\N	\N	1	1	2	f	0	\N	\N
1266	1511	341	2	1295	\N	1295	\N	\N	2	1	2	f	0	\N	\N
1267	958	341	2	201	\N	201	\N	\N	3	1	2	f	0	\N	\N
1268	959	341	2	67	\N	67	\N	\N	4	1	2	f	0	\N	\N
1269	956	341	2	41	\N	41	\N	\N	5	1	2	f	0	\N	\N
1270	1119	341	2	1560	\N	1560	\N	\N	0	1	2	f	0	\N	\N
1271	262	341	2	454	\N	454	\N	\N	0	1	2	f	0	\N	\N
1272	746	341	2	334	\N	334	\N	\N	0	1	2	f	0	\N	\N
1273	1120	341	2	328	\N	328	\N	\N	0	1	2	f	0	\N	\N
1274	263	341	2	224	\N	224	\N	\N	0	1	2	f	0	\N	\N
1275	1121	341	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
1276	264	341	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1277	261	342	2	104240	\N	0	\N	\N	1	1	2	f	104240	\N	\N
1278	740	342	2	30411	\N	0	\N	\N	2	1	2	f	30411	\N	\N
1279	1117	342	2	104240	\N	0	\N	\N	0	1	2	f	104240	\N	\N
1280	261	344	2	3296	\N	0	\N	\N	1	1	2	f	3296	\N	\N
1281	740	344	2	3104	\N	0	\N	\N	2	1	2	f	3104	\N	\N
1282	1117	344	2	3296	\N	0	\N	\N	0	1	2	f	3296	\N	\N
1283	748	345	2	105	\N	105	\N	\N	1	1	2	f	0	\N	\N
1284	751	345	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1285	748	345	1	105	\N	105	\N	\N	1	1	2	f	\N	\N	\N
1286	751	345	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
1287	736	346	2	825	\N	825	\N	\N	1	1	2	f	0	\N	\N
1288	736	346	1	825	\N	825	\N	\N	1	1	2	f	\N	\N	\N
1289	740	347	2	97	\N	0	\N	\N	1	1	2	f	97	\N	\N
1290	1118	348	2	52840	\N	52840	\N	\N	1	1	2	f	0	\N	\N
1291	1117	348	2	14341	\N	14341	\N	\N	2	1	2	f	0	\N	\N
1292	1327	348	2	13374	\N	13374	\N	\N	3	1	2	f	0	\N	\N
1293	1331	348	2	12588	\N	12588	\N	\N	4	1	2	f	0	\N	\N
1294	913	348	2	12348	\N	12348	\N	\N	5	1	2	f	0	\N	\N
1295	1511	348	2	3964	\N	3964	\N	\N	6	1	2	f	0	\N	\N
1296	475	348	2	1153	\N	1153	\N	\N	7	1	2	f	0	\N	\N
1297	958	348	2	378	\N	378	\N	\N	8	1	2	f	0	\N	\N
1298	748	348	2	320	\N	320	\N	\N	9	1	2	f	0	\N	\N
1299	959	348	2	197	\N	197	\N	\N	10	1	2	f	0	\N	\N
1300	1328	348	2	151	\N	151	\N	\N	11	1	2	f	0	\N	\N
1301	956	348	2	99	\N	99	\N	\N	12	1	2	f	0	\N	\N
1302	474	348	2	54	\N	54	\N	\N	13	1	2	f	0	\N	\N
1303	45	348	2	48	\N	48	\N	\N	14	1	2	f	0	\N	\N
1304	1119	348	2	8745	\N	8745	\N	\N	0	1	2	f	0	\N	\N
1305	262	348	2	2391	\N	2391	\N	\N	0	1	2	f	0	\N	\N
1306	746	348	2	1533	\N	1533	\N	\N	0	1	2	f	0	\N	\N
1307	1120	348	2	1365	\N	1365	\N	\N	0	1	2	f	0	\N	\N
1308	263	348	2	1014	\N	1014	\N	\N	0	1	2	f	0	\N	\N
1309	1121	348	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
1310	264	348	2	217	\N	217	\N	\N	0	1	2	f	0	\N	\N
1311	749	348	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1312	751	348	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1313	1118	348	1	33450	\N	33450	\N	\N	1	1	2	f	\N	\N	\N
1314	1117	348	1	14339	\N	14339	\N	\N	2	1	2	f	\N	\N	\N
1315	1327	348	1	13374	\N	13374	\N	\N	3	1	2	f	\N	\N	\N
1316	1331	348	1	12588	\N	12588	\N	\N	4	1	2	f	\N	\N	\N
1317	913	348	1	12348	\N	12348	\N	\N	5	1	2	f	\N	\N	\N
1318	1511	348	1	5109	\N	5109	\N	\N	6	1	2	f	\N	\N	\N
1319	958	348	1	378	\N	378	\N	\N	7	1	2	f	\N	\N	\N
1320	911	348	1	309	\N	309	\N	\N	8	1	2	f	\N	\N	\N
1321	475	348	1	211	\N	211	\N	\N	9	1	2	f	\N	\N	\N
1322	959	348	1	197	\N	197	\N	\N	10	1	2	f	\N	\N	\N
1323	1328	348	1	151	\N	151	\N	\N	11	1	2	f	\N	\N	\N
1324	956	348	1	99	\N	99	\N	\N	12	1	2	f	\N	\N	\N
1325	45	348	1	48	\N	48	\N	\N	13	1	2	f	\N	\N	\N
1326	474	348	1	46	\N	46	\N	\N	14	1	2	f	\N	\N	\N
1327	1119	348	1	5841	\N	5841	\N	\N	0	1	2	f	\N	\N	\N
1328	262	348	1	1516	\N	1516	\N	\N	0	1	2	f	\N	\N	\N
1329	746	348	1	1037	\N	1037	\N	\N	0	1	2	f	\N	\N	\N
1330	1120	348	1	929	\N	929	\N	\N	0	1	2	f	\N	\N	\N
1331	263	348	1	646	\N	646	\N	\N	0	1	2	f	\N	\N	\N
1332	1121	348	1	404	\N	404	\N	\N	0	1	2	f	\N	\N	\N
1333	264	348	1	125	\N	125	\N	\N	0	1	2	f	\N	\N	\N
1334	257	349	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1335	1136	351	2	19882	\N	19882	\N	\N	1	1	2	f	0	\N	\N
1336	1511	351	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
1337	1112	351	2	1004	\N	1004	\N	\N	3	1	2	f	0	\N	\N
1338	1125	351	2	415	\N	0	\N	\N	4	1	2	f	415	\N	\N
1339	959	351	2	78	\N	78	\N	\N	5	1	2	f	0	\N	\N
1340	476	351	2	5	\N	5	\N	\N	6	1	2	f	0	\N	\N
1341	257	351	2	5	\N	5	\N	\N	7	1	2	f	0	\N	\N
1342	57	351	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1343	978	352	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1344	476	352	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1345	257	352	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1346	1118	353	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
1347	1119	353	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
1348	262	353	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
1349	746	353	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
1350	1120	353	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
1351	263	353	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
1352	1121	353	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
1353	264	353	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
1354	1511	353	1	18878	\N	18878	\N	\N	1	1	2	f	\N	\N	\N
1355	27	355	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1356	26	355	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1357	1117	356	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
1358	1117	356	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
1359	28	357	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
1360	1117	358	2	505193	\N	505193	\N	\N	1	1	2	f	0	\N	\N
1361	736	358	1	505193	\N	505193	\N	\N	1	1	2	f	\N	\N	\N
1362	740	359	2	313853	\N	2	\N	\N	1	1	2	f	313851	\N	\N
1363	907	359	2	10	\N	0	\N	\N	2	1	2	f	10	\N	\N
1364	1332	359	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1365	257	360	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1366	1117	361	2	124	\N	124	\N	\N	1	1	2	f	0	\N	\N
1367	1117	361	1	124	\N	124	\N	\N	1	1	2	f	\N	\N	\N
1368	1117	362	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1369	1117	362	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1370	476	363	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1371	257	363	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1372	741	364	2	4007	\N	0	\N	\N	1	1	2	f	4007	\N	\N
1373	476	364	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1374	1112	364	2	4007	\N	0	\N	\N	0	1	2	f	4007	\N	\N
1375	257	364	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1376	1757	365	2	1311780	\N	1311780	\N	\N	1	1	2	f	0	\N	\N
1377	1538	365	2	221956	\N	221956	\N	\N	2	1	2	f	0	\N	\N
1378	691	365	2	220109	\N	220109	\N	\N	3	1	2	f	0	\N	\N
1379	736	365	2	91289	\N	91289	\N	\N	4	1	2	f	0	\N	\N
1380	1115	365	1	1560673	\N	1560673	\N	\N	1	1	2	f	\N	\N	\N
1381	744	365	1	33086	\N	33086	\N	\N	2	1	2	f	\N	\N	\N
1382	1114	365	1	17099	\N	17099	\N	\N	3	1	2	f	\N	\N	\N
1383	261	367	2	53580	\N	0	\N	\N	1	1	2	f	53580	\N	\N
1384	740	367	2	9481	\N	0	\N	\N	2	1	2	f	9481	\N	\N
1385	1117	367	2	53580	\N	0	\N	\N	0	1	2	f	53580	\N	\N
1386	748	368	2	117509	\N	117509	\N	\N	1	1	2	f	0	\N	\N
1387	757	368	2	1004	\N	1004	\N	\N	2	1	2	f	0	\N	\N
1388	1139	368	2	1004	\N	1004	\N	\N	3	1	2	f	0	\N	\N
1389	1140	368	2	1004	\N	1004	\N	\N	4	1	2	f	0	\N	\N
1390	1112	368	2	1004	\N	1004	\N	\N	5	1	2	f	0	\N	\N
1391	1136	368	2	1004	\N	1004	\N	\N	6	1	2	f	0	\N	\N
1392	302	368	2	720	\N	720	\N	\N	7	1	2	f	0	\N	\N
1393	749	368	2	14401	\N	14401	\N	\N	0	1	2	f	0	\N	\N
1394	750	368	2	4267	\N	4267	\N	\N	0	1	2	f	0	\N	\N
1395	1123	368	2	3251	\N	3251	\N	\N	0	1	2	f	0	\N	\N
1396	1124	368	2	2972	\N	2972	\N	\N	0	1	2	f	0	\N	\N
1397	751	368	2	2603	\N	2603	\N	\N	0	1	2	f	0	\N	\N
1398	1143	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1399	280	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1400	769	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1401	315	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1402	1186	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1403	1187	368	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1404	353	368	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1405	461	368	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1406	83	368	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1407	761	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1408	765	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1409	306	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1410	1253	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1411	395	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1412	409	368	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1413	273	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1414	301	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1415	1181	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1416	794	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1417	1231	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1418	426	368	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1419	1136	368	1	116505	\N	116505	\N	\N	1	1	2	f	\N	\N	\N
1420	1112	368	1	9756	\N	9756	\N	\N	2	1	2	f	\N	\N	\N
1421	476	369	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1422	257	369	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1423	736	370	2	77767	\N	0	\N	\N	1	1	2	f	77767	\N	\N
1424	1117	370	2	32707	\N	0	\N	\N	2	1	2	f	32707	\N	\N
1425	1136	370	2	19882	\N	0	\N	\N	3	1	2	f	19882	\N	\N
1426	1118	370	2	18878	\N	0	\N	\N	4	1	2	f	18878	\N	\N
1427	1511	370	2	1644	\N	0	\N	\N	5	1	2	f	1644	\N	\N
1428	757	370	2	1004	\N	0	\N	\N	6	1	2	f	1004	\N	\N
1429	1139	370	2	1004	\N	0	\N	\N	7	1	2	f	1004	\N	\N
1430	1140	370	2	1004	\N	0	\N	\N	8	1	2	f	1004	\N	\N
1431	1112	370	2	1004	\N	0	\N	\N	9	1	2	f	1004	\N	\N
1432	748	370	2	440	\N	0	\N	\N	10	1	2	f	440	\N	\N
1433	302	370	2	224	\N	0	\N	\N	11	1	2	f	224	\N	\N
1434	958	370	2	217	\N	0	\N	\N	12	1	2	f	217	\N	\N
1435	256	370	2	178	\N	0	\N	\N	13	1	2	f	178	\N	\N
1436	959	370	2	78	\N	0	\N	\N	14	1	2	f	78	\N	\N
1437	956	370	2	50	\N	0	\N	\N	15	1	2	f	50	\N	\N
1438	1125	370	2	49	\N	0	\N	\N	16	1	2	f	49	\N	\N
1439	27	370	2	39	\N	0	\N	\N	17	1	2	f	39	\N	\N
1440	257	370	2	26	\N	0	\N	\N	18	1	2	f	26	\N	\N
1441	28	370	2	13	\N	0	\N	\N	19	1	2	f	13	\N	\N
1442	1119	370	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
1443	262	370	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
1444	746	370	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
1445	1120	370	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
1446	263	370	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
1447	1121	370	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1448	749	370	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
1449	264	370	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
1450	750	370	2	51	\N	0	\N	\N	0	1	2	f	51	\N	\N
1451	751	370	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1452	26	370	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1453	1124	370	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1454	1123	370	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1455	1143	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1456	280	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1457	769	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1458	315	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1459	1186	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1460	1187	370	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1461	738	370	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1462	353	370	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1463	461	370	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1464	83	370	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1465	761	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1466	765	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1467	306	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1468	1253	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1469	395	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1470	409	370	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1471	273	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1472	301	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1473	1181	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1474	794	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1475	1231	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1476	426	370	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1477	476	370	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1478	742	372	2	173141	\N	173141	\N	\N	1	1	2	f	0	\N	\N
1479	748	372	2	66157	\N	66157	\N	\N	2	1	2	f	0	\N	\N
1480	1511	372	2	1644	\N	1644	\N	\N	3	1	2	f	0	\N	\N
1481	1140	372	2	1004	\N	1004	\N	\N	4	1	2	f	0	\N	\N
1482	1114	372	2	502	\N	502	\N	\N	5	1	2	f	0	\N	\N
1483	958	372	2	217	\N	217	\N	\N	6	1	2	f	0	\N	\N
1484	744	372	2	79	\N	79	\N	\N	7	1	2	f	0	\N	\N
1485	260	372	2	73	\N	73	\N	\N	8	1	2	f	0	\N	\N
1486	1115	372	2	40	\N	40	\N	\N	9	1	2	f	0	\N	\N
1487	1110	372	2	13	\N	13	\N	\N	10	1	2	f	0	\N	\N
1488	907	372	2	3	\N	3	\N	\N	11	1	2	f	0	\N	\N
1489	749	372	2	7687	\N	7687	\N	\N	0	1	2	f	0	\N	\N
1490	750	372	2	2378	\N	2378	\N	\N	0	1	2	f	0	\N	\N
1491	751	372	2	1817	\N	1817	\N	\N	0	1	2	f	0	\N	\N
1492	1124	372	2	1401	\N	1401	\N	\N	0	1	2	f	0	\N	\N
1493	1123	372	2	1259	\N	1259	\N	\N	0	1	2	f	0	\N	\N
1494	1143	372	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1495	769	372	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1496	461	372	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1497	395	372	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1498	409	372	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1499	301	372	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1500	794	372	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1501	742	372	1	4174	\N	4174	\N	\N	1	1	2	f	\N	\N	\N
1502	260	372	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
1503	1327	372	1	7	\N	7	\N	\N	3	1	2	f	\N	\N	\N
1504	1117	373	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1505	1117	373	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1506	1117	374	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1507	1117	374	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
1508	27	375	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1509	26	375	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1510	1117	376	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
1511	1117	376	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
1512	1118	377	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
1513	264	377	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1514	1136	378	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
1515	476	378	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
1516	257	378	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1517	744	380	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
1518	1115	380	2	5	\N	0	\N	\N	2	1	2	f	5	\N	\N
1519	736	381	2	1681	\N	1681	\N	\N	1	1	2	f	0	\N	\N
1520	736	381	1	1681	\N	1681	\N	\N	1	1	2	f	\N	\N	\N
1521	1118	382	2	1115	\N	1115	\N	\N	1	1	2	f	0	\N	\N
1522	264	382	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
1523	1120	382	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1524	746	382	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1525	1119	382	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1526	262	382	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1527	263	382	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1528	1117	383	2	115	\N	115	\N	\N	1	1	2	f	0	\N	\N
1529	1117	383	1	115	\N	115	\N	\N	1	1	2	f	\N	\N	\N
1530	740	385	2	81	\N	81	\N	\N	1	1	2	f	0	\N	\N
1531	228	385	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1532	1333	385	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
1533	740	385	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1534	256	386	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1535	476	387	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1536	257	387	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1537	1118	388	2	309	\N	309	\N	\N	1	1	2	f	0	\N	\N
1538	1119	388	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1539	1120	388	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1540	737	389	2	2361227	\N	0	\N	\N	1	1	2	f	2361227	\N	\N
1541	740	389	2	2075081	\N	0	\N	\N	2	1	2	f	2075081	\N	\N
1542	1757	389	2	1311780	\N	0	\N	\N	3	1	2	f	1311780	\N	\N
1543	1117	389	2	657680	\N	0	\N	\N	4	1	2	f	657680	\N	\N
1544	1538	389	2	221956	\N	0	\N	\N	5	1	2	f	221956	\N	\N
1545	691	389	2	220129	\N	0	\N	\N	6	1	2	f	220129	\N	\N
1546	1170	389	2	117093	\N	0	\N	\N	7	1	2	f	117093	\N	\N
1547	736	389	2	94758	\N	0	\N	\N	8	1	2	f	94758	\N	\N
1548	57	389	2	50212	\N	0	\N	\N	9	1	2	f	50212	\N	\N
1549	1112	389	2	44626	\N	0	\N	\N	10	1	2	f	44626	\N	\N
1550	921	389	2	41100	\N	0	\N	\N	11	1	2	f	41100	\N	\N
1551	742	389	2	35061	\N	0	\N	\N	12	1	2	f	35061	\N	\N
1552	1360	389	2	11512	\N	0	\N	\N	13	1	2	f	11512	\N	\N
1553	757	389	2	1004	\N	0	\N	\N	14	1	2	f	1004	\N	\N
1554	1139	389	2	1004	\N	0	\N	\N	15	1	2	f	1004	\N	\N
1555	1140	389	2	1004	\N	0	\N	\N	16	1	2	f	1004	\N	\N
1556	1136	389	2	1004	\N	0	\N	\N	17	1	2	f	1004	\N	\N
1557	907	389	2	857	\N	0	\N	\N	18	1	2	f	857	\N	\N
1558	1113	389	2	534	\N	0	\N	\N	19	1	2	f	534	\N	\N
1559	256	389	2	426	\N	0	\N	\N	20	1	2	f	426	\N	\N
1560	1110	389	2	272	\N	0	\N	\N	21	1	2	f	272	\N	\N
1561	302	389	2	224	\N	0	\N	\N	22	1	2	f	224	\N	\N
1562	1111	389	2	209	\N	0	\N	\N	23	1	2	f	209	\N	\N
1563	260	389	2	140	\N	0	\N	\N	24	1	2	f	140	\N	\N
1564	1114	389	2	101	\N	0	\N	\N	25	1	2	f	101	\N	\N
1565	1116	389	2	90	\N	0	\N	\N	26	1	2	f	90	\N	\N
1566	1333	389	2	60	\N	0	\N	\N	27	1	2	f	60	\N	\N
1567	478	389	2	42	\N	0	\N	\N	28	1	2	f	42	\N	\N
1568	964	389	2	38	\N	0	\N	\N	29	1	2	f	38	\N	\N
1569	36	389	2	26	\N	0	\N	\N	30	1	2	f	26	\N	\N
1570	963	389	2	24	\N	0	\N	\N	31	1	2	f	24	\N	\N
1571	37	389	2	22	\N	0	\N	\N	32	1	2	f	22	\N	\N
1572	1842	389	2	21	\N	0	\N	\N	33	1	2	f	21	\N	\N
1573	744	389	2	18	\N	0	\N	\N	34	1	2	f	18	\N	\N
1574	1115	389	2	17	\N	0	\N	\N	35	1	2	f	17	\N	\N
1575	961	389	2	16	\N	0	\N	\N	36	1	2	f	16	\N	\N
1576	41	389	2	15	\N	0	\N	\N	37	1	2	f	15	\N	\N
1577	30	389	2	12	\N	0	\N	\N	38	1	2	f	12	\N	\N
1578	1536	389	2	11	\N	0	\N	\N	39	1	2	f	11	\N	\N
1579	1775	389	2	10	\N	0	\N	\N	40	1	2	f	10	\N	\N
1580	476	389	2	4	\N	0	\N	\N	41	1	2	f	4	\N	\N
1581	257	389	2	3	\N	0	\N	\N	42	1	2	f	3	\N	\N
1582	261	389	2	657610	\N	0	\N	\N	0	1	2	f	657610	\N	\N
1583	303	389	2	117050	\N	0	\N	\N	0	1	2	f	117050	\N	\N
1584	741	389	2	43622	\N	0	\N	\N	0	1	2	f	43622	\N	\N
1585	481	389	2	41100	\N	0	\N	\N	0	1	2	f	41100	\N	\N
1586	738	389	2	121	\N	0	\N	\N	0	1	2	f	121	\N	\N
1587	1171	389	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
1588	1332	389	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
1589	479	389	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
1590	914	389	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1591	1143	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1592	280	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1593	769	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1594	315	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1595	1186	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1596	1187	389	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1597	353	389	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1598	461	389	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1599	83	389	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1600	761	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1601	765	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1602	306	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1603	1253	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1604	395	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1605	409	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1606	915	389	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1607	273	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1608	301	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1609	1181	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1610	794	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1611	1231	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1612	426	389	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1613	1136	390	2	135408	\N	0	\N	\N	1	1	2	f	135408	\N	\N
1614	741	390	2	43622	\N	0	\N	\N	2	1	2	f	43622	\N	\N
1615	1118	390	2	18878	\N	0	\N	\N	3	1	2	f	18878	\N	\N
1616	1360	390	2	11512	\N	0	\N	\N	4	1	2	f	11512	\N	\N
1617	1511	390	2	1644	\N	0	\N	\N	5	1	2	f	1644	\N	\N
1618	958	390	2	217	\N	0	\N	\N	6	1	2	f	217	\N	\N
1619	959	390	2	78	\N	0	\N	\N	7	1	2	f	78	\N	\N
1620	956	390	2	50	\N	0	\N	\N	8	1	2	f	50	\N	\N
1621	27	390	2	39	\N	0	\N	\N	9	1	2	f	39	\N	\N
1622	476	390	2	8	\N	0	\N	\N	10	1	2	f	8	\N	\N
1623	257	390	2	2	\N	0	\N	\N	11	1	2	f	2	\N	\N
1624	1112	390	2	43622	\N	0	\N	\N	0	1	2	f	43622	\N	\N
1625	1119	390	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
1626	262	390	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
1627	746	390	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
1628	1120	390	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
1629	263	390	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
1630	1121	390	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1631	1113	390	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
1632	264	390	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
1633	26	390	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1634	740	391	2	106313	\N	106263	\N	\N	1	1	2	f	50	\N	\N
1635	740	391	1	106263	\N	106263	\N	\N	1	1	2	f	\N	\N	\N
1636	1109	392	2	32	\N	32	\N	\N	1	1	2	f	0	\N	\N
1637	979	392	1	30	\N	30	\N	\N	1	1	2	f	\N	\N	\N
1638	1117	392	1	30	\N	30	\N	\N	0	1	2	f	\N	\N	\N
1639	264	393	2	65	\N	65	\N	\N	1	1	2	f	0	\N	\N
1640	1118	393	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
1641	1118	393	1	65	\N	65	\N	\N	1	1	2	f	\N	\N	\N
1642	1511	394	2	1145	\N	1145	\N	\N	1	1	2	f	0	\N	\N
1643	475	394	2	527	\N	527	\N	\N	2	1	2	f	0	\N	\N
1644	958	394	2	205	\N	0	\N	\N	3	1	2	f	205	\N	\N
1645	1117	394	2	122	\N	122	\N	\N	4	1	2	f	0	\N	\N
1646	959	394	2	67	\N	67	\N	\N	5	1	2	f	0	\N	\N
1647	956	394	2	44	\N	44	\N	\N	6	1	2	f	0	\N	\N
1648	979	394	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1649	475	394	1	1256	\N	1256	\N	\N	1	1	2	f	\N	\N	\N
1650	958	394	1	205	\N	205	\N	\N	2	1	2	f	\N	\N	\N
1651	1118	394	1	203	\N	203	\N	\N	3	1	2	f	\N	\N	\N
1652	1117	394	1	87	\N	87	\N	\N	4	1	2	f	\N	\N	\N
1653	959	394	1	67	\N	67	\N	\N	5	1	2	f	\N	\N	\N
1654	956	394	1	44	\N	44	\N	\N	6	1	2	f	\N	\N	\N
1655	740	394	1	1	\N	1	\N	\N	7	1	2	f	\N	\N	\N
1656	1120	394	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
1657	264	394	1	28	\N	28	\N	\N	0	1	2	f	\N	\N	\N
1658	746	394	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
1659	1119	394	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1660	263	394	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1661	262	394	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1662	1117	395	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
1663	1117	395	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
1664	1117	396	2	1162948	\N	0	\N	\N	1	1	2	f	1162948	\N	\N
1665	748	396	2	116505	\N	0	\N	\N	2	1	2	f	116505	\N	\N
1666	1118	396	2	18885	\N	0	\N	\N	3	1	2	f	18885	\N	\N
1667	1511	396	2	1650	\N	0	\N	\N	4	1	2	f	1650	\N	\N
1668	958	396	2	218	\N	0	\N	\N	5	1	2	f	218	\N	\N
1669	959	396	2	78	\N	0	\N	\N	6	1	2	f	78	\N	\N
1670	956	396	2	50	\N	0	\N	\N	7	1	2	f	50	\N	\N
1671	27	396	2	39	\N	0	\N	\N	8	1	2	f	39	\N	\N
1672	28	396	2	13	\N	0	\N	\N	9	1	2	f	13	\N	\N
1673	261	396	2	657610	\N	0	\N	\N	0	1	2	f	657610	\N	\N
1674	749	396	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
1675	750	396	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
1676	1123	396	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
1677	1119	396	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
1678	1124	396	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
1679	751	396	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
1680	262	396	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
1681	746	396	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
1682	1120	396	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
1683	263	396	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
1684	1121	396	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1685	264	396	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
1686	979	396	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
1687	26	396	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1688	1117	397	2	1789	\N	1789	\N	\N	1	1	2	f	0	\N	\N
1689	1117	397	1	1789	\N	1789	\N	\N	1	1	2	f	\N	\N	\N
1690	740	398	2	972914	\N	972914	\N	\N	1	1	2	f	0	\N	\N
1691	261	398	1	969717	\N	969717	\N	\N	1	1	2	f	\N	\N	\N
1692	1117	398	1	969717	\N	969717	\N	\N	0	1	2	f	\N	\N	\N
1693	907	399	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1694	1117	400	2	288741	\N	288741	\N	\N	1	1	2	f	0	\N	\N
1695	261	400	2	288739	\N	288739	\N	\N	0	1	2	f	0	\N	\N
1696	740	400	1	285866	\N	285866	\N	\N	1	1	2	f	\N	\N	\N
1697	1117	400	1	2550	\N	2550	\N	\N	2	1	2	f	\N	\N	\N
1698	1110	401	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
1699	907	401	2	30	\N	30	\N	\N	2	1	2	f	0	\N	\N
1700	1110	401	1	37	\N	37	\N	\N	1	1	2	f	\N	\N	\N
1701	907	401	1	30	\N	30	\N	\N	2	1	2	f	\N	\N	\N
1702	740	402	2	789219	\N	789219	\N	\N	1	1	2	f	0	\N	\N
1703	1117	402	1	787399	\N	787399	\N	\N	1	1	2	f	\N	\N	\N
1704	261	402	1	787395	\N	787395	\N	\N	0	1	2	f	\N	\N	\N
1705	27	403	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1706	28	403	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
1707	26	403	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1708	27	404	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1709	26	404	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1710	1117	405	2	171	\N	171	\N	\N	1	1	2	f	0	\N	\N
1711	1117	405	1	171	\N	171	\N	\N	1	1	2	f	\N	\N	\N
1712	1118	406	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
1713	1511	406	2	1644	\N	0	\N	\N	2	1	2	f	1644	\N	\N
1714	958	406	2	217	\N	0	\N	\N	3	1	2	f	217	\N	\N
1715	1119	406	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
1716	262	406	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
1717	746	406	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
1718	1120	406	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
1719	263	406	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
1720	1121	406	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1721	264	406	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
1722	1125	407	2	59	\N	0	\N	\N	1	1	2	f	59	\N	\N
1723	1139	408	2	720	\N	0	\N	\N	1	1	2	f	720	\N	\N
1724	302	408	2	224	\N	0	\N	\N	2	1	2	f	224	\N	\N
1725	27	408	2	39	\N	0	\N	\N	3	1	2	f	39	\N	\N
1726	28	408	2	13	\N	0	\N	\N	4	1	2	f	13	\N	\N
1727	26	408	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1728	1187	408	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1729	761	408	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1730	1231	408	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1731	765	408	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1732	353	408	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1733	273	408	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1734	315	408	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1735	1118	410	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
1736	1511	410	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
1737	958	410	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
1738	959	410	2	78	\N	78	\N	\N	4	1	2	f	0	\N	\N
1739	956	410	2	50	\N	50	\N	\N	5	1	2	f	0	\N	\N
1740	1119	410	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
1741	262	410	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
1742	746	410	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
1743	1120	410	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
1744	263	410	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
1745	1121	410	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
1746	264	410	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
1747	1117	411	2	14898	\N	0	\N	\N	1	1	2	f	14898	\N	\N
1748	1118	413	2	11471	\N	11471	\N	\N	1	1	2	f	0	\N	\N
1749	1511	413	2	1158	\N	1158	\N	\N	2	1	2	f	0	\N	\N
1750	1119	413	2	1581	\N	1581	\N	\N	0	1	2	f	0	\N	\N
1751	746	413	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
1752	1120	413	2	322	\N	322	\N	\N	0	1	2	f	0	\N	\N
1753	262	413	2	296	\N	296	\N	\N	0	1	2	f	0	\N	\N
1754	263	413	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
1755	1121	413	2	116	\N	116	\N	\N	0	1	2	f	0	\N	\N
1756	264	413	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1757	1117	414	2	380	\N	380	\N	\N	1	1	2	f	0	\N	\N
1758	1117	414	1	380	\N	380	\N	\N	1	1	2	f	\N	\N	\N
1759	1118	415	2	21665	\N	21665	\N	\N	1	1	2	f	0	\N	\N
1760	1119	415	2	5198	\N	5198	\N	\N	0	1	2	f	0	\N	\N
1761	262	415	2	1554	\N	1554	\N	\N	0	1	2	f	0	\N	\N
1762	746	415	2	1050	\N	1050	\N	\N	0	1	2	f	0	\N	\N
1763	1120	415	2	848	\N	848	\N	\N	0	1	2	f	0	\N	\N
1764	263	415	2	700	\N	700	\N	\N	0	1	2	f	0	\N	\N
1765	1121	415	2	399	\N	399	\N	\N	0	1	2	f	0	\N	\N
1766	264	415	2	164	\N	164	\N	\N	0	1	2	f	0	\N	\N
1767	1511	416	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1768	474	417	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1769	978	418	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1770	256	418	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1771	1511	419	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
1772	956	419	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
1773	1118	419	2	8	\N	8	\N	\N	3	1	2	f	0	\N	\N
1774	959	419	2	5	\N	5	\N	\N	4	1	2	f	0	\N	\N
1775	958	419	2	5	\N	5	\N	\N	5	1	2	f	0	\N	\N
1776	476	420	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1777	257	420	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1778	748	421	2	9713	\N	9713	\N	\N	1	1	2	f	0	\N	\N
1779	749	421	2	1612	\N	1612	\N	\N	0	1	2	f	0	\N	\N
1780	1123	421	2	456	\N	456	\N	\N	0	1	2	f	0	\N	\N
1781	750	421	2	345	\N	345	\N	\N	0	1	2	f	0	\N	\N
1782	751	421	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
1783	1124	421	2	228	\N	228	\N	\N	0	1	2	f	0	\N	\N
1784	748	422	2	56786	\N	56786	\N	\N	1	1	2	f	0	\N	\N
1785	749	422	2	5052	\N	5052	\N	\N	0	1	2	f	0	\N	\N
1786	1123	422	2	1399	\N	1399	\N	\N	0	1	2	f	0	\N	\N
1787	750	422	2	1119	\N	1119	\N	\N	0	1	2	f	0	\N	\N
1788	1124	422	2	999	\N	999	\N	\N	0	1	2	f	0	\N	\N
1789	751	422	2	647	\N	647	\N	\N	0	1	2	f	0	\N	\N
1790	1117	423	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1791	1117	423	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1792	27	424	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1793	28	424	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
1794	26	424	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1795	1117	425	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1796	1117	425	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
1797	741	427	2	43400	\N	0	\N	\N	1	1	2	f	43400	\N	\N
1798	476	427	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1799	1112	427	2	43400	\N	0	\N	\N	0	1	2	f	43400	\N	\N
1800	1113	427	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
1801	257	427	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1802	476	428	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1803	257	428	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1804	476	429	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1805	257	429	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1806	1757	430	2	1311780	\N	1311780	\N	\N	1	1	2	f	0	\N	\N
1807	1538	430	2	221956	\N	221956	\N	\N	2	1	2	f	0	\N	\N
1808	691	430	2	220109	\N	220109	\N	\N	3	1	2	f	0	\N	\N
1809	736	430	2	91289	\N	91289	\N	\N	4	1	2	f	0	\N	\N
1810	1115	430	1	1560673	\N	1560673	\N	\N	1	1	2	f	\N	\N	\N
1811	744	430	1	33086	\N	33086	\N	\N	2	1	2	f	\N	\N	\N
1812	1114	430	1	17099	\N	17099	\N	\N	3	1	2	f	\N	\N	\N
1813	1117	431	2	2165	\N	2165	\N	\N	1	1	2	f	0	\N	\N
1814	1117	431	1	2165	\N	2165	\N	\N	1	1	2	f	\N	\N	\N
1815	740	432	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1816	740	432	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1817	476	433	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1818	257	433	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1819	1117	434	2	2344	\N	2344	\N	\N	1	1	2	f	0	\N	\N
1820	1117	434	1	2344	\N	2344	\N	\N	1	1	2	f	\N	\N	\N
1821	748	435	2	106	\N	106	\N	\N	1	1	2	f	0	\N	\N
1822	748	435	1	64	\N	64	\N	\N	1	1	2	f	\N	\N	\N
1823	476	436	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1824	257	436	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1825	261	437	2	147801	\N	0	\N	\N	1	1	2	f	147801	\N	\N
1826	740	437	2	66378	\N	0	\N	\N	2	1	2	f	66378	\N	\N
1827	1117	437	2	147801	\N	0	\N	\N	0	1	2	f	147801	\N	\N
1828	257	439	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1829	741	440	2	43598	\N	0	\N	\N	1	1	2	f	43598	\N	\N
1830	476	440	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1831	1112	440	2	43598	\N	0	\N	\N	0	1	2	f	43598	\N	\N
1832	1113	440	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
1833	257	440	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1834	27	441	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
1835	26	441	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
1836	907	442	2	299	\N	0	\N	\N	1	1	2	f	299	\N	\N
1837	740	442	2	285	\N	0	\N	\N	2	1	2	f	285	\N	\N
1838	1110	442	2	222	\N	0	\N	\N	3	1	2	f	222	\N	\N
1839	256	442	2	191	\N	0	\N	\N	4	1	2	f	191	\N	\N
1840	1125	442	2	59	\N	0	\N	\N	5	1	2	f	59	\N	\N
1841	257	442	2	50	\N	0	\N	\N	6	1	2	f	50	\N	\N
1842	1111	442	2	28	\N	0	\N	\N	7	1	2	f	28	\N	\N
1843	961	442	2	16	\N	0	\N	\N	8	1	2	f	16	\N	\N
1844	30	442	2	12	\N	0	\N	\N	9	1	2	f	12	\N	\N
1845	1775	442	2	10	\N	0	\N	\N	10	1	2	f	10	\N	\N
1846	228	442	2	9	\N	0	\N	\N	11	1	2	f	9	\N	\N
1847	1536	442	2	7	\N	0	\N	\N	12	1	2	f	7	\N	\N
1848	476	442	2	1	\N	0	\N	\N	13	1	2	f	1	\N	\N
1849	738	442	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
1850	914	442	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1851	1332	442	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1852	915	442	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1853	748	443	2	107711	\N	107711	\N	\N	1	1	2	f	0	\N	\N
1854	749	443	2	52093	\N	52093	\N	\N	2	1	2	f	0	\N	\N
1855	750	443	2	9816	\N	9816	\N	\N	3	1	2	f	0	\N	\N
1856	751	443	2	6956	\N	6956	\N	\N	4	1	2	f	0	\N	\N
1857	1123	443	2	15238	\N	15238	\N	\N	0	1	2	f	0	\N	\N
1858	1124	443	2	7336	\N	7336	\N	\N	0	1	2	f	0	\N	\N
1859	1117	444	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1860	736	445	2	743558	\N	0	\N	\N	1	1	2	f	743558	\N	\N
1861	1136	446	2	18878	\N	0	\N	\N	1	1	2	f	18878	\N	\N
1862	740	447	2	242926	\N	0	\N	\N	1	1	2	f	242926	\N	\N
1863	476	448	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1864	257	448	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1865	736	449	2	20048	\N	20048	\N	\N	1	1	2	f	0	\N	\N
1866	736	449	1	20048	\N	20048	\N	\N	1	1	2	f	\N	\N	\N
1867	28	450	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
1868	27	450	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
1869	1136	450	2	7	\N	7	\N	\N	3	1	2	f	0	\N	\N
1870	26	450	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1871	1118	450	1	51	\N	51	\N	\N	1	1	2	f	\N	\N	\N
1872	264	450	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
1873	1120	450	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1874	736	451	2	975	\N	975	\N	\N	1	1	2	f	0	\N	\N
1875	736	451	1	975	\N	975	\N	\N	1	1	2	f	\N	\N	\N
1876	907	452	2	121	\N	0	\N	\N	1	1	2	f	121	\N	\N
1877	740	452	2	78	\N	0	\N	\N	2	1	2	f	78	\N	\N
1878	1110	452	2	48	\N	0	\N	\N	3	1	2	f	48	\N	\N
1879	478	452	2	41	\N	0	\N	\N	4	1	2	f	41	\N	\N
1880	479	452	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
1881	1117	452	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1882	736	453	2	253	\N	0	\N	\N	1	1	2	f	253	\N	\N
1883	1117	454	2	70	\N	70	\N	\N	1	1	2	f	0	\N	\N
1884	1117	454	1	70	\N	70	\N	\N	1	1	2	f	\N	\N	\N
1885	1117	455	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
1886	1117	455	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
1887	736	456	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1888	736	456	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1889	256	457	2	351	\N	351	\N	\N	1	1	2	f	0	\N	\N
1890	907	457	2	240	\N	240	\N	\N	2	1	2	f	0	\N	\N
1891	1110	457	2	230	\N	230	\N	\N	3	1	2	f	0	\N	\N
1892	1111	457	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1893	915	457	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1894	1332	457	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1895	914	457	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1896	740	457	1	420	\N	420	\N	\N	1	1	2	f	\N	\N	\N
1897	1109	457	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1898	738	457	1	324	\N	324	\N	\N	0	1	2	f	\N	\N	\N
1899	1360	458	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
1900	57	458	1	56706	\N	56706	\N	\N	1	1	2	f	\N	\N	\N
1901	748	459	2	117096	\N	117096	\N	\N	1	1	2	f	0	\N	\N
1902	749	459	2	14228	\N	14228	\N	\N	0	1	2	f	0	\N	\N
1903	750	459	2	4131	\N	4131	\N	\N	0	1	2	f	0	\N	\N
1904	1123	459	2	3210	\N	3210	\N	\N	0	1	2	f	0	\N	\N
1905	1124	459	2	2899	\N	2899	\N	\N	0	1	2	f	0	\N	\N
1906	751	459	2	2475	\N	2475	\N	\N	0	1	2	f	0	\N	\N
1907	1170	459	1	117095	\N	117095	\N	\N	1	1	2	f	\N	\N	\N
1908	303	459	1	117052	\N	117052	\N	\N	0	1	2	f	\N	\N	\N
1909	1171	459	1	37	\N	37	\N	\N	0	1	2	f	\N	\N	\N
1910	27	460	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1911	26	460	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1912	907	461	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1913	1111	462	2	18	\N	3	\N	\N	1	1	2	f	15	\N	\N
1914	1111	462	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1915	1136	463	2	58979	\N	58979	\N	\N	1	1	2	f	0	\N	\N
1916	1112	463	2	9756	\N	9756	\N	\N	2	1	2	f	0	\N	\N
1917	1511	463	2	4932	\N	4932	\N	\N	3	1	2	f	0	\N	\N
1918	748	463	2	229	\N	229	\N	\N	4	1	2	f	0	\N	\N
1919	1118	463	2	74	\N	74	\N	\N	5	1	2	f	0	\N	\N
1920	27	463	2	50	\N	50	\N	\N	6	1	2	f	0	\N	\N
1921	28	463	2	39	\N	39	\N	\N	7	1	2	f	0	\N	\N
1922	26	463	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1923	1120	463	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1924	1136	463	1	39767	\N	39767	\N	\N	1	1	2	f	\N	\N	\N
1925	1327	463	1	24394	\N	24394	\N	\N	2	1	2	f	\N	\N	\N
1926	748	463	1	2012	\N	2012	\N	\N	3	1	2	f	\N	\N	\N
1927	757	463	1	2008	\N	2008	\N	\N	4	1	2	f	\N	\N	\N
1928	1139	463	1	2008	\N	2008	\N	\N	5	1	2	f	\N	\N	\N
1929	1140	463	1	2008	\N	2008	\N	\N	6	1	2	f	\N	\N	\N
1930	1112	463	1	2008	\N	2008	\N	\N	7	1	2	f	\N	\N	\N
1931	1511	463	1	1647	\N	1647	\N	\N	8	1	2	f	\N	\N	\N
1932	302	463	1	1440	\N	1440	\N	\N	9	1	2	f	\N	\N	\N
1933	1118	463	1	85	\N	85	\N	\N	10	1	2	f	\N	\N	\N
1934	959	463	1	78	\N	78	\N	\N	11	1	2	f	\N	\N	\N
1935	26	463	1	57	\N	57	\N	\N	12	1	2	f	\N	\N	\N
1936	1331	463	1	50	\N	50	\N	\N	13	1	2	f	\N	\N	\N
1937	28	463	1	39	\N	39	\N	\N	14	1	2	f	\N	\N	\N
1938	1328	463	1	16	\N	16	\N	\N	15	1	2	f	\N	\N	\N
1939	474	463	1	8	\N	8	\N	\N	16	1	2	f	\N	\N	\N
1940	475	463	1	8	\N	8	\N	\N	17	1	2	f	\N	\N	\N
1941	45	463	1	7	\N	7	\N	\N	18	1	2	f	\N	\N	\N
1942	956	463	1	5	\N	5	\N	\N	19	1	2	f	\N	\N	\N
1943	958	463	1	3	\N	3	\N	\N	20	1	2	f	\N	\N	\N
1944	749	463	1	434	\N	434	\N	\N	0	1	2	f	\N	\N	\N
1945	750	463	1	282	\N	282	\N	\N	0	1	2	f	\N	\N	\N
1946	751	463	1	274	\N	274	\N	\N	0	1	2	f	\N	\N	\N
1947	1124	463	1	162	\N	162	\N	\N	0	1	2	f	\N	\N	\N
1948	1123	463	1	98	\N	98	\N	\N	0	1	2	f	\N	\N	\N
1949	27	463	1	56	\N	56	\N	\N	0	1	2	f	\N	\N	\N
1950	1143	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1951	280	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1952	769	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1953	315	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1954	1186	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1955	1187	463	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1956	353	463	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
1957	461	463	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
1958	83	463	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
1959	761	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1960	765	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1961	306	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1962	1253	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1963	395	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1964	409	463	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1965	273	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1966	301	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1967	1181	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1968	794	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1969	1231	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1970	426	463	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
1971	264	463	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1972	1119	463	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1973	1120	463	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
1974	746	463	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1975	262	463	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1976	1121	463	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1977	263	463	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1978	1117	464	2	1111	\N	1111	\N	\N	1	1	2	f	0	\N	\N
1979	1117	464	1	1111	\N	1111	\N	\N	1	1	2	f	\N	\N	\N
1980	1117	465	2	7534	\N	7534	\N	\N	1	1	2	f	0	\N	\N
1981	1117	465	1	7534	\N	7534	\N	\N	1	1	2	f	\N	\N	\N
1982	740	466	2	130773	\N	0	\N	\N	1	1	2	f	130773	\N	\N
1983	1136	467	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
1984	1117	468	2	142814	\N	0	\N	\N	1	1	2	f	142814	\N	\N
1985	1511	468	2	1016	\N	0	\N	\N	2	1	2	f	1016	\N	\N
1986	1118	468	2	352	\N	0	\N	\N	3	1	2	f	352	\N	\N
1987	958	468	2	134	\N	0	\N	\N	4	1	2	f	134	\N	\N
1988	959	468	2	55	\N	0	\N	\N	5	1	2	f	55	\N	\N
1989	956	468	2	43	\N	0	\N	\N	6	1	2	f	43	\N	\N
1990	264	468	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1991	1119	468	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
1992	262	468	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1993	263	468	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1994	746	468	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1995	1120	468	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1996	476	469	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1997	257	469	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1998	228	470	2	386552	\N	10	\N	\N	1	1	2	f	386542	\N	\N
1999	1109	470	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2000	740	470	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2001	1117	471	2	211	\N	211	\N	\N	1	1	2	f	0	\N	\N
2002	1117	471	1	10436	\N	10436	\N	\N	1	1	2	f	\N	\N	\N
2003	1118	472	2	14757	\N	0	\N	\N	1	1	2	f	14757	\N	\N
2004	1511	472	2	875	\N	0	\N	\N	2	1	2	f	875	\N	\N
2005	958	472	2	175	\N	0	\N	\N	3	1	2	f	175	\N	\N
2006	959	472	2	49	\N	0	\N	\N	4	1	2	f	49	\N	\N
2007	956	472	2	40	\N	0	\N	\N	5	1	2	f	40	\N	\N
2008	1119	472	2	2821	\N	0	\N	\N	0	1	2	f	2821	\N	\N
2009	262	472	2	852	\N	0	\N	\N	0	1	2	f	852	\N	\N
2010	746	472	2	468	\N	0	\N	\N	0	1	2	f	468	\N	\N
2011	1120	472	2	389	\N	0	\N	\N	0	1	2	f	389	\N	\N
2012	263	472	2	353	\N	0	\N	\N	0	1	2	f	353	\N	\N
2013	1121	472	2	190	\N	0	\N	\N	0	1	2	f	190	\N	\N
2014	264	472	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
2015	1730	473	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
2016	907	473	1	50	\N	50	\N	\N	1	1	2	f	\N	\N	\N
2017	915	473	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
2018	1332	473	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2019	28	474	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
2020	1118	475	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
2021	28	475	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
2022	1119	475	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
2023	262	475	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
2024	746	475	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
2025	1120	475	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
2026	263	475	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
2027	1121	475	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
2028	264	475	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
2029	1118	476	2	267	\N	0	\N	\N	1	1	2	f	267	\N	\N
2030	1119	476	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2031	264	476	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2032	263	476	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2033	748	477	2	16846	\N	16846	\N	\N	1	1	2	f	0	\N	\N
2034	749	477	2	2982	\N	2982	\N	\N	0	1	2	f	0	\N	\N
2035	750	477	2	1070	\N	1070	\N	\N	0	1	2	f	0	\N	\N
2036	751	477	2	902	\N	902	\N	\N	0	1	2	f	0	\N	\N
2037	1124	477	2	635	\N	635	\N	\N	0	1	2	f	0	\N	\N
2038	1123	477	2	496	\N	496	\N	\N	0	1	2	f	0	\N	\N
2039	1117	478	2	31	\N	31	\N	\N	1	1	2	f	0	\N	\N
2040	1117	478	1	31	\N	31	\N	\N	1	1	2	f	\N	\N	\N
2041	1117	479	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
2042	1117	479	1	44	\N	44	\N	\N	1	1	2	f	\N	\N	\N
2043	907	480	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2044	907	480	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2045	1117	481	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2046	1117	481	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
2047	1125	484	2	415	\N	415	\N	\N	1	1	2	f	0	\N	\N
2048	257	484	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2049	1136	484	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
2050	907	485	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
2051	1332	485	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2052	1117	486	2	1952	\N	0	\N	\N	1	1	2	f	1952	\N	\N
2053	28	487	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
2054	1118	487	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
2055	1120	487	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2056	1109	489	2	588	\N	588	\N	\N	1	1	2	f	0	\N	\N
2057	740	489	1	473	\N	473	\N	\N	1	1	2	f	\N	\N	\N
2058	1109	489	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2059	1730	491	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
2060	1844	491	1	51	\N	51	\N	\N	1	1	2	f	\N	\N	\N
2061	740	493	2	255	\N	0	\N	\N	1	1	2	f	255	\N	\N
2062	1730	494	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
2063	1844	494	1	57	\N	57	\N	\N	1	1	2	f	\N	\N	\N
2064	27	496	2	47	\N	47	\N	\N	1	1	2	f	0	\N	\N
2065	28	496	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
2066	1118	496	2	11	\N	11	\N	\N	3	1	2	f	0	\N	\N
2067	26	496	2	47	\N	47	\N	\N	0	1	2	f	0	\N	\N
2068	1120	496	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2069	736	497	2	17680	\N	17680	\N	\N	1	1	2	f	0	\N	\N
2070	736	497	1	17680	\N	17680	\N	\N	1	1	2	f	\N	\N	\N
2071	907	498	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
2072	907	498	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
2073	1332	498	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2074	1360	499	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
2075	1118	500	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
2076	1511	500	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
2077	958	500	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
2078	959	500	2	78	\N	78	\N	\N	4	1	2	f	0	\N	\N
2079	956	500	2	50	\N	50	\N	\N	5	1	2	f	0	\N	\N
2080	1119	500	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
2081	262	500	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
2082	746	500	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
2083	1120	500	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
2084	263	500	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
2085	1121	500	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
2086	264	500	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
2087	1136	500	1	18878	\N	18878	\N	\N	1	1	2	f	\N	\N	\N
2088	1117	501	2	319771	\N	319771	\N	\N	1	1	2	f	0	\N	\N
2089	479	501	2	27	\N	27	\N	\N	2	1	2	f	0	\N	\N
2090	261	501	2	285862	\N	285862	\N	\N	0	1	2	f	0	\N	\N
2091	740	501	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2092	478	501	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2093	1117	501	1	319778	\N	319778	\N	\N	1	1	2	f	\N	\N	\N
2094	479	501	1	27	\N	27	\N	\N	2	1	2	f	\N	\N	\N
2095	261	501	1	285862	\N	285862	\N	\N	0	1	2	f	\N	\N	\N
2096	740	501	1	27	\N	27	\N	\N	0	1	2	f	\N	\N	\N
2097	478	501	1	27	\N	27	\N	\N	0	1	2	f	\N	\N	\N
2098	27	502	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
2099	26	502	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2100	740	504	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
2101	476	505	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2102	257	505	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2103	1117	505	1	194	\N	194	\N	\N	1	1	2	f	\N	\N	\N
2104	261	505	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2105	261	507	2	44224	\N	0	\N	\N	1	1	2	f	44224	\N	\N
2106	740	507	2	16632	\N	0	\N	\N	2	1	2	f	16632	\N	\N
2107	1117	507	2	44224	\N	0	\N	\N	0	1	2	f	44224	\N	\N
2108	261	508	2	423	\N	0	\N	\N	1	1	2	f	423	\N	\N
2109	740	508	2	406	\N	0	\N	\N	2	1	2	f	406	\N	\N
2110	1117	508	2	423	\N	0	\N	\N	0	1	2	f	423	\N	\N
2111	57	509	2	50216	\N	0	\N	\N	1	1	2	f	50216	\N	\N
2112	476	509	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2113	257	509	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2114	476	510	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2115	742	511	2	35061	\N	0	\N	\N	1	1	2	f	35061	\N	\N
2116	260	511	2	140	\N	0	\N	\N	2	1	2	f	140	\N	\N
2117	1114	511	2	101	\N	0	\N	\N	3	1	2	f	101	\N	\N
2118	1116	511	2	90	\N	0	\N	\N	4	1	2	f	90	\N	\N
2119	744	511	2	18	\N	0	\N	\N	5	1	2	f	18	\N	\N
2120	1115	511	2	17	\N	0	\N	\N	6	1	2	f	17	\N	\N
2121	27	513	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
2122	26	513	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2123	1118	514	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
2124	1119	514	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2125	746	514	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2126	262	514	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2127	1121	514	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2128	1120	514	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2129	263	514	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2130	257	515	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2131	476	515	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2132	1170	516	2	117095	\N	117095	\N	\N	1	1	2	f	0	\N	\N
2133	303	516	2	117052	\N	117052	\N	\N	0	1	2	f	0	\N	\N
2134	1171	516	2	37	\N	37	\N	\N	0	1	2	f	0	\N	\N
2135	748	516	1	117095	\N	117095	\N	\N	1	1	2	f	\N	\N	\N
2136	749	516	1	14228	\N	14228	\N	\N	0	1	2	f	\N	\N	\N
2137	750	516	1	4131	\N	4131	\N	\N	0	1	2	f	\N	\N	\N
2138	1123	516	1	3210	\N	3210	\N	\N	0	1	2	f	\N	\N	\N
2139	1124	516	1	2899	\N	2899	\N	\N	0	1	2	f	\N	\N	\N
2140	751	516	1	2475	\N	2475	\N	\N	0	1	2	f	\N	\N	\N
2141	740	517	2	285855	\N	0	\N	\N	1	1	2	f	285855	\N	\N
2142	1117	518	2	657610	\N	0	\N	\N	1	1	2	f	657610	\N	\N
2143	740	518	2	552710	\N	0	\N	\N	2	1	2	f	552710	\N	\N
2144	1136	518	2	19882	\N	0	\N	\N	3	1	2	f	19882	\N	\N
2145	1118	518	2	18878	\N	0	\N	\N	4	1	2	f	18878	\N	\N
2146	1511	518	2	1644	\N	0	\N	\N	5	1	2	f	1644	\N	\N
2147	1139	518	2	1004	\N	0	\N	\N	6	1	2	f	1004	\N	\N
2148	1112	518	2	1004	\N	0	\N	\N	7	1	2	f	1004	\N	\N
2149	302	518	2	224	\N	0	\N	\N	8	1	2	f	224	\N	\N
2150	958	518	2	217	\N	0	\N	\N	9	1	2	f	217	\N	\N
2151	959	518	2	78	\N	0	\N	\N	10	1	2	f	78	\N	\N
2152	956	518	2	50	\N	0	\N	\N	11	1	2	f	50	\N	\N
2153	27	518	2	39	\N	0	\N	\N	12	1	2	f	39	\N	\N
2154	476	518	2	1	\N	0	\N	\N	13	1	2	f	1	\N	\N
2155	261	518	2	657609	\N	0	\N	\N	0	1	2	f	657609	\N	\N
2156	1119	518	2	2896	\N	0	\N	\N	0	1	2	f	2896	\N	\N
2157	262	518	2	873	\N	0	\N	\N	0	1	2	f	873	\N	\N
2158	746	518	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
2159	1120	518	2	402	\N	0	\N	\N	0	1	2	f	402	\N	\N
2160	263	518	2	365	\N	0	\N	\N	0	1	2	f	365	\N	\N
2161	1121	518	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
2162	264	518	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
2163	26	518	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2164	315	518	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2165	1187	518	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2166	353	518	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2167	761	518	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2168	765	518	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2169	273	518	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2170	1231	518	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2171	257	518	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2172	476	519	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
2173	257	519	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2174	978	519	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
2175	907	520	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
2176	1332	520	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2177	907	520	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
2178	1332	520	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2179	1118	521	2	9144	\N	0	\N	\N	1	1	2	f	9144	\N	\N
2180	264	521	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
2181	1119	521	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
2182	1120	521	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
2183	746	521	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2184	1121	521	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2185	263	521	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2186	1118	522	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
2187	1118	522	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2188	264	522	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
2189	748	523	1	126290	\N	126290	\N	\N	1	1	2	f	\N	\N	\N
2190	749	523	1	82368	\N	82368	\N	\N	2	1	2	f	\N	\N	\N
2191	750	523	1	11360	\N	11360	\N	\N	3	1	2	f	\N	\N	\N
2192	751	523	1	9768	\N	9768	\N	\N	4	1	2	f	\N	\N	\N
2193	1123	523	1	24436	\N	24436	\N	\N	0	1	2	f	\N	\N	\N
2194	1124	523	1	10295	\N	10295	\N	\N	0	1	2	f	\N	\N	\N
2195	1360	524	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
2196	476	524	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2197	257	524	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2198	261	525	2	1203	\N	0	\N	\N	1	1	2	f	1203	\N	\N
2199	740	525	2	1137	\N	0	\N	\N	2	1	2	f	1137	\N	\N
2200	1117	525	2	1203	\N	0	\N	\N	0	1	2	f	1203	\N	\N
2201	1536	526	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2202	748	527	2	116505	\N	0	\N	\N	1	1	2	f	116505	\N	\N
2203	757	527	2	1004	\N	0	\N	\N	2	1	2	f	1004	\N	\N
2204	1139	527	2	1004	\N	0	\N	\N	3	1	2	f	1004	\N	\N
2205	1140	527	2	1004	\N	0	\N	\N	4	1	2	f	1004	\N	\N
2206	749	527	2	14184	\N	0	\N	\N	0	1	2	f	14184	\N	\N
2207	750	527	2	4126	\N	0	\N	\N	0	1	2	f	4126	\N	\N
2208	1123	527	2	3202	\N	0	\N	\N	0	1	2	f	3202	\N	\N
2209	1124	527	2	2891	\N	0	\N	\N	0	1	2	f	2891	\N	\N
2210	751	527	2	2466	\N	0	\N	\N	0	1	2	f	2466	\N	\N
2211	1143	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2212	280	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2213	769	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2214	315	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2215	1186	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2216	1187	527	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2217	353	527	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2218	461	527	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2219	83	527	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2220	761	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2221	765	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2222	306	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2223	1253	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2224	395	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2225	409	527	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2226	273	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2227	301	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2228	1181	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2229	794	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2230	1231	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2231	426	527	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2232	1117	528	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2233	1117	528	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2234	907	529	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2235	257	529	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2236	28	530	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
2237	1118	530	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
2238	1120	530	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2239	27	530	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
2240	26	530	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
2241	1117	531	2	28	\N	28	\N	\N	1	1	2	f	0	\N	\N
2242	1117	531	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
2243	478	532	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2244	907	532	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2245	1117	533	2	202231	\N	202231	\N	\N	1	1	2	f	0	\N	\N
2246	261	533	2	163038	\N	163038	\N	\N	0	1	2	f	0	\N	\N
2247	979	533	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
2248	1117	533	1	38970	\N	38970	\N	\N	1	1	2	f	\N	\N	\N
2249	740	533	1	77	\N	77	\N	\N	2	1	2	f	\N	\N	\N
2250	1333	533	1	37	\N	37	\N	\N	3	1	2	f	\N	\N	\N
2251	478	533	1	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
2252	479	533	1	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
2253	1757	534	2	318899	\N	318899	\N	\N	1	1	2	f	0	\N	\N
2254	1538	534	2	231562	\N	231562	\N	\N	2	1	2	f	0	\N	\N
2255	691	534	2	220129	\N	220129	\N	\N	3	1	2	f	0	\N	\N
2256	736	534	2	33204	\N	33204	\N	\N	4	1	2	f	0	\N	\N
2257	1125	534	2	474	\N	474	\N	\N	5	1	2	f	0	\N	\N
2258	1118	534	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
2259	748	534	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
2260	741	534	1	583605	\N	583605	\N	\N	1	1	2	f	\N	\N	\N
2261	1113	534	1	433211	\N	433211	\N	\N	2	1	2	f	\N	\N	\N
2262	1136	534	1	28	\N	28	\N	\N	3	1	2	f	\N	\N	\N
2263	1112	534	1	583605	\N	583605	\N	\N	0	1	2	f	\N	\N	\N
2264	1117	535	2	1376	\N	1376	\N	\N	1	1	2	f	0	\N	\N
2265	1117	535	1	1376	\N	1376	\N	\N	1	1	2	f	\N	\N	\N
2266	1536	536	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
2267	1454	536	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
2268	476	537	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2269	257	537	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2270	1118	538	2	126908	\N	126908	\N	\N	1	1	2	f	0	\N	\N
2271	1119	538	2	82473	\N	82473	\N	\N	0	1	2	f	0	\N	\N
2272	262	538	2	24445	\N	24445	\N	\N	0	1	2	f	0	\N	\N
2273	746	538	2	11416	\N	11416	\N	\N	0	1	2	f	0	\N	\N
2274	263	538	2	10290	\N	10290	\N	\N	0	1	2	f	0	\N	\N
2275	1120	538	2	9823	\N	9823	\N	\N	0	1	2	f	0	\N	\N
2276	1121	538	2	4122	\N	4122	\N	\N	0	1	2	f	0	\N	\N
2277	1118	539	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
2278	264	539	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2279	748	540	1	107755	\N	107755	\N	\N	1	1	2	f	\N	\N	\N
2280	749	540	1	52137	\N	52137	\N	\N	2	1	2	f	\N	\N	\N
2281	750	540	1	9811	\N	9811	\N	\N	3	1	2	f	\N	\N	\N
2282	751	540	1	6950	\N	6950	\N	\N	4	1	2	f	\N	\N	\N
2283	1123	540	1	15247	\N	15247	\N	\N	0	1	2	f	\N	\N	\N
2284	1124	540	1	7331	\N	7331	\N	\N	0	1	2	f	\N	\N	\N
2285	476	541	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2286	257	541	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2287	740	542	2	2074042	\N	2074042	\N	\N	1	1	2	f	0	\N	\N
2288	1109	542	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2289	738	542	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
2290	740	542	1	2073673	\N	2073673	\N	\N	1	1	2	f	\N	\N	\N
2291	1109	542	1	381	\N	381	\N	\N	2	1	2	f	\N	\N	\N
2292	738	542	1	52	\N	52	\N	\N	0	1	2	f	\N	\N	\N
2293	1118	543	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
2294	1120	543	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2295	1109	544	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
2296	1117	545	2	657610	\N	0	\N	\N	1	1	2	f	657610	\N	\N
2297	261	545	2	657609	\N	0	\N	\N	0	1	2	f	657609	\N	\N
2298	1117	547	2	35	\N	35	\N	\N	1	1	2	f	0	\N	\N
2299	1111	548	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
2300	1110	548	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
2301	907	548	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
2302	1111	548	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2303	1110	548	1	17	\N	17	\N	\N	2	1	2	f	\N	\N	\N
2304	907	548	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
2305	256	548	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2306	740	549	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2307	740	550	2	220789	\N	0	\N	\N	1	1	2	f	220789	\N	\N
2308	921	551	2	41092	\N	41092	\N	\N	1	1	2	f	0	\N	\N
2309	481	551	2	41092	\N	41092	\N	\N	0	1	2	f	0	\N	\N
2310	740	551	1	36892	\N	36892	\N	\N	1	1	2	f	\N	\N	\N
2311	33	552	2	609	\N	0	\N	\N	1	1	2	f	609	\N	\N
2312	35	552	2	369	\N	0	\N	\N	2	1	2	f	369	\N	\N
2313	1333	552	2	61	\N	0	\N	\N	3	1	2	f	61	\N	\N
2314	34	552	2	52	\N	0	\N	\N	4	1	2	f	52	\N	\N
2315	964	552	2	38	\N	0	\N	\N	5	1	2	f	38	\N	\N
2316	740	552	2	38	\N	0	\N	\N	6	1	2	f	38	\N	\N
2317	36	552	2	26	\N	0	\N	\N	7	1	2	f	26	\N	\N
2318	963	552	2	24	\N	0	\N	\N	8	1	2	f	24	\N	\N
2319	37	552	2	22	\N	0	\N	\N	9	1	2	f	22	\N	\N
2320	1842	552	2	21	\N	0	\N	\N	10	1	2	f	21	\N	\N
2321	961	552	2	16	\N	0	\N	\N	11	1	2	f	16	\N	\N
2322	41	552	2	15	\N	0	\N	\N	12	1	2	f	15	\N	\N
2323	30	552	2	12	\N	0	\N	\N	13	1	2	f	12	\N	\N
2324	1775	552	2	10	\N	0	\N	\N	14	1	2	f	10	\N	\N
2325	261	553	2	153892	\N	0	\N	\N	1	1	2	f	153892	\N	\N
2326	740	553	2	98727	\N	0	\N	\N	2	1	2	f	98727	\N	\N
2327	1117	553	2	153892	\N	0	\N	\N	0	1	2	f	153892	\N	\N
2328	476	554	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2329	257	554	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2330	978	555	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2331	476	555	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2332	1117	556	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
2333	1117	556	1	49	\N	49	\N	\N	1	1	2	f	\N	\N	\N
2334	261	557	2	371746	\N	371746	\N	\N	1	1	2	f	0	\N	\N
2335	1117	557	2	371746	\N	371746	\N	\N	0	1	2	f	0	\N	\N
2336	740	557	1	371746	\N	371746	\N	\N	1	1	2	f	\N	\N	\N
2337	1118	558	2	11362	\N	0	\N	\N	1	1	2	f	11362	\N	\N
2338	1511	558	2	1016	\N	0	\N	\N	2	1	2	f	1016	\N	\N
2339	958	558	2	134	\N	0	\N	\N	3	1	2	f	134	\N	\N
2340	959	558	2	55	\N	0	\N	\N	4	1	2	f	55	\N	\N
2341	956	558	2	43	\N	0	\N	\N	5	1	2	f	43	\N	\N
2342	1119	558	2	2887	\N	0	\N	\N	0	1	2	f	2887	\N	\N
2343	262	558	2	869	\N	0	\N	\N	0	1	2	f	869	\N	\N
2344	746	558	2	481	\N	0	\N	\N	0	1	2	f	481	\N	\N
2345	1120	558	2	400	\N	0	\N	\N	0	1	2	f	400	\N	\N
2346	263	558	2	364	\N	0	\N	\N	0	1	2	f	364	\N	\N
2347	1121	558	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
2348	264	558	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
2349	1117	559	2	530	\N	530	\N	\N	1	1	2	f	0	\N	\N
2350	1117	559	1	530	\N	530	\N	\N	1	1	2	f	\N	\N	\N
2351	740	560	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2352	257	561	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2353	476	561	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2354	740	562	2	1559	\N	0	\N	\N	1	1	2	f	1559	\N	\N
2355	1118	564	2	34189	\N	34189	\N	\N	1	1	2	f	0	\N	\N
2356	1511	564	2	6746	\N	6746	\N	\N	2	1	2	f	0	\N	\N
2357	748	564	2	557	\N	557	\N	\N	3	1	2	f	0	\N	\N
2358	958	564	2	378	\N	378	\N	\N	4	1	2	f	0	\N	\N
2359	959	564	2	197	\N	197	\N	\N	5	1	2	f	0	\N	\N
2360	956	564	2	87	\N	87	\N	\N	6	1	2	f	0	\N	\N
2361	28	564	2	65	\N	65	\N	\N	7	1	2	f	0	\N	\N
2362	907	564	2	58	\N	36	\N	\N	8	1	2	f	22	\N	\N
2363	27	564	2	42	\N	42	\N	\N	9	1	2	f	0	\N	\N
2364	257	564	2	26	\N	26	\N	\N	10	1	2	f	0	\N	\N
2365	1111	564	2	18	\N	17	\N	\N	11	1	2	f	1	\N	\N
2366	228	564	2	1	\N	1	\N	\N	12	1	2	f	0	\N	\N
2367	740	564	2	1	\N	0	\N	\N	13	1	2	f	1	\N	\N
2368	1119	564	2	5296	\N	5296	\N	\N	0	1	2	f	0	\N	\N
2369	262	564	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
2370	746	564	2	1006	\N	1006	\N	\N	0	1	2	f	0	\N	\N
2371	1120	564	2	953	\N	953	\N	\N	0	1	2	f	0	\N	\N
2372	263	564	2	587	\N	587	\N	\N	0	1	2	f	0	\N	\N
2373	1121	564	2	376	\N	376	\N	\N	0	1	2	f	0	\N	\N
2374	264	564	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
2375	26	564	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
2376	914	564	2	7	\N	3	\N	\N	0	1	2	f	4	\N	\N
2377	1331	564	1	12588	\N	12588	\N	\N	1	1	2	f	\N	\N	\N
2378	913	564	1	1450	\N	1450	\N	\N	2	1	2	f	\N	\N	\N
2379	1327	564	1	1450	\N	1450	\N	\N	3	1	2	f	\N	\N	\N
2380	45	564	1	13	\N	13	\N	\N	4	1	2	f	\N	\N	\N
2381	475	564	1	8	\N	8	\N	\N	5	1	2	f	\N	\N	\N
2382	1136	564	1	8	\N	8	\N	\N	6	1	2	f	\N	\N	\N
2383	1328	564	1	7	\N	7	\N	\N	7	1	2	f	\N	\N	\N
2384	256	564	1	5	\N	5	\N	\N	8	1	2	f	\N	\N	\N
2385	907	564	1	5	\N	5	\N	\N	9	1	2	f	\N	\N	\N
2386	1117	566	2	181	\N	181	\N	\N	1	1	2	f	0	\N	\N
2387	1117	566	1	181	\N	181	\N	\N	1	1	2	f	\N	\N	\N
2388	1118	567	1	65690	\N	65690	\N	\N	1	1	2	f	\N	\N	\N
2389	1119	567	1	42430	\N	42430	\N	\N	0	1	2	f	\N	\N	\N
2390	262	567	1	13427	\N	13427	\N	\N	0	1	2	f	\N	\N	\N
2391	746	567	1	6234	\N	6234	\N	\N	0	1	2	f	\N	\N	\N
2392	1120	567	1	4948	\N	4948	\N	\N	0	1	2	f	\N	\N	\N
2393	263	567	1	4929	\N	4929	\N	\N	0	1	2	f	\N	\N	\N
2394	1121	567	1	2509	\N	2509	\N	\N	0	1	2	f	\N	\N	\N
2395	1117	568	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
2396	1117	568	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
2397	736	569	2	9381	\N	9381	\N	\N	1	1	2	f	0	\N	\N
2398	736	569	1	9381	\N	9381	\N	\N	1	1	2	f	\N	\N	\N
2399	740	570	2	64748	\N	3	\N	\N	1	1	2	f	64745	\N	\N
2400	907	570	2	9	\N	0	\N	\N	2	1	2	f	9	\N	\N
2401	1111	570	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
2402	914	570	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2403	27	571	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
2404	26	571	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
2405	1536	572	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
2406	1454	572	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
2407	1118	573	1	24801	\N	24801	\N	\N	1	1	2	f	\N	\N	\N
2408	1119	573	1	9264	\N	9264	\N	\N	0	1	2	f	\N	\N	\N
2409	262	573	1	2810	\N	2810	\N	\N	0	1	2	f	\N	\N	\N
2410	746	573	1	1364	\N	1364	\N	\N	0	1	2	f	\N	\N	\N
2411	1120	573	1	1152	\N	1152	\N	\N	0	1	2	f	\N	\N	\N
2412	263	573	1	1124	\N	1124	\N	\N	0	1	2	f	\N	\N	\N
2413	1121	573	1	556	\N	556	\N	\N	0	1	2	f	\N	\N	\N
2414	264	573	1	208	\N	208	\N	\N	0	1	2	f	\N	\N	\N
2415	256	574	2	177	\N	177	\N	\N	1	1	2	f	0	\N	\N
2416	738	574	1	122	\N	122	\N	\N	0	1	2	f	\N	\N	\N
2417	1117	575	2	187	\N	187	\N	\N	1	1	2	f	0	\N	\N
2418	1117	575	1	187	\N	187	\N	\N	1	1	2	f	\N	\N	\N
2419	1118	576	2	18878	\N	18878	\N	\N	1	1	2	f	0	\N	\N
2420	1511	576	2	1644	\N	1644	\N	\N	2	1	2	f	0	\N	\N
2421	958	576	2	217	\N	217	\N	\N	3	1	2	f	0	\N	\N
2422	959	576	2	78	\N	78	\N	\N	4	1	2	f	0	\N	\N
2423	956	576	2	50	\N	50	\N	\N	5	1	2	f	0	\N	\N
2424	1119	576	2	2896	\N	2896	\N	\N	0	1	2	f	0	\N	\N
2425	262	576	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
2426	746	576	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
2427	1120	576	2	402	\N	402	\N	\N	0	1	2	f	0	\N	\N
2428	263	576	2	365	\N	365	\N	\N	0	1	2	f	0	\N	\N
2429	1121	576	2	192	\N	192	\N	\N	0	1	2	f	0	\N	\N
2430	264	576	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
2431	1511	576	1	18878	\N	18878	\N	\N	1	1	2	f	\N	\N	\N
2432	958	576	1	1606	\N	1606	\N	\N	2	1	2	f	\N	\N	\N
2433	956	576	1	217	\N	217	\N	\N	3	1	2	f	\N	\N	\N
2434	959	576	1	49	\N	49	\N	\N	4	1	2	f	\N	\N	\N
2435	1118	577	2	90035	\N	90035	\N	\N	1	1	2	f	0	\N	\N
2436	1511	577	2	5191	\N	5191	\N	\N	2	1	2	f	0	\N	\N
2437	958	577	2	689	\N	689	\N	\N	3	1	2	f	0	\N	\N
2438	959	577	2	250	\N	250	\N	\N	4	1	2	f	0	\N	\N
2439	956	577	2	243	\N	243	\N	\N	5	1	2	f	0	\N	\N
2440	27	577	2	78	\N	78	\N	\N	6	1	2	f	0	\N	\N
2441	28	577	2	26	\N	26	\N	\N	7	1	2	f	0	\N	\N
2442	1119	577	2	13902	\N	13902	\N	\N	0	1	2	f	0	\N	\N
2443	262	577	2	3961	\N	3961	\N	\N	0	1	2	f	0	\N	\N
2444	746	577	2	2459	\N	2459	\N	\N	0	1	2	f	0	\N	\N
2445	1120	577	2	2174	\N	2174	\N	\N	0	1	2	f	0	\N	\N
2446	263	577	2	1722	\N	1722	\N	\N	0	1	2	f	0	\N	\N
2447	1121	577	2	947	\N	947	\N	\N	0	1	2	f	0	\N	\N
2448	264	577	2	335	\N	335	\N	\N	0	1	2	f	0	\N	\N
2449	26	577	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
2450	1136	577	1	18900	\N	18900	\N	\N	1	1	2	f	\N	\N	\N
2451	1330	577	1	3833	\N	3833	\N	\N	2	1	2	f	\N	\N	\N
2452	1117	578	2	122	\N	122	\N	\N	1	1	2	f	0	\N	\N
2453	1117	578	1	122	\N	122	\N	\N	1	1	2	f	\N	\N	\N
2454	1125	579	2	415	\N	415	\N	\N	1	1	2	f	0	\N	\N
2455	302	580	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
2456	740	582	2	271958	\N	0	\N	\N	1	1	2	f	271958	\N	\N
2457	978	584	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2458	476	584	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2459	257	584	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2460	257	591	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2461	476	591	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2462	261	592	2	46664	\N	0	\N	\N	1	1	2	f	46664	\N	\N
2463	740	592	2	11838	\N	0	\N	\N	2	1	2	f	11838	\N	\N
2464	1117	592	2	46664	\N	0	\N	\N	0	1	2	f	46664	\N	\N
2465	1117	594	2	502	\N	502	\N	\N	1	1	2	f	0	\N	\N
2466	1117	594	1	502	\N	502	\N	\N	1	1	2	f	\N	\N	\N
2467	1139	595	2	720	\N	0	\N	\N	1	1	2	f	720	\N	\N
2468	302	595	2	224	\N	0	\N	\N	2	1	2	f	224	\N	\N
2469	27	595	2	39	\N	0	\N	\N	3	1	2	f	39	\N	\N
2470	28	595	2	13	\N	0	\N	\N	4	1	2	f	13	\N	\N
2471	26	595	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2472	1187	595	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
2473	761	595	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2474	1231	595	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2475	765	595	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2476	353	595	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2477	273	595	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2478	315	595	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2479	740	596	2	293855	\N	0	\N	\N	1	1	2	f	293855	\N	\N
2480	1117	597	1	577843	\N	577843	\N	\N	1	1	2	f	\N	\N	\N
2481	1117	598	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2482	1117	598	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2483	1118	599	2	65	\N	65	\N	\N	1	1	2	f	0	\N	\N
2484	264	599	1	65	\N	65	\N	\N	1	1	2	f	\N	\N	\N
2485	1118	599	1	65	\N	65	\N	\N	0	1	2	f	\N	\N	\N
2486	1109	600	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2487	740	600	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2488	740	601	2	56706	\N	56706	\N	\N	1	1	2	f	0	\N	\N
2489	748	601	2	769	\N	769	\N	\N	2	1	2	f	0	\N	\N
2490	757	601	2	354	\N	354	\N	\N	3	1	2	f	0	\N	\N
2491	1140	601	2	354	\N	354	\N	\N	4	1	2	f	0	\N	\N
2492	1139	601	2	354	\N	354	\N	\N	5	1	2	f	0	\N	\N
2493	1118	601	2	63	\N	63	\N	\N	6	1	2	f	0	\N	\N
2494	1117	601	2	59	\N	59	\N	\N	7	1	2	f	0	\N	\N
2495	749	601	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
2496	751	601	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
2497	750	601	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
2498	1124	601	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
2499	1123	601	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2500	1143	601	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2501	280	601	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2502	315	601	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2503	761	601	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2504	306	601	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2505	409	601	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2506	765	601	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2507	1253	601	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2508	395	601	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2509	273	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2510	1181	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2511	794	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2512	461	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2513	83	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2514	353	601	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2515	769	601	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2516	1186	601	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2517	1187	601	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2518	301	601	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2519	426	601	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2520	1231	601	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2521	1125	601	1	474	\N	474	\N	\N	1	1	2	f	\N	\N	\N
2522	1328	601	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2523	737	602	2	2365569	\N	2365569	\N	\N	1	1	2	f	0	\N	\N
2524	736	603	2	648800	\N	0	\N	\N	1	1	2	f	648800	\N	\N
2525	1117	603	2	32707	\N	0	\N	\N	2	1	2	f	32707	\N	\N
2526	1139	603	2	1004	\N	0	\N	\N	3	1	2	f	1004	\N	\N
2527	1112	603	2	1004	\N	0	\N	\N	4	1	2	f	1004	\N	\N
2528	1136	603	2	1004	\N	0	\N	\N	5	1	2	f	1004	\N	\N
2529	302	603	2	224	\N	0	\N	\N	6	1	2	f	224	\N	\N
2530	1125	603	2	59	\N	0	\N	\N	7	1	2	f	59	\N	\N
2531	27	603	2	39	\N	0	\N	\N	8	1	2	f	39	\N	\N
2532	28	603	2	13	\N	0	\N	\N	9	1	2	f	13	\N	\N
2533	476	603	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
2534	26	603	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2535	315	603	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2536	1187	603	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2537	353	603	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2538	761	603	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2539	765	603	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2540	273	603	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2541	1231	603	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2542	257	603	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2543	28	604	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
2544	1117	605	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
2545	1117	605	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
2546	476	606	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2547	257	606	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2548	1117	606	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2549	261	606	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2550	748	607	2	126334	\N	126334	\N	\N	1	1	2	f	0	\N	\N
2551	749	607	2	82412	\N	82412	\N	\N	2	1	2	f	0	\N	\N
2552	750	607	2	11355	\N	11355	\N	\N	3	1	2	f	0	\N	\N
2553	751	607	2	9762	\N	9762	\N	\N	4	1	2	f	0	\N	\N
2554	1123	607	2	24445	\N	24445	\N	\N	0	1	2	f	0	\N	\N
2555	1124	607	2	10290	\N	10290	\N	\N	0	1	2	f	0	\N	\N
2556	921	608	2	41100	\N	41100	\N	\N	1	1	2	f	0	\N	\N
2557	481	608	2	41100	\N	41100	\N	\N	0	1	2	f	0	\N	\N
2558	907	608	1	41100	\N	41100	\N	\N	1	1	2	f	\N	\N	\N
2559	914	608	1	3946	\N	3946	\N	\N	0	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
1	rdf	http://www.w3.org/1999/02/22-rdf-syntax-ns#	0	f	0
2	rdfs	http://www.w3.org/2000/01/rdf-schema#	0	f	0
3	xsd	http://www.w3.org/2001/XMLSchema#	0	f	0
4	skos	http://www.w3.org/2004/02/skos/core#	0	f	0
5	dct	http://purl.org/dc/terms/	0	f	0
6	dc	http://purl.org/dc/elements/1.1/	0	f	0
7	owl	http://www.w3.org/2002/07/owl#	0	f	0
8	foaf	http://xmlns.com/foaf/0.1/	0	f	0
9	schema	http://schema.org/	0	f	0
10	dbo	http://dbpedia.org/ontology/	0	f	0
11	yago	http://dbpedia.org/class/yago/	0	f	0
12	wd	http://www.wikidata.org/entity/	0	f	0
13	wdt	http://www.wikidata.org/prop/direct/	0	f	0
14	shacl	http://www.w3.org/ns/shacl#	0	f	0
15	dcat	http://www.w3.org/ns/dcat#	0	f	0
16	void	http://rdfs.org/ns/void#	0	f	0
17	virtrdf	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
20	dbr	http://dbpedia.org/resource/	0	f	0
21	dbt	http://dbpedia.org/resource/Template:	0	f	0
22	dbc	http://dbpedia.org/resource/Category:	0	f	0
23	cc	http://creativecommons.org/ns#	0	f	0
24	vann	http://purl.org/vocab/vann/	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
26	prov	http://www.w3.org/ns/prov#	0	f	0
27	sd	http://www.w3.org/ns/sparql-service-description#	0	f	0
28	frbr	http://vocab.org/frbr/core#	0	f	0
29	georss	http://www.georss.org/georss/	0	f	0
30	gold	http://purl.org/linguistics/gold/	0	f	0
31	bibo	http://purl.org/ontology/bibo/	0	f	0
32	umbel	http://umbel.org/umbel#	0	f	0
33	umbel-rc	http://umbel.org/umbel/rc/	0	f	0
34	dul	http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#	0	f	0
35	voaf	http://purl.org/vocommons/voaf#	0	f	0
36	gr	http://purl.org/goodrelations/v1#	0	f	0
37	org	http://www.w3.org/ns/org#	0	f	0
38	sioc	http://rdfs.org/sioc/ns#	0	f	0
39	vcard	http://www.w3.org/2006/vcard/ns#	0	f	0
40	obo	http://purl.obolibrary.org/obo/	0	f	0
68	bif	http://www.openlinksw.com/schemas/bif#	0	f	0
69		http://rdf.geospecies.org/ont/geospecies#	0	t	0
70	swrl	http://www.w3.org/2003/11/swrl#	0	f	0
71	skosxl	http://www.w3.org/2008/05/skos-xl#	0	f	0
72	geonames	http://www.geonames.org/ontology#	0	f	0
73	scovo	http://purl.org/NET/scovo#	0	f	0
74	qudt	http://qudt.org/schema/qudt/	0	f	0
75	vs	http://www.w3.org/2003/06/sw-vocab-status/ns#	0	f	0
76	doap	http://usefulinc.com/ns/doap#	0	f	0
77	uniprot	http://purl.uniprot.org/core/	0	f	0
78	n_1	http://lod.taxonconcept.org/ses/Tf8vT.html#	0	f	0
79	n_2	http://lod.taxonconcept.org/ses/KDldJ.html#	0	f	0
80	n_3	http://lod.taxonconcept.org/ses/lGGpI.html#	0	f	0
81	n_4	http://lod.taxonconcept.org/ses/RTuSD.html#	0	f	0
82	n_5	http://lod.taxonconcept.org/ses/dJ8Bq.html#	0	f	0
83	n_6	http://lod.taxonconcept.org/ses/G4Qkr.rdf#	0	f	0
84	n_7	http://lod.taxonconcept.org/ses/V39Te.html#	0	f	0
85	n_8	http://lod.taxonconcept.org/ses/OvsHQ.rdf#	0	f	0
86	n_9	http://lod.taxonconcept.org/ses/onbrF.html#	0	f	0
87	n_10	http://lod.taxonconcept.org/ses/VvUQc.html#	0	f	0
88	n_11	http://lod.taxonconcept.org/ses/HsAta.rdf#	0	f	0
89	n_12	http://lod.taxonconcept.org/ses/eYgn3.rdf#	0	f	0
90	n_13	http://lod.taxonconcept.org/ses/JSfMW.html#	0	f	0
91	n_14	http://lod.taxonconcept.org/ses/JSfMW.rdf#	0	f	0
92	n_15	http://lod.taxonconcept.org/ses/nHt7g.rdf#	0	f	0
93	n_16	http://lod.taxonconcept.org/ses/DNnGE.html#	0	f	0
94	n_17	http://lod.taxonconcept.org/ses/DNnGE.rdf#	0	f	0
95	n_18	http://lod.taxonconcept.org/ses/XIVcc.html#	0	f	0
96	n_19	http://lod.taxonconcept.org/ses/55wtq.html#	0	f	0
97	n_20	http://lod.taxonconcept.org/ses/7Ro3R.html#	0	f	0
98	n_21	http://lod.taxonconcept.org/ses/4E57e.html#	0	f	0
99	n_22	http://lod.taxonconcept.org/ses/76jBF.html#	0	f	0
100	n_23	http://lod.taxonconcept.org/ses/ZZaxg.rdf#	0	f	0
101	n_24	http://lod.taxonconcept.org/ses/ieRRx.html#	0	f	0
102	n_25	http://lod.taxonconcept.org/ses/sK3lK.html#	0	f	0
103	n_26	http://rs.tdwg.org/ontology/voc/Collection#	0	f	0
104	n_27	http://rs.tdwg.org/ontology/voc/ContactDetails#	0	f	0
105	n_28	http://rs.tdwg.org/ontology/voc/GeographicRegion#	0	f	0
106	n_29	http://rs.tdwg.org/ontology/voc/InstitutionType#	0	f	0
107	n_30	http://rs.tdwg.org/ontology/voc/PublicationCitation#	0	f	0
108	n_31	http://rs.tdwg.org/ontology/voc/Specimen#	0	f	0
109	n_32	http://rs.tdwg.org/ontology/voc/TaxonName#	0	f	0
110	n_33	http://rs.tdwg.org/ontology/voc/TaxonOccurrence#	0	f	0
111	n_34	http://rs.tdwg.org/ontology/voc/TaxonOccurrenceInteraction#	0	f	0
112	n_35	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#	0	f	0
113	n_36	http://lod.taxonconcept.org/ses/2B4yu.html#	0	f	0
114	n_37	http://lod.taxonconcept.org/ses/cASOl.html#	0	f	0
115	n_38	http://lod.taxonconcept.org/ses/3d2Xq.rdf#	0	f	0
116	n_39	http://lod.taxonconcept.org/ses/H83ZL.rdf#	0	f	0
117	n_40	http://lod.taxonconcept.org/ses/kuDfK.html#	0	f	0
118	n_41	http://lod.taxonconcept.org/ses/hHgqU.rdf#	0	f	0
119	n_42	http://lod.taxonconcept.org/ses/a2eUs.rdf#	0	f	0
120	n_43	http://lod.taxonconcept.org/ses/QEBQB.rdf#	0	f	0
121	n_44	http://lod.taxonconcept.org/ses/iur2i.html#	0	f	0
122	n_45	http://lod.taxonconcept.org/ses/iur2i.rdf#	0	f	0
123	n_46	http://lod.taxonconcept.org/ses/q2tpr.html#	0	f	0
124	n_47	http://lod.taxonconcept.org/ontology/mos_path.owl#	0	f	0
125	n_48	http://lod.taxonconcept.org/ses/2tyCC.html#	0	f	0
126	n_49	http://lod.taxonconcept.org/ses/lPpMB.rdf#	0	f	0
127	n_50	http://lod.taxonconcept.org/ses/22wQv.rdf#	0	f	0
128	n_51	http://lod.taxonconcept.org/ses/CQJBJ.html#	0	f	0
129	n_52	http://lod.taxonconcept.org/ses/u7nsW.rdf#	0	f	0
130	n_53	http://lod.taxonconcept.org/ses/Badsm.html#	0	f	0
131	n_54	http://lod.taxonconcept.org/ses/pC9k6.html#	0	f	0
132	n_55	http://lod.taxonconcept.org/ses/5lVeo.html#	0	f	0
133	n_56	http://lod.taxonconcept.org/ses/BYWpt.rdf#	0	f	0
134	n_57	http://lod.taxonconcept.org/ses/n78LR.rdf#	0	f	0
135	n_58	http://lod.taxonconcept.org/ses/7fYuR.rdf#	0	f	0
136	n_59	http://lod.taxonconcept.org/ses/Hak3o.rdf#	0	f	0
137	n_60	http://lod.taxonconcept.org/ses/lUyDP.rdf#	0	f	0
138	n_61	http://lod.taxonconcept.org/ses/iRnzQ.rdf#	0	f	0
139	n_62	http://lod.taxonconcept.org/ses/ZoeKQ.rdf#	0	f	0
140	n_63	http://lod.taxonconcept.org/ses/xowGc.rdf#	0	f	0
141	n_64	http://lod.taxonconcept.org/ses/RxQZ9.html#	0	f	0
142	n_65	http://lod.taxonconcept.org/ses/7fvpi.rdf#	0	f	0
143	n_66	http://lod.taxonconcept.org/ses/ar4Fe.rdf#	0	f	0
144	n_67	http://lod.taxonconcept.org/ses/47C3Q.rdf#	0	f	0
145	n_68	http://lod.taxonconcept.org/ses/PEOGy.html#	0	f	0
146	n_69	http://lod.taxonconcept.org/ses/9OwwE.html#	0	f	0
147	n_70	http://lod.taxonconcept.org/ses/yqkNV.rdf#	0	f	0
148	n_71	http://lod.taxonconcept.org/ses/NKoA6.html#	0	f	0
149	n_72	http://lod.taxonconcept.org/ses/AoOQH.html#	0	f	0
150	n_73	http://lod.taxonconcept.org/ses/5xLy9.html#	0	f	0
151	n_74	http://lod.taxonconcept.org/ses/Y2xzp.html#	0	f	0
152	n_75	http://lod.taxonconcept.org/ses/krVXP.html#	0	f	0
153	n_76	http://lod.taxonconcept.org/ses/jv8CV.html#	0	f	0
154	n_77	http://lod.taxonconcept.org/ses/opdWv.html#	0	f	0
155	n_78	http://lod.taxonconcept.org/ses/pyaxa.html#	0	f	0
156	n_79	http://lod.taxonconcept.org/ses/oQgef.html#	0	f	0
157	n_80	http://lod.taxonconcept.org/ses/XbTtl.rdf#	0	f	0
158	n_81	http://lod.taxonconcept.org/ses/6JCRu.html#	0	f	0
159	n_82	http://lod.taxonconcept.org/ses/pC9k6.rdf#	0	f	0
160	n_83	http://lod.taxonconcept.org/ses/DEwaC.html#	0	f	0
161	n_84	http://lod.taxonconcept.org/ses/5lVeo.rdf#	0	f	0
162	n_85	http://lod.taxonconcept.org/ses/gf8Bh.html#	0	f	0
163	n_86	http://lod.taxonconcept.org/ses/gf8Bh.rdf#	0	f	0
164	n_87	http://lod.taxonconcept.org/ses/KfOVX.rdf#	0	f	0
165	n_88	http://lod.taxonconcept.org/ses/3EQhU.html#	0	f	0
166	n_89	http://lod.taxonconcept.org/ses/3EQhU.rdf#	0	f	0
167	n_90	http://lod.taxonconcept.org/ses/2iG3r.html#	0	f	0
168	n_91	http://lod.taxonconcept.org/ses/S75nv.rdf#	0	f	0
169	n_92	http://lod.taxonconcept.org/ses/EcTQM.rdf#	0	f	0
170	n_93	http://lod.taxonconcept.org/ses/4PDlb.html#	0	f	0
171	n_94	http://lod.taxonconcept.org/ses/4PDlb.rdf#	0	f	0
172	n_95	http://lod.taxonconcept.org/ses/E4TKF.html#	0	f	0
173	n_96	http://lod.taxonconcept.org/ses/5Vv5k.rdf#	0	f	0
174	n_97	http://lod.taxonconcept.org/ses/PPOlM.rdf#	0	f	0
175	n_98	http://lod.taxonconcept.org/ses/BGfwX.rdf#	0	f	0
176	n_99	http://lod.taxonconcept.org/ses/JEjhv.rdf#	0	f	0
177	n_100	http://lod.taxonconcept.org/ses/kQmp4.html#	0	f	0
178	n_101	http://lod.taxonconcept.org/ses/zIYJR.html#	0	f	0
179	n_102	http://lod.taxonconcept.org/ses/Q2isl.html#	0	f	0
180	n_103	http://lod.taxonconcept.org/ses/TDlyP.html#	0	f	0
181	n_104	http://lod.taxonconcept.org/ses/ggUul.html#	0	f	0
182	n_105	http://lod.taxonconcept.org/ses/LsXcv.html#	0	f	0
183	n_106	http://lod.taxonconcept.org/ses/aw8Ao.html#	0	f	0
184	n_107	http://lod.taxonconcept.org/ses/QXRSb.html#	0	f	0
185	n_108	http://lod.taxonconcept.org/ses/PQLdJ.rdf#	0	f	0
186	n_109	http://lod.taxonconcept.org/ses/uDNbR.rdf#	0	f	0
187	n_110	http://lod.taxonconcept.org/ses/ELuqP.html#	0	f	0
188	n_111	http://lod.taxonconcept.org/ses/HsAta.html#	0	f	0
189	n_112	http://lod.taxonconcept.org/ses/dGOc2.rdf#	0	f	0
190	n_113	http://lod.taxonconcept.org/ses/WKNeI.rdf#	0	f	0
191	n_114	http://lod.taxonconcept.org/ses/BS2sL.html#	0	f	0
192	n_115	http://lod.taxonconcept.org/ses/im3e6.rdf#	0	f	0
193	n_116	http://lod.taxonconcept.org/ses/LGFPI.html#	0	f	0
194	n_117	http://lod.taxonconcept.org/ses/LGFPI.rdf#	0	f	0
195	n_118	http://lod.taxonconcept.org/ses/76jBF.rdf#	0	f	0
196	n_119	http://lod.taxonconcept.org/ses/gjg3k.rdf#	0	f	0
197	n_120	http://lod.taxonconcept.org/ses/tyYjt.html#	0	f	0
198	n_121	http://lod.taxonconcept.org/ses/QXRSb.rdf#	0	f	0
199	n_122	http://lod.taxonconcept.org/ses/Iq3nt.rdf#	0	f	0
200	n_123	http://lod.taxonconcept.org/ses/PfzSj.html#	0	f	0
201	n_124	http://lod.taxonconcept.org/ses/O2AUE.rdf#	0	f	0
202	n_125	http://lod.taxonconcept.org/ses/ITmfL.rdf#	0	f	0
203	n_126	http://lod.taxonconcept.org/ses/AFYz2.rdf#	0	f	0
204	n_127	http://lod.taxonconcept.org/ses/24NNq.rdf#	0	f	0
205	n_128	http://lod.taxonconcept.org/ses/vMHzJ.rdf#	0	f	0
206	n_129	http://lod.taxonconcept.org/ses/ITHVA.rdf#	0	f	0
207	n_130	http://lod.taxonconcept.org/ses/HefRJ.rdf#	0	f	0
208	n_131	http://lod.taxonconcept.org/ses/TGRxf.html#	0	f	0
209	n_132	http://lod.taxonconcept.org/ses/osHpy.html#	0	f	0
210	n_133	http://lod.taxonconcept.org/ses/vxTjv.html#	0	f	0
211	n_134	http://lod.taxonconcept.org/ses/sMXn9.html#	0	f	0
212	n_135	http://lod.taxonconcept.org/ses/rQgRD.html#	0	f	0
213	n_136	http://lod.taxonconcept.org/ses/XaS5Y.rdf#	0	f	0
214	n_137	http://lod.taxonconcept.org/ses/iVwKh.html#	0	f	0
215	n_138	http://lod.taxonconcept.org/ses/EkAt6.rdf#	0	f	0
216	n_139	http://lod.taxonconcept.org/ses/3kr7b.html#	0	f	0
217	n_140	http://lod.taxonconcept.org/ses/x6gDo.html#	0	f	0
218	n_141	http://lod.taxonconcept.org/ses/LTQnq.rdf#	0	f	0
219	n_142	http://lod.taxonconcept.org/ses/bBKp5.html#	0	f	0
220	n_143	http://lod.taxonconcept.org/ses/8fG4V.html#	0	f	0
221	n_144	http://lod.taxonconcept.org/ses/NwonD.html#	0	f	0
222	n_145	http://lod.taxonconcept.org/ses/7V2jK.html#	0	f	0
223	n_146	http://lod.taxonconcept.org/ses/QXRZr.html#	0	f	0
224	n_147	http://lod.taxonconcept.org/ses/D8qet.html#	0	f	0
225	n_148	http://lod.taxonconcept.org/ses/VnzyW.html#	0	f	0
226	n_149	http://lod.taxonconcept.org/ses/DF5Ct.html#	0	f	0
227	n_150	http://lod.taxonconcept.org/ses/J3wHF.html#	0	f	0
228	n_151	http://lod.taxonconcept.org/ses/ijKNL.html#	0	f	0
229	n_152	http://lod.taxonconcept.org/ses/8fhlX.html#	0	f	0
230	n_153	http://lod.taxonconcept.org/ses/3rDWv.html#	0	f	0
231	n_154	http://lod.taxonconcept.org/ses/pLLpu.html#	0	f	0
232	n_155	http://lod.taxonconcept.org/ses/EfxcN.html#	0	f	0
233	n_156	http://lod.taxonconcept.org/ses/olWBu.html#	0	f	0
234	n_157	http://lod.taxonconcept.org/ses/3g4bi.html#	0	f	0
235	n_158	http://lod.taxonconcept.org/ses/5tLPt.html#	0	f	0
236	n_159	http://lod.taxonconcept.org/ses/EMkPp.rdf#	0	f	0
237	n_160	http://lod.taxonconcept.org/ses/AoOQH.rdf#	0	f	0
238	n_161	http://lod.taxonconcept.org/ses/YM43a.rdf#	0	f	0
239	n_162	http://lod.taxonconcept.org/ses/xLFBZ.html#	0	f	0
240	n_163	http://lod.taxonconcept.org/ses/JGok6.html#	0	f	0
241	n_164	http://lod.taxonconcept.org/ses/Bk9pZ.rdf#	0	f	0
242	n_165	http://lod.taxonconcept.org/ses/iVwKh.rdf#	0	f	0
243	n_166	http://lod.taxonconcept.org/ses/mVX7P.html#	0	f	0
244	n_167	http://lod.taxonconcept.org/ses/EkAt6.html#	0	f	0
245	n_168	http://lod.taxonconcept.org/ses/wxdNW.html#	0	f	0
246	n_169	http://lod.taxonconcept.org/ses/cWJQQ.rdf#	0	f	0
247	n_170	http://lod.taxonconcept.org/ses/QEBQB.html#	0	f	0
248	n_171	http://lod.taxonconcept.org/ses/74owc.rdf#	0	f	0
249	n_172	http://lod.taxonconcept.org/ses/XmjNm.rdf#	0	f	0
250	n_173	http://lod.taxonconcept.org/ses/Q7pVA.rdf#	0	f	0
251	n_174	http://lod.taxonconcept.org/ses/umNwC.rdf#	0	f	0
252	n_175	http://lod.taxonconcept.org/ses/PEOGy.rdf#	0	f	0
253	n_176	http://lod.taxonconcept.org/ses/6bIB4.html#	0	f	0
254	n_177	http://lod.taxonconcept.org/ses/olWBu.rdf#	0	f	0
255	n_178	http://lod.taxonconcept.org/ses/926R4.html#	0	f	0
256	n_179	http://lod.taxonconcept.org/ses/EQZJW.rdf#	0	f	0
257	n_180	http://lod.taxonconcept.org/ses/u6Qgt.rdf#	0	f	0
258	n_181	http://lod.taxonconcept.org/ses/W5fWB.rdf#	0	f	0
259	n_182	http://lod.taxonconcept.org/ses/5Vv5k.html#	0	f	0
260	n_183	http://lod.taxonconcept.org/ses/VmbzI.rdf#	0	f	0
261	n_184	http://lod.taxonconcept.org/ses/mYtsK.rdf#	0	f	0
262	n_185	http://lod.taxonconcept.org/ses/HaAJw.html#	0	f	0
263	n_186	http://lod.taxonconcept.org/ses/pOpJI.rdf#	0	f	0
264	n_187	http://lod.taxonconcept.org/ses/igYj6.html#	0	f	0
265	n_188	http://lod.taxonconcept.org/ses/2BQq2.html#	0	f	0
266	n_189	http://lod.taxonconcept.org/ses/3ufgM.html#	0	f	0
267	n_190	http://lod.taxonconcept.org/ses/u7nsW.html#	0	f	0
268	n_191	http://lod.taxonconcept.org/ses/9BRBU.html#	0	f	0
269	n_192	http://lod.taxonconcept.org/ses/e6dPZ.rdf#	0	f	0
270	n_193	http://lod.taxonconcept.org/ses/Dr525.html#	0	f	0
271	n_194	http://lod.taxonconcept.org/ses/Msb9D.rdf#	0	f	0
272	n_195	http://lod.taxonconcept.org/ses/ioT3D.html#	0	f	0
273	n_196	http://lod.taxonconcept.org/ses/dGA7c.html#	0	f	0
274	n_197	http://lod.taxonconcept.org/ses/tyYjt.rdf#	0	f	0
275	n_198	http://lod.taxonconcept.org/ses/fGg5g.html#	0	f	0
276	n_199	http://lod.taxonconcept.org/ses/nSZro.html#	0	f	0
277	n_200	http://lod.taxonconcept.org/ses/XIHap.html#	0	f	0
278	n_201	http://lod.taxonconcept.org/ses/Kmtil.html#	0	f	0
279	n_202	http://lod.taxonconcept.org/ses/N7mve.rdf#	0	f	0
280	n_203	http://lod.taxonconcept.org/ses/tTEIq.html#	0	f	0
281	n_204	http://lod.taxonconcept.org/ses/opxLi.html#	0	f	0
282	n_205	http://lod.taxonconcept.org/ses/HVNCA.html#	0	f	0
283	n_206	http://lod.taxonconcept.org/ses/48haV.html#	0	f	0
284	n_207	http://lod.taxonconcept.org/ses/ofV9x.html#	0	f	0
285	n_208	http://lod.taxonconcept.org/ses/itdft.rdf#	0	f	0
286	n_209	http://lod.taxonconcept.org/ses/BCAVn.rdf#	0	f	0
287	n_210	http://lod.taxonconcept.org/ses/s32nE.rdf#	0	f	0
288	n_211	http://lod.taxonconcept.org/ses/XNbWx.rdf#	0	f	0
289	n_212	http://lod.taxonconcept.org/ses/NwID5.html#	0	f	0
290	n_213	http://lod.taxonconcept.org/ses/kvjFY.html#	0	f	0
291	n_214	http://lod.taxonconcept.org/ses/YEqea.rdf#	0	f	0
292	n_215	http://lod.taxonconcept.org/ses/QmJnc.rdf#	0	f	0
293	n_216	http://lod.taxonconcept.org/ses/iWJLJ.html#	0	f	0
294	n_217	http://lod.taxonconcept.org/ses/VhPqt.html#	0	f	0
295	n_218	http://lod.taxonconcept.org/ses/ArS7W.html#	0	f	0
296	n_219	http://lod.taxonconcept.org/ses/SOBUF.html#	0	f	0
297	n_220	http://lod.taxonconcept.org/ses/DhWpJ.html#	0	f	0
298	n_221	http://lod.taxonconcept.org/ses/ogw3l.html#	0	f	0
299	n_222	http://lod.taxonconcept.org/ses/yMju3.rdf#	0	f	0
300	n_223	http://lod.taxonconcept.org/ses/ELuqP.rdf#	0	f	0
301	n_224	http://lod.taxonconcept.org/ses/bBKp5.rdf#	0	f	0
302	n_225	http://lod.taxonconcept.org/ses/CQJBJ.rdf#	0	f	0
303	n_226	http://lod.taxonconcept.org/ses/57Kew.rdf#	0	f	0
304	n_227	http://lod.taxonconcept.org/ses/5WPW2.html#	0	f	0
305	n_228	http://lod.taxonconcept.org/ses/4krYG.rdf#	0	f	0
306	n_229	http://lod.taxonconcept.org/ses/tnJr6.html#	0	f	0
307	n_230	http://lod.taxonconcept.org/ses/kvjFY.rdf#	0	f	0
308	n_231	http://lod.taxonconcept.org/ses/fFwMo.rdf#	0	f	0
309	n_232	http://lod.taxonconcept.org/ses/qDzwF.html#	0	f	0
310	n_233	http://lod.taxonconcept.org/ses/9m9L2.rdf#	0	f	0
311	n_234	http://www.openlinksw.com/schemas/VAD#	0	f	0
312	n_235	http://lod.taxonconcept.org/ses/pZDDU.html#	0	f	0
313	n_236	http://lod.taxonconcept.org/ses/Zn8um.html#	0	f	0
314	n_237	http://lod.taxonconcept.org/ses/v6n7p.html#	0	f	0
315	n_238	http://lod.taxonconcept.org/ses/HC5Y9.html#	0	f	0
316	n_239	http://lod.taxonconcept.org/ses/moenk.rdf#	0	f	0
317	n_240	http://lod.taxonconcept.org/ses/SKsMC.html#	0	f	0
318	n_241	http://lod.taxonconcept.org/ses/aF5ti.rdf#	0	f	0
319	n_242	http://lod.taxonconcept.org/ses/VkWnD.rdf#	0	f	0
320	n_243	http://lod.taxonconcept.org/ses/i7irQ.html#	0	f	0
321	n_244	http://lod.taxonconcept.org/ses/8mAUx.html#	0	f	0
322	n_245	http://lod.taxonconcept.org/ses/m8DFR.rdf#	0	f	0
323	n_246	http://lod.taxonconcept.org/ses/G7BFS.rdf#	0	f	0
324	n_247	http://lod.taxonconcept.org/ses/LTQnq.html#	0	f	0
325	n_248	http://lod.taxonconcept.org/ses/qxOIT.html#	0	f	0
326	n_249	http://lod.taxonconcept.org/ses/rKPgM.html#	0	f	0
327	n_250	http://lod.taxonconcept.org/ses/BnOrx.html#	0	f	0
328	n_251	http://lod.taxonconcept.org/ses/6uwCW.rdf#	0	f	0
329	n_252	http://lod.taxonconcept.org/ses/eIFFU.html#	0	f	0
330	n_253	http://lod.taxonconcept.org/ses/TT6Fu.rdf#	0	f	0
331	n_254	http://lod.taxonconcept.org/ses/im3e6.html#	0	f	0
332	n_255	http://lod.taxonconcept.org/ses/4HNHz.rdf#	0	f	0
333	n_256	http://lod.taxonconcept.org/ses/HaRqa.html#	0	f	0
334	n_257	http://lod.taxonconcept.org/ses/PCxUF.html#	0	f	0
335	n_258	http://lod.taxonconcept.org/ses/D5UkV.rdf#	0	f	0
336	n_259	http://lod.taxonconcept.org/ses/b2wr9.html#	0	f	0
337	n_260	http://lod.taxonconcept.org/ses/YM43a.html#	0	f	0
338	n_261	http://lod.taxonconcept.org/ses/IwXXi.rdf#	0	f	0
339	n_262	http://lod.taxonconcept.org/ses/wFWTd.rdf#	0	f	0
340	n_263	http://lod.taxonconcept.org/ses/mVFrg.html#	0	f	0
341	n_264	http://lod.taxonconcept.org/ses/mVFrg.rdf#	0	f	0
342	n_265	http://lod.taxonconcept.org/ses/wTt3u.html#	0	f	0
343	n_266	http://lod.taxonconcept.org/ses/2jFf6.rdf#	0	f	0
344	n_267	http://lod.taxonconcept.org/ses/6pjs3.html#	0	f	0
345	n_268	http://lod.taxonconcept.org/ses/adEE4.rdf#	0	f	0
346	txn	http://lod.taxonconcept.org/ontology/txn.owl#	0	f	0
347	n_269	http://lod.taxonconcept.org/ses/qcAAy.html#	0	f	0
348	n_270	http://lod.taxonconcept.org/ses/bFIVX.html#	0	f	0
349	n_271	http://lod.taxonconcept.org/ses/qcAAy.rdf#	0	f	0
350	n_272	http://lod.taxonconcept.org/ses/OlIuv.rdf#	0	f	0
351	n_273	http://lod.taxonconcept.org/ses/xEeq9.rdf#	0	f	0
352	n_274	http://lod.taxonconcept.org/ses/6KkDY.rdf#	0	f	0
353	n_275	http://lod.taxonconcept.org/ses/XRkR8.html#	0	f	0
354	n_276	http://lod.taxonconcept.org/ses/VkWnD.html#	0	f	0
355	n_277	http://lod.taxonconcept.org/ses/t59dV.html#	0	f	0
356	n_278	http://lod.taxonconcept.org/ses/i7irQ.rdf#	0	f	0
357	n_279	http://lod.taxonconcept.org/ses/qxOIT.rdf#	0	f	0
358	n_280	http://lod.taxonconcept.org/ses/m8DFR.html#	0	f	0
359	n_281	http://lod.taxonconcept.org/ses/V6TNl.html#	0	f	0
360	n_282	http://lod.taxonconcept.org/ses/V6TNl.rdf#	0	f	0
361	n_283	http://lod.taxonconcept.org/ses/wQT7j.html#	0	f	0
362	n_284	http://lod.taxonconcept.org/ses/VVYMq.rdf#	0	f	0
363	n_285	http://lod.taxonconcept.org/ses/3NTpp.rdf#	0	f	0
364	n_286	http://lod.taxonconcept.org/ses/GUXTh.html#	0	f	0
365	n_287	http://lod.taxonconcept.org/ses/GUXTh.rdf#	0	f	0
366	n_288	http://lod.taxonconcept.org/ses/IwXXi.html#	0	f	0
367	n_289	http://lod.taxonconcept.org/ses/D5UkV.html#	0	f	0
368	n_290	http://lod.taxonconcept.org/ses/mv8S9.html#	0	f	0
369	n_291	http://lod.taxonconcept.org/ses/b2wr9.rdf#	0	f	0
370	n_292	http://lod.taxonconcept.org/ses/ZuWgm.html#	0	f	0
371	n_293	http://lod.taxonconcept.org/ses/ZuWgm.rdf#	0	f	0
372	n_294	http://lod.taxonconcept.org/ses/feXFK.html#	0	f	0
373	n_295	http://lod.taxonconcept.org/ses/9BRBU.rdf#	0	f	0
374	n_296	http://lod.taxonconcept.org/ses/6pjs3.rdf#	0	f	0
375	n_297	http://lod.taxonconcept.org/ses/VHz69.rdf#	0	f	0
376	n_298	http://lod.taxonconcept.org/ses/dXEgr.rdf#	0	f	0
377	n_299	http://lod.taxonconcept.org/ses/kMccV.rdf#	0	f	0
378	n_300	http://lod.taxonconcept.org/ses/wwzn2.html#	0	f	0
379	n_301	http://lod.taxonconcept.org/ses/2jFf6.html#	0	f	0
380	n_302	http://lod.taxonconcept.org/ses/BpPu3.html#	0	f	0
381	n_303	http://lod.taxonconcept.org/ses/kq5Oa.rdf#	0	f	0
382	n_304	http://lod.taxonconcept.org/ses/dxKfG.rdf#	0	f	0
383	n_305	http://lod.taxonconcept.org/ses/raMe2.rdf#	0	f	0
384	n_306	http://lod.taxonconcept.org/ses/9jbcc.rdf#	0	f	0
385	n_307	http://lod.taxonconcept.org/ses/aFRYB.rdf#	0	f	0
386	n_308	http://lod.taxonconcept.org/ses/9OwwE.rdf#	0	f	0
387	n_309	http://lod.taxonconcept.org/ses/Nv6eI.html#	0	f	0
388	n_310	http://lod.taxonconcept.org/ses/5B5MS.html#	0	f	0
389	n_311	http://lod.taxonconcept.org/ses/ELjI3.html#	0	f	0
390	n_312	http://lod.taxonconcept.org/ses/jAAwG.html#	0	f	0
391	n_313	http://lod.taxonconcept.org/ses/dwOyR.html#	0	f	0
392	n_314	http://lod.taxonconcept.org/ses/jYrH5.rdf#	0	f	0
393	n_315	http://lod.taxonconcept.org/ses/z9oqP.rdf#	0	f	0
394	n_316	http://lod.taxonconcept.org/ses/waK4b.html#	0	f	0
395	n_317	http://lod.taxonconcept.org/ses/ivggI.rdf#	0	f	0
396	n_318	http://lod.taxonconcept.org/ses/Axncx.rdf#	0	f	0
397	n_319	http://lod.taxonconcept.org/ses/wTt3u.rdf#	0	f	0
398	n_320	http://lod.taxonconcept.org/ses/OFtuS.html#	0	f	0
399	n_321	http://lod.taxonconcept.org/ses/m2FE4.html#	0	f	0
400	n_322	http://lod.taxonconcept.org/ses/zWOlX.html#	0	f	0
401	n_323	http://lod.taxonconcept.org/ses/k7HvH.rdf#	0	f	0
402	n_324	http://lod.taxonconcept.org/ses/FFnq3.html#	0	f	0
403	n_325	http://lod.taxonconcept.org/ses/iBxm9.html#	0	f	0
404	n_326	http://lod.taxonconcept.org/ses/tnVcv.rdf#	0	f	0
405	n_327	http://lod.taxonconcept.org/ses/wwzn2.rdf#	0	f	0
406	n_328	http://lod.taxonconcept.org/ses/9jbcc.html#	0	f	0
407	n_329	http://lod.taxonconcept.org/ses/ejeV7.html#	0	f	0
408	n_330	http://lod.taxonconcept.org/ses/Nv6eI.rdf#	0	f	0
409	n_331	http://lod.taxonconcept.org/ses/QQNTS.rdf#	0	f	0
410	n_332	http://lod.taxonconcept.org/ses/WKNeI.html#	0	f	0
411	n_333	http://lod.taxonconcept.org/ses/D4nPw.html#	0	f	0
412	n_334	http://lod.taxonconcept.org/ses/XT77q.html#	0	f	0
413	n_335	http://lod.taxonconcept.org/ses/EaJig.html#	0	f	0
414	n_336	http://lod.taxonconcept.org/ses/UylfK.html#	0	f	0
415	n_337	http://lod.taxonconcept.org/ses/s3USA.rdf#	0	f	0
416	n_338	http://lod.taxonconcept.org/ses/NV5w5.rdf#	0	f	0
417	n_339	http://lod.taxonconcept.org/ses/vaHId.rdf#	0	f	0
418	n_340	http://lod.taxonconcept.org/ses/zXvuQ.rdf#	0	f	0
419	n_341	http://lod.taxonconcept.org/ses/LRi6u.rdf#	0	f	0
420	n_342	http://lod.taxonconcept.org/ses/2oeGw.rdf#	0	f	0
421	n_343	http://lod.taxonconcept.org/ses/T7Vjr.rdf#	0	f	0
422	n_344	http://lod.taxonconcept.org/ses/LVxnZ.rdf#	0	f	0
423	n_345	http://lod.taxonconcept.org/ses/wXh5E.rdf#	0	f	0
424	n_346	http://lod.taxonconcept.org/ses/rKPgM.rdf#	0	f	0
425	n_347	http://lod.taxonconcept.org/ses/igYj6.rdf#	0	f	0
426	n_348	http://lod.taxonconcept.org/ses/XaS5Y.html#	0	f	0
427	n_349	http://lod.taxonconcept.org/ses/lichW.rdf#	0	f	0
428	n_350	http://lod.taxonconcept.org/ses/CpatK.html#	0	f	0
429	n_351	http://lod.taxonconcept.org/ses/CpatK.rdf#	0	f	0
430	n_352	http://lod.taxonconcept.org/ses/cWJQQ.html#	0	f	0
431	n_353	http://lod.taxonconcept.org/ses/AOVKM.html#	0	f	0
432	n_354	http://lod.taxonconcept.org/ses/z3Rtq.html#	0	f	0
433	n_355	http://lod.taxonconcept.org/ses/vaHId.html#	0	f	0
434	n_356	http://lod.taxonconcept.org/ses/bFIVX.rdf#	0	f	0
435	n_357	http://lod.taxonconcept.org/ses/QwB2u.html#	0	f	0
436	n_358	http://lod.taxonconcept.org/ses/4pYdM.html#	0	f	0
437	n_359	http://lod.taxonconcept.org/ses/zaeNk.html#	0	f	0
438	n_360	http://lod.taxonconcept.org/ses/GcDa5.html#	0	f	0
439	n_361	http://lod.taxonconcept.org/ses/7x6R9.html#	0	f	0
440	n_362	http://lod.taxonconcept.org/ses/WcRD3.html#	0	f	0
441	n_363	http://lod.taxonconcept.org/ses/57Kew.html#	0	f	0
442	n_364	http://lod.taxonconcept.org/ses/rOFB9.rdf#	0	f	0
443	n_365	http://lod.taxonconcept.org/ses/BS2sL.rdf#	0	f	0
444	n_366	http://lod.taxonconcept.org/ses/IL2k3.rdf#	0	f	0
445	n_367	http://lod.taxonconcept.org/ses/8qL4Z.rdf#	0	f	0
446	n_368	http://lod.taxonconcept.org/ses/qsSwX.rdf#	0	f	0
447	n_369	http://lod.taxonconcept.org/ses/wVMFV.html#	0	f	0
448	n_370	http://lod.taxonconcept.org/ses/adEE4.html#	0	f	0
449	n_371	http://lod.taxonconcept.org/ses/EVSmX.html#	0	f	0
450	n_372	http://lod.taxonconcept.org/ses/EVSmX.rdf#	0	f	0
451	n_373	http://lod.taxonconcept.org/ses/CFMiq.html#	0	f	0
452	n_374	http://lod.taxonconcept.org/ses/CFMiq.rdf#	0	f	0
453	n_375	http://lod.taxonconcept.org/ses/sPCCJ.html#	0	f	0
454	n_376	http://lod.taxonconcept.org/ses/RilaW.rdf#	0	f	0
455	n_377	http://lod.taxonconcept.org/ses/aaZRA.rdf#	0	f	0
456	n_378	http://lod.taxonconcept.org/ses/WZI5c.html#	0	f	0
457	n_379	http://lod.taxonconcept.org/ses/Pvfap.rdf#	0	f	0
458	n_380	http://lod.taxonconcept.org/ses/n3v6Z.html#	0	f	0
459	n_381	http://lod.taxonconcept.org/ses/ULKMn.html#	0	f	0
460	n_382	http://lod.taxonconcept.org/ses/SeecQ.html#	0	f	0
461	n_383	http://lod.taxonconcept.org/ses/zWOlX.rdf#	0	f	0
462	n_384	http://lod.taxonconcept.org/ses/VvUQc.rdf#	0	f	0
463	n_385	http://lod.taxonconcept.org/ses/YArSj.rdf#	0	f	0
464	n_386	http://lod.taxonconcept.org/ses/2GDsl.rdf#	0	f	0
465	n_387	http://lod.taxonconcept.org/ses/926R4.rdf#	0	f	0
466	n_388	http://lod.taxonconcept.org/ses/O3CW8.html#	0	f	0
467	n_389	http://lod.taxonconcept.org/ses/O3CW8.rdf#	0	f	0
468	n_390	http://lod.taxonconcept.org/ses/GpZ38.html#	0	f	0
469	n_391	http://lod.taxonconcept.org/ses/BGfwX.html#	0	f	0
470	n_392	http://lod.taxonconcept.org/ses/zFh46.html#	0	f	0
471	n_393	http://lod.taxonconcept.org/ses/CRORc.html#	0	f	0
472	n_394	http://lod.taxonconcept.org/ses/OoCD3.html#	0	f	0
473	n_395	http://lod.taxonconcept.org/ses/PoSYA.rdf#	0	f	0
474	n_396	http://lod.taxonconcept.org/ses/YEqea.html#	0	f	0
475	n_397	http://lod.taxonconcept.org/ses/KDldJ.rdf#	0	f	0
476	n_398	http://lod.taxonconcept.org/ses/ebFKJ.html#	0	f	0
477	n_399	http://lod.taxonconcept.org/ses/VJgNC.rdf#	0	f	0
478	n_400	http://lod.taxonconcept.org/ses/tJoHY.rdf#	0	f	0
479	n_401	http://lod.taxonconcept.org/ses/qY4v4.html#	0	f	0
480	n_402	http://lod.taxonconcept.org/ses/8joQg.html#	0	f	0
481	n_403	http://lod.taxonconcept.org/ses/pDWjR.html#	0	f	0
482	n_404	http://lod.taxonconcept.org/ses/xj7z8.html#	0	f	0
483	n_405	http://lod.taxonconcept.org/ses/ELE4Z.rdf#	0	f	0
484	n_406	http://lod.taxonconcept.org/ses/vJgoS.rdf#	0	f	0
485	n_407	http://lod.taxonconcept.org/ses/6JCRu.rdf#	0	f	0
486	n_408	http://lod.taxonconcept.org/ses/qVPNy.html#	0	f	0
487	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
488	n_409	http://labs.mondeca.com/vocab/voaf#	0	f	0
489	n_410	http://rs.tdwg.org/ontology/voc/SPMInfoItems#	0	f	0
490	n_411	http://lod.taxonconcept.org/ses/oihlQ.rdf#	0	f	0
491	n_412	http://lod.taxonconcept.org/ses/22wQv.html#	0	f	0
492	n_413	http://lod.taxonconcept.org/ses/ZLA8X.html#	0	f	0
493	n_414	http://lod.taxonconcept.org/ses/cXZAR.html#	0	f	0
494	n_415	http://lod.taxonconcept.org/ses/rVPHV.rdf#	0	f	0
495	n_416	http://lod.taxonconcept.org/ses/F9yxJ.rdf#	0	f	0
496	n_417	http://lod.taxonconcept.org/ses/MMP3S.html#	0	f	0
497	n_418	http://lod.taxonconcept.org/ses/eqJae.html#	0	f	0
498	n_419	http://lod.taxonconcept.org/ses/oZXgE.html#	0	f	0
499	n_420	http://lod.taxonconcept.org/ses/8dhcM.html#	0	f	0
500	n_421	http://lod.taxonconcept.org/ses/Xud8H.html#	0	f	0
501	n_422	http://lod.taxonconcept.org/ses/oKHtF.html#	0	f	0
502	n_423	http://lod.taxonconcept.org/ses/t7A6t.html#	0	f	0
503	n_424	http://lod.taxonconcept.org/ses/QfP97.html#	0	f	0
504	n_425	http://lod.taxonconcept.org/ses/cD9gH.html#	0	f	0
505	n_426	http://lod.taxonconcept.org/ses/Hak3o.html#	0	f	0
506	n_427	http://lod.taxonconcept.org/ses/4HNHz.html#	0	f	0
507	n_428	http://lod.taxonconcept.org/ses/wbbPl.html#	0	f	0
508	n_429	http://lod.taxonconcept.org/ses/n5Qdb.html#	0	f	0
509	n_430	http://lod.taxonconcept.org/ses/iWJLJ.rdf#	0	f	0
510	n_431	http://lod.taxonconcept.org/ses/7V2jK.rdf#	0	f	0
511	n_432	http://lod.taxonconcept.org/ses/2AD3s.rdf#	0	f	0
512	n_433	http://lod.taxonconcept.org/ses/mD3sJ.rdf#	0	f	0
513	n_434	http://lod.taxonconcept.org/ses/IxueZ.rdf#	0	f	0
514	n_435	http://lod.taxonconcept.org/ses/xEeq9.html#	0	f	0
515	n_436	http://lod.taxonconcept.org/ses/2iG3r.rdf#	0	f	0
516	n_437	http://lod.taxonconcept.org/ses/wmVJY.rdf#	0	f	0
517	n_438	http://lod.taxonconcept.org/ses/XbTtl.html#	0	f	0
518	n_439	http://lod.taxonconcept.org/ses/EcTQM.html#	0	f	0
519	n_440	http://lod.taxonconcept.org/ses/2wS2P.html#	0	f	0
520	n_441	http://lod.taxonconcept.org/ses/IL2k3.html#	0	f	0
521	n_442	http://lod.taxonconcept.org/ses/y9pGW.rdf#	0	f	0
522	n_443	http://lod.taxonconcept.org/ses/ORKio.rdf#	0	f	0
523	n_444	http://lod.taxonconcept.org/ses/PPOlM.html#	0	f	0
524	n_445	http://lod.taxonconcept.org/ses/z2ilb.html#	0	f	0
525	n_446	http://lod.taxonconcept.org/ses/IB4Hf.html#	0	f	0
526	n_447	http://lod.taxonconcept.org/ses/VJgNC.html#	0	f	0
527	n_448	http://lod.taxonconcept.org/ses/j5NVr.html#	0	f	0
528	n_449	http://lod.taxonconcept.org/ses/4Qydt.html#	0	f	0
529	n_450	http://lod.taxonconcept.org/ses/i4JZY.html#	0	f	0
530	n_451	http://lod.taxonconcept.org/ses/4ghrW.html#	0	f	0
531	n_452	http://lod.taxonconcept.org/ses/5fK3d.html#	0	f	0
532	n_453	http://lod.taxonconcept.org/ses/IK5fE.html#	0	f	0
533	n_454	http://lod.taxonconcept.org/ses/Z3GJ8.html#	0	f	0
534	n_455	http://lod.taxonconcept.org/ses/8mLck.html#	0	f	0
535	n_456	http://lod.taxonconcept.org/ses/AofkF.html#	0	f	0
536	n_457	http://lod.taxonconcept.org/ses/cYWxg.html#	0	f	0
537	n_458	http://lod.taxonconcept.org/ses/cYWxg.rdf#	0	f	0
538	n_459	http://lod.taxonconcept.org/ses/3d2Xq.html#	0	f	0
539	n_460	http://lod.taxonconcept.org/ses/TFUb8.rdf#	0	f	0
540	n_461	http://lod.taxonconcept.org/ses/oihlQ.html#	0	f	0
541	n_462	http://lod.taxonconcept.org/ses/ZCzx2.html#	0	f	0
542	n_463	http://lod.taxonconcept.org/ses/ZCzx2.rdf#	0	f	0
543	n_464	http://lod.taxonconcept.org/ses/2tyCC.rdf#	0	f	0
544	n_465	http://lod.taxonconcept.org/ses/DEwaC.rdf#	0	f	0
545	n_466	http://lod.taxonconcept.org/ses/SeecQ.rdf#	0	f	0
546	n_467	http://lod.taxonconcept.org/ses/IxueZ.html#	0	f	0
547	n_468	http://lod.taxonconcept.org/ses/wmVJY.html#	0	f	0
548	n_469	http://lod.taxonconcept.org/ses/RxQZ9.rdf#	0	f	0
549	n_470	http://lod.taxonconcept.org/ses/E4TKF.rdf#	0	f	0
550	n_471	http://lod.taxonconcept.org/ses/y9pGW.html#	0	f	0
551	n_472	http://lod.taxonconcept.org/ses/NKoA6.rdf#	0	f	0
552	n_473	http://lod.taxonconcept.org/ses/j5NVr.rdf#	0	f	0
553	n_474	http://lod.taxonconcept.org/ses/5xLy9.rdf#	0	f	0
554	n_475	http://lod.taxonconcept.org/ses/4fx89.html#	0	f	0
555	n_476	http://lod.taxonconcept.org/ses/R9Fn8.html#	0	f	0
556	n_477	http://lod.taxonconcept.org/ses/ORKio.html#	0	f	0
557	n_478	http://lod.taxonconcept.org/ses/tknII.html#	0	f	0
558	n_479	http://lod.taxonconcept.org/ses/rDsSo.html#	0	f	0
559	n_480	http://lod.taxonconcept.org/ses/5Lwrj.html#	0	f	0
560	n_481	http://lod.taxonconcept.org/ses/UPL7f.html#	0	f	0
561	n_482	http://lod.taxonconcept.org/ses/lLjsp.html#	0	f	0
562	n_483	http://lod.taxonconcept.org/ses/ndTgB.rdf#	0	f	0
563	n_484	http://lod.taxonconcept.org/ses/XIHap.rdf#	0	f	0
564	n_485	http://lod.taxonconcept.org/ses/3g4bi.rdf#	0	f	0
565	n_486	http://lod.taxonconcept.org/ses/MYQMc.rdf#	0	f	0
566	n_487	http://lod.taxonconcept.org/ses/O2AUE.html#	0	f	0
567	n_488	http://lod.taxonconcept.org/ses/nM3cP.rdf#	0	f	0
568	n_489	http://lod.taxonconcept.org/ses/RUeOo.rdf#	0	f	0
569	n_490	http://lod.taxonconcept.org/ses/XRkR8.rdf#	0	f	0
570	n_491	http://lod.taxonconcept.org/ses/pOpJI.html#	0	f	0
571	n_492	http://lod.taxonconcept.org/ses/ExW6Q.rdf#	0	f	0
572	n_493	http://lod.taxonconcept.org/ses/ndTgB.html#	0	f	0
573	n_494	http://lod.taxonconcept.org/ses/BolZ6.rdf#	0	f	0
574	n_495	http://lod.taxonconcept.org/ses/xLFBZ.rdf#	0	f	0
575	n_496	http://lod.taxonconcept.org/ses/iRs57.html#	0	f	0
576	n_497	http://lod.taxonconcept.org/ses/axLDl.rdf#	0	f	0
577	n_498	http://lod.taxonconcept.org/ses/2p3It.rdf#	0	f	0
578	n_499	http://lod.taxonconcept.org/ses/nzNSq.html#	0	f	0
579	n_500	http://lod.taxonconcept.org/ses/s3USA.html#	0	f	0
580	n_501	http://lod.taxonconcept.org/ses/JGok6.rdf#	0	f	0
581	n_502	http://lod.taxonconcept.org/ses/UhTds.html#	0	f	0
582	n_503	http://lod.taxonconcept.org/ses/ieRRx.rdf#	0	f	0
583	n_504	http://lod.taxonconcept.org/ses/ICmLC.html#	0	f	0
584	n_505	http://lod.taxonconcept.org/ses/yATrt.html#	0	f	0
585	n_506	http://lod.taxonconcept.org/ses/3dk3a.html#	0	f	0
586	n_507	http://lod.taxonconcept.org/ses/OPM5j.html#	0	f	0
587	n_508	http://lod.taxonconcept.org/ses/rxX5V.html#	0	f	0
588	n_509	http://lod.taxonconcept.org/ses/Biw4V.html#	0	f	0
589	n_510	http://lod.taxonconcept.org/ses/abqET.html#	0	f	0
590	n_511	http://lod.taxonconcept.org/ses/mVX7P.rdf#	0	f	0
591	n_512	http://lod.taxonconcept.org/ses/mddSP.rdf#	0	f	0
592	n_513	http://lod.taxonconcept.org/ses/HVNCA.rdf#	0	f	0
593	n_514	http://lod.taxonconcept.org/ses/wxdNW.rdf#	0	f	0
594	n_515	http://lod.taxonconcept.org/ses/QNRma.rdf#	0	f	0
595	n_516	http://lod.taxonconcept.org/ses/Badsm.rdf#	0	f	0
596	n_517	http://lod.taxonconcept.org/ses/DF5Ct.rdf#	0	f	0
597	n_518	http://lod.taxonconcept.org/ses/a4VnR.html#	0	f	0
598	n_519	http://lod.taxonconcept.org/ses/rScby.html#	0	f	0
599	n_520	http://lod.taxonconcept.org/ses/kKOIv.html#	0	f	0
600	n_521	http://lod.taxonconcept.org/ses/HaAJw.rdf#	0	f	0
601	n_522	http://lod.taxonconcept.org/ses/m2FE4.rdf#	0	f	0
602	n_523	http://lod.taxonconcept.org/ses/sG4oi.html#	0	f	0
603	n_524	http://lod.taxonconcept.org/ses/sG4oi.rdf#	0	f	0
604	n_525	http://lod.taxonconcept.org/ses/kYBc4.html#	0	f	0
605	n_526	http://lod.taxonconcept.org/ses/X6aiO.rdf#	0	f	0
606	n_527	http://lod.taxonconcept.org/ses/axLDl.html#	0	f	0
607	n_528	http://lod.taxonconcept.org/ses/EMkPp.html#	0	f	0
608	n_529	http://lod.taxonconcept.org/ses/fxDuZ.html#	0	f	0
609	n_530	http://lod.taxonconcept.org/ses/fxDuZ.rdf#	0	f	0
610	n_531	http://lod.taxonconcept.org/ses/4pZxA.html#	0	f	0
611	n_532	http://lod.taxonconcept.org/ses/2CXsb.html#	0	f	0
612	n_533	http://lod.taxonconcept.org/ses/2CXsb.rdf#	0	f	0
613	n_534	http://lod.taxonconcept.org/ses/HefRJ.html#	0	f	0
614	n_535	http://lod.taxonconcept.org/ses/PJIJ8.html#	0	f	0
615	n_536	http://lod.taxonconcept.org/ses/PJIJ8.rdf#	0	f	0
616	n_537	http://lod.taxonconcept.org/ses/3kr7b.rdf#	0	f	0
617	n_538	http://lod.taxonconcept.org/ses/nlvkB.html#	0	f	0
618	n_539	http://lod.taxonconcept.org/ses/eVSXV.rdf#	0	f	0
619	n_540	http://lod.taxonconcept.org/ses/65KiB.rdf#	0	f	0
620	n_541	http://lod.taxonconcept.org/ses/DJEZ3.html#	0	f	0
621	n_542	http://lod.taxonconcept.org/ses/OJEaQ.html#	0	f	0
622	n_543	http://lod.taxonconcept.org/ses/ZLA8X.rdf#	0	f	0
623	n_544	http://lod.taxonconcept.org/ses/3LYsH.rdf#	0	f	0
624	n_545	http://lod.taxonconcept.org/ses/UARq7.rdf#	0	f	0
625	n_546	http://lod.taxonconcept.org/ses/cXZAR.rdf#	0	f	0
626	n_547	http://lod.taxonconcept.org/ses/4fx89.rdf#	0	f	0
627	n_548	http://lod.taxonconcept.org/ses/t59dV.rdf#	0	f	0
628	n_549	http://lod.taxonconcept.org/ses/EY8Z6.html#	0	f	0
629	n_550	http://lod.taxonconcept.org/ses/SkX3l.html#	0	f	0
630	n_551	http://lod.taxonconcept.org/ses/Uc2wY.html#	0	f	0
631	n_552	http://lod.taxonconcept.org/ses/QZUKm.html#	0	f	0
632	n_553	http://lod.taxonconcept.org/ses/S75nv.html#	0	f	0
633	n_554	http://lod.taxonconcept.org/ses/QnVp3.html#	0	f	0
634	n_555	http://lod.taxonconcept.org/ses/8joQg.rdf#	0	f	0
635	n_556	http://lod.taxonconcept.org/ses/4pZxA.rdf#	0	f	0
636	n_557	http://lod.taxonconcept.org/ses/sPCCJ.rdf#	0	f	0
637	n_558	http://lod.taxonconcept.org/ses/QXRZr.rdf#	0	f	0
638	n_559	http://lod.taxonconcept.org/ses/VnzyW.rdf#	0	f	0
639	n_560	http://lod.taxonconcept.org/ses/VhGI9.html#	0	f	0
640	n_561	http://lod.taxonconcept.org/ses/uHoTn.html#	0	f	0
641	n_562	http://lod.taxonconcept.org/ses/lHg5m.html#	0	f	0
642	n_563	http://lod.taxonconcept.org/ses/F8kQB.rdf#	0	f	0
643	n_564	http://lod.taxonconcept.org/ses/kYBc4.rdf#	0	f	0
644	n_565	http://lod.taxonconcept.org/ses/ArS7W.rdf#	0	f	0
645	n_566	http://lod.taxonconcept.org/ses/TOKln.rdf#	0	f	0
646	n_567	http://lod.taxonconcept.org/ses/VHz69.html#	0	f	0
647	n_568	http://lod.taxonconcept.org/ses/cdMUI.html#	0	f	0
648	n_569	http://lod.taxonconcept.org/ses/QTYha.rdf#	0	f	0
649	n_570	http://lod.taxonconcept.org/ses/JTV2N.html#	0	f	0
650	n_571	http://lod.taxonconcept.org/ses/7fYuR.html#	0	f	0
651	n_572	http://taxref.mnhn.fr/lod/status/	0	f	0
652	n_573	http://lod.taxonconcept.org/ses/6Hyrh.html#	0	f	0
653	n_574	http://lod.taxonconcept.org/ses/XsNMK.html#	0	f	0
654	n_575	http://lod.taxonconcept.org/ses/hXpqy.html#	0	f	0
655	n_576	http://lod.taxonconcept.org/ses/OJayI.rdf#	0	f	0
656	n_577	http://lod.taxonconcept.org/ses/xmwfI.html#	0	f	0
657	n_578	http://lod.taxonconcept.org/ses/V8QpQ.html#	0	f	0
658	n_579	http://lod.taxonconcept.org/ses/Imlsn.rdf#	0	f	0
659	n_580	http://lod.taxonconcept.org/ses/76MPI.rdf#	0	f	0
660	n_581	http://lod.taxonconcept.org/ses/t5Fmw.html#	0	f	0
661	n_582	http://lod.taxonconcept.org/ses/gtvtr.html#	0	f	0
662	n_583	http://lod.taxonconcept.org/ses/G4Qkr.html#	0	f	0
663	n_584	http://lod.taxonconcept.org/ses/4xejT.html#	0	f	0
664	n_585	http://lod.taxonconcept.org/ses/bLTgP.html#	0	f	0
665	n_586	http://lod.taxonconcept.org/ses/8V5bw.html#	0	f	0
666	n_587	http://lod.taxonconcept.org/ses/aJaIP.html#	0	f	0
667	n_588	http://lod.taxonconcept.org/ses/AjWPP.html#	0	f	0
668	n_589	http://lod.taxonconcept.org/ses/5tLPt.rdf#	0	f	0
669	n_590	http://lod.taxonconcept.org/ses/iRbjb.html#	0	f	0
670	n_591	http://lod.taxonconcept.org/ses/rKFVI.html#	0	f	0
671	n_592	http://lod.taxonconcept.org/ses/2Oqz2.html#	0	f	0
672	n_593	http://lod.taxonconcept.org/ses/y6jvL.html#	0	f	0
673	n_594	http://lod.taxonconcept.org/ses/pLLpu.rdf#	0	f	0
674	n_595	http://lod.taxonconcept.org/ses/kJ8FO.rdf#	0	f	0
675	n_596	http://lod.taxonconcept.org/ses/4Bgim.html#	0	f	0
676	n_597	http://lod.taxonconcept.org/ses/76MPI.html#	0	f	0
677	n_598	http://lod.taxonconcept.org/ses/t7NOj.html#	0	f	0
678	n_599	http://lod.taxonconcept.org/ses/RUeOo.html#	0	f	0
679	n_600	http://lod.taxonconcept.org/ses/6vZHr.html#	0	f	0
680	n_601	http://lod.taxonconcept.org/ses/BCAVn.html#	0	f	0
681	n_602	http://lod.taxonconcept.org/ses/nBmiL.rdf#	0	f	0
682	n_603	http://lod.taxonconcept.org/ses/gjg3k.html#	0	f	0
683	n_604	http://lod.taxonconcept.org/ses/mD3sJ.html#	0	f	0
684	n_605	http://lod.taxonconcept.org/ses/J8XNW.rdf#	0	f	0
685	n_606	http://lod.taxonconcept.org/ses/uDbnq.html#	0	f	0
686	n_607	http://lod.taxonconcept.org/ses/SKsMC.rdf#	0	f	0
687	n_608	http://lod.taxonconcept.org/ses/w2O2N.html#	0	f	0
688	n_609	http://lod.taxonconcept.org/ses/LTUGJ.html#	0	f	0
689	n_610	http://lod.taxonconcept.org/ses/NwID5.rdf#	0	f	0
690	n_611	http://lod.taxonconcept.org/ses/28Dma.html#	0	f	0
691	n_612	http://lod.taxonconcept.org/ses/yKMjt.html#	0	f	0
692	n_613	http://lod.taxonconcept.org/ontology/usda_plants.owl#	0	f	0
693	n_614	http://lod.taxonconcept.org/ses/tXHPR.html#	0	f	0
694	n_615	http://lod.taxonconcept.org/ses/oJIpA.html#	0	f	0
695	n_616	http://lod.taxonconcept.org/ses/FRbxU.html#	0	f	0
696	n_617	http://lod.taxonconcept.org/ses/8DeCK.html#	0	f	0
697	n_618	http://lod.taxonconcept.org/ses/ysPDD.html#	0	f	0
698	n_619	http://lod.taxonconcept.org/ses/Axncx.html#	0	f	0
699	n_620	http://lod.taxonconcept.org/ses/8qL4Z.html#	0	f	0
700	n_621	http://lod.taxonconcept.org/ses/caIZp.rdf#	0	f	0
701	n_622	http://lod.taxonconcept.org/ses/tnVcv.html#	0	f	0
702	n_623	http://lod.taxonconcept.org/ses/eIFFU.rdf#	0	f	0
703	n_624	http://lod.taxonconcept.org/ses/OHpAN.rdf#	0	f	0
704	n_625	http://lod.taxonconcept.org/ses/Q7pVA.html#	0	f	0
705	n_626	http://lod.taxonconcept.org/ses/iD4vM.rdf#	0	f	0
706	n_627	http://lod.taxonconcept.org/ses/yjsfm.rdf#	0	f	0
707	n_628	http://lod.taxonconcept.org/ses/PdWOo.html#	0	f	0
708	n_629	http://lod.taxonconcept.org/ses/jSdoN.html#	0	f	0
709	n_630	http://lod.taxonconcept.org/ses/jQzGP.rdf#	0	f	0
710	n_631	http://lod.taxonconcept.org/ses/LAn6h.html#	0	f	0
711	n_632	http://lod.taxonconcept.org/ses/EQZJW.html#	0	f	0
712	n_633	http://lod.taxonconcept.org/ses/mv8S9.rdf#	0	f	0
713	n_634	http://lod.taxonconcept.org/ses/feXFK.rdf#	0	f	0
714	n_635	http://lod.taxonconcept.org/ses/6uwCW.html#	0	f	0
715	n_636	http://lod.taxonconcept.org/ses/nmWc7.rdf#	0	f	0
716	n_637	http://lod.taxonconcept.org/ses/mCcSp.rdf#	0	f	0
717	n_638	http://lod.taxonconcept.org/ses/obd3m.rdf#	0	f	0
718	n_639	http://lod.taxonconcept.org/ses/mTlAd.rdf#	0	f	0
719	n_640	http://lod.taxonconcept.org/ses/hHgqU.html#	0	f	0
720	n_641	http://lod.taxonconcept.org/ses/HOaYm.rdf#	0	f	0
721	n_642	http://lod.taxonconcept.org/ses/6KkDY.html#	0	f	0
722	n_643	http://lod.taxonconcept.org/ses/mdkiV.rdf#	0	f	0
723	n_644	http://lod.taxonconcept.org/ses/TbdII.rdf#	0	f	0
724	n_645	http://lod.taxonconcept.org/ses/jSdoN.rdf#	0	f	0
725	n_646	http://lod.taxonconcept.org/ses/jQzGP.html#	0	f	0
726	n_647	http://lod.taxonconcept.org/ses/N6mpR.html#	0	f	0
727	n_648	http://lod.taxonconcept.org/ses/HaRqa.rdf#	0	f	0
728	n_649	http://lod.taxonconcept.org/ses/8mAUx.rdf#	0	f	0
729	n_650	http://lod.taxonconcept.org/ses/xb4r5.rdf#	0	f	0
730	n_651	http://lod.taxonconcept.org/ses/qDzwF.rdf#	0	f	0
731	n_652	http://lod.taxonconcept.org/ses/e6dPZ.html#	0	f	0
732	n_653	http://lod.taxonconcept.org/ses/GoFRJ.html#	0	f	0
733	n_654	http://lod.taxonconcept.org/ses/jKbtO.rdf#	0	f	0
734	n_655	http://lod.taxonconcept.org/ses/hS934.html#	0	f	0
735	n_656	http://lod.taxonconcept.org/ses/tXb2W.html#	0	f	0
736	n_657	http://lod.taxonconcept.org/ses/6EoSC.html#	0	f	0
737	n_658	http://lod.taxonconcept.org/ses/4deYk.html#	0	f	0
738	n_659	http://lod.taxonconcept.org/ses/kJ8FO.html#	0	f	0
739	n_660	http://lod.taxonconcept.org/ses/4qyn7.html#	0	f	0
740	n_661	http://lod.taxonconcept.org/ses/vJgoS.html#	0	f	0
741	n_662	http://lod.taxonconcept.org/ses/O5CP2.rdf#	0	f	0
742	n_663	http://lod.taxonconcept.org/ses/ivggI.html#	0	f	0
743	n_664	http://lod.taxonconcept.org/ses/Tf8vT.rdf#	0	f	0
744	n_665	http://lod.taxonconcept.org/ses/caIZp.html#	0	f	0
745	n_666	http://lod.taxonconcept.org/ses/iXnvQ.html#	0	f	0
746	n_667	http://lod.taxonconcept.org/ses/iXnvQ.rdf#	0	f	0
747	n_668	http://lod.taxonconcept.org/ses/TSZLI.rdf#	0	f	0
748	n_669	http://lod.taxonconcept.org/ses/BpPu3.rdf#	0	f	0
749	n_670	http://lod.taxonconcept.org/ses/kq5Oa.html#	0	f	0
750	n_671	http://lod.taxonconcept.org/ses/fcYdD.html#	0	f	0
751	n_672	http://lod.taxonconcept.org/ses/fcYdD.rdf#	0	f	0
752	n_673	http://lod.taxonconcept.org/ses/jKbtO.html#	0	f	0
753	n_674	http://lod.taxonconcept.org/ses/9tBVB.html#	0	f	0
754	n_675	http://lod.taxonconcept.org/ses/LdtMp.html#	0	f	0
755	n_676	http://lod.taxonconcept.org/ses/CsmOq.html#	0	f	0
756	n_677	http://lod.taxonconcept.org/ses/QwB2u.rdf#	0	f	0
757	n_678	http://lod.taxonconcept.org/ses/AhnLm.rdf#	0	f	0
758	n_679	http://lod.taxonconcept.org/ses/T7Vjr.html#	0	f	0
759	n_680	http://lod.taxonconcept.org/ses/wXh5E.html#	0	f	0
760	n_681	http://lod.taxonconcept.org/ses/3LYsH.html#	0	f	0
761	n_682	http://lod.taxonconcept.org/ses/nBmiL.html#	0	f	0
762	n_683	http://lod.taxonconcept.org/ses/tFejO.rdf#	0	f	0
763	n_684	http://lod.taxonconcept.org/ses/x6gDo.rdf#	0	f	0
764	n_685	http://lod.taxonconcept.org/ses/Vts5z.html#	0	f	0
765	n_686	http://lod.taxonconcept.org/ses/AOVKM.rdf#	0	f	0
766	n_687	http://lod.taxonconcept.org/ses/LRi6u.html#	0	f	0
767	n_688	http://lod.taxonconcept.org/ses/yMju3.html#	0	f	0
768	n_689	http://lod.taxonconcept.org/ses/CuKKT.rdf#	0	f	0
769	n_690	http://lod.taxonconcept.org/ses/z9oqP.html#	0	f	0
770	n_691	http://lod.taxonconcept.org/ses/mCcSp.html#	0	f	0
771	n_692	http://lod.taxonconcept.org/ses/YOlcx.html#	0	f	0
772	n_693	http://lod.taxonconcept.org/ses/tTEIq.rdf#	0	f	0
773	n_694	http://lod.taxonconcept.org/ses/iRs57.rdf#	0	f	0
774	n_695	http://lod.taxonconcept.org/ses/nzNSq.rdf#	0	f	0
775	n_696	http://lod.taxonconcept.org/ses/lichW.html#	0	f	0
776	n_697	http://lod.taxonconcept.org/ses/RilaW.html#	0	f	0
777	n_698	http://lod.taxonconcept.org/ses/JzyMo.rdf#	0	f	0
778	n_699	http://lod.taxonconcept.org/ses/65KiB.html#	0	f	0
779	n_700	http://lod.taxonconcept.org/ses/WZI5c.rdf#	0	f	0
780	n_701	http://lod.taxonconcept.org/ses/4h8D9.html#	0	f	0
781	n_702	http://lod.taxonconcept.org/ses/5o3zj.html#	0	f	0
782	n_703	http://lod.taxonconcept.org/ses/jZipn.html#	0	f	0
783	n_704	http://lod.taxonconcept.org/ses/28FRg.html#	0	f	0
784	n_705	http://lod.taxonconcept.org/ses/IJVMg.rdf#	0	f	0
785	n_706	http://lod.taxonconcept.org/ses/moenk.html#	0	f	0
786	n_707	http://lod.taxonconcept.org/ses/EfxcN.rdf#	0	f	0
787	n_708	http://lod.taxonconcept.org/ses/kuDfK.rdf#	0	f	0
788	n_709	http://lod.taxonconcept.org/ses/OoCD3.rdf#	0	f	0
789	n_710	http://lod.taxonconcept.org/ses/zseFr.rdf#	0	f	0
790	n_711	http://lod.taxonconcept.org/ses/2GDsl.html#	0	f	0
791	n_712	http://lod.taxonconcept.org/ses/ZoFhA.rdf#	0	f	0
792	n_713	http://lod.taxonconcept.org/ses/PdWOo.rdf#	0	f	0
793	n_714	http://lod.taxonconcept.org/ses/GpZ38.rdf#	0	f	0
794	n_715	http://lod.taxonconcept.org/ses/LAOy5.html#	0	f	0
795	n_716	http://lod.taxonconcept.org/ses/MdROc.rdf#	0	f	0
796	n_717	http://lod.taxonconcept.org/ses/umNwC.html#	0	f	0
797	n_718	http://lod.taxonconcept.org/ses/kIZ8s.rdf#	0	f	0
798	n_719	http://lod.taxonconcept.org/ses/kvthV.html#	0	f	0
799	n_720	http://lod.taxonconcept.org/ses/gIoD2.html#	0	f	0
800	n_721	http://lod.taxonconcept.org/ses/I2qdX.html#	0	f	0
801	n_722	http://lod.taxonconcept.org/ses/2JU3c.html#	0	f	0
802	n_723	http://lod.taxonconcept.org/ses/FFnq3.rdf#	0	f	0
803	n_724	http://lod.taxonconcept.org/ses/JYUlw.rdf#	0	f	0
804	n_725	http://lod.taxonconcept.org/ses/ELE4Z.html#	0	f	0
805	n_726	http://lod.taxonconcept.org/ses/uVdxi.rdf#	0	f	0
806	n_727	http://lod.taxonconcept.org/ses/qVPNy.rdf#	0	f	0
807	wo	http://purl.org/ontology/wo/	0	f	0
808	biotop	http://purl.org/biotop/biotop.owl#	0	f	0
809	n_728	http://lod.taxonconcept.org/ses/46cUS.html#	0	f	0
810	n_729	http://lod.taxonconcept.org/ses/uUeFV.html#	0	f	0
811	n_730	http://lod.taxonconcept.org/ses/jW7WG.html#	0	f	0
812	n_731	http://lod.taxonconcept.org/ses/LHPTE.html#	0	f	0
813	n_732	http://lod.taxonconcept.org/ses/MAVwR.html#	0	f	0
814	n_733	http://lod.taxonconcept.org/ses/3AuTD.html#	0	f	0
815	n_734	http://lod.taxonconcept.org/ses/HPseh.html#	0	f	0
816	n_735	http://lod.taxonconcept.org/ses/HkYGc.html#	0	f	0
817	n_736	http://lod.taxonconcept.org/ses/aL9o3.html#	0	f	0
818	n_737	http://lod.taxonconcept.org/ses/7dODo.html#	0	f	0
819	n_738	http://lod.taxonconcept.org/ses/42v62.html#	0	f	0
820	n_739	http://lod.taxonconcept.org/ses/V39Te.rdf#	0	f	0
821	n_740	http://lod.taxonconcept.org/ses/gBmxL.rdf#	0	f	0
822	n_741	http://lod.taxonconcept.org/ses/UhTds.rdf#	0	f	0
823	n_742	http://lod.taxonconcept.org/ses/ASpsq.html#	0	f	0
824	n_743	http://lod.taxonconcept.org/ses/8CvZO.html#	0	f	0
825	n_744	http://lod.taxonconcept.org/ses/tWMmY.html#	0	f	0
826	n_745	http://lod.taxonconcept.org/ses/KnNJn.html#	0	f	0
827	n_746	http://lod.taxonconcept.org/ses/dmGKK.html#	0	f	0
828	n_747	http://lod.taxonconcept.org/ses/KFRc2.html#	0	f	0
829	n_748	http://lod.taxonconcept.org/ses/t7NOj.rdf#	0	f	0
830	n_749	http://lod.taxonconcept.org/ses/kQmp4.rdf#	0	f	0
831	n_750	http://lod.taxonconcept.org/ses/tXGh9.html#	0	f	0
832	n_751	http://lod.taxonconcept.org/ses/GX4oF.html#	0	f	0
833	n_752	http://lod.taxonconcept.org/ses/tcmif.html#	0	f	0
834	n_753	http://lod.taxonconcept.org/ses/3xUwR.html#	0	f	0
835	n_754	http://lod.taxonconcept.org/ses/Ku8fW.html#	0	f	0
836	n_755	http://rs.tdwg.org/ontology/voc/CollectionType#	0	f	0
837	n_756	http://rs.tdwg.org/ontology/voc/TaxonConcept#	0	f	0
838	n_757	http://lod.taxonconcept.org/ses/mA4st.html#	0	f	0
839	n_758	http://lod.taxonconcept.org/ses/CAUoW.html#	0	f	0
840	n_759	http://lod.taxonconcept.org/ses/2JU3c.rdf#	0	f	0
841	n_760	http://lod.taxonconcept.org/ses/Ku8fW.rdf#	0	f	0
842	n_761	http://lod.taxonconcept.org/ses/Sw7iu.html#	0	f	0
843	n_762	http://lod.taxonconcept.org/ses/htm2P.html#	0	f	0
844	n_763	http://lod.taxonconcept.org/ses/a2eUs.html#	0	f	0
845	n_764	http://lod.taxonconcept.org/ses/TM9SC.rdf#	0	f	0
846	n_765	http://lod.taxonconcept.org/ses/ITmfL.html#	0	f	0
847	n_766	http://lod.taxonconcept.org/ses/TFUb8.html#	0	f	0
848	n_767	http://lod.taxonconcept.org/ses/ZoeKQ.html#	0	f	0
849	n_768	http://lod.taxonconcept.org/ses/nSZro.rdf#	0	f	0
850	n_769	http://lod.taxonconcept.org/ses/mTlAd.html#	0	f	0
851	n_770	http://lod.taxonconcept.org/ses/WYa5u.html#	0	f	0
852	n_771	http://lod.taxonconcept.org/ses/2POKF.html#	0	f	0
853	n_772	http://lod.taxonconcept.org/ses/YjzOP.html#	0	f	0
854	n_773	http://lod.taxonconcept.org/ses/nQB9K.html#	0	f	0
855	n_774	http://lod.taxonconcept.org/ses/sdaPW.html#	0	f	0
856	n_775	http://lod.taxonconcept.org/ses/2T4So.html#	0	f	0
857	n_776	http://lod.taxonconcept.org/ses/Xutcc.html#	0	f	0
858	n_777	http://lod.taxonconcept.org/ses/sEMkb.html#	0	f	0
859	n_778	http://lod.taxonconcept.org/ses/9PTlD.html#	0	f	0
860	n_779	http://lod.taxonconcept.org/ses/I2qdX.rdf#	0	f	0
861	n_780	http://lod.taxonconcept.org/ses/DhWpJ.rdf#	0	f	0
862	n_781	http://lod.taxonconcept.org/ses/VzVyR.html#	0	f	0
863	n_782	http://lod.taxonconcept.org/ses/LGyLC.html#	0	f	0
864	n_783	http://lod.taxonconcept.org/ses/2p3It.html#	0	f	0
865	n_784	http://lod.taxonconcept.org/ses/wbbPl.rdf#	0	f	0
866	n_785	http://lod.taxonconcept.org/ses/6Yons.html#	0	f	0
867	n_786	http://lod.taxonconcept.org/ses/txX8v.html#	0	f	0
868	n_787	http://lod.taxonconcept.org/ses/aV5eZ.html#	0	f	0
869	n_788	http://lod.taxonconcept.org/ses/TofbR.html#	0	f	0
870	n_789	http://lod.taxonconcept.org/ses/5dTwp.html#	0	f	0
871	n_790	http://lod.taxonconcept.org/ses/hs8WL.html#	0	f	0
872	n_791	http://lod.taxonconcept.org/ses/OvsHQ.html#	0	f	0
873	n_792	http://lod.taxonconcept.org/ses/onbrF.rdf#	0	f	0
874	n_793	http://lod.taxonconcept.org/ses/MdROc.html#	0	f	0
875	n_794	http://lod.taxonconcept.org/ses/4E57e.rdf#	0	f	0
876	n_795	http://lod.taxonconcept.org/ses/74owc.html#	0	f	0
877	n_796	http://lod.taxonconcept.org/ses/JEjhv.html#	0	f	0
878	n_797	http://lod.taxonconcept.org/ses/yCkp9.html#	0	f	0
879	n_798	http://lod.taxonconcept.org/ses/eZs9Q.html#	0	f	0
880	n_799	http://lod.taxonconcept.org/ses/OqNd2.html#	0	f	0
881	n_800	http://lod.taxonconcept.org/ses/ZcfSK.rdf#	0	f	0
882	n_801	http://lod.taxonconcept.org/ses/kbHmd.html#	0	f	0
883	n_802	http://lod.taxonconcept.org/ses/VVYMq.html#	0	f	0
884	n_803	http://lod.taxonconcept.org/ses/I3KlC.html#	0	f	0
885	n_804	http://lod.taxonconcept.org/ses/g67jC.html#	0	f	0
886	n_805	http://lod.taxonconcept.org/ses/87FpO.html#	0	f	0
887	n_806	http://lod.taxonconcept.org/ses/HPseh.rdf#	0	f	0
888	n_807	http://lod.taxonconcept.org/ses/87FpO.rdf#	0	f	0
889	n_808	http://lod.taxonconcept.org/ses/ePG6H.html#	0	f	0
890	n_809	http://lod.taxonconcept.org/ses/dFsc7.rdf#	0	f	0
891	n_810	http://lod.taxonconcept.org/ses/2OVJR.html#	0	f	0
892	n_811	http://lod.taxonconcept.org/ses/g3pnZ.rdf#	0	f	0
893	n_812	http://lod.taxonconcept.org/ses/45G3w.html#	0	f	0
894	n_813	http://lod.taxonconcept.org/ses/4xaly.html#	0	f	0
895	n_814	http://lod.taxonconcept.org/ses/ruKFm.html#	0	f	0
896	n_815	http://lod.taxonconcept.org/ses/a43ba.html#	0	f	0
897	n_816	http://lod.taxonconcept.org/ses/Uc2wY.rdf#	0	f	0
898	n_817	http://lod.taxonconcept.org/ses/AbVPk.rdf#	0	f	0
899	n_818	http://lod.taxonconcept.org/ses/ldYvw.html#	0	f	0
900	n_819	http://lod.taxonconcept.org/ses/2wS2P.rdf#	0	f	0
901	n_820	http://lod.taxonconcept.org/ses/pmaz9.html#	0	f	0
902	n_821	http://lod.taxonconcept.org/ses/UkNOJ.html#	0	f	0
903	n_822	http://lod.taxonconcept.org/ses/itdft.html#	0	f	0
904	n_823	https://data.archives-ouvertes.fr/doctype/	0	f	0
905	n_824	http://lod.taxonconcept.org/ses/NwonD.rdf#	0	f	0
906	n_825	http://lod.taxonconcept.org/ses/kIc5N.rdf#	0	f	0
907	n_826	http://lod.taxonconcept.org/ses/OJayI.html#	0	f	0
908	n_827	http://lod.taxonconcept.org/ses/2bDWt.html#	0	f	0
909	n_828	http://lod.taxonconcept.org/ses/wNzoi.rdf#	0	f	0
910	n_829	http://lod.taxonconcept.org/ses/dxKfG.html#	0	f	0
911	n_830	http://lod.taxonconcept.org/ses/wQF9v.html#	0	f	0
912	n_831	http://lod.taxonconcept.org/ses/HfMaF.rdf#	0	f	0
913	n_832	http://lod.taxonconcept.org/ses/OHpAN.html#	0	f	0
914	n_833	http://lod.taxonconcept.org/ses/m3Ozp.rdf#	0	f	0
915	n_834	http://lod.taxonconcept.org/ses/xj7z8.rdf#	0	f	0
916	n_835	http://lod.taxonconcept.org/ses/zfotr.rdf#	0	f	0
917	n_836	http://lod.taxonconcept.org/ses/8PXcL.html#	0	f	0
918	n_837	http://lod.taxonconcept.org/ses/OpeLP.html#	0	f	0
919	n_838	http://lod.taxonconcept.org/ses/s32nE.html#	0	f	0
920	n_839	http://lod.taxonconcept.org/ses/UmjVg.html#	0	f	0
921	n_840	http://lod.taxonconcept.org/ses/sBSUL.html#	0	f	0
922	n_841	http://lod.taxonconcept.org/ses/ar4Fe.html#	0	f	0
923	n_842	http://lod.taxonconcept.org/ses/2hSQr.html#	0	f	0
924	n_843	http://lod.taxonconcept.org/ses/AvyKU.html#	0	f	0
925	n_844	http://lod.taxonconcept.org/ses/hHckq.html#	0	f	0
926	n_845	http://lod.taxonconcept.org/ses/VEbVW.rdf#	0	f	0
927	n_846	http://lod.taxonconcept.org/ses/IB4Hf.rdf#	0	f	0
928	n_847	http://lod.taxonconcept.org/ses/4ADEI.rdf#	0	f	0
929	n_848	http://lod.taxonconcept.org/ses/pheD9.html#	0	f	0
930	n_849	http://lod.taxonconcept.org/ses/m3Ozp.html#	0	f	0
931	n_850	http://lod.taxonconcept.org/ses/gtvtr.rdf#	0	f	0
932	n_851	http://lod.taxonconcept.org/ses/nmWc7.html#	0	f	0
933	n_852	http://lod.taxonconcept.org/ses/yPMp6.html#	0	f	0
934	n_853	http://lod.taxonconcept.org/ses/raMe2.html#	0	f	0
935	n_854	http://lod.taxonconcept.org/ses/7DOvU.html#	0	f	0
936	n_855	http://lod.taxonconcept.org/ses/4xaly.rdf#	0	f	0
937	n_856	http://lod.taxonconcept.org/ses/Y647H.rdf#	0	f	0
938	n_857	http://taxref.mnhn.fr/lod/loc/	0	f	0
939	n_858	http://lod.taxonconcept.org/ses/7iUem.html#	0	f	0
940	n_859	http://lod.taxonconcept.org/ses/z3VMA.html#	0	f	0
941	n_860	http://lod.taxonconcept.org/ses/IJVMg.html#	0	f	0
942	n_861	http://lod.taxonconcept.org/ses/4EHzr.html#	0	f	0
943	n_862	http://lod.taxonconcept.org/ses/l8qzl.html#	0	f	0
944	n_863	http://lod.taxonconcept.org/ses/mh4ez.html#	0	f	0
945	n_864	http://lod.taxonconcept.org/ses/DVkdS.html#	0	f	0
946	n_865	http://lod.taxonconcept.org/ses/dTcrt.html#	0	f	0
947	n_866	http://lod.taxonconcept.org/ses/EwpcL.html#	0	f	0
948	n_867	http://lod.taxonconcept.org/ses/qBelG.html#	0	f	0
949	n_868	http://lod.taxonconcept.org/ses/VzwRC.html#	0	f	0
950	n_869	http://lod.taxonconcept.org/ses/tkMBF.rdf#	0	f	0
951	n_870	http://lod.taxonconcept.org/ses/pDWjR.rdf#	0	f	0
952	n_871	http://lod.taxonconcept.org/ses/wQT7j.rdf#	0	f	0
953	n_872	http://lod.taxonconcept.org/ses/yqkNV.html#	0	f	0
954	n_873	http://lod.taxonconcept.org/ses/YVZ2V.rdf#	0	f	0
955	n_874	http://lod.taxonconcept.org/ses/wVrLq.rdf#	0	f	0
956	n_875	http://lod.taxonconcept.org/ses/EoIzu.html#	0	f	0
957	n_876	http://lod.taxonconcept.org/ses/IdV8v.rdf#	0	f	0
958	n_877	http://lod.taxonconcept.org/ses/N6mpR.rdf#	0	f	0
959	n_878	http://lod.taxonconcept.org/ses/6CpaW.rdf#	0	f	0
960	n_879	http://lod.taxonconcept.org/ses/AbVPk.html#	0	f	0
961	n_880	http://lod.taxonconcept.org/ses/AvyKU.rdf#	0	f	0
962	n_881	http://lod.taxonconcept.org/ses/GoFRJ.rdf#	0	f	0
963	n_882	http://lod.taxonconcept.org/ses/j3zOQ.rdf#	0	f	0
964	n_883	http://lod.taxonconcept.org/ses/KfOVX.html#	0	f	0
965	n_884	http://lod.taxonconcept.org/ses/QZUKm.rdf#	0	f	0
966	n_885	http://lod.taxonconcept.org/ses/OlIuv.html#	0	f	0
967	n_886	http://lod.taxonconcept.org/ses/n78LR.html#	0	f	0
968	n_887	http://lod.taxonconcept.org/ses/mYtsK.html#	0	f	0
969	n_888	http://lod.taxonconcept.org/ses/mdkiV.html#	0	f	0
970	n_889	http://lod.taxonconcept.org/ses/aF5ti.html#	0	f	0
971	n_890	http://lod.taxonconcept.org/ses/G7BFS.html#	0	f	0
972	n_891	http://lod.taxonconcept.org/ses/TbdII.html#	0	f	0
973	n_892	http://lod.taxonconcept.org/ses/3NTpp.html#	0	f	0
974	n_893	http://lod.taxonconcept.org/ses/iD4vM.html#	0	f	0
975	n_894	http://lod.taxonconcept.org/ses/yjsfm.html#	0	f	0
976	n_895	http://lod.taxonconcept.org/ses/EoIzu.rdf#	0	f	0
977	n_896	http://lod.taxonconcept.org/ses/BnOrx.rdf#	0	f	0
978	n_897	http://lod.taxonconcept.org/ses/LAn6h.rdf#	0	f	0
979	n_898	http://lod.taxonconcept.org/ses/TT6Fu.html#	0	f	0
980	n_899	http://lod.taxonconcept.org/ses/PCxUF.rdf#	0	f	0
981	n_900	http://lod.taxonconcept.org/ses/j3zOQ.html#	0	f	0
982	n_901	http://lod.taxonconcept.org/ses/ZZaxg.html#	0	f	0
983	n_902	http://lod.taxonconcept.org/ses/AhnLm.html#	0	f	0
984	n_903	http://lod.taxonconcept.org/ses/ejeV7.rdf#	0	f	0
985	n_904	http://lod.taxonconcept.org/ses/Z8Qbe.rdf#	0	f	0
986	n_905	http://lod.taxonconcept.org/ses/waK4b.rdf#	0	f	0
987	n_906	http://lod.taxonconcept.org/ses/QQNTS.html#	0	f	0
988	n_907	http://lod.taxonconcept.org/ses/HHEk3.html#	0	f	0
989	n_908	http://lod.taxonconcept.org/ses/ejrfw.html#	0	f	0
990	n_909	http://lod.taxonconcept.org/ses/hM7ra.html#	0	f	0
991	n_910	http://lod.taxonconcept.org/ses/s7qFS.html#	0	f	0
992	n_911	http://lod.taxonconcept.org/ses/UENfF.html#	0	f	0
993	n_912	http://lod.taxonconcept.org/ses/jYrH5.html#	0	f	0
994	n_913	http://lod.taxonconcept.org/ses/O5CP2.html#	0	f	0
995	n_914	http://lod.taxonconcept.org/ses/qsSwX.html#	0	f	0
996	n_915	http://lod.taxonconcept.org/ses/OFtuS.rdf#	0	f	0
997	n_916	http://lod.taxonconcept.org/ses/iBxm9.rdf#	0	f	0
998	n_917	http://lod.taxonconcept.org/ses/xb4r5.html#	0	f	0
999	n_918	http://lod.taxonconcept.org/ses/TSZLI.html#	0	f	0
1000	n_919	http://lod.taxonconcept.org/ses/YArSj.html#	0	f	0
1001	n_920	http://lod.taxonconcept.org/ses/vRXWD.html#	0	f	0
1002	n_921	http://lod.taxonconcept.org/ses/G6Mof.html#	0	f	0
1003	n_922	http://lod.taxonconcept.org/ses/gwKUF.html#	0	f	0
1004	n_923	http://lod.taxonconcept.org/ses/LVxnZ.html#	0	f	0
1005	n_924	http://lod.taxonconcept.org/ses/mddSP.html#	0	f	0
1006	n_925	http://lod.taxonconcept.org/ses/y6jvL.rdf#	0	f	0
1007	n_926	http://lod.taxonconcept.org/ses/6CpaW.html#	0	f	0
1008	n_927	http://lod.taxonconcept.org/ses/6AiWm.rdf#	0	f	0
1009	n_928	http://lod.taxonconcept.org/ses/MYQMc.html#	0	f	0
1010	n_929	http://lod.taxonconcept.org/ses/kMccV.html#	0	f	0
1011	n_930	http://lod.taxonconcept.org/ses/k7HvH.html#	0	f	0
1012	n_931	http://lod.taxonconcept.org/ses/Vts5z.rdf#	0	f	0
1013	n_932	http://lod.taxonconcept.org/ses/NV5w5.html#	0	f	0
1014	n_933	http://lod.taxonconcept.org/ses/DJEZ3.rdf#	0	f	0
1015	n_934	http://lod.taxonconcept.org/ses/2oeGw.html#	0	f	0
1016	n_935	http://lod.taxonconcept.org/ses/Pvfap.html#	0	f	0
1017	n_936	http://lod.taxonconcept.org/ses/5Tpbq.html#	0	f	0
1018	n_937	http://lod.taxonconcept.org/ses/UtAjU.html#	0	f	0
1019	n_938	http://lod.taxonconcept.org/ses/OZDTr.html#	0	f	0
1020	n_939	http://lod.taxonconcept.org/ses/OJEaQ.rdf#	0	f	0
1021	n_940	http://lod.taxonconcept.org/ses/YVZ2V.html#	0	f	0
1022	n_941	http://lod.taxonconcept.org/ses/wVMFV.rdf#	0	f	0
1023	n_942	http://lod.taxonconcept.org/ses/2AD3s.html#	0	f	0
1024	n_943	http://lod.taxonconcept.org/ses/mQ9Bq.html#	0	f	0
1025	n_944	http://lod.taxonconcept.org/ses/mQ9Bq.rdf#	0	f	0
1026	n_945	http://lod.taxonconcept.org/ses/aaZRA.html#	0	f	0
1027	n_946	http://lod.taxonconcept.org/ses/QTYha.html#	0	f	0
1028	n_947	http://lod.taxonconcept.org/ses/CuKKT.html#	0	f	0
1029	n_948	http://lod.taxonconcept.org/ses/JXuUT.html#	0	f	0
1030	n_949	http://lod.taxonconcept.org/ses/PSZQp.html#	0	f	0
1031	n_950	http://lod.taxonconcept.org/ses/zXvuQ.html#	0	f	0
1032	n_951	http://lod.taxonconcept.org/ses/Z8Qbe.html#	0	f	0
1033	n_952	http://lod.taxonconcept.org/ses/CsmOq.rdf#	0	f	0
1034	n_953	http://lod.taxonconcept.org/ses/xRff3.html#	0	f	0
1035	n_954	http://lod.taxonconcept.org/ses/HHAha.html#	0	f	0
1036	n_955	http://lod.taxonconcept.org/ses/vMHzJ.html#	0	f	0
1037	n_956	http://lod.taxonconcept.org/ses/iOj2u.html#	0	f	0
1038	n_957	http://lod.taxonconcept.org/ses/xdmBh.rdf#	0	f	0
1039	n_958	http://lod.taxonconcept.org/ses/dmy7u.html#	0	f	0
1040	n_959	http://lod.taxonconcept.org/ses/KRLYP.html#	0	f	0
1041	n_960	http://lod.taxonconcept.org/ses/hcxFU.html#	0	f	0
1042	n_961	http://lod.taxonconcept.org/ses/uVdxi.html#	0	f	0
1043	oplacl	http://www.openlinksw.com/ontology/acl#	0	f	0
1044	n_962	http://rs.tdwg.org/ontology/voc/TaxonRank#	0	f	0
1045	n_963	http://lod.taxonconcept.org/ses/zseFr.html#	0	f	0
1046	n_964	http://lod.taxonconcept.org/ses/ITHVA.html#	0	f	0
1047	n_965	http://lod.taxonconcept.org/ses/z3Rtq.rdf#	0	f	0
1048	n_966	http://lod.taxonconcept.org/ses/zTYd3.rdf#	0	f	0
1049	n_967	http://lod.taxonconcept.org/ses/lPpMB.html#	0	f	0
1050	n_968	http://lod.taxonconcept.org/ses/D8qet.rdf#	0	f	0
1051	n_969	http://lod.taxonconcept.org/ses/J8XNW.html#	0	f	0
1052	n_970	http://lod.taxonconcept.org/ses/wFWTd.html#	0	f	0
1053	n_971	http://lod.taxonconcept.org/ses/rVPHV.html#	0	f	0
1054	n_972	http://lod.taxonconcept.org/ses/nlvkB.rdf#	0	f	0
1055	n_973	http://lod.taxonconcept.org/ses/zxUAV.html#	0	f	0
1056	n_974	http://lod.taxonconcept.org/ses/ngNtd.html#	0	f	0
1057	n_975	http://lod.taxonconcept.org/ses/xowGc.html#	0	f	0
1058	n_976	http://lod.taxonconcept.org/ses/HfMaF.html#	0	f	0
1059	n_977	http://lod.taxonconcept.org/ses/WVwE7.rdf#	0	f	0
1060	n_978	http://lod.taxonconcept.org/ses/7fvpi.html#	0	f	0
1061	n_979	http://lod.taxonconcept.org/ses/GsOo4.html#	0	f	0
1062	n_980	http://lod.taxonconcept.org/ses/CaK98.rdf#	0	f	0
1063	n_981	http://lod.taxonconcept.org/ses/xEFUR.html#	0	f	0
1064	n_982	http://lod.taxonconcept.org/ses/z2ilb.rdf#	0	f	0
1065	n_983	http://lod.taxonconcept.org/ses/nnt7Z.rdf#	0	f	0
1066	n_984	http://lod.taxonconcept.org/ses/4hZMP.html#	0	f	0
1067	n_985	http://lod.taxonconcept.org/ses/kIc5N.html#	0	f	0
1068	n_986	http://lod.taxonconcept.org/ses/KOlsc.html#	0	f	0
1069	n_987	http://lod.taxonconcept.org/ses/4QNQ3.html#	0	f	0
1070	n_988	http://lod.taxonconcept.org/ses/9wxsa.html#	0	f	0
1071	n_989	http://lod.taxonconcept.org/ses/QMUrD.html#	0	f	0
1072	n_990	http://lod.taxonconcept.org/ses/lrwfL.html#	0	f	0
1073	n_991	http://lod.taxonconcept.org/ses/JGQFa.html#	0	f	0
1074	n_992	http://lod.taxonconcept.org/ses/yRW2E.rdf#	0	f	0
1075	n_993	http://lod.taxonconcept.org/ses/4sOTC.html#	0	f	0
1076	n_994	http://lod.taxonconcept.org/ses/IA3ZS.html#	0	f	0
1077	n_995	http://lod.taxonconcept.org/ses/7s8nk.html#	0	f	0
1078	n_996	http://lod.taxonconcept.org/ses/H83ZL.html#	0	f	0
1079	n_997	http://lod.taxonconcept.org/ses/ViTHS.html#	0	f	0
1080	n_998	http://lod.taxonconcept.org/ses/x8xCX.html#	0	f	0
1081	n_999	http://lod.taxonconcept.org/ses/zjxo4.html#	0	f	0
1082	n_1000	http://lod.taxonconcept.org/ses/g5ray.html#	0	f	0
1083	n_1001	http://lod.taxonconcept.org/ses/fnhuq.rdf#	0	f	0
1084	n_1002	http://lod.taxonconcept.org/ses/JzyMo.html#	0	f	0
1085	n_1003	http://lod.taxonconcept.org/ses/mcWUg.html#	0	f	0
1086	n_1004	http://lod.taxonconcept.org/ses/py5ST.rdf#	0	f	0
1087	n_1005	http://lod.taxonconcept.org/ses/yKMjt.rdf#	0	f	0
1088	n_1006	http://lod.taxonconcept.org/ses/W5fWB.html#	0	f	0
1089	n_1007	http://lod.taxonconcept.org/ses/CaK98.html#	0	f	0
1090	n_1008	http://lod.taxonconcept.org/ses/z3dMP.html#	0	f	0
1091	n_1009	http://lod.taxonconcept.org/ses/VzwRC.rdf#	0	f	0
1092	n_1010	http://lod.taxonconcept.org/ses/G9WHN.html#	0	f	0
1093	n_1011	http://lod.taxonconcept.org/ses/KtY5J.html#	0	f	0
1094	n_1012	http://lod.taxonconcept.org/ses/Zom2X.html#	0	f	0
1095	n_1013	http://lod.taxonconcept.org/ses/r8QqF.rdf#	0	f	0
1096	n_1014	http://lod.taxonconcept.org/ses/Lb2PC.html#	0	f	0
1097	n_1015	http://lod.taxonconcept.org/ses/J8IR3.html#	0	f	0
1098	n_1016	http://lod.taxonconcept.org/ses/34X66.html#	0	f	0
1099	n_1017	http://lod.taxonconcept.org/ses/fJamf.rdf#	0	f	0
1100	n_1018	http://lod.taxonconcept.org/ses/f9DFp.html#	0	f	0
1101	n_1019	http://lod.taxonconcept.org/ses/qhAsM.html#	0	f	0
1102	n_1020	http://lod.taxonconcept.org/ses/R5Pkg.html#	0	f	0
1103	n_1021	http://lod.taxonconcept.org/ses/R5Pkg.rdf#	0	f	0
1104	n_1022	http://lod.taxonconcept.org/ses/F8kQB.html#	0	f	0
1105	n_1023	http://lod.taxonconcept.org/ses/HOaYm.html#	0	f	0
1106	n_1024	http://lod.taxonconcept.org/ses/5IHYs.html#	0	f	0
1107	n_1025	http://lod.taxonconcept.org/ses/VLdbe.html#	0	f	0
1108	n_1026	http://lod.taxonconcept.org/ses/TyNjg.rdf#	0	f	0
1109	n_1027	http://lod.taxonconcept.org/ses/6AiWm.html#	0	f	0
1110	n_1028	http://lod.taxonconcept.org/ses/PfzSj.rdf#	0	f	0
1111	n_1029	http://lod.taxonconcept.org/ses/nM3cP.html#	0	f	0
1112	n_1030	http://lod.taxonconcept.org/ses/qw2tb.rdf#	0	f	0
1113	n_1031	http://lod.taxonconcept.org/ses/wbUJ4.html#	0	f	0
1114	n_1032	http://lod.taxonconcept.org/ses/Zom2X.rdf#	0	f	0
1115	n_1033	http://lod.taxonconcept.org/ses/ICmLC.rdf#	0	f	0
1116	n_1034	http://lod.taxonconcept.org/ses/dwAmr.rdf#	0	f	0
1117	n_1035	http://lod.taxonconcept.org/ses/ogw3l.rdf#	0	f	0
1118	n_1036	http://lod.taxonconcept.org/ses/2Dqxa.html#	0	f	0
1119	n_1037	http://lod.taxonconcept.org/ses/rdubQ.html#	0	f	0
1120	n_1038	http://lod.taxonconcept.org/ses/MLtJ8.rdf#	0	f	0
1121	n_1039	http://lod.taxonconcept.org/ses/KOlsc.rdf#	0	f	0
1122	n_1040	http://lod.taxonconcept.org/ses/ZcfSK.html#	0	f	0
1123	n_1041	http://lod.taxonconcept.org/ses/QmJnc.html#	0	f	0
1124	n_1042	http://lod.taxonconcept.org/ses/GrQWJ.rdf#	0	f	0
1125	n_1043	http://lod.taxonconcept.org/ses/UflQJ.html#	0	f	0
1126	n_1044	http://lod.taxonconcept.org/ses/htm2P.rdf#	0	f	0
1127	n_1045	http://lod.taxonconcept.org/ses/QqiZf.html#	0	f	0
1128	n_1046	http://lod.taxonconcept.org/ses/LnT5s.rdf#	0	f	0
1129	n_1047	http://lod.taxonconcept.org/ses/4GtQh.html#	0	f	0
1130	n_1048	http://lod.taxonconcept.org/ses/VpJ5l.html#	0	f	0
1131	n_1049	http://lod.taxonconcept.org/ses/ECftr.html#	0	f	0
1132	n_1050	http://lod.taxonconcept.org/ses/uDbnq.rdf#	0	f	0
1133	n_1051	http://lod.taxonconcept.org/ses/dFsc7.html#	0	f	0
1134	n_1052	http://lod.taxonconcept.org/ses/uDNbR.html#	0	f	0
1135	n_1053	http://lod.taxonconcept.org/ses/JHVvp.html#	0	f	0
1136	n_1054	http://lod.taxonconcept.org/ses/Sw7iu.rdf#	0	f	0
1137	n_1055	http://lod.taxonconcept.org/ses/kIZ8s.html#	0	f	0
1138	n_1056	http://lod.taxonconcept.org/ses/4ADEI.html#	0	f	0
1139	n_1057	http://lod.taxonconcept.org/ses/9QkhN.html#	0	f	0
1140	n_1058	http://lod.taxonconcept.org/ses/6rlfn.html#	0	f	0
1141	n_1059	http://lod.taxonconcept.org/ses/bPQnF.html#	0	f	0
1142	n_1060	http://lod.taxonconcept.org/ses/eYgn3.html#	0	f	0
1143	n_1061	http://lod.taxonconcept.org/ses/7DOvU.rdf#	0	f	0
1144	n_1062	http://lod.taxonconcept.org/ses/JnCq2.html#	0	f	0
1145	n_1063	http://lod.taxonconcept.org/ses/tDVRu.html#	0	f	0
1146	n_1064	http://lod.taxonconcept.org/ses/GyhRg.html#	0	f	0
1147	n_1065	http://lod.taxonconcept.org/ses/4krYG.html#	0	f	0
1148	n_1066	http://lod.taxonconcept.org/ses/q8iz4.html#	0	f	0
1149	n_1067	http://lod.taxonconcept.org/ses/kg5kx.rdf#	0	f	0
1150	n_1068	http://lod.taxonconcept.org/ses/3JMAC.html#	0	f	0
1151	n_1069	http://lod.taxonconcept.org/ses/8fG4V.rdf#	0	f	0
1152	n_1070	http://lod.taxonconcept.org/ses/EG3o2.html#	0	f	0
1153	n_1071	http://lod.taxonconcept.org/ses/nOhRO.html#	0	f	0
1154	n_1072	http://lod.taxonconcept.org/ses/OhvDL.rdf#	0	f	0
1155	n_1073	http://lod.taxonconcept.org/ses/xdmBh.html#	0	f	0
1156	n_1074	http://lod.taxonconcept.org/ses/BolZ6.html#	0	f	0
1157	n_1075	http://lod.taxonconcept.org/ses/dwAmr.html#	0	f	0
1158	n_1076	http://lod.taxonconcept.org/ses/AFYz2.html#	0	f	0
1159	n_1077	http://lod.taxonconcept.org/ses/dGOc2.html#	0	f	0
1160	n_1078	http://lod.taxonconcept.org/ses/AFvhh.html#	0	f	0
1161	n_1079	http://lod.taxonconcept.org/ses/dXEgr.html#	0	f	0
1162	n_1080	http://lod.taxonconcept.org/ses/py5ST.html#	0	f	0
1163	n_1081	http://lod.taxonconcept.org/ses/3ZiXC.html#	0	f	0
1164	n_1082	http://lod.taxonconcept.org/ses/aE6v7.html#	0	f	0
1165	n_1083	http://lod.taxonconcept.org/ses/fnhuq.html#	0	f	0
1166	n_1084	http://lod.taxonconcept.org/ses/okb3g.html#	0	f	0
1167	n_1085	http://lod.taxonconcept.org/ses/rrljI.html#	0	f	0
1168	n_1086	http://lod.taxonconcept.org/ses/T6N6t.html#	0	f	0
1169	n_1087	http://lod.taxonconcept.org/ses/vuoEA.html#	0	f	0
1170	n_1088	http://lod.taxonconcept.org/ses/ifobC.rdf#	0	f	0
1171	n_1089	http://lod.taxonconcept.org/ses/ifobC.html#	0	f	0
1172	n_1090	http://lod.taxonconcept.org/ses/aJize.html#	0	f	0
1173	n_1091	http://lod.taxonconcept.org/ses/XNbWx.html#	0	f	0
1174	n_1092	http://lod.taxonconcept.org/ses/LnT5s.html#	0	f	0
1175	n_1093	http://lod.taxonconcept.org/ses/GyhRg.rdf#	0	f	0
1176	n_1094	http://lod.taxonconcept.org/ses/N7mve.html#	0	f	0
1177	n_1095	http://lod.taxonconcept.org/ses/vDLFB.html#	0	f	0
1178	n_1096	http://lod.taxonconcept.org/ses/CTZ8z.html#	0	f	0
1179	n_1097	http://lod.taxonconcept.org/ses/Moj7i.html#	0	f	0
1180	sdo	https://schema.org/	0	f	0
1181	n_1098	http://lod.taxonconcept.org/ses/GsOo4.rdf#	0	f	0
1182	n_1099	http://lod.taxonconcept.org/ses/IdV8v.html#	0	f	0
1183	n_1100	http://lod.taxonconcept.org/ses/zfotr.html#	0	f	0
1184	n_1101	http://lod.taxonconcept.org/ses/q8iz4.rdf#	0	f	0
1185	n_1102	http://lod.taxonconcept.org/ses/GFUyO.html#	0	f	0
1186	n_1103	http://lod.taxonconcept.org/ses/Yfjoo.html#	0	f	0
1187	n_1104	http://lod.taxonconcept.org/ses/MLtJ8.html#	0	f	0
1188	n_1105	http://lod.taxonconcept.org/ses/IASf2.html#	0	f	0
1189	n_1106	http://lod.taxonconcept.org/ses/wNzoi.html#	0	f	0
1190	n_1107	http://lod.taxonconcept.org/ses/d3gmb.rdf#	0	f	0
1191	n_1108	http://lod.taxonconcept.org/ses/XpCne.html#	0	f	0
1192	n_1109	http://lod.taxonconcept.org/ses/hazSC.html#	0	f	0
1193	n_1110	http://lod.taxonconcept.org/ses/eoA5c.html#	0	f	0
1194	n_1111	http://lod.taxonconcept.org/ses/qw2tb.html#	0	f	0
1195	n_1112	http://lod.taxonconcept.org/ses/lUyDP.html#	0	f	0
1196	n_1113	http://lod.taxonconcept.org/ses/TyNjg.html#	0	f	0
1197	n_1114	http://lod.taxonconcept.org/ses/d3gmb.html#	0	f	0
1198	n_1115	http://lod.taxonconcept.org/ses/gfGoP.html#	0	f	0
1199	n_1116	http://lod.taxonconcept.org/ses/PCvHu.html#	0	f	0
1200	n_1117	http://lod.taxonconcept.org/ses/6iNmT.html#	0	f	0
1201	n_1118	http://lod.taxonconcept.org/ses/pFZTS.rdf#	0	f	0
1202	n_1119	http://lod.taxonconcept.org/ses/ASpsq.rdf#	0	f	0
1203	n_1120	http://lod.taxonconcept.org/ses/JhEQA.rdf#	0	f	0
1204	n_1121	http://lod.taxonconcept.org/ses/bQVv3.html#	0	f	0
1205	n_1122	http://lod.taxonconcept.org/ses/Vs8zU.html#	0	f	0
1206	n_1123	http://lod.taxonconcept.org/ses/t5Fmw.rdf#	0	f	0
1207	n_1124	http://lod.taxonconcept.org/ses/tkMBF.html#	0	f	0
1208	n_1125	http://lod.taxonconcept.org/ses/I8M9f.html#	0	f	0
1209	n_1126	http://lod.taxonconcept.org/ses/kbHmd.rdf#	0	f	0
1210	n_1127	http://lod.taxonconcept.org/ses/aJize.rdf#	0	f	0
1211	n_1128	http://lod.taxonconcept.org/ses/nHt7g.html#	0	f	0
1212	n_1129	http://lod.taxonconcept.org/ses/rOFB9.html#	0	f	0
1213	n_1130	http://lod.taxonconcept.org/ses/JhEQA.html#	0	f	0
1214	n_1131	http://lod.taxonconcept.org/ses/dGA7c.rdf#	0	f	0
1215	n_1132	http://lod.taxonconcept.org/ses/uej8m.html#	0	f	0
1216	n_1133	http://lod.taxonconcept.org/ses/yJV4R.html#	0	f	0
1217	n_1134	http://lod.taxonconcept.org/ses/N5gCO.html#	0	f	0
1218	n_1135	http://lod.taxonconcept.org/ses/ucHx6.rdf#	0	f	0
1219	n_1136	http://lod.taxonconcept.org/ses/Lr3Ym.html#	0	f	0
1220	n_1137	http://lod.taxonconcept.org/ses/slHlq.html#	0	f	0
1221	n_1138	http://lod.taxonconcept.org/ses/Fpnvz.html#	0	f	0
1222	n_1139	http://lod.taxonconcept.org/ses/GTgtA.html#	0	f	0
1223	n_1140	http://lod.taxonconcept.org/ses/XmjNm.html#	0	f	0
1224	n_1141	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
1225	n_1142	http://lod.taxonconcept.org/ses/Msb9D.html#	0	f	0
1226	n_1143	http://lod.taxonconcept.org/ses/3wxvo.html#	0	f	0
1227	n_1144	http://lod.taxonconcept.org/ses/Z2OP8.html#	0	f	0
1228	n_1145	http://lod.taxonconcept.org/ses/gBmxL.html#	0	f	0
1229	n_1146	http://lod.taxonconcept.org/ses/obd3m.html#	0	f	0
1230	n_1147	http://lod.taxonconcept.org/ses/g3pnZ.html#	0	f	0
1231	n_1148	http://lod.taxonconcept.org/ses/u8oxZ.html#	0	f	0
1232	n_1149	http://lod.taxonconcept.org/ses/tFejO.html#	0	f	0
1233	n_1150	http://lod.taxonconcept.org/ses/Iq3nt.html#	0	f	0
1234	n_1151	http://lod.taxonconcept.org/ses/XH8es.html#	0	f	0
1235	n_1152	http://lod.taxonconcept.org/ses/QNRma.html#	0	f	0
1236	n_1153	http://lod.taxonconcept.org/ses/wWxWA.html#	0	f	0
1237	n_1154	http://lod.taxonconcept.org/ses/rdubQ.rdf#	0	f	0
1238	n_1155	http://lod.taxonconcept.org/ses/cU7WZ.html#	0	f	0
1239	n_1156	http://lod.taxonconcept.org/ses/ZdhkS.html#	0	f	0
1240	n_1157	http://lod.taxonconcept.org/ses/u6Qgt.html#	0	f	0
1241	n_1158	http://lod.taxonconcept.org/ses/3yF9U.html#	0	f	0
1242	n_1159	http://lod.taxonconcept.org/ses/fFwMo.html#	0	f	0
1243	n_1160	http://lod.taxonconcept.org/ses/PDdyp.html#	0	f	0
1244	n_1161	http://lod.taxonconcept.org/ses/NoloC.html#	0	f	0
1245	n_1162	http://lod.taxonconcept.org/ses/uh3Rg.html#	0	f	0
1246	n_1163	http://lod.taxonconcept.org/ses/Zwn8A.html#	0	f	0
1247	n_1164	http://lod.taxonconcept.org/ses/k9fVp.html#	0	f	0
1248	n_1165	http://lod.taxonconcept.org/ses/ZZSyS.html#	0	f	0
1249	n_1166	http://lod.taxonconcept.org/ses/BAhHL.html#	0	f	0
1250	n_1167	http://lod.taxonconcept.org/ses/6ATjy.html#	0	f	0
1251	n_1168	http://lod.taxonconcept.org/ses/iRnzQ.html#	0	f	0
1252	n_1169	http://lod.taxonconcept.org/ses/IHHNf.html#	0	f	0
1253	n_1170	http://lod.taxonconcept.org/ses/WmSCQ.html#	0	f	0
1254	n_1171	http://lod.taxonconcept.org/ses/yJV4R.rdf#	0	f	0
1255	n_1172	http://lod.taxonconcept.org/ses/Zpm2A.html#	0	f	0
1256	n_1173	http://lod.taxonconcept.org/ses/e4rKE.html#	0	f	0
1257	n_1174	http://lod.taxonconcept.org/ses/eVSXV.html#	0	f	0
1258	n_1175	http://lod.taxonconcept.org/ses/PRL6j.html#	0	f	0
1259	n_1176	http://lod.taxonconcept.org/ses/OhvDL.html#	0	f	0
1260	n_1177	http://lod.taxonconcept.org/ses/vS5nY.rdf#	0	f	0
1261	n_1178	http://lod.taxonconcept.org/ses/Y647H.html#	0	f	0
1262	n_1179	http://lod.taxonconcept.org/ses/cCZRL.rdf#	0	f	0
1263	n_1180	http://lod.taxonconcept.org/ses/Vo6he.html#	0	f	0
1264	n_1181	http://lod.taxonconcept.org/ses/Bk9pZ.html#	0	f	0
1265	n_1182	http://lod.taxonconcept.org/ses/u2iJX.html#	0	f	0
1266	n_1183	http://lod.taxonconcept.org/ses/yEPuc.html#	0	f	0
1267	n_1184	http://lod.taxonconcept.org/ses/RKFoG.html#	0	f	0
1268	n_1185	http://lod.taxonconcept.org/ses/r8QqF.html#	0	f	0
1269	n_1186	http://lod.taxonconcept.org/ses/tJoHY.html#	0	f	0
1270	n_1187	http://lod.taxonconcept.org/ses/fJamf.html#	0	f	0
1271	n_1188	http://lod.taxonconcept.org/ses/MI82U.rdf#	0	f	0
1272	n_1189	http://lod.taxonconcept.org/ses/F9yxJ.html#	0	f	0
1273	n_1190	http://lod.taxonconcept.org/ses/Zwn8A.rdf#	0	f	0
1274	n_1191	http://lod.taxonconcept.org/ses/Cmm3r.html#	0	f	0
1275	n_1192	http://lod.taxonconcept.org/ses/XSZsk.html#	0	f	0
1276	n_1193	http://lod.taxonconcept.org/ses/KdO4e.html#	0	f	0
1277	n_1194	http://lod.taxonconcept.org/ses/kg5kx.html#	0	f	0
1278	n_1195	http://lod.taxonconcept.org/ses/IHHNf.rdf#	0	f	0
1279	n_1196	http://lod.taxonconcept.org/ses/MI82U.html#	0	f	0
1280	n_1197	http://lod.taxonconcept.org/ses/VEbVW.html#	0	f	0
1281	n_1198	http://lod.taxonconcept.org/ses/yRW2E.html#	0	f	0
1282	n_1199	http://lod.taxonconcept.org/ses/u5z7k.rdf#	0	f	0
1283	n_1200	http://lod.taxonconcept.org/ses/ucHx6.html#	0	f	0
1284	n_1201	http://lod.taxonconcept.org/ses/lNKo8.html#	0	f	0
1285	n_1202	http://lod.taxonconcept.org/ses/UEIab.html#	0	f	0
1286	n_1203	http://lod.taxonconcept.org/ses/wPxH9.html#	0	f	0
1287	n_1204	http://lod.taxonconcept.org/ses/Swiii.html#	0	f	0
1288	n_1205	http://lod.taxonconcept.org/ses/ECftr.rdf#	0	f	0
1289	n_1206	http://lod.taxonconcept.org/ses/bfHCN.html#	0	f	0
1290	n_1207	http://lod.taxonconcept.org/ses/IGhqK.html#	0	f	0
1291	n_1208	http://lod.taxonconcept.org/ses/xmwfI.rdf#	0	f	0
1292	n_1209	http://lod.taxonconcept.org/ses/JiAUZ.html#	0	f	0
1293	n_1210	http://lod.taxonconcept.org/ses/w2O2N.rdf#	0	f	0
1294	n_1211	http://lod.taxonconcept.org/ses/EkjTj.html#	0	f	0
1295	n_1212	http://lod.taxonconcept.org/ses/sZNTx.html#	0	f	0
1296	n_1213	http://lod.taxonconcept.org/ses/zTYd3.html#	0	f	0
1297	n_1214	http://lod.taxonconcept.org/ses/VmbzI.html#	0	f	0
1298	n_1215	http://lod.taxonconcept.org/ses/Imlsn.html#	0	f	0
1299	n_1216	http://lod.taxonconcept.org/ses/ExW6Q.html#	0	f	0
1300	n_1217	http://lod.taxonconcept.org/ses/WVwE7.html#	0	f	0
1301	n_1218	http://lod.taxonconcept.org/ses/3uE4e.html#	0	f	0
1302	n_1219	http://lod.taxonconcept.org/ses/B4grE.html#	0	f	0
1303	n_1220	http://lod.taxonconcept.org/ses/JYUlw.html#	0	f	0
1304	n_1221	http://lod.taxonconcept.org/ses/HvnDP.html#	0	f	0
1305	n_1222	http://lod.taxonconcept.org/ses/pFZTS.html#	0	f	0
1306	n_1223	http://lod.taxonconcept.org/ses/EvygK.html#	0	f	0
1307	n_1224	http://lod.taxonconcept.org/ses/ulNqc.html#	0	f	0
1308	n_1225	http://lod.taxonconcept.org/ses/TOKln.html#	0	f	0
1309	n_1226	http://lod.taxonconcept.org/ses/CTjra.html#	0	f	0
1310	n_1227	http://lod.taxonconcept.org/ses/XEpNj.html#	0	f	0
1311	n_1228	http://lod.taxonconcept.org/ses/RT7qP.html#	0	f	0
1312	n_1229	http://lod.taxonconcept.org/ses/jxIU7.html#	0	f	0
1313	n_1230	http://lod.taxonconcept.org/ses/OKN8Y.html#	0	f	0
1314	n_1231	http://lod.taxonconcept.org/ses/vS5nY.html#	0	f	0
1315	n_1232	http://lod.taxonconcept.org/ses/u5z7k.html#	0	f	0
1316	n_1233	http://lod.taxonconcept.org/ses/hC5xg.html#	0	f	0
1317	n_1234	http://lod.taxonconcept.org/ses/GTgtA.rdf#	0	f	0
1318	n_1235	http://lod.taxonconcept.org/ses/aFRYB.html#	0	f	0
1319	n_1236	http://lod.taxonconcept.org/ses/tnJr6.rdf#	0	f	0
1320	n_1237	http://lod.taxonconcept.org/ses/BiEsG.html#	0	f	0
1321	n_1238	http://lod.taxonconcept.org/ses/GrQWJ.html#	0	f	0
1322	n_1239	http://lod.taxonconcept.org/ses/wVrLq.html#	0	f	0
1323	n_1240	http://lod.taxonconcept.org/ses/xFcQi.html#	0	f	0
1324	n_1241	http://lod.taxonconcept.org/ses/TM9SC.html#	0	f	0
1325	n_1242	http://lod.taxonconcept.org/ses/PQLdJ.html#	0	f	0
1326	n_1243	http://lod.taxonconcept.org/ses/2fPxZ.html#	0	f	0
1327	n_1244	http://lod.taxonconcept.org/ses/irCf3.html#	0	f	0
1328	n_1245	http://lod.taxonconcept.org/ses/24NNq.html#	0	f	0
1329	n_1246	http://lod.taxonconcept.org/ses/SSFw3.html#	0	f	0
1330	n_1247	http://lod.taxonconcept.org/ses/47C3Q.html#	0	f	0
1331	n_1248	http://lod.taxonconcept.org/ses/9m9L2.html#	0	f	0
1332	n_1249	http://lod.taxonconcept.org/ses/ZoFhA.html#	0	f	0
1333	n_1250	http://lod.taxonconcept.org/ses/6GTSq.html#	0	f	0
1334	n_1251	http://lod.taxonconcept.org/ses/RqaGd.html#	0	f	0
1335	n_1252	http://lod.taxonconcept.org/ses/BYWpt.html#	0	f	0
1336	n_1253	http://lod.taxonconcept.org/ses/nnt7Z.html#	0	f	0
1337	n_1254	http://lod.taxonconcept.org/ses/G92Fi.html#	0	f	0
1338	n_1255	http://lod.taxonconcept.org/ses/BPoM4.html#	0	f	0
1339	n_1256	http://lod.taxonconcept.org/ses/eZAe8.html#	0	f	0
1340	n_1257	http://lod.taxonconcept.org/ses/cCZRL.html#	0	f	0
1341	n_1258	http://lod.taxonconcept.org/ses/iuCXz.html#	0	f	0
1342	n_1259	http://lod.taxonconcept.org/ses/hE3Lu.html#	0	f	0
1343	n_1260	http://lod.taxonconcept.org/ses/X6aiO.html#	0	f	0
1344	n_1261	http://lod.taxonconcept.org/ses/rjjZx.html#	0	f	0
1345	n_1262	http://lod.taxonconcept.org/ses/PGFS2.html#	0	f	0
1346	n_1263	http://lod.taxonconcept.org/ses/e62Ou.html#	0	f	0
1347	n_1264	http://lod.taxonconcept.org/ses/yCpDA.html#	0	f	0
1348	n_1265	http://lod.taxonconcept.org/ses/TtUUO.html#	0	f	0
1349	n_1266	http://lod.taxonconcept.org/ses/DM53s.html#	0	f	0
1350	n_1267	http://lod.taxonconcept.org/ses/DpTKa.html#	0	f	0
1351	n_1268	http://lod.taxonconcept.org/ses/WhSxv.html#	0	f	0
1352	n_1269	http://lod.taxonconcept.org/ses/VjYO7.html#	0	f	0
1353	n_1270	http://lod.taxonconcept.org/ses/PoSYA.html#	0	f	0
1354	n_1271	http://lod.taxonconcept.org/ses/Hq5OE.html#	0	f	0
1355	n_1272	http://lod.taxonconcept.org/ses/z5bSA.html#	0	f	0
1356	n_1273	http://lod.taxonconcept.org/ses/ibUB4.html#	0	f	0
1357	n_1274	http://lod.taxonconcept.org/ses/UARq7.html#	0	f	0
1360	taxrefprop	http://taxref.mnhn.fr/lod/property/	0	f	0
1361	oboinowl	http://www.geneontology.org/formats/oboInOwl#	0	f	0
1364	dwc	http://rs.tdwg.org/dwc/terms/	0	f	0
1370	cito	http://purl.org/spar/cito/	0	f	0
1373	dwciri	http://rs.tdwg.org/dwc/iri/	0	f	0
1374	wdrs	http://www.w3.org/2007/05/powder-s#	0	f	0
1377	pav	http://purl.org/pav/	0	f	0
1358	aims-agr	http://aims.fao.org/aos/agrontology#	0	f	0
1359	vocbench	http://art.uniroma2.it/ontologies/vocbench#	0	f	0
1362	tdwg-c	http://rs.tdwg.org/ontology/voc/Common#	0	f	0
1363	virtdav	http://www.openlinksw.com/virtdav#	0	f	0
1365	rss-event	http://purl.org/rss/1.0/modules/event/	0	f	0
1366	obo-taxon	http://purl.obolibrary.org/obo/ncbitaxon#	0	f	0
1367	cal	http://www.w3.org/2002/12/cal#	0	f	0
1368	tdwg-attribs	http://rs.tdwg.org/dwc/terms/attributes/	0	f	0
1369	obo-vto	http://purl.obolibrary.org/obo/vto#	0	f	0
1371	tdwg-voc	http://rs.tdwg.org/ontology/voc/	0	f	0
1372	obo-envo	http://purl.obolibrary.org/obo/envo#	0	f	0
1375	go-oboinowl	http://www.geneontology.org/formats/oboInOWL#	0	f	0
1376	go-oboinowl-1	ttp://www.geneontology.org/formats/oboInOwl#	0	f	0
1378	swrl-33	http://swrl.stanford.edu/ontologies/3.3/swrla.owl#	0	f	0
1379	tdwg-base	http://rs.tdwg.org/ontology/Base#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
40	named_graph	\N	\N	Default named graph for visual environment projects using this schema.	4
210	instance_name_pattern	\N	\N	Default pattern for instance name presentation in visual query fields. Work in progress. Can be overriden on individual class level. Leave empty to present instances by their URIs.	10
330	use_instance_table	\N	\N	Mark, if a dedicated instance table is installed within the data schema (requires a custom solution).	8
240	use_pp_rels	\N	\N	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
230	instance_lookup_mode	\N	\N	table - use instances table, default - use data endpoint	19
250	direct_class_role	\N	\N	Default property to be used for instance-to-class relationship. Leave empty in the most typical case of the property being rdf:type.	5
260	indirect_class_role	\N	\N	Fill in, if an indirect class membership is to be used in the environment, along with the direct membership (normally leave empty).	6
20	schema_description	\N	\N	Description of the schema.	2
100	tree_profile_name	\N	\N	Look up public tree profile by this name (mutually exclusive with local tree_profile).	14
110	tree_profile	\N	\N	A custom configuration of the entity lookup pane tree (copy the initial value from the parameters of a similar schema).	11
220	show_instance_tab	\N	\N	Show instance tab in the entity lookup pane in the visual environment.	15
60	endpoint_public_url	\N	\N	Human readable web site of the endpoint, if available.	16
10	display_name_default	https_taxref_mnhn_fr_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	https_taxref_mnhn_fr_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://taxref.mnhn.fr/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "https://taxref.mnhn.fr/sparql", "correlationId": "4629364640556266579", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 10, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": false, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:25:06.171Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/ns/dcat#downloadURL	1	\N	15	downloadURL	downloadURL	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://xmlns.com/foaf/0.1/name	16	\N	8	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://xmlns.com/foaf/0.1/page	5602246	\N	8	page	page	f	5602233	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://schema.org/language	4	\N	9	language	language	f	4	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://creativecommons.org/ns#attributionURL	39820	\N	23	attributionURL	attributionURL	f	39820	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://aims.fao.org/aos/agrontology#spellingVariant	2163	\N	1358	spellingVariant	spellingVariant	f	2163	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
8	http://rdf.geospecies.org/ont/geospecies#hasBugGuidePage	3833	\N	69	hasBugGuidePage	hasBugGuidePage	f	3833	\N	\N	f	f	\N	1330	\N	t	f	\N	\N	\N	t	f	f
9	http://aims.fao.org/aos/agrontology#usingValue	34	\N	1358	usingValue	usingValue	f	34	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
10	http://rdf.geospecies.org/ont/geospecies#hasOmernik_4_Ecozone	39	\N	69	hasOmernik_4_Ecozone	hasOmernik_4_Ecozone	f	39	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://purl.org/dc/terms/spatial	15	\N	5	spatial	spatial	f	15	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://schema.org/dateCreated	1	\N	9	dateCreated	dateCreated	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://aims.fao.org/aos/agrontology#isOutputFrom	4	\N	1358	isOutputFrom	isOutputFrom	f	4	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
14	http://aims.fao.org/aos/agrontology#hasChemicalFormula	27	\N	1358	hasChemicalFormula	hasChemicalFormula	f	27	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
15	http://lod.taxonconcept.org/ontology/txn.owl#hasBBCPage	320	\N	346	hasBBCPage	hasBBCPage	f	320	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://aims.fao.org/aos/agrontology#measures	24	\N	1358	measures	measures	f	24	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
17	http://rdf.geospecies.org/ont/geospecies#hasSubspeciesName	43	\N	69	hasSubspeciesName	hasSubspeciesName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://rdf.geospecies.org/ont/geospecies#hasScientificNameAuthorship	14592	\N	69	hasScientificNameAuthorship	hasScientificNameAuthorship	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://schema.org/mainEntityOfPage	552709	\N	9	mainEntityOfPage	mainEntityOfPage	f	552709	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://rdf.geospecies.org/ont/geospecies#hasWikipediaArticle	12933	\N	69	hasWikipediaArticle	hasWikipediaArticle	f	12933	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://rdf.geospecies.org/ont/geospecies#relatedMatch	8	\N	69	relatedMatch	relatedMatch	f	8	\N	\N	f	f	\N	475	\N	t	f	\N	\N	\N	t	f	f
22	http://purl.obolibrary.org/obo/def	1	\N	40	def	def	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://lod.taxonconcept.org/ontology/txn.owl#hasEUNISPage	10225	\N	346	hasEUNISPage	hasEUNISPage	f	10225	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/ns/dcat#dataset	2	\N	15	dataset	dataset	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/ns/dcat#keyword	26	\N	15	keyword	keyword	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://rdf.geospecies.org/ont/geospecies#hasBBC_EcozoneName	39	\N	69	hasBBC_EcozoneName	hasBBC_EcozoneName	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://rdf.geospecies.org/ont/geospecies#hasClassName	18928	\N	69	hasClassName	hasClassName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://purl.org/dc/elements/1.1/description	26	\N	6	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://rdf.geospecies.org/ont/geospecies#inPhylum	20789	\N	69	inPhylum	inPhylum	f	20789	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://art.uniroma2.it/ontologies/vocbench#hasStatus	681808	\N	1359	hasStatus	hasStatus	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://aims.fao.org/aos/agrontology#isDerivedFrom	160	\N	1358	isDerivedFrom	isDerivedFrom	f	160	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
33	http://taxref.mnhn.fr/lod/property/habitat	833638	\N	1360	habitat	habitat	f	833638	\N	\N	f	f	740	1117	\N	t	f	\N	\N	\N	t	f	f
34	http://rdf.geospecies.org/ont/geospecies#hasCountry	52	\N	69	hasCountry	hasCountry	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://aims.fao.org/aos/agrontology#hasComponent	832	\N	1358	hasComponent	hasComponent	f	832	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
36	http://rdf.geospecies.org/ont/geospecies#hasLocalityName	39	\N	69	hasLocalityName	hasLocalityName	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://xmlns.com/foaf/0.1/homepage	552735	\N	8	homepage	homepage	f	552734	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://aims.fao.org/aos/agrontology#hasProperty	317	\N	1358	hasProperty	hasProperty	f	317	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
39	http://www.geneontology.org/formats/oboInOwl#creation_date	350	\N	1361	creation_date	creation_date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://lod.taxonconcept.org/ontology/txn.owl#uniprotFamily	102446	\N	346	uniprotFamily	uniprotFamily	f	102446	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://rdf.geospecies.org/ont/geospecies#inOrder	20522	\N	69	inOrder	inOrder	f	20522	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://lod.taxonconcept.org/ontology/txn.owl#order	117509	\N	346	order	order	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/dc/terms/abstract	5372	\N	5	abstract	abstract	f	0	\N	\N	f	f	741	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://taxref.mnhn.fr/lod/property/statusValue	1533738	\N	1360	statusValue	statusValue	f	1533738	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/ns/sparql-service-description#namedGraph	15	\N	27	namedGraph	namedGraph	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.wikidata.org/prop/direct/P1746	33186	\N	13	[ZooBank ID (Wikidata) (P1746)]	P1746	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.wikidata.org/prop/direct/P846	1999650	\N	13	[GBIF ID (Wikidata) (P846)]	P846	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.wikidata.org/prop/direct/P960	369906	\N	13	[TROPICOS ID (Wikidata) (P960)]	P960	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.wikidata.org/prop/direct/P1745	15274	\N	13	[VASCAN ID (Wikidata) (P1745)]	P1745	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://lod.taxonconcept.org/ontology/txn.owl#hasWikipediaArticle	43723	\N	346	hasWikipediaArticle	hasWikipediaArticle	f	43723	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://www.w3.org/ns/dcat#landingPage	1	\N	15	landingPage	landingPage	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/ns/dcat#compressFormat	1	\N	15	compressFormat	compressFormat	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://purl.obolibrary.org/obo/IAO_0000412	8	\N	40	IAO_0000412	IAO_0000412	f	8	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://rdf.geospecies.org/ont/geospecies#speciesReference	229	\N	69	speciesReference	speciesReference	f	229	\N	\N	f	f	264	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://lod.taxonconcept.org/ontology/txn.owl#uniprotClass	91418	\N	346	uniprotClass	uniprotClass	f	91418	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	1303	\N	2	subPropertyOf	subPropertyOf	f	1303	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://www.w3.org/2004/02/skos/core#broadMatch	10647	\N	4	broadMatch	broadMatch	f	10647	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/2004/02/skos/core#notation	646333	\N	4	notation	notation	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://aims.fao.org/aos/agrontology#hasLocalName	163	\N	1358	hasLocalName	hasLocalName	f	163	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
62	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	3040	\N	1	first	first	f	3023	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.w3.org/2002/07/owl#deprecated	325	\N	7	deprecated	deprecated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://www.openlinksw.com/schemas/VAD#versionNumber	4	\N	311	versionNumber	versionNumber	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://rdf.geospecies.org/ont/geospecies#wasObservedIn	37	\N	69	wasObservedIn	wasObservedIn	f	37	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://rs.tdwg.org/ontology/voc/Common#darwinCoreEquivalence	130	\N	1362	darwinCoreEquivalence	darwinCoreEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://schema.org/encodingFormat	56706	\N	9	encodingFormat	encodingFormat	f	0	\N	\N	f	f	1360	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.openlinksw.com/virtdav#dynRdfExtractor	4	\N	1363	dynRdfExtractor	dynRdfExtractor	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://rdf.geospecies.org/ont/geospecies#hasSpecificEpithet	18878	\N	69	hasSpecificEpithet	hasSpecificEpithet	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://rdfs.org/ns/void#target	14	\N	16	target	target	f	14	\N	\N	f	f	978	476	\N	t	f	\N	\N	\N	t	f	f
73	http://purl.obolibrary.org/obo/IAO_0000424	22	\N	40	IAO_0000424	IAO_0000424	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://purl.org/dc/terms/extent	1149	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://rdfs.org/ns/void#exampleResource	13	\N	16	exampleResource	exampleResource	f	13	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://www.geneontology.org/formats/oboInOwl#hasAlternativeId	32934	\N	1361	hasAlternativeId	hasAlternativeId	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/1999/02/22-rdf-syntax-ns#object	41092	\N	1	object	object	f	41092	\N	\N	f	f	921	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://purl.org/dc/elements/1.1/title	1413	\N	6	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://qudt.org/schema/qudt/acronym	1	\N	74	acronym	acronym	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://rs.tdwg.org/dwc/terms/continent	39	\N	1364	continent	continent	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	6	\N	1224	EMAIL	EMAIL	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://www.w3.org/ns/prov#wasAssociatedWith	1	\N	26	wasAssociatedWith	wasAssociatedWith	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://rs.tdwg.org/ontology/voc/Common#abcdEquivalence	34	\N	1362	abcdEquivalence	abcdEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://www.geneontology.org/formats/oboInOwl#hasSynonymType	297092	\N	1361	hasSynonymType	hasSynonymType	f	297092	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://rdf.geospecies.org/ont/geospecies#hasLocationName	39	\N	69	hasLocationName	hasLocationName	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://www.geneontology.org/formats/oboInOwl#default-namespace	1	\N	1361	default-namespace	default-namespace	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	256	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://www.geneontology.org/formats/oboInOwl#id	74155	\N	1361	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://schema.org/subjectOf	3	\N	9	subjectOf	subjectOf	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://art.uniroma2.it/ontologies/vocbench#hasSource	24	\N	1359	hasSource	hasSource	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://rs.tdwg.org/dwc/terms/stateProvince	39	\N	1364	stateProvince	stateProvince	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://aims.fao.org/aos/agrontology#isSpatiallyIncludedInCity	13	\N	1358	isSpatiallyIncludedInCity	isSpatiallyIncludedInCity	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://aims.fao.org/aos/agrontology#affects	187	\N	1358	affects	affects	f	187	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
98	http://rdf.geospecies.org/ont/geospecies#hasCanonicalName	18878	\N	69	hasCanonicalName	hasCanonicalName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://purl.obolibrary.org/obo/IAO_0100001	37	\N	40	[term replaced by (IAO_0100001)]	IAO_0100001	f	22	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.wikidata.org/prop/direct/P850	622514	\N	13	[WoRMS ID (Wikidata) (P850)]	P850	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.obolibrary.org/obo/RO_0002020	90	\N	40	[transports (RO_0002020)]	RO_0002020	f	90	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://purl.obolibrary.org/obo/IAO_0000425	4	\N	40	[expand assertion to (IAO_0000425)]	IAO_0000425	f	0	\N	\N	f	f	1111	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://www.openlinksw.com/schemas/VAD#versionBuild	4	\N	311	versionBuild	versionBuild	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://www.w3.org/ns/dcat#accessURL	2	\N	15	accessURL	accessURL	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://rdf.geospecies.org/ont/geospecies#hasGBIF	1685	\N	69	hasGBIF	hasGBIF	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://schema.org/image	56706	\N	9	image	image	f	56706	\N	\N	f	f	740	1360	\N	t	f	\N	\N	\N	t	f	f
103	http://rdfs.org/ns/void#inDataset	681509	\N	16	inDataset	inDataset	f	681509	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://taxref.mnhn.fr/lod/property/statusType	220129	\N	1360	statusType	statusType	f	220129	\N	\N	f	f	691	1117	\N	t	f	\N	\N	\N	t	f	f
105	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://aims.fao.org/aos/agrontology#controls	60	\N	1358	controls	controls	f	60	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
107	http://purl.obolibrary.org/obo/IAO_0000600	1	\N	40	IAO_0000600	IAO_0000600	f	0	\N	\N	f	f	1332	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://rdf.geospecies.org/ont/geospecies#inKingdom	20867	\N	69	inKingdom	inKingdom	f	20867	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://lod.taxonconcept.org/ontology/txn.owl#genus	117509	\N	346	genus	genus	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://purl.org/rss/1.0/modules/event/startdate	2	\N	1365	startdate	startdate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://aims.fao.org/aos/agrontology#spatiallyIncludes	543	\N	1358	spatiallyIncludes	spatiallyIncludes	f	543	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
112	http://purl.org/dc/terms/replaces	151	\N	5	replaces	replaces	f	151	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://rdf.geospecies.org/ont/geospecies#isUnknownAboutIn	58850	\N	69	isUnknownAboutIn	isUnknownAboutIn	f	58850	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://rdf.geospecies.org/ont/geospecies#hasSite	6	\N	69	hasSite	hasSite	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://taxref.mnhn.fr/lod/property/vernacularNameXL	94758	\N	1360	vernacularNameXL	vernacularNameXL	f	94758	\N	\N	f	f	740	736	\N	t	f	\N	\N	\N	t	f	f
116	http://www.w3.org/2002/07/owl#intersectionOf	1305	\N	7	intersectionOf	intersectionOf	f	1305	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://rdf.geospecies.org/ont/geospecies#hasKingdomName	18886	\N	69	hasKingdomName	hasKingdomName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://www.geneontology.org/formats/oboInOwl#shorthand	7	\N	1361	shorthand	shorthand	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://www.openlinksw.com/schemas/VAD#packageName	4	\N	311	packageName	packageName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://rdf.geospecies.org/ont/geospecies#hasGeodeticDatum	39	\N	69	hasGeodeticDatum	hasGeodeticDatum	f	39	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://rdf.geospecies.org/ont/geospecies#hasLowExpectationOf	21665	\N	69	hasLowExpectationOf	hasLowExpectationOf	f	21665	\N	\N	f	f	\N	1118	\N	t	f	\N	\N	\N	t	f	f
124	http://www.w3.org/2002/07/owl#disjointUnionOf	1	\N	7	disjointUnionOf	disjointUnionOf	f	1	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://aims.fao.org/aos/agrontology#hasDisease	5	\N	1358	hasDisease	hasDisease	f	5	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
126	http://www.w3.org/2008/05/skos-xl#altLabel	143595	\N	71	altLabel	altLabel	f	143595	\N	\N	f	f	1117	736	\N	t	f	\N	\N	\N	t	f	f
127	http://rdf.geospecies.org/ont/geospecies#hasGenusName	18878	\N	69	hasGenusName	hasGenusName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#isPossibleMosquitoVectorOfHumanMalaria	1	\N	112	isPossibleMosquitoVectorOfHumanMalaria	isPossibleMosquitoVectorOfHumanMalaria	f	1	\N	\N	f	f	1118	1118	\N	t	f	\N	\N	\N	t	f	f
129	http://lod.taxonconcept.org/ontology/txn.owl#authority	95904	\N	346	authority	authority	f	0	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://aims.fao.org/aos/agrontology#usesProcess	341	\N	1358	usesProcess	usesProcess	f	341	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
132	http://lod.taxonconcept.org/ontology/txn.owl#family	117509	\N	346	family	family	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://aims.fao.org/aos/agrontology#hasSymbol	709	\N	1358	hasSymbol	hasSymbol	f	709	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
134	http://www.geneontology.org/formats/oboInOwl#is_class_level	1	\N	1361	is_class_level	is_class_level	f	0	\N	\N	f	f	1111	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://aims.fao.org/aos/agrontology#hasPlural	71	\N	1358	hasPlural	hasPlural	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://rs.tdwg.org/ontology/voc/GeographicRegion#code	1039	\N	105	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://www.geneontology.org/formats/oboInOwl#is_inferred	2	\N	1361	is_inferred	is_inferred	f	0	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://schema.org/author	20	\N	9	author	author	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://purl.org/dc/terms/hasPart	582525	\N	5	hasPart	hasPart	f	582525	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://purl.obolibrary.org/obo/RO_0002469	6964	\N	40	[provides nutrients for (RO_0002469)]	RO_0002469	f	6964	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://www.wikidata.org/prop/direct/P1717	105932	\N	13	[SANDRE ID (Wikidata) (P1717)]	P1717	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://purl.obolibrary.org/obo/RO_0002582	5	\N	40	[is a defining property chain axiom where second .. (RO_0002582)]	RO_0002582	f	0	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://purl.obolibrary.org/obo/RO_0002455	2236	\N	40	[pollinates (RO_0002455)]	RO_0002455	f	2236	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://purl.obolibrary.org/obo/RO_0002456	2236	\N	40	[pollinated by (RO_0002456)]	RO_0002456	f	2236	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://www.wikidata.org/prop/direct/P6055	516	\N	13	[Mantodea Species File Online ID (Wikidata) (P6055)]	P6055	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://purl.obolibrary.org/obo/RO_0002457	6964	\N	40	[acquires nutrients from (RO_0002457)]	RO_0002457	f	6964	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://purl.org/dc/terms/contributor	2	\N	5	contributor	contributor	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://rs.tdwg.org/ontology/voc/GeographicRegion#iso2Code	978	\N	105	iso2Code	iso2Code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://rdfs.org/ns/void#vocabulary	34	\N	16	vocabulary	vocabulary	f	34	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://rdf.geospecies.org/ont/geospecies#hasDayOfYear	26	\N	69	hasDayOfYear	hasDayOfYear	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://rdf.geospecies.org/ont/geospecies#hasGNI	22	\N	69	hasGNI	hasGNI	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://rdf.geospecies.org/ont/geospecies#hasToLPage	72	\N	69	hasToLPage	hasToLPage	f	72	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://schema.org/value	2365569	\N	9	value	value	f	0	\N	\N	f	f	737	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://rs.tdwg.org/ontology/voc/GeographicRegion#continent	52	\N	105	continent	continent	f	52	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://www.w3.org/2002/07/owl#inverseOf	258	\N	7	inverseOf	inverseOf	f	258	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://purl.org/dc/terms/isPartOf	187102	\N	5	isPartOf	isPartOf	f	187102	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://aims.fao.org/aos/agrontology#hasCodeISO3Country	238	\N	1358	hasCodeISO3Country	hasCodeISO3Country	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	3040	\N	1	rest	rest	f	3040	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://lod.taxonconcept.org/ontology/txn.owl#class	117509	\N	346	class	class	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://www.w3.org/2004/02/skos/core#definition	1887	\N	4	definition	definition	f	1806	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://purl.obolibrary.org/obo/IAO_0000116	56	\N	40	IAO_0000116	IAO_0000116	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://purl.obolibrary.org/obo/IAO_0000117	329	\N	40	IAO_0000117	IAO_0000117	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://purl.obolibrary.org/obo/IAO_0000114	119	\N	40	IAO_0000114	IAO_0000114	f	119	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://www.w3.org/2004/02/skos/core#narrowerTransitive	20830	\N	4	narrowerTransitive	narrowerTransitive	f	20830	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://purl.obolibrary.org/obo/IAO_0000112	97	\N	40	IAO_0000112	IAO_0000112	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://purl.obolibrary.org/obo/IAO_0000232	65	\N	40	IAO_0000232	IAO_0000232	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://aims.fao.org/aos/agrontology#study	159	\N	1358	study	study	f	159	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
178	http://purl.obolibrary.org/obo/IAO_0000111	2	\N	40	IAO_0000111	IAO_0000111	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://aims.fao.org/aos/agrontology#hasRelatedTerm	50094	\N	1358	hasRelatedTerm	hasRelatedTerm	f	50094	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
180	http://rdf.geospecies.org/ont/geospecies#isBugGuidePageOf	3833	\N	69	isBugGuidePageOf	isBugGuidePageOf	f	3833	\N	\N	f	f	1330	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://rdfs.org/ns/void#uriSpace	1	\N	16	uriSpace	uriSpace	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	640678	\N	2	isDefinedBy	isDefinedBy	f	640678	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://rdf.geospecies.org/ont/geospecies#hasObservation	39	\N	69	hasObservation	hasObservation	f	39	\N	\N	f	f	\N	28	\N	t	f	\N	\N	\N	t	f	f
184	http://purl.obolibrary.org/obo/IAO_0000118	87	\N	40	IAO_0000118	IAO_0000118	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://purl.obolibrary.org/obo/IAO_0000119	106	\N	40	IAO_0000119	IAO_0000119	f	53	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://www.geonames.org/ontology#parentFeature	39	\N	72	parentFeature	parentFeature	f	39	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://www.w3.org/2002/07/owl#propertyChainAxiom	132	\N	7	propertyChainAxiom	propertyChainAxiom	f	132	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://lod.taxonconcept.org/ontology/txn.owl#commonName	51262	\N	346	commonName	commonName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://rdf.geospecies.org/ont/geospecies#hasStateProvince	52	\N	69	hasStateProvince	hasStateProvince	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://aims.fao.org/aos/agrontology#hasPhysiologicalFunction	8	\N	1358	hasPhysiologicalFunction	hasPhysiologicalFunction	f	8	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
147	http://purl.obolibrary.org/obo/RO_0002579	2	\N	40	[is indirect form of (RO_0002579)]	RO_0002579	f	2	\N	\N	f	f	1332	907	\N	t	f	\N	\N	\N	t	f	f
149	http://www.wikidata.org/prop/direct/P6050	4000	\N	13	[Orthoptera Species File Online ID (Wikidata) (P6050)]	P6050	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://purl.obolibrary.org/obo/RO_0002575	6	\N	40	[is direct form of (RO_0002575)]	RO_0002575	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://purl.obolibrary.org/obo/RO_0002208	2906	\N	40	[parasitoid of (RO_0002208)]	RO_0002208	f	2906	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://purl.obolibrary.org/obo/RO_0002209	2906	\N	40	[has parasitoid (RO_0002209)]	RO_0002209	f	2906	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://purl.obolibrary.org/obo/RO_0002444	4146	\N	40	[parasite of (RO_0002444)]	RO_0002444	f	4146	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://purl.obolibrary.org/obo/RO_0002445	4146	\N	40	[parasitized by (RO_0002445)]	RO_0002445	f	4146	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://purl.obolibrary.org/obo/IAO_0000115	1474	\N	40	[definition (IAO_0000115)]	IAO_0000115	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://purl.obolibrary.org/obo/RO_0002561	4	\N	40	[is symmetric relational form of process class (RO_0002561)]	RO_0002561	f	4	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://purl.obolibrary.org/obo/RO_0002441	50	\N	40	[commensually interacts with (RO_0002441)]	RO_0002441	f	50	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://purl.obolibrary.org/obo/RO_0002442	108	\N	40	[mutualistically interacts with (RO_0002442)]	RO_0002442	f	108	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://purl.obolibrary.org/obo/RO_0002439	1147	\N	40	[preys on (RO_0002439)]	RO_0002439	f	1147	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://www.w3.org/2002/07/owl#disjointWith	19	\N	7	disjointWith	disjointWith	f	19	\N	\N	f	f	740	740	\N	t	f	\N	\N	\N	t	f	f
198	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://aims.fao.org/aos/agrontology#isUsedAs	2414	\N	1358	isUsedAs	isUsedAs	f	2414	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
200	http://www.w3.org/2002/07/owl#unionOf	21	\N	7	unionOf	unionOf	f	21	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://rdf.geospecies.org/ont/geospecies#hasContinent	52	\N	69	hasContinent	hasContinent	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://www.w3.org/2002/07/owl#versionInfo	29	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://rdfs.org/ns/void#dataDumpLocation	1	\N	16	dataDumpLocation	dataDumpLocation	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://taxref.mnhn.fr/lod/property/hasStatus	1753865	\N	1360	hasStatus	hasStatus	f	1753865	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://rs.tdwg.org/ontology/voc/GeographicRegion#name	1039	\N	105	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://purl.org/vocommons/voaf#dataset	2	\N	35	dataset	dataset	f	2	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://www.openlinksw.com/schemas/VAD#packageTitle	4	\N	311	packageTitle	packageTitle	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://purl.org/rss/1.0/modules/event/enddate	2	\N	1365	enddate	enddate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://www.geneontology.org/formats/oboInOwl#hasOBONamespace	1249821	\N	1361	hasOBONamespace	hasOBONamespace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://www.w3.org/ns/dcat#endpointURL	1	\N	15	endpointURL	endpointURL	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://aims.fao.org/aos/agrontology#actsUpon	23	\N	1358	actsUpon	actsUpon	f	23	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
215	http://aims.fao.org/aos/agrontology#hasTradeName	265	\N	1358	hasTradeName	hasTradeName	f	265	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
216	http://purl.obolibrary.org/obo/ncbitaxon#has_rank	1013604	\N	1366	has_rank	has_rank	f	1013604	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://www.w3.org/2004/02/skos/core#narrower	33930	\N	4	narrower	narrower	f	33930	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://creativecommons.org/ns#license	39807	\N	23	license	license	f	39807	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://aims.fao.org/aos/agrontology#makeUseOf	920	\N	1358	makeUseOf	makeUseOf	f	920	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
221	http://rdfs.org/ns/void#uriRegexPattern	1	\N	16	uriRegexPattern	uriRegexPattern	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://www.w3.org/2004/02/skos/core#topConceptOf	193	\N	4	topConceptOf	topConceptOf	f	193	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://rdf.geospecies.org/ont/geospecies#hasBioLibPage	267	\N	69	hasBioLibPage	hasBioLibPage	f	267	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://rdf.geospecies.org/ont/geospecies#isExpectedIn	24814	\N	69	isExpectedIn	isExpectedIn	f	24814	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://www.w3.org/2004/02/skos/core#member	81	\N	4	member	member	f	81	\N	\N	f	f	\N	1117	\N	t	f	\N	\N	\N	t	f	f
226	http://www.w3.org/ns/sparql-service-description#supportedLanguage	3	\N	27	supportedLanguage	supportedLanguage	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://purl.org/dc/elements/1.1/creator	32	\N	6	creator	creator	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://purl.org/dc/terms/issued	43622	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://www.w3.org/ns/prov#hadPrimarySource	1	\N	26	hadPrimarySource	hadPrimarySource	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://rdf.geospecies.org/ont/geospecies#hasWI_Herbarium_Habitat	2	\N	69	hasWI_Herbarium_Habitat	hasWI_Herbarium_Habitat	f	2	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://aims.fao.org/aos/agrontology#isAbbreviationOf	1	\N	1358	isAbbreviationOf	isAbbreviationOf	f	1	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
234	http://rdf.geospecies.org/ont/geospecies#hasCountryName	39	\N	69	hasCountryName	hasCountryName	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://rs.tdwg.org/dwc/terms/countryCode	39	\N	1364	countryCode	countryCode	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://aims.fao.org/aos/agrontology#prevents	13	\N	1358	prevents	prevents	f	13	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
237	http://purl.org/dc/terms/hasVersion	192	\N	5	hasVersion	hasVersion	f	192	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://rdf.geospecies.org/ont/geospecies#hasScientificName	18878	\N	69	hasScientificName	hasScientificName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://schema.org/sameAs	14062	\N	9	sameAs	sameAs	f	14062	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://taxref.mnhn.fr/lod/property/bioGeoStatusIn	577843	\N	1360	bioGeoStatusIn	bioGeoStatusIn	f	577843	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.obolibrary.org/obo/IAO_0000426	6	\N	40	IAO_0000426	IAO_0000426	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://rs.tdwg.org/dwc/terms/order	277428	\N	1364	order	order	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://rdf.geospecies.org/ont/geospecies#hasContinentName	39	\N	69	hasContinentName	hasContinentName	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://www.w3.org/2002/07/owl#distinctMembers	1	\N	7	distinctMembers	distinctMembers	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://rs.tdwg.org/ontology/voc/Common#berlinModelEquivalence	21	\N	1362	berlinModelEquivalence	berlinModelEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://purl.org/dc/terms/description	1837433	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://www.wikidata.org/prop/direct/P6376	832	\N	13	[Psyl'list ID (Wikidata) (P6376)]	P6376	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://schema.org/thumbnail	56706	\N	9	thumbnail	thumbnail	f	56706	\N	\N	f	f	1360	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://www.w3.org/2002/07/owl#inverse	2	\N	7	inverse	inverse	f	2	\N	\N	f	f	1111	1111	\N	t	f	\N	\N	\N	t	f	f
249	http://www.w3.org/2002/07/owl#annotatedSource	386552	\N	7	annotatedSource	annotatedSource	f	386552	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://www.w3.org/2004/02/skos/core#inScheme	785471	\N	4	inScheme	inScheme	f	785471	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://rs.tdwg.org/dwc/terms/locality	39	\N	1364	locality	locality	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://schema.org/publisher	5	\N	9	publisher	publisher	f	5	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://taxref.mnhn.fr/lod/property/hasRank	1446565	\N	1360	hasRank	hasRank	f	1446565	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://www.geneontology.org/formats/oboInOwl#inSubset	149	\N	1361	inSubset	inSubset	f	149	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	http://rdf.geospecies.org/ont/geospecies#hasCollector	13	\N	69	hasCollector	hasCollector	f	13	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://purl.org/dc/terms/subject	53	\N	5	subject	subject	f	46	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://rdfs.org/ns/void#dataDump	1	\N	16	dataDump	dataDump	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://rs.tdwg.org/ontology/voc/GeographicRegion#isPartOf	1030	\N	105	isPartOf	isPartOf	f	1030	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://www.w3.org/2002/12/cal#summary	2	\N	1367	summary	summary	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://taxref.mnhn.fr/lod/property/hasSpecificity	13100	\N	1360	hasSpecificity	hasSpecificity	f	13100	\N	\N	f	f	921	1117	\N	t	f	\N	\N	\N	t	f	f
261	http://www.w3.org/2000/01/rdf-schema#range	671	\N	2	range	range	f	671	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://purl.org/dc/elements/1.1/publisher	23	\N	6	publisher	publisher	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://aims.fao.org/aos/agrontology#hasSynonym	127128	\N	1358	hasSynonym	hasSynonym	f	127128	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
264	http://www.w3.org/ns/prov#wasGeneratedBy	1	\N	26	wasGeneratedBy	wasGeneratedBy	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://rdf.geospecies.org/ont/geospecies#hasEOL	8	\N	69	hasEOL	hasEOL	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://rdf.geospecies.org/ont/geospecies#hasSubgenusName	1155	\N	69	hasSubgenusName	hasSubgenusName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://www.geneontology.org/formats/oboInOwl#created_by	343	\N	1361	created_by	created_by	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://rdf.geospecies.org/ont/geospecies#hasFamilyName	20522	\N	69	hasFamilyName	hasFamilyName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://rdf.geospecies.org/ont/geospecies#inClass	20739	\N	69	inClass	inClass	f	20739	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	6	\N	1224	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://rs.tdwg.org/dwc/terms/attributes/decision	47	\N	1368	decision	decision	f	47	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://lod.taxonconcept.org/ontology/mos_path.owl#hasPossibleMosquitoVector	64	\N	124	hasPossibleMosquitoVector	hasPossibleMosquitoVector	f	64	\N	\N	f	f	748	748	\N	t	f	\N	\N	\N	t	f	f
273	http://taxref.mnhn.fr/lod/property/hasAuthority	651661	\N	1360	hasAuthority	hasAuthority	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://purl.org/dc/terms/publisher	43590	\N	5	publisher	publisher	f	43589	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://aims.fao.org/aos/agrontology#isMadeFrom	104	\N	1358	isMadeFrom	isMadeFrom	f	104	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
277	http://rdf.geospecies.org/ont/geospecies#hasUSDA_Growth	4565	\N	69	hasUSDA_Growth	hasUSDA_Growth	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://purl.org/rss/1.0/modules/event/location	2	\N	1365	location	location	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://xmlns.com/foaf/0.1/closeMatch	309	\N	8	closeMatch	closeMatch	f	309	\N	\N	f	f	911	1118	\N	t	f	\N	\N	\N	t	f	f
285	http://rs.tdwg.org/ontology/voc/Common#tcsEquivalence	21	\N	1362	tcsEquivalence	tcsEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://rdf.geospecies.org/ont/geospecies#hasNomenclaturalCode	15504	\N	69	hasNomenclaturalCode	hasNomenclaturalCode	f	15504	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://rdf.geospecies.org/ont/geospecies#siteOrder	3	\N	69	siteOrder	siteOrder	f	3	\N	\N	f	f	\N	958	\N	t	f	\N	\N	\N	t	f	f
289	http://purl.org/NET/scovo#dimension	1	\N	73	dimension	dimension	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://rdf.geospecies.org/ont/geospecies#hasNoUSDA_ExpectationOf	127055	\N	69	hasNoUSDA_ExpectationOf	hasNoUSDA_ExpectationOf	f	127055	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://xmlns.com/foaf/0.1/Organization	2	\N	8	Organization	Organization	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.w3.org/2001/vcard-rdf/3.0#City	6	\N	1224	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://www.w3.org/2002/07/owl#imports	17	\N	7	imports	imports	f	17	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
294	http://www.geneontology.org/formats/oboInOwl#hasDbXref	1467235	\N	1361	hasDbXref	hasDbXref	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://purl.org/dc/terms/date	8	\N	5	date	date	f	0	\N	\N	f	f	1136	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://www.wikidata.org/prop/direct/P276	43048	\N	13	[location (Wikidata) (P276)]	P276	f	43048	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	9595525	\N	1	type	type	f	9595525	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
278	http://purl.obolibrary.org/obo/RO_0002635	358	\N	40	[has endoparasite (RO_0002635)]	RO_0002635	f	358	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://purl.obolibrary.org/obo/RO_0002632	461	\N	40	[ectoparasite of (RO_0002632)]	RO_0002632	f	461	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://www.wikidata.org/prop/direct/P3288	10848	\N	13	[The World Spider Catalog ID (Wikidata) (P3288)]	P3288	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://purl.obolibrary.org/obo/RO_0002634	358	\N	40	[endoparasite of (RO_0002634)]	RO_0002634	f	358	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://www.wikidata.org/prop/direct/P248	843386	\N	13	[stated in (Wikidata) (P248)]	P248	f	843386	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
297	http://aims.fao.org/aos/agrontology#isAcronymOf	1	\N	1358	isAcronymOf	isAcronymOf	f	1	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
298	http://rdf.geospecies.org/ont/geospecies#isUSDA_ExpectedIn	65681	\N	69	isUSDA_ExpectedIn	isUSDA_ExpectedIn	f	65681	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://www.openlinksw.com/schemas/VAD#releaseDate	4	\N	311	releaseDate	releaseDate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
300	http://rs.tdwg.org/ontology/voc/TaxonName#nameComplete	285863	\N	109	nameComplete	nameComplete	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
301	http://www.w3.org/2002/07/owl#annotatedProperty	386552	\N	7	annotatedProperty	annotatedProperty	f	386552	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://purl.obolibrary.org/obo/vto#is_extinct	28502	\N	1369	is_extinct	is_extinct	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://aims.fao.org/aos/agrontology#follows	49	\N	1358	follows	follows	f	49	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
304	http://aims.fao.org/aos/agrontology#hasBiologicalControlAgent	1	\N	1358	hasBiologicalControlAgent	hasBiologicalControlAgent	f	1	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
305	http://purl.org/spar/cito/citesAsAuthority	40	\N	1370	citesAsAuthority	citesAsAuthority	f	39	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://xmlns.com/foaf/0.1/primaryTopic	43674	\N	8	primaryTopic	primaryTopic	f	43674	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
307	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://purl.org/dc/terms/license	173630	\N	5	license	license	f	173630	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://purl.org/dc/terms/accrualPeriodicity	1	\N	5	accrualPeriodicity	accrualPeriodicity	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://rs.tdwg.org/dwc/terms/coordinateUncertaintyInMeters	39	\N	1364	coordinateUncertaintyInMeters	coordinateUncertaintyInMeters	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://www.geneontology.org/formats/oboInOwl#is_metadata_tag	1	\N	1361	is_metadata_tag	is_metadata_tag	f	0	\N	\N	f	f	1111	\N	\N	t	f	\N	\N	\N	t	f	f
312	http://www.w3.org/2002/07/owl#onProperty	628	\N	7	onProperty	onProperty	f	628	\N	\N	f	f	1109	\N	\N	t	f	\N	\N	\N	t	f	f
313	http://rdf.geospecies.org/ont/geospecies#hasUnknownExpectationOf	58850	\N	69	hasUnknownExpectationOf	hasUnknownExpectationOf	f	58850	\N	\N	f	f	\N	1118	\N	t	f	\N	\N	\N	t	f	f
314	http://purl.obolibrary.org/obo/created_by	45	\N	40	created_by	created_by	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
315	http://rs.tdwg.org/ontology/voc/CommontcsEquivalence	28	\N	1371	CommontcsEquivalence	CommontcsEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://www.w3.org/ns/dcat#distribution	1	\N	15	distribution	distribution	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
317	http://lod.taxonconcept.org/ontology/txn.owl#kingdom	117509	\N	346	kingdom	kingdom	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://aims.fao.org/aos/agrontology#hasTermType	273068	\N	1358	hasTermType	hasTermType	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
320	http://www.w3.org/ns/sparql-service-description#availableGraphs	1	\N	27	availableGraphs	availableGraphs	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://purl.obolibrary.org/obo/envo#disconnected_from	2	\N	1372	disconnected_from	disconnected_from	f	2	\N	\N	f	f	740	740	\N	t	f	\N	\N	\N	t	f	f
322	http://xmlns.com/foaf/0.1/primaryTopicOf	3	\N	8	primaryTopicOf	primaryTopicOf	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://www.w3.org/ns/sparql-service-description#endpoint	2	\N	27	endpoint	endpoint	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
324	http://rs.tdwg.org/dwc/terms/attributes/abcdEquivalence	192	\N	1368	abcdEquivalence	abcdEquivalence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
325	http://aims.fao.org/aos/agrontology#afflicts	3	\N	1358	afflicts	afflicts	f	3	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
326	http://purl.org/ontology/bibo/abstract	5372	\N	31	abstract	abstract	f	0	\N	\N	f	f	741	\N	\N	t	f	\N	\N	\N	t	f	f
328	http://rdf.geospecies.org/ont/geospecies#hasFamilyInfoContributor	2	\N	69	hasFamilyInfoContributor	hasFamilyInfoContributor	f	2	\N	\N	f	f	1511	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://schema.org/identifier	4726810	\N	9	identifier	identifier	f	4726810	\N	\N	f	f	\N	737	\N	t	f	\N	\N	\N	t	f	f
330	http://lod.taxonconcept.org/ontology/txn.owl#phylum	117509	\N	346	phylum	phylum	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
331	http://purl.org/ontology/bibo/uri	15	\N	31	uri	uri	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
332	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
333	http://rs.tdwg.org/dwc/terms/attributes/status	192	\N	1368	status	status	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
334	http://rdf.geospecies.org/ont/geospecies#hasPhylumName	18956	\N	69	hasPhylumName	hasPhylumName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
335	http://rdf.geospecies.org/ont/geospecies#hasCounty	54	\N	69	hasCounty	hasCounty	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
336	http://www.w3.org/2002/07/owl#equivalentClass	85718	\N	7	equivalentClass	equivalentClass	f	85718	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
337	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
338	http://www.w3.org/2004/02/skos/core#editorialNote	9905	\N	4	editorialNote	editorialNote	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
339	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
340	http://rdf.geospecies.org/ont/geospecies#hasNCBI	10898	\N	69	hasNCBI	hasNCBI	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
341	http://rdf.geospecies.org/ont/geospecies#hasWikispeciesArticle	11754	\N	69	hasWikispeciesArticle	hasWikispeciesArticle	f	11754	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
343	http://purl.org/rss/1.0/modules/event/type	2	\N	1365	type	type	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
327	http://www.wikidata.org/prop/direct/P3105	336580	\N	13	[Tela Botanica ID (P3105)]	P3105	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://www.wikidata.org/prop/direct/P7715	208480	\N	13	[World Flora Online ID (P7715)]	P7715	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
344	http://www.wikidata.org/prop/direct/P2026	6592	\N	13	[Avibase ID (Wikidata) (P2026)]	P2026	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
345	http://purl.org/dc/terms/relation	115	\N	5	relation	relation	f	115	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://aims.fao.org/aos/agrontology#hasAbbreviation	825	\N	1358	hasAbbreviation	hasAbbreviation	f	825	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
347	http://www.geneontology.org/formats/oboInOwl#consider	97	\N	1361	consider	consider	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
348	http://www.w3.org/2004/02/skos/core#closeMatch	125771	\N	4	closeMatch	closeMatch	f	125771	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://purl.org/vocommons/voaf#propertyNumber	1	\N	35	propertyNumber	propertyNumber	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
351	http://purl.org/dc/terms/creator	44010	\N	5	creator	creator	f	43582	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
352	http://rdfs.org/ns/void#subjectsTarget	3	\N	16	subjectsTarget	subjectsTarget	f	3	\N	\N	f	f	978	476	\N	t	f	\N	\N	\N	t	f	f
353	http://rdf.geospecies.org/ont/geospecies#inFamily	18878	\N	69	inFamily	inFamily	f	18878	\N	\N	f	f	1118	1511	\N	t	f	\N	\N	\N	t	f	f
354	http://purl.org/dc/terms/type	1	\N	5	type	type	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
355	http://rs.tdwg.org/dwc/terms/decimalLongitude	39	\N	1364	decimalLongitude	decimalLongitude	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://aims.fao.org/aos/agrontology#surroundedBy	22	\N	1358	surroundedBy	surroundedBy	f	22	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
357	http://rdf.geospecies.org/ont/geospecies#hasStartDayOfYear	13	\N	69	hasStartDayOfYear	hasStartDayOfYear	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
358	http://www.w3.org/2008/05/skos-xl#prefLabel	505193	\N	71	prefLabel	prefLabel	f	505193	\N	\N	f	f	1117	736	\N	t	f	\N	\N	\N	t	f	f
359	http://www.geneontology.org/formats/oboInOwl#hasRelatedSynonym	314758	\N	1361	hasRelatedSynonym	hasRelatedSynonym	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://aims.fao.org/aos/agrontology#hasComposition	124	\N	1358	hasComposition	hasComposition	f	124	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
362	http://aims.fao.org/aos/agrontology#hasPostProductionPractice	1	\N	1358	hasPostProductionPractice	hasPostProductionPractice	f	1	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
363	http://www.w3.org/ns/prov#generatedAtTime	1	\N	26	generatedAtTime	generatedAtTime	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://purl.org/ontology/bibo/doi	4010	\N	31	doi	doi	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://rs.tdwg.org/dwc/iri/inDescribedPlace	577843	\N	1373	inDescribedPlace	inDescribedPlace	f	577843	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://www.w3.org/2007/05/powder-s#describedby	126261	\N	1374	describedby	describedby	f	126261	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://purl.org/dc/terms/rightsHolder	5	\N	5	rightsHolder	rightsHolder	f	5	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
370	http://purl.org/dc/terms/modified	179718	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
371	http://creativecommons.org/ns#License	13	\N	23	License	License	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
372	http://www.w3.org/2002/07/owl#sameAs	254729	\N	7	sameAs	sameAs	f	254729	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://aims.fao.org/aos/agrontology#hasSubstitute	2	\N	1358	hasSubstitute	hasSubstitute	f	2	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
374	http://aims.fao.org/aos/agrontology#hasPropagationMaterial	5	\N	1358	hasPropagationMaterial	hasPropagationMaterial	f	5	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
375	http://rs.tdwg.org/dwc/terms/county	39	\N	1364	county	county	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
376	http://aims.fao.org/aos/agrontology#hasParent	12	\N	1358	hasParent	hasParent	f	12	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
377	http://rdf.geospecies.org/ont/geospecies#hasGNIPage	21	\N	69	hasGNIPage	hasGNIPage	f	21	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://purl.org/dc/terms/language	39823	\N	5	language	language	f	8	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://aims.fao.org/aos/agrontology#hasAcronym	1681	\N	1358	hasAcronym	hasAcronym	f	1681	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
382	http://rdf.geospecies.org/ont/geospecies#hasGBIFPage	1115	\N	69	hasGBIFPage	hasGBIFPage	f	1115	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
383	http://aims.fao.org/aos/agrontology#hasProduct	115	\N	1358	hasProduct	hasProduct	f	115	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
384	http://www.w3.org/ns/prov#used	1	\N	26	used	used	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://www.geneontology.org/formats/oboInOWL#xref	82	\N	1375	xref	xref	f	82	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
386	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	256	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://purl.org/dc/terms/references	2	\N	5	references	references	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://rdf.geospecies.org/ont/geospecies#hasBBCPage	309	\N	69	hasBBCPage	hasBBCPage	f	309	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
389	http://www.w3.org/2000/01/rdf-schema#label	7834864	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://purl.org/dc/terms/title	232430	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
391	http://purl.obolibrary.org/obo/vto#has_rank	106313	\N	1369	has_rank	has_rank	f	106263	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://www.w3.org/2002/07/owl#hasValue	32	\N	7	hasValue	hasValue	f	32	\N	\N	f	f	1109	\N	\N	t	f	\N	\N	\N	t	f	f
441	http://rdf.geospecies.org/ont/geospecies#hasOmernik_3_Ecozone	39	\N	69	hasOmernik_3_Ecozone	hasOmernik_3_Ecozone	f	39	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
365	http://www.wikidata.org/prop/direct/P3005	1845134	\N	13	[valid in place (Wikidata) (P3005)]	P3005	f	1845134	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
367	http://www.wikidata.org/prop/direct/P1070	107764	\N	13	[The Plant List (TPL) ID (Wikidata) (P1070)]	P1070	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
380	http://www.wikidata.org/prop/direct/P298	35	\N	13	[ISO 3166-1 alpha-3 code (Wikidata) (P298)]	P298	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
393	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#isPossibleMosquitoVectorOfVirus	65	\N	112	isPossibleMosquitoVectorOfVirus	isPossibleMosquitoVectorOfVirus	f	65	\N	\N	f	f	264	1118	\N	t	f	\N	\N	\N	t	f	f
394	http://www.w3.org/2004/02/skos/core#relatedMatch	2197	\N	4	relatedMatch	relatedMatch	f	1992	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://aims.fao.org/aos/agrontology#growsln	20	\N	1358	growsln	growsln	f	20	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
396	http://www.w3.org/2004/02/skos/core#prefLabel	1300392	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
397	http://aims.fao.org/aos/agrontology#includes	1789	\N	1358	includes	includes	f	1789	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
398	http://taxref.mnhn.fr/lod/property/hasSynonym	972914	\N	1360	hasSynonym	hasSynonym	f	972914	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
399	ttp://www.geneontology.org/formats/oboInOwl#created_by	1	\N	1376	created_by	created_by	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://taxref.mnhn.fr/lod/property/isReferenceNameOf	288739	\N	1360	isReferenceNameOf	isReferenceNameOf	f	288739	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://purl.org/dc/elements/1.1/relation	72	\N	6	relation	relation	f	72	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
402	http://taxref.mnhn.fr/lod/property/hasReferenceName	789217	\N	1360	hasReferenceName	hasReferenceName	f	789217	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://rdf.geospecies.org/ont/geospecies#hasCountyName	52	\N	69	hasCountyName	hasCountyName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://rs.tdwg.org/dwc/terms/country	39	\N	1364	country	country	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://aims.fao.org/aos/agrontology#hasTheme	171	\N	1358	hasTheme	hasTheme	f	171	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
406	http://rdf.geospecies.org/ont/geospecies#hasOrderName	20739	\N	69	hasOrderName	hasOrderName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
407	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	2055	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://www.w3.org/2003/01/geo/wgs84_pos#long	996	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://schema.org/url	1	\N	9	url	url	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
410	http://purl.uniprot.org/core/rank	20875	\N	77	rank	rank	f	20875	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://www.w3.org/2004/02/skos/core#scopeNote	14898	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
412	http://www.openlinksw.com/ontology/acl#hasApplicableAccess	2	\N	1043	hasApplicableAccess	hasApplicableAccess	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
413	http://dbpedia.org/property/hasPhotoCollection	12629	\N	19	hasPhotoCollection	hasPhotoCollection	f	12629	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://aims.fao.org/aos/agrontology#hasObjectOfActivity	380	\N	1358	hasObjectOfActivity	hasObjectOfActivity	f	380	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
415	http://rdf.geospecies.org/ont/geospecies#isUnexpectedIn	21665	\N	69	isUnexpectedIn	isUnexpectedIn	f	21665	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
416	http://rdf.geospecies.org/ont/geospecies#siteFamily	3	\N	69	siteFamily	siteFamily	f	3	\N	\N	f	f	\N	1511	\N	t	f	\N	\N	\N	t	f	f
417	http://rdf.geospecies.org/ont/geospecies#closeMatch	8	\N	69	closeMatch	closeMatch	f	8	\N	\N	f	f	\N	474	\N	t	f	\N	\N	\N	t	f	f
418	http://rdfs.org/ns/void#linkPredicate	3	\N	16	linkPredicate	linkPredicate	f	3	\N	\N	f	f	978	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://umbel.org/umbel#isAligned	49	\N	32	isAligned	isAligned	f	49	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
420	http://www.w3.org/ns/prov#wasDerivedFrom	1	\N	26	wasDerivedFrom	wasDerivedFrom	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
421	http://lod.taxonconcept.org/ontology/txn.owl#hasWikispeciesArticle	9713	\N	346	hasWikispeciesArticle	hasWikispeciesArticle	f	9713	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
422	http://lod.taxonconcept.org/ontology/txn.owl#hasITISPage	56786	\N	346	hasITISPage	hasITISPage	f	56786	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
423	http://aims.fao.org/aos/agrontology#smallerThan	2	\N	1358	smallerThan	smallerThan	f	2	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
424	http://rdf.geospecies.org/ont/geospecies#hasStateProvinceName	52	\N	69	hasStateProvinceName	hasStateProvinceName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
425	http://aims.fao.org/aos/agrontology#performs	5	\N	1358	performs	performs	f	5	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
426	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
427	http://schema.org/datePublished	43404	\N	9	datePublished	datePublished	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
428	http://schema.org/dateModified	1	\N	9	dateModified	dateModified	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
429	http://purl.org/pav/createdOn	1	\N	1377	createdOn	createdOn	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
430	http://purl.org/dc/terms/coverage	1845175	\N	5	coverage	coverage	f	1845134	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
431	http://aims.fao.org/aos/agrontology#influences	2165	\N	1358	influences	influences	f	2165	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
432	http://www.w3.org/2002/07/owl#complementOf	4	\N	7	complementOf	complementOf	f	4	\N	\N	f	f	740	740	\N	t	f	\N	\N	\N	t	f	f
433	http://schema.org/about	2	\N	9	about	about	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
434	http://www.w3.org/2004/02/skos/core#related	2344	\N	4	related	related	f	2344	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
435	http://lod.taxonconcept.org/ontology/mos_path.owl#isPossibleVectorOf	106	\N	124	isPossibleVectorOf	isPossibleVectorOf	f	106	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
436	http://rdfs.org/ns/void#sparqlEndpoint	1	\N	16	sparqlEndpoint	sparqlEndpoint	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
438	http://rdf.geospecies.org/ont/geospecies#hasArticle	1	\N	69	hasArticle	hasArticle	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
439	http://purl.org/vocommons/voaf#classNumber	1	\N	35	classNumber	classNumber	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
440	http://purl.org/dc/terms/bibliographicCitation	43602	\N	5	bibliographicCitation	bibliographicCitation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
442	http://www.w3.org/2000/01/rdf-schema#comment	1275	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
443	http://lod.taxonconcept.org/ontology/txn.owl#isExpectedIn	108042	\N	346	isExpectedIn	isExpectedIn	f	108042	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
444	http://www.w3.org/2004/02/skos/core#historyNote	2	\N	4	historyNote	historyNote	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
445	http://www.w3.org/2008/05/skos-xl#literalForm	743558	\N	71	literalForm	literalForm	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
446	http://creativecommons.org/ns#attributionName	39820	\N	23	attributionName	attributionName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
447	http://rs.tdwg.org/dwc/terms/phylum	242926	\N	1364	phylum	phylum	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
448	http://www.w3.org/ns/dcat#servesDataset	1	\N	15	servesDataset	servesDataset	f	1	\N	\N	f	f	\N	476	\N	t	f	\N	\N	\N	t	f	f
449	http://aims.fao.org/aos/agrontology#hasNearSynonym	20048	\N	1358	hasNearSynonym	hasNearSynonym	f	20048	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
450	http://rdf.geospecies.org/ont/geospecies#hasSpecies	51	\N	69	hasSpecies	hasSpecies	f	51	\N	\N	f	f	\N	1118	\N	t	f	\N	\N	\N	t	f	f
451	http://aims.fao.org/aos/agrontology#hasOldName	975	\N	1358	hasOldName	hasOldName	f	975	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
452	http://www.w3.org/2003/06/sw-vocab-status/ns#term_status	252	\N	75	term_status	term_status	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
453	http://aims.fao.org/aos/agrontology#hasSingular	253	\N	1358	hasSingular	hasSingular	f	0	\N	\N	f	f	736	\N	\N	t	f	\N	\N	\N	t	f	f
454	http://aims.fao.org/aos/agrontology#isMeansFor	70	\N	1358	isMeansFor	isMeansFor	f	70	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
455	http://aims.fao.org/aos/agrontology#includesSubprocess	4	\N	1358	includesSubprocess	includesSubprocess	f	4	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
456	http://aims.fao.org/aos/agrontology#isLocalNameOf	1	\N	1358	isLocalNameOf	isLocalNameOf	f	1	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
457	http://www.w3.org/2000/01/rdf-schema#domain	778	\N	2	domain	domain	f	778	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
458	http://schema.org/copyrightHolder	56706	\N	9	copyrightHolder	copyrightHolder	f	56706	\N	\N	f	f	1360	57	\N	t	f	\N	\N	\N	t	f	f
459	http://lod.taxonconcept.org/ontology/txn.owl#taxonNameID	117096	\N	346	taxonNameID	taxonNameID	f	117096	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
460	http://rs.tdwg.org/dwc/terms/geodeticDatum	39	\N	1364	geodeticDatum	geodeticDatum	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
461	http://purl.org/dc/elements/1.1/contributor	7	\N	6	contributor	contributor	f	0	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
462	http://www.geneontology.org/formats/oboInOwl#hasScope	18	\N	1361	hasScope	hasScope	f	3	\N	\N	f	f	1111	\N	\N	t	f	\N	\N	\N	t	f	f
463	http://xmlns.com/foaf/0.1/topic	129124	\N	8	topic	topic	f	129124	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
464	http://aims.fao.org/aos/agrontology#hasMember	1111	\N	1358	hasMember	hasMember	f	1111	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
465	http://aims.fao.org/aos/agrontology#hasTaxonomicRank	7534	\N	1358	hasTaxonomicRank	hasTaxonomicRank	f	7534	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
466	http://rs.tdwg.org/dwc/terms/subfamily	130773	\N	1364	subfamily	subfamily	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
467	http://creativecommons.org/ns#morePermissions	39812	\N	23	morePermissions	morePermissions	f	39812	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
468	http://www.w3.org/2004/02/skos/core#altLabel	144422	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
469	http://schema.org/keywords	7	\N	9	keywords	keywords	f	0	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
470	http://www.w3.org/2002/07/owl#annotatedTarget	386552	\N	7	annotatedTarget	annotatedTarget	f	10	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
471	http://www.w3.org/2004/02/skos/core#narrowMatch	10647	\N	4	narrowMatch	narrowMatch	f	10647	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
472	http://rdf.geospecies.org/ont/geospecies#hasITIS	15903	\N	69	hasITIS	hasITIS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
473	http://www.w3.org/2003/11/swrl#propertyPredicate	51	\N	70	propertyPredicate	propertyPredicate	f	51	\N	\N	f	f	1730	\N	\N	t	f	\N	\N	\N	t	f	f
474	http://rdf.geospecies.org/ont/geospecies#hasEndDayOfYear	13	\N	69	hasEndDayOfYear	hasEndDayOfYear	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
475	http://rdf.geospecies.org/ont/geospecies#hasUUID	18891	\N	69	hasUUID	hasUUID	f	18891	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
476	http://rdf.geospecies.org/ont/geospecies#hasBioLib	267	\N	69	hasBioLib	hasBioLib	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
477	http://lod.taxonconcept.org/ontology/txn.owl#thumbnail	16846	\N	346	thumbnail	thumbnail	f	16846	\N	\N	f	f	748	\N	\N	t	f	\N	\N	\N	t	f	f
478	http://aims.fao.org/aos/agrontology#isPartOf	31	\N	1358	isPartOf	isPartOf	f	31	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
479	http://aims.fao.org/aos/agrontology#hasSymptom	44	\N	1358	hasSymptom	hasSymptom	f	44	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
480	http://www.w3.org/2002/07/owl#propertyDisjointWith	2	\N	7	propertyDisjointWith	propertyDisjointWith	f	2	\N	\N	f	f	907	907	\N	t	f	\N	\N	\N	t	f	f
481	http://aims.fao.org/aos/agrontology#hasAntonym	8	\N	1358	hasAntonym	hasAntonym	f	8	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
482	http://www.openlinksw.com/schemas/VAD#packageDeveloper	4	\N	311	packageDeveloper	packageDeveloper	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
483	http://www.w3.org/2001/vcard-rdf/3.0#Street	6	\N	1224	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
484	http://purl.org/dc/elements/1.1/rights	416	\N	6	rights	rights	f	416	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
485	http://purl.obolibrary.org/obo/RO_0001900	37	\N	40	RO_0001900	RO_0001900	f	37	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
486	http://aims.fao.org/aos/agrontology#isPartOfSubvocabulary	1952	\N	1358	isPartOfSubvocabulary	isPartOfSubvocabulary	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
487	http://rdf.geospecies.org/ont/geospecies#hasDateRange	26	\N	69	hasDateRange	hasDateRange	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
488	http://www.w3.org/2001/vcard-rdf/3.0#ADR	6	\N	1224	ADR	ADR	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
489	http://www.w3.org/2002/07/owl#someValuesFrom	588	\N	7	someValuesFrom	someValuesFrom	f	588	\N	\N	f	f	1109	\N	\N	t	f	\N	\N	\N	t	f	f
490	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
491	http://www.w3.org/2003/11/swrl#argument2	51	\N	70	argument2	argument2	f	51	\N	\N	f	f	1730	1844	\N	t	f	\N	\N	\N	t	f	f
492	http://www.w3.org/ns/dcat#mediaType	4	\N	15	mediaType	mediaType	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
493	http://www.geneontology.org/formats/oboInOwl#hasNarrowSynonym	255	\N	1361	hasNarrowSynonym	hasNarrowSynonym	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
494	http://www.w3.org/2003/11/swrl#argument1	57	\N	70	argument1	argument1	f	57	\N	\N	f	f	\N	1844	\N	t	f	\N	\N	\N	t	f	f
495	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
496	http://rdf.geospecies.org/ont/geospecies#hasProject	72	\N	69	hasProject	hasProject	f	72	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
497	http://aims.fao.org/aos/agrontology#hasScientificName	17680	\N	1358	hasScientificName	hasScientificName	f	17680	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
499	http://schema.org/contentUrl	56706	\N	9	contentUrl	contentUrl	f	56706	\N	\N	f	f	1360	\N	\N	t	f	\N	\N	\N	t	f	f
500	http://rdf.geospecies.org/ont/geospecies#hasGeoSpeciesPage	20875	\N	69	hasGeoSpeciesPage	hasGeoSpeciesPage	f	20875	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
501	http://www.w3.org/2004/02/skos/core#broader	319798	\N	4	broader	broader	f	319798	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
502	http://rs.tdwg.org/dwc/terms/georeferenceVerificationStatus	39	\N	1364	georeferenceVerificationStatus	georeferenceVerificationStatus	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
503	http://xmlns.com/foaf/0.1/maker	2	\N	8	maker	maker	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
504	http://www.geneontology.org/formats/oboInOWL#hasExactSynonym	8	\N	1375	hasExactSynonym	hasExactSynonym	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
505	http://www.w3.org/2004/02/skos/core#hasTopConcept	193	\N	4	hasTopConcept	hasTopConcept	f	193	\N	\N	f	f	\N	1117	\N	t	f	\N	\N	\N	t	f	f
506	http://www.openlinksw.com/schemas/DAV#ownerUser	1187	\N	18	ownerUser	ownerUser	f	1187	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
509	http://schema.org/name	50223	\N	9	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
510	http://rdfs.org/ns/void#statItem	1	\N	16	statItem	statItem	f	1	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
512	http://purl.org/dc/terms/isReferencedBy	1	\N	5	isReferencedBy	isReferencedBy	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
513	http://rs.tdwg.org/dwc/terms/decimalLatitude	39	\N	1364	decimalLatitude	decimalLatitude	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
514	http://rdf.geospecies.org/ont/geospecies#hasWisconsinHerbariumHabitatAssociation	12	\N	69	hasWisconsinHerbariumHabitatAssociation	hasWisconsinHerbariumHabitatAssociation	f	12	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
515	http://www.w3.org/2002/07/owl#versionIRI	5	\N	7	versionIRI	versionIRI	f	5	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
516	http://lod.taxonconcept.org/ontology/txn.owl#taxonNameID_Of	117095	\N	346	taxonNameID_Of	taxonNameID_Of	f	117095	\N	\N	f	f	1170	748	\N	t	f	\N	\N	\N	t	f	f
517	http://rs.tdwg.org/dwc/terms/kingdom	285855	\N	1364	kingdom	kingdom	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
518	http://purl.org/dc/terms/identifier	1274285	\N	5	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
519	http://rdfs.org/ns/void#subset	10	\N	16	subset	subset	f	10	\N	\N	f	f	476	978	\N	t	f	\N	\N	\N	t	f	f
520	http://purl.obolibrary.org/obo/RO_0004049	7	\N	40	RO_0004049	RO_0004049	f	7	\N	\N	f	f	907	907	\N	t	f	\N	\N	\N	t	f	f
521	http://rdf.geospecies.org/ont/geospecies#hasSubfamilyName	9144	\N	69	hasSubfamilyName	hasSubfamilyName	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
522	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#humanMalarialParasiteHasPossibleMosquitoVector	25	\N	112	humanMalarialParasiteHasPossibleMosquitoVector	humanMalarialParasiteHasPossibleMosquitoVector	f	25	\N	\N	f	f	1118	1118	\N	t	f	\N	\N	\N	t	f	f
523	http://lod.taxonconcept.org/ontology/txn.owl#hasLowExpectationOf	127055	\N	346	hasLowExpectationOf	hasLowExpectationOf	f	127055	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
524	http://schema.org/license	56708	\N	9	license	license	f	56708	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
526	http://swrl.stanford.edu/ontologies/3.3/swrla.owl#isRuleEnabled	2	\N	1378	isRuleEnabled	isRuleEnabled	f	0	\N	\N	f	f	1536	\N	\N	t	f	\N	\N	\N	t	f	f
527	http://lod.taxonconcept.org/ontology/txn.owl#scientificName	119517	\N	346	scientificName	scientificName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
528	http://aims.fao.org/aos/agrontology#hasBreedingMethod	1	\N	1358	hasBreedingMethod	hasBreedingMethod	f	1	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
529	http://purl.org/dc/elements/1.1/source	3	\N	6	source	source	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
530	http://rdf.geospecies.org/ont/geospecies#hasLocation	34	\N	69	hasLocation	hasLocation	f	34	\N	\N	f	f	\N	27	\N	t	f	\N	\N	\N	t	f	f
531	http://aims.fao.org/aos/agrontology#formerlyIncludes	28	\N	1358	formerlyIncludes	formerlyIncludes	f	28	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
532	http://purl.obolibrary.org/obo/is_metadata_tag	1	\N	40	is_metadata_tag	is_metadata_tag	f	0	\N	\N	f	f	478	\N	\N	t	f	\N	\N	\N	t	f	f
533	http://www.w3.org/2004/02/skos/core#exactMatch	241200	\N	4	exactMatch	exactMatch	f	241200	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
534	http://purl.org/dc/terms/source	805614	\N	5	source	source	f	805614	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
535	http://aims.fao.org/aos/agrontology#isPathogenOf	1376	\N	1358	isPathogenOf	isPathogenOf	f	1376	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
536	http://www.w3.org/2003/11/swrl#head	16	\N	70	head	head	f	16	\N	\N	f	f	1536	1454	\N	t	f	\N	\N	\N	t	f	f
537	http://purl.org/dc/terms/accessRights	2	\N	5	accessRights	accessRights	f	2	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
498	http://purl.obolibrary.org/obo/RO_0004050	7	\N	40	[is negative form of (RO_0004050)]	RO_0004050	f	7	\N	\N	f	f	907	907	\N	t	f	\N	\N	\N	t	f	f
507	http://www.wikidata.org/prop/direct/P1348	88454	\N	13	[AlgaeBase ID (Wikidata) (P1348)]	P1348	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
508	http://www.wikidata.org/prop/direct/P4855	860	\N	13	[Phasmida Species File Online ID (Wikidata) (P4855)]	P4855	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
511	http://www.wikidata.org/prop/direct/P2561	43049	\N	13	[name (Wikidata) (P2561)]	P2561	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
538	http://rdf.geospecies.org/ont/geospecies#isNotUSDA_ExpectedIn	127098	\N	69	isNotUSDA_ExpectedIn	isNotUSDA_ExpectedIn	f	127098	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
539	http://rdf.geospecies.org/ont/geospecies#hasTreeBaseID	46	\N	69	hasTreeBaseID	hasTreeBaseID	f	0	\N	\N	f	f	1118	\N	\N	t	f	\N	\N	\N	t	f	f
540	http://lod.taxonconcept.org/ontology/txn.owl#hasExpectationOf	108085	\N	346	hasExpectationOf	hasExpectationOf	f	108085	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
541	http://www.w3.org/ns/dcat#version	2	\N	15	version	version	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
542	http://www.w3.org/2000/01/rdf-schema#subClassOf	2074152	\N	2	subClassOf	subClassOf	f	2074152	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
543	http://rdf.geospecies.org/ont/geospecies#hasObservationOf	24	\N	69	hasObservationOf	hasObservationOf	f	24	\N	\N	f	f	\N	1118	\N	t	f	\N	\N	\N	t	f	f
544	http://www.w3.org/2002/07/owl#hasSelf	6	\N	7	hasSelf	hasSelf	f	0	\N	\N	f	f	1109	\N	\N	t	f	\N	\N	\N	t	f	f
545	http://rs.tdwg.org/dwc/terms/scientificName	657609	\N	1364	scientificName	scientificName	f	0	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
546	http://www.w3.org/2002/07/owl#oneOf	2	\N	7	oneOf	oneOf	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
547	http://www.w3.org/2004/02/skos/core#exactMatct	35	\N	4	exactMatct	exactMatct	f	35	\N	\N	f	f	1117	\N	\N	t	f	\N	\N	\N	t	f	f
548	http://www.w3.org/2002/07/owl#equivalentProperty	206	\N	7	equivalentProperty	equivalentProperty	f	206	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
549	http://www.w3.org/2003/11/swrl#classPredicate	6	\N	70	classPredicate	classPredicate	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
550	http://rs.tdwg.org/dwc/terms/genus	220789	\N	1364	genus	genus	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
551	http://www.w3.org/1999/02/22-rdf-syntax-ns#subject	41092	\N	1	subject	subject	f	41092	\N	\N	f	f	921	\N	\N	t	f	\N	\N	\N	t	f	f
552	http://rs.tdwg.org/ontology/Base#definition	1387	\N	1379	definition	definition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
554	http://xmlns.com/foaf/0.1/fundedBy	5	\N	8	fundedBy	fundedBy	f	5	\N	\N	f	f	476	\N	\N	t	f	\N	\N	\N	t	f	f
555	http://rdfs.org/ns/void#objectsTarget	3	\N	16	objectsTarget	objectsTarget	f	3	\N	\N	f	f	978	476	\N	t	f	\N	\N	\N	t	f	f
556	http://aims.fao.org/aos/agrontology#benefitsFrom	49	\N	1358	benefitsFrom	benefitsFrom	f	49	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
557	http://taxref.mnhn.fr/lod/property/isSynonymOf	371746	\N	1360	isSynonymOf	isSynonymOf	f	371746	\N	\N	f	f	261	740	\N	t	f	\N	\N	\N	t	f	f
558	http://rdf.geospecies.org/ont/geospecies#hasCommonName	12618	\N	69	hasCommonName	hasCommonName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
559	http://aims.fao.org/aos/agrontology#causes	530	\N	1358	causes	causes	f	530	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
560	http://purl.obolibrary.org/obo/definition	1	\N	40	definition	definition	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
561	http://purl.org/vocab/vann/preferredNamespaceUri	2	\N	24	preferredNamespaceUri	preferredNamespaceUri	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
562	http://www.geneontology.org/formats/oboInOwl#hasBroadSynonym	1559	\N	1361	hasBroadSynonym	hasBroadSynonym	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
563	http://www.w3.org/2001/vcard-rdf/3.0#Country	6	\N	1224	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
564	http://www.w3.org/2000/01/rdf-schema#seeAlso	65389	\N	2	seeAlso	seeAlso	f	65366	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
565	http://www.openlinksw.com/schemas/VAD#packageDownload	8	\N	311	packageDownload	packageDownload	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
566	http://aims.fao.org/aos/agrontology#isComposedOf	181	\N	1358	isComposedOf	isComposedOf	f	181	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
567	http://rdf.geospecies.org/ont/geospecies#hasUSDA_ExpectationOf	65724	\N	69	hasUSDA_ExpectationOf	hasUSDA_ExpectationOf	f	65724	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
568	http://aims.fao.org/aos/agrontology#hasPropagationProcess	10	\N	1358	hasPropagationProcess	hasPropagationProcess	f	10	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
569	http://aims.fao.org/aos/agrontology#hasBroaderSynonym	9381	\N	1358	hasBroaderSynonym	hasBroaderSynonym	f	9381	\N	\N	f	f	736	736	\N	t	f	\N	\N	\N	t	f	f
570	http://www.geneontology.org/formats/oboInOwl#hasExactSynonym	64756	\N	1361	hasExactSynonym	hasExactSynonym	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
571	http://rdf.geospecies.org/ont/geospecies#hasBBC_Ecozone	39	\N	69	hasBBC_Ecozone	hasBBC_Ecozone	f	39	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
572	http://www.w3.org/2003/11/swrl#body	16	\N	70	body	body	f	16	\N	\N	f	f	1536	1454	\N	t	f	\N	\N	\N	t	f	f
573	http://rdf.geospecies.org/ont/geospecies#hasExpectationOf	24801	\N	69	hasExpectationOf	hasExpectationOf	f	24801	\N	\N	f	f	\N	1118	\N	t	f	\N	\N	\N	t	f	f
574	http://rs.tdwg.org/dwc/terms/attributes/organizedInClass	177	\N	1368	organizedInClass	organizedInClass	f	177	\N	\N	f	f	256	\N	\N	t	f	\N	\N	\N	t	f	f
575	http://aims.fao.org/aos/agrontology#hasPractice	187	\N	1358	hasPractice	hasPractice	f	187	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
576	http://www.w3.org/2004/02/skos/core#broaderTransitive	20867	\N	4	broaderTransitive	broaderTransitive	f	20867	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
577	http://xmlns.com/foaf/0.1/isPrimaryTopicOf	96572	\N	8	isPrimaryTopicOf	isPrimaryTopicOf	f	96572	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
578	http://aims.fao.org/aos/agrontology#hasGoalOrProcess	122	\N	1358	hasGoalOrProcess	hasGoalOrProcess	f	122	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
579	http://xmlns.com/foaf/0.1/thumbnail	415	\N	8	thumbnail	thumbnail	f	415	\N	\N	f	f	1125	\N	\N	t	f	\N	\N	\N	t	f	f
580	http://www.w3.org/2003/01/geo/wgs84_pos#alt	7	\N	25	alt	alt	f	0	\N	\N	f	f	302	\N	\N	t	f	\N	\N	\N	t	f	f
581	http://www.openlinksw.com/schemas/VAD#packageCopyright	4	\N	311	packageCopyright	packageCopyright	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
582	http://rs.tdwg.org/dwc/terms/family	271958	\N	1364	family	family	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
583	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
584	http://rdfs.org/ns/void#triples	4	\N	16	triples	triples	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
585	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
586	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
587	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
588	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
589	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
590	http://www.w3.org/2001/vcard-rdf/3.0#TEL	6	\N	1224	TEL	TEL	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
591	http://purl.org/vocab/vann/preferredNamespacePrefix	2	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
593	http://www.openlinksw.com/ontology/acl#hasDefaultAccess	2	\N	1043	hasDefaultAccess	hasDefaultAccess	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
594	http://aims.fao.org/aos/agrontology#produces	502	\N	1358	produces	produces	f	502	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
595	http://www.w3.org/2003/01/geo/wgs84_pos#lat	996	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
596	http://taxref.mnhn.fr/lod/property/vernacularName	293855	\N	1360	vernacularName	vernacularName	f	0	\N	\N	f	f	740	\N	\N	t	f	\N	\N	\N	t	f	f
597	http://rs.tdwg.org/dwc/iri/occurrenceStatus	577843	\N	1373	occurrenceStatus	occurrenceStatus	f	577843	\N	\N	f	f	\N	1117	\N	t	f	\N	\N	\N	t	f	f
598	http://aims.fao.org/aos/agrontology#isThemeOf	1	\N	1358	isThemeOf	isThemeOf	f	1	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
599	http://rdf.geospecies.org/ont/families/wQViY/wQViY_ontology.owl#humanVirusHasPossibleMosquitoVector	65	\N	112	humanVirusHasPossibleMosquitoVector	humanVirusHasPossibleMosquitoVector	f	65	\N	\N	f	f	1118	264	\N	t	f	\N	\N	\N	t	f	f
600	http://www.w3.org/2002/07/owl#allValuesFrom	2	\N	7	allValuesFrom	allValuesFrom	f	2	\N	\N	f	f	1109	740	\N	t	f	\N	\N	\N	t	f	f
601	http://xmlns.com/foaf/0.1/depiction	58659	\N	8	depiction	depiction	f	58659	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
602	http://schema.org/propertyID	2365569	\N	9	propertyID	propertyID	f	2365569	\N	\N	f	f	737	\N	\N	t	f	\N	\N	\N	t	f	f
603	http://purl.org/dc/terms/created	687863	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
604	http://rdf.geospecies.org/ont/geospecies#hasObservationMethod	13	\N	69	hasObservationMethod	hasObservationMethod	f	13	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
605	http://aims.fao.org/aos/agrontology#developsInto	34	\N	1358	developsInto	developsInto	f	34	\N	\N	f	f	1117	1117	\N	t	f	\N	\N	\N	t	f	f
606	http://rdfs.org/ns/void#rootResource	1	\N	16	rootResource	rootResource	f	1	\N	\N	f	f	476	1117	\N	t	f	\N	\N	\N	t	f	f
607	http://lod.taxonconcept.org/ontology/txn.owl#isUnexpectedIn	127098	\N	346	isUnexpectedIn	isUnexpectedIn	f	127098	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
608	http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate	41100	\N	1	predicate	predicate	f	41100	\N	\N	f	f	921	907	\N	t	f	\N	\N	\N	t	f	f
5	http://www.wikidata.org/prop/direct/P627	25092	\N	13	[IUCN taxon ID (P627)]	P627	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.wikidata.org/prop/direct/P961	86054	\N	13	[IPNI ID (Wikidata) (P961)]	P961	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://www.wikidata.org/prop/direct/P300	130	\N	13	[ISO 3166-2 code (Wikidata) (P300)]	P300	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://purl.obolibrary.org/obo/RO_0002581	3	\N	40	[is a defining property chain axiom (RO_0002581)]	RO_0002581	f	0	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://purl.obolibrary.org/obo/RO_0002458	1147	\N	40	[preyed upon by (RO_0002458)]	RO_0002458	f	1147	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://www.wikidata.org/prop/direct/P6052	426	\N	13	[Cockroach Species File Online ID (Wikidata) (P6052)]	P6052	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
186	http://purl.obolibrary.org/obo/RO_0002440	3900	\N	40	[symbiotically interacts with (RO_0002440)]	RO_0002440	f	3900	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://purl.obolibrary.org/obo/RO_0002560	1	\N	40	[is asymmetric relational form of process class (RO_0002560)]	RO_0002560	f	1	\N	\N	f	f	907	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://purl.obolibrary.org/obo/RO_0002423	1	\N	40	[logical macro assertion on an annotation property (RO_0002423)]	RO_0002423	f	0	\N	\N	f	f	1111	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://purl.obolibrary.org/obo/RO_0002633	461	\N	40	[has ectoparasite (RO_0002633)]	RO_0002633	f	461	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://purl.obolibrary.org/obo/IAO_0000589	20	\N	40	[OBO foundry unique label (IAO_0000589)]	IAO_0000589	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
437	http://www.wikidata.org/prop/direct/P1391	295714	\N	13	[Index Fungorum ID (Wikidata) (P1391)]	P1391	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
525	http://www.wikidata.org/prop/direct/P4630	2406	\N	13	[DORIS ID (Wikidata) (P4630)]	P4630	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
553	http://www.wikidata.org/prop/direct/P1895	307914	\N	13	[Fauna Europaea ID (Wikidata) (P1895)]	P1895	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
592	http://www.wikidata.org/prop/direct/P938	93460	\N	13	[FishBase ID (Wikidata) (P938)]	P938	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

COPY https_taxref_mnhn_fr_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	5	8	IUCN taxon ID	\N
2	7	8	Has spelling variant	en
3	9	8	Using value	en
4	13	8	Is output from	en
5	14	8	Has chemical formula	en
6	15	8	hasBBCPage	\N
7	16	8	Measures	en
8	23	8	hasEUNISPage	\N
9	31	8	priorVersion	\N
10	31	8	priorVersion	\N
11	32	8	Is derived from	en
12	35	8	Has component	en
13	38	8	Has property	en
14	40	8	ZooBank ID (Wikidata)	\N
15	41	8	uniprotFamily	en
16	42	8	GBIF ID (Wikidata)	\N
17	44	8	order	\N
18	46	8	IPNI ID (Wikidata)	\N
19	47	8	TROPICOS ID (Wikidata)	\N
20	48	8	VASCAN ID (Wikidata)	\N
21	51	8	hasWikipediaArticle	\N
22	56	8	uniprotClass	en
23	57	8	subPropertyOf	\N
24	60	8	term replaced by	en
25	60	8	term replaced by	\N
26	60	8	Term replaced by	\N
27	61	8	Has local name	en
28	65	8	WoRMS ID (Wikidata)	\N
29	67	8	transports	\N
30	68	8	DarwinCore Equivalence	\N
31	75	8	expand assertion to	\N
32	77	8	has_alternative_id	\N
33	77	8	has_alternative_id	\N
34	82	8	Continent	en
35	85	8	ABCD Equivalence	\N
36	86	8	has_synonym_type	\N
37	86	8	has_synonym_type	\N
38	86	8	has_synonym_type	\N
39	88	8	ISO 3166-2 code (Wikidata)	\N
40	95	8	State Province	en
41	96	8	Is spatially included in city	en
42	97	8	Affects	en
43	106	8	Controls	en
44	109	8	genus	\N
45	111	8	Spatially includes	en
46	116	8	intersectionOf	\N
47	116	8	intersectionOf	\N
48	118	8	shorthand	\N
49	120	8	provides nutrients for	\N
50	125	8	Has disease	en
51	129	8	authority	\N
52	130	8	SANDRE ID (Wikidata)	\N
53	131	8	Uses process	en
54	132	8	family	\N
55	133	8	Has symbol	en
56	135	8	Has plural	en
57	136	8	is a defining property chain axiom	\N
58	137	8	is a defining property chain axiom where second argument is reflexive	\N
59	138	8	TDWG Code	\N
60	142	8	pollinates	\N
61	143	8	pollinated by	\N
62	144	8	Mantodea Species File Online ID (Wikidata)	\N
63	145	8	acquires nutrients from	\N
64	146	8	preyed upon by	\N
65	147	8	is indirect form of	\N
66	149	8	Orthoptera Species File Online ID (Wikidata)	\N
67	150	8	Cockroach Species File Online ID (Wikidata)	\N
68	151	8	ISO 2-Code	\N
69	159	8	is direct form of	\N
70	160	8	inverseOf	\N
71	160	8	inverseOf	\N
72	162	8	Has ISO 3 country code	en
73	164	8	parasitoid of	\N
74	165	8	class	\N
75	166	8	has parasitoid	\N
76	168	8	parasite of	\N
77	169	8	parasitized by	\N
78	174	8	definition	\N
79	174	8	definition	\N
80	177	8	Study	en
81	182	8	isDefinedBy	\N
82	186	8	symbiotically interacts with	\N
83	187	8	is symmetric relational form of process class	\N
84	188	8	commensually interacts with	\N
85	189	8	mutualistically interacts with	\N
86	190	8	is asymmetric relational form of process class	\N
87	193	8	commonName	\N
88	194	8	preys on	\N
89	196	8	Has physiological function	en
90	197	8	disjointWith	\N
91	197	8	disjointWith	\N
92	199	8	Is used as	en
93	200	8	unionOf	\N
94	200	8	unionOf	\N
95	202	8	versionInfo	\N
96	202	8	versionInfo	\N
97	210	8	logical macro assertion on an annotation property	en
98	212	8	has_obo_namespace	\N
99	212	8	has_obo_namespace	\N
100	212	8	has_obo_namespace	\N
101	214	8	Acts upon	en
102	215	8	Has trade name, has commercial name	en
103	216	8	has_rank	\N
104	220	8	Make use of	en
105	229	8	Psyl'list ID (Wikidata)	\N
106	233	8	Is abbreviation of	en
107	235	8	Country Code	en
108	236	8	Prevents	en
109	242	8	Order	en
110	244	8	distinctMembers	\N
111	244	8	distinctMembers	\N
112	245	8	Berlin Model Equivalence	\N
113	251	8	Locality	en
114	254	8	in_subset	\N
115	254	8	in_subset	\N
116	258	8	is part of	\N
117	261	8	range	\N
118	263	8	Has Synonym	en
119	275	8	Is made from	en
120	276	8	location (Wikidata)	\N
121	278	8	has endoparasite	\N
122	280	8	ectoparasite of	\N
123	281	8	The World Spider Catalog ID (Wikidata)	\N
124	283	8	has ectoparasite	\N
125	284	8	endoparasite of	\N
126	285	8	TCS Equivalence	\N
127	293	8	imports	\N
128	293	8	imports	\N
129	294	8	database_cross_reference	\N
130	294	8	database_cross_reference	\N
131	294	8	database_cross_reference	\N
132	296	8	stated in (Wikidata)	\N
133	297	8	Is acronym of	en
134	300	8	Name Complete	\N
135	303	8	Follows	en
136	304	8	Has biological control agent	en
137	310	8	Coordinate Uncertainty In Meters	en
138	312	8	onProperty	\N
139	312	8	onProperty	\N
140	317	8	kingdom	\N
141	318	8	Has term type	en
142	319	8	OBO foundry unique label	en
143	321	8	disconnected_from	\N
144	325	8	Afflicts	en
145	327	8	Tela Botanica ID	\N
146	330	8	phylum	\N
147	336	8	equivalentClass	\N
148	336	8	equivalentClass	\N
149	342	8	World Flora Online ID	\N
150	344	8	Avibase ID (Wikidata)	\N
151	346	8	Has abbreviation	en
152	347	8	consider	\N
153	355	8	Decimal Longitude	en
154	356	8	Surrounded by	en
155	359	8	has_related_synonym	\N
156	359	8	has_related_synonym	\N
157	359	8	has_related_synonym	\N
158	361	8	Has composition	en
159	362	8	Has post-production practice	en
160	365	8	valid in place (Wikidata)	\N
161	367	8	The Plant List (TPL) ID (Wikidata)	\N
162	372	8	sameAs	\N
163	372	8	sameAs	\N
164	373	8	Has substitute	en
165	374	8	Has propagation material	en
166	375	8	County	en
167	376	8	Has parent	en
168	380	8	ISO 3166-1 alpha-3 code (Wikidata)	\N
169	381	8	Has acronym	en
170	383	8	Has product	en
171	389	8	label	\N
172	392	8	hasValue	\N
173	392	8	hasValue	\N
174	395	8	Grows in	en
175	397	8	Includes	en
176	404	8	Country	en
177	405	8	Has theme	en
178	414	8	Has object of activity	en
179	421	8	hasWikispeciesArticle	\N
180	422	8	hasITISPage	\N
181	423	8	Smaller than	en
182	425	8	Performs	en
183	431	8	Influences	en
184	432	8	complementOf	\N
185	432	8	complementOf	\N
186	437	8	Index Fungorum ID (Wikidata)	\N
187	442	8	comment	\N
188	443	8	isExpectedIn	\N
189	447	8	Phylum	en
190	449	8	Has near synonym	en
191	451	8	Has old name	en
192	453	8	Has singular	en
193	454	8	Is means for	en
194	455	8	Includes subprocess	en
195	456	8	Is a local name of	en
196	457	8	domain	\N
197	459	8	taxonNameID	\N
198	460	8	Geodetic Datum	en
199	462	8	has_scope	\N
200	462	8	has_scope	\N
201	464	8	Has member	en
202	465	8	Has taxonomic rank	en
203	477	8	thumbnail	\N
204	478	8	Is part of	en
205	479	8	Has symptom	en
206	481	8	Has antonym or Has opposite	en
207	486	8	Is part of subvocabulary	en
208	489	8	someValuesFrom	\N
209	489	8	someValuesFrom	\N
210	493	8	has_narrow_synonym	\N
211	493	8	has_narrow_synonym	\N
212	497	8	Has scientific name	en
213	498	8	is negative form of	\N
214	502	8	Georeference Verification Status	en
215	507	8	AlgaeBase ID (Wikidata)	\N
216	508	8	Phasmida Species File Online ID (Wikidata)	\N
217	511	8	name (Wikidata)	\N
218	513	8	Decimal Latitude	en
219	516	8	taxonNameID_Of	\N
220	517	8	Kingdom	en
221	520	8	is positive form of	\N
222	525	8	DORIS ID (Wikidata)	\N
223	527	8	scientificName	\N
224	528	8	Has breeding method	en
225	531	8	Formerly includes	en
226	535	8	Is pathogen of	en
227	540	8	hasExpectationOf	\N
228	542	8	subClassOf	\N
229	545	8	Scientific Name	en
230	546	8	oneOf	\N
231	546	8	oneOf	\N
232	548	8	equivalentProperty	\N
233	548	8	equivalentProperty	\N
234	550	8	Genus	en
235	553	8	Fauna Europaea ID (Wikidata)	\N
236	556	8	Benefits from	en
237	559	8	Causes	en
238	562	8	has_broad_synonym	\N
239	562	8	has_broad_synonym	\N
240	564	8	seeAlso	\N
241	566	8	Is composed of	en
242	568	8	Has Propagation process	en
243	569	8	Has broader synonym	en
244	570	8	has_exact_synonym	\N
245	570	8	has_exact_synonym	\N
246	570	8	has_exact_synonym	\N
247	575	8	Has practice	en
248	582	8	Family	en
249	592	8	FishBase ID (Wikidata)	\N
250	594	8	Produces	en
251	598	8	Is theme of	en
252	600	8	allValuesFrom	\N
253	600	8	allValuesFrom	\N
254	605	8	Develops into	en
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cc_rels_id_seq', 1771, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.class_annots_id_seq', 89, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.classes_id_seq', 1913, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cp_rels_id_seq', 2559, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.ns_id_seq', 1379, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.properties_id_seq', 608, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('https_taxref_mnhn_fr_sparql.property_annots_id_seq', 254, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON https_taxref_mnhn_fr_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON https_taxref_mnhn_fr_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON https_taxref_mnhn_fr_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON https_taxref_mnhn_fr_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON https_taxref_mnhn_fr_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON https_taxref_mnhn_fr_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON https_taxref_mnhn_fr_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON https_taxref_mnhn_fr_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON https_taxref_mnhn_fr_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON https_taxref_mnhn_fr_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON https_taxref_mnhn_fr_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON https_taxref_mnhn_fr_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON https_taxref_mnhn_fr_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON https_taxref_mnhn_fr_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON https_taxref_mnhn_fr_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON https_taxref_mnhn_fr_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON https_taxref_mnhn_fr_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON https_taxref_mnhn_fr_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON https_taxref_mnhn_fr_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON https_taxref_mnhn_fr_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON https_taxref_mnhn_fr_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON https_taxref_mnhn_fr_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON https_taxref_mnhn_fr_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON https_taxref_mnhn_fr_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON https_taxref_mnhn_fr_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON https_taxref_mnhn_fr_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES https_taxref_mnhn_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_taxref_mnhn_fr_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_taxref_mnhn_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_taxref_mnhn_fr_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_taxref_mnhn_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_taxref_mnhn_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_taxref_mnhn_fr_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_taxref_mnhn_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_taxref_mnhn_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_taxref_mnhn_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_taxref_mnhn_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES https_taxref_mnhn_fr_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_taxref_mnhn_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_taxref_mnhn_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES https_taxref_mnhn_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES https_taxref_mnhn_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_taxref_mnhn_fr_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES https_taxref_mnhn_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES https_taxref_mnhn_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES https_taxref_mnhn_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: https_taxref_mnhn_fr_sparql; Owner: -
--

ALTER TABLE ONLY https_taxref_mnhn_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_taxref_mnhn_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

