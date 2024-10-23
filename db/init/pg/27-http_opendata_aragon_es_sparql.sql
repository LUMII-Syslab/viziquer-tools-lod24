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
-- Name: http_opendata_aragon_es_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_opendata_aragon_es_sparql;


--
-- Name: SCHEMA http_opendata_aragon_es_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_opendata_aragon_es_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE FUNCTION http_opendata_aragon_es_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE FUNCTION http_opendata_aragon_es_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COMMENT ON TABLE http_opendata_aragon_es_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COMMENT ON COLUMN http_opendata_aragon_es_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_opendata_aragon_es_sparql.classes c1
     JOIN http_opendata_aragon_es_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_opendata_aragon_es_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_opendata_aragon_es_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_opendata_aragon_es_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE TABLE http_opendata_aragon_es_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE http_opendata_aragon_es_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_opendata_aragon_es_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_cc_rels AS
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
   FROM http_opendata_aragon_es_sparql.cc_rels r,
    http_opendata_aragon_es_sparql.classes c1,
    http_opendata_aragon_es_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_classes_ns AS
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
    http_opendata_aragon_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_opendata_aragon_es_sparql.classes c
     LEFT JOIN http_opendata_aragon_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_classes_ns_main AS
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
   FROM http_opendata_aragon_es_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_opendata_aragon_es_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_classes_ns_plus AS
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
    http_opendata_aragon_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_opendata_aragon_es_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_opendata_aragon_es_sparql.classes c
     LEFT JOIN http_opendata_aragon_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_classes_ns_main_plus AS
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
   FROM http_opendata_aragon_es_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_opendata_aragon_es_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_opendata_aragon_es_sparql.v_classes_ns v
     LEFT JOIN http_opendata_aragon_es_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_cp_rels AS
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
    http_opendata_aragon_es_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_opendata_aragon_es_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_opendata_aragon_es_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_opendata_aragon_es_sparql.cp_rels r,
    http_opendata_aragon_es_sparql.classes c,
    http_opendata_aragon_es_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_cp_rels_card AS
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
   FROM http_opendata_aragon_es_sparql.cp_rels r,
    http_opendata_aragon_es_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_properties_ns AS
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
    http_opendata_aragon_es_sparql.tapprox(p.cnt) AS cnt_x,
    http_opendata_aragon_es_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_opendata_aragon_es_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_opendata_aragon_es_sparql.properties p
     LEFT JOIN http_opendata_aragon_es_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_cp_sources_single AS
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
   FROM ((http_opendata_aragon_es_sparql.v_cp_rels_card r
     JOIN http_opendata_aragon_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_opendata_aragon_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_cp_targets_single AS
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
   FROM ((http_opendata_aragon_es_sparql.v_cp_rels_card r
     JOIN http_opendata_aragon_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_opendata_aragon_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_opendata_aragon_es_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_opendata_aragon_es_sparql.pp_rels r,
    http_opendata_aragon_es_sparql.properties p1,
    http_opendata_aragon_es_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_properties_sources AS
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
   FROM (http_opendata_aragon_es_sparql.v_properties_ns v
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
           FROM http_opendata_aragon_es_sparql.cp_rels r,
            http_opendata_aragon_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_properties_sources_single AS
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
   FROM (http_opendata_aragon_es_sparql.v_properties_ns v
     LEFT JOIN http_opendata_aragon_es_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_properties_targets AS
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
   FROM (http_opendata_aragon_es_sparql.v_properties_ns v
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
           FROM http_opendata_aragon_es_sparql.cp_rels r,
            http_opendata_aragon_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE VIEW http_opendata_aragon_es_sparql.v_properties_targets_single AS
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
   FROM (http_opendata_aragon_es_sparql.v_properties_ns v
     LEFT JOIN http_opendata_aragon_es_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
9	skos:prefLabel	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	124	1	\N	\N
2	9	26	1	\N	\N
3	10	63	1	\N	\N
4	13	147	1	\N	\N
5	15	76	1	\N	\N
6	16	190	1	\N	\N
7	17	190	1	\N	\N
8	18	190	1	\N	\N
9	27	175	1	\N	\N
10	31	190	1	\N	\N
11	32	190	1	\N	\N
12	33	190	1	\N	\N
13	34	190	1	\N	\N
14	35	190	1	\N	\N
15	37	62	1	\N	\N
16	38	125	1	\N	\N
17	42	132	1	\N	\N
18	43	190	1	\N	\N
19	44	189	1	\N	\N
20	46	114	1	\N	\N
21	47	190	1	\N	\N
22	48	190	1	\N	\N
23	49	190	1	\N	\N
24	56	62	1	\N	\N
25	63	110	1	\N	\N
26	64	63	1	\N	\N
27	71	190	1	\N	\N
28	74	147	1	\N	\N
29	77	190	1	\N	\N
30	78	190	1	\N	\N
31	79	190	1	\N	\N
32	86	40	1	\N	\N
33	88	190	1	\N	\N
34	89	88	1	\N	\N
35	92	189	1	\N	\N
36	93	189	1	\N	\N
37	94	147	1	\N	\N
38	98	190	1	\N	\N
39	110	27	1	\N	\N
40	111	63	1	\N	\N
41	114	125	1	\N	\N
42	116	190	1	\N	\N
43	117	190	1	\N	\N
44	118	190	1	\N	\N
45	119	190	1	\N	\N
46	120	190	1	\N	\N
47	121	190	1	\N	\N
48	122	190	1	\N	\N
49	123	62	1	\N	\N
50	131	63	1	\N	\N
51	132	26	1	\N	\N
52	135	190	1	\N	\N
53	136	190	1	\N	\N
54	137	190	1	\N	\N
55	138	190	1	\N	\N
56	139	190	1	\N	\N
57	145	42	1	\N	\N
58	149	190	1	\N	\N
59	150	190	1	\N	\N
60	151	190	1	\N	\N
61	152	190	1	\N	\N
62	153	190	1	\N	\N
63	154	190	1	\N	\N
64	166	190	1	\N	\N
65	167	190	1	\N	\N
66	168	190	1	\N	\N
67	169	190	1	\N	\N
68	173	172	1	\N	\N
69	175	145	1	\N	\N
70	181	190	1	\N	\N
71	182	190	1	\N	\N
72	183	190	1	\N	\N
73	184	190	1	\N	\N
74	191	66	1	\N	\N
75	197	190	1	\N	\N
76	198	190	1	\N	\N
77	199	190	1	\N	\N
78	200	190	1	\N	\N
79	201	190	1	\N	\N
80	205	38	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	OntologyProperty	\N
2	2	8	FunctionalProperty	\N
3	3	8	Centro	es
4	5	8	Cube Dataset	es
5	5	8	Cube Dataset	en
6	6	8	Data Structure Definition	en
7	6	8	Definición de la estructura de datos	es
8	8	8	Measure	en
9	8	8	Medida	es
10	11	8	Unidad fisiográfica	es
11	16	8	Cartografía registrada	es
12	17	8	Documento informativo territorial	es
13	18	8	Servicio web de mapas (WMS)	es
14	19	8	Paso elevado red hídrica	es
15	20	8	Acueducto	es
16	21	8	Tramo de autopista	es
17	23	8	AnnotationProperty	\N
18	24	8	Expresión legal	es
19	24	8	Legal expression	en
20	25	8	DCAT Dataset	es
21	25	8	DCAT Dataset	en
22	26	8	Thing	\N
23	29	8	Centro de atención primaria	es
24	30	8	Óptica	es
25	31	8	Cartografía topográfica básica	es
26	32	8	Datum	es
27	33	8	Geografía	es
28	34	8	Infraestructura de datos espaciales	es
29	35	8	Red de transportes	es
30	36	8	Tramo de carretera nacional	es
31	37	8	Municipio	es
32	38	8	TransitiveProperty	\N
33	39	8	Unidad del paisaje	es
34	40	8	Dimension property	en
35	40	8	Propiedad dimensión	es
36	43	8	Chelegar	an
38	43	8	Glaciar	es
39	45	8	Centro de reconocimiento médico	es
40	46	8	SymmetricProperty	\N
41	47	8	Atlas	es
42	48	8	Geoportal	es
43	49	8	Paisaje	es
44	50	8	Municipio histórico	es
45	51	8	Presa	es
46	52	8	Tramo de la Red Autonómica de Aragón I	es
47	53	8	Laguna	es
48	54	8	Embalse	es
49	55	8	Agente de software	es
50	55	8	Software Agent	en
51	56	8	Comunidad Autónoma	es
52	57	8	Class	\N
53	57	8	Concepto	es
54	59	8	Concept	en
55	59	8	Concepto	es
57	60	8	Legal resource	en
58	60	8	Recurso legal	es
59	62	8	Organización	es
61	62	8	Organization	en
62	65	8	InverseFunctionalProperty	\N
63	67	8	Contract	en
64	67	8	Contrato	es
65	68	8	Geofoto de paisaje	es
66	69	8	Gran dominio de paisaje	es
67	70	8	Región de paisaje	es
68	71	8	Chelero	an
70	71	8	Helero	es
71	72	8	Subcuenca hidrográfica	es
72	77	8	Servicio web de catálogo (CSW)	es
73	78	8	Catálogo de metadatos	es
74	79	8	Modelo digital de elevaciones	es
75	80	8	Canal	es
76	81	8	Carretera local	es
77	82	8	Río	es
78	84	8	Ontology	\N
79	87	8	Espacio natural protegido	es
80	88	8	Cuenca hidrográfica	es
81	90	8	Macro unidad de paisaje	es
82	91	8	Centro educativo	es
83	95	8	Clínica dental	es
84	96	8	Botiquín	es
85	97	8	Banco de tejidos	es
86	98	8	Servicio web de objetos o fenómenos geográficos (WFS)	es
87	99	8	Tramo de un río	es
88	100	8	Almacenamiento de agua	es
89	102	8	Publicación	es
90	104	8	Observación	es
91	104	8	Observation	en
92	105	8	Creative work	en
93	105	8	Documento	es
94	106	8	Feature of Interest	en
95	106	8	Dispositivo IoT	es
96	107	8	A specific representation of a dataset.	es
97	107	8	Una representación específica de un conjunto de datos.	en
98	108	8	Person	en
99	108	8	Persona	es
100	109	8	Rol	es
101	109	8	Role	en
102	115	8	Centro de diagnóstico	es
103	116	8	Cartografía oficial	es
104	117	8	Cartografía temática	es
105	118	8	Cartografía topográfica	es
106	119	8	Metadato	es
107	120	8	Uso del suelo	es
108	121	8	Servicio web de nomenclátor o de nombres geográficos (WFS-g)	es
109	122	8	Servicio web de procesos (WPS)	es
110	123	8	Provincia	es
111	125	8	ObjectProperty	\N
112	126	8	PROV Actividad	es
113	126	8	PROV Activity	en
114	127	8	Location	en
115	127	8	Lugar	es
116	128	8	Observación	es
117	128	8	Observation	en
118	130	8	Sector sanitario	es
119	134	8	Event	en
120	134	8	Evento	es
121	135	8	Información geográfica	es
122	136	8	Nomenclator geográfico	es
123	137	8	Servicio de información geográfica	es
124	138	8	Servicio web de coberturas (WCS)	es
125	139	8	Servicio web teselado de mapas	es
126	140	8	Tramo de carretera	es
127	141	8	Autopista	es
128	144	8	Zona básica de salud	es
129	146	8	Establecimiento de audioprótesis	es
130	148	8	Ortopedia	es
131	149	8	Cuadrícula	es
132	150	8	Geomática	es
133	151	8	Grid	en
134	151	8	Rejilla	es
135	152	8	Hidrografía	es
136	153	8	Infraestructura de Conocimiento Geográfico	es
137	154	8	Unidad administrativa	es
138	155	8	Tramo de autovía	es
139	156	8	Carretera nacional	es
140	158	8	DatatypeProperty	\N
141	161	8	Personaje histórico	es
142	162	8	Mapa Dominio del Paisaje	es
143	163	8	Zona educativa	es
144	165	8	Consulta médica	es
145	166	8	Norma Cartográfica de Aragón	es
146	167	8	Cartografía derivada	es
147	168	8	Geodato	es
150	168	9	Geodato	es
151	169	8	Sistema de Información Geográfica	es
152	170	8	Tramo de cauce artificial	es
153	171	8	Autovía	es
154	174	8	Vídeo de paisaje	es
155	177	8	Component specification	en
156	177	8	Especificación de componente	es
157	179	8	Hospital	es
158	180	8	Centro de salud mental	es
159	181	8	Cartografía topográfica derivada	es
160	182	8	Dirección	es
161	183	8	Parcela catastral	es
162	184	8	Sistema de Referencia Espacial	es
163	184	9	Sistema de Referencia Espacial	es
164	184	9	Sistema de Referencia Geodésico	\N
165	185	8	Material cartográfico	es
166	186	8	Tubería servicio red hídrica	es
167	187	8	Tramo de túnel	es
168	188	8	Red Autonómica Aragonesa I	es
169	195	8	Centro sanitario	es
170	196	8	Farmacia	es
171	197	8	Cubierta terrestre	es
172	198	8	Nombre geográfico	es
173	199	8	Núcleo de población	es
174	200	8	Ortofoto	es
176	200	9	Ortofoto	es
177	201	8	Red geodésica	es
178	202	8	Tramo acceso (red viaria)	es
179	203	8	Tramo de carretera local	es
180	204	8	Colección	es
181	206	8	Restriction	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
3	http://www.w3.org/ns/org#Site	24415	\N	t	37	Site	Site	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21975
75	http://www.openlinksw.com/schemas/Image#	2	\N	t	90			896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
2	http://www.w3.org/2002/07/owl#FunctionalProperty	89	\N	t	7	FunctionalProperty	FunctionalProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	77
4	http://purl.org/linked-data/cube#dataSet	3478	\N	t	70	dataSet	dataSet	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5150966
5	http://purl.org/linked-data/cube#DataSet	1276	\N	t	70	DataSet	DataSet	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5051711
6	http://purl.org/linked-data/cube#DataStructureDefinition	577	\N	t	70	DataStructureDefinition	DataStructureDefinition	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1916
7	http://xmlns.com/foaf/0.1/Organization	35	\N	t	8	Organization	Organization	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1335
8	http://purl.org/linked-data/cube#MeasureProperty	1057	\N	t	70	MeasureProperty	MeasureProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4747
9	http://dbpedia.org/ontology/ObservationSet	3002	\N	t	10	ObservationSet	ObservationSet	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
10	http://opendata.aragon.es/def/Aragopedia#ComunidadAutonoma	1	\N	t	78	ComunidadAutonoma	ComunidadAutonoma	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	181601
11	http://icearagon.aragon.es/def/landscape#FeatureUnidadFisiográfica	35715	\N	t	79	FeatureUnidadFisiográfica	FeatureUnidadFisiográfica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	35715
12	http://www.w3.org/2004/02/skos/core#Collection	1	\N	t	4	Collection	Collection	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
13	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	t	80	C_AKJ315005-tax	C_AKJ315005-tax	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
14	http://www.openlinksw.com/schemas/VSPX#	1	\N	t	81			896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
15	http://crossforest.eu/ifi/ontology/InfoDominantFormation	67	\N	t	82	InfoDominantFormation	InfoDominantFormation	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67
16	http://icearagon.aragon.es/def/core#CartografiaRegistrada	1	\N	t	83	CartografiaRegistrada	CartografiaRegistrada	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://icearagon.aragon.es/def/core#DIT	1	\N	t	83	DIT	DIT	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://icearagon.aragon.es/def/core#WMS	1	\N	t	83	WMS	WMS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
19	http://icearagon.aragon.es/def/hydro#Paso_elevado	4225	\N	t	84	Paso_elevado	Paso_elevado	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
20	http://icearagon.aragon.es/def/hydro#Acueducto	297	\N	t	84	Acueducto	Acueducto	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://data.tbfy.eu/ontology/ocds#Value	3282	\N	t	86	Value	Value	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3282
23	http://www.w3.org/2002/07/owl#AnnotationProperty	36	\N	t	7	AnnotationProperty	AnnotationProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	106
24	http://data.europa.eu/eli/ontology#LegalExpression	7452	\N	t	87	LegalExpression	LegalExpression	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14904
25	http://www.w3.org/ns/dcat#Dataset	1357	\N	t	15	Dataset	Dataset	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122802
26	http://www.w3.org/2002/07/owl#Thing	27929	\N	t	7	Thing	Thing	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3823784
27	http://dbpedia.org/ontology/Place	768	\N	t	10	Place	Place	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
28	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
29	http://icearagon.aragon.es/def/health#CentroAtencionPrimaria	995	\N	t	88	CentroAtencionPrimaria	CentroAtencionPrimaria	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
30	http://icearagon.aragon.es/def/health#Optica	276	\N	t	88	Optica	Optica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
31	http://icearagon.aragon.es/def/core#CartografiaTopograficaBasica	1	\N	t	83	CartografiaTopograficaBasica	CartografiaTopograficaBasica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
32	http://icearagon.aragon.es/def/core#Datum	1	\N	t	83	Datum	Datum	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
33	http://icearagon.aragon.es/def/core#Geografia	1	\N	t	83	Geografia	Geografia	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
34	http://icearagon.aragon.es/def/core#InfraestructuraDeDatosEspaciales	1	\N	t	83	InfraestructuraDeDatosEspaciales	InfraestructuraDeDatosEspaciales	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
35	http://icearagon.aragon.es/def/core#RedDeTransportes	1	\N	t	83	RedDeTransportes	RedDeTransportes	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
204	http://icearagon.aragon.es/def/core#Coleccion	115	\N	t	83	Coleccion	Coleccion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
21	http://icearagon.aragon.es/def/transport#Tramo_Autopista	49	\N	t	85	Tramo_Autopista	[Tramo de autopista (Tramo_Autopista)]	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
36	http://icearagon.aragon.es/def/transport#Tramo_CarreteraNacional	1594	\N	t	85	Tramo_CarreteraNacional	[Tramo de carretera nacional (Tramo_CarreteraNacional)]	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
37	http://icearagon.aragon.es/def/core#Municipio	731	\N	t	83	Municipio	Municipio	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	193502
38	http://www.w3.org/2002/07/owl#TransitiveProperty	2	\N	t	7	TransitiveProperty	TransitiveProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
39	http://icearagon.aragon.es/def/landscape#FeatureUnidadDelPaisaje	4473	\N	t	79	FeatureUnidadDelPaisaje	FeatureUnidadDelPaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3551
40	http://purl.org/linked-data/cube#DimensionProperty	417	\N	t	70	DimensionProperty	DimensionProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1899
41	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	4	\N	t	7	inverseFunctionalProperty	inverseFunctionalProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
42	http://schema.org/AdministrativeArea	768	\N	t	9	AdministrativeArea	AdministrativeArea	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
43	http://icearagon.aragon.es/def/hydro#Glaciar	13	\N	t	84	Glaciar	Glaciar	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
44	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
45	http://icearagon.aragon.es/def/health#CentroReconocimientoMedico	83	\N	t	88	CentroReconocimientoMedico	CentroReconocimientoMedico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
46	http://www.w3.org/2002/07/owl#SymmetricProperty	3	\N	t	7	SymmetricProperty	SymmetricProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
47	http://icearagon.aragon.es/def/core#Atlas	1	\N	t	83	Atlas	Atlas	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
48	http://icearagon.aragon.es/def/core#Geoportal	1	\N	t	83	Geoportal	Geoportal	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
49	http://icearagon.aragon.es/def/core#Paisaje	1	\N	t	83	Paisaje	Paisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
50	http://icearagon.aragon.es/def/core#MunicipioHistorico	262	\N	t	83	MunicipioHistorico	MunicipioHistorico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	100
51	http://icearagon.aragon.es/def/hydro#Presa	2061	\N	t	84	Presa	Presa	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://icearagon.aragon.es/def/hydro#Laguna	862	\N	t	84	Laguna	Laguna	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
54	http://icearagon.aragon.es/def/hydro#Embalse	128	\N	t	84	Embalse	Embalse	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
55	http://www.w3.org/ns/prov#SoftwareAgent	1	\N	t	26	SoftwareAgent	SoftwareAgent	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	822
56	http://icearagon.aragon.es/def/core#ComunidadAutonoma	1	\N	t	83	ComunidadAutonoma	ComunidadAutonoma	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2144
57	http://www.w3.org/2002/07/owl#Class	852	\N	t	7	Class	Class	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7155591
58	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
59	http://www.w3.org/2004/02/skos/core#Concept	19618	\N	t	4	Concept	Concept	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22104092
60	http://data.europa.eu/eli/ontology#LegalResource	7452	\N	t	87	LegalResource	LegalResource	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7452
61	http://data.europa.eu/eli/ontology#Format	7452	\N	t	87	Format	Format	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7452
62	http://www.w3.org/ns/org#Organization	33210	\N	t	37	Organization	Organization	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	418069
63	http://dbpedia.org/ontology/AdministrativeRegion	768	\N	t	10	AdministrativeRegion	AdministrativeRegion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
64	http://dbpedia.org/ontology/Municipality	731	\N	t	10	Municipality	Municipality	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1955913
65	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	4	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
66	http://www.opengis.net/ont/sf#Point	797	\N	t	76	Point	Point	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	797
67	http://data.tbfy.eu/ontology/ocds#Contract	3453	\N	t	86	Contract	Contract	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
68	http://icearagon.aragon.es/def/landscape#FeatureGeofotoPaisaje	4216	\N	t	79	FeatureGeofotoPaisaje	FeatureGeofotoPaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
69	http://icearagon.aragon.es/def/landscape#FeatureGranDominioDePaisaje	30	\N	t	79	FeatureGranDominioDePaisaje	FeatureGranDominioDePaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3607
70	http://icearagon.aragon.es/def/landscape#FeatureRegionDePaisaje	181	\N	t	79	FeatureRegionDePaisaje	FeatureRegionDePaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4363
71	http://icearagon.aragon.es/def/hydro#Helero	17	\N	t	84	Helero	Helero	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
72	http://icearagon.aragon.es/def/hydro#Subcuenca_Hidrográfica	35	\N	t	84	Subcuenca_Hidrográfica	Subcuenca_Hidrográfica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78210
73	http://icearagon.aragon.es/def/bca#CorArtPol	1	\N	t	89	CorArtPol	CorArtPol	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
74	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	t	80	C_AAB316003-tax	C_AAB316003-tax	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
76	http://crossforest.eu/ifi/ontology/infoDominantFormation	67	\N	t	82	infoDominantFormation	infoDominantFormation	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67
77	http://icearagon.aragon.es/def/core#CSW	1	\N	t	83	CSW	CSW	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
78	http://icearagon.aragon.es/def/core#CatalogoDeMetadatos	1	\N	t	83	CatalogoDeMetadatos	CatalogoDeMetadatos	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
79	http://icearagon.aragon.es/def/core#ModeloDigitalDeElevaciones	1	\N	t	83	ModeloDigitalDeElevaciones	ModeloDigitalDeElevaciones	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
80	http://icearagon.aragon.es/def/hydro#Canal	49	\N	t	84	Canal	Canal	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	838
81	http://icearagon.aragon.es/def/transport#CarreteraLocal	1	\N	t	85	CarreteraLocal	CarreteraLocal	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
82	http://icearagon.aragon.es/def/hydro#Río	226	\N	t	84	Río	Río	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1379
83	http://www.w3.org/2000/01/rdf-schema#Datatype	1	\N	t	2	Datatype	Datatype	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
84	http://www.w3.org/2002/07/owl#Ontology	10	\N	t	7	Ontology	Ontology	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
85	http://www.w3.org/ns/org#Post	3164	\N	t	37	Post	Post	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6007
86	http://purl.org/linked-data/cube#CodedProperty	354	\N	t	70	CodedProperty	CodedProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1836
87	http://icearagon.aragon.es/def/ps#FeatureENP	25	\N	t	91	FeatureENP	FeatureENP	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30
88	http://icearagon.aragon.es/def/hydro#Cuenca_Hidrográfica	3	\N	t	84	Cuenca_Hidrográfica	Cuenca_Hidrográfica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78278
89	http://geo.linkeddata.es/ontology/Cuenca_Hidrográfica	3	\N	t	92	Cuenca_Hidrográfica	Cuenca_Hidrográfica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78278
90	http://icearagon.aragon.es/def/landscape#FeatureMacroUnidadDePaisaje	913	\N	t	79	FeatureMacroUnidadDePaisaje	FeatureMacroUnidadDePaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2924
91	http://icearagon.aragon.es/def/education#CentroEducativo	896	\N	t	93	CentroEducativo	CentroEducativo	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53
92	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
93	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
94	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	t	80	C_AKE112003-tax	C_AKE112003-tax	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
95	http://icearagon.aragon.es/def/health#ClinicaDental	614	\N	t	88	ClinicaDental	ClinicaDental	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
96	http://icearagon.aragon.es/def/health#Botiquin	321	\N	t	88	Botiquin	Botiquin	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
97	http://icearagon.aragon.es/def/health#BancoTejidos	2	\N	t	88	BancoTejidos	BancoTejidos	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
98	http://icearagon.aragon.es/def/core#WFS	1	\N	t	83	WFS	WFS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
100	http://icearagon.aragon.es/def/hydro#Almacenamiento_de_agua	6	\N	t	84	Almacenamiento_de_agua	Almacenamiento_de_agua	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
101	http://icearagon.aragon.es/def/bca#Aerogenerador	2511	\N	t	89	Aerogenerador	Aerogenerador	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
102	http://purl.org/dc/dcmitype/Text	2994	\N	t	77	Text	Text	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
103	http://www.w3.org/2002/07/owl#AllDisjointClasses	119	\N	t	7	AllDisjointClasses	AllDisjointClasses	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
104	http://purl.org/linked-data/cube#Observation	5224176	\N	t	70	Observation	Observation	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48314
105	http://schema.org/CreativeWork	1364340	\N	t	9	CreativeWork	CreativeWork	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
106	http://www.w3.org/ns/sosa/Featureofinterest	22514	\N	t	94	Featureofinterest	Featureofinterest	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
107	http://www.w3.org/ns/dcat#Distribution	2888	\N	t	15	Distribution	Distribution	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	125525
108	http://xmlns.com/foaf/0.1/Person	6016	\N	t	8	Person	Person	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2887
109	http://www.w3.org/ns/org#Role	2106	\N	t	37	Role	Role	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4487
110	http://dbpedia.org/ontology/GovernmentalAdministrativeRegion	768	\N	t	10	GovernmentalAdministrativeRegion	GovernmentalAdministrativeRegion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
111	http://dbpedia.org/ontology/Province	3	\N	t	10	Province	Province	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	651073
112	http://vocab.linkeddata.es/datosabiertos/def/medio-ambiente/meteorologia#Estacion	14	\N	t	95	Estacion	Estacion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
113	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
114	http://www.w3.org/2002/07/owl#IrreflexiveProperty	6	\N	t	7	IrreflexiveProperty	IrreflexiveProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
115	http://icearagon.aragon.es/def/health#CentroDiagnostico	43	\N	t	88	CentroDiagnostico	CentroDiagnostico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
116	http://icearagon.aragon.es/def/core#CartografiaOficial	1	\N	t	83	CartografiaOficial	CartografiaOficial	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
117	http://icearagon.aragon.es/def/core#CartografiaTematica	1	\N	t	83	CartografiaTematica	CartografiaTematica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
118	http://icearagon.aragon.es/def/core#CartografiaTopografica	1	\N	t	83	CartografiaTopografica	CartografiaTopografica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
119	http://icearagon.aragon.es/def/core#Metadato	1	\N	t	83	Metadato	Metadato	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
120	http://icearagon.aragon.es/def/core#UsoDelSuelo	1	\N	t	83	UsoDelSuelo	UsoDelSuelo	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
121	http://icearagon.aragon.es/def/core#WFS-g	1	\N	t	83	WFS-g	WFS-g	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
122	http://icearagon.aragon.es/def/core#WPS	1	\N	t	83	WPS	WPS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
123	http://icearagon.aragon.es/def/core#Provincia	3	\N	t	83	Provincia	Provincia	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	58090
124	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	1545	\N	t	1	Property	Property	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6552
125	http://www.w3.org/2002/07/owl#ObjectProperty	135	\N	t	7	ObjectProperty	ObjectProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3566
126	http://www.w3.org/ns/prov#Activity	821	\N	t	26	Activity	Activity	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2839313
127	http://www.w3.org/2006/vcard/ns#Location	50136	\N	t	39	Location	Location	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26270
128	http://www.w3.org/ns/sosa/Observation	32320	\N	t	94	Observation	Observation	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25120
129	http://www.w3.org/2004/02/skos/core#ConceptScheme	350	\N	t	4	ConceptScheme	ConceptScheme	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	38306
130	http://icearagon.aragon.es/def/health#SectorSanitario	8	\N	t	88	SectorSanitario	SectorSanitario	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	124
131	http://opendata.aragon.es/def/Aragopedia#Comarca	33	\N	t	78	Comarca	Comarca	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	986883
132	http://schema.org/Place	768	\N	t	9	Place	Place	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
133	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
134	http://schema.org/Event	1496	\N	t	9	Event	Event	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
135	http://icearagon.aragon.es/def/core#InformacionGeografica	1	\N	t	83	InformacionGeografica	InformacionGeografica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
136	http://icearagon.aragon.es/def/core#NomenclatorGeografico	1	\N	t	83	NomenclatorGeografico	NomenclatorGeografico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
137	http://icearagon.aragon.es/def/core#ServicioDeInformacionGeografica	1	\N	t	83	ServicioDeInformacionGeografica	ServicioDeInformacionGeografica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
138	http://icearagon.aragon.es/def/core#WCS	1	\N	t	83	WCS	WCS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
139	http://icearagon.aragon.es/def/core#WMTS	1	\N	t	83	WMTS	WMTS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
140	http://icearagon.aragon.es/def/transport#Tramo	95	\N	t	85	Tramo	Tramo	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
141	http://icearagon.aragon.es/def/transport#Autopista	2	\N	t	85	Autopista	Autopista	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	116
142	http://purl.org/dc/terms/PeriodOfTime	313399	\N	t	5	PeriodOfTime	PeriodOfTime	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	313399
143	http://www.w3.org/2001/vcard-rdf/3.0#internet	2	\N	t	96	internet	internet	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
144	http://icearagon.aragon.es/def/health#ZonaBasicaSalud	124	\N	t	88	ZonaBasicaSalud	ZonaBasicaSalud	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6472
145	http://dbpedia.org/ontology/Region	768	\N	t	10	Region	Region	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
146	http://icearagon.aragon.es/def/health#EstablecimientoAudioprotesis	105	\N	t	88	EstablecimientoAudioprotesis	EstablecimientoAudioprotesis	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
147	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
148	http://icearagon.aragon.es/def/health#Ortopedia	85	\N	t	88	Ortopedia	Ortopedia	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
149	http://icearagon.aragon.es/def/core#Cuadricula	1	\N	t	83	Cuadricula	Cuadricula	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
150	http://icearagon.aragon.es/def/core#Geomatica	1	\N	t	83	Geomatica	Geomatica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
151	http://icearagon.aragon.es/def/core#Grid	1	\N	t	83	Grid	Grid	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
152	http://icearagon.aragon.es/def/core#Hidrografia	1	\N	t	83	Hidrografia	Hidrografia	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
153	http://icearagon.aragon.es/def/core#InfraestructuraDeConocimientoGeografico	1	\N	t	83	InfraestructuraDeConocimientoGeografico	InfraestructuraDeConocimientoGeografico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
154	http://icearagon.aragon.es/def/core#UnidadAdministrativa	1	\N	t	83	UnidadAdministrativa	UnidadAdministrativa	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
156	http://icearagon.aragon.es/def/transport#CarreteraNacional	24	\N	t	85	CarreteraNacional	CarreteraNacional	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2153
157	http://www.w3.org/2006/vcard/ns#Organization	362677	\N	t	39	Organization	Organization	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1237
158	http://www.w3.org/2002/07/owl#DatatypeProperty	99	\N	t	7	DatatypeProperty	DatatypeProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	215
159	http://www.w3.org/2006/time#Instant	588	\N	t	71	Instant	Instant	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5214600
160	http://www.europeana.eu/schemas/edm/Place	393	\N	t	74	Place	Place	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	643
161	http://icearagon.aragon.es/def/core#Personaje	2834	\N	t	83	Personaje	Personaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
162	http://icearagon.aragon.es/def/landscape#MapaDominiosDePaisaje	30	\N	t	79	MapaDominiosDePaisaje	MapaDominiosDePaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
163	http://icearagon.aragon.es/def/education#ZonaEducativa	19	\N	t	93	ZonaEducativa	ZonaEducativa	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
164	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
165	http://icearagon.aragon.es/def/health#ConsultaMedica	674	\N	t	88	ConsultaMedica	ConsultaMedica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
166	http://icearagon.aragon.es/def/core#NormaCartograficaDeAragon	1	\N	t	83	NormaCartograficaDeAragon	NormaCartograficaDeAragon	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	46
167	http://icearagon.aragon.es/def/core#CartografiaDerivada	1	\N	t	83	CartografiaDerivada	CartografiaDerivada	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
168	http://icearagon.aragon.es/def/core#Geodato	1	\N	t	83	Geodato	Geodato	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
169	http://icearagon.aragon.es/def/core#SIG	1	\N	t	83	SIG	SIG	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
170	http://icearagon.aragon.es/def/hydro#Tramo_de_cauce_artificial	21137	\N	t	84	Tramo_de_cauce_artificial	Tramo_de_cauce_artificial	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
171	http://icearagon.aragon.es/def/transport#Autovía	10	\N	t	85	Autovía	Autovía	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2055
172	http://www.w3.org/2001/vcard-rdf/3.0#work	2	\N	t	96	work	work	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
173	http://www.w3.org/2001/vcard-rdf/3.0#voice	2	\N	t	96	voice	voice	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
174	http://icearagon.aragon.es/def/landscape#FeatureVideoPaisaje	281	\N	t	79	FeatureVideoPaisaje	FeatureVideoPaisaje	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
175	http://dbpedia.org/ontology/PopulatedPlace	768	\N	t	10	PopulatedPlace	PopulatedPlace	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3775470
176	http://data.tbfy.eu/ontology/ocds#Period	3453	\N	t	86	Period	Period	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3453
177	http://purl.org/linked-data/cube#ComponentSpecification	11	\N	t	70	ComponentSpecification	ComponentSpecification	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
178	http://www.openlinksw.com/ontology/acl#Scope	1	\N	t	97	Scope	Scope	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
179	http://icearagon.aragon.es/def/health#Hospital	30	\N	t	88	Hospital	Hospital	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
180	http://icearagon.aragon.es/def/health#CentroSaludMental	34	\N	t	88	CentroSaludMental	CentroSaludMental	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
181	http://icearagon.aragon.es/def/core#CartografiaTopograficaDerivada	1	\N	t	83	CartografiaTopograficaDerivada	CartografiaTopograficaDerivada	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
182	http://icearagon.aragon.es/def/core#Direccion	1	\N	t	83	Direccion	Direccion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
183	http://icearagon.aragon.es/def/core#ParcelaCatastral	1	\N	t	83	ParcelaCatastral	ParcelaCatastral	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
184	http://icearagon.aragon.es/def/core#SRS	1	\N	t	83	SRS	SRS	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
185	http://www.wikidata.org/entity/Q60533375	34	\N	t	12	Q60533375	Q60533375	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
186	http://icearagon.aragon.es/def/hydro#Tuberia_servicio	1207	\N	t	84	Tuberia_servicio	Tuberia_servicio	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
187	http://icearagon.aragon.es/def/transport#Tramo_Túnel	6	\N	t	85	Tramo_Túnel	Tramo_Túnel	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
188	http://icearagon.aragon.es/def/transport#RAA_I	2	\N	t	85	RAA_I	RAA_I	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28
189	http://www.w3.org/2000/01/rdf-schema#Class	56	\N	t	2	Class	Class	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1694
190	http://www.w3.org/2002/07/owl#NamedIndividual	66140	\N	t	7	NamedIndividual	NamedIndividual	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	80273
191	http://www.w3.org/2003/01/geo/wgs84_pos#Point	14	\N	t	25	Point	Point	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
192	http://icearagon.aragon.es/def/bca#educativo	1	\N	t	89	educativo	educativo	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
193	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	t	36	BusinessEntity	BusinessEntity	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
194	http://crossforest.eu/ifi/ontology/DominantFormation	67	\N	t	82	DominantFormation	DominantFormation	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67
195	http://icearagon.aragon.es/def/health#CentroSanitario	2503	\N	t	88	CentroSanitario	CentroSanitario	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
196	http://icearagon.aragon.es/def/health#Farmacia	730	\N	t	88	Farmacia	Farmacia	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
197	http://icearagon.aragon.es/def/core#CubiertaTerrestre	1	\N	t	83	CubiertaTerrestre	CubiertaTerrestre	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
198	http://icearagon.aragon.es/def/core#NombreGeografico	1	\N	t	83	NombreGeografico	NombreGeografico	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
199	http://icearagon.aragon.es/def/core#NucleoDePoblacion	1	\N	t	83	NucleoDePoblacion	NucleoDePoblacion	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
200	http://icearagon.aragon.es/def/core#Ortofoto	1	\N	t	83	Ortofoto	Ortofoto	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
201	http://icearagon.aragon.es/def/core#RedGeodesica	1	\N	t	83	RedGeodesica	RedGeodesica	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
202	http://icearagon.aragon.es/def/transport#Tramo_Accesos	1838	\N	t	85	Tramo_Accesos	Tramo_Accesos	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
203	http://icearagon.aragon.es/def/transport#Tramo_CarreteraLocal	14	\N	t	85	Tramo_CarreteraLocal	Tramo_CarreteraLocal	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
205	http://www.w3.org/2002/07/owl#AsymmetricProperty	2	\N	t	7	AsymmetricProperty	AsymmetricProperty	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
206	http://www.w3.org/2002/07/owl#Restriction	116	\N	t	7	Restriction	Restriction	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	116
52	http://icearagon.aragon.es/def/transport#Tramo_RAA_I	20	\N	t	85	Tramo_RAA_I	[Tramo de la Red Autonómica de Aragón I (Tramo_RAA_I)]	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
99	http://icearagon.aragon.es/def/hydro#Tramo_de_río	48062	\N	t	84	Tramo_de_río	[Tramo de un río (Tramo_de_río)]	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
155	http://icearagon.aragon.es/def/transport#Tramo_Autovía	798	\N	t	85	Tramo_Autovía	[Tramo de autovía (Tramo_Autovía)]	896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	104	1	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2	26	1	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
3	105	2	2	1353507	\N	0	\N	\N	1	1	2	f	1353507	\N	\N
4	134	2	2	1500	\N	0	\N	\N	2	1	2	f	1500	\N	\N
5	190	2	2	65977	\N	0	\N	\N	0	1	2	f	65977	\N	\N
6	108	3	2	6020	\N	0	\N	\N	1	1	2	f	6020	\N	\N
7	161	3	2	2834	\N	0	\N	\N	2	1	2	f	2834	\N	\N
8	7	3	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
9	55	3	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
10	91	4	2	566	\N	0	\N	\N	1	1	2	f	566	\N	\N
11	85	5	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
12	104	6	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
13	104	7	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
14	160	8	2	2068	\N	0	\N	\N	1	1	2	f	2068	\N	\N
15	159	9	2	588	\N	0	\N	\N	1	1	2	f	588	\N	\N
16	104	10	2	7605	\N	0	\N	\N	1	1	2	f	7605	\N	\N
17	104	11	2	1515	\N	1515	\N	\N	1	1	2	f	0	\N	\N
18	59	11	1	3030	\N	3030	\N	\N	1	1	2	f	\N	\N	\N
19	104	12	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
20	104	13	2	32162	\N	0	\N	\N	1	1	2	f	32162	\N	\N
21	104	14	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
22	99	15	2	144186	\N	144186	\N	\N	1	1	2	f	0	\N	\N
23	170	15	2	63411	\N	63411	\N	\N	2	1	2	f	0	\N	\N
24	11	15	2	35715	\N	35715	\N	\N	3	1	2	f	0	\N	\N
25	19	15	2	12675	\N	12675	\N	\N	4	1	2	f	0	\N	\N
26	68	15	2	8432	\N	7649	\N	\N	5	1	2	f	783	\N	\N
27	51	15	2	6183	\N	6183	\N	\N	6	1	2	f	0	\N	\N
28	39	15	2	4473	\N	4473	\N	\N	7	1	2	f	0	\N	\N
29	186	15	2	3621	\N	3621	\N	\N	8	1	2	f	0	\N	\N
30	195	15	2	2503	\N	2503	\N	\N	9	1	2	f	0	\N	\N
31	53	15	2	1724	\N	1724	\N	\N	10	1	2	f	0	\N	\N
32	37	15	2	1462	\N	1462	\N	\N	11	1	2	f	0	\N	\N
33	25	15	2	1335	\N	1335	\N	\N	12	1	2	f	0	\N	\N
34	29	15	2	994	\N	994	\N	\N	13	1	2	f	0	\N	\N
35	90	15	2	973	\N	973	\N	\N	14	1	2	f	0	\N	\N
36	91	15	2	896	\N	0	\N	\N	15	1	2	f	896	\N	\N
37	20	15	2	891	\N	891	\N	\N	16	1	2	f	0	\N	\N
38	196	15	2	730	\N	730	\N	\N	17	1	2	f	0	\N	\N
39	165	15	2	674	\N	674	\N	\N	18	1	2	f	0	\N	\N
40	95	15	2	614	\N	614	\N	\N	19	1	2	f	0	\N	\N
41	174	15	2	562	\N	562	\N	\N	20	1	2	f	0	\N	\N
42	82	15	2	451	\N	451	\N	\N	21	1	2	f	0	\N	\N
43	96	15	2	320	\N	320	\N	\N	22	1	2	f	0	\N	\N
44	30	15	2	276	\N	276	\N	\N	23	1	2	f	0	\N	\N
45	54	15	2	256	\N	256	\N	\N	24	1	2	f	0	\N	\N
46	70	15	2	181	\N	181	\N	\N	25	1	2	f	0	\N	\N
47	146	15	2	105	\N	105	\N	\N	26	1	2	f	0	\N	\N
48	148	15	2	85	\N	85	\N	\N	27	1	2	f	0	\N	\N
49	45	15	2	83	\N	83	\N	\N	28	1	2	f	0	\N	\N
50	115	15	2	43	\N	43	\N	\N	29	1	2	f	0	\N	\N
51	180	15	2	34	\N	34	\N	\N	30	1	2	f	0	\N	\N
52	179	15	2	30	\N	30	\N	\N	31	1	2	f	0	\N	\N
53	190	15	2	30	\N	0	\N	\N	32	1	2	f	30	\N	\N
54	100	15	2	12	\N	12	\N	\N	33	1	2	f	0	\N	\N
55	84	15	2	7	\N	0	\N	\N	34	1	2	f	7	\N	\N
56	97	15	2	2	\N	2	\N	\N	35	1	2	f	0	\N	\N
57	62	15	2	1462	\N	1462	\N	\N	0	1	2	f	0	\N	\N
58	71	15	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
59	43	15	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
60	62	15	1	135826	\N	135826	\N	\N	1	1	2	f	\N	\N	\N
61	88	15	1	78210	\N	78210	\N	\N	2	1	2	f	\N	\N	\N
62	72	15	1	78210	\N	78210	\N	\N	3	1	2	f	\N	\N	\N
63	37	15	1	87190	\N	87190	\N	\N	0	1	2	f	\N	\N	\N
64	190	15	1	78210	\N	78210	\N	\N	0	1	2	f	\N	\N	\N
65	89	15	1	78210	\N	78210	\N	\N	0	1	2	f	\N	\N	\N
66	56	15	1	1335	\N	1335	\N	\N	0	1	2	f	\N	\N	\N
67	123	15	1	731	\N	731	\N	\N	0	1	2	f	\N	\N	\N
68	104	16	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
69	104	17	2	5504	\N	0	\N	\N	1	1	2	f	5504	\N	\N
70	126	18	2	822	\N	0	\N	\N	1	1	2	f	822	\N	\N
71	104	19	2	340	\N	0	\N	\N	1	1	2	f	340	\N	\N
72	104	20	2	17586	\N	0	\N	\N	1	1	2	f	17586	\N	\N
73	104	21	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
74	104	22	2	12285	\N	0	\N	\N	1	1	2	f	12285	\N	\N
75	104	23	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
76	104	24	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
77	36	25	2	715	\N	715	\N	\N	1	1	2	f	0	\N	\N
78	202	25	2	588	\N	588	\N	\N	2	1	2	f	0	\N	\N
79	155	25	2	360	\N	360	\N	\N	3	1	2	f	0	\N	\N
80	140	25	2	51	\N	51	\N	\N	4	1	2	f	0	\N	\N
81	52	25	2	16	\N	16	\N	\N	5	1	2	f	0	\N	\N
82	203	25	2	6	\N	6	\N	\N	6	1	2	f	0	\N	\N
83	21	25	2	6	\N	6	\N	\N	7	1	2	f	0	\N	\N
84	57	25	1	1737	\N	1737	\N	\N	1	1	2	f	\N	\N	\N
85	104	26	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
86	104	27	2	765	\N	0	\N	\N	1	1	2	f	765	\N	\N
87	62	28	2	13310	\N	0	\N	\N	1	1	2	f	13310	\N	\N
88	102	28	2	1519	\N	0	\N	\N	2	1	2	f	1519	\N	\N
89	185	28	2	32	\N	0	\N	\N	3	1	2	f	32	\N	\N
90	84	28	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
91	104	29	2	110940	\N	110940	\N	\N	1	1	2	f	0	\N	\N
92	59	29	1	221880	\N	221880	\N	\N	1	1	2	f	\N	\N	\N
93	104	30	2	732042	\N	732042	\N	\N	1	1	2	f	0	\N	\N
94	59	30	1	1464084	\N	1464084	\N	\N	1	1	2	f	\N	\N	\N
95	104	31	2	598201	\N	0	\N	\N	1	1	2	f	598201	\N	\N
96	104	32	2	43947	\N	0	\N	\N	1	1	2	f	43947	\N	\N
97	84	33	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
98	104	34	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
99	105	35	2	14352	\N	0	\N	\N	1	1	2	f	14352	\N	\N
100	104	36	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
101	104	37	2	18	\N	0	\N	\N	1	1	2	f	18	\N	\N
102	104	38	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
103	26	38	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
104	104	39	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
105	26	39	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
106	104	40	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
107	26	40	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
108	62	41	2	422	\N	0	\N	\N	1	1	2	f	422	\N	\N
109	104	42	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
110	26	42	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
111	104	43	2	96023	\N	0	\N	\N	1	1	2	f	96023	\N	\N
112	62	44	2	2026	\N	4	\N	\N	1	1	2	f	2022	\N	\N
113	193	44	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
114	190	44	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
115	104	45	2	12158	\N	12158	\N	\N	1	1	2	f	0	\N	\N
116	59	45	1	24316	\N	24316	\N	\N	1	1	2	f	\N	\N	\N
117	104	46	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
118	26	46	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
119	106	47	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
120	128	47	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
121	174	48	2	281	\N	281	\N	\N	1	1	2	f	0	\N	\N
122	104	49	2	64	\N	64	\N	\N	1	1	2	f	0	\N	\N
123	26	49	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
124	104	50	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
125	104	51	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
126	91	52	2	896	\N	896	\N	\N	1	1	2	f	0	\N	\N
127	59	52	1	896	\N	896	\N	\N	1	1	2	f	\N	\N	\N
128	190	52	1	896	\N	896	\N	\N	0	1	2	f	\N	\N	\N
129	25	53	2	1355	\N	1355	\N	\N	1	1	2	f	0	\N	\N
130	104	54	2	1983	\N	1983	\N	\N	1	1	2	f	0	\N	\N
131	59	54	1	3966	\N	3966	\N	\N	1	1	2	f	\N	\N	\N
132	60	55	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
133	70	56	2	4363	\N	4363	\N	\N	1	1	2	f	0	\N	\N
134	90	56	2	2924	\N	2924	\N	\N	2	1	2	f	0	\N	\N
135	104	57	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
136	176	58	2	171	\N	0	\N	\N	1	1	2	f	171	\N	\N
137	104	59	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
138	104	60	2	44941	\N	44941	\N	\N	1	1	2	f	0	\N	\N
139	59	60	1	89882	\N	89882	\N	\N	1	1	2	f	\N	\N	\N
140	57	61	1	785	\N	785	\N	\N	1	1	2	f	\N	\N	\N
141	190	61	1	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
142	204	62	2	115	\N	115	\N	\N	1	1	2	f	0	\N	\N
143	57	62	1	105	\N	105	\N	\N	1	1	2	f	\N	\N	\N
144	104	63	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
145	104	64	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
146	37	64	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
147	62	64	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
148	104	65	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
149	104	66	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
150	123	66	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
151	62	66	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
152	104	67	2	109468	\N	0	\N	\N	1	1	2	f	109468	\N	\N
153	104	68	2	11490	\N	0	\N	\N	1	1	2	f	11490	\N	\N
154	26	68	2	11490	\N	0	\N	\N	0	1	2	f	11490	\N	\N
155	107	69	2	2888	\N	0	\N	\N	1	1	2	f	2888	\N	\N
156	127	70	2	12637	\N	0	\N	\N	1	1	2	f	12637	\N	\N
157	104	71	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
158	104	72	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
159	104	73	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
160	104	74	2	883	\N	0	\N	\N	1	1	2	f	883	\N	\N
161	75	75	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
162	14	75	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
163	104	76	2	118028	\N	118028	\N	\N	1	1	2	f	0	\N	\N
164	59	76	1	236056	\N	236056	\N	\N	1	1	2	f	\N	\N	\N
165	104	77	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
166	26	77	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
167	104	78	2	2208	\N	0	\N	\N	1	1	2	f	2208	\N	\N
168	104	79	2	6994	\N	0	\N	\N	1	1	2	f	6994	\N	\N
169	104	80	2	36	\N	0	\N	\N	1	1	2	f	36	\N	\N
170	104	81	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
171	113	82	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
172	126	83	2	1217	\N	1217	\N	\N	1	1	2	f	0	\N	\N
173	55	83	1	822	\N	822	\N	\N	1	1	2	f	\N	\N	\N
174	25	83	1	179	\N	179	\N	\N	2	1	2	f	\N	\N	\N
175	107	83	1	7	\N	7	\N	\N	3	1	2	f	\N	\N	\N
176	104	84	2	1259	\N	1259	\N	\N	1	1	2	f	0	\N	\N
177	59	84	1	2518	\N	2518	\N	\N	1	1	2	f	\N	\N	\N
178	6	85	2	8856	\N	8856	\N	\N	1	1	2	f	0	\N	\N
179	5	85	2	4053	\N	4053	\N	\N	0	1	2	f	0	\N	\N
180	177	85	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
181	104	86	2	8335	\N	0	\N	\N	1	1	2	f	8335	\N	\N
182	104	87	2	3068	\N	3068	\N	\N	1	1	2	f	0	\N	\N
183	26	87	2	3068	\N	3068	\N	\N	0	1	2	f	0	\N	\N
184	104	88	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
185	104	89	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
186	104	90	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
187	104	91	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
188	104	92	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
189	104	93	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
190	104	94	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
191	104	95	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
192	102	96	2	1331	\N	0	\N	\N	1	1	2	f	1331	\N	\N
193	185	96	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
194	76	97	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
195	15	97	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
196	104	98	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
197	104	99	2	91871	\N	0	\N	\N	1	1	2	f	91871	\N	\N
198	104	100	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
199	104	101	2	175	\N	175	\N	\N	1	1	2	f	0	\N	\N
200	37	101	1	175	\N	175	\N	\N	1	1	2	f	\N	\N	\N
201	62	101	1	175	\N	175	\N	\N	0	1	2	f	\N	\N	\N
202	104	102	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
203	104	103	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
204	104	104	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
205	76	105	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
206	15	105	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
207	104	106	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
208	104	107	2	36	\N	0	\N	\N	1	1	2	f	36	\N	\N
209	104	109	2	6839	\N	0	\N	\N	1	1	2	f	6839	\N	\N
210	104	110	2	36476	\N	0	\N	\N	1	1	2	f	36476	\N	\N
211	11	111	2	35715	\N	0	\N	\N	1	1	2	f	35715	\N	\N
212	104	112	2	62640	\N	62640	\N	\N	1	1	2	f	0	\N	\N
213	59	112	1	125280	\N	125280	\N	\N	1	1	2	f	\N	\N	\N
214	104	113	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
215	26	113	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
216	104	114	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
217	104	115	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
218	104	116	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
219	24	117	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
220	61	117	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
221	104	118	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
222	104	119	2	940	\N	0	\N	\N	1	1	2	f	940	\N	\N
223	57	120	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
224	104	121	2	956	\N	0	\N	\N	1	1	2	f	956	\N	\N
225	85	122	2	476	\N	0	\N	\N	1	1	2	f	476	\N	\N
226	104	123	2	937	\N	937	\N	\N	1	1	2	f	0	\N	\N
227	37	123	1	937	\N	937	\N	\N	1	1	2	f	\N	\N	\N
228	62	123	1	937	\N	937	\N	\N	0	1	2	f	\N	\N	\N
229	104	124	2	940	\N	940	\N	\N	1	1	2	f	0	\N	\N
230	123	124	1	940	\N	940	\N	\N	1	1	2	f	\N	\N	\N
231	62	124	1	940	\N	940	\N	\N	0	1	2	f	\N	\N	\N
232	40	125	2	63	\N	0	\N	\N	1	1	2	f	63	\N	\N
233	8	125	2	38	\N	0	\N	\N	2	1	2	f	38	\N	\N
234	104	126	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
235	104	127	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
236	104	128	2	940	\N	0	\N	\N	1	1	2	f	940	\N	\N
237	104	129	2	4088	\N	4088	\N	\N	1	1	2	f	0	\N	\N
238	59	129	1	8176	\N	8176	\N	\N	1	1	2	f	\N	\N	\N
239	104	131	2	940	\N	0	\N	\N	1	1	2	f	940	\N	\N
240	104	132	2	7644	\N	0	\N	\N	1	1	2	f	7644	\N	\N
241	104	133	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
242	128	134	2	389	\N	0	\N	\N	1	1	2	f	389	\N	\N
243	104	135	2	8586	\N	0	\N	\N	1	1	2	f	8586	\N	\N
244	28	136	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
245	104	137	2	3066	\N	0	\N	\N	1	1	2	f	3066	\N	\N
246	108	138	2	82	\N	0	\N	\N	1	1	2	f	82	\N	\N
247	104	139	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
248	104	140	2	2819	\N	2819	\N	\N	1	1	2	f	0	\N	\N
249	59	140	1	5638	\N	5638	\N	\N	1	1	2	f	\N	\N	\N
250	160	141	2	807	\N	807	\N	\N	1	1	2	f	0	\N	\N
251	160	141	1	318	\N	318	\N	\N	1	1	2	f	\N	\N	\N
252	104	142	2	3144	\N	0	\N	\N	1	1	2	f	3144	\N	\N
253	9	143	2	24157	\N	24157	\N	\N	1	1	2	f	0	\N	\N
254	26	143	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
255	104	143	1	24157	\N	24157	\N	\N	1	1	2	f	\N	\N	\N
256	26	143	1	24157	\N	24157	\N	\N	0	1	2	f	\N	\N	\N
257	190	144	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
258	71	144	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
259	43	144	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
260	104	145	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
261	104	146	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
262	104	147	2	241813	\N	0	\N	\N	1	1	2	f	241813	\N	\N
263	104	148	2	5540	\N	0	\N	\N	1	1	2	f	5540	\N	\N
264	134	149	2	1537	\N	0	\N	\N	1	1	2	f	1537	\N	\N
265	104	150	2	128	\N	0	\N	\N	1	1	2	f	128	\N	\N
266	104	151	2	190441	\N	190441	\N	\N	1	1	2	f	0	\N	\N
267	59	151	1	380882	\N	380882	\N	\N	1	1	2	f	\N	\N	\N
268	104	152	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
269	161	153	2	8944	\N	0	\N	\N	1	1	2	f	8944	\N	\N
270	202	154	2	1838	\N	1838	\N	\N	1	1	2	f	0	\N	\N
271	36	154	2	1594	\N	1594	\N	\N	2	1	2	f	0	\N	\N
272	99	154	2	1380	\N	1380	\N	\N	3	1	2	f	0	\N	\N
273	170	154	2	837	\N	837	\N	\N	4	1	2	f	0	\N	\N
274	155	154	2	798	\N	798	\N	\N	5	1	2	f	0	\N	\N
275	160	154	2	367	\N	367	\N	\N	6	1	2	f	0	\N	\N
276	144	154	2	124	\N	124	\N	\N	7	1	2	f	0	\N	\N
277	140	154	2	95	\N	95	\N	\N	8	1	2	f	0	\N	\N
278	190	154	2	60	\N	60	\N	\N	9	1	2	f	0	\N	\N
279	21	154	2	49	\N	49	\N	\N	10	1	2	f	0	\N	\N
280	72	154	2	35	\N	35	\N	\N	11	1	2	f	0	\N	\N
281	52	154	2	20	\N	20	\N	\N	12	1	2	f	0	\N	\N
282	203	154	2	14	\N	14	\N	\N	13	1	2	f	0	\N	\N
283	187	154	2	6	\N	6	\N	\N	14	1	2	f	0	\N	\N
284	57	154	2	1	\N	1	\N	\N	15	1	2	f	0	\N	\N
285	71	154	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
286	43	154	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
287	156	154	1	2153	\N	2153	\N	\N	1	1	2	f	\N	\N	\N
288	171	154	1	2055	\N	2055	\N	\N	2	1	2	f	\N	\N	\N
289	82	154	1	1379	\N	1379	\N	\N	3	1	2	f	\N	\N	\N
290	80	154	1	838	\N	838	\N	\N	4	1	2	f	\N	\N	\N
291	160	154	1	320	\N	320	\N	\N	5	1	2	f	\N	\N	\N
292	130	154	1	124	\N	124	\N	\N	6	1	2	f	\N	\N	\N
293	141	154	1	116	\N	116	\N	\N	7	1	2	f	\N	\N	\N
294	88	154	1	65	\N	65	\N	\N	8	1	2	f	\N	\N	\N
295	87	154	1	30	\N	30	\N	\N	9	1	2	f	\N	\N	\N
296	188	154	1	28	\N	28	\N	\N	10	1	2	f	\N	\N	\N
297	81	154	1	11	\N	11	\N	\N	11	1	2	f	\N	\N	\N
298	57	154	1	1	\N	1	\N	\N	12	1	2	f	\N	\N	\N
299	190	154	1	65	\N	65	\N	\N	0	1	2	f	\N	\N	\N
300	89	154	1	65	\N	65	\N	\N	0	1	2	f	\N	\N	\N
301	102	156	2	160	\N	0	\N	\N	1	1	2	f	160	\N	\N
302	104	158	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
303	104	159	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
304	63	160	2	767	\N	767	\N	\N	1	1	2	f	0	\N	\N
305	26	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
306	110	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
307	27	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
308	175	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
309	145	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
310	42	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
311	132	160	2	767	\N	767	\N	\N	0	1	2	f	0	\N	\N
312	64	160	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
313	131	160	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
314	111	160	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
315	10	160	1	767	\N	767	\N	\N	1	1	2	f	\N	\N	\N
316	26	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
317	63	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
318	110	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
319	27	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
320	175	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
321	145	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
322	42	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
323	132	160	1	767	\N	767	\N	\N	0	1	2	f	\N	\N	\N
324	104	161	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
325	104	162	2	8560	\N	0	\N	\N	1	1	2	f	8560	\N	\N
326	104	163	2	6392	\N	0	\N	\N	1	1	2	f	6392	\N	\N
327	104	164	2	6181	\N	6181	\N	\N	1	1	2	f	0	\N	\N
328	59	164	1	12362	\N	12362	\N	\N	1	1	2	f	\N	\N	\N
329	104	165	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
330	104	166	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
331	142	167	1	313399	\N	313399	\N	\N	1	1	2	f	\N	\N	\N
332	104	168	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
333	104	169	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
334	104	170	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
335	104	171	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
336	104	172	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
337	57	173	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
338	57	173	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
339	104	174	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
340	104	175	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
341	40	176	2	63	\N	0	\N	\N	1	1	2	f	63	\N	\N
342	8	176	2	38	\N	0	\N	\N	2	1	2	f	38	\N	\N
343	104	177	2	4599	\N	0	\N	\N	1	1	2	f	4599	\N	\N
344	104	178	2	1469	\N	1469	\N	\N	1	1	2	f	0	\N	\N
345	59	178	1	2938	\N	2938	\N	\N	1	1	2	f	\N	\N	\N
346	104	179	2	11179	\N	0	\N	\N	1	1	2	f	11179	\N	\N
347	195	180	2	2481	\N	2481	\N	\N	1	1	2	f	0	\N	\N
348	202	180	2	1827	\N	1827	\N	\N	2	1	2	f	0	\N	\N
349	36	180	2	1813	\N	1813	\N	\N	3	1	2	f	0	\N	\N
350	29	180	2	995	\N	995	\N	\N	4	1	2	f	0	\N	\N
351	91	180	2	896	\N	896	\N	\N	5	1	2	f	0	\N	\N
352	155	180	2	891	\N	891	\N	\N	6	1	2	f	0	\N	\N
353	196	180	2	730	\N	730	\N	\N	7	1	2	f	0	\N	\N
354	165	180	2	674	\N	674	\N	\N	8	1	2	f	0	\N	\N
355	95	180	2	614	\N	614	\N	\N	9	1	2	f	0	\N	\N
356	96	180	2	321	\N	321	\N	\N	10	1	2	f	0	\N	\N
357	30	180	2	276	\N	276	\N	\N	11	1	2	f	0	\N	\N
358	146	180	2	104	\N	104	\N	\N	12	1	2	f	0	\N	\N
359	148	180	2	85	\N	85	\N	\N	13	1	2	f	0	\N	\N
360	45	180	2	83	\N	83	\N	\N	14	1	2	f	0	\N	\N
361	140	180	2	83	\N	83	\N	\N	15	1	2	f	0	\N	\N
362	21	180	2	70	\N	70	\N	\N	16	1	2	f	0	\N	\N
363	115	180	2	43	\N	43	\N	\N	17	1	2	f	0	\N	\N
364	180	180	2	34	\N	34	\N	\N	18	1	2	f	0	\N	\N
365	179	180	2	30	\N	30	\N	\N	19	1	2	f	0	\N	\N
366	52	180	2	21	\N	21	\N	\N	20	1	2	f	0	\N	\N
367	203	180	2	16	\N	16	\N	\N	21	1	2	f	0	\N	\N
368	187	180	2	9	\N	9	\N	\N	22	1	2	f	0	\N	\N
369	97	180	2	2	\N	2	\N	\N	23	1	2	f	0	\N	\N
370	144	180	1	6472	\N	6472	\N	\N	1	1	2	f	\N	\N	\N
371	37	180	1	5626	\N	5626	\N	\N	2	1	2	f	\N	\N	\N
372	62	180	1	5626	\N	5626	\N	\N	0	1	2	f	\N	\N	\N
373	104	181	2	722	\N	0	\N	\N	1	1	2	f	722	\N	\N
374	104	182	2	2126	\N	2126	\N	\N	1	1	2	f	0	\N	\N
375	59	182	1	4252	\N	4252	\N	\N	1	1	2	f	\N	\N	\N
376	104	183	2	644	\N	0	\N	\N	1	1	2	f	644	\N	\N
377	104	184	2	4923	\N	0	\N	\N	1	1	2	f	4923	\N	\N
378	161	185	2	2680	\N	0	\N	\N	1	1	2	f	2680	\N	\N
379	104	186	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
380	104	187	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
381	104	188	2	4905	\N	4905	\N	\N	1	1	2	f	0	\N	\N
382	37	188	1	4905	\N	4905	\N	\N	1	1	2	f	\N	\N	\N
383	62	188	1	4905	\N	4905	\N	\N	0	1	2	f	\N	\N	\N
384	104	189	2	4905	\N	0	\N	\N	1	1	2	f	4905	\N	\N
385	104	190	2	4400	\N	4400	\N	\N	1	1	2	f	0	\N	\N
386	59	190	1	8800	\N	8800	\N	\N	1	1	2	f	\N	\N	\N
387	127	191	2	227	\N	0	\N	\N	1	1	2	f	227	\N	\N
388	104	192	2	4908	\N	0	\N	\N	1	1	2	f	4908	\N	\N
389	104	193	2	7376	\N	7376	\N	\N	1	1	2	f	0	\N	\N
390	59	193	1	14752	\N	14752	\N	\N	1	1	2	f	\N	\N	\N
391	104	194	2	2228	\N	2228	\N	\N	1	1	2	f	0	\N	\N
392	59	194	1	4456	\N	4456	\N	\N	1	1	2	f	\N	\N	\N
393	104	195	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
394	104	196	2	4905	\N	0	\N	\N	1	1	2	f	4905	\N	\N
395	104	197	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
396	104	198	2	4905	\N	0	\N	\N	1	1	2	f	4905	\N	\N
397	104	199	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
398	59	199	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
399	28	200	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
400	133	200	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
401	104	201	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
402	59	201	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
403	104	202	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
404	104	203	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
405	24	204	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
406	60	204	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
407	104	205	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
408	59	206	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
409	59	206	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
410	104	207	2	787	\N	787	\N	\N	1	1	2	f	0	\N	\N
411	59	207	1	1574	\N	1574	\N	\N	1	1	2	f	\N	\N	\N
412	85	208	2	3164	\N	3164	\N	\N	1	1	2	f	0	\N	\N
413	109	208	1	3164	\N	3164	\N	\N	1	1	2	f	\N	\N	\N
414	104	209	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
415	104	210	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
416	59	210	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
417	12	211	2	297	\N	297	\N	\N	1	1	2	f	0	\N	\N
418	59	211	1	297	\N	297	\N	\N	1	1	2	f	\N	\N	\N
419	104	212	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
420	163	213	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
421	190	214	2	65977	\N	65977	\N	\N	1	1	2	f	0	\N	\N
422	105	214	2	65977	\N	65977	\N	\N	0	1	2	f	0	\N	\N
423	59	214	1	65977	\N	65977	\N	\N	1	1	2	f	\N	\N	\N
424	58	215	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
425	28	216	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
426	92	216	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
427	93	216	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
428	189	216	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
429	104	217	2	292971	\N	292971	\N	\N	1	1	2	f	0	\N	\N
430	59	217	1	585942	\N	585942	\N	\N	1	1	2	f	\N	\N	\N
431	104	218	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
432	59	218	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
433	104	219	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
434	161	220	2	2680	\N	0	\N	\N	1	1	2	f	2680	\N	\N
435	104	221	2	161	\N	0	\N	\N	1	1	2	f	161	\N	\N
436	104	222	2	3682	\N	0	\N	\N	1	1	2	f	3682	\N	\N
437	104	223	2	6508	\N	0	\N	\N	1	1	2	f	6508	\N	\N
438	104	224	2	590	\N	0	\N	\N	1	1	2	f	590	\N	\N
439	104	225	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
440	104	226	2	212	\N	0	\N	\N	1	1	2	f	212	\N	\N
441	104	227	2	183	\N	0	\N	\N	1	1	2	f	183	\N	\N
442	104	228	2	186	\N	0	\N	\N	1	1	2	f	186	\N	\N
443	104	229	2	113	\N	113	\N	\N	1	1	2	f	0	\N	\N
444	37	229	1	113	\N	113	\N	\N	1	1	2	f	\N	\N	\N
445	62	229	1	113	\N	113	\N	\N	0	1	2	f	\N	\N	\N
446	104	230	2	113	\N	113	\N	\N	1	1	2	f	0	\N	\N
447	123	230	1	113	\N	113	\N	\N	1	1	2	f	\N	\N	\N
448	62	230	1	113	\N	113	\N	\N	0	1	2	f	\N	\N	\N
449	104	231	2	97	\N	0	\N	\N	1	1	2	f	97	\N	\N
450	104	232	2	113	\N	0	\N	\N	1	1	2	f	113	\N	\N
451	104	233	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
452	104	234	2	3902	\N	3902	\N	\N	1	1	2	f	0	\N	\N
453	59	234	1	7804	\N	7804	\N	\N	1	1	2	f	\N	\N	\N
454	104	235	2	113	\N	0	\N	\N	1	1	2	f	113	\N	\N
455	104	236	2	113	\N	0	\N	\N	1	1	2	f	113	\N	\N
456	104	237	2	107	\N	0	\N	\N	1	1	2	f	107	\N	\N
457	99	238	2	48062	\N	0	\N	\N	1	1	2	f	48062	\N	\N
458	11	238	2	35715	\N	0	\N	\N	2	1	2	f	35715	\N	\N
459	170	238	2	21137	\N	0	\N	\N	3	1	2	f	21137	\N	\N
460	39	238	2	4474	\N	0	\N	\N	4	1	2	f	4474	\N	\N
461	19	238	2	4225	\N	0	\N	\N	5	1	2	f	4225	\N	\N
462	68	238	2	4216	\N	783	\N	\N	6	1	2	f	3433	\N	\N
463	195	238	2	2503	\N	0	\N	\N	7	1	2	f	2503	\N	\N
464	51	238	2	2061	\N	0	\N	\N	8	1	2	f	2061	\N	\N
465	202	238	2	1838	\N	0	\N	\N	9	1	2	f	1838	\N	\N
466	36	238	2	1594	\N	0	\N	\N	10	1	2	f	1594	\N	\N
467	186	238	2	1207	\N	0	\N	\N	11	1	2	f	1207	\N	\N
468	29	238	2	995	\N	0	\N	\N	12	1	2	f	995	\N	\N
469	90	238	2	913	\N	0	\N	\N	13	1	2	f	913	\N	\N
470	91	238	2	896	\N	0	\N	\N	14	1	2	f	896	\N	\N
471	53	238	2	862	\N	0	\N	\N	15	1	2	f	862	\N	\N
472	155	238	2	798	\N	0	\N	\N	16	1	2	f	798	\N	\N
473	62	238	2	735	\N	0	\N	\N	17	1	2	f	735	\N	\N
474	196	238	2	730	\N	0	\N	\N	18	1	2	f	730	\N	\N
475	165	238	2	674	\N	0	\N	\N	19	1	2	f	674	\N	\N
476	95	238	2	614	\N	0	\N	\N	20	1	2	f	614	\N	\N
477	96	238	2	321	\N	0	\N	\N	21	1	2	f	321	\N	\N
478	20	238	2	297	\N	0	\N	\N	22	1	2	f	297	\N	\N
479	174	238	2	281	\N	0	\N	\N	23	1	2	f	281	\N	\N
480	30	238	2	276	\N	0	\N	\N	24	1	2	f	276	\N	\N
481	82	238	2	226	\N	0	\N	\N	25	1	2	f	226	\N	\N
482	70	238	2	181	\N	0	\N	\N	26	1	2	f	181	\N	\N
483	144	238	2	132	\N	0	\N	\N	27	1	2	f	132	\N	\N
484	54	238	2	128	\N	0	\N	\N	28	1	2	f	128	\N	\N
485	146	238	2	105	\N	0	\N	\N	29	1	2	f	105	\N	\N
486	140	238	2	95	\N	0	\N	\N	30	1	2	f	95	\N	\N
487	148	238	2	85	\N	0	\N	\N	31	1	2	f	85	\N	\N
488	45	238	2	83	\N	0	\N	\N	32	1	2	f	83	\N	\N
489	80	238	2	49	\N	0	\N	\N	33	1	2	f	49	\N	\N
490	21	238	2	49	\N	0	\N	\N	34	1	2	f	49	\N	\N
491	115	238	2	43	\N	0	\N	\N	35	1	2	f	43	\N	\N
492	72	238	2	35	\N	0	\N	\N	36	1	2	f	35	\N	\N
493	180	238	2	34	\N	0	\N	\N	37	1	2	f	34	\N	\N
494	69	238	2	30	\N	0	\N	\N	38	1	2	f	30	\N	\N
495	179	238	2	30	\N	0	\N	\N	39	1	2	f	30	\N	\N
496	87	238	2	25	\N	0	\N	\N	40	1	2	f	25	\N	\N
497	52	238	2	20	\N	0	\N	\N	41	1	2	f	20	\N	\N
498	163	238	2	19	\N	0	\N	\N	42	1	2	f	19	\N	\N
499	203	238	2	14	\N	0	\N	\N	43	1	2	f	14	\N	\N
500	130	238	2	8	\N	0	\N	\N	44	1	2	f	8	\N	\N
501	187	238	2	6	\N	0	\N	\N	45	1	2	f	6	\N	\N
502	100	238	2	6	\N	0	\N	\N	46	1	2	f	6	\N	\N
503	88	238	2	3	\N	0	\N	\N	47	1	2	f	3	\N	\N
504	97	238	2	2	\N	0	\N	\N	48	1	2	f	2	\N	\N
505	37	238	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
506	190	238	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
507	89	238	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
508	123	238	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
509	56	238	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
510	66	238	1	783	\N	783	\N	\N	1	1	2	f	\N	\N	\N
511	176	239	2	171	\N	0	\N	\N	1	1	2	f	171	\N	\N
512	190	240	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
513	71	240	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
514	43	240	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
515	14	241	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
516	107	242	2	2835	\N	0	\N	\N	1	1	2	f	2835	\N	\N
517	25	242	2	2670	\N	0	\N	\N	2	1	2	f	2670	\N	\N
518	57	242	2	8	\N	0	\N	\N	3	1	2	f	8	\N	\N
519	104	243	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
520	104	244	2	3731	\N	0	\N	\N	1	1	2	f	3731	\N	\N
521	104	245	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
522	161	246	2	589	\N	0	\N	\N	1	1	2	f	589	\N	\N
523	104	247	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
524	105	248	2	759373	\N	0	\N	\N	1	1	2	f	759373	\N	\N
525	104	249	2	4362	\N	0	\N	\N	1	1	2	f	4362	\N	\N
526	112	250	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
527	104	251	2	65606	\N	0	\N	\N	1	1	2	f	65606	\N	\N
528	104	252	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
529	104	253	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
530	104	254	2	2397	\N	2397	\N	\N	1	1	2	f	0	\N	\N
531	59	254	1	4794	\N	4794	\N	\N	1	1	2	f	\N	\N	\N
532	104	255	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
533	105	256	2	876705	\N	876705	\N	\N	1	1	2	f	0	\N	\N
534	106	256	2	22514	\N	22514	\N	\N	2	1	2	f	0	\N	\N
535	108	256	2	6016	\N	6016	\N	\N	3	1	2	f	0	\N	\N
536	67	256	2	3453	\N	3453	\N	\N	4	1	2	f	0	\N	\N
537	127	256	2	1547	\N	1547	\N	\N	5	1	2	f	0	\N	\N
538	134	256	2	12	\N	12	\N	\N	6	1	2	f	0	\N	\N
539	59	256	1	909406	\N	909406	\N	\N	1	1	2	f	\N	\N	\N
540	104	257	2	3334	\N	3334	\N	\N	1	1	2	f	0	\N	\N
541	59	257	1	6668	\N	6668	\N	\N	1	1	2	f	\N	\N	\N
542	104	258	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
543	25	260	2	2670	\N	2670	\N	\N	1	1	2	f	0	\N	\N
544	84	260	2	14	\N	7	\N	\N	2	1	2	f	7	\N	\N
545	7	260	1	1335	\N	1335	\N	\N	1	1	2	f	\N	\N	\N
546	104	261	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
547	104	262	2	31431	\N	0	\N	\N	1	1	2	f	31431	\N	\N
548	104	263	2	14472	\N	14472	\N	\N	1	1	2	f	0	\N	\N
549	59	263	1	28944	\N	28944	\N	\N	1	1	2	f	\N	\N	\N
550	104	264	2	4717	\N	4717	\N	\N	1	1	2	f	0	\N	\N
551	59	264	1	9434	\N	9434	\N	\N	1	1	2	f	\N	\N	\N
552	104	265	2	6048	\N	6048	\N	\N	1	1	2	f	0	\N	\N
553	59	265	1	12096	\N	12096	\N	\N	1	1	2	f	\N	\N	\N
554	104	266	2	28070	\N	28070	\N	\N	1	1	2	f	0	\N	\N
555	59	266	1	56140	\N	56140	\N	\N	1	1	2	f	\N	\N	\N
556	104	267	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
557	26	267	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
558	104	268	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
559	104	269	2	10722	\N	0	\N	\N	1	1	2	f	10722	\N	\N
560	104	271	2	67669	\N	67669	\N	\N	1	1	2	f	0	\N	\N
561	59	271	1	135338	\N	135338	\N	\N	1	1	2	f	\N	\N	\N
562	104	272	2	6975	\N	0	\N	\N	1	1	2	f	6975	\N	\N
563	84	273	2	16	\N	16	\N	\N	1	1	2	f	0	\N	\N
564	84	273	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
565	104	274	2	6360	\N	6360	\N	\N	1	1	2	f	0	\N	\N
566	59	274	1	12720	\N	12720	\N	\N	1	1	2	f	\N	\N	\N
567	104	275	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
568	64	276	2	730	\N	0	\N	\N	1	1	2	f	730	\N	\N
569	26	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
570	63	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
571	110	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
572	27	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
573	175	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
574	145	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
575	42	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
576	132	276	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
577	104	277	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
578	26	277	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
579	104	278	2	442	\N	442	\N	\N	1	1	2	f	0	\N	\N
580	59	278	1	884	\N	884	\N	\N	1	1	2	f	\N	\N	\N
581	104	279	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
582	26	279	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
583	86	280	2	674	\N	674	\N	\N	1	1	2	f	0	\N	\N
584	124	280	2	674	\N	674	\N	\N	0	1	2	f	0	\N	\N
585	40	280	2	674	\N	674	\N	\N	0	1	2	f	0	\N	\N
586	129	280	1	675	\N	675	\N	\N	1	1	2	f	\N	\N	\N
587	104	281	2	4475	\N	4475	\N	\N	1	1	2	f	0	\N	\N
588	59	281	1	8950	\N	8950	\N	\N	1	1	2	f	\N	\N	\N
589	104	282	2	8068	\N	0	\N	\N	1	1	2	f	8068	\N	\N
590	104	283	2	234718	\N	0	\N	\N	1	1	2	f	234718	\N	\N
591	87	284	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
592	60	285	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
593	24	285	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
594	104	286	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
595	104	287	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
596	206	288	2	116	\N	116	\N	\N	1	1	2	f	0	\N	\N
597	158	288	1	82	\N	82	\N	\N	1	1	2	f	\N	\N	\N
598	125	288	1	34	\N	34	\N	\N	2	1	2	f	\N	\N	\N
599	23	288	1	16	\N	16	\N	\N	0	1	2	f	\N	\N	\N
600	2	288	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
601	65	288	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
602	104	289	2	8751	\N	0	\N	\N	1	1	2	f	8751	\N	\N
603	104	290	2	142	\N	0	\N	\N	1	1	2	f	142	\N	\N
604	104	291	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
605	104	292	2	1056	\N	1056	\N	\N	1	1	2	f	0	\N	\N
606	59	292	1	2112	\N	2112	\N	\N	1	1	2	f	\N	\N	\N
607	24	293	2	7557	\N	0	\N	\N	1	1	2	f	7557	\N	\N
608	104	294	2	81	\N	0	\N	\N	1	1	2	f	81	\N	\N
609	104	295	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
610	104	296	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
611	104	297	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
612	104	298	2	7677	\N	0	\N	\N	1	1	2	f	7677	\N	\N
613	58	299	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
614	58	299	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
615	104	300	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
616	104	301	2	42428	\N	0	\N	\N	1	1	2	f	42428	\N	\N
617	163	302	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
618	3	303	2	24415	\N	24415	\N	\N	1	1	2	f	0	\N	\N
619	134	303	2	1484	\N	1484	\N	\N	2	1	2	f	0	\N	\N
620	105	303	2	868	\N	868	\N	\N	3	1	2	f	0	\N	\N
621	106	303	2	323	\N	323	\N	\N	4	1	2	f	0	\N	\N
622	112	303	2	14	\N	14	\N	\N	5	1	2	f	0	\N	\N
623	127	303	1	26270	\N	26270	\N	\N	1	1	2	f	\N	\N	\N
624	191	303	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
625	66	303	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
626	157	304	2	362633	\N	0	\N	\N	1	1	2	f	362633	\N	\N
627	127	304	2	25073	\N	0	\N	\N	2	1	2	f	25073	\N	\N
628	105	305	2	950199	\N	0	\N	\N	1	1	2	f	950199	\N	\N
629	134	305	2	12	\N	0	\N	\N	2	1	2	f	12	\N	\N
630	104	306	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
631	28	307	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
632	104	308	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
633	104	309	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
634	104	310	2	2307	\N	2307	\N	\N	1	1	2	f	0	\N	\N
635	59	310	1	4614	\N	4614	\N	\N	1	1	2	f	\N	\N	\N
636	67	311	2	3297	\N	0	\N	\N	1	1	2	f	3297	\N	\N
637	104	312	2	7665	\N	0	\N	\N	1	1	2	f	7665	\N	\N
638	104	313	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
639	26	313	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
640	104	314	2	33703	\N	0	\N	\N	1	1	2	f	33703	\N	\N
641	104	315	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
642	28	316	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
643	104	318	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
644	91	319	2	896	\N	896	\N	\N	1	1	2	f	0	\N	\N
645	59	319	1	896	\N	896	\N	\N	1	1	2	f	\N	\N	\N
646	190	319	1	896	\N	896	\N	\N	0	1	2	f	\N	\N	\N
647	104	320	2	14583	\N	0	\N	\N	1	1	2	f	14583	\N	\N
648	104	321	2	48	\N	0	\N	\N	1	1	2	f	48	\N	\N
649	104	322	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
650	104	323	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
651	104	324	2	219622	\N	219622	\N	\N	1	1	2	f	0	\N	\N
652	59	324	1	439244	\N	439244	\N	\N	1	1	2	f	\N	\N	\N
653	104	325	2	13728	\N	13728	\N	\N	1	1	2	f	0	\N	\N
654	59	325	1	27456	\N	27456	\N	\N	1	1	2	f	\N	\N	\N
655	104	326	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
656	104	327	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
657	104	328	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
658	104	329	2	528	\N	0	\N	\N	1	1	2	f	528	\N	\N
659	190	330	2	65977	\N	0	\N	\N	1	1	2	f	65977	\N	\N
660	105	330	2	65977	\N	0	\N	\N	0	1	2	f	65977	\N	\N
661	104	331	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
662	104	332	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
663	104	333	2	3032	\N	3032	\N	\N	1	1	2	f	0	\N	\N
664	59	333	1	6064	\N	6064	\N	\N	1	1	2	f	\N	\N	\N
665	104	334	2	6845	\N	0	\N	\N	1	1	2	f	6845	\N	\N
666	104	335	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
667	104	336	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
668	63	337	2	768	\N	768	\N	\N	1	1	2	f	0	\N	\N
669	26	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
670	110	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
671	27	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
672	175	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
673	145	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
674	42	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
675	132	337	2	768	\N	768	\N	\N	0	1	2	f	0	\N	\N
676	64	337	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
677	131	337	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
678	111	337	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
679	10	337	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
680	104	338	2	5224267	\N	5224267	\N	\N	1	1	2	f	0	\N	\N
681	26	338	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
682	4	338	1	5150966	\N	5150966	\N	\N	1	1	2	f	\N	\N	\N
683	5	338	1	5050736	\N	5050736	\N	\N	1	1	2	f	\N	\N	\N
684	104	339	2	111865	\N	111865	\N	\N	1	1	2	f	0	\N	\N
685	59	339	1	223730	\N	223730	\N	\N	1	1	2	f	\N	\N	\N
686	25	340	2	1335	\N	0	\N	\N	1	1	2	f	1335	\N	\N
687	75	340	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
688	14	340	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
689	57	340	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
690	104	341	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
691	87	342	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
692	57	342	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
693	104	343	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
694	161	344	2	57	\N	57	\N	\N	1	1	2	f	0	\N	\N
695	91	344	1	53	\N	53	\N	\N	1	1	2	f	\N	\N	\N
696	29	344	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
697	179	344	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
698	104	345	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
699	104	346	2	1098	\N	1098	\N	\N	1	1	2	f	0	\N	\N
700	59	346	1	2196	\N	2196	\N	\N	1	1	2	f	\N	\N	\N
701	104	347	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
702	104	348	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
703	104	349	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
704	104	350	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
705	104	351	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
706	104	352	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
707	104	353	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
708	104	354	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
709	104	355	2	32	\N	0	\N	\N	1	1	2	f	32	\N	\N
710	104	356	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
711	104	357	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
712	104	358	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
713	104	359	2	341	\N	0	\N	\N	1	1	2	f	341	\N	\N
714	59	360	2	38307	\N	0	\N	\N	1	1	2	f	38307	\N	\N
715	160	360	2	393	\N	0	\N	\N	2	1	2	f	393	\N	\N
716	87	360	2	25	\N	0	\N	\N	3	1	2	f	25	\N	\N
717	57	360	2	10	\N	0	\N	\N	4	1	2	f	10	\N	\N
718	12	360	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
719	190	360	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
720	104	361	2	765	\N	0	\N	\N	1	1	2	f	765	\N	\N
721	104	362	2	2372	\N	0	\N	\N	1	1	2	f	2372	\N	\N
722	104	363	2	284	\N	0	\N	\N	1	1	2	f	284	\N	\N
723	104	364	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
724	104	365	2	301	\N	0	\N	\N	1	1	2	f	301	\N	\N
725	104	366	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
726	104	367	2	419	\N	0	\N	\N	1	1	2	f	419	\N	\N
727	104	368	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
728	62	369	2	811	\N	765	\N	\N	1	1	2	f	46	\N	\N
729	37	369	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
730	56	369	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
731	104	370	2	2371	\N	2371	\N	\N	1	1	2	f	0	\N	\N
732	37	370	1	2371	\N	2371	\N	\N	1	1	2	f	\N	\N	\N
733	62	370	1	2371	\N	2371	\N	\N	0	1	2	f	\N	\N	\N
734	104	371	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
735	172	372	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
736	143	372	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
737	173	372	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
738	104	373	2	11652	\N	11652	\N	\N	1	1	2	f	0	\N	\N
739	59	373	1	23304	\N	23304	\N	\N	1	1	2	f	\N	\N	\N
740	104	374	2	59589	\N	59589	\N	\N	1	1	2	f	0	\N	\N
741	59	374	1	119178	\N	119178	\N	\N	1	1	2	f	\N	\N	\N
742	127	375	2	2503	\N	0	\N	\N	1	1	2	f	2503	\N	\N
743	191	375	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
744	66	375	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
745	104	376	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
746	104	377	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
747	104	378	2	292971	\N	0	\N	\N	1	1	2	f	292971	\N	\N
748	104	379	2	48681	\N	48681	\N	\N	1	1	2	f	0	\N	\N
749	59	379	1	97362	\N	97362	\N	\N	1	1	2	f	\N	\N	\N
750	104	380	2	10748	\N	0	\N	\N	1	1	2	f	10748	\N	\N
751	104	382	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
752	104	383	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
753	26	383	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
754	62	384	2	6231	\N	0	\N	\N	1	1	2	f	6231	\N	\N
755	37	384	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
756	123	384	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
757	104	385	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
758	178	386	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
759	104	387	2	24157	\N	24157	\N	\N	1	1	2	f	0	\N	\N
760	9	387	2	3002	\N	3002	\N	\N	2	1	2	f	0	\N	\N
761	26	387	2	27159	\N	27159	\N	\N	0	1	2	f	0	\N	\N
762	63	387	1	27151	\N	27151	\N	\N	1	1	2	f	\N	\N	\N
763	26	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
764	110	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
765	27	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
766	175	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
767	145	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
768	42	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
769	132	387	1	27151	\N	27151	\N	\N	0	1	2	f	\N	\N	\N
770	64	387	1	26795	\N	26795	\N	\N	0	1	2	f	\N	\N	\N
771	131	387	1	254	\N	254	\N	\N	0	1	2	f	\N	\N	\N
772	111	387	1	62	\N	62	\N	\N	0	1	2	f	\N	\N	\N
773	10	387	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
774	104	388	2	2585	\N	0	\N	\N	1	1	2	f	2585	\N	\N
775	104	389	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
776	104	390	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
777	104	391	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
778	104	392	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
779	104	393	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
780	104	394	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
781	104	395	2	770	\N	0	\N	\N	1	1	2	f	770	\N	\N
782	104	396	2	6144	\N	0	\N	\N	1	1	2	f	6144	\N	\N
783	195	397	2	2503	\N	0	\N	\N	1	1	2	f	2503	\N	\N
784	29	397	2	995	\N	0	\N	\N	2	1	2	f	995	\N	\N
785	196	397	2	730	\N	0	\N	\N	3	1	2	f	730	\N	\N
786	165	397	2	674	\N	0	\N	\N	4	1	2	f	674	\N	\N
787	95	397	2	614	\N	0	\N	\N	5	1	2	f	614	\N	\N
788	96	397	2	321	\N	0	\N	\N	6	1	2	f	321	\N	\N
789	30	397	2	276	\N	0	\N	\N	7	1	2	f	276	\N	\N
790	146	397	2	105	\N	0	\N	\N	8	1	2	f	105	\N	\N
791	148	397	2	85	\N	0	\N	\N	9	1	2	f	85	\N	\N
792	45	397	2	83	\N	0	\N	\N	10	1	2	f	83	\N	\N
793	115	397	2	43	\N	0	\N	\N	11	1	2	f	43	\N	\N
794	180	397	2	34	\N	0	\N	\N	12	1	2	f	34	\N	\N
795	179	397	2	30	\N	0	\N	\N	13	1	2	f	30	\N	\N
796	97	397	2	2	\N	0	\N	\N	14	1	2	f	2	\N	\N
797	104	398	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
798	104	399	2	1487	\N	0	\N	\N	1	1	2	f	1487	\N	\N
799	104	400	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
800	76	401	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
801	15	401	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
802	104	402	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
803	104	403	2	739	\N	0	\N	\N	1	1	2	f	739	\N	\N
804	127	404	2	21934	\N	0	\N	\N	1	1	2	f	21934	\N	\N
805	105	405	2	764	\N	0	\N	\N	1	1	2	f	764	\N	\N
806	104	406	2	36476	\N	0	\N	\N	1	1	2	f	36476	\N	\N
807	104	407	2	14583	\N	0	\N	\N	1	1	2	f	14583	\N	\N
808	104	408	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
809	73	409	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
810	14	410	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
811	104	411	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
812	57	412	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
813	57	412	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
814	104	413	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
815	190	414	2	266250	\N	266250	\N	\N	1	1	2	f	0	\N	\N
816	105	414	2	266250	\N	266250	\N	\N	0	1	2	f	0	\N	\N
817	63	414	1	176533	\N	176533	\N	\N	1	1	2	f	\N	\N	\N
818	62	414	1	78045	\N	78045	\N	\N	2	1	2	f	\N	\N	\N
819	108	414	1	2887	\N	2887	\N	\N	3	1	2	f	\N	\N	\N
820	109	414	1	1323	\N	1323	\N	\N	4	1	2	f	\N	\N	\N
821	26	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
822	110	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
823	27	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
824	175	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
825	145	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
826	42	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
827	132	414	1	176533	\N	176533	\N	\N	0	1	2	f	\N	\N	\N
828	64	414	1	78943	\N	78943	\N	\N	0	1	2	f	\N	\N	\N
829	10	414	1	46341	\N	46341	\N	\N	0	1	2	f	\N	\N	\N
830	111	414	1	41278	\N	41278	\N	\N	0	1	2	f	\N	\N	\N
831	131	414	1	9971	\N	9971	\N	\N	0	1	2	f	\N	\N	\N
832	108	415	2	370	\N	0	\N	\N	1	1	2	f	370	\N	\N
833	104	416	2	8590	\N	0	\N	\N	1	1	2	f	8590	\N	\N
834	26	416	2	8590	\N	0	\N	\N	0	1	2	f	8590	\N	\N
835	177	417	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
836	40	417	1	1892	\N	1892	\N	\N	1	1	2	f	\N	\N	\N
837	124	417	1	1836	\N	1836	\N	\N	0	1	2	f	\N	\N	\N
838	86	417	1	1836	\N	1836	\N	\N	0	1	2	f	\N	\N	\N
839	104	418	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
840	104	419	2	19929	\N	19929	\N	\N	1	1	2	f	0	\N	\N
841	59	419	1	39858	\N	39858	\N	\N	1	1	2	f	\N	\N	\N
842	105	420	2	2846	\N	0	\N	\N	1	1	2	f	2846	\N	\N
843	76	421	1	67	\N	67	\N	\N	1	1	2	f	\N	\N	\N
844	15	421	1	67	\N	67	\N	\N	1	1	2	f	\N	\N	\N
845	104	422	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
846	104	423	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
847	104	424	2	81089	\N	0	\N	\N	1	1	2	f	81089	\N	\N
848	104	425	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
849	104	426	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
850	59	426	1	72	\N	72	\N	\N	1	1	2	f	\N	\N	\N
851	104	427	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
852	104	428	2	8352	\N	0	\N	\N	1	1	2	f	8352	\N	\N
853	104	429	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
854	104	430	2	1092634	\N	0	\N	\N	1	1	2	f	1092634	\N	\N
855	11	431	2	35715	\N	0	\N	\N	1	1	2	f	35715	\N	\N
856	104	432	2	5683	\N	0	\N	\N	1	1	2	f	5683	\N	\N
857	104	433	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
858	104	434	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
859	104	435	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
860	99	436	2	48062	\N	0	\N	\N	1	1	2	f	48062	\N	\N
861	170	436	2	21137	\N	0	\N	\N	2	1	2	f	21137	\N	\N
862	19	436	2	4225	\N	0	\N	\N	3	1	2	f	4225	\N	\N
863	51	436	2	2061	\N	0	\N	\N	4	1	2	f	2061	\N	\N
864	186	436	2	1207	\N	0	\N	\N	5	1	2	f	1207	\N	\N
865	20	436	2	297	\N	0	\N	\N	6	1	2	f	297	\N	\N
866	104	437	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
867	104	438	2	3902	\N	3902	\N	\N	1	1	2	f	0	\N	\N
868	59	438	1	7804	\N	7804	\N	\N	1	1	2	f	\N	\N	\N
869	104	439	2	6343	\N	0	\N	\N	1	1	2	f	6343	\N	\N
870	170	440	2	855	\N	855	\N	\N	1	1	2	f	0	\N	\N
871	99	440	2	727	\N	727	\N	\N	2	1	2	f	0	\N	\N
872	36	440	2	244	\N	244	\N	\N	3	1	2	f	0	\N	\N
873	19	440	2	125	\N	125	\N	\N	4	1	2	f	0	\N	\N
874	202	440	2	73	\N	73	\N	\N	5	1	2	f	0	\N	\N
875	186	440	2	44	\N	44	\N	\N	6	1	2	f	0	\N	\N
876	155	440	2	24	\N	24	\N	\N	7	1	2	f	0	\N	\N
877	51	440	2	10	\N	10	\N	\N	8	1	2	f	0	\N	\N
878	140	440	2	9	\N	9	\N	\N	9	1	2	f	0	\N	\N
879	203	440	2	3	\N	3	\N	\N	10	1	2	f	0	\N	\N
880	20	440	2	2	\N	2	\N	\N	11	1	2	f	0	\N	\N
881	187	440	2	1	\N	1	\N	\N	12	1	2	f	0	\N	\N
882	21	440	2	1	\N	1	\N	\N	13	1	2	f	0	\N	\N
883	62	440	1	2106	\N	2106	\N	\N	1	1	2	f	\N	\N	\N
884	104	441	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
885	104	442	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
886	63	443	2	24157	\N	24157	\N	\N	1	1	2	f	0	\N	\N
887	26	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
888	110	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
889	27	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
890	175	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
891	145	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
892	42	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
893	132	443	2	24157	\N	24157	\N	\N	0	1	2	f	0	\N	\N
894	64	443	2	23872	\N	23872	\N	\N	0	1	2	f	0	\N	\N
895	131	443	2	196	\N	196	\N	\N	0	1	2	f	0	\N	\N
896	111	443	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
897	10	443	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
898	104	443	1	24157	\N	24157	\N	\N	1	1	2	f	\N	\N	\N
899	26	443	1	24157	\N	24157	\N	\N	0	1	2	f	\N	\N	\N
900	62	444	2	2603	\N	2603	\N	\N	1	1	2	f	0	\N	\N
901	37	444	2	2193	\N	2193	\N	\N	0	1	2	f	0	\N	\N
902	62	444	1	2591	\N	2591	\N	\N	1	1	2	f	\N	\N	\N
903	123	444	1	731	\N	731	\N	\N	0	1	2	f	\N	\N	\N
904	56	444	1	731	\N	731	\N	\N	0	1	2	f	\N	\N	\N
905	104	445	2	6436	\N	0	\N	\N	1	1	2	f	6436	\N	\N
906	87	446	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
907	104	447	2	16247	\N	16247	\N	\N	1	1	2	f	0	\N	\N
908	59	447	1	32494	\N	32494	\N	\N	1	1	2	f	\N	\N	\N
909	104	448	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
910	104	449	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
911	104	450	2	883	\N	883	\N	\N	1	1	2	f	0	\N	\N
912	123	450	1	884	\N	884	\N	\N	1	1	2	f	\N	\N	\N
913	62	450	1	884	\N	884	\N	\N	0	1	2	f	\N	\N	\N
914	104	451	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
915	104	452	2	506	\N	506	\N	\N	1	1	2	f	0	\N	\N
916	123	452	1	506	\N	506	\N	\N	1	1	2	f	\N	\N	\N
917	62	452	1	506	\N	506	\N	\N	0	1	2	f	\N	\N	\N
918	104	453	2	2319	\N	2319	\N	\N	1	1	2	f	0	\N	\N
919	59	453	1	4638	\N	4638	\N	\N	1	1	2	f	\N	\N	\N
920	104	454	2	454	\N	0	\N	\N	1	1	2	f	454	\N	\N
921	104	455	2	201	\N	0	\N	\N	1	1	2	f	201	\N	\N
922	104	456	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
923	104	457	2	506	\N	506	\N	\N	1	1	2	f	0	\N	\N
924	37	457	1	506	\N	506	\N	\N	1	1	2	f	\N	\N	\N
925	62	457	1	506	\N	506	\N	\N	0	1	2	f	\N	\N	\N
926	104	458	2	34274	\N	34274	\N	\N	1	1	2	f	0	\N	\N
927	59	458	1	68548	\N	68548	\N	\N	1	1	2	f	\N	\N	\N
928	5	459	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
929	104	460	2	128	\N	0	\N	\N	1	1	2	f	128	\N	\N
930	104	461	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
931	104	462	2	6707	\N	0	\N	\N	1	1	2	f	6707	\N	\N
932	104	463	2	764	\N	0	\N	\N	1	1	2	f	764	\N	\N
933	104	464	2	765	\N	765	\N	\N	1	1	2	f	0	\N	\N
934	59	464	1	1530	\N	1530	\N	\N	1	1	2	f	\N	\N	\N
935	104	465	2	817	\N	817	\N	\N	1	1	2	f	0	\N	\N
936	37	465	1	818	\N	818	\N	\N	1	1	2	f	\N	\N	\N
937	62	465	1	818	\N	818	\N	\N	0	1	2	f	\N	\N	\N
938	104	466	2	883	\N	0	\N	\N	1	1	2	f	883	\N	\N
939	104	467	2	883	\N	0	\N	\N	1	1	2	f	883	\N	\N
940	104	468	2	52225	\N	0	\N	\N	1	1	2	f	52225	\N	\N
941	104	469	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
942	63	470	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
943	26	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
944	110	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
945	27	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
946	175	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
947	145	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
948	42	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
949	132	470	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
950	64	470	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
951	131	470	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
952	111	470	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
953	10	470	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
954	104	471	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
955	125	472	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
956	125	472	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
957	87	473	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
958	57	473	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
959	104	475	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
960	161	476	2	3670	\N	1071	\N	\N	1	1	2	f	2599	\N	\N
961	62	476	1	1071	\N	1071	\N	\N	1	1	2	f	\N	\N	\N
962	37	476	1	1043	\N	1043	\N	\N	0	1	2	f	\N	\N	\N
963	56	476	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
964	104	477	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
965	104	478	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
966	59	478	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
967	107	479	2	478	\N	478	\N	\N	1	1	2	f	0	\N	\N
968	104	480	2	10663	\N	10663	\N	\N	1	1	2	f	0	\N	\N
969	59	480	1	21326	\N	21326	\N	\N	1	1	2	f	\N	\N	\N
970	104	481	2	726	\N	726	\N	\N	1	1	2	f	0	\N	\N
971	59	481	1	1452	\N	1452	\N	\N	1	1	2	f	\N	\N	\N
972	193	482	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
973	133	482	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
974	61	483	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
975	62	483	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
976	104	484	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
977	68	485	2	4216	\N	4216	\N	\N	1	1	2	f	0	\N	\N
978	185	485	2	32	\N	32	\N	\N	2	1	2	f	0	\N	\N
979	104	486	2	9352	\N	0	\N	\N	1	1	2	f	9352	\N	\N
980	161	487	2	4383	\N	1733	\N	\N	1	1	2	f	2650	\N	\N
981	62	487	1	1733	\N	1733	\N	\N	1	1	2	f	\N	\N	\N
982	37	487	1	1638	\N	1638	\N	\N	0	1	2	f	\N	\N	\N
983	56	487	1	68	\N	68	\N	\N	0	1	2	f	\N	\N	\N
984	58	488	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
985	58	488	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
986	104	489	2	6154	\N	0	\N	\N	1	1	2	f	6154	\N	\N
987	104	490	2	12771	\N	0	\N	\N	1	1	2	f	12771	\N	\N
988	113	491	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
989	147	491	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
990	13	491	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
991	74	491	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
992	94	491	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
993	104	492	2	5616	\N	0	\N	\N	1	1	2	f	5616	\N	\N
994	104	493	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
995	104	494	2	12265	\N	0	\N	\N	1	1	2	f	12265	\N	\N
996	104	495	2	7859	\N	7859	\N	\N	1	1	2	f	0	\N	\N
997	123	495	1	7859	\N	7859	\N	\N	1	1	2	f	\N	\N	\N
998	62	495	1	7859	\N	7859	\N	\N	0	1	2	f	\N	\N	\N
999	104	496	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1000	104	497	2	5926	\N	0	\N	\N	1	1	2	f	5926	\N	\N
1001	104	498	2	9955	\N	0	\N	\N	1	1	2	f	9955	\N	\N
1002	104	499	2	7825	\N	7825	\N	\N	1	1	2	f	0	\N	\N
1003	37	499	1	7825	\N	7825	\N	\N	1	1	2	f	\N	\N	\N
1004	62	499	1	7825	\N	7825	\N	\N	0	1	2	f	\N	\N	\N
1005	104	500	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1006	104	501	2	7860	\N	0	\N	\N	1	1	2	f	7860	\N	\N
1007	104	502	2	7860	\N	0	\N	\N	1	1	2	f	7860	\N	\N
1008	104	503	2	807	\N	0	\N	\N	1	1	2	f	807	\N	\N
1009	104	504	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1010	26	504	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1011	104	505	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
1012	104	506	2	6487	\N	0	\N	\N	1	1	2	f	6487	\N	\N
1013	104	507	2	6519	\N	0	\N	\N	1	1	2	f	6519	\N	\N
1014	104	508	2	6908	\N	0	\N	\N	1	1	2	f	6908	\N	\N
1015	104	509	2	6302	\N	0	\N	\N	1	1	2	f	6302	\N	\N
1016	104	510	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
1017	129	511	2	37623	\N	37623	\N	\N	1	1	2	f	0	\N	\N
1018	57	511	2	73	\N	73	\N	\N	2	1	2	f	0	\N	\N
1019	59	511	1	37681	\N	37681	\N	\N	1	1	2	f	\N	\N	\N
1020	190	511	1	73	\N	73	\N	\N	0	1	2	f	\N	\N	\N
1021	104	512	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
1022	134	513	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1023	127	514	2	397	\N	0	\N	\N	1	1	2	f	397	\N	\N
1024	127	515	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1025	14	516	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1026	104	517	2	7860	\N	0	\N	\N	1	1	2	f	7860	\N	\N
1027	104	518	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1028	104	519	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1029	104	520	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
1030	104	521	2	3773130	\N	3773130	\N	\N	1	1	2	f	0	\N	\N
1031	61	521	2	1952744	\N	1952744	\N	\N	2	1	2	f	0	\N	\N
1032	24	521	2	1952334	\N	1952334	\N	\N	3	1	2	f	0	\N	\N
1033	60	521	2	1940534	\N	1940534	\N	\N	4	1	2	f	0	\N	\N
1034	105	521	2	1526496	\N	1526496	\N	\N	5	1	2	f	0	\N	\N
1035	127	521	2	43416	\N	43416	\N	\N	6	1	2	f	0	\N	\N
1036	3	521	2	26503	\N	26503	\N	\N	7	1	2	f	0	\N	\N
1037	128	521	2	20678	\N	20678	\N	\N	8	1	2	f	0	\N	\N
1038	62	521	2	10473	\N	10473	\N	\N	9	1	2	f	0	\N	\N
1039	22	521	2	3282	\N	3282	\N	\N	10	1	2	f	0	\N	\N
1040	176	521	2	3282	\N	3282	\N	\N	11	1	2	f	0	\N	\N
1041	67	521	2	3282	\N	3282	\N	\N	12	1	2	f	0	\N	\N
1042	134	521	2	1496	\N	1496	\N	\N	13	1	2	f	0	\N	\N
1043	5	521	2	1279	\N	1279	\N	\N	14	1	2	f	0	\N	\N
1044	4	521	2	976	\N	976	\N	\N	14	1	2	f	0	\N	\N
1045	59	521	2	1096	\N	1096	\N	\N	15	1	2	f	0	\N	\N
1046	108	521	2	688	\N	688	\N	\N	16	1	2	f	0	\N	\N
1047	159	521	2	588	\N	588	\N	\N	17	1	2	f	0	\N	\N
1048	6	521	2	571	\N	571	\N	\N	18	1	2	f	0	\N	\N
1049	40	521	2	62	\N	62	\N	\N	19	1	2	f	0	\N	\N
1050	85	521	2	52	\N	52	\N	\N	20	1	2	f	0	\N	\N
1051	8	521	2	38	\N	38	\N	\N	21	1	2	f	0	\N	\N
1052	177	521	2	10	\N	10	\N	\N	22	1	2	f	0	\N	\N
1053	106	521	2	8	\N	8	\N	\N	23	1	2	f	0	\N	\N
1054	12	521	2	1	\N	1	\N	\N	24	1	2	f	0	\N	\N
1055	56	521	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1056	126	521	1	2839313	\N	2839313	\N	\N	1	1	2	f	\N	\N	\N
1057	104	522	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
1058	195	523	2	2503	\N	2503	\N	\N	1	1	2	f	0	\N	\N
1059	29	523	2	995	\N	995	\N	\N	2	1	2	f	0	\N	\N
1060	196	523	2	730	\N	730	\N	\N	3	1	2	f	0	\N	\N
1061	165	523	2	674	\N	674	\N	\N	4	1	2	f	0	\N	\N
1062	95	523	2	614	\N	614	\N	\N	5	1	2	f	0	\N	\N
1063	96	523	2	321	\N	321	\N	\N	6	1	2	f	0	\N	\N
1064	30	523	2	276	\N	276	\N	\N	7	1	2	f	0	\N	\N
1065	146	523	2	105	\N	105	\N	\N	8	1	2	f	0	\N	\N
1066	148	523	2	85	\N	85	\N	\N	9	1	2	f	0	\N	\N
1067	45	523	2	83	\N	83	\N	\N	10	1	2	f	0	\N	\N
1068	115	523	2	43	\N	43	\N	\N	11	1	2	f	0	\N	\N
1069	180	523	2	34	\N	34	\N	\N	12	1	2	f	0	\N	\N
1070	179	523	2	30	\N	30	\N	\N	13	1	2	f	0	\N	\N
1071	97	523	2	2	\N	2	\N	\N	14	1	2	f	0	\N	\N
1072	57	523	1	6493	\N	6493	\N	\N	1	1	2	f	\N	\N	\N
1073	104	525	2	13185	\N	13185	\N	\N	1	1	2	f	0	\N	\N
1074	59	525	1	26370	\N	26370	\N	\N	1	1	2	f	\N	\N	\N
1075	127	526	2	2350	\N	0	\N	\N	1	1	2	f	2350	\N	\N
1076	104	527	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1077	76	528	2	67	\N	67	\N	\N	1	1	2	f	0	\N	\N
1078	15	528	2	67	\N	67	\N	\N	1	1	2	f	0	\N	\N
1079	194	528	1	67	\N	67	\N	\N	1	1	2	f	\N	\N	\N
1080	24	529	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
1081	195	530	2	2503	\N	0	\N	\N	1	1	2	f	2503	\N	\N
1082	29	530	2	995	\N	0	\N	\N	2	1	2	f	995	\N	\N
1083	196	530	2	730	\N	0	\N	\N	3	1	2	f	730	\N	\N
1084	165	530	2	674	\N	0	\N	\N	4	1	2	f	674	\N	\N
1085	95	530	2	614	\N	0	\N	\N	5	1	2	f	614	\N	\N
1086	96	530	2	321	\N	0	\N	\N	6	1	2	f	321	\N	\N
1087	30	530	2	276	\N	0	\N	\N	7	1	2	f	276	\N	\N
1088	146	530	2	105	\N	0	\N	\N	8	1	2	f	105	\N	\N
1089	148	530	2	85	\N	0	\N	\N	9	1	2	f	85	\N	\N
1090	45	530	2	83	\N	0	\N	\N	10	1	2	f	83	\N	\N
1091	115	530	2	43	\N	0	\N	\N	11	1	2	f	43	\N	\N
1092	180	530	2	34	\N	0	\N	\N	12	1	2	f	34	\N	\N
1093	179	530	2	30	\N	0	\N	\N	13	1	2	f	30	\N	\N
1094	97	530	2	2	\N	0	\N	\N	14	1	2	f	2	\N	\N
1095	104	531	2	1536	\N	0	\N	\N	1	1	2	f	1536	\N	\N
1096	104	532	2	36476	\N	0	\N	\N	1	1	2	f	36476	\N	\N
1097	60	533	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
1098	59	533	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
1099	104	534	2	9508	\N	0	\N	\N	1	1	2	f	9508	\N	\N
1100	104	535	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
1101	104	536	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
1102	59	536	1	44	\N	44	\N	\N	1	1	2	f	\N	\N	\N
1103	104	537	2	7241	\N	7241	\N	\N	1	1	2	f	0	\N	\N
1104	59	537	1	14482	\N	14482	\N	\N	1	1	2	f	\N	\N	\N
1105	57	538	2	903	\N	903	\N	\N	1	1	2	f	0	\N	\N
1106	92	538	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1107	93	538	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
1108	44	538	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
1109	189	538	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
1110	190	538	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1111	57	538	1	779	\N	779	\N	\N	1	1	2	f	\N	\N	\N
1112	206	538	1	116	\N	116	\N	\N	2	1	2	f	\N	\N	\N
1113	23	538	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
1114	189	538	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
1115	124	538	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1116	104	539	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
1117	59	539	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
1118	104	540	2	8598	\N	0	\N	\N	1	1	2	f	8598	\N	\N
1119	104	541	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1120	104	542	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1121	11	543	2	35715	\N	0	\N	\N	1	1	2	f	35715	\N	\N
1122	104	544	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1123	102	545	2	141	\N	0	\N	\N	1	1	2	f	141	\N	\N
1124	104	546	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1125	26	546	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1126	104	547	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1127	104	548	2	2718	\N	2718	\N	\N	1	1	2	f	0	\N	\N
1128	59	548	1	5436	\N	5436	\N	\N	1	1	2	f	\N	\N	\N
1129	104	549	2	883	\N	0	\N	\N	1	1	2	f	883	\N	\N
1130	104	550	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1131	104	551	2	883	\N	0	\N	\N	1	1	2	f	883	\N	\N
1132	104	552	2	2307	\N	2307	\N	\N	1	1	2	f	0	\N	\N
1133	59	552	1	4614	\N	4614	\N	\N	1	1	2	f	\N	\N	\N
1134	104	553	2	3101	\N	3101	\N	\N	1	1	2	f	0	\N	\N
1135	59	553	1	6202	\N	6202	\N	\N	1	1	2	f	\N	\N	\N
1136	104	554	2	35260	\N	0	\N	\N	1	1	2	f	35260	\N	\N
1137	104	555	2	6132	\N	0	\N	\N	1	1	2	f	6132	\N	\N
1138	104	556	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1139	104	557	2	6729	\N	0	\N	\N	1	1	2	f	6729	\N	\N
1140	104	559	2	42419	\N	0	\N	\N	1	1	2	f	42419	\N	\N
1141	104	560	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
1142	104	561	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1143	26	561	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1144	104	562	2	49088	\N	49088	\N	\N	1	1	2	f	0	\N	\N
1145	59	562	1	98176	\N	98176	\N	\N	1	1	2	f	\N	\N	\N
1146	104	563	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
1147	104	564	2	165	\N	0	\N	\N	1	1	2	f	165	\N	\N
1148	104	565	2	206	\N	0	\N	\N	1	1	2	f	206	\N	\N
1149	104	566	2	172	\N	0	\N	\N	1	1	2	f	172	\N	\N
1150	104	567	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
1151	127	568	2	30704	\N	0	\N	\N	1	1	2	f	30704	\N	\N
1152	105	569	2	257827	\N	0	\N	\N	1	1	2	f	257827	\N	\N
1153	190	569	2	65977	\N	0	\N	\N	0	1	2	f	65977	\N	\N
1154	104	570	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1155	128	571	2	8740	\N	0	\N	\N	1	1	2	f	8740	\N	\N
1156	104	572	2	64465	\N	64465	\N	\N	1	1	2	f	0	\N	\N
1157	59	572	1	128930	\N	128930	\N	\N	1	1	2	f	\N	\N	\N
1158	195	573	2	2503	\N	2503	\N	\N	1	1	2	f	0	\N	\N
1159	29	573	2	995	\N	995	\N	\N	2	1	2	f	0	\N	\N
1160	196	573	2	730	\N	730	\N	\N	3	1	2	f	0	\N	\N
1161	165	573	2	674	\N	674	\N	\N	4	1	2	f	0	\N	\N
1162	95	573	2	614	\N	614	\N	\N	5	1	2	f	0	\N	\N
1163	96	573	2	321	\N	321	\N	\N	6	1	2	f	0	\N	\N
1164	30	573	2	276	\N	276	\N	\N	7	1	2	f	0	\N	\N
1165	146	573	2	105	\N	105	\N	\N	8	1	2	f	0	\N	\N
1166	148	573	2	85	\N	85	\N	\N	9	1	2	f	0	\N	\N
1167	45	573	2	83	\N	83	\N	\N	10	1	2	f	0	\N	\N
1168	115	573	2	43	\N	43	\N	\N	11	1	2	f	0	\N	\N
1169	180	573	2	34	\N	34	\N	\N	12	1	2	f	0	\N	\N
1170	179	573	2	30	\N	30	\N	\N	13	1	2	f	0	\N	\N
1171	97	573	2	2	\N	2	\N	\N	14	1	2	f	0	\N	\N
1172	57	573	1	6495	\N	6495	\N	\N	1	1	2	f	\N	\N	\N
1173	104	574	2	433	\N	0	\N	\N	1	1	2	f	433	\N	\N
1174	104	575	2	433	\N	0	\N	\N	1	1	2	f	433	\N	\N
1175	104	576	2	98	\N	0	\N	\N	1	1	2	f	98	\N	\N
1176	104	577	2	35	\N	0	\N	\N	1	1	2	f	35	\N	\N
1177	104	578	2	70	\N	0	\N	\N	1	1	2	f	70	\N	\N
1178	104	579	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
1179	104	580	2	329	\N	0	\N	\N	1	1	2	f	329	\N	\N
1180	104	581	2	1032	\N	0	\N	\N	1	1	2	f	1032	\N	\N
1181	104	583	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1182	104	584	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1183	28	587	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1184	104	589	2	993	\N	993	\N	\N	1	1	2	f	0	\N	\N
1185	59	589	1	1986	\N	1986	\N	\N	1	1	2	f	\N	\N	\N
1186	104	591	2	326	\N	0	\N	\N	1	1	2	f	326	\N	\N
1187	172	592	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1188	173	592	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1189	104	593	2	187	\N	0	\N	\N	1	1	2	f	187	\N	\N
1190	84	594	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1191	190	595	2	24	\N	24	\N	\N	1	1	2	f	0	\N	\N
1192	47	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1193	77	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1194	117	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1195	197	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1196	17	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1197	182	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1198	152	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1199	79	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1200	198	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1201	136	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1202	199	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1203	200	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1204	49	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1205	35	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1206	201	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1207	137	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1208	154	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1209	120	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1210	138	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1211	121	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1212	98	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1213	18	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1214	139	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1215	122	595	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1216	104	596	2	324	\N	324	\N	\N	1	1	2	f	0	\N	\N
1217	59	596	1	648	\N	648	\N	\N	1	1	2	f	\N	\N	\N
1218	104	597	2	17706	\N	17706	\N	\N	1	1	2	f	0	\N	\N
1219	59	597	1	35412	\N	35412	\N	\N	1	1	2	f	\N	\N	\N
1220	104	598	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1221	26	598	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1222	127	599	2	2504	\N	0	\N	\N	1	1	2	f	2504	\N	\N
1223	191	599	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1224	66	599	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1225	107	600	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1226	104	601	2	6360	\N	6360	\N	\N	1	1	2	f	0	\N	\N
1227	59	601	1	12720	\N	12720	\N	\N	1	1	2	f	\N	\N	\N
1228	104	602	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1229	26	602	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1230	104	603	2	3068	\N	0	\N	\N	1	1	2	f	3068	\N	\N
1231	26	603	2	3068	\N	0	\N	\N	0	1	2	f	3068	\N	\N
1232	104	604	2	13185	\N	0	\N	\N	1	1	2	f	13185	\N	\N
1233	104	605	2	427	\N	0	\N	\N	1	1	2	f	427	\N	\N
1234	104	606	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1235	192	607	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1236	163	608	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
1237	104	609	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
1238	61	610	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
1239	104	611	2	48	\N	0	\N	\N	1	1	2	f	48	\N	\N
1240	104	612	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
1241	104	613	2	9214	\N	0	\N	\N	1	1	2	f	9214	\N	\N
1242	99	614	2	48062	\N	0	\N	\N	1	1	2	f	48062	\N	\N
1243	170	614	2	21137	\N	0	\N	\N	2	1	2	f	21137	\N	\N
1244	39	614	2	4474	\N	0	\N	\N	3	1	2	f	4474	\N	\N
1245	19	614	2	4225	\N	0	\N	\N	4	1	2	f	4225	\N	\N
1246	68	614	2	4216	\N	0	\N	\N	5	1	2	f	4216	\N	\N
1247	101	614	2	2511	\N	0	\N	\N	6	1	2	f	2511	\N	\N
1248	51	614	2	2061	\N	0	\N	\N	7	1	2	f	2061	\N	\N
1249	202	614	2	1838	\N	0	\N	\N	8	1	2	f	1838	\N	\N
1250	36	614	2	1594	\N	0	\N	\N	9	1	2	f	1594	\N	\N
1251	186	614	2	1207	\N	0	\N	\N	10	1	2	f	1207	\N	\N
1252	53	614	2	862	\N	0	\N	\N	11	1	2	f	862	\N	\N
1253	155	614	2	798	\N	0	\N	\N	12	1	2	f	798	\N	\N
1254	20	614	2	297	\N	0	\N	\N	13	1	2	f	297	\N	\N
1255	174	614	2	281	\N	0	\N	\N	14	1	2	f	281	\N	\N
1256	82	614	2	226	\N	0	\N	\N	15	1	2	f	226	\N	\N
1257	54	614	2	128	\N	0	\N	\N	16	1	2	f	128	\N	\N
1258	140	614	2	95	\N	0	\N	\N	17	1	2	f	95	\N	\N
1259	80	614	2	49	\N	0	\N	\N	18	1	2	f	49	\N	\N
1260	21	614	2	49	\N	0	\N	\N	19	1	2	f	49	\N	\N
1261	72	614	2	35	\N	0	\N	\N	20	1	2	f	35	\N	\N
1262	69	614	2	30	\N	0	\N	\N	21	1	2	f	30	\N	\N
1263	87	614	2	25	\N	0	\N	\N	22	1	2	f	25	\N	\N
1264	52	614	2	20	\N	0	\N	\N	23	1	2	f	20	\N	\N
1265	203	614	2	14	\N	0	\N	\N	24	1	2	f	14	\N	\N
1266	187	614	2	6	\N	0	\N	\N	25	1	2	f	6	\N	\N
1267	100	614	2	6	\N	0	\N	\N	26	1	2	f	6	\N	\N
1268	88	614	2	3	\N	0	\N	\N	27	1	2	f	3	\N	\N
1269	190	614	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1270	89	614	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1271	104	615	2	35283	\N	0	\N	\N	1	1	2	f	35283	\N	\N
1272	104	616	2	7027	\N	7027	\N	\N	1	1	2	f	0	\N	\N
1273	59	616	1	14054	\N	14054	\N	\N	1	1	2	f	\N	\N	\N
1274	104	617	2	5296	\N	5296	\N	\N	1	1	2	f	0	\N	\N
1275	59	617	1	10592	\N	10592	\N	\N	1	1	2	f	\N	\N	\N
1276	104	618	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1277	104	619	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1278	104	620	2	31563	\N	0	\N	\N	1	1	2	f	31563	\N	\N
1279	127	621	2	11910	\N	0	\N	\N	1	1	2	f	11910	\N	\N
1280	104	622	2	1492	\N	1492	\N	\N	1	1	2	f	0	\N	\N
1281	59	622	1	2984	\N	2984	\N	\N	1	1	2	f	\N	\N	\N
1282	104	623	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1283	104	624	2	2715	\N	0	\N	\N	1	1	2	f	2715	\N	\N
1284	104	625	2	5446	\N	5446	\N	\N	1	1	2	f	0	\N	\N
1285	59	625	1	10892	\N	10892	\N	\N	1	1	2	f	\N	\N	\N
1286	104	626	2	14982	\N	14982	\N	\N	1	1	2	f	0	\N	\N
1287	59	626	1	29964	\N	29964	\N	\N	1	1	2	f	\N	\N	\N
1288	76	627	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
1289	15	627	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
1290	104	628	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1291	104	629	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1292	104	630	2	100565	\N	100565	\N	\N	1	1	2	f	0	\N	\N
1293	59	630	1	201130	\N	201130	\N	\N	1	1	2	f	\N	\N	\N
1294	104	631	2	2307	\N	2307	\N	\N	1	1	2	f	0	\N	\N
1295	59	631	1	4614	\N	4614	\N	\N	1	1	2	f	\N	\N	\N
1296	104	632	2	13762	\N	13762	\N	\N	1	1	2	f	0	\N	\N
1297	59	632	1	27524	\N	27524	\N	\N	1	1	2	f	\N	\N	\N
1298	25	633	2	17518	\N	0	\N	\N	1	1	2	f	17518	\N	\N
1299	104	634	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
1300	62	635	2	46448	\N	46448	\N	\N	1	1	2	f	0	\N	\N
1301	62	635	1	44367	\N	44367	\N	\N	1	1	2	f	\N	\N	\N
1302	37	635	1	18998	\N	18998	\N	\N	0	1	2	f	\N	\N	\N
1303	123	635	1	15185	\N	15185	\N	\N	0	1	2	f	\N	\N	\N
1304	104	636	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
1305	104	637	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1306	104	638	2	2601	\N	2601	\N	\N	1	1	2	f	0	\N	\N
1307	59	638	1	5202	\N	5202	\N	\N	1	1	2	f	\N	\N	\N
1308	104	639	2	6446	\N	0	\N	\N	1	1	2	f	6446	\N	\N
1309	104	640	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
1310	161	641	2	2680	\N	0	\N	\N	1	1	2	f	2680	\N	\N
1311	134	642	2	1550	\N	0	\N	\N	1	1	2	f	1550	\N	\N
1312	104	643	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1313	26	643	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1314	104	644	2	195	\N	0	\N	\N	1	1	2	f	195	\N	\N
1315	104	645	2	7242	\N	0	\N	\N	1	1	2	f	7242	\N	\N
1316	104	646	2	2126	\N	2126	\N	\N	1	1	2	f	0	\N	\N
1317	59	646	1	4252	\N	4252	\N	\N	1	1	2	f	\N	\N	\N
1318	104	647	2	588470	\N	588470	\N	\N	1	1	2	f	0	\N	\N
1319	59	647	1	1176940	\N	1176940	\N	\N	1	1	2	f	\N	\N	\N
1320	104	648	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1321	104	649	2	1408	\N	1408	\N	\N	1	1	2	f	0	\N	\N
1322	59	649	1	2816	\N	2816	\N	\N	1	1	2	f	\N	\N	\N
1323	104	651	2	6729	\N	0	\N	\N	1	1	2	f	6729	\N	\N
1324	104	652	2	2538	\N	2538	\N	\N	1	1	2	f	0	\N	\N
1325	59	652	1	5076	\N	5076	\N	\N	1	1	2	f	\N	\N	\N
1326	104	653	2	7017	\N	0	\N	\N	1	1	2	f	7017	\N	\N
1327	104	654	2	6454	\N	6454	\N	\N	1	1	2	f	0	\N	\N
1328	59	654	1	12908	\N	12908	\N	\N	1	1	2	f	\N	\N	\N
1329	104	655	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1330	104	656	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1331	59	656	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1332	104	657	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1333	26	657	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1334	104	658	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
1335	104	659	2	42311	\N	0	\N	\N	1	1	2	f	42311	\N	\N
1336	104	660	2	2183	\N	2183	\N	\N	1	1	2	f	0	\N	\N
1337	59	660	1	4366	\N	4366	\N	\N	1	1	2	f	\N	\N	\N
1338	104	661	2	48747	\N	48747	\N	\N	1	1	2	f	0	\N	\N
1339	59	661	1	97494	\N	97494	\N	\N	1	1	2	f	\N	\N	\N
1340	104	662	2	5270	\N	5270	\N	\N	1	1	2	f	0	\N	\N
1341	59	662	1	10540	\N	10540	\N	\N	1	1	2	f	\N	\N	\N
1342	104	663	2	15690	\N	15690	\N	\N	1	1	2	f	0	\N	\N
1343	59	663	1	31380	\N	31380	\N	\N	1	1	2	f	\N	\N	\N
1344	60	664	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
1345	104	665	2	2909	\N	2909	\N	\N	1	1	2	f	0	\N	\N
1346	59	665	1	5818	\N	5818	\N	\N	1	1	2	f	\N	\N	\N
1347	104	666	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
1348	59	666	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
1349	204	667	2	110	\N	110	\N	\N	1	1	2	f	0	\N	\N
1350	57	667	1	110	\N	110	\N	\N	1	1	2	f	\N	\N	\N
1351	104	668	2	2315	\N	2315	\N	\N	1	1	2	f	0	\N	\N
1352	59	668	1	4630	\N	4630	\N	\N	1	1	2	f	\N	\N	\N
1353	104	669	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1354	125	670	2	54	\N	54	\N	\N	1	1	2	f	0	\N	\N
1355	124	670	2	44	\N	44	\N	\N	2	1	2	f	0	\N	\N
1356	2	670	2	34	\N	34	\N	\N	3	1	2	f	0	\N	\N
1357	158	670	2	31	\N	31	\N	\N	4	1	2	f	0	\N	\N
1358	23	670	2	14	\N	14	\N	\N	5	1	2	f	0	\N	\N
1359	65	670	2	3	\N	3	\N	\N	6	1	2	f	0	\N	\N
1360	46	670	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1361	114	670	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1362	189	670	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1363	38	670	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1364	205	670	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1365	158	670	1	115	\N	115	\N	\N	1	1	2	f	\N	\N	\N
1366	23	670	1	75	\N	75	\N	\N	2	1	2	f	\N	\N	\N
1367	2	670	1	62	\N	62	\N	\N	3	1	2	f	\N	\N	\N
1368	125	670	1	39	\N	39	\N	\N	4	1	2	f	\N	\N	\N
1369	41	670	1	9	\N	9	\N	\N	5	1	2	f	\N	\N	\N
1370	124	670	1	1	\N	1	\N	\N	6	1	2	f	\N	\N	\N
1371	189	670	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1372	46	670	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1373	114	670	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1374	59	671	2	689	\N	689	\N	\N	1	1	2	f	0	\N	\N
1375	59	671	1	689	\N	689	\N	\N	1	1	2	f	\N	\N	\N
1376	104	672	2	292971	\N	0	\N	\N	1	1	2	f	292971	\N	\N
1377	59	673	2	37616	\N	0	\N	\N	1	1	2	f	37616	\N	\N
1378	6	673	2	1131	\N	0	\N	\N	2	1	2	f	1131	\N	\N
1379	129	673	2	698	\N	0	\N	\N	3	1	2	f	698	\N	\N
1380	5	673	2	558	\N	0	\N	\N	0	1	2	f	558	\N	\N
1381	104	674	2	6417	\N	0	\N	\N	1	1	2	f	6417	\N	\N
1382	104	675	2	14583	\N	0	\N	\N	1	1	2	f	14583	\N	\N
1383	104	676	2	56044	\N	56044	\N	\N	1	1	2	f	0	\N	\N
1384	59	676	1	112088	\N	112088	\N	\N	1	1	2	f	\N	\N	\N
1385	104	678	2	5215166	\N	5215166	\N	\N	1	1	2	f	0	\N	\N
1386	159	678	1	5214600	\N	5214600	\N	\N	1	1	2	f	\N	\N	\N
1387	104	679	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
1388	104	680	2	577	\N	0	\N	\N	1	1	2	f	577	\N	\N
1389	104	681	2	481	\N	0	\N	\N	1	1	2	f	481	\N	\N
1390	104	682	2	3068	\N	0	\N	\N	1	1	2	f	3068	\N	\N
1391	26	682	2	3068	\N	0	\N	\N	0	1	2	f	3068	\N	\N
1392	62	683	2	419	\N	419	\N	\N	1	1	2	f	0	\N	\N
1393	104	684	2	445	\N	0	\N	\N	1	1	2	f	445	\N	\N
1394	67	685	2	3460	\N	0	\N	\N	1	1	2	f	3460	\N	\N
1395	104	686	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1396	104	687	2	577	\N	0	\N	\N	1	1	2	f	577	\N	\N
1397	104	688	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1398	26	688	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1399	104	689	2	576	\N	0	\N	\N	1	1	2	f	576	\N	\N
1400	104	690	2	577	\N	0	\N	\N	1	1	2	f	577	\N	\N
1401	104	691	2	191670	\N	191670	\N	\N	1	1	2	f	0	\N	\N
1402	59	691	1	383340	\N	383340	\N	\N	1	1	2	f	\N	\N	\N
1403	104	692	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1404	105	693	2	333	\N	0	\N	\N	1	1	2	f	333	\N	\N
1405	104	694	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1406	104	695	2	612663	\N	0	\N	\N	1	1	2	f	612663	\N	\N
1407	104	696	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1408	104	697	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1409	62	698	2	33354	\N	0	\N	\N	1	1	2	f	33354	\N	\N
1410	109	698	2	2077	\N	0	\N	\N	2	1	2	f	2077	\N	\N
1411	6	698	2	558	\N	0	\N	\N	3	1	2	f	558	\N	\N
1412	5	698	2	296	\N	0	\N	\N	4	1	2	f	296	\N	\N
1413	106	698	2	249	\N	0	\N	\N	5	1	2	f	249	\N	\N
1414	67	698	2	171	\N	0	\N	\N	6	1	2	f	171	\N	\N
1415	25	698	2	23	\N	0	\N	\N	7	1	2	f	23	\N	\N
1416	37	698	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
1417	123	698	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1418	56	698	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1419	143	699	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1420	104	700	2	104752	\N	0	\N	\N	1	1	2	f	104752	\N	\N
1421	104	701	2	5035	\N	5035	\N	\N	1	1	2	f	0	\N	\N
1422	59	701	1	10070	\N	10070	\N	\N	1	1	2	f	\N	\N	\N
1423	104	702	2	4328	\N	0	\N	\N	1	1	2	f	4328	\N	\N
1424	104	703	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1425	104	704	2	7570	\N	0	\N	\N	1	1	2	f	7570	\N	\N
1426	104	705	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
1427	104	706	2	4324	\N	0	\N	\N	1	1	2	f	4324	\N	\N
1428	104	707	2	3573	\N	0	\N	\N	1	1	2	f	3573	\N	\N
1429	104	708	2	4297	\N	4297	\N	\N	1	1	2	f	0	\N	\N
1430	37	708	1	4298	\N	4298	\N	\N	1	1	2	f	\N	\N	\N
1431	62	708	1	4298	\N	4298	\N	\N	0	1	2	f	\N	\N	\N
1432	104	709	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
1433	104	710	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1434	104	711	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
1435	104	712	2	4324	\N	0	\N	\N	1	1	2	f	4324	\N	\N
1436	104	713	2	13185	\N	13185	\N	\N	1	1	2	f	0	\N	\N
1437	59	713	1	26370	\N	26370	\N	\N	1	1	2	f	\N	\N	\N
1438	124	714	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1439	84	714	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1440	104	715	2	4323	\N	4323	\N	\N	1	1	2	f	0	\N	\N
1441	123	715	1	4323	\N	4323	\N	\N	1	1	2	f	\N	\N	\N
1442	62	715	1	4323	\N	4323	\N	\N	0	1	2	f	\N	\N	\N
1443	104	716	2	3149	\N	0	\N	\N	1	1	2	f	3149	\N	\N
1444	104	717	2	3066	\N	0	\N	\N	1	1	2	f	3066	\N	\N
1445	104	718	2	25329	\N	25329	\N	\N	1	1	2	f	0	\N	\N
1446	59	718	1	50658	\N	50658	\N	\N	1	1	2	f	\N	\N	\N
1447	127	719	2	756	\N	0	\N	\N	1	1	2	f	756	\N	\N
1448	64	720	2	730	\N	0	\N	\N	1	1	2	f	730	\N	\N
1449	26	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1450	63	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1451	110	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1452	27	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1453	175	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1454	145	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1455	42	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1456	132	720	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
1457	28	721	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1458	113	721	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1459	104	722	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
1460	11	723	2	35715	\N	0	\N	\N	1	1	2	f	35715	\N	\N
1461	90	723	2	974	\N	0	\N	\N	2	1	2	f	974	\N	\N
1462	70	723	2	181	\N	0	\N	\N	3	1	2	f	181	\N	\N
1463	69	723	2	30	\N	0	\N	\N	4	1	2	f	30	\N	\N
1464	104	724	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
1465	104	725	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
1466	104	726	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1467	26	726	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1468	104	727	2	6487	\N	0	\N	\N	1	1	2	f	6487	\N	\N
1469	104	728	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
1470	107	729	2	2888	\N	2888	\N	\N	1	1	2	f	0	\N	\N
1471	63	730	2	1461	\N	1461	\N	\N	1	1	2	f	0	\N	\N
1472	26	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1473	110	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1474	27	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1475	175	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1476	145	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1477	42	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1478	132	730	2	1461	\N	1461	\N	\N	0	1	2	f	0	\N	\N
1479	10	730	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
1480	131	730	2	730	\N	730	\N	\N	0	1	2	f	0	\N	\N
1481	64	730	1	1461	\N	1461	\N	\N	1	1	2	f	\N	\N	\N
1482	26	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1483	63	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1484	110	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1485	27	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1486	175	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1487	145	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1488	42	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1489	132	730	1	1461	\N	1461	\N	\N	0	1	2	f	\N	\N	\N
1490	104	731	2	6070	\N	0	\N	\N	1	1	2	f	6070	\N	\N
1491	104	732	2	10771	\N	0	\N	\N	1	1	2	f	10771	\N	\N
1492	104	733	2	3369949	\N	3369949	\N	\N	1	1	2	f	0	\N	\N
1493	59	733	1	6739898	\N	6739898	\N	\N	1	1	2	f	\N	\N	\N
1494	104	734	2	9860	\N	0	\N	\N	1	1	2	f	9860	\N	\N
1495	28	735	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
1496	104	736	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1497	104	737	2	161302	\N	161302	\N	\N	1	1	2	f	0	\N	\N
1498	59	737	1	322604	\N	322604	\N	\N	1	1	2	f	\N	\N	\N
1499	104	738	2	161302	\N	161302	\N	\N	1	1	2	f	0	\N	\N
1500	59	738	1	322604	\N	322604	\N	\N	1	1	2	f	\N	\N	\N
1501	104	739	2	157828	\N	157828	\N	\N	1	1	2	f	0	\N	\N
1502	59	739	1	315656	\N	315656	\N	\N	1	1	2	f	\N	\N	\N
1503	104	740	2	786	\N	786	\N	\N	1	1	2	f	0	\N	\N
1504	59	740	1	1572	\N	1572	\N	\N	1	1	2	f	\N	\N	\N
1505	104	741	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1506	104	742	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
1507	104	743	2	8945	\N	0	\N	\N	1	1	2	f	8945	\N	\N
1508	102	744	2	2962	\N	0	\N	\N	1	1	2	f	2962	\N	\N
1509	104	745	2	34011	\N	0	\N	\N	1	1	2	f	34011	\N	\N
1510	106	746	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1511	104	747	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
1512	104	748	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1513	104	749	2	14234	\N	0	\N	\N	1	1	2	f	14234	\N	\N
1514	202	750	2	1838	\N	0	\N	\N	1	1	2	f	1838	\N	\N
1515	36	750	2	1594	\N	0	\N	\N	2	1	2	f	1594	\N	\N
1516	155	750	2	798	\N	0	\N	\N	3	1	2	f	798	\N	\N
1517	140	750	2	95	\N	0	\N	\N	4	1	2	f	95	\N	\N
1518	21	750	2	49	\N	0	\N	\N	5	1	2	f	49	\N	\N
1519	52	750	2	20	\N	0	\N	\N	6	1	2	f	20	\N	\N
1520	203	750	2	14	\N	0	\N	\N	7	1	2	f	14	\N	\N
1521	187	750	2	6	\N	0	\N	\N	8	1	2	f	6	\N	\N
1522	104	751	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
1523	104	752	2	8120	\N	0	\N	\N	1	1	2	f	8120	\N	\N
1524	105	753	2	32111	\N	32111	\N	\N	1	1	2	f	0	\N	\N
1525	106	753	2	22188	\N	22186	\N	\N	2	1	2	f	2	\N	\N
1526	67	753	2	3783	\N	3783	\N	\N	3	1	2	f	0	\N	\N
1527	62	753	1	33433	\N	33433	\N	\N	1	1	2	f	\N	\N	\N
1528	37	753	1	27440	\N	27440	\N	\N	0	1	2	f	\N	\N	\N
1529	123	753	1	2210	\N	2210	\N	\N	0	1	2	f	\N	\N	\N
1530	104	754	2	2576	\N	0	\N	\N	1	1	2	f	2576	\N	\N
1531	104	755	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1532	22	756	2	3643	\N	0	\N	\N	1	1	2	f	3643	\N	\N
1533	104	757	2	10322	\N	0	\N	\N	1	1	2	f	10322	\N	\N
1534	104	758	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
1535	104	759	2	330	\N	330	\N	\N	1	1	2	f	0	\N	\N
1536	59	759	1	660	\N	660	\N	\N	1	1	2	f	\N	\N	\N
1537	104	760	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1538	4	761	2	3480	\N	3480	\N	\N	1	1	2	f	0	\N	\N
1539	5	761	2	984	\N	984	\N	\N	1	1	2	f	0	\N	\N
1540	6	761	1	1916	\N	1916	\N	\N	1	1	2	f	\N	\N	\N
1541	5	761	1	975	\N	975	\N	\N	2	1	2	f	\N	\N	\N
1542	104	762	2	8392	\N	0	\N	\N	1	1	2	f	8392	\N	\N
1543	104	763	2	1545	\N	1545	\N	\N	1	1	2	f	0	\N	\N
1544	59	763	1	3090	\N	3090	\N	\N	1	1	2	f	\N	\N	\N
1545	104	764	2	16247	\N	16247	\N	\N	1	1	2	f	0	\N	\N
1546	59	764	1	32494	\N	32494	\N	\N	1	1	2	f	\N	\N	\N
1547	104	765	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
1548	127	766	2	7571	\N	0	\N	\N	1	1	2	f	7571	\N	\N
1549	104	767	2	4407	\N	0	\N	\N	1	1	2	f	4407	\N	\N
1550	104	768	2	6070	\N	6070	\N	\N	1	1	2	f	0	\N	\N
1551	59	768	1	12140	\N	12140	\N	\N	1	1	2	f	\N	\N	\N
1552	190	769	2	65977	\N	65977	\N	\N	1	1	2	f	0	\N	\N
1553	25	769	2	1335	\N	1335	\N	\N	2	1	2	f	0	\N	\N
1554	5	769	2	1075	\N	1075	\N	\N	3	1	2	f	0	\N	\N
1555	4	769	2	1069	\N	1069	\N	\N	3	1	2	f	0	\N	\N
1556	105	769	2	65977	\N	65977	\N	\N	0	1	2	f	0	\N	\N
1557	59	769	1	68045	\N	68045	\N	\N	1	1	2	f	\N	\N	\N
1558	104	770	2	103	\N	0	\N	\N	1	1	2	f	103	\N	\N
1559	104	771	2	19134	\N	0	\N	\N	1	1	2	f	19134	\N	\N
1560	104	772	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
1561	105	773	2	7127	\N	7127	\N	\N	1	1	2	f	0	\N	\N
1562	104	774	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1563	104	775	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1564	26	775	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1565	113	776	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1566	104	777	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1567	85	778	2	325	\N	0	\N	\N	1	1	2	f	325	\N	\N
1568	125	779	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
1569	2	779	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1570	38	779	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1571	205	779	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1572	125	779	1	14	\N	14	\N	\N	1	1	2	f	\N	\N	\N
1573	2	779	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
1574	38	779	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1575	205	779	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1576	104	780	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
1577	25	781	2	1237	\N	1237	\N	\N	1	1	2	f	0	\N	\N
1578	157	781	1	1237	\N	1237	\N	\N	1	1	2	f	\N	\N	\N
1579	104	782	2	180332	\N	180332	\N	\N	1	1	2	f	0	\N	\N
1580	59	782	1	360480	\N	360480	\N	\N	1	1	2	f	\N	\N	\N
1581	40	783	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
1582	64	784	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
1583	26	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1584	63	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1585	110	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1586	27	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1587	175	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1588	145	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1589	42	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1590	132	784	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1591	104	785	2	6610	\N	0	\N	\N	1	1	2	f	6610	\N	\N
1592	104	786	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1593	104	787	2	6908	\N	0	\N	\N	1	1	2	f	6908	\N	\N
1594	190	788	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
1595	71	788	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1596	43	788	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1597	104	789	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1598	104	790	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1599	104	791	2	95	\N	0	\N	\N	1	1	2	f	95	\N	\N
1600	66	792	2	797	\N	0	\N	\N	1	1	2	f	797	\N	\N
1601	191	792	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1602	127	792	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1603	57	793	2	63	\N	46	\N	\N	1	1	2	f	17	\N	\N
1604	28	793	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
1605	84	793	2	3	\N	3	\N	\N	3	1	2	f	0	\N	\N
1606	124	793	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
1607	193	793	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
1608	133	793	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
1609	166	793	1	45	\N	45	\N	\N	1	1	2	f	\N	\N	\N
1610	84	793	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1611	59	793	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
1612	190	793	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
1613	104	794	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1614	104	795	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1615	104	796	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1616	104	797	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1617	104	798	2	219274	\N	219274	\N	\N	1	1	2	f	0	\N	\N
1618	59	798	1	438548	\N	438548	\N	\N	1	1	2	f	\N	\N	\N
1619	104	799	2	89	\N	0	\N	\N	1	1	2	f	89	\N	\N
1620	108	800	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
1621	104	801	2	83	\N	0	\N	\N	1	1	2	f	83	\N	\N
1622	104	802	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1623	104	803	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1624	104	804	2	2371	\N	0	\N	\N	1	1	2	f	2371	\N	\N
1625	104	805	2	138706	\N	138706	\N	\N	1	1	2	f	0	\N	\N
1626	59	805	1	277412	\N	277412	\N	\N	1	1	2	f	\N	\N	\N
1627	104	806	2	373964	\N	0	\N	\N	1	1	2	f	373964	\N	\N
1628	104	807	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1629	26	807	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1630	104	808	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1631	58	809	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1632	87	810	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
1633	57	810	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
1634	57	811	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
1635	104	812	2	6487	\N	0	\N	\N	1	1	2	f	6487	\N	\N
1636	104	813	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1637	26	813	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1638	25	814	2	243	\N	0	\N	\N	1	1	2	f	243	\N	\N
1639	84	814	2	10	\N	0	\N	\N	2	1	2	f	10	\N	\N
1640	166	814	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1641	190	814	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1642	104	815	2	993	\N	0	\N	\N	1	1	2	f	993	\N	\N
1643	104	816	2	66354	\N	0	\N	\N	1	1	2	f	66354	\N	\N
1644	104	817	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1645	104	818	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1646	26	818	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1647	104	819	2	13642	\N	13642	\N	\N	1	1	2	f	0	\N	\N
1648	59	819	1	27284	\N	27284	\N	\N	1	1	2	f	\N	\N	\N
1649	104	820	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
1650	105	821	2	16992	\N	0	\N	\N	1	1	2	f	16992	\N	\N
1651	104	822	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1652	104	823	2	48	\N	0	\N	\N	1	1	2	f	48	\N	\N
1653	28	824	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
1654	104	825	2	9214	\N	0	\N	\N	1	1	2	f	9214	\N	\N
1655	62	826	2	21261	\N	21261	\N	\N	1	1	2	f	0	\N	\N
1656	91	826	2	896	\N	896	\N	\N	2	1	2	f	0	\N	\N
1657	37	826	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
1658	123	826	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1659	3	826	1	21975	\N	21975	\N	\N	1	1	2	f	\N	\N	\N
1660	104	827	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1661	104	828	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1662	104	829	2	10748	\N	0	\N	\N	1	1	2	f	10748	\N	\N
1663	60	830	2	7455	\N	0	\N	\N	1	1	2	f	7455	\N	\N
1664	104	831	2	93	\N	0	\N	\N	1	1	2	f	93	\N	\N
1665	104	832	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1666	63	833	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
1667	26	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1668	110	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1669	27	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1670	175	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1671	145	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1672	42	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1673	132	833	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
1674	64	833	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
1675	131	833	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1676	111	833	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1677	10	833	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1678	25	834	2	1221	\N	1221	\N	\N	1	1	2	f	0	\N	\N
1679	104	835	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1680	192	836	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1681	193	837	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1682	60	838	2	7449	\N	0	\N	\N	1	1	2	f	7449	\N	\N
1683	104	839	2	2283531	\N	0	\N	\N	1	1	2	f	2283531	\N	\N
1684	104	840	2	101	\N	101	\N	\N	1	1	2	f	0	\N	\N
1685	123	840	1	101	\N	101	\N	\N	1	1	2	f	\N	\N	\N
1686	62	840	1	101	\N	101	\N	\N	0	1	2	f	\N	\N	\N
1687	104	841	2	9350	\N	0	\N	\N	1	1	2	f	9350	\N	\N
1688	104	842	2	395	\N	0	\N	\N	1	1	2	f	395	\N	\N
1689	104	843	2	8173	\N	0	\N	\N	1	1	2	f	8173	\N	\N
1690	104	844	2	542	\N	0	\N	\N	1	1	2	f	542	\N	\N
1691	104	845	2	2566	\N	2566	\N	\N	1	1	2	f	0	\N	\N
1692	59	845	1	5132	\N	5132	\N	\N	1	1	2	f	\N	\N	\N
1693	104	846	2	8160	\N	0	\N	\N	1	1	2	f	8160	\N	\N
1694	104	847	2	578	\N	578	\N	\N	1	1	2	f	0	\N	\N
1695	37	847	1	578	\N	578	\N	\N	1	1	2	f	\N	\N	\N
1696	62	847	1	578	\N	578	\N	\N	0	1	2	f	\N	\N	\N
1697	104	848	2	578	\N	578	\N	\N	1	1	2	f	0	\N	\N
1698	123	848	1	578	\N	578	\N	\N	1	1	2	f	\N	\N	\N
1699	62	848	1	578	\N	578	\N	\N	0	1	2	f	\N	\N	\N
1700	142	849	2	313262	\N	313262	\N	\N	1	1	2	f	0	\N	\N
1701	104	850	2	578	\N	0	\N	\N	1	1	2	f	578	\N	\N
1702	104	851	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
1703	104	852	2	10749	\N	0	\N	\N	1	1	2	f	10749	\N	\N
1704	104	853	2	578	\N	0	\N	\N	1	1	2	f	578	\N	\N
1705	104	854	2	578	\N	0	\N	\N	1	1	2	f	578	\N	\N
1706	102	855	2	2208	\N	25	\N	\N	1	1	2	f	2183	\N	\N
1707	185	855	2	34	\N	0	\N	\N	2	1	2	f	34	\N	\N
1708	84	855	2	29	\N	14	\N	\N	3	1	2	f	15	\N	\N
1709	62	855	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
1710	190	855	1	25	\N	25	\N	\N	0	1	2	f	\N	\N	\N
1711	104	856	2	731	\N	0	\N	\N	1	1	2	f	731	\N	\N
1712	104	857	2	8335	\N	0	\N	\N	1	1	2	f	8335	\N	\N
1713	25	858	2	1335	\N	0	\N	\N	1	1	2	f	1335	\N	\N
1714	166	858	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1715	57	858	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1716	190	858	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1717	104	859	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
1718	26	859	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
1719	104	860	2	101	\N	0	\N	\N	1	1	2	f	101	\N	\N
1720	104	861	2	10007	\N	10007	\N	\N	1	1	2	f	0	\N	\N
1721	59	861	1	20014	\N	20014	\N	\N	1	1	2	f	\N	\N	\N
1722	104	862	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
1723	39	863	2	1235	\N	0	\N	\N	1	1	2	f	1235	\N	\N
1724	206	864	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1725	104	865	2	101	\N	101	\N	\N	1	1	2	f	0	\N	\N
1726	37	865	1	101	\N	101	\N	\N	1	1	2	f	\N	\N	\N
1727	62	865	1	101	\N	101	\N	\N	0	1	2	f	\N	\N	\N
1728	68	866	2	733	\N	0	\N	\N	1	1	2	f	733	\N	\N
1729	104	867	2	101	\N	0	\N	\N	1	1	2	f	101	\N	\N
1730	104	868	2	101	\N	0	\N	\N	1	1	2	f	101	\N	\N
1731	104	869	2	1122	\N	0	\N	\N	1	1	2	f	1122	\N	\N
1732	195	870	2	2503	\N	0	\N	\N	1	1	2	f	2503	\N	\N
1733	29	870	2	995	\N	0	\N	\N	2	1	2	f	995	\N	\N
1734	196	870	2	730	\N	0	\N	\N	3	1	2	f	730	\N	\N
1735	165	870	2	674	\N	0	\N	\N	4	1	2	f	674	\N	\N
1736	95	870	2	614	\N	0	\N	\N	5	1	2	f	614	\N	\N
1737	96	870	2	321	\N	0	\N	\N	6	1	2	f	321	\N	\N
1738	30	870	2	276	\N	0	\N	\N	7	1	2	f	276	\N	\N
1739	146	870	2	105	\N	0	\N	\N	8	1	2	f	105	\N	\N
1740	148	870	2	85	\N	0	\N	\N	9	1	2	f	85	\N	\N
1741	45	870	2	83	\N	0	\N	\N	10	1	2	f	83	\N	\N
1742	115	870	2	43	\N	0	\N	\N	11	1	2	f	43	\N	\N
1743	180	870	2	34	\N	0	\N	\N	12	1	2	f	34	\N	\N
1744	179	870	2	30	\N	0	\N	\N	13	1	2	f	30	\N	\N
1745	97	870	2	2	\N	0	\N	\N	14	1	2	f	2	\N	\N
1746	104	871	2	555036	\N	555036	\N	\N	1	1	2	f	0	\N	\N
1747	59	871	1	1110072	\N	1110072	\N	\N	1	1	2	f	\N	\N	\N
1748	104	872	2	36225	\N	0	\N	\N	1	1	2	f	36225	\N	\N
1749	59	873	2	37689	\N	37689	\N	\N	1	1	2	f	0	\N	\N
1750	190	873	2	73	\N	73	\N	\N	0	1	2	f	0	\N	\N
1751	129	873	1	37631	\N	37631	\N	\N	1	1	2	f	\N	\N	\N
1752	57	873	1	73	\N	73	\N	\N	2	1	2	f	\N	\N	\N
1753	104	874	2	48	\N	0	\N	\N	1	1	2	f	48	\N	\N
1754	104	875	2	4810	\N	4810	\N	\N	1	1	2	f	0	\N	\N
1755	59	875	1	9620	\N	9620	\N	\N	1	1	2	f	\N	\N	\N
1756	104	876	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
1757	104	877	2	7376	\N	7376	\N	\N	1	1	2	f	0	\N	\N
1758	59	877	1	14752	\N	14752	\N	\N	1	1	2	f	\N	\N	\N
1759	104	878	2	53994	\N	53994	\N	\N	1	1	2	f	0	\N	\N
1760	59	878	1	107988	\N	107988	\N	\N	1	1	2	f	\N	\N	\N
1761	104	879	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
1762	124	880	2	2864	\N	2864	\N	\N	1	1	2	f	0	\N	\N
1763	125	880	2	133	\N	133	\N	\N	2	1	2	f	0	\N	\N
1764	158	880	2	94	\N	94	\N	\N	3	1	2	f	0	\N	\N
1765	8	880	2	1991	\N	1991	\N	\N	0	1	2	f	0	\N	\N
1766	86	880	2	706	\N	706	\N	\N	0	1	2	f	0	\N	\N
1767	40	880	2	706	\N	706	\N	\N	0	1	2	f	0	\N	\N
1768	2	880	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
1769	23	880	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1770	114	880	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1771	1	880	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1772	46	880	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1773	65	880	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1774	38	880	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1775	205	880	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1776	57	880	1	836	\N	836	\N	\N	1	1	2	f	\N	\N	\N
1777	44	880	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1778	83	880	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
1779	93	880	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
1780	189	880	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
1781	104	881	2	2969	\N	2969	\N	\N	1	1	2	f	0	\N	\N
1782	59	881	1	5938	\N	5938	\N	\N	1	1	2	f	\N	\N	\N
1783	185	882	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1784	102	882	2	5	\N	0	\N	\N	2	1	2	f	5	\N	\N
1785	57	882	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
1786	104	883	2	745	\N	0	\N	\N	1	1	2	f	745	\N	\N
1787	104	884	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1788	104	885	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1789	102	886	2	2954	\N	0	\N	\N	1	1	2	f	2954	\N	\N
1790	185	886	2	34	\N	0	\N	\N	2	1	2	f	34	\N	\N
1791	104	887	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
1792	59	887	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
1793	104	888	2	314377	\N	314377	\N	\N	1	1	2	f	0	\N	\N
1794	59	888	1	628754	\N	628754	\N	\N	1	1	2	f	\N	\N	\N
1795	104	889	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
1796	26	889	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1797	104	890	2	9214	\N	0	\N	\N	1	1	2	f	9214	\N	\N
1798	104	891	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
1799	104	892	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
1800	104	893	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
1801	59	893	1	50	\N	50	\N	\N	1	1	2	f	\N	\N	\N
1802	104	894	2	18575	\N	0	\N	\N	1	1	2	f	18575	\N	\N
1803	108	895	2	6022	\N	6022	\N	\N	1	1	2	f	0	\N	\N
1804	85	895	1	6007	\N	6007	\N	\N	1	1	2	f	\N	\N	\N
1805	104	896	2	5248425	\N	5248425	\N	\N	1	1	2	f	0	\N	\N
1806	105	896	2	1430317	\N	1430317	\N	\N	2	1	2	f	0	\N	\N
1807	157	896	2	362677	\N	362677	\N	\N	3	1	2	f	0	\N	\N
1808	142	896	2	313399	\N	313399	\N	\N	4	1	2	f	0	\N	\N
1809	190	896	2	132283	\N	132283	\N	\N	5	1	2	f	0	\N	\N
1810	127	896	2	50164	\N	50164	\N	\N	6	1	2	f	0	\N	\N
1811	99	896	2	48062	\N	48062	\N	\N	7	1	2	f	0	\N	\N
1812	59	896	2	38481	\N	38481	\N	\N	8	1	2	f	0	\N	\N
1813	11	896	2	35715	\N	35715	\N	\N	9	1	2	f	0	\N	\N
1814	62	896	2	33949	\N	33949	\N	\N	10	1	2	f	0	\N	\N
1815	128	896	2	32320	\N	32320	\N	\N	11	1	2	f	0	\N	\N
1816	3	896	2	24415	\N	24415	\N	\N	12	1	2	f	0	\N	\N
1817	106	896	2	22514	\N	22514	\N	\N	13	1	2	f	0	\N	\N
1818	170	896	2	21137	\N	21137	\N	\N	14	1	2	f	0	\N	\N
1819	60	896	2	7452	\N	7452	\N	\N	15	1	2	f	0	\N	\N
1820	24	896	2	7452	\N	7452	\N	\N	16	1	2	f	0	\N	\N
1821	61	896	2	7452	\N	7452	\N	\N	17	1	2	f	0	\N	\N
1822	63	896	2	6912	\N	6912	\N	\N	18	1	2	f	0	\N	\N
1823	124	896	2	6278	\N	6278	\N	\N	19	1	2	f	0	\N	\N
1824	108	896	2	6016	\N	6016	\N	\N	20	1	2	f	0	\N	\N
1825	9	896	2	6004	\N	6004	\N	\N	21	1	2	f	0	\N	\N
1826	39	896	2	4473	\N	4473	\N	\N	22	1	2	f	0	\N	\N
1827	4	896	2	4454	\N	4454	\N	\N	23	1	2	f	0	\N	\N
1828	5	896	2	2808	\N	2808	\N	\N	23	1	2	f	0	\N	\N
1829	19	896	2	4225	\N	4225	\N	\N	24	1	2	f	0	\N	\N
1830	68	896	2	4216	\N	4216	\N	\N	25	1	2	f	0	\N	\N
1831	8	896	2	4020	\N	4020	\N	\N	26	1	2	f	0	\N	\N
1832	67	896	2	3453	\N	3453	\N	\N	27	1	2	f	0	\N	\N
1833	176	896	2	3453	\N	3453	\N	\N	28	1	2	f	0	\N	\N
1834	22	896	2	3282	\N	3282	\N	\N	29	1	2	f	0	\N	\N
1835	85	896	2	3164	\N	3164	\N	\N	30	1	2	f	0	\N	\N
1836	102	896	2	2994	\N	2994	\N	\N	31	1	2	f	0	\N	\N
1837	107	896	2	2888	\N	2888	\N	\N	32	1	2	f	0	\N	\N
1838	161	896	2	2834	\N	2834	\N	\N	33	1	2	f	0	\N	\N
1839	101	896	2	2511	\N	2511	\N	\N	35	1	2	f	0	\N	\N
1840	195	896	2	2503	\N	2503	\N	\N	36	1	2	f	0	\N	\N
1841	40	896	2	2181	\N	2181	\N	\N	37	1	2	f	0	\N	\N
1842	109	896	2	2106	\N	2106	\N	\N	38	1	2	f	0	\N	\N
1843	51	896	2	2061	\N	2061	\N	\N	39	1	2	f	0	\N	\N
1844	202	896	2	1838	\N	1838	\N	\N	40	1	2	f	0	\N	\N
1845	6	896	2	1699	\N	1699	\N	\N	41	1	2	f	0	\N	\N
1846	36	896	2	1594	\N	1594	\N	\N	42	1	2	f	0	\N	\N
1847	134	896	2	1496	\N	1496	\N	\N	43	1	2	f	0	\N	\N
1848	25	896	2	1357	\N	1357	\N	\N	44	1	2	f	0	\N	\N
1849	186	896	2	1207	\N	1207	\N	\N	45	1	2	f	0	\N	\N
1850	29	896	2	995	\N	995	\N	\N	46	1	2	f	0	\N	\N
1851	90	896	2	913	\N	913	\N	\N	47	1	2	f	0	\N	\N
1852	91	896	2	896	\N	896	\N	\N	48	1	2	f	0	\N	\N
1853	57	896	2	866	\N	866	\N	\N	49	1	2	f	0	\N	\N
1854	53	896	2	862	\N	862	\N	\N	50	1	2	f	0	\N	\N
1855	66	896	2	825	\N	825	\N	\N	51	1	2	f	0	\N	\N
1856	126	896	2	821	\N	821	\N	\N	52	1	2	f	0	\N	\N
1857	155	896	2	798	\N	798	\N	\N	53	1	2	f	0	\N	\N
1858	196	896	2	730	\N	730	\N	\N	54	1	2	f	0	\N	\N
1859	129	896	2	698	\N	698	\N	\N	55	1	2	f	0	\N	\N
1860	165	896	2	674	\N	674	\N	\N	56	1	2	f	0	\N	\N
1861	95	896	2	614	\N	614	\N	\N	57	1	2	f	0	\N	\N
1862	159	896	2	588	\N	588	\N	\N	58	1	2	f	0	\N	\N
1863	160	896	2	393	\N	393	\N	\N	59	1	2	f	0	\N	\N
1864	96	896	2	321	\N	321	\N	\N	60	1	2	f	0	\N	\N
1865	20	896	2	297	\N	297	\N	\N	61	1	2	f	0	\N	\N
1866	174	896	2	281	\N	281	\N	\N	62	1	2	f	0	\N	\N
1867	30	896	2	276	\N	276	\N	\N	63	1	2	f	0	\N	\N
1868	50	896	2	262	\N	262	\N	\N	64	1	2	f	0	\N	\N
1869	82	896	2	226	\N	226	\N	\N	65	1	2	f	0	\N	\N
1870	125	896	2	198	\N	198	\N	\N	66	1	2	f	0	\N	\N
1871	2	896	2	188	\N	188	\N	\N	67	1	2	f	0	\N	\N
1872	70	896	2	181	\N	181	\N	\N	68	1	2	f	0	\N	\N
1873	158	896	2	153	\N	153	\N	\N	69	1	2	f	0	\N	\N
1874	76	896	2	134	\N	134	\N	\N	70	1	2	f	0	\N	\N
1875	15	896	2	134	\N	134	\N	\N	70	1	2	f	0	\N	\N
1876	54	896	2	128	\N	128	\N	\N	71	1	2	f	0	\N	\N
1877	144	896	2	124	\N	124	\N	\N	72	1	2	f	0	\N	\N
1878	103	896	2	119	\N	119	\N	\N	73	1	2	f	0	\N	\N
1879	206	896	2	116	\N	116	\N	\N	74	1	2	f	0	\N	\N
1880	204	896	2	115	\N	115	\N	\N	75	1	2	f	0	\N	\N
1881	146	896	2	105	\N	105	\N	\N	76	1	2	f	0	\N	\N
1882	140	896	2	95	\N	95	\N	\N	77	1	2	f	0	\N	\N
1883	148	896	2	85	\N	85	\N	\N	78	1	2	f	0	\N	\N
1884	45	896	2	83	\N	83	\N	\N	79	1	2	f	0	\N	\N
1885	194	896	2	67	\N	67	\N	\N	80	1	2	f	0	\N	\N
1886	23	896	2	56	\N	56	\N	\N	81	1	2	f	0	\N	\N
1887	80	896	2	49	\N	49	\N	\N	82	1	2	f	0	\N	\N
1888	21	896	2	49	\N	49	\N	\N	83	1	2	f	0	\N	\N
1889	115	896	2	43	\N	43	\N	\N	84	1	2	f	0	\N	\N
1890	7	896	2	35	\N	35	\N	\N	85	1	2	f	0	\N	\N
1891	72	896	2	35	\N	35	\N	\N	86	1	2	f	0	\N	\N
1892	180	896	2	34	\N	34	\N	\N	87	1	2	f	0	\N	\N
1893	185	896	2	34	\N	34	\N	\N	88	1	2	f	0	\N	\N
1894	69	896	2	30	\N	30	\N	\N	89	1	2	f	0	\N	\N
1895	162	896	2	30	\N	30	\N	\N	90	1	2	f	0	\N	\N
1896	179	896	2	30	\N	30	\N	\N	91	1	2	f	0	\N	\N
1897	87	896	2	25	\N	25	\N	\N	92	1	2	f	0	\N	\N
1898	156	896	2	24	\N	24	\N	\N	93	1	2	f	0	\N	\N
1899	52	896	2	20	\N	20	\N	\N	94	1	2	f	0	\N	\N
1900	163	896	2	19	\N	19	\N	\N	95	1	2	f	0	\N	\N
1901	112	896	2	14	\N	14	\N	\N	96	1	2	f	0	\N	\N
1902	203	896	2	14	\N	14	\N	\N	97	1	2	f	0	\N	\N
1903	177	896	2	11	\N	11	\N	\N	98	1	2	f	0	\N	\N
1904	84	896	2	10	\N	10	\N	\N	99	1	2	f	0	\N	\N
1905	171	896	2	10	\N	10	\N	\N	100	1	2	f	0	\N	\N
1906	130	896	2	8	\N	8	\N	\N	101	1	2	f	0	\N	\N
1907	147	896	2	6	\N	6	\N	\N	102	1	2	f	0	\N	\N
1908	65	896	2	6	\N	6	\N	\N	103	1	2	f	0	\N	\N
1909	41	896	2	4	\N	4	\N	\N	103	1	2	f	0	\N	\N
1910	187	896	2	6	\N	6	\N	\N	104	1	2	f	0	\N	\N
1911	100	896	2	6	\N	6	\N	\N	105	1	2	f	0	\N	\N
1912	172	896	2	4	\N	4	\N	\N	106	1	2	f	0	\N	\N
1913	28	896	2	3	\N	3	\N	\N	108	1	2	f	0	\N	\N
1914	113	896	2	3	\N	3	\N	\N	109	1	2	f	0	\N	\N
1915	92	896	2	2	\N	2	\N	\N	110	1	2	f	0	\N	\N
1916	93	896	2	2	\N	2	\N	\N	111	1	2	f	0	\N	\N
1917	44	896	2	2	\N	2	\N	\N	112	1	2	f	0	\N	\N
1918	75	896	2	2	\N	2	\N	\N	113	1	2	f	0	\N	\N
1919	97	896	2	2	\N	2	\N	\N	114	1	2	f	0	\N	\N
1920	141	896	2	2	\N	2	\N	\N	115	1	2	f	0	\N	\N
1921	188	896	2	2	\N	2	\N	\N	116	1	2	f	0	\N	\N
1922	143	896	2	2	\N	2	\N	\N	117	1	2	f	0	\N	\N
1923	83	896	2	1	\N	1	\N	\N	118	1	2	f	0	\N	\N
1924	58	896	2	1	\N	1	\N	\N	119	1	2	f	0	\N	\N
1925	192	896	2	1	\N	1	\N	\N	120	1	2	f	0	\N	\N
1926	12	896	2	1	\N	1	\N	\N	121	1	2	f	0	\N	\N
1927	73	896	2	1	\N	1	\N	\N	122	1	2	f	0	\N	\N
1928	193	896	2	1	\N	1	\N	\N	123	1	2	f	0	\N	\N
1929	133	896	2	1	\N	1	\N	\N	124	1	2	f	0	\N	\N
1930	164	896	2	1	\N	1	\N	\N	125	1	2	f	0	\N	\N
1931	178	896	2	1	\N	1	\N	\N	126	1	2	f	0	\N	\N
1932	14	896	2	1	\N	1	\N	\N	127	1	2	f	0	\N	\N
1933	81	896	2	1	\N	1	\N	\N	128	1	2	f	0	\N	\N
1934	55	896	2	1	\N	1	\N	\N	129	1	2	f	0	\N	\N
1935	26	896	2	61232	\N	61232	\N	\N	0	1	2	f	0	\N	\N
1936	110	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1937	27	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1938	175	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1939	145	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1940	42	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1941	132	896	2	6912	\N	6912	\N	\N	0	1	2	f	0	\N	\N
1942	64	896	2	6579	\N	6579	\N	\N	0	1	2	f	0	\N	\N
1943	86	896	2	2118	\N	2118	\N	\N	0	1	2	f	0	\N	\N
1944	37	896	2	1462	\N	1462	\N	\N	0	1	2	f	0	\N	\N
1945	131	896	2	297	\N	297	\N	\N	0	1	2	f	0	\N	\N
1946	189	896	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1947	191	896	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
1948	71	896	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1949	111	896	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1950	43	896	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1951	114	896	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1952	10	896	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1953	88	896	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1954	89	896	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1955	46	896	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1956	1	896	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1957	123	896	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1958	38	896	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1959	205	896	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1960	173	896	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1961	13	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1962	74	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1963	94	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1964	166	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1965	47	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1966	77	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1967	167	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1968	116	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1969	16	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1970	117	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1971	31	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1972	118	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1973	181	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1974	78	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1975	149	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1976	197	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1977	17	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1978	32	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1979	182	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1980	168	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1981	33	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1982	150	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1983	48	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1984	151	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1985	152	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1986	135	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1987	153	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1988	34	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1989	119	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1990	79	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1991	198	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1992	136	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1993	199	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1994	200	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1995	49	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1996	183	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1997	35	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1998	201	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1999	169	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2000	184	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2001	137	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2002	154	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2003	120	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2004	138	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2005	121	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2006	98	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2007	18	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2008	139	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2009	122	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2010	56	896	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2011	57	896	1	7052483	\N	7052483	\N	\N	1	1	2	f	\N	\N	\N
2012	125	896	1	3478	\N	3478	\N	\N	2	1	2	f	\N	\N	\N
2013	189	896	1	1350	\N	1350	\N	\N	0	1	2	f	\N	\N	\N
2014	104	897	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2015	59	897	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2016	104	898	2	120	\N	0	\N	\N	1	1	2	f	120	\N	\N
2017	104	899	2	2126	\N	2126	\N	\N	1	1	2	f	0	\N	\N
2018	59	899	1	4252	\N	4252	\N	\N	1	1	2	f	\N	\N	\N
2019	104	901	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
2020	163	902	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
2021	104	903	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
2022	104	904	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
2023	99	905	2	48062	\N	0	\N	\N	1	1	2	f	48062	\N	\N
2024	11	905	2	35715	\N	0	\N	\N	2	1	2	f	35715	\N	\N
2025	170	905	2	21137	\N	0	\N	\N	3	1	2	f	21137	\N	\N
2026	39	905	2	4474	\N	0	\N	\N	4	1	2	f	4474	\N	\N
2027	19	905	2	4225	\N	0	\N	\N	5	1	2	f	4225	\N	\N
2028	68	905	2	3433	\N	0	\N	\N	6	1	2	f	3433	\N	\N
2029	195	905	2	2503	\N	0	\N	\N	7	1	2	f	2503	\N	\N
2030	51	905	2	2061	\N	0	\N	\N	8	1	2	f	2061	\N	\N
2031	202	905	2	1838	\N	0	\N	\N	9	1	2	f	1838	\N	\N
2032	36	905	2	1594	\N	0	\N	\N	10	1	2	f	1594	\N	\N
2033	186	905	2	1207	\N	0	\N	\N	11	1	2	f	1207	\N	\N
2034	29	905	2	995	\N	0	\N	\N	12	1	2	f	995	\N	\N
2035	90	905	2	913	\N	0	\N	\N	13	1	2	f	913	\N	\N
2036	91	905	2	896	\N	0	\N	\N	14	1	2	f	896	\N	\N
2037	53	905	2	862	\N	0	\N	\N	15	1	2	f	862	\N	\N
2038	155	905	2	798	\N	0	\N	\N	16	1	2	f	798	\N	\N
2039	62	905	2	735	\N	0	\N	\N	17	1	2	f	735	\N	\N
2040	196	905	2	730	\N	0	\N	\N	18	1	2	f	730	\N	\N
2041	165	905	2	674	\N	0	\N	\N	19	1	2	f	674	\N	\N
2042	95	905	2	614	\N	0	\N	\N	20	1	2	f	614	\N	\N
2043	96	905	2	321	\N	0	\N	\N	21	1	2	f	321	\N	\N
2044	20	905	2	297	\N	0	\N	\N	22	1	2	f	297	\N	\N
2045	174	905	2	281	\N	0	\N	\N	23	1	2	f	281	\N	\N
2046	30	905	2	276	\N	0	\N	\N	24	1	2	f	276	\N	\N
2047	82	905	2	226	\N	0	\N	\N	25	1	2	f	226	\N	\N
2048	70	905	2	181	\N	0	\N	\N	26	1	2	f	181	\N	\N
2049	144	905	2	132	\N	0	\N	\N	27	1	2	f	132	\N	\N
2050	54	905	2	128	\N	0	\N	\N	28	1	2	f	128	\N	\N
2051	146	905	2	105	\N	0	\N	\N	29	1	2	f	105	\N	\N
2052	140	905	2	95	\N	0	\N	\N	30	1	2	f	95	\N	\N
2053	148	905	2	85	\N	0	\N	\N	31	1	2	f	85	\N	\N
2054	45	905	2	83	\N	0	\N	\N	32	1	2	f	83	\N	\N
2055	80	905	2	49	\N	0	\N	\N	33	1	2	f	49	\N	\N
2056	21	905	2	49	\N	0	\N	\N	34	1	2	f	49	\N	\N
2057	115	905	2	43	\N	0	\N	\N	35	1	2	f	43	\N	\N
2058	72	905	2	35	\N	0	\N	\N	36	1	2	f	35	\N	\N
2059	180	905	2	34	\N	0	\N	\N	37	1	2	f	34	\N	\N
2060	69	905	2	30	\N	0	\N	\N	38	1	2	f	30	\N	\N
2061	179	905	2	30	\N	0	\N	\N	39	1	2	f	30	\N	\N
2062	87	905	2	25	\N	0	\N	\N	40	1	2	f	25	\N	\N
2063	52	905	2	20	\N	0	\N	\N	41	1	2	f	20	\N	\N
2064	163	905	2	19	\N	0	\N	\N	42	1	2	f	19	\N	\N
2065	203	905	2	14	\N	0	\N	\N	43	1	2	f	14	\N	\N
2066	130	905	2	8	\N	0	\N	\N	44	1	2	f	8	\N	\N
2067	187	905	2	6	\N	0	\N	\N	45	1	2	f	6	\N	\N
2068	100	905	2	6	\N	0	\N	\N	46	1	2	f	6	\N	\N
2069	88	905	2	3	\N	0	\N	\N	47	1	2	f	3	\N	\N
2070	97	905	2	2	\N	0	\N	\N	48	1	2	f	2	\N	\N
2071	37	905	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
2072	190	905	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2073	89	905	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2074	123	905	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2075	56	905	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2076	104	906	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
2077	99	907	2	48062	\N	0	\N	\N	1	1	2	f	48062	\N	\N
2078	11	907	2	35715	\N	0	\N	\N	2	1	2	f	35715	\N	\N
2079	62	907	2	31549	\N	0	\N	\N	3	1	2	f	31549	\N	\N
2080	106	907	2	22514	\N	0	\N	\N	4	1	2	f	22514	\N	\N
2081	170	907	2	21137	\N	0	\N	\N	5	1	2	f	21137	\N	\N
2082	39	907	2	4473	\N	0	\N	\N	6	1	2	f	4473	\N	\N
2083	19	907	2	4225	\N	0	\N	\N	7	1	2	f	4225	\N	\N
2084	102	907	2	2304	\N	0	\N	\N	8	1	2	f	2304	\N	\N
2085	109	907	2	2106	\N	0	\N	\N	9	1	2	f	2106	\N	\N
2086	51	907	2	2061	\N	0	\N	\N	10	1	2	f	2061	\N	\N
2087	186	907	2	1207	\N	0	\N	\N	11	1	2	f	1207	\N	\N
2088	53	907	2	862	\N	0	\N	\N	12	1	2	f	862	\N	\N
2089	59	907	2	683	\N	0	\N	\N	13	1	2	f	683	\N	\N
2090	85	907	2	478	\N	0	\N	\N	14	1	2	f	478	\N	\N
2091	57	907	2	317	\N	0	\N	\N	15	1	2	f	317	\N	\N
2092	20	907	2	297	\N	0	\N	\N	16	1	2	f	297	\N	\N
2093	70	907	2	181	\N	0	\N	\N	17	1	2	f	181	\N	\N
2094	54	907	2	128	\N	0	\N	\N	18	1	2	f	128	\N	\N
2095	50	907	2	100	\N	0	\N	\N	19	1	2	f	100	\N	\N
2096	185	907	2	34	\N	0	\N	\N	20	1	2	f	34	\N	\N
2097	162	907	2	30	\N	0	\N	\N	21	1	2	f	30	\N	\N
2098	156	907	2	25	\N	0	\N	\N	22	1	2	f	25	\N	\N
2099	87	907	2	25	\N	0	\N	\N	23	1	2	f	25	\N	\N
2100	171	907	2	10	\N	0	\N	\N	24	1	2	f	10	\N	\N
2101	100	907	2	6	\N	0	\N	\N	25	1	2	f	6	\N	\N
2102	141	907	2	2	\N	0	\N	\N	26	1	2	f	2	\N	\N
2103	188	907	2	2	\N	0	\N	\N	27	1	2	f	2	\N	\N
2104	81	907	2	1	\N	0	\N	\N	28	1	2	f	1	\N	\N
2105	125	907	2	1	\N	0	\N	\N	29	1	2	f	1	\N	\N
2106	37	907	2	1579	\N	0	\N	\N	0	1	2	f	1579	\N	\N
2107	123	907	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2108	190	907	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2109	56	907	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2110	104	908	2	3909	\N	3909	\N	\N	1	1	2	f	0	\N	\N
2111	59	908	1	7818	\N	7818	\N	\N	1	1	2	f	\N	\N	\N
2112	104	909	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
2113	104	910	2	70	\N	0	\N	\N	1	1	2	f	70	\N	\N
2114	104	911	2	206	\N	0	\N	\N	1	1	2	f	206	\N	\N
2115	104	912	2	35279	\N	0	\N	\N	1	1	2	f	35279	\N	\N
2116	104	913	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
2117	104	914	2	164	\N	0	\N	\N	1	1	2	f	164	\N	\N
2118	104	915	2	133	\N	0	\N	\N	1	1	2	f	133	\N	\N
2119	67	916	2	3453	\N	3453	\N	\N	1	1	2	f	0	\N	\N
2120	176	916	1	3453	\N	3453	\N	\N	1	1	2	f	\N	\N	\N
2121	104	917	2	134	\N	0	\N	\N	1	1	2	f	134	\N	\N
2122	104	918	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2123	104	919	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2124	26	919	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2125	104	920	2	56690	\N	56690	\N	\N	1	1	2	f	0	\N	\N
2126	59	920	1	113380	\N	113380	\N	\N	1	1	2	f	\N	\N	\N
2127	193	921	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2128	25	922	2	1335	\N	1335	\N	\N	1	1	2	f	0	\N	\N
2129	102	923	2	145	\N	0	\N	\N	1	1	2	f	145	\N	\N
2130	204	923	2	115	\N	0	\N	\N	2	1	2	f	115	\N	\N
2131	104	924	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
2132	195	925	2	5701	\N	5701	\N	\N	1	1	2	f	0	\N	\N
2133	29	925	2	2450	\N	2450	\N	\N	2	1	2	f	0	\N	\N
2134	179	925	2	900	\N	900	\N	\N	3	1	2	f	0	\N	\N
2135	165	925	2	799	\N	799	\N	\N	4	1	2	f	0	\N	\N
2136	196	925	2	730	\N	730	\N	\N	5	1	2	f	0	\N	\N
2137	95	925	2	695	\N	695	\N	\N	6	1	2	f	0	\N	\N
2138	96	925	2	321	\N	321	\N	\N	7	1	2	f	0	\N	\N
2139	30	925	2	276	\N	276	\N	\N	8	1	2	f	0	\N	\N
2140	146	925	2	105	\N	105	\N	\N	9	1	2	f	0	\N	\N
2141	180	925	2	95	\N	95	\N	\N	10	1	2	f	0	\N	\N
2142	45	925	2	89	\N	89	\N	\N	11	1	2	f	0	\N	\N
2143	148	925	2	85	\N	85	\N	\N	12	1	2	f	0	\N	\N
2144	115	925	2	79	\N	79	\N	\N	13	1	2	f	0	\N	\N
2145	97	925	2	2	\N	2	\N	\N	14	1	2	f	0	\N	\N
2146	57	925	1	8232	\N	8232	\N	\N	1	1	2	f	\N	\N	\N
2147	104	926	2	173045	\N	0	\N	\N	1	1	2	f	173045	\N	\N
2148	104	927	2	3570502	\N	3570502	\N	\N	1	1	2	f	0	\N	\N
2149	63	927	1	3568079	\N	3568079	\N	\N	1	1	2	f	\N	\N	\N
2150	26	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2151	110	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2152	27	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2153	175	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2154	145	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2155	42	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2156	132	927	1	3568079	\N	3568079	\N	\N	0	1	2	f	\N	\N	\N
2157	64	927	1	1847983	\N	1847983	\N	\N	0	1	2	f	\N	\N	\N
2158	131	927	1	975915	\N	975915	\N	\N	0	1	2	f	\N	\N	\N
2159	111	927	1	609730	\N	609730	\N	\N	0	1	2	f	\N	\N	\N
2160	10	927	1	134451	\N	134451	\N	\N	0	1	2	f	\N	\N	\N
2161	25	929	2	2892	\N	2892	\N	\N	1	1	2	f	0	\N	\N
2162	107	929	1	2890	\N	2890	\N	\N	1	1	2	f	\N	\N	\N
2163	104	930	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2164	59	930	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2165	104	931	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
2166	104	932	2	19200	\N	0	\N	\N	1	1	2	f	19200	\N	\N
2167	104	933	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2168	104	934	2	13267	\N	13267	\N	\N	1	1	2	f	0	\N	\N
2169	59	934	1	26534	\N	26534	\N	\N	1	1	2	f	\N	\N	\N
2170	104	935	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2171	104	936	2	110056	\N	110056	\N	\N	1	1	2	f	0	\N	\N
2172	59	936	1	220112	\N	220112	\N	\N	1	1	2	f	\N	\N	\N
2173	104	937	2	17427	\N	0	\N	\N	1	1	2	f	17427	\N	\N
2174	104	938	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2175	104	939	2	35279	\N	0	\N	\N	1	1	2	f	35279	\N	\N
2176	104	940	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2177	104	941	2	3902	\N	0	\N	\N	1	1	2	f	3902	\N	\N
2178	104	942	2	223	\N	0	\N	\N	1	1	2	f	223	\N	\N
2179	104	943	2	226	\N	0	\N	\N	1	1	2	f	226	\N	\N
2180	104	944	2	528	\N	0	\N	\N	1	1	2	f	528	\N	\N
2181	104	945	2	304	\N	0	\N	\N	1	1	2	f	304	\N	\N
2182	104	946	2	101	\N	0	\N	\N	1	1	2	f	101	\N	\N
2183	104	947	2	101	\N	0	\N	\N	1	1	2	f	101	\N	\N
2184	104	948	2	505	\N	0	\N	\N	1	1	2	f	505	\N	\N
2185	106	949	2	25118	\N	25118	\N	\N	1	1	2	f	0	\N	\N
2186	128	949	1	25118	\N	25118	\N	\N	1	1	2	f	\N	\N	\N
2187	104	950	2	304	\N	0	\N	\N	1	1	2	f	304	\N	\N
2188	104	951	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2189	57	952	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2190	193	952	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2191	164	952	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
2192	57	952	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
2193	104	953	2	6487	\N	6487	\N	\N	1	1	2	f	0	\N	\N
2194	59	953	1	12974	\N	12974	\N	\N	1	1	2	f	\N	\N	\N
2195	28	954	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2196	44	954	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2197	189	954	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2198	106	955	2	14962	\N	0	\N	\N	1	1	2	f	14962	\N	\N
2199	62	955	2	4322	\N	0	\N	\N	2	1	2	f	4322	\N	\N
2200	185	955	2	34	\N	0	\N	\N	3	1	2	f	34	\N	\N
2201	84	955	2	7	\N	0	\N	\N	4	1	2	f	7	\N	\N
2202	166	955	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
2203	190	955	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2204	104	956	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
2205	26	956	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
2206	104	957	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
2207	26	957	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2208	28	958	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2209	104	959	2	9176	\N	9176	\N	\N	1	1	2	f	0	\N	\N
2210	59	959	1	18352	\N	18352	\N	\N	1	1	2	f	\N	\N	\N
2211	104	960	2	144	\N	144	\N	\N	1	1	2	f	0	\N	\N
2212	59	960	1	288	\N	288	\N	\N	1	1	2	f	\N	\N	\N
2213	104	961	2	6845	\N	0	\N	\N	1	1	2	f	6845	\N	\N
2214	104	962	2	35780	\N	0	\N	\N	1	1	2	f	35780	\N	\N
2215	134	963	2	959	\N	0	\N	\N	1	1	2	f	959	\N	\N
2216	57	964	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
2217	57	964	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
2218	104	965	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2219	76	966	2	67	\N	67	\N	\N	1	1	2	f	0	\N	\N
2220	15	966	2	67	\N	67	\N	\N	1	1	2	f	0	\N	\N
2221	190	966	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
2222	57	966	2	3	\N	2	\N	\N	3	1	2	f	1	\N	\N
2223	82	966	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
2224	161	966	2	2	\N	2	\N	\N	5	1	2	f	0	\N	\N
2225	46	966	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
2226	87	966	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
2227	43	966	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2228	125	966	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2229	114	966	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2230	62	966	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2231	104	967	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2232	59	967	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2233	64	968	2	731	\N	731	\N	\N	1	1	2	f	0	\N	\N
2234	26	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2235	63	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2236	110	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2237	27	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2238	175	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2239	145	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2240	42	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2241	132	968	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2242	131	968	1	710	\N	710	\N	\N	1	1	2	f	\N	\N	\N
2243	26	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2244	63	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2245	110	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2246	27	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2247	175	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2248	145	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2249	42	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2250	132	968	1	710	\N	710	\N	\N	0	1	2	f	\N	\N	\N
2251	104	969	2	7376	\N	7376	\N	\N	1	1	2	f	0	\N	\N
2252	59	969	1	14752	\N	14752	\N	\N	1	1	2	f	\N	\N	\N
2253	4	970	2	3480	\N	0	\N	\N	1	1	2	f	3480	\N	\N
2254	5	970	2	974	\N	0	\N	\N	1	1	2	f	974	\N	\N
2255	104	971	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
2256	104	972	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2257	26	972	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2258	104	973	2	9425	\N	0	\N	\N	1	1	2	f	9425	\N	\N
2259	104	974	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
2260	26	974	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
2261	84	975	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2262	193	975	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2263	104	976	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2264	104	977	2	56831	\N	0	\N	\N	1	1	2	f	56831	\N	\N
2265	104	978	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
2266	104	979	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2267	104	980	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2268	104	981	2	3066	\N	0	\N	\N	1	1	2	f	3066	\N	\N
2269	104	982	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2270	104	983	2	1121	\N	1121	\N	\N	1	1	2	f	0	\N	\N
2271	37	983	1	1121	\N	1121	\N	\N	1	1	2	f	\N	\N	\N
2272	62	983	1	1121	\N	1121	\N	\N	0	1	2	f	\N	\N	\N
2273	104	984	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2274	104	985	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2275	104	986	2	1122	\N	1122	\N	\N	1	1	2	f	0	\N	\N
2276	123	986	1	1122	\N	1122	\N	\N	1	1	2	f	\N	\N	\N
2277	62	986	1	1122	\N	1122	\N	\N	0	1	2	f	\N	\N	\N
2278	104	987	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2279	104	988	2	808	\N	0	\N	\N	1	1	2	f	808	\N	\N
2280	104	989	2	1123	\N	0	\N	\N	1	1	2	f	1123	\N	\N
2281	69	990	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
2282	104	991	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2283	104	992	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2284	64	993	2	730	\N	0	\N	\N	1	1	2	f	730	\N	\N
2285	26	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2286	63	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2287	110	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2288	27	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2289	175	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2290	145	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2291	42	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2292	132	993	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
2293	104	994	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2294	104	995	2	34274	\N	0	\N	\N	1	1	2	f	34274	\N	\N
2295	142	996	2	285487	\N	285487	\N	\N	1	1	2	f	0	\N	\N
2296	104	997	2	53907	\N	53907	\N	\N	1	1	2	f	0	\N	\N
2297	59	997	1	107814	\N	107814	\N	\N	1	1	2	f	\N	\N	\N
2298	160	998	2	2404	\N	2404	\N	\N	1	1	2	f	0	\N	\N
2299	4	998	2	867	\N	867	\N	\N	2	1	2	f	0	\N	\N
2300	5	998	2	866	\N	866	\N	\N	2	1	2	f	0	\N	\N
2301	62	998	2	771	\N	771	\N	\N	4	1	2	f	0	\N	\N
2302	50	998	2	100	\N	100	\N	\N	5	1	2	f	0	\N	\N
2303	193	998	2	2	\N	2	\N	\N	6	1	2	f	0	\N	\N
2304	37	998	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
2305	123	998	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2306	56	998	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2307	63	998	1	768	\N	768	\N	\N	1	1	2	f	\N	\N	\N
2308	50	998	1	100	\N	100	\N	\N	2	1	2	f	\N	\N	\N
2309	26	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2310	110	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2311	27	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2312	175	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2313	145	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2314	42	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2315	132	998	1	768	\N	768	\N	\N	0	1	2	f	\N	\N	\N
2316	64	998	1	731	\N	731	\N	\N	0	1	2	f	\N	\N	\N
2317	131	998	1	33	\N	33	\N	\N	0	1	2	f	\N	\N	\N
2318	111	998	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2319	10	998	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2320	104	999	2	828	\N	828	\N	\N	1	1	2	f	0	\N	\N
2321	37	999	1	828	\N	828	\N	\N	1	1	2	f	\N	\N	\N
2322	62	999	1	828	\N	828	\N	\N	0	1	2	f	\N	\N	\N
2323	104	1000	2	7060	\N	7060	\N	\N	1	1	2	f	0	\N	\N
2324	59	1000	1	14120	\N	14120	\N	\N	1	1	2	f	\N	\N	\N
2325	104	1001	2	828	\N	0	\N	\N	1	1	2	f	828	\N	\N
2326	104	1002	2	1532	\N	0	\N	\N	1	1	2	f	1532	\N	\N
2327	104	1003	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2328	104	1004	2	828	\N	0	\N	\N	1	1	2	f	828	\N	\N
2329	104	1005	2	8568	\N	0	\N	\N	1	1	2	f	8568	\N	\N
2330	104	1006	2	828	\N	0	\N	\N	1	1	2	f	828	\N	\N
2331	104	1008	2	828	\N	0	\N	\N	1	1	2	f	828	\N	\N
2332	104	1009	2	3180	\N	3180	\N	\N	1	1	2	f	0	\N	\N
2333	59	1009	1	6360	\N	6360	\N	\N	1	1	2	f	\N	\N	\N
2334	104	1010	2	7680	\N	0	\N	\N	1	1	2	f	7680	\N	\N
2335	193	1011	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2336	28	1011	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
2337	104	1012	2	35283	\N	0	\N	\N	1	1	2	f	35283	\N	\N
2338	104	1013	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2339	104	1014	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2340	104	1015	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2341	104	1016	2	3066	\N	0	\N	\N	1	1	2	f	3066	\N	\N
2342	25	1017	2	2183	\N	2183	\N	\N	1	1	2	f	0	\N	\N
2343	124	1018	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2344	107	1019	2	2888	\N	0	\N	\N	1	1	2	f	2888	\N	\N
2345	25	1019	2	2670	\N	0	\N	\N	2	1	2	f	2670	\N	\N
2346	11	1020	2	35715	\N	0	\N	\N	1	1	2	f	35715	\N	\N
2347	99	1020	2	17200	\N	0	\N	\N	2	1	2	f	17200	\N	\N
2348	39	1020	2	4473	\N	0	\N	\N	3	1	2	f	4473	\N	\N
2349	170	1020	2	4333	\N	0	\N	\N	4	1	2	f	4333	\N	\N
2350	68	1020	2	4205	\N	0	\N	\N	5	1	2	f	4205	\N	\N
2351	4	1020	2	3480	\N	0	\N	\N	6	1	2	f	3480	\N	\N
2352	5	1020	2	1532	\N	0	\N	\N	6	1	2	f	1532	\N	\N
2353	102	1020	2	2994	\N	0	\N	\N	7	1	2	f	2994	\N	\N
2354	124	1020	2	2867	\N	0	\N	\N	8	1	2	f	2867	\N	\N
2355	195	1020	2	2503	\N	0	\N	\N	9	1	2	f	2503	\N	\N
2356	202	1020	2	1838	\N	0	\N	\N	10	1	2	f	1838	\N	\N
2357	36	1020	2	1594	\N	0	\N	\N	11	1	2	f	1594	\N	\N
2358	6	1020	2	1131	\N	0	\N	\N	13	1	2	f	1131	\N	\N
2359	29	1020	2	995	\N	0	\N	\N	14	1	2	f	995	\N	\N
2360	90	1020	2	913	\N	0	\N	\N	15	1	2	f	913	\N	\N
2361	91	1020	2	896	\N	0	\N	\N	16	1	2	f	896	\N	\N
2362	57	1020	2	892	\N	0	\N	\N	17	1	2	f	892	\N	\N
2363	53	1020	2	862	\N	0	\N	\N	18	1	2	f	862	\N	\N
2364	155	1020	2	798	\N	0	\N	\N	19	1	2	f	798	\N	\N
2365	63	1020	2	768	\N	0	\N	\N	20	1	2	f	768	\N	\N
2366	62	1020	2	739	\N	0	\N	\N	21	1	2	f	739	\N	\N
2367	196	1020	2	730	\N	0	\N	\N	22	1	2	f	730	\N	\N
2368	129	1020	2	698	\N	0	\N	\N	23	1	2	f	698	\N	\N
2369	165	1020	2	674	\N	0	\N	\N	24	1	2	f	674	\N	\N
2370	95	1020	2	614	\N	0	\N	\N	25	1	2	f	614	\N	\N
2371	96	1020	2	321	\N	0	\N	\N	26	1	2	f	321	\N	\N
2372	174	1020	2	281	\N	0	\N	\N	27	1	2	f	281	\N	\N
2373	30	1020	2	276	\N	0	\N	\N	28	1	2	f	276	\N	\N
2374	50	1020	2	262	\N	0	\N	\N	29	1	2	f	262	\N	\N
2375	82	1020	2	226	\N	0	\N	\N	30	1	2	f	226	\N	\N
2376	70	1020	2	181	\N	0	\N	\N	31	1	2	f	181	\N	\N
2377	190	1020	2	177	\N	0	\N	\N	32	1	2	f	177	\N	\N
2378	51	1020	2	173	\N	0	\N	\N	33	1	2	f	173	\N	\N
2379	54	1020	2	128	\N	0	\N	\N	34	1	2	f	128	\N	\N
2380	144	1020	2	124	\N	0	\N	\N	35	1	2	f	124	\N	\N
2381	125	1020	2	121	\N	0	\N	\N	36	1	2	f	121	\N	\N
2382	204	1020	2	115	\N	0	\N	\N	37	1	2	f	115	\N	\N
2383	146	1020	2	105	\N	0	\N	\N	38	1	2	f	105	\N	\N
2384	19	1020	2	97	\N	0	\N	\N	39	1	2	f	97	\N	\N
2385	140	1020	2	95	\N	0	\N	\N	40	1	2	f	95	\N	\N
2386	158	1020	2	89	\N	0	\N	\N	41	1	2	f	89	\N	\N
2387	148	1020	2	85	\N	0	\N	\N	42	1	2	f	85	\N	\N
2388	45	1020	2	83	\N	0	\N	\N	43	1	2	f	83	\N	\N
2389	59	1020	2	82	\N	0	\N	\N	44	1	2	f	82	\N	\N
2390	76	1020	2	67	\N	0	\N	\N	45	1	2	f	67	\N	\N
2391	15	1020	2	67	\N	0	\N	\N	45	1	2	f	67	\N	\N
2392	194	1020	2	67	\N	0	\N	\N	46	1	2	f	67	\N	\N
2393	80	1020	2	49	\N	0	\N	\N	47	1	2	f	49	\N	\N
2394	21	1020	2	49	\N	0	\N	\N	48	1	2	f	49	\N	\N
2395	115	1020	2	43	\N	0	\N	\N	49	1	2	f	43	\N	\N
2396	72	1020	2	35	\N	0	\N	\N	50	1	2	f	35	\N	\N
2397	180	1020	2	34	\N	0	\N	\N	51	1	2	f	34	\N	\N
2398	185	1020	2	34	\N	0	\N	\N	52	1	2	f	34	\N	\N
2399	69	1020	2	30	\N	0	\N	\N	53	1	2	f	30	\N	\N
2400	162	1020	2	30	\N	0	\N	\N	54	1	2	f	30	\N	\N
2401	179	1020	2	30	\N	0	\N	\N	55	1	2	f	30	\N	\N
2402	87	1020	2	25	\N	0	\N	\N	56	1	2	f	25	\N	\N
2403	156	1020	2	24	\N	0	\N	\N	57	1	2	f	24	\N	\N
2404	52	1020	2	20	\N	0	\N	\N	58	1	2	f	20	\N	\N
2405	163	1020	2	19	\N	0	\N	\N	59	1	2	f	19	\N	\N
2406	84	1020	2	16	\N	0	\N	\N	60	1	2	f	16	\N	\N
2407	20	1020	2	15	\N	0	\N	\N	61	1	2	f	15	\N	\N
2408	112	1020	2	14	\N	0	\N	\N	62	1	2	f	14	\N	\N
2409	203	1020	2	14	\N	0	\N	\N	63	1	2	f	14	\N	\N
2410	23	1020	2	13	\N	0	\N	\N	64	1	2	f	13	\N	\N
2411	171	1020	2	10	\N	0	\N	\N	65	1	2	f	10	\N	\N
2412	186	1020	2	9	\N	0	\N	\N	66	1	2	f	9	\N	\N
2413	130	1020	2	8	\N	0	\N	\N	67	1	2	f	8	\N	\N
2414	187	1020	2	6	\N	0	\N	\N	68	1	2	f	6	\N	\N
2415	100	1020	2	6	\N	0	\N	\N	69	1	2	f	6	\N	\N
2416	97	1020	2	2	\N	0	\N	\N	70	1	2	f	2	\N	\N
2417	141	1020	2	2	\N	0	\N	\N	71	1	2	f	2	\N	\N
2418	188	1020	2	2	\N	0	\N	\N	72	1	2	f	2	\N	\N
2419	133	1020	2	1	\N	0	\N	\N	73	1	2	f	1	\N	\N
2420	92	1020	2	1	\N	0	\N	\N	74	1	2	f	1	\N	\N
2421	93	1020	2	1	\N	0	\N	\N	75	1	2	f	1	\N	\N
2422	44	1020	2	1	\N	0	\N	\N	76	1	2	f	1	\N	\N
2423	178	1020	2	1	\N	0	\N	\N	77	1	2	f	1	\N	\N
2424	81	1020	2	1	\N	0	\N	\N	78	1	2	f	1	\N	\N
2425	8	1020	2	1991	\N	0	\N	\N	0	1	2	f	1991	\N	\N
2426	26	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2427	110	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2428	27	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2429	175	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2430	145	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2431	42	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2432	132	1020	2	768	\N	0	\N	\N	0	1	2	f	768	\N	\N
2433	64	1020	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
2434	37	1020	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
2435	86	1020	2	706	\N	0	\N	\N	0	1	2	f	706	\N	\N
2436	40	1020	2	706	\N	0	\N	\N	0	1	2	f	706	\N	\N
2437	2	1020	2	78	\N	0	\N	\N	0	1	2	f	78	\N	\N
2438	189	1020	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
2439	131	1020	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2440	71	1020	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2441	43	1020	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2442	114	1020	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2443	1	1020	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2444	46	1020	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2445	111	1020	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2446	88	1020	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2447	89	1020	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2448	123	1020	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2449	65	1020	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2450	38	1020	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2451	205	1020	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2452	10	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2453	47	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2454	77	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2455	167	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2456	116	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2457	16	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2458	117	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2459	31	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2460	118	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2461	181	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2462	78	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2463	149	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2464	197	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2465	17	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2466	32	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2467	182	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2468	168	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2469	33	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2470	150	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2471	48	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2472	151	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2473	152	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2474	135	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2475	153	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2476	34	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2477	119	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2478	79	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2479	198	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2480	136	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2481	199	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2482	200	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2483	49	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2484	183	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2485	35	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2486	201	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2487	169	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2488	184	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2489	137	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2490	154	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2491	120	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2492	138	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2493	121	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2494	98	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2495	18	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2496	139	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2497	122	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2498	56	1020	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2499	104	1021	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
2500	104	1022	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2501	104	1023	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2502	104	1024	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2503	104	1025	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2504	104	1026	2	5838	\N	0	\N	\N	1	1	2	f	5838	\N	\N
2505	104	1027	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2506	105	1028	2	68240	\N	65986	\N	\N	1	1	2	f	2254	\N	\N
2507	190	1028	2	65977	\N	65977	\N	\N	0	1	2	f	0	\N	\N
2508	104	1029	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
2509	104	1030	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2510	59	1030	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2511	104	1031	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2512	104	1032	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2513	59	1032	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2514	104	1033	2	11465	\N	0	\N	\N	1	1	2	f	11465	\N	\N
2515	26	1033	2	11465	\N	0	\N	\N	0	1	2	f	11465	\N	\N
2516	104	1034	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2517	104	1035	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
2518	104	1036	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2519	104	1037	2	4972	\N	4972	\N	\N	1	1	2	f	0	\N	\N
2520	59	1037	1	9944	\N	9944	\N	\N	1	1	2	f	\N	\N	\N
2521	104	1038	2	44530	\N	0	\N	\N	1	1	2	f	44530	\N	\N
2522	104	1039	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2523	26	1039	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2524	68	1040	2	3753	\N	0	\N	\N	1	1	2	f	3753	\N	\N
2525	174	1040	2	281	\N	0	\N	\N	2	1	2	f	281	\N	\N
2526	69	1040	2	30	\N	0	\N	\N	3	1	2	f	30	\N	\N
2527	105	1041	2	12009	\N	0	\N	\N	1	1	2	f	12009	\N	\N
2528	104	1042	2	21751	\N	21751	\N	\N	1	1	2	f	0	\N	\N
2529	59	1042	1	43502	\N	43502	\N	\N	1	1	2	f	\N	\N	\N
2530	104	1043	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2531	26	1043	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2532	87	1044	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
2533	57	1044	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2534	58	1045	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2535	67	1046	2	3282	\N	3282	\N	\N	1	1	2	f	0	\N	\N
2536	22	1046	1	3282	\N	3282	\N	\N	1	1	2	f	\N	\N	\N
2537	105	1047	2	13565	\N	0	\N	\N	1	1	2	f	13565	\N	\N
2538	157	1048	2	312311	\N	0	\N	\N	1	1	2	f	312311	\N	\N
2539	104	1049	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2540	104	1050	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
2541	59	1050	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
2542	104	1051	2	371	\N	0	\N	\N	1	1	2	f	371	\N	\N
2543	104	1052	2	428	\N	0	\N	\N	1	1	2	f	428	\N	\N
2544	104	1053	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2545	104	1054	2	6845	\N	0	\N	\N	1	1	2	f	6845	\N	\N
2546	104	1055	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
2547	85	1056	2	3164	\N	3164	\N	\N	1	1	2	f	0	\N	\N
2548	62	1056	1	3160	\N	3160	\N	\N	1	1	2	f	\N	\N	\N
2549	37	1056	1	2213	\N	2213	\N	\N	0	1	2	f	\N	\N	\N
2550	99	1057	2	48062	\N	48062	\N	\N	1	1	2	f	0	\N	\N
2551	170	1057	2	21137	\N	21137	\N	\N	2	1	2	f	0	\N	\N
2552	19	1057	2	4225	\N	4225	\N	\N	3	1	2	f	0	\N	\N
2553	51	1057	2	2061	\N	2061	\N	\N	4	1	2	f	0	\N	\N
2554	186	1057	2	1207	\N	1207	\N	\N	5	1	2	f	0	\N	\N
2555	20	1057	2	297	\N	297	\N	\N	6	1	2	f	0	\N	\N
2556	57	1057	1	76989	\N	76989	\N	\N	1	1	2	f	\N	\N	\N
2557	104	1058	2	15683	\N	0	\N	\N	1	1	2	f	15683	\N	\N
2558	67	1059	2	3290	\N	0	\N	\N	1	1	2	f	3290	\N	\N
2559	104	1060	2	232	\N	0	\N	\N	1	1	2	f	232	\N	\N
2560	104	1062	2	6403	\N	0	\N	\N	1	1	2	f	6403	\N	\N
2561	104	1064	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
2562	54	1065	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2563	53	1065	2	11	\N	0	\N	\N	2	1	2	f	11	\N	\N
2564	61	1066	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
2565	24	1066	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
2566	4	1067	2	3480	\N	0	\N	\N	1	1	2	f	3480	\N	\N
2567	5	1067	2	1532	\N	0	\N	\N	1	1	2	f	1532	\N	\N
2568	68	1067	2	3433	\N	0	\N	\N	2	1	2	f	3433	\N	\N
2569	124	1067	2	2701	\N	0	\N	\N	3	1	2	f	2701	\N	\N
2570	6	1067	2	1131	\N	0	\N	\N	5	1	2	f	1131	\N	\N
2571	174	1067	2	281	\N	0	\N	\N	6	1	2	f	281	\N	\N
2572	102	1067	2	257	\N	0	\N	\N	7	1	2	f	257	\N	\N
2573	57	1067	2	225	\N	0	\N	\N	8	1	2	f	225	\N	\N
2574	204	1067	2	115	\N	0	\N	\N	9	1	2	f	115	\N	\N
2575	158	1067	2	69	\N	0	\N	\N	10	1	2	f	69	\N	\N
2576	125	1067	2	63	\N	0	\N	\N	11	1	2	f	63	\N	\N
2577	69	1067	2	30	\N	0	\N	\N	12	1	2	f	30	\N	\N
2578	162	1067	2	30	\N	0	\N	\N	13	1	2	f	30	\N	\N
2579	84	1067	2	11	\N	0	\N	\N	14	1	2	f	11	\N	\N
2580	23	1067	2	9	\N	0	\N	\N	15	1	2	f	9	\N	\N
2581	28	1067	2	3	\N	0	\N	\N	16	1	2	f	3	\N	\N
2582	113	1067	2	3	\N	0	\N	\N	17	1	2	f	3	\N	\N
2583	147	1067	2	3	\N	0	\N	\N	18	1	2	f	3	\N	\N
2584	59	1067	2	2	\N	0	\N	\N	19	1	2	f	2	\N	\N
2585	190	1067	2	2	\N	0	\N	\N	20	1	2	f	2	\N	\N
2586	92	1067	2	1	\N	0	\N	\N	21	1	2	f	1	\N	\N
2587	93	1067	2	1	\N	0	\N	\N	22	1	2	f	1	\N	\N
2588	44	1067	2	1	\N	0	\N	\N	23	1	2	f	1	\N	\N
2589	178	1067	2	1	\N	0	\N	\N	24	1	2	f	1	\N	\N
2590	185	1067	2	1	\N	0	\N	\N	25	1	2	f	1	\N	\N
2591	8	1067	2	1991	\N	0	\N	\N	0	1	2	f	1991	\N	\N
2592	86	1067	2	706	\N	0	\N	\N	0	1	2	f	706	\N	\N
2593	40	1067	2	706	\N	0	\N	\N	0	1	2	f	706	\N	\N
2594	2	1067	2	47	\N	0	\N	\N	0	1	2	f	47	\N	\N
2595	189	1067	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
2596	65	1067	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2597	46	1067	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2598	114	1067	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2599	13	1067	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2600	74	1067	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2601	94	1067	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2602	166	1067	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2603	26	1067	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2604	104	1068	2	274	\N	0	\N	\N	1	1	2	f	274	\N	\N
2605	104	1069	2	13052	\N	0	\N	\N	1	1	2	f	13052	\N	\N
2606	104	1070	2	13824	\N	0	\N	\N	1	1	2	f	13824	\N	\N
2607	104	1071	2	218	\N	0	\N	\N	1	1	2	f	218	\N	\N
2608	104	1072	2	427	\N	0	\N	\N	1	1	2	f	427	\N	\N
2609	104	1073	2	373	\N	0	\N	\N	1	1	2	f	373	\N	\N
2610	204	1074	2	994	\N	0	\N	\N	1	1	2	f	994	\N	\N
2611	57	1074	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
2612	104	1075	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2613	26	1075	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2614	104	1076	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2615	104	1077	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2616	104	1078	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
2617	104	1079	2	6305	\N	6305	\N	\N	1	1	2	f	0	\N	\N
2618	59	1079	1	12610	\N	12610	\N	\N	1	1	2	f	\N	\N	\N
2619	124	1080	2	279	\N	279	\N	\N	1	1	2	f	0	\N	\N
2620	125	1080	2	134	\N	134	\N	\N	2	1	2	f	0	\N	\N
2621	158	1080	2	98	\N	98	\N	\N	3	1	2	f	0	\N	\N
2622	23	1080	2	12	\N	12	\N	\N	4	1	2	f	0	\N	\N
2623	2	1080	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
2624	114	1080	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2625	1	1080	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2626	46	1080	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2627	65	1080	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2628	38	1080	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2629	205	1080	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2630	57	1080	1	261	\N	261	\N	\N	1	1	2	f	\N	\N	\N
2631	93	1080	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
2632	44	1080	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
2633	92	1080	1	4	\N	4	\N	\N	4	1	2	f	\N	\N	\N
2634	189	1080	1	262	\N	262	\N	\N	0	1	2	f	\N	\N	\N
2635	104	1081	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2636	26	1081	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2637	104	1082	2	13151	\N	13151	\N	\N	1	1	2	f	0	\N	\N
2638	59	1082	1	26302	\N	26302	\N	\N	1	1	2	f	\N	\N	\N
2639	104	1083	2	172	\N	0	\N	\N	1	1	2	f	172	\N	\N
2640	104	1084	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2641	104	1085	2	173	\N	0	\N	\N	1	1	2	f	173	\N	\N
2642	104	1086	2	10748	\N	0	\N	\N	1	1	2	f	10748	\N	\N
2643	104	1087	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2644	104	1088	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2645	104	1089	2	9214	\N	0	\N	\N	1	1	2	f	9214	\N	\N
2646	206	1090	2	90	\N	0	\N	\N	1	1	2	f	90	\N	\N
2647	76	1091	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
2648	15	1091	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
2649	104	1092	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2650	104	1093	2	8448	\N	0	\N	\N	1	1	2	f	8448	\N	\N
2651	50	1094	2	262	\N	0	\N	\N	1	1	2	f	262	\N	\N
2652	37	1094	2	187	\N	0	\N	\N	2	1	2	f	187	\N	\N
2653	62	1094	2	187	\N	0	\N	\N	0	1	2	f	187	\N	\N
2654	104	1095	2	3334	\N	3334	\N	\N	1	1	2	f	0	\N	\N
2655	59	1095	1	6668	\N	6668	\N	\N	1	1	2	f	\N	\N	\N
2656	104	1096	2	7678	\N	0	\N	\N	1	1	2	f	7678	\N	\N
2657	160	1097	2	664	\N	0	\N	\N	1	1	2	f	664	\N	\N
2658	59	1097	2	155	\N	0	\N	\N	2	1	2	f	155	\N	\N
2659	161	1097	2	154	\N	0	\N	\N	3	1	2	f	154	\N	\N
2660	87	1097	2	33	\N	0	\N	\N	4	1	2	f	33	\N	\N
2661	57	1097	2	6	\N	0	\N	\N	5	1	2	f	6	\N	\N
2662	171	1097	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
2663	23	1097	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
2664	125	1097	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
2665	190	1097	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2666	104	1098	2	806784	\N	0	\N	\N	1	1	2	f	806784	\N	\N
2667	104	1099	2	40832	\N	0	\N	\N	1	1	2	f	40832	\N	\N
2668	104	1100	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2669	104	1101	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2670	104	1102	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2671	104	1103	2	2574	\N	0	\N	\N	1	1	2	f	2574	\N	\N
2672	104	1104	2	8344	\N	0	\N	\N	1	1	2	f	8344	\N	\N
2673	104	1105	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2674	104	1106	2	4774	\N	0	\N	\N	1	1	2	f	4774	\N	\N
2675	104	1107	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2676	104	1108	2	2412	\N	2412	\N	\N	1	1	2	f	0	\N	\N
2677	37	1108	1	2412	\N	2412	\N	\N	1	1	2	f	\N	\N	\N
2678	62	1108	1	2412	\N	2412	\N	\N	0	1	2	f	\N	\N	\N
2679	104	1109	2	20529	\N	20529	\N	\N	1	1	2	f	0	\N	\N
2680	59	1109	1	41058	\N	41058	\N	\N	1	1	2	f	\N	\N	\N
2681	104	1110	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2682	104	1111	2	4173	\N	4173	\N	\N	1	1	2	f	0	\N	\N
2683	59	1111	1	8346	\N	8346	\N	\N	1	1	2	f	\N	\N	\N
2684	104	1112	2	81333	\N	0	\N	\N	1	1	2	f	81333	\N	\N
2685	104	1113	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2686	104	1114	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2687	104	1115	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2688	104	1116	2	2412	\N	0	\N	\N	1	1	2	f	2412	\N	\N
2689	104	1117	2	1573	\N	0	\N	\N	1	1	2	f	1573	\N	\N
2690	104	1118	2	7680	\N	0	\N	\N	1	1	2	f	7680	\N	\N
2691	104	1119	2	770	\N	0	\N	\N	1	1	2	f	770	\N	\N
2692	162	1120	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
2693	69	1120	1	60	\N	60	\N	\N	1	1	2	f	\N	\N	\N
2694	104	1121	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2695	84	1122	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2696	104	1123	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2697	104	1124	2	9166	\N	9166	\N	\N	1	1	2	f	0	\N	\N
2698	59	1124	1	18332	\N	18332	\N	\N	1	1	2	f	\N	\N	\N
2699	104	1125	2	11575	\N	11575	\N	\N	1	1	2	f	0	\N	\N
2700	59	1125	1	23150	\N	23150	\N	\N	1	1	2	f	\N	\N	\N
2701	104	1126	2	349	\N	0	\N	\N	1	1	2	f	349	\N	\N
2702	87	1127	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
2703	104	1128	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2704	104	1129	2	6886	\N	6886	\N	\N	1	1	2	f	0	\N	\N
2705	59	1129	1	13772	\N	13772	\N	\N	1	1	2	f	\N	\N	\N
2706	192	1130	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2707	104	1131	2	10534	\N	0	\N	\N	1	1	2	f	10534	\N	\N
2708	104	1132	2	317	\N	317	\N	\N	1	1	2	f	0	\N	\N
2709	59	1132	1	634	\N	634	\N	\N	1	1	2	f	\N	\N	\N
2710	107	1133	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2711	104	1134	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2712	76	1135	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
2713	15	1135	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
2714	73	1136	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2715	104	1137	2	30567	\N	0	\N	\N	1	1	2	f	30567	\N	\N
2716	177	1138	2	71	\N	71	\N	\N	1	1	2	f	0	\N	\N
2717	8	1138	1	4747	\N	4747	\N	\N	1	1	2	f	\N	\N	\N
2718	40	1138	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
2719	124	1138	1	4710	\N	4710	\N	\N	0	1	2	f	\N	\N	\N
2720	59	1139	2	671	\N	671	\N	\N	1	1	2	f	0	\N	\N
2721	59	1139	1	666	\N	666	\N	\N	1	1	2	f	\N	\N	\N
2722	160	1139	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
2723	127	1140	2	6478	\N	6478	\N	\N	1	1	2	f	0	\N	\N
2724	62	1140	1	6594	\N	6594	\N	\N	1	1	2	f	\N	\N	\N
2725	193	1141	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2726	104	1142	2	19597	\N	19597	\N	\N	1	1	2	f	0	\N	\N
2727	59	1142	1	39194	\N	39194	\N	\N	1	1	2	f	\N	\N	\N
2728	75	1143	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2729	14	1143	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2730	104	1144	2	10748	\N	0	\N	\N	1	1	2	f	10748	\N	\N
2731	104	1145	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2732	26	1145	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2733	104	1146	2	7644	\N	0	\N	\N	1	1	2	f	7644	\N	\N
2734	104	1147	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
2735	104	1148	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2736	26	1148	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2737	104	1149	2	3066	\N	0	\N	\N	1	1	2	f	3066	\N	\N
2738	104	1150	2	34029	\N	0	\N	\N	1	1	2	f	34029	\N	\N
2739	127	1151	2	13046	\N	0	\N	\N	1	1	2	f	13046	\N	\N
2740	104	1152	2	10876	\N	0	\N	\N	1	1	2	f	10876	\N	\N
2741	104	1153	2	2228	\N	2228	\N	\N	1	1	2	f	0	\N	\N
2742	59	1153	1	4456	\N	4456	\N	\N	1	1	2	f	\N	\N	\N
2743	84	1154	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2744	104	1155	2	4418	\N	0	\N	\N	1	1	2	f	4418	\N	\N
2745	112	1156	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
2746	104	1157	2	4418	\N	0	\N	\N	1	1	2	f	4418	\N	\N
2747	4	1158	2	3480	\N	0	\N	\N	1	1	2	f	3480	\N	\N
2748	5	1158	2	974	\N	0	\N	\N	1	1	2	f	974	\N	\N
2749	25	1158	2	2670	\N	0	\N	\N	2	1	2	f	2670	\N	\N
2750	112	1158	2	14	\N	0	\N	\N	3	1	2	f	14	\N	\N
2751	104	1159	2	21951	\N	21951	\N	\N	1	1	2	f	0	\N	\N
2752	59	1159	1	43902	\N	43902	\N	\N	1	1	2	f	\N	\N	\N
2753	104	1160	2	6908	\N	0	\N	\N	1	1	2	f	6908	\N	\N
2754	104	1161	2	4395	\N	0	\N	\N	1	1	2	f	4395	\N	\N
2755	104	1162	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2756	104	1163	2	340	\N	0	\N	\N	1	1	2	f	340	\N	\N
2757	104	1164	2	3552	\N	0	\N	\N	1	1	2	f	3552	\N	\N
2758	104	1165	2	4410	\N	0	\N	\N	1	1	2	f	4410	\N	\N
2759	104	1166	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
2760	104	1167	2	4418	\N	0	\N	\N	1	1	2	f	4418	\N	\N
2761	104	1168	2	3879	\N	0	\N	\N	1	1	2	f	3879	\N	\N
2762	104	1169	2	4417	\N	4417	\N	\N	1	1	2	f	0	\N	\N
2763	123	1169	1	4417	\N	4417	\N	\N	1	1	2	f	\N	\N	\N
2764	62	1169	1	4417	\N	4417	\N	\N	0	1	2	f	\N	\N	\N
2765	104	1170	2	4417	\N	4417	\N	\N	1	1	2	f	0	\N	\N
2766	37	1170	1	4417	\N	4417	\N	\N	1	1	2	f	\N	\N	\N
2767	62	1170	1	4417	\N	4417	\N	\N	0	1	2	f	\N	\N	\N
2768	104	1171	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2769	104	1172	2	4038	\N	0	\N	\N	1	1	2	f	4038	\N	\N
2770	104	1173	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2771	190	1174	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
2772	71	1174	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
2773	43	1174	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
2774	57	1174	1	30	\N	30	\N	\N	1	1	2	f	\N	\N	\N
2775	190	1174	1	30	\N	30	\N	\N	0	1	2	f	\N	\N	\N
2776	104	1175	2	24157	\N	0	\N	\N	1	1	2	f	24157	\N	\N
2777	26	1175	2	24157	\N	0	\N	\N	0	1	2	f	24157	\N	\N
2778	104	1176	2	35283	\N	0	\N	\N	1	1	2	f	35283	\N	\N
2779	127	1177	2	54574	\N	54574	\N	\N	1	1	2	f	0	\N	\N
2780	128	1177	2	50236	\N	50236	\N	\N	2	1	2	f	0	\N	\N
2781	99	1177	2	48062	\N	0	\N	\N	3	1	2	f	48062	\N	\N
2782	62	1177	2	47498	\N	47498	\N	\N	4	1	2	f	0	\N	\N
2783	106	1177	2	45028	\N	45028	\N	\N	5	1	2	f	0	\N	\N
2784	104	1177	2	39948	\N	39948	\N	\N	6	1	2	f	0	\N	\N
2785	105	1177	2	31284	\N	31284	\N	\N	7	1	2	f	0	\N	\N
2786	3	1177	2	26684	\N	26684	\N	\N	8	1	2	f	0	\N	\N
2787	170	1177	2	21137	\N	0	\N	\N	9	1	2	f	21137	\N	\N
2788	108	1177	2	11934	\N	11934	\N	\N	10	1	2	f	0	\N	\N
2789	85	1177	2	6314	\N	6314	\N	\N	11	1	2	f	0	\N	\N
2790	19	1177	2	4225	\N	0	\N	\N	12	1	2	f	4225	\N	\N
2791	109	1177	2	4212	\N	4212	\N	\N	13	1	2	f	0	\N	\N
2792	51	1177	2	2061	\N	0	\N	\N	14	1	2	f	2061	\N	\N
2793	186	1177	2	1207	\N	0	\N	\N	15	1	2	f	1207	\N	\N
2794	53	1177	2	862	\N	0	\N	\N	16	1	2	f	862	\N	\N
2795	67	1177	2	342	\N	342	\N	\N	17	1	2	f	0	\N	\N
2796	176	1177	2	342	\N	342	\N	\N	18	1	2	f	0	\N	\N
2797	20	1177	2	297	\N	0	\N	\N	19	1	2	f	297	\N	\N
2798	54	1177	2	128	\N	0	\N	\N	20	1	2	f	128	\N	\N
2799	57	1177	2	82	\N	25	\N	\N	21	1	2	f	57	\N	\N
2800	190	1177	2	61	\N	30	\N	\N	22	1	2	f	31	\N	\N
2801	112	1177	2	28	\N	28	\N	\N	23	1	2	f	0	\N	\N
2802	100	1177	2	6	\N	0	\N	\N	24	1	2	f	6	\N	\N
2803	37	1177	2	1462	\N	1462	\N	\N	0	1	2	f	0	\N	\N
2804	71	1177	2	34	\N	17	\N	\N	0	1	2	f	17	\N	\N
2805	43	1177	2	26	\N	13	\N	\N	0	1	2	f	13	\N	\N
2806	123	1177	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2807	59	1177	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2808	107	1177	1	122628	\N	122628	\N	\N	1	1	2	f	\N	\N	\N
2809	25	1177	1	122623	\N	122623	\N	\N	2	1	2	f	\N	\N	\N
2810	104	1178	2	1545	\N	1545	\N	\N	1	1	2	f	0	\N	\N
2811	59	1178	1	3090	\N	3090	\N	\N	1	1	2	f	\N	\N	\N
2812	62	1179	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
2813	190	1179	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
2814	190	1179	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
2815	88	1179	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2816	89	1179	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2817	166	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2818	47	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2819	116	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2820	153	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2821	34	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2822	136	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2823	200	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2824	49	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2825	137	1179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2826	62	1180	2	1546	\N	1546	\N	\N	1	1	2	f	0	\N	\N
2827	161	1180	2	1017	\N	1017	\N	\N	2	1	2	f	0	\N	\N
2828	82	1180	2	91	\N	91	\N	\N	3	1	2	f	0	\N	\N
2829	54	1180	2	48	\N	48	\N	\N	4	1	2	f	0	\N	\N
2830	179	1180	2	29	\N	29	\N	\N	5	1	2	f	0	\N	\N
2831	87	1180	2	24	\N	24	\N	\N	6	1	2	f	0	\N	\N
2832	53	1180	2	19	\N	19	\N	\N	7	1	2	f	0	\N	\N
2833	156	1180	2	15	\N	15	\N	\N	8	1	2	f	0	\N	\N
2834	171	1180	2	10	\N	10	\N	\N	9	1	2	f	0	\N	\N
2835	57	1180	2	4	\N	4	\N	\N	10	1	2	f	0	\N	\N
2836	190	1180	2	4	\N	4	\N	\N	11	1	2	f	0	\N	\N
2837	195	1180	2	3	\N	3	\N	\N	12	1	2	f	0	\N	\N
2838	141	1180	2	2	\N	2	\N	\N	13	1	2	f	0	\N	\N
2839	29	1180	2	2	\N	2	\N	\N	14	1	2	f	0	\N	\N
2840	188	1180	2	1	\N	1	\N	\N	15	1	2	f	0	\N	\N
2841	37	1180	2	1462	\N	1462	\N	\N	0	1	2	f	0	\N	\N
2842	56	1180	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2843	123	1180	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2844	88	1180	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2845	89	1180	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2846	43	1180	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2847	62	1180	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
2848	10	1180	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2849	57	1180	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
2850	123	1180	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2851	26	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2852	63	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2853	110	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2854	27	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2855	175	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2856	145	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2857	42	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2858	132	1180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2859	104	1181	2	4223	\N	4223	\N	\N	1	1	2	f	0	\N	\N
2860	59	1181	1	8446	\N	8446	\N	\N	1	1	2	f	\N	\N	\N
2861	104	1182	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2862	61	1183	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
2863	104	1184	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
2864	104	1185	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
2865	26	1185	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
2866	87	1186	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
2867	57	1186	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
2868	104	1187	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2869	104	1188	2	91292	\N	91292	\N	\N	1	1	2	f	0	\N	\N
2870	59	1188	1	182584	\N	182584	\N	\N	1	1	2	f	\N	\N	\N
2871	104	1189	2	4087	\N	0	\N	\N	1	1	2	f	4087	\N	\N
2872	104	1190	2	270503	\N	270503	\N	\N	1	1	2	f	0	\N	\N
2873	59	1190	1	541006	\N	541006	\N	\N	1	1	2	f	\N	\N	\N
2874	104	1191	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
2875	104	1192	2	8323	\N	0	\N	\N	1	1	2	f	8323	\N	\N
2876	104	1193	2	35279	\N	0	\N	\N	1	1	2	f	35279	\N	\N
2877	104	1194	2	3981	\N	3981	\N	\N	1	1	2	f	0	\N	\N
2878	59	1194	1	7962	\N	7962	\N	\N	1	1	2	f	\N	\N	\N
2879	104	1195	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2880	104	1196	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2881	104	1197	2	14400	\N	14400	\N	\N	1	1	2	f	0	\N	\N
2882	59	1197	1	28800	\N	28800	\N	\N	1	1	2	f	\N	\N	\N
2883	104	1198	2	7844	\N	0	\N	\N	1	1	2	f	7844	\N	\N
2884	104	1199	2	2184	\N	2184	\N	\N	1	1	2	f	0	\N	\N
2885	59	1199	1	4368	\N	4368	\N	\N	1	1	2	f	\N	\N	\N
2886	104	1200	2	753	\N	0	\N	\N	1	1	2	f	753	\N	\N
2887	158	1201	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2888	158	1201	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
2889	23	1201	1	14	\N	14	\N	\N	2	1	2	f	\N	\N	\N
2890	41	1201	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
2891	65	1201	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
2892	124	1201	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
2893	2	1201	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2894	39	1202	2	7416	\N	7416	\N	\N	1	1	2	f	0	\N	\N
2895	68	1202	2	7186	\N	7186	\N	\N	2	1	2	f	0	\N	\N
2896	174	1202	2	562	\N	562	\N	\N	3	1	2	f	0	\N	\N
2897	70	1202	1	4363	\N	4363	\N	\N	1	1	2	f	\N	\N	\N
2898	39	1202	1	3551	\N	3551	\N	\N	2	1	2	f	\N	\N	\N
2899	69	1202	1	3547	\N	3547	\N	\N	3	1	2	f	\N	\N	\N
2900	90	1202	1	2924	\N	2924	\N	\N	4	1	2	f	\N	\N	\N
2901	104	1203	2	438	\N	438	\N	\N	1	1	2	f	0	\N	\N
2902	123	1203	1	438	\N	438	\N	\N	1	1	2	f	\N	\N	\N
2903	62	1203	1	438	\N	438	\N	\N	0	1	2	f	\N	\N	\N
2904	104	1204	2	577	\N	0	\N	\N	1	1	2	f	577	\N	\N
2905	104	1205	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
2906	104	1206	2	14586	\N	0	\N	\N	1	1	2	f	14586	\N	\N
2907	105	1207	2	5376	\N	0	\N	\N	1	1	2	f	5376	\N	\N
2908	104	1208	2	678470	\N	678470	\N	\N	1	1	2	f	0	\N	\N
2909	59	1208	1	1356940	\N	1356940	\N	\N	1	1	2	f	\N	\N	\N
2910	104	1209	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
2911	104	1210	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2912	159	1211	2	523	\N	0	\N	\N	1	1	2	f	523	\N	\N
2913	104	1212	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
2914	104	1213	2	2277	\N	2277	\N	\N	1	1	2	f	0	\N	\N
2915	59	1213	1	4554	\N	4554	\N	\N	1	1	2	f	\N	\N	\N
2916	104	1214	2	18238	\N	0	\N	\N	1	1	2	f	18238	\N	\N
2917	105	1215	2	504728	\N	0	\N	\N	1	1	2	f	504728	\N	\N
2918	190	1215	2	65977	\N	0	\N	\N	0	1	2	f	65977	\N	\N
2919	99	1216	2	96124	\N	0	\N	\N	1	1	2	f	96124	\N	\N
2920	11	1216	2	71430	\N	0	\N	\N	2	1	2	f	71430	\N	\N
2921	170	1216	2	42274	\N	0	\N	\N	3	1	2	f	42274	\N	\N
2922	68	1216	2	11082	\N	0	\N	\N	4	1	2	f	11082	\N	\N
2923	39	1216	2	8948	\N	0	\N	\N	5	1	2	f	8948	\N	\N
2924	19	1216	2	8450	\N	0	\N	\N	6	1	2	f	8450	\N	\N
2925	195	1216	2	7509	\N	0	\N	\N	7	1	2	f	7509	\N	\N
2926	51	1216	2	4122	\N	0	\N	\N	8	1	2	f	4122	\N	\N
2927	202	1216	2	3676	\N	0	\N	\N	9	1	2	f	3676	\N	\N
2928	62	1216	2	3670	\N	1	\N	\N	10	1	2	f	3669	\N	\N
2929	36	1216	2	3188	\N	0	\N	\N	11	1	2	f	3188	\N	\N
2930	29	1216	2	2985	\N	0	\N	\N	12	1	2	f	2985	\N	\N
2931	91	1216	2	2688	\N	0	\N	\N	13	1	2	f	2688	\N	\N
2932	186	1216	2	2414	\N	0	\N	\N	14	1	2	f	2414	\N	\N
2933	196	1216	2	2190	\N	0	\N	\N	15	1	2	f	2190	\N	\N
2934	165	1216	2	2022	\N	0	\N	\N	16	1	2	f	2022	\N	\N
2935	95	1216	2	1842	\N	0	\N	\N	17	1	2	f	1842	\N	\N
2936	90	1216	2	1826	\N	0	\N	\N	18	1	2	f	1826	\N	\N
2937	53	1216	2	1724	\N	0	\N	\N	19	1	2	f	1724	\N	\N
2938	155	1216	2	1596	\N	0	\N	\N	20	1	2	f	1596	\N	\N
2939	96	1216	2	963	\N	0	\N	\N	21	1	2	f	963	\N	\N
2940	174	1216	2	843	\N	0	\N	\N	22	1	2	f	843	\N	\N
2941	30	1216	2	828	\N	0	\N	\N	23	1	2	f	828	\N	\N
2942	20	1216	2	594	\N	0	\N	\N	24	1	2	f	594	\N	\N
2943	82	1216	2	452	\N	0	\N	\N	25	1	2	f	452	\N	\N
2944	70	1216	2	362	\N	0	\N	\N	26	1	2	f	362	\N	\N
2945	146	1216	2	315	\N	0	\N	\N	27	1	2	f	315	\N	\N
2946	144	1216	2	264	\N	0	\N	\N	28	1	2	f	264	\N	\N
2947	54	1216	2	256	\N	0	\N	\N	29	1	2	f	256	\N	\N
2948	148	1216	2	255	\N	0	\N	\N	30	1	2	f	255	\N	\N
2949	45	1216	2	249	\N	0	\N	\N	31	1	2	f	249	\N	\N
2950	140	1216	2	190	\N	0	\N	\N	32	1	2	f	190	\N	\N
2951	115	1216	2	129	\N	0	\N	\N	33	1	2	f	129	\N	\N
2952	69	1216	2	120	\N	30	\N	\N	34	1	2	f	90	\N	\N
2953	102	1216	2	107	\N	0	\N	\N	35	1	2	f	107	\N	\N
2954	180	1216	2	102	\N	0	\N	\N	36	1	2	f	102	\N	\N
2955	80	1216	2	98	\N	0	\N	\N	37	1	2	f	98	\N	\N
2956	21	1216	2	98	\N	0	\N	\N	38	1	2	f	98	\N	\N
2957	204	1216	2	96	\N	0	\N	\N	39	1	2	f	96	\N	\N
2958	179	1216	2	90	\N	0	\N	\N	40	1	2	f	90	\N	\N
2959	72	1216	2	70	\N	0	\N	\N	41	1	2	f	70	\N	\N
2960	87	1216	2	66	\N	16	\N	\N	42	1	2	f	50	\N	\N
2961	190	1216	2	52	\N	46	\N	\N	43	1	2	f	6	\N	\N
2962	52	1216	2	40	\N	0	\N	\N	44	1	2	f	40	\N	\N
2963	163	1216	2	38	\N	0	\N	\N	45	1	2	f	38	\N	\N
2964	203	1216	2	28	\N	0	\N	\N	46	1	2	f	28	\N	\N
2965	130	1216	2	16	\N	0	\N	\N	47	1	2	f	16	\N	\N
2966	187	1216	2	12	\N	0	\N	\N	48	1	2	f	12	\N	\N
2967	100	1216	2	12	\N	0	\N	\N	49	1	2	f	12	\N	\N
2968	97	1216	2	6	\N	0	\N	\N	50	1	2	f	6	\N	\N
2969	193	1216	2	3	\N	3	\N	\N	51	1	2	f	0	\N	\N
2970	94	1216	2	1	\N	1	\N	\N	52	1	2	f	0	\N	\N
2971	28	1216	2	1	\N	1	\N	\N	53	1	2	f	0	\N	\N
2972	57	1216	2	1	\N	1	\N	\N	54	1	2	f	0	\N	\N
2973	37	1216	2	3655	\N	0	\N	\N	0	1	2	f	3655	\N	\N
2974	88	1216	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2975	89	1216	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2976	123	1216	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2977	56	1216	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2978	147	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2979	47	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2980	77	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2981	167	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2982	116	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2983	16	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2984	117	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2985	31	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2986	118	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2987	181	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2988	78	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2989	149	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2990	197	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2991	17	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2992	32	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2993	182	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2994	168	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2995	33	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2996	150	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2997	48	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2998	151	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2999	152	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3000	135	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3001	153	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3002	34	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3003	119	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3004	79	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3005	198	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3006	136	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3007	199	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3008	200	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3009	49	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3010	183	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3011	35	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3012	201	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3013	169	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3014	184	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3015	137	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3016	154	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3017	120	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3018	138	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3019	121	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3020	98	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3021	18	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3022	139	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3023	122	1216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3024	104	1217	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
3025	26	1217	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
3026	104	1218	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
3027	26	1218	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
3028	104	1219	2	3909	\N	3909	\N	\N	1	1	2	f	0	\N	\N
3029	59	1219	1	7818	\N	7818	\N	\N	1	1	2	f	\N	\N	\N
3030	104	1220	2	7351	\N	0	\N	\N	1	1	2	f	7351	\N	\N
3031	104	1221	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
3032	104	1222	2	17933	\N	0	\N	\N	1	1	2	f	17933	\N	\N
3033	105	1223	2	630419	\N	0	\N	\N	1	1	2	f	630419	\N	\N
3034	104	1224	2	17938	\N	17938	\N	\N	1	1	2	f	0	\N	\N
3035	37	1224	1	17938	\N	17938	\N	\N	1	1	2	f	\N	\N	\N
3036	62	1224	1	17938	\N	17938	\N	\N	0	1	2	f	\N	\N	\N
3037	104	1225	2	17938	\N	17938	\N	\N	1	1	2	f	0	\N	\N
3038	123	1225	1	17938	\N	17938	\N	\N	1	1	2	f	\N	\N	\N
3039	62	1225	1	17938	\N	17938	\N	\N	0	1	2	f	\N	\N	\N
3040	104	1226	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
3041	104	1227	2	7665	\N	7665	\N	\N	1	1	2	f	0	\N	\N
3042	59	1227	1	15330	\N	15330	\N	\N	1	1	2	f	\N	\N	\N
3043	104	1228	2	17938	\N	0	\N	\N	1	1	2	f	17938	\N	\N
3044	104	1229	2	4905	\N	0	\N	\N	1	1	2	f	4905	\N	\N
3045	104	1230	2	17938	\N	0	\N	\N	1	1	2	f	17938	\N	\N
3046	104	1231	2	4857	\N	0	\N	\N	1	1	2	f	4857	\N	\N
3047	104	1232	2	4868	\N	0	\N	\N	1	1	2	f	4868	\N	\N
3048	104	1233	2	4223	\N	0	\N	\N	1	1	2	f	4223	\N	\N
3049	104	1234	2	767	\N	0	\N	\N	1	1	2	f	767	\N	\N
3050	40	1235	2	64	\N	64	\N	\N	1	1	2	f	0	\N	\N
3051	8	1235	2	38	\N	38	\N	\N	2	1	2	f	0	\N	\N
3052	57	1235	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
3053	24	1236	2	7452	\N	7452	\N	\N	1	1	2	f	0	\N	\N
3054	62	1236	1	7452	\N	7452	\N	\N	1	1	2	f	\N	\N	\N
3055	104	1237	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
3056	105	1238	2	421657	\N	421657	\N	\N	1	1	2	f	0	\N	\N
3057	62	1238	2	30959	\N	30959	\N	\N	2	1	2	f	0	\N	\N
3058	134	1238	2	1484	\N	1484	\N	\N	3	1	2	f	0	\N	\N
3059	127	1238	2	13	\N	13	\N	\N	4	1	2	f	0	\N	\N
3060	106	1238	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
3061	37	1238	2	731	\N	731	\N	\N	0	1	2	f	0	\N	\N
3062	123	1238	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3063	56	1238	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3064	59	1238	1	22930	\N	22930	\N	\N	1	1	2	f	\N	\N	\N
3065	104	1239	2	298	\N	0	\N	\N	1	1	2	f	298	\N	\N
3066	104	1240	2	108	\N	0	\N	\N	1	1	2	f	108	\N	\N
3067	104	1241	2	4381	\N	0	\N	\N	1	1	2	f	4381	\N	\N
3068	104	1242	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
3069	104	1243	2	4900	\N	0	\N	\N	1	1	2	f	4900	\N	\N
3070	104	1244	2	768	\N	0	\N	\N	1	1	2	f	768	\N	\N
3071	104	1245	2	234	\N	0	\N	\N	1	1	2	f	234	\N	\N
3072	104	1246	2	4377	\N	0	\N	\N	1	1	2	f	4377	\N	\N
3073	11	1247	1	35715	\N	35715	\N	\N	1	1	2	f	\N	\N	\N
3074	178	1248	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3075	104	1249	2	11518	\N	0	\N	\N	1	1	2	f	11518	\N	\N
3076	104	1250	2	19434	\N	19434	\N	\N	1	1	2	f	0	\N	\N
3077	59	1250	1	38868	\N	38868	\N	\N	1	1	2	f	\N	\N	\N
3078	104	1251	2	725	\N	0	\N	\N	1	1	2	f	725	\N	\N
3079	26	1251	2	725	\N	0	\N	\N	0	1	2	f	725	\N	\N
3080	190	1252	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
3081	47	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3082	77	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3083	167	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3084	116	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3085	16	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3086	117	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3087	31	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3088	118	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3089	181	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3090	78	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3091	149	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3092	197	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3093	17	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3094	32	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3095	182	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3096	168	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3097	33	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3098	150	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3099	48	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3100	151	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3101	152	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3102	135	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3103	153	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3104	34	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3105	119	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3106	79	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3107	198	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3108	136	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3109	199	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3110	200	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3111	49	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3112	183	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3113	35	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3114	201	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3115	169	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3116	184	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3117	137	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3118	154	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3119	120	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3120	138	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3121	121	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3122	98	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3123	18	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3124	139	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3125	122	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3126	62	1252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3127	104	1253	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
3128	104	1254	2	2564	\N	0	\N	\N	1	1	2	f	2564	\N	\N
3129	75	1255	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3130	14	1255	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
3131	104	1256	2	10751	\N	0	\N	\N	1	1	2	f	10751	\N	\N
3132	104	1257	2	36476	\N	0	\N	\N	1	1	2	f	36476	\N	\N
3133	104	1258	2	1533	\N	0	\N	\N	1	1	2	f	1533	\N	\N
3134	11	1259	2	16289	\N	0	\N	\N	1	1	2	f	16289	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
106	n_24	https://dbpedia.org/ontology/	0	f	0
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
69		http://opendata.aragon.es/def/iaest/medida#	0	t	0
70	qb	http://purl.org/linked-data/cube#	0	f	0
71	time	http://www.w3.org/2006/time#	0	f	0
72	geonames	http://www.geonames.org/ontology#	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
73	sdmxdim	http://purl.org/linked-data/sdmx/2009/dimension#	0	f	0
74	edm	http://www.europeana.eu/schemas/edm/	0	f	0
75	bio	http://purl.org/vocab/bio/0.1/	0	f	0
76	sf	http://www.opengis.net/ont/sf#	0	f	0
77	dcmit	http://purl.org/dc/dcmitype/	0	f	0
78	n_1	http://opendata.aragon.es/def/Aragopedia#	0	f	0
79	n_2	http://icearagon.aragon.es/def/landscape#	0	f	0
80	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
81	n_3	http://www.openlinksw.com/schemas/VSPX#	0	f	0
82	n_4	http://crossforest.eu/ifi/ontology/	0	f	0
83	n_5	http://icearagon.aragon.es/def/core#	0	f	0
84	n_6	http://icearagon.aragon.es/def/hydro#	0	f	0
85	n_7	http://icearagon.aragon.es/def/transport#	0	f	0
86	n_8	http://data.tbfy.eu/ontology/ocds#	0	f	0
87	eli	http://data.europa.eu/eli/ontology#	0	f	0
88	n_9	http://icearagon.aragon.es/def/health#	0	f	0
89	n_10	http://icearagon.aragon.es/def/bca#	0	f	0
90	n_11	http://www.openlinksw.com/schemas/Image#	0	f	0
91	n_12	http://icearagon.aragon.es/def/ps#	0	f	0
92	geoes	http://geo.linkeddata.es/ontology/	0	f	0
93	n_13	http://icearagon.aragon.es/def/education#	0	f	0
94	sosa	http://www.w3.org/ns/sosa/	0	f	0
95	n_14	http://vocab.linkeddata.es/datosabiertos/def/medio-ambiente/meteorologia#	0	f	0
96	n_15	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
97	oplacl	http://www.openlinksw.com/ontology/acl#	0	f	0
98	n_16	http://opendata.aragon.es/def/iaest/dimension#	0	f	0
99	n_17	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/	0	f	0
100	n_18	http://opendata.aragon.es/def/ei2av2#	0	f	0
101	n_19	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/	0	f	0
102	n_20	http://opendata.aragon.es/recurso/measureproperty/aulas-coronavirus-aragon-dimension/	0	f	0
103	n_21	http://opendata.aragon.es/recurso/dimensionproperty/resultados-titulaciones-2020-2021-dimension/	0	f	0
104	n_22	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/	0	f	0
105	n_23	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/	0	f	0
107	n_25	http://opendata.aragon.es/	0	f	0
108	n_26	http://www.w3.org/2006/	0	f	0
109	n_27	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/	0	f	0
110	n_28	http://schemas.opengis.net/geosparql/	0	f	0
111	n_29	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-nucleos-zoologicos-medida/	0	f	0
112	n_30	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/	0	f	0
113	n_31	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/	0	f	0
114	n_32	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/	0	f	0
115	n_33	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/	0	f	0
116	n_34	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/	0	f	0
117	n_35	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-aragon-dimension/	0	f	0
118	n_36	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/	0	f	0
119	n_37	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/	0	f	0
120	sdo	https://schema.org/	0	f	0
121	n_38	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-otras-medida/	0	f	0
122	n_39	http://data.europa.eu/eli/ontology/	0	f	0
123	n_40	http://www.w3.org/2015/03/inspire/ps#	0	f	0
124	n_41	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/	0	f	0
125	n_42	http://opendata.aragon.es/recurso/dimensionproperty/aulas-coronavirus-aragon-dimension/	0	f	0
126	spdx	http://spdx.org/rdf/terms#	0	f	0
127	n_43	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-hospitales-medida/	0	f	0
128	n_44	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/	0	f	0
129	n_45	http://opendata.aragon.es/recurso/measureproperty/aulas-coronavirus-aragon-medida/	0	f	0
130	n_46	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/	0	f	0
131	n_47	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/	0	f	0
132	n_48	https://www.geonames.org/ontology#	0	f	0
133	n_49	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/	0	f	0
134	n_50	http://opendata.aragon.es/recurso/dimensionproperty/datos-vacunas-dimension/	0	f	0
135	n_51	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/	0	f	0
136	n_52	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/	0	f	0
137	n_53	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-ovino-medida/	0	f	0
138	n_54	http://opendata.aragon.es/recurso/measureproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-medida/	0	f	0
139	n_55	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-dimension/	0	f	0
140	n_56	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-cunicola-medida/	0	f	0
141	n_57	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/	0	f	0
142	n_58	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/	0	f	0
143	n_59	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-apicola-medida/	0	f	0
144	n_60	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/	0	f	0
145	n_61	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/	0	f	0
146	n_62	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/	0	f	0
147	n_63	http://opendata.aragon.es/def/	0	f	0
148	n_64	https://www.w3.org/ns/dcat#	0	f	0
149	n_65	http://opendata.aragon.es/recurso/measureproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-medida/	0	f	0
150	n_66	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/	0	f	0
151	n_67	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-bovino-medida/	0	f	0
152	n_68	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-provincia-dimension/	0	f	0
153	n_69	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/	0	f	0
154	n_70	http://opendata.aragon.es/recurso/measureproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-medida/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_opendata_aragon_es_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_opendata_aragon_es_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://opendata.aragon.es/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://opendata.aragon.es/sparql", "correlationId": "5067866015033008348", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": false, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:35:27.080Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://opendata.aragon.es/def/Aragopedia#hectareasOlivares	725	\N	78	hectareasOlivares	hectareasOlivares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://schema.org/title	1355055	\N	9	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://xmlns.com/foaf/0.1/name	8901	\N	8	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://xmlns.com/foaf/0.1/page	566	\N	8	page	page	f	0	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://www.w3.org/2006/time#hasEnd	4	\N	71	hasEnd	hasEnd	f	0	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-aguas-subterraneas-de-pozo-o-sondeo	1533	\N	69	superficie-regada-con-aguas-subterraneas-de-pozo-o-sondeo	superficie-regada-con-aguas-subterraneas-de-pozo-o-sondeo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://opendata.aragon.es/def/iaest/medida#visados-total	349	\N	69	visados-total	visados-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://www.w3.org/2004/02/skos/core#note	2068	\N	4	note	note	f	0	\N	\N	f	f	160	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://www.w3.org/2006/time#inXSDgYear	588	\N	71	inXSDgYear	inXSDgYear	f	0	\N	\N	f	f	159	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://opendata.aragon.es/def/iaest/medida#ciclos-formativos	7605	\N	69	ciclos-formativos	ciclos-formativos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://opendata.aragon.es/def/iaest/dimension#segunda-residencia	1515	\N	98	segunda-residencia	segunda-residencia	f	1515	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
12	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/9	46	\N	99	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://opendata.aragon.es/def/iaest/medida#superficie-km2	32162	\N	69	superficie-km2	superficie-km2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-mujeres	1533	\N	69	personas-que-son-mano-de-obra-familiar-mujeres	personas-que-son-mano-de-obra-familiar-mujeres	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://purl.org/dc/terms/spatial	293969	\N	5	spatial	spatial	f	292253	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://opendata.aragon.es/def/iaest/medida#enajenacion-inversiones-reales	18238	\N	69	enajenacion-inversiones-reales	enajenacion-inversiones-reales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://opendata.aragon.es/def/iaest/medida#desempleo-retribucion	5504	\N	69	desempleo-retribucion	desempleo-retribucion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://www.w3.org/ns/prov#startedAtTime	822	\N	26	startedAtTime	startedAtTime	f	0	\N	\N	f	f	126	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://opendata.aragon.es/def/iaest/medida#vab-per-capita	340	\N	69	vab-per-capita	vab-per-capita	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://opendata.aragon.es/def/iaest/medida#indice-de-maternidad	17586	\N	69	indice-de-maternidad	indice-de-maternidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-otra-formacion-agricola-del-titular	1533	\N	69	explotaciones-con-otra-formacion-agricola-del-titular	explotaciones-con-otra-formacion-agricola-del-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://opendata.aragon.es/def/iaest/medida#rustica---base-liquidable-miles-de-euros	12285	\N	69	rustica---base-liquidable-miles-de-euros	rustica---base-liquidable-miles-de-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-son-jefes-de-explotacion	1533	\N	69	unidades-de-trabajo-que-son-jefes-de-explotacion	unidades-de-trabajo-que-son-jefes-de-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-hombres	1533	\N	69	personas-que-son-mano-de-obra-familiar-hombres	personas-que-son-mano-de-obra-familiar-hombres	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://icearagon.aragon.es/def/transport#hasEstadoCarretera	1742	\N	85	hasEstadoCarretera	hasEstadoCarretera	f	1742	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://opendata.aragon.es/def/iaest/medida#total-jornadas-parciales	1533	\N	69	total-jornadas-parciales	total-jornadas-parciales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://opendata.aragon.es/def/iaest/medida#superficie-tierras-labradas	765	\N	69	superficie-tierras-labradas	superficie-tierras-labradas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://purl.org/dc/elements/1.1/description	14863	\N	6	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://opendata.aragon.es/def/iaest/dimension#nacionalidad-continente-nombre	110940	\N	98	nacionalidad-continente-nombre	nacionalidad-continente-nombre	f	110940	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
30	http://opendata.aragon.es/def/iaest/dimension#temporalidad	732042	\N	98	temporalidad	temporalidad	f	732042	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
31	http://opendata.aragon.es/def/iaest/medida#n-parados	598201	\N	69	n-parados	n-parados	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://opendata.aragon.es/def/iaest/medida#edad	43947	\N	69	edad	edad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://opendata.aragon.es/def/iaest/medida#urbana---base-imponible-miles-de-euros	14586	\N	69	urbana---base-imponible-miles-de-euros	urbana---base-imponible-miles-de-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://schema.org/material	14352	\N	9	material	material	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://opendata.aragon.es/def/iaest/medida#superficie-de-espacios-naturales-protegidos	768	\N	69	superficie-de-espacios-naturales-protegidos	superficie-de-espacios-naturales-protegidos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://opendata.aragon.es/def/iaest/medida#ccaa-nombre	18	\N	69	ccaa-nombre	ccaa-nombre	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://opendata.aragon.es/def/Aragopedia#hectareasRoquedos	725	\N	78	hectareasRoquedos	hectareasRoquedos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://opendata.aragon.es/def/Aragopedia#consumoGasoleoTipoB	16	\N	78	consumoGasoleoTipoB	consumoGasoleoTipoB	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://opendata.aragon.es/def/Aragopedia#consumoGasoleoTipoA	16	\N	78	consumoGasoleoTipoA	consumoGasoleoTipoA	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://opendata.aragon.es/def/ei2av2#order	423	\N	100	order	order	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://opendata.aragon.es/def/Aragopedia#consumoGasoleoTipoC	16	\N	78	consumoGasoleoTipoC	consumoGasoleoTipoC	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://opendata.aragon.es/def/iaest/medida#personas-residentes-viviendas-familiares	96023	\N	69	personas-residentes-viviendas-familiares	personas-residentes-viviendas-familiares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://xmlns.com/foaf/0.1/homepage	2027	\N	8	homepage	homepage	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://opendata.aragon.es/def/iaest/dimension#numero-habitaciones	12158	\N	98	numero-habitaciones	numero-habitaciones	f	12158	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
46	http://opendata.aragon.es/def/Aragopedia#hectareasViniedos	725	\N	78	hectareasViniedos	hectareasViniedos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.w3.org/ns/sosa/ObservableProperty	2	\N	94	ObservableProperty	ObservableProperty	f	2	\N	\N	f	f	106	128	\N	t	f	\N	\N	\N	t	f	f
48	http://www.wikidata.org/prop/direct/P963	281	\N	13	P963	P963	f	281	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://opendata.aragon.es/def/Aragopedia#gender	64	\N	78	gender	gender	f	64	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-solo-pastos	1533	\N	69	explotaciones-con-solo-pastos	explotaciones-con-solo-pastos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau--5-y--10-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau--5-y--10-hectareas	explotaciones-con-tierras-con-sau--5-y--10-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://icearagon.aragon.es/def/education#hasNaturalezaCentro	896	\N	93	hasNaturalezaCentro	hasNaturalezaCentro	f	896	\N	\N	f	f	91	59	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/ns/dcat#landingPage	1355	\N	15	landingPage	landingPage	f	1355	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://opendata.aragon.es/def/iaest/dimension#nucleodiseminado	1983	\N	98	nucleodiseminado	nucleodiseminado	f	1983	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
56	http://icearagon.aragon.es/def/landscape#incluyeA	7416	\N	79	incluyeA	incluyeA	f	7416	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://opendata.aragon.es/def/iaest/medida#miles-de-aves	1533	\N	69	miles-de-aves	miles-de-aves	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://data.tbfy.eu/ontology/ocds#endDate	171	\N	86	endDate	endDate	f	0	\N	\N	f	f	176	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/8	3	\N	101	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://opendata.aragon.es/def/iaest/dimension#grupo-de-tipo-de-jornada	44941	\N	98	grupo-de-tipo-de-jornada	grupo-de-tipo-de-jornada	f	44941	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
61	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	801	\N	1	first	first	f	801	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://icearagon.aragon.es/def/core#hasTipoColeccion	115	\N	83	hasTipoColeccion	hasTipoColeccion	f	115	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/4	11	\N	101	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/5	11	\N	101	5	5	f	11	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
65	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie--100-hectareas	1533	\N	69	explotaciones-con-superficie--100-hectareas	explotaciones-con-superficie--100-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/6	11	\N	101	6	6	f	11	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
67	http://opendata.aragon.es/def/iaest/medida#ordenmodalidad	109468	\N	69	ordenmodalidad	ordenmodalidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://opendata.aragon.es/def/Aragopedia#numContenedoresVidrio	11490	\N	78	numContenedoresVidrio	numContenedoresVidrio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://purl.org/dc/terms/format	2888	\N	5	format	format	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.w3.org/2006/vcard/ns#tel	12684	\N	39	tel	tel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/1	11	\N	101	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/2	11	\N	101	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-piscicola-dimension/3	11	\N	101	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://opendata.aragon.es/recurso/measureproperty/aulas-coronavirus-aragon-dimension/3	883	\N	102	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://purl.org/dc/terms/extent	1202	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://opendata.aragon.es/def/iaest/dimension#relacion-lugar-de-residencia-y-nacimiento	118028	\N	98	relacion-lugar-de-residencia-y-nacimiento	relacion-lugar-de-residencia-y-nacimiento	f	118028	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
77	http://opendata.aragon.es/def/Aragopedia#hectareasAeropuertos	725	\N	78	hectareasAeropuertos	hectareasAeropuertos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://opendata.aragon.es/def/iaest/medida#numero-empresas	2208	\N	69	numero-empresas	numero-empresas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://opendata.aragon.es/def/iaest/medida#licencias-nueva-planta-sin-demolicion	6994	\N	69	licencias-nueva-planta-sin-demolicion	licencias-nueva-planta-sin-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://opendata.aragon.es/def/iaest/medida#salario-percepciones-por-persona	36	\N	69	salario-percepciones-por-persona	salario-percepciones-por-persona	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://data.europa.eu/eli/ontology#is_member_of	7452	\N	87	[Enlace inversa con normativa (is_member_of)]	is_member_of	f	7452	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://opendata.aragon.es/def/iaest/medida#area-gastos-actuaciones-caracter-economico	10876	\N	69	area-gastos-actuaciones-caracter-economico	area-gastos-actuaciones-caracter-economico	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://www.w3.org/ns/prov#wasAssociatedWith	1217	\N	26	wasAssociatedWith	wasAssociatedWith	f	1217	\N	\N	f	f	126	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://opendata.aragon.es/def/iaest/dimension#refrigeracion	1259	\N	98	refrigeracion	refrigeracion	f	1259	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
85	http://purl.org/linked-data/cube#component	4440	\N	70	component	component	f	4440	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://opendata.aragon.es/def/iaest/medida#edificios-nueva-planta-total	8335	\N	69	edificios-nueva-planta-total	edificios-nueva-planta-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://opendata.aragon.es/def/Aragopedia#tipoEstablecimiento	3068	\N	78	tipoEstablecimiento	tipoEstablecimiento	f	3068	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://opendata.aragon.es/recurso/dimensionproperty/resultados-titulaciones-2020-2021-dimension/3	228	\N	103	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://opendata.aragon.es/recurso/dimensionproperty/resultados-titulaciones-2020-2021-dimension/4	228	\N	103	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://opendata.aragon.es/recurso/dimensionproperty/resultados-titulaciones-2020-2021-dimension/1	228	\N	103	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://opendata.aragon.es/recurso/dimensionproperty/resultados-titulaciones-2020-2021-dimension/2	228	\N	103	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuya-gestion-se-lleva-por-el-titular-de-la-misma	1533	\N	69	explotaciones-cuya-gestion-se-lleva-por-el-titular-de-la-misma	explotaciones-cuya-gestion-se-lleva-por-el-titular-de-la-misma	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-que-trabajan-en-otra-actividad-como-secundaria	1533	\N	69	personas-mano-obra-familiar-otros-que-trabajan-en-otra-actividad-como-secundaria	personas-mano-obra-familiar-otros-que-trabajan-en-otra-actividad-como-secundaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-que--trabajan-tambien-en-otra-activ-lucrativa	1533	\N	69	personas-mano-obra-familiar-otros-que--trabajan-tambien-en-otra-activ-lucrativa	personas-mano-obra-familiar-otros-que--trabajan-tambien-en-otra-activ-lucrativa	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-agua-insuficiente	1533	\N	69	superficie-regada-con-agua-insuficiente	superficie-regada-con-agua-insuficiente	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://purl.org/dc/elements/1.1/isPartOf	1332	\N	6	isPartOf	isPartOf	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://crossforest.eu/ifi/ontology/hasBasalAreaInM2	67	\N	82	hasBasalAreaInM2	hasBasalAreaInM2	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://opendata.aragon.es/def/iaest/medida#personas-asalariados-fijos-varones	1533	\N	69	personas-asalariados-fijos-varones	personas-asalariados-fijos-varones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://opendata.aragon.es/def/iaest/medida#orden	91871	\N	69	orden	orden	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/2	175	\N	104	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/3	175	\N	104	3	3	f	175	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
102	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/4	175	\N	104	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/5	175	\N	104	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://opendata.aragon.es/recurso/dimensionproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-dimension/6	175	\N	104	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://crossforest.eu/ifi/ontology/hasNumberOfTreesInUnits	67	\N	82	hasNumberOfTreesInUnits	hasNumberOfTreesInUnits	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-cuya-superficie-es-totalmente-de-su-propiedad	1533	\N	69	explotaciones-con-tierras-cuya-superficie-es-totalmente-de-su-propiedad	explotaciones-con-tierras-cuya-superficie-es-totalmente-de-su-propiedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://opendata.aragon.es/def/iaest/medida#salario-medio-por-persona	36	\N	69	salario-medio-por-persona	salario-medio-por-persona	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://xmlns.com/foaf/0.1/img	12	\N	8	img	img	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://opendata.aragon.es/def/iaest/medida#licencias-rehabilitacion-total	6839	\N	69	licencias-rehabilitacion-total	licencias-rehabilitacion-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://opendata.aragon.es/def/iaest/medida#pasivos-financieros	36476	\N	69	pasivos-financieros	pasivos-financieros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://icearagon.aragon.es/def/landscape#hasUFisio	35715	\N	79	hasUFisio	hasUFisio	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://opendata.aragon.es/def/iaest/dimension#residencia-area-nombre	62640	\N	98	residencia-area-nombre	residencia-area-nombre	f	62640	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
113	http://opendata.aragon.es/def/Aragopedia#hectareasEscasaVegetacion	725	\N	78	hectareasEscasaVegetacion	hectareasEscasaVegetacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/7	8	\N	105	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/8	3	\N	105	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://opendata.aragon.es/def/iaest/medida#sau-ha	767	\N	69	sau-ha	sau-ha	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://data.europa.eu/eli/ontology#is_embodied_by	7452	\N	87	is_embodied_by	is_embodied_by	f	7452	\N	\N	f	f	24	61	\N	t	f	\N	\N	\N	t	f	f
118	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/9	26	\N	105	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/3	940	\N	105	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
120	https://dbpedia.org/ontology/purpose	1	\N	106	purpose	purpose	f	0	\N	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/4	956	\N	105	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://opendata.aragon.es/order	481	\N	107	order	order	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/5	937	\N	105	5	5	f	937	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
124	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/6	940	\N	105	6	6	f	940	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
125	http://opendata.aragon.es/def/ei2av2#label	109	\N	100	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-35-anos	1533	\N	69	personas-que-son-mano-de-obra-familiar-35-anos	personas-que-son-mano-de-obra-familiar-35-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano-cultivos-frutales	1533	\N	69	hectareas-en-tierras-labradas-de-secano-cultivos-frutales	hectareas-en-tierras-labradas-de-secano-cultivos-frutales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/1	940	\N	105	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://opendata.aragon.es/def/iaest/dimension#regimen-de-tenencia	4088	\N	98	regimen-de-tenencia	regimen-de-tenencia	f	4088	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
130	http://icearagon.aragon.es/def/landscape#hasFeatureCalidadDelPaisaje	3851	\N	79	hasFeatureCalidadDelPaisaje	hasFeatureCalidadDelPaisaje	f	3851	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-nucleos-zoologicos-dimension/2	940	\N	105	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://opendata.aragon.es/def/iaest/medida#contenedores-de-envases	7644	\N	69	contenedores-de-envases	contenedores-de-envases	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://opendata.aragon.es/def/iaest/medida#urbana---cuota-liquida-euros	13052	\N	69	urbana---cuota-liquida-euros	urbana---cuota-liquida-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://opendata.aragon.es/comment	389	\N	107	comment	comment	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://opendata.aragon.es/def/iaest/medida#pension-percepciones	8586	\N	69	pension-percepciones	pension-percepciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau	3066	\N	69	explotaciones-con-tierras-con-sau	explotaciones-con-tierras-con-sau	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://xmlns.com/foaf/0.1/mbox	82	\N	8	mbox	mbox	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-trabajan-tambien-en-otra-activ-lucrativa	1533	\N	69	personas-mano-obra-familiar-trabajan-tambien-en-otra-activ-lucrativa	personas-mano-obra-familiar-trabajan-tambien-en-otra-activ-lucrativa	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://opendata.aragon.es/def/iaest/dimension#plantas-sobre-rasante	2819	\N	98	plantas-sobre-rasante	plantas-sobre-rasante	f	2819	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
141	http://purl.org/dc/terms/hasPart	807	\N	5	hasPart	hasPart	f	807	\N	\N	f	f	160	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://opendata.aragon.es/def/iaest/medida#renta-disponible-bruta-per-capita	3144	\N	69	renta-disponible-bruta-per-capita	renta-disponible-bruta-per-capita	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://opendata.aragon.es/def/Aragopedia#isDataSetOf	24157	\N	78	isDataSetOf	isDataSetOf	f	24157	\N	\N	f	f	9	104	\N	t	f	\N	\N	\N	t	f	f
144	http://icearagon.aragon.es/def/hydro#hasAreaInHa_1992	30	\N	84	hasAreaInHa_1992	hasAreaInHa_1992	f	0	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano-cultivo-olivar	1533	\N	69	hectareas-en-tierras-labradas-de-secano-cultivo-olivar	hectareas-en-tierras-labradas-de-secano-cultivo-olivar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-labranza-y-otras	1533	\N	69	explotaciones-con-tierras-labranza-y-otras	explotaciones-con-tierras-labranza-y-otras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://opendata.aragon.es/def/iaest/medida#extranjeros	241813	\N	69	extranjeros	extranjeros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://opendata.aragon.es/def/iaest/medida#desempleo-perceptores	5540	\N	69	desempleo-perceptores	desempleo-perceptores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://schema.org/startDate	1537	\N	9	startDate	startDate	f	0	\N	\N	f	f	134	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://opendata.aragon.es/def/iaest/medida#numero-viviendas	128	\N	69	numero-viviendas	numero-viviendas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://opendata.aragon.es/def/iaest/dimension#nivel-formativo-grupo-iaest-descripcion	190441	\N	98	nivel-formativo-grupo-iaest-descripcion	nivel-formativo-grupo-iaest-descripcion	f	190441	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
152	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio-cultivos-frutales	1533	\N	69	hectareas-en-tierras-labradas-de-regadio-cultivos-frutales	hectareas-en-tierras-labradas-de-regadio-cultivos-frutales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://www.wikidata.org/prop/direct/P101	8944	\N	13	P101	P101	f	0	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://purl.org/dc/terms/isPartOf	7218	\N	5	isPartOf	isPartOf	f	7218	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://purl.org/dc/terms/MediaType	364309	\N	5	MediaType	MediaType	f	364309	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://purl.org/dc/elements/1.1/accrualPeriodicity	160	\N	6	accrualPeriodicity	accrualPeriodicity	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	801	\N	1	rest	rest	f	801	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://opendata.aragon.es/def/iaest/medida#residencial	13052	\N	69	residencial	residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-otros-miembros-familia	767	\N	69	unidades-trabajo-ano-otros-miembros-familia	unidades-trabajo-ano-otros-miembros-familia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://opendata.aragon.es/def/Aragopedia#enComunidadAutonoma	767	\N	78	enComunidadAutonoma	enComunidadAutonoma	f	767	\N	\N	f	f	63	10	\N	t	f	\N	\N	\N	t	f	f
161	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-para-pastos-permanentes	1533	\N	69	hectareas-en-tierras-para-pastos-permanentes	hectareas-en-tierras-para-pastos-permanentes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://opendata.aragon.es/def/iaest/medida#espanoles	8560	\N	69	espanoles	espanoles	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://opendata.aragon.es/def/iaest/medida#licencias-rehabilitacion-locales	6392	\N	69	licencias-rehabilitacion-locales	licencias-rehabilitacion-locales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://opendata.aragon.es/def/iaest/dimension#situacion-profesional	6181	\N	98	situacion-profesional	situacion-profesional	f	6181	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
165	http://opendata.aragon.es/def/iaest/medida#numero-total-de-parcelas	1533	\N	69	numero-total-de-parcelas	numero-total-de-parcelas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://opendata.aragon.es/def/iaest/medida#votos-nulos	13824	\N	69	votos-nulos	votos-nulos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://www.w3.org/2006/timeInterval	313399	\N	108	timeInterval	timeInterval	f	313399	\N	\N	f	f	\N	142	\N	t	f	\N	\N	\N	t	f	f
168	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/10	1	\N	109	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/12	1	\N	109	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/11	5	\N	109	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/14	2	\N	109	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://opendata.aragon.es/def/iaest/medida#superficie-no-regada-disponiendo-la-explotacion-de-instalaciones-y-agua	1533	\N	69	superficie-no-regada-disponiendo-la-explotacion-de-instalaciones-y-agua	superficie-no-regada-disponiendo-la-explotacion-de-instalaciones-y-agua	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://www.w3.org/2002/07/owl#disjointWith	9	\N	7	disjointWith	disjointWith	f	9	\N	\N	f	f	57	57	\N	t	f	\N	\N	\N	t	f	f
174	http://opendata.aragon.es/def/iaest/medida#2000-2009	768	\N	69	2000-2009	2000-2009	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-piscicola-medida/15	1	\N	109	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://purl.org/linked-data/cube#order	109	\N	70	order	order	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://opendata.aragon.es/def/iaest/medida#explotaciones-sin-tierras	4599	\N	69	explotaciones-sin-tierras	explotaciones-sin-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://opendata.aragon.es/def/iaest/dimension#cursos-jefe-explotacion	1469	\N	98	cursos-jefe-explotacion	cursos-jefe-explotacion	f	1469	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
179	http://opendata.aragon.es/def/iaest/dimension#tamano-centro	11179	\N	98	tamano-centro	tamano-centro	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://schemas.opengis.net/geosparql/sfIntersects	12098	\N	110	sfIntersects	sfIntersects	f	12098	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://opendata.aragon.es/def/iaest/medida#viviendas-con-acceso-a-internet	722	\N	69	viviendas-con-acceso-a-internet	viviendas-con-acceso-a-internet	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://opendata.aragon.es/def/iaest/dimension#tipo-hogar-1	2126	\N	98	tipo-hogar-1	tipo-hogar-1	f	2126	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
183	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-nucleos-zoologicos-medida/10	644	\N	111	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/8	4923	\N	112	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://www.wikidata.org/prop/direct/P569	2680	\N	13	P569	P569	f	0	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
186	http://opendata.aragon.es/def/iaest/medida#visados-obra-nueva	349	\N	69	visados-obra-nueva	visados-obra-nueva	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-aguas-superficiales	1533	\N	69	superficie-regada-con-aguas-superficiales	superficie-regada-con-aguas-superficiales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/4	4905	\N	112	4	4	f	4905	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
189	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/7	4905	\N	112	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://opendata.aragon.es/def/iaest/dimension#porcentaje-de-sau-en-propiedad-del-titular	4400	\N	98	porcentaje-de-sau-en-propiedad-del-titular	porcentaje-de-sau-en-propiedad-del-titular	f	4400	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
191	http://www.w3.org/2006/vcard/ns#Location	227	\N	39	Location	Location	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/6	4908	\N	112	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://opendata.aragon.es/def/iaest/dimension#calefaccion-detalle	7376	\N	98	calefaccion-detalle	calefaccion-detalle	f	7376	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
194	http://opendata.aragon.es/def/iaest/dimension#contaminacion	2228	\N	98	contaminacion	contaminacion	f	2228	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
195	http://opendata.aragon.es/def/iaest/medida#urbana---cuota-integra-euros	13052	\N	69	urbana---cuota-integra-euros	urbana---cuota-integra-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/3	4905	\N	112	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://opendata.aragon.es/def/iaest/medida#bi-edificios-singulares	10751	\N	69	bi-edificios-singulares	bi-edificios-singulares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://opendata.aragon.es/recurso/dimensionproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-dimension/2	4905	\N	112	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://opendata.aragon.es/def/iaest/dimension#falta-de-servicios-de-aseo	128	\N	98	falta-de-servicios-de-aseo	falta-de-servicios-de-aseo	f	128	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
200	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	28	133	\N	t	f	\N	\N	\N	t	f	f
201	http://opendata.aragon.es/def/iaest/dimension#clase-vivienda	5	\N	98	clase-vivienda	clase-vivienda	f	5	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
202	http://opendata.aragon.es/def/iaest/medida#1990-1999	768	\N	69	1990-1999	1990-1999	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://opendata.aragon.es/def/iaest/medida#contenedores-de-pilas	768	\N	69	contenedores-de-pilas	contenedores-de-pilas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://data.europa.eu/eli/ontology#realizes	7452	\N	87	realizes	realizes	f	7452	\N	\N	f	f	24	60	\N	t	f	\N	\N	\N	t	f	f
205	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-concesion-integrada-en-una-comunidad-de-regantes	767	\N	69	superficie-regada-con-concesion-integrada-en-una-comunidad-de-regantes	superficie-regada-con-concesion-integrada-en-una-comunidad-de-regantes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://www.w3.org/2004/02/skos/core#narrower	4	\N	4	narrower	narrower	f	4	\N	\N	f	f	59	59	\N	t	f	\N	\N	\N	t	f	f
207	http://opendata.aragon.es/def/iaest/dimension#tipo-de-vivienda-principal	787	\N	98	tipo-de-vivienda-principal	tipo-de-vivienda-principal	f	787	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
208	http://www.w3.org/ns/org#role	3164	\N	37	role	role	f	3164	\N	\N	f	f	85	109	\N	t	f	\N	\N	\N	t	f	f
209	http://opendata.aragon.es/def/iaest/medida#sin-definir	768	\N	69	sin-definir	sin-definir	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://opendata.aragon.es/def/iaest/dimension#delincuencia-zona	128	\N	98	delincuencia-zona	delincuencia-zona	f	128	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
211	http://www.w3.org/2004/02/skos/core#member	297	\N	4	member	member	f	297	\N	\N	f	f	12	59	\N	t	f	\N	\N	\N	t	f	f
212	http://opendata.aragon.es/def/iaest/medida#urbano-bienes-inmuebles	14586	\N	69	urbano-bienes-inmuebles	urbano-bienes-inmuebles	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://icearagon.aragon.es/def/education#hasZonaInfPri	19	\N	93	hasZonaInfPri	hasZonaInfPri	f	0	\N	\N	f	f	163	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://schema.org/concept	65977	\N	9	concept	concept	f	65977	\N	\N	f	f	190	59	\N	t	f	\N	\N	\N	t	f	f
215	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://opendata.aragon.es/def/iaest/dimension#dias-duracion-contrato	292971	\N	98	dias-duracion-contrato	dias-duracion-contrato	f	292971	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
218	http://opendata.aragon.es/def/iaest/dimension#lugar-de-residencia	2	\N	98	lugar-de-residencia	lugar-de-residencia	f	2	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
219	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-titular	767	\N	69	unidades-trabajo-ano-titular	unidades-trabajo-ano-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://www.wikidata.org/prop/direct/P570	2680	\N	13	P570	P570	f	0	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/11	161	\N	113	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/10	3682	\N	113	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://opendata.aragon.es/def/iaest/medida#viviendas-rehabilitacion	6508	\N	69	viviendas-rehabilitacion	viviendas-rehabilitacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/13	590	\N	113	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://opendata.aragon.es/def/iaest/medida#participacion	13824	\N	69	participacion	participacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/12	212	\N	113	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/15	183	\N	113	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-medida/14	186	\N	113	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/5	113	\N	114	5	5	f	113	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
230	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/6	113	\N	114	6	6	f	113	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
231	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/8	97	\N	114	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/1	113	\N	114	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
929	http://www.w3.org/ns/dcat#distribution	2893	\N	15	distribution	distribution	f	2893	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://opendata.aragon.es/def/iaest/medida#rustica---cuota-liquida-euros	13052	\N	69	rustica---cuota-liquida-euros	rustica---cuota-liquida-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://opendata.aragon.es/def/iaest/dimension#actividad-del-local	3902	\N	98	actividad-del-local	actividad-del-local	f	3902	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
235	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/2	113	\N	114	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/3	113	\N	114	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
237	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-cunicola-dimension/4	107	\N	114	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://www.opengis.net/ont/geosparql#hasGeometry	136832	\N	25	hasGeometry	hasGeometry	f	783	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://data.tbfy.eu/ontology/ocds#startDate	171	\N	86	startDate	startDate	f	0	\N	\N	f	f	176	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://icearagon.aragon.es/def/hydro#hasAreaInHa_2000	27	\N	84	hasAreaInHa_2000	hasAreaInHa_2000	f	0	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://www.openlinksw.com/schemas/VSPX#title	1	\N	81	title	title	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://purl.org/dc/terms/description	5513	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://opendata.aragon.es/def/iaest/medida#superficie-calificada-en-reconversion	8448	\N	69	superficie-calificada-en-reconversion	superficie-calificada-en-reconversion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://opendata.aragon.es/def/iaest/medida#gastos-fondo-de-contingencia	3731	\N	69	gastos-fondo-de-contingencia	gastos-fondo-de-contingencia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://opendata.aragon.es/def/iaest/medida#viviendas-obra-nueva-bloque	349	\N	69	viviendas-obra-nueva-bloque	viviendas-obra-nueva-bloque	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://www.wikidata.org/prop/direct/P140	589	\N	13	P140	P140	f	0	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://opendata.aragon.es/def/iaest/medida#antes-de-1950	768	\N	69	antes-de-1950	antes-de-1950	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://schema.org/publisher	759373	\N	9	publisher	publisher	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/9	4362	\N	115	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://www.geonames.org/ontology#title	14	\N	72	title	title	f	0	\N	\N	f	f	112	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://opendata.aragon.es/def/iaest/medida#ano	65606	\N	69	ano	ano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau--20-y--50-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau--20-y--50-hectareas	explotaciones-con-tierras-con-sau--20-y--50-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-cosechadora	1533	\N	69	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-cosechadora	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-cosechadora	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://opendata.aragon.es/def/iaest/dimension#formacion-jefe-explotacion	2397	\N	98	formacion-jefe-explotacion	formacion-jefe-explotacion	f	2397	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
255	http://opendata.aragon.es/def/iaest/medida#ganado-caprino-cabezas	1533	\N	69	ganado-caprino-cabezas	ganado-caprino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://schema.org/additionalType	910625	\N	9	additionalType	additionalType	f	910625	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://opendata.aragon.es/def/iaest/dimension#tipo-edificio-detalle	3334	\N	98	tipo-edificio-detalle	tipo-edificio-detalle	f	3334	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
258	http://opendata.aragon.es/def/iaest/medida#total-personas	12	\N	69	total-personas	total-personas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	2	\N	96	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://purl.org/dc/terms/publisher	2684	\N	5	publisher	publisher	f	2677	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
261	http://opendata.aragon.es/def/iaest/medida#hectareas-de-sau-en-otros-regimenes-de-tenencia-de-las-tierras	1533	\N	69	hectareas-de-sau-en-otros-regimenes-de-tenencia-de-las-tierras	hectareas-de-sau-en-otros-regimenes-de-tenencia-de-las-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://opendata.aragon.es/def/iaest/medida#densidad-de-poblacion-habkm2	31431	\N	69	densidad-de-poblacion-habkm2	densidad-de-poblacion-habkm2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://opendata.aragon.es/def/iaest/dimension#condicion-socioeconomica	14472	\N	98	condicion-socioeconomica	condicion-socioeconomica	f	14472	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
264	http://opendata.aragon.es/def/iaest/dimension#numero-de-miembros	4717	\N	98	numero-de-miembros	numero-de-miembros	f	4717	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
265	http://opendata.aragon.es/def/iaest/dimension#lugar-trabajo-o-estudio	6048	\N	98	lugar-trabajo-o-estudio	lugar-trabajo-o-estudio	f	6048	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
266	http://opendata.aragon.es/def/iaest/dimension#corine-land-cover-2000-nivel-3-descripcion	28070	\N	98	corine-land-cover-2000-nivel-3-descripcion	corine-land-cover-2000-nivel-3-descripcion	f	28070	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
267	http://opendata.aragon.es/def/Aragopedia#hectareasArrozales	725	\N	78	hectareasArrozales	hectareasArrozales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://opendata.aragon.es/def/iaest/medida#numero-de-explotaciones-con-ganado	767	\N	69	numero-de-explotaciones-con-ganado	numero-de-explotaciones-con-ganado	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://opendata.aragon.es/def/iaest/medida#tasa-global-de-fecundidad	10722	\N	69	tasa-global-de-fecundidad	tasa-global-de-fecundidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://www.w3.org/1999/02/22-rdf-syntax-ns#resource	363282	\N	1	resource	resource	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://opendata.aragon.es/def/iaest/dimension#residencia-continente-nombre	67669	\N	98	residencia-continente-nombre	residencia-continente-nombre	f	67669	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
272	http://opendata.aragon.es/def/iaest/medida#candidatura	6975	\N	69	candidatura	candidatura	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://www.w3.org/2002/07/owl#imports	16	\N	7	imports	imports	f	16	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://opendata.aragon.es/def/iaest/dimension#especie-ganaderia-descripcion	6360	\N	98	especie-ganaderia-descripcion	especie-ganaderia-descripcion	f	6360	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
275	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-de-mas-de-65-anos	1533	\N	69	personas-que-son-mano-de-obra-familiar-de-mas-de-65-anos	personas-que-son-mano-de-obra-familiar-de-mas-de-65-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://opendata.aragon.es/def/Aragopedia#enComarcaTemporal	730	\N	78	enComarcaTemporal	enComarcaTemporal	f	0	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://opendata.aragon.es/def/Aragopedia#hectareasZonasQuemadas	725	\N	78	hectareasZonasQuemadas	hectareasZonasQuemadas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://opendata.aragon.es/def/iaest/dimension#numero-de-viajes-diarios	442	\N	98	numero-de-viajes-diarios	numero-de-viajes-diarios	f	442	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
279	http://opendata.aragon.es/def/Aragopedia#hectareasCursosAgua	725	\N	78	hectareasCursosAgua	hectareasCursosAgua	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://purl.org/linked-data/cube#codeList	338	\N	70	codeList	codeList	f	338	\N	\N	f	f	86	129	\N	t	f	\N	\N	\N	t	f	f
281	http://opendata.aragon.es/def/iaest/dimension#tipo-de-vehiculo-orden	4475	\N	98	tipo-de-vehiculo-orden	tipo-de-vehiculo-orden	f	4475	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
282	http://opendata.aragon.es/def/iaest/medida#n-hogares	8068	\N	69	n-hogares	n-hogares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://opendata.aragon.es/def/iaest/medida#siglas	234718	\N	69	siglas	siglas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://icearagon.aragon.es/def/core#hasAreaInM2	25	\N	83	hasAreaInM2	hasAreaInM2	f	0	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://opendata.aragon.es/def/iaest/medida#urbana---numero-de-recibos	14586	\N	69	urbana---numero-de-recibos	urbana---numero-de-recibos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-son-titulares-35-anos	1533	\N	69	personas-mano-obra-familiar-son-titulares-35-anos	personas-mano-obra-familiar-son-titulares-35-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/2002/07/owl#onProperty	116	\N	7	onProperty	onProperty	f	116	\N	\N	f	f	206	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://opendata.aragon.es/def/iaest/medida#vc-ocio-hosteleria	8751	\N	69	vc-ocio-hosteleria	vc-ocio-hosteleria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/14	142	\N	116	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/13	11	\N	116	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://opendata.aragon.es/def/iaest/dimension#tipo-de-edificio	1056	\N	98	tipo-de-edificio	tipo-de-edificio	f	1056	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
293	http://data.europa.eu/eli/ontology#title	7557	\N	87	title	title	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
294	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/15	81	\N	116	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-formacion-profesional-del-titular	1533	\N	69	explotaciones-con-formacion-profesional-del-titular	explotaciones-con-formacion-profesional-del-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/12	34	\N	116	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
297	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/11	11	\N	116	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://opendata.aragon.es/def/iaest/medida#contenedores-de-papel-y-carton	7677	\N	69	contenedores-de-papel-y-carton	contenedores-de-papel-y-carton	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	58	58	\N	t	f	\N	\N	\N	t	f	f
300	http://opendata.aragon.es/def/iaest/medida#unidades-ganaderas	1533	\N	69	unidades-ganaderas	unidades-ganaderas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
301	http://opendata.aragon.es/def/iaest/medida#urbano-superficie	42428	\N	69	urbano-superficie	urbano-superficie	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://icearagon.aragon.es/def/education#hasZonaESO	19	\N	93	hasZonaESO	hasZonaESO	f	0	\N	\N	f	f	163	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://www.w3.org/ns/org#siteAddress	27105	\N	37	siteAddress	siteAddress	f	27105	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
304	http://www.w3.org/2006/vcard/ns#fn	387707	\N	39	fn	fn	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
305	http://schema.org/identifier	950224	\N	9	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-titulares-que-solo-trabajan-en-la-explotacion	1533	\N	69	personas-mano-obra-familiar-titulares-que-solo-trabajan-en-la-explotacion	personas-mano-obra-familiar-titulares-que-solo-trabajan-en-la-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
307	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://opendata.aragon.es/def/iaest/medida#municipio-2-residencia-nombre	10	\N	69	municipio-2-residencia-nombre	municipio-2-residencia-nombre	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
285	http://data.europa.eu/eli/ontology#is_realized_by	7452	\N	87	[Enlace a la expresión legal (is_realized_by)]	is_realized_by	f	7452	\N	\N	f	f	60	24	\N	t	f	\N	\N	\N	t	f	f
309	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-trabajan-en-otra-actividad-como-secundaria	1533	\N	69	personas-mano-obra-familiar-trabajan-en-otra-actividad-como-secundaria	personas-mano-obra-familiar-trabajan-en-otra-actividad-como-secundaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://opendata.aragon.es/def/iaest/dimension#continente-nacionalidad	2307	\N	98	continente-nacionalidad	continente-nacionalidad	f	2307	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
311	http://data.tbfy.eu/ontology/ocds#title	3297	\N	86	title	title	f	0	\N	\N	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
312	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras	7665	\N	69	explotaciones-con-tierras	explotaciones-con-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
313	http://opendata.aragon.es/def/Aragopedia#hectareasMatorralBoscoso	725	\N	78	hectareasMatorralBoscoso	hectareasMatorralBoscoso	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://opendata.aragon.es/def/iaest/medida#indice-de-envejecimiento	33703	\N	69	indice-de-envejecimiento	indice-de-envejecimiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
315	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-maquina-en-propiedad-cosechadora	1533	\N	69	explotaciones-con-maquina-en-propiedad-cosechadora	explotaciones-con-maquina-en-propiedad-cosechadora	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
317	http://icearagon.aragon.es/def/landscape#hasFeatureAptitudDelPaisaje	3851	\N	79	hasFeatureAptitudDelPaisaje	hasFeatureAptitudDelPaisaje	f	3851	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://opendata.aragon.es/def/iaest/medida#animales	17	\N	69	animales	animales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://icearagon.aragon.es/def/education#hasTipoCentro	896	\N	93	hasTipoCentro	hasTipoCentro	f	896	\N	\N	f	f	91	59	\N	t	f	\N	\N	\N	t	f	f
320	http://opendata.aragon.es/def/iaest/medida#rustico-parcelas	14583	\N	69	rustico-parcelas	rustico-parcelas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://opendata.aragon.es/def/iaest/medida#desempleo-medio-por-percepcion	48	\N	69	desempleo-medio-por-percepcion	desempleo-medio-por-percepcion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
322	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-aguas-depuradas	767	\N	69	superficie-regada-con-aguas-depuradas	superficie-regada-con-aguas-depuradas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-solo-tierras-labranza	1533	\N	69	explotaciones-con-solo-tierras-labranza	explotaciones-con-solo-tierras-labranza	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
324	http://opendata.aragon.es/def/iaest/dimension#modalidad	219622	\N	98	modalidad	modalidad	f	219622	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
325	http://opendata.aragon.es/def/iaest/dimension#subseccion-descripcion	13728	\N	98	subseccion-descripcion	subseccion-descripcion	f	13728	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
326	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-asalariados-fijos	767	\N	69	unidades-trabajo-ano-asalariados-fijos	unidades-trabajo-ano-asalariados-fijos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
327	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-maquina-en-propiedad-tractor	1533	\N	69	explotaciones-con-maquina-en-propiedad-tractor	explotaciones-con-maquina-en-propiedad-tractor	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
328	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-con-cultivo-olivar	1533	\N	69	hectareas-en-tierras-labradas-con-cultivo-olivar	hectareas-en-tierras-labradas-con-cultivo-olivar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-aragon-dimension/1	528	\N	117	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
330	http://schema.org/sdDatePublished	65977	\N	9	sdDatePublished	sdDatePublished	f	0	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
331	http://opendata.aragon.es/def/iaest/medida#urbana---base-liquidable-miles-de-euros	14586	\N	69	urbana---base-liquidable-miles-de-euros	urbana---base-liquidable-miles-de-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
332	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-asalariados-eventuales	767	\N	69	unidades-trabajo-ano-asalariados-eventuales	unidades-trabajo-ano-asalariados-eventuales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
333	http://opendata.aragon.es/def/iaest/dimension#fondo-de-contingencia	3032	\N	98	fondo-de-contingencia	fondo-de-contingencia	f	3032	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
334	http://opendata.aragon.es/def/iaest/medida#edificios-rehabilitacion	6845	\N	69	edificios-rehabilitacion	edificios-rehabilitacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
335	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuge-de-35-a-54-anos	1533	\N	69	personas-mano-obra-familiar-conyuge-de-35-a-54-anos	personas-mano-obra-familiar-conyuge-de-35-a-54-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
336	http://opendata.aragon.es/def/iaest/medida#hectareas-de-sau-en-arrendamiento	1533	\N	69	hectareas-de-sau-en-arrendamiento	hectareas-de-sau-en-arrendamiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
337	http://dbpedia.org/ontology/country	768	\N	10	country	country	f	768	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
338	http://purl.org/linked-data/cube#dataSet	5224190	\N	70	dataSet	dataSet	f	5224190	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
339	http://opendata.aragon.es/def/iaest/dimension#tipo-de-nacionalidad	111865	\N	98	tipo-de-nacionalidad	tipo-de-nacionalidad	f	111865	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
340	http://purl.org/dc/terms/modified	2577	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
341	http://opendata.aragon.es/def/iaest/medida#viviendas-con-evacuacion-de-aguas-residuales	768	\N	69	viviendas-con-evacuacion-de-aguas-residuales	viviendas-con-evacuacion-de-aguas-residuales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://icearagon.aragon.es/def/ps#hasCod_uicn	25	\N	91	hasCod_uicn	hasCod_uicn	f	25	\N	\N	f	f	87	57	\N	t	f	\N	\N	\N	t	f	f
343	http://opendata.aragon.es/def/iaest/medida#1980-1989	768	\N	69	1980-1989	1980-1989	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
344	http://icearagon.aragon.es/def/core#daNombreA	58	\N	83	daNombreA	daNombreA	f	58	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
345	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-y-conyuges	1533	\N	69	personas-que-son-mano-de-obra-familiar-y-conyuges	personas-que-son-mano-de-obra-familiar-y-conyuges	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://opendata.aragon.es/def/iaest/dimension#tiempo-desplazamiento	1098	\N	98	tiempo-desplazamiento	tiempo-desplazamiento	f	1098	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
347	http://opendata.aragon.es/def/iaest/medida#bi-oficinas	10751	\N	69	bi-oficinas	bi-oficinas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
348	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/14	34	\N	99	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/13	22	\N	99	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/16	7	\N	99	16	16	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
351	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/15	14	\N	99	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
352	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/18	17	\N	99	18	18	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
353	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/17	4	\N	99	17	17	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
354	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-otra-relacion-con-35-anos	1533	\N	69	personas-mano-obra-familiar-otros-otra-relacion-con-35-anos	personas-mano-obra-familiar-otros-otra-relacion-con-35-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
355	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/19	32	\N	99	19	19	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/10	21	\N	99	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
357	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-son-asalariados-fijos	1533	\N	69	unidades-de-trabajo-que-son-asalariados-fijos	unidades-de-trabajo-que-son-asalariados-fijos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
358	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/12	1	\N	99	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
359	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/11	341	\N	99	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://www.w3.org/2004/02/skos/core#prefLabel	19946	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://opendata.aragon.es/def/iaest/medida#tierras-labradas	765	\N	69	tierras-labradas	tierras-labradas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
362	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/5	2372	\N	118	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
363	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/9	284	\N	119	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/6	2371	\N	118	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
365	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/7	301	\N	119	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/3	2371	\N	118	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
367	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/8	419	\N	119	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/4	2371	\N	118	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://purl.org/dc/elements/1.1/relation	811	\N	6	relation	relation	f	765	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
370	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/2	2371	\N	118	2	2	f	2371	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
371	http://opendata.aragon.es/def/iaest/medida#ganado-equino-cabezas	1533	\N	69	ganado-equino-cabezas	ganado-equino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
372	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	4	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://opendata.aragon.es/def/iaest/dimension#ocupacion-1-digito-descripcion	11652	\N	98	ocupacion-1-digito-descripcion	ocupacion-1-digito-descripcion	f	11652	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
375	http://www.w3.org/2003/01/geo/wgs84_pos#long	4200	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
376	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuyo-titular-es-una-cooperativa-de-produccion	1533	\N	69	explotaciones-cuyo-titular-es-una-cooperativa-de-produccion	explotaciones-cuyo-titular-es-una-cooperativa-de-produccion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
377	http://opendata.aragon.es/def/iaest/medida#ganado-porcino-cerdas-madres-cabezas	1533	\N	69	ganado-porcino-cerdas-madres-cabezas	ganado-porcino-cerdas-madres-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://opendata.aragon.es/def/iaest/medida#duracion-contrato	292971	\N	69	duracion-contrato	duracion-contrato	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://opendata.aragon.es/def/iaest/dimension#bonificado-o-no	48681	\N	98	bonificado-o-no	bonificado-o-no	f	48681	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
380	http://opendata.aragon.es/def/iaest/medida#tasa-bruta-de-nupcialidad	10748	\N	69	tasa-bruta-de-nupcialidad	tasa-bruta-de-nupcialidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://www.w3.org/2006/timeInstant	598749	\N	108	timeInstant	timeInstant	f	598749	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
382	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/24	13	\N	99	24	24	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
374	http://opendata.aragon.es/def/iaest/dimension#ue28-ue27-ue25	59589	\N	98	[UE28-UE27-UE25 (ue28-ue27-ue25)]	ue28-ue27-ue25	f	59589	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
383	http://opendata.aragon.es/def/Aragopedia#hectareasZonasConstruccion	725	\N	78	hectareasZonasConstruccion	hectareasZonasConstruccion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
384	http://www.w3.org/ns/org#identifier	6231	\N	37	identifier	identifier	f	0	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuya-gestion-se-lleva-por-un-miembro-de-la-familia-no-titular	1533	\N	69	explotaciones-cuya-gestion-se-lleva-por-un-miembro-de-la-familia-no-titular	explotaciones-cuya-gestion-se-lleva-por-un-miembro-de-la-familia-no-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
386	http://www.openlinksw.com/ontology/acl#hasApplicableAccess	2	\N	97	hasApplicableAccess	hasApplicableAccess	f	2	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://opendata.aragon.es/def/Aragopedia#refArea	27159	\N	78	refArea	refArea	f	27159	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/9	2585	\N	118	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
389	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-avicola-medida/20	4	\N	99	20	20	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/7	2371	\N	118	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
391	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-otra-condicion-juridica	1533	\N	69	explotaciones-con-otra-condicion-juridica	explotaciones-con-otra-condicion-juridica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://opendata.aragon.es/def/iaest/medida#numero-de-explotaciones-sin-ganado	767	\N	69	numero-de-explotaciones-sin-ganado	numero-de-explotaciones-sin-ganado	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
393	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/8	2371	\N	118	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
394	http://opendata.aragon.es/def/iaest/medida#viviendas-obra-nueva-total	349	\N	69	viviendas-obra-nueva-total	viviendas-obra-nueva-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-maquina-en-propiedad-otra-maquina	770	\N	69	explotaciones-con-maquina-en-propiedad-otra-maquina	explotaciones-con-maquina-en-propiedad-otra-maquina	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
396	http://opendata.aragon.es/def/iaest/medida#depuradoras	6144	\N	69	depuradoras	depuradoras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
397	https://schema.org/address	6495	\N	120	address	address	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
398	http://opendata.aragon.es/def/iaest/medida#espacios-naturales-protegidos	768	\N	69	espacios-naturales-protegidos	espacios-naturales-protegidos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
399	http://opendata.aragon.es/def/iaest/medida#fecha	1487	\N	69	fecha	fecha	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-con-cultivos-frutales	1533	\N	69	hectareas-en-tierras-labradas-con-cultivos-frutales	hectareas-en-tierras-labradas-con-cultivos-frutales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://crossforest.eu/ifi/ontology/hasVolumeWithBarkInM3ByHa	67	\N	82	hasVolumeWithBarkInM3ByHa	hasVolumeWithBarkInM3ByHa	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
402	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-tractor	1533	\N	69	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-tractor	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-tractor	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://opendata.aragon.es/def/iaest/medida#viviendas-con-agua-caliente-central	739	\N	69	viviendas-con-agua-caliente-central	viviendas-con-agua-caliente-central	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://www.w3.org/2006/vcard/ns#street-address	21935	\N	39	street-address	street-address	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://schema.org/datePublished	764	\N	9	datePublished	datePublished	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
406	http://opendata.aragon.es/def/iaest/medida#transferencias-corrientes	36476	\N	69	transferencias-corrientes	transferencias-corrientes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
407	http://opendata.aragon.es/def/iaest/medida#rustico-valor-catastral	14583	\N	69	rustico-valor-catastral	rustico-valor-catastral	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-de-55-a-64-anos	1533	\N	69	personas-mano-obra-familiar-otros-de-55-a-64-anos	personas-mano-obra-familiar-otros-de-55-a-64-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://icearagon.aragon.es/def/bca#hasEstado	1	\N	89	hasEstado	hasEstado	f	1	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
410	http://www.openlinksw.com/schemas/VSPX#type	1	\N	81	type	type	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://opendata.aragon.es/def/iaest/medida#1960-1969	768	\N	69	1960-1969	1960-1969	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
412	http://www.w3.org/2002/07/owl#complementOf	3	\N	7	complementOf	complementOf	f	3	\N	\N	f	f	\N	57	\N	t	f	\N	\N	\N	t	f	f
413	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-agua-suficiente	1533	\N	69	superficie-regada-con-agua-suficiente	superficie-regada-con-agua-suficiente	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://schema.org/about	266250	\N	9	about	about	f	266250	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
415	http://xmlns.com/foaf/0.1/phone	370	\N	8	phone	phone	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
416	http://opendata.aragon.es/def/Aragopedia#population	8590	\N	78	population	population	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
417	http://purl.org/linked-data/cube#dimension	2107	\N	70	dimension	dimension	f	2107	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
418	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-otras-medida/9	94	\N	121	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://opendata.aragon.es/def/iaest/dimension#corine-land-cover-2000-nivel-2-descripcion	19929	\N	98	corine-land-cover-2000-nivel-2-descripcion	corine-land-cover-2000-nivel-2-descripcion	f	19929	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
420	http://data.europa.eu/eli/ontology/first_date_entry_in_force	2847	\N	122	first_date_entry_in_force	first_date_entry_in_force	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
421	http://crossforest.eu/ifi/ontology/containsDominantFormation	67	\N	82	containsDominantFormation	containsDominantFormation	f	67	\N	\N	f	f	\N	15	\N	t	f	\N	\N	\N	t	f	f
422	http://opendata.aragon.es/def/iaest/medida#bi-suelo-vacante	10751	\N	69	bi-suelo-vacante	bi-suelo-vacante	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
423	http://opendata.aragon.es/def/iaest/medida#superficie-regada-has	1533	\N	69	superficie-regada-has	superficie-regada-has	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
424	http://opendata.aragon.es/def/iaest/medida#poblacion	81089	\N	69	poblacion	poblacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
425	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-son-titulares-de-mas-de-65-anos	1533	\N	69	personas-mano-obra-familiar-son-titulares-de-mas-de-65-anos	personas-mano-obra-familiar-son-titulares-de-mas-de-65-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
426	http://opendata.aragon.es/def/iaest/dimension#pension-percepciones-por-persona	36	\N	98	pension-percepciones-por-persona	pension-percepciones-por-persona	f	36	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
427	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-maquina-en-propiedad-motocultor	1533	\N	69	explotaciones-con-maquina-en-propiedad-motocultor	explotaciones-con-maquina-en-propiedad-motocultor	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
428	http://opendata.aragon.es/def/iaest/medida#autorizaciones-según-tipo	8352	\N	69	autorizaciones-según-tipo	autorizaciones-según-tipo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
429	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuyo-titular-es-una-entidad-publica	1533	\N	69	explotaciones-cuyo-titular-es-una-entidad-publica	explotaciones-cuyo-titular-es-una-entidad-publica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
430	http://opendata.aragon.es/def/iaest/medida#numero-de-contratos	1092634	\N	69	numero-de-contratos	numero-de-contratos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
431	http://icearagon.aragon.es/def/landscape#hasLayerName	35715	\N	79	hasLayerName	hasLayerName	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
432	http://opendata.aragon.es/def/iaest/medida#numero-de-viviendas	5683	\N	69	numero-de-viviendas	numero-de-viviendas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
433	http://opendata.aragon.es/def/iaest/medida#bi-industrial	10751	\N	69	bi-industrial	bi-industrial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
434	http://opendata.aragon.es/def/iaest/medida#visados-reforma	349	\N	69	visados-reforma	visados-reforma	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
435	http://opendata.aragon.es/def/iaest/medida#superficie-regada-con-concesion-individual	767	\N	69	superficie-regada-con-concesion-individual	superficie-regada-con-concesion-individual	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
436	http://icearagon.aragon.es/def/hydro#hasStrahler	76989	\N	84	hasStrahler	hasStrahler	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
437	http://opendata.aragon.es/def/iaest/medida#bi-almacen-estacionamiento	10751	\N	69	bi-almacen-estacionamiento	bi-almacen-estacionamiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
438	http://opendata.aragon.es/def/iaest/dimension#tipo-local	3902	\N	98	tipo-local	tipo-local	f	3902	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
439	http://opendata.aragon.es/def/iaest/medida#numero-de-cabezas	6343	\N	69	numero-de-cabezas	numero-de-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
440	http://schemas.opengis.net/geosparql/sfCrosses	2118	\N	110	sfCrosses	sfCrosses	f	2118	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
441	http://opendata.aragon.es/def/iaest/medida#personas-asalariadas-fijas-mujeres	1533	\N	69	personas-asalariadas-fijas-mujeres	personas-asalariadas-fijas-mujeres	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
442	http://opendata.aragon.es/def/iaest/medida#superficie-lugares-de-importacia-comunitaria	768	\N	69	superficie-lugares-de-importacia-comunitaria	superficie-lugares-de-importacia-comunitaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
443	http://opendata.aragon.es/def/Aragopedia#hasObservation	24157	\N	78	hasObservation	hasObservation	f	24157	\N	\N	f	f	63	104	\N	t	f	\N	\N	\N	t	f	f
444	http://www.w3.org/ns/org#subOrganizationOf	2603	\N	37	subOrganizationOf	subOrganizationOf	f	2603	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
445	http://opendata.aragon.es/def/iaest/medida#vc-religioso	6436	\N	69	vc-religioso	vc-religioso	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
446	http://www.w3.org/2015/03/inspire/ps#legalFoundationDate	25	\N	123	legalFoundationDate	legalFoundationDate	f	0	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
447	http://opendata.aragon.es/def/iaest/dimension#sector-actividad	16247	\N	98	sector-actividad	sector-actividad	f	16247	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
448	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/2	506	\N	124	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
449	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/3	506	\N	124	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
450	http://opendata.aragon.es/recurso/dimensionproperty/aulas-coronavirus-aragon-dimension/6	884	\N	125	6	6	f	884	\N	\N	f	f	\N	123	\N	t	f	\N	\N	\N	t	f	f
451	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/1	506	\N	124	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
452	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/6	506	\N	124	6	6	f	506	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
453	http://opendata.aragon.es/def/iaest/dimension#nucleos-en-el-hogar	2319	\N	98	nucleos-en-el-hogar	nucleos-en-el-hogar	f	2319	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
454	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/7	454	\N	124	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
455	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/4	201	\N	124	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
456	http://opendata.aragon.es/def/iaest/medida#area-gastos-deuda-publica	10876	\N	69	area-gastos-deuda-publica	area-gastos-deuda-publica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
457	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/5	506	\N	124	5	5	f	506	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
458	http://opendata.aragon.es/def/iaest/dimension#seccion-1-letra-descripcion	34274	\N	98	seccion-1-letra-descripcion	seccion-1-letra-descripcion	f	34274	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
459	http://opendata.aragon.es/def/ei2av2#isDefinedBy	10	\N	100	isDefinedBy	isDefinedBy	f	10	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
460	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-equido-dimension/8	128	\N	124	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
461	http://opendata.aragon.es/def/iaest/medida#bi-comercial	10751	\N	69	bi-comercial	bi-comercial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
462	http://opendata.aragon.es/def/iaest/medida#licencias-rehabilitacion-con-demolicion	6707	\N	69	licencias-rehabilitacion-con-demolicion	licencias-rehabilitacion-con-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
463	http://opendata.aragon.es/def/iaest/medida#viviendas-con-calefaccion	764	\N	69	viviendas-con-calefaccion	viviendas-con-calefaccion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
464	http://opendata.aragon.es/def/iaest/dimension#orden	765	\N	98	orden	orden	f	765	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
465	http://opendata.aragon.es/recurso/dimensionproperty/aulas-coronavirus-aragon-dimension/5	818	\N	125	5	5	f	818	\N	\N	f	f	\N	37	\N	t	f	\N	\N	\N	t	f	f
466	http://opendata.aragon.es/recurso/dimensionproperty/aulas-coronavirus-aragon-dimension/2	884	\N	125	2	2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
467	http://opendata.aragon.es/recurso/dimensionproperty/aulas-coronavirus-aragon-dimension/1	883	\N	125	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
468	http://opendata.aragon.es/def/iaest/medida#n-personas	52225	\N	69	n-personas	n-personas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
469	http://opendata.aragon.es/def/iaest/medida#area-gastos-actuaciones-proteccion-y-promocion-social	10876	\N	69	area-gastos-actuaciones-proteccion-y-promocion-social	area-gastos-actuaciones-proteccion-y-promocion-social	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
470	http://opendata.aragon.es/def/Aragopedia#menPopulation	768	\N	78	menPopulation	menPopulation	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
471	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-7499-y-100porcentaje-trabajando-en-explotacion	1533	\N	69	personas-mano-obra-familiar-con-7499-y-100porcentaje-trabajando-en-explotacion	personas-mano-obra-familiar-con-7499-y-100porcentaje-trabajando-en-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
472	http://www.w3.org/2002/07/owl#propertyDisjointWith	1	\N	7	propertyDisjointWith	propertyDisjointWith	f	1	\N	\N	f	f	125	125	\N	t	f	\N	\N	\N	t	f	f
473	http://icearagon.aragon.es/def/ps#hasCtipfigura	25	\N	91	hasCtipfigura	hasCtipfigura	f	25	\N	\N	f	f	87	57	\N	t	f	\N	\N	\N	t	f	f
474	http://www.w3.org/2001/vcard-rdf/3.0#Street	2	\N	96	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
475	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-asalariados	767	\N	69	unidades-trabajo-ano-asalariados	unidades-trabajo-ano-asalariados	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
476	http://www.wikidata.org/prop/direct/P20	3670	\N	13	P20	P20	f	1071	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
477	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajoano-totales	1533	\N	69	unidades-de-trabajoano-totales	unidades-de-trabajoano-totales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
478	http://opendata.aragon.es/def/iaest/dimension#ascensor	317	\N	98	ascensor	ascensor	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
479	http://spdx.org/rdf/terms#checksum	478	\N	126	checksum	checksum	f	478	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
480	http://opendata.aragon.es/def/iaest/dimension#descripcion-ocupacion	10663	\N	98	descripcion-ocupacion	descripcion-ocupacion	f	10663	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
481	http://opendata.aragon.es/def/iaest/dimension#rama-descripcion	726	\N	98	rama-descripcion	rama-descripcion	f	726	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
482	http://www.w3.org/2001/vcard-rdf/3.0#ADR	2	\N	96	ADR	ADR	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
483	http://data.europa.eu/eli/ontology#rightsholder_agent	7452	\N	87	rightsholder_agent	rightsholder_agent	f	7452	\N	\N	f	f	61	62	\N	t	f	\N	\N	\N	t	f	f
484	http://opendata.aragon.es/def/iaest/medida#viviendas-ampliacion-o-reforma	349	\N	69	viviendas-ampliacion-o-reforma	viviendas-ampliacion-o-reforma	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
485	http://www.wikidata.org/prop/direct/P18	4248	\N	13	P18	P18	f	4248	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
486	http://opendata.aragon.es/def/iaest/medida#vc-sanidad-benefic	9352	\N	69	vc-sanidad-benefic	vc-sanidad-benefic	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
487	http://www.wikidata.org/prop/direct/P19	4383	\N	13	P19	P19	f	1733	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
488	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	58	58	\N	t	f	\N	\N	\N	t	f	f
489	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-hospitales-medida/4	6154	\N	127	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
490	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-hospitales-medida/3	12771	\N	127	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
491	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	\N	\N	f	f	113	147	\N	t	f	\N	\N	\N	t	f	f
492	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/8	5616	\N	128	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
493	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano-otros-cultivos	1533	\N	69	hectareas-en-tierras-labradas-de-secano-otros-cultivos	hectareas-en-tierras-labradas-de-secano-otros-cultivos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
494	http://opendata.aragon.es/def/iaest/medida#numero-total-de-explotaciones	12265	\N	69	numero-total-de-explotaciones	numero-total-de-explotaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
495	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/6	7859	\N	128	6	6	f	7859	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
496	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/7	1	\N	128	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
497	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/4	5926	\N	128	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
498	http://opendata.aragon.es/def/iaest/medida#vc-espectaculos	9955	\N	69	vc-espectaculos	vc-espectaculos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
499	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/5	7825	\N	128	5	5	f	7825	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
500	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-secundaria	1533	\N	69	personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-secundaria	personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-secundaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
501	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/2	7860	\N	128	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
502	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/3	7860	\N	128	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
503	http://opendata.aragon.es/def/iaest/medida#diputados	807	\N	69	diputados	diputados	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
504	http://opendata.aragon.es/def/Aragopedia#hectareasEscombrerasVertederos	725	\N	78	hectareasEscombrerasVertederos	hectareasEscombrerasVertederos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
505	http://opendata.aragon.es/def/iaest/medida#vc-sin-definir	13052	\N	69	vc-sin-definir	vc-sin-definir	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
506	http://opendata.aragon.es/def/iaest/medida#explotaciones-ganaderia	6487	\N	69	explotaciones-ganaderia	explotaciones-ganaderia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
507	http://opendata.aragon.es/def/iaest/medida#edificios-demolicion	6519	\N	69	edificios-demolicion	edificios-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
508	http://opendata.aragon.es/def/iaest/medida#bancos	6908	\N	69	bancos	bancos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
509	http://opendata.aragon.es/def/iaest/medida#centros-escolares	6302	\N	69	centros-escolares	centros-escolares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
510	http://opendata.aragon.es/def/iaest/medida#1950-1959	768	\N	69	1950-1959	1950-1959	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
511	http://www.w3.org/2004/02/skos/core#hasTopConcept	18895	\N	4	hasTopConcept	hasTopConcept	f	18895	\N	\N	f	f	\N	59	\N	t	f	\N	\N	\N	t	f	f
512	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-totales	767	\N	69	unidades-trabajo-ano-totales	unidades-trabajo-ano-totales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
513	http://schema.org/name	12	\N	9	name	name	f	0	\N	\N	f	f	134	\N	\N	t	f	\N	\N	\N	t	f	f
514	http://www.w3.org/2006/vcard/ns#note	397	\N	39	note	note	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
515	http://www.w3.org/2006/vcard/ns#Fax	10	\N	39	Fax	Fax	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
516	http://www.openlinksw.com/schemas/VSPX#pageId	1	\N	81	pageId	pageId	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
517	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-ovino-dimension/1	7860	\N	128	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
518	http://opendata.aragon.es/def/iaest/medida#ganado-ovino-cabezas	1533	\N	69	ganado-ovino-cabezas	ganado-ovino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
519	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-labranza-y-pastos	1533	\N	69	explotaciones-con-tierras-labranza-y-pastos	explotaciones-con-tierras-labranza-y-pastos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
520	http://opendata.aragon.es/def/iaest/medida#superficie-total-agricultura-ecologica	8448	\N	69	superficie-total-agricultura-ecologica	superficie-total-agricultura-ecologica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
521	http://www.w3.org/ns/prov#wasUsedBy	11261515	\N	26	wasUsedBy	wasUsedBy	f	11261515	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
522	http://opendata.aragon.es/def/iaest/medida#bi-deportivo	10751	\N	69	bi-deportivo	bi-deportivo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
523	http://icearagon.aragon.es/def/health#hasClaseInstalacionSanitaria	6495	\N	88	hasClaseInstalacionSanitaria	hasClaseInstalacionSanitaria	f	6495	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
524	http://spdx.org/rdf/terms#checksumValue	274232	\N	126	checksumValue	checksumValue	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
525	http://opendata.aragon.es/def/iaest/dimension#rama-de-actividad	13185	\N	98	rama-de-actividad	rama-de-actividad	f	13185	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
526	http://www.w3.org/2006/vcard/ns#fax	2350	\N	39	fax	fax	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
527	http://opendata.aragon.es/def/iaest/medida#ganado-porcino-resto-porcino-cabezas	1533	\N	69	ganado-porcino-resto-porcino-cabezas	ganado-porcino-resto-porcino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
528	http://crossforest.eu/ifi/ontology/hasDominantFormation	67	\N	82	hasDominantFormation	hasDominantFormation	f	67	\N	\N	f	f	15	194	\N	t	f	\N	\N	\N	t	f	f
529	http://data.europa.eu/eli/ontology#language	7452	\N	87	language	language	f	7452	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
530	http://icearagon.aragon.es/def/health#CodigoAutonomicoAutorizacion	6495	\N	88	CodigoAutonomicoAutorizacion	CodigoAutonomicoAutorizacion	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
531	http://opendata.aragon.es/def/iaest/medida#cuota-euros	1536	\N	69	cuota-euros	cuota-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
532	http://opendata.aragon.es/def/iaest/medida#activos-financieros	36476	\N	69	activos-financieros	activos-financieros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
533	http://data.europa.eu/eli/ontology#is_about	7452	\N	87	is_about	is_about	f	7452	\N	\N	f	f	60	59	\N	t	f	\N	\N	\N	t	f	f
534	http://opendata.aragon.es/def/iaest/medida#vc-oficinas	9508	\N	69	vc-oficinas	vc-oficinas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
535	http://opendata.aragon.es/def/iaest/medida#urbano-valor-catastral-total	10751	\N	69	urbano-valor-catastral-total	urbano-valor-catastral-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
536	http://opendata.aragon.es/def/iaest/dimension#rama	22	\N	98	rama	rama	f	22	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
537	http://opendata.aragon.es/def/iaest/dimension#relacion-lugar-de-residencia-y-nacimiento-prov	7241	\N	98	relacion-lugar-de-residencia-y-nacimiento-prov	relacion-lugar-de-residencia-y-nacimiento-prov	f	7241	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
538	http://www.w3.org/2000/01/rdf-schema#subClassOf	964	\N	2	subClassOf	subClassOf	f	964	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
539	http://opendata.aragon.es/def/iaest/dimension#malas-comunicaciones	128	\N	98	malas-comunicaciones	malas-comunicaciones	f	128	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
540	http://opendata.aragon.es/def/iaest/medida#pension-retribucion	8598	\N	69	pension-retribucion	pension-retribucion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
541	http://opendata.aragon.es/def/iaest/medida#superficie-regada-por-gravedad	1533	\N	69	superficie-regada-por-gravedad	superficie-regada-por-gravedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
542	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuges-que-trabajan-tambien-en-otra-activ-lucrativa	1533	\N	69	personas-mano-obra-familiar-conyuges-que-trabajan-tambien-en-otra-activ-lucrativa	personas-mano-obra-familiar-conyuges-que-trabajan-tambien-en-otra-activ-lucrativa	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
543	http://icearagon.aragon.es/def/landscape#hasLayerId	35715	\N	79	hasLayerId	hasLayerId	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
544	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-con-cultivos-herbaceos	1533	\N	69	hectareas-en-tierras-labradas-con-cultivos-herbaceos	hectareas-en-tierras-labradas-con-cultivos-herbaceos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
545	http://purl.org/dc/elements/1.1/hasPart	141	\N	6	hasPart	hasPart	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
546	http://opendata.aragon.es/def/Aragopedia#hectareasConiferas	725	\N	78	hectareasConiferas	hectareasConiferas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
547	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-otros-diferentes	1533	\N	69	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-otros-diferentes	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-otros-diferentes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
548	http://opendata.aragon.es/def/iaest/dimension#regtenen-orden	2718	\N	98	regtenen-orden	regtenen-orden	f	2718	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
549	http://opendata.aragon.es/recurso/measureproperty/aulas-coronavirus-aragon-medida/7	883	\N	129	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
550	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-con-cultivo-vinedo	1533	\N	69	hectareas-en-tierras-labradas-con-cultivo-vinedo	hectareas-en-tierras-labradas-con-cultivo-vinedo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
551	http://opendata.aragon.es/recurso/measureproperty/aulas-coronavirus-aragon-medida/4	883	\N	129	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
552	http://opendata.aragon.es/def/iaest/dimension#area-nacionalidad-nombre	2307	\N	98	area-nacionalidad-nombre	area-nacionalidad-nombre	f	2307	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
553	http://opendata.aragon.es/def/iaest/dimension#combustible	3101	\N	98	combustible	combustible	f	3101	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
554	http://opendata.aragon.es/def/iaest/medida#indice-estructura-de-poblacion-activa-total	35260	\N	69	indice-estructura-de-poblacion-activa-total	indice-estructura-de-poblacion-activa-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
555	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar	6132	\N	69	personas-que-son-mano-de-obra-familiar	personas-que-son-mano-de-obra-familiar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
556	http://opendata.aragon.es/def/iaest/medida#total-bienes-inmuebles	17	\N	69	total-bienes-inmuebles	total-bienes-inmuebles	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
557	http://opendata.aragon.es/def/iaest/medida#superficie-nueva-planta-no-residencial	6729	\N	69	superficie-nueva-planta-no-residencial	superficie-nueva-planta-no-residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
558	http://www.w3.org/2001/vcard-rdf/3.0#Country	2	\N	96	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
559	http://opendata.aragon.es/def/iaest/medida#rustico-superficie	42419	\N	69	rustico-superficie	rustico-superficie	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
560	http://opendata.aragon.es/def/iaest/medida#bi-ocio-hosteleria	10751	\N	69	bi-ocio-hosteleria	bi-ocio-hosteleria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
561	http://opendata.aragon.es/def/Aragopedia#consumoGasoleoOtros	10	\N	78	consumoGasoleoOtros	consumoGasoleoOtros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
562	http://opendata.aragon.es/def/iaest/dimension#corine-land-cover-2000-nivel-5-descripcion	49088	\N	98	corine-land-cover-2000-nivel-5-descripcion	corine-land-cover-2000-nivel-5-descripcion	f	49088	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
563	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/7	175	\N	130	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
564	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/8	165	\N	130	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
565	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/5	206	\N	130	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
566	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/6	172	\N	130	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
567	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/10	2412	\N	131	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
568	https://www.geonames.org/ontology#SpatialThing	39133	\N	132	SpatialThing	SpatialThing	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
569	http://schema.org/version	257827	\N	9	version	version	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
570	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/9	12	\N	130	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
571	http://www.w3.org/ns/sosa/hasResult	8740	\N	94	hasResult	hasResult	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
572	http://opendata.aragon.es/def/iaest/dimension#codmun	64465	\N	98	codmun	codmun	f	64465	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1044	http://icearagon.aragon.es/def/ps#hasCestado	25	\N	91	hasCestado	hasCestado	f	25	\N	\N	f	f	87	57	\N	t	f	\N	\N	\N	t	f	f
573	http://icearagon.aragon.es/def/health#hasDependenciaFuncional	6495	\N	88	hasDependenciaFuncional	hasDependenciaFuncional	f	6495	\N	\N	f	f	\N	57	\N	t	f	\N	\N	\N	t	f	f
574	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/16	433	\N	133	16	16	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
575	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/17	433	\N	133	17	17	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
576	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/14	98	\N	133	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
577	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/15	35	\N	133	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
578	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/12	70	\N	133	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
579	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/13	30	\N	133	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
580	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/10	329	\N	133	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
581	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/11	1100	\N	133	11	11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
582	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
583	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-motocultor	1533	\N	69	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-motocultor	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-motocultor	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
584	http://opendata.aragon.es/def/iaest/medida#hectareas-en-especies-arboreas-forestales	1533	\N	69	hectareas-en-especies-arboreas-forestales	hectareas-en-especies-arboreas-forestales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
585	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
586	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
587	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
588	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
589	http://opendata.aragon.es/def/iaest/dimension#area-nacionalidad	993	\N	98	area-nacionalidad	area-nacionalidad	f	993	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
590	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
591	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/18	326	\N	133	18	18	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
592	http://www.w3.org/2001/vcard-rdf/3.0#TEL	2	\N	96	TEL	TEL	f	2	\N	\N	f	f	\N	172	\N	t	f	\N	\N	\N	t	f	f
593	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/19	187	\N	133	19	19	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
594	http://purl.org/vocab/vann/preferredNamespacePrefix	7	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
595	http://icearagon.aragon.es/def/core#hasQr	24	\N	83	hasQr	hasQr	f	24	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
596	http://opendata.aragon.es/def/iaest/dimension#diputados	324	\N	98	diputados	diputados	f	324	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
597	http://opendata.aragon.es/def/iaest/dimension#sector-vab-descripcion	17706	\N	98	sector-vab-descripcion	sector-vab-descripcion	f	17706	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
598	http://opendata.aragon.es/def/Aragopedia#hectareasBosquesMixtos	725	\N	78	hectareasBosquesMixtos	hectareasBosquesMixtos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
599	http://www.w3.org/2003/01/geo/wgs84_pos#lat	4281	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
600	http://www.w3.org/ns/dcat#byteSize	8	\N	15	byteSize	byteSize	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
641	http://xmlns.com/foaf/0.1/gender	2680	\N	8	gender	gender	f	0	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
601	http://opendata.aragon.es/def/iaest/dimension#subespecie-ganaderia-descripcion	6360	\N	98	subespecie-ganaderia-descripcion	subespecie-ganaderia-descripcion	f	6360	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
602	http://opendata.aragon.es/def/Aragopedia#hectareasZonasMineras	725	\N	78	hectareasZonasMineras	hectareasZonasMineras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
603	http://opendata.aragon.es/def/Aragopedia#numPlazas	3068	\N	78	numPlazas	numPlazas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
604	http://opendata.aragon.es/def/iaest/medida#numero-de-actividades	13185	\N	69	numero-de-actividades	numero-de-actividades	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
605	http://opendata.aragon.es/recurso/dimensionproperty/datos-vacunas-dimension/1	427	\N	134	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
606	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuge-35-anos	1533	\N	69	personas-mano-obra-familiar-conyuge-35-anos	personas-mano-obra-familiar-conyuge-35-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
607	http://icearagon.aragon.es/def/bca#hasTitular	1	\N	89	hasTitular	hasTitular	f	1	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
608	http://icearagon.aragon.es/def/education#hasZonaBachillerato	19	\N	93	hasZonaBachillerato	hasZonaBachillerato	f	0	\N	\N	f	f	163	\N	\N	t	f	\N	\N	\N	t	f	f
609	http://opendata.aragon.es/def/iaest/medida#superficie-calificada-primer-ano-practicas	8448	\N	69	superficie-calificada-primer-ano-practicas	superficie-calificada-primer-ano-practicas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
610	http://data.europa.eu/eli/ontology#licence	7452	\N	87	licence	licence	f	7452	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
611	http://opendata.aragon.es/def/iaest/medida#pension-perceptores	48	\N	69	pension-perceptores	pension-perceptores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
612	http://opendata.aragon.es/def/iaest/medida#superficie-certificaciones-privadas	8448	\N	69	superficie-certificaciones-privadas	superficie-certificaciones-privadas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
613	http://opendata.aragon.es/def/iaest/medida#viviendas-nuevas	9214	\N	69	viviendas-nuevas	viviendas-nuevas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
614	http://icearagon.aragon.es/def/core#hasObjectId	94249	\N	83	hasObjectId	hasObjectId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
615	http://opendata.aragon.es/def/iaest/medida#indice-de-ancianidad	35283	\N	69	indice-de-ancianidad	indice-de-ancianidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
616	http://opendata.aragon.es/def/iaest/dimension#grado	7027	\N	98	grado	grado	f	7027	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
617	http://opendata.aragon.es/def/iaest/dimension#sector-actividad-descripcion	5296	\N	98	sector-actividad-descripcion	sector-actividad-descripcion	f	5296	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
618	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-que-solo-trabajan-en-la-explotacion	1533	\N	69	personas-mano-obra-familiar-otros-que-solo-trabajan-en-la-explotacion	personas-mano-obra-familiar-otros-que-solo-trabajan-en-la-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
619	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-2499-y-50porcentaje-trabajando-en-explotacion	1533	\N	69	personas-mano-obra-familiar-con-2499-y-50porcentaje-trabajando-en-explotacion	personas-mano-obra-familiar-con-2499-y-50porcentaje-trabajando-en-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
620	http://opendata.aragon.es/def/iaest/medida#indice-de-vejez	31563	\N	69	indice-de-vejez	indice-de-vejez	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
621	http://www.w3.org/2006/vcard/ns#postal-code	11910	\N	39	postal-code	postal-code	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
622	http://opendata.aragon.es/def/iaest/dimension#estudios-en-curso	1492	\N	98	estudios-en-curso	estudios-en-curso	f	1492	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
623	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-labranza-pastos-y-otras	1533	\N	69	explotaciones-con-tierras-labranza-pastos-y-otras	explotaciones-con-tierras-labranza-pastos-y-otras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
624	http://opendata.aragon.es/def/iaest/medida#ccaa-2-residencia-nombre	2715	\N	69	ccaa-2-residencia-nombre	ccaa-2-residencia-nombre	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
625	http://opendata.aragon.es/def/iaest/dimension#nivel-estudios	5446	\N	98	nivel-estudios	nivel-estudios	f	5446	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
626	http://opendata.aragon.es/def/iaest/dimension#codcom	14982	\N	98	codcom	codcom	f	14982	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
627	http://crossforest.eu/ifi/ontology/hasBasalAreaInM2ByHa	67	\N	82	hasBasalAreaInM2ByHa	hasBasalAreaInM2ByHa	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
628	http://opendata.aragon.es/def/iaest/medida#ganado-bovino-cabezas	1533	\N	69	ganado-bovino-cabezas	ganado-bovino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
629	http://opendata.aragon.es/def/iaest/medida#superficie-regada-por-otros-metodos	1533	\N	69	superficie-regada-por-otros-metodos	superficie-regada-por-otros-metodos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
631	http://opendata.aragon.es/def/iaest/dimension#tipo-nacionalidad	2307	\N	98	tipo-nacionalidad	tipo-nacionalidad	f	2307	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
632	http://opendata.aragon.es/def/iaest/dimension#nivel-estudios-agregado	13762	\N	98	nivel-estudios-agregado	nivel-estudios-agregado	f	13762	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
633	http://www.w3.org/ns/dcat#keyword	17518	\N	15	keyword	keyword	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
634	http://opendata.aragon.es/def/iaest/medida#bi-sin-definir	13052	\N	69	bi-sin-definir	bi-sin-definir	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
635	http://www.w3.org/ns/org#linkedTo	46466	\N	37	linkedTo	linkedTo	f	46466	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
636	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/20	27	\N	133	20	20	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
637	http://opendata.aragon.es/def/iaest/medida#ganado-bovino-resto-bovino-cabezas	1533	\N	69	ganado-bovino-resto-bovino-cabezas	ganado-bovino-resto-bovino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
638	http://opendata.aragon.es/def/iaest/dimension#estado-del-edificio	2601	\N	98	estado-del-edificio	estado-del-edificio	f	2601	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
639	http://opendata.aragon.es/def/iaest/medida#licencias-nueva-planta-con-demolicion	6446	\N	69	licencias-nueva-planta-con-demolicion	licencias-nueva-planta-con-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
640	http://opendata.aragon.es/def/iaest/medida#impuestos-directos	18238	\N	69	impuestos-directos	impuestos-directos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
642	http://schema.org/description	1550	\N	9	description	description	f	0	\N	\N	f	f	134	\N	\N	t	f	\N	\N	\N	t	f	f
643	http://opendata.aragon.es/def/Aragopedia#hectareasLaminasAgua	725	\N	78	hectareasLaminasAgua	hectareasLaminasAgua	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
644	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/21	195	\N	133	21	21	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
645	http://opendata.aragon.es/def/iaest/medida#vc-edificios-singulares	7242	\N	69	vc-edificios-singulares	vc-edificios-singulares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
646	http://opendata.aragon.es/def/iaest/dimension#tipo-de-hogar-2	2126	\N	98	tipo-de-hogar-2	tipo-de-hogar-2	f	2126	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
647	http://opendata.aragon.es/def/iaest/dimension#edad-grandes-grupos	588470	\N	98	edad-grandes-grupos	edad-grandes-grupos	f	588470	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
648	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio-cultivo-vinedo	1533	\N	69	hectareas-en-tierras-labradas-de-regadio-cultivo-vinedo	hectareas-en-tierras-labradas-de-regadio-cultivo-vinedo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
649	http://opendata.aragon.es/def/iaest/dimension#clase-de-propietario	1408	\N	98	clase-de-propietario	clase-de-propietario	f	1408	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
650	http://icearagon.aragon.es/def/landscape#hasFeatureFragilidadDelPaisaje	3851	\N	79	hasFeatureFragilidadDelPaisaje	hasFeatureFragilidadDelPaisaje	f	3851	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
691	http://opendata.aragon.es/def/iaest/dimension#nacionalidad-pais-nombre	191670	\N	98	nacionalidad-pais-nombre	nacionalidad-pais-nombre	f	191670	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
630	http://opendata.aragon.es/def/iaest/dimension#ue25-ue27-ue28	100565	\N	98	[UE25-UE27-UE28 (ue25-ue27-ue28)]	ue25-ue27-ue28	f	100565	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
651	http://opendata.aragon.es/def/iaest/medida#edificios-nueva-planta-no-residencial	6729	\N	69	edificios-nueva-planta-no-residencial	edificios-nueva-planta-no-residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
652	http://opendata.aragon.es/def/iaest/dimension#continente	2538	\N	98	continente	continente	f	2538	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
653	http://opendata.aragon.es/def/iaest/medida#licencias-nueva-planta-total	7017	\N	69	licencias-nueva-planta-total	licencias-nueva-planta-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
654	http://opendata.aragon.es/def/iaest/dimension#viviendas-en-el-edificio	6454	\N	98	viviendas-en-el-edificio	viviendas-en-el-edificio	f	6454	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
655	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio-otros-cultivos	1533	\N	69	hectareas-en-tierras-labradas-de-regadio-otros-cultivos	hectareas-en-tierras-labradas-de-regadio-otros-cultivos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
656	http://opendata.aragon.es/def/iaest/dimension#tipo-vivienda	1	\N	98	tipo-vivienda	tipo-vivienda	f	1	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
657	http://opendata.aragon.es/def/Aragopedia#hectareasTejUrbanoDiscontinuo	725	\N	78	hectareasTejUrbanoDiscontinuo	hectareasTejUrbanoDiscontinuo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
658	http://opendata.aragon.es/def/iaest/medida#gastos-en-bienes-corrientes-y-servicios	18238	\N	69	gastos-en-bienes-corrientes-y-servicios	gastos-en-bienes-corrientes-y-servicios	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
659	http://opendata.aragon.es/def/iaest/medida#total	42311	\N	69	total	total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
660	http://opendata.aragon.es/def/iaest/dimension#tipo-licencias-descripcion	2183	\N	98	tipo-licencias-descripcion	tipo-licencias-descripcion	f	2183	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
661	http://opendata.aragon.es/def/iaest/dimension#cif	48747	\N	98	cif	cif	f	48747	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
662	http://opendata.aragon.es/def/iaest/dimension#numero-de-personas-en-el-hogar	5270	\N	98	numero-de-personas-en-el-hogar	numero-de-personas-en-el-hogar	f	5270	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
663	http://opendata.aragon.es/def/iaest/dimension#situacion-preferente	15690	\N	98	situacion-preferente	situacion-preferente	f	15690	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
665	http://opendata.aragon.es/def/iaest/dimension#tipo-estudios	2909	\N	98	tipo-estudios	tipo-estudios	f	2909	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
666	http://opendata.aragon.es/def/iaest/dimension#poca-limpieza	128	\N	98	poca-limpieza	poca-limpieza	f	128	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
667	http://icearagon.aragon.es/def/core#hasEsquemaDistribucion	110	\N	83	hasEsquemaDistribucion	hasEsquemaDistribucion	f	110	\N	\N	f	f	204	57	\N	t	f	\N	\N	\N	t	f	f
668	http://opendata.aragon.es/def/iaest/dimension#tipo-de-vivienda	2315	\N	98	tipo-de-vivienda	tipo-de-vivienda	f	2315	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
669	http://opendata.aragon.es/def/iaest/medida#otras-maquinas	1533	\N	69	otras-maquinas	otras-maquinas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
670	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	554	\N	2	subPropertyOf	subPropertyOf	f	554	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
671	http://www.w3.org/2004/02/skos/core#broadMatch	689	\N	4	broadMatch	broadMatch	f	689	\N	\N	f	f	59	59	\N	t	f	\N	\N	\N	t	f	f
672	http://opendata.aragon.es/def/iaest/medida#duracion-contrato--100--numero-de-contratos	292971	\N	69	duracion-contrato--100--numero-de-contratos	duracion-contrato--100--numero-de-contratos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
673	http://www.w3.org/2004/02/skos/core#notation	19743	\N	4	notation	notation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
674	http://opendata.aragon.es/def/iaest/medida#licencias-demolicion	6417	\N	69	licencias-demolicion	licencias-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
675	http://opendata.aragon.es/def/iaest/medida#rustico-subparcelas	14583	\N	69	rustico-subparcelas	rustico-subparcelas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
676	http://opendata.aragon.es/def/iaest/dimension#estado-de-la-informacion	56044	\N	98	estado-de-la-informacion	estado-de-la-informacion	f	56044	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
677	http://www.w3.org/2000/01/rdf-schema#value	908299	\N	2	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
678	http://purl.org/linked-data/sdmx/2009/dimension#refPeriod	5215074	\N	73	refPeriod	refPeriod	f	5215074	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
679	http://opendata.aragon.es/def/iaest/medida#siglas-agrupada	125	\N	69	siglas-agrupada	siglas-agrupada	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
680	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/8	592	\N	135	8	8	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
681	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/6	495	\N	135	6	6	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
682	http://opendata.aragon.es/def/Aragopedia#numEstablecimientos	3068	\N	78	numEstablecimientos	numEstablecimientos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
683	http://opendata.aragon.es/def/ei2av2#legislature	420	\N	100	legislature	legislature	f	420	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
684	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/7	446	\N	135	7	7	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
685	http://data.tbfy.eu/ontology/ocds#id	3460	\N	86	id	id	f	0	\N	\N	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
686	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuyo-titular-es-una-sociedad	1533	\N	69	explotaciones-cuyo-titular-es-una-sociedad	explotaciones-cuyo-titular-es-una-sociedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
687	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/4	592	\N	135	4	4	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
688	http://opendata.aragon.es/def/Aragopedia#hectareasTejUrbanoContinuo	725	\N	78	hectareasTejUrbanoContinuo	hectareasTejUrbanoContinuo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
689	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/5	591	\N	135	5	5	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
690	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-provincia-medida/3	593	\N	135	3	3	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
692	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva	1533	\N	69	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
693	http://schema.org/expires	333	\N	9	expires	expires	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
694	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-25porcentaje-trabajando-en-explotacion	1533	\N	69	personas-mano-obra-familiar-con-25porcentaje-trabajando-en-explotacion	personas-mano-obra-familiar-con-25porcentaje-trabajando-en-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
695	http://opendata.aragon.es/def/iaest/medida#afiliaciones-en-alta	612663	\N	69	afiliaciones-en-alta	afiliaciones-en-alta	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
696	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio-cultivos-herbaceos	1533	\N	69	hectareas-en-tierras-labradas-de-regadio-cultivos-herbaceos	hectareas-en-tierras-labradas-de-regadio-cultivos-herbaceos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
697	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau--50-y--100-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau--50-y--100-hectareas	explotaciones-con-tierras-con-sau--50-y--100-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
698	http://purl.org/dc/elements/1.1/title	36170	\N	6	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
699	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	2	\N	96	EMAIL	EMAIL	f	2	\N	\N	f	f	\N	143	\N	t	f	\N	\N	\N	t	f	f
700	http://opendata.aragon.es/def/iaest/medida#superficie-has	104752	\N	69	superficie-has	superficie-has	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
701	http://opendata.aragon.es/def/iaest/dimension#jefe-explotacion	5035	\N	98	jefe-explotacion	jefe-explotacion	f	5035	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
702	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/2	4328	\N	136	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
703	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-son-titulares-de-35-a-54-anos	1533	\N	69	personas-mano-obra-familiar-son-titulares-de-35-a-54-anos	personas-mano-obra-familiar-son-titulares-de-35-a-54-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
704	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-ovino-medida/12	7570	\N	137	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
705	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-ovino-medida/11	23	\N	137	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
706	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/3	4324	\N	136	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
707	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/4	3573	\N	136	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
708	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/5	4298	\N	136	5	5	f	4298	\N	\N	f	f	\N	37	\N	t	f	\N	\N	\N	t	f	f
709	http://opendata.aragon.es/def/iaest/medida#gastos-financieros	18238	\N	69	gastos-financieros	gastos-financieros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
710	http://opendata.aragon.es/def/iaest/medida#salario-medio-anual	12	\N	69	salario-medio-anual	salario-medio-anual	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
711	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-ovino-medida/10	27	\N	137	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
712	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/1	4324	\N	136	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
713	http://opendata.aragon.es/def/iaest/dimension#sector	13185	\N	98	sector	sector	f	13185	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
714	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	124	\N	\N	t	f	\N	\N	\N	t	f	f
715	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/6	4323	\N	136	6	6	f	4323	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
716	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-bovino-dimension/7	3149	\N	136	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
717	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-sin-sau	3066	\N	69	explotaciones-con-tierras-sin-sau	explotaciones-con-tierras-sin-sau	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
718	http://opendata.aragon.es/def/iaest/dimension#clasificacion	25329	\N	98	clasificacion	clasificacion	f	25329	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
719	http://www.w3.org/2006/vcard/ns#region	756	\N	39	region	region	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
720	http://opendata.aragon.es/def/Aragopedia#areaTotal	730	\N	78	areaTotal	areaTotal	f	0	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
721	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	28	113	\N	t	f	\N	\N	\N	t	f	f
722	http://opendata.aragon.es/def/iaest/medida#total-gastos	18238	\N	69	total-gastos	total-gastos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
723	http://icearagon.aragon.es/def/landscape#hasObjectId	36900	\N	79	hasObjectId	hasObjectId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
724	http://opendata.aragon.es/def/iaest/medida#area-gastos-actuaciones-caracter-general	10876	\N	69	area-gastos-actuaciones-caracter-general	area-gastos-actuaciones-caracter-general	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
725	http://opendata.aragon.es/def/iaest/medida#area-gastos-servicios-publicos-basicos	10876	\N	69	area-gastos-servicios-publicos-basicos	area-gastos-servicios-publicos-basicos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
726	http://opendata.aragon.es/def/Aragopedia#hectareasTurberas	725	\N	78	hectareasTurberas	hectareasTurberas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
727	http://opendata.aragon.es/def/iaest/medida#especie-ganaderia	6487	\N	69	especie-ganaderia	especie-ganaderia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
728	http://opendata.aragon.es/def/iaest/medida#bi-espectaculos	10751	\N	69	bi-espectaculos	bi-espectaculos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
729	http://www.w3.org/ns/dcat#accessURL	2888	\N	15	accessURL	accessURL	f	2888	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
730	http://opendata.aragon.es/def/Aragopedia#contieneMunicipio	1461	\N	78	contieneMunicipio	contieneMunicipio	f	1461	\N	\N	f	f	63	64	\N	t	f	\N	\N	\N	t	f	f
731	http://opendata.aragon.es/def/iaest/medida#cantidad	6070	\N	69	cantidad	cantidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
732	http://opendata.aragon.es/def/iaest/medida#superficie-total	10771	\N	69	superficie-total	superficie-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
733	http://opendata.aragon.es/def/iaest/dimension#sexo	3369949	\N	98	sexo	sexo	f	3369949	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
734	http://opendata.aragon.es/def/iaest/medida#saldo-migratorio	9860	\N	69	saldo-migratorio	saldo-migratorio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
735	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
736	http://opendata.aragon.es/def/iaest/medida#personas-jefes-de-explotacion	1533	\N	69	personas-jefes-de-explotacion	personas-jefes-de-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
738	http://opendata.aragon.es/def/iaest/dimension#ue28	161302	\N	98	ue28	ue28	f	161302	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
739	http://opendata.aragon.es/def/iaest/dimension#ue27	157828	\N	98	ue27	ue27	f	157828	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
740	http://opendata.aragon.es/def/iaest/dimension#horas-trabajadas	786	\N	98	horas-trabajadas	horas-trabajadas	f	786	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
741	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-solo-otras-tierras	1533	\N	69	explotaciones-con-solo-otras-tierras	explotaciones-con-solo-otras-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
742	http://opendata.aragon.es/def/iaest/medida#viviendas-obra-nueva-otros	349	\N	69	viviendas-obra-nueva-otros	viviendas-obra-nueva-otros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
743	http://opendata.aragon.es/def/iaest/dimension#cnae-ano	8945	\N	98	cnae-ano	cnae-ano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
744	http://purl.org/dc/elements/1.1/subject	2962	\N	6	subject	subject	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
745	http://opendata.aragon.es/def/iaest/dimension#ano-de-construccion	34011	\N	98	ano-de-construccion	ano-de-construccion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
746	http://www.w3.org/ns/sosa/phenomenonTime	85	\N	94	phenomenonTime	phenomenonTime	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
747	http://opendata.aragon.es/def/iaest/medida#superficie-forestal-afectada	20	\N	69	superficie-forestal-afectada	superficie-forestal-afectada	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
748	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano-cultivos-herbaceos	1533	\N	69	hectareas-en-tierras-labradas-de-secano-cultivos-herbaceos	hectareas-en-tierras-labradas-de-secano-cultivos-herbaceos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
749	http://opendata.aragon.es/def/iaest/medida#n-edificios	14234	\N	69	n-edificios	n-edificios	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
750	http://icearagon.aragon.es/def/transport#hasSpeedLimitInKm_per_hour	4414	\N	85	hasSpeedLimitInKm_per_hour	hasSpeedLimitInKm_per_hour	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
751	http://opendata.aragon.es/def/iaest/medida#1970-1979	768	\N	69	1970-1979	1970-1979	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
752	http://opendata.aragon.es/def/iaest/medida#vc-deportivo	8120	\N	69	vc-deportivo	vc-deportivo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
753	http://www.w3.org/ns/org#organization	58082	\N	37	organization	organization	f	58080	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
754	http://opendata.aragon.es/recurso/measureproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-medida/11	2576	\N	138	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
755	http://opendata.aragon.es/def/iaest/medida#hectareas-de-sau-en-aparceria	1533	\N	69	hectareas-de-sau-en-aparceria	hectareas-de-sau-en-aparceria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
756	http://data.tbfy.eu/ontology/ocds#valueAmount	3643	\N	86	valueAmount	valueAmount	f	0	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
757	http://opendata.aragon.es/def/iaest/medida#vc-industrial	10322	\N	69	vc-industrial	vc-industrial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
758	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-jefe-explotacion	767	\N	69	unidades-trabajo-ano-jefe-explotacion	unidades-trabajo-ano-jefe-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
759	http://opendata.aragon.es/def/iaest/dimension#relacion-lugar-de-residencia-y-nacimiento-com	330	\N	98	relacion-lugar-de-residencia-y-nacimiento-com	relacion-lugar-de-residencia-y-nacimiento-com	f	330	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
760	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-conyuges	1533	\N	69	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-conyuges	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-conyuges	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
761	http://purl.org/linked-data/cube#structure	3488	\N	70	structure	structure	f	3488	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
762	http://opendata.aragon.es/def/iaest/medida#salario-retribucion	8392	\N	69	salario-retribucion	salario-retribucion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
763	http://opendata.aragon.es/def/iaest/dimension#area	1545	\N	98	area	area	f	1545	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
764	http://opendata.aragon.es/def/iaest/dimension#rama-actividad-descripcion	16247	\N	98	rama-actividad-descripcion	rama-actividad-descripcion	f	16247	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
765	http://opendata.aragon.es/def/iaest/medida#viviendas-obra-nueva-unifamiliar	349	\N	69	viviendas-obra-nueva-unifamiliar	viviendas-obra-nueva-unifamiliar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
766	http://www.w3.org/2006/vcard/ns#email	7572	\N	39	email	email	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
767	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-porcino-dimension/8	4407	\N	139	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
768	http://opendata.aragon.es/def/iaest/dimension#tipo-de-vehiculo	6070	\N	98	tipo-de-vehiculo	tipo-de-vehiculo	f	6070	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
769	http://www.w3.org/ns/dcat#theme	68387	\N	15	theme	theme	f	68387	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
737	http://opendata.aragon.es/def/iaest/dimension#ue25	161302	\N	98	[UE25 (ue25)]	ue25	f	161302	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
770	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-ovino-medida/9	103	\N	137	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
771	http://opendata.aragon.es/def/iaest/medida#vab	19134	\N	69	vab	vab	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
772	http://opendata.aragon.es/def/iaest/medida#tamano-medio	767	\N	69	tamano-medio	tamano-medio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
773	http://schema.org/hasPart	7127	\N	9	hasPart	hasPart	f	7127	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
774	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-son-asalariados-eventuales	1533	\N	69	unidades-de-trabajo-que-son-asalariados-eventuales	unidades-de-trabajo-que-son-asalariados-eventuales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
775	http://opendata.aragon.es/def/Aragopedia#hectareasPastizalesNaturales	725	\N	78	hectareasPastizalesNaturales	hectareasPastizalesNaturales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
776	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
777	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuya-gestion-se-lleva-por-otra-persona	1533	\N	69	explotaciones-cuya-gestion-se-lleva-por-otra-persona	explotaciones-cuya-gestion-se-lleva-por-otra-persona	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
778	http://www.w3.org/2006/time#hasBeginning	325	\N	71	hasBeginning	hasBeginning	f	0	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
779	http://www.w3.org/2002/07/owl#inverseOf	14	\N	7	inverseOf	inverseOf	f	14	\N	\N	f	f	125	125	\N	t	f	\N	\N	\N	t	f	f
780	http://opendata.aragon.es/def/iaest/medida#censo-electoral	13824	\N	69	censo-electoral	censo-electoral	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
781	http://www.w3.org/ns/dcat#contactPoint	1237	\N	15	contactPoint	contactPoint	f	1237	\N	\N	f	f	25	157	\N	t	f	\N	\N	\N	t	f	f
782	http://opendata.aragon.es/def/iaest/dimension#division-2-digitos-descripcion	180240	\N	98	division-2-digitos-descripcion	division-2-digitos-descripcion	f	180240	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
783	http://purl.org/linked-data/cube#concept	9	\N	70	concept	concept	f	9	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
784	http://opendata.aragon.es/def/Aragopedia#symbol	23	\N	78	symbol	symbol	f	0	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
785	http://opendata.aragon.es/def/iaest/medida#licencias-rehabilitacion-sin-demolicion	6610	\N	69	licencias-rehabilitacion-sin-demolicion	licencias-rehabilitacion-sin-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
786	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-son-mano-de-obra-familiar	1533	\N	69	unidades-de-trabajo-que-son-mano-de-obra-familiar	unidades-de-trabajo-que-son-mano-de-obra-familiar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
787	http://opendata.aragon.es/def/iaest/medida#cajas	6908	\N	69	cajas	cajas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
788	http://icearagon.aragon.es/def/core#hasAltitude	30	\N	83	hasAltitude	hasAltitude	f	0	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
789	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-cunicola-medida/10	5	\N	140	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
790	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-cunicola-medida/11	10	\N	140	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
791	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-cunicola-medida/12	95	\N	140	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
792	http://www.opengis.net/ont/geosparql#asWKT	797	\N	25	asWKT	asWKT	f	0	\N	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
793	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	73	\N	2	isDefinedBy	isDefinedBy	f	56	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
794	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/10	1	\N	130	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
795	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-titulares-que-trabajan-tambien-en-otra-activ-lucrativa	1533	\N	69	personas-mano-obra-familiar-titulares-que-trabajan-tambien-en-otra-activ-lucrativa	personas-mano-obra-familiar-titulares-que-trabajan-tambien-en-otra-activ-lucrativa	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
796	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/11	7	\N	130	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
797	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-de-mas-de-65-anos	1533	\N	69	personas-mano-obra-familiar-otros-de-mas-de-65-anos	personas-mano-obra-familiar-otros-de-mas-de-65-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
798	http://opendata.aragon.es/def/iaest/dimension#grupo-de-tipo-de-contrato	219274	\N	98	grupo-de-tipo-de-contrato	grupo-de-tipo-de-contrato	f	219274	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
799	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/12	89	\N	130	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
800	http://purl.org/vocab/bio/0.1/biography	52	\N	75	biography	biography	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
801	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/13	83	\N	130	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
802	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-y-titulares-explotacion	1533	\N	69	personas-que-son-mano-de-obra-familiar-y-titulares-explotacion	personas-que-son-mano-de-obra-familiar-y-titulares-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
803	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie-10-y-20-hectareas	1533	\N	69	explotaciones-con-superficie-10-y-20-hectareas	explotaciones-con-superficie-10-y-20-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
804	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2021-2022-dimension/10	2371	\N	118	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
805	http://opendata.aragon.es/def/iaest/dimension#siglas	138706	\N	98	siglas	siglas	f	138706	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
806	http://opendata.aragon.es/def/iaest/medida#votos	373964	\N	69	votos	votos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
807	http://opendata.aragon.es/def/Aragopedia#hectareasCultivosRegadio	725	\N	78	hectareasCultivosRegadio	hectareasCultivosRegadio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
808	http://opendata.aragon.es/def/iaest/medida#conejas-madres-cabezas	1533	\N	69	conejas-madres-cabezas	conejas-madres-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
809	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
810	http://www.w3.org/2015/03/inspire/ps#siteProtectionClassification	25	\N	123	siteProtectionClassification	siteProtectionClassification	f	25	\N	\N	f	f	87	57	\N	t	f	\N	\N	\N	t	f	f
811	http://www.w3.org/2002/07/owl#unionOf	26	\N	7	unionOf	unionOf	f	26	\N	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
812	http://opendata.aragon.es/def/iaest/medida#viviendas-demolicion	6487	\N	69	viviendas-demolicion	viviendas-demolicion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
813	http://opendata.aragon.es/def/Aragopedia#hectareasAgricolaVegNat	725	\N	78	hectareasAgricolaVegNat	hectareasAgricolaVegNat	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
814	http://www.w3.org/2002/07/owl#versionInfo	254	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
815	http://opendata.aragon.es/def/iaest/medida#grado-de-formacion	993	\N	69	grado-de-formacion	grado-de-formacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
816	http://opendata.aragon.es/def/iaest/medida#n-demandantes	66354	\N	69	n-demandantes	n-demandantes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
817	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-sin-remuneracion	1533	\N	69	personas-mano-obra-familiar-sin-remuneracion	personas-mano-obra-familiar-sin-remuneracion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
818	http://opendata.aragon.es/def/Aragopedia#hectareasCultivosSecano	725	\N	78	hectareasCultivosSecano	hectareasCultivosSecano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
819	http://opendata.aragon.es/def/iaest/dimension#edad-grupos-quinquenales-2010	13642	\N	98	edad-grupos-quinquenales-2010	edad-grupos-quinquenales-2010	f	13642	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
820	http://opendata.aragon.es/def/iaest/medida#superficie-sin-clasificar	8448	\N	69	superficie-sin-clasificar	superficie-sin-clasificar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
821	http://data.europa.eu/eli/ontology/date_publication	16993	\N	122	date_publication	date_publication	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
822	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau-totalmente-de-su-propiedad	1533	\N	69	explotaciones-con-tierras-con-sau-totalmente-de-su-propiedad	explotaciones-con-tierras-con-sau-totalmente-de-su-propiedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
823	http://opendata.aragon.es/def/iaest/medida#salario-perceptores	48	\N	69	salario-perceptores	salario-perceptores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
824	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
825	http://opendata.aragon.es/def/iaest/medida#viviendas-protegidas	9214	\N	69	viviendas-protegidas	viviendas-protegidas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
826	http://www.w3.org/ns/org#hasSite	22157	\N	37	hasSite	hasSite	f	22157	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
827	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-trabajan-en-otra-actividad-como-principal	1533	\N	69	personas-mano-obra-familiar-trabajan-en-otra-actividad-como-principal	personas-mano-obra-familiar-trabajan-en-otra-actividad-como-principal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
828	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-solo-trabajan-en-la-explotacion	1533	\N	69	personas-mano-obra-familiar-solo-trabajan-en-la-explotacion	personas-mano-obra-familiar-solo-trabajan-en-la-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
829	http://opendata.aragon.es/def/iaest/medida#tasa-bruta-de-natalidad	10748	\N	69	tasa-bruta-de-natalidad	tasa-bruta-de-natalidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
831	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-equido-medida/9	93	\N	116	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
832	http://opendata.aragon.es/def/iaest/medida#personas-asalariados-fijos-total	1533	\N	69	personas-asalariados-fijos-total	personas-asalariados-fijos-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
833	http://opendata.aragon.es/def/Aragopedia#womenPopulation	768	\N	78	womenPopulation	womenPopulation	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
834	http://purl.org/dc/terms/temporal	1221	\N	5	temporal	temporal	f	1221	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
835	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/8	15	\N	141	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
836	http://icearagon.aragon.es/def/bca#hasTipo	1	\N	89	hasTipo	hasTipo	f	1	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
837	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	193	\N	\N	t	f	\N	\N	\N	t	f	f
839	http://opendata.aragon.es/def/iaest/dimension#mes-y-ano	2283531	\N	98	mes-y-ano	mes-y-ano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
840	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/6	101	\N	141	6	6	f	101	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
841	http://opendata.aragon.es/def/iaest/medida#vc-comercial	9350	\N	69	vc-comercial	vc-comercial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
842	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/8	395	\N	142	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
843	http://opendata.aragon.es/def/iaest/dimension#superficie-km2	8173	\N	98	superficie-km2	superficie-km2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
844	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/4	542	\N	142	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
845	http://opendata.aragon.es/def/iaest/dimension#estado	2566	\N	98	estado	estado	f	2566	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
846	http://opendata.aragon.es/def/iaest/medida#viviendas-nueva-planta	8160	\N	69	viviendas-nueva-planta	viviendas-nueva-planta	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
830	http://data.europa.eu/eli/ontology#date_publication	7455	\N	87	[Fecha de publicación (date_publication)]	date_publication	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
838	http://data.europa.eu/eli/ontology#date_document	7449	\N	87	[Fecha del documento (date_document)]	date_document	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
847	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/5	578	\N	142	5	5	f	578	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
848	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/6	578	\N	142	6	6	f	578	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
849	http://www.w3.org/2006/timehasBeginning	313262	\N	108	timehasBeginning	timehasBeginning	f	313262	\N	\N	f	f	142	\N	\N	t	f	\N	\N	\N	t	f	f
850	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/1	578	\N	142	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
851	http://opendata.aragon.es/def/iaest/medida#superficie-total-ha	767	\N	69	superficie-total-ha	superficie-total-ha	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
852	http://opendata.aragon.es/def/iaest/medida#saldo-vegetativo	10749	\N	69	saldo-vegetativo	saldo-vegetativo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
853	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/2	578	\N	142	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
854	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-avicola-dimension/3	578	\N	142	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
855	http://purl.org/dc/elements/1.1/creator	2271	\N	6	creator	creator	f	39	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
856	http://opendata.aragon.es/def/iaest/medida#municipio-superficie-medida	731	\N	69	municipio-superficie-medida	municipio-superficie-medida	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
857	http://opendata.aragon.es/def/iaest/medida#superficie-nueva-planta-total	8335	\N	69	superficie-nueva-planta-total	superficie-nueva-planta-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
858	http://purl.org/dc/terms/issued	1337	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
859	http://opendata.aragon.es/def/Aragopedia#hectareasBosquesFrondosas	725	\N	78	hectareasBosquesFrondosas	hectareasBosquesFrondosas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
860	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/1	101	\N	141	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
861	http://opendata.aragon.es/def/iaest/dimension#grandes-grupos	10007	\N	98	grandes-grupos	grandes-grupos	f	10007	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
862	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/4	25	\N	141	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
863	http://icearagon.aragon.es/def/landscape#hasEngarce	1235	\N	79	hasEngarce	hasEngarce	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
864	http://www.w3.org/2002/07/owl#minCardinality	26	\N	7	minCardinality	minCardinality	f	0	\N	\N	f	f	206	\N	\N	t	f	\N	\N	\N	t	f	f
865	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/5	101	\N	141	5	5	f	101	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
866	http://icearagon.aragon.es/def/landscape#hasStop	733	\N	79	hasStop	hasStop	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
867	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/2	101	\N	141	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
868	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-otras-dimension/3	101	\N	141	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
869	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-apicola-medida/10	1122	\N	143	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
870	http://icearagon.aragon.es/def/health#CCN	6495	\N	88	CCN	CCN	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
871	http://opendata.aragon.es/def/iaest/dimension#edad-grupos-quinquenales	555036	\N	98	edad-grupos-quinquenales	edad-grupos-quinquenales	f	555036	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
872	http://opendata.aragon.es/def/iaest/medida#edad-media-de-la-poblacion	36225	\N	69	edad-media-de-la-poblacion	edad-media-de-la-poblacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
873	http://www.w3.org/2004/02/skos/core#inScheme	18899	\N	4	inScheme	inScheme	f	18899	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
874	http://opendata.aragon.es/def/iaest/medida#pension-media-por-persona	48	\N	69	pension-media-por-persona	pension-media-por-persona	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
875	http://opendata.aragon.es/def/iaest/dimension#porcentaje-sau-regimen-tenencia	4810	\N	98	porcentaje-sau-regimen-tenencia	porcentaje-sau-regimen-tenencia	f	4810	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
876	http://opendata.aragon.es/def/iaest/medida#bi-religioso	10751	\N	69	bi-religioso	bi-religioso	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
877	http://opendata.aragon.es/def/iaest/dimension#calefaccion-agregado	7376	\N	98	calefaccion-agregado	calefaccion-agregado	f	7376	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
878	http://opendata.aragon.es/def/iaest/dimension#sector-de-actividad	53994	\N	98	sector-de-actividad	sector-de-actividad	f	53994	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
879	http://opendata.aragon.es/def/iaest/medida#gastos-de-personal	18238	\N	69	gastos-de-personal	gastos-de-personal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
880	http://www.w3.org/2000/01/rdf-schema#range	1768	\N	2	range	range	f	1768	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
881	http://opendata.aragon.es/def/iaest/dimension#vehiculos-en-el-hogar	2969	\N	98	vehiculos-en-el-hogar	vehiculos-en-el-hogar	f	2969	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
882	http://purl.org/dc/elements/1.1/publisher	42	\N	6	publisher	publisher	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
883	http://opendata.aragon.es/def/iaest/medida#pastizales-permanentes	745	\N	69	pastizales-permanentes	pastizales-permanentes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
884	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros--trabajan-en-otra-actividad-como-principal	1533	\N	69	personas-mano-obra-familiar-otros--trabajan-en-otra-actividad-como-principal	personas-mano-obra-familiar-otros--trabajan-en-otra-actividad-como-principal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
885	http://opendata.aragon.es/def/iaest/medida#motocultores	1533	\N	69	motocultores	motocultores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
886	http://purl.org/dc/elements/1.1/format	2988	\N	6	format	format	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
887	http://opendata.aragon.es/def/iaest/dimension#evacuacion-aguas-residuales	317	\N	98	evacuacion-aguas-residuales	evacuacion-aguas-residuales	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
888	http://opendata.aragon.es/def/iaest/dimension#sector-descripcion	314377	\N	98	sector-descripcion	sector-descripcion	f	314377	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
889	http://opendata.aragon.es/def/Aragopedia#consumoGasolinaTotal	16	\N	78	consumoGasolinaTotal	consumoGasolinaTotal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
890	http://opendata.aragon.es/def/iaest/medida#viviendas-de-2-mano	9214	\N	69	viviendas-de-2-mano	viviendas-de-2-mano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
891	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio-cultivo-olivar	1533	\N	69	hectareas-en-tierras-labradas-de-regadio-cultivo-olivar	hectareas-en-tierras-labradas-de-regadio-cultivo-olivar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
892	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-cunicola-medida/9	25	\N	140	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
893	http://opendata.aragon.es/def/iaest/dimension#tasa-de-feminidad	25	\N	98	tasa-de-feminidad	tasa-de-feminidad	f	25	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
894	http://opendata.aragon.es/def/iaest/medida#tasa-de-masculinidad	18575	\N	69	tasa-de-masculinidad	tasa-de-masculinidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
895	http://www.w3.org/ns/org#holds	6256	\N	37	holds	holds	f	6256	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
897	http://opendata.aragon.es/def/iaest/dimension#portero	317	\N	98	portero	portero	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
898	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/20	120	\N	130	20	20	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
899	http://opendata.aragon.es/def/iaest/dimension#gestion-explotacion	2126	\N	98	gestion-explotacion	gestion-explotacion	f	2126	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
900	http://www.w3.org/2001/vcard-rdf/3.0#City	2	\N	96	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
901	http://opendata.aragon.es/def/iaest/medida#urbano-parcelas	14586	\N	69	urbano-parcelas	urbano-parcelas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
902	http://icearagon.aragon.es/def/education#hasNumZona	19	\N	93	hasNumZona	hasNumZona	f	0	\N	\N	f	f	163	\N	\N	t	f	\N	\N	\N	t	f	f
903	http://opendata.aragon.es/def/iaest/medida#bi-sanidad-benefic	10751	\N	69	bi-sanidad-benefic	bi-sanidad-benefic	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
904	http://opendata.aragon.es/def/iaest/medida#visados-otros	349	\N	69	visados-otros	visados-otros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
905	http://www.wikidata.org/prop/direct/P242	136049	\N	13	P242	P242	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
906	http://opendata.aragon.es/def/iaest/medida#impuestos-indirectos	18238	\N	69	impuestos-indirectos	impuestos-indirectos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
907	http://purl.org/dc/elements/1.1/identifier	178535	\N	6	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
908	http://opendata.aragon.es/def/iaest/dimension#regimen-de-tenencia-agregado	3909	\N	98	regimen-de-tenencia-agregado	regimen-de-tenencia-agregado	f	3909	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
909	http://opendata.aragon.es/def/iaest/medida#votos-a-candidaturas	13824	\N	69	votos-a-candidaturas	votos-a-candidaturas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
910	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/14	70	\N	130	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
911	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/15	206	\N	130	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
912	http://opendata.aragon.es/def/iaest/medida#tasa-global-de-dependencia-ancianos	35279	\N	69	tasa-global-de-dependencia-ancianos	tasa-global-de-dependencia-ancianos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
913	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/16	202	\N	130	16	16	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
914	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/17	164	\N	130	17	17	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
915	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/18	133	\N	130	18	18	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
916	http://data.tbfy.eu/ontology/ocds#hasContractPeriod	3453	\N	86	hasContractPeriod	hasContractPeriod	f	3453	\N	\N	f	f	67	176	\N	t	f	\N	\N	\N	t	f	f
917	http://opendata.aragon.es/recurso/measureproperty/resultados-titulaciones-2020-2021-medida/19	134	\N	130	19	19	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
918	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau--100-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau--100-hectareas	explotaciones-con-tierras-con-sau--100-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
919	http://opendata.aragon.es/def/Aragopedia#hectareasZonasIndustrialesComerciales	725	\N	78	hectareasZonasIndustrialesComerciales	hectareasZonasIndustrialesComerciales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
920	http://opendata.aragon.es/def/iaest/dimension#residencia-pais-nombre	56690	\N	98	residencia-pais-nombre	residencia-pais-nombre	f	56690	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
921	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	193	\N	\N	t	f	\N	\N	\N	t	f	f
922	http://purl.org/dc/terms/license	1335	\N	5	license	license	f	1335	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
923	http://purl.org/dc/elements/1.1/temporal	260	\N	6	temporal	temporal	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
924	http://opendata.aragon.es/def/iaest/medida#vc-residencial	13052	\N	69	vc-residencial	vc-residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
925	http://icearagon.aragon.es/def/health#hasOfertaAsistencial	12327	\N	88	hasOfertaAsistencial	hasOfertaAsistencial	f	12327	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
926	http://opendata.aragon.es/def/iaest/medida#n-accidentes	172953	\N	69	n-accidentes	n-accidentes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
927	http://purl.org/linked-data/sdmx/2009/dimension#refArea	3570457	\N	73	refArea	refArea	f	3570457	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1089	http://opendata.aragon.es/def/iaest/medida#viviendas-libres	9214	\N	69	viviendas-libres	viviendas-libres	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
928	http://icearagon.aragon.es/def/landscape#hasFeatureUnidadDelPaisaje	3851	\N	79	hasFeatureUnidadDelPaisaje	hasFeatureUnidadDelPaisaje	f	3851	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
930	http://opendata.aragon.es/def/iaest/dimension#accesible	317	\N	98	accesible	accesible	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
931	http://opendata.aragon.es/def/iaest/medida#total-ingresos	18238	\N	69	total-ingresos	total-ingresos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
932	http://opendata.aragon.es/def/iaest/medida#total-viviendas	19200	\N	69	total-viviendas	total-viviendas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
933	http://opendata.aragon.es/def/iaest/medida#ganado-porcino-cabezas	1533	\N	69	ganado-porcino-cabezas	ganado-porcino-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
934	http://opendata.aragon.es/def/iaest/dimension#estado-civil	13267	\N	98	estado-civil	estado-civil	f	13267	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
935	http://opendata.aragon.es/def/iaest/medida#total-maquinas	1533	\N	69	total-maquinas	total-maquinas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
936	http://opendata.aragon.es/def/iaest/dimension#numero-trabajadores-cc	110056	\N	98	numero-trabajadores-cc	numero-trabajadores-cc	f	110056	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
937	http://opendata.aragon.es/def/iaest/medida#indice-de-potencialidad	17427	\N	69	indice-de-potencialidad	indice-de-potencialidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
939	http://opendata.aragon.es/def/iaest/medida#tasa-global-de-dependencia-jovenes	35279	\N	69	tasa-global-de-dependencia-jovenes	tasa-global-de-dependencia-jovenes	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
940	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau-5-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau-5-hectareas	explotaciones-con-tierras-con-sau-5-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
941	http://opendata.aragon.es/def/iaest/medida#numero-de-locales	3902	\N	69	numero-de-locales	numero-de-locales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
942	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/4	223	\N	133	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
943	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/3	226	\N	133	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
944	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/2	528	\N	133	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
945	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/8	304	\N	133	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
946	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/7	101	\N	133	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
947	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/6	101	\N	133	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
948	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/5	505	\N	133	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
949	http://www.w3.org/ns/sosa/observableProperty	25118	\N	94	observableProperty	observableProperty	f	25118	\N	\N	f	f	106	128	\N	t	f	\N	\N	\N	t	f	f
950	http://opendata.aragon.es/recurso/measureproperty/casos-coronavirus-aragon-medida/9	304	\N	133	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
951	http://opendata.aragon.es/def/iaest/medida#superficie-total-regada	1533	\N	69	superficie-total-regada	superficie-total-regada	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
952	http://www.w3.org/2002/07/owl#equivalentClass	66	\N	7	equivalentClass	equivalentClass	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
953	http://opendata.aragon.es/def/iaest/dimension#subespecie-ganaderia	6487	\N	98	subespecie-ganaderia	subespecie-ganaderia	f	6487	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
954	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	28	44	\N	t	f	\N	\N	\N	t	f	f
955	http://purl.org/dc/elements/1.1/date	19326	\N	6	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
956	http://opendata.aragon.es/def/Aragopedia#consumoGasolina98	16	\N	78	consumoGasolina98	consumoGasolina98	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
957	http://opendata.aragon.es/def/Aragopedia#consumoGasolina97	9	\N	78	consumoGasolina97	consumoGasolina97	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
958	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
959	http://opendata.aragon.es/def/iaest/dimension#superficie-agricola-utilizada	9176	\N	98	superficie-agricola-utilizada	superficie-agricola-utilizada	f	9176	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
960	http://opendata.aragon.es/def/iaest/dimension#lugar-de-nacimiento	144	\N	98	lugar-de-nacimiento	lugar-de-nacimiento	f	144	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
961	http://opendata.aragon.es/def/iaest/medida#superficie-nueva-planta-residencial	6845	\N	69	superficie-nueva-planta-residencial	superficie-nueva-planta-residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
962	http://opendata.aragon.es/def/iaest/medida#variaciones	35780	\N	69	variaciones	variaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
963	http://schema.org/endDate	959	\N	9	endDate	endDate	f	0	\N	\N	f	f	134	\N	\N	t	f	\N	\N	\N	t	f	f
964	http://purl.org/dc/terms/relation	18	\N	5	relation	relation	f	18	\N	\N	f	f	57	57	\N	t	f	\N	\N	\N	t	f	f
965	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuge-de-mas-de-65-anos	1533	\N	69	personas-mano-obra-familiar-conyuge-de-mas-de-65-anos	personas-mano-obra-familiar-conyuge-de-mas-de-65-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
966	http://www.w3.org/2004/02/skos/core#closeMatch	81	\N	4	closeMatch	closeMatch	f	80	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
967	http://opendata.aragon.es/def/iaest/dimension#gas	317	\N	98	gas	gas	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
968	http://opendata.aragon.es/def/Aragopedia#enComarca	731	\N	78	enComarca	enComarca	f	731	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
969	http://opendata.aragon.es/def/iaest/dimension#combustible-usado	7376	\N	98	combustible-usado	combustible-usado	f	7376	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
970	http://purl.org/dc/elements/1.1/modified	3478	\N	6	modified	modified	f	0	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
971	http://opendata.aragon.es/def/iaest/medida#incendios	20	\N	69	incendios	incendios	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
972	http://opendata.aragon.es/def/Aragopedia#hectareasMosaicoCultivos	725	\N	78	hectareasMosaicoCultivos	hectareasMosaicoCultivos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
973	http://opendata.aragon.es/def/iaest/medida#vc-almacen-estacionamiento	9425	\N	69	vc-almacen-estacionamiento	vc-almacen-estacionamiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
974	http://opendata.aragon.es/def/Aragopedia#consumoGasolina95	16	\N	78	consumoGasolina95	consumoGasolina95	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
975	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	\N	\N	f	f	84	193	\N	t	f	\N	\N	\N	t	f	f
976	http://opendata.aragon.es/def/iaest/medida#hectareas-en-aparceria	1533	\N	69	hectareas-en-aparceria	hectareas-en-aparceria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
977	http://opendata.aragon.es/def/iaest/medida#numero-hogares	56831	\N	69	numero-hogares	numero-hogares	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
978	http://opendata.aragon.es/def/iaest/medida#area-gastos-total	10876	\N	69	area-gastos-total	area-gastos-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
979	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/1	1123	\N	144	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
980	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/3	1123	\N	144	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
981	http://opendata.aragon.es/def/iaest/medida#superficie-agricola-utilizada-sau	3066	\N	69	superficie-agricola-utilizada-sau	superficie-agricola-utilizada-sau	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
982	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/2	1123	\N	144	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
983	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/5	1121	\N	144	5	5	f	1121	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
984	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/4	1123	\N	144	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
985	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/7	1123	\N	144	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
986	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/6	1122	\N	144	6	6	f	1122	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
987	http://opendata.aragon.es/def/iaest/medida#superficie-regada-por-aspersion	1533	\N	69	superficie-regada-por-aspersion	superficie-regada-por-aspersion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
988	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/9	808	\N	144	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
989	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-apicola-dimension/8	1123	\N	144	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
990	http://icearagon.aragon.es/def/core#hasAreaInHa	30	\N	83	hasAreaInHa	hasAreaInHa	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
991	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-son-titulares-de-55-a-64-anos	1533	\N	69	personas-mano-obra-familiar-son-titulares-de-55-a-64-anos	personas-mano-obra-familiar-son-titulares-de-55-a-64-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
992	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie--50-y-100-hectareas	1533	\N	69	explotaciones-con-superficie--50-y-100-hectareas	explotaciones-con-superficie--50-y-100-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
993	http://opendata.aragon.es/def/Aragopedia#codigoINE	730	\N	78	codigoINE	codigoINE	f	0	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
994	http://opendata.aragon.es/def/iaest/medida#lugares-de-importancia-comunitaria	768	\N	69	lugares-de-importancia-comunitaria	lugares-de-importancia-comunitaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
995	http://opendata.aragon.es/def/iaest/medida#mes-y-ano	34274	\N	69	mes-y-ano	mes-y-ano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
996	http://www.w3.org/2006/timehasEnd	285487	\N	108	timehasEnd	timehasEnd	f	285487	\N	\N	f	f	142	\N	\N	t	f	\N	\N	\N	t	f	f
997	http://opendata.aragon.es/def/iaest/dimension#tipo-de-presupuesto	53907	\N	98	tipo-de-presupuesto	tipo-de-presupuesto	f	53907	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
998	http://www.w3.org/2002/07/owl#sameAs	4250	\N	7	sameAs	sameAs	f	4250	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
999	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/2	828	\N	145	2	2	f	828	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
1000	http://opendata.aragon.es/def/iaest/dimension#nivel-estudios-detalle	7060	\N	98	nivel-estudios-detalle	nivel-estudios-detalle	f	7060	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1001	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/5	828	\N	145	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1002	http://opendata.aragon.es/def/iaest/medida#rustica---cuota-euros	1532	\N	69	rustica---cuota-euros	rustica---cuota-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1003	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas	1533	\N	69	hectareas-en-tierras-labradas	hectareas-en-tierras-labradas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1004	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/6	828	\N	145	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1005	http://opendata.aragon.es/def/iaest/medida#pension-media-por-percepcion	8568	\N	69	pension-media-por-percepcion	pension-media-por-percepcion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1006	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/3	828	\N	145	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1007	http://www.w3.org/2002/07/owl#members	119	\N	7	members	members	f	119	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1008	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-egresados-universidad-zaragoza-2019-2020-dimension/4	828	\N	145	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1009	http://opendata.aragon.es/def/iaest/dimension#plazas-garaje	3180	\N	98	plazas-garaje	plazas-garaje	f	3180	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1010	http://opendata.aragon.es/def/iaest/medida#kg-vidrio-domestico	7680	\N	69	kg-vidrio-domestico	kg-vidrio-domestico	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1011	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	193	28	\N	t	f	\N	\N	\N	t	f	f
1012	http://opendata.aragon.es/def/iaest/medida#indice-de-sobreenvejecimiento	35283	\N	69	indice-de-sobreenvejecimiento	indice-de-sobreenvejecimiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1013	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie--01-y-5-hectareas	1533	\N	69	explotaciones-con-superficie--01-y-5-hectareas	explotaciones-con-superficie--01-y-5-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1014	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-distinta-a-las-anteriores-otros	1533	\N	69	personas-que-son-mano-de-obra-familiar-distinta-a-las-anteriores-otros	personas-que-son-mano-de-obra-familiar-distinta-a-las-anteriores-otros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1015	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-4999-y-75porcentaje-trabajando-en-explotacion	1533	\N	69	personas-mano-obra-familiar-con-4999-y-75porcentaje-trabajando-en-explotacion	personas-mano-obra-familiar-con-4999-y-75porcentaje-trabajando-en-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1016	http://opendata.aragon.es/def/iaest/medida#explotaciones-cuyo-titular-es-persona-fisica	3066	\N	69	explotaciones-cuyo-titular-es-persona-fisica	explotaciones-cuyo-titular-es-persona-fisica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1017	http://purl.org/dc/terms/references	2183	\N	5	references	references	f	2183	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
1018	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	124	\N	\N	t	f	\N	\N	\N	t	f	f
1019	http://purl.org/dc/terms/title	153125	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1020	http://www.w3.org/2000/01/rdf-schema#label	1001614	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1021	http://opendata.aragon.es/def/iaest/medida#unidades-trabajo-ano-mano-obra-familiar	767	\N	69	unidades-trabajo-ano-mano-obra-familiar	unidades-trabajo-ano-mano-obra-familiar	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1022	http://opendata.aragon.es/def/iaest/medida#cosechadoras	1533	\N	69	cosechadoras	cosechadoras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1023	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-regadio	1533	\N	69	hectareas-en-tierras-labradas-de-regadio	hectareas-en-tierras-labradas-de-regadio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1024	http://opendata.aragon.es/def/iaest/medida#superficie-zonas-de-especial-proteccion-para-las-aves	768	\N	69	superficie-zonas-de-especial-proteccion-para-las-aves	superficie-zonas-de-especial-proteccion-para-las-aves	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1025	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-secundaria	1533	\N	69	personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-secundaria	personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-secundaria	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1026	http://opendata.aragon.es/def/iaest/medida#porcentaje	5838	\N	69	porcentaje	porcentaje	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1027	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie-5-y-10-hectareas	1533	\N	69	explotaciones-con-superficie-5-y-10-hectareas	explotaciones-con-superficie-5-y-10-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1028	http://schema.org/url	68306	\N	9	url	url	f	65986	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1029	http://opendata.aragon.es/def/iaest/medida#unidades-ganaderas-totales	767	\N	69	unidades-ganaderas-totales	unidades-ganaderas-totales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1030	http://opendata.aragon.es/def/iaest/dimension#portero-automatico	317	\N	98	portero-automatico	portero-automatico	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1031	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-son-asalariados	1533	\N	69	unidades-de-trabajo-que-son-asalariados	unidades-de-trabajo-que-son-asalariados	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1032	http://opendata.aragon.es/def/iaest/dimension#agua-caliente-central	317	\N	98	agua-caliente-central	agua-caliente-central	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1033	http://opendata.aragon.es/def/Aragopedia#numKGVidrio	11465	\N	78	numKGVidrio	numKGVidrio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1034	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuges-que-solo-trabajan-en-la-explotacion	1533	\N	69	personas-mano-obra-familiar-conyuges-que-solo-trabajan-en-la-explotacion	personas-mano-obra-familiar-conyuges-que-solo-trabajan-en-la-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1035	http://opendata.aragon.es/def/iaest/medida#tasas-y-otros-ingresos	18238	\N	69	tasas-y-otros-ingresos	tasas-y-otros-ingresos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1036	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-de-35-a-45-anos	1533	\N	69	personas-que-son-mano-de-obra-familiar-de-35-a-45-anos	personas-que-son-mano-de-obra-familiar-de-35-a-45-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1037	http://opendata.aragon.es/def/iaest/dimension#tipo-de-estudios-realizados	4972	\N	98	tipo-de-estudios-realizados	tipo-de-estudios-realizados	f	4972	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1038	http://opendata.aragon.es/def/iaest/medida#concejales	44530	\N	69	concejales	concejales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1039	http://opendata.aragon.es/def/Aragopedia#hectareasZonasVerdesUrbanas	725	\N	78	hectareasZonasVerdesUrbanas	hectareasZonasVerdesUrbanas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1040	http://icearagon.aragon.es/def/landscape#hasCodDom	4064	\N	79	hasCodDom	hasCodDom	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1041	http://schema.org/temporal	12009	\N	9	temporal	temporal	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
1042	http://opendata.aragon.es/def/iaest/dimension#nacionalidad	21751	\N	98	nacionalidad	nacionalidad	f	21751	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1043	http://opendata.aragon.es/def/Aragopedia#hectareasPlayasDunasArenales	725	\N	78	hectareasPlayasDunasArenales	hectareasPlayasDunasArenales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1045	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1046	http://data.tbfy.eu/ontology/ocds#hasContractValue	3282	\N	86	hasContractValue	hasContractValue	f	3282	\N	\N	f	f	67	22	\N	t	f	\N	\N	\N	t	f	f
1047	http://schema.org/size	13565	\N	9	size	size	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
1048	http://www.w3.org/2006/vcard/ns#hasEmail	312311	\N	39	hasEmail	hasEmail	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
1049	http://opendata.aragon.es/def/iaest/medida#personas-que-son-mano-de-obra-familiar-de-55-a-64-anos	1533	\N	69	personas-que-son-mano-de-obra-familiar-de-55-a-64-anos	personas-que-son-mano-de-obra-familiar-de-55-a-64-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1050	http://opendata.aragon.es/def/iaest/dimension#pocas-zonas-verdes	128	\N	98	pocas-zonas-verdes	pocas-zonas-verdes	f	128	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1051	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/6	371	\N	146	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1052	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/7	428	\N	146	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1053	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-con-otros-cultivos	1533	\N	69	hectareas-en-tierras-labradas-con-otros-cultivos	hectareas-en-tierras-labradas-con-otros-cultivos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1054	http://opendata.aragon.es/def/iaest/medida#edificios-nueva-planta-residencial	6845	\N	69	edificios-nueva-planta-residencial	edificios-nueva-planta-residencial	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1055	http://opendata.aragon.es/def/iaest/medida#inversiones-reales	18238	\N	69	inversiones-reales	inversiones-reales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1056	http://www.w3.org/ns/org#postIn	3165	\N	37	postIn	postIn	f	3165	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1057	http://icearagon.aragon.es/def/hydro#hasNivelVert	76989	\N	84	hasNivelVert	hasNivelVert	f	76989	\N	\N	f	f	\N	57	\N	t	f	\N	\N	\N	t	f	f
1058	http://opendata.aragon.es/def/iaest/medida#valor	15683	\N	69	valor	valor	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1059	http://data.tbfy.eu/ontology/ocds#description	3290	\N	86	description	description	f	0	\N	\N	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
1060	http://opendata.aragon.es/def/iaest/medida#autorizaciones	232	\N	69	autorizaciones	autorizaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1061	http://opendata.aragon.es/def/Aragopedia.htmlComunidadAutonoma	147567	\N	147	Aragopedia.htmlComunidadAutonoma	Aragopedia.htmlComunidadAutonoma	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1062	http://opendata.aragon.es/def/iaest/medida#n-viviendas	6403	\N	69	n-viviendas	n-viviendas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1063	http://www.w3.org/2006/timeinXSDDate	598749	\N	108	timeinXSDDate	timeinXSDDate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1064	http://opendata.aragon.es/def/iaest/medida#votos-blancos	13824	\N	69	votos-blancos	votos-blancos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1065	http://icearagon.aragon.es/def/hydro#hasTipologia	56	\N	84	hasTipologia	hasTipologia	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1066	http://data.europa.eu/eli/ontology#embodies	7452	\N	87	embodies	embodies	f	7452	\N	\N	f	f	61	24	\N	t	f	\N	\N	\N	t	f	f
1067	http://www.w3.org/2000/01/rdf-schema#comment	9988	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1068	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/4	274	\N	146	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1069	http://opendata.aragon.es/def/iaest/medida#rustica---cuota-integra-euros	13052	\N	69	rustica---cuota-integra-euros	rustica---cuota-integra-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1070	http://opendata.aragon.es/def/iaest/medida#abstencion	13824	\N	69	abstencion	abstencion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1071	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/5	218	\N	146	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1072	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/2	427	\N	146	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1073	http://opendata.aragon.es/recurso/measureproperty/datos-vacunas-medida/3	373	\N	146	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1074	https://www.w3.org/ns/dcat#keyword	997	\N	148	keyword	keyword	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1075	http://opendata.aragon.es/def/Aragopedia#hectareasHumedales	725	\N	78	hectareasHumedales	hectareasHumedales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1076	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano-cultivo-vinedo	1533	\N	69	hectareas-en-tierras-labradas-de-secano-cultivo-vinedo	hectareas-en-tierras-labradas-de-secano-cultivo-vinedo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1077	http://opendata.aragon.es/def/iaest/medida#hectareas-de-sau-en-propiedad	1533	\N	69	hectareas-de-sau-en-propiedad	hectareas-de-sau-en-propiedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1078	http://opendata.aragon.es/recurso/measureproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-medida/7	175	\N	149	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1079	http://opendata.aragon.es/def/iaest/dimension#regimen-2-digitos	6305	\N	98	regimen-2-digitos	regimen-2-digitos	f	6305	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1080	http://www.w3.org/2000/01/rdf-schema#domain	515	\N	2	domain	domain	f	515	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1081	http://opendata.aragon.es/def/Aragopedia#hectareasMatorralesHumedos	725	\N	78	hectareasMatorralesHumedos	hectareasMatorralesHumedos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1082	http://opendata.aragon.es/def/iaest/dimension#intervalo-renta	13151	\N	98	intervalo-renta	intervalo-renta	f	13151	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1083	http://opendata.aragon.es/recurso/measureproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-medida/8	172	\N	149	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1118	http://opendata.aragon.es/def/iaest/medida#contenedores-de-vidrio	7680	\N	69	contenedores-de-vidrio	contenedores-de-vidrio	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1236	http://data.europa.eu/eli/ontology#publisher_agent	7452	\N	87	publisher_agent	publisher_agent	f	7452	\N	\N	f	f	24	62	\N	t	f	\N	\N	\N	t	f	f
1084	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-principal	1533	\N	69	personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-principal	personas-mano-obra-familiar-conyuges-que-trabajan-en-otra-actividad-como-principal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1085	http://opendata.aragon.es/recurso/measureproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-medida/9	173	\N	149	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1086	http://opendata.aragon.es/def/iaest/medida#tasa-bruta-de-saldo-vegetativo	10748	\N	69	tasa-bruta-de-saldo-vegetativo	tasa-bruta-de-saldo-vegetativo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1087	http://opendata.aragon.es/def/iaest/medida#hectareas-en-tierras-labradas-de-secano	1533	\N	69	hectareas-en-tierras-labradas-de-secano	hectareas-en-tierras-labradas-de-secano	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1088	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-remuneracion	1533	\N	69	personas-mano-obra-familiar-con-remuneracion	personas-mano-obra-familiar-con-remuneracion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1090	http://www.w3.org/2002/07/owl#maxCardinality	90	\N	7	maxCardinality	maxCardinality	f	0	\N	\N	f	f	206	\N	\N	t	f	\N	\N	\N	t	f	f
1091	http://crossforest.eu/ifi/ontology/hasVolumeWithBarkInM3	67	\N	82	hasVolumeWithBarkInM3	hasVolumeWithBarkInM3	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1092	http://opendata.aragon.es/def/iaest/medida#hectareas-en-arrendamiento	1533	\N	69	hectareas-en-arrendamiento	hectareas-en-arrendamiento	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1093	http://opendata.aragon.es/def/iaest/medida#superficie-calificada-agricultura-ecologica	8448	\N	69	superficie-calificada-agricultura-ecologica	superficie-calificada-agricultura-ecologica	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1094	http://icearagon.aragon.es/def/core#historia	451	\N	83	historia	historia	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1095	http://opendata.aragon.es/def/iaest/dimension#tipo-edificio-agregado	3334	\N	98	tipo-edificio-agregado	tipo-edificio-agregado	f	3334	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1096	http://opendata.aragon.es/def/iaest/medida#kg-recogidos-papel-y-carton	7678	\N	69	kg-recogidos-papel-y-carton	kg-recogidos-papel-y-carton	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1097	http://www.w3.org/2004/02/skos/core#altLabel	1015	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1098	http://opendata.aragon.es/def/iaest/medida#personas	806784	\N	69	personas	personas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1099	http://opendata.aragon.es/def/iaest/medida#explotaciones	40832	\N	69	explotaciones	explotaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1100	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/8	2412	\N	131	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1101	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/7	2412	\N	131	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1102	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-otros-de-35-a-54-anos	1533	\N	69	personas-mano-obra-familiar-otros-de-35-a-54-anos	personas-mano-obra-familiar-otros-de-35-a-54-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1103	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/9	2574	\N	131	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1104	http://opendata.aragon.es/def/iaest/medida#salario-percepciones	8344	\N	69	salario-percepciones	salario-percepciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1105	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-con-100porcentaje-trabajando-en-explotacion	1533	\N	69	personas-mano-obra-familiar-con-100porcentaje-trabajando-en-explotacion	personas-mano-obra-familiar-con-100porcentaje-trabajando-en-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1106	http://opendata.aragon.es/def/iaest/medida#desempleo-prestacion-media-anual	4774	\N	69	desempleo-prestacion-media-anual	desempleo-prestacion-media-anual	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1107	http://opendata.aragon.es/def/iaest/medida#unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-titulares-explotacion	1533	\N	69	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-titulares-explotacion	unidades-de-trabajo-que-siendo-mano-de-obra-familiar-son-titulares-explotacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1108	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/2	2412	\N	131	2	2	f	2412	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
1109	http://opendata.aragon.es/def/iaest/dimension#grupo-antiguedad	20529	\N	98	grupo-antiguedad	grupo-antiguedad	f	20529	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1110	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/4	2412	\N	131	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1111	http://opendata.aragon.es/def/iaest/dimension#grupo-clase-explotacion	4173	\N	98	grupo-clase-explotacion	grupo-clase-explotacion	f	4173	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1112	http://opendata.aragon.es/def/iaest/medida#cuentas-cotizacion-con-trabajadores	81333	\N	69	cuentas-cotizacion-con-trabajadores	cuentas-cotizacion-con-trabajadores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1113	http://opendata.aragon.es/def/iaest/medida#viviendas-con-agua-corriente	768	\N	69	viviendas-con-agua-corriente	viviendas-con-agua-corriente	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1114	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/3	2412	\N	131	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1115	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/6	2412	\N	131	6	6	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1116	http://opendata.aragon.es/recurso/dimensionproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-dimension/5	2412	\N	131	5	5	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1117	http://opendata.aragon.es/def/iaest/medida#comarca	1573	\N	69	comarca	comarca	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1159	http://opendata.aragon.es/def/iaest/dimension#grupo	21951	\N	98	grupo	grupo	f	21951	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1119	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-otra-maquina	770	\N	69	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-otra-maquina	explotaciones-que-usan-maquinaria-no-en-propiedad-exclusiva-otra-maquina	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1120	http://icearagon.aragon.es/def/landscape#hasFeatureGranDominioDePaisaje	60	\N	79	hasFeatureGranDominioDePaisaje	hasFeatureGranDominioDePaisaje	f	60	\N	\N	f	f	\N	69	\N	t	f	\N	\N	\N	t	f	f
1121	http://opendata.aragon.es/def/iaest/medida#hectareas-en-propiedad	1533	\N	69	hectareas-en-propiedad	hectareas-en-propiedad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1122	http://purl.org/dc/elements/1.1/rights	1	\N	6	rights	rights	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1123	http://opendata.aragon.es/def/iaest/medida#explotaciones-que-usan-maquinaria-propia	1533	\N	69	explotaciones-que-usan-maquinaria-propia	explotaciones-que-usan-maquinaria-propia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1124	http://opendata.aragon.es/def/iaest/dimension#entidad-singular	9166	\N	98	entidad-singular	entidad-singular	f	9166	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1125	http://opendata.aragon.es/def/iaest/dimension#estructura-hogar	11575	\N	98	estructura-hogar	estructura-hogar	f	11575	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1126	http://opendata.aragon.es/def/iaest/medida#visados-ampliacion	349	\N	69	visados-ampliacion	visados-ampliacion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1127	http://www.w3.org/2015/03/inspire/ps#legalFoundationDocument	25	\N	123	legalFoundationDocument	legalFoundationDocument	f	0	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
1128	http://opendata.aragon.es/def/iaest/medida#kg-recogidos-de-pilas	768	\N	69	kg-recogidos-de-pilas	kg-recogidos-de-pilas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1129	http://opendata.aragon.es/def/iaest/dimension#nucleo	6886	\N	98	nucleo	nucleo	f	6886	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1130	http://icearagon.aragon.es/def/bca#hasNombre	1	\N	89	hasNombre	hasNombre	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
1131	http://opendata.aragon.es/def/iaest/medida#vc-suelo-vacante	10534	\N	69	vc-suelo-vacante	vc-suelo-vacante	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1132	http://opendata.aragon.es/def/iaest/dimension#telefono	317	\N	98	telefono	telefono	f	317	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1133	http://www.w3.org/ns/dcat#mediaType	1533	\N	15	mediaType	mediaType	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1134	http://opendata.aragon.es/def/iaest/medida#ganado-bovino-vacas-lecheras-cabezas	1533	\N	69	ganado-bovino-vacas-lecheras-cabezas	ganado-bovino-vacas-lecheras-cabezas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1135	http://crossforest.eu/ifi/ontology/hasNumberOfTreesInUnitsByHa	67	\N	82	hasNumberOfTreesInUnitsByHa	hasNumberOfTreesInUnitsByHa	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1136	http://icearagon.aragon.es/def/bca#hasComponen1D	1	\N	89	hasComponen1D	hasComponen1D	f	1	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
1137	http://opendata.aragon.es/def/iaest/medida#numero-de-edificios	30567	\N	69	numero-de-edificios	numero-de-edificios	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1138	http://purl.org/linked-data/cube#measure	2451	\N	70	measure	measure	f	2451	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1139	http://www.w3.org/2004/02/skos/core#broader	667	\N	4	broader	broader	f	667	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
1140	http://www.w3.org/2006/vcard/ns#org	6594	\N	39	org	org	f	6594	\N	\N	f	f	\N	62	\N	t	f	\N	\N	\N	t	f	f
1141	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	\N	\N	f	f	193	\N	\N	t	f	\N	\N	\N	t	f	f
1142	http://opendata.aragon.es/def/iaest/dimension#regimen	19597	\N	98	regimen	regimen	f	19597	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1143	http://www.openlinksw.com/schemas/DAV#ownerUser	1240	\N	18	ownerUser	ownerUser	f	1240	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1144	http://opendata.aragon.es/def/iaest/medida#tasa-bruta-de-mortalidad	10748	\N	69	tasa-bruta-de-mortalidad	tasa-bruta-de-mortalidad	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1145	http://opendata.aragon.es/def/Aragopedia#hectareasGlaciarNievePermanente	725	\N	78	hectareasGlaciarNievePermanente	hectareasGlaciarNievePermanente	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1146	http://opendata.aragon.es/def/iaest/medida#kg-recogidos-envases	7644	\N	69	kg-recogidos-envases	kg-recogidos-envases	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1147	http://opendata.aragon.es/def/iaest/medida#urbano-valor-catastral-suelo	10751	\N	69	urbano-valor-catastral-suelo	urbano-valor-catastral-suelo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1148	http://opendata.aragon.es/def/Aragopedia#hectareasInstalacionesDeportivas	725	\N	78	hectareasInstalacionesDeportivas	hectareasInstalacionesDeportivas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1149	http://opendata.aragon.es/def/iaest/medida#superficie-total-de-las-explotaciones	3066	\N	69	superficie-total-de-las-explotaciones	superficie-total-de-las-explotaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1150	http://opendata.aragon.es/def/iaest/medida#indice-reemplazamiento-edad-activa-total	34029	\N	69	indice-reemplazamiento-edad-activa-total	indice-reemplazamiento-edad-activa-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1151	http://www.w3.org/2006/vcard/ns#locality	13046	\N	39	locality	locality	f	0	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
1152	http://opendata.aragon.es/def/iaest/medida#area-gastos-produccion-bienes-publicos-caracter-preferente	10876	\N	69	area-gastos-produccion-bienes-publicos-caracter-preferente	area-gastos-produccion-bienes-publicos-caracter-preferente	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1153	http://opendata.aragon.es/def/iaest/dimension#ruidos-exteriores	2228	\N	98	ruidos-exteriores	ruidos-exteriores	f	2228	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1154	http://www.w3.org/2002/07/owl#versionIRI	8	\N	7	versionIRI	versionIRI	f	8	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1155	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/2	4418	\N	150	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1156	http://www.geonames.org/ontology#name	14	\N	72	name	name	f	0	\N	\N	f	f	112	\N	\N	t	f	\N	\N	\N	t	f	f
1157	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/1	4418	\N	150	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1158	http://purl.org/dc/terms/identifier	6162	\N	5	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1160	http://opendata.aragon.es/def/iaest/medida#cooperativas	6908	\N	69	cooperativas	cooperativas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1161	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/7	4395	\N	150	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1162	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-superficie--20-y-50-hectareas	1533	\N	69	explotaciones-con-superficie--20-y-50-hectareas	explotaciones-con-superficie--20-y-50-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1163	http://opendata.aragon.es/def/iaest/medida#empleo	340	\N	69	empleo	empleo	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1164	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/9	3552	\N	150	9	9	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1165	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/4	4410	\N	150	4	4	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1166	http://opendata.aragon.es/def/iaest/medida#viviendas-con-tendido-telefonico	767	\N	69	viviendas-con-tendido-telefonico	viviendas-con-tendido-telefonico	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1167	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/3	4418	\N	150	3	3	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1168	http://opendata.aragon.es/recurso/measureproperty/explotaciones-ganaderas-bovino-medida/8	3879	\N	151	8	8	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1169	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/6	4417	\N	150	6	6	f	4417	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
1170	http://opendata.aragon.es/recurso/dimensionproperty/explotaciones-ganaderas-porcino-dimension/5	4417	\N	150	5	5	f	4417	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
1171	http://opendata.aragon.es/def/iaest/medida#viviendas-con-cuarto-de-aseo-con-inodoro	768	\N	69	viviendas-con-cuarto-de-aseo-con-inodoro	viviendas-con-cuarto-de-aseo-con-inodoro	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1172	http://opendata.aragon.es/def/iaest/medida#renta-disponible-bruta	4038	\N	69	renta-disponible-bruta	renta-disponible-bruta	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1173	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-tierras-con-sau--10-y--20-hectareas	1533	\N	69	explotaciones-con-tierras-con-sau--10-y--20-hectareas	explotaciones-con-tierras-con-sau--10-y--20-hectareas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1174	http://icearagon.aragon.es/def/core#hasOrientation	30	\N	83	hasOrientation	hasOrientation	f	30	\N	\N	f	f	190	57	\N	t	f	\N	\N	\N	t	f	f
1175	http://opendata.aragon.es/def/Aragopedia#year	24157	\N	78	year	year	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1176	http://opendata.aragon.es/def/iaest/medida#indice-de-juventud	35283	\N	69	indice-de-juventud	indice-de-juventud	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1177	http://purl.org/dc/elements/1.1/source	396582	\N	6	source	source	f	318509	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1178	http://opendata.aragon.es/def/iaest/dimension#nacionalidad-nombre	1545	\N	98	nacionalidad-nombre	nacionalidad-nombre	f	1545	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1179	http://icearagon.aragon.es/def/core#manages	12	\N	83	manages	manages	f	12	\N	\N	f	f	62	190	\N	t	f	\N	\N	\N	t	f	f
1180	http://www.w3.org/2004/02/skos/core#exactMatch	2818	\N	4	exactMatch	exactMatch	f	2818	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1181	http://opendata.aragon.es/def/iaest/dimension#n-de-habitaciones-de-la-vivienda	4223	\N	98	n-de-habitaciones-de-la-vivienda	n-de-habitaciones-de-la-vivienda	f	4223	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1182	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-principal	1533	\N	69	personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-principal	personas-mano-obra-familiar-titulares-que-trabajan-en-otra-actividad-como-principal	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1183	http://data.europa.eu/eli/ontology#format	7452	\N	87	format	format	f	7452	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
1184	http://opendata.aragon.es/def/iaest/medida#fuentes-mineromedicinales	767	\N	69	fuentes-mineromedicinales	fuentes-mineromedicinales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1185	http://opendata.aragon.es/def/Aragopedia#hectareasCarreterasTren	725	\N	78	hectareasCarreterasTren	hectareasCarreterasTren	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1186	http://icearagon.aragon.es/def/ps#hasCsubtip	25	\N	91	hasCsubtip	hasCsubtip	f	25	\N	\N	f	f	87	57	\N	t	f	\N	\N	\N	t	f	f
1187	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-formacion-universitaria-del-titular	1533	\N	69	explotaciones-con-formacion-universitaria-del-titular	explotaciones-con-formacion-universitaria-del-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1188	http://opendata.aragon.es/def/iaest/dimension#grupos-1-duracion-demanda-descripcion	91292	\N	98	grupos-1-duracion-demanda-descripcion	grupos-1-duracion-demanda-descripcion	f	91292	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1189	http://opendata.aragon.es/def/iaest/medida#n-medio-de-miembros	4087	\N	69	n-medio-de-miembros	n-medio-de-miembros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1190	http://opendata.aragon.es/def/iaest/dimension#nacionalidad-area-nombre	270503	\N	98	nacionalidad-area-nombre	nacionalidad-area-nombre	f	270503	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1191	http://opendata.aragon.es/def/iaest/medida#bi-cultural	10751	\N	69	bi-cultural	bi-cultural	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1192	http://opendata.aragon.es/def/iaest/medida#salario-medio-por-percepcion	8323	\N	69	salario-medio-por-percepcion	salario-medio-por-percepcion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1193	http://opendata.aragon.es/def/iaest/medida#tasa-global-de-dependencia	35279	\N	69	tasa-global-de-dependencia	tasa-global-de-dependencia	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1194	http://opendata.aragon.es/def/iaest/dimension#tipo-de-hogar	3981	\N	98	tipo-de-hogar	tipo-de-hogar	f	3981	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1195	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-pastos-y-otras-tierras	1533	\N	69	explotaciones-con-pastos-y-otras-tierras	explotaciones-con-pastos-y-otras-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1196	http://opendata.aragon.es/def/iaest/medida#personas-mano-obra-familiar-conyuge-de-55-a-64-anos	1533	\N	69	personas-mano-obra-familiar-conyuge-de-55-a-64-anos	personas-mano-obra-familiar-conyuge-de-55-a-64-anos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1197	http://opendata.aragon.es/def/iaest/dimension#residencia	14400	\N	98	residencia	residencia	f	14400	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1198	http://opendata.aragon.es/def/iaest/medida#licencias-total	7844	\N	69	licencias-total	licencias-total	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1199	http://opendata.aragon.es/def/iaest/dimension#cod-temporalidad	2184	\N	98	cod-temporalidad	cod-temporalidad	f	2184	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1200	http://opendata.aragon.es/def/iaest/medida#otras-tierrras	753	\N	69	otras-tierrras	otras-tierrras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1201	http://www.w3.org/2002/07/owl#equivalentProperty	194	\N	7	equivalentProperty	equivalentProperty	f	193	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1202	http://icearagon.aragon.es/def/landscape#includedIn	15164	\N	79	includedIn	includedIn	f	15164	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1203	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-provincia-dimension/2	438	\N	152	2	2	f	438	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
1204	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-provincia-dimension/1	592	\N	152	1	1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1205	http://opendata.aragon.es/def/iaest/medida#sau	767	\N	69	sau	sau	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1206	http://opendata.aragon.es/def/iaest/medida#rustica---base-imponible-miles-de-euros	14586	\N	69	rustica---base-imponible-miles-de-euros	rustica---base-imponible-miles-de-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1207	http://data.europa.eu/eli/ontology/date_applicability	5377	\N	122	date_applicability	date_applicability	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1208	http://opendata.aragon.es/def/iaest/dimension#mes-nombre	678470	\N	98	mes-nombre	mes-nombre	f	678470	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1209	http://opendata.aragon.es/def/iaest/medida#total-edificios	768	\N	69	total-edificios	total-edificios	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1210	http://opendata.aragon.es/def/iaest/medida#tractores	1533	\N	69	tractores	tractores	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1211	http://www.w3.org/2006/time#inXSDgYearMonth	523	\N	71	inXSDgYearMonth	inXSDgYearMonth	f	0	\N	\N	f	f	159	\N	\N	t	f	\N	\N	\N	t	f	f
1212	http://opendata.aragon.es/def/iaest/medida#hectareas-en-otras-tierras	1533	\N	69	hectareas-en-otras-tierras	hectareas-en-otras-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1213	http://opendata.aragon.es/def/iaest/dimension#personalidad-juridica	2277	\N	98	personalidad-juridica	personalidad-juridica	f	2277	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1214	http://opendata.aragon.es/def/iaest/medida#ingresos-patrimoniales	18238	\N	69	ingresos-patrimoniales	ingresos-patrimoniales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1215	http://schema.org/abstract	504728	\N	9	abstract	abstract	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1216	http://www.w3.org/2000/01/rdf-schema#seeAlso	286518	\N	2	seeAlso	seeAlso	f	100	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1217	http://opendata.aragon.es/def/Aragopedia#consumoGasoleoBiodiesel	10	\N	78	consumoGasoleoBiodiesel	consumoGasoleoBiodiesel	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1218	http://opendata.aragon.es/def/Aragopedia#hectareasFrutales	725	\N	78	hectareasFrutales	hectareasFrutales	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1219	http://opendata.aragon.es/def/iaest/dimension#regimen-de-tenencia-detalle	3909	\N	98	regimen-de-tenencia-detalle	regimen-de-tenencia-detalle	f	3909	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1220	http://opendata.aragon.es/def/iaest/medida#vc-cultural	7351	\N	69	vc-cultural	vc-cultural	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1221	http://opendata.aragon.es/recurso/measureproperty/oferta-ocupacion-plazas-universidad-zaragoza-2020-2021-medida/10	175	\N	149	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1222	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/7	17933	\N	153	7	7	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1223	http://schema.org/creator	630419	\N	9	creator	creator	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
1224	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/5	17938	\N	153	5	5	f	17938	\N	\N	f	f	104	37	\N	t	f	\N	\N	\N	t	f	f
1225	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/6	17938	\N	153	6	6	f	17938	\N	\N	f	f	104	123	\N	t	f	\N	\N	\N	t	f	f
1226	http://opendata.aragon.es/def/iaest/medida#superficie-regada-por-riego-localizado-goteo-microaspersion-etc	1533	\N	69	superficie-regada-por-riego-localizado-goteo-microaspersion-etc	superficie-regada-por-riego-localizado-goteo-microaspersion-etc	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1227	http://opendata.aragon.es/def/iaest/dimension#corine-land-cover-2000-nivel-1-descripcion	7665	\N	98	corine-land-cover-2000-nivel-1-descripcion	corine-land-cover-2000-nivel-1-descripcion	f	7665	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1228	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/1	17938	\N	153	1	1	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1229	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/15	4905	\N	115	15	15	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1230	http://opendata.aragon.es/recurso/dimensionproperty/casos-coronavirus-hospitales-dimension/2	17938	\N	153	2	2	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1231	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/13	4857	\N	115	13	13	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1232	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/14	4868	\N	115	14	14	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1233	http://opendata.aragon.es/def/iaest/medida#n-habitaciones	4223	\N	69	n-habitaciones	n-habitaciones	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1234	http://opendata.aragon.es/def/iaest/medida#produccion-estandar-total-euros	767	\N	69	produccion-estandar-total-euros	produccion-estandar-total-euros	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1235	http://opendata.aragon.es/def/ei2av2#range	110	\N	100	range	range	f	110	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1237	http://opendata.aragon.es/def/iaest/medida#viviendas-con-disponibilidad-de-ducha-o-banera	768	\N	69	viviendas-con-disponibilidad-de-ducha-o-banera	viviendas-con-disponibilidad-de-ducha-o-banera	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1238	http://www.w3.org/ns/org#classification	454117	\N	37	classification	classification	f	454117	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1239	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/11	298	\N	119	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1240	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/10	108	\N	119	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1241	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/11	4381	\N	115	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1242	http://opendata.aragon.es/def/iaest/medida#explotaciones-con-experiencia-practica-exclusiva-del-titular	1533	\N	69	explotaciones-con-experiencia-practica-exclusiva-del-titular	explotaciones-con-experiencia-practica-exclusiva-del-titular	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1243	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/12	4900	\N	115	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1244	http://opendata.aragon.es/def/iaest/medida#zonas-de-especial-proteccion-para-las-aves	768	\N	69	zonas-de-especial-proteccion-para-las-aves	zonas-de-especial-proteccion-para-las-aves	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1245	http://opendata.aragon.es/recurso/measureproperty/alumnos-egresados-universidad-zaragoza-2019-2020-medida/12	234	\N	119	12	12	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1246	http://opendata.aragon.es/recurso/measureproperty/rendimiento-por-asignatura-y-titulacion-universidad-zaragoza-2020-2021-medida/10	4377	\N	115	10	10	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1247	http://icearagon.aragon.es/def/landscape#hasFeatureUnidadFisiográfica	35715	\N	79	hasFeatureUnidadFisiográfica	hasFeatureUnidadFisiográfica	f	35715	\N	\N	f	f	\N	11	\N	t	f	\N	\N	\N	t	f	f
1248	http://www.openlinksw.com/ontology/acl#hasDefaultAccess	2	\N	97	hasDefaultAccess	hasDefaultAccess	f	2	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
1249	http://opendata.aragon.es/def/iaest/medida#rustica---numero-de-recibos	11518	\N	69	rustica---numero-de-recibos	rustica---numero-de-recibos	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1250	http://opendata.aragon.es/def/iaest/dimension#nivel-de-estudios-nombre	19434	\N	98	nivel-de-estudios-nombre	nivel-de-estudios-nombre	f	19434	\N	\N	f	f	104	59	\N	t	f	\N	\N	\N	t	f	f
1251	http://opendata.aragon.es/def/Aragopedia#hectareasMatorralesEsclerof	725	\N	78	hectareasMatorralesEsclerof	hectareasMatorralesEsclerof	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1252	http://xmlns.com/foaf/0.1/depiction	46	\N	8	depiction	depiction	f	46	\N	\N	f	f	190	\N	\N	t	f	\N	\N	\N	t	f	f
1253	http://opendata.aragon.es/def/iaest/medida#total-jornadas-completas	1533	\N	69	total-jornadas-completas	total-jornadas-completas	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1254	http://opendata.aragon.es/recurso/measureproperty/alumnos-matriculados-universidad-zaragoza-2020-2021-medida/11	2564	\N	154	11	11	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1255	http://purl.org/dc/terms/created	1240	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1256	http://opendata.aragon.es/def/iaest/medida#urbano-valor-catastral-construccion	10751	\N	69	urbano-valor-catastral-construccion	urbano-valor-catastral-construccion	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1257	http://opendata.aragon.es/def/iaest/medida#transferencias-de-capital	36476	\N	69	transferencias-de-capital	transferencias-de-capital	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1258	http://opendata.aragon.es/def/iaest/medida#hectareas-en-otros-regimenes-de-tenencia-de-las-tierras	1533	\N	69	hectareas-en-otros-regimenes-de-tenencia-de-las-tierras	hectareas-en-otros-regimenes-de-tenencia-de-las-tierras	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
1259	http://icearagon.aragon.es/def/landscape#hasCodFis	16289	\N	79	hasCodFis	hasCodFis	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
896	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	7759081	\N	1	type	type	f	7759081	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
664	http://data.europa.eu/eli/ontology#type_document	7452	\N	87	[Enlace con tipo documento (type_document)]	type_document	f	7452	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
938	http://opendata.aragon.es/def/iaest/medida#2010-y-posterior	768	\N	69	[2010 y posterior (2010-y-posterior)]	2010-y-posterior	f	0	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_opendata_aragon_es_sparql; Owner: -
--

COPY http_opendata_aragon_es_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	2	8	Título	es
2	3	8	Nombre completo	es
3	5	8	Fecha de fin	es
4	6	8	Superficie regada con aguas subterráneas de pozo o sondeo	es
6	7	8	Visados, total	es
8	11	8	Segunda residencia	es
10	13	8	Superficie (km2)	es
12	14	8	Personas que son mano de obra familiar mujeres	es
14	16	8	Enajenación inversiones reales	es
16	17	8	Desempleo Retribución	es
18	18	8	Fecha de inicio del cambio	es
19	19	8	VAB per cápita	es
20	20	8	Índice de maternidad	es
22	21	8	Explotaciones con otra formación agrícola del titular	es
24	22	8	Rústica   Base liquidable (miles de euros)	es
26	23	8	Unidades de trabajo que son jefes de explotación	es
28	24	8	Personas que son mano de obra familiar hombres	es
30	25	8	Estado	es
31	26	8	Total jornadas parciales	es
33	27	8	Superficie tierras labradas	es
35	28	8	Observaciones	es
36	29	8	Nacionalidad continente nombre	es
38	30	8	Temporalidad	es
40	31	8	Nº parados	es
42	32	8	Edad	es
44	33	8	priorVersion	\N
45	34	8	Urbana   Base imponible (miles de euros)	es
47	35	8	Material	es
48	36	8	Superficie de Espacios Naturales Protegidos	es
50	41	8	Orden	es
51	43	8	Personas residentes viviendas familiares	es
53	44	8	Página web	\N
54	45	8	Número habitaciones	es
56	47	8	Observación	es
57	50	8	Explotaciones con sólo pastos	es
59	51	8	Explotaciones con tierras con SAU >= 5 y < 10 hectáreas	es
61	52	8	Naturaleza	es
62	54	8	Núcleo/diseminado	es
64	55	8	Enlace inversa con normativa	es
65	57	8	Miles de aves	es
67	58	8	Fecha de final	es
68	60	8	Grupo de tipo de jornada	es
70	62	8	Tipo	es
71	65	8	Explotaciones con superficie >= 100 hectáreas	es
73	67	8	orden_modalidad	es
75	70	8	Teléfono	es
76	76	8	Relación lugar de residencia y nacimiento	es
78	78	8	Número Empresas	es
80	79	8	Licencias, nueva planta, sin demolición	es
82	80	8	Salario Percepciones por persona	es
84	81	8	Área gastos, actuaciones carácter económico	es
86	84	8	Refrigeración	es
88	85	8	Especificaciones de los componentes	es
89	86	8	Edificios nueva planta, total	es
91	92	8	Explotaciones cuya gestión se lleva por el titular de la misma	es
93	93	8	Personas mano obra familiar otros, que trabajan en otra actividad como secundaria	es
94	94	8	Personas mano obra familiar otros, que  trabajan también en otra activ. lucrativa	es
95	95	8	Superficie regada con agua insuficiente	es
97	98	8	Personas asalariados fijos varones	es
99	99	8	Orden	es
101	106	8	Explotaciones con tierras cuya superficie es totalmente de su propiedad	es
103	107	8	Salario medio por persona	es
105	108	8	Imagen de usuario	es
106	109	8	Licencias, rehabilitación, total	es
108	110	8	Pasivos financieros	es
110	111	8	Unidad fisiomorfológica	es
111	112	8	Residencia área nombre	es
113	116	8	SAU (Ha.)	es
115	125	8	Valor	es
116	126	8	Personas que son mano de obra familiar <35 años	es
118	127	8	Hectáreas en tierras labradas de secano cultivos frutales	es
120	129	8	Régimen de tenencia	es
122	130	8	Calidad	es
123	132	8	Contenedores de envases	es
125	133	8	Urbana   Cuota líquida (euros)	es
127	135	8	Pensión Percepciones	es
129	137	8	Explotaciones con tierras con SAU	es
131	138	8	Correo electrónico	\N
132	139	8	Personas mano obra familiar trabajan también en otra activ. lucrativa	es
133	140	8	Plantas sobre rasante	es
135	142	8	Renta disponible bruta per cápita	es
137	144	8	Superficie en el año 1992 (Has.)	es
138	145	8	Hectáreas en tierras labradas de secano cultivo olivar	es
140	146	8	Explotaciones con tierras labranza y otras	es
142	147	8	Extranjeros	es
144	148	8	Desempleo Perceptores	es
146	149	8	Fecha de inicio	es
147	150	8	Número viviendas	es
149	151	8	Nivel formativo grupo IAEST descripción	es
151	152	8	Hectáreas en tierras labradas de regadío cultivos frutales	es
153	158	8	Residencial	es
155	159	8	Unidades trabajo-año otros miembros familia	es
157	161	8	Hectáreas en tierras para pastos permanentes	es
159	162	8	Españoles	es
161	163	8	Licencias, rehabilitación locales	es
163	164	8	Situación profesional	es
165	165	8	Número total de parcelas	es
167	166	8	Votos nulos	es
169	172	8	Superficie no regada, disponiendo la explotación de instalaciones y agua	es
171	173	8	disjointWith	\N
172	174	8	2000-2009	es
174	176	8	Orden	es
175	177	8	Explotaciones sin tierras	es
177	178	8	Cursos jefe explotación	es
179	179	8	Tamaño Centro	es
181	181	8	Viviendas con acceso a internet	es
183	182	8	Tipo hogar 1	es
185	186	8	Visados, obra nueva	es
187	187	8	Superficie regada con aguas superficiales	es
189	190	8	Porcentaje de SAU en propiedad del titular	es
191	191	8	Location	en
192	191	8	Lugar	es
193	193	8	Calefacción (detalle)	es
195	194	8	Contaminación	es
197	195	8	Urbana   Cuota íntegra (euros)	es
199	197	8	BI Edificios singulares	es
201	199	8	Falta de servicios de aseo	es
203	201	8	Clase vivienda (agregado)	es
205	202	8	1990-1999	es
207	203	8	Contenedores de pilas	es
209	205	8	Superficie regada con concesión integrada en una Comunidad de Regantes	es
211	207	8	Tipo de vivienda principal	es
213	208	8	Rol	es
214	209	8	Sin definir	es
216	210	8	Delincuencia zona	es
218	211	8	Categorías raíz del tesauro	es
219	212	8	Urbano, bienes inmuebles	es
221	213	8	Zona Infantil y Primaria	es
222	217	8	Días duración contrato	es
224	218	8	Lugar de residencia	es
226	219	8	Unidades trabajo-año titular	es
228	223	8	Viviendas rehabilitación	es
230	225	8	% Participación	es
232	233	8	Rústica   Cuota líquida (euros)	es
234	234	8	Actividad del local	es
236	239	8	Fecha de inicio	es
237	240	8	Superficie en el año 2000 (Has.)	es
238	243	8	Superficie calificada en reconversión	es
240	244	8	Gastos, fondo de contingencia	es
242	245	8	Viviendas, obra nueva, bloque	es
244	247	8	Antes de 1950	es
246	248	8	Editorial	es
247	251	8	Año	es
249	252	8	Explotaciones con tierras con SAU >= 20 y < 50 hectáreas	es
251	253	8	Explotaciones que usan maquinaria no en propiedad exclusiva: cosechadora	es
253	254	8	Formación jefe explotación	es
255	255	8	Ganado caprino (cabezas)	es
257	257	8	Tipo edificio (detalle)	es
259	258	8	Total personas	es
261	261	8	Hectáreas de SAU en otros regímenes de tenencia de las tierras	es
263	262	8	Densidad de población (hab/km2)	es
265	263	8	Condición socioeconómica	es
267	264	8	Número de miembros	es
269	265	8	Lugar trabajo o estudio	es
271	266	8	Corine Land Cover 2000 nivel 3 descripción	es
273	268	8	Número de explotaciones con ganado	es
275	271	8	Residencia continente nombre	es
277	272	8	Candidatura	es
279	273	8	imports	\N
280	274	8	Especie ganadería descripción	es
282	275	8	Personas que son mano de obra familiar de más de 65 años	es
284	278	8	Número de viajes diarios	es
286	281	8	Tipo de vehículo (orden)	es
288	282	8	Nº hogares	es
290	283	8	Siglas	es
292	284	8	Superficie (m²)	es
293	285	8	Enlace a la expresión legal	es
294	286	8	Urbana   Número de recibos	es
296	287	8	Personas mano obra familiar son titulares <35 años	es
298	288	8	onProperty	\N
299	289	8	VC Ocio, hostelería	es
300	292	8	Tipo de edificio	es
302	295	8	Explotaciones con formación profesional del titular	es
304	298	8	Contenedores de papel y cartón	es
306	300	8	Unidades ganaderas	es
308	301	8	Urbano, superficie	es
310	302	8	Zona ESO	es
311	303	8	Dirección de la sede	es
312	303	8	Site address	en
313	304	8	Nombre	es
314	305	8	Identificador	es
315	306	8	Personas mano obra familiar titulares que sólo trabajan en la explotación	es
316	308	8	Municipio 2ª residencia, nombre	es
318	309	8	Personas mano obra familiar trabajan en otra actividad como secundaria	es
319	310	8	Continente nacionalidad	es
321	312	8	Explotaciones con tierras	es
323	314	8	Índice de envejecimiento	es
325	315	8	Explotaciones con máquina en propiedad: cosechadora	es
327	317	8	Aptitud	es
328	318	8	Animales	es
330	319	8	Tipo	es
331	320	8	Rústico, parcelas	es
333	321	8	Desempleo medio por percepción	es
335	322	8	Superficie regada con aguas depuradas	es
337	323	8	Explotaciones con sólo tierras labranza	es
339	324	8	Modalidad	es
341	325	8	Subsección descripción	es
343	326	8	Unidades trabajo-año asalariados fijos	es
345	327	8	Explotaciones con máquina en propiedad: tractor	es
347	328	8	Hectáreas en tierras labradas con cultivo olivar	es
349	330	8	Fecha de obtención de la información	es
350	331	8	Urbana   Base liquidable (miles de euros)	es
352	332	8	Unidades trabajo-año asalariados eventuales	es
354	333	8	Fondo de contingencia	es
356	334	8	Edificios rehabilitación	es
358	335	8	Personas mano obra familiar cónyuge de 35 a 54 años	es
360	336	8	Hectáreas de SAU en arrendamiento	es
362	339	8	Tipo de nacionalidad	es
364	341	8	Viviendas con evacuación de aguas residuales	es
366	342	8	Código UICN	es
367	343	8	1980-1989	es
369	344	8	Da nombre a	es
370	345	8	Personas que son mano de obra familiar y cónyuges	es
372	346	8	Tiempo desplazamiento	es
374	347	8	BI Oficinas	es
376	354	8	Personas mano obra familiar otros (otra relación) con <35 años	es
378	357	8	Unidades de trabajo que son asalariados fijos	es
380	360	8	Etiqueta	es
381	361	8	Tierras labradas	es
383	371	8	Ganado equino (cabezas)	es
385	373	8	Ocupación (1 dígito) descripción	es
387	374	8	UE28-UE27-UE25	es
389	375	8	Longitud	es
390	376	8	Explotaciones cuyo titular es una cooperativa de producción	es
392	377	8	Ganado porcino-cerdas madres (cabezas)	es
394	378	8	Duración contrato	es
396	379	8	Bonificado o no	es
398	384	8	Identificador de la organización	es
399	385	8	Explotaciones cuya gestión se lleva por un miembro de la familia, no titular	es
401	391	8	Explotaciones con otra condición jurídica	es
403	392	8	Número de explotaciones sin ganado	es
405	394	8	Viviendas, obra nueva, total	es
407	395	8	Explotaciones con máquina en propiedad: otra máquina	es
409	396	8	Depuradoras	es
411	398	8	Espacios Naturales Protegidos	es
413	400	8	Hectáreas en tierras labradas con cultivos frutales	es
415	402	8	Explotaciones que usan maquinaria no en propiedad exclusiva: tractor	es
417	403	8	Viviendas con agua caliente central	es
419	404	8	Dirección	es
420	405	8	Fecha de publicación	es
421	406	8	Transferencias corrientes	es
423	407	8	Rústico, valor catastral	es
425	408	8	Personas mano obra familiar otros de 55 a 64 años	es
427	411	8	1960-1969	es
429	412	8	complementOf	\N
430	413	8	Superficie regada con agua suficiente	es
432	414	8	Información relacionada	es
433	415	8	Teléfono	es
434	417	8	Dimensión	es
435	419	8	Corine Land Cover 2000 nivel 2 descripción	es
437	422	8	BI Suelo vacante	es
439	423	8	Superficie regada (has)	es
441	424	8	Población	es
443	425	8	Personas mano obra familiar son titulares de más de 65 años	es
445	426	8	Pensión Percepciones por persona	es
447	427	8	Explotaciones con máquina en propiedad: motocultor	es
449	428	8	Autorizaciones según tipo	es
450	429	8	Explotaciones cuyo titular es una entidad pública	es
452	430	8	Número de contratos	es
454	431	8	Capa (nombre)	es
455	432	8	Número de viviendas	es
456	433	8	BI Industrial	es
458	434	8	Visados, reforma	es
460	435	8	Superficie regada con concesión individual	es
462	436	8	Número Strahler	es
463	437	8	BI Almacén, estacionamiento	es
465	438	8	Tipo local	es
467	439	8	Número de cabezas	es
469	441	8	Personas asalariadas fijas mujeres	es
471	442	8	Superficie Lugares de Importacia Comunitaria	es
473	444	8	Organización padre	es
474	445	8	VC Religioso	es
475	446	8	Fecha declaración	es
476	447	8	Sector actividad	es
478	453	8	Núcleos en el hogar	es
480	456	8	Área gastos, deuda pública	es
482	458	8	Sección (1 letra) descripción	es
484	461	8	BI Comercial	es
486	462	8	Licencias, rehabilitación, con demolición	es
488	463	8	Viviendas con calefacción	es
490	464	8	Orden	es
492	468	8	Nº personas	es
494	469	8	Área gastos, actuaciones protección y promoción social	es
496	471	8	Personas mano obra familiar con >74,99 y <100% trabajando en explotación	es
497	473	8	Tipo de figura	es
498	475	8	Unidades trabajo-año asalariados	es
500	477	8	Unidades de trabajo/año totales	es
502	478	8	Ascensor	es
504	480	8	Descripción Ocupación	es
506	481	8	Rama descripción	es
508	483	8	Enlace con organización	es
509	484	8	Viviendas, ampliación o reforma	es
511	486	8	VC Sanidad, benefic	es
512	493	8	Hectáreas en tierras labradas de secano otros cultivos	es
514	494	8	Número total de explotaciones	es
516	498	8	VC Espectáculos	es
517	500	8	Personas mano obra familiar cónyuges que trabajan en otra actividad como secundaria	es
518	503	8	Diputados	es
520	505	8	VC Sin definir	es
521	506	8	Explotaciones ganadería	es
523	507	8	Edificios demolición	es
525	508	8	Bancos	es
527	510	8	1950-1959	es
529	512	8	Unidades trabajo-año totales	es
531	513	8	Nombre	es
532	518	8	Ganado ovino (cabezas)	es
534	519	8	Explotaciones con tierras labranza y pastos	es
536	520	8	Superficie total agricultura ecológica	es
538	522	8	BI Deportivo	es
540	523	8	Clase	es
541	525	8	Rama de actividad	es
543	527	8	Ganado porcino-resto porcino (cabezas)	es
545	530	8	Código Autonómico de Autorización del Centro	es
546	531	8	Cuota (euros)	es
548	532	8	Activos financieros	es
550	534	8	VC Oficinas	es
551	535	8	Urbano, valor catastral total	es
553	536	8	Rama	es
555	537	8	Relación lugar de residencia y nacimiento prov	es
557	539	8	Malas comunicaciones	es
559	540	8	Pensión Retribución	es
561	541	8	Superficie regada por gravedad	es
563	542	8	Personas mano obra familiar cónyuges que trabajan también en otra activ. Lucrativa	es
564	543	8	Capa (identificador)	es
565	544	8	Hectáreas en tierras labradas con cultivos herbáceos	es
567	547	8	Unidades de trabajo que siendo mano de obra familiar son otros diferentes	es
569	548	8	REGTENEN ORDEN	es
571	550	8	Hectáreas en tierras labradas con cultivo viñedo	es
573	552	8	Area nacionalidad, nombre	es
575	553	8	Combustible	es
577	554	8	Índice estructura de población activa total	es
579	555	8	Personas que son mano de obra familiar	es
581	556	8	Total Bienes inmuebles	es
583	557	8	Superficie nueva planta, no residencial	es
585	559	8	Rústico, superficie	es
587	560	8	BI Ocio, hostelería	es
589	562	8	Corine Land Cover 2000 nivel 5 descripción	es
591	568	8	Geoposicionamiento	es
592	569	8	Edición	es
593	572	8	Codmun	es
595	573	8	Dependencia funcional	es
596	583	8	Explotaciones que usan maquinaria no en propiedad exclusiva: motocultor	es
598	584	8	Hectáreas en especies arbóreas forestales	es
600	589	8	Area nacionalidad	es
602	595	8	QR	\N
603	596	8	Diputados	es
605	597	8	Sector VAB descripción	es
607	599	8	Latitud	es
608	601	8	Subespecie ganadería descripción	es
610	604	8	Número de actividades	es
612	606	8	Personas mano obra familiar cónyuge <35 años	es
614	608	8	Zona Bachillerato	es
615	609	8	Superficie calificada primer año prácticas	es
617	611	8	Pensión Perceptores	es
619	612	8	Superficie certificaciones privadas	es
620	613	8	Viviendas nuevas	es
622	614	8	ObjectId	\N
623	615	8	Índice de ancianidad	es
625	616	8	Grado	es
627	617	8	Sector actividad, descripción	es
629	618	8	Personas mano obra familiar otros, que sólo trabajan en la explotación	es
630	619	8	Personas mano obra familiar con >24,99 y <50% trabajando en explotación	es
631	620	8	Índice de vejez	es
633	621	8	Código postal	es
634	622	8	Estudios en curso	es
636	623	8	Explotaciones con tierras labranza, pastos y otras	es
638	624	8	CCAA 2ª residencia, nombre	es
640	625	8	Nivel estudios	es
642	626	8	Codcom	es
644	628	8	Ganado bovino (cabezas) 	es
646	629	8	Superficie regada por otros métodos	es
648	630	8	UE25-UE27-UE28	es
650	631	8	Tipo nacionalidad	es
652	632	8	Nivel estudios (agregado)	es
654	634	8	BI Sin definir	es
656	637	8	Ganado bovino-resto bovino (cabezas)	es
658	638	8	Estado del edificio	es
660	639	8	Licencias, nueva planta, con demolición	es
662	640	8	Impuestos directos	es
664	642	8	Descripción	es
665	645	8	VC Edificios singulares	es
666	646	8	Tipo de hogar 2	es
668	647	8	Edad (grandes grupos)	es
670	648	8	Hectáreas en tierras labradas de regadío cultivo viñedo	es
672	649	8	Clase de propietario	es
674	650	8	Fragilidad	es
675	651	8	Edificios nueva planta, no residencial	es
677	652	8	Continente	es
679	653	8	Licencias, nueva planta, total	es
681	654	8	Viviendas en el edificio	es
683	655	8	Hectáreas en tierras labradas de regadío otros cultivos	es
685	656	8	Tipo vivienda	es
687	658	8	Gastos en bienes corrientes y servicios	es
689	659	8	Total	es
691	660	8	Tipo licencias descripción	es
693	661	8	CIF	es
695	662	8	Número de personas en el hogar	es
697	663	8	Situación preferente	es
699	664	8	Enlace con tipo documento	es
700	665	8	Tipo estudios	es
702	666	8	Poca limpieza	es
704	667	8	Esquema de distribución	es
705	668	8	Tipo de vivienda	es
707	669	8	Otras máquinas	es
709	672	8	Duración contrato * 1.00 / Número de contratos	es
711	674	8	Licencias, demolición	es
713	675	8	Rústico, subparcelas	es
715	676	8	Estado de la información	es
717	679	8	Siglas agrupada	es
719	683	8	Legislatura	es
720	686	8	Explotaciones cuyo titular es una sociedad	es
722	691	8	Nacionalidad país nombre	es
724	692	8	Explotaciones que usan maquinaria no en propiedad exclusiva	es
726	693	8	Fecha de suspensión	es
727	694	8	Personas mano obra familiar con <25% trabajando en explotación	es
728	695	8	Afiliaciones en alta	es
730	696	8	Hectáreas en tierras labradas de regadío cultivos herbáceos	es
732	697	8	Explotaciones con tierras con SAU >= 50 y < 100 hectáreas	es
734	698	8	Título	es
735	700	8	Superficie (has)	es
737	701	8	Jefe explotación	es
739	703	8	Personas mano obra familiar son titulares de 35 a 54 años	es
741	709	8	Gastos financieros	es
743	710	8	Salario medio anual	es
745	713	8	Sector	es
747	717	8	Explotaciones con tierras sin SAU	es
749	718	8	Clasificación	es
751	719	8	Provincia	es
752	722	8	Total gastos	es
754	724	8	Área gastos, actuaciones carácter general	es
756	725	8	Área gastos, servicios públicos básicos	es
758	727	8	Especie ganadería	es
760	728	8	BI Espectáculos	es
762	731	8	Cantidad	es
764	732	8	Superficie total	es
766	733	8	Sexo	es
768	736	8	Personas jefes de explotación	es
770	737	8	UE25	es
772	738	8	UE28	es
774	739	8	UE27	es
776	740	8	Horas trabajadas	es
778	741	8	Explotaciones con sólo otras tierras	es
780	742	8	Viviendas, obra nueva, otros	es
782	743	8	CNAE año	es
784	745	8	Año de construcción	es
786	747	8	Superficie forestal afectada	es
788	748	8	Hectáreas en tierras labradas de secano cultivos herbáceos	es
790	749	8	Nº edificios	es
792	750	8	Límite de velocidad (Km/h)	es
793	751	8	1970-1979	es
795	752	8	VC Deportivo	es
796	755	8	Hectáreas de SAU en aparcería	es
798	757	8	VC Industrial	es
799	758	8	Unidades trabajo-año jefe explotación	es
801	759	8	Relación lugar de residencia y nacimiento com	es
803	760	8	Unidades de trabajo que siendo mano de obra familiar son cónyuges	es
805	761	8	Definición de estructura	es
806	762	8	Salario Retribución	es
808	763	8	Área	es
810	764	8	Rama actividad, descripción	es
812	765	8	Viviendas, obra nueva, unifamiliar	es
814	766	8	Email	es
815	768	8	Tipo de vehículo	es
817	771	8	VAB	es
819	772	8	Tamaño medio	es
821	773	8	Documento al que pertenece	es
822	774	8	Unidades de trabajo que son asalariados eventuales	es
824	777	8	Explotaciones cuya gestión se lleva por otra persona	es
826	778	8	Fecha de inicio	es
827	779	8	inverseOf	\N
828	780	8	Censo electoral	es
830	782	8	División (2 dígitos) Descripción	es
832	783	8	Categorías	es
833	785	8	Licencias, rehabilitación, sin demolición	es
835	786	8	Unidades de trabajo que son mano de obra familiar	es
837	787	8	Cajas	es
839	788	8	Altitud	es
840	795	8	Personas mano obra familiar titulares que trabajan también en otra activ. lucrativa	es
841	797	8	Personas mano obra familiar otros de más de 65 años	es
843	798	8	Grupo de tipo de contrato	es
845	800	8	Biografía	es
846	802	8	Personas que son mano de obra familiar y titulares explotación	es
848	803	8	Explotaciones con superficie >=10 y <20 hectáreas	es
850	805	8	Siglas	es
852	806	8	Votos	es
854	808	8	Conejas madres (cabezas)	es
856	810	8	Clasificación	es
857	811	8	unionOf	\N
858	812	8	Viviendas demolición	es
860	814	8	versionInfo	\N
861	815	8	Grado de formación	es
863	816	8	Nº demandantes	es
865	817	8	Personas mano obra familiar sin remuneración	es
867	819	8	Edad (Grupos Quinquenales 2010)	es
869	820	8	Superficie sin clasificar	es
870	822	8	Explotaciones con tierras con SAU totalmente de su propiedad	es
872	823	8	Salario Perceptores	es
874	825	8	Viviendas protegidas	es
876	826	8	Centro	es
877	827	8	Personas mano obra familiar trabajan en otra actividad como principal	es
878	828	8	Personas mano obra familiar sólo trabajan en la explotación	es
879	830	8	Fecha de publicación	es
880	832	8	Personas asalariados fijos total	es
882	838	8	Fecha del documento	es
883	839	8	Mes y año	es
885	841	8	VC Comercial	es
886	843	8	Superficie (km2)	es
888	845	8	Estado	es
890	846	8	Viviendas nueva planta	es
892	851	8	Superficie total (Ha.)	es
894	856	8	Municipio superficie, medida	es
896	857	8	Superficie nueva planta, total	es
898	861	8	Grandes grupos	es
900	863	8	Engarce	es
901	864	8	minCardinality	\N
902	866	8	Stop	\N
903	870	8	CCN	es
904	871	8	Edad (grupos quinquenales)	es
906	872	8	Edad media de la población	es
908	873	8	Tipo de documento	es
909	874	8	Pensión media por persona	es
911	875	8	Porcentaje SAU régimen tenencia	es
913	876	8	BI Religioso	es
915	877	8	Calefacción (agregado)	es
917	878	8	Sector de actividad	es
919	879	8	Gastos de personal	es
921	881	8	Vehículos en el hogar	es
923	883	8	Pastizales permanentes	es
925	884	8	Personas mano obra familiar otros,  trabajan en otra actividad como principal	es
926	885	8	Motocultores	es
928	887	8	Evacuación aguas residuales	es
930	888	8	Sector descripción	es
932	890	8	Viviendas de 2ª mano	es
934	891	8	Hectáreas en tierras labradas de regadío cultivo olivar	es
936	893	8	Tasa de feminidad	es
938	894	8	Tasa de masculinidad	es
940	897	8	Portero	es
942	899	8	Gestión explotación	es
944	901	8	Urbano, parcelas	es
946	902	8	Nº de zona	es
947	903	8	BI Sanidad, benefic	es
949	904	8	Visados, otros	es
951	906	8	Impuestos indirectos	es
953	907	8	Identificador	es
954	908	8	Régimen de tenencia (agregado)	es
956	909	8	Votos a candidaturas	es
958	912	8	Tasa global de dependencia ancianos	es
960	916	8	Enlace con Periodo	es
961	918	8	Explotaciones con tierras con SAU >= 100 hectáreas	es
963	920	8	Residencia país nombre	es
965	924	8	VC Residencial	es
966	925	8	Oferta asistencial	es
967	926	8	Nº Accidentes	es
969	930	8	Accesible	es
971	931	8	Total ingresos	es
973	932	8	Total viviendas	es
975	933	8	Ganado porcino (cabezas)	es
977	934	8	Estado civil	es
979	935	8	Total máquinas	es
981	936	8	Número trabajadores (CC)	es
983	937	8	Índice de potencialidad	es
985	938	8	2010 y posterior	es
987	939	8	Tasa global de dependencia jóvenes	es
989	940	8	Explotaciones con tierras con SAU <5 hectáreas	es
991	941	8	Número de locales	es
993	951	8	Superficie total regada	es
995	952	8	equivalentClass	\N
996	953	8	Subespecie ganadería	es
998	955	8	Fecha	es
999	959	8	Superficie agrícola utilizada	es
1001	960	8	Lugar de nacimiento	es
1003	961	8	Superficie nueva planta, residencial	es
1005	963	8	Fecha de fin	es
1006	965	8	Personas mano obra familiar cónyuge de más de 65 años	es
1008	967	8	Gas	es
1010	969	8	Combustible usado	es
1012	971	8	Incendios	es
1014	973	8	VC Almacén, estacionamiento	es
1015	976	8	Hectáreas en aparcería	es
1017	977	8	Número hogares	es
1019	978	8	Área gastos, total	es
1021	981	8	Superficie Agrícola Utilizada (SAU)	es
1023	987	8	Superficie regada por aspersión	es
1025	990	8	Superficie (Has.)	es
1026	991	8	Personas mano obra familiar son titulares de 55 a 64 años	es
1028	992	8	Explotaciones con superficie >= 50 y <100 hectáreas	es
1030	994	8	Lugares de Importancia Comunitaria	es
1032	995	8	Mes y año	es
1034	997	8	Tipo de presupuesto	es
1036	998	8	sameAs	\N
1037	1000	8	Nivel estudios (detalle)	es
1039	1002	8	Rústica   Cuota (euros)	es
1041	1003	8	Hectáreas en tierras labradas	es
1043	1005	8	Pensión media por percepción	es
1045	1009	8	Plazas garaje	es
1047	1010	8	Kg vidrio doméstico	es
1049	1012	8	Índice de sobreenvejecimiento	es
1051	1013	8	Explotaciones con superficie >= 0,1 y <5 hectáreas	es
1053	1014	8	Personas que son mano de obra familiar distinta a las anteriores (otros)	es
1055	1015	8	Personas mano obra familiar con >49,99 y <75% trabajando en explotación	es
1056	1016	8	Explotaciones cuyo titular es persona física	es
1058	1021	8	Unidades trabajo-año mano obra familiar	es
1060	1022	8	Cosechadoras	es
1062	1023	8	Hectáreas en tierras labradas de regadío	es
1064	1024	8	Superficie Zonas de Especial Protección para las Aves	es
1066	1025	8	Personas mano obra familiar titulares que trabajan en otra actividad como secundaria	es
1067	1026	8	Porcentaje	es
1069	1027	8	Explotaciones con superficie >=5 y <10 hectáreas	es
1071	1028	8	URL	es
1072	1029	8	Unidades ganaderas totales	es
1074	1030	8	Portero automático	es
1076	1031	8	Unidades de trabajo que son asalariados	es
1078	1032	8	Agua caliente central	es
1080	1034	8	Personas mano obra familiar cónyuges que sólo trabajan en la explotación	es
1081	1035	8	Tasas y otros ingresos	es
1083	1036	8	Personas que son mano de obra familiar de 35 a 45 años	es
1085	1037	8	Tipo de estudios realizados	es
1087	1038	8	Concejales	es
1089	1040	8	Códigio dominio	es
1090	1041	8	Año	es
1091	1042	8	Nacionalidad	es
1093	1044	8	Estado	es
1094	1047	8	Tamaño	es
1095	1049	8	Personas que son mano de obra familiar de 55 a 64 años	es
1097	1050	8	Pocas zonas verdes	es
1099	1053	8	Hectáreas en tierras labradas con otros cultivos	es
1101	1054	8	Edificios nueva planta, residencial	es
1103	1055	8	Inversiones reales	es
1105	1056	8	Enlace con organismo	es
1106	1057	8	Nivel	es
1107	1059	8	Descripción	es
1108	1060	8	Autorizaciones	es
1109	1062	8	Nº viviendas	es
1111	1064	8	Votos blancos	es
1113	1066	8	Enlace a expresión legal	es
1114	1069	8	Rústica   Cuota íntegra (euros)	es
1116	1070	8	Abstención	es
1118	1076	8	Hectáreas en tierras labradas de secano cultivo viñedo	es
1120	1077	8	Hectáreas de SAU en propiedad	es
1122	1079	8	Régimen (2 dígitos)	es
1124	1082	8	Intervalo renta	es
1126	1084	8	Personas mano obra familiar cónyuges que trabajan en otra actividad como principal	es
1127	1087	8	Hectáreas en tierras labradas de secano	es
1129	1088	8	Personas mano obra familiar con remuneración	es
1131	1089	8	Viviendas libres	es
1133	1090	8	maxCardinality	\N
1134	1092	8	Hectáreas en arrendamiento	es
1136	1093	8	Superficie calificada agricultura ecológica	es
1138	1094	8	Historia	es
1139	1095	8	Tipo edificio (agregado)	es
1141	1096	8	Kg recogidos papel y cartón	es
1142	1098	8	Personas	es
1144	1099	8	Explotaciones	es
1146	1102	8	Personas mano obra familiar otros de 35 a 54 años	es
1148	1104	8	Salario Percepciones	es
1150	1105	8	Personas mano obra familiar con 100% trabajando en explotación	es
1151	1106	8	Desempleo prestación media anual	es
1153	1107	8	Unidades de trabajo que siendo mano de obra familiar son titulares explotación	es
1155	1109	8	Grupo Antigüedad	es
1157	1111	8	Grupo clase explotación	es
1159	1112	8	Cuentas cotización con trabajadores	es
1161	1113	8	Viviendas con agua corriente	es
1163	1117	8	Comarca	es
1165	1118	8	Contenedores de vidrio	es
1167	1119	8	Explotaciones que usan maquinaria no en propiedad exclusiva otra máquina	es
1169	1120	8	Grandes dominios de paisaje	es
1170	1121	8	Hectáreas en propiedad	es
1172	1123	8	Explotaciones que usan maquinaria propia	es
1174	1124	8	Entidad singular	es
1176	1125	8	Estructura hogar	es
1178	1126	8	Visados, ampliación	es
1180	1127	8	Documento legal de declaración	es
1181	1128	8	Kg recogidos de pilas	es
1183	1129	8	Núcleo	es
1185	1131	8	VC Suelo vacante	es
1186	1132	8	Teléfono	es
1188	1134	8	Ganado bovino-vacas lecheras (cabezas)	es
1190	1137	8	Número de edificios	es
1192	1138	8	Medidas	es
1193	1139	8	Padre	es
1194	1140	8	Organización	es
1195	1142	8	Régimen	es
1197	1146	8	Kg recogidos envases	es
1199	1147	8	Urbano, valor catastral suelo	es
1201	1149	8	Superficie total de las explotaciones	es
1203	1150	8	Índice reemplazamiento edad activa total	es
1205	1151	8	Localidad	es
1206	1152	8	Área gastos, producción bienes públicos carácter preferente	es
1208	1153	8	Ruidos exteriores	es
1210	1159	8	Grupo	es
1212	1160	8	Cooperativas	es
1214	1162	8	Explotaciones con superficie >= 20 y <50 hectáreas	es
1216	1163	8	Empleo	es
1217	1166	8	Viviendas con tendido telefónico	es
1219	1171	8	Viviendas con cuarto de aseo con inodoro	es
1221	1172	8	Renta disponible bruta	es
1223	1173	8	Explotaciones con tierras con SAU >= 10 y < 20 hectáreas	es
1225	1174	8	Orientación	es
1226	1176	8	Índice de juventud	es
1228	1177	8	Fuente	es
1229	1178	8	Nacionalidad, nombre	es
1231	1179	8	Responsable de	es
1232	1181	8	Nº de habitaciones de la vivienda	es
1234	1182	8	Personas mano obra familiar titulares que trabajan en otra actividad como principal	es
1235	1183	8	Enlace al formato	es
1236	1184	8	Fuentes Mineromedicinales	es
1238	1186	8	Subtipo	es
1239	1187	8	Explotaciones con formación universitaria del titular	es
1241	1188	8	Grupos 1 duración demanda descripción	es
1243	1189	8	Nº medio de miembros	es
1245	1190	8	Nacionalidad área nombre	es
1247	1191	8	BI Cultural	es
1249	1192	8	Salario medio por percepción	es
1251	1193	8	Tasa global de dependencia	es
1253	1194	8	Tipo de hogar	es
1255	1195	8	Explotaciones con pastos y otras tierras	es
1257	1196	8	Personas mano obra familiar cónyuge de 55 a 64 años	es
1259	1197	8	Residencia	es
1261	1198	8	Licencias, total	es
1263	1199	8	Cod temporalidad	es
1265	1200	8	Otras tierrras	es
1267	1201	8	equivalentProperty	\N
1268	1202	8	Incluido/a en	es
1269	1205	8	SAU	es
1271	1206	8	Rústica   Base imponible (miles de euros)	es
1273	1208	8	Mes nombre	es
1275	1209	8	Total edificios	es
1277	1210	8	Tractores	es
1279	1212	8	Hectáreas en otras tierras	es
1281	1213	8	Personalidad jurídica	es
1283	1214	8	Ingresos patrimoniales	es
1285	1215	8	Descripción	es
1286	1219	8	Régimen de tenencia (detalle)	es
1288	1220	8	VC Cultural	es
1289	1223	8	Creador	es
1290	1226	8	Superficie regada por riego localizado (goteo, microaspersión, etc.)	es
1292	1227	8	Corine Land Cover 2000 nivel 1 descripción	es
1294	1233	8	Nº habitaciones	es
1296	1234	8	Producción estándar total (euros)	es
1298	1235	8	Entidad relacionada	es
1299	1236	8	Organización	es
1300	1237	8	Viviendas con disponibilidad de ducha o bañera	es
1302	1238	8	Categoría	es
1303	1242	8	Explotaciones con experiencia práctica exclusiva del titular	es
1305	1244	8	Zonas de especial Protección para las Aves	es
1307	1247	8	Unidad fisiográfica	es
1308	1249	8	Rústica   Número de recibos	es
1310	1250	8	Nivel de estudios Nombre	es
1312	1253	8	Total jornadas completas	es
1314	1256	8	Urbano, valor catastral construcción	es
1316	1257	8	Transferencias de capital	es
1318	1258	8	Hectáreas en otros regímenes de tenencia de las tierras	es
1320	1259	8	Código	es
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.annot_types_id_seq', 9, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cc_rels_id_seq', 80, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.class_annots_id_seq', 181, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.classes_id_seq', 206, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cp_rels_id_seq', 3134, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.ns_id_seq', 154, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.properties_id_seq', 1259, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_opendata_aragon_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_opendata_aragon_es_sparql.property_annots_id_seq', 1320, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_opendata_aragon_es_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_opendata_aragon_es_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_opendata_aragon_es_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_opendata_aragon_es_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_opendata_aragon_es_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_opendata_aragon_es_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_opendata_aragon_es_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_opendata_aragon_es_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_opendata_aragon_es_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_opendata_aragon_es_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_opendata_aragon_es_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_opendata_aragon_es_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_opendata_aragon_es_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_opendata_aragon_es_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_opendata_aragon_es_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_opendata_aragon_es_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_opendata_aragon_es_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_opendata_aragon_es_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_opendata_aragon_es_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_opendata_aragon_es_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_opendata_aragon_es_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_opendata_aragon_es_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_opendata_aragon_es_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_opendata_aragon_es_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_opendata_aragon_es_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_opendata_aragon_es_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_opendata_aragon_es_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_opendata_aragon_es_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_opendata_aragon_es_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_opendata_aragon_es_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_opendata_aragon_es_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_opendata_aragon_es_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_opendata_aragon_es_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_opendata_aragon_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_opendata_aragon_es_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_opendata_aragon_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_opendata_aragon_es_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_opendata_aragon_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_opendata_aragon_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_opendata_aragon_es_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_opendata_aragon_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_opendata_aragon_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_opendata_aragon_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_opendata_aragon_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_opendata_aragon_es_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_opendata_aragon_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_opendata_aragon_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_opendata_aragon_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_opendata_aragon_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_opendata_aragon_es_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_opendata_aragon_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_opendata_aragon_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_opendata_aragon_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_opendata_aragon_es_sparql; Owner: -
--

ALTER TABLE ONLY http_opendata_aragon_es_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_opendata_aragon_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

