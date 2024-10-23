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
-- Name: http_foodie_cloud_catchrecord_norway; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_foodie_cloud_catchrecord_norway;


--
-- Name: SCHEMA http_foodie_cloud_catchrecord_norway; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_foodie_cloud_catchrecord_norway IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE FUNCTION http_foodie_cloud_catchrecord_norway.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE FUNCTION http_foodie_cloud_catchrecord_norway.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COMMENT ON TABLE http_foodie_cloud_catchrecord_norway._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COMMENT ON COLUMN http_foodie_cloud_catchrecord_norway.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_foodie_cloud_catchrecord_norway.classes c1
     JOIN http_foodie_cloud_catchrecord_norway.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_foodie_cloud_catchrecord_norway.properties p ON ((cp1.property_id = p.id)))
     JOIN http_foodie_cloud_catchrecord_norway.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_foodie_cloud_catchrecord_norway.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE TABLE http_foodie_cloud_catchrecord_norway.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE http_foodie_cloud_catchrecord_norway.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_catchrecord_norway.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_cc_rels AS
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
   FROM http_foodie_cloud_catchrecord_norway.cc_rels r,
    http_foodie_cloud_catchrecord_norway.classes c1,
    http_foodie_cloud_catchrecord_norway.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_classes_ns AS
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
    http_foodie_cloud_catchrecord_norway.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_foodie_cloud_catchrecord_norway.classes c
     LEFT JOIN http_foodie_cloud_catchrecord_norway.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_classes_ns_main AS
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
   FROM http_foodie_cloud_catchrecord_norway.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_foodie_cloud_catchrecord_norway.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_classes_ns_plus AS
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
    http_foodie_cloud_catchrecord_norway.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_foodie_cloud_catchrecord_norway.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_foodie_cloud_catchrecord_norway.classes c
     LEFT JOIN http_foodie_cloud_catchrecord_norway.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_classes_ns_main_plus AS
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
   FROM http_foodie_cloud_catchrecord_norway.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_foodie_cloud_catchrecord_norway.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_classes_ns_main_v01 AS
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
   FROM (http_foodie_cloud_catchrecord_norway.v_classes_ns v
     LEFT JOIN http_foodie_cloud_catchrecord_norway.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_cp_rels AS
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
    http_foodie_cloud_catchrecord_norway.tapprox((r.cnt)::integer) AS cnt_x,
    http_foodie_cloud_catchrecord_norway.tapprox(r.object_cnt) AS object_cnt_x,
    http_foodie_cloud_catchrecord_norway.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_foodie_cloud_catchrecord_norway.cp_rels r,
    http_foodie_cloud_catchrecord_norway.classes c,
    http_foodie_cloud_catchrecord_norway.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_cp_rels_card AS
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
   FROM http_foodie_cloud_catchrecord_norway.cp_rels r,
    http_foodie_cloud_catchrecord_norway.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_properties_ns AS
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
    http_foodie_cloud_catchrecord_norway.tapprox(p.cnt) AS cnt_x,
    http_foodie_cloud_catchrecord_norway.tapprox(p.object_cnt) AS object_cnt_x,
    http_foodie_cloud_catchrecord_norway.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_foodie_cloud_catchrecord_norway.properties p
     LEFT JOIN http_foodie_cloud_catchrecord_norway.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_cp_sources_single AS
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
   FROM ((http_foodie_cloud_catchrecord_norway.v_cp_rels_card r
     JOIN http_foodie_cloud_catchrecord_norway.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_foodie_cloud_catchrecord_norway.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_cp_targets_single AS
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
   FROM ((http_foodie_cloud_catchrecord_norway.v_cp_rels_card r
     JOIN http_foodie_cloud_catchrecord_norway.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_foodie_cloud_catchrecord_norway.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_foodie_cloud_catchrecord_norway.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_foodie_cloud_catchrecord_norway.pp_rels r,
    http_foodie_cloud_catchrecord_norway.properties p1,
    http_foodie_cloud_catchrecord_norway.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_properties_sources AS
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
   FROM (http_foodie_cloud_catchrecord_norway.v_properties_ns v
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
           FROM http_foodie_cloud_catchrecord_norway.cp_rels r,
            http_foodie_cloud_catchrecord_norway.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_properties_sources_single AS
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
   FROM (http_foodie_cloud_catchrecord_norway.v_properties_ns v
     LEFT JOIN http_foodie_cloud_catchrecord_norway.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_properties_targets AS
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
   FROM (http_foodie_cloud_catchrecord_norway.v_properties_ns v
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
           FROM http_foodie_cloud_catchrecord_norway.cp_rels r,
            http_foodie_cloud_catchrecord_norway.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE VIEW http_foodie_cloud_catchrecord_norway.v_properties_targets_single AS
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
   FROM (http_foodie_cloud_catchrecord_norway.v_properties_ns v
     LEFT JOIN http_foodie_cloud_catchrecord_norway.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	2	3	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://w3id.org/foodie/open/vessels#Vessel	6966	\N	t	70	Vessel	Vessel	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4633989
2	https://www.omg.org/spec/LCC/Countries/CountryRepresentation#CountrySubdivision	233	\N	t	71	CountrySubdivision	CountrySubdivision	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4811550
3	https://www.omg.org/spec/LCC/Countries/CountryRepresentation#GeographicRegionIdentifier	233	\N	t	71	GeographicRegionIdentifier	GeographicRegionIdentifier	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4811550
4	http://w3id.org/foodie/open/gear#Gear	47	\N	t	72	Gear	Gear	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14574480
5	http://www.fao.org/aims/aos/fi/species_taxonomic.owl#Species	146	\N	t	73	Species	Species	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
6	http://w3id.org/foodie/open/catchrecord/norway#ConservationMethod	36	\N	t	69	ConservationMethod	ConservationMethod	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
7	http://w3id.org/foodie/open/catchrecord/norway#Quality	14	\N	t	69	Quality	Quality	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
8	http://www.ontologydesignpatterns.org/cp/owl/fsdas/catchrecord.owl#CatchRecord	4858160	\N	t	74	CatchRecord	CatchRecord	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
9	http://w3id.org/foodie/open/catchrecord/norway#CatchUtilization	46	\N	t	69	CatchUtilization	CatchUtilization	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4846287
10	http://xmlns.com/foaf/0.1/Person	6057	\N	t	8	Person	Person	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4126683
11	http://w3id.org/foodie/open/FDIR#FdirSpecies	165	\N	t	75	FdirSpecies	FdirSpecies	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
12	http://www.opengis.net/ont/geosparql#Geometry	9716320	\N	t	25	Geometry	Geometry	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9716320
13	http://w3id.org/foodie/open/catchrecord/norway#ProductState	50	\N	t	69	ProductState	ProductState	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
14	http://w3id.org/foodie/open/catchrecord/norway#CatchSizeGroup	468	\N	t	69	CatchSizeGroup	CatchSizeGroup	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
15	http://w3id.org/foodie/open/catchrecord/norway#MainCatchArea	63	\N	t	69	MainCatchArea	MainCatchArea	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858158
16	http://xmlns.com/foaf/0.1/Organisation	6	\N	t	8	Organisation	Organisation	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
17	http://w3id.org/foodie/open/catchrecord/norway#CatchArea	976	\N	t	69	CatchArea	CatchArea	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4858160
18	http://xmlns.com/foaf/0.1/Agent	1246	\N	t	8	Agent	Agent	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4800720
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	8	1	2	3920663	\N	0	\N	\N	1	1	2	f	3920663	\N	\N
2	10	2	2	6754	\N	6754	\N	\N	1	1	2	f	0	\N	\N
3	2	2	1	6501	\N	6501	\N	\N	1	1	2	f	\N	10	\N
4	3	2	1	6501	\N	6501	\N	\N	0	1	2	f	\N	10	\N
5	8	3	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	17	\N
6	17	3	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
7	8	4	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	12	\N
8	12	4	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
9	2	5	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
10	3	5	2	233	\N	0	\N	\N	0	1	2	f	233	\N	\N
11	8	6	2	4846287	\N	4846287	\N	\N	1	1	2	f	0	9	\N
12	9	6	1	4846287	\N	4846287	\N	\N	1	1	2	f	\N	8	\N
13	8	7	2	4636060	\N	0	\N	\N	1	1	2	f	4636060	\N	\N
14	8	8	2	3920663	\N	0	\N	\N	1	1	2	f	3920663	\N	\N
15	8	9	2	3567763	\N	0	\N	\N	1	1	2	f	3567763	\N	\N
16	1	10	2	4887	\N	0	\N	\N	1	1	2	f	4887	\N	\N
17	8	11	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	6	\N
18	6	11	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
19	8	12	2	4126683	\N	4126683	\N	\N	1	1	2	f	0	10	\N
20	10	12	1	4126683	\N	4126683	\N	\N	1	1	2	f	\N	8	\N
21	8	13	2	3920663	\N	0	\N	\N	1	1	2	f	3920663	\N	\N
22	8	14	2	4612342	\N	4612342	\N	\N	1	1	2	f	0	1	\N
23	1	14	1	4612342	\N	4612342	\N	\N	1	1	2	f	\N	8	\N
24	8	15	2	4800365	\N	4800365	\N	\N	1	1	2	f	0	\N	\N
25	8	16	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	12	\N
26	12	16	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
27	12	17	2	9560448	\N	0	\N	\N	1	1	2	f	9560448	\N	\N
28	8	18	2	4858160	\N	0	\N	\N	1	1	2	f	4858160	\N	\N
29	8	19	2	3920663	\N	0	\N	\N	1	1	2	f	3920663	\N	\N
30	8	20	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	7	\N
31	7	20	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
32	1	21	2	7711	\N	7711	\N	\N	1	1	2	f	0	1	\N
33	1	21	1	7711	\N	7711	\N	\N	1	1	2	f	\N	1	\N
34	8	22	2	3920663	\N	0	\N	\N	1	1	2	f	3920663	\N	\N
35	8	23	2	4858160	\N	0	\N	\N	1	1	2	f	4858160	\N	\N
36	8	24	2	4858158	\N	4858158	\N	\N	1	1	2	f	0	\N	\N
37	8	25	2	4858160	\N	0	\N	\N	1	1	2	f	4858160	\N	\N
38	8	26	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	4	\N
39	4	26	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
40	8	27	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	4	\N
41	4	27	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
42	12	28	2	9716320	\N	9716320	\N	\N	1	1	2	f	0	\N	\N
43	8	28	2	4858160	\N	4858160	\N	\N	2	1	2	f	0	\N	\N
44	1	28	2	6966	\N	6966	\N	\N	3	1	2	f	0	\N	\N
45	10	28	2	6057	\N	6057	\N	\N	4	1	2	f	0	\N	\N
46	18	28	2	1246	\N	1246	\N	\N	5	1	2	f	0	\N	\N
47	17	28	2	976	\N	976	\N	\N	6	1	2	f	0	\N	\N
48	14	28	2	468	\N	468	\N	\N	7	1	2	f	0	\N	\N
49	2	28	2	466	\N	466	\N	\N	8	1	2	f	0	\N	\N
50	11	28	2	165	\N	165	\N	\N	9	1	2	f	0	\N	\N
51	5	28	2	146	\N	146	\N	\N	10	1	2	f	0	\N	\N
52	15	28	2	63	\N	63	\N	\N	11	1	2	f	0	\N	\N
53	13	28	2	50	\N	50	\N	\N	12	1	2	f	0	\N	\N
54	4	28	2	47	\N	47	\N	\N	13	1	2	f	0	\N	\N
55	9	28	2	46	\N	46	\N	\N	14	1	2	f	0	\N	\N
56	6	28	2	36	\N	36	\N	\N	15	1	2	f	0	\N	\N
57	7	28	2	14	\N	14	\N	\N	16	1	2	f	0	\N	\N
58	16	28	2	6	\N	6	\N	\N	17	1	2	f	0	\N	\N
59	3	28	2	466	\N	466	\N	\N	0	1	2	f	0	\N	\N
60	8	29	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	11	\N
61	11	29	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
62	8	30	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	4	\N
63	4	30	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
64	8	31	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	5	\N
65	5	31	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
66	8	32	2	3984678	\N	0	\N	\N	1	1	2	f	3984678	\N	\N
67	8	33	2	3054865	\N	0	\N	\N	1	1	2	f	3054865	\N	\N
68	1	34	2	6968	\N	6968	\N	\N	1	1	2	f	0	1	\N
69	1	34	1	6968	\N	6968	\N	\N	1	1	2	f	\N	1	\N
70	8	35	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	13	\N
71	13	35	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
72	8	36	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	\N	\N
73	1	37	2	6968	\N	6968	\N	\N	1	1	2	f	0	1	\N
74	1	37	1	6968	\N	6968	\N	\N	1	1	2	f	\N	1	\N
75	8	38	2	4858158	\N	4858158	\N	\N	1	1	2	f	0	15	\N
76	15	38	1	4858158	\N	4858158	\N	\N	1	1	2	f	\N	8	\N
77	8	39	2	4614232	\N	0	\N	\N	1	1	2	f	4614232	\N	\N
78	5	40	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
79	8	41	2	1408296	\N	0	\N	\N	1	1	2	f	1408296	\N	\N
80	8	42	2	4858160	\N	0	\N	\N	1	1	2	f	4858160	\N	\N
81	1	42	2	6966	\N	0	\N	\N	2	1	2	f	6966	\N	\N
82	10	42	2	6057	\N	0	\N	\N	3	1	2	f	6057	\N	\N
83	18	42	2	1246	\N	0	\N	\N	4	1	2	f	1246	\N	\N
84	17	42	2	976	\N	0	\N	\N	5	1	2	f	976	\N	\N
85	14	42	2	468	\N	0	\N	\N	6	1	2	f	468	\N	\N
86	15	42	2	63	\N	0	\N	\N	7	1	2	f	63	\N	\N
87	13	42	2	50	\N	0	\N	\N	8	1	2	f	50	\N	\N
88	4	42	2	47	\N	0	\N	\N	9	1	2	f	47	\N	\N
89	9	42	2	46	\N	0	\N	\N	10	1	2	f	46	\N	\N
90	6	42	2	36	\N	0	\N	\N	11	1	2	f	36	\N	\N
91	7	42	2	14	\N	0	\N	\N	12	1	2	f	14	\N	\N
92	16	42	2	6	\N	0	\N	\N	13	1	2	f	6	\N	\N
93	8	43	2	2624078	\N	0	\N	\N	1	1	2	f	2624078	\N	\N
94	8	44	2	4800720	\N	4800720	\N	\N	1	1	2	f	0	18	\N
95	18	44	1	4800720	\N	4800720	\N	\N	1	1	2	f	\N	8	\N
96	8	45	2	4805049	\N	4805049	\N	\N	1	1	2	f	0	2	\N
97	2	45	1	4805049	\N	4805049	\N	\N	1	1	2	f	\N	8	\N
98	3	45	1	4805049	\N	4805049	\N	\N	0	1	2	f	\N	8	\N
99	8	46	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	16	\N
100	16	46	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
101	8	47	2	4858160	\N	4858160	\N	\N	1	1	2	f	0	14	\N
102	14	47	1	4858160	\N	4858160	\N	\N	1	1	2	f	\N	8	\N
103	11	48	2	165	\N	0	\N	\N	1	1	2	f	165	\N	\N
104	1	49	2	8236	\N	0	\N	\N	1	1	2	f	8236	\N	\N
105	10	49	2	6057	\N	0	\N	\N	2	1	2	f	6057	\N	\N
106	18	49	2	1246	\N	0	\N	\N	3	1	2	f	1246	\N	\N
107	17	49	2	976	\N	0	\N	\N	4	1	2	f	976	\N	\N
108	14	49	2	468	\N	0	\N	\N	5	1	2	f	468	\N	\N
109	2	49	2	228	\N	0	\N	\N	6	1	2	f	228	\N	\N
110	11	49	2	165	\N	0	\N	\N	7	1	2	f	165	\N	\N
111	5	49	2	146	\N	0	\N	\N	8	1	2	f	146	\N	\N
112	15	49	2	63	\N	0	\N	\N	9	1	2	f	63	\N	\N
113	13	49	2	50	\N	0	\N	\N	10	1	2	f	50	\N	\N
114	4	49	2	47	\N	0	\N	\N	11	1	2	f	47	\N	\N
115	9	49	2	46	\N	0	\N	\N	12	1	2	f	46	\N	\N
116	6	49	2	36	\N	0	\N	\N	13	1	2	f	36	\N	\N
117	7	49	2	14	\N	0	\N	\N	14	1	2	f	14	\N	\N
118	16	49	2	6	\N	0	\N	\N	15	1	2	f	6	\N	\N
119	3	49	2	228	\N	0	\N	\N	0	1	2	f	228	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	2	2	6501	\N	1	\N
2	2	3	6501	\N	0	\N
3	3	10	6501	\N	1	\N
4	4	10	6501	\N	1	\N
5	5	17	4858160	\N	1	\N
6	6	8	4858160	\N	1	\N
7	7	12	4858160	\N	1	\N
8	8	8	4858160	\N	1	\N
9	11	9	4846287	\N	1	\N
10	12	8	4846287	\N	1	\N
11	17	6	4858160	\N	1	\N
12	18	8	4858160	\N	1	\N
13	19	10	4126683	\N	1	\N
14	20	8	4126683	\N	1	\N
15	22	1	4612342	\N	1	\N
16	23	8	4612342	\N	1	\N
17	25	12	4858160	\N	1	\N
18	26	8	4858160	\N	1	\N
19	30	7	4858160	\N	1	\N
20	31	8	4858160	\N	1	\N
21	32	1	7711	\N	1	\N
22	33	1	7711	\N	1	\N
23	38	4	4858160	\N	1	\N
24	39	8	4858160	\N	1	\N
25	40	4	4858160	\N	1	\N
26	41	8	4858160	\N	1	\N
27	60	11	4858160	\N	1	\N
28	61	8	4858160	\N	1	\N
29	62	4	4858160	\N	1	\N
30	63	8	4858160	\N	1	\N
31	64	5	4858160	\N	1	\N
32	65	8	4858160	\N	1	\N
33	68	1	6968	\N	1	\N
34	69	1	6968	\N	1	\N
35	70	13	4858160	\N	1	\N
36	71	8	4858160	\N	1	\N
37	73	1	6968	\N	1	\N
38	74	1	6968	\N	1	\N
39	75	15	4858158	\N	1	\N
40	76	8	4858158	\N	1	\N
41	94	18	4800720	\N	1	\N
42	95	8	4800720	\N	1	\N
43	96	2	4805049	\N	1	\N
44	96	3	4805049	\N	0	\N
45	97	8	4805049	\N	1	\N
46	98	8	4805049	\N	1	\N
47	99	16	4858160	\N	1	\N
48	100	8	4858160	\N	1	\N
49	101	14	4858160	\N	1	\N
50	102	8	4858160	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#integer	3	integer
2	http://www.w3.org/2001/XMLSchema#string	3	string
3	http://www.w3.org/2001/XMLSchema#Geometry	3	Geometry
4	http://www.w3.org/2001/XMLSchema#dateTime	3	dateTime
5	http://www.w3.org/2001/XMLSchema#datetime	3	datetime
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
72	n_3	http://w3id.org/foodie/open/gear#	0	f	0
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
69		http://w3id.org/foodie/open/catchrecord/norway#	0	t	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
70	n_1	http://w3id.org/foodie/open/vessels#	0	f	0
71	n_2	https://www.omg.org/spec/LCC/Countries/CountryRepresentation#	0	f	0
73	n_4	http://www.fao.org/aims/aos/fi/species_taxonomic.owl#	0	f	0
74	n_5	http://www.ontologydesignpatterns.org/cp/owl/fsdas/catchrecord.owl#	0	f	0
75	n_6	http://w3id.org/foodie/open/FDIR#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
210	instance_name_pattern	\N	\N	Default pattern for instance name presentation in visual query fields. Work in progress. Can be overriden on individual class level. Leave empty to present instances by their URIs.	10
330	use_instance_table	\N	\N	Mark, if a dedicated instance table is installed within the data schema (requires a custom solution).	8
230	instance_lookup_mode	\N	\N	table - use instances table, default - use data endpoint	19
250	direct_class_role	\N	\N	Default property to be used for instance-to-class relationship. Leave empty in the most typical case of the property being rdf:type.	5
260	indirect_class_role	\N	\N	Fill in, if an indirect class membership is to be used in the environment, along with the direct membership (normally leave empty).	6
20	schema_description	\N	\N	Description of the schema.	2
100	tree_profile_name	\N	\N	Look up public tree profile by this name (mutually exclusive with local tree_profile).	14
110	tree_profile	\N	\N	A custom configuration of the entity lookup pane tree (copy the initial value from the parameters of a similar schema).	11
220	show_instance_tab	\N	\N	Show instance tab in the entity lookup pane in the visual environment.	15
60	endpoint_public_url	\N	\N	Human readable web site of the endpoint, if available.	16
10	display_name_default	http_foodie_cloud_catchrecord_norway	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_foodie_cloud_catchrecord_norway	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://www.foodie-cloud.org/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
40	named_graph	http://w3id.org/foodie/open/catchrecord/norway/	\N	Default named graph for visual environment projects using this schema.	4
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"graphName": "http://w3id.org/foodie/open/catchrecord/norway/", "endpointUrl": "https://www.foodie-cloud.org/sparql", "correlationId": "8814414587097083694", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "propertyLevelOnly", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "propertyLevelOnly", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": true, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:32:35.697Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	31
240	use_pp_rels	\N	true	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	1	100000	\N	100000
2	5	2	233	\N	233
3	7	1	100000	\N	100000
4	8	1	100000	\N	100000
5	9	1	100000	\N	100000
6	10	2	4887	\N	4887
7	13	1	100000	\N	100000
8	17	3	100000	\N	100000
9	18	1	100000	\N	100000
10	19	1	100000	\N	100000
11	22	1	100000	\N	100000
12	23	4	100000	\N	100000
13	25	4	100000	\N	100000
14	32	1	100000	\N	100000
15	33	2	100000	\N	100000
16	39	5	100000	\N	100000
17	41	1	100000	\N	100000
18	42	2	100000	\N	100000
19	43	1	100000	\N	100000
20	48	2	165	\N	165
21	49	2	17784	\N	17784
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
1	1	42	2	1000000	\N	1000000
2	1	13	2	1000000	\N	1000000
3	1	18	2	1000000	\N	1000000
4	1	23	2	1000000	\N	1000000
5	1	47	2	1000000	\N	1000000
6	1	6	2	1000000	\N	1000000
7	1	11	2	1000000	\N	1000000
8	1	25	2	1000000	\N	1000000
9	1	3	2	1000000	\N	1000000
10	1	38	2	1000000	\N	1000000
11	1	29	2	1000000	\N	1000000
12	1	36	2	1000000	\N	1000000
13	1	19	2	1000000	\N	1000000
14	1	35	2	1000000	\N	1000000
15	1	20	2	1000000	\N	1000000
16	1	46	2	1000000	\N	1000000
17	1	1	2	1000000	\N	1000000
18	1	8	2	1000000	\N	1000000
19	1	22	2	1000000	\N	1000000
20	1	32	2	1000000	\N	1000000
21	1	26	2	1000000	\N	1000000
22	1	30	2	1000000	\N	1000000
23	1	27	2	1000000	\N	1000000
24	1	24	2	1000000	\N	1000000
25	1	31	2	1000000	\N	1000000
26	1	16	2	1000000	\N	1000000
27	1	4	2	1000000	\N	1000000
28	1	28	2	1000000	\N	1000000
29	1	39	2	986783	\N	1000000
30	1	44	2	986288	\N	1000000
31	1	45	2	985685	\N	1000000
32	1	15	2	985460	\N	1000000
33	1	14	2	956677	\N	1000000
34	1	7	2	947086	\N	1000000
35	1	9	2	922919	\N	1000000
36	1	12	2	840390	\N	1000000
37	1	43	2	719339	\N	1000000
38	1	33	2	674656	\N	1000000
39	1	41	2	325785	\N	1000000
40	2	28	1	446	\N	\N
41	2	5	1	223	\N	\N
42	2	49	1	222	\N	\N
43	2	45	3	4802982	\N	\N
44	2	2	3	6754	\N	\N
45	2	2	2	6754	\N	\N
46	2	42	2	6056	\N	\N
47	2	28	2	6056	\N	\N
48	2	49	2	6056	\N	\N
49	3	42	1	976	\N	\N
50	3	28	1	976	\N	\N
51	3	49	1	976	\N	\N
52	3	3	3	4858160	\N	\N
53	3	42	2	1000000	\N	1000000
54	3	18	2	1000000	\N	1000000
55	3	23	2	1000000	\N	1000000
56	3	47	2	1000000	\N	1000000
57	3	11	2	1000000	\N	1000000
58	3	25	2	1000000	\N	1000000
59	3	3	2	1000000	\N	1000000
60	3	38	2	1000000	\N	1000000
61	3	29	2	1000000	\N	1000000
62	3	36	2	1000000	\N	1000000
63	3	35	2	1000000	\N	1000000
64	3	20	2	1000000	\N	1000000
65	3	46	2	1000000	\N	1000000
66	3	26	2	1000000	\N	1000000
67	3	30	2	1000000	\N	1000000
68	3	27	2	1000000	\N	1000000
69	3	24	2	1000000	\N	1000000
70	3	31	2	1000000	\N	1000000
71	3	16	2	1000000	\N	1000000
72	3	4	2	1000000	\N	1000000
73	3	28	2	1000000	\N	1000000
74	3	6	2	994701	\N	1000000
75	3	45	2	988660	\N	1000000
76	3	15	2	988458	\N	1000000
77	3	44	2	987688	\N	1000000
78	3	7	2	964138	\N	1000000
79	3	14	2	940120	\N	1000000
80	3	39	2	921676	\N	1000000
81	3	12	2	861281	\N	1000000
82	3	32	2	644293	\N	1000000
83	3	13	2	630415	\N	1000000
84	3	19	2	630415	\N	1000000
85	3	1	2	630415	\N	1000000
86	3	8	2	630415	\N	1000000
87	3	22	2	630415	\N	1000000
88	3	33	2	624822	\N	1000000
89	3	9	2	595395	\N	1000000
90	3	43	2	497696	\N	1000000
91	3	41	2	187833	\N	1000000
92	4	28	1	4858160	\N	\N
93	4	17	1	4775378	\N	\N
94	4	4	3	4858160	\N	\N
95	4	42	2	1000000	\N	1000000
96	4	18	2	1000000	\N	1000000
97	4	23	2	1000000	\N	1000000
98	4	47	2	1000000	\N	1000000
99	4	11	2	1000000	\N	1000000
100	4	25	2	1000000	\N	1000000
101	4	3	2	1000000	\N	1000000
102	4	38	2	1000000	\N	1000000
103	4	29	2	1000000	\N	1000000
104	4	36	2	1000000	\N	1000000
105	4	35	2	1000000	\N	1000000
106	4	20	2	1000000	\N	1000000
107	4	46	2	1000000	\N	1000000
108	4	26	2	1000000	\N	1000000
109	4	30	2	1000000	\N	1000000
110	4	27	2	1000000	\N	1000000
111	4	24	2	1000000	\N	1000000
112	4	31	2	1000000	\N	1000000
113	4	16	2	1000000	\N	1000000
114	4	4	2	1000000	\N	1000000
115	4	28	2	1000000	\N	1000000
116	4	6	2	994701	\N	1000000
117	4	45	2	988660	\N	1000000
118	4	15	2	988458	\N	1000000
119	4	44	2	987688	\N	1000000
120	4	7	2	964138	\N	1000000
121	4	14	2	940120	\N	1000000
122	4	39	2	921676	\N	1000000
123	4	12	2	861281	\N	1000000
124	4	32	2	644293	\N	1000000
125	4	13	2	630415	\N	1000000
126	4	19	2	630415	\N	1000000
127	4	1	2	630415	\N	1000000
128	4	8	2	630415	\N	1000000
129	4	22	2	630415	\N	1000000
130	4	33	2	624822	\N	1000000
131	4	9	2	595395	\N	1000000
132	4	43	2	497696	\N	1000000
133	4	41	2	187833	\N	1000000
134	5	28	2	466	\N	\N
135	5	5	2	233	\N	\N
136	5	49	2	228	\N	\N
137	6	42	1	46	\N	\N
138	6	28	1	46	\N	\N
139	6	49	1	46	\N	\N
140	6	6	3	4846287	\N	\N
141	6	42	2	1000000	\N	1000000
142	6	18	2	1000000	\N	1000000
143	6	23	2	1000000	\N	1000000
144	6	47	2	1000000	\N	1000000
145	6	6	2	1000000	\N	1000000
146	6	11	2	1000000	\N	1000000
147	6	25	2	1000000	\N	1000000
148	6	3	2	1000000	\N	1000000
149	6	38	2	1000000	\N	1000000
150	6	29	2	1000000	\N	1000000
151	6	36	2	1000000	\N	1000000
152	6	35	2	1000000	\N	1000000
153	6	20	2	1000000	\N	1000000
154	6	46	2	1000000	\N	1000000
155	6	26	2	1000000	\N	1000000
156	6	30	2	1000000	\N	1000000
157	6	27	2	1000000	\N	1000000
158	6	24	2	1000000	\N	1000000
159	6	31	2	1000000	\N	1000000
160	6	16	2	1000000	\N	1000000
161	6	4	2	1000000	\N	1000000
162	6	28	2	1000000	\N	1000000
163	6	45	2	988660	\N	1000000
164	6	15	2	988458	\N	1000000
165	6	44	2	987712	\N	1000000
166	6	7	2	964138	\N	1000000
167	6	14	2	944354	\N	1000000
168	6	39	2	926830	\N	1000000
169	6	12	2	865135	\N	1000000
170	6	32	2	648340	\N	1000000
171	6	13	2	634462	\N	1000000
172	6	19	2	634462	\N	1000000
173	6	1	2	634462	\N	1000000
174	6	8	2	634462	\N	1000000
175	6	22	2	634462	\N	1000000
176	6	33	2	624822	\N	1000000
177	6	9	2	599316	\N	1000000
178	6	43	2	501743	\N	1000000
179	6	41	2	191880	\N	1000000
180	7	42	2	4636060	\N	\N
181	7	18	2	4636060	\N	\N
182	7	23	2	4636060	\N	\N
183	7	47	2	4636060	\N	\N
184	7	11	2	4636060	\N	\N
185	7	25	2	4636060	\N	\N
186	7	3	2	4636060	\N	\N
187	7	29	2	4636060	\N	\N
188	7	36	2	4636060	\N	\N
189	7	7	2	4636060	\N	\N
190	7	35	2	4636060	\N	\N
191	7	20	2	4636060	\N	\N
192	7	46	2	4636060	\N	\N
193	7	26	2	4636060	\N	\N
194	7	30	2	4636060	\N	\N
195	7	27	2	4636060	\N	\N
196	7	31	2	4636060	\N	\N
197	7	16	2	4636060	\N	\N
198	7	4	2	4636060	\N	\N
199	7	28	2	4636060	\N	\N
200	7	38	2	4636058	\N	\N
201	7	24	2	4636058	\N	\N
202	7	6	2	4624187	\N	\N
203	7	45	2	4583306	\N	\N
204	7	44	2	4578921	\N	\N
205	7	15	2	4578647	\N	\N
206	7	14	2	4400943	\N	\N
207	7	39	2	4396479	\N	\N
208	7	12	2	3929807	\N	\N
209	7	32	2	3762592	\N	\N
210	7	13	2	3702911	\N	\N
211	7	19	2	3702911	\N	\N
212	7	1	2	3702911	\N	\N
213	7	8	2	3702911	\N	\N
214	7	22	2	3702911	\N	\N
215	7	9	2	3353810	\N	\N
216	7	33	2	2851103	\N	\N
217	7	43	2	2477411	\N	\N
218	7	41	2	1396606	\N	\N
219	8	42	2	1000000	\N	1000000
220	8	13	2	1000000	\N	1000000
221	8	18	2	1000000	\N	1000000
222	8	23	2	1000000	\N	1000000
223	8	47	2	1000000	\N	1000000
224	8	6	2	1000000	\N	1000000
225	8	11	2	1000000	\N	1000000
226	8	25	2	1000000	\N	1000000
227	8	3	2	1000000	\N	1000000
228	8	38	2	1000000	\N	1000000
229	8	29	2	1000000	\N	1000000
230	8	36	2	1000000	\N	1000000
231	8	19	2	1000000	\N	1000000
232	8	35	2	1000000	\N	1000000
233	8	20	2	1000000	\N	1000000
234	8	46	2	1000000	\N	1000000
235	8	1	2	1000000	\N	1000000
236	8	8	2	1000000	\N	1000000
237	8	22	2	1000000	\N	1000000
238	8	32	2	1000000	\N	1000000
239	8	26	2	1000000	\N	1000000
240	8	30	2	1000000	\N	1000000
241	8	27	2	1000000	\N	1000000
242	8	24	2	1000000	\N	1000000
243	8	31	2	1000000	\N	1000000
244	8	16	2	1000000	\N	1000000
245	8	4	2	1000000	\N	1000000
246	8	28	2	1000000	\N	1000000
247	8	39	2	986783	\N	1000000
248	8	44	2	986288	\N	1000000
249	8	45	2	985685	\N	1000000
250	8	15	2	985460	\N	1000000
251	8	14	2	956677	\N	1000000
252	8	7	2	947086	\N	1000000
253	8	9	2	922919	\N	1000000
254	8	12	2	840390	\N	1000000
255	8	43	2	719339	\N	1000000
256	8	33	2	674656	\N	1000000
257	8	41	2	325785	\N	1000000
258	9	42	2	1000000	\N	1000000
259	9	13	2	1000000	\N	1000000
260	9	18	2	1000000	\N	1000000
261	9	23	2	1000000	\N	1000000
262	9	47	2	1000000	\N	1000000
263	9	6	2	1000000	\N	1000000
264	9	9	2	1000000	\N	1000000
265	9	11	2	1000000	\N	1000000
266	9	25	2	1000000	\N	1000000
267	9	3	2	1000000	\N	1000000
268	9	29	2	1000000	\N	1000000
269	9	36	2	1000000	\N	1000000
270	9	19	2	1000000	\N	1000000
271	9	35	2	1000000	\N	1000000
272	9	20	2	1000000	\N	1000000
273	9	46	2	1000000	\N	1000000
274	9	39	2	1000000	\N	1000000
275	9	1	2	1000000	\N	1000000
276	9	8	2	1000000	\N	1000000
277	9	22	2	1000000	\N	1000000
278	9	32	2	1000000	\N	1000000
279	9	26	2	1000000	\N	1000000
280	9	30	2	1000000	\N	1000000
281	9	27	2	1000000	\N	1000000
282	9	31	2	1000000	\N	1000000
283	9	16	2	1000000	\N	1000000
284	9	4	2	1000000	\N	1000000
285	9	28	2	1000000	\N	1000000
286	9	38	2	999999	\N	1000000
287	9	24	2	999999	\N	1000000
288	9	45	2	994983	\N	1000000
289	9	44	2	994642	\N	1000000
290	9	15	2	994617	\N	1000000
291	9	14	2	955664	\N	1000000
292	9	7	2	910333	\N	1000000
293	9	12	2	822842	\N	1000000
294	9	43	2	676015	\N	1000000
295	9	33	2	629490	\N	1000000
296	9	41	2	380928	\N	1000000
297	10	49	2	6064	\N	\N
298	10	21	2	5645	\N	\N
299	10	34	2	4907	\N	\N
300	10	37	2	4907	\N	\N
301	10	10	2	4887	\N	\N
302	10	42	2	4874	\N	\N
303	10	28	2	4874	\N	\N
304	11	42	1	36	\N	\N
305	11	28	1	36	\N	\N
306	11	49	1	36	\N	\N
307	11	11	3	4858160	\N	\N
308	11	42	2	1000000	\N	1000000
309	11	18	2	1000000	\N	1000000
310	11	23	2	1000000	\N	1000000
311	11	47	2	1000000	\N	1000000
312	11	11	2	1000000	\N	1000000
313	11	25	2	1000000	\N	1000000
314	11	3	2	1000000	\N	1000000
315	11	38	2	1000000	\N	1000000
316	11	29	2	1000000	\N	1000000
317	11	36	2	1000000	\N	1000000
318	11	35	2	1000000	\N	1000000
319	11	20	2	1000000	\N	1000000
320	11	46	2	1000000	\N	1000000
321	11	26	2	1000000	\N	1000000
322	11	30	2	1000000	\N	1000000
323	11	27	2	1000000	\N	1000000
324	11	24	2	1000000	\N	1000000
325	11	31	2	1000000	\N	1000000
326	11	16	2	1000000	\N	1000000
327	11	4	2	1000000	\N	1000000
328	11	28	2	1000000	\N	1000000
329	11	6	2	994701	\N	1000000
330	11	45	2	988660	\N	1000000
331	11	15	2	988458	\N	1000000
332	11	44	2	987688	\N	1000000
333	11	7	2	964138	\N	1000000
334	11	14	2	940120	\N	1000000
335	11	39	2	921676	\N	1000000
336	11	12	2	861281	\N	1000000
337	11	32	2	644293	\N	1000000
338	11	13	2	630415	\N	1000000
339	11	19	2	630415	\N	1000000
340	11	1	2	630415	\N	1000000
341	11	8	2	630415	\N	1000000
342	11	22	2	630415	\N	1000000
343	11	33	2	624822	\N	1000000
344	11	9	2	595395	\N	1000000
345	11	43	2	497696	\N	1000000
346	11	41	2	187833	\N	1000000
347	12	2	1	6754	\N	\N
348	12	42	1	6057	\N	\N
349	12	28	1	6057	\N	\N
350	12	49	1	6057	\N	\N
351	12	12	3	4126683	\N	\N
352	12	42	2	1000000	\N	1000000
353	12	18	2	1000000	\N	1000000
354	12	23	2	1000000	\N	1000000
355	12	47	2	1000000	\N	1000000
356	12	11	2	1000000	\N	1000000
357	12	25	2	1000000	\N	1000000
358	12	3	2	1000000	\N	1000000
359	12	12	2	1000000	\N	1000000
360	12	38	2	1000000	\N	1000000
361	12	29	2	1000000	\N	1000000
362	12	36	2	1000000	\N	1000000
363	12	35	2	1000000	\N	1000000
364	12	20	2	1000000	\N	1000000
365	12	46	2	1000000	\N	1000000
366	12	26	2	1000000	\N	1000000
367	12	30	2	1000000	\N	1000000
368	12	27	2	1000000	\N	1000000
369	12	24	2	1000000	\N	1000000
370	12	31	2	1000000	\N	1000000
371	12	16	2	1000000	\N	1000000
372	12	4	2	1000000	\N	1000000
373	12	28	2	1000000	\N	1000000
374	12	6	2	999238	\N	1000000
375	12	14	2	995844	\N	1000000
376	12	44	2	990346	\N	1000000
377	12	45	2	989003	\N	1000000
378	12	15	2	988717	\N	1000000
379	12	7	2	968860	\N	1000000
380	12	39	2	923345	\N	1000000
381	12	33	2	653794	\N	1000000
382	12	32	2	649878	\N	1000000
383	12	13	2	642988	\N	1000000
384	12	19	2	642988	\N	1000000
385	12	1	2	642988	\N	1000000
386	12	8	2	642988	\N	1000000
387	12	22	2	642988	\N	1000000
388	12	9	2	610914	\N	1000000
389	12	43	2	446627	\N	1000000
390	12	41	2	176138	\N	1000000
391	13	42	2	1000000	\N	1000000
392	13	13	2	1000000	\N	1000000
393	13	18	2	1000000	\N	1000000
394	13	23	2	1000000	\N	1000000
395	13	47	2	1000000	\N	1000000
396	13	6	2	1000000	\N	1000000
397	13	11	2	1000000	\N	1000000
398	13	25	2	1000000	\N	1000000
399	13	3	2	1000000	\N	1000000
400	13	29	2	1000000	\N	1000000
401	13	36	2	1000000	\N	1000000
402	13	19	2	1000000	\N	1000000
403	13	35	2	1000000	\N	1000000
404	13	20	2	1000000	\N	1000000
405	13	46	2	1000000	\N	1000000
406	13	1	2	1000000	\N	1000000
407	13	8	2	1000000	\N	1000000
408	13	22	2	1000000	\N	1000000
409	13	32	2	1000000	\N	1000000
410	13	26	2	1000000	\N	1000000
411	13	30	2	1000000	\N	1000000
412	13	27	2	1000000	\N	1000000
413	13	31	2	1000000	\N	1000000
414	13	16	2	1000000	\N	1000000
415	13	4	2	1000000	\N	1000000
416	13	28	2	1000000	\N	1000000
417	13	38	2	999999	\N	1000000
418	13	24	2	999999	\N	1000000
419	13	45	2	998009	\N	1000000
420	13	44	2	997722	\N	1000000
421	13	15	2	997586	\N	1000000
422	13	14	2	967194	\N	1000000
423	13	7	2	938387	\N	1000000
424	13	39	2	933747	\N	1000000
425	13	12	2	792905	\N	1000000
426	13	43	2	763578	\N	1000000
427	13	9	2	649963	\N	1000000
428	13	41	2	565733	\N	1000000
429	13	33	2	450692	\N	1000000
430	14	49	1	8205	\N	\N
431	14	21	1	7711	\N	\N
432	14	34	1	6968	\N	\N
433	14	37	1	6968	\N	\N
434	14	42	1	6935	\N	\N
435	14	28	1	6935	\N	\N
436	14	10	1	4887	\N	\N
437	14	14	3	4612342	\N	\N
438	14	42	2	1000000	\N	1000000
439	14	18	2	1000000	\N	1000000
440	14	23	2	1000000	\N	1000000
441	14	47	2	1000000	\N	1000000
442	14	11	2	1000000	\N	1000000
443	14	25	2	1000000	\N	1000000
444	14	3	2	1000000	\N	1000000
445	14	38	2	1000000	\N	1000000
446	14	14	2	1000000	\N	1000000
447	14	29	2	1000000	\N	1000000
448	14	36	2	1000000	\N	1000000
449	14	35	2	1000000	\N	1000000
450	14	20	2	1000000	\N	1000000
451	14	46	2	1000000	\N	1000000
452	14	26	2	1000000	\N	1000000
453	14	30	2	1000000	\N	1000000
454	14	27	2	1000000	\N	1000000
455	14	24	2	1000000	\N	1000000
456	14	31	2	1000000	\N	1000000
457	14	16	2	1000000	\N	1000000
458	14	4	2	1000000	\N	1000000
459	14	28	2	1000000	\N	1000000
460	14	6	2	999277	\N	1000000
461	14	45	2	988660	\N	1000000
462	14	15	2	988374	\N	1000000
463	14	44	2	987851	\N	1000000
464	14	7	2	966576	\N	1000000
465	14	39	2	927525	\N	1000000
466	14	12	2	912876	\N	1000000
467	14	32	2	649459	\N	1000000
468	14	13	2	642569	\N	1000000
469	14	19	2	642569	\N	1000000
470	14	1	2	642569	\N	1000000
471	14	8	2	642569	\N	1000000
472	14	22	2	642569	\N	1000000
473	14	33	2	632977	\N	1000000
474	14	9	2	605694	\N	1000000
475	14	43	2	494042	\N	1000000
476	14	41	2	197686	\N	1000000
477	15	15	3	4800365	\N	\N
478	15	42	2	1000000	\N	1000000
479	15	18	2	1000000	\N	1000000
480	15	23	2	1000000	\N	1000000
481	15	47	2	1000000	\N	1000000
482	15	6	2	1000000	\N	1000000
483	15	11	2	1000000	\N	1000000
484	15	25	2	1000000	\N	1000000
485	15	3	2	1000000	\N	1000000
486	15	29	2	1000000	\N	1000000
487	15	36	2	1000000	\N	1000000
488	15	45	2	1000000	\N	1000000
489	15	15	2	1000000	\N	1000000
490	15	35	2	1000000	\N	1000000
491	15	20	2	1000000	\N	1000000
492	15	46	2	1000000	\N	1000000
493	15	26	2	1000000	\N	1000000
494	15	30	2	1000000	\N	1000000
495	15	27	2	1000000	\N	1000000
496	15	31	2	1000000	\N	1000000
497	15	16	2	1000000	\N	1000000
498	15	4	2	1000000	\N	1000000
499	15	28	2	1000000	\N	1000000
500	15	38	2	999998	\N	1000000
501	15	24	2	999998	\N	1000000
502	15	44	2	996636	\N	1000000
503	15	7	2	995645	\N	1000000
504	15	14	2	987904	\N	1000000
505	15	39	2	880561	\N	1000000
506	15	13	2	843031	\N	1000000
507	15	19	2	843031	\N	1000000
508	15	1	2	843031	\N	1000000
509	15	8	2	843031	\N	1000000
510	15	22	2	843031	\N	1000000
511	15	32	2	843031	\N	1000000
512	15	43	2	843022	\N	1000000
513	15	41	2	843022	\N	1000000
514	15	12	2	757371	\N	1000000
515	15	9	2	531875	\N	1000000
516	15	33	2	9	\N	1000000
517	16	28	1	4858160	\N	\N
518	16	17	1	4775461	\N	\N
519	16	16	3	4858160	\N	\N
520	16	42	2	1000000	\N	1000000
521	16	18	2	1000000	\N	1000000
522	16	23	2	1000000	\N	1000000
523	16	47	2	1000000	\N	1000000
524	16	11	2	1000000	\N	1000000
525	16	25	2	1000000	\N	1000000
526	16	3	2	1000000	\N	1000000
527	16	38	2	1000000	\N	1000000
528	16	29	2	1000000	\N	1000000
529	16	36	2	1000000	\N	1000000
530	16	35	2	1000000	\N	1000000
531	16	20	2	1000000	\N	1000000
532	16	46	2	1000000	\N	1000000
533	16	26	2	1000000	\N	1000000
534	16	30	2	1000000	\N	1000000
535	16	27	2	1000000	\N	1000000
536	16	24	2	1000000	\N	1000000
537	16	31	2	1000000	\N	1000000
538	16	16	2	1000000	\N	1000000
539	16	4	2	1000000	\N	1000000
540	16	28	2	1000000	\N	1000000
541	16	45	2	997583	\N	1000000
542	16	15	2	997080	\N	1000000
543	16	44	2	996441	\N	1000000
544	16	6	2	996414	\N	1000000
545	16	14	2	955652	\N	1000000
546	16	7	2	955399	\N	1000000
547	16	39	2	945139	\N	1000000
548	16	32	2	856236	\N	1000000
549	16	13	2	833414	\N	1000000
550	16	19	2	833414	\N	1000000
551	16	1	2	833414	\N	1000000
552	16	8	2	833414	\N	1000000
553	16	22	2	833414	\N	1000000
554	16	12	2	783867	\N	1000000
555	16	9	2	695994	\N	1000000
556	16	43	2	667815	\N	1000000
557	16	33	2	519314	\N	1000000
558	16	41	2	369652	\N	1000000
559	17	28	2	9560448	\N	\N
560	17	17	2	9550839	\N	\N
561	18	42	2	1000000	\N	1000000
562	18	18	2	1000000	\N	1000000
563	18	23	2	1000000	\N	1000000
564	18	47	2	1000000	\N	1000000
565	18	11	2	1000000	\N	1000000
566	18	25	2	1000000	\N	1000000
567	18	3	2	1000000	\N	1000000
568	18	38	2	1000000	\N	1000000
569	18	29	2	1000000	\N	1000000
570	18	36	2	1000000	\N	1000000
571	18	35	2	1000000	\N	1000000
572	18	20	2	1000000	\N	1000000
573	18	46	2	1000000	\N	1000000
574	18	26	2	1000000	\N	1000000
575	18	30	2	1000000	\N	1000000
576	18	27	2	1000000	\N	1000000
577	18	24	2	1000000	\N	1000000
578	18	31	2	1000000	\N	1000000
579	18	16	2	1000000	\N	1000000
580	18	4	2	1000000	\N	1000000
581	18	28	2	1000000	\N	1000000
582	18	6	2	994701	\N	1000000
583	18	45	2	988660	\N	1000000
584	18	15	2	988458	\N	1000000
585	18	44	2	987688	\N	1000000
586	18	7	2	964138	\N	1000000
587	18	14	2	940120	\N	1000000
588	18	39	2	921676	\N	1000000
589	18	12	2	861281	\N	1000000
590	18	32	2	644293	\N	1000000
591	18	13	2	630415	\N	1000000
592	18	19	2	630415	\N	1000000
593	18	1	2	630415	\N	1000000
594	18	8	2	630415	\N	1000000
595	18	22	2	630415	\N	1000000
596	18	33	2	624822	\N	1000000
597	18	9	2	595395	\N	1000000
598	18	43	2	497696	\N	1000000
599	18	41	2	187833	\N	1000000
600	19	42	2	1000000	\N	1000000
601	19	13	2	1000000	\N	1000000
602	19	18	2	1000000	\N	1000000
603	19	23	2	1000000	\N	1000000
604	19	47	2	1000000	\N	1000000
605	19	6	2	1000000	\N	1000000
606	19	11	2	1000000	\N	1000000
607	19	25	2	1000000	\N	1000000
608	19	3	2	1000000	\N	1000000
609	19	38	2	1000000	\N	1000000
610	19	29	2	1000000	\N	1000000
611	19	36	2	1000000	\N	1000000
612	19	19	2	1000000	\N	1000000
613	19	35	2	1000000	\N	1000000
614	19	20	2	1000000	\N	1000000
615	19	46	2	1000000	\N	1000000
616	19	1	2	1000000	\N	1000000
617	19	8	2	1000000	\N	1000000
618	19	22	2	1000000	\N	1000000
619	19	32	2	1000000	\N	1000000
620	19	26	2	1000000	\N	1000000
621	19	30	2	1000000	\N	1000000
622	19	27	2	1000000	\N	1000000
623	19	24	2	1000000	\N	1000000
624	19	31	2	1000000	\N	1000000
625	19	16	2	1000000	\N	1000000
626	19	4	2	1000000	\N	1000000
627	19	28	2	1000000	\N	1000000
628	19	39	2	986783	\N	1000000
629	19	44	2	986289	\N	1000000
630	19	45	2	985686	\N	1000000
631	19	15	2	985461	\N	1000000
632	19	14	2	956665	\N	1000000
633	19	7	2	946763	\N	1000000
634	19	9	2	922919	\N	1000000
635	19	12	2	840321	\N	1000000
636	19	43	2	718935	\N	1000000
637	19	33	2	674588	\N	1000000
638	19	41	2	325853	\N	1000000
639	20	42	1	14	\N	\N
640	20	28	1	14	\N	\N
641	20	49	1	14	\N	\N
642	20	20	3	4858160	\N	\N
643	20	42	2	1000000	\N	1000000
644	20	18	2	1000000	\N	1000000
645	20	23	2	1000000	\N	1000000
646	20	47	2	1000000	\N	1000000
647	20	11	2	1000000	\N	1000000
648	20	25	2	1000000	\N	1000000
649	20	3	2	1000000	\N	1000000
650	20	38	2	1000000	\N	1000000
651	20	29	2	1000000	\N	1000000
652	20	36	2	1000000	\N	1000000
653	20	35	2	1000000	\N	1000000
654	20	20	2	1000000	\N	1000000
655	20	46	2	1000000	\N	1000000
656	20	26	2	1000000	\N	1000000
657	20	30	2	1000000	\N	1000000
658	20	27	2	1000000	\N	1000000
659	20	24	2	1000000	\N	1000000
660	20	31	2	1000000	\N	1000000
661	20	16	2	1000000	\N	1000000
662	20	4	2	1000000	\N	1000000
663	20	28	2	1000000	\N	1000000
664	20	6	2	995222	\N	1000000
665	20	45	2	985815	\N	1000000
666	20	15	2	985796	\N	1000000
667	20	44	2	984792	\N	1000000
668	20	7	2	964336	\N	1000000
669	20	14	2	944160	\N	1000000
670	20	39	2	917164	\N	1000000
671	20	12	2	843529	\N	1000000
672	20	32	2	682221	\N	1000000
673	20	13	2	667872	\N	1000000
674	20	19	2	667872	\N	1000000
675	20	1	2	667872	\N	1000000
676	20	8	2	667872	\N	1000000
677	20	22	2	667872	\N	1000000
678	20	9	2	593920	\N	1000000
679	20	33	2	592817	\N	1000000
680	20	43	2	561950	\N	1000000
681	20	41	2	238783	\N	1000000
682	21	42	1	8	\N	\N
683	21	28	1	8	\N	\N
684	21	49	1	8	\N	\N
685	21	21	3	7711	\N	\N
686	21	49	2	8205	\N	\N
687	21	21	2	7711	\N	\N
688	21	34	2	6968	\N	\N
689	21	37	2	6968	\N	\N
690	21	42	2	6935	\N	\N
691	21	28	2	6935	\N	\N
692	21	10	2	4887	\N	\N
693	22	42	2	1000000	\N	1000000
694	22	13	2	1000000	\N	1000000
695	22	18	2	1000000	\N	1000000
696	22	23	2	1000000	\N	1000000
697	22	47	2	1000000	\N	1000000
698	22	6	2	1000000	\N	1000000
699	22	11	2	1000000	\N	1000000
700	22	25	2	1000000	\N	1000000
701	22	3	2	1000000	\N	1000000
702	22	38	2	1000000	\N	1000000
703	22	29	2	1000000	\N	1000000
704	22	36	2	1000000	\N	1000000
705	22	19	2	1000000	\N	1000000
706	22	35	2	1000000	\N	1000000
707	22	20	2	1000000	\N	1000000
708	22	46	2	1000000	\N	1000000
709	22	1	2	1000000	\N	1000000
710	22	8	2	1000000	\N	1000000
711	22	22	2	1000000	\N	1000000
712	22	32	2	1000000	\N	1000000
713	22	26	2	1000000	\N	1000000
714	22	30	2	1000000	\N	1000000
715	22	27	2	1000000	\N	1000000
716	22	24	2	1000000	\N	1000000
717	22	31	2	1000000	\N	1000000
718	22	16	2	1000000	\N	1000000
719	22	4	2	1000000	\N	1000000
720	22	28	2	1000000	\N	1000000
721	22	39	2	986783	\N	1000000
722	22	44	2	986288	\N	1000000
723	22	45	2	985685	\N	1000000
724	22	15	2	985460	\N	1000000
725	22	14	2	956677	\N	1000000
726	22	7	2	947086	\N	1000000
727	22	9	2	922919	\N	1000000
728	22	12	2	840390	\N	1000000
729	22	43	2	719339	\N	1000000
730	22	33	2	674656	\N	1000000
731	22	41	2	325785	\N	1000000
732	23	42	2	1000000	\N	1000000
733	23	18	2	1000000	\N	1000000
734	23	23	2	1000000	\N	1000000
735	23	47	2	1000000	\N	1000000
736	23	11	2	1000000	\N	1000000
737	23	25	2	1000000	\N	1000000
738	23	3	2	1000000	\N	1000000
739	23	38	2	1000000	\N	1000000
740	23	29	2	1000000	\N	1000000
741	23	36	2	1000000	\N	1000000
742	23	35	2	1000000	\N	1000000
743	23	20	2	1000000	\N	1000000
744	23	46	2	1000000	\N	1000000
745	23	26	2	1000000	\N	1000000
746	23	30	2	1000000	\N	1000000
747	23	27	2	1000000	\N	1000000
748	23	24	2	1000000	\N	1000000
749	23	31	2	1000000	\N	1000000
750	23	16	2	1000000	\N	1000000
751	23	4	2	1000000	\N	1000000
752	23	28	2	1000000	\N	1000000
753	23	6	2	994701	\N	1000000
754	23	45	2	988660	\N	1000000
755	23	15	2	988458	\N	1000000
756	23	44	2	987688	\N	1000000
757	23	7	2	964138	\N	1000000
758	23	14	2	940120	\N	1000000
759	23	39	2	921676	\N	1000000
760	23	12	2	861281	\N	1000000
761	23	32	2	644293	\N	1000000
762	23	13	2	630415	\N	1000000
763	23	19	2	630415	\N	1000000
764	23	1	2	630415	\N	1000000
765	23	8	2	630415	\N	1000000
766	23	22	2	630415	\N	1000000
767	23	33	2	624822	\N	1000000
768	23	9	2	595395	\N	1000000
769	23	43	2	497696	\N	1000000
770	23	41	2	187833	\N	1000000
771	24	24	3	4858158	\N	\N
772	24	42	2	1000000	\N	1000000
773	24	18	2	1000000	\N	1000000
774	24	23	2	1000000	\N	1000000
775	24	47	2	1000000	\N	1000000
776	24	11	2	1000000	\N	1000000
777	24	25	2	1000000	\N	1000000
778	24	3	2	1000000	\N	1000000
779	24	38	2	1000000	\N	1000000
780	24	29	2	1000000	\N	1000000
781	24	36	2	1000000	\N	1000000
782	24	35	2	1000000	\N	1000000
783	24	20	2	1000000	\N	1000000
784	24	46	2	1000000	\N	1000000
785	24	26	2	1000000	\N	1000000
786	24	30	2	1000000	\N	1000000
787	24	27	2	1000000	\N	1000000
788	24	24	2	1000000	\N	1000000
789	24	31	2	1000000	\N	1000000
790	24	16	2	1000000	\N	1000000
791	24	4	2	1000000	\N	1000000
792	24	28	2	1000000	\N	1000000
793	24	6	2	994701	\N	1000000
794	24	45	2	988725	\N	1000000
795	24	15	2	988460	\N	1000000
796	24	44	2	987655	\N	1000000
797	24	7	2	964059	\N	1000000
798	24	14	2	940065	\N	1000000
799	24	39	2	921577	\N	1000000
800	24	12	2	861414	\N	1000000
801	24	32	2	644396	\N	1000000
802	24	13	2	630421	\N	1000000
803	24	19	2	630421	\N	1000000
804	24	1	2	630421	\N	1000000
805	24	8	2	630421	\N	1000000
806	24	22	2	630421	\N	1000000
807	24	33	2	624961	\N	1000000
808	24	9	2	595193	\N	1000000
809	24	43	2	497671	\N	1000000
810	24	41	2	187748	\N	1000000
811	25	42	2	1000000	\N	1000000
812	25	18	2	1000000	\N	1000000
813	25	23	2	1000000	\N	1000000
814	25	47	2	1000000	\N	1000000
815	25	11	2	1000000	\N	1000000
816	25	25	2	1000000	\N	1000000
817	25	3	2	1000000	\N	1000000
818	25	38	2	1000000	\N	1000000
819	25	29	2	1000000	\N	1000000
820	25	36	2	1000000	\N	1000000
821	25	35	2	1000000	\N	1000000
822	25	20	2	1000000	\N	1000000
823	25	46	2	1000000	\N	1000000
824	25	26	2	1000000	\N	1000000
825	25	30	2	1000000	\N	1000000
826	25	27	2	1000000	\N	1000000
827	25	24	2	1000000	\N	1000000
828	25	31	2	1000000	\N	1000000
829	25	16	2	1000000	\N	1000000
830	25	4	2	1000000	\N	1000000
831	25	28	2	1000000	\N	1000000
832	25	7	2	999295	\N	1000000
833	25	6	2	993654	\N	1000000
834	25	45	2	989853	\N	1000000
835	25	15	2	989473	\N	1000000
836	25	44	2	987777	\N	1000000
837	25	14	2	935265	\N	1000000
838	25	39	2	912767	\N	1000000
839	25	12	2	877136	\N	1000000
840	25	33	2	638371	\N	1000000
841	25	32	2	314185	\N	1000000
842	25	13	2	314109	\N	1000000
843	25	19	2	314109	\N	1000000
844	25	1	2	314109	\N	1000000
845	25	8	2	314109	\N	1000000
846	25	22	2	314109	\N	1000000
847	25	9	2	292749	\N	1000000
848	25	43	2	118365	\N	1000000
849	25	41	2	116691	\N	1000000
850	26	42	1	9	\N	\N
851	26	28	1	9	\N	\N
852	26	49	1	9	\N	\N
853	26	26	3	4858160	\N	\N
854	26	42	2	1000000	\N	1000000
855	26	18	2	1000000	\N	1000000
856	26	23	2	1000000	\N	1000000
857	26	47	2	1000000	\N	1000000
858	26	11	2	1000000	\N	1000000
859	26	25	2	1000000	\N	1000000
860	26	3	2	1000000	\N	1000000
861	26	38	2	1000000	\N	1000000
862	26	29	2	1000000	\N	1000000
863	26	36	2	1000000	\N	1000000
864	26	35	2	1000000	\N	1000000
865	26	20	2	1000000	\N	1000000
866	26	46	2	1000000	\N	1000000
867	26	26	2	1000000	\N	1000000
868	26	30	2	1000000	\N	1000000
869	26	27	2	1000000	\N	1000000
870	26	24	2	1000000	\N	1000000
871	26	31	2	1000000	\N	1000000
872	26	16	2	1000000	\N	1000000
873	26	4	2	1000000	\N	1000000
874	26	28	2	1000000	\N	1000000
875	26	6	2	994701	\N	1000000
876	26	45	2	988660	\N	1000000
877	26	15	2	988458	\N	1000000
878	26	44	2	987688	\N	1000000
879	26	7	2	964138	\N	1000000
880	26	14	2	940120	\N	1000000
881	26	39	2	921676	\N	1000000
882	26	12	2	861281	\N	1000000
883	26	32	2	644293	\N	1000000
884	26	13	2	630415	\N	1000000
885	26	19	2	630415	\N	1000000
886	26	1	2	630415	\N	1000000
887	26	8	2	630415	\N	1000000
888	26	22	2	630415	\N	1000000
889	26	33	2	624822	\N	1000000
890	26	9	2	595395	\N	1000000
891	26	43	2	497696	\N	1000000
892	26	41	2	187833	\N	1000000
893	27	42	1	4	\N	\N
894	27	28	1	4	\N	\N
895	27	49	1	4	\N	\N
896	27	27	3	4858160	\N	\N
897	27	42	2	1000000	\N	1000000
898	27	18	2	1000000	\N	1000000
899	27	23	2	1000000	\N	1000000
900	27	47	2	1000000	\N	1000000
901	27	11	2	1000000	\N	1000000
902	27	25	2	1000000	\N	1000000
903	27	3	2	1000000	\N	1000000
904	27	38	2	1000000	\N	1000000
905	27	29	2	1000000	\N	1000000
906	27	36	2	1000000	\N	1000000
907	27	35	2	1000000	\N	1000000
908	27	20	2	1000000	\N	1000000
909	27	46	2	1000000	\N	1000000
910	27	26	2	1000000	\N	1000000
911	27	30	2	1000000	\N	1000000
912	27	27	2	1000000	\N	1000000
913	27	24	2	1000000	\N	1000000
914	27	31	2	1000000	\N	1000000
915	27	16	2	1000000	\N	1000000
916	27	4	2	1000000	\N	1000000
917	27	28	2	1000000	\N	1000000
918	27	6	2	994701	\N	1000000
919	27	45	2	988660	\N	1000000
920	27	15	2	988458	\N	1000000
921	27	44	2	987688	\N	1000000
922	27	7	2	964138	\N	1000000
923	27	14	2	940120	\N	1000000
924	27	39	2	921676	\N	1000000
925	27	12	2	861281	\N	1000000
926	27	32	2	644293	\N	1000000
927	27	13	2	630415	\N	1000000
928	27	19	2	630415	\N	1000000
929	27	1	2	630415	\N	1000000
930	27	8	2	630415	\N	1000000
931	27	22	2	630415	\N	1000000
932	27	33	2	624822	\N	1000000
933	27	9	2	595395	\N	1000000
934	27	43	2	497696	\N	1000000
935	27	41	2	187833	\N	1000000
936	28	28	3	14591232	\N	\N
937	28	28	2	1000000	\N	1000000
938	28	17	2	978223	\N	1000000
939	28	2	2	6754	\N	1000000
940	28	42	2	6057	\N	1000000
941	28	49	2	6057	\N	1000000
942	29	48	1	165	\N	\N
943	29	28	1	165	\N	\N
944	29	49	1	165	\N	\N
945	29	29	3	4858160	\N	\N
946	29	42	2	1000000	\N	1000000
947	29	18	2	1000000	\N	1000000
948	29	23	2	1000000	\N	1000000
949	29	47	2	1000000	\N	1000000
950	29	11	2	1000000	\N	1000000
951	29	25	2	1000000	\N	1000000
952	29	3	2	1000000	\N	1000000
953	29	38	2	1000000	\N	1000000
954	29	29	2	1000000	\N	1000000
955	29	36	2	1000000	\N	1000000
956	29	35	2	1000000	\N	1000000
957	29	20	2	1000000	\N	1000000
958	29	46	2	1000000	\N	1000000
959	29	26	2	1000000	\N	1000000
960	29	30	2	1000000	\N	1000000
961	29	27	2	1000000	\N	1000000
962	29	24	2	1000000	\N	1000000
963	29	31	2	1000000	\N	1000000
964	29	16	2	1000000	\N	1000000
965	29	4	2	1000000	\N	1000000
966	29	28	2	1000000	\N	1000000
967	29	6	2	994701	\N	1000000
968	29	45	2	988660	\N	1000000
969	29	15	2	988458	\N	1000000
970	29	44	2	987688	\N	1000000
971	29	7	2	964138	\N	1000000
972	29	14	2	940120	\N	1000000
973	29	39	2	921676	\N	1000000
974	29	12	2	861281	\N	1000000
975	29	32	2	644293	\N	1000000
976	29	13	2	630415	\N	1000000
977	29	19	2	630415	\N	1000000
978	29	1	2	630415	\N	1000000
979	29	8	2	630415	\N	1000000
980	29	22	2	630415	\N	1000000
981	29	33	2	624822	\N	1000000
982	29	9	2	595395	\N	1000000
983	29	43	2	497696	\N	1000000
984	29	41	2	187833	\N	1000000
985	30	42	1	34	\N	\N
986	30	28	1	34	\N	\N
987	30	49	1	34	\N	\N
988	30	30	3	4858160	\N	\N
989	30	42	2	1000000	\N	1000000
990	30	18	2	1000000	\N	1000000
991	30	23	2	1000000	\N	1000000
992	30	47	2	1000000	\N	1000000
993	30	11	2	1000000	\N	1000000
994	30	25	2	1000000	\N	1000000
995	30	3	2	1000000	\N	1000000
996	30	38	2	1000000	\N	1000000
997	30	29	2	1000000	\N	1000000
998	30	36	2	1000000	\N	1000000
999	30	35	2	1000000	\N	1000000
1000	30	20	2	1000000	\N	1000000
1001	30	46	2	1000000	\N	1000000
1002	30	26	2	1000000	\N	1000000
1003	30	30	2	1000000	\N	1000000
1004	30	27	2	1000000	\N	1000000
1005	30	24	2	1000000	\N	1000000
1006	30	31	2	1000000	\N	1000000
1007	30	16	2	1000000	\N	1000000
1008	30	4	2	1000000	\N	1000000
1009	30	28	2	1000000	\N	1000000
1010	30	6	2	994701	\N	1000000
1011	30	45	2	988660	\N	1000000
1012	30	15	2	988458	\N	1000000
1013	30	44	2	987688	\N	1000000
1014	30	7	2	964138	\N	1000000
1015	30	14	2	940120	\N	1000000
1016	30	39	2	921676	\N	1000000
1017	30	12	2	861281	\N	1000000
1018	30	32	2	644293	\N	1000000
1019	30	13	2	630415	\N	1000000
1020	30	19	2	630415	\N	1000000
1021	30	1	2	630415	\N	1000000
1022	30	8	2	630415	\N	1000000
1023	30	22	2	630415	\N	1000000
1024	30	33	2	624822	\N	1000000
1025	30	9	2	595395	\N	1000000
1026	30	43	2	497696	\N	1000000
1027	30	41	2	187833	\N	1000000
1028	31	28	1	146	\N	\N
1029	31	49	1	146	\N	\N
1030	31	40	1	112	\N	\N
1031	31	31	3	4858160	\N	\N
1032	31	42	2	1000000	\N	1000000
1033	31	18	2	1000000	\N	1000000
1034	31	23	2	1000000	\N	1000000
1035	31	47	2	1000000	\N	1000000
1036	31	11	2	1000000	\N	1000000
1037	31	25	2	1000000	\N	1000000
1038	31	3	2	1000000	\N	1000000
1039	31	38	2	1000000	\N	1000000
1040	31	29	2	1000000	\N	1000000
1041	31	36	2	1000000	\N	1000000
1042	31	35	2	1000000	\N	1000000
1043	31	20	2	1000000	\N	1000000
1044	31	46	2	1000000	\N	1000000
1045	31	26	2	1000000	\N	1000000
1046	31	30	2	1000000	\N	1000000
1047	31	27	2	1000000	\N	1000000
1048	31	24	2	1000000	\N	1000000
1049	31	31	2	1000000	\N	1000000
1050	31	16	2	1000000	\N	1000000
1051	31	4	2	1000000	\N	1000000
1052	31	28	2	1000000	\N	1000000
1053	31	6	2	995998	\N	1000000
1054	31	45	2	992236	\N	1000000
1055	31	15	2	991855	\N	1000000
1056	31	44	2	991849	\N	1000000
1057	31	39	2	957418	\N	1000000
1058	31	14	2	936231	\N	1000000
1059	31	7	2	898748	\N	1000000
1060	31	12	2	848557	\N	1000000
1061	31	33	2	796027	\N	1000000
1062	31	32	2	730421	\N	1000000
1063	31	13	2	713825	\N	1000000
1064	31	19	2	713825	\N	1000000
1065	31	1	2	713825	\N	1000000
1066	31	8	2	713825	\N	1000000
1067	31	22	2	713825	\N	1000000
1068	31	9	2	675766	\N	1000000
1069	31	43	2	446536	\N	1000000
1070	31	41	2	122431	\N	1000000
1071	32	42	2	1000000	\N	1000000
1072	32	18	2	1000000	\N	1000000
1073	32	23	2	1000000	\N	1000000
1074	32	47	2	1000000	\N	1000000
1075	32	6	2	1000000	\N	1000000
1076	32	11	2	1000000	\N	1000000
1077	32	25	2	1000000	\N	1000000
1078	32	3	2	1000000	\N	1000000
1079	32	38	2	1000000	\N	1000000
1080	32	29	2	1000000	\N	1000000
1081	32	36	2	1000000	\N	1000000
1082	32	35	2	1000000	\N	1000000
1083	32	20	2	1000000	\N	1000000
1084	32	46	2	1000000	\N	1000000
1085	32	32	2	1000000	\N	1000000
1086	32	26	2	1000000	\N	1000000
1087	32	30	2	1000000	\N	1000000
1088	32	27	2	1000000	\N	1000000
1089	32	24	2	1000000	\N	1000000
1090	32	31	2	1000000	\N	1000000
1091	32	16	2	1000000	\N	1000000
1092	32	4	2	1000000	\N	1000000
1093	32	28	2	1000000	\N	1000000
1094	32	44	2	986255	\N	1000000
1095	32	45	2	985583	\N	1000000
1096	32	15	2	985358	\N	1000000
1097	32	13	2	984555	\N	1000000
1098	32	19	2	984555	\N	1000000
1099	32	1	2	984555	\N	1000000
1100	32	8	2	984555	\N	1000000
1101	32	22	2	984555	\N	1000000
1102	32	39	2	971338	\N	1000000
1103	32	14	2	950178	\N	1000000
1104	32	7	2	948532	\N	1000000
1105	32	9	2	908185	\N	1000000
1106	32	12	2	836303	\N	1000000
1107	32	43	2	709800	\N	1000000
1108	32	33	2	660529	\N	1000000
1109	32	41	2	324469	\N	1000000
1110	33	42	2	1000000	\N	1000000
1111	33	18	2	1000000	\N	1000000
1112	33	23	2	1000000	\N	1000000
1113	33	47	2	1000000	\N	1000000
1114	33	6	2	1000000	\N	1000000
1115	33	11	2	1000000	\N	1000000
1116	33	25	2	1000000	\N	1000000
1117	33	3	2	1000000	\N	1000000
1118	33	38	2	1000000	\N	1000000
1119	33	29	2	1000000	\N	1000000
1120	33	36	2	1000000	\N	1000000
1121	33	35	2	1000000	\N	1000000
1122	33	33	2	1000000	\N	1000000
1123	33	20	2	1000000	\N	1000000
1124	33	44	2	1000000	\N	1000000
1125	33	46	2	1000000	\N	1000000
1126	33	26	2	1000000	\N	1000000
1127	33	30	2	1000000	\N	1000000
1128	33	27	2	1000000	\N	1000000
1129	33	24	2	1000000	\N	1000000
1130	33	31	2	1000000	\N	1000000
1131	33	16	2	1000000	\N	1000000
1132	33	4	2	1000000	\N	1000000
1133	33	28	2	1000000	\N	1000000
1134	33	45	2	999991	\N	1000000
1135	33	15	2	999991	\N	1000000
1136	33	39	2	999536	\N	1000000
1137	33	14	2	956019	\N	1000000
1138	33	7	2	941256	\N	1000000
1139	33	12	2	882001	\N	1000000
1140	33	13	2	732294	\N	1000000
1141	33	19	2	732294	\N	1000000
1142	33	1	2	732294	\N	1000000
1143	33	8	2	732294	\N	1000000
1144	33	22	2	732294	\N	1000000
1145	33	32	2	732294	\N	1000000
1146	33	9	2	731649	\N	1000000
1147	33	43	2	400871	\N	1000000
1148	33	41	2	17952	\N	1000000
1149	34	42	1	5	\N	\N
1150	34	28	1	5	\N	\N
1151	34	49	1	5	\N	\N
1152	34	34	3	6968	\N	\N
1153	34	37	3	6968	\N	\N
1154	34	49	2	8205	\N	\N
1155	34	21	2	7711	\N	\N
1156	34	34	2	6968	\N	\N
1157	34	37	2	6968	\N	\N
1158	34	42	2	6935	\N	\N
1159	34	28	2	6935	\N	\N
1160	34	10	2	4887	\N	\N
1161	35	42	1	50	\N	\N
1162	35	28	1	50	\N	\N
1163	35	49	1	50	\N	\N
1164	35	35	3	4858160	\N	\N
1165	35	42	2	1000000	\N	1000000
1166	35	18	2	1000000	\N	1000000
1167	35	23	2	1000000	\N	1000000
1168	35	47	2	1000000	\N	1000000
1169	35	11	2	1000000	\N	1000000
1170	35	25	2	1000000	\N	1000000
1171	35	3	2	1000000	\N	1000000
1172	35	38	2	1000000	\N	1000000
1173	35	29	2	1000000	\N	1000000
1174	35	36	2	1000000	\N	1000000
1175	35	7	2	1000000	\N	1000000
1176	35	35	2	1000000	\N	1000000
1177	35	20	2	1000000	\N	1000000
1178	35	46	2	1000000	\N	1000000
1179	35	26	2	1000000	\N	1000000
1180	35	30	2	1000000	\N	1000000
1181	35	27	2	1000000	\N	1000000
1182	35	24	2	1000000	\N	1000000
1183	35	31	2	1000000	\N	1000000
1184	35	16	2	1000000	\N	1000000
1185	35	4	2	1000000	\N	1000000
1186	35	28	2	1000000	\N	1000000
1187	35	6	2	999330	\N	1000000
1188	35	45	2	993910	\N	1000000
1189	35	15	2	993641	\N	1000000
1190	35	44	2	990565	\N	1000000
1191	35	14	2	968401	\N	1000000
1192	35	39	2	954905	\N	1000000
1193	35	12	2	861608	\N	1000000
1194	35	32	2	742452	\N	1000000
1195	35	13	2	739391	\N	1000000
1196	35	19	2	739391	\N	1000000
1197	35	1	2	739391	\N	1000000
1198	35	8	2	739391	\N	1000000
1199	35	22	2	739391	\N	1000000
1200	35	9	2	689362	\N	1000000
1201	35	33	2	603823	\N	1000000
1202	35	43	2	480568	\N	1000000
1203	35	41	2	295225	\N	1000000
1204	36	36	3	4858160	\N	\N
1205	36	42	2	1000000	\N	1000000
1206	36	18	2	1000000	\N	1000000
1207	36	23	2	1000000	\N	1000000
1208	36	47	2	1000000	\N	1000000
1209	36	11	2	1000000	\N	1000000
1210	36	25	2	1000000	\N	1000000
1211	36	3	2	1000000	\N	1000000
1212	36	38	2	1000000	\N	1000000
1213	36	29	2	1000000	\N	1000000
1214	36	36	2	1000000	\N	1000000
1215	36	35	2	1000000	\N	1000000
1216	36	20	2	1000000	\N	1000000
1217	36	46	2	1000000	\N	1000000
1218	36	26	2	1000000	\N	1000000
1219	36	30	2	1000000	\N	1000000
1220	36	27	2	1000000	\N	1000000
1221	36	24	2	1000000	\N	1000000
1222	36	31	2	1000000	\N	1000000
1223	36	16	2	1000000	\N	1000000
1224	36	4	2	1000000	\N	1000000
1225	36	28	2	1000000	\N	1000000
1226	36	6	2	994701	\N	1000000
1227	36	45	2	988660	\N	1000000
1228	36	15	2	988458	\N	1000000
1229	36	44	2	987688	\N	1000000
1230	36	7	2	964138	\N	1000000
1231	36	14	2	940120	\N	1000000
1232	36	39	2	921676	\N	1000000
1233	36	12	2	861281	\N	1000000
1234	36	32	2	644293	\N	1000000
1235	36	13	2	630415	\N	1000000
1236	36	19	2	630415	\N	1000000
1237	36	1	2	630415	\N	1000000
1238	36	8	2	630415	\N	1000000
1239	36	22	2	630415	\N	1000000
1240	36	33	2	624822	\N	1000000
1241	36	9	2	595395	\N	1000000
1242	36	43	2	497696	\N	1000000
1243	36	41	2	187833	\N	1000000
1244	37	42	1	5	\N	\N
1245	37	28	1	5	\N	\N
1246	37	49	1	5	\N	\N
1247	37	34	3	6968	\N	\N
1248	37	37	3	6968	\N	\N
1249	37	49	2	8205	\N	\N
1250	37	21	2	7711	\N	\N
1251	37	34	2	6968	\N	\N
1252	37	37	2	6968	\N	\N
1253	37	42	2	6935	\N	\N
1254	37	28	2	6935	\N	\N
1255	37	10	2	4887	\N	\N
1256	38	42	1	63	\N	\N
1257	38	28	1	63	\N	\N
1258	38	49	1	63	\N	\N
1259	38	38	3	4858158	\N	\N
1260	38	42	2	1000000	\N	1000000
1261	38	18	2	1000000	\N	1000000
1262	38	23	2	1000000	\N	1000000
1263	38	47	2	1000000	\N	1000000
1264	38	11	2	1000000	\N	1000000
1265	38	25	2	1000000	\N	1000000
1266	38	3	2	1000000	\N	1000000
1267	38	38	2	1000000	\N	1000000
1268	38	29	2	1000000	\N	1000000
1269	38	36	2	1000000	\N	1000000
1270	38	35	2	1000000	\N	1000000
1271	38	20	2	1000000	\N	1000000
1272	38	46	2	1000000	\N	1000000
1273	38	26	2	1000000	\N	1000000
1274	38	30	2	1000000	\N	1000000
1275	38	27	2	1000000	\N	1000000
1276	38	24	2	1000000	\N	1000000
1277	38	31	2	1000000	\N	1000000
1278	38	16	2	1000000	\N	1000000
1279	38	4	2	1000000	\N	1000000
1280	38	28	2	1000000	\N	1000000
1281	38	45	2	999999	\N	1000000
1282	38	15	2	999998	\N	1000000
1283	38	6	2	999766	\N	1000000
1284	38	44	2	999568	\N	1000000
1285	38	39	2	992419	\N	1000000
1286	38	33	2	982763	\N	1000000
1287	38	14	2	965292	\N	1000000
1288	38	7	2	932903	\N	1000000
1289	38	12	2	878631	\N	1000000
1290	38	32	2	782372	\N	1000000
1291	38	13	2	778453	\N	1000000
1292	38	19	2	778453	\N	1000000
1293	38	1	2	778453	\N	1000000
1294	38	8	2	778453	\N	1000000
1295	38	22	2	778453	\N	1000000
1296	38	9	2	777412	\N	1000000
1297	38	43	2	354827	\N	1000000
1298	38	41	2	4024	\N	1000000
1299	39	42	2	1000000	\N	1000000
1300	39	18	2	1000000	\N	1000000
1301	39	23	2	1000000	\N	1000000
1302	39	47	2	1000000	\N	1000000
1303	39	6	2	1000000	\N	1000000
1304	39	11	2	1000000	\N	1000000
1305	39	25	2	1000000	\N	1000000
1306	39	3	2	1000000	\N	1000000
1307	39	38	2	1000000	\N	1000000
1308	39	29	2	1000000	\N	1000000
1309	39	36	2	1000000	\N	1000000
1310	39	35	2	1000000	\N	1000000
1311	39	20	2	1000000	\N	1000000
1312	39	46	2	1000000	\N	1000000
1313	39	39	2	1000000	\N	1000000
1314	39	26	2	1000000	\N	1000000
1315	39	30	2	1000000	\N	1000000
1316	39	27	2	1000000	\N	1000000
1317	39	24	2	1000000	\N	1000000
1318	39	31	2	1000000	\N	1000000
1319	39	16	2	1000000	\N	1000000
1320	39	4	2	1000000	\N	1000000
1321	39	28	2	1000000	\N	1000000
1322	39	45	2	988774	\N	1000000
1323	39	15	2	988530	\N	1000000
1324	39	44	2	987102	\N	1000000
1325	39	7	2	965263	\N	1000000
1326	39	14	2	945595	\N	1000000
1327	39	12	2	862039	\N	1000000
1328	39	33	2	680661	\N	1000000
1329	39	13	2	679887	\N	1000000
1330	39	19	2	679887	\N	1000000
1331	39	1	2	679887	\N	1000000
1332	39	8	2	679887	\N	1000000
1333	39	22	2	679887	\N	1000000
1334	39	32	2	679887	\N	1000000
1335	39	9	2	652975	\N	1000000
1336	39	43	2	505838	\N	1000000
1337	39	41	2	195777	\N	1000000
1338	40	40	3	112	\N	\N
1339	40	28	2	112	\N	\N
1340	40	49	2	112	\N	\N
1341	40	40	2	112	\N	\N
1342	41	28	2	1408296	\N	\N
1343	41	42	2	1406949	\N	\N
1344	41	4	2	1406897	\N	\N
1345	41	46	2	1402928	\N	\N
1346	41	8	2	1401621	\N	\N
1347	41	41	2	1399958	\N	\N
1348	41	11	2	1398834	\N	\N
1349	41	20	2	1396281	\N	\N
1350	41	25	2	1393142	\N	\N
1351	41	16	2	1392190	\N	\N
1352	41	47	2	1391151	\N	\N
1353	41	3	2	1390847	\N	\N
1354	41	35	2	1390620	\N	\N
1355	41	1	2	1386373	\N	\N
1356	41	7	2	1385720	\N	\N
1357	41	22	2	1385030	\N	\N
1358	41	32	2	1384291	\N	\N
1359	41	38	2	1383581	\N	\N
1360	41	43	2	1381550	\N	\N
1361	41	36	2	1379186	\N	\N
1362	41	6	2	1377117	\N	\N
1363	41	29	2	1373940	\N	\N
1364	41	31	2	1368656	\N	\N
1365	41	14	2	1367850	\N	\N
1366	41	26	2	1367031	\N	\N
1367	41	27	2	1363977	\N	\N
1368	41	18	2	1363301	\N	\N
1369	41	13	2	1362312	\N	\N
1370	41	19	2	1361095	\N	\N
1371	41	23	2	1360170	\N	\N
1372	41	30	2	1358634	\N	\N
1373	41	44	2	1349798	\N	\N
1374	41	24	2	1347547	\N	\N
1375	41	45	2	1327052	\N	\N
1376	41	15	2	1321258	\N	\N
1377	41	39	2	1315479	\N	\N
1378	41	12	2	1057190	\N	\N
1379	41	9	2	1030696	\N	\N
1380	41	33	2	79655	\N	\N
1381	42	42	2	1000000	\N	1000000
1382	42	28	2	1000000	\N	1000000
1383	42	18	2	992124	\N	1000000
1384	42	23	2	992124	\N	1000000
1385	42	47	2	992124	\N	1000000
1386	42	11	2	992124	\N	1000000
1387	42	25	2	992124	\N	1000000
1388	42	3	2	992124	\N	1000000
1389	42	38	2	992124	\N	1000000
1390	42	29	2	992124	\N	1000000
1391	42	36	2	992124	\N	1000000
1392	42	35	2	992124	\N	1000000
1393	42	20	2	992124	\N	1000000
1394	42	46	2	992124	\N	1000000
1395	42	26	2	992124	\N	1000000
1396	42	30	2	992124	\N	1000000
1397	42	27	2	992124	\N	1000000
1398	42	24	2	992124	\N	1000000
1399	42	31	2	992124	\N	1000000
1400	42	16	2	992124	\N	1000000
1401	42	4	2	992124	\N	1000000
1402	42	6	2	986825	\N	1000000
1403	42	45	2	980784	\N	1000000
1404	42	15	2	980582	\N	1000000
1405	42	44	2	979812	\N	1000000
1406	42	7	2	956262	\N	1000000
1407	42	14	2	932883	\N	1000000
1408	42	39	2	913957	\N	1000000
1409	42	12	2	855173	\N	1000000
1410	42	32	2	638350	\N	1000000
1411	42	33	2	624822	\N	1000000
1412	42	13	2	624472	\N	1000000
1413	42	19	2	624472	\N	1000000
1414	42	1	2	624472	\N	1000000
1415	42	8	2	624472	\N	1000000
1416	42	22	2	624472	\N	1000000
1417	42	9	2	589587	\N	1000000
1418	42	43	2	491753	\N	1000000
1419	42	41	2	181890	\N	1000000
1420	42	49	2	7876	\N	1000000
1421	42	2	2	6754	\N	1000000
1422	43	42	2	1000000	\N	1000000
1423	43	13	2	1000000	\N	1000000
1424	43	18	2	1000000	\N	1000000
1425	43	23	2	1000000	\N	1000000
1426	43	47	2	1000000	\N	1000000
1427	43	6	2	1000000	\N	1000000
1428	43	11	2	1000000	\N	1000000
1429	43	25	2	1000000	\N	1000000
1430	43	3	2	1000000	\N	1000000
1431	43	38	2	1000000	\N	1000000
1432	43	29	2	1000000	\N	1000000
1433	43	36	2	1000000	\N	1000000
1434	43	19	2	1000000	\N	1000000
1435	43	35	2	1000000	\N	1000000
1436	43	20	2	1000000	\N	1000000
1437	43	46	2	1000000	\N	1000000
1438	43	43	2	1000000	\N	1000000
1439	43	1	2	1000000	\N	1000000
1440	43	8	2	1000000	\N	1000000
1441	43	22	2	1000000	\N	1000000
1442	43	32	2	1000000	\N	1000000
1443	43	26	2	1000000	\N	1000000
1444	43	30	2	1000000	\N	1000000
1445	43	27	2	1000000	\N	1000000
1446	43	24	2	1000000	\N	1000000
1447	43	31	2	1000000	\N	1000000
1448	43	16	2	1000000	\N	1000000
1449	43	4	2	1000000	\N	1000000
1450	43	28	2	1000000	\N	1000000
1451	43	39	2	986779	\N	1000000
1452	43	44	2	984330	\N	1000000
1453	43	45	2	983691	\N	1000000
1454	43	15	2	983454	\N	1000000
1455	43	14	2	963428	\N	1000000
1456	43	7	2	932669	\N	1000000
1457	43	9	2	873679	\N	1000000
1458	43	12	2	800247	\N	1000000
1459	43	33	2	524115	\N	1000000
1460	43	41	2	474050	\N	1000000
1461	44	42	1	1246	\N	\N
1462	44	28	1	1246	\N	\N
1463	44	49	1	1246	\N	\N
1464	44	44	3	4800720	\N	\N
1465	44	42	2	1000000	\N	1000000
1466	44	18	2	1000000	\N	1000000
1467	44	23	2	1000000	\N	1000000
1468	44	47	2	1000000	\N	1000000
1469	44	11	2	1000000	\N	1000000
1470	44	25	2	1000000	\N	1000000
1471	44	3	2	1000000	\N	1000000
1472	44	38	2	1000000	\N	1000000
1473	44	29	2	1000000	\N	1000000
1474	44	36	2	1000000	\N	1000000
1475	44	35	2	1000000	\N	1000000
1476	44	20	2	1000000	\N	1000000
1477	44	44	2	1000000	\N	1000000
1478	44	46	2	1000000	\N	1000000
1479	44	26	2	1000000	\N	1000000
1480	44	30	2	1000000	\N	1000000
1481	44	27	2	1000000	\N	1000000
1482	44	24	2	1000000	\N	1000000
1483	44	31	2	1000000	\N	1000000
1484	44	16	2	1000000	\N	1000000
1485	44	4	2	1000000	\N	1000000
1486	44	28	2	1000000	\N	1000000
1487	44	45	2	998470	\N	1000000
1488	44	15	2	998268	\N	1000000
1489	44	6	2	994725	\N	1000000
1490	44	7	2	964203	\N	1000000
1491	44	14	2	940160	\N	1000000
1492	44	39	2	921417	\N	1000000
1493	44	12	2	862392	\N	1000000
1494	44	32	2	645418	\N	1000000
1495	44	13	2	631540	\N	1000000
1496	44	19	2	631540	\N	1000000
1497	44	1	2	631540	\N	1000000
1498	44	8	2	631540	\N	1000000
1499	44	22	2	631540	\N	1000000
1500	44	33	2	624822	\N	1000000
1501	44	9	2	596157	\N	1000000
1502	44	43	2	498970	\N	1000000
1503	44	41	2	189688	\N	1000000
1504	45	28	1	466	\N	\N
1505	45	5	1	233	\N	\N
1506	45	49	1	228	\N	\N
1507	45	45	3	4805049	\N	\N
1508	45	2	3	6501	\N	\N
1509	45	42	2	1000000	\N	1000000
1510	45	18	2	1000000	\N	1000000
1511	45	23	2	1000000	\N	1000000
1512	45	47	2	1000000	\N	1000000
1513	45	11	2	1000000	\N	1000000
1514	45	25	2	1000000	\N	1000000
1515	45	3	2	1000000	\N	1000000
1516	45	38	2	1000000	\N	1000000
1517	45	29	2	1000000	\N	1000000
1518	45	36	2	1000000	\N	1000000
1519	45	45	2	1000000	\N	1000000
1520	45	35	2	1000000	\N	1000000
1521	45	20	2	1000000	\N	1000000
1522	45	46	2	1000000	\N	1000000
1523	45	26	2	1000000	\N	1000000
1524	45	30	2	1000000	\N	1000000
1525	45	27	2	1000000	\N	1000000
1526	45	24	2	1000000	\N	1000000
1527	45	31	2	1000000	\N	1000000
1528	45	16	2	1000000	\N	1000000
1529	45	4	2	1000000	\N	1000000
1530	45	28	2	1000000	\N	1000000
1531	45	15	2	999798	\N	1000000
1532	45	44	2	997498	\N	1000000
1533	45	6	2	994701	\N	1000000
1534	45	7	2	964223	\N	1000000
1535	45	14	2	939280	\N	1000000
1536	45	39	2	921335	\N	1000000
1537	45	12	2	860047	\N	1000000
1538	45	32	2	644908	\N	1000000
1539	45	13	2	631046	\N	1000000
1540	45	19	2	631046	\N	1000000
1541	45	1	2	631046	\N	1000000
1542	45	8	2	631046	\N	1000000
1543	45	22	2	631046	\N	1000000
1544	45	33	2	624822	\N	1000000
1545	45	9	2	595675	\N	1000000
1546	45	43	2	498335	\N	1000000
1547	45	41	2	188491	\N	1000000
1548	46	42	1	6	\N	\N
1549	46	28	1	6	\N	\N
1550	46	49	1	6	\N	\N
1551	46	46	3	4858160	\N	\N
1552	46	42	2	1000000	\N	1000000
1553	46	18	2	1000000	\N	1000000
1554	46	23	2	1000000	\N	1000000
1555	46	47	2	1000000	\N	1000000
1556	46	11	2	1000000	\N	1000000
1557	46	25	2	1000000	\N	1000000
1558	46	3	2	1000000	\N	1000000
1559	46	38	2	1000000	\N	1000000
1560	46	29	2	1000000	\N	1000000
1561	46	36	2	1000000	\N	1000000
1562	46	35	2	1000000	\N	1000000
1563	46	20	2	1000000	\N	1000000
1564	46	46	2	1000000	\N	1000000
1565	46	26	2	1000000	\N	1000000
1566	46	30	2	1000000	\N	1000000
1567	46	27	2	1000000	\N	1000000
1568	46	24	2	1000000	\N	1000000
1569	46	31	2	1000000	\N	1000000
1570	46	16	2	1000000	\N	1000000
1571	46	4	2	1000000	\N	1000000
1572	46	28	2	1000000	\N	1000000
1573	46	6	2	994701	\N	1000000
1574	46	45	2	988660	\N	1000000
1575	46	15	2	988458	\N	1000000
1576	46	44	2	987688	\N	1000000
1577	46	7	2	964138	\N	1000000
1578	46	14	2	940120	\N	1000000
1579	46	39	2	921676	\N	1000000
1580	46	12	2	861281	\N	1000000
1581	46	32	2	644293	\N	1000000
1582	46	13	2	630415	\N	1000000
1583	46	19	2	630415	\N	1000000
1584	46	1	2	630415	\N	1000000
1585	46	8	2	630415	\N	1000000
1586	46	22	2	630415	\N	1000000
1587	46	33	2	624822	\N	1000000
1588	46	9	2	595395	\N	1000000
1589	46	43	2	497696	\N	1000000
1590	46	41	2	187833	\N	1000000
1591	47	42	1	468	\N	\N
1592	47	28	1	468	\N	\N
1593	47	49	1	468	\N	\N
1594	47	47	3	4858160	\N	\N
1595	47	42	2	1000000	\N	1000000
1596	47	18	2	1000000	\N	1000000
1597	47	23	2	1000000	\N	1000000
1598	47	47	2	1000000	\N	1000000
1599	47	11	2	1000000	\N	1000000
1600	47	25	2	1000000	\N	1000000
1601	47	3	2	1000000	\N	1000000
1602	47	38	2	1000000	\N	1000000
1603	47	29	2	1000000	\N	1000000
1604	47	36	2	1000000	\N	1000000
1605	47	35	2	1000000	\N	1000000
1606	47	20	2	1000000	\N	1000000
1607	47	46	2	1000000	\N	1000000
1608	47	26	2	1000000	\N	1000000
1609	47	30	2	1000000	\N	1000000
1610	47	27	2	1000000	\N	1000000
1611	47	24	2	1000000	\N	1000000
1612	47	31	2	1000000	\N	1000000
1613	47	16	2	1000000	\N	1000000
1614	47	4	2	1000000	\N	1000000
1615	47	28	2	1000000	\N	1000000
1616	47	6	2	994701	\N	1000000
1617	47	45	2	988660	\N	1000000
1618	47	15	2	988458	\N	1000000
1619	47	44	2	987688	\N	1000000
1620	47	7	2	964138	\N	1000000
1621	47	14	2	940120	\N	1000000
1622	47	39	2	921676	\N	1000000
1623	47	12	2	861281	\N	1000000
1624	47	32	2	644293	\N	1000000
1625	47	13	2	630415	\N	1000000
1626	47	19	2	630415	\N	1000000
1627	47	1	2	630415	\N	1000000
1628	47	8	2	630415	\N	1000000
1629	47	22	2	630415	\N	1000000
1630	47	33	2	624822	\N	1000000
1631	47	9	2	595395	\N	1000000
1632	47	43	2	497696	\N	1000000
1633	47	41	2	187833	\N	1000000
1634	48	48	2	165	\N	\N
1635	48	28	2	165	\N	\N
1636	48	49	2	165	\N	\N
1637	49	49	2	17774	\N	\N
1638	49	28	2	16742	\N	\N
1639	49	42	2	15955	\N	\N
1640	49	21	2	7671	\N	\N
1641	49	34	2	6951	\N	\N
1642	49	37	2	6949	\N	\N
1643	49	2	2	6739	\N	\N
1644	49	10	2	4864	\N	\N
1645	49	5	2	228	\N	\N
1646	49	48	2	165	\N	\N
1647	49	40	2	112	\N	\N
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://w3id.org/foodie/open/catchrecord/norway#unitPriceForBuyer	3920663	\N	69	unitPriceForBuyer	unitPriceForBuyer	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://dbpedia.org/ontology/municipalityCode	6754	\N	10	municipalityCode	municipalityCode	f	6754	-1	-1	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://w3id.org/foodie/open/catchrecord/norway#fromCatchArea	4858160	\N	69	fromCatchArea	fromCatchArea	f	4858160	1	-1	f	f	8	17	\N	t	f	\N	\N	\N	t	f	f
4	http://www.opengis.net/ont/geosparql#hasGeometry	4858160	\N	25	hasGeometry	hasGeometry	f	4858160	1	1	f	f	8	12	\N	t	f	\N	\N	\N	t	f	f
5	https://www.omg.org/spec/LCC/Countries/CountryRepresentation#hasTag	233	\N	71	hasTag	hasTag	f	0	1	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://w3id.org/foodie/open/catchrecord/norway#catchUtilization	4846287	\N	69	catchUtilization	catchUtilization	f	4846287	1	-1	f	f	8	9	\N	t	f	\N	\N	\N	t	f	f
7	http://w3id.org/foodie/open/catchrecord/norway#liveWeight	4636060	\N	69	liveWeight	liveWeight	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://w3id.org/foodie/open/catchrecord/norway#unitPriceForFisherman	3920663	\N	69	unitPriceForFisherman	unitPriceForFisherman	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://w3id.org/foodie/open/catchrecord/norway#catchValue	3567763	\N	69	catchValue	catchValue	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://w3id.org/foodie/open/vessels#radioCallSignal	4887	\N	70	radioCallSignal	radioCallSignal	f	0	-1	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://w3id.org/foodie/open/catchrecord/norway#conservationMethod	4858160	\N	69	conservationMethod	conservationMethod	f	4858160	1	-1	f	f	8	6	\N	t	f	\N	\N	\N	t	f	f
12	http://w3id.org/foodie/open/catchrecord/norway#fromFisherman	4126683	\N	69	fromFisherman	fromFisherman	f	4126683	1	-1	f	f	8	10	\N	t	f	\N	\N	\N	t	f	f
13	http://w3id.org/foodie/open/catchrecord/norway#associationTax	3920663	\N	69	associationTax	associationTax	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://w3id.org/foodie/open/catchrecord/norway#fromVessel	4612342	\N	69	fromVessel	fromVessel	f	4612342	1	-1	f	f	8	1	\N	t	f	\N	\N	\N	t	f	f
15	http://w3id.org/foodie/open/catchrecord/norway#landingRegionCode	4800365	\N	69	landingRegionCode	landingRegionCode	f	4800365	1	-1	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://www.opengis.net/ont/geosparql#defaultGeometry	4858160	\N	25	defaultGeometry	defaultGeometry	f	4858160	1	1	f	f	8	12	\N	t	f	\N	\N	\N	t	f	f
17	http://www.opengis.net/ont/geosparql#asWKT	9560448	\N	25	asWKT	asWKT	f	0	1	\N	f	f	12	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://w3id.org/foodie/open/catchrecord/norway#bruttoWeight	4858160	\N	69	bruttoWeight	bruttoWeight	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://w3id.org/foodie/open/catchrecord/norway#postponedPayment	3920663	\N	69	postponedPayment	postponedPayment	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://w3id.org/foodie/open/catchrecord/norway#quality	4858160	\N	69	quality	quality	f	4858160	1	-1	f	f	8	7	\N	t	f	\N	\N	\N	t	f	f
21	http://w3id.org/foodie/open/vessels#vesselType	7711	\N	70	vesselType	vesselType	f	7711	-1	-1	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
22	http://w3id.org/foodie/open/catchrecord/norway#valueForBuyer	3920663	\N	69	valueForBuyer	valueForBuyer	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://w3id.org/foodie/open/catchrecord/norway#catchLandingTime	4858160	\N	69	catchLandingTime	catchLandingTime	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.ontologydesignpatterns.org/cp/owl/fsdas/catchrecord.owl#fromFishingArea	4858158	\N	74	fromFishingArea	fromFishingArea	f	4858158	1	-1	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://w3id.org/foodie/open/catchrecord/norway#documentUpdateTime	4858160	\N	69	documentUpdateTime	documentUpdateTime	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://w3id.org/foodie/open/catchrecord/norway#withGearGroup	4858160	\N	69	withGearGroup	withGearGroup	f	4858160	1	-1	f	f	8	4	\N	t	f	\N	\N	\N	t	f	f
27	http://w3id.org/foodie/open/catchrecord/norway#withMainGearGroup	4858160	\N	69	withMainGearGroup	withMainGearGroup	f	4858160	1	-1	f	f	8	4	\N	t	f	\N	\N	\N	t	f	f
29	http://w3id.org/foodie/open/catchrecord/norway#isCatchRecordForFDIR	4858160	\N	69	isCatchRecordForFDIR	isCatchRecordForFDIR	f	4858160	1	-1	f	f	8	11	\N	t	f	\N	\N	\N	t	f	f
30	http://w3id.org/foodie/open/catchrecord/norway#withGearType	4858160	\N	69	withGearType	withGearType	f	4858160	1	-1	f	f	8	4	\N	t	f	\N	\N	\N	t	f	f
31	http://www.ontologydesignpatterns.org/cp/owl/fsdas/catchrecord.owl#isCatchRecordFor	4858160	\N	74	isCatchRecordFor	isCatchRecordFor	f	4858160	1	-1	f	f	8	5	\N	t	f	\N	\N	\N	t	f	f
32	http://w3id.org/foodie/open/catchrecord/norway#valueForFisherman	3984678	\N	69	valueForFisherman	valueForFisherman	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://w3id.org/foodie/open/catchrecord/norway#productionFacility	3054865	\N	69	productionFacility	productionFacility	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://w3id.org/foodie/open/vessels#lenghtGroup	6968	\N	70	lenghtGroup	lenghtGroup	f	6968	-1	-1	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
35	http://w3id.org/foodie/open/catchrecord/norway#productState	4858160	\N	69	productState	productState	f	4858160	1	-1	f	f	8	13	\N	t	f	\N	\N	\N	t	f	f
36	http://w3id.org/foodie/open/catchrecord/norway#landingCountryCode	4858160	\N	69	landingCountryCode	landingCountryCode	f	4858160	1	-1	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://w3id.org/foodie/open/vessels#quotaType	6968	\N	70	quotaType	quotaType	f	6968	-1	-1	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
38	http://w3id.org/foodie/open/catchrecord/norway#fromMainCatchArea	4858158	\N	69	fromMainCatchArea	fromMainCatchArea	f	4858158	1	-1	f	f	8	15	\N	t	f	\N	\N	\N	t	f	f
39	http://w3id.org/foodie/open/catchrecord/norway#saleDate	4614232	\N	69	saleDate	saleDate	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/2002/07/owl#sameAs	112	\N	7	sameAs	sameAs	f	112	1	1	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	14591232	\N	1	type	type	f	14591232	-1	-1	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
41	http://w3id.org/foodie/open/catchrecord/norway#supportAmount	1408296	\N	69	supportAmount	supportAmount	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://purl.org/dc/terms/identifier	4874135	\N	5	identifier	identifier	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://w3id.org/foodie/open/catchrecord/norway#seizedCatchValue	2624078	\N	69	seizedCatchValue	seizedCatchValue	f	0	1	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://w3id.org/foodie/open/catchrecord/norway#receiverID	4800720	\N	69	receiverID	receiverID	f	4800720	1	-1	f	f	8	18	\N	t	f	\N	\N	\N	t	f	f
45	http://w3id.org/foodie/open/catchrecord/norway#landingMunicipalityCode	4805049	\N	69	landingMunicipalityCode	landingMunicipalityCode	f	4805049	1	-1	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
46	http://w3id.org/foodie/open/catchrecord/norway#saleAssociationID	4858160	\N	69	saleAssociationID	saleAssociationID	f	4858160	1	-1	f	f	8	16	\N	t	f	\N	\N	\N	t	f	f
47	http://w3id.org/foodie/open/catchrecord/norway#catchSizeGroup	4858160	\N	69	catchSizeGroup	catchSizeGroup	f	4858160	1	-1	f	f	8	14	\N	t	f	\N	\N	\N	t	f	f
48	http://w3id.org/foodie/open/FDIR#hasCodeFDIR	165	\N	75	hasCodeFDIR	hasCodeFDIR	f	0	1	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://www.w3.org/2000/01/rdf-schema#label	17784	\N	2	label	label	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

COPY http_foodie_cloud_catchrecord_norway.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.annot_types_id_seq', 7, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cc_rels_id_seq', 1, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.class_annots_id_seq', 1, false);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.classes_id_seq', 18, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cp_rels_id_seq', 119, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cpc_rels_id_seq', 50, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.datatypes_id_seq', 5, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.ns_id_seq', 75, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.parameters_id_seq', 32, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.pd_rels_id_seq', 21, true);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.pp_rels_id_seq', 1647, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.properties_id_seq', 49, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_catchrecord_norway.property_annots_id_seq', 1, false);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_foodie_cloud_catchrecord_norway.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_foodie_cloud_catchrecord_norway.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_foodie_cloud_catchrecord_norway.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_foodie_cloud_catchrecord_norway.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_foodie_cloud_catchrecord_norway.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_foodie_cloud_catchrecord_norway.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_foodie_cloud_catchrecord_norway.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_foodie_cloud_catchrecord_norway.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_foodie_cloud_catchrecord_norway.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_foodie_cloud_catchrecord_norway.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_foodie_cloud_catchrecord_norway.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_foodie_cloud_catchrecord_norway.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_foodie_cloud_catchrecord_norway.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_foodie_cloud_catchrecord_norway.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_classes_data ON http_foodie_cloud_catchrecord_norway.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_classes_iri ON http_foodie_cloud_catchrecord_norway.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_foodie_cloud_catchrecord_norway.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_foodie_cloud_catchrecord_norway.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_foodie_cloud_catchrecord_norway.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_foodie_cloud_catchrecord_norway.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_instances_test ON http_foodie_cloud_catchrecord_norway.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_foodie_cloud_catchrecord_norway.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_foodie_cloud_catchrecord_norway.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_foodie_cloud_catchrecord_norway.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_properties_data ON http_foodie_cloud_catchrecord_norway.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

CREATE INDEX idx_properties_iri ON http_foodie_cloud_catchrecord_norway.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_catchrecord_norway.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_catchrecord_norway.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_catchrecord_norway.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_catchrecord_norway.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_catchrecord_norway.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_catchrecord_norway.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_catchrecord_norway.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_foodie_cloud_catchrecord_norway.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_foodie_cloud_catchrecord_norway.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_catchrecord_norway.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_catchrecord_norway.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_catchrecord_norway.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_catchrecord_norway.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_catchrecord_norway.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_foodie_cloud_catchrecord_norway.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_foodie_cloud_catchrecord_norway.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_catchrecord_norway.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_catchrecord_norway.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_foodie_cloud_catchrecord_norway.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_catchrecord_norway.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_catchrecord_norway; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_catchrecord_norway.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_catchrecord_norway.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

