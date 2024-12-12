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
-- Name: http_data_bnf_fr_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_data_bnf_fr_sparql;


--
-- Name: SCHEMA http_data_bnf_fr_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_data_bnf_fr_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE FUNCTION http_data_bnf_fr_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE FUNCTION http_data_bnf_fr_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_data_bnf_fr_sparql; Owner: -
--

COMMENT ON TABLE http_data_bnf_fr_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_data_bnf_fr_sparql; Owner: -
--

COMMENT ON COLUMN http_data_bnf_fr_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_data_bnf_fr_sparql.classes c1
     JOIN http_data_bnf_fr_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_data_bnf_fr_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_data_bnf_fr_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_data_bnf_fr_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE TABLE http_data_bnf_fr_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE http_data_bnf_fr_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_bnf_fr_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_cc_rels AS
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
   FROM http_data_bnf_fr_sparql.cc_rels r,
    http_data_bnf_fr_sparql.classes c1,
    http_data_bnf_fr_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_classes_ns AS
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
    http_data_bnf_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_data_bnf_fr_sparql.classes c
     LEFT JOIN http_data_bnf_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_classes_ns_main AS
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
   FROM http_data_bnf_fr_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_data_bnf_fr_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_classes_ns_plus AS
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
    http_data_bnf_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_data_bnf_fr_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_data_bnf_fr_sparql.classes c
     LEFT JOIN http_data_bnf_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_classes_ns_main_plus AS
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
   FROM http_data_bnf_fr_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_data_bnf_fr_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_data_bnf_fr_sparql.v_classes_ns v
     LEFT JOIN http_data_bnf_fr_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_cp_rels AS
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
    http_data_bnf_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_data_bnf_fr_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_data_bnf_fr_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_data_bnf_fr_sparql.cp_rels r,
    http_data_bnf_fr_sparql.classes c,
    http_data_bnf_fr_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_cp_rels_card AS
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
   FROM http_data_bnf_fr_sparql.cp_rels r,
    http_data_bnf_fr_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_properties_ns AS
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
    http_data_bnf_fr_sparql.tapprox(p.cnt) AS cnt_x,
    http_data_bnf_fr_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_data_bnf_fr_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_data_bnf_fr_sparql.properties p
     LEFT JOIN http_data_bnf_fr_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_cp_sources_single AS
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
   FROM ((http_data_bnf_fr_sparql.v_cp_rels_card r
     JOIN http_data_bnf_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_data_bnf_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_cp_targets_single AS
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
   FROM ((http_data_bnf_fr_sparql.v_cp_rels_card r
     JOIN http_data_bnf_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_data_bnf_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_data_bnf_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_data_bnf_fr_sparql.pp_rels r,
    http_data_bnf_fr_sparql.properties p1,
    http_data_bnf_fr_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_properties_sources AS
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
   FROM (http_data_bnf_fr_sparql.v_properties_ns v
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
           FROM http_data_bnf_fr_sparql.cp_rels r,
            http_data_bnf_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_properties_sources_single AS
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
   FROM (http_data_bnf_fr_sparql.v_properties_ns v
     LEFT JOIN http_data_bnf_fr_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_properties_targets AS
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
   FROM (http_data_bnf_fr_sparql.v_properties_ns v
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
           FROM http_data_bnf_fr_sparql.cp_rels r,
            http_data_bnf_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE VIEW http_data_bnf_fr_sparql.v_properties_targets_single AS
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
   FROM (http_data_bnf_fr_sparql.v_properties_ns v
     LEFT JOIN http_data_bnf_fr_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
9	skos:prefLabel	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	4	3	1	\N	\N
2	5	21	1	\N	\N
3	7	1	1	\N	\N
4	15	9	1	\N	\N
5	16	10	1	\N	\N
6	23	25	1	\N	\N
7	24	19	1	\N	\N
8	25	15	1	\N	\N
9	26	15	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	14	8	AnnotationProperty	\N
2	16	8	OntologyProperty	\N
3	18	8	Ontology	\N
4	20	8	Class	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://xmlns.com/foaf/0.1/Document	5702	\N	t	8	Document	Document	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30
2	http://www.w3.org/2004/02/skos/core#Concept	20742426	\N	t	4	Concept	Concept	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29435994
3	http://www.w3.org/2004/02/skos/core#Collection	3	\N	t	4	Collection	Collection	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18089
4	http://purl.org/iso25964/skos-thes#ConceptGroup	3	\N	t	74	ConceptGroup	ConceptGroup	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18089
5	http://rdaregistry.info/Elements/c/#C10007	13063699	\N	t	75	C10007	C10007	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13070121
6	http://xmlns.com/foaf/0.1/Person	4393839	\N	t	8	Person	Person	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60821789
7	http://data.bnf.fr/ontology/bnf-onto/ExpositionVirtuelle	5167	\N	t	76	ExpositionVirtuelle	ExpositionVirtuelle	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
9	http://rdvocab.info/uri/schema/FRBRentitiesRDA/Work	2530649	\N	t	77	Work	Work	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9342142
10	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	65	\N	t	1	Property	Property	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
11	http://www.w3.org/2003/01/geo/wgs84_pos#SpatialThing	120500	\N	t	25	SpatialThing	SpatialThing	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	133243
12	http://www.w3.org/TR/owl-time/Instant	2698	\N	t	78	Instant	Instant	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29569345
13	http://www.w3.org/2000/01/rdf-schema#Class	15	\N	t	2	Class	Class	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43
14	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
15	http://rdaregistry.info/Elements/c/#C10001	2530649	\N	t	75	C10001	C10001	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9342142
16	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://xmlns.com/foaf/0.1/Organization	430832	\N	t	8	Organization	Organization	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13402947
18	http://www.w3.org/2002/07/owl#Ontology	1	\N	t	7	Ontology	Ontology	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
19	http://rdvocab.info/uri/schema/FRBRentitiesRDA/Expression	13063699	\N	t	77	Expression	Expression	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31536276
20	http://www.w3.org/2002/07/owl#Class	3	\N	t	7	Class	Class	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
21	http://rdvocab.info/uri/schema/FRBRentitiesRDA/Manifestation	13063699	\N	t	77	Manifestation	Manifestation	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13070121
22	http://www.w3.org/2004/02/skos/core#ConceptScheme	1	\N	t	4	ConceptScheme	ConceptScheme	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	http://purl.org/dc/dcmitype/InteractiveResource	16305	\N	t	72	InteractiveResource	InteractiveResource	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26847
24	http://rdaregistry.info/Elements/c/#C10006	13063699	\N	t	75	C10006	C10006	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31536276
25	http://purl.org/ontology/bibo/Periodical	515304	\N	t	31	Periodical	Periodical	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	567592
26	http://purl.org/dc/dcmitype/Event	62245	\N	t	72	Event	Event	607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	277231
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	6	1	2	4133135	\N	0	\N	\N	1	1	2	f	4133135	\N	\N
2	17	1	2	430832	\N	0	\N	\N	2	1	2	f	430832	\N	\N
3	6	2	2	4393839	\N	4393839	\N	\N	1	1	2	f	0	\N	\N
4	2	2	2	2172632	\N	2172632	\N	\N	2	1	2	f	0	\N	\N
5	17	2	2	430832	\N	430832	\N	\N	3	1	2	f	0	\N	\N
6	11	2	2	101030	\N	101030	\N	\N	4	1	2	f	0	\N	\N
7	26	2	2	62245	\N	62245	\N	\N	5	1	2	f	0	\N	\N
8	12	2	2	2698	\N	2698	\N	\N	6	1	2	f	0	\N	\N
9	9	2	2	62245	\N	62245	\N	\N	0	1	2	f	0	\N	\N
10	15	2	2	62245	\N	62245	\N	\N	0	1	2	f	0	\N	\N
11	2	2	1	1647531	\N	1647531	\N	\N	1	1	2	f	\N	\N	\N
12	12	2	1	2698	\N	2698	\N	\N	2	1	2	f	\N	\N	\N
13	2	3	2	2364938	\N	0	\N	\N	1	1	2	f	2364938	\N	\N
14	10	3	2	35	\N	0	\N	\N	2	1	2	f	35	\N	\N
15	26	4	2	575	\N	575	\N	\N	1	1	2	f	0	\N	\N
16	24	4	2	146	\N	146	\N	\N	2	1	2	f	0	\N	\N
17	9	4	2	575	\N	575	\N	\N	0	1	2	f	0	\N	\N
18	15	4	2	575	\N	575	\N	\N	0	1	2	f	0	\N	\N
19	19	4	2	146	\N	146	\N	\N	0	1	2	f	0	\N	\N
20	6	4	1	716	\N	716	\N	\N	1	1	2	f	\N	\N	\N
21	17	4	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
22	24	5	2	544	\N	544	\N	\N	1	1	2	f	0	\N	\N
23	9	5	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
24	19	5	2	544	\N	544	\N	\N	0	1	2	f	0	\N	\N
25	15	5	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
26	25	5	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
27	26	5	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
28	6	5	1	552	\N	552	\N	\N	1	1	2	f	\N	\N	\N
29	17	5	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
30	2	6	2	3834	\N	0	\N	\N	1	1	2	f	3834	\N	\N
31	24	7	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
32	19	7	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
33	6	7	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
34	24	8	2	9602	\N	9602	\N	\N	1	1	2	f	0	\N	\N
35	26	8	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
36	19	8	2	9602	\N	9602	\N	\N	0	1	2	f	0	\N	\N
37	9	8	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
38	15	8	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
39	6	8	1	7942	\N	7942	\N	\N	1	1	2	f	\N	\N	\N
40	17	8	1	1662	\N	1662	\N	\N	2	1	2	f	\N	\N	\N
41	6	9	2	1844998	\N	0	\N	\N	1	1	2	f	1844998	\N	\N
42	24	10	2	82	\N	82	\N	\N	1	1	2	f	0	\N	\N
43	19	10	2	82	\N	82	\N	\N	0	1	2	f	0	\N	\N
44	6	10	1	82	\N	82	\N	\N	1	1	2	f	\N	\N	\N
45	24	11	2	736	\N	736	\N	\N	1	1	2	f	0	\N	\N
46	9	11	2	40	\N	40	\N	\N	2	1	2	f	0	\N	\N
47	19	11	2	736	\N	736	\N	\N	0	1	2	f	0	\N	\N
48	15	11	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
49	25	11	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
50	26	11	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
51	23	11	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
52	6	11	1	677	\N	677	\N	\N	1	1	2	f	\N	\N	\N
53	17	11	1	99	\N	99	\N	\N	2	1	2	f	\N	\N	\N
54	6	12	2	513186	\N	0	\N	\N	1	1	2	f	513186	\N	\N
55	24	13	2	353	\N	353	\N	\N	1	1	2	f	0	\N	\N
56	26	13	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
57	19	13	2	353	\N	353	\N	\N	0	1	2	f	0	\N	\N
58	9	13	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
59	15	13	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
60	6	13	1	354	\N	354	\N	\N	1	1	2	f	\N	\N	\N
61	17	13	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
62	21	14	2	253617	\N	253617	\N	\N	1	1	2	f	0	\N	\N
63	5	14	2	253617	\N	253617	\N	\N	0	1	2	f	0	\N	\N
64	18	15	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
65	19	16	2	10173	\N	10173	\N	\N	1	1	2	f	0	\N	\N
66	26	16	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
67	24	16	2	10173	\N	10173	\N	\N	0	1	2	f	0	\N	\N
68	9	16	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
69	15	16	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
70	6	16	1	9679	\N	9679	\N	\N	1	1	2	f	\N	\N	\N
71	17	16	1	495	\N	495	\N	\N	2	1	2	f	\N	\N	\N
72	21	17	2	1441897	\N	1441897	\N	\N	1	1	2	f	0	\N	\N
73	25	17	2	20505	\N	20505	\N	\N	2	1	2	f	0	\N	\N
74	5	17	2	1441897	\N	1441897	\N	\N	0	1	2	f	0	\N	\N
75	9	17	2	20505	\N	20505	\N	\N	0	1	2	f	0	\N	\N
76	15	17	2	20505	\N	20505	\N	\N	0	1	2	f	0	\N	\N
77	19	18	2	290	\N	290	\N	\N	1	1	2	f	0	\N	\N
78	26	18	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
79	24	18	2	290	\N	290	\N	\N	0	1	2	f	0	\N	\N
80	9	18	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
81	15	18	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
82	6	18	1	292	\N	292	\N	\N	1	1	2	f	\N	\N	\N
83	17	19	2	76688	\N	76688	\N	\N	1	1	2	f	0	\N	\N
84	6	19	2	30225	\N	30225	\N	\N	2	1	2	f	0	\N	\N
85	23	19	2	20064	\N	20064	\N	\N	3	1	2	f	0	\N	\N
86	9	19	2	20064	\N	20064	\N	\N	0	1	2	f	0	\N	\N
87	15	19	2	20064	\N	20064	\N	\N	0	1	2	f	0	\N	\N
88	25	19	2	20064	\N	20064	\N	\N	0	1	2	f	0	\N	\N
89	1	19	1	30	\N	30	\N	\N	1	1	2	f	\N	\N	\N
90	24	20	2	4183	\N	4183	\N	\N	1	1	2	f	0	\N	\N
91	19	20	2	4183	\N	4183	\N	\N	0	1	2	f	0	\N	\N
92	6	20	1	4166	\N	4166	\N	\N	1	1	2	f	\N	\N	\N
93	17	20	1	17	\N	17	\N	\N	2	1	2	f	\N	\N	\N
94	24	21	2	30503	\N	30503	\N	\N	1	1	2	f	0	\N	\N
95	9	21	2	8692	\N	8692	\N	\N	2	1	2	f	0	\N	\N
96	19	21	2	30503	\N	30503	\N	\N	0	1	2	f	0	\N	\N
97	15	21	2	8692	\N	8692	\N	\N	0	1	2	f	0	\N	\N
98	26	21	2	293	\N	293	\N	\N	0	1	2	f	0	\N	\N
99	25	21	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
100	17	21	1	28911	\N	28911	\N	\N	1	1	2	f	\N	\N	\N
101	6	21	1	10284	\N	10284	\N	\N	2	1	2	f	\N	\N	\N
102	24	22	2	134907	\N	134907	\N	\N	1	1	2	f	0	\N	\N
103	26	22	2	19806	\N	19806	\N	\N	2	1	2	f	0	\N	\N
104	19	22	2	134907	\N	134907	\N	\N	0	1	2	f	0	\N	\N
105	9	22	2	19806	\N	19806	\N	\N	0	1	2	f	0	\N	\N
106	15	22	2	19806	\N	19806	\N	\N	0	1	2	f	0	\N	\N
107	17	22	1	87436	\N	87436	\N	\N	1	1	2	f	\N	\N	\N
108	6	22	1	67277	\N	67277	\N	\N	2	1	2	f	\N	\N	\N
109	26	23	2	4534	\N	4534	\N	\N	1	1	2	f	0	\N	\N
110	24	23	2	1515	\N	1515	\N	\N	2	1	2	f	0	\N	\N
111	9	23	2	4534	\N	4534	\N	\N	0	1	2	f	0	\N	\N
112	15	23	2	4534	\N	4534	\N	\N	0	1	2	f	0	\N	\N
113	19	23	2	1515	\N	1515	\N	\N	0	1	2	f	0	\N	\N
114	6	23	1	5902	\N	5902	\N	\N	1	1	2	f	\N	\N	\N
115	17	23	1	147	\N	147	\N	\N	2	1	2	f	\N	\N	\N
116	24	24	2	15787	\N	15787	\N	\N	1	1	2	f	0	\N	\N
117	26	24	2	23	\N	23	\N	\N	2	1	2	f	0	\N	\N
118	19	24	2	15787	\N	15787	\N	\N	0	1	2	f	0	\N	\N
119	9	24	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
120	15	24	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
121	6	24	1	15778	\N	15778	\N	\N	1	1	2	f	\N	\N	\N
122	17	24	1	32	\N	32	\N	\N	2	1	2	f	\N	\N	\N
123	21	25	2	622411	\N	0	\N	\N	1	1	2	f	622411	\N	\N
124	5	25	2	622411	\N	0	\N	\N	0	1	2	f	622411	\N	\N
125	21	26	2	2399175	\N	0	\N	\N	1	1	2	f	2399175	\N	\N
126	5	26	2	2399175	\N	0	\N	\N	0	1	2	f	2399175	\N	\N
127	21	27	2	2089902	\N	0	\N	\N	1	1	2	f	2089902	\N	\N
128	5	27	2	2089902	\N	0	\N	\N	0	1	2	f	2089902	\N	\N
129	24	28	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
130	19	28	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
131	6	28	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
132	17	28	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
133	24	29	2	387062	\N	387062	\N	\N	1	1	2	f	0	\N	\N
134	9	29	2	18406	\N	18406	\N	\N	2	1	2	f	0	\N	\N
135	19	29	2	387062	\N	387062	\N	\N	0	1	2	f	0	\N	\N
136	15	29	2	18406	\N	18406	\N	\N	0	1	2	f	0	\N	\N
137	26	29	2	18405	\N	18405	\N	\N	0	1	2	f	0	\N	\N
138	25	29	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
139	17	29	1	394188	\N	394188	\N	\N	1	1	2	f	\N	\N	\N
140	6	29	1	11280	\N	11280	\N	\N	2	1	2	f	\N	\N	\N
141	24	30	2	2997	\N	2997	\N	\N	1	1	2	f	0	\N	\N
142	25	30	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
143	19	30	2	2997	\N	2997	\N	\N	0	1	2	f	0	\N	\N
144	9	30	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
145	15	30	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
146	6	30	1	3001	\N	3001	\N	\N	1	1	2	f	\N	\N	\N
147	24	31	2	542	\N	542	\N	\N	1	1	2	f	0	\N	\N
148	26	31	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
149	19	31	2	542	\N	542	\N	\N	0	1	2	f	0	\N	\N
150	9	31	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
151	15	31	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
152	17	31	1	542	\N	542	\N	\N	1	1	2	f	\N	\N	\N
153	6	31	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
154	6	32	2	202028	\N	100828	\N	\N	1	1	2	f	101200	\N	\N
155	24	33	2	697	\N	697	\N	\N	1	1	2	f	0	\N	\N
156	26	33	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
157	19	33	2	697	\N	697	\N	\N	0	1	2	f	0	\N	\N
158	9	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
159	15	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
160	6	33	1	699	\N	699	\N	\N	1	1	2	f	\N	\N	\N
161	17	33	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
162	24	34	2	353	\N	353	\N	\N	1	1	2	f	0	\N	\N
163	26	34	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
164	19	34	2	353	\N	353	\N	\N	0	1	2	f	0	\N	\N
165	9	34	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
166	15	34	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
167	6	34	1	355	\N	355	\N	\N	1	1	2	f	\N	\N	\N
168	6	35	2	1927628	\N	1927628	\N	\N	1	1	2	f	0	\N	\N
169	11	36	2	37751	\N	0	\N	\N	1	1	2	f	37751	\N	\N
170	24	37	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
171	19	37	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
172	17	37	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
173	6	37	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
174	19	38	2	11458	\N	11458	\N	\N	1	1	2	f	0	\N	\N
175	9	38	2	96	\N	96	\N	\N	2	1	2	f	0	\N	\N
176	24	38	2	11458	\N	11458	\N	\N	0	1	2	f	0	\N	\N
177	15	38	2	96	\N	96	\N	\N	0	1	2	f	0	\N	\N
178	25	38	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
179	26	38	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
180	6	38	1	11471	\N	11471	\N	\N	1	1	2	f	\N	\N	\N
181	17	38	1	83	\N	83	\N	\N	2	1	2	f	\N	\N	\N
182	19	39	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
183	24	39	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
184	6	39	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
185	19	40	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
186	24	40	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
187	6	40	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
188	19	41	2	69608	\N	69608	\N	\N	1	1	2	f	0	\N	\N
189	9	41	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
190	24	41	2	69608	\N	69608	\N	\N	0	1	2	f	0	\N	\N
191	15	41	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
192	26	41	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
193	25	41	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
194	6	41	1	69005	\N	69005	\N	\N	1	1	2	f	\N	\N	\N
195	17	41	1	607	\N	607	\N	\N	2	1	2	f	\N	\N	\N
196	20	42	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
197	6	43	2	200678	\N	0	\N	\N	1	1	2	f	200678	\N	\N
198	24	44	2	232383	\N	232383	\N	\N	1	1	2	f	0	\N	\N
199	9	44	2	281	\N	281	\N	\N	2	1	2	f	0	\N	\N
200	19	44	2	232383	\N	232383	\N	\N	0	1	2	f	0	\N	\N
201	15	44	2	281	\N	281	\N	\N	0	1	2	f	0	\N	\N
202	25	44	2	280	\N	280	\N	\N	0	1	2	f	0	\N	\N
203	26	44	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
204	6	44	1	232551	\N	232551	\N	\N	1	1	2	f	\N	\N	\N
205	17	44	1	113	\N	113	\N	\N	2	1	2	f	\N	\N	\N
206	24	45	2	9647	\N	9647	\N	\N	1	1	2	f	0	\N	\N
207	26	45	2	52	\N	52	\N	\N	2	1	2	f	0	\N	\N
208	19	45	2	9647	\N	9647	\N	\N	0	1	2	f	0	\N	\N
209	9	45	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
210	15	45	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
211	6	45	1	9682	\N	9682	\N	\N	1	1	2	f	\N	\N	\N
212	17	45	1	17	\N	17	\N	\N	2	1	2	f	\N	\N	\N
213	6	46	2	1844998	\N	0	\N	\N	1	1	2	f	1844998	\N	\N
214	24	47	2	2356	\N	2356	\N	\N	1	1	2	f	0	\N	\N
215	26	47	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
216	19	47	2	2356	\N	2356	\N	\N	0	1	2	f	0	\N	\N
217	9	47	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
218	15	47	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
219	17	47	1	2360	\N	2360	\N	\N	1	1	2	f	\N	\N	\N
220	6	47	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
221	24	48	2	107737	\N	107737	\N	\N	1	1	2	f	0	\N	\N
222	25	48	2	78	\N	78	\N	\N	2	1	2	f	0	\N	\N
223	19	48	2	107737	\N	107737	\N	\N	0	1	2	f	0	\N	\N
224	9	48	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
225	15	48	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
226	17	48	1	85406	\N	85406	\N	\N	1	1	2	f	\N	\N	\N
227	6	48	1	22409	\N	22409	\N	\N	2	1	2	f	\N	\N	\N
228	24	50	2	9962188	\N	9962188	\N	\N	1	1	2	f	0	\N	\N
229	9	50	2	263217	\N	263217	\N	\N	2	1	2	f	0	\N	\N
230	19	50	2	9962188	\N	9962188	\N	\N	0	1	2	f	0	\N	\N
231	15	50	2	263217	\N	263217	\N	\N	0	1	2	f	0	\N	\N
232	25	50	2	212288	\N	212288	\N	\N	0	1	2	f	0	\N	\N
233	26	50	2	50334	\N	50334	\N	\N	0	1	2	f	0	\N	\N
234	23	50	2	11403	\N	11403	\N	\N	0	1	2	f	0	\N	\N
235	6	50	1	8925435	\N	8925435	\N	\N	1	1	2	f	\N	\N	\N
236	17	50	1	1299970	\N	1299970	\N	\N	2	1	2	f	\N	\N	\N
237	24	51	2	138155	\N	138155	\N	\N	1	1	2	f	0	\N	\N
238	9	51	2	92	\N	92	\N	\N	2	1	2	f	0	\N	\N
239	19	51	2	138155	\N	138155	\N	\N	0	1	2	f	0	\N	\N
240	15	51	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
241	26	51	2	85	\N	85	\N	\N	0	1	2	f	0	\N	\N
242	25	51	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
243	6	51	1	138055	\N	138055	\N	\N	1	1	2	f	\N	\N	\N
244	17	51	1	192	\N	192	\N	\N	2	1	2	f	\N	\N	\N
245	6	52	2	292595	\N	0	\N	\N	1	1	2	f	292595	\N	\N
246	24	53	2	373	\N	373	\N	\N	1	1	2	f	0	\N	\N
247	26	53	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
248	19	53	2	373	\N	373	\N	\N	0	1	2	f	0	\N	\N
249	9	53	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
250	15	53	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
251	6	53	1	374	\N	374	\N	\N	1	1	2	f	\N	\N	\N
252	24	54	2	382	\N	382	\N	\N	1	1	2	f	0	\N	\N
253	26	54	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
254	19	54	2	382	\N	382	\N	\N	0	1	2	f	0	\N	\N
255	9	54	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
256	15	54	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
257	6	54	1	387	\N	387	\N	\N	1	1	2	f	\N	\N	\N
258	24	55	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
259	19	55	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
260	17	55	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
261	24	56	2	61	\N	61	\N	\N	1	1	2	f	0	\N	\N
262	26	56	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
263	19	56	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
264	9	56	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
265	15	56	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
266	17	56	1	61	\N	61	\N	\N	1	1	2	f	\N	\N	\N
267	6	56	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
268	24	57	2	7975	\N	7975	\N	\N	1	1	2	f	0	\N	\N
269	26	57	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
270	19	57	2	7975	\N	7975	\N	\N	0	1	2	f	0	\N	\N
271	9	57	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
272	15	57	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
273	17	57	1	7964	\N	7964	\N	\N	1	1	2	f	\N	\N	\N
274	6	57	1	12	\N	12	\N	\N	2	1	2	f	\N	\N	\N
275	24	58	2	41890	\N	41890	\N	\N	1	1	2	f	0	\N	\N
276	25	58	2	34	\N	34	\N	\N	2	1	2	f	0	\N	\N
277	19	58	2	41890	\N	41890	\N	\N	0	1	2	f	0	\N	\N
278	9	58	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
279	15	58	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
280	17	58	1	41019	\N	41019	\N	\N	1	1	2	f	\N	\N	\N
281	6	58	1	905	\N	905	\N	\N	2	1	2	f	\N	\N	\N
282	25	59	2	514005	\N	0	\N	\N	1	1	2	f	514005	\N	\N
283	9	59	2	514005	\N	0	\N	\N	0	1	2	f	514005	\N	\N
284	15	59	2	514005	\N	0	\N	\N	0	1	2	f	514005	\N	\N
285	23	59	2	16305	\N	0	\N	\N	0	1	2	f	16305	\N	\N
286	24	60	2	4594	\N	4594	\N	\N	1	1	2	f	0	\N	\N
287	9	60	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
288	19	60	2	4594	\N	4594	\N	\N	0	1	2	f	0	\N	\N
289	15	60	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
290	26	60	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
291	25	60	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
292	6	60	1	4595	\N	4595	\N	\N	1	1	2	f	\N	\N	\N
293	17	60	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
294	26	61	2	59757	\N	59757	\N	\N	1	1	2	f	0	\N	\N
295	9	61	2	59757	\N	59757	\N	\N	0	1	2	f	0	\N	\N
296	15	61	2	59757	\N	59757	\N	\N	0	1	2	f	0	\N	\N
297	2	61	1	59757	\N	59757	\N	\N	1	1	2	f	\N	\N	\N
298	21	62	2	11732703	\N	0	\N	\N	1	1	2	f	11732703	\N	\N
299	25	62	2	514005	\N	0	\N	\N	2	1	2	f	514005	\N	\N
300	5	62	2	11732703	\N	0	\N	\N	0	1	2	f	11732703	\N	\N
301	9	62	2	514005	\N	0	\N	\N	0	1	2	f	514005	\N	\N
302	15	62	2	514005	\N	0	\N	\N	0	1	2	f	514005	\N	\N
303	23	62	2	16305	\N	0	\N	\N	0	1	2	f	16305	\N	\N
304	24	63	2	3435	\N	3435	\N	\N	1	1	2	f	0	\N	\N
305	9	63	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
306	19	63	2	3435	\N	3435	\N	\N	0	1	2	f	0	\N	\N
307	15	63	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
308	25	63	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
309	26	63	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
310	23	63	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
311	6	63	1	3198	\N	3198	\N	\N	1	1	2	f	\N	\N	\N
312	17	63	1	247	\N	247	\N	\N	2	1	2	f	\N	\N	\N
313	24	64	2	4814	\N	4814	\N	\N	1	1	2	f	0	\N	\N
314	26	64	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
315	19	64	2	4814	\N	4814	\N	\N	0	1	2	f	0	\N	\N
316	9	64	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
317	15	64	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
318	17	64	1	4820	\N	4820	\N	\N	1	1	2	f	\N	\N	\N
319	6	64	1	22	\N	22	\N	\N	2	1	2	f	\N	\N	\N
320	17	65	2	175635	\N	0	\N	\N	1	1	2	f	175635	\N	\N
321	24	66	2	1983	\N	1983	\N	\N	1	1	2	f	0	\N	\N
322	19	66	2	1983	\N	1983	\N	\N	0	1	2	f	0	\N	\N
323	6	66	1	1983	\N	1983	\N	\N	1	1	2	f	\N	\N	\N
324	26	67	2	557	\N	557	\N	\N	1	1	2	f	0	\N	\N
325	24	67	2	181	\N	181	\N	\N	2	1	2	f	0	\N	\N
326	9	67	2	557	\N	557	\N	\N	0	1	2	f	0	\N	\N
327	15	67	2	557	\N	557	\N	\N	0	1	2	f	0	\N	\N
328	19	67	2	181	\N	181	\N	\N	0	1	2	f	0	\N	\N
329	6	67	1	738	\N	738	\N	\N	1	1	2	f	\N	\N	\N
330	24	68	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
331	19	68	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
332	17	68	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
333	24	69	2	2671	\N	2671	\N	\N	1	1	2	f	0	\N	\N
334	26	69	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
335	19	69	2	2671	\N	2671	\N	\N	0	1	2	f	0	\N	\N
336	9	69	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
337	15	69	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
338	17	69	1	2678	\N	2678	\N	\N	1	1	2	f	\N	\N	\N
339	6	69	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
340	19	70	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
341	24	70	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
342	17	70	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
343	19	71	2	2105	\N	2105	\N	\N	1	1	2	f	0	\N	\N
344	24	71	2	2105	\N	2105	\N	\N	0	1	2	f	0	\N	\N
345	17	71	1	2098	\N	2098	\N	\N	1	1	2	f	\N	\N	\N
346	6	71	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
347	2	72	2	1647531	\N	0	\N	\N	1	1	2	f	1647531	\N	\N
348	26	73	2	47188	\N	47188	\N	\N	1	1	2	f	0	\N	\N
349	19	73	2	5936	\N	5936	\N	\N	2	1	2	f	0	\N	\N
350	9	73	2	47188	\N	47188	\N	\N	0	1	2	f	0	\N	\N
351	15	73	2	47188	\N	47188	\N	\N	0	1	2	f	0	\N	\N
352	24	73	2	5936	\N	5936	\N	\N	0	1	2	f	0	\N	\N
353	6	73	1	52984	\N	52984	\N	\N	1	1	2	f	\N	\N	\N
354	17	73	1	140	\N	140	\N	\N	2	1	2	f	\N	\N	\N
355	19	74	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
356	24	74	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
357	6	74	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
358	19	75	2	5977	\N	5977	\N	\N	1	1	2	f	0	\N	\N
359	25	75	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
360	24	75	2	5977	\N	5977	\N	\N	0	1	2	f	0	\N	\N
361	9	75	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
362	15	75	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
363	6	75	1	5719	\N	5719	\N	\N	1	1	2	f	\N	\N	\N
364	17	75	1	267	\N	267	\N	\N	2	1	2	f	\N	\N	\N
365	9	76	2	2061618	\N	2061618	\N	\N	1	1	2	f	0	\N	\N
366	15	76	2	2061618	\N	2061618	\N	\N	0	1	2	f	0	\N	\N
367	19	77	2	32	\N	32	\N	\N	1	1	2	f	0	\N	\N
368	24	77	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
369	6	77	1	31	\N	31	\N	\N	1	1	2	f	\N	\N	\N
370	17	77	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
371	24	78	2	3439	\N	3439	\N	\N	1	1	2	f	0	\N	\N
372	26	78	2	45	\N	45	\N	\N	2	1	2	f	0	\N	\N
373	19	78	2	3439	\N	3439	\N	\N	0	1	2	f	0	\N	\N
374	9	78	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
375	15	78	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
376	17	78	1	3479	\N	3479	\N	\N	1	1	2	f	\N	\N	\N
377	6	78	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
378	24	79	2	277231	\N	277231	\N	\N	1	1	2	f	0	\N	\N
379	9	79	2	22190	\N	22190	\N	\N	2	1	2	f	0	\N	\N
380	19	79	2	277231	\N	277231	\N	\N	0	1	2	f	0	\N	\N
381	15	79	2	22190	\N	22190	\N	\N	0	1	2	f	0	\N	\N
382	26	79	2	22147	\N	22147	\N	\N	0	1	2	f	0	\N	\N
383	25	79	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
384	23	79	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
385	6	79	1	295584	\N	295584	\N	\N	1	1	2	f	\N	\N	\N
386	17	79	1	3837	\N	3837	\N	\N	2	1	2	f	\N	\N	\N
387	24	80	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
388	19	80	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
389	6	80	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
390	24	81	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
391	19	81	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
392	6	81	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
393	24	82	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
394	19	82	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
395	6	82	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
396	24	83	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
397	19	83	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
398	6	83	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
399	24	84	2	459	\N	459	\N	\N	1	1	2	f	0	\N	\N
400	25	84	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
401	19	84	2	459	\N	459	\N	\N	0	1	2	f	0	\N	\N
402	9	84	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
403	15	84	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
404	6	84	1	452	\N	452	\N	\N	1	1	2	f	\N	\N	\N
405	17	84	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
406	19	85	2	98195	\N	98195	\N	\N	1	1	2	f	0	\N	\N
407	9	85	2	223	\N	223	\N	\N	2	1	2	f	0	\N	\N
408	24	85	2	98195	\N	98195	\N	\N	0	1	2	f	0	\N	\N
409	15	85	2	223	\N	223	\N	\N	0	1	2	f	0	\N	\N
410	26	85	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
411	25	85	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
412	6	85	1	98232	\N	98232	\N	\N	1	1	2	f	\N	\N	\N
413	17	85	1	186	\N	186	\N	\N	2	1	2	f	\N	\N	\N
414	19	86	2	84	\N	84	\N	\N	1	1	2	f	0	\N	\N
415	26	86	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
416	24	86	2	84	\N	84	\N	\N	0	1	2	f	0	\N	\N
417	9	86	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
418	15	86	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
419	6	86	1	92	\N	92	\N	\N	1	1	2	f	\N	\N	\N
420	21	87	2	7042637	\N	0	\N	\N	1	1	2	f	7042637	\N	\N
421	25	87	2	319911	\N	0	\N	\N	2	1	2	f	319911	\N	\N
422	5	87	2	7042637	\N	0	\N	\N	0	1	2	f	7042637	\N	\N
423	9	87	2	319911	\N	0	\N	\N	0	1	2	f	319911	\N	\N
424	15	87	2	319911	\N	0	\N	\N	0	1	2	f	319911	\N	\N
425	23	87	2	24236	\N	0	\N	\N	0	1	2	f	24236	\N	\N
426	19	88	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
427	24	88	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
428	6	88	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
429	9	89	2	795	\N	0	\N	\N	1	1	2	f	795	\N	\N
430	15	89	2	795	\N	0	\N	\N	0	1	2	f	795	\N	\N
431	19	90	2	248	\N	248	\N	\N	1	1	2	f	0	\N	\N
432	24	90	2	248	\N	248	\N	\N	0	1	2	f	0	\N	\N
433	17	90	1	248	\N	248	\N	\N	1	1	2	f	\N	\N	\N
434	19	91	2	142534	\N	142534	\N	\N	1	1	2	f	0	\N	\N
435	26	91	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
436	24	91	2	142534	\N	142534	\N	\N	0	1	2	f	0	\N	\N
437	9	91	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
438	15	91	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
439	17	91	1	142360	\N	142360	\N	\N	1	1	2	f	\N	\N	\N
440	6	91	1	180	\N	180	\N	\N	2	1	2	f	\N	\N	\N
441	21	92	2	3685346	\N	0	\N	\N	1	1	2	f	3685346	\N	\N
442	5	92	2	3685346	\N	0	\N	\N	0	1	2	f	3685346	\N	\N
443	21	93	2	11627612	\N	11627612	\N	\N	1	1	2	f	0	\N	\N
444	5	93	2	11627612	\N	11627612	\N	\N	0	1	2	f	0	\N	\N
445	12	93	1	11627612	\N	11627612	\N	\N	1	1	2	f	\N	\N	\N
446	19	94	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
447	25	94	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
448	24	94	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
449	9	94	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
450	15	94	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
451	6	94	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
452	17	94	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
453	6	95	2	4133135	\N	0	\N	\N	1	1	2	f	4133135	\N	\N
454	19	96	2	20590908	\N	20590908	\N	\N	1	1	2	f	0	\N	\N
455	9	96	2	690140	\N	690140	\N	\N	2	1	2	f	0	\N	\N
456	24	96	2	20590908	\N	20590908	\N	\N	0	1	2	f	0	\N	\N
457	15	96	2	690140	\N	690140	\N	\N	0	1	2	f	0	\N	\N
458	26	96	2	336259	\N	336259	\N	\N	0	1	2	f	0	\N	\N
459	25	96	2	255215	\N	255215	\N	\N	0	1	2	f	0	\N	\N
460	23	96	2	12935	\N	12935	\N	\N	0	1	2	f	0	\N	\N
461	6	96	1	17443460	\N	17443460	\N	\N	1	1	2	f	\N	\N	\N
462	17	96	1	3837588	\N	3837588	\N	\N	2	1	2	f	\N	\N	\N
463	19	97	2	126	\N	126	\N	\N	1	1	2	f	0	\N	\N
464	24	97	2	126	\N	126	\N	\N	0	1	2	f	0	\N	\N
465	6	97	1	125	\N	125	\N	\N	1	1	2	f	\N	\N	\N
466	17	97	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
467	19	98	2	109	\N	109	\N	\N	1	1	2	f	0	\N	\N
468	24	98	2	109	\N	109	\N	\N	0	1	2	f	0	\N	\N
469	6	98	1	105	\N	105	\N	\N	1	1	2	f	\N	\N	\N
470	17	98	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
471	19	99	2	10645	\N	10645	\N	\N	1	1	2	f	0	\N	\N
472	25	99	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
473	24	99	2	10645	\N	10645	\N	\N	0	1	2	f	0	\N	\N
474	9	99	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
475	15	99	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
476	6	99	1	9525	\N	9525	\N	\N	1	1	2	f	\N	\N	\N
477	17	99	1	1122	\N	1122	\N	\N	2	1	2	f	\N	\N	\N
478	19	100	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
479	24	100	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
480	6	100	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
481	19	101	2	261	\N	261	\N	\N	1	1	2	f	0	\N	\N
482	24	101	2	261	\N	261	\N	\N	0	1	2	f	0	\N	\N
483	6	101	1	218	\N	218	\N	\N	1	1	2	f	\N	\N	\N
484	17	101	1	43	\N	43	\N	\N	2	1	2	f	\N	\N	\N
485	2	102	2	230391	\N	230391	\N	\N	1	1	2	f	0	\N	\N
486	4	102	1	18089	\N	18089	\N	\N	1	1	2	f	\N	\N	\N
487	3	102	1	18089	\N	18089	\N	\N	0	1	2	f	\N	\N	\N
488	9	103	2	1887159	\N	0	\N	\N	1	1	2	f	1887159	\N	\N
489	6	103	2	391691	\N	0	\N	\N	2	1	2	f	391691	\N	\N
490	17	103	2	95636	\N	0	\N	\N	3	1	2	f	95636	\N	\N
491	15	103	2	1887159	\N	0	\N	\N	0	1	2	f	1887159	\N	\N
492	25	103	2	244622	\N	0	\N	\N	0	1	2	f	244622	\N	\N
493	23	103	2	2354	\N	0	\N	\N	0	1	2	f	2354	\N	\N
494	19	105	2	2236	\N	2236	\N	\N	1	1	2	f	0	\N	\N
495	26	105	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
496	24	105	2	2236	\N	2236	\N	\N	0	1	2	f	0	\N	\N
497	9	105	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
498	15	105	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
499	6	105	1	2246	\N	2246	\N	\N	1	1	2	f	\N	\N	\N
500	19	106	2	862	\N	862	\N	\N	1	1	2	f	0	\N	\N
501	26	106	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
502	24	106	2	862	\N	862	\N	\N	0	1	2	f	0	\N	\N
503	9	106	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
504	15	106	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
505	6	106	1	864	\N	864	\N	\N	1	1	2	f	\N	\N	\N
506	19	107	2	2051	\N	2051	\N	\N	1	1	2	f	0	\N	\N
507	9	107	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
508	24	107	2	2051	\N	2051	\N	\N	0	1	2	f	0	\N	\N
509	15	107	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
510	26	107	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
511	25	107	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
512	6	107	1	2017	\N	2017	\N	\N	1	1	2	f	\N	\N	\N
513	17	107	1	38	\N	38	\N	\N	2	1	2	f	\N	\N	\N
514	19	108	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
515	24	108	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
516	6	108	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
517	17	108	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
518	19	109	2	1631	\N	1631	\N	\N	1	1	2	f	0	\N	\N
519	9	109	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
520	24	109	2	1631	\N	1631	\N	\N	0	1	2	f	0	\N	\N
521	15	109	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
522	25	109	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
523	26	109	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
524	6	109	1	1628	\N	1628	\N	\N	1	1	2	f	\N	\N	\N
525	17	109	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
526	19	110	2	37968	\N	37968	\N	\N	1	1	2	f	0	\N	\N
527	25	110	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
528	24	110	2	37968	\N	37968	\N	\N	0	1	2	f	0	\N	\N
529	9	110	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
530	15	110	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
531	6	110	1	37354	\N	37354	\N	\N	1	1	2	f	\N	\N	\N
532	17	110	1	621	\N	621	\N	\N	2	1	2	f	\N	\N	\N
533	19	111	2	14991	\N	14991	\N	\N	1	1	2	f	0	\N	\N
534	24	111	2	14991	\N	14991	\N	\N	0	1	2	f	0	\N	\N
535	6	111	1	14975	\N	14975	\N	\N	1	1	2	f	\N	\N	\N
536	17	111	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
537	19	112	2	6184	\N	6184	\N	\N	1	1	2	f	0	\N	\N
538	26	112	2	162	\N	162	\N	\N	2	1	2	f	0	\N	\N
539	24	112	2	6184	\N	6184	\N	\N	0	1	2	f	0	\N	\N
540	9	112	2	162	\N	162	\N	\N	0	1	2	f	0	\N	\N
541	15	112	2	162	\N	162	\N	\N	0	1	2	f	0	\N	\N
542	6	112	1	6342	\N	6342	\N	\N	1	1	2	f	\N	\N	\N
543	17	112	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
544	24	113	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
545	19	113	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
546	6	113	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
547	24	114	2	28043	\N	28043	\N	\N	1	1	2	f	0	\N	\N
548	26	114	2	39	\N	39	\N	\N	2	1	2	f	0	\N	\N
549	19	114	2	28043	\N	28043	\N	\N	0	1	2	f	0	\N	\N
550	9	114	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
551	15	114	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
552	6	114	1	28075	\N	28075	\N	\N	1	1	2	f	\N	\N	\N
553	17	114	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
554	24	115	2	251	\N	251	\N	\N	1	1	2	f	0	\N	\N
555	19	115	2	251	\N	251	\N	\N	0	1	2	f	0	\N	\N
556	6	115	1	251	\N	251	\N	\N	1	1	2	f	\N	\N	\N
557	26	116	2	2462	\N	2462	\N	\N	1	1	2	f	0	\N	\N
558	24	116	2	152	\N	152	\N	\N	2	1	2	f	0	\N	\N
559	9	116	2	2462	\N	2462	\N	\N	0	1	2	f	0	\N	\N
560	15	116	2	2462	\N	2462	\N	\N	0	1	2	f	0	\N	\N
561	19	116	2	152	\N	152	\N	\N	0	1	2	f	0	\N	\N
562	6	116	1	2606	\N	2606	\N	\N	1	1	2	f	\N	\N	\N
563	17	116	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
564	24	117	2	18937	\N	18937	\N	\N	1	1	2	f	0	\N	\N
565	26	117	2	80	\N	80	\N	\N	2	1	2	f	0	\N	\N
566	19	117	2	18937	\N	18937	\N	\N	0	1	2	f	0	\N	\N
567	9	117	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
568	15	117	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
569	6	117	1	19015	\N	19015	\N	\N	1	1	2	f	\N	\N	\N
570	17	117	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
571	24	118	2	1586	\N	1586	\N	\N	1	1	2	f	0	\N	\N
572	19	118	2	1586	\N	1586	\N	\N	0	1	2	f	0	\N	\N
573	6	118	1	1534	\N	1534	\N	\N	1	1	2	f	\N	\N	\N
574	17	118	1	52	\N	52	\N	\N	2	1	2	f	\N	\N	\N
575	24	119	2	23	\N	23	\N	\N	1	1	2	f	0	\N	\N
576	19	119	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
577	6	119	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
578	26	120	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
579	9	120	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
580	15	120	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
581	6	120	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
582	19	121	2	222	\N	222	\N	\N	1	1	2	f	0	\N	\N
583	26	121	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
584	24	121	2	222	\N	222	\N	\N	0	1	2	f	0	\N	\N
585	9	121	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
586	15	121	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
587	6	121	1	187	\N	187	\N	\N	1	1	2	f	\N	\N	\N
588	17	121	1	40	\N	40	\N	\N	2	1	2	f	\N	\N	\N
589	19	122	2	108860	\N	108860	\N	\N	1	1	2	f	0	\N	\N
590	9	122	2	35	\N	35	\N	\N	2	1	2	f	0	\N	\N
591	24	122	2	108860	\N	108860	\N	\N	0	1	2	f	0	\N	\N
592	15	122	2	35	\N	35	\N	\N	0	1	2	f	0	\N	\N
593	25	122	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
594	26	122	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
595	23	122	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
596	6	122	1	107630	\N	107630	\N	\N	1	1	2	f	\N	\N	\N
597	17	122	1	1265	\N	1265	\N	\N	2	1	2	f	\N	\N	\N
598	26	123	2	83	\N	83	\N	\N	1	1	2	f	0	\N	\N
599	19	123	2	24	\N	24	\N	\N	2	1	2	f	0	\N	\N
600	9	123	2	83	\N	83	\N	\N	0	1	2	f	0	\N	\N
601	15	123	2	83	\N	83	\N	\N	0	1	2	f	0	\N	\N
602	24	123	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
603	6	123	1	96	\N	96	\N	\N	1	1	2	f	\N	\N	\N
604	17	123	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
605	19	124	2	232383	\N	232383	\N	\N	1	1	2	f	0	\N	\N
606	9	124	2	281	\N	281	\N	\N	2	1	2	f	0	\N	\N
607	24	124	2	232383	\N	232383	\N	\N	0	1	2	f	0	\N	\N
608	15	124	2	281	\N	281	\N	\N	0	1	2	f	0	\N	\N
609	25	124	2	280	\N	280	\N	\N	0	1	2	f	0	\N	\N
610	26	124	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
611	6	124	1	232551	\N	232551	\N	\N	1	1	2	f	\N	\N	\N
612	17	124	1	113	\N	113	\N	\N	2	1	2	f	\N	\N	\N
613	19	125	2	4784	\N	4784	\N	\N	1	1	2	f	0	\N	\N
614	24	125	2	4784	\N	4784	\N	\N	0	1	2	f	0	\N	\N
615	6	125	1	4783	\N	4783	\N	\N	1	1	2	f	\N	\N	\N
616	17	125	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
617	24	126	2	134	\N	134	\N	\N	1	1	2	f	0	\N	\N
618	19	126	2	134	\N	134	\N	\N	0	1	2	f	0	\N	\N
619	6	126	1	134	\N	134	\N	\N	1	1	2	f	\N	\N	\N
620	24	127	2	467	\N	467	\N	\N	1	1	2	f	0	\N	\N
621	19	127	2	467	\N	467	\N	\N	0	1	2	f	0	\N	\N
622	6	127	1	466	\N	466	\N	\N	1	1	2	f	\N	\N	\N
623	17	127	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
624	24	128	2	167715	\N	167715	\N	\N	1	1	2	f	0	\N	\N
625	26	128	2	239	\N	239	\N	\N	2	1	2	f	0	\N	\N
626	19	128	2	167715	\N	167715	\N	\N	0	1	2	f	0	\N	\N
627	9	128	2	239	\N	239	\N	\N	0	1	2	f	0	\N	\N
628	15	128	2	239	\N	239	\N	\N	0	1	2	f	0	\N	\N
629	6	128	1	167137	\N	167137	\N	\N	1	1	2	f	\N	\N	\N
630	17	128	1	817	\N	817	\N	\N	2	1	2	f	\N	\N	\N
631	6	129	2	292595	\N	0	\N	\N	1	1	2	f	292595	\N	\N
632	21	130	2	41932	\N	41932	\N	\N	1	1	2	f	0	\N	\N
633	5	130	2	41932	\N	41932	\N	\N	0	1	2	f	0	\N	\N
634	24	131	2	1423	\N	1423	\N	\N	1	1	2	f	0	\N	\N
635	26	131	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
636	19	131	2	1423	\N	1423	\N	\N	0	1	2	f	0	\N	\N
637	9	131	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
638	15	131	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
639	6	131	1	1423	\N	1423	\N	\N	1	1	2	f	\N	\N	\N
640	17	131	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
641	24	132	2	19897	\N	19897	\N	\N	1	1	2	f	0	\N	\N
642	26	132	2	54	\N	54	\N	\N	2	1	2	f	0	\N	\N
643	19	132	2	19897	\N	19897	\N	\N	0	1	2	f	0	\N	\N
644	9	132	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
645	15	132	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
646	6	132	1	19951	\N	19951	\N	\N	1	1	2	f	\N	\N	\N
647	24	133	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
648	19	133	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
649	6	133	1	35	\N	35	\N	\N	1	1	2	f	\N	\N	\N
650	17	133	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
651	26	134	2	21340	\N	21340	\N	\N	1	1	2	f	0	\N	\N
652	9	134	2	21340	\N	21340	\N	\N	0	1	2	f	0	\N	\N
653	15	134	2	21340	\N	21340	\N	\N	0	1	2	f	0	\N	\N
654	17	134	1	21340	\N	21340	\N	\N	1	1	2	f	\N	\N	\N
655	19	135	2	4299	\N	4299	\N	\N	1	1	2	f	0	\N	\N
656	26	135	2	42	\N	42	\N	\N	2	1	2	f	0	\N	\N
657	24	135	2	4299	\N	4299	\N	\N	0	1	2	f	0	\N	\N
658	9	135	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
659	15	135	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
660	6	135	1	4339	\N	4339	\N	\N	1	1	2	f	\N	\N	\N
661	17	135	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
662	24	136	2	188	\N	188	\N	\N	1	1	2	f	0	\N	\N
663	26	136	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
664	19	136	2	188	\N	188	\N	\N	0	1	2	f	0	\N	\N
665	9	136	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
666	15	136	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
667	6	136	1	190	\N	190	\N	\N	1	1	2	f	\N	\N	\N
668	24	137	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
669	19	137	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
670	6	137	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
671	21	138	2	85121	\N	0	\N	\N	1	1	2	f	85121	\N	\N
672	5	138	2	85121	\N	0	\N	\N	0	1	2	f	85121	\N	\N
673	2	139	2	181762	\N	181762	\N	\N	1	1	2	f	0	\N	\N
674	2	139	1	181762	\N	181762	\N	\N	1	1	2	f	\N	\N	\N
675	24	140	2	1732	\N	1732	\N	\N	1	1	2	f	0	\N	\N
676	19	140	2	1732	\N	1732	\N	\N	0	1	2	f	0	\N	\N
677	6	140	1	1731	\N	1731	\N	\N	1	1	2	f	\N	\N	\N
678	17	140	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
679	24	141	2	48	\N	48	\N	\N	1	1	2	f	0	\N	\N
680	19	141	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
681	6	141	1	48	\N	48	\N	\N	1	1	2	f	\N	\N	\N
682	24	142	2	17073	\N	17073	\N	\N	1	1	2	f	0	\N	\N
683	26	142	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
684	19	142	2	17073	\N	17073	\N	\N	0	1	2	f	0	\N	\N
685	9	142	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
686	15	142	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
687	6	142	1	17074	\N	17074	\N	\N	1	1	2	f	\N	\N	\N
688	17	142	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
689	24	143	2	127	\N	127	\N	\N	1	1	2	f	0	\N	\N
690	19	143	2	127	\N	127	\N	\N	0	1	2	f	0	\N	\N
691	6	143	1	127	\N	127	\N	\N	1	1	2	f	\N	\N	\N
692	3	144	2	18089	\N	18089	\N	\N	1	1	2	f	0	\N	\N
693	4	144	2	18089	\N	18089	\N	\N	0	1	2	f	0	\N	\N
694	2	144	1	18089	\N	18089	\N	\N	1	1	2	f	\N	\N	\N
695	8	145	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
696	24	146	2	7864	\N	7864	\N	\N	1	1	2	f	0	\N	\N
697	26	146	2	66	\N	66	\N	\N	2	1	2	f	0	\N	\N
698	19	146	2	7864	\N	7864	\N	\N	0	1	2	f	0	\N	\N
699	9	146	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
700	15	146	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
701	6	146	1	7928	\N	7928	\N	\N	1	1	2	f	\N	\N	\N
702	17	146	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
703	24	147	2	17946	\N	17946	\N	\N	1	1	2	f	0	\N	\N
704	26	147	2	17	\N	17	\N	\N	2	1	2	f	0	\N	\N
705	19	147	2	17946	\N	17946	\N	\N	0	1	2	f	0	\N	\N
706	9	147	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
707	15	147	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
708	6	147	1	17961	\N	17961	\N	\N	1	1	2	f	\N	\N	\N
709	17	147	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
710	19	148	2	167	\N	167	\N	\N	1	1	2	f	0	\N	\N
711	26	148	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
712	24	148	2	167	\N	167	\N	\N	0	1	2	f	0	\N	\N
713	9	148	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
714	15	148	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
715	6	148	1	154	\N	154	\N	\N	1	1	2	f	\N	\N	\N
716	17	148	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
717	19	149	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
718	24	149	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
719	6	149	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
720	19	150	2	2777	\N	2777	\N	\N	1	1	2	f	0	\N	\N
721	24	150	2	2777	\N	2777	\N	\N	0	1	2	f	0	\N	\N
722	6	150	1	2593	\N	2593	\N	\N	1	1	2	f	\N	\N	\N
723	17	150	1	184	\N	184	\N	\N	2	1	2	f	\N	\N	\N
724	19	151	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
725	24	151	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
726	6	151	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
727	19	152	2	222886	\N	222886	\N	\N	1	1	2	f	0	\N	\N
728	9	152	2	77	\N	77	\N	\N	2	1	2	f	0	\N	\N
729	24	152	2	222886	\N	222886	\N	\N	0	1	2	f	0	\N	\N
730	15	152	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
731	26	152	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
732	25	152	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
733	23	152	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
734	6	152	1	172045	\N	172045	\N	\N	1	1	2	f	\N	\N	\N
735	17	152	1	50918	\N	50918	\N	\N	2	1	2	f	\N	\N	\N
736	19	153	2	1093	\N	1093	\N	\N	1	1	2	f	0	\N	\N
737	26	153	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
738	24	153	2	1093	\N	1093	\N	\N	0	1	2	f	0	\N	\N
739	9	153	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
740	15	153	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
741	6	153	1	1092	\N	1092	\N	\N	1	1	2	f	\N	\N	\N
742	17	153	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
743	24	154	2	71	\N	71	\N	\N	1	1	2	f	0	\N	\N
744	19	154	2	71	\N	71	\N	\N	0	1	2	f	0	\N	\N
745	6	154	1	69	\N	69	\N	\N	1	1	2	f	\N	\N	\N
746	17	154	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
747	19	155	2	1458	\N	1458	\N	\N	1	1	2	f	0	\N	\N
748	26	155	2	41	\N	41	\N	\N	2	1	2	f	0	\N	\N
749	24	155	2	1458	\N	1458	\N	\N	0	1	2	f	0	\N	\N
750	9	155	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
751	15	155	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
752	6	155	1	1491	\N	1491	\N	\N	1	1	2	f	\N	\N	\N
753	17	155	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
754	2	156	2	19881	\N	19881	\N	\N	1	1	2	f	0	\N	\N
755	21	157	2	11619124	\N	0	\N	\N	1	1	2	f	11619124	\N	\N
756	9	157	2	771375	\N	0	\N	\N	2	1	2	f	771375	\N	\N
757	11	157	2	3920	\N	0	\N	\N	3	1	2	f	3920	\N	\N
758	7	157	2	555	\N	0	\N	\N	4	1	2	f	555	\N	\N
759	5	157	2	11619124	\N	0	\N	\N	0	1	2	f	11619124	\N	\N
760	15	157	2	771375	\N	0	\N	\N	0	1	2	f	771375	\N	\N
761	25	157	2	419923	\N	0	\N	\N	0	1	2	f	419923	\N	\N
762	26	157	2	62198	\N	0	\N	\N	0	1	2	f	62198	\N	\N
763	23	157	2	15671	\N	0	\N	\N	0	1	2	f	15671	\N	\N
764	1	157	2	555	\N	0	\N	\N	0	1	2	f	555	\N	\N
765	19	158	2	220	\N	220	\N	\N	1	1	2	f	0	\N	\N
766	26	158	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
767	24	158	2	220	\N	220	\N	\N	0	1	2	f	0	\N	\N
768	9	158	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
769	15	158	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
770	6	158	1	216	\N	216	\N	\N	1	1	2	f	\N	\N	\N
771	17	158	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
772	26	159	2	171	\N	171	\N	\N	1	1	2	f	0	\N	\N
773	19	159	2	83	\N	83	\N	\N	2	1	2	f	0	\N	\N
774	9	159	2	171	\N	171	\N	\N	0	1	2	f	0	\N	\N
775	15	159	2	171	\N	171	\N	\N	0	1	2	f	0	\N	\N
776	24	159	2	83	\N	83	\N	\N	0	1	2	f	0	\N	\N
777	6	159	1	250	\N	250	\N	\N	1	1	2	f	\N	\N	\N
778	17	159	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
779	21	160	2	13835629	\N	13835629	\N	\N	1	1	2	f	0	\N	\N
780	19	160	2	9493819	\N	9493819	\N	\N	2	1	2	f	0	\N	\N
781	9	160	2	365112	\N	365112	\N	\N	3	1	2	f	0	\N	\N
782	1	160	2	7921	\N	7921	\N	\N	4	1	2	f	0	\N	\N
783	2	160	2	5763	\N	5763	\N	\N	5	1	2	f	0	\N	\N
784	5	160	2	13835629	\N	13835629	\N	\N	0	1	2	f	0	\N	\N
785	24	160	2	9493819	\N	9493819	\N	\N	0	1	2	f	0	\N	\N
786	15	160	2	365112	\N	365112	\N	\N	0	1	2	f	0	\N	\N
787	26	160	2	25691	\N	25691	\N	\N	0	1	2	f	0	\N	\N
788	7	160	2	7372	\N	7372	\N	\N	0	1	2	f	0	\N	\N
789	25	160	2	2334	\N	2334	\N	\N	0	1	2	f	0	\N	\N
790	23	160	2	225	\N	225	\N	\N	0	1	2	f	0	\N	\N
791	2	160	1	21958076	\N	21958076	\N	\N	1	1	2	f	\N	\N	\N
792	6	160	1	1344056	\N	1344056	\N	\N	2	1	2	f	\N	\N	\N
793	9	160	1	526223	\N	526223	\N	\N	3	1	2	f	\N	\N	\N
794	17	160	1	395525	\N	395525	\N	\N	4	1	2	f	\N	\N	\N
795	15	160	1	526223	\N	526223	\N	\N	0	1	2	f	\N	\N	\N
796	26	160	1	214986	\N	214986	\N	\N	0	1	2	f	\N	\N	\N
797	19	161	2	7841	\N	7841	\N	\N	1	1	2	f	0	\N	\N
798	26	161	2	42	\N	42	\N	\N	2	1	2	f	0	\N	\N
799	24	161	2	7841	\N	7841	\N	\N	0	1	2	f	0	\N	\N
800	9	161	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
801	15	161	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
802	6	161	1	7881	\N	7881	\N	\N	1	1	2	f	\N	\N	\N
803	17	161	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
804	19	162	2	943	\N	943	\N	\N	1	1	2	f	0	\N	\N
805	26	162	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
806	24	162	2	943	\N	943	\N	\N	0	1	2	f	0	\N	\N
807	9	162	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
808	15	162	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
809	6	162	1	946	\N	946	\N	\N	1	1	2	f	\N	\N	\N
810	17	162	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
811	19	163	2	54	\N	54	\N	\N	1	1	2	f	0	\N	\N
812	26	163	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
813	24	163	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
814	9	163	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
815	15	163	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
816	6	163	1	49	\N	49	\N	\N	1	1	2	f	\N	\N	\N
817	17	163	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
818	19	164	2	8878	\N	8878	\N	\N	1	1	2	f	0	\N	\N
819	26	164	2	87	\N	87	\N	\N	2	1	2	f	0	\N	\N
820	24	164	2	8878	\N	8878	\N	\N	0	1	2	f	0	\N	\N
821	9	164	2	87	\N	87	\N	\N	0	1	2	f	0	\N	\N
822	15	164	2	87	\N	87	\N	\N	0	1	2	f	0	\N	\N
823	6	164	1	8929	\N	8929	\N	\N	1	1	2	f	\N	\N	\N
824	17	164	1	36	\N	36	\N	\N	2	1	2	f	\N	\N	\N
825	19	165	2	29962	\N	29962	\N	\N	1	1	2	f	0	\N	\N
826	9	165	2	159	\N	159	\N	\N	2	1	2	f	0	\N	\N
827	24	165	2	29962	\N	29962	\N	\N	0	1	2	f	0	\N	\N
828	15	165	2	159	\N	159	\N	\N	0	1	2	f	0	\N	\N
829	26	165	2	153	\N	153	\N	\N	0	1	2	f	0	\N	\N
830	25	165	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
831	23	165	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
832	6	165	1	29735	\N	29735	\N	\N	1	1	2	f	\N	\N	\N
833	17	165	1	386	\N	386	\N	\N	2	1	2	f	\N	\N	\N
834	11	166	2	37752	\N	0	\N	\N	1	1	2	f	37752	\N	\N
835	11	167	2	77	\N	0	\N	\N	1	1	2	f	77	\N	\N
836	19	168	2	15787	\N	15787	\N	\N	1	1	2	f	0	\N	\N
837	26	168	2	23	\N	23	\N	\N	2	1	2	f	0	\N	\N
838	24	168	2	15787	\N	15787	\N	\N	0	1	2	f	0	\N	\N
839	9	168	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
840	15	168	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
841	6	168	1	15778	\N	15778	\N	\N	1	1	2	f	\N	\N	\N
842	17	168	1	32	\N	32	\N	\N	2	1	2	f	\N	\N	\N
843	19	169	2	3517	\N	3517	\N	\N	1	1	2	f	0	\N	\N
844	24	169	2	3517	\N	3517	\N	\N	0	1	2	f	0	\N	\N
845	6	169	1	2766	\N	2766	\N	\N	1	1	2	f	\N	\N	\N
846	17	169	1	751	\N	751	\N	\N	2	1	2	f	\N	\N	\N
847	24	170	2	353	\N	353	\N	\N	1	1	2	f	0	\N	\N
848	19	170	2	353	\N	353	\N	\N	0	1	2	f	0	\N	\N
849	6	170	1	353	\N	353	\N	\N	1	1	2	f	\N	\N	\N
850	24	171	2	253	\N	253	\N	\N	1	1	2	f	0	\N	\N
851	19	171	2	253	\N	253	\N	\N	0	1	2	f	0	\N	\N
852	6	171	1	252	\N	252	\N	\N	1	1	2	f	\N	\N	\N
853	17	171	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
854	24	172	2	217060	\N	217060	\N	\N	1	1	2	f	0	\N	\N
855	25	172	2	304	\N	304	\N	\N	2	1	2	f	0	\N	\N
856	19	172	2	217060	\N	217060	\N	\N	0	1	2	f	0	\N	\N
857	9	172	2	304	\N	304	\N	\N	0	1	2	f	0	\N	\N
858	15	172	2	304	\N	304	\N	\N	0	1	2	f	0	\N	\N
859	6	172	1	154824	\N	154824	\N	\N	1	1	2	f	\N	\N	\N
860	17	172	1	62540	\N	62540	\N	\N	2	1	2	f	\N	\N	\N
861	24	173	2	167715	\N	167715	\N	\N	1	1	2	f	0	\N	\N
862	26	173	2	239	\N	239	\N	\N	2	1	2	f	0	\N	\N
863	19	173	2	167715	\N	167715	\N	\N	0	1	2	f	0	\N	\N
864	9	173	2	239	\N	239	\N	\N	0	1	2	f	0	\N	\N
865	15	173	2	239	\N	239	\N	\N	0	1	2	f	0	\N	\N
866	6	173	1	167137	\N	167137	\N	\N	1	1	2	f	\N	\N	\N
867	17	173	1	817	\N	817	\N	\N	2	1	2	f	\N	\N	\N
868	19	174	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
869	24	174	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
870	6	174	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
871	25	175	2	2111	\N	2111	\N	\N	1	1	2	f	0	\N	\N
872	9	175	2	2111	\N	2111	\N	\N	0	1	2	f	0	\N	\N
873	15	175	2	2111	\N	2111	\N	\N	0	1	2	f	0	\N	\N
874	23	175	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
875	25	175	1	2111	\N	2111	\N	\N	1	1	2	f	\N	\N	\N
876	9	175	1	2111	\N	2111	\N	\N	0	1	2	f	\N	\N	\N
877	15	175	1	2111	\N	2111	\N	\N	0	1	2	f	\N	\N	\N
878	23	175	1	1188	\N	1188	\N	\N	0	1	2	f	\N	\N	\N
879	2	176	2	238	\N	238	\N	\N	1	1	2	f	0	\N	\N
880	21	177	2	12196082	\N	0	\N	\N	1	1	2	f	12196082	\N	\N
881	25	177	2	515009	\N	0	\N	\N	2	1	2	f	515009	\N	\N
882	5	177	2	12196082	\N	0	\N	\N	0	1	2	f	12196082	\N	\N
883	9	177	2	515009	\N	0	\N	\N	0	1	2	f	515009	\N	\N
884	15	177	2	515009	\N	0	\N	\N	0	1	2	f	515009	\N	\N
885	23	177	2	16305	\N	0	\N	\N	0	1	2	f	16305	\N	\N
886	26	178	2	240	\N	240	\N	\N	1	1	2	f	0	\N	\N
887	19	178	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
888	9	178	2	240	\N	240	\N	\N	0	1	2	f	0	\N	\N
889	15	178	2	240	\N	240	\N	\N	0	1	2	f	0	\N	\N
890	24	178	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
891	6	178	1	240	\N	240	\N	\N	1	1	2	f	\N	\N	\N
892	17	178	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
893	19	179	2	161	\N	161	\N	\N	1	1	2	f	0	\N	\N
894	24	179	2	161	\N	161	\N	\N	0	1	2	f	0	\N	\N
895	17	179	1	160	\N	160	\N	\N	1	1	2	f	\N	\N	\N
896	6	179	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
897	19	180	2	400	\N	400	\N	\N	1	1	2	f	0	\N	\N
898	24	180	2	400	\N	400	\N	\N	0	1	2	f	0	\N	\N
899	6	180	1	400	\N	400	\N	\N	1	1	2	f	\N	\N	\N
900	19	181	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
901	24	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
902	6	181	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
903	21	182	2	13063699	\N	13063699	\N	\N	1	1	2	f	0	\N	\N
904	5	182	2	13063699	\N	13063699	\N	\N	0	1	2	f	0	\N	\N
905	19	182	1	13063699	\N	13063699	\N	\N	1	1	2	f	\N	\N	\N
906	24	182	1	13063699	\N	13063699	\N	\N	0	1	2	f	\N	\N	\N
907	19	183	2	21177	\N	21177	\N	\N	1	1	2	f	0	\N	\N
908	26	183	2	30	\N	30	\N	\N	2	1	2	f	0	\N	\N
909	24	183	2	21177	\N	21177	\N	\N	0	1	2	f	0	\N	\N
910	9	183	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
911	15	183	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
912	6	183	1	21203	\N	21203	\N	\N	1	1	2	f	\N	\N	\N
913	17	183	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
914	19	184	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
915	24	184	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
916	6	184	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
917	19	185	2	168	\N	168	\N	\N	1	1	2	f	0	\N	\N
918	24	185	2	168	\N	168	\N	\N	0	1	2	f	0	\N	\N
919	6	185	1	168	\N	168	\N	\N	1	1	2	f	\N	\N	\N
920	19	186	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
921	24	186	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
922	17	186	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
923	19	187	2	175	\N	175	\N	\N	1	1	2	f	0	\N	\N
924	24	187	2	175	\N	175	\N	\N	0	1	2	f	0	\N	\N
925	6	187	1	174	\N	174	\N	\N	1	1	2	f	\N	\N	\N
926	17	187	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
927	19	188	2	122185	\N	122185	\N	\N	1	1	2	f	0	\N	\N
928	9	188	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
929	24	188	2	122185	\N	122185	\N	\N	0	1	2	f	0	\N	\N
930	15	188	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
931	26	188	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
932	25	188	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
933	6	188	1	120692	\N	120692	\N	\N	1	1	2	f	\N	\N	\N
934	17	188	1	1502	\N	1502	\N	\N	2	1	2	f	\N	\N	\N
935	24	189	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
936	19	189	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
937	6	189	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
938	26	190	2	1416	\N	1416	\N	\N	1	1	2	f	0	\N	\N
939	24	190	2	89	\N	89	\N	\N	2	1	2	f	0	\N	\N
940	9	190	2	1416	\N	1416	\N	\N	0	1	2	f	0	\N	\N
941	15	190	2	1416	\N	1416	\N	\N	0	1	2	f	0	\N	\N
942	19	190	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
943	6	190	1	1490	\N	1490	\N	\N	1	1	2	f	\N	\N	\N
944	17	190	1	15	\N	15	\N	\N	2	1	2	f	\N	\N	\N
945	24	191	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
946	19	191	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
947	6	191	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
948	17	191	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
949	9	192	2	187739	\N	187739	\N	\N	1	1	2	f	0	\N	\N
950	15	192	2	187739	\N	187739	\N	\N	0	1	2	f	0	\N	\N
951	2	192	1	187646	\N	187646	\N	\N	1	1	2	f	\N	\N	\N
952	24	193	2	1422	\N	1422	\N	\N	1	1	2	f	0	\N	\N
953	19	193	2	1422	\N	1422	\N	\N	0	1	2	f	0	\N	\N
954	6	193	1	1420	\N	1420	\N	\N	1	1	2	f	\N	\N	\N
955	17	193	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
956	24	194	2	27600	\N	27600	\N	\N	1	1	2	f	0	\N	\N
957	9	194	2	8388	\N	8388	\N	\N	2	1	2	f	0	\N	\N
958	19	194	2	27600	\N	27600	\N	\N	0	1	2	f	0	\N	\N
959	15	194	2	8388	\N	8388	\N	\N	0	1	2	f	0	\N	\N
960	25	194	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
961	17	194	1	28276	\N	28276	\N	\N	1	1	2	f	\N	\N	\N
962	6	194	1	7712	\N	7712	\N	\N	2	1	2	f	\N	\N	\N
963	11	195	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
964	24	196	2	3147	\N	3147	\N	\N	1	1	2	f	0	\N	\N
965	25	196	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
966	19	196	2	3147	\N	3147	\N	\N	0	1	2	f	0	\N	\N
967	9	196	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
968	15	196	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
969	6	196	1	3133	\N	3133	\N	\N	1	1	2	f	\N	\N	\N
970	17	196	1	15	\N	15	\N	\N	2	1	2	f	\N	\N	\N
971	24	197	2	133	\N	133	\N	\N	1	1	2	f	0	\N	\N
972	19	197	2	133	\N	133	\N	\N	0	1	2	f	0	\N	\N
973	6	197	1	133	\N	133	\N	\N	1	1	2	f	\N	\N	\N
974	18	198	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
975	24	199	2	41527	\N	41527	\N	\N	1	1	2	f	0	\N	\N
976	9	199	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
977	19	199	2	41527	\N	41527	\N	\N	0	1	2	f	0	\N	\N
978	15	199	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
979	25	199	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
980	26	199	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
981	6	199	1	41457	\N	41457	\N	\N	1	1	2	f	\N	\N	\N
982	17	199	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
983	24	200	2	3250	\N	3250	\N	\N	1	1	2	f	0	\N	\N
984	9	200	2	40	\N	40	\N	\N	2	1	2	f	0	\N	\N
985	19	200	2	3250	\N	3250	\N	\N	0	1	2	f	0	\N	\N
986	15	200	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
987	25	200	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
988	26	200	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
989	23	200	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
990	6	200	1	3189	\N	3189	\N	\N	1	1	2	f	\N	\N	\N
991	17	200	1	101	\N	101	\N	\N	2	1	2	f	\N	\N	\N
992	24	201	2	205	\N	205	\N	\N	1	1	2	f	0	\N	\N
993	26	201	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
994	19	201	2	205	\N	205	\N	\N	0	1	2	f	0	\N	\N
995	9	201	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
996	15	201	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
997	6	201	1	206	\N	206	\N	\N	1	1	2	f	\N	\N	\N
998	24	202	2	157	\N	157	\N	\N	1	1	2	f	0	\N	\N
999	19	202	2	157	\N	157	\N	\N	0	1	2	f	0	\N	\N
1000	6	202	1	156	\N	156	\N	\N	1	1	2	f	\N	\N	\N
1001	17	202	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1002	19	203	2	475	\N	475	\N	\N	1	1	2	f	0	\N	\N
1003	24	203	2	475	\N	475	\N	\N	0	1	2	f	0	\N	\N
1004	6	203	1	470	\N	470	\N	\N	1	1	2	f	\N	\N	\N
1005	17	203	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1006	19	204	2	801	\N	801	\N	\N	1	1	2	f	0	\N	\N
1007	24	204	2	801	\N	801	\N	\N	0	1	2	f	0	\N	\N
1008	6	204	1	799	\N	799	\N	\N	1	1	2	f	\N	\N	\N
1009	17	204	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1010	19	205	2	73134	\N	73134	\N	\N	1	1	2	f	0	\N	\N
1011	9	205	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
1012	24	205	2	73134	\N	73134	\N	\N	0	1	2	f	0	\N	\N
1013	15	205	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1014	26	205	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1015	25	205	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1016	6	205	1	70708	\N	70708	\N	\N	1	1	2	f	\N	\N	\N
1017	17	205	1	2430	\N	2430	\N	\N	2	1	2	f	\N	\N	\N
1018	19	206	2	122	\N	122	\N	\N	1	1	2	f	0	\N	\N
1019	26	206	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1020	24	206	2	122	\N	122	\N	\N	0	1	2	f	0	\N	\N
1021	9	206	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1022	15	206	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1023	6	206	1	122	\N	122	\N	\N	1	1	2	f	\N	\N	\N
1024	17	206	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1025	19	207	2	10508	\N	10508	\N	\N	1	1	2	f	0	\N	\N
1026	9	207	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
1027	24	207	2	10508	\N	10508	\N	\N	0	1	2	f	0	\N	\N
1028	15	207	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1029	26	207	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1030	25	207	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1031	23	207	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1032	6	207	1	10504	\N	10504	\N	\N	1	1	2	f	\N	\N	\N
1033	17	207	1	9	\N	9	\N	\N	2	1	2	f	\N	\N	\N
1034	19	208	2	1569	\N	1569	\N	\N	1	1	2	f	0	\N	\N
1035	26	208	2	25	\N	25	\N	\N	2	1	2	f	0	\N	\N
1036	24	208	2	1569	\N	1569	\N	\N	0	1	2	f	0	\N	\N
1037	9	208	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
1038	15	208	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
1039	6	208	1	1591	\N	1591	\N	\N	1	1	2	f	\N	\N	\N
1040	17	208	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1041	17	209	2	74327	\N	36026	\N	\N	1	1	2	f	38301	\N	\N
1042	24	210	2	215	\N	215	\N	\N	1	1	2	f	0	\N	\N
1043	19	210	2	215	\N	215	\N	\N	0	1	2	f	0	\N	\N
1044	6	210	1	215	\N	215	\N	\N	1	1	2	f	\N	\N	\N
1045	21	211	2	223102	\N	223102	\N	\N	1	1	2	f	0	\N	\N
1046	5	211	2	223102	\N	223102	\N	\N	0	1	2	f	0	\N	\N
1047	12	211	1	223102	\N	223102	\N	\N	1	1	2	f	\N	\N	\N
1048	24	212	2	2225	\N	2225	\N	\N	1	1	2	f	0	\N	\N
1049	26	212	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1050	19	212	2	2225	\N	2225	\N	\N	0	1	2	f	0	\N	\N
1051	9	212	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1052	15	212	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1053	6	212	1	2227	\N	2227	\N	\N	1	1	2	f	\N	\N	\N
1054	24	213	2	161	\N	161	\N	\N	1	1	2	f	0	\N	\N
1055	19	213	2	161	\N	161	\N	\N	0	1	2	f	0	\N	\N
1056	6	213	1	143	\N	143	\N	\N	1	1	2	f	\N	\N	\N
1057	17	213	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
1058	24	214	2	256440	\N	256440	\N	\N	1	1	2	f	0	\N	\N
1059	25	214	2	18963	\N	18963	\N	\N	2	1	2	f	0	\N	\N
1060	19	214	2	256440	\N	256440	\N	\N	0	1	2	f	0	\N	\N
1061	9	214	2	18963	\N	18963	\N	\N	0	1	2	f	0	\N	\N
1062	15	214	2	18963	\N	18963	\N	\N	0	1	2	f	0	\N	\N
1063	23	214	2	393	\N	393	\N	\N	0	1	2	f	0	\N	\N
1064	6	214	1	271387	\N	271387	\N	\N	1	1	2	f	\N	\N	\N
1065	17	214	1	4016	\N	4016	\N	\N	2	1	2	f	\N	\N	\N
1066	19	215	2	6088	\N	6088	\N	\N	1	1	2	f	0	\N	\N
1067	26	215	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
1068	24	215	2	6088	\N	6088	\N	\N	0	1	2	f	0	\N	\N
1069	9	215	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1070	15	215	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1071	6	215	1	4564	\N	4564	\N	\N	1	1	2	f	\N	\N	\N
1072	17	215	1	1552	\N	1552	\N	\N	2	1	2	f	\N	\N	\N
1073	19	216	2	120	\N	120	\N	\N	1	1	2	f	0	\N	\N
1074	24	216	2	120	\N	120	\N	\N	0	1	2	f	0	\N	\N
1075	6	216	1	120	\N	120	\N	\N	1	1	2	f	\N	\N	\N
1076	8	217	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1077	8	217	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1078	25	218	2	221127	\N	0	\N	\N	1	1	2	f	221127	\N	\N
1079	9	218	2	221127	\N	0	\N	\N	0	1	2	f	221127	\N	\N
1080	15	218	2	221127	\N	0	\N	\N	0	1	2	f	221127	\N	\N
1081	23	218	2	10683	\N	0	\N	\N	0	1	2	f	10683	\N	\N
1082	21	219	2	11627613	\N	0	\N	\N	1	1	2	f	11627613	\N	\N
1083	9	219	2	2323759	\N	0	\N	\N	2	1	2	f	2323759	\N	\N
1084	6	219	2	1115556	\N	0	\N	\N	3	1	2	f	1115556	\N	\N
1085	17	219	2	217412	\N	0	\N	\N	4	1	2	f	217412	\N	\N
1086	5	219	2	11627613	\N	0	\N	\N	0	1	2	f	11627613	\N	\N
1087	15	219	2	2323759	\N	0	\N	\N	0	1	2	f	2323759	\N	\N
1088	25	219	2	418999	\N	0	\N	\N	0	1	2	f	418999	\N	\N
1089	26	219	2	62148	\N	0	\N	\N	0	1	2	f	62148	\N	\N
1090	23	219	2	13276	\N	0	\N	\N	0	1	2	f	13276	\N	\N
1091	11	220	2	214543	\N	214543	\N	\N	1	1	2	f	0	\N	\N
1092	2	220	1	214543	\N	214543	\N	\N	1	1	2	f	\N	\N	\N
1093	19	221	2	9690	\N	9690	\N	\N	1	1	2	f	0	\N	\N
1094	26	221	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
1095	24	221	2	9690	\N	9690	\N	\N	0	1	2	f	0	\N	\N
1096	9	221	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1097	15	221	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1098	6	221	1	9693	\N	9693	\N	\N	1	1	2	f	\N	\N	\N
1099	17	221	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1100	19	222	2	40	\N	40	\N	\N	1	1	2	f	0	\N	\N
1101	24	222	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1102	6	222	1	40	\N	40	\N	\N	1	1	2	f	\N	\N	\N
1103	19	223	2	14991	\N	14991	\N	\N	1	1	2	f	0	\N	\N
1104	24	223	2	14991	\N	14991	\N	\N	0	1	2	f	0	\N	\N
1105	6	223	1	14975	\N	14975	\N	\N	1	1	2	f	\N	\N	\N
1106	17	223	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
1107	19	224	2	977	\N	977	\N	\N	1	1	2	f	0	\N	\N
1108	24	224	2	977	\N	977	\N	\N	0	1	2	f	0	\N	\N
1109	17	224	1	972	\N	972	\N	\N	1	1	2	f	\N	\N	\N
1110	6	224	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1111	19	225	2	862	\N	862	\N	\N	1	1	2	f	0	\N	\N
1112	26	225	2	29	\N	29	\N	\N	2	1	2	f	0	\N	\N
1113	24	225	2	862	\N	862	\N	\N	0	1	2	f	0	\N	\N
1114	9	225	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
1115	15	225	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
1116	6	225	1	802	\N	802	\N	\N	1	1	2	f	\N	\N	\N
1117	17	225	1	89	\N	89	\N	\N	2	1	2	f	\N	\N	\N
1118	26	226	2	7439	\N	7439	\N	\N	1	1	2	f	0	\N	\N
1119	24	226	2	5192	\N	5192	\N	\N	2	1	2	f	0	\N	\N
1120	9	226	2	7439	\N	7439	\N	\N	0	1	2	f	0	\N	\N
1121	15	226	2	7439	\N	7439	\N	\N	0	1	2	f	0	\N	\N
1122	19	226	2	5192	\N	5192	\N	\N	0	1	2	f	0	\N	\N
1123	6	226	1	10826	\N	10826	\N	\N	1	1	2	f	\N	\N	\N
1124	17	226	1	1805	\N	1805	\N	\N	2	1	2	f	\N	\N	\N
1125	24	227	2	21356	\N	21356	\N	\N	1	1	2	f	0	\N	\N
1126	9	227	2	40	\N	40	\N	\N	2	1	2	f	0	\N	\N
1127	19	227	2	21356	\N	21356	\N	\N	0	1	2	f	0	\N	\N
1128	15	227	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1129	25	227	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1130	26	227	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1131	6	227	1	15318	\N	15318	\N	\N	1	1	2	f	\N	\N	\N
1132	17	227	1	6078	\N	6078	\N	\N	2	1	2	f	\N	\N	\N
1133	9	228	2	2704439	\N	2704439	\N	\N	1	1	2	f	0	\N	\N
1134	15	228	2	2704439	\N	2704439	\N	\N	0	1	2	f	0	\N	\N
1135	24	228	1	2704439	\N	2704439	\N	\N	1	1	2	f	\N	\N	\N
1136	19	228	1	2704439	\N	2704439	\N	\N	0	1	2	f	\N	\N	\N
1137	24	229	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1138	19	229	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1139	6	229	1	19	\N	19	\N	\N	1	1	2	f	\N	\N	\N
1140	24	230	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1141	19	230	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1142	6	230	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1143	24	231	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1144	19	231	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1145	6	231	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1146	24	232	2	526	\N	526	\N	\N	1	1	2	f	0	\N	\N
1147	26	232	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1148	19	232	2	526	\N	526	\N	\N	0	1	2	f	0	\N	\N
1149	9	232	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1150	15	232	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1151	6	232	1	525	\N	525	\N	\N	1	1	2	f	\N	\N	\N
1152	17	232	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1153	2	233	2	1512570	\N	0	\N	\N	1	1	2	f	1512570	\N	\N
1154	26	234	2	11734	\N	11734	\N	\N	1	1	2	f	0	\N	\N
1155	24	234	2	224	\N	224	\N	\N	2	1	2	f	0	\N	\N
1156	9	234	2	11734	\N	11734	\N	\N	0	1	2	f	0	\N	\N
1157	15	234	2	11734	\N	11734	\N	\N	0	1	2	f	0	\N	\N
1158	19	234	2	224	\N	224	\N	\N	0	1	2	f	0	\N	\N
1159	6	234	1	11947	\N	11947	\N	\N	1	1	2	f	\N	\N	\N
1160	17	234	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
1161	26	235	2	285	\N	285	\N	\N	1	1	2	f	0	\N	\N
1162	24	235	2	39	\N	39	\N	\N	2	1	2	f	0	\N	\N
1163	9	235	2	285	\N	285	\N	\N	0	1	2	f	0	\N	\N
1164	15	235	2	285	\N	285	\N	\N	0	1	2	f	0	\N	\N
1165	19	235	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
1166	6	235	1	314	\N	314	\N	\N	1	1	2	f	\N	\N	\N
1167	17	235	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
1168	24	236	2	1409	\N	1409	\N	\N	1	1	2	f	0	\N	\N
1169	26	236	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
1170	19	236	2	1409	\N	1409	\N	\N	0	1	2	f	0	\N	\N
1171	9	236	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1172	15	236	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1173	6	236	1	1416	\N	1416	\N	\N	1	1	2	f	\N	\N	\N
1174	17	236	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1175	24	237	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1176	19	237	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1177	6	237	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1178	24	238	2	29	\N	29	\N	\N	1	1	2	f	0	\N	\N
1179	25	238	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1180	19	238	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
1181	9	238	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1182	15	238	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1183	17	238	1	27	\N	27	\N	\N	1	1	2	f	\N	\N	\N
1184	6	238	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1185	24	239	2	2819	\N	2819	\N	\N	1	1	2	f	0	\N	\N
1186	26	239	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
1187	19	239	2	2819	\N	2819	\N	\N	0	1	2	f	0	\N	\N
1188	9	239	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1189	15	239	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1190	6	239	1	2823	\N	2823	\N	\N	1	1	2	f	\N	\N	\N
1191	26	240	2	78	\N	78	\N	\N	1	1	2	f	0	\N	\N
1192	19	240	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1193	9	240	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
1194	15	240	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
1195	24	240	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1196	6	240	1	80	\N	80	\N	\N	1	1	2	f	\N	\N	\N
1197	26	241	2	388	\N	388	\N	\N	1	1	2	f	0	\N	\N
1198	19	241	2	76	\N	76	\N	\N	2	1	2	f	0	\N	\N
1199	9	241	2	388	\N	388	\N	\N	0	1	2	f	0	\N	\N
1200	15	241	2	388	\N	388	\N	\N	0	1	2	f	0	\N	\N
1201	24	241	2	76	\N	76	\N	\N	0	1	2	f	0	\N	\N
1202	6	241	1	461	\N	461	\N	\N	1	1	2	f	\N	\N	\N
1203	17	241	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1204	19	242	2	252	\N	252	\N	\N	1	1	2	f	0	\N	\N
1205	24	242	2	252	\N	252	\N	\N	0	1	2	f	0	\N	\N
1206	6	242	1	221	\N	221	\N	\N	1	1	2	f	\N	\N	\N
1207	17	242	1	31	\N	31	\N	\N	2	1	2	f	\N	\N	\N
1208	19	243	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1209	24	243	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1210	6	243	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
1211	24	244	2	1060	\N	1060	\N	\N	1	1	2	f	0	\N	\N
1212	19	244	2	1060	\N	1060	\N	\N	0	1	2	f	0	\N	\N
1213	6	244	1	709	\N	709	\N	\N	1	1	2	f	\N	\N	\N
1214	17	244	1	351	\N	351	\N	\N	2	1	2	f	\N	\N	\N
1215	24	245	2	287	\N	287	\N	\N	1	1	2	f	0	\N	\N
1216	19	245	2	287	\N	287	\N	\N	0	1	2	f	0	\N	\N
1217	6	245	1	285	\N	285	\N	\N	1	1	2	f	\N	\N	\N
1218	17	245	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1219	24	246	2	203958	\N	203958	\N	\N	1	1	2	f	0	\N	\N
1220	9	246	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
1221	19	246	2	203958	\N	203958	\N	\N	0	1	2	f	0	\N	\N
1222	15	246	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1223	25	246	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1224	26	246	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1225	17	246	1	145317	\N	145317	\N	\N	1	1	2	f	\N	\N	\N
1226	6	246	1	58649	\N	58649	\N	\N	2	1	2	f	\N	\N	\N
1227	24	247	2	548003	\N	548003	\N	\N	1	1	2	f	0	\N	\N
1228	26	247	2	3491	\N	3491	\N	\N	2	1	2	f	0	\N	\N
1229	19	247	2	548003	\N	548003	\N	\N	0	1	2	f	0	\N	\N
1230	9	247	2	3491	\N	3491	\N	\N	0	1	2	f	0	\N	\N
1231	15	247	2	3491	\N	3491	\N	\N	0	1	2	f	0	\N	\N
1232	6	247	1	328599	\N	328599	\N	\N	1	1	2	f	\N	\N	\N
1233	17	247	1	222895	\N	222895	\N	\N	2	1	2	f	\N	\N	\N
1234	6	248	2	511077	\N	0	\N	\N	1	1	2	f	511077	\N	\N
1235	24	249	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
1236	25	249	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1237	19	249	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1238	9	249	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1239	15	249	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1240	6	249	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
1241	17	249	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1242	24	250	2	13583	\N	13583	\N	\N	1	1	2	f	0	\N	\N
1243	26	250	2	462	\N	462	\N	\N	2	1	2	f	0	\N	\N
1244	19	250	2	13583	\N	13583	\N	\N	0	1	2	f	0	\N	\N
1245	9	250	2	462	\N	462	\N	\N	0	1	2	f	0	\N	\N
1246	15	250	2	462	\N	462	\N	\N	0	1	2	f	0	\N	\N
1247	6	250	1	14024	\N	14024	\N	\N	1	1	2	f	\N	\N	\N
1248	17	250	1	21	\N	21	\N	\N	2	1	2	f	\N	\N	\N
1249	24	251	2	138175	\N	138175	\N	\N	1	1	2	f	0	\N	\N
1250	9	251	2	4873	\N	4873	\N	\N	2	1	2	f	0	\N	\N
1251	19	251	2	138175	\N	138175	\N	\N	0	1	2	f	0	\N	\N
1252	15	251	2	4873	\N	4873	\N	\N	0	1	2	f	0	\N	\N
1253	25	251	2	4869	\N	4869	\N	\N	0	1	2	f	0	\N	\N
1254	26	251	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1255	6	251	1	133746	\N	133746	\N	\N	1	1	2	f	\N	\N	\N
1256	17	251	1	9302	\N	9302	\N	\N	2	1	2	f	\N	\N	\N
1257	24	252	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
1258	19	252	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1259	6	252	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
1260	26	253	2	7559	\N	7559	\N	\N	1	1	2	f	0	\N	\N
1261	24	253	2	5222	\N	5222	\N	\N	2	1	2	f	0	\N	\N
1262	9	253	2	7559	\N	7559	\N	\N	0	1	2	f	0	\N	\N
1263	15	253	2	7559	\N	7559	\N	\N	0	1	2	f	0	\N	\N
1264	19	253	2	5222	\N	5222	\N	\N	0	1	2	f	0	\N	\N
1265	6	253	1	12743	\N	12743	\N	\N	1	1	2	f	\N	\N	\N
1266	17	253	1	38	\N	38	\N	\N	2	1	2	f	\N	\N	\N
1267	24	254	2	66112	\N	66112	\N	\N	1	1	2	f	0	\N	\N
1268	26	254	2	8187	\N	8187	\N	\N	2	1	2	f	0	\N	\N
1269	19	254	2	66112	\N	66112	\N	\N	0	1	2	f	0	\N	\N
1270	9	254	2	8187	\N	8187	\N	\N	0	1	2	f	0	\N	\N
1271	15	254	2	8187	\N	8187	\N	\N	0	1	2	f	0	\N	\N
1272	6	254	1	73670	\N	73670	\N	\N	1	1	2	f	\N	\N	\N
1273	17	254	1	629	\N	629	\N	\N	2	1	2	f	\N	\N	\N
1274	24	255	2	295112	\N	295112	\N	\N	1	1	2	f	0	\N	\N
1275	26	255	2	58645	\N	58645	\N	\N	2	1	2	f	0	\N	\N
1276	19	255	2	295112	\N	295112	\N	\N	0	1	2	f	0	\N	\N
1277	9	255	2	58645	\N	58645	\N	\N	0	1	2	f	0	\N	\N
1278	15	255	2	58645	\N	58645	\N	\N	0	1	2	f	0	\N	\N
1279	6	255	1	351630	\N	351630	\N	\N	1	1	2	f	\N	\N	\N
1280	17	255	1	2127	\N	2127	\N	\N	2	1	2	f	\N	\N	\N
1281	2	256	2	20600236	\N	0	\N	\N	1	1	2	f	20600236	\N	\N
1282	24	257	2	24879	\N	24879	\N	\N	1	1	2	f	0	\N	\N
1283	25	257	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
1284	19	257	2	24879	\N	24879	\N	\N	0	1	2	f	0	\N	\N
1285	9	257	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1286	15	257	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1287	6	257	1	24426	\N	24426	\N	\N	1	1	2	f	\N	\N	\N
1288	17	257	1	456	\N	456	\N	\N	2	1	2	f	\N	\N	\N
1289	24	258	2	54	\N	54	\N	\N	1	1	2	f	0	\N	\N
1290	19	258	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
1291	6	258	1	54	\N	54	\N	\N	1	1	2	f	\N	\N	\N
1292	24	259	2	27	\N	27	\N	\N	1	1	2	f	0	\N	\N
1293	19	259	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1294	6	259	1	27	\N	27	\N	\N	1	1	2	f	\N	\N	\N
1295	24	260	2	20796	\N	20796	\N	\N	1	1	2	f	0	\N	\N
1296	26	260	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1297	19	260	2	20796	\N	20796	\N	\N	0	1	2	f	0	\N	\N
1298	9	260	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1299	15	260	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1300	6	260	1	20718	\N	20718	\N	\N	1	1	2	f	\N	\N	\N
1301	17	260	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
1302	19	261	2	1727393	\N	1727393	\N	\N	1	1	2	f	0	\N	\N
1303	9	261	2	11310	\N	11310	\N	\N	2	1	2	f	0	\N	\N
1304	24	261	2	1727393	\N	1727393	\N	\N	0	1	2	f	0	\N	\N
1305	15	261	2	11310	\N	11310	\N	\N	0	1	2	f	0	\N	\N
1306	25	261	2	11296	\N	11296	\N	\N	0	1	2	f	0	\N	\N
1307	23	261	2	151	\N	151	\N	\N	0	1	2	f	0	\N	\N
1308	26	261	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1309	6	261	1	1239454	\N	1239454	\N	\N	1	1	2	f	\N	\N	\N
1310	17	261	1	499249	\N	499249	\N	\N	2	1	2	f	\N	\N	\N
1311	19	262	2	5152	\N	5152	\N	\N	1	1	2	f	0	\N	\N
1312	24	262	2	5152	\N	5152	\N	\N	0	1	2	f	0	\N	\N
1313	6	262	1	5148	\N	5148	\N	\N	1	1	2	f	\N	\N	\N
1314	17	262	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1315	19	263	2	748459	\N	748459	\N	\N	1	1	2	f	0	\N	\N
1316	25	263	2	596	\N	596	\N	\N	2	1	2	f	0	\N	\N
1317	24	263	2	748459	\N	748459	\N	\N	0	1	2	f	0	\N	\N
1318	9	263	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
1319	15	263	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
1320	23	263	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1321	17	263	1	697620	\N	697620	\N	\N	1	1	2	f	\N	\N	\N
1322	6	263	1	51435	\N	51435	\N	\N	2	1	2	f	\N	\N	\N
1323	19	264	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
1324	24	264	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1325	6	264	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
1326	19	265	2	503	\N	503	\N	\N	1	1	2	f	0	\N	\N
1327	26	265	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
1328	24	265	2	503	\N	503	\N	\N	0	1	2	f	0	\N	\N
1329	9	265	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1330	15	265	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1331	6	265	1	513	\N	513	\N	\N	1	1	2	f	\N	\N	\N
1332	19	266	2	63880	\N	63880	\N	\N	1	1	2	f	0	\N	\N
1333	26	266	2	2144	\N	2144	\N	\N	2	1	2	f	0	\N	\N
1334	24	266	2	63880	\N	63880	\N	\N	0	1	2	f	0	\N	\N
1335	9	266	2	2144	\N	2144	\N	\N	0	1	2	f	0	\N	\N
1336	15	266	2	2144	\N	2144	\N	\N	0	1	2	f	0	\N	\N
1337	6	266	1	41471	\N	41471	\N	\N	1	1	2	f	\N	\N	\N
1338	17	266	1	24553	\N	24553	\N	\N	2	1	2	f	\N	\N	\N
1339	2	267	2	1834844	\N	0	\N	\N	1	1	2	f	1834844	\N	\N
1340	24	268	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
1341	19	268	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1342	6	268	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
1343	17	268	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
1344	24	269	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1345	19	269	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1346	6	269	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1347	24	270	2	256440	\N	256440	\N	\N	1	1	2	f	0	\N	\N
1348	25	270	2	18963	\N	18963	\N	\N	2	1	2	f	0	\N	\N
1349	19	270	2	256440	\N	256440	\N	\N	0	1	2	f	0	\N	\N
1350	9	270	2	18963	\N	18963	\N	\N	0	1	2	f	0	\N	\N
1351	15	270	2	18963	\N	18963	\N	\N	0	1	2	f	0	\N	\N
1352	23	270	2	393	\N	393	\N	\N	0	1	2	f	0	\N	\N
1353	6	270	1	271387	\N	271387	\N	\N	1	1	2	f	\N	\N	\N
1354	17	270	1	4016	\N	4016	\N	\N	2	1	2	f	\N	\N	\N
1355	24	271	2	2573	\N	2573	\N	\N	1	1	2	f	0	\N	\N
1356	19	271	2	2573	\N	2573	\N	\N	0	1	2	f	0	\N	\N
1357	6	271	1	2573	\N	2573	\N	\N	1	1	2	f	\N	\N	\N
1358	24	272	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1359	25	272	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1360	19	272	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1361	9	272	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1362	15	272	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1363	6	272	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1364	17	272	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1365	19	273	2	27	\N	27	\N	\N	1	1	2	f	0	\N	\N
1366	24	273	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1367	17	273	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
1368	6	273	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1369	19	274	2	6095	\N	6095	\N	\N	1	1	2	f	0	\N	\N
1370	24	274	2	6095	\N	6095	\N	\N	0	1	2	f	0	\N	\N
1371	6	274	1	6094	\N	6094	\N	\N	1	1	2	f	\N	\N	\N
1372	17	274	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1373	2	275	2	62079	\N	62079	\N	\N	1	1	2	f	0	\N	\N
1374	19	276	2	260	\N	260	\N	\N	1	1	2	f	0	\N	\N
1375	26	276	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1376	24	276	2	260	\N	260	\N	\N	0	1	2	f	0	\N	\N
1377	9	276	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1378	15	276	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1379	6	276	1	260	\N	260	\N	\N	1	1	2	f	\N	\N	\N
1380	17	276	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1381	19	277	2	10438	\N	10438	\N	\N	1	1	2	f	0	\N	\N
1382	24	277	2	10438	\N	10438	\N	\N	0	1	2	f	0	\N	\N
1383	6	277	1	10438	\N	10438	\N	\N	1	1	2	f	\N	\N	\N
1384	19	278	2	756728	\N	756728	\N	\N	1	1	2	f	0	\N	\N
1385	25	278	2	596	\N	596	\N	\N	2	1	2	f	0	\N	\N
1386	24	278	2	756728	\N	756728	\N	\N	0	1	2	f	0	\N	\N
1387	9	278	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
1388	15	278	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
1389	23	278	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1390	17	278	1	705878	\N	705878	\N	\N	1	1	2	f	\N	\N	\N
1391	6	278	1	51446	\N	51446	\N	\N	2	1	2	f	\N	\N	\N
1392	9	279	2	122181	\N	0	\N	\N	1	1	2	f	122181	\N	\N
1393	15	279	2	122181	\N	0	\N	\N	0	1	2	f	122181	\N	\N
1394	2	280	2	7578153	\N	0	\N	\N	1	1	2	f	7578153	\N	\N
1395	4	280	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
1396	22	280	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1397	3	280	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1398	19	281	2	118084	\N	118084	\N	\N	1	1	2	f	0	\N	\N
1399	24	281	2	118084	\N	118084	\N	\N	0	1	2	f	0	\N	\N
1400	6	281	1	117887	\N	117887	\N	\N	1	1	2	f	\N	\N	\N
1401	17	281	1	197	\N	197	\N	\N	2	1	2	f	\N	\N	\N
1402	25	282	2	185109	\N	0	\N	\N	1	1	2	f	185109	\N	\N
1403	9	282	2	185109	\N	0	\N	\N	0	1	2	f	185109	\N	\N
1404	15	282	2	185109	\N	0	\N	\N	0	1	2	f	185109	\N	\N
1405	23	282	2	13896	\N	0	\N	\N	0	1	2	f	13896	\N	\N
1406	11	283	2	107120	\N	0	\N	\N	1	1	2	f	107120	\N	\N
1407	19	284	2	116	\N	116	\N	\N	1	1	2	f	0	\N	\N
1408	24	284	2	116	\N	116	\N	\N	0	1	2	f	0	\N	\N
1409	6	284	1	116	\N	116	\N	\N	1	1	2	f	\N	\N	\N
1410	19	285	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1411	26	285	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
1412	24	285	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1413	9	285	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1414	15	285	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1415	6	285	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
1416	17	285	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1417	19	286	2	135709	\N	135709	\N	\N	1	1	2	f	0	\N	\N
1418	26	286	2	3625	\N	3625	\N	\N	2	1	2	f	0	\N	\N
1419	24	286	2	135709	\N	135709	\N	\N	0	1	2	f	0	\N	\N
1420	9	286	2	3625	\N	3625	\N	\N	0	1	2	f	0	\N	\N
1421	15	286	2	3625	\N	3625	\N	\N	0	1	2	f	0	\N	\N
1422	6	286	1	139255	\N	139255	\N	\N	1	1	2	f	\N	\N	\N
1423	17	286	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
1424	26	287	2	360	\N	360	\N	\N	1	1	2	f	0	\N	\N
1425	19	287	2	101	\N	101	\N	\N	2	1	2	f	0	\N	\N
1426	9	287	2	360	\N	360	\N	\N	0	1	2	f	0	\N	\N
1427	15	287	2	360	\N	360	\N	\N	0	1	2	f	0	\N	\N
1428	24	287	2	101	\N	101	\N	\N	0	1	2	f	0	\N	\N
1429	6	287	1	394	\N	394	\N	\N	1	1	2	f	\N	\N	\N
1430	17	287	1	67	\N	67	\N	\N	2	1	2	f	\N	\N	\N
1431	19	288	2	33901	\N	33901	\N	\N	1	1	2	f	0	\N	\N
1432	9	288	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
1433	24	288	2	33901	\N	33901	\N	\N	0	1	2	f	0	\N	\N
1434	15	288	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1435	26	288	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1436	25	288	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1437	6	288	1	33703	\N	33703	\N	\N	1	1	2	f	\N	\N	\N
1438	17	288	1	204	\N	204	\N	\N	2	1	2	f	\N	\N	\N
1439	19	289	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
1440	24	289	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1441	6	289	1	30	\N	30	\N	\N	1	1	2	f	\N	\N	\N
1442	19	290	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
1443	24	290	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1444	6	290	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
1445	2	291	2	34690	\N	0	\N	\N	1	1	2	f	34690	\N	\N
1446	26	292	2	13496	\N	13496	\N	\N	1	1	2	f	0	\N	\N
1447	19	292	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
1448	9	292	2	13496	\N	13496	\N	\N	0	1	2	f	0	\N	\N
1449	15	292	2	13496	\N	13496	\N	\N	0	1	2	f	0	\N	\N
1450	24	292	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1451	6	292	1	13497	\N	13497	\N	\N	1	1	2	f	\N	\N	\N
1452	17	292	1	9	\N	9	\N	\N	2	1	2	f	\N	\N	\N
1453	6	293	2	1926493	\N	1926493	\N	\N	1	1	2	f	0	\N	\N
1454	2	293	1	86655	\N	86655	\N	\N	1	1	2	f	\N	\N	\N
1455	6	294	2	14802	\N	0	\N	\N	1	1	2	f	14802	\N	\N
1456	24	295	2	1150	\N	1150	\N	\N	1	1	2	f	0	\N	\N
1457	26	295	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1458	19	295	2	1150	\N	1150	\N	\N	0	1	2	f	0	\N	\N
1459	9	295	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1460	15	295	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1461	6	295	1	1149	\N	1149	\N	\N	1	1	2	f	\N	\N	\N
1462	17	295	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1463	24	296	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1464	26	296	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1465	19	296	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1466	9	296	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1467	15	296	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1468	6	296	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1469	24	297	2	3963	\N	3963	\N	\N	1	1	2	f	0	\N	\N
1470	26	297	2	49	\N	49	\N	\N	2	1	2	f	0	\N	\N
1471	19	297	2	3963	\N	3963	\N	\N	0	1	2	f	0	\N	\N
1472	9	297	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
1473	15	297	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
1474	6	297	1	3943	\N	3943	\N	\N	1	1	2	f	\N	\N	\N
1475	17	297	1	69	\N	69	\N	\N	2	1	2	f	\N	\N	\N
1476	24	298	2	292862	\N	292862	\N	\N	1	1	2	f	0	\N	\N
1477	26	298	2	58628	\N	58628	\N	\N	2	1	2	f	0	\N	\N
1478	19	298	2	292862	\N	292862	\N	\N	0	1	2	f	0	\N	\N
1479	9	298	2	58628	\N	58628	\N	\N	0	1	2	f	0	\N	\N
1480	15	298	2	58628	\N	58628	\N	\N	0	1	2	f	0	\N	\N
1481	6	298	1	349488	\N	349488	\N	\N	1	1	2	f	\N	\N	\N
1482	17	298	1	2002	\N	2002	\N	\N	2	1	2	f	\N	\N	\N
1483	24	299	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
1484	19	299	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
1485	6	299	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
1486	24	300	2	20915	\N	20915	\N	\N	1	1	2	f	0	\N	\N
1487	9	300	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
1488	19	300	2	20915	\N	20915	\N	\N	0	1	2	f	0	\N	\N
1489	15	300	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1490	26	300	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1491	25	300	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1492	17	300	1	19134	\N	19134	\N	\N	1	1	2	f	\N	\N	\N
1493	6	300	1	1791	\N	1791	\N	\N	2	1	2	f	\N	\N	\N
1494	24	301	2	195	\N	195	\N	\N	1	1	2	f	0	\N	\N
1495	26	301	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1496	19	301	2	195	\N	195	\N	\N	0	1	2	f	0	\N	\N
1497	9	301	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1498	15	301	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1499	6	301	1	196	\N	196	\N	\N	1	1	2	f	\N	\N	\N
1500	24	302	2	1006	\N	1006	\N	\N	1	1	2	f	0	\N	\N
1501	26	302	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
1502	19	302	2	1006	\N	1006	\N	\N	0	1	2	f	0	\N	\N
1503	9	302	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1504	15	302	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1505	6	302	1	1018	\N	1018	\N	\N	1	1	2	f	\N	\N	\N
1506	17	302	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1507	26	303	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1508	9	303	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1509	15	303	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1510	6	303	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1511	24	304	2	69684	\N	69684	\N	\N	1	1	2	f	0	\N	\N
1512	9	304	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
1513	19	304	2	69684	\N	69684	\N	\N	0	1	2	f	0	\N	\N
1514	15	304	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1515	25	304	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1516	26	304	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1517	6	304	1	69300	\N	69300	\N	\N	1	1	2	f	\N	\N	\N
1518	17	304	1	392	\N	392	\N	\N	2	1	2	f	\N	\N	\N
1519	24	305	2	35	\N	35	\N	\N	1	1	2	f	0	\N	\N
1520	19	305	2	35	\N	35	\N	\N	0	1	2	f	0	\N	\N
1521	6	305	1	35	\N	35	\N	\N	1	1	2	f	\N	\N	\N
1522	24	306	2	8734	\N	8734	\N	\N	1	1	2	f	0	\N	\N
1523	9	306	2	18	\N	18	\N	\N	2	1	2	f	0	\N	\N
1524	19	306	2	8734	\N	8734	\N	\N	0	1	2	f	0	\N	\N
1525	15	306	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1526	25	306	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1527	26	306	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1528	6	306	1	8630	\N	8630	\N	\N	1	1	2	f	\N	\N	\N
1529	17	306	1	122	\N	122	\N	\N	2	1	2	f	\N	\N	\N
1530	19	307	2	2259	\N	2259	\N	\N	1	1	2	f	0	\N	\N
1531	26	307	2	14	\N	14	\N	\N	2	1	2	f	0	\N	\N
1532	24	307	2	2259	\N	2259	\N	\N	0	1	2	f	0	\N	\N
1533	9	307	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1534	15	307	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1535	6	307	1	2144	\N	2144	\N	\N	1	1	2	f	\N	\N	\N
1536	17	307	1	129	\N	129	\N	\N	2	1	2	f	\N	\N	\N
1537	19	308	2	105	\N	105	\N	\N	1	1	2	f	0	\N	\N
1538	24	308	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
1539	6	308	1	105	\N	105	\N	\N	1	1	2	f	\N	\N	\N
1540	19	309	2	242783	\N	242783	\N	\N	1	1	2	f	0	\N	\N
1541	9	309	2	88	\N	88	\N	\N	2	1	2	f	0	\N	\N
1542	24	309	2	242783	\N	242783	\N	\N	0	1	2	f	0	\N	\N
1543	15	309	2	88	\N	88	\N	\N	0	1	2	f	0	\N	\N
1544	26	309	2	70	\N	70	\N	\N	0	1	2	f	0	\N	\N
1545	25	309	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1546	23	309	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1547	6	309	1	190445	\N	190445	\N	\N	1	1	2	f	\N	\N	\N
1548	17	309	1	52426	\N	52426	\N	\N	2	1	2	f	\N	\N	\N
1549	2	310	2	3834	\N	3834	\N	\N	1	1	2	f	0	\N	\N
1550	20	311	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1551	20	311	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1552	19	312	2	549	\N	549	\N	\N	1	1	2	f	0	\N	\N
1553	26	312	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1554	24	312	2	549	\N	549	\N	\N	0	1	2	f	0	\N	\N
1555	9	312	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1556	15	312	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1557	6	312	1	548	\N	548	\N	\N	1	1	2	f	\N	\N	\N
1558	17	312	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1559	19	313	2	135709	\N	135709	\N	\N	1	1	2	f	0	\N	\N
1560	26	313	2	3625	\N	3625	\N	\N	2	1	2	f	0	\N	\N
1561	24	313	2	135709	\N	135709	\N	\N	0	1	2	f	0	\N	\N
1562	9	313	2	3625	\N	3625	\N	\N	0	1	2	f	0	\N	\N
1563	15	313	2	3625	\N	3625	\N	\N	0	1	2	f	0	\N	\N
1564	6	313	1	139255	\N	139255	\N	\N	1	1	2	f	\N	\N	\N
1565	17	313	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
1566	26	314	2	40	\N	40	\N	\N	1	1	2	f	0	\N	\N
1567	24	314	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1568	9	314	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1569	15	314	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1570	19	314	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1571	6	314	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
1572	24	315	2	36882	\N	36882	\N	\N	1	1	2	f	0	\N	\N
1573	26	315	2	103	\N	103	\N	\N	2	1	2	f	0	\N	\N
1574	19	315	2	36882	\N	36882	\N	\N	0	1	2	f	0	\N	\N
1575	9	315	2	103	\N	103	\N	\N	0	1	2	f	0	\N	\N
1576	15	315	2	103	\N	103	\N	\N	0	1	2	f	0	\N	\N
1577	6	315	1	36948	\N	36948	\N	\N	1	1	2	f	\N	\N	\N
1578	17	315	1	37	\N	37	\N	\N	2	1	2	f	\N	\N	\N
1579	2	316	2	16100	\N	0	\N	\N	1	1	2	f	16100	\N	\N
1580	26	317	2	7557	\N	7557	\N	\N	1	1	2	f	0	\N	\N
1581	24	317	2	5221	\N	5221	\N	\N	2	1	2	f	0	\N	\N
1582	9	317	2	7557	\N	7557	\N	\N	0	1	2	f	0	\N	\N
1583	15	317	2	7557	\N	7557	\N	\N	0	1	2	f	0	\N	\N
1584	19	317	2	5221	\N	5221	\N	\N	0	1	2	f	0	\N	\N
1585	6	317	1	12740	\N	12740	\N	\N	1	1	2	f	\N	\N	\N
1586	17	317	1	38	\N	38	\N	\N	2	1	2	f	\N	\N	\N
1587	24	318	2	161007	\N	161007	\N	\N	1	1	2	f	0	\N	\N
1588	9	318	2	2745	\N	2745	\N	\N	2	1	2	f	0	\N	\N
1589	19	318	2	161007	\N	161007	\N	\N	0	1	2	f	0	\N	\N
1590	15	318	2	2745	\N	2745	\N	\N	0	1	2	f	0	\N	\N
1591	26	318	2	1575	\N	1575	\N	\N	0	1	2	f	0	\N	\N
1592	25	318	2	1170	\N	1170	\N	\N	0	1	2	f	0	\N	\N
1593	23	318	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1594	6	318	1	139044	\N	139044	\N	\N	1	1	2	f	\N	\N	\N
1595	17	318	1	24708	\N	24708	\N	\N	2	1	2	f	\N	\N	\N
1596	17	319	2	98117	\N	98117	\N	\N	1	1	2	f	0	\N	\N
1597	12	319	1	95636	\N	95636	\N	\N	1	1	2	f	\N	\N	\N
1598	24	320	2	1233	\N	1233	\N	\N	1	1	2	f	0	\N	\N
1599	19	320	2	1233	\N	1233	\N	\N	0	1	2	f	0	\N	\N
1600	6	320	1	1231	\N	1231	\N	\N	1	1	2	f	\N	\N	\N
1601	17	320	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1602	24	321	2	80	\N	80	\N	\N	1	1	2	f	0	\N	\N
1603	19	321	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
1604	17	321	1	75	\N	75	\N	\N	1	1	2	f	\N	\N	\N
1605	6	321	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1606	24	322	2	6750	\N	6750	\N	\N	1	1	2	f	0	\N	\N
1607	26	322	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
1608	19	322	2	6750	\N	6750	\N	\N	0	1	2	f	0	\N	\N
1609	9	322	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1610	15	322	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1611	6	322	1	6758	\N	6758	\N	\N	1	1	2	f	\N	\N	\N
1612	17	322	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1613	24	323	2	258	\N	258	\N	\N	1	1	2	f	0	\N	\N
1614	26	323	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1615	19	323	2	258	\N	258	\N	\N	0	1	2	f	0	\N	\N
1616	9	323	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1617	15	323	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1618	6	323	1	258	\N	258	\N	\N	1	1	2	f	\N	\N	\N
1619	17	323	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1620	24	324	2	2340	\N	2340	\N	\N	1	1	2	f	0	\N	\N
1621	26	324	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
1622	19	324	2	2340	\N	2340	\N	\N	0	1	2	f	0	\N	\N
1623	9	324	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1624	15	324	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1625	6	324	1	2318	\N	2318	\N	\N	1	1	2	f	\N	\N	\N
1626	17	324	1	26	\N	26	\N	\N	2	1	2	f	\N	\N	\N
1627	26	325	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1628	19	325	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
1629	9	325	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1630	15	325	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1631	24	325	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1632	6	325	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
1633	26	326	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1634	24	326	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1635	9	326	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1636	15	326	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1637	19	326	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1638	6	326	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1639	19	327	2	1285693	\N	1285693	\N	\N	1	1	2	f	0	\N	\N
1640	9	327	2	17252	\N	17252	\N	\N	2	1	2	f	0	\N	\N
1641	24	327	2	1285693	\N	1285693	\N	\N	0	1	2	f	0	\N	\N
1642	15	327	2	17252	\N	17252	\N	\N	0	1	2	f	0	\N	\N
1643	26	327	2	17244	\N	17244	\N	\N	0	1	2	f	0	\N	\N
1644	25	327	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1645	6	327	1	1299241	\N	1299241	\N	\N	1	1	2	f	\N	\N	\N
1646	17	327	1	3704	\N	3704	\N	\N	2	1	2	f	\N	\N	\N
1647	2	328	2	3834	\N	0	\N	\N	1	1	2	f	3834	\N	\N
1648	9	329	2	1842613	\N	1842613	\N	\N	1	1	2	f	0	\N	\N
1649	15	329	2	1842613	\N	1842613	\N	\N	0	1	2	f	0	\N	\N
1650	12	329	1	1842613	\N	1842613	\N	\N	1	1	2	f	\N	\N	\N
1651	9	330	2	548153	\N	548153	\N	\N	1	1	2	f	0	\N	\N
1652	15	330	2	548153	\N	548153	\N	\N	0	1	2	f	0	\N	\N
1653	25	330	2	513579	\N	513579	\N	\N	0	1	2	f	0	\N	\N
1654	23	330	2	16301	\N	16301	\N	\N	0	1	2	f	0	\N	\N
1655	2	330	1	27364	\N	27364	\N	\N	1	1	2	f	\N	\N	\N
1656	19	331	2	32	\N	32	\N	\N	1	1	2	f	0	\N	\N
1657	26	331	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
1658	24	331	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
1659	9	331	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1660	15	331	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1661	6	331	1	59	\N	59	\N	\N	1	1	2	f	\N	\N	\N
1662	17	331	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1663	19	332	2	1757	\N	1757	\N	\N	1	1	2	f	0	\N	\N
1664	26	332	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
1665	24	332	2	1757	\N	1757	\N	\N	0	1	2	f	0	\N	\N
1666	9	332	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1667	15	332	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1668	6	332	1	1766	\N	1766	\N	\N	1	1	2	f	\N	\N	\N
1669	2	333	2	22357	\N	0	\N	\N	1	1	2	f	22357	\N	\N
1670	19	334	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
1671	25	334	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
1672	24	334	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
1673	9	334	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1674	15	334	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1675	6	334	1	59	\N	59	\N	\N	1	1	2	f	\N	\N	\N
1676	17	334	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1677	19	335	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1678	24	335	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1679	6	335	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1680	19	336	2	159711	\N	159711	\N	\N	1	1	2	f	0	\N	\N
1681	9	336	2	2739	\N	2739	\N	\N	2	1	2	f	0	\N	\N
1682	24	336	2	159711	\N	159711	\N	\N	0	1	2	f	0	\N	\N
1683	15	336	2	2739	\N	2739	\N	\N	0	1	2	f	0	\N	\N
1684	26	336	2	1575	\N	1575	\N	\N	0	1	2	f	0	\N	\N
1685	25	336	2	1164	\N	1164	\N	\N	0	1	2	f	0	\N	\N
1686	23	336	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1687	6	336	1	137748	\N	137748	\N	\N	1	1	2	f	\N	\N	\N
1688	17	336	1	24702	\N	24702	\N	\N	2	1	2	f	\N	\N	\N
1689	19	337	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
1690	26	337	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1691	24	337	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1692	9	337	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1693	15	337	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1694	6	337	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
1695	26	338	2	62	\N	62	\N	\N	1	1	2	f	0	\N	\N
1696	19	338	2	30	\N	30	\N	\N	2	1	2	f	0	\N	\N
1697	9	338	2	62	\N	62	\N	\N	0	1	2	f	0	\N	\N
1698	15	338	2	62	\N	62	\N	\N	0	1	2	f	0	\N	\N
1699	24	338	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1700	6	338	1	92	\N	92	\N	\N	1	1	2	f	\N	\N	\N
1701	19	339	2	312485	\N	312485	\N	\N	1	1	2	f	0	\N	\N
1702	26	339	2	7563	\N	7563	\N	\N	2	1	2	f	0	\N	\N
1703	24	339	2	312485	\N	312485	\N	\N	0	1	2	f	0	\N	\N
1704	9	339	2	7563	\N	7563	\N	\N	0	1	2	f	0	\N	\N
1705	15	339	2	7563	\N	7563	\N	\N	0	1	2	f	0	\N	\N
1706	6	339	1	319148	\N	319148	\N	\N	1	1	2	f	\N	\N	\N
1707	17	339	1	900	\N	900	\N	\N	2	1	2	f	\N	\N	\N
1708	2	340	2	1594	\N	1594	\N	\N	1	1	2	f	0	\N	\N
1709	24	341	2	248	\N	248	\N	\N	1	1	2	f	0	\N	\N
1710	19	341	2	248	\N	248	\N	\N	0	1	2	f	0	\N	\N
1711	6	341	1	247	\N	247	\N	\N	1	1	2	f	\N	\N	\N
1712	17	341	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1713	24	342	2	449509	\N	449509	\N	\N	1	1	2	f	0	\N	\N
1714	25	342	2	426	\N	426	\N	\N	2	1	2	f	0	\N	\N
1715	19	342	2	449509	\N	449509	\N	\N	0	1	2	f	0	\N	\N
1716	9	342	2	426	\N	426	\N	\N	0	1	2	f	0	\N	\N
1717	15	342	2	426	\N	426	\N	\N	0	1	2	f	0	\N	\N
1718	17	342	1	447345	\N	447345	\N	\N	1	1	2	f	\N	\N	\N
1719	6	342	1	2590	\N	2590	\N	\N	2	1	2	f	\N	\N	\N
1720	24	343	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
1721	26	343	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1722	19	343	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
1723	9	343	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1724	15	343	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1725	6	343	1	247	\N	247	\N	\N	1	1	2	f	\N	\N	\N
1726	26	344	2	59757	\N	59757	\N	\N	1	1	2	f	0	\N	\N
1727	9	344	2	59757	\N	59757	\N	\N	0	1	2	f	0	\N	\N
1728	15	344	2	59757	\N	59757	\N	\N	0	1	2	f	0	\N	\N
1729	2	344	1	59757	\N	59757	\N	\N	1	1	2	f	\N	\N	\N
1730	24	345	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
1731	26	345	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1732	19	345	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
1733	9	345	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1734	15	345	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1735	6	345	1	48	\N	48	\N	\N	1	1	2	f	\N	\N	\N
1736	17	345	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1737	24	346	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1738	25	346	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1739	19	346	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1740	9	346	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1741	15	346	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1742	6	346	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1743	24	347	2	68310	\N	68310	\N	\N	1	1	2	f	0	\N	\N
1744	9	347	2	8333	\N	8333	\N	\N	2	1	2	f	0	\N	\N
1745	19	347	2	68310	\N	68310	\N	\N	0	1	2	f	0	\N	\N
1746	15	347	2	8333	\N	8333	\N	\N	0	1	2	f	0	\N	\N
1747	26	347	2	8331	\N	8331	\N	\N	0	1	2	f	0	\N	\N
1748	25	347	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1749	6	347	1	75356	\N	75356	\N	\N	1	1	2	f	\N	\N	\N
1750	17	347	1	1287	\N	1287	\N	\N	2	1	2	f	\N	\N	\N
1751	24	348	2	1742	\N	1742	\N	\N	1	1	2	f	0	\N	\N
1752	19	348	2	1742	\N	1742	\N	\N	0	1	2	f	0	\N	\N
1753	6	348	1	1741	\N	1741	\N	\N	1	1	2	f	\N	\N	\N
1754	17	348	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1755	2	349	2	1834831	\N	0	\N	\N	1	1	2	f	1834831	\N	\N
1756	26	350	2	61	\N	61	\N	\N	1	1	2	f	0	\N	\N
1757	24	350	2	27	\N	27	\N	\N	2	1	2	f	0	\N	\N
1758	9	350	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1759	15	350	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1760	19	350	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1761	17	350	1	83	\N	83	\N	\N	1	1	2	f	\N	\N	\N
1762	6	350	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1763	24	351	2	1995	\N	1995	\N	\N	1	1	2	f	0	\N	\N
1764	25	351	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1765	19	351	2	1995	\N	1995	\N	\N	0	1	2	f	0	\N	\N
1766	9	351	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1767	15	351	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1768	6	351	1	1996	\N	1996	\N	\N	1	1	2	f	\N	\N	\N
1769	24	352	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1770	19	352	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1771	6	352	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1772	24	353	2	2552	\N	2552	\N	\N	1	1	2	f	0	\N	\N
1773	9	353	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
1774	19	353	2	2552	\N	2552	\N	\N	0	1	2	f	0	\N	\N
1775	15	353	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1776	26	353	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1777	23	353	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1778	25	353	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1779	6	353	1	2203	\N	2203	\N	\N	1	1	2	f	\N	\N	\N
1780	17	353	1	364	\N	364	\N	\N	2	1	2	f	\N	\N	\N
1781	24	354	2	13650	\N	13650	\N	\N	1	1	2	f	0	\N	\N
1782	9	354	2	53	\N	53	\N	\N	2	1	2	f	0	\N	\N
1783	19	354	2	13650	\N	13650	\N	\N	0	1	2	f	0	\N	\N
1784	15	354	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
1785	25	354	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1786	23	354	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1787	26	354	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1788	6	354	1	13566	\N	13566	\N	\N	1	1	2	f	\N	\N	\N
1789	17	354	1	137	\N	137	\N	\N	2	1	2	f	\N	\N	\N
1790	24	355	2	111	\N	111	\N	\N	1	1	2	f	0	\N	\N
1791	26	355	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1792	19	355	2	111	\N	111	\N	\N	0	1	2	f	0	\N	\N
1793	9	355	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1794	15	355	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1795	6	355	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
1796	17	355	1	46	\N	46	\N	\N	2	1	2	f	\N	\N	\N
1797	21	356	2	645741	\N	0	\N	\N	1	1	2	f	645741	\N	\N
1798	5	356	2	645741	\N	0	\N	\N	0	1	2	f	645741	\N	\N
1799	26	357	2	25849	\N	25849	\N	\N	1	1	2	f	0	\N	\N
1800	24	357	2	2630	\N	2630	\N	\N	2	1	2	f	0	\N	\N
1801	9	357	2	25849	\N	25849	\N	\N	0	1	2	f	0	\N	\N
1802	15	357	2	25849	\N	25849	\N	\N	0	1	2	f	0	\N	\N
1803	19	357	2	2630	\N	2630	\N	\N	0	1	2	f	0	\N	\N
1804	6	357	1	28390	\N	28390	\N	\N	1	1	2	f	\N	\N	\N
1805	17	357	1	89	\N	89	\N	\N	2	1	2	f	\N	\N	\N
1806	24	358	2	2489	\N	2489	\N	\N	1	1	2	f	0	\N	\N
1807	9	358	2	200	\N	200	\N	\N	2	1	2	f	0	\N	\N
1808	19	358	2	2489	\N	2489	\N	\N	0	1	2	f	0	\N	\N
1809	15	358	2	200	\N	200	\N	\N	0	1	2	f	0	\N	\N
1810	25	358	2	198	\N	198	\N	\N	0	1	2	f	0	\N	\N
1811	26	358	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1812	6	358	1	2464	\N	2464	\N	\N	1	1	2	f	\N	\N	\N
1813	17	358	1	225	\N	225	\N	\N	2	1	2	f	\N	\N	\N
1814	19	359	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1815	24	359	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1816	6	359	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1817	17	359	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1818	19	360	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1819	24	360	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1820	6	360	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1821	17	360	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1822	19	361	2	524	\N	524	\N	\N	1	1	2	f	0	\N	\N
1823	24	361	2	524	\N	524	\N	\N	0	1	2	f	0	\N	\N
1824	6	361	1	523	\N	523	\N	\N	1	1	2	f	\N	\N	\N
1825	17	361	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1826	8	362	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1827	8	362	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1828	19	363	2	4660	\N	4660	\N	\N	1	1	2	f	0	\N	\N
1829	9	363	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
1830	24	363	2	4660	\N	4660	\N	\N	0	1	2	f	0	\N	\N
1831	15	363	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1832	26	363	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1833	25	363	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1834	6	363	1	4661	\N	4661	\N	\N	1	1	2	f	\N	\N	\N
1835	17	363	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
1836	19	364	2	530744	\N	530744	\N	\N	1	1	2	f	0	\N	\N
1837	9	364	2	6135	\N	6135	\N	\N	2	1	2	f	0	\N	\N
1838	24	364	2	530744	\N	530744	\N	\N	0	1	2	f	0	\N	\N
1839	15	364	2	6135	\N	6135	\N	\N	0	1	2	f	0	\N	\N
1840	26	364	2	6079	\N	6079	\N	\N	0	1	2	f	0	\N	\N
1841	25	364	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1842	6	364	1	534302	\N	534302	\N	\N	1	1	2	f	\N	\N	\N
1843	17	364	1	2577	\N	2577	\N	\N	2	1	2	f	\N	\N	\N
1844	19	365	2	79	\N	79	\N	\N	1	1	2	f	0	\N	\N
1845	24	365	2	79	\N	79	\N	\N	0	1	2	f	0	\N	\N
1846	6	365	1	79	\N	79	\N	\N	1	1	2	f	\N	\N	\N
1847	19	366	2	119	\N	119	\N	\N	1	1	2	f	0	\N	\N
1848	24	366	2	119	\N	119	\N	\N	0	1	2	f	0	\N	\N
1849	6	366	1	118	\N	118	\N	\N	1	1	2	f	\N	\N	\N
1850	17	366	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1851	19	367	2	45	\N	45	\N	\N	1	1	2	f	0	\N	\N
1852	24	367	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
1853	17	367	1	41	\N	41	\N	\N	1	1	2	f	\N	\N	\N
1854	6	367	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1855	21	368	2	7042637	\N	0	\N	\N	1	1	2	f	7042637	\N	\N
1856	25	368	2	319911	\N	0	\N	\N	2	1	2	f	319911	\N	\N
1857	5	368	2	7042637	\N	0	\N	\N	0	1	2	f	7042637	\N	\N
1858	9	368	2	319911	\N	0	\N	\N	0	1	2	f	319911	\N	\N
1859	15	368	2	319911	\N	0	\N	\N	0	1	2	f	319911	\N	\N
1860	23	368	2	24236	\N	0	\N	\N	0	1	2	f	24236	\N	\N
1861	19	369	2	1027	\N	1027	\N	\N	1	1	2	f	0	\N	\N
1862	24	369	2	1027	\N	1027	\N	\N	0	1	2	f	0	\N	\N
1863	6	369	1	863	\N	863	\N	\N	1	1	2	f	\N	\N	\N
1864	17	369	1	164	\N	164	\N	\N	2	1	2	f	\N	\N	\N
1865	19	370	2	284	\N	284	\N	\N	1	1	2	f	0	\N	\N
1866	25	370	2	14	\N	14	\N	\N	2	1	2	f	0	\N	\N
1867	24	370	2	284	\N	284	\N	\N	0	1	2	f	0	\N	\N
1868	9	370	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1869	15	370	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1870	6	370	1	292	\N	292	\N	\N	1	1	2	f	\N	\N	\N
1871	17	370	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
1872	19	371	2	21656	\N	21656	\N	\N	1	1	2	f	0	\N	\N
1873	9	371	2	10101	\N	10101	\N	\N	2	1	2	f	0	\N	\N
1874	24	371	2	21656	\N	21656	\N	\N	0	1	2	f	0	\N	\N
1875	15	371	2	10101	\N	10101	\N	\N	0	1	2	f	0	\N	\N
1876	26	371	2	10100	\N	10100	\N	\N	0	1	2	f	0	\N	\N
1877	25	371	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1878	6	371	1	31747	\N	31747	\N	\N	1	1	2	f	\N	\N	\N
1879	17	371	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
1880	19	372	2	4183	\N	4183	\N	\N	1	1	2	f	0	\N	\N
1881	24	372	2	4183	\N	4183	\N	\N	0	1	2	f	0	\N	\N
1882	6	372	1	4166	\N	4166	\N	\N	1	1	2	f	\N	\N	\N
1883	17	372	1	17	\N	17	\N	\N	2	1	2	f	\N	\N	\N
1884	24	373	2	48840	\N	48840	\N	\N	1	1	2	f	0	\N	\N
1885	9	373	2	115	\N	115	\N	\N	2	1	2	f	0	\N	\N
1886	19	373	2	48840	\N	48840	\N	\N	0	1	2	f	0	\N	\N
1887	15	373	2	115	\N	115	\N	\N	0	1	2	f	0	\N	\N
1888	26	373	2	93	\N	93	\N	\N	0	1	2	f	0	\N	\N
1889	25	373	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1890	6	373	1	42600	\N	42600	\N	\N	1	1	2	f	\N	\N	\N
1891	17	373	1	6355	\N	6355	\N	\N	2	1	2	f	\N	\N	\N
1892	25	374	2	313448	\N	0	\N	\N	1	1	2	f	313448	\N	\N
1893	9	374	2	313448	\N	0	\N	\N	0	1	2	f	313448	\N	\N
1894	15	374	2	313448	\N	0	\N	\N	0	1	2	f	313448	\N	\N
1895	23	374	2	15983	\N	0	\N	\N	0	1	2	f	15983	\N	\N
1896	24	375	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
1897	19	375	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1898	6	375	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
1899	17	375	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1900	24	376	2	187	\N	187	\N	\N	1	1	2	f	0	\N	\N
1901	26	376	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
1902	19	376	2	187	\N	187	\N	\N	0	1	2	f	0	\N	\N
1903	9	376	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1904	15	376	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1905	6	376	1	187	\N	187	\N	\N	1	1	2	f	\N	\N	\N
1906	17	376	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1907	24	377	2	3527	\N	3527	\N	\N	1	1	2	f	0	\N	\N
1908	19	377	2	3527	\N	3527	\N	\N	0	1	2	f	0	\N	\N
1909	6	377	1	3310	\N	3310	\N	\N	1	1	2	f	\N	\N	\N
1910	17	377	1	217	\N	217	\N	\N	2	1	2	f	\N	\N	\N
1911	24	378	2	1461	\N	1461	\N	\N	1	1	2	f	0	\N	\N
1912	19	378	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1913	6	378	1	1446	\N	1446	\N	\N	1	1	2	f	\N	\N	\N
1914	17	378	1	15	\N	15	\N	\N	2	1	2	f	\N	\N	\N
1915	13	379	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1916	13	379	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1917	24	380	2	61697	\N	61697	\N	\N	1	1	2	f	0	\N	\N
1918	9	380	2	258	\N	258	\N	\N	2	1	2	f	0	\N	\N
1919	19	380	2	61697	\N	61697	\N	\N	0	1	2	f	0	\N	\N
1920	15	380	2	258	\N	258	\N	\N	0	1	2	f	0	\N	\N
1921	26	380	2	254	\N	254	\N	\N	0	1	2	f	0	\N	\N
1922	25	380	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1923	6	380	1	61834	\N	61834	\N	\N	1	1	2	f	\N	\N	\N
1924	17	380	1	121	\N	121	\N	\N	2	1	2	f	\N	\N	\N
1925	21	381	2	1441897	\N	1441897	\N	\N	1	1	2	f	0	\N	\N
1926	25	381	2	20505	\N	20505	\N	\N	2	1	2	f	0	\N	\N
1927	5	381	2	1441897	\N	1441897	\N	\N	0	1	2	f	0	\N	\N
1928	9	381	2	20505	\N	20505	\N	\N	0	1	2	f	0	\N	\N
1929	15	381	2	20505	\N	20505	\N	\N	0	1	2	f	0	\N	\N
1930	21	382	2	11627612	\N	11627612	\N	\N	1	1	2	f	0	\N	\N
1931	5	382	2	11627612	\N	11627612	\N	\N	0	1	2	f	0	\N	\N
1932	12	382	1	11627612	\N	11627612	\N	\N	1	1	2	f	\N	\N	\N
1933	2	383	2	100763	\N	0	\N	\N	1	1	2	f	100763	\N	\N
1934	19	385	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
1935	24	385	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1936	6	385	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
1937	17	385	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1938	26	386	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
1939	19	386	2	22	\N	22	\N	\N	2	1	2	f	0	\N	\N
1940	9	386	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
1941	15	386	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
1942	24	386	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1943	6	386	1	65	\N	65	\N	\N	1	1	2	f	\N	\N	\N
1944	17	386	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
1945	26	387	2	76	\N	76	\N	\N	1	1	2	f	0	\N	\N
1946	19	387	2	17	\N	17	\N	\N	2	1	2	f	0	\N	\N
1947	9	387	2	76	\N	76	\N	\N	0	1	2	f	0	\N	\N
1948	15	387	2	76	\N	76	\N	\N	0	1	2	f	0	\N	\N
1949	24	387	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1950	6	387	1	91	\N	91	\N	\N	1	1	2	f	\N	\N	\N
1951	17	387	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1952	19	388	2	567	\N	567	\N	\N	1	1	2	f	0	\N	\N
1953	24	388	2	567	\N	567	\N	\N	0	1	2	f	0	\N	\N
1954	6	388	1	551	\N	551	\N	\N	1	1	2	f	\N	\N	\N
1955	17	388	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
1956	24	389	2	84	\N	84	\N	\N	1	1	2	f	0	\N	\N
1957	23	389	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1958	19	389	2	84	\N	84	\N	\N	0	1	2	f	0	\N	\N
1959	9	389	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1960	15	389	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1961	25	389	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1962	6	389	1	84	\N	84	\N	\N	1	1	2	f	\N	\N	\N
1963	17	389	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1964	26	390	2	478	\N	478	\N	\N	1	1	2	f	0	\N	\N
1965	24	390	2	56	\N	56	\N	\N	2	1	2	f	0	\N	\N
1966	9	390	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
1967	15	390	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
1968	19	390	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1969	6	390	1	524	\N	524	\N	\N	1	1	2	f	\N	\N	\N
1970	17	390	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
1971	24	391	2	20877	\N	20877	\N	\N	1	1	2	f	0	\N	\N
1972	26	391	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1973	19	391	2	20877	\N	20877	\N	\N	0	1	2	f	0	\N	\N
1974	9	391	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1975	15	391	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1976	6	391	1	20799	\N	20799	\N	\N	1	1	2	f	\N	\N	\N
1977	17	391	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
1978	21	392	2	2704439	\N	2704439	\N	\N	1	1	2	f	0	\N	\N
1979	26	392	2	29995	\N	29995	\N	\N	2	1	2	f	0	\N	\N
1980	5	392	2	2704439	\N	2704439	\N	\N	0	1	2	f	0	\N	\N
1981	9	392	2	29995	\N	29995	\N	\N	0	1	2	f	0	\N	\N
1982	15	392	2	29995	\N	29995	\N	\N	0	1	2	f	0	\N	\N
1983	9	392	1	3093579	\N	3093579	\N	\N	1	1	2	f	\N	\N	\N
1984	15	392	1	3093579	\N	3093579	\N	\N	0	1	2	f	\N	\N	\N
1985	24	393	2	8966	\N	8966	\N	\N	1	1	2	f	0	\N	\N
1986	23	393	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1987	19	393	2	8966	\N	8966	\N	\N	0	1	2	f	0	\N	\N
1988	9	393	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1989	15	393	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1990	25	393	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1991	17	393	1	5166	\N	5166	\N	\N	1	1	2	f	\N	\N	\N
1992	6	393	1	3801	\N	3801	\N	\N	2	1	2	f	\N	\N	\N
1993	24	394	2	8879	\N	8879	\N	\N	1	1	2	f	0	\N	\N
1994	19	394	2	8879	\N	8879	\N	\N	0	1	2	f	0	\N	\N
1995	17	394	1	5164	\N	5164	\N	\N	1	1	2	f	\N	\N	\N
1996	6	394	1	3715	\N	3715	\N	\N	2	1	2	f	\N	\N	\N
1997	19	395	2	107628	\N	107628	\N	\N	1	1	2	f	0	\N	\N
1998	25	395	2	78	\N	78	\N	\N	2	1	2	f	0	\N	\N
1999	24	395	2	107628	\N	107628	\N	\N	0	1	2	f	0	\N	\N
2000	9	395	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
2001	15	395	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
2002	17	395	1	85336	\N	85336	\N	\N	1	1	2	f	\N	\N	\N
2003	6	395	1	22370	\N	22370	\N	\N	2	1	2	f	\N	\N	\N
2004	11	396	2	279	\N	0	\N	\N	1	1	2	f	279	\N	\N
2005	19	397	2	205560	\N	205560	\N	\N	1	1	2	f	0	\N	\N
2006	9	397	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
2007	24	397	2	205560	\N	205560	\N	\N	0	1	2	f	0	\N	\N
2008	15	397	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2009	25	397	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2010	26	397	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2011	17	397	1	145701	\N	145701	\N	\N	1	1	2	f	\N	\N	\N
2012	6	397	1	59867	\N	59867	\N	\N	2	1	2	f	\N	\N	\N
2013	2	400	2	20544012	\N	20544012	\N	\N	1	1	2	f	0	\N	\N
2014	21	400	1	13063699	\N	13063699	\N	\N	1	1	2	f	\N	\N	\N
2015	6	400	1	4393839	\N	4393839	\N	\N	2	1	2	f	\N	\N	\N
2016	9	400	1	2530649	\N	2530649	\N	\N	3	1	2	f	\N	\N	\N
2017	17	400	1	430832	\N	430832	\N	\N	4	1	2	f	\N	\N	\N
2018	11	400	1	120500	\N	120500	\N	\N	5	1	2	f	\N	\N	\N
2019	5	400	1	13063699	\N	13063699	\N	\N	0	1	2	f	\N	\N	\N
2020	15	400	1	2530649	\N	2530649	\N	\N	0	1	2	f	\N	\N	\N
2021	25	400	1	515304	\N	515304	\N	\N	0	1	2	f	\N	\N	\N
2022	26	400	1	62245	\N	62245	\N	\N	0	1	2	f	\N	\N	\N
2023	23	400	1	16305	\N	16305	\N	\N	0	1	2	f	\N	\N	\N
2024	19	403	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
2025	24	403	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
2026	6	403	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
2027	17	403	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2028	19	405	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
2029	24	405	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2030	6	405	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
2031	26	406	2	11734	\N	11734	\N	\N	1	1	2	f	0	\N	\N
2032	19	406	2	224	\N	224	\N	\N	2	1	2	f	0	\N	\N
2033	9	406	2	11734	\N	11734	\N	\N	0	1	2	f	0	\N	\N
2034	15	406	2	11734	\N	11734	\N	\N	0	1	2	f	0	\N	\N
2035	24	406	2	224	\N	224	\N	\N	0	1	2	f	0	\N	\N
2036	6	406	1	11947	\N	11947	\N	\N	1	1	2	f	\N	\N	\N
2037	17	406	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
2038	21	407	2	12344650	\N	0	\N	\N	1	1	2	f	12344650	\N	\N
2039	5	407	2	12344650	\N	0	\N	\N	0	1	2	f	12344650	\N	\N
2040	21	408	2	215583	\N	0	\N	\N	1	1	2	f	215583	\N	\N
2041	5	408	2	215583	\N	0	\N	\N	0	1	2	f	215583	\N	\N
2042	24	409	2	274359	\N	274359	\N	\N	1	1	2	f	0	\N	\N
2043	9	409	2	130096	\N	130096	\N	\N	2	1	2	f	0	\N	\N
2044	19	409	2	274359	\N	274359	\N	\N	0	1	2	f	0	\N	\N
2045	15	409	2	130096	\N	130096	\N	\N	0	1	2	f	0	\N	\N
2046	26	409	2	54280	\N	54280	\N	\N	0	1	2	f	0	\N	\N
2047	25	409	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
2048	6	409	1	397259	\N	397259	\N	\N	1	1	2	f	\N	\N	\N
2049	17	409	1	7196	\N	7196	\N	\N	2	1	2	f	\N	\N	\N
2050	11	410	2	107146	\N	0	\N	\N	1	1	2	f	107146	\N	\N
2051	24	411	2	1916	\N	1916	\N	\N	1	1	2	f	0	\N	\N
2052	19	411	2	1916	\N	1916	\N	\N	0	1	2	f	0	\N	\N
2053	6	411	1	1903	\N	1903	\N	\N	1	1	2	f	\N	\N	\N
2054	17	411	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
2055	24	412	2	3527	\N	3527	\N	\N	1	1	2	f	0	\N	\N
2056	19	412	2	3527	\N	3527	\N	\N	0	1	2	f	0	\N	\N
2057	6	412	1	3310	\N	3310	\N	\N	1	1	2	f	\N	\N	\N
2058	17	412	1	217	\N	217	\N	\N	2	1	2	f	\N	\N	\N
2059	17	413	2	369350	\N	369350	\N	\N	1	1	2	f	0	\N	\N
2060	2	413	1	16070	\N	16070	\N	\N	1	1	2	f	\N	\N	\N
2061	24	414	2	1770	\N	1770	\N	\N	1	1	2	f	0	\N	\N
2062	25	414	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
2063	19	414	2	1770	\N	1770	\N	\N	0	1	2	f	0	\N	\N
2064	9	414	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2065	15	414	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2066	6	414	1	1542	\N	1542	\N	\N	1	1	2	f	\N	\N	\N
2067	17	414	1	232	\N	232	\N	\N	2	1	2	f	\N	\N	\N
2068	21	415	2	6422	\N	6422	\N	\N	1	1	2	f	0	\N	\N
2069	5	415	2	6422	\N	6422	\N	\N	0	1	2	f	0	\N	\N
2070	24	416	2	2045	\N	2045	\N	\N	1	1	2	f	0	\N	\N
2071	25	416	2	32	\N	32	\N	\N	2	1	2	f	0	\N	\N
2072	19	416	2	2045	\N	2045	\N	\N	0	1	2	f	0	\N	\N
2073	9	416	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
2074	15	416	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
2075	6	416	1	1448	\N	1448	\N	\N	1	1	2	f	\N	\N	\N
2076	17	416	1	629	\N	629	\N	\N	2	1	2	f	\N	\N	\N
2077	17	417	2	98117	\N	98117	\N	\N	1	1	2	f	0	\N	\N
2078	12	417	1	95636	\N	95636	\N	\N	1	1	2	f	\N	\N	\N
2079	17	418	2	175635	\N	0	\N	\N	1	1	2	f	175635	\N	\N
2080	17	419	2	253398	\N	253398	\N	\N	1	1	2	f	0	\N	\N
2081	12	419	1	217413	\N	217413	\N	\N	1	1	2	f	\N	\N	\N
2082	24	420	2	3173	\N	3173	\N	\N	1	1	2	f	0	\N	\N
2083	25	420	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2084	19	420	2	3173	\N	3173	\N	\N	0	1	2	f	0	\N	\N
2085	9	420	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2086	15	420	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2087	6	420	1	3110	\N	3110	\N	\N	1	1	2	f	\N	\N	\N
2088	17	420	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
2089	24	421	2	1293	\N	1293	\N	\N	1	1	2	f	0	\N	\N
2090	19	421	2	1293	\N	1293	\N	\N	0	1	2	f	0	\N	\N
2091	6	421	1	1291	\N	1291	\N	\N	1	1	2	f	\N	\N	\N
2092	17	421	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2093	19	422	2	274839	\N	274839	\N	\N	1	1	2	f	0	\N	\N
2094	26	422	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
2095	24	422	2	274839	\N	274839	\N	\N	0	1	2	f	0	\N	\N
2096	9	422	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2097	15	422	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2098	17	422	1	156752	\N	156752	\N	\N	1	1	2	f	\N	\N	\N
2099	6	422	1	118097	\N	118097	\N	\N	2	1	2	f	\N	\N	\N
2100	19	423	2	23	\N	23	\N	\N	1	1	2	f	0	\N	\N
2101	26	423	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2102	24	423	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
2103	9	423	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2104	15	423	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2105	6	423	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2106	19	424	2	357	\N	357	\N	\N	1	1	2	f	0	\N	\N
2107	26	424	2	99	\N	99	\N	\N	2	1	2	f	0	\N	\N
2108	24	424	2	357	\N	357	\N	\N	0	1	2	f	0	\N	\N
2109	9	424	2	99	\N	99	\N	\N	0	1	2	f	0	\N	\N
2110	15	424	2	99	\N	99	\N	\N	0	1	2	f	0	\N	\N
2111	6	424	1	433	\N	433	\N	\N	1	1	2	f	\N	\N	\N
2112	17	424	1	23	\N	23	\N	\N	2	1	2	f	\N	\N	\N
2113	6	425	2	387880	\N	387880	\N	\N	1	1	2	f	0	\N	\N
2114	12	425	1	387880	\N	387880	\N	\N	1	1	2	f	\N	\N	\N
2115	19	426	2	27	\N	27	\N	\N	1	1	2	f	0	\N	\N
2116	26	426	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2117	24	426	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2118	9	426	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2119	15	426	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2120	6	426	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
2121	19	427	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
2122	24	427	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
2123	6	427	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2124	19	428	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
2125	24	428	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2126	6	428	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
2127	19	429	2	86	\N	86	\N	\N	1	1	2	f	0	\N	\N
2128	24	429	2	86	\N	86	\N	\N	0	1	2	f	0	\N	\N
2129	6	429	1	83	\N	83	\N	\N	1	1	2	f	\N	\N	\N
2130	17	429	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2131	9	430	2	2704439	\N	2704439	\N	\N	1	1	2	f	0	\N	\N
2132	15	430	2	2704439	\N	2704439	\N	\N	0	1	2	f	0	\N	\N
2133	24	430	1	2704439	\N	2704439	\N	\N	1	1	2	f	\N	\N	\N
2134	19	430	1	2704439	\N	2704439	\N	\N	0	1	2	f	\N	\N	\N
2135	6	431	2	202028	\N	100828	\N	\N	1	1	2	f	101200	\N	\N
2136	6	432	2	1732068	\N	0	\N	\N	1	1	2	f	1732068	\N	\N
2137	19	433	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
2138	26	433	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2139	24	433	2	95	\N	95	\N	\N	0	1	2	f	0	\N	\N
2140	9	433	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2141	15	433	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2142	6	433	1	96	\N	96	\N	\N	1	1	2	f	\N	\N	\N
2143	11	434	2	78	\N	0	\N	\N	1	1	2	f	78	\N	\N
2144	19	435	2	145	\N	145	\N	\N	1	1	2	f	0	\N	\N
2145	24	435	2	145	\N	145	\N	\N	0	1	2	f	0	\N	\N
2146	6	435	1	145	\N	145	\N	\N	1	1	2	f	\N	\N	\N
2147	21	436	2	274474	\N	0	\N	\N	1	1	2	f	274474	\N	\N
2148	5	436	2	274474	\N	0	\N	\N	0	1	2	f	274474	\N	\N
2149	2	437	2	124449	\N	124449	\N	\N	1	1	2	f	0	\N	\N
2150	2	437	1	124449	\N	124449	\N	\N	1	1	2	f	\N	\N	\N
2151	6	438	2	1926493	\N	1926493	\N	\N	1	1	2	f	0	\N	\N
2152	2	438	1	86655	\N	86655	\N	\N	1	1	2	f	\N	\N	\N
2153	19	439	2	6183	\N	6183	\N	\N	1	1	2	f	0	\N	\N
2154	26	439	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
2155	24	439	2	6183	\N	6183	\N	\N	0	1	2	f	0	\N	\N
2156	9	439	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2157	15	439	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2158	6	439	1	6192	\N	6192	\N	\N	1	1	2	f	\N	\N	\N
2159	17	439	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2160	6	440	2	14802	\N	0	\N	\N	1	1	2	f	14802	\N	\N
2161	19	441	2	11247	\N	11247	\N	\N	1	1	2	f	0	\N	\N
2162	26	441	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
2163	24	441	2	11247	\N	11247	\N	\N	0	1	2	f	0	\N	\N
2164	9	441	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2165	15	441	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2166	6	441	1	11195	\N	11195	\N	\N	1	1	2	f	\N	\N	\N
2167	17	441	1	58	\N	58	\N	\N	2	1	2	f	\N	\N	\N
2168	19	442	2	605	\N	605	\N	\N	1	1	2	f	0	\N	\N
2169	26	442	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
2170	24	442	2	605	\N	605	\N	\N	0	1	2	f	0	\N	\N
2171	9	442	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2172	15	442	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2173	6	442	1	595	\N	595	\N	\N	1	1	2	f	\N	\N	\N
2174	17	442	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
2175	19	443	2	509	\N	509	\N	\N	1	1	2	f	0	\N	\N
2176	26	443	2	197	\N	197	\N	\N	2	1	2	f	0	\N	\N
2177	24	443	2	509	\N	509	\N	\N	0	1	2	f	0	\N	\N
2178	9	443	2	197	\N	197	\N	\N	0	1	2	f	0	\N	\N
2179	15	443	2	197	\N	197	\N	\N	0	1	2	f	0	\N	\N
2180	6	443	1	702	\N	702	\N	\N	1	1	2	f	\N	\N	\N
2181	17	443	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
2182	19	444	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2183	24	444	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2184	6	444	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
2185	19	445	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
2186	24	445	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2187	6	445	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
2188	17	445	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
2189	2	446	2	346	\N	346	\N	\N	1	1	2	f	0	\N	\N
2190	2	447	2	525	\N	525	\N	\N	1	1	2	f	0	\N	\N
2191	10	447	2	31	\N	31	\N	\N	2	1	2	f	0	\N	\N
2192	10	447	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2193	2	448	2	1404	\N	0	\N	\N	1	1	2	f	1404	\N	\N
2194	19	449	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2195	24	449	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2196	6	449	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2197	17	449	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2198	2	450	2	499	\N	0	\N	\N	1	1	2	f	499	\N	\N
2199	21	451	2	223102	\N	223102	\N	\N	1	1	2	f	0	\N	\N
2200	5	451	2	223102	\N	223102	\N	\N	0	1	2	f	0	\N	\N
2201	12	451	1	223102	\N	223102	\N	\N	1	1	2	f	\N	\N	\N
2202	19	452	2	114114	\N	114114	\N	\N	1	1	2	f	0	\N	\N
2203	26	452	2	1327	\N	1327	\N	\N	2	1	2	f	0	\N	\N
2204	24	452	2	114114	\N	114114	\N	\N	0	1	2	f	0	\N	\N
2205	9	452	2	1327	\N	1327	\N	\N	0	1	2	f	0	\N	\N
2206	15	452	2	1327	\N	1327	\N	\N	0	1	2	f	0	\N	\N
2207	17	452	1	67596	\N	67596	\N	\N	1	1	2	f	\N	\N	\N
2208	6	452	1	47845	\N	47845	\N	\N	2	1	2	f	\N	\N	\N
2209	19	453	2	1388	\N	1388	\N	\N	1	1	2	f	0	\N	\N
2210	24	453	2	1388	\N	1388	\N	\N	0	1	2	f	0	\N	\N
2211	6	453	1	1388	\N	1388	\N	\N	1	1	2	f	\N	\N	\N
2212	19	454	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
2213	26	454	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2214	24	454	2	112	\N	112	\N	\N	0	1	2	f	0	\N	\N
2215	9	454	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2216	15	454	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2217	6	454	1	113	\N	113	\N	\N	1	1	2	f	\N	\N	\N
2218	24	455	2	2548	\N	2548	\N	\N	1	1	2	f	0	\N	\N
2219	9	455	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
2220	19	455	2	2548	\N	2548	\N	\N	0	1	2	f	0	\N	\N
2221	15	455	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
2222	26	455	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
2223	23	455	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2224	25	455	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2225	6	455	1	2199	\N	2199	\N	\N	1	1	2	f	\N	\N	\N
2226	17	455	1	364	\N	364	\N	\N	2	1	2	f	\N	\N	\N
2227	24	456	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2228	19	456	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2229	6	456	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2230	24	457	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2231	19	457	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2232	6	457	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2233	24	458	2	304	\N	304	\N	\N	1	1	2	f	0	\N	\N
2234	19	458	2	304	\N	304	\N	\N	0	1	2	f	0	\N	\N
2235	6	458	1	302	\N	302	\N	\N	1	1	2	f	\N	\N	\N
2236	17	458	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2237	17	459	2	369350	\N	369350	\N	\N	1	1	2	f	0	\N	\N
2238	2	459	1	16070	\N	16070	\N	\N	1	1	2	f	\N	\N	\N
2239	24	460	2	86	\N	86	\N	\N	1	1	2	f	0	\N	\N
2240	19	460	2	86	\N	86	\N	\N	0	1	2	f	0	\N	\N
2241	6	460	1	86	\N	86	\N	\N	1	1	2	f	\N	\N	\N
2242	24	461	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
2243	19	461	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2244	6	461	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
2245	24	462	2	268692	\N	268692	\N	\N	1	1	2	f	0	\N	\N
2246	9	462	2	76865	\N	76865	\N	\N	2	1	2	f	0	\N	\N
2247	19	462	2	268692	\N	268692	\N	\N	0	1	2	f	0	\N	\N
2248	15	462	2	76865	\N	76865	\N	\N	0	1	2	f	0	\N	\N
2249	26	462	2	1049	\N	1049	\N	\N	0	1	2	f	0	\N	\N
2250	25	462	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
2251	6	462	1	338532	\N	338532	\N	\N	1	1	2	f	\N	\N	\N
2252	17	462	1	7025	\N	7025	\N	\N	2	1	2	f	\N	\N	\N
2253	2	463	2	5144902	\N	5144902	\N	\N	1	1	2	f	0	\N	\N
2254	9	463	2	1953100	\N	1953100	\N	\N	2	1	2	f	0	\N	\N
2255	15	463	2	1953100	\N	1953100	\N	\N	0	1	2	f	0	\N	\N
2256	24	464	2	2045	\N	2045	\N	\N	1	1	2	f	0	\N	\N
2257	26	464	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2258	19	464	2	2045	\N	2045	\N	\N	0	1	2	f	0	\N	\N
2259	9	464	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2260	15	464	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2261	6	464	1	2046	\N	2046	\N	\N	1	1	2	f	\N	\N	\N
2262	17	464	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2263	26	465	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2264	24	465	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2265	9	465	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2266	15	465	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2267	19	465	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2268	6	465	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2269	2	466	2	1834846	\N	0	\N	\N	1	1	2	f	1834846	\N	\N
2270	24	467	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
2271	19	467	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
2272	6	467	1	51	\N	51	\N	\N	1	1	2	f	\N	\N	\N
2273	24	468	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2274	19	468	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2275	6	468	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
2276	24	469	2	275	\N	275	\N	\N	1	1	2	f	0	\N	\N
2277	19	469	2	275	\N	275	\N	\N	0	1	2	f	0	\N	\N
2278	6	469	1	271	\N	271	\N	\N	1	1	2	f	\N	\N	\N
2279	17	469	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
2280	24	470	2	2509	\N	2509	\N	\N	1	1	2	f	0	\N	\N
2281	25	470	2	90	\N	90	\N	\N	2	1	2	f	0	\N	\N
2282	19	470	2	2509	\N	2509	\N	\N	0	1	2	f	0	\N	\N
2283	9	470	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
2284	15	470	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
2285	6	470	1	2597	\N	2597	\N	\N	1	1	2	f	\N	\N	\N
2286	17	470	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2287	9	471	2	1953100	\N	0	\N	\N	1	1	2	f	1953100	\N	\N
2288	15	471	2	1953100	\N	0	\N	\N	0	1	2	f	1953100	\N	\N
2289	24	472	2	200002	\N	200002	\N	\N	1	1	2	f	0	\N	\N
2290	25	472	2	3745	\N	3745	\N	\N	2	1	2	f	0	\N	\N
2291	19	472	2	200002	\N	200002	\N	\N	0	1	2	f	0	\N	\N
2292	9	472	2	3745	\N	3745	\N	\N	0	1	2	f	0	\N	\N
2293	15	472	2	3745	\N	3745	\N	\N	0	1	2	f	0	\N	\N
2294	23	472	2	845	\N	845	\N	\N	0	1	2	f	0	\N	\N
2295	6	472	1	202062	\N	202062	\N	\N	1	1	2	f	\N	\N	\N
2296	17	472	1	1685	\N	1685	\N	\N	2	1	2	f	\N	\N	\N
2297	24	473	2	138155	\N	138155	\N	\N	1	1	2	f	0	\N	\N
2298	9	473	2	92	\N	92	\N	\N	2	1	2	f	0	\N	\N
2299	19	473	2	138155	\N	138155	\N	\N	0	1	2	f	0	\N	\N
2300	15	473	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
2301	26	473	2	85	\N	85	\N	\N	0	1	2	f	0	\N	\N
2302	25	473	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2303	6	473	1	138055	\N	138055	\N	\N	1	1	2	f	\N	\N	\N
2304	17	473	1	192	\N	192	\N	\N	2	1	2	f	\N	\N	\N
2305	24	474	2	377	\N	377	\N	\N	1	1	2	f	0	\N	\N
2306	26	474	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2307	19	474	2	377	\N	377	\N	\N	0	1	2	f	0	\N	\N
2308	9	474	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2309	15	474	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2310	6	474	1	377	\N	377	\N	\N	1	1	2	f	\N	\N	\N
2311	17	474	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2312	25	475	2	341	\N	341	\N	\N	1	1	2	f	0	\N	\N
2313	24	475	2	92	\N	92	\N	\N	2	1	2	f	0	\N	\N
2314	9	475	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
2315	15	475	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
2316	23	475	2	124	\N	124	\N	\N	0	1	2	f	0	\N	\N
2317	19	475	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
2318	6	475	1	425	\N	425	\N	\N	1	1	2	f	\N	\N	\N
2319	17	475	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
2320	6	476	2	1439	\N	0	\N	\N	1	1	2	f	1439	\N	\N
2321	24	477	2	9553470	\N	9553470	\N	\N	1	1	2	f	0	\N	\N
2322	9	477	2	240442	\N	240442	\N	\N	2	1	2	f	0	\N	\N
2323	19	477	2	9553470	\N	9553470	\N	\N	0	1	2	f	0	\N	\N
2324	15	477	2	240442	\N	240442	\N	\N	0	1	2	f	0	\N	\N
2325	25	477	2	212230	\N	212230	\N	\N	0	1	2	f	0	\N	\N
2326	26	477	2	28212	\N	28212	\N	\N	0	1	2	f	0	\N	\N
2327	23	477	2	11394	\N	11394	\N	\N	0	1	2	f	0	\N	\N
2328	6	477	1	8499545	\N	8499545	\N	\N	1	1	2	f	\N	\N	\N
2329	17	477	1	1294367	\N	1294367	\N	\N	2	1	2	f	\N	\N	\N
2330	24	478	2	11277	\N	11277	\N	\N	1	1	2	f	0	\N	\N
2331	9	478	2	691	\N	691	\N	\N	2	1	2	f	0	\N	\N
2332	19	478	2	11277	\N	11277	\N	\N	0	1	2	f	0	\N	\N
2333	15	478	2	691	\N	691	\N	\N	0	1	2	f	0	\N	\N
2334	25	478	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
2335	26	478	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2336	6	478	1	11885	\N	11885	\N	\N	1	1	2	f	\N	\N	\N
2337	17	478	1	83	\N	83	\N	\N	2	1	2	f	\N	\N	\N
2338	24	479	2	68310	\N	68310	\N	\N	1	1	2	f	0	\N	\N
2339	9	479	2	8333	\N	8333	\N	\N	2	1	2	f	0	\N	\N
2340	19	479	2	68310	\N	68310	\N	\N	0	1	2	f	0	\N	\N
2341	15	479	2	8333	\N	8333	\N	\N	0	1	2	f	0	\N	\N
2342	26	479	2	8331	\N	8331	\N	\N	0	1	2	f	0	\N	\N
2343	25	479	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2344	6	479	1	75356	\N	75356	\N	\N	1	1	2	f	\N	\N	\N
2345	17	479	1	1287	\N	1287	\N	\N	2	1	2	f	\N	\N	\N
2346	24	480	2	11339	\N	11339	\N	\N	1	1	2	f	0	\N	\N
2347	9	480	2	52	\N	52	\N	\N	2	1	2	f	0	\N	\N
2348	19	480	2	11339	\N	11339	\N	\N	0	1	2	f	0	\N	\N
2349	15	480	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
2350	25	480	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
2351	23	480	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2352	26	480	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2353	6	480	1	11258	\N	11258	\N	\N	1	1	2	f	\N	\N	\N
2354	17	480	1	133	\N	133	\N	\N	2	1	2	f	\N	\N	\N
2355	19	481	2	40	\N	40	\N	\N	1	1	2	f	0	\N	\N
2356	24	481	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
2357	6	481	1	40	\N	40	\N	\N	1	1	2	f	\N	\N	\N
2358	19	482	2	190	\N	190	\N	\N	1	1	2	f	0	\N	\N
2359	24	482	2	190	\N	190	\N	\N	0	1	2	f	0	\N	\N
2360	6	482	1	179	\N	179	\N	\N	1	1	2	f	\N	\N	\N
2361	17	482	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
2362	19	483	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
2363	24	483	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2364	6	483	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
2365	11	484	2	104366	\N	0	\N	\N	1	1	2	f	104366	\N	\N
2366	19	485	2	372	\N	372	\N	\N	1	1	2	f	0	\N	\N
2367	24	485	2	372	\N	372	\N	\N	0	1	2	f	0	\N	\N
2368	6	485	1	369	\N	369	\N	\N	1	1	2	f	\N	\N	\N
2369	17	485	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2370	23	486	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2371	9	486	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2372	15	486	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2373	25	486	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2374	6	486	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2375	11	487	2	827	\N	0	\N	\N	1	1	2	f	827	\N	\N
2376	19	488	2	43	\N	43	\N	\N	1	1	2	f	0	\N	\N
2377	24	488	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
2378	6	488	1	40	\N	40	\N	\N	1	1	2	f	\N	\N	\N
2379	17	488	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2380	19	489	2	40	\N	40	\N	\N	1	1	2	f	0	\N	\N
2381	24	489	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
2382	6	489	1	40	\N	40	\N	\N	1	1	2	f	\N	\N	\N
2383	24	490	2	102	\N	102	\N	\N	1	1	2	f	0	\N	\N
2384	19	490	2	102	\N	102	\N	\N	0	1	2	f	0	\N	\N
2385	6	490	1	99	\N	99	\N	\N	1	1	2	f	\N	\N	\N
2386	17	490	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2387	21	491	2	430	\N	430	\N	\N	1	1	2	f	0	\N	\N
2388	5	491	2	430	\N	430	\N	\N	0	1	2	f	0	\N	\N
2389	24	492	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2390	19	492	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2391	6	492	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
2392	24	493	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
2393	19	493	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
2394	6	493	1	19	\N	19	\N	\N	1	1	2	f	\N	\N	\N
2395	2	494	2	3834	\N	0	\N	\N	1	1	2	f	3834	\N	\N
2396	24	495	2	1655	\N	1655	\N	\N	1	1	2	f	0	\N	\N
2397	26	495	2	293	\N	293	\N	\N	2	1	2	f	0	\N	\N
2398	19	495	2	1655	\N	1655	\N	\N	0	1	2	f	0	\N	\N
2399	9	495	2	293	\N	293	\N	\N	0	1	2	f	0	\N	\N
2400	15	495	2	293	\N	293	\N	\N	0	1	2	f	0	\N	\N
2401	6	495	1	1488	\N	1488	\N	\N	1	1	2	f	\N	\N	\N
2402	17	495	1	460	\N	460	\N	\N	2	1	2	f	\N	\N	\N
2403	24	496	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
2404	25	496	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2405	19	496	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
2406	9	496	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2407	15	496	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2408	6	496	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
2409	24	497	2	59	\N	59	\N	\N	1	1	2	f	0	\N	\N
2410	26	497	2	27	\N	27	\N	\N	2	1	2	f	0	\N	\N
2411	19	497	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
2412	9	497	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2413	15	497	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2414	6	497	1	85	\N	85	\N	\N	1	1	2	f	\N	\N	\N
2415	17	497	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2416	21	498	2	2034806	\N	0	\N	\N	1	1	2	f	2034806	\N	\N
2417	5	498	2	2034806	\N	0	\N	\N	0	1	2	f	2034806	\N	\N
2418	24	499	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2419	19	499	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2420	6	499	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2421	21	500	2	41932	\N	41932	\N	\N	1	1	2	f	0	\N	\N
2422	5	500	2	41932	\N	41932	\N	\N	0	1	2	f	0	\N	\N
2423	24	501	2	105	\N	105	\N	\N	1	1	2	f	0	\N	\N
2424	19	501	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
2425	6	501	1	104	\N	104	\N	\N	1	1	2	f	\N	\N	\N
2426	17	501	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2427	24	502	2	50849	\N	50849	\N	\N	1	1	2	f	0	\N	\N
2428	9	502	2	258	\N	258	\N	\N	2	1	2	f	0	\N	\N
2429	19	502	2	50849	\N	50849	\N	\N	0	1	2	f	0	\N	\N
2430	15	502	2	258	\N	258	\N	\N	0	1	2	f	0	\N	\N
2431	26	502	2	254	\N	254	\N	\N	0	1	2	f	0	\N	\N
2432	25	502	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2433	6	502	1	50986	\N	50986	\N	\N	1	1	2	f	\N	\N	\N
2434	17	502	1	121	\N	121	\N	\N	2	1	2	f	\N	\N	\N
2435	24	503	2	8436	\N	8436	\N	\N	1	1	2	f	0	\N	\N
2436	26	503	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
2437	19	503	2	8436	\N	8436	\N	\N	0	1	2	f	0	\N	\N
2438	9	503	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2439	15	503	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2440	17	503	1	8260	\N	8260	\N	\N	1	1	2	f	\N	\N	\N
2441	6	503	1	186	\N	186	\N	\N	2	1	2	f	\N	\N	\N
2442	24	504	2	74	\N	74	\N	\N	1	1	2	f	0	\N	\N
2443	19	504	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
2444	17	504	1	73	\N	73	\N	\N	1	1	2	f	\N	\N	\N
2445	6	504	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2446	25	505	2	6387	\N	6387	\N	\N	1	1	2	f	0	\N	\N
2447	9	505	2	6387	\N	6387	\N	\N	0	1	2	f	0	\N	\N
2448	15	505	2	6387	\N	6387	\N	\N	0	1	2	f	0	\N	\N
2449	23	505	2	444	\N	444	\N	\N	0	1	2	f	0	\N	\N
2450	25	505	1	6387	\N	6387	\N	\N	1	1	2	f	\N	\N	\N
2451	9	505	1	6387	\N	6387	\N	\N	0	1	2	f	\N	\N	\N
2452	15	505	1	6387	\N	6387	\N	\N	0	1	2	f	\N	\N	\N
2453	23	505	1	673	\N	673	\N	\N	0	1	2	f	\N	\N	\N
2454	24	506	2	508	\N	508	\N	\N	1	1	2	f	0	\N	\N
2455	25	506	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2456	19	506	2	508	\N	508	\N	\N	0	1	2	f	0	\N	\N
2457	9	506	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2458	15	506	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2459	6	506	1	503	\N	503	\N	\N	1	1	2	f	\N	\N	\N
2460	17	506	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
2461	9	507	2	22912	\N	22912	\N	\N	1	1	2	f	0	\N	\N
2462	15	507	2	22912	\N	22912	\N	\N	0	1	2	f	0	\N	\N
2463	9	507	1	22912	\N	22912	\N	\N	1	1	2	f	\N	\N	\N
2464	15	507	1	22912	\N	22912	\N	\N	0	1	2	f	\N	\N	\N
2465	24	508	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
2466	19	508	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
2467	6	508	1	58	\N	58	\N	\N	1	1	2	f	\N	\N	\N
2468	24	509	2	1008	\N	1008	\N	\N	1	1	2	f	0	\N	\N
2469	19	509	2	1008	\N	1008	\N	\N	0	1	2	f	0	\N	\N
2470	6	509	1	970	\N	970	\N	\N	1	1	2	f	\N	\N	\N
2471	17	509	1	38	\N	38	\N	\N	2	1	2	f	\N	\N	\N
2472	24	510	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2473	19	510	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2474	17	510	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2475	6	510	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2476	24	511	2	760	\N	760	\N	\N	1	1	2	f	0	\N	\N
2477	19	511	2	760	\N	760	\N	\N	0	1	2	f	0	\N	\N
2478	6	511	1	696	\N	696	\N	\N	1	1	2	f	\N	\N	\N
2479	17	511	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
2480	9	512	2	2061618	\N	2061618	\N	\N	1	1	2	f	0	\N	\N
2481	15	512	2	2061618	\N	2061618	\N	\N	0	1	2	f	0	\N	\N
2482	24	513	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
2483	19	513	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
2484	6	513	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
2485	24	514	2	10508	\N	10508	\N	\N	1	1	2	f	0	\N	\N
2486	9	514	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
2487	19	514	2	10508	\N	10508	\N	\N	0	1	2	f	0	\N	\N
2488	15	514	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2489	26	514	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2490	25	514	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2491	23	514	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2492	6	514	1	10504	\N	10504	\N	\N	1	1	2	f	\N	\N	\N
2493	17	514	1	9	\N	9	\N	\N	2	1	2	f	\N	\N	\N
2494	19	515	2	41	\N	41	\N	\N	1	1	2	f	0	\N	\N
2495	24	515	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
2496	6	515	1	41	\N	41	\N	\N	1	1	2	f	\N	\N	\N
2497	19	516	2	5830	\N	5830	\N	\N	1	1	2	f	0	\N	\N
2498	26	516	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
2499	24	516	2	5830	\N	5830	\N	\N	0	1	2	f	0	\N	\N
2500	9	516	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2501	15	516	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2502	6	516	1	5837	\N	5837	\N	\N	1	1	2	f	\N	\N	\N
2503	17	516	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
2504	19	517	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2505	24	517	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2506	6	517	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2507	19	518	2	110	\N	110	\N	\N	1	1	2	f	0	\N	\N
2508	24	518	2	110	\N	110	\N	\N	0	1	2	f	0	\N	\N
2509	6	518	1	110	\N	110	\N	\N	1	1	2	f	\N	\N	\N
2510	19	519	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2511	26	519	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2512	24	519	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2513	9	519	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2514	15	519	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2515	6	519	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
2516	19	520	2	5730	\N	5730	\N	\N	1	1	2	f	0	\N	\N
2517	26	520	2	455	\N	455	\N	\N	2	1	2	f	0	\N	\N
2518	24	520	2	5730	\N	5730	\N	\N	0	1	2	f	0	\N	\N
2519	9	520	2	455	\N	455	\N	\N	0	1	2	f	0	\N	\N
2520	15	520	2	455	\N	455	\N	\N	0	1	2	f	0	\N	\N
2521	6	520	1	6111	\N	6111	\N	\N	1	1	2	f	\N	\N	\N
2522	17	520	1	74	\N	74	\N	\N	2	1	2	f	\N	\N	\N
2523	19	521	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2524	24	521	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2525	6	521	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
2526	19	522	2	1456	\N	1456	\N	\N	1	1	2	f	0	\N	\N
2527	24	522	2	1456	\N	1456	\N	\N	0	1	2	f	0	\N	\N
2528	6	522	1	1456	\N	1456	\N	\N	1	1	2	f	\N	\N	\N
2529	19	523	2	3607	\N	3607	\N	\N	1	1	2	f	0	\N	\N
2530	9	523	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
2531	24	523	2	3607	\N	3607	\N	\N	0	1	2	f	0	\N	\N
2532	15	523	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2533	26	523	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2534	25	523	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2535	6	523	1	3339	\N	3339	\N	\N	1	1	2	f	\N	\N	\N
2536	17	523	1	271	\N	271	\N	\N	2	1	2	f	\N	\N	\N
2537	19	524	2	79	\N	79	\N	\N	1	1	2	f	0	\N	\N
2538	26	524	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
2539	24	524	2	79	\N	79	\N	\N	0	1	2	f	0	\N	\N
2540	9	524	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2541	15	524	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2542	6	524	1	85	\N	85	\N	\N	1	1	2	f	\N	\N	\N
2543	19	525	2	145265	\N	145265	\N	\N	1	1	2	f	0	\N	\N
2544	24	525	2	145265	\N	145265	\N	\N	0	1	2	f	0	\N	\N
2545	17	525	1	145246	\N	145246	\N	\N	1	1	2	f	\N	\N	\N
2546	6	525	1	19	\N	19	\N	\N	2	1	2	f	\N	\N	\N
2547	26	526	2	62192	\N	0	\N	\N	1	1	2	f	62192	\N	\N
2548	9	526	2	62192	\N	0	\N	\N	0	1	2	f	62192	\N	\N
2549	15	526	2	62192	\N	0	\N	\N	0	1	2	f	62192	\N	\N
2550	19	527	2	161	\N	161	\N	\N	1	1	2	f	0	\N	\N
2551	24	527	2	161	\N	161	\N	\N	0	1	2	f	0	\N	\N
2552	17	527	1	160	\N	160	\N	\N	1	1	2	f	\N	\N	\N
2553	6	527	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2554	18	528	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2555	19	529	2	2817	\N	2817	\N	\N	1	1	2	f	0	\N	\N
2556	24	529	2	2817	\N	2817	\N	\N	0	1	2	f	0	\N	\N
2557	17	529	1	2815	\N	2815	\N	\N	1	1	2	f	\N	\N	\N
2558	6	529	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2559	19	530	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2560	24	530	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2561	6	530	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2562	19	531	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2563	24	531	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2564	6	531	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2565	19	532	2	52455	\N	52455	\N	\N	1	1	2	f	0	\N	\N
2566	9	532	2	2173	\N	2173	\N	\N	2	1	2	f	0	\N	\N
2567	24	532	2	52455	\N	52455	\N	\N	0	1	2	f	0	\N	\N
2568	15	532	2	2173	\N	2173	\N	\N	0	1	2	f	0	\N	\N
2569	26	532	2	2106	\N	2106	\N	\N	0	1	2	f	0	\N	\N
2570	25	532	2	67	\N	67	\N	\N	0	1	2	f	0	\N	\N
2571	23	532	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2572	6	532	1	49969	\N	49969	\N	\N	1	1	2	f	\N	\N	\N
2573	17	532	1	4659	\N	4659	\N	\N	2	1	2	f	\N	\N	\N
2574	19	533	2	240493	\N	240493	\N	\N	1	1	2	f	0	\N	\N
2575	9	533	2	27	\N	27	\N	\N	2	1	2	f	0	\N	\N
2576	24	533	2	240493	\N	240493	\N	\N	0	1	2	f	0	\N	\N
2577	15	533	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2578	25	533	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
2579	26	533	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2580	6	533	1	239085	\N	239085	\N	\N	1	1	2	f	\N	\N	\N
2581	17	533	1	1435	\N	1435	\N	\N	2	1	2	f	\N	\N	\N
2582	19	534	2	777	\N	777	\N	\N	1	1	2	f	0	\N	\N
2583	26	534	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2584	24	534	2	777	\N	777	\N	\N	0	1	2	f	0	\N	\N
2585	9	534	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2586	15	534	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2587	6	534	1	778	\N	778	\N	\N	1	1	2	f	\N	\N	\N
2588	19	535	2	877	\N	877	\N	\N	1	1	2	f	0	\N	\N
2589	24	535	2	877	\N	877	\N	\N	0	1	2	f	0	\N	\N
2590	6	535	1	877	\N	877	\N	\N	1	1	2	f	\N	\N	\N
2591	19	536	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
2592	24	536	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
2593	17	536	1	58	\N	58	\N	\N	1	1	2	f	\N	\N	\N
2594	8	537	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2595	19	538	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
2596	24	538	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
2597	6	538	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
2598	19	539	2	12023	\N	12023	\N	\N	1	1	2	f	0	\N	\N
2599	24	539	2	12023	\N	12023	\N	\N	0	1	2	f	0	\N	\N
2600	6	539	1	12023	\N	12023	\N	\N	1	1	2	f	\N	\N	\N
2601	20	540	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2602	19	541	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2603	24	541	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2604	17	541	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2605	6	541	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2606	18	542	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2607	19	543	2	516240	\N	516240	\N	\N	1	1	2	f	0	\N	\N
2608	9	543	2	432	\N	432	\N	\N	2	1	2	f	0	\N	\N
2609	24	543	2	516240	\N	516240	\N	\N	0	1	2	f	0	\N	\N
2610	15	543	2	432	\N	432	\N	\N	0	1	2	f	0	\N	\N
2611	25	543	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
2612	26	543	2	73	\N	73	\N	\N	0	1	2	f	0	\N	\N
2613	23	543	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2614	6	543	1	513140	\N	513140	\N	\N	1	1	2	f	\N	\N	\N
2615	17	543	1	3532	\N	3532	\N	\N	2	1	2	f	\N	\N	\N
2616	21	544	2	83336	\N	0	\N	\N	1	1	2	f	83336	\N	\N
2617	5	544	2	83336	\N	0	\N	\N	0	1	2	f	83336	\N	\N
2618	26	545	2	478	\N	478	\N	\N	1	1	2	f	0	\N	\N
2619	19	545	2	56	\N	56	\N	\N	2	1	2	f	0	\N	\N
2620	9	545	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
2621	15	545	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
2622	24	545	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
2623	6	545	1	524	\N	524	\N	\N	1	1	2	f	\N	\N	\N
2624	17	545	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
2625	19	546	2	6753	\N	6753	\N	\N	1	1	2	f	0	\N	\N
2626	24	546	2	6753	\N	6753	\N	\N	0	1	2	f	0	\N	\N
2627	6	546	1	6043	\N	6043	\N	\N	1	1	2	f	\N	\N	\N
2628	17	546	1	710	\N	710	\N	\N	2	1	2	f	\N	\N	\N
2629	19	547	2	39902	\N	39902	\N	\N	1	1	2	f	0	\N	\N
2630	26	547	2	1505	\N	1505	\N	\N	2	1	2	f	0	\N	\N
2631	24	547	2	39902	\N	39902	\N	\N	0	1	2	f	0	\N	\N
2632	9	547	2	1505	\N	1505	\N	\N	0	1	2	f	0	\N	\N
2633	15	547	2	1505	\N	1505	\N	\N	0	1	2	f	0	\N	\N
2634	6	547	1	41407	\N	41407	\N	\N	1	1	2	f	\N	\N	\N
2635	19	548	2	285	\N	285	\N	\N	1	1	2	f	0	\N	\N
2636	24	548	2	285	\N	285	\N	\N	0	1	2	f	0	\N	\N
2637	6	548	1	285	\N	285	\N	\N	1	1	2	f	\N	\N	\N
2638	19	549	2	121	\N	121	\N	\N	1	1	2	f	0	\N	\N
2639	24	549	2	121	\N	121	\N	\N	0	1	2	f	0	\N	\N
2640	6	549	1	121	\N	121	\N	\N	1	1	2	f	\N	\N	\N
2641	6	550	2	4393839	\N	0	\N	\N	1	1	2	f	4393839	\N	\N
2642	19	551	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2643	24	551	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2644	6	551	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
2645	19	552	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
2646	24	552	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2647	6	552	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
2648	19	553	2	727	\N	727	\N	\N	1	1	2	f	0	\N	\N
2649	26	553	2	25	\N	25	\N	\N	2	1	2	f	0	\N	\N
2650	24	553	2	727	\N	727	\N	\N	0	1	2	f	0	\N	\N
2651	9	553	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
2652	15	553	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
2653	6	553	1	750	\N	750	\N	\N	1	1	2	f	\N	\N	\N
2654	17	553	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2655	26	554	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
2656	24	554	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
2657	9	554	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
2658	15	554	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
2659	19	554	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
2660	6	554	1	38	\N	38	\N	\N	1	1	2	f	\N	\N	\N
2661	17	554	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
2662	26	555	2	132	\N	132	\N	\N	1	1	2	f	0	\N	\N
2663	19	555	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
2664	9	555	2	132	\N	132	\N	\N	0	1	2	f	0	\N	\N
2665	15	555	2	132	\N	132	\N	\N	0	1	2	f	0	\N	\N
2666	24	555	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2667	6	555	1	141	\N	141	\N	\N	1	1	2	f	\N	\N	\N
2668	17	555	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2669	19	556	2	67	\N	67	\N	\N	1	1	2	f	0	\N	\N
2670	26	556	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2671	24	556	2	67	\N	67	\N	\N	0	1	2	f	0	\N	\N
2672	9	556	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2673	15	556	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2674	6	556	1	64	\N	64	\N	\N	1	1	2	f	\N	\N	\N
2675	17	556	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
2676	19	557	2	515	\N	515	\N	\N	1	1	2	f	0	\N	\N
2677	24	557	2	515	\N	515	\N	\N	0	1	2	f	0	\N	\N
2678	6	557	1	515	\N	515	\N	\N	1	1	2	f	\N	\N	\N
2679	11	558	2	116	\N	0	\N	\N	1	1	2	f	116	\N	\N
2680	19	559	2	54012	\N	54012	\N	\N	1	1	2	f	0	\N	\N
2681	26	559	2	8024	\N	8024	\N	\N	2	1	2	f	0	\N	\N
2682	24	559	2	54012	\N	54012	\N	\N	0	1	2	f	0	\N	\N
2683	9	559	2	8024	\N	8024	\N	\N	0	1	2	f	0	\N	\N
2684	15	559	2	8024	\N	8024	\N	\N	0	1	2	f	0	\N	\N
2685	6	559	1	61415	\N	61415	\N	\N	1	1	2	f	\N	\N	\N
2686	17	559	1	621	\N	621	\N	\N	2	1	2	f	\N	\N	\N
2687	19	560	2	55	\N	55	\N	\N	1	1	2	f	0	\N	\N
2688	26	560	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2689	24	560	2	55	\N	55	\N	\N	0	1	2	f	0	\N	\N
2690	9	560	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2691	15	560	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2692	6	560	1	56	\N	56	\N	\N	1	1	2	f	\N	\N	\N
2693	24	561	2	385	\N	385	\N	\N	1	1	2	f	0	\N	\N
2694	19	561	2	385	\N	385	\N	\N	0	1	2	f	0	\N	\N
2695	6	561	1	384	\N	384	\N	\N	1	1	2	f	\N	\N	\N
2696	17	561	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2697	24	562	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
2698	19	562	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2699	6	562	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
2700	24	563	2	451	\N	451	\N	\N	1	1	2	f	0	\N	\N
2701	19	563	2	451	\N	451	\N	\N	0	1	2	f	0	\N	\N
2702	6	563	1	451	\N	451	\N	\N	1	1	2	f	\N	\N	\N
2703	24	564	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2704	19	564	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2705	6	564	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2706	24	565	2	9349	\N	9349	\N	\N	1	1	2	f	0	\N	\N
2707	26	565	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
2708	19	565	2	9349	\N	9349	\N	\N	0	1	2	f	0	\N	\N
2709	9	565	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2710	15	565	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2711	6	565	1	9348	\N	9348	\N	\N	1	1	2	f	\N	\N	\N
2712	17	565	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
2713	24	566	2	98146	\N	98146	\N	\N	1	1	2	f	0	\N	\N
2714	9	566	2	220	\N	220	\N	\N	2	1	2	f	0	\N	\N
2715	19	566	2	98146	\N	98146	\N	\N	0	1	2	f	0	\N	\N
2716	15	566	2	220	\N	220	\N	\N	0	1	2	f	0	\N	\N
2717	26	566	2	218	\N	218	\N	\N	0	1	2	f	0	\N	\N
2718	25	566	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2719	6	566	1	98180	\N	98180	\N	\N	1	1	2	f	\N	\N	\N
2720	17	566	1	186	\N	186	\N	\N	2	1	2	f	\N	\N	\N
2721	26	567	2	26320	\N	26320	\N	\N	1	1	2	f	0	\N	\N
2722	9	567	2	26320	\N	26320	\N	\N	0	1	2	f	0	\N	\N
2723	15	567	2	26320	\N	26320	\N	\N	0	1	2	f	0	\N	\N
2724	2	567	1	13577	\N	13577	\N	\N	1	1	2	f	\N	\N	\N
2725	11	567	1	12743	\N	12743	\N	\N	2	1	2	f	\N	\N	\N
2726	24	568	2	1097	\N	1097	\N	\N	1	1	2	f	0	\N	\N
2727	26	568	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2728	19	568	2	1097	\N	1097	\N	\N	0	1	2	f	0	\N	\N
2729	9	568	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2730	15	568	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2731	6	568	1	1099	\N	1099	\N	\N	1	1	2	f	\N	\N	\N
2732	24	569	2	1727393	\N	1727393	\N	\N	1	1	2	f	0	\N	\N
2733	9	569	2	11310	\N	11310	\N	\N	2	1	2	f	0	\N	\N
2734	19	569	2	1727393	\N	1727393	\N	\N	0	1	2	f	0	\N	\N
2735	15	569	2	11310	\N	11310	\N	\N	0	1	2	f	0	\N	\N
2736	25	569	2	11296	\N	11296	\N	\N	0	1	2	f	0	\N	\N
2737	23	569	2	151	\N	151	\N	\N	0	1	2	f	0	\N	\N
2738	26	569	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
2739	6	569	1	1239454	\N	1239454	\N	\N	1	1	2	f	\N	\N	\N
2740	17	569	1	499249	\N	499249	\N	\N	2	1	2	f	\N	\N	\N
2741	24	570	2	31	\N	31	\N	\N	1	1	2	f	0	\N	\N
2742	26	570	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2743	19	570	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
2744	9	570	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2745	15	570	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2746	6	570	1	32	\N	32	\N	\N	1	1	2	f	\N	\N	\N
2747	24	571	2	266	\N	266	\N	\N	1	1	2	f	0	\N	\N
2748	19	571	2	266	\N	266	\N	\N	0	1	2	f	0	\N	\N
2749	6	571	1	266	\N	266	\N	\N	1	1	2	f	\N	\N	\N
2750	21	572	2	10690637	\N	0	\N	\N	1	1	2	f	10690637	\N	\N
2751	25	572	2	512947	\N	0	\N	\N	2	1	2	f	512947	\N	\N
2752	5	572	2	10690637	\N	0	\N	\N	0	1	2	f	10690637	\N	\N
2753	9	572	2	512947	\N	0	\N	\N	0	1	2	f	512947	\N	\N
2754	15	572	2	512947	\N	0	\N	\N	0	1	2	f	512947	\N	\N
2755	23	572	2	16309	\N	0	\N	\N	0	1	2	f	16309	\N	\N
2756	24	573	2	507	\N	507	\N	\N	1	1	2	f	0	\N	\N
2757	25	573	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2758	19	573	2	507	\N	507	\N	\N	0	1	2	f	0	\N	\N
2759	9	573	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2760	15	573	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2761	6	573	1	500	\N	500	\N	\N	1	1	2	f	\N	\N	\N
2762	17	573	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
2763	26	574	2	557	\N	557	\N	\N	1	1	2	f	0	\N	\N
2764	24	574	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
2765	9	574	2	557	\N	557	\N	\N	0	1	2	f	0	\N	\N
2766	15	574	2	557	\N	557	\N	\N	0	1	2	f	0	\N	\N
2767	19	574	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2768	6	574	1	562	\N	562	\N	\N	1	1	2	f	\N	\N	\N
2769	24	575	2	236814	\N	236814	\N	\N	1	1	2	f	0	\N	\N
2770	9	575	2	26	\N	26	\N	\N	2	1	2	f	0	\N	\N
2771	19	575	2	236814	\N	236814	\N	\N	0	1	2	f	0	\N	\N
2772	15	575	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
2773	25	575	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2774	26	575	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2775	6	575	1	235513	\N	235513	\N	\N	1	1	2	f	\N	\N	\N
2776	17	575	1	1327	\N	1327	\N	\N	2	1	2	f	\N	\N	\N
2777	26	576	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
2778	9	576	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2779	15	576	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2780	6	576	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
2781	24	577	2	2282	\N	2282	\N	\N	1	1	2	f	0	\N	\N
2782	9	577	2	533	\N	533	\N	\N	2	1	2	f	0	\N	\N
2783	19	577	2	2282	\N	2282	\N	\N	0	1	2	f	0	\N	\N
2784	15	577	2	533	\N	533	\N	\N	0	1	2	f	0	\N	\N
2785	6	577	1	2217	\N	2217	\N	\N	1	1	2	f	\N	\N	\N
2786	17	577	1	598	\N	598	\N	\N	2	1	2	f	\N	\N	\N
2787	24	578	2	626	\N	626	\N	\N	1	1	2	f	0	\N	\N
2788	26	578	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
2789	19	578	2	626	\N	626	\N	\N	0	1	2	f	0	\N	\N
2790	9	578	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2791	15	578	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2792	6	578	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2793	26	579	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2794	9	579	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2795	15	579	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2796	6	579	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2797	24	580	2	3605	\N	3605	\N	\N	1	1	2	f	0	\N	\N
2798	9	580	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
2799	19	580	2	3605	\N	3605	\N	\N	0	1	2	f	0	\N	\N
2800	15	580	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
2801	26	580	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2802	25	580	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2803	6	580	1	3596	\N	3596	\N	\N	1	1	2	f	\N	\N	\N
2804	17	580	1	37	\N	37	\N	\N	2	1	2	f	\N	\N	\N
2805	24	581	2	2038	\N	2038	\N	\N	1	1	2	f	0	\N	\N
2806	26	581	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2807	19	581	2	2038	\N	2038	\N	\N	0	1	2	f	0	\N	\N
2808	9	581	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2809	15	581	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2810	6	581	1	2039	\N	2039	\N	\N	1	1	2	f	\N	\N	\N
2811	24	582	2	89	\N	89	\N	\N	1	1	2	f	0	\N	\N
2812	26	582	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
2813	19	582	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
2814	9	582	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2815	15	582	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2816	6	582	1	94	\N	94	\N	\N	1	1	2	f	\N	\N	\N
2817	17	582	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2818	24	583	2	55	\N	55	\N	\N	1	1	2	f	0	\N	\N
2819	26	583	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
2820	19	583	2	55	\N	55	\N	\N	0	1	2	f	0	\N	\N
2821	9	583	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2822	15	583	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2823	6	583	1	58	\N	58	\N	\N	1	1	2	f	\N	\N	\N
2824	2	584	2	21265	\N	21265	\N	\N	1	1	2	f	0	\N	\N
2825	24	585	2	37770	\N	37770	\N	\N	1	1	2	f	0	\N	\N
2826	26	585	2	1715	\N	1715	\N	\N	2	1	2	f	0	\N	\N
2827	19	585	2	37770	\N	37770	\N	\N	0	1	2	f	0	\N	\N
2828	9	585	2	1715	\N	1715	\N	\N	0	1	2	f	0	\N	\N
2829	15	585	2	1715	\N	1715	\N	\N	0	1	2	f	0	\N	\N
2830	17	585	1	39423	\N	39423	\N	\N	1	1	2	f	\N	\N	\N
2831	6	585	1	62	\N	62	\N	\N	2	1	2	f	\N	\N	\N
2832	24	586	2	212	\N	212	\N	\N	1	1	2	f	0	\N	\N
2833	19	586	2	212	\N	212	\N	\N	0	1	2	f	0	\N	\N
2834	6	586	1	202	\N	202	\N	\N	1	1	2	f	\N	\N	\N
2835	17	586	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
2836	26	587	2	2586	\N	2586	\N	\N	1	1	2	f	0	\N	\N
2837	24	587	2	247	\N	247	\N	\N	2	1	2	f	0	\N	\N
2838	9	587	2	2586	\N	2586	\N	\N	0	1	2	f	0	\N	\N
2839	15	587	2	2586	\N	2586	\N	\N	0	1	2	f	0	\N	\N
2840	19	587	2	247	\N	247	\N	\N	0	1	2	f	0	\N	\N
2841	6	587	1	2810	\N	2810	\N	\N	1	1	2	f	\N	\N	\N
2842	17	587	1	23	\N	23	\N	\N	2	1	2	f	\N	\N	\N
2843	24	588	2	32	\N	32	\N	\N	1	1	2	f	0	\N	\N
2844	19	588	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
2845	6	588	1	31	\N	31	\N	\N	1	1	2	f	\N	\N	\N
2846	17	588	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2847	19	589	2	216	\N	216	\N	\N	1	1	2	f	0	\N	\N
2848	24	589	2	216	\N	216	\N	\N	0	1	2	f	0	\N	\N
2849	6	589	1	216	\N	216	\N	\N	1	1	2	f	\N	\N	\N
2850	19	590	2	10305	\N	10305	\N	\N	1	1	2	f	0	\N	\N
2851	26	590	2	51	\N	51	\N	\N	2	1	2	f	0	\N	\N
2852	24	590	2	10305	\N	10305	\N	\N	0	1	2	f	0	\N	\N
2853	9	590	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
2854	15	590	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
2855	6	590	1	10274	\N	10274	\N	\N	1	1	2	f	\N	\N	\N
2856	17	590	1	82	\N	82	\N	\N	2	1	2	f	\N	\N	\N
2857	19	591	2	79971	\N	79971	\N	\N	1	1	2	f	0	\N	\N
2858	9	591	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
2859	24	591	2	79971	\N	79971	\N	\N	0	1	2	f	0	\N	\N
2860	15	591	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2861	25	591	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2862	26	591	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2863	6	591	1	77285	\N	77285	\N	\N	1	1	2	f	\N	\N	\N
2864	17	591	1	2699	\N	2699	\N	\N	2	1	2	f	\N	\N	\N
2865	19	592	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
2866	26	592	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
2867	24	592	2	95	\N	95	\N	\N	0	1	2	f	0	\N	\N
2868	9	592	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2869	15	592	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2870	17	592	1	100	\N	100	\N	\N	1	1	2	f	\N	\N	\N
2871	6	592	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
2872	19	593	2	1888	\N	1888	\N	\N	1	1	2	f	0	\N	\N
2873	26	593	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2874	24	593	2	1888	\N	1888	\N	\N	0	1	2	f	0	\N	\N
2875	9	593	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2876	15	593	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2877	6	593	1	1889	\N	1889	\N	\N	1	1	2	f	\N	\N	\N
2878	19	594	2	1273851	\N	1273851	\N	\N	1	1	2	f	0	\N	\N
2879	9	594	2	17201	\N	17201	\N	\N	2	1	2	f	0	\N	\N
2880	24	594	2	1273851	\N	1273851	\N	\N	0	1	2	f	0	\N	\N
2881	15	594	2	17201	\N	17201	\N	\N	0	1	2	f	0	\N	\N
2882	26	594	2	17193	\N	17193	\N	\N	0	1	2	f	0	\N	\N
2883	25	594	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2884	6	594	1	1287430	\N	1287430	\N	\N	1	1	2	f	\N	\N	\N
2885	17	594	1	3622	\N	3622	\N	\N	2	1	2	f	\N	\N	\N
2886	24	595	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
2887	19	595	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
2888	6	595	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
2889	24	596	2	524	\N	524	\N	\N	1	1	2	f	0	\N	\N
2890	19	596	2	524	\N	524	\N	\N	0	1	2	f	0	\N	\N
2891	6	596	1	523	\N	523	\N	\N	1	1	2	f	\N	\N	\N
2892	17	596	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2893	10	597	2	62	\N	62	\N	\N	1	1	2	f	0	\N	\N
2894	16	597	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2895	20	597	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2896	13	597	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
2897	2	598	2	1647531	\N	1647531	\N	\N	1	1	2	f	0	\N	\N
2898	24	599	2	200002	\N	200002	\N	\N	1	1	2	f	0	\N	\N
2899	25	599	2	3745	\N	3745	\N	\N	2	1	2	f	0	\N	\N
2900	19	599	2	200002	\N	200002	\N	\N	0	1	2	f	0	\N	\N
2901	9	599	2	3745	\N	3745	\N	\N	0	1	2	f	0	\N	\N
2902	15	599	2	3745	\N	3745	\N	\N	0	1	2	f	0	\N	\N
2903	23	599	2	845	\N	845	\N	\N	0	1	2	f	0	\N	\N
2904	6	599	1	202062	\N	202062	\N	\N	1	1	2	f	\N	\N	\N
2905	17	599	1	1685	\N	1685	\N	\N	2	1	2	f	\N	\N	\N
2906	24	600	2	90	\N	90	\N	\N	1	1	2	f	0	\N	\N
2907	19	600	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
2908	6	600	1	90	\N	90	\N	\N	1	1	2	f	\N	\N	\N
2909	24	601	2	451	\N	451	\N	\N	1	1	2	f	0	\N	\N
2910	26	601	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
2911	19	601	2	451	\N	451	\N	\N	0	1	2	f	0	\N	\N
2912	9	601	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2913	15	601	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2914	6	601	1	453	\N	453	\N	\N	1	1	2	f	\N	\N	\N
2915	24	602	2	170	\N	170	\N	\N	1	1	2	f	0	\N	\N
2916	19	602	2	170	\N	170	\N	\N	0	1	2	f	0	\N	\N
2917	6	602	1	169	\N	169	\N	\N	1	1	2	f	\N	\N	\N
2918	17	602	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2919	24	603	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2920	19	603	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2921	6	603	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
2922	24	604	2	22581	\N	22581	\N	\N	1	1	2	f	0	\N	\N
2923	9	604	2	2023	\N	2023	\N	\N	2	1	2	f	0	\N	\N
2924	19	604	2	22581	\N	22581	\N	\N	0	1	2	f	0	\N	\N
2925	15	604	2	2023	\N	2023	\N	\N	0	1	2	f	0	\N	\N
2926	26	604	2	1962	\N	1962	\N	\N	0	1	2	f	0	\N	\N
2927	25	604	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
2928	23	604	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2929	6	604	1	20320	\N	20320	\N	\N	1	1	2	f	\N	\N	\N
2930	17	604	1	4284	\N	4284	\N	\N	2	1	2	f	\N	\N	\N
2931	24	605	2	118	\N	118	\N	\N	1	1	2	f	0	\N	\N
2932	26	605	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
2933	19	605	2	118	\N	118	\N	\N	0	1	2	f	0	\N	\N
2934	9	605	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2935	15	605	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2936	6	605	1	128	\N	128	\N	\N	1	1	2	f	\N	\N	\N
2937	19	606	2	21019	\N	21019	\N	\N	1	1	2	f	0	\N	\N
2938	9	606	2	9894	\N	9894	\N	\N	2	1	2	f	0	\N	\N
2939	24	606	2	21019	\N	21019	\N	\N	0	1	2	f	0	\N	\N
2940	15	606	2	9894	\N	9894	\N	\N	0	1	2	f	0	\N	\N
2941	26	606	2	9893	\N	9893	\N	\N	0	1	2	f	0	\N	\N
2942	25	606	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2943	6	606	1	30907	\N	30907	\N	\N	1	1	2	f	\N	\N	\N
2944	17	606	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
2945	21	607	2	26127398	\N	26127398	\N	\N	1	1	2	f	0	\N	\N
2946	19	607	2	26127398	\N	26127398	\N	\N	2	1	2	f	0	\N	\N
2947	2	607	2	20742426	\N	20742426	\N	\N	3	1	2	f	0	\N	\N
2948	9	607	2	5655152	\N	5655152	\N	\N	4	1	2	f	0	\N	\N
2949	6	607	2	4393839	\N	4393839	\N	\N	5	1	2	f	0	\N	\N
2950	17	607	2	430832	\N	430832	\N	\N	6	1	2	f	0	\N	\N
2951	11	607	2	120500	\N	120500	\N	\N	7	1	2	f	0	\N	\N
2952	1	607	2	10869	\N	10869	\N	\N	8	1	2	f	0	\N	\N
2953	12	607	2	2698	\N	2698	\N	\N	9	1	2	f	0	\N	\N
2954	10	607	2	70	\N	70	\N	\N	10	1	2	f	0	\N	\N
2955	4	607	2	6	\N	6	\N	\N	11	1	2	f	0	\N	\N
2956	14	607	2	6	\N	6	\N	\N	12	1	2	f	0	\N	\N
2957	20	607	2	3	\N	3	\N	\N	13	1	2	f	0	\N	\N
2958	8	607	2	1	\N	1	\N	\N	14	1	2	f	0	\N	\N
2959	18	607	2	1	\N	1	\N	\N	15	1	2	f	0	\N	\N
2960	22	607	2	1	\N	1	\N	\N	16	1	2	f	0	\N	\N
2961	5	607	2	26127398	\N	26127398	\N	\N	0	1	2	f	0	\N	\N
2962	24	607	2	26127398	\N	26127398	\N	\N	0	1	2	f	0	\N	\N
2963	15	607	2	5655152	\N	5655152	\N	\N	0	1	2	f	0	\N	\N
2964	25	607	2	1562217	\N	1562217	\N	\N	0	1	2	f	0	\N	\N
2965	26	607	2	186735	\N	186735	\N	\N	0	1	2	f	0	\N	\N
2966	23	607	2	65220	\N	65220	\N	\N	0	1	2	f	0	\N	\N
2967	7	607	2	10334	\N	10334	\N	\N	0	1	2	f	0	\N	\N
2968	13	607	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
2969	16	607	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2970	3	607	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2971	13	607	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
2972	19	608	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
2973	24	608	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
2974	6	608	1	49	\N	49	\N	\N	1	1	2	f	\N	\N	\N
2975	21	609	2	12703672	\N	0	\N	\N	1	1	2	f	12703672	\N	\N
2976	9	609	2	1906123	\N	0	\N	\N	2	1	2	f	1906123	\N	\N
2977	5	609	2	12703672	\N	0	\N	\N	0	1	2	f	12703672	\N	\N
2978	15	609	2	1906123	\N	0	\N	\N	0	1	2	f	1906123	\N	\N
2979	26	609	2	62148	\N	0	\N	\N	0	1	2	f	62148	\N	\N
2980	24	610	2	74747	\N	74747	\N	\N	1	1	2	f	0	\N	\N
2981	26	610	2	347	\N	347	\N	\N	2	1	2	f	0	\N	\N
2982	19	610	2	74747	\N	74747	\N	\N	0	1	2	f	0	\N	\N
2983	9	610	2	347	\N	347	\N	\N	0	1	2	f	0	\N	\N
2984	15	610	2	347	\N	347	\N	\N	0	1	2	f	0	\N	\N
2985	6	610	1	75024	\N	75024	\N	\N	1	1	2	f	\N	\N	\N
2986	17	610	1	70	\N	70	\N	\N	2	1	2	f	\N	\N	\N
2987	21	611	2	4499509	\N	0	\N	\N	1	1	2	f	4499509	\N	\N
2988	5	611	2	4499509	\N	0	\N	\N	0	1	2	f	4499509	\N	\N
2989	24	612	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
2990	19	612	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2991	17	612	1	14	\N	14	\N	\N	1	1	2	f	\N	\N	\N
2992	6	612	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
2993	24	613	2	374	\N	374	\N	\N	1	1	2	f	0	\N	\N
2994	26	613	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
2995	19	613	2	374	\N	374	\N	\N	0	1	2	f	0	\N	\N
2996	9	613	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2997	15	613	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2998	6	613	1	380	\N	380	\N	\N	1	1	2	f	\N	\N	\N
2999	24	614	2	985	\N	985	\N	\N	1	1	2	f	0	\N	\N
3000	26	614	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3001	19	614	2	985	\N	985	\N	\N	0	1	2	f	0	\N	\N
3002	9	614	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3003	15	614	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3004	6	614	1	987	\N	987	\N	\N	1	1	2	f	\N	\N	\N
3005	24	615	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3006	19	615	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3007	6	615	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3008	24	616	2	3173	\N	3173	\N	\N	1	1	2	f	0	\N	\N
3009	25	616	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3010	19	616	2	3173	\N	3173	\N	\N	0	1	2	f	0	\N	\N
3011	9	616	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3012	15	616	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3013	6	616	1	3110	\N	3110	\N	\N	1	1	2	f	\N	\N	\N
3014	17	616	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
3015	24	617	2	6906	\N	6906	\N	\N	1	1	2	f	0	\N	\N
3016	26	617	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
3017	19	617	2	6906	\N	6906	\N	\N	0	1	2	f	0	\N	\N
3018	9	617	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
3019	15	617	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
3020	6	617	1	6931	\N	6931	\N	\N	1	1	2	f	\N	\N	\N
3021	17	617	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
3022	24	618	2	440	\N	440	\N	\N	1	1	2	f	0	\N	\N
3023	19	618	2	440	\N	440	\N	\N	0	1	2	f	0	\N	\N
3024	6	618	1	439	\N	439	\N	\N	1	1	2	f	\N	\N	\N
3025	17	618	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3026	24	619	2	515759	\N	515759	\N	\N	1	1	2	f	0	\N	\N
3027	9	619	2	432	\N	432	\N	\N	2	1	2	f	0	\N	\N
3028	19	619	2	515759	\N	515759	\N	\N	0	1	2	f	0	\N	\N
3029	15	619	2	432	\N	432	\N	\N	0	1	2	f	0	\N	\N
3030	25	619	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
3031	26	619	2	73	\N	73	\N	\N	0	1	2	f	0	\N	\N
3032	23	619	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3033	6	619	1	512667	\N	512667	\N	\N	1	1	2	f	\N	\N	\N
3034	17	619	1	3524	\N	3524	\N	\N	2	1	2	f	\N	\N	\N
3035	24	620	2	530744	\N	530744	\N	\N	1	1	2	f	0	\N	\N
3036	9	620	2	6135	\N	6135	\N	\N	2	1	2	f	0	\N	\N
3037	19	620	2	530744	\N	530744	\N	\N	0	1	2	f	0	\N	\N
3038	15	620	2	6135	\N	6135	\N	\N	0	1	2	f	0	\N	\N
3039	26	620	2	6079	\N	6079	\N	\N	0	1	2	f	0	\N	\N
3040	25	620	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
3041	6	620	1	534302	\N	534302	\N	\N	1	1	2	f	\N	\N	\N
3042	17	620	1	2577	\N	2577	\N	\N	2	1	2	f	\N	\N	\N
3043	24	621	2	2396	\N	2396	\N	\N	1	1	2	f	0	\N	\N
3044	26	621	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3045	19	621	2	2396	\N	2396	\N	\N	0	1	2	f	0	\N	\N
3046	9	621	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3047	15	621	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3048	6	621	1	2394	\N	2394	\N	\N	1	1	2	f	\N	\N	\N
3049	17	621	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
3050	24	622	2	12790	\N	12790	\N	\N	1	1	2	f	0	\N	\N
3051	26	622	2	178	\N	178	\N	\N	2	1	2	f	0	\N	\N
3052	19	622	2	12790	\N	12790	\N	\N	0	1	2	f	0	\N	\N
3053	9	622	2	178	\N	178	\N	\N	0	1	2	f	0	\N	\N
3054	15	622	2	178	\N	178	\N	\N	0	1	2	f	0	\N	\N
3055	17	622	1	12955	\N	12955	\N	\N	1	1	2	f	\N	\N	\N
3056	6	622	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
3057	19	623	2	969	\N	969	\N	\N	1	1	2	f	0	\N	\N
3058	26	623	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
3059	24	623	2	969	\N	969	\N	\N	0	1	2	f	0	\N	\N
3060	9	623	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3061	15	623	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3062	6	623	1	975	\N	975	\N	\N	1	1	2	f	\N	\N	\N
3063	2	624	2	14980	\N	0	\N	\N	1	1	2	f	14980	\N	\N
3064	19	625	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
3065	24	625	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
3066	6	625	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
3067	19	626	2	79	\N	79	\N	\N	1	1	2	f	0	\N	\N
3068	26	626	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3069	24	626	2	79	\N	79	\N	\N	0	1	2	f	0	\N	\N
3070	9	626	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3071	15	626	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3072	6	626	1	80	\N	80	\N	\N	1	1	2	f	\N	\N	\N
3073	24	627	2	160	\N	160	\N	\N	1	1	2	f	0	\N	\N
3074	26	627	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
3075	19	627	2	160	\N	160	\N	\N	0	1	2	f	0	\N	\N
3076	9	627	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3077	15	627	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3078	17	627	1	163	\N	163	\N	\N	1	1	2	f	\N	\N	\N
3079	24	628	2	8734	\N	8734	\N	\N	1	1	2	f	0	\N	\N
3080	9	628	2	18	\N	18	\N	\N	2	1	2	f	0	\N	\N
3081	19	628	2	8734	\N	8734	\N	\N	0	1	2	f	0	\N	\N
3082	15	628	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
3083	25	628	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
3084	26	628	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3085	6	628	1	8630	\N	8630	\N	\N	1	1	2	f	\N	\N	\N
3086	17	628	1	122	\N	122	\N	\N	2	1	2	f	\N	\N	\N
3087	24	629	2	19294	\N	19294	\N	\N	1	1	2	f	0	\N	\N
3088	26	629	2	22	\N	22	\N	\N	2	1	2	f	0	\N	\N
3089	19	629	2	19294	\N	19294	\N	\N	0	1	2	f	0	\N	\N
3090	9	629	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
3091	15	629	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
3092	17	629	1	19297	\N	19297	\N	\N	1	1	2	f	\N	\N	\N
3093	6	629	1	19	\N	19	\N	\N	2	1	2	f	\N	\N	\N
3094	24	630	2	9690	\N	9690	\N	\N	1	1	2	f	0	\N	\N
3095	26	630	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
3096	19	630	2	9690	\N	9690	\N	\N	0	1	2	f	0	\N	\N
3097	9	630	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3098	15	630	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3099	6	630	1	9693	\N	9693	\N	\N	1	1	2	f	\N	\N	\N
3100	17	630	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
3101	26	631	2	18007	\N	18007	\N	\N	1	1	2	f	0	\N	\N
3102	24	631	2	328	\N	328	\N	\N	2	1	2	f	0	\N	\N
3103	9	631	2	18007	\N	18007	\N	\N	0	1	2	f	0	\N	\N
3104	15	631	2	18007	\N	18007	\N	\N	0	1	2	f	0	\N	\N
3105	19	631	2	328	\N	328	\N	\N	0	1	2	f	0	\N	\N
3106	17	631	1	17598	\N	17598	\N	\N	1	1	2	f	\N	\N	\N
3107	6	631	1	737	\N	737	\N	\N	2	1	2	f	\N	\N	\N
3108	24	632	2	2103	\N	2103	\N	\N	1	1	2	f	0	\N	\N
3109	26	632	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
3110	19	632	2	2103	\N	2103	\N	\N	0	1	2	f	0	\N	\N
3111	9	632	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3112	15	632	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3113	6	632	1	2105	\N	2105	\N	\N	1	1	2	f	\N	\N	\N
3114	17	632	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3115	24	633	2	125	\N	125	\N	\N	1	1	2	f	0	\N	\N
3116	26	633	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3117	19	633	2	125	\N	125	\N	\N	0	1	2	f	0	\N	\N
3118	9	633	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3119	15	633	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3120	6	633	1	126	\N	126	\N	\N	1	1	2	f	\N	\N	\N
3121	6	634	2	1927628	\N	1927628	\N	\N	1	1	2	f	0	\N	\N
3122	24	635	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
3123	26	635	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
3124	19	635	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
3125	9	635	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3126	15	635	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3127	6	635	1	57	\N	57	\N	\N	1	1	2	f	\N	\N	\N
3128	17	635	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3129	24	636	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
3130	19	636	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
3131	6	636	1	35	\N	35	\N	\N	1	1	2	f	\N	\N	\N
3132	17	636	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3133	24	637	2	17820	\N	17820	\N	\N	1	1	2	f	0	\N	\N
3134	26	637	2	459	\N	459	\N	\N	2	1	2	f	0	\N	\N
3135	19	637	2	17820	\N	17820	\N	\N	0	1	2	f	0	\N	\N
3136	9	637	2	459	\N	459	\N	\N	0	1	2	f	0	\N	\N
3137	15	637	2	459	\N	459	\N	\N	0	1	2	f	0	\N	\N
3138	6	637	1	18274	\N	18274	\N	\N	1	1	2	f	\N	\N	\N
3139	17	637	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
3140	24	638	2	1184	\N	1184	\N	\N	1	1	2	f	0	\N	\N
3141	19	638	2	1184	\N	1184	\N	\N	0	1	2	f	0	\N	\N
3142	17	638	1	864	\N	864	\N	\N	1	1	2	f	\N	\N	\N
3143	6	638	1	320	\N	320	\N	\N	2	1	2	f	\N	\N	\N
3144	24	639	2	4092	\N	4092	\N	\N	1	1	2	f	0	\N	\N
3145	25	639	2	222	\N	222	\N	\N	2	1	2	f	0	\N	\N
3146	19	639	2	4092	\N	4092	\N	\N	0	1	2	f	0	\N	\N
3147	9	639	2	222	\N	222	\N	\N	0	1	2	f	0	\N	\N
3148	15	639	2	222	\N	222	\N	\N	0	1	2	f	0	\N	\N
3149	17	639	1	4281	\N	4281	\N	\N	1	1	2	f	\N	\N	\N
3150	6	639	1	33	\N	33	\N	\N	2	1	2	f	\N	\N	\N
3151	24	640	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
3152	19	640	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3153	6	640	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3154	17	640	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3155	21	641	2	411729	\N	411729	\N	\N	1	1	2	f	0	\N	\N
3156	5	641	2	411729	\N	411729	\N	\N	0	1	2	f	0	\N	\N
3157	19	642	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3158	24	642	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3159	6	642	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
3160	19	643	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
3161	24	643	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3162	6	643	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
3163	17	643	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3164	19	644	2	2484	\N	2484	\N	\N	1	1	2	f	0	\N	\N
3165	9	644	2	200	\N	200	\N	\N	2	1	2	f	0	\N	\N
3166	24	644	2	2484	\N	2484	\N	\N	0	1	2	f	0	\N	\N
3167	15	644	2	200	\N	200	\N	\N	0	1	2	f	0	\N	\N
3168	25	644	2	198	\N	198	\N	\N	0	1	2	f	0	\N	\N
3169	26	644	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3170	6	644	1	2460	\N	2460	\N	\N	1	1	2	f	\N	\N	\N
3171	17	644	1	224	\N	224	\N	\N	2	1	2	f	\N	\N	\N
3172	11	645	2	102	\N	0	\N	\N	1	1	2	f	102	\N	\N
3173	19	646	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
3174	24	646	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3175	17	646	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
3176	26	647	2	1217	\N	1217	\N	\N	1	1	2	f	0	\N	\N
3177	19	647	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3178	9	647	2	1217	\N	1217	\N	\N	0	1	2	f	0	\N	\N
3179	15	647	2	1217	\N	1217	\N	\N	0	1	2	f	0	\N	\N
3180	24	647	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3181	6	647	1	1209	\N	1209	\N	\N	1	1	2	f	\N	\N	\N
3182	17	647	1	12	\N	12	\N	\N	2	1	2	f	\N	\N	\N
3183	2	648	2	1749978	\N	1749978	\N	\N	1	1	2	f	0	\N	\N
3184	2	648	1	39620	\N	39620	\N	\N	1	1	2	f	\N	\N	\N
3185	19	649	2	2203	\N	2203	\N	\N	1	1	2	f	0	\N	\N
3186	26	649	2	139	\N	139	\N	\N	2	1	2	f	0	\N	\N
3187	24	649	2	2203	\N	2203	\N	\N	0	1	2	f	0	\N	\N
3188	9	649	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
3189	15	649	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
3190	6	649	1	2341	\N	2341	\N	\N	1	1	2	f	\N	\N	\N
3191	17	649	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3192	24	650	2	2302	\N	2302	\N	\N	1	1	2	f	0	\N	\N
3193	19	650	2	2302	\N	2302	\N	\N	0	1	2	f	0	\N	\N
3194	6	650	1	2300	\N	2300	\N	\N	1	1	2	f	\N	\N	\N
3195	17	650	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
3196	24	651	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
3197	26	651	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3198	19	651	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
3199	9	651	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3200	15	651	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3201	6	651	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
3202	9	652	2	2127349	\N	2127349	\N	\N	1	1	2	f	0	\N	\N
3203	15	652	2	2127349	\N	2127349	\N	\N	0	1	2	f	0	\N	\N
3204	6	652	1	2109620	\N	2109620	\N	\N	1	1	2	f	\N	\N	\N
3205	17	652	1	17729	\N	17729	\N	\N	2	1	2	f	\N	\N	\N
3206	12	653	1	4507	\N	4507	\N	\N	1	1	2	f	\N	\N	\N
3207	24	654	2	140	\N	140	\N	\N	1	1	2	f	0	\N	\N
3208	19	654	2	140	\N	140	\N	\N	0	1	2	f	0	\N	\N
3209	17	654	1	137	\N	137	\N	\N	1	1	2	f	\N	\N	\N
3210	6	654	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
3211	24	655	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
3212	19	655	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3213	6	655	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
3214	24	656	2	47	\N	47	\N	\N	1	1	2	f	0	\N	\N
3215	19	656	2	47	\N	47	\N	\N	0	1	2	f	0	\N	\N
3216	6	656	1	40	\N	40	\N	\N	1	1	2	f	\N	\N	\N
3217	17	656	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
3218	26	657	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
3219	9	657	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3220	15	657	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3221	6	657	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
3222	24	658	2	15189571	\N	15189571	\N	\N	1	1	2	f	0	\N	\N
3223	21	658	2	2125872	\N	2125872	\N	\N	2	1	2	f	0	\N	\N
3224	19	658	2	15189571	\N	15189571	\N	\N	0	1	2	f	0	\N	\N
3225	5	658	2	2125872	\N	2125872	\N	\N	0	1	2	f	0	\N	\N
3226	2	658	1	4251744	\N	4251744	\N	\N	1	1	2	f	\N	\N	\N
3227	24	659	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3228	19	659	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3229	6	659	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3230	24	660	2	210	\N	210	\N	\N	1	1	2	f	0	\N	\N
3231	19	660	2	210	\N	210	\N	\N	0	1	2	f	0	\N	\N
3232	6	660	1	210	\N	210	\N	\N	1	1	2	f	\N	\N	\N
3233	21	661	2	430	\N	430	\N	\N	1	1	2	f	0	\N	\N
3234	5	661	2	430	\N	430	\N	\N	0	1	2	f	0	\N	\N
3235	26	662	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
3236	24	662	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3237	9	662	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3238	15	662	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3239	19	662	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3240	6	662	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
3241	24	663	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
3242	26	663	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
3243	19	663	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
3244	9	663	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3245	15	663	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3246	6	663	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
3247	17	663	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
3248	24	664	2	610	\N	610	\N	\N	1	1	2	f	0	\N	\N
3249	25	664	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
3250	19	664	2	610	\N	610	\N	\N	0	1	2	f	0	\N	\N
3251	9	664	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3252	15	664	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3253	17	664	1	525	\N	525	\N	\N	1	1	2	f	\N	\N	\N
3254	6	664	1	88	\N	88	\N	\N	2	1	2	f	\N	\N	\N
3255	24	665	2	137	\N	137	\N	\N	1	1	2	f	0	\N	\N
3256	26	665	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3257	19	665	2	137	\N	137	\N	\N	0	1	2	f	0	\N	\N
3258	9	665	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3259	15	665	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3260	6	665	1	138	\N	138	\N	\N	1	1	2	f	\N	\N	\N
3261	17	665	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3262	24	666	2	118	\N	118	\N	\N	1	1	2	f	0	\N	\N
3263	19	666	2	118	\N	118	\N	\N	0	1	2	f	0	\N	\N
3264	6	666	1	111	\N	111	\N	\N	1	1	2	f	\N	\N	\N
3265	17	666	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
3266	24	667	2	1916	\N	1916	\N	\N	1	1	2	f	0	\N	\N
3267	19	667	2	1916	\N	1916	\N	\N	0	1	2	f	0	\N	\N
3268	6	667	1	1903	\N	1903	\N	\N	1	1	2	f	\N	\N	\N
3269	17	667	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
3270	24	668	2	113	\N	113	\N	\N	1	1	2	f	0	\N	\N
3271	19	668	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
3272	6	668	1	112	\N	112	\N	\N	1	1	2	f	\N	\N	\N
3273	17	668	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3274	24	669	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
3275	19	669	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3276	6	669	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
3277	24	670	2	1431	\N	1431	\N	\N	1	1	2	f	0	\N	\N
3278	25	670	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
3279	19	670	2	1431	\N	1431	\N	\N	0	1	2	f	0	\N	\N
3280	9	670	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3281	15	670	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3282	6	670	1	1260	\N	1260	\N	\N	1	1	2	f	\N	\N	\N
3283	17	670	1	182	\N	182	\N	\N	2	1	2	f	\N	\N	\N
3284	24	671	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
3285	19	671	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3286	17	671	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
3287	24	672	2	63	\N	63	\N	\N	1	1	2	f	0	\N	\N
3288	19	672	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
3289	6	672	1	63	\N	63	\N	\N	1	1	2	f	\N	\N	\N
3290	24	673	2	37789	\N	37789	\N	\N	1	1	2	f	0	\N	\N
3291	25	673	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
3292	19	673	2	37789	\N	37789	\N	\N	0	1	2	f	0	\N	\N
3293	9	673	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3294	15	673	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3295	6	673	1	37176	\N	37176	\N	\N	1	1	2	f	\N	\N	\N
3296	17	673	1	620	\N	620	\N	\N	2	1	2	f	\N	\N	\N
3297	24	674	2	2365	\N	2365	\N	\N	1	1	2	f	0	\N	\N
3298	9	674	2	556	\N	556	\N	\N	2	1	2	f	0	\N	\N
3299	19	674	2	2365	\N	2365	\N	\N	0	1	2	f	0	\N	\N
3300	15	674	2	556	\N	556	\N	\N	0	1	2	f	0	\N	\N
3301	25	674	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
3302	23	674	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3303	6	674	1	2294	\N	2294	\N	\N	1	1	2	f	\N	\N	\N
3304	17	674	1	627	\N	627	\N	\N	2	1	2	f	\N	\N	\N
3305	24	675	2	13063699	\N	13063699	\N	\N	1	1	2	f	0	\N	\N
3306	6	675	2	7609507	\N	7609507	\N	\N	2	1	2	f	0	\N	\N
3307	9	675	2	2584941	\N	2584941	\N	\N	3	1	2	f	0	\N	\N
3308	17	675	2	984637	\N	984637	\N	\N	4	1	2	f	0	\N	\N
3309	2	675	2	388211	\N	388211	\N	\N	5	1	2	f	0	\N	\N
3310	11	675	2	153275	\N	153275	\N	\N	6	1	2	f	0	\N	\N
3311	12	675	2	4873	\N	4873	\N	\N	7	1	2	f	0	\N	\N
3312	19	675	2	13063699	\N	13063699	\N	\N	0	1	2	f	0	\N	\N
3313	15	675	2	2584941	\N	2584941	\N	\N	0	1	2	f	0	\N	\N
3314	25	675	2	550197	\N	550197	\N	\N	0	1	2	f	0	\N	\N
3315	26	675	2	62245	\N	62245	\N	\N	0	1	2	f	0	\N	\N
3316	23	675	2	16305	\N	16305	\N	\N	0	1	2	f	0	\N	\N
3317	2	675	1	82	\N	82	\N	\N	1	1	2	f	\N	\N	\N
3318	24	676	2	2445	\N	2445	\N	\N	1	1	2	f	0	\N	\N
3319	26	676	2	44	\N	44	\N	\N	2	1	2	f	0	\N	\N
3320	19	676	2	2445	\N	2445	\N	\N	0	1	2	f	0	\N	\N
3321	9	676	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
3322	15	676	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
3323	6	676	1	2485	\N	2485	\N	\N	1	1	2	f	\N	\N	\N
3324	17	676	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
3325	24	677	2	45	\N	45	\N	\N	1	1	2	f	0	\N	\N
3326	19	677	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
3327	17	677	1	41	\N	41	\N	\N	1	1	2	f	\N	\N	\N
3328	6	677	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
3329	19	678	2	11768515	\N	11768515	\N	\N	1	1	2	f	0	\N	\N
3330	9	678	2	2350570	\N	2350570	\N	\N	2	1	2	f	0	\N	\N
3331	2	678	2	3808	\N	3808	\N	\N	3	1	2	f	0	\N	\N
3332	24	678	2	11768515	\N	11768515	\N	\N	0	1	2	f	0	\N	\N
3333	15	678	2	2350570	\N	2350570	\N	\N	0	1	2	f	0	\N	\N
3334	25	678	2	515754	\N	515754	\N	\N	0	1	2	f	0	\N	\N
3335	23	678	2	17813	\N	17813	\N	\N	0	1	2	f	0	\N	\N
3336	19	679	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
3337	26	679	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3338	24	679	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
3339	9	679	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3340	15	679	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3341	6	679	1	15	\N	15	\N	\N	1	1	2	f	\N	\N	\N
3342	26	680	2	7447	\N	7447	\N	\N	1	1	2	f	0	\N	\N
3343	19	680	2	277	\N	277	\N	\N	2	1	2	f	0	\N	\N
3344	9	680	2	7447	\N	7447	\N	\N	0	1	2	f	0	\N	\N
3345	15	680	2	7447	\N	7447	\N	\N	0	1	2	f	0	\N	\N
3346	24	680	2	277	\N	277	\N	\N	0	1	2	f	0	\N	\N
3347	6	680	1	7689	\N	7689	\N	\N	1	1	2	f	\N	\N	\N
3348	17	680	1	35	\N	35	\N	\N	2	1	2	f	\N	\N	\N
3349	19	681	2	504	\N	504	\N	\N	1	1	2	f	0	\N	\N
3350	24	681	2	504	\N	504	\N	\N	0	1	2	f	0	\N	\N
3351	6	681	1	504	\N	504	\N	\N	1	1	2	f	\N	\N	\N
3352	26	682	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3353	9	682	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3354	15	682	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3355	6	682	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3356	19	683	2	64	\N	64	\N	\N	1	1	2	f	0	\N	\N
3357	26	683	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
3358	24	683	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
3359	9	683	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
3360	15	683	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
3361	6	683	1	78	\N	78	\N	\N	1	1	2	f	\N	\N	\N
3362	17	683	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3363	24	684	2	142	\N	142	\N	\N	1	1	2	f	0	\N	\N
3364	25	684	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3365	19	684	2	142	\N	142	\N	\N	0	1	2	f	0	\N	\N
3366	9	684	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3367	15	684	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3368	17	684	1	130	\N	130	\N	\N	1	1	2	f	\N	\N	\N
3369	6	684	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
3370	17	685	2	253398	\N	253398	\N	\N	1	1	2	f	0	\N	\N
3371	12	685	1	217413	\N	217413	\N	\N	1	1	2	f	\N	\N	\N
3372	24	686	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3373	19	686	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3374	6	686	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
3375	9	687	2	2530649	\N	0	\N	\N	1	1	2	f	2530649	\N	\N
3376	11	687	2	120500	\N	0	\N	\N	2	1	2	f	120500	\N	\N
3377	12	687	2	2698	\N	0	\N	\N	3	1	2	f	2698	\N	\N
3378	10	687	2	65	\N	0	\N	\N	4	1	2	f	65	\N	\N
3379	20	687	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
3380	15	687	2	2530649	\N	0	\N	\N	0	1	2	f	2530649	\N	\N
3381	25	687	2	515304	\N	0	\N	\N	0	1	2	f	515304	\N	\N
3382	26	687	2	62245	\N	0	\N	\N	0	1	2	f	62245	\N	\N
3383	23	687	2	16305	\N	0	\N	\N	0	1	2	f	16305	\N	\N
3384	13	687	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
3385	16	687	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3386	14	687	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3387	21	688	2	13062848	\N	0	\N	\N	1	1	2	f	13062848	\N	\N
3388	9	688	2	2530649	\N	0	\N	\N	2	1	2	f	2530649	\N	\N
3389	7	688	2	5167	\N	0	\N	\N	3	1	2	f	5167	\N	\N
3390	5	688	2	13062848	\N	0	\N	\N	0	1	2	f	13062848	\N	\N
3391	15	688	2	2530649	\N	0	\N	\N	0	1	2	f	2530649	\N	\N
3392	25	688	2	515304	\N	0	\N	\N	0	1	2	f	515304	\N	\N
3393	26	688	2	62245	\N	0	\N	\N	0	1	2	f	62245	\N	\N
3394	23	688	2	16305	\N	0	\N	\N	0	1	2	f	16305	\N	\N
3395	1	688	2	5167	\N	0	\N	\N	0	1	2	f	5167	\N	\N
3396	6	689	2	271905	\N	0	\N	\N	1	1	2	f	271905	\N	\N
3397	19	690	2	2051	\N	2051	\N	\N	1	1	2	f	0	\N	\N
3398	9	690	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3399	24	690	2	2051	\N	2051	\N	\N	0	1	2	f	0	\N	\N
3400	15	690	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3401	26	690	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3402	25	690	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3403	6	690	1	2017	\N	2017	\N	\N	1	1	2	f	\N	\N	\N
3404	17	690	1	38	\N	38	\N	\N	2	1	2	f	\N	\N	\N
3405	19	691	2	8253	\N	8253	\N	\N	1	1	2	f	0	\N	\N
3406	26	691	2	21	\N	21	\N	\N	2	1	2	f	0	\N	\N
3407	24	691	2	8253	\N	8253	\N	\N	0	1	2	f	0	\N	\N
3408	9	691	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
3409	15	691	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
3410	6	691	1	8270	\N	8270	\N	\N	1	1	2	f	\N	\N	\N
3411	17	691	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
3412	19	692	2	405364	\N	405364	\N	\N	1	1	2	f	0	\N	\N
3413	26	692	2	10645	\N	10645	\N	\N	2	1	2	f	0	\N	\N
3414	24	692	2	405364	\N	405364	\N	\N	0	1	2	f	0	\N	\N
3415	9	692	2	10645	\N	10645	\N	\N	0	1	2	f	0	\N	\N
3416	15	692	2	10645	\N	10645	\N	\N	0	1	2	f	0	\N	\N
3417	6	692	1	415089	\N	415089	\N	\N	1	1	2	f	\N	\N	\N
3418	17	692	1	920	\N	920	\N	\N	2	1	2	f	\N	\N	\N
3419	19	693	2	1458	\N	1458	\N	\N	1	1	2	f	0	\N	\N
3420	26	693	2	41	\N	41	\N	\N	2	1	2	f	0	\N	\N
3421	24	693	2	1458	\N	1458	\N	\N	0	1	2	f	0	\N	\N
3422	9	693	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
3423	15	693	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
3424	6	693	1	1491	\N	1491	\N	\N	1	1	2	f	\N	\N	\N
3425	17	693	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
3426	19	694	2	5567	\N	5567	\N	\N	1	1	2	f	0	\N	\N
3427	26	694	2	65	\N	65	\N	\N	2	1	2	f	0	\N	\N
3428	24	694	2	5567	\N	5567	\N	\N	0	1	2	f	0	\N	\N
3429	9	694	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
3430	15	694	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
3431	6	694	1	5632	\N	5632	\N	\N	1	1	2	f	\N	\N	\N
3432	19	695	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
3433	24	695	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3434	6	695	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
3435	19	696	2	915	\N	915	\N	\N	1	1	2	f	0	\N	\N
3436	26	696	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3437	24	696	2	915	\N	915	\N	\N	0	1	2	f	0	\N	\N
3438	9	696	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3439	15	696	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3440	6	696	1	915	\N	915	\N	\N	1	1	2	f	\N	\N	\N
3441	17	696	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
3442	19	697	2	109	\N	109	\N	\N	1	1	2	f	0	\N	\N
3443	24	697	2	109	\N	109	\N	\N	0	1	2	f	0	\N	\N
3444	17	697	1	70	\N	70	\N	\N	1	1	2	f	\N	\N	\N
3445	6	697	1	39	\N	39	\N	\N	2	1	2	f	\N	\N	\N
3446	19	698	2	91	\N	91	\N	\N	1	1	2	f	0	\N	\N
3447	26	698	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3448	24	698	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
3449	9	698	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3450	15	698	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3451	6	698	1	92	\N	92	\N	\N	1	1	2	f	\N	\N	\N
3452	19	699	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3453	24	699	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3454	6	699	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
3455	19	700	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
3456	24	700	2	112	\N	112	\N	\N	0	1	2	f	0	\N	\N
3457	6	700	1	112	\N	112	\N	\N	1	1	2	f	\N	\N	\N
3458	11	701	2	118	\N	0	\N	\N	1	1	2	f	118	\N	\N
3459	26	702	2	350	\N	350	\N	\N	1	1	2	f	0	\N	\N
3460	19	702	2	50	\N	50	\N	\N	2	1	2	f	0	\N	\N
3461	9	702	2	350	\N	350	\N	\N	0	1	2	f	0	\N	\N
3462	15	702	2	350	\N	350	\N	\N	0	1	2	f	0	\N	\N
3463	24	702	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
3464	6	702	1	397	\N	397	\N	\N	1	1	2	f	\N	\N	\N
3465	17	702	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
3466	19	703	2	12503	\N	12503	\N	\N	1	1	2	f	0	\N	\N
3467	26	703	2	500	\N	500	\N	\N	2	1	2	f	0	\N	\N
3468	24	703	2	12503	\N	12503	\N	\N	0	1	2	f	0	\N	\N
3469	9	703	2	500	\N	500	\N	\N	0	1	2	f	0	\N	\N
3470	15	703	2	500	\N	500	\N	\N	0	1	2	f	0	\N	\N
3471	6	703	1	13003	\N	13003	\N	\N	1	1	2	f	\N	\N	\N
3472	26	704	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
3473	19	704	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3474	9	704	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3475	15	704	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3476	24	704	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3477	6	704	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
3478	19	705	2	99	\N	99	\N	\N	1	1	2	f	0	\N	\N
3479	24	705	2	99	\N	99	\N	\N	0	1	2	f	0	\N	\N
3480	6	705	1	99	\N	99	\N	\N	1	1	2	f	\N	\N	\N
3481	19	706	2	17	\N	17	\N	\N	1	1	2	f	0	\N	\N
3482	24	706	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
3483	6	706	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
3484	19	707	2	2997	\N	2997	\N	\N	1	1	2	f	0	\N	\N
3485	25	707	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3486	24	707	2	2997	\N	2997	\N	\N	0	1	2	f	0	\N	\N
3487	9	707	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3488	15	707	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3489	6	707	1	3001	\N	3001	\N	\N	1	1	2	f	\N	\N	\N
3490	19	708	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3491	24	708	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3492	6	708	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
3493	8	709	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
3494	26	710	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3495	9	710	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3496	15	710	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3497	6	710	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3498	21	711	2	133527	\N	0	\N	\N	1	1	2	f	133527	\N	\N
3499	5	711	2	133527	\N	0	\N	\N	0	1	2	f	133527	\N	\N
3500	19	712	2	32517	\N	32517	\N	\N	1	1	2	f	0	\N	\N
3501	25	712	2	59	\N	59	\N	\N	2	1	2	f	0	\N	\N
3502	24	712	2	32517	\N	32517	\N	\N	0	1	2	f	0	\N	\N
3503	9	712	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3504	15	712	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3505	6	712	1	31551	\N	31551	\N	\N	1	1	2	f	\N	\N	\N
3506	17	712	1	1025	\N	1025	\N	\N	2	1	2	f	\N	\N	\N
3507	2	713	2	120398	\N	120398	\N	\N	1	1	2	f	0	\N	\N
3508	2	713	1	120398	\N	120398	\N	\N	1	1	2	f	\N	\N	\N
3509	9	714	2	548153	\N	548153	\N	\N	1	1	2	f	0	\N	\N
3510	15	714	2	548153	\N	548153	\N	\N	0	1	2	f	0	\N	\N
3511	25	714	2	513579	\N	513579	\N	\N	0	1	2	f	0	\N	\N
3512	23	714	2	16301	\N	16301	\N	\N	0	1	2	f	0	\N	\N
3513	2	714	1	27364	\N	27364	\N	\N	1	1	2	f	\N	\N	\N
3514	19	715	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
3515	26	715	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
3516	24	715	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
3517	9	715	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3518	15	715	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3519	6	715	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
3520	19	716	2	18964	\N	18964	\N	\N	1	1	2	f	0	\N	\N
3521	26	716	2	794	\N	794	\N	\N	2	1	2	f	0	\N	\N
3522	24	716	2	18964	\N	18964	\N	\N	0	1	2	f	0	\N	\N
3523	9	716	2	794	\N	794	\N	\N	0	1	2	f	0	\N	\N
3524	15	716	2	794	\N	794	\N	\N	0	1	2	f	0	\N	\N
3525	6	716	1	19758	\N	19758	\N	\N	1	1	2	f	\N	\N	\N
3526	9	717	2	1842613	\N	1842613	\N	\N	1	1	2	f	0	\N	\N
3527	15	717	2	1842613	\N	1842613	\N	\N	0	1	2	f	0	\N	\N
3528	12	717	1	1842613	\N	1842613	\N	\N	1	1	2	f	\N	\N	\N
3529	26	718	2	7439	\N	7439	\N	\N	1	1	2	f	0	\N	\N
3530	19	718	2	5192	\N	5192	\N	\N	2	1	2	f	0	\N	\N
3531	9	718	2	7439	\N	7439	\N	\N	0	1	2	f	0	\N	\N
3532	15	718	2	7439	\N	7439	\N	\N	0	1	2	f	0	\N	\N
3533	24	718	2	5192	\N	5192	\N	\N	0	1	2	f	0	\N	\N
3534	6	718	1	10826	\N	10826	\N	\N	1	1	2	f	\N	\N	\N
3535	17	718	1	1805	\N	1805	\N	\N	2	1	2	f	\N	\N	\N
3536	24	719	2	1742	\N	1742	\N	\N	1	1	2	f	0	\N	\N
3537	19	719	2	1742	\N	1742	\N	\N	0	1	2	f	0	\N	\N
3538	6	719	1	1741	\N	1741	\N	\N	1	1	2	f	\N	\N	\N
3539	17	719	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3540	26	720	2	598	\N	598	\N	\N	1	1	2	f	0	\N	\N
3541	9	720	2	598	\N	598	\N	\N	0	1	2	f	0	\N	\N
3542	15	720	2	598	\N	598	\N	\N	0	1	2	f	0	\N	\N
3543	6	720	1	588	\N	588	\N	\N	1	1	2	f	\N	\N	\N
3544	17	720	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
3545	24	721	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3546	19	721	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3547	6	721	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
3548	24	722	2	657	\N	657	\N	\N	1	1	2	f	0	\N	\N
3549	19	722	2	657	\N	657	\N	\N	0	1	2	f	0	\N	\N
3550	6	722	1	639	\N	639	\N	\N	1	1	2	f	\N	\N	\N
3551	17	722	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
3552	24	723	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
3553	26	723	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3554	19	723	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
3555	9	723	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3556	15	723	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3557	6	723	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
3558	24	724	2	8051	\N	8051	\N	\N	1	1	2	f	0	\N	\N
3559	19	724	2	8051	\N	8051	\N	\N	0	1	2	f	0	\N	\N
3560	17	724	1	8051	\N	8051	\N	\N	1	1	2	f	\N	\N	\N
3561	10	725	2	75	\N	0	\N	\N	1	1	2	f	75	\N	\N
3562	18	725	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
3563	24	726	2	5156	\N	5156	\N	\N	1	1	2	f	0	\N	\N
3564	26	726	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3565	19	726	2	5156	\N	5156	\N	\N	0	1	2	f	0	\N	\N
3566	9	726	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3567	15	726	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3568	6	726	1	5150	\N	5150	\N	\N	1	1	2	f	\N	\N	\N
3569	17	726	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
3570	24	727	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
3571	19	727	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
3572	6	727	1	30	\N	30	\N	\N	1	1	2	f	\N	\N	\N
3573	24	728	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
3574	19	728	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
3575	6	728	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
3576	2	729	2	219	\N	0	\N	\N	1	1	2	f	219	\N	\N
3577	10	730	2	63	\N	63	\N	\N	1	1	2	f	0	\N	\N
3578	16	730	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3579	20	730	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3580	13	730	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
3581	24	731	2	32866	\N	32866	\N	\N	1	1	2	f	0	\N	\N
3582	26	731	2	1078	\N	1078	\N	\N	2	1	2	f	0	\N	\N
3583	19	731	2	32866	\N	32866	\N	\N	0	1	2	f	0	\N	\N
3584	9	731	2	1078	\N	1078	\N	\N	0	1	2	f	0	\N	\N
3585	15	731	2	1078	\N	1078	\N	\N	0	1	2	f	0	\N	\N
3586	6	731	1	33944	\N	33944	\N	\N	1	1	2	f	\N	\N	\N
3587	24	732	2	200	\N	200	\N	\N	1	1	2	f	0	\N	\N
3588	26	732	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3589	19	732	2	200	\N	200	\N	\N	0	1	2	f	0	\N	\N
3590	9	732	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3591	15	732	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3592	6	732	1	201	\N	201	\N	\N	1	1	2	f	\N	\N	\N
3593	24	733	2	10432	\N	10432	\N	\N	1	1	2	f	0	\N	\N
3594	9	733	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3595	19	733	2	10432	\N	10432	\N	\N	0	1	2	f	0	\N	\N
3596	15	733	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3597	26	733	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3598	25	733	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3599	6	733	1	10287	\N	10287	\N	\N	1	1	2	f	\N	\N	\N
3600	17	733	1	147	\N	147	\N	\N	2	1	2	f	\N	\N	\N
3601	24	734	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
3602	26	734	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
3603	19	734	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3604	9	734	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3605	15	734	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3606	6	734	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
3607	21	735	2	85121	\N	0	\N	\N	1	1	2	f	85121	\N	\N
3608	5	735	2	85121	\N	0	\N	\N	0	1	2	f	85121	\N	\N
3609	24	736	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3610	19	736	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3611	6	736	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3612	2	737	2	2909874	\N	0	\N	\N	1	1	2	f	2909874	\N	\N
3613	21	738	2	379067	\N	0	\N	\N	1	1	2	f	379067	\N	\N
3614	5	738	2	379067	\N	0	\N	\N	0	1	2	f	379067	\N	\N
3615	24	739	2	2509	\N	2509	\N	\N	1	1	2	f	0	\N	\N
3616	25	739	2	90	\N	90	\N	\N	2	1	2	f	0	\N	\N
3617	19	739	2	2509	\N	2509	\N	\N	0	1	2	f	0	\N	\N
3618	9	739	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
3619	15	739	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
3620	6	739	1	2597	\N	2597	\N	\N	1	1	2	f	\N	\N	\N
3621	17	739	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
3622	2	740	2	239	\N	239	\N	\N	1	1	2	f	0	\N	\N
3623	24	741	2	17	\N	17	\N	\N	1	1	2	f	0	\N	\N
3624	19	741	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
3625	6	741	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
3626	24	742	2	10432	\N	10432	\N	\N	1	1	2	f	0	\N	\N
3627	9	742	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3628	19	742	2	10432	\N	10432	\N	\N	0	1	2	f	0	\N	\N
3629	15	742	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3630	26	742	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3631	25	742	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3632	6	742	1	10287	\N	10287	\N	\N	1	1	2	f	\N	\N	\N
3633	17	742	1	147	\N	147	\N	\N	2	1	2	f	\N	\N	\N
3634	19	743	2	1631	\N	1631	\N	\N	1	1	2	f	0	\N	\N
3635	9	743	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
3636	24	743	2	1631	\N	1631	\N	\N	0	1	2	f	0	\N	\N
3637	15	743	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3638	25	743	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3639	26	743	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3640	6	743	1	1628	\N	1628	\N	\N	1	1	2	f	\N	\N	\N
3641	17	743	1	8	\N	8	\N	\N	2	1	2	f	\N	\N	\N
3642	21	744	2	10690637	\N	0	\N	\N	1	1	2	f	10690637	\N	\N
3643	25	744	2	512947	\N	0	\N	\N	2	1	2	f	512947	\N	\N
3644	5	744	2	10690637	\N	0	\N	\N	0	1	2	f	10690637	\N	\N
3645	9	744	2	512947	\N	0	\N	\N	0	1	2	f	512947	\N	\N
3646	15	744	2	512947	\N	0	\N	\N	0	1	2	f	512947	\N	\N
3647	23	744	2	16309	\N	0	\N	\N	0	1	2	f	16309	\N	\N
3648	19	745	2	32515	\N	32515	\N	\N	1	1	2	f	0	\N	\N
3649	25	745	2	59	\N	59	\N	\N	2	1	2	f	0	\N	\N
3650	24	745	2	32515	\N	32515	\N	\N	0	1	2	f	0	\N	\N
3651	9	745	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3652	15	745	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3653	6	745	1	31549	\N	31549	\N	\N	1	1	2	f	\N	\N	\N
3654	17	745	1	1025	\N	1025	\N	\N	2	1	2	f	\N	\N	\N
3655	19	746	2	3362	\N	3362	\N	\N	1	1	2	f	0	\N	\N
3656	24	746	2	3362	\N	3362	\N	\N	0	1	2	f	0	\N	\N
3657	17	746	1	3240	\N	3240	\N	\N	1	1	2	f	\N	\N	\N
3658	6	746	1	122	\N	122	\N	\N	2	1	2	f	\N	\N	\N
3659	19	747	2	1293	\N	1293	\N	\N	1	1	2	f	0	\N	\N
3660	24	747	2	1293	\N	1293	\N	\N	0	1	2	f	0	\N	\N
3661	6	747	1	1291	\N	1291	\N	\N	1	1	2	f	\N	\N	\N
3662	17	747	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
3663	19	748	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3664	24	748	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3665	6	748	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
3666	19	749	2	10091	\N	10091	\N	\N	1	1	2	f	0	\N	\N
3667	26	749	2	151	\N	151	\N	\N	2	1	2	f	0	\N	\N
3668	24	749	2	10091	\N	10091	\N	\N	0	1	2	f	0	\N	\N
3669	9	749	2	151	\N	151	\N	\N	0	1	2	f	0	\N	\N
3670	15	749	2	151	\N	151	\N	\N	0	1	2	f	0	\N	\N
3671	6	749	1	8620	\N	8620	\N	\N	1	1	2	f	\N	\N	\N
3672	17	749	1	1622	\N	1622	\N	\N	2	1	2	f	\N	\N	\N
3673	19	750	2	22093	\N	22093	\N	\N	1	1	2	f	0	\N	\N
3674	9	750	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
3675	24	750	2	22093	\N	22093	\N	\N	0	1	2	f	0	\N	\N
3676	15	750	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
3677	26	750	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3678	25	750	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3679	17	750	1	19992	\N	19992	\N	\N	1	1	2	f	\N	\N	\N
3680	6	750	1	2111	\N	2111	\N	\N	2	1	2	f	\N	\N	\N
3681	2	751	2	298785	\N	298785	\N	\N	1	1	2	f	0	\N	\N
3682	2	751	1	298785	\N	298785	\N	\N	1	1	2	f	\N	\N	\N
3683	17	752	2	74327	\N	36026	\N	\N	1	1	2	f	38301	\N	\N
3684	19	753	2	83	\N	83	\N	\N	1	1	2	f	0	\N	\N
3685	25	753	2	23	\N	23	\N	\N	2	1	2	f	0	\N	\N
3686	24	753	2	83	\N	83	\N	\N	0	1	2	f	0	\N	\N
3687	9	753	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
3688	15	753	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
3689	23	753	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3690	6	753	1	77	\N	77	\N	\N	1	1	2	f	\N	\N	\N
3691	17	753	1	29	\N	29	\N	\N	2	1	2	f	\N	\N	\N
3692	19	755	2	1806	\N	1806	\N	\N	1	1	2	f	0	\N	\N
3693	25	755	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3694	24	755	2	1806	\N	1806	\N	\N	0	1	2	f	0	\N	\N
3695	9	755	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3696	15	755	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3697	6	755	1	1577	\N	1577	\N	\N	1	1	2	f	\N	\N	\N
3698	17	755	1	233	\N	233	\N	\N	2	1	2	f	\N	\N	\N
3699	19	756	2	9883	\N	9883	\N	\N	1	1	2	f	0	\N	\N
3700	26	756	2	582	\N	582	\N	\N	2	1	2	f	0	\N	\N
3701	24	756	2	9883	\N	9883	\N	\N	0	1	2	f	0	\N	\N
3702	9	756	2	582	\N	582	\N	\N	0	1	2	f	0	\N	\N
3703	15	756	2	582	\N	582	\N	\N	0	1	2	f	0	\N	\N
3704	17	756	1	10421	\N	10421	\N	\N	1	1	2	f	\N	\N	\N
3705	6	756	1	44	\N	44	\N	\N	2	1	2	f	\N	\N	\N
3706	19	757	2	155216	\N	155216	\N	\N	1	1	2	f	0	\N	\N
3707	9	757	2	45	\N	45	\N	\N	2	1	2	f	0	\N	\N
3708	24	757	2	155216	\N	155216	\N	\N	0	1	2	f	0	\N	\N
3709	15	757	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
3710	25	757	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
3711	26	757	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
3712	23	757	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3713	6	757	1	153850	\N	153850	\N	\N	1	1	2	f	\N	\N	\N
3714	17	757	1	1411	\N	1411	\N	\N	2	1	2	f	\N	\N	\N
3715	6	758	2	200678	\N	0	\N	\N	1	1	2	f	200678	\N	\N
3716	19	759	2	453835	\N	453835	\N	\N	1	1	2	f	0	\N	\N
3717	9	759	2	13923	\N	13923	\N	\N	2	1	2	f	0	\N	\N
3718	24	759	2	453835	\N	453835	\N	\N	0	1	2	f	0	\N	\N
3719	15	759	2	13923	\N	13923	\N	\N	0	1	2	f	0	\N	\N
3720	26	759	2	13496	\N	13496	\N	\N	0	1	2	f	0	\N	\N
3721	25	759	2	427	\N	427	\N	\N	0	1	2	f	0	\N	\N
3722	17	759	1	451536	\N	451536	\N	\N	1	1	2	f	\N	\N	\N
3723	6	759	1	16222	\N	16222	\N	\N	2	1	2	f	\N	\N	\N
3724	11	760	2	37743	\N	0	\N	\N	1	1	2	f	37743	\N	\N
3725	21	761	2	27072	\N	0	\N	\N	1	1	2	f	27072	\N	\N
3726	5	761	2	27072	\N	0	\N	\N	0	1	2	f	27072	\N	\N
3727	19	762	2	358427	\N	358427	\N	\N	1	1	2	f	0	\N	\N
3728	9	762	2	177	\N	177	\N	\N	2	1	2	f	0	\N	\N
3729	24	762	2	358427	\N	358427	\N	\N	0	1	2	f	0	\N	\N
3730	15	762	2	177	\N	177	\N	\N	0	1	2	f	0	\N	\N
3731	25	762	2	110	\N	110	\N	\N	0	1	2	f	0	\N	\N
3732	26	762	2	67	\N	67	\N	\N	0	1	2	f	0	\N	\N
3733	23	762	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3734	6	762	1	332587	\N	332587	\N	\N	1	1	2	f	\N	\N	\N
3735	17	762	1	26017	\N	26017	\N	\N	2	1	2	f	\N	\N	\N
3736	2	763	2	3834	\N	0	\N	\N	1	1	2	f	3834	\N	\N
3737	19	764	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
3738	24	764	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
3739	6	764	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
3740	21	765	2	46829	\N	46829	\N	\N	1	1	2	f	0	\N	\N
3741	5	765	2	46829	\N	46829	\N	\N	0	1	2	f	0	\N	\N
3742	6	766	2	386814	\N	386814	\N	\N	1	1	2	f	0	\N	\N
3743	12	766	1	386814	\N	386814	\N	\N	1	1	2	f	\N	\N	\N
3744	2	767	2	7322941	\N	7322941	\N	\N	1	1	2	f	0	\N	\N
3745	24	768	2	276368	\N	276368	\N	\N	1	1	2	f	0	\N	\N
3746	19	768	2	276368	\N	276368	\N	\N	0	1	2	f	0	\N	\N
3747	17	768	1	270959	\N	270959	\N	\N	1	1	2	f	\N	\N	\N
3748	6	768	1	5409	\N	5409	\N	\N	2	1	2	f	\N	\N	\N
3749	24	769	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
3750	19	769	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
3751	6	769	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
3752	6	770	2	386814	\N	386814	\N	\N	1	1	2	f	0	\N	\N
3753	12	770	1	386814	\N	386814	\N	\N	1	1	2	f	\N	\N	\N
3754	6	771	2	387880	\N	387880	\N	\N	1	1	2	f	0	\N	\N
3755	12	771	1	387880	\N	387880	\N	\N	1	1	2	f	\N	\N	\N
3756	24	772	2	175170	\N	175170	\N	\N	1	1	2	f	0	\N	\N
3757	25	772	2	270	\N	270	\N	\N	2	1	2	f	0	\N	\N
3758	19	772	2	175170	\N	175170	\N	\N	0	1	2	f	0	\N	\N
3759	9	772	2	270	\N	270	\N	\N	0	1	2	f	0	\N	\N
3760	15	772	2	270	\N	270	\N	\N	0	1	2	f	0	\N	\N
3761	6	772	1	153919	\N	153919	\N	\N	1	1	2	f	\N	\N	\N
3762	17	772	1	21521	\N	21521	\N	\N	2	1	2	f	\N	\N	\N
3763	21	773	2	2704439	\N	2704439	\N	\N	1	1	2	f	0	\N	\N
3764	26	773	2	29995	\N	29995	\N	\N	2	1	2	f	0	\N	\N
3765	5	773	2	2704439	\N	2704439	\N	\N	0	1	2	f	0	\N	\N
3766	9	773	2	29995	\N	29995	\N	\N	0	1	2	f	0	\N	\N
3767	15	773	2	29995	\N	29995	\N	\N	0	1	2	f	0	\N	\N
3768	15	773	1	3093579	\N	3093579	\N	\N	1	1	2	f	\N	\N	\N
3769	9	773	1	3093579	\N	3093579	\N	\N	0	1	2	f	\N	\N	\N
3770	26	774	2	3549	\N	3549	\N	\N	1	1	2	f	0	\N	\N
3771	19	774	2	1249	\N	1249	\N	\N	2	1	2	f	0	\N	\N
3772	9	774	2	3549	\N	3549	\N	\N	0	1	2	f	0	\N	\N
3773	15	774	2	3549	\N	3549	\N	\N	0	1	2	f	0	\N	\N
3774	24	774	2	1249	\N	1249	\N	\N	0	1	2	f	0	\N	\N
3775	17	774	1	4782	\N	4782	\N	\N	1	1	2	f	\N	\N	\N
3776	6	774	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
3777	21	775	2	645741	\N	0	\N	\N	1	1	2	f	645741	\N	\N
3778	5	775	2	645741	\N	0	\N	\N	0	1	2	f	645741	\N	\N
3779	19	776	2	17228	\N	17228	\N	\N	1	1	2	f	0	\N	\N
3780	9	776	2	14794	\N	14794	\N	\N	2	1	2	f	0	\N	\N
3781	24	776	2	17228	\N	17228	\N	\N	0	1	2	f	0	\N	\N
3782	15	776	2	14794	\N	14794	\N	\N	0	1	2	f	0	\N	\N
3783	26	776	2	14793	\N	14793	\N	\N	0	1	2	f	0	\N	\N
3784	25	776	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3785	17	776	1	28037	\N	28037	\N	\N	1	1	2	f	\N	\N	\N
3786	6	776	1	3985	\N	3985	\N	\N	2	1	2	f	\N	\N	\N
3787	19	777	2	60	\N	60	\N	\N	1	1	2	f	0	\N	\N
3788	24	777	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
3789	6	777	1	50	\N	50	\N	\N	1	1	2	f	\N	\N	\N
3790	17	777	1	10	\N	10	\N	\N	2	1	2	f	\N	\N	\N
3791	19	778	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
3792	26	778	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
3793	24	778	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
3794	9	778	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3795	15	778	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
3796	6	778	1	59	\N	59	\N	\N	1	1	2	f	\N	\N	\N
3797	21	779	2	13070969	\N	13070969	\N	\N	1	1	2	f	0	\N	\N
3798	2	779	2	6258462	\N	6258462	\N	\N	2	1	2	f	0	\N	\N
3799	6	779	2	12048	\N	12048	\N	\N	3	1	2	f	0	\N	\N
3800	5	779	2	13070969	\N	13070969	\N	\N	0	1	2	f	0	\N	\N
3801	6	779	1	12048	\N	12048	\N	\N	1	1	2	f	\N	\N	\N
3802	21	780	2	274474	\N	0	\N	\N	1	1	2	f	274474	\N	\N
3803	5	780	2	274474	\N	0	\N	\N	0	1	2	f	274474	\N	\N
3804	26	781	2	25522	\N	25522	\N	\N	1	1	2	f	0	\N	\N
3805	24	781	2	2575	\N	2575	\N	\N	2	1	2	f	0	\N	\N
3806	9	781	2	25522	\N	25522	\N	\N	0	1	2	f	0	\N	\N
3807	15	781	2	25522	\N	25522	\N	\N	0	1	2	f	0	\N	\N
3808	19	781	2	2575	\N	2575	\N	\N	0	1	2	f	0	\N	\N
3809	6	781	1	28018	\N	28018	\N	\N	1	1	2	f	\N	\N	\N
3810	17	781	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
3811	24	782	2	35783	\N	35783	\N	\N	1	1	2	f	0	\N	\N
3812	25	782	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
3813	19	782	2	35783	\N	35783	\N	\N	0	1	2	f	0	\N	\N
3814	9	782	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3815	15	782	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3816	6	782	1	35597	\N	35597	\N	\N	1	1	2	f	\N	\N	\N
3817	17	782	1	188	\N	188	\N	\N	2	1	2	f	\N	\N	\N
3818	26	783	2	25433	\N	25433	\N	\N	1	1	2	f	0	\N	\N
3819	24	783	2	1915	\N	1915	\N	\N	2	1	2	f	0	\N	\N
3820	9	783	2	25433	\N	25433	\N	\N	0	1	2	f	0	\N	\N
3821	15	783	2	25433	\N	25433	\N	\N	0	1	2	f	0	\N	\N
3822	19	783	2	1915	\N	1915	\N	\N	0	1	2	f	0	\N	\N
3823	6	783	1	27269	\N	27269	\N	\N	1	1	2	f	\N	\N	\N
3824	17	783	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
3825	2	784	2	578	\N	578	\N	\N	1	1	2	f	0	\N	\N
3826	26	785	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
3827	9	785	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3828	15	785	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3829	6	785	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
3830	24	786	2	662	\N	662	\N	\N	1	1	2	f	0	\N	\N
3831	26	786	2	89	\N	89	\N	\N	2	1	2	f	0	\N	\N
3832	19	786	2	662	\N	662	\N	\N	0	1	2	f	0	\N	\N
3833	9	786	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
3834	15	786	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
3835	6	786	1	751	\N	751	\N	\N	1	1	2	f	\N	\N	\N
3836	24	787	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
3837	19	787	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3838	17	787	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
3839	9	788	2	72928	\N	72928	\N	\N	1	1	2	f	0	\N	\N
3840	21	788	2	196	\N	196	\N	\N	2	1	2	f	0	\N	\N
3841	15	788	2	72928	\N	72928	\N	\N	0	1	2	f	0	\N	\N
3842	25	788	2	50016	\N	50016	\N	\N	0	1	2	f	0	\N	\N
3843	23	788	2	8463	\N	8463	\N	\N	0	1	2	f	0	\N	\N
3844	5	788	2	196	\N	196	\N	\N	0	1	2	f	0	\N	\N
3845	9	788	1	66702	\N	66702	\N	\N	1	1	2	f	\N	\N	\N
3846	21	788	1	6422	\N	6422	\N	\N	2	1	2	f	\N	\N	\N
3847	15	788	1	66702	\N	66702	\N	\N	0	1	2	f	\N	\N	\N
3848	25	788	1	43790	\N	43790	\N	\N	0	1	2	f	\N	\N	\N
3849	23	788	1	8681	\N	8681	\N	\N	0	1	2	f	\N	\N	\N
3850	5	788	1	6422	\N	6422	\N	\N	0	1	2	f	\N	\N	\N
3851	21	789	2	13063699	\N	13063699	\N	\N	1	1	2	f	0	\N	\N
3852	5	789	2	13063699	\N	13063699	\N	\N	0	1	2	f	0	\N	\N
3853	24	789	1	13063699	\N	13063699	\N	\N	1	1	2	f	\N	\N	\N
3854	19	789	1	13063699	\N	13063699	\N	\N	0	1	2	f	\N	\N	\N
3855	21	790	2	215583	\N	0	\N	\N	1	1	2	f	215583	\N	\N
3856	5	790	2	215583	\N	0	\N	\N	0	1	2	f	215583	\N	\N
3857	21	791	2	178105	\N	0	\N	\N	1	1	2	f	178105	\N	\N
3858	5	791	2	178105	\N	0	\N	\N	0	1	2	f	178105	\N	\N
3859	26	792	2	25676	\N	25676	\N	\N	1	1	2	f	0	\N	\N
3860	24	792	2	1888	\N	1888	\N	\N	2	1	2	f	0	\N	\N
3861	9	792	2	25676	\N	25676	\N	\N	0	1	2	f	0	\N	\N
3862	15	792	2	25676	\N	25676	\N	\N	0	1	2	f	0	\N	\N
3863	19	792	2	1888	\N	1888	\N	\N	0	1	2	f	0	\N	\N
3864	6	792	1	27489	\N	27489	\N	\N	1	1	2	f	\N	\N	\N
3865	17	792	1	75	\N	75	\N	\N	2	1	2	f	\N	\N	\N
3866	24	793	2	6518	\N	6518	\N	\N	1	1	2	f	0	\N	\N
3867	25	793	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
3868	19	793	2	6518	\N	6518	\N	\N	0	1	2	f	0	\N	\N
3869	9	793	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3870	15	793	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3871	6	793	1	6509	\N	6509	\N	\N	1	1	2	f	\N	\N	\N
3872	17	793	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
3873	24	794	2	710	\N	710	\N	\N	1	1	2	f	0	\N	\N
3874	26	794	2	59	\N	59	\N	\N	2	1	2	f	0	\N	\N
3875	19	794	2	710	\N	710	\N	\N	0	1	2	f	0	\N	\N
3876	9	794	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3877	15	794	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
3878	6	794	1	768	\N	768	\N	\N	1	1	2	f	\N	\N	\N
3879	17	794	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
3880	24	795	2	92214	\N	92214	\N	\N	1	1	2	f	0	\N	\N
3881	19	795	2	92214	\N	92214	\N	\N	0	1	2	f	0	\N	\N
3882	17	795	1	90355	\N	90355	\N	\N	1	1	2	f	\N	\N	\N
3883	6	795	1	1859	\N	1859	\N	\N	2	1	2	f	\N	\N	\N
3884	6	796	2	1900027	\N	1900027	\N	\N	1	1	2	f	0	\N	\N
3885	9	796	2	291196	\N	291196	\N	\N	2	1	2	f	0	\N	\N
3886	11	796	2	153868	\N	153868	\N	\N	3	1	2	f	0	\N	\N
3887	7	796	2	5126	\N	5126	\N	\N	4	1	2	f	0	\N	\N
3888	15	796	2	291196	\N	291196	\N	\N	0	1	2	f	0	\N	\N
3889	1	796	2	5126	\N	5126	\N	\N	0	1	2	f	0	\N	\N
3890	26	797	2	120	\N	120	\N	\N	1	1	2	f	0	\N	\N
3891	24	797	2	32	\N	32	\N	\N	2	1	2	f	0	\N	\N
3892	9	797	2	120	\N	120	\N	\N	0	1	2	f	0	\N	\N
3893	15	797	2	120	\N	120	\N	\N	0	1	2	f	0	\N	\N
3894	19	797	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
3895	6	797	1	139	\N	139	\N	\N	1	1	2	f	\N	\N	\N
3896	17	797	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
3897	2	798	2	20600236	\N	0	\N	\N	1	1	2	f	20600236	\N	\N
3898	25	798	2	510666	\N	0	\N	\N	2	1	2	f	510666	\N	\N
3899	9	798	2	510666	\N	0	\N	\N	0	1	2	f	510666	\N	\N
3900	15	798	2	510666	\N	0	\N	\N	0	1	2	f	510666	\N	\N
3901	23	798	2	16299	\N	0	\N	\N	0	1	2	f	16299	\N	\N
3902	21	799	2	12924685	\N	0	\N	\N	1	1	2	f	12924685	\N	\N
3903	2	799	2	6028020	\N	0	\N	\N	2	1	2	f	6028020	\N	\N
3904	5	799	2	12924685	\N	0	\N	\N	0	1	2	f	12924685	\N	\N
3905	19	800	2	148999	\N	148999	\N	\N	1	1	2	f	0	\N	\N
3906	9	800	2	4905	\N	4905	\N	\N	2	1	2	f	0	\N	\N
3907	24	800	2	148999	\N	148999	\N	\N	0	1	2	f	0	\N	\N
3908	15	800	2	4905	\N	4905	\N	\N	0	1	2	f	0	\N	\N
3909	25	800	2	4901	\N	4901	\N	\N	0	1	2	f	0	\N	\N
3910	26	800	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3911	6	800	1	143232	\N	143232	\N	\N	1	1	2	f	\N	\N	\N
3912	17	800	1	10672	\N	10672	\N	\N	2	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://data.bnf.fr/vocabulary/roles/	0	t	0
70	marcrel	http://id.loc.gov/vocabulary/relators/	0	f	0
71	ore	http://www.openarchives.org/ore/terms/	0	f	0
72	dcmit	http://purl.org/dc/dcmitype/	0	f	0
73	mo	http://purl.org/ontology/mo/	0	f	0
74	isothes	http://purl.org/iso25964/skos-thes#	0	f	0
77	rdafrbr	http://rdvocab.info/uri/schema/FRBRentitiesRDA/	0	f	0
80	rdag2	http://rdvocab.info/ElementsGr2/	0	f	0
82	rdrel	http://rdvocab.info/RDARelationshipsWEMI/	0	f	0
85	rdagr1	http://rdvocab.info/Elements/	0	f	0
87	frgeo	http://rdf.insee.fr/geo/	0	f	0
92	ecrm	http://erlangen-crm.org/current/	0	f	0
75	rdac	http://rdaregistry.info/Elements/c/#	0	f	0
76	onto	http://data.bnf.fr/ontology/bnf-onto/	0	f	0
78	time	http://www.w3.org/TR/owl-time/	0	f	0
79	nomisma	http://nomisma.org/ontology#	0	f	0
81	vocab_bio	http://vocab.org/bio/0.1/	0	f	0
83	rdaa	http://rdaregistry.info/Elements/a/#	0	f	0
84	rdam	http://rdaregistry.info/Elements/m/#	0	f	0
86	rdae	http://rdaregistry.info/Elements/e/#	0	f	0
88	topo	http://data.ign.fr/ontology/topo.owl/	0	f	0
89	rdaw	http://rdaregistry.info/Elements/w/#	0	f	0
90	rdau	http://rdaregistry.info/Elements/u/#	0	f	0
91	ismi	http://isni.org/ontology#	0	f	0
93	geonames	http://www.geonames.org/ontology/ontology_v3.1.rdf/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_data_bnf_fr_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_data_bnf_fr_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://data.bnf.fr/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://data.bnf.fr/sparql", "correlationId": "6275593198396867543", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:28:25.532Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://xmlns.com/foaf/0.1/name	4563967	\N	8	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://xmlns.com/foaf/0.1/page	7163276	\N	8	page	page	f	7163276	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.w3.org/2004/02/skos/core#note	2364973	\N	4	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://id.loc.gov/vocabulary/relators/wam	559	\N	70	wam	wam	f	559	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://nomisma.org/ontology#hasWeightStandard	3834	\N	79	hasWeightStandard	hasWeightStandard	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://rdvocab.info/ElementsGr2/biographicalInformation	1844998	\N	80	biographicalInformation	biographicalInformation	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://vocab.org/bio/0.1/death	513186	\N	81	death	death	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://schema.org/genre	253617	\N	9	genre	genre	f	253617	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://rdvocab.info/RDARelationshipsWEMI/electronicReproduction	1462402	\N	82	electronicReproduction	electronicReproduction	f	1462402	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://xmlns.com/foaf/0.1/homepage	126977	\N	8	homepage	homepage	f	126977	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://id.loc.gov/vocabulary/relators/prg	39195	\N	70	prg	prg	f	39195	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://id.loc.gov/vocabulary/relators/prf	154713	\N	70	prf	prf	f	154713	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://id.loc.gov/vocabulary/relators/prd	6049	\N	70	prd	prd	f	6049	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://id.loc.gov/vocabulary/relators/aud	15810	\N	70	aud	aud	f	15810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://purl.org/dc/terms/abstract	622411	\N	5	abstract	abstract	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://purl.org/ontology/bibo/isbn10	2399175	\N	31	isbn10	isbn10	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://purl.org/ontology/bibo/isbn13	2089902	\N	31	isbn13	isbn13	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://id.loc.gov/vocabulary/relators/auc	30	\N	70	auc	auc	f	30	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://id.loc.gov/vocabulary/relators/pro	405468	\N	70	pro	pro	f	405468	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://id.loc.gov/vocabulary/relators/prm	3001	\N	70	prm	prm	f	3001	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
32	http://rdaregistry.info/Elements/a/#P50100	202028	\N	83	P50100	P50100	f	100828	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://rdaregistry.info/Elements/a/#P50102	1927628	\N	83	P50102	P50102	f	1927628	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://data.bnf.fr/ontology/bnf-onto/referenceIGN	37751	\N	76	referenceIGN	referenceIGN	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://id.loc.gov/vocabulary/relators/att	11554	\N	70	att	att	f	11554	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	2	\N	1	first	first	f	2	\N	\N	f	f	\N	20	\N	t	f	\N	\N	\N	t	f	f
43	http://rdaregistry.info/Elements/a/#P50118	200678	\N	83	P50118	P50118	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://id.loc.gov/vocabulary/relators/aui	232664	\N	70	aui	aui	f	232664	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://rdaregistry.info/Elements/a/#P50113	1844998	\N	83	P50113	P50113	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://id.loc.gov/vocabulary/relators/prt	107815	\N	70	prt	prt	f	107815	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://purl.org/dc/terms/extent	730	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://id.loc.gov/vocabulary/relators/aut	10225405	\N	70	aut	aut	f	10225405	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://id.loc.gov/vocabulary/relators/aus	138247	\N	70	aus	aus	f	138247	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://rdaregistry.info/Elements/a/#P50119	292595	\N	83	P50119	P50119	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://data.bnf.fr/vocabulary/roles/r1860	9604	\N	69	[Remixeur (r1860)]	r1860	f	9604	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://data.bnf.fr/vocabulary/roles/r1607	82	\N	69	[Instrumentalist (r1607)]	r1607	f	82	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
11	http://data.bnf.fr/vocabulary/roles/r700	776	\N	69	[Auteur de la collation (r700)]	r700	f	776	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://data.bnf.fr/vocabulary/roles/r940	358	\N	69	[Designer sonore (r940)]	r940	f	358	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://data.bnf.fr/vocabulary/roles/r1850	10174	\N	69	[Disc jockey (r1850)]	r1850	f	10174	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://data.bnf.fr/vocabulary/roles/r1610	292	\N	69	[Harmoniumiste (r1610)]	r1610	f	292	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
20	http://data.bnf.fr/vocabulary/roles/r910	4183	\N	69	[Chef de la mission (r910)]	r910	f	4183	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://data.bnf.fr/vocabulary/roles/r1400	700	\N	69	[Instrumentalist (r1400)]	r1400	f	700	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://data.bnf.fr/vocabulary/roles/r1640	355	\N	69	[Vielleur (r1640)]	r1640	f	355	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
37	http://data.bnf.fr/vocabulary/roles/r1888	2	\N	69	[Ensemble à vent (musique ethnique) (r1888)]	r1888	f	2	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://data.bnf.fr/vocabulary/roles/r1407	66	\N	69	[Instrumentalist (r1407)]	r1407	f	66	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
40	http://data.bnf.fr/vocabulary/roles/r1649	5	\N	69	[Instrumentalist (r1649)]	r1649	f	5	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
41	http://data.bnf.fr/vocabulary/roles/r920	69612	\N	69	[Participant (r920)]	r920	f	69612	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://data.bnf.fr/vocabulary/roles/r1870	2364	\N	69	[Ensemble de cordes (r1870)]	r1870	f	2364	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://data.bnf.fr/vocabulary/roles/r1638	374	\N	69	[Instrumentalist (r1638)]	r1638	f	374	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
54	http://data.bnf.fr/vocabulary/roles/r1637	387	\N	69	[Instrumentalist (r1637)]	r1637	f	387	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
163	http://data.bnf.fr/vocabulary/roles/r101	55	\N	69	[Auteur présumé de l'idée originale (r101)]	r101	f	55	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://data.bnf.fr/vocabulary/roles/r1667	8965	\N	69	[Percussionniste (r1667)]	r1667	f	8965	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://rdaregistry.info/Elements/m/#P30088	514005	\N	84	P30088	P30088	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://rdaregistry.info/Elements/m/#P30086	59757	\N	84	P30086	P30086	f	59757	\N	\N	f	f	26	2	\N	t	f	\N	\N	\N	t	f	f
62	http://rdvocab.info/Elements/placeOfPublication	12246708	\N	85	placeOfPublication	placeOfPublication	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://rdvocab.info/ElementsGr2/corporateHistory	175635	\N	80	corporateHistory	corporateHistory	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://purl.org/dc/terms/valid	1647531	\N	5	valid	valid	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://rdvocab.info/Elements/formOfWork	2061618	\N	85	formOfWork	formOfWork	f	2061618	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://id.loc.gov/vocabulary/relators/nrt	98418	\N	70	nrt	nrt	f	98418	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://rdvocab.info/Elements/note	7362548	\N	85	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://data.bnf.fr/ontology/bnf-onto/NoticeDeRegroupement	795	\N	76	NoticeDeRegroupement	NoticeDeRegroupement	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://data.bnf.fr/ontology/bnf-onto/frenchNationalBibliographyID	3685346	\N	76	frenchNationalBibliographyID	frenchNationalBibliographyID	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://rdvocab.info/Elements/dateOfPublicationManifestation	11627612	\N	85	dateOfPublicationManifestation	dateOfPublicationManifestation	f	11627612	\N	\N	f	f	21	12	\N	t	f	\N	\N	\N	t	f	f
95	http://xmlns.com/foaf/0.1/givenName	4133135	\N	8	givenName	givenName	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://purl.org/dc/terms/contributor	21281048	\N	5	contributor	contributor	f	21281048	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://purl.org/dc/terms/isPartOf	230391	\N	5	isPartOf	isPartOf	f	230391	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://data.bnf.fr/ontology/bnf-onto/lastYear	2374486	\N	76	lastYear	lastYear	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	2	\N	1	rest	rest	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://id.loc.gov/vocabulary/relators/sad	2055	\N	70	sad	sad	f	2055	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://data.bnf.fr/vocabulary/roles/r1818	62	\N	69	[Ensemble vocal (musique ethnique) (r1818)]	r1818	f	62	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://data.bnf.fr/vocabulary/roles/r1817	7976	\N	69	[Groupe vocal (r1817)]	r1817	f	7976	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://data.bnf.fr/vocabulary/roles/r4090	41924	\N	69	[Ancien détenteur (r4090)]	r4090	f	41924	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://data.bnf.fr/vocabulary/roles/r730	4603	\N	69	[Transcripteur (r730)]	r730	f	4603	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://data.bnf.fr/vocabulary/roles/r980	3445	\N	69	[Auteur ou responsable intellectuel (autre) (r980)]	r980	f	3445	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://data.bnf.fr/vocabulary/roles/r748	1983	\N	69	[Magistrat monétaire (r748)]	r748	f	1983	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
67	http://data.bnf.fr/vocabulary/roles/r505	738	\N	69	[Assistant metteur en scène (r505)]	r505	f	738	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
68	http://data.bnf.fr/vocabulary/roles/r747	2	\N	69	[Atelier monétaire prétendu (r747)]	r747	f	2	\N	\N	f	f	24	17	\N	t	f	\N	\N	\N	t	f	f
69	http://data.bnf.fr/vocabulary/roles/r1807	2681	\N	69	[Chœur à voix égales (r1807)]	r1807	f	2681	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://data.bnf.fr/vocabulary/roles/r745	2105	\N	69	[Atelier monétaire (r745)]	r745	f	2105	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://data.bnf.fr/vocabulary/roles/r500	53124	\N	69	[Metteur en scène (r500)]	r500	f	53124	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://data.bnf.fr/vocabulary/roles/r741	16	\N	69	[Monétaire présumé (r741)]	r741	f	16	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
75	http://data.bnf.fr/vocabulary/roles/r4080	5986	\N	69	[Addressee (r4080)]	r4080	f	5986	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://data.bnf.fr/vocabulary/roles/r750	32	\N	69	[Orfèvre (r750)]	r750	f	32	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://data.bnf.fr/vocabulary/roles/r1810	3484	\N	69	[Ensemble vocal (r1810)]	r1810	f	3484	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://data.bnf.fr/vocabulary/roles/r990	299421	\N	69	[Auteur ou responsable intellectuel (r990)]	r990	f	299421	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://data.bnf.fr/vocabulary/roles/r713	2	\N	69	[Enlumineur prétendu (r713)]	r713	f	2	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
82	http://data.bnf.fr/vocabulary/roles/r712	6	\N	69	[Enlumineur du modèle (r712)]	r712	f	6	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
83	http://data.bnf.fr/vocabulary/roles/r711	24	\N	69	[Enlumineur présumé (r711)]	r711	f	24	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
84	http://data.bnf.fr/vocabulary/roles/r710	460	\N	69	[Enlumineur (r710)]	r710	f	460	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://data.bnf.fr/vocabulary/roles/r1840	92	\N	69	[Interprète (Bruitages) (r1840)]	r1840	f	92	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
90	http://data.bnf.fr/vocabulary/roles/r1828	248	\N	69	[Ensemble vocal et instrumental (musique ethnique) (r1828)]	r1828	f	248	\N	\N	f	f	19	17	\N	t	f	\N	\N	\N	t	f	f
91	http://data.bnf.fr/vocabulary/roles/r1827	142540	\N	69	[Groupe vocal et instrumental (r1827)]	r1827	f	142540	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://data.bnf.fr/vocabulary/roles/r720	27	\N	69	[Auteur de la recension (r720)]	r720	f	27	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://data.bnf.fr/vocabulary/roles/r1830	126	\N	69	[Siffleur (r1830)]	r1830	f	126	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://data.bnf.fr/vocabulary/roles/r534	10647	\N	69	[Photographe de l'œuvre reproduite (r534)]	r534	f	10647	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://data.bnf.fr/vocabulary/roles/r533	21	\N	69	[Photographe prétendu (r533)]	r533	f	21	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
101	http://data.bnf.fr/vocabulary/roles/r532	261	\N	69	[Photographe, auteur du modèle (r532)]	r532	f	261	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://data.bnf.fr/vocabulary/roles/r1220	2246	\N	69	[Altiste (r1220)]	r1220	f	2246	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
106	http://data.bnf.fr/vocabulary/roles/r1460	864	\N	69	[Instrumentalist (r1460)]	r1460	f	864	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
110	http://id.loc.gov/vocabulary/relators/ltg	37975	\N	70	ltg	ltg	f	37975	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://rdvocab.info/ElementsGr2/placeOfBirth	292595	\N	80	placeOfBirth	placeOfBirth	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://purl.org/dc/terms/audience	41932	\N	5	audience	audience	f	41932	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://id.loc.gov/vocabulary/relators/his	21340	\N	70	his	his	f	21340	\N	\N	f	f	26	17	\N	t	f	\N	\N	\N	t	f	f
138	http://rdaregistry.info/Elements/e/#P20216	85121	\N	86	P20216	P20216	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://www.w3.org/2004/02/skos/core#narrower	181762	\N	4	narrower	narrower	f	181762	\N	\N	f	f	2	2	\N	t	f	\N	\N	\N	t	f	f
144	http://www.w3.org/2004/02/skos/core#member	18089	\N	4	member	member	f	18089	\N	\N	f	f	3	2	\N	t	f	\N	\N	\N	t	f	f
145	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://id.loc.gov/vocabulary/relators/flm	1499	\N	70	flm	flm	f	1499	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://schema.org/sameAs	19882	\N	9	sameAs	sameAs	f	19882	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://purl.org/dc/terms/description	12394974	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://purl.org/dc/terms/subject	24347605	\N	5	subject	subject	f	24347605	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://data.bnf.fr/vocabulary/roles/r300	1636	\N	69	[Dedicator (r300)]	r300	f	1636	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://data.bnf.fr/vocabulary/roles/r540	14991	\N	69	[Author of afterword, colophon, etc. (r540)]	r540	f	14991	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://data.bnf.fr/vocabulary/roles/r780	6346	\N	69	[Orchestrateur (r780)]	r780	f	6346	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://data.bnf.fr/vocabulary/roles/r1450	28082	\N	69	[Saxophoniste (r1450)]	r1450	f	28082	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://data.bnf.fr/vocabulary/roles/r1690	251	\N	69	[Instrumentalist (r1690)]	r1690	f	251	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
116	http://data.bnf.fr/vocabulary/roles/r2300	2614	\N	69	[Opérateur du son (r2300)]	r2300	f	2614	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://data.bnf.fr/vocabulary/roles/r1210	19017	\N	69	[Violoniste (r1210)]	r1210	f	19017	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://data.bnf.fr/vocabulary/roles/r311	1586	\N	69	[Dessinateur présumé (r311)]	r311	f	1586	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://data.bnf.fr/vocabulary/roles/r1459	23	\N	69	[Instrumentalist (r1459)]	r1459	f	23	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
121	http://data.bnf.fr/vocabulary/roles/r1217	227	\N	69	[Instrumentalist (r1217)]	r1217	f	227	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://data.bnf.fr/vocabulary/roles/r310	108895	\N	69	[Dessinateur (r310)]	r310	f	108895	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://data.bnf.fr/vocabulary/roles/r2305	107	\N	69	[Ingénieur du son (r2305)]	r2305	f	107	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://data.bnf.fr/vocabulary/roles/r550	232664	\N	69	[Préfacier (r550)]	r550	f	232664	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://data.bnf.fr/vocabulary/roles/r790	4784	\N	69	[Adapter (r790)]	r790	f	4784	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://data.bnf.fr/vocabulary/roles/r1219	134	\N	69	[Instrumentalist (r1219)]	r1219	f	134	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
127	http://data.bnf.fr/vocabulary/roles/r1218	467	\N	69	[Instrumentalist (r1218)]	r1218	f	467	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://data.bnf.fr/vocabulary/roles/r510	167954	\N	69	[Parolier (r510)]	r510	f	167954	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://data.bnf.fr/vocabulary/roles/r1480	1424	\N	69	[Instrumentalist (r1480)]	r1480	f	1424	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://data.bnf.fr/vocabulary/roles/r4990	39	\N	69	[Intervenant sur l'exemplaire (r4990)]	r4990	f	39	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://data.bnf.fr/vocabulary/roles/r520	4341	\N	69	[Peintre (r520)]	r520	f	4341	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://data.bnf.fr/vocabulary/roles/r1249	190	\N	69	[Instrumentalist (r1249)]	r1249	f	190	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
137	http://data.bnf.fr/vocabulary/roles/r760	34	\N	69	[Artist (r760)]	r760	f	34	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
140	http://data.bnf.fr/vocabulary/roles/r524	1732	\N	69	[Artist (r524)]	r524	f	1732	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://data.bnf.fr/vocabulary/roles/r523	48	\N	69	[Artist (r523)]	r523	f	48	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
142	http://data.bnf.fr/vocabulary/roles/r522	17075	\N	69	[Artist (r522)]	r522	f	17075	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://data.bnf.fr/vocabulary/roles/r1230	7930	\N	69	[Violoncelliste (r1230)]	r1230	f	7930	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://data.bnf.fr/vocabulary/roles/r1470	17963	\N	69	[Trompettiste (r1470)]	r1470	f	17963	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://data.bnf.fr/vocabulary/roles/r1477	170	\N	69	[Instrumentalist (r1477)]	r1477	f	170	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://data.bnf.fr/vocabulary/roles/r4980	24	\N	69	[Intervenant sur l'exemplaire (autre) (r4980)]	r4980	f	24	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
151	http://data.bnf.fr/vocabulary/roles/r1239	22	\N	69	[Instrumentalist (r1239)]	r1239	f	22	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
152	http://data.bnf.fr/vocabulary/roles/r530	222963	\N	69	[Photographe (r530)]	r530	f	222963	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://data.bnf.fr/vocabulary/roles/r770	1095	\N	69	[Adapter (r770)]	r770	f	1095	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://data.bnf.fr/vocabulary/roles/r1478	71	\N	69	[Instrumentalist (r1478)]	r1478	f	71	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://data.bnf.fr/vocabulary/roles/r1660	222	\N	69	[Instrumentalist (r1660)]	r1660	f	222	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://data.bnf.fr/vocabulary/roles/r2990	254	\N	69	[Collaborateur technico-artistique (r2990)]	r2990	f	254	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://data.bnf.fr/vocabulary/roles/r1420	7883	\N	69	[Clarinettiste (r1420)]	r1420	f	7883	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://rdf.insee.fr/geo/code_commune	37752	\N	87	code_commune	code_commune	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://data.ign.fr/ontology/topo.owl/population	77	\N	88	population	population	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://id.loc.gov/vocabulary/relators/fmo	217364	\N	70	fmo	fmo	f	217364	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://id.loc.gov/vocabulary/relators/lyr	167954	\N	70	lyr	lyr	f	167954	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://data.bnf.fr/ontology/bnf-onto/electronicEdition	2111	\N	76	electronicEdition	electronicEdition	f	2111	\N	\N	f	f	25	25	\N	t	f	\N	\N	\N	t	f	f
176	http://nomisma.org/ontology#hasIconography	238	\N	79	hasIconography	hasIconography	f	238	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://purl.org/dc/terms/publisher	12711091	\N	5	publisher	publisher	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://rdvocab.info/RDARelationshipsWEMI/expressionManifested	13063699	\N	82	expressionManifested	expressionManifested	f	13063699	\N	\N	f	f	21	19	\N	t	f	\N	\N	\N	t	f	f
192	http://purl.org/ontology/mo/genre	187739	\N	73	genre	genre	f	187739	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://data.bnf.fr/ontology/bnf-onto/superficie	15	\N	76	superficie	superficie	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://www.w3.org/2002/07/owl#imports	1	\N	7	imports	imports	f	1	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://id.loc.gov/vocabulary/relators/scr	3290	\N	70	scr	scr	f	3290	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://id.loc.gov/vocabulary/relators/scl	1594	\N	70	scl	scl	f	1594	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://rdvocab.info/ElementsGr2/fieldOfActivityOfTheCorporateBody	74327	\N	80	fieldOfActivityOfTheCorporateBody	fieldOfActivityOfTheCorporateBody	f	36026	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://rdvocab.info/Elements/dateOfCapture	223102	\N	85	dateOfCapture	dateOfCapture	f	223102	\N	\N	f	f	21	12	\N	t	f	\N	\N	\N	t	f	f
165	http://data.bnf.fr/vocabulary/roles/r100	30121	\N	69	[Auteur de l'idée originale (r100)]	r100	f	30121	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://data.bnf.fr/vocabulary/roles/r340	15810	\N	69	[Dialoguiste (r340)]	r340	f	15810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://data.bnf.fr/vocabulary/roles/r580	3517	\N	69	[Producteur de fonds d'archives (r580)]	r580	f	3517	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://data.bnf.fr/vocabulary/roles/r1427	253	\N	69	[Instrumentalist (r1427)]	r1427	f	253	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://data.bnf.fr/vocabulary/roles/r103	20	\N	69	[Auteur prétendu de l'idée originale (r103)]	r103	f	20	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
178	http://data.bnf.fr/vocabulary/roles/r2980	248	\N	69	[Collaborateur technico-artistique (autre) (r2980)]	r2980	f	248	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://data.bnf.fr/vocabulary/roles/r1890	161	\N	69	[Ensemble de cuivres (r1890)]	r1890	f	161	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://data.bnf.fr/vocabulary/roles/r1651	2	\N	69	[Instrumentalist (r1651)]	r1651	f	2	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
183	http://data.bnf.fr/vocabulary/roles/r1650	21207	\N	69	[Batteur (r1650)]	r1650	f	21207	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://data.bnf.fr/vocabulary/roles/r113	6	\N	69	[Attributed name (r113)]	r113	f	6	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
185	http://data.bnf.fr/vocabulary/roles/r1657	168	\N	69	[Instrumentalist (r1657)]	r1657	f	168	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
186	http://data.bnf.fr/vocabulary/roles/r1898	1	\N	69	[Ensemble de cuivres (musique ethnique) (r1898)]	r1898	f	1	\N	\N	f	f	19	17	\N	t	f	\N	\N	\N	t	f	f
187	http://data.bnf.fr/vocabulary/roles/r111	175	\N	69	[Attributed name (r111)]	r111	f	175	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://data.bnf.fr/vocabulary/roles/r110	122194	\N	69	[Auteur de lettres (r110)]	r110	f	122194	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://data.bnf.fr/vocabulary/roles/r350	1505	\N	69	[Dramaturge (r350)]	r350	f	1505	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://data.bnf.fr/vocabulary/roles/r1659	24	\N	69	[Instrumentalist (r1659)]	r1659	f	24	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://data.bnf.fr/vocabulary/roles/r1658	1422	\N	69	[Instrumentalist (r1658)]	r1658	f	1422	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://data.bnf.fr/vocabulary/roles/r590	35988	\N	69	[Développeur (r590)]	r590	f	35988	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://data.bnf.fr/vocabulary/roles/r314	3148	\N	69	[Dessinateur de l'œuvre reproduite (r314)]	r314	f	3148	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://data.bnf.fr/vocabulary/roles/r312	41536	\N	69	[Dessinateur du modèle (r312)]	r312	f	41536	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://data.bnf.fr/vocabulary/roles/r1440	206	\N	69	[Instrumentalist (r1440)]	r1440	f	206	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
202	http://data.bnf.fr/vocabulary/roles/r1680	157	\N	69	[Xylophoniste (r1680)]	r1680	f	157	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://data.bnf.fr/vocabulary/roles/r1200	475	\N	69	[Chanteur (enfant) (r1200)]	r1200	f	475	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://data.bnf.fr/vocabulary/roles/r321	801	\N	69	[Addressee (r321)]	r321	f	801	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://data.bnf.fr/vocabulary/roles/r320	73138	\N	69	[Addressee (r320)]	r320	f	73138	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://data.bnf.fr/vocabulary/roles/r1688	124	\N	69	[Instrumentalist (r1688)]	r1688	f	124	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://data.bnf.fr/vocabulary/roles/r1670	215	\N	69	[Timbaliste (r1670)]	r1670	f	215	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
212	http://data.bnf.fr/vocabulary/roles/r1430	2227	\N	69	[Hautboïste (r1430)]	r1430	f	2227	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
213	http://data.bnf.fr/vocabulary/roles/r1437	161	\N	69	[Instrumentalist (r1437)]	r1437	f	161	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://data.bnf.fr/vocabulary/roles/r330	275403	\N	69	[Directeur de publication (r330)]	r330	f	275403	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://data.bnf.fr/vocabulary/roles/r570	6116	\N	69	[Producteur artistique (r570)]	r570	f	6116	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
218	http://rdvocab.info/Elements/numberingOfIssue	221127	\N	85	numberingOfIssue	numberingOfIssue	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://data.bnf.fr/ontology/bnf-onto/firstYear	15284340	\N	76	firstYear	firstYear	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://data.bnf.fr/ontology/bnf-onto/cadreGeographique	214543	\N	76	cadreGeographique	cadreGeographique	f	214543	\N	\N	f	f	11	2	\N	t	f	\N	\N	\N	t	f	f
221	http://id.loc.gov/vocabulary/relators/ivr	9696	\N	70	ivr	ivr	f	9696	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://id.loc.gov/vocabulary/relators/aft	14991	\N	70	aft	aft	f	14991	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://rdvocab.info/RDARelationshipsWEMI/expressionOfWork	2704439	\N	82	expressionOfWork	expressionOfWork	f	2704439	\N	\N	f	f	9	24	\N	t	f	\N	\N	\N	t	f	f
233	http://www.w3.org/2004/02/skos/core#editorialNote	1512570	\N	4	editorialNote	editorialNote	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://id.loc.gov/vocabulary/relators/itr	551494	\N	70	itr	itr	f	551494	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://vocab.org/bio/0.1/birth	511077	\N	81	birth	birth	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://id.loc.gov/vocabulary/relators/rev	27	\N	70	rev	rev	f	27	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://id.loc.gov/vocabulary/relators/chr	12781	\N	70	chr	chr	f	12781	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://id.loc.gov/vocabulary/relators/adp	74299	\N	70	adp	adp	f	74299	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	http://id.loc.gov/vocabulary/relators/act	353757	\N	70	act	act	f	353757	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://purl.org/dc/terms/modified	20600979	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://id.loc.gov/vocabulary/relators/voc	66024	\N	70	voc	voc	f	66024	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://data.bnf.fr/ontology/bnf-onto/isniAttributionAgency	1834844	\N	76	isniAttributionAgency	isniAttributionAgency	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://id.loc.gov/vocabulary/relators/pbd	275403	\N	70	pbd	pbd	f	275403	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://data.bnf.fr/vocabulary/roles/r3240	977	\N	69	[Agence photographique (r3240)]	r3240	f	977	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://data.bnf.fr/vocabulary/roles/r2150	891	\N	69	[Coordonnateur des effets spéciaux (r2150)]	r2150	f	891	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://data.bnf.fr/vocabulary/roles/r1060	12631	\N	69	[Danseur (r1060)]	r1060	f	12631	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://data.bnf.fr/vocabulary/roles/r380	21396	\N	69	[Graphiste (r380)]	r380	f	21396	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://data.bnf.fr/vocabulary/roles/r143	1	\N	69	[Calligraphe prétendu (r143)]	r143	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
231	http://data.bnf.fr/vocabulary/roles/r141	3	\N	69	[Calligraphe supposé (r141)]	r141	f	3	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
232	http://data.bnf.fr/vocabulary/roles/r140	528	\N	69	[Calligraphe (r140)]	r140	f	528	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://data.bnf.fr/vocabulary/roles/r2140	11958	\N	69	[Chef éclairagiste (r2140)]	r2140	f	11958	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://data.bnf.fr/vocabulary/roles/r1050	324	\N	69	[Marionnettiste (r1050)]	r1050	f	324	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://data.bnf.fr/vocabulary/roles/r1290	1418	\N	69	[Instrumentalist (r1290)]	r1290	f	1418	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
237	http://data.bnf.fr/vocabulary/roles/r390	1	\N	69	[Géodésien (r390)]	r390	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
238	http://data.bnf.fr/vocabulary/roles/r3230	30	\N	69	[Agence de presse (r3230)]	r3230	f	30	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://data.bnf.fr/vocabulary/roles/r2146	80	\N	69	[Régisseur lumières (r2146)]	r2146	f	80	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
241	http://data.bnf.fr/vocabulary/roles/r2145	464	\N	69	[Concepteur des éclairages (r2145)]	r2145	f	464	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://data.bnf.fr/vocabulary/roles/r154	252	\N	69	[Cartographe du document reproduit (r154)]	r154	f	252	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://data.bnf.fr/vocabulary/roles/r153	5	\N	69	[Cartographe prétendu (r153)]	r153	f	5	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
245	http://data.bnf.fr/vocabulary/roles/r151	287	\N	69	[Cartographe présumé (r151)]	r151	f	287	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://data.bnf.fr/vocabulary/roles/r150	203966	\N	69	[Cartographe (r150)]	r150	f	203966	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://data.bnf.fr/vocabulary/roles/r1080	14045	\N	69	[Chef de chœur (r1080)]	r1080	f	14045	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://data.bnf.fr/vocabulary/roles/r3260	143048	\N	69	[Imprimeur-libraire (r3260)]	r3260	f	143048	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://data.bnf.fr/vocabulary/roles/r3020	7	\N	69	[Détenteur du privilège (r3020)]	r3020	f	7	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
257	http://data.bnf.fr/vocabulary/roles/r365	24882	\N	69	[Expert (r365)]	r365	f	24882	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://data.bnf.fr/vocabulary/roles/r121	27	\N	69	[Auteur présumé du commentaire (r121)]	r121	f	27	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
260	http://data.bnf.fr/vocabulary/roles/r120	20797	\N	69	[Auteur du commentaire (r120)]	r120	f	20797	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
261	http://data.bnf.fr/vocabulary/roles/r360	1738703	\N	69	[Éditeur scientifique (r360)]	r360	f	1738703	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://data.bnf.fr/vocabulary/roles/r126	5152	\N	69	[Auteur de la conférence (r126)]	r126	f	5152	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://data.bnf.fr/vocabulary/roles/r2160	21	\N	69	[Faussaire (r2160)]	r2160	f	21	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
265	http://data.bnf.fr/vocabulary/roles/r1070	513	\N	69	[Lecteur à voix haute (r1070)]	r1070	f	513	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
268	http://data.bnf.fr/vocabulary/roles/r3010	30	\N	69	[Commissaire-priseur (r3010)]	r3010	f	30	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://data.bnf.fr/vocabulary/roles/r4100	2	\N	69	[Donor (r4100)]	r4100	f	2	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
275	http://www.w3.org/2004/02/skos/core#relatedMatch	62079	\N	4	relatedMatch	relatedMatch	f	62079	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://id.loc.gov/vocabulary/relators/pbl	757324	\N	70	pbl	pbl	f	757324	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://data.bnf.fr/ontology/bnf-onto/subject	122181	\N	76	subject	subject	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://www.w3.org/2004/02/skos/core#prefLabel	7676744	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://purl.org/dc/terms/frequency	185109	\N	5	frequency	frequency	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://www.w3.org/2003/01/geo/wgs84_pos#long	107478	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://id.loc.gov/vocabulary/relators/cnd	139334	\N	70	cnd	cnd	f	139334	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://www.w3.org/2004/02/skos/core#scopeNote	34690	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://rdaregistry.info/Elements/a/#P50097	1926493	\N	83	P50097	P50097	f	1926493	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
294	http://rdaregistry.info/Elements/a/#P50098	14802	\N	83	P50098	P50098	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
304	http://id.loc.gov/vocabulary/relators/col	69692	\N	70	col	col	f	69692	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://id.loc.gov/vocabulary/relators/com	8752	\N	70	com	com	f	8752	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://id.loc.gov/vocabulary/relators/pht	242871	\N	70	pht	pht	f	242871	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://nomisma.org/ontology#hasAuthenticity	3834	\N	79	hasAuthenticity	hasAuthenticity	f	3834	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://www.w3.org/2002/07/owl#complementOf	2	\N	7	complementOf	complementOf	f	2	\N	\N	f	f	20	20	\N	t	f	\N	\N	\N	t	f	f
312	http://id.loc.gov/vocabulary/relators/cll	551	\N	70	cll	cll	f	551	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://rdaregistry.info/Elements/w/#P10222	16100	\N	89	P10222	P10222	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://id.loc.gov/vocabulary/relators/clb	163752	\N	70	clb	clb	f	163752	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://rdvocab.info/ElementsGr2/dateOfTermination	98117	\N	80	dateOfTermination	dateOfTermination	f	98117	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://data.bnf.fr/vocabulary/roles/r377	2573	\N	69	[Émetteur prétendu (r377)]	r377	f	2573	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
272	http://data.bnf.fr/vocabulary/roles/r376	3	\N	69	[Émetteur douteux (r376)]	r376	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://data.bnf.fr/vocabulary/roles/r373	6095	\N	69	[Autorité émettrice de monnaie prétendue (r373)]	r373	f	6095	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://data.bnf.fr/vocabulary/roles/r130	261	\N	69	[Auteur du matériel d'accompagnement (r130)]	r130	f	261	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://data.bnf.fr/vocabulary/roles/r370	118084	\N	69	[Autorité émettrice de monnaie (r370)]	r370	f	118084	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://data.bnf.fr/vocabulary/roles/r1260	116	\N	69	[Instrumentalist (r1260)]	r1260	f	116	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
285	http://data.bnf.fr/vocabulary/roles/r2110	18	\N	69	[Directeur de ballet (r2110)]	r2110	f	18	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://data.bnf.fr/vocabulary/roles/r1020	461	\N	69	[Artiste de cirque (r1020)]	r1020	f	461	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://data.bnf.fr/vocabulary/roles/r180	33907	\N	69	[Collecteur (r180)]	r180	f	33907	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://data.bnf.fr/vocabulary/roles/r2350	30	\N	69	[Bookjacket designer (r2350)]	r2350	f	30	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
292	http://data.bnf.fr/vocabulary/roles/r3200	13506	\N	69	[Directeur de salle de spectacle (r3200)]	r3200	f	13506	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://data.bnf.fr/vocabulary/roles/r1490	1151	\N	69	[Instrumentalist (r1490)]	r1490	f	1151	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://data.bnf.fr/vocabulary/roles/r1011	6	\N	69	[Acteur présumé (r1011)]	r1011	f	6	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
297	http://data.bnf.fr/vocabulary/roles/r2100	4012	\N	69	[Directeur artistique (r2100)]	r2100	f	4012	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://data.bnf.fr/vocabulary/roles/r1010	351490	\N	69	[Acteur (r1010)]	r1010	f	351490	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://data.bnf.fr/vocabulary/roles/r2340	66	\N	69	[Scripteur (r2340)]	r2340	f	66	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
300	http://data.bnf.fr/vocabulary/roles/r190	20925	\N	69	[Commanditaire du contenu (r190)]	r190	f	20925	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://data.bnf.fr/vocabulary/roles/r1257	1019	\N	69	[Violiste (r1257)]	r1257	f	1019	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://data.bnf.fr/vocabulary/roles/r1013	2	\N	69	[Acteur prétendu (r1013)]	r1013	f	2	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
305	http://data.bnf.fr/vocabulary/roles/r1018	35	\N	69	[Chansonnier (r1018)]	r1018	f	35	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
307	http://data.bnf.fr/vocabulary/roles/r1017	2273	\N	69	[Humoriste (r1017)]	r1017	f	2273	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://data.bnf.fr/vocabulary/roles/r1258	105	\N	69	[Instrumentalist (r1258)]	r1258	f	105	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
313	http://data.bnf.fr/vocabulary/roles/r1040	139334	\N	69	[Chef d'orchestre (r1040)]	r1040	f	139334	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://data.bnf.fr/vocabulary/roles/r2370	42	\N	69	[Régisseur son (théâtre) (r2370)]	r2370	f	42	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
315	http://data.bnf.fr/vocabulary/roles/r1280	36985	\N	69	[Guitariste (r1280)]	r1280	f	36985	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
320	http://data.bnf.fr/vocabulary/roles/r2130	1233	\N	69	[Documentaliste (r2130)]	r2130	f	1233	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://data.bnf.fr/vocabulary/roles/r3220	80	\N	69	[Galerie (r3220)]	r3220	f	80	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
322	http://data.bnf.fr/vocabulary/roles/r1289	6762	\N	69	[Instrumentalist (r1289)]	r1289	f	6762	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://data.bnf.fr/vocabulary/roles/r1288	259	\N	69	[Instrumentalist (r1288)]	r1288	f	259	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
324	http://data.bnf.fr/vocabulary/roles/r1287	2344	\N	69	[Instrumentalist (r1287)]	r1287	f	2344	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
327	http://id.loc.gov/vocabulary/relators/cmp	1302945	\N	70	cmp	cmp	f	1302945	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
328	http://nomisma.org/ontology#hasMaterial	3834	\N	79	hasMaterial	hasMaterial	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://rdaregistry.info/Elements/w/#P10219	1842613	\N	89	P10219	P10219	f	1842613	\N	\N	f	f	9	12	\N	t	f	\N	\N	\N	t	f	f
330	http://rdaregistry.info/Elements/w/#P10218	548153	\N	89	P10218	P10218	f	548153	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
333	http://rdaregistry.info/Elements/w/#P10210	22357	\N	89	P10210	P10210	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
340	http://nomisma.org/ontology#FieldOfNumismatics	1594	\N	79	FieldOfNumismatics	FieldOfNumismatics	f	1594	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
344	http://rdvocab.info/Elements/placeOfProduction	59757	\N	85	placeOfProduction	placeOfProduction	f	59757	\N	\N	f	f	26	2	\N	t	f	\N	\N	\N	t	f	f
347	http://id.loc.gov/vocabulary/relators/ant	76643	\N	70	ant	ant	f	76643	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
348	http://id.loc.gov/vocabulary/relators/crr	1742	\N	70	crr	crr	f	1742	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://data.bnf.fr/ontology/bnf-onto/isniAttributionDate	1834831	\N	76	isniAttributionDate	isniAttributionDate	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
353	http://id.loc.gov/vocabulary/relators/anm	2567	\N	70	anm	anm	f	2567	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
354	http://id.loc.gov/vocabulary/relators/ann	13703	\N	70	ann	ann	f	13703	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://rdvocab.info/Elements/designationOfEdition	645741	\N	85	designationOfEdition	designationOfEdition	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
357	http://id.loc.gov/vocabulary/relators/cst	28479	\N	70	cst	cst	f	28479	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
358	http://id.loc.gov/vocabulary/relators/ctb	2689	\N	70	ctb	ctb	f	2689	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://id.loc.gov/vocabulary/relators/rpt	524	\N	70	rpt	rpt	f	524	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
362	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
363	http://id.loc.gov/vocabulary/relators/trc	4669	\N	70	trc	trc	f	4669	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://id.loc.gov/vocabulary/relators/trl	536879	\N	70	trl	trl	f	536879	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
367	http://id.loc.gov/vocabulary/relators/cph	45	\N	70	cph	cph	f	45	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://rdaregistry.info/Elements/u/#P60470	7362548	\N	90	P60470	P60470	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
371	http://id.loc.gov/vocabulary/relators/lbt	31757	\N	70	lbt	lbt	f	31757	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
372	http://id.loc.gov/vocabulary/relators/rth	4183	\N	70	rth	rth	f	4183	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://id.loc.gov/vocabulary/relators/art	48955	\N	70	art	art	f	48955	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
374	http://purl.org/ontology/bibo/issn	313448	\N	31	issn	issn	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
377	http://id.loc.gov/vocabulary/relators/ppm	3527	\N	70	ppm	ppm	f	3527	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://www.w3.org/2000/01/rdf-schema#subClassOf	15	\N	2	subClassOf	subClassOf	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
331	http://data.bnf.fr/vocabulary/roles/r2360	60	\N	69	[Graphiste (r2360)]	r2360	f	60	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
332	http://data.bnf.fr/vocabulary/roles/r1270	1766	\N	69	[Harpiste (r1270)]	r1270	f	1766	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
334	http://data.bnf.fr/vocabulary/roles/r171	63	\N	69	[Collaborateur présumé (r171)]	r171	f	63	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
335	http://data.bnf.fr/vocabulary/roles/r1033	1	\N	69	[Chanteur prétendu (r1033)]	r1033	f	1	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
336	http://data.bnf.fr/vocabulary/roles/r170	162450	\N	69	[Collaborateur (r170)]	r170	f	162450	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
337	http://data.bnf.fr/vocabulary/roles/r1031	21	\N	69	[Chanteur présumé (r1031)]	r1031	f	21	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
338	http://data.bnf.fr/vocabulary/roles/r2120	92	\N	69	[Directeur musical (r2120)]	r2120	f	92	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
341	http://data.bnf.fr/vocabulary/roles/r1278	248	\N	69	[Instrumentalist (r1278)]	r1278	f	248	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://data.bnf.fr/vocabulary/roles/r3210	449935	\N	69	[Distributeur (r3210)]	r3210	f	449935	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
343	http://data.bnf.fr/vocabulary/roles/r1277	247	\N	69	[Instrumentalist (r1277)]	r1277	f	247	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
345	http://data.bnf.fr/vocabulary/roles/r1039	52	\N	69	[Chanteur (sons traités par l'électronique) (r1039)]	r1039	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://data.bnf.fr/vocabulary/roles/r3080	88	\N	69	[Producteur exécutif (r3080)]	r3080	f	88	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
351	http://data.bnf.fr/vocabulary/roles/r4170	1996	\N	69	[Annotator (r4170)]	r4170	f	1996	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
352	http://data.bnf.fr/vocabulary/roles/r4171	10	\N	69	[Auteur présumé des notes manuscrites (r4171)]	r4171	f	10	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
355	http://data.bnf.fr/vocabulary/roles/r1900	112	\N	69	[Instrumentalist (r1900)]	r1900	f	112	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
359	http://data.bnf.fr/vocabulary/roles/r3070	5	\N	69	[Technicien de laboratoire (r3070)]	r3070	f	5	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://data.bnf.fr/vocabulary/roles/r4160	3	\N	69	[Associated name (r4160)]	r4160	f	3	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://data.bnf.fr/vocabulary/roles/r1920	119	\N	69	[Instrumentalist (r1920)]	r1920	f	119	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://data.bnf.fr/vocabulary/roles/r3090	1027	\N	69	[Photographer (r3090)]	r3090	f	1027	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
370	http://data.bnf.fr/vocabulary/roles/r4180	298	\N	69	[Auteur de la pièce jointe (r4180)]	r4180	f	298	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
375	http://data.bnf.fr/vocabulary/roles/r3040	21	\N	69	[Expert (r3040)]	r3040	f	21	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
376	http://data.bnf.fr/vocabulary/roles/r2190	192	\N	69	[Maquettiste (r2190)]	r2190	f	192	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://data.bnf.fr/vocabulary/roles/r3280	1461	\N	69	[Bookseller (r3280)]	r3280	f	1461	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
380	http://id.loc.gov/vocabulary/relators/arr	61955	\N	70	arr	arr	f	61955	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://rdaregistry.info/Elements/m/#P30016	1462402	\N	84	P30016	P30016	f	1462402	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
382	http://rdaregistry.info/Elements/m/#P30011	11627612	\N	84	P30011	P30011	f	11627612	\N	\N	f	f	21	12	\N	t	f	\N	\N	\N	t	f	f
383	http://data.bnf.fr/ontology/bnf-onto/domaineLitteral	100763	\N	76	domaineLitteral	domaineLitteral	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
384	http://data.bnf.fr/ontology/bnf-onto/ocrConfidence	411728	\N	76	ocrConfidence	ocrConfidence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://id.loc.gov/vocabulary/relators/tyg	26	\N	70	tyg	tyg	f	26	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://id.loc.gov/vocabulary/relators/ppt	534	\N	70	ppt	ppt	f	534	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
391	http://id.loc.gov/vocabulary/relators/cwt	20878	\N	70	cwt	cwt	f	20878	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://rdvocab.info/RDARelationshipsWEMI/workManifested	3093579	\N	82	workManifested	workManifested	f	3093579	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
393	http://id.loc.gov/vocabulary/relators/asn	8967	\N	70	asn	asn	f	8967	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
396	http://www.w3.org/2003/01/geo/wgs84_pos#alt	279	\N	25	alt	alt	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
397	http://id.loc.gov/vocabulary/relators/ctg	205568	\N	70	ctg	ctg	f	205568	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
398	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
399	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://xmlns.com/foaf/0.1/focus	20544012	\N	8	focus	focus	f	20544012	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
402	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://id.loc.gov/vocabulary/relators/exp	21	\N	70	exp	exp	f	21	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://id.loc.gov/vocabulary/relators/les	7	\N	70	les	les	f	7	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
406	http://id.loc.gov/vocabulary/relators/lgd	11958	\N	70	lgd	lgd	f	11958	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
407	http://rdaregistry.info/Elements/m/#P30279	12344650	\N	84	P30279	P30279	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://rdvocab.info/Elements/placeOfCapture	215583	\N	85	placeOfCapture	placeOfCapture	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://id.loc.gov/vocabulary/relators/rsg	404455	\N	70	rsg	rsg	f	404455	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
410	http://www.w3.org/2003/01/geo/wgs84_pos#lat	107504	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://id.loc.gov/vocabulary/relators/pop	1916	\N	70	pop	pop	f	1916	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
413	http://rdaregistry.info/Elements/a/#P50031	369350	\N	83	P50031	P50031	f	369350	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
415	http://www.openarchives.org/ore/terms/aggregatedBy	6422	\N	71	aggregatedBy	aggregatedBy	f	6422	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
417	http://rdaregistry.info/Elements/a/#P50038	98117	\N	83	P50038	P50038	f	98117	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
418	http://rdaregistry.info/Elements/a/#P50035	175635	\N	83	P50035	P50035	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://rdaregistry.info/Elements/a/#P50037	253398	\N	83	P50037	P50037	f	253398	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
420	http://id.loc.gov/vocabulary/relators/cur	3174	\N	70	cur	cur	f	3174	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
422	http://id.loc.gov/vocabulary/relators/org	274849	\N	70	org	org	f	274849	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
425	http://rdvocab.info/ElementsGr2/dateOfBirth	387880	\N	80	dateOfBirth	dateOfBirth	f	387880	\N	\N	f	f	6	12	\N	t	f	\N	\N	\N	t	f	f
430	http://rdaregistry.info/Elements/w/#P10078	2704439	\N	89	P10078	P10078	f	2704439	\N	\N	f	f	9	24	\N	t	f	\N	\N	\N	t	f	f
431	http://rdvocab.info/ElementsGr2/fieldOfActivityOfThePerson	202028	\N	80	fieldOfActivityOfThePerson	fieldOfActivityOfThePerson	f	100828	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
432	http://xmlns.com/foaf/0.1/gender	1732068	\N	8	gender	gender	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
591	http://id.loc.gov/vocabulary/relators/rcp	79984	\N	70	rcp	rcp	f	79984	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://data.bnf.fr/vocabulary/roles/r3030	567	\N	69	[Bookseller (r3030)]	r3030	f	567	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
389	http://data.bnf.fr/vocabulary/roles/r4120	85	\N	69	[Associated name (r4120)]	r4120	f	85	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
394	http://data.bnf.fr/vocabulary/roles/r4150	8879	\N	69	[Vendeur (r4150)]	r4150	f	8879	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://data.bnf.fr/vocabulary/roles/r3060	107706	\N	69	[Imprimeur (r3060)]	r3060	f	107706	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
412	http://data.bnf.fr/vocabulary/roles/r3050	3527	\N	69	[Fabricant du papier (r3050)]	r3050	f	3527	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://data.bnf.fr/vocabulary/roles/r4140	1774	\N	69	[Relieur (r4140)]	r4140	f	1774	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
416	http://data.bnf.fr/vocabulary/roles/r3290	2077	\N	69	[Libraire (r3290)]	r3290	f	2077	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
421	http://data.bnf.fr/vocabulary/roles/r810	1293	\N	69	[Directeur d'atelier (r810)]	r810	f	1293	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
424	http://data.bnf.fr/vocabulary/roles/r1980	456	\N	69	[Interprète (autre) (r1980)]	r1980	f	456	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
426	http://data.bnf.fr/vocabulary/roles/r1500	28	\N	69	[Instrumentalist (r1500)]	r1500	f	28	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
427	http://data.bnf.fr/vocabulary/roles/r1748	25	\N	69	[Instrumentalist (r1748)]	r1748	f	25	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
428	http://data.bnf.fr/vocabulary/roles/r1747	7	\N	69	[Instrumentalist (r1747)]	r1747	f	7	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
429	http://data.bnf.fr/vocabulary/roles/r1728	86	\N	69	[Instrumentalist (r1728)]	r1728	f	86	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
433	http://data.bnf.fr/vocabulary/roles/r1730	96	\N	69	[Instrumentalist (r1730)]	r1730	f	96	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
434	http://data.bnf.fr/ontology/bnf-onto/habitants	78	\N	76	habitants	habitants	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
436	http://rdvocab.info/Elements/scale	274474	\N	85	scale	scale	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
437	http://data.bnf.fr/ontology/bnf-onto/domaine	124449	\N	76	domaine	domaine	f	124449	\N	\N	f	f	2	2	\N	t	f	\N	\N	\N	t	f	f
438	http://rdvocab.info/ElementsGr2/countryAssociatedWithThePerson	1926493	\N	80	countryAssociatedWithThePerson	countryAssociatedWithThePerson	f	1926493	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
440	http://rdvocab.info/ElementsGr2/periodOfActivityOfThePerson	14802	\N	80	periodOfActivityOfThePerson	periodOfActivityOfThePerson	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
446	http://www.w3.org/2004/02/skos/core#broadMatch	346	\N	4	broadMatch	broadMatch	f	346	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
447	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	556	\N	2	subPropertyOf	subPropertyOf	f	556	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
448	http://www.w3.org/2004/02/skos/core#notation	1404	\N	4	notation	notation	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
450	http://nomisma.org/ontology#hasTypeSeriesItem	499	\N	79	hasTypeSeriesItem	hasTypeSeriesItem	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
451	http://rdaregistry.info/Elements/u/#P60074	223102	\N	90	P60074	P60074	f	223102	\N	\N	f	f	21	12	\N	t	f	\N	\N	\N	t	f	f
459	http://rdvocab.info/ElementsGr2/placeAssociatedWithTheCorporateBody	369350	\N	80	placeAssociatedWithTheCorporateBody	placeAssociatedWithTheCorporateBody	f	369350	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
463	http://rdaregistry.info/Elements/u/#P61160	7098002	\N	90	P61160	P61160	f	7098002	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
466	http://isni.org/ontology#identifierValid	1834846	\N	91	identifierValid	identifierValid	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
471	http://rdvocab.info/Elements/statusOfIdentification	1953100	\N	85	statusOfIdentification	statusOfIdentification	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
476	http://data.bnf.fr/ontology/bnf-onto/mortPourLaFrance	1439	\N	76	mortPourLaFrance	mortPourLaFrance	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
484	http://www.w3.org/2003/01/geo/wgs84_pos#lat_long	104724	\N	25	lat_long	lat_long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
435	http://data.bnf.fr/vocabulary/roles/r1738	145	\N	69	[Instrumentalist (r1738)]	r1738	f	145	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
439	http://data.bnf.fr/vocabulary/roles/r1520	6194	\N	69	[Tromboniste (r1520)]	r1520	f	6194	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
441	http://data.bnf.fr/vocabulary/roles/r1760	11253	\N	69	[Synthétiseur (r1760)]	r1760	f	11253	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
442	http://data.bnf.fr/vocabulary/roles/r1767	613	\N	69	[Instrumentalist (r1767)]	r1767	f	613	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
443	http://data.bnf.fr/vocabulary/roles/r80	706	\N	69	[Auteur de l'argument (r80)]	r80	f	706	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
445	http://data.bnf.fr/vocabulary/roles/r1527	22	\N	69	[Instrumentalist (r1527)]	r1527	f	22	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
449	http://data.bnf.fr/vocabulary/roles/r800	4	\N	69	[Auteur du slogan (r800)]	r800	f	4	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
452	http://data.bnf.fr/vocabulary/roles/r1990	115441	\N	69	[Interprète (r1990)]	r1990	f	115441	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
453	http://data.bnf.fr/vocabulary/roles/r1510	1388	\N	69	[Corniste (r1510)]	r1510	f	1388	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
454	http://data.bnf.fr/vocabulary/roles/r1750	113	\N	69	[Ondiste (r1750)]	r1750	f	113	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
455	http://data.bnf.fr/vocabulary/roles/r90	2563	\N	69	[Auteur de l'animation (r90)]	r90	f	2563	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
456	http://data.bnf.fr/vocabulary/roles/r91	1	\N	69	[Animator (r91)]	r91	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
458	http://data.bnf.fr/vocabulary/roles/r1938	304	\N	69	[Instrumentalist (r1938)]	r1938	f	304	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
460	http://data.bnf.fr/vocabulary/roles/r1937	86	\N	69	[Instrumentalist (r1937)]	r1937	f	86	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
461	http://data.bnf.fr/vocabulary/roles/r611	6	\N	69	[Restager (r611)]	r611	f	6	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
462	http://data.bnf.fr/vocabulary/roles/r610	345557	\N	69	[Réalisateur (r610)]	r610	f	345557	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
464	http://data.bnf.fr/vocabulary/roles/r1700	2047	\N	69	[Vibraphoniste (r1700)]	r1700	f	2047	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
465	http://data.bnf.fr/vocabulary/roles/r860	3	\N	69	[Greffier (r860)]	r860	f	3	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
467	http://data.bnf.fr/vocabulary/roles/r1940	51	\N	69	[Instrumentalist (r1940)]	r1940	f	51	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
469	http://data.bnf.fr/vocabulary/roles/r60	275	\N	69	[Annotator (r60)]	r60	f	275	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
470	http://data.bnf.fr/vocabulary/roles/r73	2599	\N	69	[Auteur prétendu du texte (r73)]	r73	f	2599	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
472	http://data.bnf.fr/vocabulary/roles/r620	203747	\N	69	[Rédacteur (r620)]	r620	f	203747	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
473	http://data.bnf.fr/vocabulary/roles/r630	138247	\N	69	[Scénariste (r630)]	r630	f	138247	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
474	http://data.bnf.fr/vocabulary/roles/r1930	379	\N	69	[Instrumentalist (r1930)]	r1930	f	379	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
475	http://data.bnf.fr/vocabulary/roles/r870	433	\N	69	[Fondateur de la publication (r870)]	r870	f	433	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
477	http://data.bnf.fr/vocabulary/roles/r70	9793912	\N	69	[Auteur du texte (r70)]	r70	f	9793912	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
479	http://data.bnf.fr/vocabulary/roles/r72	76643	\N	69	[Auteur adapté (r72)]	r72	f	76643	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
480	http://data.bnf.fr/vocabulary/roles/r40	11391	\N	69	[Annotateur (r40)]	r40	f	11391	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
481	http://data.bnf.fr/vocabulary/roles/r41	40	\N	69	[Annotator (r41)]	r41	f	40	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
482	http://data.bnf.fr/vocabulary/roles/r1718	190	\N	69	[Instrumentalist (r1718)]	r1718	f	190	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
483	http://data.bnf.fr/vocabulary/roles/r43	7	\N	69	[Annotator (r43)]	r43	f	7	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
487	http://data.bnf.fr/ontology/bnf-onto/creationduLieu	827	\N	76	creationduLieu	creationduLieu	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
491	http://rdvocab.info/RDARelationshipsWEMI/exemplarOfManifestation	430	\N	82	exemplarOfManifestation	exemplarOfManifestation	f	430	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
494	http://nomisma.org/ontology#hasDenomination	3834	\N	79	hasDenomination	hasDenomination	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
498	http://data.bnf.fr/ontology/bnf-onto/ean	2034806	\N	76	ean	ean	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
500	http://schema.org/audience	41932	\N	9	audience	audience	f	41932	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
505	http://data.bnf.fr/ontology/bnf-onto/translation	6387	\N	76	translation	translation	f	6387	\N	\N	f	f	25	25	\N	t	f	\N	\N	\N	t	f	f
507	http://www.openarchives.org/ore/terms/isAggregatedBy	22912	\N	71	isAggregatedBy	isAggregatedBy	f	22912	\N	\N	f	f	9	9	\N	t	f	\N	\N	\N	t	f	f
512	http://rdaregistry.info/Elements/w/#P10004	2061618	\N	89	P10004	P10004	f	2061618	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
513	http://id.loc.gov/vocabulary/relators/inv	26	\N	70	inv	inv	f	26	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
514	http://id.loc.gov/vocabulary/relators/ins	10513	\N	70	ins	ins	f	10513	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
526	http://schema.org/location	62192	\N	9	location	location	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
528	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	3	\N	2	isDefinedBy	isDefinedBy	f	3	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
532	http://id.loc.gov/vocabulary/relators/ccp	54628	\N	70	ccp	ccp	f	54628	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
533	http://id.loc.gov/vocabulary/relators/egr	240520	\N	70	egr	egr	f	240520	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
485	http://data.bnf.fr/vocabulary/roles/r1717	372	\N	69	[Instrumentalist (r1717)]	r1717	f	372	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
486	http://data.bnf.fr/vocabulary/roles/r830	1	\N	69	[Lettriste (r830)]	r830	f	1	\N	\N	f	f	23	6	\N	t	f	\N	\N	\N	t	f	f
488	http://data.bnf.fr/vocabulary/roles/r1720	43	\N	69	[Instrumentalist (r1720)]	r1720	f	43	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
489	http://data.bnf.fr/vocabulary/roles/r51	40	\N	69	[Arranger (r51)]	r51	f	40	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
490	http://data.bnf.fr/vocabulary/roles/r1707	102	\N	69	[Instrumentalist (r1707)]	r1707	f	102	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
492	http://data.bnf.fr/vocabulary/roles/r53	5	\N	69	[Arranger (r53)]	r53	f	5	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
495	http://data.bnf.fr/vocabulary/roles/r600	1948	\N	69	[Programmeur (r600)]	r600	f	1948	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
496	http://data.bnf.fr/vocabulary/roles/r840	28	\N	69	[Secrétaire (r840)]	r840	f	28	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
497	http://data.bnf.fr/vocabulary/roles/r1950	86	\N	69	[Performeur (r1950)]	r1950	f	86	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
499	http://data.bnf.fr/vocabulary/roles/r850	1	\N	69	[Notaire, tabellion (r850)]	r850	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
501	http://data.bnf.fr/vocabulary/roles/r1710	105	\N	69	[Carilloniste (r1710)]	r1710	f	105	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
502	http://data.bnf.fr/vocabulary/roles/r50	51107	\N	69	[Arrangeur (r50)]	r50	f	51107	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
503	http://data.bnf.fr/vocabulary/roles/r20	8446	\N	69	[Agence de publicité (création) (r20)]	r20	f	8446	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
506	http://data.bnf.fr/vocabulary/roles/r414	509	\N	69	[Engraver (r414)]	r414	f	509	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
508	http://data.bnf.fr/vocabulary/roles/r413	58	\N	69	[Engraver (r413)]	r413	f	58	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
509	http://data.bnf.fr/vocabulary/roles/r412	1008	\N	69	[Engraver (r412)]	r412	f	1008	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
510	http://data.bnf.fr/vocabulary/roles/r24	2	\N	69	[Originator (r24)]	r24	f	2	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
511	http://data.bnf.fr/vocabulary/roles/r411	760	\N	69	[Engraver (r411)]	r411	f	760	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
515	http://data.bnf.fr/vocabulary/roles/r1340	41	\N	69	[Instrumentalist (r1340)]	r1340	f	41	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
517	http://data.bnf.fr/vocabulary/roles/r1103	3	\N	69	[Instrumentalist (r1103)]	r1103	f	3	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
518	http://data.bnf.fr/vocabulary/roles/r1587	110	\N	69	[Instrumentalist (r1587)]	r1587	f	110	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
519	http://data.bnf.fr/vocabulary/roles/r1101	10	\N	69	[Instrumentalist (r1101)]	r1101	f	10	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
520	http://data.bnf.fr/vocabulary/roles/r1100	6185	\N	69	[Instrumentiste (r1100)]	r1100	f	6185	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
521	http://data.bnf.fr/vocabulary/roles/r421	5	\N	69	[Engraver (r421)]	r421	f	5	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
522	http://data.bnf.fr/vocabulary/roles/r420	1456	\N	69	[Graveur en lettres (r420)]	r420	f	1456	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
523	http://data.bnf.fr/vocabulary/roles/r660	3610	\N	69	[Technicien graphique (r660)]	r660	f	3610	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
525	http://data.bnf.fr/vocabulary/roles/r30	145265	\N	69	[Agence photographique (commanditaire) (r30)]	r30	f	145265	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
527	http://data.bnf.fr/vocabulary/roles/r31	161	\N	69	[Agence photographique présumée (commanditaire) (r31)]	r31	f	161	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
529	http://data.bnf.fr/vocabulary/roles/r34	2817	\N	69	[Originator (r34)]	r34	f	2817	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
531	http://data.bnf.fr/vocabulary/roles/r422	2	\N	69	[Engraver (r422)]	r422	f	2	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
534	http://data.bnf.fr/vocabulary/roles/r1330	778	\N	69	[Mandoliniste (r1330)]	r1330	f	778	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
535	http://data.bnf.fr/vocabulary/roles/r1570	877	\N	69	[Pianofortiste (r1570)]	r1570	f	877	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
536	http://data.bnf.fr/vocabulary/roles/r3990	58	\N	69	[Opérateur commercial (r3990)]	r3990	f	58	\N	\N	f	f	19	17	\N	t	f	\N	\N	\N	t	f	f
537	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
540	http://www.w3.org/2002/07/owl#unionOf	1	\N	7	unionOf	unionOf	f	1	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
542	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
543	http://id.loc.gov/vocabulary/relators/ill	516672	\N	70	ill	ill	f	516672	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
544	http://rdaregistry.info/Elements/w/#P10024	83336	\N	89	P10024	P10024	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
550	http://xmlns.com/foaf/0.1/familyName	4393839	\N	8	familyName	familyName	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
558	http://purl.org/dc/terms/temporal	116	\N	5	temporal	temporal	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
567	http://erlangen-crm.org/current/P7_took_place_at	26320	\N	92	P7_took_place_at	P7_took_place_at	f	26320	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
569	http://id.loc.gov/vocabulary/relators/edt	1738703	\N	70	edt	edt	f	1738703	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
572	http://rdvocab.info/Elements/publishersName	11203584	\N	85	publishersName	publishersName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
573	http://id.loc.gov/vocabulary/relators/ilu	508	\N	70	ilu	ilu	f	508	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
584	http://www.w3.org/2004/02/skos/core#inScheme	21265	\N	4	inScheme	inScheme	f	21265	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
587	http://id.loc.gov/vocabulary/relators/rce	2833	\N	70	rce	rce	f	2833	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
539	http://data.bnf.fr/vocabulary/roles/r430	12023	\N	69	[Harmonisateur (r430)]	r430	f	12023	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
541	http://data.bnf.fr/vocabulary/roles/r670	4	\N	69	[Testeur (r670)]	r670	f	4	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
545	http://data.bnf.fr/vocabulary/roles/r2210	534	\N	69	[Créateur des marionnettes (r2210)]	r2210	f	534	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
546	http://data.bnf.fr/vocabulary/roles/r3300	6753	\N	69	[Marchand (r3300)]	r3300	f	6753	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
547	http://data.bnf.fr/vocabulary/roles/r1120	41407	\N	69	[Soprano (r1120)]	r1120	f	41407	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
548	http://data.bnf.fr/vocabulary/roles/r1360	285	\N	69	[Cithariste (r1360)]	r1360	f	285	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
551	http://data.bnf.fr/vocabulary/roles/r1129	4	\N	69	[Singer (r1129)]	r1129	f	4	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
552	http://data.bnf.fr/vocabulary/roles/r641	6	\N	69	[Sculpteur présumé (r641)]	r641	f	6	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
553	http://data.bnf.fr/vocabulary/roles/r640	752	\N	69	[Sculpteur (r640)]	r640	f	752	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
554	http://data.bnf.fr/vocabulary/roles/r2216	43	\N	69	[Réalisateur des marionnettes (r2216)]	r2216	f	43	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
555	http://data.bnf.fr/vocabulary/roles/r2215	142	\N	69	[Concepteur des marionnettes (r2215)]	r2215	f	142	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
556	http://data.bnf.fr/vocabulary/roles/r880	68	\N	69	[Créateur de l'objet (r880)]	r880	f	68	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
559	http://data.bnf.fr/vocabulary/roles/r10	62036	\N	69	[Adaptateur (r10)]	r10	f	62036	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
560	http://data.bnf.fr/vocabulary/roles/r11	56	\N	69	[Adaptateur présumé (r11)]	r11	f	56	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
561	http://data.bnf.fr/vocabulary/roles/r644	385	\N	69	[Sculpteur de l'œuvre reproduite (r644)]	r644	f	385	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
562	http://data.bnf.fr/vocabulary/roles/r13	11	\N	69	[Adaptateur prétendu (r13)]	r13	f	11	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
563	http://data.bnf.fr/vocabulary/roles/r642	451	\N	69	[Sculpteur du modèle (r642)]	r642	f	451	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
565	http://data.bnf.fr/vocabulary/roles/r1590	9356	\N	69	[Organiste (r1590)]	r1590	f	9356	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
566	http://data.bnf.fr/vocabulary/roles/r1110	98366	\N	69	[Voix parlée (r1110)]	r1110	f	98366	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
568	http://data.bnf.fr/vocabulary/roles/r1350	1099	\N	69	[Instrumentalist (r1350)]	r1350	f	1099	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
570	http://data.bnf.fr/vocabulary/roles/r1598	32	\N	69	[Instrumentalist (r1598)]	r1598	f	32	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
571	http://data.bnf.fr/vocabulary/roles/r1597	266	\N	69	[Instrumentalist (r1597)]	r1597	f	266	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
574	http://data.bnf.fr/vocabulary/roles/r2200	562	\N	69	[Maquilleur (r2200)]	r2200	f	562	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
575	http://data.bnf.fr/vocabulary/roles/r410	236840	\N	69	[Graveur (r410)]	r410	f	236840	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
576	http://data.bnf.fr/vocabulary/roles/r2206	13	\N	69	[Maquilleur (r2206)]	r2206	f	13	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
577	http://data.bnf.fr/vocabulary/roles/r650	2815	\N	69	[Signataire (r650)]	r650	f	2815	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
579	http://data.bnf.fr/vocabulary/roles/r2205	1	\N	69	[Chef maquilleur (r2205)]	r2205	f	1	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
580	http://data.bnf.fr/vocabulary/roles/r891	3633	\N	69	[Plasticien (r891)]	r891	f	3633	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
581	http://data.bnf.fr/vocabulary/roles/r1599	2039	\N	69	[Instrumentalist (r1599)]	r1599	f	2039	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
582	http://data.bnf.fr/vocabulary/roles/r1357	95	\N	69	[Instrumentalist (r1357)]	r1357	f	95	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
583	http://data.bnf.fr/vocabulary/roles/r1119	58	\N	69	[Narrator (r1119)]	r1119	f	58	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
585	http://data.bnf.fr/vocabulary/roles/r1780	39485	\N	69	[Orchestre (r1780)]	r1780	f	39485	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
586	http://data.bnf.fr/vocabulary/roles/r1300	212	\N	69	[Instrumentalist (r1300)]	r1300	f	212	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
589	http://data.bnf.fr/vocabulary/roles/r223	216	\N	69	[Composer (r223)]	r223	f	216	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
590	http://data.bnf.fr/vocabulary/roles/r222	10356	\N	69	[Composer (r222)]	r222	f	10356	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
597	http://www.w3.org/2000/01/rdf-schema#range	62	\N	2	range	range	f	62	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
598	http://www.w3.org/ns/prov#wasGeneratedBy	1647531	\N	26	wasGeneratedBy	wasGeneratedBy	f	1647531	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
599	http://id.loc.gov/vocabulary/relators/red	203747	\N	70	red	red	f	203747	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
609	http://purl.org/dc/terms/date	14614302	\N	5	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
611	http://data.bnf.fr/ontology/bnf-onto/isbn	4499509	\N	76	isbn	isbn	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
624	http://data.bnf.fr/ontology/bnf-onto/isan	14980	\N	76	isan	isan	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
634	http://rdvocab.info/ElementsGr2/languageOfThePerson	1927628	\N	80	languageOfThePerson	languageOfThePerson	f	1927628	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
641	http://data.bnf.fr/ontology/bnf-onto/OCR	411729	\N	76	OCR	OCR	f	411729	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
645	http://www.geonames.org/ontology/ontology_v3.1.rdf/postalCode	102	\N	93	postalCode	postalCode	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
592	http://data.bnf.fr/vocabulary/roles/r1787	102	\N	69	[Ensembles (divers) (r1787)]	r1787	f	102	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
607	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	83611483	\N	1	type	type	f	83611483	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
593	http://data.bnf.fr/vocabulary/roles/r221	1889	\N	69	[Compositeur présumé (r221)]	r221	f	1889	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
594	http://data.bnf.fr/vocabulary/roles/r220	1291052	\N	69	[Compositeur (r220)]	r220	f	1291052	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
595	http://data.bnf.fr/vocabulary/roles/r1309	21	\N	69	[Instrumentalist (r1309)]	r1309	f	21	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
600	http://data.bnf.fr/vocabulary/roles/r1770	90	\N	69	[Instrumentalist (r1770)]	r1770	f	90	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
601	http://data.bnf.fr/vocabulary/roles/r1530	453	\N	69	[Tubiste (r1530)]	r1530	f	453	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
602	http://data.bnf.fr/vocabulary/roles/r1777	170	\N	69	[Instrumentalist (r1777)]	r1777	f	170	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
603	http://data.bnf.fr/vocabulary/roles/r473	5	\N	69	[Librettist (r473)]	r473	f	5	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
604	http://data.bnf.fr/vocabulary/roles/r230	24604	\N	69	[Concepteur (r230)]	r230	f	24604	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
605	http://data.bnf.fr/vocabulary/roles/r471	128	\N	69	[Librettist (r471)]	r471	f	128	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
606	http://data.bnf.fr/vocabulary/roles/r470	30913	\N	69	[Librettiste (r470)]	r470	f	30913	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
610	http://data.bnf.fr/vocabulary/roles/r1560	75094	\N	69	[Pianiste (r1560)]	r1560	f	75094	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
612	http://data.bnf.fr/vocabulary/roles/r3980	22	\N	69	[Opérateur commercial (autre) (r3980)]	r3980	f	22	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
613	http://data.bnf.fr/vocabulary/roles/r1320	380	\N	69	[Théorbiste (r1320)]	r1320	f	380	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
614	http://data.bnf.fr/vocabulary/roles/r1569	987	\N	69	[Instrumentalist (r1569)]	r1569	f	987	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
615	http://data.bnf.fr/vocabulary/roles/r443	2	\N	69	[Illustrateur prétendu (r443)]	r443	f	2	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
616	http://data.bnf.fr/vocabulary/roles/r200	3174	\N	69	[Commissaire d'exposition (r200)]	r200	f	3174	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
618	http://data.bnf.fr/vocabulary/roles/r441	440	\N	69	[Illustrateur présumé (r441)]	r441	f	440	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
619	http://data.bnf.fr/vocabulary/roles/r440	516191	\N	69	[Illustrateur (r440)]	r440	f	516191	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
620	http://data.bnf.fr/vocabulary/roles/r680	536879	\N	69	[Traducteur (r680)]	r680	f	536879	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
621	http://data.bnf.fr/vocabulary/roles/r1550	2400	\N	69	[Harmoniciste (r1550)]	r1550	f	2400	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
622	http://data.bnf.fr/vocabulary/roles/r1790	12968	\N	69	[Ensemble instrumental (r1790)]	r1790	f	12968	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
623	http://data.bnf.fr/vocabulary/roles/r1310	975	\N	69	[Luthiste (r1310)]	r1310	f	975	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
626	http://data.bnf.fr/vocabulary/roles/r1557	80	\N	69	[Instrumentalist (r1557)]	r1557	f	80	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
627	http://data.bnf.fr/vocabulary/roles/r1798	163	\N	69	[Ensemble instrumental (musique ethnique) (r1798)]	r1798	f	163	\N	\N	f	f	\N	17	\N	t	f	\N	\N	\N	t	f	f
628	http://data.bnf.fr/vocabulary/roles/r210	8752	\N	69	[Compilateur (r210)]	r210	f	8752	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
629	http://data.bnf.fr/vocabulary/roles/r1797	19316	\N	69	[Groupe instrumental (r1797)]	r1797	f	19316	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
630	http://data.bnf.fr/vocabulary/roles/r450	9696	\N	69	[Interviewer (r450)]	r450	f	9696	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
631	http://data.bnf.fr/vocabulary/roles/r690	18335	\N	69	[Créateur de spectacle (r690)]	r690	f	18335	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
633	http://data.bnf.fr/vocabulary/roles/r1317	126	\N	69	[Instrumentalist (r1317)]	r1317	f	126	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
635	http://data.bnf.fr/vocabulary/roles/r2030	58	\N	69	[Bruiteur (r2030)]	r2030	f	58	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
636	http://data.bnf.fr/vocabulary/roles/r2270	36	\N	69	[Relieur (r2270)]	r2270	f	36	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
637	http://data.bnf.fr/vocabulary/roles/r1180	18279	\N	69	[Basse (voix) (r1180)]	r1180	f	18279	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
638	http://data.bnf.fr/vocabulary/roles/r3120	1184	\N	69	[Commanditaire de la publication (r3120)]	r3120	f	1184	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
639	http://data.bnf.fr/vocabulary/roles/r4210	4314	\N	69	[Déposant (r4210)]	r4210	f	4314	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
642	http://data.bnf.fr/vocabulary/roles/r263	1	\N	69	[Continuateur prétendu (r263)]	r263	f	1	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
643	http://data.bnf.fr/vocabulary/roles/r261	4	\N	69	[Continuateur présumé (r261)]	r261	f	4	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
644	http://data.bnf.fr/vocabulary/roles/r260	2684	\N	69	[Continuateur (r260)]	r260	f	2684	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
648	http://www.w3.org/2004/02/skos/core#closeMatch	1749982	\N	4	closeMatch	closeMatch	f	1749982	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
652	http://purl.org/dc/terms/creator	2127349	\N	5	creator	creator	f	2127349	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
653	http://data.bnf.fr/ontology/bnf-onto/date	4507	\N	76	date	date	f	4507	\N	\N	f	f	\N	12	\N	t	f	\N	\N	\N	t	f	f
658	http://purl.org/dc/terms/type	17315443	\N	5	type	type	f	17315443	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
661	http://rdaregistry.info/Elements/m/#P30103	430	\N	84	P30103	P30103	f	430	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
671	http://id.loc.gov/vocabulary/relators/fnd	9	\N	70	fnd	fnd	f	9	\N	\N	f	f	24	17	\N	t	f	\N	\N	\N	t	f	f
674	http://id.loc.gov/vocabulary/relators/sgn	2921	\N	70	sgn	sgn	f	2921	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
675	http://www.w3.org/2002/07/owl#sameAs	24789143	\N	7	sameAs	sameAs	f	24789143	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
678	http://purl.org/dc/terms/language	14122893	\N	5	language	language	f	14122893	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
685	http://rdvocab.info/ElementsGr2/dateOfEstablishment	253398	\N	80	dateOfEstablishment	dateOfEstablishment	f	253398	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
687	http://www.w3.org/2000/01/rdf-schema#label	2653929	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
688	http://purl.org/dc/terms/title	15598664	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
689	http://xmlns.com/foaf/0.1/birthday	271905	\N	8	birthday	birthday	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
692	http://id.loc.gov/vocabulary/relators/sng	416009	\N	70	sng	sng	f	416009	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
647	http://data.bnf.fr/vocabulary/roles/r2260	1221	\N	69	[Régisseur (r2260)]	r2260	f	1221	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
649	http://data.bnf.fr/vocabulary/roles/r1170	2342	\N	69	[Baryton-basse (r1170)]	r1170	f	2342	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
650	http://data.bnf.fr/vocabulary/roles/r270	2302	\N	69	[Copiste (r270)]	r270	f	2302	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
651	http://data.bnf.fr/vocabulary/roles/r2020	25	\N	69	[Assistant réalisateur (r2020)]	r2020	f	25	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
654	http://data.bnf.fr/vocabulary/roles/r3110	140	\N	69	[Annonceur (r3110)]	r3110	f	140	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
655	http://data.bnf.fr/vocabulary/roles/r1179	6	\N	69	[Baryton-basse (sons traités par l'électronique) (r1179)]	r1179	f	6	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
656	http://data.bnf.fr/vocabulary/roles/r4200	47	\N	69	[Illustrateur de l'exemplaire (r4200)]	r4200	f	47	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
659	http://data.bnf.fr/vocabulary/roles/r273	2	\N	69	[Copiste prétendu (r273)]	r273	f	2	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
660	http://data.bnf.fr/vocabulary/roles/r271	210	\N	69	[Copiste présumé (r271)]	r271	f	210	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
662	http://data.bnf.fr/vocabulary/roles/r2290	5	\N	69	[Script (r2290)]	r2290	f	5	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
663	http://data.bnf.fr/vocabulary/roles/r3140	13	\N	69	[Directeur de production (r3140)]	r3140	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
664	http://data.bnf.fr/vocabulary/roles/r4230	613	\N	69	[Mécène (r4230)]	r4230	f	613	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
665	http://data.bnf.fr/vocabulary/roles/r2050	139	\N	69	[Coloriste (r2050)]	r2050	f	139	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
666	http://data.bnf.fr/vocabulary/roles/r486	118	\N	69	[Héliograveur (r486)]	r486	f	118	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
667	http://data.bnf.fr/vocabulary/roles/r485	1916	\N	69	[Sérigraphe (r485)]	r485	f	1916	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
669	http://data.bnf.fr/vocabulary/roles/r483	3	\N	69	[Lithographe prétendu (r483)]	r483	f	3	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
670	http://data.bnf.fr/vocabulary/roles/r240	1442	\N	69	[Chef de projet informatique (r240)]	r240	f	1442	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
672	http://data.bnf.fr/vocabulary/roles/r481	63	\N	69	[Lithographe présumé (r481)]	r481	f	63	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
673	http://data.bnf.fr/vocabulary/roles/r480	37796	\N	69	[Lithographe (r480)]	r480	f	37796	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
676	http://data.bnf.fr/vocabulary/roles/r1190	2489	\N	69	[Contre-ténor (r1190)]	r1190	f	2489	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
679	http://data.bnf.fr/vocabulary/roles/r2040	15	\N	69	[Créateur (Cascades et batailles) (r2040)]	r2040	f	15	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
680	http://data.bnf.fr/vocabulary/roles/r2280	7724	\N	69	[Scénographe (r2280)]	r2280	f	7724	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
681	http://data.bnf.fr/vocabulary/roles/r490	504	\N	69	[Artist (r490)]	r490	f	504	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
682	http://data.bnf.fr/vocabulary/roles/r2045	2	\N	69	[Conseiller pour les cascades (r2045)]	r2045	f	2	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
683	http://data.bnf.fr/vocabulary/roles/r1197	79	\N	69	[Haute-contre (r1197)]	r1197	f	79	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
686	http://data.bnf.fr/vocabulary/roles/r2046	1	\N	69	[Cascadeur (r2046)]	r2046	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
690	http://data.bnf.fr/vocabulary/roles/r250	2055	\N	69	[Conseiller scientifique (r250)]	r250	f	2055	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
691	http://data.bnf.fr/vocabulary/roles/r1380	8274	\N	69	[Flûtiste (r1380)]	r1380	f	8274	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
693	http://data.bnf.fr/vocabulary/roles/r2230	1499	\N	69	[Monteur (r2230)]	r2230	f	1499	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
694	http://data.bnf.fr/vocabulary/roles/r1140	5632	\N	69	[Alto (voix) (r1140)]	r1140	f	5632	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
695	http://data.bnf.fr/vocabulary/roles/r1389	8	\N	69	[Instrumentalist (r1389)]	r1389	f	8	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
696	http://data.bnf.fr/vocabulary/roles/r1388	917	\N	69	[Instrumentalist (r1388)]	r1388	f	917	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
698	http://data.bnf.fr/vocabulary/roles/r1387	92	\N	69	[Instrumentalist (r1387)]	r1387	f	92	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
699	http://data.bnf.fr/vocabulary/roles/r1149	1	\N	69	[Alto (voix ; sons traités par l'électronique) (r1149)]	r1149	f	1	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
701	http://data.bnf.fr/ontology/bnf-onto/suppressionduLieu	118	\N	76	suppressionduLieu	suppressionduLieu	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
709	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
711	http://data.bnf.fr/ontology/bnf-onto/cote	133527	\N	76	cote	cote	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
712	http://id.loc.gov/vocabulary/relators/dnr	32576	\N	70	dnr	dnr	f	32576	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
713	http://www.w3.org/2004/02/skos/core#related	120398	\N	4	related	related	f	120398	\N	\N	f	f	2	2	\N	t	f	\N	\N	\N	t	f	f
714	http://rdvocab.info/Elements/placeOfOriginOfTheWork	548153	\N	85	placeOfOriginOfTheWork	placeOfOriginOfTheWork	f	548153	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
717	http://rdvocab.info/Elements/dateOfWork	1842613	\N	85	dateOfWork	dateOfWork	f	1842613	\N	\N	f	f	9	12	\N	t	f	\N	\N	\N	t	f	f
718	http://id.loc.gov/vocabulary/relators/dnc	12631	\N	70	dnc	dnc	f	12631	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
725	http://www.w3.org/2000/01/rdf-schema#comment	76	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
727	http://id.loc.gov/vocabulary/relators/bjd	30	\N	70	bjd	bjd	f	30	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
728	http://id.loc.gov/vocabulary/relators/frg	21	\N	70	frg	frg	f	21	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
729	http://data.bnf.fr/ontology/bnf-onto/nomUsuel	219	\N	76	nomUsuel	nomUsuel	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
730	http://www.w3.org/2000/01/rdf-schema#domain	63	\N	2	domain	domain	f	63	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
735	http://rdvocab.info/Elements/projectionOfCartographicProjection	85121	\N	85	projectionOfCartographicProjection	projectionOfCartographicProjection	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
737	http://www.w3.org/2004/02/skos/core#altLabel	2909874	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
738	http://data.bnf.fr/ontology/bnf-onto/ouvrageJeunesse	379067	\N	76	ouvrageJeunesse	ouvrageJeunesse	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
739	http://id.loc.gov/vocabulary/relators/dub	2599	\N	70	dub	dub	f	2599	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
740	http://www.w3.org/2004/02/skos/core#narrowMatch	239	\N	4	narrowMatch	narrowMatch	f	239	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
742	http://id.loc.gov/vocabulary/relators/dte	10434	\N	70	dte	dte	f	10434	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
743	http://id.loc.gov/vocabulary/relators/dto	1636	\N	70	dto	dto	f	1636	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
744	http://rdaregistry.info/Elements/m/#P30176	11203584	\N	84	P30176	P30176	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
747	http://id.loc.gov/vocabulary/relators/mfr	1293	\N	70	mfr	mfr	f	1293	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
748	http://id.loc.gov/vocabulary/relators/srv	2	\N	70	srv	srv	f	2	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
749	http://id.loc.gov/vocabulary/relators/drt	10242	\N	70	drt	drt	f	10242	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
750	http://id.loc.gov/vocabulary/relators/spn	22103	\N	70	spn	spn	f	22103	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
700	http://data.bnf.fr/vocabulary/roles/r1370	112	\N	69	[Cymbaliste (r1370)]	r1370	f	112	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
702	http://data.bnf.fr/vocabulary/roles/r2220	400	\N	69	[Créateur des masques (r2220)]	r2220	f	400	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
703	http://data.bnf.fr/vocabulary/roles/r1130	13003	\N	69	[Mezzo-soprano (r1130)]	r1130	f	13003	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
704	http://data.bnf.fr/vocabulary/roles/r2225	5	\N	69	[Concepteur des masques (r2225)]	r2225	f	5	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
706	http://data.bnf.fr/vocabulary/roles/r1377	17	\N	69	[Instrumentalist (r1377)]	r1377	f	17	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
707	http://data.bnf.fr/vocabulary/roles/r3310	3001	\N	69	[Graveur de musique (r3310)]	r3310	f	3001	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
708	http://data.bnf.fr/vocabulary/roles/r1139	1	\N	69	[Mezzo-soprano (sons traités par l'électronique) (r1139)]	r1139	f	1	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
710	http://data.bnf.fr/vocabulary/roles/r2226	2	\N	69	[Réalisateur des masques (r2226)]	r2226	f	2	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
715	http://data.bnf.fr/vocabulary/roles/r2250	26	\N	69	[Opérateur prises de vue (r2250)]	r2250	f	26	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
719	http://data.bnf.fr/vocabulary/roles/r280	1742	\N	69	[Correcteur (r280)]	r280	f	1742	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
720	http://data.bnf.fr/vocabulary/roles/r2010	598	\N	69	[Accessoiriste (r2010)]	r2010	f	598	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
721	http://data.bnf.fr/vocabulary/roles/r1169	1	\N	69	[Baryton (voix ; sons traités par l'électronique) (r1169)]	r1169	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
722	http://data.bnf.fr/vocabulary/roles/r3340	657	\N	69	[Cartier (r3340)]	r3340	f	657	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
723	http://data.bnf.fr/vocabulary/roles/r2256	11	\N	69	[Opérateur prises de vue (r2256)]	r2256	f	11	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
726	http://data.bnf.fr/vocabulary/roles/r2255	5158	\N	69	[Directeur de la photographie (r2255)]	r2255	f	5158	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
731	http://data.bnf.fr/vocabulary/roles/r1150	33944	\N	69	[Ténor (r1150)]	r1150	f	33944	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
732	http://data.bnf.fr/vocabulary/roles/r1390	201	\N	69	[Instrumentalist (r1390)]	r1390	f	201	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
733	http://data.bnf.fr/vocabulary/roles/r290	10434	\N	69	[Dédicataire (r290)]	r290	f	10434	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
734	http://data.bnf.fr/vocabulary/roles/r2240	10	\N	69	[Photographe de plateau (r2240)]	r2240	f	10	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
736	http://data.bnf.fr/vocabulary/roles/r1159	2	\N	69	[Singer (r1159)]	r1159	f	2	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
741	http://data.bnf.fr/vocabulary/roles/r4050	17	\N	69	[Doreur (r4050)]	r4050	f	17	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
745	http://data.bnf.fr/vocabulary/roles/r4040	32574	\N	69	[Donateur (r4040)]	r4040	f	32574	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
746	http://data.bnf.fr/vocabulary/roles/r3190	3362	\N	69	[Diffuseur (r3190)]	r3190	f	3362	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
751	http://www.w3.org/2004/02/skos/core#broader	298785	\N	4	broader	broader	f	298785	\N	\N	f	f	2	2	\N	t	f	\N	\N	\N	t	f	f
752	http://rdaregistry.info/Elements/a/#P500022	74327	\N	83	P500022	P500022	f	36026	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
754	http://www.openlinksw.com/schemas/DAV#ownerUser	743	\N	18	ownerUser	ownerUser	f	743	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
755	http://id.loc.gov/vocabulary/relators/bnd	1810	\N	70	bnd	bnd	f	1810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
757	http://id.loc.gov/vocabulary/relators/drm	155261	\N	70	drm	drm	f	155261	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
758	http://rdvocab.info/ElementsGr2/placeOfDeath	200678	\N	80	placeOfDeath	placeOfDeath	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
759	http://id.loc.gov/vocabulary/relators/dst	467758	\N	70	dst	dst	f	467758	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
760	http://data.bnf.fr/ontology/bnf-onto/coordonneesLambert	37743	\N	76	coordonneesLambert	coordonneesLambert	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
761	http://data.bnf.fr/ontology/bnf-onto/ismn	27072	\N	76	ismn	ismn	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
763	http://data.bnf.fr/ontology/bnf-onto/statutObjet	3834	\N	76	statutObjet	statutObjet	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
765	http://schema.org/ratingValue	46829	\N	9	ratingValue	ratingValue	f	46829	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
766	http://rdvocab.info/ElementsGr2/dateOfDeath	386814	\N	80	dateOfDeath	dateOfDeath	f	386814	\N	\N	f	f	6	12	\N	t	f	\N	\N	\N	t	f	f
767	http://www.w3.org/2004/02/skos/core#exactMatch	7322945	\N	4	exactMatch	exactMatch	f	7322945	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
770	http://rdaregistry.info/Elements/a/#P50120	386814	\N	83	P50120	P50120	f	386814	\N	\N	f	f	6	12	\N	t	f	\N	\N	\N	t	f	f
771	http://rdaregistry.info/Elements/a/#P50121	387880	\N	83	P50121	P50121	f	387880	\N	\N	f	f	6	12	\N	t	f	\N	\N	\N	t	f	f
773	http://rdaregistry.info/Elements/m/#P30135	3093579	\N	84	P30135	P30135	f	3093579	\N	\N	f	f	\N	15	\N	t	f	\N	\N	\N	t	f	f
775	http://rdaregistry.info/Elements/m/#P30133	645741	\N	84	P30133	P30133	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
779	http://www.w3.org/2000/01/rdf-schema#seeAlso	19341479	\N	2	seeAlso	seeAlso	f	19341479	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
780	http://rdaregistry.info/Elements/u/#P60565	274474	\N	90	P60565	P60565	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
781	http://id.loc.gov/vocabulary/relators/std	28097	\N	70	std	std	f	28097	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
784	http://data.bnf.fr/ontology/bnf-onto/hasBibliography	578	\N	76	hasBibliography	hasBibliography	f	578	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
788	http://www.openarchives.org/ore/terms/aggregates	73124	\N	71	aggregates	aggregates	f	73124	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
789	http://rdaregistry.info/Elements/m/#P30139	13063699	\N	84	P30139	P30139	f	13063699	\N	\N	f	f	21	24	\N	t	f	\N	\N	\N	t	f	f
790	http://rdaregistry.info/Elements/u/#P60556	215583	\N	90	P60556	P60556	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
791	http://rdvocab.info/Elements/coordinatesOfCartographicContent	178105	\N	85	coordinatesOfCartographicContent	coordinatesOfCartographicContent	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
796	http://xmlns.com/foaf/0.1/depiction	3808352	\N	8	depiction	depiction	f	2350217	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
798	http://purl.org/dc/terms/created	21111645	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
799	http://data.bnf.fr/ontology/bnf-onto/FRBNF	18952705	\N	76	FRBNF	FRBNF	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
800	http://id.loc.gov/vocabulary/relators/bsl	153904	\N	70	bsl	bsl	f	153904	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://data.bnf.fr/vocabulary/roles/r930	721	\N	69	[Vidéaste (r930)]	r930	f	721	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://data.bnf.fr/vocabulary/roles/r1620	66	\N	69	[Instrumentalist (r1620)]	r1620	f	66	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
31	http://data.bnf.fr/vocabulary/roles/r1880	543	\N	69	[Ensemble à vent (r1880)]	r1880	f	543	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
756	http://data.bnf.fr/vocabulary/roles/r1800	10465	\N	69	[Chœur mixte (r1800)]	r1800	f	10465	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
762	http://data.bnf.fr/vocabulary/roles/r9990	358604	\N	69	[Autre (r9990)]	r9990	f	358604	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
764	http://data.bnf.fr/vocabulary/roles/r4060	26	\N	69	[Inventeur (r4060)]	r4060	f	26	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
768	http://data.bnf.fr/vocabulary/roles/r3160	276368	\N	69	[Producteur de phonogrammes (r3160)]	r3160	f	276368	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
772	http://data.bnf.fr/vocabulary/roles/r4010	175440	\N	69	[Ancien possesseur (r4010)]	r4010	f	175440	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
774	http://data.bnf.fr/vocabulary/roles/r900	4798	\N	69	[Programmateur (r900)]	r900	f	4798	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
776	http://data.bnf.fr/vocabulary/roles/r3150	32022	\N	69	[Producteur (r3150)]	r3150	f	32022	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
777	http://data.bnf.fr/vocabulary/roles/r4240	60	\N	69	[Commanditaire de la reliure (r4240)]	r4240	f	60	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
778	http://data.bnf.fr/vocabulary/roles/r2060	59	\N	69	[Conseiller technique (r2060)]	r2060	f	59	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
782	http://data.bnf.fr/vocabulary/roles/r4030	35785	\N	69	[Collectionneur (r4030)]	r4030	f	35785	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
783	http://data.bnf.fr/vocabulary/roles/r2090	27348	\N	69	[Réalisateur des décors (r2090)]	r2090	f	27348	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
786	http://data.bnf.fr/vocabulary/roles/r2095	751	\N	69	[Chef décorateur (r2095)]	r2095	f	751	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
787	http://data.bnf.fr/vocabulary/roles/r3180	9	\N	69	[Funder (r3180)]	r3180	f	9	\N	\N	f	f	24	17	\N	t	f	\N	\N	\N	t	f	f
792	http://data.bnf.fr/vocabulary/roles/r2080	27564	\N	69	[Costumier (r2080)]	r2080	f	27564	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
793	http://data.bnf.fr/vocabulary/roles/r4020	6525	\N	69	[Auteur de l'envoi (r4020)]	r4020	f	6525	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
794	http://data.bnf.fr/vocabulary/roles/r2085	769	\N	69	[Chef costumier (r2085)]	r2085	f	769	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
795	http://data.bnf.fr/vocabulary/roles/r3170	92214	\N	69	[Producteur de vidéogrammes (r3170)]	r3170	f	92214	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
797	http://data.bnf.fr/vocabulary/roles/r2086	152	\N	69	[Costume designer (r2086)]	r2086	f	152	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://data.bnf.fr/vocabulary/roles/r1630	9699	\N	69	[Accordéoniste (r1630)]	r1630	f	9699	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://data.bnf.fr/vocabulary/roles/r1878	5	\N	69	[Ensemble de cordes (musique ethnique) (r1878)]	r1878	f	5	\N	\N	f	f	24	17	\N	t	f	\N	\N	\N	t	f	f
64	http://data.bnf.fr/vocabulary/roles/r1820	4842	\N	69	[Ensemble vocal et instrumental (r1820)]	r1820	f	4842	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://data.bnf.fr/vocabulary/roles/r746	12	\N	69	[Atelier monétaire présumé (r746)]	r746	f	12	\N	\N	f	f	19	17	\N	t	f	\N	\N	\N	t	f	f
80	http://data.bnf.fr/vocabulary/roles/r714	20	\N	69	[Enlumineur de l'œuvre reproduite (r714)]	r714	f	20	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
88	http://data.bnf.fr/vocabulary/roles/r1600	34	\N	69	[Instrumentalist (r1600)]	r1600	f	34	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
98	http://data.bnf.fr/vocabulary/roles/r1837	109	\N	69	[Interprète (Bruits corporels) (r1837)]	r1837	f	109	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://data.bnf.fr/vocabulary/roles/r2310	26	\N	69	[Typographe (r2310)]	r2310	f	26	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://data.bnf.fr/vocabulary/roles/r1229	7	\N	69	[Instrumentalist (r1229)]	r1229	f	7	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
120	http://data.bnf.fr/vocabulary/roles/r2306	1	\N	69	[Opérateur du son (r2306)]	r2306	f	1	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
132	http://data.bnf.fr/vocabulary/roles/r1240	19951	\N	69	[Contrebassiste (r1240)]	r1240	f	19951	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
143	http://data.bnf.fr/vocabulary/roles/r521	127	\N	69	[Artist (r521)]	r521	f	127	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
150	http://data.bnf.fr/vocabulary/roles/r531	2777	\N	69	[Photographe présumé (r531)]	r531	f	2777	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://data.bnf.fr/vocabulary/roles/r1668	954	\N	69	[Instrumentalist (r1668)]	r1668	f	954	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://data.bnf.fr/vocabulary/roles/r1428	353	\N	69	[Instrumentalist (r1428)]	r1428	f	353	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
180	http://data.bnf.fr/vocabulary/roles/r1410	400	\N	69	[Instrumentalist (r1410)]	r1410	f	400	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
189	http://data.bnf.fr/vocabulary/roles/r1418	5	\N	69	[Instrumentalist (r1418)]	r1418	f	5	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
197	http://data.bnf.fr/vocabulary/roles/r313	133	\N	69	[Dessinateur prétendu (r313)]	r313	f	133	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
207	http://data.bnf.fr/vocabulary/roles/r560	10513	\N	69	[Présentateur (r560)]	r560	f	10513	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://data.bnf.fr/vocabulary/roles/r1438	120	\N	69	[Interprète (Instruments à vent divers (musique e.. (r1438)]	r1438	f	120	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
222	http://data.bnf.fr/vocabulary/roles/r379	40	\N	69	[Autorité régnante (r379)]	r379	f	40	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
229	http://data.bnf.fr/vocabulary/roles/r144	19	\N	69	[Calligraphe du document reproduit (r144)]	r144	f	19	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
239	http://data.bnf.fr/vocabulary/roles/r1299	2823	\N	69	[Instrumentalist (r1299)]	r1299	f	2823	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
244	http://data.bnf.fr/vocabulary/roles/r152	1060	\N	69	[Cartographe du modèle (r152)]	r152	f	1060	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://data.bnf.fr/vocabulary/roles/r123	54	\N	69	[Auteur prétendu du commentaire (r123)]	r123	f	54	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
263	http://data.bnf.fr/vocabulary/roles/r3250	749055	\N	69	[Éditeur commercial (r3250)]	r3250	f	749055	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://data.bnf.fr/vocabulary/roles/r375	27	\N	69	[Émetteur (r375)]	r375	f	27	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://data.bnf.fr/vocabulary/roles/r371	10438	\N	69	[Autorité émettrice de monnaie présumée (r371)]	r371	f	10438	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
290	http://data.bnf.fr/vocabulary/roles/r1268	13	\N	69	[Instrumentalist (r1268)]	r1268	f	13	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
301	http://data.bnf.fr/vocabulary/roles/r1250	196	\N	69	[Instrumentalist (r1250)]	r1250	f	196	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
317	http://data.bnf.fr/vocabulary/roles/r160	12778	\N	69	[Chorégraphe (r160)]	r160	f	12778	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
325	http://data.bnf.fr/vocabulary/roles/r165	26	\N	69	[Maître de ballet (r165)]	r165	f	26	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
326	http://data.bnf.fr/vocabulary/roles/r161	3	\N	69	[Choreographer (r161)]	r161	f	3	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
339	http://data.bnf.fr/vocabulary/roles/r1030	320048	\N	69	[Chanteur (r1030)]	r1030	f	320048	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://data.bnf.fr/vocabulary/roles/r173	6	\N	69	[Collaborateur prétendu (r173)]	r173	f	6	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
365	http://data.bnf.fr/vocabulary/roles/r4190	79	\N	69	[Addressee (r4190)]	r4190	f	79	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
386	http://data.bnf.fr/vocabulary/roles/r2180	68	\N	69	[Créateur (Illustration sonore) (r2180)]	r2180	f	68	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://data.bnf.fr/vocabulary/roles/r1090	93	\N	69	[Mime (r1090)]	r1090	f	93	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
423	http://data.bnf.fr/vocabulary/roles/r1740	25	\N	69	[Instrumentalist (r1740)]	r1740	f	25	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
444	http://data.bnf.fr/vocabulary/roles/r81	5	\N	69	[Auteur présumé de l'argument (r81)]	r81	f	5	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
457	http://data.bnf.fr/vocabulary/roles/r93	3	\N	69	[Animator (r93)]	r93	f	3	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
468	http://data.bnf.fr/vocabulary/roles/r1947	4	\N	69	[Instrumentalist (r1947)]	r1947	f	4	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
478	http://data.bnf.fr/vocabulary/roles/r71	11968	\N	69	[Auteur présumé du texte (r71)]	r71	f	11968	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
493	http://data.bnf.fr/vocabulary/roles/r1948	19	\N	69	[Instrumentalist (r1948)]	r1948	f	19	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
504	http://data.bnf.fr/vocabulary/roles/r21	74	\N	69	[Agence de publicité présumée (création) (r21)]	r21	f	74	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
516	http://data.bnf.fr/vocabulary/roles/r1580	5841	\N	69	[Claveciniste (r1580)]	r1580	f	5841	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
524	http://data.bnf.fr/vocabulary/roles/r1108	85	\N	69	[Instrumentalist (r1108)]	r1108	f	85	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
530	http://data.bnf.fr/vocabulary/roles/r424	2	\N	69	[Engraver (r424)]	r424	f	2	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
538	http://data.bnf.fr/vocabulary/roles/r1337	46	\N	69	[Instrumentalist (r1337)]	r1337	f	46	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
549	http://data.bnf.fr/vocabulary/roles/r1367	121	\N	69	[Instrumentalist (r1367)]	r1367	f	121	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
557	http://data.bnf.fr/vocabulary/roles/r1368	515	\N	69	[Instrumentalist (r1368)]	r1368	f	515	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
564	http://data.bnf.fr/vocabulary/roles/r400	1	\N	69	[Géomètre-arpenteur (r400)]	r400	f	1	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
578	http://data.bnf.fr/vocabulary/roles/r1358	634	\N	69	[Instrumentalist (r1358)]	r1358	f	634	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
588	http://data.bnf.fr/vocabulary/roles/r1540	32	\N	69	[Instrumentalist (r1540)]	r1540	f	32	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
596	http://data.bnf.fr/vocabulary/roles/r460	524	\N	69	[Auteur du reportage (r460)]	r460	f	524	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
608	http://data.bnf.fr/vocabulary/roles/r1537	49	\N	69	[Instrumentalist (r1537)]	r1537	f	49	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
617	http://data.bnf.fr/vocabulary/roles/r1567	6934	\N	69	[Instrumentalist (r1567)]	r1567	f	6934	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
625	http://data.bnf.fr/vocabulary/roles/r1558	46	\N	69	[Instrumentalist (r1558)]	r1558	f	46	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
632	http://data.bnf.fr/vocabulary/roles/r1318	2106	\N	69	[Instrumentalist (r1318)]	r1318	f	2106	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
640	http://data.bnf.fr/vocabulary/roles/r1189	3	\N	69	[Basse (voix ; sons traités par l'électronique) (r1189)]	r1189	f	3	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
646	http://data.bnf.fr/vocabulary/roles/r3350	5	\N	69	[Agence mettant à disposition une reproduction de.. (r3350)]	r3350	f	5	\N	\N	f	f	19	17	\N	t	f	\N	\N	\N	t	f	f
657	http://data.bnf.fr/vocabulary/roles/r2266	8	\N	69	[Production personnel (r2266)]	r2266	f	8	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
668	http://data.bnf.fr/vocabulary/roles/r484	113	\N	69	[Lithographe de l'œuvre reproduite (r484)]	r484	f	113	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
677	http://data.bnf.fr/vocabulary/roles/r3130	45	\N	69	[Copyright holder (r3130)]	r3130	f	45	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
684	http://data.bnf.fr/vocabulary/roles/r4220	143	\N	69	[Intermédiaire commercial (r4220)]	r4220	f	143	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
697	http://data.bnf.fr/vocabulary/roles/r3320	109	\N	69	[Imprimeur de cartes (r3320)]	r3320	f	109	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
705	http://data.bnf.fr/vocabulary/roles/r1378	99	\N	69	[Instrumentalist (r1378)]	r1378	f	99	\N	\N	f	f	19	6	\N	t	f	\N	\N	\N	t	f	f
716	http://data.bnf.fr/vocabulary/roles/r1160	19758	\N	69	[Baryton (voix) (r1160)]	r1160	f	19758	\N	\N	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
724	http://data.bnf.fr/vocabulary/roles/r3100	8051	\N	69	[Agence de publicité (r3100)]	r3100	f	8051	\N	\N	f	f	24	17	\N	t	f	\N	\N	\N	t	f	f
753	http://data.bnf.fr/vocabulary/roles/r4070	106	\N	69	[Parapheur (r4070)]	r4070	f	106	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
769	http://data.bnf.fr/vocabulary/roles/r4250	46	\N	69	[Bibliothécaire (r4250)]	r4250	f	46	\N	\N	f	f	24	6	\N	t	f	\N	\N	\N	t	f	f
785	http://data.bnf.fr/vocabulary/roles/r2096	5	\N	69	[Director (r2096)]	r2096	f	5	\N	\N	f	f	26	6	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_data_bnf_fr_sparql; Owner: -
--

COPY http_data_bnf_fr_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	4	9	Vidéaste	fr
2	7	9	Instrumentalist	en
3	7	9	Interprète (Clavicorde)	fr
4	8	9	Remixeur	fr
5	8	9	Performer	en
6	10	9	Instrumentalist	en
7	10	9	Interprète (Orgues mécaniques (divers))	fr
8	11	9	Auteur de la collation	fr
9	11	9	Scribe	en
10	13	9	Designer sonore	fr
11	15	8	priorVersion	\N
12	16	9	Disc jockey	fr
13	16	9	Performer	en
14	18	9	Harmoniumiste	fr
15	18	9	Instrumentalist	en
16	20	9	Chef de la mission	fr
17	20	9	Research team head	en
18	31	9	Ensemble à vent	fr
19	31	9	Instrumentalist	en
20	33	9	Instrumentalist	en
21	33	9	Interprète (Flûte à bec)	fr
22	34	9	Vielleur	fr
23	34	9	Instrumentalist	en
24	36	8	referenceIGN	fr
25	37	9	Ensemble à vent (musique ethnique)	fr
26	37	9	Instrumentalist	en
27	39	9	Instrumentalist	en
28	39	9	Interprète (Flûtes à bec (diverses))	fr
29	40	9	Instrumentalist	en
30	40	9	Interprète (Vielle à roue électrique)	fr
31	41	9	Participant	fr
32	45	9	Accordéoniste	fr
33	45	9	Instrumentalist	en
34	47	9	Ensemble de cordes	fr
35	47	9	Instrumentalist	en
36	53	9	Instrumentalist	en
37	53	9	Interprète (Accordéon (musique ethnique))	fr
38	54	9	Instrumentalist	en
39	54	9	Interprète (Accordéons (divers))	fr
40	55	9	Ensemble de cordes (musique ethnique)	fr
41	55	9	Instrumentalist	en
42	56	9	Ensemble vocal (musique ethnique)	fr
43	57	9	Groupe vocal	fr
44	58	9	Ancien détenteur	fr
45	58	9	Former owner	en
46	60	9	Transcripteur	fr
47	60	9	Transcriber	en
48	63	9	Auteur ou responsable intellectuel (autre)	fr
49	63	9	Author	en
50	64	9	Ensemble vocal et instrumental	fr
51	64	9	Instrumentalist	en
52	66	9	Magistrat monétaire	fr
53	67	9	Assistant metteur en scène	fr
54	68	9	Atelier monétaire prétendu	fr
55	69	9	Chœur à voix égales	fr
56	70	9	Atelier monétaire présumé	fr
57	71	9	Atelier monétaire	fr
58	73	9	Metteur en scène	fr
59	73	9	Restager	en
60	74	9	Monétaire présumé	fr
61	75	9	Addressee	en
62	75	9	Destinataire de l'envoi	fr
63	77	9	Orfèvre	fr
64	77	9	Artist	en
65	78	9	Ensemble vocal	fr
66	79	9	Auteur ou responsable intellectuel	fr
67	79	9	Author	en
68	80	9	Enlumineur de l'œuvre reproduite	fr
69	80	9	Illuminator	en
70	81	9	Enlumineur prétendu	fr
71	81	9	Illuminator	en
72	82	9	Enlumineur du modèle	fr
73	82	9	Illuminator	en
74	83	9	Enlumineur présumé	fr
75	83	9	Illuminator	en
76	84	9	Enlumineur	fr
77	84	9	Illuminator	en
78	86	9	Interprète (Bruitages)	fr
79	86	9	Performer	en
80	88	9	Instrumentalist	en
81	88	9	Interprète (Orgue mécanique)	fr
82	90	9	Ensemble vocal et instrumental (musique ethnique)	fr
83	90	9	Instrumentalist	en
84	91	9	Groupe vocal et instrumental	fr
85	91	9	Instrumentalist	en
86	94	9	Auteur de la recension	fr
87	94	9	Reviewer	en
88	97	9	Siffleur	fr
89	97	9	Performer	en
90	98	9	Interprète (Bruits corporels)	fr
91	98	9	Performer	en
92	99	9	Photographe de l'œuvre reproduite	fr
93	99	9	Photographer	en
94	100	9	Photographe prétendu	fr
95	100	9	Photographer	en
96	101	9	Photographe, auteur du modèle	fr
97	101	9	Photographer	en
98	103	8	lastYear	fr
99	105	9	Altiste	fr
100	105	9	Instrumentalist	en
101	106	9	Instrumentalist	en
102	106	9	Interprète (Basson)	fr
103	108	9	Typographe	fr
104	108	9	Typographer	en
105	109	9	Dedicator	en
106	109	9	Dédicateur	fr
107	111	9	Author of afterword, colophon, etc.	en
108	111	9	Postfacier	fr
109	112	9	Orchestrateur	fr
110	112	9	Adapter	en
111	113	9	Instrumentalist	en
112	113	9	Interprète (Alto (instrument ; traité par l'électronique))	fr
113	114	9	Saxophoniste	fr
114	114	9	Instrumentalist	en
115	115	9	Instrumentalist	en
116	115	9	Marimbiste	fr
117	116	9	Opérateur du son	fr
118	116	9	Recording engineer	en
119	117	9	Violoniste	fr
120	117	9	Instrumentalist	en
121	118	9	Dessinateur présumé	fr
122	118	9	Draftsman	en
123	119	9	Instrumentalist	en
124	119	9	Interprète (Lyricon)	fr
125	120	9	Opérateur du son	fr
126	120	9	Recording engineer	en
127	121	9	Instrumentalist	en
128	121	9	Interprète (Cordes frottées (divers))	fr
129	122	9	Dessinateur	fr
130	122	9	Draftsman	en
131	123	9	Ingénieur du son	fr
132	123	9	Recording engineer	en
133	124	9	Préfacier	fr
134	124	9	Author of introduction, etc.,	en
135	125	9	Adapter	en
136	125	9	Auteur de la réduction musicale	fr
137	126	9	Instrumentalist	en
138	126	9	Interprète (Violon électrique)	fr
139	127	9	Instrumentalist	en
140	127	9	Interprète (Cordes frottées (musique ethnique))	fr
141	128	9	Parolier	fr
142	128	9	Lyricist	en
143	131	9	Instrumentalist	en
144	131	9	Interprète (Bugle)	fr
145	132	9	Contrebassiste	fr
146	132	9	Instrumentalist	en
147	133	9	Intervenant sur l'exemplaire	fr
148	135	9	Peintre	fr
149	135	9	Artist	en
150	136	9	Instrumentalist	en
151	136	9	Interprète (Contrebasse électrique)	fr
152	137	9	Artist	en
153	137	9	Graveur de coin	fr
154	140	9	Artist	en
155	140	9	Peintre de l'œuvre reproduite	fr
156	141	9	Artist	en
157	141	9	Peintre prétendu	fr
158	142	9	Artist	en
159	142	9	Peintre du modèle	fr
160	143	9	Artist	en
161	143	9	Peintre présumé	fr
162	146	9	Violoncelliste	fr
163	146	9	Instrumentalist	en
164	147	9	Trompettiste	fr
165	147	9	Instrumentalist	en
166	148	9	Instrumentalist	en
167	148	9	Interprète (Cuivres (divers))	fr
168	149	9	Intervenant sur l'exemplaire (autre)	fr
169	150	9	Photographe présumé	fr
170	150	9	Photographer	en
171	151	9	Instrumentalist	en
172	151	9	Interprète (Violoncelle électrique)	fr
173	152	9	Photographe	fr
174	152	9	Photographer	en
175	153	9	Adapter	en
176	153	9	Réalisateur de la basse continue	fr
177	154	9	Instrumentalist	en
178	154	9	Interprète (Trompes (musique ethnique))	fr
179	158	9	Instrumentalist	en
180	158	9	Interprète (Tambour)	fr
181	159	9	Collaborateur technico-artistique	fr
182	159	9	Production personnel	en
183	161	9	Clarinettiste	fr
184	161	9	Instrumentalist	en
185	162	9	Instrumentalist	en
186	162	9	Interprète (Percussions (musique ethnique))	fr
187	163	9	Auteur présumé de l'idée originale	fr
188	163	9	Conceptor	en
189	164	9	Percussionniste	fr
190	164	9	Instrumentalist	en
191	165	9	Auteur de l'idée originale	fr
192	165	9	Conceptor	en
193	168	9	Dialoguiste	fr
194	168	9	Author of dialog	en
195	169	9	Producteur de fonds d'archives	fr
196	170	9	Instrumentalist	en
197	170	9	Interprète (Instruments à anche (musique ethnique))	fr
198	171	9	Instrumentalist	en
199	171	9	Interprète (Instruments à anche (divers))	fr
200	174	9	Auteur prétendu de l'idée originale	fr
201	174	9	Conceptor	en
202	175	8	electronicEdition	fr
203	178	9	Collaborateur technico-artistique (autre)	fr
204	178	9	Production personnel	en
205	179	9	Ensemble de cuivres	fr
206	179	9	Instrumentalist	en
207	180	9	Instrumentalist	en
208	180	9	Interprète (Flûte de Pan)	fr
209	181	9	Instrumentalist	en
210	181	9	Interprète (Batterie (interprète présumé))	fr
211	183	9	Batteur	fr
212	183	9	Instrumentalist	en
213	184	9	Attributed name	en
214	184	9	Auteur prétendu de lettres	fr
215	185	9	Instrumentalist	en
216	185	9	Interprète (Membranophones (divers))	fr
217	186	9	Ensemble de cuivres (musique ethnique)	fr
218	186	9	Instrumentalist	en
219	187	9	Attributed name	en
220	187	9	Auteur présumé de lettres	fr
221	188	9	Auteur de lettres	fr
222	188	9	Author	en
223	189	9	Instrumentalist	en
224	189	9	Interprète (Flûtes de Pan (musique ethnique))	fr
225	190	9	Dramaturge	fr
226	190	9	Production personnel	en
227	191	9	Instrumentalist	en
228	191	9	Interprète (Batterie électrique)	fr
229	193	9	Instrumentalist	en
230	193	9	Interprète (Membranophones (musique ethnique))	fr
231	194	9	Développeur	fr
232	194	9	Programmer	en
233	195	8	superficie	fr
234	196	9	Dessinateur de l'œuvre reproduite	fr
235	196	9	Draftsman	en
236	197	9	Dessinateur prétendu	fr
237	197	9	Draftsman	en
238	198	8	imports	\N
239	199	9	Dessinateur du modèle	fr
240	199	9	Draftsman	en
241	201	9	Instrumentalist	en
242	201	9	Interprète (Cor anglais )	fr
243	202	9	Xylophoniste	fr
244	202	9	Instrumentalist	en
245	203	9	Chanteur (enfant)	fr
246	203	9	Singer	en
247	204	9	Addressee	en
248	204	9	Destinataire de lettres présumé	fr
249	205	9	Addressee	en
250	205	9	Destinataire de lettres	fr
251	206	9	Instrumentalist	en
252	206	9	Interprète (Xylophones (musique ethnique))	fr
253	207	9	Présentateur	fr
254	207	9	Inscriber	en
255	210	9	Timbaliste	fr
256	210	9	Instrumentalist	en
257	212	9	Hautboïste	fr
258	212	9	Instrumentalist	en
259	213	9	Instrumentalist	en
260	213	9	Interprète (Instruments à vent (divers))	fr
261	214	9	Directeur de publication	fr
262	214	9	Publishing director	en
263	215	9	Producteur artistique	fr
264	215	9	Director	en
265	216	9	Interprète (Instruments à vent divers (musique ethnique))	fr
266	216	9	Instrumentalist	en
267	219	8	firstYear	fr
268	220	8	cadreGeographique	fr
269	222	9	Autorité régnante	fr
270	224	9	Agence photographique	fr
271	224	9	Distributor	en
272	225	9	Coordonnateur des effets spéciaux	fr
273	225	9	Production personnel	en
274	226	9	Danseur	fr
275	226	9	Dancer	en
276	227	9	Graphiste	fr
277	227	9	Artist	en
278	229	9	Calligraphe du document reproduit	fr
279	229	9	Calligrapher	en
280	230	9	Calligraphe prétendu	fr
281	230	9	Calligrapher	en
282	231	9	Calligraphe supposé	fr
283	231	9	Calligrapher	en
284	232	9	Calligraphe	fr
285	232	9	Calligrapher	en
286	234	9	Chef éclairagiste	fr
287	234	9	Lighting designer	en
288	235	9	Marionnettiste	fr
289	236	9	Instrumentalist	en
290	236	9	Interprète (Guitare basse)	fr
291	237	9	Géodésien	fr
292	237	9	Surveyor	en
293	238	9	Agence de presse	fr
294	238	9	Distributor	en
295	239	9	Instrumentalist	en
296	239	9	Interprète (Guitare basse électrique)	fr
297	240	9	Régisseur lumières	fr
298	241	9	Concepteur des éclairages	fr
299	242	9	Cartographe du document reproduit	fr
300	242	9	Cartographer	en
301	243	9	Cartographe prétendu	fr
302	243	9	Cartographer	en
303	244	9	Cartographe du modèle	fr
304	244	9	Cartographer	en
305	245	9	Cartographe présumé	fr
306	245	9	Cartographer	en
307	246	9	Cartographe	fr
308	246	9	Cartographer	en
309	250	9	Chef de chœur	fr
310	251	9	Imprimeur-libraire	fr
311	251	9	Bookseller	en
312	252	9	Détenteur du privilège	fr
313	257	9	Expert	fr
314	258	9	Auteur prétendu du commentaire	fr
315	258	9	Commentator for written text	en
316	259	9	Auteur présumé du commentaire	fr
317	259	9	Commentator for written text	en
318	260	9	Auteur du commentaire	fr
319	260	9	Commentator for written text	en
320	261	9	Éditeur scientifique	fr
321	261	9	Editor	en
322	262	9	Auteur de la conférence	fr
323	262	9	Author	en
324	263	9	Éditeur commercial	fr
325	263	9	Publisher	en
326	264	9	Faussaire	fr
327	264	9	Forger	en
328	265	9	Lecteur à voix haute	fr
329	268	9	Commissaire-priseur	fr
330	268	9	Auctioneer	en
331	269	9	Donor	en
332	269	9	Fondateur de waqf	fr
333	271	9	Émetteur prétendu	fr
334	272	9	Émetteur douteux	fr
335	273	9	Émetteur	fr
336	274	9	Autorité émettrice de monnaie prétendue	fr
337	276	9	Auteur du matériel d'accompagnement	fr
338	276	9	Writer of accompanying material	en
339	277	9	Autorité émettrice de monnaie présumée	fr
340	279	8	subject	fr
341	281	9	Autorité émettrice de monnaie	fr
342	281	9	Originator	en
343	284	9	Instrumentalist	en
344	284	9	Interprète (Viole d'amour)	fr
345	285	9	Directeur de ballet	fr
346	285	9	Director	en
347	287	9	Artiste de cirque	fr
348	287	9	Performer	en
349	288	9	Collecteur	fr
350	288	9	Collector	en
351	289	9	Bookjacket designer	en
352	289	9	Créateur du cartonnage d'éditeur	fr
353	290	9	Instrumentalist	en
354	290	9	Interprète (Hardingfele)	fr
355	292	9	Directeur de salle de spectacle	fr
356	292	9	Distributor	en
357	295	9	Instrumentalist	en
358	295	9	Interprète (Cornet à pistons)	fr
359	296	9	Acteur présumé	fr
360	296	9	Actor	en
361	297	9	Directeur artistique	fr
362	297	9	Director	en
363	298	9	Acteur	fr
364	298	9	Actor	en
365	299	9	Scripteur	fr
366	299	9	Transcriber	en
367	300	9	Commanditaire du contenu	fr
368	300	9	Sponsor	en
369	301	9	Instrumentalist	en
370	301	9	Interprète (Basse de viole)	fr
371	302	9	Violiste	fr
372	302	9	Instrumentalist	en
373	303	9	Acteur prétendu	fr
374	303	9	Actor	en
375	305	9	Chansonnier	fr
376	307	9	Humoriste	fr
377	307	9	Actor	en
378	308	9	Instrumentalist	en
379	308	9	Interprète (Cordophones divers (musique ethnique))	fr
380	311	8	complementOf	\N
381	313	9	Chef d'orchestre	fr
382	313	9	Conductor	en
383	314	9	Régisseur son (théâtre)	fr
384	315	9	Guitariste	fr
385	315	9	Instrumentalist	en
386	317	9	Chorégraphe	fr
387	317	9	Choreographer	en
388	320	9	Documentaliste	fr
389	321	9	Galerie	fr
390	321	9	Distributor	en
391	322	9	Instrumentalist	en
392	322	9	Interprète (Guitare électrique)	fr
393	323	9	Instrumentalist	en
394	323	9	Interprète (Guitares (musique ethnique))	fr
395	324	9	Instrumentalist	en
396	324	9	Interprète (Guitares (diverses))	fr
397	325	9	Maître de ballet	fr
398	326	9	Choreographer	en
399	326	9	Chorégraphe présumé	fr
400	331	9	Graphiste	fr
401	331	9	Artist	en
402	332	9	Harpiste	fr
403	332	9	Instrumentalist	en
404	334	9	Collaborateur présumé	fr
405	335	9	Chanteur prétendu	fr
406	335	9	Singer	en
407	336	9	Collaborateur	fr
408	337	9	Chanteur présumé	fr
409	337	9	Singer	en
410	338	9	Directeur musical	fr
411	338	9	Director	en
412	339	9	Chanteur	fr
413	339	9	Singer	en
414	341	9	Instrumentalist	en
415	341	9	Interprète (Harpes (musique ethnique))	fr
416	342	9	Distributeur	fr
417	342	9	Distributor	en
418	343	9	Instrumentalist	en
419	343	9	Interprète (Harpes (diverses))	fr
420	345	9	Chanteur (sons traités par l'électronique)	fr
421	345	9	Singer	en
422	346	9	Collaborateur prétendu	fr
423	350	9	Producteur exécutif	fr
424	350	9	Producer	en
425	351	9	Annotator	en
426	351	9	Auteur des annotations manuscrites	fr
427	352	9	Auteur présumé des notes manuscrites	fr
428	355	9	Instrumentalist	en
429	355	9	Piano à 4 mains	fr
430	359	9	Technicien de laboratoire	fr
431	360	9	Associated name	en
432	360	9	Bénéficiaire de waqf	fr
433	365	9	Addressee	en
434	365	9	Destinataire de la pièce jointe	fr
435	366	9	Instrumentalist	en
436	366	9	Interprète (Célesta)	fr
437	369	9	Photographer	en
438	369	9	Tireur de la photographie	fr
439	370	9	Auteur de la pièce jointe	fr
440	370	9	Writer of accompanying material	en
441	375	9	Expert	fr
442	375	9	Expert	en
443	376	9	Maquettiste	fr
444	376	9	Production personnel	en
445	378	9	Bookseller	en
446	378	9	Libraire-marchand d'estampes	fr
447	384	8	ocrConfidence	fr
448	386	9	Créateur (Illustration sonore)	fr
449	386	9	Recording engineer	en
450	387	9	Mime	fr
451	387	9	Performer	en
452	388	9	Bookseller	en
453	388	9	Imprimeur-libraire antécédent	fr
454	389	9	Associated name	en
455	389	9	Lecteur	fr
456	394	9	Vendeur	fr
457	394	9	Associated name	en
458	395	9	Imprimeur	fr
459	395	9	Printer	en
460	412	9	Fabricant du papier	fr
461	412	9	Papermaker	en
462	414	9	Relieur	fr
463	414	9	Binder	en
464	416	9	Libraire	fr
465	416	9	Bookseller	en
466	421	9	Directeur d'atelier	fr
467	421	9	Manufacturer	en
468	423	9	Instrumentalist	en
469	423	9	Interprète (Harmonica de verre)	fr
470	424	9	Interprète (autre)	fr
471	424	9	Performer	en
472	426	9	Instrumentalist	en
473	426	9	Interprète (Cornet à bouquin)	fr
474	427	9	Instrumentalist	en
475	427	9	Interprète (Idiophones frottés (musique ethnique))	fr
476	428	9	Instrumentalist	en
477	428	9	Interprète (Cristallophones)	fr
478	429	9	Instrumentalist	en
479	429	9	Interprète (Idiophones secoués (musique ethnique))	fr
480	433	9	Instrumentalist	en
481	433	9	Interprète (Guimbarde)	fr
482	434	8	habitants	fr
483	435	9	Instrumentalist	en
484	435	9	Interprète (Idiophones pincés (musique ethnique))	fr
485	437	8	domaine	fr
486	439	9	Tromboniste	fr
487	439	9	Instrumentalist	en
488	441	9	Synthétiseur	fr
489	441	9	Instrumentalist	en
490	442	9	Instrumentalist	en
491	442	9	Interprète (Instrument électronique)	fr
492	443	9	Auteur de l'argument	fr
493	443	9	Librettist	en
494	444	9	Auteur présumé de l'argument	fr
495	444	9	Librettist	en
496	445	9	Instrumentalist	en
497	445	9	Interprète (Trombones (divers))	fr
498	449	9	Auteur du slogan	fr
499	449	9	Conceptor	en
500	452	9	Interprète	fr
501	452	9	Performer	en
502	453	9	Corniste	fr
503	453	9	Instrumentalist	en
504	454	9	Ondiste	fr
505	454	9	Instrumentalist	en
506	455	9	Auteur de l'animation	fr
507	455	9	Animator	en
508	456	9	Animator	en
509	456	9	Auteur présumé de l'animation	fr
510	457	9	Animator	en
511	457	9	Auteur prétendu de l'animation	fr
512	458	9	Instrumentalist	en
513	458	9	Interprète (Cornemuses (musique ethnique))	fr
514	460	9	Instrumentalist	en
515	460	9	Interprète (Cornemuses (diverses))	fr
516	461	9	Restager	en
517	461	9	Réalisateur présumé	fr
518	462	9	Réalisateur	fr
519	462	9	Restager	en
520	464	9	Vibraphoniste	fr
521	464	9	Instrumentalist	en
522	465	9	Greffier	fr
523	467	9	Instrumentalist	en
524	467	9	Interprète (Washboard)	fr
525	468	9	Instrumentalist	en
526	468	9	Interprète (Idiophones raclés (divers))	fr
527	469	9	Annotator	en
528	469	9	Auteur de la notice bibliographique	fr
529	470	9	Auteur prétendu du texte	fr
530	470	9	Dubious author	en
531	472	9	Rédacteur	fr
532	472	9	Redaktor	en
533	473	9	Scénariste	fr
534	473	9	Screenwriter	en
535	474	9	Instrumentalist	en
536	474	9	Interprète (Cornemuse)	fr
537	475	9	Fondateur de la publication	fr
538	476	8	mortPourLaFrance	fr
539	477	9	Auteur du texte	fr
540	477	9	Author	en
541	478	9	Auteur présumé du texte	fr
542	478	9	Attributed name	en
543	479	9	Auteur adapté	fr
544	479	9	Bibliographic antecedent	en
545	480	9	Annotateur	fr
546	480	9	Annotator	en
547	481	9	Annotator	en
548	481	9	Auteur présumé des notes éditoriales	fr
549	482	9	Instrumentalist	en
550	482	9	Interprète (Idiophones par percussion (musique ethnique))	fr
551	483	9	Annotator	en
552	483	9	Auteur prétendu des notes éditoriales	fr
553	485	9	Instrumentalist	en
554	485	9	Interprète (Idiophones par percussion (divers))	fr
555	486	9	Lettriste	fr
556	487	8	creationduLieu	fr
557	488	9	Instrumentalist	en
558	488	9	Interprète (Claquettes)	fr
559	489	9	Arranger	en
560	489	9	Arrangeur présumé	fr
561	490	9	Instrumentalist	en
562	490	9	Interprète (Métallophones (divers))	fr
563	492	9	Arranger	en
564	492	9	Arrangeur prétendu	fr
565	493	9	Instrumentalist	en
566	493	9	Interprète (Idiophones raclés (musique ethnique))	fr
567	495	9	Programmeur	fr
568	495	9	Programmer	en
569	496	9	Secrétaire	fr
570	497	9	Performeur	fr
571	498	8	ean	fr
572	499	9	Notaire, tabellion	fr
573	501	9	Carilloniste	fr
574	501	9	Instrumentalist	en
575	502	9	Arrangeur	fr
576	502	9	Arranger	en
577	503	9	Agence de publicité (création)	fr
578	503	9	Originator	en
579	504	9	Agence de publicité présumée (création)	fr
580	504	9	Originator	en
581	505	8	translation	fr
582	506	9	Engraver	en
583	506	9	Graveur de l'œuvre reproduite	fr
584	508	9	Engraver	en
585	508	9	Graveur prétendu	fr
586	509	9	Engraver	en
587	509	9	Graveur du modèle	fr
588	510	9	Originator	en
589	510	9	Agence de publicité pour le document reproduit (création)	fr
590	511	9	Engraver	en
591	511	9	Graveur présumé	fr
592	515	9	Instrumentalist	en
593	515	9	Interprète (Vihuela)	fr
594	516	9	Claveciniste	fr
595	516	9	Instrumentalist	en
596	517	9	Instrumentalist	en
597	517	9	Instrumentiste prétendu	fr
598	518	9	Instrumentalist	en
599	518	9	Interprète (Clavecins (divers))	fr
600	519	9	Instrumentalist	en
601	519	9	Instrumentiste présumé	fr
602	520	9	Instrumentiste	fr
603	520	9	Instrumentalist	en
604	521	9	Engraver	en
605	521	9	Graveur en lettres présumé	fr
606	522	9	Graveur en lettres	fr
607	522	9	Engraver	en
608	523	9	Technicien graphique	fr
609	523	9	Artist	en
610	524	9	Instrumentalist	en
611	524	9	Instrumentiste (musique ethnique)	fr
612	525	9	Agence photographique (commanditaire)	fr
613	525	9	Originator	en
614	527	9	Agence photographique présumée (commanditaire)	fr
615	527	9	Originator	en
616	529	9	Originator	en
617	529	9	Agence photographique pour le document reproduit (commanditaire)	fr
618	530	9	Engraver	en
619	530	9	Graveur en lettres de l'œuvre reproduite	fr
620	531	9	Engraver	en
621	531	9	Graveur en lettres du modèle	fr
622	534	9	Mandoliniste	fr
623	534	9	Instrumentalist	en
624	535	9	Pianofortiste	fr
625	535	9	Instrumentalist	en
626	536	9	Opérateur commercial	fr
627	536	9	Publisher	en
628	538	9	Instrumentalist	en
629	538	9	Interprète (Instruments à plectre (divers))	fr
630	539	9	Harmonisateur	fr
631	539	9	Arranger	en
632	540	8	unionOf	\N
633	541	9	Testeur	fr
634	541	9	Programmer	en
635	542	8	versionInfo	\N
636	545	9	Créateur des marionnettes	fr
637	545	9	Puppeteer	en
638	546	9	Marchand	fr
639	546	9	Bookseller	en
640	547	9	Soprano	fr
641	548	9	Cithariste	fr
642	548	9	Instrumentalist	en
643	549	9	Instrumentalist	en
644	549	9	Interprète (Cithares (diverses))	fr
645	551	9	Singer	en
646	551	9	Soprano (sons traités par l'électronique)	fr
647	552	9	Sculpteur présumé	fr
648	552	9	Sculptor	en
649	553	9	Sculpteur	fr
650	553	9	Sculptor	en
651	554	9	Réalisateur des marionnettes	fr
652	555	9	Concepteur des marionnettes	fr
653	556	9	Créateur de l'objet	fr
654	557	9	Instrumentalist	en
655	557	9	Interprète (Cithares (musique ethnique))	fr
656	559	9	Adaptateur	fr
657	559	9	Adapter	en
658	560	9	Adaptateur présumé	fr
659	560	9	Adapter	en
660	561	9	Sculpteur de l'œuvre reproduite	fr
661	561	9	Sculptor	en
662	562	9	Adaptateur prétendu	fr
663	562	9	Adapter	en
664	563	9	Sculpteur du modèle	fr
665	563	9	Sculptor	en
666	564	9	Géomètre-arpenteur	fr
667	564	9	Surveyor	en
668	565	9	Organiste	fr
669	565	9	Instrumentalist	en
670	566	9	Voix parlée	fr
671	566	9	Narrator	en
672	568	9	Instrumentalist	en
673	568	9	Interprète (Banjo)	fr
674	570	9	Instrumentalist	en
675	570	9	Interprète (Orgue (musique ethnique))	fr
676	571	9	Instrumentalist	en
677	571	9	Interprète (Orgues (divers))	fr
678	574	9	Maquilleur	fr
679	574	9	Production personnel	en
680	575	9	Graveur	fr
681	575	9	Engraver	en
682	576	9	Maquilleur	fr
683	576	9	Production personnel	en
684	577	9	Signataire	fr
685	577	9	Signer	en
686	578	9	Instrumentalist	en
687	578	9	Interprète (Cordes pincées (musique ethnique))	fr
688	579	9	Chef maquilleur	fr
689	579	9	Production personnel	en
690	580	9	Plasticien	fr
691	581	9	Instrumentalist	en
692	581	9	Interprète (Orgue électronique)	fr
693	582	9	Instrumentalist	en
694	582	9	Interprète (Cordes pincées (divers))	fr
695	583	9	Narrator	en
696	583	9	Voix parlée (sons traités par l'électronique)	fr
697	585	9	Orchestre	fr
698	585	9	Instrumentalist	en
699	586	9	Instrumentalist	en
700	586	9	Interprète (Guitare hawaïenne)	fr
701	588	9	Instrumentalist	en
702	588	9	Interprète (Mirliton)	fr
703	589	9	Composer	en
704	589	9	Compositeur prétendu	fr
705	590	9	Composer	en
706	590	9	Compositeur de l'œuvre adaptée	fr
707	592	9	Ensembles (divers)	fr
708	592	9	Instrumentalist	en
709	593	9	Compositeur présumé	fr
710	593	9	Composer	en
711	594	9	Compositeur	fr
712	594	9	Composer	en
713	595	9	Instrumentalist	en
714	595	9	Interprète (Pedal steel guitar)	fr
715	596	9	Auteur du reportage	fr
716	596	9	Reporter	en
717	600	9	Instrumentalist	en
718	600	9	Interprète (Instrument électronique (non autonome))	fr
719	601	9	Tubiste	fr
720	601	9	Instrumentalist	en
721	602	9	Instrumentalist	en
722	602	9	Interprète (Sculptures et environnements sonores)	fr
723	603	9	Librettist	en
724	603	9	Librettiste prétendu	fr
725	604	9	Concepteur	fr
726	604	9	Conceptor	en
727	605	9	Librettist	en
728	605	9	Librettiste présumé	fr
729	606	9	Librettiste	fr
730	606	9	Librettist	en
731	608	9	Instrumentalist	en
732	608	9	Interprète (Tubas (divers))	fr
733	610	9	Pianiste	fr
734	610	9	Instrumentalist	en
735	611	8	isbn	fr
736	612	9	Opérateur commercial (autre)	fr
737	612	9	Publisher	en
738	613	9	Théorbiste	fr
739	613	9	Instrumentalist	en
740	614	9	Instrumentalist	en
741	614	9	Interprète (Piano électrique)	fr
742	615	9	Illustrateur prétendu	fr
743	615	9	Illustrator	en
744	616	9	Commissaire d'exposition	fr
745	616	9	Curator	en
746	617	9	Instrumentalist	en
747	617	9	Interprète (Claviers (divers))	fr
748	618	9	Illustrateur présumé	fr
749	618	9	Illustrator	en
750	619	9	Illustrateur	fr
751	619	9	Illustrator	en
752	620	9	Traducteur	fr
753	620	9	Translator	en
754	621	9	Harmoniciste	fr
755	621	9	Instrumentalist	en
756	622	9	Ensemble instrumental	fr
757	622	9	Instrumentalist	en
758	623	9	Luthiste	fr
759	623	9	Instrumentalist	en
760	624	8	isan	fr
761	625	9	Instrumentalist	en
762	625	9	Interprète (Instruments à anche libre (musique ethnique))	fr
763	626	9	Instrumentalist	en
764	626	9	Interprète (Instruments à anche libre (divers))	fr
765	627	9	Ensemble instrumental (musique ethnique)	fr
766	627	9	Instrumentalist	en
767	628	9	Compilateur	fr
768	628	9	Compiler	en
769	629	9	Groupe instrumental	fr
770	629	9	Instrumentalist	en
771	630	9	Interviewer	fr
772	630	9	Interviewer	en
773	631	9	Créateur de spectacle	fr
774	631	9	Performer	en
775	632	9	Instrumentalist	en
776	632	9	Interprète (Luths (musique ethnique))	fr
777	633	9	Instrumentalist	en
778	633	9	Interprète (Luths (divers))	fr
779	635	9	Bruiteur	fr
780	635	9	Recording engineer	en
781	636	9	Relieur	fr
782	636	9	Binder	en
783	637	9	Basse (voix)	fr
784	637	9	Singer	en
785	638	9	Commanditaire de la publication	fr
786	638	9	Sponsor	en
787	639	9	Déposant	fr
788	640	9	Basse (voix ; sons traités par l'électronique)	fr
789	640	9	Singer	en
790	642	9	Continuateur prétendu	fr
791	642	9	Contributor	en
792	643	9	Continuateur présumé	fr
793	643	9	Contributor	en
794	644	9	Continuateur	fr
795	644	9	Contributor	en
796	646	9	Agence mettant à disposition une reproduction de la ressource décrite	fr
797	647	9	Régisseur	fr
798	647	9	Production personnel	en
799	649	9	Baryton-basse	fr
800	649	9	Singer	en
801	650	9	Copiste	fr
802	650	9	Scribe	en
803	651	9	Assistant réalisateur	fr
804	651	9	Production personnel	en
805	653	8	date	fr
806	654	9	Annonceur	fr
807	654	9	Publisher	en
808	655	9	Baryton-basse (sons traités par l'électronique)	fr
809	655	9	Singer	en
810	656	9	Illustrateur de l'exemplaire	fr
811	656	9	Illustrator	en
812	657	9	Production personnel	en
813	657	9	Technicien régie	fr
814	659	9	Copiste prétendu	fr
815	659	9	Scribe	en
816	660	9	Copiste présumé	fr
817	660	9	Scribe	en
818	662	9	Script	fr
819	662	9	Production personnel	en
820	663	9	Directeur de production	fr
821	663	9	Producer	en
822	664	9	Mécène	fr
823	665	9	Coloriste	fr
824	665	9	Production personnel	en
825	666	9	Héliograveur	fr
826	667	9	Sérigraphe	fr
827	667	9	Printer of plates	en
828	668	9	Lithographe de l'œuvre reproduite	fr
829	668	9	Lithographer	en
830	669	9	Lithographe prétendu	fr
831	669	9	Lithographer	en
832	670	9	Chef de projet informatique	fr
833	670	9	Programmer	en
834	672	9	Lithographe présumé	fr
835	672	9	Lithographer	en
836	673	9	Lithographe	fr
837	673	9	Lithographer	en
838	675	8	sameAs	\N
839	676	9	Contre-ténor	fr
840	676	9	Singer	en
841	677	9	Copyright holder	en
842	677	9	Détenteur du copyright ou de protection	fr
843	679	9	Créateur (Cascades et batailles)	fr
844	679	9	Production personnel	en
845	680	9	Scénographe	fr
846	680	9	Restager	en
847	681	9	Artist	en
848	681	9	Médailleur	fr
849	682	9	Conseiller pour les cascades	fr
850	682	9	Production personnel	en
851	683	9	Haute-contre	fr
852	683	9	Singer	en
853	684	9	Intermédiaire commercial	fr
854	686	9	Cascadeur	fr
855	686	9	Performer	en
856	690	9	Conseiller scientifique	fr
857	690	9	Scientific advisor	en
858	691	9	Flûtiste	fr
859	691	9	Instrumentalist	en
860	693	9	Monteur	fr
861	693	9	Film editor	en
862	694	9	Alto (voix)	fr
863	694	9	Singer	en
864	695	9	Instrumentalist	en
865	695	9	Interprète (Flûte (sons traités par l'électronique))	fr
866	696	9	Instrumentalist	en
867	696	9	Interprète (Flûtes (musique ethnique))	fr
868	697	9	Imprimeur de cartes	fr
869	697	9	Printer	en
870	698	9	Instrumentalist	en
871	698	9	Interprète (Bois (divers))	fr
872	699	9	Alto (voix ; sons traités par l'électronique)	fr
873	699	9	Singer	en
874	700	9	Cymbaliste	fr
875	700	9	Instrumentalist	en
876	701	8	suppressionduLieu	fr
877	702	9	Créateur des masques	fr
878	702	9	Production personnel	en
879	703	9	Mezzo-soprano	fr
880	703	9	Singer	en
881	704	9	Concepteur des masques	fr
882	705	9	Instrumentalist	en
883	705	9	Interprète (Cordes frappées (musique ethnique))	fr
884	706	9	Instrumentalist	en
885	706	9	Interprète (Cordes frappées (divers))	fr
886	707	9	Graveur de musique	fr
887	707	9	Printmaker	en
888	708	9	Mezzo-soprano (sons traités par l'électronique)	fr
889	708	9	Singer	en
890	710	9	Réalisateur des masques	fr
891	711	8	cote	fr
892	715	9	Opérateur prises de vue	fr
893	715	9	Photographer	en
894	716	9	Baryton (voix)	fr
895	716	9	Singer	en
896	719	9	Correcteur	fr
897	719	9	Corrector	en
898	720	9	Accessoiriste	fr
899	720	9	Production personnel	en
900	721	9	Baryton (voix ; sons traités par l'électronique)	fr
901	721	9	Singer	en
902	722	9	Cartier	fr
903	723	9	Opérateur prises de vue	fr
904	723	9	Photographer	en
905	724	9	Agence de publicité	fr
906	724	9	Publisher	en
907	726	9	Directeur de la photographie	fr
908	726	9	Photographer	en
909	729	8	nomUsuel	fr
910	731	9	Ténor	fr
911	731	9	Singer	en
912	732	9	Instrumentalist	en
913	732	9	Piccoliste	fr
914	733	9	Dédicataire	fr
915	733	9	Dedicatee	en
916	734	9	Photographe de plateau	fr
917	734	9	Photographer	en
918	736	9	Singer	en
919	736	9	Ténor (sons traités par l'électronique)	fr
920	738	8	ouvrageJeunesse	fr
921	741	9	Doreur	fr
922	741	9	Artist	en
923	745	9	Donateur	fr
924	745	9	Donor	en
925	746	9	Diffuseur	fr
926	746	9	Distributor	en
927	753	9	Parapheur	fr
928	753	9	Signer	en
929	756	9	Chœur mixte	fr
930	760	8	coordonneesLambert	fr
931	761	8	ismn	fr
932	762	9	Autre	fr
933	763	8	statutObjet	fr
934	764	9	Inventeur	fr
935	764	9	Inventor	en
936	768	9	Producteur de phonogrammes	fr
937	768	9	Producer	en
938	769	9	Bibliothécaire	fr
939	772	9	Ancien possesseur	fr
940	772	9	Former owner	en
941	774	9	Programmateur	fr
942	774	9	Producer	en
943	776	9	Producteur	fr
944	776	9	Producer	en
945	777	9	Commanditaire de la reliure	fr
946	778	9	Conseiller technique	fr
947	778	9	Production personnel	en
948	782	9	Collectionneur	fr
949	782	9	Collector	en
950	783	9	Réalisateur des décors	fr
951	783	9	Set designer	en
952	785	9	Director	en
953	785	9	Ensemblier	fr
954	786	9	Chef décorateur	fr
955	786	9	Set designer	en
956	787	9	Funder	en
957	787	9	Parraineur	fr
958	792	9	Costumier	fr
959	792	9	Costume designer	en
960	793	9	Auteur de l'envoi	fr
961	793	9	Author	en
962	794	9	Chef costumier	fr
963	794	9	Costume designer	en
964	795	9	Producteur de vidéogrammes	fr
965	795	9	Producer	en
966	797	9	Costume designer	en
967	797	9	Réalisateur des costumes	fr
968	799	8	FRBNF	fr
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.annot_types_id_seq', 9, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cc_rels_id_seq', 9, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.class_annots_id_seq', 4, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.classes_id_seq', 26, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cp_rels_id_seq', 3912, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.ns_id_seq', 93, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.properties_id_seq', 800, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_data_bnf_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_bnf_fr_sparql.property_annots_id_seq', 968, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_data_bnf_fr_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_data_bnf_fr_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_data_bnf_fr_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_data_bnf_fr_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_data_bnf_fr_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_data_bnf_fr_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_data_bnf_fr_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_data_bnf_fr_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_data_bnf_fr_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_data_bnf_fr_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_data_bnf_fr_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_data_bnf_fr_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_data_bnf_fr_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_data_bnf_fr_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_data_bnf_fr_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_data_bnf_fr_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_data_bnf_fr_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_data_bnf_fr_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_data_bnf_fr_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_data_bnf_fr_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_data_bnf_fr_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_data_bnf_fr_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_data_bnf_fr_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_data_bnf_fr_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_data_bnf_fr_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_data_bnf_fr_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_data_bnf_fr_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_data_bnf_fr_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_data_bnf_fr_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_data_bnf_fr_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_data_bnf_fr_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_data_bnf_fr_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_data_bnf_fr_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_data_bnf_fr_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_data_bnf_fr_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_data_bnf_fr_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_data_bnf_fr_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_data_bnf_fr_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_data_bnf_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_data_bnf_fr_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_bnf_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_bnf_fr_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_data_bnf_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_bnf_fr_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_bnf_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_data_bnf_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_bnf_fr_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_data_bnf_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_data_bnf_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_bnf_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_bnf_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_data_bnf_fr_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_bnf_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_data_bnf_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_data_bnf_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_data_bnf_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_bnf_fr_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_bnf_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_data_bnf_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_data_bnf_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_data_bnf_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_data_bnf_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_data_bnf_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

