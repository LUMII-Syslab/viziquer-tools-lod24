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
-- Name: http_datos_bne_es_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_datos_bne_es_sparql;


--
-- Name: SCHEMA http_datos_bne_es_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_datos_bne_es_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE FUNCTION http_datos_bne_es_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE FUNCTION http_datos_bne_es_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_datos_bne_es_sparql; Owner: -
--

COMMENT ON TABLE http_datos_bne_es_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_datos_bne_es_sparql; Owner: -
--

COMMENT ON COLUMN http_datos_bne_es_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_datos_bne_es_sparql.classes c1
     JOIN http_datos_bne_es_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_datos_bne_es_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_datos_bne_es_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_datos_bne_es_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE TABLE http_datos_bne_es_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE http_datos_bne_es_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_datos_bne_es_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_cc_rels AS
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
   FROM http_datos_bne_es_sparql.cc_rels r,
    http_datos_bne_es_sparql.classes c1,
    http_datos_bne_es_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_classes_ns AS
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
    http_datos_bne_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_datos_bne_es_sparql.classes c
     LEFT JOIN http_datos_bne_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_classes_ns_main AS
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
   FROM http_datos_bne_es_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_datos_bne_es_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_classes_ns_plus AS
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
    http_datos_bne_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_datos_bne_es_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_datos_bne_es_sparql.classes c
     LEFT JOIN http_datos_bne_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_classes_ns_main_plus AS
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
   FROM http_datos_bne_es_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_datos_bne_es_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_datos_bne_es_sparql.v_classes_ns v
     LEFT JOIN http_datos_bne_es_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_cp_rels AS
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
    http_datos_bne_es_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_datos_bne_es_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_datos_bne_es_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_datos_bne_es_sparql.cp_rels r,
    http_datos_bne_es_sparql.classes c,
    http_datos_bne_es_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_cp_rels_card AS
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
   FROM http_datos_bne_es_sparql.cp_rels r,
    http_datos_bne_es_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_properties_ns AS
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
    http_datos_bne_es_sparql.tapprox(p.cnt) AS cnt_x,
    http_datos_bne_es_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_datos_bne_es_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_datos_bne_es_sparql.properties p
     LEFT JOIN http_datos_bne_es_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_cp_sources_single AS
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
   FROM ((http_datos_bne_es_sparql.v_cp_rels_card r
     JOIN http_datos_bne_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_datos_bne_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_cp_targets_single AS
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
   FROM ((http_datos_bne_es_sparql.v_cp_rels_card r
     JOIN http_datos_bne_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_datos_bne_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_datos_bne_es_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_datos_bne_es_sparql.pp_rels r,
    http_datos_bne_es_sparql.properties p1,
    http_datos_bne_es_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_properties_sources AS
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
   FROM (http_datos_bne_es_sparql.v_properties_ns v
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
           FROM http_datos_bne_es_sparql.cp_rels r,
            http_datos_bne_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_properties_sources_single AS
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
   FROM (http_datos_bne_es_sparql.v_properties_ns v
     LEFT JOIN http_datos_bne_es_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_properties_targets AS
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
   FROM (http_datos_bne_es_sparql.v_properties_ns v
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
           FROM http_datos_bne_es_sparql.cp_rels r,
            http_datos_bne_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE VIEW http_datos_bne_es_sparql.v_properties_targets_single AS
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
   FROM (http_datos_bne_es_sparql.v_properties_ns v
     LEFT JOIN http_datos_bne_es_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	6	16	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	Corporate Body	en
2	1	8	Entidad Corporativa	es
3	3	8	AnnotationProperty	
4	4	8	Person	en
5	4	8	Persona	es
6	6	8	OntologyProperty	
7	7	8	Concept	en
8	8	8	Ejemplar	es
9	8	8	Item	en
10	9	8	Expresión	es
11	9	8	Expression	en
12	10	8	Ontology	
13	13	8	Work	en
14	13	8	Obra\r\n	es
15	14	8	Class	
16	15	8	Manifestación	es
17	15	8	Manifestation	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
2	https://datos.bne.es/def/C1008	1470	\N	t	69	C1008	C1008	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1480
3	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
5	http://www.w3.org/2000/01/rdf-schema#Class	15	\N	t	2	Class	Class	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43
6	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
7	http://www.w3.org/2004/02/skos/core#Concept	712122	\N	t	4	Concept	Concept	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8390798
10	http://www.w3.org/2002/07/owl#Ontology	1	\N	t	7	Ontology	Ontology	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
12	http://www.w3.org/2004/02/skos/core#ConceptScheme	7	\N	t	4	ConceptScheme	ConceptScheme	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	712122
14	http://www.w3.org/2002/07/owl#Class	3	\N	t	7	Class	Class	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
16	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	23	\N	t	1	Property	Property	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
1	https://datos.bne.es/def/C1006	360741	\N	t	69	C1006	[Corporate Body (C1006)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1844190
4	https://datos.bne.es/def/C1005	1544786	\N	t	69	C1005	[Person (C1005)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6051915
8	https://datos.bne.es/def/C1004	12107047	\N	t	69	C1004	[Ejemplar (C1004)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12107056
9	https://datos.bne.es/def/C1002	1540714	\N	t	69	C1002	[Expresión (C1002)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3538342
13	https://datos.bne.es/def/C1001	2221853	\N	t	69	C1001	[Work (C1001)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3141917
15	https://datos.bne.es/def/C1003	5634229	\N	t	69	C1003	[Manifestación (C1003)]	209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16364364
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	15	1	2	3961479	\N	0	\N	\N	1	1	2	f	3961479	\N	\N
2	15	2	2	5160017	\N	0	\N	\N	1	1	2	f	5160017	\N	\N
3	15	3	2	3890408	\N	0	\N	\N	1	1	2	f	3890408	\N	\N
4	15	4	2	19637	\N	19637	\N	\N	1	1	2	f	0	\N	\N
5	15	4	1	19421	\N	19421	\N	\N	1	1	2	f	\N	\N	\N
6	15	5	2	5143832	\N	0	\N	\N	1	1	2	f	5143832	\N	\N
7	15	6	2	2204803	\N	0	\N	\N	1	1	2	f	2204803	\N	\N
8	15	7	2	1091301	\N	0	\N	\N	1	1	2	f	1091301	\N	\N
9	15	8	2	1700	\N	1700	\N	\N	1	1	2	f	0	\N	\N
10	15	8	1	1308	\N	1308	\N	\N	1	1	2	f	\N	\N	\N
11	15	9	2	1477152	\N	0	\N	\N	1	1	2	f	1477152	\N	\N
12	15	10	2	2348993	\N	0	\N	\N	1	1	2	f	2348993	\N	\N
13	15	11	2	2585576	\N	0	\N	\N	1	1	2	f	2585576	\N	\N
14	7	13	2	207455	\N	0	\N	\N	1	1	2	f	207455	\N	\N
15	15	14	2	5634229	\N	0	\N	\N	1	1	2	f	5634229	\N	\N
16	13	14	2	2221853	\N	0	\N	\N	2	1	2	f	2221853	\N	\N
17	4	14	2	1544786	\N	0	\N	\N	3	1	2	f	1544786	\N	\N
18	9	14	2	1540714	\N	0	\N	\N	4	1	2	f	1540714	\N	\N
19	7	14	2	712122	\N	0	\N	\N	5	1	2	f	712122	\N	\N
20	1	14	2	360741	\N	0	\N	\N	6	1	2	f	360741	\N	\N
21	2	14	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
22	8	14	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
23	15	15	2	110817	\N	110817	\N	\N	1	1	2	f	0	\N	\N
24	15	15	1	93140	\N	93140	\N	\N	1	1	2	f	\N	\N	\N
25	8	15	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
26	10	16	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
27	7	17	2	141203	\N	141203	\N	\N	1	1	2	f	0	\N	\N
28	15	18	2	5552778	\N	0	\N	\N	1	1	2	f	5552778	\N	\N
29	7	19	2	132075	\N	132075	\N	\N	1	1	2	f	0	\N	\N
30	4	19	1	75500	\N	75500	\N	\N	1	1	2	f	\N	\N	\N
31	1	19	1	49484	\N	49484	\N	\N	2	1	2	f	\N	\N	\N
32	13	19	1	6770	\N	6770	\N	\N	3	1	2	f	\N	\N	\N
33	9	19	1	119	\N	119	\N	\N	4	1	2	f	\N	\N	\N
34	7	19	1	35	\N	35	\N	\N	5	1	2	f	\N	\N	\N
35	15	20	2	5476768	\N	0	\N	\N	1	1	2	f	5476768	\N	\N
36	15	21	2	5697065	\N	0	\N	\N	1	1	2	f	5697065	\N	\N
37	15	22	2	12375096	\N	12375096	\N	\N	1	1	2	f	0	\N	\N
38	8	22	1	12107052	\N	12107052	\N	\N	1	1	2	f	\N	\N	\N
39	1	22	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
40	15	23	2	3439195	\N	0	\N	\N	1	1	2	f	3439195	\N	\N
41	15	24	2	1692039	\N	1692039	\N	\N	1	1	2	f	0	\N	\N
42	4	24	1	1692039	\N	1692039	\N	\N	1	1	2	f	\N	\N	\N
43	15	25	2	2014948	\N	2014948	\N	\N	1	1	2	f	0	\N	\N
44	9	25	1	2014948	\N	2014948	\N	\N	1	1	2	f	\N	\N	\N
45	15	26	2	5634208	\N	0	\N	\N	1	1	2	f	5634208	\N	\N
46	15	27	2	5578370	\N	0	\N	\N	1	1	2	f	5578370	\N	\N
47	15	28	2	297767	\N	297767	\N	\N	1	1	2	f	0	\N	\N
48	1	28	1	297767	\N	297767	\N	\N	1	1	2	f	\N	\N	\N
49	8	28	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
50	15	29	2	201660	\N	201660	\N	\N	1	1	2	f	0	\N	\N
51	13	29	1	157452	\N	157452	\N	\N	1	1	2	f	\N	\N	\N
52	9	29	1	32885	\N	32885	\N	\N	2	1	2	f	\N	\N	\N
53	1	29	1	174	\N	174	\N	\N	3	1	2	f	\N	\N	\N
54	4	29	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
55	15	30	2	3642723	\N	3642723	\N	\N	1	1	2	f	0	\N	\N
56	4	30	1	2678298	\N	2678298	\N	\N	1	1	2	f	\N	\N	\N
57	1	30	1	914943	\N	914943	\N	\N	2	1	2	f	\N	\N	\N
58	13	30	1	44446	\N	44446	\N	\N	3	1	2	f	\N	\N	\N
59	9	30	1	3769	\N	3769	\N	\N	4	1	2	f	\N	\N	\N
60	2	30	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
61	15	31	2	21513	\N	21513	\N	\N	1	1	2	f	0	\N	\N
62	15	31	1	21224	\N	21224	\N	\N	1	1	2	f	\N	\N	\N
63	15	32	2	6618736	\N	6618736	\N	\N	1	1	2	f	0	\N	\N
64	7	32	1	6185656	\N	6185656	\N	\N	1	1	2	f	\N	\N	\N
65	4	32	1	265575	\N	265575	\N	\N	2	1	2	f	\N	\N	\N
66	1	32	1	106315	\N	106315	\N	\N	3	1	2	f	\N	\N	\N
67	13	32	1	55904	\N	55904	\N	\N	4	1	2	f	\N	\N	\N
68	9	32	1	781	\N	781	\N	\N	5	1	2	f	\N	\N	\N
69	8	33	2	12107052	\N	12107052	\N	\N	1	1	2	f	0	\N	\N
70	1	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
71	15	33	1	12107052	\N	12107052	\N	\N	1	1	2	f	\N	\N	\N
72	2	34	2	1485	\N	0	\N	\N	1	1	2	f	1485	\N	\N
73	4	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
74	2	35	2	1958	\N	0	\N	\N	1	1	2	f	1958	\N	\N
75	4	35	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
76	2	37	2	355	\N	0	\N	\N	1	1	2	f	355	\N	\N
77	4	37	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
78	2	38	2	1485	\N	0	\N	\N	1	1	2	f	1485	\N	\N
79	4	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
80	2	39	2	1478	\N	0	\N	\N	1	1	2	f	1478	\N	\N
81	4	39	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
82	4	40	2	1154078	\N	1154078	\N	\N	1	1	2	f	0	\N	\N
83	1	40	2	111531	\N	111531	\N	\N	2	1	2	f	0	\N	\N
84	13	40	2	71970	\N	71970	\N	\N	3	1	2	f	0	\N	\N
85	9	40	2	16128	\N	16128	\N	\N	4	1	2	f	0	\N	\N
86	7	40	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
87	2	40	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
88	16	41	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
89	7	42	2	78591	\N	0	\N	\N	1	1	2	f	78591	\N	\N
90	14	43	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
91	15	44	2	5502937	\N	5502937	\N	\N	1	1	2	f	0	\N	\N
92	15	46	2	5634208	\N	0	\N	\N	1	1	2	f	5634208	\N	\N
93	13	46	2	2221275	\N	0	\N	\N	2	1	2	f	2221275	\N	\N
94	4	46	2	1544786	\N	0	\N	\N	3	1	2	f	1544786	\N	\N
95	7	46	2	712122	\N	0	\N	\N	4	1	2	f	712122	\N	\N
96	1	46	2	360741	\N	0	\N	\N	5	1	2	f	360741	\N	\N
97	16	46	2	23	\N	0	\N	\N	6	1	2	f	23	\N	\N
98	12	46	2	7	\N	0	\N	\N	7	1	2	f	7	\N	\N
99	14	46	2	2	\N	0	\N	\N	8	1	2	f	2	\N	\N
100	5	46	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
101	6	46	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
102	2	46	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
103	3	46	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
104	8	46	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
105	7	47	2	788885	\N	0	\N	\N	1	1	2	f	788885	\N	\N
106	7	48	2	23875	\N	0	\N	\N	1	1	2	f	23875	\N	\N
107	15	49	2	138	\N	0	\N	\N	1	1	2	f	138	\N	\N
108	15	50	2	25834	\N	0	\N	\N	1	1	2	f	25834	\N	\N
109	15	51	2	3711	\N	0	\N	\N	1	1	2	f	3711	\N	\N
110	15	52	2	5415	\N	0	\N	\N	1	1	2	f	5415	\N	\N
111	15	53	2	737	\N	0	\N	\N	1	1	2	f	737	\N	\N
112	15	54	2	828	\N	0	\N	\N	1	1	2	f	828	\N	\N
113	7	55	2	6364	\N	0	\N	\N	1	1	2	f	6364	\N	\N
114	15	56	2	10773	\N	0	\N	\N	1	1	2	f	10773	\N	\N
115	15	57	2	11366	\N	0	\N	\N	1	1	2	f	11366	\N	\N
116	15	58	2	1980	\N	0	\N	\N	1	1	2	f	1980	\N	\N
117	15	59	2	9494	\N	0	\N	\N	1	1	2	f	9494	\N	\N
118	8	60	2	12107047	\N	0	\N	\N	1	1	2	f	12107047	\N	\N
119	1	60	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
120	15	61	2	15685	\N	0	\N	\N	1	1	2	f	15685	\N	\N
121	15	62	2	23356	\N	0	\N	\N	1	1	2	f	23356	\N	\N
122	15	63	2	17259	\N	0	\N	\N	1	1	2	f	17259	\N	\N
123	15	64	2	42891	\N	0	\N	\N	1	1	2	f	42891	\N	\N
124	15	65	2	78177	\N	0	\N	\N	1	1	2	f	78177	\N	\N
125	8	66	2	12107063	\N	0	\N	\N	1	1	2	f	12107063	\N	\N
126	1	66	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
127	15	67	2	74610	\N	0	\N	\N	1	1	2	f	74610	\N	\N
128	4	68	2	19453	\N	0	\N	\N	1	1	2	f	19453	\N	\N
129	2	68	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
130	15	69	2	26659	\N	0	\N	\N	1	1	2	f	26659	\N	\N
131	15	70	2	47733	\N	0	\N	\N	1	1	2	f	47733	\N	\N
132	15	71	2	89416	\N	0	\N	\N	1	1	2	f	89416	\N	\N
133	8	72	2	1204644	\N	0	\N	\N	1	1	2	f	1204644	\N	\N
134	11	73	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
135	15	74	2	111468	\N	0	\N	\N	1	1	2	f	111468	\N	\N
136	14	75	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
137	14	75	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
138	7	76	2	64996	\N	64996	\N	\N	1	1	2	f	0	\N	\N
139	7	76	1	64196	\N	64196	\N	\N	1	1	2	f	\N	\N	\N
140	1	76	1	523	\N	523	\N	\N	2	1	2	f	\N	\N	\N
141	13	76	1	170	\N	170	\N	\N	3	1	2	f	\N	\N	\N
142	4	76	1	93	\N	93	\N	\N	4	1	2	f	\N	\N	\N
143	15	77	2	196877	\N	0	\N	\N	1	1	2	f	196877	\N	\N
144	15	78	2	83302	\N	0	\N	\N	1	1	2	f	83302	\N	\N
145	15	79	2	46584	\N	0	\N	\N	1	1	2	f	46584	\N	\N
146	8	80	2	12107047	\N	0	\N	\N	1	1	2	f	12107047	\N	\N
147	1	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
148	15	81	2	77471	\N	0	\N	\N	1	1	2	f	77471	\N	\N
149	15	82	2	64996	\N	0	\N	\N	1	1	2	f	64996	\N	\N
150	8	83	2	12107052	\N	0	\N	\N	1	1	2	f	12107052	\N	\N
151	1	83	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
152	15	84	2	145477	\N	0	\N	\N	1	1	2	f	145477	\N	\N
153	15	85	2	129188	\N	0	\N	\N	1	1	2	f	129188	\N	\N
154	15	86	2	123612	\N	0	\N	\N	1	1	2	f	123612	\N	\N
155	15	87	2	330845	\N	0	\N	\N	1	1	2	f	330845	\N	\N
156	12	88	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
157	10	88	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
158	15	89	2	137085	\N	0	\N	\N	1	1	2	f	137085	\N	\N
159	15	90	2	187723	\N	0	\N	\N	1	1	2	f	187723	\N	\N
160	16	91	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
161	6	91	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
162	14	91	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
163	5	91	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
164	15	92	2	594624	\N	0	\N	\N	1	1	2	f	594624	\N	\N
165	15	93	2	1073587	\N	0	\N	\N	1	1	2	f	1073587	\N	\N
166	4	94	2	1692997	\N	1692997	\N	\N	1	1	2	f	0	\N	\N
167	15	94	1	1692039	\N	1692039	\N	\N	1	1	2	f	\N	\N	\N
168	15	95	2	415326	\N	0	\N	\N	1	1	2	f	415326	\N	\N
169	15	96	2	372171	\N	0	\N	\N	1	1	2	f	372171	\N	\N
170	15	97	2	321891	\N	0	\N	\N	1	1	2	f	321891	\N	\N
171	15	98	2	307537	\N	0	\N	\N	1	1	2	f	307537	\N	\N
172	4	99	2	1281163	\N	1281163	\N	\N	1	1	2	f	0	\N	\N
173	13	99	1	1281154	\N	1281154	\N	\N	1	1	2	f	\N	\N	\N
174	4	99	1	9	\N	9	\N	\N	2	1	2	f	\N	\N	\N
175	15	100	2	270771	\N	0	\N	\N	1	1	2	f	270771	\N	\N
176	4	101	2	10500	\N	10500	\N	\N	1	1	2	f	0	\N	\N
177	4	101	1	10488	\N	10488	\N	\N	1	1	2	f	\N	\N	\N
178	15	102	2	707621	\N	0	\N	\N	1	1	2	f	707621	\N	\N
179	15	103	2	359499	\N	0	\N	\N	1	1	2	f	359499	\N	\N
180	4	104	2	1211	\N	1211	\N	\N	1	1	2	f	0	\N	\N
181	2	104	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
182	2	104	1	1211	\N	1211	\N	\N	1	1	2	f	\N	\N	\N
183	4	104	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
184	15	105	2	529244	\N	0	\N	\N	1	1	2	f	529244	\N	\N
185	15	106	2	537316	\N	0	\N	\N	1	1	2	f	537316	\N	\N
186	4	107	2	8914	\N	8914	\N	\N	1	1	2	f	0	\N	\N
187	1	107	1	8913	\N	8913	\N	\N	1	1	2	f	\N	\N	\N
188	1	108	2	1712	\N	0	\N	\N	1	1	2	f	1712	\N	\N
189	1	109	2	26777	\N	0	\N	\N	1	1	2	f	26777	\N	\N
190	7	110	2	105889	\N	0	\N	\N	1	1	2	f	105889	\N	\N
191	13	110	2	25208	\N	0	\N	\N	2	1	2	f	25208	\N	\N
192	1	111	2	31004	\N	0	\N	\N	1	1	2	f	31004	\N	\N
193	1	112	2	6992	\N	0	\N	\N	1	1	2	f	6992	\N	\N
194	1	113	2	13651	\N	0	\N	\N	1	1	2	f	13651	\N	\N
195	1	114	2	5383	\N	0	\N	\N	1	1	2	f	5383	\N	\N
196	1	116	2	298693	\N	298693	\N	\N	1	1	2	f	0	\N	\N
197	8	116	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
198	15	116	1	297767	\N	297767	\N	\N	1	1	2	f	\N	\N	\N
199	1	117	2	53808	\N	53808	\N	\N	1	1	2	f	0	\N	\N
200	1	117	1	53808	\N	53808	\N	\N	1	1	2	f	\N	\N	\N
201	1	118	2	9431	\N	0	\N	\N	1	1	2	f	9431	\N	\N
202	1	119	2	53808	\N	53808	\N	\N	1	1	2	f	0	\N	\N
203	1	119	1	53808	\N	53808	\N	\N	1	1	2	f	\N	\N	\N
204	1	120	2	58242	\N	0	\N	\N	1	1	2	f	58242	\N	\N
205	8	120	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
206	1	121	2	99042	\N	99042	\N	\N	1	1	2	f	0	\N	\N
207	13	121	2	76	\N	76	\N	\N	2	1	2	f	0	\N	\N
208	13	121	1	99094	\N	99094	\N	\N	1	1	2	f	\N	\N	\N
209	1	121	1	24	\N	24	\N	\N	2	1	2	f	\N	\N	\N
210	1	122	2	15923	\N	0	\N	\N	1	1	2	f	15923	\N	\N
211	1	123	2	66726	\N	0	\N	\N	1	1	2	f	66726	\N	\N
212	8	123	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
213	1	124	2	139784	\N	0	\N	\N	1	1	2	f	139784	\N	\N
214	1	125	2	19916	\N	19916	\N	\N	1	1	2	f	0	\N	\N
215	1	125	1	19914	\N	19914	\N	\N	1	1	2	f	\N	\N	\N
216	1	126	2	78224	\N	0	\N	\N	1	1	2	f	78224	\N	\N
217	1	127	2	266	\N	266	\N	\N	1	1	2	f	0	\N	\N
218	2	127	1	266	\N	266	\N	\N	1	1	2	f	\N	\N	\N
219	1	128	2	75960	\N	0	\N	\N	1	1	2	f	75960	\N	\N
220	8	128	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
221	1	129	2	360757	\N	0	\N	\N	1	1	2	f	360757	\N	\N
222	8	129	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
223	15	130	2	15848	\N	0	\N	\N	1	1	2	f	15848	\N	\N
224	1	131	2	8778	\N	8778	\N	\N	1	1	2	f	0	\N	\N
225	4	131	1	8760	\N	8760	\N	\N	1	1	2	f	\N	\N	\N
226	15	132	2	30530	\N	0	\N	\N	1	1	2	f	30530	\N	\N
227	15	133	2	40973	\N	0	\N	\N	1	1	2	f	40973	\N	\N
228	15	134	2	472044	\N	0	\N	\N	1	1	2	f	472044	\N	\N
229	15	135	2	157208	\N	0	\N	\N	1	1	2	f	157208	\N	\N
230	10	136	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
231	4	137	2	1589821	\N	0	\N	\N	1	1	2	f	1589821	\N	\N
232	1	137	2	287196	\N	0	\N	\N	2	1	2	f	287196	\N	\N
233	13	137	2	261232	\N	0	\N	\N	3	1	2	f	261232	\N	\N
234	2	137	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
235	15	138	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
236	15	139	2	158536	\N	0	\N	\N	1	1	2	f	158536	\N	\N
237	4	140	2	964789	\N	0	\N	\N	1	1	2	f	964789	\N	\N
238	2	140	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
239	11	141	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
240	15	142	2	112594	\N	0	\N	\N	1	1	2	f	112594	\N	\N
241	15	143	2	3070	\N	0	\N	\N	1	1	2	f	3070	\N	\N
242	15	144	2	6175	\N	0	\N	\N	1	1	2	f	6175	\N	\N
243	14	145	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
244	15	146	2	74174	\N	0	\N	\N	1	1	2	f	74174	\N	\N
245	11	147	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
246	11	147	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
247	10	148	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
248	15	149	2	3611	\N	0	\N	\N	1	1	2	f	3611	\N	\N
249	7	150	2	58738	\N	58738	\N	\N	1	1	2	f	0	\N	\N
250	7	150	1	58638	\N	58638	\N	\N	1	1	2	f	\N	\N	\N
251	1	150	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
252	4	150	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
253	4	152	2	8916	\N	0	\N	\N	1	1	2	f	8916	\N	\N
254	15	153	2	6404	\N	0	\N	\N	1	1	2	f	6404	\N	\N
255	4	154	2	722	\N	0	\N	\N	1	1	2	f	722	\N	\N
256	2	154	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
257	15	155	2	2925	\N	2925	\N	\N	1	1	2	f	0	\N	\N
258	15	155	1	2817	\N	2817	\N	\N	1	1	2	f	\N	\N	\N
259	4	156	2	461061	\N	0	\N	\N	1	1	2	f	461061	\N	\N
260	2	156	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
261	15	157	2	486	\N	0	\N	\N	1	1	2	f	486	\N	\N
262	4	158	2	6462	\N	0	\N	\N	1	1	2	f	6462	\N	\N
263	2	158	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
264	15	159	2	9271	\N	0	\N	\N	1	1	2	f	9271	\N	\N
265	15	160	2	49186	\N	49186	\N	\N	1	1	2	f	0	\N	\N
266	15	160	1	46788	\N	46788	\N	\N	1	1	2	f	\N	\N	\N
267	8	160	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
268	4	161	2	285003	\N	0	\N	\N	1	1	2	f	285003	\N	\N
269	2	161	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
270	4	162	2	109868	\N	0	\N	\N	1	1	2	f	109868	\N	\N
271	2	162	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
272	15	163	2	142431	\N	142431	\N	\N	1	1	2	f	0	\N	\N
273	15	163	1	64511	\N	64511	\N	\N	1	1	2	f	\N	\N	\N
274	15	164	2	3381	\N	3381	\N	\N	1	1	2	f	0	\N	\N
275	15	164	1	3348	\N	3348	\N	\N	1	1	2	f	\N	\N	\N
276	7	165	2	59327	\N	59327	\N	\N	1	1	2	f	0	\N	\N
277	7	165	1	58302	\N	58302	\N	\N	1	1	2	f	\N	\N	\N
278	1	165	1	820	\N	820	\N	\N	2	1	2	f	\N	\N	\N
279	13	165	1	122	\N	122	\N	\N	3	1	2	f	\N	\N	\N
280	4	165	1	52	\N	52	\N	\N	4	1	2	f	\N	\N	\N
281	1	166	2	16726	\N	0	\N	\N	1	1	2	f	16726	\N	\N
282	1	167	2	32407	\N	0	\N	\N	1	1	2	f	32407	\N	\N
283	11	168	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
284	4	169	2	1219	\N	0	\N	\N	1	1	2	f	1219	\N	\N
285	4	170	2	10041	\N	0	\N	\N	1	1	2	f	10041	\N	\N
286	4	171	2	18662	\N	0	\N	\N	1	1	2	f	18662	\N	\N
287	4	172	2	10520	\N	0	\N	\N	1	1	2	f	10520	\N	\N
288	15	173	2	265107	\N	265107	\N	\N	1	1	2	f	0	\N	\N
289	9	173	2	94965	\N	94965	\N	\N	2	1	2	f	0	\N	\N
290	13	173	2	89285	\N	89285	\N	\N	3	1	2	f	0	\N	\N
291	4	173	2	30343	\N	0	\N	\N	4	1	2	f	30343	\N	\N
292	1	173	2	6	\N	4	\N	\N	5	1	2	f	2	\N	\N
293	4	174	2	48876	\N	0	\N	\N	1	1	2	f	48876	\N	\N
294	13	175	2	1281154	\N	1281154	\N	\N	1	1	2	f	0	\N	\N
295	4	175	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
296	4	175	1	1281163	\N	1281163	\N	\N	1	1	2	f	\N	\N	\N
297	4	176	2	16566	\N	0	\N	\N	1	1	2	f	16566	\N	\N
298	15	177	2	44021	\N	0	\N	\N	1	1	2	f	44021	\N	\N
299	4	178	2	1544786	\N	0	\N	\N	1	1	2	f	1544786	\N	\N
300	2	178	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
301	13	179	2	2331	\N	2331	\N	\N	1	1	2	f	0	\N	\N
302	13	179	1	2331	\N	2331	\N	\N	1	1	2	f	\N	\N	\N
303	4	180	2	39079	\N	0	\N	\N	1	1	2	f	39079	\N	\N
304	1	180	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
305	4	181	2	348407	\N	0	\N	\N	1	1	2	f	348407	\N	\N
306	2	181	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
307	13	182	2	1481966	\N	1481966	\N	\N	1	1	2	f	0	\N	\N
308	1	182	2	137	\N	137	\N	\N	2	1	2	f	0	\N	\N
309	4	182	2	22	\N	22	\N	\N	3	1	2	f	0	\N	\N
310	9	182	2	11	\N	11	\N	\N	4	1	2	f	0	\N	\N
311	9	182	1	1482136	\N	1482136	\N	\N	1	1	2	f	\N	\N	\N
312	13	183	2	99094	\N	99094	\N	\N	1	1	2	f	0	\N	\N
313	1	183	2	24	\N	24	\N	\N	2	1	2	f	0	\N	\N
314	1	183	1	99042	\N	99042	\N	\N	1	1	2	f	\N	\N	\N
315	13	183	1	76	\N	76	\N	\N	2	1	2	f	\N	\N	\N
316	15	184	2	2077786	\N	0	\N	\N	1	1	2	f	2077786	\N	\N
317	13	185	2	2331	\N	2331	\N	\N	1	1	2	f	0	\N	\N
318	13	185	1	2331	\N	2331	\N	\N	1	1	2	f	\N	\N	\N
319	15	186	2	2291207	\N	0	\N	\N	1	1	2	f	2291207	\N	\N
320	15	187	2	5627326	\N	0	\N	\N	1	1	2	f	5627326	\N	\N
321	15	188	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
322	15	189	2	311	\N	0	\N	\N	1	1	2	f	311	\N	\N
323	4	190	2	1949	\N	0	\N	\N	1	1	2	f	1949	\N	\N
324	4	191	2	127592	\N	0	\N	\N	1	1	2	f	127592	\N	\N
325	2	191	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
326	4	192	2	19871	\N	0	\N	\N	1	1	2	f	19871	\N	\N
327	2	192	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
328	4	193	2	1021709	\N	0	\N	\N	1	1	2	f	1021709	\N	\N
329	2	193	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
330	7	194	2	712122	\N	712122	\N	\N	1	1	2	f	0	\N	\N
331	12	194	1	712122	\N	712122	\N	\N	1	1	2	f	\N	\N	\N
332	9	195	2	52142	\N	0	\N	\N	1	1	2	f	52142	\N	\N
333	9	196	2	1482136	\N	1482136	\N	\N	1	1	2	f	0	\N	\N
334	13	196	1	1481966	\N	1481966	\N	\N	1	1	2	f	\N	\N	\N
335	1	196	1	137	\N	137	\N	\N	2	1	2	f	\N	\N	\N
336	4	196	1	22	\N	22	\N	\N	3	1	2	f	\N	\N	\N
337	9	196	1	11	\N	11	\N	\N	4	1	2	f	\N	\N	\N
338	5	197	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
339	5	197	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
340	9	198	2	2091116	\N	2091116	\N	\N	1	1	2	f	0	\N	\N
341	15	198	1	2014949	\N	2014949	\N	\N	1	1	2	f	\N	\N	\N
342	9	199	2	1713	\N	1713	\N	\N	1	1	2	f	0	\N	\N
343	13	199	2	196	\N	196	\N	\N	2	1	2	f	0	\N	\N
344	9	199	1	1909	\N	1909	\N	\N	1	1	2	f	\N	\N	\N
345	9	200	2	1909	\N	1909	\N	\N	1	1	2	f	0	\N	\N
346	9	200	1	1713	\N	1713	\N	\N	1	1	2	f	\N	\N	\N
347	13	200	1	196	\N	196	\N	\N	2	1	2	f	\N	\N	\N
348	9	201	2	1467775	\N	0	\N	\N	1	1	2	f	1467775	\N	\N
349	7	202	2	86687	\N	86687	\N	\N	1	1	2	f	0	\N	\N
350	16	203	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
351	6	203	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
352	14	203	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
353	5	203	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
354	13	205	2	928241	\N	928241	\N	\N	1	1	2	f	0	\N	\N
355	1	205	2	121	\N	121	\N	\N	2	1	2	f	0	\N	\N
356	4	205	2	23	\N	23	\N	\N	3	1	2	f	0	\N	\N
357	9	205	2	16	\N	16	\N	\N	4	1	2	f	0	\N	\N
358	7	205	1	863784	\N	863784	\N	\N	1	1	2	f	\N	\N	\N
359	4	205	1	38701	\N	38701	\N	\N	2	1	2	f	\N	\N	\N
360	1	205	1	15502	\N	15502	\N	\N	3	1	2	f	\N	\N	\N
361	13	205	1	9905	\N	9905	\N	\N	4	1	2	f	\N	\N	\N
362	9	205	1	71	\N	71	\N	\N	5	1	2	f	\N	\N	\N
363	7	206	2	1384683	\N	1384683	\N	\N	1	1	2	f	0	\N	\N
364	7	206	1	1160187	\N	1160187	\N	\N	1	1	2	f	\N	\N	\N
365	1	206	1	222733	\N	222733	\N	\N	2	1	2	f	\N	\N	\N
366	15	207	2	211832	\N	211832	\N	\N	1	1	2	f	0	\N	\N
367	4	207	2	177984	\N	46332	\N	\N	2	1	2	f	131652	\N	\N
368	1	207	2	27433	\N	4	\N	\N	3	1	2	f	27429	\N	\N
369	2	207	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
370	7	208	2	163820	\N	0	\N	\N	1	1	2	f	163820	\N	\N
371	8	209	2	12107048	\N	12107048	\N	\N	1	1	2	f	0	\N	\N
372	15	209	2	5634229	\N	5634229	\N	\N	2	1	2	f	0	\N	\N
373	13	209	2	2221853	\N	2221853	\N	\N	3	1	2	f	0	\N	\N
374	4	209	2	1544788	\N	1544788	\N	\N	4	1	2	f	0	\N	\N
375	9	209	2	1540714	\N	1540714	\N	\N	5	1	2	f	0	\N	\N
376	7	209	2	712122	\N	712122	\N	\N	6	1	2	f	0	\N	\N
377	1	209	2	360742	\N	360742	\N	\N	7	1	2	f	0	\N	\N
378	2	209	2	1472	\N	1472	\N	\N	8	1	2	f	0	\N	\N
379	16	209	2	28	\N	28	\N	\N	9	1	2	f	0	\N	\N
380	12	209	2	7	\N	7	\N	\N	10	1	2	f	0	\N	\N
381	3	209	2	6	\N	6	\N	\N	11	1	2	f	0	\N	\N
382	14	209	2	3	\N	3	\N	\N	12	1	2	f	0	\N	\N
383	11	209	2	1	\N	1	\N	\N	13	1	2	f	0	\N	\N
384	10	209	2	1	\N	1	\N	\N	14	1	2	f	0	\N	\N
385	5	209	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
386	6	209	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
387	5	209	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
388	10	210	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
389	13	211	2	8688	\N	0	\N	\N	1	1	2	f	8688	\N	\N
390	2	212	2	1211	\N	1211	\N	\N	1	1	2	f	0	\N	\N
391	4	212	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
392	4	212	1	1211	\N	1211	\N	\N	1	1	2	f	\N	\N	\N
393	2	212	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
394	2	213	2	266	\N	266	\N	\N	1	1	2	f	0	\N	\N
395	1	213	1	266	\N	266	\N	\N	1	1	2	f	\N	\N	\N
396	13	214	2	67263	\N	0	\N	\N	1	1	2	f	67263	\N	\N
397	13	215	2	27398	\N	0	\N	\N	1	1	2	f	27398	\N	\N
398	1	216	2	10085	\N	0	\N	\N	1	1	2	f	10085	\N	\N
399	4	216	2	7670	\N	0	\N	\N	2	1	2	f	7670	\N	\N
400	13	216	2	1778	\N	0	\N	\N	3	1	2	f	1778	\N	\N
401	13	217	2	13823	\N	0	\N	\N	1	1	2	f	13823	\N	\N
402	13	218	2	37045	\N	0	\N	\N	1	1	2	f	37045	\N	\N
403	1	219	2	90554	\N	0	\N	\N	1	1	2	f	90554	\N	\N
404	13	220	2	403	\N	0	\N	\N	1	1	2	f	403	\N	\N
405	15	221	2	3413563	\N	0	\N	\N	1	1	2	f	3413563	\N	\N
406	13	221	2	1415863	\N	0	\N	\N	2	1	2	f	1415863	\N	\N
407	7	223	2	4404	\N	0	\N	\N	1	1	2	f	4404	\N	\N
408	4	228	2	30013	\N	0	\N	\N	1	1	2	f	30013	\N	\N
409	2	228	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
410	4	229	2	80935	\N	0	\N	\N	1	1	2	f	80935	\N	\N
411	7	230	2	23849	\N	0	\N	\N	1	1	2	f	23849	\N	\N
412	4	231	2	5924	\N	0	\N	\N	1	1	2	f	5924	\N	\N
413	4	232	2	3035	\N	0	\N	\N	1	1	2	f	3035	\N	\N
414	4	233	2	341886	\N	0	\N	\N	1	1	2	f	341886	\N	\N
415	2	233	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
416	4	234	2	254018	\N	0	\N	\N	1	1	2	f	254018	\N	\N
417	13	235	2	2221275	\N	0	\N	\N	1	1	2	f	2221275	\N	\N
418	4	236	2	1588364	\N	0	\N	\N	1	1	2	f	1588364	\N	\N
419	1	236	2	286174	\N	0	\N	\N	2	1	2	f	286174	\N	\N
420	13	236	2	260640	\N	0	\N	\N	3	1	2	f	260640	\N	\N
421	2	236	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
422	4	237	2	1464223	\N	0	\N	\N	1	1	2	f	1464223	\N	\N
423	1	237	2	254941	\N	0	\N	\N	2	1	2	f	254941	\N	\N
424	13	237	2	218948	\N	0	\N	\N	3	1	2	f	218948	\N	\N
425	2	237	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
426	13	238	2	105493	\N	0	\N	\N	1	1	2	f	105493	\N	\N
427	1	240	2	156	\N	0	\N	\N	1	1	2	f	156	\N	\N
428	11	241	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
429	11	241	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		https://datos.bne.es/def/	0	t	0
70	madsrdf	http://www.loc.gov/mads/rdf/v1#	0	f	0
71	rdaa	http://www.rdaregistry.info/Elements/a/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_datos_bne_es_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_datos_bne_es_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://datos.bne.es/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://datos.bne.es/sparql", "correlationId": "8461581245235565521", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-09-05T13:07:40.423Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
4	https://datos.bne.es/def/OP3010	19637	\N	69	OP3010	OP3010	f	19637	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
8	https://datos.bne.es/def/OP3011	1700	\N	69	OP3011	OP3011	f	1700	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/2002/07/owl#equivalentClass	1	\N	7	equivalentClass	equivalentClass	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://www.loc.gov/mads/rdf/v1#citationSource	207455	\N	70	citationSource	citationSource	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
14	https://datos.bne.es/def/id	12014445	\N	69	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://purl.org/dc/terms/relation	110817	\N	5	relation	relation	f	110817	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.w3.org/2004/02/skos/core#closeMatch	141203	\N	4	closeMatch	closeMatch	f	141203	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://www.loc.gov/mads/rdf/v1#hasRelatedAuthority	132075	\N	70	hasRelatedAuthority	hasRelatedAuthority	f	132075	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
31	https://datos.bne.es/def/OP3009	21513	\N	69	OP3009	OP3009	f	21513	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
34	https://datos.bne.es/def/P8005	1485	\N	69	P8005	P8005	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
35	https://datos.bne.es/def/P8004	1958	\N	69	P8004	P8004	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://purl.org/dc/terms/modified	750	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
37	https://datos.bne.es/def/P8003	355	\N	69	P8003	P8003	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
38	https://datos.bne.es/def/P8002	1485	\N	69	P8002	P8002	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
39	https://datos.bne.es/def/P8001	1478	\N	69	P8001	P8001	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/2002/07/owl#sameAs	1353753	\N	7	sameAs	sameAs	f	1353753	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	2	\N	2	subPropertyOf	subPropertyOf	f	2	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/2004/02/skos/core#notation	78591	\N	4	notation	notation	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	2	\N	1	first	first	f	2	\N	\N	f	f	\N	14	\N	t	f	\N	\N	\N	t	f	f
44	http://purl.org/dc/terms/language	5502937	\N	5	language	language	f	5502937	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/dc/terms/extent	733	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.w3.org/2000/01/rdf-schema#label	10473179	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.w3.org/2004/02/skos/core#prefLabel	788885	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.w3.org/2003/01/geo/wgs84_pos#long	23875	\N	25	long	long	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
2	https://datos.bne.es/def/P3007	5160017	\N	69	[has dimensions (P3007)]	P3007	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
3	https://datos.bne.es/def/P3009	3890408	\N	69	[Identifier for the manifestation (P3009)]	P3009	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
5	https://datos.bne.es/def/P3015	5143832	\N	69	[has note (P3015)]	P3015	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
6	https://datos.bne.es/def/P3014	2204803	\N	69	[tiene información complementaria del título (P3014)]	P3014	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
7	https://datos.bne.es/def/P3017	1091301	\N	69	[has edition statement (P3017)]	P3017	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
10	https://datos.bne.es/def/P3013	2348993	\N	69	[ISBN (P3013)]	P3013	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
11	https://datos.bne.es/def/P3012	2585576	\N	69	[has other physical details (P3012)]	P3012	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
18	https://datos.bne.es/def/P3004	5552778	\N	69	[has specific material designation and extent (P3004)]	P3004	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
20	https://datos.bne.es/def/P3003	5476768	\N	69	[has place of publication, production, distribution (P3003)]	P3003	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
22	https://datos.bne.es/def/OP3001	12375096	\N	69	[está ejemplificado por (OP3001)]	OP3001	f	12375096	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
23	https://datos.bne.es/def/P3005	3439195	\N	69	[tiene mención de forma del contenido y de tipo d.. (P3005)]	P3005	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
24	https://datos.bne.es/def/OP3003	1692039	\N	69	[es creada (manifestación) por (persona) (OP3003)]	OP3003	f	1692039	\N	\N	f	f	15	4	\N	t	f	\N	\N	\N	t	f	f
26	https://datos.bne.es/def/P3002	5634208	\N	69	[has title proper (P3002)]	P3002	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
27	https://datos.bne.es/def/P3001	5578370	\N	69	[has name of publisher, producer, distributor (P3001)]	P3001	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
28	https://datos.bne.es/def/OP3004	297767	\N	69	[es creada (manifestación) por (entidad corporati.. (OP3004)]	OP3004	f	297767	\N	\N	f	f	15	1	\N	t	f	\N	\N	\N	t	f	f
29	https://datos.bne.es/def/OP3007	201660	\N	69	[has relation (OP3007)]	OP3007	f	201660	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
32	https://datos.bne.es/def/OP3008	6618736	\N	69	[has subject (OP3008)]	OP3008	f	6618736	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
33	https://datos.bne.es/def/OP4001	12107052	\N	69	[es ejemplar de (OP4001)]	OP4001	f	12107052	\N	\N	f	f	8	15	\N	t	f	\N	\N	\N	t	f	f
49	https://datos.bne.es/def/P3059	138	\N	69	[has fingerprint (P3059)]	P3059	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
50	https://datos.bne.es/def/P3058	25834	\N	69	[has note on mode of access (P3058)]	P3058	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
51	https://datos.bne.es/def/P3055	3711	\N	69	[has note on supplements, inserts, etc. (P3055)]	P3055	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
53	https://datos.bne.es/def/P3057	737	\N	69	[has longitude and latitude (P3057)]	P3057	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
54	https://datos.bne.es/def/P3056	828	\N	69	[has coordinates (P3056)]	P3056	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://www.w3.org/2004/02/skos/core#scopeNote	6364	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
60	https://datos.bne.es/def/P4008	12107047	\N	69	P4008	P4008	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
66	https://datos.bne.es/def/P4014	12107063	\N	69	P4014	P4014	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
68	https://datos.bne.es/def/P5222	19453	\N	69	P5222	P5222	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
72	https://datos.bne.es/def/P4010	1204644	\N	69	P4010	P4010	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://www.w3.org/2002/07/owl#complementOf	2	\N	7	complementOf	complementOf	f	2	\N	\N	f	f	14	14	\N	t	f	\N	\N	\N	t	f	f
76	http://www.w3.org/2004/02/skos/core#related	64996	\N	4	related	related	f	64996	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
80	https://datos.bne.es/def/P4007	12107047	\N	69	P4007	P4007	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
83	https://datos.bne.es/def/P4001	12107052	\N	69	P4001	P4001	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://www.w3.org/2000/01/rdf-schema#comment	8	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://www.w3.org/2000/01/rdf-schema#domain	21	\N	2	domain	domain	f	21	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
101	https://datos.bne.es/def/OP5006	10500	\N	69	OP5006	OP5006	f	10500	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
104	https://datos.bne.es/def/OP5004	1211	\N	69	OP5004	OP5004	f	1211	\N	\N	f	f	4	2	\N	t	f	\N	\N	\N	t	f	f
107	https://datos.bne.es/def/OP5009	8914	\N	69	OP5009	OP5009	f	8914	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://www.rdaregistry.info/Elements/a/P50034	1712	\N	71	P50034	P50034	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
56	https://datos.bne.es/def/P3051	10773	\N	69	[has music format statement (P3051)]	P3051	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
57	https://datos.bne.es/def/P3050	11366	\N	69	[tiene mención de responsabilidad relativa a edic.. (P3050)]	P3050	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
59	https://datos.bne.es/def/P3052	9494	\N	69	[tiene nota de serie o recurso monográfico multip.. (P3052)]	P3052	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
61	https://datos.bne.es/def/P3048	15685	\N	69	[has date of printing or manufacturer (P3048)]	P3048	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
62	https://datos.bne.es/def/P3047	23356	\N	69	[has note on reproduction (P3047)]	P3047	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
64	https://datos.bne.es/def/P3044	42891	\N	69	[has note on system requirements (P3044)]	P3044	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
65	https://datos.bne.es/def/P3043	78177	\N	69	[tiene nota sobre el área de edición e historia b.. (P3043)]	P3043	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
67	https://datos.bne.es/def/P3046	74610	\N	69	[has note on relationship between continuing reso.. (P3046)]	P3046	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
70	https://datos.bne.es/def/P3040	47733	\N	69	[has note on nature, scope, form, purpose or lang.. (P3040)]	P3040	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
71	https://datos.bne.es/def/P3042	89416	\N	69	[has note on material type or resource specific t.. (P3042)]	P3042	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
74	https://datos.bne.es/def/P3041	111468	\N	69	[has standard identifier (P3041)]	P3041	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
78	https://datos.bne.es/def/P3037	83302	\N	69	[has note on basis of description (P3037)]	P3037	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
79	https://datos.bne.es/def/P3036	46584	\N	69	[has note on use or audience (P3036)]	P3036	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
81	https://datos.bne.es/def/P3039	77471	\N	69	[ISSN (P3039)]	P3039	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
82	https://datos.bne.es/def/P3038	64996	\N	69	[has terms of availability (P3038)]	P3038	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
84	https://datos.bne.es/def/P3033	145477	\N	69	[has dependent title designation of title proper (P3033)]	P3033	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
86	https://datos.bne.es/def/P3035	123612	\N	69	[has statement of scale (P3035)]	P3035	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
87	https://datos.bne.es/def/P3034	330845	\N	69	[has note on relationship to other resources (P3034)]	P3034	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
89	https://datos.bne.es/def/P3031	137085	\N	69	[has numeric designation (P3031)]	P3031	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
92	https://datos.bne.es/def/P3019	594624	\N	69	[has name of printer or manufacturer (P3019)]	P3019	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
93	https://datos.bne.es/def/P3018	1073587	\N	69	[has numbering within series or multipart monogra.. (P3018)]	P3018	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
94	https://datos.bne.es/def/OP5002	1692997	\N	69	[es creador (persona) de (manifestación) (OP5002)]	OP5002	f	1692997	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
96	https://datos.bne.es/def/P3025	372171	\N	69	[has note on bibliographic reference (P3025)]	P3025	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
97	https://datos.bne.es/def/P3028	321891	\N	69	[variant title (manifestation) (P3028)]	P3028	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
98	https://datos.bne.es/def/P3027	307537	\N	69	[has place of printing or manufacturer (P3027)]	P3027	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
99	https://datos.bne.es/def/OP5001	1281163	\N	69	[es creador de (persona) (OP5001)]	OP5001	f	1281163	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
102	https://datos.bne.es/def/P3021	707621	\N	69	[has note on material description (P3021)]	P3021	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
103	https://datos.bne.es/def/P3024	359499	\N	69	[has performer (P3024)]	P3024	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
105	https://datos.bne.es/def/P3023	529244	\N	69	[has note on contents (P3023)]	P3023	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
106	https://datos.bne.es/def/P3020	537316	\N	69	[número del editor para música (manifestación\r\n) (P3020)]	P3020	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://www.rdaregistry.info/Elements/a/P50033	26777	\N	71	P50033	P50033	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://www.w3.org/2004/02/skos/core#altLabel	131097	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://www.rdaregistry.info/Elements/a/P50031	31004	\N	71	P50031	P50031	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://www.rdaregistry.info/Elements/a/P50038	6992	\N	71	P50038	P50038	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://www.rdaregistry.info/Elements/a/P50037	13651	\N	71	P50037	P50037	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	2	\N	1	rest	rest	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
125	https://datos.bne.es/def/OP6007	19916	\N	69	OP6007	OP6007	f	19916	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
127	https://datos.bne.es/def/OP6006	266	\N	69	OP6006	OP6006	f	266	\N	\N	f	f	1	2	\N	t	f	\N	\N	\N	t	f	f
130	https://datos.bne.es/def/P3094	15848	\N	69	P3094	P3094	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
131	https://datos.bne.es/def/OP6009	8778	\N	69	OP6009	OP6009	f	8778	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
132	https://datos.bne.es/def/P3091	30530	\N	69	P3091	P3091	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
133	https://datos.bne.es/def/P3090	40973	\N	69	P3090	P3090	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
134	https://datos.bne.es/def/P3093	472044	\N	69	P3093	P3093	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
135	https://datos.bne.es/def/P3092	157208	\N	69	P3092	P3092	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	3	\N	2	isDefinedBy	isDefinedBy	f	3	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
137	https://datos.bne.es/def/P1100	2138249	\N	69	P1100	P1100	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
138	https://datos.bne.es/def/P3087	1	\N	69	P3087	P3087	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
139	https://datos.bne.es/def/P3089	158536	\N	69	P3089	P3089	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
140	https://datos.bne.es/def/P5024	964789	\N	69	P5024	P5024	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
142	https://datos.bne.es/def/P3084	112594	\N	69	P3084	P3084	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
143	https://datos.bne.es/def/P3083	3070	\N	69	P3083	P3083	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
144	https://datos.bne.es/def/P3086	6175	\N	69	P3086	P3086	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://www.w3.org/2002/07/owl#unionOf	1	\N	7	unionOf	unionOf	f	1	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
146	https://datos.bne.es/def/P3085	74174	\N	69	P3085	P3085	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	11	11	\N	t	f	\N	\N	\N	t	f	f
148	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
149	https://datos.bne.es/def/P3082	3611	\N	69	P3082	P3082	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://www.w3.org/2004/02/skos/core#broader	58738	\N	4	broader	broader	f	58738	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://www.openlinksw.com/schemas/DAV#ownerUser	750	\N	18	ownerUser	ownerUser	f	750	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
153	https://datos.bne.es/def/P3077	6404	\N	69	P3077	P3077	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
154	https://datos.bne.es/def/P5014	722	\N	69	P5014	P5014	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
155	https://datos.bne.es/def/P3076	2925	\N	69	P3076	P3076	f	2925	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
156	https://datos.bne.es/def/P5012	461061	\N	69	P5012	P5012	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
157	https://datos.bne.es/def/P3079	486	\N	69	P3079	P3079	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
158	https://datos.bne.es/def/P5013	6462	\N	69	P5013	P5013	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
159	https://datos.bne.es/def/P3078	9271	\N	69	P3078	P3078	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
160	https://datos.bne.es/def/P3073	49186	\N	69	P3073	P3073	f	49186	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
114	https://datos.bne.es/def/P6008	5383	\N	69	[nota (P6008)]	P6008	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
116	https://datos.bne.es/def/OP6004	298693	\N	69	[is creator (corporate body) of (manifestation)  (OP6004)]	OP6004	f	298693	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
118	https://datos.bne.es/def/P6009	9431	\N	69	[persona relacionada (entidad corporativa) (P6009)]	P6009	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
119	https://datos.bne.es/def/OP6002	53808	\N	69	[es subordinado de (OP6002)]	OP6002	f	53808	\N	\N	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
120	https://datos.bne.es/def/P6006	58242	\N	69	[has number associated with the corporate body (P6006)]	P6006	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
122	https://datos.bne.es/def/P6007	15923	\N	69	[entidad relacionada (entidad corporativa) (P6007)]	P6007	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
123	https://datos.bne.es/def/P6004	66726	\N	69	[has place associated with the corporate body (P6004)]	P6004	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
124	https://datos.bne.es/def/P6005	139784	\N	69	[has other variant name (corporate body) (P6005)]	P6005	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
128	https://datos.bne.es/def/P6003	75960	\N	69	[has date associated with the corporate body (P6003)]	P6003	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
129	https://datos.bne.es/def/P6001	360757	\N	69	[has name of the corporate body (P6001)]	P6001	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
152	https://datos.bne.es/def/P5009	8916	\N	69	[entidad relacionada (persona) (P5009)]	P5009	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
161	https://datos.bne.es/def/P5010	285003	\N	69	[date of birth (P5010)]	P5010	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
163	https://datos.bne.es/def/P3075	142431	\N	69	P3075	P3075	f	142431	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
164	https://datos.bne.es/def/P3074	3381	\N	69	P3074	P3074	f	3381	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://www.w3.org/2004/02/skos/core#narrower	59327	\N	4	narrower	narrower	f	59327	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://www.rdaregistry.info/Elements/a/P50023	16726	\N	71	P50023	P50023	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://www.rdaregistry.info/Elements/a/P50022	32407	\N	71	P50022	P50022	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://www.rdaregistry.info/Elements/a/P50110	1949	\N	71	P50110	P50110	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://www.rdaregistry.info/Elements/a/P50119	127592	\N	71	P50119	P50119	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://www.rdaregistry.info/Elements/a/P50118	19871	\N	71	P50118	P50118	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://www.rdaregistry.info/Elements/a/P50116	1021709	\N	71	P50116	P50116	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://www.w3.org/2004/02/skos/core#inScheme	712122	\N	4	inScheme	inScheme	f	712122	\N	\N	f	f	7	12	\N	t	f	\N	\N	\N	t	f	f
197	http://www.w3.org/2000/01/rdf-schema#subClassOf	15	\N	2	subClassOf	subClassOf	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection	86687	\N	70	isMemberOfMADSCollection	isMemberOfMADSCollection	f	86687	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://www.w3.org/2000/01/rdf-schema#range	20	\N	2	range	range	f	20	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://www.w3.org/2002/07/owl#equivalentProperty	1	\N	7	equivalentProperty	equivalentProperty	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://www.w3.org/2004/02/skos/core#semanticRelation	1384683	\N	4	semanticRelation	semanticRelation	f	1384683	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://www.w3.org/2000/01/rdf-schema#seeAlso	417249	\N	2	seeAlso	seeAlso	f	258168	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://www.loc.gov/mads/rdf/v1#citationNote	163820	\N	70	citationNote	citationNote	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://www.w3.org/2002/07/owl#imports	1	\N	7	imports	imports	f	1	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
212	https://datos.bne.es/def/OP8001	1211	\N	69	OP8001	OP8001	f	1211	\N	\N	f	f	2	4	\N	t	f	\N	\N	\N	t	f	f
213	https://datos.bne.es/def/OP8002	266	\N	69	OP8002	OP8002	f	266	\N	\N	f	f	2	1	\N	t	f	\N	\N	\N	t	f	f
170	https://datos.bne.es/def/P5008	10041	\N	69	[has pseudonymous persona (P5008)]	P5008	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
171	https://datos.bne.es/def/P5005	18662	\N	69	[has biography or history (P5005)]	P5005	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
172	https://datos.bne.es/def/P5006	10520	\N	69	[persona relacionada (persona) (P5006)]	P5006	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
173	https://datos.bne.es/def/P3066	479706	\N	69	[thumbnail (P3066)]	P3066	f	449361	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
174	https://datos.bne.es/def/P5003	48876	\N	69	[has title of person (P5003)]	P5003	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
175	https://datos.bne.es/def/OP1001	1281163	\N	69	[es creada por (persona) (OP1001)]	OP1001	f	1281163	\N	\N	f	f	\N	4	\N	t	f	\N	\N	\N	t	f	f
177	https://datos.bne.es/def/P3065	44021	\N	69	[has note of incipit (P3065)]	P3065	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
178	https://datos.bne.es/def/P5001	1544786	\N	69	[has name of person (P5001)]	P5001	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
179	https://datos.bne.es/def/OP1003	2331	\N	69	[has part (work) (OP1003)]	OP1003	f	2331	\N	\N	f	f	13	13	\N	t	f	\N	\N	\N	t	f	f
180	https://datos.bne.es/def/P3067	39080	\N	69	[abstract (P3067)]	P3067	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
181	https://datos.bne.es/def/P5002	348407	\N	69	[has dates of person (P5002)]	P5002	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
182	https://datos.bne.es/def/OP1002	1482136	\N	69	[es realizada a través de (OP1002)]	OP1002	f	1482136	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
184	https://datos.bne.es/def/P3062	2077786	\N	69	[has media type (P3062)]	P3062	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
185	https://datos.bne.es/def/OP1004	2331	\N	69	[forma parte de (obra) (OP1004)]	OP1004	f	2331	\N	\N	f	f	13	13	\N	t	f	\N	\N	\N	t	f	f
186	https://datos.bne.es/def/P3061	2291207	\N	69	[has content form (P3061)]	P3061	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
187	https://datos.bne.es/def/P3064	5627326	\N	69	[tipo de recurso (P3064)]	P3064	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
188	https://datos.bne.es/def/P3063	233	\N	69	[has right ascension and declination (P3063)]	P3063	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
195	https://datos.bne.es/def/P2002	52142	\N	69	[tiene otras características distintivas de expre.. (P2002)]	P2002	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
196	https://datos.bne.es/def/OP2002	1482136	\N	69	[es realización de (OP2002)]	OP2002	f	1482136	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
198	https://datos.bne.es/def/OP2001	2091116	\N	69	[está materializada en (OP2001)]	OP2001	f	2091116	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
200	https://datos.bne.es/def/OP2003	1909	\N	69	[has part (expression) (OP2003)]	OP2003	f	1909	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
201	https://datos.bne.es/def/P2001	1467775	\N	69	[has language of expression (P2001)]	P2001	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
205	https://datos.bne.es/def/OP7001	928401	\N	69	[has as subject (concept) (OP7001)]	OP7001	f	928401	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
211	https://datos.bne.es/def/P1009	8688	\N	69	[has key (musical work) (P1009)]	P1009	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
214	https://datos.bne.es/def/P1005	67263	\N	69	[has other variant name (work) (P1005)]	P1005	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
216	https://datos.bne.es/def/P1007	19533	\N	69	[cataloguer's note (P1007)]	P1007	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
219	https://datos.bne.es/def/P6024	90554	\N	69	P6024	P6024	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://www.loc.gov/mads/rdf/v1#editorialNote	4404	\N	70	editorialNote	editorialNote	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://www.rdaregistry.info/Elements/a/P50101	30013	\N	71	P50101	P50101	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://www.rdaregistry.info/Elements/a/P50100	80935	\N	71	P50100	P50100	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://www.w3.org/2003/01/geo/wgs84_pos#lat	23849	\N	25	lat	lat	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://www.rdaregistry.info/Elements/a/P50109	5924	\N	71	P50109	P50109	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://www.rdaregistry.info/Elements/a/P50108	3035	\N	71	P50108	P50108	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://www.rdaregistry.info/Elements/a/P50104	341886	\N	71	P50104	P50104	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://www.rdaregistry.info/Elements/a/P50102	254018	\N	71	P50102	P50102	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://purl.org/dc/terms/created	750	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
240	https://datos.bne.es/def/P6014	156	\N	69	P6014	P6014	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	11	11	\N	t	f	\N	\N	\N	t	f	f
209	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	24123291	\N	1	type	type	f	24123291	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
1	https://datos.bne.es/def/P3008	3961479	\N	69	[has statement of responsibility relating to title (P3008)]	P3008	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
9	https://datos.bne.es/def/P3016	1477152	\N	69	[has title proper of series or multipart monograp.. (P3016)]	P3016	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
21	https://datos.bne.es/def/P3006	5697065	\N	69	[tiene fecha de publicación, producción, distribu.. (P3006)]	P3006	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
25	https://datos.bne.es/def/OP3002	2014948	\N	69	[es materialización de (OP3002)]	OP3002	f	2014948	\N	\N	f	f	15	9	\N	t	f	\N	\N	\N	t	f	f
30	https://datos.bne.es/def/OP3006	3642723	\N	69	[has contributor (OP3006)]	OP3006	f	3642723	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
52	https://datos.bne.es/def/P3054	5415	\N	69	[has note on supplement to or insert in (P3054)]	P3054	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
58	https://datos.bne.es/def/P3053	1980	\N	69	[has dependent title designation of series or mul.. (P3053)]	P3053	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
63	https://datos.bne.es/def/P3049	17259	\N	69	[tiene número normalizado internacional de serie .. (P3049)]	P3049	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
69	https://datos.bne.es/def/P3045	26659	\N	69	[has dependent title of series or multipart monog.. (P3045)]	P3045	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
77	https://datos.bne.es/def/P3029	196877	\N	69	[has accompanying material statement (P3029)]	P3029	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
85	https://datos.bne.es/def/P3032	129188	\N	69	[has note on frequency (P3032)]	P3032	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
90	https://datos.bne.es/def/P3030	187723	\N	69	[has dependent title of title proper (P3030)]	P3030	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
95	https://datos.bne.es/def/P3026	415326	\N	69	[tiene nota sobre publicación, producción, distri.. (P3026)]	P3026	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
100	https://datos.bne.es/def/P3022	270771	\N	69	[is in series (P3022)]	P3022	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
117	https://datos.bne.es/def/OP6003	53808	\N	69	[has subordinate (OP6003)]	OP6003	f	53808	\N	\N	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
121	https://datos.bne.es/def/OP6001	99118	\N	69	[es creador de (entidad corporativa) (OP6001)]	OP6001	f	99118	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
126	https://datos.bne.es/def/P6002	78224	\N	69	[has hierarchical subordinate (P6002)]	P6002	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
162	https://datos.bne.es/def/P5011	109868	\N	69	[date of death (P5011)]	P5011	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
169	https://datos.bne.es/def/P5007	1219	\N	69	[has other designation associated with the person (P5007)]	P5007	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
176	https://datos.bne.es/def/P5004	16566	\N	69	[fuller form of name (person) (P5004)]	P5004	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
183	https://datos.bne.es/def/OP1005	99118	\N	69	[es creada por (entidad corporativa) (OP1005)]	OP1005	f	99118	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
189	https://datos.bne.es/def/P3060	311	\N	69	[has note on binding (P3060)]	P3060	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
199	https://datos.bne.es/def/OP2004	1909	\N	69	[forma parte (expresión) de (OP2004)]	OP2004	f	1909	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
215	https://datos.bne.es/def/P1006	27398	\N	69	[numbering of part (P1006)]	P1006	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
218	https://datos.bne.es/def/P1012	37045	\N	69	[label of part (P1012)]	P1012	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
220	https://datos.bne.es/def/P1010	403	\N	69	[Signatory to a treaty, etc. (P1010)]	P1010	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
221	https://datos.bne.es/def/P1011	4829426	\N	69	[etiqueta asociada al autor (P1011)]	P1011	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
236	https://datos.bne.es/def/P1002	2135178	\N	69	[fuente consultada (P1002)]	P1002	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
237	https://datos.bne.es/def/P1003	1938112	\N	69	[citation note (P1003)]	P1003	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
238	https://datos.bne.es/def/P1004	105493	\N	69	[has date of the work (P1004)]	P1004	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
217	https://datos.bne.es/def/P1008	13823	\N	69	[has medium of performance (musical work) (P1008)]	P1008	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
235	https://datos.bne.es/def/P1001	2221275	\N	69	[has title of the work (P1001)]	P1001	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_datos_bne_es_sparql; Owner: -
--

COPY http_datos_bne_es_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	has statement of responsibility relating to title	en
2	1	8	tienen mención de responsabilidad relativa al título	es
3	2	8	has dimensions	en
4	2	8	tiene dimensiones	es
5	3	8	Identifier for the manifestation	en
6	3	8	depósito legal	es
7	5	8	has note	en
8	5	8	tiene nota	es
9	6	8	tiene información complementaria del título	es
11	7	8	has edition statement	en
12	7	8	tiene mención de edición	es
13	9	8	has title proper of series or multipart monographic resource	en
14	9	8	tiene título propiamente dicho de serie o recurso monográfico multiparte	es
15	10	8	ISBN	en
16	10	8	ISBN	es
17	11	8	has other physical details	en
18	11	8	tiene otros detalles físicos	es
19	12	8	equivalentClass	
20	14	8	BNE id	en
21	14	8	BNE id	es
22	16	8	priorVersion	
23	18	8	has specific material designation and extent	en
24	18	8	tiene designación específica del material y extensión	es
25	20	8	has place of publication, production, distribution	en
26	20	8	tiene lugar de publicación, producción, distribución	es
27	21	8	tiene fecha de publicación, producción, distribución	es
28	21	8	has date of publication, production, distribution	en
29	22	8	está ejemplificado por	es
30	22	8	is exemplified by	en
31	23	8	tiene mención de forma del contenido y de tipo de medio	es
32	23	8	has content form and media type statement	en
33	24	8	es creada (manifestación) por (persona)	es
34	24	8	is created (manifestation) by (person)	en
35	25	8	es materialización de	es
36	25	8	is embodiment of	en
37	26	8	has title proper	en
38	26	8	tiene título propiamente dicho	es
39	27	8	has name of publisher, producer, distributor	en
40	27	8	tiene nombre de editor, productor, distribuidor	es
41	28	8	es creada (manifestación) por (entidad corporativa)	es
42	28	8	is created (manifestation) by (corporate body)	en
43	29	8	has relation	en
44	29	8	tiene relation	es
45	30	8	has contributor	en
46	30	8	tiene contribuidor	es
47	32	8	has subject	en
48	32	8	tiene como materia	es
49	33	8	es ejemplar de	es
50	33	8	is exemplar of	en
51	36	8	modified	
52	40	8	sameAs	
53	47	8	prefLabel	
54	49	8	has fingerprint	en
55	49	8	tiene identificador tipográfico	es
56	50	8	has note on mode of access	en
57	50	8	tiene nota sobre modo de acceso	es
58	51	8	has note on supplements, inserts, etc.	en
59	51	8	tiene nota de suplementos, insertos, etc	es
60	52	8	has note on supplement to or insert in	en
61	52	8	tiene nota de suplemento a o de insertado en	es
62	53	8	has longitude and latitude	en
63	53	8	tiene longitud y latitud	es
64	54	8	has coordinates	en
65	54	8	tiene coordenadas	es
66	56	8	has music format statement	en
67	56	8	tiene mención de formato musical	es
68	57	8	tiene mención de responsabilidad relativa a edición	es
69	57	8	has statement of responsibility relating to edition	en
70	58	8	has dependent title designation of series or multipart monographic resource	en
71	58	8	tiene designación de título dependiente de serie o recurso monográfico multiparte	es
72	59	8	tiene nota de serie o recurso monográfico multiparte	es
73	59	8	has note on series and multipart monographic resources	en
74	61	8	has date of printing or manufacturer	en
75	61	8	tiene fecha de impresión o fabricación	es
76	62	8	has note on reproduction	en
77	62	8	tiene nota de reproducción	es
78	63	8	tiene número normalizado internacional de serie o recurso monográfico multiparte	es
79	63	8	has international standard number of series or multipart monographic resource	en
80	64	8	has note on system requirements	en
81	64	8	tiene nota de requisitos mínimos del sistema	es
82	65	8	tiene nota sobre el área de edición e historia bibliográfica	es
83	65	8	has note on edition area and bibliographic history	en
84	67	8	has note on relationship between continuing resources	en
85	67	8	tiene nota sobre la relación con recursos continuados	es
86	69	8	has dependent title of series or multipart monographic resource	en
87	69	8	tiene título dependiente de serie o recurso monográfico multiparte	es
88	70	8	has note on nature, scope, form, purpose or language	en
89	70	8	tiene nota sobre naturaleza, alcance, forma, propósito o lengua	es
90	71	8	has note on material type or resource specific type	en
91	71	8	tiene nota sobre tipo de material o tipo específico de recurso	es
92	74	8	has standard identifier	en
93	74	8	tiene identificador normalizado	es
94	75	8	complementOf	
95	76	8	related	
96	77	8	has accompanying material statement	en
97	77	8	tiene mención de material anejo	es
98	78	8	has note on basis of description	en
99	78	8	tiene nota sobre base de descripción	es
100	79	8	has note on use or audience	en
101	79	8	tiene nota de uso o destinatario	es
102	81	8	ISSN	en
103	81	8	ISSN	es
104	82	8	has terms of availability	en
105	82	8	tiene condiciones de disponibilidad	es
106	84	8	has dependent title designation of title proper	en
107	84	8	tiene designación de título dependiente de título propiamente dicho	es
108	85	8	has note on frequency	en
109	85	8	tiene nota de frecuencia	es
110	86	8	has statement of scale	en
111	86	8	tiene mención de escala	es
112	87	8	has note on relationship to other resources	en
113	87	8	tiene nota de relación con otros recursos	es
114	89	8	has numeric designation	en
115	89	8	tiene designación  numérica	es
116	90	8	has dependent title of title proper	en
117	90	8	tiene título dependiente de título propiamente dicho	es
118	92	8	has name of printer or manufacturer	en
119	92	8	tiene nombre de impresor o fabricante	es
120	93	8	has numbering within series or multipart monographic resource	en
121	93	8	tiene numeración de serie o recurso monográfico multiparte	es
122	94	8	es creador (persona) de (manifestación)	es
123	94	8	is creator (person) of (manifestation)	en
124	95	8	tiene nota sobre publicación, producción, distribución, etc.	es
125	95	8	has note on publication, production, distribution, etc.	en
126	96	8	has note on bibliographic reference	en
127	96	8	tiene nota de referencia bibliográfica	es
128	97	8	variant title (manifestation)	en
129	97	8	variante de título (manifestación)	es
130	98	8	has place of printing or manufacturer	en
131	98	8	tiene lugar de impresión o fabricación	es
132	99	8	es creador de (persona)	es
133	99	8	is creator of (person)	en
134	100	8	is in series	en
135	100	8	pertenece a serie	es
136	102	8	has note on material description	en
137	102	8	tiene nota sobre descripción del material	es
138	103	8	has performer	en
139	103	8	tiene intérprete	es
140	105	8	has note on contents	en
141	105	8	tiene nota sobre el contenido	es
142	106	8	número del editor para música (manifestación\r\n)	es
143	106	8	publisher's number for music (manifestation)	en
144	114	8	nota	es
145	114	8	note	en
146	116	8	is creator (corporate body) of (manifestation) 	en
147	116	8	es creador (entidad corporativa) de (manifestación)	es
148	117	8	has subordinate	en
149	117	8	tiene subordinado	es
150	118	8	persona relacionada (entidad corporativa)	es
151	118	8	related person (corporate body) 	en
152	119	8	es subordinado de	es
153	119	8	is subordinate of	en
154	120	8	has number associated with the corporate body	en
155	120	8	tiene número asociado a la entidad corporativa	es
156	121	8	es creador de (entidad corporativa)	es
157	121	8	is creator (corporate body) of	en
158	122	8	entidad relacionada (entidad corporativa)	es
159	122	8	related corporate body (corporate body)	en
160	123	8	has place associated with the corporate body	en
161	123	8	tiene lugar asociado a la entidad corporativa	es
162	124	8	has other variant name (corporate body)	en
163	124	8	tiene otra variante de nombre (entidad corporativa)	es
164	126	8	has hierarchical subordinate	en
165	126	8	subordinada jerárquica	es
166	128	8	has date associated with the corporate body	en
167	128	8	tiene fecha asociada a la entidad corporativa	es
168	129	8	has name of the corporate body	en
169	129	8	tiene nombre de entidad corporativa	es
170	145	8	unionOf	
171	148	8	versionInfo	
172	150	8	broader	
173	152	8	entidad relacionada (persona)	es
174	152	8	related corporate body (person)	en
175	161	8	date of birth	en
176	161	8	fecha de nacimiento	es
177	162	8	date of death	en
178	162	8	fecha de fallecimiento	es
179	169	8	has other designation associated with the person	en
180	169	8	tiene otras designaciones asociadas con la persona	es
181	170	8	has pseudonymous persona	en
182	170	8	tiene pseudónimo	es
183	171	8	has biography or history	en
184	171	8	tiene biografía o historia	es
185	172	8	persona relacionada (persona)	es
186	172	8	related person (person)	en
188	173	8	miniatura	es
187	173	8	thumbnail	en
190	174	8	has title of person	en
191	174	8	tiene calificativo de persona	es
192	175	8	es creada por (persona)	es
193	175	8	is created by (person)	en
194	176	8	fuller form of name (person)	en
195	176	8	nombre completo (persona)	es
196	177	8	has note of incipit	en
197	177	8	tiene nota de incipit	es
198	178	8	has name of person	en
199	178	8	tiene nombre de persona	es
200	179	8	has part (work)	en
201	179	8	tiene parte (obra)	es
202	180	8	abstract	en
203	180	8	resumen	es
204	181	8	has dates of person	en
205	181	8	tiene fechas de persona	es
206	182	8	es realizada a través de	es
207	182	8	is realized through	en
208	183	8	es creada por (entidad corporativa)	es
209	183	8	is created by (corporate body)	en
210	184	8	has media type	en
211	184	8	tiene tipo de medio	es
212	185	8	forma parte de (obra)	es
213	185	8	is part of work (work)	en
214	186	8	has content form	en
215	186	8	tiene forma del contenido	es
216	187	8	tipo de recurso	es
217	187	8	type of resource	en
218	188	8	has right ascension and declination	en
219	188	8	tiene ascensión recta y declinación	es
220	189	8	has note on binding	en
221	189	8	tiene nota sobre la encuadernación	es
222	195	8	tiene otras características distintivas de expresión	es
223	195	8	has other distinguishing characteristic of expression	en
224	196	8	es realización de	es
225	196	8	is realization of\r\n	en
226	198	8	está materializada en	es
227	198	8	is embodied in	en
228	199	8	forma parte (expresión) de	es
229	199	8	is part (expression) of	en
230	200	8	has part (expression)	en
231	200	8	tiene parte (expresión)	es
232	201	8	has language of expression	en
233	201	8	tiene lengua de la expresión	es
234	204	8	equivalentProperty	
235	205	8	has as subject (concept)	en
236	205	8	tiene como materia (concepto)	es
237	207	8	see also	en
238	210	8	imports	
239	211	8	has key (musical work)	en
240	211	8	tiene clave (obra musical)	es
241	214	8	has other variant name (work)	en
242	214	8	tiene otra variante de nombre (obra)	es
243	215	8	numbering of part	en
244	215	8	numeración de parte	es
245	216	8	cataloguer's note	en
246	216	8	nota del catalogador	es
247	217	8	has medium of performance (musical work)	en
248	217	8	tiene medio de interpretación (obra musical)	es
249	218	8	label of part	en
250	220	8	Signatory to a treaty, etc.	en
251	220	8	firmante del tratado	es
252	221	8	etiqueta asociada al autor	es
253	221	8	label associated with author	en
254	235	8	has title of the work	en
255	235	8	tiene título de la obra	es
256	236	8	fuente consultada	es
257	236	8	source consulted	en
258	237	8	citation note	en
259	237	8	información encontrada	es
260	238	8	has date of the work	en
261	238	8	tiene fecha de la obra	es
262	239	8	created	
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cc_rels_id_seq', 1, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.class_annots_id_seq', 17, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.classes_id_seq', 16, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cp_rels_id_seq', 429, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.ns_id_seq', 71, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.properties_id_seq', 241, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_datos_bne_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_datos_bne_es_sparql.property_annots_id_seq', 262, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_datos_bne_es_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_datos_bne_es_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_datos_bne_es_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_datos_bne_es_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_datos_bne_es_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_datos_bne_es_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_datos_bne_es_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_datos_bne_es_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_datos_bne_es_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_datos_bne_es_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_datos_bne_es_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_datos_bne_es_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_datos_bne_es_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_datos_bne_es_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_datos_bne_es_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_datos_bne_es_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_datos_bne_es_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_datos_bne_es_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_datos_bne_es_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_datos_bne_es_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_datos_bne_es_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_datos_bne_es_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_datos_bne_es_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_datos_bne_es_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_datos_bne_es_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_datos_bne_es_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_datos_bne_es_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_datos_bne_es_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_datos_bne_es_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_datos_bne_es_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_datos_bne_es_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_datos_bne_es_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_datos_bne_es_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_datos_bne_es_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_datos_bne_es_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_datos_bne_es_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_datos_bne_es_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_datos_bne_es_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_datos_bne_es_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_datos_bne_es_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_datos_bne_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_datos_bne_es_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_datos_bne_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_datos_bne_es_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_datos_bne_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_datos_bne_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_datos_bne_es_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_datos_bne_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_datos_bne_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_datos_bne_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_datos_bne_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_datos_bne_es_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_datos_bne_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_datos_bne_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_datos_bne_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_datos_bne_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_datos_bne_es_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_datos_bne_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_datos_bne_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_datos_bne_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_datos_bne_es_sparql; Owner: -
--

ALTER TABLE ONLY http_datos_bne_es_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_datos_bne_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

