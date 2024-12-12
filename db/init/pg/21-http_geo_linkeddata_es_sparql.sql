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
-- Name: http_geo_linkeddata_es_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_geo_linkeddata_es_sparql;


--
-- Name: SCHEMA http_geo_linkeddata_es_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_geo_linkeddata_es_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE FUNCTION http_geo_linkeddata_es_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE FUNCTION http_geo_linkeddata_es_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COMMENT ON TABLE http_geo_linkeddata_es_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COMMENT ON COLUMN http_geo_linkeddata_es_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_geo_linkeddata_es_sparql.classes c1
     JOIN http_geo_linkeddata_es_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_geo_linkeddata_es_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_geo_linkeddata_es_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_geo_linkeddata_es_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE TABLE http_geo_linkeddata_es_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE http_geo_linkeddata_es_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_geo_linkeddata_es_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_cc_rels AS
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
   FROM http_geo_linkeddata_es_sparql.cc_rels r,
    http_geo_linkeddata_es_sparql.classes c1,
    http_geo_linkeddata_es_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_classes_ns AS
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
    http_geo_linkeddata_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_geo_linkeddata_es_sparql.classes c
     LEFT JOIN http_geo_linkeddata_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_classes_ns_main AS
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
   FROM http_geo_linkeddata_es_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_geo_linkeddata_es_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_classes_ns_plus AS
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
    http_geo_linkeddata_es_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_geo_linkeddata_es_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_geo_linkeddata_es_sparql.classes c
     LEFT JOIN http_geo_linkeddata_es_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_classes_ns_main_plus AS
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
   FROM http_geo_linkeddata_es_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_geo_linkeddata_es_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_geo_linkeddata_es_sparql.v_classes_ns v
     LEFT JOIN http_geo_linkeddata_es_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_cp_rels AS
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
    http_geo_linkeddata_es_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_geo_linkeddata_es_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_geo_linkeddata_es_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_geo_linkeddata_es_sparql.cp_rels r,
    http_geo_linkeddata_es_sparql.classes c,
    http_geo_linkeddata_es_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_cp_rels_card AS
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
   FROM http_geo_linkeddata_es_sparql.cp_rels r,
    http_geo_linkeddata_es_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_properties_ns AS
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
    http_geo_linkeddata_es_sparql.tapprox(p.cnt) AS cnt_x,
    http_geo_linkeddata_es_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_geo_linkeddata_es_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_geo_linkeddata_es_sparql.properties p
     LEFT JOIN http_geo_linkeddata_es_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_cp_sources_single AS
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
   FROM ((http_geo_linkeddata_es_sparql.v_cp_rels_card r
     JOIN http_geo_linkeddata_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_geo_linkeddata_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_cp_targets_single AS
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
   FROM ((http_geo_linkeddata_es_sparql.v_cp_rels_card r
     JOIN http_geo_linkeddata_es_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_geo_linkeddata_es_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_geo_linkeddata_es_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_geo_linkeddata_es_sparql.pp_rels r,
    http_geo_linkeddata_es_sparql.properties p1,
    http_geo_linkeddata_es_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_properties_sources AS
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
   FROM (http_geo_linkeddata_es_sparql.v_properties_ns v
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
           FROM http_geo_linkeddata_es_sparql.cp_rels r,
            http_geo_linkeddata_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_properties_sources_single AS
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
   FROM (http_geo_linkeddata_es_sparql.v_properties_ns v
     LEFT JOIN http_geo_linkeddata_es_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_properties_targets AS
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
   FROM (http_geo_linkeddata_es_sparql.v_properties_ns v
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
           FROM http_geo_linkeddata_es_sparql.cp_rels r,
            http_geo_linkeddata_es_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE VIEW http_geo_linkeddata_es_sparql.v_properties_targets_single AS
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
   FROM (http_geo_linkeddata_es_sparql.v_properties_ns v
     LEFT JOIN http_geo_linkeddata_es_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
84	"http://geo.linkeddata.es/def/Laguna"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/def/Laguna	http://geo.linkeddata.es/def/Laguna	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
1	"http://geo.linkeddata.es/def/btn100#Punta"^^<http://www.w3.org/2001/XMLSchema#string>	958	\N	t	\N	http://geo.linkeddata.es/def/btn100#Punta	http://geo.linkeddata.es/def/btn100#Punta	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
2	"http://geo.linkeddata.es/def/btn100#PatrimonioDeLaHumanidad"^^<http://www.w3.org/2001/XMLSchema#string>	61	\N	t	\N	http://geo.linkeddata.es/def/btn100#PatrimonioDeLaHumanidad	http://geo.linkeddata.es/def/btn100#PatrimonioDeLaHumanidad	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
3	"http://geo.linkeddata.es/ontology/Mar"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://geo.linkeddata.es/ontology/Mar	http://geo.linkeddata.es/ontology/Mar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
4	"http://phenomenontology.linkeddata.es/ontology/Restos_arqueol%C3%B3gicos"^^<http://www.w3.org/2001/XMLSchema#string>	17	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Restos_arqueol%C3%B3gicos	http://phenomenontology.linkeddata.es/ontology/Restos_arqueol%C3%B3gicos	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	30
5	"http://geo.linkeddata.es/ontology/CanalMarino"^^<http://www.w3.org/2001/XMLSchema#string>	34	\N	t	\N	http://geo.linkeddata.es/ontology/CanalMarino	http://geo.linkeddata.es/ontology/CanalMarino	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
6	"http://phenomenontology.linkeddata.es/ontology/Templo"^^<http://www.w3.org/2001/XMLSchema#string>	7	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Templo	http://phenomenontology.linkeddata.es/ontology/Templo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	11
7	"http://geo.linkeddata.es/def/btn100#Bahia"^^<http://www.w3.org/2001/XMLSchema#string>	58	\N	t	\N	http://geo.linkeddata.es/def/btn100#Bahia	http://geo.linkeddata.es/def/btn100#Bahia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
8	"http://phenomenontology.linkeddata.es/ontology/Mezquita"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Mezquita	http://phenomenontology.linkeddata.es/ontology/Mezquita	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
9	"http://geo.linkeddata.es/def/btn100#ZonaDeportiva"^^<http://www.w3.org/2001/XMLSchema#string>	2373	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaDeportiva	http://geo.linkeddata.es/def/btn100#ZonaDeportiva	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
10	"http://geo.linkeddata.es/ontology/Puerto"^^<http://www.w3.org/2001/XMLSchema#string>	348	\N	t	\N	http://geo.linkeddata.es/ontology/Puerto	http://geo.linkeddata.es/ontology/Puerto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
11	"http://geo.linkeddata.es/def/btn100#Golfo"^^<http://www.w3.org/2001/XMLSchema#string>	12	\N	t	\N	http://geo.linkeddata.es/def/btn100#Golfo	http://geo.linkeddata.es/def/btn100#Golfo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
12	"http://geo.linkeddata.es/def/Rivera"^^<http://www.w3.org/2001/XMLSchema#string>	9	\N	t	\N	http://geo.linkeddata.es/def/Rivera	http://geo.linkeddata.es/def/Rivera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
13	"http://phenomenontology.linkeddata.es/ontology/F%C3%A1brica"^^<http://www.w3.org/2001/XMLSchema#string>	72	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/F%C3%A1brica	http://phenomenontology.linkeddata.es/ontology/F%C3%A1brica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	137
14	"http://www.w3.org/2002/07/owl#Restriction"^^<http://www.w3.org/2001/XMLSchema#string>	189	\N	t	\N	http://www.w3.org/2002/07/owl#Restriction	http://www.w3.org/2002/07/owl#Restriction	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	189
15	"http://phenomenontology.linkeddata.es/ontology/Parroquia"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Parroquia	http://phenomenontology.linkeddata.es/ontology/Parroquia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
16	"http://geo.linkeddata.es/ontology/Carretera"^^<http://www.w3.org/2001/XMLSchema#string>	9675	\N	t	\N	http://geo.linkeddata.es/ontology/Carretera	http://geo.linkeddata.es/ontology/Carretera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
17	"http://phenomenontology.linkeddata.es/ontology/Alcazaba"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Alcazaba	http://phenomenontology.linkeddata.es/ontology/Alcazaba	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
18	"http://geo.linkeddata.es/ontology/Piscina"^^<http://www.w3.org/2001/XMLSchema#string>	39	\N	t	\N	http://geo.linkeddata.es/ontology/Piscina	http://geo.linkeddata.es/ontology/Piscina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
19	"http://geo.linkeddata.es/def/btn100#ComarcaRegion"^^<http://www.w3.org/2001/XMLSchema#string>	549	\N	t	\N	http://geo.linkeddata.es/def/btn100#ComarcaRegion	http://geo.linkeddata.es/def/btn100#ComarcaRegion	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
20	"http://phenomenontology.linkeddata.es/ontology/Ba%C3%B1os"^^<http://www.w3.org/2001/XMLSchema#string>	6	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Ba%C3%B1os	http://phenomenontology.linkeddata.es/ontology/Ba%C3%B1os	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
21	"http://geo.linkeddata.es/ontology/Estero"^^<http://www.w3.org/2001/XMLSchema#string>	27	\N	t	\N	http://geo.linkeddata.es/ontology/Estero	http://geo.linkeddata.es/ontology/Estero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
22	"http://www.w3.org/2003/01/geo/wgs84_pos#Point"^^<http://www.w3.org/2001/XMLSchema#string>	4277929	\N	t	\N	http://www.w3.org/2003/01/geo/wgs84_pos#Point	http://www.w3.org/2003/01/geo/wgs84_pos#Point	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4295598
23	"http://geo.linkeddata.es/ontology/Pa%C3%ADs"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Pa%C3%ADs	http://geo.linkeddata.es/ontology/Pa%C3%ADs	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
24	"http://geo.linkeddata.es/def/btn100#Aeropuerto"^^<http://www.w3.org/2001/XMLSchema#string>	61	\N	t	\N	http://geo.linkeddata.es/def/btn100#Aeropuerto	http://geo.linkeddata.es/def/btn100#Aeropuerto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
25	"http://www.w3.org/ns/prov#Entity"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://www.w3.org/ns/prov#Entity	http://www.w3.org/ns/prov#Entity	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	3
26	"http://geo.linkeddata.es/def/btn100#SitioHistorico"^^<http://www.w3.org/2001/XMLSchema#string>	113	\N	t	\N	http://geo.linkeddata.es/def/btn100#SitioHistorico	http://geo.linkeddata.es/def/btn100#SitioHistorico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
27	"http://geo.linkeddata.es/ontology/Ca%C3%B1o"^^<http://www.w3.org/2001/XMLSchema#string>	131	\N	t	\N	http://geo.linkeddata.es/ontology/Ca%C3%B1o	http://geo.linkeddata.es/ontology/Ca%C3%B1o	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
28	"http://geo.linkeddata.es/def/btn100#EstacionDeFerrocarril"^^<http://www.w3.org/2001/XMLSchema#string>	1107	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionDeFerrocarril	http://geo.linkeddata.es/def/btn100#EstacionDeFerrocarril	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
29	"http://phenomenontology.linkeddata.es/ontology/Monumento"^^<http://www.w3.org/2001/XMLSchema#string>	43	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Monumento	http://phenomenontology.linkeddata.es/ontology/Monumento	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	63
30	"http://phenomenontology.linkeddata.es/ontology/Casa"^^<http://www.w3.org/2001/XMLSchema#string>	58	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Casa	http://phenomenontology.linkeddata.es/ontology/Casa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	61
31	"http://phenomenontology.linkeddata.es/ontology/Mercado"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Mercado	http://phenomenontology.linkeddata.es/ontology/Mercado	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
32	"http://geo.linkeddata.es/ontology/Saladar"^^<http://www.w3.org/2001/XMLSchema#string>	15	\N	t	\N	http://geo.linkeddata.es/ontology/Saladar	http://geo.linkeddata.es/ontology/Saladar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
33	"http://geo.linkeddata.es/def/btn100#Esclusa"^^<http://www.w3.org/2001/XMLSchema#string>	14	\N	t	\N	http://geo.linkeddata.es/def/btn100#Esclusa	http://geo.linkeddata.es/def/btn100#Esclusa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
34	"http://phenomenontology.linkeddata.es/ontology/Acuario"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Acuario	http://phenomenontology.linkeddata.es/ontology/Acuario	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
35	"http://geo.linkeddata.es/def/btn100#SubestacionElectrica"^^<http://www.w3.org/2001/XMLSchema#string>	2578	\N	t	\N	http://geo.linkeddata.es/def/btn100#SubestacionElectrica	http://geo.linkeddata.es/def/btn100#SubestacionElectrica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
36	"http://www.openlinksw.com/schemas/virtrdf#array-of-string"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#array-of-string	http://www.openlinksw.com/schemas/virtrdf#array-of-string	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
37	"http://geo.linkeddata.es/ontology/Lago"^^<http://www.w3.org/2001/XMLSchema#string>	122	\N	t	\N	http://geo.linkeddata.es/ontology/Lago	http://geo.linkeddata.es/ontology/Lago	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
38	"http://geo.linkeddata.es/ontology/Humedal"^^<http://www.w3.org/2001/XMLSchema#string>	639	\N	t	\N	http://geo.linkeddata.es/ontology/Humedal	http://geo.linkeddata.es/ontology/Humedal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
39	"http://geo.linkeddata.es/def/btn100#ZonaMonumental"^^<http://www.w3.org/2001/XMLSchema#string>	22	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaMonumental	http://geo.linkeddata.es/def/btn100#ZonaMonumental	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
40	"http://phenomenontology.linkeddata.es/ontology/Granja"^^<http://www.w3.org/2001/XMLSchema#string>	46	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Granja	http://phenomenontology.linkeddata.es/ontology/Granja	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	81
41	"http://geo.linkeddata.es/def/Rambla"^^<http://www.w3.org/2001/XMLSchema#string>	853	\N	t	\N	http://geo.linkeddata.es/def/Rambla	http://geo.linkeddata.es/def/Rambla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
42	"http://geo.linkeddata.es/def/Presa"^^<http://www.w3.org/2001/XMLSchema#string>	1147	\N	t	\N	http://geo.linkeddata.es/def/Presa	http://geo.linkeddata.es/def/Presa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
43	"http://geo.linkeddata.es/ontology/Riacho"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://geo.linkeddata.es/ontology/Riacho	http://geo.linkeddata.es/ontology/Riacho	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
44	"http://geo.linkeddata.es/def/btn100#PistaDeAterrizaje"^^<http://www.w3.org/2001/XMLSchema#string>	180	\N	t	\N	http://geo.linkeddata.es/def/btn100#PistaDeAterrizaje	http://geo.linkeddata.es/def/btn100#PistaDeAterrizaje	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
45	"http://geo.linkeddata.es/def/btn100#ZonaArqueologica"^^<http://www.w3.org/2001/XMLSchema#string>	1099	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaArqueologica	http://geo.linkeddata.es/def/btn100#ZonaArqueologica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
46	"http://phenomenontology.linkeddata.es/ontology/Cueva"^^<http://www.w3.org/2001/XMLSchema#string>	262	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Cueva	http://phenomenontology.linkeddata.es/ontology/Cueva	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	274
47	"http://geo.linkeddata.es/def/Humedal"^^<http://www.w3.org/2001/XMLSchema#string>	723	\N	t	\N	http://geo.linkeddata.es/def/Humedal	http://geo.linkeddata.es/def/Humedal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
48	"http://geo.linkeddata.es/ontology/Confluencia"^^<http://www.w3.org/2001/XMLSchema#string>	449	\N	t	\N	http://geo.linkeddata.es/ontology/Confluencia	http://geo.linkeddata.es/ontology/Confluencia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
49	"http://geo.linkeddata.es/ontology/Vertiente"^^<http://www.w3.org/2001/XMLSchema#string>	164	\N	t	\N	http://geo.linkeddata.es/ontology/Vertiente	http://geo.linkeddata.es/ontology/Vertiente	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
50	"http://geo.linkeddata.es/ontology/Sif%C3%B3n"^^<http://www.w3.org/2001/XMLSchema#string>	24	\N	t	\N	http://geo.linkeddata.es/ontology/Sif%C3%B3n	http://geo.linkeddata.es/ontology/Sif%C3%B3n	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
51	"http://geo.linkeddata.es/def/btn100#Camping"^^<http://www.w3.org/2001/XMLSchema#string>	1091	\N	t	\N	http://geo.linkeddata.es/def/btn100#Camping	http://geo.linkeddata.es/def/btn100#Camping	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
52	"http://geo.linkeddata.es/def/btn100#AreaDeServicio"^^<http://www.w3.org/2001/XMLSchema#string>	359	\N	t	\N	http://geo.linkeddata.es/def/btn100#AreaDeServicio	http://geo.linkeddata.es/def/btn100#AreaDeServicio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
53	"http://geo.linkeddata.es/ontology/IslaFluvial"^^<http://www.w3.org/2001/XMLSchema#string>	121	\N	t	\N	http://geo.linkeddata.es/ontology/IslaFluvial	http://geo.linkeddata.es/ontology/IslaFluvial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
54	"http://phenomenontology.linkeddata.es/ontology/Catedral"^^<http://www.w3.org/2001/XMLSchema#string>	55	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Catedral	http://phenomenontology.linkeddata.es/ontology/Catedral	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	53
55	"http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteOrografico"^^<http://www.w3.org/2001/XMLSchema#string>	185	\N	t	\N	http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteOrografico	http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteOrografico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
56	"http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapColumn"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapColumn	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapColumn	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	8
57	"http://geo.linkeddata.es/def/btn100#Cargadero"^^<http://www.w3.org/2001/XMLSchema#string>	74	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cargadero	http://geo.linkeddata.es/def/btn100#Cargadero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
58	"http://phenomenontology.linkeddata.es/ontology/Vista_panor%C3%A1mica"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Vista_panor%C3%A1mica	http://phenomenontology.linkeddata.es/ontology/Vista_panor%C3%A1mica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
59	"http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeFerrocarril"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeFerrocarril	http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeFerrocarril	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
60	"http://geo.linkeddata.es/ontology/Ojo"^^<http://www.w3.org/2001/XMLSchema#string>	27	\N	t	\N	http://geo.linkeddata.es/ontology/Ojo	http://geo.linkeddata.es/ontology/Ojo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
61	"http://geo.linkeddata.es/def/btn100#CentralElectrica"^^<http://www.w3.org/2001/XMLSchema#string>	62	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralElectrica	http://geo.linkeddata.es/def/btn100#CentralElectrica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
62	"http://geo.linkeddata.es/def/btn100#IslaMaritima"^^<http://www.w3.org/2001/XMLSchema#string>	4603	\N	t	\N	http://geo.linkeddata.es/def/btn100#IslaMaritima	http://geo.linkeddata.es/def/btn100#IslaMaritima	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
63	"http://geo.linkeddata.es/ontology/Alberca"^^<http://www.w3.org/2001/XMLSchema#string>	6	\N	t	\N	http://geo.linkeddata.es/ontology/Alberca	http://geo.linkeddata.es/ontology/Alberca	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
64	"http://geo.linkeddata.es/ontology/Camino"^^<http://www.w3.org/2001/XMLSchema#string>	315	\N	t	\N	http://geo.linkeddata.es/ontology/Camino	http://geo.linkeddata.es/ontology/Camino	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
65	"http://geo.linkeddata.es/def/btn100#Collado"^^<http://www.w3.org/2001/XMLSchema#string>	154	\N	t	\N	http://geo.linkeddata.es/def/btn100#Collado	http://geo.linkeddata.es/def/btn100#Collado	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
66	"http://geo.linkeddata.es/def/btn100#EstacionDeTelevision"^^<http://www.w3.org/2001/XMLSchema#string>	736	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionDeTelevision	http://geo.linkeddata.es/def/btn100#EstacionDeTelevision	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
67	"http://geo.linkeddata.es/ontology/CintaTransportadora"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/CintaTransportadora	http://geo.linkeddata.es/ontology/CintaTransportadora	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
68	"http://geo.linkeddata.es/def/btn100#Telesqui"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://geo.linkeddata.es/def/btn100#Telesqui	http://geo.linkeddata.es/def/btn100#Telesqui	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
69	"http://geo.linkeddata.es/def/btn100#CentralTermica"^^<http://www.w3.org/2001/XMLSchema#string>	43	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralTermica	http://geo.linkeddata.es/def/btn100#CentralTermica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
70	"http://purl.org/NET/scovo#Dataset"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://purl.org/NET/scovo#Dataset	http://purl.org/NET/scovo#Dataset	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	575
71	"http://geo.linkeddata.es/def/btn100#FerrocarrilAltaVelocidad"^^<http://www.w3.org/2001/XMLSchema#string>	1086	\N	t	\N	http://geo.linkeddata.es/def/btn100#FerrocarrilAltaVelocidad	http://geo.linkeddata.es/def/btn100#FerrocarrilAltaVelocidad	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
72	"http://geo.linkeddata.es/def/btn100#Cementerio"^^<http://www.w3.org/2001/XMLSchema#string>	16761	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cementerio	http://geo.linkeddata.es/def/btn100#Cementerio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
73	"http://geo.linkeddata.es/ontology/Tuber%C3%ADa"^^<http://www.w3.org/2001/XMLSchema#string>	5	\N	t	\N	http://geo.linkeddata.es/ontology/Tuber%C3%ADa	http://geo.linkeddata.es/ontology/Tuber%C3%ADa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
74	"http://geo.linkeddata.es/def/btn100#ZonaAeroportuaria"^^<http://www.w3.org/2001/XMLSchema#string>	89	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaAeroportuaria	http://geo.linkeddata.es/def/btn100#ZonaAeroportuaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
75	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Pais"^^<http://www.w3.org/2001/XMLSchema#string>	6	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Pais	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Pais	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
76	"http://geo.linkeddata.es/def/btn100#Humedal"^^<http://www.w3.org/2001/XMLSchema#string>	105	\N	t	\N	http://geo.linkeddata.es/def/btn100#Humedal	http://geo.linkeddata.es/def/btn100#Humedal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
77	"http://geo.linkeddata.es/ontology/R%C3%ADo"^^<http://www.w3.org/2001/XMLSchema#string>	7449	\N	t	\N	http://geo.linkeddata.es/ontology/R%C3%ADo	http://geo.linkeddata.es/ontology/R%C3%ADo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	329
78	"http://geo.linkeddata.es/ontology/Desag%C3%BCe"^^<http://www.w3.org/2001/XMLSchema#string>	102	\N	t	\N	http://geo.linkeddata.es/ontology/Desag%C3%BCe	http://geo.linkeddata.es/ontology/Desag%C3%BCe	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
79	"http://www.w3.org/2002/07/owl#TransitiveProperty"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://www.w3.org/2002/07/owl#TransitiveProperty	http://www.w3.org/2002/07/owl#TransitiveProperty	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	3
80	"http://geo.linkeddata.es/def/FronteraTierraAgua"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://geo.linkeddata.es/def/FronteraTierraAgua	http://geo.linkeddata.es/def/FronteraTierraAgua	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
81	"http://geo.linkeddata.es/def/btn100#Hospital"^^<http://www.w3.org/2001/XMLSchema#string>	474	\N	t	\N	http://geo.linkeddata.es/def/btn100#Hospital	http://geo.linkeddata.es/def/btn100#Hospital	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
82	"http://geo.linkeddata.es/ontology/Aeropuerto"^^<http://www.w3.org/2001/XMLSchema#string>	84	\N	t	\N	http://geo.linkeddata.es/ontology/Aeropuerto	http://geo.linkeddata.es/ontology/Aeropuerto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
83	"http://geo.linkeddata.es/ontology/Venaje"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Venaje	http://geo.linkeddata.es/ontology/Venaje	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
85	"http://geo.linkeddata.es/def/btn100#CurvaNivelBatimetrica"^^<http://www.w3.org/2001/XMLSchema#string>	1751	\N	t	\N	http://geo.linkeddata.es/def/btn100#CurvaNivelBatimetrica	http://geo.linkeddata.es/def/btn100#CurvaNivelBatimetrica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
86	"http://geo.linkeddata.es/def/btn100#ItinerarioDeViaVerde"^^<http://www.w3.org/2001/XMLSchema#string>	118	\N	t	\N	http://geo.linkeddata.es/def/btn100#ItinerarioDeViaVerde	http://geo.linkeddata.es/def/btn100#ItinerarioDeViaVerde	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
87	"http://phenomenontology.linkeddata.es/ontology/Auditorio"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Auditorio	http://phenomenontology.linkeddata.es/ontology/Auditorio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
88	"http://geo.linkeddata.es/ontology/Autopista"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Autopista	http://geo.linkeddata.es/ontology/Autopista	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
89	"http://geo.linkeddata.es/def/btn100#AccidenteMaritimoPuntual"^^<http://www.w3.org/2001/XMLSchema#string>	204	\N	t	\N	http://geo.linkeddata.es/def/btn100#AccidenteMaritimoPuntual	http://geo.linkeddata.es/def/btn100#AccidenteMaritimoPuntual	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
90	"http://geo.linkeddata.es/ontology/Barranco"^^<http://www.w3.org/2001/XMLSchema#string>	10638	\N	t	\N	http://geo.linkeddata.es/ontology/Barranco	http://geo.linkeddata.es/ontology/Barranco	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
91	"http://geo.linkeddata.es/def/btn100#Penon"^^<http://www.w3.org/2001/XMLSchema#string>	13	\N	t	\N	http://geo.linkeddata.es/def/btn100#Penon	http://geo.linkeddata.es/def/btn100#Penon	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
92	"http://geo.linkeddata.es/def/btn100#EstacionTelefonica"^^<http://www.w3.org/2001/XMLSchema#string>	643	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionTelefonica	http://geo.linkeddata.es/def/btn100#EstacionTelefonica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
93	"http://geo.linkeddata.es/def/btn100#Balsa"^^<http://www.w3.org/2001/XMLSchema#string>	4768	\N	t	\N	http://geo.linkeddata.es/def/btn100#Balsa	http://geo.linkeddata.es/def/btn100#Balsa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
94	"http://purl.org/NET/scovo#Item"^^<http://www.w3.org/2001/XMLSchema#string>	575	\N	t	\N	http://purl.org/NET/scovo#Item	http://purl.org/NET/scovo#Item	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
95	"http://geo.linkeddata.es/def/btn100#Universidad"^^<http://www.w3.org/2001/XMLSchema#string>	140	\N	t	\N	http://geo.linkeddata.es/def/btn100#Universidad	http://geo.linkeddata.es/def/btn100#Universidad	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
96	"http://geo.linkeddata.es/ontology/Brazo"^^<http://www.w3.org/2001/XMLSchema#string>	14	\N	t	\N	http://geo.linkeddata.es/ontology/Brazo	http://geo.linkeddata.es/ontology/Brazo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
97	"http://geo.linkeddata.es/ontology/LineString"^^<http://www.w3.org/2001/XMLSchema#string>	100	\N	t	\N	http://geo.linkeddata.es/ontology/LineString	http://geo.linkeddata.es/ontology/LineString	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	100
98	"http://geo.linkeddata.es/ontology/Poza"^^<http://www.w3.org/2001/XMLSchema#string>	29	\N	t	\N	http://geo.linkeddata.es/ontology/Poza	http://geo.linkeddata.es/ontology/Poza	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
99	"http://geo.linkeddata.es/def/Barranco"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://geo.linkeddata.es/def/Barranco	http://geo.linkeddata.es/def/Barranco	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
100	"http://geo.linkeddata.es/def/btn100#Telesilla"^^<http://www.w3.org/2001/XMLSchema#string>	68	\N	t	\N	http://geo.linkeddata.es/def/btn100#Telesilla	http://geo.linkeddata.es/def/btn100#Telesilla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
101	"http://phenomenontology.linkeddata.es/ontology/Ayuntamiento"^^<http://www.w3.org/2001/XMLSchema#string>	20	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Ayuntamiento	http://phenomenontology.linkeddata.es/ontology/Ayuntamiento	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	30
102	"http://phenomenontology.linkeddata.es/ontology/Colegiata"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Colegiata	http://phenomenontology.linkeddata.es/ontology/Colegiata	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
103	"http://geo.linkeddata.es/def/btn100#ZonaVerde"^^<http://www.w3.org/2001/XMLSchema#string>	619	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaVerde	http://geo.linkeddata.es/def/btn100#ZonaVerde	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
104	"http://geo.linkeddata.es/def/btn100#Ensenada"^^<http://www.w3.org/2001/XMLSchema#string>	102	\N	t	\N	http://geo.linkeddata.es/def/btn100#Ensenada	http://geo.linkeddata.es/def/btn100#Ensenada	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
105	"http://geo.linkeddata.es/def/btn100#Castillo"^^<http://www.w3.org/2001/XMLSchema#string>	2467	\N	t	\N	http://geo.linkeddata.es/def/btn100#Castillo	http://geo.linkeddata.es/def/btn100#Castillo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
106	"http://geo.linkeddata.es/def/btn100#ZonaFerroviaria"^^<http://www.w3.org/2001/XMLSchema#string>	34	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaFerroviaria	http://geo.linkeddata.es/def/btn100#ZonaFerroviaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
107	"http://www.opengis.net/ont/sf#MultiPolygon"^^<http://www.w3.org/2001/XMLSchema#string>	1138	\N	t	\N	http://www.opengis.net/ont/sf#MultiPolygon	http://www.opengis.net/ont/sf#MultiPolygon	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1138
108	"http://geo.linkeddata.es/ontology/Aljibe"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://geo.linkeddata.es/ontology/Aljibe	http://geo.linkeddata.es/ontology/Aljibe	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
109	"http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteMaritimo"^^<http://www.w3.org/2001/XMLSchema#string>	190	\N	t	\N	http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteMaritimo	http://geo.linkeddata.es/def/btn100#EntidadVirtualAccidenteMaritimo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
110	"http://geo.linkeddata.es/def/Lago"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/def/Lago	http://geo.linkeddata.es/def/Lago	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
111	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#CiudadAutonoma"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#CiudadAutonoma	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#CiudadAutonoma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
112	"http://geo.linkeddata.es/ontology/Salina"^^<http://www.w3.org/2001/XMLSchema#string>	226	\N	t	\N	http://geo.linkeddata.es/ontology/Salina	http://geo.linkeddata.es/ontology/Salina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
113	"http://geo.linkeddata.es/ontology/Garganta"^^<http://www.w3.org/2001/XMLSchema#string>	392	\N	t	\N	http://geo.linkeddata.es/ontology/Garganta	http://geo.linkeddata.es/ontology/Garganta	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
114	"http://geo.linkeddata.es/ontology/BaseA%C3%A9rea"^^<http://www.w3.org/2001/XMLSchema#string>	10	\N	t	\N	http://geo.linkeddata.es/ontology/BaseA%C3%A9rea	http://geo.linkeddata.es/ontology/BaseA%C3%A9rea	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
115	"http://geo.linkeddata.es/def/btn100#Paraje"^^<http://www.w3.org/2001/XMLSchema#string>	896	\N	t	\N	http://geo.linkeddata.es/def/btn100#Paraje	http://geo.linkeddata.es/def/btn100#Paraje	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
116	"http://geo.linkeddata.es/ontology/Regato"^^<http://www.w3.org/2001/XMLSchema#string>	1119	\N	t	\N	http://geo.linkeddata.es/ontology/Regato	http://geo.linkeddata.es/ontology/Regato	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
117	"http://phenomenontology.linkeddata.es/ontology/Teatro"^^<http://www.w3.org/2001/XMLSchema#string>	11	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Teatro	http://phenomenontology.linkeddata.es/ontology/Teatro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	15
118	"http://geo.linkeddata.es/def/btn100#Cerro"^^<http://www.w3.org/2001/XMLSchema#string>	1368	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cerro	http://geo.linkeddata.es/def/btn100#Cerro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
119	"http://geo.linkeddata.es/def/btn100#RioLineal"^^<http://www.w3.org/2001/XMLSchema#string>	33735	\N	t	\N	http://geo.linkeddata.es/def/btn100#RioLineal	http://geo.linkeddata.es/def/btn100#RioLineal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
120	"http://geo.linkeddata.es/ontology/Glorieta"^^<http://www.w3.org/2001/XMLSchema#string>	26	\N	t	\N	http://geo.linkeddata.es/ontology/Glorieta	http://geo.linkeddata.es/ontology/Glorieta	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
121	"http://geo.linkeddata.es/def/btn100#JardinHistorico"^^<http://www.w3.org/2001/XMLSchema#string>	57	\N	t	\N	http://geo.linkeddata.es/def/btn100#JardinHistorico	http://geo.linkeddata.es/def/btn100#JardinHistorico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
122	"http://phenomenontology.linkeddata.es/ontology/Acueducto"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Acueducto	http://phenomenontology.linkeddata.es/ontology/Acueducto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	7
123	"http://geo.linkeddata.es/def/btn100#EdificioReligioso"^^<http://www.w3.org/2001/XMLSchema#string>	13009	\N	t	\N	http://geo.linkeddata.es/def/btn100#EdificioReligioso	http://geo.linkeddata.es/def/btn100#EdificioReligioso	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
124	"http://geo.linkeddata.es/def/btn100#Estanque"^^<http://www.w3.org/2001/XMLSchema#string>	54	\N	t	\N	http://geo.linkeddata.es/def/btn100#Estanque	http://geo.linkeddata.es/def/btn100#Estanque	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
125	"http://phenomenontology.linkeddata.es/ontology/Ruinas"^^<http://www.w3.org/2001/XMLSchema#string>	81	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Ruinas	http://phenomenontology.linkeddata.es/ontology/Ruinas	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	92
126	"http://geo.linkeddata.es/def/btn100#Cueva"^^<http://www.w3.org/2001/XMLSchema#string>	818	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cueva	http://geo.linkeddata.es/def/btn100#Cueva	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
127	"http://phenomenontology.linkeddata.es/ontology/Castillo"^^<http://www.w3.org/2001/XMLSchema#string>	641	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Castillo	http://phenomenontology.linkeddata.es/ontology/Castillo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	682
128	"http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeAutobuses"^^<http://www.w3.org/2001/XMLSchema#string>	33	\N	t	\N	http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeAutobuses	http://geo.linkeddata.es/ontology/Estaci%C3%B3nDeAutobuses	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
129	"http://geo.linkeddata.es/ontology/Madre"^^<http://www.w3.org/2001/XMLSchema#string>	15	\N	t	\N	http://geo.linkeddata.es/ontology/Madre	http://geo.linkeddata.es/ontology/Madre	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
130	"http://geo.linkeddata.es/def/Marisma"^^<http://www.w3.org/2001/XMLSchema#string>	98	\N	t	\N	http://geo.linkeddata.es/def/Marisma	http://geo.linkeddata.es/def/Marisma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
131	"http://geo.linkeddata.es/def/btn100#CanalMayor"^^<http://www.w3.org/2001/XMLSchema#string>	985	\N	t	\N	http://geo.linkeddata.es/def/btn100#CanalMayor	http://geo.linkeddata.es/def/btn100#CanalMayor	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
132	"http://phenomenontology.linkeddata.es/ontology/B%C3%B3veda"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/B%C3%B3veda	http://phenomenontology.linkeddata.es/ontology/B%C3%B3veda	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	3
133	"http://phenomenontology.linkeddata.es/ontology/Villa"^^<http://www.w3.org/2001/XMLSchema#string>	9	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Villa	http://phenomenontology.linkeddata.es/ontology/Villa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	15
134	"http://www.opengis.net/ont/gml#Point"^^<http://www.w3.org/2001/XMLSchema#string>	2653	\N	t	\N	http://www.opengis.net/ont/gml#Point	http://www.opengis.net/ont/gml#Point	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	3157
135	"http://phenomenontology.linkeddata.es/ontology/Convento"^^<http://www.w3.org/2001/XMLSchema#string>	98	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Convento	http://phenomenontology.linkeddata.es/ontology/Convento	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	127
136	"http://geo.linkeddata.es/ontology/Nava"^^<http://www.w3.org/2001/XMLSchema#string>	119	\N	t	\N	http://geo.linkeddata.es/ontology/Nava	http://geo.linkeddata.es/ontology/Nava	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
137	"http://phenomenontology.linkeddata.es/ontology/Cortijo"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Cortijo	http://phenomenontology.linkeddata.es/ontology/Cortijo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
138	"http://geo.linkeddata.es/def/btn100#EstacionPermanenteGPS"^^<http://www.w3.org/2001/XMLSchema#string>	45	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionPermanenteGPS	http://geo.linkeddata.es/def/btn100#EstacionPermanenteGPS	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
139	"http://geo.linkeddata.es/def/btn100#EstacionDeRadio"^^<http://www.w3.org/2001/XMLSchema#string>	91	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionDeRadio	http://geo.linkeddata.es/def/btn100#EstacionDeRadio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
140	"http://geo.linkeddata.es/def/btn100#PuertoDeMontana"^^<http://www.w3.org/2001/XMLSchema#string>	502	\N	t	\N	http://geo.linkeddata.es/def/btn100#PuertoDeMontana	http://geo.linkeddata.es/def/btn100#PuertoDeMontana	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
141	"http://www.openlinksw.com/schemas/virtrdf#QuadMapColumn"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMapColumn	http://www.openlinksw.com/schemas/virtrdf#QuadMapColumn	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	8
142	"http://phenomenontology.linkeddata.es/ontology/Faro"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Faro	http://phenomenontology.linkeddata.es/ontology/Faro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
143	"http://geo.linkeddata.es/ontology/Embalse"^^<http://www.w3.org/2001/XMLSchema#string>	1750	\N	t	\N	http://geo.linkeddata.es/ontology/Embalse	http://geo.linkeddata.es/ontology/Embalse	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
144	"http://geo.linkeddata.es/def/btn100#Pista"^^<http://www.w3.org/2001/XMLSchema#string>	93646	\N	t	\N	http://geo.linkeddata.es/def/btn100#Pista	http://geo.linkeddata.es/def/btn100#Pista	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
145	"http://geo.linkeddata.es/def/btn100#PuntoAcotado"^^<http://www.w3.org/2001/XMLSchema#string>	44485	\N	t	\N	http://geo.linkeddata.es/def/btn100#PuntoAcotado	http://geo.linkeddata.es/def/btn100#PuntoAcotado	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
146	"http://phenomenontology.linkeddata.es/ontology/Abad%C3%ADa"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Abad%C3%ADa	http://phenomenontology.linkeddata.es/ontology/Abad%C3%ADa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
147	"http://geo.linkeddata.es/def/btn100#CentralEolica"^^<http://www.w3.org/2001/XMLSchema#string>	1521	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralEolica	http://geo.linkeddata.es/def/btn100#CentralEolica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
148	"http://geo.linkeddata.es/ontology/Balsa"^^<http://www.w3.org/2001/XMLSchema#string>	942	\N	t	\N	http://geo.linkeddata.es/ontology/Balsa	http://geo.linkeddata.es/ontology/Balsa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
149	"http://geo.linkeddata.es/def/btn100#EdificioSingular"^^<http://www.w3.org/2001/XMLSchema#string>	1992	\N	t	\N	http://geo.linkeddata.es/def/btn100#EdificioSingular	http://geo.linkeddata.es/def/btn100#EdificioSingular	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
150	"http://geo.linkeddata.es/def/Embalse"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/def/Embalse	http://geo.linkeddata.es/def/Embalse	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
151	"http://geo.linkeddata.es/def/btn100#ParadorNacional"^^<http://www.w3.org/2001/XMLSchema#string>	93	\N	t	\N	http://geo.linkeddata.es/def/btn100#ParadorNacional	http://geo.linkeddata.es/def/btn100#ParadorNacional	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
152	"http://phenomenontology.linkeddata.es/ontology/Yacimiento"^^<http://www.w3.org/2001/XMLSchema#string>	20	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Yacimiento	http://phenomenontology.linkeddata.es/ontology/Yacimiento	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	26
153	"http://www.w3.org/1999/02/22-rdf-syntax-ns#List"^^<http://www.w3.org/2001/XMLSchema#string>	114	\N	t	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	114
154	"http://geo.linkeddata.es/def/btn100#Invernadero"^^<http://www.w3.org/2001/XMLSchema#string>	3499	\N	t	\N	http://geo.linkeddata.es/def/btn100#Invernadero	http://geo.linkeddata.es/def/btn100#Invernadero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
180	"http://phenomenontology.linkeddata.es/ontology/Parque"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Parque	http://phenomenontology.linkeddata.es/ontology/Parque	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
155	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadAutonoma"^^<http://www.w3.org/2001/XMLSchema#string>	17	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadAutonoma	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadAutonoma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
156	"http://phenomenontology.linkeddata.es/ontology/Anfiteatro"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Anfiteatro	http://phenomenontology.linkeddata.es/ontology/Anfiteatro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
157	"http://geo.linkeddata.es/def/btn100#Teleferico"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/def/btn100#Teleferico	http://geo.linkeddata.es/def/btn100#Teleferico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
158	"http://phenomenontology.linkeddata.es/ontology/Molino"^^<http://www.w3.org/2001/XMLSchema#string>	19	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Molino	http://phenomenontology.linkeddata.es/ontology/Molino	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	17
159	"http://geo.linkeddata.es/ontology/Acu%C3%ADfero"^^<http://www.w3.org/2001/XMLSchema#string>	113	\N	t	\N	http://geo.linkeddata.es/ontology/Acu%C3%ADfero	http://geo.linkeddata.es/ontology/Acu%C3%ADfero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
160	"http://phenomenontology.linkeddata.es/ontology/Plaza_de_toros"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Plaza_de_toros	http://phenomenontology.linkeddata.es/ontology/Plaza_de_toros	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
161	"http://vocab.linkeddata.es/datosabiertos/def/urbanismo-infraestructuras/callejero#Via"^^<http://www.w3.org/2001/XMLSchema#string>	80673	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/urbanismo-infraestructuras/callejero#Via	http://vocab.linkeddata.es/datosabiertos/def/urbanismo-infraestructuras/callejero#Via	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
162	"http://geo.linkeddata.es/def/btn100#CentralCicloCombinado"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralCicloCombinado	http://geo.linkeddata.es/def/btn100#CentralCicloCombinado	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
163	"http://geo.linkeddata.es/def/btn100#Salina"^^<http://www.w3.org/2001/XMLSchema#string>	140	\N	t	\N	http://geo.linkeddata.es/def/btn100#Salina	http://geo.linkeddata.es/def/btn100#Salina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
164	"http://geo.linkeddata.es/ontology/Municipio"^^<http://www.w3.org/2001/XMLSchema#string>	9969	\N	t	\N	http://geo.linkeddata.es/ontology/Municipio	http://geo.linkeddata.es/ontology/Municipio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	20909
165	"http://geo.linkeddata.es/def/btn100#Oleoducto"^^<http://www.w3.org/2001/XMLSchema#string>	27	\N	t	\N	http://geo.linkeddata.es/def/btn100#Oleoducto	http://geo.linkeddata.es/def/btn100#Oleoducto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
166	"http://geo.linkeddata.es/def/btn100#DiseminadoPuntual"^^<http://www.w3.org/2001/XMLSchema#string>	41983	\N	t	\N	http://geo.linkeddata.es/def/btn100#DiseminadoPuntual	http://geo.linkeddata.es/def/btn100#DiseminadoPuntual	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
167	"http://geo.linkeddata.es/def/btn100#FerrocarrilConvencional"^^<http://www.w3.org/2001/XMLSchema#string>	4512	\N	t	\N	http://geo.linkeddata.es/def/btn100#FerrocarrilConvencional	http://geo.linkeddata.es/def/btn100#FerrocarrilConvencional	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
168	"http://geo.linkeddata.es/ontology/Marjal"^^<http://www.w3.org/2001/XMLSchema#string>	21	\N	t	\N	http://geo.linkeddata.es/ontology/Marjal	http://geo.linkeddata.es/ontology/Marjal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
169	"http://geo.linkeddata.es/def/btn100#ParqueNatural"^^<http://www.w3.org/2001/XMLSchema#string>	104	\N	t	\N	http://geo.linkeddata.es/def/btn100#ParqueNatural	http://geo.linkeddata.es/def/btn100#ParqueNatural	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
170	"http://geo.linkeddata.es/ontology/FuenteNatural"^^<http://www.w3.org/2001/XMLSchema#string>	2467	\N	t	\N	http://geo.linkeddata.es/ontology/FuenteNatural	http://geo.linkeddata.es/ontology/FuenteNatural	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
171	"http://code.google.com/p/map4rdf/wiki/ontology#FacetGroup"^^<http://www.w3.org/2001/XMLSchema#string>	7	\N	t	\N	http://code.google.com/p/map4rdf/wiki/ontology#FacetGroup	http://code.google.com/p/map4rdf/wiki/ontology#FacetGroup	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
172	"http://www.opengis.net/ont/sf#Point"^^<http://www.w3.org/2001/XMLSchema#string>	275148	\N	t	\N	http://www.opengis.net/ont/sf#Point	http://www.opengis.net/ont/sf#Point	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	275148
173	"http://www.openlinksw.com/schemas/virtrdf#QuadMapATable"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMapATable	http://www.openlinksw.com/schemas/virtrdf#QuadMapATable	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
174	"http://geo.linkeddata.es/ontology/Cascada"^^<http://www.w3.org/2001/XMLSchema#string>	409	\N	t	\N	http://geo.linkeddata.es/ontology/Cascada	http://geo.linkeddata.es/ontology/Cascada	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
175	"http://geo.linkeddata.es/ontology/Curva"^^<http://www.w3.org/2001/XMLSchema#string>	17164	\N	t	\N	http://geo.linkeddata.es/ontology/Curva	http://geo.linkeddata.es/ontology/Curva	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	17164
176	"http://geo.linkeddata.es/def/btn100#Apeadero"^^<http://www.w3.org/2001/XMLSchema#string>	543	\N	t	\N	http://geo.linkeddata.es/def/btn100#Apeadero	http://geo.linkeddata.es/def/btn100#Apeadero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
177	"http://phenomenontology.linkeddata.es/ontology/Observatorio"^^<http://www.w3.org/2001/XMLSchema#string>	14	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Observatorio	http://phenomenontology.linkeddata.es/ontology/Observatorio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	17
178	"http://geo.linkeddata.es/ontology/Organizaci%C3%B3n"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Organizaci%C3%B3n	http://geo.linkeddata.es/ontology/Organizaci%C3%B3n	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
179	"http://www.openlinksw.com/schemas/virtrdf#QuadMapFText"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMapFText	http://www.openlinksw.com/schemas/virtrdf#QuadMapFText	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	3
181	"http://geo.linkeddata.es/ontology/Lucio"^^<http://www.w3.org/2001/XMLSchema#string>	59	\N	t	\N	http://geo.linkeddata.es/ontology/Lucio	http://geo.linkeddata.es/ontology/Lucio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
182	"http://geo.linkeddata.es/ontology/Oc%C3%A9ano"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Oc%C3%A9ano	http://geo.linkeddata.es/ontology/Oc%C3%A9ano	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
183	"http://phenomenontology.linkeddata.es/ontology/Biblioteca"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Biblioteca	http://phenomenontology.linkeddata.es/ontology/Biblioteca	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
184	"http://geo.linkeddata.es/ontology/Ruta"^^<http://www.w3.org/2001/XMLSchema#string>	3684	\N	t	\N	http://geo.linkeddata.es/ontology/Ruta	http://geo.linkeddata.es/ontology/Ruta	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
185	"http://phenomenontology.linkeddata.es/ontology/Puente"^^<http://www.w3.org/2001/XMLSchema#string>	9	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Puente	http://phenomenontology.linkeddata.es/ontology/Puente	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	9
186	"http://geo.linkeddata.es/def/btn100#InstalacionDeportiva"^^<http://www.w3.org/2001/XMLSchema#string>	8442	\N	t	\N	http://geo.linkeddata.es/def/btn100#InstalacionDeportiva	http://geo.linkeddata.es/def/btn100#InstalacionDeportiva	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
187	"http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapATable"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapATable	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapATable	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	8
188	"http://geo.linkeddata.es/def/btn100#CanalTrasvase"^^<http://www.w3.org/2001/XMLSchema#string>	221	\N	t	\N	http://geo.linkeddata.es/def/btn100#CanalTrasvase	http://geo.linkeddata.es/def/btn100#CanalTrasvase	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
189	"http://geo.linkeddata.es/ontology/Charca"^^<http://www.w3.org/2001/XMLSchema#string>	352	\N	t	\N	http://geo.linkeddata.es/ontology/Charca	http://geo.linkeddata.es/ontology/Charca	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
190	"http://geo.linkeddata.es/ontology/Surgencia"^^<http://www.w3.org/2001/XMLSchema#string>	9	\N	t	\N	http://geo.linkeddata.es/ontology/Surgencia	http://geo.linkeddata.es/ontology/Surgencia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
191	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Provincia"^^<http://www.w3.org/2001/XMLSchema#string>	50	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Provincia	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Provincia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
192	"http://geo.linkeddata.es/def/btn100#VerticeGeodesicoRegcan95"^^<http://www.w3.org/2001/XMLSchema#string>	10030	\N	t	\N	http://geo.linkeddata.es/def/btn100#VerticeGeodesicoRegcan95	http://geo.linkeddata.es/def/btn100#VerticeGeodesicoRegcan95	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
193	"http://geo.linkeddata.es/def/btn100#LineaElectricaDeAltaTension"^^<http://www.w3.org/2001/XMLSchema#string>	1115	\N	t	\N	http://geo.linkeddata.es/def/btn100#LineaElectricaDeAltaTension	http://geo.linkeddata.es/def/btn100#LineaElectricaDeAltaTension	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
194	"http://geo.linkeddata.es/def/btn100#Estrecho"^^<http://www.w3.org/2001/XMLSchema#string>	5	\N	t	\N	http://geo.linkeddata.es/def/btn100#Estrecho	http://geo.linkeddata.es/def/btn100#Estrecho	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
195	"http://geo.linkeddata.es/ontology/Reguero"^^<http://www.w3.org/2001/XMLSchema#string>	743	\N	t	\N	http://geo.linkeddata.es/ontology/Reguero	http://geo.linkeddata.es/ontology/Reguero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
196	"http://geo.linkeddata.es/ontology/R%C3%ADa"^^<http://www.w3.org/2001/XMLSchema#string>	89	\N	t	\N	http://geo.linkeddata.es/ontology/R%C3%ADa	http://geo.linkeddata.es/ontology/R%C3%ADa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
197	"http://geo.linkeddata.es/ontology/Dep%C3%B3sito"^^<http://www.w3.org/2001/XMLSchema#string>	43	\N	t	\N	http://geo.linkeddata.es/ontology/Dep%C3%B3sito	http://geo.linkeddata.es/ontology/Dep%C3%B3sito	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
198	"http://geo.linkeddata.es/def/btn100#VerticeGeodesicoDeOrdenInferior"^^<http://www.w3.org/2001/XMLSchema#string>	1111	\N	t	\N	http://geo.linkeddata.es/def/btn100#VerticeGeodesicoDeOrdenInferior	http://geo.linkeddata.es/def/btn100#VerticeGeodesicoDeOrdenInferior	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
199	"http://geo.linkeddata.es/ontology/Pista"^^<http://www.w3.org/2001/XMLSchema#string>	24	\N	t	\N	http://geo.linkeddata.es/ontology/Pista	http://geo.linkeddata.es/ontology/Pista	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
200	"http://geo.linkeddata.es/ontology/Faro"^^<http://www.w3.org/2001/XMLSchema#string>	127	\N	t	\N	http://geo.linkeddata.es/ontology/Faro	http://geo.linkeddata.es/ontology/Faro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
201	"http://geo.linkeddata.es/def/btn100#ConjuntoHistorico"^^<http://www.w3.org/2001/XMLSchema#string>	694	\N	t	\N	http://geo.linkeddata.es/def/btn100#ConjuntoHistorico	http://geo.linkeddata.es/def/btn100#ConjuntoHistorico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
202	"http://geo.linkeddata.es/def/btn100#ZonaRecreativa"^^<http://www.w3.org/2001/XMLSchema#string>	292	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaRecreativa	http://geo.linkeddata.es/def/btn100#ZonaRecreativa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
203	"http://geo.linkeddata.es/ontology/Desembocadura"^^<http://www.w3.org/2001/XMLSchema#string>	81	\N	t	\N	http://geo.linkeddata.es/ontology/Desembocadura	http://geo.linkeddata.es/ontology/Desembocadura	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
204	"http://geo.linkeddata.es/def/btn100#EstacionDeSuministro"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionDeSuministro	http://geo.linkeddata.es/def/btn100#EstacionDeSuministro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
205	"http://geo.linkeddata.es/def/btn100#DiseminadoSuperficial"^^<http://www.w3.org/2001/XMLSchema#string>	7146	\N	t	\N	http://geo.linkeddata.es/def/btn100#DiseminadoSuperficial	http://geo.linkeddata.es/def/btn100#DiseminadoSuperficial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
206	"http://geo.linkeddata.es/ontology/Captaci%C3%B3n"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Captaci%C3%B3n	http://geo.linkeddata.es/ontology/Captaci%C3%B3n	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
207	"http://geo.linkeddata.es/def/btn100#ConduccionDeCombustible"^^<http://www.w3.org/2001/XMLSchema#string>	46	\N	t	\N	http://geo.linkeddata.es/def/btn100#ConduccionDeCombustible	http://geo.linkeddata.es/def/btn100#ConduccionDeCombustible	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
208	"http://www.w3.org/2002/07/owl#Ontology"^^<http://www.w3.org/2001/XMLSchema#string>	5	\N	t	\N	http://www.w3.org/2002/07/owl#Ontology	http://www.w3.org/2002/07/owl#Ontology	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
209	"http://geo.linkeddata.es/def/btn100#Cabo"^^<http://www.w3.org/2001/XMLSchema#string>	169	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cabo	http://geo.linkeddata.es/def/btn100#Cabo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
210	"http://geo.linkeddata.es/def/btn100#EstacionTelecomunicaciones"^^<http://www.w3.org/2001/XMLSchema#string>	1418	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionTelecomunicaciones	http://geo.linkeddata.es/def/btn100#EstacionTelecomunicaciones	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
211	"http://www.w3.org/2002/07/owl#DataRange"^^<http://www.w3.org/2001/XMLSchema#string>	24	\N	t	\N	http://www.w3.org/2002/07/owl#DataRange	http://www.w3.org/2002/07/owl#DataRange	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	24
212	"http://geo.linkeddata.es/ontology/Reguera"^^<http://www.w3.org/2001/XMLSchema#string>	97	\N	t	\N	http://geo.linkeddata.es/ontology/Reguera	http://geo.linkeddata.es/ontology/Reguera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
213	"http://geo.linkeddata.es/def/btn100#Sierra"^^<http://www.w3.org/2001/XMLSchema#string>	2734	\N	t	\N	http://geo.linkeddata.es/def/btn100#Sierra	http://geo.linkeddata.es/def/btn100#Sierra	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
214	"http://geo.linkeddata.es/ontology/CarreteraAutonomica"^^<http://www.w3.org/2001/XMLSchema#string>	9670	\N	t	\N	http://geo.linkeddata.es/ontology/CarreteraAutonomica	http://geo.linkeddata.es/ontology/CarreteraAutonomica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
215	"http://geo.linkeddata.es/ontology/Laguna"^^<http://www.w3.org/2001/XMLSchema#string>	1454	\N	t	\N	http://geo.linkeddata.es/ontology/Laguna	http://geo.linkeddata.es/ontology/Laguna	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
216	"http://geo.linkeddata.es/def/btn100#CarreteraAutonomica"^^<http://www.w3.org/2001/XMLSchema#string>	73801	\N	t	\N	http://geo.linkeddata.es/def/btn100#CarreteraAutonomica	http://geo.linkeddata.es/def/btn100#CarreteraAutonomica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
217	"http://geo.linkeddata.es/def/btn100#Pico"^^<http://www.w3.org/2001/XMLSchema#string>	1146	\N	t	\N	http://geo.linkeddata.es/def/btn100#Pico	http://geo.linkeddata.es/def/btn100#Pico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
218	"http://geo.linkeddata.es/ontology/Nacimiento"^^<http://www.w3.org/2001/XMLSchema#string>	483	\N	t	\N	http://geo.linkeddata.es/ontology/Nacimiento	http://geo.linkeddata.es/ontology/Nacimiento	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
219	"http://geo.linkeddata.es/ontology/Provincia"^^<http://www.w3.org/2001/XMLSchema#string>	152	\N	t	\N	http://geo.linkeddata.es/ontology/Provincia	http://geo.linkeddata.es/ontology/Provincia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	39048
220	"http://geo.linkeddata.es/ontology/Meandro"^^<http://www.w3.org/2001/XMLSchema#string>	102	\N	t	\N	http://geo.linkeddata.es/ontology/Meandro	http://geo.linkeddata.es/ontology/Meandro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
221	"http://geo.linkeddata.es/ontology/Ribera"^^<http://www.w3.org/2001/XMLSchema#string>	248	\N	t	\N	http://geo.linkeddata.es/ontology/Ribera	http://geo.linkeddata.es/ontology/Ribera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
222	"http://geo.linkeddata.es/def/btn100#Gasolinera"^^<http://www.w3.org/2001/XMLSchema#string>	7222	\N	t	\N	http://geo.linkeddata.es/def/btn100#Gasolinera	http://geo.linkeddata.es/def/btn100#Gasolinera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
223	"http://geo.linkeddata.es/def/btn100#ZonaMilitar"^^<http://www.w3.org/2001/XMLSchema#string>	144	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaMilitar	http://geo.linkeddata.es/def/btn100#ZonaMilitar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
224	"http://geo.linkeddata.es/def/btn100#Cordillera"^^<http://www.w3.org/2001/XMLSchema#string>	57	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cordillera	http://geo.linkeddata.es/def/btn100#Cordillera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
225	"http://geo.linkeddata.es/ontology/Marisma"^^<http://www.w3.org/2001/XMLSchema#string>	131	\N	t	\N	http://geo.linkeddata.es/ontology/Marisma	http://geo.linkeddata.es/ontology/Marisma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
226	"http://geo.linkeddata.es/def/btn100#Balneario"^^<http://www.w3.org/2001/XMLSchema#string>	125	\N	t	\N	http://geo.linkeddata.es/def/btn100#Balneario	http://geo.linkeddata.es/def/btn100#Balneario	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
227	"http://geo.linkeddata.es/ontology/Estanque"^^<http://www.w3.org/2001/XMLSchema#string>	287	\N	t	\N	http://geo.linkeddata.es/ontology/Estanque	http://geo.linkeddata.es/ontology/Estanque	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
228	"http://geo.linkeddata.es/def/btn100#RioSuperficial"^^<http://www.w3.org/2001/XMLSchema#string>	463	\N	t	\N	http://geo.linkeddata.es/def/btn100#RioSuperficial	http://geo.linkeddata.es/def/btn100#RioSuperficial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
229	"http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMap"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMap	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMap	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
230	"http://geo.linkeddata.es/ontology/Aeroclub"^^<http://www.w3.org/2001/XMLSchema#string>	18	\N	t	\N	http://geo.linkeddata.es/ontology/Aeroclub	http://geo.linkeddata.es/ontology/Aeroclub	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
231	"http://www.w3.org/2002/07/owl#DatatypeProperty"^^<http://www.w3.org/2001/XMLSchema#string>	79	\N	t	\N	http://www.w3.org/2002/07/owl#DatatypeProperty	http://www.w3.org/2002/07/owl#DatatypeProperty	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	6
232	"http://phenomenontology.linkeddata.es/ontology/Palacio"^^<http://www.w3.org/2001/XMLSchema#string>	92	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Palacio	http://phenomenontology.linkeddata.es/ontology/Palacio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	14
233	"http://geo.linkeddata.es/def/Esclusa"^^<http://www.w3.org/2001/XMLSchema#string>	15	\N	t	\N	http://geo.linkeddata.es/def/Esclusa	http://geo.linkeddata.es/def/Esclusa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
234	"http://phenomenontology.linkeddata.es/ontology/Pazo"^^<http://www.w3.org/2001/XMLSchema#string>	48	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Pazo	http://phenomenontology.linkeddata.es/ontology/Pazo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	50
235	"http://geo.linkeddata.es/def/btn100#Mar"^^<http://www.w3.org/2001/XMLSchema#string>	29	\N	t	\N	http://geo.linkeddata.es/def/btn100#Mar	http://geo.linkeddata.es/def/btn100#Mar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
236	"http://www.openlinksw.com/schemas/virtrdf#QuadMap"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMap	http://www.openlinksw.com/schemas/virtrdf#QuadMap	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
237	"http://www.openlinksw.com/schemas/virtrdf#QuadStorage"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadStorage	http://www.openlinksw.com/schemas/virtrdf#QuadStorage	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
238	"http://www.opengis.net/ont/sf#LineString"^^<http://www.w3.org/2001/XMLSchema#string>	506264	\N	t	\N	http://www.opengis.net/ont/sf#LineString	http://www.opengis.net/ont/sf#LineString	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	506264
239	"http://geo.linkeddata.es/def/btn100#Albufera"^^<http://www.w3.org/2001/XMLSchema#string>	10	\N	t	\N	http://geo.linkeddata.es/def/btn100#Albufera	http://geo.linkeddata.es/def/btn100#Albufera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
240	"http://geo.linkeddata.es/ontology/Rivera"^^<http://www.w3.org/2001/XMLSchema#string>	208	\N	t	\N	http://geo.linkeddata.es/ontology/Rivera	http://geo.linkeddata.es/ontology/Rivera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
241	"http://geo.linkeddata.es/def/btn100#PasoANivel"^^<http://www.w3.org/2001/XMLSchema#string>	911	\N	t	\N	http://geo.linkeddata.es/def/btn100#PasoANivel	http://geo.linkeddata.es/def/btn100#PasoANivel	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
242	"http://geo.linkeddata.es/def/btn100#Albergue"^^<http://www.w3.org/2001/XMLSchema#string>	685	\N	t	\N	http://geo.linkeddata.es/def/btn100#Albergue	http://geo.linkeddata.es/def/btn100#Albergue	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
243	"http://geo.linkeddata.es/def/btn100#ZonaProtegida"^^<http://www.w3.org/2001/XMLSchema#string>	69	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaProtegida	http://geo.linkeddata.es/def/btn100#ZonaProtegida	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
244	"http://geo.linkeddata.es/ontology/Lavajo"^^<http://www.w3.org/2001/XMLSchema#string>	89	\N	t	\N	http://geo.linkeddata.es/ontology/Lavajo	http://geo.linkeddata.es/ontology/Lavajo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
245	"http://geo.linkeddata.es/def/btn100#Cantera"^^<http://www.w3.org/2001/XMLSchema#string>	3546	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cantera	http://geo.linkeddata.es/def/btn100#Cantera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
246	"http://geo.linkeddata.es/ontology/Caz"^^<http://www.w3.org/2001/XMLSchema#string>	69	\N	t	\N	http://geo.linkeddata.es/ontology/Caz	http://geo.linkeddata.es/ontology/Caz	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
247	"http://geo.linkeddata.es/def/btn100#CentralHidraulica"^^<http://www.w3.org/2001/XMLSchema#string>	110	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralHidraulica	http://geo.linkeddata.es/def/btn100#CentralHidraulica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
248	"http://geo.linkeddata.es/def/btn100#LugarImportanciaComunitaria"^^<http://www.w3.org/2001/XMLSchema#string>	957	\N	t	\N	http://geo.linkeddata.es/def/btn100#LugarImportanciaComunitaria	http://geo.linkeddata.es/def/btn100#LugarImportanciaComunitaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
249	"http://phenomenontology.linkeddata.es/ontology/Cartuja"^^<http://www.w3.org/2001/XMLSchema#string>	5	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Cartuja	http://phenomenontology.linkeddata.es/ontology/Cartuja	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
250	"http://phenomenontology.linkeddata.es/ontology/Castro"^^<http://www.w3.org/2001/XMLSchema#string>	187	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Castro	http://phenomenontology.linkeddata.es/ontology/Castro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	249
251	"http://www.openlinksw.com/schemas/virtrdf#QuadMapValue"^^<http://www.w3.org/2001/XMLSchema#string>	8	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMapValue	http://www.openlinksw.com/schemas/virtrdf#QuadMapValue	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	8
252	"http://geo.linkeddata.es/ontology/Traves%C3%ADa"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://geo.linkeddata.es/ontology/Traves%C3%ADa	http://geo.linkeddata.es/ontology/Traves%C3%ADa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
253	"http://phenomenontology.linkeddata.es/ontology/Hospital"^^<http://www.w3.org/2001/XMLSchema#string>	23	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Hospital	http://phenomenontology.linkeddata.es/ontology/Hospital	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	31
254	"http://phenomenontology.linkeddata.es/ontology/Mirador"^^<http://www.w3.org/2001/XMLSchema#string>	13	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Mirador	http://phenomenontology.linkeddata.es/ontology/Mirador	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	21
255	"http://geo.linkeddata.es/def/btn100#ZonaDeUsoCaracteristico"^^<http://www.w3.org/2001/XMLSchema#string>	163	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaDeUsoCaracteristico	http://geo.linkeddata.es/def/btn100#ZonaDeUsoCaracteristico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
256	"http://www.opengis.net/ont/sf#Polygon"^^<http://www.w3.org/2001/XMLSchema#string>	90247	\N	t	\N	http://www.opengis.net/ont/sf#Polygon	http://www.opengis.net/ont/sf#Polygon	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	90247
257	"http://phenomenontology.linkeddata.es/ontology/Monasterio"^^<http://www.w3.org/2001/XMLSchema#string>	144	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Monasterio	http://phenomenontology.linkeddata.es/ontology/Monasterio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	159
258	"http://geo.linkeddata.es/def/btn100#CarreteraNacional"^^<http://www.w3.org/2001/XMLSchema#string>	5269	\N	t	\N	http://geo.linkeddata.es/def/btn100#CarreteraNacional	http://geo.linkeddata.es/def/btn100#CarreteraNacional	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
259	"http://geo.linkeddata.es/ontology/Vado"^^<http://www.w3.org/2001/XMLSchema#string>	43	\N	t	\N	http://geo.linkeddata.es/ontology/Vado	http://geo.linkeddata.es/ontology/Vado	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
260	"http://geo.linkeddata.es/def/btn100#CentralNuclear"^^<http://www.w3.org/2001/XMLSchema#string>	7	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralNuclear	http://geo.linkeddata.es/def/btn100#CentralNuclear	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
261	"http://geo.linkeddata.es/def/btn100#Rambla"^^<http://www.w3.org/2001/XMLSchema#string>	1336	\N	t	\N	http://geo.linkeddata.es/def/btn100#Rambla	http://geo.linkeddata.es/def/btn100#Rambla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
262	"http://geo.linkeddata.es/def/btn100#Marisma"^^<http://www.w3.org/2001/XMLSchema#string>	210	\N	t	\N	http://geo.linkeddata.es/def/btn100#Marisma	http://geo.linkeddata.es/def/btn100#Marisma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
263	"http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapFormat"^^<http://www.w3.org/2001/XMLSchema#string>	82	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapFormat	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapFormat	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	82
264	"http://phenomenontology.linkeddata.es/ontology/Parador"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Parador	http://phenomenontology.linkeddata.es/ontology/Parador	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
265	"http://geo.linkeddata.es/ontology/Arroyo"^^<http://www.w3.org/2001/XMLSchema#string>	14490	\N	t	\N	http://geo.linkeddata.es/ontology/Arroyo	http://geo.linkeddata.es/ontology/Arroyo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
266	"http://geo.linkeddata.es/def/btn100#Muralla"^^<http://www.w3.org/2001/XMLSchema#string>	298	\N	t	\N	http://geo.linkeddata.es/def/btn100#Muralla	http://geo.linkeddata.es/def/btn100#Muralla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
267	"http://geo.linkeddata.es/ontology/Ca%C3%B1ada"^^<http://www.w3.org/2001/XMLSchema#string>	568	\N	t	\N	http://geo.linkeddata.es/ontology/Ca%C3%B1ada	http://geo.linkeddata.es/ontology/Ca%C3%B1ada	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
268	"http://geo.linkeddata.es/def/btn100#ItinerarioDeCaminoDeSantiago"^^<http://www.w3.org/2001/XMLSchema#string>	1232	\N	t	\N	http://geo.linkeddata.es/def/btn100#ItinerarioDeCaminoDeSantiago	http://geo.linkeddata.es/def/btn100#ItinerarioDeCaminoDeSantiago	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
269	"http://phenomenontology.linkeddata.es/ontology/Bas%C3%ADlica"^^<http://www.w3.org/2001/XMLSchema#string>	19	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Bas%C3%ADlica	http://phenomenontology.linkeddata.es/ontology/Bas%C3%ADlica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	20
270	"http://geo.linkeddata.es/def/btn100#CanalMenor"^^<http://www.w3.org/2001/XMLSchema#string>	733	\N	t	\N	http://geo.linkeddata.es/def/btn100#CanalMenor	http://geo.linkeddata.es/def/btn100#CanalMenor	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
271	"http://geo.linkeddata.es/def/btn100#DepositoDeAgua"^^<http://www.w3.org/2001/XMLSchema#string>	21935	\N	t	\N	http://geo.linkeddata.es/def/btn100#DepositoDeAgua	http://geo.linkeddata.es/def/btn100#DepositoDeAgua	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
272	"http://geo.linkeddata.es/def/Puente"^^<http://www.w3.org/2001/XMLSchema#string>	17338	\N	t	\N	http://geo.linkeddata.es/def/Puente	http://geo.linkeddata.es/def/Puente	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
273	"http://geo.linkeddata.es/def/btn100#InstalacionFerroviaria"^^<http://www.w3.org/2001/XMLSchema#string>	86	\N	t	\N	http://geo.linkeddata.es/def/btn100#InstalacionFerroviaria	http://geo.linkeddata.es/def/btn100#InstalacionFerroviaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
274	"http://geo.linkeddata.es/ontology/Azarbe"^^<http://www.w3.org/2001/XMLSchema#string>	121	\N	t	\N	http://geo.linkeddata.es/ontology/Azarbe	http://geo.linkeddata.es/ontology/Azarbe	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
275	"http://geo.linkeddata.es/def/btn100#EstacionInvernal"^^<http://www.w3.org/2001/XMLSchema#string>	38	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionInvernal	http://geo.linkeddata.es/def/btn100#EstacionInvernal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
276	"http://geo.linkeddata.es/ontology/Albufera"^^<http://www.w3.org/2001/XMLSchema#string>	12	\N	t	\N	http://geo.linkeddata.es/ontology/Albufera	http://geo.linkeddata.es/ontology/Albufera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
277	"http://geo.linkeddata.es/def/btn100#Helipuerto"^^<http://www.w3.org/2001/XMLSchema#string>	412	\N	t	\N	http://geo.linkeddata.es/def/btn100#Helipuerto	http://geo.linkeddata.es/def/btn100#Helipuerto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
278	"http://geo.linkeddata.es/ontology/Toma"^^<http://www.w3.org/2001/XMLSchema#string>	89	\N	t	\N	http://geo.linkeddata.es/ontology/Toma	http://geo.linkeddata.es/ontology/Toma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
279	"http://phenomenontology.linkeddata.es/ontology/Termas"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Termas	http://phenomenontology.linkeddata.es/ontology/Termas	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	7
280	"http://phenomenontology.linkeddata.es/ontology/Iglesia"^^<http://www.w3.org/2001/XMLSchema#string>	306	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Iglesia	http://phenomenontology.linkeddata.es/ontology/Iglesia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	497
281	"http://geo.linkeddata.es/ontology/Gola"^^<http://www.w3.org/2001/XMLSchema#string>	36	\N	t	\N	http://geo.linkeddata.es/ontology/Gola	http://geo.linkeddata.es/ontology/Gola	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
282	"http://geo.linkeddata.es/def/bnt100#Laguna"^^<http://www.w3.org/2001/XMLSchema#string>	4630	\N	t	\N	http://geo.linkeddata.es/def/bnt100#Laguna	http://geo.linkeddata.es/def/bnt100#Laguna	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
283	"http://phenomenontology.linkeddata.es/ontology/Muralla"^^<http://www.w3.org/2001/XMLSchema#string>	12	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Muralla	http://phenomenontology.linkeddata.es/ontology/Muralla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	18
284	"http://geo.linkeddata.es/def/btn100#Ria"^^<http://www.w3.org/2001/XMLSchema#string>	40	\N	t	\N	http://geo.linkeddata.es/def/btn100#Ria	http://geo.linkeddata.es/def/btn100#Ria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
285	"http://phenomenontology.linkeddata.es/ontology/Hotel"^^<http://www.w3.org/2001/XMLSchema#string>	1	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Hotel	http://phenomenontology.linkeddata.es/ontology/Hotel	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	1
286	"http://geo.linkeddata.es/def/btn100#ZonaPortuaria"^^<http://www.w3.org/2001/XMLSchema#string>	304	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaPortuaria	http://geo.linkeddata.es/def/btn100#ZonaPortuaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
287	"http://geo.linkeddata.es/ontology/Torrente"^^<http://www.w3.org/2001/XMLSchema#string>	1361	\N	t	\N	http://geo.linkeddata.es/ontology/Torrente	http://geo.linkeddata.es/ontology/Torrente	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
288	"http://www.openlinksw.com/schemas/virtrdf#QuadMapFormat"^^<http://www.w3.org/2001/XMLSchema#string>	82	\N	t	\N	http://www.openlinksw.com/schemas/virtrdf#QuadMapFormat	http://www.openlinksw.com/schemas/virtrdf#QuadMapFormat	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	221
289	"http://phenomenontology.linkeddata.es/ontology/Fuerte"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Fuerte	http://phenomenontology.linkeddata.es/ontology/Fuerte	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
290	"http://geo.linkeddata.es/ontology/R%C3%A1pido"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://geo.linkeddata.es/ontology/R%C3%A1pido	http://geo.linkeddata.es/ontology/R%C3%A1pido	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
291	"http://geo.linkeddata.es/def/btn100#Puente"^^<http://www.w3.org/2001/XMLSchema#string>	34675	\N	t	\N	http://geo.linkeddata.es/def/btn100#Puente	http://geo.linkeddata.es/def/btn100#Puente	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
292	"http://geo.linkeddata.es/def/btn100#Cala"^^<http://www.w3.org/2001/XMLSchema#string>	250	\N	t	\N	http://geo.linkeddata.es/def/btn100#Cala	http://geo.linkeddata.es/def/btn100#Cala	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
293	"http://geo.linkeddata.es/def/AguasEstancadas"^^<http://www.w3.org/2001/XMLSchema#string>	4632	\N	t	\N	http://geo.linkeddata.es/def/AguasEstancadas	http://geo.linkeddata.es/def/AguasEstancadas	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
294	"http://geo.linkeddata.es/ontology/ComunidadAut%C3%B3noma"^^<http://www.w3.org/2001/XMLSchema#string>	34	\N	t	\N	http://geo.linkeddata.es/ontology/ComunidadAut%C3%B3noma	http://geo.linkeddata.es/ontology/ComunidadAut%C3%B3noma	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4330
295	"http://geo.linkeddata.es/def/btn100#DepositoDeCombustible"^^<http://www.w3.org/2001/XMLSchema#string>	4526	\N	t	\N	http://geo.linkeddata.es/def/btn100#DepositoDeCombustible	http://geo.linkeddata.es/def/btn100#DepositoDeCombustible	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
296	"http://geo.linkeddata.es/def/btn100#Montana"^^<http://www.w3.org/2001/XMLSchema#string>	287	\N	t	\N	http://geo.linkeddata.es/def/btn100#Montana	http://geo.linkeddata.es/def/btn100#Montana	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
297	"http://geo.linkeddata.es/def/btn100#Puerto"^^<http://www.w3.org/2001/XMLSchema#string>	308	\N	t	\N	http://geo.linkeddata.es/def/btn100#Puerto	http://geo.linkeddata.es/def/btn100#Puerto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
298	"http://geo.linkeddata.es/def/btn100#CotaMunicipal"^^<http://www.w3.org/2001/XMLSchema#string>	7262	\N	t	\N	http://geo.linkeddata.es/def/btn100#CotaMunicipal	http://geo.linkeddata.es/def/btn100#CotaMunicipal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
299	"http://geo.linkeddata.es/def/btn100#Faro"^^<http://www.w3.org/2001/XMLSchema#string>	254	\N	t	\N	http://geo.linkeddata.es/def/btn100#Faro	http://geo.linkeddata.es/def/btn100#Faro	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
300	"http://geo.linkeddata.es/ontology/Colector"^^<http://www.w3.org/2001/XMLSchema#string>	98	\N	t	\N	http://geo.linkeddata.es/ontology/Colector	http://geo.linkeddata.es/ontology/Colector	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
301	"http://geo.linkeddata.es/def/btn100#EstacionDepuradora"^^<http://www.w3.org/2001/XMLSchema#string>	2225	\N	t	\N	http://geo.linkeddata.es/def/btn100#EstacionDepuradora	http://geo.linkeddata.es/def/btn100#EstacionDepuradora	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
302	"http://geo.linkeddata.es/ontology/Sumidero"^^<http://www.w3.org/2001/XMLSchema#string>	10	\N	t	\N	http://geo.linkeddata.es/ontology/Sumidero	http://geo.linkeddata.es/ontology/Sumidero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
303	"http://geo.linkeddata.es/ontology/Galacho"^^<http://www.w3.org/2001/XMLSchema#string>	7	\N	t	\N	http://geo.linkeddata.es/ontology/Galacho	http://geo.linkeddata.es/ontology/Galacho	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
304	"http://geo.linkeddata.es/ontology/Chorrera"^^<http://www.w3.org/2001/XMLSchema#string>	28	\N	t	\N	http://geo.linkeddata.es/ontology/Chorrera	http://geo.linkeddata.es/ontology/Chorrera	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
305	"http://phenomenontology.linkeddata.es/ontology/Mina"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Mina	http://phenomenontology.linkeddata.es/ontology/Mina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
306	"http://geo.linkeddata.es/def/btn100#Presa"^^<http://www.w3.org/2001/XMLSchema#string>	1143	\N	t	\N	http://geo.linkeddata.es/def/btn100#Presa	http://geo.linkeddata.es/def/btn100#Presa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
307	"http://geo.linkeddata.es/ontology/Bod%C3%B3n"^^<http://www.w3.org/2001/XMLSchema#string>	26	\N	t	\N	http://geo.linkeddata.es/ontology/Bod%C3%B3n	http://geo.linkeddata.es/ontology/Bod%C3%B3n	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
308	"http://phenomenontology.linkeddata.es/ontology/Universidad"^^<http://www.w3.org/2001/XMLSchema#string>	6	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Universidad	http://phenomenontology.linkeddata.es/ontology/Universidad	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	8
309	"http://geo.linkeddata.es/ontology/Playa"^^<http://www.w3.org/2001/XMLSchema#string>	2925	\N	t	\N	http://geo.linkeddata.es/ontology/Playa	http://geo.linkeddata.es/ontology/Playa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
310	"http://geo.linkeddata.es/ontology/Acequia"^^<http://www.w3.org/2001/XMLSchema#string>	1145	\N	t	\N	http://geo.linkeddata.es/ontology/Acequia	http://geo.linkeddata.es/ontology/Acequia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
311	"http://geo.linkeddata.es/def/btn100#LineaElectricaDeBajaTension"^^<http://www.w3.org/2001/XMLSchema#string>	1345	\N	t	\N	http://geo.linkeddata.es/def/btn100#LineaElectricaDeBajaTension	http://geo.linkeddata.es/def/btn100#LineaElectricaDeBajaTension	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
312	"http://www.w3.org/ns/prov#Activity"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://www.w3.org/ns/prov#Activity	http://www.w3.org/ns/prov#Activity	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
313	"http://geo.linkeddata.es/def/btn100#Aerodromo"^^<http://www.w3.org/2001/XMLSchema#string>	158	\N	t	\N	http://geo.linkeddata.es/def/btn100#Aerodromo	http://geo.linkeddata.es/def/btn100#Aerodromo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
314	"http://geo.linkeddata.es/def/btn100#ZonaEspecialProteccionAves"^^<http://www.w3.org/2001/XMLSchema#string>	405	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaEspecialProteccionAves	http://geo.linkeddata.es/def/btn100#ZonaEspecialProteccionAves	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
315	"http://geo.linkeddata.es/def/btn100#NucleoPoblacionSuperficial"^^<http://www.w3.org/2001/XMLSchema#string>	26913	\N	t	\N	http://geo.linkeddata.es/def/btn100#NucleoPoblacionSuperficial	http://geo.linkeddata.es/def/btn100#NucleoPoblacionSuperficial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
316	"http://phenomenontology.linkeddata.es/ontology/Colegio"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Colegio	http://phenomenontology.linkeddata.es/ontology/Colegio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
317	"http://geo.linkeddata.es/ontology/Canal"^^<http://www.w3.org/2001/XMLSchema#string>	724	\N	t	\N	http://geo.linkeddata.es/ontology/Canal	http://geo.linkeddata.es/ontology/Canal	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
318	"http://geo.linkeddata.es/def/btn100#VistaPanoramica"^^<http://www.w3.org/2001/XMLSchema#string>	40	\N	t	\N	http://geo.linkeddata.es/def/btn100#VistaPanoramica	http://geo.linkeddata.es/def/btn100#VistaPanoramica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
319	"http://phenomenontology.linkeddata.es/ontology/Alc%C3%A1zar"^^<http://www.w3.org/2001/XMLSchema#string>	6	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Alc%C3%A1zar	http://phenomenontology.linkeddata.es/ontology/Alc%C3%A1zar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	6
320	"http://phenomenontology.linkeddata.es/ontology/Fortaleza"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Fortaleza	http://phenomenontology.linkeddata.es/ontology/Fortaleza	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
321	"http://phenomenontology.linkeddata.es/ontology/Torre"^^<http://www.w3.org/2001/XMLSchema#string>	82	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Torre	http://phenomenontology.linkeddata.es/ontology/Torre	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	90
322	"http://geo.linkeddata.es/def/btn100#Mina"^^<http://www.w3.org/2001/XMLSchema#string>	1326	\N	t	\N	http://geo.linkeddata.es/def/btn100#Mina	http://geo.linkeddata.es/def/btn100#Mina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
323	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadJurisdiccional"^^<http://www.w3.org/2001/XMLSchema#string>	81	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadJurisdiccional	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#ComunidadJurisdiccional	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
324	"http://www.w3.org/ns/prov#Organization"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.w3.org/ns/prov#Organization	http://www.w3.org/ns/prov#Organization	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
325	"http://geo.linkeddata.es/def/btn100#ParqueNacional"^^<http://www.w3.org/2001/XMLSchema#string>	10	\N	t	\N	http://geo.linkeddata.es/def/btn100#ParqueNacional	http://geo.linkeddata.es/def/btn100#ParqueNacional	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
326	"http://geo.linkeddata.es/ontology/Manantial"^^<http://www.w3.org/2001/XMLSchema#string>	570	\N	t	\N	http://geo.linkeddata.es/ontology/Manantial	http://geo.linkeddata.es/ontology/Manantial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
327	"http://geo.linkeddata.es/ontology/Pozo"^^<http://www.w3.org/2001/XMLSchema#string>	468	\N	t	\N	http://geo.linkeddata.es/ontology/Pozo	http://geo.linkeddata.es/ontology/Pozo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
328	"http://geo.linkeddata.es/def/btn100#NucleoPoblacionPuntual"^^<http://www.w3.org/2001/XMLSchema#string>	10131	\N	t	\N	http://geo.linkeddata.es/def/btn100#NucleoPoblacionPuntual	http://geo.linkeddata.es/def/btn100#NucleoPoblacionPuntual	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
329	"http://www.w3.org/2002/07/owl#ObjectProperty"^^<http://www.w3.org/2001/XMLSchema#string>	52	\N	t	\N	http://www.w3.org/2002/07/owl#ObjectProperty	http://www.w3.org/2002/07/owl#ObjectProperty	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	217
330	"http://geo.linkeddata.es/def/btn100#Costa"^^<http://www.w3.org/2001/XMLSchema#string>	3	\N	t	\N	http://geo.linkeddata.es/def/btn100#Costa	http://geo.linkeddata.es/def/btn100#Costa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
331	"http://geo.linkeddata.es/def/btn100#Gaseoducto"^^<http://www.w3.org/2001/XMLSchema#string>	34	\N	t	\N	http://geo.linkeddata.es/def/btn100#Gaseoducto	http://geo.linkeddata.es/def/btn100#Gaseoducto	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
332	"http://geo.linkeddata.es/ontology/Rambla"^^<http://www.w3.org/2001/XMLSchema#string>	1710	\N	t	\N	http://geo.linkeddata.es/ontology/Rambla	http://geo.linkeddata.es/ontology/Rambla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
333	"http://phenomenontology.linkeddata.es/ontology/Capilla"^^<http://www.w3.org/2001/XMLSchema#string>	21	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Capilla	http://phenomenontology.linkeddata.es/ontology/Capilla	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	17
334	"http://geo.linkeddata.es/ontology/Nevero"^^<http://www.w3.org/2001/XMLSchema#string>	4	\N	t	\N	http://geo.linkeddata.es/ontology/Nevero	http://geo.linkeddata.es/ontology/Nevero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
335	"http://geo.linkeddata.es/def/btn100#ZonaIndustrial"^^<http://www.w3.org/2001/XMLSchema#string>	11871	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaIndustrial	http://geo.linkeddata.es/def/btn100#ZonaIndustrial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
336	"http://geo.linkeddata.es/def/btn100#Playa"^^<http://www.w3.org/2001/XMLSchema#string>	598	\N	t	\N	http://geo.linkeddata.es/def/btn100#Playa	http://geo.linkeddata.es/def/btn100#Playa	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
337	"http://phenomenontology.linkeddata.es/ontology/Museo"^^<http://www.w3.org/2001/XMLSchema#string>	61	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Museo	http://phenomenontology.linkeddata.es/ontology/Museo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	59
338	"http://geo.linkeddata.es/def/Salina"^^<http://www.w3.org/2001/XMLSchema#string>	86	\N	t	\N	http://geo.linkeddata.es/def/Salina	http://geo.linkeddata.es/def/Salina	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
339	"http://geo.linkeddata.es/ontology/Sendero"^^<http://www.w3.org/2001/XMLSchema#string>	3684	\N	t	\N	http://geo.linkeddata.es/ontology/Sendero	http://geo.linkeddata.es/ontology/Sendero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
340	"http://www.w3.org/ns/prov#Agent"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://www.w3.org/ns/prov#Agent	http://www.w3.org/ns/prov#Agent	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4
341	"http://phenomenontology.linkeddata.es/ontology/Santuario"^^<http://www.w3.org/2001/XMLSchema#string>	103	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Santuario	http://phenomenontology.linkeddata.es/ontology/Santuario	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	69
342	"http://phenomenontology.linkeddata.es/ontology/Conjunto_hist%C3%B3rico"^^<http://www.w3.org/2001/XMLSchema#string>	2	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Conjunto_hist%C3%B3rico	http://phenomenontology.linkeddata.es/ontology/Conjunto_hist%C3%B3rico	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	2
343	"http://phenomenontology.linkeddata.es/ontology/Dolmen"^^<http://www.w3.org/2001/XMLSchema#string>	16	\N	t	\N	http://phenomenontology.linkeddata.es/ontology/Dolmen	http://phenomenontology.linkeddata.es/ontology/Dolmen	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	22
344	"http://geo.linkeddata.es/def/btn100#ZonaUniversitaria"^^<http://www.w3.org/2001/XMLSchema#string>	91	\N	t	\N	http://geo.linkeddata.es/def/btn100#ZonaUniversitaria	http://geo.linkeddata.es/def/btn100#ZonaUniversitaria	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
345	"http://geo.linkeddata.es/def/Rio"^^<http://www.w3.org/2001/XMLSchema#string>	38	\N	t	\N	http://geo.linkeddata.es/def/Rio	http://geo.linkeddata.es/def/Rio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
346	"http://geo.linkeddata.es/def/btn100#Enlace"^^<http://www.w3.org/2001/XMLSchema#string>	13216	\N	t	\N	http://geo.linkeddata.es/def/btn100#Enlace	http://geo.linkeddata.es/def/btn100#Enlace	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
347	"http://geo.linkeddata.es/def/btn100#IslaFluvial"^^<http://www.w3.org/2001/XMLSchema#string>	795	\N	t	\N	http://geo.linkeddata.es/def/btn100#IslaFluvial	http://geo.linkeddata.es/def/btn100#IslaFluvial	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
348	"http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Municipio"^^<http://www.w3.org/2001/XMLSchema#string>	7912	\N	t	\N	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Municipio	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#Municipio	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
349	"http://www.w3.org/2002/07/owl#AnnotationProperty"^^<http://www.w3.org/2001/XMLSchema#string>	5	\N	t	\N	http://www.w3.org/2002/07/owl#AnnotationProperty	http://www.w3.org/2002/07/owl#AnnotationProperty	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
350	"http://geo.linkeddata.es/def/btn100#Autovia"^^<http://www.w3.org/2001/XMLSchema#string>	7411	\N	t	\N	http://geo.linkeddata.es/def/btn100#Autovia	http://geo.linkeddata.es/def/btn100#Autovia	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
351	"http://geo.linkeddata.es/def/btn100#LugarDeInteres"^^<http://www.w3.org/2001/XMLSchema#string>	931	\N	t	\N	http://geo.linkeddata.es/def/btn100#LugarDeInteres	http://geo.linkeddata.es/def/btn100#LugarDeInteres	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
352	"http://geo.linkeddata.es/def/btn100#CentralSolar"^^<http://www.w3.org/2001/XMLSchema#string>	807	\N	t	\N	http://geo.linkeddata.es/def/btn100#CentralSolar	http://geo.linkeddata.es/def/btn100#CentralSolar	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
353	"http://geo.linkeddata.es/def/btn100#Embalse"^^<http://www.w3.org/2001/XMLSchema#string>	1092	\N	t	\N	http://geo.linkeddata.es/def/btn100#Embalse	http://geo.linkeddata.es/def/btn100#Embalse	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
354	"http://www.w3.org/2002/07/owl#Class"^^<http://www.w3.org/2001/XMLSchema#string>	367	\N	t	\N	http://www.w3.org/2002/07/owl#Class	http://www.w3.org/2002/07/owl#Class	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	4381047
355	"http://geo.linkeddata.es/ontology/Aer%C3%B3dromo"^^<http://www.w3.org/2001/XMLSchema#string>	64	\N	t	\N	http://geo.linkeddata.es/ontology/Aer%C3%B3dromo	http://geo.linkeddata.es/ontology/Aer%C3%B3dromo	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
356	"http://geo.linkeddata.es/def/btn100#Apartadero"^^<http://www.w3.org/2001/XMLSchema#string>	489	\N	t	\N	http://geo.linkeddata.es/def/btn100#Apartadero	http://geo.linkeddata.es/def/btn100#Apartadero	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
357	"http://geo.linkeddata.es/ontology/A%C3%B1o"^^<http://www.w3.org/2001/XMLSchema#string>	13	\N	t	\N	http://geo.linkeddata.es/ontology/A%C3%B1o	http://geo.linkeddata.es/ontology/A%C3%B1o	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	575
358	"http://geo.linkeddata.es/def/btn100#Autopista"^^<http://www.w3.org/2001/XMLSchema#string>	2012	\N	t	\N	http://geo.linkeddata.es/def/btn100#Autopista	http://geo.linkeddata.es/def/btn100#Autopista	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
359	"http://geo.linkeddata.es/def/btn100#CurvaNivelAltimetrica"^^<http://www.w3.org/2001/XMLSchema#string>	165851	\N	t	\N	http://geo.linkeddata.es/def/btn100#CurvaNivelAltimetrica	http://geo.linkeddata.es/def/btn100#CurvaNivelAltimetrica	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
360	"http://geo.linkeddata.es/ontology/Ib%C3%B3n"^^<http://www.w3.org/2001/XMLSchema#string>	100	\N	t	\N	http://geo.linkeddata.es/ontology/Ib%C3%B3n	http://geo.linkeddata.es/ontology/Ib%C3%B3n	181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	t	1	\N	f	f	\N	f	\N	t	f	\N
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	179	1	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2	167	2	2	4432	\N	4432	\N	\N	1	1	2	f	0	\N	\N
3	179	3	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
4	119	4	2	17718	\N	16980	\N	\N	1	1	2	f	738	\N	\N
5	236	5	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
6	171	6	2	149	\N	149	\N	\N	1	1	2	f	0	\N	\N
7	288	7	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
8	192	8	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
9	198	8	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
10	138	8	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
11	354	9	2	64	\N	0	\N	\N	1	1	2	f	64	\N	\N
12	295	10	2	4526	\N	0	\N	\N	1	1	2	f	4526	\N	\N
13	301	10	2	2225	\N	0	\N	\N	0	1	2	f	2225	\N	\N
14	172	11	2	3197	\N	0	\N	\N	1	1	2	f	3197	\N	\N
15	354	12	2	38	\N	38	\N	\N	1	1	2	f	0	354	\N
16	354	12	1	34	\N	34	\N	\N	1	1	2	f	\N	354	\N
17	14	12	1	4	\N	4	\N	\N	0	1	2	f	\N	354	\N
18	288	13	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
19	288	14	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
20	14	15	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
21	167	16	2	4391	\N	4391	\N	\N	1	1	2	f	\N	\N	\N
22	28	16	2	1107	\N	336	\N	\N	0	1	2	f	771	\N	\N
23	176	16	2	543	\N	469	\N	\N	0	1	2	f	74	\N	\N
24	356	16	2	489	\N	482	\N	\N	0	1	2	f	7	\N	\N
25	273	16	2	86	\N	86	\N	\N	0	1	2	f	\N	\N	\N
26	57	16	2	74	\N	73	\N	\N	0	1	2	f	1	\N	\N
27	204	16	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
28	288	17	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
29	210	18	2	1418	\N	1418	\N	\N	1	1	2	f	0	\N	\N
30	66	18	2	736	\N	736	\N	\N	0	1	2	f	0	\N	\N
31	92	18	2	643	\N	643	\N	\N	0	1	2	f	0	\N	\N
32	139	18	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
33	288	19	2	150	\N	150	\N	\N	1	1	2	f	0	\N	\N
34	251	20	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
35	214	21	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
36	16	21	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
37	324	22	2	2	\N	\N	\N	\N	1	1	2	f	2	\N	\N
38	25	22	2	2	\N	\N	\N	\N	0	1	2	f	2	\N	\N
39	340	22	2	2	\N	\N	\N	\N	0	1	2	f	2	\N	\N
40	178	22	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
41	192	23	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
42	198	23	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
43	138	23	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
44	214	24	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
45	16	24	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
46	297	25	2	308	\N	42	\N	\N	1	1	2	f	266	\N	\N
47	301	26	2	2225	\N	0	\N	\N	1	1	2	f	2225	\N	\N
48	288	27	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
49	245	28	2	3546	\N	0	\N	\N	1	1	2	f	3546	\N	\N
50	237	29	2	2	\N	2	\N	\N	1	1	2	f	0	236	\N
51	236	29	1	2	\N	2	\N	\N	1	1	2	f	\N	237	\N
52	141	30	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
53	329	31	2	14	\N	14	\N	\N	1	1	2	f	0	329	\N
54	231	31	2	4	\N	4	\N	\N	0	1	2	f	0	231	\N
55	329	31	1	14	\N	14	\N	\N	1	1	2	f	\N	329	\N
56	231	31	1	4	\N	4	\N	\N	0	1	2	f	\N	231	\N
57	245	32	2	3546	\N	0	\N	\N	1	1	2	f	3546	\N	\N
58	164	33	2	8831	\N	8831	\N	\N	1	1	2	f	0	\N	\N
59	219	33	2	864	\N	864	\N	\N	0	1	2	f	0	\N	\N
60	127	33	2	265	\N	265	\N	\N	0	1	2	f	0	\N	\N
61	191	33	2	100	\N	100	\N	\N	0	1	2	f	0	\N	\N
62	257	33	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
63	280	33	2	86	\N	86	\N	\N	0	1	2	f	0	\N	\N
64	294	33	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
65	54	33	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
66	232	33	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
67	337	33	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
68	155	33	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
69	46	33	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
70	341	33	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
71	135	33	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
72	321	33	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
73	30	33	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
74	101	33	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
75	125	33	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
76	269	33	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
77	29	33	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
78	117	33	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
79	319	33	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
80	31	33	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
81	283	33	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
82	6	33	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
83	308	33	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
84	15	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
85	20	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
86	180	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
87	185	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
88	249	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
89	253	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
90	343	33	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
91	8	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
92	122	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
93	133	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
94	177	33	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
95	17	33	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
96	23	33	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
97	152	33	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
98	234	33	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
99	333	33	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
100	4	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
101	13	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
102	58	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
103	87	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
104	102	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
105	142	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
106	156	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
107	160	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
108	250	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
109	279	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
110	316	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
111	320	33	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
112	219	33	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
113	288	34	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
114	288	35	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
115	24	36	2	53	\N	0	\N	\N	1	1	2	f	53	\N	\N
116	313	36	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
117	179	37	2	1	\N	1	\N	\N	1	1	2	f	0	36	\N
118	36	37	1	1	\N	1	\N	\N	1	1	2	f	\N	179	\N
119	153	38	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
120	354	38	1	396	\N	396	\N	\N	1	1	2	f	\N	\N	\N
121	14	38	1	85	\N	85	\N	\N	0	1	2	f	\N	\N	\N
122	192	39	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
123	198	39	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
124	28	40	2	561	\N	0	\N	\N	1	1	2	f	561	\N	\N
125	356	40	2	483	\N	0	\N	\N	0	1	2	f	483	\N	\N
126	176	40	2	458	\N	0	\N	\N	0	1	2	f	458	\N	\N
127	273	40	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
128	57	40	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
129	204	40	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
130	312	41	2	2	\N	1	\N	\N	1	1	2	f	1	25	\N
131	25	41	1	1	\N	1	\N	\N	1	1	2	f	\N	312	\N
132	14	42	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
133	288	43	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
134	359	44	2	165851	\N	0	\N	\N	1	1	2	f	165851	\N	\N
135	144	44	2	93646	\N	0	\N	\N	0	1	2	f	93646	\N	\N
136	161	44	2	80673	\N	0	\N	\N	0	1	2	f	80673	\N	\N
137	216	44	2	73801	\N	0	\N	\N	0	1	2	f	73801	\N	\N
138	145	44	2	44485	\N	0	\N	\N	0	1	2	f	44485	\N	\N
139	166	44	2	41983	\N	0	\N	\N	0	1	2	f	41983	\N	\N
140	291	44	2	34675	\N	0	\N	\N	0	1	2	f	34675	\N	\N
141	119	44	2	33735	\N	0	\N	\N	0	1	2	f	33735	\N	\N
142	315	44	2	26913	\N	0	\N	\N	0	1	2	f	26913	\N	\N
143	271	44	2	21935	\N	0	\N	\N	0	1	2	f	21935	\N	\N
144	72	44	2	16761	\N	0	\N	\N	0	1	2	f	16761	\N	\N
145	265	44	2	16269	\N	0	\N	\N	0	1	2	f	16269	\N	\N
146	164	44	2	13368	\N	0	\N	\N	0	1	2	f	13368	\N	\N
147	346	44	2	13216	\N	0	\N	\N	0	1	2	f	13216	\N	\N
148	123	44	2	13009	\N	0	\N	\N	0	1	2	f	13009	\N	\N
149	90	44	2	12222	\N	0	\N	\N	0	1	2	f	12222	\N	\N
150	335	44	2	11871	\N	0	\N	\N	0	1	2	f	11871	\N	\N
151	328	44	2	10131	\N	0	\N	\N	0	1	2	f	10131	\N	\N
152	192	44	2	10030	\N	0	\N	\N	0	1	2	f	10030	\N	\N
153	16	44	2	9675	\N	0	\N	\N	0	1	2	f	9675	\N	\N
154	214	44	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
155	186	44	2	8442	\N	0	\N	\N	0	1	2	f	8442	\N	\N
156	77	44	2	8359	\N	0	\N	\N	0	1	2	f	8359	\N	\N
157	348	44	2	7604	\N	0	\N	\N	0	1	2	f	7604	\N	\N
158	350	44	2	7411	\N	0	\N	\N	0	1	2	f	7411	\N	\N
159	298	44	2	7262	\N	0	\N	\N	0	1	2	f	7262	\N	\N
160	222	44	2	7222	\N	0	\N	\N	0	1	2	f	7222	\N	\N
161	205	44	2	7146	\N	0	\N	\N	0	1	2	f	7146	\N	\N
162	258	44	2	5269	\N	0	\N	\N	0	1	2	f	5269	\N	\N
163	93	44	2	4768	\N	0	\N	\N	0	1	2	f	4768	\N	\N
164	282	44	2	4630	\N	0	\N	\N	0	1	2	f	4630	\N	\N
165	62	44	2	4603	\N	0	\N	\N	0	1	2	f	4603	\N	\N
166	295	44	2	4526	\N	0	\N	\N	0	1	2	f	4526	\N	\N
167	167	44	2	4512	\N	0	\N	\N	0	1	2	f	4512	\N	\N
168	184	44	2	4097	\N	0	\N	\N	0	1	2	f	4097	\N	\N
169	339	44	2	4097	\N	0	\N	\N	0	1	2	f	4097	\N	\N
170	245	44	2	3546	\N	0	\N	\N	0	1	2	f	3546	\N	\N
171	154	44	2	3499	\N	0	\N	\N	0	1	2	f	3499	\N	\N
172	309	44	2	3274	\N	0	\N	\N	0	1	2	f	3274	\N	\N
173	213	44	2	2734	\N	0	\N	\N	0	1	2	f	2734	\N	\N
174	170	44	2	2616	\N	0	\N	\N	0	1	2	f	2616	\N	\N
175	35	44	2	2578	\N	0	\N	\N	0	1	2	f	2578	\N	\N
176	105	44	2	2467	\N	0	\N	\N	0	1	2	f	2467	\N	\N
177	9	44	2	2373	\N	0	\N	\N	0	1	2	f	2373	\N	\N
178	301	44	2	2225	\N	0	\N	\N	0	1	2	f	2225	\N	\N
179	143	44	2	2046	\N	0	\N	\N	0	1	2	f	2046	\N	\N
180	358	44	2	2012	\N	0	\N	\N	0	1	2	f	2012	\N	\N
181	149	44	2	1992	\N	0	\N	\N	0	1	2	f	1992	\N	\N
182	332	44	2	1811	\N	0	\N	\N	0	1	2	f	1811	\N	\N
183	85	44	2	1751	\N	0	\N	\N	0	1	2	f	1751	\N	\N
184	215	44	2	1613	\N	0	\N	\N	0	1	2	f	1613	\N	\N
185	147	44	2	1521	\N	0	\N	\N	0	1	2	f	1521	\N	\N
186	210	44	2	1418	\N	0	\N	\N	0	1	2	f	1418	\N	\N
187	287	44	2	1380	\N	0	\N	\N	0	1	2	f	1380	\N	\N
188	118	44	2	1368	\N	0	\N	\N	0	1	2	f	1368	\N	\N
189	311	44	2	1345	\N	0	\N	\N	0	1	2	f	1345	\N	\N
190	261	44	2	1336	\N	0	\N	\N	0	1	2	f	1336	\N	\N
191	322	44	2	1326	\N	0	\N	\N	0	1	2	f	1326	\N	\N
192	116	44	2	1294	\N	0	\N	\N	0	1	2	f	1294	\N	\N
193	268	44	2	1232	\N	0	\N	\N	0	1	2	f	1232	\N	\N
194	310	44	2	1153	\N	0	\N	\N	0	1	2	f	1153	\N	\N
195	217	44	2	1146	\N	0	\N	\N	0	1	2	f	1146	\N	\N
196	306	44	2	1143	\N	0	\N	\N	0	1	2	f	1143	\N	\N
197	193	44	2	1115	\N	0	\N	\N	0	1	2	f	1115	\N	\N
198	198	44	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
199	28	44	2	1107	\N	0	\N	\N	0	1	2	f	1107	\N	\N
200	45	44	2	1099	\N	0	\N	\N	0	1	2	f	1099	\N	\N
201	353	44	2	1092	\N	0	\N	\N	0	1	2	f	1092	\N	\N
202	51	44	2	1091	\N	0	\N	\N	0	1	2	f	1091	\N	\N
203	71	44	2	1086	\N	0	\N	\N	0	1	2	f	1086	\N	\N
204	148	44	2	1058	\N	0	\N	\N	0	1	2	f	1058	\N	\N
205	131	44	2	985	\N	0	\N	\N	0	1	2	f	985	\N	\N
206	1	44	2	958	\N	0	\N	\N	0	1	2	f	958	\N	\N
207	248	44	2	957	\N	0	\N	\N	0	1	2	f	957	\N	\N
208	351	44	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
209	241	44	2	911	\N	0	\N	\N	0	1	2	f	911	\N	\N
210	115	44	2	896	\N	0	\N	\N	0	1	2	f	896	\N	\N
211	48	44	2	877	\N	0	\N	\N	0	1	2	f	877	\N	\N
212	126	44	2	818	\N	0	\N	\N	0	1	2	f	818	\N	\N
213	352	44	2	807	\N	0	\N	\N	0	1	2	f	807	\N	\N
214	347	44	2	795	\N	0	\N	\N	0	1	2	f	795	\N	\N
215	317	44	2	785	\N	0	\N	\N	0	1	2	f	785	\N	\N
216	195	44	2	743	\N	0	\N	\N	0	1	2	f	743	\N	\N
217	66	44	2	736	\N	0	\N	\N	0	1	2	f	736	\N	\N
218	270	44	2	733	\N	0	\N	\N	0	1	2	f	733	\N	\N
219	201	44	2	694	\N	0	\N	\N	0	1	2	f	694	\N	\N
220	326	44	2	693	\N	0	\N	\N	0	1	2	f	693	\N	\N
221	242	44	2	685	\N	0	\N	\N	0	1	2	f	685	\N	\N
222	218	44	2	681	\N	0	\N	\N	0	1	2	f	681	\N	\N
223	38	44	2	645	\N	0	\N	\N	0	1	2	f	645	\N	\N
224	92	44	2	643	\N	0	\N	\N	0	1	2	f	643	\N	\N
225	127	44	2	641	\N	0	\N	\N	0	1	2	f	641	\N	\N
226	103	44	2	619	\N	0	\N	\N	0	1	2	f	619	\N	\N
227	336	44	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
228	94	44	2	575	\N	0	\N	\N	0	1	2	f	575	\N	\N
229	267	44	2	570	\N	0	\N	\N	0	1	2	f	570	\N	\N
230	19	44	2	549	\N	0	\N	\N	0	1	2	f	549	\N	\N
231	176	44	2	543	\N	0	\N	\N	0	1	2	f	543	\N	\N
232	140	44	2	502	\N	0	\N	\N	0	1	2	f	502	\N	\N
233	327	44	2	493	\N	0	\N	\N	0	1	2	f	493	\N	\N
234	356	44	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
235	81	44	2	474	\N	0	\N	\N	0	1	2	f	474	\N	\N
236	219	44	2	473	\N	0	\N	\N	0	1	2	f	473	\N	\N
237	228	44	2	463	\N	0	\N	\N	0	1	2	f	463	\N	\N
238	10	44	2	453	\N	0	\N	\N	0	1	2	f	453	\N	\N
239	174	44	2	437	\N	0	\N	\N	0	1	2	f	437	\N	\N
240	113	44	2	413	\N	0	\N	\N	0	1	2	f	413	\N	\N
241	277	44	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
242	314	44	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
243	64	44	2	372	\N	0	\N	\N	0	1	2	f	372	\N	\N
244	189	44	2	361	\N	0	\N	\N	0	1	2	f	361	\N	\N
245	52	44	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
246	354	44	2	350	\N	0	\N	\N	0	1	2	f	350	\N	\N
247	297	44	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
248	280	44	2	306	\N	0	\N	\N	0	1	2	f	306	\N	\N
249	227	44	2	305	\N	0	\N	\N	0	1	2	f	305	\N	\N
250	286	44	2	304	\N	0	\N	\N	0	1	2	f	304	\N	\N
251	221	44	2	300	\N	0	\N	\N	0	1	2	f	300	\N	\N
252	266	44	2	298	\N	0	\N	\N	0	1	2	f	298	\N	\N
253	202	44	2	292	\N	0	\N	\N	0	1	2	f	292	\N	\N
254	296	44	2	287	\N	0	\N	\N	0	1	2	f	287	\N	\N
255	46	44	2	262	\N	0	\N	\N	0	1	2	f	262	\N	\N
256	299	44	2	254	\N	0	\N	\N	0	1	2	f	254	\N	\N
257	112	44	2	253	\N	0	\N	\N	0	1	2	f	253	\N	\N
258	292	44	2	250	\N	0	\N	\N	0	1	2	f	250	\N	\N
259	188	44	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
260	240	44	2	214	\N	0	\N	\N	0	1	2	f	214	\N	\N
261	262	44	2	210	\N	0	\N	\N	0	1	2	f	210	\N	\N
262	89	44	2	204	\N	0	\N	\N	0	1	2	f	204	\N	\N
263	109	44	2	190	\N	0	\N	\N	0	1	2	f	190	\N	\N
264	250	44	2	187	\N	0	\N	\N	0	1	2	f	187	\N	\N
265	55	44	2	185	\N	0	\N	\N	0	1	2	f	185	\N	\N
266	44	44	2	180	\N	0	\N	\N	0	1	2	f	180	\N	\N
267	209	44	2	169	\N	0	\N	\N	0	1	2	f	169	\N	\N
268	49	44	2	165	\N	0	\N	\N	0	1	2	f	165	\N	\N
269	255	44	2	163	\N	0	\N	\N	0	1	2	f	163	\N	\N
270	313	44	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
271	65	44	2	154	\N	0	\N	\N	0	1	2	f	154	\N	\N
272	225	44	2	153	\N	0	\N	\N	0	1	2	f	153	\N	\N
273	200	44	2	150	\N	0	\N	\N	0	1	2	f	150	\N	\N
274	223	44	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
275	257	44	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
276	95	44	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
277	163	44	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
278	274	44	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
279	37	44	2	136	\N	0	\N	\N	0	1	2	f	136	\N	\N
280	27	44	2	135	\N	0	\N	\N	0	1	2	f	135	\N	\N
281	136	44	2	132	\N	0	\N	\N	0	1	2	f	132	\N	\N
282	82	44	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
283	226	44	2	125	\N	0	\N	\N	0	1	2	f	125	\N	\N
284	53	44	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
285	86	44	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
286	26	44	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
287	159	44	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
288	220	44	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
289	247	44	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
290	196	44	2	108	\N	0	\N	\N	0	1	2	f	108	\N	\N
291	203	44	2	107	\N	0	\N	\N	0	1	2	f	107	\N	\N
292	76	44	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
293	169	44	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
294	341	44	2	103	\N	0	\N	\N	0	1	2	f	103	\N	\N
295	360	44	2	103	\N	0	\N	\N	0	1	2	f	103	\N	\N
296	78	44	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
297	104	44	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
298	300	44	2	100	\N	0	\N	\N	0	1	2	f	100	\N	\N
299	135	44	2	98	\N	0	\N	\N	0	1	2	f	98	\N	\N
300	212	44	2	97	\N	0	\N	\N	0	1	2	f	97	\N	\N
301	151	44	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
302	232	44	2	92	\N	0	\N	\N	0	1	2	f	92	\N	\N
303	278	44	2	92	\N	0	\N	\N	0	1	2	f	92	\N	\N
304	139	44	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
305	244	44	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
306	344	44	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
307	74	44	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
308	273	44	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
309	294	44	2	84	\N	0	\N	\N	0	1	2	f	84	\N	\N
310	321	44	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
311	125	44	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
312	323	44	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
313	57	44	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
314	13	44	2	72	\N	0	\N	\N	0	1	2	f	72	\N	\N
315	246	44	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
316	243	44	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
317	100	44	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
318	355	44	2	67	\N	0	\N	\N	0	1	2	f	67	\N	\N
319	61	44	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
320	2	44	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
321	24	44	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
322	337	44	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
323	181	44	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
324	7	44	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
325	30	44	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
326	121	44	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
327	224	44	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
328	281	44	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
329	54	44	2	55	\N	0	\N	\N	0	1	2	f	55	\N	\N
330	124	44	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
331	191	44	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
332	234	44	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
333	40	44	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
334	207	44	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
335	138	44	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
336	197	44	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
337	29	44	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
338	69	44	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
339	259	44	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
340	18	44	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
341	128	44	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
342	168	44	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
343	284	44	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
344	318	44	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
345	275	44	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
346	5	44	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
347	106	44	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
348	331	44	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
349	120	44	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
350	304	44	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
351	21	44	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
352	60	44	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
353	98	44	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
354	235	44	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
355	165	44	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
356	307	44	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
357	357	44	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
358	50	44	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
359	199	44	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
360	253	44	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
361	39	44	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
362	276	44	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
363	32	44	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
364	230	44	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
365	333	44	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
366	101	44	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
367	152	44	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
368	158	44	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
369	269	44	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
370	4	44	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
371	155	44	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
372	343	44	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
373	129	44	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
374	33	44	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
375	96	44	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
376	171	44	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
377	177	44	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
378	91	44	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
379	254	44	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
380	11	44	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
381	283	44	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
382	117	44	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
383	190	44	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
384	114	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
385	239	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
386	302	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
387	325	44	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
388	133	44	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
389	185	44	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
390	63	44	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
391	68	44	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
392	108	44	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
393	162	44	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
394	6	44	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
395	260	44	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
396	303	44	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
397	20	44	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
398	75	44	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
399	308	44	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
400	319	44	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
401	23	44	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
402	73	44	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
403	194	44	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
404	249	44	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
405	3	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
406	15	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
407	31	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
408	122	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
409	137	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
410	180	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
411	305	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
412	320	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
413	334	44	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
414	43	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
415	70	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
416	132	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
417	279	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
418	290	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
419	316	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
420	330	44	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
421	8	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
422	17	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
423	59	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
424	87	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
425	102	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
426	111	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
427	142	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
428	146	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
429	160	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
430	178	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
431	183	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
432	204	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
433	289	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
434	329	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
435	342	44	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
436	34	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
437	58	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
438	67	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
439	83	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
440	88	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
441	156	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
442	157	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
443	182	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
444	206	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
445	208	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
446	231	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
447	252	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
448	264	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
449	285	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
450	216	45	2	53673	\N	0	\N	\N	1	1	2	f	53673	\N	\N
451	119	45	2	32270	\N	0	\N	\N	0	1	2	f	32270	\N	\N
452	315	45	2	26913	\N	0	\N	\N	0	1	2	f	26913	\N	\N
453	166	45	2	24621	\N	0	\N	\N	0	1	2	f	24621	\N	\N
454	72	45	2	16877	\N	0	\N	\N	0	1	2	f	16877	\N	\N
455	123	45	2	13009	\N	0	\N	\N	0	1	2	f	13009	\N	\N
456	335	45	2	11871	\N	0	\N	\N	0	1	2	f	11871	\N	\N
457	328	45	2	10131	\N	0	\N	\N	0	1	2	f	10131	\N	\N
458	192	45	2	10030	\N	0	\N	\N	0	1	2	f	10030	\N	\N
459	186	45	2	8442	\N	0	\N	\N	0	1	2	f	8442	\N	\N
460	16	45	2	8116	\N	0	\N	\N	0	1	2	f	8116	\N	\N
461	214	45	2	8116	\N	0	\N	\N	0	1	2	f	8116	\N	\N
462	348	45	2	7920	\N	0	\N	\N	0	1	2	f	7920	\N	\N
463	350	45	2	7398	\N	0	\N	\N	0	1	2	f	7398	\N	\N
464	298	45	2	7262	\N	0	\N	\N	0	1	2	f	7262	\N	\N
465	222	45	2	7222	\N	0	\N	\N	0	1	2	f	7222	\N	\N
466	258	45	2	5269	\N	0	\N	\N	0	1	2	f	5269	\N	\N
467	167	45	2	4504	\N	0	\N	\N	0	1	2	f	4504	\N	\N
468	154	45	2	3499	\N	0	\N	\N	0	1	2	f	3499	\N	\N
469	205	45	2	3446	\N	0	\N	\N	0	1	2	f	3446	\N	\N
470	293	45	2	2800	\N	0	\N	\N	0	1	2	f	2800	\N	\N
471	213	45	2	2734	\N	0	\N	\N	0	1	2	f	2734	\N	\N
472	105	45	2	2467	\N	0	\N	\N	0	1	2	f	2467	\N	\N
473	9	45	2	2373	\N	0	\N	\N	0	1	2	f	2373	\N	\N
474	358	45	2	2012	\N	0	\N	\N	0	1	2	f	2012	\N	\N
475	149	45	2	1992	\N	0	\N	\N	0	1	2	f	1992	\N	\N
476	282	45	2	1716	\N	0	\N	\N	0	1	2	f	1716	\N	\N
477	118	45	2	1368	\N	0	\N	\N	0	1	2	f	1368	\N	\N
478	268	45	2	1232	\N	0	\N	\N	0	1	2	f	1232	\N	\N
479	42	45	2	1147	\N	0	\N	\N	0	1	2	f	1147	\N	\N
480	217	45	2	1146	\N	0	\N	\N	0	1	2	f	1146	\N	\N
481	198	45	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
482	45	45	2	1099	\N	0	\N	\N	0	1	2	f	1099	\N	\N
483	28	45	2	1098	\N	0	\N	\N	0	1	2	f	1098	\N	\N
484	51	45	2	1091	\N	0	\N	\N	0	1	2	f	1091	\N	\N
485	353	45	2	1090	\N	0	\N	\N	0	1	2	f	1090	\N	\N
486	71	45	2	1079	\N	0	\N	\N	0	1	2	f	1079	\N	\N
487	62	45	2	1047	\N	0	\N	\N	0	1	2	f	1047	\N	\N
488	1	45	2	958	\N	0	\N	\N	0	1	2	f	958	\N	\N
489	248	45	2	957	\N	0	\N	\N	0	1	2	f	957	\N	\N
490	351	45	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
491	241	45	2	911	\N	0	\N	\N	0	1	2	f	911	\N	\N
492	261	45	2	898	\N	0	\N	\N	0	1	2	f	898	\N	\N
493	115	45	2	896	\N	0	\N	\N	0	1	2	f	896	\N	\N
494	131	45	2	876	\N	0	\N	\N	0	1	2	f	876	\N	\N
495	41	45	2	853	\N	0	\N	\N	0	1	2	f	853	\N	\N
496	145	45	2	851	\N	0	\N	\N	0	1	2	f	851	\N	\N
497	126	45	2	818	\N	0	\N	\N	0	1	2	f	818	\N	\N
498	270	45	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
499	201	45	2	694	\N	0	\N	\N	0	1	2	f	694	\N	\N
500	242	45	2	685	\N	0	\N	\N	0	1	2	f	685	\N	\N
501	336	45	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
502	103	45	2	550	\N	0	\N	\N	0	1	2	f	550	\N	\N
503	19	45	2	549	\N	0	\N	\N	0	1	2	f	549	\N	\N
504	176	45	2	542	\N	0	\N	\N	0	1	2	f	542	\N	\N
505	140	45	2	502	\N	0	\N	\N	0	1	2	f	502	\N	\N
506	356	45	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
507	81	45	2	474	\N	0	\N	\N	0	1	2	f	474	\N	\N
508	228	45	2	463	\N	0	\N	\N	0	1	2	f	463	\N	\N
509	277	45	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
510	314	45	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
511	347	45	2	391	\N	0	\N	\N	0	1	2	f	391	\N	\N
512	272	45	2	361	\N	0	\N	\N	0	1	2	f	361	\N	\N
513	52	45	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
514	297	45	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
515	286	45	2	304	\N	0	\N	\N	0	1	2	f	304	\N	\N
516	202	45	2	292	\N	0	\N	\N	0	1	2	f	292	\N	\N
517	296	45	2	287	\N	0	\N	\N	0	1	2	f	287	\N	\N
518	299	45	2	254	\N	0	\N	\N	0	1	2	f	254	\N	\N
519	292	45	2	250	\N	0	\N	\N	0	1	2	f	250	\N	\N
520	188	45	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
521	89	45	2	204	\N	0	\N	\N	0	1	2	f	204	\N	\N
522	109	45	2	190	\N	0	\N	\N	0	1	2	f	190	\N	\N
523	55	45	2	185	\N	0	\N	\N	0	1	2	f	185	\N	\N
524	209	45	2	169	\N	0	\N	\N	0	1	2	f	169	\N	\N
525	255	45	2	163	\N	0	\N	\N	0	1	2	f	163	\N	\N
526	313	45	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
527	65	45	2	154	\N	0	\N	\N	0	1	2	f	154	\N	\N
528	223	45	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
529	95	45	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
530	226	45	2	125	\N	0	\N	\N	0	1	2	f	125	\N	\N
531	86	45	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
532	26	45	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
533	262	45	2	106	\N	0	\N	\N	0	1	2	f	106	\N	\N
534	169	45	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
535	104	45	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
536	130	45	2	98	\N	0	\N	\N	0	1	2	f	98	\N	\N
537	151	45	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
538	344	45	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
539	74	45	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
540	47	45	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
541	163	45	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
542	338	45	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
543	273	45	2	83	\N	0	\N	\N	0	1	2	f	83	\N	\N
544	323	45	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
545	147	45	2	76	\N	0	\N	\N	0	1	2	f	76	\N	\N
546	76	45	2	75	\N	0	\N	\N	0	1	2	f	75	\N	\N
547	57	45	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
548	243	45	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
549	2	45	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
550	24	45	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
551	7	45	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
552	121	45	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
553	224	45	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
554	191	45	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
555	247	45	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
556	138	45	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
557	284	45	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
558	318	45	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
559	275	45	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
560	345	45	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
561	106	45	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
562	235	45	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
563	69	45	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
564	39	45	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
565	155	45	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
566	61	45	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
567	91	45	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
568	11	45	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
569	325	45	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
570	12	45	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
571	352	45	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
572	260	45	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
573	75	45	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
574	162	45	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
575	194	45	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
576	330	45	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
577	99	45	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
578	111	45	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
579	204	45	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
580	84	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
581	110	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
582	150	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
583	233	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
584	239	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
585	288	46	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
586	288	47	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
587	166	48	2	36721	\N	0	\N	\N	1	1	2	f	36721	\N	\N
588	315	48	2	26407	\N	0	\N	\N	0	1	2	f	26407	\N	\N
589	328	48	2	10088	\N	0	\N	\N	0	1	2	f	10088	\N	\N
590	205	48	2	6396	\N	0	\N	\N	0	1	2	f	6396	\N	\N
591	208	49	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
592	312	50	2	1	\N	1	\N	\N	1	1	2	f	0	324	\N
593	324	50	1	1	\N	1	\N	\N	1	1	2	f	\N	312	\N
594	340	50	1	1	\N	1	\N	\N	0	1	2	f	\N	312	\N
595	167	51	2	4512	\N	4512	\N	\N	1	1	2	f	0	\N	\N
596	288	52	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
597	94	53	2	575	\N	0	\N	\N	1	1	2	f	575	\N	\N
598	357	53	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
599	131	54	2	985	\N	985	\N	\N	1	1	2	f	0	\N	\N
600	270	54	2	733	\N	733	\N	\N	0	1	2	f	0	\N	\N
601	188	54	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
602	288	55	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
603	214	56	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
604	16	56	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
605	22	57	2	4277929	\N	0	\N	\N	1	1	2	f	4277929	\N	\N
606	192	57	2	10030	\N	0	\N	\N	0	1	2	f	10030	\N	\N
607	198	57	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
608	138	57	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
609	288	58	2	56	\N	56	\N	\N	1	1	2	f	0	288	\N
610	288	58	1	56	\N	56	\N	\N	1	1	2	f	\N	288	\N
611	288	59	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
612	236	60	2	2	\N	2	\N	\N	1	1	2	f	0	251	\N
613	251	60	1	2	\N	2	\N	\N	1	1	2	f	\N	236	\N
614	359	61	2	165851	\N	165851	\N	\N	1	1	2	f	0	\N	\N
615	85	61	2	1751	\N	1751	\N	\N	0	1	2	f	0	\N	\N
616	179	63	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
617	288	64	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
618	288	65	1	82	\N	82	\N	\N	1	1	2	f	\N	\N	\N
619	229	65	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
620	236	65	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
621	237	65	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
622	141	66	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
623	288	67	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
624	251	68	2	2	\N	2	\N	\N	1	1	2	f	0	179	\N
625	179	68	1	2	\N	2	\N	\N	1	1	2	f	\N	251	\N
626	25	69	2	1	\N	1	\N	\N	1	1	2	f	0	25	\N
627	25	69	1	1	\N	1	\N	\N	1	1	2	f	\N	25	\N
628	127	70	2	1372	\N	1372	\N	\N	1	1	2	f	0	134	\N
629	250	70	2	788	\N	788	\N	\N	0	1	2	f	0	134	\N
630	280	70	2	788	\N	788	\N	\N	0	1	2	f	0	134	\N
631	46	70	2	546	\N	546	\N	\N	0	1	2	f	0	134	\N
632	257	70	2	260	\N	260	\N	\N	0	1	2	f	0	172	\N
633	135	70	2	250	\N	250	\N	\N	0	1	2	f	0	134	\N
634	341	70	2	208	\N	208	\N	\N	0	1	2	f	0	134	\N
635	13	70	2	194	\N	194	\N	\N	0	1	2	f	0	134	\N
636	232	70	2	194	\N	194	\N	\N	0	1	2	f	0	134	\N
637	125	70	2	170	\N	170	\N	\N	0	1	2	f	0	134	\N
638	321	70	2	168	\N	168	\N	\N	0	1	2	f	0	134	\N
639	40	70	2	138	\N	138	\N	\N	0	1	2	f	0	134	\N
640	337	70	2	126	\N	126	\N	\N	0	1	2	f	0	134	\N
641	30	70	2	124	\N	124	\N	\N	0	1	2	f	0	134	\N
642	54	70	2	112	\N	112	\N	\N	0	1	2	f	0	134	\N
643	29	70	2	100	\N	100	\N	\N	0	1	2	f	0	134	\N
644	234	70	2	100	\N	100	\N	\N	0	1	2	f	0	134	\N
645	253	70	2	52	\N	52	\N	\N	0	1	2	f	0	134	\N
646	4	70	2	48	\N	48	\N	\N	0	1	2	f	0	134	\N
647	101	70	2	48	\N	48	\N	\N	0	1	2	f	0	134	\N
648	152	70	2	44	\N	44	\N	\N	0	1	2	f	0	134	\N
649	269	70	2	42	\N	42	\N	\N	0	1	2	f	0	134	\N
650	333	70	2	42	\N	42	\N	\N	0	1	2	f	0	134	\N
651	158	70	2	38	\N	38	\N	\N	0	1	2	f	0	134	\N
652	283	70	2	36	\N	36	\N	\N	0	1	2	f	0	134	\N
653	343	70	2	36	\N	36	\N	\N	0	1	2	f	0	134	\N
654	254	70	2	32	\N	32	\N	\N	0	1	2	f	0	134	\N
655	177	70	2	30	\N	30	\N	\N	0	1	2	f	0	134	\N
656	117	70	2	26	\N	26	\N	\N	0	1	2	f	0	134	\N
657	133	70	2	22	\N	22	\N	\N	0	1	2	f	0	134	\N
658	308	70	2	21	\N	21	\N	\N	0	1	2	f	0	134	\N
659	185	70	2	19	\N	19	\N	\N	0	1	2	f	0	134	\N
660	6	70	2	16	\N	16	\N	\N	0	1	2	f	0	134	\N
661	20	70	2	14	\N	14	\N	\N	0	1	2	f	0	134	\N
662	319	70	2	12	\N	12	\N	\N	0	1	2	f	0	134	\N
663	122	70	2	10	\N	10	\N	\N	0	1	2	f	0	134	\N
664	249	70	2	10	\N	10	\N	\N	0	1	2	f	0	134	\N
665	15	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
666	31	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
667	137	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
668	180	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
669	279	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
670	305	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
671	320	70	2	8	\N	8	\N	\N	0	1	2	f	0	134	\N
672	132	70	2	6	\N	6	\N	\N	0	1	2	f	0	134	\N
673	316	70	2	6	\N	6	\N	\N	0	1	2	f	0	134	\N
674	8	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
675	17	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
676	87	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
677	102	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
678	142	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
679	146	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
680	160	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
681	183	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
682	289	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
683	342	70	2	4	\N	4	\N	\N	0	1	2	f	0	134	\N
684	34	70	2	2	\N	2	\N	\N	0	1	2	f	0	134	\N
685	58	70	2	2	\N	2	\N	\N	0	1	2	f	0	134	\N
686	156	70	2	2	\N	2	\N	\N	0	1	2	f	0	134	\N
687	264	70	2	2	\N	2	\N	\N	0	1	2	f	0	134	\N
688	285	70	2	2	\N	2	\N	\N	0	1	2	f	0	134	\N
689	172	70	1	3197	\N	3197	\N	\N	1	1	2	f	\N	127	\N
690	134	70	1	3157	\N	3157	\N	\N	0	1	2	f	\N	127	\N
691	25	71	2	1	\N	1	\N	\N	1	1	2	f	0	25	\N
692	25	71	1	1	\N	1	\N	\N	1	1	2	f	\N	25	\N
693	288	72	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
694	166	73	2	41983	\N	41983	\N	\N	1	1	2	f	0	\N	\N
695	315	73	2	26913	\N	26913	\N	\N	0	1	2	f	0	\N	\N
696	328	73	2	10131	\N	10131	\N	\N	0	1	2	f	0	\N	\N
697	205	73	2	7146	\N	7146	\N	\N	0	1	2	f	0	\N	\N
698	236	74	2	2	\N	2	\N	\N	1	1	2	f	0	251	\N
699	251	74	1	2	\N	2	\N	\N	1	1	2	f	\N	236	\N
700	25	75	2	2	\N	2	\N	\N	1	1	2	f	0	340	\N
701	324	75	1	2	\N	2	\N	\N	1	1	2	f	\N	25	\N
702	340	75	1	2	\N	2	\N	\N	0	1	2	f	\N	25	\N
703	288	76	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
704	213	77	2	2734	\N	2734	\N	\N	1	1	2	f	0	\N	\N
705	1	77	2	958	\N	958	\N	\N	0	1	2	f	0	\N	\N
706	115	77	2	896	\N	896	\N	\N	0	1	2	f	0	\N	\N
707	336	77	2	598	\N	598	\N	\N	0	1	2	f	0	\N	\N
708	19	77	2	549	\N	549	\N	\N	0	1	2	f	0	\N	\N
709	296	77	2	287	\N	287	\N	\N	0	1	2	f	0	\N	\N
710	292	77	2	250	\N	250	\N	\N	0	1	2	f	0	\N	\N
711	89	77	2	204	\N	204	\N	\N	0	1	2	f	0	\N	\N
712	109	77	2	190	\N	190	\N	\N	0	1	2	f	0	\N	\N
713	55	77	2	185	\N	185	\N	\N	0	1	2	f	0	\N	\N
714	209	77	2	169	\N	169	\N	\N	0	1	2	f	0	\N	\N
715	104	77	2	102	\N	102	\N	\N	0	1	2	f	0	\N	\N
716	7	77	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
717	224	77	2	57	\N	57	\N	\N	0	1	2	f	0	\N	\N
718	235	77	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
719	91	77	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
720	11	77	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
721	194	77	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
722	330	77	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
723	354	78	2	12	\N	12	\N	\N	1	1	2	f	0	354	\N
724	354	78	1	12	\N	12	\N	\N	1	1	2	f	\N	354	\N
725	288	79	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
726	144	80	2	6933	\N	0	\N	\N	1	1	2	f	6933	\N	\N
727	166	80	2	5186	\N	0	\N	\N	0	1	2	f	5186	\N	\N
728	167	80	2	3962	\N	0	\N	\N	0	1	2	f	3962	\N	\N
729	123	80	2	3288	\N	0	\N	\N	0	1	2	f	3288	\N	\N
730	346	80	2	1195	\N	0	\N	\N	0	1	2	f	1195	\N	\N
731	216	80	2	1139	\N	0	\N	\N	0	1	2	f	1139	\N	\N
732	28	80	2	929	\N	0	\N	\N	0	1	2	f	929	\N	\N
733	306	80	2	683	\N	0	\N	\N	0	1	2	f	683	\N	\N
734	322	80	2	643	\N	0	\N	\N	0	1	2	f	643	\N	\N
735	270	80	2	607	\N	0	\N	\N	0	1	2	f	607	\N	\N
736	131	80	2	589	\N	0	\N	\N	0	1	2	f	589	\N	\N
737	161	80	2	519	\N	0	\N	\N	0	1	2	f	519	\N	\N
738	335	80	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
739	176	80	2	482	\N	0	\N	\N	0	1	2	f	482	\N	\N
740	356	80	2	463	\N	0	\N	\N	0	1	2	f	463	\N	\N
741	105	80	2	458	\N	0	\N	\N	0	1	2	f	458	\N	\N
742	118	80	2	424	\N	0	\N	\N	0	1	2	f	424	\N	\N
743	145	80	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
744	277	80	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
745	71	80	2	353	\N	0	\N	\N	0	1	2	f	353	\N	\N
746	45	80	2	328	\N	0	\N	\N	0	1	2	f	328	\N	\N
747	126	80	2	260	\N	0	\N	\N	0	1	2	f	260	\N	\N
748	16	80	2	242	\N	0	\N	\N	0	1	2	f	242	\N	\N
749	214	80	2	242	\N	0	\N	\N	0	1	2	f	242	\N	\N
750	115	80	2	234	\N	0	\N	\N	0	1	2	f	234	\N	\N
751	245	80	2	207	\N	0	\N	\N	0	1	2	f	207	\N	\N
752	313	80	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
753	188	80	2	147	\N	0	\N	\N	0	1	2	f	147	\N	\N
754	149	80	2	137	\N	0	\N	\N	0	1	2	f	137	\N	\N
755	299	80	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
756	9	80	2	95	\N	0	\N	\N	0	1	2	f	95	\N	\N
757	217	80	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
758	226	80	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
759	273	80	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
760	205	80	2	67	\N	0	\N	\N	0	1	2	f	67	\N	\N
761	57	80	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
762	351	80	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
763	24	80	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
764	151	80	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
765	242	80	2	51	\N	0	\N	\N	0	1	2	f	51	\N	\N
766	51	80	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
767	103	80	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
768	213	80	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
769	65	80	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
770	275	80	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
771	202	80	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
772	223	80	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
773	201	80	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
774	350	80	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
775	344	80	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
776	140	80	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
777	258	80	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
778	44	80	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
779	318	80	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
780	2	80	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
781	81	80	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
782	358	80	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
783	19	80	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
784	282	80	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
785	39	80	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
786	55	80	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
787	72	80	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
788	74	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
789	204	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
790	255	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
791	353	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
792	69	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
793	86	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
794	106	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
795	315	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
796	352	80	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
797	138	81	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
798	134	82	2	2653	\N	0	\N	\N	1	1	2	f	2653	\N	\N
799	354	83	2	53	\N	53	\N	\N	1	1	2	f	0	\N	\N
800	22	84	2	4207095	\N	0	\N	\N	1	1	2	f	4207095	\N	\N
801	251	85	2	8	\N	8	\N	\N	1	1	2	f	0	56	\N
802	56	85	1	8	\N	8	\N	\N	1	1	2	f	\N	251	\N
803	192	86	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
804	288	87	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
805	288	88	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
806	288	89	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
807	354	90	2	173	\N	\N	\N	\N	1	1	2	f	173	\N	\N
808	231	90	2	18	\N	\N	\N	\N	0	1	2	f	18	\N	\N
809	329	90	2	8	\N	\N	\N	\N	0	1	2	f	8	\N	\N
810	208	90	2	3	\N	1	\N	\N	0	1	2	f	2	\N	\N
811	312	90	2	3	\N	\N	\N	\N	0	1	2	f	3	\N	\N
812	25	90	2	1	\N	\N	\N	\N	0	1	2	f	1	\N	\N
813	216	91	2	4878	\N	4878	\N	\N	1	1	2	f	0	\N	\N
814	288	92	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
815	167	93	2	4512	\N	4512	\N	\N	1	1	2	f	0	\N	\N
816	315	94	2	26913	\N	0	\N	\N	1	1	2	f	26913	\N	\N
817	166	94	2	16992	\N	0	\N	\N	0	1	2	f	16992	\N	\N
818	328	94	2	10131	\N	0	\N	\N	0	1	2	f	10131	\N	\N
819	348	94	2	7912	\N	0	\N	\N	0	1	2	f	7912	\N	\N
820	205	94	2	7146	\N	0	\N	\N	0	1	2	f	7146	\N	\N
821	323	94	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
822	191	94	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
823	155	94	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
824	111	94	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
825	288	95	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
826	119	96	2	33486	\N	0	\N	\N	1	1	2	f	33486	\N	\N
827	228	96	2	456	\N	0	\N	\N	0	1	2	f	456	\N	\N
828	350	97	2	7411	\N	7411	\N	\N	1	1	2	f	\N	\N	\N
829	358	97	2	2012	\N	2012	\N	\N	0	1	2	f	\N	\N	\N
830	313	97	2	158	\N	158	\N	\N	0	1	2	f	\N	\N	\N
831	24	97	2	61	\N	53	\N	\N	0	1	2	f	8	\N	\N
832	231	98	2	109	\N	109	\N	\N	1	1	2	f	0	354	\N
833	329	98	2	48	\N	48	\N	\N	0	1	2	f	0	354	\N
834	79	98	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
835	354	98	1	157	\N	157	\N	\N	1	1	2	f	\N	231	\N
836	251	99	2	1	\N	1	\N	\N	1	1	2	f	0	179	\N
837	179	99	1	1	\N	1	\N	\N	1	1	2	f	\N	251	\N
838	166	100	2	24991	\N	0	\N	\N	1	1	2	f	24991	\N	\N
839	288	101	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
840	77	102	2	22305	\N	22305	\N	\N	1	1	2	f	0	175	\N
841	265	102	2	22258	\N	22258	\N	\N	0	1	2	f	0	22	\N
842	90	102	2	14944	\N	14944	\N	\N	0	1	2	f	0	22	\N
843	164	102	2	13213	\N	13213	\N	\N	0	1	2	f	0	22	\N
844	184	102	2	4223	\N	4223	\N	\N	0	1	2	f	0	22	\N
845	339	102	2	4223	\N	4223	\N	\N	0	1	2	f	0	22	\N
846	309	102	2	3194	\N	3194	\N	\N	0	1	2	f	0	22	\N
847	170	102	2	2907	\N	2907	\N	\N	0	1	2	f	0	22	\N
848	143	102	2	2049	\N	2049	\N	\N	0	1	2	f	0	22	\N
849	332	102	2	2045	\N	2045	\N	\N	0	1	2	f	0	22	\N
850	215	102	2	1650	\N	1650	\N	\N	0	1	2	f	0	22	\N
851	287	102	2	1565	\N	1565	\N	\N	0	1	2	f	0	22	\N
852	310	102	2	1381	\N	1381	\N	\N	0	1	2	f	0	22	\N
853	116	102	2	1205	\N	1205	\N	\N	0	1	2	f	0	22	\N
854	148	102	2	984	\N	984	\N	\N	0	1	2	f	0	22	\N
855	317	102	2	829	\N	829	\N	\N	0	1	2	f	0	22	\N
856	195	102	2	801	\N	801	\N	\N	0	1	2	f	0	22	\N
857	127	102	2	686	\N	686	\N	\N	0	1	2	f	0	22	\N
858	38	102	2	670	\N	670	\N	\N	0	1	2	f	0	22	\N
859	267	102	2	643	\N	643	\N	\N	0	1	2	f	0	22	\N
860	326	102	2	577	\N	577	\N	\N	0	1	2	f	0	22	\N
861	327	102	2	507	\N	507	\N	\N	0	1	2	f	0	22	\N
862	218	102	2	497	\N	497	\N	\N	0	1	2	f	0	22	\N
863	48	102	2	449	\N	449	\N	\N	0	1	2	f	0	22	\N
864	174	102	2	447	\N	447	\N	\N	0	1	2	f	0	22	\N
865	113	102	2	436	\N	436	\N	\N	0	1	2	f	0	22	\N
866	250	102	2	394	\N	394	\N	\N	0	1	2	f	0	22	\N
867	280	102	2	394	\N	394	\N	\N	0	1	2	f	0	22	\N
868	10	102	2	390	\N	390	\N	\N	0	1	2	f	0	22	\N
869	64	102	2	369	\N	369	\N	\N	0	1	2	f	0	22	\N
870	189	102	2	369	\N	369	\N	\N	0	1	2	f	0	22	\N
871	221	102	2	316	\N	316	\N	\N	0	1	2	f	0	22	\N
872	219	102	2	296	\N	296	\N	\N	0	1	2	f	0	22	\N
873	227	102	2	289	\N	289	\N	\N	0	1	2	f	0	22	\N
874	46	102	2	273	\N	273	\N	\N	0	1	2	f	0	22	\N
875	112	102	2	244	\N	244	\N	\N	0	1	2	f	0	22	\N
876	240	102	2	239	\N	239	\N	\N	0	1	2	f	0	22	\N
877	159	102	2	207	\N	207	\N	\N	0	1	2	f	0	22	\N
878	49	102	2	174	\N	174	\N	\N	0	1	2	f	0	22	\N
879	257	102	2	153	\N	153	\N	\N	0	1	2	f	0	22	\N
880	225	102	2	150	\N	150	\N	\N	0	1	2	f	0	22	\N
881	27	102	2	144	\N	144	\N	\N	0	1	2	f	0	22	\N
882	220	102	2	138	\N	138	\N	\N	0	1	2	f	0	22	\N
883	200	102	2	128	\N	128	\N	\N	0	1	2	f	0	22	\N
884	53	102	2	127	\N	127	\N	\N	0	1	2	f	0	22	\N
885	37	102	2	125	\N	125	\N	\N	0	1	2	f	0	22	\N
886	135	102	2	125	\N	125	\N	\N	0	1	2	f	0	22	\N
887	274	102	2	123	\N	123	\N	\N	0	1	2	f	0	22	\N
888	136	102	2	122	\N	122	\N	\N	0	1	2	f	0	22	\N
889	78	102	2	110	\N	110	\N	\N	0	1	2	f	0	22	\N
890	278	102	2	106	\N	106	\N	\N	0	1	2	f	0	22	\N
891	246	102	2	105	\N	105	\N	\N	0	1	2	f	0	22	\N
892	341	102	2	104	\N	104	\N	\N	0	1	2	f	0	22	\N
893	196	102	2	103	\N	103	\N	\N	0	1	2	f	0	22	\N
894	212	102	2	101	\N	101	\N	\N	0	1	2	f	0	22	\N
895	300	102	2	101	\N	101	\N	\N	0	1	2	f	0	22	\N
896	360	102	2	100	\N	100	\N	\N	0	1	2	f	0	22	\N
897	13	102	2	97	\N	97	\N	\N	0	1	2	f	0	22	\N
898	232	102	2	97	\N	97	\N	\N	0	1	2	f	0	22	\N
899	82	102	2	96	\N	96	\N	\N	0	1	2	f	0	22	\N
900	244	102	2	89	\N	89	\N	\N	0	1	2	f	0	22	\N
901	125	102	2	85	\N	85	\N	\N	0	1	2	f	0	22	\N
902	203	102	2	84	\N	84	\N	\N	0	1	2	f	0	22	\N
903	321	102	2	84	\N	84	\N	\N	0	1	2	f	0	22	\N
904	40	102	2	69	\N	69	\N	\N	0	1	2	f	0	22	\N
905	355	102	2	65	\N	65	\N	\N	0	1	2	f	0	22	\N
906	337	102	2	63	\N	63	\N	\N	0	1	2	f	0	22	\N
907	30	102	2	62	\N	62	\N	\N	0	1	2	f	0	22	\N
908	181	102	2	60	\N	60	\N	\N	0	1	2	f	0	22	\N
909	54	102	2	55	\N	55	\N	\N	0	1	2	f	0	22	\N
910	29	102	2	50	\N	50	\N	\N	0	1	2	f	0	22	\N
911	234	102	2	50	\N	50	\N	\N	0	1	2	f	0	22	\N
912	259	102	2	45	\N	45	\N	\N	0	1	2	f	0	22	\N
913	197	102	2	43	\N	43	\N	\N	0	1	2	f	0	22	\N
914	18	102	2	40	\N	40	\N	\N	0	1	2	f	0	22	\N
915	281	102	2	38	\N	38	\N	\N	0	1	2	f	0	22	\N
916	5	102	2	34	\N	34	\N	\N	0	1	2	f	0	22	\N
917	294	102	2	34	\N	34	\N	\N	0	1	2	f	0	22	\N
918	128	102	2	33	\N	33	\N	\N	0	1	2	f	0	22	\N
919	21	102	2	29	\N	29	\N	\N	0	1	2	f	0	22	\N
920	98	102	2	29	\N	29	\N	\N	0	1	2	f	0	22	\N
921	304	102	2	29	\N	29	\N	\N	0	1	2	f	0	22	\N
922	60	102	2	28	\N	28	\N	\N	0	1	2	f	0	22	\N
923	120	102	2	26	\N	26	\N	\N	0	1	2	f	0	22	\N
924	253	102	2	26	\N	26	\N	\N	0	1	2	f	0	22	\N
925	307	102	2	26	\N	26	\N	\N	0	1	2	f	0	22	\N
926	50	102	2	25	\N	25	\N	\N	0	1	2	f	0	22	\N
927	4	102	2	24	\N	24	\N	\N	0	1	2	f	0	22	\N
928	101	102	2	24	\N	24	\N	\N	0	1	2	f	0	22	\N
929	168	102	2	24	\N	24	\N	\N	0	1	2	f	0	22	\N
930	199	102	2	24	\N	24	\N	\N	0	1	2	f	0	22	\N
931	152	102	2	22	\N	22	\N	\N	0	1	2	f	0	22	\N
932	269	102	2	21	\N	21	\N	\N	0	1	2	f	0	22	\N
933	333	102	2	21	\N	21	\N	\N	0	1	2	f	0	22	\N
934	158	102	2	19	\N	19	\N	\N	0	1	2	f	0	22	\N
935	230	102	2	18	\N	18	\N	\N	0	1	2	f	0	22	\N
936	283	102	2	18	\N	18	\N	\N	0	1	2	f	0	22	\N
937	343	102	2	18	\N	18	\N	\N	0	1	2	f	0	22	\N
938	129	102	2	16	\N	16	\N	\N	0	1	2	f	0	22	\N
939	254	102	2	16	\N	16	\N	\N	0	1	2	f	0	22	\N
940	32	102	2	15	\N	15	\N	\N	0	1	2	f	0	22	\N
941	177	102	2	15	\N	15	\N	\N	0	1	2	f	0	22	\N
942	96	102	2	14	\N	14	\N	\N	0	1	2	f	0	22	\N
943	276	102	2	14	\N	14	\N	\N	0	1	2	f	0	22	\N
944	117	102	2	12	\N	12	\N	\N	0	1	2	f	0	22	\N
945	133	102	2	11	\N	11	\N	\N	0	1	2	f	0	22	\N
946	114	102	2	10	\N	10	\N	\N	0	1	2	f	0	22	\N
947	302	102	2	10	\N	10	\N	\N	0	1	2	f	0	22	\N
948	308	102	2	10	\N	10	\N	\N	0	1	2	f	0	22	\N
949	16	102	2	9	\N	9	\N	\N	0	1	2	f	0	22	\N
950	185	102	2	9	\N	9	\N	\N	0	1	2	f	0	22	\N
951	190	102	2	9	\N	9	\N	\N	0	1	2	f	0	22	\N
952	6	102	2	8	\N	8	\N	\N	0	1	2	f	0	22	\N
953	108	102	2	8	\N	8	\N	\N	0	1	2	f	0	22	\N
954	20	102	2	7	\N	7	\N	\N	0	1	2	f	0	22	\N
955	303	102	2	7	\N	7	\N	\N	0	1	2	f	0	22	\N
956	63	102	2	6	\N	6	\N	\N	0	1	2	f	0	22	\N
957	319	102	2	6	\N	6	\N	\N	0	1	2	f	0	22	\N
958	334	102	2	6	\N	6	\N	\N	0	1	2	f	0	22	\N
959	73	102	2	5	\N	5	\N	\N	0	1	2	f	0	22	\N
960	122	102	2	5	\N	5	\N	\N	0	1	2	f	0	22	\N
961	249	102	2	5	\N	5	\N	\N	0	1	2	f	0	22	\N
962	15	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
963	31	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
964	137	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
965	180	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
966	279	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
967	305	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
968	320	102	2	4	\N	4	\N	\N	0	1	2	f	0	22	\N
969	3	102	2	3	\N	3	\N	\N	0	1	2	f	0	22	\N
970	43	102	2	3	\N	3	\N	\N	0	1	2	f	0	22	\N
971	132	102	2	3	\N	3	\N	\N	0	1	2	f	0	22	\N
972	290	102	2	3	\N	3	\N	\N	0	1	2	f	0	22	\N
973	316	102	2	3	\N	3	\N	\N	0	1	2	f	0	22	\N
974	8	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
975	17	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
976	59	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
977	87	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
978	102	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
979	142	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
980	146	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
981	160	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
982	183	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
983	289	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
984	342	102	2	2	\N	2	\N	\N	0	1	2	f	0	22	\N
985	34	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
986	58	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
987	67	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
988	83	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
989	88	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
990	156	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
991	182	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
992	206	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
993	252	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
994	264	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
995	285	102	2	1	\N	1	\N	\N	0	1	2	f	0	22	\N
996	22	102	1	86950	\N	86950	\N	\N	1	1	2	f	\N	265	\N
997	175	102	1	17164	\N	17164	\N	\N	0	1	2	f	\N	77	\N
998	97	102	1	100	\N	100	\N	\N	0	1	2	f	\N	77	\N
999	14	103	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1000	288	104	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1001	251	105	2	8	\N	8	\N	\N	1	1	2	f	0	187	\N
1002	187	105	1	8	\N	8	\N	\N	1	1	2	f	\N	251	\N
1003	236	106	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1004	179	107	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1005	329	108	2	16	\N	16	\N	\N	1	1	2	f	0	329	\N
1006	329	108	1	16	\N	16	\N	\N	1	1	2	f	\N	329	\N
1007	79	108	1	1	\N	1	\N	\N	0	1	2	f	\N	329	\N
1008	312	109	2	3	\N	3	\N	\N	1	1	2	f	0	312	\N
1009	312	109	1	3	\N	3	\N	\N	1	1	2	f	\N	312	\N
1010	214	110	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
1011	16	110	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1012	153	111	2	114	\N	114	\N	\N	1	1	2	f	0	153	\N
1013	153	111	1	90	\N	90	\N	\N	1	1	2	f	\N	153	\N
1014	277	112	2	412	\N	0	\N	\N	1	1	2	f	412	\N	\N
1015	313	112	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
1016	24	112	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
1017	216	113	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
1018	350	113	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1019	258	113	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
1020	358	113	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1021	288	114	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1022	288	115	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1023	127	116	2	1232	\N	1232	\N	\N	1	1	2	f	0	219	\N
1024	280	116	2	544	\N	544	\N	\N	0	1	2	f	0	219	\N
1025	46	116	2	510	\N	510	\N	\N	0	1	2	f	0	219	\N
1026	250	116	2	354	\N	354	\N	\N	0	1	2	f	0	219	\N
1027	257	116	2	274	\N	274	\N	\N	0	1	2	f	0	219	\N
1028	341	116	2	204	\N	204	\N	\N	0	1	2	f	0	219	\N
1029	135	116	2	180	\N	180	\N	\N	0	1	2	f	0	219	\N
1030	232	116	2	176	\N	176	\N	\N	0	1	2	f	0	219	\N
1031	321	116	2	160	\N	160	\N	\N	0	1	2	f	0	219	\N
1032	125	116	2	156	\N	156	\N	\N	0	1	2	f	0	219	\N
1033	13	116	2	124	\N	124	\N	\N	0	1	2	f	0	219	\N
1034	337	116	2	120	\N	120	\N	\N	0	1	2	f	0	219	\N
1035	30	116	2	112	\N	112	\N	\N	0	1	2	f	0	219	\N
1036	54	116	2	110	\N	110	\N	\N	0	1	2	f	0	219	\N
1037	234	116	2	94	\N	94	\N	\N	0	1	2	f	0	219	\N
1038	40	116	2	86	\N	86	\N	\N	0	1	2	f	0	219	\N
1039	29	116	2	78	\N	78	\N	\N	0	1	2	f	0	219	\N
1040	253	116	2	44	\N	44	\N	\N	0	1	2	f	0	219	\N
1041	333	116	2	42	\N	42	\N	\N	0	1	2	f	0	219	\N
1042	101	116	2	38	\N	38	\N	\N	0	1	2	f	0	219	\N
1043	152	116	2	38	\N	38	\N	\N	0	1	2	f	0	219	\N
1044	158	116	2	38	\N	38	\N	\N	0	1	2	f	0	219	\N
1045	4	116	2	30	\N	30	\N	\N	0	1	2	f	0	219	\N
1046	269	116	2	30	\N	30	\N	\N	0	1	2	f	0	219	\N
1047	343	116	2	30	\N	30	\N	\N	0	1	2	f	0	219	\N
1048	177	116	2	26	\N	26	\N	\N	0	1	2	f	0	219	\N
1049	254	116	2	24	\N	24	\N	\N	0	1	2	f	0	219	\N
1050	117	116	2	20	\N	20	\N	\N	0	1	2	f	0	219	\N
1051	185	116	2	18	\N	18	\N	\N	0	1	2	f	0	219	\N
1052	283	116	2	18	\N	18	\N	\N	0	1	2	f	0	164	\N
1053	133	116	2	14	\N	14	\N	\N	0	1	2	f	0	219	\N
1054	6	116	2	12	\N	12	\N	\N	0	1	2	f	0	219	\N
1055	319	116	2	12	\N	12	\N	\N	0	1	2	f	0	219	\N
1056	20	116	2	10	\N	10	\N	\N	0	1	2	f	0	219	\N
1057	249	116	2	10	\N	10	\N	\N	0	1	2	f	0	219	\N
1058	308	116	2	10	\N	10	\N	\N	0	1	2	f	0	219	\N
1059	15	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1060	31	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1061	137	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1062	180	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1063	305	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1064	320	116	2	8	\N	8	\N	\N	0	1	2	f	0	219	\N
1065	122	116	2	6	\N	6	\N	\N	0	1	2	f	0	219	\N
1066	132	116	2	6	\N	6	\N	\N	0	1	2	f	0	219	\N
1067	316	116	2	6	\N	6	\N	\N	0	1	2	f	0	219	\N
1068	8	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1069	17	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1070	87	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1071	102	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1072	142	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1073	146	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1074	160	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1075	183	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1076	279	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1077	289	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1078	342	116	2	4	\N	4	\N	\N	0	1	2	f	0	219	\N
1079	34	116	2	2	\N	2	\N	\N	0	1	2	f	0	219	\N
1080	58	116	2	2	\N	2	\N	\N	0	1	2	f	0	219	\N
1081	156	116	2	2	\N	2	\N	\N	0	1	2	f	0	219	\N
1082	264	116	2	2	\N	2	\N	\N	0	1	2	f	0	219	\N
1083	285	116	2	2	\N	2	\N	\N	0	1	2	f	0	219	\N
1084	219	116	1	7623	\N	7623	\N	\N	1	1	2	f	\N	127	\N
1085	164	116	1	4315	\N	4315	\N	\N	0	1	2	f	\N	127	\N
1086	213	117	2	2734	\N	2734	\N	\N	1	1	2	f	0	\N	\N
1087	115	117	2	896	\N	896	\N	\N	0	1	2	f	0	\N	\N
1088	19	117	2	549	\N	549	\N	\N	0	1	2	f	0	\N	\N
1089	296	117	2	287	\N	287	\N	\N	0	1	2	f	0	\N	\N
1090	55	117	2	185	\N	185	\N	\N	0	1	2	f	0	\N	\N
1091	224	117	2	57	\N	57	\N	\N	0	1	2	f	0	\N	\N
1092	237	118	2	2	\N	2	\N	\N	1	1	2	f	0	229	\N
1093	229	118	1	2	\N	2	\N	\N	1	1	2	f	\N	237	\N
1094	238	119	2	506276	\N	0	\N	\N	1	1	2	f	506276	\N	\N
1095	172	119	2	272091	\N	0	\N	\N	0	1	2	f	272091	\N	\N
1096	256	119	2	94473	\N	0	\N	\N	0	1	2	f	94473	\N	\N
1097	107	119	2	1293	\N	0	\N	\N	0	1	2	f	1293	\N	\N
1098	288	120	2	35	\N	0	\N	\N	1	1	2	f	35	\N	\N
1099	288	121	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
1100	288	122	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1101	171	123	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
1102	288	124	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1103	288	125	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1104	94	126	2	575	\N	575	\N	\N	1	1	2	f	0	70	\N
1105	70	126	1	575	\N	575	\N	\N	1	1	2	f	\N	94	\N
1106	14	127	2	90	\N	90	\N	\N	1	1	2	f	0	354	\N
1107	354	127	1	88	\N	88	\N	\N	1	1	2	f	\N	14	\N
1108	354	128	2	111	\N	111	\N	\N	1	1	2	f	0	\N	\N
1109	192	129	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
1110	198	129	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
1111	138	129	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
1112	208	130	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1113	216	131	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
1114	216	132	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
1115	350	132	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1116	358	132	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1117	288	134	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1118	251	135	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1119	288	136	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1120	216	137	2	68923	\N	68923	\N	\N	1	1	2	f	0	\N	\N
1121	346	137	2	13216	\N	13216	\N	\N	0	1	2	f	0	\N	\N
1122	350	137	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1123	258	137	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
1124	167	137	2	4512	\N	4512	\N	\N	0	1	2	f	0	\N	\N
1125	358	137	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1126	71	137	2	1086	\N	1086	\N	\N	0	1	2	f	0	\N	\N
1127	297	137	2	308	\N	308	\N	\N	0	1	2	f	0	\N	\N
1128	192	138	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
1129	198	138	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
1130	138	138	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
1131	288	139	2	82	\N	0	\N	\N	1	1	2	f	82	\N	\N
1132	359	140	2	165851	\N	0	\N	\N	1	1	2	f	165851	\N	\N
1133	144	140	2	93646	\N	0	\N	\N	0	1	2	f	93646	\N	\N
1134	161	140	2	80673	\N	0	\N	\N	0	1	2	f	80673	\N	\N
1135	216	140	2	73801	\N	0	\N	\N	0	1	2	f	73801	\N	\N
1136	145	140	2	44485	\N	0	\N	\N	0	1	2	f	44485	\N	\N
1137	166	140	2	41983	\N	0	\N	\N	0	1	2	f	41983	\N	\N
1138	291	140	2	34675	\N	0	\N	\N	0	1	2	f	34675	\N	\N
1139	119	140	2	33735	\N	0	\N	\N	0	1	2	f	33735	\N	\N
1140	315	140	2	26913	\N	0	\N	\N	0	1	2	f	26913	\N	\N
1141	271	140	2	21935	\N	0	\N	\N	0	1	2	f	21935	\N	\N
1142	272	140	2	17338	\N	0	\N	\N	0	1	2	f	17338	\N	\N
1143	72	140	2	16761	\N	0	\N	\N	0	1	2	f	16761	\N	\N
1144	346	140	2	13216	\N	0	\N	\N	0	1	2	f	13216	\N	\N
1145	123	140	2	13009	\N	0	\N	\N	0	1	2	f	13009	\N	\N
1146	335	140	2	11871	\N	0	\N	\N	0	1	2	f	11871	\N	\N
1147	328	140	2	10131	\N	0	\N	\N	0	1	2	f	10131	\N	\N
1148	16	140	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1149	214	140	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1150	186	140	2	8442	\N	0	\N	\N	0	1	2	f	8442	\N	\N
1151	348	140	2	7912	\N	0	\N	\N	0	1	2	f	7912	\N	\N
1152	350	140	2	7411	\N	0	\N	\N	0	1	2	f	7411	\N	\N
1153	298	140	2	7262	\N	0	\N	\N	0	1	2	f	7262	\N	\N
1154	222	140	2	7222	\N	0	\N	\N	0	1	2	f	7222	\N	\N
1155	205	140	2	7146	\N	0	\N	\N	0	1	2	f	7146	\N	\N
1156	258	140	2	5269	\N	0	\N	\N	0	1	2	f	5269	\N	\N
1157	93	140	2	4768	\N	0	\N	\N	0	1	2	f	4768	\N	\N
1158	293	140	2	4632	\N	0	\N	\N	0	1	2	f	4632	\N	\N
1159	282	140	2	4630	\N	0	\N	\N	0	1	2	f	4630	\N	\N
1160	62	140	2	4603	\N	0	\N	\N	0	1	2	f	4603	\N	\N
1161	167	140	2	4512	\N	0	\N	\N	0	1	2	f	4512	\N	\N
1162	245	140	2	3546	\N	0	\N	\N	0	1	2	f	3546	\N	\N
1163	154	140	2	3499	\N	0	\N	\N	0	1	2	f	3499	\N	\N
1164	213	140	2	2734	\N	0	\N	\N	0	1	2	f	2734	\N	\N
1165	35	140	2	2578	\N	0	\N	\N	0	1	2	f	2578	\N	\N
1166	105	140	2	2467	\N	0	\N	\N	0	1	2	f	2467	\N	\N
1167	9	140	2	2373	\N	0	\N	\N	0	1	2	f	2373	\N	\N
1168	358	140	2	2012	\N	0	\N	\N	0	1	2	f	2012	\N	\N
1169	149	140	2	1992	\N	0	\N	\N	0	1	2	f	1992	\N	\N
1170	85	140	2	1751	\N	0	\N	\N	0	1	2	f	1751	\N	\N
1171	147	140	2	1521	\N	0	\N	\N	0	1	2	f	1521	\N	\N
1172	210	140	2	1418	\N	0	\N	\N	0	1	2	f	1418	\N	\N
1173	118	140	2	1368	\N	0	\N	\N	0	1	2	f	1368	\N	\N
1174	311	140	2	1345	\N	0	\N	\N	0	1	2	f	1345	\N	\N
1175	261	140	2	1336	\N	0	\N	\N	0	1	2	f	1336	\N	\N
1176	322	140	2	1326	\N	0	\N	\N	0	1	2	f	1326	\N	\N
1177	268	140	2	1232	\N	0	\N	\N	0	1	2	f	1232	\N	\N
1178	42	140	2	1147	\N	0	\N	\N	0	1	2	f	1147	\N	\N
1179	217	140	2	1146	\N	0	\N	\N	0	1	2	f	1146	\N	\N
1180	306	140	2	1143	\N	0	\N	\N	0	1	2	f	1143	\N	\N
1181	193	140	2	1115	\N	0	\N	\N	0	1	2	f	1115	\N	\N
1182	198	140	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
1183	28	140	2	1107	\N	0	\N	\N	0	1	2	f	1107	\N	\N
1184	45	140	2	1099	\N	0	\N	\N	0	1	2	f	1099	\N	\N
1185	353	140	2	1092	\N	0	\N	\N	0	1	2	f	1092	\N	\N
1186	51	140	2	1091	\N	0	\N	\N	0	1	2	f	1091	\N	\N
1187	71	140	2	1086	\N	0	\N	\N	0	1	2	f	1086	\N	\N
1188	131	140	2	985	\N	0	\N	\N	0	1	2	f	985	\N	\N
1189	1	140	2	958	\N	0	\N	\N	0	1	2	f	958	\N	\N
1190	248	140	2	957	\N	0	\N	\N	0	1	2	f	957	\N	\N
1191	351	140	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
1192	241	140	2	911	\N	0	\N	\N	0	1	2	f	911	\N	\N
1193	115	140	2	896	\N	0	\N	\N	0	1	2	f	896	\N	\N
1194	41	140	2	853	\N	0	\N	\N	0	1	2	f	853	\N	\N
1195	126	140	2	818	\N	0	\N	\N	0	1	2	f	818	\N	\N
1196	352	140	2	807	\N	0	\N	\N	0	1	2	f	807	\N	\N
1197	347	140	2	795	\N	0	\N	\N	0	1	2	f	795	\N	\N
1198	66	140	2	736	\N	0	\N	\N	0	1	2	f	736	\N	\N
1199	270	140	2	733	\N	0	\N	\N	0	1	2	f	733	\N	\N
1200	47	140	2	723	\N	0	\N	\N	0	1	2	f	723	\N	\N
1201	201	140	2	694	\N	0	\N	\N	0	1	2	f	694	\N	\N
1202	242	140	2	685	\N	0	\N	\N	0	1	2	f	685	\N	\N
1203	92	140	2	643	\N	0	\N	\N	0	1	2	f	643	\N	\N
1204	103	140	2	619	\N	0	\N	\N	0	1	2	f	619	\N	\N
1205	336	140	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
1206	19	140	2	549	\N	0	\N	\N	0	1	2	f	549	\N	\N
1207	176	140	2	543	\N	0	\N	\N	0	1	2	f	543	\N	\N
1208	140	140	2	502	\N	0	\N	\N	0	1	2	f	502	\N	\N
1209	356	140	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
1210	81	140	2	474	\N	0	\N	\N	0	1	2	f	474	\N	\N
1211	228	140	2	463	\N	0	\N	\N	0	1	2	f	463	\N	\N
1212	277	140	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
1213	314	140	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
1214	52	140	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
1215	297	140	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
1216	286	140	2	304	\N	0	\N	\N	0	1	2	f	304	\N	\N
1217	266	140	2	298	\N	0	\N	\N	0	1	2	f	298	\N	\N
1218	202	140	2	292	\N	0	\N	\N	0	1	2	f	292	\N	\N
1219	296	140	2	287	\N	0	\N	\N	0	1	2	f	287	\N	\N
1220	299	140	2	254	\N	0	\N	\N	0	1	2	f	254	\N	\N
1221	292	140	2	250	\N	0	\N	\N	0	1	2	f	250	\N	\N
1222	188	140	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
1223	262	140	2	210	\N	0	\N	\N	0	1	2	f	210	\N	\N
1224	89	140	2	204	\N	0	\N	\N	0	1	2	f	204	\N	\N
1225	109	140	2	190	\N	0	\N	\N	0	1	2	f	190	\N	\N
1226	55	140	2	185	\N	0	\N	\N	0	1	2	f	185	\N	\N
1227	44	140	2	180	\N	0	\N	\N	0	1	2	f	180	\N	\N
1228	209	140	2	169	\N	0	\N	\N	0	1	2	f	169	\N	\N
1229	255	140	2	163	\N	0	\N	\N	0	1	2	f	163	\N	\N
1230	313	140	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
1231	65	140	2	154	\N	0	\N	\N	0	1	2	f	154	\N	\N
1232	223	140	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
1233	95	140	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
1234	163	140	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
1235	226	140	2	125	\N	0	\N	\N	0	1	2	f	125	\N	\N
1236	86	140	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
1237	26	140	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
1238	247	140	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
1239	76	140	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
1240	169	140	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
1241	104	140	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
1242	130	140	2	98	\N	0	\N	\N	0	1	2	f	98	\N	\N
1243	151	140	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
1244	139	140	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
1245	344	140	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
1246	74	140	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
1247	273	140	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
1248	338	140	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
1249	323	140	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
1250	57	140	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
1251	243	140	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
1252	100	140	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
1253	61	140	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
1254	2	140	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
1255	24	140	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
1256	7	140	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
1257	121	140	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
1258	224	140	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
1259	124	140	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
1260	191	140	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1261	207	140	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
1262	138	140	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
1263	69	140	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
1264	284	140	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1265	318	140	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1266	275	140	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
1267	345	140	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
1268	106	140	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
1269	331	140	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
1270	235	140	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1271	165	140	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
1272	39	140	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
1273	155	140	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1274	233	140	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1275	33	140	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1276	91	140	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1277	11	140	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1278	239	140	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1279	325	140	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1280	12	140	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1281	68	140	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1282	162	140	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1283	260	140	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1284	75	140	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1285	194	140	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1286	80	140	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1287	330	140	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1288	99	140	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1289	111	140	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1290	204	140	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1291	84	140	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1292	110	140	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1293	150	140	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1294	157	140	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1295	358	141	2	2012	\N	2012	\N	\N	1	1	2	f	0	\N	\N
1296	288	142	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
1297	208	143	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1298	288	144	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1299	277	145	2	412	\N	412	\N	\N	1	1	2	f	0	\N	\N
1300	313	145	2	158	\N	158	\N	\N	0	1	2	f	0	\N	\N
1301	24	145	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1302	219	146	2	301	\N	301	\N	\N	1	1	2	f	0	164	\N
1303	23	146	2	1	\N	1	\N	\N	0	1	2	f	0	164	\N
1304	164	146	1	290	\N	290	\N	\N	1	1	2	f	\N	219	\N
1305	354	147	2	140	\N	0	\N	\N	1	1	2	f	140	\N	\N
1306	231	147	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1307	14	148	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
1308	214	149	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
1309	16	149	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1310	216	150	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
1311	350	150	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1312	258	150	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
1313	358	150	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1314	288	151	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1315	173	152	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1316	359	153	2	165851	\N	165851	\N	\N	1	1	2	f	0	238	\N
1317	144	153	2	93646	\N	93646	\N	\N	0	1	2	f	0	238	\N
1318	161	153	2	80673	\N	80673	\N	\N	0	1	2	f	0	238	\N
1319	216	153	2	73801	\N	73801	\N	\N	0	1	2	f	0	238	\N
1320	145	153	2	44485	\N	44485	\N	\N	0	1	2	f	0	172	\N
1321	166	153	2	41983	\N	41983	\N	\N	0	1	2	f	0	172	\N
1322	291	153	2	34675	\N	34675	\N	\N	0	1	2	f	0	172	\N
1323	119	153	2	33735	\N	33735	\N	\N	0	1	2	f	0	238	\N
1324	315	153	2	26913	\N	26913	\N	\N	0	1	2	f	0	256	\N
1325	271	153	2	21935	\N	21935	\N	\N	0	1	2	f	0	172	\N
1326	272	153	2	17338	\N	17338	\N	\N	0	1	2	f	0	172	\N
1327	72	153	2	16761	\N	16761	\N	\N	0	1	2	f	0	172	\N
1328	346	153	2	13216	\N	13216	\N	\N	0	1	2	f	0	238	\N
1329	123	153	2	13009	\N	13009	\N	\N	0	1	2	f	0	172	\N
1330	335	153	2	11871	\N	11871	\N	\N	0	1	2	f	0	256	\N
1331	328	153	2	10131	\N	10131	\N	\N	0	1	2	f	0	172	\N
1332	192	153	2	10030	\N	10030	\N	\N	0	1	2	f	0	172	\N
1333	16	153	2	9670	\N	9670	\N	\N	0	1	2	f	0	238	\N
1334	214	153	2	9670	\N	9670	\N	\N	0	1	2	f	0	238	\N
1335	186	153	2	8442	\N	8442	\N	\N	0	1	2	f	0	172	\N
1336	348	153	2	7912	\N	7912	\N	\N	0	1	2	f	0	256	\N
1337	350	153	2	7411	\N	7411	\N	\N	0	1	2	f	0	238	\N
1338	298	153	2	7262	\N	7262	\N	\N	0	1	2	f	0	172	\N
1339	222	153	2	7222	\N	7222	\N	\N	0	1	2	f	0	172	\N
1340	205	153	2	7146	\N	7146	\N	\N	0	1	2	f	0	256	\N
1341	258	153	2	5269	\N	5269	\N	\N	0	1	2	f	0	238	\N
1342	93	153	2	4768	\N	4768	\N	\N	0	1	2	f	0	256	\N
1343	293	153	2	4632	\N	4632	\N	\N	0	1	2	f	0	256	\N
1344	282	153	2	4630	\N	4630	\N	\N	0	1	2	f	0	256	\N
1345	62	153	2	4603	\N	4603	\N	\N	0	1	2	f	0	256	\N
1346	295	153	2	4526	\N	4526	\N	\N	0	1	2	f	0	172	\N
1347	167	153	2	4512	\N	4512	\N	\N	0	1	2	f	0	238	\N
1348	245	153	2	3546	\N	3546	\N	\N	0	1	2	f	0	172	\N
1349	154	153	2	3499	\N	3499	\N	\N	0	1	2	f	0	256	\N
1350	213	153	2	2734	\N	2734	\N	\N	0	1	2	f	0	238	\N
1351	35	153	2	2578	\N	2578	\N	\N	0	1	2	f	0	172	\N
1352	105	153	2	2467	\N	2467	\N	\N	0	1	2	f	0	172	\N
1353	9	153	2	2373	\N	2373	\N	\N	0	1	2	f	0	256	\N
1354	301	153	2	2225	\N	2225	\N	\N	0	1	2	f	0	172	\N
1355	358	153	2	2012	\N	2012	\N	\N	0	1	2	f	0	238	\N
1356	149	153	2	1992	\N	1992	\N	\N	0	1	2	f	0	172	\N
1357	85	153	2	1751	\N	1751	\N	\N	0	1	2	f	0	238	\N
1358	147	153	2	1521	\N	1521	\N	\N	0	1	2	f	0	256	\N
1359	210	153	2	1418	\N	1418	\N	\N	0	1	2	f	0	172	\N
1360	118	153	2	1368	\N	1368	\N	\N	0	1	2	f	0	172	\N
1361	311	153	2	1345	\N	1345	\N	\N	0	1	2	f	0	238	\N
1362	261	153	2	1336	\N	1336	\N	\N	0	1	2	f	0	256	\N
1363	322	153	2	1326	\N	1326	\N	\N	0	1	2	f	0	172	\N
1364	268	153	2	1232	\N	1232	\N	\N	0	1	2	f	0	238	\N
1365	42	153	2	1147	\N	1147	\N	\N	0	1	2	f	0	238	\N
1366	217	153	2	1146	\N	1146	\N	\N	0	1	2	f	0	172	\N
1367	306	153	2	1143	\N	1143	\N	\N	0	1	2	f	0	238	\N
1368	193	153	2	1115	\N	1115	\N	\N	0	1	2	f	0	238	\N
1369	198	153	2	1111	\N	1111	\N	\N	0	1	2	f	0	172	\N
1370	28	153	2	1107	\N	1107	\N	\N	0	1	2	f	0	172	\N
1371	45	153	2	1099	\N	1099	\N	\N	0	1	2	f	0	172	\N
1372	353	153	2	1092	\N	1092	\N	\N	0	1	2	f	0	256	\N
1373	51	153	2	1091	\N	1091	\N	\N	0	1	2	f	0	172	\N
1374	71	153	2	1086	\N	1086	\N	\N	0	1	2	f	0	238	\N
1375	131	153	2	985	\N	985	\N	\N	0	1	2	f	0	238	\N
1376	1	153	2	958	\N	958	\N	\N	0	1	2	f	0	172	\N
1377	248	153	2	957	\N	957	\N	\N	0	1	2	f	0	256	\N
1378	351	153	2	931	\N	931	\N	\N	0	1	2	f	0	172	\N
1379	241	153	2	911	\N	911	\N	\N	0	1	2	f	0	172	\N
1380	115	153	2	896	\N	896	\N	\N	0	1	2	f	0	238	\N
1381	41	153	2	853	\N	853	\N	\N	0	1	2	f	0	256	\N
1382	126	153	2	818	\N	818	\N	\N	0	1	2	f	0	172	\N
1383	352	153	2	807	\N	807	\N	\N	0	1	2	f	0	256	\N
1384	347	153	2	795	\N	795	\N	\N	0	1	2	f	0	256	\N
1385	66	153	2	736	\N	736	\N	\N	0	1	2	f	0	172	\N
1386	270	153	2	733	\N	733	\N	\N	0	1	2	f	0	238	\N
1387	47	153	2	723	\N	723	\N	\N	0	1	2	f	0	256	\N
1388	201	153	2	694	\N	694	\N	\N	0	1	2	f	0	172	\N
1389	242	153	2	685	\N	685	\N	\N	0	1	2	f	0	172	\N
1390	92	153	2	643	\N	643	\N	\N	0	1	2	f	0	172	\N
1391	103	153	2	619	\N	619	\N	\N	0	1	2	f	0	256	\N
1392	336	153	2	598	\N	598	\N	\N	0	1	2	f	0	172	\N
1393	19	153	2	549	\N	549	\N	\N	0	1	2	f	0	238	\N
1394	176	153	2	543	\N	543	\N	\N	0	1	2	f	0	172	\N
1395	140	153	2	502	\N	502	\N	\N	0	1	2	f	0	172	\N
1396	356	153	2	489	\N	489	\N	\N	0	1	2	f	0	172	\N
1397	81	153	2	474	\N	474	\N	\N	0	1	2	f	0	172	\N
1398	228	153	2	463	\N	463	\N	\N	0	1	2	f	0	256	\N
1399	277	153	2	412	\N	412	\N	\N	0	1	2	f	0	172	\N
1400	314	153	2	405	\N	405	\N	\N	0	1	2	f	0	256	\N
1401	52	153	2	359	\N	359	\N	\N	0	1	2	f	0	256	\N
1402	297	153	2	308	\N	308	\N	\N	0	1	2	f	0	172	\N
1403	286	153	2	304	\N	304	\N	\N	0	1	2	f	0	256	\N
1404	266	153	2	298	\N	298	\N	\N	0	1	2	f	0	238	\N
1405	202	153	2	292	\N	292	\N	\N	0	1	2	f	0	256	\N
1406	296	153	2	287	\N	287	\N	\N	0	1	2	f	0	238	\N
1407	299	153	2	254	\N	254	\N	\N	0	1	2	f	0	172	\N
1408	292	153	2	250	\N	250	\N	\N	0	1	2	f	0	172	\N
1409	188	153	2	221	\N	221	\N	\N	0	1	2	f	0	238	\N
1410	262	153	2	210	\N	210	\N	\N	0	1	2	f	0	256	\N
1411	89	153	2	204	\N	204	\N	\N	0	1	2	f	0	172	\N
1412	109	153	2	190	\N	190	\N	\N	0	1	2	f	0	238	\N
1413	55	153	2	185	\N	185	\N	\N	0	1	2	f	0	238	\N
1414	44	153	2	180	\N	180	\N	\N	0	1	2	f	0	256	\N
1415	209	153	2	169	\N	169	\N	\N	0	1	2	f	0	172	\N
1416	255	153	2	163	\N	163	\N	\N	0	1	2	f	0	256	\N
1417	313	153	2	158	\N	158	\N	\N	0	1	2	f	0	172	\N
1418	65	153	2	154	\N	154	\N	\N	0	1	2	f	0	172	\N
1419	223	153	2	144	\N	144	\N	\N	0	1	2	f	0	256	\N
1420	95	153	2	140	\N	140	\N	\N	0	1	2	f	0	172	\N
1421	163	153	2	140	\N	140	\N	\N	0	1	2	f	0	256	\N
1422	226	153	2	125	\N	125	\N	\N	0	1	2	f	0	172	\N
1423	86	153	2	118	\N	118	\N	\N	0	1	2	f	0	238	\N
1424	26	153	2	113	\N	113	\N	\N	0	1	2	f	0	172	\N
1425	247	153	2	110	\N	110	\N	\N	0	1	2	f	0	256	\N
1426	76	153	2	105	\N	105	\N	\N	0	1	2	f	0	256	\N
1427	169	153	2	104	\N	104	\N	\N	0	1	2	f	0	256	\N
1428	104	153	2	102	\N	102	\N	\N	0	1	2	f	0	238	\N
1429	130	153	2	98	\N	98	\N	\N	0	1	2	f	0	256	\N
1430	151	153	2	93	\N	93	\N	\N	0	1	2	f	0	172	\N
1431	139	153	2	91	\N	91	\N	\N	0	1	2	f	0	172	\N
1432	344	153	2	91	\N	91	\N	\N	0	1	2	f	0	256	\N
1433	74	153	2	89	\N	89	\N	\N	0	1	2	f	0	256	\N
1434	273	153	2	86	\N	86	\N	\N	0	1	2	f	0	172	\N
1435	338	153	2	86	\N	86	\N	\N	0	1	2	f	0	256	\N
1436	323	153	2	81	\N	81	\N	\N	0	1	2	f	0	256	\N
1437	57	153	2	74	\N	74	\N	\N	0	1	2	f	0	172	\N
1438	243	153	2	69	\N	69	\N	\N	0	1	2	f	0	256	\N
1439	100	153	2	68	\N	68	\N	\N	0	1	2	f	0	238	\N
1440	61	153	2	62	\N	62	\N	\N	0	1	2	f	0	256	\N
1441	2	153	2	61	\N	61	\N	\N	0	1	2	f	0	172	\N
1442	24	153	2	61	\N	61	\N	\N	0	1	2	f	0	172	\N
1443	7	153	2	58	\N	58	\N	\N	0	1	2	f	0	238	\N
1444	121	153	2	57	\N	57	\N	\N	0	1	2	f	0	172	\N
1445	224	153	2	57	\N	57	\N	\N	0	1	2	f	0	238	\N
1446	124	153	2	54	\N	54	\N	\N	0	1	2	f	0	256	\N
1447	191	153	2	50	\N	50	\N	\N	0	1	2	f	0	107	\N
1448	207	153	2	46	\N	46	\N	\N	0	1	2	f	0	238	\N
1449	138	153	2	45	\N	45	\N	\N	0	1	2	f	0	172	\N
1450	69	153	2	43	\N	43	\N	\N	0	1	2	f	0	256	\N
1451	284	153	2	40	\N	40	\N	\N	0	1	2	f	0	256	\N
1452	318	153	2	40	\N	40	\N	\N	0	1	2	f	0	172	\N
1453	275	153	2	38	\N	38	\N	\N	0	1	2	f	0	172	\N
1454	345	153	2	38	\N	38	\N	\N	0	1	2	f	0	256	\N
1455	106	153	2	34	\N	34	\N	\N	0	1	2	f	0	256	\N
1456	331	153	2	34	\N	34	\N	\N	0	1	2	f	0	238	\N
1457	235	153	2	29	\N	29	\N	\N	0	1	2	f	0	238	\N
1458	165	153	2	27	\N	27	\N	\N	0	1	2	f	0	238	\N
1459	39	153	2	22	\N	22	\N	\N	0	1	2	f	0	256	\N
1460	155	153	2	17	\N	17	\N	\N	0	1	2	f	0	107	\N
1461	233	153	2	15	\N	15	\N	\N	0	1	2	f	0	172	\N
1462	33	153	2	14	\N	14	\N	\N	0	1	2	f	0	172	\N
1463	91	153	2	13	\N	13	\N	\N	0	1	2	f	0	172	\N
1464	11	153	2	12	\N	12	\N	\N	0	1	2	f	0	238	\N
1465	239	153	2	10	\N	10	\N	\N	0	1	2	f	0	256	\N
1466	325	153	2	10	\N	10	\N	\N	0	1	2	f	0	256	\N
1467	12	153	2	9	\N	9	\N	\N	0	1	2	f	0	256	\N
1468	68	153	2	8	\N	8	\N	\N	0	1	2	f	0	238	\N
1469	162	153	2	8	\N	8	\N	\N	0	1	2	f	0	256	\N
1470	260	153	2	7	\N	7	\N	\N	0	1	2	f	0	256	\N
1471	75	153	2	6	\N	6	\N	\N	0	1	2	f	0	256	\N
1472	194	153	2	5	\N	5	\N	\N	0	1	2	f	0	238	\N
1473	80	153	2	3	\N	3	\N	\N	0	1	2	f	0	238	\N
1474	330	153	2	3	\N	3	\N	\N	0	1	2	f	0	238	\N
1475	99	153	2	2	\N	2	\N	\N	0	1	2	f	0	256	\N
1476	111	153	2	2	\N	2	\N	\N	0	1	2	f	0	107	\N
1477	204	153	2	2	\N	2	\N	\N	0	1	2	f	0	172	\N
1478	84	153	2	1	\N	1	\N	\N	0	1	2	f	0	256	\N
1479	110	153	2	1	\N	1	\N	\N	0	1	2	f	0	256	\N
1480	150	153	2	1	\N	1	\N	\N	0	1	2	f	0	256	\N
1481	157	153	2	1	\N	1	\N	\N	0	1	2	f	0	238	\N
1482	238	153	1	506264	\N	506264	\N	\N	1	1	2	f	\N	359	\N
1483	172	153	1	271951	\N	271951	\N	\N	0	1	2	f	\N	145	\N
1484	256	153	1	90247	\N	90247	\N	\N	0	1	2	f	\N	315	\N
1485	107	153	1	1138	\N	1138	\N	\N	0	1	2	f	\N	348	\N
1486	288	154	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1487	288	155	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1488	237	156	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1489	359	157	2	164956	\N	0	\N	\N	1	1	2	f	164956	\N	\N
1490	145	157	2	44473	\N	0	\N	\N	0	1	2	f	44473	\N	\N
1491	298	157	2	7260	\N	0	\N	\N	0	1	2	f	7260	\N	\N
1492	118	157	2	1368	\N	0	\N	\N	0	1	2	f	1368	\N	\N
1493	85	157	2	1233	\N	0	\N	\N	0	1	2	f	1233	\N	\N
1494	217	157	2	1146	\N	0	\N	\N	0	1	2	f	1146	\N	\N
1495	140	157	2	502	\N	0	\N	\N	0	1	2	f	502	\N	\N
1496	65	157	2	154	\N	0	\N	\N	0	1	2	f	154	\N	\N
1497	14	158	2	2	\N	2	\N	\N	1	1	2	f	0	354	\N
1498	354	158	1	2	\N	2	\N	\N	1	1	2	f	\N	14	\N
1499	288	159	2	82	\N	82	\N	\N	1	1	2	f	0	263	\N
1500	263	159	1	82	\N	82	\N	\N	1	1	2	f	\N	288	\N
1501	214	160	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
1502	16	160	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1503	354	162	2	280	\N	280	\N	\N	1	1	2	f	0	354	\N
1504	354	162	1	180	\N	180	\N	\N	1	1	2	f	\N	354	\N
1505	14	162	1	100	\N	100	\N	\N	0	1	2	f	\N	354	\N
1506	216	163	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
1507	350	163	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1508	258	163	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
1509	358	163	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1510	324	164	2	1	\N	1	\N	\N	1	1	2	f	0	324	\N
1511	340	164	2	1	\N	1	\N	\N	0	1	2	f	0	340	\N
1512	324	164	1	1	\N	1	\N	\N	1	1	2	f	\N	324	\N
1513	340	164	1	1	\N	1	\N	\N	0	1	2	f	\N	340	\N
1514	214	165	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
1515	16	165	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1516	231	166	2	64	\N	64	\N	\N	1	1	2	f	0	211	\N
1517	329	166	2	48	\N	48	\N	\N	0	1	2	f	0	354	\N
1518	79	166	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
1519	354	166	1	48	\N	48	\N	\N	1	1	2	f	\N	329	\N
1520	211	166	1	24	\N	24	\N	\N	0	1	2	f	\N	231	\N
1521	211	167	2	24	\N	24	\N	\N	1	1	2	f	0	153	\N
1522	153	167	1	24	\N	24	\N	\N	1	1	2	f	\N	211	\N
1523	208	168	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1524	175	169	2	17164	\N	0	\N	\N	1	1	2	f	17164	\N	\N
1525	97	169	2	100	\N	0	\N	\N	0	1	2	f	100	\N	\N
1526	167	170	2	4512	\N	4512	\N	\N	1	1	2	f	0	\N	\N
1527	25	171	2	1	\N	1	\N	\N	1	1	2	f	0	312	\N
1528	312	171	1	1	\N	1	\N	\N	1	1	2	f	\N	25	\N
1529	173	172	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1530	164	173	2	287	\N	287	\N	\N	1	1	2	f	0	219	\N
1531	219	173	1	301	\N	301	\N	\N	1	1	2	f	\N	164	\N
1532	214	174	2	9670	\N	0	\N	\N	1	1	2	f	9670	\N	\N
1533	16	174	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
1534	288	175	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1535	119	176	2	33735	\N	33735	\N	\N	1	1	2	f	0	\N	\N
1536	282	176	2	4630	\N	4630	\N	\N	0	1	2	f	0	\N	\N
1537	236	177	2	2	\N	2	\N	\N	1	1	2	f	0	251	\N
1538	251	177	1	2	\N	2	\N	\N	1	1	2	f	\N	236	\N
1539	62	178	2	4603	\N	4603	\N	\N	1	1	2	f	0	\N	\N
1540	347	178	2	795	\N	795	\N	\N	0	1	2	f	0	\N	\N
1541	119	179	2	16017	\N	15287	\N	\N	1	1	2	f	730	\N	\N
1542	228	179	2	417	\N	417	\N	\N	0	1	2	f	\N	\N	\N
1543	127	180	2	947	\N	947	\N	\N	1	1	2	f	\N	127	\N
1544	280	180	2	583	\N	583	\N	\N	0	1	2	f	\N	280	\N
1545	46	180	2	307	\N	307	\N	\N	0	1	2	f	\N	46	\N
1546	250	180	2	250	\N	250	\N	\N	0	1	2	f	\N	250	\N
1547	257	180	2	250	\N	250	\N	\N	0	1	2	f	\N	257	\N
1548	135	180	2	152	\N	152	\N	\N	0	1	2	f	\N	135	\N
1549	13	180	2	138	\N	138	\N	\N	0	1	2	f	\N	13	\N
1550	321	180	2	114	\N	114	\N	\N	0	1	2	f	\N	321	\N
1551	54	180	2	111	\N	111	\N	\N	0	1	2	f	\N	\N	\N
1552	125	180	2	105	\N	105	\N	\N	0	1	2	f	\N	125	\N
1553	341	180	2	102	\N	102	\N	\N	0	1	2	f	\N	341	\N
1554	337	180	2	99	\N	99	\N	\N	0	1	2	f	\N	337	\N
1555	40	180	2	81	\N	81	\N	\N	0	1	2	f	\N	40	\N
1556	30	180	2	76	\N	76	\N	\N	0	1	2	f	\N	30	\N
1557	29	180	2	70	\N	70	\N	\N	0	1	2	f	\N	29	\N
1558	232	180	2	63	\N	63	\N	\N	0	1	2	f	\N	232	\N
1559	234	180	2	52	\N	52	\N	\N	0	1	2	f	\N	234	\N
1560	101	180	2	45	\N	45	\N	\N	0	1	2	f	\N	101	\N
1561	253	180	2	35	\N	35	\N	\N	0	1	2	f	\N	253	\N
1562	269	180	2	33	\N	33	\N	\N	0	1	2	f	\N	269	\N
1563	4	180	2	31	\N	31	\N	\N	0	1	2	f	\N	4	\N
1564	152	180	2	28	\N	28	\N	\N	0	1	2	f	\N	152	\N
1565	343	180	2	26	\N	26	\N	\N	0	1	2	f	\N	343	\N
1566	283	180	2	24	\N	24	\N	\N	0	1	2	f	\N	283	\N
1567	117	180	2	22	\N	22	\N	\N	0	1	2	f	\N	117	\N
1568	254	180	2	21	\N	21	\N	\N	0	1	2	f	\N	254	\N
1569	177	180	2	20	\N	20	\N	\N	0	1	2	f	\N	177	\N
1570	333	180	2	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
1571	133	180	2	18	\N	18	\N	\N	0	1	2	f	\N	133	\N
1572	158	180	2	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
1573	6	180	2	16	\N	16	\N	\N	0	1	2	f	\N	6	\N
1574	185	180	2	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
1575	308	180	2	13	\N	13	\N	\N	0	1	2	f	\N	308	\N
1576	319	180	2	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
1577	219	180	2	12	\N	12	\N	\N	0	1	2	f	\N	219	\N
1578	31	180	2	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
1579	122	180	2	10	\N	10	\N	\N	0	1	2	f	\N	122	\N
1580	15	180	2	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1581	20	180	2	8	\N	8	\N	\N	0	1	2	f	\N	20	\N
1582	180	180	2	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1583	249	180	2	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1584	279	180	2	8	\N	8	\N	\N	0	1	2	f	\N	279	\N
1585	8	180	2	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
1586	320	180	2	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
1587	17	180	2	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1588	137	180	2	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1589	231	180	2	4	\N	\N	\N	\N	0	1	2	f	4	\N	\N
1590	305	180	2	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1591	87	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1592	102	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1593	132	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1594	142	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1595	160	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1596	316	180	2	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1597	58	180	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1598	156	180	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1599	289	180	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1600	342	180	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1601	34	180	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1602	146	180	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1603	183	180	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1604	264	180	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1605	285	180	2	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1606	127	180	1	682	\N	682	\N	\N	1	1	2	f	\N	127	\N
1607	280	180	1	497	\N	497	\N	\N	0	1	2	f	\N	280	\N
1608	219	180	1	301	\N	301	\N	\N	0	1	2	f	\N	219	\N
1609	46	180	1	274	\N	274	\N	\N	0	1	2	f	\N	46	\N
1610	250	180	1	249	\N	249	\N	\N	0	1	2	f	\N	250	\N
1611	257	180	1	159	\N	159	\N	\N	0	1	2	f	\N	257	\N
1612	13	180	1	137	\N	137	\N	\N	0	1	2	f	\N	13	\N
1613	135	180	1	127	\N	127	\N	\N	0	1	2	f	\N	135	\N
1614	125	180	1	92	\N	92	\N	\N	0	1	2	f	\N	125	\N
1615	321	180	1	90	\N	90	\N	\N	0	1	2	f	\N	321	\N
1616	40	180	1	81	\N	81	\N	\N	0	1	2	f	\N	40	\N
1617	341	180	1	69	\N	69	\N	\N	0	1	2	f	\N	341	\N
1618	29	180	1	63	\N	63	\N	\N	0	1	2	f	\N	29	\N
1619	30	180	1	61	\N	61	\N	\N	0	1	2	f	\N	30	\N
1620	337	180	1	59	\N	59	\N	\N	0	1	2	f	\N	337	\N
1621	54	180	1	53	\N	53	\N	\N	0	1	2	f	\N	\N	\N
1622	234	180	1	50	\N	50	\N	\N	0	1	2	f	\N	234	\N
1623	253	180	1	31	\N	31	\N	\N	0	1	2	f	\N	253	\N
1624	4	180	1	30	\N	30	\N	\N	0	1	2	f	\N	4	\N
1625	101	180	1	30	\N	30	\N	\N	0	1	2	f	\N	101	\N
1626	152	180	1	26	\N	26	\N	\N	0	1	2	f	\N	152	\N
1627	343	180	1	22	\N	22	\N	\N	0	1	2	f	\N	343	\N
1628	254	180	1	21	\N	21	\N	\N	0	1	2	f	\N	254	\N
1629	269	180	1	20	\N	20	\N	\N	0	1	2	f	\N	269	\N
1630	283	180	1	18	\N	18	\N	\N	0	1	2	f	\N	283	\N
1631	158	180	1	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
1632	177	180	1	17	\N	17	\N	\N	0	1	2	f	\N	177	\N
1633	333	180	1	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
1634	117	180	1	15	\N	15	\N	\N	0	1	2	f	\N	117	\N
1635	133	180	1	15	\N	15	\N	\N	0	1	2	f	\N	133	\N
1636	232	180	1	14	\N	14	\N	\N	0	1	2	f	\N	232	\N
1637	6	180	1	11	\N	11	\N	\N	0	1	2	f	\N	6	\N
1638	185	180	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
1639	308	180	1	8	\N	8	\N	\N	0	1	2	f	\N	308	\N
1640	122	180	1	7	\N	7	\N	\N	0	1	2	f	\N	122	\N
1641	279	180	1	7	\N	7	\N	\N	0	1	2	f	\N	279	\N
1642	319	180	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
1643	15	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1644	20	180	1	4	\N	4	\N	\N	0	1	2	f	\N	20	\N
1645	31	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1646	137	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1647	180	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1648	249	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1649	305	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1650	320	180	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1651	132	180	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1652	8	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1653	17	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1654	87	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1655	102	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1656	142	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1657	160	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1658	289	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1659	316	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1660	342	180	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1661	34	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1662	58	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1663	146	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1664	156	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1665	183	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1666	264	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1667	285	180	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1668	22	181	2	4277929	\N	4277929	\N	\N	1	1	2	f	0	354	\N
1669	238	181	2	506264	\N	506264	\N	\N	0	1	2	f	0	\N	\N
1670	172	181	2	275288	\N	275288	\N	\N	0	1	2	f	0	\N	\N
1671	359	181	2	165851	\N	165851	\N	\N	0	1	2	f	0	\N	\N
1672	144	181	2	93646	\N	93646	\N	\N	0	1	2	f	0	\N	\N
1673	256	181	2	90391	\N	90391	\N	\N	0	1	2	f	0	\N	\N
1674	161	181	2	80673	\N	80673	\N	\N	0	1	2	f	0	\N	\N
1675	216	181	2	73801	\N	73801	\N	\N	0	1	2	f	0	\N	\N
1676	145	181	2	44485	\N	44485	\N	\N	0	1	2	f	0	\N	\N
1677	166	181	2	41983	\N	41983	\N	\N	0	1	2	f	0	\N	\N
1678	291	181	2	34675	\N	34675	\N	\N	0	1	2	f	0	\N	\N
1679	119	181	2	33735	\N	33735	\N	\N	0	1	2	f	0	\N	\N
1680	315	181	2	26913	\N	26913	\N	\N	0	1	2	f	0	\N	\N
1681	271	181	2	21935	\N	21935	\N	\N	0	1	2	f	0	\N	\N
1682	16	181	2	19345	\N	19345	\N	\N	0	1	2	f	0	354	\N
1683	214	181	2	19340	\N	19340	\N	\N	0	1	2	f	0	354	\N
1684	272	181	2	17338	\N	17338	\N	\N	0	1	2	f	0	\N	\N
1685	175	181	2	17164	\N	17164	\N	\N	0	1	2	f	0	354	\N
1686	72	181	2	16761	\N	16761	\N	\N	0	1	2	f	0	\N	\N
1687	265	181	2	14504	\N	14504	\N	\N	0	1	2	f	0	354	\N
1688	346	181	2	13216	\N	13216	\N	\N	0	1	2	f	0	\N	\N
1689	164	181	2	13209	\N	13209	\N	\N	0	1	2	f	0	354	\N
1690	123	181	2	13009	\N	13009	\N	\N	0	1	2	f	0	\N	\N
1691	335	181	2	11871	\N	11871	\N	\N	0	1	2	f	0	\N	\N
1692	90	181	2	10640	\N	10640	\N	\N	0	1	2	f	0	354	\N
1693	328	181	2	10131	\N	10131	\N	\N	0	1	2	f	0	\N	\N
1694	192	181	2	10030	\N	10030	\N	\N	0	1	2	f	0	\N	\N
1695	186	181	2	8442	\N	8442	\N	\N	0	1	2	f	0	\N	\N
1696	77	181	2	7955	\N	7955	\N	\N	0	1	2	f	0	354	\N
1697	348	181	2	7912	\N	7912	\N	\N	0	1	2	f	0	\N	\N
1698	350	181	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
1699	184	181	2	7368	\N	7368	\N	\N	0	1	2	f	0	354	\N
1700	339	181	2	7368	\N	7368	\N	\N	0	1	2	f	0	354	\N
1701	298	181	2	7262	\N	7262	\N	\N	0	1	2	f	0	\N	\N
1702	222	181	2	7222	\N	7222	\N	\N	0	1	2	f	0	\N	\N
1703	205	181	2	7146	\N	7146	\N	\N	0	1	2	f	0	\N	\N
1704	258	181	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
1705	93	181	2	4768	\N	4768	\N	\N	0	1	2	f	0	\N	\N
1706	293	181	2	4632	\N	4632	\N	\N	0	1	2	f	0	\N	\N
1707	282	181	2	4630	\N	4630	\N	\N	0	1	2	f	0	\N	\N
1708	62	181	2	4603	\N	4603	\N	\N	0	1	2	f	0	\N	\N
1709	295	181	2	4526	\N	4526	\N	\N	0	1	2	f	0	\N	\N
1710	167	181	2	4512	\N	4512	\N	\N	0	1	2	f	0	\N	\N
1711	245	181	2	3546	\N	3546	\N	\N	0	1	2	f	0	\N	\N
1712	154	181	2	3499	\N	3499	\N	\N	0	1	2	f	0	\N	\N
1713	309	181	2	2925	\N	2925	\N	\N	0	1	2	f	0	354	\N
1714	213	181	2	2734	\N	2734	\N	\N	0	1	2	f	0	\N	\N
1715	134	181	2	2653	\N	2653	\N	\N	0	1	2	f	0	\N	\N
1716	35	181	2	2578	\N	2578	\N	\N	0	1	2	f	0	\N	\N
1717	105	181	2	2467	\N	2467	\N	\N	0	1	2	f	0	\N	\N
1718	170	181	2	2467	\N	2467	\N	\N	0	1	2	f	0	354	\N
1719	9	181	2	2373	\N	2373	\N	\N	0	1	2	f	0	\N	\N
1720	301	181	2	2225	\N	2225	\N	\N	0	1	2	f	0	\N	\N
1721	358	181	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
1722	149	181	2	1992	\N	1992	\N	\N	0	1	2	f	0	\N	\N
1723	143	181	2	1962	\N	1962	\N	\N	0	1	2	f	0	354	\N
1724	85	181	2	1751	\N	1751	\N	\N	0	1	2	f	0	\N	\N
1725	332	181	2	1714	\N	1714	\N	\N	0	1	2	f	0	354	\N
1726	147	181	2	1521	\N	1521	\N	\N	0	1	2	f	0	\N	\N
1727	215	181	2	1484	\N	1484	\N	\N	0	1	2	f	0	354	\N
1728	210	181	2	1418	\N	1418	\N	\N	0	1	2	f	0	\N	\N
1729	118	181	2	1368	\N	1368	\N	\N	0	1	2	f	0	\N	\N
1730	287	181	2	1367	\N	1367	\N	\N	0	1	2	f	0	354	\N
1731	311	181	2	1345	\N	1345	\N	\N	0	1	2	f	0	\N	\N
1732	261	181	2	1336	\N	1336	\N	\N	0	1	2	f	0	\N	\N
1733	322	181	2	1326	\N	1326	\N	\N	0	1	2	f	0	\N	\N
1734	268	181	2	1232	\N	1232	\N	\N	0	1	2	f	0	\N	\N
1735	42	181	2	1147	\N	1147	\N	\N	0	1	2	f	0	\N	\N
1736	217	181	2	1146	\N	1146	\N	\N	0	1	2	f	0	\N	\N
1737	310	181	2	1145	\N	1145	\N	\N	0	1	2	f	0	354	\N
1738	306	181	2	1143	\N	1143	\N	\N	0	1	2	f	0	\N	\N
1739	107	181	2	1142	\N	1142	\N	\N	0	1	2	f	0	\N	\N
1740	116	181	2	1119	\N	1119	\N	\N	0	1	2	f	0	354	\N
1741	193	181	2	1115	\N	1115	\N	\N	0	1	2	f	0	\N	\N
1742	198	181	2	1111	\N	1111	\N	\N	0	1	2	f	0	\N	\N
1743	28	181	2	1107	\N	1107	\N	\N	0	1	2	f	0	\N	\N
1744	45	181	2	1099	\N	1099	\N	\N	0	1	2	f	0	\N	\N
1745	353	181	2	1092	\N	1092	\N	\N	0	1	2	f	0	\N	\N
1746	51	181	2	1091	\N	1091	\N	\N	0	1	2	f	0	\N	\N
1747	71	181	2	1086	\N	1086	\N	\N	0	1	2	f	0	\N	\N
1748	131	181	2	985	\N	985	\N	\N	0	1	2	f	0	\N	\N
1749	1	181	2	958	\N	958	\N	\N	0	1	2	f	0	\N	\N
1750	248	181	2	957	\N	957	\N	\N	0	1	2	f	0	\N	\N
1751	148	181	2	942	\N	942	\N	\N	0	1	2	f	0	354	\N
1752	351	181	2	931	\N	931	\N	\N	0	1	2	f	0	\N	\N
1753	241	181	2	911	\N	911	\N	\N	0	1	2	f	0	\N	\N
1754	115	181	2	896	\N	896	\N	\N	0	1	2	f	0	\N	\N
1755	41	181	2	853	\N	853	\N	\N	0	1	2	f	0	\N	\N
1756	126	181	2	818	\N	818	\N	\N	0	1	2	f	0	\N	\N
1757	352	181	2	807	\N	807	\N	\N	0	1	2	f	0	\N	\N
1758	347	181	2	795	\N	795	\N	\N	0	1	2	f	0	\N	\N
1759	195	181	2	743	\N	743	\N	\N	0	1	2	f	0	354	\N
1760	66	181	2	736	\N	736	\N	\N	0	1	2	f	0	\N	\N
1761	317	181	2	734	\N	734	\N	\N	0	1	2	f	0	354	\N
1762	270	181	2	733	\N	733	\N	\N	0	1	2	f	0	\N	\N
1763	47	181	2	723	\N	723	\N	\N	0	1	2	f	0	\N	\N
1764	201	181	2	694	\N	694	\N	\N	0	1	2	f	0	\N	\N
1765	242	181	2	685	\N	685	\N	\N	0	1	2	f	0	\N	\N
1766	92	181	2	643	\N	643	\N	\N	0	1	2	f	0	\N	\N
1767	127	181	2	641	\N	641	\N	\N	0	1	2	f	0	\N	\N
1768	38	181	2	639	\N	639	\N	\N	0	1	2	f	0	354	\N
1769	103	181	2	619	\N	619	\N	\N	0	1	2	f	0	\N	\N
1770	336	181	2	598	\N	598	\N	\N	0	1	2	f	0	\N	\N
1771	94	181	2	575	\N	575	\N	\N	0	1	2	f	0	\N	\N
1772	326	181	2	570	\N	570	\N	\N	0	1	2	f	0	354	\N
1773	267	181	2	568	\N	568	\N	\N	0	1	2	f	0	354	\N
1774	19	181	2	549	\N	549	\N	\N	0	1	2	f	0	\N	\N
1775	176	181	2	543	\N	543	\N	\N	0	1	2	f	0	\N	\N
1776	140	181	2	502	\N	502	\N	\N	0	1	2	f	0	\N	\N
1777	356	181	2	489	\N	489	\N	\N	0	1	2	f	0	\N	\N
1778	218	181	2	483	\N	483	\N	\N	0	1	2	f	0	354	\N
1779	81	181	2	474	\N	474	\N	\N	0	1	2	f	0	\N	\N
1780	327	181	2	468	\N	468	\N	\N	0	1	2	f	0	354	\N
1781	228	181	2	463	\N	463	\N	\N	0	1	2	f	0	\N	\N
1782	48	181	2	449	\N	449	\N	\N	0	1	2	f	0	354	\N
1783	219	181	2	444	\N	444	\N	\N	0	1	2	f	0	354	\N
1784	277	181	2	412	\N	412	\N	\N	0	1	2	f	0	\N	\N
1785	174	181	2	409	\N	409	\N	\N	0	1	2	f	0	354	\N
1786	314	181	2	405	\N	405	\N	\N	0	1	2	f	0	\N	\N
1787	113	181	2	392	\N	392	\N	\N	0	1	2	f	0	354	\N
1788	10	181	2	390	\N	390	\N	\N	0	1	2	f	0	354	\N
1789	354	181	2	367	\N	367	\N	\N	0	1	2	f	0	\N	\N
1790	52	181	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
1791	189	181	2	352	\N	352	\N	\N	0	1	2	f	0	354	\N
1792	64	181	2	315	\N	315	\N	\N	0	1	2	f	0	354	\N
1793	297	181	2	308	\N	308	\N	\N	0	1	2	f	0	\N	\N
1794	280	181	2	306	\N	306	\N	\N	0	1	2	f	0	\N	\N
1795	286	181	2	304	\N	304	\N	\N	0	1	2	f	0	\N	\N
1796	266	181	2	298	\N	298	\N	\N	0	1	2	f	0	\N	\N
1797	202	181	2	292	\N	292	\N	\N	0	1	2	f	0	\N	\N
1798	227	181	2	287	\N	287	\N	\N	0	1	2	f	0	354	\N
1799	296	181	2	287	\N	287	\N	\N	0	1	2	f	0	\N	\N
1800	46	181	2	262	\N	262	\N	\N	0	1	2	f	0	\N	\N
1801	299	181	2	254	\N	254	\N	\N	0	1	2	f	0	\N	\N
1802	292	181	2	250	\N	250	\N	\N	0	1	2	f	0	\N	\N
1803	221	181	2	248	\N	248	\N	\N	0	1	2	f	0	354	\N
1804	112	181	2	240	\N	240	\N	\N	0	1	2	f	0	354	\N
1805	188	181	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
1806	240	181	2	212	\N	212	\N	\N	0	1	2	f	0	354	\N
1807	262	181	2	210	\N	210	\N	\N	0	1	2	f	0	\N	\N
1808	89	181	2	204	\N	204	\N	\N	0	1	2	f	0	\N	\N
1809	109	181	2	190	\N	190	\N	\N	0	1	2	f	0	\N	\N
1810	14	181	2	189	\N	189	\N	\N	0	1	2	f	0	\N	\N
1811	250	181	2	187	\N	187	\N	\N	0	1	2	f	0	\N	\N
1812	55	181	2	185	\N	185	\N	\N	0	1	2	f	0	\N	\N
1813	44	181	2	180	\N	180	\N	\N	0	1	2	f	0	\N	\N
1814	209	181	2	169	\N	169	\N	\N	0	1	2	f	0	\N	\N
1815	49	181	2	164	\N	164	\N	\N	0	1	2	f	0	354	\N
1816	255	181	2	163	\N	163	\N	\N	0	1	2	f	0	\N	\N
1817	313	181	2	158	\N	158	\N	\N	0	1	2	f	0	\N	\N
1818	65	181	2	154	\N	154	\N	\N	0	1	2	f	0	\N	\N
1819	225	181	2	145	\N	145	\N	\N	0	1	2	f	0	354	\N
1820	223	181	2	144	\N	144	\N	\N	0	1	2	f	0	\N	\N
1821	257	181	2	144	\N	144	\N	\N	0	1	2	f	0	\N	\N
1822	95	181	2	140	\N	140	\N	\N	0	1	2	f	0	\N	\N
1823	163	181	2	140	\N	140	\N	\N	0	1	2	f	0	\N	\N
1824	27	181	2	131	\N	131	\N	\N	0	1	2	f	0	354	\N
1825	200	181	2	127	\N	127	\N	\N	0	1	2	f	0	354	\N
1826	226	181	2	125	\N	125	\N	\N	0	1	2	f	0	\N	\N
1827	37	181	2	122	\N	122	\N	\N	0	1	2	f	0	354	\N
1828	53	181	2	121	\N	121	\N	\N	0	1	2	f	0	354	\N
1829	274	181	2	121	\N	121	\N	\N	0	1	2	f	0	354	\N
1830	136	181	2	119	\N	119	\N	\N	0	1	2	f	0	354	\N
1831	86	181	2	118	\N	118	\N	\N	0	1	2	f	0	\N	\N
1832	153	181	2	114	\N	114	\N	\N	0	1	2	f	0	\N	\N
1833	26	181	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
1834	159	181	2	113	\N	113	\N	\N	0	1	2	f	0	354	\N
1835	247	181	2	110	\N	110	\N	\N	0	1	2	f	0	\N	\N
1836	76	181	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
1837	169	181	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
1838	341	181	2	103	\N	103	\N	\N	0	1	2	f	0	\N	\N
1839	78	181	2	102	\N	102	\N	\N	0	1	2	f	0	354	\N
1840	104	181	2	102	\N	102	\N	\N	0	1	2	f	0	\N	\N
1841	220	181	2	102	\N	102	\N	\N	0	1	2	f	0	354	\N
1842	97	181	2	100	\N	100	\N	\N	0	1	2	f	0	\N	\N
1843	360	181	2	100	\N	100	\N	\N	0	1	2	f	0	354	\N
1844	196	181	2	99	\N	99	\N	\N	0	1	2	f	0	354	\N
1845	130	181	2	98	\N	98	\N	\N	0	1	2	f	0	\N	\N
1846	135	181	2	98	\N	98	\N	\N	0	1	2	f	0	\N	\N
1847	300	181	2	98	\N	98	\N	\N	0	1	2	f	0	354	\N
1848	212	181	2	97	\N	97	\N	\N	0	1	2	f	0	354	\N
1849	82	181	2	96	\N	96	\N	\N	0	1	2	f	0	354	\N
1850	151	181	2	93	\N	93	\N	\N	0	1	2	f	0	\N	\N
1851	232	181	2	92	\N	92	\N	\N	0	1	2	f	0	\N	\N
1852	139	181	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
1853	344	181	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
1854	74	181	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
1855	244	181	2	89	\N	89	\N	\N	0	1	2	f	0	354	\N
1856	278	181	2	89	\N	89	\N	\N	0	1	2	f	0	354	\N
1857	273	181	2	86	\N	86	\N	\N	0	1	2	f	0	\N	\N
1858	338	181	2	86	\N	86	\N	\N	0	1	2	f	0	\N	\N
1859	263	181	2	82	\N	82	\N	\N	0	1	2	f	0	\N	\N
1860	288	181	2	82	\N	82	\N	\N	0	1	2	f	0	\N	\N
1861	321	181	2	82	\N	82	\N	\N	0	1	2	f	0	\N	\N
1862	125	181	2	81	\N	81	\N	\N	0	1	2	f	0	\N	\N
1863	203	181	2	81	\N	81	\N	\N	0	1	2	f	0	354	\N
1864	323	181	2	81	\N	81	\N	\N	0	1	2	f	0	\N	\N
1865	231	181	2	79	\N	79	\N	\N	0	1	2	f	0	\N	\N
1866	57	181	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
1867	13	181	2	72	\N	72	\N	\N	0	1	2	f	0	\N	\N
1868	243	181	2	69	\N	69	\N	\N	0	1	2	f	0	\N	\N
1869	246	181	2	69	\N	69	\N	\N	0	1	2	f	0	354	\N
1870	100	181	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
1871	294	181	2	68	\N	68	\N	\N	0	1	2	f	0	354	\N
1872	355	181	2	64	\N	64	\N	\N	0	1	2	f	0	354	\N
1873	61	181	2	62	\N	62	\N	\N	0	1	2	f	0	\N	\N
1874	2	181	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1875	24	181	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1876	337	181	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1877	181	181	2	59	\N	59	\N	\N	0	1	2	f	0	354	\N
1878	7	181	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
1879	30	181	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
1880	121	181	2	57	\N	57	\N	\N	0	1	2	f	0	\N	\N
1881	224	181	2	57	\N	57	\N	\N	0	1	2	f	0	\N	\N
1882	54	181	2	55	\N	55	\N	\N	0	1	2	f	0	\N	\N
1883	124	181	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
1884	329	181	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
1885	191	181	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1886	234	181	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1887	40	181	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
1888	207	181	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
1889	138	181	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
1890	29	181	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
1891	69	181	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
1892	197	181	2	43	\N	43	\N	\N	0	1	2	f	0	354	\N
1893	259	181	2	43	\N	43	\N	\N	0	1	2	f	0	354	\N
1894	284	181	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1895	318	181	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1896	18	181	2	39	\N	39	\N	\N	0	1	2	f	0	354	\N
1897	275	181	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
1898	345	181	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
1899	281	181	2	36	\N	36	\N	\N	0	1	2	f	0	354	\N
1900	5	181	2	34	\N	34	\N	\N	0	1	2	f	0	354	\N
1901	106	181	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1902	331	181	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1903	128	181	2	33	\N	33	\N	\N	0	1	2	f	0	354	\N
1904	21	181	2	29	\N	29	\N	\N	0	1	2	f	0	354	\N
1905	98	181	2	29	\N	29	\N	\N	0	1	2	f	0	354	\N
1906	235	181	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
1907	304	181	2	28	\N	28	\N	\N	0	1	2	f	0	354	\N
1908	60	181	2	27	\N	27	\N	\N	0	1	2	f	0	354	\N
1909	165	181	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1910	120	181	2	26	\N	26	\N	\N	0	1	2	f	0	354	\N
1911	307	181	2	26	\N	26	\N	\N	0	1	2	f	0	354	\N
1912	50	181	2	24	\N	24	\N	\N	0	1	2	f	0	354	\N
1913	199	181	2	24	\N	24	\N	\N	0	1	2	f	0	354	\N
1914	211	181	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1915	253	181	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
1916	39	181	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1917	168	181	2	21	\N	21	\N	\N	0	1	2	f	0	354	\N
1918	333	181	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1919	101	181	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1920	152	181	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1921	158	181	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1922	269	181	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
1923	230	181	2	18	\N	18	\N	\N	0	1	2	f	0	354	\N
1924	4	181	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1925	155	181	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1926	343	181	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1927	32	181	2	15	\N	15	\N	\N	0	1	2	f	0	354	\N
1928	129	181	2	15	\N	15	\N	\N	0	1	2	f	0	354	\N
1929	233	181	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1930	33	181	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1931	96	181	2	14	\N	14	\N	\N	0	1	2	f	0	354	\N
1932	177	181	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1933	276	181	2	14	\N	14	\N	\N	0	1	2	f	0	354	\N
1934	91	181	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1935	254	181	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1936	357	181	2	13	\N	13	\N	\N	0	1	2	f	0	354	\N
1937	11	181	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1938	283	181	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1939	117	181	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
1940	114	181	2	10	\N	10	\N	\N	0	1	2	f	0	354	\N
1941	239	181	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1942	302	181	2	10	\N	10	\N	\N	0	1	2	f	0	354	\N
1943	325	181	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1944	12	181	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1945	133	181	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1946	185	181	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1947	190	181	2	9	\N	9	\N	\N	0	1	2	f	0	354	\N
1948	56	181	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1949	68	181	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1950	108	181	2	8	\N	8	\N	\N	0	1	2	f	0	354	\N
1951	141	181	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1952	162	181	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1953	251	181	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1954	6	181	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1955	171	181	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1956	260	181	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1957	303	181	2	7	\N	7	\N	\N	0	1	2	f	0	354	\N
1958	20	181	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1959	63	181	2	6	\N	6	\N	\N	0	1	2	f	0	354	\N
1960	75	181	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1961	308	181	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1962	319	181	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1963	73	181	2	5	\N	5	\N	\N	0	1	2	f	0	354	\N
1964	194	181	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1965	208	181	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1966	249	181	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1967	349	181	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1968	15	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1969	31	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1970	122	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1971	137	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1972	180	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1973	305	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1974	312	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1975	320	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1976	324	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1977	334	181	2	4	\N	4	\N	\N	0	1	2	f	0	354	\N
1978	340	181	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1979	3	181	2	3	\N	3	\N	\N	0	1	2	f	0	354	\N
1980	25	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1981	43	181	2	3	\N	3	\N	\N	0	1	2	f	0	354	\N
1982	80	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1983	132	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1984	179	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1985	279	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1986	290	181	2	3	\N	3	\N	\N	0	1	2	f	0	354	\N
1987	316	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1988	330	181	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1989	8	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1990	17	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1991	59	181	2	2	\N	2	\N	\N	0	1	2	f	0	354	\N
1992	70	181	2	2	\N	2	\N	\N	0	1	2	f	0	354	\N
1993	79	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1994	87	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1995	99	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1996	102	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1997	111	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1998	142	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1999	146	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2000	160	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2001	173	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2002	183	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2003	187	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2004	204	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2005	229	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2006	236	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2007	237	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2008	289	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2009	342	181	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2010	23	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2011	34	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2012	36	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2013	58	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2014	67	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2015	83	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2016	84	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2017	88	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2018	110	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2019	150	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2020	156	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2021	157	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2022	178	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2023	182	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2024	206	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2025	252	181	2	1	\N	1	\N	\N	0	1	2	f	0	354	\N
2026	264	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2027	285	181	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2028	354	181	1	4380069	\N	4380069	\N	\N	1	1	2	f	\N	22	\N
2029	288	182	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2030	94	183	2	1150	\N	1150	\N	\N	1	1	2	f	0	219	\N
2031	219	183	1	938	\N	938	\N	\N	1	1	2	f	\N	94	\N
2032	357	183	1	575	\N	575	\N	\N	0	1	2	f	\N	94	\N
2033	294	183	1	408	\N	408	\N	\N	0	1	2	f	\N	94	\N
2034	216	184	2	73801	\N	73801	\N	\N	1	1	2	f	0	\N	\N
2035	346	184	2	13216	\N	13216	\N	\N	0	1	2	f	0	\N	\N
2036	350	184	2	7411	\N	7411	\N	\N	0	1	2	f	0	\N	\N
2037	258	184	2	5269	\N	5269	\N	\N	0	1	2	f	0	\N	\N
2038	358	184	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
2039	71	184	2	1086	\N	1086	\N	\N	0	1	2	f	0	\N	\N
2040	207	184	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
2041	331	184	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
2042	165	184	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2043	208	185	2	8	\N	8	\N	\N	1	1	2	f	0	208	\N
2044	208	185	1	4	\N	4	\N	\N	1	1	2	f	\N	208	\N
2045	175	186	2	4185464	\N	4185464	\N	\N	1	1	2	f	0	22	\N
2046	219	186	2	29288	\N	29288	\N	\N	0	1	2	f	0	164	\N
2047	97	186	2	23184	\N	23184	\N	\N	0	1	2	f	0	22	\N
2048	294	186	2	3820	\N	3820	\N	\N	0	1	2	f	0	164	\N
2049	22	186	1	4208648	\N	4208648	\N	\N	1	1	2	f	\N	175	\N
2050	164	186	1	16304	\N	16304	\N	\N	0	1	2	f	\N	219	\N
2051	219	186	1	293	\N	293	\N	\N	0	1	2	f	\N	294	\N
2052	236	187	2	2	\N	2	\N	\N	1	1	2	f	0	251	\N
2053	251	187	1	2	\N	2	\N	\N	1	1	2	f	\N	236	\N
2054	251	188	2	8	\N	8	\N	\N	1	1	2	f	0	288	\N
2055	288	188	1	8	\N	8	\N	\N	1	1	2	f	\N	251	\N
2056	192	189	2	10030	\N	0	\N	\N	1	1	2	f	10030	\N	\N
2057	198	189	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
2058	138	189	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
2059	288	190	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2060	24	191	2	60	\N	0	\N	\N	1	1	2	f	60	\N	\N
2061	313	191	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2062	277	191	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2063	288	192	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
2064	263	193	2	3	\N	3	\N	\N	1	1	2	f	0	288	\N
2065	288	193	1	3	\N	3	\N	\N	1	1	2	f	\N	263	\N
2066	263	194	2	10	\N	10	\N	\N	1	1	2	f	0	288	\N
2067	288	194	1	10	\N	10	\N	\N	1	1	2	f	\N	263	\N
2068	263	195	2	3	\N	3	\N	\N	1	1	2	f	0	288	\N
2069	288	195	1	3	\N	3	\N	\N	1	1	2	f	\N	263	\N
2150	245	211	2	3546	\N	0	\N	\N	0	1	2	f	3546	\N	\N
2070	164	196	2	16712	\N	16712	\N	\N	1	1	2	f	0	219	\N
2071	219	196	2	293	\N	293	\N	\N	0	1	2	f	0	294	\N
2072	219	196	1	29589	\N	29589	\N	\N	1	1	2	f	\N	164	\N
2073	294	196	1	3922	\N	3922	\N	\N	0	1	2	f	\N	164	\N
2074	263	197	2	46	\N	46	\N	\N	1	1	2	f	0	288	\N
2075	56	197	2	8	\N	8	\N	\N	0	1	2	f	0	141	\N
2076	187	197	2	2	\N	2	\N	\N	0	1	2	f	0	173	\N
2077	288	197	1	46	\N	46	\N	\N	1	1	2	f	\N	263	\N
2078	141	197	1	8	\N	8	\N	\N	0	1	2	f	\N	56	\N
2079	173	197	1	2	\N	2	\N	\N	0	1	2	f	\N	187	\N
2080	288	198	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
2081	263	199	2	13	\N	13	\N	\N	1	1	2	f	0	288	\N
2082	288	199	1	13	\N	13	\N	\N	1	1	2	f	\N	263	\N
2083	72	200	2	16480	\N	0	\N	\N	1	1	2	f	16480	\N	\N
2084	123	200	2	13008	\N	0	\N	\N	0	1	2	f	13008	\N	\N
2085	222	200	2	7222	\N	0	\N	\N	0	1	2	f	7222	\N	\N
2086	105	200	2	2464	\N	0	\N	\N	0	1	2	f	2464	\N	\N
2087	149	200	2	1992	\N	0	\N	\N	0	1	2	f	1992	\N	\N
2088	45	200	2	1094	\N	0	\N	\N	0	1	2	f	1094	\N	\N
2089	351	200	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
2090	126	200	2	818	\N	0	\N	\N	0	1	2	f	818	\N	\N
2091	201	200	2	694	\N	0	\N	\N	0	1	2	f	694	\N	\N
2092	81	200	2	474	\N	0	\N	\N	0	1	2	f	474	\N	\N
2093	95	200	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
2094	26	200	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
2095	2	200	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
2096	121	200	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
2097	318	200	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
2098	297	201	2	85	\N	0	\N	\N	1	1	2	f	85	\N	\N
2099	167	202	2	872	\N	0	\N	\N	1	1	2	f	872	\N	\N
2100	71	202	2	322	\N	0	\N	\N	0	1	2	f	322	\N	\N
2101	22	203	2	4277929	\N	0	\N	\N	1	1	2	f	4277929	\N	\N
2102	192	203	2	10030	\N	0	\N	\N	0	1	2	f	10030	\N	\N
2103	198	203	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
2104	138	203	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
2105	288	204	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2106	288	205	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
2107	161	206	2	80673	\N	80673	\N	\N	1	1	2	f	0	\N	\N
2108	77	207	2	328	\N	328	\N	\N	1	1	2	f	0	77	\N
2109	77	207	1	329	\N	329	\N	\N	1	1	2	f	\N	77	\N
2110	245	208	2	3546	\N	3546	\N	\N	1	1	2	f	0	\N	\N
2111	322	208	2	1326	\N	1326	\N	\N	0	1	2	f	0	\N	\N
2112	14	209	2	189	\N	189	\N	\N	1	1	2	f	0	329	\N
2113	329	209	1	187	\N	187	\N	\N	1	1	2	f	\N	14	\N
2114	79	209	1	2	\N	2	\N	\N	0	1	2	f	\N	14	\N
2115	231	209	1	2	\N	2	\N	\N	0	1	2	f	\N	14	\N
2116	14	210	2	61	\N	61	\N	\N	1	1	2	f	0	354	\N
2117	354	210	1	61	\N	61	\N	\N	1	1	2	f	\N	14	\N
2118	359	211	2	165851	\N	0	\N	\N	1	1	2	f	165851	\N	\N
2119	144	211	2	93646	\N	0	\N	\N	0	1	2	f	93646	\N	\N
2120	161	211	2	80673	\N	0	\N	\N	0	1	2	f	80673	\N	\N
2121	216	211	2	73801	\N	0	\N	\N	0	1	2	f	73801	\N	\N
2122	145	211	2	44485	\N	0	\N	\N	0	1	2	f	44485	\N	\N
2123	166	211	2	41983	\N	0	\N	\N	0	1	2	f	41983	\N	\N
2124	291	211	2	34675	\N	0	\N	\N	0	1	2	f	34675	\N	\N
2125	119	211	2	33735	\N	0	\N	\N	0	1	2	f	33735	\N	\N
2126	315	211	2	26913	\N	0	\N	\N	0	1	2	f	26913	\N	\N
2127	271	211	2	21935	\N	0	\N	\N	0	1	2	f	21935	\N	\N
2128	272	211	2	17338	\N	0	\N	\N	0	1	2	f	17338	\N	\N
2129	72	211	2	16900	\N	0	\N	\N	0	1	2	f	16900	\N	\N
2130	346	211	2	13216	\N	0	\N	\N	0	1	2	f	13216	\N	\N
2131	123	211	2	13009	\N	0	\N	\N	0	1	2	f	13009	\N	\N
2132	335	211	2	11871	\N	0	\N	\N	0	1	2	f	11871	\N	\N
2133	328	211	2	10131	\N	0	\N	\N	0	1	2	f	10131	\N	\N
2134	192	211	2	10030	\N	0	\N	\N	0	1	2	f	10030	\N	\N
2135	16	211	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
2136	214	211	2	9670	\N	0	\N	\N	0	1	2	f	9670	\N	\N
2137	186	211	2	8442	\N	0	\N	\N	0	1	2	f	8442	\N	\N
2138	348	211	2	7904	\N	0	\N	\N	0	1	2	f	7904	\N	\N
2139	350	211	2	7375	\N	0	\N	\N	0	1	2	f	7375	\N	\N
2140	298	211	2	7262	\N	0	\N	\N	0	1	2	f	7262	\N	\N
2141	222	211	2	7222	\N	0	\N	\N	0	1	2	f	7222	\N	\N
2142	205	211	2	7146	\N	0	\N	\N	0	1	2	f	7146	\N	\N
2143	258	211	2	5269	\N	0	\N	\N	0	1	2	f	5269	\N	\N
2144	93	211	2	4768	\N	0	\N	\N	0	1	2	f	4768	\N	\N
2145	293	211	2	4639	\N	0	\N	\N	0	1	2	f	4639	\N	\N
2146	282	211	2	4630	\N	0	\N	\N	0	1	2	f	4630	\N	\N
2147	62	211	2	4603	\N	0	\N	\N	0	1	2	f	4603	\N	\N
2148	295	211	2	4526	\N	0	\N	\N	0	1	2	f	4526	\N	\N
2149	167	211	2	4512	\N	0	\N	\N	0	1	2	f	4512	\N	\N
2151	154	211	2	3499	\N	0	\N	\N	0	1	2	f	3499	\N	\N
2152	213	211	2	2733	\N	0	\N	\N	0	1	2	f	2733	\N	\N
2153	35	211	2	2578	\N	0	\N	\N	0	1	2	f	2578	\N	\N
2154	105	211	2	2467	\N	0	\N	\N	0	1	2	f	2467	\N	\N
2155	9	211	2	2373	\N	0	\N	\N	0	1	2	f	2373	\N	\N
2156	358	211	2	2012	\N	0	\N	\N	0	1	2	f	2012	\N	\N
2157	149	211	2	1992	\N	0	\N	\N	0	1	2	f	1992	\N	\N
2158	85	211	2	1751	\N	0	\N	\N	0	1	2	f	1751	\N	\N
2159	147	211	2	1521	\N	0	\N	\N	0	1	2	f	1521	\N	\N
2160	210	211	2	1418	\N	0	\N	\N	0	1	2	f	1418	\N	\N
2161	118	211	2	1368	\N	0	\N	\N	0	1	2	f	1368	\N	\N
2162	311	211	2	1345	\N	0	\N	\N	0	1	2	f	1345	\N	\N
2163	261	211	2	1335	\N	0	\N	\N	0	1	2	f	1335	\N	\N
2164	322	211	2	1326	\N	0	\N	\N	0	1	2	f	1326	\N	\N
2165	268	211	2	1232	\N	0	\N	\N	0	1	2	f	1232	\N	\N
2166	42	211	2	1147	\N	0	\N	\N	0	1	2	f	1147	\N	\N
2167	217	211	2	1146	\N	0	\N	\N	0	1	2	f	1146	\N	\N
2168	306	211	2	1143	\N	0	\N	\N	0	1	2	f	1143	\N	\N
2169	193	211	2	1115	\N	0	\N	\N	0	1	2	f	1115	\N	\N
2170	198	211	2	1111	\N	0	\N	\N	0	1	2	f	1111	\N	\N
2171	28	211	2	1107	\N	0	\N	\N	0	1	2	f	1107	\N	\N
2172	45	211	2	1098	\N	0	\N	\N	0	1	2	f	1098	\N	\N
2173	353	211	2	1092	\N	0	\N	\N	0	1	2	f	1092	\N	\N
2174	51	211	2	1091	\N	0	\N	\N	0	1	2	f	1091	\N	\N
2175	71	211	2	1086	\N	0	\N	\N	0	1	2	f	1086	\N	\N
2176	131	211	2	985	\N	0	\N	\N	0	1	2	f	985	\N	\N
2177	1	211	2	958	\N	0	\N	\N	0	1	2	f	958	\N	\N
2178	248	211	2	956	\N	0	\N	\N	0	1	2	f	956	\N	\N
2179	351	211	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
2180	115	211	2	896	\N	0	\N	\N	0	1	2	f	896	\N	\N
2181	41	211	2	853	\N	0	\N	\N	0	1	2	f	853	\N	\N
2182	126	211	2	818	\N	0	\N	\N	0	1	2	f	818	\N	\N
2183	352	211	2	807	\N	0	\N	\N	0	1	2	f	807	\N	\N
2184	347	211	2	795	\N	0	\N	\N	0	1	2	f	795	\N	\N
2185	66	211	2	736	\N	0	\N	\N	0	1	2	f	736	\N	\N
2186	270	211	2	733	\N	0	\N	\N	0	1	2	f	733	\N	\N
2187	47	211	2	723	\N	0	\N	\N	0	1	2	f	723	\N	\N
2188	201	211	2	694	\N	0	\N	\N	0	1	2	f	694	\N	\N
2189	242	211	2	685	\N	0	\N	\N	0	1	2	f	685	\N	\N
2190	92	211	2	643	\N	0	\N	\N	0	1	2	f	643	\N	\N
2191	103	211	2	619	\N	0	\N	\N	0	1	2	f	619	\N	\N
2192	336	211	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
2193	19	211	2	548	\N	0	\N	\N	0	1	2	f	548	\N	\N
2194	176	211	2	543	\N	0	\N	\N	0	1	2	f	543	\N	\N
2195	140	211	2	502	\N	0	\N	\N	0	1	2	f	502	\N	\N
2196	356	211	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
2197	81	211	2	474	\N	0	\N	\N	0	1	2	f	474	\N	\N
2198	228	211	2	463	\N	0	\N	\N	0	1	2	f	463	\N	\N
2199	277	211	2	412	\N	0	\N	\N	0	1	2	f	412	\N	\N
2200	314	211	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
2201	52	211	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
2202	297	211	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
2203	286	211	2	304	\N	0	\N	\N	0	1	2	f	304	\N	\N
2204	266	211	2	298	\N	0	\N	\N	0	1	2	f	298	\N	\N
2205	202	211	2	292	\N	0	\N	\N	0	1	2	f	292	\N	\N
2206	296	211	2	287	\N	0	\N	\N	0	1	2	f	287	\N	\N
2207	299	211	2	254	\N	0	\N	\N	0	1	2	f	254	\N	\N
2208	292	211	2	250	\N	0	\N	\N	0	1	2	f	250	\N	\N
2209	188	211	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
2210	262	211	2	210	\N	0	\N	\N	0	1	2	f	210	\N	\N
2211	89	211	2	204	\N	0	\N	\N	0	1	2	f	204	\N	\N
2212	109	211	2	190	\N	0	\N	\N	0	1	2	f	190	\N	\N
2213	55	211	2	184	\N	0	\N	\N	0	1	2	f	184	\N	\N
2214	44	211	2	180	\N	0	\N	\N	0	1	2	f	180	\N	\N
2215	209	211	2	169	\N	0	\N	\N	0	1	2	f	169	\N	\N
2216	255	211	2	163	\N	0	\N	\N	0	1	2	f	163	\N	\N
2217	313	211	2	158	\N	0	\N	\N	0	1	2	f	158	\N	\N
2218	65	211	2	154	\N	0	\N	\N	0	1	2	f	154	\N	\N
2219	223	211	2	144	\N	0	\N	\N	0	1	2	f	144	\N	\N
2220	95	211	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
2221	163	211	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
2222	226	211	2	125	\N	0	\N	\N	0	1	2	f	125	\N	\N
2223	86	211	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
2224	26	211	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
2225	247	211	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
2226	76	211	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
2227	169	211	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
2228	104	211	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
2229	130	211	2	98	\N	0	\N	\N	0	1	2	f	98	\N	\N
2230	151	211	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
2231	139	211	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
2232	344	211	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
2233	74	211	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
2234	273	211	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
2235	338	211	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
2236	323	211	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
2237	57	211	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
2238	243	211	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
2239	100	211	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
2240	61	211	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
2241	2	211	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
2242	24	211	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
2243	7	211	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
2244	121	211	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
2245	224	211	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
2246	124	211	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
2247	191	211	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
2248	207	211	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
2249	138	211	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
2250	69	211	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
2251	284	211	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
2252	318	211	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
2253	275	211	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
2254	345	211	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
2255	106	211	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
2256	331	211	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
2257	165	211	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2258	235	211	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2259	39	211	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
2260	155	211	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2261	233	211	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2262	33	211	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
2263	91	211	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2264	11	211	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2265	239	211	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2266	325	211	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2267	12	211	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2268	68	211	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2269	162	211	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2270	260	211	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2271	194	211	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2272	80	211	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2273	330	211	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2274	99	211	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2275	111	211	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2276	204	211	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2277	84	211	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2278	110	211	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2279	150	211	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2280	157	211	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2281	216	212	2	73801	\N	73801	\N	\N	1	1	2	f	\N	\N	\N
2282	258	212	2	5269	\N	5269	\N	\N	0	1	2	f	\N	\N	\N
2283	167	212	2	4512	\N	4512	\N	\N	0	1	2	f	\N	\N	\N
2284	28	212	2	1107	\N	1098	\N	\N	0	1	2	f	9	\N	\N
2285	71	212	2	1086	\N	1086	\N	\N	0	1	2	f	\N	\N	\N
2286	176	212	2	543	\N	543	\N	\N	0	1	2	f	\N	\N	\N
2287	356	212	2	489	\N	489	\N	\N	0	1	2	f	\N	\N	\N
2288	277	212	2	412	\N	412	\N	\N	0	1	2	f	\N	\N	\N
2289	297	212	2	308	\N	300	\N	\N	0	1	2	f	8	\N	\N
2290	273	212	2	86	\N	86	\N	\N	0	1	2	f	\N	\N	\N
2291	57	212	2	74	\N	74	\N	\N	0	1	2	f	\N	\N	\N
2292	204	212	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	15	354	34	\N	1	\N
2	15	14	4	\N	0	\N
3	16	354	34	\N	1	\N
4	17	354	4	\N	1	\N
5	50	236	2	\N	1	\N
6	51	237	2	\N	1	\N
7	53	329	14	\N	1	\N
8	54	231	4	\N	1	\N
9	55	329	14	\N	1	\N
10	56	231	4	\N	1	\N
11	117	36	1	\N	1	\N
12	118	179	1	\N	1	\N
13	130	25	1	\N	1	\N
14	131	312	1	\N	1	\N
15	592	324	1	\N	1	\N
16	592	340	1	\N	0	\N
17	593	312	1	\N	1	\N
18	594	312	1	\N	1	\N
19	609	288	56	\N	1	\N
20	610	288	56	\N	1	\N
21	612	251	2	\N	1	\N
22	613	236	2	\N	1	\N
23	624	179	2	\N	1	\N
24	625	251	2	\N	1	\N
25	626	25	1	\N	1	\N
26	627	25	1	\N	1	\N
27	628	172	686	\N	0	\N
28	628	134	686	\N	1	\N
29	629	134	394	\N	1	\N
30	629	172	394	\N	0	\N
31	630	172	394	\N	0	\N
32	630	134	394	\N	1	\N
33	631	172	273	\N	0	\N
34	631	134	273	\N	1	\N
35	632	134	107	\N	0	\N
36	632	172	153	\N	1	\N
37	633	172	125	\N	0	\N
38	633	134	125	\N	1	\N
39	634	134	104	\N	1	\N
40	634	172	104	\N	0	\N
41	635	172	97	\N	0	\N
42	635	134	97	\N	1	\N
43	636	172	97	\N	0	\N
44	636	134	97	\N	1	\N
45	637	134	85	\N	1	\N
46	637	172	85	\N	0	\N
47	638	134	84	\N	1	\N
48	638	172	84	\N	0	\N
49	639	172	69	\N	0	\N
50	639	134	69	\N	1	\N
51	640	172	63	\N	0	\N
52	640	134	63	\N	1	\N
53	641	134	62	\N	1	\N
54	641	172	62	\N	0	\N
55	642	172	55	\N	0	\N
56	642	134	57	\N	1	\N
57	643	172	50	\N	0	\N
58	643	134	50	\N	1	\N
59	644	172	50	\N	0	\N
60	644	134	50	\N	1	\N
61	645	134	26	\N	1	\N
62	645	172	26	\N	0	\N
63	646	172	24	\N	0	\N
64	646	134	24	\N	1	\N
65	647	134	24	\N	1	\N
66	647	172	24	\N	0	\N
67	648	172	22	\N	0	\N
68	648	134	22	\N	1	\N
69	649	134	21	\N	1	\N
70	649	172	21	\N	0	\N
71	650	134	21	\N	1	\N
72	650	172	21	\N	0	\N
73	651	172	19	\N	0	\N
74	651	134	19	\N	1	\N
75	652	134	18	\N	1	\N
76	652	172	18	\N	0	\N
77	653	134	18	\N	1	\N
78	653	172	18	\N	0	\N
79	654	134	16	\N	1	\N
80	654	172	16	\N	0	\N
81	655	134	15	\N	1	\N
82	655	172	15	\N	0	\N
83	656	134	14	\N	1	\N
84	656	172	12	\N	0	\N
85	657	172	11	\N	0	\N
86	657	134	11	\N	1	\N
87	658	172	10	\N	0	\N
88	658	134	11	\N	1	\N
89	659	134	10	\N	1	\N
90	659	172	9	\N	0	\N
91	660	134	8	\N	1	\N
92	660	172	8	\N	0	\N
93	661	172	7	\N	0	\N
94	661	134	7	\N	1	\N
95	662	134	6	\N	1	\N
96	662	172	6	\N	0	\N
97	663	134	5	\N	1	\N
98	663	172	5	\N	0	\N
99	664	172	5	\N	0	\N
100	664	134	5	\N	1	\N
101	665	172	4	\N	0	\N
102	665	134	4	\N	1	\N
103	666	172	4	\N	0	\N
104	666	134	4	\N	1	\N
105	667	134	4	\N	1	\N
106	667	172	4	\N	0	\N
107	668	172	4	\N	0	\N
108	668	134	4	\N	1	\N
109	669	134	4	\N	1	\N
110	669	172	4	\N	0	\N
111	670	172	4	\N	0	\N
112	670	134	4	\N	1	\N
113	671	134	4	\N	1	\N
114	671	172	4	\N	0	\N
115	672	134	3	\N	1	\N
116	672	172	3	\N	0	\N
117	673	172	3	\N	0	\N
118	673	134	3	\N	1	\N
119	674	172	2	\N	0	\N
120	674	134	2	\N	1	\N
121	675	172	2	\N	0	\N
122	675	134	2	\N	1	\N
123	676	172	2	\N	0	\N
124	676	134	2	\N	1	\N
125	677	172	2	\N	0	\N
126	677	134	2	\N	1	\N
127	678	134	2	\N	1	\N
128	678	172	2	\N	0	\N
129	679	134	2	\N	1	\N
130	679	172	2	\N	0	\N
131	680	134	2	\N	1	\N
132	680	172	2	\N	0	\N
133	681	172	2	\N	0	\N
134	681	134	2	\N	1	\N
135	682	134	2	\N	1	\N
136	682	172	2	\N	0	\N
137	683	134	2	\N	1	\N
138	683	172	2	\N	0	\N
139	684	172	1	\N	0	\N
140	684	134	1	\N	1	\N
141	685	134	1	\N	1	\N
142	685	172	1	\N	0	\N
143	686	172	1	\N	0	\N
144	686	134	1	\N	1	\N
145	687	172	1	\N	0	\N
146	687	134	1	\N	1	\N
147	688	134	1	\N	1	\N
148	688	172	1	\N	0	\N
149	689	15	4	\N	0	\N
150	689	29	50	\N	0	\N
151	689	133	11	\N	0	\N
152	689	13	97	\N	0	\N
153	689	183	2	\N	0	\N
154	689	40	69	\N	0	\N
155	689	46	273	\N	0	\N
156	689	102	2	\N	0	\N
157	689	17	2	\N	0	\N
158	689	4	24	\N	0	\N
159	689	31	4	\N	0	\N
160	689	127	686	\N	1	\N
161	689	6	8	\N	0	\N
162	689	254	16	\N	0	\N
163	689	316	3	\N	0	\N
164	689	185	9	\N	0	\N
165	689	289	2	\N	0	\N
166	689	34	1	\N	0	\N
167	689	305	4	\N	0	\N
168	689	58	1	\N	0	\N
169	689	280	394	\N	0	\N
170	689	234	50	\N	0	\N
171	689	87	2	\N	0	\N
172	689	158	19	\N	0	\N
173	689	20	7	\N	0	\N
174	689	250	394	\N	0	\N
175	689	156	1	\N	0	\N
176	689	137	4	\N	0	\N
177	689	54	55	\N	0	\N
178	689	257	153	\N	0	\N
179	689	122	5	\N	0	\N
180	689	8	2	\N	0	\N
181	689	264	1	\N	0	\N
182	689	146	2	\N	0	\N
183	689	279	4	\N	0	\N
184	689	319	6	\N	0	\N
185	689	135	125	\N	0	\N
186	689	249	5	\N	0	\N
187	689	337	63	\N	0	\N
188	689	320	4	\N	0	\N
189	689	341	104	\N	0	\N
190	689	117	12	\N	0	\N
191	689	321	84	\N	0	\N
192	689	101	24	\N	0	\N
193	689	232	97	\N	0	\N
194	689	152	22	\N	0	\N
195	689	132	3	\N	0	\N
196	689	180	4	\N	0	\N
197	689	253	26	\N	0	\N
198	689	160	2	\N	0	\N
199	689	283	18	\N	0	\N
200	689	343	18	\N	0	\N
201	689	269	21	\N	0	\N
202	689	177	15	\N	0	\N
203	689	125	85	\N	0	\N
204	689	285	1	\N	0	\N
205	689	308	10	\N	0	\N
206	689	142	2	\N	0	\N
207	689	333	21	\N	0	\N
208	689	342	2	\N	0	\N
209	689	30	62	\N	0	\N
210	690	269	21	\N	0	\N
211	690	132	3	\N	0	\N
212	690	321	84	\N	0	\N
213	690	117	14	\N	0	\N
214	690	320	4	\N	0	\N
215	690	185	10	\N	0	\N
216	690	254	16	\N	0	\N
217	690	333	21	\N	0	\N
218	690	279	4	\N	0	\N
219	690	6	8	\N	0	\N
220	690	30	62	\N	0	\N
221	690	58	1	\N	0	\N
222	690	289	2	\N	0	\N
223	690	285	1	\N	0	\N
224	690	29	50	\N	0	\N
225	690	133	11	\N	0	\N
226	690	31	4	\N	0	\N
227	690	250	394	\N	0	\N
228	690	101	24	\N	0	\N
229	690	122	5	\N	0	\N
230	690	257	107	\N	0	\N
231	690	125	85	\N	0	\N
232	690	137	4	\N	0	\N
233	690	127	686	\N	1	\N
234	690	146	2	\N	0	\N
235	690	4	24	\N	0	\N
236	690	46	273	\N	0	\N
237	690	142	2	\N	0	\N
238	690	319	6	\N	0	\N
239	690	280	394	\N	0	\N
240	690	341	104	\N	0	\N
241	690	342	2	\N	0	\N
242	690	8	2	\N	0	\N
243	690	20	7	\N	0	\N
244	690	156	1	\N	0	\N
245	690	15	4	\N	0	\N
246	690	264	1	\N	0	\N
247	690	177	15	\N	0	\N
248	690	13	97	\N	0	\N
249	690	54	57	\N	0	\N
250	690	102	2	\N	0	\N
251	690	160	2	\N	0	\N
252	690	135	125	\N	0	\N
253	690	234	50	\N	0	\N
254	690	232	97	\N	0	\N
255	690	316	3	\N	0	\N
256	690	283	18	\N	0	\N
257	690	337	63	\N	0	\N
258	690	253	26	\N	0	\N
259	690	87	2	\N	0	\N
260	690	158	19	\N	0	\N
261	690	34	1	\N	0	\N
262	690	249	5	\N	0	\N
263	690	40	69	\N	0	\N
264	690	305	4	\N	0	\N
265	690	343	18	\N	0	\N
266	690	180	4	\N	0	\N
267	690	183	2	\N	0	\N
268	690	152	22	\N	0	\N
269	690	308	11	\N	0	\N
270	690	17	2	\N	0	\N
271	691	25	1	\N	1	\N
272	692	25	1	\N	1	\N
273	698	251	2	\N	1	\N
274	699	236	2	\N	1	\N
275	700	340	2	\N	1	\N
276	700	324	2	\N	0	\N
277	701	25	2	\N	1	\N
278	702	25	2	\N	1	\N
279	723	354	12	\N	1	\N
280	724	354	12	\N	1	\N
281	801	56	8	\N	1	\N
282	802	251	8	\N	1	\N
283	832	354	109	\N	1	\N
284	833	354	48	\N	1	\N
285	834	354	1	\N	1	\N
286	835	329	48	\N	0	\N
287	835	79	1	\N	0	\N
288	835	231	109	\N	1	\N
289	836	179	1	\N	1	\N
290	837	251	1	\N	1	\N
291	840	175	17164	\N	1	\N
292	840	97	100	\N	0	\N
293	840	22	5041	\N	0	\N
294	841	22	22258	\N	1	\N
295	842	22	14944	\N	1	\N
296	843	22	13213	\N	1	\N
297	844	22	4223	\N	1	\N
298	845	22	4223	\N	1	\N
299	846	22	3194	\N	1	\N
300	847	22	2907	\N	1	\N
301	848	22	2049	\N	1	\N
302	849	22	2045	\N	1	\N
303	850	22	1650	\N	1	\N
304	851	22	1565	\N	1	\N
305	852	22	1381	\N	1	\N
306	853	22	1205	\N	1	\N
307	854	22	984	\N	1	\N
308	855	22	829	\N	1	\N
309	856	22	801	\N	1	\N
310	857	22	686	\N	1	\N
311	858	22	670	\N	1	\N
312	859	22	643	\N	1	\N
313	860	22	577	\N	1	\N
314	861	22	507	\N	1	\N
315	862	22	497	\N	1	\N
316	863	22	449	\N	1	\N
317	864	22	447	\N	1	\N
318	865	22	436	\N	1	\N
319	866	22	394	\N	1	\N
320	867	22	394	\N	1	\N
321	868	22	390	\N	1	\N
322	869	22	369	\N	1	\N
323	870	22	369	\N	1	\N
324	871	22	316	\N	1	\N
325	872	22	296	\N	1	\N
326	873	22	289	\N	1	\N
327	874	22	273	\N	1	\N
328	875	22	244	\N	1	\N
329	876	22	239	\N	1	\N
330	877	22	207	\N	1	\N
331	878	22	174	\N	1	\N
332	879	22	153	\N	1	\N
333	880	22	150	\N	1	\N
334	881	22	144	\N	1	\N
335	882	22	138	\N	1	\N
336	883	22	128	\N	1	\N
337	884	22	127	\N	1	\N
338	885	22	125	\N	1	\N
339	886	22	125	\N	1	\N
340	887	22	123	\N	1	\N
341	888	22	122	\N	1	\N
342	889	22	110	\N	1	\N
343	890	22	106	\N	1	\N
344	891	22	105	\N	1	\N
345	892	22	104	\N	1	\N
346	893	22	103	\N	1	\N
347	894	22	101	\N	1	\N
348	895	22	101	\N	1	\N
349	896	22	100	\N	1	\N
350	897	22	97	\N	1	\N
351	898	22	97	\N	1	\N
352	899	22	96	\N	1	\N
353	900	22	89	\N	1	\N
354	901	22	85	\N	1	\N
355	902	22	84	\N	1	\N
356	903	22	84	\N	1	\N
357	904	22	69	\N	1	\N
358	905	22	65	\N	1	\N
359	906	22	63	\N	1	\N
360	907	22	62	\N	1	\N
361	908	22	60	\N	1	\N
362	909	22	55	\N	1	\N
363	910	22	50	\N	1	\N
364	911	22	50	\N	1	\N
365	912	22	45	\N	1	\N
366	913	22	43	\N	1	\N
367	914	22	40	\N	1	\N
368	915	22	38	\N	1	\N
369	916	22	34	\N	1	\N
370	917	22	34	\N	1	\N
371	918	22	33	\N	1	\N
372	919	22	29	\N	1	\N
373	920	22	29	\N	1	\N
374	921	22	29	\N	1	\N
375	922	22	28	\N	1	\N
376	923	22	26	\N	1	\N
377	924	22	26	\N	1	\N
378	925	22	26	\N	1	\N
379	926	22	25	\N	1	\N
380	927	22	24	\N	1	\N
381	928	22	24	\N	1	\N
382	929	22	24	\N	1	\N
383	930	22	24	\N	1	\N
384	931	22	22	\N	1	\N
385	932	22	21	\N	1	\N
386	933	22	21	\N	1	\N
387	934	22	19	\N	1	\N
388	935	22	18	\N	1	\N
389	936	22	18	\N	1	\N
390	937	22	18	\N	1	\N
391	938	22	16	\N	1	\N
392	939	22	16	\N	1	\N
393	940	22	15	\N	1	\N
394	941	22	15	\N	1	\N
395	942	22	14	\N	1	\N
396	943	22	14	\N	1	\N
397	944	22	12	\N	1	\N
398	945	22	11	\N	1	\N
399	946	22	10	\N	1	\N
400	947	22	10	\N	1	\N
401	948	22	10	\N	1	\N
402	949	22	9	\N	1	\N
403	950	22	9	\N	1	\N
404	951	22	9	\N	1	\N
405	952	22	8	\N	1	\N
406	953	22	8	\N	1	\N
407	954	22	7	\N	1	\N
408	955	22	7	\N	1	\N
409	956	22	6	\N	1	\N
410	957	22	6	\N	1	\N
411	958	22	6	\N	1	\N
412	959	22	5	\N	1	\N
413	960	22	5	\N	1	\N
414	961	22	5	\N	1	\N
415	962	22	4	\N	1	\N
416	963	22	4	\N	1	\N
417	964	22	4	\N	1	\N
418	965	22	4	\N	1	\N
419	966	22	4	\N	1	\N
420	967	22	4	\N	1	\N
421	968	22	4	\N	1	\N
422	969	22	3	\N	1	\N
423	970	22	3	\N	1	\N
424	971	22	3	\N	1	\N
425	972	22	3	\N	1	\N
426	973	22	3	\N	1	\N
427	974	22	2	\N	1	\N
428	975	22	2	\N	1	\N
429	976	22	2	\N	1	\N
430	977	22	2	\N	1	\N
431	978	22	2	\N	1	\N
432	979	22	2	\N	1	\N
433	980	22	2	\N	1	\N
434	981	22	2	\N	1	\N
435	982	22	2	\N	1	\N
436	983	22	2	\N	1	\N
437	984	22	2	\N	1	\N
438	985	22	1	\N	1	\N
439	986	22	1	\N	1	\N
440	987	22	1	\N	1	\N
441	988	22	1	\N	1	\N
442	989	22	1	\N	1	\N
443	990	22	1	\N	1	\N
444	991	22	1	\N	1	\N
445	992	22	1	\N	1	\N
446	993	22	1	\N	1	\N
447	994	22	1	\N	1	\N
448	995	22	1	\N	1	\N
449	996	227	289	\N	0	\N
450	996	200	128	\N	0	\N
451	996	189	369	\N	0	\N
452	996	21	29	\N	0	\N
453	996	125	85	\N	0	\N
454	996	32	15	\N	0	\N
455	996	304	29	\N	0	\N
456	996	49	174	\N	0	\N
457	996	87	2	\N	0	\N
458	996	8	2	\N	0	\N
459	996	112	244	\N	0	\N
460	996	333	21	\N	0	\N
461	996	27	144	\N	0	\N
462	996	102	2	\N	0	\N
463	996	142	2	\N	0	\N
464	996	34	1	\N	0	\N
465	996	20	7	\N	0	\N
466	996	279	4	\N	0	\N
467	996	225	150	\N	0	\N
468	996	120	26	\N	0	\N
469	996	170	2907	\N	0	\N
470	996	219	296	\N	0	\N
471	996	334	6	\N	0	\N
472	996	59	2	\N	0	\N
473	996	73	5	\N	0	\N
474	996	341	104	\N	0	\N
475	996	246	105	\N	0	\N
476	996	10	390	\N	0	\N
477	996	16	9	\N	0	\N
478	996	360	100	\N	0	\N
479	996	310	1381	\N	0	\N
480	996	307	26	\N	0	\N
481	996	3	3	\N	0	\N
482	996	321	84	\N	0	\N
483	996	129	16	\N	0	\N
484	996	78	110	\N	0	\N
485	996	290	3	\N	0	\N
486	996	15	4	\N	0	\N
487	996	98	29	\N	0	\N
488	996	53	127	\N	0	\N
489	996	287	1565	\N	0	\N
490	996	285	1	\N	0	\N
491	996	152	22	\N	0	\N
492	996	206	1	\N	0	\N
493	996	253	26	\N	0	\N
494	996	174	447	\N	0	\N
495	996	274	123	\N	0	\N
496	996	158	19	\N	0	\N
497	996	46	273	\N	0	\N
498	996	257	153	\N	0	\N
499	996	337	63	\N	0	\N
500	996	234	50	\N	0	\N
501	996	164	13213	\N	0	\N
502	996	196	103	\N	0	\N
503	996	276	14	\N	0	\N
504	996	250	394	\N	0	\N
505	996	215	1650	\N	0	\N
506	996	38	670	\N	0	\N
507	996	127	686	\N	0	\N
508	996	156	1	\N	0	\N
509	996	218	497	\N	0	\N
510	996	320	4	\N	0	\N
511	996	232	97	\N	0	\N
512	996	280	394	\N	0	\N
513	996	185	9	\N	0	\N
514	996	148	984	\N	0	\N
515	996	108	8	\N	0	\N
516	996	136	122	\N	0	\N
517	996	67	1	\N	0	\N
518	996	252	1	\N	0	\N
519	996	50	25	\N	0	\N
520	996	184	4223	\N	0	\N
521	996	281	38	\N	0	\N
522	996	283	18	\N	0	\N
523	996	43	3	\N	0	\N
524	996	339	4223	\N	0	\N
525	996	114	10	\N	0	\N
526	996	4	24	\N	0	\N
527	996	302	10	\N	0	\N
528	996	64	369	\N	0	\N
529	996	63	6	\N	0	\N
530	996	83	1	\N	0	\N
531	996	181	60	\N	0	\N
532	996	137	4	\N	0	\N
533	996	254	16	\N	0	\N
534	996	244	89	\N	0	\N
535	996	342	2	\N	0	\N
536	996	54	55	\N	0	\N
537	996	327	507	\N	0	\N
538	996	180	4	\N	0	\N
539	996	18	40	\N	0	\N
540	996	294	34	\N	0	\N
541	996	31	4	\N	0	\N
542	996	6	8	\N	0	\N
543	996	30	62	\N	0	\N
544	996	90	14944	\N	0	\N
545	996	29	50	\N	0	\N
546	996	300	101	\N	0	\N
547	996	5	34	\N	0	\N
548	996	132	3	\N	0	\N
549	996	240	239	\N	0	\N
550	996	113	436	\N	0	\N
551	996	117	12	\N	0	\N
552	996	159	207	\N	0	\N
553	996	289	2	\N	0	\N
554	996	183	2	\N	0	\N
555	996	332	2045	\N	0	\N
556	996	101	24	\N	0	\N
557	996	58	1	\N	0	\N
558	996	40	69	\N	0	\N
559	996	195	801	\N	0	\N
560	996	177	15	\N	0	\N
561	996	326	577	\N	0	\N
562	996	199	24	\N	0	\N
563	996	96	14	\N	0	\N
564	996	278	106	\N	0	\N
565	996	60	28	\N	0	\N
566	996	212	101	\N	0	\N
567	996	230	18	\N	0	\N
568	996	203	84	\N	0	\N
569	996	146	2	\N	0	\N
570	996	220	138	\N	0	\N
571	996	48	449	\N	0	\N
572	996	249	5	\N	0	\N
573	996	135	125	\N	0	\N
574	996	309	3194	\N	0	\N
575	996	303	7	\N	0	\N
576	996	259	45	\N	0	\N
577	996	317	829	\N	0	\N
578	996	221	316	\N	0	\N
579	996	88	1	\N	0	\N
580	996	128	33	\N	0	\N
581	996	37	125	\N	0	\N
582	996	122	5	\N	0	\N
583	996	355	65	\N	0	\N
584	996	197	43	\N	0	\N
585	996	116	1205	\N	0	\N
586	996	264	1	\N	0	\N
587	996	343	18	\N	0	\N
588	996	168	24	\N	0	\N
589	996	82	96	\N	0	\N
590	996	319	6	\N	0	\N
591	996	308	10	\N	0	\N
592	996	305	4	\N	0	\N
593	996	316	3	\N	0	\N
594	996	267	643	\N	0	\N
595	996	160	2	\N	0	\N
596	996	190	9	\N	0	\N
597	996	143	2049	\N	0	\N
598	996	133	11	\N	0	\N
599	996	77	5041	\N	0	\N
600	996	269	21	\N	0	\N
601	996	182	1	\N	0	\N
602	996	265	22258	\N	1	\N
603	996	17	2	\N	0	\N
604	996	13	97	\N	0	\N
605	997	77	17164	\N	1	\N
606	998	77	100	\N	1	\N
607	1001	187	8	\N	1	\N
608	1002	251	8	\N	1	\N
609	1005	329	16	\N	1	\N
610	1005	79	1	\N	0	\N
611	1006	329	16	\N	1	\N
612	1007	329	1	\N	1	\N
613	1008	312	3	\N	1	\N
614	1009	312	3	\N	1	\N
615	1012	153	90	\N	1	\N
616	1013	153	90	\N	1	\N
617	1023	164	904	\N	0	\N
618	1023	219	1814	\N	1	\N
619	1024	164	490	\N	0	\N
620	1024	219	803	\N	1	\N
621	1025	164	409	\N	0	\N
622	1025	219	763	\N	1	\N
623	1026	164	216	\N	0	\N
624	1026	219	531	\N	1	\N
625	1027	219	397	\N	1	\N
626	1027	164	213	\N	0	\N
627	1028	164	168	\N	0	\N
628	1028	219	304	\N	1	\N
629	1029	164	152	\N	0	\N
630	1029	219	266	\N	1	\N
631	1030	219	263	\N	1	\N
632	1030	164	178	\N	0	\N
633	1031	219	228	\N	1	\N
634	1031	164	147	\N	0	\N
635	1032	219	234	\N	1	\N
636	1032	164	114	\N	0	\N
637	1033	219	186	\N	1	\N
638	1033	164	89	\N	0	\N
639	1034	164	148	\N	0	\N
640	1034	219	172	\N	1	\N
641	1035	219	166	\N	1	\N
642	1035	164	132	\N	0	\N
643	1036	219	162	\N	1	\N
644	1036	164	147	\N	0	\N
645	1037	219	131	\N	1	\N
646	1037	164	57	\N	0	\N
647	1038	219	127	\N	1	\N
648	1038	164	63	\N	0	\N
649	1039	164	61	\N	0	\N
650	1039	219	117	\N	1	\N
651	1040	219	63	\N	1	\N
652	1040	164	49	\N	0	\N
653	1041	219	63	\N	1	\N
654	1041	164	32	\N	0	\N
655	1042	164	45	\N	0	\N
656	1042	219	57	\N	1	\N
657	1043	164	31	\N	0	\N
658	1043	219	57	\N	1	\N
659	1044	219	57	\N	1	\N
660	1044	164	22	\N	0	\N
661	1045	219	45	\N	1	\N
662	1045	164	21	\N	0	\N
663	1046	219	45	\N	1	\N
664	1046	164	31	\N	0	\N
665	1047	164	25	\N	0	\N
666	1047	219	45	\N	1	\N
667	1048	164	22	\N	0	\N
668	1048	219	39	\N	1	\N
669	1049	219	34	\N	1	\N
670	1049	164	16	\N	0	\N
671	1050	219	30	\N	1	\N
672	1050	164	23	\N	0	\N
673	1051	164	17	\N	0	\N
674	1051	219	27	\N	1	\N
675	1052	219	25	\N	0	\N
676	1052	164	26	\N	1	\N
677	1053	219	21	\N	1	\N
678	1053	164	10	\N	0	\N
679	1054	219	18	\N	1	\N
680	1054	164	12	\N	0	\N
681	1055	219	18	\N	1	\N
682	1055	164	18	\N	0	\N
683	1056	164	14	\N	0	\N
684	1056	219	15	\N	1	\N
685	1057	219	15	\N	1	\N
686	1057	164	10	\N	0	\N
687	1058	219	15	\N	1	\N
688	1058	164	13	\N	0	\N
689	1059	164	11	\N	0	\N
690	1059	219	12	\N	1	\N
691	1060	164	12	\N	0	\N
692	1060	219	12	\N	1	\N
693	1061	164	7	\N	0	\N
694	1061	219	12	\N	1	\N
695	1062	164	12	\N	0	\N
696	1062	219	12	\N	1	\N
697	1063	164	4	\N	0	\N
698	1063	219	12	\N	1	\N
699	1064	164	4	\N	0	\N
700	1064	219	12	\N	1	\N
701	1065	219	9	\N	1	\N
702	1065	164	8	\N	0	\N
703	1066	164	5	\N	0	\N
704	1066	219	9	\N	1	\N
705	1067	164	7	\N	0	\N
706	1067	219	9	\N	1	\N
707	1068	164	6	\N	0	\N
708	1068	219	6	\N	1	\N
709	1069	164	5	\N	0	\N
710	1069	219	6	\N	1	\N
711	1070	219	6	\N	1	\N
712	1070	164	6	\N	0	\N
713	1071	164	2	\N	0	\N
714	1071	219	6	\N	1	\N
715	1072	219	6	\N	1	\N
716	1072	164	4	\N	0	\N
717	1073	219	6	\N	1	\N
718	1073	164	4	\N	0	\N
719	1074	219	6	\N	1	\N
720	1074	164	5	\N	0	\N
721	1075	164	6	\N	0	\N
722	1075	219	6	\N	1	\N
723	1076	164	4	\N	0	\N
724	1076	219	6	\N	1	\N
725	1077	219	6	\N	1	\N
726	1077	164	4	\N	0	\N
727	1078	219	6	\N	1	\N
728	1078	164	4	\N	0	\N
729	1079	219	3	\N	1	\N
730	1079	164	1	\N	0	\N
731	1080	164	1	\N	0	\N
732	1080	219	3	\N	1	\N
733	1081	164	3	\N	0	\N
734	1081	219	3	\N	1	\N
735	1082	219	3	\N	1	\N
736	1082	164	2	\N	0	\N
737	1083	219	3	\N	1	\N
738	1083	164	1	\N	0	\N
739	1084	125	234	\N	0	\N
740	1084	6	18	\N	0	\N
741	1084	122	9	\N	0	\N
742	1084	142	6	\N	0	\N
743	1084	158	57	\N	0	\N
744	1084	34	3	\N	0	\N
745	1084	342	6	\N	0	\N
746	1084	232	263	\N	0	\N
747	1084	254	34	\N	0	\N
748	1084	58	3	\N	0	\N
749	1084	269	45	\N	0	\N
750	1084	13	186	\N	0	\N
751	1084	87	6	\N	0	\N
752	1084	283	25	\N	0	\N
753	1084	4	45	\N	0	\N
754	1084	20	15	\N	0	\N
755	1084	234	131	\N	0	\N
756	1084	321	228	\N	0	\N
757	1084	257	397	\N	0	\N
758	1084	40	127	\N	0	\N
759	1084	249	15	\N	0	\N
760	1084	135	266	\N	0	\N
761	1084	8	6	\N	0	\N
762	1084	30	166	\N	0	\N
763	1084	117	30	\N	0	\N
764	1084	289	6	\N	0	\N
765	1084	177	39	\N	0	\N
766	1084	31	12	\N	0	\N
767	1084	127	1814	\N	1	\N
768	1084	54	162	\N	0	\N
769	1084	333	63	\N	0	\N
770	1084	133	21	\N	0	\N
771	1084	102	6	\N	0	\N
772	1084	146	6	\N	0	\N
773	1084	337	172	\N	0	\N
774	1084	343	45	\N	0	\N
775	1084	185	27	\N	0	\N
776	1084	308	15	\N	0	\N
777	1084	264	3	\N	0	\N
778	1084	160	6	\N	0	\N
779	1084	319	18	\N	0	\N
780	1084	285	3	\N	0	\N
781	1084	279	6	\N	0	\N
782	1084	253	63	\N	0	\N
783	1084	101	57	\N	0	\N
784	1084	183	6	\N	0	\N
785	1084	341	304	\N	0	\N
786	1084	46	763	\N	0	\N
787	1084	180	12	\N	0	\N
788	1084	29	117	\N	0	\N
789	1084	15	12	\N	0	\N
790	1084	156	3	\N	0	\N
791	1084	152	57	\N	0	\N
792	1084	316	9	\N	0	\N
793	1084	137	12	\N	0	\N
794	1084	280	803	\N	0	\N
795	1084	17	6	\N	0	\N
796	1084	320	12	\N	0	\N
797	1084	132	9	\N	0	\N
798	1084	250	531	\N	0	\N
799	1084	305	12	\N	0	\N
800	1085	20	14	\N	0	\N
801	1085	135	152	\N	0	\N
802	1085	8	6	\N	0	\N
803	1085	58	1	\N	0	\N
804	1085	31	12	\N	0	\N
805	1085	337	148	\N	0	\N
806	1085	102	2	\N	0	\N
807	1085	279	4	\N	0	\N
808	1085	321	147	\N	0	\N
809	1085	342	4	\N	0	\N
810	1085	87	6	\N	0	\N
811	1085	177	22	\N	0	\N
812	1085	122	8	\N	0	\N
813	1085	127	904	\N	1	\N
814	1085	316	7	\N	0	\N
815	1085	125	114	\N	0	\N
816	1085	29	61	\N	0	\N
817	1085	341	168	\N	0	\N
818	1085	15	11	\N	0	\N
819	1085	142	4	\N	0	\N
820	1085	343	25	\N	0	\N
821	1085	180	12	\N	0	\N
822	1085	320	4	\N	0	\N
823	1085	254	16	\N	0	\N
824	1085	185	17	\N	0	\N
825	1085	6	12	\N	0	\N
826	1085	333	32	\N	0	\N
827	1085	289	4	\N	0	\N
828	1085	158	22	\N	0	\N
829	1085	283	26	\N	0	\N
830	1085	280	490	\N	0	\N
831	1085	17	5	\N	0	\N
832	1085	183	6	\N	0	\N
833	1085	101	45	\N	0	\N
834	1085	152	31	\N	0	\N
835	1085	249	10	\N	0	\N
836	1085	132	5	\N	0	\N
837	1085	160	5	\N	0	\N
838	1085	156	3	\N	0	\N
839	1085	30	132	\N	0	\N
840	1085	13	89	\N	0	\N
841	1085	250	216	\N	0	\N
842	1085	46	409	\N	0	\N
843	1085	269	31	\N	0	\N
844	1085	133	10	\N	0	\N
845	1085	40	63	\N	0	\N
846	1085	137	7	\N	0	\N
847	1085	232	178	\N	0	\N
848	1085	319	18	\N	0	\N
849	1085	264	2	\N	0	\N
850	1085	234	57	\N	0	\N
851	1085	308	13	\N	0	\N
852	1085	146	4	\N	0	\N
853	1085	117	23	\N	0	\N
854	1085	34	1	\N	0	\N
855	1085	4	21	\N	0	\N
856	1085	54	147	\N	0	\N
857	1085	253	49	\N	0	\N
858	1085	305	4	\N	0	\N
859	1085	285	1	\N	0	\N
860	1085	257	213	\N	0	\N
861	1092	229	2	\N	1	\N
862	1093	237	2	\N	1	\N
863	1104	70	575	\N	1	\N
864	1105	94	575	\N	1	\N
865	1106	354	88	\N	1	\N
866	1107	14	88	\N	1	\N
867	1302	164	851	\N	1	\N
868	1303	164	3	\N	1	\N
869	1304	219	851	\N	1	\N
870	1304	23	3	\N	0	\N
871	1316	238	165851	\N	1	\N
872	1317	238	93646	\N	1	\N
873	1318	238	80673	\N	1	\N
874	1319	238	73801	\N	1	\N
875	1320	172	44485	\N	1	\N
876	1321	172	41983	\N	1	\N
877	1322	172	34675	\N	1	\N
878	1323	238	33735	\N	1	\N
879	1324	256	26913	\N	1	\N
880	1325	172	21935	\N	1	\N
881	1326	172	17338	\N	1	\N
882	1327	172	16480	\N	1	\N
883	1327	256	421	\N	0	\N
884	1328	238	13216	\N	1	\N
885	1329	172	13009	\N	1	\N
886	1330	256	11871	\N	1	\N
887	1331	172	10131	\N	1	\N
888	1332	172	10030	\N	1	\N
889	1333	238	9670	\N	1	\N
890	1334	238	9670	\N	1	\N
891	1335	172	8442	\N	1	\N
892	1336	256	7237	\N	1	\N
893	1336	107	679	\N	0	\N
894	1337	238	7411	\N	1	\N
895	1338	172	7262	\N	1	\N
896	1339	172	7222	\N	1	\N
897	1340	256	7146	\N	1	\N
898	1341	238	5269	\N	1	\N
899	1342	256	4768	\N	1	\N
900	1343	256	4632	\N	1	\N
901	1344	256	4630	\N	1	\N
902	1345	256	4597	\N	1	\N
903	1345	107	6	\N	0	\N
904	1346	172	4526	\N	1	\N
905	1347	238	4512	\N	1	\N
906	1348	172	3546	\N	1	\N
907	1349	256	3499	\N	1	\N
908	1350	238	2734	\N	1	\N
909	1351	172	2578	\N	1	\N
910	1352	172	2467	\N	1	\N
911	1353	256	2373	\N	1	\N
912	1354	172	2225	\N	1	\N
913	1355	238	2012	\N	1	\N
914	1356	172	1992	\N	1	\N
915	1357	238	1751	\N	1	\N
916	1358	256	1521	\N	1	\N
917	1359	172	1418	\N	1	\N
918	1360	172	1368	\N	1	\N
919	1361	238	1345	\N	1	\N
920	1362	256	1336	\N	1	\N
921	1363	172	1326	\N	1	\N
922	1364	238	1232	\N	1	\N
923	1365	238	1147	\N	1	\N
924	1366	172	1146	\N	1	\N
925	1367	238	1143	\N	1	\N
926	1368	238	1115	\N	1	\N
927	1369	172	1111	\N	1	\N
928	1370	172	1107	\N	1	\N
929	1371	172	1099	\N	1	\N
930	1372	256	1092	\N	1	\N
931	1373	172	1091	\N	1	\N
932	1374	238	1086	\N	1	\N
933	1375	238	985	\N	1	\N
934	1376	172	958	\N	1	\N
935	1377	256	716	\N	1	\N
936	1377	107	241	\N	0	\N
937	1378	172	931	\N	1	\N
938	1379	172	911	\N	1	\N
939	1380	238	896	\N	1	\N
940	1381	256	853	\N	1	\N
941	1382	172	818	\N	1	\N
942	1383	256	807	\N	1	\N
943	1384	256	795	\N	1	\N
944	1385	172	736	\N	1	\N
945	1386	238	733	\N	1	\N
946	1387	256	723	\N	1	\N
947	1388	172	694	\N	1	\N
948	1389	172	685	\N	1	\N
949	1390	172	643	\N	1	\N
950	1391	256	619	\N	1	\N
951	1392	172	598	\N	1	\N
952	1393	238	549	\N	1	\N
953	1394	172	543	\N	1	\N
954	1395	172	502	\N	1	\N
955	1396	172	489	\N	1	\N
956	1397	172	474	\N	1	\N
957	1398	256	463	\N	1	\N
958	1399	172	412	\N	1	\N
959	1400	107	125	\N	0	\N
960	1400	256	280	\N	1	\N
961	1401	256	359	\N	1	\N
962	1402	172	308	\N	1	\N
963	1403	256	304	\N	1	\N
964	1404	238	298	\N	1	\N
965	1405	256	292	\N	1	\N
966	1406	238	287	\N	1	\N
967	1407	172	254	\N	1	\N
968	1408	172	250	\N	1	\N
969	1409	238	221	\N	1	\N
970	1410	256	210	\N	1	\N
971	1411	172	204	\N	1	\N
972	1412	238	190	\N	1	\N
973	1413	238	185	\N	1	\N
974	1414	256	180	\N	1	\N
975	1415	172	169	\N	1	\N
976	1416	256	163	\N	1	\N
977	1417	172	158	\N	1	\N
978	1418	172	154	\N	1	\N
979	1419	256	144	\N	1	\N
980	1420	172	140	\N	1	\N
981	1421	256	140	\N	1	\N
982	1422	172	125	\N	1	\N
983	1423	238	118	\N	1	\N
984	1424	172	113	\N	1	\N
985	1425	256	110	\N	1	\N
986	1426	256	105	\N	1	\N
987	1427	107	28	\N	0	\N
988	1427	256	76	\N	1	\N
989	1428	238	102	\N	1	\N
990	1429	256	98	\N	1	\N
991	1430	172	93	\N	1	\N
992	1431	172	91	\N	1	\N
993	1432	256	91	\N	1	\N
994	1433	256	89	\N	1	\N
995	1434	172	86	\N	1	\N
996	1435	256	86	\N	1	\N
997	1436	256	80	\N	1	\N
998	1436	107	1	\N	0	\N
999	1437	172	74	\N	1	\N
1000	1438	107	11	\N	0	\N
1001	1438	256	58	\N	1	\N
1002	1439	238	68	\N	1	\N
1003	1440	256	62	\N	1	\N
1004	1441	172	61	\N	1	\N
1005	1442	172	61	\N	1	\N
1006	1443	238	58	\N	1	\N
1007	1444	172	57	\N	1	\N
1008	1445	238	57	\N	1	\N
1009	1446	256	54	\N	1	\N
1010	1447	256	21	\N	0	\N
1011	1447	107	29	\N	1	\N
1012	1448	238	46	\N	1	\N
1013	1449	172	45	\N	1	\N
1014	1450	256	43	\N	1	\N
1015	1451	256	40	\N	1	\N
1016	1452	172	40	\N	1	\N
1017	1453	172	38	\N	1	\N
1018	1454	256	38	\N	1	\N
1019	1455	256	34	\N	1	\N
1020	1456	238	34	\N	1	\N
1021	1457	238	29	\N	1	\N
1022	1458	238	27	\N	1	\N
1023	1459	256	22	\N	1	\N
1024	1460	107	14	\N	1	\N
1025	1460	256	3	\N	0	\N
1026	1461	172	15	\N	1	\N
1027	1462	172	14	\N	1	\N
1028	1463	172	13	\N	1	\N
1029	1464	238	12	\N	1	\N
1030	1465	256	10	\N	1	\N
1031	1466	256	9	\N	1	\N
1032	1466	107	1	\N	0	\N
1033	1467	256	9	\N	1	\N
1034	1468	238	8	\N	1	\N
1035	1469	256	8	\N	1	\N
1036	1470	256	7	\N	1	\N
1037	1471	256	5	\N	1	\N
1038	1471	107	1	\N	0	\N
1039	1472	238	5	\N	1	\N
1040	1473	238	3	\N	1	\N
1041	1474	238	3	\N	1	\N
1042	1475	256	2	\N	1	\N
1043	1476	107	2	\N	1	\N
1044	1477	172	2	\N	1	\N
1045	1478	256	1	\N	1	\N
1046	1479	256	1	\N	1	\N
1047	1480	256	1	\N	1	\N
1048	1481	238	1	\N	1	\N
1049	1482	119	33735	\N	0	\N
1050	1482	268	1232	\N	0	\N
1051	1482	165	27	\N	0	\N
1052	1482	270	733	\N	0	\N
1053	1482	331	34	\N	0	\N
1054	1482	109	190	\N	0	\N
1055	1482	311	1345	\N	0	\N
1056	1482	100	68	\N	0	\N
1057	1482	296	287	\N	0	\N
1058	1482	214	9670	\N	0	\N
1059	1482	193	1115	\N	0	\N
1060	1482	216	73801	\N	0	\N
1061	1482	19	549	\N	0	\N
1062	1482	55	185	\N	0	\N
1063	1482	157	1	\N	0	\N
1064	1482	346	13216	\N	0	\N
1065	1482	350	7411	\N	0	\N
1066	1482	235	29	\N	0	\N
1067	1482	194	5	\N	0	\N
1068	1482	85	1751	\N	0	\N
1069	1482	358	2012	\N	0	\N
1070	1482	144	93646	\N	0	\N
1071	1482	359	165851	\N	1	\N
1072	1482	207	46	\N	0	\N
1073	1482	188	221	\N	0	\N
1074	1482	224	57	\N	0	\N
1075	1482	104	102	\N	0	\N
1076	1482	115	896	\N	0	\N
1077	1482	7	58	\N	0	\N
1078	1482	80	3	\N	0	\N
1079	1482	71	1086	\N	0	\N
1080	1482	167	4512	\N	0	\N
1081	1482	266	298	\N	0	\N
1082	1482	11	12	\N	0	\N
1083	1482	330	3	\N	0	\N
1084	1482	42	1147	\N	0	\N
1085	1482	86	118	\N	0	\N
1086	1482	131	985	\N	0	\N
1087	1482	306	1143	\N	0	\N
1088	1482	213	2734	\N	0	\N
1089	1482	258	5269	\N	0	\N
1090	1482	161	80673	\N	0	\N
1091	1482	16	9670	\N	0	\N
1092	1482	68	8	\N	0	\N
1093	1483	201	694	\N	0	\N
1094	1483	313	158	\N	0	\N
1095	1483	145	44485	\N	1	\N
1096	1483	241	911	\N	0	\N
1097	1483	118	1368	\N	0	\N
1098	1483	217	1146	\N	0	\N
1099	1483	95	140	\N	0	\N
1100	1483	301	2225	\N	0	\N
1101	1483	291	34675	\N	0	\N
1102	1483	222	7222	\N	0	\N
1103	1483	242	685	\N	0	\N
1104	1483	297	308	\N	0	\N
1105	1483	57	74	\N	0	\N
1106	1483	351	931	\N	0	\N
1107	1483	275	38	\N	0	\N
1108	1483	328	10131	\N	0	\N
1109	1483	299	254	\N	0	\N
1110	1483	35	2578	\N	0	\N
1111	1483	336	598	\N	0	\N
1112	1483	292	250	\N	0	\N
1113	1483	138	45	\N	0	\N
1114	1483	322	1326	\N	0	\N
1115	1483	273	86	\N	0	\N
1116	1483	33	14	\N	0	\N
1117	1483	192	10030	\N	0	\N
1118	1483	89	204	\N	0	\N
1119	1483	139	91	\N	0	\N
1120	1483	210	1418	\N	0	\N
1121	1483	166	41983	\N	0	\N
1122	1483	105	2467	\N	0	\N
1123	1483	92	643	\N	0	\N
1124	1483	2	61	\N	0	\N
1125	1483	121	57	\N	0	\N
1126	1483	149	1992	\N	0	\N
1127	1483	66	736	\N	0	\N
1128	1483	72	16480	\N	0	\N
1129	1483	356	489	\N	0	\N
1130	1483	24	61	\N	0	\N
1131	1483	65	154	\N	0	\N
1132	1483	318	40	\N	0	\N
1133	1483	140	502	\N	0	\N
1134	1483	277	412	\N	0	\N
1135	1483	209	169	\N	0	\N
1136	1483	233	15	\N	0	\N
1137	1483	1	958	\N	0	\N
1138	1483	81	474	\N	0	\N
1139	1483	198	1111	\N	0	\N
1140	1483	45	1099	\N	0	\N
1141	1483	51	1091	\N	0	\N
1142	1483	91	13	\N	0	\N
1143	1483	204	2	\N	0	\N
1144	1483	298	7262	\N	0	\N
1145	1483	123	13009	\N	0	\N
1146	1483	186	8442	\N	0	\N
1147	1483	295	4526	\N	0	\N
1148	1483	126	818	\N	0	\N
1149	1483	26	113	\N	0	\N
1150	1483	151	93	\N	0	\N
1151	1483	245	3546	\N	0	\N
1152	1483	176	543	\N	0	\N
1153	1483	28	1107	\N	0	\N
1154	1483	271	21935	\N	0	\N
1155	1483	226	125	\N	0	\N
1156	1483	272	17338	\N	0	\N
1157	1484	62	4597	\N	0	\N
1158	1484	41	853	\N	0	\N
1159	1484	286	304	\N	0	\N
1160	1484	282	4630	\N	0	\N
1161	1484	323	80	\N	0	\N
1162	1484	260	7	\N	0	\N
1163	1484	93	4768	\N	0	\N
1164	1484	84	1	\N	0	\N
1165	1484	163	140	\N	0	\N
1166	1484	75	5	\N	0	\N
1167	1484	154	3499	\N	0	\N
1168	1484	191	21	\N	0	\N
1169	1484	239	10	\N	0	\N
1170	1484	261	1336	\N	0	\N
1171	1484	99	2	\N	0	\N
1172	1484	150	1	\N	0	\N
1173	1484	293	4632	\N	0	\N
1174	1484	44	180	\N	0	\N
1175	1484	69	43	\N	0	\N
1176	1484	262	210	\N	0	\N
1177	1484	338	86	\N	0	\N
1178	1484	76	105	\N	0	\N
1179	1484	106	34	\N	0	\N
1180	1484	9	2373	\N	0	\N
1181	1484	124	54	\N	0	\N
1182	1484	325	9	\N	0	\N
1183	1484	202	292	\N	0	\N
1184	1484	52	359	\N	0	\N
1185	1484	155	3	\N	0	\N
1186	1484	147	1521	\N	0	\N
1187	1484	47	723	\N	0	\N
1188	1484	61	62	\N	0	\N
1189	1484	243	58	\N	0	\N
1190	1484	39	22	\N	0	\N
1191	1484	205	7146	\N	0	\N
1192	1484	353	1092	\N	0	\N
1193	1484	314	280	\N	0	\N
1194	1484	130	98	\N	0	\N
1195	1484	223	144	\N	0	\N
1196	1484	344	91	\N	0	\N
1197	1484	248	716	\N	0	\N
1198	1484	348	7237	\N	0	\N
1199	1484	74	89	\N	0	\N
1200	1484	284	40	\N	0	\N
1201	1484	255	163	\N	0	\N
1202	1484	103	619	\N	0	\N
1203	1484	72	421	\N	0	\N
1204	1484	169	76	\N	0	\N
1205	1484	335	11871	\N	0	\N
1206	1484	162	8	\N	0	\N
1207	1484	315	26913	\N	1	\N
1208	1484	228	463	\N	0	\N
1209	1484	345	38	\N	0	\N
1210	1484	12	9	\N	0	\N
1211	1484	347	795	\N	0	\N
1212	1484	352	807	\N	0	\N
1213	1484	247	110	\N	0	\N
1214	1484	110	1	\N	0	\N
1215	1485	314	125	\N	0	\N
1216	1485	243	11	\N	0	\N
1217	1485	111	2	\N	0	\N
1218	1485	155	14	\N	0	\N
1219	1485	325	1	\N	0	\N
1220	1485	323	1	\N	0	\N
1221	1485	169	28	\N	0	\N
1222	1485	62	6	\N	0	\N
1223	1485	75	1	\N	0	\N
1224	1485	348	679	\N	1	\N
1225	1485	191	29	\N	0	\N
1226	1485	248	241	\N	0	\N
1227	1497	354	2	\N	1	\N
1228	1498	14	2	\N	1	\N
1229	1499	263	82	\N	1	\N
1230	1500	288	82	\N	1	\N
1231	1503	354	180	\N	1	\N
1232	1503	14	100	\N	0	\N
1233	1504	354	180	\N	1	\N
1234	1505	354	100	\N	1	\N
1235	1510	324	1	\N	1	\N
1236	1510	340	1	\N	0	\N
1237	1511	340	1	\N	1	\N
1238	1511	324	1	\N	0	\N
1239	1512	324	1	\N	1	\N
1240	1512	340	1	\N	0	\N
1241	1513	340	1	\N	1	\N
1242	1513	324	1	\N	0	\N
1243	1516	211	24	\N	1	\N
1244	1517	354	48	\N	1	\N
1245	1518	354	1	\N	1	\N
1246	1519	329	48	\N	1	\N
1247	1519	79	1	\N	0	\N
1248	1520	231	24	\N	1	\N
1249	1521	153	24	\N	1	\N
1250	1522	211	24	\N	1	\N
1251	1527	312	1	\N	1	\N
1252	1528	25	1	\N	1	\N
1253	1530	219	851	\N	1	\N
1254	1531	164	851	\N	1	\N
1255	1537	251	2	\N	1	\N
1256	1538	236	2	\N	1	\N
1257	1543	127	66	\N	1	\N
1258	1544	280	240	\N	1	\N
1259	1545	46	26	\N	1	\N
1260	1546	250	70	\N	1	\N
1261	1547	257	24	\N	1	\N
1262	1548	135	34	\N	1	\N
1263	1549	13	66	\N	1	\N
1264	1550	321	8	\N	1	\N
1265	1552	125	14	\N	1	\N
1266	1553	341	4	\N	1	\N
1267	1554	337	2	\N	1	\N
1268	1555	40	36	\N	1	\N
1269	1556	30	4	\N	1	\N
1270	1557	29	22	\N	1	\N
1271	1558	232	14	\N	1	\N
1272	1559	234	6	\N	1	\N
1273	1560	101	10	\N	1	\N
1274	1561	253	8	\N	1	\N
1275	1562	269	2	\N	1	\N
1276	1563	4	14	\N	1	\N
1277	1564	152	6	\N	1	\N
1278	1565	343	6	\N	1	\N
1279	1566	283	6	\N	1	\N
1280	1567	117	4	\N	1	\N
1281	1568	254	8	\N	1	\N
1282	1569	177	4	\N	1	\N
1283	1571	133	6	\N	1	\N
1284	1573	6	4	\N	1	\N
1285	1575	308	2	\N	1	\N
1286	1577	219	16	\N	1	\N
1287	1579	122	4	\N	1	\N
1288	1581	20	4	\N	1	\N
1289	1584	279	4	\N	1	\N
1290	1606	127	66	\N	1	\N
1291	1607	280	240	\N	1	\N
1292	1608	219	16	\N	1	\N
1293	1609	46	26	\N	1	\N
1294	1610	250	70	\N	1	\N
1295	1611	257	24	\N	1	\N
1296	1612	13	66	\N	1	\N
1297	1613	135	34	\N	1	\N
1298	1614	125	14	\N	1	\N
1299	1615	321	8	\N	1	\N
1300	1616	40	36	\N	1	\N
1301	1617	341	4	\N	1	\N
1302	1618	29	22	\N	1	\N
1303	1619	30	4	\N	1	\N
1304	1620	337	2	\N	1	\N
1305	1622	234	6	\N	1	\N
1306	1623	253	8	\N	1	\N
1307	1624	4	14	\N	1	\N
1308	1625	101	10	\N	1	\N
1309	1626	152	6	\N	1	\N
1310	1627	343	6	\N	1	\N
1311	1628	254	8	\N	1	\N
1312	1629	269	2	\N	1	\N
1313	1630	283	6	\N	1	\N
1314	1632	177	4	\N	1	\N
1315	1634	117	4	\N	1	\N
1316	1635	133	6	\N	1	\N
1317	1636	232	14	\N	1	\N
1318	1637	6	4	\N	1	\N
1319	1639	308	2	\N	1	\N
1320	1640	122	4	\N	1	\N
1321	1641	279	4	\N	1	\N
1322	1644	20	4	\N	1	\N
1323	1668	354	4277929	\N	1	\N
1324	1682	354	9675	\N	1	\N
1325	1683	354	9670	\N	1	\N
1326	1685	354	17164	\N	1	\N
1327	1687	354	14504	\N	1	\N
1328	1689	354	13209	\N	1	\N
1329	1692	354	10640	\N	1	\N
1330	1696	354	7955	\N	1	\N
1331	1699	354	7368	\N	1	\N
1332	1700	354	7368	\N	1	\N
1333	1713	354	2925	\N	1	\N
1334	1718	354	2467	\N	1	\N
1335	1723	354	1962	\N	1	\N
1336	1725	354	1714	\N	1	\N
1337	1727	354	1484	\N	1	\N
1338	1730	354	1367	\N	1	\N
1339	1737	354	1145	\N	1	\N
1340	1740	354	1119	\N	1	\N
1341	1751	354	942	\N	1	\N
1342	1759	354	743	\N	1	\N
1343	1761	354	734	\N	1	\N
1344	1768	354	639	\N	1	\N
1345	1772	354	570	\N	1	\N
1346	1773	354	568	\N	1	\N
1347	1778	354	483	\N	1	\N
1348	1780	354	468	\N	1	\N
1349	1782	354	449	\N	1	\N
1350	1783	354	444	\N	1	\N
1351	1785	354	409	\N	1	\N
1352	1787	354	392	\N	1	\N
1353	1788	354	390	\N	1	\N
1354	1791	354	352	\N	1	\N
1355	1792	354	315	\N	1	\N
1356	1798	354	287	\N	1	\N
1357	1803	354	248	\N	1	\N
1358	1804	354	240	\N	1	\N
1359	1806	354	212	\N	1	\N
1360	1815	354	164	\N	1	\N
1361	1819	354	145	\N	1	\N
1362	1824	354	131	\N	1	\N
1363	1825	354	127	\N	1	\N
1364	1827	354	122	\N	1	\N
1365	1828	354	121	\N	1	\N
1366	1829	354	121	\N	1	\N
1367	1830	354	119	\N	1	\N
1368	1834	354	113	\N	1	\N
1369	1839	354	102	\N	1	\N
1370	1841	354	102	\N	1	\N
1371	1843	354	100	\N	1	\N
1372	1844	354	99	\N	1	\N
1373	1847	354	98	\N	1	\N
1374	1848	354	97	\N	1	\N
1375	1849	354	96	\N	1	\N
1376	1855	354	89	\N	1	\N
1377	1856	354	89	\N	1	\N
1378	1863	354	81	\N	1	\N
1379	1869	354	69	\N	1	\N
1380	1871	354	68	\N	1	\N
1381	1872	354	64	\N	1	\N
1382	1877	354	59	\N	1	\N
1383	1892	354	43	\N	1	\N
1384	1893	354	43	\N	1	\N
1385	1896	354	39	\N	1	\N
1386	1899	354	36	\N	1	\N
1387	1900	354	34	\N	1	\N
1388	1903	354	33	\N	1	\N
1389	1904	354	29	\N	1	\N
1390	1905	354	29	\N	1	\N
1391	1907	354	28	\N	1	\N
1392	1908	354	27	\N	1	\N
1393	1910	354	26	\N	1	\N
1394	1911	354	26	\N	1	\N
1395	1912	354	24	\N	1	\N
1396	1913	354	24	\N	1	\N
1397	1917	354	21	\N	1	\N
1398	1923	354	18	\N	1	\N
1399	1927	354	15	\N	1	\N
1400	1928	354	15	\N	1	\N
1401	1931	354	14	\N	1	\N
1402	1933	354	14	\N	1	\N
1403	1936	354	13	\N	1	\N
1404	1940	354	10	\N	1	\N
1405	1942	354	10	\N	1	\N
1406	1947	354	9	\N	1	\N
1407	1950	354	8	\N	1	\N
1408	1957	354	7	\N	1	\N
1409	1959	354	6	\N	1	\N
1410	1963	354	5	\N	1	\N
1411	1977	354	4	\N	1	\N
1412	1979	354	3	\N	1	\N
1413	1981	354	3	\N	1	\N
1414	1986	354	3	\N	1	\N
1415	1991	354	2	\N	1	\N
1416	1992	354	2	\N	1	\N
1417	2010	354	1	\N	1	\N
1418	2014	354	1	\N	1	\N
1419	2015	354	1	\N	1	\N
1420	2017	354	1	\N	1	\N
1421	2022	354	1	\N	1	\N
1422	2023	354	1	\N	1	\N
1423	2024	354	1	\N	1	\N
1424	2025	354	1	\N	1	\N
1425	2028	246	69	\N	0	\N
1426	2028	50	24	\N	0	\N
1427	2028	53	121	\N	0	\N
1428	2028	159	113	\N	0	\N
1429	2028	196	99	\N	0	\N
1430	2028	190	9	\N	0	\N
1431	2028	120	26	\N	0	\N
1432	2028	332	1714	\N	0	\N
1433	2028	48	449	\N	0	\N
1434	2028	23	1	\N	0	\N
1435	2028	88	1	\N	0	\N
1436	2028	252	1	\N	0	\N
1437	2028	148	942	\N	0	\N
1438	2028	43	3	\N	0	\N
1439	2028	77	7955	\N	0	\N
1440	2028	18	39	\N	0	\N
1441	2028	22	4277929	\N	1	\N
1442	2028	206	1	\N	0	\N
1443	2028	259	43	\N	0	\N
1444	2028	309	2925	\N	0	\N
1445	2028	73	5	\N	0	\N
1446	2028	287	1367	\N	0	\N
1447	2028	303	7	\N	0	\N
1448	2028	225	145	\N	0	\N
1449	2028	128	33	\N	0	\N
1450	2028	5	34	\N	0	\N
1451	2028	164	13209	\N	0	\N
1452	2028	326	570	\N	0	\N
1453	2028	200	127	\N	0	\N
1454	2028	302	10	\N	0	\N
1455	2028	195	743	\N	0	\N
1456	2028	197	43	\N	0	\N
1457	2028	175	17164	\N	0	\N
1458	2028	129	15	\N	0	\N
1459	2028	143	1962	\N	0	\N
1460	2028	327	468	\N	0	\N
1461	2028	59	2	\N	0	\N
1462	2028	90	10640	\N	0	\N
1463	2028	290	3	\N	0	\N
1464	2028	3	3	\N	0	\N
1465	2028	98	29	\N	0	\N
1466	2028	112	240	\N	0	\N
1467	2028	355	64	\N	0	\N
1468	2028	21	29	\N	0	\N
1469	2028	27	131	\N	0	\N
1470	2028	357	13	\N	0	\N
1471	2028	16	9675	\N	0	\N
1472	2028	278	89	\N	0	\N
1473	2028	199	24	\N	0	\N
1474	2028	360	100	\N	0	\N
1475	2028	267	568	\N	0	\N
1476	2028	181	59	\N	0	\N
1477	2028	317	734	\N	0	\N
1478	2028	265	14504	\N	0	\N
1479	2028	168	21	\N	0	\N
1480	2028	294	68	\N	0	\N
1481	2028	96	14	\N	0	\N
1482	2028	49	164	\N	0	\N
1483	2028	38	639	\N	0	\N
1484	2028	300	98	\N	0	\N
1485	2028	70	2	\N	0	\N
1486	2028	214	9670	\N	0	\N
1487	2028	240	212	\N	0	\N
1488	2028	212	97	\N	0	\N
1489	2028	307	26	\N	0	\N
1490	2028	37	122	\N	0	\N
1491	2028	32	15	\N	0	\N
1492	2028	221	248	\N	0	\N
1493	2028	244	89	\N	0	\N
1494	2028	220	102	\N	0	\N
1495	2028	170	2467	\N	0	\N
1496	2028	182	1	\N	0	\N
1497	2028	276	14	\N	0	\N
1498	2028	116	1119	\N	0	\N
1499	2028	274	121	\N	0	\N
1500	2028	227	287	\N	0	\N
1501	2028	310	1145	\N	0	\N
1502	2028	230	18	\N	0	\N
1503	2028	78	102	\N	0	\N
1504	2028	10	390	\N	0	\N
1505	2028	108	8	\N	0	\N
1506	2028	218	483	\N	0	\N
1507	2028	215	1484	\N	0	\N
1508	2028	82	96	\N	0	\N
1509	2028	64	315	\N	0	\N
1510	2028	203	81	\N	0	\N
1511	2028	83	1	\N	0	\N
1512	2028	339	7368	\N	0	\N
1513	2028	60	27	\N	0	\N
1514	2028	281	36	\N	0	\N
1515	2028	178	1	\N	0	\N
1516	2028	174	409	\N	0	\N
1517	2028	334	4	\N	0	\N
1518	2028	114	10	\N	0	\N
1519	2028	219	444	\N	0	\N
1520	2028	304	28	\N	0	\N
1521	2028	189	352	\N	0	\N
1522	2028	184	7368	\N	0	\N
1523	2028	67	1	\N	0	\N
1524	2028	63	6	\N	0	\N
1525	2028	113	392	\N	0	\N
1526	2028	136	119	\N	0	\N
1527	2030	357	575	\N	0	\N
1528	2030	294	408	\N	0	\N
1529	2030	219	938	\N	1	\N
1530	2031	94	938	\N	1	\N
1531	2032	94	575	\N	1	\N
1532	2033	94	408	\N	1	\N
1533	2043	208	4	\N	1	\N
1534	2044	208	4	\N	1	\N
1535	2045	22	4185464	\N	1	\N
1536	2046	164	38478	\N	1	\N
1537	2047	22	23184	\N	1	\N
1538	2048	164	6728	\N	1	\N
1539	2048	219	586	\N	0	\N
1540	2049	175	4185464	\N	1	\N
1541	2049	97	23184	\N	0	\N
1542	2050	294	6728	\N	0	\N
1543	2050	219	38478	\N	1	\N
1544	2051	294	586	\N	1	\N
1545	2052	251	2	\N	1	\N
1546	2053	236	2	\N	1	\N
1547	2054	288	8	\N	1	\N
1548	2055	251	8	\N	1	\N
1549	2064	288	3	\N	1	\N
1550	2065	263	3	\N	1	\N
1551	2066	288	10	\N	1	\N
1552	2067	263	10	\N	1	\N
1553	2068	288	3	\N	1	\N
1554	2069	263	3	\N	1	\N
1555	2070	219	39184	\N	1	\N
1556	2070	294	7014	\N	0	\N
1557	2071	294	586	\N	1	\N
1558	2072	164	39184	\N	1	\N
1559	2073	164	7014	\N	1	\N
1560	2073	219	586	\N	0	\N
1561	2074	288	46	\N	1	\N
1562	2075	141	8	\N	1	\N
1563	2076	173	2	\N	1	\N
1564	2077	263	46	\N	1	\N
1565	2078	56	8	\N	1	\N
1566	2079	187	2	\N	1	\N
1567	2081	288	13	\N	1	\N
1568	2082	263	13	\N	1	\N
1569	2108	77	326	\N	1	\N
1570	2109	77	326	\N	1	\N
1571	2112	329	187	\N	1	\N
1572	2112	231	2	\N	0	\N
1573	2112	79	2	\N	0	\N
1574	2113	14	187	\N	1	\N
1575	2114	14	2	\N	1	\N
1576	2115	14	2	\N	1	\N
1577	2116	354	61	\N	1	\N
1578	2117	14	61	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#string	3	string
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
20	dbr	http://dbpedia.org/resource/	0	f	0
21	dbt	http://dbpedia.org/resource/Template:	0	f	0
22	dbc	http://dbpedia.org/resource/Category:	0	f	0
23	cc	http://creativecommons.org/ns#	0	f	0
24	vann	http://purl.org/vocab/vann/	0	f	0
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
70	scovo	http://purl.org/NET/scovo#	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
71	geonames	http://www.geonames.org/ontology#	0	f	0
74	geoes	http://geo.linkeddata.es/ontology/	0	f	0
77	esadm	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#	0	f	0
79	cjr	http://vocab.linkeddata.es/datosabiertos/def/urbanismo-infraestructuras/callejero#	0	f	0
72	btn-100	http://geo.linkeddata.es/def/btn100#	0	f	0
73	map4rdf	http://code.google.com/p/map4rdf/wiki/ontology#	0	f	0
75	geosparql	http://www.opengis.net/ont/geosparql/	0	f	0
76	cantera	http://geo.linkeddata.es/recurso/btn100/cantera/	0	f	0
78	geo_core	http://geo.linkeddata.es/def/geo_core#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_geo_linkeddata_es_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_geo_linkeddata_es_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://geo.linkeddata.es/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://geo.linkeddata.es/sparql", "correlationId": "8909287622100839778", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": "base", "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-12T12:41:33.509Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.openlinksw.com/schemas/virtrdf#qmvftColumnName	3	\N	17	qmvftColumnName	qmvftColumnName	f	0	\N	\N	f	f	179	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://geo.linkeddata.es/def/btn100#numeroDeVias	4432	\N	72	numeroDeVias	numeroDeVias	f	4432	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.openlinksw.com/schemas/virtrdf#qmvftXmlIndex	2	\N	17	qmvftXmlIndex	qmvftXmlIndex	f	0	\N	\N	f	f	179	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://geo.linkeddata.es/def/btn100#categoria	17718	\N	72	categoria	categoria	f	16980	\N	\N	f	f	119	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://www.openlinksw.com/schemas/virtrdf#qmTableName	2	\N	17	qmTableName	qmTableName	f	0	\N	\N	f	f	236	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://code.google.com/p/map4rdf/wiki/ontology#facet	149	\N	73	facet	facet	f	149	\N	\N	f	f	171	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfLongTmpl	26	\N	17	qmfShortOfLongTmpl	qmfShortOfLongTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://geo.linkeddata.es/def/btn100#altitudOrtometrica	11186	\N	72	altitudOrtometrica	altitudOrtometrica	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://geo.linkeddata.es/ontology/provenance	64	\N	74	provenance	provenance	f	0	\N	\N	f	f	354	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://purl.org/dc/terms/identificador	6751	\N	5	identificador	identificador	f	0	\N	\N	f	f	295	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.opengis.net/ont/geosparql/asWKT	3197	\N	75	asWKT	asWKT	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/2002/07/owl#equivalentClass	38	\N	7	equivalentClass	equivalentClass	f	38	\N	\N	f	f	354	354	\N	t	f	\N	\N	\N	t	f	f
13	http://www.openlinksw.com/schemas/virtrdf#qmfBoolOfShortTmpl	26	\N	17	qmfBoolOfShortTmpl	qmfBoolOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://www.openlinksw.com/schemas/virtrdf#qmfTypeminTmpl	34	\N	17	qmfTypeminTmpl	qmfTypeminTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2002/07/owl#minQualifiedCardinality	2	\N	7	minQualifiedCardinality	minQualifiedCardinality	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://geo.linkeddata.es/def/btn100#tipoDeTrafico	6692	\N	72	tipoDeTrafico	tipoDeTrafico	f	5839	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.openlinksw.com/schemas/virtrdf#qmfSqlvalOfShortTmpl	31	\N	17	qmfSqlvalOfShortTmpl	qmfSqlvalOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://geo.linkeddata.es/def/btn100#componenteDeTelecomunicaciones	2888	\N	72	componenteDeTelecomunicaciones	componenteDeTelecomunicaciones	f	2888	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrRestrictions	150	\N	17	qmfValRange-rvrRestrictions	qmfValRange-rvrRestrictions	f	150	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://www.openlinksw.com/schemas/virtrdf#qmvColumnsFormKey	8	\N	17	qmvColumnsFormKey	qmvColumnsFormKey	f	0	\N	\N	f	f	251	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://geo.linkeddata.es/ontology/rutaTEN-T	9670	\N	74	rutaTEN-T	rutaTEN-T	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://xmlns.com/foaf/0.1/homepage	5	\N	8	homepage	homepage	f	1	\N	\N	f	f	324	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://geo.linkeddata.es/def/btn100#huso	11186	\N	72	huso	huso	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://geo.linkeddata.es/ontology/competencia	9670	\N	74	competencia	competencia	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://geo.linkeddata.es/def/btn100#competenciaPortuaria	308	\N	72	competenciaPortuaria	competenciaPortuaria	f	42	\N	\N	f	f	297	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://purl.org/dc/terms/FECHA_ALTA	2225	\N	5	FECHA_ALTA	FECHA_ALTA	f	0	\N	\N	f	f	301	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://www.openlinksw.com/schemas/virtrdf#qmfUriIdOffset	34	\N	17	qmfUriIdOffset	qmfUriIdOffset	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://geo.linkeddata.es/recurso/btn100/cantera/TIPO_0506	3546	\N	76	TIPO_0506	TIPO_0506	f	0	\N	\N	f	f	245	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.openlinksw.com/schemas/virtrdf#qsDefaultMap	2	\N	17	qsDefaultMap	qsDefaultMap	f	2	\N	\N	f	f	237	236	\N	t	f	\N	\N	\N	t	f	f
30	http://www.openlinksw.com/schemas/virtrdf#qmvcAlias	8	\N	17	qmvcAlias	qmvcAlias	f	0	\N	\N	f	f	141	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	18	\N	2	subPropertyOf	subPropertyOf	f	18	\N	\N	f	f	329	329	\N	t	f	\N	\N	\N	t	f	f
32	http://geo.linkeddata.es/recurso/btn100/cantera/ID_CODIGO	3546	\N	76	ID_CODIGO	ID_CODIGO	f	0	\N	\N	f	f	245	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://www.w3.org/2002/07/owl#sameAs	8738	\N	7	sameAs	sameAs	f	8738	\N	\N	f	f	164	219	\N	t	f	\N	\N	\N	t	f	f
34	http://www.openlinksw.com/schemas/virtrdf#qmfLongOfShortTmpl	31	\N	17	qmfLongOfShortTmpl	qmfLongOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfUriTmpl	2	\N	17	qmfExistingShortOfUriTmpl	qmfExistingShortOfUriTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://geo.linkeddata.es/def/btn100#codigoIATA	54	\N	72	codigoIATA	codigoIATA	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://www.openlinksw.com/schemas/virtrdf#qmvftConds	1	\N	17	qmvftConds	qmvftConds	f	1	\N	\N	f	f	179	36	\N	t	f	\N	\N	\N	t	f	f
38	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	595	\N	1	first	first	f	481	\N	\N	f	f	153	354	\N	t	f	\N	\N	\N	t	f	f
39	http://geo.linkeddata.es/def/btn100#numeroDeVertice	11141	\N	72	numeroDeVertice	numeroDeVertice	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://geo.linkeddata.es/def/btn100#codigoDeEstacion	1654	\N	72	codigoDeEstacion	codigoDeEstacion	f	0	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://www.w3.org/ns/prov#used	2	\N	26	used	used	f	1	\N	\N	f	f	312	25	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/2002/07/owl#cardinality	25	\N	7	cardinality	cardinality	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrLanguage	1	\N	17	qmfValRange-rvrLanguage	qmfValRange-rvrLanguage	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/2000/01/rdf-schema#label	926532	\N	2	label	label	f	0	\N	\N	f	f	359	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/dc/terms/title	314232	\N	5	title	title	f	0	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.openlinksw.com/schemas/virtrdf#qmfBoolTmpl	26	\N	17	qmfBoolTmpl	qmfBoolTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://www.openlinksw.com/schemas/virtrdf#qmfName	82	\N	17	qmfName	qmfName	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfUriTmpl	26	\N	17	qmfShortOfUriTmpl	qmfShortOfUriTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.geonames.org/ontology#population	79612	\N	71	population	population	f	0	\N	\N	f	f	166	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://purl.org/dc/elements/1.1/title	1	\N	6	title	title	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/ns/prov#wasAssociatedWith	1	\N	26	wasAssociatedWith	wasAssociatedWith	f	1	\N	\N	f	f	312	324	\N	t	f	\N	\N	\N	t	f	f
51	http://geo.linkeddata.es/def/btn100#anchoDeVia	4512	\N	72	anchoDeVia	anchoDeVia	f	4512	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://www.openlinksw.com/schemas/virtrdf#qmfUriOfShortTmpl	31	\N	17	qmfUriOfShortTmpl	qmfUriOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	588	\N	1	value	value	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://geo.linkeddata.es/def/btn100#situacionDeCauce	1939	\N	72	situacionDeCauce	situacionDeCauce	f	1939	\N	\N	f	f	131	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://www.openlinksw.com/schemas/virtrdf#qmfIsblankOfShortTmpl	26	\N	17	qmfIsblankOfShortTmpl	qmfIsblankOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://geo.linkeddata.es/ontology/tipoDeCalzada	9670	\N	74	tipoDeCalzada	tipoDeCalzada	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://www.w3.org/2003/01/geo/wgs84_pos#long	4289115	\N	25	long	long	f	0	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://www.openlinksw.com/schemas/virtrdf#inheritFrom	56	\N	17	inheritFrom	inheritFrom	f	56	\N	\N	f	f	288	288	\N	t	f	\N	\N	\N	t	f	f
59	http://www.openlinksw.com/schemas/virtrdf#qmfShortTmpl	26	\N	17	qmfShortTmpl	qmfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.openlinksw.com/schemas/virtrdf#qmPredicateMap	2	\N	17	qmPredicateMap	qmPredicateMap	f	2	\N	\N	f	f	236	251	\N	t	f	\N	\N	\N	t	f	f
61	http://geo.linkeddata.es/def/btn100#categoriaCurvaDeNivel	167602	\N	72	categoriaCurvaDeNivel	categoriaCurvaDeNivel	f	167602	\N	\N	f	f	359	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://www.openlinksw.com/schemas/virtrdf#loadAs	4	\N	17	loadAs	loadAs	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.openlinksw.com/schemas/virtrdf#qmvftTableName	1	\N	17	qmvftTableName	qmvftTableName	f	0	\N	\N	f	f	179	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://www.openlinksw.com/schemas/virtrdf#qmfLongTmpl	31	\N	17	qmfLongTmpl	qmfLongTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.openlinksw.com/schemas/virtrdf#item	89	\N	17	item	item	f	89	\N	\N	f	f	\N	288	\N	t	f	\N	\N	\N	t	f	f
66	http://www.openlinksw.com/schemas/virtrdf#qmvcColumnName	8	\N	17	qmvcColumnName	qmvcColumnName	f	0	\N	\N	f	f	141	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfLongTmpl	2	\N	17	qmfExistingShortOfLongTmpl	qmfExistingShortOfLongTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://www.openlinksw.com/schemas/virtrdf#qmvFText	2	\N	17	qmvFText	qmvFText	f	2	\N	\N	f	f	251	179	\N	t	f	\N	\N	\N	t	f	f
69	http://www.w3.org/ns/prov#wasDerivedFrom	1	\N	26	wasDerivedFrom	wasDerivedFrom	f	1	\N	\N	f	f	25	25	\N	t	f	\N	\N	\N	t	f	f
70	http://www.opengis.net/ont/geosparql/hasGeometry	6354	\N	75	hasGeometry	hasGeometry	f	6354	\N	\N	f	f	127	172	\N	t	f	\N	\N	\N	t	f	f
71	http://www.w3.org/ns/prov#wasRevisionOf	1	\N	26	wasRevisionOf	wasRevisionOf	f	1	\N	\N	f	f	25	25	\N	t	f	\N	\N	\N	t	f	f
72	http://www.openlinksw.com/schemas/virtrdf#qmfDtpOfNiceSqlval	4	\N	17	qmfDtpOfNiceSqlval	qmfDtpOfNiceSqlval	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://geo.linkeddata.es/def/btn100#tipoDeCapital	86173	\N	72	tipoDeCapital	tipoDeCapital	f	86173	\N	\N	f	f	166	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.openlinksw.com/schemas/virtrdf#qmSubjectMap	2	\N	17	qmSubjectMap	qmSubjectMap	f	2	\N	\N	f	f	236	251	\N	t	f	\N	\N	\N	t	f	f
75	http://www.w3.org/ns/prov#wasAttributedTo	2	\N	26	wasAttributedTo	wasAttributedTo	f	2	\N	\N	f	f	25	324	\N	t	f	\N	\N	\N	t	f	f
76	http://www.openlinksw.com/schemas/virtrdf#qmfSqlvalTmpl	31	\N	17	qmfSqlvalTmpl	qmfSqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://geo.linkeddata.es/def/btn100#productoFuente	7299	\N	72	productoFuente	productoFuente	f	7299	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/2002/07/owl#complementOf	12	\N	7	complementOf	complementOf	f	12	\N	\N	f	f	354	354	\N	t	f	\N	\N	\N	t	f	f
79	http://www.openlinksw.com/schemas/virtrdf#qmfOkForAnySqlvalue	26	\N	17	qmfOkForAnySqlvalue	qmfOkForAnySqlvalue	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://purl.org/dc/terms/replaces	32093	\N	5	replaces	replaces	f	0	\N	\N	f	f	144	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://geo.linkeddata.es/def/btn100#codigoEstacionGPS	45	\N	72	codigoEstacionGPS	codigoEstacionGPS	f	0	\N	\N	f	f	138	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://www.opengis.net/ont/geosparql/asGML	2653	\N	75	asGML	asGML	f	0	\N	\N	f	f	134	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://www.w3.org/2002/07/owl#intersectionOf	53	\N	7	intersectionOf	intersectionOf	f	53	\N	\N	f	f	354	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://geo.linkeddata.es/ontology/orden	4207095	\N	74	orden	orden	f	0	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://www.openlinksw.com/schemas/virtrdf#qmvColumns	8	\N	17	qmvColumns	qmvColumns	f	8	\N	\N	f	f	251	56	\N	t	f	\N	\N	\N	t	f	f
86	http://purl.org/dc/terms/ID	10030	\N	5	ID	ID	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfSqlvalTmpl	2	\N	17	qmfExistingShortOfSqlvalTmpl	qmfExistingShortOfSqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrDatatype	12	\N	17	qmfValRange-rvrDatatype	qmfValRange-rvrDatatype	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://www.openlinksw.com/schemas/virtrdf#qmf01uriOfShortTmpl	2	\N	17	qmf01uriOfShortTmpl	qmf01uriOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://www.w3.org/2000/01/rdf-schema#comment	206	\N	2	comment	comment	f	1	\N	\N	f	f	354	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://geo.linkeddata.es/def/btn100#estadoDeVia	4878	\N	72	estadoDeVia	estadoDeVia	f	4878	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://www.openlinksw.com/schemas/virtrdf#qmfDatatypeOfShortTmpl	26	\N	17	qmfDatatypeOfShortTmpl	qmfDatatypeOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://geo.linkeddata.es/def/btn100#electrificacion	4512	\N	72	electrificacion	electrificacion	f	4512	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://vocab.linkeddata.es/datosabiertos/def/sector-publico/territorio#codigoINE	69244	\N	77	codigoINE	codigoINE	f	0	\N	\N	f	f	315	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLong	8	\N	17	qmfIsSubformatOfLong	qmfIsSubformatOfLong	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://geo.linkeddata.es/def/btn100#codigoDeRio	33942	\N	72	codigoDeRio	codigoDeRio	f	0	\N	\N	f	f	119	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://geo.linkeddata.es/def/btn100#rutaTENT-T	9642	\N	72	rutaTENT-T	rutaTENT-T	f	9634	\N	\N	f	f	350	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://www.w3.org/2000/01/rdf-schema#domain	157	\N	2	domain	domain	f	157	\N	\N	f	f	231	354	\N	t	f	\N	\N	\N	t	f	f
99	http://www.openlinksw.com/schemas/virtrdf#qmvGeo	1	\N	17	qmvGeo	qmvGeo	f	1	\N	\N	f	f	251	179	\N	t	f	\N	\N	\N	t	f	f
100	http://geo.linkeddata.es/def/btn100#codigoINE	24991	\N	72	codigoINE	codigoINE	f	0	\N	\N	f	f	166	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLongWhenEqToSql	2	\N	17	qmfIsSubformatOfLongWhenEqToSql	qmfIsSubformatOfLongWhenEqToSql	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://www.w3.org/2003/01/geo/wgs84_pos#geometry	104214	\N	25	geometry	geometry	f	104214	\N	\N	f	f	77	22	\N	t	f	\N	\N	\N	t	f	f
103	http://www.w3.org/2002/07/owl#maxCardinality	2	\N	7	maxCardinality	maxCardinality	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLongWhenRef	4	\N	17	qmfIsSubformatOfLongWhenRef	qmfIsSubformatOfLongWhenRef	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://www.openlinksw.com/schemas/virtrdf#qmvATables	8	\N	17	qmvATables	qmvATables	f	8	\N	\N	f	f	251	187	\N	t	f	\N	\N	\N	t	f	f
106	http://www.openlinksw.com/schemas/virtrdf#qmMatchingFlags	2	\N	17	qmMatchingFlags	qmMatchingFlags	f	2	\N	\N	f	f	236	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://www.openlinksw.com/schemas/virtrdf#qmvftAlias	1	\N	17	qmvftAlias	qmvftAlias	f	0	\N	\N	f	f	179	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://www.w3.org/2002/07/owl#inverseOf	16	\N	7	inverseOf	inverseOf	f	16	\N	\N	f	f	329	329	\N	t	f	\N	\N	\N	t	f	f
109	http://www.w3.org/ns/prov#wasInformedBy	3	\N	26	wasInformedBy	wasInformedBy	f	3	\N	\N	f	f	312	312	\N	t	f	\N	\N	\N	t	f	f
110	http://geo.linkeddata.es/ontology/itinerarioEuropeo	9670	\N	74	itinerarioEuropeo	itinerarioEuropeo	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	595	\N	1	rest	rest	f	595	\N	\N	f	f	153	153	\N	t	f	\N	\N	\N	t	f	f
112	http://geo.linkeddata.es/def/btn100#altitud	631	\N	72	altitud	altitud	f	0	\N	\N	f	f	277	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://geo.linkeddata.es/def/btn100#tipoDeTramo	88493	\N	72	tipoDeTramo	tipoDeTramo	f	88493	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://www.openlinksw.com/schemas/virtrdf#qmfDatatypeTmpl	2	\N	17	qmfDatatypeTmpl	qmfDatatypeTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://www.openlinksw.com/schemas/virtrdf#qmfWrapDistinct	2	\N	17	qmfWrapDistinct	qmfWrapDistinct	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://geo.linkeddata.es/ontology/perteneceA	5162	\N	74	perteneceA	perteneceA	f	5162	\N	\N	f	f	127	219	\N	t	f	\N	\N	\N	t	f	f
117	http://geo.linkeddata.es/def/btn100#categoriaDeInteres	4708	\N	72	categoriaDeInteres	categoriaDeInteres	f	4708	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://www.openlinksw.com/schemas/virtrdf#qsUserMaps	2	\N	17	qsUserMaps	qsUserMaps	f	2	\N	\N	f	f	237	229	\N	t	f	\N	\N	\N	t	f	f
119	http://www.opengis.net/ont/geosparql#asWKT	873845	\N	25	asWKT	asWKT	f	0	\N	\N	f	f	238	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://www.openlinksw.com/schemas/virtrdf#qmfIidOfShortTmpl	35	\N	17	qmfIidOfShortTmpl	qmfIidOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://www.openlinksw.com/schemas/virtrdf#qmfStrsqlvalOfShortTmpl	31	\N	17	qmfStrsqlvalOfShortTmpl	qmfStrsqlvalOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfSqlvalTmpl	26	\N	17	qmfShortOfSqlvalTmpl	qmfShortOfSqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://code.google.com/p/map4rdf/wiki/ontology#facetPredicate	7	\N	73	facetPredicate	facetPredicate	f	7	\N	\N	f	f	171	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://www.openlinksw.com/schemas/virtrdf#qmfTypemaxTmpl	34	\N	17	qmfTypemaxTmpl	qmfTypemaxTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://www.openlinksw.com/schemas/virtrdf#qmfIsStable	34	\N	17	qmfIsStable	qmfIsStable	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://purl.org/NET/scovo#dataset	575	\N	70	dataset	dataset	f	575	\N	\N	f	f	94	70	\N	t	f	\N	\N	\N	t	f	f
127	http://www.w3.org/2002/07/owl#someValuesFrom	90	\N	7	someValuesFrom	someValuesFrom	f	90	\N	\N	f	f	14	354	\N	t	f	\N	\N	\N	t	f	f
128	http://www.w3.org/2002/07/owl#unionOf	111	\N	7	unionOf	unionOf	f	111	\N	\N	f	f	354	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://geo.linkeddata.es/def/geo_core#xETRS89	11186	\N	78	xETRS89	xETRS89	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://geo.linkeddata.es/def/btn100#ordenDeImportancia	73801	\N	72	ordenDeImportancia	ordenDeImportancia	f	73801	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://geo.linkeddata.es/def/btn100#competencia	83224	\N	72	competencia	competencia	f	83224	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://www.openlinksw.com/schemas/virtrdf#version	1	\N	17	version	version	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfNiceSqlvalTmpl	4	\N	17	qmfShortOfNiceSqlvalTmpl	qmfShortOfNiceSqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://www.openlinksw.com/schemas/virtrdf#qmvTableName	8	\N	17	qmvTableName	qmvTableName	f	0	\N	\N	f	f	251	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://www.openlinksw.com/schemas/virtrdf#qmfIsrefOfShortTmpl	26	\N	17	qmfIsrefOfShortTmpl	qmfIsrefOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://geo.linkeddata.es/def/btn100#estadoDeUso	102737	\N	72	estadoDeUso	estadoDeUso	f	102737	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://geo.linkeddata.es/def/geo_core#yETRS89	11186	\N	78	yETRS89	yETRS89	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://purl.org/dc/terms/identifier	852675	\N	5	identifier	identifier	f	0	\N	\N	f	f	359	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://geo.linkeddata.es/def/btn100#tieneAcceso	2012	\N	72	tieneAcceso	tieneAcceso	f	2012	\N	\N	f	f	358	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://www.openlinksw.com/schemas/virtrdf#qmfCustomString1	11	\N	17	qmfCustomString1	qmfCustomString1	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://purl.org/dc/elements/1.1/creator	2	\N	6	creator	creator	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://www.openlinksw.com/schemas/virtrdf#qmfColumnCount	26	\N	17	qmfColumnCount	qmfColumnCount	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://geo.linkeddata.es/def/btn100#competenciaAeroportuaria	631	\N	72	competenciaAeroportuaria	competenciaAeroportuaria	f	631	\N	\N	f	f	277	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://geo.linkeddata.es/ontology/tieneCapital	103	\N	74	tieneCapital	tieneCapital	f	103	\N	\N	f	f	219	164	\N	t	f	\N	\N	\N	t	f	f
147	http://purl.org/dc/elements/1.1/source	142	\N	6	source	source	f	0	\N	\N	f	f	354	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://www.w3.org/2002/07/owl#minCardinality	9	\N	7	minCardinality	minCardinality	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://geo.linkeddata.es/ontology/situacion	9670	\N	74	situacion	situacion	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://geo.linkeddata.es/def/btn100#calzada	88493	\N	72	calzada	calzada	f	88493	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://www.openlinksw.com/schemas/virtrdf#qmfIsuriOfShortTmpl	26	\N	17	qmfIsuriOfShortTmpl	qmfIsuriOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://www.openlinksw.com/schemas/virtrdf#qmvaAlias	2	\N	17	qmvaAlias	qmvaAlias	f	0	\N	\N	f	f	173	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://www.opengis.net/ont/geosparql#hasGeometry	869456	\N	25	hasGeometry	hasGeometry	f	869456	\N	\N	f	f	359	238	\N	t	f	\N	\N	\N	t	f	f
154	http://www.openlinksw.com/schemas/virtrdf#qmfIsBijection	34	\N	17	qmfIsBijection	qmfIsBijection	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfTypedsqlvalTmpl	26	\N	17	qmfShortOfTypedsqlvalTmpl	qmfShortOfTypedsqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://www.openlinksw.com/schemas/virtrdf#qsMatchingFlags	2	\N	17	qsMatchingFlags	qsMatchingFlags	f	2	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://geo.linkeddata.es/def/btn100#cota	221092	\N	72	cota	cota	f	0	\N	\N	f	f	359	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://www.w3.org/2002/07/owl#onClass	2	\N	7	onClass	onClass	f	2	\N	\N	f	f	14	354	\N	t	f	\N	\N	\N	t	f	f
159	http://www.openlinksw.com/schemas/virtrdf#qmfSuperFormats	82	\N	17	qmfSuperFormats	qmfSuperFormats	f	82	\N	\N	f	f	288	263	\N	t	f	\N	\N	\N	t	f	f
160	http://geo.linkeddata.es/ontology/estado	9670	\N	74	estado	estado	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.openlinksw.com/schemas/virtrdf#isSpecialPredicate	5	\N	17	isSpecialPredicate	isSpecialPredicate	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://www.w3.org/2000/01/rdf-schema#subClassOf	280	\N	2	subClassOf	subClassOf	f	280	\N	\N	f	f	354	354	\N	t	f	\N	\N	\N	t	f	f
163	http://geo.linkeddata.es/def/btn100#tipoDeItinerario	88493	\N	72	tipoDeItinerario	tipoDeItinerario	f	88493	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://www.w3.org/ns/prov#actedOnBehalfOf	1	\N	26	actedOnBehalfOf	actedOnBehalfOf	f	1	\N	\N	f	f	324	324	\N	t	f	\N	\N	\N	t	f	f
165	http://geo.linkeddata.es/ontology/tipoDeTramo	9670	\N	74	tipoDeTramo	tipoDeTramo	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://www.w3.org/2000/01/rdf-schema#range	112	\N	2	range	range	f	112	\N	\N	f	f	231	354	\N	t	f	\N	\N	\N	t	f	f
167	http://www.w3.org/2002/07/owl#oneOf	24	\N	7	oneOf	oneOf	f	24	\N	\N	f	f	211	153	\N	t	f	\N	\N	\N	t	f	f
168	http://purl.org/dc/elements/1.1/publisher	1	\N	6	publisher	publisher	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://geo.linkeddata.es/ontology/gml	17264	\N	74	gml	gml	f	0	\N	\N	f	f	175	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://geo.linkeddata.es/def/btn100#situacionDevia	4512	\N	72	situacionDevia	situacionDevia	f	4512	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://www.w3.org/ns/prov#wasGeneratedBy	1	\N	26	wasGeneratedBy	wasGeneratedBy	f	1	\N	\N	f	f	25	312	\N	t	f	\N	\N	\N	t	f	f
172	http://www.openlinksw.com/schemas/virtrdf#qmvaTableName	2	\N	17	qmvaTableName	qmvaTableName	f	0	\N	\N	f	f	173	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://geo.linkeddata.es/ontology/esCapitalDe	102	\N	74	esCapitalDe	esCapitalDe	f	102	\N	\N	f	f	164	219	\N	t	f	\N	\N	\N	t	f	f
174	http://geo.linkeddata.es/ontology/ordenDeImportancia	9670	\N	74	ordenDeImportancia	ordenDeImportancia	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://www.openlinksw.com/schemas/virtrdf#qmfIslitOfShortTmpl	26	\N	17	qmfIslitOfShortTmpl	qmfIslitOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://geo.linkeddata.es/def/btn100#regimen	38365	\N	72	regimen	regimen	f	38365	\N	\N	f	f	119	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://www.openlinksw.com/schemas/virtrdf#qmObjectMap	2	\N	17	qmObjectMap	qmObjectMap	f	2	\N	\N	f	f	236	251	\N	t	f	\N	\N	\N	t	f	f
178	http://geo.linkeddata.es/def/btn100#categoriaDeIsla	5398	\N	72	categoriaDeIsla	categoriaDeIsla	f	5398	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://geo.linkeddata.es/def/btn100#categoriaDeRio	16434	\N	72	categoriaDeRio	categoriaDeRio	f	15704	\N	\N	f	f	119	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://www.w3.org/2000/01/rdf-schema#seeAlso	6910	\N	2	seeAlso	seeAlso	f	6906	\N	\N	f	f	127	127	\N	t	f	\N	\N	\N	t	f	f
182	http://www.openlinksw.com/schemas/virtrdf#qmf01blankOfShortTmpl	2	\N	17	qmf01blankOfShortTmpl	qmf01blankOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://purl.org/NET/scovo#dimension	1150	\N	70	dimension	dimension	f	1150	\N	\N	f	f	94	219	\N	t	f	\N	\N	\N	t	f	f
184	http://geo.linkeddata.es/def/btn100#situacionDeVia	102902	\N	72	situacionDeVia	situacionDeVia	f	102902	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://www.w3.org/2002/07/owl#imports	8	\N	7	imports	imports	f	8	\N	\N	f	f	208	208	\N	t	f	\N	\N	\N	t	f	f
186	http://geo.linkeddata.es/ontology/formadoPor	4220408	\N	74	formadoPor	formadoPor	f	4220408	\N	\N	f	f	175	22	\N	t	f	\N	\N	\N	t	f	f
187	http://www.openlinksw.com/schemas/virtrdf#qmGraphMap	2	\N	17	qmGraphMap	qmGraphMap	f	2	\N	\N	f	f	236	251	\N	t	f	\N	\N	\N	t	f	f
188	http://www.openlinksw.com/schemas/virtrdf#qmvFormat	8	\N	17	qmvFormat	qmvFormat	f	8	\N	\N	f	f	251	288	\N	t	f	\N	\N	\N	t	f	f
189	http://www.w3.org/2003/01/geo/wgs84_pos#alt	11186	\N	25	alt	alt	f	0	\N	\N	f	f	192	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfTypedsqlvalTmpl	2	\N	17	qmfExistingShortOfTypedsqlvalTmpl	qmfExistingShortOfTypedsqlvalTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://geo.linkeddata.es/def/btn100#codigoICAO	105	\N	72	codigoICAO	codigoICAO	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://www.openlinksw.com/schemas/virtrdf#qmfCmpFuncName	34	\N	17	qmfCmpFuncName	qmfCmpFuncName	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	263	288	\N	t	f	\N	\N	\N	t	f	f
194	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	263	288	\N	t	f	\N	\N	\N	t	f	f
195	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	263	288	\N	t	f	\N	\N	\N	t	f	f
196	http://geo.linkeddata.es/ontology/formaParteDe	11928	\N	74	formaParteDe	formaParteDe	f	11928	\N	\N	f	f	164	219	\N	t	f	\N	\N	\N	t	f	f
197	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	56	\N	1	_1	_1	f	56	\N	\N	f	f	263	288	\N	t	f	\N	\N	\N	t	f	f
198	http://www.openlinksw.com/schemas/virtrdf#qmfLanguageOfShortTmpl	26	\N	17	qmfLanguageOfShortTmpl	qmfLanguageOfShortTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	263	288	\N	t	f	\N	\N	\N	t	f	f
200	http://geo.linkeddata.es/def/btn100#codigoBIC	45588	\N	72	codigoBIC	codigoBIC	f	0	\N	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://geo.linkeddata.es/def/btn100#unloCode	85	\N	72	unloCode	unloCode	f	0	\N	\N	f	f	297	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://geo.linkeddata.es/def/btn100#codigoDeVia	1194	\N	72	codigoDeVia	codigoDeVia	f	0	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://www.w3.org/2003/01/geo/wgs84_pos#lat	4289115	\N	25	lat	lat	f	0	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://www.openlinksw.com/schemas/virtrdf#qmfLanguageTmpl	2	\N	17	qmfLanguageTmpl	qmfLanguageTmpl	f	0	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://www.openlinksw.com/schemas/virtrdf#noInherit	44	\N	17	noInherit	noInherit	f	44	\N	\N	f	f	288	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://vocab.linkeddata.es/datosabiertos/def/urbanismo-infraestructuras/callejero#tipoVia	80673	\N	79	tipoVia	tipoVia	f	80673	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://www.w3.org/2002/07/owl#differentFrom	331	\N	7	differentFrom	differentFrom	f	331	\N	\N	f	f	77	77	\N	t	f	\N	\N	\N	t	f	f
208	http://geo.linkeddata.es/def/btn100#estadoDeLaExplotacionMinera	4872	\N	72	estadoDeLaExplotacionMinera	estadoDeLaExplotacionMinera	f	4872	\N	\N	f	f	245	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://www.w3.org/2002/07/owl#onProperty	189	\N	7	onProperty	onProperty	f	189	\N	\N	f	f	14	329	\N	t	f	\N	\N	\N	t	f	f
210	http://www.w3.org/2002/07/owl#allValuesFrom	61	\N	7	allValuesFrom	allValuesFrom	f	61	\N	\N	f	f	14	354	\N	t	f	\N	\N	\N	t	f	f
211	http://purl.org/dc/terms/created	866408	\N	5	created	created	f	0	\N	\N	f	f	359	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://geo.linkeddata.es/def/btn100#rutaTEN-T	87689	\N	72	rutaTEN-T	rutaTEN-T	f	87672	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	6129400	\N	1	type	type	f	6129400	\N	\N	f	f	22	354	\N	t	t	t	\N	t	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

COPY http_geo_linkeddata_es_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	196	8	is part of	en
2	196	8	forma parte de	es
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cc_rels_id_seq', 1, false);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.class_annots_id_seq', 1, false);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.classes_id_seq', 360, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cp_rels_id_seq', 2292, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cpc_rels_id_seq', 1578, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.datatypes_id_seq', 1, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.ns_id_seq', 79, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.properties_id_seq', 212, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

SELECT pg_catalog.setval('http_geo_linkeddata_es_sparql.property_annots_id_seq', 2, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_geo_linkeddata_es_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_geo_linkeddata_es_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_geo_linkeddata_es_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_geo_linkeddata_es_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_geo_linkeddata_es_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_geo_linkeddata_es_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_geo_linkeddata_es_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_geo_linkeddata_es_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_geo_linkeddata_es_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_geo_linkeddata_es_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_geo_linkeddata_es_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_geo_linkeddata_es_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_geo_linkeddata_es_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_geo_linkeddata_es_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_geo_linkeddata_es_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_geo_linkeddata_es_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_geo_linkeddata_es_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_geo_linkeddata_es_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_geo_linkeddata_es_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_geo_linkeddata_es_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_geo_linkeddata_es_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_geo_linkeddata_es_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_geo_linkeddata_es_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_geo_linkeddata_es_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_geo_linkeddata_es_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_geo_linkeddata_es_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_geo_linkeddata_es_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_geo_linkeddata_es_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_geo_linkeddata_es_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_geo_linkeddata_es_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_geo_linkeddata_es_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_geo_linkeddata_es_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_geo_linkeddata_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_geo_linkeddata_es_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_geo_linkeddata_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_geo_linkeddata_es_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_geo_linkeddata_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_geo_linkeddata_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_geo_linkeddata_es_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_geo_linkeddata_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_geo_linkeddata_es_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_geo_linkeddata_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_geo_linkeddata_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_geo_linkeddata_es_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_geo_linkeddata_es_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_geo_linkeddata_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_geo_linkeddata_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_geo_linkeddata_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_geo_linkeddata_es_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_geo_linkeddata_es_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_geo_linkeddata_es_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_geo_linkeddata_es_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_geo_linkeddata_es_sparql; Owner: -
--

ALTER TABLE ONLY http_geo_linkeddata_es_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_geo_linkeddata_es_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

