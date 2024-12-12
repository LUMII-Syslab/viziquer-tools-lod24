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
-- Name: http_dati_camera_it_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_dati_camera_it_sparql;


--
-- Name: SCHEMA http_dati_camera_it_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_dati_camera_it_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE FUNCTION http_dati_camera_it_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE FUNCTION http_dati_camera_it_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_dati_camera_it_sparql; Owner: -
--

COMMENT ON TABLE http_dati_camera_it_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_dati_camera_it_sparql; Owner: -
--

COMMENT ON COLUMN http_dati_camera_it_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_dati_camera_it_sparql.classes c1
     JOIN http_dati_camera_it_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_dati_camera_it_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_dati_camera_it_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_dati_camera_it_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE TABLE http_dati_camera_it_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE http_dati_camera_it_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_camera_it_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_cc_rels AS
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
   FROM http_dati_camera_it_sparql.cc_rels r,
    http_dati_camera_it_sparql.classes c1,
    http_dati_camera_it_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_classes_ns AS
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
    http_dati_camera_it_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_dati_camera_it_sparql.classes c
     LEFT JOIN http_dati_camera_it_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_classes_ns_main AS
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
   FROM http_dati_camera_it_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_dati_camera_it_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_classes_ns_plus AS
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
    http_dati_camera_it_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_dati_camera_it_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_dati_camera_it_sparql.classes c
     LEFT JOIN http_dati_camera_it_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_classes_ns_main_plus AS
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
   FROM http_dati_camera_it_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_dati_camera_it_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_dati_camera_it_sparql.v_classes_ns v
     LEFT JOIN http_dati_camera_it_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_cp_rels AS
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
    http_dati_camera_it_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_dati_camera_it_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_dati_camera_it_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_dati_camera_it_sparql.cp_rels r,
    http_dati_camera_it_sparql.classes c,
    http_dati_camera_it_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_cp_rels_card AS
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
   FROM http_dati_camera_it_sparql.cp_rels r,
    http_dati_camera_it_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_properties_ns AS
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
    http_dati_camera_it_sparql.tapprox(p.cnt) AS cnt_x,
    http_dati_camera_it_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_dati_camera_it_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_dati_camera_it_sparql.properties p
     LEFT JOIN http_dati_camera_it_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_cp_sources_single AS
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
   FROM ((http_dati_camera_it_sparql.v_cp_rels_card r
     JOIN http_dati_camera_it_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_dati_camera_it_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_cp_targets_single AS
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
   FROM ((http_dati_camera_it_sparql.v_cp_rels_card r
     JOIN http_dati_camera_it_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_dati_camera_it_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_dati_camera_it_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_dati_camera_it_sparql.pp_rels r,
    http_dati_camera_it_sparql.properties p1,
    http_dati_camera_it_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_properties_sources AS
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
   FROM (http_dati_camera_it_sparql.v_properties_ns v
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
           FROM http_dati_camera_it_sparql.cp_rels r,
            http_dati_camera_it_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_properties_sources_single AS
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
   FROM (http_dati_camera_it_sparql.v_properties_ns v
     LEFT JOIN http_dati_camera_it_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_properties_targets AS
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
   FROM (http_dati_camera_it_sparql.v_properties_ns v
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
           FROM http_dati_camera_it_sparql.cp_rels r,
            http_dati_camera_it_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE VIEW http_dati_camera_it_sparql.v_properties_targets_single AS
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
   FROM (http_dati_camera_it_sparql.v_properties_ns v
     LEFT JOIN http_dati_camera_it_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	14	78	1	\N	\N
2	15	47	1	\N	\N
3	16	32	1	\N	\N
4	71	85	1	\N	\N
5	73	76	1	\N	\N
6	80	47	1	\N	\N
7	89	32	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	10	8	post	\N
2	10	8	post	\N
3	16	8	abbinamento	\N
4	16	8	abbinamento	\N
5	17	8	assegnazione	\N
6	17	8	assegnazione	\N
7	18	8	atto camera	\N
8	18	8	atto camera	\N
9	19	8	bollettino	\N
10	19	8	bollettino	\N
11	20	8	incarico	\N
12	20	8	incarico	\N
13	21	8	intervento in una discussione	\N
14	21	8	intervento in una discussione	\N
15	22	8	legge	\N
16	22	8	legge	\N
17	23	8	luogo	\N
18	23	8	luogo	\N
19	24	8	membro di Governo	\N
20	24	8	membro di Governo	\N
21	25	8	presidente della Camera dei deputati	\N
22	25	8	presidente della Camera dei deputati	\N
23	26	8	presidente del Consiglio dei ministri	\N
24	26	8	presidente del Consiglio dei ministri	\N
25	27	8	relatore di un atto camera	\N
26	27	8	relatore di un atto camera	\N
27	28	8	senatore	\N
28	28	8	senatore	\N
29	29	8	stato iter	\N
30	29	8	stato iter	\N
31	30	8	ufficio Parlamentare	\N
32	30	8	ufficio Parlamentare	\N
33	31	8	voto del deputato in una votazione	\N
34	31	8	voto del deputato in una votazione	\N
35	53	8	allegato ad una discussione	\N
36	53	8	allegato ad una discussione	\N
37	54	8	assemblea	\N
38	54	8	assemblea	\N
39	55	8	autore	\N
40	55	8	autore	\N
41	56	8	componente del Gruppo Misto	\N
42	56	8	componente del Gruppo Misto	\N
43	57	8	discussione	\N
44	57	8	discussione	\N
45	58	8	elezione	\N
46	58	8	elezione	\N
47	59	8	governo	\N
48	59	8	governo	\N
49	60	8	gruppo parlamentare	\N
50	60	8	gruppo parlamentare	\N
51	61	8	legislatura	\N
52	61	8	legislatura	\N
53	62	8	mandato	\N
54	62	8	mandato	\N
55	63	8	natura	\N
56	63	8	natura	\N
57	64	8	organo	\N
58	64	8	organo	\N
59	65	8	presidente della Repubblica	\N
60	65	8	presidente della Repubblica	\N
61	66	8	risposta scritta alle interrogazioni	\N
62	66	8	risposta scritta alle interrogazioni	\N
63	67	8	trasmissione	\N
64	67	8	trasmissione	\N
65	68	8	votazione	\N
66	68	8	votazione	\N
67	70	8	Person	\N
68	75	8	sessione legislatura	\N
69	75	8	sessione legislatura	\N
70	81	8	Online Account	\N
71	82	8	doc	\N
72	82	8	doc	\N
73	83	8	atti di indirizzo e controllo	\N
74	83	8	atti di indirizzo e controllo	\N
75	84	8	cronologia	\N
76	84	8	cronologia	\N
77	85	8	deputato	\N
78	85	8	deputato	\N
79	86	8	dibattito	\N
80	86	8	dibattito	\N
81	87	8	mandato	\N
82	87	8	mandato	\N
83	88	8	organo governativo	\N
84	88	8	organo governativo	\N
85	89	8	richiesta parere	\N
86	89	8	richiesta parere	\N
87	90	8	seduta	\N
88	90	8	seduta	\N
89	91	8	sistema elettorale	\N
90	91	8	sistema elettorale	\N
91	92	8	versione testo atto camera	\N
92	92	8	versione testo atto camera	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://purl.org/ontology/bibo/Article	41033	\N	t	31	Article	Article	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
2	http://purl.org/ontology/bibo/Book	12116	\N	t	31	Book	Book	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13138
3	http://purl.org/ontology/bibo/Periodical	2367	\N	t	31	Periodical	Periodical	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27604
4	http://culturalis.org/oad#Instance	74831	\N	t	74	Instance	Instance	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	145153
5	http://purl.org/ontology/bibo/Website	9	\N	t	31	Website	Website	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://dati.camera.it/ocd/file	11705	\N	t	69	file	file	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11911
7	http://culturalis.org/oad#ArchivalResource	143	\N	t	74	ArchivalResource	ArchivalResource	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	305
8	http://linkedgeodata.org/ontology/Place	1	\N	t	75	Place	Place	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
9	http://www.w3.org/ns/org#OrganizationalUnit	30	\N	t	37	OrganizationalUnit	OrganizationalUnit	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6366
10	http://dati.camera.it/ocd/post	10842	\N	t	69	post	post	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
11	http://culturalis.org/cult/0.1#Collections	2	\N	t	76	Collections	Collections	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	290
12	http://culturalis.org/eac-cpf#Person	8	\N	t	77	Person	Person	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
13	http://culturalis.org/eac-cpf#CorporateBody	96	\N	t	77	CorporateBody	CorporateBody	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	96
14	http://www.w3.org/2000/01/rdf-schema#Class	13	\N	t	2	Class	Class	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34160
15	http://www.w3.org/2002/07/owl#FunctionalProperty	4	\N	t	7	FunctionalProperty	FunctionalProperty	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
16	http://dati.camera.it/ocd/abbinamento	5856	\N	t	69	abbinamento	abbinamento	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51341
17	http://dati.camera.it/ocd/assegnazione	138782	\N	t	69	assegnazione	assegnazione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	100410
18	http://dati.camera.it/ocd/atto	267609	\N	t	69	atto	atto	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	892364
19	http://dati.camera.it/ocd/bollettino	21878	\N	t	69	bollettino	bollettino	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113656
20	http://dati.camera.it/ocd/incarico	6134	\N	t	69	incarico	incarico	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11076
21	http://dati.camera.it/ocd/intervento	1022795	\N	t	69	intervento	intervento	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	852485
22	http://dati.camera.it/ocd/legge	33598	\N	t	69	legge	legge	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	http://dati.camera.it/ocd/luogo	4998	\N	t	69	luogo	luogo	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16800
24	http://dati.camera.it/ocd/membroGoverno	15130	\N	t	69	membroGoverno	membroGoverno	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114060
25	http://dati.camera.it/ocd/presidenteCamera	155	\N	t	69	presidenteCamera	presidenteCamera	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
26	http://dati.camera.it/ocd/presidenteConsiglioMinistri	294	\N	t	69	presidenteConsiglioMinistri	presidenteConsiglioMinistri	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	588
27	http://dati.camera.it/ocd/relatore	89314	\N	t	69	relatore	relatore	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	70949
28	http://dati.camera.it/ocd/senatore	17185	\N	t	69	senatore	senatore	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	608646
29	http://dati.camera.it/ocd/statoIter	114495	\N	t	69	statoIter	statoIter	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	64395
30	http://dati.camera.it/ocd/ufficioParlamentare	24914	\N	t	69	ufficioParlamentare	ufficioParlamentare	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	41760
31	http://dati.camera.it/ocd/voto	50062949	\N	t	69	voto	voto	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
32	http://www.w3.org/2002/07/owl#Event	49810	\N	t	7	Event	Event	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	76908
33	http://schema.org/Website	20	\N	t	9	Website	Website	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
34	http://www.w3.org/ns/dcat#Distribution	147	\N	t	15	Distribution	Distribution	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	147
35	http://purl.org/vocab/bio/0.1/date	33	\N	t	71	date	date	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
36	http://www.w3.org/2008/05/skos#Concept	250	\N	t	78	Concept	Concept	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60862
37	http://www.w3.org/2002/07/owl#AllDisjointClasses	4	\N	t	7	AllDisjointClasses	AllDisjointClasses	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
38	http://linkedgeodata.org/ontology/Village	4	\N	t	75	Village	Village	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
39	http://www.w3.org/ns/org#Organization	5	\N	t	37	Organization	Organization	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	307
40	http://linkedgeodata.org/ontology/City	1	\N	t	75	City	City	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://culturalis.org/cult/0.1#HolderOfArchives	2	\N	t	76	HolderOfArchives	HolderOfArchives	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
42	http://culturalis.org/oad#AdministrativeBiographicalHistory	236	\N	t	74	AdministrativeBiographicalHistory	AdministrativeBiographicalHistory	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	236
43	http://culturalis.org/oad#FindingAid	22	\N	t	74	FindingAid	FindingAid	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	75390
44	http://culturalis.org/oad#UoD	539	\N	t	74	UoD	UoD	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1062
45	http://culturalis.org/eac-cpf#Name	24	\N	t	77	Name	Name	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23
46	http://lod.xdams.org/ontologies/ods/file	8	\N	t	79	file	file	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
47	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	62	\N	t	1	Property	Property	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
48	http://www.w3.org/2002/07/owl#Ontology	2	\N	t	7	Ontology	Ontology	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	244
49	http://www.w3.org/2002/07/owl#Restriction	114	\N	t	7	Restriction	Restriction	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114
50	http://www.w3.org/2002/07/owl#ObjectProperty	153	\N	t	7	ObjectProperty	ObjectProperty	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	102
51	http://www.w3.org/2002/07/owl#DatatypeProperty	99	\N	t	7	DatatypeProperty	DatatypeProperty	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
52	http://www.w3.org/ns/dcat#Catalog	1	\N	t	15	Catalog	Catalog	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://dati.camera.it/ocd/allegatoDiscussione	56818	\N	t	69	allegatoDiscussione	allegatoDiscussione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	46930
54	http://dati.camera.it/ocd/assemblea	102	\N	t	69	assemblea	assemblea	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	843926
55	http://dati.camera.it/ocd/autore	17795	\N	t	69	autore	autore	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57908
56	http://dati.camera.it/ocd/componenteGruppoMisto	198	\N	t	69	componenteGruppoMisto	componenteGruppoMisto	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1582478
57	http://dati.camera.it/ocd/discussione	500185	\N	t	69	discussione	discussione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	501567
58	http://dati.camera.it/ocd/elezione	25556	\N	t	69	elezione	elezione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25556
59	http://dati.camera.it/ocd/governo	294	\N	t	69	governo	governo	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	71920
60	http://dati.camera.it/ocd/gruppoParlamentare	454	\N	t	69	gruppoParlamentare	gruppoParlamentare	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	44430090
61	http://dati.camera.it/ocd/legislatura	101	\N	t	69	legislatura	legislatura	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2748700
62	http://dati.camera.it/ocd/mandatoCamera	57270	\N	t	69	mandatoCamera	mandatoCamera	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114402
63	http://dati.camera.it/ocd/natura	6	\N	t	69	natura	natura	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32842
64	http://dati.camera.it/ocd/organo	5208	\N	t	69	organo	organo	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	972984
65	http://dati.camera.it/ocd/presidenteRepubblica	22	\N	t	69	presidenteRepubblica	presidenteRepubblica	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
66	http://dati.camera.it/ocd/rispostaAIC	78834	\N	t	69	rispostaAIC	rispostaAIC	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78834
67	http://dati.camera.it/ocd/trasmissione	4412	\N	t	69	trasmissione	trasmissione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3457
68	http://dati.camera.it/ocd/votazione	234892	\N	t	69	votazione	votazione	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	50254795
69	http://linkedevents.org/ontology/Event	142	\N	t	80	Event	Event	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
70	http://xmlns.com/foaf/0.1/Person	31907	\N	t	8	Person	Person	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	360599
71	http://dati.camera.it/ocd/Deputato	2	\N	t	69	Deputato	Deputato	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
72	http://www.w3.org/2008/05/skos#ConceptScheme	2	\N	t	78	ConceptScheme	ConceptScheme	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	218
73	http://labs.mondeca.com/vocab/voaf#Vocabulary	1	\N	t	81	Vocabulary	Vocabulary	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	172
74	http://linkedgeodata.org/ontology/Town	2	\N	t	75	Town	Town	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://dati.camera.it/ocd/sessioneLegislatura	98	\N	t	69	sessioneLegislatura	sessioneLegislatura	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21170
76	http://www.w3.org/2002/07/owl#NamedIndividual	2	\N	t	7	NamedIndividual	NamedIndividual	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	227
77	http://www.w3.org/ns/dcat#Dataset	104	\N	t	15	Dataset	Dataset	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	103
78	http://www.w3.org/2002/07/owl#Class	380	\N	t	7	Class	Class	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	109538886
79	http://www.w3.org/2002/07/owl#AnnotationProperty	7	\N	t	7	AnnotationProperty	AnnotationProperty	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	52
80	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	12	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
81	http://xmlns.com/foaf/0.1/OnlineAccount	2171	\N	t	8	OnlineAccount	OnlineAccount	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1828
82	http://dati.camera.it/ocd/DOC	59954	\N	t	69	DOC	DOC	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20693
83	http://dati.camera.it/ocd/aic	1062560	\N	t	69	aic	aic	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	89700
84	http://dati.camera.it/ocd/cronologia	13724	\N	t	69	cronologia	cronologia	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
85	http://dati.camera.it/ocd/deputato	55491	\N	t	69	deputato	deputato	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57290366
86	http://dati.camera.it/ocd/dibattito	431863	\N	t	69	dibattito	dibattito	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	240790
87	http://dati.camera.it/ocd/mandatoSenato	17218	\N	t	69	mandatoSenato	mandatoSenato	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34434
88	http://dati.camera.it/ocd/organoGoverno	5401	\N	t	69	organoGoverno	organoGoverno	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1122420
89	http://dati.camera.it/ocd/richiestaParere	17870	\N	t	69	richiestaParere	richiestaParere	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37122
90	http://dati.camera.it/ocd/seduta	235792	\N	t	69	seduta	seduta	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1165070
91	http://dati.camera.it/ocd/sistemaElettorale	27	\N	t	69	sistemaElettorale	sistemaElettorale	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25656
92	http://dati.camera.it/ocd/versioneTestoAtto	31752	\N	t	69	versioneTestoAtto	versioneTestoAtto	247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27666
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	34	1	2	147	\N	147	\N	\N	1	1	2	f	0	\N	\N
2	1	2	2	40906	\N	0	\N	\N	1	1	2	f	40906	\N	\N
3	2	2	2	9401	\N	0	\N	\N	2	1	2	f	9401	\N	\N
4	3	2	2	228	\N	0	\N	\N	3	1	2	f	228	\N	\N
5	77	2	2	97	\N	97	\N	\N	4	1	2	f	0	\N	\N
6	5	2	2	8	\N	0	\N	\N	5	1	2	f	8	\N	\N
7	1	3	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
8	64	4	2	40803	\N	40803	\N	\N	1	1	2	f	0	\N	\N
9	85	4	2	19350	\N	19350	\N	\N	2	1	2	f	0	\N	\N
10	30	4	1	41760	\N	41760	\N	\N	1	1	2	f	\N	\N	\N
11	81	5	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
12	61	6	2	56	\N	56	\N	\N	1	1	2	f	0	\N	\N
13	91	6	1	56	\N	56	\N	\N	1	1	2	f	\N	\N	\N
14	2	7	2	316	\N	0	\N	\N	1	1	2	f	316	\N	\N
15	3	7	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
16	55	8	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
17	91	9	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
18	2	10	2	139	\N	0	\N	\N	1	1	2	f	139	\N	\N
19	36	11	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
20	6	12	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
21	33	13	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
22	31	14	2	3237318	\N	3237318	\N	\N	1	1	2	f	0	\N	\N
23	56	14	1	1582478	\N	1582478	\N	\N	1	1	2	f	\N	\N	\N
24	58	15	2	3686	\N	0	\N	\N	1	1	2	f	3686	\N	\N
25	10	15	2	385	\N	0	\N	\N	2	1	2	f	385	\N	\N
26	1	16	2	10442	\N	10442	\N	\N	1	1	2	f	0	\N	\N
27	2	16	2	1402	\N	1402	\N	\N	2	1	2	f	0	\N	\N
28	91	16	2	60	\N	60	\N	\N	3	1	2	f	0	\N	\N
29	5	16	2	8	\N	8	\N	\N	4	1	2	f	0	\N	\N
30	10	16	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
31	84	16	2	4	\N	4	\N	\N	6	1	2	f	0	\N	\N
32	3	16	2	2	\N	2	\N	\N	7	1	2	f	0	\N	\N
33	6	16	1	11911	\N	11911	\N	\N	1	1	2	f	\N	\N	\N
34	18	17	2	45182	\N	45182	\N	\N	1	1	2	f	0	\N	\N
35	89	17	1	37122	\N	37122	\N	\N	1	1	2	f	\N	\N	\N
36	32	17	1	30651	\N	30651	\N	\N	0	1	2	f	\N	\N	\N
37	21	18	2	44721	\N	44721	\N	\N	1	1	2	f	0	\N	\N
38	70	18	2	15675	\N	15675	\N	\N	2	1	2	f	0	\N	\N
39	59	18	2	15094	\N	15094	\N	\N	3	1	2	f	0	\N	\N
40	88	18	2	15092	\N	15092	\N	\N	4	1	2	f	0	\N	\N
41	85	18	2	2848	\N	2848	\N	\N	5	1	2	f	0	\N	\N
42	24	18	1	110580	\N	110580	\N	\N	1	1	2	f	\N	\N	\N
43	36	19	2	250	\N	0	\N	\N	1	1	2	f	250	\N	\N
44	61	20	2	155	\N	99	\N	\N	1	1	2	f	56	\N	\N
45	54	20	1	100	\N	100	\N	\N	1	1	2	f	\N	\N	\N
46	78	21	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
47	14	21	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
48	83	22	2	1052688	\N	1052688	\N	\N	1	1	2	f	0	\N	\N
49	86	22	2	434711	\N	434711	\N	\N	2	1	2	f	0	\N	\N
50	18	22	2	267608	\N	267608	\N	\N	3	1	2	f	0	\N	\N
51	90	22	2	235764	\N	235764	\N	\N	4	1	2	f	0	\N	\N
52	68	22	2	235046	\N	235046	\N	\N	5	1	2	f	0	\N	\N
53	62	22	2	57270	\N	57270	\N	\N	6	1	2	f	0	\N	\N
54	82	22	2	56615	\N	56615	\N	\N	7	1	2	f	0	\N	\N
55	85	22	2	55482	\N	55482	\N	\N	8	1	2	f	0	\N	\N
56	71	22	2	2	\N	2	\N	\N	8	1	2	f	0	\N	\N
57	53	22	2	47047	\N	47047	\N	\N	9	1	2	f	0	\N	\N
58	22	22	2	33598	\N	33598	\N	\N	10	1	2	f	0	\N	\N
59	58	22	2	25556	\N	25556	\N	\N	11	1	2	f	0	\N	\N
60	30	22	2	24914	\N	24914	\N	\N	12	1	2	f	0	\N	\N
61	19	22	2	21878	\N	21878	\N	\N	13	1	2	f	0	\N	\N
62	17	22	2	18802	\N	18802	\N	\N	14	1	2	f	0	\N	\N
63	24	22	2	17926	\N	17926	\N	\N	15	1	2	f	0	\N	\N
64	84	22	2	13474	\N	13474	\N	\N	16	1	2	f	0	\N	\N
65	87	22	2	12406	\N	12406	\N	\N	17	1	2	f	0	\N	\N
66	28	22	2	12372	\N	12372	\N	\N	18	1	2	f	0	\N	\N
67	10	22	2	6382	\N	6382	\N	\N	19	1	2	f	0	\N	\N
68	20	22	2	6134	\N	6134	\N	\N	20	1	2	f	0	\N	\N
69	64	22	2	5412	\N	5412	\N	\N	21	1	2	f	0	\N	\N
70	60	22	2	430	\N	430	\N	\N	22	1	2	f	0	\N	\N
71	2	22	2	357	\N	357	\N	\N	23	1	2	f	0	\N	\N
72	59	22	2	342	\N	342	\N	\N	24	1	2	f	0	\N	\N
73	25	22	2	308	\N	308	\N	\N	25	1	2	f	0	\N	\N
74	56	22	2	198	\N	198	\N	\N	26	1	2	f	0	\N	\N
75	54	22	2	102	\N	102	\N	\N	27	1	2	f	0	\N	\N
76	91	22	2	98	\N	98	\N	\N	28	1	2	f	0	\N	\N
77	75	22	2	98	\N	98	\N	\N	29	1	2	f	0	\N	\N
78	61	22	1	2748696	\N	2748696	\N	\N	1	1	2	f	\N	\N	\N
79	52	23	2	105	\N	105	\N	\N	1	1	2	f	0	\N	\N
80	77	23	1	103	\N	103	\N	\N	1	1	2	f	\N	\N	\N
81	83	24	2	1052688	\N	0	\N	\N	1	1	2	f	1052688	\N	\N
82	57	24	2	285158	\N	0	\N	\N	2	1	2	f	285158	\N	\N
83	18	24	2	237856	\N	0	\N	\N	3	1	2	f	237856	\N	\N
84	90	24	2	235766	\N	0	\N	\N	4	1	2	f	235766	\N	\N
85	68	24	2	235046	\N	0	\N	\N	5	1	2	f	235046	\N	\N
86	29	24	2	113945	\N	0	\N	\N	6	1	2	f	113945	\N	\N
87	66	24	2	78785	\N	0	\N	\N	7	1	2	f	78785	\N	\N
88	4	24	2	70896	\N	0	\N	\N	8	1	2	f	70896	\N	\N
89	62	24	2	57270	\N	0	\N	\N	9	1	2	f	57270	\N	\N
90	82	24	2	43143	\N	0	\N	\N	10	1	2	f	43143	\N	\N
91	17	24	2	36434	\N	0	\N	\N	11	1	2	f	36434	\N	\N
92	22	24	2	33596	\N	0	\N	\N	12	1	2	f	33596	\N	\N
93	92	24	2	30220	\N	0	\N	\N	13	1	2	f	30220	\N	\N
94	86	24	2	26447	\N	0	\N	\N	14	1	2	f	26447	\N	\N
95	58	24	2	25546	\N	0	\N	\N	15	1	2	f	25546	\N	\N
96	30	24	2	24914	\N	0	\N	\N	16	1	2	f	24914	\N	\N
97	19	24	2	21878	\N	0	\N	\N	17	1	2	f	21878	\N	\N
98	87	24	2	17218	\N	0	\N	\N	18	1	2	f	17218	\N	\N
99	24	24	2	15132	\N	0	\N	\N	19	1	2	f	15132	\N	\N
100	84	24	2	13510	\N	0	\N	\N	20	1	2	f	13510	\N	\N
101	20	24	2	6134	\N	0	\N	\N	21	1	2	f	6134	\N	\N
102	64	24	2	5412	\N	0	\N	\N	22	1	2	f	5412	\N	\N
103	67	24	2	4412	\N	0	\N	\N	23	1	2	f	4412	\N	\N
104	44	24	2	539	\N	0	\N	\N	24	1	2	f	539	\N	\N
105	60	24	2	430	\N	0	\N	\N	25	1	2	f	430	\N	\N
106	25	24	2	308	\N	0	\N	\N	26	1	2	f	308	\N	\N
107	26	24	2	294	\N	0	\N	\N	27	1	2	f	294	\N	\N
108	59	24	2	294	\N	0	\N	\N	28	1	2	f	294	\N	\N
109	56	24	2	198	\N	0	\N	\N	29	1	2	f	198	\N	\N
110	7	24	2	111	\N	0	\N	\N	30	1	2	f	111	\N	\N
111	69	24	2	110	\N	0	\N	\N	31	1	2	f	110	\N	\N
112	61	24	2	101	\N	0	\N	\N	32	1	2	f	101	\N	\N
113	75	24	2	98	\N	0	\N	\N	33	1	2	f	98	\N	\N
114	2	24	2	28	\N	0	\N	\N	34	1	2	f	28	\N	\N
115	91	24	2	26	\N	0	\N	\N	35	1	2	f	26	\N	\N
116	65	24	2	22	\N	0	\N	\N	36	1	2	f	22	\N	\N
117	70	24	2	2	\N	0	\N	\N	37	1	2	f	2	\N	\N
118	32	24	2	29631	\N	0	\N	\N	0	1	2	f	29631	\N	\N
119	28	24	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
120	77	25	2	102	\N	0	\N	\N	1	1	2	f	102	\N	\N
121	4	26	2	67333	\N	0	\N	\N	1	1	2	f	67333	\N	\N
122	44	26	2	87	\N	0	\N	\N	2	1	2	f	87	\N	\N
123	36	27	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
124	57	28	2	49650	\N	49650	\N	\N	1	1	2	f	0	\N	\N
125	66	28	2	16007	\N	16007	\N	\N	2	1	2	f	0	\N	\N
126	24	28	2	15132	\N	15132	\N	\N	3	1	2	f	0	\N	\N
127	84	28	2	2118	\N	2118	\N	\N	4	1	2	f	0	\N	\N
128	26	28	2	294	\N	294	\N	\N	5	1	2	f	0	\N	\N
129	30	28	2	60	\N	60	\N	\N	6	1	2	f	0	\N	\N
130	65	28	2	22	\N	22	\N	\N	7	1	2	f	0	\N	\N
131	25	28	2	4	\N	4	\N	\N	8	1	2	f	0	\N	\N
132	70	28	1	195556	\N	195556	\N	\N	1	1	2	f	\N	\N	\N
133	31	29	2	16600059	\N	0	\N	\N	1	1	2	f	16600059	\N	\N
134	83	29	2	1052352	\N	0	\N	\N	2	1	2	f	1052352	\N	\N
135	68	29	2	235046	\N	0	\N	\N	3	1	2	f	235046	\N	\N
136	85	29	2	57402	\N	0	\N	\N	4	1	2	f	57402	\N	\N
137	18	29	2	54600	\N	0	\N	\N	5	1	2	f	54600	\N	\N
138	66	29	2	41030	\N	0	\N	\N	6	1	2	f	41030	\N	\N
139	70	29	2	26503	\N	0	\N	\N	7	1	2	f	26503	\N	\N
140	84	29	2	13616	\N	0	\N	\N	8	1	2	f	13616	\N	\N
141	10	29	2	6376	\N	0	\N	\N	9	1	2	f	6376	\N	\N
142	24	29	2	1156	\N	0	\N	\N	10	1	2	f	1156	\N	\N
143	64	29	2	1082	\N	0	\N	\N	11	1	2	f	1082	\N	\N
144	42	29	2	236	\N	0	\N	\N	12	1	2	f	236	\N	\N
145	34	29	2	148	\N	0	\N	\N	13	1	2	f	148	\N	\N
146	4	29	2	108	\N	0	\N	\N	14	1	2	f	108	\N	\N
147	77	29	2	104	\N	0	\N	\N	15	1	2	f	104	\N	\N
148	91	29	2	26	\N	0	\N	\N	16	1	2	f	26	\N	\N
149	55	29	2	6	\N	0	\N	\N	17	1	2	f	6	\N	\N
150	51	29	2	4	\N	0	\N	\N	18	1	2	f	4	\N	\N
151	48	29	2	2	\N	0	\N	\N	19	1	2	f	2	\N	\N
152	52	29	2	1	\N	0	\N	\N	20	1	2	f	1	\N	\N
153	44	29	2	1	\N	0	\N	\N	21	1	2	f	1	\N	\N
154	73	29	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
155	76	29	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
156	28	29	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
157	1	30	2	23910	\N	0	\N	\N	1	1	2	f	23910	\N	\N
158	4	31	2	3401	\N	3401	\N	\N	1	1	2	f	0	\N	\N
159	13	31	2	96	\N	96	\N	\N	2	1	2	f	0	\N	\N
160	12	31	2	8	\N	8	\N	\N	3	1	2	f	0	\N	\N
161	64	31	1	353	\N	353	\N	\N	1	1	2	f	\N	\N	\N
162	70	31	1	24	\N	24	\N	\N	2	1	2	f	\N	\N	\N
163	61	31	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
164	83	32	2	2799916	\N	2799916	\N	\N	1	1	2	f	0	\N	\N
165	18	32	2	1283319	\N	1283319	\N	\N	2	1	2	f	0	\N	\N
166	85	32	1	3428814	\N	3428814	\N	\N	1	1	2	f	\N	\N	\N
167	28	32	1	475808	\N	475808	\N	\N	2	1	2	f	\N	\N	\N
168	70	32	1	39628	\N	39628	\N	\N	3	1	2	f	\N	\N	\N
169	70	33	2	2222	\N	2190	\N	\N	1	1	2	f	32	\N	\N
170	9	33	2	30	\N	30	\N	\N	2	1	2	f	0	\N	\N
171	81	33	1	1828	\N	1828	\N	\N	1	1	2	f	\N	\N	\N
172	70	34	2	31540	\N	0	\N	\N	1	1	2	f	31540	\N	\N
173	85	34	2	25530	\N	0	\N	\N	2	1	2	f	25530	\N	\N
174	1	35	2	42106	\N	42106	\N	\N	1	1	2	f	0	\N	\N
175	2	35	2	8056	\N	8056	\N	\N	2	1	2	f	0	\N	\N
176	10	35	2	6343	\N	6343	\N	\N	3	1	2	f	0	\N	\N
177	3	35	2	54	\N	54	\N	\N	4	1	2	f	0	\N	\N
178	5	35	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
179	52	35	2	2	\N	2	\N	\N	6	1	2	f	0	\N	\N
180	55	35	1	50222	\N	50222	\N	\N	1	1	2	f	\N	\N	\N
181	9	35	1	6314	\N	6314	\N	\N	2	1	2	f	\N	\N	\N
182	39	35	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
183	73	37	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
184	48	37	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
185	76	37	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
186	68	38	2	235046	\N	235046	\N	\N	1	1	2	f	0	\N	\N
187	85	38	1	245706	\N	245706	\N	\N	1	1	2	f	\N	\N	\N
188	68	39	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
189	56	40	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
190	60	40	2	18	\N	18	\N	\N	2	1	2	f	0	\N	\N
191	23	41	2	240	\N	0	\N	\N	1	1	2	f	240	\N	\N
192	10	42	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
193	3	43	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
194	2	43	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
195	5	43	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
196	39	43	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
197	18	44	2	24580	\N	24580	\N	\N	1	1	2	f	0	\N	\N
198	18	44	1	23015	\N	23015	\N	\N	1	1	2	f	\N	\N	\N
199	81	45	2	110	\N	0	\N	\N	1	1	2	f	110	\N	\N
200	1	46	2	7942	\N	0	\N	\N	1	1	2	f	7942	\N	\N
201	2	46	2	4581	\N	0	\N	\N	2	1	2	f	4581	\N	\N
202	3	46	2	42	\N	0	\N	\N	3	1	2	f	42	\N	\N
203	5	46	2	6	\N	0	\N	\N	4	1	2	f	6	\N	\N
204	62	47	2	2978	\N	2978	\N	\N	1	1	2	f	0	\N	\N
205	10	48	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
206	1	49	2	40932	\N	0	\N	\N	1	1	2	f	40932	\N	\N
207	2	49	2	12078	\N	0	\N	\N	2	1	2	f	12078	\N	\N
208	3	49	2	2350	\N	0	\N	\N	3	1	2	f	2350	\N	\N
209	5	49	2	8	\N	0	\N	\N	4	1	2	f	8	\N	\N
210	1	50	2	712	\N	0	\N	\N	1	1	2	f	712	\N	\N
211	1	51	2	10204	\N	0	\N	\N	1	1	2	f	10204	\N	\N
212	2	51	2	6389	\N	0	\N	\N	2	1	2	f	6389	\N	\N
213	3	51	2	292	\N	0	\N	\N	3	1	2	f	292	\N	\N
214	5	51	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
215	90	52	2	209687	\N	209687	\N	\N	1	1	2	f	0	\N	\N
216	17	52	2	160394	\N	160394	\N	\N	2	1	2	f	0	\N	\N
217	32	52	2	43636	\N	43636	\N	\N	3	1	2	f	0	\N	\N
218	86	52	2	33318	\N	33318	\N	\N	4	1	2	f	0	\N	\N
219	30	52	2	24914	\N	24914	\N	\N	5	1	2	f	0	\N	\N
220	89	52	2	15560	\N	15560	\N	\N	0	1	2	f	0	\N	\N
221	64	52	1	954019	\N	954019	\N	\N	1	1	2	f	\N	\N	\N
222	83	53	2	1030160	\N	1030160	\N	\N	1	1	2	f	0	\N	\N
223	18	53	2	299665	\N	299665	\N	\N	2	1	2	f	0	\N	\N
224	82	53	2	1710	\N	1710	\N	\N	3	1	2	f	0	\N	\N
225	85	53	1	1029024	\N	1029024	\N	\N	1	1	2	f	\N	\N	\N
226	70	53	1	124538	\N	124538	\N	\N	2	1	2	f	\N	\N	\N
227	28	53	1	99990	\N	99990	\N	\N	3	1	2	f	\N	\N	\N
228	83	54	2	1095356	\N	1095356	\N	\N	1	1	2	f	0	\N	\N
229	88	54	1	1058330	\N	1058330	\N	\N	1	1	2	f	\N	\N	\N
230	44	55	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
231	42	55	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
232	10	56	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
233	2	57	2	339	\N	339	\N	\N	1	1	2	f	0	\N	\N
234	83	58	2	273318	\N	0	\N	\N	1	1	2	f	273318	\N	\N
235	86	58	2	250388	\N	0	\N	\N	2	1	2	f	250388	\N	\N
236	62	58	2	24742	\N	0	\N	\N	3	1	2	f	24742	\N	\N
237	30	58	2	17224	\N	0	\N	\N	4	1	2	f	17224	\N	\N
238	87	58	2	10712	\N	0	\N	\N	5	1	2	f	10712	\N	\N
239	24	58	2	10530	\N	0	\N	\N	6	1	2	f	10530	\N	\N
240	20	58	2	5294	\N	0	\N	\N	7	1	2	f	5294	\N	\N
241	64	58	2	4395	\N	0	\N	\N	8	1	2	f	4395	\N	\N
242	60	58	2	370	\N	0	\N	\N	9	1	2	f	370	\N	\N
243	2	58	2	184	\N	0	\N	\N	10	1	2	f	184	\N	\N
244	56	58	2	160	\N	0	\N	\N	11	1	2	f	160	\N	\N
245	59	58	2	136	\N	0	\N	\N	12	1	2	f	136	\N	\N
246	26	58	2	132	\N	0	\N	\N	13	1	2	f	132	\N	\N
247	75	58	2	98	\N	0	\N	\N	14	1	2	f	98	\N	\N
248	61	58	2	38	\N	0	\N	\N	15	1	2	f	38	\N	\N
249	91	58	2	18	\N	0	\N	\N	16	1	2	f	18	\N	\N
250	77	59	2	104	\N	104	\N	\N	1	1	2	f	0	\N	\N
251	36	60	2	201	\N	0	\N	\N	1	1	2	f	201	\N	\N
252	10	61	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
253	77	62	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
254	73	62	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
255	52	62	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
256	48	62	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
257	76	62	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
258	6	63	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
259	2	64	2	2563	\N	0	\N	\N	1	1	2	f	2563	\N	\N
260	1	64	2	642	\N	0	\N	\N	2	1	2	f	642	\N	\N
261	3	64	2	196	\N	0	\N	\N	3	1	2	f	196	\N	\N
262	5	64	2	4	\N	0	\N	\N	4	1	2	f	4	\N	\N
263	51	65	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
264	47	65	2	13	\N	13	\N	\N	2	1	2	f	0	\N	\N
265	80	65	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
266	50	65	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
267	47	65	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
268	79	65	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
269	50	65	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
270	51	65	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
271	80	65	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
272	70	66	2	19901	\N	19901	\N	\N	1	1	2	f	0	\N	\N
273	23	66	2	12694	\N	12694	\N	\N	2	1	2	f	0	\N	\N
274	88	66	2	2682	\N	2682	\N	\N	3	1	2	f	0	\N	\N
275	59	66	2	176	\N	176	\N	\N	4	1	2	f	0	\N	\N
276	55	66	2	114	\N	114	\N	\N	5	1	2	f	0	\N	\N
277	61	66	2	34	\N	34	\N	\N	6	1	2	f	0	\N	\N
278	65	66	2	22	\N	22	\N	\N	7	1	2	f	0	\N	\N
279	38	66	2	8	\N	8	\N	\N	8	1	2	f	0	\N	\N
280	74	66	2	4	\N	4	\N	\N	9	1	2	f	0	\N	\N
281	78	66	2	4	\N	4	\N	\N	10	1	2	f	0	\N	\N
282	8	66	2	3	\N	3	\N	\N	11	1	2	f	0	\N	\N
283	40	66	2	2	\N	2	\N	\N	12	1	2	f	0	\N	\N
284	39	66	2	2	\N	2	\N	\N	13	1	2	f	0	\N	\N
285	76	66	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
286	78	66	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
287	70	66	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
288	14	66	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
289	23	68	2	398	\N	0	\N	\N	1	1	2	f	398	\N	\N
290	3	69	2	156	\N	0	\N	\N	1	1	2	f	156	\N	\N
291	2	70	2	12040	\N	0	\N	\N	1	1	2	f	12040	\N	\N
292	3	70	2	170	\N	0	\N	\N	2	1	2	f	170	\N	\N
293	2	71	2	12036	\N	0	\N	\N	1	1	2	f	12036	\N	\N
294	3	71	2	176	\N	0	\N	\N	2	1	2	f	176	\N	\N
295	2	72	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
296	36	73	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
297	49	74	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
298	78	74	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
299	18	75	2	119545	\N	119545	\N	\N	1	1	2	f	0	\N	\N
300	18	75	1	119254	\N	119254	\N	\N	1	1	2	f	\N	\N	\N
301	78	76	1	2282	\N	2282	\N	\N	1	1	2	f	\N	\N	\N
302	76	76	1	41	\N	41	\N	\N	0	1	2	f	\N	\N	\N
303	50	76	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
304	62	77	2	32482	\N	0	\N	\N	1	1	2	f	32482	\N	\N
305	24	77	2	10530	\N	0	\N	\N	2	1	2	f	10530	\N	\N
306	87	77	2	4642	\N	0	\N	\N	3	1	2	f	4642	\N	\N
307	3	78	2	2108	\N	0	\N	\N	1	1	2	f	2108	\N	\N
308	57	79	2	56108	\N	56108	\N	\N	1	1	2	f	0	\N	\N
309	18	79	2	14839	\N	14839	\N	\N	2	1	2	f	0	\N	\N
310	27	79	1	70949	\N	70949	\N	\N	1	1	2	f	\N	\N	\N
311	37	80	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
312	68	81	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
313	83	82	2	82310	\N	82310	\N	\N	1	1	2	f	0	\N	\N
314	18	82	2	18847	\N	18847	\N	\N	2	1	2	f	0	\N	\N
315	17	82	1	100410	\N	100410	\N	\N	1	1	2	f	\N	\N	\N
316	32	82	1	10178	\N	10178	\N	\N	0	1	2	f	\N	\N	\N
317	4	84	2	74831	\N	74831	\N	\N	1	1	2	f	0	\N	\N
318	6	85	2	11660	\N	11660	\N	\N	1	1	2	f	0	\N	\N
319	4	86	2	72373	\N	72373	\N	\N	1	1	2	f	0	\N	\N
320	4	86	1	70340	\N	70340	\N	\N	1	1	2	f	\N	\N	\N
321	30	87	2	24914	\N	0	\N	\N	1	1	2	f	24914	\N	\N
322	18	88	2	51790	\N	0	\N	\N	1	1	2	f	51790	\N	\N
323	1	88	2	40956	\N	40956	\N	\N	2	1	2	f	0	\N	\N
324	2	88	2	9102	\N	9102	\N	\N	3	1	2	f	0	\N	\N
325	67	88	2	4412	\N	0	\N	\N	4	1	2	f	4412	\N	\N
326	82	88	2	2714	\N	0	\N	\N	5	1	2	f	2714	\N	\N
327	3	88	2	138	\N	138	\N	\N	6	1	2	f	0	\N	\N
328	5	88	2	8	\N	8	\N	\N	7	1	2	f	0	\N	\N
329	6	88	2	2	\N	2	\N	\N	8	1	2	f	0	\N	\N
330	55	88	2	2	\N	2	\N	\N	9	1	2	f	0	\N	\N
331	58	89	2	570	\N	0	\N	\N	1	1	2	f	570	\N	\N
332	36	90	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
333	10	90	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
334	10	90	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
335	16	91	2	5866	\N	5866	\N	\N	1	1	2	f	0	\N	\N
336	32	91	2	4436	\N	4436	\N	\N	0	1	2	f	0	\N	\N
337	18	91	1	6846	\N	6846	\N	\N	1	1	2	f	\N	\N	\N
338	2	92	2	9238	\N	0	\N	\N	1	1	2	f	9238	\N	\N
339	31	93	2	50125247	\N	0	\N	\N	1	1	2	f	50125247	\N	\N
340	83	93	2	1052660	\N	0	\N	\N	2	1	2	f	1052660	\N	\N
341	21	93	2	1022535	\N	0	\N	\N	3	1	2	f	1022535	\N	\N
342	86	93	2	442153	\N	0	\N	\N	4	1	2	f	442153	\N	\N
343	57	93	2	285171	\N	0	\N	\N	5	1	2	f	285171	\N	\N
344	18	93	2	267608	\N	0	\N	\N	6	1	2	f	267608	\N	\N
345	90	93	2	235766	\N	0	\N	\N	7	1	2	f	235766	\N	\N
346	68	93	2	235046	\N	0	\N	\N	8	1	2	f	235046	\N	\N
347	17	93	2	138808	\N	0	\N	\N	9	1	2	f	138808	\N	\N
348	29	93	2	113946	\N	0	\N	\N	10	1	2	f	113946	\N	\N
349	27	93	2	89026	\N	0	\N	\N	11	1	2	f	89026	\N	\N
350	4	93	2	74825	\N	0	\N	\N	12	1	2	f	74825	\N	\N
351	62	93	2	57270	\N	0	\N	\N	13	1	2	f	57270	\N	\N
352	53	93	2	56818	\N	0	\N	\N	14	1	2	f	56818	\N	\N
353	82	93	2	56646	\N	0	\N	\N	15	1	2	f	56646	\N	\N
354	85	93	2	55482	\N	0	\N	\N	16	1	2	f	55482	\N	\N
355	71	93	2	2	\N	0	\N	\N	16	1	2	f	2	\N	\N
356	32	93	2	46319	\N	0	\N	\N	17	1	2	f	46319	\N	\N
357	22	93	2	33598	\N	0	\N	\N	18	1	2	f	33598	\N	\N
358	70	93	2	31538	\N	0	\N	\N	19	1	2	f	31538	\N	\N
359	92	93	2	28619	\N	0	\N	\N	20	1	2	f	28619	\N	\N
360	58	93	2	25546	\N	0	\N	\N	21	1	2	f	25546	\N	\N
361	30	93	2	24914	\N	0	\N	\N	22	1	2	f	24914	\N	\N
362	19	93	2	21878	\N	0	\N	\N	23	1	2	f	21878	\N	\N
363	55	93	2	17780	\N	0	\N	\N	24	1	2	f	17780	\N	\N
364	87	93	2	17218	\N	0	\N	\N	25	1	2	f	17218	\N	\N
365	28	93	2	17185	\N	0	\N	\N	26	1	2	f	17185	\N	\N
366	24	93	2	15132	\N	0	\N	\N	27	1	2	f	15132	\N	\N
367	20	93	2	6134	\N	0	\N	\N	28	1	2	f	6134	\N	\N
368	64	93	2	5412	\N	0	\N	\N	29	1	2	f	5412	\N	\N
369	88	93	2	5232	\N	0	\N	\N	30	1	2	f	5232	\N	\N
370	23	93	2	4990	\N	0	\N	\N	31	1	2	f	4990	\N	\N
371	67	93	2	4412	\N	0	\N	\N	32	1	2	f	4412	\N	\N
372	81	93	2	2171	\N	0	\N	\N	33	1	2	f	2171	\N	\N
373	44	93	2	539	\N	0	\N	\N	34	1	2	f	539	\N	\N
374	60	93	2	430	\N	0	\N	\N	35	1	2	f	430	\N	\N
375	25	93	2	304	\N	0	\N	\N	36	1	2	f	304	\N	\N
376	78	93	2	298	\N	0	\N	\N	37	1	2	f	298	\N	\N
377	26	93	2	294	\N	0	\N	\N	38	1	2	f	294	\N	\N
378	59	93	2	294	\N	0	\N	\N	39	1	2	f	294	\N	\N
379	50	93	2	269	\N	0	\N	\N	40	1	2	f	269	\N	\N
380	36	93	2	250	\N	0	\N	\N	41	1	2	f	250	\N	\N
381	42	93	2	232	\N	0	\N	\N	42	1	2	f	232	\N	\N
382	56	93	2	198	\N	0	\N	\N	43	1	2	f	198	\N	\N
383	51	93	2	165	\N	0	\N	\N	44	1	2	f	165	\N	\N
384	7	93	2	143	\N	0	\N	\N	45	1	2	f	143	\N	\N
385	69	93	2	142	\N	0	\N	\N	46	1	2	f	142	\N	\N
386	34	93	2	103	\N	0	\N	\N	47	1	2	f	103	\N	\N
387	54	93	2	102	\N	0	\N	\N	48	1	2	f	102	\N	\N
388	84	93	2	100	\N	0	\N	\N	49	1	2	f	100	\N	\N
389	61	93	2	99	\N	0	\N	\N	50	1	2	f	99	\N	\N
390	75	93	2	98	\N	0	\N	\N	51	1	2	f	98	\N	\N
391	77	93	2	97	\N	0	\N	\N	52	1	2	f	97	\N	\N
392	13	93	2	96	\N	0	\N	\N	53	1	2	f	96	\N	\N
393	47	93	2	62	\N	0	\N	\N	54	1	2	f	62	\N	\N
394	9	93	2	30	\N	0	\N	\N	55	1	2	f	30	\N	\N
395	45	93	2	24	\N	0	\N	\N	56	1	2	f	24	\N	\N
396	65	93	2	22	\N	0	\N	\N	57	1	2	f	22	\N	\N
397	43	93	2	22	\N	0	\N	\N	58	1	2	f	22	\N	\N
398	33	93	2	20	\N	0	\N	\N	59	1	2	f	20	\N	\N
399	12	93	2	8	\N	0	\N	\N	60	1	2	f	8	\N	\N
400	63	93	2	6	\N	0	\N	\N	61	1	2	f	6	\N	\N
401	41	93	2	4	\N	0	\N	\N	62	1	2	f	4	\N	\N
402	11	93	2	4	\N	0	\N	\N	63	1	2	f	4	\N	\N
403	72	93	2	2	\N	0	\N	\N	64	1	2	f	2	\N	\N
404	1	93	2	2	\N	0	\N	\N	65	1	2	f	2	\N	\N
405	52	93	2	1	\N	0	\N	\N	66	1	2	f	1	\N	\N
406	39	93	2	1	\N	0	\N	\N	67	1	2	f	1	\N	\N
407	89	93	2	15577	\N	0	\N	\N	0	1	2	f	15577	\N	\N
408	16	93	2	5856	\N	0	\N	\N	0	1	2	f	5856	\N	\N
409	14	93	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
410	80	93	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
411	15	93	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
412	76	93	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
413	79	93	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
414	66	94	2	78428	\N	0	\N	\N	1	1	2	f	78428	\N	\N
415	20	94	2	6134	\N	0	\N	\N	2	1	2	f	6134	\N	\N
416	68	95	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
417	31	96	2	50125247	\N	0	\N	\N	1	1	2	f	50125247	\N	\N
418	83	96	2	1052660	\N	0	\N	\N	2	1	2	f	1052660	\N	\N
419	21	96	2	1022535	\N	0	\N	\N	3	1	2	f	1022535	\N	\N
420	86	96	2	442140	\N	0	\N	\N	4	1	2	f	442140	\N	\N
421	57	96	2	285171	\N	0	\N	\N	5	1	2	f	285171	\N	\N
422	18	96	2	267608	\N	0	\N	\N	6	1	2	f	267608	\N	\N
423	90	96	2	235311	\N	0	\N	\N	7	1	2	f	235311	\N	\N
424	68	96	2	235046	\N	0	\N	\N	8	1	2	f	235046	\N	\N
425	29	96	2	113945	\N	0	\N	\N	9	1	2	f	113945	\N	\N
426	27	96	2	89026	\N	0	\N	\N	10	1	2	f	89026	\N	\N
427	4	96	2	74825	\N	0	\N	\N	11	1	2	f	74825	\N	\N
428	62	96	2	57270	\N	0	\N	\N	12	1	2	f	57270	\N	\N
429	53	96	2	56818	\N	0	\N	\N	13	1	2	f	56818	\N	\N
430	82	96	2	56635	\N	0	\N	\N	14	1	2	f	56635	\N	\N
431	85	96	2	55482	\N	0	\N	\N	15	1	2	f	55482	\N	\N
432	71	96	2	2	\N	0	\N	\N	15	1	2	f	2	\N	\N
433	32	96	2	46319	\N	0	\N	\N	16	1	2	f	46319	\N	\N
434	17	96	2	42596	\N	0	\N	\N	17	1	2	f	42596	\N	\N
435	1	96	2	40934	\N	0	\N	\N	18	1	2	f	40934	\N	\N
436	22	96	2	33598	\N	0	\N	\N	19	1	2	f	33598	\N	\N
437	70	96	2	31882	\N	0	\N	\N	20	1	2	f	31882	\N	\N
438	92	96	2	28619	\N	0	\N	\N	21	1	2	f	28619	\N	\N
439	58	96	2	25546	\N	0	\N	\N	22	1	2	f	25546	\N	\N
440	30	96	2	24914	\N	0	\N	\N	23	1	2	f	24914	\N	\N
441	19	96	2	21878	\N	0	\N	\N	24	1	2	f	21878	\N	\N
442	87	96	2	17218	\N	0	\N	\N	25	1	2	f	17218	\N	\N
443	28	96	2	17183	\N	0	\N	\N	26	1	2	f	17183	\N	\N
444	24	96	2	15132	\N	0	\N	\N	27	1	2	f	15132	\N	\N
445	84	96	2	13492	\N	0	\N	\N	28	1	2	f	13492	\N	\N
446	2	96	2	12078	\N	0	\N	\N	29	1	2	f	12078	\N	\N
447	6	96	2	11660	\N	0	\N	\N	30	1	2	f	11660	\N	\N
448	10	96	2	6382	\N	0	\N	\N	31	1	2	f	6382	\N	\N
449	20	96	2	6134	\N	0	\N	\N	32	1	2	f	6134	\N	\N
450	64	96	2	5412	\N	0	\N	\N	33	1	2	f	5412	\N	\N
451	88	96	2	5232	\N	0	\N	\N	34	1	2	f	5232	\N	\N
452	23	96	2	4990	\N	0	\N	\N	35	1	2	f	4990	\N	\N
453	67	96	2	4412	\N	0	\N	\N	36	1	2	f	4412	\N	\N
454	3	96	2	2350	\N	0	\N	\N	37	1	2	f	2350	\N	\N
455	81	96	2	2127	\N	0	\N	\N	38	1	2	f	2127	\N	\N
456	44	96	2	539	\N	0	\N	\N	39	1	2	f	539	\N	\N
457	60	96	2	430	\N	0	\N	\N	40	1	2	f	430	\N	\N
458	25	96	2	308	\N	0	\N	\N	41	1	2	f	308	\N	\N
459	26	96	2	294	\N	0	\N	\N	42	1	2	f	294	\N	\N
460	59	96	2	294	\N	0	\N	\N	43	1	2	f	294	\N	\N
461	56	96	2	198	\N	0	\N	\N	44	1	2	f	198	\N	\N
462	34	96	2	148	\N	0	\N	\N	45	1	2	f	148	\N	\N
463	7	96	2	143	\N	0	\N	\N	46	1	2	f	143	\N	\N
464	77	96	2	104	\N	0	\N	\N	47	1	2	f	104	\N	\N
465	54	96	2	102	\N	0	\N	\N	48	1	2	f	102	\N	\N
466	61	96	2	101	\N	0	\N	\N	49	1	2	f	101	\N	\N
467	75	96	2	98	\N	0	\N	\N	50	1	2	f	98	\N	\N
468	91	96	2	26	\N	0	\N	\N	51	1	2	f	26	\N	\N
469	65	96	2	22	\N	0	\N	\N	52	1	2	f	22	\N	\N
470	43	96	2	22	\N	0	\N	\N	53	1	2	f	22	\N	\N
471	5	96	2	8	\N	0	\N	\N	54	1	2	f	8	\N	\N
472	63	96	2	6	\N	0	\N	\N	55	1	2	f	6	\N	\N
473	41	96	2	4	\N	0	\N	\N	56	1	2	f	4	\N	\N
474	11	96	2	4	\N	0	\N	\N	57	1	2	f	4	\N	\N
475	39	96	2	4	\N	0	\N	\N	58	1	2	f	4	\N	\N
476	48	96	2	2	\N	0	\N	\N	59	1	2	f	2	\N	\N
477	52	96	2	1	\N	0	\N	\N	60	1	2	f	1	\N	\N
478	89	96	2	15577	\N	0	\N	\N	0	1	2	f	15577	\N	\N
479	16	96	2	5856	\N	0	\N	\N	0	1	2	f	5856	\N	\N
480	73	96	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
481	76	96	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
482	19	97	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
483	1	98	2	7912	\N	0	\N	\N	1	1	2	f	7912	\N	\N
484	2	98	2	1736	\N	0	\N	\N	2	1	2	f	1736	\N	\N
485	3	98	2	210	\N	0	\N	\N	3	1	2	f	210	\N	\N
486	5	98	2	8	\N	0	\N	\N	4	1	2	f	8	\N	\N
487	6	98	2	8	\N	0	\N	\N	5	1	2	f	8	\N	\N
488	83	99	2	1052688	\N	743594	\N	\N	1	1	2	f	309094	\N	\N
489	21	99	2	1021776	\N	488698	\N	\N	2	1	2	f	533078	\N	\N
490	90	99	2	317672	\N	218018	\N	\N	3	1	2	f	99654	\N	\N
491	57	99	2	284593	\N	74277	\N	\N	4	1	2	f	210316	\N	\N
492	68	99	2	235046	\N	198208	\N	\N	5	1	2	f	36838	\N	\N
493	18	99	2	220197	\N	220197	\N	\N	6	1	2	f	0	\N	\N
494	53	99	2	56659	\N	28351	\N	\N	7	1	2	f	28308	\N	\N
495	82	99	2	48069	\N	33237	\N	\N	8	1	2	f	14832	\N	\N
496	6	99	2	5444	\N	5444	\N	\N	9	1	2	f	0	\N	\N
497	2	99	2	107	\N	107	\N	\N	10	1	2	f	0	\N	\N
498	34	100	2	103	\N	103	\N	\N	1	1	2	f	0	\N	\N
499	77	100	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
500	6	102	2	10060	\N	0	\N	\N	1	1	2	f	10060	\N	\N
501	38	103	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
502	8	103	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
503	74	103	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
504	40	103	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
505	77	104	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
506	70	105	2	15343	\N	15343	\N	\N	1	1	2	f	0	\N	\N
507	55	105	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
508	28	105	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
509	57	106	2	46934	\N	46934	\N	\N	1	1	2	f	0	\N	\N
510	53	106	1	46930	\N	46930	\N	\N	1	1	2	f	\N	\N	\N
511	86	107	2	536180	\N	536180	\N	\N	1	1	2	f	0	\N	\N
512	57	107	1	501567	\N	501567	\N	\N	1	1	2	f	\N	\N	\N
513	18	108	2	267586	\N	0	\N	\N	1	1	2	f	267586	\N	\N
514	85	109	2	57250	\N	57250	\N	\N	1	1	2	f	0	\N	\N
515	71	109	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
516	70	109	2	57069	\N	57069	\N	\N	2	1	2	f	0	\N	\N
517	62	109	1	114402	\N	114402	\N	\N	1	1	2	f	\N	\N	\N
518	18	110	2	58280	\N	58280	\N	\N	1	1	2	f	0	\N	\N
519	16	110	1	51341	\N	51341	\N	\N	1	1	2	f	\N	\N	\N
520	32	110	1	36079	\N	36079	\N	\N	0	1	2	f	\N	\N	\N
521	24	111	2	10944	\N	0	\N	\N	1	1	2	f	10944	\N	\N
522	2	112	2	138	\N	0	\N	\N	1	1	2	f	138	\N	\N
523	7	113	2	143	\N	143	\N	\N	1	1	2	f	0	\N	\N
524	11	113	1	286	\N	286	\N	\N	1	1	2	f	\N	\N	\N
525	88	114	2	5026	\N	0	\N	\N	1	1	2	f	5026	\N	\N
526	34	115	2	103	\N	103	\N	\N	1	1	2	f	0	\N	\N
527	7	116	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
528	43	116	1	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
529	31	117	2	50124083	\N	0	\N	\N	1	1	2	f	50124083	\N	\N
530	10	118	2	4457	\N	0	\N	\N	1	1	2	f	4457	\N	\N
531	25	118	2	155	\N	0	\N	\N	2	1	2	f	155	\N	\N
532	84	118	2	104	\N	0	\N	\N	3	1	2	f	104	\N	\N
533	1	118	2	101	\N	0	\N	\N	4	1	2	f	101	\N	\N
534	55	118	2	69	\N	0	\N	\N	5	1	2	f	69	\N	\N
535	6	118	2	63	\N	0	\N	\N	6	1	2	f	63	\N	\N
536	2	118	2	38	\N	0	\N	\N	7	1	2	f	38	\N	\N
537	3	118	2	17	\N	0	\N	\N	8	1	2	f	17	\N	\N
538	70	118	2	6	\N	0	\N	\N	9	1	2	f	6	\N	\N
539	5	118	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
540	91	118	2	1	\N	0	\N	\N	11	1	2	f	1	\N	\N
541	28	118	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
542	6	119	2	11660	\N	11660	\N	\N	1	1	2	f	0	\N	\N
543	67	120	2	624	\N	624	\N	\N	1	1	2	f	0	\N	\N
544	17	121	2	36434	\N	0	\N	\N	1	1	2	f	36434	\N	\N
545	32	121	2	29631	\N	0	\N	\N	0	1	2	f	29631	\N	\N
546	83	122	2	480614	\N	0	\N	\N	1	1	2	f	480614	\N	\N
547	86	122	2	251294	\N	0	\N	\N	2	1	2	f	251294	\N	\N
548	62	122	2	25556	\N	0	\N	\N	3	1	2	f	25556	\N	\N
549	30	122	2	22190	\N	0	\N	\N	4	1	2	f	22190	\N	\N
550	87	122	2	12406	\N	0	\N	\N	5	1	2	f	12406	\N	\N
551	24	122	2	10944	\N	0	\N	\N	6	1	2	f	10944	\N	\N
552	20	122	2	6134	\N	0	\N	\N	7	1	2	f	6134	\N	\N
553	64	122	2	4731	\N	0	\N	\N	8	1	2	f	4731	\N	\N
554	60	122	2	430	\N	0	\N	\N	9	1	2	f	430	\N	\N
555	56	122	2	198	\N	0	\N	\N	10	1	2	f	198	\N	\N
556	2	122	2	184	\N	0	\N	\N	11	1	2	f	184	\N	\N
557	26	122	2	138	\N	0	\N	\N	12	1	2	f	138	\N	\N
558	59	122	2	138	\N	0	\N	\N	13	1	2	f	138	\N	\N
559	75	122	2	98	\N	0	\N	\N	14	1	2	f	98	\N	\N
560	61	122	2	39	\N	0	\N	\N	15	1	2	f	39	\N	\N
561	91	122	2	26	\N	0	\N	\N	16	1	2	f	26	\N	\N
562	36	123	2	245	\N	245	\N	\N	1	1	2	f	0	\N	\N
563	72	123	1	204	\N	204	\N	\N	1	1	2	f	\N	\N	\N
564	36	123	1	40	\N	40	\N	\N	2	1	2	f	\N	\N	\N
565	6	124	2	206	\N	0	\N	\N	1	1	2	f	206	\N	\N
566	46	124	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
567	83	125	2	221652	\N	221652	\N	\N	1	1	2	f	0	\N	\N
568	4	126	2	366572	\N	0	\N	\N	1	1	2	f	366572	\N	\N
569	83	126	2	18656	\N	18656	\N	\N	2	1	2	f	0	\N	\N
570	44	126	2	709	\N	0	\N	\N	3	1	2	f	709	\N	\N
571	77	127	2	97	\N	97	\N	\N	1	1	2	f	0	\N	\N
572	39	127	1	97	\N	97	\N	\N	1	1	2	f	\N	\N	\N
573	57	128	2	853207	\N	853207	\N	\N	1	1	2	f	0	\N	\N
574	21	128	1	852485	\N	852485	\N	\N	1	1	2	f	\N	\N	\N
575	68	129	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
576	1	130	2	22626	\N	0	\N	\N	1	1	2	f	22626	\N	\N
577	2	130	2	208	\N	0	\N	\N	2	1	2	f	208	\N	\N
578	57	131	2	500178	\N	500178	\N	\N	1	1	2	f	0	\N	\N
579	68	131	2	235046	\N	235046	\N	\N	2	1	2	f	0	\N	\N
580	83	131	2	219240	\N	219240	\N	\N	3	1	2	f	0	\N	\N
581	90	131	1	1165070	\N	1165070	\N	\N	1	1	2	f	\N	\N	\N
582	64	132	2	176528	\N	176528	\N	\N	1	1	2	f	0	\N	\N
583	1	133	2	41260	\N	0	\N	\N	1	1	2	f	41260	\N	\N
584	90	133	2	21905	\N	0	\N	\N	2	1	2	f	21905	\N	\N
585	85	134	2	25452	\N	25452	\N	\N	1	1	2	f	0	\N	\N
586	70	134	2	16786	\N	16786	\N	\N	2	1	2	f	0	\N	\N
587	24	134	2	602	\N	602	\N	\N	3	1	2	f	0	\N	\N
588	18	135	2	199490	\N	199490	\N	\N	1	1	2	f	0	\N	\N
589	32	135	2	37666	\N	37666	\N	\N	2	1	2	f	0	\N	\N
590	17	135	2	26489	\N	26489	\N	\N	0	1	2	f	0	\N	\N
591	89	135	2	17797	\N	17797	\N	\N	0	1	2	f	0	\N	\N
592	86	135	1	240790	\N	240790	\N	\N	1	1	2	f	\N	\N	\N
593	50	136	2	179	\N	0	\N	\N	1	1	2	f	179	\N	\N
594	78	136	2	179	\N	0	\N	\N	2	1	2	f	179	\N	\N
595	51	136	2	107	\N	0	\N	\N	3	1	2	f	107	\N	\N
596	47	136	2	62	\N	0	\N	\N	4	1	2	f	62	\N	\N
597	14	136	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
598	80	136	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
599	15	136	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
600	76	136	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
601	79	136	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
602	73	137	2	29	\N	29	\N	\N	1	1	2	f	0	\N	\N
603	48	137	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
604	76	137	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
605	68	138	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
606	16	139	2	5859	\N	0	\N	\N	1	1	2	f	5859	\N	\N
607	32	139	2	4431	\N	0	\N	\N	0	1	2	f	4431	\N	\N
608	4	140	2	162	\N	162	\N	\N	1	1	2	f	0	\N	\N
609	44	140	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
610	7	140	1	163	\N	163	\N	\N	1	1	2	f	\N	\N	\N
611	47	141	2	62	\N	0	\N	\N	1	1	2	f	62	\N	\N
612	78	141	2	13	\N	0	\N	\N	2	1	2	f	13	\N	\N
613	50	141	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
614	51	141	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
615	14	141	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
616	80	141	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
617	15	141	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
618	79	141	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
619	85	142	2	29776	\N	29776	\N	\N	1	1	2	f	0	\N	\N
620	36	143	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
621	50	144	2	506	\N	506	\N	\N	1	1	2	f	0	\N	\N
622	51	144	2	186	\N	186	\N	\N	2	1	2	f	0	\N	\N
623	47	144	2	55	\N	55	\N	\N	3	1	2	f	0	\N	\N
624	80	144	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
625	78	144	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
626	15	144	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
627	78	144	1	483	\N	483	\N	\N	1	1	2	f	\N	\N	\N
628	14	144	1	44	\N	44	\N	\N	0	1	2	f	\N	\N	\N
629	76	144	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
630	70	145	2	810	\N	0	\N	\N	1	1	2	f	810	\N	\N
631	85	146	2	5688	\N	5688	\N	\N	1	1	2	f	0	\N	\N
632	60	146	2	5578	\N	5578	\N	\N	2	1	2	f	0	\N	\N
633	20	146	1	11076	\N	11076	\N	\N	1	1	2	f	\N	\N	\N
634	60	147	2	430	\N	0	\N	\N	1	1	2	f	430	\N	\N
635	56	147	2	198	\N	0	\N	\N	2	1	2	f	198	\N	\N
636	41	148	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
637	11	148	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
638	90	149	2	21450	\N	21450	\N	\N	1	1	2	f	0	\N	\N
639	75	149	1	21170	\N	21170	\N	\N	1	1	2	f	\N	\N	\N
640	2	150	2	4484	\N	4484	\N	\N	1	1	2	f	0	\N	\N
641	1	150	2	3098	\N	3098	\N	\N	2	1	2	f	0	\N	\N
642	3	150	2	98	\N	98	\N	\N	3	1	2	f	0	\N	\N
643	5	150	2	6	\N	6	\N	\N	4	1	2	f	0	\N	\N
644	55	150	1	7686	\N	7686	\N	\N	1	1	2	f	\N	\N	\N
645	83	151	2	1334	\N	1334	\N	\N	1	1	2	f	0	\N	\N
646	64	151	1	1816	\N	1816	\N	\N	1	1	2	f	\N	\N	\N
647	83	152	2	2952976	\N	0	\N	\N	1	1	2	f	2952976	\N	\N
648	18	152	2	1291596	\N	0	\N	\N	2	1	2	f	1291596	\N	\N
649	81	153	2	2101	\N	0	\N	\N	1	1	2	f	2101	\N	\N
650	83	154	2	475750	\N	0	\N	\N	1	1	2	f	475750	\N	\N
651	36	155	2	245	\N	245	\N	\N	1	1	2	f	0	\N	\N
652	36	155	1	230	\N	230	\N	\N	1	1	2	f	\N	\N	\N
653	72	155	1	14	\N	14	\N	\N	2	1	2	f	\N	\N	\N
654	18	156	2	27666	\N	27666	\N	\N	1	1	2	f	0	\N	\N
655	92	156	1	27666	\N	27666	\N	\N	1	1	2	f	\N	\N	\N
656	54	157	2	56332	\N	56332	\N	\N	1	1	2	f	0	\N	\N
657	60	157	2	29762	\N	29762	\N	\N	2	1	2	f	0	\N	\N
658	61	157	2	2709	\N	2709	\N	\N	3	1	2	f	0	\N	\N
659	56	157	2	1892	\N	1892	\N	\N	4	1	2	f	0	\N	\N
660	85	157	1	55440	\N	55440	\N	\N	1	1	2	f	\N	\N	\N
661	64	157	1	5079	\N	5079	\N	\N	2	1	2	f	\N	\N	\N
662	70	157	1	833	\N	833	\N	\N	3	1	2	f	\N	\N	\N
663	24	158	2	10944	\N	0	\N	\N	1	1	2	f	10944	\N	\N
664	18	159	2	64395	\N	64395	\N	\N	1	1	2	f	0	\N	\N
665	29	159	1	64395	\N	64395	\N	\N	1	1	2	f	\N	\N	\N
666	18	160	2	3479	\N	3479	\N	\N	1	1	2	f	0	\N	\N
667	24	160	1	3480	\N	3480	\N	\N	1	1	2	f	\N	\N	\N
668	47	161	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
669	50	161	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
670	80	161	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
671	15	161	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
672	47	161	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
673	50	161	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
674	80	161	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
675	15	161	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
676	18	162	2	32859	\N	32859	\N	\N	1	1	2	f	0	\N	\N
677	63	162	1	32842	\N	32842	\N	\N	1	1	2	f	\N	\N	\N
678	4	163	2	74810	\N	74810	\N	\N	1	1	2	f	0	\N	\N
679	18	163	2	51790	\N	0	\N	\N	2	1	2	f	51790	\N	\N
680	1	163	2	41276	\N	41276	\N	\N	3	1	2	f	0	\N	\N
681	82	163	2	2714	\N	0	\N	\N	4	1	2	f	2714	\N	\N
682	44	163	2	538	\N	538	\N	\N	5	1	2	f	0	\N	\N
683	64	163	2	162	\N	162	\N	\N	6	1	2	f	0	\N	\N
684	2	163	2	30	\N	30	\N	\N	7	1	2	f	0	\N	\N
685	4	163	1	74810	\N	74810	\N	\N	1	1	2	f	\N	\N	\N
686	3	163	1	27604	\N	27604	\N	\N	2	1	2	f	\N	\N	\N
687	2	163	1	13138	\N	13138	\N	\N	3	1	2	f	\N	\N	\N
688	44	163	1	538	\N	538	\N	\N	4	1	2	f	\N	\N	\N
689	64	163	1	176	\N	176	\N	\N	5	1	2	f	\N	\N	\N
690	18	165	2	76627	\N	76627	\N	\N	1	1	2	f	0	\N	\N
691	24	165	2	15132	\N	15132	\N	\N	2	1	2	f	0	\N	\N
692	88	165	1	64090	\N	64090	\N	\N	1	1	2	f	\N	\N	\N
693	77	166	2	97	\N	97	\N	\N	1	1	2	f	0	\N	\N
694	22	167	2	33598	\N	33598	\N	\N	1	1	2	f	0	\N	\N
695	10	167	2	1080	\N	1080	\N	\N	2	1	2	f	0	\N	\N
696	18	167	2	594	\N	594	\N	\N	3	1	2	f	0	\N	\N
697	6	167	2	16	\N	16	\N	\N	4	1	2	f	0	\N	\N
698	70	168	2	31536	\N	0	\N	\N	1	1	2	f	31536	\N	\N
699	85	168	2	25530	\N	0	\N	\N	2	1	2	f	25530	\N	\N
700	24	168	2	10944	\N	0	\N	\N	3	1	2	f	10944	\N	\N
701	55	168	2	970	\N	0	\N	\N	4	1	2	f	970	\N	\N
702	70	169	2	31532	\N	0	\N	\N	1	1	2	f	31532	\N	\N
703	85	169	2	25530	\N	0	\N	\N	2	1	2	f	25530	\N	\N
704	24	169	2	10944	\N	0	\N	\N	3	1	2	f	10944	\N	\N
705	55	169	2	966	\N	0	\N	\N	4	1	2	f	966	\N	\N
706	4	170	2	74830	\N	74830	\N	\N	1	1	2	f	0	\N	\N
707	44	170	2	539	\N	539	\N	\N	2	1	2	f	0	\N	\N
708	43	170	1	75369	\N	75369	\N	\N	1	1	2	f	\N	\N	\N
709	85	171	2	75626	\N	75626	\N	\N	1	1	2	f	0	\N	\N
710	78	172	2	168	\N	168	\N	\N	1	1	2	f	0	\N	\N
711	50	172	2	151	\N	151	\N	\N	2	1	2	f	0	\N	\N
712	51	172	2	99	\N	99	\N	\N	3	1	2	f	0	\N	\N
713	47	172	2	62	\N	62	\N	\N	4	1	2	f	0	\N	\N
714	80	172	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
715	14	172	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
716	15	172	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
717	76	172	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
718	79	172	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
719	48	172	1	242	\N	242	\N	\N	1	1	2	f	\N	\N	\N
720	73	172	1	170	\N	170	\N	\N	0	1	2	f	\N	\N	\N
721	76	172	1	170	\N	170	\N	\N	0	1	2	f	\N	\N	\N
722	73	173	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
723	48	173	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
724	76	173	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
725	10	174	2	29	\N	29	\N	\N	1	1	2	f	0	\N	\N
726	9	174	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
727	77	175	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
728	49	176	2	39	\N	39	\N	\N	1	1	2	f	0	\N	\N
729	78	177	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
730	14	177	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
731	78	177	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
732	14	177	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
733	17	178	2	18796	\N	0	\N	\N	1	1	2	f	18796	\N	\N
734	55	179	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
735	78	180	2	221	\N	221	\N	\N	1	1	2	f	0	\N	\N
736	68	181	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
737	78	182	2	102	\N	0	\N	\N	1	1	2	f	102	\N	\N
738	50	182	2	92	\N	0	\N	\N	2	1	2	f	92	\N	\N
739	51	182	2	78	\N	0	\N	\N	3	1	2	f	78	\N	\N
740	73	182	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
741	48	182	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
742	76	182	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
743	70	183	2	27042	\N	27042	\N	\N	1	1	2	f	0	\N	\N
744	55	183	2	14	\N	14	\N	\N	2	1	2	f	0	\N	\N
745	28	183	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
746	86	184	2	54973	\N	54973	\N	\N	1	1	2	f	0	\N	\N
747	68	184	2	34345	\N	34345	\N	\N	2	1	2	f	0	\N	\N
748	83	184	1	89700	\N	89700	\N	\N	1	1	2	f	\N	\N	\N
749	86	185	2	11179	\N	11179	\N	\N	1	1	2	f	0	\N	\N
750	82	185	2	1969	\N	1969	\N	\N	2	1	2	f	0	\N	\N
751	82	185	1	20693	\N	20693	\N	\N	1	1	2	f	\N	\N	\N
752	55	186	2	1176	\N	1176	\N	\N	1	1	2	f	0	\N	\N
753	10	186	2	50	\N	50	\N	\N	2	1	2	f	0	\N	\N
754	18	186	2	12	\N	12	\N	\N	3	1	2	f	0	\N	\N
755	68	187	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
756	10	188	2	6381	\N	6381	\N	\N	1	1	2	f	0	\N	\N
757	81	188	2	60	\N	60	\N	\N	2	1	2	f	0	\N	\N
758	64	188	1	11541	\N	11541	\N	\N	1	1	2	f	\N	\N	\N
759	81	189	2	2161	\N	2151	\N	\N	1	1	2	f	10	\N	\N
760	18	190	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
761	18	190	1	44	\N	44	\N	\N	1	1	2	f	\N	\N	\N
762	68	191	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
763	62	192	2	22254	\N	0	\N	\N	1	1	2	f	22254	\N	\N
764	73	193	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
765	48	193	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
766	76	193	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
767	39	194	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
768	83	195	2	1052688	\N	743594	\N	\N	1	1	2	f	309094	\N	\N
769	18	195	2	213797	\N	213797	\N	\N	2	1	2	f	0	\N	\N
770	86	195	2	182349	\N	182349	\N	\N	3	1	2	f	0	\N	\N
771	90	195	2	44614	\N	44614	\N	\N	4	1	2	f	0	\N	\N
772	82	195	2	35935	\N	34947	\N	\N	5	1	2	f	988	\N	\N
773	92	195	2	31752	\N	19118	\N	\N	6	1	2	f	12634	\N	\N
774	85	195	2	25530	\N	25530	\N	\N	7	1	2	f	0	\N	\N
775	19	195	2	21876	\N	21876	\N	\N	8	1	2	f	0	\N	\N
776	89	195	2	17287	\N	10105	\N	\N	9	1	2	f	7182	\N	\N
777	28	195	2	12370	\N	11268	\N	\N	10	1	2	f	1102	\N	\N
778	25	195	2	4	\N	4	\N	\N	11	1	2	f	0	\N	\N
779	43	195	2	1	\N	1	\N	\N	12	1	2	f	0	\N	\N
780	32	195	2	14033	\N	10442	\N	\N	0	1	2	f	3591	\N	\N
781	6	196	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
782	58	197	2	7494	\N	0	\N	\N	1	1	2	f	7494	\N	\N
783	24	198	2	4188	\N	0	\N	\N	1	1	2	f	4188	\N	\N
784	23	199	1	16800	\N	16800	\N	\N	1	1	2	f	\N	\N	\N
785	60	200	2	114	\N	114	\N	\N	1	1	2	f	0	\N	\N
786	56	200	2	92	\N	92	\N	\N	2	1	2	f	0	\N	\N
787	1	201	2	41768	\N	0	\N	\N	1	1	2	f	41768	\N	\N
788	58	201	2	25546	\N	0	\N	\N	2	1	2	f	25546	\N	\N
789	90	201	2	24088	\N	0	\N	\N	3	1	2	f	24088	\N	\N
790	86	201	2	20484	\N	0	\N	\N	4	1	2	f	20484	\N	\N
791	2	201	2	9985	\N	0	\N	\N	5	1	2	f	9985	\N	\N
792	18	201	2	633	\N	0	\N	\N	6	1	2	f	633	\N	\N
793	64	201	2	591	\N	0	\N	\N	7	1	2	f	591	\N	\N
794	3	201	2	176	\N	0	\N	\N	8	1	2	f	176	\N	\N
795	10	201	2	26	\N	0	\N	\N	9	1	2	f	26	\N	\N
796	5	201	2	12	\N	0	\N	\N	10	1	2	f	12	\N	\N
797	83	202	2	1052660	\N	0	\N	\N	1	1	2	f	1052660	\N	\N
798	18	202	2	304014	\N	0	\N	\N	2	1	2	f	304014	\N	\N
799	82	202	2	2558	\N	0	\N	\N	3	1	2	f	2558	\N	\N
800	77	202	2	104	\N	104	\N	\N	4	1	2	f	0	\N	\N
801	6	202	2	8	\N	0	\N	\N	5	1	2	f	8	\N	\N
802	73	202	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
803	48	202	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
804	76	202	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
805	39	202	1	104	\N	104	\N	\N	1	1	2	f	\N	\N	\N
806	33	203	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
807	1	204	2	40932	\N	0	\N	\N	1	1	2	f	40932	\N	\N
808	2	204	2	11845	\N	0	\N	\N	2	1	2	f	11845	\N	\N
809	10	204	2	6380	\N	0	\N	\N	3	1	2	f	6380	\N	\N
810	3	204	2	278	\N	0	\N	\N	4	1	2	f	278	\N	\N
811	77	204	2	104	\N	0	\N	\N	5	1	2	f	104	\N	\N
812	34	204	2	6	\N	0	\N	\N	6	1	2	f	6	\N	\N
813	5	204	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
814	52	204	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
815	44	205	2	539	\N	539	\N	\N	1	1	2	f	0	\N	\N
816	52	206	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
817	4	207	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
818	42	207	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
819	58	208	2	25556	\N	25556	\N	\N	1	1	2	f	0	\N	\N
820	61	208	2	99	\N	43	\N	\N	2	1	2	f	56	\N	\N
821	91	208	1	25600	\N	25600	\N	\N	1	1	2	f	\N	\N	\N
822	83	209	2	1624312	\N	1624312	\N	\N	1	1	2	f	0	\N	\N
823	2	210	2	3532	\N	0	\N	\N	1	1	2	f	3532	\N	\N
824	70	211	2	17975	\N	17975	\N	\N	1	1	2	f	0	\N	\N
825	28	211	2	17217	\N	17217	\N	\N	2	1	2	f	0	\N	\N
826	87	211	1	34434	\N	34434	\N	\N	1	1	2	f	\N	\N	\N
827	6	212	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
828	1	213	2	17558	\N	0	\N	\N	1	1	2	f	17558	\N	\N
829	2	213	2	4411	\N	0	\N	\N	2	1	2	f	4411	\N	\N
830	3	213	2	120	\N	0	\N	\N	3	1	2	f	120	\N	\N
831	3	214	2	148	\N	0	\N	\N	1	1	2	f	148	\N	\N
832	86	215	2	239791	\N	239791	\N	\N	1	1	2	f	0	\N	\N
833	68	215	2	196744	\N	196744	\N	\N	2	1	2	f	0	\N	\N
834	16	215	2	23181	\N	23181	\N	\N	3	1	2	f	0	\N	\N
835	83	215	2	9872	\N	9872	\N	\N	4	1	2	f	0	\N	\N
836	32	215	2	20985	\N	20985	\N	\N	0	1	2	f	0	\N	\N
837	18	215	1	743205	\N	743205	\N	\N	1	1	2	f	\N	\N	\N
838	13	216	2	96	\N	96	\N	\N	1	1	2	f	0	\N	\N
839	12	216	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
840	45	216	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
841	70	216	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
842	6	217	2	11660	\N	0	\N	\N	1	1	2	f	11660	\N	\N
843	2	217	2	14	\N	0	\N	\N	2	1	2	f	14	\N	\N
844	68	218	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
845	78	219	2	309	\N	309	\N	\N	1	1	2	f	0	\N	\N
846	14	219	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
847	49	219	1	114	\N	114	\N	\N	1	1	2	f	\N	\N	\N
848	78	219	1	79	\N	79	\N	\N	2	1	2	f	\N	\N	\N
849	14	219	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
850	76	219	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
851	83	220	2	808838	\N	808838	\N	\N	1	1	2	f	0	\N	\N
852	1	220	2	49210	\N	49210	\N	\N	2	1	2	f	0	\N	\N
853	2	220	2	11220	\N	11220	\N	\N	3	1	2	f	0	\N	\N
854	3	220	2	156	\N	156	\N	\N	4	1	2	f	0	\N	\N
855	5	220	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
856	36	220	1	60592	\N	60592	\N	\N	1	1	2	f	\N	\N	\N
857	58	221	2	25556	\N	0	\N	\N	1	1	2	f	25556	\N	\N
858	23	222	2	4744	\N	0	\N	\N	1	1	2	f	4744	\N	\N
859	23	223	2	4466	\N	0	\N	\N	1	1	2	f	4466	\N	\N
860	6	224	2	10060	\N	0	\N	\N	1	1	2	f	10060	\N	\N
861	23	225	2	4744	\N	0	\N	\N	1	1	2	f	4744	\N	\N
862	1	226	2	40216	\N	0	\N	\N	1	1	2	f	40216	\N	\N
863	90	227	2	113773	\N	113773	\N	\N	1	1	2	f	0	\N	\N
864	19	227	1	113656	\N	113656	\N	\N	1	1	2	f	\N	\N	\N
865	50	228	2	298	\N	298	\N	\N	1	1	2	f	0	\N	\N
866	51	228	2	160	\N	160	\N	\N	2	1	2	f	0	\N	\N
867	47	228	2	55	\N	55	\N	\N	3	1	2	f	0	\N	\N
868	80	228	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
869	78	228	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
870	15	228	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
871	78	228	1	261	\N	261	\N	\N	1	1	2	f	\N	\N	\N
872	14	228	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
873	76	228	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
874	31	229	2	50124395	\N	50124395	\N	\N	1	1	2	f	0	\N	\N
875	21	229	2	829721	\N	829721	\N	\N	2	1	2	f	0	\N	\N
876	57	229	2	370278	\N	370278	\N	\N	3	1	2	f	0	\N	\N
877	27	229	2	88280	\N	88280	\N	\N	4	1	2	f	0	\N	\N
878	62	229	2	57254	\N	57254	\N	\N	5	1	2	f	0	\N	\N
879	30	229	2	22944	\N	22944	\N	\N	6	1	2	f	0	\N	\N
880	20	229	2	6134	\N	6134	\N	\N	7	1	2	f	0	\N	\N
881	25	229	2	304	\N	304	\N	\N	8	1	2	f	0	\N	\N
882	85	229	1	52531382	\N	52531382	\N	\N	1	1	2	f	\N	\N	\N
883	71	229	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
884	22	230	2	33596	\N	0	\N	\N	1	1	2	f	33596	\N	\N
885	2	230	2	12044	\N	0	\N	\N	2	1	2	f	12044	\N	\N
886	3	230	2	194	\N	0	\N	\N	3	1	2	f	194	\N	\N
887	77	230	2	104	\N	104	\N	\N	4	1	2	f	0	\N	\N
888	73	230	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
889	48	230	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
890	76	230	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
891	39	230	1	104	\N	104	\N	\N	1	1	2	f	\N	\N	\N
892	51	231	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
893	47	231	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
894	50	231	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
895	2	232	2	359	\N	0	\N	\N	1	1	2	f	359	\N	\N
896	18	233	2	3457	\N	3457	\N	\N	1	1	2	f	0	\N	\N
897	67	233	1	3457	\N	3457	\N	\N	1	1	2	f	\N	\N	\N
898	4	234	2	67133	\N	0	\N	\N	1	1	2	f	67133	\N	\N
899	34	234	2	147	\N	147	\N	\N	2	1	2	f	0	\N	\N
900	69	234	2	69	\N	0	\N	\N	3	1	2	f	69	\N	\N
901	7	234	2	69	\N	0	\N	\N	4	1	2	f	69	\N	\N
902	36	235	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
903	73	235	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
904	48	235	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
905	76	235	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
906	52	236	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
907	39	236	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
908	2	237	2	2870	\N	0	\N	\N	1	1	2	f	2870	\N	\N
909	83	238	2	307938	\N	307938	\N	\N	1	1	2	f	0	\N	\N
910	66	238	1	78834	\N	78834	\N	\N	1	1	2	f	\N	\N	\N
911	86	239	2	400823	\N	400823	\N	\N	1	1	2	f	0	\N	\N
912	68	239	2	235046	\N	235046	\N	\N	2	1	2	f	0	\N	\N
913	90	239	2	47157	\N	47157	\N	\N	3	1	2	f	0	\N	\N
914	54	239	1	843826	\N	843826	\N	\N	1	1	2	f	\N	\N	\N
915	83	240	2	1052688	\N	0	\N	\N	1	1	2	f	1052688	\N	\N
916	73	241	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
917	48	241	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
918	76	241	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
919	59	242	2	294	\N	294	\N	\N	1	1	2	f	0	\N	\N
920	70	242	2	294	\N	294	\N	\N	2	1	2	f	0	\N	\N
921	26	242	1	588	\N	588	\N	\N	1	1	2	f	\N	\N	\N
922	2	243	2	980	\N	0	\N	\N	1	1	2	f	980	\N	\N
923	9	244	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
924	39	244	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
925	10	245	2	47	\N	47	\N	\N	1	1	2	f	0	\N	\N
926	4	246	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
927	44	246	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
928	4	246	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
929	31	247	2	99819073	\N	99819073	\N	\N	1	1	2	f	0	\N	\N
930	83	247	2	2125120	\N	2125120	\N	\N	2	1	2	f	0	\N	\N
931	21	247	2	1800669	\N	1800669	\N	\N	3	1	2	f	0	\N	\N
932	57	247	2	770683	\N	770683	\N	\N	4	1	2	f	0	\N	\N
933	86	247	2	682999	\N	682999	\N	\N	5	1	2	f	0	\N	\N
934	18	247	2	621847	\N	621847	\N	\N	6	1	2	f	0	\N	\N
935	90	247	2	471106	\N	471106	\N	\N	7	1	2	f	0	\N	\N
936	68	247	2	459124	\N	459124	\N	\N	8	1	2	f	0	\N	\N
937	17	247	2	313223	\N	313223	\N	\N	9	1	2	f	0	\N	\N
938	29	247	2	228431	\N	228431	\N	\N	10	1	2	f	0	\N	\N
939	27	247	2	159258	\N	159258	\N	\N	11	1	2	f	0	\N	\N
940	32	247	2	145829	\N	145829	\N	\N	12	1	2	f	0	\N	\N
941	62	247	2	114536	\N	114536	\N	\N	13	1	2	f	0	\N	\N
942	82	247	2	113148	\N	113148	\N	\N	14	1	2	f	0	\N	\N
943	85	247	2	110973	\N	110973	\N	\N	15	1	2	f	0	\N	\N
944	71	247	2	4	\N	4	\N	\N	15	1	2	f	0	\N	\N
945	53	247	2	100144	\N	100144	\N	\N	16	1	2	f	0	\N	\N
946	1	247	2	81965	\N	81965	\N	\N	17	1	2	f	0	\N	\N
947	66	247	2	78834	\N	78834	\N	\N	18	1	2	f	0	\N	\N
948	4	247	2	74831	\N	74831	\N	\N	19	1	2	f	0	\N	\N
949	22	247	2	67196	\N	67196	\N	\N	20	1	2	f	0	\N	\N
950	70	247	2	63771	\N	63771	\N	\N	21	1	2	f	0	\N	\N
951	92	247	2	56642	\N	56642	\N	\N	22	1	2	f	0	\N	\N
952	58	247	2	51112	\N	51112	\N	\N	23	1	2	f	0	\N	\N
953	30	247	2	49828	\N	49828	\N	\N	24	1	2	f	0	\N	\N
954	19	247	2	43756	\N	43756	\N	\N	25	1	2	f	0	\N	\N
955	55	247	2	35575	\N	35575	\N	\N	26	1	2	f	0	\N	\N
956	87	247	2	34436	\N	34436	\N	\N	27	1	2	f	0	\N	\N
957	28	247	2	34369	\N	34369	\N	\N	28	1	2	f	0	\N	\N
958	24	247	2	30260	\N	30260	\N	\N	29	1	2	f	0	\N	\N
959	84	247	2	27344	\N	27344	\N	\N	30	1	2	f	0	\N	\N
960	2	247	2	23834	\N	23834	\N	\N	31	1	2	f	0	\N	\N
961	6	247	2	23373	\N	23373	\N	\N	32	1	2	f	0	\N	\N
962	64	247	2	19544	\N	19544	\N	\N	33	1	2	f	0	\N	\N
963	10	247	2	17204	\N	17204	\N	\N	34	1	2	f	0	\N	\N
964	20	247	2	12268	\N	12268	\N	\N	35	1	2	f	0	\N	\N
965	88	247	2	10633	\N	10633	\N	\N	36	1	2	f	0	\N	\N
966	23	247	2	9996	\N	9996	\N	\N	37	1	2	f	0	\N	\N
967	67	247	2	8110	\N	8110	\N	\N	38	1	2	f	0	\N	\N
968	3	247	2	4717	\N	4717	\N	\N	39	1	2	f	0	\N	\N
969	81	247	2	4361	\N	4361	\N	\N	40	1	2	f	0	\N	\N
970	60	247	2	884	\N	884	\N	\N	41	1	2	f	0	\N	\N
971	26	247	2	588	\N	588	\N	\N	42	1	2	f	0	\N	\N
972	59	247	2	588	\N	588	\N	\N	43	1	2	f	0	\N	\N
973	44	247	2	539	\N	539	\N	\N	44	1	2	f	0	\N	\N
974	78	247	2	537	\N	537	\N	\N	45	1	2	f	0	\N	\N
975	36	247	2	498	\N	498	\N	\N	46	1	2	f	0	\N	\N
976	56	247	2	396	\N	396	\N	\N	47	1	2	f	0	\N	\N
977	50	247	2	312	\N	312	\N	\N	48	1	2	f	0	\N	\N
978	25	247	2	309	\N	309	\N	\N	49	1	2	f	0	\N	\N
979	42	247	2	236	\N	236	\N	\N	50	1	2	f	0	\N	\N
980	54	247	2	204	\N	204	\N	\N	51	1	2	f	0	\N	\N
981	51	247	2	201	\N	201	\N	\N	52	1	2	f	0	\N	\N
982	61	247	2	201	\N	201	\N	\N	53	1	2	f	0	\N	\N
983	75	247	2	196	\N	196	\N	\N	54	1	2	f	0	\N	\N
984	34	247	2	147	\N	147	\N	\N	55	1	2	f	0	\N	\N
985	7	247	2	143	\N	143	\N	\N	56	1	2	f	0	\N	\N
986	69	247	2	142	\N	142	\N	\N	57	1	2	f	0	\N	\N
987	47	247	2	139	\N	139	\N	\N	58	1	2	f	0	\N	\N
988	49	247	2	114	\N	114	\N	\N	59	1	2	f	0	\N	\N
989	77	247	2	104	\N	104	\N	\N	60	1	2	f	0	\N	\N
990	13	247	2	96	\N	96	\N	\N	61	1	2	f	0	\N	\N
991	9	247	2	60	\N	60	\N	\N	62	1	2	f	0	\N	\N
992	91	247	2	53	\N	53	\N	\N	63	1	2	f	0	\N	\N
993	65	247	2	44	\N	44	\N	\N	64	1	2	f	0	\N	\N
994	35	247	2	33	\N	33	\N	\N	65	1	2	f	0	\N	\N
995	45	247	2	24	\N	24	\N	\N	66	1	2	f	0	\N	\N
996	43	247	2	22	\N	22	\N	\N	67	1	2	f	0	\N	\N
997	33	247	2	20	\N	20	\N	\N	68	1	2	f	0	\N	\N
998	5	247	2	17	\N	17	\N	\N	69	1	2	f	0	\N	\N
999	63	247	2	12	\N	12	\N	\N	70	1	2	f	0	\N	\N
1000	39	247	2	9	\N	9	\N	\N	71	1	2	f	0	\N	\N
1001	79	247	2	8	\N	8	\N	\N	72	1	2	f	0	\N	\N
1002	12	247	2	8	\N	8	\N	\N	73	1	2	f	0	\N	\N
1003	46	247	2	8	\N	8	\N	\N	74	1	2	f	0	\N	\N
1004	76	247	2	6	\N	6	\N	\N	75	1	2	f	0	\N	\N
1005	48	247	2	4	\N	4	\N	\N	76	1	2	f	0	\N	\N
1006	72	247	2	4	\N	4	\N	\N	77	1	2	f	0	\N	\N
1007	41	247	2	4	\N	4	\N	\N	78	1	2	f	0	\N	\N
1008	11	247	2	4	\N	4	\N	\N	79	1	2	f	0	\N	\N
1009	38	247	2	4	\N	4	\N	\N	80	1	2	f	0	\N	\N
1010	37	247	2	4	\N	4	\N	\N	81	1	2	f	0	\N	\N
1011	74	247	2	2	\N	2	\N	\N	82	1	2	f	0	\N	\N
1012	8	247	2	1	\N	1	\N	\N	83	1	2	f	0	\N	\N
1013	40	247	2	1	\N	1	\N	\N	84	1	2	f	0	\N	\N
1014	52	247	2	1	\N	1	\N	\N	85	1	2	f	0	\N	\N
1015	89	247	2	53610	\N	53610	\N	\N	0	1	2	f	0	\N	\N
1016	16	247	2	17568	\N	17568	\N	\N	0	1	2	f	0	\N	\N
1017	80	247	2	35	\N	35	\N	\N	0	1	2	f	0	\N	\N
1018	14	247	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1019	15	247	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1020	73	247	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1021	78	247	1	109535741	\N	109535741	\N	\N	1	1	2	f	\N	\N	\N
1022	14	247	1	34078	\N	34078	\N	\N	0	1	2	f	\N	\N	\N
1023	18	248	2	55344	\N	55344	\N	\N	1	1	2	f	0	\N	\N
1024	24	248	2	15132	\N	15132	\N	\N	2	1	2	f	0	\N	\N
1025	88	248	2	5232	\N	5232	\N	\N	3	1	2	f	0	\N	\N
1026	61	248	2	340	\N	340	\N	\N	4	1	2	f	0	\N	\N
1027	26	248	2	294	\N	294	\N	\N	5	1	2	f	0	\N	\N
1028	59	248	1	71920	\N	71920	\N	\N	1	1	2	f	\N	\N	\N
1029	31	250	2	49695098	\N	0	\N	\N	1	1	2	f	49695098	\N	\N
1030	83	250	2	1062568	\N	0	\N	\N	2	1	2	f	1062568	\N	\N
1031	21	250	2	777874	\N	0	\N	\N	3	1	2	f	777874	\N	\N
1032	18	250	2	364643	\N	0	\N	\N	4	1	2	f	364643	\N	\N
1033	57	250	2	270520	\N	0	\N	\N	5	1	2	f	270520	\N	\N
1034	86	250	2	251136	\N	0	\N	\N	6	1	2	f	251136	\N	\N
1035	90	250	2	235338	\N	0	\N	\N	7	1	2	f	235338	\N	\N
1036	68	250	2	224078	\N	0	\N	\N	8	1	2	f	224078	\N	\N
1037	17	250	2	138007	\N	0	\N	\N	9	1	2	f	138007	\N	\N
1038	29	250	2	114486	\N	0	\N	\N	10	1	2	f	114486	\N	\N
1039	1	250	2	76796	\N	0	\N	\N	11	1	2	f	76796	\N	\N
1040	27	250	2	69946	\N	0	\N	\N	12	1	2	f	69946	\N	\N
1041	62	250	2	57270	\N	0	\N	\N	13	1	2	f	57270	\N	\N
1042	82	250	2	56527	\N	0	\N	\N	14	1	2	f	56527	\N	\N
1043	85	250	2	55489	\N	0	\N	\N	15	1	2	f	55489	\N	\N
1044	32	250	2	49035	\N	0	\N	\N	16	1	2	f	49035	\N	\N
1045	53	250	2	43326	\N	0	\N	\N	17	1	2	f	43326	\N	\N
1046	22	250	2	33598	\N	0	\N	\N	18	1	2	f	33598	\N	\N
1047	70	250	2	31872	\N	0	\N	\N	19	1	2	f	31872	\N	\N
1048	58	250	2	25556	\N	0	\N	\N	20	1	2	f	25556	\N	\N
1049	30	250	2	24914	\N	0	\N	\N	21	1	2	f	24914	\N	\N
1050	92	250	2	24890	\N	0	\N	\N	22	1	2	f	24890	\N	\N
1051	19	250	2	21878	\N	0	\N	\N	23	1	2	f	21878	\N	\N
1052	55	250	2	17780	\N	0	\N	\N	24	1	2	f	17780	\N	\N
1053	87	250	2	17218	\N	0	\N	\N	25	1	2	f	17218	\N	\N
1054	28	250	2	17185	\N	0	\N	\N	26	1	2	f	17185	\N	\N
1055	24	250	2	15132	\N	0	\N	\N	27	1	2	f	15132	\N	\N
1056	64	250	2	14132	\N	0	\N	\N	28	1	2	f	14132	\N	\N
1057	84	250	2	13620	\N	0	\N	\N	29	1	2	f	13620	\N	\N
1058	2	250	2	11718	\N	0	\N	\N	30	1	2	f	11718	\N	\N
1059	6	250	2	11668	\N	0	\N	\N	31	1	2	f	11668	\N	\N
1060	10	250	2	6385	\N	0	\N	\N	32	1	2	f	6385	\N	\N
1061	20	250	2	6134	\N	0	\N	\N	33	1	2	f	6134	\N	\N
1062	88	250	2	5401	\N	0	\N	\N	34	1	2	f	5401	\N	\N
1063	23	250	2	4998	\N	0	\N	\N	35	1	2	f	4998	\N	\N
1064	67	250	2	3698	\N	0	\N	\N	36	1	2	f	3698	\N	\N
1065	3	250	2	2350	\N	0	\N	\N	37	1	2	f	2350	\N	\N
1066	81	250	2	2204	\N	0	\N	\N	38	1	2	f	2204	\N	\N
1067	60	250	2	454	\N	0	\N	\N	39	1	2	f	454	\N	\N
1068	26	250	2	294	\N	0	\N	\N	40	1	2	f	294	\N	\N
1069	59	250	2	294	\N	0	\N	\N	41	1	2	f	294	\N	\N
1070	36	250	2	248	\N	0	\N	\N	42	1	2	f	248	\N	\N
1071	56	250	2	198	\N	0	\N	\N	43	1	2	f	198	\N	\N
1072	25	250	2	154	\N	0	\N	\N	44	1	2	f	154	\N	\N
1073	54	250	2	102	\N	0	\N	\N	45	1	2	f	102	\N	\N
1074	61	250	2	100	\N	0	\N	\N	46	1	2	f	100	\N	\N
1075	75	250	2	98	\N	0	\N	\N	47	1	2	f	98	\N	\N
1076	9	250	2	30	\N	0	\N	\N	48	1	2	f	30	\N	\N
1077	91	250	2	26	\N	0	\N	\N	49	1	2	f	26	\N	\N
1078	65	250	2	22	\N	0	\N	\N	50	1	2	f	22	\N	\N
1079	5	250	2	8	\N	0	\N	\N	51	1	2	f	8	\N	\N
1080	63	250	2	6	\N	0	\N	\N	52	1	2	f	6	\N	\N
1081	39	250	2	4	\N	0	\N	\N	53	1	2	f	4	\N	\N
1082	72	250	2	2	\N	0	\N	\N	54	1	2	f	2	\N	\N
1083	89	250	2	17870	\N	0	\N	\N	0	1	2	f	17870	\N	\N
1084	16	250	2	5856	\N	0	\N	\N	0	1	2	f	5856	\N	\N
1085	2	251	2	139	\N	0	\N	\N	1	1	2	f	139	\N	\N
1086	73	252	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1087	48	252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1088	76	252	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1089	62	253	2	25556	\N	25556	\N	\N	1	1	2	f	0	\N	\N
1090	58	253	1	25556	\N	25556	\N	\N	1	1	2	f	\N	\N	\N
1091	44	254	2	454	\N	0	\N	\N	1	1	2	f	454	\N	\N
1092	87	255	2	17218	\N	17218	\N	\N	1	1	2	f	0	\N	\N
1093	30	255	2	1920	\N	1920	\N	\N	2	1	2	f	0	\N	\N
1094	28	255	1	32848	\N	32848	\N	\N	1	1	2	f	\N	\N	\N
1095	89	256	2	15575	\N	0	\N	\N	1	1	2	f	15575	\N	\N
1096	32	256	2	12256	\N	0	\N	\N	0	1	2	f	12256	\N	\N
1097	68	257	2	235046	\N	0	\N	\N	1	1	2	f	235046	\N	\N
1098	31	258	2	50124395	\N	0	\N	\N	1	1	2	f	50124395	\N	\N
1099	83	258	2	1052688	\N	0	\N	\N	2	1	2	f	1052688	\N	\N
1100	18	258	2	267144	\N	0	\N	\N	3	1	2	f	267144	\N	\N
1101	68	258	2	235046	\N	0	\N	\N	4	1	2	f	235046	\N	\N
1102	4	258	2	71483	\N	0	\N	\N	5	1	2	f	71483	\N	\N
1103	82	258	2	56617	\N	0	\N	\N	6	1	2	f	56617	\N	\N
1104	22	258	2	33598	\N	0	\N	\N	7	1	2	f	33598	\N	\N
1105	90	258	2	18968	\N	0	\N	\N	8	1	2	f	18968	\N	\N
1106	17	258	2	18802	\N	0	\N	\N	9	1	2	f	18802	\N	\N
1107	44	258	2	538	\N	0	\N	\N	10	1	2	f	538	\N	\N
1108	7	259	2	113	\N	113	\N	\N	1	1	2	f	0	\N	\N
1109	13	259	1	96	\N	96	\N	\N	1	1	2	f	\N	\N	\N
1110	70	259	1	16	\N	16	\N	\N	2	1	2	f	\N	\N	\N
1111	12	259	1	8	\N	8	\N	\N	3	1	2	f	\N	\N	\N
1112	61	259	1	2	\N	2	\N	\N	4	1	2	f	\N	\N	\N
1113	4	264	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
1114	69	267	2	142	\N	142	\N	\N	1	1	2	f	0	\N	\N
1115	7	267	1	142	\N	142	\N	\N	1	1	2	f	\N	\N	\N
1116	52	268	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1117	73	269	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1118	48	269	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1119	76	269	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1120	44	270	2	524	\N	524	\N	\N	1	1	2	f	0	\N	\N
1121	44	270	1	524	\N	524	\N	\N	1	1	2	f	\N	\N	\N
1122	38	271	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1123	8	271	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
1124	74	271	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
1125	40	271	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
1126	49	272	2	114	\N	114	\N	\N	1	1	2	f	0	\N	\N
1127	50	272	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
1128	79	272	1	48	\N	48	\N	\N	2	1	2	f	\N	\N	\N
1129	31	273	2	46886765	\N	46886765	\N	\N	1	1	2	f	0	\N	\N
1130	20	273	2	6134	\N	6134	\N	\N	2	1	2	f	0	\N	\N
1131	56	273	2	198	\N	198	\N	\N	3	1	2	f	0	\N	\N
1132	60	273	1	44430090	\N	44430090	\N	\N	1	1	2	f	\N	\N	\N
1133	31	274	2	50124619	\N	0	\N	\N	1	1	2	f	50124619	\N	\N
1134	83	274	2	1052686	\N	0	\N	\N	2	1	2	f	1052686	\N	\N
1135	18	274	2	267608	\N	0	\N	\N	3	1	2	f	267608	\N	\N
1136	68	274	2	235042	\N	0	\N	\N	4	1	2	f	235042	\N	\N
1137	86	274	2	175749	\N	0	\N	\N	5	1	2	f	175749	\N	\N
1138	29	274	2	113394	\N	0	\N	\N	6	1	2	f	113394	\N	\N
1139	27	274	2	71815	\N	0	\N	\N	7	1	2	f	71815	\N	\N
1140	82	274	2	53646	\N	0	\N	\N	8	1	2	f	53646	\N	\N
1141	1	274	2	40932	\N	0	\N	\N	9	1	2	f	40932	\N	\N
1142	57	274	2	36069	\N	0	\N	\N	10	1	2	f	36069	\N	\N
1143	22	274	2	33598	\N	0	\N	\N	11	1	2	f	33598	\N	\N
1144	84	274	2	13616	\N	0	\N	\N	12	1	2	f	13616	\N	\N
1145	2	274	2	12077	\N	0	\N	\N	13	1	2	f	12077	\N	\N
1146	64	274	2	4731	\N	0	\N	\N	14	1	2	f	4731	\N	\N
1147	67	274	2	4412	\N	0	\N	\N	15	1	2	f	4412	\N	\N
1148	3	274	2	2350	\N	0	\N	\N	16	1	2	f	2350	\N	\N
1149	17	274	2	870	\N	0	\N	\N	17	1	2	f	870	\N	\N
1150	69	274	2	142	\N	0	\N	\N	18	1	2	f	142	\N	\N
1151	36	274	2	26	\N	0	\N	\N	19	1	2	f	26	\N	\N
1152	5	274	2	8	\N	0	\N	\N	20	1	2	f	8	\N	\N
1153	39	274	2	4	\N	0	\N	\N	21	1	2	f	4	\N	\N
1154	10	275	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1155	9	275	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1156	31	276	2	50124395	\N	50124395	\N	\N	1	1	2	f	0	\N	\N
1157	68	276	1	50254795	\N	50254795	\N	\N	1	1	2	f	\N	\N	\N
1158	49	277	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
1159	78	277	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1160	85	278	2	39012	\N	13724	\N	\N	1	1	2	f	25288	\N	\N
1161	70	278	2	16466	\N	4952	\N	\N	2	1	2	f	11514	\N	\N
1162	77	279	2	147	\N	147	\N	\N	1	1	2	f	0	\N	\N
1163	34	279	1	147	\N	147	\N	\N	1	1	2	f	\N	\N	\N
1164	2	280	2	139	\N	0	\N	\N	1	1	2	f	139	\N	\N
1165	22	281	2	35868	\N	35868	\N	\N	1	1	2	f	0	\N	\N
1166	4	282	2	231	\N	231	\N	\N	1	1	2	f	0	\N	\N
1167	42	282	1	230	\N	230	\N	\N	1	1	2	f	\N	\N	\N
1168	58	283	2	588	\N	588	\N	\N	1	1	2	f	0	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://dati.camera.it/ocd/	0	t	0
70	isbd	http://iflastandards.info/ns/isbd/elements/	0	f	0
71	bio	http://purl.org/vocab/bio/0.1/	0	f	0
72	nfo	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#	0	f	0
73	vs	http://www.w3.org/2003/06/sw-vocab-status/ns#	0	f	0
75	lgdo	http://linkedgeodata.org/ontology/	0	f	0
78	skos08	http://www.w3.org/2008/05/skos#	0	f	0
79	ods	http://lod.xdams.org/ontologies/ods/	0	f	0
80	lode	http://linkedevents.org/ontology/	0	f	0
74	oad	http://culturalis.org/oad#	0	f	0
76	cult	http://culturalis.org/cult/0.1#	0	f	0
77	ezc-cpf	http://culturalis.org/eac-cpf#	0	f	0
81	mvoaf	http://labs.mondeca.com/vocab/voaf#	0	f	0
82	uod	http://dati.camera.it/ocd/uod/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_dati_camera_it_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_dati_camera_it_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://dati.camera.it/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://dati.camera.it/sparql", "correlationId": "8752317644423706613", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:28:59.883Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/ns/dcat#downloadURL	147	\N	15	downloadURL	downloadURL	f	147	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://purl.org/dc/elements/1.1/language	25548	\N	6	language	language	f	97	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://purl.org/ontology/bibo/page	5	\N	31	page	page	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://xmlns.com/foaf/0.1/page	15	\N	8	page	page	f	15	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://culturalis.org/oad#scopeAndContent	67420	\N	74	scopeAndContent	scopeAndContent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://dati.camera.it/ocd/rif_sistema_elettorale	28	\N	69	rif_sistema_elettorale	rif_sistema_elettorale	f	28	\N	\N	f	f	61	91	\N	t	f	\N	\N	\N	t	f	f
7	http://purl.org/ontology/bibo/edition	177	\N	31	edition	edition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://www.w3.org/2008/05/skos#editorialNote	1	\N	78	editorialNote	editorialNote	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://purl.org/ontology/bibo/abstract	13	\N	31	abstract	abstract	f	0	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://purl.org/ontology/bibo/pageStart	139	\N	31	pageStart	pageStart	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.w3.org/2008/05/skos#scopeNote	14	\N	78	scopeNote	scopeNote	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#fileName	2	\N	72	fileName	fileName	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://schema.org/dateCreated	20	\N	9	dateCreated	dateCreated	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://dati.camera.it/ocd/rif_componente	1621668	\N	69	rif_componente	rif_componente	f	1621668	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://purl.org/dc/terms/spatial	2036	\N	5	spatial	spatial	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://dati.camera.it/ocd/rif_file	5963	\N	69	rif_file	rif_file	f	5963	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://www.w3.org/2008/05/skos#notation	126	\N	78	notation	notation	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://dati.camera.it/ocd/nomina	78	\N	69	nomina	nomina	f	50	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://www.w3.org/2002/07/owl#equivalentClass	5	\N	7	equivalentClass	equivalentClass	f	5	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://www.w3.org/ns/dcat#dataset	105	\N	15	dataset	dataset	f	105	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://purl.org/dc/elements/1.1/date	1591653	\N	6	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/ns/dcat#keyword	102	\N	15	keyword	keyword	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://www.w3.org/2008/05/skos#prefLabel	16	\N	78	prefLabel	prefLabel	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://purl.org/dc/elements/1.1/description	9144454	\N	6	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://purl.org/ontology/bibo/issue	11955	\N	31	issue	issue	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://purl.org/dc/terms/relation	3505	\N	5	relation	relation	f	3505	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://dati.camera.it/ocd/altro_firmatario	1972370	\N	69	altro_firmatario	altro_firmatario	f	1972370	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://xmlns.com/foaf/0.1/account	1126	\N	8	account	account	f	1110	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://xmlns.com/foaf/0.1/gender	28551	\N	8	gender	gender	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://purl.org/dc/terms/creator	28295	\N	5	creator	creator	f	28295	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://dati.camera.it/ocd/componente	971	\N	69	componente	componente	f	971	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://purl.org/dc/elements/1.1/modified	5	\N	6	modified	modified	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://dati.camera.it/ocd/presiedutaDa	122853	\N	69	presiedutaDa	presiedutaDa	f	122853	\N	\N	f	f	68	85	\N	t	f	\N	\N	\N	t	f	f
39	http://dati.camera.it/ocd/contrari	122853	\N	69	contrari	contrari	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://dati.camera.it/ocd/diventa	22	\N	69	diventa	diventa	f	22	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://dati.camera.it/ocd/parentCountry	120	\N	69	parentCountry	parentCountry	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://dati.camera.it/ocd/griglia	15	\N	69	griglia	griglia	f	15	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://xmlns.com/foaf/0.1/homepage	34	\N	8	homepage	homepage	f	34	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://dati.camera.it/ocd/rif_relazioneAttoCamera	10418	\N	69	rif_relazioneAttoCamera	rif_relazioneAttoCamera	f	10418	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://xmlns.com/foaf/0.1/interest	55	\N	8	interest	interest	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://iflastandards.info/ns/isbd/elements/P1007	6446	\N	70	P1007	P1007	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://dati.camera.it/ocd/tipoProclamazione	1489	\N	69	tipoProclamazione	tipoProclamazione	f	1489	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://lod.xdams.org/ontologies/ods/ha_agenda	3	\N	79	ha_agenda	ha_agenda	f	3	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://iflastandards.info/ns/isbd/elements/P1004	27864	\N	70	P1004	P1004	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://purl.org/ontology/bibo/doi	356	\N	31	doi	doi	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://iflastandards.info/ns/isbd/elements/P1006	8623	\N	70	P1006	P1006	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://dati.camera.it/ocd/primo_firmatario	654118	\N	69	primo_firmatario	primo_firmatario	f	654118	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://dati.camera.it/ocd/rif_richiestaParere	22591	\N	69	rif_richiestaParere	rif_richiestaParere	f	22591	\N	\N	f	f	18	89	\N	t	f	\N	\N	\N	t	f	f
18	http://dati.camera.it/ocd/rif_membroGoverno	56481	\N	69	rif_membroGoverno	rif_membroGoverno	f	56481	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://dati.camera.it/ocd/rif_leg	1407470	\N	69	rif_leg	rif_leg	f	1407470	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://dati.camera.it/ocd/rif_organo	282461	\N	69	rif_organo	rif_organo	f	282461	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://dati.camera.it/ocd/destinatario	547678	\N	69	destinatario	destinatario	f	547678	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://culturalis.org/oad#has_administrativeBiographicalHistory	1	\N	74	has_administrativeBiographicalHistory	has_administrativeBiographicalHistory	f	1	\N	\N	f	f	44	42	\N	t	f	\N	\N	\N	t	f	f
56	http://purl.org/dc/elements/1.1/note	8	\N	6	note	note	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://dati.camera.it/ocd/sessioneLegislatura	339	\N	69	sessioneLegislatura	sessioneLegislatura	f	339	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://dati.camera.it/ocd/endDate	407783	\N	69	endDate	endDate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/ns/dcat#landingPage	104	\N	15	landingPage	landingPage	f	104	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.w3.org/2008/05/skos#definition	102	\N	78	definition	definition	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://lod.xdams.org/ontologies/ods/inevidenza	1	\N	79	inevidenza	inevidenza	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://purl.org/dc/terms/modified	73	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#fileUrl	31	\N	72	fileUrl	fileUrl	f	31	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://iflastandards.info/ns/isbd/elements/P1018	1746	\N	70	P1018	P1018	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	27	\N	2	subPropertyOf	subPropertyOf	f	27	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://www.w3.org/2002/07/owl#sameAs	17850	\N	7	sameAs	sameAs	f	17850	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/vocab/bio/0.1/date	23880	\N	71	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://dati.camera.it/ocd/name	22462	\N	69	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://iflastandards.info/ns/isbd/elements/P1015	78	\N	70	P1015	P1015	f	0	\N	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://iflastandards.info/ns/isbd/elements/P1016	6282	\N	70	P1016	P1016	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://iflastandards.info/ns/isbd/elements/P1017	6283	\N	70	P1017	P1017	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://iflastandards.info/ns/isbd/elements/P1010	13	\N	70	P1010	P1010	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://www.w3.org/2002/07/owl#deprecated	14	\N	7	deprecated	deprecated	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.w3.org/2002/07/owl#allValueFrom	12	\N	7	allValueFrom	allValueFrom	f	12	\N	\N	f	f	49	78	\N	t	f	\N	\N	\N	t	f	f
75	http://dati.camera.it/ocd/rif_attoCameraAbbinato	50110	\N	69	rif_attoCameraAbbinato	rif_attoCameraAbbinato	f	50110	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	1149	\N	1	first	first	f	1149	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
77	http://dati.camera.it/ocd/motivoTermine	90433	\N	69	motivoTermine	motivoTermine	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://iflastandards.info/ns/isbd/elements/P1012	1054	\N	70	P1012	P1012	f	0	\N	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://dati.camera.it/ocd/rif_relatore	37466	\N	69	rif_relatore	rif_relatore	f	37466	\N	\N	f	f	\N	27	\N	t	f	\N	\N	\N	t	f	f
80	http://www.w3.org/2002/07/owl#members	4	\N	7	members	members	f	4	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://dati.camera.it/ocd/favorevoli	122853	\N	69	favorevoli	favorevoli	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://dati.camera.it/ocd/uod/cd3500000085	1	\N	82	cd3500000085	cd3500000085	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://culturalis.org/oad#hasLevel	74831	\N	74	hasLevel	hasLevel	f	74831	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://purl.org/dc/terms/format	5826	\N	5	format	format	f	5826	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://culturalis.org/oad#hasNextInSequence	72373	\N	74	hasNextInSequence	hasNextInSequence	f	72373	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://dati.camera.it/ocd/carica	12457	\N	69	carica	carica	f	0	\N	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://purl.org/dc/terms/provenance	55791	\N	5	provenance	provenance	f	25230	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://dati.camera.it/ocd/opzione	285	\N	69	opzione	opzione	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://purl.org/dc/terms/references	32	\N	5	references	references	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://dati.camera.it/ocd/attoPortante	3434	\N	69	attoPortante	attoPortante	f	3434	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://purl.org/dc/terms/extent	4792	\N	5	extent	extent	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://www.w3.org/2000/01/rdf-schema#label	27860226	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://dati.camera.it/ocd/ruolo	133308	\N	69	ruolo	ruolo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://dati.camera.it/ocd/votazioneFinale	122853	\N	69	votazioneFinale	votazioneFinale	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://purl.org/dc/elements/1.1/title	27714894	\N	6	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://purl.org/dc/elements/1.1/isReferencedBy	1	\N	6	isReferencedBy	isReferencedBy	f	1	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://purl.org/dc/terms/available	5078	\N	5	available	available	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://purl.org/dc/elements/1.1/relation	1749625	\N	6	relation	relation	f	1133351	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://purl.org/dc/elements/1.1/license	110	\N	6	license	license	f	110	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	7943	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#fileSize	5026	\N	72	fileSize	fileSize	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://www.w3.org/2003/01/geo/wgs84_pos#long	10	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://purl.org/dc/terms/keyword	20	\N	5	keyword	keyword	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://purl.org/vocab/bio/0.1/Death	7685	\N	71	Death	Death	f	7685	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://dati.camera.it/ocd/iniziativa	119856	\N	69	iniziativa	iniziativa	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://dati.camera.it/ocd/membroGoverno	5472	\N	69	membroGoverno	membroGoverno	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://schema.org/isPartOf	138	\N	9	isPartOf	isPartOf	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://culturalis.org/cult/0.1#isIncludedIn	143	\N	76	isIncludedIn	isIncludedIn	f	143	\N	\N	f	f	7	11	\N	t	f	\N	\N	\N	t	f	f
114	http://dati.camera.it/ocd/dicastero	2513	\N	69	dicastero	dicastero	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://www.w3.org/ns/dcat#accessURL	103	\N	15	accessURL	accessURL	f	103	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://culturalis.org/oad#isDescriberBy	21	\N	74	isDescriberBy	isDescriberBy	f	21	\N	\N	f	f	7	43	\N	t	f	\N	\N	\N	t	f	f
117	http://dati.camera.it/ocd/siglaGruppo	25215454	\N	69	siglaGruppo	siglaGruppo	f	0	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://lod.xdams.org/ontologies/ods/deleted	4900	\N	79	deleted	deleted	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#remoteDataObject	5826	\N	72	remoteDataObject	remoteDataObject	f	5826	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://dati.camera.it/ocd/rif_attoSenato	544	\N	69	rif_attoSenato	rif_attoSenato	f	544	\N	\N	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://dati.camera.it/ocd/sede	22280	\N	69	sede	sede	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://dati.camera.it/ocd/startDate	523286	\N	69	startDate	startDate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://www.w3.org/2008/05/skos#inScheme	123	\N	78	inScheme	inScheme	f	123	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://lod.xdams.org/ontologies/ods/keywords	107	\N	79	keywords	keywords	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://purl.org/dc/elements/1.1/subject	376609	\N	6	subject	subject	f	9328	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://purl.org/dc/elements/1.1/rightsHolder	97	\N	6	rightsHolder	rightsHolder	f	97	\N	\N	f	f	77	39	\N	t	f	\N	\N	\N	t	f	f
129	http://dati.camera.it/ocd/maggioranza	122853	\N	69	maggioranza	maggioranza	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://purl.org/ontology/bibo/volume	11521	\N	31	volume	volume	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://dati.camera.it/ocd/haMembro	47013	\N	69	haMembro	haMembro	f	47013	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://purl.org/dc/terms/bibliographicCitation	31810	\N	5	bibliographicCitation	bibliographicCitation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://xmlns.com/foaf/0.1/nickname	21420	\N	8	nickname	nickname	f	21420	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://www.w3.org/2000/01/rdf-schema#comment	272	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://www.w3.org/2004/02/skos/core#historyNote	29	\N	4	historyNote	historyNote	f	29	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://dati.camera.it/ocd/votanti	122853	\N	69	votanti	votanti	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://dati.camera.it/ocd/tipoTesto	3430	\N	69	tipoTesto	tipoTesto	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://culturalis.org/oad#isEntryOf	164	\N	74	isEntryOf	isEntryOf	f	164	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://www.w3.org/2003/06/sw-vocab-status/ns#term_status	75	\N	73	term_status	term_status	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://dati.camera.it/ocd/aderisce	14888	\N	69	aderisce	aderisce	f	14888	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://www.w3.org/2008/05/skos#historyNote	14	\N	78	historyNote	historyNote	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://www.w3.org/2000/01/rdf-schema#domain	379	\N	2	domain	domain	f	379	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://dati.camera.it/ocd/membroConsulta	405	\N	69	membroConsulta	membroConsulta	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://purl.org/dc/terms/alternative	451	\N	5	alternative	alternative	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://culturalis.org/cult/0.1#maintains	2	\N	76	maintains	maintains	f	2	\N	\N	f	f	41	11	\N	t	f	\N	\N	\N	t	f	f
150	http://purl.org/dc/terms/contributor	3843	\N	5	contributor	contributor	f	3843	\N	\N	f	f	\N	55	\N	t	f	\N	\N	\N	t	f	f
151	http://dati.camera.it/ocd/assegnatario	667	\N	69	assegnatario	assegnatario	f	667	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://purl.org/dc/elements/1.1/contributor	2053038	\N	6	contributor	contributor	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://xmlns.com/foaf/0.1/accountName	1045	\N	8	accountName	accountName	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://dati.camera.it/ocd/ramo	237875	\N	69	ramo	ramo	f	0	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://www.w3.org/2008/05/skos#broader	123	\N	78	broader	broader	f	123	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://dati.camera.it/ocd/rif_allegatoDiscussione	25336	\N	69	rif_allegatoDiscussione	rif_allegatoDiscussione	f	25336	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://dati.camera.it/ocd/rif_discussione	385775	\N	69	rif_discussione	rif_discussione	f	385775	\N	\N	f	f	86	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://dati.camera.it/ocd/rif_mandatoCamera	57203	\N	69	rif_mandatoCamera	rif_mandatoCamera	f	57203	\N	\N	f	f	\N	62	\N	t	f	\N	\N	\N	t	f	f
125	http://dati.camera.it/ocd/rif_delegato	110826	\N	69	rif_delegato	rif_delegato	f	110826	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://dati.camera.it/ocd/rif_intervento	463215	\N	69	rif_intervento	rif_intervento	f	463215	\N	\N	f	f	\N	21	\N	t	f	\N	\N	\N	t	f	f
131	http://dati.camera.it/ocd/rif_seduta	597421	\N	69	rif_seduta	rif_seduta	f	597421	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://dati.camera.it/ocd/rif_dibattito	127419	\N	69	rif_dibattito	rif_dibattito	f	127419	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://dati.camera.it/ocd/rif_incarico	5633	\N	69	rif_incarico	rif_incarico	f	5633	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://dati.camera.it/ocd/siComponeDi	45357	\N	69	siComponeDi	siComponeDi	f	45357	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://dati.camera.it/ocd/interim	5472	\N	69	interim	interim	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://dati.camera.it/ocd/diConcertoCon	1748	\N	69	diConcertoCon	diConcertoCon	f	1748	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.w3.org/2002/07/owl#inverseOf	8	\N	7	inverseOf	inverseOf	f	8	\N	\N	f	f	47	47	\N	t	f	\N	\N	\N	t	f	f
163	http://purl.org/dc/terms/isPartOf	124051	\N	5	isPartOf	isPartOf	f	96053	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	1149	\N	1	rest	rest	f	1149	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://purl.org/dc/elements/1.1/accrualPeriodicity	97	\N	6	accrualPeriodicity	accrualPeriodicity	f	97	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://dati.camera.it/ocd/lex	17645	\N	69	lex	lex	f	17645	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://xmlns.com/foaf/0.1/surname	56116	\N	8	surname	surname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://xmlns.com/foaf/0.1/firstName	56105	\N	8	firstName	firstName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://culturalis.org/oad#isContainedIn	75369	\N	74	isContainedIn	isContainedIn	f	75369	\N	\N	f	f	\N	43	\N	t	f	\N	\N	\N	t	f	f
171	http://dati.camera.it/ocd/membro	37813	\N	69	membro	membro	f	37813	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	250	\N	2	isDefinedBy	isDefinedBy	f	250	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://purl.org/dc/elements/1.1/rights	1	\N	6	rights	rights	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://www.w3.org/ns/dcat#language	7	\N	15	language	language	f	7	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://www.w3.org/2002/07/owl#someValuesFrom	39	\N	7	someValuesFrom	someValuesFrom	f	39	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://www.w3.org/2002/07/owl#disjointWith	8	\N	7	disjointWith	disjointWith	f	8	\N	\N	f	f	78	78	\N	t	f	\N	\N	\N	t	f	f
178	http://dati.camera.it/ocd/dataAssegnazione	9398	\N	69	dataAssegnazione	dataAssegnazione	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://xmlns.com/foaf/0.1/nick	2	\N	8	nick	nick	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://www.w3.org/2002/07/owl#unionOf	221	\N	7	unionOf	unionOf	f	221	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://dati.camera.it/ocd/richiestaFiducia	122853	\N	69	richiestaFiducia	richiestaFiducia	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://www.w3.org/2002/07/owl#versionInfo	142	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://purl.org/vocab/bio/0.1/Birth	13543	\N	71	Birth	Birth	f	13543	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://dati.camera.it/ocd/rif_aic	47690	\N	69	rif_aic	rif_aic	f	47690	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
186	http://www.w3.org/2008/05/skos#changeNote	642	\N	78	changeNote	changeNote	f	642	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://dati.camera.it/ocd/astenuti	122853	\N	69	astenuti	astenuti	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://purl.org/dc/terms/audience	3230	\N	5	audience	audience	f	3230	\N	\N	f	f	\N	64	\N	t	f	\N	\N	\N	t	f	f
189	http://xmlns.com/foaf/0.1/accountServiceHomepage	1075	\N	8	accountServiceHomepage	accountServiceHomepage	f	1070	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://dati.camera.it/ocd/stralciatoIn	22	\N	69	stralciatoIn	stralciatoIn	f	22	\N	\N	f	f	18	18	\N	t	f	\N	\N	\N	t	f	f
191	http://dati.camera.it/ocd/presenti	122853	\N	69	presenti	presenti	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://dati.camera.it/ocd/convalida	11127	\N	69	convalida	convalida	f	0	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://creativecommons.org/ns#licence	1	\N	23	licence	licence	f	1	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://xmlns.com/foaf/0.1/mail	1	\N	8	mail	mail	f	1	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://purl.org/dc/terms/isReferencedBy	912645	\N	5	isReferencedBy	isReferencedBy	f	746668	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://lod.xdams.org/ontologies/ods/ocr	2	\N	79	ocr	ocr	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://dati.camera.it/ocd/lista	3747	\N	69	lista	lista	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://dati.camera.it/ocd/incaricoGovernativo	2094	\N	69	incaricoGovernativo	incaricoGovernativo	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://dati.camera.it/ocd/denominazione	103	\N	69	denominazione	denominazione	f	103	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://purl.org/dc/elements/1.1/coverage	73117	\N	6	coverage	coverage	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://purl.org/dc/elements/1.1/creator	679304	\N	6	creator	creator	f	104	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://schema.org/license	20	\N	9	license	license	f	20	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://purl.org/dc/terms/issued	29970	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://culturalis.org/oad#has_level	539	\N	74	has_level	has_level	f	539	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://purl.org/dc/terms/rights	1	\N	5	rights	rights	f	1	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://dati.camera.it/ocd/rif_versioneTestoAtto	13836	\N	69	rif_versioneTestoAtto	rif_versioneTestoAtto	f	13836	\N	\N	f	f	18	92	\N	t	f	\N	\N	\N	t	f	f
159	http://dati.camera.it/ocd/rif_statoIter	32201	\N	69	rif_statoIter	rif_statoIter	f	32201	\N	\N	f	f	18	29	\N	t	f	\N	\N	\N	t	f	f
162	http://dati.camera.it/ocd/rif_natura	16433	\N	69	rif_natura	rif_natura	f	16433	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://dati.camera.it/ocd/rif_organoGoverno	39360	\N	69	rif_organoGoverno	rif_organoGoverno	f	39360	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://dati.camera.it/ocd/rif_doc	12224	\N	69	rif_doc	rif_doc	f	12224	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://dati.camera.it/ocd/rif_luogo	8401	\N	69	rif_luogo	rif_luogo	f	8401	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://culturalis.org/oad#AdministrativeBiographicalHistory	5	\N	74	AdministrativeBiographicalHistory	AdministrativeBiographicalHistory	f	5	\N	\N	f	f	4	42	\N	t	f	\N	\N	\N	t	f	f
210	http://iflastandards.info/ns/isbd/elements/P1026	1766	\N	70	P1026	P1026	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://lod.xdams.org/ontologies/ods/fileMetadata	2	\N	79	fileMetadata	fileMetadata	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://www.w3.org/2008/05/skos#note	11070	\N	78	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://purl.org/ontology/bibo/issn	74	\N	31	issn	issn	f	0	\N	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://culturalis.org/eac-cpf#named	104	\N	77	named	named	f	104	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://purl.org/dc/terms/accessRights	5833	\N	5	accessRights	accessRights	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://dati.camera.it/ocd/votazioneSegreta	122853	\N	69	votazioneSegreta	votazioneSegreta	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://www.w3.org/2000/01/rdf-schema#subClassOf	160	\N	2	subClassOf	subClassOf	f	160	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://purl.org/dc/terms/subject	434716	\N	5	subject	subject	f	434716	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://dati.camera.it/ocd/tipoElezione	12778	\N	69	tipoElezione	tipoElezione	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://dati.camera.it/ocd/parentADM1	11850	\N	69	parentADM1	parentADM1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://dati.camera.it/ocd/parentADM2	2233	\N	69	parentADM2	parentADM2	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#hashValue	5026	\N	72	hashValue	hashValue	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://dati.camera.it/ocd/parentADM3	2372	\N	69	parentADM3	parentADM3	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://purl.org/ontology/bibo/pages	20108	\N	31	pages	pages	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://www.w3.org/2000/01/rdf-schema#range	262	\N	2	range	range	f	262	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://purl.org/dc/elements/1.1/publisher	23199	\N	6	publisher	publisher	f	104	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://www.w3.org/2002/07/owl#equivalentProperty	6	\N	7	equivalentProperty	equivalentProperty	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://schema.org/bookFormat	359	\N	9	bookFormat	bookFormat	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://purl.org/dc/elements/1.1/format	67418	\N	6	format	format	f	147	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://purl.org/dc/terms/isReplacedBy	14	\N	5	isReplacedBy	isReplacedBy	f	14	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://purl.org/dc/terms/publisher	1	\N	5	publisher	publisher	f	1	\N	\N	f	f	52	39	\N	t	f	\N	\N	\N	t	f	f
237	http://iflastandards.info/ns/isbd/elements/P1031	1615	\N	70	P1031	P1031	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://dati.camera.it/ocd/risposta	153969	\N	69	risposta	risposta	f	153969	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://dati.camera.it/ocd/concluso	526344	\N	69	concluso	concluso	f	0	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.org/dc/elements/1.1/issued	1	\N	6	issued	issued	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://purl.org/ontology/bibo/isbn	490	\N	31	isbn	isbn	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://www.w3.org/ns/org#unitOf	16	\N	37	unitOf	unitOf	f	16	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://dati.camera.it/ocd/eurovoc	27	\N	69	eurovoc	eurovoc	f	27	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://www.w3.org/2000/01/rdf-schema#seeAlso	21	\N	2	seeAlso	seeAlso	f	21	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://purl.org/vocab/bio/0.1/place	10963	\N	71	place	place	f	10802	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://lod.xdams.org/ontologies/ods/modified	26892333	\N	79	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://schema.org/version	139	\N	9	version	version	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://www.w3.org/2002/07/owl#imports	1	\N	7	imports	imports	f	1	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://culturalis.org/oad#extentAndMedium	454	\N	74	extentAndMedium	extentAndMedium	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://dati.camera.it/ocd/esito	9277	\N	69	esito	esito	f	0	\N	\N	f	f	89	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://dati.camera.it/ocd/approvato	122853	\N	69	approvato	approvato	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://purl.org/dc/elements/1.1/identifier	26122171	\N	6	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://dati.camera.it/ocd/rif_firmaAIC	812156	\N	69	rif_firmaAIC	rif_firmaAIC	f	812156	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://dati.camera.it/ocd/rif_mandatoSenato	17597	\N	69	rif_mandatoSenato	rif_mandatoSenato	f	17597	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://dati.camera.it/ocd/rif_attoCamera	345214	\N	69	rif_attoCamera	rif_attoCamera	f	345214	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://dati.camera.it/ocd/rif_bollettino	56887	\N	69	rif_bollettino	rif_bollettino	f	56887	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://dati.camera.it/ocd/rif_deputato	26271342	\N	69	rif_deputato	rif_deputato	f	26271342	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://dati.camera.it/ocd/rif_assemblea	421913	\N	69	rif_assemblea	rif_assemblea	f	421913	\N	\N	f	f	\N	54	\N	t	f	\N	\N	\N	t	f	f
242	http://dati.camera.it/ocd/rif_presidenteConsiglioMinistri	294	\N	69	rif_presidenteConsiglioMinistri	rif_presidenteConsiglioMinistri	f	294	\N	\N	f	f	\N	26	\N	t	f	\N	\N	\N	t	f	f
248	http://dati.camera.it/ocd/rif_governo	36182	\N	69	rif_governo	rif_governo	f	36182	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://dati.camera.it/ocd/rif_elezione	12778	\N	69	rif_elezione	rif_elezione	f	12778	\N	\N	f	f	62	58	\N	t	f	\N	\N	\N	t	f	f
255	http://dati.camera.it/ocd/rif_senatore	16425	\N	69	rif_senatore	rif_senatore	f	16425	\N	\N	f	f	\N	28	\N	t	f	\N	\N	\N	t	f	f
259	http://culturalis.org/oad#isProducedBy	113	\N	74	isProducedBy	isProducedBy	f	113	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
261	http://purl.org/dc/terms/isReferenceBy	8085	\N	5	isReferenceBy	isReferenceBy	f	8085	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://xmlns.com/foaf/0.1/primaryTopic	21	\N	8	primaryTopic	primaryTopic	f	21	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	74	\N	1	_1	_1	f	74	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://linkedevents.org/ontology/involved	142	\N	80	involved	involved	f	142	\N	\N	f	f	69	7	\N	t	f	\N	\N	\N	t	f	f
268	http://purl.org/dc/terms/license	1	\N	5	license	license	f	1	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://purl.org/vocab/vann/preferredNamespacePrefix	1	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://culturalis.org/oad#has_nextInSequence	524	\N	74	has_nextInSequence	has_nextInSequence	f	524	\N	\N	f	f	44	44	\N	t	f	\N	\N	\N	t	f	f
271	http://www.w3.org/2003/01/geo/wgs84_pos#lat	10	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://www.w3.org/2002/07/owl#onProperty	114	\N	7	onProperty	onProperty	f	114	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://purl.org/dc/elements/1.1/type	26419524	\N	6	type	type	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://lod.xdams.org/ontologies/ods/twittedBy	3	\N	79	twittedBy	twittedBy	f	3	\N	\N	f	f	10	9	\N	t	f	\N	\N	\N	t	f	f
277	http://www.w3.org/2002/07/owl#allValuesFrom	42	\N	7	allValuesFrom	allValuesFrom	f	42	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://xmlns.com/foaf/0.1/depiction	27753	\N	8	depiction	depiction	f	9352	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://www.w3.org/ns/dcat#distribution	147	\N	15	distribution	distribution	f	147	\N	\N	f	f	77	34	\N	t	f	\N	\N	\N	t	f	f
280	http://lod.xdams.org/ontologies/ods/catenaVirtuale	139	\N	79	catenaVirtuale	catenaVirtuale	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://dati.camera.it/ocd/lavoriPreparatori	17934	\N	69	lavoriPreparatori	lavoriPreparatori	f	17934	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://culturalis.org/oad#hasAdministrativeBiographicalHistory	231	\N	74	hasAdministrativeBiographicalHistory	hasAdministrativeBiographicalHistory	f	231	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://dati.camera.it/ocd/plurieletto	294	\N	69	plurieletto	plurieletto	f	294	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	54979743	\N	1	type	type	f	54979743	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
4	http://dati.camera.it/ocd/rif_ufficioParlamentare	21042	\N	69	rif_ufficioParlamentare	rif_ufficioParlamentare	f	21042	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://dati.camera.it/ocd/rif_persona	97832	\N	69	rif_persona	rif_persona	f	97832	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://dati.camera.it/ocd/rif_assegnazione	50582	\N	69	rif_assegnazione	rif_assegnazione	f	50582	\N	\N	f	f	\N	17	\N	t	f	\N	\N	\N	t	f	f
110	http://dati.camera.it/ocd/rif_abbinamento	29140	\N	69	rif_abbinamento	rif_abbinamento	f	29140	\N	\N	f	f	18	16	\N	t	f	\N	\N	\N	t	f	f
149	http://dati.camera.it/ocd/rif_sessione	10725	\N	69	rif_sessione	rif_sessione	f	10725	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://dati.camera.it/ocd/rif_unitaOrganizzativa	26	\N	69	rif_unitaOrganizzativa	rif_unitaOrganizzativa	f	26	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://dati.camera.it/ocd/rif_sistemaElettorale	12828	\N	69	rif_sistemaElettorale	rif_sistemaElettorale	f	12800	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://dati.camera.it/ocd/rif_trasmissione	1730	\N	69	rif_trasmissione	rif_trasmissione	f	1730	\N	\N	f	f	18	67	\N	t	f	\N	\N	\N	t	f	f
273	http://dati.camera.it/ocd/rif_gruppoParlamentare	23612916	\N	69	rif_gruppoParlamentare	rif_gruppoParlamentare	f	23612916	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://dati.camera.it/ocd/rif_votazione	25215610	\N	69	rif_votazione	rif_votazione	f	25215610	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_dati_camera_it_sparql; Owner: -
--

COPY http_dati_camera_it_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	4	8	riferimento ufficio parlamentare	\N
2	4	8	riferimento ufficio parlamentare	\N
3	5	8	page	\N
4	17	8	riferimento alla richesta dei pareri su un atto camera	\N
5	17	8	\nriferimento alla richesta dei pareri su un atto camera\n	\N
6	18	8	riferimento al membro di Governo	\N
7	18	8	riferimento al membro di Governo	\N
8	20	8	nomina	\N
9	20	8	nomina	\N
10	22	8	riferimento alla legislatura	\N
11	22	8	riferimento alla legislatura	\N
12	28	8	riferimento a persona	\N
13	28	8	riferimento a persona	\N
14	32	8	altro firmatario	\N
15	32	8	altro firmatario	\N
16	33	8	account	\N
17	34	8	gender	\N
18	36	8	componente	\N
19	36	8	componente	\N
20	39	8	voti contrari	\N
21	39	8	voti contrari	\N
22	40	8	diventa	\N
23	40	8	diventa	\N
24	41	8	parentCountry	\N
25	41	8	parentCountry	\N
26	42	8	griglia	\N
27	42	8	griglia	\N
28	43	8	homepage	\N
29	45	8	interest	\N
30	47	8	tipologia proclamazione	\N
31	47	8	tipologia proclamazione	\N
32	52	8	riferimento all'organo	\N
33	52	8	riferimento all'organo	\N
34	53	8	primo firmatario	\N
35	53	8	primo firmatario	\N
36	54	8	componente	\N
37	54	8	componente	\N
38	57	8	sessione legislatura	\N
39	57	8	sessione legislatura	\N
40	58	8	data fine	\N
41	58	8	data fine	\N
42	68	8	nome del luogo	\N
43	68	8	nome del luogo	\N
44	77	8	motivo termine mandato	\N
45	77	8	motivo termine mandato	\N
46	81	8	voti favorevoli	\N
47	81	8	voti favorevoli	\N
48	82	8	riferimento all'assegnazione dell'atto camera	\N
49	82	8	riferimento all'assegnazione dell'atto camera	\N
50	83	8	Discorso tenuto a Napoli per le elezioni amministrative	\N
51	87	8	dicastero	\N
52	87	8	dicastero	\N
53	89	8	data di opzione	\N
54	89	8	data di opzione	\N
55	91	8	atto portante	\N
56	91	8	atto portante	\N
57	94	8	ruolo	\N
58	94	8	ruolo	\N
59	95	8	votazione finale	\N
60	95	8	votazione finale	\N
61	106	8	riferimento all'allegato di una discussione	\N
62	106	8	riferimento all'allegato di una discussione	\N
63	107	8	riferimento alla discussione	\N
64	107	8	riferimento alla discussione	\N
65	108	8	iniziativa	\N
66	108	8	iniziativa	\N
67	109	8	riferimento a mandato camera	\N
68	109	8	riferimento a mandato camera	\N
69	110	8	riferimento all'abbinamento dell'atto camera con altri atti	\N
70	110	8	\nriferimento all'abbinamento dell'atto camera con altri atti\n	\N
71	111	8	membro di Governo	\N
72	111	8	membro di Governo	\N
73	114	8	dicastero	\N
74	114	8	dicastero	\N
75	122	8	data inizio	\N
76	122	8	data inizio	\N
77	125	8	riferimento al delegato a rispondere	it
78	128	8	riferimento all'intervento del deputato o del membro di governo in una discussione	\N
79	128	8	\nriferimento all'intervento del deputato o del membro di governo in una discussione\n	\N
80	129	8	numero maggioranza	\N
81	129	8	numero maggioranza	\N
82	131	8	riferimento alla seduta	\N
83	131	8	riferimento alla seduta	\N
84	132	8	ha membro	\N
85	132	8	ha membro	\N
86	135	8	riferimento al dibattito	\N
87	135	8	riferimento al dibattito	\N
88	138	8	numero votanti	\N
89	138	8	numero votanti	\N
90	139	8	tipo testo	\N
91	139	8	tipo testo	\N
92	142	8	aderisce	\N
93	142	8	aderisce	\N
94	145	8	membro	\N
95	145	8	membro	\N
96	146	8	riferimento all'incarico	\N
97	146	8	riferimento all'incarico	\N
98	149	8	atto portante	\N
99	149	8	riferimento alla sessione	\N
100	153	8	account name	\N
101	154	8	ramo	it
102	156	8	riferimento alla versione del testo dell'atto camera	\N
103	156	8	\nriferimento alla versione del testo dell'atto camera\n	\N
104	157	8	si compone di	\N
105	157	8	si compone di	\N
106	158	8	interim	\N
107	158	8	interim	\N
108	159	8	riferimento allo stato iter di un atto camera	\N
109	159	8	riferimento allo stato iter di un atto camera	\N
110	162	8	riferimento alla natura dell'atto camera	\N
111	162	8	riferimento alla natura dell'atto camera	\N
112	165	8	riferimento all'organo di governo	\N
113	165	8	riferimento all'organo di governo	\N
114	167	8	legge	\N
115	167	8	legge	\N
116	168	8	Surname	\N
117	169	8	firstName	\N
118	171	8	membro	\N
119	171	8	membro	\N
120	174	8	unità organizzativa	\N
121	174	8	unità organizzativa	\N
122	179	8	nickname	\N
123	181	8	richiesta della fiducia	\N
124	181	8	richiesta della fiducia	\N
125	185	8	riferimento al doc	\N
126	185	8	riferimento al doc	\N
127	187	8	numero astenuti	\N
128	187	8	numero astenuti	\N
129	189	8	account service homepage	\N
130	190	8	stralciato in	\N
131	190	8	stralciato in	\N
132	191	8	numero presenti	\N
133	191	8	numero presenti	\N
134	192	8	data di convalida	\N
135	192	8	data di convalida	\N
136	197	8	lista	\N
137	197	8	lista	\N
138	198	8	incarico governativo	\N
139	198	8	incarico governativo	\N
140	199	8	riferimento al luogo	\N
141	199	8	riferimento al luogo	\N
142	200	8	denominazione	\N
143	200	8	denominazione	\N
144	208	8	riferimento al sistema elettorale	\N
145	208	8	riferimento al sistema elettorale	\N
146	209	8	riferimento alla firma dell'AIC	\N
147	211	8	riferimento a mandato senato	\N
148	211	8	riferimento a mandato senato	\N
149	215	8	riferimento all'atto camera	\N
150	215	8	riferimento all'atto camera	\N
151	218	8	votazione segreta	\N
152	218	8	votazione segreta	\N
153	221	8	tipo di elezione	\N
154	221	8	tipo di elezione	\N
155	222	8	ADM1	\N
156	222	8	ADM1	\N
157	223	8	ADM2	\N
158	223	8	ADM2	\N
159	225	8	ADM3	\N
160	225	8	ADM3	\N
161	227	8	riferimento al bollettino	\N
162	227	8	riferimento al bollettino	\N
163	229	8	rierimento a deputato	\N
164	229	8	rierimento a deputato	\N
165	233	8	riferimento alla trasmissione di un atto camera all'altro ramo del parlamento	\N
166	233	8	\nriferimento alla trasmissione di un atto camera all'altro ramo del parlamento\n	\N
167	238	8	riferimento alla risposta scritta all'interrogazione	\N
168	238	8	\nriferimento alla risposta scritta all'interrogazione\n	\N
169	239	8	riferimento all'assemblea	\N
170	240	8	costituzionale	\N
171	240	8	costituzionale	\N
172	242	8	rierimento al Presidente del Consiglio dei ministri	\N
173	242	8	\nrierimento al Presidente del Consiglio dei ministri\n	\N
174	248	8	riferimento al governo	\N
175	248	8	riferimento al governo	\N
176	253	8	riferimento all'elezione	\N
177	253	8	riferimento all'elezione	\N
178	255	8	riferimento al senatore	\N
179	255	8	riferimento al senatore	\N
180	257	8	approvato	\N
181	257	8	approvato	\N
182	264	8	primary topic	\N
183	273	8	riferimento al Gruppo parlamentare	\N
184	273	8	riferimento al Gruppo parlamentare	\N
185	276	8	riferimento alla votazione	\N
186	276	8	riferimento alla votazione	\N
187	278	8	depiction	\N
188	281	8	lavori preparatori	\N
189	281	8	lavori preparatori	\N
190	283	8	plurieletto	\N
191	283	8	plurieletto	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cc_rels_id_seq', 7, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.class_annots_id_seq', 92, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.classes_id_seq', 92, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cp_rels_id_seq', 1168, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.ns_id_seq', 82, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.properties_id_seq', 283, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_dati_camera_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_camera_it_sparql.property_annots_id_seq', 191, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_dati_camera_it_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_dati_camera_it_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_dati_camera_it_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_dati_camera_it_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_dati_camera_it_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_dati_camera_it_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_dati_camera_it_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_dati_camera_it_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_dati_camera_it_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_dati_camera_it_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_dati_camera_it_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_dati_camera_it_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_dati_camera_it_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_dati_camera_it_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_dati_camera_it_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_dati_camera_it_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_dati_camera_it_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_dati_camera_it_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_dati_camera_it_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_dati_camera_it_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_dati_camera_it_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_dati_camera_it_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_dati_camera_it_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_dati_camera_it_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_dati_camera_it_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_dati_camera_it_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_dati_camera_it_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_dati_camera_it_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_dati_camera_it_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_dati_camera_it_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_dati_camera_it_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_dati_camera_it_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_dati_camera_it_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_dati_camera_it_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_dati_camera_it_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_dati_camera_it_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_dati_camera_it_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_dati_camera_it_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_dati_camera_it_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_dati_camera_it_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_camera_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_camera_it_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_camera_it_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_camera_it_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_camera_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_camera_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_camera_it_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_dati_camera_it_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_dati_camera_it_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_camera_it_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_camera_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_dati_camera_it_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_camera_it_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_camera_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_dati_camera_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_dati_camera_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_camera_it_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_camera_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_dati_camera_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_camera_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_dati_camera_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_camera_it_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_camera_it_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

