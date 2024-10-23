--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)

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
-- Name: http_premon_fbk_eu_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_premon_fbk_eu_sparql;


--
-- Name: SCHEMA http_premon_fbk_eu_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_premon_fbk_eu_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE FUNCTION http_premon_fbk_eu_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE FUNCTION http_premon_fbk_eu_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COMMENT ON TABLE http_premon_fbk_eu_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COMMENT ON COLUMN http_premon_fbk_eu_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_premon_fbk_eu_sparql.classes c1
     JOIN http_premon_fbk_eu_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_premon_fbk_eu_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_premon_fbk_eu_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_premon_fbk_eu_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE TABLE http_premon_fbk_eu_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE http_premon_fbk_eu_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_premon_fbk_eu_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_cc_rels AS
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
   FROM http_premon_fbk_eu_sparql.cc_rels r,
    http_premon_fbk_eu_sparql.classes c1,
    http_premon_fbk_eu_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_classes_ns AS
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
    http_premon_fbk_eu_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_premon_fbk_eu_sparql.classes c
     LEFT JOIN http_premon_fbk_eu_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_classes_ns_main AS
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
   FROM http_premon_fbk_eu_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_premon_fbk_eu_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_classes_ns_plus AS
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
    http_premon_fbk_eu_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_premon_fbk_eu_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_premon_fbk_eu_sparql.classes c
     LEFT JOIN http_premon_fbk_eu_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_classes_ns_main_plus AS
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
   FROM http_premon_fbk_eu_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_premon_fbk_eu_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_premon_fbk_eu_sparql.v_classes_ns v
     LEFT JOIN http_premon_fbk_eu_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_cp_rels AS
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
    http_premon_fbk_eu_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_premon_fbk_eu_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_premon_fbk_eu_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_premon_fbk_eu_sparql.cp_rels r,
    http_premon_fbk_eu_sparql.classes c,
    http_premon_fbk_eu_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_cp_rels_card AS
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
   FROM http_premon_fbk_eu_sparql.cp_rels r,
    http_premon_fbk_eu_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_properties_ns AS
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
    http_premon_fbk_eu_sparql.tapprox(p.cnt) AS cnt_x,
    http_premon_fbk_eu_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_premon_fbk_eu_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_premon_fbk_eu_sparql.properties p
     LEFT JOIN http_premon_fbk_eu_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_cp_sources_single AS
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
   FROM ((http_premon_fbk_eu_sparql.v_cp_rels_card r
     JOIN http_premon_fbk_eu_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_premon_fbk_eu_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_cp_targets_single AS
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
   FROM ((http_premon_fbk_eu_sparql.v_cp_rels_card r
     JOIN http_premon_fbk_eu_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_premon_fbk_eu_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_premon_fbk_eu_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_premon_fbk_eu_sparql.pp_rels r,
    http_premon_fbk_eu_sparql.properties p1,
    http_premon_fbk_eu_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_properties_sources AS
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
   FROM (http_premon_fbk_eu_sparql.v_properties_ns v
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
           FROM http_premon_fbk_eu_sparql.cp_rels r,
            http_premon_fbk_eu_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_properties_sources_single AS
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
   FROM (http_premon_fbk_eu_sparql.v_properties_ns v
     LEFT JOIN http_premon_fbk_eu_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_properties_targets AS
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
   FROM (http_premon_fbk_eu_sparql.v_properties_ns v
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
           FROM http_premon_fbk_eu_sparql.cp_rels r,
            http_premon_fbk_eu_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE VIEW http_premon_fbk_eu_sparql.v_properties_targets_single AS
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
   FROM (http_premon_fbk_eu_sparql.v_properties_ns v
     LEFT JOIN http_premon_fbk_eu_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	90	1	\N	\N
2	7	93	1	\N	\N
3	8	80	1	\N	\N
4	9	65	1	\N	\N
5	11	44	1	\N	\N
6	12	69	1	\N	\N
7	13	2	1	\N	\N
8	14	3	1	\N	\N
9	15	60	1	\N	\N
10	16	60	1	\N	\N
11	18	35	1	\N	\N
12	19	3	1	\N	\N
13	20	79	1	\N	\N
14	21	64	1	\N	\N
15	25	60	1	\N	\N
16	28	80	1	\N	\N
17	29	3	1	\N	\N
18	30	2	1	\N	\N
19	31	3	1	\N	\N
20	35	41	1	\N	\N
21	37	35	1	\N	\N
22	38	8	1	\N	\N
23	41	64	1	\N	\N
24	43	8	1	\N	\N
25	45	3	1	\N	\N
26	47	79	1	\N	\N
27	48	80	1	\N	\N
28	49	32	1	\N	\N
29	52	88	1	\N	\N
30	53	12	1	\N	\N
31	54	7	1	\N	\N
32	57	3	1	\N	\N
33	65	64	1	\N	\N
34	67	44	1	\N	\N
35	68	30	1	\N	\N
36	70	32	1	\N	\N
37	72	17	1	\N	\N
38	75	8	1	\N	\N
39	76	44	1	\N	\N
40	77	69	1	\N	\N
41	78	12	1	\N	\N
42	79	2	1	\N	\N
43	80	64	1	\N	\N
44	81	93	1	\N	\N
45	82	8	1	\N	\N
46	83	32	1	\N	\N
47	84	32	1	\N	\N
48	85	79	1	\N	\N
49	85	90	1	\N	\N
50	86	35	1	\N	\N
51	89	30	1	\N	\N
52	90	2	1	\N	\N
53	94	80	1	\N	\N
54	95	35	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	15	8	InverseFunctionalProperty	\N
2	16	8	SymmetricProperty	\N
3	25	8	TransitiveProperty	\N
4	26	8	AnnotationProperty	\N
5	52	8	OntologyProperty	\N
6	58	8	Ontology	\N
7	59	8	Restriction	\N
8	60	8	ObjectProperty	\N
9	61	8	DatatypeProperty	\N
10	71	8	Class	\N
11	87	8	FunctionalProperty	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://premon.fbk.eu/ontology/vn#AndCompoundRestriction	185	\N	t	69	AndCompoundRestriction	AndCompoundRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	185
2	http://premon.fbk.eu/ontology/vn#Restriction	5145	\N	t	69	Restriction	Restriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5145
3	http://premon.fbk.eu/ontology/vn#SynItem	11507	\N	t	69	SynItem	SynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23014
4	http://premon.fbk.eu/ontology/pb#Voice	2	\N	t	71	Voice	Voice	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	112
5	http://www.w3.org/2002/07/owl#AllDisjointClasses	1	\N	t	7	AllDisjointClasses	AllDisjointClasses	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://www.w3.org/ns/lemon/ontolex#LexicalEntry	27053	\N	t	72	LexicalEntry	LexicalEntry	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	346737
7	http://premon.fbk.eu/ontology/core#Example	566653	\N	t	73	Example	Example	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1699254
8	http://premon.fbk.eu/ontology/fn#FrameElement	32312	\N	t	74	FrameElement	FrameElement	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1442875
9	http://premon.fbk.eu/ontology/fn#LexicalUnit	38695	\N	t	74	LexicalUnit	LexicalUnit	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	572541
10	http://premon.fbk.eu/resource/Example	11	\N	t	75	Example	Example	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	http://premon.fbk.eu/ontology/core#SemanticRoleMapping	128282	\N	t	73	SemanticRoleMapping	SemanticRoleMapping	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	261780
12	http://premon.fbk.eu/ontology/vn#SelectionalRestrictionProperty	1959	\N	t	69	SelectionalRestrictionProperty	SelectionalRestrictionProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5192
13	http://premon.fbk.eu/ontology/vn#SyntacticRestriction	1136	\N	t	69	SyntacticRestriction	SyntacticRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1136
14	http://premon.fbk.eu/ontology/vn#VerbSynItem	2968	\N	t	69	VerbSynItem	VerbSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5936
15	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	5	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
16	http://www.w3.org/2002/07/owl#SymmetricProperty	5	\N	t	7	SymmetricProperty	SymmetricProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
17	http://www.w3.org/ns/lemon/lime#Lexicon	1	\N	t	76	Lexicon	Lexicon	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://premon.fbk.eu/ontology/nb#Roleset	5576	\N	t	77	Roleset	Roleset	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39098
19	http://premon.fbk.eu/ontology/vn#PrepSynItem	1554	\N	t	69	PrepSynItem	PrepSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3108
20	http://premon.fbk.eu/ontology/vn#RoleSelectionalRestriction	3677	\N	t	69	RoleSelectionalRestriction	RoleSelectionalRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3677
21	http://premon.fbk.eu/ontology/vn#ThematicRole	58	\N	t	69	ThematicRole	ThematicRole	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	33012
22	http://premon.fbk.eu/ontology/pb#Inflection	137	\N	t	71	Inflection	Inflection	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18580
23	http://premon.fbk.eu/ontology/pb#Person	2	\N	t	71	Person	Person	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	75
24	http://premon.fbk.eu/ontology/pb#Tense	3	\N	t	71	Tense	Tense	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	102
25	http://www.w3.org/2002/07/owl#TransitiveProperty	7	\N	t	7	TransitiveProperty	TransitiveProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21
26	http://www.w3.org/2002/07/owl#AnnotationProperty	37	\N	t	7	AnnotationProperty	AnnotationProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
27	http://premon.fbk.eu/resource/Resource	11	\N	t	75	Resource	Resource	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	33
28	http://premon.fbk.eu/ontology/pb#SemanticRole	693216	\N	t	71	SemanticRole	SemanticRole	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	901483
29	http://premon.fbk.eu/ontology/vn#AdvSynItem	75	\N	t	69	AdvSynItem	AdvSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	150
30	http://premon.fbk.eu/ontology/vn#AtomicRestriction	4285	\N	t	69	AtomicRestriction	AtomicRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4285
31	http://premon.fbk.eu/ontology/vn#NpSynItem	6745	\N	t	69	NpSynItem	NpSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13490
32	http://premon.fbk.eu/ontology/vn#PredArg	25001	\N	t	69	PredArg	PredArg	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	50002
33	http://premon.fbk.eu/ontology/vn#PredType	299	\N	t	69	PredType	PredType	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14584
34	http://premon.fbk.eu/ontology/vn#AuxnpType	4	\N	t	69	AuxnpType	AuxnpType	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
35	http://premon.fbk.eu/ontology/core#SemanticClass	39108	\N	t	73	SemanticClass	SemanticClass	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1041102
36	http://premon.fbk.eu/ontology/fn#FECoreSet	1096	\N	t	74	FECoreSet	FECoreSet	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1096
37	http://premon.fbk.eu/ontology/fn#Frame	3445	\N	t	74	Frame	Frame	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	670389
38	http://premon.fbk.eu/ontology/fn#PeripheralFrameElement	14239	\N	t	74	PeripheralFrameElement	PeripheralFrameElement	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	249810
39	http://premon.fbk.eu/ontology/vn#VerbNetFrame	2968	\N	t	69	VerbNetFrame	VerbNetFrame	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7518
40	http://www.w3.org/2002/07/owl#AllDisjointProperties	1	\N	t	7	AllDisjointProperties	AllDisjointProperties	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://www.w3.org/ns/lemon/ontolex#LexicalConcept	53311	\N	t	72	LexicalConcept	LexicalConcept	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1151678
42	http://premon.fbk.eu/ontology/nb#Tag	3	\N	t	77	Tag	Tag	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2228
43	http://premon.fbk.eu/ontology/fn#CoreUnexpressedFrameElement	329	\N	t	74	CoreUnexpressedFrameElement	CoreUnexpressedFrameElement	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20774
44	http://premon.fbk.eu/ontology/core#Mapping	251242	\N	t	73	Mapping	Mapping	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	261780
45	http://premon.fbk.eu/ontology/vn#LexSynItem	159	\N	t	69	LexSynItem	LexSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	318
46	http://premon.fbk.eu/ontology/vn#Pred	8224	\N	t	69	Pred	Pred	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16448
47	http://premon.fbk.eu/ontology/vn#PrepositionSelectionalRestriction	332	\N	t	69	PrepositionSelectionalRestriction	PrepositionSelectionalRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	332
48	http://premon.fbk.eu/ontology/vn#SemanticRole	3165	\N	t	69	SemanticRole	SemanticRole	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	102211
49	http://premon.fbk.eu/ontology/vn#VerbSpecificPredArg	1871	\N	t	69	VerbSpecificPredArg	VerbSpecificPredArg	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3742
50	http://premon.fbk.eu/ontology/pb#Form	4	\N	t	71	Form	Form	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	125
51	http://www.w3.org/2000/01/rdf-schema#Class	15	\N	t	2	Class	Class	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	646
52	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://premon.fbk.eu/ontology/vn#PrepositionRestrictionProperty	9	\N	t	69	PrepositionRestrictionProperty	PrepositionRestrictionProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	322
54	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#Context	566653	\N	t	70	Context	Context	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1699254
55	http://premon.fbk.eu/ontology/core#AnnotationSet	614134	\N	t	73	AnnotationSet	AnnotationSet	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
56	http://premon.fbk.eu/ontology/fn#LUStatus	54	\N	t	74	LUStatus	LUStatus	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	38747
57	http://premon.fbk.eu/ontology/vn#AdjSynItem	6	\N	t	69	AdjSynItem	AdjSynItem	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
58	http://www.w3.org/2002/07/owl#Ontology	13	\N	t	7	Ontology	Ontology	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13
59	http://www.w3.org/2002/07/owl#Restriction	111	\N	t	7	Restriction	Restriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	540
60	http://www.w3.org/2002/07/owl#ObjectProperty	157	\N	t	7	ObjectProperty	ObjectProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	537
61	http://www.w3.org/2002/07/owl#DatatypeProperty	47	\N	t	7	DatatypeProperty	DatatypeProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	108
62	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
63	http://premon.fbk.eu/ontology/vn#EventPredArgType	4	\N	t	69	EventPredArgType	EventPredArgType	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5620
64	http://www.w3.org/2004/02/skos/core#Concept	1001669	\N	t	4	Concept	Concept	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5252077
65	http://premon.fbk.eu/ontology/core#Conceptualization	129254	\N	t	73	Conceptualization	Conceptualization	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1011654
66	http://premon.fbk.eu/ontology/fn#SemType	284	\N	t	74	SemType	SemType	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17430
67	http://premon.fbk.eu/ontology/core#ConceptualizationMapping	56009	\N	t	73	ConceptualizationMapping	ConceptualizationMapping	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
68	http://premon.fbk.eu/ontology/vn#ExistAtomicRestriction	3931	\N	t	69	ExistAtomicRestriction	ExistAtomicRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3931
69	http://premon.fbk.eu/ontology/vn#RestrictionProperty	2000	\N	t	69	RestrictionProperty	RestrictionProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6357
70	http://premon.fbk.eu/ontology/vn#ThemRolePredArg	13646	\N	t	69	ThemRolePredArg	ThemRolePredArg	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27292
71	http://www.w3.org/2002/07/owl#Class	190	\N	t	7	Class	Class	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11334554
72	http://rdfs.org/ns/void#Dataset	1	\N	t	16	Dataset	Dataset	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
73	http://www.w3.org/ns/lemon/ontolex#Form	24032	\N	t	72	Form	Form	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48064
74	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#Annotation	2012638	\N	t	70	Annotation	Annotation	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5823273
75	http://premon.fbk.eu/ontology/fn#ExtraThematicFrameElement	7781	\N	t	74	ExtraThematicFrameElement	ExtraThematicFrameElement	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	79388
76	http://premon.fbk.eu/ontology/core#SemanticClassMapping	55694	\N	t	73	SemanticClassMapping	SemanticClassMapping	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
77	http://premon.fbk.eu/ontology/vn#SyntacticRestrictionProperty	41	\N	t	69	SyntacticRestrictionProperty	SyntacticRestrictionProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1165
78	http://premon.fbk.eu/ontology/vn#RoleRestrictionProperty	1950	\N	t	69	RoleRestrictionProperty	RoleRestrictionProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4870
79	http://premon.fbk.eu/ontology/vn#SelectionalRestriction	4009	\N	t	69	SelectionalRestriction	SelectionalRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4009
80	http://premon.fbk.eu/ontology/core#SemanticRole	819046	\N	t	73	SemanticRole	SemanticRole	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3055733
81	http://premon.fbk.eu/ontology/core#Markable	1696269	\N	t	73	Markable	Markable	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
82	http://premon.fbk.eu/ontology/fn#CoreFrameElement	9963	\N	t	74	CoreFrameElement	CoreFrameElement	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1092903
83	http://premon.fbk.eu/ontology/vn#ConstantPredArg	1707	\N	t	69	ConstantPredArg	ConstantPredArg	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3414
84	http://premon.fbk.eu/ontology/vn#EventPredArg	7777	\N	t	69	EventPredArg	EventPredArg	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15554
85	http://premon.fbk.eu/ontology/vn#OrCompoundRestriction	704	\N	t	69	OrCompoundRestriction	OrCompoundRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	704
86	http://premon.fbk.eu/ontology/vn#VerbClass	1083	\N	t	69	VerbClass	VerbClass	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	69804
87	http://www.w3.org/2002/07/owl#FunctionalProperty	40	\N	t	7	FunctionalProperty	FunctionalProperty	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	119
88	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	29	\N	t	1	Property	Property	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
89	http://premon.fbk.eu/ontology/vn#AbsentAtomicRestriction	377	\N	t	69	AbsentAtomicRestriction	AbsentAtomicRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	377
90	http://premon.fbk.eu/ontology/vn#CompoundRestriction	860	\N	t	69	CompoundRestriction	CompoundRestriction	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	860
91	http://premon.fbk.eu/ontology/pb#Aspect	2	\N	t	71	Aspect	Aspect	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68
92	http://www.w3.org/2000/01/rdf-schema#Datatype	33	\N	t	2	Datatype	Datatype	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	47
93	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#String	2262922	\N	t	70	String	String	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1699254
94	http://premon.fbk.eu/ontology/nb#SemanticRole	76241	\N	t	77	SemanticRole	SemanticRole	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	116122
95	http://premon.fbk.eu/ontology/pb#Roleset	26093	\N	t	71	Roleset	Roleset	110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	201936
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	93	1	2	2251437	\N	0	\N	\N	1	1	2	f	2251437	\N	\N
2	81	1	2	1684784	\N	0	\N	\N	0	1	2	f	1684784	\N	\N
3	54	1	2	566653	\N	0	\N	\N	0	1	2	f	566653	\N	\N
4	7	1	2	566653	\N	0	\N	\N	0	1	2	f	566653	\N	\N
5	80	2	2	76724	\N	76724	\N	\N	1	1	2	f	0	\N	\N
6	64	2	2	76724	\N	76724	\N	\N	0	1	2	f	0	\N	\N
7	94	2	2	76241	\N	76241	\N	\N	0	1	2	f	0	\N	\N
8	80	3	2	1385	\N	1385	\N	\N	1	1	2	f	0	\N	\N
9	64	3	2	1385	\N	1385	\N	\N	0	1	2	f	0	\N	\N
10	8	3	2	1025	\N	1025	\N	\N	0	1	2	f	0	\N	\N
11	38	3	2	451	\N	451	\N	\N	0	1	2	f	0	\N	\N
12	82	3	2	450	\N	450	\N	\N	0	1	2	f	0	\N	\N
13	75	3	2	103	\N	103	\N	\N	0	1	2	f	0	\N	\N
14	43	3	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
15	80	3	1	1380	\N	1380	\N	\N	1	1	2	f	\N	\N	\N
16	64	3	1	1380	\N	1380	\N	\N	0	1	2	f	\N	\N	\N
17	8	3	1	1025	\N	1025	\N	\N	0	1	2	f	\N	\N	\N
18	82	3	1	472	\N	472	\N	\N	0	1	2	f	\N	\N	\N
19	38	3	1	427	\N	427	\N	\N	0	1	2	f	\N	\N	\N
20	75	3	1	112	\N	112	\N	\N	0	1	2	f	\N	\N	\N
21	43	3	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
22	60	4	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
23	15	4	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
24	87	4	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
25	16	4	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
26	60	4	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
27	87	4	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
28	16	4	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
29	35	5	2	609	\N	609	\N	\N	1	1	2	f	0	\N	\N
30	64	5	2	609	\N	609	\N	\N	0	1	2	f	0	\N	\N
31	41	5	2	609	\N	609	\N	\N	0	1	2	f	0	\N	\N
32	37	5	2	570	\N	570	\N	\N	0	1	2	f	0	\N	\N
33	35	5	1	619	\N	619	\N	\N	1	1	2	f	\N	\N	\N
34	64	5	1	619	\N	619	\N	\N	0	1	2	f	\N	\N	\N
35	41	5	1	619	\N	619	\N	\N	0	1	2	f	\N	\N	\N
36	37	5	1	570	\N	570	\N	\N	0	1	2	f	\N	\N	\N
37	71	6	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
38	39	8	2	2968	\N	0	\N	\N	1	1	2	f	2968	\N	\N
39	80	9	2	9761	\N	9761	\N	\N	1	1	2	f	0	\N	\N
40	64	9	2	9761	\N	9761	\N	\N	0	1	2	f	0	\N	\N
41	8	9	2	7387	\N	7387	\N	\N	0	1	2	f	0	\N	\N
42	38	9	2	3292	\N	3292	\N	\N	0	1	2	f	0	\N	\N
43	82	9	2	3164	\N	3164	\N	\N	0	1	2	f	0	\N	\N
44	75	9	2	904	\N	904	\N	\N	0	1	2	f	0	\N	\N
45	43	9	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
46	80	9	1	9821	\N	9821	\N	\N	1	1	2	f	\N	\N	\N
47	64	9	1	9821	\N	9821	\N	\N	0	1	2	f	\N	\N	\N
48	8	9	1	7387	\N	7387	\N	\N	0	1	2	f	\N	\N	\N
49	82	9	1	3357	\N	3357	\N	\N	0	1	2	f	\N	\N	\N
50	38	9	1	2916	\N	2916	\N	\N	0	1	2	f	\N	\N	\N
51	75	9	1	991	\N	991	\N	\N	0	1	2	f	\N	\N	\N
52	43	9	1	123	\N	123	\N	\N	0	1	2	f	\N	\N	\N
53	64	10	2	216421	\N	0	\N	\N	1	1	2	f	216421	\N	\N
54	66	10	2	284	\N	0	\N	\N	2	1	2	f	284	\N	\N
55	56	10	2	54	\N	0	\N	\N	3	1	2	f	54	\N	\N
56	80	10	2	127619	\N	0	\N	\N	0	1	2	f	127619	\N	\N
57	28	10	2	67218	\N	0	\N	\N	0	1	2	f	67218	\N	\N
58	65	10	2	50792	\N	0	\N	\N	0	1	2	f	50792	\N	\N
59	9	10	2	38869	\N	0	\N	\N	0	1	2	f	38869	\N	\N
60	35	10	2	38010	\N	0	\N	\N	0	1	2	f	38010	\N	\N
61	41	10	2	38010	\N	0	\N	\N	0	1	2	f	38010	\N	\N
62	8	10	2	32263	\N	0	\N	\N	0	1	2	f	32263	\N	\N
63	95	10	2	26082	\N	0	\N	\N	0	1	2	f	26082	\N	\N
64	94	10	2	14913	\N	0	\N	\N	0	1	2	f	14913	\N	\N
65	38	10	2	14222	\N	0	\N	\N	0	1	2	f	14222	\N	\N
66	82	10	2	9940	\N	0	\N	\N	0	1	2	f	9940	\N	\N
67	75	10	2	7774	\N	0	\N	\N	0	1	2	f	7774	\N	\N
68	18	10	2	5576	\N	0	\N	\N	0	1	2	f	5576	\N	\N
69	37	10	2	3442	\N	0	\N	\N	0	1	2	f	3442	\N	\N
70	43	10	2	327	\N	0	\N	\N	0	1	2	f	327	\N	\N
71	80	11	2	29096	\N	29096	\N	\N	1	1	2	f	0	\N	\N
72	74	11	2	24393	\N	24393	\N	\N	2	1	2	f	0	\N	\N
73	81	11	2	359	\N	359	\N	\N	3	1	2	f	0	\N	\N
74	64	11	2	29096	\N	29096	\N	\N	0	1	2	f	0	\N	\N
75	28	11	2	28984	\N	28984	\N	\N	0	1	2	f	0	\N	\N
76	93	11	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
77	6	11	1	91	\N	91	\N	\N	1	1	2	f	\N	\N	\N
78	71	12	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
79	59	12	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
80	71	12	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
81	59	12	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
82	22	13	2	110	\N	110	\N	\N	1	1	2	f	0	\N	\N
83	4	13	1	110	\N	110	\N	\N	1	1	2	f	\N	\N	\N
84	65	14	2	155880	\N	155880	\N	\N	1	1	2	f	0	\N	\N
85	64	14	2	155880	\N	155880	\N	\N	0	1	2	f	0	\N	\N
86	9	14	2	38695	\N	38695	\N	\N	0	1	2	f	0	\N	\N
87	6	14	1	157805	\N	157805	\N	\N	1	1	2	f	\N	\N	\N
88	58	15	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
89	16	16	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
90	60	16	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
91	60	16	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
92	59	17	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
93	58	18	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
94	80	19	2	70059	\N	0	\N	\N	1	1	2	f	70059	\N	\N
95	64	19	2	70059	\N	0	\N	\N	0	1	2	f	70059	\N	\N
96	28	19	2	67194	\N	0	\N	\N	0	1	2	f	67194	\N	\N
97	60	20	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
98	16	20	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
99	64	21	2	96418	\N	96418	\N	\N	1	1	2	f	0	\N	\N
100	65	21	2	50667	\N	50667	\N	\N	0	1	2	f	0	\N	\N
101	80	21	2	42214	\N	42214	\N	\N	0	1	2	f	0	\N	\N
102	9	21	2	38762	\N	38762	\N	\N	0	1	2	f	0	\N	\N
103	8	21	2	32312	\N	32312	\N	\N	0	1	2	f	0	\N	\N
104	38	21	2	14239	\N	14239	\N	\N	0	1	2	f	0	\N	\N
105	82	21	2	9963	\N	9963	\N	\N	0	1	2	f	0	\N	\N
106	75	21	2	7781	\N	7781	\N	\N	0	1	2	f	0	\N	\N
107	35	21	2	3537	\N	3537	\N	\N	0	1	2	f	0	\N	\N
108	41	21	2	3537	\N	3537	\N	\N	0	1	2	f	0	\N	\N
109	37	21	2	3445	\N	3445	\N	\N	0	1	2	f	0	\N	\N
110	43	21	2	329	\N	329	\N	\N	0	1	2	f	0	\N	\N
111	59	22	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
112	71	22	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
113	71	23	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
114	71	23	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
115	62	24	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
116	46	25	2	8224	\N	0	\N	\N	1	1	2	f	8224	\N	\N
117	39	26	2	1243	\N	0	\N	\N	1	1	2	f	1243	\N	\N
118	71	27	2	35	\N	35	\N	\N	1	1	2	f	0	\N	\N
119	62	28	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
120	62	28	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
121	27	29	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
122	35	30	2	5893	\N	5893	\N	\N	1	1	2	f	0	\N	\N
123	64	30	2	5893	\N	5893	\N	\N	0	1	2	f	0	\N	\N
124	41	30	2	5893	\N	5893	\N	\N	0	1	2	f	0	\N	\N
125	37	30	2	5673	\N	5673	\N	\N	0	1	2	f	0	\N	\N
126	35	30	1	5987	\N	5987	\N	\N	1	1	2	f	\N	\N	\N
127	64	30	1	5987	\N	5987	\N	\N	0	1	2	f	\N	\N	\N
128	41	30	1	5987	\N	5987	\N	\N	0	1	2	f	\N	\N	\N
129	37	30	1	5673	\N	5673	\N	\N	0	1	2	f	\N	\N	\N
130	93	31	2	3865239	\N	3865239	\N	\N	1	1	2	f	0	\N	\N
131	54	31	2	2012638	\N	2012638	\N	\N	0	1	2	f	0	\N	\N
132	7	31	2	2012638	\N	2012638	\N	\N	0	1	2	f	0	\N	\N
133	81	31	2	1852601	\N	1852601	\N	\N	0	1	2	f	0	\N	\N
134	74	31	1	3810635	\N	3810635	\N	\N	1	1	2	f	\N	\N	\N
135	35	31	1	59737	\N	59737	\N	\N	2	1	2	f	\N	\N	\N
136	64	31	1	59737	\N	59737	\N	\N	0	1	2	f	\N	\N	\N
137	41	31	1	59737	\N	59737	\N	\N	0	1	2	f	\N	\N	\N
138	95	31	1	45021	\N	45021	\N	\N	0	1	2	f	\N	\N	\N
139	18	31	1	9583	\N	9583	\N	\N	0	1	2	f	\N	\N	\N
140	22	32	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
141	91	32	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
142	58	33	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
143	74	34	2	2228	\N	2228	\N	\N	1	1	2	f	0	\N	\N
144	42	34	1	2228	\N	2228	\N	\N	1	1	2	f	\N	\N	\N
145	35	35	2	2252	\N	2252	\N	\N	1	1	2	f	0	\N	\N
146	64	35	2	2252	\N	2252	\N	\N	0	1	2	f	0	\N	\N
147	41	35	2	2252	\N	2252	\N	\N	0	1	2	f	0	\N	\N
148	37	35	2	2167	\N	2167	\N	\N	0	1	2	f	0	\N	\N
149	35	35	1	2310	\N	2310	\N	\N	1	1	2	f	\N	\N	\N
150	64	35	1	2310	\N	2310	\N	\N	0	1	2	f	\N	\N	\N
151	41	35	1	2310	\N	2310	\N	\N	0	1	2	f	\N	\N	\N
152	37	35	1	2167	\N	2167	\N	\N	0	1	2	f	\N	\N	\N
153	86	36	2	2968	\N	2968	\N	\N	1	1	2	f	0	\N	\N
154	64	36	2	2968	\N	2968	\N	\N	0	1	2	f	0	\N	\N
155	35	36	2	2968	\N	2968	\N	\N	0	1	2	f	0	\N	\N
156	41	36	2	2968	\N	2968	\N	\N	0	1	2	f	0	\N	\N
157	39	36	1	2968	\N	2968	\N	\N	1	1	2	f	\N	\N	\N
158	35	37	2	873713	\N	873713	\N	\N	1	1	2	f	0	\N	\N
159	64	37	2	873713	\N	873713	\N	\N	0	1	2	f	0	\N	\N
160	41	37	2	873713	\N	873713	\N	\N	0	1	2	f	0	\N	\N
161	95	37	2	693216	\N	693216	\N	\N	0	1	2	f	0	\N	\N
162	18	37	2	76241	\N	76241	\N	\N	0	1	2	f	0	\N	\N
163	37	37	2	32312	\N	32312	\N	\N	0	1	2	f	0	\N	\N
164	86	37	2	3165	\N	3165	\N	\N	0	1	2	f	0	\N	\N
165	80	37	1	818184	\N	818184	\N	\N	1	1	2	f	\N	\N	\N
166	64	37	1	818184	\N	818184	\N	\N	0	1	2	f	\N	\N	\N
167	28	37	1	693216	\N	693216	\N	\N	0	1	2	f	\N	\N	\N
168	94	37	1	76241	\N	76241	\N	\N	0	1	2	f	\N	\N	\N
169	8	37	1	32312	\N	32312	\N	\N	0	1	2	f	\N	\N	\N
170	38	37	1	14239	\N	14239	\N	\N	0	1	2	f	\N	\N	\N
171	82	37	1	9963	\N	9963	\N	\N	0	1	2	f	\N	\N	\N
172	75	37	1	7781	\N	7781	\N	\N	0	1	2	f	\N	\N	\N
173	48	37	1	3165	\N	3165	\N	\N	0	1	2	f	\N	\N	\N
174	43	37	1	329	\N	329	\N	\N	0	1	2	f	\N	\N	\N
175	80	38	2	2560	\N	2560	\N	\N	1	1	2	f	0	\N	\N
176	64	38	2	2560	\N	2560	\N	\N	0	1	2	f	0	\N	\N
177	8	38	2	1896	\N	1896	\N	\N	0	1	2	f	0	\N	\N
178	82	38	2	844	\N	844	\N	\N	0	1	2	f	0	\N	\N
179	38	38	2	840	\N	840	\N	\N	0	1	2	f	0	\N	\N
180	75	38	2	186	\N	186	\N	\N	0	1	2	f	0	\N	\N
181	43	38	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
182	80	38	1	2518	\N	2518	\N	\N	1	1	2	f	\N	\N	\N
183	64	38	1	2518	\N	2518	\N	\N	0	1	2	f	\N	\N	\N
184	8	38	1	1896	\N	1896	\N	\N	0	1	2	f	\N	\N	\N
185	82	38	1	828	\N	828	\N	\N	0	1	2	f	\N	\N	\N
186	38	38	1	796	\N	796	\N	\N	0	1	2	f	\N	\N	\N
187	75	38	1	195	\N	195	\N	\N	0	1	2	f	\N	\N	\N
188	43	38	1	77	\N	77	\N	\N	0	1	2	f	\N	\N	\N
189	35	39	2	2735	\N	2735	\N	\N	1	1	2	f	0	\N	\N
190	66	39	2	275	\N	275	\N	\N	2	1	2	f	0	\N	\N
191	64	39	2	2735	\N	2735	\N	\N	0	1	2	f	0	\N	\N
192	41	39	2	2735	\N	2735	\N	\N	0	1	2	f	0	\N	\N
193	37	39	2	2167	\N	2167	\N	\N	0	1	2	f	0	\N	\N
194	86	39	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
195	35	39	1	2793	\N	2793	\N	\N	1	1	2	f	\N	\N	\N
196	66	39	1	275	\N	275	\N	\N	2	1	2	f	\N	\N	\N
197	64	39	1	2793	\N	2793	\N	\N	0	1	2	f	\N	\N	\N
198	41	39	1	2793	\N	2793	\N	\N	0	1	2	f	\N	\N	\N
199	37	39	1	2167	\N	2167	\N	\N	0	1	2	f	\N	\N	\N
200	86	39	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
201	73	40	2	24034	\N	0	\N	\N	1	1	2	f	24034	\N	\N
202	64	41	2	61746	\N	61746	\N	\N	1	1	2	f	0	\N	\N
203	65	41	2	29410	\N	29410	\N	\N	0	1	2	f	0	\N	\N
204	80	41	2	26516	\N	26516	\N	\N	0	1	2	f	0	\N	\N
205	9	41	2	11887	\N	11887	\N	\N	0	1	2	f	0	\N	\N
206	8	41	2	9910	\N	9910	\N	\N	0	1	2	f	0	\N	\N
207	35	41	2	5820	\N	5820	\N	\N	0	1	2	f	0	\N	\N
208	41	41	2	5820	\N	5820	\N	\N	0	1	2	f	0	\N	\N
209	38	41	2	4298	\N	4298	\N	\N	0	1	2	f	0	\N	\N
210	82	41	2	3215	\N	3215	\N	\N	0	1	2	f	0	\N	\N
211	28	41	2	2865	\N	2865	\N	\N	0	1	2	f	0	\N	\N
212	75	41	2	2302	\N	2302	\N	\N	0	1	2	f	0	\N	\N
213	95	41	2	2222	\N	2222	\N	\N	0	1	2	f	0	\N	\N
214	18	41	2	596	\N	596	\N	\N	0	1	2	f	0	\N	\N
215	94	41	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
216	43	41	2	95	\N	95	\N	\N	0	1	2	f	0	\N	\N
217	37	41	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
218	86	43	2	1837	\N	1837	\N	\N	1	1	2	f	0	\N	\N
219	64	43	2	1837	\N	1837	\N	\N	0	1	2	f	0	\N	\N
220	35	43	2	1837	\N	1837	\N	\N	0	1	2	f	0	\N	\N
221	41	43	2	1837	\N	1837	\N	\N	0	1	2	f	0	\N	\N
222	48	43	1	1837	\N	1837	\N	\N	1	1	2	f	\N	\N	\N
223	64	43	1	1837	\N	1837	\N	\N	0	1	2	f	\N	\N	\N
224	80	43	1	1837	\N	1837	\N	\N	0	1	2	f	\N	\N	\N
225	81	44	2	1696269	\N	0	\N	\N	1	1	2	f	1696269	\N	\N
226	93	44	2	1696269	\N	0	\N	\N	0	1	2	f	1696269	\N	\N
227	32	45	2	25001	\N	0	\N	\N	1	1	2	f	25001	\N	\N
228	45	45	2	159	\N	0	\N	\N	2	1	2	f	159	\N	\N
229	70	45	2	13646	\N	0	\N	\N	0	1	2	f	13646	\N	\N
230	84	45	2	7777	\N	0	\N	\N	0	1	2	f	7777	\N	\N
231	49	45	2	1871	\N	0	\N	\N	0	1	2	f	1871	\N	\N
232	83	45	2	1707	\N	0	\N	\N	0	1	2	f	1707	\N	\N
233	3	45	2	159	\N	0	\N	\N	0	1	2	f	159	\N	\N
234	39	46	2	2985	\N	2985	\N	\N	1	1	2	f	0	\N	\N
235	54	46	1	2985	\N	2985	\N	\N	1	1	2	f	\N	\N	\N
236	93	46	1	2985	\N	2985	\N	\N	0	1	2	f	\N	\N	\N
237	7	46	1	2985	\N	2985	\N	\N	0	1	2	f	\N	\N	\N
238	55	47	2	2012638	\N	2012638	\N	\N	1	1	2	f	0	\N	\N
239	44	47	2	557988	\N	557988	\N	\N	2	1	2	f	0	\N	\N
240	46	47	2	25001	\N	25001	\N	\N	3	1	2	f	0	\N	\N
241	39	47	2	19731	\N	19731	\N	\N	4	1	2	f	0	\N	\N
242	36	47	2	2648	\N	2648	\N	\N	5	1	2	f	0	\N	\N
243	90	47	2	1753	\N	1753	\N	\N	6	1	2	f	0	\N	\N
244	11	47	2	267694	\N	267694	\N	\N	0	1	2	f	0	\N	\N
245	67	47	2	136762	\N	136762	\N	\N	0	1	2	f	0	\N	\N
246	76	47	2	118376	\N	118376	\N	\N	0	1	2	f	0	\N	\N
247	2	47	2	1753	\N	1753	\N	\N	0	1	2	f	0	\N	\N
248	79	47	2	1733	\N	1733	\N	\N	0	1	2	f	0	\N	\N
249	20	47	2	1693	\N	1693	\N	\N	0	1	2	f	0	\N	\N
250	69	47	2	1689	\N	1689	\N	\N	0	1	2	f	0	\N	\N
251	78	47	2	1689	\N	1689	\N	\N	0	1	2	f	0	\N	\N
252	12	47	2	1689	\N	1689	\N	\N	0	1	2	f	0	\N	\N
253	85	47	2	1441	\N	1441	\N	\N	0	1	2	f	0	\N	\N
254	1	47	2	401	\N	401	\N	\N	0	1	2	f	0	\N	\N
255	47	47	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
256	13	47	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
257	74	47	1	2012638	\N	2012638	\N	\N	1	1	2	f	\N	\N	\N
258	64	47	1	693150	\N	693150	\N	\N	2	1	2	f	\N	\N	\N
259	32	47	1	25001	\N	25001	\N	\N	3	1	2	f	\N	\N	\N
260	3	47	1	11507	\N	11507	\N	\N	4	1	2	f	\N	\N	\N
261	46	47	1	8224	\N	8224	\N	\N	5	1	2	f	\N	\N	\N
262	30	47	1	1753	\N	1753	\N	\N	6	1	2	f	\N	\N	\N
263	80	47	1	309197	\N	309197	\N	\N	0	1	2	f	\N	\N	\N
264	65	47	1	257373	\N	257373	\N	\N	0	1	2	f	\N	\N	\N
265	35	47	1	126580	\N	126580	\N	\N	0	1	2	f	\N	\N	\N
266	41	47	1	126580	\N	126580	\N	\N	0	1	2	f	\N	\N	\N
267	28	47	1	100334	\N	100334	\N	\N	0	1	2	f	\N	\N	\N
268	48	47	1	83761	\N	83761	\N	\N	0	1	2	f	\N	\N	\N
269	8	47	1	63156	\N	63156	\N	\N	0	1	2	f	\N	\N	\N
270	95	47	1	49930	\N	49930	\N	\N	0	1	2	f	\N	\N	\N
271	86	47	1	39066	\N	39066	\N	\N	0	1	2	f	\N	\N	\N
272	82	47	1	28895	\N	28895	\N	\N	0	1	2	f	\N	\N	\N
273	94	47	1	23091	\N	23091	\N	\N	0	1	2	f	\N	\N	\N
274	38	47	1	22391	\N	22391	\N	\N	0	1	2	f	\N	\N	\N
275	37	47	1	20600	\N	20600	\N	\N	0	1	2	f	\N	\N	\N
276	9	47	1	19578	\N	19578	\N	\N	0	1	2	f	\N	\N	\N
277	70	47	1	13646	\N	13646	\N	\N	0	1	2	f	\N	\N	\N
278	75	47	1	11271	\N	11271	\N	\N	0	1	2	f	\N	\N	\N
279	18	47	1	8780	\N	8780	\N	\N	0	1	2	f	\N	\N	\N
280	84	47	1	7777	\N	7777	\N	\N	0	1	2	f	\N	\N	\N
281	31	47	1	6745	\N	6745	\N	\N	0	1	2	f	\N	\N	\N
282	14	47	1	2968	\N	2968	\N	\N	0	1	2	f	\N	\N	\N
283	49	47	1	1871	\N	1871	\N	\N	0	1	2	f	\N	\N	\N
284	2	47	1	1753	\N	1753	\N	\N	0	1	2	f	\N	\N	\N
285	79	47	1	1733	\N	1733	\N	\N	0	1	2	f	\N	\N	\N
286	83	47	1	1707	\N	1707	\N	\N	0	1	2	f	\N	\N	\N
287	20	47	1	1693	\N	1693	\N	\N	0	1	2	f	\N	\N	\N
288	68	47	1	1612	\N	1612	\N	\N	0	1	2	f	\N	\N	\N
289	19	47	1	1554	\N	1554	\N	\N	0	1	2	f	\N	\N	\N
290	43	47	1	599	\N	599	\N	\N	0	1	2	f	\N	\N	\N
291	89	47	1	164	\N	164	\N	\N	0	1	2	f	\N	\N	\N
292	45	47	1	159	\N	159	\N	\N	0	1	2	f	\N	\N	\N
293	29	47	1	75	\N	75	\N	\N	0	1	2	f	\N	\N	\N
294	47	47	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
295	13	47	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
296	57	47	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
297	80	49	2	18888	\N	18888	\N	\N	1	1	2	f	0	\N	\N
298	64	49	2	18888	\N	18888	\N	\N	0	1	2	f	0	\N	\N
299	8	49	2	14590	\N	14590	\N	\N	0	1	2	f	0	\N	\N
300	38	49	2	7582	\N	7582	\N	\N	0	1	2	f	0	\N	\N
301	82	49	2	4729	\N	4729	\N	\N	0	1	2	f	0	\N	\N
302	75	49	2	2110	\N	2110	\N	\N	0	1	2	f	0	\N	\N
303	43	49	2	169	\N	169	\N	\N	0	1	2	f	0	\N	\N
304	80	49	1	18906	\N	18906	\N	\N	1	1	2	f	\N	\N	\N
305	64	49	1	18906	\N	18906	\N	\N	0	1	2	f	\N	\N	\N
306	8	49	1	14590	\N	14590	\N	\N	0	1	2	f	\N	\N	\N
307	38	49	1	6427	\N	6427	\N	\N	0	1	2	f	\N	\N	\N
308	82	49	1	4692	\N	4692	\N	\N	0	1	2	f	\N	\N	\N
309	75	49	1	2964	\N	2964	\N	\N	0	1	2	f	\N	\N	\N
310	43	49	1	507	\N	507	\N	\N	0	1	2	f	\N	\N	\N
311	6	50	2	18907	\N	18907	\N	\N	1	1	2	f	0	\N	\N
312	60	51	2	230	\N	230	\N	\N	1	1	2	f	0	\N	\N
313	87	51	2	50	\N	50	\N	\N	2	1	2	f	0	\N	\N
314	61	51	2	50	\N	50	\N	\N	3	1	2	f	0	\N	\N
315	88	51	2	3	\N	3	\N	\N	4	1	2	f	0	\N	\N
316	26	51	2	3	\N	3	\N	\N	5	1	2	f	0	\N	\N
317	16	51	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
318	25	51	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
319	15	51	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
320	60	51	1	228	\N	228	\N	\N	1	1	2	f	\N	\N	\N
321	61	51	1	50	\N	50	\N	\N	2	1	2	f	\N	\N	\N
322	26	51	1	7	\N	7	\N	\N	3	1	2	f	\N	\N	\N
323	87	51	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
324	25	51	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
325	15	51	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
326	16	51	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
327	88	51	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
328	80	52	2	2786	\N	2786	\N	\N	1	1	2	f	0	\N	\N
329	64	52	2	2786	\N	2786	\N	\N	0	1	2	f	0	\N	\N
330	8	52	2	2089	\N	2089	\N	\N	0	1	2	f	0	\N	\N
331	38	52	2	931	\N	931	\N	\N	0	1	2	f	0	\N	\N
332	82	52	2	889	\N	889	\N	\N	0	1	2	f	0	\N	\N
333	75	52	2	228	\N	228	\N	\N	0	1	2	f	0	\N	\N
334	43	52	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
335	80	52	1	2720	\N	2720	\N	\N	1	1	2	f	\N	\N	\N
336	64	52	1	2720	\N	2720	\N	\N	0	1	2	f	\N	\N	\N
337	8	52	1	2089	\N	2089	\N	\N	0	1	2	f	\N	\N	\N
338	38	52	1	957	\N	957	\N	\N	0	1	2	f	\N	\N	\N
339	82	52	1	914	\N	914	\N	\N	0	1	2	f	\N	\N	\N
340	75	52	1	210	\N	210	\N	\N	0	1	2	f	\N	\N	\N
341	43	52	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
342	64	53	2	96581	\N	0	\N	\N	1	1	2	f	96581	\N	\N
343	66	53	2	284	\N	0	\N	\N	2	1	2	f	284	\N	\N
344	65	53	2	50830	\N	0	\N	\N	0	1	2	f	50830	\N	\N
345	80	53	2	42214	\N	0	\N	\N	0	1	2	f	42214	\N	\N
346	9	53	2	38888	\N	0	\N	\N	0	1	2	f	38888	\N	\N
347	8	53	2	32312	\N	0	\N	\N	0	1	2	f	32312	\N	\N
348	38	53	2	14239	\N	0	\N	\N	0	1	2	f	14239	\N	\N
349	82	53	2	9963	\N	0	\N	\N	0	1	2	f	9963	\N	\N
350	75	53	2	7781	\N	0	\N	\N	0	1	2	f	7781	\N	\N
351	35	53	2	3537	\N	0	\N	\N	0	1	2	f	3537	\N	\N
352	41	53	2	3537	\N	0	\N	\N	0	1	2	f	3537	\N	\N
353	37	53	2	3445	\N	0	\N	\N	0	1	2	f	3445	\N	\N
354	43	53	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
355	71	54	1	99	\N	99	\N	\N	1	1	2	f	\N	\N	\N
356	69	54	1	82	\N	82	\N	\N	2	1	2	f	\N	\N	\N
357	60	54	1	33	\N	33	\N	\N	3	1	2	f	\N	\N	\N
358	59	54	1	12	\N	12	\N	\N	4	1	2	f	\N	\N	\N
359	63	54	1	8	\N	8	\N	\N	5	1	2	f	\N	\N	\N
360	87	54	1	8	\N	8	\N	\N	6	1	2	f	\N	\N	\N
361	34	54	1	4	\N	4	\N	\N	7	1	2	f	\N	\N	\N
362	50	54	1	4	\N	4	\N	\N	8	1	2	f	\N	\N	\N
363	24	54	1	3	\N	3	\N	\N	9	1	2	f	\N	\N	\N
364	4	54	1	2	\N	2	\N	\N	10	1	2	f	\N	\N	\N
365	23	54	1	2	\N	2	\N	\N	11	1	2	f	\N	\N	\N
366	91	54	1	2	\N	2	\N	\N	12	1	2	f	\N	\N	\N
367	12	54	1	43	\N	43	\N	\N	0	1	2	f	\N	\N	\N
368	77	54	1	39	\N	39	\N	\N	0	1	2	f	\N	\N	\N
369	78	54	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
370	53	54	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
371	15	54	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
372	61	54	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
373	16	54	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
374	35	55	2	176	\N	176	\N	\N	1	1	2	f	0	\N	\N
375	64	55	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
376	41	55	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
377	37	55	2	168	\N	168	\N	\N	0	1	2	f	0	\N	\N
378	35	55	1	174	\N	174	\N	\N	1	1	2	f	\N	\N	\N
379	64	55	1	174	\N	174	\N	\N	0	1	2	f	\N	\N	\N
380	41	55	1	174	\N	174	\N	\N	0	1	2	f	\N	\N	\N
381	37	55	1	168	\N	168	\N	\N	0	1	2	f	\N	\N	\N
382	46	56	2	8224	\N	8224	\N	\N	1	1	2	f	0	\N	\N
383	39	56	2	5936	\N	5936	\N	\N	2	1	2	f	0	\N	\N
384	32	56	1	8224	\N	8224	\N	\N	1	1	2	f	\N	\N	\N
385	46	56	1	2968	\N	2968	\N	\N	2	1	2	f	\N	\N	\N
386	3	56	1	2968	\N	2968	\N	\N	3	1	2	f	\N	\N	\N
387	84	56	1	6397	\N	6397	\N	\N	0	1	2	f	\N	\N	\N
388	31	56	1	2903	\N	2903	\N	\N	0	1	2	f	\N	\N	\N
389	70	56	1	1781	\N	1781	\N	\N	0	1	2	f	\N	\N	\N
390	45	56	1	42	\N	42	\N	\N	0	1	2	f	\N	\N	\N
391	49	56	1	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
392	19	56	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
393	83	56	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
394	72	57	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
395	17	57	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
396	5	58	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
397	40	58	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
398	71	58	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
399	39	59	2	2968	\N	0	\N	\N	1	1	2	f	2968	\N	\N
400	65	60	2	50582	\N	50582	\N	\N	1	1	2	f	0	\N	\N
401	6	60	2	27118	\N	27118	\N	\N	2	1	2	f	0	\N	\N
402	64	60	2	50582	\N	50582	\N	\N	0	1	2	f	0	\N	\N
403	9	60	2	38695	\N	38695	\N	\N	0	1	2	f	0	\N	\N
404	62	61	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
405	22	62	2	73	\N	73	\N	\N	1	1	2	f	0	\N	\N
406	23	62	1	73	\N	73	\N	\N	1	1	2	f	\N	\N	\N
407	22	63	2	121	\N	121	\N	\N	1	1	2	f	0	\N	\N
408	50	63	1	121	\N	121	\N	\N	1	1	2	f	\N	\N	\N
409	32	64	2	16777	\N	16777	\N	\N	1	1	2	f	0	\N	\N
410	3	64	2	8539	\N	8539	\N	\N	2	1	2	f	0	\N	\N
411	46	64	2	5256	\N	5256	\N	\N	3	1	2	f	0	\N	\N
412	70	64	2	8440	\N	8440	\N	\N	0	1	2	f	0	\N	\N
413	84	64	2	6397	\N	6397	\N	\N	0	1	2	f	0	\N	\N
414	31	64	2	4154	\N	4154	\N	\N	0	1	2	f	0	\N	\N
415	14	64	2	2702	\N	2702	\N	\N	0	1	2	f	0	\N	\N
416	83	64	2	1699	\N	1699	\N	\N	0	1	2	f	0	\N	\N
417	19	64	2	1551	\N	1551	\N	\N	0	1	2	f	0	\N	\N
418	49	64	2	241	\N	241	\N	\N	0	1	2	f	0	\N	\N
419	45	64	2	109	\N	109	\N	\N	0	1	2	f	0	\N	\N
420	29	64	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
421	57	64	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
422	32	64	1	16777	\N	16777	\N	\N	1	1	2	f	\N	\N	\N
423	3	64	1	8539	\N	8539	\N	\N	2	1	2	f	\N	\N	\N
424	46	64	1	5256	\N	5256	\N	\N	3	1	2	f	\N	\N	\N
425	70	64	1	11865	\N	11865	\N	\N	0	1	2	f	\N	\N	\N
426	31	64	1	3842	\N	3842	\N	\N	0	1	2	f	\N	\N	\N
427	14	64	1	2968	\N	2968	\N	\N	0	1	2	f	\N	\N	\N
428	49	64	1	1833	\N	1833	\N	\N	0	1	2	f	\N	\N	\N
429	83	64	1	1699	\N	1699	\N	\N	0	1	2	f	\N	\N	\N
430	19	64	1	1531	\N	1531	\N	\N	0	1	2	f	\N	\N	\N
431	84	64	1	1380	\N	1380	\N	\N	0	1	2	f	\N	\N	\N
432	45	64	1	117	\N	117	\N	\N	0	1	2	f	\N	\N	\N
433	29	64	1	75	\N	75	\N	\N	0	1	2	f	\N	\N	\N
434	57	64	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
435	59	65	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
436	81	66	2	1696269	\N	0	\N	\N	1	1	2	f	1696269	\N	\N
437	93	66	2	1696269	\N	0	\N	\N	0	1	2	f	1696269	\N	\N
438	22	68	2	99	\N	99	\N	\N	1	1	2	f	0	\N	\N
439	24	68	1	99	\N	99	\N	\N	1	1	2	f	\N	\N	\N
440	64	69	2	132145	\N	0	\N	\N	1	1	2	f	132145	\N	\N
441	6	69	2	27055	\N	0	\N	\N	2	1	2	f	27055	\N	\N
442	33	69	2	561	\N	0	\N	\N	3	1	2	f	561	\N	\N
443	66	69	2	284	\N	0	\N	\N	4	1	2	f	284	\N	\N
444	56	69	2	54	\N	0	\N	\N	5	1	2	f	54	\N	\N
445	88	69	2	23	\N	0	\N	\N	6	1	2	f	23	\N	\N
446	71	69	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
447	65	69	2	50824	\N	0	\N	\N	0	1	2	f	50824	\N	\N
448	80	69	2	42214	\N	0	\N	\N	0	1	2	f	42214	\N	\N
449	35	69	2	39107	\N	0	\N	\N	0	1	2	f	39107	\N	\N
450	41	69	2	39107	\N	0	\N	\N	0	1	2	f	39107	\N	\N
451	9	69	2	38885	\N	0	\N	\N	0	1	2	f	38885	\N	\N
452	8	69	2	32312	\N	0	\N	\N	0	1	2	f	32312	\N	\N
453	95	69	2	26093	\N	0	\N	\N	0	1	2	f	26093	\N	\N
454	38	69	2	14239	\N	0	\N	\N	0	1	2	f	14239	\N	\N
455	82	69	2	9963	\N	0	\N	\N	0	1	2	f	9963	\N	\N
456	75	69	2	7781	\N	0	\N	\N	0	1	2	f	7781	\N	\N
457	18	69	2	5576	\N	0	\N	\N	0	1	2	f	5576	\N	\N
458	37	69	2	3445	\N	0	\N	\N	0	1	2	f	3445	\N	\N
459	86	69	2	1083	\N	0	\N	\N	0	1	2	f	1083	\N	\N
460	43	69	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
461	51	69	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
462	26	69	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
463	52	69	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
464	60	69	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
465	59	70	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
466	10	71	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
467	27	71	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
468	59	72	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
469	35	73	2	366	\N	366	\N	\N	1	1	2	f	0	\N	\N
470	64	73	2	366	\N	366	\N	\N	0	1	2	f	0	\N	\N
471	41	73	2	366	\N	366	\N	\N	0	1	2	f	0	\N	\N
472	37	73	2	345	\N	345	\N	\N	0	1	2	f	0	\N	\N
473	35	73	1	347	\N	347	\N	\N	1	1	2	f	\N	\N	\N
474	64	73	1	347	\N	347	\N	\N	0	1	2	f	\N	\N	\N
475	41	73	1	347	\N	347	\N	\N	0	1	2	f	\N	\N	\N
476	37	73	1	345	\N	345	\N	\N	0	1	2	f	\N	\N	\N
477	54	74	2	18580	\N	18580	\N	\N	1	1	2	f	0	\N	\N
478	93	74	2	18580	\N	18580	\N	\N	0	1	2	f	0	\N	\N
479	7	74	2	18580	\N	18580	\N	\N	0	1	2	f	0	\N	\N
480	22	74	1	18580	\N	18580	\N	\N	1	1	2	f	\N	\N	\N
481	54	75	2	8894	\N	0	\N	\N	1	1	2	f	8894	\N	\N
482	27	75	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
483	93	75	2	8894	\N	0	\N	\N	0	1	2	f	8894	\N	\N
484	7	75	2	8894	\N	0	\N	\N	0	1	2	f	8894	\N	\N
485	27	75	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
486	32	76	2	25001	\N	0	\N	\N	1	1	2	f	25001	\N	\N
487	70	76	2	13646	\N	0	\N	\N	0	1	2	f	13646	\N	\N
488	84	76	2	7777	\N	0	\N	\N	0	1	2	f	7777	\N	\N
489	49	76	2	1871	\N	0	\N	\N	0	1	2	f	1871	\N	\N
490	83	76	2	1707	\N	0	\N	\N	0	1	2	f	1707	\N	\N
491	59	77	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
492	71	77	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
493	59	78	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
494	59	79	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
495	80	80	2	423	\N	423	\N	\N	1	1	2	f	0	\N	\N
496	64	80	2	423	\N	423	\N	\N	0	1	2	f	0	\N	\N
497	8	80	2	309	\N	309	\N	\N	0	1	2	f	0	\N	\N
498	82	80	2	300	\N	300	\N	\N	0	1	2	f	0	\N	\N
499	38	80	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
500	75	80	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
501	80	80	1	423	\N	423	\N	\N	1	1	2	f	\N	\N	\N
502	64	80	1	423	\N	423	\N	\N	0	1	2	f	\N	\N	\N
503	8	80	1	309	\N	309	\N	\N	0	1	2	f	\N	\N	\N
504	82	80	1	297	\N	297	\N	\N	0	1	2	f	\N	\N	\N
505	38	80	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
506	43	80	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
507	64	81	2	21918	\N	21918	\N	\N	1	1	2	f	0	\N	\N
508	80	81	2	17805	\N	17805	\N	\N	0	1	2	f	0	\N	\N
509	8	81	2	13451	\N	13451	\N	\N	0	1	2	f	0	\N	\N
510	38	81	2	8784	\N	8784	\N	\N	0	1	2	f	0	\N	\N
511	65	81	2	3518	\N	3518	\N	\N	0	1	2	f	0	\N	\N
512	82	81	2	3109	\N	3109	\N	\N	0	1	2	f	0	\N	\N
513	9	81	2	2838	\N	2838	\N	\N	0	1	2	f	0	\N	\N
514	75	81	2	1493	\N	1493	\N	\N	0	1	2	f	0	\N	\N
515	35	81	2	595	\N	595	\N	\N	0	1	2	f	0	\N	\N
516	41	81	2	595	\N	595	\N	\N	0	1	2	f	0	\N	\N
517	37	81	2	591	\N	591	\N	\N	0	1	2	f	0	\N	\N
518	43	81	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
519	66	81	1	16880	\N	16880	\N	\N	1	1	2	f	\N	\N	\N
520	54	82	2	566653	\N	0	\N	\N	1	1	2	f	566653	\N	\N
521	93	82	2	566653	\N	0	\N	\N	0	1	2	f	566653	\N	\N
522	7	82	2	566653	\N	0	\N	\N	0	1	2	f	566653	\N	\N
523	65	83	2	50649	\N	50649	\N	\N	1	1	2	f	0	\N	\N
524	64	83	2	50649	\N	50649	\N	\N	0	1	2	f	0	\N	\N
525	9	83	2	38747	\N	38747	\N	\N	0	1	2	f	0	\N	\N
526	56	83	1	38747	\N	38747	\N	\N	1	1	2	f	\N	\N	\N
527	44	84	2	271985	\N	271985	\N	\N	1	1	2	f	0	\N	\N
528	76	84	2	138749	\N	138749	\N	\N	0	1	2	f	0	\N	\N
529	67	84	2	133236	\N	133236	\N	\N	0	1	2	f	0	\N	\N
530	11	84	1	261780	\N	261780	\N	\N	1	1	2	f	\N	\N	\N
531	44	84	1	261780	\N	261780	\N	\N	0	1	2	f	\N	\N	\N
532	71	85	2	439	\N	439	\N	\N	1	1	2	f	0	\N	\N
533	59	85	2	36	\N	36	\N	\N	2	1	2	f	0	\N	\N
534	51	85	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
535	71	85	1	299	\N	299	\N	\N	1	1	2	f	\N	\N	\N
536	59	85	1	175	\N	175	\N	\N	2	1	2	f	\N	\N	\N
537	51	85	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
538	72	86	2	24032	\N	24032	\N	\N	1	1	2	f	0	\N	\N
539	17	86	2	24032	\N	24032	\N	\N	0	1	2	f	0	\N	\N
540	6	86	1	27053	\N	27053	\N	\N	1	1	2	f	\N	\N	\N
541	74	87	2	2608632	\N	2608632	\N	\N	1	1	2	f	0	\N	\N
542	32	87	2	19016	\N	19016	\N	\N	2	1	2	f	0	\N	\N
543	3	87	2	8321	\N	8321	\N	\N	3	1	2	f	0	\N	\N
544	46	87	2	8224	\N	8224	\N	\N	4	1	2	f	0	\N	\N
545	30	87	2	4339	\N	4339	\N	\N	5	1	2	f	0	\N	\N
546	70	87	2	13404	\N	13404	\N	\N	0	1	2	f	0	\N	\N
547	31	87	2	6745	\N	6745	\N	\N	0	1	2	f	0	\N	\N
548	84	87	2	5612	\N	5612	\N	\N	0	1	2	f	0	\N	\N
549	2	87	2	4339	\N	4339	\N	\N	0	1	2	f	0	\N	\N
550	68	87	2	3985	\N	3985	\N	\N	0	1	2	f	0	\N	\N
551	79	87	2	3213	\N	3213	\N	\N	0	1	2	f	0	\N	\N
552	20	87	2	2900	\N	2900	\N	\N	0	1	2	f	0	\N	\N
553	19	87	2	1576	\N	1576	\N	\N	0	1	2	f	0	\N	\N
554	13	87	2	1126	\N	1126	\N	\N	0	1	2	f	0	\N	\N
555	69	87	2	1081	\N	1081	\N	\N	0	1	2	f	0	\N	\N
556	78	87	2	1081	\N	1081	\N	\N	0	1	2	f	0	\N	\N
557	12	87	2	1081	\N	1081	\N	\N	0	1	2	f	0	\N	\N
558	89	87	2	400	\N	400	\N	\N	0	1	2	f	0	\N	\N
559	47	87	2	313	\N	313	\N	\N	0	1	2	f	0	\N	\N
560	64	87	1	3251939	\N	3251939	\N	\N	1	1	2	f	\N	\N	\N
561	33	87	1	14584	\N	14584	\N	\N	2	1	2	f	\N	\N	\N
562	63	87	1	5612	\N	5612	\N	\N	3	1	2	f	\N	\N	\N
563	69	87	1	4361	\N	4361	\N	\N	4	1	2	f	\N	\N	\N
564	6	87	1	1576	\N	1576	\N	\N	5	1	2	f	\N	\N	\N
565	80	87	1	1823770	\N	1823770	\N	\N	0	1	2	f	\N	\N	\N
566	8	87	1	1268924	\N	1268924	\N	\N	0	1	2	f	\N	\N	\N
567	82	87	1	1018953	\N	1018953	\N	\N	0	1	2	f	\N	\N	\N
568	65	87	1	754281	\N	754281	\N	\N	0	1	2	f	\N	\N	\N
569	41	87	1	647113	\N	647113	\N	\N	0	1	2	f	\N	\N	\N
570	35	87	1	647113	\N	647113	\N	\N	0	1	2	f	\N	\N	\N
571	9	87	1	552963	\N	552963	\N	\N	0	1	2	f	\N	\N	\N
572	37	87	1	552961	\N	552961	\N	\N	0	1	2	f	\N	\N	\N
573	38	87	1	183582	\N	183582	\N	\N	0	1	2	f	\N	\N	\N
574	28	87	1	107933	\N	107933	\N	\N	0	1	2	f	\N	\N	\N
575	75	87	1	48479	\N	48479	\N	\N	0	1	2	f	\N	\N	\N
576	95	87	1	45032	\N	45032	\N	\N	0	1	2	f	\N	\N	\N
577	21	87	1	26775	\N	26775	\N	\N	0	1	2	f	\N	\N	\N
578	43	87	1	17910	\N	17910	\N	\N	0	1	2	f	\N	\N	\N
579	94	87	1	16790	\N	16790	\N	\N	0	1	2	f	\N	\N	\N
580	48	87	1	13448	\N	13448	\N	\N	0	1	2	f	\N	\N	\N
581	18	87	1	9583	\N	9583	\N	\N	0	1	2	f	\N	\N	\N
582	12	87	1	3235	\N	3235	\N	\N	0	1	2	f	\N	\N	\N
583	86	87	1	2985	\N	2985	\N	\N	0	1	2	f	\N	\N	\N
584	78	87	1	2922	\N	2922	\N	\N	0	1	2	f	\N	\N	\N
585	77	87	1	1126	\N	1126	\N	\N	0	1	2	f	\N	\N	\N
586	53	87	1	313	\N	313	\N	\N	0	1	2	f	\N	\N	\N
587	66	88	2	275	\N	275	\N	\N	1	1	2	f	0	\N	\N
588	66	88	1	275	\N	275	\N	\N	1	1	2	f	\N	\N	\N
589	59	89	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
590	65	90	2	5314	\N	5314	\N	\N	1	1	2	f	0	\N	\N
591	64	90	2	5314	\N	5314	\N	\N	0	1	2	f	0	\N	\N
592	9	90	2	4167	\N	4167	\N	\N	0	1	2	f	0	\N	\N
593	80	90	1	5463	\N	5463	\N	\N	1	1	2	f	\N	\N	\N
594	64	90	1	5463	\N	5463	\N	\N	0	1	2	f	\N	\N	\N
595	8	90	1	4167	\N	4167	\N	\N	0	1	2	f	\N	\N	\N
596	82	90	1	4082	\N	4082	\N	\N	0	1	2	f	\N	\N	\N
597	38	90	1	53	\N	53	\N	\N	0	1	2	f	\N	\N	\N
598	43	90	1	28	\N	28	\N	\N	0	1	2	f	\N	\N	\N
599	75	90	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
600	60	91	2	517	\N	517	\N	\N	1	1	2	f	0	\N	\N
601	87	91	2	106	\N	106	\N	\N	2	1	2	f	0	\N	\N
602	61	91	2	40	\N	40	\N	\N	3	1	2	f	0	\N	\N
603	88	91	2	20	\N	20	\N	\N	4	1	2	f	0	\N	\N
604	16	91	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
605	25	91	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
606	15	91	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
607	52	91	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
608	26	91	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
609	71	91	1	399	\N	399	\N	\N	1	1	2	f	\N	\N	\N
610	59	91	1	121	\N	121	\N	\N	2	1	2	f	\N	\N	\N
611	92	91	1	42	\N	42	\N	\N	3	1	2	f	\N	\N	\N
612	51	91	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
613	65	92	2	155880	\N	155880	\N	\N	1	1	2	f	0	\N	\N
614	64	92	2	155880	\N	155880	\N	\N	0	1	2	f	0	\N	\N
615	9	92	2	38695	\N	38695	\N	\N	0	1	2	f	0	\N	\N
616	41	92	1	148129	\N	148129	\N	\N	1	1	2	f	\N	\N	\N
617	64	92	1	148129	\N	148129	\N	\N	0	1	2	f	\N	\N	\N
618	35	92	1	92841	\N	92841	\N	\N	0	1	2	f	\N	\N	\N
619	37	92	1	38695	\N	38695	\N	\N	0	1	2	f	\N	\N	\N
620	95	92	1	30980	\N	30980	\N	\N	0	1	2	f	\N	\N	\N
621	86	92	1	13152	\N	13152	\N	\N	0	1	2	f	\N	\N	\N
622	18	92	1	5576	\N	5576	\N	\N	0	1	2	f	\N	\N	\N
623	6	93	2	157797	\N	157797	\N	\N	1	1	2	f	0	\N	\N
624	41	93	1	148122	\N	148122	\N	\N	1	1	2	f	\N	\N	\N
625	64	93	1	148122	\N	148122	\N	\N	0	1	2	f	\N	\N	\N
626	35	93	1	92834	\N	92834	\N	\N	0	1	2	f	\N	\N	\N
627	37	93	1	38695	\N	38695	\N	\N	0	1	2	f	\N	\N	\N
628	95	93	1	30973	\N	30973	\N	\N	0	1	2	f	\N	\N	\N
629	86	93	1	13152	\N	13152	\N	\N	0	1	2	f	\N	\N	\N
630	18	93	1	5576	\N	5576	\N	\N	0	1	2	f	\N	\N	\N
631	71	94	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
632	60	95	2	157	\N	157	\N	\N	1	1	2	f	0	\N	\N
633	61	95	2	47	\N	47	\N	\N	2	1	2	f	0	\N	\N
634	87	95	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
635	25	95	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
636	15	95	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
637	16	95	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
638	26	95	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
639	88	95	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
640	60	95	1	157	\N	157	\N	\N	1	1	2	f	\N	\N	\N
641	61	95	1	47	\N	47	\N	\N	2	1	2	f	\N	\N	\N
642	87	95	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
643	25	95	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
644	15	95	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
645	16	95	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
646	26	95	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
647	88	95	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
648	80	96	2	2580	\N	2580	\N	\N	1	1	2	f	0	\N	\N
649	64	96	2	2580	\N	2580	\N	\N	0	1	2	f	0	\N	\N
650	8	96	2	2110	\N	2110	\N	\N	0	1	2	f	0	\N	\N
651	38	96	2	955	\N	955	\N	\N	0	1	2	f	0	\N	\N
652	82	96	2	759	\N	759	\N	\N	0	1	2	f	0	\N	\N
653	75	96	2	375	\N	375	\N	\N	0	1	2	f	0	\N	\N
654	43	96	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
655	80	96	1	2580	\N	2580	\N	\N	1	1	2	f	\N	\N	\N
656	64	96	1	2580	\N	2580	\N	\N	0	1	2	f	\N	\N	\N
657	8	96	1	2110	\N	2110	\N	\N	0	1	2	f	\N	\N	\N
658	38	96	1	955	\N	955	\N	\N	0	1	2	f	\N	\N	\N
659	82	96	1	759	\N	759	\N	\N	0	1	2	f	\N	\N	\N
660	75	96	1	375	\N	375	\N	\N	0	1	2	f	\N	\N	\N
661	43	96	1	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
662	35	97	2	56	\N	56	\N	\N	1	1	2	f	0	\N	\N
663	64	97	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
664	41	97	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
665	37	97	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
666	35	97	1	57	\N	57	\N	\N	1	1	2	f	\N	\N	\N
667	64	97	1	57	\N	57	\N	\N	0	1	2	f	\N	\N	\N
668	41	97	1	57	\N	57	\N	\N	0	1	2	f	\N	\N	\N
669	37	97	1	54	\N	54	\N	\N	0	1	2	f	\N	\N	\N
670	35	98	2	1140	\N	1140	\N	\N	1	1	2	f	0	\N	\N
671	64	98	2	1140	\N	1140	\N	\N	0	1	2	f	0	\N	\N
672	41	98	2	1140	\N	1140	\N	\N	0	1	2	f	0	\N	\N
673	37	98	2	1096	\N	1096	\N	\N	0	1	2	f	0	\N	\N
674	36	98	1	1096	\N	1096	\N	\N	1	1	2	f	\N	\N	\N
675	6	99	2	27053	\N	0	\N	\N	1	1	2	f	27053	\N	\N
676	72	99	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
677	17	99	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
678	86	100	2	4550	\N	4550	\N	\N	1	1	2	f	0	\N	\N
679	64	100	2	4550	\N	4550	\N	\N	0	1	2	f	0	\N	\N
680	35	100	2	4550	\N	4550	\N	\N	0	1	2	f	0	\N	\N
681	41	100	2	4550	\N	4550	\N	\N	0	1	2	f	0	\N	\N
682	39	100	1	4550	\N	4550	\N	\N	1	1	2	f	\N	\N	\N
683	35	101	2	6376	\N	6376	\N	\N	1	1	2	f	0	\N	\N
684	64	101	2	6376	\N	6376	\N	\N	0	1	2	f	0	\N	\N
685	41	101	2	6376	\N	6376	\N	\N	0	1	2	f	0	\N	\N
686	37	101	2	5673	\N	5673	\N	\N	0	1	2	f	0	\N	\N
687	86	101	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
688	35	101	1	6470	\N	6470	\N	\N	1	1	2	f	\N	\N	\N
689	64	101	1	6470	\N	6470	\N	\N	0	1	2	f	\N	\N	\N
690	41	101	1	6470	\N	6470	\N	\N	0	1	2	f	\N	\N	\N
691	37	101	1	5673	\N	5673	\N	\N	0	1	2	f	\N	\N	\N
692	86	101	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
693	41	102	2	148122	\N	148122	\N	\N	1	1	2	f	0	\N	\N
694	64	102	2	148122	\N	148122	\N	\N	0	1	2	f	0	\N	\N
695	35	102	2	92834	\N	92834	\N	\N	0	1	2	f	0	\N	\N
696	37	102	2	38695	\N	38695	\N	\N	0	1	2	f	0	\N	\N
697	95	102	2	30973	\N	30973	\N	\N	0	1	2	f	0	\N	\N
698	86	102	2	13152	\N	13152	\N	\N	0	1	2	f	0	\N	\N
699	18	102	2	5576	\N	5576	\N	\N	0	1	2	f	0	\N	\N
700	6	102	1	157797	\N	157797	\N	\N	1	1	2	f	\N	\N	\N
701	8	103	2	38	\N	38	\N	\N	1	1	2	f	0	\N	\N
702	64	103	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
703	80	103	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
704	38	103	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
705	75	103	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
706	82	103	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
707	8	103	1	38	\N	38	\N	\N	1	1	2	f	\N	\N	\N
708	64	103	1	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
709	80	103	1	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
710	38	103	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
711	75	103	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
712	82	103	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
713	62	104	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
714	80	105	2	47350	\N	47350	\N	\N	1	1	2	f	0	\N	\N
715	64	105	2	47350	\N	47350	\N	\N	0	1	2	f	0	\N	\N
716	8	105	2	36184	\N	36184	\N	\N	0	1	2	f	0	\N	\N
717	38	105	2	16042	\N	16042	\N	\N	0	1	2	f	0	\N	\N
718	82	105	2	14958	\N	14958	\N	\N	0	1	2	f	0	\N	\N
719	75	105	2	4706	\N	4706	\N	\N	0	1	2	f	0	\N	\N
720	43	105	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
721	80	105	1	47346	\N	47346	\N	\N	1	1	2	f	\N	\N	\N
722	64	105	1	47346	\N	47346	\N	\N	0	1	2	f	\N	\N	\N
723	8	105	1	36184	\N	36184	\N	\N	0	1	2	f	\N	\N	\N
724	82	105	1	15171	\N	15171	\N	\N	0	1	2	f	\N	\N	\N
725	38	105	1	14365	\N	14365	\N	\N	0	1	2	f	\N	\N	\N
726	75	105	1	5704	\N	5704	\N	\N	0	1	2	f	\N	\N	\N
727	43	105	1	944	\N	944	\N	\N	0	1	2	f	\N	\N	\N
728	80	106	2	282	\N	282	\N	\N	1	1	2	f	0	\N	\N
729	64	106	2	282	\N	282	\N	\N	0	1	2	f	0	\N	\N
730	8	106	2	213	\N	213	\N	\N	0	1	2	f	0	\N	\N
731	82	106	2	106	\N	106	\N	\N	0	1	2	f	0	\N	\N
732	38	106	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
733	75	106	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
734	43	106	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
735	80	106	1	284	\N	284	\N	\N	1	1	2	f	\N	\N	\N
736	64	106	1	284	\N	284	\N	\N	0	1	2	f	\N	\N	\N
737	8	106	1	213	\N	213	\N	\N	0	1	2	f	\N	\N	\N
738	82	106	1	96	\N	96	\N	\N	0	1	2	f	\N	\N	\N
739	38	106	1	64	\N	64	\N	\N	0	1	2	f	\N	\N	\N
740	75	106	1	41	\N	41	\N	\N	0	1	2	f	\N	\N	\N
741	43	106	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
742	64	107	2	92748	\N	92748	\N	\N	1	1	2	f	0	\N	\N
743	65	107	2	52781	\N	52781	\N	\N	0	1	2	f	0	\N	\N
744	35	107	2	39967	\N	39967	\N	\N	0	1	2	f	0	\N	\N
745	41	107	2	39967	\N	39967	\N	\N	0	1	2	f	0	\N	\N
746	95	107	2	30973	\N	30973	\N	\N	0	1	2	f	0	\N	\N
747	18	107	2	5576	\N	5576	\N	\N	0	1	2	f	0	\N	\N
748	86	107	2	600	\N	600	\N	\N	0	1	2	f	0	\N	\N
749	35	108	2	403	\N	403	\N	\N	1	1	2	f	0	\N	\N
750	64	108	2	403	\N	403	\N	\N	0	1	2	f	0	\N	\N
751	41	108	2	403	\N	403	\N	\N	0	1	2	f	0	\N	\N
752	37	108	2	381	\N	381	\N	\N	0	1	2	f	0	\N	\N
753	35	108	1	392	\N	392	\N	\N	1	1	2	f	\N	\N	\N
754	64	108	1	392	\N	392	\N	\N	0	1	2	f	\N	\N	\N
755	41	108	1	392	\N	392	\N	\N	0	1	2	f	\N	\N	\N
756	37	108	1	381	\N	381	\N	\N	0	1	2	f	\N	\N	\N
757	80	109	2	1438	\N	1438	\N	\N	1	1	2	f	0	\N	\N
758	64	109	2	1438	\N	1438	\N	\N	0	1	2	f	0	\N	\N
759	8	109	2	1094	\N	1094	\N	\N	0	1	2	f	0	\N	\N
760	38	109	2	578	\N	578	\N	\N	0	1	2	f	0	\N	\N
761	82	109	2	337	\N	337	\N	\N	0	1	2	f	0	\N	\N
762	75	109	2	173	\N	173	\N	\N	0	1	2	f	0	\N	\N
763	43	109	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
764	80	109	1	1433	\N	1433	\N	\N	1	1	2	f	\N	\N	\N
765	64	109	1	1433	\N	1433	\N	\N	0	1	2	f	\N	\N	\N
766	8	109	1	1094	\N	1094	\N	\N	0	1	2	f	\N	\N	\N
767	38	109	1	570	\N	570	\N	\N	0	1	2	f	\N	\N	\N
768	82	109	1	332	\N	332	\N	\N	0	1	2	f	\N	\N	\N
769	75	109	1	169	\N	169	\N	\N	0	1	2	f	\N	\N	\N
770	43	109	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
771	93	110	2	5092497	\N	5092497	\N	\N	1	1	2	f	0	\N	\N
772	64	110	2	3249349	\N	3249349	\N	\N	2	1	2	f	0	\N	\N
773	74	110	2	2012638	\N	2012638	\N	\N	3	1	2	f	0	\N	\N
774	55	110	2	614134	\N	614134	\N	\N	4	1	2	f	0	\N	\N
775	44	110	2	491227	\N	491227	\N	\N	5	1	2	f	0	\N	\N
776	32	110	2	50002	\N	50002	\N	\N	6	1	2	f	0	\N	\N
777	6	110	2	33095	\N	33095	\N	\N	7	1	2	f	0	\N	\N
778	2	110	2	30383	\N	30383	\N	\N	8	1	2	f	0	\N	\N
779	73	110	2	24032	\N	24032	\N	\N	9	1	2	f	0	\N	\N
780	3	110	2	23014	\N	23014	\N	\N	10	1	2	f	0	\N	\N
781	69	110	2	15646	\N	15646	\N	\N	11	1	2	f	0	\N	\N
782	46	110	2	8224	\N	8224	\N	\N	12	1	2	f	0	\N	\N
783	39	110	2	2968	\N	2968	\N	\N	13	1	2	f	0	\N	\N
784	36	110	2	1096	\N	1096	\N	\N	14	1	2	f	0	\N	\N
785	33	110	2	561	\N	561	\N	\N	15	1	2	f	0	\N	\N
786	66	110	2	284	\N	284	\N	\N	16	1	2	f	0	\N	\N
787	60	110	2	206	\N	206	\N	\N	17	1	2	f	0	\N	\N
788	71	110	2	194	\N	194	\N	\N	18	1	2	f	0	\N	\N
789	22	110	2	137	\N	137	\N	\N	19	1	2	f	0	\N	\N
790	59	110	2	111	\N	111	\N	\N	20	1	2	f	0	\N	\N
791	87	110	2	81	\N	81	\N	\N	21	1	2	f	0	\N	\N
792	61	110	2	58	\N	58	\N	\N	22	1	2	f	0	\N	\N
793	26	110	2	57	\N	57	\N	\N	23	1	2	f	0	\N	\N
794	56	110	2	54	\N	54	\N	\N	24	1	2	f	0	\N	\N
795	88	110	2	39	\N	39	\N	\N	25	1	2	f	0	\N	\N
796	92	110	2	33	\N	33	\N	\N	26	1	2	f	0	\N	\N
797	58	110	2	13	\N	13	\N	\N	27	1	2	f	0	\N	\N
798	34	110	2	12	\N	12	\N	\N	28	1	2	f	0	\N	\N
799	63	110	2	12	\N	12	\N	\N	29	1	2	f	0	\N	\N
800	10	110	2	11	\N	11	\N	\N	30	1	2	f	0	\N	\N
801	27	110	2	11	\N	11	\N	\N	31	1	2	f	0	\N	\N
802	50	110	2	8	\N	8	\N	\N	32	1	2	f	0	\N	\N
803	24	110	2	6	\N	6	\N	\N	33	1	2	f	0	\N	\N
804	4	110	2	4	\N	4	\N	\N	34	1	2	f	0	\N	\N
805	23	110	2	4	\N	4	\N	\N	35	1	2	f	0	\N	\N
806	91	110	2	4	\N	4	\N	\N	36	1	2	f	0	\N	\N
807	42	110	2	3	\N	3	\N	\N	37	1	2	f	0	\N	\N
808	72	110	2	2	\N	2	\N	\N	38	1	2	f	0	\N	\N
809	62	110	2	1	\N	1	\N	\N	39	1	2	f	0	\N	\N
810	5	110	2	1	\N	1	\N	\N	40	1	2	f	0	\N	\N
811	40	110	2	1	\N	1	\N	\N	41	1	2	f	0	\N	\N
812	81	110	2	3392538	\N	3392538	\N	\N	0	1	2	f	0	\N	\N
813	80	110	2	2551490	\N	2551490	\N	\N	0	1	2	f	0	\N	\N
814	28	110	2	2085378	\N	2085378	\N	\N	0	1	2	f	0	\N	\N
815	54	110	2	1699959	\N	1699959	\N	\N	0	1	2	f	0	\N	\N
816	7	110	2	1699959	\N	1699959	\N	\N	0	1	2	f	0	\N	\N
817	65	110	2	445862	\N	445862	\N	\N	0	1	2	f	0	\N	\N
818	11	110	2	256564	\N	256564	\N	\N	0	1	2	f	0	\N	\N
819	41	110	2	251773	\N	251773	\N	\N	0	1	2	f	0	\N	\N
820	94	110	2	229689	\N	229689	\N	\N	0	1	2	f	0	\N	\N
821	35	110	2	173891	\N	173891	\N	\N	0	1	2	f	0	\N	\N
822	8	110	2	149052	\N	149052	\N	\N	0	1	2	f	0	\N	\N
823	9	110	2	139859	\N	139859	\N	\N	0	1	2	f	0	\N	\N
824	67	110	2	112018	\N	112018	\N	\N	0	1	2	f	0	\N	\N
825	76	110	2	111388	\N	111388	\N	\N	0	1	2	f	0	\N	\N
826	95	110	2	111038	\N	111038	\N	\N	0	1	2	f	0	\N	\N
827	38	110	2	65548	\N	65548	\N	\N	0	1	2	f	0	\N	\N
828	82	110	2	46270	\N	46270	\N	\N	0	1	2	f	0	\N	\N
829	75	110	2	35728	\N	35728	\N	\N	0	1	2	f	0	\N	\N
830	70	110	2	27292	\N	27292	\N	\N	0	1	2	f	0	\N	\N
831	79	110	2	25839	\N	25839	\N	\N	0	1	2	f	0	\N	\N
832	20	110	2	24179	\N	24179	\N	\N	0	1	2	f	0	\N	\N
833	18	110	2	24092	\N	24092	\N	\N	0	1	2	f	0	\N	\N
834	30	110	2	23577	\N	23577	\N	\N	0	1	2	f	0	\N	\N
835	68	110	2	21981	\N	21981	\N	\N	0	1	2	f	0	\N	\N
836	84	110	2	15554	\N	15554	\N	\N	0	1	2	f	0	\N	\N
837	12	110	2	15525	\N	15525	\N	\N	0	1	2	f	0	\N	\N
838	78	110	2	15489	\N	15489	\N	\N	0	1	2	f	0	\N	\N
839	37	110	2	14056	\N	14056	\N	\N	0	1	2	f	0	\N	\N
840	31	110	2	13490	\N	13490	\N	\N	0	1	2	f	0	\N	\N
841	48	110	2	9495	\N	9495	\N	\N	0	1	2	f	0	\N	\N
842	90	110	2	6806	\N	6806	\N	\N	0	1	2	f	0	\N	\N
843	14	110	2	5936	\N	5936	\N	\N	0	1	2	f	0	\N	\N
844	85	110	2	5622	\N	5622	\N	\N	0	1	2	f	0	\N	\N
845	13	110	2	4544	\N	4544	\N	\N	0	1	2	f	0	\N	\N
846	86	110	2	4332	\N	4332	\N	\N	0	1	2	f	0	\N	\N
847	49	110	2	3742	\N	3742	\N	\N	0	1	2	f	0	\N	\N
848	83	110	2	3414	\N	3414	\N	\N	0	1	2	f	0	\N	\N
849	19	110	2	3108	\N	3108	\N	\N	0	1	2	f	0	\N	\N
850	89	110	2	1734	\N	1734	\N	\N	0	1	2	f	0	\N	\N
851	47	110	2	1660	\N	1660	\N	\N	0	1	2	f	0	\N	\N
852	43	110	2	1506	\N	1506	\N	\N	0	1	2	f	0	\N	\N
853	1	110	2	1445	\N	1445	\N	\N	0	1	2	f	0	\N	\N
854	45	110	2	318	\N	318	\N	\N	0	1	2	f	0	\N	\N
855	21	110	2	224	\N	224	\N	\N	0	1	2	f	0	\N	\N
856	29	110	2	150	\N	150	\N	\N	0	1	2	f	0	\N	\N
857	77	110	2	121	\N	121	\N	\N	0	1	2	f	0	\N	\N
858	53	110	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
859	51	110	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
860	25	110	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
861	57	110	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
862	52	110	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
863	15	110	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
864	16	110	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
865	17	110	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
866	71	110	1	11333065	\N	11333065	\N	\N	1	1	2	f	\N	\N	\N
867	51	110	1	616	\N	616	\N	\N	0	1	2	f	\N	\N	\N
868	35	111	2	1620	\N	1620	\N	\N	1	1	2	f	0	\N	\N
869	64	111	2	1620	\N	1620	\N	\N	0	1	2	f	0	\N	\N
870	41	111	2	1620	\N	1620	\N	\N	0	1	2	f	0	\N	\N
871	37	111	2	1597	\N	1597	\N	\N	0	1	2	f	0	\N	\N
872	35	111	1	1682	\N	1682	\N	\N	1	1	2	f	\N	\N	\N
873	64	111	1	1682	\N	1682	\N	\N	0	1	2	f	\N	\N	\N
874	41	111	1	1682	\N	1682	\N	\N	0	1	2	f	\N	\N	\N
875	37	111	1	1597	\N	1597	\N	\N	0	1	2	f	\N	\N	\N
876	71	112	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
877	71	112	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
878	59	112	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
879	58	113	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
880	58	113	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
881	80	114	2	696081	\N	696081	\N	\N	1	1	2	f	0	\N	\N
882	64	114	2	696081	\N	696081	\N	\N	0	1	2	f	0	\N	\N
883	28	114	2	693216	\N	693216	\N	\N	0	1	2	f	0	\N	\N
884	71	115	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
885	81	116	2	1696269	\N	1696269	\N	\N	1	1	2	f	0	\N	\N
886	93	116	2	1696269	\N	1696269	\N	\N	0	1	2	f	0	\N	\N
887	54	116	1	1696269	\N	1696269	\N	\N	1	1	2	f	\N	\N	\N
888	93	116	1	1696269	\N	1696269	\N	\N	0	1	2	f	\N	\N	\N
889	7	116	1	1696269	\N	1696269	\N	\N	0	1	2	f	\N	\N	\N
890	39	117	2	2921	\N	0	\N	\N	1	1	2	f	2921	\N	\N
891	6	118	2	1992	\N	1992	\N	\N	1	1	2	f	0	\N	\N
892	6	118	1	2415	\N	2415	\N	\N	1	1	2	f	\N	\N	\N
893	35	119	2	271	\N	271	\N	\N	1	1	2	f	0	\N	\N
894	64	119	2	271	\N	271	\N	\N	0	1	2	f	0	\N	\N
895	41	119	2	271	\N	271	\N	\N	0	1	2	f	0	\N	\N
896	37	119	2	257	\N	257	\N	\N	0	1	2	f	0	\N	\N
897	35	119	1	270	\N	270	\N	\N	1	1	2	f	\N	\N	\N
898	64	119	1	270	\N	270	\N	\N	0	1	2	f	\N	\N	\N
899	41	119	1	270	\N	270	\N	\N	0	1	2	f	\N	\N	\N
900	37	119	1	257	\N	257	\N	\N	0	1	2	f	\N	\N	\N
901	6	120	2	27053	\N	27053	\N	\N	1	1	2	f	0	\N	\N
902	73	120	1	24032	\N	24032	\N	\N	1	1	2	f	\N	\N	\N
903	59	121	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
904	92	121	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
905	86	122	2	483	\N	483	\N	\N	1	1	2	f	0	\N	\N
906	64	122	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
907	35	122	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
908	41	122	2	483	\N	483	\N	\N	0	1	2	f	0	\N	\N
909	86	122	1	483	\N	483	\N	\N	1	1	2	f	\N	\N	\N
910	64	122	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
911	35	122	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
912	41	122	1	483	\N	483	\N	\N	0	1	2	f	\N	\N	\N
913	6	123	2	27053	\N	27053	\N	\N	1	1	2	f	0	\N	\N
914	73	123	1	24032	\N	24032	\N	\N	1	1	2	f	\N	\N	\N
915	80	124	2	3443	\N	3443	\N	\N	1	1	2	f	0	\N	\N
916	64	124	2	3443	\N	3443	\N	\N	0	1	2	f	0	\N	\N
917	8	124	2	2572	\N	2572	\N	\N	0	1	2	f	0	\N	\N
918	82	124	2	2366	\N	2366	\N	\N	0	1	2	f	0	\N	\N
919	43	124	2	140	\N	140	\N	\N	0	1	2	f	0	\N	\N
920	38	124	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
921	75	124	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
922	80	124	1	3443	\N	3443	\N	\N	1	1	2	f	\N	\N	\N
923	64	124	1	3443	\N	3443	\N	\N	0	1	2	f	\N	\N	\N
924	8	124	1	2572	\N	2572	\N	\N	0	1	2	f	\N	\N	\N
925	82	124	1	2366	\N	2366	\N	\N	0	1	2	f	\N	\N	\N
926	43	124	1	140	\N	140	\N	\N	0	1	2	f	\N	\N	\N
927	38	124	1	61	\N	61	\N	\N	0	1	2	f	\N	\N	\N
928	75	124	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
929	54	125	2	57239	\N	0	\N	\N	1	1	2	f	57239	\N	\N
930	58	125	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
931	93	125	2	57239	\N	0	\N	\N	0	1	2	f	57239	\N	\N
932	7	125	2	57239	\N	0	\N	\N	0	1	2	f	57239	\N	\N
933	71	128	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
934	39	132	2	2536	\N	0	\N	\N	1	1	2	f	2536	\N	\N
935	48	133	2	1914	\N	1914	\N	\N	1	1	2	f	0	\N	\N
936	3	133	2	1478	\N	1478	\N	\N	2	1	2	f	0	\N	\N
937	64	133	2	1914	\N	1914	\N	\N	0	1	2	f	0	\N	\N
938	80	133	2	1914	\N	1914	\N	\N	0	1	2	f	0	\N	\N
939	31	133	2	1186	\N	1186	\N	\N	0	1	2	f	0	\N	\N
940	19	133	2	292	\N	292	\N	\N	0	1	2	f	0	\N	\N
941	2	133	1	3392	\N	3392	\N	\N	1	1	2	f	\N	\N	\N
942	30	133	1	2532	\N	2532	\N	\N	0	1	2	f	\N	\N	\N
943	68	133	1	2319	\N	2319	\N	\N	0	1	2	f	\N	\N	\N
944	79	133	1	2276	\N	2276	\N	\N	0	1	2	f	\N	\N	\N
945	20	133	1	1984	\N	1984	\N	\N	0	1	2	f	\N	\N	\N
946	69	133	1	1914	\N	1914	\N	\N	0	1	2	f	\N	\N	\N
947	78	133	1	1914	\N	1914	\N	\N	0	1	2	f	\N	\N	\N
948	12	133	1	1914	\N	1914	\N	\N	0	1	2	f	\N	\N	\N
949	13	133	1	1116	\N	1116	\N	\N	0	1	2	f	\N	\N	\N
950	90	133	1	860	\N	860	\N	\N	0	1	2	f	\N	\N	\N
951	85	133	1	704	\N	704	\N	\N	0	1	2	f	\N	\N	\N
952	47	133	1	292	\N	292	\N	\N	0	1	2	f	\N	\N	\N
953	89	133	1	213	\N	213	\N	\N	0	1	2	f	\N	\N	\N
954	1	133	1	185	\N	185	\N	\N	0	1	2	f	\N	\N	\N
955	80	134	2	6359	\N	6359	\N	\N	1	1	2	f	0	\N	\N
956	64	134	2	6359	\N	6359	\N	\N	0	1	2	f	0	\N	\N
957	8	134	2	4809	\N	4809	\N	\N	0	1	2	f	0	\N	\N
958	38	134	2	2200	\N	2200	\N	\N	0	1	2	f	0	\N	\N
959	82	134	2	1598	\N	1598	\N	\N	0	1	2	f	0	\N	\N
960	75	134	2	968	\N	968	\N	\N	0	1	2	f	0	\N	\N
961	43	134	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
962	80	134	1	6390	\N	6390	\N	\N	1	1	2	f	\N	\N	\N
963	64	134	1	6390	\N	6390	\N	\N	0	1	2	f	\N	\N	\N
964	8	134	1	4809	\N	4809	\N	\N	0	1	2	f	\N	\N	\N
965	38	134	1	1986	\N	1986	\N	\N	0	1	2	f	\N	\N	\N
966	82	134	1	1716	\N	1716	\N	\N	0	1	2	f	\N	\N	\N
967	75	134	1	1074	\N	1074	\N	\N	0	1	2	f	\N	\N	\N
968	43	134	1	33	\N	33	\N	\N	0	1	2	f	\N	\N	\N
969	59	135	2	111	\N	111	\N	\N	1	1	2	f	0	\N	\N
970	60	135	1	94	\N	94	\N	\N	1	1	2	f	\N	\N	\N
971	87	135	1	24	\N	24	\N	\N	2	1	2	f	\N	\N	\N
972	61	135	1	9	\N	9	\N	\N	3	1	2	f	\N	\N	\N
973	80	136	2	34161	\N	0	\N	\N	1	1	2	f	34161	\N	\N
974	66	136	2	284	\N	0	\N	\N	2	1	2	f	284	\N	\N
975	64	136	2	34161	\N	0	\N	\N	0	1	2	f	34161	\N	\N
976	8	136	2	26014	\N	0	\N	\N	0	1	2	f	26014	\N	\N
977	38	136	2	11737	\N	0	\N	\N	0	1	2	f	11737	\N	\N
978	82	136	2	8229	\N	0	\N	\N	0	1	2	f	8229	\N	\N
979	75	136	2	5789	\N	0	\N	\N	0	1	2	f	5789	\N	\N
980	43	136	2	259	\N	0	\N	\N	0	1	2	f	259	\N	\N
981	60	137	2	624	\N	624	\N	\N	1	1	2	f	0	\N	\N
982	61	137	2	171	\N	171	\N	\N	2	1	2	f	0	\N	\N
983	88	137	2	21	\N	21	\N	\N	3	1	2	f	0	\N	\N
984	87	137	2	145	\N	145	\N	\N	0	1	2	f	0	\N	\N
985	15	137	2	35	\N	35	\N	\N	0	1	2	f	0	\N	\N
986	16	137	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
987	25	137	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
988	52	137	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
989	26	137	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
990	71	137	1	583	\N	583	\N	\N	1	1	2	f	\N	\N	\N
991	59	137	1	220	\N	220	\N	\N	2	1	2	f	\N	\N	\N
992	51	137	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
993	59	138	2	43	\N	43	\N	\N	1	1	2	f	0	\N	\N
994	71	138	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
995	92	138	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
996	73	139	2	24034	\N	0	\N	\N	1	1	2	f	24034	\N	\N
997	35	140	2	409	\N	409	\N	\N	1	1	2	f	0	\N	\N
998	64	140	2	409	\N	409	\N	\N	0	1	2	f	0	\N	\N
999	41	140	2	409	\N	409	\N	\N	0	1	2	f	0	\N	\N
1000	37	140	2	382	\N	382	\N	\N	0	1	2	f	0	\N	\N
1001	35	140	1	409	\N	409	\N	\N	1	1	2	f	\N	\N	\N
1002	64	140	1	409	\N	409	\N	\N	0	1	2	f	\N	\N	\N
1003	41	140	1	409	\N	409	\N	\N	0	1	2	f	\N	\N	\N
1004	37	140	1	382	\N	382	\N	\N	0	1	2	f	\N	\N	\N
1005	39	141	2	2968	\N	0	\N	\N	1	1	2	f	2968	\N	\N
1006	64	142	2	96581	\N	0	\N	\N	1	1	2	f	96581	\N	\N
1007	65	142	2	50830	\N	0	\N	\N	0	1	2	f	50830	\N	\N
1008	80	142	2	42214	\N	0	\N	\N	0	1	2	f	42214	\N	\N
1009	9	142	2	38888	\N	0	\N	\N	0	1	2	f	38888	\N	\N
1010	8	142	2	32312	\N	0	\N	\N	0	1	2	f	32312	\N	\N
1011	38	142	2	14239	\N	0	\N	\N	0	1	2	f	14239	\N	\N
1012	82	142	2	9963	\N	0	\N	\N	0	1	2	f	9963	\N	\N
1013	75	142	2	7781	\N	0	\N	\N	0	1	2	f	7781	\N	\N
1014	35	142	2	3537	\N	0	\N	\N	0	1	2	f	3537	\N	\N
1015	41	142	2	3537	\N	0	\N	\N	0	1	2	f	3537	\N	\N
1016	37	142	2	3445	\N	0	\N	\N	0	1	2	f	3445	\N	\N
1017	43	142	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
1018	37	143	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
1019	64	143	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1020	35	143	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1021	41	143	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1022	37	143	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
1023	64	143	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1024	35	143	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1025	41	143	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1026	80	144	2	15393	\N	0	\N	\N	1	1	2	f	15393	\N	\N
1027	64	144	2	15393	\N	0	\N	\N	0	1	2	f	15393	\N	\N
1028	94	144	2	14910	\N	0	\N	\N	0	1	2	f	14910	\N	\N
1029	48	145	2	3128	\N	3128	\N	\N	1	1	2	f	0	\N	\N
1030	64	145	2	3128	\N	3128	\N	\N	0	1	2	f	0	\N	\N
1031	80	145	2	3128	\N	3128	\N	\N	0	1	2	f	0	\N	\N
1032	21	145	1	6237	\N	6237	\N	\N	1	1	2	f	\N	\N	\N
1033	64	145	1	6237	\N	6237	\N	\N	0	1	2	f	\N	\N	\N
1034	62	146	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1035	62	146	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://premon.fbk.eu/ontology/vn#	0	t	0
70	nif	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#	0	f	0
71	pmopb	http://premon.fbk.eu/ontology/pb#	0	f	0
72	ontolex	http://www.w3.org/ns/lemon/ontolex#	0	f	0
73	pmo	http://premon.fbk.eu/ontology/core#	0	f	0
74	pmofn	http://premon.fbk.eu/ontology/fn#	0	f	0
75	pm	http://premon.fbk.eu/resource/	0	f	0
76	lime	http://www.w3.org/ns/lemon/lime#	0	f	0
77	pmonb	http://premon.fbk.eu/ontology/nb#	0	f	0
78	lexinfo	http://www.lexinfo.net/ontology/2.0/lexinfo#	0	f	0
79	n_1	http://www.w3.org/ns/lemon/decomp#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_premon_fbk_eu_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_premon_fbk_eu_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://premon.fbk.eu/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://premon.fbk.eu/sparql", "correlationId": "8896819855730708142", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:35:44.614Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#anchorOf	2251437	\N	70	anchorOf	anchorOf	f	0	\N	\N	f	f	93	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://premon.fbk.eu/ontology/nb#argument	76241	\N	77	argument	argument	f	76241	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://premon.fbk.eu/ontology/fn#precedesFER	1025	\N	74	precedesFER	precedesFER	f	1025	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
4	http://www.w3.org/2002/07/owl#inverseOf	25	\N	7	inverseOf	inverseOf	f	25	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://premon.fbk.eu/ontology/fn#reFrameMapping	570	\N	74	reFrameMapping	reFrameMapping	f	570	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
6	http://www.w3.org/2002/07/owl#hasKey	1	\N	7	hasKey	hasKey	f	1	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	302	\N	1	rest	rest	f	302	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://premon.fbk.eu/ontology/vn#frameSyntaxDescription	2968	\N	69	frameSyntaxDescription	frameSyntaxDescription	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://premon.fbk.eu/ontology/fn#usesFER	7387	\N	74	usesFER	usesFER	f	7387	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
10	http://www.w3.org/2004/02/skos/core#definition	188701	\N	4	definition	definition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://premon.fbk.eu/ontology/pb#tag	53736	\N	71	tag	tag	f	53736	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/2002/07/owl#equivalentClass	33	\N	7	equivalentClass	equivalentClass	f	33	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://premon.fbk.eu/ontology/pb#voice	110	\N	71	voice	voice	f	110	\N	\N	f	f	22	4	\N	t	f	\N	\N	\N	t	f	f
14	http://premon.fbk.eu/ontology/core#evokingEntry	108219	\N	73	evokingEntry	evokingEntry	f	108219	\N	\N	f	f	65	6	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	3	\N	2	isDefinedBy	isDefinedBy	f	3	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://www.w3.org/2002/07/owl#propertyDisjointWith	1	\N	7	propertyDisjointWith	propertyDisjointWith	f	1	\N	\N	f	f	16	60	\N	t	f	\N	\N	\N	t	f	f
17	http://www.w3.org/2002/07/owl#minQualifiedCardinality	6	\N	7	minQualifiedCardinality	minQualifiedCardinality	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://premon.fbk.eu/ontology/pb#core	67194	\N	71	core	core	f	0	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://www.w3.org/2002/07/owl#propertyChainAxiom	11	\N	7	propertyChainAxiom	propertyChainAxiom	f	11	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://purl.org/dc/terms/creator	74519	\N	5	creator	creator	f	74519	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://www.w3.org/2002/07/owl#someValuesFrom	11	\N	7	someValuesFrom	someValuesFrom	f	11	\N	\N	f	f	59	71	\N	t	f	\N	\N	\N	t	f	f
23	http://www.w3.org/2002/07/owl#disjointWith	4	\N	7	disjointWith	disjointWith	f	4	\N	\N	f	f	71	71	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://premon.fbk.eu/ontology/vn#negPred	8224	\N	69	negPred	negPred	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://premon.fbk.eu/ontology/vn#frameXtag	1243	\N	69	frameXtag	frameXtag	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://www.w3.org/2002/07/owl#unionOf	34	\N	7	unionOf	unionOf	f	34	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	62	62	\N	t	f	\N	\N	\N	t	f	f
29	http://purl.org/dc/terms/isVersionOf	11	\N	5	isVersionOf	isVersionOf	f	11	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://premon.fbk.eu/ontology/fn#frameRelation	5673	\N	74	frameRelation	frameRelation	f	5673	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
31	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#annotation	3865239	\N	70	annotation	annotation	f	3865239	\N	\N	f	f	93	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://premon.fbk.eu/ontology/pb#aspect	66	\N	71	aspect	aspect	f	66	\N	\N	f	f	22	91	\N	t	f	\N	\N	\N	t	f	f
33	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://premon.fbk.eu/ontology/nb#tag	2228	\N	77	tag	tag	f	2228	\N	\N	f	f	74	42	\N	t	f	\N	\N	\N	t	f	f
35	http://premon.fbk.eu/ontology/fn#inheritsFrom	2167	\N	74	inheritsFrom	inheritsFrom	f	2167	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
36	http://premon.fbk.eu/ontology/vn#definesFrame	2968	\N	69	definesFrame	definesFrame	f	2968	\N	\N	f	f	86	39	\N	t	f	\N	\N	\N	t	f	f
37	http://premon.fbk.eu/ontology/core#semRole	804934	\N	73	semRole	semRole	f	804934	\N	\N	f	f	35	80	\N	t	f	\N	\N	\N	t	f	f
38	http://premon.fbk.eu/ontology/fn#subframeOfFER	1896	\N	74	subframeOfFER	subframeOfFER	f	1896	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
39	http://www.w3.org/2004/02/skos/core#broader	2925	\N	4	broader	broader	f	2925	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/ns/lemon/ontolex#writtenRep	24034	\N	72	writtenRep	writtenRep	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://premon.fbk.eu/ontology/core#ontologyMatch	30873	\N	73	ontologyMatch	ontologyMatch	f	30873	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.openlinksw.com/schemas/DAV#ownerUser	750	\N	18	ownerUser	ownerUser	f	750	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://premon.fbk.eu/ontology/vn#definesSemRole	1837	\N	69	definesSemRole	definesSemRole	f	1837	\N	\N	f	f	86	48	\N	t	f	\N	\N	\N	t	f	f
44	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#endIndex	1696269	\N	70	endIndex	endIndex	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://premon.fbk.eu/ontology/core#valueDt	25160	\N	73	valueDt	valueDt	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://premon.fbk.eu/ontology/vn#frameExample	2985	\N	69	frameExample	frameExample	f	2985	\N	\N	f	f	39	54	\N	t	f	\N	\N	\N	t	f	f
47	http://premon.fbk.eu/ontology/core#item	2619759	\N	73	item	item	f	2619759	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://purl.org/dc/terms/modified	750	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://premon.fbk.eu/ontology/fn#inheritsFromFER	14590	\N	74	inheritsFromFER	inheritsFromFER	f	14590	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/2002/07/owl#sameAs	15886	\N	7	sameAs	sameAs	f	15886	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	283	\N	2	subPropertyOf	subPropertyOf	f	283	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://premon.fbk.eu/ontology/fn#perspectiveOnFER	2089	\N	74	perspectiveOnFER	perspectiveOnFER	f	2089	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
53	http://purl.org/dc/terms/identifier	75053	\N	5	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	301	\N	1	first	first	f	301	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://premon.fbk.eu/ontology/fn#isCausativeOf	168	\N	74	isCausativeOf	isCausativeOf	f	168	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
56	http://premon.fbk.eu/ontology/core#first	14160	\N	73	first	first	f	14160	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/dc/terms/language	1	\N	5	language	language	f	1	\N	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://www.w3.org/2002/07/owl#members	4	\N	7	members	members	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://premon.fbk.eu/ontology/vn#frameSemanticsDescription	2968	\N	69	frameSemanticsDescription	frameSemanticsDescription	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.lexinfo.net/ontology/2.0/lexinfo#partOfSpeech	62792	\N	78	partOfSpeech	partOfSpeech	f	62792	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://premon.fbk.eu/ontology/pb#person	73	\N	71	person	person	f	73	\N	\N	f	f	22	23	\N	t	f	\N	\N	\N	t	f	f
63	http://premon.fbk.eu/ontology/pb#form	121	\N	71	form	form	f	121	\N	\N	f	f	22	50	\N	t	f	\N	\N	\N	t	f	f
64	http://premon.fbk.eu/ontology/core#next	30572	\N	73	next	next	f	30572	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.w3.org/2002/07/owl#cardinality	10	\N	7	cardinality	cardinality	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#beginIndex	1696269	\N	70	beginIndex	beginIndex	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/dc/terms/extent	733	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://premon.fbk.eu/ontology/pb#tense	99	\N	71	tense	tense	f	99	\N	\N	f	f	22	24	\N	t	f	\N	\N	\N	t	f	f
69	http://www.w3.org/2000/01/rdf-schema#label	132105	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.w3.org/2002/07/owl#hasValue	1	\N	7	hasValue	hasValue	f	1	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://purl.org/dc/terms/requires	11	\N	5	requires	requires	f	11	\N	\N	f	f	10	27	\N	t	f	\N	\N	\N	t	f	f
72	http://www.w3.org/2002/07/owl#minCardinality	1	\N	7	minCardinality	minCardinality	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://premon.fbk.eu/ontology/fn#perspectiveOn	345	\N	74	perspectiveOn	perspectiveOn	f	345	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
74	http://premon.fbk.eu/ontology/pb#inflection	18580	\N	71	inflection	inflection	f	18580	\N	\N	f	f	54	22	\N	t	f	\N	\N	\N	t	f	f
75	http://purl.org/dc/terms/source	8927	\N	5	source	source	f	33	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://premon.fbk.eu/ontology/vn#implPredArg	25001	\N	69	implPredArg	implPredArg	f	0	\N	\N	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://www.w3.org/2002/07/owl#onClass	25	\N	7	onClass	onClass	f	25	\N	\N	f	f	59	71	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/2002/07/owl#maxQualifiedCardinality	2	\N	7	maxQualifiedCardinality	maxQualifiedCardinality	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://www.w3.org/2002/07/owl#qualifiedCardinality	22	\N	7	qualifiedCardinality	qualifiedCardinality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://premon.fbk.eu/ontology/fn#requiresFrameElement	309	\N	74	requiresFrameElement	requiresFrameElement	f	309	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
81	http://premon.fbk.eu/ontology/fn#semType	16880	\N	74	semType	semType	f	16880	\N	\N	f	f	64	66	\N	t	f	\N	\N	\N	t	f	f
82	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#isString	566653	\N	70	isString	isString	f	0	\N	\N	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://premon.fbk.eu/ontology/fn#status	38747	\N	74	status	status	f	38747	\N	\N	f	f	65	56	\N	t	f	\N	\N	\N	t	f	f
84	http://premon.fbk.eu/ontology/core#semRoleMapping	271985	\N	73	semRoleMapping	semRoleMapping	f	271985	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://www.w3.org/2000/01/rdf-schema#subClassOf	493	\N	2	subClassOf	subClassOf	f	493	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://www.w3.org/ns/lemon/lime#entry	24032	\N	76	entry	entry	f	24032	\N	\N	f	f	72	6	\N	t	f	\N	\N	\N	t	f	f
87	http://premon.fbk.eu/ontology/core#valueObj	2648532	\N	73	valueObj	valueObj	f	2648532	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://premon.fbk.eu/ontology/fn#subTypeOf	275	\N	74	subTypeOf	subTypeOf	f	275	\N	\N	f	f	66	66	\N	t	f	\N	\N	\N	t	f	f
89	http://www.w3.org/2002/07/owl#hasSelf	1	\N	7	hasSelf	hasSelf	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://premon.fbk.eu/ontology/fn#incorporatedFrameElement	4167	\N	74	incorporatedFrameElement	incorporatedFrameElement	f	4167	\N	\N	f	f	65	80	\N	t	f	\N	\N	\N	t	f	f
91	http://www.w3.org/2000/01/rdf-schema#range	576	\N	2	range	range	f	576	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://premon.fbk.eu/ontology/core#evokedConcept	108219	\N	73	evokedConcept	evokedConcept	f	108219	\N	\N	f	f	65	41	\N	t	f	\N	\N	\N	t	f	f
93	http://www.w3.org/ns/lemon/ontolex#evokes	108212	\N	72	evokes	evokes	f	108212	\N	\N	f	f	6	41	\N	t	f	\N	\N	\N	t	f	f
94	http://www.w3.org/2002/07/owl#oneOf	15	\N	7	oneOf	oneOf	f	15	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://www.w3.org/2002/07/owl#equivalentProperty	205	\N	7	equivalentProperty	equivalentProperty	f	205	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://premon.fbk.eu/ontology/fn#seeAlsoFER	2110	\N	74	seeAlsoFER	seeAlsoFER	f	2110	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
97	http://premon.fbk.eu/ontology/fn#isInchoativeOf	54	\N	74	isInchoativeOf	isInchoativeOf	f	54	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
98	http://premon.fbk.eu/ontology/fn#feCoreSet	1096	\N	74	feCoreSet	feCoreSet	f	1096	\N	\N	f	f	35	36	\N	t	f	\N	\N	\N	t	f	f
99	http://www.w3.org/ns/lemon/lime#language	24033	\N	76	language	language	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://premon.fbk.eu/ontology/vn#frame	4550	\N	69	frame	frame	f	4550	\N	\N	f	f	86	39	\N	t	f	\N	\N	\N	t	f	f
101	http://premon.fbk.eu/ontology/core#classRel	6156	\N	73	classRel	classRel	f	6156	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
102	http://www.w3.org/ns/lemon/ontolex#isEvokedBy	108212	\N	72	isEvokedBy	isEvokedBy	f	108212	\N	\N	f	f	41	6	\N	t	f	\N	\N	\N	t	f	f
103	http://premon.fbk.eu/ontology/fn#metaphorFER	38	\N	74	metaphorFER	metaphorFER	f	38	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
104	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://premon.fbk.eu/ontology/core#roleRel	36184	\N	73	roleRel	roleRel	f	36184	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
106	http://premon.fbk.eu/ontology/fn#isInchoativeOfFER	213	\N	74	isInchoativeOfFER	isInchoativeOfFER	f	213	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
107	http://www.w3.org/2000/01/rdf-schema#seeAlso	56968	\N	2	seeAlso	seeAlso	f	56968	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://premon.fbk.eu/ontology/fn#subframeOf	381	\N	74	subframeOf	subframeOf	f	381	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
109	http://premon.fbk.eu/ontology/fn#isCausativeOfFER	1094	\N	74	isCausativeOfFER	isCausativeOfFER	f	1094	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
111	http://premon.fbk.eu/ontology/fn#uses	1597	\N	74	uses	uses	f	1597	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
112	http://www.w3.org/2002/07/owl#complementOf	5	\N	7	complementOf	complementOf	f	5	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://www.w3.org/2002/07/owl#imports	15	\N	7	imports	imports	f	15	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://premon.fbk.eu/ontology/pb#argument	693216	\N	71	argument	argument	f	693216	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://www.w3.org/2002/07/owl#intersectionOf	6	\N	7	intersectionOf	intersectionOf	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#referenceContext	1696269	\N	70	referenceContext	referenceContext	f	1696269	\N	\N	f	f	81	54	\N	t	f	\N	\N	\N	t	f	f
117	http://premon.fbk.eu/ontology/vn#frameSecondary	2921	\N	69	frameSecondary	frameSecondary	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://www.w3.org/ns/lemon/decomp#subterm	1992	\N	79	subterm	subterm	f	1992	\N	\N	f	f	6	6	\N	t	f	\N	\N	\N	t	f	f
119	http://premon.fbk.eu/ontology/fn#precedes	257	\N	74	precedes	precedes	f	257	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
120	http://www.w3.org/ns/lemon/ontolex#lexicalForm	24032	\N	72	lexicalForm	lexicalForm	f	24032	\N	\N	f	f	6	73	\N	t	f	\N	\N	\N	t	f	f
121	http://www.w3.org/2002/07/owl#onDataRange	4	\N	7	onDataRange	onDataRange	f	4	\N	\N	f	f	59	92	\N	t	f	\N	\N	\N	t	f	f
122	http://premon.fbk.eu/ontology/vn#subclassOf	483	\N	69	subclassOf	subclassOf	f	483	\N	\N	f	f	86	86	\N	t	f	\N	\N	\N	t	f	f
123	http://www.w3.org/ns/lemon/ontolex#canonicalForm	24032	\N	72	canonicalForm	canonicalForm	f	24032	\N	\N	f	f	6	73	\N	t	f	\N	\N	\N	t	f	f
124	http://premon.fbk.eu/ontology/fn#excludesFrameElement	2572	\N	74	excludesFrameElement	excludesFrameElement	f	2572	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
125	http://www.w3.org/2000/01/rdf-schema#comment	57240	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://www.w3.org/2002/07/owl#disjointUnionOf	9	\N	7	disjointUnionOf	disjointUnionOf	f	9	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://premon.fbk.eu/ontology/vn#frameDescNumber	2536	\N	69	frameDescNumber	frameDescNumber	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://premon.fbk.eu/ontology/vn#restriction	3392	\N	69	restriction	restriction	f	3392	\N	\N	f	f	\N	2	\N	t	f	\N	\N	\N	t	f	f
134	http://premon.fbk.eu/ontology/fn#reFrameMappingFER	4809	\N	74	reFrameMappingFER	reFrameMappingFER	f	4809	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
135	http://www.w3.org/2002/07/owl#onProperty	111	\N	7	onProperty	onProperty	f	111	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://premon.fbk.eu/ontology/core#abbreviation	26298	\N	73	abbreviation	abbreviation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://www.w3.org/2000/01/rdf-schema#domain	819	\N	2	domain	domain	f	819	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://www.w3.org/2002/07/owl#allValuesFrom	43	\N	7	allValuesFrom	allValuesFrom	f	43	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://www.w3.org/ns/lemon/ontolex#representation	24034	\N	72	representation	representation	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://premon.fbk.eu/ontology/fn#seeAlso	382	\N	74	seeAlso	seeAlso	f	382	\N	\N	f	f	35	35	\N	t	f	\N	\N	\N	t	f	f
141	http://premon.fbk.eu/ontology/vn#framePrimary	2968	\N	69	framePrimary	framePrimary	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://purl.org/dc/terms/created	75395	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://premon.fbk.eu/ontology/fn#metaphor	4	\N	74	metaphor	metaphor	f	4	\N	\N	f	f	37	37	\N	t	f	\N	\N	\N	t	f	f
144	http://premon.fbk.eu/ontology/nb#core	14910	\N	77	core	core	f	0	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	11334016	\N	1	type	type	f	11334016	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
145	http://premon.fbk.eu/ontology/vn#thematicRole	3128	\N	69	thematicRole	thematicRole	f	3128	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	62	62	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_premon_fbk_eu_sparql; Owner: -
--

COPY http_premon_fbk_eu_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	4	8	inverseOf	\N
2	12	8	equivalentClass	\N
3	18	8	priorVersion	\N
4	22	8	someValuesFrom	\N
5	23	8	disjointWith	\N
6	27	8	unionOf	\N
7	33	8	versionInfo	\N
8	50	8	sameAs	\N
9	65	8	cardinality	\N
10	70	8	hasValue	\N
11	72	8	minCardinality	\N
12	94	8	oneOf	\N
13	95	8	equivalentProperty	\N
14	112	8	complementOf	\N
15	113	8	imports	\N
16	115	8	intersectionOf	\N
17	135	8	onProperty	\N
18	138	8	allValuesFrom	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cc_rels_id_seq', 54, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.class_annots_id_seq', 11, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.classes_id_seq', 95, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cp_rels_id_seq', 1035, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.ns_id_seq', 79, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.properties_id_seq', 146, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_premon_fbk_eu_sparql; Owner: -
--

SELECT pg_catalog.setval('http_premon_fbk_eu_sparql.property_annots_id_seq', 18, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_premon_fbk_eu_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_premon_fbk_eu_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_premon_fbk_eu_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_premon_fbk_eu_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_premon_fbk_eu_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_premon_fbk_eu_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_premon_fbk_eu_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_premon_fbk_eu_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_premon_fbk_eu_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_premon_fbk_eu_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_premon_fbk_eu_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_premon_fbk_eu_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_premon_fbk_eu_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_premon_fbk_eu_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_premon_fbk_eu_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_premon_fbk_eu_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_premon_fbk_eu_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_premon_fbk_eu_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_premon_fbk_eu_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_premon_fbk_eu_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_premon_fbk_eu_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_premon_fbk_eu_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_premon_fbk_eu_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_premon_fbk_eu_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_premon_fbk_eu_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_premon_fbk_eu_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_premon_fbk_eu_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_premon_fbk_eu_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_premon_fbk_eu_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_premon_fbk_eu_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_premon_fbk_eu_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_premon_fbk_eu_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_premon_fbk_eu_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_premon_fbk_eu_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_premon_fbk_eu_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_premon_fbk_eu_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_premon_fbk_eu_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_premon_fbk_eu_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_premon_fbk_eu_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_premon_fbk_eu_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_premon_fbk_eu_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_premon_fbk_eu_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_premon_fbk_eu_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_premon_fbk_eu_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_premon_fbk_eu_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_premon_fbk_eu_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_premon_fbk_eu_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_premon_fbk_eu_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_premon_fbk_eu_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_premon_fbk_eu_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_premon_fbk_eu_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_premon_fbk_eu_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_premon_fbk_eu_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_premon_fbk_eu_sparql; Owner: -
--

ALTER TABLE ONLY http_premon_fbk_eu_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_premon_fbk_eu_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

