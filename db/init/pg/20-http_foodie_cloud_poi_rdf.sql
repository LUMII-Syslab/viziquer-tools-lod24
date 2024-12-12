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
-- Name: http_foodie_cloud_poi_rdf; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_foodie_cloud_poi_rdf;


--
-- Name: SCHEMA http_foodie_cloud_poi_rdf; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_foodie_cloud_poi_rdf IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE FUNCTION http_foodie_cloud_poi_rdf.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE FUNCTION http_foodie_cloud_poi_rdf.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COMMENT ON TABLE http_foodie_cloud_poi_rdf._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COMMENT ON COLUMN http_foodie_cloud_poi_rdf.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_foodie_cloud_poi_rdf.classes c1
     JOIN http_foodie_cloud_poi_rdf.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_foodie_cloud_poi_rdf.properties p ON ((cp1.property_id = p.id)))
     JOIN http_foodie_cloud_poi_rdf.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_foodie_cloud_poi_rdf.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE TABLE http_foodie_cloud_poi_rdf.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE http_foodie_cloud_poi_rdf.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_foodie_cloud_poi_rdf.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_cc_rels AS
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
   FROM http_foodie_cloud_poi_rdf.cc_rels r,
    http_foodie_cloud_poi_rdf.classes c1,
    http_foodie_cloud_poi_rdf.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_classes_ns AS
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
    http_foodie_cloud_poi_rdf.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_foodie_cloud_poi_rdf.classes c
     LEFT JOIN http_foodie_cloud_poi_rdf.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_classes_ns_main AS
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
   FROM http_foodie_cloud_poi_rdf.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_foodie_cloud_poi_rdf.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_classes_ns_plus AS
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
    http_foodie_cloud_poi_rdf.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_foodie_cloud_poi_rdf.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_foodie_cloud_poi_rdf.classes c
     LEFT JOIN http_foodie_cloud_poi_rdf.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_classes_ns_main_plus AS
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
   FROM http_foodie_cloud_poi_rdf.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_foodie_cloud_poi_rdf.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_classes_ns_main_v01 AS
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
   FROM (http_foodie_cloud_poi_rdf.v_classes_ns v
     LEFT JOIN http_foodie_cloud_poi_rdf.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_cp_rels AS
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
    http_foodie_cloud_poi_rdf.tapprox((r.cnt)::integer) AS cnt_x,
    http_foodie_cloud_poi_rdf.tapprox(r.object_cnt) AS object_cnt_x,
    http_foodie_cloud_poi_rdf.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_foodie_cloud_poi_rdf.cp_rels r,
    http_foodie_cloud_poi_rdf.classes c,
    http_foodie_cloud_poi_rdf.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_cp_rels_card AS
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
   FROM http_foodie_cloud_poi_rdf.cp_rels r,
    http_foodie_cloud_poi_rdf.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_properties_ns AS
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
    http_foodie_cloud_poi_rdf.tapprox(p.cnt) AS cnt_x,
    http_foodie_cloud_poi_rdf.tapprox(p.object_cnt) AS object_cnt_x,
    http_foodie_cloud_poi_rdf.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_foodie_cloud_poi_rdf.properties p
     LEFT JOIN http_foodie_cloud_poi_rdf.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_cp_sources_single AS
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
   FROM ((http_foodie_cloud_poi_rdf.v_cp_rels_card r
     JOIN http_foodie_cloud_poi_rdf.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_foodie_cloud_poi_rdf.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_cp_targets_single AS
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
   FROM ((http_foodie_cloud_poi_rdf.v_cp_rels_card r
     JOIN http_foodie_cloud_poi_rdf.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_foodie_cloud_poi_rdf.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_foodie_cloud_poi_rdf.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_foodie_cloud_poi_rdf.pp_rels r,
    http_foodie_cloud_poi_rdf.properties p1,
    http_foodie_cloud_poi_rdf.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_properties_sources AS
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
   FROM (http_foodie_cloud_poi_rdf.v_properties_ns v
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
           FROM http_foodie_cloud_poi_rdf.cp_rels r,
            http_foodie_cloud_poi_rdf.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_properties_sources_single AS
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
   FROM (http_foodie_cloud_poi_rdf.v_properties_ns v
     LEFT JOIN http_foodie_cloud_poi_rdf.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_properties_targets AS
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
   FROM (http_foodie_cloud_poi_rdf.v_properties_ns v
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
           FROM http_foodie_cloud_poi_rdf.cp_rels r,
            http_foodie_cloud_poi_rdf.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE VIEW http_foodie_cloud_poi_rdf.v_properties_targets_single AS
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
   FROM (http_foodie_cloud_poi_rdf.v_properties_ns v
     LEFT JOIN http_foodie_cloud_poi_rdf.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	109	1	\N	\N
2	2	111	1	\N	\N
3	3	251	1	\N	\N
4	4	111	1	\N	\N
5	5	55	1	\N	\N
6	6	37	1	\N	\N
7	7	109	1	\N	\N
8	8	251	1	\N	\N
9	9	55	1	\N	\N
10	10	109	1	\N	\N
11	11	55	1	\N	\N
12	12	55	1	\N	\N
13	13	54	1	\N	\N
14	14	111	1	\N	\N
15	15	145	1	\N	\N
16	16	145	1	\N	\N
17	17	55	1	\N	\N
18	18	55	1	\N	\N
19	19	55	1	\N	\N
20	20	55	1	\N	\N
21	21	33	1	\N	\N
22	22	251	1	\N	\N
23	24	145	1	\N	\N
24	25	37	1	\N	\N
25	25	55	1	\N	\N
26	26	37	1	\N	\N
27	27	55	1	\N	\N
28	28	268	1	\N	\N
29	29	55	1	\N	\N
30	30	55	1	\N	\N
31	31	55	1	\N	\N
32	32	33	1	\N	\N
33	34	55	1	\N	\N
34	35	55	1	\N	\N
35	36	55	1	\N	\N
36	37	109	1	\N	\N
37	38	111	1	\N	\N
38	39	55	1	\N	\N
39	40	145	1	\N	\N
40	41	109	1	\N	\N
41	42	55	1	\N	\N
42	43	145	1	\N	\N
43	44	33	1	\N	\N
44	45	145	1	\N	\N
45	46	55	1	\N	\N
46	47	55	1	\N	\N
47	48	145	1	\N	\N
48	49	54	1	\N	\N
49	50	145	1	\N	\N
50	51	145	1	\N	\N
51	52	111	1	\N	\N
52	53	111	1	\N	\N
53	56	54	1	\N	\N
54	57	54	1	\N	\N
55	58	55	1	\N	\N
56	59	139	1	\N	\N
57	60	139	1	\N	\N
58	61	55	1	\N	\N
59	62	251	1	\N	\N
60	63	55	1	\N	\N
61	64	109	1	\N	\N
62	65	54	1	\N	\N
63	66	55	1	\N	\N
64	67	33	1	\N	\N
65	68	54	1	\N	\N
66	69	111	1	\N	\N
67	71	109	1	\N	\N
68	72	109	1	\N	\N
69	73	37	1	\N	\N
70	73	55	1	\N	\N
71	74	54	1	\N	\N
72	75	54	1	\N	\N
73	76	54	1	\N	\N
74	77	139	1	\N	\N
75	78	145	1	\N	\N
76	80	145	1	\N	\N
77	81	54	1	\N	\N
78	82	109	1	\N	\N
79	83	54	1	\N	\N
80	84	145	1	\N	\N
81	85	145	1	\N	\N
82	86	55	1	\N	\N
83	87	111	1	\N	\N
84	88	139	1	\N	\N
85	89	251	1	\N	\N
86	90	251	1	\N	\N
87	92	55	1	\N	\N
88	93	251	1	\N	\N
89	94	109	1	\N	\N
90	95	109	1	\N	\N
91	96	145	1	\N	\N
92	97	54	1	\N	\N
93	98	109	1	\N	\N
94	99	111	1	\N	\N
95	100	109	1	\N	\N
96	101	251	1	\N	\N
97	102	55	1	\N	\N
98	103	33	1	\N	\N
99	104	91	1	\N	\N
100	105	33	1	\N	\N
101	106	111	1	\N	\N
102	107	109	1	\N	\N
103	108	55	1	\N	\N
104	110	139	1	\N	\N
105	112	54	1	\N	\N
106	113	55	1	\N	\N
107	114	91	1	\N	\N
108	115	54	1	\N	\N
109	116	111	1	\N	\N
110	117	37	1	\N	\N
111	118	54	1	\N	\N
112	119	54	1	\N	\N
113	120	139	1	\N	\N
114	121	111	1	\N	\N
115	122	37	1	\N	\N
116	123	55	1	\N	\N
117	124	145	1	\N	\N
118	125	55	1	\N	\N
119	126	251	1	\N	\N
120	127	55	1	\N	\N
121	128	54	1	\N	\N
122	129	54	1	\N	\N
123	130	109	1	\N	\N
124	131	145	1	\N	\N
125	132	145	1	\N	\N
126	133	55	1	\N	\N
127	134	55	1	\N	\N
128	135	251	1	\N	\N
129	136	37	1	\N	\N
130	137	55	1	\N	\N
131	138	109	1	\N	\N
132	140	145	1	\N	\N
133	141	145	1	\N	\N
134	142	55	1	\N	\N
135	143	145	1	\N	\N
136	144	111	1	\N	\N
137	146	55	1	\N	\N
138	147	55	1	\N	\N
139	148	55	1	\N	\N
140	149	111	1	\N	\N
141	150	54	1	\N	\N
142	151	109	1	\N	\N
143	152	139	1	\N	\N
144	153	54	1	\N	\N
145	154	111	1	\N	\N
146	155	55	1	\N	\N
147	156	251	1	\N	\N
148	157	54	1	\N	\N
149	158	109	1	\N	\N
150	159	54	1	\N	\N
151	160	109	1	\N	\N
152	161	111	1	\N	\N
153	162	145	1	\N	\N
154	163	251	1	\N	\N
155	165	55	1	\N	\N
156	166	145	1	\N	\N
157	167	109	1	\N	\N
158	168	37	1	\N	\N
159	168	55	1	\N	\N
160	169	54	1	\N	\N
161	170	55	1	\N	\N
162	171	251	1	\N	\N
163	172	109	1	\N	\N
164	173	139	1	\N	\N
165	174	251	1	\N	\N
166	175	111	1	\N	\N
167	176	139	1	\N	\N
168	177	55	1	\N	\N
169	178	55	1	\N	\N
170	179	55	1	\N	\N
171	180	55	1	\N	\N
172	181	109	1	\N	\N
173	182	145	1	\N	\N
174	183	109	1	\N	\N
175	184	145	1	\N	\N
176	185	55	1	\N	\N
177	186	145	1	\N	\N
178	186	109	1	\N	\N
179	187	145	1	\N	\N
180	188	111	1	\N	\N
181	189	55	1	\N	\N
182	190	145	1	\N	\N
183	191	251	1	\N	\N
184	192	55	1	\N	\N
185	193	111	1	\N	\N
186	194	111	1	\N	\N
187	195	54	1	\N	\N
188	196	251	1	\N	\N
189	197	251	1	\N	\N
190	198	145	1	\N	\N
191	199	55	1	\N	\N
192	200	145	1	\N	\N
193	201	55	1	\N	\N
194	202	54	1	\N	\N
195	203	145	1	\N	\N
196	204	111	1	\N	\N
197	205	54	1	\N	\N
198	206	145	1	\N	\N
199	207	55	1	\N	\N
200	208	55	1	\N	\N
201	209	109	1	\N	\N
202	210	251	1	\N	\N
203	211	111	1	\N	\N
204	212	111	1	\N	\N
205	213	111	1	\N	\N
206	214	111	1	\N	\N
207	215	111	1	\N	\N
208	218	55	1	\N	\N
209	219	251	1	\N	\N
210	220	54	1	\N	\N
211	221	251	1	\N	\N
212	222	55	1	\N	\N
213	223	33	1	\N	\N
214	224	109	1	\N	\N
215	225	111	1	\N	\N
216	226	111	1	\N	\N
217	227	145	1	\N	\N
218	228	54	1	\N	\N
219	230	33	1	\N	\N
220	231	145	1	\N	\N
221	232	111	1	\N	\N
222	233	145	1	\N	\N
223	234	33	1	\N	\N
224	235	251	1	\N	\N
225	236	145	1	\N	\N
226	237	55	1	\N	\N
227	238	55	1	\N	\N
228	239	109	1	\N	\N
229	240	109	1	\N	\N
230	241	111	1	\N	\N
231	242	111	1	\N	\N
232	243	109	1	\N	\N
233	244	145	1	\N	\N
234	245	145	1	\N	\N
235	246	54	1	\N	\N
236	247	37	1	\N	\N
237	247	55	1	\N	\N
238	248	37	1	\N	\N
239	249	33	1	\N	\N
240	250	251	1	\N	\N
241	252	55	1	\N	\N
242	253	109	1	\N	\N
243	254	55	1	\N	\N
244	255	109	1	\N	\N
245	256	54	1	\N	\N
246	257	55	1	\N	\N
247	258	109	1	\N	\N
248	259	145	1	\N	\N
249	260	37	1	\N	\N
250	261	33	1	\N	\N
251	262	54	1	\N	\N
252	263	145	1	\N	\N
253	264	111	1	\N	\N
254	265	109	1	\N	\N
255	266	251	1	\N	\N
256	267	111	1	\N	\N
257	269	145	1	\N	\N
258	271	55	1	\N	\N
259	272	145	1	\N	\N
260	273	145	1	\N	\N
261	274	55	1	\N	\N
262	275	54	1	\N	\N
263	276	55	1	\N	\N
264	277	109	1	\N	\N
265	278	54	1	\N	\N
266	279	251	1	\N	\N
267	280	145	1	\N	\N
268	281	55	1	\N	\N
269	282	251	1	\N	\N
270	283	251	1	\N	\N
271	284	139	1	\N	\N
272	285	109	1	\N	\N
273	286	145	1	\N	\N
274	287	55	1	\N	\N
275	288	55	1	\N	\N
276	289	111	1	\N	\N
277	290	54	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	gondola	en
2	2	8	protected area	en
3	3	8	region	en
4	4	8	shoal	en
5	5	8	wholesale	en
6	7	8	pier	en
7	8	8	town	en
8	9	8	general shop	en
9	10	8	rest area	en
10	11	8	vending machine	en
11	12	8	bureau de change	en
12	13	8	kindergarten	en
13	14	8	basin	en
14	15	8	church	en
15	16	8	ice rink	en
16	17	8	seafood	en
17	18	8	toys	en
18	19	8	travel agency	en
19	20	8	alcohol	en
20	21	8	cafe	en
21	22	8	chimney	en
22	23	8	library	en
23	24	8	picnic site	en
24	25	8	tyres	en
25	26	8	garage	en
26	27	8	handcrafts	en
27	28	8	volcano	en
28	29	8	boutique	en
29	30	8	fashion	en
30	31	8	jewelry	en
31	32	8	bar	en
32	33	8	food and drink	en
33	34	8	video	en
34	35	8	computer	en
35	36	8	confectionery	en
36	37	8	car service	en
37	38	8	hill	en
38	39	8	stationery	en
39	40	8	theme park	en
40	41	8	weir	en
41	42	8	wine	en
42	43	8	arts centre	en
43	44	8	biergarten	en
44	45	8	cinema	en
45	46	8	clothes	en
46	47	8	houseware	en
47	48	8	playground	en
48	49	8	police	en
49	50	8	fortification	en
50	51	8	gym	en
51	52	8	heath	en
52	53	8	wadi	en
53	54	8	professional and public	en
54	55	8	shopping and service	en
55	56	8	industrial building	en
56	57	8	office	en
57	58	8	pastry	en
58	59	8	camp site	en
59	60	8	guest house	en
60	61	8	hairdresser	en
61	62	8	antenna	en
62	63	8	beverages	en
63	64	8	boat rental	en
64	65	8	doctor	en
65	66	8	gift	en
66	67	8	ice cream	en
67	68	8	telephone	en
68	69	8	natural attraction	en
69	70	8	rozcestník	cs
70	70	8	signpost	en
71	71	8	airport terminal	en
72	72	8	bicycle parking	en
73	73	8	car	en
74	74	8	drinking water	en
75	75	8	public building	en
76	76	8	waste basket	en
77	77	8	apartment	en
78	78	8	zoo	en
79	79	8	dam	en
80	80	8	gallery	en
81	81	8	garden	en
82	82	8	halt	en
83	83	8	post office	en
84	84	8	stadium	en
85	85	8	castle	en
86	86	8	mobile phone	en
87	87	8	beach	en
88	88	8	caravan site	en
89	89	8	flagpole	en
90	90	8	isolated dwelling	en
91	91	8	outdoor	en
92	92	8	tailor	en
93	93	8	water tank	en
94	94	8	chair lift	en
95	95	8	hangar	en
96	96	8	mosque	en
97	97	8	rescue station	en
98	98	8	rope tow	en
99	99	8	sand	en
100	100	8	t-bar	en
101	101	8	terrace	en
102	102	8	dry cleaning	en
103	103	8	fountain	en
104	104	8	skiing	en
105	105	8	bbq	en
106	106	8	cliff	en
107	107	8	crossing	en
108	108	8	greengrocer	en
109	109	8	transportation	en
110	110	8	hostel	en
111	111	8	natural feature	en
112	112	8	school	en
113	113	8	shop	en
114	114	8	viewpoint	en
115	114	8	vyhlídkové místo	cs
116	115	8	dentist	en
117	116	8	bare rock	en
118	117	8	car rental	en
119	118	8	information	en
120	119	8	post box	en
121	120	8	shelter	en
122	121	8	wetland	en
123	122	8	car wash	en
124	123	8	department store	en
125	124	8	horse riding	en
126	125	8	interior decoration	en
127	126	8	locality	en
128	127	8	locksmith	en
129	128	8	ranger station	en
130	129	8	university	en
131	130	8	cable car	en
132	131	8	chapel	en
133	131	8	kaple	cs
134	132	8	meteor crater	en
135	133	8	atm	en
136	134	8	electronics	en
137	135	8	farm	en
138	136	8	fuel	en
139	137	8	garden centre	en
140	138	8	helipad	en
141	139	8	lodging	en
142	140	8	pitch	en
143	141	8	slipway	en
144	142	8	sports	en
145	143	8	wayside cross	en
146	144	8	bay	en
147	145	8	culture and entertainment	en
148	146	8	farmyard	en
149	147	8	marketplace	en
150	148	8	medical supply	en
151	149	8	tree	en
152	150	8	embassy	en
153	151	8	aerialway station	en
154	152	8	hut	en
156	153	8	townhall	en
157	154	8	water	en
158	155	8	butcher	en
159	156	8	city	en
160	157	8	clinic	en
161	158	8	lighthouse	en
162	159	8	residential building	en
163	160	8	drag lift	en
164	161	8	lake	en
165	162	8	recreation ground	en
166	163	8	windpump	en
167	165	8	hifi	en
168	166	8	archaeological site	en
169	167	8	bus station	en
170	168	8	car repair	en
171	169	8	hospital	en
172	170	8	hardware	en
173	171	8	water well	en
174	172	8	airport	en
175	173	8	hotel	en
176	174	8	silo	en
177	175	8	cave entrance	en
178	176	8	chalet	en
179	177	8	chemist	en
180	178	8	optician	en
181	179	8	bakery	en
182	180	8	bank	en
183	181	8	bridge	en
184	182	8	dive	en
185	183	8	ferry terminal	en
186	184	8	leisure common	en
187	185	8	mall	en
188	186	8	marina	en
189	187	8	ruin	en
190	188	8	spring	en
191	189	8	greenhouse	en
192	190	8	hot spring	en
193	191	8	islet	en
194	192	8	money transfer	en
195	193	8	tree row	en
196	194	8	waterfall	en
197	195	8	building	en
198	196	8	farmland	en
199	197	8	tower	en
200	198	8	artwork	en
201	199	8	florist	en
202	200	8	monument	en
203	201	8	beauty	en
204	202	8	fire station	en
205	203	8	track	en
206	204	8	wood	en
207	205	8	commercial building	en
208	206	8	park	en
209	207	8	shoes	en
210	208	8	supermarket	en
211	209	8	turning circle	en
212	210	8	village	en
213	211	8	massif	en
214	212	8	national park	en
215	213	8	plateau	en
216	214	8	reef	en
217	215	8	sandstone	en
218	218	8	laundry	en
219	219	8	neighbourhood	en
220	220	8	college	en
221	221	8	communications tower	en
222	222	8	convenience	en
223	223	8	food court	en
224	224	8	railway station	en
225	225	8	rock	en
226	226	8	stone	en
227	227	8	museum	en
228	228	8	courthouse	en
229	229	8	tourism attraction	en
230	230	8	water point	en
231	231	8	nightclub	en
232	232	8	cape	en
233	233	8	climbing wall	en
234	234	8	fast food	en
235	235	8	island	en
236	236	8	memorial	en
237	236	8	pomník	cs
238	237	8	pharmacy	en
239	238	8	variety store	en
240	239	8	magic carpet	en
241	240	8	platter	en
242	241	8	valley	en
243	242	8	peak	en
244	243	8	footway	en
245	244	8	golf course	en
246	245	8	monastery	en
247	246	8	veterinary	en
248	247	8	car_parts	en
249	248	8	parking space	en
250	249	8	restaurant	\N
251	250	8	water tower	en
252	251	8	other	en
253	252	8	art	en
254	253	8	bicycle rental	en
255	254	8	books	en
256	255	8	bus stop	en
257	256	8	community centre	en
258	257	8	copyshop	en
259	258	8	dock	en
260	259	8	jewish	en
261	260	8	parking entrance	en
262	261	8	pub	en
263	262	8	public toilet	en
264	264	8	dune	en
265	265	8	mixed lift	en
266	266	8	mountain range	en
267	267	8	natural reserve	en
268	268	8	unesco heritage	en
269	269	8	wreck	en
270	271	8	kiosk	en
271	272	8	sports centre	en
272	273	8	theatre	en
273	274	8	ticket	en
274	275	8	childcare	en
275	276	8	doityourself	en
276	277	8	ford	en
277	278	8	place of worship	en
278	279	8	suburb	en
279	280	8	swimming pool	en
280	281	8	taxi	en
281	282	8	hamlet	en
282	283	8	reservoir	en
283	284	8	motel	en
284	285	8	boatyard	en
285	286	8	dive centre	en
286	287	8	fishmonger	en
287	288	8	photo studio	en
289	289	8	ridge	en
290	290	8	shower	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://gis.zcu.cz/SPOI/Ontology#gondola	2	\N	t	69	gondola	gondola	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
2	http://gis.zcu.cz/SPOI/Ontology#protected_area	1	\N	t	69	protected_area	protected_area	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
3	http://gis.zcu.cz/SPOI/Ontology#region	2958	\N	t	69	region	region	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2958
4	http://gis.zcu.cz/SPOI/Ontology#shoal	227	\N	t	69	shoal	shoal	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	227
5	http://gis.zcu.cz/SPOI/Ontology#wholesale	484	\N	t	69	wholesale	wholesale	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	484
6	http://gis.zcu.cz/SPOI/Ontology#parking	297060	\N	t	69	parking	parking	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	297060
7	http://gis.zcu.cz/SPOI/Ontology#pier	4961	\N	t	69	pier	pier	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4961
8	http://gis.zcu.cz/SPOI/Ontology#town	81821	\N	t	69	town	town	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	81816
9	http://gis.zcu.cz/SPOI/Ontology#general_shop	2099	\N	t	69	general_shop	general_shop	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2099
10	http://gis.zcu.cz/SPOI/Ontology#rest_area	8280	\N	t	69	rest_area	rest_area	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8280
11	http://gis.zcu.cz/SPOI/Ontology#vending_machine	92878	\N	t	69	vending_machine	vending_machine	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	92878
12	http://gis.zcu.cz/SPOI/Ontology#bureau_de_change	6275	\N	t	69	bureau_de_change	bureau_de_change	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6275
13	http://gis.zcu.cz/SPOI/Ontology#kindergarten	91937	\N	t	69	kindergarten	kindergarten	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91937
14	http://gis.zcu.cz/SPOI/Ontology#basin	362	\N	t	69	basin	basin	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	362
15	http://gis.zcu.cz/SPOI/Ontology#church	1909	\N	t	69	church	church	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1909
16	http://gis.zcu.cz/SPOI/Ontology#ice_rink	478	\N	t	69	ice_rink	ice_rink	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	478
17	http://gis.zcu.cz/SPOI/Ontology#seafood	5856	\N	t	69	seafood	seafood	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5856
18	http://gis.zcu.cz/SPOI/Ontology#toys	11180	\N	t	69	toys	toys	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11180
19	http://gis.zcu.cz/SPOI/Ontology#travel_agency	16736	\N	t	69	travel_agency	travel_agency	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16736
20	http://gis.zcu.cz/SPOI/Ontology#alcohol	28680	\N	t	69	alcohol	alcohol	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28680
21	http://gis.zcu.cz/SPOI/Ontology#cafe	217362	\N	t	69	cafe	cafe	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	217362
22	http://gis.zcu.cz/SPOI/Ontology#chimney	23926	\N	t	69	chimney	chimney	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23926
23	http://gis.zcu.cz/SPOI/Ontology#library	44408	\N	t	69	library	library	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	44408
24	http://gis.zcu.cz/SPOI/Ontology#picnic_site	83872	\N	t	69	picnic_site	picnic_site	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	83872
25	http://gis.zcu.cz/SPOI/Ontology#tyres	7010	\N	t	69	tyres	tyres	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7010
26	http://gis.zcu.cz/SPOI/Ontology#garage	15	\N	t	69	garage	garage	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
27	http://gis.zcu.cz/SPOI/Ontology#handcrafts	3	\N	t	69	handcrafts	handcrafts	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
28	http://gis.zcu.cz/SPOI/Ontology#volcano	1	\N	t	69	volcano	volcano	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
29	http://gis.zcu.cz/SPOI/Ontology#boutique	9021	\N	t	69	boutique	boutique	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9021
30	http://gis.zcu.cz/SPOI/Ontology#fashion	3502	\N	t	69	fashion	fashion	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3502
31	http://gis.zcu.cz/SPOI/Ontology#jewelry	25208	\N	t	69	jewelry	jewelry	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25208
32	http://gis.zcu.cz/SPOI/Ontology#bar	99479	\N	t	69	bar	bar	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	99479
33	http://gis.zcu.cz/SPOI/Ontology#food_and_drink	1274717	\N	t	69	food_and_drink	food_and_drink	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1274717
34	http://gis.zcu.cz/SPOI/Ontology#video	3161	\N	t	69	video	video	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3161
35	http://gis.zcu.cz/SPOI/Ontology#computer	15526	\N	t	69	computer	computer	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15526
36	http://gis.zcu.cz/SPOI/Ontology#confectionery	14833	\N	t	69	confectionery	confectionery	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14833
38	http://gis.zcu.cz/SPOI/Ontology#hill	2133	\N	t	69	hill	hill	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2133
39	http://gis.zcu.cz/SPOI/Ontology#stationery	13409	\N	t	69	stationery	stationery	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13409
40	http://gis.zcu.cz/SPOI/Ontology#theme_park	2277	\N	t	69	theme_park	theme_park	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2277
41	http://gis.zcu.cz/SPOI/Ontology#weir	29224	\N	t	69	weir	weir	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29224
42	http://gis.zcu.cz/SPOI/Ontology#wine	4380	\N	t	69	wine	wine	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4380
43	http://gis.zcu.cz/SPOI/Ontology#arts_centre	7281	\N	t	69	arts_centre	arts_centre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7281
44	http://gis.zcu.cz/SPOI/Ontology#biergarten	4774	\N	t	69	biergarten	biergarten	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4774
45	http://gis.zcu.cz/SPOI/Ontology#cinema	13989	\N	t	69	cinema	cinema	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13989
46	http://gis.zcu.cz/SPOI/Ontology#clothes	139906	\N	t	69	clothes	clothes	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	139906
47	http://gis.zcu.cz/SPOI/Ontology#houseware	3664	\N	t	69	houseware	houseware	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3664
48	http://gis.zcu.cz/SPOI/Ontology#playground	122012	\N	t	69	playground	playground	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122012
49	http://gis.zcu.cz/SPOI/Ontology#police	65135	\N	t	69	police	police	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	65135
50	http://gis.zcu.cz/SPOI/Ontology#fortification	3	\N	t	69	fortification	fortification	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
51	http://gis.zcu.cz/SPOI/Ontology#gym	541	\N	t	69	gym	gym	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	541
52	http://gis.zcu.cz/SPOI/Ontology#heath	434	\N	t	69	heath	heath	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	434
53	http://gis.zcu.cz/SPOI/Ontology#wadi	5	\N	t	69	wadi	wadi	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
54	http://gis.zcu.cz/SPOI/Ontology#professional_and_public	3422319	\N	t	69	professional_and_public	professional_and_public	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3422319
55	http://gis.zcu.cz/SPOI/Ontology#shopping_and_service	2321110	\N	t	69	shopping_and_service	shopping_and_service	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2321108
56	http://gis.zcu.cz/SPOI/Ontology#industrial_building	3731	\N	t	69	industrial_building	industrial_building	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3731
57	http://gis.zcu.cz/SPOI/Ontology#office	3861	\N	t	69	office	office	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3861
58	http://gis.zcu.cz/SPOI/Ontology#pastry	1738	\N	t	69	pastry	pastry	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1738
59	http://gis.zcu.cz/SPOI/Ontology#camp_site	51394	\N	t	69	camp_site	camp_site	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51394
60	http://gis.zcu.cz/SPOI/Ontology#guest_house	54334	\N	t	69	guest_house	guest_house	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	54334
61	http://gis.zcu.cz/SPOI/Ontology#hairdresser	115441	\N	t	69	hairdresser	hairdresser	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	115441
62	http://gis.zcu.cz/SPOI/Ontology#antenna	3793	\N	t	69	antenna	antenna	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3793
63	http://gis.zcu.cz/SPOI/Ontology#beverages	11148	\N	t	69	beverages	beverages	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11148
64	http://gis.zcu.cz/SPOI/Ontology#boat_rental	1135	\N	t	69	boat_rental	boat_rental	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1135
65	http://gis.zcu.cz/SPOI/Ontology#doctor	56175	\N	t	69	doctor	doctor	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56175
66	http://gis.zcu.cz/SPOI/Ontology#gift	21979	\N	t	69	gift	gift	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21979
67	http://gis.zcu.cz/SPOI/Ontology#ice_cream	9163	\N	t	69	ice_cream	ice_cream	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9163
68	http://gis.zcu.cz/SPOI/Ontology#telephone	95105	\N	t	69	telephone	telephone	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95105
69	http://gis.zcu.cz/SPOI/Ontology#natural_attraction	2	\N	t	69	natural_attraction	natural_attraction	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
70	http://gis.zcu.cz/SPOI/Ontology#signpost	1546	\N	t	69	signpost	signpost	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3396
71	http://gis.zcu.cz/SPOI/Ontology#airport_terminal	597	\N	t	69	airport_terminal	airport_terminal	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	597
72	http://gis.zcu.cz/SPOI/Ontology#bicycle_parking	168152	\N	t	69	bicycle_parking	bicycle_parking	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	168152
73	http://gis.zcu.cz/SPOI/Ontology#car	40290	\N	t	69	car	car	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40290
74	http://gis.zcu.cz/SPOI/Ontology#drinking_water	132500	\N	t	69	drinking_water	drinking_water	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	132500
75	http://gis.zcu.cz/SPOI/Ontology#public_building	27866	\N	t	69	public_building	public_building	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27866
76	http://gis.zcu.cz/SPOI/Ontology#waste_basket	213533	\N	t	69	waste_basket	waste_basket	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	213533
77	http://gis.zcu.cz/SPOI/Ontology#apartment	12374	\N	t	69	apartment	apartment	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12374
78	http://gis.zcu.cz/SPOI/Ontology#zoo	1955	\N	t	69	zoo	zoo	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1955
79	http://gis.zcu.cz/SPOI/Ontology#dam	53153	\N	t	69	dam	dam	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53152
80	http://gis.zcu.cz/SPOI/Ontology#gallery	2050	\N	t	69	gallery	gallery	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2050
81	http://gis.zcu.cz/SPOI/Ontology#garden	3439	\N	t	69	garden	garden	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3439
82	http://gis.zcu.cz/SPOI/Ontology#halt	31636	\N	t	69	halt	halt	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31636
83	http://gis.zcu.cz/SPOI/Ontology#post_office	113400	\N	t	69	post_office	post_office	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113400
84	http://gis.zcu.cz/SPOI/Ontology#stadium	1530	\N	t	69	stadium	stadium	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1530
85	http://gis.zcu.cz/SPOI/Ontology#castle	10156	\N	t	69	castle	castle	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10156
86	http://gis.zcu.cz/SPOI/Ontology#mobile_phone	28577	\N	t	69	mobile_phone	mobile_phone	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28577
87	http://gis.zcu.cz/SPOI/Ontology#beach	7053	\N	t	69	beach	beach	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7053
88	http://gis.zcu.cz/SPOI/Ontology#caravan_site	8127	\N	t	69	caravan_site	caravan_site	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8127
89	http://gis.zcu.cz/SPOI/Ontology#flagpole	24122	\N	t	69	flagpole	flagpole	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24122
90	http://gis.zcu.cz/SPOI/Ontology#isolated_dwelling	247421	\N	t	69	isolated_dwelling	isolated_dwelling	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	247421
91	http://gis.zcu.cz/SPOI/Ontology#outdoor	125391	\N	t	69	outdoor	outdoor	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	125388
92	http://gis.zcu.cz/SPOI/Ontology#tailor	6256	\N	t	69	tailor	tailor	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6256
94	http://gis.zcu.cz/SPOI/Ontology#chair_lift	18	\N	t	69	chair_lift	chair_lift	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
95	http://gis.zcu.cz/SPOI/Ontology#hangar	105	\N	t	69	hangar	hangar	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	105
96	http://gis.zcu.cz/SPOI/Ontology#mosque	1	\N	t	69	mosque	mosque	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
97	http://gis.zcu.cz/SPOI/Ontology#rescue_station	113	\N	t	69	rescue_station	rescue_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113
98	http://gis.zcu.cz/SPOI/Ontology#rope_tow	1	\N	t	69	rope_tow	rope_tow	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
99	http://gis.zcu.cz/SPOI/Ontology#sand	166	\N	t	69	sand	sand	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	166
100	http://gis.zcu.cz/SPOI/Ontology#t-bar	11	\N	t	69	t-bar	t-bar	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
101	http://gis.zcu.cz/SPOI/Ontology#terrace	1320	\N	t	69	terrace	terrace	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1320
102	http://gis.zcu.cz/SPOI/Ontology#dry_cleaning	10800	\N	t	69	dry_cleaning	dry_cleaning	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10800
103	http://gis.zcu.cz/SPOI/Ontology#fountain	60906	\N	t	69	fountain	fountain	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60906
104	http://gis.zcu.cz/SPOI/Ontology#skiing	1509	\N	t	69	skiing	skiing	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1509
105	http://gis.zcu.cz/SPOI/Ontology#bbq	13293	\N	t	69	bbq	bbq	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13293
106	http://gis.zcu.cz/SPOI/Ontology#cliff	15462	\N	t	69	cliff	cliff	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15462
107	http://gis.zcu.cz/SPOI/Ontology#crossing	88703	\N	t	69	crossing	crossing	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	88703
108	http://gis.zcu.cz/SPOI/Ontology#greengrocer	18592	\N	t	69	greengrocer	greengrocer	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18592
109	http://gis.zcu.cz/SPOI/Ontology#transportation	4906174	\N	t	69	transportation	transportation	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4906174
110	http://gis.zcu.cz/SPOI/Ontology#hostel	18959	\N	t	69	hostel	hostel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18959
111	http://gis.zcu.cz/SPOI/Ontology#natural_feature	11755071	\N	t	69	natural_feature	natural_feature	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11755058
112	http://gis.zcu.cz/SPOI/Ontology#school	378703	\N	t	69	school	school	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	378703
113	http://gis.zcu.cz/SPOI/Ontology#shop	53337	\N	t	69	shop	shop	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53337
114	http://gis.zcu.cz/SPOI/Ontology#viewpoint	99621	\N	t	69	viewpoint	viewpoint	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	99621
115	http://gis.zcu.cz/SPOI/Ontology#dentist	39848	\N	t	69	dentist	dentist	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39848
116	http://gis.zcu.cz/SPOI/Ontology#bare_rock	1069	\N	t	69	bare_rock	bare_rock	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1069
118	http://gis.zcu.cz/SPOI/Ontology#information	418468	\N	t	69	information	information	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	418468
119	http://gis.zcu.cz/SPOI/Ontology#post_box	233176	\N	t	69	post_box	post_box	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	233176
120	http://gis.zcu.cz/SPOI/Ontology#shelter	90029	\N	t	69	shelter	shelter	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	90029
121	http://gis.zcu.cz/SPOI/Ontology#wetland	12342	\N	t	69	wetland	wetland	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12342
123	http://gis.zcu.cz/SPOI/Ontology#department_store	16767	\N	t	69	department_store	department_store	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16767
124	http://gis.zcu.cz/SPOI/Ontology#horse_riding	588	\N	t	69	horse_riding	horse_riding	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	588
125	http://gis.zcu.cz/SPOI/Ontology#interior_decoration	6322	\N	t	69	interior_decoration	interior_decoration	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6322
126	http://gis.zcu.cz/SPOI/Ontology#locality	1132543	\N	t	69	locality	locality	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1132543
127	http://gis.zcu.cz/SPOI/Ontology#locksmith	1337	\N	t	69	locksmith	locksmith	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1337
128	http://gis.zcu.cz/SPOI/Ontology#ranger_station	419	\N	t	69	ranger_station	ranger_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	419
129	http://gis.zcu.cz/SPOI/Ontology#university	11624	\N	t	69	university	university	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11624
130	http://gis.zcu.cz/SPOI/Ontology#cable_car	5	\N	t	69	cable_car	cable_car	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
131	http://gis.zcu.cz/SPOI/Ontology#chapel	173	\N	t	69	chapel	chapel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	173
132	http://gis.zcu.cz/SPOI/Ontology#meteor_crater	24	\N	t	69	meteor_crater	meteor_crater	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
133	http://gis.zcu.cz/SPOI/Ontology#atm	114343	\N	t	69	atm	atm	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114343
134	http://gis.zcu.cz/SPOI/Ontology#electronics	27454	\N	t	69	electronics	electronics	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27454
135	http://gis.zcu.cz/SPOI/Ontology#farm	54788	\N	t	69	farm	farm	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	54788
136	http://gis.zcu.cz/SPOI/Ontology#fuel	220113	\N	t	69	fuel	fuel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	220113
137	http://gis.zcu.cz/SPOI/Ontology#garden_centre	8340	\N	t	69	garden_centre	garden_centre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8340
138	http://gis.zcu.cz/SPOI/Ontology#helipad	16782	\N	t	69	helipad	helipad	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16782
139	http://gis.zcu.cz/SPOI/Ontology#lodging	709021	\N	t	69	lodging	lodging	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	708848
140	http://gis.zcu.cz/SPOI/Ontology#pitch	7797	\N	t	69	pitch	pitch	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7797
122	http://gis.zcu.cz/SPOI/Ontology#car_wash	30612	\N	t	69	car_wash	[car wash (car_wash)]	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30612
141	http://gis.zcu.cz/SPOI/Ontology#slipway	21576	\N	t	69	slipway	slipway	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21576
142	http://gis.zcu.cz/SPOI/Ontology#sports	15373	\N	t	69	sports	sports	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15373
143	http://gis.zcu.cz/SPOI/Ontology#wayside_cross	84816	\N	t	69	wayside_cross	wayside_cross	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	84816
144	http://gis.zcu.cz/SPOI/Ontology#bay	39303	\N	t	69	bay	bay	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39303
145	http://gis.zcu.cz/SPOI/Ontology#culture_and_entertainment	1300451	\N	t	69	culture_and_entertainment	culture_and_entertainment	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1300433
146	http://gis.zcu.cz/SPOI/Ontology#farmyard	2102	\N	t	69	farmyard	farmyard	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2102
147	http://gis.zcu.cz/SPOI/Ontology#marketplace	13553	\N	t	69	marketplace	marketplace	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13551
148	http://gis.zcu.cz/SPOI/Ontology#medical_supply	2921	\N	t	69	medical_supply	medical_supply	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2921
149	http://gis.zcu.cz/SPOI/Ontology#tree	9069126	\N	t	69	tree	tree	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9069126
150	http://gis.zcu.cz/SPOI/Ontology#embassy	5373	\N	t	69	embassy	embassy	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5373
151	http://gis.zcu.cz/SPOI/Ontology#aerialway_station	21994	\N	t	69	aerialway_station	aerialway_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21994
152	http://gis.zcu.cz/SPOI/Ontology#hut	23729	\N	t	69	hut	hut	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23729
153	http://gis.zcu.cz/SPOI/Ontology#townhall	43567	\N	t	69	townhall	townhall	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43567
154	http://gis.zcu.cz/SPOI/Ontology#water	26677	\N	t	69	water	water	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26677
155	http://gis.zcu.cz/SPOI/Ontology#butcher	39228	\N	t	69	butcher	butcher	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39228
156	http://gis.zcu.cz/SPOI/Ontology#city	8484	\N	t	69	city	city	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8484
157	http://gis.zcu.cz/SPOI/Ontology#clinic	24079	\N	t	69	clinic	clinic	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24079
158	http://gis.zcu.cz/SPOI/Ontology#lighthouse	7287	\N	t	69	lighthouse	lighthouse	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7287
159	http://gis.zcu.cz/SPOI/Ontology#residential_building	109705	\N	t	69	residential_building	residential_building	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	109705
160	http://gis.zcu.cz/SPOI/Ontology#drag_lift	27	\N	t	69	drag_lift	drag_lift	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27
161	http://gis.zcu.cz/SPOI/Ontology#lake	5	\N	t	69	lake	lake	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
162	http://gis.zcu.cz/SPOI/Ontology#recreation_ground	77	\N	t	69	recreation_ground	recreation_ground	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	77
163	http://gis.zcu.cz/SPOI/Ontology#windpump	446	\N	t	69	windpump	windpump	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	446
164	http://www.w3.org/2002/07/owl#Ontology	1	\N	t	7	Ontology	Ontology	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
165	http://gis.zcu.cz/SPOI/Ontology#hifi	5067	\N	t	69	hifi	hifi	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5067
166	http://gis.zcu.cz/SPOI/Ontology#archaeological_site	48009	\N	t	69	archaeological_site	archaeological_site	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48009
167	http://gis.zcu.cz/SPOI/Ontology#bus_station	24214	\N	t	69	bus_station	bus_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24214
169	http://gis.zcu.cz/SPOI/Ontology#hospital	73621	\N	t	69	hospital	hospital	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73621
170	http://gis.zcu.cz/SPOI/Ontology#hardware	27248	\N	t	69	hardware	hardware	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27248
171	http://gis.zcu.cz/SPOI/Ontology#water_well	61226	\N	t	69	water_well	water_well	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	61226
172	http://gis.zcu.cz/SPOI/Ontology#airport	30086	\N	t	69	airport	airport	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30086
173	http://gis.zcu.cz/SPOI/Ontology#hotel	143276	\N	t	69	hotel	hotel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	143276
174	http://gis.zcu.cz/SPOI/Ontology#silo	8427	\N	t	69	silo	silo	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8427
175	http://gis.zcu.cz/SPOI/Ontology#cave_entrance	23978	\N	t	69	cave_entrance	cave_entrance	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23978
176	http://gis.zcu.cz/SPOI/Ontology#chalet	11609	\N	t	69	chalet	chalet	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11609
177	http://gis.zcu.cz/SPOI/Ontology#chemist	17271	\N	t	69	chemist	chemist	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17271
178	http://gis.zcu.cz/SPOI/Ontology#optician	25205	\N	t	69	optician	optician	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25205
179	http://gis.zcu.cz/SPOI/Ontology#bakery	104349	\N	t	69	bakery	bakery	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	104349
180	http://gis.zcu.cz/SPOI/Ontology#bank	190265	\N	t	69	bank	bank	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	190265
181	http://gis.zcu.cz/SPOI/Ontology#bridge	68	\N	t	69	bridge	bridge	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68
182	http://gis.zcu.cz/SPOI/Ontology#dive	660	\N	t	69	dive	dive	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	660
183	http://gis.zcu.cz/SPOI/Ontology#ferry_terminal	10848	\N	t	69	ferry_terminal	ferry_terminal	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10848
184	http://gis.zcu.cz/SPOI/Ontology#leisure_common	707	\N	t	69	leisure_common	leisure_common	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	707
185	http://gis.zcu.cz/SPOI/Ontology#mall	6076	\N	t	69	mall	mall	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6076
186	http://gis.zcu.cz/SPOI/Ontology#marina	11814	\N	t	69	marina	marina	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11814
187	http://gis.zcu.cz/SPOI/Ontology#ruin	23859	\N	t	69	ruin	ruin	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23859
188	http://gis.zcu.cz/SPOI/Ontology#spring	76766	\N	t	69	spring	spring	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	76766
189	http://gis.zcu.cz/SPOI/Ontology#greenhouse	307	\N	t	69	greenhouse	greenhouse	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	307
190	http://gis.zcu.cz/SPOI/Ontology#hot_spring	128	\N	t	69	hot_spring	hot_spring	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	128
191	http://gis.zcu.cz/SPOI/Ontology#islet	7512	\N	t	69	islet	islet	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7512
192	http://gis.zcu.cz/SPOI/Ontology#money_transfer	864	\N	t	69	money_transfer	money_transfer	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	864
193	http://gis.zcu.cz/SPOI/Ontology#tree_row	221	\N	t	69	tree_row	tree_row	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	221
194	http://gis.zcu.cz/SPOI/Ontology#waterfall	16544	\N	t	69	waterfall	waterfall	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16544
195	http://gis.zcu.cz/SPOI/Ontology#building	298703	\N	t	69	building	building	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	298703
196	http://gis.zcu.cz/SPOI/Ontology#farmland	301	\N	t	69	farmland	farmland	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	301
197	http://gis.zcu.cz/SPOI/Ontology#tower	166120	\N	t	69	tower	tower	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	166120
198	http://gis.zcu.cz/SPOI/Ontology#artwork	59993	\N	t	69	artwork	artwork	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	59993
199	http://gis.zcu.cz/SPOI/Ontology#florist	35399	\N	t	69	florist	florist	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	35399
200	http://gis.zcu.cz/SPOI/Ontology#monument	34519	\N	t	69	monument	monument	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34519
201	http://gis.zcu.cz/SPOI/Ontology#beauty	34452	\N	t	69	beauty	beauty	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34452
202	http://gis.zcu.cz/SPOI/Ontology#fire_station	51760	\N	t	69	fire_station	fire_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51760
203	http://gis.zcu.cz/SPOI/Ontology#track	308	\N	t	69	track	track	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	308
204	http://gis.zcu.cz/SPOI/Ontology#wood	6865	\N	t	69	wood	wood	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6865
205	http://gis.zcu.cz/SPOI/Ontology#commercial_building	3604	\N	t	69	commercial_building	commercial_building	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3604
206	http://gis.zcu.cz/SPOI/Ontology#park	48058	\N	t	69	park	park	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48058
207	http://gis.zcu.cz/SPOI/Ontology#shoes	30801	\N	t	69	shoes	shoes	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30801
208	http://gis.zcu.cz/SPOI/Ontology#supermarket	178450	\N	t	69	supermarket	supermarket	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	178450
209	http://gis.zcu.cz/SPOI/Ontology#turning_circle	1536812	\N	t	69	turning_circle	turning_circle	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1536812
210	http://gis.zcu.cz/SPOI/Ontology#village	977158	\N	t	69	village	village	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	977158
211	http://gis.zcu.cz/SPOI/Ontology#massif	5	\N	t	69	massif	massif	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
212	http://gis.zcu.cz/SPOI/Ontology#national_park	325	\N	t	69	national_park	national_park	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	322
213	http://gis.zcu.cz/SPOI/Ontology#plateau	26	\N	t	69	plateau	plateau	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
214	http://gis.zcu.cz/SPOI/Ontology#reef	398	\N	t	69	reef	reef	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	398
215	http://gis.zcu.cz/SPOI/Ontology#sandstone	5	\N	t	69	sandstone	sandstone	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
216	http://gis.zcu.cz/SPOI/Ontology#Chapel	1	\N	t	69	Chapel	Chapel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
217	http://www.w3.org/2002/07/owl#Class	290	\N	t	7	Class	Class	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	58052570
218	http://gis.zcu.cz/SPOI/Ontology#laundry	14245	\N	t	69	laundry	laundry	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14245
219	http://gis.zcu.cz/SPOI/Ontology#neighbourhood	96397	\N	t	69	neighbourhood	neighbourhood	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	96397
220	http://gis.zcu.cz/SPOI/Ontology#college	12262	\N	t	69	college	college	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12262
221	http://gis.zcu.cz/SPOI/Ontology#communications_tower	3540	\N	t	69	communications_tower	communications_tower	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3540
222	http://gis.zcu.cz/SPOI/Ontology#convenience	251585	\N	t	69	convenience	convenience	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	251585
223	http://gis.zcu.cz/SPOI/Ontology#food_court	2277	\N	t	69	food_court	food_court	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2277
224	http://gis.zcu.cz/SPOI/Ontology#railway_station	91347	\N	t	69	railway_station	railway_station	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91347
225	http://gis.zcu.cz/SPOI/Ontology#rock	149835	\N	t	69	rock	rock	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	149835
226	http://gis.zcu.cz/SPOI/Ontology#stone	8733	\N	t	69	stone	stone	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8733
227	http://gis.zcu.cz/SPOI/Ontology#museum	36753	\N	t	69	museum	museum	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	36753
228	http://gis.zcu.cz/SPOI/Ontology#courthouse	7758	\N	t	69	courthouse	courthouse	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7758
229	http://gis.zcu.cz/SPOI/Ontology#tourism_attraction	66782	\N	t	69	tourism_attraction	tourism_attraction	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	66782
230	http://gis.zcu.cz/SPOI/Ontology#water_point	7258	\N	t	69	water_point	water_point	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7258
231	http://gis.zcu.cz/SPOI/Ontology#nightclub	11384	\N	t	69	nightclub	nightclub	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11384
232	http://gis.zcu.cz/SPOI/Ontology#cape	4583	\N	t	69	cape	cape	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4583
233	http://gis.zcu.cz/SPOI/Ontology#climbing_wall	5771	\N	t	69	climbing_wall	climbing_wall	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5771
234	http://gis.zcu.cz/SPOI/Ontology#fast_food	203949	\N	t	69	fast_food	fast_food	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	203949
235	http://gis.zcu.cz/SPOI/Ontology#island	38059	\N	t	69	island	island	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	38057
236	http://gis.zcu.cz/SPOI/Ontology#memorial	128038	\N	t	69	memorial	memorial	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	128038
237	http://gis.zcu.cz/SPOI/Ontology#pharmacy	169772	\N	t	69	pharmacy	pharmacy	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	169772
238	http://gis.zcu.cz/SPOI/Ontology#variety_store	14453	\N	t	69	variety_store	variety_store	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14453
239	http://gis.zcu.cz/SPOI/Ontology#magic_carpet	2	\N	t	69	magic_carpet	magic_carpet	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
240	http://gis.zcu.cz/SPOI/Ontology#platter	14	\N	t	69	platter	platter	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
241	http://gis.zcu.cz/SPOI/Ontology#valley	1309	\N	t	69	valley	valley	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1309
242	http://gis.zcu.cz/SPOI/Ontology#peak	441450	\N	t	69	peak	peak	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	441450
243	http://gis.zcu.cz/SPOI/Ontology#footway	194	\N	t	69	footway	footway	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	194
244	http://gis.zcu.cz/SPOI/Ontology#golf_course	1303	\N	t	69	golf_course	golf_course	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1303
245	http://gis.zcu.cz/SPOI/Ontology#monastery	212	\N	t	69	monastery	monastery	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	212
246	http://gis.zcu.cz/SPOI/Ontology#veterinary	17491	\N	t	69	veterinary	veterinary	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17491
247	http://gis.zcu.cz/SPOI/Ontology#car_parts	18410	\N	t	69	car_parts	car_parts	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18410
248	http://gis.zcu.cz/SPOI/Ontology#parking_space	27668	\N	t	69	parking_space	parking_space	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27668
249	http://gis.zcu.cz/SPOI/Ontology#restaurant	549908	\N	t	69	restaurant	restaurant	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	549908
250	http://gis.zcu.cz/SPOI/Ontology#water_tower	45312	\N	t	69	water_tower	water_tower	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	45312
251	http://gis.zcu.cz/SPOI/Ontology#other	4778255	\N	t	69	other	other	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4778248
252	http://gis.zcu.cz/SPOI/Ontology#art	5712	\N	t	69	art	art	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5712
253	http://gis.zcu.cz/SPOI/Ontology#bicycle_rental	22654	\N	t	69	bicycle_rental	bicycle_rental	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22654
254	http://gis.zcu.cz/SPOI/Ontology#books	25928	\N	t	69	books	books	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25928
255	http://gis.zcu.cz/SPOI/Ontology#bus_stop	1830201	\N	t	69	bus_stop	bus_stop	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1830201
256	http://gis.zcu.cz/SPOI/Ontology#community_centre	21583	\N	t	69	community_centre	community_centre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21583
257	http://gis.zcu.cz/SPOI/Ontology#copyshop	8243	\N	t	69	copyshop	copyshop	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8243
258	http://gis.zcu.cz/SPOI/Ontology#dock	1166	\N	t	69	dock	dock	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1166
259	http://gis.zcu.cz/SPOI/Ontology#jewish	22	\N	t	69	jewish	jewish	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
260	http://gis.zcu.cz/SPOI/Ontology#parking_entrance	34452	\N	t	69	parking_entrance	parking_entrance	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34452
261	http://gis.zcu.cz/SPOI/Ontology#pub	104556	\N	t	69	pub	pub	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	104556
262	http://gis.zcu.cz/SPOI/Ontology#public_toilet	405	\N	t	69	public_toilet	public_toilet	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	405
263	http://gis.zcu.cz/SPOI/Ontology#cathedral	29	\N	t	69	cathedral	cathedral	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
264	http://gis.zcu.cz/SPOI/Ontology#dune	133	\N	t	69	dune	dune	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	132
265	http://gis.zcu.cz/SPOI/Ontology#mixed_lift	2	\N	t	69	mixed_lift	mixed_lift	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
266	http://gis.zcu.cz/SPOI/Ontology#mountain_range	11	\N	t	69	mountain_range	mountain_range	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
267	http://gis.zcu.cz/SPOI/Ontology#natural_reserve	4	\N	t	69	natural_reserve	natural_reserve	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
268	http://gis.zcu.cz/SPOI/Ontology#unesco_heritage_object	9	\N	t	69	unesco_heritage_object	unesco_heritage_object	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
269	http://gis.zcu.cz/SPOI/Ontology#wreck	1650	\N	t	69	wreck	wreck	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1650
270	http://gis.zcu.cz/SPOI/Ontology#Church	1	\N	t	69	Church	Church	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
271	http://gis.zcu.cz/SPOI/Ontology#kiosk	43188	\N	t	69	kiosk	kiosk	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43188
272	http://gis.zcu.cz/SPOI/Ontology#sports_centre	24248	\N	t	69	sports_centre	sports_centre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24248
273	http://gis.zcu.cz/SPOI/Ontology#theatre	14027	\N	t	69	theatre	theatre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14027
274	http://gis.zcu.cz/SPOI/Ontology#ticket	4322	\N	t	69	ticket	ticket	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4322
275	http://gis.zcu.cz/SPOI/Ontology#childcare	3759	\N	t	69	childcare	childcare	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3759
276	http://gis.zcu.cz/SPOI/Ontology#doityourself	26660	\N	t	69	doityourself	doityourself	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26660
277	http://gis.zcu.cz/SPOI/Ontology#ford	4291	\N	t	69	ford	ford	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4291
278	http://gis.zcu.cz/SPOI/Ontology#place_of_worship	405128	\N	t	69	place_of_worship	place_of_worship	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	405128
279	http://gis.zcu.cz/SPOI/Ontology#suburb	91890	\N	t	69	suburb	suburb	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91890
280	http://gis.zcu.cz/SPOI/Ontology#swimming_pool	61809	\N	t	69	swimming_pool	swimming_pool	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	61809
281	http://gis.zcu.cz/SPOI/Ontology#taxi	23760	\N	t	69	taxi	taxi	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23760
282	http://gis.zcu.cz/SPOI/Ontology#hamlet	978197	\N	t	69	hamlet	hamlet	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	978197
283	http://gis.zcu.cz/SPOI/Ontology#reservoir	60487	\N	t	69	reservoir	reservoir	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60487
284	http://gis.zcu.cz/SPOI/Ontology#motel	20303	\N	t	69	motel	motel	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20303
285	http://gis.zcu.cz/SPOI/Ontology#boatyard	799	\N	t	69	boatyard	boatyard	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	799
286	http://gis.zcu.cz/SPOI/Ontology#dive_centre	246	\N	t	69	dive_centre	dive_centre	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	246
287	http://gis.zcu.cz/SPOI/Ontology#fishmonger	992	\N	t	69	fishmonger	fishmonger	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	992
288	http://gis.zcu.cz/SPOI/Ontology#photo	6514	\N	t	69	photo	photo	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6514
289	http://gis.zcu.cz/SPOI/Ontology#ridge	1651	\N	t	69	ridge	ridge	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1651
290	http://gis.zcu.cz/SPOI/Ontology#shower	10823	\N	t	69	shower	shower	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10823
37	http://gis.zcu.cz/SPOI/Ontology#car_service	754107	\N	t	69	car_service	[car service (car_service)]	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	754107
93	http://gis.zcu.cz/SPOI/Ontology#water_tank	2144	\N	t	69	water_tank	[water tank (water_tank)]	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2144
117	http://gis.zcu.cz/SPOI/Ontology#car_rental	9952	\N	t	69	car_rental	[car rental (car_rental)]	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9952
168	http://gis.zcu.cz/SPOI/Ontology#car_repair	68386	\N	t	69	car_repair	[car repair (car_repair)]	46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68386
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	111	1	2	11755408	\N	0	\N	\N	1	1	2	f	11755408	\N	\N
2	109	1	2	4907205	\N	0	\N	\N	2	1	2	f	4907205	\N	\N
3	251	1	2	4778332	\N	0	\N	\N	3	1	2	f	4778332	\N	\N
4	54	1	2	3422593	\N	0	\N	\N	4	1	2	f	3422593	\N	\N
5	55	1	2	2321305	\N	0	\N	\N	5	1	2	f	2321305	\N	\N
6	145	1	2	1301030	\N	0	\N	\N	6	1	2	f	1301030	\N	\N
7	33	1	2	1274886	\N	0	\N	\N	7	1	2	f	1274886	\N	\N
8	139	1	2	709076	\N	0	\N	\N	8	1	2	f	709076	\N	\N
9	91	1	2	125432	\N	0	\N	\N	9	1	2	f	125432	\N	\N
10	70	1	2	1546	\N	0	\N	\N	10	1	2	f	1546	\N	\N
11	149	1	2	9069288	\N	0	\N	\N	0	1	2	f	9069288	\N	\N
12	255	1	2	1831087	\N	0	\N	\N	0	1	2	f	1831087	\N	\N
13	209	1	2	1536813	\N	0	\N	\N	0	1	2	f	1536813	\N	\N
14	126	1	2	1132568	\N	0	\N	\N	0	1	2	f	1132568	\N	\N
15	282	1	2	978200	\N	0	\N	\N	0	1	2	f	978200	\N	\N
16	210	1	2	977170	\N	0	\N	\N	0	1	2	f	977170	\N	\N
17	37	1	2	754155	\N	0	\N	\N	0	1	2	f	754155	\N	\N
18	249	1	2	550009	\N	0	\N	\N	0	1	2	f	550009	\N	\N
19	242	1	2	441566	\N	0	\N	\N	0	1	2	f	441566	\N	\N
20	118	1	2	418532	\N	0	\N	\N	0	1	2	f	418532	\N	\N
21	278	1	2	405162	\N	0	\N	\N	0	1	2	f	405162	\N	\N
22	112	1	2	378751	\N	0	\N	\N	0	1	2	f	378751	\N	\N
23	195	1	2	298709	\N	0	\N	\N	0	1	2	f	298709	\N	\N
24	6	1	2	297070	\N	0	\N	\N	0	1	2	f	297070	\N	\N
25	222	1	2	251605	\N	0	\N	\N	0	1	2	f	251605	\N	\N
26	90	1	2	247422	\N	0	\N	\N	0	1	2	f	247422	\N	\N
27	119	1	2	233178	\N	0	\N	\N	0	1	2	f	233178	\N	\N
28	136	1	2	220141	\N	0	\N	\N	0	1	2	f	220141	\N	\N
29	21	1	2	217378	\N	0	\N	\N	0	1	2	f	217378	\N	\N
30	76	1	2	213534	\N	0	\N	\N	0	1	2	f	213534	\N	\N
31	234	1	2	203977	\N	0	\N	\N	0	1	2	f	203977	\N	\N
32	180	1	2	190279	\N	0	\N	\N	0	1	2	f	190279	\N	\N
33	208	1	2	178467	\N	0	\N	\N	0	1	2	f	178467	\N	\N
34	237	1	2	169796	\N	0	\N	\N	0	1	2	f	169796	\N	\N
35	72	1	2	168152	\N	0	\N	\N	0	1	2	f	168152	\N	\N
36	197	1	2	166140	\N	0	\N	\N	0	1	2	f	166140	\N	\N
37	225	1	2	149835	\N	0	\N	\N	0	1	2	f	149835	\N	\N
38	173	1	2	143288	\N	0	\N	\N	0	1	2	f	143288	\N	\N
39	46	1	2	139923	\N	0	\N	\N	0	1	2	f	139923	\N	\N
40	74	1	2	132507	\N	0	\N	\N	0	1	2	f	132507	\N	\N
41	236	1	2	128062	\N	0	\N	\N	0	1	2	f	128062	\N	\N
42	48	1	2	122014	\N	0	\N	\N	0	1	2	f	122014	\N	\N
43	61	1	2	115452	\N	0	\N	\N	0	1	2	f	115452	\N	\N
44	133	1	2	114350	\N	0	\N	\N	0	1	2	f	114350	\N	\N
45	83	1	2	113440	\N	0	\N	\N	0	1	2	f	113440	\N	\N
46	159	1	2	109705	\N	0	\N	\N	0	1	2	f	109705	\N	\N
47	261	1	2	104567	\N	0	\N	\N	0	1	2	f	104567	\N	\N
48	179	1	2	104372	\N	0	\N	\N	0	1	2	f	104372	\N	\N
49	114	1	2	99662	\N	0	\N	\N	0	1	2	f	99662	\N	\N
50	32	1	2	99488	\N	0	\N	\N	0	1	2	f	99488	\N	\N
51	219	1	2	96407	\N	0	\N	\N	0	1	2	f	96407	\N	\N
52	68	1	2	95105	\N	0	\N	\N	0	1	2	f	95105	\N	\N
53	11	1	2	92879	\N	0	\N	\N	0	1	2	f	92879	\N	\N
54	13	1	2	91940	\N	0	\N	\N	0	1	2	f	91940	\N	\N
55	279	1	2	91893	\N	0	\N	\N	0	1	2	f	91893	\N	\N
56	224	1	2	91352	\N	0	\N	\N	0	1	2	f	91352	\N	\N
57	120	1	2	90049	\N	0	\N	\N	0	1	2	f	90049	\N	\N
58	107	1	2	88703	\N	0	\N	\N	0	1	2	f	88703	\N	\N
59	143	1	2	84821	\N	0	\N	\N	0	1	2	f	84821	\N	\N
60	24	1	2	83883	\N	0	\N	\N	0	1	2	f	83883	\N	\N
61	8	1	2	81823	\N	0	\N	\N	0	1	2	f	81823	\N	\N
62	188	1	2	76776	\N	0	\N	\N	0	1	2	f	76776	\N	\N
63	169	1	2	73651	\N	0	\N	\N	0	1	2	f	73651	\N	\N
64	168	1	2	68392	\N	0	\N	\N	0	1	2	f	68392	\N	\N
65	229	1	2	66870	\N	0	\N	\N	0	1	2	f	66870	\N	\N
66	49	1	2	65149	\N	0	\N	\N	0	1	2	f	65149	\N	\N
67	280	1	2	61809	\N	0	\N	\N	0	1	2	f	61809	\N	\N
68	171	1	2	61230	\N	0	\N	\N	0	1	2	f	61230	\N	\N
69	103	1	2	60913	\N	0	\N	\N	0	1	2	f	60913	\N	\N
70	283	1	2	60487	\N	0	\N	\N	0	1	2	f	60487	\N	\N
71	198	1	2	60002	\N	0	\N	\N	0	1	2	f	60002	\N	\N
72	65	1	2	56183	\N	0	\N	\N	0	1	2	f	56183	\N	\N
73	135	1	2	54788	\N	0	\N	\N	0	1	2	f	54788	\N	\N
74	60	1	2	54345	\N	0	\N	\N	0	1	2	f	54345	\N	\N
75	113	1	2	53347	\N	0	\N	\N	0	1	2	f	53347	\N	\N
76	79	1	2	53154	\N	0	\N	\N	0	1	2	f	53154	\N	\N
77	202	1	2	51761	\N	0	\N	\N	0	1	2	f	51761	\N	\N
78	59	1	2	51395	\N	0	\N	\N	0	1	2	f	51395	\N	\N
79	206	1	2	48060	\N	0	\N	\N	0	1	2	f	48060	\N	\N
80	166	1	2	48016	\N	0	\N	\N	0	1	2	f	48016	\N	\N
81	250	1	2	45312	\N	0	\N	\N	0	1	2	f	45312	\N	\N
82	23	1	2	44412	\N	0	\N	\N	0	1	2	f	44412	\N	\N
83	153	1	2	43571	\N	0	\N	\N	0	1	2	f	43571	\N	\N
84	271	1	2	43188	\N	0	\N	\N	0	1	2	f	43188	\N	\N
85	73	1	2	40291	\N	0	\N	\N	0	1	2	f	40291	\N	\N
86	115	1	2	39849	\N	0	\N	\N	0	1	2	f	39849	\N	\N
87	144	1	2	39319	\N	0	\N	\N	0	1	2	f	39319	\N	\N
88	155	1	2	39232	\N	0	\N	\N	0	1	2	f	39232	\N	\N
89	235	1	2	38059	\N	0	\N	\N	0	1	2	f	38059	\N	\N
90	227	1	2	36765	\N	0	\N	\N	0	1	2	f	36765	\N	\N
91	199	1	2	35400	\N	0	\N	\N	0	1	2	f	35400	\N	\N
92	200	1	2	34532	\N	0	\N	\N	0	1	2	f	34532	\N	\N
93	201	1	2	34453	\N	0	\N	\N	0	1	2	f	34453	\N	\N
94	260	1	2	34452	\N	0	\N	\N	0	1	2	f	34452	\N	\N
95	82	1	2	31641	\N	0	\N	\N	0	1	2	f	31641	\N	\N
96	207	1	2	30805	\N	0	\N	\N	0	1	2	f	30805	\N	\N
97	122	1	2	30612	\N	0	\N	\N	0	1	2	f	30612	\N	\N
98	172	1	2	30100	\N	0	\N	\N	0	1	2	f	30100	\N	\N
99	41	1	2	29226	\N	0	\N	\N	0	1	2	f	29226	\N	\N
100	20	1	2	28680	\N	0	\N	\N	0	1	2	f	28680	\N	\N
101	86	1	2	28581	\N	0	\N	\N	0	1	2	f	28581	\N	\N
102	75	1	2	27869	\N	0	\N	\N	0	1	2	f	27869	\N	\N
103	248	1	2	27669	\N	0	\N	\N	0	1	2	f	27669	\N	\N
104	134	1	2	27456	\N	0	\N	\N	0	1	2	f	27456	\N	\N
105	170	1	2	27249	\N	0	\N	\N	0	1	2	f	27249	\N	\N
106	154	1	2	26677	\N	0	\N	\N	0	1	2	f	26677	\N	\N
107	276	1	2	26660	\N	0	\N	\N	0	1	2	f	26660	\N	\N
108	254	1	2	25929	\N	0	\N	\N	0	1	2	f	25929	\N	\N
109	31	1	2	25210	\N	0	\N	\N	0	1	2	f	25210	\N	\N
110	178	1	2	25207	\N	0	\N	\N	0	1	2	f	25207	\N	\N
111	272	1	2	24250	\N	0	\N	\N	0	1	2	f	24250	\N	\N
112	167	1	2	24225	\N	0	\N	\N	0	1	2	f	24225	\N	\N
113	89	1	2	24123	\N	0	\N	\N	0	1	2	f	24123	\N	\N
114	157	1	2	24097	\N	0	\N	\N	0	1	2	f	24097	\N	\N
115	175	1	2	23982	\N	0	\N	\N	0	1	2	f	23982	\N	\N
116	22	1	2	23927	\N	0	\N	\N	0	1	2	f	23927	\N	\N
117	187	1	2	23878	\N	0	\N	\N	0	1	2	f	23878	\N	\N
118	281	1	2	23760	\N	0	\N	\N	0	1	2	f	23760	\N	\N
119	152	1	2	23732	\N	0	\N	\N	0	1	2	f	23732	\N	\N
120	253	1	2	22654	\N	0	\N	\N	0	1	2	f	22654	\N	\N
121	151	1	2	22006	\N	0	\N	\N	0	1	2	f	22006	\N	\N
122	66	1	2	21981	\N	0	\N	\N	0	1	2	f	21981	\N	\N
123	256	1	2	21584	\N	0	\N	\N	0	1	2	f	21584	\N	\N
124	141	1	2	21576	\N	0	\N	\N	0	1	2	f	21576	\N	\N
125	284	1	2	20304	\N	0	\N	\N	0	1	2	f	20304	\N	\N
126	110	1	2	18963	\N	0	\N	\N	0	1	2	f	18963	\N	\N
127	108	1	2	18595	\N	0	\N	\N	0	1	2	f	18595	\N	\N
128	247	1	2	18411	\N	0	\N	\N	0	1	2	f	18411	\N	\N
129	246	1	2	17493	\N	0	\N	\N	0	1	2	f	17493	\N	\N
130	177	1	2	17271	\N	0	\N	\N	0	1	2	f	17271	\N	\N
131	138	1	2	16789	\N	0	\N	\N	0	1	2	f	16789	\N	\N
132	123	1	2	16770	\N	0	\N	\N	0	1	2	f	16770	\N	\N
133	19	1	2	16739	\N	0	\N	\N	0	1	2	f	16739	\N	\N
134	194	1	2	16553	\N	0	\N	\N	0	1	2	f	16553	\N	\N
135	35	1	2	15527	\N	0	\N	\N	0	1	2	f	15527	\N	\N
136	106	1	2	15462	\N	0	\N	\N	0	1	2	f	15462	\N	\N
137	142	1	2	15376	\N	0	\N	\N	0	1	2	f	15376	\N	\N
138	36	1	2	14834	\N	0	\N	\N	0	1	2	f	14834	\N	\N
139	238	1	2	14454	\N	0	\N	\N	0	1	2	f	14454	\N	\N
140	218	1	2	14248	\N	0	\N	\N	0	1	2	f	14248	\N	\N
141	273	1	2	14031	\N	0	\N	\N	0	1	2	f	14031	\N	\N
142	45	1	2	13990	\N	0	\N	\N	0	1	2	f	13990	\N	\N
143	147	1	2	13557	\N	0	\N	\N	0	1	2	f	13557	\N	\N
144	39	1	2	13410	\N	0	\N	\N	0	1	2	f	13410	\N	\N
145	105	1	2	13294	\N	0	\N	\N	0	1	2	f	13294	\N	\N
146	77	1	2	12376	\N	0	\N	\N	0	1	2	f	12376	\N	\N
147	121	1	2	12342	\N	0	\N	\N	0	1	2	f	12342	\N	\N
148	220	1	2	12263	\N	0	\N	\N	0	1	2	f	12263	\N	\N
149	186	1	2	11818	\N	0	\N	\N	0	1	2	f	11818	\N	\N
150	129	1	2	11626	\N	0	\N	\N	0	1	2	f	11626	\N	\N
151	176	1	2	11611	\N	0	\N	\N	0	1	2	f	11611	\N	\N
152	231	1	2	11385	\N	0	\N	\N	0	1	2	f	11385	\N	\N
153	18	1	2	11182	\N	0	\N	\N	0	1	2	f	11182	\N	\N
154	63	1	2	11148	\N	0	\N	\N	0	1	2	f	11148	\N	\N
155	183	1	2	10890	\N	0	\N	\N	0	1	2	f	10890	\N	\N
156	290	1	2	10823	\N	0	\N	\N	0	1	2	f	10823	\N	\N
157	102	1	2	10800	\N	0	\N	\N	0	1	2	f	10800	\N	\N
158	85	1	2	10157	\N	0	\N	\N	0	1	2	f	10157	\N	\N
159	117	1	2	9954	\N	0	\N	\N	0	1	2	f	9954	\N	\N
160	67	1	2	9168	\N	0	\N	\N	0	1	2	f	9168	\N	\N
161	29	1	2	9022	\N	0	\N	\N	0	1	2	f	9022	\N	\N
162	226	1	2	8733	\N	0	\N	\N	0	1	2	f	8733	\N	\N
163	156	1	2	8484	\N	0	\N	\N	0	1	2	f	8484	\N	\N
164	174	1	2	8427	\N	0	\N	\N	0	1	2	f	8427	\N	\N
165	137	1	2	8343	\N	0	\N	\N	0	1	2	f	8343	\N	\N
166	10	1	2	8280	\N	0	\N	\N	0	1	2	f	8280	\N	\N
167	257	1	2	8243	\N	0	\N	\N	0	1	2	f	8243	\N	\N
168	88	1	2	8129	\N	0	\N	\N	0	1	2	f	8129	\N	\N
169	140	1	2	7797	\N	0	\N	\N	0	1	2	f	7797	\N	\N
170	228	1	2	7758	\N	0	\N	\N	0	1	2	f	7758	\N	\N
171	191	1	2	7512	\N	0	\N	\N	0	1	2	f	7512	\N	\N
172	158	1	2	7287	\N	0	\N	\N	0	1	2	f	7287	\N	\N
173	43	1	2	7282	\N	0	\N	\N	0	1	2	f	7282	\N	\N
174	230	1	2	7259	\N	0	\N	\N	0	1	2	f	7259	\N	\N
175	87	1	2	7055	\N	0	\N	\N	0	1	2	f	7055	\N	\N
176	25	1	2	7011	\N	0	\N	\N	0	1	2	f	7011	\N	\N
177	204	1	2	6867	\N	0	\N	\N	0	1	2	f	6867	\N	\N
178	288	1	2	6514	\N	0	\N	\N	0	1	2	f	6514	\N	\N
179	125	1	2	6322	\N	0	\N	\N	0	1	2	f	6322	\N	\N
180	12	1	2	6276	\N	0	\N	\N	0	1	2	f	6276	\N	\N
181	92	1	2	6256	\N	0	\N	\N	0	1	2	f	6256	\N	\N
182	185	1	2	6076	\N	0	\N	\N	0	1	2	f	6076	\N	\N
183	17	1	2	5857	\N	0	\N	\N	0	1	2	f	5857	\N	\N
184	233	1	2	5771	\N	0	\N	\N	0	1	2	f	5771	\N	\N
185	252	1	2	5713	\N	0	\N	\N	0	1	2	f	5713	\N	\N
186	150	1	2	5373	\N	0	\N	\N	0	1	2	f	5373	\N	\N
187	165	1	2	5067	\N	0	\N	\N	0	1	2	f	5067	\N	\N
188	7	1	2	4961	\N	0	\N	\N	0	1	2	f	4961	\N	\N
189	44	1	2	4775	\N	0	\N	\N	0	1	2	f	4775	\N	\N
190	232	1	2	4587	\N	0	\N	\N	0	1	2	f	4587	\N	\N
191	42	1	2	4381	\N	0	\N	\N	0	1	2	f	4381	\N	\N
192	274	1	2	4322	\N	0	\N	\N	0	1	2	f	4322	\N	\N
193	277	1	2	4291	\N	0	\N	\N	0	1	2	f	4291	\N	\N
194	57	1	2	3861	\N	0	\N	\N	0	1	2	f	3861	\N	\N
195	62	1	2	3793	\N	0	\N	\N	0	1	2	f	3793	\N	\N
196	275	1	2	3759	\N	0	\N	\N	0	1	2	f	3759	\N	\N
197	56	1	2	3731	\N	0	\N	\N	0	1	2	f	3731	\N	\N
198	47	1	2	3664	\N	0	\N	\N	0	1	2	f	3664	\N	\N
199	205	1	2	3604	\N	0	\N	\N	0	1	2	f	3604	\N	\N
200	221	1	2	3544	\N	0	\N	\N	0	1	2	f	3544	\N	\N
201	30	1	2	3502	\N	0	\N	\N	0	1	2	f	3502	\N	\N
202	81	1	2	3442	\N	0	\N	\N	0	1	2	f	3442	\N	\N
203	34	1	2	3161	\N	0	\N	\N	0	1	2	f	3161	\N	\N
204	3	1	2	2958	\N	0	\N	\N	0	1	2	f	2958	\N	\N
205	148	1	2	2921	\N	0	\N	\N	0	1	2	f	2921	\N	\N
206	40	1	2	2279	\N	0	\N	\N	0	1	2	f	2279	\N	\N
207	223	1	2	2278	\N	0	\N	\N	0	1	2	f	2278	\N	\N
208	93	1	2	2144	\N	0	\N	\N	0	1	2	f	2144	\N	\N
209	38	1	2	2133	\N	0	\N	\N	0	1	2	f	2133	\N	\N
210	146	1	2	2102	\N	0	\N	\N	0	1	2	f	2102	\N	\N
211	9	1	2	2099	\N	0	\N	\N	0	1	2	f	2099	\N	\N
212	80	1	2	2051	\N	0	\N	\N	0	1	2	f	2051	\N	\N
213	78	1	2	1956	\N	0	\N	\N	0	1	2	f	1956	\N	\N
214	15	1	2	1909	\N	0	\N	\N	0	1	2	f	1909	\N	\N
215	58	1	2	1739	\N	0	\N	\N	0	1	2	f	1739	\N	\N
216	289	1	2	1651	\N	0	\N	\N	0	1	2	f	1651	\N	\N
217	269	1	2	1650	\N	0	\N	\N	0	1	2	f	1650	\N	\N
218	84	1	2	1531	\N	0	\N	\N	0	1	2	f	1531	\N	\N
219	104	1	2	1509	\N	0	\N	\N	0	1	2	f	1509	\N	\N
220	127	1	2	1337	\N	0	\N	\N	0	1	2	f	1337	\N	\N
221	101	1	2	1320	\N	0	\N	\N	0	1	2	f	1320	\N	\N
222	241	1	2	1309	\N	0	\N	\N	0	1	2	f	1309	\N	\N
223	244	1	2	1303	\N	0	\N	\N	0	1	2	f	1303	\N	\N
224	258	1	2	1166	\N	0	\N	\N	0	1	2	f	1166	\N	\N
225	64	1	2	1135	\N	0	\N	\N	0	1	2	f	1135	\N	\N
226	116	1	2	1069	\N	0	\N	\N	0	1	2	f	1069	\N	\N
227	287	1	2	993	\N	0	\N	\N	0	1	2	f	993	\N	\N
228	192	1	2	864	\N	0	\N	\N	0	1	2	f	864	\N	\N
229	285	1	2	799	\N	0	\N	\N	0	1	2	f	799	\N	\N
230	184	1	2	707	\N	0	\N	\N	0	1	2	f	707	\N	\N
231	182	1	2	660	\N	0	\N	\N	0	1	2	f	660	\N	\N
232	71	1	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
233	124	1	2	588	\N	0	\N	\N	0	1	2	f	588	\N	\N
234	51	1	2	541	\N	0	\N	\N	0	1	2	f	541	\N	\N
235	5	1	2	484	\N	0	\N	\N	0	1	2	f	484	\N	\N
236	16	1	2	478	\N	0	\N	\N	0	1	2	f	478	\N	\N
237	163	1	2	446	\N	0	\N	\N	0	1	2	f	446	\N	\N
238	52	1	2	434	\N	0	\N	\N	0	1	2	f	434	\N	\N
239	128	1	2	420	\N	0	\N	\N	0	1	2	f	420	\N	\N
240	262	1	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
241	214	1	2	398	\N	0	\N	\N	0	1	2	f	398	\N	\N
242	14	1	2	363	\N	0	\N	\N	0	1	2	f	363	\N	\N
243	212	1	2	340	\N	0	\N	\N	0	1	2	f	340	\N	\N
244	203	1	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
245	189	1	2	307	\N	0	\N	\N	0	1	2	f	307	\N	\N
246	196	1	2	301	\N	0	\N	\N	0	1	2	f	301	\N	\N
247	286	1	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
248	4	1	2	227	\N	0	\N	\N	0	1	2	f	227	\N	\N
249	193	1	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
250	245	1	2	213	\N	0	\N	\N	0	1	2	f	213	\N	\N
251	243	1	2	194	\N	0	\N	\N	0	1	2	f	194	\N	\N
252	131	1	2	173	\N	0	\N	\N	0	1	2	f	173	\N	\N
253	99	1	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
254	264	1	2	133	\N	0	\N	\N	0	1	2	f	133	\N	\N
255	190	1	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
256	97	1	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
257	95	1	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
258	162	1	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
259	181	1	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
260	263	1	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
261	160	1	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
262	213	1	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
263	132	1	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
264	259	1	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
265	94	1	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
266	26	1	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
267	240	1	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
268	100	1	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
269	266	1	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
270	268	1	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
271	53	1	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
272	211	1	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
273	161	1	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
274	130	1	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
275	215	1	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
276	267	1	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
277	50	1	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
278	27	1	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
279	239	1	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
280	69	1	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
281	1	1	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
282	265	1	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
283	98	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
284	28	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
285	96	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
286	270	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
287	216	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
288	2	1	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
289	139	2	2	392	\N	0	\N	\N	1	1	2	f	392	\N	\N
290	91	2	2	57	\N	0	\N	\N	2	1	2	f	57	\N	\N
291	145	2	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
292	23	2	2	18	\N	0	\N	\N	4	1	2	f	18	\N	\N
293	33	2	2	18	\N	0	\N	\N	5	1	2	f	18	\N	\N
294	229	2	2	2	\N	0	\N	\N	6	1	2	f	2	\N	\N
295	173	2	2	259	\N	0	\N	\N	0	1	2	f	259	\N	\N
296	77	2	2	127	\N	0	\N	\N	0	1	2	f	127	\N	\N
297	104	2	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
298	54	2	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
299	227	2	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
300	32	2	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
301	249	2	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
302	60	2	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
303	111	2	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
304	85	2	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
305	111	3	2	11772405	\N	11772405	\N	\N	1	1	2	f	0	\N	\N
306	251	3	2	4943745	\N	4943745	\N	\N	2	1	2	f	0	\N	\N
307	109	3	2	4909249	\N	4909249	\N	\N	3	1	2	f	0	\N	\N
308	54	3	2	3450744	\N	3450744	\N	\N	4	1	2	f	0	\N	\N
309	55	3	2	2322875	\N	2322875	\N	\N	5	1	2	f	0	\N	\N
310	145	3	2	1315171	\N	1315167	\N	\N	6	1	2	f	4	\N	\N
311	33	3	2	1275361	\N	1275361	\N	\N	7	1	2	f	0	\N	\N
312	139	3	2	708728	\N	708728	\N	\N	8	1	2	f	0	\N	\N
313	91	3	2	101311	\N	101203	\N	\N	9	1	2	f	108	\N	\N
314	149	3	2	9069459	\N	9069459	\N	\N	0	1	2	f	0	\N	\N
315	255	3	2	1830841	\N	1830841	\N	\N	0	1	2	f	0	\N	\N
316	209	3	2	1536814	\N	1536814	\N	\N	0	1	2	f	0	\N	\N
317	126	3	2	1134214	\N	1134214	\N	\N	0	1	2	f	0	\N	\N
318	210	3	2	1074174	\N	1074174	\N	\N	0	1	2	f	0	\N	\N
319	282	3	2	1011869	\N	1011869	\N	\N	0	1	2	f	0	\N	\N
320	37	3	2	754169	\N	754169	\N	\N	0	1	2	f	0	\N	\N
321	249	3	2	550294	\N	550294	\N	\N	0	1	2	f	0	\N	\N
322	242	3	2	456883	\N	456883	\N	\N	0	1	2	f	0	\N	\N
323	118	3	2	418697	\N	418697	\N	\N	0	1	2	f	0	\N	\N
324	278	3	2	407309	\N	407309	\N	\N	0	1	2	f	0	\N	\N
325	112	3	2	400989	\N	400989	\N	\N	0	1	2	f	0	\N	\N
326	195	3	2	300064	\N	300064	\N	\N	0	1	2	f	0	\N	\N
327	6	3	2	297011	\N	297011	\N	\N	0	1	2	f	0	\N	\N
328	222	3	2	251639	\N	251639	\N	\N	0	1	2	f	0	\N	\N
329	90	3	2	250164	\N	250164	\N	\N	0	1	2	f	0	\N	\N
330	119	3	2	233204	\N	233204	\N	\N	0	1	2	f	0	\N	\N
331	136	3	2	220161	\N	220161	\N	\N	0	1	2	f	0	\N	\N
332	21	3	2	217490	\N	217490	\N	\N	0	1	2	f	0	\N	\N
333	76	3	2	213533	\N	213533	\N	\N	0	1	2	f	0	\N	\N
334	234	3	2	204129	\N	204129	\N	\N	0	1	2	f	0	\N	\N
335	180	3	2	190553	\N	190553	\N	\N	0	1	2	f	0	\N	\N
336	208	3	2	178960	\N	178960	\N	\N	0	1	2	f	0	\N	\N
337	237	3	2	169845	\N	169845	\N	\N	0	1	2	f	0	\N	\N
338	72	3	2	168156	\N	168156	\N	\N	0	1	2	f	0	\N	\N
339	197	3	2	166622	\N	166622	\N	\N	0	1	2	f	0	\N	\N
340	225	3	2	149877	\N	149877	\N	\N	0	1	2	f	0	\N	\N
341	173	3	2	143325	\N	143325	\N	\N	0	1	2	f	0	\N	\N
342	46	3	2	140127	\N	140127	\N	\N	0	1	2	f	0	\N	\N
343	74	3	2	132525	\N	132525	\N	\N	0	1	2	f	0	\N	\N
344	236	3	2	130860	\N	130860	\N	\N	0	1	2	f	0	\N	\N
345	48	3	2	122019	\N	122019	\N	\N	0	1	2	f	0	\N	\N
346	61	3	2	115452	\N	115452	\N	\N	0	1	2	f	0	\N	\N
347	133	3	2	114373	\N	114373	\N	\N	0	1	2	f	0	\N	\N
348	83	3	2	113474	\N	113474	\N	\N	0	1	2	f	0	\N	\N
349	159	3	2	109707	\N	109707	\N	\N	0	1	2	f	0	\N	\N
350	261	3	2	104629	\N	104629	\N	\N	0	1	2	f	0	\N	\N
351	179	3	2	104386	\N	104386	\N	\N	0	1	2	f	0	\N	\N
352	114	3	2	99725	\N	99725	\N	\N	0	1	2	f	0	\N	\N
353	8	3	2	98966	\N	98966	\N	\N	0	1	2	f	0	\N	\N
354	32	3	2	98924	\N	98924	\N	\N	0	1	2	f	0	\N	\N
355	219	3	2	98775	\N	98775	\N	\N	0	1	2	f	0	\N	\N
356	279	3	2	96404	\N	96404	\N	\N	0	1	2	f	0	\N	\N
357	68	3	2	95107	\N	95107	\N	\N	0	1	2	f	0	\N	\N
358	13	3	2	93726	\N	93726	\N	\N	0	1	2	f	0	\N	\N
359	11	3	2	92888	\N	92888	\N	\N	0	1	2	f	0	\N	\N
360	224	3	2	90437	\N	90437	\N	\N	0	1	2	f	0	\N	\N
361	120	3	2	90055	\N	90055	\N	\N	0	1	2	f	0	\N	\N
362	107	3	2	88724	\N	88724	\N	\N	0	1	2	f	0	\N	\N
363	143	3	2	85470	\N	85470	\N	\N	0	1	2	f	0	\N	\N
364	24	3	2	83877	\N	83877	\N	\N	0	1	2	f	0	\N	\N
365	188	3	2	76881	\N	76881	\N	\N	0	1	2	f	0	\N	\N
366	169	3	2	73793	\N	73793	\N	\N	0	1	2	f	0	\N	\N
367	168	3	2	68403	\N	68403	\N	\N	0	1	2	f	0	\N	\N
368	229	3	2	67760	\N	67760	\N	\N	0	1	2	f	0	\N	\N
369	49	3	2	65169	\N	65169	\N	\N	0	1	2	f	0	\N	\N
370	280	3	2	61814	\N	61814	\N	\N	0	1	2	f	0	\N	\N
371	198	3	2	61651	\N	61651	\N	\N	0	1	2	f	0	\N	\N
372	103	3	2	61337	\N	61337	\N	\N	0	1	2	f	0	\N	\N
373	171	3	2	61250	\N	61250	\N	\N	0	1	2	f	0	\N	\N
374	283	3	2	60916	\N	60916	\N	\N	0	1	2	f	0	\N	\N
375	65	3	2	56181	\N	56181	\N	\N	0	1	2	f	0	\N	\N
376	135	3	2	54796	\N	54796	\N	\N	0	1	2	f	0	\N	\N
377	60	3	2	54330	\N	54330	\N	\N	0	1	2	f	0	\N	\N
378	113	3	2	53351	\N	53351	\N	\N	0	1	2	f	0	\N	\N
379	79	3	2	53249	\N	53249	\N	\N	0	1	2	f	0	\N	\N
380	202	3	2	51781	\N	51781	\N	\N	0	1	2	f	0	\N	\N
381	59	3	2	51402	\N	51402	\N	\N	0	1	2	f	0	\N	\N
382	166	3	2	49736	\N	49736	\N	\N	0	1	2	f	0	\N	\N
383	206	3	2	49573	\N	49573	\N	\N	0	1	2	f	0	\N	\N
384	250	3	2	45335	\N	45335	\N	\N	0	1	2	f	0	\N	\N
385	153	3	2	43805	\N	43805	\N	\N	0	1	2	f	0	\N	\N
386	23	3	2	43716	\N	43716	\N	\N	0	1	2	f	0	\N	\N
387	271	3	2	43191	\N	43191	\N	\N	0	1	2	f	0	\N	\N
388	73	3	2	40300	\N	40300	\N	\N	0	1	2	f	0	\N	\N
389	115	3	2	39848	\N	39848	\N	\N	0	1	2	f	0	\N	\N
390	144	3	2	39654	\N	39654	\N	\N	0	1	2	f	0	\N	\N
391	155	3	2	39234	\N	39234	\N	\N	0	1	2	f	0	\N	\N
392	235	3	2	38766	\N	38766	\N	\N	0	1	2	f	0	\N	\N
393	227	3	2	38608	\N	38608	\N	\N	0	1	2	f	0	\N	\N
394	199	3	2	35400	\N	35400	\N	\N	0	1	2	f	0	\N	\N
395	200	3	2	35035	\N	35035	\N	\N	0	1	2	f	0	\N	\N
396	201	3	2	34478	\N	34478	\N	\N	0	1	2	f	0	\N	\N
397	260	3	2	34453	\N	34453	\N	\N	0	1	2	f	0	\N	\N
398	82	3	2	33080	\N	33080	\N	\N	0	1	2	f	0	\N	\N
399	172	3	2	31745	\N	31745	\N	\N	0	1	2	f	0	\N	\N
400	207	3	2	30830	\N	30830	\N	\N	0	1	2	f	0	\N	\N
401	122	3	2	30614	\N	30614	\N	\N	0	1	2	f	0	\N	\N
402	41	3	2	29229	\N	29229	\N	\N	0	1	2	f	0	\N	\N
403	20	3	2	28693	\N	28693	\N	\N	0	1	2	f	0	\N	\N
404	86	3	2	28634	\N	28634	\N	\N	0	1	2	f	0	\N	\N
405	75	3	2	27895	\N	27895	\N	\N	0	1	2	f	0	\N	\N
406	248	3	2	27668	\N	27668	\N	\N	0	1	2	f	0	\N	\N
407	134	3	2	27487	\N	27487	\N	\N	0	1	2	f	0	\N	\N
408	170	3	2	27253	\N	27253	\N	\N	0	1	2	f	0	\N	\N
409	154	3	2	26695	\N	26695	\N	\N	0	1	2	f	0	\N	\N
410	276	3	2	26690	\N	26690	\N	\N	0	1	2	f	0	\N	\N
411	254	3	2	25982	\N	25982	\N	\N	0	1	2	f	0	\N	\N
412	31	3	2	25249	\N	25249	\N	\N	0	1	2	f	0	\N	\N
413	178	3	2	25236	\N	25236	\N	\N	0	1	2	f	0	\N	\N
414	187	3	2	24423	\N	24423	\N	\N	0	1	2	f	0	\N	\N
415	272	3	2	24359	\N	24359	\N	\N	0	1	2	f	0	\N	\N
416	175	3	2	24286	\N	24286	\N	\N	0	1	2	f	0	\N	\N
417	167	3	2	24250	\N	24250	\N	\N	0	1	2	f	0	\N	\N
418	89	3	2	24126	\N	24126	\N	\N	0	1	2	f	0	\N	\N
419	157	3	2	24093	\N	24093	\N	\N	0	1	2	f	0	\N	\N
420	22	3	2	23952	\N	23952	\N	\N	0	1	2	f	0	\N	\N
421	152	3	2	23900	\N	23900	\N	\N	0	1	2	f	0	\N	\N
422	281	3	2	23761	\N	23761	\N	\N	0	1	2	f	0	\N	\N
423	253	3	2	22766	\N	22766	\N	\N	0	1	2	f	0	\N	\N
424	151	3	2	22005	\N	22005	\N	\N	0	1	2	f	0	\N	\N
425	66	3	2	21987	\N	21987	\N	\N	0	1	2	f	0	\N	\N
426	256	3	2	21613	\N	21613	\N	\N	0	1	2	f	0	\N	\N
427	141	3	2	21580	\N	21580	\N	\N	0	1	2	f	0	\N	\N
428	284	3	2	20308	\N	20308	\N	\N	0	1	2	f	0	\N	\N
429	110	3	2	18961	\N	18961	\N	\N	0	1	2	f	0	\N	\N
430	108	3	2	18592	\N	18592	\N	\N	0	1	2	f	0	\N	\N
431	247	3	2	18413	\N	18413	\N	\N	0	1	2	f	0	\N	\N
432	246	3	2	17492	\N	17492	\N	\N	0	1	2	f	0	\N	\N
433	177	3	2	17303	\N	17303	\N	\N	0	1	2	f	0	\N	\N
434	138	3	2	16804	\N	16804	\N	\N	0	1	2	f	0	\N	\N
435	123	3	2	16801	\N	16801	\N	\N	0	1	2	f	0	\N	\N
436	19	3	2	16746	\N	16746	\N	\N	0	1	2	f	0	\N	\N
437	194	3	2	16695	\N	16695	\N	\N	0	1	2	f	0	\N	\N
438	35	3	2	15533	\N	15533	\N	\N	0	1	2	f	0	\N	\N
439	106	3	2	15490	\N	15490	\N	\N	0	1	2	f	0	\N	\N
440	142	3	2	15418	\N	15418	\N	\N	0	1	2	f	0	\N	\N
441	36	3	2	14843	\N	14843	\N	\N	0	1	2	f	0	\N	\N
442	273	3	2	14587	\N	14587	\N	\N	0	1	2	f	0	\N	\N
443	238	3	2	14467	\N	14467	\N	\N	0	1	2	f	0	\N	\N
444	218	3	2	14246	\N	14246	\N	\N	0	1	2	f	0	\N	\N
445	45	3	2	14215	\N	14215	\N	\N	0	1	2	f	0	\N	\N
446	147	3	2	13566	\N	13566	\N	\N	0	1	2	f	0	\N	\N
447	39	3	2	13417	\N	13417	\N	\N	0	1	2	f	0	\N	\N
448	105	3	2	13294	\N	13294	\N	\N	0	1	2	f	0	\N	\N
449	121	3	2	12979	\N	12979	\N	\N	0	1	2	f	0	\N	\N
450	156	3	2	12954	\N	12954	\N	\N	0	1	2	f	0	\N	\N
451	220	3	2	12542	\N	12542	\N	\N	0	1	2	f	0	\N	\N
452	85	3	2	12149	\N	12149	\N	\N	0	1	2	f	0	\N	\N
453	77	3	2	11998	\N	11998	\N	\N	0	1	2	f	0	\N	\N
454	129	3	2	11929	\N	11929	\N	\N	0	1	2	f	0	\N	\N
455	186	3	2	11840	\N	11840	\N	\N	0	1	2	f	0	\N	\N
456	176	3	2	11613	\N	11613	\N	\N	0	1	2	f	0	\N	\N
457	231	3	2	11449	\N	11449	\N	\N	0	1	2	f	0	\N	\N
458	18	3	2	11194	\N	11194	\N	\N	0	1	2	f	0	\N	\N
459	63	3	2	11153	\N	11153	\N	\N	0	1	2	f	0	\N	\N
460	183	3	2	10873	\N	10873	\N	\N	0	1	2	f	0	\N	\N
461	290	3	2	10823	\N	10823	\N	\N	0	1	2	f	0	\N	\N
462	102	3	2	10803	\N	10803	\N	\N	0	1	2	f	0	\N	\N
463	117	3	2	9978	\N	9978	\N	\N	0	1	2	f	0	\N	\N
464	67	3	2	9166	\N	9166	\N	\N	0	1	2	f	0	\N	\N
465	29	3	2	9022	\N	9022	\N	\N	0	1	2	f	0	\N	\N
466	226	3	2	8790	\N	8790	\N	\N	0	1	2	f	0	\N	\N
467	174	3	2	8428	\N	8428	\N	\N	0	1	2	f	0	\N	\N
468	137	3	2	8345	\N	8345	\N	\N	0	1	2	f	0	\N	\N
469	10	3	2	8281	\N	8281	\N	\N	0	1	2	f	0	\N	\N
470	257	3	2	8245	\N	8245	\N	\N	0	1	2	f	0	\N	\N
471	88	3	2	8127	\N	8127	\N	\N	0	1	2	f	0	\N	\N
472	228	3	2	7993	\N	7993	\N	\N	0	1	2	f	0	\N	\N
473	140	3	2	7824	\N	7824	\N	\N	0	1	2	f	0	\N	\N
474	158	3	2	7548	\N	7548	\N	\N	0	1	2	f	0	\N	\N
475	191	3	2	7525	\N	7525	\N	\N	0	1	2	f	0	\N	\N
476	43	3	2	7288	\N	7288	\N	\N	0	1	2	f	0	\N	\N
477	230	3	2	7258	\N	7258	\N	\N	0	1	2	f	0	\N	\N
478	87	3	2	7183	\N	7183	\N	\N	0	1	2	f	0	\N	\N
479	25	3	2	7014	\N	7014	\N	\N	0	1	2	f	0	\N	\N
480	204	3	2	6883	\N	6883	\N	\N	0	1	2	f	0	\N	\N
481	288	3	2	6515	\N	6515	\N	\N	0	1	2	f	0	\N	\N
482	125	3	2	6332	\N	6332	\N	\N	0	1	2	f	0	\N	\N
483	12	3	2	6275	\N	6275	\N	\N	0	1	2	f	0	\N	\N
484	92	3	2	6256	\N	6256	\N	\N	0	1	2	f	0	\N	\N
485	185	3	2	6104	\N	6104	\N	\N	0	1	2	f	0	\N	\N
486	17	3	2	5856	\N	5856	\N	\N	0	1	2	f	0	\N	\N
487	233	3	2	5766	\N	5766	\N	\N	0	1	2	f	0	\N	\N
488	252	3	2	5724	\N	5724	\N	\N	0	1	2	f	0	\N	\N
489	150	3	2	5503	\N	5503	\N	\N	0	1	2	f	0	\N	\N
490	165	3	2	5070	\N	5070	\N	\N	0	1	2	f	0	\N	\N
491	7	3	2	4963	\N	4963	\N	\N	0	1	2	f	0	\N	\N
492	44	3	2	4776	\N	4776	\N	\N	0	1	2	f	0	\N	\N
493	232	3	2	4620	\N	4620	\N	\N	0	1	2	f	0	\N	\N
494	42	3	2	4381	\N	4381	\N	\N	0	1	2	f	0	\N	\N
495	274	3	2	4325	\N	4325	\N	\N	0	1	2	f	0	\N	\N
496	277	3	2	4291	\N	4291	\N	\N	0	1	2	f	0	\N	\N
497	57	3	2	3865	\N	3865	\N	\N	0	1	2	f	0	\N	\N
498	62	3	2	3800	\N	3800	\N	\N	0	1	2	f	0	\N	\N
499	275	3	2	3760	\N	3760	\N	\N	0	1	2	f	0	\N	\N
500	56	3	2	3737	\N	3737	\N	\N	0	1	2	f	0	\N	\N
501	47	3	2	3664	\N	3664	\N	\N	0	1	2	f	0	\N	\N
502	205	3	2	3610	\N	3610	\N	\N	0	1	2	f	0	\N	\N
503	221	3	2	3552	\N	3552	\N	\N	0	1	2	f	0	\N	\N
504	30	3	2	3503	\N	3503	\N	\N	0	1	2	f	0	\N	\N
505	81	3	2	3476	\N	3476	\N	\N	0	1	2	f	0	\N	\N
506	34	3	2	3163	\N	3163	\N	\N	0	1	2	f	0	\N	\N
507	3	3	2	2989	\N	2989	\N	\N	0	1	2	f	0	\N	\N
508	148	3	2	2922	\N	2922	\N	\N	0	1	2	f	0	\N	\N
509	40	3	2	2297	\N	2297	\N	\N	0	1	2	f	0	\N	\N
510	223	3	2	2277	\N	2277	\N	\N	0	1	2	f	0	\N	\N
511	93	3	2	2145	\N	2145	\N	\N	0	1	2	f	0	\N	\N
512	38	3	2	2135	\N	2135	\N	\N	0	1	2	f	0	\N	\N
513	146	3	2	2102	\N	2102	\N	\N	0	1	2	f	0	\N	\N
514	9	3	2	2099	\N	2099	\N	\N	0	1	2	f	0	\N	\N
515	80	3	2	2073	\N	2073	\N	\N	0	1	2	f	0	\N	\N
516	78	3	2	1998	\N	1998	\N	\N	0	1	2	f	0	\N	\N
517	15	3	2	1823	\N	1823	\N	\N	0	1	2	f	0	\N	\N
518	58	3	2	1738	\N	1738	\N	\N	0	1	2	f	0	\N	\N
519	269	3	2	1663	\N	1663	\N	\N	0	1	2	f	0	\N	\N
520	289	3	2	1653	\N	1653	\N	\N	0	1	2	f	0	\N	\N
521	84	3	2	1569	\N	1569	\N	\N	0	1	2	f	0	\N	\N
522	127	3	2	1337	\N	1337	\N	\N	0	1	2	f	0	\N	\N
523	101	3	2	1320	\N	1320	\N	\N	0	1	2	f	0	\N	\N
524	241	3	2	1313	\N	1313	\N	\N	0	1	2	f	0	\N	\N
525	244	3	2	1311	\N	1311	\N	\N	0	1	2	f	0	\N	\N
526	258	3	2	1170	\N	1170	\N	\N	0	1	2	f	0	\N	\N
527	64	3	2	1136	\N	1136	\N	\N	0	1	2	f	0	\N	\N
528	104	3	2	1072	\N	964	\N	\N	0	1	2	f	108	\N	\N
529	116	3	2	1070	\N	1070	\N	\N	0	1	2	f	0	\N	\N
530	287	3	2	992	\N	992	\N	\N	0	1	2	f	0	\N	\N
531	192	3	2	864	\N	864	\N	\N	0	1	2	f	0	\N	\N
532	285	3	2	799	\N	799	\N	\N	0	1	2	f	0	\N	\N
533	184	3	2	707	\N	707	\N	\N	0	1	2	f	0	\N	\N
534	182	3	2	660	\N	660	\N	\N	0	1	2	f	0	\N	\N
535	71	3	2	600	\N	600	\N	\N	0	1	2	f	0	\N	\N
536	124	3	2	588	\N	588	\N	\N	0	1	2	f	0	\N	\N
537	51	3	2	543	\N	543	\N	\N	0	1	2	f	0	\N	\N
538	5	3	2	484	\N	484	\N	\N	0	1	2	f	0	\N	\N
539	16	3	2	481	\N	481	\N	\N	0	1	2	f	0	\N	\N
540	163	3	2	450	\N	450	\N	\N	0	1	2	f	0	\N	\N
541	52	3	2	435	\N	435	\N	\N	0	1	2	f	0	\N	\N
542	128	3	2	421	\N	421	\N	\N	0	1	2	f	0	\N	\N
543	214	3	2	398	\N	398	\N	\N	0	1	2	f	0	\N	\N
544	14	3	2	364	\N	364	\N	\N	0	1	2	f	0	\N	\N
545	203	3	2	310	\N	310	\N	\N	0	1	2	f	0	\N	\N
546	189	3	2	308	\N	308	\N	\N	0	1	2	f	0	\N	\N
547	196	3	2	301	\N	301	\N	\N	0	1	2	f	0	\N	\N
548	286	3	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
549	245	3	2	233	\N	233	\N	\N	0	1	2	f	0	\N	\N
550	4	3	2	227	\N	227	\N	\N	0	1	2	f	0	\N	\N
551	193	3	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
552	243	3	2	194	\N	194	\N	\N	0	1	2	f	0	\N	\N
553	99	3	2	166	\N	166	\N	\N	0	1	2	f	0	\N	\N
554	264	3	2	132	\N	132	\N	\N	0	1	2	f	0	\N	\N
555	190	3	2	129	\N	129	\N	\N	0	1	2	f	0	\N	\N
556	97	3	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
557	95	3	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
558	162	3	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
559	181	3	2	69	\N	69	\N	\N	0	1	2	f	0	\N	\N
560	132	3	2	35	\N	35	\N	\N	0	1	2	f	0	\N	\N
561	263	3	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
562	160	3	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
563	213	3	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
564	259	3	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
565	212	3	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
566	94	3	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
567	26	3	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
568	240	3	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
569	100	3	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
570	266	3	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
571	262	3	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
572	53	3	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
573	211	3	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
574	130	3	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
575	215	3	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
576	50	3	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
577	27	3	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
578	239	3	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
579	69	3	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
580	267	3	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
581	1	3	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
582	265	3	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
583	98	3	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
584	2	3	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
585	139	4	2	821	\N	0	\N	\N	1	1	2	f	821	\N	\N
586	145	4	2	429	\N	0	\N	\N	2	1	2	f	429	\N	\N
587	33	4	2	154	\N	0	\N	\N	3	1	2	f	154	\N	\N
588	91	4	2	108	\N	0	\N	\N	4	1	2	f	108	\N	\N
589	54	4	2	47	\N	0	\N	\N	5	1	2	f	47	\N	\N
590	55	4	2	43	\N	0	\N	\N	6	1	2	f	43	\N	\N
591	135	4	2	19	\N	0	\N	\N	7	1	2	f	19	\N	\N
592	111	4	2	9	\N	0	\N	\N	8	1	2	f	9	\N	\N
593	77	4	2	373	\N	0	\N	\N	0	1	2	f	373	\N	\N
594	173	4	2	284	\N	0	\N	\N	0	1	2	f	284	\N	\N
595	131	4	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
596	32	4	2	137	\N	0	\N	\N	0	1	2	f	137	\N	\N
597	227	4	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
598	104	4	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
599	15	4	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
600	23	4	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
601	251	4	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
602	60	4	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
603	249	4	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
604	229	4	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
605	75	4	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
606	270	4	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
607	216	4	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
608	85	4	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
609	33	5	2	409784	\N	0	\N	\N	1	1	2	f	409784	\N	\N
610	55	5	2	2297	\N	0	\N	\N	2	1	2	f	2297	\N	\N
611	139	5	2	327	\N	0	\N	\N	3	1	2	f	327	\N	\N
612	145	5	2	40	\N	0	\N	\N	4	1	2	f	40	\N	\N
613	54	5	2	39	\N	0	\N	\N	5	1	2	f	39	\N	\N
614	109	5	2	38	\N	0	\N	\N	6	1	2	f	38	\N	\N
615	251	5	2	24	\N	0	\N	\N	7	1	2	f	24	\N	\N
616	91	5	2	2	\N	0	\N	\N	8	1	2	f	2	\N	\N
617	111	5	2	2	\N	0	\N	\N	9	1	2	f	2	\N	\N
618	249	5	2	249706	\N	0	\N	\N	0	1	2	f	249706	\N	\N
619	234	5	2	112197	\N	0	\N	\N	0	1	2	f	112197	\N	\N
620	21	5	2	42752	\N	0	\N	\N	0	1	2	f	42752	\N	\N
621	261	5	2	2538	\N	0	\N	\N	0	1	2	f	2538	\N	\N
622	32	5	2	1889	\N	0	\N	\N	0	1	2	f	1889	\N	\N
623	179	5	2	718	\N	0	\N	\N	0	1	2	f	718	\N	\N
624	67	5	2	479	\N	0	\N	\N	0	1	2	f	479	\N	\N
625	222	5	2	410	\N	0	\N	\N	0	1	2	f	410	\N	\N
626	173	5	2	224	\N	0	\N	\N	0	1	2	f	224	\N	\N
627	208	5	2	188	\N	0	\N	\N	0	1	2	f	188	\N	\N
628	36	5	2	183	\N	0	\N	\N	0	1	2	f	183	\N	\N
629	271	5	2	150	\N	0	\N	\N	0	1	2	f	150	\N	\N
630	44	5	2	141	\N	0	\N	\N	0	1	2	f	141	\N	\N
631	155	5	2	95	\N	0	\N	\N	0	1	2	f	95	\N	\N
632	17	5	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
633	223	5	2	72	\N	0	\N	\N	0	1	2	f	72	\N	\N
634	60	5	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
635	63	5	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
636	58	5	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
637	113	5	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
638	42	5	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
639	37	5	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
640	20	5	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
641	152	5	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
642	66	5	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
643	254	5	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
644	105	5	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
645	108	5	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
646	61	5	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
647	46	5	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
648	195	5	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
649	231	5	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
650	201	5	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
651	136	5	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
652	237	5	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
653	123	5	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
654	180	5	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
655	147	5	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
656	90	5	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
657	31	5	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
658	207	5	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
659	168	5	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
660	273	5	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
661	110	5	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
662	126	5	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
663	142	5	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
664	11	5	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
665	276	5	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
666	9	5	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
667	6	5	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
668	287	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
669	86	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
670	157	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
671	284	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
672	282	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
673	19	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
674	255	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
675	77	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
676	238	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
677	185	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
678	248	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
679	229	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
680	102	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
681	135	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
682	39	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
683	120	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
684	199	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
685	252	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
686	134	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
687	112	5	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
688	23	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
689	117	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
690	257	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
691	125	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
692	24	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
693	30	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
694	178	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
695	170	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
696	272	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
697	13	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
698	169	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
699	256	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
700	115	5	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
701	278	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
702	165	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
703	35	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
704	59	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
705	247	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
706	227	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
707	43	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
708	206	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
709	200	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
710	15	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
711	73	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
712	80	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
713	74	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
714	25	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
715	176	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
716	197	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
717	18	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
718	177	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
719	29	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
720	34	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
721	104	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
722	103	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
723	218	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
724	219	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
725	246	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
726	175	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
727	85	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
728	210	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
729	65	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
730	205	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
731	56	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
732	129	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
733	10	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
734	72	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
735	253	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
736	48	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
737	244	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
738	198	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
739	280	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
740	45	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
741	114	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
742	87	5	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
743	54	6	2	141	\N	0	\N	\N	1	1	2	f	141	\N	\N
744	145	6	2	135	\N	0	\N	\N	2	1	2	f	135	\N	\N
745	110	6	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
746	262	6	2	123	\N	0	\N	\N	0	1	2	f	123	\N	\N
747	43	6	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
748	273	6	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
749	227	6	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
750	23	6	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
751	45	6	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
752	139	6	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
753	139	7	2	692	\N	692	\N	\N	1	1	2	f	0	\N	\N
754	135	8	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
755	251	8	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
756	262	9	2	247	\N	0	\N	\N	1	1	2	f	247	\N	\N
757	145	9	2	69	\N	0	\N	\N	2	1	2	f	69	\N	\N
758	91	9	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
759	33	9	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
760	54	9	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
761	206	9	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
762	70	10	2	1546	\N	0	\N	\N	1	1	2	f	1546	\N	\N
763	111	11	2	11755071	\N	11755071	\N	\N	1	1	2	f	0	\N	\N
764	109	11	2	4906174	\N	4906174	\N	\N	2	1	2	f	0	109	\N
765	251	11	2	4778255	\N	4778255	\N	\N	3	1	2	f	0	\N	\N
766	54	11	2	3422319	\N	3422319	\N	\N	4	1	2	f	0	54	\N
767	55	11	2	2321110	\N	2321110	\N	\N	5	1	2	f	0	\N	\N
768	145	11	2	1300451	\N	1300451	\N	\N	6	1	2	f	0	\N	\N
769	33	11	2	1274717	\N	1274717	\N	\N	7	1	2	f	0	33	\N
770	139	11	2	709021	\N	709021	\N	\N	8	1	2	f	0	\N	\N
771	91	11	2	125391	\N	125391	\N	\N	9	1	2	f	0	\N	\N
772	70	11	2	1546	\N	1546	\N	\N	10	1	2	f	0	70	\N
773	149	11	2	9069126	\N	9069126	\N	\N	0	1	2	f	0	149	\N
774	255	11	2	1830201	\N	1830201	\N	\N	0	1	2	f	0	255	\N
775	209	11	2	1536812	\N	1536812	\N	\N	0	1	2	f	0	209	\N
776	126	11	2	1132543	\N	1132543	\N	\N	0	1	2	f	0	126	\N
777	282	11	2	978197	\N	978197	\N	\N	0	1	2	f	0	282	\N
778	210	11	2	977158	\N	977158	\N	\N	0	1	2	f	0	210	\N
779	37	11	2	754107	\N	754107	\N	\N	0	1	2	f	0	37	\N
780	249	11	2	549908	\N	549908	\N	\N	0	1	2	f	0	249	\N
781	242	11	2	441450	\N	441450	\N	\N	0	1	2	f	0	242	\N
782	118	11	2	418468	\N	418468	\N	\N	0	1	2	f	0	118	\N
783	278	11	2	405128	\N	405128	\N	\N	0	1	2	f	0	278	\N
784	112	11	2	378703	\N	378703	\N	\N	0	1	2	f	0	112	\N
785	195	11	2	298703	\N	298703	\N	\N	0	1	2	f	0	195	\N
786	6	11	2	297060	\N	297060	\N	\N	0	1	2	f	0	6	\N
787	222	11	2	251585	\N	251585	\N	\N	0	1	2	f	0	222	\N
788	90	11	2	247421	\N	247421	\N	\N	0	1	2	f	0	90	\N
789	119	11	2	233176	\N	233176	\N	\N	0	1	2	f	0	119	\N
790	136	11	2	220113	\N	220113	\N	\N	0	1	2	f	0	136	\N
791	21	11	2	217362	\N	217362	\N	\N	0	1	2	f	0	21	\N
792	76	11	2	213533	\N	213533	\N	\N	0	1	2	f	0	76	\N
793	234	11	2	203949	\N	203949	\N	\N	0	1	2	f	0	234	\N
794	180	11	2	190265	\N	190265	\N	\N	0	1	2	f	0	180	\N
795	208	11	2	178450	\N	178450	\N	\N	0	1	2	f	0	208	\N
796	237	11	2	169772	\N	169772	\N	\N	0	1	2	f	0	237	\N
797	72	11	2	168152	\N	168152	\N	\N	0	1	2	f	0	72	\N
798	197	11	2	166120	\N	166120	\N	\N	0	1	2	f	0	197	\N
799	225	11	2	149835	\N	149835	\N	\N	0	1	2	f	0	225	\N
800	173	11	2	143276	\N	143276	\N	\N	0	1	2	f	0	173	\N
801	46	11	2	139906	\N	139906	\N	\N	0	1	2	f	0	46	\N
802	74	11	2	132500	\N	132500	\N	\N	0	1	2	f	0	74	\N
803	236	11	2	128038	\N	128038	\N	\N	0	1	2	f	0	236	\N
804	48	11	2	122012	\N	122012	\N	\N	0	1	2	f	0	48	\N
805	61	11	2	115441	\N	115441	\N	\N	0	1	2	f	0	61	\N
806	133	11	2	114343	\N	114343	\N	\N	0	1	2	f	0	133	\N
807	83	11	2	113400	\N	113400	\N	\N	0	1	2	f	0	83	\N
808	159	11	2	109705	\N	109705	\N	\N	0	1	2	f	0	159	\N
809	261	11	2	104556	\N	104556	\N	\N	0	1	2	f	0	261	\N
810	179	11	2	104349	\N	104349	\N	\N	0	1	2	f	0	179	\N
811	114	11	2	99621	\N	99621	\N	\N	0	1	2	f	0	114	\N
812	32	11	2	99479	\N	99479	\N	\N	0	1	2	f	0	32	\N
813	219	11	2	96397	\N	96397	\N	\N	0	1	2	f	0	219	\N
814	68	11	2	95105	\N	95105	\N	\N	0	1	2	f	0	68	\N
815	11	11	2	92878	\N	92878	\N	\N	0	1	2	f	0	11	\N
816	13	11	2	91937	\N	91937	\N	\N	0	1	2	f	0	13	\N
817	279	11	2	91890	\N	91890	\N	\N	0	1	2	f	0	279	\N
818	224	11	2	91347	\N	91347	\N	\N	0	1	2	f	0	224	\N
819	120	11	2	90029	\N	90029	\N	\N	0	1	2	f	0	120	\N
820	107	11	2	88703	\N	88703	\N	\N	0	1	2	f	0	107	\N
821	143	11	2	84816	\N	84816	\N	\N	0	1	2	f	0	143	\N
822	24	11	2	83872	\N	83872	\N	\N	0	1	2	f	0	24	\N
823	8	11	2	81821	\N	81821	\N	\N	0	1	2	f	0	\N	\N
824	188	11	2	76766	\N	76766	\N	\N	0	1	2	f	0	188	\N
825	169	11	2	73621	\N	73621	\N	\N	0	1	2	f	0	169	\N
826	168	11	2	68386	\N	68386	\N	\N	0	1	2	f	0	168	\N
827	229	11	2	66782	\N	66782	\N	\N	0	1	2	f	0	229	\N
828	49	11	2	65135	\N	65135	\N	\N	0	1	2	f	0	49	\N
829	280	11	2	61809	\N	61809	\N	\N	0	1	2	f	0	280	\N
830	171	11	2	61226	\N	61226	\N	\N	0	1	2	f	0	171	\N
831	103	11	2	60906	\N	60906	\N	\N	0	1	2	f	0	103	\N
832	283	11	2	60487	\N	60487	\N	\N	0	1	2	f	0	283	\N
833	198	11	2	59993	\N	59993	\N	\N	0	1	2	f	0	198	\N
834	65	11	2	56175	\N	56175	\N	\N	0	1	2	f	0	65	\N
835	135	11	2	54788	\N	54788	\N	\N	0	1	2	f	0	135	\N
836	60	11	2	54334	\N	54334	\N	\N	0	1	2	f	0	60	\N
837	113	11	2	53337	\N	53337	\N	\N	0	1	2	f	0	113	\N
838	79	11	2	53153	\N	53153	\N	\N	0	1	2	f	0	\N	\N
839	202	11	2	51760	\N	51760	\N	\N	0	1	2	f	0	202	\N
840	59	11	2	51394	\N	51394	\N	\N	0	1	2	f	0	59	\N
841	206	11	2	48058	\N	48058	\N	\N	0	1	2	f	0	206	\N
842	166	11	2	48009	\N	48009	\N	\N	0	1	2	f	0	166	\N
843	250	11	2	45312	\N	45312	\N	\N	0	1	2	f	0	250	\N
844	23	11	2	44408	\N	44408	\N	\N	0	1	2	f	0	23	\N
845	153	11	2	43567	\N	43567	\N	\N	0	1	2	f	0	153	\N
846	271	11	2	43188	\N	43188	\N	\N	0	1	2	f	0	271	\N
847	73	11	2	40290	\N	40290	\N	\N	0	1	2	f	0	73	\N
848	115	11	2	39848	\N	39848	\N	\N	0	1	2	f	0	115	\N
849	144	11	2	39303	\N	39303	\N	\N	0	1	2	f	0	144	\N
850	155	11	2	39228	\N	39228	\N	\N	0	1	2	f	0	155	\N
851	235	11	2	38059	\N	38059	\N	\N	0	1	2	f	0	\N	\N
852	227	11	2	36753	\N	36753	\N	\N	0	1	2	f	0	227	\N
853	199	11	2	35399	\N	35399	\N	\N	0	1	2	f	0	199	\N
854	200	11	2	34519	\N	34519	\N	\N	0	1	2	f	0	200	\N
855	201	11	2	34452	\N	34452	\N	\N	0	1	2	f	0	201	\N
856	260	11	2	34452	\N	34452	\N	\N	0	1	2	f	0	260	\N
857	82	11	2	31636	\N	31636	\N	\N	0	1	2	f	0	82	\N
858	207	11	2	30801	\N	30801	\N	\N	0	1	2	f	0	207	\N
859	122	11	2	30612	\N	30612	\N	\N	0	1	2	f	0	122	\N
860	172	11	2	30086	\N	30086	\N	\N	0	1	2	f	0	172	\N
861	41	11	2	29224	\N	29224	\N	\N	0	1	2	f	0	41	\N
862	20	11	2	28680	\N	28680	\N	\N	0	1	2	f	0	20	\N
863	86	11	2	28577	\N	28577	\N	\N	0	1	2	f	0	86	\N
864	75	11	2	27866	\N	27866	\N	\N	0	1	2	f	0	75	\N
865	248	11	2	27668	\N	27668	\N	\N	0	1	2	f	0	248	\N
866	134	11	2	27454	\N	27454	\N	\N	0	1	2	f	0	134	\N
867	170	11	2	27248	\N	27248	\N	\N	0	1	2	f	0	170	\N
868	154	11	2	26677	\N	26677	\N	\N	0	1	2	f	0	154	\N
869	276	11	2	26660	\N	26660	\N	\N	0	1	2	f	0	276	\N
870	254	11	2	25928	\N	25928	\N	\N	0	1	2	f	0	254	\N
871	31	11	2	25208	\N	25208	\N	\N	0	1	2	f	0	31	\N
872	178	11	2	25205	\N	25205	\N	\N	0	1	2	f	0	178	\N
873	272	11	2	24248	\N	24248	\N	\N	0	1	2	f	0	272	\N
874	167	11	2	24214	\N	24214	\N	\N	0	1	2	f	0	167	\N
875	89	11	2	24122	\N	24122	\N	\N	0	1	2	f	0	89	\N
876	157	11	2	24079	\N	24079	\N	\N	0	1	2	f	0	157	\N
877	175	11	2	23978	\N	23978	\N	\N	0	1	2	f	0	175	\N
878	22	11	2	23926	\N	23926	\N	\N	0	1	2	f	0	22	\N
879	187	11	2	23859	\N	23859	\N	\N	0	1	2	f	0	187	\N
880	281	11	2	23760	\N	23760	\N	\N	0	1	2	f	0	281	\N
881	152	11	2	23729	\N	23729	\N	\N	0	1	2	f	0	152	\N
882	253	11	2	22654	\N	22654	\N	\N	0	1	2	f	0	253	\N
883	151	11	2	21994	\N	21994	\N	\N	0	1	2	f	0	151	\N
884	66	11	2	21979	\N	21979	\N	\N	0	1	2	f	0	66	\N
885	256	11	2	21583	\N	21583	\N	\N	0	1	2	f	0	256	\N
886	141	11	2	21576	\N	21576	\N	\N	0	1	2	f	0	141	\N
887	284	11	2	20303	\N	20303	\N	\N	0	1	2	f	0	284	\N
888	110	11	2	18959	\N	18959	\N	\N	0	1	2	f	0	110	\N
889	108	11	2	18592	\N	18592	\N	\N	0	1	2	f	0	108	\N
890	247	11	2	18410	\N	18410	\N	\N	0	1	2	f	0	247	\N
891	246	11	2	17491	\N	17491	\N	\N	0	1	2	f	0	246	\N
892	177	11	2	17271	\N	17271	\N	\N	0	1	2	f	0	177	\N
893	138	11	2	16782	\N	16782	\N	\N	0	1	2	f	0	138	\N
894	123	11	2	16767	\N	16767	\N	\N	0	1	2	f	0	123	\N
895	19	11	2	16736	\N	16736	\N	\N	0	1	2	f	0	19	\N
896	194	11	2	16544	\N	16544	\N	\N	0	1	2	f	0	194	\N
897	35	11	2	15526	\N	15526	\N	\N	0	1	2	f	0	35	\N
898	106	11	2	15462	\N	15462	\N	\N	0	1	2	f	0	106	\N
899	142	11	2	15373	\N	15373	\N	\N	0	1	2	f	0	142	\N
900	36	11	2	14833	\N	14833	\N	\N	0	1	2	f	0	36	\N
901	238	11	2	14453	\N	14453	\N	\N	0	1	2	f	0	238	\N
902	218	11	2	14245	\N	14245	\N	\N	0	1	2	f	0	218	\N
903	273	11	2	14027	\N	14027	\N	\N	0	1	2	f	0	273	\N
904	45	11	2	13989	\N	13989	\N	\N	0	1	2	f	0	45	\N
905	147	11	2	13553	\N	13553	\N	\N	0	1	2	f	0	\N	\N
906	39	11	2	13409	\N	13409	\N	\N	0	1	2	f	0	39	\N
907	105	11	2	13293	\N	13293	\N	\N	0	1	2	f	0	105	\N
908	77	11	2	12374	\N	12374	\N	\N	0	1	2	f	0	77	\N
909	121	11	2	12342	\N	12342	\N	\N	0	1	2	f	0	121	\N
910	220	11	2	12262	\N	12262	\N	\N	0	1	2	f	0	220	\N
911	186	11	2	11814	\N	11814	\N	\N	0	1	2	f	0	186	\N
912	129	11	2	11624	\N	11624	\N	\N	0	1	2	f	0	129	\N
913	176	11	2	11609	\N	11609	\N	\N	0	1	2	f	0	176	\N
914	231	11	2	11384	\N	11384	\N	\N	0	1	2	f	0	231	\N
915	18	11	2	11180	\N	11180	\N	\N	0	1	2	f	0	18	\N
916	63	11	2	11148	\N	11148	\N	\N	0	1	2	f	0	63	\N
917	183	11	2	10848	\N	10848	\N	\N	0	1	2	f	0	183	\N
918	290	11	2	10823	\N	10823	\N	\N	0	1	2	f	0	290	\N
919	102	11	2	10800	\N	10800	\N	\N	0	1	2	f	0	102	\N
920	85	11	2	10156	\N	10156	\N	\N	0	1	2	f	0	85	\N
921	117	11	2	9952	\N	9952	\N	\N	0	1	2	f	0	117	\N
922	67	11	2	9163	\N	9163	\N	\N	0	1	2	f	0	67	\N
923	29	11	2	9021	\N	9021	\N	\N	0	1	2	f	0	29	\N
924	226	11	2	8733	\N	8733	\N	\N	0	1	2	f	0	226	\N
925	156	11	2	8484	\N	8484	\N	\N	0	1	2	f	0	156	\N
926	174	11	2	8427	\N	8427	\N	\N	0	1	2	f	0	174	\N
927	137	11	2	8340	\N	8340	\N	\N	0	1	2	f	0	137	\N
928	10	11	2	8280	\N	8280	\N	\N	0	1	2	f	0	10	\N
929	257	11	2	8243	\N	8243	\N	\N	0	1	2	f	0	257	\N
930	88	11	2	8127	\N	8127	\N	\N	0	1	2	f	0	88	\N
931	140	11	2	7797	\N	7797	\N	\N	0	1	2	f	0	140	\N
932	228	11	2	7758	\N	7758	\N	\N	0	1	2	f	0	228	\N
933	191	11	2	7512	\N	7512	\N	\N	0	1	2	f	0	191	\N
934	158	11	2	7287	\N	7287	\N	\N	0	1	2	f	0	158	\N
935	43	11	2	7281	\N	7281	\N	\N	0	1	2	f	0	43	\N
936	230	11	2	7258	\N	7258	\N	\N	0	1	2	f	0	230	\N
937	87	11	2	7053	\N	7053	\N	\N	0	1	2	f	0	87	\N
938	25	11	2	7010	\N	7010	\N	\N	0	1	2	f	0	25	\N
939	204	11	2	6865	\N	6865	\N	\N	0	1	2	f	0	204	\N
940	288	11	2	6514	\N	6514	\N	\N	0	1	2	f	0	288	\N
941	125	11	2	6322	\N	6322	\N	\N	0	1	2	f	0	125	\N
942	12	11	2	6275	\N	6275	\N	\N	0	1	2	f	0	12	\N
943	92	11	2	6256	\N	6256	\N	\N	0	1	2	f	0	92	\N
944	185	11	2	6076	\N	6076	\N	\N	0	1	2	f	0	185	\N
945	17	11	2	5856	\N	5856	\N	\N	0	1	2	f	0	17	\N
946	233	11	2	5771	\N	5771	\N	\N	0	1	2	f	0	233	\N
947	252	11	2	5712	\N	5712	\N	\N	0	1	2	f	0	252	\N
948	150	11	2	5373	\N	5373	\N	\N	0	1	2	f	0	150	\N
949	165	11	2	5067	\N	5067	\N	\N	0	1	2	f	0	165	\N
950	7	11	2	4961	\N	4961	\N	\N	0	1	2	f	0	7	\N
951	44	11	2	4774	\N	4774	\N	\N	0	1	2	f	0	44	\N
952	232	11	2	4583	\N	4583	\N	\N	0	1	2	f	0	232	\N
953	42	11	2	4380	\N	4380	\N	\N	0	1	2	f	0	42	\N
954	274	11	2	4322	\N	4322	\N	\N	0	1	2	f	0	274	\N
955	277	11	2	4291	\N	4291	\N	\N	0	1	2	f	0	277	\N
956	57	11	2	3861	\N	3861	\N	\N	0	1	2	f	0	57	\N
957	62	11	2	3793	\N	3793	\N	\N	0	1	2	f	0	62	\N
958	275	11	2	3759	\N	3759	\N	\N	0	1	2	f	0	275	\N
959	56	11	2	3731	\N	3731	\N	\N	0	1	2	f	0	56	\N
960	47	11	2	3664	\N	3664	\N	\N	0	1	2	f	0	47	\N
961	205	11	2	3604	\N	3604	\N	\N	0	1	2	f	0	205	\N
962	221	11	2	3540	\N	3540	\N	\N	0	1	2	f	0	221	\N
963	30	11	2	3502	\N	3502	\N	\N	0	1	2	f	0	30	\N
964	81	11	2	3439	\N	3439	\N	\N	0	1	2	f	0	81	\N
965	34	11	2	3161	\N	3161	\N	\N	0	1	2	f	0	34	\N
966	3	11	2	2958	\N	2958	\N	\N	0	1	2	f	0	3	\N
967	148	11	2	2921	\N	2921	\N	\N	0	1	2	f	0	148	\N
968	223	11	2	2277	\N	2277	\N	\N	0	1	2	f	0	223	\N
969	40	11	2	2277	\N	2277	\N	\N	0	1	2	f	0	40	\N
970	93	11	2	2144	\N	2144	\N	\N	0	1	2	f	0	93	\N
971	38	11	2	2133	\N	2133	\N	\N	0	1	2	f	0	38	\N
972	146	11	2	2102	\N	2102	\N	\N	0	1	2	f	0	146	\N
973	9	11	2	2099	\N	2099	\N	\N	0	1	2	f	0	9	\N
974	80	11	2	2050	\N	2050	\N	\N	0	1	2	f	0	80	\N
975	78	11	2	1955	\N	1955	\N	\N	0	1	2	f	0	78	\N
976	15	11	2	1909	\N	1909	\N	\N	0	1	2	f	0	\N	\N
977	58	11	2	1738	\N	1738	\N	\N	0	1	2	f	0	58	\N
978	289	11	2	1651	\N	1651	\N	\N	0	1	2	f	0	289	\N
979	269	11	2	1650	\N	1650	\N	\N	0	1	2	f	0	269	\N
980	84	11	2	1530	\N	1530	\N	\N	0	1	2	f	0	84	\N
981	104	11	2	1509	\N	1509	\N	\N	0	1	2	f	0	104	\N
982	127	11	2	1337	\N	1337	\N	\N	0	1	2	f	0	127	\N
983	101	11	2	1320	\N	1320	\N	\N	0	1	2	f	0	101	\N
984	241	11	2	1309	\N	1309	\N	\N	0	1	2	f	0	241	\N
985	244	11	2	1303	\N	1303	\N	\N	0	1	2	f	0	244	\N
986	258	11	2	1166	\N	1166	\N	\N	0	1	2	f	0	258	\N
987	64	11	2	1135	\N	1135	\N	\N	0	1	2	f	0	64	\N
988	116	11	2	1069	\N	1069	\N	\N	0	1	2	f	0	116	\N
989	287	11	2	992	\N	992	\N	\N	0	1	2	f	0	287	\N
990	192	11	2	864	\N	864	\N	\N	0	1	2	f	0	192	\N
991	285	11	2	799	\N	799	\N	\N	0	1	2	f	0	285	\N
992	184	11	2	707	\N	707	\N	\N	0	1	2	f	0	184	\N
993	182	11	2	660	\N	660	\N	\N	0	1	2	f	0	182	\N
994	71	11	2	597	\N	597	\N	\N	0	1	2	f	0	71	\N
995	124	11	2	588	\N	588	\N	\N	0	1	2	f	0	124	\N
996	51	11	2	541	\N	541	\N	\N	0	1	2	f	0	51	\N
997	5	11	2	484	\N	484	\N	\N	0	1	2	f	0	5	\N
998	16	11	2	478	\N	478	\N	\N	0	1	2	f	0	16	\N
999	163	11	2	446	\N	446	\N	\N	0	1	2	f	0	163	\N
1000	52	11	2	434	\N	434	\N	\N	0	1	2	f	0	52	\N
1001	128	11	2	419	\N	419	\N	\N	0	1	2	f	0	128	\N
1002	262	11	2	405	\N	405	\N	\N	0	1	2	f	0	262	\N
1003	214	11	2	398	\N	398	\N	\N	0	1	2	f	0	214	\N
1004	14	11	2	362	\N	362	\N	\N	0	1	2	f	0	14	\N
1005	212	11	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
1006	203	11	2	308	\N	308	\N	\N	0	1	2	f	0	203	\N
1007	189	11	2	307	\N	307	\N	\N	0	1	2	f	0	189	\N
1008	196	11	2	301	\N	301	\N	\N	0	1	2	f	0	196	\N
1009	286	11	2	246	\N	246	\N	\N	0	1	2	f	0	286	\N
1010	4	11	2	227	\N	227	\N	\N	0	1	2	f	0	4	\N
1011	193	11	2	221	\N	221	\N	\N	0	1	2	f	0	193	\N
1012	245	11	2	212	\N	212	\N	\N	0	1	2	f	0	245	\N
1013	243	11	2	194	\N	194	\N	\N	0	1	2	f	0	243	\N
1014	131	11	2	173	\N	173	\N	\N	0	1	2	f	0	\N	\N
1015	99	11	2	166	\N	166	\N	\N	0	1	2	f	0	99	\N
1016	264	11	2	133	\N	133	\N	\N	0	1	2	f	0	\N	\N
1017	190	11	2	128	\N	128	\N	\N	0	1	2	f	0	190	\N
1018	97	11	2	113	\N	113	\N	\N	0	1	2	f	0	97	\N
1019	95	11	2	105	\N	105	\N	\N	0	1	2	f	0	95	\N
1020	162	11	2	77	\N	77	\N	\N	0	1	2	f	0	162	\N
1021	181	11	2	68	\N	68	\N	\N	0	1	2	f	0	181	\N
1022	263	11	2	29	\N	29	\N	\N	0	1	2	f	0	263	\N
1023	160	11	2	27	\N	27	\N	\N	0	1	2	f	0	160	\N
1024	213	11	2	26	\N	26	\N	\N	0	1	2	f	0	213	\N
1025	132	11	2	24	\N	24	\N	\N	0	1	2	f	0	132	\N
1026	259	11	2	22	\N	22	\N	\N	0	1	2	f	0	259	\N
1027	94	11	2	18	\N	18	\N	\N	0	1	2	f	0	94	\N
1028	26	11	2	15	\N	15	\N	\N	0	1	2	f	0	26	\N
1029	240	11	2	14	\N	14	\N	\N	0	1	2	f	0	240	\N
1030	100	11	2	11	\N	11	\N	\N	0	1	2	f	0	100	\N
1031	266	11	2	11	\N	11	\N	\N	0	1	2	f	0	266	\N
1032	268	11	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1033	53	11	2	5	\N	5	\N	\N	0	1	2	f	0	53	\N
1034	211	11	2	5	\N	5	\N	\N	0	1	2	f	0	211	\N
1035	161	11	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1036	130	11	2	5	\N	5	\N	\N	0	1	2	f	0	130	\N
1037	215	11	2	5	\N	5	\N	\N	0	1	2	f	0	215	\N
1038	267	11	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1039	50	11	2	3	\N	3	\N	\N	0	1	2	f	0	50	\N
1040	27	11	2	3	\N	3	\N	\N	0	1	2	f	0	27	\N
1041	239	11	2	2	\N	2	\N	\N	0	1	2	f	0	239	\N
1042	69	11	2	2	\N	2	\N	\N	0	1	2	f	0	69	\N
1043	1	11	2	2	\N	2	\N	\N	0	1	2	f	0	1	\N
1044	265	11	2	2	\N	2	\N	\N	0	1	2	f	0	265	\N
1045	98	11	2	1	\N	1	\N	\N	0	1	2	f	0	98	\N
1046	28	11	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1047	96	11	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1048	270	11	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1049	216	11	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1050	2	11	2	1	\N	1	\N	\N	0	1	2	f	0	2	\N
1051	111	11	1	11755058	\N	11755058	\N	\N	1	1	2	f	\N	111	\N
1052	109	11	1	4906174	\N	4906174	\N	\N	2	1	2	f	\N	109	\N
1053	251	11	1	4778248	\N	4778248	\N	\N	3	1	2	f	\N	251	\N
1054	54	11	1	3422319	\N	3422319	\N	\N	4	1	2	f	\N	54	\N
1055	55	11	1	2321108	\N	2321108	\N	\N	5	1	2	f	\N	55	\N
1056	145	11	1	1300433	\N	1300433	\N	\N	6	1	2	f	\N	145	\N
1057	33	11	1	1274717	\N	1274717	\N	\N	7	1	2	f	\N	33	\N
1058	139	11	1	708848	\N	708848	\N	\N	8	1	2	f	\N	139	\N
1059	91	11	1	125388	\N	125388	\N	\N	9	1	2	f	\N	91	\N
1060	70	11	1	1546	\N	1546	\N	\N	10	1	2	f	\N	70	\N
1061	149	11	1	9069126	\N	9069126	\N	\N	0	1	2	f	\N	149	\N
1062	255	11	1	1830201	\N	1830201	\N	\N	0	1	2	f	\N	255	\N
1063	209	11	1	1536812	\N	1536812	\N	\N	0	1	2	f	\N	209	\N
1064	126	11	1	1132543	\N	1132543	\N	\N	0	1	2	f	\N	126	\N
1065	282	11	1	978197	\N	978197	\N	\N	0	1	2	f	\N	282	\N
1066	210	11	1	977158	\N	977158	\N	\N	0	1	2	f	\N	210	\N
1067	37	11	1	754107	\N	754107	\N	\N	0	1	2	f	\N	37	\N
1068	249	11	1	549908	\N	549908	\N	\N	0	1	2	f	\N	249	\N
1069	242	11	1	441450	\N	441450	\N	\N	0	1	2	f	\N	242	\N
1070	118	11	1	418468	\N	418468	\N	\N	0	1	2	f	\N	118	\N
1071	278	11	1	405128	\N	405128	\N	\N	0	1	2	f	\N	278	\N
1072	112	11	1	378703	\N	378703	\N	\N	0	1	2	f	\N	112	\N
1073	195	11	1	298703	\N	298703	\N	\N	0	1	2	f	\N	195	\N
1074	6	11	1	297060	\N	297060	\N	\N	0	1	2	f	\N	6	\N
1075	222	11	1	251585	\N	251585	\N	\N	0	1	2	f	\N	222	\N
1076	90	11	1	247421	\N	247421	\N	\N	0	1	2	f	\N	90	\N
1077	119	11	1	233176	\N	233176	\N	\N	0	1	2	f	\N	119	\N
1078	136	11	1	220113	\N	220113	\N	\N	0	1	2	f	\N	136	\N
1079	21	11	1	217362	\N	217362	\N	\N	0	1	2	f	\N	21	\N
1080	76	11	1	213533	\N	213533	\N	\N	0	1	2	f	\N	76	\N
1081	234	11	1	203949	\N	203949	\N	\N	0	1	2	f	\N	234	\N
1082	180	11	1	190265	\N	190265	\N	\N	0	1	2	f	\N	180	\N
1083	208	11	1	178450	\N	178450	\N	\N	0	1	2	f	\N	208	\N
1084	237	11	1	169772	\N	169772	\N	\N	0	1	2	f	\N	237	\N
1085	72	11	1	168152	\N	168152	\N	\N	0	1	2	f	\N	72	\N
1086	197	11	1	166120	\N	166120	\N	\N	0	1	2	f	\N	197	\N
1087	225	11	1	149835	\N	149835	\N	\N	0	1	2	f	\N	225	\N
1088	173	11	1	143276	\N	143276	\N	\N	0	1	2	f	\N	173	\N
1089	46	11	1	139906	\N	139906	\N	\N	0	1	2	f	\N	46	\N
1090	74	11	1	132500	\N	132500	\N	\N	0	1	2	f	\N	74	\N
1091	236	11	1	128038	\N	128038	\N	\N	0	1	2	f	\N	236	\N
1092	48	11	1	122012	\N	122012	\N	\N	0	1	2	f	\N	48	\N
1093	61	11	1	115441	\N	115441	\N	\N	0	1	2	f	\N	61	\N
1094	133	11	1	114343	\N	114343	\N	\N	0	1	2	f	\N	133	\N
1095	83	11	1	113400	\N	113400	\N	\N	0	1	2	f	\N	83	\N
1096	159	11	1	109705	\N	109705	\N	\N	0	1	2	f	\N	159	\N
1097	261	11	1	104556	\N	104556	\N	\N	0	1	2	f	\N	261	\N
1098	179	11	1	104349	\N	104349	\N	\N	0	1	2	f	\N	179	\N
1099	114	11	1	99621	\N	99621	\N	\N	0	1	2	f	\N	114	\N
1100	32	11	1	99479	\N	99479	\N	\N	0	1	2	f	\N	32	\N
1101	219	11	1	96397	\N	96397	\N	\N	0	1	2	f	\N	219	\N
1102	68	11	1	95105	\N	95105	\N	\N	0	1	2	f	\N	68	\N
1103	11	11	1	92878	\N	92878	\N	\N	0	1	2	f	\N	11	\N
1104	13	11	1	91937	\N	91937	\N	\N	0	1	2	f	\N	13	\N
1105	279	11	1	91890	\N	91890	\N	\N	0	1	2	f	\N	279	\N
1106	224	11	1	91347	\N	91347	\N	\N	0	1	2	f	\N	224	\N
1107	120	11	1	90029	\N	90029	\N	\N	0	1	2	f	\N	120	\N
1108	107	11	1	88703	\N	88703	\N	\N	0	1	2	f	\N	107	\N
1109	143	11	1	84816	\N	84816	\N	\N	0	1	2	f	\N	143	\N
1110	24	11	1	83872	\N	83872	\N	\N	0	1	2	f	\N	24	\N
1111	8	11	1	81816	\N	81816	\N	\N	0	1	2	f	\N	8	\N
1112	188	11	1	76766	\N	76766	\N	\N	0	1	2	f	\N	188	\N
1113	169	11	1	73621	\N	73621	\N	\N	0	1	2	f	\N	169	\N
1114	168	11	1	68386	\N	68386	\N	\N	0	1	2	f	\N	168	\N
1115	229	11	1	66782	\N	66782	\N	\N	0	1	2	f	\N	229	\N
1116	49	11	1	65135	\N	65135	\N	\N	0	1	2	f	\N	49	\N
1117	280	11	1	61809	\N	61809	\N	\N	0	1	2	f	\N	280	\N
1118	171	11	1	61226	\N	61226	\N	\N	0	1	2	f	\N	171	\N
1119	103	11	1	60906	\N	60906	\N	\N	0	1	2	f	\N	103	\N
1120	283	11	1	60487	\N	60487	\N	\N	0	1	2	f	\N	283	\N
1121	198	11	1	59993	\N	59993	\N	\N	0	1	2	f	\N	198	\N
1122	65	11	1	56175	\N	56175	\N	\N	0	1	2	f	\N	65	\N
1123	135	11	1	54788	\N	54788	\N	\N	0	1	2	f	\N	135	\N
1124	60	11	1	54334	\N	54334	\N	\N	0	1	2	f	\N	60	\N
1125	113	11	1	53337	\N	53337	\N	\N	0	1	2	f	\N	113	\N
1126	79	11	1	53152	\N	53152	\N	\N	0	1	2	f	\N	79	\N
1127	202	11	1	51760	\N	51760	\N	\N	0	1	2	f	\N	202	\N
1128	59	11	1	51394	\N	51394	\N	\N	0	1	2	f	\N	59	\N
1129	206	11	1	48058	\N	48058	\N	\N	0	1	2	f	\N	206	\N
1130	166	11	1	48009	\N	48009	\N	\N	0	1	2	f	\N	166	\N
1131	250	11	1	45312	\N	45312	\N	\N	0	1	2	f	\N	250	\N
1132	23	11	1	44408	\N	44408	\N	\N	0	1	2	f	\N	23	\N
1133	153	11	1	43567	\N	43567	\N	\N	0	1	2	f	\N	153	\N
1134	271	11	1	43188	\N	43188	\N	\N	0	1	2	f	\N	271	\N
1135	73	11	1	40290	\N	40290	\N	\N	0	1	2	f	\N	73	\N
1136	115	11	1	39848	\N	39848	\N	\N	0	1	2	f	\N	115	\N
1137	144	11	1	39303	\N	39303	\N	\N	0	1	2	f	\N	144	\N
1138	155	11	1	39228	\N	39228	\N	\N	0	1	2	f	\N	155	\N
1139	235	11	1	38057	\N	38057	\N	\N	0	1	2	f	\N	235	\N
1140	227	11	1	36753	\N	36753	\N	\N	0	1	2	f	\N	227	\N
1141	199	11	1	35399	\N	35399	\N	\N	0	1	2	f	\N	199	\N
1142	200	11	1	34519	\N	34519	\N	\N	0	1	2	f	\N	200	\N
1143	201	11	1	34452	\N	34452	\N	\N	0	1	2	f	\N	201	\N
1144	260	11	1	34452	\N	34452	\N	\N	0	1	2	f	\N	260	\N
1145	82	11	1	31636	\N	31636	\N	\N	0	1	2	f	\N	82	\N
1146	207	11	1	30801	\N	30801	\N	\N	0	1	2	f	\N	207	\N
1147	122	11	1	30612	\N	30612	\N	\N	0	1	2	f	\N	122	\N
1148	172	11	1	30086	\N	30086	\N	\N	0	1	2	f	\N	172	\N
1149	41	11	1	29224	\N	29224	\N	\N	0	1	2	f	\N	41	\N
1150	20	11	1	28680	\N	28680	\N	\N	0	1	2	f	\N	20	\N
1151	86	11	1	28577	\N	28577	\N	\N	0	1	2	f	\N	86	\N
1152	75	11	1	27866	\N	27866	\N	\N	0	1	2	f	\N	75	\N
1153	248	11	1	27668	\N	27668	\N	\N	0	1	2	f	\N	248	\N
1154	134	11	1	27454	\N	27454	\N	\N	0	1	2	f	\N	134	\N
1155	170	11	1	27248	\N	27248	\N	\N	0	1	2	f	\N	170	\N
1156	154	11	1	26677	\N	26677	\N	\N	0	1	2	f	\N	154	\N
1157	276	11	1	26660	\N	26660	\N	\N	0	1	2	f	\N	276	\N
1158	254	11	1	25928	\N	25928	\N	\N	0	1	2	f	\N	254	\N
1159	31	11	1	25208	\N	25208	\N	\N	0	1	2	f	\N	31	\N
1160	178	11	1	25205	\N	25205	\N	\N	0	1	2	f	\N	178	\N
1161	272	11	1	24248	\N	24248	\N	\N	0	1	2	f	\N	272	\N
1162	167	11	1	24214	\N	24214	\N	\N	0	1	2	f	\N	167	\N
1163	89	11	1	24122	\N	24122	\N	\N	0	1	2	f	\N	89	\N
1164	157	11	1	24079	\N	24079	\N	\N	0	1	2	f	\N	157	\N
1165	175	11	1	23978	\N	23978	\N	\N	0	1	2	f	\N	175	\N
1166	22	11	1	23926	\N	23926	\N	\N	0	1	2	f	\N	22	\N
1167	187	11	1	23859	\N	23859	\N	\N	0	1	2	f	\N	187	\N
1168	281	11	1	23760	\N	23760	\N	\N	0	1	2	f	\N	281	\N
1169	152	11	1	23729	\N	23729	\N	\N	0	1	2	f	\N	152	\N
1170	253	11	1	22654	\N	22654	\N	\N	0	1	2	f	\N	253	\N
1171	151	11	1	21994	\N	21994	\N	\N	0	1	2	f	\N	151	\N
1172	66	11	1	21979	\N	21979	\N	\N	0	1	2	f	\N	66	\N
1173	256	11	1	21583	\N	21583	\N	\N	0	1	2	f	\N	256	\N
1174	141	11	1	21576	\N	21576	\N	\N	0	1	2	f	\N	141	\N
1175	284	11	1	20303	\N	20303	\N	\N	0	1	2	f	\N	284	\N
1176	110	11	1	18959	\N	18959	\N	\N	0	1	2	f	\N	110	\N
1177	108	11	1	18592	\N	18592	\N	\N	0	1	2	f	\N	108	\N
1178	247	11	1	18410	\N	18410	\N	\N	0	1	2	f	\N	247	\N
1179	246	11	1	17491	\N	17491	\N	\N	0	1	2	f	\N	246	\N
1180	177	11	1	17271	\N	17271	\N	\N	0	1	2	f	\N	177	\N
1181	138	11	1	16782	\N	16782	\N	\N	0	1	2	f	\N	138	\N
1182	123	11	1	16767	\N	16767	\N	\N	0	1	2	f	\N	123	\N
1183	19	11	1	16736	\N	16736	\N	\N	0	1	2	f	\N	19	\N
1184	194	11	1	16544	\N	16544	\N	\N	0	1	2	f	\N	194	\N
1185	35	11	1	15526	\N	15526	\N	\N	0	1	2	f	\N	35	\N
1186	106	11	1	15462	\N	15462	\N	\N	0	1	2	f	\N	106	\N
1187	142	11	1	15373	\N	15373	\N	\N	0	1	2	f	\N	142	\N
1188	36	11	1	14833	\N	14833	\N	\N	0	1	2	f	\N	36	\N
1189	238	11	1	14453	\N	14453	\N	\N	0	1	2	f	\N	238	\N
1190	218	11	1	14245	\N	14245	\N	\N	0	1	2	f	\N	218	\N
1191	273	11	1	14027	\N	14027	\N	\N	0	1	2	f	\N	273	\N
1192	45	11	1	13989	\N	13989	\N	\N	0	1	2	f	\N	45	\N
1193	147	11	1	13551	\N	13551	\N	\N	0	1	2	f	\N	147	\N
1194	39	11	1	13409	\N	13409	\N	\N	0	1	2	f	\N	39	\N
1195	105	11	1	13293	\N	13293	\N	\N	0	1	2	f	\N	105	\N
1196	77	11	1	12374	\N	12374	\N	\N	0	1	2	f	\N	77	\N
1197	121	11	1	12342	\N	12342	\N	\N	0	1	2	f	\N	121	\N
1198	220	11	1	12262	\N	12262	\N	\N	0	1	2	f	\N	220	\N
1199	186	11	1	11814	\N	11814	\N	\N	0	1	2	f	\N	186	\N
1200	129	11	1	11624	\N	11624	\N	\N	0	1	2	f	\N	129	\N
1201	176	11	1	11609	\N	11609	\N	\N	0	1	2	f	\N	176	\N
1202	231	11	1	11384	\N	11384	\N	\N	0	1	2	f	\N	231	\N
1203	18	11	1	11180	\N	11180	\N	\N	0	1	2	f	\N	18	\N
1204	63	11	1	11148	\N	11148	\N	\N	0	1	2	f	\N	63	\N
1205	183	11	1	10848	\N	10848	\N	\N	0	1	2	f	\N	183	\N
1206	290	11	1	10823	\N	10823	\N	\N	0	1	2	f	\N	290	\N
1207	102	11	1	10800	\N	10800	\N	\N	0	1	2	f	\N	102	\N
1208	85	11	1	10156	\N	10156	\N	\N	0	1	2	f	\N	85	\N
1209	117	11	1	9952	\N	9952	\N	\N	0	1	2	f	\N	117	\N
1210	67	11	1	9163	\N	9163	\N	\N	0	1	2	f	\N	67	\N
1211	29	11	1	9021	\N	9021	\N	\N	0	1	2	f	\N	29	\N
1212	226	11	1	8733	\N	8733	\N	\N	0	1	2	f	\N	226	\N
1213	156	11	1	8484	\N	8484	\N	\N	0	1	2	f	\N	156	\N
1214	174	11	1	8427	\N	8427	\N	\N	0	1	2	f	\N	174	\N
1215	137	11	1	8340	\N	8340	\N	\N	0	1	2	f	\N	137	\N
1216	10	11	1	8280	\N	8280	\N	\N	0	1	2	f	\N	10	\N
1217	257	11	1	8243	\N	8243	\N	\N	0	1	2	f	\N	257	\N
1218	88	11	1	8127	\N	8127	\N	\N	0	1	2	f	\N	88	\N
1219	140	11	1	7797	\N	7797	\N	\N	0	1	2	f	\N	140	\N
1220	228	11	1	7758	\N	7758	\N	\N	0	1	2	f	\N	228	\N
1221	191	11	1	7512	\N	7512	\N	\N	0	1	2	f	\N	191	\N
1222	158	11	1	7287	\N	7287	\N	\N	0	1	2	f	\N	158	\N
1223	43	11	1	7281	\N	7281	\N	\N	0	1	2	f	\N	43	\N
1224	230	11	1	7258	\N	7258	\N	\N	0	1	2	f	\N	230	\N
1225	87	11	1	7053	\N	7053	\N	\N	0	1	2	f	\N	87	\N
1226	25	11	1	7010	\N	7010	\N	\N	0	1	2	f	\N	25	\N
1227	204	11	1	6865	\N	6865	\N	\N	0	1	2	f	\N	204	\N
1228	288	11	1	6514	\N	6514	\N	\N	0	1	2	f	\N	288	\N
1229	125	11	1	6322	\N	6322	\N	\N	0	1	2	f	\N	125	\N
1230	12	11	1	6275	\N	6275	\N	\N	0	1	2	f	\N	12	\N
1231	92	11	1	6256	\N	6256	\N	\N	0	1	2	f	\N	92	\N
1232	185	11	1	6076	\N	6076	\N	\N	0	1	2	f	\N	185	\N
1233	17	11	1	5856	\N	5856	\N	\N	0	1	2	f	\N	17	\N
1234	233	11	1	5771	\N	5771	\N	\N	0	1	2	f	\N	233	\N
1235	252	11	1	5712	\N	5712	\N	\N	0	1	2	f	\N	252	\N
1236	150	11	1	5373	\N	5373	\N	\N	0	1	2	f	\N	150	\N
1237	165	11	1	5067	\N	5067	\N	\N	0	1	2	f	\N	165	\N
1238	7	11	1	4961	\N	4961	\N	\N	0	1	2	f	\N	7	\N
1239	44	11	1	4774	\N	4774	\N	\N	0	1	2	f	\N	44	\N
1240	232	11	1	4583	\N	4583	\N	\N	0	1	2	f	\N	232	\N
1241	42	11	1	4380	\N	4380	\N	\N	0	1	2	f	\N	42	\N
1242	274	11	1	4322	\N	4322	\N	\N	0	1	2	f	\N	274	\N
1243	277	11	1	4291	\N	4291	\N	\N	0	1	2	f	\N	277	\N
1244	57	11	1	3861	\N	3861	\N	\N	0	1	2	f	\N	57	\N
1245	62	11	1	3793	\N	3793	\N	\N	0	1	2	f	\N	62	\N
1246	275	11	1	3759	\N	3759	\N	\N	0	1	2	f	\N	275	\N
1247	56	11	1	3731	\N	3731	\N	\N	0	1	2	f	\N	56	\N
1248	47	11	1	3664	\N	3664	\N	\N	0	1	2	f	\N	47	\N
1249	205	11	1	3604	\N	3604	\N	\N	0	1	2	f	\N	205	\N
1250	221	11	1	3540	\N	3540	\N	\N	0	1	2	f	\N	221	\N
1251	30	11	1	3502	\N	3502	\N	\N	0	1	2	f	\N	30	\N
1252	81	11	1	3439	\N	3439	\N	\N	0	1	2	f	\N	81	\N
1253	34	11	1	3161	\N	3161	\N	\N	0	1	2	f	\N	34	\N
1254	3	11	1	2958	\N	2958	\N	\N	0	1	2	f	\N	3	\N
1255	148	11	1	2921	\N	2921	\N	\N	0	1	2	f	\N	148	\N
1256	223	11	1	2277	\N	2277	\N	\N	0	1	2	f	\N	223	\N
1257	40	11	1	2277	\N	2277	\N	\N	0	1	2	f	\N	40	\N
1258	93	11	1	2144	\N	2144	\N	\N	0	1	2	f	\N	93	\N
1259	38	11	1	2133	\N	2133	\N	\N	0	1	2	f	\N	38	\N
1260	146	11	1	2102	\N	2102	\N	\N	0	1	2	f	\N	146	\N
1261	9	11	1	2099	\N	2099	\N	\N	0	1	2	f	\N	9	\N
1262	80	11	1	2050	\N	2050	\N	\N	0	1	2	f	\N	80	\N
1263	78	11	1	1955	\N	1955	\N	\N	0	1	2	f	\N	78	\N
1264	15	11	1	1909	\N	1909	\N	\N	0	1	2	f	\N	\N	\N
1265	58	11	1	1738	\N	1738	\N	\N	0	1	2	f	\N	58	\N
1266	289	11	1	1651	\N	1651	\N	\N	0	1	2	f	\N	289	\N
1267	269	11	1	1650	\N	1650	\N	\N	0	1	2	f	\N	269	\N
1268	84	11	1	1530	\N	1530	\N	\N	0	1	2	f	\N	84	\N
1269	104	11	1	1509	\N	1509	\N	\N	0	1	2	f	\N	104	\N
1270	127	11	1	1337	\N	1337	\N	\N	0	1	2	f	\N	127	\N
1271	101	11	1	1320	\N	1320	\N	\N	0	1	2	f	\N	101	\N
1272	241	11	1	1309	\N	1309	\N	\N	0	1	2	f	\N	241	\N
1273	244	11	1	1303	\N	1303	\N	\N	0	1	2	f	\N	244	\N
1274	258	11	1	1166	\N	1166	\N	\N	0	1	2	f	\N	258	\N
1275	64	11	1	1135	\N	1135	\N	\N	0	1	2	f	\N	64	\N
1276	116	11	1	1069	\N	1069	\N	\N	0	1	2	f	\N	116	\N
1277	287	11	1	992	\N	992	\N	\N	0	1	2	f	\N	287	\N
1278	192	11	1	864	\N	864	\N	\N	0	1	2	f	\N	192	\N
1279	285	11	1	799	\N	799	\N	\N	0	1	2	f	\N	285	\N
1280	184	11	1	707	\N	707	\N	\N	0	1	2	f	\N	184	\N
1281	182	11	1	660	\N	660	\N	\N	0	1	2	f	\N	182	\N
1282	71	11	1	597	\N	597	\N	\N	0	1	2	f	\N	71	\N
1283	124	11	1	588	\N	588	\N	\N	0	1	2	f	\N	124	\N
1284	51	11	1	541	\N	541	\N	\N	0	1	2	f	\N	51	\N
1285	5	11	1	484	\N	484	\N	\N	0	1	2	f	\N	5	\N
1286	16	11	1	478	\N	478	\N	\N	0	1	2	f	\N	16	\N
1287	163	11	1	446	\N	446	\N	\N	0	1	2	f	\N	163	\N
1288	52	11	1	434	\N	434	\N	\N	0	1	2	f	\N	52	\N
1289	128	11	1	419	\N	419	\N	\N	0	1	2	f	\N	128	\N
1290	262	11	1	405	\N	405	\N	\N	0	1	2	f	\N	262	\N
1291	214	11	1	398	\N	398	\N	\N	0	1	2	f	\N	214	\N
1292	14	11	1	362	\N	362	\N	\N	0	1	2	f	\N	14	\N
1293	212	11	1	322	\N	322	\N	\N	0	1	2	f	\N	212	\N
1294	203	11	1	308	\N	308	\N	\N	0	1	2	f	\N	203	\N
1295	189	11	1	307	\N	307	\N	\N	0	1	2	f	\N	189	\N
1296	196	11	1	301	\N	301	\N	\N	0	1	2	f	\N	196	\N
1297	286	11	1	246	\N	246	\N	\N	0	1	2	f	\N	286	\N
1298	4	11	1	227	\N	227	\N	\N	0	1	2	f	\N	4	\N
1299	193	11	1	221	\N	221	\N	\N	0	1	2	f	\N	193	\N
1300	245	11	1	212	\N	212	\N	\N	0	1	2	f	\N	245	\N
1301	243	11	1	194	\N	194	\N	\N	0	1	2	f	\N	243	\N
1302	131	11	1	173	\N	173	\N	\N	0	1	2	f	\N	\N	\N
1303	99	11	1	166	\N	166	\N	\N	0	1	2	f	\N	99	\N
1304	264	11	1	132	\N	132	\N	\N	0	1	2	f	\N	264	\N
1305	190	11	1	128	\N	128	\N	\N	0	1	2	f	\N	190	\N
1306	97	11	1	113	\N	113	\N	\N	0	1	2	f	\N	97	\N
1307	95	11	1	105	\N	105	\N	\N	0	1	2	f	\N	95	\N
1308	162	11	1	77	\N	77	\N	\N	0	1	2	f	\N	162	\N
1309	181	11	1	68	\N	68	\N	\N	0	1	2	f	\N	181	\N
1310	263	11	1	29	\N	29	\N	\N	0	1	2	f	\N	263	\N
1311	160	11	1	27	\N	27	\N	\N	0	1	2	f	\N	160	\N
1312	213	11	1	26	\N	26	\N	\N	0	1	2	f	\N	213	\N
1313	132	11	1	24	\N	24	\N	\N	0	1	2	f	\N	132	\N
1314	259	11	1	22	\N	22	\N	\N	0	1	2	f	\N	259	\N
1315	94	11	1	18	\N	18	\N	\N	0	1	2	f	\N	94	\N
1316	26	11	1	15	\N	15	\N	\N	0	1	2	f	\N	26	\N
1317	240	11	1	14	\N	14	\N	\N	0	1	2	f	\N	240	\N
1318	100	11	1	11	\N	11	\N	\N	0	1	2	f	\N	100	\N
1319	266	11	1	11	\N	11	\N	\N	0	1	2	f	\N	266	\N
1320	53	11	1	5	\N	5	\N	\N	0	1	2	f	\N	53	\N
1321	211	11	1	5	\N	5	\N	\N	0	1	2	f	\N	211	\N
1322	130	11	1	5	\N	5	\N	\N	0	1	2	f	\N	130	\N
1323	215	11	1	5	\N	5	\N	\N	0	1	2	f	\N	215	\N
1324	50	11	1	3	\N	3	\N	\N	0	1	2	f	\N	50	\N
1325	27	11	1	3	\N	3	\N	\N	0	1	2	f	\N	27	\N
1326	239	11	1	2	\N	2	\N	\N	0	1	2	f	\N	239	\N
1327	69	11	1	2	\N	2	\N	\N	0	1	2	f	\N	69	\N
1328	267	11	1	2	\N	2	\N	\N	0	1	2	f	\N	267	\N
1329	1	11	1	2	\N	2	\N	\N	0	1	2	f	\N	1	\N
1330	265	11	1	2	\N	2	\N	\N	0	1	2	f	\N	265	\N
1331	98	11	1	1	\N	1	\N	\N	0	1	2	f	\N	98	\N
1332	270	11	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1333	216	11	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1334	2	11	1	1	\N	1	\N	\N	0	1	2	f	\N	2	\N
1335	54	12	2	141	\N	0	\N	\N	1	1	2	f	141	\N	\N
1336	145	12	2	135	\N	0	\N	\N	2	1	2	f	135	\N	\N
1337	110	12	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
1338	262	12	2	123	\N	0	\N	\N	0	1	2	f	123	\N	\N
1339	43	12	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
1340	273	12	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
1341	227	12	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
1342	23	12	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
1343	45	12	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1344	139	12	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1345	217	13	2	290	\N	290	\N	\N	1	1	2	f	0	217	\N
1346	217	13	1	290	\N	290	\N	\N	1	1	2	f	\N	217	\N
1347	135	14	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
1348	251	14	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1349	91	15	2	37909	\N	0	\N	\N	1	1	2	f	37909	\N	\N
1350	145	15	2	1579	\N	0	\N	\N	2	1	2	f	1579	\N	\N
1351	109	15	2	828	\N	0	\N	\N	3	1	2	f	828	\N	\N
1352	111	15	2	362	\N	0	\N	\N	4	1	2	f	362	\N	\N
1353	217	15	2	298	\N	0	\N	\N	5	1	2	f	298	\N	\N
1354	139	15	2	298	\N	0	\N	\N	6	1	2	f	298	\N	\N
1355	54	15	2	276	\N	0	\N	\N	7	1	2	f	276	\N	\N
1356	251	15	2	30	\N	0	\N	\N	8	1	2	f	30	\N	\N
1357	33	15	2	10	\N	0	\N	\N	9	1	2	f	10	\N	\N
1358	55	15	2	4	\N	0	\N	\N	10	1	2	f	4	\N	\N
1359	172	15	2	827	\N	0	\N	\N	0	1	2	f	827	\N	\N
1360	212	15	2	302	\N	0	\N	\N	0	1	2	f	302	\N	\N
1361	262	15	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
1362	131	15	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
1363	15	15	2	47	\N	0	\N	\N	0	1	2	f	47	\N	\N
1364	135	15	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1365	268	15	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1366	8	15	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1367	229	15	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1368	161	15	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1369	235	15	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1370	267	15	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1371	147	15	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1372	143	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1373	264	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1374	79	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1375	75	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1376	28	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1377	96	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1378	270	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1379	216	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1380	149	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1381	262	16	2	195	\N	0	\N	\N	1	1	2	f	195	\N	\N
1382	54	16	2	195	\N	0	\N	\N	0	1	2	f	195	\N	\N
1383	70	17	2	2596	\N	0	\N	\N	1	1	2	f	2596	\N	\N
1384	109	18	2	5179	\N	0	\N	\N	1	1	2	f	5179	\N	\N
1385	251	18	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
1386	172	18	2	5108	\N	0	\N	\N	0	1	2	f	5108	\N	\N
1387	138	18	2	47	\N	0	\N	\N	0	1	2	f	47	\N	\N
1388	71	18	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1389	224	18	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1390	126	18	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1391	235	18	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1392	139	19	2	665	\N	0	\N	\N	1	1	2	f	665	\N	\N
1393	145	19	2	529	\N	0	\N	\N	2	1	2	f	529	\N	\N
1394	91	19	2	158	\N	0	\N	\N	3	1	2	f	158	\N	\N
1395	33	19	2	46	\N	0	\N	\N	4	1	2	f	46	\N	\N
1396	54	19	2	36	\N	0	\N	\N	5	1	2	f	36	\N	\N
1397	135	19	2	17	\N	0	\N	\N	6	1	2	f	17	\N	\N
1398	111	19	2	6	\N	0	\N	\N	7	1	2	f	6	\N	\N
1399	55	19	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
1400	77	19	2	339	\N	0	\N	\N	0	1	2	f	339	\N	\N
1401	173	19	2	273	\N	0	\N	\N	0	1	2	f	273	\N	\N
1402	131	19	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
1403	104	19	2	151	\N	0	\N	\N	0	1	2	f	151	\N	\N
1404	15	19	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
1405	23	19	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1406	32	19	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
1407	227	19	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1408	251	19	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1409	60	19	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1410	249	19	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1411	229	19	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1412	75	19	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1413	270	19	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1414	216	19	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1415	85	19	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1416	111	20	2	11755071	\N	0	\N	\N	1	1	2	f	11755071	\N	\N
1417	109	20	2	4906174	\N	0	\N	\N	2	1	2	f	4906174	\N	\N
1418	251	20	2	4778255	\N	0	\N	\N	3	1	2	f	4778255	\N	\N
1419	54	20	2	3422319	\N	0	\N	\N	4	1	2	f	3422319	\N	\N
1420	55	20	2	2321110	\N	0	\N	\N	5	1	2	f	2321110	\N	\N
1421	145	20	2	1300451	\N	0	\N	\N	6	1	2	f	1300451	\N	\N
1422	33	20	2	1274717	\N	0	\N	\N	7	1	2	f	1274717	\N	\N
1423	139	20	2	709021	\N	0	\N	\N	8	1	2	f	709021	\N	\N
1424	91	20	2	125391	\N	0	\N	\N	9	1	2	f	125391	\N	\N
1425	70	20	2	1546	\N	0	\N	\N	10	1	2	f	1546	\N	\N
1426	149	20	2	9069126	\N	0	\N	\N	0	1	2	f	9069126	\N	\N
1427	255	20	2	1830201	\N	0	\N	\N	0	1	2	f	1830201	\N	\N
1428	209	20	2	1536812	\N	0	\N	\N	0	1	2	f	1536812	\N	\N
1429	126	20	2	1132543	\N	0	\N	\N	0	1	2	f	1132543	\N	\N
1430	282	20	2	978197	\N	0	\N	\N	0	1	2	f	978197	\N	\N
1431	210	20	2	977158	\N	0	\N	\N	0	1	2	f	977158	\N	\N
1432	37	20	2	754107	\N	0	\N	\N	0	1	2	f	754107	\N	\N
1433	249	20	2	549908	\N	0	\N	\N	0	1	2	f	549908	\N	\N
1434	242	20	2	441450	\N	0	\N	\N	0	1	2	f	441450	\N	\N
1435	118	20	2	418468	\N	0	\N	\N	0	1	2	f	418468	\N	\N
1436	278	20	2	405128	\N	0	\N	\N	0	1	2	f	405128	\N	\N
1437	112	20	2	378703	\N	0	\N	\N	0	1	2	f	378703	\N	\N
1438	195	20	2	298703	\N	0	\N	\N	0	1	2	f	298703	\N	\N
1439	6	20	2	297060	\N	0	\N	\N	0	1	2	f	297060	\N	\N
1440	222	20	2	251585	\N	0	\N	\N	0	1	2	f	251585	\N	\N
1441	90	20	2	247421	\N	0	\N	\N	0	1	2	f	247421	\N	\N
1442	119	20	2	233176	\N	0	\N	\N	0	1	2	f	233176	\N	\N
1443	136	20	2	220113	\N	0	\N	\N	0	1	2	f	220113	\N	\N
1444	21	20	2	217362	\N	0	\N	\N	0	1	2	f	217362	\N	\N
1445	76	20	2	213533	\N	0	\N	\N	0	1	2	f	213533	\N	\N
1446	234	20	2	203949	\N	0	\N	\N	0	1	2	f	203949	\N	\N
1447	180	20	2	190265	\N	0	\N	\N	0	1	2	f	190265	\N	\N
1448	208	20	2	178450	\N	0	\N	\N	0	1	2	f	178450	\N	\N
1449	237	20	2	169772	\N	0	\N	\N	0	1	2	f	169772	\N	\N
1450	72	20	2	168152	\N	0	\N	\N	0	1	2	f	168152	\N	\N
1451	197	20	2	166120	\N	0	\N	\N	0	1	2	f	166120	\N	\N
1452	225	20	2	149835	\N	0	\N	\N	0	1	2	f	149835	\N	\N
1453	173	20	2	143276	\N	0	\N	\N	0	1	2	f	143276	\N	\N
1454	46	20	2	139906	\N	0	\N	\N	0	1	2	f	139906	\N	\N
1455	74	20	2	132500	\N	0	\N	\N	0	1	2	f	132500	\N	\N
1456	236	20	2	128038	\N	0	\N	\N	0	1	2	f	128038	\N	\N
1457	48	20	2	122012	\N	0	\N	\N	0	1	2	f	122012	\N	\N
1458	61	20	2	115441	\N	0	\N	\N	0	1	2	f	115441	\N	\N
1459	133	20	2	114343	\N	0	\N	\N	0	1	2	f	114343	\N	\N
1460	83	20	2	113400	\N	0	\N	\N	0	1	2	f	113400	\N	\N
1461	159	20	2	109705	\N	0	\N	\N	0	1	2	f	109705	\N	\N
1462	261	20	2	104556	\N	0	\N	\N	0	1	2	f	104556	\N	\N
1463	179	20	2	104349	\N	0	\N	\N	0	1	2	f	104349	\N	\N
1464	114	20	2	99621	\N	0	\N	\N	0	1	2	f	99621	\N	\N
1465	32	20	2	99479	\N	0	\N	\N	0	1	2	f	99479	\N	\N
1466	219	20	2	96397	\N	0	\N	\N	0	1	2	f	96397	\N	\N
1467	68	20	2	95105	\N	0	\N	\N	0	1	2	f	95105	\N	\N
1468	11	20	2	92878	\N	0	\N	\N	0	1	2	f	92878	\N	\N
1469	13	20	2	91937	\N	0	\N	\N	0	1	2	f	91937	\N	\N
1470	279	20	2	91890	\N	0	\N	\N	0	1	2	f	91890	\N	\N
1471	224	20	2	91347	\N	0	\N	\N	0	1	2	f	91347	\N	\N
1472	120	20	2	90029	\N	0	\N	\N	0	1	2	f	90029	\N	\N
1473	107	20	2	88703	\N	0	\N	\N	0	1	2	f	88703	\N	\N
1474	143	20	2	84816	\N	0	\N	\N	0	1	2	f	84816	\N	\N
1475	24	20	2	83872	\N	0	\N	\N	0	1	2	f	83872	\N	\N
1476	8	20	2	81821	\N	0	\N	\N	0	1	2	f	81821	\N	\N
1477	188	20	2	76766	\N	0	\N	\N	0	1	2	f	76766	\N	\N
1478	169	20	2	73621	\N	0	\N	\N	0	1	2	f	73621	\N	\N
1479	168	20	2	68386	\N	0	\N	\N	0	1	2	f	68386	\N	\N
1480	229	20	2	66782	\N	0	\N	\N	0	1	2	f	66782	\N	\N
1481	49	20	2	65135	\N	0	\N	\N	0	1	2	f	65135	\N	\N
1482	280	20	2	61809	\N	0	\N	\N	0	1	2	f	61809	\N	\N
1483	171	20	2	61226	\N	0	\N	\N	0	1	2	f	61226	\N	\N
1484	103	20	2	60906	\N	0	\N	\N	0	1	2	f	60906	\N	\N
1485	283	20	2	60487	\N	0	\N	\N	0	1	2	f	60487	\N	\N
1486	198	20	2	59993	\N	0	\N	\N	0	1	2	f	59993	\N	\N
1487	65	20	2	56175	\N	0	\N	\N	0	1	2	f	56175	\N	\N
1488	135	20	2	54788	\N	0	\N	\N	0	1	2	f	54788	\N	\N
1489	60	20	2	54334	\N	0	\N	\N	0	1	2	f	54334	\N	\N
1490	113	20	2	53337	\N	0	\N	\N	0	1	2	f	53337	\N	\N
1491	79	20	2	53153	\N	0	\N	\N	0	1	2	f	53153	\N	\N
1492	202	20	2	51760	\N	0	\N	\N	0	1	2	f	51760	\N	\N
1493	59	20	2	51394	\N	0	\N	\N	0	1	2	f	51394	\N	\N
1494	206	20	2	48058	\N	0	\N	\N	0	1	2	f	48058	\N	\N
1495	166	20	2	48009	\N	0	\N	\N	0	1	2	f	48009	\N	\N
1496	250	20	2	45312	\N	0	\N	\N	0	1	2	f	45312	\N	\N
1497	23	20	2	44408	\N	0	\N	\N	0	1	2	f	44408	\N	\N
1498	153	20	2	43567	\N	0	\N	\N	0	1	2	f	43567	\N	\N
1499	271	20	2	43188	\N	0	\N	\N	0	1	2	f	43188	\N	\N
1500	73	20	2	40290	\N	0	\N	\N	0	1	2	f	40290	\N	\N
1501	115	20	2	39848	\N	0	\N	\N	0	1	2	f	39848	\N	\N
1502	144	20	2	39303	\N	0	\N	\N	0	1	2	f	39303	\N	\N
1503	155	20	2	39228	\N	0	\N	\N	0	1	2	f	39228	\N	\N
1504	235	20	2	38059	\N	0	\N	\N	0	1	2	f	38059	\N	\N
1505	227	20	2	36753	\N	0	\N	\N	0	1	2	f	36753	\N	\N
1506	199	20	2	35399	\N	0	\N	\N	0	1	2	f	35399	\N	\N
1507	200	20	2	34519	\N	0	\N	\N	0	1	2	f	34519	\N	\N
1508	201	20	2	34452	\N	0	\N	\N	0	1	2	f	34452	\N	\N
1509	260	20	2	34452	\N	0	\N	\N	0	1	2	f	34452	\N	\N
1510	82	20	2	31636	\N	0	\N	\N	0	1	2	f	31636	\N	\N
1511	207	20	2	30801	\N	0	\N	\N	0	1	2	f	30801	\N	\N
1512	122	20	2	30612	\N	0	\N	\N	0	1	2	f	30612	\N	\N
1513	172	20	2	30086	\N	0	\N	\N	0	1	2	f	30086	\N	\N
1514	41	20	2	29224	\N	0	\N	\N	0	1	2	f	29224	\N	\N
1515	20	20	2	28680	\N	0	\N	\N	0	1	2	f	28680	\N	\N
1516	86	20	2	28577	\N	0	\N	\N	0	1	2	f	28577	\N	\N
1517	75	20	2	27866	\N	0	\N	\N	0	1	2	f	27866	\N	\N
1518	248	20	2	27668	\N	0	\N	\N	0	1	2	f	27668	\N	\N
1519	134	20	2	27454	\N	0	\N	\N	0	1	2	f	27454	\N	\N
1520	170	20	2	27248	\N	0	\N	\N	0	1	2	f	27248	\N	\N
1521	154	20	2	26677	\N	0	\N	\N	0	1	2	f	26677	\N	\N
1522	276	20	2	26660	\N	0	\N	\N	0	1	2	f	26660	\N	\N
1523	254	20	2	25928	\N	0	\N	\N	0	1	2	f	25928	\N	\N
1524	31	20	2	25208	\N	0	\N	\N	0	1	2	f	25208	\N	\N
1525	178	20	2	25205	\N	0	\N	\N	0	1	2	f	25205	\N	\N
1526	272	20	2	24248	\N	0	\N	\N	0	1	2	f	24248	\N	\N
1527	167	20	2	24214	\N	0	\N	\N	0	1	2	f	24214	\N	\N
1528	89	20	2	24122	\N	0	\N	\N	0	1	2	f	24122	\N	\N
1529	157	20	2	24079	\N	0	\N	\N	0	1	2	f	24079	\N	\N
1530	175	20	2	23978	\N	0	\N	\N	0	1	2	f	23978	\N	\N
1531	22	20	2	23926	\N	0	\N	\N	0	1	2	f	23926	\N	\N
1532	187	20	2	23859	\N	0	\N	\N	0	1	2	f	23859	\N	\N
1533	281	20	2	23760	\N	0	\N	\N	0	1	2	f	23760	\N	\N
1534	152	20	2	23729	\N	0	\N	\N	0	1	2	f	23729	\N	\N
1535	253	20	2	22654	\N	0	\N	\N	0	1	2	f	22654	\N	\N
1536	151	20	2	21994	\N	0	\N	\N	0	1	2	f	21994	\N	\N
1537	66	20	2	21979	\N	0	\N	\N	0	1	2	f	21979	\N	\N
1538	256	20	2	21583	\N	0	\N	\N	0	1	2	f	21583	\N	\N
1539	141	20	2	21576	\N	0	\N	\N	0	1	2	f	21576	\N	\N
1540	284	20	2	20303	\N	0	\N	\N	0	1	2	f	20303	\N	\N
1541	110	20	2	18959	\N	0	\N	\N	0	1	2	f	18959	\N	\N
1542	108	20	2	18592	\N	0	\N	\N	0	1	2	f	18592	\N	\N
1543	247	20	2	18410	\N	0	\N	\N	0	1	2	f	18410	\N	\N
1544	246	20	2	17491	\N	0	\N	\N	0	1	2	f	17491	\N	\N
1545	177	20	2	17271	\N	0	\N	\N	0	1	2	f	17271	\N	\N
1546	138	20	2	16782	\N	0	\N	\N	0	1	2	f	16782	\N	\N
1547	123	20	2	16767	\N	0	\N	\N	0	1	2	f	16767	\N	\N
1548	19	20	2	16736	\N	0	\N	\N	0	1	2	f	16736	\N	\N
1549	194	20	2	16544	\N	0	\N	\N	0	1	2	f	16544	\N	\N
1550	35	20	2	15526	\N	0	\N	\N	0	1	2	f	15526	\N	\N
1551	106	20	2	15462	\N	0	\N	\N	0	1	2	f	15462	\N	\N
1552	142	20	2	15373	\N	0	\N	\N	0	1	2	f	15373	\N	\N
1553	36	20	2	14833	\N	0	\N	\N	0	1	2	f	14833	\N	\N
1554	238	20	2	14453	\N	0	\N	\N	0	1	2	f	14453	\N	\N
1555	218	20	2	14245	\N	0	\N	\N	0	1	2	f	14245	\N	\N
1556	273	20	2	14027	\N	0	\N	\N	0	1	2	f	14027	\N	\N
1557	45	20	2	13989	\N	0	\N	\N	0	1	2	f	13989	\N	\N
1558	147	20	2	13553	\N	0	\N	\N	0	1	2	f	13553	\N	\N
1559	39	20	2	13409	\N	0	\N	\N	0	1	2	f	13409	\N	\N
1560	105	20	2	13293	\N	0	\N	\N	0	1	2	f	13293	\N	\N
1561	77	20	2	12374	\N	0	\N	\N	0	1	2	f	12374	\N	\N
1562	121	20	2	12342	\N	0	\N	\N	0	1	2	f	12342	\N	\N
1563	220	20	2	12262	\N	0	\N	\N	0	1	2	f	12262	\N	\N
1564	186	20	2	11814	\N	0	\N	\N	0	1	2	f	11814	\N	\N
1565	129	20	2	11624	\N	0	\N	\N	0	1	2	f	11624	\N	\N
1566	176	20	2	11609	\N	0	\N	\N	0	1	2	f	11609	\N	\N
1567	231	20	2	11384	\N	0	\N	\N	0	1	2	f	11384	\N	\N
1568	18	20	2	11180	\N	0	\N	\N	0	1	2	f	11180	\N	\N
1569	63	20	2	11148	\N	0	\N	\N	0	1	2	f	11148	\N	\N
1570	183	20	2	10848	\N	0	\N	\N	0	1	2	f	10848	\N	\N
1571	290	20	2	10823	\N	0	\N	\N	0	1	2	f	10823	\N	\N
1572	102	20	2	10800	\N	0	\N	\N	0	1	2	f	10800	\N	\N
1573	85	20	2	10156	\N	0	\N	\N	0	1	2	f	10156	\N	\N
1574	117	20	2	9952	\N	0	\N	\N	0	1	2	f	9952	\N	\N
1575	67	20	2	9163	\N	0	\N	\N	0	1	2	f	9163	\N	\N
1576	29	20	2	9021	\N	0	\N	\N	0	1	2	f	9021	\N	\N
1577	226	20	2	8733	\N	0	\N	\N	0	1	2	f	8733	\N	\N
1578	156	20	2	8484	\N	0	\N	\N	0	1	2	f	8484	\N	\N
1579	174	20	2	8427	\N	0	\N	\N	0	1	2	f	8427	\N	\N
1580	137	20	2	8340	\N	0	\N	\N	0	1	2	f	8340	\N	\N
1581	10	20	2	8280	\N	0	\N	\N	0	1	2	f	8280	\N	\N
1582	257	20	2	8243	\N	0	\N	\N	0	1	2	f	8243	\N	\N
1583	88	20	2	8127	\N	0	\N	\N	0	1	2	f	8127	\N	\N
1584	140	20	2	7797	\N	0	\N	\N	0	1	2	f	7797	\N	\N
1585	228	20	2	7758	\N	0	\N	\N	0	1	2	f	7758	\N	\N
1586	191	20	2	7512	\N	0	\N	\N	0	1	2	f	7512	\N	\N
1587	158	20	2	7287	\N	0	\N	\N	0	1	2	f	7287	\N	\N
1588	43	20	2	7281	\N	0	\N	\N	0	1	2	f	7281	\N	\N
1589	230	20	2	7258	\N	0	\N	\N	0	1	2	f	7258	\N	\N
1590	87	20	2	7053	\N	0	\N	\N	0	1	2	f	7053	\N	\N
1591	25	20	2	7010	\N	0	\N	\N	0	1	2	f	7010	\N	\N
1592	204	20	2	6865	\N	0	\N	\N	0	1	2	f	6865	\N	\N
1593	288	20	2	6514	\N	0	\N	\N	0	1	2	f	6514	\N	\N
1594	125	20	2	6322	\N	0	\N	\N	0	1	2	f	6322	\N	\N
1595	12	20	2	6275	\N	0	\N	\N	0	1	2	f	6275	\N	\N
1596	92	20	2	6256	\N	0	\N	\N	0	1	2	f	6256	\N	\N
1597	185	20	2	6076	\N	0	\N	\N	0	1	2	f	6076	\N	\N
1598	17	20	2	5856	\N	0	\N	\N	0	1	2	f	5856	\N	\N
1599	233	20	2	5771	\N	0	\N	\N	0	1	2	f	5771	\N	\N
1600	252	20	2	5712	\N	0	\N	\N	0	1	2	f	5712	\N	\N
1601	150	20	2	5373	\N	0	\N	\N	0	1	2	f	5373	\N	\N
1602	165	20	2	5067	\N	0	\N	\N	0	1	2	f	5067	\N	\N
1603	7	20	2	4961	\N	0	\N	\N	0	1	2	f	4961	\N	\N
1604	44	20	2	4774	\N	0	\N	\N	0	1	2	f	4774	\N	\N
1605	232	20	2	4583	\N	0	\N	\N	0	1	2	f	4583	\N	\N
1606	42	20	2	4380	\N	0	\N	\N	0	1	2	f	4380	\N	\N
1607	274	20	2	4322	\N	0	\N	\N	0	1	2	f	4322	\N	\N
1608	277	20	2	4291	\N	0	\N	\N	0	1	2	f	4291	\N	\N
1609	57	20	2	3861	\N	0	\N	\N	0	1	2	f	3861	\N	\N
1610	62	20	2	3793	\N	0	\N	\N	0	1	2	f	3793	\N	\N
1611	275	20	2	3759	\N	0	\N	\N	0	1	2	f	3759	\N	\N
1612	56	20	2	3731	\N	0	\N	\N	0	1	2	f	3731	\N	\N
1613	47	20	2	3664	\N	0	\N	\N	0	1	2	f	3664	\N	\N
1614	205	20	2	3604	\N	0	\N	\N	0	1	2	f	3604	\N	\N
1615	221	20	2	3540	\N	0	\N	\N	0	1	2	f	3540	\N	\N
1616	30	20	2	3502	\N	0	\N	\N	0	1	2	f	3502	\N	\N
1617	81	20	2	3439	\N	0	\N	\N	0	1	2	f	3439	\N	\N
1618	34	20	2	3161	\N	0	\N	\N	0	1	2	f	3161	\N	\N
1619	3	20	2	2958	\N	0	\N	\N	0	1	2	f	2958	\N	\N
1620	148	20	2	2921	\N	0	\N	\N	0	1	2	f	2921	\N	\N
1621	223	20	2	2277	\N	0	\N	\N	0	1	2	f	2277	\N	\N
1622	40	20	2	2277	\N	0	\N	\N	0	1	2	f	2277	\N	\N
1623	93	20	2	2144	\N	0	\N	\N	0	1	2	f	2144	\N	\N
1624	38	20	2	2133	\N	0	\N	\N	0	1	2	f	2133	\N	\N
1625	146	20	2	2102	\N	0	\N	\N	0	1	2	f	2102	\N	\N
1626	9	20	2	2099	\N	0	\N	\N	0	1	2	f	2099	\N	\N
1627	80	20	2	2050	\N	0	\N	\N	0	1	2	f	2050	\N	\N
1628	78	20	2	1955	\N	0	\N	\N	0	1	2	f	1955	\N	\N
1629	15	20	2	1909	\N	0	\N	\N	0	1	2	f	1909	\N	\N
1630	58	20	2	1738	\N	0	\N	\N	0	1	2	f	1738	\N	\N
1631	289	20	2	1651	\N	0	\N	\N	0	1	2	f	1651	\N	\N
1632	269	20	2	1650	\N	0	\N	\N	0	1	2	f	1650	\N	\N
1633	84	20	2	1530	\N	0	\N	\N	0	1	2	f	1530	\N	\N
1634	104	20	2	1509	\N	0	\N	\N	0	1	2	f	1509	\N	\N
1635	127	20	2	1337	\N	0	\N	\N	0	1	2	f	1337	\N	\N
1636	101	20	2	1320	\N	0	\N	\N	0	1	2	f	1320	\N	\N
1637	241	20	2	1309	\N	0	\N	\N	0	1	2	f	1309	\N	\N
1638	244	20	2	1303	\N	0	\N	\N	0	1	2	f	1303	\N	\N
1639	258	20	2	1166	\N	0	\N	\N	0	1	2	f	1166	\N	\N
1640	64	20	2	1135	\N	0	\N	\N	0	1	2	f	1135	\N	\N
1641	116	20	2	1069	\N	0	\N	\N	0	1	2	f	1069	\N	\N
1642	287	20	2	992	\N	0	\N	\N	0	1	2	f	992	\N	\N
1643	192	20	2	864	\N	0	\N	\N	0	1	2	f	864	\N	\N
1644	285	20	2	799	\N	0	\N	\N	0	1	2	f	799	\N	\N
1645	184	20	2	707	\N	0	\N	\N	0	1	2	f	707	\N	\N
1646	182	20	2	660	\N	0	\N	\N	0	1	2	f	660	\N	\N
1647	71	20	2	597	\N	0	\N	\N	0	1	2	f	597	\N	\N
1648	124	20	2	588	\N	0	\N	\N	0	1	2	f	588	\N	\N
1649	51	20	2	541	\N	0	\N	\N	0	1	2	f	541	\N	\N
1650	5	20	2	484	\N	0	\N	\N	0	1	2	f	484	\N	\N
1651	16	20	2	478	\N	0	\N	\N	0	1	2	f	478	\N	\N
1652	163	20	2	446	\N	0	\N	\N	0	1	2	f	446	\N	\N
1653	52	20	2	434	\N	0	\N	\N	0	1	2	f	434	\N	\N
1654	128	20	2	419	\N	0	\N	\N	0	1	2	f	419	\N	\N
1655	262	20	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
1656	214	20	2	398	\N	0	\N	\N	0	1	2	f	398	\N	\N
1657	14	20	2	362	\N	0	\N	\N	0	1	2	f	362	\N	\N
1658	212	20	2	325	\N	0	\N	\N	0	1	2	f	325	\N	\N
1659	203	20	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
1660	189	20	2	307	\N	0	\N	\N	0	1	2	f	307	\N	\N
1661	196	20	2	301	\N	0	\N	\N	0	1	2	f	301	\N	\N
1662	286	20	2	246	\N	0	\N	\N	0	1	2	f	246	\N	\N
1663	4	20	2	227	\N	0	\N	\N	0	1	2	f	227	\N	\N
1664	193	20	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
1665	245	20	2	212	\N	0	\N	\N	0	1	2	f	212	\N	\N
1666	243	20	2	194	\N	0	\N	\N	0	1	2	f	194	\N	\N
1667	131	20	2	173	\N	0	\N	\N	0	1	2	f	173	\N	\N
1668	99	20	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
1669	264	20	2	133	\N	0	\N	\N	0	1	2	f	133	\N	\N
1670	190	20	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
1671	97	20	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
1672	95	20	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
1673	162	20	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
1674	181	20	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
1675	263	20	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1676	160	20	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
1677	213	20	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
1678	132	20	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1679	259	20	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
1680	94	20	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
1681	26	20	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1682	240	20	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1683	100	20	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1684	266	20	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1685	268	20	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1686	53	20	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1687	211	20	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1688	161	20	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1689	130	20	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1690	215	20	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1691	267	20	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1692	50	20	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1693	27	20	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1694	239	20	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1695	69	20	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1696	1	20	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1697	265	20	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1698	98	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1699	28	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1700	96	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1701	270	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1702	216	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1703	2	20	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1704	111	21	2	11837143	\N	0	\N	\N	1	1	2	f	11837143	\N	\N
1705	109	21	2	4924155	\N	0	\N	\N	2	1	2	f	4924155	\N	\N
1706	251	21	2	4792979	\N	0	\N	\N	3	1	2	f	4792979	\N	\N
1707	54	21	2	3438255	\N	0	\N	\N	4	1	2	f	3438255	\N	\N
1708	55	21	2	2330970	\N	0	\N	\N	5	1	2	f	2330970	\N	\N
1709	145	21	2	1308163	\N	0	\N	\N	6	1	2	f	1308163	\N	\N
1710	33	21	2	1280992	\N	0	\N	\N	7	1	2	f	1280992	\N	\N
1711	139	21	2	711800	\N	0	\N	\N	8	1	2	f	711800	\N	\N
1712	91	21	2	126555	\N	0	\N	\N	9	1	2	f	126555	\N	\N
1713	70	21	2	1546	\N	0	\N	\N	10	1	2	f	1546	\N	\N
1714	149	21	2	9142261	\N	0	\N	\N	0	1	2	f	9142261	\N	\N
1715	255	21	2	1838200	\N	0	\N	\N	0	1	2	f	1838200	\N	\N
1716	209	21	2	1539730	\N	0	\N	\N	0	1	2	f	1539730	\N	\N
1717	126	21	2	1137768	\N	0	\N	\N	0	1	2	f	1137768	\N	\N
1718	210	21	2	981040	\N	0	\N	\N	0	1	2	f	981040	\N	\N
1719	282	21	2	980097	\N	0	\N	\N	0	1	2	f	980097	\N	\N
1720	37	21	2	757537	\N	0	\N	\N	0	1	2	f	757537	\N	\N
1721	249	21	2	553045	\N	0	\N	\N	0	1	2	f	553045	\N	\N
1722	242	21	2	447683	\N	0	\N	\N	0	1	2	f	447683	\N	\N
1723	118	21	2	425038	\N	0	\N	\N	0	1	2	f	425038	\N	\N
1724	278	21	2	406140	\N	0	\N	\N	0	1	2	f	406140	\N	\N
1725	112	21	2	381286	\N	0	\N	\N	0	1	2	f	381286	\N	\N
1726	195	21	2	299395	\N	0	\N	\N	0	1	2	f	299395	\N	\N
1727	6	21	2	298672	\N	0	\N	\N	0	1	2	f	298672	\N	\N
1728	222	21	2	252487	\N	0	\N	\N	0	1	2	f	252487	\N	\N
1729	90	21	2	247623	\N	0	\N	\N	0	1	2	f	247623	\N	\N
1730	119	21	2	233880	\N	0	\N	\N	0	1	2	f	233880	\N	\N
1731	136	21	2	221087	\N	0	\N	\N	0	1	2	f	221087	\N	\N
1732	21	21	2	218154	\N	0	\N	\N	0	1	2	f	218154	\N	\N
1733	76	21	2	214316	\N	0	\N	\N	0	1	2	f	214316	\N	\N
1734	234	21	2	204939	\N	0	\N	\N	0	1	2	f	204939	\N	\N
1735	180	21	2	190925	\N	0	\N	\N	0	1	2	f	190925	\N	\N
1736	208	21	2	179265	\N	0	\N	\N	0	1	2	f	179265	\N	\N
1737	237	21	2	170484	\N	0	\N	\N	0	1	2	f	170484	\N	\N
1738	72	21	2	168478	\N	0	\N	\N	0	1	2	f	168478	\N	\N
1739	197	21	2	167059	\N	0	\N	\N	0	1	2	f	167059	\N	\N
1740	225	21	2	149904	\N	0	\N	\N	0	1	2	f	149904	\N	\N
1741	173	21	2	143879	\N	0	\N	\N	0	1	2	f	143879	\N	\N
1742	46	21	2	140663	\N	0	\N	\N	0	1	2	f	140663	\N	\N
1743	74	21	2	133073	\N	0	\N	\N	0	1	2	f	133073	\N	\N
1744	236	21	2	128875	\N	0	\N	\N	0	1	2	f	128875	\N	\N
1745	48	21	2	122520	\N	0	\N	\N	0	1	2	f	122520	\N	\N
1746	61	21	2	115895	\N	0	\N	\N	0	1	2	f	115895	\N	\N
1747	133	21	2	114807	\N	0	\N	\N	0	1	2	f	114807	\N	\N
1748	83	21	2	113861	\N	0	\N	\N	0	1	2	f	113861	\N	\N
1749	159	21	2	109756	\N	0	\N	\N	0	1	2	f	109756	\N	\N
1750	179	21	2	104952	\N	0	\N	\N	0	1	2	f	104952	\N	\N
1751	261	21	2	104906	\N	0	\N	\N	0	1	2	f	104906	\N	\N
1752	114	21	2	100770	\N	0	\N	\N	0	1	2	f	100770	\N	\N
1753	32	21	2	99932	\N	0	\N	\N	0	1	2	f	99932	\N	\N
1754	219	21	2	97123	\N	0	\N	\N	0	1	2	f	97123	\N	\N
1755	68	21	2	95402	\N	0	\N	\N	0	1	2	f	95402	\N	\N
1756	11	21	2	93141	\N	0	\N	\N	0	1	2	f	93141	\N	\N
1757	279	21	2	92171	\N	0	\N	\N	0	1	2	f	92171	\N	\N
1758	13	21	2	92153	\N	0	\N	\N	0	1	2	f	92153	\N	\N
1759	224	21	2	91593	\N	0	\N	\N	0	1	2	f	91593	\N	\N
1760	120	21	2	91136	\N	0	\N	\N	0	1	2	f	91136	\N	\N
1761	107	21	2	89264	\N	0	\N	\N	0	1	2	f	89264	\N	\N
1762	143	21	2	85440	\N	0	\N	\N	0	1	2	f	85440	\N	\N
1763	24	21	2	84885	\N	0	\N	\N	0	1	2	f	84885	\N	\N
1764	8	21	2	82120	\N	0	\N	\N	0	1	2	f	82120	\N	\N
1765	188	21	2	77231	\N	0	\N	\N	0	1	2	f	77231	\N	\N
1766	169	21	2	73934	\N	0	\N	\N	0	1	2	f	73934	\N	\N
1767	168	21	2	68677	\N	0	\N	\N	0	1	2	f	68677	\N	\N
1768	229	21	2	67241	\N	0	\N	\N	0	1	2	f	67241	\N	\N
1769	49	21	2	65417	\N	0	\N	\N	0	1	2	f	65417	\N	\N
1770	280	21	2	61841	\N	0	\N	\N	0	1	2	f	61841	\N	\N
1771	171	21	2	61341	\N	0	\N	\N	0	1	2	f	61341	\N	\N
1772	103	21	2	61211	\N	0	\N	\N	0	1	2	f	61211	\N	\N
1773	283	21	2	60602	\N	0	\N	\N	0	1	2	f	60602	\N	\N
1774	198	21	2	60404	\N	0	\N	\N	0	1	2	f	60404	\N	\N
1775	65	21	2	56443	\N	0	\N	\N	0	1	2	f	56443	\N	\N
1776	135	21	2	54825	\N	0	\N	\N	0	1	2	f	54825	\N	\N
1777	60	21	2	54699	\N	0	\N	\N	0	1	2	f	54699	\N	\N
1778	113	21	2	53841	\N	0	\N	\N	0	1	2	f	53841	\N	\N
1779	79	21	2	53318	\N	0	\N	\N	0	1	2	f	53318	\N	\N
1780	202	21	2	51917	\N	0	\N	\N	0	1	2	f	51917	\N	\N
1781	59	21	2	51613	\N	0	\N	\N	0	1	2	f	51613	\N	\N
1782	206	21	2	49545	\N	0	\N	\N	0	1	2	f	49545	\N	\N
1783	166	21	2	48316	\N	0	\N	\N	0	1	2	f	48316	\N	\N
1784	250	21	2	45413	\N	0	\N	\N	0	1	2	f	45413	\N	\N
1785	23	21	2	44548	\N	0	\N	\N	0	1	2	f	44548	\N	\N
1786	153	21	2	43723	\N	0	\N	\N	0	1	2	f	43723	\N	\N
1787	271	21	2	43285	\N	0	\N	\N	0	1	2	f	43285	\N	\N
1788	73	21	2	40399	\N	0	\N	\N	0	1	2	f	40399	\N	\N
1789	115	21	2	39952	\N	0	\N	\N	0	1	2	f	39952	\N	\N
1790	144	21	2	39730	\N	0	\N	\N	0	1	2	f	39730	\N	\N
1791	155	21	2	39387	\N	0	\N	\N	0	1	2	f	39387	\N	\N
1792	235	21	2	38575	\N	0	\N	\N	0	1	2	f	38575	\N	\N
1793	227	21	2	36969	\N	0	\N	\N	0	1	2	f	36969	\N	\N
1794	199	21	2	35529	\N	0	\N	\N	0	1	2	f	35529	\N	\N
1795	200	21	2	34767	\N	0	\N	\N	0	1	2	f	34767	\N	\N
1796	201	21	2	34586	\N	0	\N	\N	0	1	2	f	34586	\N	\N
1797	260	21	2	34527	\N	0	\N	\N	0	1	2	f	34527	\N	\N
1798	82	21	2	31831	\N	0	\N	\N	0	1	2	f	31831	\N	\N
1799	207	21	2	30965	\N	0	\N	\N	0	1	2	f	30965	\N	\N
1800	122	21	2	30747	\N	0	\N	\N	0	1	2	f	30747	\N	\N
1801	172	21	2	30185	\N	0	\N	\N	0	1	2	f	30185	\N	\N
1802	41	21	2	29878	\N	0	\N	\N	0	1	2	f	29878	\N	\N
1803	20	21	2	28779	\N	0	\N	\N	0	1	2	f	28779	\N	\N
1804	86	21	2	28716	\N	0	\N	\N	0	1	2	f	28716	\N	\N
1805	75	21	2	27998	\N	0	\N	\N	0	1	2	f	27998	\N	\N
1806	248	21	2	27715	\N	0	\N	\N	0	1	2	f	27715	\N	\N
1807	134	21	2	27562	\N	0	\N	\N	0	1	2	f	27562	\N	\N
1808	170	21	2	27342	\N	0	\N	\N	0	1	2	f	27342	\N	\N
1809	154	21	2	26843	\N	0	\N	\N	0	1	2	f	26843	\N	\N
1810	276	21	2	26759	\N	0	\N	\N	0	1	2	f	26759	\N	\N
1811	254	21	2	26022	\N	0	\N	\N	0	1	2	f	26022	\N	\N
1812	31	21	2	25383	\N	0	\N	\N	0	1	2	f	25383	\N	\N
1813	178	21	2	25325	\N	0	\N	\N	0	1	2	f	25325	\N	\N
1814	272	21	2	24358	\N	0	\N	\N	0	1	2	f	24358	\N	\N
1815	167	21	2	24320	\N	0	\N	\N	0	1	2	f	24320	\N	\N
1816	89	21	2	24203	\N	0	\N	\N	0	1	2	f	24203	\N	\N
1817	175	21	2	24161	\N	0	\N	\N	0	1	2	f	24161	\N	\N
1818	157	21	2	24160	\N	0	\N	\N	0	1	2	f	24160	\N	\N
1819	187	21	2	24143	\N	0	\N	\N	0	1	2	f	24143	\N	\N
1820	22	21	2	24051	\N	0	\N	\N	0	1	2	f	24051	\N	\N
1821	152	21	2	23927	\N	0	\N	\N	0	1	2	f	23927	\N	\N
1822	281	21	2	23831	\N	0	\N	\N	0	1	2	f	23831	\N	\N
1823	253	21	2	22682	\N	0	\N	\N	0	1	2	f	22682	\N	\N
1824	151	21	2	22346	\N	0	\N	\N	0	1	2	f	22346	\N	\N
1825	141	21	2	22199	\N	0	\N	\N	0	1	2	f	22199	\N	\N
1826	66	21	2	22100	\N	0	\N	\N	0	1	2	f	22100	\N	\N
1827	256	21	2	21649	\N	0	\N	\N	0	1	2	f	21649	\N	\N
1828	284	21	2	20351	\N	0	\N	\N	0	1	2	f	20351	\N	\N
1829	110	21	2	19060	\N	0	\N	\N	0	1	2	f	19060	\N	\N
1830	108	21	2	18687	\N	0	\N	\N	0	1	2	f	18687	\N	\N
1831	247	21	2	18476	\N	0	\N	\N	0	1	2	f	18476	\N	\N
1832	246	21	2	17536	\N	0	\N	\N	0	1	2	f	17536	\N	\N
1833	177	21	2	17340	\N	0	\N	\N	0	1	2	f	17340	\N	\N
1834	194	21	2	16992	\N	0	\N	\N	0	1	2	f	16992	\N	\N
1835	138	21	2	16888	\N	0	\N	\N	0	1	2	f	16888	\N	\N
1836	19	21	2	16836	\N	0	\N	\N	0	1	2	f	16836	\N	\N
1837	123	21	2	16828	\N	0	\N	\N	0	1	2	f	16828	\N	\N
1838	106	21	2	15910	\N	0	\N	\N	0	1	2	f	15910	\N	\N
1839	35	21	2	15620	\N	0	\N	\N	0	1	2	f	15620	\N	\N
1840	142	21	2	15453	\N	0	\N	\N	0	1	2	f	15453	\N	\N
1841	36	21	2	14884	\N	0	\N	\N	0	1	2	f	14884	\N	\N
1842	238	21	2	14506	\N	0	\N	\N	0	1	2	f	14506	\N	\N
1843	218	21	2	14305	\N	0	\N	\N	0	1	2	f	14305	\N	\N
1844	273	21	2	14087	\N	0	\N	\N	0	1	2	f	14087	\N	\N
1845	45	21	2	14049	\N	0	\N	\N	0	1	2	f	14049	\N	\N
1846	147	21	2	13611	\N	0	\N	\N	0	1	2	f	13611	\N	\N
1847	39	21	2	13449	\N	0	\N	\N	0	1	2	f	13449	\N	\N
1848	105	21	2	13434	\N	0	\N	\N	0	1	2	f	13434	\N	\N
1849	77	21	2	12422	\N	0	\N	\N	0	1	2	f	12422	\N	\N
1850	121	21	2	12367	\N	0	\N	\N	0	1	2	f	12367	\N	\N
1851	220	21	2	12307	\N	0	\N	\N	0	1	2	f	12307	\N	\N
1852	186	21	2	11951	\N	0	\N	\N	0	1	2	f	11951	\N	\N
1853	176	21	2	11682	\N	0	\N	\N	0	1	2	f	11682	\N	\N
1854	129	21	2	11679	\N	0	\N	\N	0	1	2	f	11679	\N	\N
1855	231	21	2	11431	\N	0	\N	\N	0	1	2	f	11431	\N	\N
1856	183	21	2	11226	\N	0	\N	\N	0	1	2	f	11226	\N	\N
1857	18	21	2	11223	\N	0	\N	\N	0	1	2	f	11223	\N	\N
1858	63	21	2	11183	\N	0	\N	\N	0	1	2	f	11183	\N	\N
1859	290	21	2	10852	\N	0	\N	\N	0	1	2	f	10852	\N	\N
1860	102	21	2	10823	\N	0	\N	\N	0	1	2	f	10823	\N	\N
1861	85	21	2	10188	\N	0	\N	\N	0	1	2	f	10188	\N	\N
1862	117	21	2	10026	\N	0	\N	\N	0	1	2	f	10026	\N	\N
1863	67	21	2	9222	\N	0	\N	\N	0	1	2	f	9222	\N	\N
1864	29	21	2	9147	\N	0	\N	\N	0	1	2	f	9147	\N	\N
1865	226	21	2	8805	\N	0	\N	\N	0	1	2	f	8805	\N	\N
1866	156	21	2	8512	\N	0	\N	\N	0	1	2	f	8512	\N	\N
1867	174	21	2	8461	\N	0	\N	\N	0	1	2	f	8461	\N	\N
1868	137	21	2	8375	\N	0	\N	\N	0	1	2	f	8375	\N	\N
1869	10	21	2	8317	\N	0	\N	\N	0	1	2	f	8317	\N	\N
1870	257	21	2	8288	\N	0	\N	\N	0	1	2	f	8288	\N	\N
1871	88	21	2	8159	\N	0	\N	\N	0	1	2	f	8159	\N	\N
1872	140	21	2	7819	\N	0	\N	\N	0	1	2	f	7819	\N	\N
1873	228	21	2	7781	\N	0	\N	\N	0	1	2	f	7781	\N	\N
1874	191	21	2	7529	\N	0	\N	\N	0	1	2	f	7529	\N	\N
1875	158	21	2	7408	\N	0	\N	\N	0	1	2	f	7408	\N	\N
1876	43	21	2	7308	\N	0	\N	\N	0	1	2	f	7308	\N	\N
1877	230	21	2	7268	\N	0	\N	\N	0	1	2	f	7268	\N	\N
1878	87	21	2	7139	\N	0	\N	\N	0	1	2	f	7139	\N	\N
1879	204	21	2	7098	\N	0	\N	\N	0	1	2	f	7098	\N	\N
1880	25	21	2	7061	\N	0	\N	\N	0	1	2	f	7061	\N	\N
1881	288	21	2	6545	\N	0	\N	\N	0	1	2	f	6545	\N	\N
1882	12	21	2	6368	\N	0	\N	\N	0	1	2	f	6368	\N	\N
1883	125	21	2	6344	\N	0	\N	\N	0	1	2	f	6344	\N	\N
1884	92	21	2	6284	\N	0	\N	\N	0	1	2	f	6284	\N	\N
1885	185	21	2	6087	\N	0	\N	\N	0	1	2	f	6087	\N	\N
1886	233	21	2	5897	\N	0	\N	\N	0	1	2	f	5897	\N	\N
1887	17	21	2	5879	\N	0	\N	\N	0	1	2	f	5879	\N	\N
1888	252	21	2	5739	\N	0	\N	\N	0	1	2	f	5739	\N	\N
1889	150	21	2	5409	\N	0	\N	\N	0	1	2	f	5409	\N	\N
1890	165	21	2	5082	\N	0	\N	\N	0	1	2	f	5082	\N	\N
1891	7	21	2	4980	\N	0	\N	\N	0	1	2	f	4980	\N	\N
1892	44	21	2	4830	\N	0	\N	\N	0	1	2	f	4830	\N	\N
1893	232	21	2	4663	\N	0	\N	\N	0	1	2	f	4663	\N	\N
1894	42	21	2	4396	\N	0	\N	\N	0	1	2	f	4396	\N	\N
1895	274	21	2	4342	\N	0	\N	\N	0	1	2	f	4342	\N	\N
1896	277	21	2	4305	\N	0	\N	\N	0	1	2	f	4305	\N	\N
1897	57	21	2	3876	\N	0	\N	\N	0	1	2	f	3876	\N	\N
1898	62	21	2	3804	\N	0	\N	\N	0	1	2	f	3804	\N	\N
1899	275	21	2	3777	\N	0	\N	\N	0	1	2	f	3777	\N	\N
1900	56	21	2	3741	\N	0	\N	\N	0	1	2	f	3741	\N	\N
1901	47	21	2	3674	\N	0	\N	\N	0	1	2	f	3674	\N	\N
1902	205	21	2	3627	\N	0	\N	\N	0	1	2	f	3627	\N	\N
1903	221	21	2	3556	\N	0	\N	\N	0	1	2	f	3556	\N	\N
1904	30	21	2	3509	\N	0	\N	\N	0	1	2	f	3509	\N	\N
1905	81	21	2	3461	\N	0	\N	\N	0	1	2	f	3461	\N	\N
1906	34	21	2	3175	\N	0	\N	\N	0	1	2	f	3175	\N	\N
1907	3	21	2	2964	\N	0	\N	\N	0	1	2	f	2964	\N	\N
1908	148	21	2	2937	\N	0	\N	\N	0	1	2	f	2937	\N	\N
1909	40	21	2	2288	\N	0	\N	\N	0	1	2	f	2288	\N	\N
1910	223	21	2	2282	\N	0	\N	\N	0	1	2	f	2282	\N	\N
1911	93	21	2	2144	\N	0	\N	\N	0	1	2	f	2144	\N	\N
1912	38	21	2	2133	\N	0	\N	\N	0	1	2	f	2133	\N	\N
1913	9	21	2	2106	\N	0	\N	\N	0	1	2	f	2106	\N	\N
1914	146	21	2	2103	\N	0	\N	\N	0	1	2	f	2103	\N	\N
1915	80	21	2	2064	\N	0	\N	\N	0	1	2	f	2064	\N	\N
1916	78	21	2	1961	\N	0	\N	\N	0	1	2	f	1961	\N	\N
1917	15	21	2	1922	\N	0	\N	\N	0	1	2	f	1922	\N	\N
1918	58	21	2	1746	\N	0	\N	\N	0	1	2	f	1746	\N	\N
1919	269	21	2	1655	\N	0	\N	\N	0	1	2	f	1655	\N	\N
1920	289	21	2	1654	\N	0	\N	\N	0	1	2	f	1654	\N	\N
1921	84	21	2	1534	\N	0	\N	\N	0	1	2	f	1534	\N	\N
1922	104	21	2	1524	\N	0	\N	\N	0	1	2	f	1524	\N	\N
1923	127	21	2	1343	\N	0	\N	\N	0	1	2	f	1343	\N	\N
1924	101	21	2	1322	\N	0	\N	\N	0	1	2	f	1322	\N	\N
1925	241	21	2	1309	\N	0	\N	\N	0	1	2	f	1309	\N	\N
1926	244	21	2	1305	\N	0	\N	\N	0	1	2	f	1305	\N	\N
1927	258	21	2	1187	\N	0	\N	\N	0	1	2	f	1187	\N	\N
1928	64	21	2	1140	\N	0	\N	\N	0	1	2	f	1140	\N	\N
1929	116	21	2	1070	\N	0	\N	\N	0	1	2	f	1070	\N	\N
1930	287	21	2	995	\N	0	\N	\N	0	1	2	f	995	\N	\N
1931	192	21	2	872	\N	0	\N	\N	0	1	2	f	872	\N	\N
1932	285	21	2	803	\N	0	\N	\N	0	1	2	f	803	\N	\N
1933	184	21	2	708	\N	0	\N	\N	0	1	2	f	708	\N	\N
1934	182	21	2	662	\N	0	\N	\N	0	1	2	f	662	\N	\N
1935	71	21	2	601	\N	0	\N	\N	0	1	2	f	601	\N	\N
1936	124	21	2	592	\N	0	\N	\N	0	1	2	f	592	\N	\N
1937	51	21	2	542	\N	0	\N	\N	0	1	2	f	542	\N	\N
1938	5	21	2	484	\N	0	\N	\N	0	1	2	f	484	\N	\N
1939	16	21	2	481	\N	0	\N	\N	0	1	2	f	481	\N	\N
1940	163	21	2	450	\N	0	\N	\N	0	1	2	f	450	\N	\N
1941	52	21	2	437	\N	0	\N	\N	0	1	2	f	437	\N	\N
1942	128	21	2	429	\N	0	\N	\N	0	1	2	f	429	\N	\N
1943	262	21	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
1944	214	21	2	398	\N	0	\N	\N	0	1	2	f	398	\N	\N
1945	14	21	2	363	\N	0	\N	\N	0	1	2	f	363	\N	\N
1946	212	21	2	325	\N	0	\N	\N	0	1	2	f	325	\N	\N
1947	196	21	2	312	\N	0	\N	\N	0	1	2	f	312	\N	\N
1948	203	21	2	310	\N	0	\N	\N	0	1	2	f	310	\N	\N
1949	189	21	2	307	\N	0	\N	\N	0	1	2	f	307	\N	\N
1950	286	21	2	252	\N	0	\N	\N	0	1	2	f	252	\N	\N
1951	4	21	2	227	\N	0	\N	\N	0	1	2	f	227	\N	\N
1952	193	21	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
1953	245	21	2	216	\N	0	\N	\N	0	1	2	f	216	\N	\N
1954	243	21	2	194	\N	0	\N	\N	0	1	2	f	194	\N	\N
1955	131	21	2	173	\N	0	\N	\N	0	1	2	f	173	\N	\N
1956	99	21	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
1957	264	21	2	133	\N	0	\N	\N	0	1	2	f	133	\N	\N
1958	190	21	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
1959	97	21	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
1960	95	21	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
1961	162	21	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
1962	181	21	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
1963	263	21	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1964	160	21	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
1965	213	21	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
1966	132	21	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1967	259	21	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
1968	94	21	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
1969	26	21	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1970	240	21	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
1971	100	21	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1972	266	21	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1973	268	21	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1974	53	21	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1975	211	21	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1976	161	21	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1977	130	21	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1978	215	21	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1979	267	21	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1980	50	21	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1981	27	21	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1982	239	21	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1983	69	21	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1984	1	21	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1985	265	21	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1986	98	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1987	28	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1988	96	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1989	270	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1990	216	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1991	2	21	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1992	111	22	2	28748846	\N	28748846	\N	\N	1	1	2	f	0	\N	\N
1993	109	22	2	12427021	\N	12427021	\N	\N	2	1	2	f	0	\N	\N
1994	251	22	2	10987500	\N	10987500	\N	\N	3	1	2	f	0	\N	\N
1995	54	22	2	8266195	\N	8266195	\N	\N	4	1	2	f	0	\N	\N
1996	55	22	2	5555689	\N	5555689	\N	\N	5	1	2	f	0	\N	\N
1997	145	22	2	3114641	\N	3114641	\N	\N	6	1	2	f	0	\N	\N
1998	33	22	2	3102503	\N	3102503	\N	\N	7	1	2	f	0	\N	\N
1999	139	22	2	1587562	\N	1587562	\N	\N	8	1	2	f	0	\N	\N
2000	91	22	2	299979	\N	299979	\N	\N	9	1	2	f	0	\N	\N
2001	70	22	2	14876	\N	14876	\N	\N	10	1	2	f	0	\N	\N
2002	149	22	2	22928649	\N	22928649	\N	\N	0	1	2	f	0	\N	\N
2003	255	22	2	4397728	\N	4397728	\N	\N	0	1	2	f	0	\N	\N
2004	209	22	2	4277044	\N	4277044	\N	\N	0	1	2	f	0	\N	\N
2005	126	22	2	2579000	\N	2579000	\N	\N	0	1	2	f	0	\N	\N
2006	282	22	2	2378969	\N	2378969	\N	\N	0	1	2	f	0	\N	\N
2007	210	22	2	2137245	\N	2137245	\N	\N	0	1	2	f	0	\N	\N
2008	37	22	2	1841530	\N	1841530	\N	\N	0	1	2	f	0	\N	\N
2009	249	22	2	1352457	\N	1352457	\N	\N	0	1	2	f	0	\N	\N
2010	118	22	2	1121943	\N	1121943	\N	\N	0	1	2	f	0	\N	\N
2011	242	22	2	1057107	\N	1057107	\N	\N	0	1	2	f	0	\N	\N
2012	278	22	2	1039703	\N	1039703	\N	\N	0	1	2	f	0	\N	\N
2013	112	22	2	928094	\N	928094	\N	\N	0	1	2	f	0	\N	\N
2014	6	22	2	743715	\N	743715	\N	\N	0	1	2	f	0	\N	\N
2015	195	22	2	672015	\N	672015	\N	\N	0	1	2	f	0	\N	\N
2016	90	22	2	622337	\N	622337	\N	\N	0	1	2	f	0	\N	\N
2017	119	22	2	596590	\N	596590	\N	\N	0	1	2	f	0	\N	\N
2018	76	22	2	568758	\N	568758	\N	\N	0	1	2	f	0	\N	\N
2019	222	22	2	563229	\N	563229	\N	\N	0	1	2	f	0	\N	\N
2020	234	22	2	515641	\N	515641	\N	\N	0	1	2	f	0	\N	\N
2021	136	22	2	507995	\N	507995	\N	\N	0	1	2	f	0	\N	\N
2022	21	22	2	506425	\N	506425	\N	\N	0	1	2	f	0	\N	\N
2023	72	22	2	450402	\N	450402	\N	\N	0	1	2	f	0	\N	\N
2024	180	22	2	443569	\N	443569	\N	\N	0	1	2	f	0	\N	\N
2025	225	22	2	443395	\N	443395	\N	\N	0	1	2	f	0	\N	\N
2026	197	22	2	419306	\N	419306	\N	\N	0	1	2	f	0	\N	\N
2027	208	22	2	417755	\N	417755	\N	\N	0	1	2	f	0	\N	\N
2028	237	22	2	394938	\N	394938	\N	\N	0	1	2	f	0	\N	\N
2029	46	22	2	349122	\N	349122	\N	\N	0	1	2	f	0	\N	\N
2030	236	22	2	330525	\N	330525	\N	\N	0	1	2	f	0	\N	\N
2031	173	22	2	326549	\N	326549	\N	\N	0	1	2	f	0	\N	\N
2032	48	22	2	310312	\N	310312	\N	\N	0	1	2	f	0	\N	\N
2033	74	22	2	293976	\N	293976	\N	\N	0	1	2	f	0	\N	\N
2034	61	22	2	286850	\N	286850	\N	\N	0	1	2	f	0	\N	\N
2035	159	22	2	282429	\N	282429	\N	\N	0	1	2	f	0	\N	\N
2036	83	22	2	272437	\N	272437	\N	\N	0	1	2	f	0	\N	\N
2037	179	22	2	267113	\N	267113	\N	\N	0	1	2	f	0	\N	\N
2038	133	22	2	266634	\N	266634	\N	\N	0	1	2	f	0	\N	\N
2039	11	22	2	250738	\N	250738	\N	\N	0	1	2	f	0	\N	\N
2040	114	22	2	248036	\N	248036	\N	\N	0	1	2	f	0	\N	\N
2041	261	22	2	244157	\N	244157	\N	\N	0	1	2	f	0	\N	\N
2042	143	22	2	236914	\N	236914	\N	\N	0	1	2	f	0	\N	\N
2043	120	22	2	236567	\N	236567	\N	\N	0	1	2	f	0	\N	\N
2044	219	22	2	231717	\N	231717	\N	\N	0	1	2	f	0	\N	\N
2045	32	22	2	230047	\N	230047	\N	\N	0	1	2	f	0	\N	\N
2046	107	22	2	228946	\N	228946	\N	\N	0	1	2	f	0	\N	\N
2047	68	22	2	227340	\N	227340	\N	\N	0	1	2	f	0	\N	\N
2048	24	22	2	222941	\N	222941	\N	\N	0	1	2	f	0	\N	\N
2049	13	22	2	206535	\N	206535	\N	\N	0	1	2	f	0	\N	\N
2050	279	22	2	201418	\N	201418	\N	\N	0	1	2	f	0	\N	\N
2051	224	22	2	199195	\N	199195	\N	\N	0	1	2	f	0	\N	\N
2052	188	22	2	193585	\N	193585	\N	\N	0	1	2	f	0	\N	\N
2053	283	22	2	180911	\N	180911	\N	\N	0	1	2	f	0	\N	\N
2054	8	22	2	176544	\N	176544	\N	\N	0	1	2	f	0	\N	\N
2055	168	22	2	165047	\N	165047	\N	\N	0	1	2	f	0	\N	\N
2056	229	22	2	162148	\N	162148	\N	\N	0	1	2	f	0	\N	\N
2057	103	22	2	159143	\N	159143	\N	\N	0	1	2	f	0	\N	\N
2058	79	22	2	158120	\N	158120	\N	\N	0	1	2	f	0	\N	\N
2059	198	22	2	155069	\N	155069	\N	\N	0	1	2	f	0	\N	\N
2060	169	22	2	153664	\N	153664	\N	\N	0	1	2	f	0	\N	\N
2061	49	22	2	146507	\N	146507	\N	\N	0	1	2	f	0	\N	\N
2062	171	22	2	144245	\N	144245	\N	\N	0	1	2	f	0	\N	\N
2063	65	22	2	143504	\N	143504	\N	\N	0	1	2	f	0	\N	\N
2064	202	22	2	138955	\N	138955	\N	\N	0	1	2	f	0	\N	\N
2065	206	22	2	134356	\N	134356	\N	\N	0	1	2	f	0	\N	\N
2066	280	22	2	133815	\N	133815	\N	\N	0	1	2	f	0	\N	\N
2067	59	22	2	129089	\N	129089	\N	\N	0	1	2	f	0	\N	\N
2068	166	22	2	127292	\N	127292	\N	\N	0	1	2	f	0	\N	\N
2069	60	22	2	125429	\N	125429	\N	\N	0	1	2	f	0	\N	\N
2070	113	22	2	123105	\N	123105	\N	\N	0	1	2	f	0	\N	\N
2071	135	22	2	121210	\N	121210	\N	\N	0	1	2	f	0	\N	\N
2072	153	22	2	107817	\N	107817	\N	\N	0	1	2	f	0	\N	\N
2073	23	22	2	107581	\N	107581	\N	\N	0	1	2	f	0	\N	\N
2074	250	22	2	105497	\N	105497	\N	\N	0	1	2	f	0	\N	\N
2075	144	22	2	103862	\N	103862	\N	\N	0	1	2	f	0	\N	\N
2076	235	22	2	102546	\N	102546	\N	\N	0	1	2	f	0	\N	\N
2077	271	22	2	99643	\N	99643	\N	\N	0	1	2	f	0	\N	\N
2078	73	22	2	98874	\N	98874	\N	\N	0	1	2	f	0	\N	\N
2079	155	22	2	97309	\N	97309	\N	\N	0	1	2	f	0	\N	\N
2080	115	22	2	95951	\N	95951	\N	\N	0	1	2	f	0	\N	\N
2081	260	22	2	89596	\N	89596	\N	\N	0	1	2	f	0	\N	\N
2082	199	22	2	89096	\N	89096	\N	\N	0	1	2	f	0	\N	\N
2083	227	22	2	87788	\N	87788	\N	\N	0	1	2	f	0	\N	\N
2084	201	22	2	87253	\N	87253	\N	\N	0	1	2	f	0	\N	\N
2085	248	22	2	81008	\N	81008	\N	\N	0	1	2	f	0	\N	\N
2086	200	22	2	78845	\N	78845	\N	\N	0	1	2	f	0	\N	\N
2087	41	22	2	78513	\N	78513	\N	\N	0	1	2	f	0	\N	\N
2088	207	22	2	77136	\N	77136	\N	\N	0	1	2	f	0	\N	\N
2089	172	22	2	74991	\N	74991	\N	\N	0	1	2	f	0	\N	\N
2090	82	22	2	73413	\N	73413	\N	\N	0	1	2	f	0	\N	\N
2091	122	22	2	73046	\N	73046	\N	\N	0	1	2	f	0	\N	\N
2092	154	22	2	71107	\N	71107	\N	\N	0	1	2	f	0	\N	\N
2093	20	22	2	70100	\N	70100	\N	\N	0	1	2	f	0	\N	\N
2094	86	22	2	67940	\N	67940	\N	\N	0	1	2	f	0	\N	\N
2095	89	22	2	65223	\N	65223	\N	\N	0	1	2	f	0	\N	\N
2096	134	22	2	64458	\N	64458	\N	\N	0	1	2	f	0	\N	\N
2097	178	22	2	64361	\N	64361	\N	\N	0	1	2	f	0	\N	\N
2098	254	22	2	63071	\N	63071	\N	\N	0	1	2	f	0	\N	\N
2099	276	22	2	63006	\N	63006	\N	\N	0	1	2	f	0	\N	\N
2100	31	22	2	62781	\N	62781	\N	\N	0	1	2	f	0	\N	\N
2101	75	22	2	61843	\N	61843	\N	\N	0	1	2	f	0	\N	\N
2102	272	22	2	59761	\N	59761	\N	\N	0	1	2	f	0	\N	\N
2103	170	22	2	59603	\N	59603	\N	\N	0	1	2	f	0	\N	\N
2104	141	22	2	58543	\N	58543	\N	\N	0	1	2	f	0	\N	\N
2105	187	22	2	57050	\N	57050	\N	\N	0	1	2	f	0	\N	\N
2106	22	22	2	56446	\N	56446	\N	\N	0	1	2	f	0	\N	\N
2107	175	22	2	55613	\N	55613	\N	\N	0	1	2	f	0	\N	\N
2108	253	22	2	54971	\N	54971	\N	\N	0	1	2	f	0	\N	\N
2109	66	22	2	54344	\N	54344	\N	\N	0	1	2	f	0	\N	\N
2110	281	22	2	54260	\N	54260	\N	\N	0	1	2	f	0	\N	\N
2111	157	22	2	54036	\N	54036	\N	\N	0	1	2	f	0	\N	\N
2112	151	22	2	53020	\N	53020	\N	\N	0	1	2	f	0	\N	\N
2113	167	22	2	52755	\N	52755	\N	\N	0	1	2	f	0	\N	\N
2114	256	22	2	51692	\N	51692	\N	\N	0	1	2	f	0	\N	\N
2115	152	22	2	49841	\N	49841	\N	\N	0	1	2	f	0	\N	\N
2116	284	22	2	48390	\N	48390	\N	\N	0	1	2	f	0	\N	\N
2117	106	22	2	45429	\N	45429	\N	\N	0	1	2	f	0	\N	\N
2118	177	22	2	43689	\N	43689	\N	\N	0	1	2	f	0	\N	\N
2119	108	22	2	43290	\N	43290	\N	\N	0	1	2	f	0	\N	\N
2120	246	22	2	42310	\N	42310	\N	\N	0	1	2	f	0	\N	\N
2121	138	22	2	41777	\N	41777	\N	\N	0	1	2	f	0	\N	\N
2122	110	22	2	41532	\N	41532	\N	\N	0	1	2	f	0	\N	\N
2123	247	22	2	41196	\N	41196	\N	\N	0	1	2	f	0	\N	\N
2124	19	22	2	40890	\N	40890	\N	\N	0	1	2	f	0	\N	\N
2125	123	22	2	40728	\N	40728	\N	\N	0	1	2	f	0	\N	\N
2126	194	22	2	40373	\N	40373	\N	\N	0	1	2	f	0	\N	\N
2127	142	22	2	38398	\N	38398	\N	\N	0	1	2	f	0	\N	\N
2128	35	22	2	36192	\N	36192	\N	\N	0	1	2	f	0	\N	\N
2129	238	22	2	35648	\N	35648	\N	\N	0	1	2	f	0	\N	\N
2130	218	22	2	35429	\N	35429	\N	\N	0	1	2	f	0	\N	\N
2131	273	22	2	34740	\N	34740	\N	\N	0	1	2	f	0	\N	\N
2132	36	22	2	34357	\N	34357	\N	\N	0	1	2	f	0	\N	\N
2133	105	22	2	33168	\N	33168	\N	\N	0	1	2	f	0	\N	\N
2134	45	22	2	33107	\N	33107	\N	\N	0	1	2	f	0	\N	\N
2135	39	22	2	31654	\N	31654	\N	\N	0	1	2	f	0	\N	\N
2136	77	22	2	31475	\N	31475	\N	\N	0	1	2	f	0	\N	\N
2137	121	22	2	31374	\N	31374	\N	\N	0	1	2	f	0	\N	\N
2138	147	22	2	30569	\N	30569	\N	\N	0	1	2	f	0	\N	\N
2139	186	22	2	29662	\N	29662	\N	\N	0	1	2	f	0	\N	\N
2140	63	22	2	28251	\N	28251	\N	\N	0	1	2	f	0	\N	\N
2141	176	22	2	27701	\N	27701	\N	\N	0	1	2	f	0	\N	\N
2142	102	22	2	27394	\N	27394	\N	\N	0	1	2	f	0	\N	\N
2143	220	22	2	27347	\N	27347	\N	\N	0	1	2	f	0	\N	\N
2144	18	22	2	27342	\N	27342	\N	\N	0	1	2	f	0	\N	\N
2145	231	22	2	26616	\N	26616	\N	\N	0	1	2	f	0	\N	\N
2146	183	22	2	26240	\N	26240	\N	\N	0	1	2	f	0	\N	\N
2147	129	22	2	25944	\N	25944	\N	\N	0	1	2	f	0	\N	\N
2148	85	22	2	25932	\N	25932	\N	\N	0	1	2	f	0	\N	\N
2149	117	22	2	24596	\N	24596	\N	\N	0	1	2	f	0	\N	\N
2150	290	22	2	23922	\N	23922	\N	\N	0	1	2	f	0	\N	\N
2151	67	22	2	23379	\N	23379	\N	\N	0	1	2	f	0	\N	\N
2152	29	22	2	22140	\N	22140	\N	\N	0	1	2	f	0	\N	\N
2153	174	22	2	21885	\N	21885	\N	\N	0	1	2	f	0	\N	\N
2154	88	22	2	21257	\N	21257	\N	\N	0	1	2	f	0	\N	\N
2155	226	22	2	21144	\N	21144	\N	\N	0	1	2	f	0	\N	\N
2156	140	22	2	21068	\N	21068	\N	\N	0	1	2	f	0	\N	\N
2157	137	22	2	20834	\N	20834	\N	\N	0	1	2	f	0	\N	\N
2158	10	22	2	19816	\N	19816	\N	\N	0	1	2	f	0	\N	\N
2159	257	22	2	19621	\N	19621	\N	\N	0	1	2	f	0	\N	\N
2160	156	22	2	18390	\N	18390	\N	\N	0	1	2	f	0	\N	\N
2161	228	22	2	18186	\N	18186	\N	\N	0	1	2	f	0	\N	\N
2162	43	22	2	17799	\N	17799	\N	\N	0	1	2	f	0	\N	\N
2163	158	22	2	17576	\N	17576	\N	\N	0	1	2	f	0	\N	\N
2164	87	22	2	17197	\N	17197	\N	\N	0	1	2	f	0	\N	\N
2165	125	22	2	16635	\N	16635	\N	\N	0	1	2	f	0	\N	\N
2166	191	22	2	16260	\N	16260	\N	\N	0	1	2	f	0	\N	\N
2167	25	22	2	16157	\N	16157	\N	\N	0	1	2	f	0	\N	\N
2168	204	22	2	16009	\N	16009	\N	\N	0	1	2	f	0	\N	\N
2169	230	22	2	15909	\N	15909	\N	\N	0	1	2	f	0	\N	\N
2170	288	22	2	15766	\N	15766	\N	\N	0	1	2	f	0	\N	\N
2171	92	22	2	15037	\N	15037	\N	\N	0	1	2	f	0	\N	\N
2172	233	22	2	15023	\N	15023	\N	\N	0	1	2	f	0	\N	\N
2173	252	22	2	14919	\N	14919	\N	\N	0	1	2	f	0	\N	\N
2174	12	22	2	14564	\N	14564	\N	\N	0	1	2	f	0	\N	\N
2175	7	22	2	14222	\N	14222	\N	\N	0	1	2	f	0	\N	\N
2176	17	22	2	13896	\N	13896	\N	\N	0	1	2	f	0	\N	\N
2177	44	22	2	13467	\N	13467	\N	\N	0	1	2	f	0	\N	\N
2178	185	22	2	13391	\N	13391	\N	\N	0	1	2	f	0	\N	\N
2179	150	22	2	12389	\N	12389	\N	\N	0	1	2	f	0	\N	\N
2180	165	22	2	12034	\N	12034	\N	\N	0	1	2	f	0	\N	\N
2181	42	22	2	10956	\N	10956	\N	\N	0	1	2	f	0	\N	\N
2182	274	22	2	10278	\N	10278	\N	\N	0	1	2	f	0	\N	\N
2183	232	22	2	10237	\N	10237	\N	\N	0	1	2	f	0	\N	\N
2184	275	22	2	9565	\N	9565	\N	\N	0	1	2	f	0	\N	\N
2185	47	22	2	9313	\N	9313	\N	\N	0	1	2	f	0	\N	\N
2186	62	22	2	9275	\N	9275	\N	\N	0	1	2	f	0	\N	\N
2187	57	22	2	9145	\N	9145	\N	\N	0	1	2	f	0	\N	\N
2188	277	22	2	9124	\N	9124	\N	\N	0	1	2	f	0	\N	\N
2189	30	22	2	8857	\N	8857	\N	\N	0	1	2	f	0	\N	\N
2190	221	22	2	8747	\N	8747	\N	\N	0	1	2	f	0	\N	\N
2191	3	22	2	8735	\N	8735	\N	\N	0	1	2	f	0	\N	\N
2192	81	22	2	8581	\N	8581	\N	\N	0	1	2	f	0	\N	\N
2193	205	22	2	8566	\N	8566	\N	\N	0	1	2	f	0	\N	\N
2194	56	22	2	8289	\N	8289	\N	\N	0	1	2	f	0	\N	\N
2195	148	22	2	7811	\N	7811	\N	\N	0	1	2	f	0	\N	\N
2196	34	22	2	7395	\N	7395	\N	\N	0	1	2	f	0	\N	\N
2197	80	22	2	5470	\N	5470	\N	\N	0	1	2	f	0	\N	\N
2198	40	22	2	5335	\N	5335	\N	\N	0	1	2	f	0	\N	\N
2199	223	22	2	5180	\N	5180	\N	\N	0	1	2	f	0	\N	\N
2200	93	22	2	4965	\N	4965	\N	\N	0	1	2	f	0	\N	\N
2201	9	22	2	4802	\N	4802	\N	\N	0	1	2	f	0	\N	\N
2202	78	22	2	4527	\N	4527	\N	\N	0	1	2	f	0	\N	\N
2203	38	22	2	4466	\N	4466	\N	\N	0	1	2	f	0	\N	\N
2204	58	22	2	4434	\N	4434	\N	\N	0	1	2	f	0	\N	\N
2205	146	22	2	4407	\N	4407	\N	\N	0	1	2	f	0	\N	\N
2206	15	22	2	4372	\N	4372	\N	\N	0	1	2	f	0	\N	\N
2207	84	22	2	3602	\N	3602	\N	\N	0	1	2	f	0	\N	\N
2208	269	22	2	3591	\N	3591	\N	\N	0	1	2	f	0	\N	\N
2209	101	22	2	3481	\N	3481	\N	\N	0	1	2	f	0	\N	\N
2210	104	22	2	3421	\N	3421	\N	\N	0	1	2	f	0	\N	\N
2211	289	22	2	3349	\N	3349	\N	\N	0	1	2	f	0	\N	\N
2212	127	22	2	3306	\N	3306	\N	\N	0	1	2	f	0	\N	\N
2213	244	22	2	3178	\N	3178	\N	\N	0	1	2	f	0	\N	\N
2214	258	22	2	3007	\N	3007	\N	\N	0	1	2	f	0	\N	\N
2215	64	22	2	3004	\N	3004	\N	\N	0	1	2	f	0	\N	\N
2216	241	22	2	2711	\N	2711	\N	\N	0	1	2	f	0	\N	\N
2217	287	22	2	2371	\N	2371	\N	\N	0	1	2	f	0	\N	\N
2218	116	22	2	2275	\N	2275	\N	\N	0	1	2	f	0	\N	\N
2219	285	22	2	1840	\N	1840	\N	\N	0	1	2	f	0	\N	\N
2220	192	22	2	1814	\N	1814	\N	\N	0	1	2	f	0	\N	\N
2221	184	22	2	1679	\N	1679	\N	\N	0	1	2	f	0	\N	\N
2222	124	22	2	1623	\N	1623	\N	\N	0	1	2	f	0	\N	\N
2223	182	22	2	1554	\N	1554	\N	\N	0	1	2	f	0	\N	\N
2224	71	22	2	1399	\N	1399	\N	\N	0	1	2	f	0	\N	\N
2225	16	22	2	1342	\N	1342	\N	\N	0	1	2	f	0	\N	\N
2226	131	22	2	1313	\N	1313	\N	\N	0	1	2	f	0	\N	\N
2227	51	22	2	1282	\N	1282	\N	\N	0	1	2	f	0	\N	\N
2228	163	22	2	1157	\N	1157	\N	\N	0	1	2	f	0	\N	\N
2229	5	22	2	1134	\N	1134	\N	\N	0	1	2	f	0	\N	\N
2230	52	22	2	1110	\N	1110	\N	\N	0	1	2	f	0	\N	\N
2231	128	22	2	1063	\N	1063	\N	\N	0	1	2	f	0	\N	\N
2232	14	22	2	963	\N	963	\N	\N	0	1	2	f	0	\N	\N
2233	214	22	2	821	\N	821	\N	\N	0	1	2	f	0	\N	\N
2234	262	22	2	813	\N	813	\N	\N	0	1	2	f	0	\N	\N
2235	203	22	2	807	\N	807	\N	\N	0	1	2	f	0	\N	\N
2236	189	22	2	800	\N	800	\N	\N	0	1	2	f	0	\N	\N
2237	196	22	2	712	\N	712	\N	\N	0	1	2	f	0	\N	\N
2238	212	22	2	655	\N	655	\N	\N	0	1	2	f	0	\N	\N
2239	286	22	2	557	\N	557	\N	\N	0	1	2	f	0	\N	\N
2240	245	22	2	498	\N	498	\N	\N	0	1	2	f	0	\N	\N
2241	243	22	2	479	\N	479	\N	\N	0	1	2	f	0	\N	\N
2242	4	22	2	463	\N	463	\N	\N	0	1	2	f	0	\N	\N
2243	193	22	2	459	\N	459	\N	\N	0	1	2	f	0	\N	\N
2244	99	22	2	367	\N	367	\N	\N	0	1	2	f	0	\N	\N
2245	190	22	2	271	\N	271	\N	\N	0	1	2	f	0	\N	\N
2246	264	22	2	267	\N	267	\N	\N	0	1	2	f	0	\N	\N
2247	95	22	2	251	\N	251	\N	\N	0	1	2	f	0	\N	\N
2248	97	22	2	243	\N	243	\N	\N	0	1	2	f	0	\N	\N
2249	162	22	2	191	\N	191	\N	\N	0	1	2	f	0	\N	\N
2250	181	22	2	162	\N	162	\N	\N	0	1	2	f	0	\N	\N
2251	259	22	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
2252	132	22	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
2253	263	22	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
2254	160	22	2	58	\N	58	\N	\N	0	1	2	f	0	\N	\N
2255	213	22	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
2256	94	22	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
2257	26	22	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
2258	240	22	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
2259	100	22	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2260	266	22	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2261	268	22	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
2262	53	22	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
2263	130	22	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2264	211	22	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2265	161	22	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2266	215	22	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2267	267	22	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2268	216	22	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2269	50	22	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2270	270	22	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2271	27	22	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2272	69	22	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2273	239	22	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2274	1	22	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2275	265	22	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2276	98	22	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2277	28	22	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2278	96	22	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2279	2	22	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2280	111	23	2	13327569	\N	0	\N	\N	1	1	2	f	13327569	\N	\N
2281	251	23	2	5323262	\N	0	\N	\N	2	1	2	f	5323262	\N	\N
2282	109	23	2	5165851	\N	0	\N	\N	3	1	2	f	5165851	\N	\N
2283	54	23	2	3669065	\N	0	\N	\N	4	1	2	f	3669065	\N	\N
2284	55	23	2	2409022	\N	0	\N	\N	5	1	2	f	2409022	\N	\N
2285	145	23	2	1480996	\N	0	\N	\N	6	1	2	f	1480996	\N	\N
2286	33	23	2	1320847	\N	0	\N	\N	7	1	2	f	1320847	\N	\N
2287	139	23	2	921270	\N	0	\N	\N	8	1	2	f	921270	\N	\N
2288	91	23	2	132077	\N	0	\N	\N	9	1	2	f	132077	\N	\N
2289	70	23	2	1601	\N	0	\N	\N	10	1	2	f	1601	\N	\N
2290	149	23	2	9454230	\N	0	\N	\N	0	1	2	f	9454230	\N	\N
2291	255	23	2	1923716	\N	0	\N	\N	0	1	2	f	1923716	\N	\N
2292	209	23	2	1564079	\N	0	\N	\N	0	1	2	f	1564079	\N	\N
2293	126	23	2	1195344	\N	0	\N	\N	0	1	2	f	1195344	\N	\N
2294	210	23	2	1121860	\N	0	\N	\N	0	1	2	f	1121860	\N	\N
2295	282	23	2	1042100	\N	0	\N	\N	0	1	2	f	1042100	\N	\N
2296	37	23	2	783974	\N	0	\N	\N	0	1	2	f	783974	\N	\N
2297	249	23	2	569342	\N	0	\N	\N	0	1	2	f	569342	\N	\N
2298	242	23	2	478240	\N	0	\N	\N	0	1	2	f	478240	\N	\N
2299	118	23	2	439569	\N	0	\N	\N	0	1	2	f	439569	\N	\N
2300	278	23	2	417043	\N	0	\N	\N	0	1	2	f	417043	\N	\N
2301	112	23	2	396784	\N	0	\N	\N	0	1	2	f	396784	\N	\N
2302	6	23	2	308484	\N	0	\N	\N	0	1	2	f	308484	\N	\N
2303	195	23	2	304880	\N	0	\N	\N	0	1	2	f	304880	\N	\N
2304	90	23	2	260120	\N	0	\N	\N	0	1	2	f	260120	\N	\N
2305	222	23	2	257104	\N	0	\N	\N	0	1	2	f	257104	\N	\N
2306	119	23	2	243889	\N	0	\N	\N	0	1	2	f	243889	\N	\N
2307	136	23	2	229422	\N	0	\N	\N	0	1	2	f	229422	\N	\N
2308	76	23	2	225062	\N	0	\N	\N	0	1	2	f	225062	\N	\N
2309	21	23	2	223997	\N	0	\N	\N	0	1	2	f	223997	\N	\N
2310	234	23	2	210944	\N	0	\N	\N	0	1	2	f	210944	\N	\N
2311	180	23	2	195985	\N	0	\N	\N	0	1	2	f	195985	\N	\N
2312	208	23	2	183696	\N	0	\N	\N	0	1	2	f	183696	\N	\N
2313	72	23	2	175683	\N	0	\N	\N	0	1	2	f	175683	\N	\N
2314	237	23	2	175321	\N	0	\N	\N	0	1	2	f	175321	\N	\N
2315	197	23	2	171098	\N	0	\N	\N	0	1	2	f	171098	\N	\N
2316	225	23	2	150365	\N	0	\N	\N	0	1	2	f	150365	\N	\N
2317	173	23	2	147598	\N	0	\N	\N	0	1	2	f	147598	\N	\N
2318	46	23	2	145446	\N	0	\N	\N	0	1	2	f	145446	\N	\N
2319	74	23	2	139252	\N	0	\N	\N	0	1	2	f	139252	\N	\N
2320	236	23	2	133973	\N	0	\N	\N	0	1	2	f	133973	\N	\N
2321	48	23	2	126718	\N	0	\N	\N	0	1	2	f	126718	\N	\N
2322	61	23	2	120130	\N	0	\N	\N	0	1	2	f	120130	\N	\N
2323	133	23	2	118394	\N	0	\N	\N	0	1	2	f	118394	\N	\N
2324	83	23	2	117778	\N	0	\N	\N	0	1	2	f	117778	\N	\N
2325	159	23	2	110657	\N	0	\N	\N	0	1	2	f	110657	\N	\N
2326	179	23	2	109310	\N	0	\N	\N	0	1	2	f	109310	\N	\N
2327	261	23	2	108799	\N	0	\N	\N	0	1	2	f	108799	\N	\N
2328	114	23	2	103782	\N	0	\N	\N	0	1	2	f	103782	\N	\N
2329	32	23	2	103214	\N	0	\N	\N	0	1	2	f	103214	\N	\N
2330	219	23	2	99230	\N	0	\N	\N	0	1	2	f	99230	\N	\N
2331	68	23	2	98767	\N	0	\N	\N	0	1	2	f	98767	\N	\N
2332	11	23	2	97921	\N	0	\N	\N	0	1	2	f	97921	\N	\N
2333	13	23	2	95732	\N	0	\N	\N	0	1	2	f	95732	\N	\N
2334	279	23	2	94964	\N	0	\N	\N	0	1	2	f	94964	\N	\N
2335	120	23	2	93912	\N	0	\N	\N	0	1	2	f	93912	\N	\N
2336	224	23	2	93185	\N	0	\N	\N	0	1	2	f	93185	\N	\N
2337	107	23	2	91950	\N	0	\N	\N	0	1	2	f	91950	\N	\N
2338	143	23	2	89639	\N	0	\N	\N	0	1	2	f	89639	\N	\N
2339	24	23	2	87866	\N	0	\N	\N	0	1	2	f	87866	\N	\N
2340	8	23	2	86868	\N	0	\N	\N	0	1	2	f	86868	\N	\N
2341	188	23	2	81272	\N	0	\N	\N	0	1	2	f	81272	\N	\N
2342	169	23	2	76040	\N	0	\N	\N	0	1	2	f	76040	\N	\N
2343	168	23	2	70893	\N	0	\N	\N	0	1	2	f	70893	\N	\N
2344	229	23	2	69326	\N	0	\N	\N	0	1	2	f	69326	\N	\N
2345	49	23	2	67018	\N	0	\N	\N	0	1	2	f	67018	\N	\N
2346	171	23	2	65063	\N	0	\N	\N	0	1	2	f	65063	\N	\N
2347	280	23	2	64741	\N	0	\N	\N	0	1	2	f	64741	\N	\N
2348	103	23	2	63610	\N	0	\N	\N	0	1	2	f	63610	\N	\N
2349	198	23	2	62599	\N	0	\N	\N	0	1	2	f	62599	\N	\N
2350	283	23	2	60732	\N	0	\N	\N	0	1	2	f	60732	\N	\N
2351	65	23	2	58626	\N	0	\N	\N	0	1	2	f	58626	\N	\N
2352	135	23	2	57993	\N	0	\N	\N	0	1	2	f	57993	\N	\N
2353	60	23	2	56766	\N	0	\N	\N	0	1	2	f	56766	\N	\N
2354	113	23	2	54408	\N	0	\N	\N	0	1	2	f	54408	\N	\N
2355	202	23	2	53990	\N	0	\N	\N	0	1	2	f	53990	\N	\N
2356	59	23	2	53773	\N	0	\N	\N	0	1	2	f	53773	\N	\N
2357	79	23	2	53324	\N	0	\N	\N	0	1	2	f	53324	\N	\N
2358	166	23	2	50894	\N	0	\N	\N	0	1	2	f	50894	\N	\N
2359	206	23	2	49166	\N	0	\N	\N	0	1	2	f	49166	\N	\N
2360	250	23	2	46203	\N	0	\N	\N	0	1	2	f	46203	\N	\N
2361	23	23	2	46179	\N	0	\N	\N	0	1	2	f	46179	\N	\N
2362	153	23	2	45348	\N	0	\N	\N	0	1	2	f	45348	\N	\N
2363	271	23	2	44589	\N	0	\N	\N	0	1	2	f	44589	\N	\N
2364	115	23	2	41695	\N	0	\N	\N	0	1	2	f	41695	\N	\N
2365	73	23	2	41692	\N	0	\N	\N	0	1	2	f	41692	\N	\N
2366	235	23	2	41087	\N	0	\N	\N	0	1	2	f	41087	\N	\N
2367	155	23	2	40957	\N	0	\N	\N	0	1	2	f	40957	\N	\N
2368	144	23	2	40335	\N	0	\N	\N	0	1	2	f	40335	\N	\N
2369	227	23	2	38060	\N	0	\N	\N	0	1	2	f	38060	\N	\N
2370	199	23	2	36860	\N	0	\N	\N	0	1	2	f	36860	\N	\N
2371	260	23	2	35751	\N	0	\N	\N	0	1	2	f	35751	\N	\N
2372	201	23	2	35512	\N	0	\N	\N	0	1	2	f	35512	\N	\N
2373	200	23	2	35330	\N	0	\N	\N	0	1	2	f	35330	\N	\N
2374	82	23	2	32435	\N	0	\N	\N	0	1	2	f	32435	\N	\N
2375	172	23	2	32380	\N	0	\N	\N	0	1	2	f	32380	\N	\N
2376	207	23	2	32058	\N	0	\N	\N	0	1	2	f	32058	\N	\N
2377	122	23	2	31519	\N	0	\N	\N	0	1	2	f	31519	\N	\N
2378	41	23	2	30376	\N	0	\N	\N	0	1	2	f	30376	\N	\N
2379	248	23	2	29728	\N	0	\N	\N	0	1	2	f	29728	\N	\N
2380	20	23	2	29523	\N	0	\N	\N	0	1	2	f	29523	\N	\N
2381	86	23	2	29302	\N	0	\N	\N	0	1	2	f	29302	\N	\N
2382	75	23	2	28796	\N	0	\N	\N	0	1	2	f	28796	\N	\N
2383	134	23	2	28263	\N	0	\N	\N	0	1	2	f	28263	\N	\N
2384	154	23	2	28080	\N	0	\N	\N	0	1	2	f	28080	\N	\N
2385	170	23	2	27777	\N	0	\N	\N	0	1	2	f	27777	\N	\N
2386	276	23	2	27430	\N	0	\N	\N	0	1	2	f	27430	\N	\N
2387	254	23	2	26861	\N	0	\N	\N	0	1	2	f	26861	\N	\N
2388	178	23	2	26283	\N	0	\N	\N	0	1	2	f	26283	\N	\N
2389	31	23	2	26211	\N	0	\N	\N	0	1	2	f	26211	\N	\N
2390	175	23	2	25274	\N	0	\N	\N	0	1	2	f	25274	\N	\N
2391	272	23	2	25176	\N	0	\N	\N	0	1	2	f	25176	\N	\N
2392	89	23	2	24946	\N	0	\N	\N	0	1	2	f	24946	\N	\N
2393	187	23	2	24885	\N	0	\N	\N	0	1	2	f	24885	\N	\N
2394	157	23	2	24857	\N	0	\N	\N	0	1	2	f	24857	\N	\N
2395	167	23	2	24746	\N	0	\N	\N	0	1	2	f	24746	\N	\N
2396	281	23	2	24379	\N	0	\N	\N	0	1	2	f	24379	\N	\N
2397	253	23	2	24309	\N	0	\N	\N	0	1	2	f	24309	\N	\N
2398	22	23	2	24306	\N	0	\N	\N	0	1	2	f	24306	\N	\N
2399	152	23	2	24296	\N	0	\N	\N	0	1	2	f	24296	\N	\N
2400	151	23	2	23050	\N	0	\N	\N	0	1	2	f	23050	\N	\N
2401	66	23	2	22741	\N	0	\N	\N	0	1	2	f	22741	\N	\N
2402	256	23	2	22437	\N	0	\N	\N	0	1	2	f	22437	\N	\N
2403	141	23	2	22004	\N	0	\N	\N	0	1	2	f	22004	\N	\N
2404	284	23	2	20590	\N	0	\N	\N	0	1	2	f	20590	\N	\N
2405	110	23	2	19315	\N	0	\N	\N	0	1	2	f	19315	\N	\N
2406	108	23	2	19204	\N	0	\N	\N	0	1	2	f	19204	\N	\N
2407	247	23	2	18771	\N	0	\N	\N	0	1	2	f	18771	\N	\N
2408	246	23	2	18271	\N	0	\N	\N	0	1	2	f	18271	\N	\N
2409	177	23	2	18065	\N	0	\N	\N	0	1	2	f	18065	\N	\N
2410	19	23	2	17393	\N	0	\N	\N	0	1	2	f	17393	\N	\N
2411	138	23	2	17278	\N	0	\N	\N	0	1	2	f	17278	\N	\N
2412	123	23	2	17141	\N	0	\N	\N	0	1	2	f	17141	\N	\N
2413	194	23	2	16860	\N	0	\N	\N	0	1	2	f	16860	\N	\N
2414	35	23	2	16020	\N	0	\N	\N	0	1	2	f	16020	\N	\N
2415	142	23	2	15942	\N	0	\N	\N	0	1	2	f	15942	\N	\N
2416	106	23	2	15644	\N	0	\N	\N	0	1	2	f	15644	\N	\N
2417	36	23	2	15303	\N	0	\N	\N	0	1	2	f	15303	\N	\N
2418	238	23	2	14824	\N	0	\N	\N	0	1	2	f	14824	\N	\N
2419	218	23	2	14688	\N	0	\N	\N	0	1	2	f	14688	\N	\N
2420	273	23	2	14515	\N	0	\N	\N	0	1	2	f	14515	\N	\N
2421	45	23	2	14381	\N	0	\N	\N	0	1	2	f	14381	\N	\N
2422	147	23	2	13885	\N	0	\N	\N	0	1	2	f	13885	\N	\N
2423	105	23	2	13813	\N	0	\N	\N	0	1	2	f	13813	\N	\N
2424	39	23	2	13782	\N	0	\N	\N	0	1	2	f	13782	\N	\N
2425	77	23	2	12986	\N	0	\N	\N	0	1	2	f	12986	\N	\N
2426	121	23	2	12906	\N	0	\N	\N	0	1	2	f	12906	\N	\N
2427	220	23	2	12637	\N	0	\N	\N	0	1	2	f	12637	\N	\N
2428	186	23	2	12223	\N	0	\N	\N	0	1	2	f	12223	\N	\N
2429	176	23	2	12121	\N	0	\N	\N	0	1	2	f	12121	\N	\N
2430	129	23	2	11967	\N	0	\N	\N	0	1	2	f	11967	\N	\N
2431	231	23	2	11729	\N	0	\N	\N	0	1	2	f	11729	\N	\N
2432	63	23	2	11596	\N	0	\N	\N	0	1	2	f	11596	\N	\N
2433	18	23	2	11589	\N	0	\N	\N	0	1	2	f	11589	\N	\N
2434	183	23	2	11204	\N	0	\N	\N	0	1	2	f	11204	\N	\N
2435	102	23	2	11154	\N	0	\N	\N	0	1	2	f	11154	\N	\N
2436	290	23	2	11042	\N	0	\N	\N	0	1	2	f	11042	\N	\N
2437	85	23	2	10863	\N	0	\N	\N	0	1	2	f	10863	\N	\N
2438	117	23	2	10257	\N	0	\N	\N	0	1	2	f	10257	\N	\N
2439	67	23	2	9535	\N	0	\N	\N	0	1	2	f	9535	\N	\N
2440	29	23	2	9305	\N	0	\N	\N	0	1	2	f	9305	\N	\N
2441	226	23	2	9042	\N	0	\N	\N	0	1	2	f	9042	\N	\N
2442	156	23	2	8754	\N	0	\N	\N	0	1	2	f	8754	\N	\N
2443	137	23	2	8703	\N	0	\N	\N	0	1	2	f	8703	\N	\N
2444	174	23	2	8625	\N	0	\N	\N	0	1	2	f	8625	\N	\N
2445	10	23	2	8549	\N	0	\N	\N	0	1	2	f	8549	\N	\N
2446	257	23	2	8457	\N	0	\N	\N	0	1	2	f	8457	\N	\N
2447	88	23	2	8407	\N	0	\N	\N	0	1	2	f	8407	\N	\N
2448	140	23	2	8176	\N	0	\N	\N	0	1	2	f	8176	\N	\N
2449	228	23	2	7967	\N	0	\N	\N	0	1	2	f	7967	\N	\N
2450	191	23	2	7714	\N	0	\N	\N	0	1	2	f	7714	\N	\N
2451	230	23	2	7701	\N	0	\N	\N	0	1	2	f	7701	\N	\N
2452	158	23	2	7695	\N	0	\N	\N	0	1	2	f	7695	\N	\N
2453	43	23	2	7564	\N	0	\N	\N	0	1	2	f	7564	\N	\N
2454	204	23	2	7423	\N	0	\N	\N	0	1	2	f	7423	\N	\N
2455	87	23	2	7258	\N	0	\N	\N	0	1	2	f	7258	\N	\N
2456	25	23	2	7194	\N	0	\N	\N	0	1	2	f	7194	\N	\N
2457	288	23	2	6714	\N	0	\N	\N	0	1	2	f	6714	\N	\N
2458	125	23	2	6646	\N	0	\N	\N	0	1	2	f	6646	\N	\N
2459	92	23	2	6458	\N	0	\N	\N	0	1	2	f	6458	\N	\N
2460	233	23	2	6424	\N	0	\N	\N	0	1	2	f	6424	\N	\N
2461	12	23	2	6367	\N	0	\N	\N	0	1	2	f	6367	\N	\N
2462	185	23	2	6262	\N	0	\N	\N	0	1	2	f	6262	\N	\N
2463	17	23	2	6077	\N	0	\N	\N	0	1	2	f	6077	\N	\N
2464	252	23	2	5928	\N	0	\N	\N	0	1	2	f	5928	\N	\N
2465	150	23	2	5499	\N	0	\N	\N	0	1	2	f	5499	\N	\N
2466	165	23	2	5267	\N	0	\N	\N	0	1	2	f	5267	\N	\N
2467	44	23	2	5002	\N	0	\N	\N	0	1	2	f	5002	\N	\N
2468	7	23	2	5001	\N	0	\N	\N	0	1	2	f	5001	\N	\N
2469	232	23	2	4728	\N	0	\N	\N	0	1	2	f	4728	\N	\N
2470	42	23	2	4582	\N	0	\N	\N	0	1	2	f	4582	\N	\N
2471	274	23	2	4455	\N	0	\N	\N	0	1	2	f	4455	\N	\N
2472	277	23	2	4368	\N	0	\N	\N	0	1	2	f	4368	\N	\N
2473	57	23	2	3946	\N	0	\N	\N	0	1	2	f	3946	\N	\N
2474	62	23	2	3944	\N	0	\N	\N	0	1	2	f	3944	\N	\N
2475	275	23	2	3904	\N	0	\N	\N	0	1	2	f	3904	\N	\N
2476	47	23	2	3817	\N	0	\N	\N	0	1	2	f	3817	\N	\N
2477	56	23	2	3816	\N	0	\N	\N	0	1	2	f	3816	\N	\N
2478	205	23	2	3661	\N	0	\N	\N	0	1	2	f	3661	\N	\N
2479	30	23	2	3642	\N	0	\N	\N	0	1	2	f	3642	\N	\N
2480	221	23	2	3624	\N	0	\N	\N	0	1	2	f	3624	\N	\N
2481	81	23	2	3531	\N	0	\N	\N	0	1	2	f	3531	\N	\N
2482	3	23	2	3511	\N	0	\N	\N	0	1	2	f	3511	\N	\N
2483	34	23	2	3271	\N	0	\N	\N	0	1	2	f	3271	\N	\N
2484	148	23	2	3069	\N	0	\N	\N	0	1	2	f	3069	\N	\N
2485	38	23	2	2597	\N	0	\N	\N	0	1	2	f	2597	\N	\N
2486	104	23	2	2394	\N	0	\N	\N	0	1	2	f	2394	\N	\N
2487	40	23	2	2332	\N	0	\N	\N	0	1	2	f	2332	\N	\N
2488	223	23	2	2327	\N	0	\N	\N	0	1	2	f	2327	\N	\N
2489	9	23	2	2223	\N	0	\N	\N	0	1	2	f	2223	\N	\N
2490	93	23	2	2161	\N	0	\N	\N	0	1	2	f	2161	\N	\N
2491	146	23	2	2142	\N	0	\N	\N	0	1	2	f	2142	\N	\N
2492	80	23	2	2123	\N	0	\N	\N	0	1	2	f	2123	\N	\N
2493	78	23	2	2030	\N	0	\N	\N	0	1	2	f	2030	\N	\N
2494	15	23	2	1950	\N	0	\N	\N	0	1	2	f	1950	\N	\N
2495	289	23	2	1854	\N	0	\N	\N	0	1	2	f	1854	\N	\N
2496	58	23	2	1815	\N	0	\N	\N	0	1	2	f	1815	\N	\N
2497	269	23	2	1709	\N	0	\N	\N	0	1	2	f	1709	\N	\N
2498	241	23	2	1606	\N	0	\N	\N	0	1	2	f	1606	\N	\N
2499	84	23	2	1604	\N	0	\N	\N	0	1	2	f	1604	\N	\N
2500	127	23	2	1381	\N	0	\N	\N	0	1	2	f	1381	\N	\N
2501	101	23	2	1362	\N	0	\N	\N	0	1	2	f	1362	\N	\N
2502	244	23	2	1346	\N	0	\N	\N	0	1	2	f	1346	\N	\N
2503	258	23	2	1182	\N	0	\N	\N	0	1	2	f	1182	\N	\N
2504	64	23	2	1174	\N	0	\N	\N	0	1	2	f	1174	\N	\N
2505	116	23	2	1072	\N	0	\N	\N	0	1	2	f	1072	\N	\N
2506	287	23	2	1013	\N	0	\N	\N	0	1	2	f	1013	\N	\N
2507	192	23	2	889	\N	0	\N	\N	0	1	2	f	889	\N	\N
2508	285	23	2	817	\N	0	\N	\N	0	1	2	f	817	\N	\N
2509	184	23	2	731	\N	0	\N	\N	0	1	2	f	731	\N	\N
2510	182	23	2	679	\N	0	\N	\N	0	1	2	f	679	\N	\N
2511	212	23	2	657	\N	0	\N	\N	0	1	2	f	657	\N	\N
2512	262	23	2	616	\N	0	\N	\N	0	1	2	f	616	\N	\N
2513	71	23	2	614	\N	0	\N	\N	0	1	2	f	614	\N	\N
2514	124	23	2	614	\N	0	\N	\N	0	1	2	f	614	\N	\N
2515	51	23	2	547	\N	0	\N	\N	0	1	2	f	547	\N	\N
2516	5	23	2	500	\N	0	\N	\N	0	1	2	f	500	\N	\N
2517	16	23	2	489	\N	0	\N	\N	0	1	2	f	489	\N	\N
2518	163	23	2	458	\N	0	\N	\N	0	1	2	f	458	\N	\N
2519	52	23	2	457	\N	0	\N	\N	0	1	2	f	457	\N	\N
2520	128	23	2	429	\N	0	\N	\N	0	1	2	f	429	\N	\N
2521	214	23	2	416	\N	0	\N	\N	0	1	2	f	416	\N	\N
2522	14	23	2	400	\N	0	\N	\N	0	1	2	f	400	\N	\N
2523	203	23	2	323	\N	0	\N	\N	0	1	2	f	323	\N	\N
2524	189	23	2	315	\N	0	\N	\N	0	1	2	f	315	\N	\N
2525	196	23	2	309	\N	0	\N	\N	0	1	2	f	309	\N	\N
2526	286	23	2	256	\N	0	\N	\N	0	1	2	f	256	\N	\N
2527	4	23	2	250	\N	0	\N	\N	0	1	2	f	250	\N	\N
2528	193	23	2	222	\N	0	\N	\N	0	1	2	f	222	\N	\N
2529	245	23	2	214	\N	0	\N	\N	0	1	2	f	214	\N	\N
2530	264	23	2	207	\N	0	\N	\N	0	1	2	f	207	\N	\N
2531	243	23	2	198	\N	0	\N	\N	0	1	2	f	198	\N	\N
2532	99	23	2	197	\N	0	\N	\N	0	1	2	f	197	\N	\N
2533	131	23	2	175	\N	0	\N	\N	0	1	2	f	175	\N	\N
2534	190	23	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
2535	97	23	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
2536	95	23	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
2537	162	23	2	80	\N	0	\N	\N	0	1	2	f	80	\N	\N
2538	181	23	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
2539	213	23	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
2540	263	23	2	30	\N	0	\N	\N	0	1	2	f	30	\N	\N
2541	160	23	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
2542	132	23	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
2543	259	23	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
2544	94	23	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
2545	26	23	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2546	240	23	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
2547	100	23	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2548	266	23	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2549	268	23	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2550	211	23	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2551	161	23	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2552	53	23	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2553	267	23	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2554	130	23	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2555	215	23	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2556	50	23	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2557	27	23	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2558	239	23	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2559	69	23	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2560	1	23	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2561	265	23	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2562	98	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2563	28	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2564	96	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2565	270	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2566	216	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2567	2	23	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2568	135	24	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
2569	251	24	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
2570	217	25	2	284	\N	0	\N	\N	1	1	2	f	284	\N	\N
2571	54	26	2	142	\N	0	\N	\N	1	1	2	f	142	\N	\N
2572	145	26	2	135	\N	0	\N	\N	2	1	2	f	135	\N	\N
2573	110	26	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
2574	262	26	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
2575	43	26	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
2576	273	26	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
2577	227	26	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
2578	23	26	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
2579	45	26	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2580	139	26	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2581	262	27	2	247	\N	0	\N	\N	1	1	2	f	247	\N	\N
2582	54	27	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
2583	54	29	2	142	\N	0	\N	\N	1	1	2	f	142	\N	\N
2584	145	29	2	135	\N	0	\N	\N	2	1	2	f	135	\N	\N
2585	110	29	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
2586	262	29	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
2587	43	29	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
2588	273	29	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
2589	227	29	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
2590	23	29	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
2591	45	29	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2592	139	29	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2593	70	30	2	1546	\N	0	\N	\N	1	1	2	f	1546	\N	\N
2594	70	31	2	1850	\N	1850	\N	\N	1	1	2	f	0	70	\N
2595	70	31	1	1850	\N	1850	\N	\N	1	1	2	f	\N	70	\N
2596	111	32	2	11755071	\N	11755071	\N	\N	1	1	2	f	0	\N	\N
2597	109	32	2	4906174	\N	4906174	\N	\N	2	1	2	f	0	\N	\N
2598	251	32	2	4778255	\N	4778255	\N	\N	3	1	2	f	0	\N	\N
2599	54	32	2	3422319	\N	3422319	\N	\N	4	1	2	f	0	\N	\N
2600	55	32	2	2321110	\N	2321110	\N	\N	5	1	2	f	0	\N	\N
2601	145	32	2	1300451	\N	1300451	\N	\N	6	1	2	f	0	\N	\N
2602	33	32	2	1274717	\N	1274717	\N	\N	7	1	2	f	0	\N	\N
2603	139	32	2	709021	\N	709021	\N	\N	8	1	2	f	0	\N	\N
2604	91	32	2	125391	\N	125391	\N	\N	9	1	2	f	0	\N	\N
2605	70	32	2	1546	\N	1546	\N	\N	10	1	2	f	0	\N	\N
2606	149	32	2	9069126	\N	9069126	\N	\N	0	1	2	f	0	\N	\N
2607	255	32	2	1830201	\N	1830201	\N	\N	0	1	2	f	0	\N	\N
2608	209	32	2	1536812	\N	1536812	\N	\N	0	1	2	f	0	\N	\N
2609	126	32	2	1132543	\N	1132543	\N	\N	0	1	2	f	0	\N	\N
2610	282	32	2	978197	\N	978197	\N	\N	0	1	2	f	0	\N	\N
2611	210	32	2	977158	\N	977158	\N	\N	0	1	2	f	0	\N	\N
2612	37	32	2	754107	\N	754107	\N	\N	0	1	2	f	0	\N	\N
2613	249	32	2	549908	\N	549908	\N	\N	0	1	2	f	0	\N	\N
2614	242	32	2	441450	\N	441450	\N	\N	0	1	2	f	0	\N	\N
2615	118	32	2	418468	\N	418468	\N	\N	0	1	2	f	0	\N	\N
2616	278	32	2	405128	\N	405128	\N	\N	0	1	2	f	0	\N	\N
2617	112	32	2	378703	\N	378703	\N	\N	0	1	2	f	0	\N	\N
2618	195	32	2	298703	\N	298703	\N	\N	0	1	2	f	0	\N	\N
2619	6	32	2	297060	\N	297060	\N	\N	0	1	2	f	0	\N	\N
2620	222	32	2	251585	\N	251585	\N	\N	0	1	2	f	0	\N	\N
2621	90	32	2	247421	\N	247421	\N	\N	0	1	2	f	0	\N	\N
2622	119	32	2	233176	\N	233176	\N	\N	0	1	2	f	0	\N	\N
2623	136	32	2	220113	\N	220113	\N	\N	0	1	2	f	0	\N	\N
2624	21	32	2	217362	\N	217362	\N	\N	0	1	2	f	0	\N	\N
2625	76	32	2	213533	\N	213533	\N	\N	0	1	2	f	0	\N	\N
2626	234	32	2	203949	\N	203949	\N	\N	0	1	2	f	0	\N	\N
2627	180	32	2	190265	\N	190265	\N	\N	0	1	2	f	0	\N	\N
2628	208	32	2	178450	\N	178450	\N	\N	0	1	2	f	0	\N	\N
2629	237	32	2	169772	\N	169772	\N	\N	0	1	2	f	0	\N	\N
2630	72	32	2	168152	\N	168152	\N	\N	0	1	2	f	0	\N	\N
2631	197	32	2	166120	\N	166120	\N	\N	0	1	2	f	0	\N	\N
2632	225	32	2	149835	\N	149835	\N	\N	0	1	2	f	0	\N	\N
2633	173	32	2	143276	\N	143276	\N	\N	0	1	2	f	0	\N	\N
2634	46	32	2	139906	\N	139906	\N	\N	0	1	2	f	0	\N	\N
2635	74	32	2	132500	\N	132500	\N	\N	0	1	2	f	0	\N	\N
2636	236	32	2	128038	\N	128038	\N	\N	0	1	2	f	0	\N	\N
2637	48	32	2	122012	\N	122012	\N	\N	0	1	2	f	0	\N	\N
2638	61	32	2	115441	\N	115441	\N	\N	0	1	2	f	0	\N	\N
2639	133	32	2	114343	\N	114343	\N	\N	0	1	2	f	0	\N	\N
2640	83	32	2	113400	\N	113400	\N	\N	0	1	2	f	0	\N	\N
2641	159	32	2	109705	\N	109705	\N	\N	0	1	2	f	0	\N	\N
2642	261	32	2	104556	\N	104556	\N	\N	0	1	2	f	0	\N	\N
2643	179	32	2	104349	\N	104349	\N	\N	0	1	2	f	0	\N	\N
2644	114	32	2	99621	\N	99621	\N	\N	0	1	2	f	0	\N	\N
2645	32	32	2	99479	\N	99479	\N	\N	0	1	2	f	0	\N	\N
2646	219	32	2	96397	\N	96397	\N	\N	0	1	2	f	0	\N	\N
2647	68	32	2	95105	\N	95105	\N	\N	0	1	2	f	0	\N	\N
2648	11	32	2	92878	\N	92878	\N	\N	0	1	2	f	0	\N	\N
2649	13	32	2	91937	\N	91937	\N	\N	0	1	2	f	0	\N	\N
2650	279	32	2	91890	\N	91890	\N	\N	0	1	2	f	0	\N	\N
2651	224	32	2	91347	\N	91347	\N	\N	0	1	2	f	0	\N	\N
2652	120	32	2	90029	\N	90029	\N	\N	0	1	2	f	0	\N	\N
2653	107	32	2	88703	\N	88703	\N	\N	0	1	2	f	0	\N	\N
2654	143	32	2	84816	\N	84816	\N	\N	0	1	2	f	0	\N	\N
2655	24	32	2	83872	\N	83872	\N	\N	0	1	2	f	0	\N	\N
2656	8	32	2	81821	\N	81821	\N	\N	0	1	2	f	0	\N	\N
2657	188	32	2	76766	\N	76766	\N	\N	0	1	2	f	0	\N	\N
2658	169	32	2	73621	\N	73621	\N	\N	0	1	2	f	0	\N	\N
2659	168	32	2	68386	\N	68386	\N	\N	0	1	2	f	0	\N	\N
2660	229	32	2	66782	\N	66782	\N	\N	0	1	2	f	0	\N	\N
2661	49	32	2	65135	\N	65135	\N	\N	0	1	2	f	0	\N	\N
2662	280	32	2	61809	\N	61809	\N	\N	0	1	2	f	0	\N	\N
2663	171	32	2	61226	\N	61226	\N	\N	0	1	2	f	0	\N	\N
2664	103	32	2	60906	\N	60906	\N	\N	0	1	2	f	0	\N	\N
2665	283	32	2	60487	\N	60487	\N	\N	0	1	2	f	0	\N	\N
2666	198	32	2	59993	\N	59993	\N	\N	0	1	2	f	0	\N	\N
2667	65	32	2	56175	\N	56175	\N	\N	0	1	2	f	0	\N	\N
2668	135	32	2	54788	\N	54788	\N	\N	0	1	2	f	0	\N	\N
2669	60	32	2	54334	\N	54334	\N	\N	0	1	2	f	0	\N	\N
2670	113	32	2	53337	\N	53337	\N	\N	0	1	2	f	0	\N	\N
2671	79	32	2	53153	\N	53153	\N	\N	0	1	2	f	0	\N	\N
2672	202	32	2	51760	\N	51760	\N	\N	0	1	2	f	0	\N	\N
2673	59	32	2	51394	\N	51394	\N	\N	0	1	2	f	0	\N	\N
2674	206	32	2	48058	\N	48058	\N	\N	0	1	2	f	0	\N	\N
2675	166	32	2	48009	\N	48009	\N	\N	0	1	2	f	0	\N	\N
2676	250	32	2	45312	\N	45312	\N	\N	0	1	2	f	0	\N	\N
2677	23	32	2	44408	\N	44408	\N	\N	0	1	2	f	0	\N	\N
2678	153	32	2	43567	\N	43567	\N	\N	0	1	2	f	0	\N	\N
2679	271	32	2	43188	\N	43188	\N	\N	0	1	2	f	0	\N	\N
2680	73	32	2	40290	\N	40290	\N	\N	0	1	2	f	0	\N	\N
2681	115	32	2	39848	\N	39848	\N	\N	0	1	2	f	0	\N	\N
2682	144	32	2	39303	\N	39303	\N	\N	0	1	2	f	0	\N	\N
2683	155	32	2	39228	\N	39228	\N	\N	0	1	2	f	0	\N	\N
2684	235	32	2	38059	\N	38059	\N	\N	0	1	2	f	0	\N	\N
2685	227	32	2	36753	\N	36753	\N	\N	0	1	2	f	0	\N	\N
2686	199	32	2	35399	\N	35399	\N	\N	0	1	2	f	0	\N	\N
2687	200	32	2	34519	\N	34519	\N	\N	0	1	2	f	0	\N	\N
2688	201	32	2	34452	\N	34452	\N	\N	0	1	2	f	0	\N	\N
2689	260	32	2	34452	\N	34452	\N	\N	0	1	2	f	0	\N	\N
2690	82	32	2	31636	\N	31636	\N	\N	0	1	2	f	0	\N	\N
2691	207	32	2	30801	\N	30801	\N	\N	0	1	2	f	0	\N	\N
2692	122	32	2	30612	\N	30612	\N	\N	0	1	2	f	0	\N	\N
2693	172	32	2	30086	\N	30086	\N	\N	0	1	2	f	0	\N	\N
2694	41	32	2	29224	\N	29224	\N	\N	0	1	2	f	0	\N	\N
2695	20	32	2	28680	\N	28680	\N	\N	0	1	2	f	0	\N	\N
2696	86	32	2	28577	\N	28577	\N	\N	0	1	2	f	0	\N	\N
2697	75	32	2	27866	\N	27866	\N	\N	0	1	2	f	0	\N	\N
2698	248	32	2	27668	\N	27668	\N	\N	0	1	2	f	0	\N	\N
2699	134	32	2	27454	\N	27454	\N	\N	0	1	2	f	0	\N	\N
2700	170	32	2	27248	\N	27248	\N	\N	0	1	2	f	0	\N	\N
2701	154	32	2	26677	\N	26677	\N	\N	0	1	2	f	0	\N	\N
2702	276	32	2	26660	\N	26660	\N	\N	0	1	2	f	0	\N	\N
2703	254	32	2	25928	\N	25928	\N	\N	0	1	2	f	0	\N	\N
2704	31	32	2	25208	\N	25208	\N	\N	0	1	2	f	0	\N	\N
2705	178	32	2	25205	\N	25205	\N	\N	0	1	2	f	0	\N	\N
2706	272	32	2	24248	\N	24248	\N	\N	0	1	2	f	0	\N	\N
2707	167	32	2	24214	\N	24214	\N	\N	0	1	2	f	0	\N	\N
2708	89	32	2	24122	\N	24122	\N	\N	0	1	2	f	0	\N	\N
2709	157	32	2	24079	\N	24079	\N	\N	0	1	2	f	0	\N	\N
2710	175	32	2	23978	\N	23978	\N	\N	0	1	2	f	0	\N	\N
2711	22	32	2	23926	\N	23926	\N	\N	0	1	2	f	0	\N	\N
2712	187	32	2	23859	\N	23859	\N	\N	0	1	2	f	0	\N	\N
2713	281	32	2	23760	\N	23760	\N	\N	0	1	2	f	0	\N	\N
2714	152	32	2	23729	\N	23729	\N	\N	0	1	2	f	0	\N	\N
2715	253	32	2	22654	\N	22654	\N	\N	0	1	2	f	0	\N	\N
2716	151	32	2	21994	\N	21994	\N	\N	0	1	2	f	0	\N	\N
2717	66	32	2	21979	\N	21979	\N	\N	0	1	2	f	0	\N	\N
2718	256	32	2	21583	\N	21583	\N	\N	0	1	2	f	0	\N	\N
2719	141	32	2	21576	\N	21576	\N	\N	0	1	2	f	0	\N	\N
2720	284	32	2	20303	\N	20303	\N	\N	0	1	2	f	0	\N	\N
2721	110	32	2	18959	\N	18959	\N	\N	0	1	2	f	0	\N	\N
2722	108	32	2	18592	\N	18592	\N	\N	0	1	2	f	0	\N	\N
2723	247	32	2	18410	\N	18410	\N	\N	0	1	2	f	0	\N	\N
2724	246	32	2	17491	\N	17491	\N	\N	0	1	2	f	0	\N	\N
2725	177	32	2	17271	\N	17271	\N	\N	0	1	2	f	0	\N	\N
2726	138	32	2	16782	\N	16782	\N	\N	0	1	2	f	0	\N	\N
2727	123	32	2	16767	\N	16767	\N	\N	0	1	2	f	0	\N	\N
2728	19	32	2	16736	\N	16736	\N	\N	0	1	2	f	0	\N	\N
2729	194	32	2	16544	\N	16544	\N	\N	0	1	2	f	0	\N	\N
2730	35	32	2	15526	\N	15526	\N	\N	0	1	2	f	0	\N	\N
2731	106	32	2	15462	\N	15462	\N	\N	0	1	2	f	0	\N	\N
2732	142	32	2	15373	\N	15373	\N	\N	0	1	2	f	0	\N	\N
2733	36	32	2	14833	\N	14833	\N	\N	0	1	2	f	0	\N	\N
2734	238	32	2	14453	\N	14453	\N	\N	0	1	2	f	0	\N	\N
2735	218	32	2	14245	\N	14245	\N	\N	0	1	2	f	0	\N	\N
2736	273	32	2	14027	\N	14027	\N	\N	0	1	2	f	0	\N	\N
2737	45	32	2	13989	\N	13989	\N	\N	0	1	2	f	0	\N	\N
2738	147	32	2	13553	\N	13553	\N	\N	0	1	2	f	0	\N	\N
2739	39	32	2	13409	\N	13409	\N	\N	0	1	2	f	0	\N	\N
2740	105	32	2	13293	\N	13293	\N	\N	0	1	2	f	0	\N	\N
2741	77	32	2	12374	\N	12374	\N	\N	0	1	2	f	0	\N	\N
2742	121	32	2	12342	\N	12342	\N	\N	0	1	2	f	0	\N	\N
2743	220	32	2	12262	\N	12262	\N	\N	0	1	2	f	0	\N	\N
2744	186	32	2	11814	\N	11814	\N	\N	0	1	2	f	0	\N	\N
2745	129	32	2	11624	\N	11624	\N	\N	0	1	2	f	0	\N	\N
2746	176	32	2	11609	\N	11609	\N	\N	0	1	2	f	0	\N	\N
2747	231	32	2	11384	\N	11384	\N	\N	0	1	2	f	0	\N	\N
2748	18	32	2	11180	\N	11180	\N	\N	0	1	2	f	0	\N	\N
2749	63	32	2	11148	\N	11148	\N	\N	0	1	2	f	0	\N	\N
2750	183	32	2	10848	\N	10848	\N	\N	0	1	2	f	0	\N	\N
2751	290	32	2	10823	\N	10823	\N	\N	0	1	2	f	0	\N	\N
2752	102	32	2	10800	\N	10800	\N	\N	0	1	2	f	0	\N	\N
2753	85	32	2	10156	\N	10156	\N	\N	0	1	2	f	0	\N	\N
2754	117	32	2	9952	\N	9952	\N	\N	0	1	2	f	0	\N	\N
2755	67	32	2	9163	\N	9163	\N	\N	0	1	2	f	0	\N	\N
2756	29	32	2	9021	\N	9021	\N	\N	0	1	2	f	0	\N	\N
2757	226	32	2	8733	\N	8733	\N	\N	0	1	2	f	0	\N	\N
2758	156	32	2	8484	\N	8484	\N	\N	0	1	2	f	0	\N	\N
2759	174	32	2	8427	\N	8427	\N	\N	0	1	2	f	0	\N	\N
2760	137	32	2	8340	\N	8340	\N	\N	0	1	2	f	0	\N	\N
2761	10	32	2	8280	\N	8280	\N	\N	0	1	2	f	0	\N	\N
2762	257	32	2	8243	\N	8243	\N	\N	0	1	2	f	0	\N	\N
2763	88	32	2	8127	\N	8127	\N	\N	0	1	2	f	0	\N	\N
2764	140	32	2	7797	\N	7797	\N	\N	0	1	2	f	0	\N	\N
2765	228	32	2	7758	\N	7758	\N	\N	0	1	2	f	0	\N	\N
2766	191	32	2	7512	\N	7512	\N	\N	0	1	2	f	0	\N	\N
2767	158	32	2	7287	\N	7287	\N	\N	0	1	2	f	0	\N	\N
2768	43	32	2	7281	\N	7281	\N	\N	0	1	2	f	0	\N	\N
2769	230	32	2	7258	\N	7258	\N	\N	0	1	2	f	0	\N	\N
2770	87	32	2	7053	\N	7053	\N	\N	0	1	2	f	0	\N	\N
2771	25	32	2	7010	\N	7010	\N	\N	0	1	2	f	0	\N	\N
2772	204	32	2	6865	\N	6865	\N	\N	0	1	2	f	0	\N	\N
2773	288	32	2	6514	\N	6514	\N	\N	0	1	2	f	0	\N	\N
2774	125	32	2	6322	\N	6322	\N	\N	0	1	2	f	0	\N	\N
2775	12	32	2	6275	\N	6275	\N	\N	0	1	2	f	0	\N	\N
2776	92	32	2	6256	\N	6256	\N	\N	0	1	2	f	0	\N	\N
2777	185	32	2	6076	\N	6076	\N	\N	0	1	2	f	0	\N	\N
2778	17	32	2	5856	\N	5856	\N	\N	0	1	2	f	0	\N	\N
2779	233	32	2	5771	\N	5771	\N	\N	0	1	2	f	0	\N	\N
2780	252	32	2	5712	\N	5712	\N	\N	0	1	2	f	0	\N	\N
2781	150	32	2	5373	\N	5373	\N	\N	0	1	2	f	0	\N	\N
2782	165	32	2	5067	\N	5067	\N	\N	0	1	2	f	0	\N	\N
2783	7	32	2	4961	\N	4961	\N	\N	0	1	2	f	0	\N	\N
2784	44	32	2	4774	\N	4774	\N	\N	0	1	2	f	0	\N	\N
2785	232	32	2	4583	\N	4583	\N	\N	0	1	2	f	0	\N	\N
2786	42	32	2	4380	\N	4380	\N	\N	0	1	2	f	0	\N	\N
2787	274	32	2	4322	\N	4322	\N	\N	0	1	2	f	0	\N	\N
2788	277	32	2	4291	\N	4291	\N	\N	0	1	2	f	0	\N	\N
2789	57	32	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
2790	62	32	2	3793	\N	3793	\N	\N	0	1	2	f	0	\N	\N
2791	275	32	2	3759	\N	3759	\N	\N	0	1	2	f	0	\N	\N
2792	56	32	2	3731	\N	3731	\N	\N	0	1	2	f	0	\N	\N
2793	47	32	2	3664	\N	3664	\N	\N	0	1	2	f	0	\N	\N
2794	205	32	2	3604	\N	3604	\N	\N	0	1	2	f	0	\N	\N
2795	221	32	2	3540	\N	3540	\N	\N	0	1	2	f	0	\N	\N
2796	30	32	2	3502	\N	3502	\N	\N	0	1	2	f	0	\N	\N
2797	81	32	2	3439	\N	3439	\N	\N	0	1	2	f	0	\N	\N
2798	34	32	2	3161	\N	3161	\N	\N	0	1	2	f	0	\N	\N
2799	3	32	2	2958	\N	2958	\N	\N	0	1	2	f	0	\N	\N
2800	148	32	2	2921	\N	2921	\N	\N	0	1	2	f	0	\N	\N
2801	223	32	2	2277	\N	2277	\N	\N	0	1	2	f	0	\N	\N
2802	40	32	2	2277	\N	2277	\N	\N	0	1	2	f	0	\N	\N
2803	93	32	2	2144	\N	2144	\N	\N	0	1	2	f	0	\N	\N
2804	38	32	2	2133	\N	2133	\N	\N	0	1	2	f	0	\N	\N
2805	146	32	2	2102	\N	2102	\N	\N	0	1	2	f	0	\N	\N
2806	9	32	2	2099	\N	2099	\N	\N	0	1	2	f	0	\N	\N
2807	80	32	2	2050	\N	2050	\N	\N	0	1	2	f	0	\N	\N
2808	78	32	2	1955	\N	1955	\N	\N	0	1	2	f	0	\N	\N
2809	15	32	2	1909	\N	1909	\N	\N	0	1	2	f	0	\N	\N
2810	58	32	2	1738	\N	1738	\N	\N	0	1	2	f	0	\N	\N
2811	289	32	2	1651	\N	1651	\N	\N	0	1	2	f	0	\N	\N
2812	269	32	2	1650	\N	1650	\N	\N	0	1	2	f	0	\N	\N
2813	84	32	2	1530	\N	1530	\N	\N	0	1	2	f	0	\N	\N
2814	104	32	2	1509	\N	1509	\N	\N	0	1	2	f	0	\N	\N
2815	127	32	2	1337	\N	1337	\N	\N	0	1	2	f	0	\N	\N
2816	101	32	2	1320	\N	1320	\N	\N	0	1	2	f	0	\N	\N
2817	241	32	2	1309	\N	1309	\N	\N	0	1	2	f	0	\N	\N
2818	244	32	2	1303	\N	1303	\N	\N	0	1	2	f	0	\N	\N
2819	258	32	2	1166	\N	1166	\N	\N	0	1	2	f	0	\N	\N
2820	64	32	2	1135	\N	1135	\N	\N	0	1	2	f	0	\N	\N
2821	116	32	2	1069	\N	1069	\N	\N	0	1	2	f	0	\N	\N
2822	287	32	2	992	\N	992	\N	\N	0	1	2	f	0	\N	\N
2823	192	32	2	864	\N	864	\N	\N	0	1	2	f	0	\N	\N
2824	285	32	2	799	\N	799	\N	\N	0	1	2	f	0	\N	\N
2825	184	32	2	707	\N	707	\N	\N	0	1	2	f	0	\N	\N
2826	182	32	2	660	\N	660	\N	\N	0	1	2	f	0	\N	\N
2827	71	32	2	597	\N	597	\N	\N	0	1	2	f	0	\N	\N
2828	124	32	2	588	\N	588	\N	\N	0	1	2	f	0	\N	\N
2829	51	32	2	541	\N	541	\N	\N	0	1	2	f	0	\N	\N
2830	5	32	2	484	\N	484	\N	\N	0	1	2	f	0	\N	\N
2831	16	32	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
2832	163	32	2	446	\N	446	\N	\N	0	1	2	f	0	\N	\N
2833	52	32	2	434	\N	434	\N	\N	0	1	2	f	0	\N	\N
2834	128	32	2	419	\N	419	\N	\N	0	1	2	f	0	\N	\N
2835	262	32	2	405	\N	405	\N	\N	0	1	2	f	0	\N	\N
2836	214	32	2	398	\N	398	\N	\N	0	1	2	f	0	\N	\N
2837	14	32	2	362	\N	362	\N	\N	0	1	2	f	0	\N	\N
2838	212	32	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
2839	203	32	2	308	\N	308	\N	\N	0	1	2	f	0	\N	\N
2840	189	32	2	307	\N	307	\N	\N	0	1	2	f	0	\N	\N
2841	196	32	2	301	\N	301	\N	\N	0	1	2	f	0	\N	\N
2842	286	32	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
2843	4	32	2	227	\N	227	\N	\N	0	1	2	f	0	\N	\N
2844	193	32	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
2845	245	32	2	212	\N	212	\N	\N	0	1	2	f	0	\N	\N
2846	243	32	2	194	\N	194	\N	\N	0	1	2	f	0	\N	\N
2847	131	32	2	173	\N	173	\N	\N	0	1	2	f	0	\N	\N
2848	99	32	2	166	\N	166	\N	\N	0	1	2	f	0	\N	\N
2849	264	32	2	133	\N	133	\N	\N	0	1	2	f	0	\N	\N
2850	190	32	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
2851	97	32	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
2852	95	32	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
2853	162	32	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
2854	181	32	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
2855	263	32	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
2856	160	32	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
2857	213	32	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
2858	132	32	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
2859	259	32	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
2860	94	32	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
2861	26	32	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
2862	240	32	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
2863	100	32	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2864	266	32	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2865	268	32	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
2866	53	32	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2867	211	32	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2868	161	32	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2869	130	32	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2870	215	32	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2871	267	32	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2872	50	32	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2873	27	32	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2874	239	32	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2875	69	32	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2876	1	32	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2877	265	32	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2878	98	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2879	28	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2880	96	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2881	270	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2882	216	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2883	2	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2884	33	34	2	39484	\N	0	\N	\N	1	1	2	f	39484	\N	\N
2885	139	34	2	23704	\N	0	\N	\N	2	1	2	f	23704	\N	\N
2886	55	34	2	9638	\N	0	\N	\N	3	1	2	f	9638	\N	\N
2887	54	34	2	4872	\N	0	\N	\N	4	1	2	f	4872	\N	\N
2888	109	34	2	2258	\N	0	\N	\N	5	1	2	f	2258	\N	\N
2889	145	34	2	815	\N	0	\N	\N	6	1	2	f	815	\N	\N
2890	251	34	2	26	\N	0	\N	\N	7	1	2	f	26	\N	\N
2891	91	34	2	14	\N	0	\N	\N	8	1	2	f	14	\N	\N
2892	111	34	2	5	\N	0	\N	\N	9	1	2	f	5	\N	\N
2893	21	34	2	18718	\N	0	\N	\N	0	1	2	f	18718	\N	\N
2894	249	34	2	12324	\N	0	\N	\N	0	1	2	f	12324	\N	\N
2895	173	34	2	11266	\N	0	\N	\N	0	1	2	f	11266	\N	\N
2896	60	34	2	4971	\N	0	\N	\N	0	1	2	f	4971	\N	\N
2897	234	34	2	3777	\N	0	\N	\N	0	1	2	f	3777	\N	\N
2898	110	34	2	2971	\N	0	\N	\N	0	1	2	f	2971	\N	\N
2899	222	34	2	2953	\N	0	\N	\N	0	1	2	f	2953	\N	\N
2900	32	34	2	2499	\N	0	\N	\N	0	1	2	f	2499	\N	\N
2901	68	34	2	1887	\N	0	\N	\N	0	1	2	f	1887	\N	\N
2902	261	34	2	1870	\N	0	\N	\N	0	1	2	f	1870	\N	\N
2903	37	34	2	1270	\N	0	\N	\N	0	1	2	f	1270	\N	\N
2904	59	34	2	1181	\N	0	\N	\N	0	1	2	f	1181	\N	\N
2905	23	34	2	1078	\N	0	\N	\N	0	1	2	f	1078	\N	\N
2906	176	34	2	870	\N	0	\N	\N	0	1	2	f	870	\N	\N
2907	208	34	2	705	\N	0	\N	\N	0	1	2	f	705	\N	\N
2908	88	34	2	610	\N	0	\N	\N	0	1	2	f	610	\N	\N
2909	120	34	2	588	\N	0	\N	\N	0	1	2	f	588	\N	\N
2910	35	34	2	553	\N	0	\N	\N	0	1	2	f	553	\N	\N
2911	179	34	2	539	\N	0	\N	\N	0	1	2	f	539	\N	\N
2912	284	34	2	530	\N	0	\N	\N	0	1	2	f	530	\N	\N
2913	77	34	2	501	\N	0	\N	\N	0	1	2	f	501	\N	\N
2914	136	34	2	432	\N	0	\N	\N	0	1	2	f	432	\N	\N
2915	168	34	2	398	\N	0	\N	\N	0	1	2	f	398	\N	\N
2916	86	34	2	393	\N	0	\N	\N	0	1	2	f	393	\N	\N
2917	134	34	2	376	\N	0	\N	\N	0	1	2	f	376	\N	\N
2918	10	34	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
2919	118	34	2	327	\N	0	\N	\N	0	1	2	f	327	\N	\N
2920	46	34	2	309	\N	0	\N	\N	0	1	2	f	309	\N	\N
2921	61	34	2	287	\N	0	\N	\N	0	1	2	f	287	\N	\N
2922	256	34	2	278	\N	0	\N	\N	0	1	2	f	278	\N	\N
2923	201	34	2	263	\N	0	\N	\N	0	1	2	f	263	\N	\N
2924	157	34	2	238	\N	0	\N	\N	0	1	2	f	238	\N	\N
2925	224	34	2	232	\N	0	\N	\N	0	1	2	f	232	\N	\N
2926	152	34	2	219	\N	0	\N	\N	0	1	2	f	219	\N	\N
2927	170	34	2	216	\N	0	\N	\N	0	1	2	f	216	\N	\N
2928	115	34	2	209	\N	0	\N	\N	0	1	2	f	209	\N	\N
2929	254	34	2	201	\N	0	\N	\N	0	1	2	f	201	\N	\N
2930	257	34	2	196	\N	0	\N	\N	0	1	2	f	196	\N	\N
2931	123	34	2	194	\N	0	\N	\N	0	1	2	f	194	\N	\N
2932	113	34	2	193	\N	0	\N	\N	0	1	2	f	193	\N	\N
2933	169	34	2	182	\N	0	\N	\N	0	1	2	f	182	\N	\N
2934	48	34	2	175	\N	0	\N	\N	0	1	2	f	175	\N	\N
2935	73	34	2	172	\N	0	\N	\N	0	1	2	f	172	\N	\N
2936	231	34	2	169	\N	0	\N	\N	0	1	2	f	169	\N	\N
2937	65	34	2	162	\N	0	\N	\N	0	1	2	f	162	\N	\N
2938	122	34	2	152	\N	0	\N	\N	0	1	2	f	152	\N	\N
2939	186	34	2	150	\N	0	\N	\N	0	1	2	f	150	\N	\N
2940	83	34	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
2941	223	34	2	130	\N	0	\N	\N	0	1	2	f	130	\N	\N
2942	167	34	2	125	\N	0	\N	\N	0	1	2	f	125	\N	\N
2943	288	34	2	122	\N	0	\N	\N	0	1	2	f	122	\N	\N
2944	142	34	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
2945	66	34	2	114	\N	0	\N	\N	0	1	2	f	114	\N	\N
2946	36	34	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
2947	227	34	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
2948	63	34	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
2949	218	34	2	100	\N	0	\N	\N	0	1	2	f	100	\N	\N
2950	255	34	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
2951	237	34	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
2952	117	34	2	92	\N	0	\N	\N	0	1	2	f	92	\N	\N
2953	180	34	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
2954	31	34	2	89	\N	0	\N	\N	0	1	2	f	89	\N	\N
2955	67	34	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
2956	44	34	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
2957	20	34	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
2958	45	34	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
2959	129	34	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
2960	246	34	2	66	\N	0	\N	\N	0	1	2	f	66	\N	\N
2961	220	34	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2962	271	34	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
2963	177	34	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
2964	207	34	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
2965	155	34	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2966	178	34	2	47	\N	0	\N	\N	0	1	2	f	47	\N	\N
2967	199	34	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
2968	272	34	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
2969	11	34	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
2970	195	34	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
2971	112	34	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
2972	18	34	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
2973	276	34	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
2974	39	34	2	30	\N	0	\N	\N	0	1	2	f	30	\N	\N
2975	275	34	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2976	108	34	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
2977	75	34	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
2978	185	34	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
2979	102	34	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
2980	280	34	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
2981	58	34	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2982	153	34	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2983	29	34	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2984	43	34	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
2985	183	34	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2986	42	34	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
2987	114	34	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2988	247	34	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2989	24	34	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2990	273	34	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2991	172	34	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2992	229	34	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2993	9	34	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2994	238	34	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2995	19	34	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2996	17	34	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2997	6	34	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2998	197	34	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2999	40	34	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3000	198	34	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3001	253	34	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3002	151	34	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3003	165	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3004	137	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3005	274	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3006	25	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3007	13	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3008	92	34	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3009	140	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3010	12	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3011	34	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3012	281	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3013	125	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3014	278	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3015	252	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3016	290	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3017	210	34	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3018	148	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3019	202	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3020	80	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3021	230	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3022	82	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3023	219	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3024	49	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3025	126	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3026	133	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3027	205	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3028	71	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3029	182	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3030	105	34	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3031	128	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3032	5	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3033	233	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3034	119	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3035	282	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3036	127	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3037	279	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3038	147	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3039	72	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3040	87	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3041	78	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3042	206	34	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3043	47	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3044	74	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3045	146	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3046	242	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3047	89	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3048	209	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3049	154	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3050	8	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3051	150	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3052	90	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3053	84	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3054	16	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3055	104	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3056	141	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3057	143	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3058	57	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3059	56	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3060	175	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3061	156	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3062	258	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3063	236	34	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3064	70	35	2	1546	\N	0	\N	\N	1	1	2	f	1546	\N	\N
3065	54	36	2	142	\N	0	\N	\N	1	1	2	f	142	\N	\N
3066	145	36	2	135	\N	0	\N	\N	2	1	2	f	135	\N	\N
3067	110	36	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
3068	262	36	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
3069	43	36	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
3070	273	36	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
3071	227	36	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
3072	23	36	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
3073	45	36	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
3074	139	36	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3075	70	37	2	1546	\N	1546	\N	\N	1	1	2	f	0	217	\N
3076	217	37	1	1546	\N	1546	\N	\N	1	1	2	f	\N	70	\N
3077	111	38	2	11860138	\N	0	\N	\N	1	1	2	f	11860138	\N	\N
3078	251	38	2	5505760	\N	0	\N	\N	2	1	2	f	5505760	\N	\N
3079	109	38	2	5024548	\N	0	\N	\N	3	1	2	f	5024548	\N	\N
3080	54	38	2	3531446	\N	0	\N	\N	4	1	2	f	3531446	\N	\N
3081	55	38	2	2431639	\N	0	\N	\N	5	1	2	f	2431639	\N	\N
3082	145	38	2	1335311	\N	0	\N	\N	6	1	2	f	1335311	\N	\N
3083	33	38	2	1333933	\N	0	\N	\N	7	1	2	f	1333933	\N	\N
3084	139	38	2	732134	\N	0	\N	\N	8	1	2	f	732134	\N	\N
3085	91	38	2	128277	\N	0	\N	\N	9	1	2	f	128277	\N	\N
3086	70	38	2	1546	\N	0	\N	\N	10	1	2	f	1546	\N	\N
3087	217	38	2	297	\N	0	\N	\N	11	1	2	f	297	\N	\N
3088	164	38	2	1	\N	0	\N	\N	12	1	2	f	1	\N	\N
3089	149	38	2	9073211	\N	0	\N	\N	0	1	2	f	9073211	\N	\N
3090	255	38	2	1886445	\N	0	\N	\N	0	1	2	f	1886445	\N	\N
3091	209	38	2	1536819	\N	0	\N	\N	0	1	2	f	1536819	\N	\N
3092	210	38	2	1365903	\N	0	\N	\N	0	1	2	f	1365903	\N	\N
3093	126	38	2	1274328	\N	0	\N	\N	0	1	2	f	1274328	\N	\N
3094	282	38	2	1084526	\N	0	\N	\N	0	1	2	f	1084526	\N	\N
3095	37	38	2	776340	\N	0	\N	\N	0	1	2	f	776340	\N	\N
3096	249	38	2	577921	\N	0	\N	\N	0	1	2	f	577921	\N	\N
3097	242	38	2	516127	\N	0	\N	\N	0	1	2	f	516127	\N	\N
3098	118	38	2	425806	\N	0	\N	\N	0	1	2	f	425806	\N	\N
3099	278	38	2	416750	\N	0	\N	\N	0	1	2	f	416750	\N	\N
3100	112	38	2	395039	\N	0	\N	\N	0	1	2	f	395039	\N	\N
3101	195	38	2	299291	\N	0	\N	\N	0	1	2	f	299291	\N	\N
3102	6	38	2	298288	\N	0	\N	\N	0	1	2	f	298288	\N	\N
3103	222	38	2	277273	\N	0	\N	\N	0	1	2	f	277273	\N	\N
3104	90	38	2	249849	\N	0	\N	\N	0	1	2	f	249849	\N	\N
3105	136	38	2	234723	\N	0	\N	\N	0	1	2	f	234723	\N	\N
3106	119	38	2	233486	\N	0	\N	\N	0	1	2	f	233486	\N	\N
3107	21	38	2	230353	\N	0	\N	\N	0	1	2	f	230353	\N	\N
3108	234	38	2	216008	\N	0	\N	\N	0	1	2	f	216008	\N	\N
3109	76	38	2	213569	\N	0	\N	\N	0	1	2	f	213569	\N	\N
3110	180	38	2	204384	\N	0	\N	\N	0	1	2	f	204384	\N	\N
3111	208	38	2	194644	\N	0	\N	\N	0	1	2	f	194644	\N	\N
3112	237	38	2	175997	\N	0	\N	\N	0	1	2	f	175997	\N	\N
3113	72	38	2	168348	\N	0	\N	\N	0	1	2	f	168348	\N	\N
3114	197	38	2	166396	\N	0	\N	\N	0	1	2	f	166396	\N	\N
3115	173	38	2	152050	\N	0	\N	\N	0	1	2	f	152050	\N	\N
3116	225	38	2	149963	\N	0	\N	\N	0	1	2	f	149963	\N	\N
3117	46	38	2	144766	\N	0	\N	\N	0	1	2	f	144766	\N	\N
3118	74	38	2	133128	\N	0	\N	\N	0	1	2	f	133128	\N	\N
3119	236	38	2	132884	\N	0	\N	\N	0	1	2	f	132884	\N	\N
3120	8	38	2	130431	\N	0	\N	\N	0	1	2	f	130431	\N	\N
3121	48	38	2	122303	\N	0	\N	\N	0	1	2	f	122303	\N	\N
3122	83	38	2	119880	\N	0	\N	\N	0	1	2	f	119880	\N	\N
3123	224	38	2	118677	\N	0	\N	\N	0	1	2	f	118677	\N	\N
3124	133	38	2	118231	\N	0	\N	\N	0	1	2	f	118231	\N	\N
3125	61	38	2	118133	\N	0	\N	\N	0	1	2	f	118133	\N	\N
3126	159	38	2	109736	\N	0	\N	\N	0	1	2	f	109736	\N	\N
3127	179	38	2	106815	\N	0	\N	\N	0	1	2	f	106815	\N	\N
3128	261	38	2	106699	\N	0	\N	\N	0	1	2	f	106699	\N	\N
3129	32	38	2	102843	\N	0	\N	\N	0	1	2	f	102843	\N	\N
3130	114	38	2	102440	\N	0	\N	\N	0	1	2	f	102440	\N	\N
3131	219	38	2	101219	\N	0	\N	\N	0	1	2	f	101219	\N	\N
3132	279	38	2	101189	\N	0	\N	\N	0	1	2	f	101189	\N	\N
3133	169	38	2	100842	\N	0	\N	\N	0	1	2	f	100842	\N	\N
3134	13	38	2	97396	\N	0	\N	\N	0	1	2	f	97396	\N	\N
3135	68	38	2	95263	\N	0	\N	\N	0	1	2	f	95263	\N	\N
3136	11	38	2	93009	\N	0	\N	\N	0	1	2	f	93009	\N	\N
3137	188	38	2	92140	\N	0	\N	\N	0	1	2	f	92140	\N	\N
3138	120	38	2	90415	\N	0	\N	\N	0	1	2	f	90415	\N	\N
3139	107	38	2	88719	\N	0	\N	\N	0	1	2	f	88719	\N	\N
3140	143	38	2	84921	\N	0	\N	\N	0	1	2	f	84921	\N	\N
3141	24	38	2	84294	\N	0	\N	\N	0	1	2	f	84294	\N	\N
3142	229	38	2	75643	\N	0	\N	\N	0	1	2	f	75643	\N	\N
3143	168	38	2	70681	\N	0	\N	\N	0	1	2	f	70681	\N	\N
3144	49	38	2	70648	\N	0	\N	\N	0	1	2	f	70648	\N	\N
3145	198	38	2	62934	\N	0	\N	\N	0	1	2	f	62934	\N	\N
3146	280	38	2	61891	\N	0	\N	\N	0	1	2	f	61891	\N	\N
3147	171	38	2	61584	\N	0	\N	\N	0	1	2	f	61584	\N	\N
3148	103	38	2	61297	\N	0	\N	\N	0	1	2	f	61297	\N	\N
3149	283	38	2	60982	\N	0	\N	\N	0	1	2	f	60982	\N	\N
3150	65	38	2	57962	\N	0	\N	\N	0	1	2	f	57962	\N	\N
3151	60	38	2	57734	\N	0	\N	\N	0	1	2	f	57734	\N	\N
3152	135	38	2	55336	\N	0	\N	\N	0	1	2	f	55336	\N	\N
3153	113	38	2	53833	\N	0	\N	\N	0	1	2	f	53833	\N	\N
3154	79	38	2	53197	\N	0	\N	\N	0	1	2	f	53197	\N	\N
3155	59	38	2	52637	\N	0	\N	\N	0	1	2	f	52637	\N	\N
3156	202	38	2	52566	\N	0	\N	\N	0	1	2	f	52566	\N	\N
3157	166	38	2	48820	\N	0	\N	\N	0	1	2	f	48820	\N	\N
3158	206	38	2	48679	\N	0	\N	\N	0	1	2	f	48679	\N	\N
3159	23	38	2	47276	\N	0	\N	\N	0	1	2	f	47276	\N	\N
3160	153	38	2	46275	\N	0	\N	\N	0	1	2	f	46275	\N	\N
3161	115	38	2	45818	\N	0	\N	\N	0	1	2	f	45818	\N	\N
3162	250	38	2	45334	\N	0	\N	\N	0	1	2	f	45334	\N	\N
3163	271	38	2	43740	\N	0	\N	\N	0	1	2	f	43740	\N	\N
3164	144	38	2	42152	\N	0	\N	\N	0	1	2	f	42152	\N	\N
3165	227	38	2	41946	\N	0	\N	\N	0	1	2	f	41946	\N	\N
3166	73	38	2	41761	\N	0	\N	\N	0	1	2	f	41761	\N	\N
3167	235	38	2	41427	\N	0	\N	\N	0	1	2	f	41427	\N	\N
3168	155	38	2	39990	\N	0	\N	\N	0	1	2	f	39990	\N	\N
3169	200	38	2	36909	\N	0	\N	\N	0	1	2	f	36909	\N	\N
3170	199	38	2	36695	\N	0	\N	\N	0	1	2	f	36695	\N	\N
3171	82	38	2	36064	\N	0	\N	\N	0	1	2	f	36064	\N	\N
3172	201	38	2	35675	\N	0	\N	\N	0	1	2	f	35675	\N	\N
3173	260	38	2	34518	\N	0	\N	\N	0	1	2	f	34518	\N	\N
3174	172	38	2	32842	\N	0	\N	\N	0	1	2	f	32842	\N	\N
3175	207	38	2	31806	\N	0	\N	\N	0	1	2	f	31806	\N	\N
3176	86	38	2	31434	\N	0	\N	\N	0	1	2	f	31434	\N	\N
3177	122	38	2	31274	\N	0	\N	\N	0	1	2	f	31274	\N	\N
3178	154	38	2	30976	\N	0	\N	\N	0	1	2	f	30976	\N	\N
3179	75	38	2	29766	\N	0	\N	\N	0	1	2	f	29766	\N	\N
3180	20	38	2	29737	\N	0	\N	\N	0	1	2	f	29737	\N	\N
3181	134	38	2	29436	\N	0	\N	\N	0	1	2	f	29436	\N	\N
3182	41	38	2	29237	\N	0	\N	\N	0	1	2	f	29237	\N	\N
3183	170	38	2	28612	\N	0	\N	\N	0	1	2	f	28612	\N	\N
3184	248	38	2	27682	\N	0	\N	\N	0	1	2	f	27682	\N	\N
3185	276	38	2	27405	\N	0	\N	\N	0	1	2	f	27405	\N	\N
3186	254	38	2	27254	\N	0	\N	\N	0	1	2	f	27254	\N	\N
3187	167	38	2	26623	\N	0	\N	\N	0	1	2	f	26623	\N	\N
3188	178	38	2	26123	\N	0	\N	\N	0	1	2	f	26123	\N	\N
3189	31	38	2	25985	\N	0	\N	\N	0	1	2	f	25985	\N	\N
3190	157	38	2	25838	\N	0	\N	\N	0	1	2	f	25838	\N	\N
3191	284	38	2	25758	\N	0	\N	\N	0	1	2	f	25758	\N	\N
3192	187	38	2	25585	\N	0	\N	\N	0	1	2	f	25585	\N	\N
3193	272	38	2	24752	\N	0	\N	\N	0	1	2	f	24752	\N	\N
3194	175	38	2	24714	\N	0	\N	\N	0	1	2	f	24714	\N	\N
3195	152	38	2	24163	\N	0	\N	\N	0	1	2	f	24163	\N	\N
3196	89	38	2	24136	\N	0	\N	\N	0	1	2	f	24136	\N	\N
3197	22	38	2	24026	\N	0	\N	\N	0	1	2	f	24026	\N	\N
3198	281	38	2	23973	\N	0	\N	\N	0	1	2	f	23973	\N	\N
3199	253	38	2	23390	\N	0	\N	\N	0	1	2	f	23390	\N	\N
3200	66	38	2	23274	\N	0	\N	\N	0	1	2	f	23274	\N	\N
3201	156	38	2	23122	\N	0	\N	\N	0	1	2	f	23122	\N	\N
3202	256	38	2	23115	\N	0	\N	\N	0	1	2	f	23115	\N	\N
3203	151	38	2	22303	\N	0	\N	\N	0	1	2	f	22303	\N	\N
3204	141	38	2	21589	\N	0	\N	\N	0	1	2	f	21589	\N	\N
3205	110	38	2	20320	\N	0	\N	\N	0	1	2	f	20320	\N	\N
3206	247	38	2	19450	\N	0	\N	\N	0	1	2	f	19450	\N	\N
3207	246	38	2	19115	\N	0	\N	\N	0	1	2	f	19115	\N	\N
3208	108	38	2	19081	\N	0	\N	\N	0	1	2	f	19081	\N	\N
3209	123	38	2	18025	\N	0	\N	\N	0	1	2	f	18025	\N	\N
3210	19	38	2	17634	\N	0	\N	\N	0	1	2	f	17634	\N	\N
3211	177	38	2	17538	\N	0	\N	\N	0	1	2	f	17538	\N	\N
3212	194	38	2	17063	\N	0	\N	\N	0	1	2	f	17063	\N	\N
3213	138	38	2	17029	\N	0	\N	\N	0	1	2	f	17029	\N	\N
3214	35	38	2	16522	\N	0	\N	\N	0	1	2	f	16522	\N	\N
3215	142	38	2	16140	\N	0	\N	\N	0	1	2	f	16140	\N	\N
3216	36	38	2	15775	\N	0	\N	\N	0	1	2	f	15775	\N	\N
3217	106	38	2	15587	\N	0	\N	\N	0	1	2	f	15587	\N	\N
3218	45	38	2	14886	\N	0	\N	\N	0	1	2	f	14886	\N	\N
3219	238	38	2	14799	\N	0	\N	\N	0	1	2	f	14799	\N	\N
3220	273	38	2	14780	\N	0	\N	\N	0	1	2	f	14780	\N	\N
3221	218	38	2	14547	\N	0	\N	\N	0	1	2	f	14547	\N	\N
3222	147	38	2	14001	\N	0	\N	\N	0	1	2	f	14001	\N	\N
3223	39	38	2	13660	\N	0	\N	\N	0	1	2	f	13660	\N	\N
3224	105	38	2	13371	\N	0	\N	\N	0	1	2	f	13371	\N	\N
3225	176	38	2	13075	\N	0	\N	\N	0	1	2	f	13075	\N	\N
3226	129	38	2	13057	\N	0	\N	\N	0	1	2	f	13057	\N	\N
3227	220	38	2	12743	\N	0	\N	\N	0	1	2	f	12743	\N	\N
3228	77	38	2	12544	\N	0	\N	\N	0	1	2	f	12544	\N	\N
3229	121	38	2	12361	\N	0	\N	\N	0	1	2	f	12361	\N	\N
3230	186	38	2	12070	\N	0	\N	\N	0	1	2	f	12070	\N	\N
3231	231	38	2	11865	\N	0	\N	\N	0	1	2	f	11865	\N	\N
3232	18	38	2	11664	\N	0	\N	\N	0	1	2	f	11664	\N	\N
3233	63	38	2	11556	\N	0	\N	\N	0	1	2	f	11556	\N	\N
3234	183	38	2	11405	\N	0	\N	\N	0	1	2	f	11405	\N	\N
3235	102	38	2	11093	\N	0	\N	\N	0	1	2	f	11093	\N	\N
3236	85	38	2	10878	\N	0	\N	\N	0	1	2	f	10878	\N	\N
3237	290	38	2	10843	\N	0	\N	\N	0	1	2	f	10843	\N	\N
3238	117	38	2	10560	\N	0	\N	\N	0	1	2	f	10560	\N	\N
3239	67	38	2	9260	\N	0	\N	\N	0	1	2	f	9260	\N	\N
3240	29	38	2	9103	\N	0	\N	\N	0	1	2	f	9103	\N	\N
3241	226	38	2	8813	\N	0	\N	\N	0	1	2	f	8813	\N	\N
3242	257	38	2	8550	\N	0	\N	\N	0	1	2	f	8550	\N	\N
3243	3	38	2	8526	\N	0	\N	\N	0	1	2	f	8526	\N	\N
3244	150	38	2	8512	\N	0	\N	\N	0	1	2	f	8512	\N	\N
3245	137	38	2	8442	\N	0	\N	\N	0	1	2	f	8442	\N	\N
3246	174	38	2	8429	\N	0	\N	\N	0	1	2	f	8429	\N	\N
3247	10	38	2	8380	\N	0	\N	\N	0	1	2	f	8380	\N	\N
3248	88	38	2	8377	\N	0	\N	\N	0	1	2	f	8377	\N	\N
3249	228	38	2	8192	\N	0	\N	\N	0	1	2	f	8192	\N	\N
3250	43	38	2	8171	\N	0	\N	\N	0	1	2	f	8171	\N	\N
3251	140	38	2	7913	\N	0	\N	\N	0	1	2	f	7913	\N	\N
3252	191	38	2	7553	\N	0	\N	\N	0	1	2	f	7553	\N	\N
3253	158	38	2	7503	\N	0	\N	\N	0	1	2	f	7503	\N	\N
3254	230	38	2	7275	\N	0	\N	\N	0	1	2	f	7275	\N	\N
3255	87	38	2	7268	\N	0	\N	\N	0	1	2	f	7268	\N	\N
3256	25	38	2	7251	\N	0	\N	\N	0	1	2	f	7251	\N	\N
3257	288	38	2	6886	\N	0	\N	\N	0	1	2	f	6886	\N	\N
3258	204	38	2	6876	\N	0	\N	\N	0	1	2	f	6876	\N	\N
3259	12	38	2	6583	\N	0	\N	\N	0	1	2	f	6583	\N	\N
3260	185	38	2	6419	\N	0	\N	\N	0	1	2	f	6419	\N	\N
3261	125	38	2	6370	\N	0	\N	\N	0	1	2	f	6370	\N	\N
3262	92	38	2	6345	\N	0	\N	\N	0	1	2	f	6345	\N	\N
3263	232	38	2	6114	\N	0	\N	\N	0	1	2	f	6114	\N	\N
3264	17	38	2	6088	\N	0	\N	\N	0	1	2	f	6088	\N	\N
3265	233	38	2	5908	\N	0	\N	\N	0	1	2	f	5908	\N	\N
3266	252	38	2	5800	\N	0	\N	\N	0	1	2	f	5800	\N	\N
3267	165	38	2	5134	\N	0	\N	\N	0	1	2	f	5134	\N	\N
3268	7	38	2	4985	\N	0	\N	\N	0	1	2	f	4985	\N	\N
3269	44	38	2	4799	\N	0	\N	\N	0	1	2	f	4799	\N	\N
3270	42	38	2	4710	\N	0	\N	\N	0	1	2	f	4710	\N	\N
3271	274	38	2	4702	\N	0	\N	\N	0	1	2	f	4702	\N	\N
3272	277	38	2	4291	\N	0	\N	\N	0	1	2	f	4291	\N	\N
3273	275	38	2	3989	\N	0	\N	\N	0	1	2	f	3989	\N	\N
3274	57	38	2	3965	\N	0	\N	\N	0	1	2	f	3965	\N	\N
3275	62	38	2	3796	\N	0	\N	\N	0	1	2	f	3796	\N	\N
3276	56	38	2	3793	\N	0	\N	\N	0	1	2	f	3793	\N	\N
3277	81	38	2	3713	\N	0	\N	\N	0	1	2	f	3713	\N	\N
3278	47	38	2	3709	\N	0	\N	\N	0	1	2	f	3709	\N	\N
3279	205	38	2	3636	\N	0	\N	\N	0	1	2	f	3636	\N	\N
3280	221	38	2	3552	\N	0	\N	\N	0	1	2	f	3552	\N	\N
3281	30	38	2	3534	\N	0	\N	\N	0	1	2	f	3534	\N	\N
3282	34	38	2	3298	\N	0	\N	\N	0	1	2	f	3298	\N	\N
3283	148	38	2	2972	\N	0	\N	\N	0	1	2	f	2972	\N	\N
3284	40	38	2	2430	\N	0	\N	\N	0	1	2	f	2430	\N	\N
3285	223	38	2	2323	\N	0	\N	\N	0	1	2	f	2323	\N	\N
3286	9	38	2	2237	\N	0	\N	\N	0	1	2	f	2237	\N	\N
3287	78	38	2	2175	\N	0	\N	\N	0	1	2	f	2175	\N	\N
3288	38	38	2	2148	\N	0	\N	\N	0	1	2	f	2148	\N	\N
3289	93	38	2	2145	\N	0	\N	\N	0	1	2	f	2145	\N	\N
3290	146	38	2	2107	\N	0	\N	\N	0	1	2	f	2107	\N	\N
3291	80	38	2	2093	\N	0	\N	\N	0	1	2	f	2093	\N	\N
3292	15	38	2	2004	\N	0	\N	\N	0	1	2	f	2004	\N	\N
3293	58	38	2	1767	\N	0	\N	\N	0	1	2	f	1767	\N	\N
3294	269	38	2	1659	\N	0	\N	\N	0	1	2	f	1659	\N	\N
3295	289	38	2	1652	\N	0	\N	\N	0	1	2	f	1652	\N	\N
3296	84	38	2	1603	\N	0	\N	\N	0	1	2	f	1603	\N	\N
3297	104	38	2	1550	\N	0	\N	\N	0	1	2	f	1550	\N	\N
3298	244	38	2	1396	\N	0	\N	\N	0	1	2	f	1396	\N	\N
3299	241	38	2	1359	\N	0	\N	\N	0	1	2	f	1359	\N	\N
3300	127	38	2	1348	\N	0	\N	\N	0	1	2	f	1348	\N	\N
3301	101	38	2	1320	\N	0	\N	\N	0	1	2	f	1320	\N	\N
3302	258	38	2	1175	\N	0	\N	\N	0	1	2	f	1175	\N	\N
3303	64	38	2	1140	\N	0	\N	\N	0	1	2	f	1140	\N	\N
3304	116	38	2	1070	\N	0	\N	\N	0	1	2	f	1070	\N	\N
3305	287	38	2	1005	\N	0	\N	\N	0	1	2	f	1005	\N	\N
3306	192	38	2	871	\N	0	\N	\N	0	1	2	f	871	\N	\N
3307	285	38	2	800	\N	0	\N	\N	0	1	2	f	800	\N	\N
3308	184	38	2	730	\N	0	\N	\N	0	1	2	f	730	\N	\N
3309	182	38	2	677	\N	0	\N	\N	0	1	2	f	677	\N	\N
3310	262	38	2	652	\N	0	\N	\N	0	1	2	f	652	\N	\N
3311	71	38	2	632	\N	0	\N	\N	0	1	2	f	632	\N	\N
3312	14	38	2	627	\N	0	\N	\N	0	1	2	f	627	\N	\N
3313	124	38	2	595	\N	0	\N	\N	0	1	2	f	595	\N	\N
3314	51	38	2	547	\N	0	\N	\N	0	1	2	f	547	\N	\N
3315	16	38	2	490	\N	0	\N	\N	0	1	2	f	490	\N	\N
3316	5	38	2	486	\N	0	\N	\N	0	1	2	f	486	\N	\N
3317	163	38	2	446	\N	0	\N	\N	0	1	2	f	446	\N	\N
3318	52	38	2	444	\N	0	\N	\N	0	1	2	f	444	\N	\N
3319	128	38	2	423	\N	0	\N	\N	0	1	2	f	423	\N	\N
3320	214	38	2	409	\N	0	\N	\N	0	1	2	f	409	\N	\N
3321	212	38	2	344	\N	0	\N	\N	0	1	2	f	344	\N	\N
3322	203	38	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
3323	189	38	2	307	\N	0	\N	\N	0	1	2	f	307	\N	\N
3324	196	38	2	305	\N	0	\N	\N	0	1	2	f	305	\N	\N
3325	286	38	2	261	\N	0	\N	\N	0	1	2	f	261	\N	\N
3326	245	38	2	256	\N	0	\N	\N	0	1	2	f	256	\N	\N
3327	4	38	2	229	\N	0	\N	\N	0	1	2	f	229	\N	\N
3328	193	38	2	221	\N	0	\N	\N	0	1	2	f	221	\N	\N
3329	243	38	2	194	\N	0	\N	\N	0	1	2	f	194	\N	\N
3330	131	38	2	179	\N	0	\N	\N	0	1	2	f	179	\N	\N
3331	99	38	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
3332	264	38	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
3333	190	38	2	139	\N	0	\N	\N	0	1	2	f	139	\N	\N
3334	97	38	2	118	\N	0	\N	\N	0	1	2	f	118	\N	\N
3335	95	38	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
3336	162	38	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
3337	181	38	2	69	\N	0	\N	\N	0	1	2	f	69	\N	\N
3338	263	38	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
3339	213	38	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
3340	160	38	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
3341	132	38	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
3342	259	38	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
3343	94	38	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
3344	26	38	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
3345	240	38	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
3346	266	38	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
3347	100	38	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
3348	268	38	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3349	53	38	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3350	211	38	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3351	161	38	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3352	130	38	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3353	215	38	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3354	267	38	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3355	50	38	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3356	27	38	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3357	239	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3358	69	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3359	1	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3360	265	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3361	2	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3362	98	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3363	28	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3364	96	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3365	270	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3366	216	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3367	145	39	2	1224	\N	0	\N	\N	1	1	2	f	1224	\N	\N
3368	111	39	2	1128	\N	0	\N	\N	2	1	2	f	1128	\N	\N
3369	33	39	2	550	\N	0	\N	\N	3	1	2	f	550	\N	\N
3370	54	39	2	191	\N	0	\N	\N	4	1	2	f	191	\N	\N
3371	91	39	2	104	\N	0	\N	\N	5	1	2	f	104	\N	\N
3372	6	39	2	54	\N	0	\N	\N	6	1	2	f	54	\N	\N
3373	139	39	2	27	\N	0	\N	\N	7	1	2	f	27	\N	\N
3374	135	39	2	23	\N	0	\N	\N	8	1	2	f	23	\N	\N
3375	149	39	2	1124	\N	0	\N	\N	0	1	2	f	1124	\N	\N
3376	32	39	2	374	\N	0	\N	\N	0	1	2	f	374	\N	\N
3377	229	39	2	340	\N	0	\N	\N	0	1	2	f	340	\N	\N
3378	249	39	2	171	\N	0	\N	\N	0	1	2	f	171	\N	\N
3379	262	39	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
3380	131	39	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
3381	104	39	2	96	\N	0	\N	\N	0	1	2	f	96	\N	\N
3382	206	39	2	80	\N	0	\N	\N	0	1	2	f	80	\N	\N
3383	43	39	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
3384	227	39	2	63	\N	0	\N	\N	0	1	2	f	63	\N	\N
3385	109	39	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
3386	37	39	2	54	\N	0	\N	\N	0	1	2	f	54	\N	\N
3387	273	39	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
3388	15	39	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3389	251	39	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
3390	23	39	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
3391	60	39	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
3392	45	39	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
3393	233	39	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3394	110	39	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3395	173	39	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3396	143	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3397	75	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3398	270	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3399	216	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3400	85	39	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3401	139	40	2	395	\N	0	\N	\N	1	1	2	f	395	\N	\N
3402	145	40	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
3403	111	41	2	11755093	\N	11755093	\N	\N	1	1	2	f	0	\N	\N
3404	109	41	2	4906175	\N	4906175	\N	\N	2	1	2	f	0	\N	\N
3405	251	41	2	4778258	\N	4778258	\N	\N	3	1	2	f	0	\N	\N
3406	54	41	2	3422334	\N	3422334	\N	\N	4	1	2	f	0	\N	\N
3407	55	41	2	2321111	\N	2321111	\N	\N	5	1	2	f	0	\N	\N
3408	145	41	2	1300926	\N	1300926	\N	\N	6	1	2	f	0	\N	\N
3409	33	41	2	1274707	\N	1274707	\N	\N	7	1	2	f	0	\N	\N
3410	139	41	2	709004	\N	709004	\N	\N	8	1	2	f	0	\N	\N
3411	91	41	2	125417	\N	125417	\N	\N	9	1	2	f	0	\N	\N
3412	70	41	2	1546	\N	1546	\N	\N	10	1	2	f	0	\N	\N
3413	149	41	2	9069125	\N	9069125	\N	\N	0	1	2	f	0	\N	\N
3414	255	41	2	1830201	\N	1830201	\N	\N	0	1	2	f	0	\N	\N
3415	209	41	2	1536812	\N	1536812	\N	\N	0	1	2	f	0	\N	\N
3416	126	41	2	1132543	\N	1132543	\N	\N	0	1	2	f	0	\N	\N
3417	282	41	2	978197	\N	978197	\N	\N	0	1	2	f	0	\N	\N
3418	210	41	2	977158	\N	977158	\N	\N	0	1	2	f	0	\N	\N
3419	37	41	2	754107	\N	754107	\N	\N	0	1	2	f	0	\N	\N
3420	249	41	2	549893	\N	549893	\N	\N	0	1	2	f	0	\N	\N
3421	242	41	2	441450	\N	441450	\N	\N	0	1	2	f	0	\N	\N
3422	118	41	2	418468	\N	418468	\N	\N	0	1	2	f	0	\N	\N
3423	278	41	2	405128	\N	405128	\N	\N	0	1	2	f	0	\N	\N
3424	112	41	2	378703	\N	378703	\N	\N	0	1	2	f	0	\N	\N
3425	195	41	2	298703	\N	298703	\N	\N	0	1	2	f	0	\N	\N
3426	6	41	2	297060	\N	297060	\N	\N	0	1	2	f	0	\N	\N
3427	222	41	2	251585	\N	251585	\N	\N	0	1	2	f	0	\N	\N
3428	90	41	2	247421	\N	247421	\N	\N	0	1	2	f	0	\N	\N
3429	119	41	2	233176	\N	233176	\N	\N	0	1	2	f	0	\N	\N
3430	136	41	2	220113	\N	220113	\N	\N	0	1	2	f	0	\N	\N
3431	21	41	2	217362	\N	217362	\N	\N	0	1	2	f	0	\N	\N
3432	76	41	2	213533	\N	213533	\N	\N	0	1	2	f	0	\N	\N
3433	234	41	2	203949	\N	203949	\N	\N	0	1	2	f	0	\N	\N
3434	180	41	2	190265	\N	190265	\N	\N	0	1	2	f	0	\N	\N
3435	208	41	2	178450	\N	178450	\N	\N	0	1	2	f	0	\N	\N
3436	237	41	2	169772	\N	169772	\N	\N	0	1	2	f	0	\N	\N
3437	72	41	2	168152	\N	168152	\N	\N	0	1	2	f	0	\N	\N
3438	197	41	2	166120	\N	166120	\N	\N	0	1	2	f	0	\N	\N
3439	225	41	2	149835	\N	149835	\N	\N	0	1	2	f	0	\N	\N
3440	173	41	2	143272	\N	143272	\N	\N	0	1	2	f	0	\N	\N
3441	46	41	2	139906	\N	139906	\N	\N	0	1	2	f	0	\N	\N
3442	74	41	2	132500	\N	132500	\N	\N	0	1	2	f	0	\N	\N
3443	236	41	2	128038	\N	128038	\N	\N	0	1	2	f	0	\N	\N
3444	48	41	2	122012	\N	122012	\N	\N	0	1	2	f	0	\N	\N
3445	61	41	2	115441	\N	115441	\N	\N	0	1	2	f	0	\N	\N
3446	133	41	2	114343	\N	114343	\N	\N	0	1	2	f	0	\N	\N
3447	83	41	2	113400	\N	113400	\N	\N	0	1	2	f	0	\N	\N
3448	159	41	2	109705	\N	109705	\N	\N	0	1	2	f	0	\N	\N
3449	261	41	2	104556	\N	104556	\N	\N	0	1	2	f	0	\N	\N
3450	179	41	2	104349	\N	104349	\N	\N	0	1	2	f	0	\N	\N
3451	114	41	2	99621	\N	99621	\N	\N	0	1	2	f	0	\N	\N
3452	32	41	2	99479	\N	99479	\N	\N	0	1	2	f	0	\N	\N
3453	219	41	2	96397	\N	96397	\N	\N	0	1	2	f	0	\N	\N
3454	68	41	2	95105	\N	95105	\N	\N	0	1	2	f	0	\N	\N
3455	11	41	2	92878	\N	92878	\N	\N	0	1	2	f	0	\N	\N
3456	13	41	2	91937	\N	91937	\N	\N	0	1	2	f	0	\N	\N
3457	279	41	2	91890	\N	91890	\N	\N	0	1	2	f	0	\N	\N
3458	224	41	2	91347	\N	91347	\N	\N	0	1	2	f	0	\N	\N
3459	120	41	2	90029	\N	90029	\N	\N	0	1	2	f	0	\N	\N
3460	107	41	2	88703	\N	88703	\N	\N	0	1	2	f	0	\N	\N
3461	143	41	2	84817	\N	84817	\N	\N	0	1	2	f	0	\N	\N
3462	24	41	2	83872	\N	83872	\N	\N	0	1	2	f	0	\N	\N
3463	8	41	2	81821	\N	81821	\N	\N	0	1	2	f	0	\N	\N
3464	188	41	2	76766	\N	76766	\N	\N	0	1	2	f	0	\N	\N
3465	169	41	2	73621	\N	73621	\N	\N	0	1	2	f	0	\N	\N
3466	168	41	2	68386	\N	68386	\N	\N	0	1	2	f	0	\N	\N
3467	229	41	2	66775	\N	66775	\N	\N	0	1	2	f	0	\N	\N
3468	49	41	2	65135	\N	65135	\N	\N	0	1	2	f	0	\N	\N
3469	280	41	2	61809	\N	61809	\N	\N	0	1	2	f	0	\N	\N
3470	171	41	2	61226	\N	61226	\N	\N	0	1	2	f	0	\N	\N
3471	103	41	2	60906	\N	60906	\N	\N	0	1	2	f	0	\N	\N
3472	283	41	2	60487	\N	60487	\N	\N	0	1	2	f	0	\N	\N
3473	198	41	2	59993	\N	59993	\N	\N	0	1	2	f	0	\N	\N
3474	65	41	2	56175	\N	56175	\N	\N	0	1	2	f	0	\N	\N
3475	135	41	2	54791	\N	54791	\N	\N	0	1	2	f	0	\N	\N
3476	60	41	2	54317	\N	54317	\N	\N	0	1	2	f	0	\N	\N
3477	113	41	2	53337	\N	53337	\N	\N	0	1	2	f	0	\N	\N
3478	79	41	2	53153	\N	53153	\N	\N	0	1	2	f	0	\N	\N
3479	202	41	2	51760	\N	51760	\N	\N	0	1	2	f	0	\N	\N
3480	59	41	2	51394	\N	51394	\N	\N	0	1	2	f	0	\N	\N
3481	206	41	2	48058	\N	48058	\N	\N	0	1	2	f	0	\N	\N
3482	166	41	2	48009	\N	48009	\N	\N	0	1	2	f	0	\N	\N
3483	250	41	2	45312	\N	45312	\N	\N	0	1	2	f	0	\N	\N
3484	23	41	2	44409	\N	44409	\N	\N	0	1	2	f	0	\N	\N
3485	153	41	2	43567	\N	43567	\N	\N	0	1	2	f	0	\N	\N
3486	271	41	2	43188	\N	43188	\N	\N	0	1	2	f	0	\N	\N
3487	73	41	2	40290	\N	40290	\N	\N	0	1	2	f	0	\N	\N
3488	115	41	2	39848	\N	39848	\N	\N	0	1	2	f	0	\N	\N
3489	144	41	2	39303	\N	39303	\N	\N	0	1	2	f	0	\N	\N
3490	155	41	2	39228	\N	39228	\N	\N	0	1	2	f	0	\N	\N
3491	235	41	2	38059	\N	38059	\N	\N	0	1	2	f	0	\N	\N
3492	227	41	2	36751	\N	36751	\N	\N	0	1	2	f	0	\N	\N
3493	199	41	2	35399	\N	35399	\N	\N	0	1	2	f	0	\N	\N
3494	200	41	2	34519	\N	34519	\N	\N	0	1	2	f	0	\N	\N
3495	201	41	2	34452	\N	34452	\N	\N	0	1	2	f	0	\N	\N
3496	260	41	2	34452	\N	34452	\N	\N	0	1	2	f	0	\N	\N
3497	82	41	2	31636	\N	31636	\N	\N	0	1	2	f	0	\N	\N
3498	207	41	2	30801	\N	30801	\N	\N	0	1	2	f	0	\N	\N
3499	122	41	2	30612	\N	30612	\N	\N	0	1	2	f	0	\N	\N
3500	172	41	2	30086	\N	30086	\N	\N	0	1	2	f	0	\N	\N
3501	41	41	2	29224	\N	29224	\N	\N	0	1	2	f	0	\N	\N
3502	20	41	2	28680	\N	28680	\N	\N	0	1	2	f	0	\N	\N
3503	86	41	2	28577	\N	28577	\N	\N	0	1	2	f	0	\N	\N
3504	75	41	2	27867	\N	27867	\N	\N	0	1	2	f	0	\N	\N
3505	248	41	2	27668	\N	27668	\N	\N	0	1	2	f	0	\N	\N
3506	134	41	2	27454	\N	27454	\N	\N	0	1	2	f	0	\N	\N
3507	170	41	2	27248	\N	27248	\N	\N	0	1	2	f	0	\N	\N
3508	154	41	2	26677	\N	26677	\N	\N	0	1	2	f	0	\N	\N
3509	276	41	2	26660	\N	26660	\N	\N	0	1	2	f	0	\N	\N
3510	254	41	2	25928	\N	25928	\N	\N	0	1	2	f	0	\N	\N
3511	31	41	2	25208	\N	25208	\N	\N	0	1	2	f	0	\N	\N
3512	178	41	2	25205	\N	25205	\N	\N	0	1	2	f	0	\N	\N
3513	272	41	2	24248	\N	24248	\N	\N	0	1	2	f	0	\N	\N
3514	167	41	2	24214	\N	24214	\N	\N	0	1	2	f	0	\N	\N
3515	89	41	2	24122	\N	24122	\N	\N	0	1	2	f	0	\N	\N
3516	157	41	2	24079	\N	24079	\N	\N	0	1	2	f	0	\N	\N
3517	175	41	2	23978	\N	23978	\N	\N	0	1	2	f	0	\N	\N
3518	22	41	2	23926	\N	23926	\N	\N	0	1	2	f	0	\N	\N
3519	187	41	2	23857	\N	23857	\N	\N	0	1	2	f	0	\N	\N
3520	281	41	2	23760	\N	23760	\N	\N	0	1	2	f	0	\N	\N
3521	152	41	2	23729	\N	23729	\N	\N	0	1	2	f	0	\N	\N
3522	253	41	2	22654	\N	22654	\N	\N	0	1	2	f	0	\N	\N
3523	151	41	2	21994	\N	21994	\N	\N	0	1	2	f	0	\N	\N
3524	66	41	2	21979	\N	21979	\N	\N	0	1	2	f	0	\N	\N
3525	256	41	2	21583	\N	21583	\N	\N	0	1	2	f	0	\N	\N
3526	141	41	2	21576	\N	21576	\N	\N	0	1	2	f	0	\N	\N
3527	284	41	2	20303	\N	20303	\N	\N	0	1	2	f	0	\N	\N
3528	110	41	2	18959	\N	18959	\N	\N	0	1	2	f	0	\N	\N
3529	108	41	2	18592	\N	18592	\N	\N	0	1	2	f	0	\N	\N
3530	247	41	2	18410	\N	18410	\N	\N	0	1	2	f	0	\N	\N
3531	246	41	2	17491	\N	17491	\N	\N	0	1	2	f	0	\N	\N
3532	177	41	2	17271	\N	17271	\N	\N	0	1	2	f	0	\N	\N
3533	138	41	2	16782	\N	16782	\N	\N	0	1	2	f	0	\N	\N
3534	123	41	2	16767	\N	16767	\N	\N	0	1	2	f	0	\N	\N
3535	19	41	2	16736	\N	16736	\N	\N	0	1	2	f	0	\N	\N
3536	194	41	2	16544	\N	16544	\N	\N	0	1	2	f	0	\N	\N
3537	35	41	2	15526	\N	15526	\N	\N	0	1	2	f	0	\N	\N
3538	106	41	2	15462	\N	15462	\N	\N	0	1	2	f	0	\N	\N
3539	142	41	2	15373	\N	15373	\N	\N	0	1	2	f	0	\N	\N
3540	36	41	2	14833	\N	14833	\N	\N	0	1	2	f	0	\N	\N
3541	238	41	2	14453	\N	14453	\N	\N	0	1	2	f	0	\N	\N
3542	218	41	2	14245	\N	14245	\N	\N	0	1	2	f	0	\N	\N
3543	273	41	2	14027	\N	14027	\N	\N	0	1	2	f	0	\N	\N
3544	45	41	2	13989	\N	13989	\N	\N	0	1	2	f	0	\N	\N
3545	147	41	2	13553	\N	13553	\N	\N	0	1	2	f	0	\N	\N
3546	39	41	2	13409	\N	13409	\N	\N	0	1	2	f	0	\N	\N
3547	105	41	2	13293	\N	13293	\N	\N	0	1	2	f	0	\N	\N
3548	77	41	2	12374	\N	12374	\N	\N	0	1	2	f	0	\N	\N
3549	121	41	2	12342	\N	12342	\N	\N	0	1	2	f	0	\N	\N
3550	220	41	2	12262	\N	12262	\N	\N	0	1	2	f	0	\N	\N
3551	186	41	2	11814	\N	11814	\N	\N	0	1	2	f	0	\N	\N
3552	129	41	2	11624	\N	11624	\N	\N	0	1	2	f	0	\N	\N
3553	176	41	2	11609	\N	11609	\N	\N	0	1	2	f	0	\N	\N
3554	231	41	2	11384	\N	11384	\N	\N	0	1	2	f	0	\N	\N
3555	18	41	2	11180	\N	11180	\N	\N	0	1	2	f	0	\N	\N
3556	63	41	2	11148	\N	11148	\N	\N	0	1	2	f	0	\N	\N
3557	183	41	2	10848	\N	10848	\N	\N	0	1	2	f	0	\N	\N
3558	290	41	2	10823	\N	10823	\N	\N	0	1	2	f	0	\N	\N
3559	102	41	2	10800	\N	10800	\N	\N	0	1	2	f	0	\N	\N
3560	85	41	2	10154	\N	10154	\N	\N	0	1	2	f	0	\N	\N
3561	117	41	2	9952	\N	9952	\N	\N	0	1	2	f	0	\N	\N
3562	67	41	2	9163	\N	9163	\N	\N	0	1	2	f	0	\N	\N
3563	29	41	2	9021	\N	9021	\N	\N	0	1	2	f	0	\N	\N
3564	226	41	2	8733	\N	8733	\N	\N	0	1	2	f	0	\N	\N
3565	156	41	2	8484	\N	8484	\N	\N	0	1	2	f	0	\N	\N
3566	174	41	2	8427	\N	8427	\N	\N	0	1	2	f	0	\N	\N
3567	137	41	2	8340	\N	8340	\N	\N	0	1	2	f	0	\N	\N
3568	10	41	2	8280	\N	8280	\N	\N	0	1	2	f	0	\N	\N
3569	257	41	2	8243	\N	8243	\N	\N	0	1	2	f	0	\N	\N
3570	88	41	2	8127	\N	8127	\N	\N	0	1	2	f	0	\N	\N
3571	140	41	2	7797	\N	7797	\N	\N	0	1	2	f	0	\N	\N
3572	228	41	2	7758	\N	7758	\N	\N	0	1	2	f	0	\N	\N
3573	191	41	2	7512	\N	7512	\N	\N	0	1	2	f	0	\N	\N
3574	158	41	2	7287	\N	7287	\N	\N	0	1	2	f	0	\N	\N
3575	43	41	2	7281	\N	7281	\N	\N	0	1	2	f	0	\N	\N
3576	230	41	2	7258	\N	7258	\N	\N	0	1	2	f	0	\N	\N
3577	87	41	2	7053	\N	7053	\N	\N	0	1	2	f	0	\N	\N
3578	25	41	2	7010	\N	7010	\N	\N	0	1	2	f	0	\N	\N
3579	204	41	2	6865	\N	6865	\N	\N	0	1	2	f	0	\N	\N
3580	288	41	2	6514	\N	6514	\N	\N	0	1	2	f	0	\N	\N
3581	125	41	2	6322	\N	6322	\N	\N	0	1	2	f	0	\N	\N
3582	12	41	2	6275	\N	6275	\N	\N	0	1	2	f	0	\N	\N
3583	92	41	2	6256	\N	6256	\N	\N	0	1	2	f	0	\N	\N
3584	185	41	2	6076	\N	6076	\N	\N	0	1	2	f	0	\N	\N
3585	17	41	2	5856	\N	5856	\N	\N	0	1	2	f	0	\N	\N
3586	233	41	2	5771	\N	5771	\N	\N	0	1	2	f	0	\N	\N
3587	252	41	2	5712	\N	5712	\N	\N	0	1	2	f	0	\N	\N
3588	150	41	2	5373	\N	5373	\N	\N	0	1	2	f	0	\N	\N
3589	165	41	2	5067	\N	5067	\N	\N	0	1	2	f	0	\N	\N
3590	7	41	2	4961	\N	4961	\N	\N	0	1	2	f	0	\N	\N
3591	44	41	2	4774	\N	4774	\N	\N	0	1	2	f	0	\N	\N
3592	232	41	2	4583	\N	4583	\N	\N	0	1	2	f	0	\N	\N
3593	42	41	2	4380	\N	4380	\N	\N	0	1	2	f	0	\N	\N
3594	274	41	2	4322	\N	4322	\N	\N	0	1	2	f	0	\N	\N
3595	277	41	2	4291	\N	4291	\N	\N	0	1	2	f	0	\N	\N
3596	57	41	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
3597	62	41	2	3793	\N	3793	\N	\N	0	1	2	f	0	\N	\N
3598	275	41	2	3759	\N	3759	\N	\N	0	1	2	f	0	\N	\N
3599	56	41	2	3731	\N	3731	\N	\N	0	1	2	f	0	\N	\N
3600	47	41	2	3664	\N	3664	\N	\N	0	1	2	f	0	\N	\N
3601	205	41	2	3604	\N	3604	\N	\N	0	1	2	f	0	\N	\N
3602	221	41	2	3540	\N	3540	\N	\N	0	1	2	f	0	\N	\N
3603	30	41	2	3502	\N	3502	\N	\N	0	1	2	f	0	\N	\N
3604	81	41	2	3439	\N	3439	\N	\N	0	1	2	f	0	\N	\N
3605	34	41	2	3161	\N	3161	\N	\N	0	1	2	f	0	\N	\N
3606	3	41	2	2958	\N	2958	\N	\N	0	1	2	f	0	\N	\N
3607	148	41	2	2921	\N	2921	\N	\N	0	1	2	f	0	\N	\N
3608	223	41	2	2277	\N	2277	\N	\N	0	1	2	f	0	\N	\N
3609	40	41	2	2277	\N	2277	\N	\N	0	1	2	f	0	\N	\N
3610	93	41	2	2144	\N	2144	\N	\N	0	1	2	f	0	\N	\N
3611	38	41	2	2133	\N	2133	\N	\N	0	1	2	f	0	\N	\N
3612	146	41	2	2102	\N	2102	\N	\N	0	1	2	f	0	\N	\N
3613	9	41	2	2099	\N	2099	\N	\N	0	1	2	f	0	\N	\N
3614	80	41	2	2050	\N	2050	\N	\N	0	1	2	f	0	\N	\N
3615	15	41	2	1966	\N	1966	\N	\N	0	1	2	f	0	\N	\N
3616	78	41	2	1955	\N	1955	\N	\N	0	1	2	f	0	\N	\N
3617	58	41	2	1738	\N	1738	\N	\N	0	1	2	f	0	\N	\N
3618	289	41	2	1651	\N	1651	\N	\N	0	1	2	f	0	\N	\N
3619	269	41	2	1650	\N	1650	\N	\N	0	1	2	f	0	\N	\N
3620	84	41	2	1530	\N	1530	\N	\N	0	1	2	f	0	\N	\N
3621	104	41	2	1509	\N	1509	\N	\N	0	1	2	f	0	\N	\N
3622	127	41	2	1337	\N	1337	\N	\N	0	1	2	f	0	\N	\N
3623	101	41	2	1320	\N	1320	\N	\N	0	1	2	f	0	\N	\N
3624	241	41	2	1309	\N	1309	\N	\N	0	1	2	f	0	\N	\N
3625	244	41	2	1303	\N	1303	\N	\N	0	1	2	f	0	\N	\N
3626	258	41	2	1166	\N	1166	\N	\N	0	1	2	f	0	\N	\N
3627	64	41	2	1135	\N	1135	\N	\N	0	1	2	f	0	\N	\N
3628	116	41	2	1069	\N	1069	\N	\N	0	1	2	f	0	\N	\N
3629	287	41	2	992	\N	992	\N	\N	0	1	2	f	0	\N	\N
3630	192	41	2	864	\N	864	\N	\N	0	1	2	f	0	\N	\N
3631	285	41	2	799	\N	799	\N	\N	0	1	2	f	0	\N	\N
3632	184	41	2	707	\N	707	\N	\N	0	1	2	f	0	\N	\N
3633	182	41	2	660	\N	660	\N	\N	0	1	2	f	0	\N	\N
3634	71	41	2	597	\N	597	\N	\N	0	1	2	f	0	\N	\N
3635	124	41	2	588	\N	588	\N	\N	0	1	2	f	0	\N	\N
3636	51	41	2	541	\N	541	\N	\N	0	1	2	f	0	\N	\N
3637	5	41	2	484	\N	484	\N	\N	0	1	2	f	0	\N	\N
3638	16	41	2	478	\N	478	\N	\N	0	1	2	f	0	\N	\N
3639	163	41	2	446	\N	446	\N	\N	0	1	2	f	0	\N	\N
3640	52	41	2	434	\N	434	\N	\N	0	1	2	f	0	\N	\N
3641	128	41	2	419	\N	419	\N	\N	0	1	2	f	0	\N	\N
3642	262	41	2	405	\N	405	\N	\N	0	1	2	f	0	\N	\N
3643	214	41	2	398	\N	398	\N	\N	0	1	2	f	0	\N	\N
3644	14	41	2	362	\N	362	\N	\N	0	1	2	f	0	\N	\N
3645	131	41	2	346	\N	346	\N	\N	0	1	2	f	0	\N	\N
3646	212	41	2	325	\N	325	\N	\N	0	1	2	f	0	\N	\N
3647	203	41	2	308	\N	308	\N	\N	0	1	2	f	0	\N	\N
3648	189	41	2	307	\N	307	\N	\N	0	1	2	f	0	\N	\N
3649	196	41	2	301	\N	301	\N	\N	0	1	2	f	0	\N	\N
3650	286	41	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
3651	4	41	2	227	\N	227	\N	\N	0	1	2	f	0	\N	\N
3652	193	41	2	221	\N	221	\N	\N	0	1	2	f	0	\N	\N
3653	245	41	2	212	\N	212	\N	\N	0	1	2	f	0	\N	\N
3654	243	41	2	194	\N	194	\N	\N	0	1	2	f	0	\N	\N
3655	99	41	2	166	\N	166	\N	\N	0	1	2	f	0	\N	\N
3656	264	41	2	133	\N	133	\N	\N	0	1	2	f	0	\N	\N
3657	190	41	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
3658	97	41	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
3659	95	41	2	105	\N	105	\N	\N	0	1	2	f	0	\N	\N
3660	162	41	2	77	\N	77	\N	\N	0	1	2	f	0	\N	\N
3661	181	41	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
3662	263	41	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
3663	160	41	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
3664	213	41	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
3665	132	41	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
3666	259	41	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
3667	94	41	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
3668	26	41	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
3669	240	41	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
3670	100	41	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3671	266	41	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3672	268	41	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
3673	53	41	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3674	211	41	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3675	161	41	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3676	130	41	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3677	215	41	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
3678	267	41	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3679	50	41	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3680	27	41	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3681	239	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3682	69	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3683	270	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3684	216	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3685	1	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3686	265	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3687	98	41	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3688	28	41	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3689	96	41	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3690	2	41	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3691	70	42	2	1546	\N	1546	\N	\N	1	1	2	f	0	\N	\N
3692	172	42	2	825	\N	0	\N	\N	2	1	2	f	825	\N	\N
3693	104	42	2	367	\N	0	\N	\N	3	1	2	f	367	\N	\N
3694	139	42	2	344	\N	171	\N	\N	4	1	2	f	173	\N	\N
3695	217	42	2	46	\N	0	\N	\N	5	1	2	f	46	\N	\N
3696	145	42	2	42	\N	29	\N	\N	6	1	2	f	13	\N	\N
3697	135	42	2	23	\N	23	\N	\N	7	1	2	f	0	\N	\N
3698	164	42	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
3699	54	42	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
3700	109	42	2	825	\N	0	\N	\N	0	1	2	f	825	\N	\N
3701	91	42	2	367	\N	0	\N	\N	0	1	2	f	367	\N	\N
3702	251	42	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
3703	15	42	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
3704	131	42	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3705	23	42	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3706	55	43	2	190334	\N	0	\N	\N	1	1	2	f	190334	\N	\N
3707	33	43	2	147904	\N	0	\N	\N	2	1	2	f	147904	\N	\N
3708	54	43	2	72393	\N	0	\N	\N	3	1	2	f	72393	\N	\N
3709	139	43	2	53261	\N	0	\N	\N	4	1	2	f	53261	\N	\N
3710	109	43	2	41201	\N	0	\N	\N	5	1	2	f	41201	\N	\N
3711	145	43	2	39845	\N	0	\N	\N	6	1	2	f	39845	\N	\N
3712	111	43	2	16326	\N	0	\N	\N	7	1	2	f	16326	\N	\N
3713	251	43	2	10796	\N	0	\N	\N	8	1	2	f	10796	\N	\N
3714	91	43	2	655	\N	0	\N	\N	9	1	2	f	655	\N	\N
3715	249	43	2	85954	\N	0	\N	\N	0	1	2	f	85954	\N	\N
3716	173	43	2	25731	\N	0	\N	\N	0	1	2	f	25731	\N	\N
3717	37	43	2	24036	\N	0	\N	\N	0	1	2	f	24036	\N	\N
3718	21	43	2	23671	\N	0	\N	\N	0	1	2	f	23671	\N	\N
3719	234	43	2	19097	\N	0	\N	\N	0	1	2	f	19097	\N	\N
3720	208	43	2	17238	\N	0	\N	\N	0	1	2	f	17238	\N	\N
3721	180	43	2	15850	\N	0	\N	\N	0	1	2	f	15850	\N	\N
3722	46	43	2	13674	\N	0	\N	\N	0	1	2	f	13674	\N	\N
3723	237	43	2	12932	\N	0	\N	\N	0	1	2	f	12932	\N	\N
3724	149	43	2	12742	\N	0	\N	\N	0	1	2	f	12742	\N	\N
3725	60	43	2	11716	\N	0	\N	\N	0	1	2	f	11716	\N	\N
3726	222	43	2	11435	\N	0	\N	\N	0	1	2	f	11435	\N	\N
3727	261	43	2	9563	\N	0	\N	\N	0	1	2	f	9563	\N	\N
3728	112	43	2	9349	\N	0	\N	\N	0	1	2	f	9349	\N	\N
3729	61	43	2	8211	\N	0	\N	\N	0	1	2	f	8211	\N	\N
3730	179	43	2	8047	\N	0	\N	\N	0	1	2	f	8047	\N	\N
3731	255	43	2	8017	\N	0	\N	\N	0	1	2	f	8017	\N	\N
3732	32	43	2	7949	\N	0	\N	\N	0	1	2	f	7949	\N	\N
3733	65	43	2	7592	\N	0	\N	\N	0	1	2	f	7592	\N	\N
3734	136	43	2	7331	\N	0	\N	\N	0	1	2	f	7331	\N	\N
3735	278	43	2	7273	\N	0	\N	\N	0	1	2	f	7273	\N	\N
3736	227	43	2	7235	\N	0	\N	\N	0	1	2	f	7235	\N	\N
3737	236	43	2	6998	\N	0	\N	\N	0	1	2	f	6998	\N	\N
3738	168	43	2	5988	\N	0	\N	\N	0	1	2	f	5988	\N	\N
3739	83	43	2	5915	\N	0	\N	\N	0	1	2	f	5915	\N	\N
3740	73	43	2	5828	\N	0	\N	\N	0	1	2	f	5828	\N	\N
3741	118	43	2	5259	\N	0	\N	\N	0	1	2	f	5259	\N	\N
3742	210	43	2	5246	\N	0	\N	\N	0	1	2	f	5246	\N	\N
3743	115	43	2	4788	\N	0	\N	\N	0	1	2	f	4788	\N	\N
3744	201	43	2	4584	\N	0	\N	\N	0	1	2	f	4584	\N	\N
3745	133	43	2	4481	\N	0	\N	\N	0	1	2	f	4481	\N	\N
3746	23	43	2	4344	\N	0	\N	\N	0	1	2	f	4344	\N	\N
3747	59	43	2	4341	\N	0	\N	\N	0	1	2	f	4341	\N	\N
3748	229	43	2	4015	\N	0	\N	\N	0	1	2	f	4015	\N	\N
3749	254	43	2	3965	\N	0	\N	\N	0	1	2	f	3965	\N	\N
3750	253	43	2	3897	\N	0	\N	\N	0	1	2	f	3897	\N	\N
3751	134	43	2	3857	\N	0	\N	\N	0	1	2	f	3857	\N	\N
3752	86	43	2	3728	\N	0	\N	\N	0	1	2	f	3728	\N	\N
3753	178	43	2	3668	\N	0	\N	\N	0	1	2	f	3668	\N	\N
3754	13	43	2	3634	\N	0	\N	\N	0	1	2	f	3634	\N	\N
3755	110	43	2	3545	\N	0	\N	\N	0	1	2	f	3545	\N	\N
3756	113	43	2	3489	\N	0	\N	\N	0	1	2	f	3489	\N	\N
3757	35	43	2	3420	\N	0	\N	\N	0	1	2	f	3420	\N	\N
3758	31	43	2	3349	\N	0	\N	\N	0	1	2	f	3349	\N	\N
3759	207	43	2	3224	\N	0	\N	\N	0	1	2	f	3224	\N	\N
3760	19	43	2	3062	\N	0	\N	\N	0	1	2	f	3062	\N	\N
3761	276	43	2	2994	\N	0	\N	\N	0	1	2	f	2994	\N	\N
3762	177	43	2	2947	\N	0	\N	\N	0	1	2	f	2947	\N	\N
3763	199	43	2	2857	\N	0	\N	\N	0	1	2	f	2857	\N	\N
3764	20	43	2	2819	\N	0	\N	\N	0	1	2	f	2819	\N	\N
3765	155	43	2	2788	\N	0	\N	\N	0	1	2	f	2788	\N	\N
3766	142	43	2	2712	\N	0	\N	\N	0	1	2	f	2712	\N	\N
3767	157	43	2	2602	\N	0	\N	\N	0	1	2	f	2602	\N	\N
3768	242	43	2	2594	\N	0	\N	\N	0	1	2	f	2594	\N	\N
3769	153	43	2	2587	\N	0	\N	\N	0	1	2	f	2587	\N	\N
3770	176	43	2	2473	\N	0	\N	\N	0	1	2	f	2473	\N	\N
3771	198	43	2	2458	\N	0	\N	\N	0	1	2	f	2458	\N	\N
3772	273	43	2	2454	\N	0	\N	\N	0	1	2	f	2454	\N	\N
3773	272	43	2	2416	\N	0	\N	\N	0	1	2	f	2416	\N	\N
3774	45	43	2	2409	\N	0	\N	\N	0	1	2	f	2409	\N	\N
3775	77	43	2	2399	\N	0	\N	\N	0	1	2	f	2399	\N	\N
3776	8	43	2	2398	\N	0	\N	\N	0	1	2	f	2398	\N	\N
3777	66	43	2	2360	\N	0	\N	\N	0	1	2	f	2360	\N	\N
3778	11	43	2	2244	\N	0	\N	\N	0	1	2	f	2244	\N	\N
3779	246	43	2	2231	\N	0	\N	\N	0	1	2	f	2231	\N	\N
3780	169	43	2	2126	\N	0	\N	\N	0	1	2	f	2126	\N	\N
3781	256	43	2	1985	\N	0	\N	\N	0	1	2	f	1985	\N	\N
3782	231	43	2	1971	\N	0	\N	\N	0	1	2	f	1971	\N	\N
3783	123	43	2	1879	\N	0	\N	\N	0	1	2	f	1879	\N	\N
3784	186	43	2	1736	\N	0	\N	\N	0	1	2	f	1736	\N	\N
3785	18	43	2	1686	\N	0	\N	\N	0	1	2	f	1686	\N	\N
3786	247	43	2	1640	\N	0	\N	\N	0	1	2	f	1640	\N	\N
3787	119	43	2	1622	\N	0	\N	\N	0	1	2	f	1622	\N	\N
3788	170	43	2	1601	\N	0	\N	\N	0	1	2	f	1601	\N	\N
3789	202	43	2	1569	\N	0	\N	\N	0	1	2	f	1569	\N	\N
3790	220	43	2	1440	\N	0	\N	\N	0	1	2	f	1440	\N	\N
3791	252	43	2	1421	\N	0	\N	\N	0	1	2	f	1421	\N	\N
3792	125	43	2	1411	\N	0	\N	\N	0	1	2	f	1411	\N	\N
3793	36	43	2	1402	\N	0	\N	\N	0	1	2	f	1402	\N	\N
3794	129	43	2	1335	\N	0	\N	\N	0	1	2	f	1335	\N	\N
3795	117	43	2	1329	\N	0	\N	\N	0	1	2	f	1329	\N	\N
3796	224	43	2	1267	\N	0	\N	\N	0	1	2	f	1267	\N	\N
3797	43	43	2	1259	\N	0	\N	\N	0	1	2	f	1259	\N	\N
3798	288	43	2	1257	\N	0	\N	\N	0	1	2	f	1257	\N	\N
3799	238	43	2	1236	\N	0	\N	\N	0	1	2	f	1236	\N	\N
3800	49	43	2	1187	\N	0	\N	\N	0	1	2	f	1187	\N	\N
3801	150	43	2	1176	\N	0	\N	\N	0	1	2	f	1176	\N	\N
3802	137	43	2	1176	\N	0	\N	\N	0	1	2	f	1176	\N	\N
3803	257	43	2	1161	\N	0	\N	\N	0	1	2	f	1161	\N	\N
3804	39	43	2	1134	\N	0	\N	\N	0	1	2	f	1134	\N	\N
3805	29	43	2	1047	\N	0	\N	\N	0	1	2	f	1047	\N	\N
3806	195	43	2	1035	\N	0	\N	\N	0	1	2	f	1035	\N	\N
3807	63	43	2	1013	\N	0	\N	\N	0	1	2	f	1013	\N	\N
3808	42	43	2	989	\N	0	\N	\N	0	1	2	f	989	\N	\N
3809	284	43	2	978	\N	0	\N	\N	0	1	2	f	978	\N	\N
3810	67	43	2	931	\N	0	\N	\N	0	1	2	f	931	\N	\N
3811	88	43	2	871	\N	0	\N	\N	0	1	2	f	871	\N	\N
3812	166	43	2	767	\N	0	\N	\N	0	1	2	f	767	\N	\N
3813	165	43	2	758	\N	0	\N	\N	0	1	2	f	758	\N	\N
3814	148	43	2	751	\N	0	\N	\N	0	1	2	f	751	\N	\N
3815	6	43	2	735	\N	0	\N	\N	0	1	2	f	735	\N	\N
3816	75	43	2	715	\N	0	\N	\N	0	1	2	f	715	\N	\N
3817	156	43	2	701	\N	0	\N	\N	0	1	2	f	701	\N	\N
3818	152	43	2	675	\N	0	\N	\N	0	1	2	f	675	\N	\N
3819	80	43	2	648	\N	0	\N	\N	0	1	2	f	648	\N	\N
3820	218	43	2	623	\N	0	\N	\N	0	1	2	f	623	\N	\N
3821	25	43	2	609	\N	0	\N	\N	0	1	2	f	609	\N	\N
3822	108	43	2	570	\N	0	\N	\N	0	1	2	f	570	\N	\N
3823	102	43	2	563	\N	0	\N	\N	0	1	2	f	563	\N	\N
3824	120	43	2	536	\N	0	\N	\N	0	1	2	f	536	\N	\N
3825	228	43	2	528	\N	0	\N	\N	0	1	2	f	528	\N	\N
3826	47	43	2	525	\N	0	\N	\N	0	1	2	f	525	\N	\N
3827	271	43	2	521	\N	0	\N	\N	0	1	2	f	521	\N	\N
3828	282	43	2	514	\N	0	\N	\N	0	1	2	f	514	\N	\N
3829	275	43	2	498	\N	0	\N	\N	0	1	2	f	498	\N	\N
3830	206	43	2	494	\N	0	\N	\N	0	1	2	f	494	\N	\N
3831	233	43	2	491	\N	0	\N	\N	0	1	2	f	491	\N	\N
3832	122	43	2	485	\N	0	\N	\N	0	1	2	f	485	\N	\N
3833	30	43	2	454	\N	0	\N	\N	0	1	2	f	454	\N	\N
3834	126	43	2	454	\N	0	\N	\N	0	1	2	f	454	\N	\N
3835	172	43	2	445	\N	0	\N	\N	0	1	2	f	445	\N	\N
3836	57	43	2	438	\N	0	\N	\N	0	1	2	f	438	\N	\N
3837	17	43	2	432	\N	0	\N	\N	0	1	2	f	432	\N	\N
3838	197	43	2	427	\N	0	\N	\N	0	1	2	f	427	\N	\N
3839	44	43	2	419	\N	0	\N	\N	0	1	2	f	419	\N	\N
3840	143	43	2	411	\N	0	\N	\N	0	1	2	f	411	\N	\N
3841	175	43	2	405	\N	0	\N	\N	0	1	2	f	405	\N	\N
3842	141	43	2	394	\N	0	\N	\N	0	1	2	f	394	\N	\N
3843	147	43	2	373	\N	0	\N	\N	0	1	2	f	373	\N	\N
3844	200	43	2	360	\N	0	\N	\N	0	1	2	f	360	\N	\N
3845	48	43	2	354	\N	0	\N	\N	0	1	2	f	354	\N	\N
3846	85	43	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
3847	114	43	2	331	\N	0	\N	\N	0	1	2	f	331	\N	\N
3848	58	43	2	331	\N	0	\N	\N	0	1	2	f	331	\N	\N
3849	40	43	2	327	\N	0	\N	\N	0	1	2	f	327	\N	\N
3850	104	43	2	321	\N	0	\N	\N	0	1	2	f	321	\N	\N
3851	279	43	2	316	\N	0	\N	\N	0	1	2	f	316	\N	\N
3852	185	43	2	308	\N	0	\N	\N	0	1	2	f	308	\N	\N
3853	274	43	2	295	\N	0	\N	\N	0	1	2	f	295	\N	\N
3854	183	43	2	288	\N	0	\N	\N	0	1	2	f	288	\N	\N
3855	92	43	2	280	\N	0	\N	\N	0	1	2	f	280	\N	\N
3856	281	43	2	274	\N	0	\N	\N	0	1	2	f	274	\N	\N
3857	205	43	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
3858	64	43	2	260	\N	0	\N	\N	0	1	2	f	260	\N	\N
3859	280	43	2	257	\N	0	\N	\N	0	1	2	f	257	\N	\N
3860	188	43	2	253	\N	0	\N	\N	0	1	2	f	253	\N	\N
3861	219	43	2	251	\N	0	\N	\N	0	1	2	f	251	\N	\N
3862	187	43	2	237	\N	0	\N	\N	0	1	2	f	237	\N	\N
3863	135	43	2	236	\N	0	\N	\N	0	1	2	f	236	\N	\N
3864	82	43	2	236	\N	0	\N	\N	0	1	2	f	236	\N	\N
3865	72	43	2	227	\N	0	\N	\N	0	1	2	f	227	\N	\N
3866	167	43	2	225	\N	0	\N	\N	0	1	2	f	225	\N	\N
3867	78	43	2	215	\N	0	\N	\N	0	1	2	f	215	\N	\N
3868	34	43	2	209	\N	0	\N	\N	0	1	2	f	209	\N	\N
3869	56	43	2	208	\N	0	\N	\N	0	1	2	f	208	\N	\N
3870	74	43	2	198	\N	0	\N	\N	0	1	2	f	198	\N	\N
3871	226	43	2	185	\N	0	\N	\N	0	1	2	f	185	\N	\N
3872	127	43	2	178	\N	0	\N	\N	0	1	2	f	178	\N	\N
3873	182	43	2	178	\N	0	\N	\N	0	1	2	f	178	\N	\N
3874	103	43	2	177	\N	0	\N	\N	0	1	2	f	177	\N	\N
3875	81	43	2	176	\N	0	\N	\N	0	1	2	f	176	\N	\N
3876	12	43	2	168	\N	0	\N	\N	0	1	2	f	168	\N	\N
3877	131	43	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
3878	124	43	2	166	\N	0	\N	\N	0	1	2	f	166	\N	\N
3879	244	43	2	151	\N	0	\N	\N	0	1	2	f	151	\N	\N
3880	68	43	2	149	\N	0	\N	\N	0	1	2	f	149	\N	\N
3881	140	43	2	147	\N	0	\N	\N	0	1	2	f	147	\N	\N
3882	9	43	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
3883	90	43	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
3884	24	43	2	107	\N	0	\N	\N	0	1	2	f	107	\N	\N
3885	51	43	2	86	\N	0	\N	\N	0	1	2	f	86	\N	\N
3886	223	43	2	80	\N	0	\N	\N	0	1	2	f	80	\N	\N
3887	260	43	2	78	\N	0	\N	\N	0	1	2	f	78	\N	\N
3888	5	43	2	76	\N	0	\N	\N	0	1	2	f	76	\N	\N
3889	15	43	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
3890	158	43	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
3891	105	43	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
3892	151	43	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
3893	287	43	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
3894	159	43	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3895	286	43	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3896	285	43	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
3897	76	43	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
3898	146	43	2	35	\N	0	\N	\N	0	1	2	f	35	\N	\N
3899	235	43	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
3900	84	43	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
3901	128	43	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
3902	87	43	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
3903	225	43	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
3904	138	43	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
3905	245	43	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
3906	97	43	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
3907	71	43	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
3908	16	43	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
3909	203	43	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
3910	194	43	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
3911	269	43	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
3912	171	43	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
3913	41	43	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
3914	89	43	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
3915	62	43	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
3916	250	43	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
3917	248	43	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
3918	10	43	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
3919	7	43	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
3920	106	43	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
3921	221	43	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
3922	290	43	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
3923	192	43	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3924	162	43	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3925	184	43	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3926	212	43	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3927	144	43	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3928	189	43	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3929	154	43	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3930	196	43	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3931	190	43	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3932	204	43	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3933	79	43	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
3934	258	43	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3935	209	43	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3936	22	43	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3937	3	43	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3938	259	43	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3939	116	43	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3940	121	43	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3941	283	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3942	230	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3943	270	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3944	216	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3945	163	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3946	191	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3947	107	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3948	277	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3949	52	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3950	241	43	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3951	109	44	2	6342	\N	0	\N	\N	1	1	2	f	6342	\N	\N
3952	23	44	2	1087	\N	0	\N	\N	2	1	2	f	1087	\N	\N
3953	139	44	2	656	\N	0	\N	\N	3	1	2	f	656	\N	\N
3954	32	44	2	236	\N	0	\N	\N	4	1	2	f	236	\N	\N
3955	227	44	2	135	\N	0	\N	\N	5	1	2	f	135	\N	\N
3956	55	44	2	120	\N	0	\N	\N	6	1	2	f	120	\N	\N
3957	224	44	2	5889	\N	0	\N	\N	0	1	2	f	5889	\N	\N
3958	54	44	2	1087	\N	0	\N	\N	0	1	2	f	1087	\N	\N
3959	77	44	2	374	\N	0	\N	\N	0	1	2	f	374	\N	\N
3960	173	44	2	282	\N	0	\N	\N	0	1	2	f	282	\N	\N
3961	33	44	2	236	\N	0	\N	\N	0	1	2	f	236	\N	\N
3962	145	44	2	135	\N	0	\N	\N	0	1	2	f	135	\N	\N
3963	70	45	2	2562	\N	0	\N	\N	1	1	2	f	2562	\N	\N
3964	111	46	2	21663074	\N	21663074	\N	\N	1	1	2	f	0	217	\N
3965	109	46	2	10657434	\N	10657434	\N	\N	2	1	2	f	0	217	\N
3966	251	46	2	9003199	\N	9003199	\N	\N	3	1	2	f	0	217	\N
3967	54	46	2	6445440	\N	6445440	\N	\N	4	1	2	f	0	217	\N
3968	55	46	2	4910717	\N	4910717	\N	\N	5	1	2	f	0	217	\N
3969	33	46	2	2547672	\N	2547672	\N	\N	6	1	2	f	0	217	\N
3970	145	46	2	2256594	\N	2256594	\N	\N	7	1	2	f	0	217	\N
3971	139	46	2	1143181	\N	1143181	\N	\N	8	1	2	f	0	217	\N
3972	91	46	2	226544	\N	226544	\N	\N	9	1	2	f	0	217	\N
3973	70	46	2	1546	\N	1546	\N	\N	10	1	2	f	0	217	\N
3974	217	46	2	290	\N	290	\N	\N	11	1	2	f	0	\N	\N
3975	164	46	2	1	\N	1	\N	\N	12	1	2	f	0	\N	\N
3976	149	46	2	18138256	\N	18138256	\N	\N	0	1	2	f	0	217	\N
3977	255	46	2	3660416	\N	3660416	\N	\N	0	1	2	f	0	217	\N
3978	209	46	2	3073624	\N	3073624	\N	\N	0	1	2	f	0	217	\N
3979	37	46	2	2396287	\N	2396287	\N	\N	0	1	2	f	0	217	\N
3980	126	46	2	2265350	\N	2265350	\N	\N	0	1	2	f	0	217	\N
3981	282	46	2	1956432	\N	1956432	\N	\N	0	1	2	f	0	217	\N
3982	210	46	2	1954341	\N	1954341	\N	\N	0	1	2	f	0	217	\N
3983	249	46	2	1099846	\N	1099846	\N	\N	0	1	2	f	0	217	\N
3984	6	46	2	891182	\N	891182	\N	\N	0	1	2	f	0	217	\N
3985	242	46	2	882926	\N	882926	\N	\N	0	1	2	f	0	217	\N
3986	118	46	2	836942	\N	836942	\N	\N	0	1	2	f	0	217	\N
3987	278	46	2	810272	\N	810272	\N	\N	0	1	2	f	0	217	\N
3988	112	46	2	757415	\N	757415	\N	\N	0	1	2	f	0	217	\N
3989	136	46	2	660351	\N	660351	\N	\N	0	1	2	f	0	217	\N
3990	195	46	2	597416	\N	597416	\N	\N	0	1	2	f	0	217	\N
3991	222	46	2	503177	\N	503177	\N	\N	0	1	2	f	0	217	\N
3992	90	46	2	494858	\N	494858	\N	\N	0	1	2	f	0	217	\N
3993	119	46	2	466352	\N	466352	\N	\N	0	1	2	f	0	217	\N
3994	21	46	2	434732	\N	434732	\N	\N	0	1	2	f	0	217	\N
3995	76	46	2	427068	\N	427068	\N	\N	0	1	2	f	0	217	\N
3996	234	46	2	407901	\N	407901	\N	\N	0	1	2	f	0	217	\N
3997	180	46	2	380535	\N	380535	\N	\N	0	1	2	f	0	217	\N
3998	208	46	2	356905	\N	356905	\N	\N	0	1	2	f	0	217	\N
3999	237	46	2	339546	\N	339546	\N	\N	0	1	2	f	0	217	\N
4000	72	46	2	336304	\N	336304	\N	\N	0	1	2	f	0	217	\N
4001	197	46	2	332256	\N	332256	\N	\N	0	1	2	f	0	217	\N
4002	225	46	2	299670	\N	299670	\N	\N	0	1	2	f	0	217	\N
4003	173	46	2	286560	\N	286560	\N	\N	0	1	2	f	0	217	\N
4004	46	46	2	279823	\N	279823	\N	\N	0	1	2	f	0	217	\N
4005	168	46	2	273545	\N	273545	\N	\N	0	1	2	f	0	217	\N
4006	74	46	2	265016	\N	265016	\N	\N	0	1	2	f	0	217	\N
4007	236	46	2	256088	\N	256088	\N	\N	0	1	2	f	0	217	\N
4008	48	46	2	244024	\N	244024	\N	\N	0	1	2	f	0	217	\N
4009	61	46	2	230883	\N	230883	\N	\N	0	1	2	f	0	217	\N
4010	133	46	2	228688	\N	228688	\N	\N	0	1	2	f	0	217	\N
4011	83	46	2	226800	\N	226800	\N	\N	0	1	2	f	0	217	\N
4012	159	46	2	219410	\N	219410	\N	\N	0	1	2	f	0	217	\N
4013	261	46	2	209121	\N	209121	\N	\N	0	1	2	f	0	217	\N
4014	179	46	2	208701	\N	208701	\N	\N	0	1	2	f	0	217	\N
4015	114	46	2	199264	\N	199264	\N	\N	0	1	2	f	0	217	\N
4016	32	46	2	198969	\N	198969	\N	\N	0	1	2	f	0	217	\N
4017	219	46	2	192843	\N	192843	\N	\N	0	1	2	f	0	217	\N
4018	68	46	2	190210	\N	190210	\N	\N	0	1	2	f	0	217	\N
4019	11	46	2	185758	\N	185758	\N	\N	0	1	2	f	0	217	\N
4020	13	46	2	183876	\N	183876	\N	\N	0	1	2	f	0	217	\N
4021	279	46	2	183789	\N	183789	\N	\N	0	1	2	f	0	217	\N
4022	224	46	2	182700	\N	182700	\N	\N	0	1	2	f	0	217	\N
4023	120	46	2	180073	\N	180073	\N	\N	0	1	2	f	0	217	\N
4024	107	46	2	177406	\N	177406	\N	\N	0	1	2	f	0	217	\N
4025	143	46	2	169648	\N	169648	\N	\N	0	1	2	f	0	217	\N
4026	24	46	2	167754	\N	167754	\N	\N	0	1	2	f	0	217	\N
4027	8	46	2	163653	\N	163653	\N	\N	0	1	2	f	0	217	\N
4028	73	46	2	161160	\N	161160	\N	\N	0	1	2	f	0	217	\N
4029	79	46	2	159459	\N	159459	\N	\N	0	1	2	f	0	217	\N
4030	188	46	2	153546	\N	153546	\N	\N	0	1	2	f	0	217	\N
4031	169	46	2	147267	\N	147267	\N	\N	0	1	2	f	0	217	\N
4032	229	46	2	133611	\N	133611	\N	\N	0	1	2	f	0	217	\N
4033	49	46	2	130270	\N	130270	\N	\N	0	1	2	f	0	217	\N
4034	280	46	2	123618	\N	123618	\N	\N	0	1	2	f	0	217	\N
4035	171	46	2	122460	\N	122460	\N	\N	0	1	2	f	0	217	\N
4036	103	46	2	121822	\N	121822	\N	\N	0	1	2	f	0	217	\N
4037	283	46	2	120974	\N	120974	\N	\N	0	1	2	f	0	217	\N
4038	198	46	2	119988	\N	119988	\N	\N	0	1	2	f	0	217	\N
4039	65	46	2	112354	\N	112354	\N	\N	0	1	2	f	0	217	\N
4040	135	46	2	109578	\N	109578	\N	\N	0	1	2	f	0	217	\N
4041	60	46	2	108675	\N	108675	\N	\N	0	1	2	f	0	217	\N
4042	113	46	2	106694	\N	106694	\N	\N	0	1	2	f	0	217	\N
4043	202	46	2	103520	\N	103520	\N	\N	0	1	2	f	0	217	\N
4044	260	46	2	103357	\N	103357	\N	\N	0	1	2	f	0	217	\N
4045	59	46	2	102789	\N	102789	\N	\N	0	1	2	f	0	217	\N
4046	206	46	2	96125	\N	96125	\N	\N	0	1	2	f	0	217	\N
4047	166	46	2	96024	\N	96024	\N	\N	0	1	2	f	0	217	\N
4048	122	46	2	91836	\N	91836	\N	\N	0	1	2	f	0	217	\N
4049	250	46	2	90624	\N	90624	\N	\N	0	1	2	f	0	217	\N
4050	23	46	2	88817	\N	88817	\N	\N	0	1	2	f	0	217	\N
4051	153	46	2	87137	\N	87137	\N	\N	0	1	2	f	0	217	\N
4052	271	46	2	86376	\N	86376	\N	\N	0	1	2	f	0	217	\N
4053	248	46	2	83005	\N	83005	\N	\N	0	1	2	f	0	217	\N
4054	115	46	2	79696	\N	79696	\N	\N	0	1	2	f	0	217	\N
4055	144	46	2	78655	\N	78655	\N	\N	0	1	2	f	0	217	\N
4056	155	46	2	78456	\N	78456	\N	\N	0	1	2	f	0	217	\N
4057	235	46	2	76129	\N	76129	\N	\N	0	1	2	f	0	217	\N
4058	247	46	2	73640	\N	73640	\N	\N	0	1	2	f	0	217	\N
4059	227	46	2	73510	\N	73510	\N	\N	0	1	2	f	0	217	\N
4060	281	46	2	71280	\N	71280	\N	\N	0	1	2	f	0	217	\N
4061	199	46	2	70798	\N	70798	\N	\N	0	1	2	f	0	217	\N
4062	200	46	2	69055	\N	69055	\N	\N	0	1	2	f	0	217	\N
4063	201	46	2	68905	\N	68905	\N	\N	0	1	2	f	0	217	\N
4064	82	46	2	63278	\N	63278	\N	\N	0	1	2	f	0	217	\N
4065	207	46	2	61603	\N	61603	\N	\N	0	1	2	f	0	217	\N
4066	172	46	2	60173	\N	60173	\N	\N	0	1	2	f	0	217	\N
4067	41	46	2	58452	\N	58452	\N	\N	0	1	2	f	0	217	\N
4068	20	46	2	57361	\N	57361	\N	\N	0	1	2	f	0	217	\N
4069	86	46	2	57154	\N	57154	\N	\N	0	1	2	f	0	217	\N
4070	75	46	2	55733	\N	55733	\N	\N	0	1	2	f	0	217	\N
4071	134	46	2	54908	\N	54908	\N	\N	0	1	2	f	0	217	\N
4072	170	46	2	54496	\N	54496	\N	\N	0	1	2	f	0	217	\N
4073	154	46	2	53356	\N	53356	\N	\N	0	1	2	f	0	217	\N
4074	276	46	2	53320	\N	53320	\N	\N	0	1	2	f	0	217	\N
4075	254	46	2	51857	\N	51857	\N	\N	0	1	2	f	0	217	\N
4076	31	46	2	50417	\N	50417	\N	\N	0	1	2	f	0	217	\N
4077	178	46	2	50410	\N	50410	\N	\N	0	1	2	f	0	217	\N
4078	272	46	2	48498	\N	48498	\N	\N	0	1	2	f	0	217	\N
4079	167	46	2	48434	\N	48434	\N	\N	0	1	2	f	0	217	\N
4080	89	46	2	48244	\N	48244	\N	\N	0	1	2	f	0	217	\N
4081	157	46	2	48183	\N	48183	\N	\N	0	1	2	f	0	217	\N
4082	175	46	2	47958	\N	47958	\N	\N	0	1	2	f	0	217	\N
4083	22	46	2	47853	\N	47853	\N	\N	0	1	2	f	0	217	\N
4084	187	46	2	47749	\N	47749	\N	\N	0	1	2	f	0	217	\N
4085	152	46	2	47466	\N	47466	\N	\N	0	1	2	f	0	217	\N
4086	253	46	2	45308	\N	45308	\N	\N	0	1	2	f	0	217	\N
4087	151	46	2	43988	\N	43988	\N	\N	0	1	2	f	0	217	\N
4088	66	46	2	43962	\N	43962	\N	\N	0	1	2	f	0	217	\N
4089	256	46	2	43168	\N	43168	\N	\N	0	1	2	f	0	217	\N
4090	141	46	2	43152	\N	43152	\N	\N	0	1	2	f	0	217	\N
4091	284	46	2	40606	\N	40606	\N	\N	0	1	2	f	0	217	\N
4092	110	46	2	37920	\N	37920	\N	\N	0	1	2	f	0	217	\N
4093	108	46	2	37184	\N	37184	\N	\N	0	1	2	f	0	217	\N
4094	186	46	2	35443	\N	35443	\N	\N	0	1	2	f	0	217	\N
4095	246	46	2	34982	\N	34982	\N	\N	0	1	2	f	0	217	\N
4096	177	46	2	34543	\N	34543	\N	\N	0	1	2	f	0	217	\N
4097	138	46	2	33564	\N	33564	\N	\N	0	1	2	f	0	217	\N
4098	123	46	2	33536	\N	33536	\N	\N	0	1	2	f	0	217	\N
4099	19	46	2	33472	\N	33472	\N	\N	0	1	2	f	0	217	\N
4100	194	46	2	33100	\N	33100	\N	\N	0	1	2	f	0	217	\N
4101	35	46	2	31052	\N	31052	\N	\N	0	1	2	f	0	217	\N
4102	106	46	2	30924	\N	30924	\N	\N	0	1	2	f	0	217	\N
4103	142	46	2	30747	\N	30747	\N	\N	0	1	2	f	0	217	\N
4104	117	46	2	29856	\N	29856	\N	\N	0	1	2	f	0	217	\N
4105	36	46	2	29666	\N	29666	\N	\N	0	1	2	f	0	217	\N
4106	238	46	2	28907	\N	28907	\N	\N	0	1	2	f	0	217	\N
4107	218	46	2	28490	\N	28490	\N	\N	0	1	2	f	0	217	\N
4108	273	46	2	28104	\N	28104	\N	\N	0	1	2	f	0	217	\N
4109	25	46	2	28042	\N	28042	\N	\N	0	1	2	f	0	217	\N
4110	45	46	2	27978	\N	27978	\N	\N	0	1	2	f	0	217	\N
4111	147	46	2	27106	\N	27106	\N	\N	0	1	2	f	0	217	\N
4112	39	46	2	26818	\N	26818	\N	\N	0	1	2	f	0	217	\N
4113	105	46	2	26586	\N	26586	\N	\N	0	1	2	f	0	217	\N
4114	77	46	2	24755	\N	24755	\N	\N	0	1	2	f	0	217	\N
4115	121	46	2	24684	\N	24684	\N	\N	0	1	2	f	0	217	\N
4116	220	46	2	24525	\N	24525	\N	\N	0	1	2	f	0	217	\N
4117	129	46	2	23249	\N	23249	\N	\N	0	1	2	f	0	217	\N
4118	176	46	2	23224	\N	23224	\N	\N	0	1	2	f	0	217	\N
4119	231	46	2	22770	\N	22770	\N	\N	0	1	2	f	0	217	\N
4120	18	46	2	22360	\N	22360	\N	\N	0	1	2	f	0	217	\N
4121	63	46	2	22297	\N	22297	\N	\N	0	1	2	f	0	217	\N
4122	183	46	2	21698	\N	21698	\N	\N	0	1	2	f	0	217	\N
4123	290	46	2	21646	\N	21646	\N	\N	0	1	2	f	0	217	\N
4124	102	46	2	21600	\N	21600	\N	\N	0	1	2	f	0	217	\N
4125	85	46	2	20315	\N	20315	\N	\N	0	1	2	f	0	217	\N
4126	67	46	2	18327	\N	18327	\N	\N	0	1	2	f	0	217	\N
4127	29	46	2	18042	\N	18042	\N	\N	0	1	2	f	0	217	\N
4128	226	46	2	17468	\N	17468	\N	\N	0	1	2	f	0	217	\N
4129	156	46	2	16968	\N	16968	\N	\N	0	1	2	f	0	217	\N
4130	174	46	2	16854	\N	16854	\N	\N	0	1	2	f	0	217	\N
4131	137	46	2	16680	\N	16680	\N	\N	0	1	2	f	0	217	\N
4132	10	46	2	16560	\N	16560	\N	\N	0	1	2	f	0	217	\N
4133	257	46	2	16486	\N	16486	\N	\N	0	1	2	f	0	217	\N
4134	88	46	2	16256	\N	16256	\N	\N	0	1	2	f	0	217	\N
4135	140	46	2	15595	\N	15595	\N	\N	0	1	2	f	0	217	\N
4136	228	46	2	15516	\N	15516	\N	\N	0	1	2	f	0	217	\N
4137	191	46	2	15033	\N	15033	\N	\N	0	1	2	f	0	217	\N
4138	43	46	2	14612	\N	14612	\N	\N	0	1	2	f	0	217	\N
4139	158	46	2	14574	\N	14574	\N	\N	0	1	2	f	0	217	\N
4140	230	46	2	14520	\N	14520	\N	\N	0	1	2	f	0	217	\N
4141	87	46	2	14111	\N	14111	\N	\N	0	1	2	f	0	217	\N
4142	204	46	2	13748	\N	13748	\N	\N	0	1	2	f	0	217	\N
4143	288	46	2	13028	\N	13028	\N	\N	0	1	2	f	0	217	\N
4144	125	46	2	12644	\N	12644	\N	\N	0	1	2	f	0	217	\N
4145	12	46	2	12550	\N	12550	\N	\N	0	1	2	f	0	217	\N
4146	92	46	2	12512	\N	12512	\N	\N	0	1	2	f	0	217	\N
4147	185	46	2	12152	\N	12152	\N	\N	0	1	2	f	0	217	\N
4148	17	46	2	11713	\N	11713	\N	\N	0	1	2	f	0	217	\N
4149	233	46	2	11544	\N	11544	\N	\N	0	1	2	f	0	217	\N
4150	252	46	2	11426	\N	11426	\N	\N	0	1	2	f	0	217	\N
4151	150	46	2	10746	\N	10746	\N	\N	0	1	2	f	0	217	\N
4152	165	46	2	10134	\N	10134	\N	\N	0	1	2	f	0	217	\N
4153	7	46	2	9922	\N	9922	\N	\N	0	1	2	f	0	217	\N
4154	44	46	2	9548	\N	9548	\N	\N	0	1	2	f	0	217	\N
4155	232	46	2	9268	\N	9268	\N	\N	0	1	2	f	0	217	\N
4156	42	46	2	8760	\N	8760	\N	\N	0	1	2	f	0	217	\N
4157	274	46	2	8644	\N	8644	\N	\N	0	1	2	f	0	217	\N
4158	277	46	2	8582	\N	8582	\N	\N	0	1	2	f	0	217	\N
4159	57	46	2	7722	\N	7722	\N	\N	0	1	2	f	0	217	\N
4160	62	46	2	7586	\N	7586	\N	\N	0	1	2	f	0	217	\N
4161	275	46	2	7518	\N	7518	\N	\N	0	1	2	f	0	217	\N
4162	56	46	2	7462	\N	7462	\N	\N	0	1	2	f	0	217	\N
4163	47	46	2	7328	\N	7328	\N	\N	0	1	2	f	0	217	\N
4164	205	46	2	7208	\N	7208	\N	\N	0	1	2	f	0	217	\N
4165	221	46	2	7085	\N	7085	\N	\N	0	1	2	f	0	217	\N
4166	30	46	2	7004	\N	7004	\N	\N	0	1	2	f	0	217	\N
4167	81	46	2	6886	\N	6886	\N	\N	0	1	2	f	0	217	\N
4168	34	46	2	6322	\N	6322	\N	\N	0	1	2	f	0	217	\N
4169	3	46	2	5916	\N	5916	\N	\N	0	1	2	f	0	217	\N
4170	148	46	2	5842	\N	5842	\N	\N	0	1	2	f	0	217	\N
4171	40	46	2	4557	\N	4557	\N	\N	0	1	2	f	0	217	\N
4172	223	46	2	4554	\N	4554	\N	\N	0	1	2	f	0	217	\N
4173	93	46	2	4288	\N	4288	\N	\N	0	1	2	f	0	217	\N
4174	38	46	2	4266	\N	4266	\N	\N	0	1	2	f	0	217	\N
4175	146	46	2	4204	\N	4204	\N	\N	0	1	2	f	0	217	\N
4176	9	46	2	4198	\N	4198	\N	\N	0	1	2	f	0	217	\N
4177	80	46	2	4102	\N	4102	\N	\N	0	1	2	f	0	217	\N
4178	78	46	2	3910	\N	3910	\N	\N	0	1	2	f	0	217	\N
4179	15	46	2	3820	\N	3820	\N	\N	0	1	2	f	0	\N	\N
4180	58	46	2	3478	\N	3478	\N	\N	0	1	2	f	0	217	\N
4181	289	46	2	3302	\N	3302	\N	\N	0	1	2	f	0	217	\N
4182	269	46	2	3300	\N	3300	\N	\N	0	1	2	f	0	217	\N
4183	84	46	2	3060	\N	3060	\N	\N	0	1	2	f	0	217	\N
4184	104	46	2	3018	\N	3018	\N	\N	0	1	2	f	0	217	\N
4185	127	46	2	2674	\N	2674	\N	\N	0	1	2	f	0	217	\N
4186	101	46	2	2640	\N	2640	\N	\N	0	1	2	f	0	217	\N
4187	241	46	2	2618	\N	2618	\N	\N	0	1	2	f	0	217	\N
4188	244	46	2	2606	\N	2606	\N	\N	0	1	2	f	0	217	\N
4189	258	46	2	2332	\N	2332	\N	\N	0	1	2	f	0	217	\N
4190	64	46	2	2270	\N	2270	\N	\N	0	1	2	f	0	217	\N
4191	116	46	2	2138	\N	2138	\N	\N	0	1	2	f	0	217	\N
4192	287	46	2	1985	\N	1985	\N	\N	0	1	2	f	0	217	\N
4193	192	46	2	1728	\N	1728	\N	\N	0	1	2	f	0	217	\N
4194	285	46	2	1598	\N	1598	\N	\N	0	1	2	f	0	217	\N
4195	184	46	2	1414	\N	1414	\N	\N	0	1	2	f	0	217	\N
4196	182	46	2	1320	\N	1320	\N	\N	0	1	2	f	0	217	\N
4197	71	46	2	1195	\N	1195	\N	\N	0	1	2	f	0	217	\N
4198	124	46	2	1177	\N	1177	\N	\N	0	1	2	f	0	217	\N
4199	51	46	2	1082	\N	1082	\N	\N	0	1	2	f	0	217	\N
4200	212	46	2	973	\N	973	\N	\N	0	1	2	f	0	217	\N
4201	5	46	2	968	\N	968	\N	\N	0	1	2	f	0	217	\N
4202	16	46	2	956	\N	956	\N	\N	0	1	2	f	0	217	\N
4203	163	46	2	892	\N	892	\N	\N	0	1	2	f	0	217	\N
4204	52	46	2	868	\N	868	\N	\N	0	1	2	f	0	217	\N
4205	128	46	2	838	\N	838	\N	\N	0	1	2	f	0	217	\N
4206	262	46	2	810	\N	810	\N	\N	0	1	2	f	0	217	\N
4207	214	46	2	796	\N	796	\N	\N	0	1	2	f	0	217	\N
4208	14	46	2	724	\N	724	\N	\N	0	1	2	f	0	217	\N
4209	203	46	2	616	\N	616	\N	\N	0	1	2	f	0	217	\N
4210	189	46	2	614	\N	614	\N	\N	0	1	2	f	0	217	\N
4211	196	46	2	602	\N	602	\N	\N	0	1	2	f	0	217	\N
4212	286	46	2	492	\N	492	\N	\N	0	1	2	f	0	217	\N
4213	4	46	2	454	\N	454	\N	\N	0	1	2	f	0	217	\N
4214	193	46	2	442	\N	442	\N	\N	0	1	2	f	0	217	\N
4215	245	46	2	424	\N	424	\N	\N	0	1	2	f	0	217	\N
4216	243	46	2	388	\N	388	\N	\N	0	1	2	f	0	217	\N
4217	190	46	2	384	\N	384	\N	\N	0	1	2	f	0	217	\N
4218	131	46	2	346	\N	346	\N	\N	0	1	2	f	0	\N	\N
4219	99	46	2	332	\N	332	\N	\N	0	1	2	f	0	217	\N
4220	264	46	2	266	\N	266	\N	\N	0	1	2	f	0	217	\N
4221	97	46	2	226	\N	226	\N	\N	0	1	2	f	0	217	\N
4222	95	46	2	210	\N	210	\N	\N	0	1	2	f	0	217	\N
4223	162	46	2	154	\N	154	\N	\N	0	1	2	f	0	217	\N
4224	181	46	2	136	\N	136	\N	\N	0	1	2	f	0	217	\N
4225	263	46	2	58	\N	58	\N	\N	0	1	2	f	0	217	\N
4226	160	46	2	54	\N	54	\N	\N	0	1	2	f	0	217	\N
4227	213	46	2	52	\N	52	\N	\N	0	1	2	f	0	217	\N
4228	132	46	2	48	\N	48	\N	\N	0	1	2	f	0	217	\N
4229	26	46	2	45	\N	45	\N	\N	0	1	2	f	0	217	\N
4230	259	46	2	44	\N	44	\N	\N	0	1	2	f	0	217	\N
4231	94	46	2	36	\N	36	\N	\N	0	1	2	f	0	217	\N
4232	268	46	2	31	\N	31	\N	\N	0	1	2	f	0	217	\N
4233	240	46	2	28	\N	28	\N	\N	0	1	2	f	0	217	\N
4234	100	46	2	22	\N	22	\N	\N	0	1	2	f	0	217	\N
4235	266	46	2	22	\N	22	\N	\N	0	1	2	f	0	217	\N
4236	53	46	2	10	\N	10	\N	\N	0	1	2	f	0	217	\N
4237	211	46	2	10	\N	10	\N	\N	0	1	2	f	0	217	\N
4238	161	46	2	10	\N	10	\N	\N	0	1	2	f	0	217	\N
4239	130	46	2	10	\N	10	\N	\N	0	1	2	f	0	217	\N
4240	215	46	2	10	\N	10	\N	\N	0	1	2	f	0	217	\N
4241	267	46	2	9	\N	9	\N	\N	0	1	2	f	0	217	\N
4242	50	46	2	6	\N	6	\N	\N	0	1	2	f	0	217	\N
4243	27	46	2	6	\N	6	\N	\N	0	1	2	f	0	217	\N
4244	239	46	2	4	\N	4	\N	\N	0	1	2	f	0	217	\N
4245	69	46	2	4	\N	4	\N	\N	0	1	2	f	0	217	\N
4246	1	46	2	4	\N	4	\N	\N	0	1	2	f	0	217	\N
4247	265	46	2	4	\N	4	\N	\N	0	1	2	f	0	217	\N
4248	28	46	2	3	\N	3	\N	\N	0	1	2	f	0	217	\N
4249	98	46	2	2	\N	2	\N	\N	0	1	2	f	0	217	\N
4250	96	46	2	2	\N	2	\N	\N	0	1	2	f	0	217	\N
4251	2	46	2	2	\N	2	\N	\N	0	1	2	f	0	217	\N
4252	270	46	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
4253	216	46	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
4254	217	46	1	58050734	\N	58050734	\N	\N	1	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	763	111	11755058	\N	1	\N
2	763	233	1	\N	0	\N
3	763	149	9069126	\N	0	\N
4	763	154	26677	\N	0	\N
5	763	54	5	\N	0	\N
6	763	264	132	\N	0	\N
7	763	112	1	\N	0	\N
8	763	236	1	\N	0	\N
9	763	215	5	\N	0	\N
10	763	241	1309	\N	0	\N
11	763	194	16544	\N	0	\N
12	763	145	463	\N	0	\N
13	763	4	227	\N	0	\N
14	763	109	1	\N	0	\N
15	763	213	26	\N	0	\N
16	763	232	4583	\N	0	\N
17	763	121	12342	\N	0	\N
18	763	251	87	\N	0	\N
19	763	214	398	\N	0	\N
20	763	99	166	\N	0	\N
21	763	242	441450	\N	0	\N
22	763	38	2133	\N	0	\N
23	763	175	23978	\N	0	\N
24	763	91	3	\N	0	\N
25	763	229	7	\N	0	\N
26	763	267	2	\N	0	\N
27	763	2	1	\N	0	\N
28	763	143	3	\N	0	\N
29	763	188	76766	\N	0	\N
30	763	144	39303	\N	0	\N
31	763	225	149835	\N	0	\N
32	763	204	6865	\N	0	\N
33	763	166	1	\N	0	\N
34	763	289	1651	\N	0	\N
35	763	14	362	\N	0	\N
36	763	126	86	\N	0	\N
37	763	33	2	\N	0	\N
38	763	41	1	\N	0	\N
39	763	193	221	\N	0	\N
40	763	226	8733	\N	0	\N
41	763	53	5	\N	0	\N
42	763	219	1	\N	0	\N
43	763	211	5	\N	0	\N
44	763	116	1069	\N	0	\N
45	763	114	3	\N	0	\N
46	763	200	1	\N	0	\N
47	763	230	2	\N	0	\N
48	763	212	322	\N	0	\N
49	763	87	7053	\N	0	\N
50	763	106	15462	\N	0	\N
51	763	74	4	\N	0	\N
52	763	52	434	\N	0	\N
53	763	69	2	\N	0	\N
54	763	190	128	\N	0	\N
55	764	172	30086	\N	0	\N
56	764	251	53152	\N	0	\N
57	764	247	18410	\N	0	\N
58	764	248	27668	\N	0	\N
59	764	41	29224	\N	0	\N
60	764	138	16782	\N	0	\N
61	764	6	297060	\N	0	\N
62	764	25	7010	\N	0	\N
63	764	10	8280	\N	0	\N
64	764	122	30612	\N	0	\N
65	764	168	68386	\N	0	\N
66	764	109	4906174	\N	1	\N
67	764	158	7287	\N	0	\N
68	764	243	194	\N	0	\N
69	764	151	21994	\N	0	\N
70	764	79	53152	\N	0	\N
71	764	117	9952	\N	0	\N
72	764	139	1	\N	0	\N
73	764	153	1	\N	0	\N
74	764	180	1	\N	0	\N
75	764	255	1830201	\N	0	\N
76	764	136	220113	\N	0	\N
77	764	88	1	\N	0	\N
78	764	26	15	\N	0	\N
79	764	95	105	\N	0	\N
80	764	100	11	\N	0	\N
81	764	98	1	\N	0	\N
82	764	209	1536812	\N	0	\N
83	764	107	88703	\N	0	\N
84	764	183	10848	\N	0	\N
85	764	239	2	\N	0	\N
86	764	94	18	\N	0	\N
87	764	55	157861	\N	0	\N
88	764	253	22654	\N	0	\N
89	764	260	34452	\N	0	\N
90	764	130	5	\N	0	\N
91	764	265	2	\N	0	\N
92	764	72	168152	\N	0	\N
93	764	145	11814	\N	0	\N
94	764	186	11814	\N	0	\N
95	764	258	1166	\N	0	\N
96	764	181	68	\N	0	\N
97	764	240	14	\N	0	\N
98	764	1	2	\N	0	\N
99	764	111	1	\N	0	\N
100	764	167	24214	\N	0	\N
101	764	64	1135	\N	0	\N
102	764	71	597	\N	0	\N
103	764	73	40290	\N	0	\N
104	764	281	23760	\N	0	\N
105	764	224	91347	\N	0	\N
106	764	285	799	\N	0	\N
107	764	54	2	\N	0	\N
108	764	7	4961	\N	0	\N
109	764	277	4291	\N	0	\N
110	764	37	754107	\N	0	\N
111	764	82	31636	\N	0	\N
112	764	113	5	\N	0	\N
113	764	278	1	\N	0	\N
114	764	188	1	\N	0	\N
115	764	160	27	\N	0	\N
116	765	114	5	\N	0	\N
117	765	79	53152	\N	0	\N
118	765	283	60487	\N	0	\N
119	765	62	3793	\N	0	\N
120	765	219	96397	\N	0	\N
121	765	174	8427	\N	0	\N
122	765	278	2	\N	0	\N
123	765	111	87	\N	0	\N
124	765	90	247421	\N	0	\N
125	765	232	50	\N	0	\N
126	765	143	1	\N	0	\N
127	765	135	54788	\N	0	\N
128	765	145	15	\N	0	\N
129	765	154	1	\N	0	\N
130	765	103	2	\N	0	\N
131	765	22	23926	\N	0	\N
132	765	171	61226	\N	0	\N
133	765	109	53152	\N	0	\N
134	765	221	3540	\N	0	\N
135	765	93	2144	\N	0	\N
136	765	229	4	\N	0	\N
137	765	33	2	\N	0	\N
138	765	204	8	\N	0	\N
139	765	251	4778248	\N	1	\N
140	765	89	24122	\N	0	\N
141	765	282	978197	\N	0	\N
142	765	250	45312	\N	0	\N
143	765	54	3	\N	0	\N
144	765	191	7512	\N	0	\N
145	765	235	38057	\N	0	\N
146	765	242	6	\N	0	\N
147	765	200	1	\N	0	\N
148	765	156	8484	\N	0	\N
149	765	91	5	\N	0	\N
150	765	74	1	\N	0	\N
151	765	187	9	\N	0	\N
152	765	279	91890	\N	0	\N
153	765	41	1	\N	0	\N
154	765	163	446	\N	0	\N
155	765	144	22	\N	0	\N
156	765	126	1132543	\N	0	\N
157	765	210	977158	\N	0	\N
158	765	3	2958	\N	0	\N
159	765	101	1320	\N	0	\N
160	765	8	81816	\N	0	\N
161	765	197	166120	\N	0	\N
162	765	196	301	\N	0	\N
163	765	266	11	\N	0	\N
164	766	275	3759	\N	0	\N
165	766	112	378703	\N	0	\N
166	766	153	43567	\N	0	\N
167	766	145	13	\N	0	\N
168	766	227	1	\N	0	\N
169	766	262	405	\N	0	\N
170	766	8	1	\N	0	\N
171	766	255	2	\N	0	\N
172	766	278	405128	\N	0	\N
173	766	157	24079	\N	0	\N
174	766	143	3	\N	0	\N
175	766	56	3731	\N	0	\N
176	766	120	1	\N	0	\N
177	766	111	5	\N	0	\N
178	766	187	1	\N	0	\N
179	766	66	1	\N	0	\N
180	766	290	10823	\N	0	\N
181	766	115	39848	\N	0	\N
182	766	188	4	\N	0	\N
183	766	246	17491	\N	0	\N
184	766	23	44407	\N	0	\N
185	766	33	4	\N	0	\N
186	766	11	1	\N	0	\N
187	766	149	1	\N	0	\N
188	766	68	95105	\N	0	\N
189	766	74	132500	\N	0	\N
190	766	118	418468	\N	0	\N
191	766	202	51760	\N	0	\N
192	766	57	3861	\N	0	\N
193	766	229	4	\N	0	\N
194	766	83	113400	\N	0	\N
195	766	171	1	\N	0	\N
196	766	251	3	\N	0	\N
197	766	15	1	\N	0	\N
198	766	206	2	\N	0	\N
199	766	49	65135	\N	0	\N
200	766	128	419	\N	0	\N
201	766	205	3604	\N	0	\N
202	766	135	1	\N	0	\N
203	766	55	2	\N	0	\N
204	766	159	109705	\N	0	\N
205	766	195	298703	\N	0	\N
206	766	76	213533	\N	0	\N
207	766	169	73621	\N	0	\N
208	766	13	91937	\N	0	\N
209	766	220	12262	\N	0	\N
210	766	228	7758	\N	0	\N
211	766	103	3	\N	0	\N
212	766	54	3422319	\N	1	\N
213	766	119	233176	\N	0	\N
214	766	139	1	\N	0	\N
215	766	109	2	\N	0	\N
216	766	150	5373	\N	0	\N
217	766	256	21583	\N	0	\N
218	766	65	56175	\N	0	\N
219	766	129	11624	\N	0	\N
220	766	75	27866	\N	0	\N
221	766	81	3439	\N	0	\N
222	766	249	1	\N	0	\N
223	766	97	113	\N	0	\N
224	766	40	1	\N	0	\N
225	767	222	251585	\N	0	\N
226	767	271	43188	\N	0	\N
227	767	201	34452	\N	0	\N
228	767	125	6322	\N	0	\N
229	767	146	2102	\N	0	\N
230	767	63	11148	\N	0	\N
231	767	36	14833	\N	0	\N
232	767	47	3664	\N	0	\N
233	767	137	8340	\N	0	\N
234	767	237	169772	\N	0	\N
235	767	207	30801	\N	0	\N
236	767	35	15526	\N	0	\N
237	767	148	2921	\N	0	\N
238	767	168	68386	\N	0	\N
239	767	73	40290	\N	0	\N
240	767	192	864	\N	0	\N
241	767	118	1	\N	0	\N
242	767	208	178450	\N	0	\N
243	767	123	16767	\N	0	\N
244	767	180	190265	\N	0	\N
245	767	177	17271	\N	0	\N
246	767	9	2099	\N	0	\N
247	767	170	27248	\N	0	\N
248	767	185	6076	\N	0	\N
249	767	281	23760	\N	0	\N
250	767	102	10800	\N	0	\N
251	767	255	1	\N	0	\N
252	767	113	53337	\N	0	\N
253	767	155	39228	\N	0	\N
254	767	276	26660	\N	0	\N
255	767	134	27454	\N	0	\N
256	767	127	1337	\N	0	\N
257	767	165	5067	\N	0	\N
258	767	30	3502	\N	0	\N
259	767	29	9021	\N	0	\N
260	767	18	11180	\N	0	\N
261	767	58	1738	\N	0	\N
262	767	54	2	\N	0	\N
263	767	108	18592	\N	0	\N
264	767	109	157861	\N	0	\N
265	767	238	14453	\N	0	\N
266	767	288	6514	\N	0	\N
267	767	218	14245	\N	0	\N
268	767	34	3161	\N	0	\N
269	767	80	1	\N	0	\N
270	767	27	3	\N	0	\N
271	767	55	2321108	\N	1	\N
272	767	46	139906	\N	0	\N
273	767	179	104349	\N	0	\N
274	767	66	21979	\N	0	\N
275	767	254	25928	\N	0	\N
276	767	257	8243	\N	0	\N
277	767	92	6256	\N	0	\N
278	767	252	5712	\N	0	\N
279	767	25	7010	\N	0	\N
280	767	61	115441	\N	0	\N
281	767	247	18410	\N	0	\N
282	767	19	16736	\N	0	\N
283	767	86	28577	\N	0	\N
284	767	178	25205	\N	0	\N
285	767	42	4380	\N	0	\N
286	767	12	6275	\N	0	\N
287	767	37	134100	\N	0	\N
288	767	17	5856	\N	0	\N
289	767	189	307	\N	0	\N
290	767	11	92878	\N	0	\N
291	767	142	15373	\N	0	\N
292	767	199	35399	\N	0	\N
293	767	133	114343	\N	0	\N
294	767	274	4322	\N	0	\N
295	767	20	28680	\N	0	\N
296	767	31	25208	\N	0	\N
297	767	147	13551	\N	0	\N
298	767	287	992	\N	0	\N
299	767	39	13409	\N	0	\N
300	767	136	6	\N	0	\N
301	767	5	484	\N	0	\N
302	767	145	1	\N	0	\N
303	767	76	1	\N	0	\N
304	768	145	1300433	\N	1	\N
305	768	140	7797	\N	0	\N
306	768	24	83872	\N	0	\N
307	768	198	59993	\N	0	\N
308	768	187	23859	\N	0	\N
309	768	114	3	\N	0	\N
310	768	85	10156	\N	0	\N
311	768	15	1909	\N	0	\N
312	768	118	1	\N	0	\N
313	768	278	4	\N	0	\N
314	768	195	4	\N	0	\N
315	768	183	1	\N	0	\N
316	768	272	24248	\N	0	\N
317	768	45	13989	\N	0	\N
318	768	109	11814	\N	0	\N
319	768	206	48058	\N	0	\N
320	768	182	660	\N	0	\N
321	768	54	13	\N	0	\N
322	768	286	246	\N	0	\N
323	768	124	588	\N	0	\N
324	768	81	4	\N	0	\N
325	768	43	7281	\N	0	\N
326	768	197	1	\N	0	\N
327	768	171	1	\N	0	\N
328	768	132	24	\N	0	\N
329	768	273	14027	\N	0	\N
330	768	120	5	\N	0	\N
331	768	227	36753	\N	0	\N
332	768	33	1	\N	0	\N
333	768	194	5	\N	0	\N
334	768	175	1	\N	0	\N
335	768	141	21576	\N	0	\N
336	768	200	34519	\N	0	\N
337	768	91	3	\N	0	\N
338	768	229	66781	\N	0	\N
339	768	269	1650	\N	0	\N
340	768	162	77	\N	0	\N
341	768	50	3	\N	0	\N
342	768	226	1	\N	0	\N
343	768	242	5	\N	0	\N
344	768	139	5	\N	0	\N
345	768	280	61809	\N	0	\N
346	768	186	11814	\N	0	\N
347	768	78	1955	\N	0	\N
348	768	126	13	\N	0	\N
349	768	55	1	\N	0	\N
350	768	212	322	\N	0	\N
351	768	131	173	\N	0	\N
352	768	51	541	\N	0	\N
353	768	233	5771	\N	0	\N
354	768	184	707	\N	0	\N
355	768	259	22	\N	0	\N
356	768	84	1530	\N	0	\N
357	768	40	2277	\N	0	\N
358	768	16	478	\N	0	\N
359	768	232	1	\N	0	\N
360	768	203	308	\N	0	\N
361	768	261	1	\N	0	\N
362	768	251	15	\N	0	\N
363	768	23	1	\N	0	\N
364	768	111	463	\N	0	\N
365	768	236	128038	\N	0	\N
366	768	166	48009	\N	0	\N
367	768	244	1303	\N	0	\N
368	768	245	212	\N	0	\N
369	768	48	122012	\N	0	\N
370	768	190	128	\N	0	\N
371	768	143	84816	\N	0	\N
372	768	80	2050	\N	0	\N
373	768	231	11384	\N	0	\N
374	768	263	29	\N	0	\N
375	768	252	1	\N	0	\N
376	769	32	99479	\N	0	\N
377	769	105	13293	\N	0	\N
378	769	223	2277	\N	0	\N
379	769	230	7258	\N	0	\N
380	769	77	1	\N	0	\N
381	769	173	3	\N	0	\N
382	769	171	2	\N	0	\N
383	769	145	1	\N	0	\N
384	769	251	2	\N	0	\N
385	769	103	60906	\N	0	\N
386	769	261	104556	\N	0	\N
387	769	249	549908	\N	0	\N
388	769	152	1	\N	0	\N
389	769	278	1	\N	0	\N
390	769	234	203949	\N	0	\N
391	769	54	4	\N	0	\N
392	769	21	217362	\N	0	\N
393	769	60	1	\N	0	\N
394	769	231	1	\N	0	\N
395	769	188	2	\N	0	\N
396	769	33	1274717	\N	1	\N
397	769	74	3	\N	0	\N
398	769	67	9163	\N	0	\N
399	769	44	4774	\N	0	\N
400	769	139	6	\N	0	\N
401	769	111	2	\N	0	\N
402	770	120	90029	\N	0	\N
403	770	152	23729	\N	0	\N
404	770	139	708848	\N	1	\N
405	770	176	11609	\N	0	\N
406	770	145	5	\N	0	\N
407	770	249	6	\N	0	\N
408	770	173	143276	\N	0	\N
409	770	24	5	\N	0	\N
410	770	77	12374	\N	0	\N
411	770	54	1	\N	0	\N
412	770	118	1	\N	0	\N
413	770	284	20303	\N	0	\N
414	770	88	8127	\N	0	\N
415	770	59	51394	\N	0	\N
416	770	109	1	\N	0	\N
417	770	110	18959	\N	0	\N
418	770	60	54334	\N	0	\N
419	770	255	1	\N	0	\N
420	770	33	6	\N	0	\N
421	771	197	4	\N	0	\N
422	771	242	2	\N	0	\N
423	771	126	1	\N	0	\N
424	771	114	99621	\N	0	\N
425	771	111	3	\N	0	\N
426	771	251	5	\N	0	\N
427	771	104	1509	\N	0	\N
428	771	145	3	\N	0	\N
429	771	229	2	\N	0	\N
430	771	91	125388	\N	1	\N
431	771	187	1	\N	0	\N
432	771	194	1	\N	0	\N
433	772	70	1546	\N	1	\N
434	773	54	1	\N	0	\N
435	773	149	9069126	\N	1	\N
436	773	204	2	\N	0	\N
437	773	112	1	\N	0	\N
438	773	111	9069126	\N	0	\N
439	774	109	1830201	\N	0	\N
440	774	54	2	\N	0	\N
441	774	55	1	\N	0	\N
442	774	88	1	\N	0	\N
443	774	255	1830201	\N	1	\N
444	774	139	1	\N	0	\N
445	774	167	6	\N	0	\N
446	774	153	1	\N	0	\N
447	774	278	1	\N	0	\N
448	774	180	1	\N	0	\N
449	775	109	1536812	\N	0	\N
450	775	209	1536812	\N	1	\N
451	776	210	1	\N	0	\N
452	776	111	86	\N	0	\N
453	776	144	22	\N	0	\N
454	776	251	1132543	\N	0	\N
455	776	282	17	\N	0	\N
456	776	232	50	\N	0	\N
457	776	126	1132543	\N	1	\N
458	776	219	34	\N	0	\N
459	776	143	1	\N	0	\N
460	776	242	5	\N	0	\N
461	776	187	9	\N	0	\N
462	776	204	8	\N	0	\N
463	776	114	1	\N	0	\N
464	776	229	2	\N	0	\N
465	776	191	2	\N	0	\N
466	776	279	4	\N	0	\N
467	776	145	13	\N	0	\N
468	776	90	6	\N	0	\N
469	776	200	1	\N	0	\N
470	776	91	1	\N	0	\N
471	776	154	1	\N	0	\N
472	777	282	978197	\N	1	\N
473	777	251	978197	\N	0	\N
474	777	90	5	\N	0	\N
475	777	210	15	\N	0	\N
476	777	126	17	\N	0	\N
477	777	219	1	\N	0	\N
478	778	219	5	\N	0	\N
479	778	126	1	\N	0	\N
480	778	90	2	\N	0	\N
481	778	210	977158	\N	1	\N
482	778	8	1	\N	0	\N
483	778	251	977158	\N	0	\N
484	778	282	15	\N	0	\N
485	778	279	1	\N	0	\N
486	779	168	68386	\N	0	\N
487	779	247	18410	\N	0	\N
488	779	6	297060	\N	0	\N
489	779	37	754107	\N	1	\N
490	779	260	34452	\N	0	\N
491	779	109	754107	\N	0	\N
492	779	117	9952	\N	0	\N
493	779	73	40290	\N	0	\N
494	779	248	27668	\N	0	\N
495	779	136	220113	\N	0	\N
496	779	25	7010	\N	0	\N
497	779	26	15	\N	0	\N
498	779	122	30612	\N	0	\N
499	779	55	134100	\N	0	\N
500	779	113	5	\N	0	\N
501	780	60	1	\N	0	\N
502	780	77	1	\N	0	\N
503	780	261	2	\N	0	\N
504	780	21	5	\N	0	\N
505	780	139	6	\N	0	\N
506	780	234	3	\N	0	\N
507	780	54	1	\N	0	\N
508	780	33	549908	\N	0	\N
509	780	249	549908	\N	1	\N
510	780	152	1	\N	0	\N
511	780	278	1	\N	0	\N
512	780	173	3	\N	0	\N
513	780	67	1	\N	0	\N
514	780	32	5	\N	0	\N
515	781	111	441450	\N	0	\N
516	781	143	3	\N	0	\N
517	781	251	6	\N	0	\N
518	781	145	5	\N	0	\N
519	781	233	1	\N	0	\N
520	781	126	5	\N	0	\N
521	781	91	2	\N	0	\N
522	781	219	1	\N	0	\N
523	781	114	2	\N	0	\N
524	781	242	441450	\N	1	\N
525	781	200	1	\N	0	\N
526	782	145	1	\N	0	\N
527	782	66	1	\N	0	\N
528	782	54	418468	\N	0	\N
529	782	139	1	\N	0	\N
530	782	118	418468	\N	1	\N
531	782	227	1	\N	0	\N
532	782	55	1	\N	0	\N
533	782	120	1	\N	0	\N
534	783	54	405128	\N	0	\N
535	783	278	405128	\N	1	\N
536	783	33	1	\N	0	\N
537	783	249	1	\N	0	\N
538	783	109	1	\N	0	\N
539	783	15	1	\N	0	\N
540	783	255	1	\N	0	\N
541	783	251	2	\N	0	\N
542	783	135	1	\N	0	\N
543	783	143	3	\N	0	\N
544	783	8	1	\N	0	\N
545	783	145	4	\N	0	\N
546	784	220	1	\N	0	\N
547	784	13	2	\N	0	\N
548	784	195	2	\N	0	\N
549	784	54	378703	\N	0	\N
550	784	149	1	\N	0	\N
551	784	256	1	\N	0	\N
552	784	129	1	\N	0	\N
553	784	111	1	\N	0	\N
554	784	112	378703	\N	1	\N
555	785	187	1	\N	0	\N
556	785	54	298703	\N	0	\N
557	785	195	298703	\N	1	\N
558	785	229	3	\N	0	\N
559	785	112	2	\N	0	\N
560	785	145	4	\N	0	\N
561	786	37	297060	\N	0	\N
562	786	109	297060	\N	0	\N
563	786	248	1	\N	0	\N
564	786	6	297060	\N	1	\N
565	786	260	1	\N	0	\N
566	787	201	1	\N	0	\N
567	787	208	2	\N	0	\N
568	787	46	1	\N	0	\N
569	787	55	251585	\N	0	\N
570	787	222	251585	\N	1	\N
571	787	113	3	\N	0	\N
572	788	282	5	\N	0	\N
573	788	210	2	\N	0	\N
574	788	219	3	\N	0	\N
575	788	90	247421	\N	1	\N
576	788	251	247421	\N	0	\N
577	788	126	6	\N	0	\N
578	789	119	233176	\N	1	\N
579	789	54	233176	\N	0	\N
580	790	37	220113	\N	0	\N
581	790	113	5	\N	0	\N
582	790	136	220113	\N	1	\N
583	790	109	220113	\N	0	\N
584	790	55	6	\N	0	\N
585	790	25	1	\N	0	\N
586	791	33	217362	\N	0	\N
587	791	249	5	\N	0	\N
588	791	21	217362	\N	1	\N
589	791	32	2	\N	0	\N
590	791	261	1	\N	0	\N
591	792	54	213533	\N	0	\N
592	792	11	1	\N	0	\N
593	792	55	1	\N	0	\N
594	792	76	213533	\N	1	\N
595	793	249	3	\N	0	\N
596	793	33	203949	\N	0	\N
597	793	234	203949	\N	1	\N
598	794	237	1	\N	0	\N
599	794	109	1	\N	0	\N
600	794	133	2	\N	0	\N
601	794	180	190265	\N	1	\N
602	794	255	1	\N	0	\N
603	794	55	190265	\N	0	\N
604	795	46	2	\N	0	\N
605	795	123	1	\N	0	\N
606	795	222	2	\N	0	\N
607	795	55	178450	\N	0	\N
608	795	208	178450	\N	1	\N
609	796	180	1	\N	0	\N
610	796	177	1	\N	0	\N
611	796	55	169772	\N	0	\N
612	796	237	169772	\N	1	\N
613	797	72	168152	\N	1	\N
614	797	109	168152	\N	0	\N
615	798	197	166120	\N	1	\N
616	798	91	4	\N	0	\N
617	798	251	166120	\N	0	\N
618	798	22	1	\N	0	\N
619	798	145	1	\N	0	\N
620	798	229	1	\N	0	\N
621	798	114	4	\N	0	\N
622	798	221	5	\N	0	\N
623	799	111	149835	\N	0	\N
624	799	225	149835	\N	1	\N
625	800	173	143276	\N	1	\N
626	800	249	3	\N	0	\N
627	800	152	2	\N	0	\N
628	800	139	143276	\N	0	\N
629	800	33	3	\N	0	\N
630	801	66	1	\N	0	\N
631	801	61	1	\N	0	\N
632	801	123	1	\N	0	\N
633	801	207	1	\N	0	\N
634	801	179	1	\N	0	\N
635	801	142	1	\N	0	\N
636	801	46	139906	\N	1	\N
637	801	222	1	\N	0	\N
638	801	208	2	\N	0	\N
639	801	254	1	\N	0	\N
640	801	55	139906	\N	0	\N
641	801	113	1	\N	0	\N
642	802	251	1	\N	0	\N
643	802	188	4	\N	0	\N
644	802	54	132500	\N	0	\N
645	802	111	4	\N	0	\N
646	802	74	132500	\N	1	\N
647	802	103	3	\N	0	\N
648	802	33	3	\N	0	\N
649	802	171	1	\N	0	\N
650	803	145	128038	\N	0	\N
651	803	236	128038	\N	1	\N
652	803	226	1	\N	0	\N
653	803	111	1	\N	0	\N
654	803	143	1	\N	0	\N
655	803	198	1	\N	0	\N
656	803	200	8	\N	0	\N
657	804	145	122012	\N	0	\N
658	804	48	122012	\N	1	\N
659	805	55	115441	\N	0	\N
660	805	46	1	\N	0	\N
661	805	61	115441	\N	1	\N
662	806	133	114343	\N	1	\N
663	806	180	2	\N	0	\N
664	806	55	114343	\N	0	\N
665	807	54	113400	\N	0	\N
666	807	83	113400	\N	1	\N
667	808	54	109705	\N	0	\N
668	808	159	109705	\N	1	\N
669	809	261	104556	\N	1	\N
670	809	249	2	\N	0	\N
671	809	32	4	\N	0	\N
672	809	33	104556	\N	0	\N
673	809	145	1	\N	0	\N
674	809	231	1	\N	0	\N
675	809	21	1	\N	0	\N
676	810	46	1	\N	0	\N
677	810	55	104349	\N	0	\N
678	810	58	2	\N	0	\N
679	810	179	104349	\N	1	\N
680	811	242	2	\N	0	\N
681	811	145	3	\N	0	\N
682	811	114	99621	\N	1	\N
683	811	194	1	\N	0	\N
684	811	91	99621	\N	0	\N
685	811	187	1	\N	0	\N
686	811	111	3	\N	0	\N
687	811	251	5	\N	0	\N
688	811	197	4	\N	0	\N
689	811	229	2	\N	0	\N
690	811	126	1	\N	0	\N
691	812	21	2	\N	0	\N
692	812	32	99479	\N	1	\N
693	812	261	4	\N	0	\N
694	812	33	99479	\N	0	\N
695	812	249	5	\N	0	\N
696	813	219	96397	\N	1	\N
697	813	242	1	\N	0	\N
698	813	251	96397	\N	0	\N
699	813	126	34	\N	0	\N
700	813	210	5	\N	0	\N
701	813	282	1	\N	0	\N
702	813	90	3	\N	0	\N
703	813	111	1	\N	0	\N
704	813	279	4	\N	0	\N
705	814	54	95105	\N	0	\N
706	814	68	95105	\N	1	\N
707	815	55	92878	\N	0	\N
708	815	54	1	\N	0	\N
709	815	76	1	\N	0	\N
710	815	11	92878	\N	1	\N
711	816	54	91937	\N	0	\N
712	816	112	2	\N	0	\N
713	816	13	91937	\N	1	\N
714	817	219	4	\N	0	\N
715	817	251	91890	\N	0	\N
716	817	126	4	\N	0	\N
717	817	279	91890	\N	1	\N
718	817	210	1	\N	0	\N
719	818	109	91347	\N	0	\N
720	818	82	6	\N	0	\N
721	818	224	91347	\N	1	\N
722	819	176	2	\N	0	\N
723	819	120	90029	\N	1	\N
724	819	24	5	\N	0	\N
725	819	118	1	\N	0	\N
726	819	152	1	\N	0	\N
727	819	145	5	\N	0	\N
728	819	54	1	\N	0	\N
729	819	139	90029	\N	0	\N
730	820	107	88703	\N	1	\N
731	820	109	88703	\N	0	\N
732	821	143	84816	\N	1	\N
733	821	111	3	\N	0	\N
734	821	54	3	\N	0	\N
735	821	251	1	\N	0	\N
736	821	126	1	\N	0	\N
737	821	200	1	\N	0	\N
738	821	145	84816	\N	0	\N
739	821	278	3	\N	0	\N
740	821	236	1	\N	0	\N
741	821	242	3	\N	0	\N
742	822	145	83872	\N	0	\N
743	822	24	83872	\N	1	\N
744	822	120	5	\N	0	\N
745	822	139	5	\N	0	\N
746	823	8	81816	\N	1	\N
747	823	278	1	\N	0	\N
748	823	210	1	\N	0	\N
749	823	54	1	\N	0	\N
750	823	251	81816	\N	0	\N
751	824	188	76766	\N	1	\N
752	824	54	4	\N	0	\N
753	824	33	2	\N	0	\N
754	824	109	1	\N	0	\N
755	824	41	1	\N	0	\N
756	824	111	76766	\N	0	\N
757	824	74	4	\N	0	\N
758	824	230	2	\N	0	\N
759	825	169	73621	\N	1	\N
760	825	157	23	\N	0	\N
761	825	54	73621	\N	0	\N
762	825	65	2	\N	0	\N
763	826	168	68386	\N	1	\N
764	826	37	68386	\N	0	\N
765	826	25	1	\N	0	\N
766	826	109	68386	\N	0	\N
767	826	55	68386	\N	0	\N
768	827	251	4	\N	0	\N
769	827	272	1	\N	0	\N
770	827	171	1	\N	0	\N
771	827	81	1	\N	0	\N
772	827	229	66782	\N	1	\N
773	827	85	2	\N	0	\N
774	827	54	4	\N	0	\N
775	827	114	2	\N	0	\N
776	827	145	66781	\N	0	\N
777	827	194	5	\N	0	\N
778	827	91	2	\N	0	\N
779	827	195	3	\N	0	\N
780	827	232	1	\N	0	\N
781	827	206	2	\N	0	\N
782	827	187	7	\N	0	\N
783	827	227	1	\N	0	\N
784	827	197	1	\N	0	\N
785	827	111	7	\N	0	\N
786	827	166	2	\N	0	\N
787	827	126	2	\N	0	\N
788	828	54	65135	\N	0	\N
789	828	49	65135	\N	1	\N
790	829	280	61809	\N	1	\N
791	829	145	61809	\N	0	\N
792	830	251	61226	\N	0	\N
793	830	54	1	\N	0	\N
794	830	103	2	\N	0	\N
795	830	171	61226	\N	1	\N
796	830	145	1	\N	0	\N
797	830	74	1	\N	0	\N
798	830	33	2	\N	0	\N
799	830	229	1	\N	0	\N
800	831	74	3	\N	0	\N
801	831	54	3	\N	0	\N
802	831	171	2	\N	0	\N
803	831	33	60906	\N	0	\N
804	831	251	2	\N	0	\N
805	831	103	60906	\N	1	\N
806	832	283	60487	\N	1	\N
807	832	251	60487	\N	0	\N
808	833	236	1	\N	0	\N
809	833	145	59993	\N	0	\N
810	833	200	1	\N	0	\N
811	833	198	59993	\N	1	\N
812	834	65	56175	\N	1	\N
813	834	169	2	\N	0	\N
814	834	157	2	\N	0	\N
815	834	54	56175	\N	0	\N
816	835	278	1	\N	0	\N
817	835	251	54788	\N	0	\N
818	835	135	54788	\N	1	\N
819	835	54	1	\N	0	\N
820	836	77	2	\N	0	\N
821	836	33	1	\N	0	\N
822	836	152	2	\N	0	\N
823	836	110	1	\N	0	\N
824	836	60	54334	\N	1	\N
825	836	139	54334	\N	0	\N
826	836	249	1	\N	0	\N
827	837	46	1	\N	0	\N
828	837	136	5	\N	0	\N
829	837	109	5	\N	0	\N
830	837	55	53337	\N	0	\N
831	837	113	53337	\N	1	\N
832	837	37	5	\N	0	\N
833	837	31	1	\N	0	\N
834	837	222	3	\N	0	\N
835	838	109	53152	\N	0	\N
836	838	251	53152	\N	0	\N
837	838	79	53152	\N	1	\N
838	838	41	1	\N	0	\N
839	839	54	51760	\N	0	\N
840	839	202	51760	\N	1	\N
841	840	59	51394	\N	1	\N
842	840	139	51394	\N	0	\N
843	840	176	1	\N	0	\N
844	841	145	48058	\N	0	\N
845	841	229	2	\N	0	\N
846	841	206	48058	\N	1	\N
847	841	40	1	\N	0	\N
848	841	81	2	\N	0	\N
849	841	140	1	\N	0	\N
850	841	54	2	\N	0	\N
851	841	200	1	\N	0	\N
852	842	166	48009	\N	1	\N
853	842	229	2	\N	0	\N
854	842	227	1	\N	0	\N
855	842	145	48009	\N	0	\N
856	842	111	1	\N	0	\N
857	842	175	1	\N	0	\N
858	842	85	1	\N	0	\N
859	843	251	45312	\N	0	\N
860	843	250	45312	\N	1	\N
861	844	54	44407	\N	0	\N
862	844	23	44408	\N	1	\N
863	844	145	1	\N	0	\N
864	844	75	1	\N	0	\N
865	845	256	1	\N	0	\N
866	845	54	43567	\N	0	\N
867	845	153	43567	\N	1	\N
868	845	255	1	\N	0	\N
869	845	109	1	\N	0	\N
870	846	55	43188	\N	0	\N
871	846	271	43188	\N	1	\N
872	847	73	40290	\N	1	\N
873	847	109	40290	\N	0	\N
874	847	37	40290	\N	0	\N
875	847	55	40290	\N	0	\N
876	848	115	39848	\N	1	\N
877	848	54	39848	\N	0	\N
878	849	126	22	\N	0	\N
879	849	251	22	\N	0	\N
880	849	144	39303	\N	1	\N
881	849	111	39303	\N	0	\N
882	849	87	5	\N	0	\N
883	850	55	39228	\N	0	\N
884	850	155	39228	\N	1	\N
885	851	191	7	\N	0	\N
886	851	235	38057	\N	1	\N
887	851	251	38057	\N	0	\N
888	852	227	36753	\N	1	\N
889	852	145	36753	\N	0	\N
890	852	166	1	\N	0	\N
891	852	54	1	\N	0	\N
892	852	229	1	\N	0	\N
893	852	118	1	\N	0	\N
894	853	199	35399	\N	1	\N
895	853	55	35399	\N	0	\N
896	854	111	1	\N	0	\N
897	854	236	8	\N	0	\N
898	854	126	1	\N	0	\N
899	854	187	2	\N	0	\N
900	854	242	1	\N	0	\N
901	854	251	1	\N	0	\N
902	854	145	34519	\N	0	\N
903	854	200	34519	\N	1	\N
904	854	198	1	\N	0	\N
905	854	143	1	\N	0	\N
906	854	206	1	\N	0	\N
907	855	201	34452	\N	1	\N
908	855	222	1	\N	0	\N
909	855	55	34452	\N	0	\N
910	856	260	34452	\N	1	\N
911	856	109	34452	\N	0	\N
912	856	6	1	\N	0	\N
913	856	37	34452	\N	0	\N
914	857	82	31636	\N	1	\N
915	857	224	6	\N	0	\N
916	857	109	31636	\N	0	\N
917	858	207	30801	\N	1	\N
918	858	55	30801	\N	0	\N
919	858	46	1	\N	0	\N
920	859	109	30612	\N	0	\N
921	859	37	30612	\N	0	\N
922	859	122	30612	\N	1	\N
923	860	109	30086	\N	0	\N
924	860	172	30086	\N	1	\N
925	860	71	1	\N	0	\N
926	861	251	1	\N	0	\N
927	861	41	29224	\N	1	\N
928	861	109	29224	\N	0	\N
929	861	188	1	\N	0	\N
930	861	111	1	\N	0	\N
931	861	79	1	\N	0	\N
932	862	63	1	\N	0	\N
933	862	20	28680	\N	1	\N
934	862	55	28680	\N	0	\N
935	863	86	28577	\N	1	\N
936	863	55	28577	\N	0	\N
937	864	23	1	\N	0	\N
938	864	54	27866	\N	0	\N
939	864	75	27866	\N	1	\N
940	865	109	27668	\N	0	\N
941	865	37	27668	\N	0	\N
942	865	248	27668	\N	1	\N
943	865	6	1	\N	0	\N
944	866	134	27454	\N	1	\N
945	866	55	27454	\N	0	\N
946	867	170	27248	\N	1	\N
947	867	55	27248	\N	0	\N
948	868	154	26677	\N	1	\N
949	868	251	1	\N	0	\N
950	868	111	26677	\N	0	\N
951	868	126	1	\N	0	\N
952	869	55	26660	\N	0	\N
953	869	276	26660	\N	1	\N
954	870	46	1	\N	0	\N
955	870	55	25928	\N	0	\N
956	870	254	25928	\N	1	\N
957	871	113	1	\N	0	\N
958	871	31	25208	\N	1	\N
959	871	55	25208	\N	0	\N
960	872	178	25205	\N	1	\N
961	872	55	25205	\N	0	\N
962	873	272	24248	\N	1	\N
963	873	145	24248	\N	0	\N
964	873	229	1	\N	0	\N
965	873	124	1	\N	0	\N
966	874	167	24214	\N	1	\N
967	874	255	6	\N	0	\N
968	874	109	24214	\N	0	\N
969	875	251	24122	\N	0	\N
970	875	89	24122	\N	1	\N
971	876	54	24079	\N	0	\N
972	876	157	24079	\N	1	\N
973	876	169	23	\N	0	\N
974	876	65	2	\N	0	\N
975	877	166	1	\N	0	\N
976	877	111	23978	\N	0	\N
977	877	145	1	\N	0	\N
978	877	175	23978	\N	1	\N
979	878	22	23926	\N	1	\N
980	878	251	23926	\N	0	\N
981	878	197	1	\N	0	\N
982	879	54	1	\N	0	\N
983	879	114	1	\N	0	\N
984	879	195	1	\N	0	\N
985	879	145	23859	\N	0	\N
986	879	251	9	\N	0	\N
987	879	187	23859	\N	1	\N
988	879	229	7	\N	0	\N
989	879	91	1	\N	0	\N
990	879	200	2	\N	0	\N
991	879	126	9	\N	0	\N
992	880	281	23760	\N	1	\N
993	880	55	23760	\N	0	\N
994	880	109	23760	\N	0	\N
995	881	249	1	\N	0	\N
996	881	60	2	\N	0	\N
997	881	110	1	\N	0	\N
998	881	120	1	\N	0	\N
999	881	139	23729	\N	0	\N
1000	881	173	2	\N	0	\N
1001	881	33	1	\N	0	\N
1002	881	152	23729	\N	1	\N
1003	882	109	22654	\N	0	\N
1004	882	253	22654	\N	1	\N
1005	883	109	21994	\N	0	\N
1006	883	151	21994	\N	1	\N
1007	884	238	1	\N	0	\N
1008	884	55	21979	\N	0	\N
1009	884	66	21979	\N	1	\N
1010	884	118	1	\N	0	\N
1011	884	46	1	\N	0	\N
1012	884	54	1	\N	0	\N
1013	885	256	21583	\N	1	\N
1014	885	112	1	\N	0	\N
1015	885	153	1	\N	0	\N
1016	885	54	21583	\N	0	\N
1017	886	141	21576	\N	1	\N
1018	886	145	21576	\N	0	\N
1019	887	139	20303	\N	0	\N
1020	887	284	20303	\N	1	\N
1021	888	110	18959	\N	1	\N
1022	888	139	18959	\N	0	\N
1023	888	60	1	\N	0	\N
1024	888	152	1	\N	0	\N
1025	889	108	18592	\N	1	\N
1026	889	55	18592	\N	0	\N
1027	890	55	18410	\N	0	\N
1028	890	109	18410	\N	0	\N
1029	890	247	18410	\N	1	\N
1030	890	37	18410	\N	0	\N
1031	891	54	17491	\N	0	\N
1032	891	246	17491	\N	1	\N
1033	892	55	17271	\N	0	\N
1034	892	237	1	\N	0	\N
1035	892	177	17271	\N	1	\N
1036	893	138	16782	\N	1	\N
1037	893	109	16782	\N	0	\N
1038	894	123	16767	\N	1	\N
1039	894	46	1	\N	0	\N
1040	894	55	16767	\N	0	\N
1041	894	208	1	\N	0	\N
1042	895	55	16736	\N	0	\N
1043	895	19	16736	\N	1	\N
1044	896	111	16544	\N	0	\N
1045	896	194	16544	\N	1	\N
1046	896	145	5	\N	0	\N
1047	896	114	1	\N	0	\N
1048	896	229	5	\N	0	\N
1049	896	91	1	\N	0	\N
1050	897	35	15526	\N	1	\N
1051	897	55	15526	\N	0	\N
1052	898	111	15462	\N	0	\N
1053	898	106	15462	\N	1	\N
1054	899	55	15373	\N	0	\N
1055	899	142	15373	\N	1	\N
1056	899	46	1	\N	0	\N
1057	900	36	14833	\N	1	\N
1058	900	55	14833	\N	0	\N
1059	901	66	1	\N	0	\N
1060	901	55	14453	\N	0	\N
1061	901	238	14453	\N	1	\N
1062	902	55	14245	\N	0	\N
1063	902	218	14245	\N	1	\N
1064	903	43	50	\N	0	\N
1065	903	145	14027	\N	0	\N
1066	903	273	14027	\N	1	\N
1067	904	145	13989	\N	0	\N
1068	904	45	13989	\N	1	\N
1069	905	147	13551	\N	1	\N
1070	905	55	13551	\N	0	\N
1071	906	55	13409	\N	0	\N
1072	906	39	13409	\N	1	\N
1073	907	105	13293	\N	1	\N
1074	907	33	13293	\N	0	\N
1075	908	60	2	\N	0	\N
1076	908	249	1	\N	0	\N
1077	908	77	12374	\N	1	\N
1078	908	33	1	\N	0	\N
1079	908	176	3	\N	0	\N
1080	908	139	12374	\N	0	\N
1081	909	111	12342	\N	0	\N
1082	909	121	12342	\N	1	\N
1083	910	112	1	\N	0	\N
1084	910	220	12262	\N	1	\N
1085	910	54	12262	\N	0	\N
1086	911	109	11814	\N	0	\N
1087	911	145	11814	\N	0	\N
1088	911	183	1	\N	0	\N
1089	911	186	11814	\N	1	\N
1090	912	129	11624	\N	1	\N
1091	912	112	1	\N	0	\N
1092	912	54	11624	\N	0	\N
1093	913	176	11609	\N	1	\N
1094	913	59	1	\N	0	\N
1095	913	77	3	\N	0	\N
1096	913	139	11609	\N	0	\N
1097	913	120	2	\N	0	\N
1098	914	261	1	\N	0	\N
1099	914	231	11384	\N	1	\N
1100	914	145	11384	\N	0	\N
1101	914	33	1	\N	0	\N
1102	915	18	11180	\N	1	\N
1103	915	55	11180	\N	0	\N
1104	916	55	11148	\N	0	\N
1105	916	63	11148	\N	1	\N
1106	916	20	1	\N	0	\N
1107	917	183	10848	\N	1	\N
1108	917	145	1	\N	0	\N
1109	917	109	10848	\N	0	\N
1110	917	186	1	\N	0	\N
1111	918	290	10823	\N	1	\N
1112	918	54	10823	\N	0	\N
1113	919	55	10800	\N	0	\N
1114	919	102	10800	\N	1	\N
1115	920	85	10156	\N	1	\N
1116	920	166	1	\N	0	\N
1117	920	229	2	\N	0	\N
1118	920	145	10156	\N	0	\N
1119	921	109	9952	\N	0	\N
1120	921	117	9952	\N	1	\N
1121	921	37	9952	\N	0	\N
1122	922	249	1	\N	0	\N
1123	922	33	9163	\N	0	\N
1124	922	67	9163	\N	1	\N
1125	923	29	9021	\N	1	\N
1126	923	55	9021	\N	0	\N
1127	924	226	8733	\N	1	\N
1128	924	111	8733	\N	0	\N
1129	924	236	1	\N	0	\N
1130	924	145	1	\N	0	\N
1131	925	156	8484	\N	1	\N
1132	925	251	8484	\N	0	\N
1133	926	174	8427	\N	1	\N
1134	926	251	8427	\N	0	\N
1135	927	137	8340	\N	1	\N
1136	927	55	8340	\N	0	\N
1137	928	109	8280	\N	0	\N
1138	928	10	8280	\N	1	\N
1139	929	257	8243	\N	1	\N
1140	929	55	8243	\N	0	\N
1141	930	109	1	\N	0	\N
1142	930	88	8127	\N	1	\N
1143	930	139	8127	\N	0	\N
1144	930	255	1	\N	0	\N
1145	931	145	7797	\N	0	\N
1146	931	206	1	\N	0	\N
1147	931	140	7797	\N	1	\N
1148	932	54	7758	\N	0	\N
1149	932	228	7758	\N	1	\N
1150	933	235	7	\N	0	\N
1151	933	251	7512	\N	0	\N
1152	933	126	2	\N	0	\N
1153	933	191	7512	\N	1	\N
1154	934	158	7287	\N	1	\N
1155	934	109	7287	\N	0	\N
1156	935	43	7281	\N	1	\N
1157	935	273	50	\N	0	\N
1158	935	145	7281	\N	0	\N
1159	936	33	7258	\N	0	\N
1160	936	230	7258	\N	1	\N
1161	936	188	2	\N	0	\N
1162	936	111	2	\N	0	\N
1163	937	144	5	\N	0	\N
1164	937	87	7053	\N	1	\N
1165	937	111	7053	\N	0	\N
1166	938	168	1	\N	0	\N
1167	938	55	7010	\N	0	\N
1168	938	136	1	\N	0	\N
1169	938	37	7010	\N	0	\N
1170	938	25	7010	\N	1	\N
1171	938	109	7010	\N	0	\N
1172	939	111	6865	\N	0	\N
1173	939	204	6865	\N	1	\N
1174	939	149	2	\N	0	\N
1175	939	126	8	\N	0	\N
1176	939	251	8	\N	0	\N
1177	940	55	6514	\N	0	\N
1178	940	288	6514	\N	1	\N
1179	941	55	6322	\N	0	\N
1180	941	125	6322	\N	1	\N
1181	942	12	6275	\N	1	\N
1182	942	55	6275	\N	0	\N
1183	943	55	6256	\N	0	\N
1184	943	92	6256	\N	1	\N
1185	944	185	6076	\N	1	\N
1186	944	55	6076	\N	0	\N
1187	945	287	1	\N	0	\N
1188	945	55	5856	\N	0	\N
1189	945	17	5856	\N	1	\N
1190	946	145	5771	\N	0	\N
1191	946	111	1	\N	0	\N
1192	946	233	5771	\N	1	\N
1193	946	242	1	\N	0	\N
1194	947	145	1	\N	0	\N
1195	947	252	5712	\N	1	\N
1196	947	80	1	\N	0	\N
1197	947	55	5712	\N	0	\N
1198	948	150	5373	\N	1	\N
1199	948	54	5373	\N	0	\N
1200	949	55	5067	\N	0	\N
1201	949	165	5067	\N	1	\N
1202	950	109	4961	\N	0	\N
1203	950	7	4961	\N	1	\N
1204	951	44	4774	\N	1	\N
1205	951	33	4774	\N	0	\N
1206	952	232	4583	\N	1	\N
1207	952	126	50	\N	0	\N
1208	952	251	50	\N	0	\N
1209	952	229	1	\N	0	\N
1210	952	111	4583	\N	0	\N
1211	952	145	1	\N	0	\N
1212	953	42	4380	\N	1	\N
1213	953	55	4380	\N	0	\N
1214	954	274	4322	\N	1	\N
1215	954	55	4322	\N	0	\N
1216	955	277	4291	\N	1	\N
1217	955	109	4291	\N	0	\N
1218	956	54	3861	\N	0	\N
1219	956	57	3861	\N	1	\N
1220	957	251	3793	\N	0	\N
1221	957	62	3793	\N	1	\N
1222	958	275	3759	\N	1	\N
1223	958	54	3759	\N	0	\N
1224	959	54	3731	\N	0	\N
1225	959	56	3731	\N	1	\N
1226	960	55	3664	\N	0	\N
1227	960	47	3664	\N	1	\N
1228	961	54	3604	\N	0	\N
1229	961	205	3604	\N	1	\N
1230	962	251	3540	\N	0	\N
1231	962	221	3540	\N	1	\N
1232	962	197	5	\N	0	\N
1233	963	55	3502	\N	0	\N
1234	963	30	3502	\N	1	\N
1235	964	145	4	\N	0	\N
1236	964	229	1	\N	0	\N
1237	964	81	3439	\N	1	\N
1238	964	206	2	\N	0	\N
1239	964	54	3439	\N	0	\N
1240	964	40	1	\N	0	\N
1241	965	55	3161	\N	0	\N
1242	965	34	3161	\N	1	\N
1243	966	251	2958	\N	0	\N
1244	966	3	2958	\N	1	\N
1245	967	148	2921	\N	1	\N
1246	967	55	2921	\N	0	\N
1247	968	33	2277	\N	0	\N
1248	968	223	2277	\N	1	\N
1249	969	54	1	\N	0	\N
1250	969	145	2277	\N	0	\N
1251	969	81	1	\N	0	\N
1252	969	40	2277	\N	1	\N
1253	969	206	1	\N	0	\N
1254	970	93	2144	\N	1	\N
1255	970	251	2144	\N	0	\N
1256	971	111	2133	\N	0	\N
1257	971	38	2133	\N	1	\N
1258	972	146	2102	\N	1	\N
1259	972	55	2102	\N	0	\N
1260	973	55	2099	\N	0	\N
1261	973	9	2099	\N	1	\N
1262	974	80	2050	\N	1	\N
1263	974	145	2050	\N	0	\N
1264	974	252	1	\N	0	\N
1265	974	55	1	\N	0	\N
1266	975	145	1955	\N	0	\N
1267	975	78	1955	\N	1	\N
1268	976	54	1	\N	0	\N
1269	976	278	1	\N	0	\N
1270	976	15	1909	\N	1	\N
1271	976	145	1909	\N	0	\N
1272	977	58	1738	\N	1	\N
1273	977	55	1738	\N	0	\N
1274	977	179	2	\N	0	\N
1275	978	289	1651	\N	1	\N
1276	978	111	1651	\N	0	\N
1277	979	145	1650	\N	0	\N
1278	979	269	1650	\N	1	\N
1279	980	145	1530	\N	0	\N
1280	980	84	1530	\N	1	\N
1281	981	91	1509	\N	0	\N
1282	981	104	1509	\N	1	\N
1283	982	127	1337	\N	1	\N
1284	982	55	1337	\N	0	\N
1285	983	251	1320	\N	0	\N
1286	983	101	1320	\N	1	\N
1287	984	241	1309	\N	1	\N
1288	984	111	1309	\N	0	\N
1289	985	244	1303	\N	1	\N
1290	985	145	1303	\N	0	\N
1291	986	258	1166	\N	1	\N
1292	986	109	1166	\N	0	\N
1293	987	64	1135	\N	1	\N
1294	987	109	1135	\N	0	\N
1295	988	116	1069	\N	1	\N
1296	988	111	1069	\N	0	\N
1297	989	287	992	\N	1	\N
1298	989	17	1	\N	0	\N
1299	989	55	992	\N	0	\N
1300	990	55	864	\N	0	\N
1301	990	192	864	\N	1	\N
1302	991	109	799	\N	0	\N
1303	991	285	799	\N	1	\N
1304	992	184	707	\N	1	\N
1305	992	145	707	\N	0	\N
1306	993	145	660	\N	0	\N
1307	993	182	660	\N	1	\N
1308	994	109	597	\N	0	\N
1309	994	172	1	\N	0	\N
1310	994	71	597	\N	1	\N
1311	995	124	588	\N	1	\N
1312	995	272	1	\N	0	\N
1313	995	145	588	\N	0	\N
1314	996	145	541	\N	0	\N
1315	996	51	541	\N	1	\N
1316	997	5	484	\N	1	\N
1317	997	55	484	\N	0	\N
1318	998	16	478	\N	1	\N
1319	998	145	478	\N	0	\N
1320	999	163	446	\N	1	\N
1321	999	251	446	\N	0	\N
1322	1000	111	434	\N	0	\N
1323	1000	52	434	\N	1	\N
1324	1001	128	419	\N	1	\N
1325	1001	54	419	\N	0	\N
1326	1002	54	405	\N	0	\N
1327	1002	262	405	\N	1	\N
1328	1003	111	398	\N	0	\N
1329	1003	214	398	\N	1	\N
1330	1004	14	362	\N	1	\N
1331	1004	111	362	\N	0	\N
1332	1005	212	322	\N	1	\N
1333	1005	145	322	\N	0	\N
1334	1005	111	322	\N	0	\N
1335	1006	203	308	\N	1	\N
1336	1006	145	308	\N	0	\N
1337	1007	189	307	\N	1	\N
1338	1007	55	307	\N	0	\N
1339	1008	196	301	\N	1	\N
1340	1008	251	301	\N	0	\N
1341	1009	286	246	\N	1	\N
1342	1009	145	246	\N	0	\N
1343	1010	111	227	\N	0	\N
1344	1010	4	227	\N	1	\N
1345	1011	111	221	\N	0	\N
1346	1011	193	221	\N	1	\N
1347	1012	145	212	\N	0	\N
1348	1012	245	212	\N	1	\N
1349	1013	109	194	\N	0	\N
1350	1013	243	194	\N	1	\N
1351	1014	145	173	\N	0	\N
1352	1014	131	173	\N	1	\N
1353	1015	99	166	\N	1	\N
1354	1015	111	166	\N	0	\N
1355	1016	111	132	\N	0	\N
1356	1016	264	132	\N	1	\N
1357	1017	111	128	\N	0	\N
1358	1017	190	128	\N	1	\N
1359	1017	145	128	\N	0	\N
1360	1018	54	113	\N	0	\N
1361	1018	97	113	\N	1	\N
1362	1019	95	105	\N	1	\N
1363	1019	109	105	\N	0	\N
1364	1020	162	77	\N	1	\N
1365	1020	145	77	\N	0	\N
1366	1021	109	68	\N	0	\N
1367	1021	181	68	\N	1	\N
1368	1022	263	29	\N	1	\N
1369	1022	145	29	\N	0	\N
1370	1023	109	27	\N	0	\N
1371	1023	160	27	\N	1	\N
1372	1024	213	26	\N	1	\N
1373	1024	111	26	\N	0	\N
1374	1025	132	24	\N	1	\N
1375	1025	145	24	\N	0	\N
1376	1026	145	22	\N	0	\N
1377	1026	259	22	\N	1	\N
1378	1027	94	18	\N	1	\N
1379	1027	109	18	\N	0	\N
1380	1028	109	15	\N	0	\N
1381	1028	37	15	\N	0	\N
1382	1028	26	15	\N	1	\N
1383	1029	109	14	\N	0	\N
1384	1029	240	14	\N	1	\N
1385	1030	109	11	\N	0	\N
1386	1030	100	11	\N	1	\N
1387	1031	266	11	\N	1	\N
1388	1031	251	11	\N	0	\N
1389	1033	111	5	\N	0	\N
1390	1033	53	5	\N	1	\N
1391	1034	111	5	\N	0	\N
1392	1034	211	5	\N	1	\N
1393	1036	109	5	\N	0	\N
1394	1036	130	5	\N	1	\N
1395	1037	111	5	\N	0	\N
1396	1037	215	5	\N	1	\N
1397	1038	267	2	\N	1	\N
1398	1038	111	2	\N	0	\N
1399	1039	145	3	\N	0	\N
1400	1039	50	3	\N	1	\N
1401	1040	27	3	\N	1	\N
1402	1040	55	3	\N	0	\N
1403	1041	109	2	\N	0	\N
1404	1041	239	2	\N	1	\N
1405	1042	111	2	\N	0	\N
1406	1042	69	2	\N	1	\N
1407	1043	1	2	\N	1	\N
1408	1043	109	2	\N	0	\N
1409	1044	109	2	\N	0	\N
1410	1044	265	2	\N	1	\N
1411	1045	109	1	\N	0	\N
1412	1045	98	1	\N	1	\N
1413	1048	270	1	\N	1	\N
1414	1049	216	1	\N	1	\N
1415	1050	2	1	\N	1	\N
1416	1050	111	1	\N	0	\N
1417	1051	111	11755058	\N	1	\N
1418	1051	106	15462	\N	0	\N
1419	1051	200	1	\N	0	\N
1420	1051	190	128	\N	0	\N
1421	1051	242	441450	\N	0	\N
1422	1051	194	16544	\N	0	\N
1423	1051	143	3	\N	0	\N
1424	1051	225	149835	\N	0	\N
1425	1051	204	6865	\N	0	\N
1426	1051	91	3	\N	0	\N
1427	1051	251	87	\N	0	\N
1428	1051	126	86	\N	0	\N
1429	1051	4	227	\N	0	\N
1430	1051	54	5	\N	0	\N
1431	1051	264	132	\N	0	\N
1432	1051	53	5	\N	0	\N
1433	1051	99	166	\N	0	\N
1434	1051	193	221	\N	0	\N
1435	1051	226	8733	\N	0	\N
1436	1051	121	12342	\N	0	\N
1437	1051	116	1069	\N	0	\N
1438	1051	154	26677	\N	0	\N
1439	1051	214	398	\N	0	\N
1440	1051	69	2	\N	0	\N
1441	1051	236	1	\N	0	\N
1442	1051	233	1	\N	0	\N
1443	1051	289	1651	\N	0	\N
1444	1051	38	2133	\N	0	\N
1445	1051	175	23978	\N	0	\N
1446	1051	74	4	\N	0	\N
1447	1051	188	76766	\N	0	\N
1448	1051	14	362	\N	0	\N
1449	1051	41	1	\N	0	\N
1450	1051	215	5	\N	0	\N
1451	1051	144	39303	\N	0	\N
1452	1051	52	434	\N	0	\N
1453	1051	166	1	\N	0	\N
1454	1051	109	1	\N	0	\N
1455	1051	232	4583	\N	0	\N
1456	1051	114	3	\N	0	\N
1457	1051	219	1	\N	0	\N
1458	1051	241	1309	\N	0	\N
1459	1051	145	463	\N	0	\N
1460	1051	112	1	\N	0	\N
1461	1051	87	7053	\N	0	\N
1462	1051	149	9069126	\N	0	\N
1463	1051	229	7	\N	0	\N
1464	1051	33	2	\N	0	\N
1465	1051	230	2	\N	0	\N
1466	1051	212	322	\N	0	\N
1467	1051	211	5	\N	0	\N
1468	1051	267	2	\N	0	\N
1469	1051	2	1	\N	0	\N
1470	1051	213	26	\N	0	\N
1471	1052	255	1830201	\N	0	\N
1472	1052	10	8280	\N	0	\N
1473	1052	239	2	\N	0	\N
1474	1052	7	4961	\N	0	\N
1475	1052	145	11814	\N	0	\N
1476	1052	186	11814	\N	0	\N
1477	1052	172	30086	\N	0	\N
1478	1052	122	30612	\N	0	\N
1479	1052	260	34452	\N	0	\N
1480	1052	79	53152	\N	0	\N
1481	1052	88	1	\N	0	\N
1482	1052	180	1	\N	0	\N
1483	1052	278	1	\N	0	\N
1484	1052	111	1	\N	0	\N
1485	1052	188	1	\N	0	\N
1486	1052	181	68	\N	0	\N
1487	1052	6	297060	\N	0	\N
1488	1052	109	4906174	\N	1	\N
1489	1052	258	1166	\N	0	\N
1490	1052	71	597	\N	0	\N
1491	1052	243	194	\N	0	\N
1492	1052	136	220113	\N	0	\N
1493	1052	248	27668	\N	0	\N
1494	1052	117	9952	\N	0	\N
1495	1052	41	29224	\N	0	\N
1496	1052	113	5	\N	0	\N
1497	1052	281	23760	\N	0	\N
1498	1052	224	91347	\N	0	\N
1499	1052	251	53152	\N	0	\N
1500	1052	247	18410	\N	0	\N
1501	1052	26	15	\N	0	\N
1502	1052	100	11	\N	0	\N
1503	1052	55	157861	\N	0	\N
1504	1052	285	799	\N	0	\N
1505	1052	37	754107	\N	0	\N
1506	1052	168	68386	\N	0	\N
1507	1052	98	1	\N	0	\N
1508	1052	265	2	\N	0	\N
1509	1052	72	168152	\N	0	\N
1510	1052	209	1536812	\N	0	\N
1511	1052	277	4291	\N	0	\N
1512	1052	25	7010	\N	0	\N
1513	1052	94	18	\N	0	\N
1514	1052	183	10848	\N	0	\N
1515	1052	253	22654	\N	0	\N
1516	1052	151	21994	\N	0	\N
1517	1052	139	1	\N	0	\N
1518	1052	153	1	\N	0	\N
1519	1052	240	14	\N	0	\N
1520	1052	138	16782	\N	0	\N
1521	1052	73	40290	\N	0	\N
1522	1052	130	5	\N	0	\N
1523	1052	160	27	\N	0	\N
1524	1052	107	88703	\N	0	\N
1525	1052	158	7287	\N	0	\N
1526	1052	82	31636	\N	0	\N
1527	1052	54	2	\N	0	\N
1528	1052	167	24214	\N	0	\N
1529	1052	64	1135	\N	0	\N
1530	1052	95	105	\N	0	\N
1531	1052	1	2	\N	0	\N
1532	1053	171	61226	\N	0	\N
1533	1053	109	53152	\N	0	\N
1534	1053	41	1	\N	0	\N
1535	1053	221	3540	\N	0	\N
1536	1053	74	1	\N	0	\N
1537	1053	229	4	\N	0	\N
1538	1053	250	45312	\N	0	\N
1539	1053	283	60487	\N	0	\N
1540	1053	62	3793	\N	0	\N
1541	1053	242	6	\N	0	\N
1542	1053	154	1	\N	0	\N
1543	1053	126	1132543	\N	0	\N
1544	1053	197	166120	\N	0	\N
1545	1053	91	5	\N	0	\N
1546	1053	89	24122	\N	0	\N
1547	1053	219	96397	\N	0	\N
1548	1053	22	23926	\N	0	\N
1549	1053	282	978197	\N	0	\N
1550	1053	111	87	\N	0	\N
1551	1053	33	2	\N	0	\N
1552	1053	143	1	\N	0	\N
1553	1053	135	54788	\N	0	\N
1554	1053	79	53152	\N	0	\N
1555	1053	278	2	\N	0	\N
1556	1053	3	2958	\N	0	\N
1557	1053	191	7512	\N	0	\N
1558	1053	266	11	\N	0	\N
1559	1053	251	4778248	\N	1	\N
1560	1053	8	81816	\N	0	\N
1561	1053	156	8484	\N	0	\N
1562	1053	232	50	\N	0	\N
1563	1053	200	1	\N	0	\N
1564	1053	279	91890	\N	0	\N
1565	1053	174	8427	\N	0	\N
1566	1053	93	2144	\N	0	\N
1567	1053	54	3	\N	0	\N
1568	1053	187	9	\N	0	\N
1569	1053	101	1320	\N	0	\N
1570	1053	144	22	\N	0	\N
1571	1053	103	2	\N	0	\N
1572	1053	235	38057	\N	0	\N
1573	1053	145	15	\N	0	\N
1574	1053	204	8	\N	0	\N
1575	1053	210	977158	\N	0	\N
1576	1053	114	5	\N	0	\N
1577	1053	196	301	\N	0	\N
1578	1053	163	446	\N	0	\N
1579	1053	90	247421	\N	0	\N
1580	1054	278	405128	\N	0	\N
1581	1054	23	44407	\N	0	\N
1582	1054	111	5	\N	0	\N
1583	1054	188	4	\N	0	\N
1584	1054	187	1	\N	0	\N
1585	1054	11	1	\N	0	\N
1586	1054	150	5373	\N	0	\N
1587	1054	195	298703	\N	0	\N
1588	1054	76	213533	\N	0	\N
1589	1054	246	17491	\N	0	\N
1590	1054	13	91937	\N	0	\N
1591	1054	118	418468	\N	0	\N
1592	1054	153	43567	\N	0	\N
1593	1054	145	13	\N	0	\N
1594	1054	171	1	\N	0	\N
1595	1054	15	1	\N	0	\N
1596	1054	255	2	\N	0	\N
1597	1054	159	109705	\N	0	\N
1598	1054	75	27866	\N	0	\N
1599	1054	202	51760	\N	0	\N
1600	1054	143	3	\N	0	\N
1601	1054	40	1	\N	0	\N
1602	1054	229	4	\N	0	\N
1603	1054	149	1	\N	0	\N
1604	1054	112	378703	\N	0	\N
1605	1054	68	95105	\N	0	\N
1606	1054	157	24079	\N	0	\N
1607	1054	56	3731	\N	0	\N
1608	1054	83	113400	\N	0	\N
1609	1054	205	3604	\N	0	\N
1610	1054	262	405	\N	0	\N
1611	1054	8	1	\N	0	\N
1612	1054	103	3	\N	0	\N
1613	1054	119	233176	\N	0	\N
1614	1054	55	2	\N	0	\N
1615	1054	74	132500	\N	0	\N
1616	1054	228	7758	\N	0	\N
1617	1054	227	1	\N	0	\N
1618	1054	33	4	\N	0	\N
1619	1054	251	3	\N	0	\N
1620	1054	290	10823	\N	0	\N
1621	1054	128	419	\N	0	\N
1622	1054	139	1	\N	0	\N
1623	1054	120	1	\N	0	\N
1624	1054	57	3861	\N	0	\N
1625	1054	249	1	\N	0	\N
1626	1054	49	65135	\N	0	\N
1627	1054	115	39848	\N	0	\N
1628	1054	81	3439	\N	0	\N
1629	1054	275	3759	\N	0	\N
1630	1054	256	21583	\N	0	\N
1631	1054	169	73621	\N	0	\N
1632	1054	97	113	\N	0	\N
1633	1054	206	2	\N	0	\N
1634	1054	66	1	\N	0	\N
1635	1054	54	3422319	\N	1	\N
1636	1054	65	56175	\N	0	\N
1637	1054	220	12262	\N	0	\N
1638	1054	109	2	\N	0	\N
1639	1054	129	11624	\N	0	\N
1640	1054	135	1	\N	0	\N
1641	1055	47	3664	\N	0	\N
1642	1055	276	26660	\N	0	\N
1643	1055	11	92878	\N	0	\N
1644	1055	218	14245	\N	0	\N
1645	1055	102	10800	\N	0	\N
1646	1055	61	115441	\N	0	\N
1647	1055	247	18410	\N	0	\N
1648	1055	63	11148	\N	0	\N
1649	1055	142	15373	\N	0	\N
1650	1055	92	6256	\N	0	\N
1651	1055	238	14453	\N	0	\N
1652	1055	288	6514	\N	0	\N
1653	1055	30	3502	\N	0	\N
1654	1055	34	3161	\N	0	\N
1655	1055	271	43188	\N	0	\N
1656	1055	66	21979	\N	0	\N
1657	1055	134	27454	\N	0	\N
1658	1055	177	17271	\N	0	\N
1659	1055	31	25208	\N	0	\N
1660	1055	147	13551	\N	0	\N
1661	1055	25	7010	\N	0	\N
1662	1055	17	5856	\N	0	\N
1663	1055	19	16736	\N	0	\N
1664	1055	255	1	\N	0	\N
1665	1055	36	14833	\N	0	\N
1666	1055	170	27248	\N	0	\N
1667	1055	281	23760	\N	0	\N
1668	1055	113	53337	\N	0	\N
1669	1055	222	251585	\N	0	\N
1670	1055	207	30801	\N	0	\N
1671	1055	5	484	\N	0	\N
1672	1055	155	39228	\N	0	\N
1673	1055	9	2099	\N	0	\N
1674	1055	165	5067	\N	0	\N
1675	1055	201	34452	\N	0	\N
1676	1055	18	11180	\N	0	\N
1677	1055	55	2321108	\N	1	\N
1678	1055	208	178450	\N	0	\N
1679	1055	108	18592	\N	0	\N
1680	1055	137	8340	\N	0	\N
1681	1055	42	4380	\N	0	\N
1682	1055	35	15526	\N	0	\N
1683	1055	109	157861	\N	0	\N
1684	1055	125	6322	\N	0	\N
1685	1055	39	13409	\N	0	\N
1686	1055	192	864	\N	0	\N
1687	1055	136	6	\N	0	\N
1688	1055	145	1	\N	0	\N
1689	1055	76	1	\N	0	\N
1690	1055	179	104349	\N	0	\N
1691	1055	123	16767	\N	0	\N
1692	1055	29	9021	\N	0	\N
1693	1055	146	2102	\N	0	\N
1694	1055	54	2	\N	0	\N
1695	1055	180	190265	\N	0	\N
1696	1055	237	169772	\N	0	\N
1697	1055	148	2921	\N	0	\N
1698	1055	80	1	\N	0	\N
1699	1055	118	1	\N	0	\N
1700	1055	86	28577	\N	0	\N
1701	1055	46	139906	\N	0	\N
1702	1055	254	25928	\N	0	\N
1703	1055	199	35399	\N	0	\N
1704	1055	178	25205	\N	0	\N
1705	1055	133	114343	\N	0	\N
1706	1055	12	6275	\N	0	\N
1707	1055	287	992	\N	0	\N
1708	1055	189	307	\N	0	\N
1709	1055	27	3	\N	0	\N
1710	1055	127	1337	\N	0	\N
1711	1055	274	4322	\N	0	\N
1712	1055	20	28680	\N	0	\N
1713	1055	257	8243	\N	0	\N
1714	1055	185	6076	\N	0	\N
1715	1055	252	5712	\N	0	\N
1716	1055	37	134100	\N	0	\N
1717	1055	168	68386	\N	0	\N
1718	1055	73	40290	\N	0	\N
1719	1055	58	1738	\N	0	\N
1720	1056	145	1300433	\N	1	\N
1721	1056	206	48058	\N	0	\N
1722	1056	54	13	\N	0	\N
1723	1056	118	1	\N	0	\N
1724	1056	269	1650	\N	0	\N
1725	1056	81	4	\N	0	\N
1726	1056	111	463	\N	0	\N
1727	1056	236	128038	\N	0	\N
1728	1056	182	660	\N	0	\N
1729	1056	259	22	\N	0	\N
1730	1056	132	24	\N	0	\N
1731	1056	242	5	\N	0	\N
1732	1056	139	5	\N	0	\N
1733	1056	45	13989	\N	0	\N
1734	1056	198	59993	\N	0	\N
1735	1056	184	707	\N	0	\N
1736	1056	187	23859	\N	0	\N
1737	1056	78	1955	\N	0	\N
1738	1056	252	1	\N	0	\N
1739	1056	194	5	\N	0	\N
1740	1056	124	588	\N	0	\N
1741	1056	114	3	\N	0	\N
1742	1056	84	1530	\N	0	\N
1743	1056	231	11384	\N	0	\N
1744	1056	50	3	\N	0	\N
1745	1056	33	1	\N	0	\N
1746	1056	251	15	\N	0	\N
1747	1056	197	1	\N	0	\N
1748	1056	131	173	\N	0	\N
1749	1056	140	7797	\N	0	\N
1750	1056	227	36753	\N	0	\N
1751	1056	229	66781	\N	0	\N
1752	1056	80	2050	\N	0	\N
1753	1056	40	2277	\N	0	\N
1754	1056	16	478	\N	0	\N
1755	1056	190	128	\N	0	\N
1756	1056	23	1	\N	0	\N
1757	1056	272	24248	\N	0	\N
1758	1056	273	14027	\N	0	\N
1759	1056	233	5771	\N	0	\N
1760	1056	166	48009	\N	0	\N
1761	1056	48	122012	\N	0	\N
1762	1056	91	3	\N	0	\N
1763	1056	120	5	\N	0	\N
1764	1056	24	83872	\N	0	\N
1765	1056	200	34519	\N	0	\N
1766	1056	263	29	\N	0	\N
1767	1056	261	1	\N	0	\N
1768	1056	183	1	\N	0	\N
1769	1056	143	84816	\N	0	\N
1770	1056	109	11814	\N	0	\N
1771	1056	186	11814	\N	0	\N
1772	1056	244	1303	\N	0	\N
1773	1056	212	322	\N	0	\N
1774	1056	51	541	\N	0	\N
1775	1056	43	7281	\N	0	\N
1776	1056	286	246	\N	0	\N
1777	1056	245	212	\N	0	\N
1778	1056	278	4	\N	0	\N
1779	1056	195	4	\N	0	\N
1780	1056	171	1	\N	0	\N
1781	1056	175	1	\N	0	\N
1782	1056	141	21576	\N	0	\N
1783	1056	280	61809	\N	0	\N
1784	1056	126	13	\N	0	\N
1785	1056	226	1	\N	0	\N
1786	1056	85	10156	\N	0	\N
1787	1056	15	1909	\N	0	\N
1788	1056	203	308	\N	0	\N
1789	1056	162	77	\N	0	\N
1790	1056	55	1	\N	0	\N
1791	1056	232	1	\N	0	\N
1792	1057	278	1	\N	0	\N
1793	1057	188	2	\N	0	\N
1794	1057	44	4774	\N	0	\N
1795	1057	60	1	\N	0	\N
1796	1057	21	217362	\N	0	\N
1797	1057	54	4	\N	0	\N
1798	1057	145	1	\N	0	\N
1799	1057	251	2	\N	0	\N
1800	1057	261	104556	\N	0	\N
1801	1057	234	203949	\N	0	\N
1802	1057	67	9163	\N	0	\N
1803	1057	103	60906	\N	0	\N
1804	1057	105	13293	\N	0	\N
1805	1057	223	2277	\N	0	\N
1806	1057	249	549908	\N	0	\N
1807	1057	230	7258	\N	0	\N
1808	1057	152	1	\N	0	\N
1809	1057	77	1	\N	0	\N
1810	1057	111	2	\N	0	\N
1811	1057	33	1274717	\N	1	\N
1812	1057	173	3	\N	0	\N
1813	1057	231	1	\N	0	\N
1814	1057	139	6	\N	0	\N
1815	1057	171	2	\N	0	\N
1816	1057	74	3	\N	0	\N
1817	1057	32	99479	\N	0	\N
1818	1058	139	708848	\N	1	\N
1819	1058	110	18959	\N	0	\N
1820	1058	249	6	\N	0	\N
1821	1058	88	8127	\N	0	\N
1822	1058	152	23729	\N	0	\N
1823	1058	118	1	\N	0	\N
1824	1058	109	1	\N	0	\N
1825	1058	284	20303	\N	0	\N
1826	1058	255	1	\N	0	\N
1827	1058	176	11609	\N	0	\N
1828	1058	145	5	\N	0	\N
1829	1058	59	51394	\N	0	\N
1830	1058	120	90029	\N	0	\N
1831	1058	60	54334	\N	0	\N
1832	1058	173	143276	\N	0	\N
1833	1058	54	1	\N	0	\N
1834	1058	77	12374	\N	0	\N
1835	1058	24	5	\N	0	\N
1836	1058	33	6	\N	0	\N
1837	1059	197	4	\N	0	\N
1838	1059	242	2	\N	0	\N
1839	1059	104	1509	\N	0	\N
1840	1059	111	3	\N	0	\N
1841	1059	145	3	\N	0	\N
1842	1059	114	99621	\N	0	\N
1843	1059	91	125388	\N	1	\N
1844	1059	251	5	\N	0	\N
1845	1059	229	2	\N	0	\N
1846	1059	187	1	\N	0	\N
1847	1059	126	1	\N	0	\N
1848	1059	194	1	\N	0	\N
1849	1060	70	1546	\N	1	\N
1850	1061	111	9069126	\N	0	\N
1851	1061	204	2	\N	0	\N
1852	1061	54	1	\N	0	\N
1853	1061	149	9069126	\N	1	\N
1854	1061	112	1	\N	0	\N
1855	1062	54	2	\N	0	\N
1856	1062	55	1	\N	0	\N
1857	1062	278	1	\N	0	\N
1858	1062	109	1830201	\N	0	\N
1859	1062	255	1830201	\N	1	\N
1860	1062	153	1	\N	0	\N
1861	1062	88	1	\N	0	\N
1862	1062	180	1	\N	0	\N
1863	1062	139	1	\N	0	\N
1864	1062	167	6	\N	0	\N
1865	1063	109	1536812	\N	0	\N
1866	1063	209	1536812	\N	1	\N
1867	1064	91	1	\N	0	\N
1868	1064	210	1	\N	0	\N
1869	1064	126	1132543	\N	1	\N
1870	1064	242	5	\N	0	\N
1871	1064	219	34	\N	0	\N
1872	1064	200	1	\N	0	\N
1873	1064	232	50	\N	0	\N
1874	1064	191	2	\N	0	\N
1875	1064	143	1	\N	0	\N
1876	1064	144	22	\N	0	\N
1877	1064	154	1	\N	0	\N
1878	1064	145	13	\N	0	\N
1879	1064	111	86	\N	0	\N
1880	1064	282	17	\N	0	\N
1881	1064	279	4	\N	0	\N
1882	1064	204	8	\N	0	\N
1883	1064	251	1132543	\N	0	\N
1884	1064	187	9	\N	0	\N
1885	1064	90	6	\N	0	\N
1886	1064	229	2	\N	0	\N
1887	1064	114	1	\N	0	\N
1888	1065	282	978197	\N	1	\N
1889	1065	90	5	\N	0	\N
1890	1065	126	17	\N	0	\N
1891	1065	251	978197	\N	0	\N
1892	1065	219	1	\N	0	\N
1893	1065	210	15	\N	0	\N
1894	1066	126	1	\N	0	\N
1895	1066	90	2	\N	0	\N
1896	1066	8	1	\N	0	\N
1897	1066	210	977158	\N	1	\N
1898	1066	219	5	\N	0	\N
1899	1066	282	15	\N	0	\N
1900	1066	251	977158	\N	0	\N
1901	1066	279	1	\N	0	\N
1902	1067	136	220113	\N	0	\N
1903	1067	168	68386	\N	0	\N
1904	1067	6	297060	\N	0	\N
1905	1067	37	754107	\N	1	\N
1906	1067	122	30612	\N	0	\N
1907	1067	25	7010	\N	0	\N
1908	1067	26	15	\N	0	\N
1909	1067	55	134100	\N	0	\N
1910	1067	113	5	\N	0	\N
1911	1067	260	34452	\N	0	\N
1912	1067	248	27668	\N	0	\N
1913	1067	73	40290	\N	0	\N
1914	1067	109	754107	\N	0	\N
1915	1067	247	18410	\N	0	\N
1916	1067	117	9952	\N	0	\N
1917	1068	152	1	\N	0	\N
1918	1068	234	3	\N	0	\N
1919	1068	278	1	\N	0	\N
1920	1068	67	1	\N	0	\N
1921	1068	139	6	\N	0	\N
1922	1068	77	1	\N	0	\N
1923	1068	261	2	\N	0	\N
1924	1068	33	549908	\N	0	\N
1925	1068	173	3	\N	0	\N
1926	1068	21	5	\N	0	\N
1927	1068	249	549908	\N	1	\N
1928	1068	60	1	\N	0	\N
1929	1068	54	1	\N	0	\N
1930	1068	32	5	\N	0	\N
1931	1069	91	2	\N	0	\N
1932	1069	114	2	\N	0	\N
1933	1069	219	1	\N	0	\N
1934	1069	111	441450	\N	0	\N
1935	1069	126	5	\N	0	\N
1936	1069	200	1	\N	0	\N
1937	1069	145	5	\N	0	\N
1938	1069	251	6	\N	0	\N
1939	1069	242	441450	\N	1	\N
1940	1069	233	1	\N	0	\N
1941	1069	143	3	\N	0	\N
1942	1070	145	1	\N	0	\N
1943	1070	120	1	\N	0	\N
1944	1070	55	1	\N	0	\N
1945	1070	66	1	\N	0	\N
1946	1070	118	418468	\N	1	\N
1947	1070	54	418468	\N	0	\N
1948	1070	139	1	\N	0	\N
1949	1070	227	1	\N	0	\N
1950	1071	278	405128	\N	1	\N
1951	1071	145	4	\N	0	\N
1952	1071	54	405128	\N	0	\N
1953	1071	8	1	\N	0	\N
1954	1071	251	2	\N	0	\N
1955	1071	15	1	\N	0	\N
1956	1071	135	1	\N	0	\N
1957	1071	33	1	\N	0	\N
1958	1071	143	3	\N	0	\N
1959	1071	255	1	\N	0	\N
1960	1071	249	1	\N	0	\N
1961	1071	109	1	\N	0	\N
1962	1072	54	378703	\N	0	\N
1963	1072	220	1	\N	0	\N
1964	1072	111	1	\N	0	\N
1965	1072	256	1	\N	0	\N
1966	1072	129	1	\N	0	\N
1967	1072	13	2	\N	0	\N
1968	1072	195	2	\N	0	\N
1969	1072	149	1	\N	0	\N
1970	1072	112	378703	\N	1	\N
1971	1073	145	4	\N	0	\N
1972	1073	187	1	\N	0	\N
1973	1073	112	2	\N	0	\N
1974	1073	195	298703	\N	1	\N
1975	1073	229	3	\N	0	\N
1976	1073	54	298703	\N	0	\N
1977	1074	109	297060	\N	0	\N
1978	1074	37	297060	\N	0	\N
1979	1074	260	1	\N	0	\N
1980	1074	6	297060	\N	1	\N
1981	1074	248	1	\N	0	\N
1982	1075	55	251585	\N	0	\N
1983	1075	201	1	\N	0	\N
1984	1075	222	251585	\N	1	\N
1985	1075	208	2	\N	0	\N
1986	1075	46	1	\N	0	\N
1987	1075	113	3	\N	0	\N
1988	1076	251	247421	\N	0	\N
1989	1076	282	5	\N	0	\N
1990	1076	210	2	\N	0	\N
1991	1076	90	247421	\N	1	\N
1992	1076	219	3	\N	0	\N
1993	1076	126	6	\N	0	\N
1994	1077	119	233176	\N	1	\N
1995	1077	54	233176	\N	0	\N
1996	1078	113	5	\N	0	\N
1997	1078	25	1	\N	0	\N
1998	1078	136	220113	\N	1	\N
1999	1078	109	220113	\N	0	\N
2000	1078	37	220113	\N	0	\N
2001	1078	55	6	\N	0	\N
2002	1079	249	5	\N	0	\N
2003	1079	32	2	\N	0	\N
2004	1079	33	217362	\N	0	\N
2005	1079	21	217362	\N	1	\N
2006	1079	261	1	\N	0	\N
2007	1080	11	1	\N	0	\N
2008	1080	54	213533	\N	0	\N
2009	1080	76	213533	\N	1	\N
2010	1080	55	1	\N	0	\N
2011	1081	249	3	\N	0	\N
2012	1081	33	203949	\N	0	\N
2013	1081	234	203949	\N	1	\N
2014	1082	237	1	\N	0	\N
2015	1082	55	190265	\N	0	\N
2016	1082	109	1	\N	0	\N
2017	1082	180	190265	\N	1	\N
2018	1082	133	2	\N	0	\N
2019	1082	255	1	\N	0	\N
2020	1083	222	2	\N	0	\N
2021	1083	55	178450	\N	0	\N
2022	1083	46	2	\N	0	\N
2023	1083	123	1	\N	0	\N
2024	1083	208	178450	\N	1	\N
2025	1084	180	1	\N	0	\N
2026	1084	55	169772	\N	0	\N
2027	1084	177	1	\N	0	\N
2028	1084	237	169772	\N	1	\N
2029	1085	72	168152	\N	1	\N
2030	1085	109	168152	\N	0	\N
2031	1086	197	166120	\N	1	\N
2032	1086	91	4	\N	0	\N
2033	1086	145	1	\N	0	\N
2034	1086	22	1	\N	0	\N
2035	1086	221	5	\N	0	\N
2036	1086	229	1	\N	0	\N
2037	1086	251	166120	\N	0	\N
2038	1086	114	4	\N	0	\N
2039	1087	225	149835	\N	1	\N
2040	1087	111	149835	\N	0	\N
2041	1088	33	3	\N	0	\N
2042	1088	139	143276	\N	0	\N
2043	1088	173	143276	\N	1	\N
2044	1088	152	2	\N	0	\N
2045	1088	249	3	\N	0	\N
2046	1089	61	1	\N	0	\N
2047	1089	208	2	\N	0	\N
2048	1089	113	1	\N	0	\N
2049	1089	222	1	\N	0	\N
2050	1089	123	1	\N	0	\N
2051	1089	142	1	\N	0	\N
2052	1089	179	1	\N	0	\N
2053	1089	55	139906	\N	0	\N
2054	1089	46	139906	\N	1	\N
2055	1089	66	1	\N	0	\N
2056	1089	207	1	\N	0	\N
2057	1089	254	1	\N	0	\N
2058	1090	103	3	\N	0	\N
2059	1090	54	132500	\N	0	\N
2060	1090	188	4	\N	0	\N
2061	1090	74	132500	\N	1	\N
2062	1090	251	1	\N	0	\N
2063	1090	33	3	\N	0	\N
2064	1090	171	1	\N	0	\N
2065	1090	111	4	\N	0	\N
2066	1091	198	1	\N	0	\N
2067	1091	111	1	\N	0	\N
2068	1091	236	128038	\N	1	\N
2069	1091	200	8	\N	0	\N
2070	1091	226	1	\N	0	\N
2071	1091	145	128038	\N	0	\N
2072	1091	143	1	\N	0	\N
2073	1092	48	122012	\N	1	\N
2074	1092	145	122012	\N	0	\N
2075	1093	46	1	\N	0	\N
2076	1093	55	115441	\N	0	\N
2077	1093	61	115441	\N	1	\N
2078	1094	180	2	\N	0	\N
2079	1094	133	114343	\N	1	\N
2080	1094	55	114343	\N	0	\N
2081	1095	54	113400	\N	0	\N
2082	1095	83	113400	\N	1	\N
2083	1096	54	109705	\N	0	\N
2084	1096	159	109705	\N	1	\N
2085	1097	261	104556	\N	1	\N
2086	1097	249	2	\N	0	\N
2087	1097	231	1	\N	0	\N
2088	1097	33	104556	\N	0	\N
2089	1097	145	1	\N	0	\N
2090	1097	32	4	\N	0	\N
2091	1097	21	1	\N	0	\N
2092	1098	46	1	\N	0	\N
2093	1098	55	104349	\N	0	\N
2094	1098	179	104349	\N	1	\N
2095	1098	58	2	\N	0	\N
2096	1099	251	5	\N	0	\N
2097	1099	145	3	\N	0	\N
2098	1099	91	99621	\N	0	\N
2099	1099	187	1	\N	0	\N
2100	1099	229	2	\N	0	\N
2101	1099	194	1	\N	0	\N
2102	1099	126	1	\N	0	\N
2103	1099	114	99621	\N	1	\N
2104	1099	242	2	\N	0	\N
2105	1099	111	3	\N	0	\N
2106	1099	197	4	\N	0	\N
2107	1100	33	99479	\N	0	\N
2108	1100	261	4	\N	0	\N
2109	1100	21	2	\N	0	\N
2110	1100	32	99479	\N	1	\N
2111	1100	249	5	\N	0	\N
2112	1101	219	96397	\N	1	\N
2113	1101	251	96397	\N	0	\N
2114	1101	279	4	\N	0	\N
2115	1101	90	3	\N	0	\N
2116	1101	210	5	\N	0	\N
2117	1101	126	34	\N	0	\N
2118	1101	242	1	\N	0	\N
2119	1101	111	1	\N	0	\N
2120	1101	282	1	\N	0	\N
2121	1102	54	95105	\N	0	\N
2122	1102	68	95105	\N	1	\N
2123	1103	54	1	\N	0	\N
2124	1103	76	1	\N	0	\N
2125	1103	11	92878	\N	1	\N
2126	1103	55	92878	\N	0	\N
2127	1104	112	2	\N	0	\N
2128	1104	13	91937	\N	1	\N
2129	1104	54	91937	\N	0	\N
2130	1105	126	4	\N	0	\N
2131	1105	251	91890	\N	0	\N
2132	1105	279	91890	\N	1	\N
2133	1105	219	4	\N	0	\N
2134	1105	210	1	\N	0	\N
2135	1106	82	6	\N	0	\N
2136	1106	224	91347	\N	1	\N
2137	1106	109	91347	\N	0	\N
2138	1107	139	90029	\N	0	\N
2139	1107	152	1	\N	0	\N
2140	1107	120	90029	\N	1	\N
2141	1107	54	1	\N	0	\N
2142	1107	145	5	\N	0	\N
2143	1107	24	5	\N	0	\N
2144	1107	176	2	\N	0	\N
2145	1107	118	1	\N	0	\N
2146	1108	109	88703	\N	0	\N
2147	1108	107	88703	\N	1	\N
2148	1109	143	84816	\N	1	\N
2149	1109	242	3	\N	0	\N
2150	1109	54	3	\N	0	\N
2151	1109	251	1	\N	0	\N
2152	1109	126	1	\N	0	\N
2153	1109	111	3	\N	0	\N
2154	1109	278	3	\N	0	\N
2155	1109	236	1	\N	0	\N
2156	1109	200	1	\N	0	\N
2157	1109	145	84816	\N	0	\N
2158	1110	145	83872	\N	0	\N
2159	1110	120	5	\N	0	\N
2160	1110	139	5	\N	0	\N
2161	1110	24	83872	\N	1	\N
2162	1111	54	1	\N	0	\N
2163	1111	8	81816	\N	1	\N
2164	1111	278	1	\N	0	\N
2165	1111	210	1	\N	0	\N
2166	1111	251	81816	\N	0	\N
2167	1112	188	76766	\N	1	\N
2168	1112	54	4	\N	0	\N
2169	1112	74	4	\N	0	\N
2170	1112	41	1	\N	0	\N
2171	1112	111	76766	\N	0	\N
2172	1112	33	2	\N	0	\N
2173	1112	230	2	\N	0	\N
2174	1112	109	1	\N	0	\N
2175	1113	169	73621	\N	1	\N
2176	1113	65	2	\N	0	\N
2177	1113	54	73621	\N	0	\N
2178	1113	157	23	\N	0	\N
2179	1114	168	68386	\N	1	\N
2180	1114	37	68386	\N	0	\N
2181	1114	25	1	\N	0	\N
2182	1114	55	68386	\N	0	\N
2183	1114	109	68386	\N	0	\N
2184	1115	229	66782	\N	1	\N
2185	1115	166	2	\N	0	\N
2186	1115	206	2	\N	0	\N
2187	1115	81	1	\N	0	\N
2188	1115	111	7	\N	0	\N
2189	1115	251	4	\N	0	\N
2190	1115	145	66781	\N	0	\N
2191	1115	54	4	\N	0	\N
2192	1115	195	3	\N	0	\N
2193	1115	126	2	\N	0	\N
2194	1115	91	2	\N	0	\N
2195	1115	194	5	\N	0	\N
2196	1115	227	1	\N	0	\N
2197	1115	197	1	\N	0	\N
2198	1115	187	7	\N	0	\N
2199	1115	272	1	\N	0	\N
2200	1115	232	1	\N	0	\N
2201	1115	85	2	\N	0	\N
2202	1115	114	2	\N	0	\N
2203	1115	171	1	\N	0	\N
2204	1116	54	65135	\N	0	\N
2205	1116	49	65135	\N	1	\N
2206	1117	280	61809	\N	1	\N
2207	1117	145	61809	\N	0	\N
2208	1118	229	1	\N	0	\N
2209	1118	33	2	\N	0	\N
2210	1118	145	1	\N	0	\N
2211	1118	251	61226	\N	0	\N
2212	1118	103	2	\N	0	\N
2213	1118	54	1	\N	0	\N
2214	1118	171	61226	\N	1	\N
2215	1118	74	1	\N	0	\N
2216	1119	171	2	\N	0	\N
2217	1119	251	2	\N	0	\N
2218	1119	33	60906	\N	0	\N
2219	1119	54	3	\N	0	\N
2220	1119	74	3	\N	0	\N
2221	1119	103	60906	\N	1	\N
2222	1120	251	60487	\N	0	\N
2223	1120	283	60487	\N	1	\N
2224	1121	145	59993	\N	0	\N
2225	1121	198	59993	\N	1	\N
2226	1121	236	1	\N	0	\N
2227	1121	200	1	\N	0	\N
2228	1122	65	56175	\N	1	\N
2229	1122	169	2	\N	0	\N
2230	1122	54	56175	\N	0	\N
2231	1122	157	2	\N	0	\N
2232	1123	251	54788	\N	0	\N
2233	1123	278	1	\N	0	\N
2234	1123	135	54788	\N	1	\N
2235	1123	54	1	\N	0	\N
2236	1124	249	1	\N	0	\N
2237	1124	152	2	\N	0	\N
2238	1124	77	2	\N	0	\N
2239	1124	110	1	\N	0	\N
2240	1124	60	54334	\N	1	\N
2241	1124	33	1	\N	0	\N
2242	1124	139	54334	\N	0	\N
2243	1125	31	1	\N	0	\N
2244	1125	136	5	\N	0	\N
2245	1125	55	53337	\N	0	\N
2246	1125	113	53337	\N	1	\N
2247	1125	222	3	\N	0	\N
2248	1125	46	1	\N	0	\N
2249	1125	109	5	\N	0	\N
2250	1125	37	5	\N	0	\N
2251	1126	251	53152	\N	0	\N
2252	1126	109	53152	\N	0	\N
2253	1126	79	53152	\N	1	\N
2254	1126	41	1	\N	0	\N
2255	1127	54	51760	\N	0	\N
2256	1127	202	51760	\N	1	\N
2257	1128	176	1	\N	0	\N
2258	1128	59	51394	\N	1	\N
2259	1128	139	51394	\N	0	\N
2260	1129	145	48058	\N	0	\N
2261	1129	206	48058	\N	1	\N
2262	1129	81	2	\N	0	\N
2263	1129	40	1	\N	0	\N
2264	1129	54	2	\N	0	\N
2265	1129	140	1	\N	0	\N
2266	1129	229	2	\N	0	\N
2267	1129	200	1	\N	0	\N
2268	1130	166	48009	\N	1	\N
2269	1130	175	1	\N	0	\N
2270	1130	227	1	\N	0	\N
2271	1130	111	1	\N	0	\N
2272	1130	85	1	\N	0	\N
2273	1130	145	48009	\N	0	\N
2274	1130	229	2	\N	0	\N
2275	1131	251	45312	\N	0	\N
2276	1131	250	45312	\N	1	\N
2277	1132	75	1	\N	0	\N
2278	1132	23	44408	\N	1	\N
2279	1132	54	44407	\N	0	\N
2280	1132	145	1	\N	0	\N
2281	1133	54	43567	\N	0	\N
2282	1133	256	1	\N	0	\N
2283	1133	109	1	\N	0	\N
2284	1133	153	43567	\N	1	\N
2285	1133	255	1	\N	0	\N
2286	1134	55	43188	\N	0	\N
2287	1134	271	43188	\N	1	\N
2288	1135	55	40290	\N	0	\N
2289	1135	73	40290	\N	1	\N
2290	1135	37	40290	\N	0	\N
2291	1135	109	40290	\N	0	\N
2292	1136	54	39848	\N	0	\N
2293	1136	115	39848	\N	1	\N
2294	1137	87	5	\N	0	\N
2295	1137	126	22	\N	0	\N
2296	1137	111	39303	\N	0	\N
2297	1137	144	39303	\N	1	\N
2298	1137	251	22	\N	0	\N
2299	1138	55	39228	\N	0	\N
2300	1138	155	39228	\N	1	\N
2301	1139	191	7	\N	0	\N
2302	1139	235	38057	\N	1	\N
2303	1139	251	38057	\N	0	\N
2304	1140	227	36753	\N	1	\N
2305	1140	54	1	\N	0	\N
2306	1140	145	36753	\N	0	\N
2307	1140	118	1	\N	0	\N
2308	1140	166	1	\N	0	\N
2309	1140	229	1	\N	0	\N
2310	1141	199	35399	\N	1	\N
2311	1141	55	35399	\N	0	\N
2312	1142	198	1	\N	0	\N
2313	1142	145	34519	\N	0	\N
2314	1142	251	1	\N	0	\N
2315	1142	143	1	\N	0	\N
2316	1142	200	34519	\N	1	\N
2317	1142	187	2	\N	0	\N
2318	1142	242	1	\N	0	\N
2319	1142	111	1	\N	0	\N
2320	1142	126	1	\N	0	\N
2321	1142	236	8	\N	0	\N
2322	1142	206	1	\N	0	\N
2323	1143	55	34452	\N	0	\N
2324	1143	222	1	\N	0	\N
2325	1143	201	34452	\N	1	\N
2326	1144	260	34452	\N	1	\N
2327	1144	37	34452	\N	0	\N
2328	1144	109	34452	\N	0	\N
2329	1144	6	1	\N	0	\N
2330	1145	82	31636	\N	1	\N
2331	1145	224	6	\N	0	\N
2332	1145	109	31636	\N	0	\N
2333	1146	55	30801	\N	0	\N
2334	1146	207	30801	\N	1	\N
2335	1146	46	1	\N	0	\N
2336	1147	109	30612	\N	0	\N
2337	1147	122	30612	\N	1	\N
2338	1147	37	30612	\N	0	\N
2339	1148	109	30086	\N	0	\N
2340	1148	71	1	\N	0	\N
2341	1148	172	30086	\N	1	\N
2342	1149	109	29224	\N	0	\N
2343	1149	41	29224	\N	1	\N
2344	1149	188	1	\N	0	\N
2345	1149	111	1	\N	0	\N
2346	1149	79	1	\N	0	\N
2347	1149	251	1	\N	0	\N
2348	1150	20	28680	\N	1	\N
2349	1150	63	1	\N	0	\N
2350	1150	55	28680	\N	0	\N
2351	1151	55	28577	\N	0	\N
2352	1151	86	28577	\N	1	\N
2353	1152	75	27866	\N	1	\N
2354	1152	23	1	\N	0	\N
2355	1152	54	27866	\N	0	\N
2356	1153	109	27668	\N	0	\N
2357	1153	6	1	\N	0	\N
2358	1153	37	27668	\N	0	\N
2359	1153	248	27668	\N	1	\N
2360	1154	134	27454	\N	1	\N
2361	1154	55	27454	\N	0	\N
2362	1155	170	27248	\N	1	\N
2363	1155	55	27248	\N	0	\N
2364	1156	111	26677	\N	0	\N
2365	1156	154	26677	\N	1	\N
2366	1156	251	1	\N	0	\N
2367	1156	126	1	\N	0	\N
2368	1157	276	26660	\N	1	\N
2369	1157	55	26660	\N	0	\N
2370	1158	55	25928	\N	0	\N
2371	1158	46	1	\N	0	\N
2372	1158	254	25928	\N	1	\N
2373	1159	31	25208	\N	1	\N
2374	1159	55	25208	\N	0	\N
2375	1159	113	1	\N	0	\N
2376	1160	178	25205	\N	1	\N
2377	1160	55	25205	\N	0	\N
2378	1161	229	1	\N	0	\N
2379	1161	145	24248	\N	0	\N
2380	1161	124	1	\N	0	\N
2381	1161	272	24248	\N	1	\N
2382	1162	167	24214	\N	1	\N
2383	1162	255	6	\N	0	\N
2384	1162	109	24214	\N	0	\N
2385	1163	251	24122	\N	0	\N
2386	1163	89	24122	\N	1	\N
2387	1164	54	24079	\N	0	\N
2388	1164	65	2	\N	0	\N
2389	1164	169	23	\N	0	\N
2390	1164	157	24079	\N	1	\N
2391	1165	111	23978	\N	0	\N
2392	1165	145	1	\N	0	\N
2393	1165	166	1	\N	0	\N
2394	1165	175	23978	\N	1	\N
2395	1166	22	23926	\N	1	\N
2396	1166	197	1	\N	0	\N
2397	1166	251	23926	\N	0	\N
2398	1167	145	23859	\N	0	\N
2399	1167	195	1	\N	0	\N
2400	1167	54	1	\N	0	\N
2401	1167	200	2	\N	0	\N
2402	1167	126	9	\N	0	\N
2403	1167	114	1	\N	0	\N
2404	1167	187	23859	\N	1	\N
2405	1167	91	1	\N	0	\N
2406	1167	251	9	\N	0	\N
2407	1167	229	7	\N	0	\N
2408	1168	281	23760	\N	1	\N
2409	1168	55	23760	\N	0	\N
2410	1168	109	23760	\N	0	\N
2411	1169	139	23729	\N	0	\N
2412	1169	60	2	\N	0	\N
2413	1169	33	1	\N	0	\N
2414	1169	120	1	\N	0	\N
2415	1169	173	2	\N	0	\N
2416	1169	249	1	\N	0	\N
2417	1169	110	1	\N	0	\N
2418	1169	152	23729	\N	1	\N
2419	1170	109	22654	\N	0	\N
2420	1170	253	22654	\N	1	\N
2421	1171	109	21994	\N	0	\N
2422	1171	151	21994	\N	1	\N
2423	1172	238	1	\N	0	\N
2424	1172	118	1	\N	0	\N
2425	1172	46	1	\N	0	\N
2426	1172	66	21979	\N	1	\N
2427	1172	54	1	\N	0	\N
2428	1172	55	21979	\N	0	\N
2429	1173	153	1	\N	0	\N
2430	1173	256	21583	\N	1	\N
2431	1173	112	1	\N	0	\N
2432	1173	54	21583	\N	0	\N
2433	1174	145	21576	\N	0	\N
2434	1174	141	21576	\N	1	\N
2435	1175	284	20303	\N	1	\N
2436	1175	139	20303	\N	0	\N
2437	1176	110	18959	\N	1	\N
2438	1176	152	1	\N	0	\N
2439	1176	60	1	\N	0	\N
2440	1176	139	18959	\N	0	\N
2441	1177	108	18592	\N	1	\N
2442	1177	55	18592	\N	0	\N
2443	1178	109	18410	\N	0	\N
2444	1178	37	18410	\N	0	\N
2445	1178	55	18410	\N	0	\N
2446	1178	247	18410	\N	1	\N
2447	1179	54	17491	\N	0	\N
2448	1179	246	17491	\N	1	\N
2449	1180	55	17271	\N	0	\N
2450	1180	237	1	\N	0	\N
2451	1180	177	17271	\N	1	\N
2452	1181	109	16782	\N	0	\N
2453	1181	138	16782	\N	1	\N
2454	1182	123	16767	\N	1	\N
2455	1182	46	1	\N	0	\N
2456	1182	55	16767	\N	0	\N
2457	1182	208	1	\N	0	\N
2458	1183	19	16736	\N	1	\N
2459	1183	55	16736	\N	0	\N
2460	1184	111	16544	\N	0	\N
2461	1184	194	16544	\N	1	\N
2462	1184	145	5	\N	0	\N
2463	1184	114	1	\N	0	\N
2464	1184	229	5	\N	0	\N
2465	1184	91	1	\N	0	\N
2466	1185	35	15526	\N	1	\N
2467	1185	55	15526	\N	0	\N
2468	1186	106	15462	\N	1	\N
2469	1186	111	15462	\N	0	\N
2470	1187	142	15373	\N	1	\N
2471	1187	46	1	\N	0	\N
2472	1187	55	15373	\N	0	\N
2473	1188	55	14833	\N	0	\N
2474	1188	36	14833	\N	1	\N
2475	1189	66	1	\N	0	\N
2476	1189	55	14453	\N	0	\N
2477	1189	238	14453	\N	1	\N
2478	1190	55	14245	\N	0	\N
2479	1190	218	14245	\N	1	\N
2480	1191	43	50	\N	0	\N
2481	1191	145	14027	\N	0	\N
2482	1191	273	14027	\N	1	\N
2483	1192	145	13989	\N	0	\N
2484	1192	45	13989	\N	1	\N
2485	1193	147	13551	\N	1	\N
2486	1193	55	13551	\N	0	\N
2487	1194	39	13409	\N	1	\N
2488	1194	55	13409	\N	0	\N
2489	1195	105	13293	\N	1	\N
2490	1195	33	13293	\N	0	\N
2491	1196	249	1	\N	0	\N
2492	1196	60	2	\N	0	\N
2493	1196	33	1	\N	0	\N
2494	1196	176	3	\N	0	\N
2495	1196	77	12374	\N	1	\N
2496	1196	139	12374	\N	0	\N
2497	1197	111	12342	\N	0	\N
2498	1197	121	12342	\N	1	\N
2499	1198	112	1	\N	0	\N
2500	1198	220	12262	\N	1	\N
2501	1198	54	12262	\N	0	\N
2502	1199	145	11814	\N	0	\N
2503	1199	109	11814	\N	0	\N
2504	1199	186	11814	\N	1	\N
2505	1199	183	1	\N	0	\N
2506	1200	129	11624	\N	1	\N
2507	1200	112	1	\N	0	\N
2508	1200	54	11624	\N	0	\N
2509	1201	120	2	\N	0	\N
2510	1201	139	11609	\N	0	\N
2511	1201	176	11609	\N	1	\N
2512	1201	59	1	\N	0	\N
2513	1201	77	3	\N	0	\N
2514	1202	231	11384	\N	1	\N
2515	1202	261	1	\N	0	\N
2516	1202	33	1	\N	0	\N
2517	1202	145	11384	\N	0	\N
2518	1203	18	11180	\N	1	\N
2519	1203	55	11180	\N	0	\N
2520	1204	55	11148	\N	0	\N
2521	1204	63	11148	\N	1	\N
2522	1204	20	1	\N	0	\N
2523	1205	145	1	\N	0	\N
2524	1205	109	10848	\N	0	\N
2525	1205	183	10848	\N	1	\N
2526	1205	186	1	\N	0	\N
2527	1206	290	10823	\N	1	\N
2528	1206	54	10823	\N	0	\N
2529	1207	55	10800	\N	0	\N
2530	1207	102	10800	\N	1	\N
2531	1208	145	10156	\N	0	\N
2532	1208	229	2	\N	0	\N
2533	1208	85	10156	\N	1	\N
2534	1208	166	1	\N	0	\N
2535	1209	109	9952	\N	0	\N
2536	1209	37	9952	\N	0	\N
2537	1209	117	9952	\N	1	\N
2538	1210	67	9163	\N	1	\N
2539	1210	249	1	\N	0	\N
2540	1210	33	9163	\N	0	\N
2541	1211	29	9021	\N	1	\N
2542	1211	55	9021	\N	0	\N
2543	1212	226	8733	\N	1	\N
2544	1212	236	1	\N	0	\N
2545	1212	145	1	\N	0	\N
2546	1212	111	8733	\N	0	\N
2547	1213	156	8484	\N	1	\N
2548	1213	251	8484	\N	0	\N
2549	1214	251	8427	\N	0	\N
2550	1214	174	8427	\N	1	\N
2551	1215	55	8340	\N	0	\N
2552	1215	137	8340	\N	1	\N
2553	1216	109	8280	\N	0	\N
2554	1216	10	8280	\N	1	\N
2555	1217	55	8243	\N	0	\N
2556	1217	257	8243	\N	1	\N
2557	1218	88	8127	\N	1	\N
2558	1218	255	1	\N	0	\N
2559	1218	109	1	\N	0	\N
2560	1218	139	8127	\N	0	\N
2561	1219	145	7797	\N	0	\N
2562	1219	206	1	\N	0	\N
2563	1219	140	7797	\N	1	\N
2564	1220	54	7758	\N	0	\N
2565	1220	228	7758	\N	1	\N
2566	1221	235	7	\N	0	\N
2567	1221	251	7512	\N	0	\N
2568	1221	126	2	\N	0	\N
2569	1221	191	7512	\N	1	\N
2570	1222	109	7287	\N	0	\N
2571	1222	158	7287	\N	1	\N
2572	1223	43	7281	\N	1	\N
2573	1223	145	7281	\N	0	\N
2574	1223	273	50	\N	0	\N
2575	1224	33	7258	\N	0	\N
2576	1224	230	7258	\N	1	\N
2577	1224	111	2	\N	0	\N
2578	1224	188	2	\N	0	\N
2579	1225	144	5	\N	0	\N
2580	1225	87	7053	\N	1	\N
2581	1225	111	7053	\N	0	\N
2582	1226	168	1	\N	0	\N
2583	1226	109	7010	\N	0	\N
2584	1226	25	7010	\N	1	\N
2585	1226	55	7010	\N	0	\N
2586	1226	37	7010	\N	0	\N
2587	1226	136	1	\N	0	\N
2588	1227	204	6865	\N	1	\N
2589	1227	251	8	\N	0	\N
2590	1227	126	8	\N	0	\N
2591	1227	149	2	\N	0	\N
2592	1227	111	6865	\N	0	\N
2593	1228	55	6514	\N	0	\N
2594	1228	288	6514	\N	1	\N
2595	1229	55	6322	\N	0	\N
2596	1229	125	6322	\N	1	\N
2597	1230	12	6275	\N	1	\N
2598	1230	55	6275	\N	0	\N
2599	1231	55	6256	\N	0	\N
2600	1231	92	6256	\N	1	\N
2601	1232	55	6076	\N	0	\N
2602	1232	185	6076	\N	1	\N
2603	1233	17	5856	\N	1	\N
2604	1233	287	1	\N	0	\N
2605	1233	55	5856	\N	0	\N
2606	1234	111	1	\N	0	\N
2607	1234	242	1	\N	0	\N
2608	1234	145	5771	\N	0	\N
2609	1234	233	5771	\N	1	\N
2610	1235	80	1	\N	0	\N
2611	1235	55	5712	\N	0	\N
2612	1235	252	5712	\N	1	\N
2613	1235	145	1	\N	0	\N
2614	1236	150	5373	\N	1	\N
2615	1236	54	5373	\N	0	\N
2616	1237	55	5067	\N	0	\N
2617	1237	165	5067	\N	1	\N
2618	1238	7	4961	\N	1	\N
2619	1238	109	4961	\N	0	\N
2620	1239	44	4774	\N	1	\N
2621	1239	33	4774	\N	0	\N
2622	1240	232	4583	\N	1	\N
2623	1240	251	50	\N	0	\N
2624	1240	126	50	\N	0	\N
2625	1240	111	4583	\N	0	\N
2626	1240	145	1	\N	0	\N
2627	1240	229	1	\N	0	\N
2628	1241	42	4380	\N	1	\N
2629	1241	55	4380	\N	0	\N
2630	1242	274	4322	\N	1	\N
2631	1242	55	4322	\N	0	\N
2632	1243	277	4291	\N	1	\N
2633	1243	109	4291	\N	0	\N
2634	1244	54	3861	\N	0	\N
2635	1244	57	3861	\N	1	\N
2636	1245	251	3793	\N	0	\N
2637	1245	62	3793	\N	1	\N
2638	1246	54	3759	\N	0	\N
2639	1246	275	3759	\N	1	\N
2640	1247	54	3731	\N	0	\N
2641	1247	56	3731	\N	1	\N
2642	1248	55	3664	\N	0	\N
2643	1248	47	3664	\N	1	\N
2644	1249	54	3604	\N	0	\N
2645	1249	205	3604	\N	1	\N
2646	1250	251	3540	\N	0	\N
2647	1250	221	3540	\N	1	\N
2648	1250	197	5	\N	0	\N
2649	1251	55	3502	\N	0	\N
2650	1251	30	3502	\N	1	\N
2651	1252	229	1	\N	0	\N
2652	1252	145	4	\N	0	\N
2653	1252	40	1	\N	0	\N
2654	1252	81	3439	\N	1	\N
2655	1252	206	2	\N	0	\N
2656	1252	54	3439	\N	0	\N
2657	1253	55	3161	\N	0	\N
2658	1253	34	3161	\N	1	\N
2659	1254	3	2958	\N	1	\N
2660	1254	251	2958	\N	0	\N
2661	1255	55	2921	\N	0	\N
2662	1255	148	2921	\N	1	\N
2663	1256	33	2277	\N	0	\N
2664	1256	223	2277	\N	1	\N
2665	1257	206	1	\N	0	\N
2666	1257	40	2277	\N	1	\N
2667	1257	145	2277	\N	0	\N
2668	1257	81	1	\N	0	\N
2669	1257	54	1	\N	0	\N
2670	1258	93	2144	\N	1	\N
2671	1258	251	2144	\N	0	\N
2672	1259	111	2133	\N	0	\N
2673	1259	38	2133	\N	1	\N
2674	1260	55	2102	\N	0	\N
2675	1260	146	2102	\N	1	\N
2676	1261	55	2099	\N	0	\N
2677	1261	9	2099	\N	1	\N
2678	1262	80	2050	\N	1	\N
2679	1262	55	1	\N	0	\N
2680	1262	252	1	\N	0	\N
2681	1262	145	2050	\N	0	\N
2682	1263	78	1955	\N	1	\N
2683	1263	145	1955	\N	0	\N
2684	1264	145	1909	\N	0	\N
2685	1264	278	1	\N	0	\N
2686	1264	54	1	\N	0	\N
2687	1264	15	1909	\N	1	\N
2688	1265	55	1738	\N	0	\N
2689	1265	58	1738	\N	1	\N
2690	1265	179	2	\N	0	\N
2691	1266	289	1651	\N	1	\N
2692	1266	111	1651	\N	0	\N
2693	1267	269	1650	\N	1	\N
2694	1267	145	1650	\N	0	\N
2695	1268	145	1530	\N	0	\N
2696	1268	84	1530	\N	1	\N
2697	1269	91	1509	\N	0	\N
2698	1269	104	1509	\N	1	\N
2699	1270	55	1337	\N	0	\N
2700	1270	127	1337	\N	1	\N
2701	1271	101	1320	\N	1	\N
2702	1271	251	1320	\N	0	\N
2703	1272	111	1309	\N	0	\N
2704	1272	241	1309	\N	1	\N
2705	1273	244	1303	\N	1	\N
2706	1273	145	1303	\N	0	\N
2707	1274	258	1166	\N	1	\N
2708	1274	109	1166	\N	0	\N
2709	1275	64	1135	\N	1	\N
2710	1275	109	1135	\N	0	\N
2711	1276	116	1069	\N	1	\N
2712	1276	111	1069	\N	0	\N
2713	1277	287	992	\N	1	\N
2714	1277	17	1	\N	0	\N
2715	1277	55	992	\N	0	\N
2716	1278	55	864	\N	0	\N
2717	1278	192	864	\N	1	\N
2718	1279	285	799	\N	1	\N
2719	1279	109	799	\N	0	\N
2720	1280	184	707	\N	1	\N
2721	1280	145	707	\N	0	\N
2722	1281	145	660	\N	0	\N
2723	1281	182	660	\N	1	\N
2724	1282	109	597	\N	0	\N
2725	1282	71	597	\N	1	\N
2726	1282	172	1	\N	0	\N
2727	1283	145	588	\N	0	\N
2728	1283	124	588	\N	1	\N
2729	1283	272	1	\N	0	\N
2730	1284	145	541	\N	0	\N
2731	1284	51	541	\N	1	\N
2732	1285	5	484	\N	1	\N
2733	1285	55	484	\N	0	\N
2734	1286	16	478	\N	1	\N
2735	1286	145	478	\N	0	\N
2736	1287	163	446	\N	1	\N
2737	1287	251	446	\N	0	\N
2738	1288	52	434	\N	1	\N
2739	1288	111	434	\N	0	\N
2740	1289	128	419	\N	1	\N
2741	1289	54	419	\N	0	\N
2742	1290	54	405	\N	0	\N
2743	1290	262	405	\N	1	\N
2744	1291	111	398	\N	0	\N
2745	1291	214	398	\N	1	\N
2746	1292	14	362	\N	1	\N
2747	1292	111	362	\N	0	\N
2748	1293	212	322	\N	1	\N
2749	1293	145	322	\N	0	\N
2750	1293	111	322	\N	0	\N
2751	1294	203	308	\N	1	\N
2752	1294	145	308	\N	0	\N
2753	1295	189	307	\N	1	\N
2754	1295	55	307	\N	0	\N
2755	1296	196	301	\N	1	\N
2756	1296	251	301	\N	0	\N
2757	1297	145	246	\N	0	\N
2758	1297	286	246	\N	1	\N
2759	1298	111	227	\N	0	\N
2760	1298	4	227	\N	1	\N
2761	1299	111	221	\N	0	\N
2762	1299	193	221	\N	1	\N
2763	1300	145	212	\N	0	\N
2764	1300	245	212	\N	1	\N
2765	1301	109	194	\N	0	\N
2766	1301	243	194	\N	1	\N
2767	1302	145	173	\N	0	\N
2768	1302	131	173	\N	1	\N
2769	1303	99	166	\N	1	\N
2770	1303	111	166	\N	0	\N
2771	1304	111	132	\N	0	\N
2772	1304	264	132	\N	1	\N
2773	1305	190	128	\N	1	\N
2774	1305	145	128	\N	0	\N
2775	1305	111	128	\N	0	\N
2776	1306	54	113	\N	0	\N
2777	1306	97	113	\N	1	\N
2778	1307	109	105	\N	0	\N
2779	1307	95	105	\N	1	\N
2780	1308	145	77	\N	0	\N
2781	1308	162	77	\N	1	\N
2782	1309	181	68	\N	1	\N
2783	1309	109	68	\N	0	\N
2784	1310	263	29	\N	1	\N
2785	1310	145	29	\N	0	\N
2786	1311	160	27	\N	1	\N
2787	1311	109	27	\N	0	\N
2788	1312	111	26	\N	0	\N
2789	1312	213	26	\N	1	\N
2790	1313	132	24	\N	1	\N
2791	1313	145	24	\N	0	\N
2792	1314	259	22	\N	1	\N
2793	1314	145	22	\N	0	\N
2794	1315	94	18	\N	1	\N
2795	1315	109	18	\N	0	\N
2796	1316	109	15	\N	0	\N
2797	1316	26	15	\N	1	\N
2798	1316	37	15	\N	0	\N
2799	1317	109	14	\N	0	\N
2800	1317	240	14	\N	1	\N
2801	1318	109	11	\N	0	\N
2802	1318	100	11	\N	1	\N
2803	1319	266	11	\N	1	\N
2804	1319	251	11	\N	0	\N
2805	1320	53	5	\N	1	\N
2806	1320	111	5	\N	0	\N
2807	1321	111	5	\N	0	\N
2808	1321	211	5	\N	1	\N
2809	1322	109	5	\N	0	\N
2810	1322	130	5	\N	1	\N
2811	1323	111	5	\N	0	\N
2812	1323	215	5	\N	1	\N
2813	1324	145	3	\N	0	\N
2814	1324	50	3	\N	1	\N
2815	1325	55	3	\N	0	\N
2816	1325	27	3	\N	1	\N
2817	1326	109	2	\N	0	\N
2818	1326	239	2	\N	1	\N
2819	1327	111	2	\N	0	\N
2820	1327	69	2	\N	1	\N
2821	1328	111	2	\N	0	\N
2822	1328	267	2	\N	1	\N
2823	1329	1	2	\N	1	\N
2824	1329	109	2	\N	0	\N
2825	1330	109	2	\N	0	\N
2826	1330	265	2	\N	1	\N
2827	1331	109	1	\N	0	\N
2828	1331	98	1	\N	1	\N
2829	1332	270	1	\N	1	\N
2830	1333	216	1	\N	1	\N
2831	1334	111	1	\N	0	\N
2832	1334	2	1	\N	1	\N
2833	1345	217	290	\N	1	\N
2834	1346	217	290	\N	1	\N
2835	2594	70	1850	\N	1	\N
2836	2595	70	1850	\N	1	\N
2837	3075	217	1546	\N	1	\N
2838	3076	70	1546	\N	1	\N
2839	3964	217	21663074	\N	1	\N
2840	3965	217	10657434	\N	1	\N
2841	3966	217	9003199	\N	1	\N
2842	3967	217	6445440	\N	1	\N
2843	3968	217	4910717	\N	1	\N
2844	3969	217	2547672	\N	1	\N
2845	3970	217	2256594	\N	1	\N
2846	3971	217	1143181	\N	1	\N
2847	3972	217	226544	\N	1	\N
2848	3973	217	1546	\N	1	\N
2849	3976	217	18138256	\N	1	\N
2850	3977	217	3660416	\N	1	\N
2851	3978	217	3073624	\N	1	\N
2852	3979	217	2396287	\N	1	\N
2853	3980	217	2265350	\N	1	\N
2854	3981	217	1956432	\N	1	\N
2855	3982	217	1954341	\N	1	\N
2856	3983	217	1099846	\N	1	\N
2857	3984	217	891182	\N	1	\N
2858	3985	217	882926	\N	1	\N
2859	3986	217	836942	\N	1	\N
2860	3987	217	810272	\N	1	\N
2861	3988	217	757415	\N	1	\N
2862	3989	217	660351	\N	1	\N
2863	3990	217	597416	\N	1	\N
2864	3991	217	503177	\N	1	\N
2865	3992	217	494858	\N	1	\N
2866	3993	217	466352	\N	1	\N
2867	3994	217	434732	\N	1	\N
2868	3995	217	427068	\N	1	\N
2869	3996	217	407901	\N	1	\N
2870	3997	217	380535	\N	1	\N
2871	3998	217	356905	\N	1	\N
2872	3999	217	339546	\N	1	\N
2873	4000	217	336304	\N	1	\N
2874	4001	217	332256	\N	1	\N
2875	4002	217	299670	\N	1	\N
2876	4003	217	286560	\N	1	\N
2877	4004	217	279823	\N	1	\N
2878	4005	217	273545	\N	1	\N
2879	4006	217	265016	\N	1	\N
2880	4007	217	256088	\N	1	\N
2881	4008	217	244024	\N	1	\N
2882	4009	217	230883	\N	1	\N
2883	4010	217	228688	\N	1	\N
2884	4011	217	226800	\N	1	\N
2885	4012	217	219410	\N	1	\N
2886	4013	217	209121	\N	1	\N
2887	4014	217	208701	\N	1	\N
2888	4015	217	199264	\N	1	\N
2889	4016	217	198969	\N	1	\N
2890	4017	217	192843	\N	1	\N
2891	4018	217	190210	\N	1	\N
2892	4019	217	185758	\N	1	\N
2893	4020	217	183876	\N	1	\N
2894	4021	217	183789	\N	1	\N
2895	4022	217	182700	\N	1	\N
2896	4023	217	180073	\N	1	\N
2897	4024	217	177406	\N	1	\N
2898	4025	217	169648	\N	1	\N
2899	4026	217	167754	\N	1	\N
2900	4027	217	163653	\N	1	\N
2901	4028	217	161160	\N	1	\N
2902	4029	217	159459	\N	1	\N
2903	4030	217	153546	\N	1	\N
2904	4031	217	147267	\N	1	\N
2905	4032	217	133611	\N	1	\N
2906	4033	217	130270	\N	1	\N
2907	4034	217	123618	\N	1	\N
2908	4035	217	122460	\N	1	\N
2909	4036	217	121822	\N	1	\N
2910	4037	217	120974	\N	1	\N
2911	4038	217	119988	\N	1	\N
2912	4039	217	112354	\N	1	\N
2913	4040	217	109578	\N	1	\N
2914	4041	217	108675	\N	1	\N
2915	4042	217	106694	\N	1	\N
2916	4043	217	103520	\N	1	\N
2917	4044	217	103357	\N	1	\N
2918	4045	217	102789	\N	1	\N
2919	4046	217	96125	\N	1	\N
2920	4047	217	96024	\N	1	\N
2921	4048	217	91836	\N	1	\N
2922	4049	217	90624	\N	1	\N
2923	4050	217	88817	\N	1	\N
2924	4051	217	87137	\N	1	\N
2925	4052	217	86376	\N	1	\N
2926	4053	217	83005	\N	1	\N
2927	4054	217	79696	\N	1	\N
2928	4055	217	78655	\N	1	\N
2929	4056	217	78456	\N	1	\N
2930	4057	217	76129	\N	1	\N
2931	4058	217	73640	\N	1	\N
2932	4059	217	73510	\N	1	\N
2933	4060	217	71280	\N	1	\N
2934	4061	217	70798	\N	1	\N
2935	4062	217	69055	\N	1	\N
2936	4063	217	68905	\N	1	\N
2937	4064	217	63278	\N	1	\N
2938	4065	217	61603	\N	1	\N
2939	4066	217	60173	\N	1	\N
2940	4067	217	58452	\N	1	\N
2941	4068	217	57361	\N	1	\N
2942	4069	217	57154	\N	1	\N
2943	4070	217	55733	\N	1	\N
2944	4071	217	54908	\N	1	\N
2945	4072	217	54496	\N	1	\N
2946	4073	217	53356	\N	1	\N
2947	4074	217	53320	\N	1	\N
2948	4075	217	51857	\N	1	\N
2949	4076	217	50417	\N	1	\N
2950	4077	217	50410	\N	1	\N
2951	4078	217	48498	\N	1	\N
2952	4079	217	48434	\N	1	\N
2953	4080	217	48244	\N	1	\N
2954	4081	217	48183	\N	1	\N
2955	4082	217	47958	\N	1	\N
2956	4083	217	47853	\N	1	\N
2957	4084	217	47749	\N	1	\N
2958	4085	217	47466	\N	1	\N
2959	4086	217	45308	\N	1	\N
2960	4087	217	43988	\N	1	\N
2961	4088	217	43962	\N	1	\N
2962	4089	217	43168	\N	1	\N
2963	4090	217	43152	\N	1	\N
2964	4091	217	40606	\N	1	\N
2965	4092	217	37920	\N	1	\N
2966	4093	217	37184	\N	1	\N
2967	4094	217	35443	\N	1	\N
2968	4095	217	34982	\N	1	\N
2969	4096	217	34543	\N	1	\N
2970	4097	217	33564	\N	1	\N
2971	4098	217	33536	\N	1	\N
2972	4099	217	33472	\N	1	\N
2973	4100	217	33100	\N	1	\N
2974	4101	217	31052	\N	1	\N
2975	4102	217	30924	\N	1	\N
2976	4103	217	30747	\N	1	\N
2977	4104	217	29856	\N	1	\N
2978	4105	217	29666	\N	1	\N
2979	4106	217	28907	\N	1	\N
2980	4107	217	28490	\N	1	\N
2981	4108	217	28104	\N	1	\N
2982	4109	217	28042	\N	1	\N
2983	4110	217	27978	\N	1	\N
2984	4111	217	27106	\N	1	\N
2985	4112	217	26818	\N	1	\N
2986	4113	217	26586	\N	1	\N
2987	4114	217	24755	\N	1	\N
2988	4115	217	24684	\N	1	\N
2989	4116	217	24525	\N	1	\N
2990	4117	217	23249	\N	1	\N
2991	4118	217	23224	\N	1	\N
2992	4119	217	22770	\N	1	\N
2993	4120	217	22360	\N	1	\N
2994	4121	217	22297	\N	1	\N
2995	4122	217	21698	\N	1	\N
2996	4123	217	21646	\N	1	\N
2997	4124	217	21600	\N	1	\N
2998	4125	217	20315	\N	1	\N
2999	4126	217	18327	\N	1	\N
3000	4127	217	18042	\N	1	\N
3001	4128	217	17468	\N	1	\N
3002	4129	217	16968	\N	1	\N
3003	4130	217	16854	\N	1	\N
3004	4131	217	16680	\N	1	\N
3005	4132	217	16560	\N	1	\N
3006	4133	217	16486	\N	1	\N
3007	4134	217	16256	\N	1	\N
3008	4135	217	15595	\N	1	\N
3009	4136	217	15516	\N	1	\N
3010	4137	217	15033	\N	1	\N
3011	4138	217	14612	\N	1	\N
3012	4139	217	14574	\N	1	\N
3013	4140	217	14520	\N	1	\N
3014	4141	217	14111	\N	1	\N
3015	4142	217	13748	\N	1	\N
3016	4143	217	13028	\N	1	\N
3017	4144	217	12644	\N	1	\N
3018	4145	217	12550	\N	1	\N
3019	4146	217	12512	\N	1	\N
3020	4147	217	12152	\N	1	\N
3021	4148	217	11713	\N	1	\N
3022	4149	217	11544	\N	1	\N
3023	4150	217	11426	\N	1	\N
3024	4151	217	10746	\N	1	\N
3025	4152	217	10134	\N	1	\N
3026	4153	217	9922	\N	1	\N
3027	4154	217	9548	\N	1	\N
3028	4155	217	9268	\N	1	\N
3029	4156	217	8760	\N	1	\N
3030	4157	217	8644	\N	1	\N
3031	4158	217	8582	\N	1	\N
3032	4159	217	7722	\N	1	\N
3033	4160	217	7586	\N	1	\N
3034	4161	217	7518	\N	1	\N
3035	4162	217	7462	\N	1	\N
3036	4163	217	7328	\N	1	\N
3037	4164	217	7208	\N	1	\N
3038	4165	217	7085	\N	1	\N
3039	4166	217	7004	\N	1	\N
3040	4167	217	6886	\N	1	\N
3041	4168	217	6322	\N	1	\N
3042	4169	217	5916	\N	1	\N
3043	4170	217	5842	\N	1	\N
3044	4171	217	4557	\N	1	\N
3045	4172	217	4554	\N	1	\N
3046	4173	217	4288	\N	1	\N
3047	4174	217	4266	\N	1	\N
3048	4175	217	4204	\N	1	\N
3049	4176	217	4198	\N	1	\N
3050	4177	217	4102	\N	1	\N
3051	4178	217	3910	\N	1	\N
3052	4179	217	3820	\N	1	\N
3053	4180	217	3478	\N	1	\N
3054	4181	217	3302	\N	1	\N
3055	4182	217	3300	\N	1	\N
3056	4183	217	3060	\N	1	\N
3057	4184	217	3018	\N	1	\N
3058	4185	217	2674	\N	1	\N
3059	4186	217	2640	\N	1	\N
3060	4187	217	2618	\N	1	\N
3061	4188	217	2606	\N	1	\N
3062	4189	217	2332	\N	1	\N
3063	4190	217	2270	\N	1	\N
3064	4191	217	2138	\N	1	\N
3065	4192	217	1985	\N	1	\N
3066	4193	217	1728	\N	1	\N
3067	4194	217	1598	\N	1	\N
3068	4195	217	1414	\N	1	\N
3069	4196	217	1320	\N	1	\N
3070	4197	217	1195	\N	1	\N
3071	4198	217	1177	\N	1	\N
3072	4199	217	1082	\N	1	\N
3073	4200	217	973	\N	1	\N
3074	4201	217	968	\N	1	\N
3075	4202	217	956	\N	1	\N
3076	4203	217	892	\N	1	\N
3077	4204	217	868	\N	1	\N
3078	4205	217	838	\N	1	\N
3079	4206	217	810	\N	1	\N
3080	4207	217	796	\N	1	\N
3081	4208	217	724	\N	1	\N
3082	4209	217	616	\N	1	\N
3083	4210	217	614	\N	1	\N
3084	4211	217	602	\N	1	\N
3085	4212	217	492	\N	1	\N
3086	4213	217	454	\N	1	\N
3087	4214	217	442	\N	1	\N
3088	4215	217	424	\N	1	\N
3089	4216	217	388	\N	1	\N
3090	4217	217	384	\N	1	\N
3091	4218	217	346	\N	1	\N
3092	4219	217	332	\N	1	\N
3093	4220	217	266	\N	1	\N
3094	4221	217	226	\N	1	\N
3095	4222	217	210	\N	1	\N
3096	4223	217	154	\N	1	\N
3097	4224	217	136	\N	1	\N
3098	4225	217	58	\N	1	\N
3099	4226	217	54	\N	1	\N
3100	4227	217	52	\N	1	\N
3101	4228	217	48	\N	1	\N
3102	4229	217	45	\N	1	\N
3103	4230	217	44	\N	1	\N
3104	4231	217	36	\N	1	\N
3105	4232	217	31	\N	1	\N
3106	4233	217	28	\N	1	\N
3107	4234	217	22	\N	1	\N
3108	4235	217	22	\N	1	\N
3109	4236	217	10	\N	1	\N
3110	4237	217	10	\N	1	\N
3111	4238	217	10	\N	1	\N
3112	4239	217	10	\N	1	\N
3113	4240	217	10	\N	1	\N
3114	4241	217	9	\N	1	\N
3115	4242	217	6	\N	1	\N
3116	4243	217	6	\N	1	\N
3117	4244	217	4	\N	1	\N
3118	4245	217	4	\N	1	\N
3119	4246	217	4	\N	1	\N
3120	4247	217	4	\N	1	\N
3121	4248	217	3	\N	1	\N
3122	4249	217	2	\N	1	\N
3123	4250	217	2	\N	1	\N
3124	4251	217	2	\N	1	\N
3125	4254	227	73510	\N	0	\N
3126	4254	166	96024	\N	0	\N
3127	4254	187	47749	\N	0	\N
3128	4254	43	14612	\N	0	\N
3129	4254	269	3300	\N	0	\N
3130	4254	21	434732	\N	0	\N
3131	4254	87	14111	\N	0	\N
3132	4254	232	9268	\N	0	\N
3133	4254	138	33564	\N	0	\N
3134	4254	49	130270	\N	0	\N
3135	4254	46	279823	\N	0	\N
3136	4254	256	43168	\N	0	\N
3137	4254	142	30747	\N	0	\N
3138	4254	42	8760	\N	0	\N
3139	4254	147	27106	\N	0	\N
3140	4254	252	11426	\N	0	\N
3141	4254	56	7462	\N	0	\N
3142	4254	34	6322	\N	0	\N
3143	4254	60	108675	\N	0	\N
3144	4254	260	103357	\N	0	\N
3145	4254	283	120974	\N	0	\N
3146	4254	62	7586	\N	0	\N
3147	4254	264	266	\N	0	\N
3148	4254	191	15033	\N	0	\N
3149	4254	239	4	\N	0	\N
3150	4254	161	10	\N	0	\N
3151	4254	131	346	\N	0	\N
3152	4254	94	36	\N	0	\N
3153	4254	45	27978	\N	0	\N
3154	4254	67	18327	\N	0	\N
3155	4254	50	6	\N	0	\N
3156	4254	219	192843	\N	0	\N
3157	4254	113	106694	\N	0	\N
3158	4254	123	33536	\N	0	\N
3159	4254	165	10134	\N	0	\N
3160	4254	238	28907	\N	0	\N
3161	4254	146	4204	\N	0	\N
3162	4254	72	336304	\N	0	\N
3163	4254	224	182700	\N	0	\N
3164	4254	210	1954341	\N	0	\N
3165	4254	277	8582	\N	0	\N
3166	4254	171	122460	\N	0	\N
3167	4254	249	1099846	\N	0	\N
3168	4254	17	11713	\N	0	\N
3169	4254	230	14520	\N	0	\N
3170	4254	57	7722	\N	0	\N
3171	4254	204	13748	\N	0	\N
3172	4254	240	28	\N	0	\N
3173	4254	28	3	\N	0	\N
3174	4254	27	6	\N	0	\N
3175	4254	130	10	\N	0	\N
3176	4254	24	167754	\N	0	\N
3177	4254	198	119988	\N	0	\N
3178	4254	206	96125	\N	0	\N
3179	4254	233	11544	\N	0	\N
3180	4254	244	2606	\N	0	\N
3181	4254	259	44	\N	0	\N
3182	4254	53	10	\N	0	\N
3183	4254	241	2618	\N	0	\N
3184	4254	139	1143181	\N	8	\N
3185	4254	54	6445440	\N	4	\N
3186	4254	143	169648	\N	0	\N
3187	4254	208	356905	\N	0	\N
3188	4254	134	54908	\N	0	\N
3189	4254	65	112354	\N	0	\N
3190	4254	9	4198	\N	0	\N
3191	4254	207	61603	\N	0	\N
3192	4254	30	7004	\N	0	\N
3193	4254	228	15516	\N	0	\N
3194	4254	120	180073	\N	0	\N
3195	4254	186	35443	\N	0	\N
3196	4254	64	2270	\N	0	\N
3197	4254	258	2332	\N	0	\N
3198	4254	181	136	\N	0	\N
3199	4254	37	2396287	\N	0	\N
3200	4254	83	226800	\N	0	\N
3201	4254	25	28042	\N	0	\N
3202	4254	82	63278	\N	0	\N
3203	4254	136	660351	\N	0	\N
3204	4254	84	3060	\N	0	\N
3205	4254	154	53356	\N	0	\N
3206	4254	101	2640	\N	0	\N
3207	4254	100	22	\N	0	\N
3208	4254	98	2	\N	0	\N
3209	4254	96	2	\N	0	\N
3210	4254	145	2256594	\N	7	\N
3211	4254	48	244024	\N	0	\N
3212	4254	200	69055	\N	0	\N
3213	4254	261	209121	\N	0	\N
3214	4254	44	9548	\N	0	\N
3215	4254	193	442	\N	0	\N
3216	4254	8	163653	\N	0	\N
3217	4254	68	190210	\N	0	\N
3218	4254	66	43962	\N	0	\N
3219	4254	220	24525	\N	0	\N
3220	4254	11	185758	\N	0	\N
3221	4254	135	109578	\N	0	\N
3222	4254	274	8644	\N	0	\N
3223	4254	170	54496	\N	0	\N
3224	4254	158	14574	\N	0	\N
3225	4254	6	891182	\N	0	\N
3226	4254	152	47466	\N	0	\N
3227	4254	248	83005	\N	0	\N
3228	4254	117	29856	\N	0	\N
3229	4254	189	614	\N	0	\N
3230	4254	97	226	\N	0	\N
3231	4254	211	10	\N	0	\N
3232	4254	267	9	\N	0	\N
3233	4254	78	3910	\N	0	\N
3234	4254	234	407901	\N	0	\N
3235	4254	263	58	\N	0	\N
3236	4254	245	424	\N	0	\N
3237	4254	109	10657434	\N	2	\N
3238	4254	110	37920	\N	0	\N
3239	4254	176	23224	\N	0	\N
3240	4254	150	10746	\N	0	\N
3241	4254	104	3018	\N	0	\N
3242	4254	55	4910717	\N	5	\N
3243	4254	155	78456	\N	0	\N
3244	4254	177	34543	\N	0	\N
3245	4254	31	50417	\N	0	\N
3246	4254	281	71280	\N	0	\N
3247	4254	157	48183	\N	0	\N
3248	4254	10	16560	\N	0	\N
3249	4254	167	48434	\N	0	\N
3250	4254	183	21698	\N	0	\N
3251	4254	156	16968	\N	0	\N
3252	4254	243	388	\N	0	\N
3253	4254	250	90624	\N	0	\N
3254	4254	73	161160	\N	0	\N
3255	4254	39	26818	\N	0	\N
3256	4254	58	3478	\N	0	\N
3257	4254	80	4102	\N	0	\N
3258	4254	41	58452	\N	0	\N
3259	4254	175	47958	\N	0	\N
3260	4254	212	973	\N	0	\N
3261	4254	268	31	\N	0	\N
3262	4254	111	21663074	\N	1	\N
3263	4254	188	153546	\N	0	\N
3264	4254	52	868	\N	0	\N
3265	4254	23	88817	\N	0	\N
3266	4254	103	121822	\N	0	\N
3267	4254	273	28104	\N	0	\N
3268	4254	194	33100	\N	0	\N
3269	4254	271	86376	\N	0	\N
3270	4254	13	183876	\N	0	\N
3271	4254	257	16486	\N	0	\N
3272	4254	125	12644	\N	0	\N
3273	4254	128	838	\N	0	\N
3274	4254	126	2265350	\N	0	\N
3275	4254	225	299670	\N	0	\N
3276	4254	285	1598	\N	0	\N
3277	4254	22	47853	\N	0	\N
3278	4254	18	22360	\N	0	\N
3279	4254	61	230883	\N	0	\N
3280	4254	85	20315	\N	0	\N
3281	4254	121	24684	\N	0	\N
3282	4254	16	956	\N	0	\N
3283	4254	235	76129	\N	0	\N
3284	4254	190	384	\N	0	\N
3285	4254	184	1414	\N	0	\N
3286	4254	182	1320	\N	0	\N
3287	4254	286	492	\N	0	\N
3288	4254	215	10	\N	0	\N
3289	4254	213	52	\N	0	\N
3290	4254	144	78655	\N	0	\N
3291	4254	88	16256	\N	0	\N
3292	4254	278	810272	\N	0	\N
3293	4254	195	597416	\N	0	\N
3294	4254	108	37184	\N	0	\N
3295	4254	276	53320	\N	0	\N
3296	4254	237	339546	\N	0	\N
3297	4254	218	28490	\N	0	\N
3298	4254	129	23249	\N	0	\N
3299	4254	119	466352	\N	0	\N
3300	4254	19	33472	\N	0	\N
3301	4254	14	724	\N	0	\N
3302	4254	116	2138	\N	0	\N
3303	4254	221	7085	\N	0	\N
3304	4254	5	968	\N	0	\N
3305	4254	70	1546	\N	10	\N
3306	4254	226	17468	\N	0	\N
3307	4254	289	3302	\N	0	\N
3308	4254	214	796	\N	0	\N
3309	4254	223	4554	\N	0	\N
3310	4254	284	40606	\N	0	\N
3311	4254	251	9003199	\N	3	\N
3312	4254	242	882926	\N	0	\N
3313	4254	222	503177	\N	0	\N
3314	4254	179	208701	\N	0	\N
3315	4254	169	147267	\N	0	\N
3316	4254	7	9922	\N	0	\N
3317	4254	254	51857	\N	0	\N
3318	4254	178	50410	\N	0	\N
3319	4254	133	228688	\N	0	\N
3320	4254	180	380535	\N	0	\N
3321	4254	185	12152	\N	0	\N
3322	4254	12	12550	\N	0	\N
3323	4254	279	183789	\N	0	\N
3324	4254	255	3660416	\N	0	\N
3325	4254	209	3073624	\N	0	\N
3326	4254	118	836942	\N	0	\N
3327	4254	153	87137	\N	0	\N
3328	4254	122	91836	\N	0	\N
3329	4254	229	133611	\N	0	\N
3330	4254	196	602	\N	0	\N
3331	4254	95	210	\N	0	\N
3332	4254	236	256088	\N	0	\N
3333	4254	2	2	\N	0	\N
3334	4254	51	1082	\N	0	\N
3335	4254	280	123618	\N	0	\N
3336	4254	162	154	\N	0	\N
3337	4254	272	48498	\N	0	\N
3338	4254	86	57154	\N	0	\N
3339	4254	76	427068	\N	0	\N
3340	4254	246	34982	\N	0	\N
3341	4254	36	29666	\N	0	\N
3342	4254	137	16680	\N	0	\N
3343	4254	20	57361	\N	0	\N
3344	4254	35	31052	\N	0	\N
3345	4254	92	12512	\N	0	\N
3346	4254	148	5842	\N	0	\N
3347	4254	201	68905	\N	0	\N
3348	4254	288	13028	\N	0	\N
3349	4254	29	18042	\N	0	\N
3350	4254	107	177406	\N	0	\N
3351	4254	90	494858	\N	0	\N
3352	4254	89	48244	\N	0	\N
3353	4254	173	286560	\N	0	\N
3354	4254	168	273545	\N	0	\N
3355	4254	151	43988	\N	0	\N
3356	4254	40	4557	\N	0	\N
3357	4254	93	4288	\N	0	\N
3358	4254	192	1728	\N	0	\N
3359	4254	163	892	\N	0	\N
3360	4254	265	4	\N	0	\N
3361	4254	149	18138256	\N	0	\N
3362	4254	32	198969	\N	0	\N
3363	4254	132	48	\N	0	\N
3364	4254	91	226544	\N	9	\N
3365	4254	114	199264	\N	0	\N
3366	4254	141	43152	\N	0	\N
3367	4254	112	757415	\N	0	\N
3368	4254	47	7328	\N	0	\N
3369	4254	115	79696	\N	0	\N
3370	4254	127	2674	\N	0	\N
3371	4254	199	70798	\N	0	\N
3372	4254	75	55733	\N	0	\N
3373	4254	287	1985	\N	0	\N
3374	4254	253	45308	\N	0	\N
3375	4254	71	1195	\N	0	\N
3376	4254	202	103520	\N	0	\N
3377	4254	172	60173	\N	0	\N
3378	4254	79	159459	\N	0	\N
3379	4254	247	73640	\N	0	\N
3380	4254	174	16854	\N	0	\N
3381	4254	38	4266	\N	0	\N
3382	4254	205	7208	\N	0	\N
3383	4254	262	810	\N	0	\N
3384	4254	3	5916	\N	0	\N
3385	4254	99	332	\N	0	\N
3386	4254	124	1177	\N	0	\N
3387	4254	33	2547672	\N	6	\N
3388	4254	4	454	\N	0	\N
3389	4254	106	30924	\N	0	\N
3390	4254	105	26586	\N	0	\N
3391	4254	159	219410	\N	0	\N
3392	4254	290	21646	\N	0	\N
3393	4254	140	15595	\N	0	\N
3394	4254	275	7518	\N	0	\N
3395	4254	63	22297	\N	0	\N
3396	4254	74	265016	\N	0	\N
3397	4254	77	24755	\N	0	\N
3398	4254	102	21600	\N	0	\N
3399	4254	197	332256	\N	0	\N
3400	4254	59	102789	\N	0	\N
3401	4254	81	6886	\N	0	\N
3402	4254	282	1956432	\N	0	\N
3403	4254	15	3820	\N	0	\N
3404	4254	203	616	\N	0	\N
3405	4254	231	22770	\N	0	\N
3406	4254	26	45	\N	0	\N
3407	4254	69	4	\N	0	\N
3408	4254	1	4	\N	0	\N
3409	4254	266	22	\N	0	\N
3410	4254	160	54	\N	0	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#string	3	string
2	http://www.w3.org/1999/02/22-rdf-syntax-ns#langString	1	langString
3	http://www.w3.org/2001/XMLSchema#date	3	date
4	http://www.w3.org/2001/XMLSchema#Geometry	3	Geometry
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
73	n_3		0	f	0
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
69		http://gis.zcu.cz/SPOI/Ontology#	0	t	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
71	locn	http://www.w3.org/ns/locn#	0	f	0
70	poi	http://www.openvoc.eu/poi#	0	f	0
72	dct-11	http://purl.org/dc/terms/1.1/	0	f	0
74	org_1	http://www.w3.org/ns/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_foodie_cloud_poi_rdf	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_foodie_cloud_poi_rdf	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://www.foodie-cloud.org/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
40	named_graph	http://www.sdi4apps.eu/poi.rdf	\N	Default named graph for visual environment projects using this schema.	4
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"graphName": "http://www.sdi4apps.eu/poi.rdf", "endpointUrl": "https://www.foodie-cloud.org/sparql", "correlationId": "720060799879292670", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "propertyLevelOnly", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "propertyLevelOnly", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": true, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:33:04.685Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	31
240	use_pp_rels	\N	true	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	1	99973	\N	100000
2	1	2	27	\N	100000
3	2	1	521	\N	521
4	4	1	1635	\N	1635
5	5	1	100000	\N	100000
6	6	1	281	\N	281
7	8	1	26	\N	26
8	9	1	64	\N	322
9	9	2	258	\N	322
10	10	1	1546	\N	1546
11	12	1	281	\N	281
12	14	1	26	\N	26
13	15	1	777	\N	41293
14	15	2	40516	\N	41293
15	16	1	195	\N	195
16	17	1	2596	\N	2596
17	18	1	5182	\N	5182
18	19	1	1462	\N	1462
19	20	1	100000	\N	100000
20	21	3	100000	\N	100000
21	23	1	105	\N	100000
22	23	4	99895	\N	100000
23	24	1	26	\N	26
24	25	1	256	\N	284
25	25	2	28	\N	284
26	26	1	282	\N	282
27	27	2	247	\N	247
28	28	1	692	\N	692
29	29	1	282	\N	282
30	30	1	1546	\N	1546
31	33	1	144	\N	170
32	34	1	80076	\N	80076
33	35	1	1546	\N	1546
34	36	1	282	\N	282
35	38	1	93072	\N	100000
36	38	2	6928	\N	100000
37	39	1	3306	\N	3306
38	40	1	408	\N	408
39	43	1	100000	\N	100000
40	44	1	2761	\N	9103
41	44	2	6342	\N	9103
42	45	1	2562	\N	2562
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
1	1	22	2	2363455	\N	1000000
2	1	46	2	2037901	\N	1000000
3	1	23	2	1051151	\N	1000000
4	1	38	2	1015431	\N	1000000
5	1	3	2	1012018	\N	1000000
6	1	21	2	1004010	\N	1000000
7	1	1	2	1000512	\N	1000000
8	1	41	2	1000001	\N	1000000
9	1	11	2	1000000	\N	1000000
10	1	20	2	1000000	\N	1000000
11	1	32	2	1000000	\N	1000000
12	1	5	2	44894	\N	1000000
13	1	43	2	29010	\N	1000000
14	1	34	2	7130	\N	1000000
15	1	15	2	970	\N	1000000
16	1	7	2	612	\N	1000000
17	1	39	2	422	\N	1000000
18	1	42	2	371	\N	1000000
19	1	40	2	368	\N	1000000
20	1	4	2	174	\N	1000000
21	1	44	2	163	\N	1000000
22	1	19	2	154	\N	1000000
23	1	36	2	128	\N	1000000
24	1	29	2	128	\N	1000000
25	1	26	2	128	\N	1000000
26	1	12	2	127	\N	1000000
27	1	6	2	127	\N	1000000
28	1	18	2	22	\N	1000000
29	1	2	2	15	\N	1000000
30	1	9	2	13	\N	1000000
31	1	31	2	12	\N	1000000
32	1	45	2	9	\N	1000000
33	1	17	2	9	\N	1000000
34	1	30	2	8	\N	1000000
35	1	37	2	8	\N	1000000
36	1	35	2	8	\N	1000000
37	1	10	2	8	\N	1000000
38	2	23	2	1497	\N	\N
39	2	38	2	1258	\N	\N
40	2	46	2	1010	\N	\N
41	2	1	2	877	\N	\N
42	2	19	2	600	\N	\N
43	2	15	2	572	\N	\N
44	2	43	2	552	\N	\N
45	2	4	2	539	\N	\N
46	2	2	2	521	\N	\N
47	2	11	2	512	\N	\N
48	2	20	2	512	\N	\N
49	2	32	2	512	\N	\N
50	2	21	2	512	\N	\N
51	2	41	2	511	\N	\N
52	2	44	2	427	\N	\N
53	2	39	2	318	\N	\N
54	2	22	2	164	\N	\N
55	2	9	2	20	\N	\N
56	2	42	2	18	\N	\N
57	2	40	2	9	\N	\N
58	2	3	2	8	\N	\N
59	3	3	3	30576142	\N	\N
60	3	22	2	2691703	\N	1000000
61	3	46	2	1905911	\N	1000000
62	3	23	2	1109572	\N	1000000
63	3	38	2	1030421	\N	1000000
64	3	3	2	1023649	\N	1000000
65	3	21	2	1019315	\N	1000000
66	3	1	2	1000082	\N	1000000
67	3	11	2	1000000	\N	1000000
68	3	20	2	1000000	\N	1000000
69	3	32	2	1000000	\N	1000000
70	3	41	2	1000000	\N	1000000
71	3	43	2	25388	\N	1000000
72	3	5	2	12650	\N	1000000
73	3	34	2	4149	\N	1000000
74	3	18	2	138	\N	1000000
75	4	23	2	2937	\N	\N
76	4	46	2	2936	\N	\N
77	4	38	2	2594	\N	\N
78	4	22	2	2583	\N	\N
79	4	1	2	1971	\N	\N
80	4	41	2	1855	\N	\N
81	4	4	2	1635	\N	\N
82	4	11	2	1606	\N	\N
83	4	20	2	1606	\N	\N
84	4	32	2	1606	\N	\N
85	4	21	2	1606	\N	\N
86	4	19	2	1276	\N	\N
87	4	43	2	1247	\N	\N
88	4	15	2	1191	\N	\N
89	4	44	2	997	\N	\N
90	4	39	2	676	\N	\N
91	4	7	2	584	\N	\N
92	4	2	2	519	\N	\N
93	4	42	2	356	\N	\N
94	4	40	2	350	\N	\N
95	4	9	2	44	\N	\N
96	4	14	2	22	\N	\N
97	4	24	2	22	\N	\N
98	4	8	2	22	\N	\N
99	4	3	2	14	\N	\N
100	5	22	2	1034859	\N	\N
101	5	46	2	824970	\N	\N
102	5	38	2	433836	\N	\N
103	5	23	2	423816	\N	\N
104	5	1	2	411624	\N	\N
105	5	3	2	411355	\N	\N
106	5	41	2	410990	\N	\N
107	5	11	2	410899	\N	\N
108	5	20	2	410835	\N	\N
109	5	32	2	410491	\N	\N
110	5	21	2	410177	\N	\N
111	5	5	2	406856	\N	\N
112	5	43	2	83550	\N	\N
113	5	34	2	21712	\N	\N
114	6	46	2	611	\N	\N
115	6	22	2	562	\N	\N
116	6	23	2	282	\N	\N
117	6	39	2	282	\N	\N
118	6	36	2	282	\N	\N
119	6	29	2	282	\N	\N
120	6	26	2	282	\N	\N
121	6	11	2	281	\N	\N
122	6	20	2	281	\N	\N
123	6	32	2	281	\N	\N
124	6	41	2	281	\N	\N
125	6	1	2	281	\N	\N
126	6	21	2	281	\N	\N
127	6	38	2	281	\N	\N
128	6	12	2	281	\N	\N
129	6	6	2	281	\N	\N
130	7	28	1	692	\N	\N
131	7	7	3	692	\N	\N
132	7	7	2	692	\N	\N
133	7	40	2	395	\N	\N
134	7	38	2	347	\N	\N
135	7	22	2	346	\N	\N
136	7	42	2	343	\N	\N
137	7	15	2	290	\N	\N
138	7	23	2	210	\N	\N
139	7	11	2	173	\N	\N
140	7	20	2	173	\N	\N
141	7	32	2	173	\N	\N
142	7	41	2	173	\N	\N
143	7	1	2	173	\N	\N
144	7	21	2	173	\N	\N
145	7	46	2	173	\N	\N
146	7	4	2	146	\N	\N
147	7	19	2	36	\N	\N
148	8	22	2	208	\N	\N
149	8	46	2	46	\N	\N
150	8	23	2	32	\N	\N
151	8	41	2	29	\N	\N
152	8	11	2	26	\N	\N
153	8	20	2	26	\N	\N
154	8	32	2	26	\N	\N
155	8	1	2	26	\N	\N
156	8	21	2	26	\N	\N
157	8	14	2	26	\N	\N
158	8	24	2	26	\N	\N
159	8	8	2	26	\N	\N
160	8	15	2	26	\N	\N
161	8	38	2	26	\N	\N
162	8	42	2	26	\N	\N
163	8	39	2	26	\N	\N
164	8	43	2	25	\N	\N
165	8	4	2	22	\N	\N
166	8	19	2	19	\N	\N
167	9	38	2	1284	\N	\N
168	9	23	2	1206	\N	\N
169	9	15	2	836	\N	\N
170	9	1	2	665	\N	\N
171	9	22	2	600	\N	\N
172	9	46	2	576	\N	\N
173	9	41	2	324	\N	\N
174	9	9	2	322	\N	\N
175	9	11	2	300	\N	\N
176	9	20	2	300	\N	\N
177	9	32	2	300	\N	\N
178	9	21	2	300	\N	\N
179	9	39	2	290	\N	\N
180	9	27	2	247	\N	\N
181	9	16	2	195	\N	\N
182	9	43	2	159	\N	\N
183	9	19	2	129	\N	\N
184	9	4	2	51	\N	\N
185	9	2	2	15	\N	\N
186	9	40	2	9	\N	\N
187	9	42	2	2	\N	\N
188	10	22	2	14876	\N	\N
189	10	17	2	2596	\N	\N
190	10	45	2	2562	\N	\N
191	10	31	2	1850	\N	\N
192	10	23	2	1601	\N	\N
193	10	11	2	1546	\N	\N
194	10	20	2	1546	\N	\N
195	10	32	2	1546	\N	\N
196	10	41	2	1546	\N	\N
197	10	1	2	1546	\N	\N
198	10	21	2	1546	\N	\N
199	10	30	2	1546	\N	\N
200	10	37	2	1546	\N	\N
201	10	35	2	1546	\N	\N
202	10	10	2	1546	\N	\N
203	10	46	2	1546	\N	\N
204	10	38	2	1546	\N	\N
205	10	42	2	1546	\N	\N
206	11	22	1	2547103	\N	1000000
207	11	46	1	1997497	\N	1000000
208	11	38	1	1072769	\N	1000000
209	11	23	1	1050101	\N	1000000
210	11	21	1	1021396	\N	1000000
211	11	3	1	1008723	\N	1000000
212	11	1	1	1000554	\N	1000000
213	11	41	1	1000124	\N	1000000
214	11	11	1	1000000	\N	1000000
215	11	20	1	1000000	\N	1000000
216	11	32	1	1000000	\N	1000000
217	11	5	1	84626	\N	1000000
218	11	43	1	68620	\N	1000000
219	11	34	1	7952	\N	1000000
220	11	15	1	1078	\N	1000000
221	11	39	1	938	\N	1000000
222	11	19	1	362	\N	1000000
223	11	9	1	261	\N	1000000
224	11	27	1	247	\N	1000000
225	11	16	1	195	\N	1000000
226	11	4	1	159	\N	1000000
227	11	2	1	70	\N	1000000
228	11	42	1	41	\N	1000000
229	11	40	1	13	\N	1000000
230	11	14	1	3	\N	1000000
231	11	24	1	3	\N	1000000
232	11	8	1	3	\N	1000000
233	11	18	1	2	\N	1000000
234	11	11	3	30371128	\N	\N
235	11	31	3	1850	\N	\N
236	11	22	2	2547103	\N	1000000
237	11	46	2	1997497	\N	1000000
238	11	38	2	1072769	\N	1000000
239	11	23	2	1050101	\N	1000000
240	11	21	2	1021396	\N	1000000
241	11	3	2	1008723	\N	1000000
242	11	1	2	1000554	\N	1000000
243	11	41	2	1000124	\N	1000000
244	11	11	2	1000000	\N	1000000
245	11	20	2	1000000	\N	1000000
246	11	32	2	1000000	\N	1000000
247	11	5	2	84626	\N	1000000
248	11	43	2	68620	\N	1000000
249	11	34	2	7952	\N	1000000
250	11	15	2	1078	\N	1000000
251	11	39	2	938	\N	1000000
252	11	19	2	362	\N	1000000
253	11	9	2	261	\N	1000000
254	11	27	2	247	\N	1000000
255	11	16	2	195	\N	1000000
256	11	4	2	159	\N	1000000
257	11	2	2	70	\N	1000000
258	11	42	2	41	\N	1000000
259	11	40	2	13	\N	1000000
260	11	14	2	3	\N	1000000
261	11	24	2	3	\N	1000000
262	11	8	2	3	\N	1000000
263	11	18	2	2	\N	1000000
264	12	46	2	611	\N	\N
265	12	22	2	562	\N	\N
266	12	23	2	282	\N	\N
267	12	39	2	282	\N	\N
268	12	36	2	282	\N	\N
269	12	29	2	282	\N	\N
270	12	26	2	282	\N	\N
271	12	11	2	281	\N	\N
272	12	20	2	281	\N	\N
273	12	32	2	281	\N	\N
274	12	41	2	281	\N	\N
275	12	1	2	281	\N	\N
276	12	21	2	281	\N	\N
277	12	38	2	281	\N	\N
278	12	12	2	281	\N	\N
279	12	6	2	281	\N	\N
280	13	46	1	10	\N	\N
281	13	25	1	10	\N	\N
282	13	38	1	10	\N	\N
283	13	13	1	1	\N	\N
284	13	46	3	31346616	\N	\N
285	13	13	3	290	\N	\N
286	13	15	2	298	\N	\N
287	13	13	2	290	\N	\N
288	13	38	2	288	\N	\N
289	13	46	2	281	\N	\N
290	13	25	2	275	\N	\N
291	13	42	2	46	\N	\N
292	14	22	2	208	\N	\N
293	14	46	2	46	\N	\N
294	14	23	2	32	\N	\N
295	14	41	2	29	\N	\N
296	14	11	2	26	\N	\N
297	14	20	2	26	\N	\N
298	14	32	2	26	\N	\N
299	14	1	2	26	\N	\N
300	14	21	2	26	\N	\N
301	14	14	2	26	\N	\N
302	14	24	2	26	\N	\N
303	14	8	2	26	\N	\N
304	14	15	2	26	\N	\N
305	14	38	2	26	\N	\N
306	14	42	2	26	\N	\N
307	14	39	2	26	\N	\N
308	14	43	2	25	\N	\N
309	14	4	2	22	\N	\N
310	14	19	2	19	\N	\N
311	15	22	2	49050	\N	\N
312	15	15	2	41293	\N	\N
313	15	23	2	27183	\N	\N
314	15	46	2	26035	\N	\N
315	15	38	2	25579	\N	\N
316	15	41	2	24353	\N	\N
317	15	1	2	24209	\N	\N
318	15	11	2	23818	\N	\N
319	15	20	2	23818	\N	\N
320	15	32	2	23818	\N	\N
321	15	21	2	23818	\N	\N
322	15	42	2	1249	\N	\N
323	15	18	2	820	\N	\N
324	15	39	2	698	\N	\N
325	15	7	2	692	\N	\N
326	15	19	2	573	\N	\N
327	15	43	2	571	\N	\N
328	15	4	2	496	\N	\N
329	15	40	2	408	\N	\N
330	15	9	2	293	\N	\N
331	15	13	2	280	\N	\N
332	15	25	2	271	\N	\N
333	15	27	2	247	\N	\N
334	15	16	2	195	\N	\N
335	15	14	2	26	\N	\N
336	15	24	2	26	\N	\N
337	15	8	2	26	\N	\N
338	15	2	2	25	\N	\N
339	15	3	2	4	\N	\N
340	16	22	2	390	\N	\N
341	16	46	2	390	\N	\N
342	16	38	2	390	\N	\N
343	16	23	2	352	\N	\N
344	16	11	2	195	\N	\N
345	16	20	2	195	\N	\N
346	16	32	2	195	\N	\N
347	16	41	2	195	\N	\N
348	16	1	2	195	\N	\N
349	16	21	2	195	\N	\N
350	16	27	2	195	\N	\N
351	16	16	2	195	\N	\N
352	16	9	2	195	\N	\N
353	16	15	2	195	\N	\N
354	17	22	2	14158	\N	\N
355	17	17	2	2596	\N	\N
356	17	45	2	2562	\N	\N
357	17	31	2	1846	\N	\N
358	17	23	2	1506	\N	\N
359	17	11	2	1456	\N	\N
360	17	20	2	1456	\N	\N
361	17	32	2	1456	\N	\N
362	17	41	2	1456	\N	\N
363	17	1	2	1456	\N	\N
364	17	21	2	1456	\N	\N
365	17	30	2	1456	\N	\N
366	17	37	2	1456	\N	\N
367	17	35	2	1456	\N	\N
368	17	10	2	1456	\N	\N
369	17	46	2	1456	\N	\N
370	17	38	2	1456	\N	\N
371	17	42	2	1456	\N	\N
372	18	22	2	11837	\N	\N
373	18	46	2	10364	\N	\N
374	18	38	2	6636	\N	\N
375	18	23	2	6299	\N	\N
376	18	3	2	5254	\N	\N
377	18	21	2	5202	\N	\N
378	18	1	2	5193	\N	\N
379	18	11	2	5182	\N	\N
380	18	20	2	5182	\N	\N
381	18	32	2	5182	\N	\N
382	18	41	2	5182	\N	\N
383	18	18	2	5182	\N	\N
384	18	15	2	827	\N	\N
385	18	42	2	825	\N	\N
386	18	43	2	145	\N	\N
387	18	34	2	4	\N	\N
388	19	23	2	2685	\N	\N
389	19	22	2	2647	\N	\N
390	19	46	2	2471	\N	\N
391	19	38	2	2329	\N	\N
392	19	1	2	1715	\N	\N
393	19	41	2	1711	\N	\N
394	19	19	2	1462	\N	\N
395	19	11	2	1350	\N	\N
396	19	20	2	1350	\N	\N
397	19	32	2	1350	\N	\N
398	19	21	2	1350	\N	\N
399	19	43	2	1272	\N	\N
400	19	15	2	1223	\N	\N
401	19	4	2	1193	\N	\N
402	19	39	2	782	\N	\N
403	19	44	2	701	\N	\N
404	19	2	2	497	\N	\N
405	19	42	2	228	\N	\N
406	19	7	2	144	\N	\N
407	19	40	2	97	\N	\N
408	19	9	2	36	\N	\N
409	19	3	2	23	\N	\N
410	19	14	2	19	\N	\N
411	19	24	2	19	\N	\N
412	19	8	2	19	\N	\N
413	20	22	2	2547103	\N	1000000
414	20	46	2	1997497	\N	1000000
415	20	38	2	1072769	\N	1000000
416	20	23	2	1050101	\N	1000000
417	20	21	2	1021396	\N	1000000
418	20	3	2	1008723	\N	1000000
419	20	1	2	1000554	\N	1000000
420	20	41	2	1000124	\N	1000000
421	20	11	2	1000000	\N	1000000
422	20	20	2	1000000	\N	1000000
423	20	32	2	1000000	\N	1000000
424	20	5	2	84626	\N	1000000
425	20	43	2	68620	\N	1000000
426	20	34	2	7952	\N	1000000
427	20	15	2	1078	\N	1000000
428	20	39	2	938	\N	1000000
429	20	19	2	362	\N	1000000
430	20	9	2	261	\N	1000000
431	20	27	2	247	\N	1000000
432	20	16	2	195	\N	1000000
433	20	4	2	159	\N	1000000
434	20	2	2	70	\N	1000000
435	20	42	2	41	\N	1000000
436	20	40	2	13	\N	1000000
437	20	14	2	3	\N	1000000
438	20	24	2	3	\N	1000000
439	20	8	2	3	\N	1000000
440	20	18	2	2	\N	1000000
441	21	22	2	2547103	\N	1000000
442	21	46	2	1997497	\N	1000000
443	21	38	2	1072769	\N	1000000
444	21	23	2	1050101	\N	1000000
445	21	21	2	1021396	\N	1000000
446	21	3	2	1008723	\N	1000000
447	21	1	2	1000554	\N	1000000
448	21	41	2	1000124	\N	1000000
449	21	11	2	1000000	\N	1000000
450	21	20	2	1000000	\N	1000000
451	21	32	2	1000000	\N	1000000
452	21	5	2	84626	\N	1000000
453	21	43	2	68620	\N	1000000
454	21	34	2	7952	\N	1000000
455	21	15	2	1078	\N	1000000
456	21	39	2	938	\N	1000000
457	21	19	2	362	\N	1000000
458	21	9	2	261	\N	1000000
459	21	27	2	247	\N	1000000
460	21	16	2	195	\N	1000000
461	21	4	2	159	\N	1000000
462	21	2	2	70	\N	1000000
463	21	42	2	41	\N	1000000
464	21	40	2	13	\N	1000000
465	21	14	2	3	\N	1000000
466	21	24	2	3	\N	1000000
467	21	8	2	3	\N	1000000
468	21	18	2	2	\N	1000000
469	22	22	3	73539808	\N	\N
470	22	22	2	2247505	\N	1000000
471	22	46	2	1890497	\N	1000000
472	22	23	2	1126178	\N	1000000
473	22	38	2	1107760	\N	1000000
474	22	21	2	1006086	\N	1000000
475	22	3	2	1003451	\N	1000000
476	22	1	2	1000309	\N	1000000
477	22	41	2	1000008	\N	1000000
478	22	11	2	1000000	\N	1000000
479	22	20	2	1000000	\N	1000000
480	22	32	2	1000000	\N	1000000
481	22	43	2	22309	\N	1000000
482	22	5	2	18098	\N	1000000
483	22	34	2	2695	\N	1000000
484	22	39	2	1488	\N	1000000
485	22	18	2	471	\N	1000000
486	22	36	2	282	\N	1000000
487	22	29	2	282	\N	1000000
488	22	26	2	282	\N	1000000
489	22	12	2	281	\N	1000000
490	22	6	2	281	\N	1000000
491	22	15	2	59	\N	1000000
492	22	42	2	54	\N	1000000
493	22	14	2	26	\N	1000000
494	22	24	2	26	\N	1000000
495	22	8	2	26	\N	1000000
496	22	4	2	26	\N	1000000
497	22	19	2	23	\N	1000000
498	23	22	2	2547103	\N	1000000
499	23	46	2	1997497	\N	1000000
500	23	38	2	1072769	\N	1000000
501	23	23	2	1050101	\N	1000000
502	23	21	2	1021396	\N	1000000
503	23	3	2	1008723	\N	1000000
504	23	1	2	1000554	\N	1000000
505	23	41	2	1000124	\N	1000000
506	23	11	2	1000000	\N	1000000
507	23	20	2	1000000	\N	1000000
508	23	32	2	1000000	\N	1000000
509	23	5	2	84626	\N	1000000
510	23	43	2	68620	\N	1000000
511	23	34	2	7952	\N	1000000
512	23	15	2	1078	\N	1000000
513	23	39	2	938	\N	1000000
514	23	19	2	362	\N	1000000
515	23	9	2	261	\N	1000000
516	23	27	2	247	\N	1000000
517	23	16	2	195	\N	1000000
518	23	4	2	159	\N	1000000
519	23	2	2	70	\N	1000000
520	23	42	2	41	\N	1000000
521	23	40	2	13	\N	1000000
522	23	14	2	3	\N	1000000
523	23	24	2	3	\N	1000000
524	23	8	2	3	\N	1000000
525	23	18	2	2	\N	1000000
526	24	22	2	208	\N	\N
527	24	46	2	46	\N	\N
528	24	23	2	32	\N	\N
529	24	41	2	29	\N	\N
530	24	11	2	26	\N	\N
531	24	20	2	26	\N	\N
532	24	32	2	26	\N	\N
533	24	1	2	26	\N	\N
534	24	21	2	26	\N	\N
535	24	14	2	26	\N	\N
536	24	24	2	26	\N	\N
537	24	8	2	26	\N	\N
538	24	15	2	26	\N	\N
539	24	38	2	26	\N	\N
540	24	42	2	26	\N	\N
541	24	39	2	26	\N	\N
542	24	43	2	25	\N	\N
543	24	4	2	22	\N	\N
544	24	19	2	19	\N	\N
545	25	15	2	298	\N	\N
546	25	38	2	286	\N	\N
547	25	46	2	284	\N	\N
548	25	25	2	284	\N	\N
549	25	13	2	280	\N	\N
550	25	42	2	46	\N	\N
551	26	46	2	611	\N	\N
552	26	22	2	562	\N	\N
553	26	23	2	282	\N	\N
554	26	39	2	282	\N	\N
555	26	36	2	282	\N	\N
556	26	29	2	282	\N	\N
557	26	26	2	282	\N	\N
558	26	11	2	281	\N	\N
559	26	20	2	281	\N	\N
560	26	32	2	281	\N	\N
561	26	41	2	281	\N	\N
562	26	1	2	281	\N	\N
563	26	21	2	281	\N	\N
564	26	38	2	281	\N	\N
565	26	12	2	281	\N	\N
566	26	6	2	281	\N	\N
567	27	22	2	494	\N	\N
568	27	46	2	494	\N	\N
569	27	38	2	494	\N	\N
570	27	23	2	445	\N	\N
571	27	11	2	247	\N	\N
572	27	20	2	247	\N	\N
573	27	32	2	247	\N	\N
574	27	41	2	247	\N	\N
575	27	1	2	247	\N	\N
576	27	21	2	247	\N	\N
577	27	27	2	247	\N	\N
578	27	9	2	247	\N	\N
579	27	15	2	247	\N	\N
580	27	16	2	195	\N	\N
581	28	28	2	692	\N	\N
582	29	46	2	611	\N	\N
583	29	22	2	562	\N	\N
584	29	23	2	282	\N	\N
585	29	39	2	282	\N	\N
586	29	36	2	282	\N	\N
587	29	29	2	282	\N	\N
588	29	26	2	282	\N	\N
589	29	11	2	281	\N	\N
590	29	20	2	281	\N	\N
591	29	32	2	281	\N	\N
592	29	41	2	281	\N	\N
593	29	1	2	281	\N	\N
594	29	21	2	281	\N	\N
595	29	38	2	281	\N	\N
596	29	12	2	281	\N	\N
597	29	6	2	281	\N	\N
598	30	22	2	14876	\N	\N
599	30	17	2	2596	\N	\N
600	30	45	2	2562	\N	\N
601	30	31	2	1850	\N	\N
602	30	23	2	1601	\N	\N
603	30	11	2	1546	\N	\N
604	30	20	2	1546	\N	\N
605	30	32	2	1546	\N	\N
606	30	41	2	1546	\N	\N
607	30	1	2	1546	\N	\N
608	30	21	2	1546	\N	\N
609	30	30	2	1546	\N	\N
610	30	37	2	1546	\N	\N
611	30	35	2	1546	\N	\N
612	30	10	2	1546	\N	\N
613	30	46	2	1546	\N	\N
614	30	38	2	1546	\N	\N
615	30	42	2	1546	\N	\N
616	31	22	1	10381	\N	\N
617	31	17	1	1952	\N	\N
618	31	45	1	1921	\N	\N
619	31	31	1	1843	\N	\N
620	31	23	1	1097	\N	\N
621	31	11	1	1060	\N	\N
622	31	20	1	1060	\N	\N
623	31	32	1	1060	\N	\N
624	31	41	1	1060	\N	\N
625	31	1	1	1060	\N	\N
626	31	21	1	1060	\N	\N
627	31	30	1	1060	\N	\N
628	31	37	1	1060	\N	\N
629	31	35	1	1060	\N	\N
630	31	10	1	1060	\N	\N
631	31	46	1	1060	\N	\N
632	31	38	1	1060	\N	\N
633	31	42	1	1060	\N	\N
634	31	31	3	1850	\N	\N
635	31	11	3	1060	\N	\N
636	31	22	2	10373	\N	\N
637	31	17	2	1952	\N	\N
638	31	45	2	1921	\N	\N
639	31	31	2	1850	\N	\N
640	31	23	2	1096	\N	\N
641	31	11	2	1059	\N	\N
642	31	20	2	1059	\N	\N
643	31	32	2	1059	\N	\N
644	31	41	2	1059	\N	\N
645	31	1	2	1059	\N	\N
646	31	21	2	1059	\N	\N
647	31	30	2	1059	\N	\N
648	31	37	2	1059	\N	\N
649	31	35	2	1059	\N	\N
650	31	10	2	1059	\N	\N
651	31	46	2	1059	\N	\N
652	31	38	2	1059	\N	\N
653	31	42	2	1059	\N	\N
654	32	32	3	30371128	\N	\N
655	32	22	2	2547103	\N	1000000
656	32	46	2	1997497	\N	1000000
657	32	38	2	1072769	\N	1000000
658	32	23	2	1050101	\N	1000000
659	32	21	2	1021396	\N	1000000
660	32	3	2	1008723	\N	1000000
661	32	1	2	1000554	\N	1000000
662	32	41	2	1000124	\N	1000000
663	32	11	2	1000000	\N	1000000
664	32	20	2	1000000	\N	1000000
665	32	32	2	1000000	\N	1000000
666	32	5	2	84626	\N	1000000
667	32	43	2	68620	\N	1000000
668	32	34	2	7952	\N	1000000
669	32	15	2	1078	\N	1000000
670	32	39	2	938	\N	1000000
671	32	19	2	362	\N	1000000
672	32	9	2	261	\N	1000000
673	32	27	2	247	\N	1000000
674	32	16	2	195	\N	1000000
675	32	4	2	159	\N	1000000
676	32	2	2	70	\N	1000000
677	32	42	2	41	\N	1000000
678	32	40	2	13	\N	1000000
679	32	14	2	3	\N	1000000
680	32	24	2	3	\N	1000000
681	32	8	2	3	\N	1000000
682	32	18	2	2	\N	1000000
683	33	33	3	26	\N	\N
684	33	33	2	196	\N	\N
685	34	22	2	188431	\N	\N
686	34	46	2	162126	\N	\N
687	34	38	2	92536	\N	\N
688	34	23	2	81713	\N	\N
689	34	3	2	80026	\N	\N
690	34	1	2	79879	\N	\N
691	34	21	2	79803	\N	\N
692	34	41	2	79738	\N	\N
693	34	20	2	79691	\N	\N
694	34	11	2	79688	\N	\N
695	34	32	2	79637	\N	\N
696	34	34	2	78800	\N	\N
697	34	43	2	27876	\N	\N
698	34	5	2	21749	\N	\N
699	34	18	2	4	\N	\N
700	35	22	2	14876	\N	\N
701	35	17	2	2596	\N	\N
702	35	45	2	2562	\N	\N
703	35	31	2	1850	\N	\N
704	35	23	2	1601	\N	\N
705	35	11	2	1546	\N	\N
706	35	20	2	1546	\N	\N
707	35	32	2	1546	\N	\N
708	35	41	2	1546	\N	\N
709	35	1	2	1546	\N	\N
710	35	21	2	1546	\N	\N
711	35	30	2	1546	\N	\N
712	35	37	2	1546	\N	\N
713	35	35	2	1546	\N	\N
714	35	10	2	1546	\N	\N
715	35	46	2	1546	\N	\N
716	35	38	2	1546	\N	\N
717	35	42	2	1546	\N	\N
718	36	46	2	611	\N	\N
719	36	22	2	562	\N	\N
720	36	23	2	282	\N	\N
721	36	39	2	282	\N	\N
722	36	36	2	282	\N	\N
723	36	29	2	282	\N	\N
724	36	26	2	282	\N	\N
725	36	11	2	281	\N	\N
726	36	20	2	281	\N	\N
727	36	32	2	281	\N	\N
728	36	41	2	281	\N	\N
729	36	1	2	281	\N	\N
730	36	21	2	281	\N	\N
731	36	38	2	281	\N	\N
732	36	12	2	281	\N	\N
733	36	6	2	281	\N	\N
734	37	38	1	2	\N	\N
735	37	46	1	1	\N	\N
736	37	13	1	1	\N	\N
737	37	37	3	1546	\N	\N
738	37	46	3	1546	\N	\N
739	37	22	2	14876	\N	\N
740	37	17	2	2596	\N	\N
741	37	45	2	2562	\N	\N
742	37	31	2	1850	\N	\N
743	37	23	2	1601	\N	\N
744	37	11	2	1546	\N	\N
745	37	20	2	1546	\N	\N
746	37	32	2	1546	\N	\N
747	37	41	2	1546	\N	\N
748	37	1	2	1546	\N	\N
749	37	21	2	1546	\N	\N
750	37	30	2	1546	\N	\N
751	37	37	2	1546	\N	\N
752	37	35	2	1546	\N	\N
753	37	10	2	1546	\N	\N
754	37	46	2	1546	\N	\N
755	37	38	2	1546	\N	\N
756	37	42	2	1546	\N	\N
757	38	22	2	2543119	\N	1000000
758	38	46	2	1994169	\N	1000000
759	38	38	2	1072771	\N	1000000
760	38	23	2	1048272	\N	1000000
761	38	21	2	1019612	\N	1000000
762	38	3	2	1006941	\N	1000000
763	38	1	2	998772	\N	1000000
764	38	41	2	998342	\N	1000000
765	38	11	2	998218	\N	1000000
766	38	20	2	998218	\N	1000000
767	38	32	2	998218	\N	1000000
768	38	5	2	84626	\N	1000000
769	38	43	2	68618	\N	1000000
770	38	34	2	7939	\N	1000000
771	38	15	2	1329	\N	1000000
772	38	39	2	938	\N	1000000
773	38	19	2	362	\N	1000000
774	38	9	2	261	\N	1000000
775	38	27	2	247	\N	1000000
776	38	25	2	236	\N	1000000
777	38	13	2	234	\N	1000000
778	38	16	2	195	\N	1000000
779	38	4	2	159	\N	1000000
780	38	42	2	72	\N	1000000
781	38	2	2	70	\N	1000000
782	38	40	2	13	\N	1000000
783	38	14	2	3	\N	1000000
784	38	24	2	3	\N	1000000
785	38	8	2	3	\N	1000000
786	38	18	2	2	\N	1000000
787	39	22	2	5112	\N	\N
788	39	46	2	3626	\N	\N
789	39	23	2	3559	\N	\N
790	39	38	2	2838	\N	\N
791	39	41	2	2253	\N	\N
792	39	1	2	2126	\N	\N
793	39	39	2	2003	\N	\N
794	39	11	2	1867	\N	\N
795	39	21	2	1861	\N	\N
796	39	20	2	1858	\N	\N
797	39	32	2	1850	\N	\N
798	39	15	2	937	\N	\N
799	39	43	2	562	\N	\N
800	39	19	2	543	\N	\N
801	39	4	2	428	\N	\N
802	39	36	2	280	\N	\N
803	39	12	2	279	\N	\N
804	39	29	2	279	\N	\N
805	39	26	2	277	\N	\N
806	39	6	2	276	\N	\N
807	39	2	2	78	\N	\N
808	39	42	2	66	\N	\N
809	39	9	2	60	\N	\N
810	39	14	2	26	\N	\N
811	39	24	2	26	\N	\N
812	39	8	2	25	\N	\N
813	39	3	2	13	\N	\N
814	39	40	2	4	\N	\N
815	40	38	2	1066	\N	\N
816	40	23	2	901	\N	\N
817	40	15	2	840	\N	\N
818	40	7	2	684	\N	\N
819	40	1	2	541	\N	\N
820	40	40	2	408	\N	\N
821	40	22	2	352	\N	\N
822	40	42	2	339	\N	\N
823	40	39	2	243	\N	\N
824	40	41	2	181	\N	\N
825	40	11	2	176	\N	\N
826	40	20	2	176	\N	\N
827	40	32	2	176	\N	\N
828	40	21	2	176	\N	\N
829	40	46	2	176	\N	\N
830	40	4	2	176	\N	\N
831	40	19	2	153	\N	\N
832	40	43	2	145	\N	\N
833	40	9	2	13	\N	\N
834	40	2	2	10	\N	\N
835	41	41	3	30371646	\N	\N
836	41	22	2	2000010	\N	1000000
837	41	23	2	1484727	\N	1000000
838	41	46	2	1003411	\N	1000000
839	41	38	2	1000567	\N	1000000
840	41	1	2	1000250	\N	1000000
841	41	11	2	1000000	\N	1000000
842	41	20	2	1000000	\N	1000000
843	41	32	2	1000000	\N	1000000
844	41	41	2	1000000	\N	1000000
845	41	21	2	1000000	\N	1000000
846	41	3	2	997193	\N	1000000
847	41	39	2	2258	\N	1000000
848	41	15	2	1373	\N	1000000
849	41	42	2	1192	\N	1000000
850	41	18	2	820	\N	1000000
851	41	27	2	247	\N	1000000
852	41	9	2	247	\N	1000000
853	41	43	2	205	\N	1000000
854	41	16	2	195	\N	1000000
855	41	19	2	151	\N	1000000
856	41	4	2	99	\N	1000000
857	41	2	2	53	\N	1000000
858	42	38	1	1546	\N	\N
859	42	33	1	196	\N	\N
860	42	42	3	1772	\N	\N
861	42	22	2	17565	\N	\N
862	42	23	2	4048	\N	\N
863	42	46	2	3922	\N	\N
864	42	42	2	3198	\N	\N
865	42	38	2	3078	\N	\N
866	42	41	2	2869	\N	\N
867	42	1	2	2833	\N	\N
868	42	11	2	2822	\N	\N
869	42	20	2	2822	\N	\N
870	42	32	2	2822	\N	\N
871	42	21	2	2822	\N	\N
872	42	17	2	2596	\N	\N
873	42	45	2	2562	\N	\N
874	42	31	2	1850	\N	\N
875	42	30	2	1546	\N	\N
876	42	37	2	1546	\N	\N
877	42	35	2	1546	\N	\N
878	42	10	2	1546	\N	\N
879	42	15	2	1201	\N	\N
880	42	18	2	819	\N	\N
881	42	7	2	692	\N	\N
882	42	40	2	395	\N	\N
883	42	4	2	198	\N	\N
884	42	43	2	161	\N	\N
885	42	19	2	137	\N	\N
886	42	3	2	72	\N	\N
887	42	39	2	55	\N	\N
888	42	13	2	27	\N	\N
889	42	14	2	26	\N	\N
890	42	24	2	26	\N	\N
891	42	8	2	26	\N	\N
892	42	25	2	25	\N	\N
893	42	2	2	12	\N	\N
894	42	9	2	4	\N	\N
895	43	22	2	1429763	\N	\N
896	43	46	2	1152458	\N	\N
897	43	38	2	605679	\N	\N
898	43	23	2	577383	\N	\N
899	43	3	2	563273	\N	\N
900	43	1	2	555117	\N	\N
901	43	41	2	554040	\N	\N
902	43	43	2	553880	\N	\N
903	43	11	2	553572	\N	\N
904	43	20	2	553483	\N	\N
905	43	32	2	553010	\N	\N
906	43	21	2	552768	\N	\N
907	43	5	2	82722	\N	\N
908	43	34	2	27524	\N	\N
909	43	19	2	1126	\N	\N
910	43	4	2	1093	\N	\N
911	43	15	2	879	\N	\N
912	43	44	2	682	\N	\N
913	43	39	2	538	\N	\N
914	43	2	2	407	\N	\N
915	43	42	2	268	\N	\N
916	43	18	2	145	\N	\N
917	43	9	2	26	\N	\N
918	43	14	2	25	\N	\N
919	43	24	2	25	\N	\N
920	43	8	2	24	\N	\N
921	43	40	2	4	\N	\N
922	44	46	2	16579	\N	\N
923	44	22	2	12684	\N	\N
924	44	23	2	9771	\N	\N
925	44	11	2	9103	\N	\N
926	44	20	2	9103	\N	\N
927	44	32	2	9103	\N	\N
928	44	41	2	9103	\N	\N
929	44	1	2	9103	\N	\N
930	44	21	2	9103	\N	\N
931	44	38	2	9103	\N	\N
932	44	44	2	9103	\N	\N
933	44	4	2	997	\N	\N
934	44	19	2	701	\N	\N
935	44	43	2	697	\N	\N
936	44	2	2	427	\N	\N
937	45	22	2	14158	\N	\N
938	45	17	2	2596	\N	\N
939	45	45	2	2562	\N	\N
940	45	31	2	1846	\N	\N
941	45	23	2	1506	\N	\N
942	45	11	2	1456	\N	\N
943	45	20	2	1456	\N	\N
944	45	32	2	1456	\N	\N
945	45	41	2	1456	\N	\N
946	45	1	2	1456	\N	\N
947	45	21	2	1456	\N	\N
948	45	30	2	1456	\N	\N
949	45	37	2	1456	\N	\N
950	45	35	2	1456	\N	\N
951	45	10	2	1456	\N	\N
952	45	46	2	1456	\N	\N
953	45	38	2	1456	\N	\N
954	45	42	2	1456	\N	\N
955	46	15	1	297	\N	\N
956	46	38	1	290	\N	\N
957	46	46	1	286	\N	\N
958	46	13	1	286	\N	\N
959	46	25	1	283	\N	\N
960	46	42	1	46	\N	\N
961	46	46	3	58051027	\N	\N
962	46	37	3	1546	\N	\N
963	46	13	3	290	\N	\N
964	46	22	2	2301062	\N	1000000
965	46	46	2	2084796	\N	1000000
966	46	23	2	1127370	\N	1000000
967	46	38	2	1041359	\N	1000000
968	46	21	2	1003728	\N	1000000
969	46	3	2	1000114	\N	1000000
970	46	1	2	999797	\N	1000000
971	46	11	2	999709	\N	1000000
972	46	20	2	999709	\N	1000000
973	46	32	2	999709	\N	1000000
974	46	41	2	999695	\N	1000000
975	46	43	2	62645	\N	1000000
976	46	34	2	18910	\N	1000000
977	46	4	2	688	\N	1000000
978	46	44	2	656	\N	1000000
979	46	19	2	642	\N	1000000
980	46	5	2	457	\N	1000000
981	46	2	2	390	\N	1000000
982	46	15	2	321	\N	1000000
983	46	13	2	290	\N	1000000
984	46	25	2	284	\N	1000000
985	46	42	2	70	\N	1000000
986	46	18	2	47	\N	1000000
987	46	39	2	40	\N	1000000
988	46	14	2	23	\N	1000000
989	46	24	2	23	\N	1000000
990	46	8	2	23	\N	1000000
991	46	12	2	1	\N	1000000
992	46	36	2	1	\N	1000000
993	46	6	2	1	\N	1000000
994	46	29	2	1	\N	1000000
995	46	26	2	1	\N	1000000
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://purl.org/dc/elements/1.1/title	30373806	\N	6	title	title	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://www.openvoc.eu/poi#fax	521	\N	70	fax	fax	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.w3.org/2004/02/skos/core#exactMatch	30576254	\N	4	exactMatch	exactMatch	f	30576142	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://xmlns.com/foaf/0.1/phone	1635	\N	8	phone	phone	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://www.openvoc.eu/poi#cuisine	412540	\N	70	cuisine	cuisine	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://www.w3.org/ns/locn#postCode	281	\N	71	postCode	postCode	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://www.openvoc.eu/poi#region	692	\N	70	region	region	f	692	-1	1	f	f	139	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://www.openvoc.eu/poi#product	26	\N	70	product	product	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://www.openvoc.eu/poi#openingHours	322	\N	70	openingHours	openingHours	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://www.openvoc.eu/poi#signpostRegistrationNumber	1546	\N	70	signpostRegistrationNumber	signpostRegistrationNumber	f	0	1	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://purl.org/dc/elements/1.1/identifier	30371128	\N	6	identifier	identifier	f	30371128	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/ns/locn#adminUnitL1	281	\N	71	adminUnitL1	adminUnitL1	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://www.w3.org/2000/01/rdf-schema#subClassOf	290	\N	2	subClassOf	subClassOf	f	290	-1	-1	f	f	217	217	\N	t	f	\N	\N	\N	t	f	f
14	http://www.openvoc.eu/poi#accommodation	26	\N	70	accommodation	accommodation	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2000/01/rdf-schema#comment	41293	\N	2	comment	comment	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://www.openvoc.eu/poi#address	195	\N	70	address	address	f	0	1	\N	f	f	262	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.openvoc.eu/poi#hikingSignpost	2596	\N	70	hikingSignpost	hikingSignpost	f	0	-1	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://www.openvoc.eu/poi#iata	5182	\N	70	iata	iata	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://xmlns.com/foaf/0.1/mbox	1462	\N	8	mbox	mbox	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://purl.org/dc/elements/1.1/publisher	30371128	\N	6	publisher	publisher	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://purl.org/dc/terms/1.1/created	30528560	\N	72	created	created	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://www.opengis.net/ont/geosparql#sfWithin	73539808	\N	25	sfWithin	sfWithin	f	73539808	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://www.opengis.net/ont/geosparql#asWKT	33522555	\N	25	asWKT	asWKT	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.openvoc.eu/poi#activity	26	\N	70	activity	activity	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	284	\N	2	isDefinedBy	isDefinedBy	f	0	1	\N	f	f	217	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://www.w3.org/ns/locn#thoroughfare	282	\N	71	thoroughfare	thoroughfare	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://www.openvoc.eu/poi#accessibility	247	\N	70	accessibility	accessibility	f	0	1	\N	f	f	262	\N	\N	t	f	\N	\N	\N	t	f	f
28	resource	692	\N	73	resource	resource	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.w3.org/ns/locn#postName	282	\N	71	postName	postName	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://www.openvoc.eu/poi#altitude	1546	\N	70	altitude	altitude	f	0	1	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://www.openvoc.eu/poi#next	1850	\N	70	next	next	f	1850	-1	-1	f	f	70	70	\N	t	f	\N	\N	\N	t	f	f
32	http://purl.org/dc/elements/1.1/rights	30371128	\N	6	rights	rights	f	30371128	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://purl.org/dc/elements/1.1/type	196	\N	6	type	type	f	26	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://www.openvoc.eu/poi#internetAccess	80076	\N	70	internetAccess	internetAccess	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://www.openvoc.eu/poi#signpostRegistrationCode	1546	\N	70	signpostRegistrationCode	signpostRegistrationCode	f	0	1	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://www.w3.org/ns/locn#locatorDesignator	282	\N	71	locatorDesignator	locatorDesignator	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://www.openvoc.eu/poi#class	1546	\N	70	class	class	f	1546	1	-1	f	f	70	217	\N	t	f	\N	\N	\N	t	f	f
38	http://www.w3.org/2000/01/rdf-schema#label	31657984	\N	2	label	label	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://www.w3.org/ns/locn#fullAddress	3306	\N	71	fullAddress	fullAddress	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.openvoc.eu/poi#access	408	\N	70	access	access	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://purl.org/dc/elements/1.1/source	30371646	\N	6	source	source	f	30371646	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/2000/01/rdf-schema#seeAlso	3198	\N	2	seeAlso	seeAlso	f	1772	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://xmlns.com/foaf/0.1/homepage	556614	\N	8	homepage	homepage	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/ns/locnfullAddress	9103	\N	74	locnfullAddress	locnfullAddress	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://www.openvoc.eu/poi#hikingRoute	2562	\N	70	hikingRoute	hikingRoute	f	0	-1	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	58051027	\N	1	type	type	f	58051027	-1	-1	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

COPY http_foodie_cloud_poi_rdf.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cc_rels_id_seq', 277, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.class_annots_id_seq', 290, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.classes_id_seq', 290, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cp_rels_id_seq', 4254, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cpc_rels_id_seq', 3410, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.datatypes_id_seq', 4, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.ns_id_seq', 74, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.parameters_id_seq', 32, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.pd_rels_id_seq', 42, true);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.pp_rels_id_seq', 995, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.properties_id_seq', 46, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

SELECT pg_catalog.setval('http_foodie_cloud_poi_rdf.property_annots_id_seq', 1, false);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_foodie_cloud_poi_rdf.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_foodie_cloud_poi_rdf.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_foodie_cloud_poi_rdf.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_foodie_cloud_poi_rdf.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_foodie_cloud_poi_rdf.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_foodie_cloud_poi_rdf.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_foodie_cloud_poi_rdf.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_foodie_cloud_poi_rdf.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_foodie_cloud_poi_rdf.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_foodie_cloud_poi_rdf.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_foodie_cloud_poi_rdf.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_foodie_cloud_poi_rdf.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_foodie_cloud_poi_rdf.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_foodie_cloud_poi_rdf.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_foodie_cloud_poi_rdf.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_foodie_cloud_poi_rdf.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_foodie_cloud_poi_rdf.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_foodie_cloud_poi_rdf.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_classes_data ON http_foodie_cloud_poi_rdf.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_classes_iri ON http_foodie_cloud_poi_rdf.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_foodie_cloud_poi_rdf.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_foodie_cloud_poi_rdf.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_foodie_cloud_poi_rdf.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_foodie_cloud_poi_rdf.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_foodie_cloud_poi_rdf.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_foodie_cloud_poi_rdf.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_instances_test ON http_foodie_cloud_poi_rdf.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_foodie_cloud_poi_rdf.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_foodie_cloud_poi_rdf.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_foodie_cloud_poi_rdf.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_properties_data ON http_foodie_cloud_poi_rdf.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

CREATE INDEX idx_properties_iri ON http_foodie_cloud_poi_rdf.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_poi_rdf.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_poi_rdf.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_poi_rdf.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_poi_rdf.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_poi_rdf.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_poi_rdf.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_poi_rdf.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_foodie_cloud_poi_rdf.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_foodie_cloud_poi_rdf.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_poi_rdf.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_poi_rdf.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_poi_rdf.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_foodie_cloud_poi_rdf.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_poi_rdf.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_foodie_cloud_poi_rdf.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_foodie_cloud_poi_rdf.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_poi_rdf.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_foodie_cloud_poi_rdf.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_foodie_cloud_poi_rdf.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_foodie_cloud_poi_rdf.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_foodie_cloud_poi_rdf; Owner: -
--

ALTER TABLE ONLY http_foodie_cloud_poi_rdf.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_foodie_cloud_poi_rdf.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

