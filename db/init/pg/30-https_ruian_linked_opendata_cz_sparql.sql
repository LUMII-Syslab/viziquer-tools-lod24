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
-- Name: https_ruian_linked_opendata_cz_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA https_ruian_linked_opendata_cz_sparql;


--
-- Name: SCHEMA https_ruian_linked_opendata_cz_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA https_ruian_linked_opendata_cz_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE FUNCTION https_ruian_linked_opendata_cz_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE FUNCTION https_ruian_linked_opendata_cz_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COMMENT ON TABLE https_ruian_linked_opendata_cz_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COMMENT ON COLUMN https_ruian_linked_opendata_cz_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((https_ruian_linked_opendata_cz_sparql.classes c1
     JOIN https_ruian_linked_opendata_cz_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN https_ruian_linked_opendata_cz_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN https_ruian_linked_opendata_cz_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN https_ruian_linked_opendata_cz_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE TABLE https_ruian_linked_opendata_cz_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE https_ruian_linked_opendata_cz_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_ruian_linked_opendata_cz_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_cc_rels AS
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
   FROM https_ruian_linked_opendata_cz_sparql.cc_rels r,
    https_ruian_linked_opendata_cz_sparql.classes c1,
    https_ruian_linked_opendata_cz_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_classes_ns AS
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
    https_ruian_linked_opendata_cz_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_ruian_linked_opendata_cz_sparql.classes c
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_classes_ns_main AS
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
   FROM https_ruian_linked_opendata_cz_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM https_ruian_linked_opendata_cz_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_classes_ns_plus AS
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
    https_ruian_linked_opendata_cz_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM https_ruian_linked_opendata_cz_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_ruian_linked_opendata_cz_sparql.classes c
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_classes_ns_main_plus AS
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
   FROM https_ruian_linked_opendata_cz_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM https_ruian_linked_opendata_cz_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_classes_ns_main_v01 AS
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
   FROM (https_ruian_linked_opendata_cz_sparql.v_classes_ns v
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_cp_rels AS
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
    https_ruian_linked_opendata_cz_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    https_ruian_linked_opendata_cz_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    https_ruian_linked_opendata_cz_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM https_ruian_linked_opendata_cz_sparql.cp_rels r,
    https_ruian_linked_opendata_cz_sparql.classes c,
    https_ruian_linked_opendata_cz_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_cp_rels_card AS
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
   FROM https_ruian_linked_opendata_cz_sparql.cp_rels r,
    https_ruian_linked_opendata_cz_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_properties_ns AS
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
    https_ruian_linked_opendata_cz_sparql.tapprox(p.cnt) AS cnt_x,
    https_ruian_linked_opendata_cz_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    https_ruian_linked_opendata_cz_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (https_ruian_linked_opendata_cz_sparql.properties p
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_cp_sources_single AS
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
   FROM ((https_ruian_linked_opendata_cz_sparql.v_cp_rels_card r
     JOIN https_ruian_linked_opendata_cz_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_cp_targets_single AS
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
   FROM ((https_ruian_linked_opendata_cz_sparql.v_cp_rels_card r
     JOIN https_ruian_linked_opendata_cz_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    https_ruian_linked_opendata_cz_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM https_ruian_linked_opendata_cz_sparql.pp_rels r,
    https_ruian_linked_opendata_cz_sparql.properties p1,
    https_ruian_linked_opendata_cz_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_properties_sources AS
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
   FROM (https_ruian_linked_opendata_cz_sparql.v_properties_ns v
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
           FROM https_ruian_linked_opendata_cz_sparql.cp_rels r,
            https_ruian_linked_opendata_cz_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_properties_sources_single AS
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
   FROM (https_ruian_linked_opendata_cz_sparql.v_properties_ns v
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_properties_targets AS
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
   FROM (https_ruian_linked_opendata_cz_sparql.v_properties_ns v
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
           FROM https_ruian_linked_opendata_cz_sparql.cp_rels r,
            https_ruian_linked_opendata_cz_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE VIEW https_ruian_linked_opendata_cz_sparql.v_properties_targets_single AS
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
   FROM (https_ruian_linked_opendata_cz_sparql.v_properties_ns v
     LEFT JOIN https_ruian_linked_opendata_cz_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	3	2	1	\N	\N
2	6	44	1	\N	\N
3	7	56	1	\N	\N
4	8	56	1	\N	\N
5	10	87	1	\N	\N
6	14	49	1	\N	\N
7	15	51	1	\N	\N
8	16	51	1	\N	\N
9	18	17	1	\N	\N
10	19	91	1	\N	\N
11	20	5	1	\N	\N
12	21	67	1	\N	\N
13	24	60	1	\N	\N
14	25	8	1	\N	\N
15	26	61	1	\N	\N
16	29	2	1	\N	\N
17	31	4	1	\N	\N
18	32	56	1	\N	\N
19	35	36	1	\N	\N
20	39	51	1	\N	\N
21	42	77	1	\N	\N
22	43	59	1	\N	\N
23	44	56	1	\N	\N
24	45	7	1	\N	\N
25	52	18	1	\N	\N
26	53	68	1	\N	\N
27	55	9	1	\N	\N
28	57	66	1	\N	\N
29	58	33	1	\N	\N
30	60	56	1	\N	\N
31	61	56	1	\N	\N
32	62	56	1	\N	\N
33	62	92	1	\N	\N
34	63	98	1	\N	\N
35	67	56	1	\N	\N
36	70	84	1	\N	\N
37	71	62	1	\N	\N
38	72	85	1	\N	\N
39	76	90	1	\N	\N
40	77	56	1	\N	\N
41	89	2	1	\N	\N
43	96	82	1	\N	\N
44	98	56	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	14	8	OntologyProperty	\N
2	74	8	AnnotationProperty	\N
3	75	8	Ontology	\N
4	86	8	Class	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
2	http://www.w3.org/2000/01/rdf-schema#Class	75	\N	t	2	Class	Class	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	454
3	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
4	https://ruian.linked.opendata.cz/slovník/TypPrvku#KU	13091	\N	t	71	KU	KU	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22574441
5	https://ruian.linked.opendata.cz/slovník/TypPrvku#SO	4056890	\N	t	71	SO	SO	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2900397
6	https://ruian.linked.opendata.cz/slovník/Mop	10	\N	t	72	Mop	Mop	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
7	https://ruian.linked.opendata.cz/slovník/TypPrvku#SP	22	\N	t	71	SP	SP	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
8	https://ruian.linked.opendata.cz/slovník/TypPrvku#KR	8	\N	t	71	KR	KR	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	77
9	http://www.w3.org/ns/dcat#Catalog	1	\N	t	15	Catalog	Catalog	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
10	http://www.w3.org/2001/vcard-rdf/3.0#voice	22	\N	t	73	voice	voice	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
14	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
15	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	t	74	C_AKJ315005-tax	C_AKJ315005-tax	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
16	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	t	74	C_AAB316003-tax	C_AAB316003-tax	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
17	https://ruian.linked.opendata.cz/slovník/TypPrvku#AD	2900397	\N	t	71	AD	AD	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	https://ruian.linked.opendata.cz/slovník/AdresníMísto	2900397	\N	t	72	AdresníMísto	AdresníMísto	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
19	https://ruian.linked.opendata.cz/slovník/Parcela	22551940	\N	t	72	Parcela	Parcela	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3965523
20	https://ruian.linked.opendata.cz/slovník/StavebníObjekt	4056890	\N	t	72	StavebníObjekt	StavebníObjekt	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2900397
21	https://ruian.linked.opendata.cz/slovník/Okres	77	\N	t	72	Okres	Okres	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6258
22	http://xmlns.com/foaf/0.1/Document	1	\N	t	8	Document	Document	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
23	http://purl.org/dc/terms/Frequency	1	\N	t	5	Frequency	Frequency	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
24	https://ruian.linked.opendata.cz/slovník/Momc	142	\N	t	72	Momc	Momc	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	412087
25	https://ruian.linked.opendata.cz/slovník/Kraj1960	8	\N	t	72	Kraj1960	Kraj1960	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	77
26	https://ruian.linked.opendata.cz/slovník/RegionSoudrznosti	8	\N	t	72	RegionSoudrznosti	RegionSoudrznosti	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
29	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
30	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
31	https://ruian.linked.opendata.cz/slovník/KatastrálníÚzemí	13091	\N	t	72	KatastrálníÚzemí	KatastrálníÚzemí	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22574441
32	http://www.opengis.net/ont/gml#MultiPoint	41850	\N	t	75	MultiPoint	MultiPoint	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	41850
33	https://ruian.linked.opendata.cz/slovník/Ulice	82262	\N	t	72	Ulice	Ulice	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1487735
34	http://purl.org/dc/terms/MediaTypeOrExtent	2	\N	t	5	MediaTypeOrExtent	MediaTypeOrExtent	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
35	http://schema.org/DataDownload	1	\N	t	9	DataDownload	DataDownload	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
36	http://www.w3.org/ns/dcat#Distribution	1	\N	t	15	Distribution	Distribution	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
37	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
38	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
39	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	t	74	C_AKE112003-tax	C_AKE112003-tax	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
40	http://www.opengis.net/ont/gml#Point	29511669	\N	t	75	Point	Point	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29511669
41	https://ruian.linked.opendata.cz/slovník/ZpůsobOchrany	14414766	\N	t	72	ZpůsobOchrany	ZpůsobOchrany	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14414766
42	https://ruian.linked.opendata.cz/slovník/TypPrvku#CO	15094	\N	t	71	CO	CO	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2829101
43	https://ruian.linked.opendata.cz/slovník/Pou	393	\N	t	72	Pou	Pou	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6258
44	https://ruian.linked.opendata.cz/slovník/TypPrvku#MP	10	\N	t	71	MP	MP	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
45	https://ruian.linked.opendata.cz/slovník/SprávníObvod	22	\N	t	72	SprávníObvod	SprávníObvod	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
46	http://schema.org/GeoCoordinates	29511669	\N	t	9	GeoCoordinates	GeoCoordinates	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29511669
47	http://www.w3.org/2004/02/skos/core#Concept	3600	\N	t	4	Concept	Concept	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	167
48	http://www.w3.org/2001/vcard-rdf/3.0#internet	22	\N	t	73	internet	internet	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
49	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	246	\N	t	1	Property	Property	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
50	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	t	36	BusinessEntity	BusinessEntity	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
51	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
52	http://schema.org/Place	2900397	\N	t	9	Place	Place	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://schema.org/Dataset	1	\N	t	9	Dataset	Dataset	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
54	http://www.openlinksw.com/schemas/VSPX#	1	\N	t	76			259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
55	http://schema.org/DataCatalog	1	\N	t	9	DataCatalog	DataCatalog	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
56	http://www.opengis.net/ont/geosparql#Geometry	29434518	\N	t	25	Geometry	Geometry	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10107127
57	https://ruian.linked.opendata.cz/slovník/TypPrvku#ZJ	22501	\N	t	71	ZJ	ZJ	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
58	https://ruian.linked.opendata.cz/slovník/TypPrvku#UL	82262	\N	t	71	UL	UL	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1487735
59	https://ruian.linked.opendata.cz/slovník/TypPrvku#PU	393	\N	t	71	PU	PU	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6258
60	https://ruian.linked.opendata.cz/slovník/TypPrvku#MC	142	\N	t	71	MC	MC	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	412087
61	https://ruian.linked.opendata.cz/slovník/TypPrvku#RS	8	\N	t	71	RS	RS	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
62	https://ruian.linked.opendata.cz/slovník/TypPrvku#ST	1	\N	t	71	ST	ST	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
63	https://ruian.linked.opendata.cz/slovník/TypPrvku#VC	14	\N	t	71	VC	VC	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	283
64	http://purl.org/dc/terms/LicenseDocument	1	\N	t	5	LicenseDocument	LicenseDocument	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
66	https://ruian.linked.opendata.cz/slovník/Zsj	22501	\N	t	72	Zsj	Zsj	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
67	https://ruian.linked.opendata.cz/slovník/TypPrvku#OK	77	\N	t	71	OK	OK	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6258
68	http://www.w3.org/ns/dcat#Dataset	1	\N	t	15	Dataset	Dataset	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
69	http://purl.org/dc/terms/LinguisticSystem	1	\N	t	5	LinguisticSystem	LinguisticSystem	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
70	https://ruian.linked.opendata.cz/slovník/Orp	206	\N	t	72	Orp	Orp	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	393
71	https://ruian.linked.opendata.cz/slovník/Stát	1	\N	t	72	Stát	Stát	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
72	http://www.w3.org/2006/vcard/ns#Individual	1	\N	t	39	Individual	Individual	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
74	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://www.w3.org/2002/07/owl#Ontology	2	\N	t	7	Ontology	Ontology	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
76	https://ruian.linked.opendata.cz/slovník/Obec	6258	\N	t	72	Obec	Obec	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	110622
77	https://ruian.linked.opendata.cz/slovník/ČástObce	15094	\N	t	72	ČástObce	ČástObce	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2829101
80	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
81	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
82	http://xmlns.com/foaf/0.1/Agent	1	\N	t	8	Agent	Agent	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
83	http://purl.org/dc/terms/RightsStatement	1	\N	t	5	RightsStatement	RightsStatement	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
84	https://ruian.linked.opendata.cz/slovník/TypPrvku#OP	206	\N	t	71	OP	OP	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	393
85	http://www.w3.org/2006/vcard/ns#Kind	1	\N	t	39	Kind	Kind	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
86	http://www.w3.org/2002/07/owl#Class	5	\N	t	7	Class	Class	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
87	http://www.w3.org/2001/vcard-rdf/3.0#work	22	\N	t	73	work	work	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
89	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
90	https://ruian.linked.opendata.cz/slovník/TypPrvku#OB	6258	\N	t	71	OB	OB	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	110622
91	https://ruian.linked.opendata.cz/slovník/TypPrvku#PA	22551940	\N	t	71	PA	PA	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3965523
92	http://purl.org/dc/terms/Location	2	\N	t	5	Location	Location	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19
94	http://purl.org/dc/terms/PeriodOfTime	1	\N	t	5	PeriodOfTime	PeriodOfTime	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
96	http://schema.org/Organization	1	\N	t	9	Organization	Organization	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
97	http://www.w3.org/2004/02/skos/core#ConceptScheme	18	\N	t	4	ConceptScheme	ConceptScheme	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3598
98	https://ruian.linked.opendata.cz/slovník/Vúsc	14	\N	t	72	Vúsc	Vúsc	259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	283
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	35	1	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2	36	1	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
4	24	2	2	57	\N	57	\N	\N	1	1	2	f	0	44	\N
5	56	2	2	57	\N	57	\N	\N	0	1	2	f	0	44	\N
6	60	2	2	57	\N	57	\N	\N	0	1	2	f	0	6	\N
7	6	2	1	57	\N	57	\N	\N	1	1	2	f	\N	60	\N
8	44	2	1	57	\N	57	\N	\N	0	1	2	f	\N	60	\N
9	56	2	1	57	\N	57	\N	\N	0	1	2	f	\N	60	\N
10	82	3	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
11	96	3	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
12	53	4	2	1	\N	1	\N	\N	1	1	2	f	0	22	\N
13	68	4	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
14	22	4	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
15	47	5	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
17	5	7	2	412087	\N	412087	\N	\N	1	1	2	f	0	60	\N
18	20	7	2	412087	\N	412087	\N	\N	0	1	2	f	0	24	\N
19	56	7	2	404407	\N	404407	\N	\N	0	1	2	f	0	60	\N
20	24	7	1	412087	\N	412087	\N	\N	1	1	2	f	\N	20	\N
21	56	7	1	412087	\N	412087	\N	\N	0	1	2	f	\N	5	\N
22	60	7	1	412087	\N	412087	\N	\N	0	1	2	f	\N	5	\N
23	5	8	2	2296498	\N	2296498	\N	\N	1	1	2	f	0	\N	\N
24	20	8	2	2296498	\N	2296498	\N	\N	0	1	2	f	0	\N	\N
25	56	8	2	2295546	\N	2295546	\N	\N	0	1	2	f	0	\N	\N
26	5	9	2	2764026	\N	0	\N	\N	1	1	2	f	2764026	\N	\N
27	20	9	2	2764026	\N	0	\N	\N	0	1	2	f	2764026	\N	\N
28	56	9	2	2752322	\N	0	\N	\N	0	1	2	f	2752322	\N	\N
30	53	11	2	2	\N	2	\N	\N	1	1	2	f	0	92	\N
31	68	11	2	2	\N	2	\N	\N	0	1	2	f	0	92	\N
32	92	11	1	2	\N	2	\N	\N	1	1	2	f	\N	53	\N
33	56	11	1	1	\N	1	\N	\N	0	1	2	f	\N	68	\N
34	62	11	1	1	\N	1	\N	\N	0	1	2	f	\N	68	\N
35	71	11	1	1	\N	1	\N	\N	0	1	2	f	\N	68	\N
36	17	12	2	2900397	\N	2900397	\N	\N	1	1	2	f	0	\N	\N
37	18	12	2	2900397	\N	2900397	\N	\N	0	1	2	f	0	\N	\N
38	52	12	2	2900397	\N	2900397	\N	\N	0	1	2	f	0	\N	\N
39	56	12	2	2837194	\N	2837194	\N	\N	0	1	2	f	0	\N	\N
40	72	13	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
41	85	13	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
43	40	15	2	29511669	\N	0	\N	\N	1	1	2	f	29511669	\N	\N
45	5	17	2	3884026	\N	0	\N	\N	1	1	2	f	3884026	\N	\N
46	20	17	2	3884026	\N	0	\N	\N	0	1	2	f	3884026	\N	\N
47	56	17	2	3864540	\N	0	\N	\N	0	1	2	f	3864540	\N	\N
48	38	18	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
49	5	19	2	2280690	\N	2280690	\N	\N	1	1	2	f	0	\N	\N
50	20	19	2	2280690	\N	2280690	\N	\N	0	1	2	f	0	\N	\N
51	56	19	2	2279841	\N	2279841	\N	\N	0	1	2	f	0	\N	\N
52	30	20	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
53	50	20	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
54	9	21	2	1	\N	1	\N	\N	1	1	2	f	0	68	\N
55	55	21	2	1	\N	1	\N	\N	0	1	2	f	0	68	\N
56	53	21	1	1	\N	1	\N	\N	1	1	2	f	\N	9	\N
57	68	21	1	1	\N	1	\N	\N	0	1	2	f	\N	55	\N
58	17	22	2	1487735	\N	1487735	\N	\N	1	1	2	f	0	58	\N
59	18	22	2	1487735	\N	1487735	\N	\N	0	1	2	f	0	33	\N
60	52	22	2	1487735	\N	1487735	\N	\N	0	1	2	f	0	33	\N
61	56	22	2	1472079	\N	1472079	\N	\N	0	1	2	f	0	33	\N
62	33	22	1	1487735	\N	1487735	\N	\N	1	1	2	f	\N	18	\N
63	58	22	1	1487735	\N	1487735	\N	\N	0	1	2	f	\N	17	\N
64	38	23	2	1	\N	1	\N	\N	1	1	2	f	0	29	\N
65	29	23	1	1	\N	1	\N	\N	1	1	2	f	\N	38	\N
66	2	23	1	1	\N	1	\N	\N	0	1	2	f	\N	38	\N
68	53	25	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
69	68	25	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
70	38	26	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
72	94	28	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
73	75	29	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
76	53	32	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
77	68	32	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
78	38	33	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
80	35	35	2	1	\N	1	\N	\N	1	1	2	f	0	47	\N
81	53	35	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
82	64	35	2	1	\N	1	\N	\N	3	1	2	f	0	47	\N
83	82	35	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
84	36	35	2	1	\N	1	\N	\N	0	1	2	f	0	47	\N
85	68	35	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
86	96	35	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
88	47	35	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
89	5	36	2	2278026	\N	2278026	\N	\N	1	1	2	f	0	\N	\N
90	20	36	2	2278026	\N	2278026	\N	\N	0	1	2	f	0	\N	\N
91	56	36	2	2277201	\N	2277201	\N	\N	0	1	2	f	0	\N	\N
92	50	37	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
93	75	38	2	1	\N	1	\N	\N	1	1	2	f	0	50	\N
94	50	38	1	1	\N	1	\N	\N	1	1	2	f	\N	75	\N
95	47	39	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
96	5	40	2	2221589	\N	0	\N	\N	1	1	2	f	2221589	\N	\N
97	20	40	2	2221589	\N	0	\N	\N	0	1	2	f	2221589	\N	\N
98	56	40	2	2220632	\N	0	\N	\N	0	1	2	f	2220632	\N	\N
99	4	41	2	13091	\N	0	\N	\N	1	1	2	f	13091	\N	\N
100	31	41	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
101	19	42	2	14574694	\N	0	\N	\N	1	1	2	f	14574694	\N	\N
102	91	42	2	14574694	\N	0	\N	\N	0	1	2	f	14574694	\N	\N
103	56	42	2	14574604	\N	0	\N	\N	0	1	2	f	14574604	\N	\N
104	19	43	2	22551940	\N	0	\N	\N	1	1	2	f	22551940	\N	\N
105	41	43	2	14731413	\N	0	\N	\N	2	1	2	f	14731413	\N	\N
106	4	43	2	13091	\N	0	\N	\N	3	1	2	f	13091	\N	\N
107	91	43	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
108	56	43	2	22551829	\N	0	\N	\N	0	1	2	f	22551829	\N	\N
109	31	43	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
110	21	44	2	77	\N	77	\N	\N	1	1	2	f	0	25	\N
111	56	44	2	77	\N	77	\N	\N	0	1	2	f	0	8	\N
112	67	44	2	77	\N	77	\N	\N	0	1	2	f	0	25	\N
113	8	44	1	77	\N	77	\N	\N	1	1	2	f	\N	21	\N
114	25	44	1	77	\N	77	\N	\N	0	1	2	f	\N	21	\N
115	56	44	1	77	\N	77	\N	\N	0	1	2	f	\N	21	\N
117	53	46	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
118	68	46	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
119	35	47	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
120	53	47	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
121	54	47	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
122	36	47	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
123	68	47	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
128	17	50	2	2837194	\N	2837194	\N	\N	1	1	2	f	0	40	\N
129	18	50	2	2837194	\N	2837194	\N	\N	0	1	2	f	0	40	\N
130	52	50	2	2837194	\N	2837194	\N	\N	0	1	2	f	0	40	\N
131	56	50	2	2837194	\N	2837194	\N	\N	0	1	2	f	0	40	\N
132	40	50	1	2837194	\N	2837194	\N	\N	1	1	2	f	\N	52	\N
133	49	51	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
134	2	51	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
135	2	51	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
136	50	52	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
137	56	53	2	29392668	\N	0	\N	\N	1	1	2	f	29392668	\N	\N
138	33	53	2	82262	\N	0	\N	\N	2	1	2	f	82262	\N	\N
139	57	53	2	22501	\N	0	\N	\N	3	1	2	f	22501	\N	\N
140	4	53	2	13091	\N	0	\N	\N	4	1	2	f	13091	\N	\N
141	76	53	2	6258	\N	0	\N	\N	5	1	2	f	6258	\N	\N
142	47	53	2	3578	\N	0	\N	\N	6	1	2	f	3578	\N	\N
143	43	53	2	393	\N	0	\N	\N	7	1	2	f	393	\N	\N
144	70	53	2	206	\N	0	\N	\N	8	1	2	f	206	\N	\N
145	19	53	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
146	91	53	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
147	5	53	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
148	20	53	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
149	17	53	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
150	18	53	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
151	52	53	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
152	58	53	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
153	66	53	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
154	42	53	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
155	77	53	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
156	31	53	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
157	90	53	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
158	59	53	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
159	84	53	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
160	24	53	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
161	60	53	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
162	21	53	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
163	67	53	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
164	7	53	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
165	45	53	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
166	63	53	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
167	98	53	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
168	6	53	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
169	44	53	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
170	8	53	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
171	25	53	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
172	26	53	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
173	61	53	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
174	62	53	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
175	71	53	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
176	92	53	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
177	43	54	2	393	\N	393	\N	\N	1	1	2	f	0	70	\N
178	59	54	2	393	\N	393	\N	\N	0	1	2	f	0	84	\N
179	70	54	1	393	\N	393	\N	\N	1	1	2	f	\N	43	\N
180	84	54	1	393	\N	393	\N	\N	0	1	2	f	\N	59	\N
181	5	55	2	2829101	\N	2829101	\N	\N	1	1	2	f	0	77	\N
182	20	55	2	2829101	\N	2829101	\N	\N	0	1	2	f	0	77	\N
183	56	55	2	2780602	\N	2780602	\N	\N	0	1	2	f	0	42	\N
184	42	55	1	2829101	\N	2829101	\N	\N	1	1	2	f	\N	5	\N
185	56	55	1	2829101	\N	2829101	\N	\N	0	1	2	f	\N	5	\N
186	77	55	1	2829101	\N	2829101	\N	\N	0	1	2	f	\N	20	\N
191	86	59	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
192	35	60	2	1	\N	1	\N	\N	1	1	2	f	0	69	\N
193	53	60	2	1	\N	1	\N	\N	2	1	2	f	0	69	\N
194	36	60	2	1	\N	1	\N	\N	0	1	2	f	0	69	\N
195	68	60	2	1	\N	1	\N	\N	0	1	2	f	0	69	\N
197	69	60	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
198	50	61	2	3	\N	3	\N	\N	1	1	2	f	0	38	\N
199	38	61	1	3	\N	3	\N	\N	1	1	2	f	\N	50	\N
200	35	62	2	1	\N	1	\N	\N	1	1	2	f	0	34	\N
201	36	62	2	1	\N	1	\N	\N	0	1	2	f	0	34	\N
203	34	62	1	1	\N	1	\N	\N	1	1	2	f	\N	93	\N
205	5	64	2	3959928	\N	3959928	\N	\N	1	1	2	f	0	\N	\N
206	20	64	2	3959928	\N	3959928	\N	\N	0	1	2	f	0	\N	\N
207	56	64	2	3938596	\N	3938596	\N	\N	0	1	2	f	0	\N	\N
208	19	65	2	6169533	\N	0	\N	\N	1	1	2	f	6169533	\N	\N
209	91	65	2	6169533	\N	0	\N	\N	0	1	2	f	6169533	\N	\N
210	56	65	2	6169483	\N	0	\N	\N	0	1	2	f	6169483	\N	\N
212	54	67	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
213	49	68	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
214	49	69	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
215	47	69	2	19	\N	0	\N	\N	2	1	2	f	19	\N	\N
216	97	69	2	17	\N	0	\N	\N	3	1	2	f	17	\N	\N
217	86	69	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
218	3	69	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
219	29	69	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
220	80	69	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
221	89	69	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
222	75	69	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
223	2	69	2	75	\N	0	\N	\N	0	1	2	f	75	\N	\N
224	14	69	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
225	74	69	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
226	35	70	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
227	53	70	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
228	36	70	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
229	68	70	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
242	47	74	2	3597	\N	0	\N	\N	1	1	2	f	3597	\N	\N
243	97	74	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
244	2	74	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
245	48	75	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
246	81	76	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
248	10	78	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
249	48	78	2	22	\N	0	\N	\N	2	1	2	f	22	\N	\N
250	87	78	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
252	53	80	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
253	68	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
259	5	84	2	3978381	\N	3978381	\N	\N	1	1	2	f	0	\N	\N
260	20	84	2	3978381	\N	3978381	\N	\N	0	1	2	f	0	\N	\N
261	56	84	2	3955924	\N	3955924	\N	\N	0	1	2	f	0	\N	\N
262	19	84	1	3965523	\N	3965523	\N	\N	1	1	2	f	\N	5	\N
263	91	84	1	3965523	\N	3965523	\N	\N	0	1	2	f	\N	20	\N
264	56	84	1	3965519	\N	3965519	\N	\N	0	1	2	f	\N	5	\N
265	49	85	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
266	75	85	1	1	\N	1	\N	\N	1	1	2	f	\N	49	\N
267	47	87	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
268	19	88	2	22551940	\N	0	\N	\N	1	1	2	f	22551940	\N	\N
269	91	88	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
270	56	88	2	22551829	\N	0	\N	\N	0	1	2	f	22551829	\N	\N
271	56	89	2	29392668	\N	0	\N	\N	1	1	2	f	29392668	\N	\N
272	19	89	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
273	91	89	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
274	5	89	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
275	20	89	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
276	17	89	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
277	18	89	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
278	52	89	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
279	33	89	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
280	58	89	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
281	57	89	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
282	66	89	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
283	42	89	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
284	77	89	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
285	4	89	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
286	31	89	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
287	76	89	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
288	90	89	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
289	43	89	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
290	59	89	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
291	70	89	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
292	84	89	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
293	24	89	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
294	60	89	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
295	21	89	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
296	67	89	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
297	7	89	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
298	45	89	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
299	63	89	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
300	98	89	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
301	6	89	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
302	44	89	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
303	8	89	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
304	25	89	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
305	26	89	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
306	61	89	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
307	62	89	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
308	71	89	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
309	92	89	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
310	38	90	2	3	\N	3	\N	\N	1	1	2	f	0	81	\N
311	81	90	1	3	\N	3	\N	\N	1	1	2	f	\N	38	\N
314	76	93	2	4288	\N	0	\N	\N	1	1	2	f	4288	\N	\N
315	24	93	2	63	\N	0	\N	\N	2	1	2	f	63	\N	\N
316	90	93	2	4288	\N	0	\N	\N	0	1	2	f	4288	\N	\N
317	56	93	2	63	\N	0	\N	\N	0	1	2	f	63	\N	\N
318	60	93	2	63	\N	0	\N	\N	0	1	2	f	63	\N	\N
323	46	95	2	29511669	\N	0	\N	\N	1	1	2	f	29511669	\N	\N
325	76	97	2	4675	\N	0	\N	\N	1	1	2	f	4675	\N	\N
326	24	97	2	70	\N	0	\N	\N	2	1	2	f	70	\N	\N
327	90	97	2	4675	\N	0	\N	\N	0	1	2	f	4675	\N	\N
328	56	97	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
329	60	97	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
333	35	100	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
334	36	100	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
336	5	101	2	319483	\N	0	\N	\N	1	1	2	f	319483	\N	\N
337	20	101	2	319483	\N	0	\N	\N	0	1	2	f	319483	\N	\N
338	56	101	2	318624	\N	0	\N	\N	0	1	2	f	318624	\N	\N
339	17	102	2	159	\N	0	\N	\N	1	1	2	f	159	\N	\N
340	33	102	2	5	\N	0	\N	\N	2	1	2	f	5	\N	\N
341	18	102	2	159	\N	0	\N	\N	0	1	2	f	159	\N	\N
342	52	102	2	159	\N	0	\N	\N	0	1	2	f	159	\N	\N
343	56	102	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
344	58	102	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
347	38	105	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
351	37	108	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
352	17	109	2	39406	\N	39406	\N	\N	1	1	2	f	0	40	\N
353	18	109	2	39406	\N	39406	\N	\N	0	1	2	f	0	40	\N
354	52	109	2	39406	\N	39406	\N	\N	0	1	2	f	0	40	\N
355	56	109	2	39406	\N	39406	\N	\N	0	1	2	f	0	40	\N
356	40	109	1	39406	\N	39406	\N	\N	1	1	2	f	\N	52	\N
357	54	110	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
358	40	111	2	29511669	\N	29511669	\N	\N	1	1	2	f	0	\N	\N
359	72	112	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
360	85	112	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
361	86	113	2	4	\N	4	\N	\N	1	1	2	f	0	86	\N
362	86	113	1	4	\N	4	\N	\N	1	1	2	f	\N	86	\N
364	19	115	2	22551940	\N	22551940	\N	\N	1	1	2	f	0	31	\N
365	91	115	2	22551940	\N	22551940	\N	\N	0	1	2	f	0	31	\N
366	56	115	2	22551829	\N	22551829	\N	\N	0	1	2	f	0	31	\N
367	4	115	1	22551940	\N	22551940	\N	\N	1	1	2	f	\N	91	\N
368	31	115	1	22551940	\N	22551940	\N	\N	0	1	2	f	\N	19	\N
369	56	116	2	29511558	\N	0	\N	\N	1	1	2	f	29511558	\N	\N
370	19	116	2	22551829	\N	0	\N	\N	0	1	2	f	22551829	\N	\N
371	91	116	2	22551829	\N	0	\N	\N	0	1	2	f	22551829	\N	\N
372	5	116	2	3988269	\N	0	\N	\N	0	1	2	f	3988269	\N	\N
373	20	116	2	3988269	\N	0	\N	\N	0	1	2	f	3988269	\N	\N
374	17	116	2	2914230	\N	0	\N	\N	0	1	2	f	2914230	\N	\N
375	18	116	2	2914230	\N	0	\N	\N	0	1	2	f	2914230	\N	\N
376	52	116	2	2914230	\N	0	\N	\N	0	1	2	f	2914230	\N	\N
377	32	116	2	41854	\N	0	\N	\N	0	1	2	f	41854	\N	\N
378	42	116	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
379	77	116	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
380	24	116	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
381	60	116	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
382	21	116	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
383	67	116	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
384	7	116	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
385	45	116	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
386	63	116	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
387	98	116	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
388	6	116	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
389	44	116	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
390	8	116	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
391	25	116	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
392	26	116	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
393	61	116	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
394	62	116	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
395	71	116	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
396	92	116	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
397	47	117	2	70	\N	70	\N	\N	1	1	2	f	0	47	\N
398	47	117	1	70	\N	70	\N	\N	1	1	2	f	\N	47	\N
399	4	118	2	243	\N	0	\N	\N	1	1	2	f	243	\N	\N
400	42	118	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
401	31	118	2	243	\N	0	\N	\N	0	1	2	f	243	\N	\N
402	56	118	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
403	77	118	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
404	76	119	2	6258	\N	6258	\N	\N	1	1	2	f	0	59	\N
405	90	119	2	6258	\N	6258	\N	\N	0	1	2	f	0	43	\N
406	43	119	1	6258	\N	6258	\N	\N	1	1	2	f	\N	90	\N
407	59	119	1	6258	\N	6258	\N	\N	0	1	2	f	\N	76	\N
408	56	120	2	15236	\N	0	\N	\N	1	1	2	f	15236	\N	\N
409	4	120	2	13091	\N	0	\N	\N	2	1	2	f	13091	\N	\N
410	76	120	2	6258	\N	0	\N	\N	3	1	2	f	6258	\N	\N
411	42	120	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
412	77	120	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
413	31	120	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
414	90	120	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
415	24	120	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
416	60	120	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
417	56	121	2	15236	\N	0	\N	\N	1	1	2	f	15236	\N	\N
418	4	121	2	13091	\N	0	\N	\N	2	1	2	f	13091	\N	\N
419	76	121	2	6258	\N	0	\N	\N	3	1	2	f	6258	\N	\N
420	42	121	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
421	77	121	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
422	31	121	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
423	90	121	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
424	24	121	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
425	60	121	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
426	56	122	2	15235	\N	0	\N	\N	1	1	2	f	15235	\N	\N
427	4	122	2	13091	\N	0	\N	\N	2	1	2	f	13091	\N	\N
428	76	122	2	6258	\N	0	\N	\N	3	1	2	f	6258	\N	\N
429	42	122	2	15093	\N	0	\N	\N	0	1	2	f	15093	\N	\N
430	77	122	2	15093	\N	0	\N	\N	0	1	2	f	15093	\N	\N
431	31	122	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
432	90	122	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
433	24	122	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
434	60	122	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
435	56	123	2	15236	\N	0	\N	\N	1	1	2	f	15236	\N	\N
436	4	123	2	13091	\N	0	\N	\N	2	1	2	f	13091	\N	\N
437	76	123	2	6258	\N	0	\N	\N	3	1	2	f	6258	\N	\N
438	42	123	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
439	77	123	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
440	31	123	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
441	90	123	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
442	24	123	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
443	60	123	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
446	56	125	2	23	\N	23	\N	\N	1	1	2	f	0	\N	\N
447	63	125	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
448	98	125	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
449	26	125	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
450	61	125	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
451	62	125	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
452	71	125	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
453	92	125	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
460	56	130	2	15236	\N	0	\N	\N	1	1	2	f	15236	\N	\N
461	4	130	2	13091	\N	0	\N	\N	2	1	2	f	13091	\N	\N
462	76	130	2	6258	\N	0	\N	\N	3	1	2	f	6258	\N	\N
463	42	130	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
464	77	130	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
465	31	130	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
466	90	130	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
467	24	130	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
468	60	130	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
469	38	131	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
470	49	132	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
471	38	132	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
472	51	132	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
473	81	132	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
474	75	132	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
475	3	132	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
476	29	132	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
477	89	132	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
478	2	132	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
479	15	132	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
480	16	132	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
481	39	132	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
482	9	133	2	1	\N	1	\N	\N	1	1	2	f	0	68	\N
483	55	133	2	1	\N	1	\N	\N	0	1	2	f	0	68	\N
484	53	133	1	1	\N	1	\N	\N	1	1	2	f	\N	9	\N
485	68	133	1	1	\N	1	\N	\N	0	1	2	f	\N	55	\N
487	41	135	2	16507430	\N	0	\N	\N	1	1	2	f	16507430	\N	\N
488	24	136	2	57	\N	57	\N	\N	1	1	2	f	0	45	\N
489	56	136	2	57	\N	57	\N	\N	0	1	2	f	0	45	\N
490	60	136	2	57	\N	57	\N	\N	0	1	2	f	0	7	\N
491	7	136	1	57	\N	57	\N	\N	1	1	2	f	\N	60	\N
492	45	136	1	57	\N	57	\N	\N	0	1	2	f	\N	60	\N
493	56	136	1	57	\N	57	\N	\N	0	1	2	f	\N	60	\N
495	19	138	2	22551940	\N	22551940	\N	\N	1	1	2	f	0	\N	\N
496	91	138	2	22551940	\N	22551940	\N	\N	0	1	2	f	0	\N	\N
497	56	138	2	22551829	\N	22551829	\N	\N	0	1	2	f	0	\N	\N
498	70	139	2	206	\N	206	\N	\N	1	1	2	f	0	98	\N
499	21	139	2	77	\N	77	\N	\N	2	1	2	f	0	98	\N
500	84	139	2	206	\N	206	\N	\N	0	1	2	f	0	98	\N
501	56	139	2	77	\N	77	\N	\N	0	1	2	f	0	98	\N
502	67	139	2	77	\N	77	\N	\N	0	1	2	f	0	63	\N
503	63	139	1	283	\N	283	\N	\N	1	1	2	f	\N	\N	\N
504	56	139	1	283	\N	283	\N	\N	0	1	2	f	\N	\N	\N
505	98	139	1	283	\N	283	\N	\N	0	1	2	f	\N	\N	\N
506	49	140	2	304	\N	304	\N	\N	1	1	2	f	0	\N	\N
507	14	140	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
508	47	140	1	25	\N	25	\N	\N	1	1	2	f	\N	49	\N
509	89	140	1	13	\N	13	\N	\N	2	1	2	f	\N	49	\N
510	29	140	1	6	\N	6	\N	\N	3	1	2	f	\N	49	\N
511	3	140	1	4	\N	4	\N	\N	4	1	2	f	\N	49	\N
512	86	140	1	2	\N	2	\N	\N	5	1	2	f	\N	49	\N
513	2	140	1	287	\N	287	\N	\N	0	1	2	f	\N	49	\N
518	5	144	2	262206	\N	0	\N	\N	1	1	2	f	262206	\N	\N
519	20	144	2	262206	\N	0	\N	\N	0	1	2	f	262206	\N	\N
520	56	144	2	261356	\N	0	\N	\N	0	1	2	f	261356	\N	\N
521	76	145	2	6258	\N	6258	\N	\N	1	1	2	f	0	67	\N
522	90	145	2	6258	\N	6258	\N	\N	0	1	2	f	0	21	\N
523	21	145	1	6258	\N	6258	\N	\N	1	1	2	f	\N	90	\N
524	56	145	1	6258	\N	6258	\N	\N	0	1	2	f	\N	90	\N
525	67	145	1	6258	\N	6258	\N	\N	0	1	2	f	\N	76	\N
526	53	146	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
527	68	146	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
528	35	147	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
529	36	147	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
531	94	148	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
533	47	150	2	161	\N	0	\N	\N	1	1	2	f	161	\N	\N
537	81	153	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
538	53	154	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
539	68	154	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
540	19	155	2	13916081	\N	13916081	\N	\N	1	1	2	f	0	41	\N
541	91	155	2	13916081	\N	13916081	\N	\N	0	1	2	f	0	41	\N
542	56	155	2	13916019	\N	13916019	\N	\N	0	1	2	f	0	41	\N
543	41	155	1	13916081	\N	13916081	\N	\N	1	1	2	f	\N	91	\N
544	17	156	2	2900397	\N	2900397	\N	\N	1	1	2	f	0	20	\N
545	18	156	2	2900397	\N	2900397	\N	\N	0	1	2	f	0	5	\N
546	52	156	2	2900397	\N	2900397	\N	\N	0	1	2	f	0	20	\N
547	56	156	2	2837194	\N	2837194	\N	\N	0	1	2	f	0	20	\N
548	5	156	1	2900397	\N	2900397	\N	\N	1	1	2	f	\N	18	\N
549	20	156	1	2900397	\N	2900397	\N	\N	0	1	2	f	\N	52	\N
550	56	156	1	2851806	\N	2851806	\N	\N	0	1	2	f	\N	52	\N
552	40	159	2	29511669	\N	0	\N	\N	1	1	2	f	29511669	\N	\N
553	56	159	2	29392668	\N	0	\N	\N	2	1	2	f	29392668	\N	\N
554	33	159	2	82262	\N	0	\N	\N	3	1	2	f	82262	\N	\N
555	57	159	2	22501	\N	0	\N	\N	4	1	2	f	22501	\N	\N
556	4	159	2	13091	\N	0	\N	\N	5	1	2	f	13091	\N	\N
557	76	159	2	6258	\N	0	\N	\N	6	1	2	f	6258	\N	\N
558	43	159	2	393	\N	0	\N	\N	7	1	2	f	393	\N	\N
559	70	159	2	206	\N	0	\N	\N	8	1	2	f	206	\N	\N
560	19	159	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
561	91	159	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
562	5	159	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
563	20	159	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
564	17	159	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
565	18	159	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
566	52	159	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
567	58	159	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
568	66	159	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
569	42	159	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
570	77	159	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
571	31	159	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
572	90	159	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
573	59	159	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
574	84	159	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
575	24	159	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
576	60	159	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
577	21	159	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
578	67	159	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
579	7	159	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
580	45	159	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
581	63	159	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
582	98	159	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
583	6	159	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
584	44	159	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
585	8	159	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
586	25	159	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
587	26	159	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
588	61	159	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
589	62	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
590	71	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
591	92	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
592	53	160	2	1	\N	1	\N	\N	1	1	2	f	0	85	\N
593	68	160	2	1	\N	1	\N	\N	0	1	2	f	0	85	\N
594	72	160	1	1	\N	1	\N	\N	1	1	2	f	\N	68	\N
595	85	160	1	1	\N	1	\N	\N	0	1	2	f	\N	68	\N
596	19	161	2	22551940	\N	22551940	\N	\N	1	1	2	f	0	\N	\N
597	91	161	2	22551940	\N	22551940	\N	\N	0	1	2	f	0	\N	\N
598	56	161	2	22551829	\N	22551829	\N	\N	0	1	2	f	0	\N	\N
599	19	162	2	22551940	\N	0	\N	\N	1	1	2	f	22551940	\N	\N
600	91	162	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
601	56	162	2	22551829	\N	0	\N	\N	0	1	2	f	22551829	\N	\N
604	47	165	2	27	\N	27	\N	\N	1	1	2	f	0	47	\N
605	2	165	2	27	\N	27	\N	\N	0	1	2	f	0	47	\N
606	47	165	1	27	\N	27	\N	\N	1	1	2	f	\N	47	\N
607	2	165	1	27	\N	27	\N	\N	0	1	2	f	\N	47	\N
610	75	167	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
611	38	167	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
612	49	167	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
613	50	167	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
614	80	167	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
615	75	167	1	1	\N	1	\N	\N	1	1	2	f	\N	49	\N
617	56	169	2	16	\N	16	\N	\N	1	1	2	f	0	71	\N
618	8	169	2	8	\N	8	\N	\N	0	1	2	f	0	62	\N
619	25	169	2	8	\N	8	\N	\N	0	1	2	f	0	71	\N
620	26	169	2	8	\N	8	\N	\N	0	1	2	f	0	71	\N
621	61	169	2	8	\N	8	\N	\N	0	1	2	f	0	71	\N
622	62	169	1	16	\N	16	\N	\N	1	1	2	f	\N	56	\N
623	56	169	1	16	\N	16	\N	\N	0	1	2	f	\N	56	\N
624	71	169	1	16	\N	16	\N	\N	0	1	2	f	\N	56	\N
625	92	169	1	16	\N	16	\N	\N	0	1	2	f	\N	56	\N
627	17	172	2	37741	\N	37741	\N	\N	1	1	2	f	0	40	\N
628	18	172	2	37741	\N	37741	\N	\N	0	1	2	f	0	40	\N
629	52	172	2	37741	\N	37741	\N	\N	0	1	2	f	0	40	\N
630	56	172	2	37741	\N	37741	\N	\N	0	1	2	f	0	40	\N
631	40	172	1	37741	\N	37741	\N	\N	1	1	2	f	\N	52	\N
634	5	175	2	433811	\N	0	\N	\N	1	1	2	f	433811	\N	\N
635	20	175	2	433811	\N	0	\N	\N	0	1	2	f	433811	\N	\N
636	56	175	2	426867	\N	0	\N	\N	0	1	2	f	426867	\N	\N
638	50	177	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
639	80	177	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
640	37	178	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
641	86	179	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
642	37	180	2	1	\N	1	\N	\N	1	1	2	f	0	37	\N
643	37	180	1	1	\N	1	\N	\N	1	1	2	f	\N	37	\N
644	35	181	2	1	\N	1	\N	\N	1	1	2	f	0	34	\N
645	36	181	2	1	\N	1	\N	\N	0	1	2	f	0	34	\N
647	34	181	1	1	\N	1	\N	\N	1	1	2	f	\N	93	\N
648	56	182	2	5661055	\N	0	\N	\N	1	1	2	f	5661055	\N	\N
649	17	182	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
650	18	182	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
651	52	182	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
652	5	182	2	2872362	\N	0	\N	\N	0	1	2	f	2872362	\N	\N
653	20	182	2	2872362	\N	0	\N	\N	0	1	2	f	2872362	\N	\N
654	75	183	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
655	81	184	2	3	\N	3	\N	\N	1	1	2	f	0	51	\N
656	51	184	1	3	\N	3	\N	\N	1	1	2	f	\N	81	\N
657	15	184	1	1	\N	1	\N	\N	0	1	2	f	\N	81	\N
658	16	184	1	1	\N	1	\N	\N	0	1	2	f	\N	81	\N
659	39	184	1	1	\N	1	\N	\N	0	1	2	f	\N	81	\N
661	5	187	2	2297060	\N	2297060	\N	\N	1	1	2	f	0	\N	\N
662	20	187	2	2297060	\N	2297060	\N	\N	0	1	2	f	0	\N	\N
663	56	187	2	2296105	\N	2296105	\N	\N	0	1	2	f	0	\N	\N
664	46	188	2	29511669	\N	0	\N	\N	1	1	2	f	29511669	\N	\N
665	35	189	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
666	36	189	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
668	56	190	2	29392668	\N	0	\N	\N	1	1	2	f	29392668	\N	\N
669	41	190	2	14582684	\N	0	\N	\N	2	1	2	f	14582684	\N	\N
670	33	190	2	82262	\N	0	\N	\N	3	1	2	f	82262	\N	\N
671	57	190	2	22501	\N	0	\N	\N	4	1	2	f	22501	\N	\N
672	4	190	2	13091	\N	0	\N	\N	5	1	2	f	13091	\N	\N
673	76	190	2	6258	\N	0	\N	\N	6	1	2	f	6258	\N	\N
674	43	190	2	393	\N	0	\N	\N	7	1	2	f	393	\N	\N
675	70	190	2	206	\N	0	\N	\N	8	1	2	f	206	\N	\N
676	19	190	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
677	91	190	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
678	5	190	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
679	20	190	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
680	17	190	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
681	18	190	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
682	52	190	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
683	58	190	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
684	66	190	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
685	42	190	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
686	77	190	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
687	31	190	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
688	90	190	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
689	59	190	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
690	84	190	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
691	24	190	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
692	60	190	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
693	21	190	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
694	67	190	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
695	7	190	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
696	45	190	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
697	63	190	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
698	98	190	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
699	6	190	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
700	44	190	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
701	8	190	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
702	25	190	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
703	26	190	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
704	61	190	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
705	62	190	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
706	71	190	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
707	92	190	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
708	50	191	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
709	97	192	2	1	\N	1	\N	\N	1	1	2	f	0	47	\N
710	47	192	1	1	\N	1	\N	\N	1	1	2	f	\N	97	\N
711	2	192	1	1	\N	1	\N	\N	0	1	2	f	\N	97	\N
712	38	193	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
713	54	194	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
714	5	195	2	2335473	\N	2335473	\N	\N	1	1	2	f	0	\N	\N
715	20	195	2	2335473	\N	2335473	\N	\N	0	1	2	f	0	\N	\N
716	56	195	2	2334763	\N	2334763	\N	\N	0	1	2	f	0	\N	\N
717	38	196	2	3	\N	3	\N	\N	1	1	2	f	0	80	\N
718	80	196	1	3	\N	3	\N	\N	1	1	2	f	\N	38	\N
721	56	199	2	29392668	\N	0	\N	\N	1	1	2	f	29392668	\N	\N
722	33	199	2	82262	\N	0	\N	\N	2	1	2	f	82262	\N	\N
723	57	199	2	22501	\N	0	\N	\N	3	1	2	f	22501	\N	\N
724	4	199	2	13091	\N	0	\N	\N	4	1	2	f	13091	\N	\N
725	76	199	2	6258	\N	0	\N	\N	5	1	2	f	6258	\N	\N
726	43	199	2	393	\N	0	\N	\N	6	1	2	f	393	\N	\N
727	70	199	2	206	\N	0	\N	\N	7	1	2	f	206	\N	\N
728	53	199	2	2	\N	0	\N	\N	8	1	2	f	2	\N	\N
729	82	199	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
730	19	199	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
731	91	199	2	22551940	\N	0	\N	\N	0	1	2	f	22551940	\N	\N
732	5	199	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
733	20	199	2	4056890	\N	0	\N	\N	0	1	2	f	4056890	\N	\N
734	17	199	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
735	18	199	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
736	52	199	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
737	58	199	2	82262	\N	0	\N	\N	0	1	2	f	82262	\N	\N
738	66	199	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
739	42	199	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
740	77	199	2	15094	\N	0	\N	\N	0	1	2	f	15094	\N	\N
741	31	199	2	13091	\N	0	\N	\N	0	1	2	f	13091	\N	\N
742	90	199	2	6258	\N	0	\N	\N	0	1	2	f	6258	\N	\N
743	59	199	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
744	84	199	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
745	24	199	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
746	60	199	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
747	21	199	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
748	67	199	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
749	7	199	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
750	45	199	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
751	63	199	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
752	98	199	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
753	6	199	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
754	44	199	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
755	8	199	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
756	25	199	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
757	26	199	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
758	61	199	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
759	68	199	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
760	62	199	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
761	71	199	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
762	92	199	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
763	96	199	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
764	5	200	2	370446	\N	0	\N	\N	1	1	2	f	370446	\N	\N
765	20	200	2	370446	\N	0	\N	\N	0	1	2	f	370446	\N	\N
766	56	200	2	369302	\N	0	\N	\N	0	1	2	f	369302	\N	\N
767	54	201	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
770	47	204	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
771	53	205	2	1	\N	1	\N	\N	1	1	2	f	0	94	\N
772	68	205	2	1	\N	1	\N	\N	0	1	2	f	0	94	\N
773	94	205	1	1	\N	1	\N	\N	1	1	2	f	\N	68	\N
774	57	206	2	22501	\N	22501	\N	\N	1	1	2	f	0	\N	\N
775	66	206	2	22501	\N	22501	\N	\N	0	1	2	f	0	\N	\N
776	50	207	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
778	47	209	2	1	\N	1	\N	\N	1	1	2	f	0	97	\N
779	2	209	2	1	\N	1	\N	\N	0	1	2	f	0	97	\N
780	97	209	1	1	\N	1	\N	\N	1	1	2	f	\N	47	\N
781	53	210	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
782	68	210	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
783	17	211	2	516897	\N	0	\N	\N	1	1	2	f	516897	\N	\N
784	18	211	2	516897	\N	0	\N	\N	0	1	2	f	516897	\N	\N
785	52	211	2	516897	\N	0	\N	\N	0	1	2	f	516897	\N	\N
786	56	211	2	514898	\N	0	\N	\N	0	1	2	f	514898	\N	\N
789	40	213	2	29511669	\N	29511669	\N	\N	1	1	2	f	0	46	\N
790	46	213	1	29511669	\N	29511669	\N	\N	1	1	2	f	\N	40	\N
791	38	214	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
792	3	214	1	1	\N	1	\N	\N	1	1	2	f	\N	38	\N
793	89	214	1	1	\N	1	\N	\N	2	1	2	f	\N	38	\N
794	2	214	1	2	\N	2	\N	\N	0	1	2	f	\N	38	\N
795	53	215	2	1	\N	1	\N	\N	1	1	2	f	0	93	\N
796	68	215	2	1	\N	1	\N	\N	0	1	2	f	0	93	\N
797	35	215	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
798	36	215	1	1	\N	1	\N	\N	0	1	2	f	\N	53	\N
800	37	216	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
803	35	219	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
804	53	219	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
805	36	219	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
806	68	219	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
808	17	220	2	24526	\N	0	\N	\N	1	1	2	f	24526	\N	\N
809	18	220	2	24526	\N	0	\N	\N	0	1	2	f	24526	\N	\N
810	52	220	2	24526	\N	0	\N	\N	0	1	2	f	24526	\N	\N
811	56	220	2	24367	\N	0	\N	\N	0	1	2	f	24367	\N	\N
812	40	221	2	29511669	\N	0	\N	\N	1	1	2	f	29511669	\N	\N
815	17	224	2	2837194	\N	0	\N	\N	1	1	2	f	2837194	\N	\N
816	18	224	2	2837194	\N	0	\N	\N	0	1	2	f	2837194	\N	\N
817	52	224	2	2837194	\N	0	\N	\N	0	1	2	f	2837194	\N	\N
818	56	224	2	2837194	\N	0	\N	\N	0	1	2	f	2837194	\N	\N
819	57	225	2	22501	\N	0	\N	\N	1	1	2	f	22501	\N	\N
820	66	225	2	22501	\N	0	\N	\N	0	1	2	f	22501	\N	\N
821	32	226	2	41854	\N	41854	\N	\N	1	1	2	f	0	40	\N
822	56	226	2	41854	\N	41854	\N	\N	0	1	2	f	0	40	\N
823	40	226	1	41854	\N	41854	\N	\N	1	1	2	f	\N	32	\N
825	56	228	2	26555474	\N	26555474	\N	\N	1	1	2	f	0	40	\N
826	57	228	2	22501	\N	22501	\N	\N	2	1	2	f	0	32	\N
827	4	228	2	13091	\N	13091	\N	\N	3	1	2	f	0	32	\N
828	76	228	2	6258	\N	6258	\N	\N	4	1	2	f	0	32	\N
829	19	228	2	22551829	\N	22551829	\N	\N	0	1	2	f	0	40	\N
830	91	228	2	22551829	\N	22551829	\N	\N	0	1	2	f	0	40	\N
831	5	228	2	3988269	\N	3988269	\N	\N	0	1	2	f	0	40	\N
832	20	228	2	3988269	\N	3988269	\N	\N	0	1	2	f	0	40	\N
833	66	228	2	22501	\N	22501	\N	\N	0	1	2	f	0	32	\N
834	42	228	2	15094	\N	15094	\N	\N	0	1	2	f	0	40	\N
835	77	228	2	15094	\N	15094	\N	\N	0	1	2	f	0	40	\N
836	31	228	2	13091	\N	13091	\N	\N	0	1	2	f	0	32	\N
837	90	228	2	6258	\N	6258	\N	\N	0	1	2	f	0	32	\N
838	24	228	2	142	\N	142	\N	\N	0	1	2	f	0	40	\N
839	60	228	2	142	\N	142	\N	\N	0	1	2	f	0	40	\N
840	21	228	2	77	\N	77	\N	\N	0	1	2	f	0	40	\N
841	67	228	2	77	\N	77	\N	\N	0	1	2	f	0	40	\N
842	7	228	2	22	\N	22	\N	\N	0	1	2	f	0	40	\N
843	45	228	2	22	\N	22	\N	\N	0	1	2	f	0	40	\N
844	63	228	2	14	\N	14	\N	\N	0	1	2	f	0	40	\N
845	98	228	2	14	\N	14	\N	\N	0	1	2	f	0	40	\N
846	6	228	2	10	\N	10	\N	\N	0	1	2	f	0	40	\N
847	44	228	2	10	\N	10	\N	\N	0	1	2	f	0	40	\N
848	8	228	2	8	\N	8	\N	\N	0	1	2	f	0	40	\N
849	25	228	2	8	\N	8	\N	\N	0	1	2	f	0	40	\N
850	26	228	2	8	\N	8	\N	\N	0	1	2	f	0	40	\N
851	61	228	2	8	\N	8	\N	\N	0	1	2	f	0	40	\N
852	62	228	2	1	\N	1	\N	\N	0	1	2	f	0	40	\N
853	71	228	2	1	\N	1	\N	\N	0	1	2	f	0	40	\N
854	92	228	2	1	\N	1	\N	\N	0	1	2	f	0	40	\N
855	40	228	1	26555474	\N	26555474	\N	\N	1	1	2	f	\N	56	\N
856	32	228	1	41850	\N	41850	\N	\N	2	1	2	f	\N	\N	\N
857	56	228	1	41850	\N	41850	\N	\N	0	1	2	f	\N	\N	\N
860	53	231	2	1	\N	1	\N	\N	1	1	2	f	0	83	\N
861	68	231	2	1	\N	1	\N	\N	0	1	2	f	0	83	\N
862	83	231	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
863	54	232	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
864	53	233	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
865	68	233	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
866	47	234	2	3597	\N	3597	\N	\N	1	1	2	f	0	97	\N
867	2	234	2	19	\N	19	\N	\N	0	1	2	f	0	97	\N
868	97	234	1	3597	\N	3597	\N	\N	1	1	2	f	\N	47	\N
869	76	236	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
870	90	236	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
874	63	239	2	14	\N	14	\N	\N	1	1	2	f	0	26	\N
875	56	239	2	14	\N	14	\N	\N	0	1	2	f	0	26	\N
876	98	239	2	14	\N	14	\N	\N	0	1	2	f	0	26	\N
877	26	239	1	14	\N	14	\N	\N	1	1	2	f	\N	63	\N
878	56	239	1	14	\N	14	\N	\N	0	1	2	f	\N	63	\N
879	61	239	1	14	\N	14	\N	\N	0	1	2	f	\N	98	\N
880	3	240	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
881	29	240	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
882	89	240	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
883	2	240	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
884	2	240	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
885	43	241	2	393	\N	0	\N	\N	1	1	2	f	393	\N	\N
886	59	241	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
887	76	242	2	6258	\N	6258	\N	\N	1	1	2	f	0	\N	\N
888	21	242	2	77	\N	77	\N	\N	2	1	2	f	0	\N	\N
889	90	242	2	6258	\N	6258	\N	\N	0	1	2	f	0	\N	\N
890	56	242	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
891	67	242	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
895	76	244	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
896	90	244	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
897	49	245	2	230	\N	230	\N	\N	1	1	2	f	0	\N	\N
898	14	245	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
899	47	245	1	17	\N	17	\N	\N	1	1	2	f	\N	49	\N
900	29	245	1	2	\N	2	\N	\N	2	1	2	f	\N	49	\N
901	86	245	1	2	\N	2	\N	\N	3	1	2	f	\N	49	\N
902	89	245	1	1	\N	1	\N	\N	4	1	2	f	\N	49	\N
903	2	245	1	62	\N	62	\N	\N	0	1	2	f	\N	49	\N
905	35	248	2	1	\N	1	\N	\N	1	1	2	f	0	47	\N
906	36	248	2	1	\N	1	\N	\N	0	1	2	f	0	47	\N
908	47	248	1	1	\N	1	\N	\N	1	1	2	f	\N	93	\N
909	53	250	2	1	\N	1	\N	\N	1	1	2	f	0	96	\N
910	68	250	2	1	\N	1	\N	\N	0	1	2	f	0	82	\N
911	82	250	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
912	96	250	1	1	\N	1	\N	\N	0	1	2	f	\N	53	\N
914	5	252	2	4056890	\N	4056890	\N	\N	1	1	2	f	0	\N	\N
915	20	252	2	4056890	\N	4056890	\N	\N	0	1	2	f	0	\N	\N
916	56	252	2	3988269	\N	3988269	\N	\N	0	1	2	f	0	\N	\N
919	57	254	2	22501	\N	22501	\N	\N	1	1	2	f	0	4	\N
920	66	254	2	22501	\N	22501	\N	\N	0	1	2	f	0	4	\N
921	4	254	1	22501	\N	22501	\N	\N	1	1	2	f	\N	66	\N
922	31	254	1	22501	\N	22501	\N	\N	0	1	2	f	\N	66	\N
923	53	255	2	1	\N	1	\N	\N	1	1	2	f	0	9	\N
924	68	255	2	1	\N	1	\N	\N	0	1	2	f	0	55	\N
925	9	255	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
926	55	255	1	1	\N	1	\N	\N	0	1	2	f	\N	68	\N
927	50	257	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
928	39	257	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
929	38	257	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
930	51	257	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
932	56	259	2	91098899	\N	91098899	\N	\N	1	1	2	f	0	\N	\N
933	40	259	2	29511669	\N	29511669	\N	\N	2	1	2	f	0	\N	\N
934	46	259	2	29511669	\N	29511669	\N	\N	3	1	2	f	0	\N	\N
935	41	259	2	14414766	\N	14414766	\N	\N	4	1	2	f	0	\N	\N
936	33	259	2	164524	\N	164524	\N	\N	5	1	2	f	0	\N	\N
937	57	259	2	45002	\N	45002	\N	\N	6	1	2	f	0	\N	\N
938	4	259	2	26182	\N	26182	\N	\N	7	1	2	f	0	\N	\N
939	76	259	2	12516	\N	12516	\N	\N	8	1	2	f	0	\N	\N
940	47	259	2	3619	\N	3619	\N	\N	9	1	2	f	0	\N	\N
941	43	259	2	786	\N	786	\N	\N	10	1	2	f	0	\N	\N
942	70	259	2	412	\N	412	\N	\N	11	1	2	f	0	\N	\N
943	49	259	2	251	\N	251	\N	\N	12	1	2	f	0	\N	\N
946	10	259	2	44	\N	44	\N	\N	15	1	2	f	0	\N	\N
947	48	259	2	22	\N	22	\N	\N	16	1	2	f	0	\N	\N
948	97	259	2	18	\N	18	\N	\N	17	1	2	f	0	\N	\N
952	51	259	2	6	\N	6	\N	\N	21	1	2	f	0	\N	\N
953	86	259	2	5	\N	5	\N	\N	22	1	2	f	0	\N	\N
955	35	259	2	3	\N	3	\N	\N	24	1	2	f	0	\N	\N
957	38	259	2	3	\N	3	\N	\N	26	1	2	f	0	\N	\N
959	81	259	2	3	\N	3	\N	\N	28	1	2	f	0	\N	\N
960	3	259	2	2	\N	2	\N	\N	29	1	2	f	0	\N	\N
961	9	259	2	2	\N	2	\N	\N	30	1	2	f	0	\N	\N
962	29	259	2	2	\N	2	\N	\N	31	1	2	f	0	\N	\N
963	53	259	2	2	\N	2	\N	\N	32	1	2	f	0	\N	\N
964	72	259	2	2	\N	2	\N	\N	33	1	2	f	0	\N	\N
965	82	259	2	2	\N	2	\N	\N	34	1	2	f	0	\N	\N
966	89	259	2	2	\N	2	\N	\N	35	1	2	f	0	\N	\N
969	34	259	2	2	\N	2	\N	\N	38	1	2	f	0	\N	\N
970	75	259	2	2	\N	2	\N	\N	39	1	2	f	0	\N	\N
973	22	259	2	1	\N	1	\N	\N	42	1	2	f	0	\N	\N
974	23	259	2	1	\N	1	\N	\N	43	1	2	f	0	\N	\N
975	30	259	2	1	\N	1	\N	\N	44	1	2	f	0	\N	\N
976	37	259	2	1	\N	1	\N	\N	45	1	2	f	0	\N	\N
977	50	259	2	1	\N	1	\N	\N	46	1	2	f	0	\N	\N
978	54	259	2	1	\N	1	\N	\N	47	1	2	f	0	\N	\N
979	64	259	2	1	\N	1	\N	\N	48	1	2	f	0	\N	\N
980	69	259	2	1	\N	1	\N	\N	49	1	2	f	0	\N	\N
981	80	259	2	1	\N	1	\N	\N	50	1	2	f	0	\N	\N
982	83	259	2	1	\N	1	\N	\N	51	1	2	f	0	\N	\N
983	94	259	2	1	\N	1	\N	\N	52	1	2	f	0	\N	\N
984	19	259	2	67655709	\N	67655709	\N	\N	0	1	2	f	0	\N	\N
985	91	259	2	67655709	\N	67655709	\N	\N	0	1	2	f	0	\N	\N
986	5	259	2	12102049	\N	12102049	\N	\N	0	1	2	f	0	\N	\N
987	20	259	2	12102049	\N	12102049	\N	\N	0	1	2	f	0	\N	\N
988	17	259	2	11538385	\N	11538385	\N	\N	0	1	2	f	0	\N	\N
989	18	259	2	11538385	\N	11538385	\N	\N	0	1	2	f	0	\N	\N
990	52	259	2	11538385	\N	11538385	\N	\N	0	1	2	f	0	\N	\N
991	58	259	2	164524	\N	164524	\N	\N	0	1	2	f	0	\N	\N
992	32	259	2	83700	\N	83700	\N	\N	0	1	2	f	0	\N	\N
993	42	259	2	45282	\N	45282	\N	\N	0	1	2	f	0	\N	\N
994	77	259	2	45282	\N	45282	\N	\N	0	1	2	f	0	\N	\N
995	66	259	2	45002	\N	45002	\N	\N	0	1	2	f	0	\N	\N
996	31	259	2	26182	\N	26182	\N	\N	0	1	2	f	0	\N	\N
997	90	259	2	12516	\N	12516	\N	\N	0	1	2	f	0	\N	\N
998	59	259	2	786	\N	786	\N	\N	0	1	2	f	0	\N	\N
999	24	259	2	426	\N	426	\N	\N	0	1	2	f	0	\N	\N
1000	60	259	2	426	\N	426	\N	\N	0	1	2	f	0	\N	\N
1001	84	259	2	412	\N	412	\N	\N	0	1	2	f	0	\N	\N
1002	21	259	2	231	\N	231	\N	\N	0	1	2	f	0	\N	\N
1003	67	259	2	231	\N	231	\N	\N	0	1	2	f	0	\N	\N
1004	2	259	2	97	\N	97	\N	\N	0	1	2	f	0	\N	\N
1005	7	259	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
1006	45	259	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
1007	87	259	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1008	63	259	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
1009	98	259	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
1010	6	259	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1011	44	259	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1012	8	259	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1013	25	259	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1014	26	259	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1015	61	259	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1016	14	259	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1017	74	259	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1018	92	259	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1019	62	259	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1020	71	259	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1021	36	259	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1023	15	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1024	16	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1025	39	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1026	55	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1027	68	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1028	85	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1029	96	259	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1030	2	259	1	16	\N	16	\N	\N	0	1	2	f	\N	\N	\N
1031	75	260	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1032	47	262	2	24	\N	24	\N	\N	1	1	2	f	0	47	\N
1033	2	262	2	24	\N	24	\N	\N	0	1	2	f	0	47	\N
1034	47	262	1	24	\N	24	\N	\N	1	1	2	f	\N	47	\N
1035	2	262	1	24	\N	24	\N	\N	0	1	2	f	\N	47	\N
1037	53	264	2	1	\N	1	\N	\N	1	1	2	f	0	96	\N
1038	68	264	2	1	\N	1	\N	\N	0	1	2	f	0	82	\N
1039	82	264	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
1040	96	264	1	1	\N	1	\N	\N	0	1	2	f	\N	53	\N
1045	5	267	2	498685	\N	498685	\N	\N	1	1	2	f	0	41	\N
1046	20	267	2	498685	\N	498685	\N	\N	0	1	2	f	0	41	\N
1047	56	267	2	495547	\N	495547	\N	\N	0	1	2	f	0	41	\N
1048	41	267	1	498685	\N	498685	\N	\N	1	1	2	f	\N	20	\N
1060	38	274	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1067	17	276	2	2900397	\N	0	\N	\N	1	1	2	f	2900397	\N	\N
1068	18	276	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
1069	52	276	2	2900397	\N	0	\N	\N	0	1	2	f	2900397	\N	\N
1070	56	276	2	2837194	\N	0	\N	\N	0	1	2	f	2837194	\N	\N
1074	76	279	2	6258	\N	6258	\N	\N	1	1	2	f	0	\N	\N
1075	90	279	2	6258	\N	6258	\N	\N	0	1	2	f	0	\N	\N
1076	50	280	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1077	10	281	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
1078	87	281	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
1079	35	282	2	1	\N	1	\N	\N	1	1	2	f	0	64	\N
1080	36	282	2	1	\N	1	\N	\N	0	1	2	f	0	64	\N
1082	64	282	1	1	\N	1	\N	\N	1	1	2	f	\N	35	\N
1083	5	283	2	2233565	\N	2233565	\N	\N	1	1	2	f	0	\N	\N
1084	20	283	2	2233565	\N	2233565	\N	\N	0	1	2	f	0	\N	\N
1085	56	283	2	2232620	\N	2232620	\N	\N	0	1	2	f	0	\N	\N
1086	53	284	2	1	\N	1	\N	\N	1	1	2	f	0	23	\N
1087	68	284	2	1	\N	1	\N	\N	0	1	2	f	0	23	\N
1088	23	284	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
1091	41	287	2	16348400	\N	0	\N	\N	1	1	2	f	16348400	\N	\N
1092	53	288	2	1	\N	1	\N	\N	1	1	2	f	0	93	\N
1093	68	288	2	1	\N	1	\N	\N	0	1	2	f	0	93	\N
1094	35	288	1	1	\N	1	\N	\N	1	1	2	f	\N	53	\N
1095	36	288	1	1	\N	1	\N	\N	0	1	2	f	\N	53	\N
1097	54	289	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1098	33	290	2	82262	\N	82262	\N	\N	1	1	2	f	0	90	\N
1099	56	290	2	15268	\N	15268	\N	\N	2	1	2	f	0	90	\N
1100	4	290	2	13091	\N	13091	\N	\N	3	1	2	f	0	76	\N
1101	58	290	2	82262	\N	82262	\N	\N	0	1	2	f	0	76	\N
1102	42	290	2	15094	\N	15094	\N	\N	0	1	2	f	0	90	\N
1103	77	290	2	15094	\N	15094	\N	\N	0	1	2	f	0	90	\N
1104	31	290	2	13091	\N	13091	\N	\N	0	1	2	f	0	90	\N
1105	24	290	2	142	\N	142	\N	\N	0	1	2	f	0	90	\N
1106	60	290	2	142	\N	142	\N	\N	0	1	2	f	0	90	\N
1107	7	290	2	22	\N	22	\N	\N	0	1	2	f	0	76	\N
1108	45	290	2	22	\N	22	\N	\N	0	1	2	f	0	76	\N
1109	6	290	2	10	\N	10	\N	\N	0	1	2	f	0	90	\N
1110	44	290	2	10	\N	10	\N	\N	0	1	2	f	0	76	\N
1111	76	290	1	110621	\N	110621	\N	\N	1	1	2	f	\N	\N	\N
1112	90	290	1	110621	\N	110621	\N	\N	0	1	2	f	\N	\N	\N
1113	37	291	2	1	\N	1	\N	\N	1	1	2	f	0	37	\N
1114	37	291	1	1	\N	1	\N	\N	1	1	2	f	\N	37	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	4	56	57	\N	0	\N
2	4	44	57	\N	1	\N
3	4	6	57	\N	0	\N
4	5	44	57	\N	1	\N
5	5	56	57	\N	0	\N
6	5	6	57	\N	0	\N
7	6	6	57	\N	1	\N
8	6	56	57	\N	0	\N
9	6	44	57	\N	0	\N
10	7	60	57	\N	1	\N
11	7	56	57	\N	0	\N
12	7	24	57	\N	0	\N
13	8	56	57	\N	0	\N
14	8	60	57	\N	1	\N
15	8	24	57	\N	0	\N
16	9	56	57	\N	0	\N
17	9	60	57	\N	1	\N
18	9	24	57	\N	0	\N
19	12	22	1	\N	1	\N
20	13	22	1	\N	1	\N
21	14	53	1	\N	1	\N
22	14	68	1	\N	0	\N
23	17	56	412087	\N	0	\N
24	17	60	412087	\N	1	\N
25	17	24	412087	\N	0	\N
26	18	56	412087	\N	0	\N
27	18	24	412087	\N	1	\N
28	18	60	412087	\N	0	\N
29	19	60	404407	\N	1	\N
30	19	56	404407	\N	0	\N
31	19	24	404407	\N	0	\N
32	20	20	412087	\N	1	\N
33	20	56	404407	\N	0	\N
34	20	5	412087	\N	0	\N
35	21	5	412087	\N	1	\N
36	21	20	412087	\N	0	\N
37	21	56	404407	\N	0	\N
38	22	56	404407	\N	0	\N
39	22	5	412087	\N	1	\N
40	22	20	412087	\N	0	\N
41	30	92	2	\N	1	\N
42	30	71	1	\N	0	\N
43	30	62	1	\N	0	\N
44	30	56	1	\N	0	\N
45	31	92	2	\N	1	\N
46	31	56	1	\N	0	\N
47	31	71	1	\N	0	\N
48	31	62	1	\N	0	\N
49	32	53	2	\N	1	\N
50	32	68	2	\N	0	\N
51	33	68	1	\N	1	\N
52	33	53	1	\N	0	\N
53	34	68	1	\N	1	\N
54	34	53	1	\N	0	\N
55	35	68	1	\N	1	\N
56	35	53	1	\N	0	\N
57	54	68	1	\N	1	\N
58	54	53	1	\N	0	\N
59	55	68	1	\N	1	\N
60	55	53	1	\N	0	\N
61	56	9	1	\N	1	\N
62	56	55	1	\N	0	\N
63	57	55	1	\N	1	\N
64	57	9	1	\N	0	\N
65	58	58	1487735	\N	1	\N
66	58	33	1487735	\N	0	\N
67	59	33	1487735	\N	1	\N
68	59	58	1487735	\N	0	\N
69	60	33	1487735	\N	1	\N
70	60	58	1487735	\N	0	\N
71	61	33	1472079	\N	1	\N
72	61	58	1472079	\N	0	\N
73	62	18	1487735	\N	1	\N
74	62	52	1487735	\N	0	\N
75	62	56	1472079	\N	0	\N
76	62	17	1487735	\N	0	\N
77	63	17	1487735	\N	1	\N
78	63	56	1472079	\N	0	\N
79	63	18	1487735	\N	0	\N
80	63	52	1487735	\N	0	\N
81	64	29	1	\N	1	\N
82	64	2	1	\N	0	\N
83	65	38	1	\N	1	\N
84	66	38	1	\N	1	\N
85	80	47	1	\N	1	\N
86	82	47	1	\N	1	\N
87	84	47	1	\N	1	\N
89	88	64	1	\N	1	\N
90	88	36	1	\N	2	\N
92	88	35	1	\N	0	\N
93	93	50	1	\N	1	\N
94	94	75	1	\N	1	\N
95	110	25	77	\N	1	\N
96	110	8	77	\N	0	\N
97	110	56	77	\N	0	\N
98	111	8	77	\N	1	\N
99	111	56	77	\N	0	\N
100	111	25	77	\N	0	\N
101	112	25	77	\N	1	\N
102	112	56	77	\N	0	\N
103	112	8	77	\N	0	\N
104	113	56	77	\N	0	\N
105	113	21	77	\N	1	\N
106	113	67	77	\N	0	\N
107	114	21	77	\N	1	\N
108	114	56	77	\N	0	\N
109	114	67	77	\N	0	\N
110	115	56	77	\N	0	\N
111	115	21	77	\N	1	\N
112	115	67	77	\N	0	\N
115	128	40	2837194	\N	1	\N
116	129	40	2837194	\N	1	\N
117	130	40	2837194	\N	1	\N
118	131	40	2837194	\N	1	\N
119	132	56	2837194	\N	0	\N
120	132	52	2837194	\N	1	\N
121	132	17	2837194	\N	0	\N
122	132	18	2837194	\N	0	\N
123	134	2	2	\N	0	\N
124	135	2	2	\N	0	\N
125	177	70	393	\N	1	\N
126	177	84	393	\N	0	\N
127	178	84	393	\N	1	\N
128	178	70	393	\N	0	\N
129	179	43	393	\N	1	\N
130	179	59	393	\N	0	\N
131	180	59	393	\N	1	\N
132	180	43	393	\N	0	\N
133	181	56	2829101	\N	0	\N
134	181	77	2829101	\N	1	\N
135	181	42	2829101	\N	0	\N
136	182	56	2829101	\N	0	\N
137	182	77	2829101	\N	1	\N
138	182	42	2829101	\N	0	\N
139	183	56	2780602	\N	0	\N
140	183	42	2780602	\N	1	\N
141	183	77	2780602	\N	0	\N
142	184	56	2780602	\N	0	\N
143	184	5	2829101	\N	1	\N
144	184	20	2829101	\N	0	\N
145	185	5	2829101	\N	1	\N
146	185	20	2829101	\N	0	\N
147	185	56	2780602	\N	0	\N
148	186	20	2829101	\N	1	\N
149	186	5	2829101	\N	0	\N
150	186	56	2780602	\N	0	\N
153	192	69	1	\N	1	\N
154	193	69	1	\N	1	\N
155	194	69	1	\N	1	\N
156	195	69	1	\N	1	\N
158	197	36	1	\N	1	\N
159	197	53	1	\N	2	\N
160	197	35	1	\N	0	\N
161	197	68	1	\N	0	\N
163	198	38	3	\N	1	\N
164	199	50	3	\N	1	\N
165	200	34	1	\N	1	\N
166	201	34	1	\N	1	\N
169	203	35	1	\N	0	\N
170	203	36	1	\N	0	\N
211	259	19	3965523	\N	1	\N
212	259	56	3965519	\N	0	\N
213	259	91	3965523	\N	0	\N
214	260	91	3965523	\N	1	\N
215	260	56	3965519	\N	0	\N
216	260	19	3965523	\N	0	\N
217	261	91	3943625	\N	1	\N
218	261	56	3943621	\N	0	\N
219	261	19	3943625	\N	0	\N
220	262	5	3965523	\N	1	\N
221	262	20	3965523	\N	0	\N
222	262	56	3943625	\N	0	\N
223	263	20	3965523	\N	1	\N
224	263	56	3943625	\N	0	\N
225	263	5	3965523	\N	0	\N
226	264	5	3965519	\N	1	\N
227	264	20	3965519	\N	0	\N
228	264	56	3943621	\N	0	\N
229	265	75	1	\N	1	\N
230	266	49	1	\N	1	\N
231	310	81	3	\N	1	\N
232	311	38	3	\N	1	\N
237	352	40	39406	\N	1	\N
238	353	40	39406	\N	1	\N
239	354	40	39406	\N	1	\N
240	355	40	39406	\N	1	\N
241	356	56	39406	\N	0	\N
242	356	52	39406	\N	1	\N
243	356	17	39406	\N	0	\N
244	356	18	39406	\N	0	\N
245	361	86	4	\N	1	\N
246	362	86	4	\N	1	\N
247	364	31	22551940	\N	1	\N
248	364	4	22551940	\N	0	\N
249	365	31	22551940	\N	1	\N
250	365	4	22551940	\N	0	\N
251	366	31	22551829	\N	1	\N
252	366	4	22551829	\N	0	\N
253	367	56	22551829	\N	0	\N
254	367	91	22551940	\N	1	\N
255	367	19	22551940	\N	0	\N
256	368	56	22551829	\N	0	\N
257	368	19	22551940	\N	1	\N
258	368	91	22551940	\N	0	\N
259	397	47	70	\N	1	\N
260	398	47	70	\N	1	\N
261	404	59	6258	\N	1	\N
262	404	43	6258	\N	0	\N
263	405	43	6258	\N	1	\N
264	405	59	6258	\N	0	\N
265	406	90	6258	\N	1	\N
266	406	76	6258	\N	0	\N
267	407	76	6258	\N	1	\N
268	407	90	6258	\N	0	\N
271	482	68	1	\N	1	\N
272	482	53	1	\N	0	\N
273	483	68	1	\N	1	\N
274	483	53	1	\N	0	\N
275	484	9	1	\N	1	\N
276	484	55	1	\N	0	\N
277	485	55	1	\N	1	\N
278	485	9	1	\N	0	\N
279	488	56	57	\N	0	\N
280	488	45	57	\N	1	\N
281	488	7	57	\N	0	\N
282	489	45	57	\N	1	\N
283	489	56	57	\N	0	\N
284	489	7	57	\N	0	\N
285	490	7	57	\N	1	\N
286	490	45	57	\N	0	\N
287	490	56	57	\N	0	\N
288	491	60	57	\N	1	\N
289	491	56	57	\N	0	\N
290	491	24	57	\N	0	\N
291	492	56	57	\N	0	\N
292	492	60	57	\N	1	\N
293	492	24	57	\N	0	\N
294	493	56	57	\N	0	\N
295	493	60	57	\N	1	\N
296	493	24	57	\N	0	\N
297	498	98	206	\N	1	\N
298	498	63	206	\N	0	\N
299	498	56	206	\N	0	\N
300	499	98	77	\N	1	\N
301	499	63	77	\N	0	\N
302	499	56	77	\N	0	\N
303	500	98	206	\N	1	\N
304	500	56	206	\N	0	\N
305	500	63	206	\N	0	\N
306	501	56	77	\N	0	\N
307	501	98	77	\N	1	\N
308	501	63	77	\N	0	\N
309	502	63	77	\N	1	\N
310	502	98	77	\N	0	\N
311	502	56	77	\N	0	\N
312	503	56	77	\N	0	\N
313	503	67	77	\N	2	\N
314	503	21	77	\N	0	\N
315	503	70	206	\N	1	\N
316	503	84	206	\N	0	\N
317	504	56	77	\N	0	\N
318	504	84	206	\N	1	\N
319	504	21	77	\N	2	\N
320	504	67	77	\N	0	\N
321	504	70	206	\N	0	\N
322	505	84	206	\N	1	\N
323	505	21	77	\N	2	\N
324	505	56	77	\N	0	\N
325	505	70	206	\N	0	\N
326	505	67	77	\N	0	\N
327	506	3	4	\N	4	\N
328	506	47	25	\N	1	\N
329	506	89	13	\N	2	\N
330	506	86	2	\N	5	\N
331	506	2	287	\N	0	\N
332	506	29	6	\N	3	\N
333	507	2	4	\N	0	\N
334	508	49	25	\N	1	\N
335	509	49	13	\N	1	\N
336	510	49	6	\N	1	\N
337	511	49	4	\N	1	\N
338	512	49	2	\N	1	\N
339	513	14	4	\N	0	\N
340	513	49	287	\N	1	\N
343	521	67	6258	\N	1	\N
344	521	56	6258	\N	0	\N
345	521	21	6258	\N	0	\N
346	522	56	6258	\N	0	\N
347	522	21	6258	\N	1	\N
348	522	67	6258	\N	0	\N
349	523	90	6258	\N	1	\N
350	523	76	6258	\N	0	\N
351	524	90	6258	\N	1	\N
352	524	76	6258	\N	0	\N
353	525	76	6258	\N	1	\N
354	525	90	6258	\N	0	\N
357	540	41	13916081	\N	1	\N
358	541	41	13916081	\N	1	\N
359	542	41	13916019	\N	1	\N
360	543	91	13916081	\N	1	\N
361	543	19	13916081	\N	0	\N
362	543	56	13916019	\N	0	\N
363	544	20	2900397	\N	1	\N
364	544	5	2900397	\N	0	\N
365	544	56	2851806	\N	0	\N
366	545	5	2900397	\N	1	\N
367	545	56	2851806	\N	0	\N
368	545	20	2900397	\N	0	\N
369	546	56	2851806	\N	0	\N
370	546	20	2900397	\N	1	\N
371	546	5	2900397	\N	0	\N
372	547	20	2837194	\N	1	\N
373	547	56	2835693	\N	0	\N
374	547	5	2837194	\N	0	\N
375	548	18	2900397	\N	1	\N
376	548	52	2900397	\N	0	\N
377	548	56	2837194	\N	0	\N
378	548	17	2900397	\N	0	\N
379	549	56	2837194	\N	0	\N
380	549	52	2900397	\N	1	\N
381	549	17	2900397	\N	0	\N
382	549	18	2900397	\N	0	\N
383	550	52	2851806	\N	1	\N
384	550	56	2835693	\N	0	\N
385	550	18	2851806	\N	0	\N
386	550	17	2851806	\N	0	\N
387	592	85	1	\N	1	\N
388	592	72	1	\N	0	\N
389	593	85	1	\N	1	\N
390	593	72	1	\N	0	\N
391	594	68	1	\N	1	\N
392	594	53	1	\N	0	\N
393	595	68	1	\N	1	\N
394	595	53	1	\N	0	\N
395	604	47	27	\N	1	\N
396	604	2	27	\N	0	\N
397	605	2	27	\N	0	\N
398	605	47	27	\N	1	\N
399	606	47	27	\N	1	\N
400	606	2	27	\N	0	\N
401	607	2	27	\N	0	\N
402	607	47	27	\N	1	\N
405	612	75	1	\N	1	\N
406	615	49	1	\N	1	\N
407	617	92	16	\N	0	\N
408	617	71	16	\N	1	\N
409	617	56	16	\N	0	\N
410	617	62	16	\N	0	\N
411	618	92	8	\N	0	\N
412	618	56	8	\N	0	\N
413	618	62	8	\N	1	\N
414	618	71	8	\N	0	\N
415	619	71	8	\N	1	\N
416	619	56	8	\N	0	\N
417	619	62	8	\N	0	\N
418	619	92	8	\N	0	\N
419	620	71	8	\N	1	\N
420	620	56	8	\N	0	\N
421	620	92	8	\N	0	\N
422	620	62	8	\N	0	\N
423	621	92	8	\N	0	\N
424	621	56	8	\N	0	\N
425	621	71	8	\N	1	\N
426	621	62	8	\N	0	\N
427	622	56	16	\N	1	\N
428	622	61	8	\N	0	\N
429	622	25	8	\N	0	\N
430	622	8	8	\N	0	\N
431	622	26	8	\N	0	\N
432	623	61	8	\N	0	\N
433	623	56	16	\N	1	\N
434	623	25	8	\N	0	\N
435	623	26	8	\N	0	\N
436	623	8	8	\N	0	\N
437	624	56	16	\N	1	\N
438	624	25	8	\N	0	\N
439	624	26	8	\N	0	\N
440	624	61	8	\N	0	\N
441	624	8	8	\N	0	\N
442	625	56	16	\N	1	\N
443	625	61	8	\N	0	\N
444	625	8	8	\N	0	\N
445	625	26	8	\N	0	\N
446	625	25	8	\N	0	\N
447	627	40	37741	\N	1	\N
448	628	40	37741	\N	1	\N
449	629	40	37741	\N	1	\N
450	630	40	37741	\N	1	\N
451	631	56	37741	\N	0	\N
452	631	52	37741	\N	1	\N
453	631	17	37741	\N	0	\N
454	631	18	37741	\N	0	\N
455	642	37	1	\N	1	\N
456	643	37	1	\N	1	\N
457	644	34	1	\N	1	\N
458	645	34	1	\N	1	\N
461	647	35	1	\N	0	\N
462	647	36	1	\N	0	\N
463	655	51	3	\N	1	\N
464	655	16	1	\N	0	\N
465	655	15	1	\N	0	\N
466	655	39	1	\N	0	\N
467	656	81	3	\N	1	\N
468	657	81	1	\N	1	\N
469	658	81	1	\N	1	\N
470	659	81	1	\N	1	\N
471	709	47	1	\N	1	\N
472	709	2	1	\N	0	\N
473	710	97	1	\N	1	\N
474	711	97	1	\N	1	\N
475	717	80	3	\N	1	\N
476	718	38	3	\N	1	\N
477	771	94	1	\N	1	\N
478	772	94	1	\N	1	\N
479	773	68	1	\N	1	\N
480	773	53	1	\N	0	\N
481	778	97	1	\N	1	\N
482	779	97	1	\N	1	\N
483	780	47	1	\N	1	\N
484	780	2	1	\N	0	\N
487	789	46	29511669	\N	1	\N
488	790	40	29511669	\N	1	\N
489	791	3	1	\N	1	\N
490	791	89	1	\N	2	\N
491	791	2	2	\N	0	\N
492	792	38	1	\N	1	\N
493	793	38	1	\N	1	\N
494	794	38	2	\N	1	\N
496	795	35	1	\N	0	\N
497	795	36	1	\N	0	\N
499	796	36	1	\N	0	\N
500	796	35	1	\N	0	\N
501	797	53	1	\N	1	\N
502	797	68	1	\N	0	\N
503	798	53	1	\N	1	\N
504	798	68	1	\N	0	\N
507	821	40	41854	\N	1	\N
508	822	40	41854	\N	1	\N
509	823	56	41854	\N	0	\N
510	823	32	41854	\N	1	\N
511	825	40	26555474	\N	1	\N
512	826	32	22501	\N	1	\N
513	826	56	22501	\N	0	\N
514	827	56	13091	\N	0	\N
515	827	32	13091	\N	1	\N
516	828	56	6258	\N	0	\N
517	828	32	6258	\N	1	\N
518	829	40	22551829	\N	1	\N
519	830	40	22551829	\N	1	\N
520	831	40	3988269	\N	1	\N
521	832	40	3988269	\N	1	\N
522	833	56	22501	\N	0	\N
523	833	32	22501	\N	1	\N
524	834	40	15094	\N	1	\N
525	835	40	15094	\N	1	\N
526	836	32	13091	\N	1	\N
527	836	56	13091	\N	0	\N
528	837	56	6258	\N	0	\N
529	837	32	6258	\N	1	\N
530	838	40	142	\N	1	\N
531	839	40	142	\N	1	\N
532	840	40	77	\N	1	\N
533	841	40	77	\N	1	\N
534	842	40	22	\N	1	\N
535	843	40	22	\N	1	\N
536	844	40	14	\N	1	\N
537	845	40	14	\N	1	\N
538	846	40	10	\N	1	\N
539	847	40	10	\N	1	\N
540	848	40	8	\N	1	\N
541	849	40	8	\N	1	\N
542	850	40	8	\N	1	\N
543	851	40	8	\N	1	\N
544	852	40	1	\N	1	\N
545	853	40	1	\N	1	\N
546	854	40	1	\N	1	\N
547	855	56	26555474	\N	1	\N
548	855	24	142	\N	0	\N
549	855	7	22	\N	0	\N
550	855	92	1	\N	0	\N
551	855	62	1	\N	0	\N
552	855	19	22551829	\N	0	\N
553	855	45	22	\N	0	\N
554	855	5	3988269	\N	0	\N
555	855	44	10	\N	0	\N
556	855	8	8	\N	0	\N
557	855	61	8	\N	0	\N
558	855	67	77	\N	0	\N
559	855	98	14	\N	0	\N
560	855	91	22551829	\N	0	\N
561	855	20	3988269	\N	0	\N
562	855	60	142	\N	0	\N
563	855	63	14	\N	0	\N
564	855	6	10	\N	0	\N
565	855	71	1	\N	0	\N
566	855	42	15094	\N	0	\N
567	855	77	15094	\N	0	\N
568	855	21	77	\N	0	\N
569	855	25	8	\N	0	\N
570	855	26	8	\N	0	\N
571	856	31	13091	\N	2	\N
572	856	66	22501	\N	1	\N
573	856	4	13091	\N	0	\N
574	856	57	22501	\N	0	\N
575	856	76	6258	\N	3	\N
576	856	90	6258	\N	0	\N
577	857	90	6258	\N	3	\N
578	857	66	22501	\N	1	\N
579	857	31	13091	\N	2	\N
580	857	4	13091	\N	0	\N
581	857	76	6258	\N	0	\N
582	857	57	22501	\N	0	\N
583	860	83	1	\N	1	\N
584	861	83	1	\N	1	\N
585	862	53	1	\N	1	\N
586	862	68	1	\N	0	\N
587	866	97	3597	\N	1	\N
588	867	97	19	\N	1	\N
589	868	47	3597	\N	1	\N
590	868	2	19	\N	0	\N
593	874	56	14	\N	0	\N
594	874	26	14	\N	1	\N
595	874	61	14	\N	0	\N
596	875	56	14	\N	0	\N
597	875	26	14	\N	1	\N
598	875	61	14	\N	0	\N
599	876	56	14	\N	0	\N
600	876	26	14	\N	1	\N
601	876	61	14	\N	0	\N
602	877	63	14	\N	1	\N
603	877	98	14	\N	0	\N
604	877	56	14	\N	0	\N
605	878	56	14	\N	0	\N
606	878	63	14	\N	1	\N
607	878	98	14	\N	0	\N
608	879	98	14	\N	1	\N
609	879	63	14	\N	0	\N
610	879	56	14	\N	0	\N
611	883	2	32	\N	0	\N
612	884	2	32	\N	0	\N
613	897	47	17	\N	1	\N
614	897	89	1	\N	4	\N
615	897	86	2	\N	3	\N
616	897	2	62	\N	0	\N
617	897	29	2	\N	2	\N
618	898	2	4	\N	0	\N
619	899	49	17	\N	1	\N
620	900	49	2	\N	1	\N
621	901	49	2	\N	1	\N
622	902	49	1	\N	1	\N
623	903	14	4	\N	0	\N
624	903	49	62	\N	1	\N
625	905	47	1	\N	1	\N
626	906	47	1	\N	1	\N
629	908	36	1	\N	0	\N
630	908	35	1	\N	0	\N
631	909	96	1	\N	1	\N
632	909	82	1	\N	0	\N
633	910	82	1	\N	1	\N
634	910	96	1	\N	0	\N
635	911	53	1	\N	1	\N
636	911	68	1	\N	0	\N
637	912	53	1	\N	1	\N
638	912	68	1	\N	0	\N
641	919	4	22501	\N	1	\N
642	919	31	22501	\N	0	\N
643	920	4	22501	\N	1	\N
644	920	31	22501	\N	0	\N
645	921	66	22501	\N	1	\N
646	921	57	22501	\N	0	\N
647	922	66	22501	\N	1	\N
648	922	57	22501	\N	0	\N
649	923	9	1	\N	1	\N
650	923	55	1	\N	0	\N
651	924	55	1	\N	1	\N
652	924	9	1	\N	0	\N
653	925	53	1	\N	1	\N
654	925	68	1	\N	0	\N
655	926	68	1	\N	1	\N
656	926	53	1	\N	0	\N
657	943	2	5	\N	0	\N
658	953	2	5	\N	0	\N
659	970	2	2	\N	0	\N
660	1016	2	4	\N	0	\N
661	1017	2	5	\N	0	\N
662	1030	14	4	\N	3	\N
663	1030	86	5	\N	1	\N
664	1030	75	2	\N	4	\N
665	1030	74	5	\N	2	\N
666	1030	49	5	\N	0	\N
667	1032	47	24	\N	1	\N
668	1032	2	24	\N	0	\N
669	1033	2	24	\N	0	\N
670	1033	47	24	\N	1	\N
671	1034	47	24	\N	1	\N
672	1034	2	24	\N	0	\N
673	1035	2	24	\N	0	\N
674	1035	47	24	\N	1	\N
675	1037	96	1	\N	1	\N
676	1037	82	1	\N	0	\N
677	1038	82	1	\N	1	\N
678	1038	96	1	\N	0	\N
679	1039	53	1	\N	1	\N
680	1039	68	1	\N	0	\N
681	1040	53	1	\N	1	\N
682	1040	68	1	\N	0	\N
687	1045	41	498685	\N	1	\N
688	1046	41	498685	\N	1	\N
689	1047	41	495547	\N	1	\N
690	1048	20	498685	\N	1	\N
691	1048	5	498685	\N	0	\N
692	1048	56	495547	\N	0	\N
707	1079	64	1	\N	1	\N
708	1080	64	1	\N	1	\N
710	1082	35	1	\N	1	\N
711	1082	36	1	\N	0	\N
713	1086	23	1	\N	1	\N
714	1087	23	1	\N	1	\N
715	1088	53	1	\N	1	\N
716	1088	68	1	\N	0	\N
718	1092	35	1	\N	0	\N
719	1092	36	1	\N	0	\N
721	1093	36	1	\N	0	\N
722	1093	35	1	\N	0	\N
723	1094	53	1	\N	1	\N
724	1094	68	1	\N	0	\N
725	1095	53	1	\N	1	\N
726	1095	68	1	\N	0	\N
729	1098	90	82262	\N	1	\N
730	1098	76	82262	\N	0	\N
731	1099	90	15268	\N	1	\N
732	1099	76	15268	\N	0	\N
733	1100	76	13091	\N	1	\N
734	1100	90	13091	\N	0	\N
735	1101	76	82262	\N	1	\N
736	1101	90	82262	\N	0	\N
737	1102	90	15094	\N	1	\N
738	1102	76	15094	\N	0	\N
739	1103	90	15094	\N	1	\N
740	1103	76	15094	\N	0	\N
741	1104	90	13091	\N	1	\N
742	1104	76	13091	\N	0	\N
743	1105	90	142	\N	1	\N
744	1105	76	142	\N	0	\N
745	1106	90	142	\N	1	\N
746	1106	76	142	\N	0	\N
747	1107	76	22	\N	1	\N
748	1107	90	22	\N	0	\N
749	1108	76	22	\N	1	\N
750	1108	90	22	\N	0	\N
751	1109	90	10	\N	1	\N
752	1109	76	10	\N	0	\N
753	1110	76	10	\N	1	\N
754	1110	90	10	\N	0	\N
755	1111	7	22	\N	0	\N
756	1111	77	15094	\N	0	\N
757	1111	58	82262	\N	1	\N
758	1111	4	13091	\N	3	\N
759	1111	33	82262	\N	0	\N
760	1111	56	15268	\N	2	\N
761	1111	42	15094	\N	0	\N
762	1111	60	142	\N	0	\N
763	1111	44	10	\N	0	\N
764	1111	31	13091	\N	0	\N
765	1111	24	142	\N	0	\N
766	1111	45	22	\N	0	\N
767	1111	6	10	\N	0	\N
768	1112	56	15268	\N	2	\N
769	1112	42	15094	\N	0	\N
770	1112	77	15094	\N	0	\N
771	1112	6	10	\N	0	\N
772	1112	33	82262	\N	1	\N
773	1112	24	142	\N	0	\N
774	1112	60	142	\N	0	\N
775	1112	4	13091	\N	3	\N
776	1112	31	13091	\N	0	\N
777	1112	58	82262	\N	0	\N
778	1112	7	22	\N	0	\N
779	1112	44	10	\N	0	\N
780	1112	45	22	\N	0	\N
781	1113	37	1	\N	1	\N
782	1114	37	1	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
72	n_2	https://ruian.linked.opendata.cz/slovník/	0	f	0
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
20	dbr	http://dbpedia.org/resource/	0	f	0
21	dbt	http://dbpedia.org/resource/Template:	0	f	0
22	dbc	http://dbpedia.org/resource/Category:	0	f	0
23	cc	http://creativecommons.org/ns#	0	f	0
24	vann	http://purl.org/vocab/vann/	0	f	0
73	n_3	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
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
17		http://www.openlinksw.com/schemas/virtrdf#	0	t	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
70	adms	http://www.w3.org/ns/adms#	0	f	0
71	n_1	https://ruian.linked.opendata.cz/slovník/TypPrvku#	0	f	0
74	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
75	gml	http://www.opengis.net/ont/gml#	0	f	0
76	n_4	http://www.openlinksw.com/schemas/VSPX#	0	f	0
77	n_5	https://ruian.linked.opendata.cz/slovníky/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	https_ruian_linked_opendata_cz_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	https_ruian_linked_opendata_cz_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://ruian.linked.opendata.cz/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "https://ruian.linked.opendata.cz/sparql", "correlationId": "9027923675153326764", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": "base", "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:21:23.382Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/ns/dcat#downloadURL	1	\N	15	downloadURL	downloadURL	f	1	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
2	https://ruian.linked.opendata.cz/slovník/mop	57	\N	72	mop	mop	f	57	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
3	http://xmlns.com/foaf/0.1/name	2	\N	8	name	name	f	0	\N	\N	f	f	82	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://xmlns.com/foaf/0.1/page	1	\N	8	page	page	f	1	\N	\N	f	f	53	22	\N	t	f	\N	\N	\N	t	f	f
5	http://www.w3.org/2004/02/skos/core#note	92	\N	4	note	note	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
7	https://ruian.linked.opendata.cz/slovník/momc	412087	\N	72	momc	momc	f	412087	\N	\N	f	f	5	24	\N	t	f	\N	\N	\N	t	f	f
8	https://ruian.linked.opendata.cz/slovník/připojeníVodovod	2296498	\N	72	připojeníVodovod	připojeníVodovod	f	2296498	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
9	https://ruian.linked.opendata.cz/slovník/početBytů	2764026	\N	72	početBytů	početBytů	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://purl.org/dc/terms/spatial	2	\N	5	spatial	spatial	f	2	\N	\N	f	f	53	92	\N	t	f	\N	\N	\N	t	f	f
12	https://ruian.linked.opendata.cz/slovník/adresníPošta	2900397	\N	72	adresníPošta	adresníPošta	f	2900397	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://www.w3.org/2006/vcard/ns#fn	1	\N	39	fn	fn	f	0	\N	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.opengis.net/ont/gml#srsDimension	29511669	\N	75	srsDimension	srsDimension	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
17	https://ruian.linked.opendata.cz/slovník/isknBudovaId	3884026	\N	72	isknBudovaId	isknBudovaId	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
19	https://ruian.linked.opendata.cz/slovník/způsobVytápění	2280690	\N	72	způsobVytápění	způsobVytápění	f	2280690	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://www.w3.org/2002/07/owl#equivalentClass	5	\N	7	equivalentClass	equivalentClass	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://www.w3.org/ns/dcat#dataset	1	\N	15	dataset	dataset	f	1	\N	\N	f	f	9	53	\N	t	f	\N	\N	\N	t	f	f
22	https://ruian.linked.opendata.cz/slovník/ulice	1487735	\N	72	ulice	ulice	f	1487735	\N	\N	f	f	17	33	\N	t	f	\N	\N	\N	t	f	f
23	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	38	29	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/ns/dcat#keyword	6	\N	15	keyword	keyword	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://schema.org/endDate	1	\N	9	endDate	endDate	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://schema.org/description	2	\N	9	description	description	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://purl.org/dc/terms/type	4	\N	5	type	type	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	https://ruian.linked.opendata.cz/slovník/připojeníPlyn	2278026	\N	72	připojeníPlyn	připojeníPlyn	f	2278026	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://xmlns.com/foaf/0.1/homepage	1	\N	8	homepage	homepage	f	1	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	\N	\N	f	f	75	50	\N	t	f	\N	\N	\N	t	f	f
39	https://ruian.linked.opendata.cz/slovníky/zemedelskaKultura	11	\N	77	zemedelskaKultura	zemedelskaKultura	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
40	https://ruian.linked.opendata.cz/slovník/početPodlaží	2221589	\N	72	početPodlaží	početPodlaží	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
41	https://ruian.linked.opendata.cz/slovník/existujeDigitálníMapa	13091	\N	72	existujeDigitálníMapa	existujeDigitálníMapa	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
42	https://ruian.linked.opendata.cz/slovník/pododdeleniCisla	14574694	\N	72	pododdeleniCisla	pododdeleniCisla	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
43	https://ruian.linked.opendata.cz/slovník/řízeníId	37296444	\N	72	řízeníId	řízeníId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	https://ruian.linked.opendata.cz/slovník/kraj1960	77	\N	72	kraj1960	kraj1960	f	77	\N	\N	f	f	21	8	\N	t	f	\N	\N	\N	t	f	f
46	http://www.w3.org/ns/dcat#landingPage	2	\N	15	landingPage	landingPage	f	2	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://purl.org/dc/terms/modified	1193	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	https://ruian.linked.opendata.cz/slovník/adresníBod	2837194	\N	72	adresníBod	adresníBod	f	2837194	\N	\N	f	f	17	40	\N	t	f	\N	\N	\N	t	f	f
51	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	46	\N	2	subPropertyOf	subPropertyOf	f	46	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://www.w3.org/2002/07/owl#sameAs	2	\N	7	sameAs	sameAs	f	2	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/2004/02/skos/core#notation	29652892	\N	4	notation	notation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	https://ruian.linked.opendata.cz/slovník/orp	393	\N	72	orp	orp	f	393	\N	\N	f	f	43	70	\N	t	f	\N	\N	\N	t	f	f
55	https://ruian.linked.opendata.cz/slovník/částObce	2829101	\N	72	částObce	částObce	f	2829101	\N	\N	f	f	5	42	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	6	\N	1	first	first	f	6	\N	\N	f	f	\N	86	\N	t	f	\N	\N	\N	t	f	f
60	http://purl.org/dc/terms/language	2	\N	5	language	language	f	2	\N	\N	f	f	\N	69	\N	t	f	\N	\N	\N	t	f	f
61	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	50	38	\N	t	f	\N	\N	\N	t	f	f
62	http://purl.org/dc/terms/format	1	\N	5	format	format	f	1	\N	\N	f	f	35	34	\N	t	f	\N	\N	\N	t	f	f
64	https://ruian.linked.opendata.cz/slovník/způsobVyužití	3959928	\N	72	způsobVyužití	způsobVyužití	f	3959928	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
65	https://ruian.linked.opendata.cz/slovník/způsobyVyužitíPozemku	6169533	\N	72	způsobyVyužitíPozemku	způsobyVyužitíPozemku	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/dc/terms/extent	1151	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://www.w3.org/2000/01/rdf-schema#label	342	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://purl.org/dc/terms/title	4	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.w3.org/2004/02/skos/core#prefLabel	3598	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	22	\N	73	EMAIL	EMAIL	f	22	\N	\N	f	f	\N	48	\N	t	f	\N	\N	\N	t	f	f
76	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	44	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://schema.org/url	2	\N	9	url	url	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
84	https://ruian.linked.opendata.cz/slovník/identifikačníParcela	3978381	\N	72	identifikačníParcela	identifikačníParcela	f	3978381	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
87	https://ruian.linked.opendata.cz/slovníky/stavebniParcela	11	\N	77	stavebniParcela	stavebniParcela	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
88	https://ruian.linked.opendata.cz/slovník/kmenoveCislo	22551940	\N	72	kmenoveCislo	kmenoveCislo	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
89	https://ruian.linked.opendata.cz/slovník/platíOd	29649314	\N	72	platíOd	platíOd	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	38	81	\N	t	f	\N	\N	\N	t	f	f
93	https://ruian.linked.opendata.cz/slovník/znakText	4351	\N	72	znakText	znakText	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://schema.org/longitude	29511669	\N	9	longitude	longitude	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
97	https://ruian.linked.opendata.cz/slovník/vlajkaText	4745	\N	72	vlajkaText	vlajkaText	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://www.w3.org/ns/dcat#accessURL	1	\N	15	accessURL	accessURL	f	1	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
101	https://ruian.linked.opendata.cz/slovník/obestavěnýProstor	319483	\N	72	obestavěnýProstor	obestavěnýProstor	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
102	https://ruian.linked.opendata.cz/slovník/nesprávný	164	\N	72	nesprávný	nesprávný	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
109	https://ruian.linked.opendata.cz/slovník/bodHasičů	39406	\N	72	bodHasičů	bodHasičů	f	39406	\N	\N	f	f	17	40	\N	t	f	\N	\N	\N	t	f	f
110	http://www.openlinksw.com/schemas/VSPX#type	1	\N	76	type	type	f	0	\N	\N	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://www.opengis.net/ont/gml#srsName	29511669	\N	75	srsName	srsName	f	29511669	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://www.w3.org/2006/vcard/ns#hasEmail	1	\N	39	hasEmail	hasEmail	f	0	\N	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://www.w3.org/2002/07/owl#complementOf	4	\N	7	complementOf	complementOf	f	4	\N	\N	f	f	86	86	\N	t	f	\N	\N	\N	t	f	f
115	https://ruian.linked.opendata.cz/slovník/katastralni-uzemi	22551940	\N	72	katastralni-uzemi	katastralni-uzemi	f	22551940	\N	\N	f	f	19	4	\N	t	f	\N	\N	\N	t	f	f
116	http://www.opengis.net/ont/geosparql#asGML	29511557	\N	25	asGML	asGML	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://www.w3.org/2004/02/skos/core#related	70	\N	4	related	related	f	70	\N	\N	f	f	47	47	\N	t	f	\N	\N	\N	t	f	f
118	https://ruian.linked.opendata.cz/slovník/pád5	244	\N	72	pád5	pád5	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
119	https://ruian.linked.opendata.cz/slovník/pou	6258	\N	72	pou	pou	f	6258	\N	\N	f	f	76	43	\N	t	f	\N	\N	\N	t	f	f
120	https://ruian.linked.opendata.cz/slovník/pád6	34585	\N	72	pád6	pád6	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
121	https://ruian.linked.opendata.cz/slovník/pád3	34585	\N	72	pád3	pád3	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
122	https://ruian.linked.opendata.cz/slovník/pád4	34584	\N	72	pád4	pád4	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
123	https://ruian.linked.opendata.cz/slovník/pád2	34585	\N	72	pád2	pád2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
125	https://ruian.linked.opendata.cz/slovník/nuts	23	\N	72	nuts	nuts	f	23	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
130	https://ruian.linked.opendata.cz/slovník/pád7	34585	\N	72	pád7	pád7	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://www.w3.org/2000/01/rdf-schema#comment	57	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://schema.org/dataset	1	\N	9	dataset	dataset	f	1	\N	\N	f	f	9	53	\N	t	f	\N	\N	\N	t	f	f
135	https://ruian.linked.opendata.cz/slovník/kódZpůsobuOchrany	16507430	\N	72	kódZpůsobuOchrany	kódZpůsobuOchrany	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
136	https://ruian.linked.opendata.cz/slovník/správníObvod	57	\N	72	správníObvod	správníObvod	f	57	\N	\N	f	f	24	7	\N	t	f	\N	\N	\N	t	f	f
138	https://ruian.linked.opendata.cz/slovník/druhPozemku	22551940	\N	72	druhPozemku	druhPozemku	f	22551940	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
139	https://ruian.linked.opendata.cz/slovník/vúsc	283	\N	72	vúsc	vúsc	f	283	\N	\N	f	f	\N	63	\N	t	f	\N	\N	\N	t	f	f
140	http://www.w3.org/2000/01/rdf-schema#domain	304	\N	2	domain	domain	f	304	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
144	https://ruian.linked.opendata.cz/slovník/podlahováPlocha	262206	\N	72	podlahováPlocha	podlahováPlocha	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
145	https://ruian.linked.opendata.cz/slovník/okres	6258	\N	72	okres	okres	f	6258	\N	\N	f	f	76	21	\N	t	f	\N	\N	\N	t	f	f
146	http://www.w3.org/ns/dcat#theme	1	\N	15	theme	theme	f	1	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://schema.org/fileFormat	1	\N	9	fileFormat	fileFormat	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://schema.org/startDate	1	\N	9	startDate	startDate	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://www.w3.org/2004/02/skos/core#altLabel	161	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://schema.org/keywords	6	\N	9	keywords	keywords	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
155	https://ruian.linked.opendata.cz/slovník/způsobOchranyPozemku	13916081	\N	72	způsobOchranyPozemku	způsobOchranyPozemku	f	13916081	\N	\N	f	f	19	41	\N	t	f	\N	\N	\N	t	f	f
156	https://ruian.linked.opendata.cz/slovník/stavebníObjekt	2900397	\N	72	stavebníObjekt	stavebníObjekt	f	2900397	\N	\N	f	f	17	5	\N	t	f	\N	\N	\N	t	f	f
158	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	6	\N	1	rest	rest	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://www.opengis.net/ont/gml#id	59160983	\N	75	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://www.w3.org/ns/dcat#contactPoint	1	\N	15	contactPoint	contactPoint	f	1	\N	\N	f	f	53	72	\N	t	f	\N	\N	\N	t	f	f
161	https://ruian.linked.opendata.cz/slovník/druhČíslování	22551940	\N	72	druhČíslování	druhČíslování	f	22551940	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
162	https://ruian.linked.opendata.cz/slovník/výměraParcely	22551940	\N	72	výměraParcely	výměraParcely	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://www.w3.org/2004/02/skos/core#narrowerTransitive	27	\N	4	narrowerTransitive	narrowerTransitive	f	27	\N	\N	f	f	47	47	\N	t	f	\N	\N	\N	t	f	f
167	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	10	\N	2	isDefinedBy	isDefinedBy	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	https://ruian.linked.opendata.cz/slovník/stát	16	\N	72	stát	stát	f	16	\N	\N	f	f	56	62	\N	t	f	\N	\N	\N	t	f	f
170	http://www.w3.org/2001/vcard-rdf/3.0#Street	22	\N	73	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
172	https://ruian.linked.opendata.cz/slovník/bodZáchranky	37741	\N	72	bodZáchranky	bodZáchranky	f	37741	\N	\N	f	f	17	40	\N	t	f	\N	\N	\N	t	f	f
175	https://ruian.linked.opendata.cz/slovník/dokončení	433811	\N	72	dokončení	dokončení	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://www.w3.org/2001/vcard-rdf/3.0#ADR	22	\N	73	ADR	ADR	f	22	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://www.w3.org/2002/07/owl#unionOf	3	\N	7	unionOf	unionOf	f	3	\N	\N	f	f	86	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	37	37	\N	t	f	\N	\N	\N	t	f	f
181	http://www.w3.org/ns/dcat#mediaType	1	\N	15	mediaType	mediaType	f	1	\N	\N	f	f	35	34	\N	t	f	\N	\N	\N	t	f	f
182	https://ruian.linked.opendata.cz/slovník/čísloDomovní	5772759	\N	72	čísloDomovní	čísloDomovní	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	\N	\N	f	f	81	51	\N	t	f	\N	\N	\N	t	f	f
187	https://ruian.linked.opendata.cz/slovník/připojeníKanalizace	2297060	\N	72	připojeníKanalizace	připojeníKanalizace	f	2297060	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://schema.org/latitude	29511669	\N	9	latitude	latitude	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://schema.org/contentUrl	1	\N	9	contentUrl	contentUrl	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
190	https://ruian.linked.opendata.cz/slovník/idTransakce	44231998	\N	72	idTransakce	idTransakce	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://www.w3.org/2004/02/skos/core#hasTopConcept	1	\N	4	hasTopConcept	hasTopConcept	f	1	\N	\N	f	f	97	47	\N	t	f	\N	\N	\N	t	f	f
193	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://www.openlinksw.com/schemas/DAV#ownerUser	1191	\N	18	ownerUser	ownerUser	f	1191	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
195	https://ruian.linked.opendata.cz/slovník/vybaveníVýtahem	2335473	\N	72	vybaveníVýtahem	vybaveníVýtahem	f	2335473	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	38	80	\N	t	f	\N	\N	\N	t	f	f
199	http://schema.org/name	29649317	\N	9	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
200	https://ruian.linked.opendata.cz/slovník/zastavěnáPlocha	370446	\N	72	zastavěnáPlocha	zastavěnáPlocha	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://www.openlinksw.com/schemas/VSPX#pageId	1	\N	76	pageId	pageId	f	0	\N	\N	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
204	https://ruian.linked.opendata.cz/slovníky/povinnyZpusobVyuziti	11	\N	77	povinnyZpusobVyuziti	povinnyZpusobVyuziti	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://purl.org/dc/terms/temporal	1	\N	5	temporal	temporal	f	1	\N	\N	f	f	53	94	\N	t	f	\N	\N	\N	t	f	f
206	https://ruian.linked.opendata.cz/slovník/charakterZsj	22501	\N	72	charakterZsj	charakterZsj	f	22501	\N	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://www.w3.org/2004/02/skos/core#topConceptOf	1	\N	4	topConceptOf	topConceptOf	f	1	\N	\N	f	f	47	97	\N	t	f	\N	\N	\N	t	f	f
210	http://purl.org/dc/terms/identifier	1	\N	5	identifier	identifier	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
211	https://ruian.linked.opendata.cz/slovník/čísloOrientační	516897	\N	72	čísloOrientační	čísloOrientační	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://schema.org/geo	29511669	\N	9	geo	geo	f	29511669	\N	\N	f	f	40	46	\N	t	f	\N	\N	\N	t	f	f
214	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://schema.org/distribution	1	\N	9	distribution	distribution	f	1	\N	\N	f	f	53	35	\N	t	f	\N	\N	\N	t	f	f
216	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://purl.org/dc/terms/issued	2	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
220	https://ruian.linked.opendata.cz/slovník/čísloOrientačníPísmeno	24526	\N	72	čísloOrientačníPísmeno	čísloOrientačníPísmeno	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://www.opengis.net/ont/gml#pos	29511669	\N	75	pos	pos	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
224	https://ruian.linked.opendata.cz/slovník/vOKód	2837194	\N	72	vOKód	vOKód	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
225	https://ruian.linked.opendata.cz/slovník/výměra	22501	\N	72	výměra	výměra	f	0	\N	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://www.opengis.net/ont/gml#pointMember	41854	\N	75	pointMember	pointMember	f	41854	\N	\N	f	f	32	40	\N	t	f	\N	\N	\N	t	f	f
228	https://ruian.linked.opendata.cz/slovník/definičníBod	26597324	\N	72	definičníBod	definičníBod	f	26597324	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://purl.org/dc/terms/accessRights	1	\N	5	accessRights	accessRights	f	1	\N	\N	f	f	53	83	\N	t	f	\N	\N	\N	t	f	f
232	http://www.openlinksw.com/schemas/VSPX#title	1	\N	76	title	title	f	0	\N	\N	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://purl.org/dc/terms/description	2	\N	5	description	description	f	0	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://www.w3.org/2004/02/skos/core#inScheme	3597	\N	4	inScheme	inScheme	f	3597	\N	\N	f	f	47	97	\N	t	f	\N	\N	\N	t	f	f
236	https://ruian.linked.opendata.cz/slovník/členěníSMTyp	8	\N	72	členěníSMTyp	členěníSMTyp	f	8	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
239	https://ruian.linked.opendata.cz/slovník/regionSoudržnosti	14	\N	72	regionSoudržnosti	regionSoudržnosti	f	14	\N	\N	f	f	63	26	\N	t	f	\N	\N	\N	t	f	f
240	http://www.w3.org/2000/01/rdf-schema#subClassOf	52	\N	2	subClassOf	subClassOf	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
241	https://ruian.linked.opendata.cz/slovník/správníObecKód	393	\N	72	správníObecKód	správníObecKód	f	0	\N	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
242	https://ruian.linked.opendata.cz/slovník/lau	6335	\N	72	lau	lau	f	6335	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
244	https://ruian.linked.opendata.cz/slovník/členěníSMRozsah	8	\N	72	členěníSMRozsah	členěníSMRozsah	f	8	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://www.w3.org/2000/01/rdf-schema#range	230	\N	2	range	range	f	230	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://www.w3.org/2002/07/owl#equivalentProperty	3	\N	7	equivalentProperty	equivalentProperty	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://www.w3.org/ns/adms#status	1	\N	70	status	status	f	1	\N	\N	f	f	35	47	\N	t	f	\N	\N	\N	t	f	f
249	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	22	\N	73	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://purl.org/dc/terms/publisher	1	\N	5	publisher	publisher	f	1	\N	\N	f	f	53	82	\N	t	f	\N	\N	\N	t	f	f
252	https://ruian.linked.opendata.cz/slovník/typStavebníhoObjektu	4056890	\N	72	typStavebníhoObjektu	typStavebníhoObjektu	f	4056890	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
254	https://ruian.linked.opendata.cz/slovník/katastrálníÚzemí	22501	\N	72	katastrálníÚzemí	katastrálníÚzemí	f	22501	\N	\N	f	f	57	4	\N	t	f	\N	\N	\N	t	f	f
255	http://schema.org/includedInDataCatalog	1	\N	9	includedInDataCatalog	includedInDataCatalog	f	1	\N	\N	f	f	53	9	\N	t	f	\N	\N	\N	t	f	f
256	http://www.w3.org/2001/vcard-rdf/3.0#Country	22	\N	73	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://www.w3.org/2000/01/rdf-schema#seeAlso	5	\N	2	seeAlso	seeAlso	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://www.w3.org/2002/07/owl#imports	2	\N	7	imports	imports	f	2	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
261	http://www.w3.org/2001/vcard-rdf/3.0#City	22	\N	73	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://www.w3.org/2004/02/skos/core#broaderTransitive	24	\N	4	broaderTransitive	broaderTransitive	f	24	\N	\N	f	f	47	47	\N	t	f	\N	\N	\N	t	f	f
264	http://schema.org/creator	1	\N	9	creator	creator	f	1	\N	\N	f	f	53	82	\N	t	f	\N	\N	\N	t	f	f
267	https://ruian.linked.opendata.cz/slovník/způsobOchrany	498685	\N	72	způsobOchrany	způsobOchrany	f	498685	\N	\N	f	f	5	41	\N	t	f	\N	\N	\N	t	f	f
259	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	165117829	\N	1	type	type	f	165117829	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
274	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
276	https://ruian.linked.opendata.cz/slovník/psč	2900397	\N	72	psč	psč	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
279	https://ruian.linked.opendata.cz/slovník/status	6258	\N	72	status	status	f	6258	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://www.w3.org/2001/vcard-rdf/3.0#TEL	22	\N	73	TEL	TEL	f	22	\N	\N	f	f	\N	10	\N	t	f	\N	\N	\N	t	f	f
282	http://purl.org/dc/terms/license	1	\N	5	license	license	f	1	\N	\N	f	f	35	64	\N	t	f	\N	\N	\N	t	f	f
283	https://ruian.linked.opendata.cz/slovník/druhKonstrukce	2233565	\N	72	druhKonstrukce	druhKonstrukce	f	2233565	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://purl.org/dc/terms/accrualPeriodicity	1	\N	5	accrualPeriodicity	accrualPeriodicity	f	1	\N	\N	f	f	53	23	\N	t	f	\N	\N	\N	t	f	f
287	https://ruian.linked.opendata.cz/slovník/typOchranyKód	16348400	\N	72	typOchranyKód	typOchranyKód	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/ns/dcat#distribution	1	\N	15	distribution	distribution	f	1	\N	\N	f	f	53	35	\N	t	f	\N	\N	\N	t	f	f
289	http://purl.org/dc/terms/created	1191	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	https://ruian.linked.opendata.cz/slovník/obec	110621	\N	72	obec	obec	f	110621	\N	\N	f	f	\N	76	\N	t	f	\N	\N	\N	t	f	f
291	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	37	37	\N	t	f	\N	\N	\N	t	f	f
270	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

COPY https_ruian_linked_opendata_cz_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	20	8	equivalentClass	\N
2	29	8	priorVersion	\N
3	52	8	sameAs	\N
4	113	8	complementOf	\N
5	179	8	unionOf	\N
6	183	8	versionInfo	\N
7	246	8	equivalentProperty	\N
8	260	8	imports	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cc_rels_id_seq', 44, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.class_annots_id_seq', 4, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.classes_id_seq', 98, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cp_rels_id_seq', 1114, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cpc_rels_id_seq', 782, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.ns_id_seq', 77, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.properties_id_seq', 291, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

SELECT pg_catalog.setval('https_ruian_linked_opendata_cz_sparql.property_annots_id_seq', 8, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON https_ruian_linked_opendata_cz_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON https_ruian_linked_opendata_cz_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON https_ruian_linked_opendata_cz_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON https_ruian_linked_opendata_cz_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON https_ruian_linked_opendata_cz_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON https_ruian_linked_opendata_cz_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON https_ruian_linked_opendata_cz_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON https_ruian_linked_opendata_cz_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON https_ruian_linked_opendata_cz_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON https_ruian_linked_opendata_cz_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON https_ruian_linked_opendata_cz_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON https_ruian_linked_opendata_cz_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON https_ruian_linked_opendata_cz_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON https_ruian_linked_opendata_cz_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON https_ruian_linked_opendata_cz_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON https_ruian_linked_opendata_cz_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON https_ruian_linked_opendata_cz_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON https_ruian_linked_opendata_cz_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON https_ruian_linked_opendata_cz_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON https_ruian_linked_opendata_cz_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON https_ruian_linked_opendata_cz_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON https_ruian_linked_opendata_cz_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON https_ruian_linked_opendata_cz_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON https_ruian_linked_opendata_cz_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON https_ruian_linked_opendata_cz_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON https_ruian_linked_opendata_cz_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES https_ruian_linked_opendata_cz_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_ruian_linked_opendata_cz_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_ruian_linked_opendata_cz_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_ruian_linked_opendata_cz_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_ruian_linked_opendata_cz_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_ruian_linked_opendata_cz_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_ruian_linked_opendata_cz_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_ruian_linked_opendata_cz_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_ruian_linked_opendata_cz_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_ruian_linked_opendata_cz_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_ruian_linked_opendata_cz_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES https_ruian_linked_opendata_cz_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_ruian_linked_opendata_cz_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_ruian_linked_opendata_cz_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES https_ruian_linked_opendata_cz_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES https_ruian_linked_opendata_cz_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_ruian_linked_opendata_cz_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES https_ruian_linked_opendata_cz_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES https_ruian_linked_opendata_cz_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES https_ruian_linked_opendata_cz_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: https_ruian_linked_opendata_cz_sparql; Owner: -
--

ALTER TABLE ONLY https_ruian_linked_opendata_cz_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_ruian_linked_opendata_cz_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

