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
-- Name: http_cr_eionet_europa_eu; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_cr_eionet_europa_eu;


--
-- Name: SCHEMA http_cr_eionet_europa_eu; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_cr_eionet_europa_eu IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE FUNCTION http_cr_eionet_europa_eu.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE FUNCTION http_cr_eionet_europa_eu.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_cr_eionet_europa_eu; Owner: -
--

COMMENT ON TABLE http_cr_eionet_europa_eu._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_cr_eionet_europa_eu; Owner: -
--

COMMENT ON COLUMN http_cr_eionet_europa_eu.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_cr_eionet_europa_eu.classes c1
     JOIN http_cr_eionet_europa_eu.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_cr_eionet_europa_eu.properties p ON ((cp1.property_id = p.id)))
     JOIN http_cr_eionet_europa_eu.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_cr_eionet_europa_eu.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE TABLE http_cr_eionet_europa_eu.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE http_cr_eionet_europa_eu.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_cr_eionet_europa_eu.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_cc_rels AS
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
   FROM http_cr_eionet_europa_eu.cc_rels r,
    http_cr_eionet_europa_eu.classes c1,
    http_cr_eionet_europa_eu.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_classes_ns AS
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
    http_cr_eionet_europa_eu.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_cr_eionet_europa_eu.classes c
     LEFT JOIN http_cr_eionet_europa_eu.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_classes_ns_main AS
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
   FROM http_cr_eionet_europa_eu.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_cr_eionet_europa_eu.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_classes_ns_plus AS
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
    http_cr_eionet_europa_eu.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_cr_eionet_europa_eu.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_cr_eionet_europa_eu.classes c
     LEFT JOIN http_cr_eionet_europa_eu.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_classes_ns_main_plus AS
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
   FROM http_cr_eionet_europa_eu.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_cr_eionet_europa_eu.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_classes_ns_main_v01 AS
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
   FROM (http_cr_eionet_europa_eu.v_classes_ns v
     LEFT JOIN http_cr_eionet_europa_eu.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_cp_rels AS
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
    http_cr_eionet_europa_eu.tapprox((r.cnt)::integer) AS cnt_x,
    http_cr_eionet_europa_eu.tapprox(r.object_cnt) AS object_cnt_x,
    http_cr_eionet_europa_eu.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_cr_eionet_europa_eu.cp_rels r,
    http_cr_eionet_europa_eu.classes c,
    http_cr_eionet_europa_eu.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_cp_rels_card AS
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
   FROM http_cr_eionet_europa_eu.cp_rels r,
    http_cr_eionet_europa_eu.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_properties_ns AS
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
    http_cr_eionet_europa_eu.tapprox(p.cnt) AS cnt_x,
    http_cr_eionet_europa_eu.tapprox(p.object_cnt) AS object_cnt_x,
    http_cr_eionet_europa_eu.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_cr_eionet_europa_eu.properties p
     LEFT JOIN http_cr_eionet_europa_eu.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_cp_sources_single AS
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
   FROM ((http_cr_eionet_europa_eu.v_cp_rels_card r
     JOIN http_cr_eionet_europa_eu.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_cr_eionet_europa_eu.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_cp_targets_single AS
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
   FROM ((http_cr_eionet_europa_eu.v_cp_rels_card r
     JOIN http_cr_eionet_europa_eu.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_cr_eionet_europa_eu.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_cr_eionet_europa_eu.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_cr_eionet_europa_eu.pp_rels r,
    http_cr_eionet_europa_eu.properties p1,
    http_cr_eionet_europa_eu.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_properties_sources AS
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
   FROM (http_cr_eionet_europa_eu.v_properties_ns v
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
           FROM http_cr_eionet_europa_eu.cp_rels r,
            http_cr_eionet_europa_eu.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_properties_sources_single AS
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
   FROM (http_cr_eionet_europa_eu.v_properties_ns v
     LEFT JOIN http_cr_eionet_europa_eu.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_properties_targets AS
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
   FROM (http_cr_eionet_europa_eu.v_properties_ns v
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
           FROM http_cr_eionet_europa_eu.cp_rels r,
            http_cr_eionet_europa_eu.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE VIEW http_cr_eionet_europa_eu.v_properties_targets_single AS
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
   FROM (http_cr_eionet_europa_eu.v_properties_ns v
     LEFT JOIN http_cr_eionet_europa_eu.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	34	120	1	\N	\N
2	38	8	1	\N	\N
3	39	99	1	\N	\N
4	42	56	1	\N	\N
5	60	56	1	\N	\N
6	63	259	1	\N	\N
7	81	120	1	\N	\N
8	84	56	1	\N	\N
9	100	56	1	\N	\N
10	119	97	1	\N	\N
11	137	259	1	\N	\N
12	138	259	1	\N	\N
13	139	99	1	\N	\N
14	147	97	1	\N	\N
15	161	259	1	\N	\N
16	163	47	1	\N	\N
17	181	56	1	\N	\N
18	184	118	1	\N	\N
19	185	99	1	\N	\N
20	204	120	1	\N	\N
21	211	120	1	\N	\N
22	214	10	1	\N	\N
23	235	56	1	\N	\N
24	239	99	1	\N	\N
25	249	100	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	Equivalence demonstration	\N
2	2	8	Time references	\N
3	6	8	List	\N
4	7	8	Tracked file	\N
5	8	8	Concept	en
6	9	8	SymmetricProperty	\N
7	11	8	Habitat type Report	\N
8	12	8	Reporting header declaration	\N
9	13	8	AQ Model	\N
10	15	8	Reporting Obligation	\N
11	17	8	Groundwater parameter/element	\N
12	18	8	DF1 Major roads	\N
13	22	8	Threats/Pressures code	\N
14	26	8	INSPIRE Identifier	\N
15	27	8	Exceedance area	\N
16	32	8	FunctionalProperty	\N
17	33	8	Concept Scheme	en
18	35	8	Sample declaration	\N
19	36	8	Observation	\N
20	38	8	Country (EEA)	\N
21	39	8	Country group (EEA)	\N
22	40	8	Groupe de langues	fr
23	40	8	Language group	en
24	43	8	Bookmark	\N
25	48	8	Groundwater body	\N
26	53	8	Pollutant declaration	\N
27	57	8	Still Image	en-us
29	57	8	Still Image	en
30	59	8	Time instant	\N
31	60	8	Ground Water Monitoring Station Declaration	\N
32	62	8	InverseFunctionalProperty	\N
33	64	8	Environmental issue	\N
34	65	8	Review folder	\N
35	66	8	Language	en
36	66	8	Langue	fr
37	68	8	Article 17 reason	\N
38	73	8	Assessment method	\N
39	78	8	Related party	\N
40	80	8	Service	\N
41	82	8	Network declaration	\N
42	84	8	UWWT Discharge Point	\N
43	85	8	User folder	\N
44	87	8	Area of AQ model	\N
45	88	8	Validated exceedence	\N
46	89	8	WFD Quality element	\N
47	91	8	Biogeographical region	\N
48	93	8	Habitat type code	\N
49	97	8	Property	\N
50	99	8	Collection	en
51	101	8	AQ Sampling point process	\N
52	102	8	Reportnet Delivery	\N
53	103	8	Reporting header declaration	\N
54	107	8	AQ Zone	\N
55	112	8	Assessment threshold	\N
56	113	8	Assessment threshold	\N
57	116	8	AQ Sampling point Observing capability	\N
58	118	8	Class	\N
59	119	8	AnnotationProperty	\N
60	120	8	Dataset	en-us
62	120	8	Dataset	en
63	121	8	Registrations file	\N
64	122	8	ObjectProperty	\N
65	123	8	Collection	en
66	123	8	Collection	en-us
68	125	8	Station declaration	\N
69	128	8	Regional habitat type report	\N
70	129	8	AQ Attainment	\N
71	130	8	AQ Network	\N
72	131	8	WFD Code list	\N
73	132	8	Set of XML schemas	\N
74	133	8	River basin district	\N
75	135	8	Language	\N
76	140	8	Country code (Eurostat)	\N
77	141	8	DF5 Agglomerations	\N
78	145	8	Contact	\N
79	147	8	OntologyProperty	\N
80	148	8	Bookmarks file	\N
81	151	8	Legislation citation	\N
82	152	8	UWWT Big City Discharger	\N
83	153	8	Folder	\N
84	154	8	Locality	\N
85	155	8	Datatype	\N
86	157	8	Contact	\N
87	158	8	DF5 Major Rail	\N
88	164	8	DF5 Major Airports	\N
89	166	8	Exceedance exposure final	\N
90	169	8	Relevant emission declaration	\N
91	170	8	Process parameter	\N
92	172	8	Ontology	\N
93	173	8	History file	\N
94	174	8	AQ Station	\N
95	177	8	Time period	\N
96	178	8	Sampling point declaration	\N
97	179	8	Sampling point process declaration	\N
98	180	8	Zone declaration	\N
99	181	8	UWWT Agglomeration	\N
100	182	8	Language	\N
101	184	8	Agent Class	en
102	184	8	Agent Class	en-us
103	186	8	Assessment methods	\N
104	193	8	Data quality	\N
105	196	8	Exceedance description	\N
106	197	8	Adjustment method	\N
107	201	8	Class	\N
108	202	8	AQ Sample	\N
109	204	8	Habitats directive Article 17 General report	\N
110	205	8	Attainment	\N
111	207	8	Assessment regime	\N
112	209	8	UWWT Receiving Area	\N
113	210	8	UWWT pAgglo	\N
114	212	8	NUTS Region	\N
115	214	8	Reportnet client	\N
116	215	8	Legislation Instrument	\N
117	216	8	SPARQL bookmark	\N
118	224	8	Address representation	\N
119	225	8	AQ Sampling point Relevant emissions	\N
120	226	8	Environmental objective	\N
121	229	8	DatatypeProperty	\N
122	230	8	TransitiveProperty	\N
123	231	8	Species report	\N
124	232	8	Sound	en-us
126	232	8	Sound	en
127	233	8	Observing capability declaration	\N
128	235	8	UWWT Plant	\N
129	236	8	Feature	\N
130	243	8	Measurement method	\N
131	244	8	Measurement equipment	\N
132	246	8	Reportnet File	\N
133	247	8	Text	en-us
135	247	8	Text	en
136	248	8	Feedback	\N
137	249	8	AQ SamplingPoint	\N
138	252	8	Feedback attachment	\N
139	253	8	Regional species report	\N
140	254	8	Assessment regime	\N
141	255	8	Area of model declaration	\N
142	256	8	Model declaration	\N
143	257	8	Model process declaration	\N
144	260	8	UWWT Industry	\N
145	264	8	DF1 Major Rail	\N
146	266	8	Article 17 assessment	\N
147	267	8	Biogeographical region	\N
148	269	8	DF1 Agglomerations	\N
149	270	8	Article 17 survey method	\N
150	271	8	DF1 Major Airports	\N
151	272	8	Exceedance exposure	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://rdfdata.eionet.europa.eu/airquality/ontology/EquivalenceDemonstration	1909205	\N	t	69	EquivalenceDemonstration	EquivalenceDemonstration	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1909165
2	http://rdfdata.eionet.europa.eu/airquality/ontology/TimeReferences	3878965	\N	t	69	TimeReferences	TimeReferences	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3885060
3	http://rdfdata.eionet.europa.eu/airquality/ontology/AnalyticalTechnique	719345	\N	t	69	AnalyticalTechnique	AnalyticalTechnique	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	719328
4	http://reference.eionet.europa.eu/aq/ontology/AreaExceedanceFinal	1474985	\N	t	81	AreaExceedanceFinal	AreaExceedanceFinal	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	69855
5	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMap	3	\N	t	17	array-of-QuadMap	array-of-QuadMap	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
6	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	1	\N	t	1	List	List	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6
7	http://cr.eionet.europa.eu/ontologies/contreg.rdf#File	837547	\N	t	82	File	File	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9922225
8	http://www.w3.org/2004/02/skos/core#Concept	240218	\N	t	4	Concept	Concept	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	104586786
9	http://www.w3.org/2002/07/owl#SymmetricProperty	10	\N	t	7	SymmetricProperty	SymmetricProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
10	http://xmlns.com/foaf/0.1/Organization	76	\N	t	8	Organization	Organization	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1276
11	http://rdfdata.eionet.europa.eu/article17/ontology/HabitatTypeReport	4620	\N	t	83	HabitatTypeReport	HabitatTypeReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3141
13	http://reference.eionet.europa.eu/aq/ontology/Model	1285	\N	t	81	Model	Model	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1117265
14	http://reference.eionet.europa.eu/aq/ontology/ModelProcess	3258	\N	t	81	ModelProcess	ModelProcess	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	83989
15	http://rod.eionet.europa.eu/schema.rdf#Obligation	671	\N	t	84	Obligation	Obligation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	70278
16	http://rdfdata.eionet.europa.eu/msfd/ontology/CompetentAuthorityDeclaration	284	\N	t	85	CompetentAuthorityDeclaration	CompetentAuthorityDeclaration	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://rdfdata.eionet.europa.eu/wise/ontology/GroundwaterParameter	10	\N	t	86	GroundwaterParameter	GroundwaterParameter	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	145257
19	http://rdfdata.eionet.europa.eu/eea/ontology/BoundingBox	202	\N	t	88	BoundingBox	BoundingBox	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
20	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv/DF1_5_MRaiilway	9351	\N	t	89	DF1_5_MRaiilway	DF1_5_MRaiilway	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
21	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv/DF1_5_Agg	456	\N	t	90	DF1_5_Agg	DF1_5_Agg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://rdfdata.eionet.europa.eu/article17/ontology/ThreatPressure	168	\N	t	83	ThreatPressure	ThreatPressure	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	http://rdfdata.eionet.europa.eu/ramon/ontology/MIG	5	\N	t	91	MIG	MIG	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
24	http://rdfdata.eionet.europa.eu/airquality/ontology/DQ_ConformanceResult	437249	\N	t	69	DQ_ConformanceResult	DQ_ConformanceResult	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	437249
25	http://telegraphis.net/ontology/measurement/code#Code	738	\N	t	92	Code	Code	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	738
26	http://rdfdata.eionet.europa.eu/airquality/ontology/Identifier	6429420	\N	t	69	Identifier	Identifier	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6428578
27	http://rdfdata.eionet.europa.eu/airquality/ontology/ExceedanceArea	34219	\N	t	69	ExceedanceArea	ExceedanceArea	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34219
28	http://reference.eionet.europa.eu/aq/ontology/EnvironmentalObjective	630215	\N	t	81	EnvironmentalObjective	EnvironmentalObjective	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	629875
29	http://www.openlinksw.com/schemas/virtrdf#QuadMapFormat	130	\N	t	17	QuadMapFormat	QuadMapFormat	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	322
30	http://www.openlinksw.com/schemas/virtrdf#QuadMap	2	\N	t	17	QuadMap	QuadMap	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
31	http://www.openlinksw.com/schemas/virtrdf#QuadMapFText	4	\N	t	17	QuadMapFText	QuadMapFText	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
32	http://www.w3.org/2002/07/owl#FunctionalProperty	8	\N	t	7	FunctionalProperty	FunctionalProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
12	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_ReportingHeader	18213	\N	t	69	AQD_ReportingHeader	[Reporting header declaration (AQD_ReportingHeader)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18110
18	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF1_MRoad	45913	\N	t	87	DF1_MRoad	[DF1 Major roads (DF1_MRoad)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
33	http://www.w3.org/2004/02/skos/core#ConceptScheme	214	\N	t	4	ConceptScheme	ConceptScheme	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	238258
34	http://rdfdata.eionet.europa.eu/article17/ontology/SpeciesChecklistItem	70	\N	t	83	SpeciesChecklistItem	SpeciesChecklistItem	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	150
36	http://rdfdata.eionet.europa.eu/airquality/ontology/OM_Observation	483642	\N	t	69	OM_Observation	OM_Observation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19740
37	http://rdfdata.eionet.europa.eu/wise/ontology/PARAMETER	145250	\N	t	86	PARAMETER	PARAMETER	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	144251
38	http://rdfdata.eionet.europa.eu/eea/ontology/Country	73	\N	t	88	Country	Country	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26359
39	http://rdfdata.eionet.europa.eu/eea/ontology/CountryGroup	24	\N	t	88	CountryGroup	CountryGroup	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	172
40	http://psi.oasis-open.org/iso/639/#language-group	57	\N	t	93	language-group	language-group	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv/DF1_5_MRoad	182542	\N	t	94	DF1_5_MRoad	DF1_5_MRoad	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
42	http://rdfdata.eionet.europa.eu/wise/ontology/GroundWaterBodyDeclaration	25252	\N	t	86	GroundWaterBodyDeclaration	GroundWaterBodyDeclaration	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
43	http://cr.eionet.europa.eu/ontologies/contreg.rdf#Bookmark	5	\N	t	82	Bookmark	Bookmark	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
44	http://rdfdata.eionet.europa.eu/waterbase/ontology/RiverStation	10358	\N	t	95	RiverStation	RiverStation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
45	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv/DF1_5_Agg	13546	\N	t	96	DF1_5_Agg	DF1_5_Agg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
46	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv/file	19068	\N	t	97	file	file	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
47	http://purl.org/linked-data/api/vocab#Page	1	\N	t	98	Page	Page	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
48	http://rdfdata.eionet.europa.eu/wise/ontology/GroundwaterBody	5053	\N	t	86	GroundwaterBody	GroundwaterBody	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
49	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv/DF1_5_Agg	472	\N	t	99	DF1_5_Agg	DF1_5_Agg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
50	http://reference.eionet.europa.eu/aq/ontology/ExposureExceedanceBase	4837	\N	t	81	ExposureExceedanceBase	ExposureExceedanceBase	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	216
51	http://rdfdata.eionet.europa.eu/airquality/ontology/CI_Citation	437249	\N	t	69	CI_Citation	CI_Citation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	437249
52	http://rdfdata.eionet.europa.eu/airquality/ontology/QuantityCommented	63206	\N	t	69	QuantityCommented	QuantityCommented	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	63206
53	http://rdfdata.eionet.europa.eu/airquality/ontology/Pollutant	304346	\N	t	69	Pollutant	Pollutant	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	304958
54	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapFormat	98	\N	t	17	array-of-QuadMapFormat	array-of-QuadMapFormat	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	98
55	http://www.openlinksw.com/schemas/virtrdf#QuadMapATable	2	\N	t	17	QuadMapATable	QuadMapATable	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
56	http://www.w3.org/2003/01/geo/wgs84_pos#SpatialThing	2099738	\N	t	25	SpatialThing	SpatialThing	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23492526
57	http://purl.org/dc/dcmitype/StillImage	3821	\N	t	72	StillImage	StillImage	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3455
58	http://rdfdata.eionet.europa.eu/article17/generalreportGeneralReport	66	\N	t	100	generalreportGeneralReport	generalreportGeneralReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	144
59	http://rdfdata.eionet.europa.eu/airquality/ontology/TimeInstant	1030474	\N	t	69	TimeInstant	TimeInstant	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1035212
60	http://rdfdata.eionet.europa.eu/wise/ontology/GROUNDWATERMONITORINGSTATION	40827	\N	t	86	GROUNDWATERMONITORINGSTATION	GROUNDWATERMONITORINGSTATION	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
61	http://xmlns.com/foaf/0.1/Document	170	\N	t	8	Document	Document	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	253
62	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	8	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
63	http://rdfdata.eionet.europa.eu/ramon/ontology/Class	615	\N	t	91	Class	Class	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
64	http://rod.eionet.europa.eu/schema.rdf#Issue	11	\N	t	84	Issue	Issue	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	927
65	http://cr.eionet.europa.eu/ontologies/contreg.rdf#ReviewFolder	56	\N	t	82	ReviewFolder	ReviewFolder	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56
66	http://psi.oasis-open.org/iso/639/#language	415	\N	t	93	language	language	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	88
67	http://rdfdata.eionet.europa.eu/airquality/ontology/CompositeSurface	41	\N	t	69	CompositeSurface	CompositeSurface	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	41
68	http://rdfdata.eionet.europa.eu/article17/ontology/Reason	8	\N	t	83	Reason	Reason	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
69	http://rdfdata.eionet.europa.eu/inspire-m/ontology/SpatialDataSet	208	\N	t	101	SpatialDataSet	SpatialDataSet	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	208
70	http://rdfdata.eionet.europa.eu/inspire-m/ontology/SpatialDataService	46	\N	t	101	SpatialDataService	SpatialDataService	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	46
71	http://rdfdata.eionet.europa.eu/airquality/ontology/boundedBy	320	\N	t	69	boundedBy	boundedBy	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
72	http://rdfdata.eionet.europa.eu/airquality/ontology/CI_Date	437249	\N	t	69	CI_Date	CI_Date	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	437249
73	http://rdfdata.eionet.europa.eu/airquality/ontology/AssessmentMethods	561539	\N	t	69	AssessmentMethods	AssessmentMethods	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	561539
74	http://rdfdata.eionet.europa.eu/airquality/ontology/UrbanBackground	1512	\N	t	69	UrbanBackground	UrbanBackground	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512
75	http://rdfdata.eionet.europa.eu/airquality/ontology/Publication	4804	\N	t	69	Publication	Publication	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4804
76	http://rdfdata.eionet.europa.eu/wise/ontology/SUB_PROGRAMME	2403	\N	t	86	SUB_PROGRAMME	SUB_PROGRAMME	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2403
77	http://rdfdata.eionet.europa.eu/airquality/ontology/SamplingEquipment	214825	\N	t	69	SamplingEquipment	SamplingEquipment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	224595
78	http://rdfdata.eionet.europa.eu/airquality/ontology/RelatedParty	1961497	\N	t	69	RelatedParty	RelatedParty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1961437
79	http://rdfdata.eionet.europa.eu/airquality/ontology/DispersionSituation	152307	\N	t	69	DispersionSituation	DispersionSituation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	152119
80	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
81	http://rdfdata.eionet.europa.eu/article17/ontology/BirdReport	41	\N	t	83	BirdReport	BirdReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	124
83	http://rdfdata.eionet.europa.eu/wise/ontology/QUALITY_ELEMENT	5455	\N	t	86	QUALITY_ELEMENT	QUALITY_ELEMENT	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
84	http://rdfdata.eionet.europa.eu/uwwtd/ontology/DischargePoint	36450	\N	t	102	DischargePoint	DischargePoint	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
85	http://cr.eionet.europa.eu/ontologies/contreg.rdf#UserFolder	56	\N	t	82	UserFolder	UserFolder	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
86	http://rdfdata.eionet.europa.eu/airquality/ontology/DocumentCitation	25152	\N	t	69	DocumentCitation	DocumentCitation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25152
87	http://reference.eionet.europa.eu/aq/ontology/ModelArea	1493	\N	t	81	ModelArea	ModelArea	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	107604
88	http://reference.eionet.europa.eu/aq/ontology/ValidatedExceedence	935516	\N	t	81	ValidatedExceedence	ValidatedExceedence	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
89	http://rdfdata.eionet.europa.eu/wise/ontology/QualityElement	48	\N	t	86	QualityElement	QualityElement	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18308
90	http://rdfdata.eionet.europa.eu/ghg/ontology/GreenHouseGas	6	\N	t	103	GreenHouseGas	GreenHouseGas	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
91	http://rdfdata.eionet.europa.eu/eea/ontology/BiogeographicalRegion	35	\N	t	88	BiogeographicalRegion	BiogeographicalRegion	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15505
92	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv/DF1_DF5_MajorRailways	5149	\N	t	104	DF1_DF5_MajorRailways	DF1_DF5_MajorRailways	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
93	http://rdfdata.eionet.europa.eu/article17/ontology/HabitatType	218	\N	t	83	HabitatType	HabitatType	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
94	http://rdfs.org/ns/void#TechnicalFeature	3	\N	t	16	TechnicalFeature	TechnicalFeature	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
95	http://rdfdata.eionet.europa.eu/airquality/ontology/MultiGeometry	18	\N	t	69	MultiGeometry	MultiGeometry	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
96	http://rdfdata.eionet.europa.eu/airquality/ontology/DQ_QuantitativeAttributeAccuracy	89221	\N	t	69	DQ_QuantitativeAttributeAccuracy	DQ_QuantitativeAttributeAccuracy	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	89221
97	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	7270	\N	t	1	Property	Property	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	353
98	http://rdfs.org/ns/void#DatasetDescription	2	\N	t	16	DatasetDescription	DatasetDescription	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
99	http://www.w3.org/2004/02/skos/core#Collection	1080	\N	t	4	Collection	Collection	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3301
100	http://www.w3.org/2003/01/geo/wgs84_pos#Point	1881690	\N	t	25	Point	Point	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23276401
101	http://reference.eionet.europa.eu/aq/ontology/SamplingPointProcess	61234	\N	t	81	SamplingPointProcess	SamplingPointProcess	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7445814
102	http://rod.eionet.europa.eu/schema.rdf#Delivery	46337	\N	t	84	Delivery	Delivery	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	754124
103	http://reference.eionet.europa.eu/aq/ontology/ReportingHeader	6214	\N	t	81	ReportingHeader	ReportingHeader	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18368
104	http://rdfdata.eionet.europa.eu/airquality/ontology/OperationalActivityPeriod	2334482	\N	t	69	OperationalActivityPeriod	OperationalActivityPeriod	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2334482
105	http://rdfdata.eionet.europa.eu/wise/ontology/GWPROGRAMME	550	\N	t	86	GWPROGRAMME	GWPROGRAMME	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
106	http://rdfdata.eionet.europa.eu/airquality/ontology/BaseUnit	244387	\N	t	69	BaseUnit	BaseUnit	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	245011
107	http://reference.eionet.europa.eu/aq/ontology/Zone	1159	\N	t	81	Zone	Zone	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1643482
108	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv/DF1_DF5_MajorRoads	123830	\N	t	105	DF1_DF5_MajorRoads	DF1_DF5_MajorRoads	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
109	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv/DF1_5_MAir	94	\N	t	106	DF1_5_MAir	DF1_5_MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
110	http://purl.org/dc/dcam/VocabularyEncodingScheme	18	\N	t	76	VocabularyEncodingScheme	VocabularyEncodingScheme	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	72
111	http://eunis.eea.europa.eu/rdf/schema.rdf#Designation	611	\N	t	107	Designation	Designation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
112	http://reference.eionet.europa.eu/aq/ontology/AssessmentThreshold	6719312	\N	t	81	AssessmentThreshold	AssessmentThreshold	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	676203
113	http://rdfdata.eionet.europa.eu/airquality/ontology/AssessmentThreshold	479066	\N	t	69	AssessmentThreshold	AssessmentThreshold	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	743933
114	http://rdfdata.eionet.europa.eu/airquality/ontology/ExpectedImpact	16679	\N	t	69	ExpectedImpact	ExpectedImpact	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16679
115	http://rdfdata.eionet.europa.eu/airquality/ontology/OfficialJournalInformation	234	\N	t	69	OfficialJournalInformation	OfficialJournalInformation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	234
116	http://reference.eionet.europa.eu/aq/ontology/ObservingCapability	1054932	\N	t	81	ObservingCapability	ObservingCapability	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1054453
117	http://spinrdf.org/spin#ConstraintViolation	15841	\N	t	108	ConstraintViolation	ConstraintViolation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
118	http://www.w3.org/2000/01/rdf-schema#Class	741	\N	t	2	Class	Class	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73345585
119	http://www.w3.org/2002/07/owl#AnnotationProperty	15	\N	t	7	AnnotationProperty	AnnotationProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32
120	http://purl.org/dc/dcmitype/Dataset	161880	\N	t	72	Dataset	Dataset	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8460499
121	http://cr.eionet.europa.eu/ontologies/contreg.rdf#RegistrationsFile	56	\N	t	82	RegistrationsFile	RegistrationsFile	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56
122	http://www.w3.org/2002/07/owl#ObjectProperty	22	\N	t	7	ObjectProperty	ObjectProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
123	http://purl.org/dc/dcmitype/Collection	2884	\N	t	72	Collection	Collection	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3062
124	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_SourceApportionment	1512	\N	t	69	AQD_SourceApportionment	AQD_SourceApportionment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512
126	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_EvaluationScenario	935	\N	t	69	AQD_EvaluationScenario	AQD_EvaluationScenario	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	935
127	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Measures	25693	\N	t	69	AQD_Measures	AQD_Measures	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25693
128	http://rdfdata.eionet.europa.eu/article17/ontology/HabitatTypeRegionalReport	7203	\N	t	83	HabitatTypeRegionalReport	HabitatTypeRegionalReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7203
129	http://reference.eionet.europa.eu/aq/ontology/Attainment	110122	\N	t	81	Attainment	Attainment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	412384
130	http://reference.eionet.europa.eu/aq/ontology/Network	553	\N	t	81	Network	Network	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2183920
131	http://rdfdata.eionet.europa.eu/wise/ontology/CodeList	2	\N	t	86	CodeList	CodeList	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51
132	http://dd.eionet.europa.eu/schema.rdf#SchemaSet	97	\N	t	109	SchemaSet	SchemaSet	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
133	http://rdfdata.eionet.europa.eu/wise/ontology/RBD	202	\N	t	86	RBD	RBD	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	58650
134	http://purl.org/linked-data/cube#DataSet	4	\N	t	73	DataSet	DataSet	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	217684
135	http://rdfdata.eionet.europa.eu/eea/ontology/Language	45	\N	t	88	Language	Language	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
136	http://rdfdata.eionet.europa.eu/eea/ontology/BioGeoRegionCountry	84	\N	t	88	BioGeoRegionCountry	BioGeoRegionCountry	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
137	http://rdfdata.eionet.europa.eu/ramon/ontology/Group	272	\N	t	91	Group	Group	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	615
138	http://rdfdata.eionet.europa.eu/ramon/ontology/Division	88	\N	t	91	Division	Division	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	272
139	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#SuperGroup	4	\N	t	110	SuperGroup	SuperGroup	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	36
140	http://rdfdata.eionet.europa.eu/ramon/ontology/CountryCode	40	\N	t	91	CountryCode	CountryCode	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
142	http://rdfdata.eionet.europa.eu/eea/ontology/DPSIR	5	\N	t	88	DPSIR	DPSIR	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
217	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv/Magg	1124	\N	t	119	Magg	Magg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
143	http://rdfdata.eionet.europa.eu/airquality/ontology/Scenario	1870	\N	t	69	Scenario	Scenario	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1870
144	http://rdfdata.eionet.europa.eu/wise/ontology/PROGRAMME	53586	\N	t	86	PROGRAMME	PROGRAMME	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53586
145	http://rdfdata.eionet.europa.eu/airquality/ontology/Contact	1961505	\N	t	69	Contact	Contact	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1961456
146	http://www.openlinksw.com/schemas/virtrdf#QuadMapColumn	8	\N	t	17	QuadMapColumn	QuadMapColumn	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
147	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
148	http://cr.eionet.europa.eu/ontologies/contreg.rdf#BookmarksFile	60	\N	t	82	BookmarksFile	BookmarksFile	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60
149	http://rdfs.org/ns/void#Linkset	26	\N	t	16	Linkset	Linkset	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
150	http://rdfdata.eionet.europa.eu/wise/ontology/SWPROGRAMME	862	\N	t	86	SWPROGRAMME	SWPROGRAMME	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
151	http://rdfdata.eionet.europa.eu/airquality/ontology/LegislationCitation	19518	\N	t	69	LegislationCitation	LegislationCitation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19518
152	http://rdfdata.eionet.europa.eu/uwwtd/ontology/BigCityDischarger	968	\N	t	102	BigCityDischarger	BigCityDischarger	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
153	http://cr.eionet.europa.eu/ontologies/contreg.rdf#Folder	7	\N	t	82	Folder	Folder	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6
154	http://rod.eionet.europa.eu/schema.rdf#Locality	69	\N	t	84	Locality	Locality	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	74137
155	http://www.w3.org/2000/01/rdf-schema#Datatype	30	\N	t	2	Datatype	Datatype	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
156	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv/MRoad_2010_2015	411027	\N	t	111	MRoad_2010_2015	MRoad_2010_2015	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
157	http://rdfdata.eionet.europa.eu/uwwtd/ontology/Contact	58	\N	t	102	Contact	Contact	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
159	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv/MAir	225	\N	t	112	MAir	MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
160	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv/DF1_5_MRoad	233718	\N	t	113	DF1_5_MRoad	DF1_5_MRoad	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
161	http://rdfdata.eionet.europa.eu/ramon/ontology/Section	21	\N	t	91	Section	Section	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1063
162	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv/DF1_5_Agg	506	\N	t	114	DF1_5_Agg	DF1_5_Agg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
163	http://purl.org/linked-data/api/vocab#ListEndpoint	1	\N	t	98	ListEndpoint	ListEndpoint	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
165	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv/DF1_5_MAir	91	\N	t	115	DF1_5_MAir	DF1_5_MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
166	http://reference.eionet.europa.eu/aq/ontology/ExposureExceedanceFinal	505915	\N	t	81	ExposureExceedanceFinal	ExposureExceedanceFinal	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32850
167	http://rdfdata.eionet.europa.eu/airquality/ontology/PlannedImplementation	25693	\N	t	69	PlannedImplementation	PlannedImplementation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25693
168	http://rdfdata.eionet.europa.eu/airquality/ontology/SamplingPointCollection	640	\N	t	69	SamplingPointCollection	SamplingPointCollection	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	640
169	http://rdfdata.eionet.europa.eu/airquality/ontology/RelevantEmissions	1854424	\N	t	69	RelevantEmissions	RelevantEmissions	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1854277
170	http://rdfdata.eionet.europa.eu/airquality/ontology/ProcessParameter	903214	\N	t	69	ProcessParameter	ProcessParameter	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	903132
171	http://www.openlinksw.com/schemas/virtrdf#QuadStorage	3	\N	t	17	QuadStorage	QuadStorage	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
172	http://www.w3.org/2002/07/owl#Ontology	26	\N	t	7	Ontology	Ontology	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	105
173	http://cr.eionet.europa.eu/ontologies/contreg.rdf#HistoryFile	56	\N	t	82	HistoryFile	HistoryFile	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56
174	http://reference.eionet.europa.eu/aq/ontology/Station	9045	\N	t	81	Station	Station	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3199274
175	http://dbpedia.org/ontology/Animal	1657	\N	t	10	Animal	Animal	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
176	http://rdfdata.eionet.europa.eu/airquality/ontology/CompetentAuthorities	8032	\N	t	69	CompetentAuthorities	CompetentAuthorities	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	162
177	http://rdfdata.eionet.europa.eu/airquality/ontology/TimePeriod	5275880	\N	t	69	TimePeriod	TimePeriod	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5276481
164	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF5_Mair	90	\N	t	87	DF5_Mair	[DF5 Major Airports (DF5_Mair)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
178	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_SamplingPoint	1855886	\N	t	69	AQD_SamplingPoint	[Sampling point declaration (AQD_SamplingPoint)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1902480
179	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_SamplingPointProcess	1925942	\N	t	69	AQD_SamplingPointProcess	[Sampling point process declaration (AQD_SamplingPointProcess)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1963781
181	http://rdfdata.eionet.europa.eu/uwwtd/ontology/Agglomeration	35097	\N	t	102	Agglomeration	Agglomeration	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	93252
182	http://www.w3.org/ns/sparql-service-description#Language	3	\N	t	27	Language	Language	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
183	http://rdfdata.eionet.europa.eu/ippc/ontology/Installation	189	\N	t	116	Installation	Installation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
184	http://purl.org/dc/terms/AgentClass	2	\N	t	5	AgentClass	AgentClass	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16
185	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#Group	32	\N	t	110	Group	Group	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	64
186	http://reference.eionet.europa.eu/aq/ontology/AssessmentMethods	15117462	\N	t	81	AssessmentMethods	AssessmentMethods	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	408460
187	http://reference.eionet.europa.eu/aq/ontology/AreaExceedanceBase	29143	\N	t	81	AreaExceedanceBase	AreaExceedanceBase	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1462
188	http://rdfdata.eionet.europa.eu/airquality/ontology/DQ_DomainConsistency	591647	\N	t	69	DQ_DomainConsistency	DQ_DomainConsistency	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	591647
189	http://rdfdata.eionet.europa.eu/airquality/ontology/DQ_QuantitativeResult	244387	\N	t	69	DQ_QuantitativeResult	DQ_QuantitativeResult	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	244387
190	http://rdfdata.eionet.europa.eu/airquality/ontology/LocalIncrement	1512	\N	t	69	LocalIncrement	LocalIncrement	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512
191	http://rdfdata.eionet.europa.eu/airquality/ontology/div	3	\N	t	69	div	div	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
192	http://telegraphis.net/ontology/geography/geography#Code	246	\N	t	117	Code	Code	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	246
193	http://rdfdata.eionet.europa.eu/airquality/ontology/DataQuality	1926031	\N	t	69	DataQuality	DataQuality	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1925993
194	http://rdfdata.eionet.europa.eu/airquality/ontology/SamplingMethod	714841	\N	t	69	SamplingMethod	SamplingMethod	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	714819
195	http://rdfdata.eionet.europa.eu/airquality/ontology/NamedValue	1015273	\N	t	69	NamedValue	NamedValue	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1015273
196	http://rdfdata.eionet.europa.eu/airquality/ontology/ExceedanceDescription	225689	\N	t	69	ExceedanceDescription	ExceedanceDescription	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	225689
197	http://rdfdata.eionet.europa.eu/airquality/ontology/AdjustmentMethod	192230	\N	t	69	AdjustmentMethod	AdjustmentMethod	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	192230
198	http://rdfdata.eionet.europa.eu/airquality/ontology/Envelope	750	\N	t	69	Envelope	Envelope	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	750
199	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapATable	2	\N	t	17	array-of-QuadMapATable	array-of-QuadMapATable	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
200	http://www.openlinksw.com/schemas/virtrdf#array-of-string	2	\N	t	17	array-of-string	array-of-string	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
201	http://www.w3.org/2002/07/owl#Class	19	\N	t	7	Class	Class	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	241581
202	http://reference.eionet.europa.eu/aq/ontology/Sample	71620	\N	t	81	Sample	Sample	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6697591
203	http://xmlns.com/foaf/0.1/Person	1	\N	t	8	Person	Person	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
204	http://rdfdata.eionet.europa.eu/article17/generalreport/GeneralReport	25	\N	t	118	GeneralReport	GeneralReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	64
206	http://rdfdata.eionet.europa.eu/airquality/ontology/MultiSurface	18700	\N	t	69	MultiSurface	MultiSurface	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18700
207	http://reference.eionet.europa.eu/aq/ontology/AssessmentRegime	167770	\N	t	81	AssessmentRegime	AssessmentRegime	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1201292
208	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Plan	1536	\N	t	69	AQD_Plan	AQD_Plan	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1536
209	http://rdfdata.eionet.europa.eu/uwwtd/ontology/ReceivingArea	5548	\N	t	102	ReceivingArea	ReceivingArea	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	33183
210	http://rdfdata.eionet.europa.eu/uwwtd/ontology/UwwtpAgglo	36540	\N	t	102	UwwtpAgglo	UwwtpAgglo	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
211	http://rdfdata.eionet.europa.eu/article17/ontology/HabitatChecklistItem	28	\N	t	83	HabitatChecklistItem	HabitatChecklistItem	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	69
212	http://rdfdata.eionet.europa.eu/ramon/ontology/NUTSRegion	7804	\N	t	91	NUTSRegion	NUTSRegion	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	108182
213	http://www.geonames.org/ontology#Country	246	\N	t	70	Country	Country	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	74
214	http://rod.eionet.europa.eu/schema.rdf#Client	74	\N	t	84	Client	Client	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1240
215	http://rod.eionet.europa.eu/schema.rdf#Instrument	216	\N	t	84	Instrument	Instrument	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7527
216	http://cr.eionet.europa.eu/ontologies/contreg.rdf#SparqlBookmark	129	\N	t	82	SparqlBookmark	SparqlBookmark	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13
205	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Attainment	222475	\N	t	69	AQD_Attainment	[Attainment (AQD_Attainment)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	231883
218	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv/DF1_DF5_MajorRailways	5923	\N	t	120	DF1_DF5_MajorRailways	DF1_DF5_MajorRailways	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
219	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv/DF1_DF5_MajorRoads	150682	\N	t	121	DF1_DF5_MajorRoads	DF1_DF5_MajorRoads	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
220	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv/DF1_5_Agg	456	\N	t	122	DF1_5_Agg	DF1_5_Agg	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
221	http://rdfdata.eionet.europa.eu/airquality/ontology/RegionalBackground	1512	\N	t	69	RegionalBackground	RegionalBackground	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512
222	http://rdfdata.eionet.europa.eu/airquality/ontology/DQ_ConceptualConsistency	774	\N	t	69	DQ_ConceptualConsistency	DQ_ConceptualConsistency	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	774
223	http://telegraphis.net/ontology/measurement/measurement#Measurement	246	\N	t	123	Measurement	Measurement	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	246
224	http://rdfdata.eionet.europa.eu/airquality/ontology/AddressRepresentation	1961500	\N	t	69	AddressRepresentation	AddressRepresentation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1961437
225	http://reference.eionet.europa.eu/aq/ontology/RelevantEmissions	956051	\N	t	81	RelevantEmissions	RelevantEmissions	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	955581
226	http://rdfdata.eionet.europa.eu/airquality/ontology/EnvironmentalObjective	1737846	\N	t	69	EnvironmentalObjective	EnvironmentalObjective	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1737846
227	http://reference.eionet.europa.eu/aq/ontology/Pollutant	509915	\N	t	81	Pollutant	Pollutant	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29408
228	http://www.openlinksw.com/schemas/virtrdf#QuadMapValue	8	\N	t	17	QuadMapValue	QuadMapValue	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
229	http://www.w3.org/2002/07/owl#DatatypeProperty	1796	\N	t	7	DatatypeProperty	DatatypeProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
230	http://www.w3.org/2002/07/owl#TransitiveProperty	5	\N	t	7	TransitiveProperty	TransitiveProperty	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
231	http://rdfdata.eionet.europa.eu/article17/ontology/SpeciesReport	11142	\N	t	83	SpeciesReport	SpeciesReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7549
232	http://purl.org/dc/dcmitype/Sound	134	\N	t	72	Sound	Sound	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113
233	http://rdfdata.eionet.europa.eu/airquality/ontology/ObservingCapability	2367115	\N	t	69	ObservingCapability	ObservingCapability	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2367115
234	http://dd.eionet.europa.eu/tables/8286/rdf/BWQD_2006_IdentifiedBW	33849	\N	t	124	BWQD_2006_IdentifiedBW	BWQD_2006_IdentifiedBW	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8723
235	http://rdfdata.eionet.europa.eu/uwwtd/ontology/UWWTP	36012	\N	t	102	UWWTP	UWWTP	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113503
236	http://www.w3.org/ns/sparql-service-description#Feature	5	\N	t	27	Feature	Feature	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
237	http://purl.org/linked-data/cube#Observation	217681	\N	t	73	Observation	Observation	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
238	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingHeader	2	\N	t	69	reportingHeader	reportingHeader	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
239	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#Theme	40	\N	t	110	Theme	Theme	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
240	http://rdfdata.eionet.europa.eu/airquality/ontology/Costs	19363	\N	t	69	Costs	Costs	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19363
241	http://rdfdata.eionet.europa.eu/wise/ontology/ASSOC_WB	103007	\N	t	86	ASSOC_WB	ASSOC_WB	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	103007
242	http://rdfdata.eionet.europa.eu/article17/generalreportPublication	14	\N	t	100	generalreportPublication	generalreportPublication	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
243	http://rdfdata.eionet.europa.eu/airquality/ontology/MeasurementMethod	1206662	\N	t	69	MeasurementMethod	MeasurementMethod	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1206643
244	http://rdfdata.eionet.europa.eu/airquality/ontology/MeasurementEquipment	726836	\N	t	69	MeasurementEquipment	MeasurementEquipment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	726817
245	http://www.openlinksw.com/schemas/virtrdf#array-of-QuadMapColumn	8	\N	t	17	array-of-QuadMapColumn	array-of-QuadMapColumn	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
246	http://rod.eionet.europa.eu/schema.rdf#File	523260	\N	t	84	File	File	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8849733
247	http://purl.org/dc/dcmitype/Text	386152	\N	t	72	Text	Text	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	384676
248	http://cr.eionet.europa.eu/ontologies/contreg.rdf#Feedback	230056	\N	t	82	Feedback	Feedback	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	269609
249	http://reference.eionet.europa.eu/aq/ontology/SamplingPoint	70439	\N	t	81	SamplingPoint	SamplingPoint	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21450077
250	http://rdfs.org/ns/void#Dataset	93	\N	t	16	Dataset	Dataset	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	84
251	http://purl.org/ontology/bibo/Document	2	\N	t	31	Document	Document	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
252	http://cr.eionet.europa.eu/ontologies/contreg.rdf#FeedbackAttachment	37950	\N	t	82	FeedbackAttachment	FeedbackAttachment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40854
253	http://rdfdata.eionet.europa.eu/article17/ontology/SpeciesRegionalReport	17016	\N	t	83	SpeciesRegionalReport	SpeciesRegionalReport	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17016
258	http://www.geonames.org/ontology#Feature	333	\N	t	70	Feature	Feature	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	668
259	http://rdfdata.eionet.europa.eu/ramon/ontology/Activity	996	\N	t	91	Activity	Activity	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1950
260	http://rdfdata.eionet.europa.eu/uwwtd/ontology/Industry	258	\N	t	102	Industry	Industry	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
261	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv/DF1_5_MAir	114	\N	t	125	DF1_5_MAir	DF1_5_MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
262	http://rdfdata.eionet.europa.eu/airquality/ontology/competentAuthorities	1	\N	t	69	competentAuthorities	competentAuthorities	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
263	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv/DF1_5_MAir	92	\N	t	126	DF1_5_MAir	DF1_5_MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
265	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#Source	87	\N	t	110	Source	Source	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
266	http://rdfdata.eionet.europa.eu/article17/ontology/Assessment	8	\N	t	83	Assessment	Assessment	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
267	http://rdfdata.eionet.europa.eu/article17/ontology/BioGeoRegion	11	\N	t	83	BioGeoRegion	BioGeoRegion	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
268	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv/DF1_5_MAir	92	\N	t	127	DF1_5_MAir	DF1_5_MAir	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
270	http://rdfdata.eionet.europa.eu/article17/ontology/Method	5	\N	t	83	Method	Method	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
272	http://rdfdata.eionet.europa.eu/airquality/ontology/ExceedanceExposure	64126	\N	t	69	ExceedanceExposure	ExceedanceExposure	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	64126
35	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Sample	1499564	\N	t	69	AQD_Sample	[Sample declaration (AQD_Sample)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1549442
82	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Network	13691	\N	t	69	AQD_Network	[Network declaration (AQD_Network)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14197
125	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Station	266220	\N	t	69	AQD_Station	[Station declaration (AQD_Station)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	273628
141	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF5_Agg	397	\N	t	87	DF5_Agg	[DF5 Agglomerations (DF5_Agg)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
158	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF5_MRail	7625	\N	t	87	DF5_MRail	[DF5 Major Rail (DF5_MRail)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
180	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Zone	30940	\N	t	69	AQD_Zone	[Zone declaration (AQD_Zone)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37412
254	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_AssessmentRegime	478636	\N	t	69	AQD_AssessmentRegime	[Assessment regime (AQD_AssessmentRegime)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	496890
255	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_ModelArea	22851	\N	t	69	AQD_ModelArea	[Area of model declaration (AQD_ModelArea)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22733
256	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_Model	37226	\N	t	69	AQD_Model	[Model declaration (AQD_Model)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37713
257	http://rdfdata.eionet.europa.eu/airquality/ontology/AQD_ModelProcess	27017	\N	t	69	AQD_ModelProcess	[Model process declaration (AQD_ModelProcess)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27593
264	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF1_MRail	2022	\N	t	87	DF1_MRail	[DF1 Major Rail (DF1_MRail)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
269	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF1_Agg	165	\N	t	87	DF1_Agg	[DF1 Agglomerations (DF1_Agg)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
271	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/DF1_MAir	78	\N	t	87	DF1_MAir	[DF1 Major Airports (DF1_MAir)]	1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	10	1	2	75	\N	0	\N	\N	1	1	2	f	75	\N	\N
2	214	1	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
3	209	2	2	2859	\N	2859	\N	\N	1	1	2	f	0	\N	\N
4	209	2	1	2855	\N	2855	\N	\N	1	1	2	f	\N	209	\N
5	8	3	2	19016	\N	0	\N	\N	1	1	2	f	19016	\N	\N
6	97	3	2	75	\N	0	\N	\N	2	1	2	f	75	\N	\N
7	252	4	2	37980	\N	37980	\N	\N	1	1	2	f	0	248	\N
8	7	4	2	37956	\N	37956	\N	\N	0	1	2	f	0	248	\N
9	247	4	2	23277	\N	23277	\N	\N	0	1	2	f	0	248	\N
10	120	4	2	9	\N	9	\N	\N	0	1	2	f	0	248	\N
11	14	4	2	1	\N	1	\N	\N	0	1	2	f	0	248	\N
12	57	4	2	1	\N	1	\N	\N	0	1	2	f	0	248	\N
13	129	4	2	1	\N	1	\N	\N	0	1	2	f	0	129	\N
14	248	4	1	37976	\N	37976	\N	\N	1	1	2	f	\N	252	\N
15	7	4	1	37953	\N	37953	\N	\N	0	1	2	f	\N	252	\N
16	247	4	1	28467	\N	28467	\N	\N	0	1	2	f	\N	252	\N
17	129	4	1	14	\N	14	\N	\N	0	1	2	f	\N	252	\N
18	120	4	1	1	\N	1	\N	\N	0	1	2	f	\N	252	\N
19	174	5	2	9045	\N	9045	\N	\N	1	1	2	f	0	154	\N
20	107	5	2	1165	\N	1165	\N	\N	2	1	2	f	0	154	\N
21	87	5	2	6	\N	6	\N	\N	0	1	2	f	0	154	\N
22	7	5	2	2	\N	2	\N	\N	0	1	2	f	0	154	\N
23	154	5	1	10204	\N	10204	\N	\N	1	1	2	f	\N	\N	\N
24	92	9	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
25	83	13	2	3637	\N	0	\N	\N	1	1	2	f	3637	\N	\N
26	37	13	2	786	\N	0	\N	\N	2	1	2	f	786	\N	\N
27	107	14	2	1236	\N	1236	\N	\N	1	1	2	f	0	\N	\N
28	87	14	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
29	7	14	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
30	8	14	1	105	\N	105	\N	\N	1	1	2	f	\N	107	\N
31	14	15	2	3221	\N	0	\N	\N	1	1	2	f	3221	\N	\N
32	7	15	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
33	247	15	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
34	248	15	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
35	101	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
36	252	15	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
37	235	16	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
38	56	16	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
39	8	17	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
40	235	18	2	32485	\N	0	\N	\N	1	1	2	f	32485	\N	\N
41	56	18	2	32485	\N	0	\N	\N	0	1	2	f	32485	\N	\N
42	220	19	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
43	128	20	2	168	\N	0	\N	\N	1	1	2	f	168	\N	\N
44	181	21	2	2729	\N	0	\N	\N	1	1	2	f	2729	\N	\N
45	56	21	2	2729	\N	0	\N	\N	0	1	2	f	2729	\N	\N
46	128	23	2	225	\N	0	\N	\N	1	1	2	f	225	\N	\N
47	248	24	2	149314	\N	149314	\N	\N	1	1	2	f	0	\N	\N
48	7	24	2	149207	\N	149207	\N	\N	0	1	2	f	0	\N	\N
49	247	24	2	111244	\N	111244	\N	\N	0	1	2	f	0	\N	\N
50	129	24	2	21	\N	21	\N	\N	0	1	2	f	0	120	\N
51	14	24	2	5	\N	5	\N	\N	0	1	2	f	0	120	\N
52	87	24	2	4	\N	4	\N	\N	0	1	2	f	0	120	\N
53	103	24	2	1	\N	1	\N	\N	0	1	2	f	0	246	\N
54	120	24	2	1	\N	1	\N	\N	0	1	2	f	0	120	\N
55	7	24	1	148714	\N	148714	\N	\N	1	1	2	f	\N	248	\N
56	246	24	1	148556	\N	148556	\N	\N	0	1	2	f	\N	248	\N
57	120	24	1	129084	\N	129084	\N	\N	0	1	2	f	\N	248	\N
58	231	24	1	3684	\N	3684	\N	\N	0	1	2	f	\N	248	\N
59	11	24	1	1466	\N	1466	\N	\N	0	1	2	f	\N	248	\N
60	34	24	1	100	\N	100	\N	\N	0	1	2	f	\N	248	\N
61	58	24	1	96	\N	96	\N	\N	0	1	2	f	\N	248	\N
62	81	24	1	93	\N	93	\N	\N	0	1	2	f	\N	248	\N
63	211	24	1	46	\N	46	\N	\N	0	1	2	f	\N	248	\N
64	204	24	1	40	\N	40	\N	\N	0	1	2	f	\N	248	\N
65	129	24	1	22	\N	22	\N	\N	0	1	2	f	\N	248	\N
66	123	24	1	4	\N	4	\N	\N	0	1	2	f	\N	248	\N
67	247	24	1	1	\N	1	\N	\N	0	1	2	f	\N	248	\N
68	102	25	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
69	172	25	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
70	7	25	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
71	34	26	2	269	\N	0	\N	\N	1	1	2	f	269	\N	\N
72	120	26	2	269	\N	0	\N	\N	0	1	2	f	269	\N	\N
73	7	26	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
74	246	26	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
75	172	27	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
76	79	28	2	56843	\N	56843	\N	\N	1	1	2	f	0	\N	\N
77	8	28	1	53503	\N	53503	\N	\N	1	1	2	f	\N	79	\N
78	29	29	2	53	\N	0	\N	\N	1	1	2	f	53	\N	\N
79	82	30	2	13691	\N	13691	\N	\N	1	1	2	f	0	\N	\N
80	8	30	1	13613	\N	13613	\N	\N	1	1	2	f	\N	82	\N
81	176	31	2	9172	\N	1	\N	\N	1	1	2	f	0	78	\N
82	262	31	2	1	\N	\N	\N	\N	1	1	2	f	0	78	\N
83	78	31	1	9173	\N	9173	\N	\N	1	1	2	f	\N	\N	\N
84	145	32	2	1891809	\N	0	\N	\N	1	1	2	f	1891809	\N	\N
85	8	33	2	1047	\N	419	\N	\N	1	1	2	f	628	\N	\N
86	8	33	1	419	\N	419	\N	\N	1	1	2	f	\N	8	\N
87	129	34	2	142	\N	0	\N	\N	1	1	2	f	142	\N	\N
88	34	35	2	127	\N	0	\N	\N	1	1	2	f	127	\N	\N
89	120	35	2	127	\N	0	\N	\N	0	1	2	f	127	\N	\N
90	7	35	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
91	246	35	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
92	205	38	2	222686	\N	222686	\N	\N	1	1	2	f	0	196	\N
93	196	38	1	222686	\N	222686	\N	\N	1	1	2	f	\N	205	\N
94	253	39	2	3598	\N	3598	\N	\N	1	1	2	f	0	8	\N
95	8	39	1	3598	\N	3598	\N	\N	1	1	2	f	\N	253	\N
96	10	40	2	74	\N	74	\N	\N	1	1	2	f	0	\N	\N
97	250	40	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
98	214	40	2	73	\N	73	\N	\N	0	1	2	f	0	\N	\N
99	251	40	1	2	\N	2	\N	\N	1	1	2	f	\N	250	\N
100	113	41	2	479066	\N	479066	\N	\N	1	1	2	f	0	59	\N
101	112	41	2	411336	\N	411336	\N	\N	0	1	2	f	0	59	\N
102	59	41	1	479066	\N	479066	\N	\N	1	1	2	f	\N	113	\N
103	181	42	2	5230	\N	0	\N	\N	1	1	2	f	5230	\N	\N
104	56	42	2	5230	\N	0	\N	\N	0	1	2	f	5230	\N	\N
105	235	43	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
106	56	43	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
107	8	44	2	798	\N	0	\N	\N	1	1	2	f	798	\N	\N
108	38	44	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
109	128	45	2	7186	\N	4433	\N	\N	1	1	2	f	2753	\N	\N
110	8	45	1	4433	\N	4433	\N	\N	1	1	2	f	\N	128	\N
111	15	46	2	657	\N	0	\N	\N	1	1	2	f	657	\N	\N
112	215	46	2	197	\N	0	\N	\N	2	1	2	f	197	\N	\N
113	7	46	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
114	102	47	2	45197	\N	0	\N	\N	1	1	2	f	45197	\N	\N
115	7	47	2	45140	\N	0	\N	\N	0	1	2	f	45140	\N	\N
116	247	47	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
117	128	48	2	4430	\N	4430	\N	\N	1	1	2	f	0	8	\N
118	8	48	1	4430	\N	4430	\N	\N	1	1	2	f	\N	128	\N
119	128	49	2	7203	\N	0	\N	\N	1	1	2	f	7203	\N	\N
120	11	49	2	4620	\N	0	\N	\N	2	1	2	f	4620	\N	\N
121	211	49	2	2230	\N	0	\N	\N	3	1	2	f	2230	\N	\N
122	120	49	2	4004	\N	0	\N	\N	0	1	2	f	4004	\N	\N
123	7	49	2	3402	\N	0	\N	\N	0	1	2	f	3402	\N	\N
124	246	49	2	3402	\N	0	\N	\N	0	1	2	f	3402	\N	\N
125	37	50	2	7047	\N	0	\N	\N	1	1	2	f	7047	\N	\N
126	58	51	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
127	120	51	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
128	7	51	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
129	246	51	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
130	179	52	2	1925943	\N	1925943	\N	\N	1	1	2	f	0	\N	\N
131	178	52	2	1855886	\N	1855886	\N	\N	2	1	2	f	0	\N	\N
132	35	52	2	1499519	\N	1499519	\N	\N	3	1	2	f	0	\N	\N
133	254	52	2	478636	\N	478636	\N	\N	4	1	2	f	0	\N	\N
134	125	52	2	266220	\N	266220	\N	\N	5	1	2	f	0	\N	\N
135	205	52	2	222475	\N	222475	\N	\N	6	1	2	f	0	\N	\N
136	256	52	2	37226	\N	37226	\N	\N	7	1	2	f	0	\N	\N
137	180	52	2	30959	\N	30959	\N	\N	8	1	2	f	0	\N	\N
138	257	52	2	27017	\N	27017	\N	\N	9	1	2	f	0	\N	\N
139	127	52	2	25693	\N	25693	\N	\N	10	1	2	f	0	\N	\N
140	255	52	2	22653	\N	22653	\N	\N	11	1	2	f	0	\N	\N
141	12	52	2	18214	\N	18214	\N	\N	12	1	2	f	0	\N	\N
142	82	52	2	13689	\N	13689	\N	\N	13	1	2	f	0	\N	\N
143	208	52	2	1536	\N	1536	\N	\N	14	1	2	f	0	\N	\N
144	124	52	2	1512	\N	1512	\N	\N	15	1	2	f	0	\N	\N
145	126	52	2	935	\N	935	\N	\N	16	1	2	f	0	\N	\N
146	176	52	2	61	\N	61	\N	\N	17	1	2	f	0	\N	\N
147	56	52	2	1809636	\N	1809636	\N	\N	0	1	2	f	0	\N	\N
148	100	52	2	1809636	\N	1809636	\N	\N	0	1	2	f	0	\N	\N
149	129	52	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
150	101	52	1	1873557	\N	1873557	\N	\N	1	1	2	f	\N	179	\N
151	249	52	1	1789482	\N	1789482	\N	\N	2	1	2	f	\N	178	\N
152	202	52	1	1477782	\N	1477782	\N	\N	3	1	2	f	\N	35	\N
153	207	52	1	467604	\N	467604	\N	\N	4	1	2	f	\N	254	\N
154	174	52	1	264768	\N	264768	\N	\N	5	1	2	f	\N	125	\N
155	107	52	1	30713	\N	30713	\N	\N	6	1	2	f	\N	\N	\N
156	103	52	1	18242	\N	18242	\N	\N	7	1	2	f	\N	\N	\N
157	130	52	1	13365	\N	13365	\N	\N	8	1	2	f	\N	82	\N
158	13	52	1	10878	\N	10878	\N	\N	9	1	2	f	\N	256	\N
159	56	52	1	1789482	\N	1789482	\N	\N	0	1	2	f	\N	178	\N
160	100	52	1	1789482	\N	1789482	\N	\N	0	1	2	f	\N	178	\N
161	129	52	1	211531	\N	211531	\N	\N	0	1	2	f	\N	\N	\N
162	14	52	1	24763	\N	24763	\N	\N	0	1	2	f	\N	\N	\N
163	87	52	1	20765	\N	20765	\N	\N	0	1	2	f	\N	\N	\N
164	7	52	1	43	\N	43	\N	\N	0	1	2	f	\N	\N	\N
165	16	53	2	282	\N	0	\N	\N	1	1	2	f	282	\N	\N
166	4	54	2	170232	\N	73559	\N	\N	1	1	2	f	96673	\N	\N
167	107	54	1	5006	\N	5006	\N	\N	1	1	2	f	\N	4	\N
168	246	54	1	2961	\N	2961	\N	\N	2	1	2	f	\N	4	\N
169	7	54	1	2961	\N	2961	\N	\N	0	1	2	f	\N	4	\N
170	81	55	2	1008	\N	0	\N	\N	1	1	2	f	1008	\N	\N
171	120	55	2	1008	\N	0	\N	\N	0	1	2	f	1008	\N	\N
172	7	55	2	826	\N	0	\N	\N	0	1	2	f	826	\N	\N
173	246	55	2	826	\N	0	\N	\N	0	1	2	f	826	\N	\N
174	29	56	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
175	48	58	2	457	\N	0	\N	\N	1	1	2	f	457	\N	\N
176	212	59	2	7840	\N	0	\N	\N	1	1	2	f	7840	\N	\N
177	259	59	2	996	\N	0	\N	\N	2	1	2	f	996	\N	\N
178	140	59	2	40	\N	0	\N	\N	3	1	2	f	40	\N	\N
179	63	59	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
180	137	59	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
181	138	59	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
182	161	59	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
183	29	60	2	37	\N	0	\N	\N	1	1	2	f	37	\N	\N
184	15	61	2	505	\N	0	\N	\N	1	1	2	f	505	\N	\N
185	7	61	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
186	16	62	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
187	60	63	2	40828	\N	0	\N	\N	1	1	2	f	40828	\N	\N
188	56	63	2	40828	\N	0	\N	\N	0	1	2	f	40828	\N	\N
189	25	64	2	738	\N	738	\N	\N	1	1	2	f	0	\N	\N
190	192	64	2	246	\N	246	\N	\N	2	1	2	f	0	\N	\N
191	214	66	2	61	\N	0	\N	\N	1	1	2	f	61	\N	\N
192	10	66	2	61	\N	0	\N	\N	0	1	2	f	61	\N	\N
193	88	67	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
194	214	68	2	64	\N	0	\N	\N	1	1	2	f	64	\N	\N
195	10	68	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
196	209	69	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
197	29	70	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
198	128	71	2	6922	\N	0	\N	\N	1	1	2	f	6922	\N	\N
199	250	72	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
200	213	72	1	3	\N	3	\N	\N	1	1	2	f	\N	250	\N
201	215	72	1	2	\N	2	\N	\N	2	1	2	f	\N	250	\N
202	15	72	1	2	\N	2	\N	\N	3	1	2	f	\N	250	\N
203	64	72	1	1	\N	1	\N	\N	4	1	2	f	\N	250	\N
204	175	72	1	1	\N	1	\N	\N	5	1	2	f	\N	250	\N
205	8	72	1	1	\N	1	\N	\N	6	1	2	f	\N	250	\N
206	14	73	2	3054	\N	0	\N	\N	1	1	2	f	3054	\N	\N
207	7	73	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
208	247	73	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
209	248	73	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
210	101	73	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
211	252	73	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
212	124	74	2	1512	\N	1512	\N	\N	1	1	2	f	0	196	\N
213	196	74	1	1512	\N	1512	\N	\N	1	1	2	f	\N	124	\N
214	235	75	2	19043	\N	19043	\N	\N	1	1	2	f	0	\N	\N
215	56	75	2	19043	\N	19043	\N	\N	0	1	2	f	0	\N	\N
216	181	75	1	18516	\N	18516	\N	\N	1	1	2	f	\N	235	\N
217	56	75	1	18516	\N	18516	\N	\N	0	1	2	f	\N	235	\N
218	84	76	2	10189	\N	0	\N	\N	1	1	2	f	10189	\N	\N
219	56	76	2	10189	\N	0	\N	\N	0	1	2	f	10189	\N	\N
220	8	77	2	1194	\N	1194	\N	\N	1	1	2	f	0	\N	\N
221	8	77	1	1182	\N	1182	\N	\N	1	1	2	f	\N	8	\N
222	15	78	2	458	\N	0	\N	\N	1	1	2	f	458	\N	\N
223	7	78	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
224	204	79	2	35	\N	0	\N	\N	1	1	2	f	35	\N	\N
225	120	79	2	35	\N	0	\N	\N	0	1	2	f	35	\N	\N
226	7	79	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
227	246	79	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
228	253	80	2	3078	\N	3078	\N	\N	1	1	2	f	0	8	\N
229	8	80	1	3078	\N	3078	\N	\N	1	1	2	f	\N	253	\N
230	169	81	2	394994	\N	394773	\N	\N	1	1	2	f	221	\N	\N
231	8	81	1	394773	\N	394773	\N	\N	1	1	2	f	\N	169	\N
232	253	82	2	9734	\N	0	\N	\N	1	1	2	f	9734	\N	\N
233	7	87	2	668517	\N	0	\N	\N	1	1	2	f	668517	\N	\N
234	98	87	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
235	251	87	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
236	246	87	2	457855	\N	0	\N	\N	0	1	2	f	457855	\N	\N
237	247	87	2	384648	\N	0	\N	\N	0	1	2	f	384648	\N	\N
238	248	87	2	182533	\N	0	\N	\N	0	1	2	f	182533	\N	\N
239	120	87	2	160239	\N	0	\N	\N	0	1	2	f	160239	\N	\N
240	252	87	2	27935	\N	0	\N	\N	0	1	2	f	27935	\N	\N
241	231	87	2	4211	\N	0	\N	\N	0	1	2	f	4211	\N	\N
242	57	87	2	3821	\N	0	\N	\N	0	1	2	f	3821	\N	\N
243	123	87	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
244	11	87	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
245	102	87	2	229	\N	0	\N	\N	0	1	2	f	229	\N	\N
246	232	87	2	134	\N	0	\N	\N	0	1	2	f	134	\N	\N
247	34	87	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
248	58	87	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
249	81	87	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
250	211	87	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
251	204	87	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
252	129	87	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
253	172	87	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
254	14	87	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
255	87	87	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
256	103	87	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
257	102	89	2	46419	\N	46419	\N	\N	1	1	2	f	0	154	\N
258	7	89	2	46363	\N	46363	\N	\N	0	1	2	f	0	154	\N
259	247	89	2	229	\N	229	\N	\N	0	1	2	f	0	154	\N
260	154	89	1	46333	\N	46333	\N	\N	1	1	2	f	\N	102	\N
261	146	90	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
262	7	91	2	988	\N	0	\N	\N	1	1	2	f	988	\N	\N
263	120	91	2	984	\N	0	\N	\N	0	1	2	f	984	\N	\N
264	246	91	2	979	\N	0	\N	\N	0	1	2	f	979	\N	\N
265	247	91	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
266	15	92	2	255	\N	0	\N	\N	1	1	2	f	255	\N	\N
267	215	92	2	160	\N	0	\N	\N	2	1	2	f	160	\N	\N
268	7	92	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
269	206	93	2	67	\N	41	\N	\N	1	1	2	f	26	\N	\N
270	67	93	1	41	\N	41	\N	\N	1	1	2	f	\N	206	\N
271	233	94	2	2367115	\N	2367115	\N	\N	1	1	2	f	0	177	\N
272	177	94	1	2367115	\N	2367115	\N	\N	1	1	2	f	\N	233	\N
273	258	95	2	253	\N	253	\N	\N	1	1	2	f	0	\N	\N
274	213	95	2	246	\N	246	\N	\N	2	1	2	f	0	\N	\N
275	56	95	2	253	\N	253	\N	\N	0	1	2	f	0	\N	\N
276	120	96	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
277	7	96	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
278	246	96	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
279	219	97	2	150682	\N	0	\N	\N	1	1	2	f	150682	\N	\N
280	12	98	2	18217	\N	0	\N	\N	1	1	2	f	18217	\N	\N
281	238	98	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
282	129	98	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
283	204	99	2	1177	\N	1177	\N	\N	1	1	2	f	0	\N	\N
284	120	99	2	1177	\N	1177	\N	\N	0	1	2	f	0	\N	\N
285	7	99	2	1171	\N	1171	\N	\N	0	1	2	f	0	\N	\N
286	246	99	2	1171	\N	1171	\N	\N	0	1	2	f	0	\N	\N
287	8	100	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
288	7	100	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
289	30	101	2	2	\N	2	\N	\N	1	1	2	f	0	228	\N
290	228	101	1	2	\N	2	\N	\N	1	1	2	f	\N	30	\N
291	253	102	2	16911	\N	16911	\N	\N	1	1	2	f	0	\N	\N
292	231	102	2	34	\N	34	\N	\N	2	1	2	f	0	\N	\N
293	120	102	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
294	7	102	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
295	246	102	2	33	\N	33	\N	\N	0	1	2	f	0	\N	\N
296	212	103	2	2610	\N	2610	\N	\N	1	1	2	f	0	212	\N
297	212	103	1	2610	\N	2610	\N	\N	1	1	2	f	\N	212	\N
298	27	104	2	4759	\N	4759	\N	\N	1	1	2	f	0	\N	\N
299	13	104	1	1628	\N	1628	\N	\N	1	1	2	f	\N	27	\N
300	116	106	2	1054932	\N	0	\N	\N	1	1	2	f	1054932	\N	\N
301	143	107	2	927	\N	0	\N	\N	1	1	2	f	927	\N	\N
302	44	110	2	4314	\N	0	\N	\N	1	1	2	f	4314	\N	\N
303	56	110	2	4277	\N	0	\N	\N	0	1	2	f	4277	\N	\N
304	253	111	2	4836	\N	0	\N	\N	1	1	2	f	4836	\N	\N
305	167	112	2	24710	\N	24710	\N	\N	1	1	2	f	0	8	\N
306	208	112	2	1523	\N	1523	\N	\N	2	1	2	f	0	8	\N
307	8	112	1	26233	\N	26233	\N	\N	1	1	2	f	\N	\N	\N
308	88	113	2	935516	\N	935516	\N	\N	1	1	2	f	0	\N	\N
309	174	113	1	767741	\N	767741	\N	\N	1	1	2	f	\N	88	\N
310	81	114	2	218	\N	0	\N	\N	1	1	2	f	218	\N	\N
311	120	114	2	218	\N	0	\N	\N	0	1	2	f	218	\N	\N
312	7	114	2	176	\N	0	\N	\N	0	1	2	f	176	\N	\N
313	246	114	2	176	\N	0	\N	\N	0	1	2	f	176	\N	\N
314	92	115	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
315	27	116	2	3520	\N	1662	\N	\N	1	1	2	f	1858	\N	\N
316	107	116	1	661	\N	661	\N	\N	1	1	2	f	\N	27	\N
317	246	116	1	360	\N	360	\N	\N	2	1	2	f	\N	27	\N
318	7	116	1	360	\N	360	\N	\N	0	1	2	f	\N	27	\N
319	209	117	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
320	129	118	2	89214	\N	89214	\N	\N	1	1	2	f	0	\N	\N
321	7	118	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
322	207	118	2	35	\N	35	\N	\N	0	1	2	f	0	8	\N
404	109	148	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
323	248	118	2	25	\N	25	\N	\N	0	1	2	f	0	8	\N
324	177	118	2	21	\N	21	\N	\N	0	1	2	f	0	8	\N
325	12	118	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
326	127	118	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
327	120	118	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
328	246	118	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
329	247	118	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
330	59	118	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
331	252	118	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
332	8	118	1	88407	\N	88407	\N	\N	1	1	2	f	\N	129	\N
333	37	119	2	78596	\N	0	\N	\N	1	1	2	f	78596	\N	\N
334	60	119	2	40828	\N	0	\N	\N	2	1	2	f	40828	\N	\N
335	105	119	2	550	\N	0	\N	\N	3	1	2	f	550	\N	\N
336	56	119	2	40828	\N	0	\N	\N	0	1	2	f	40828	\N	\N
337	150	119	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
338	246	120	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
339	7	120	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
340	120	120	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
341	204	121	2	4430	\N	4430	\N	\N	1	1	2	f	0	\N	\N
342	120	121	2	4430	\N	4430	\N	\N	0	1	2	f	0	\N	\N
343	7	121	2	4376	\N	4376	\N	\N	0	1	2	f	0	\N	\N
344	246	121	2	4376	\N	4376	\N	\N	0	1	2	f	0	\N	\N
345	214	122	2	41	\N	41	\N	\N	1	1	2	f	0	\N	\N
346	10	122	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
347	258	123	2	477	\N	477	\N	\N	1	1	2	f	0	\N	\N
348	56	123	2	477	\N	477	\N	\N	0	1	2	f	0	\N	\N
349	234	124	2	19971	\N	19971	\N	\N	1	1	2	f	0	133	\N
350	56	124	2	19971	\N	19971	\N	\N	0	1	2	f	0	133	\N
351	133	124	1	19971	\N	19971	\N	\N	1	1	2	f	\N	234	\N
352	69	125	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
353	102	126	2	46371	\N	0	\N	\N	1	1	2	f	46371	\N	\N
354	7	126	2	46315	\N	0	\N	\N	0	1	2	f	46315	\N	\N
355	247	126	2	229	\N	0	\N	\N	0	1	2	f	229	\N	\N
356	123	127	2	208	\N	208	\N	\N	1	1	2	f	0	\N	\N
357	47	127	2	1	\N	1	\N	\N	2	1	2	f	0	47	\N
358	163	127	2	1	\N	1	\N	\N	0	1	2	f	0	47	\N
359	33	127	1	197	\N	197	\N	\N	1	1	2	f	\N	123	\N
360	47	127	1	1	\N	1	\N	\N	2	1	2	f	\N	47	\N
361	163	127	1	1	\N	1	\N	\N	0	1	2	f	\N	47	\N
362	253	129	2	608	\N	0	\N	\N	1	1	2	f	608	\N	\N
363	209	130	2	329	\N	0	\N	\N	1	1	2	f	329	\N	\N
364	120	131	2	166	\N	\N	\N	\N	1	1	2	f	166	\N	\N
365	172	131	2	9	\N	3	\N	\N	2	1	2	f	6	\N	\N
366	7	131	2	166	\N	\N	\N	\N	0	1	2	f	166	\N	\N
367	246	131	2	166	\N	\N	\N	\N	0	1	2	f	166	\N	\N
368	8	132	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
369	7	132	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
370	81	133	2	135	\N	0	\N	\N	1	1	2	f	135	\N	\N
371	120	133	2	135	\N	0	\N	\N	0	1	2	f	135	\N	\N
372	7	133	2	100	\N	0	\N	\N	0	1	2	f	100	\N	\N
373	246	133	2	100	\N	0	\N	\N	0	1	2	f	100	\N	\N
374	79	134	2	49112	\N	49112	\N	\N	1	1	2	f	0	\N	\N
375	8	134	1	49039	\N	49039	\N	\N	1	1	2	f	\N	\N	\N
376	33	134	1	6	\N	6	\N	\N	2	1	2	f	\N	79	\N
377	174	135	2	2501	\N	0	\N	\N	1	1	2	f	2501	\N	\N
378	58	136	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
379	120	136	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
380	7	136	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
381	246	136	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
382	38	136	1	58	\N	58	\N	\N	1	1	2	f	\N	58	\N
383	8	136	1	58	\N	58	\N	\N	0	1	2	f	\N	58	\N
384	246	137	2	258	\N	0	\N	\N	1	1	2	f	258	\N	\N
385	133	137	2	202	\N	0	\N	\N	2	1	2	f	202	\N	\N
386	7	137	2	258	\N	0	\N	\N	0	1	2	f	258	\N	\N
387	120	137	2	253	\N	0	\N	\N	0	1	2	f	253	\N	\N
388	6	138	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
389	241	139	2	114979	\N	114979	\N	\N	1	1	2	f	0	\N	\N
390	60	139	2	40831	\N	40831	\N	\N	2	1	2	f	0	\N	\N
391	56	139	2	40831	\N	40831	\N	\N	0	1	2	f	0	\N	\N
392	120	140	2	59	\N	0	\N	\N	1	1	2	f	59	\N	\N
393	247	140	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
394	7	140	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
395	246	140	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
396	253	141	2	16569	\N	10566	\N	\N	1	1	2	f	6003	\N	\N
397	8	141	1	10566	\N	10566	\N	\N	1	1	2	f	\N	253	\N
398	29	142	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
399	102	144	2	45225	\N	0	\N	\N	1	1	2	f	45225	\N	\N
400	7	144	2	45168	\N	0	\N	\N	0	1	2	f	45168	\N	\N
401	247	144	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
402	29	146	2	53	\N	0	\N	\N	1	1	2	f	53	\N	\N
403	209	147	2	210	\N	0	\N	\N	1	1	2	f	210	\N	\N
405	35	149	2	805852	\N	805852	\N	\N	1	1	2	f	0	8	\N
406	8	149	1	805852	\N	805852	\N	\N	1	1	2	f	\N	35	\N
407	209	150	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
408	167	151	2	2493	\N	2493	\N	\N	1	1	2	f	0	177	\N
409	177	151	1	2493	\N	2493	\N	\N	1	1	2	f	\N	167	\N
410	58	152	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
411	120	152	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
412	7	152	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
413	246	152	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
414	258	153	2	834	\N	834	\N	\N	1	1	2	f	0	\N	\N
415	56	153	2	754	\N	754	\N	\N	0	1	2	f	0	\N	\N
416	258	153	1	376	\N	376	\N	\N	1	1	2	f	\N	258	\N
417	56	153	1	355	\N	355	\N	\N	0	1	2	f	\N	258	\N
418	210	154	2	36540	\N	36540	\N	\N	1	1	2	f	0	\N	\N
419	235	154	1	36534	\N	36534	\N	\N	1	1	2	f	\N	210	\N
420	56	154	1	36534	\N	36534	\N	\N	0	1	2	f	\N	210	\N
421	253	155	2	16467	\N	10513	\N	\N	1	1	2	f	5954	\N	\N
422	128	155	2	7125	\N	4432	\N	\N	2	1	2	f	2693	\N	\N
423	8	155	1	14851	\N	14851	\N	\N	1	1	2	f	\N	\N	\N
424	181	156	2	1552	\N	0	\N	\N	1	1	2	f	1552	\N	\N
425	56	156	2	1552	\N	0	\N	\N	0	1	2	f	1552	\N	\N
426	159	157	2	225	\N	0	\N	\N	1	1	2	f	225	\N	\N
427	231	158	2	6930	\N	0	\N	\N	1	1	2	f	6930	\N	\N
428	11	158	2	2846	\N	0	\N	\N	2	1	2	f	2846	\N	\N
429	81	158	2	78	\N	0	\N	\N	3	1	2	f	78	\N	\N
430	120	158	2	78	\N	0	\N	\N	0	1	2	f	78	\N	\N
431	7	158	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
432	246	158	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
433	231	159	2	6930	\N	0	\N	\N	1	1	2	f	6930	\N	\N
434	11	159	2	2846	\N	0	\N	\N	2	1	2	f	2846	\N	\N
435	81	159	2	46	\N	0	\N	\N	3	1	2	f	46	\N	\N
436	120	159	2	46	\N	0	\N	\N	0	1	2	f	46	\N	\N
437	7	159	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
438	246	159	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
439	216	160	2	138	\N	0	\N	\N	1	1	2	f	138	\N	\N
440	38	161	2	68	\N	0	\N	\N	1	1	2	f	68	\N	\N
441	39	161	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
442	8	161	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
443	99	161	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
444	48	162	2	482	\N	0	\N	\N	1	1	2	f	482	\N	\N
445	196	163	2	90830	\N	0	\N	\N	1	1	2	f	90830	\N	\N
446	111	164	2	611	\N	0	\N	\N	1	1	2	f	611	\N	\N
447	154	165	2	69	\N	0	\N	\N	1	1	2	f	69	\N	\N
448	209	166	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
449	92	167	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
450	109	168	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
451	8	169	2	162	\N	0	\N	\N	1	1	2	f	162	\N	\N
452	29	170	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
453	7	171	2	832539	\N	832539	\N	\N	1	1	2	f	0	\N	\N
454	98	171	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
455	246	171	2	522840	\N	522840	\N	\N	0	1	2	f	0	\N	\N
456	247	171	2	386087	\N	386087	\N	\N	0	1	2	f	0	\N	\N
457	248	171	2	228197	\N	228197	\N	\N	0	1	2	f	0	\N	\N
458	120	171	2	160229	\N	160229	\N	\N	0	1	2	f	0	\N	\N
459	102	171	2	44798	\N	44798	\N	\N	0	1	2	f	0	\N	\N
460	252	171	2	36753	\N	36753	\N	\N	0	1	2	f	0	\N	\N
461	231	171	2	4211	\N	4211	\N	\N	0	1	2	f	0	\N	\N
462	57	171	2	3821	\N	3821	\N	\N	0	1	2	f	0	\N	\N
463	123	171	2	2872	\N	2872	\N	\N	0	1	2	f	0	\N	\N
464	11	171	2	1774	\N	1774	\N	\N	0	1	2	f	0	\N	\N
465	107	171	2	624	\N	624	\N	\N	0	1	2	f	0	\N	\N
466	232	171	2	134	\N	134	\N	\N	0	1	2	f	0	\N	\N
467	34	171	2	70	\N	70	\N	\N	0	1	2	f	0	\N	\N
468	58	171	2	65	\N	65	\N	\N	0	1	2	f	0	\N	\N
469	81	171	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
470	129	171	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
471	211	171	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
472	204	171	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
473	87	171	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
474	172	171	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
475	14	171	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
476	8	171	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
477	103	171	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
478	7	171	1	56	\N	56	\N	\N	1	1	2	f	\N	\N	\N
479	102	171	1	53	\N	53	\N	\N	0	1	2	f	\N	\N	\N
480	248	171	1	7	\N	7	\N	\N	0	1	2	f	\N	247	\N
481	247	171	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
482	15	172	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
483	235	173	2	36012	\N	0	\N	\N	1	1	2	f	36012	\N	\N
484	56	173	2	36012	\N	0	\N	\N	0	1	2	f	36012	\N	\N
485	127	174	2	16679	\N	16679	\N	\N	1	1	2	f	0	114	\N
486	129	174	2	2	\N	2	\N	\N	0	1	2	f	0	114	\N
487	114	174	1	16679	\N	16679	\N	\N	1	1	2	f	\N	127	\N
488	60	175	2	40824	\N	0	\N	\N	1	1	2	f	40824	\N	\N
489	56	175	2	40824	\N	0	\N	\N	0	1	2	f	40824	\N	\N
490	141	176	2	384	\N	0	\N	\N	1	1	2	f	384	\N	\N
491	269	176	2	165	\N	0	\N	\N	2	1	2	f	165	\N	\N
492	235	177	2	311	\N	0	\N	\N	1	1	2	f	311	\N	\N
493	56	177	2	311	\N	0	\N	\N	0	1	2	f	311	\N	\N
494	99	178	2	40646	\N	40646	\N	\N	1	1	2	f	0	\N	\N
495	8	178	2	468	\N	468	\N	\N	2	1	2	f	0	8	\N
496	239	178	2	10517	\N	10517	\N	\N	0	1	2	f	0	8	\N
497	185	178	2	5593	\N	5593	\N	\N	0	1	2	f	0	8	\N
498	39	178	2	421	\N	421	\N	\N	0	1	2	f	0	38	\N
499	139	178	2	32	\N	32	\N	\N	0	1	2	f	0	185	\N
500	8	178	1	41037	\N	41037	\N	\N	1	1	2	f	\N	\N	\N
501	99	178	1	74	\N	74	\N	\N	2	1	2	f	\N	99	\N
502	38	178	1	421	\N	421	\N	\N	0	1	2	f	\N	39	\N
503	185	178	1	64	\N	64	\N	\N	0	1	2	f	\N	99	\N
504	139	178	1	4	\N	4	\N	\N	0	1	2	f	\N	99	\N
505	102	179	2	157	\N	0	\N	\N	1	1	2	f	157	\N	\N
506	7	179	2	157	\N	0	\N	\N	0	1	2	f	157	\N	\N
507	58	180	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
508	120	180	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
509	7	180	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
510	246	180	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
511	133	181	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
512	253	182	2	10491	\N	0	\N	\N	1	1	2	f	10491	\N	\N
513	253	183	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
514	128	183	2	2767	\N	0	\N	\N	2	1	2	f	2767	\N	\N
515	78	184	2	1961393	\N	0	\N	\N	1	1	2	f	1961393	\N	\N
516	202	185	2	36128	\N	36128	\N	\N	1	1	2	f	0	8	\N
517	8	185	1	36128	\N	36128	\N	\N	1	1	2	f	\N	202	\N
518	242	186	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
519	167	187	2	25693	\N	25693	\N	\N	1	1	2	f	0	177	\N
520	177	187	1	25693	\N	25693	\N	\N	1	1	2	f	\N	167	\N
521	129	187	1	10	\N	10	\N	\N	0	1	2	f	\N	167	\N
522	128	188	2	168	\N	0	\N	\N	1	1	2	f	168	\N	\N
523	246	189	2	49	\N	0	\N	\N	1	1	2	f	49	\N	\N
524	7	189	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
525	120	189	2	47	\N	0	\N	\N	0	1	2	f	47	\N	\N
526	120	190	2	4002	\N	4002	\N	\N	1	1	2	f	0	\N	\N
527	7	190	2	3400	\N	3400	\N	\N	0	1	2	f	0	\N	\N
528	246	190	2	3400	\N	3400	\N	\N	0	1	2	f	0	\N	\N
529	211	190	2	2228	\N	2228	\N	\N	0	1	2	f	0	\N	\N
530	11	190	2	1774	\N	1774	\N	\N	0	1	2	f	0	\N	\N
531	157	191	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
532	250	192	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
533	247	192	1	1	\N	1	\N	\N	1	1	2	f	\N	250	\N
534	253	193	2	13972	\N	7715	\N	\N	1	1	2	f	6257	\N	\N
535	174	194	2	1737	\N	1737	\N	\N	1	1	2	f	0	\N	\N
536	8	194	1	1708	\N	1708	\N	\N	1	1	2	f	\N	174	\N
537	33	194	1	6	\N	6	\N	\N	2	1	2	f	\N	174	\N
538	73	195	2	486612	\N	0	\N	\N	1	1	2	f	486612	\N	\N
539	101	196	2	35830	\N	35830	\N	\N	1	1	2	f	0	\N	\N
540	8	196	1	35468	\N	35468	\N	\N	1	1	2	f	\N	101	\N
541	33	196	1	30	\N	30	\N	\N	2	1	2	f	\N	101	\N
542	7	197	2	753536	\N	0	\N	\N	1	1	2	f	753536	\N	\N
543	246	197	2	523577	\N	0	\N	\N	0	1	2	f	523577	\N	\N
544	247	197	2	331366	\N	0	\N	\N	0	1	2	f	331366	\N	\N
545	248	197	2	230241	\N	0	\N	\N	0	1	2	f	230241	\N	\N
546	120	197	2	156250	\N	0	\N	\N	0	1	2	f	156250	\N	\N
547	231	197	2	3865	\N	0	\N	\N	0	1	2	f	3865	\N	\N
548	57	197	2	3454	\N	0	\N	\N	0	1	2	f	3454	\N	\N
549	123	197	2	2850	\N	0	\N	\N	0	1	2	f	2850	\N	\N
550	11	197	2	1675	\N	0	\N	\N	0	1	2	f	1675	\N	\N
551	232	197	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
552	34	197	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
553	58	197	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
554	129	197	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
555	81	197	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
556	204	197	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
557	211	197	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
558	87	197	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
559	14	197	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
560	103	197	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
561	120	198	2	182	\N	0	\N	\N	1	1	2	f	182	\N	\N
562	7	198	2	182	\N	0	\N	\N	0	1	2	f	182	\N	\N
563	246	198	2	182	\N	0	\N	\N	0	1	2	f	182	\N	\N
564	133	199	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
565	250	200	2	21	\N	21	\N	\N	1	1	2	f	\N	\N	\N
566	33	200	2	4	\N	\N	\N	\N	2	1	2	f	4	\N	\N
567	8	200	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
568	8	201	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
569	7	201	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
570	128	202	2	36923	\N	36923	\N	\N	1	1	2	f	0	\N	\N
571	237	204	2	111996	\N	111996	\N	\N	1	1	2	f	0	\N	\N
572	263	205	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
573	15	206	2	344	\N	344	\N	\N	1	1	2	f	0	214	\N
574	7	206	2	1	\N	1	\N	\N	0	1	2	f	0	214	\N
575	214	206	1	344	\N	344	\N	\N	1	1	2	f	\N	15	\N
576	10	206	1	344	\N	344	\N	\N	0	1	2	f	\N	15	\N
577	13	207	2	1291	\N	1291	\N	\N	1	1	2	f	0	\N	\N
578	8	207	1	1285	\N	1285	\N	\N	1	1	2	f	\N	13	\N
579	265	209	2	85	\N	\N	\N	\N	1	1	2	f	85	\N	\N
580	250	209	2	77	\N	77	\N	\N	2	1	2	f	\N	\N	\N
581	98	209	2	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
582	251	209	2	1	\N	1	\N	\N	4	1	2	f	\N	10	\N
583	33	209	2	1	\N	1	\N	\N	5	1	2	f	\N	\N	\N
584	10	209	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
585	214	209	1	5	\N	5	\N	\N	0	1	2	f	\N	250	\N
586	51	210	2	119	\N	0	\N	\N	1	1	2	f	119	\N	\N
587	224	211	2	1471424	\N	0	\N	\N	1	1	2	f	1471424	\N	\N
588	48	212	2	385	\N	0	\N	\N	1	1	2	f	385	\N	\N
589	172	213	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
590	95	214	2	18	\N	0	\N	\N	1	1	2	f	18	\N	\N
591	42	215	2	25252	\N	0	\N	\N	1	1	2	f	25252	\N	\N
592	56	215	2	25252	\N	0	\N	\N	0	1	2	f	25252	\N	\N
593	8	216	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
594	27	217	2	85327	\N	85327	\N	\N	1	1	2	f	0	\N	\N
595	249	217	1	83954	\N	83954	\N	\N	1	1	2	f	\N	27	\N
596	174	217	1	17	\N	17	\N	\N	2	1	2	f	\N	27	\N
597	56	217	1	83954	\N	83954	\N	\N	0	1	2	f	\N	27	\N
598	100	217	1	83954	\N	83954	\N	\N	0	1	2	f	\N	27	\N
599	235	218	2	4288	\N	0	\N	\N	1	1	2	f	4288	\N	\N
600	56	218	2	4288	\N	0	\N	\N	0	1	2	f	4288	\N	\N
601	44	219	2	2433	\N	0	\N	\N	1	1	2	f	2433	\N	\N
602	56	219	2	2433	\N	0	\N	\N	0	1	2	f	2433	\N	\N
603	172	220	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
604	84	221	2	36450	\N	0	\N	\N	1	1	2	f	36450	\N	\N
605	56	221	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
606	174	222	2	9545	\N	0	\N	\N	1	1	2	f	9545	\N	\N
607	246	223	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
608	7	223	2	30	\N	0	\N	\N	0	1	2	f	30	\N	\N
609	120	223	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
610	44	224	2	2708	\N	0	\N	\N	1	1	2	f	2708	\N	\N
611	56	224	2	2708	\N	0	\N	\N	0	1	2	f	2708	\N	\N
612	204	225	2	52	\N	52	\N	\N	1	1	2	f	0	\N	\N
613	120	225	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
614	7	225	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
615	246	225	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
616	69	226	2	208	\N	0	\N	\N	1	1	2	f	208	\N	\N
617	70	226	2	38	\N	0	\N	\N	2	1	2	f	38	\N	\N
618	30	227	2	2	\N	2	\N	\N	1	1	2	f	0	228	\N
619	228	227	1	2	\N	2	\N	\N	1	1	2	f	\N	30	\N
620	228	228	2	8	\N	8	\N	\N	1	1	2	f	0	29	\N
621	29	228	1	8	\N	8	\N	\N	1	1	2	f	\N	228	\N
622	180	229	2	30841	\N	30841	\N	\N	1	1	2	f	0	\N	\N
623	8	229	1	1404	\N	1404	\N	\N	1	1	2	f	\N	180	\N
624	73	230	2	1468616	\N	1468616	\N	\N	1	1	2	f	0	\N	\N
625	197	230	2	3	\N	3	\N	\N	0	1	2	f	0	249	\N
626	249	230	1	1439470	\N	1439470	\N	\N	1	1	2	f	\N	73	\N
627	56	230	1	1439470	\N	1439470	\N	\N	0	1	2	f	\N	73	\N
628	100	230	1	1439470	\N	1439470	\N	\N	0	1	2	f	\N	73	\N
629	111	231	2	611	\N	611	\N	\N	1	1	2	f	0	\N	\N
630	157	232	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
631	33	233	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
632	209	234	2	940	\N	0	\N	\N	1	1	2	f	940	\N	\N
633	8	235	2	162	\N	0	\N	\N	1	1	2	f	162	\N	\N
634	127	236	2	19363	\N	19363	\N	\N	1	1	2	f	0	240	\N
635	240	236	1	19363	\N	19363	\N	\N	1	1	2	f	\N	127	\N
636	209	237	2	1158	\N	0	\N	\N	1	1	2	f	1158	\N	\N
637	240	238	2	291	\N	0	\N	\N	1	1	2	f	291	\N	\N
638	117	239	2	15841	\N	15841	\N	\N	1	1	2	f	0	\N	\N
639	234	239	1	8723	\N	8723	\N	\N	1	1	2	f	\N	117	\N
640	180	239	1	5726	\N	5726	\N	\N	2	1	2	f	\N	117	\N
641	7	239	1	813	\N	813	\N	\N	3	1	2	f	\N	117	\N
642	53	239	1	612	\N	612	\N	\N	4	1	2	f	\N	117	\N
643	56	239	1	8723	\N	8723	\N	\N	0	1	2	f	\N	117	\N
644	246	239	1	784	\N	784	\N	\N	0	1	2	f	\N	117	\N
645	120	239	1	779	\N	779	\N	\N	0	1	2	f	\N	117	\N
646	247	239	1	1	\N	1	\N	\N	0	1	2	f	\N	117	\N
647	69	240	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
648	29	241	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
649	162	242	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
650	45	243	2	13546	\N	0	\N	\N	1	1	2	f	13546	\N	\N
651	84	244	2	6601	\N	0	\N	\N	1	1	2	f	6601	\N	\N
652	56	244	2	6601	\N	0	\N	\N	0	1	2	f	6601	\N	\N
653	156	245	2	411027	\N	0	\N	\N	1	1	2	f	411027	\N	\N
654	253	247	2	40033	\N	40033	\N	\N	1	1	2	f	0	\N	\N
655	88	248	2	935728	\N	0	\N	\N	1	1	2	f	935728	\N	\N
656	84	249	2	4324	\N	0	\N	\N	1	1	2	f	4324	\N	\N
657	56	249	2	4324	\N	0	\N	\N	0	1	2	f	4324	\N	\N
658	115	250	2	234	\N	0	\N	\N	1	1	2	f	234	\N	\N
659	254	251	2	1	\N	1	\N	\N	1	1	2	f	0	262	\N
660	262	251	1	1	\N	1	\N	\N	1	1	2	f	\N	254	\N
661	69	252	2	208	\N	0	\N	\N	1	1	2	f	208	\N	\N
662	92	253	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
663	75	254	2	3077	\N	0	\N	\N	1	1	2	f	3077	\N	\N
664	48	255	2	589	\N	0	\N	\N	1	1	2	f	589	\N	\N
665	170	256	2	873162	\N	0	\N	\N	1	1	2	f	873162	\N	\N
666	179	256	2	38145	\N	0	\N	\N	2	1	2	f	38145	\N	\N
667	35	256	2	37339	\N	0	\N	\N	3	1	2	f	37339	\N	\N
668	178	256	2	37186	\N	0	\N	\N	4	1	2	f	37186	\N	\N
669	257	256	2	26915	\N	0	\N	\N	5	1	2	f	26915	\N	\N
670	127	256	2	25692	\N	0	\N	\N	6	1	2	f	25692	\N	\N
671	75	256	2	4704	\N	0	\N	\N	7	1	2	f	4704	\N	\N
672	143	256	2	1768	\N	0	\N	\N	8	1	2	f	1768	\N	\N
673	256	256	2	1315	\N	0	\N	\N	9	1	2	f	1315	\N	\N
674	36	256	2	1121	\N	0	\N	\N	10	1	2	f	1121	\N	\N
675	56	256	2	37186	\N	0	\N	\N	0	1	2	f	37186	\N	\N
676	100	256	2	37186	\N	0	\N	\N	0	1	2	f	37186	\N	\N
677	129	256	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
678	26	257	2	6428757	\N	0	\N	\N	1	1	2	f	6428757	\N	\N
679	72	258	2	437249	\N	0	\N	\N	1	1	2	f	437249	\N	\N
680	212	259	2	644	\N	0	\N	\N	1	1	2	f	644	\N	\N
681	220	260	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
682	19	261	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
683	136	262	2	84	\N	0	\N	\N	1	1	2	f	84	\N	\N
684	169	263	2	407647	\N	0	\N	\N	1	1	2	f	407647	\N	\N
685	178	264	2	419	\N	0	\N	\N	1	1	2	f	419	\N	\N
686	56	264	2	419	\N	0	\N	\N	0	1	2	f	419	\N	\N
687	100	264	2	419	\N	0	\N	\N	0	1	2	f	419	\N	\N
688	107	265	2	1599	\N	0	\N	\N	1	1	2	f	1599	\N	\N
689	87	265	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
690	7	265	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
691	44	266	2	5299	\N	0	\N	\N	1	1	2	f	5299	\N	\N
692	56	266	2	5299	\N	0	\N	\N	0	1	2	f	5299	\N	\N
693	205	267	2	50275	\N	0	\N	\N	1	1	2	f	50275	\N	\N
694	52	267	2	31076	\N	0	\N	\N	2	1	2	f	31076	\N	\N
695	240	267	2	17864	\N	0	\N	\N	3	1	2	f	17864	\N	\N
696	167	267	2	16339	\N	0	\N	\N	4	1	2	f	16339	\N	\N
697	196	267	2	16316	\N	0	\N	\N	5	1	2	f	16316	\N	\N
698	114	267	2	14841	\N	0	\N	\N	6	1	2	f	14841	\N	\N
699	127	267	2	2793	\N	0	\N	\N	7	1	2	f	2793	\N	\N
700	143	267	2	1229	\N	0	\N	\N	8	1	2	f	1229	\N	\N
701	208	267	2	1214	\N	0	\N	\N	9	1	2	f	1214	\N	\N
702	124	267	2	586	\N	0	\N	\N	10	1	2	f	586	\N	\N
703	193	267	2	60	\N	0	\N	\N	11	1	2	f	60	\N	\N
704	111	268	2	405	\N	0	\N	\N	1	1	2	f	405	\N	\N
705	8	269	2	7185	\N	0	\N	\N	1	1	2	f	7185	\N	\N
706	259	270	2	996	\N	0	\N	\N	1	1	2	f	996	\N	\N
707	63	270	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
708	137	270	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
709	138	270	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
710	161	270	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
711	44	271	2	7596	\N	0	\N	\N	1	1	2	f	7596	\N	\N
712	56	271	2	7596	\N	0	\N	\N	0	1	2	f	7596	\N	\N
713	44	272	2	4061	\N	0	\N	\N	1	1	2	f	4061	\N	\N
714	56	272	2	4056	\N	0	\N	\N	0	1	2	f	4056	\N	\N
715	129	273	2	348	\N	348	\N	\N	1	1	2	f	0	8	\N
716	8	273	1	348	\N	348	\N	\N	1	1	2	f	\N	129	\N
717	253	274	2	17016	\N	0	\N	\N	1	1	2	f	17016	\N	\N
718	128	274	2	7203	\N	0	\N	\N	2	1	2	f	7203	\N	\N
719	120	274	2	6124	\N	0	\N	\N	3	1	2	f	6124	\N	\N
720	7	274	2	5644	\N	0	\N	\N	0	1	2	f	5644	\N	\N
721	246	274	2	5644	\N	0	\N	\N	0	1	2	f	5644	\N	\N
722	231	274	2	4212	\N	0	\N	\N	0	1	2	f	4212	\N	\N
723	11	274	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
724	34	274	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
725	81	274	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
726	211	274	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
727	16	275	2	265	\N	0	\N	\N	1	1	2	f	265	\N	\N
728	228	276	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
729	210	277	2	36532	\N	0	\N	\N	1	1	2	f	36532	\N	\N
730	16	278	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
731	8	279	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
732	18	280	2	45913	\N	0	\N	\N	1	1	2	f	45913	\N	\N
733	235	281	2	2519	\N	0	\N	\N	1	1	2	f	2519	\N	\N
734	56	281	2	2519	\N	0	\N	\N	0	1	2	f	2519	\N	\N
735	178	282	2	105598	\N	105598	\N	\N	1	1	2	f	0	8	\N
736	56	282	2	3733	\N	3733	\N	\N	0	1	2	f	0	8	\N
737	100	282	2	3733	\N	3733	\N	\N	0	1	2	f	0	8	\N
738	256	282	2	77	\N	77	\N	\N	0	1	2	f	0	8	\N
739	8	282	1	105675	\N	105675	\N	\N	1	1	2	f	\N	178	\N
740	250	283	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
741	178	284	2	547793	\N	547793	\N	\N	1	1	2	f	0	\N	\N
742	254	284	2	468965	\N	468965	\N	\N	2	1	2	f	0	\N	\N
743	205	284	2	222074	\N	222074	\N	\N	3	1	2	f	0	\N	\N
744	256	284	2	50727	\N	50727	\N	\N	4	1	2	f	0	\N	\N
745	56	284	2	419586	\N	419586	\N	\N	0	1	2	f	0	\N	\N
746	100	284	2	419586	\N	419586	\N	\N	0	1	2	f	0	\N	\N
747	107	284	1	1267408	\N	1267408	\N	\N	1	1	2	f	\N	\N	\N
748	87	284	1	14296	\N	14296	\N	\N	0	1	2	f	\N	\N	\N
749	7	284	1	1947	\N	1947	\N	\N	0	1	2	f	\N	\N	\N
750	249	285	2	28634	\N	0	\N	\N	1	1	2	f	28634	\N	\N
751	56	285	2	28634	\N	0	\N	\N	0	1	2	f	28634	\N	\N
752	100	285	2	28634	\N	0	\N	\N	0	1	2	f	28634	\N	\N
753	44	286	2	2744	\N	0	\N	\N	1	1	2	f	2744	\N	\N
754	56	286	2	2739	\N	0	\N	\N	0	1	2	f	2739	\N	\N
755	209	287	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
756	250	288	2	12	\N	12	\N	\N	1	1	2	f	0	251	\N
757	149	288	2	10	\N	10	\N	\N	2	1	2	f	0	251	\N
758	201	288	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
759	251	288	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
760	272	289	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
761	218	290	2	5923	\N	0	\N	\N	1	1	2	f	5923	\N	\N
762	162	291	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
763	8	292	2	5573	\N	0	\N	\N	1	1	2	f	5573	\N	\N
764	15	292	2	647	\N	0	\N	\N	2	1	2	f	647	\N	\N
765	97	292	2	235	\N	0	\N	\N	3	1	2	f	235	\N	\N
766	215	292	2	188	\N	0	\N	\N	4	1	2	f	188	\N	\N
767	61	292	2	170	\N	0	\N	\N	5	1	2	f	170	\N	\N
768	99	292	2	76	\N	0	\N	\N	6	1	2	f	76	\N	\N
769	110	292	2	36	\N	0	\N	\N	7	1	2	f	36	\N	\N
770	155	292	2	36	\N	0	\N	\N	8	1	2	f	36	\N	\N
771	134	292	2	4	\N	0	\N	\N	9	1	2	f	4	\N	\N
772	251	292	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
773	172	292	2	1	\N	0	\N	\N	11	1	2	f	1	\N	\N
774	250	292	2	1	\N	0	\N	\N	12	1	2	f	1	\N	\N
775	118	292	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
776	239	292	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
777	185	292	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
778	139	292	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
779	7	292	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
780	136	293	2	84	\N	84	\N	\N	1	1	2	f	0	38	\N
781	38	293	1	84	\N	84	\N	\N	1	1	2	f	\N	136	\N
782	8	293	1	84	\N	84	\N	\N	0	1	2	f	\N	136	\N
783	209	294	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
784	253	295	2	670	\N	0	\N	\N	1	1	2	f	670	\N	\N
785	259	296	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
786	63	296	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
787	138	296	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
788	137	296	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
789	161	296	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
790	107	297	2	1562	\N	1562	\N	\N	1	1	2	f	0	\N	\N
791	87	297	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
792	7	297	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
793	8	297	1	1243	\N	1243	\N	\N	1	1	2	f	\N	107	\N
794	268	299	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
795	174	300	2	3026	\N	0	\N	\N	1	1	2	f	3026	\N	\N
796	235	301	2	13957	\N	0	\N	\N	1	1	2	f	13957	\N	\N
797	56	301	2	13957	\N	0	\N	\N	0	1	2	f	13957	\N	\N
798	31	302	2	2	\N	2	\N	\N	1	1	2	f	0	200	\N
799	200	302	1	2	\N	2	\N	\N	1	1	2	f	\N	31	\N
800	125	303	2	266220	\N	0	\N	\N	1	1	2	f	266220	\N	\N
801	56	303	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
802	100	303	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
803	234	304	2	33849	\N	0	\N	\N	1	1	2	f	33849	\N	\N
804	56	304	2	33848	\N	0	\N	\N	0	1	2	f	33848	\N	\N
805	178	305	2	1854277	\N	1854277	\N	\N	1	1	2	f	0	169	\N
806	56	305	2	1582839	\N	1582839	\N	\N	0	1	2	f	0	169	\N
807	100	305	2	1582839	\N	1582839	\N	\N	0	1	2	f	0	169	\N
808	169	305	1	1854277	\N	1854277	\N	\N	1	1	2	f	\N	178	\N
889	201	334	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
809	133	306	2	202	\N	202	\N	\N	1	1	2	f	0	38	\N
810	38	306	1	202	\N	202	\N	\N	1	1	2	f	\N	133	\N
811	8	306	1	202	\N	202	\N	\N	0	1	2	f	\N	133	\N
812	83	307	2	2872	\N	0	\N	\N	1	1	2	f	2872	\N	\N
813	37	307	2	1302	\N	0	\N	\N	2	1	2	f	1302	\N	\N
814	253	308	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
815	128	308	2	2767	\N	0	\N	\N	2	1	2	f	2767	\N	\N
816	29	309	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
817	237	310	2	111996	\N	111996	\N	\N	1	1	2	f	0	\N	\N
818	8	311	2	512891	\N	0	\N	\N	1	1	2	f	512891	\N	\N
819	99	311	2	1300	\N	0	\N	\N	2	1	2	f	1300	\N	\N
820	142	311	2	10	\N	0	\N	\N	3	1	2	f	10	\N	\N
821	185	311	2	1123	\N	0	\N	\N	0	1	2	f	1123	\N	\N
822	139	311	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
823	38	311	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
824	7	311	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
825	169	313	2	400307	\N	400199	\N	\N	1	1	2	f	108	\N	\N
826	8	313	1	400199	\N	400199	\N	\N	1	1	2	f	\N	169	\N
827	14	314	2	3219	\N	3219	\N	\N	1	1	2	f	0	8	\N
828	7	314	2	7	\N	7	\N	\N	0	1	2	f	0	8	\N
829	247	314	2	6	\N	6	\N	\N	0	1	2	f	0	8	\N
830	248	314	2	6	\N	6	\N	\N	0	1	2	f	0	8	\N
831	101	314	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
832	252	314	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
833	8	314	1	3219	\N	3219	\N	\N	1	1	2	f	\N	14	\N
834	212	315	2	5158	\N	0	\N	\N	1	1	2	f	5158	\N	\N
835	266	316	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
836	13	317	2	1345	\N	1345	\N	\N	1	1	2	f	0	\N	\N
837	8	317	1	913	\N	913	\N	\N	1	1	2	f	\N	13	\N
838	2	318	2	3878892	\N	0	\N	\N	1	1	2	f	3878892	\N	\N
839	1	319	2	459818	\N	0	\N	\N	1	1	2	f	459818	\N	\N
840	56	320	2	1989253	\N	0	\N	\N	1	1	2	f	1989253	\N	\N
841	100	320	2	1812561	\N	0	\N	\N	0	1	2	f	1812561	\N	\N
842	178	320	2	1583248	\N	0	\N	\N	0	1	2	f	1583248	\N	\N
843	125	320	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
844	84	320	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
845	235	320	2	35694	\N	0	\N	\N	0	1	2	f	35694	\N	\N
846	181	320	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
847	234	320	2	33661	\N	0	\N	\N	0	1	2	f	33661	\N	\N
848	42	320	2	25252	\N	0	\N	\N	0	1	2	f	25252	\N	\N
849	44	320	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
850	249	320	2	1310	\N	0	\N	\N	0	1	2	f	1310	\N	\N
851	258	320	2	253	\N	0	\N	\N	0	1	2	f	253	\N	\N
852	154	321	2	69	\N	0	\N	\N	1	1	2	f	69	\N	\N
853	132	322	2	296	\N	296	\N	\N	1	1	2	f	0	\N	\N
854	127	323	2	25693	\N	25693	\N	\N	1	1	2	f	0	167	\N
855	129	323	2	11	\N	11	\N	\N	0	1	2	f	0	167	\N
856	167	323	1	25693	\N	25693	\N	\N	1	1	2	f	\N	127	\N
857	35	324	2	716968	\N	0	\N	\N	1	1	2	f	716968	\N	\N
858	221	326	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
859	52	326	1	1512	\N	1512	\N	\N	1	1	2	f	\N	221	\N
860	84	329	2	32126	\N	0	\N	\N	1	1	2	f	32126	\N	\N
861	56	329	2	32126	\N	0	\N	\N	0	1	2	f	32126	\N	\N
862	231	330	2	1068	\N	0	\N	\N	1	1	2	f	1068	\N	\N
863	81	330	2	191	\N	0	\N	\N	2	1	2	f	191	\N	\N
864	120	330	2	191	\N	0	\N	\N	0	1	2	f	191	\N	\N
865	7	330	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
866	246	330	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
867	207	331	2	164452	\N	164452	\N	\N	1	1	2	f	0	\N	\N
868	249	331	2	35546	\N	35546	\N	\N	2	1	2	f	0	\N	\N
869	248	331	2	25	\N	25	\N	\N	3	1	2	f	0	107	\N
870	177	331	2	21	\N	21	\N	\N	4	1	2	f	0	107	\N
871	12	331	2	11	\N	11	\N	\N	5	1	2	f	0	107	\N
872	127	331	2	11	\N	11	\N	\N	6	1	2	f	0	107	\N
873	252	331	2	1	\N	1	\N	\N	7	1	2	f	0	107	\N
874	59	331	2	1	\N	1	\N	\N	8	1	2	f	0	107	\N
875	129	331	2	109915	\N	109915	\N	\N	0	1	2	f	0	\N	\N
876	56	331	2	35546	\N	35546	\N	\N	0	1	2	f	0	\N	\N
877	100	331	2	35546	\N	35546	\N	\N	0	1	2	f	0	\N	\N
878	7	331	2	39	\N	39	\N	\N	0	1	2	f	0	107	\N
879	120	331	2	11	\N	11	\N	\N	0	1	2	f	0	107	\N
880	246	331	2	11	\N	11	\N	\N	0	1	2	f	0	107	\N
881	247	331	2	2	\N	2	\N	\N	0	1	2	f	0	107	\N
882	107	331	1	302862	\N	302862	\N	\N	1	1	2	f	\N	\N	\N
883	87	331	1	2122	\N	2122	\N	\N	0	1	2	f	\N	\N	\N
884	7	331	1	49	\N	49	\N	\N	0	1	2	f	\N	\N	\N
885	150	332	2	2403	\N	2403	\N	\N	1	1	2	f	0	76	\N
886	105	332	2	16	\N	16	\N	\N	0	1	2	f	0	76	\N
887	76	332	1	2403	\N	2403	\N	\N	1	1	2	f	\N	150	\N
888	70	333	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
890	248	335	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
891	7	335	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
892	202	336	2	28802	\N	28802	\N	\N	1	1	2	f	0	8	\N
893	8	336	1	28802	\N	28802	\N	\N	1	1	2	f	\N	202	\N
894	116	337	2	231465	\N	0	\N	\N	1	1	2	f	231465	\N	\N
895	13	337	2	1761	\N	0	\N	\N	2	1	2	f	1761	\N	\N
896	44	338	2	9173	\N	0	\N	\N	1	1	2	f	9173	\N	\N
897	56	338	2	9100	\N	0	\N	\N	0	1	2	f	9100	\N	\N
898	204	339	2	52	\N	52	\N	\N	1	1	2	f	0	\N	\N
899	120	339	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
900	7	339	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
901	246	339	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
902	48	340	2	2280	\N	0	\N	\N	1	1	2	f	2280	\N	\N
903	4	341	2	1438944	\N	1438944	\N	\N	1	1	2	f	0	\N	\N
904	187	341	2	29143	\N	29143	\N	\N	2	1	2	f	0	249	\N
905	249	341	1	1465038	\N	1465038	\N	\N	1	1	2	f	\N	\N	\N
906	56	341	1	1465038	\N	1465038	\N	\N	0	1	2	f	\N	\N	\N
907	100	341	1	1465038	\N	1465038	\N	\N	0	1	2	f	\N	\N	\N
908	231	342	2	6868	\N	6868	\N	\N	1	1	2	f	0	8	\N
909	11	342	2	2843	\N	2843	\N	\N	2	1	2	f	0	8	\N
910	8	342	1	9711	\N	9711	\N	\N	1	1	2	f	\N	\N	\N
911	181	343	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
912	56	343	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
913	179	344	2	714819	\N	714819	\N	\N	1	1	2	f	0	194	\N
914	194	344	2	709072	\N	709072	\N	\N	2	1	2	f	0	8	\N
915	194	344	1	714819	\N	714819	\N	\N	1	1	2	f	\N	179	\N
916	8	344	1	475092	\N	475092	\N	\N	2	1	2	f	\N	\N	\N
917	177	345	2	2171482	\N	0	\N	\N	1	1	2	f	2171482	\N	\N
918	129	345	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
919	226	346	2	1729382	\N	1729382	\N	\N	1	1	2	f	0	8	\N
920	53	346	2	304331	\N	304331	\N	\N	2	1	2	f	0	\N	\N
921	8	346	1	2032246	\N	2032246	\N	\N	1	1	2	f	\N	\N	\N
922	33	346	1	15	\N	15	\N	\N	2	1	2	f	\N	53	\N
923	253	347	2	2455	\N	2455	\N	\N	1	1	2	f	0	8	\N
924	128	347	2	557	\N	557	\N	\N	2	1	2	f	0	8	\N
925	8	347	1	3012	\N	3012	\N	\N	1	1	2	f	\N	\N	\N
926	15	348	2	420	\N	0	\N	\N	1	1	2	f	420	\N	\N
927	7	348	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
928	81	349	2	137	\N	0	\N	\N	1	1	2	f	137	\N	\N
929	120	349	2	137	\N	0	\N	\N	0	1	2	f	137	\N	\N
930	7	349	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
931	246	349	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
932	272	350	2	21843	\N	21843	\N	\N	1	1	2	f	0	59	\N
933	124	350	2	1411	\N	1411	\N	\N	2	1	2	f	0	59	\N
934	59	350	1	23254	\N	23254	\N	\N	1	1	2	f	\N	\N	\N
935	249	351	2	184643	\N	0	\N	\N	1	1	2	f	184643	\N	\N
936	202	351	2	119561	\N	0	\N	\N	2	1	2	f	119561	\N	\N
937	101	351	2	109522	\N	0	\N	\N	3	1	2	f	109522	\N	\N
938	129	351	2	85787	\N	0	\N	\N	4	1	2	f	85787	\N	\N
939	174	351	2	17506	\N	0	\N	\N	5	1	2	f	17506	\N	\N
940	103	351	2	6671	\N	0	\N	\N	6	1	2	f	6671	\N	\N
941	87	351	2	2847	\N	0	\N	\N	7	1	2	f	2847	\N	\N
942	13	351	2	1870	\N	0	\N	\N	8	1	2	f	1870	\N	\N
943	130	351	2	775	\N	0	\N	\N	9	1	2	f	775	\N	\N
944	56	351	2	184643	\N	0	\N	\N	0	1	2	f	184643	\N	\N
945	100	351	2	184643	\N	0	\N	\N	0	1	2	f	184643	\N	\N
946	14	351	2	5645	\N	0	\N	\N	0	1	2	f	5645	\N	\N
947	107	351	2	2272	\N	0	\N	\N	0	1	2	f	2272	\N	\N
948	207	351	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
949	7	351	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
950	248	351	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
951	247	351	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
952	252	351	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
953	69	352	2	208	\N	0	\N	\N	1	1	2	f	208	\N	\N
954	113	353	2	387177	\N	0	\N	\N	1	1	2	f	387177	\N	\N
955	112	353	2	328083	\N	0	\N	\N	0	1	2	f	328083	\N	\N
956	253	354	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
957	128	354	2	2767	\N	0	\N	\N	2	1	2	f	2767	\N	\N
958	60	355	2	19505	\N	0	\N	\N	1	1	2	f	19505	\N	\N
959	56	355	2	19505	\N	0	\N	\N	0	1	2	f	19505	\N	\N
960	83	356	2	3964	\N	0	\N	\N	1	1	2	f	3964	\N	\N
961	37	356	2	822	\N	0	\N	\N	2	1	2	f	822	\N	\N
962	70	357	2	37	\N	0	\N	\N	1	1	2	f	37	\N	\N
963	215	358	2	215	\N	0	\N	\N	1	1	2	f	215	\N	\N
964	157	359	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
965	157	360	2	58	\N	0	\N	\N	1	1	2	f	58	\N	\N
966	152	361	2	968	\N	0	\N	\N	1	1	2	f	968	\N	\N
967	29	362	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
968	46	363	2	19068	\N	0	\N	\N	1	1	2	f	19068	\N	\N
969	209	364	2	327	\N	0	\N	\N	1	1	2	f	327	\N	\N
970	101	365	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
971	8	365	1	2	\N	2	\N	\N	1	1	2	f	\N	101	\N
972	29	366	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
973	180	367	2	7980	\N	7980	\N	\N	1	1	2	f	0	\N	\N
974	107	367	1	7387	\N	7387	\N	\N	1	1	2	f	\N	180	\N
975	87	367	1	338	\N	338	\N	\N	0	1	2	f	\N	180	\N
976	183	368	2	197	\N	0	\N	\N	1	1	2	f	197	\N	\N
977	243	369	2	11593	\N	0	\N	\N	1	1	2	f	11593	\N	\N
978	235	370	2	2109	\N	0	\N	\N	1	1	2	f	2109	\N	\N
979	56	370	2	2109	\N	0	\N	\N	0	1	2	f	2109	\N	\N
980	258	371	2	63	\N	0	\N	\N	1	1	2	f	63	\N	\N
981	56	371	2	63	\N	0	\N	\N	0	1	2	f	63	\N	\N
982	253	372	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
983	253	374	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
984	58	375	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
985	120	375	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
986	7	375	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
987	246	375	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
988	31	376	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
989	246	377	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
990	7	377	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
991	120	377	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
992	253	378	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
993	181	380	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
994	56	380	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
995	84	381	2	36450	\N	0	\N	\N	1	1	2	f	36450	\N	\N
996	56	381	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
997	58	382	2	178	\N	178	\N	\N	1	1	2	f	0	\N	\N
998	120	382	2	178	\N	178	\N	\N	0	1	2	f	0	\N	\N
999	7	382	2	144	\N	144	\N	\N	0	1	2	f	0	\N	\N
1000	246	382	2	144	\N	144	\N	\N	0	1	2	f	0	\N	\N
1001	89	383	2	48	\N	0	\N	\N	1	1	2	f	48	\N	\N
1002	17	383	2	10	\N	0	\N	\N	2	1	2	f	10	\N	\N
1003	133	384	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
1004	41	385	2	182542	\N	0	\N	\N	1	1	2	f	182542	\N	\N
1005	229	386	2	1789	\N	1789	\N	\N	1	1	2	f	0	\N	\N
1006	97	386	2	941	\N	941	\N	\N	0	1	2	f	0	99	\N
1007	99	386	1	2063	\N	2063	\N	\N	1	1	2	f	\N	\N	\N
1008	143	387	2	76664	\N	76664	\N	\N	1	1	2	f	0	\N	\N
1009	103	387	1	77	\N	77	\N	\N	1	1	2	f	\N	143	\N
1010	111	388	2	570	\N	0	\N	\N	1	1	2	f	570	\N	\N
1011	181	389	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
1012	56	389	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
1013	196	390	2	34219	\N	34219	\N	\N	1	1	2	f	0	27	\N
1014	27	390	1	34219	\N	34219	\N	\N	1	1	2	f	\N	196	\N
1015	29	391	2	57	\N	0	\N	\N	1	1	2	f	57	\N	\N
1016	235	392	2	2512	\N	0	\N	\N	1	1	2	f	2512	\N	\N
1017	56	392	2	2512	\N	0	\N	\N	0	1	2	f	2512	\N	\N
1018	207	393	2	264867	\N	264867	\N	\N	1	1	2	f	0	113	\N
1019	129	393	2	37	\N	37	\N	\N	0	1	2	f	0	113	\N
1020	7	393	2	1	\N	1	\N	\N	0	1	2	f	0	113	\N
1021	113	393	1	264867	\N	264867	\N	\N	1	1	2	f	\N	207	\N
1022	112	393	1	264867	\N	264867	\N	\N	0	1	2	f	\N	207	\N
1023	29	394	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
1024	8	395	2	192	\N	192	\N	\N	1	1	2	f	0	8	\N
1025	7	395	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
1026	8	395	1	192	\N	192	\N	\N	1	1	2	f	\N	8	\N
1027	235	396	2	4517	\N	0	\N	\N	1	1	2	f	4517	\N	\N
1028	56	396	2	4517	\N	0	\N	\N	0	1	2	f	4517	\N	\N
1029	80	397	2	1	\N	1	\N	\N	1	1	2	f	0	80	\N
1030	80	397	1	1	\N	1	\N	\N	1	1	2	f	\N	80	\N
1031	65	398	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
1032	85	398	2	112	\N	112	\N	\N	2	1	2	f	0	\N	\N
1033	153	398	2	12	\N	12	\N	\N	3	1	2	f	0	\N	\N
1034	118	398	1	236	\N	236	\N	\N	0	1	2	f	\N	\N	\N
1035	181	399	2	753	\N	0	\N	\N	1	1	2	f	753	\N	\N
1036	56	399	2	753	\N	0	\N	\N	0	1	2	f	753	\N	\N
1037	15	400	2	16534	\N	16534	\N	\N	1	1	2	f	0	\N	\N
1038	7	400	2	66	\N	66	\N	\N	0	1	2	f	0	154	\N
1039	154	400	1	16533	\N	16533	\N	\N	1	1	2	f	\N	15	\N
1040	70	401	2	37	\N	0	\N	\N	1	1	2	f	37	\N	\N
1041	246	403	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
1042	7	403	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
1043	120	403	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1044	128	404	2	2546	\N	0	\N	\N	1	1	2	f	2546	\N	\N
1045	47	405	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1046	163	405	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1047	208	406	2	1522	\N	0	\N	\N	1	1	2	f	1522	\N	\N
1048	76	407	2	12808	\N	12808	\N	\N	1	1	2	f	0	\N	\N
1049	29	410	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
1050	235	412	2	4532	\N	0	\N	\N	1	1	2	f	4532	\N	\N
1051	56	412	2	4532	\N	0	\N	\N	0	1	2	f	4532	\N	\N
1052	253	413	2	287	\N	0	\N	\N	1	1	2	f	287	\N	\N
1053	246	414	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
1054	7	414	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
1055	120	414	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1056	136	415	2	84	\N	84	\N	\N	1	1	2	f	0	91	\N
1057	91	415	1	84	\N	84	\N	\N	1	1	2	f	\N	136	\N
1058	169	416	2	477026	\N	477026	\N	\N	1	1	2	f	0	8	\N
1059	8	416	1	477026	\N	477026	\N	\N	1	1	2	f	\N	169	\N
1060	3	417	2	5400	\N	0	\N	\N	1	1	2	f	5400	\N	\N
1061	249	419	2	74141	\N	74141	\N	\N	1	1	2	f	0	\N	\N
1062	56	419	2	74141	\N	74141	\N	\N	0	1	2	f	0	\N	\N
1063	100	419	2	74141	\N	74141	\N	\N	0	1	2	f	0	\N	\N
1064	8	419	1	63994	\N	63994	\N	\N	1	1	2	f	\N	249	\N
1065	250	420	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
1066	149	420	2	1	\N	1	\N	\N	2	1	2	f	0	250	\N
1067	149	420	1	21	\N	21	\N	\N	1	1	2	f	\N	250	\N
1068	250	420	1	20	\N	20	\N	\N	2	1	2	f	\N	\N	\N
1069	15	421	2	671	\N	671	\N	\N	1	1	2	f	0	214	\N
1070	7	421	2	2	\N	2	\N	\N	0	1	2	f	0	214	\N
1071	214	421	1	671	\N	671	\N	\N	1	1	2	f	\N	15	\N
1072	10	421	1	671	\N	671	\N	\N	0	1	2	f	\N	15	\N
1073	124	422	2	1512	\N	1512	\N	\N	1	1	2	f	0	221	\N
1074	221	422	1	1512	\N	1512	\N	\N	1	1	2	f	\N	124	\N
1075	234	423	2	33849	\N	0	\N	\N	1	1	2	f	33849	\N	\N
1076	56	423	2	33848	\N	0	\N	\N	0	1	2	f	33848	\N	\N
1077	85	425	2	169	\N	169	\N	\N	1	1	2	f	0	\N	\N
1078	153	425	2	53	\N	53	\N	\N	2	1	2	f	0	\N	\N
1079	148	425	1	60	\N	60	\N	\N	1	1	2	f	\N	\N	\N
1080	121	425	1	56	\N	56	\N	\N	2	1	2	f	\N	85	\N
1081	173	425	1	56	\N	56	\N	\N	3	1	2	f	\N	85	\N
1082	7	425	1	1	\N	1	\N	\N	0	1	2	f	\N	153	\N
1083	42	429	2	24222	\N	24222	\N	\N	1	1	2	f	0	\N	\N
1084	56	429	2	24222	\N	24222	\N	\N	0	1	2	f	0	\N	\N
1085	82	431	2	11818	\N	11818	\N	\N	1	1	2	f	0	\N	\N
1086	8	431	1	11711	\N	11711	\N	\N	1	1	2	f	\N	82	\N
1087	33	431	1	49	\N	49	\N	\N	2	1	2	f	\N	82	\N
1088	253	432	2	40291	\N	40291	\N	\N	1	1	2	f	0	\N	\N
1089	46	433	2	19068	\N	0	\N	\N	1	1	2	f	19068	\N	\N
1090	152	435	2	968	\N	0	\N	\N	1	1	2	f	968	\N	\N
1091	234	436	2	27297	\N	0	\N	\N	1	1	2	f	27297	\N	\N
1092	56	436	2	27297	\N	0	\N	\N	0	1	2	f	27297	\N	\N
1093	48	437	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
1094	116	438	2	1054567	\N	1054567	\N	\N	1	1	2	f	\N	\N	\N
1095	249	438	2	422756	\N	422756	\N	\N	2	1	2	f	\N	7	\N
1096	202	438	2	278202	\N	278202	\N	\N	3	1	2	f	\N	\N	\N
1097	207	438	2	264488	\N	264488	\N	\N	4	1	2	f	\N	\N	\N
1098	101	438	2	186689	\N	186689	\N	\N	5	1	2	f	\N	7	\N
1099	174	438	2	41179	\N	41179	\N	\N	6	1	2	f	\N	7	\N
1100	103	438	2	11357	\N	11357	\N	\N	7	1	2	f	\N	\N	\N
1101	107	438	2	4689	\N	4689	\N	\N	8	1	2	f	\N	246	\N
1102	13	438	2	2496	\N	2496	\N	\N	9	1	2	f	\N	120	\N
1103	130	438	2	1786	\N	1786	\N	\N	10	1	2	f	\N	\N	\N
1104	111	438	2	611	\N	\N	\N	\N	11	1	2	f	611	\N	\N
1105	177	438	2	21	\N	21	\N	\N	12	1	2	f	\N	\N	\N
1106	12	438	2	11	\N	11	\N	\N	13	1	2	f	\N	\N	\N
1107	127	438	2	11	\N	11	\N	\N	14	1	2	f	\N	\N	\N
1108	120	438	2	11	\N	11	\N	\N	15	1	2	f	\N	\N	\N
1109	134	438	2	4	\N	4	\N	\N	16	1	2	f	\N	\N	\N
1110	250	438	2	4	\N	4	\N	\N	17	1	2	f	\N	\N	\N
1111	172	438	2	1	\N	1	\N	\N	18	1	2	f	\N	\N	\N
1112	33	438	2	1	\N	\N	\N	\N	19	1	2	f	1	\N	\N
1113	59	438	2	1	\N	1	\N	\N	20	1	2	f	\N	\N	\N
1114	56	438	2	422756	\N	422756	\N	\N	0	1	2	f	\N	7	\N
1115	100	438	2	422756	\N	422756	\N	\N	0	1	2	f	\N	7	\N
1116	129	438	2	130814	\N	130814	\N	\N	0	1	2	f	\N	\N	\N
1117	14	438	2	6573	\N	6573	\N	\N	0	1	2	f	\N	\N	\N
1118	87	438	2	3374	\N	3374	\N	\N	0	1	2	f	\N	\N	\N
1119	7	438	2	57	\N	57	\N	\N	0	1	2	f	\N	\N	\N
1120	248	438	2	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
1121	247	438	2	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
1122	246	438	2	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
1123	252	438	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1124	7	438	1	2409659	\N	2409659	\N	\N	1	1	2	f	\N	\N	\N
1125	246	438	1	2404639	\N	2404639	\N	\N	0	1	2	f	\N	\N	\N
1126	120	438	1	2404054	\N	2404054	\N	\N	0	1	2	f	\N	\N	\N
1127	252	438	1	2874	\N	2874	\N	\N	0	1	2	f	\N	\N	\N
1128	247	438	1	1385	\N	1385	\N	\N	0	1	2	f	\N	\N	\N
1129	248	438	1	1383	\N	1383	\N	\N	0	1	2	f	\N	116	\N
1130	102	438	1	11	\N	11	\N	\N	0	1	2	f	\N	129	\N
1131	129	438	1	6	\N	6	\N	\N	0	1	2	f	\N	103	\N
1132	183	439	2	90	\N	0	\N	\N	1	1	2	f	90	\N	\N
1133	181	440	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
1134	56	440	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
1135	178	441	2	86681	\N	0	\N	\N	1	1	2	f	86681	\N	\N
1136	56	441	2	1213	\N	0	\N	\N	0	1	2	f	1213	\N	\N
1137	100	441	2	1213	\N	0	\N	\N	0	1	2	f	1213	\N	\N
1138	60	442	2	40827	\N	40827	\N	\N	1	1	2	f	0	\N	\N
1139	56	442	2	40827	\N	40827	\N	\N	0	1	2	f	0	\N	\N
1140	16	443	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
1141	260	444	2	258	\N	0	\N	\N	1	1	2	f	258	\N	\N
1142	125	445	2	265284	\N	265284	\N	\N	1	1	2	f	0	\N	\N
1143	27	445	2	64471	\N	64471	\N	\N	2	1	2	f	0	8	\N
1144	56	445	2	225599	\N	225599	\N	\N	0	1	2	f	0	8	\N
1145	100	445	2	225599	\N	225599	\N	\N	0	1	2	f	0	8	\N
1146	8	445	1	329513	\N	329513	\N	\N	1	1	2	f	\N	\N	\N
1147	114	446	2	503	\N	503	\N	\N	1	1	2	f	0	\N	\N
1148	8	446	1	497	\N	497	\N	\N	1	1	2	f	\N	114	\N
1149	151	447	2	19518	\N	19518	\N	\N	1	1	2	f	0	8	\N
1150	8	447	1	19518	\N	19518	\N	\N	1	1	2	f	\N	151	\N
1151	181	448	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
1152	56	448	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
1153	29	449	2	40	\N	0	\N	\N	1	1	2	f	40	\N	\N
1154	44	450	2	967	\N	0	\N	\N	1	1	2	f	967	\N	\N
1155	56	450	2	967	\N	0	\N	\N	0	1	2	f	967	\N	\N
1156	196	451	2	64126	\N	64126	\N	\N	1	1	2	f	0	272	\N
1157	272	451	1	64126	\N	64126	\N	\N	1	1	2	f	\N	196	\N
1158	227	452	2	509915	\N	509915	\N	\N	1	1	2	f	0	8	\N
1159	8	452	1	509915	\N	509915	\N	\N	1	1	2	f	\N	227	\N
1160	233	453	2	2368352	\N	2368352	\N	\N	1	1	2	f	0	\N	\N
1161	36	453	2	484224	\N	484224	\N	\N	2	1	2	f	0	\N	\N
1162	101	453	1	2710683	\N	2710683	\N	\N	1	1	2	f	\N	\N	\N
1163	13	453	1	303	\N	303	\N	\N	2	1	2	f	\N	233	\N
1164	249	453	1	1	\N	1	\N	\N	3	1	2	f	\N	233	\N
1165	14	453	1	32794	\N	32794	\N	\N	0	1	2	f	\N	\N	\N
1166	56	453	1	1	\N	1	\N	\N	0	1	2	f	\N	233	\N
1167	100	453	1	1	\N	1	\N	\N	0	1	2	f	\N	233	\N
1168	77	454	2	904	\N	904	\N	\N	1	1	2	f	0	8	\N
1169	8	454	1	904	\N	904	\N	\N	1	1	2	f	\N	77	\N
1170	58	456	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
1171	120	456	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
1172	7	456	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1173	246	456	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1174	60	457	2	3353	\N	0	\N	\N	1	1	2	f	3353	\N	\N
1175	76	457	2	626	\N	0	\N	\N	2	1	2	f	626	\N	\N
1176	105	457	2	193	\N	0	\N	\N	3	1	2	f	193	\N	\N
1177	120	457	2	33	\N	0	\N	\N	4	1	2	f	33	\N	\N
1178	56	457	2	3353	\N	0	\N	\N	0	1	2	f	3353	\N	\N
1179	150	457	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
1180	7	457	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1181	246	457	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
1182	129	459	2	44009	\N	0	\N	\N	1	1	2	f	44009	\N	\N
1183	207	459	2	35	\N	0	\N	\N	0	1	2	f	35	\N	\N
1184	7	459	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
1185	248	459	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
1186	177	459	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1187	12	459	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1188	127	459	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1189	120	459	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1190	246	459	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1191	247	459	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1192	59	459	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1193	252	459	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1194	44	460	2	1562	\N	0	\N	\N	1	1	2	f	1562	\N	\N
1195	56	460	2	1562	\N	0	\N	\N	0	1	2	f	1562	\N	\N
1196	29	461	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
1197	88	462	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
1198	38	463	2	73	\N	0	\N	\N	1	1	2	f	73	\N	\N
1199	39	463	2	21	\N	0	\N	\N	2	1	2	f	21	\N	\N
1200	8	463	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
1201	99	463	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1202	179	464	2	1909165	\N	1909165	\N	\N	1	1	2	f	0	1	\N
1203	1	464	2	1825	\N	1825	\N	\N	0	1	2	f	0	8	\N
1204	1	464	1	1909165	\N	1909165	\N	\N	1	1	2	f	\N	179	\N
1205	8	464	1	1825	\N	1825	\N	\N	0	1	2	f	\N	1	\N
1206	181	465	2	4438	\N	0	\N	\N	1	1	2	f	4438	\N	\N
1207	56	465	2	4438	\N	0	\N	\N	0	1	2	f	4438	\N	\N
1208	180	467	2	30940	\N	30940	\N	\N	1	1	2	f	0	\N	\N
1209	8	467	1	30915	\N	30915	\N	\N	1	1	2	f	\N	180	\N
1210	253	468	2	10327	\N	10327	\N	\N	1	1	2	f	0	8	\N
1211	128	468	2	4428	\N	4428	\N	\N	2	1	2	f	0	8	\N
1212	8	468	1	14755	\N	14755	\N	\N	1	1	2	f	\N	\N	\N
1213	48	469	2	2103	\N	0	\N	\N	1	1	2	f	2103	\N	\N
1214	235	470	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
1215	56	470	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
1216	8	471	2	41	\N	41	\N	\N	1	1	2	f	0	8	\N
1217	8	471	1	41	\N	41	\N	\N	1	1	2	f	\N	8	\N
1218	84	472	2	632	\N	0	\N	\N	1	1	2	f	632	\N	\N
1219	56	472	2	632	\N	0	\N	\N	0	1	2	f	632	\N	\N
1220	81	474	2	1583	\N	0	\N	\N	1	1	2	f	1583	\N	\N
1221	120	474	2	1583	\N	0	\N	\N	0	1	2	f	1583	\N	\N
1222	7	474	2	1262	\N	0	\N	\N	0	1	2	f	1262	\N	\N
1223	246	474	2	1262	\N	0	\N	\N	0	1	2	f	1262	\N	\N
1224	152	475	2	968	\N	0	\N	\N	1	1	2	f	968	\N	\N
1225	258	476	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1226	56	476	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1227	24	477	2	437121	\N	0	\N	\N	1	1	2	f	437121	\N	\N
1228	54	478	2	3	\N	3	\N	\N	1	1	2	f	0	29	\N
1229	29	478	1	3	\N	3	\N	\N	1	1	2	f	\N	54	\N
1230	129	479	2	23915	\N	0	\N	\N	1	1	2	f	23915	\N	\N
1231	250	480	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1232	54	481	2	10	\N	10	\N	\N	1	1	2	f	0	29	\N
1233	29	481	1	10	\N	10	\N	\N	1	1	2	f	\N	54	\N
1234	54	482	2	3	\N	3	\N	\N	1	1	2	f	0	29	\N
1235	29	482	1	3	\N	3	\N	\N	1	1	2	f	\N	54	\N
1236	54	483	2	56	\N	56	\N	\N	1	1	2	f	0	29	\N
1237	245	483	2	8	\N	8	\N	\N	2	1	2	f	0	146	\N
1238	199	483	2	2	\N	2	\N	\N	3	1	2	f	0	55	\N
1239	29	483	1	56	\N	56	\N	\N	1	1	2	f	\N	54	\N
1240	146	483	1	8	\N	8	\N	\N	2	1	2	f	\N	245	\N
1241	55	483	1	2	\N	2	\N	\N	3	1	2	f	\N	199	\N
1242	29	484	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
1243	54	485	2	13	\N	13	\N	\N	1	1	2	f	0	29	\N
1244	29	485	1	13	\N	13	\N	\N	1	1	2	f	\N	54	\N
1245	125	486	2	265755	\N	0	\N	\N	1	1	2	f	265755	\N	\N
1246	56	486	2	226181	\N	0	\N	\N	0	1	2	f	226181	\N	\N
1247	100	486	2	226181	\N	0	\N	\N	0	1	2	f	226181	\N	\N
1248	21	488	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
1249	37	489	2	73088	\N	73088	\N	\N	1	1	2	f	0	241	\N
1250	144	489	2	29919	\N	29919	\N	\N	2	1	2	f	0	241	\N
1251	241	489	1	103007	\N	103007	\N	\N	1	1	2	f	\N	\N	\N
1252	74	490	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
1253	190	490	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
1254	221	490	2	1512	\N	1512	\N	\N	3	1	2	f	0	52	\N
1255	52	490	1	4536	\N	4536	\N	\N	1	1	2	f	\N	\N	\N
1256	157	494	2	54	\N	0	\N	\N	1	1	2	f	54	\N	\N
1257	58	495	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1258	120	495	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1259	7	495	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1260	246	495	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1261	12	496	2	17952	\N	17952	\N	\N	1	1	2	f	0	\N	\N
1262	238	496	2	2	\N	2	\N	\N	2	1	2	f	0	177	\N
1263	129	496	2	11	\N	11	\N	\N	0	1	2	f	0	129	\N
1264	177	496	1	17925	\N	17925	\N	\N	1	1	2	f	\N	\N	\N
1265	59	496	1	29	\N	29	\N	\N	2	1	2	f	\N	12	\N
1266	129	496	1	11	\N	11	\N	\N	0	1	2	f	\N	12	\N
1267	213	497	2	241	\N	241	\N	\N	1	1	2	f	0	\N	\N
1268	21	498	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
1269	235	499	2	36012	\N	0	\N	\N	1	1	2	f	36012	\N	\N
1270	56	499	2	36012	\N	0	\N	\N	0	1	2	f	36012	\N	\N
1271	249	500	2	77608	\N	0	\N	\N	1	1	2	f	77608	\N	\N
1272	56	500	2	77608	\N	0	\N	\N	0	1	2	f	77608	\N	\N
1273	100	500	2	77608	\N	0	\N	\N	0	1	2	f	77608	\N	\N
1274	253	501	2	16569	\N	10566	\N	\N	1	1	2	f	6003	\N	\N
1275	128	501	2	7186	\N	4433	\N	\N	2	1	2	f	2753	\N	\N
1276	8	501	1	14999	\N	14999	\N	\N	1	1	2	f	\N	\N	\N
1277	61	502	2	170	\N	170	\N	\N	1	1	2	f	0	\N	\N
1278	126	503	2	904	\N	904	\N	\N	1	1	2	f	0	\N	\N
1279	103	503	1	1	\N	1	\N	\N	1	1	2	f	\N	126	\N
1280	31	504	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1281	253	505	2	5861	\N	5861	\N	\N	1	1	2	f	0	\N	\N
1282	42	506	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
1283	56	506	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
1284	133	507	2	81	\N	0	\N	\N	1	1	2	f	81	\N	\N
1285	74	508	2	1418	\N	1418	\N	\N	1	1	2	f	0	52	\N
1286	190	508	2	1417	\N	1417	\N	\N	2	1	2	f	0	52	\N
1287	221	508	2	1414	\N	1414	\N	\N	3	1	2	f	0	52	\N
1288	52	508	1	4249	\N	4249	\N	\N	1	1	2	f	\N	\N	\N
1289	126	509	2	919	\N	0	\N	\N	1	1	2	f	919	\N	\N
1290	47	510	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1291	163	510	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1292	235	511	2	32761	\N	0	\N	\N	1	1	2	f	32761	\N	\N
1293	56	511	2	32761	\N	0	\N	\N	0	1	2	f	32761	\N	\N
1294	169	512	2	607059	\N	0	\N	\N	1	1	2	f	607059	\N	\N
1295	66	513	2	171	\N	0	\N	\N	1	1	2	f	171	\N	\N
1296	108	514	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
1297	197	515	2	2319	\N	2319	\N	\N	1	1	2	f	0	8	\N
1298	8	515	1	2319	\N	2319	\N	\N	1	1	2	f	\N	197	\N
1299	44	516	2	129	\N	0	\N	\N	1	1	2	f	129	\N	\N
1300	56	516	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
1301	150	518	2	862	\N	0	\N	\N	1	1	2	f	862	\N	\N
1302	105	518	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1303	196	519	2	225659	\N	0	\N	\N	1	1	2	f	225659	\N	\N
1304	44	520	2	3649	\N	0	\N	\N	1	1	2	f	3649	\N	\N
1305	56	520	2	3649	\N	0	\N	\N	0	1	2	f	3649	\N	\N
1306	29	522	2	172	\N	172	\N	\N	1	1	2	f	0	\N	\N
1307	58	523	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
1308	120	523	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1309	7	523	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1310	246	523	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1311	60	524	2	7733	\N	0	\N	\N	1	1	2	f	7733	\N	\N
1312	56	524	2	7733	\N	0	\N	\N	0	1	2	f	7733	\N	\N
1313	81	525	2	20022	\N	20022	\N	\N	1	1	2	f	0	\N	\N
1314	120	525	2	20022	\N	20022	\N	\N	0	1	2	f	0	\N	\N
1315	7	525	2	15206	\N	15206	\N	\N	0	1	2	f	0	\N	\N
1316	246	525	2	15206	\N	15206	\N	\N	0	1	2	f	0	\N	\N
1317	254	526	2	478636	\N	478636	\N	\N	1	1	2	f	0	\N	\N
1318	205	526	2	222475	\N	222475	\N	\N	2	1	2	f	0	8	\N
1319	8	526	1	700910	\N	700910	\N	\N	1	1	2	f	\N	\N	\N
1320	253	527	2	9869	\N	0	\N	\N	1	1	2	f	9869	\N	\N
1321	253	528	2	6188	\N	0	\N	\N	1	1	2	f	6188	\N	\N
1322	128	528	2	3653	\N	0	\N	\N	2	1	2	f	3653	\N	\N
1323	112	530	2	6719312	\N	6719312	\N	\N	1	1	2	f	0	8	\N
1324	113	530	2	411336	\N	411336	\N	\N	0	1	2	f	0	\N	\N
1325	8	530	1	6664208	\N	6664208	\N	\N	1	1	2	f	\N	112	\N
1326	33	530	1	437	\N	437	\N	\N	2	1	2	f	\N	112	\N
1327	253	532	2	4871	\N	0	\N	\N	1	1	2	f	4871	\N	\N
1328	178	533	2	1856185	\N	1856185	\N	\N	1	1	2	f	0	\N	\N
1329	125	533	2	262585	\N	262585	\N	\N	2	1	2	f	0	\N	\N
1330	56	533	2	1809627	\N	1809627	\N	\N	0	1	2	f	0	\N	\N
1331	100	533	2	1809627	\N	1809627	\N	\N	0	1	2	f	0	\N	\N
1332	130	533	1	2077179	\N	2077179	\N	\N	1	1	2	f	\N	\N	\N
1333	249	534	2	75912	\N	75912	\N	\N	1	1	2	f	0	\N	\N
1334	174	534	2	9281	\N	9281	\N	\N	2	1	2	f	0	\N	\N
1335	56	534	2	75912	\N	75912	\N	\N	0	1	2	f	0	\N	\N
1336	100	534	2	75912	\N	75912	\N	\N	0	1	2	f	0	\N	\N
1337	130	534	1	80644	\N	80644	\N	\N	1	1	2	f	\N	\N	\N
1338	171	535	2	2	\N	2	\N	\N	1	1	2	f	0	30	\N
1339	30	535	1	2	\N	2	\N	\N	1	1	2	f	\N	171	\N
1340	240	536	2	3527	\N	0	\N	\N	1	1	2	f	3527	\N	\N
1341	117	537	2	15061	\N	15061	\N	\N	1	1	2	f	0	\N	\N
1342	129	539	2	63744	\N	0	\N	\N	1	1	2	f	63744	\N	\N
1343	7	539	2	35	\N	0	\N	\N	0	1	2	f	35	\N	\N
1344	248	539	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
1345	177	539	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1346	127	539	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1347	120	539	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1348	246	539	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1349	12	539	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1350	207	539	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1351	247	539	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1352	252	539	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1353	8	540	2	226058	\N	0	\N	\N	1	1	2	f	226058	\N	\N
1354	259	540	2	996	\N	0	\N	\N	2	1	2	f	996	\N	\N
1355	15	540	2	671	\N	0	\N	\N	3	1	2	f	671	\N	\N
1356	33	540	2	216	\N	0	\N	\N	4	1	2	f	216	\N	\N
1357	215	540	2	216	\N	0	\N	\N	5	1	2	f	216	\N	\N
1358	265	540	2	87	\N	0	\N	\N	6	1	2	f	87	\N	\N
1359	154	540	2	69	\N	0	\N	\N	7	1	2	f	69	\N	\N
1360	99	540	2	36	\N	0	\N	\N	8	1	2	f	36	\N	\N
1361	123	540	2	11	\N	0	\N	\N	9	1	2	f	11	\N	\N
1362	142	540	2	10	\N	0	\N	\N	10	1	2	f	10	\N	\N
1363	63	540	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
1364	137	540	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
1365	138	540	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
1366	38	540	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
1367	39	540	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1368	161	540	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1369	7	540	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1370	106	541	2	239594	\N	0	\N	\N	1	1	2	f	239594	\N	\N
1371	48	542	2	617	\N	0	\N	\N	1	1	2	f	617	\N	\N
1372	135	543	2	58	\N	58	\N	\N	1	1	2	f	0	38	\N
1373	38	543	1	58	\N	58	\N	\N	1	1	2	f	\N	135	\N
1374	8	543	1	58	\N	58	\N	\N	0	1	2	f	\N	135	\N
1375	149	544	2	40	\N	40	\N	\N	1	1	2	f	0	\N	\N
1376	250	544	1	39	\N	39	\N	\N	1	1	2	f	\N	149	\N
1377	56	545	2	107559	\N	107559	\N	\N	1	1	2	f	0	\N	\N
1378	210	545	2	36540	\N	36540	\N	\N	2	1	2	f	0	\N	\N
1379	209	545	2	5548	\N	5548	\N	\N	3	1	2	f	0	\N	\N
1380	152	545	2	968	\N	968	\N	\N	4	1	2	f	0	\N	\N
1381	260	545	2	258	\N	258	\N	\N	5	1	2	f	0	\N	\N
1382	84	545	2	36450	\N	36450	\N	\N	0	1	2	f	0	\N	\N
1383	235	545	2	36012	\N	36012	\N	\N	0	1	2	f	0	\N	\N
1384	181	545	2	35097	\N	35097	\N	\N	0	1	2	f	0	\N	\N
1385	234	546	2	33948	\N	0	\N	\N	1	1	2	f	33948	\N	\N
1386	56	546	2	33948	\N	0	\N	\N	0	1	2	f	33948	\N	\N
1387	29	548	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
1388	209	549	2	1769	\N	0	\N	\N	1	1	2	f	1769	\N	\N
1389	58	550	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1390	120	550	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1391	7	550	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1392	246	550	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1393	144	551	2	53586	\N	53586	\N	\N	1	1	2	f	0	\N	\N
1394	150	551	2	862	\N	862	\N	\N	2	1	2	f	0	\N	\N
1395	105	551	2	550	\N	550	\N	\N	0	1	2	f	0	\N	\N
1396	179	552	2	1926005	\N	1926005	\N	\N	1	1	2	f	\N	\N	\N
1397	178	552	2	1855897	\N	1855897	\N	\N	2	1	2	f	\N	26	\N
1398	35	552	2	1499564	\N	1499564	\N	\N	3	1	2	f	\N	26	\N
1399	254	552	2	479066	\N	478887	\N	\N	4	1	2	f	179	26	\N
1400	125	552	2	266283	\N	266283	\N	\N	5	1	2	f	\N	\N	\N
1401	205	552	2	222475	\N	222475	\N	\N	6	1	2	f	\N	26	\N
1402	256	552	2	37226	\N	37226	\N	\N	7	1	2	f	\N	26	\N
1403	180	552	2	30940	\N	30940	\N	\N	8	1	2	f	\N	26	\N
1404	257	552	2	27017	\N	27017	\N	\N	9	1	2	f	\N	26	\N
1405	127	552	2	25693	\N	25693	\N	\N	10	1	2	f	\N	26	\N
1406	255	552	2	22653	\N	22653	\N	\N	11	1	2	f	\N	26	\N
1407	12	552	2	18218	\N	18217	\N	\N	12	1	2	f	1	\N	\N
1408	82	552	2	13700	\N	13700	\N	\N	13	1	2	f	\N	26	\N
1409	208	552	2	1536	\N	1536	\N	\N	14	1	2	f	\N	26	\N
1410	124	552	2	1512	\N	1512	\N	\N	15	1	2	f	\N	26	\N
1411	126	552	2	935	\N	935	\N	\N	16	1	2	f	\N	26	\N
1412	176	552	2	61	\N	61	\N	\N	17	1	2	f	\N	26	\N
1413	238	552	2	2	\N	2	\N	\N	18	1	2	f	\N	26	\N
1414	56	552	2	1809699	\N	1809699	\N	\N	0	1	2	f	\N	\N	\N
1415	100	552	2	1809699	\N	1809699	\N	\N	0	1	2	f	\N	\N	\N
1416	129	552	2	22	\N	22	\N	\N	0	1	2	f	\N	26	\N
1417	26	552	1	6428578	\N	6428578	\N	\N	1	1	2	f	\N	\N	\N
1418	58	553	2	15	\N	4	\N	\N	1	1	2	f	11	\N	\N
1419	120	553	2	15	\N	4	\N	\N	0	1	2	f	11	\N	\N
1420	7	553	2	9	\N	2	\N	\N	0	1	2	f	7	\N	\N
1421	246	553	2	9	\N	2	\N	\N	0	1	2	f	7	\N	\N
1422	242	553	1	4	\N	4	\N	\N	1	1	2	f	\N	58	\N
1423	81	554	2	1006	\N	0	\N	\N	1	1	2	f	1006	\N	\N
1424	120	554	2	1006	\N	0	\N	\N	0	1	2	f	1006	\N	\N
1425	7	554	2	841	\N	0	\N	\N	0	1	2	f	841	\N	\N
1426	246	554	2	841	\N	0	\N	\N	0	1	2	f	841	\N	\N
1427	213	555	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
1428	44	556	2	3997	\N	0	\N	\N	1	1	2	f	3997	\N	\N
1429	56	556	2	3997	\N	0	\N	\N	0	1	2	f	3997	\N	\N
1430	29	557	2	99	\N	99	\N	\N	1	1	2	f	0	29	\N
1431	29	557	1	99	\N	99	\N	\N	1	1	2	f	\N	29	\N
1432	213	558	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
1433	269	559	2	165	\N	0	\N	\N	1	1	2	f	165	\N	\N
1434	8	560	2	192	\N	0	\N	\N	1	1	2	f	192	\N	\N
1435	7	560	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1436	48	561	2	594	\N	0	\N	\N	1	1	2	f	594	\N	\N
1437	102	563	2	52253	\N	52253	\N	\N	1	1	2	f	0	\N	\N
1438	7	563	2	52192	\N	52192	\N	\N	0	1	2	f	0	\N	\N
1439	247	563	2	262	\N	262	\N	\N	0	1	2	f	0	\N	\N
1440	15	563	1	52150	\N	52150	\N	\N	1	1	2	f	\N	102	\N
1441	7	563	1	1737	\N	1737	\N	\N	0	1	2	f	\N	102	\N
1442	253	564	2	16576	\N	10566	\N	\N	1	1	2	f	6010	\N	\N
1443	8	564	1	10566	\N	10566	\N	\N	1	1	2	f	\N	253	\N
1444	31	565	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1445	129	566	2	95	\N	0	\N	\N	1	1	2	f	95	\N	\N
1446	35	567	2	1469992	\N	1469992	\N	\N	1	1	2	f	0	8	\N
1447	8	567	1	1469992	\N	1469992	\N	\N	1	1	2	f	\N	35	\N
1448	107	568	2	516	\N	0	\N	\N	1	1	2	f	516	\N	\N
1449	44	569	2	2460	\N	0	\N	\N	1	1	2	f	2460	\N	\N
1450	56	569	2	2460	\N	0	\N	\N	0	1	2	f	2460	\N	\N
1451	196	570	2	1108	\N	0	\N	\N	1	1	2	f	1108	\N	\N
1452	88	571	2	937120	\N	937120	\N	\N	1	1	2	f	0	8	\N
1453	207	571	2	167973	\N	167973	\N	\N	2	1	2	f	0	\N	\N
1454	248	571	2	25	\N	25	\N	\N	3	1	2	f	0	8	\N
1455	177	571	2	21	\N	21	\N	\N	4	1	2	f	0	8	\N
1456	12	571	2	11	\N	11	\N	\N	5	1	2	f	0	8	\N
1457	127	571	2	11	\N	11	\N	\N	6	1	2	f	0	8	\N
1458	252	571	2	1	\N	1	\N	\N	7	1	2	f	0	8	\N
1459	59	571	2	1	\N	1	\N	\N	8	1	2	f	0	8	\N
1460	129	571	2	110159	\N	110159	\N	\N	0	1	2	f	0	8	\N
1461	7	571	2	39	\N	39	\N	\N	0	1	2	f	0	8	\N
1462	120	571	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
1463	246	571	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
1464	247	571	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
1465	8	571	1	1215026	\N	1215026	\N	\N	1	1	2	f	\N	\N	\N
1466	42	572	2	23279	\N	0	\N	\N	1	1	2	f	23279	\N	\N
1467	56	572	2	23279	\N	0	\N	\N	0	1	2	f	23279	\N	\N
1468	223	573	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
1469	237	574	2	37642	\N	37642	\N	\N	1	1	2	f	0	\N	\N
1470	129	575	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
1471	60	576	2	33879	\N	0	\N	\N	1	1	2	f	33879	\N	\N
1472	56	576	2	33879	\N	0	\N	\N	0	1	2	f	33879	\N	\N
1473	107	578	2	1172	\N	1172	\N	\N	1	1	2	f	0	8	\N
1474	87	578	2	6	\N	6	\N	\N	0	1	2	f	0	8	\N
1475	7	578	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
1476	8	578	1	1166	\N	1166	\N	\N	1	1	2	f	\N	107	\N
1477	24	580	2	437249	\N	0	\N	\N	1	1	2	f	437249	\N	\N
1478	70	582	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
1479	69	583	2	208	\N	0	\N	\N	1	1	2	f	208	\N	\N
1480	70	583	2	49	\N	0	\N	\N	2	1	2	f	49	\N	\N
1481	157	584	2	49	\N	0	\N	\N	1	1	2	f	49	\N	\N
1482	15	585	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
1483	7	585	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1484	118	586	2	108	\N	108	\N	\N	0	1	2	f	0	110	\N
1485	110	586	1	72	\N	72	\N	\N	1	1	2	f	\N	\N	\N
1486	48	587	2	717	\N	0	\N	\N	1	1	2	f	717	\N	\N
1487	235	588	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
1488	56	588	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
1489	234	591	2	17901	\N	0	\N	\N	1	1	2	f	17901	\N	\N
1490	56	591	2	17901	\N	0	\N	\N	0	1	2	f	17901	\N	\N
1491	29	592	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1492	84	593	2	35667	\N	0	\N	\N	1	1	2	f	35667	\N	\N
1493	56	593	2	35667	\N	0	\N	\N	0	1	2	f	35667	\N	\N
1494	29	594	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
1495	128	596	2	7159	\N	0	\N	\N	1	1	2	f	7159	\N	\N
1496	175	597	2	1657	\N	0	\N	\N	1	1	2	f	1657	\N	\N
1497	91	598	2	35	\N	0	\N	\N	1	1	2	f	35	\N	\N
1498	128	599	2	4430	\N	4430	\N	\N	1	1	2	f	0	8	\N
1499	8	599	1	4430	\N	4430	\N	\N	1	1	2	f	\N	128	\N
1500	14	600	2	3372	\N	0	\N	\N	1	1	2	f	3372	\N	\N
1501	7	600	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1502	247	600	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1503	248	600	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1504	101	600	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1505	252	600	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1506	197	601	2	190753	\N	190753	\N	\N	1	1	2	f	0	\N	\N
1507	8	601	1	189350	\N	189350	\N	\N	1	1	2	f	\N	197	\N
1508	8	602	2	192	\N	0	\N	\N	1	1	2	f	192	\N	\N
1509	7	602	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1510	48	603	2	745	\N	0	\N	\N	1	1	2	f	745	\N	\N
1511	44	604	2	6637	\N	0	\N	\N	1	1	2	f	6637	\N	\N
1512	56	604	2	6637	\N	0	\N	\N	0	1	2	f	6637	\N	\N
1513	235	606	2	1177	\N	0	\N	\N	1	1	2	f	1177	\N	\N
1514	56	606	2	1177	\N	0	\N	\N	0	1	2	f	1177	\N	\N
1515	209	607	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
1516	209	608	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
1517	38	609	2	73	\N	0	\N	\N	1	1	2	f	73	\N	\N
1518	135	609	2	45	\N	0	\N	\N	2	1	2	f	45	\N	\N
1519	91	609	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
1520	39	609	2	21	\N	0	\N	\N	4	1	2	f	21	\N	\N
1521	8	609	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
1522	99	609	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1523	260	610	2	257	\N	0	\N	\N	1	1	2	f	257	\N	\N
1524	84	611	2	1471	\N	0	\N	\N	1	1	2	f	1471	\N	\N
1525	56	611	2	1471	\N	0	\N	\N	0	1	2	f	1471	\N	\N
1526	180	612	2	25061	\N	20231	\N	\N	1	1	2	f	4830	\N	\N
1527	178	612	2	11312	\N	1418	\N	\N	2	1	2	f	9894	\N	\N
1528	125	612	2	3942	\N	197	\N	\N	3	1	2	f	3745	\N	\N
1529	206	612	1	18700	\N	18700	\N	\N	1	1	2	f	\N	180	\N
1530	100	612	1	1615	\N	1615	\N	\N	2	1	2	f	\N	\N	\N
1531	246	612	1	476	\N	476	\N	\N	3	1	2	f	\N	180	\N
1532	95	612	1	18	\N	18	\N	\N	4	1	2	f	\N	180	\N
1533	56	612	1	1615	\N	1615	\N	\N	0	1	2	f	\N	\N	\N
1534	7	612	1	476	\N	476	\N	\N	0	1	2	f	\N	180	\N
1535	120	612	1	76	\N	76	\N	\N	0	1	2	f	\N	180	\N
1536	204	614	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
1537	120	614	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
1538	7	614	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1539	246	614	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1540	108	615	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
1541	231	616	2	6930	\N	0	\N	\N	1	1	2	f	6930	\N	\N
1542	11	616	2	2846	\N	0	\N	\N	2	1	2	f	2846	\N	\N
1543	81	616	2	80	\N	0	\N	\N	3	1	2	f	80	\N	\N
1544	120	616	2	80	\N	0	\N	\N	0	1	2	f	80	\N	\N
1545	7	616	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
1546	246	616	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
1547	196	617	2	212	\N	0	\N	\N	1	1	2	f	212	\N	\N
1548	253	618	2	5950	\N	5950	\N	\N	1	1	2	f	\N	8	\N
1549	81	618	2	168	\N	\N	\N	\N	2	1	2	f	168	\N	\N
1550	120	618	2	168	\N	\N	\N	\N	0	1	2	f	168	\N	\N
1551	7	618	2	130	\N	\N	\N	\N	0	1	2	f	130	\N	\N
1552	246	618	2	130	\N	\N	\N	\N	0	1	2	f	130	\N	\N
1553	8	618	1	5950	\N	5950	\N	\N	1	1	2	f	\N	253	\N
1554	8	619	2	4015	\N	2492	\N	\N	1	1	2	f	1523	\N	\N
1555	8	619	1	2492	\N	2492	\N	\N	1	1	2	f	\N	8	\N
1556	179	620	2	1206643	\N	1206643	\N	\N	1	1	2	f	0	243	\N
1557	243	620	2	1204282	\N	1204282	\N	\N	0	1	2	f	0	8	\N
1558	243	620	1	1206643	\N	1206643	\N	\N	1	1	2	f	\N	179	\N
1559	8	620	1	1203715	\N	1203715	\N	\N	0	1	2	f	\N	243	\N
1560	33	620	1	9	\N	9	\N	\N	0	1	2	f	\N	243	\N
1561	81	621	2	2208	\N	0	\N	\N	1	1	2	f	2208	\N	\N
1562	120	621	2	2208	\N	0	\N	\N	0	1	2	f	2208	\N	\N
1563	7	621	2	1754	\N	0	\N	\N	0	1	2	f	1754	\N	\N
1564	246	621	2	1754	\N	0	\N	\N	0	1	2	f	1754	\N	\N
1565	212	622	2	7804	\N	0	\N	\N	1	1	2	f	7804	\N	\N
1566	259	622	2	996	\N	0	\N	\N	2	1	2	f	996	\N	\N
1567	140	622	2	40	\N	0	\N	\N	3	1	2	f	40	\N	\N
1568	63	622	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
1569	137	622	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
1570	138	622	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
1571	161	622	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1572	73	623	2	105952	\N	105952	\N	\N	1	1	2	f	0	\N	\N
1573	13	623	1	66463	\N	66463	\N	\N	1	1	2	f	\N	73	\N
1574	249	623	1	268	\N	268	\N	\N	2	1	2	f	\N	73	\N
1575	14	623	1	178	\N	178	\N	\N	3	1	2	f	\N	73	\N
1576	56	623	1	268	\N	268	\N	\N	0	1	2	f	\N	73	\N
1577	100	623	1	268	\N	268	\N	\N	0	1	2	f	\N	73	\N
1578	97	624	2	14	\N	14	\N	\N	1	1	2	f	0	97	\N
1579	122	624	2	12	\N	12	\N	\N	0	1	2	f	0	122	\N
1580	230	624	2	2	\N	2	\N	\N	0	1	2	f	0	230	\N
1581	32	624	2	1	\N	1	\N	\N	0	1	2	f	0	62	\N
1582	62	624	2	1	\N	1	\N	\N	0	1	2	f	0	32	\N
1583	97	624	1	14	\N	14	\N	\N	1	1	2	f	\N	97	\N
1584	122	624	1	12	\N	12	\N	\N	0	1	2	f	\N	122	\N
1585	230	624	1	2	\N	2	\N	\N	0	1	2	f	\N	230	\N
1586	32	624	1	1	\N	1	\N	\N	0	1	2	f	\N	62	\N
1587	62	624	1	1	\N	1	\N	\N	0	1	2	f	\N	32	\N
1588	180	625	2	30935	\N	0	\N	\N	1	1	2	f	30935	\N	\N
1589	58	626	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
1590	120	626	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1591	7	626	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1592	246	626	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1593	120	627	2	348	\N	0	\N	\N	1	1	2	f	348	\N	\N
1594	7	627	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
1595	246	627	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
1596	160	628	2	233718	\N	0	\N	\N	1	1	2	f	233718	\N	\N
1597	8	629	2	1644	\N	1608	\N	\N	1	1	2	f	36	\N	\N
1598	7	629	2	2	\N	2	\N	\N	0	1	2	f	\N	8	\N
1599	8	629	1	1592	\N	1592	\N	\N	1	1	2	f	\N	8	\N
1600	253	630	2	17016	\N	17016	\N	\N	1	1	2	f	0	\N	\N
1601	128	630	2	7203	\N	7203	\N	\N	2	1	2	f	0	\N	\N
1602	120	630	2	6124	\N	6124	\N	\N	3	1	2	f	0	\N	\N
1603	7	630	2	5644	\N	5644	\N	\N	0	1	2	f	0	\N	\N
1604	246	630	2	5644	\N	5644	\N	\N	0	1	2	f	0	\N	\N
1605	231	630	2	4212	\N	4212	\N	\N	0	1	2	f	0	\N	\N
1606	11	630	2	1774	\N	1774	\N	\N	0	1	2	f	0	\N	\N
1607	34	630	2	70	\N	70	\N	\N	0	1	2	f	0	\N	\N
1608	81	630	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
1609	211	630	2	28	\N	28	\N	\N	0	1	2	f	0	38	\N
1610	38	630	1	15121	\N	15121	\N	\N	1	1	2	f	\N	\N	\N
1611	33	630	1	131	\N	131	\N	\N	2	1	2	f	\N	\N	\N
1612	8	630	1	15121	\N	15121	\N	\N	0	1	2	f	\N	\N	\N
1613	8	631	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1614	215	631	1	2	\N	2	\N	\N	1	1	2	f	\N	8	\N
1615	8	632	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1616	81	633	2	117	\N	0	\N	\N	1	1	2	f	117	\N	\N
1617	120	633	2	117	\N	0	\N	\N	0	1	2	f	117	\N	\N
1618	7	633	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
1619	246	633	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
1620	79	634	2	45279	\N	0	\N	\N	1	1	2	f	45279	\N	\N
1621	249	635	2	788642	\N	788642	\N	\N	1	1	2	f	0	225	\N
1622	177	635	2	1	\N	1	\N	\N	2	1	2	f	0	225	\N
1623	56	635	2	788642	\N	788642	\N	\N	0	1	2	f	0	225	\N
1624	100	635	2	788642	\N	788642	\N	\N	0	1	2	f	0	225	\N
1625	225	635	1	955581	\N	955581	\N	\N	1	1	2	f	\N	\N	\N
1626	58	636	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1627	120	636	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1628	7	636	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1629	246	636	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1630	213	637	2	492	\N	0	\N	\N	1	1	2	f	492	\N	\N
1631	178	638	2	1855886	\N	0	\N	\N	1	1	2	f	1855886	\N	\N
1632	125	638	2	266220	\N	0	\N	\N	2	1	2	f	266220	\N	\N
1633	56	638	2	1809636	\N	0	\N	\N	0	1	2	f	1809636	\N	\N
1634	100	638	2	1809636	\N	0	\N	\N	0	1	2	f	1809636	\N	\N
1635	80	639	2	2	\N	2	\N	\N	1	1	2	f	0	236	\N
1636	236	639	1	2	\N	2	\N	\N	1	1	2	f	\N	80	\N
1637	235	640	2	36012	\N	0	\N	\N	1	1	2	f	36012	\N	\N
1638	56	640	2	36012	\N	0	\N	\N	0	1	2	f	36012	\N	\N
1639	143	641	2	350	\N	0	\N	\N	1	1	2	f	350	\N	\N
1640	201	642	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1641	193	643	2	1555968	\N	0	\N	\N	1	1	2	f	1555968	\N	\N
1642	172	644	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1643	7	644	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1644	167	646	2	13577	\N	0	\N	\N	1	1	2	f	13577	\N	\N
1645	8	647	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
1646	7	647	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1647	164	648	2	90	\N	0	\N	\N	1	1	2	f	90	\N	\N
1648	271	648	2	78	\N	0	\N	\N	2	1	2	f	78	\N	\N
1649	17	649	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1650	17	649	1	7	\N	7	\N	\N	1	1	2	f	\N	17	\N
1651	131	649	1	3	\N	3	\N	\N	2	1	2	f	\N	17	\N
1652	204	650	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
1653	120	650	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
1654	7	650	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1655	246	650	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1656	181	652	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
1657	56	652	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
1658	81	653	2	2381	\N	0	\N	\N	1	1	2	f	2381	\N	\N
1659	120	653	2	2381	\N	0	\N	\N	0	1	2	f	2381	\N	\N
1660	7	653	2	1902	\N	0	\N	\N	0	1	2	f	1902	\N	\N
1661	246	653	2	1902	\N	0	\N	\N	0	1	2	f	1902	\N	\N
1662	37	655	2	955	\N	0	\N	\N	1	1	2	f	955	\N	\N
1663	231	656	2	6451	\N	0	\N	\N	1	1	2	f	6451	\N	\N
1664	11	656	2	2830	\N	0	\N	\N	2	1	2	f	2830	\N	\N
1665	179	657	2	1925993	\N	1925993	\N	\N	1	1	2	f	0	2	\N
1666	2	657	1	1925993	\N	1925993	\N	\N	1	1	2	f	\N	179	\N
1667	179	658	2	1647611	\N	1647611	\N	\N	1	1	2	f	0	78	\N
1668	178	658	2	116070	\N	116070	\N	\N	2	1	2	f	0	78	\N
1669	256	658	2	33914	\N	33914	\N	\N	3	1	2	f	0	78	\N
1670	257	658	2	26690	\N	26690	\N	\N	4	1	2	f	0	78	\N
1671	125	658	2	21662	\N	21662	\N	\N	5	1	2	f	0	78	\N
1672	82	658	2	13505	\N	13505	\N	\N	6	1	2	f	0	78	\N
1673	56	658	2	101948	\N	101948	\N	\N	0	1	2	f	0	78	\N
1674	100	658	2	101948	\N	101948	\N	\N	0	1	2	f	0	78	\N
1675	78	658	1	1859452	\N	1859452	\N	\N	1	1	2	f	\N	\N	\N
1676	214	659	2	73	\N	0	\N	\N	1	1	2	f	73	\N	\N
1677	10	659	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
1678	60	660	2	77	\N	0	\N	\N	1	1	2	f	77	\N	\N
1679	56	660	2	77	\N	0	\N	\N	0	1	2	f	77	\N	\N
1680	75	661	2	4804	\N	4804	\N	\N	1	1	2	f	0	59	\N
1681	59	661	1	4804	\N	4804	\N	\N	1	1	2	f	\N	75	\N
1682	253	662	2	5168	\N	0	\N	\N	1	1	2	f	5168	\N	\N
1683	48	663	2	588	\N	0	\N	\N	1	1	2	f	588	\N	\N
1684	250	664	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1685	42	665	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
1686	56	665	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
1687	125	666	2	262278	\N	262227	\N	\N	1	1	2	f	51	\N	\N
1688	56	666	2	226388	\N	226337	\N	\N	0	1	2	f	51	\N	\N
1689	100	666	2	226388	\N	226337	\N	\N	0	1	2	f	51	\N	\N
1690	8	666	1	240943	\N	240943	\N	\N	1	1	2	f	\N	125	\N
1691	42	667	2	24222	\N	0	\N	\N	1	1	2	f	24222	\N	\N
1692	56	667	2	24222	\N	0	\N	\N	0	1	2	f	24222	\N	\N
1693	194	668	2	5262	\N	0	\N	\N	1	1	2	f	5262	\N	\N
1694	78	669	2	1961401	\N	0	\N	\N	1	1	2	f	1961401	\N	\N
1695	259	670	2	996	\N	0	\N	\N	1	1	2	f	996	\N	\N
1696	63	670	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
1697	137	670	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
1698	138	670	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
1699	161	670	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1700	144	671	2	53586	\N	0	\N	\N	1	1	2	f	53586	\N	\N
1701	150	671	2	862	\N	0	\N	\N	2	1	2	f	862	\N	\N
1702	105	671	2	550	\N	0	\N	\N	0	1	2	f	550	\N	\N
1703	159	672	2	225	\N	0	\N	\N	1	1	2	f	225	\N	\N
1704	181	673	2	3723	\N	0	\N	\N	1	1	2	f	3723	\N	\N
1705	56	673	2	3723	\N	0	\N	\N	0	1	2	f	3723	\N	\N
1706	97	674	2	235	\N	235	\N	\N	1	1	2	f	0	\N	\N
1707	155	674	2	48	\N	48	\N	\N	2	1	2	f	0	\N	\N
1708	110	674	2	36	\N	36	\N	\N	3	1	2	f	0	\N	\N
1709	184	674	2	4	\N	4	\N	\N	4	1	2	f	0	\N	\N
1710	118	674	2	196	\N	196	\N	\N	0	1	2	f	0	\N	\N
1711	15	675	2	671	\N	671	\N	\N	1	1	2	f	0	215	\N
1712	7	675	2	2	\N	2	\N	\N	0	1	2	f	0	215	\N
1713	215	675	1	671	\N	671	\N	\N	1	1	2	f	\N	15	\N
1714	111	676	2	611	\N	0	\N	\N	1	1	2	f	611	\N	\N
1715	48	677	2	5053	\N	0	\N	\N	1	1	2	f	5053	\N	\N
1716	58	678	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1717	120	678	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1718	7	678	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1719	246	678	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1720	178	679	2	332675	\N	332675	\N	\N	1	1	2	f	0	\N	\N
1721	56	679	2	231305	\N	231305	\N	\N	0	1	2	f	0	8	\N
1722	100	679	2	231305	\N	231305	\N	\N	0	1	2	f	0	8	\N
1723	8	679	1	231327	\N	231327	\N	\N	1	1	2	f	\N	178	\N
1724	256	681	2	36990	\N	36990	\N	\N	1	1	2	f	0	\N	\N
1725	82	681	2	11681	\N	11681	\N	\N	2	1	2	f	0	\N	\N
1726	8	681	1	48491	\N	48491	\N	\N	1	1	2	f	\N	\N	\N
1727	8	682	2	232669	\N	232669	\N	\N	1	1	2	f	0	33	\N
1728	99	682	2	135	\N	135	\N	\N	2	1	2	f	0	33	\N
1729	89	682	2	48	\N	48	\N	\N	3	1	2	f	0	131	\N
1730	38	682	2	73	\N	73	\N	\N	0	1	2	f	0	33	\N
1731	239	682	2	40	\N	40	\N	\N	0	1	2	f	0	33	\N
1732	185	682	2	32	\N	32	\N	\N	0	1	2	f	0	33	\N
1733	39	682	2	21	\N	21	\N	\N	0	1	2	f	0	33	\N
1734	139	682	2	4	\N	4	\N	\N	0	1	2	f	0	33	\N
1735	7	682	2	3	\N	3	\N	\N	0	1	2	f	0	33	\N
1736	33	682	1	232804	\N	232804	\N	\N	1	1	2	f	\N	\N	\N
1737	131	682	1	48	\N	48	\N	\N	2	1	2	f	\N	89	\N
1738	84	683	2	4477	\N	0	\N	\N	1	1	2	f	4477	\N	\N
1739	56	683	2	4477	\N	0	\N	\N	0	1	2	f	4477	\N	\N
1740	81	684	2	2414	\N	0	\N	\N	1	1	2	f	2414	\N	\N
1741	120	684	2	2414	\N	0	\N	\N	0	1	2	f	2414	\N	\N
1742	7	684	2	1812	\N	0	\N	\N	0	1	2	f	1812	\N	\N
1743	246	684	2	1812	\N	0	\N	\N	0	1	2	f	1812	\N	\N
1744	133	685	2	197	\N	0	\N	\N	1	1	2	f	197	\N	\N
1745	128	686	2	418	\N	0	\N	\N	1	1	2	f	418	\N	\N
1746	97	687	2	5943	\N	5943	\N	\N	1	1	2	f	0	\N	\N
1747	122	687	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
1748	62	687	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1749	9	687	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1750	229	687	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1751	119	687	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1752	147	687	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1753	32	687	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1754	230	687	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1755	184	687	1	16	\N	16	\N	\N	1	1	2	f	\N	97	\N
1756	201	687	1	15	\N	15	\N	\N	2	1	2	f	\N	\N	\N
1757	155	687	1	1	\N	1	\N	\N	3	1	2	f	\N	97	\N
1758	97	687	1	1	\N	1	\N	\N	4	1	2	f	\N	97	\N
1759	118	687	1	214	\N	214	\N	\N	0	1	2	f	\N	\N	\N
1760	15	688	2	926	\N	926	\N	\N	1	1	2	f	0	64	\N
1761	7	688	2	2	\N	2	\N	\N	0	1	2	f	0	64	\N
1762	64	688	1	926	\N	926	\N	\N	1	1	2	f	\N	15	\N
1763	55	689	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1764	81	691	2	115	\N	0	\N	\N	1	1	2	f	115	\N	\N
1765	120	691	2	115	\N	0	\N	\N	0	1	2	f	115	\N	\N
1766	7	691	2	90	\N	0	\N	\N	0	1	2	f	90	\N	\N
1767	246	691	2	90	\N	0	\N	\N	0	1	2	f	90	\N	\N
1768	76	692	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
1769	37	692	2	1721	\N	0	\N	\N	2	1	2	f	1721	\N	\N
1770	105	692	2	550	\N	0	\N	\N	3	1	2	f	550	\N	\N
1771	150	692	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1772	129	693	2	145	\N	0	\N	\N	1	1	2	f	145	\N	\N
1773	268	694	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
1774	233	695	2	2367115	\N	2367115	\N	\N	1	1	2	f	0	\N	\N
1775	36	695	2	484238	\N	484238	\N	\N	2	1	2	f	0	8	\N
1776	8	695	1	2849330	\N	2849330	\N	\N	1	1	2	f	\N	\N	\N
1777	60	697	2	40831	\N	0	\N	\N	1	1	2	f	40831	\N	\N
1778	56	697	2	40831	\N	0	\N	\N	0	1	2	f	40831	\N	\N
1779	209	698	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
1780	42	699	2	25252	\N	25252	\N	\N	1	1	2	f	0	\N	\N
1781	56	699	2	25252	\N	25252	\N	\N	0	1	2	f	0	\N	\N
1782	88	700	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
1783	15	701	2	257	\N	257	\N	\N	1	1	2	f	0	\N	\N
1784	7	701	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1785	201	702	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
1786	165	703	2	91	\N	0	\N	\N	1	1	2	f	91	\N	\N
1787	44	704	2	3619	\N	0	\N	\N	1	1	2	f	3619	\N	\N
1788	56	704	2	3582	\N	0	\N	\N	0	1	2	f	3582	\N	\N
1789	246	705	2	523576	\N	0	\N	\N	1	1	2	f	523576	\N	\N
1790	33	705	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1791	172	705	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1792	7	705	2	523477	\N	0	\N	\N	0	1	2	f	523477	\N	\N
1793	120	705	2	156247	\N	0	\N	\N	0	1	2	f	156247	\N	\N
1794	247	705	2	147972	\N	0	\N	\N	0	1	2	f	147972	\N	\N
1795	231	705	2	3865	\N	0	\N	\N	0	1	2	f	3865	\N	\N
1796	57	705	2	3454	\N	0	\N	\N	0	1	2	f	3454	\N	\N
1797	123	705	2	2850	\N	0	\N	\N	0	1	2	f	2850	\N	\N
1798	11	705	2	1675	\N	0	\N	\N	0	1	2	f	1675	\N	\N
1799	232	705	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
1800	34	705	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1801	58	705	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
1802	81	705	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
1803	204	705	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1804	211	705	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1805	129	705	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1806	248	705	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1807	209	706	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
1808	15	707	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1809	124	708	2	1512	\N	1512	\N	\N	1	1	2	f	0	190	\N
1810	190	708	1	1512	\N	1512	\N	\N	1	1	2	f	\N	124	\N
1811	242	709	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
1812	42	710	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
1813	56	710	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
1814	209	711	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
1815	105	712	2	363	\N	0	\N	\N	1	1	2	f	363	\N	\N
1816	150	712	2	142	\N	0	\N	\N	0	1	2	f	142	\N	\N
1817	44	713	2	7013	\N	0	\N	\N	1	1	2	f	7013	\N	\N
1818	56	713	2	6976	\N	0	\N	\N	0	1	2	f	6976	\N	\N
1819	237	714	2	217681	\N	217681	\N	\N	1	1	2	f	0	\N	\N
1820	8	714	1	105685	\N	105685	\N	\N	1	1	2	f	\N	237	\N
1821	7	714	1	1086	\N	1086	\N	\N	0	1	2	f	\N	237	\N
1822	101	715	2	29941	\N	29941	\N	\N	1	1	2	f	0	\N	\N
1823	8	715	1	29832	\N	29832	\N	\N	1	1	2	f	\N	101	\N
1824	33	715	1	12	\N	12	\N	\N	2	1	2	f	\N	101	\N
1825	109	716	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
1826	263	717	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
1827	234	718	2	19984	\N	0	\N	\N	1	1	2	f	19984	\N	\N
1828	56	718	2	19984	\N	0	\N	\N	0	1	2	f	19984	\N	\N
1829	181	720	2	5461	\N	0	\N	\N	1	1	2	f	5461	\N	\N
1830	56	720	2	5461	\N	0	\N	\N	0	1	2	f	5461	\N	\N
1831	8	721	2	494	\N	419	\N	\N	1	1	2	f	75	\N	\N
1832	8	721	1	419	\N	419	\N	\N	1	1	2	f	\N	8	\N
1833	8	722	2	3006	\N	3006	\N	\N	1	1	2	f	0	\N	\N
1834	217	723	2	1124	\N	0	\N	\N	1	1	2	f	1124	\N	\N
1835	52	724	2	17781	\N	0	\N	\N	1	1	2	f	17781	\N	\N
1836	48	725	2	1611	\N	0	\N	\N	1	1	2	f	1611	\N	\N
1837	48	726	2	286	\N	0	\N	\N	1	1	2	f	286	\N	\N
1838	213	727	2	984	\N	984	\N	\N	1	1	2	f	0	\N	\N
1839	25	727	1	738	\N	738	\N	\N	1	1	2	f	\N	213	\N
1840	192	727	1	246	\N	246	\N	\N	2	1	2	f	\N	213	\N
1841	216	728	2	185	\N	0	\N	\N	1	1	2	f	185	\N	\N
1842	180	730	2	30896	\N	0	\N	\N	1	1	2	f	30896	\N	\N
1843	175	731	2	1657	\N	0	\N	\N	1	1	2	f	1657	\N	\N
1844	88	732	2	935732	\N	0	\N	\N	1	1	2	f	935732	\N	\N
1845	14	735	2	3027	\N	0	\N	\N	1	1	2	f	3027	\N	\N
1846	7	735	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1847	247	735	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1848	248	735	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1849	101	735	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1850	252	735	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1851	253	736	2	17016	\N	17016	\N	\N	1	1	2	f	0	\N	\N
1852	128	736	2	7203	\N	7203	\N	\N	2	1	2	f	0	\N	\N
1853	120	736	2	311	\N	311	\N	\N	3	1	2	f	0	\N	\N
1854	7	736	2	230	\N	230	\N	\N	0	1	2	f	0	\N	\N
1855	246	736	2	230	\N	230	\N	\N	0	1	2	f	0	\N	\N
1856	34	736	2	218	\N	218	\N	\N	0	1	2	f	0	\N	\N
1857	211	736	2	93	\N	93	\N	\N	0	1	2	f	0	91	\N
1858	91	736	1	15389	\N	15389	\N	\N	1	1	2	f	\N	\N	\N
1859	8	736	1	9024	\N	9024	\N	\N	2	1	2	f	\N	\N	\N
1860	37	737	2	34407	\N	0	\N	\N	1	1	2	f	34407	\N	\N
1861	181	739	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
1862	56	739	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
1863	172	740	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1864	180	741	2	29718	\N	29718	\N	\N	1	1	2	f	0	\N	\N
1865	8	741	1	18291	\N	18291	\N	\N	1	1	2	f	\N	180	\N
1866	235	742	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
1867	56	742	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
1868	208	743	2	5253	\N	5253	\N	\N	1	1	2	f	0	\N	\N
1869	129	743	1	4310	\N	4310	\N	\N	1	1	2	f	\N	208	\N
1870	108	744	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
1871	214	746	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1872	10	746	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1873	56	747	2	19346	\N	0	\N	\N	1	1	2	f	19346	\N	\N
1874	150	747	2	82	\N	0	\N	\N	2	1	2	f	82	\N	\N
1875	246	747	2	60	\N	0	\N	\N	3	1	2	f	60	\N	\N
1876	42	747	2	15451	\N	0	\N	\N	0	1	2	f	15451	\N	\N
1877	60	747	2	3895	\N	0	\N	\N	0	1	2	f	3895	\N	\N
1878	7	747	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
1879	120	747	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
1880	105	747	2	55	\N	0	\N	\N	0	1	2	f	55	\N	\N
1881	101	748	2	38488	\N	38488	\N	\N	1	1	2	f	0	\N	\N
1882	8	748	1	38305	\N	38305	\N	\N	1	1	2	f	\N	101	\N
1883	33	748	1	2	\N	2	\N	\N	2	1	2	f	\N	101	\N
1884	235	749	2	4877	\N	0	\N	\N	1	1	2	f	4877	\N	\N
1885	56	749	2	4877	\N	0	\N	\N	0	1	2	f	4877	\N	\N
1886	58	750	2	35	\N	0	\N	\N	1	1	2	f	35	\N	\N
1887	120	750	2	35	\N	0	\N	\N	0	1	2	f	35	\N	\N
1888	7	750	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1889	246	750	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1890	235	751	2	4039	\N	0	\N	\N	1	1	2	f	4039	\N	\N
1891	56	751	2	4039	\N	0	\N	\N	0	1	2	f	4039	\N	\N
1892	16	752	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
1893	48	753	2	407	\N	0	\N	\N	1	1	2	f	407	\N	\N
1894	14	754	2	3259	\N	0	\N	\N	1	1	2	f	3259	\N	\N
1895	7	754	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1896	247	754	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1897	248	754	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1898	101	754	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1899	252	754	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1900	172	755	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1901	128	756	2	4436	\N	0	\N	\N	1	1	2	f	4436	\N	\N
1902	128	757	2	4436	\N	0	\N	\N	1	1	2	f	4436	\N	\N
1903	128	758	2	4436	\N	0	\N	\N	1	1	2	f	4436	\N	\N
1904	181	760	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
1905	56	760	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
1906	118	761	2	443	\N	443	\N	\N	0	1	2	f	0	\N	\N
1907	234	762	2	33849	\N	0	\N	\N	1	1	2	f	33849	\N	\N
1908	56	762	2	33848	\N	0	\N	\N	0	1	2	f	33848	\N	\N
1909	186	763	2	13589717	\N	0	\N	\N	1	1	2	f	13589717	\N	\N
1910	129	763	2	337	\N	0	\N	\N	2	1	2	f	337	\N	\N
1911	105	765	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
1912	150	765	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
1913	128	768	2	4427	\N	4427	\N	\N	1	1	2	f	0	8	\N
1914	8	768	1	4427	\N	4427	\N	\N	1	1	2	f	\N	128	\N
1915	253	772	2	10399	\N	0	\N	\N	1	1	2	f	10399	\N	\N
1916	128	772	2	4428	\N	0	\N	\N	2	1	2	f	4428	\N	\N
1917	42	774	2	25252	\N	25252	\N	\N	1	1	2	f	0	\N	\N
1918	56	774	2	25252	\N	25252	\N	\N	0	1	2	f	0	\N	\N
1919	7	775	2	276149	\N	0	\N	\N	1	1	2	f	276149	\N	\N
1920	248	775	2	230240	\N	0	\N	\N	0	1	2	f	230240	\N	\N
1921	247	775	2	183398	\N	0	\N	\N	0	1	2	f	183398	\N	\N
1922	102	775	2	46146	\N	0	\N	\N	0	1	2	f	46146	\N	\N
1923	129	775	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
1924	87	775	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1925	14	775	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1926	120	775	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1927	103	775	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1928	246	775	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1929	42	776	2	24222	\N	24222	\N	\N	1	1	2	f	0	\N	\N
1930	56	776	2	24222	\N	24222	\N	\N	0	1	2	f	0	\N	\N
1931	126	777	2	935	\N	935	\N	\N	1	1	2	f	0	143	\N
1932	143	777	1	935	\N	935	\N	\N	1	1	2	f	\N	126	\N
1933	253	779	2	10556	\N	10556	\N	\N	1	1	2	f	0	8	\N
1934	8	779	1	10556	\N	10556	\N	\N	1	1	2	f	\N	253	\N
1935	79	780	2	61071	\N	61071	\N	\N	1	1	2	f	0	\N	\N
1936	8	780	1	56025	\N	56025	\N	\N	1	1	2	f	\N	79	\N
1937	120	781	2	59	\N	0	\N	\N	1	1	2	f	59	\N	\N
1938	247	781	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1939	7	781	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
1940	246	781	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
1941	162	782	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
1942	107	783	2	1492	\N	0	\N	\N	1	1	2	f	1492	\N	\N
1943	87	783	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1944	7	783	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1945	210	784	2	36540	\N	36540	\N	\N	1	1	2	f	0	\N	\N
1946	181	784	1	36067	\N	36067	\N	\N	1	1	2	f	\N	210	\N
1947	56	784	1	36067	\N	36067	\N	\N	0	1	2	f	\N	210	\N
1948	125	785	2	266220	\N	0	\N	\N	1	1	2	f	266220	\N	\N
1949	56	785	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
1950	100	785	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
1951	7	786	2	838071	\N	0	\N	\N	1	1	2	f	838071	\N	\N
1952	215	786	2	216	\N	0	\N	\N	2	1	2	f	216	\N	\N
1953	265	786	2	87	\N	0	\N	\N	3	1	2	f	87	\N	\N
1954	250	786	2	41	\N	0	\N	\N	4	1	2	f	41	\N	\N
1955	33	786	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
1956	251	786	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
1957	246	786	2	523835	\N	0	\N	\N	0	1	2	f	523835	\N	\N
1958	247	786	2	354872	\N	0	\N	\N	0	1	2	f	354872	\N	\N
1959	248	786	2	230241	\N	0	\N	\N	0	1	2	f	230241	\N	\N
1960	120	786	2	156512	\N	0	\N	\N	0	1	2	f	156512	\N	\N
1961	102	786	2	46371	\N	0	\N	\N	0	1	2	f	46371	\N	\N
1962	252	786	2	37980	\N	0	\N	\N	0	1	2	f	37980	\N	\N
1963	231	786	2	3865	\N	0	\N	\N	0	1	2	f	3865	\N	\N
1964	57	786	2	3455	\N	0	\N	\N	0	1	2	f	3455	\N	\N
1965	123	786	2	2850	\N	0	\N	\N	0	1	2	f	2850	\N	\N
1966	11	786	2	1675	\N	0	\N	\N	0	1	2	f	1675	\N	\N
1967	15	786	2	671	\N	0	\N	\N	0	1	2	f	671	\N	\N
1968	232	786	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
1969	34	786	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
1970	58	786	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
1971	129	786	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
1972	81	786	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
1973	204	786	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1974	211	786	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
1975	14	786	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1976	87	786	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1977	172	786	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1978	103	786	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1979	262	788	2	1	\N	1	\N	\N	1	1	2	f	0	78	\N
1980	78	788	1	1	\N	1	\N	\N	1	1	2	f	\N	262	\N
1981	42	789	2	24222	\N	24222	\N	\N	1	1	2	f	0	\N	\N
1982	56	789	2	24222	\N	24222	\N	\N	0	1	2	f	0	\N	\N
1983	33	791	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
1984	37	792	2	35527	\N	0	\N	\N	1	1	2	f	35527	\N	\N
1985	101	793	2	61906	\N	61906	\N	\N	1	1	2	f	0	\N	\N
1986	14	793	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
1987	8	793	1	61834	\N	61834	\N	\N	1	1	2	f	\N	101	\N
1988	84	794	2	4673	\N	0	\N	\N	1	1	2	f	4673	\N	\N
1989	56	794	2	4673	\N	0	\N	\N	0	1	2	f	4673	\N	\N
1990	81	795	2	1084	\N	0	\N	\N	1	1	2	f	1084	\N	\N
1991	120	795	2	1084	\N	0	\N	\N	0	1	2	f	1084	\N	\N
1992	7	795	2	938	\N	0	\N	\N	0	1	2	f	938	\N	\N
1993	246	795	2	938	\N	0	\N	\N	0	1	2	f	938	\N	\N
1994	271	796	2	76	\N	0	\N	\N	1	1	2	f	76	\N	\N
1995	84	797	2	36450	\N	36450	\N	\N	1	1	2	f	0	\N	\N
1996	56	797	2	36450	\N	36450	\N	\N	0	1	2	f	0	\N	\N
1997	235	797	1	36448	\N	36448	\N	\N	1	1	2	f	\N	84	\N
1998	56	797	1	36448	\N	36448	\N	\N	0	1	2	f	\N	84	\N
1999	234	799	2	33845	\N	0	\N	\N	1	1	2	f	33845	\N	\N
2000	56	799	2	33844	\N	0	\N	\N	0	1	2	f	33844	\N	\N
2001	181	800	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
2002	56	800	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
2003	48	801	2	318	\N	0	\N	\N	1	1	2	f	318	\N	\N
2004	109	802	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
2005	133	803	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
2006	29	804	1	128	\N	128	\N	\N	1	1	2	f	\N	\N	\N
2007	171	804	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
2008	30	804	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
2009	5	804	1	2	\N	2	\N	\N	4	1	2	f	\N	\N	\N
2010	207	805	2	119168	\N	0	\N	\N	1	1	2	f	119168	\N	\N
2011	103	805	2	7530	\N	0	\N	\N	2	1	2	f	7530	\N	\N
2012	107	805	2	3974	\N	0	\N	\N	3	1	2	f	3974	\N	\N
2013	177	805	2	21	\N	0	\N	\N	4	1	2	f	21	\N	\N
2014	12	805	2	11	\N	0	\N	\N	5	1	2	f	11	\N	\N
2015	127	805	2	11	\N	0	\N	\N	6	1	2	f	11	\N	\N
2016	120	805	2	11	\N	0	\N	\N	7	1	2	f	11	\N	\N
2017	59	805	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
2018	129	805	2	107864	\N	0	\N	\N	0	1	2	f	107864	\N	\N
2019	7	805	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
2020	248	805	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2021	246	805	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2022	87	805	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2023	247	805	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2024	252	805	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2025	60	806	2	17380	\N	0	\N	\N	1	1	2	f	17380	\N	\N
2026	56	806	2	17380	\N	0	\N	\N	0	1	2	f	17380	\N	\N
2027	181	807	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
2028	56	807	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
2029	46	808	2	19068	\N	0	\N	\N	1	1	2	f	19068	\N	\N
2030	235	809	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
2031	56	809	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
2032	74	810	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
2033	190	810	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
2034	52	810	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
2035	35	811	2	705645	\N	705645	\N	\N	1	1	2	f	0	8	\N
2036	8	811	1	705597	\N	705597	\N	\N	1	1	2	f	\N	35	\N
2037	8	812	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2038	7	812	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2039	120	813	2	167	\N	0	\N	\N	1	1	2	f	167	\N	\N
2040	7	813	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
2041	34	813	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
2042	246	813	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
2043	211	813	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
2044	263	815	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
2045	14	816	2	117692	\N	117692	\N	\N	1	1	2	f	0	\N	\N
2046	101	816	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
2047	7	816	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
2048	247	816	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2049	248	816	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2050	252	816	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2051	2	816	1	6168	\N	6168	\N	\N	1	1	2	f	\N	14	\N
2052	81	817	2	618	\N	0	\N	\N	1	1	2	f	618	\N	\N
2053	120	817	2	618	\N	0	\N	\N	0	1	2	f	618	\N	\N
2054	7	817	2	522	\N	0	\N	\N	0	1	2	f	522	\N	\N
2055	246	817	2	522	\N	0	\N	\N	0	1	2	f	522	\N	\N
2056	36	818	2	484237	\N	484237	\N	\N	1	1	2	f	0	59	\N
2057	59	818	1	484237	\N	484237	\N	\N	1	1	2	f	\N	36	\N
2058	81	819	2	2600	\N	0	\N	\N	1	1	2	f	2600	\N	\N
2059	120	819	2	2600	\N	0	\N	\N	0	1	2	f	2600	\N	\N
2060	7	819	2	2131	\N	0	\N	\N	0	1	2	f	2131	\N	\N
2061	246	819	2	2131	\N	0	\N	\N	0	1	2	f	2131	\N	\N
2062	8	820	2	3406	\N	3406	\N	\N	1	1	2	f	0	8	\N
2063	8	820	1	3406	\N	3406	\N	\N	1	1	2	f	\N	8	\N
2064	120	821	2	470	\N	0	\N	\N	1	1	2	f	470	\N	\N
2065	34	821	2	413	\N	0	\N	\N	0	1	2	f	413	\N	\N
2066	7	821	2	335	\N	0	\N	\N	0	1	2	f	335	\N	\N
2067	246	821	2	335	\N	0	\N	\N	0	1	2	f	335	\N	\N
2068	211	821	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
2069	258	822	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
2070	56	822	2	246	\N	0	\N	\N	0	1	2	f	246	\N	\N
2071	7	823	2	40422	\N	0	\N	\N	1	1	2	f	40422	\N	\N
2072	85	823	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
2073	121	823	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
2074	153	823	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
2075	246	823	2	22447	\N	0	\N	\N	0	1	2	f	22447	\N	\N
2076	248	823	2	15357	\N	0	\N	\N	0	1	2	f	15357	\N	\N
2077	252	823	2	2610	\N	0	\N	\N	0	1	2	f	2610	\N	\N
2078	247	823	2	1421	\N	0	\N	\N	0	1	2	f	1421	\N	\N
2079	120	823	2	94	\N	0	\N	\N	0	1	2	f	94	\N	\N
2080	129	823	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
2081	107	823	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2082	87	823	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2083	231	823	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2084	57	823	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2085	103	823	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2086	228	824	2	8	\N	8	\N	\N	1	1	2	f	0	245	\N
2087	245	824	1	8	\N	8	\N	\N	1	1	2	f	\N	228	\N
2088	250	825	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2089	202	826	2	70896	\N	70896	\N	\N	1	1	2	f	0	8	\N
2090	8	826	1	70896	\N	70896	\N	\N	1	1	2	f	\N	202	\N
2091	253	827	2	3064	\N	0	\N	\N	1	1	2	f	3064	\N	\N
2092	81	827	2	537	\N	0	\N	\N	2	1	2	f	537	\N	\N
2093	120	827	2	537	\N	0	\N	\N	0	1	2	f	537	\N	\N
2094	7	827	2	409	\N	0	\N	\N	0	1	2	f	409	\N	\N
2095	246	827	2	409	\N	0	\N	\N	0	1	2	f	409	\N	\N
2096	258	828	2	30130	\N	0	\N	\N	1	1	2	f	30130	\N	\N
2097	56	828	2	30130	\N	0	\N	\N	0	1	2	f	30130	\N	\N
2098	210	830	2	36540	\N	0	\N	\N	1	1	2	f	36540	\N	\N
2099	209	831	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2100	29	832	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
2101	74	833	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
2102	190	833	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
2103	52	833	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
2104	66	834	2	415	\N	0	\N	\N	1	1	2	f	415	\N	\N
2105	40	834	2	57	\N	0	\N	\N	2	1	2	f	57	\N	\N
2106	83	835	2	2461	\N	0	\N	\N	1	1	2	f	2461	\N	\N
2107	37	835	2	900	\N	0	\N	\N	2	1	2	f	900	\N	\N
2108	97	836	2	5903	\N	5903	\N	\N	1	1	2	f	0	\N	\N
2109	229	836	2	1794	\N	1794	\N	\N	0	1	2	f	0	\N	\N
2110	122	836	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
2111	62	836	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2112	9	836	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
2113	119	836	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2114	147	836	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2115	32	836	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2116	230	836	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2117	201	836	1	8	\N	8	\N	\N	1	1	2	f	\N	97	\N
2118	118	836	1	7685	\N	7685	\N	\N	0	1	2	f	\N	\N	\N
2119	210	837	2	5642	\N	0	\N	\N	1	1	2	f	5642	\N	\N
2120	66	838	2	415	\N	0	\N	\N	1	1	2	f	415	\N	\N
2121	40	838	2	57	\N	0	\N	\N	2	1	2	f	57	\N	\N
2122	233	839	2	2365155	\N	2365155	\N	\N	1	1	2	f	0	\N	\N
2123	8	839	1	2312129	\N	2312129	\N	\N	1	1	2	f	\N	233	\N
2124	178	841	2	1827689	\N	0	\N	\N	1	1	2	f	1827689	\N	\N
2125	256	841	2	23937	\N	0	\N	\N	2	1	2	f	23937	\N	\N
2126	56	841	2	1555051	\N	0	\N	\N	0	1	2	f	1555051	\N	\N
2127	100	841	2	1555051	\N	0	\N	\N	0	1	2	f	1555051	\N	\N
2128	29	842	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2129	53	843	2	304329	\N	304329	\N	\N	1	1	2	f	0	\N	\N
2130	8	843	1	304023	\N	304023	\N	\N	1	1	2	f	\N	53	\N
2131	33	843	1	4	\N	4	\N	\N	2	1	2	f	\N	53	\N
2132	42	845	2	755	\N	0	\N	\N	1	1	2	f	755	\N	\N
2133	56	845	2	755	\N	0	\N	\N	0	1	2	f	755	\N	\N
2134	8	846	2	1194	\N	0	\N	\N	1	1	2	f	1194	\N	\N
2135	253	847	2	3480	\N	0	\N	\N	1	1	2	f	3480	\N	\N
2136	185	848	2	32	\N	32	\N	\N	1	1	2	f	0	139	\N
2137	99	848	2	32	\N	32	\N	\N	0	1	2	f	0	139	\N
2138	139	848	1	32	\N	32	\N	\N	1	1	2	f	\N	185	\N
2139	99	848	1	32	\N	32	\N	\N	0	1	2	f	\N	185	\N
2140	220	849	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
2141	101	850	2	13094	\N	0	\N	\N	1	1	2	f	13094	\N	\N
2142	181	851	2	4669	\N	0	\N	\N	1	1	2	f	4669	\N	\N
2143	56	851	2	4669	\N	0	\N	\N	0	1	2	f	4669	\N	\N
2144	253	852	2	10558	\N	10558	\N	\N	1	1	2	f	\N	8	\N
2145	128	852	2	4432	\N	4432	\N	\N	2	1	2	f	\N	8	\N
2146	81	852	2	118	\N	\N	\N	\N	3	1	2	f	118	\N	\N
2147	120	852	2	118	\N	\N	\N	\N	0	1	2	f	118	\N	\N
2148	7	852	2	87	\N	\N	\N	\N	0	1	2	f	87	\N	\N
2149	246	852	2	87	\N	\N	\N	\N	0	1	2	f	87	\N	\N
2150	8	852	1	14990	\N	14990	\N	\N	1	1	2	f	\N	\N	\N
2151	4	853	2	1461783	\N	1461783	\N	\N	1	1	2	f	0	8	\N
2152	187	853	2	29143	\N	29143	\N	\N	2	1	2	f	0	8	\N
2153	174	853	2	9541	\N	9541	\N	\N	3	1	2	f	0	\N	\N
2154	8	853	1	1500441	\N	1500441	\N	\N	1	1	2	f	\N	\N	\N
2155	181	854	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
2156	56	854	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
2157	181	855	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
2158	56	855	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
2159	253	856	2	4857	\N	0	\N	\N	1	1	2	f	4857	\N	\N
2160	205	857	2	775	\N	775	\N	\N	1	1	2	f	0	196	\N
2161	196	857	1	775	\N	775	\N	\N	1	1	2	f	\N	205	\N
2162	81	858	2	15858	\N	15858	\N	\N	1	1	2	f	0	\N	\N
2163	120	858	2	15858	\N	15858	\N	\N	0	1	2	f	0	\N	\N
2164	7	858	2	12202	\N	12202	\N	\N	0	1	2	f	0	\N	\N
2165	246	858	2	12202	\N	12202	\N	\N	0	1	2	f	0	\N	\N
2166	214	859	2	68	\N	0	\N	\N	1	1	2	f	68	\N	\N
2167	10	859	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
2168	15	860	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
2169	215	860	2	216	\N	0	\N	\N	2	1	2	f	216	\N	\N
2170	7	860	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2171	180	862	2	7064	\N	0	\N	\N	1	1	2	f	7064	\N	\N
2172	162	863	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
2173	4	864	2	1474985	\N	0	\N	\N	1	1	2	f	1474985	\N	\N
2174	187	864	2	29143	\N	0	\N	\N	2	1	2	f	29143	\N	\N
2175	235	865	2	36012	\N	0	\N	\N	1	1	2	f	36012	\N	\N
2176	56	865	2	36012	\N	0	\N	\N	0	1	2	f	36012	\N	\N
2177	44	866	2	9814	\N	0	\N	\N	1	1	2	f	9814	\N	\N
2178	56	866	2	9741	\N	0	\N	\N	0	1	2	f	9741	\N	\N
2179	42	867	2	275	\N	0	\N	\N	1	1	2	f	275	\N	\N
2180	56	867	2	275	\N	0	\N	\N	0	1	2	f	275	\N	\N
2181	253	868	2	3327	\N	0	\N	\N	1	1	2	f	3327	\N	\N
2182	128	868	2	928	\N	0	\N	\N	2	1	2	f	928	\N	\N
2183	81	868	2	187	\N	0	\N	\N	3	1	2	f	187	\N	\N
2184	120	868	2	187	\N	0	\N	\N	0	1	2	f	187	\N	\N
2185	7	868	2	161	\N	0	\N	\N	0	1	2	f	161	\N	\N
2186	246	868	2	161	\N	0	\N	\N	0	1	2	f	161	\N	\N
2187	180	869	2	30892	\N	30892	\N	\N	1	1	2	f	0	\N	\N
2188	8	869	1	25221	\N	25221	\N	\N	1	1	2	f	\N	180	\N
2189	169	870	2	402228	\N	0	\N	\N	1	1	2	f	402228	\N	\N
2190	29	872	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
2191	104	873	2	2334482	\N	2334482	\N	\N	1	1	2	f	0	177	\N
2192	177	873	1	2334482	\N	2334482	\N	\N	1	1	2	f	\N	104	\N
2193	16	874	2	270	\N	0	\N	\N	1	1	2	f	270	\N	\N
2194	16	875	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
2195	201	876	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
2196	58	877	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
2197	120	877	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2198	7	877	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2199	246	877	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2200	60	879	2	22037	\N	0	\N	\N	1	1	2	f	22037	\N	\N
2201	56	879	2	22037	\N	0	\N	\N	0	1	2	f	22037	\N	\N
2202	268	881	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
2203	8	882	2	19579	\N	19127	\N	\N	1	1	2	f	452	\N	\N
2204	259	882	2	975	\N	975	\N	\N	2	1	2	f	\N	259	\N
2205	89	882	2	45	\N	45	\N	\N	3	1	2	f	\N	89	\N
2206	99	882	2	2	\N	2	\N	\N	4	1	2	f	\N	99	\N
2207	63	882	2	615	\N	615	\N	\N	0	1	2	f	\N	137	\N
2208	137	882	2	272	\N	272	\N	\N	0	1	2	f	\N	138	\N
2209	138	882	2	88	\N	88	\N	\N	0	1	2	f	\N	161	\N
2210	8	882	1	18834	\N	18834	\N	\N	1	1	2	f	\N	8	\N
2211	259	882	1	975	\N	975	\N	\N	2	1	2	f	\N	259	\N
2212	89	882	1	45	\N	45	\N	\N	3	1	2	f	\N	89	\N
2213	99	882	1	13	\N	13	\N	\N	4	1	2	f	\N	\N	\N
2214	137	882	1	615	\N	615	\N	\N	0	1	2	f	\N	63	\N
2215	138	882	1	272	\N	272	\N	\N	0	1	2	f	\N	137	\N
2216	161	882	1	88	\N	88	\N	\N	0	1	2	f	\N	138	\N
2217	120	885	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
2218	7	885	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2219	246	885	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2220	20	886	2	9351	\N	0	\N	\N	1	1	2	f	9351	\N	\N
2221	261	887	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
2222	15	888	2	114	\N	114	\N	\N	1	1	2	f	0	\N	\N
2223	7	888	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2224	210	889	2	36540	\N	0	\N	\N	1	1	2	f	36540	\N	\N
2225	143	890	2	1870	\N	0	\N	\N	1	1	2	f	1870	\N	\N
2226	92	891	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
2227	253	892	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
2228	128	892	2	4436	\N	0	\N	\N	2	1	2	f	4436	\N	\N
2229	58	893	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
2230	120	893	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2231	7	893	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2232	246	893	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2233	235	894	2	34569	\N	0	\N	\N	1	1	2	f	34569	\N	\N
2234	56	894	2	34569	\N	0	\N	\N	0	1	2	f	34569	\N	\N
2235	215	895	2	154	\N	0	\N	\N	1	1	2	f	154	\N	\N
2236	8	896	1	102	\N	102	\N	\N	1	1	2	f	\N	\N	\N
2237	181	897	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
2238	56	897	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
2239	84	898	2	19660	\N	0	\N	\N	1	1	2	f	19660	\N	\N
2240	56	898	2	19660	\N	0	\N	\N	0	1	2	f	19660	\N	\N
2241	44	899	2	4392	\N	0	\N	\N	1	1	2	f	4392	\N	\N
2242	56	899	2	4388	\N	0	\N	\N	0	1	2	f	4388	\N	\N
2243	101	900	2	37272	\N	0	\N	\N	1	1	2	f	37272	\N	\N
2244	108	901	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
2245	84	902	2	9691	\N	0	\N	\N	1	1	2	f	9691	\N	\N
2246	56	902	2	9691	\N	0	\N	\N	0	1	2	f	9691	\N	\N
2247	42	903	2	16375	\N	0	\N	\N	1	1	2	f	16375	\N	\N
2248	105	903	2	533	\N	0	\N	\N	2	1	2	f	533	\N	\N
2249	56	903	2	16375	\N	0	\N	\N	0	1	2	f	16375	\N	\N
2250	150	903	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2251	8	904	2	162	\N	0	\N	\N	1	1	2	f	162	\N	\N
2252	60	905	2	40827	\N	40827	\N	\N	1	1	2	f	0	\N	\N
2253	246	905	2	606	\N	606	\N	\N	2	1	2	f	0	\N	\N
2254	56	905	2	40827	\N	40827	\N	\N	0	1	2	f	0	\N	\N
2255	7	905	2	606	\N	606	\N	\N	0	1	2	f	0	\N	\N
2256	120	905	2	601	\N	601	\N	\N	0	1	2	f	0	\N	\N
2257	133	905	1	38679	\N	38679	\N	\N	1	1	2	f	\N	\N	\N
2258	258	906	2	253	\N	253	\N	\N	1	1	2	f	0	\N	\N
2259	56	906	2	253	\N	253	\N	\N	0	1	2	f	0	\N	\N
2260	44	907	2	6612	\N	0	\N	\N	1	1	2	f	6612	\N	\N
2261	56	907	2	6570	\N	0	\N	\N	0	1	2	f	6570	\N	\N
2262	209	908	2	1184	\N	0	\N	\N	1	1	2	f	1184	\N	\N
2263	235	909	2	34820	\N	0	\N	\N	1	1	2	f	34820	\N	\N
2264	56	909	2	34820	\N	0	\N	\N	0	1	2	f	34820	\N	\N
2265	128	910	2	63	\N	0	\N	\N	1	1	2	f	63	\N	\N
2266	198	911	2	750	\N	0	\N	\N	1	1	2	f	750	\N	\N
2267	43	912	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
2268	216	912	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2269	247	912	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2270	102	913	2	52	\N	52	\N	\N	1	1	2	f	0	102	\N
2271	7	913	2	52	\N	52	\N	\N	0	1	2	f	0	102	\N
2272	102	913	1	52	\N	52	\N	\N	1	1	2	f	\N	102	\N
2273	7	913	1	52	\N	52	\N	\N	0	1	2	f	\N	102	\N
2274	29	914	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
2275	8	915	2	54198	\N	18930	\N	\N	1	1	2	f	35268	\N	\N
2276	99	915	2	6	\N	6	\N	\N	2	1	2	f	\N	8	\N
2277	8	915	1	937	\N	937	\N	\N	1	1	2	f	\N	\N	\N
2278	154	915	1	67	\N	67	\N	\N	2	1	2	f	\N	8	\N
2279	66	915	1	44	\N	44	\N	\N	3	1	2	f	\N	8	\N
2280	99	915	1	6	\N	6	\N	\N	4	1	2	f	\N	8	\N
2281	38	915	1	73	\N	73	\N	\N	0	1	2	f	\N	8	\N
2282	7	915	1	2	\N	2	\N	\N	0	1	2	f	\N	8	\N
2283	128	916	2	4428	\N	4428	\N	\N	1	1	2	f	0	8	\N
2284	8	916	1	4428	\N	4428	\N	\N	1	1	2	f	\N	128	\N
2285	253	917	2	2433	\N	0	\N	\N	1	1	2	f	2433	\N	\N
2286	29	918	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
2287	220	919	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
2288	120	921	2	182	\N	0	\N	\N	1	1	2	f	182	\N	\N
2289	7	921	2	182	\N	0	\N	\N	0	1	2	f	182	\N	\N
2290	246	921	2	182	\N	0	\N	\N	0	1	2	f	182	\N	\N
2291	8	922	2	370	\N	350	\N	\N	1	1	2	f	20	\N	\N
2292	7	922	2	6	\N	6	\N	\N	0	1	2	f	\N	8	\N
2293	8	922	1	350	\N	350	\N	\N	1	1	2	f	\N	8	\N
2294	107	924	2	3203	\N	0	\N	\N	1	1	2	f	3203	\N	\N
2295	87	924	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2296	7	924	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2297	77	926	2	650	\N	0	\N	\N	1	1	2	f	650	\N	\N
2298	79	927	2	106993	\N	0	\N	\N	1	1	2	f	106993	\N	\N
2299	60	928	2	40827	\N	40827	\N	\N	1	1	2	f	0	120	\N
2300	83	928	2	5455	\N	5455	\N	\N	2	1	2	f	0	120	\N
2301	150	928	2	862	\N	862	\N	\N	3	1	2	f	0	120	\N
2302	56	928	2	40827	\N	40827	\N	\N	0	1	2	f	0	120	\N
2303	105	928	2	550	\N	550	\N	\N	0	1	2	f	0	120	\N
2304	120	928	1	60498	\N	60498	\N	\N	1	1	2	f	\N	\N	\N
2305	7	928	1	60498	\N	60498	\N	\N	0	1	2	f	\N	\N	\N
2306	246	928	1	60498	\N	60498	\N	\N	0	1	2	f	\N	\N	\N
2307	16	929	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
2308	272	930	2	4262	\N	0	\N	\N	1	1	2	f	4262	\N	\N
2309	154	931	2	17482	\N	17482	\N	\N	1	1	2	f	0	\N	\N
2310	15	931	1	17456	\N	17456	\N	\N	1	1	2	f	\N	\N	\N
2311	7	931	1	78	\N	78	\N	\N	0	1	2	f	\N	154	\N
2312	225	932	2	557472	\N	0	\N	\N	1	1	2	f	557472	\N	\N
2313	97	933	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2314	205	934	2	716	\N	716	\N	\N	1	1	2	f	0	196	\N
2315	196	934	1	716	\N	716	\N	\N	1	1	2	f	\N	205	\N
2316	20	935	2	9351	\N	0	\N	\N	1	1	2	f	9351	\N	\N
2317	179	936	2	719328	\N	719328	\N	\N	1	1	2	f	0	3	\N
2318	3	936	2	713169	\N	713169	\N	\N	0	1	2	f	0	8	\N
2319	3	936	1	719328	\N	719328	\N	\N	1	1	2	f	\N	179	\N
2320	8	936	1	712415	\N	712415	\N	\N	0	1	2	f	\N	3	\N
2321	33	936	1	61	\N	61	\N	\N	0	1	2	f	\N	3	\N
2322	7	937	2	2854237	\N	2854237	\N	\N	1	1	2	f	\N	7	\N
2323	91	937	2	16	\N	16	\N	\N	2	1	2	f	\N	91	\N
2324	246	937	2	2853933	\N	2853933	\N	\N	0	1	2	f	\N	7	\N
2325	120	937	2	2853915	\N	2853915	\N	\N	0	1	2	f	\N	7	\N
2326	8	937	2	9328	\N	525	\N	\N	0	1	2	f	8803	\N	\N
2327	129	937	2	1060	\N	1060	\N	\N	0	1	2	f	\N	7	\N
2328	247	937	2	6	\N	6	\N	\N	0	1	2	f	\N	120	\N
2329	7	937	1	2856113	\N	2856113	\N	\N	1	1	2	f	\N	7	\N
2330	91	937	1	16	\N	16	\N	\N	2	1	2	f	\N	91	\N
2331	246	937	1	2853924	\N	2853924	\N	\N	0	1	2	f	\N	7	\N
2332	120	937	1	2853921	\N	2853921	\N	\N	0	1	2	f	\N	7	\N
2333	129	937	1	1688	\N	1688	\N	\N	0	1	2	f	\N	120	\N
2334	8	937	1	525	\N	525	\N	\N	0	1	2	f	\N	8	\N
2335	133	938	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
2336	8	939	2	1266	\N	0	\N	\N	1	1	2	f	1266	\N	\N
2337	99	939	2	37	\N	0	\N	\N	2	1	2	f	37	\N	\N
2338	58	940	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
2339	120	940	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2340	7	940	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2341	246	940	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2342	246	941	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
2343	7	941	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
2344	120	941	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
2345	33	942	2	214	\N	0	\N	\N	1	1	2	f	214	\N	\N
2346	244	943	2	713766	\N	713766	\N	\N	1	1	2	f	0	\N	\N
2347	77	943	2	208103	\N	208103	\N	\N	2	1	2	f	0	\N	\N
2348	8	943	1	910107	\N	910107	\N	\N	1	1	2	f	\N	\N	\N
2349	33	943	1	911	\N	911	\N	\N	2	1	2	f	\N	244	\N
2350	101	944	2	31976	\N	0	\N	\N	1	1	2	f	31976	\N	\N
2351	48	945	2	430	\N	0	\N	\N	1	1	2	f	430	\N	\N
2352	58	946	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
2353	120	946	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2354	7	946	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2355	246	946	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2356	220	947	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
2357	208	948	2	1534	\N	1534	\N	\N	1	1	2	f	0	59	\N
2358	59	948	1	1534	\N	1534	\N	\N	1	1	2	f	\N	208	\N
2359	76	949	2	122	\N	0	\N	\N	1	1	2	f	122	\N	\N
2360	258	950	2	265	\N	265	\N	\N	1	1	2	f	\N	\N	\N
2361	155	950	2	52	\N	52	\N	\N	2	1	2	f	\N	\N	\N
2362	110	950	2	34	\N	34	\N	\N	3	1	2	f	\N	\N	\N
2363	212	950	2	26	\N	26	\N	\N	4	1	2	f	\N	212	\N
2364	201	950	2	7	\N	7	\N	\N	5	1	2	f	\N	\N	\N
2365	134	950	2	6	\N	6	\N	\N	6	1	2	f	\N	\N	\N
2366	98	950	2	4	\N	4	\N	\N	7	1	2	f	\N	\N	\N
2367	172	950	2	3	\N	3	\N	\N	8	1	2	f	\N	\N	\N
2368	97	950	2	3	\N	3	\N	\N	9	1	2	f	\N	\N	\N
2369	8	950	2	3	\N	1	\N	\N	10	1	2	f	2	\N	\N
2370	39	950	2	2	\N	2	\N	\N	11	1	2	f	\N	\N	\N
2371	56	950	2	265	\N	265	\N	\N	0	1	2	f	\N	\N	\N
2372	99	950	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2373	118	950	2	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2374	212	950	1	26	\N	26	\N	\N	1	1	2	f	\N	212	\N
2375	179	951	2	803170	\N	803170	\N	\N	1	1	2	f	0	170	\N
2376	257	951	2	99962	\N	99962	\N	\N	2	1	2	f	0	170	\N
2377	170	951	1	903132	\N	903132	\N	\N	1	1	2	f	\N	\N	\N
2378	145	952	2	1911027	\N	0	\N	\N	1	1	2	f	1911027	\N	\N
2379	99	954	2	941	\N	941	\N	\N	1	1	2	f	0	99	\N
2380	118	954	2	443	\N	443	\N	\N	0	1	2	f	0	\N	\N
2381	99	954	1	941	\N	941	\N	\N	1	1	2	f	\N	99	\N
2382	254	955	2	479066	\N	479066	\N	\N	1	1	2	f	0	113	\N
2383	113	955	1	479066	\N	479066	\N	\N	1	1	2	f	\N	254	\N
2384	112	955	1	411336	\N	411336	\N	\N	0	1	2	f	\N	254	\N
2385	88	956	2	935591	\N	0	\N	\N	1	1	2	f	935591	\N	\N
2386	91	957	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
2387	27	958	2	25859	\N	0	\N	\N	1	1	2	f	25859	\N	\N
2388	235	959	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
2389	56	959	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
2390	47	960	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2391	163	960	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2392	84	961	2	30328	\N	30328	\N	\N	1	1	2	f	0	209	\N
2393	56	961	2	30328	\N	30328	\N	\N	0	1	2	f	0	209	\N
2394	209	961	1	30328	\N	30328	\N	\N	1	1	2	f	\N	84	\N
2395	165	962	2	91	\N	0	\N	\N	1	1	2	f	91	\N	\N
2396	144	963	2	142530	\N	142530	\N	\N	1	1	2	f	0	37	\N
2397	105	963	2	1721	\N	1721	\N	\N	2	1	2	f	0	37	\N
2398	150	963	2	20	\N	20	\N	\N	0	1	2	f	0	37	\N
2399	37	963	1	144251	\N	144251	\N	\N	1	1	2	f	\N	\N	\N
2400	79	964	2	105038	\N	0	\N	\N	1	1	2	f	105038	\N	\N
2401	101	965	2	50823	\N	\N	\N	\N	1	1	2	f	50823	\N	\N
2402	13	965	2	1285	\N	1285	\N	\N	2	1	2	f	\N	\N	\N
2403	14	965	2	1	\N	\N	\N	\N	0	1	2	f	1	\N	\N
2404	8	965	1	1152	\N	1152	\N	\N	1	1	2	f	\N	13	\N
2405	8	966	2	221714	\N	0	\N	\N	1	1	2	f	221714	\N	\N
2406	7	966	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2407	237	967	2	1656	\N	1656	\N	\N	1	1	2	f	0	\N	\N
2408	15	968	2	171	\N	0	\N	\N	1	1	2	f	171	\N	\N
2409	81	969	2	1461	\N	0	\N	\N	1	1	2	f	1461	\N	\N
2410	120	969	2	1461	\N	0	\N	\N	0	1	2	f	1461	\N	\N
2411	7	969	2	1038	\N	0	\N	\N	0	1	2	f	1038	\N	\N
2412	246	969	2	1038	\N	0	\N	\N	0	1	2	f	1038	\N	\N
2413	209	970	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
2414	212	971	2	7686	\N	7686	\N	\N	1	1	2	f	0	\N	\N
2415	212	971	1	7479	\N	7479	\N	\N	1	1	2	f	\N	212	\N
2416	15	972	2	553	\N	0	\N	\N	1	1	2	f	553	\N	\N
2417	215	972	2	134	\N	0	\N	\N	2	1	2	f	134	\N	\N
2418	7	972	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2419	107	973	2	1466	\N	0	\N	\N	1	1	2	f	1466	\N	\N
2420	87	973	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2421	7	973	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2422	49	974	2	472	\N	0	\N	\N	1	1	2	f	472	\N	\N
2423	250	975	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
2424	265	975	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
2425	70	976	2	37	\N	0	\N	\N	1	1	2	f	37	\N	\N
2426	258	977	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
2427	56	977	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
2428	258	977	1	8	\N	8	\N	\N	1	1	2	f	\N	258	\N
2429	56	977	1	8	\N	8	\N	\N	0	1	2	f	\N	258	\N
2430	58	978	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
2431	120	978	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2432	7	978	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2433	246	978	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2434	7	979	2	1460808	\N	0	\N	\N	1	1	2	f	1460808	\N	\N
2435	98	979	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
2436	47	979	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
2437	251	979	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
2438	246	979	2	981364	\N	0	\N	\N	0	1	2	f	981364	\N	\N
2439	247	979	2	740796	\N	0	\N	\N	0	1	2	f	740796	\N	\N
2440	248	979	2	413639	\N	0	\N	\N	0	1	2	f	413639	\N	\N
2441	120	979	2	318148	\N	0	\N	\N	0	1	2	f	318148	\N	\N
2442	252	979	2	65915	\N	0	\N	\N	0	1	2	f	65915	\N	\N
2443	231	979	2	8076	\N	0	\N	\N	0	1	2	f	8076	\N	\N
2444	57	979	2	7276	\N	0	\N	\N	0	1	2	f	7276	\N	\N
2445	123	979	2	5723	\N	0	\N	\N	0	1	2	f	5723	\N	\N
2446	11	979	2	3449	\N	0	\N	\N	0	1	2	f	3449	\N	\N
2447	232	979	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
2448	102	979	2	230	\N	0	\N	\N	0	1	2	f	230	\N	\N
2449	34	979	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
2450	58	979	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
2451	81	979	2	72	\N	0	\N	\N	0	1	2	f	72	\N	\N
2452	211	979	2	51	\N	0	\N	\N	0	1	2	f	51	\N	\N
2453	129	979	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
2454	204	979	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
2455	14	979	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2456	87	979	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2457	172	979	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2458	103	979	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2459	163	979	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2460	253	980	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
2461	128	980	2	4436	\N	0	\N	\N	2	1	2	f	4436	\N	\N
2462	253	981	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
2463	128	981	2	4436	\N	0	\N	\N	2	1	2	f	4436	\N	\N
2464	84	982	2	36450	\N	0	\N	\N	1	1	2	f	36450	\N	\N
2465	56	982	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
2466	204	983	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
2467	120	983	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
2468	7	983	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
2469	246	983	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
2470	126	984	2	935	\N	935	\N	\N	1	1	2	f	0	59	\N
2471	59	984	1	935	\N	935	\N	\N	1	1	2	f	\N	126	\N
2472	81	985	2	1408	\N	0	\N	\N	1	1	2	f	1408	\N	\N
2473	253	985	2	163	\N	0	\N	\N	2	1	2	f	163	\N	\N
2474	128	985	2	33	\N	0	\N	\N	3	1	2	f	33	\N	\N
2475	120	985	2	1408	\N	0	\N	\N	0	1	2	f	1408	\N	\N
2476	7	985	2	1098	\N	0	\N	\N	0	1	2	f	1098	\N	\N
2477	246	985	2	1098	\N	0	\N	\N	0	1	2	f	1098	\N	\N
2478	128	986	2	7187	\N	4433	\N	\N	1	1	2	f	2754	\N	\N
2479	8	986	1	4433	\N	4433	\N	\N	1	1	2	f	\N	128	\N
2480	133	987	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
2481	29	988	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
2482	253	989	2	3479	\N	3479	\N	\N	1	1	2	f	0	8	\N
2483	8	989	1	3479	\N	3479	\N	\N	1	1	2	f	\N	253	\N
2484	258	990	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2485	56	990	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2486	253	991	2	2923	\N	0	\N	\N	1	1	2	f	2923	\N	\N
2487	181	992	2	1086	\N	0	\N	\N	1	1	2	f	1086	\N	\N
2488	56	992	2	1086	\N	0	\N	\N	0	1	2	f	1086	\N	\N
2489	60	993	2	40830	\N	0	\N	\N	1	1	2	f	40830	\N	\N
2490	56	993	2	40830	\N	0	\N	\N	0	1	2	f	40830	\N	\N
2491	15	994	2	586	\N	0	\N	\N	1	1	2	f	586	\N	\N
2492	7	994	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2493	261	995	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
2494	7	996	2	832541	\N	0	\N	\N	1	1	2	f	832541	\N	\N
2495	85	996	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
2496	98	996	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
2497	121	996	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
2498	47	996	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
2499	251	996	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
2500	153	996	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
2501	246	996	2	522841	\N	0	\N	\N	0	1	2	f	522841	\N	\N
2502	247	996	2	386152	\N	0	\N	\N	0	1	2	f	386152	\N	\N
2503	248	996	2	228209	\N	0	\N	\N	0	1	2	f	228209	\N	\N
2504	120	996	2	161880	\N	0	\N	\N	0	1	2	f	161880	\N	\N
2505	102	996	2	44798	\N	0	\N	\N	0	1	2	f	44798	\N	\N
2506	252	996	2	36753	\N	0	\N	\N	0	1	2	f	36753	\N	\N
2507	231	996	2	4211	\N	0	\N	\N	0	1	2	f	4211	\N	\N
2508	57	996	2	3821	\N	0	\N	\N	0	1	2	f	3821	\N	\N
2509	123	996	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
2510	11	996	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
2511	107	996	2	633	\N	0	\N	\N	0	1	2	f	633	\N	\N
2512	232	996	2	134	\N	0	\N	\N	0	1	2	f	134	\N	\N
2513	34	996	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
2514	58	996	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2515	81	996	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
2516	129	996	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
2517	211	996	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
2518	204	996	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
2519	87	996	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
2520	172	996	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2521	14	996	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2522	8	996	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2523	103	996	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2524	163	996	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2525	48	997	2	1004	\N	0	\N	\N	1	1	2	f	1004	\N	\N
2526	29	998	2	47	\N	0	\N	\N	1	1	2	f	47	\N	\N
2527	58	999	2	15	\N	10	\N	\N	1	1	2	f	5	\N	\N
2528	120	999	2	15	\N	10	\N	\N	0	1	2	f	5	\N	\N
2529	7	999	2	9	\N	6	\N	\N	0	1	2	f	3	\N	\N
2530	246	999	2	9	\N	6	\N	\N	0	1	2	f	3	\N	\N
2531	242	999	1	10	\N	10	\N	\N	1	1	2	f	\N	58	\N
2532	2	1000	2	3878892	\N	3878892	\N	\N	1	1	2	f	0	8	\N
2533	8	1000	1	3650368	\N	3650368	\N	\N	1	1	2	f	\N	2	\N
2534	33	1000	1	104	\N	104	\N	\N	0	1	2	f	\N	2	\N
2535	48	1001	2	359	\N	0	\N	\N	1	1	2	f	359	\N	\N
2536	102	1002	2	523823	\N	523823	\N	\N	1	1	2	f	0	\N	\N
2537	7	1002	2	523650	\N	523650	\N	\N	0	1	2	f	0	\N	\N
2538	247	1002	2	270	\N	270	\N	\N	0	1	2	f	0	\N	\N
2539	246	1002	1	523576	\N	523576	\N	\N	1	1	2	f	\N	102	\N
2540	102	1002	1	42	\N	42	\N	\N	2	1	2	f	\N	102	\N
2541	7	1002	1	523519	\N	523519	\N	\N	0	1	2	f	\N	102	\N
2542	120	1002	1	156247	\N	156247	\N	\N	0	1	2	f	\N	102	\N
2543	247	1002	1	147972	\N	147972	\N	\N	0	1	2	f	\N	102	\N
2544	231	1002	1	3865	\N	3865	\N	\N	0	1	2	f	\N	102	\N
2545	57	1002	1	3454	\N	3454	\N	\N	0	1	2	f	\N	102	\N
2546	123	1002	1	2850	\N	2850	\N	\N	0	1	2	f	\N	7	\N
2547	11	1002	1	1675	\N	1675	\N	\N	0	1	2	f	\N	102	\N
2548	232	1002	1	113	\N	113	\N	\N	0	1	2	f	\N	102	\N
2549	34	1002	1	50	\N	50	\N	\N	0	1	2	f	\N	102	\N
2550	58	1002	1	48	\N	48	\N	\N	0	1	2	f	\N	102	\N
2551	81	1002	1	31	\N	31	\N	\N	0	1	2	f	\N	102	\N
2552	204	1002	1	24	\N	24	\N	\N	0	1	2	f	\N	102	\N
2553	211	1002	1	23	\N	23	\N	\N	0	1	2	f	\N	102	\N
2554	129	1002	1	11	\N	11	\N	\N	0	1	2	f	\N	102	\N
2555	248	1002	1	1	\N	1	\N	\N	0	1	2	f	\N	102	\N
2556	134	1003	2	6	\N	6	\N	\N	1	1	2	f	0	216	\N
2557	216	1003	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
2558	174	1004	2	1886	\N	0	\N	\N	1	1	2	f	1886	\N	\N
2559	48	1005	2	589	\N	0	\N	\N	1	1	2	f	589	\N	\N
2560	181	1006	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
2561	56	1006	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
2562	8	1007	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2563	7	1007	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2564	8	1008	1	220003	\N	220003	\N	\N	1	1	2	f	\N	\N	\N
2565	128	1009	2	1585	\N	1585	\N	\N	1	1	2	f	0	8	\N
2566	8	1009	1	1585	\N	1585	\N	\N	1	1	2	f	\N	128	\N
2567	107	1010	2	4134	\N	4134	\N	\N	1	1	2	f	0	59	\N
2568	87	1010	2	6	\N	6	\N	\N	0	1	2	f	0	59	\N
2569	7	1010	2	2	\N	2	\N	\N	0	1	2	f	0	59	\N
2570	59	1010	1	4116	\N	4116	\N	\N	1	1	2	f	\N	107	\N
2571	235	1011	2	19043	\N	0	\N	\N	1	1	2	f	19043	\N	\N
2572	56	1011	2	19043	\N	0	\N	\N	0	1	2	f	19043	\N	\N
2573	128	1012	2	55	\N	0	\N	\N	1	1	2	f	55	\N	\N
2574	88	1013	2	935516	\N	935516	\N	\N	1	1	2	f	0	\N	\N
2575	8	1013	1	924630	\N	924630	\N	\N	1	1	2	f	\N	88	\N
2576	58	1014	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
2577	120	1014	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
2578	7	1014	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2579	246	1014	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2580	82	1015	2	13593	\N	13593	\N	\N	1	1	2	f	0	177	\N
2581	177	1015	1	13593	\N	13593	\N	\N	1	1	2	f	\N	82	\N
2582	193	1016	2	1385855	\N	\N	\N	\N	1	1	2	f	1385855	\N	\N
2583	257	1016	2	25152	\N	25152	\N	\N	2	1	2	f	\N	86	\N
2584	86	1016	1	25152	\N	25152	\N	\N	1	1	2	f	\N	257	\N
2585	127	1017	2	28135	\N	28135	\N	\N	1	1	2	f	0	8	\N
2586	129	1017	2	13	\N	13	\N	\N	0	1	2	f	0	8	\N
2587	8	1017	1	28135	\N	28135	\N	\N	1	1	2	f	\N	127	\N
2588	91	1018	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
2589	15	1019	2	647	\N	647	\N	\N	1	1	2	f	0	\N	\N
2590	215	1019	2	188	\N	188	\N	\N	2	1	2	f	0	\N	\N
2591	7	1019	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2592	15	1020	2	144	\N	0	\N	\N	1	1	2	f	144	\N	\N
2593	7	1020	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2594	151	1021	2	19518	\N	0	\N	\N	1	1	2	f	19518	\N	\N
2595	146	1022	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
2596	120	1023	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
2597	7	1023	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
2598	246	1023	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
2599	253	1024	2	16648	\N	0	\N	\N	1	1	2	f	16648	\N	\N
2600	81	1024	2	409	\N	0	\N	\N	2	1	2	f	409	\N	\N
2601	120	1024	2	409	\N	0	\N	\N	0	1	2	f	409	\N	\N
2602	7	1024	2	313	\N	0	\N	\N	0	1	2	f	313	\N	\N
2603	246	1024	2	313	\N	0	\N	\N	0	1	2	f	313	\N	\N
2604	12	1025	2	18216	\N	18216	\N	\N	1	1	2	f	0	78	\N
2605	238	1025	2	2	\N	2	\N	\N	2	1	2	f	0	78	\N
2606	129	1025	2	11	\N	11	\N	\N	0	1	2	f	0	78	\N
2607	78	1025	1	18214	\N	18214	\N	\N	1	1	2	f	\N	\N	\N
2608	179	1026	2	1925993	\N	1925993	\N	\N	1	1	2	f	0	2	\N
2609	2	1026	1	1925993	\N	1925993	\N	\N	1	1	2	f	\N	179	\N
2610	8	1028	2	659	\N	0	\N	\N	1	1	2	f	659	\N	\N
2611	201	1029	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
2612	122	1029	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2613	172	1029	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
2614	155	1029	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
2615	97	1029	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2616	246	1030	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
2617	7	1030	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
2618	120	1030	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
2619	116	1031	2	1054932	\N	1054932	\N	\N	1	1	2	f	0	8	\N
2620	13	1031	2	1289	\N	1289	\N	\N	2	1	2	f	0	8	\N
2621	8	1031	1	1056212	\N	1056212	\N	\N	1	1	2	f	\N	\N	\N
2622	58	1032	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
2623	120	1032	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
2624	7	1032	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2625	246	1032	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2626	79	1033	2	69943	\N	69943	\N	\N	1	1	2	f	0	\N	\N
2627	8	1033	1	68440	\N	68440	\N	\N	1	1	2	f	\N	79	\N
2628	214	1034	2	41	\N	0	\N	\N	1	1	2	f	41	\N	\N
2629	10	1034	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
2630	216	1035	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
2631	94	1035	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
2632	235	1036	2	33429	\N	0	\N	\N	1	1	2	f	33429	\N	\N
2633	56	1036	2	33429	\N	0	\N	\N	0	1	2	f	33429	\N	\N
2634	74	1037	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
2635	190	1037	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
2636	221	1037	2	1512	\N	1512	\N	\N	3	1	2	f	0	52	\N
2637	52	1037	1	4536	\N	4536	\N	\N	1	1	2	f	\N	\N	\N
2638	35	1038	2	815747	\N	0	\N	\N	1	1	2	f	815747	\N	\N
2639	15	1039	2	259	\N	0	\N	\N	1	1	2	f	259	\N	\N
2640	209	1040	2	5438	\N	0	\N	\N	1	1	2	f	5438	\N	\N
2641	186	1041	2	15117462	\N	15117462	\N	\N	1	1	2	f	0	8	\N
2642	249	1041	2	73960	\N	73960	\N	\N	2	1	2	f	0	\N	\N
2643	13	1041	2	1285	\N	1285	\N	\N	3	1	2	f	0	8	\N
2644	129	1041	2	330	\N	330	\N	\N	4	1	2	f	0	8	\N
2645	56	1041	2	73960	\N	73960	\N	\N	0	1	2	f	0	\N	\N
2646	100	1041	2	73960	\N	73960	\N	\N	0	1	2	f	0	\N	\N
2647	8	1041	1	15192970	\N	15192970	\N	\N	1	1	2	f	\N	\N	\N
2648	178	1042	2	2068262	\N	2068262	\N	\N	1	1	2	f	0	104	\N
2649	125	1042	2	266220	\N	266220	\N	\N	2	1	2	f	0	104	\N
2650	82	1042	2	2	\N	2	\N	\N	3	1	2	f	0	177	\N
2651	56	1042	2	1893288	\N	1893288	\N	\N	0	1	2	f	0	104	\N
2652	100	1042	2	1893288	\N	1893288	\N	\N	0	1	2	f	0	104	\N
2653	104	1042	1	2334482	\N	2334482	\N	\N	1	1	2	f	\N	\N	\N
2654	177	1042	1	2	\N	2	\N	\N	0	1	2	f	\N	82	\N
2655	58	1044	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
2656	120	1044	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2657	7	1044	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2658	246	1044	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
2659	41	1045	2	182542	\N	0	\N	\N	1	1	2	f	182542	\N	\N
2660	162	1046	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
2661	30	1047	2	2	\N	2	\N	\N	1	1	2	f	0	228	\N
2662	228	1047	1	2	\N	2	\N	\N	1	1	2	f	\N	30	\N
2663	16	1048	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
2664	183	1049	2	196	\N	0	\N	\N	1	1	2	f	196	\N	\N
2665	58	1050	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
2666	120	1050	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2667	7	1050	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2668	246	1050	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2669	178	1051	2	1342	\N	0	\N	\N	1	1	2	f	1342	\N	\N
2670	56	1051	2	1236	\N	0	\N	\N	0	1	2	f	1236	\N	\N
2671	100	1051	2	1236	\N	0	\N	\N	0	1	2	f	1236	\N	\N
2672	48	1052	2	579	\N	0	\N	\N	1	1	2	f	579	\N	\N
2673	248	1053	2	230240	\N	0	\N	\N	1	1	2	f	230240	\N	\N
2674	7	1053	2	230059	\N	0	\N	\N	0	1	2	f	230059	\N	\N
2675	247	1053	2	183394	\N	0	\N	\N	0	1	2	f	183394	\N	\N
2676	129	1053	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
2677	87	1053	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2678	14	1053	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2679	120	1053	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2680	103	1053	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2681	246	1053	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2682	29	1054	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2683	15	1055	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
2684	79	1056	2	104138	\N	104138	\N	\N	1	1	2	f	0	\N	\N
2685	8	1056	1	100790	\N	100790	\N	\N	1	1	2	f	\N	79	\N
2686	225	1057	2	508444	\N	0	\N	\N	1	1	2	f	508444	\N	\N
2687	48	1058	2	2144	\N	0	\N	\N	1	1	2	f	2144	\N	\N
2688	101	1059	2	35856	\N	35856	\N	\N	1	1	2	f	0	\N	\N
2689	8	1059	1	35411	\N	35411	\N	\N	1	1	2	f	\N	101	\N
2690	15	1060	2	441	\N	0	\N	\N	1	1	2	f	441	\N	\N
2691	7	1060	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2692	81	1062	2	1068	\N	0	\N	\N	1	1	2	f	1068	\N	\N
2693	253	1062	2	206	\N	0	\N	\N	2	1	2	f	206	\N	\N
2694	128	1062	2	30	\N	0	\N	\N	3	1	2	f	30	\N	\N
2695	120	1062	2	1068	\N	0	\N	\N	0	1	2	f	1068	\N	\N
2696	7	1062	2	781	\N	0	\N	\N	0	1	2	f	781	\N	\N
2697	246	1062	2	781	\N	0	\N	\N	0	1	2	f	781	\N	\N
2698	29	1063	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
2699	81	1064	2	115	\N	0	\N	\N	1	1	2	f	115	\N	\N
2700	120	1064	2	115	\N	0	\N	\N	0	1	2	f	115	\N	\N
2701	7	1064	2	85	\N	0	\N	\N	0	1	2	f	85	\N	\N
2702	246	1064	2	85	\N	0	\N	\N	0	1	2	f	85	\N	\N
2703	249	1065	2	70483	\N	70483	\N	\N	1	1	2	f	0	\N	\N
2704	56	1065	2	70483	\N	70483	\N	\N	0	1	2	f	0	\N	\N
2705	100	1065	2	70483	\N	70483	\N	\N	0	1	2	f	0	\N	\N
2706	174	1065	1	68468	\N	68468	\N	\N	1	1	2	f	\N	249	\N
2707	235	1067	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
2708	56	1067	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
2709	48	1068	2	326	\N	0	\N	\N	1	1	2	f	326	\N	\N
2710	235	1069	2	8055	\N	0	\N	\N	1	1	2	f	8055	\N	\N
2711	56	1069	2	8055	\N	0	\N	\N	0	1	2	f	8055	\N	\N
2712	7	1071	2	787973	\N	0	\N	\N	1	1	2	f	787973	\N	\N
2713	85	1071	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
2714	98	1071	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
2715	121	1071	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
2716	47	1071	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
2717	251	1071	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
2718	153	1071	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
2719	246	1071	2	522827	\N	0	\N	\N	0	1	2	f	522827	\N	\N
2720	247	1071	2	386152	\N	0	\N	\N	0	1	2	f	386152	\N	\N
2721	248	1071	2	228209	\N	0	\N	\N	0	1	2	f	228209	\N	\N
2722	120	1071	2	161880	\N	0	\N	\N	0	1	2	f	161880	\N	\N
2723	252	1071	2	36753	\N	0	\N	\N	0	1	2	f	36753	\N	\N
2724	231	1071	2	4211	\N	0	\N	\N	0	1	2	f	4211	\N	\N
2725	57	1071	2	3821	\N	0	\N	\N	0	1	2	f	3821	\N	\N
2726	123	1071	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
2727	11	1071	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
2728	102	1071	2	231	\N	0	\N	\N	0	1	2	f	231	\N	\N
2729	232	1071	2	134	\N	0	\N	\N	0	1	2	f	134	\N	\N
2730	34	1071	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
2731	58	1071	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
2732	81	1071	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
2733	129	1071	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
2734	211	1071	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
2735	204	1071	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
2736	107	1071	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2737	87	1071	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2738	172	1071	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2739	14	1071	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2740	103	1071	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2741	163	1071	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2742	235	1072	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
2743	56	1072	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
2744	37	1073	2	35683	\N	0	\N	\N	1	1	2	f	35683	\N	\N
2745	8	1074	2	815	\N	178	\N	\N	1	1	2	f	637	\N	\N
2746	7	1074	2	2	\N	2	\N	\N	0	1	2	f	\N	8	\N
2747	8	1074	1	178	\N	178	\N	\N	1	1	2	f	\N	8	\N
2748	209	1076	2	3082	\N	0	\N	\N	1	1	2	f	3082	\N	\N
2749	215	1077	2	670	\N	670	\N	\N	1	1	2	f	0	15	\N
2750	15	1077	1	670	\N	670	\N	\N	1	1	2	f	\N	215	\N
2751	7	1077	1	2	\N	2	\N	\N	0	1	2	f	\N	215	\N
2752	21	1078	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
2753	128	1079	2	3021	\N	3021	\N	\N	1	1	2	f	0	\N	\N
2754	178	1080	2	1855568	\N	1855568	\N	\N	1	1	2	f	0	\N	\N
2755	125	1080	2	266199	\N	266199	\N	\N	2	1	2	f	0	\N	\N
2756	56	1080	2	1809304	\N	1809304	\N	\N	0	1	2	f	0	\N	\N
2757	100	1080	2	1809304	\N	1809304	\N	\N	0	1	2	f	0	\N	\N
2758	8	1080	1	1856139	\N	1856139	\N	\N	1	1	2	f	\N	\N	\N
2759	169	1082	2	598800	\N	598800	\N	\N	1	1	2	f	0	8	\N
2760	8	1082	1	598800	\N	598800	\N	\N	1	1	2	f	\N	169	\N
2761	254	1083	2	559566	\N	559566	\N	\N	1	1	2	f	0	73	\N
2762	73	1083	1	559566	\N	559566	\N	\N	1	1	2	f	\N	254	\N
2763	112	1084	2	6719312	\N	6719312	\N	\N	1	1	2	f	0	8	\N
2764	28	1084	2	630215	\N	630215	\N	\N	2	1	2	f	0	8	\N
2765	13	1084	2	1303	\N	1303	\N	\N	3	1	2	f	0	\N	\N
2766	113	1084	2	411336	\N	411336	\N	\N	0	1	2	f	0	8	\N
2767	8	1084	1	10365670	\N	10365670	\N	\N	1	1	2	f	\N	\N	\N
2768	107	1085	2	81	\N	0	\N	\N	1	1	2	f	81	\N	\N
2769	219	1087	2	150682	\N	0	\N	\N	1	1	2	f	150682	\N	\N
2770	102	1088	2	46146	\N	0	\N	\N	1	1	2	f	46146	\N	\N
2771	7	1088	2	46090	\N	0	\N	\N	0	1	2	f	46090	\N	\N
2772	247	1088	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2773	58	1089	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
2774	120	1089	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
2775	7	1089	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2776	246	1089	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
2777	74	1090	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
2778	190	1090	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
2779	52	1090	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
2780	253	1091	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
2781	128	1091	2	4436	\N	0	\N	\N	2	1	2	f	4436	\N	\N
2782	15	1092	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
2783	234	1093	2	33948	\N	0	\N	\N	1	1	2	f	33948	\N	\N
2784	56	1093	2	33948	\N	0	\N	\N	0	1	2	f	33948	\N	\N
2785	88	1094	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
2786	16	1095	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
2787	250	1096	2	55	\N	55	\N	\N	1	1	2	f	0	\N	\N
2788	172	1096	1	8	\N	8	\N	\N	1	1	2	f	\N	250	\N
2789	7	1096	1	5	\N	5	\N	\N	0	1	2	f	\N	250	\N
2790	41	1097	2	182542	\N	0	\N	\N	1	1	2	f	182542	\N	\N
2791	44	1098	2	10358	\N	0	\N	\N	1	1	2	f	10358	\N	\N
2792	56	1098	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
2793	58	1099	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
2794	120	1099	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
2795	7	1099	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2796	246	1099	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
2797	127	1100	2	25688	\N	25688	\N	\N	1	1	2	f	0	8	\N
2798	129	1100	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
2799	8	1100	1	25688	\N	25688	\N	\N	1	1	2	f	\N	127	\N
2800	111	1102	2	531	\N	0	\N	\N	1	1	2	f	531	\N	\N
2801	126	1103	2	935	\N	935	\N	\N	1	1	2	f	0	59	\N
2802	59	1103	1	935	\N	935	\N	\N	1	1	2	f	\N	126	\N
2803	7	1104	2	753536	\N	753536	\N	\N	1	1	2	f	0	102	\N
2804	33	1104	2	213	\N	213	\N	\N	2	1	2	f	0	\N	\N
2805	47	1104	2	1	\N	1	\N	\N	3	1	2	f	0	47	\N
2806	246	1104	2	523577	\N	523577	\N	\N	0	1	2	f	0	102	\N
2807	247	1104	2	331366	\N	331366	\N	\N	0	1	2	f	0	102	\N
2808	248	1104	2	230241	\N	230241	\N	\N	0	1	2	f	0	102	\N
2809	120	1104	2	156250	\N	156250	\N	\N	0	1	2	f	0	102	\N
2810	231	1104	2	3865	\N	3865	\N	\N	0	1	2	f	0	102	\N
2811	57	1104	2	3454	\N	3454	\N	\N	0	1	2	f	0	102	\N
2812	123	1104	2	2850	\N	2850	\N	\N	0	1	2	f	0	7	\N
2813	11	1104	2	1675	\N	1675	\N	\N	0	1	2	f	0	102	\N
2814	232	1104	2	113	\N	113	\N	\N	0	1	2	f	0	102	\N
2815	34	1104	2	50	\N	50	\N	\N	0	1	2	f	0	102	\N
2816	58	1104	2	48	\N	48	\N	\N	0	1	2	f	0	102	\N
2817	129	1104	2	36	\N	36	\N	\N	0	1	2	f	0	102	\N
2818	81	1104	2	31	\N	31	\N	\N	0	1	2	f	0	102	\N
2819	204	1104	2	24	\N	24	\N	\N	0	1	2	f	0	102	\N
2820	211	1104	2	23	\N	23	\N	\N	0	1	2	f	0	102	\N
2821	87	1104	2	7	\N	7	\N	\N	0	1	2	f	0	102	\N
2822	14	1104	2	6	\N	6	\N	\N	0	1	2	f	0	102	\N
2823	103	1104	2	2	\N	2	\N	\N	0	1	2	f	0	102	\N
2824	163	1104	2	1	\N	1	\N	\N	0	1	2	f	0	47	\N
2825	102	1104	1	753966	\N	753966	\N	\N	1	1	2	f	\N	\N	\N
2826	123	1104	1	208	\N	208	\N	\N	2	1	2	f	\N	33	\N
2827	47	1104	1	1	\N	1	\N	\N	3	1	2	f	\N	47	\N
2828	7	1104	1	753654	\N	753654	\N	\N	0	1	2	f	\N	\N	\N
2829	247	1104	1	77	\N	77	\N	\N	0	1	2	f	\N	7	\N
2830	163	1104	1	1	\N	1	\N	\N	0	1	2	f	\N	47	\N
2831	260	1105	2	32	\N	0	\N	\N	1	1	2	f	32	\N	\N
2832	127	1106	2	28142	\N	28142	\N	\N	1	1	2	f	0	8	\N
2833	129	1106	2	12	\N	12	\N	\N	0	1	2	f	0	8	\N
2834	8	1106	1	28142	\N	28142	\N	\N	1	1	2	f	\N	127	\N
2835	8	1107	2	290105	\N	0	\N	\N	1	1	2	f	290105	\N	\N
2836	97	1107	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
2837	201	1107	2	4	\N	0	\N	\N	3	1	2	f	4	\N	\N
2838	39	1107	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
2839	122	1107	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2840	119	1107	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2841	9	1107	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2842	7	1107	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2843	230	1107	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2844	32	1107	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2845	99	1107	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2846	229	1107	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2847	235	1108	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
2848	56	1108	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
2849	23	1109	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
2850	260	1110	2	257	\N	0	\N	\N	1	1	2	f	257	\N	\N
2851	249	1111	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
2852	56	1111	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2853	100	1111	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
2854	29	1112	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2855	81	1113	2	155	\N	0	\N	\N	1	1	2	f	155	\N	\N
2856	120	1113	2	155	\N	0	\N	\N	0	1	2	f	155	\N	\N
2857	7	1113	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
2858	246	1113	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
2859	250	1114	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2860	100	1115	2	1216654	\N	\N	\N	\N	1	1	2	f	1216654	\N	\N
2861	195	1115	2	1015273	\N	1015273	\N	\N	2	1	2	f	\N	8	\N
2862	170	1115	2	903121	\N	903121	\N	\N	3	1	2	f	\N	\N	\N
2863	35	1115	2	37170	\N	\N	\N	\N	4	1	2	f	37170	\N	\N
2864	256	1115	2	36723	\N	\N	\N	\N	5	1	2	f	36723	\N	\N
2865	179	1115	2	33643	\N	\N	\N	\N	6	1	2	f	33643	\N	\N
2866	180	1115	2	30940	\N	\N	\N	\N	7	1	2	f	30940	\N	\N
2867	257	1115	2	27017	\N	\N	\N	\N	8	1	2	f	27017	\N	\N
2868	127	1115	2	25693	\N	\N	\N	\N	9	1	2	f	25693	\N	\N
2869	86	1115	2	24535	\N	\N	\N	\N	10	1	2	f	24535	\N	\N
2870	151	1115	2	19518	\N	\N	\N	\N	11	1	2	f	19518	\N	\N
2871	82	1115	2	13805	\N	\N	\N	\N	12	1	2	f	13805	\N	\N
2872	208	1115	2	1535	\N	\N	\N	\N	13	1	2	f	1535	\N	\N
2873	255	1115	2	499	\N	\N	\N	\N	14	1	2	f	499	\N	\N
2874	56	1115	2	1216654	\N	\N	\N	\N	0	1	2	f	1216654	\N	\N
2875	178	1115	2	1013164	\N	\N	\N	\N	0	1	2	f	1013164	\N	\N
2876	125	1115	2	269357	\N	\N	\N	\N	0	1	2	f	269357	\N	\N
2877	129	1115	2	11	\N	\N	\N	\N	0	1	2	f	11	\N	\N
2878	8	1115	1	1892754	\N	1892754	\N	\N	1	1	2	f	\N	\N	\N
2879	33	1115	1	5	\N	5	\N	\N	2	1	2	f	\N	170	\N
2880	37	1116	2	76890	\N	0	\N	\N	1	1	2	f	76890	\N	\N
2881	60	1116	2	40831	\N	0	\N	\N	2	1	2	f	40831	\N	\N
2882	105	1116	2	550	\N	0	\N	\N	3	1	2	f	550	\N	\N
2883	56	1116	2	40831	\N	0	\N	\N	0	1	2	f	40831	\N	\N
2884	150	1116	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2885	246	1117	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
2886	7	1117	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
2887	120	1117	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
2888	38	1118	2	73	\N	0	\N	\N	1	1	2	f	73	\N	\N
2889	39	1118	2	21	\N	0	\N	\N	2	1	2	f	21	\N	\N
2890	8	1118	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
2891	99	1118	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
2892	183	1119	2	189	\N	0	\N	\N	1	1	2	f	189	\N	\N
2893	226	1120	2	1729358	\N	1729358	\N	\N	1	1	2	f	0	8	\N
2894	8	1120	1	1728187	\N	1728187	\N	\N	1	1	2	f	\N	226	\N
2895	24	1121	2	437249	\N	437249	\N	\N	1	1	2	f	0	51	\N
2896	51	1121	1	437249	\N	437249	\N	\N	1	1	2	f	\N	24	\N
2897	201	1122	2	3	\N	3	\N	\N	1	1	2	f	0	201	\N
2898	201	1122	1	3	\N	3	\N	\N	1	1	2	f	\N	201	\N
2899	208	1123	2	1536	\N	1536	\N	\N	1	1	2	f	0	59	\N
2900	59	1123	1	1536	\N	1536	\N	\N	1	1	2	f	\N	208	\N
2901	4	1124	2	212602	\N	212602	\N	\N	1	1	2	f	0	\N	\N
2902	187	1124	2	4165	\N	4165	\N	\N	2	1	2	f	0	\N	\N
2903	13	1124	1	76984	\N	76984	\N	\N	1	1	2	f	\N	4	\N
2904	15	1125	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
2905	7	1125	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2906	81	1126	2	370	\N	0	\N	\N	1	1	2	f	370	\N	\N
2907	120	1126	2	370	\N	0	\N	\N	0	1	2	f	370	\N	\N
2908	7	1126	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
2909	246	1126	2	329	\N	0	\N	\N	0	1	2	f	329	\N	\N
2910	181	1127	2	35097	\N	0	\N	\N	1	1	2	f	35097	\N	\N
2911	56	1127	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
2912	257	1128	2	25410	\N	0	\N	\N	1	1	2	f	25410	\N	\N
2913	8	1129	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2914	7	1129	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2915	107	1130	2	1529	\N	0	\N	\N	1	1	2	f	1529	\N	\N
2916	87	1130	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2917	7	1130	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2918	81	1131	2	135	\N	0	\N	\N	1	1	2	f	135	\N	\N
2919	120	1131	2	135	\N	0	\N	\N	0	1	2	f	135	\N	\N
2920	7	1131	2	106	\N	0	\N	\N	0	1	2	f	106	\N	\N
2921	246	1131	2	106	\N	0	\N	\N	0	1	2	f	106	\N	\N
2922	129	1132	2	350	\N	350	\N	\N	1	1	2	f	0	8	\N
2923	8	1132	1	350	\N	350	\N	\N	1	1	2	f	\N	129	\N
2924	125	1133	2	113310	\N	0	\N	\N	1	1	2	f	113310	\N	\N
2925	56	1133	2	105533	\N	0	\N	\N	0	1	2	f	105533	\N	\N
2926	100	1133	2	105533	\N	0	\N	\N	0	1	2	f	105533	\N	\N
2927	253	1134	2	6706	\N	0	\N	\N	1	1	2	f	6706	\N	\N
2928	8	1135	2	796	\N	0	\N	\N	1	1	2	f	796	\N	\N
2929	233	1136	2	2365155	\N	2365155	\N	\N	1	1	2	f	0	\N	\N
2930	8	1136	1	21116	\N	21116	\N	\N	1	1	2	f	\N	233	\N
2931	209	1137	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
2932	88	1138	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
2933	246	1139	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2934	7	1139	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
2935	120	1139	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
2936	174	1140	2	11142	\N	0	\N	\N	1	1	2	f	11142	\N	\N
2937	8	1141	2	29810	\N	18834	\N	\N	1	1	2	f	10976	\N	\N
2938	8	1141	1	18834	\N	18834	\N	\N	1	1	2	f	\N	8	\N
2939	61	1142	2	170	\N	170	\N	\N	1	1	2	f	0	\N	\N
2940	33	1142	2	2	\N	2	\N	\N	2	1	2	f	0	247	\N
2941	247	1142	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
2942	49	1143	2	472	\N	0	\N	\N	1	1	2	f	472	\N	\N
2943	156	1144	2	411027	\N	0	\N	\N	1	1	2	f	411027	\N	\N
2944	253	1145	2	10497	\N	10497	\N	\N	1	1	2	f	\N	8	\N
2945	81	1145	2	155	\N	\N	\N	\N	2	1	2	f	155	\N	\N
2946	120	1145	2	155	\N	\N	\N	\N	0	1	2	f	155	\N	\N
2947	7	1145	2	120	\N	\N	\N	\N	0	1	2	f	120	\N	\N
2948	246	1145	2	120	\N	\N	\N	\N	0	1	2	f	120	\N	\N
2949	8	1145	1	10497	\N	10497	\N	\N	1	1	2	f	\N	253	\N
2950	29	1146	2	130	\N	0	\N	\N	1	1	2	f	130	\N	\N
2951	76	1147	2	100	\N	0	\N	\N	1	1	2	f	100	\N	\N
2952	105	1147	2	42	\N	0	\N	\N	2	1	2	f	42	\N	\N
2953	150	1147	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
2954	80	1148	2	1	\N	1	\N	\N	1	1	2	f	0	182	\N
2955	182	1148	1	1	\N	1	\N	\N	1	1	2	f	\N	80	\N
2956	15	1149	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
2957	266	1150	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
2958	253	1151	2	3771	\N	0	\N	\N	1	1	2	f	3771	\N	\N
2959	128	1151	2	2516	\N	0	\N	\N	2	1	2	f	2516	\N	\N
2960	210	1152	2	36535	\N	0	\N	\N	1	1	2	f	36535	\N	\N
2961	107	1153	2	1555	\N	0	\N	\N	1	1	2	f	1555	\N	\N
2962	87	1153	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2963	7	1153	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2964	128	1155	2	2767	\N	0	\N	\N	1	1	2	f	2767	\N	\N
2965	81	1156	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
2966	253	1156	2	207	\N	0	\N	\N	2	1	2	f	207	\N	\N
2967	128	1156	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
2968	120	1156	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
2969	7	1156	2	753	\N	0	\N	\N	0	1	2	f	753	\N	\N
2970	246	1156	2	753	\N	0	\N	\N	0	1	2	f	753	\N	\N
2971	29	1157	2	47	\N	0	\N	\N	1	1	2	f	47	\N	\N
2972	158	1158	2	7625	\N	0	\N	\N	1	1	2	f	7625	\N	\N
2973	264	1158	2	2022	\N	0	\N	\N	2	1	2	f	2022	\N	\N
2974	234	1159	2	24003	\N	0	\N	\N	1	1	2	f	24003	\N	\N
2975	56	1159	2	24003	\N	0	\N	\N	0	1	2	f	24003	\N	\N
2976	7	1160	2	16230	\N	0	\N	\N	1	1	2	f	16230	\N	\N
2977	97	1160	2	106	\N	0	\N	\N	2	1	2	f	106	\N	\N
2978	155	1160	2	12	\N	0	\N	\N	3	1	2	f	12	\N	\N
2979	250	1160	2	9	\N	0	\N	\N	4	1	2	f	9	\N	\N
2980	184	1160	2	4	\N	0	\N	\N	5	1	2	f	4	\N	\N
2981	102	1160	2	16180	\N	0	\N	\N	0	1	2	f	16180	\N	\N
2982	118	1160	2	132	\N	0	\N	\N	0	1	2	f	132	\N	\N
2983	120	1160	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
2984	246	1160	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
2985	247	1160	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
2986	172	1160	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2987	44	1161	2	5566	\N	0	\N	\N	1	1	2	f	5566	\N	\N
2988	56	1161	2	5561	\N	0	\N	\N	0	1	2	f	5561	\N	\N
2989	130	1162	2	683	\N	0	\N	\N	1	1	2	f	683	\N	\N
2990	8	1163	2	164	\N	34	\N	\N	1	1	2	f	130	\N	\N
2991	7	1163	2	2	\N	2	\N	\N	0	1	2	f	\N	8	\N
2992	8	1163	1	34	\N	34	\N	\N	1	1	2	f	\N	8	\N
2993	7	1164	2	669619	\N	0	\N	\N	1	1	2	f	669619	\N	\N
2994	98	1164	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
2995	47	1164	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
2996	251	1164	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
2997	246	1164	2	458085	\N	0	\N	\N	0	1	2	f	458085	\N	\N
2998	247	1164	2	386158	\N	0	\N	\N	0	1	2	f	386158	\N	\N
2999	248	1164	2	183399	\N	0	\N	\N	0	1	2	f	183399	\N	\N
3000	120	1164	2	161880	\N	0	\N	\N	0	1	2	f	161880	\N	\N
3001	252	1164	2	27940	\N	0	\N	\N	0	1	2	f	27940	\N	\N
3002	231	1164	2	4211	\N	0	\N	\N	0	1	2	f	4211	\N	\N
3003	57	1164	2	3843	\N	0	\N	\N	0	1	2	f	3843	\N	\N
3004	123	1164	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
3005	11	1164	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
3006	102	1164	2	230	\N	0	\N	\N	0	1	2	f	230	\N	\N
3007	232	1164	2	134	\N	0	\N	\N	0	1	2	f	134	\N	\N
3008	34	1164	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
3009	58	1164	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
3010	81	1164	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
3011	211	1164	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
3012	204	1164	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
3013	129	1164	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
3014	172	1164	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3015	14	1164	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3016	87	1164	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3017	103	1164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3018	163	1164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3019	15	1165	2	31	\N	31	\N	\N	1	1	2	f	0	\N	\N
3020	128	1166	2	4436	\N	0	\N	\N	1	1	2	f	4436	\N	\N
3021	250	1167	2	83	\N	83	\N	\N	1	1	2	f	0	\N	\N
3022	36	1168	2	683430	\N	683430	\N	\N	1	1	2	f	0	\N	\N
3023	188	1168	1	591647	\N	591647	\N	\N	1	1	2	f	\N	36	\N
3024	96	1168	1	89221	\N	89221	\N	\N	2	1	2	f	\N	36	\N
3025	222	1168	1	774	\N	774	\N	\N	3	1	2	f	\N	36	\N
3026	116	1169	2	1054569	\N	1054569	\N	\N	1	1	2	f	0	\N	\N
3027	88	1169	2	935516	\N	935516	\N	\N	2	1	2	f	0	\N	\N
3028	13	1169	2	1367	\N	1367	\N	\N	3	1	2	f	0	\N	\N
3029	101	1169	1	1053895	\N	1053895	\N	\N	1	1	2	f	\N	116	\N
3030	13	1169	1	139	\N	139	\N	\N	2	1	2	f	\N	13	\N
3031	36	1169	1	1	\N	1	\N	\N	3	1	2	f	\N	116	\N
3032	14	1169	1	1501	\N	1501	\N	\N	0	1	2	f	\N	\N	\N
3033	135	1170	2	1362	\N	0	\N	\N	1	1	2	f	1362	\N	\N
3034	38	1170	2	73	\N	0	\N	\N	2	1	2	f	73	\N	\N
3035	91	1170	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
3036	39	1170	2	21	\N	0	\N	\N	4	1	2	f	21	\N	\N
3037	8	1170	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
3038	99	1170	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
3039	253	1171	2	1555	\N	0	\N	\N	1	1	2	f	1555	\N	\N
3040	205	1172	2	222400	\N	222400	\N	\N	1	1	2	f	0	\N	\N
3041	207	1172	1	220519	\N	220519	\N	\N	1	1	2	f	\N	205	\N
3042	129	1172	1	37	\N	37	\N	\N	0	1	2	f	\N	205	\N
3043	7	1172	1	4	\N	4	\N	\N	0	1	2	f	\N	205	\N
3044	15	1174	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
3045	215	1174	2	216	\N	0	\N	\N	2	1	2	f	216	\N	\N
3046	7	1174	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3047	258	1175	2	251	\N	251	\N	\N	1	1	2	f	0	\N	\N
3048	56	1175	2	251	\N	251	\N	\N	0	1	2	f	0	\N	\N
3049	268	1176	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
3050	44	1178	2	10358	\N	0	\N	\N	1	1	2	f	10358	\N	\N
3051	56	1178	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
3052	237	1179	2	3532	\N	3532	\N	\N	1	1	2	f	0	\N	\N
3053	253	1180	2	5833	\N	5833	\N	\N	1	1	2	f	0	\N	\N
3054	128	1180	2	3133	\N	3133	\N	\N	2	1	2	f	0	\N	\N
3055	8	1180	1	8543	\N	8543	\N	\N	1	1	2	f	\N	\N	\N
3056	58	1181	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
3057	120	1181	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3058	7	1181	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3059	246	1181	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3060	249	1182	2	629419	\N	629419	\N	\N	1	1	2	f	0	28	\N
3061	129	1182	2	130994	\N	130994	\N	\N	2	1	2	f	0	\N	\N
3062	56	1182	2	629419	\N	629419	\N	\N	0	1	2	f	0	28	\N
3063	100	1182	2	629419	\N	629419	\N	\N	0	1	2	f	0	28	\N
3064	7	1182	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
3065	207	1182	2	37	\N	37	\N	\N	0	1	2	f	0	\N	\N
3066	248	1182	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
3067	177	1182	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
3068	12	1182	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3069	127	1182	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3070	120	1182	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3071	246	1182	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3072	247	1182	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3073	59	1182	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3074	252	1182	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3075	28	1182	1	629875	\N	629875	\N	\N	1	1	2	f	\N	\N	\N
3076	76	1183	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
3077	215	1184	2	40	\N	40	\N	\N	1	1	2	f	0	215	\N
3078	215	1184	1	40	\N	40	\N	\N	1	1	2	f	\N	215	\N
3079	253	1185	2	5823	\N	0	\N	\N	1	1	2	f	5823	\N	\N
3080	128	1185	2	2681	\N	0	\N	\N	2	1	2	f	2681	\N	\N
3081	81	1185	2	102	\N	0	\N	\N	3	1	2	f	102	\N	\N
3082	120	1185	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
3083	7	1185	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
3084	246	1185	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
3085	130	1186	2	40	\N	0	\N	\N	1	1	2	f	40	\N	\N
3086	36	1187	2	1016465	\N	1016465	\N	\N	1	1	2	f	0	195	\N
3087	195	1187	1	1015273	\N	1015273	\N	\N	1	1	2	f	\N	36	\N
3088	209	1188	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
3089	79	1191	2	70859	\N	0	\N	\N	1	1	2	f	70859	\N	\N
3090	180	1192	2	30958	\N	30958	\N	\N	1	1	2	f	0	\N	\N
3091	8	1192	1	30928	\N	30928	\N	\N	1	1	2	f	\N	180	\N
3092	246	1193	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
3093	7	1193	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
3094	120	1193	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3095	213	1194	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
3096	133	1195	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
3097	202	1196	2	39723	\N	39723	\N	\N	1	1	2	f	0	\N	\N
3098	87	1196	2	996	\N	996	\N	\N	2	1	2	f	0	\N	\N
3099	7	1196	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3100	248	1196	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
3101	247	1196	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
3102	249	1196	1	19815	\N	19815	\N	\N	1	1	2	f	\N	202	\N
3103	202	1196	1	4524	\N	4524	\N	\N	2	1	2	f	\N	202	\N
3104	56	1196	1	19815	\N	19815	\N	\N	0	1	2	f	\N	202	\N
3105	100	1196	1	19815	\N	19815	\N	\N	0	1	2	f	\N	202	\N
3106	127	1197	2	25675	\N	25675	\N	\N	1	1	2	f	0	8	\N
3107	129	1197	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
3108	8	1197	1	25675	\N	25675	\N	\N	1	1	2	f	\N	127	\N
3109	70	1198	2	37	\N	0	\N	\N	1	1	2	f	37	\N	\N
3110	224	1199	2	1941020	\N	0	\N	\N	1	1	2	f	1941020	\N	\N
3111	218	1200	2	5923	\N	0	\N	\N	1	1	2	f	5923	\N	\N
3112	29	1201	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
3113	90	1202	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
3114	181	1203	2	3706	\N	0	\N	\N	1	1	2	f	3706	\N	\N
3115	56	1203	2	3706	\N	0	\N	\N	0	1	2	f	3706	\N	\N
3116	48	1204	2	1178	\N	0	\N	\N	1	1	2	f	1178	\N	\N
3117	269	1205	2	165	\N	0	\N	\N	1	1	2	f	165	\N	\N
3118	61	1206	2	170	\N	170	\N	\N	1	1	2	f	0	258	\N
3119	251	1206	2	1	\N	1	\N	\N	2	1	2	f	0	250	\N
3120	258	1206	1	253	\N	253	\N	\N	1	1	2	f	\N	61	\N
3121	107	1206	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
3122	134	1206	1	3	\N	3	\N	\N	3	1	2	f	\N	\N	\N
3123	250	1206	1	1	\N	1	\N	\N	4	1	2	f	\N	251	\N
3124	56	1206	1	253	\N	253	\N	\N	0	1	2	f	\N	61	\N
3125	7	1206	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
3126	253	1207	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
3127	237	1208	2	37642	\N	37642	\N	\N	1	1	2	f	0	\N	\N
3128	29	1209	2	56	\N	56	\N	\N	1	1	2	f	0	\N	\N
3129	209	1210	2	327	\N	0	\N	\N	1	1	2	f	327	\N	\N
3130	235	1211	2	2478	\N	0	\N	\N	1	1	2	f	2478	\N	\N
3131	56	1211	2	2478	\N	0	\N	\N	0	1	2	f	2478	\N	\N
3132	103	1212	2	6556	\N	0	\N	\N	1	1	2	f	6556	\N	\N
3133	7	1212	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3134	248	1212	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3135	247	1212	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3136	58	1213	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
3137	120	1213	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
3138	7	1213	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3139	246	1213	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3140	166	1214	2	203591	\N	0	\N	\N	1	1	2	f	203591	\N	\N
3141	50	1214	2	4779	\N	0	\N	\N	2	1	2	f	4779	\N	\N
3142	129	1215	2	7020	\N	0	\N	\N	1	1	2	f	7020	\N	\N
3143	174	1216	2	1878	\N	1878	\N	\N	1	1	2	f	0	\N	\N
3144	8	1216	1	1850	\N	1850	\N	\N	1	1	2	f	\N	174	\N
3145	33	1216	1	15	\N	15	\N	\N	2	1	2	f	\N	174	\N
3146	44	1217	2	9242	\N	0	\N	\N	1	1	2	f	9242	\N	\N
3147	56	1217	2	9205	\N	0	\N	\N	0	1	2	f	9205	\N	\N
3148	107	1219	2	29474	\N	29474	\N	\N	1	1	2	f	0	\N	\N
3149	87	1219	2	60	\N	60	\N	\N	0	1	2	f	0	227	\N
3150	7	1219	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3151	227	1219	1	29408	\N	29408	\N	\N	1	1	2	f	\N	107	\N
3152	128	1221	2	18683	\N	18683	\N	\N	1	1	2	f	0	\N	\N
3153	129	1222	2	216	\N	216	\N	\N	1	1	2	f	0	50	\N
3154	50	1222	1	216	\N	216	\N	\N	1	1	2	f	\N	129	\N
3155	103	1223	2	6283	\N	0	\N	\N	1	1	2	f	6283	\N	\N
3156	14	1223	2	3483	\N	0	\N	\N	2	1	2	f	3483	\N	\N
3157	13	1223	2	927	\N	0	\N	\N	3	1	2	f	927	\N	\N
3158	130	1223	2	681	\N	0	\N	\N	4	1	2	f	681	\N	\N
3159	7	1223	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3160	248	1223	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
3161	247	1223	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3162	101	1223	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3163	252	1223	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3164	249	1224	2	30937	\N	0	\N	\N	1	1	2	f	30937	\N	\N
3165	174	1224	2	11801	\N	0	\N	\N	2	1	2	f	11801	\N	\N
3166	14	1224	2	3343	\N	0	\N	\N	3	1	2	f	3343	\N	\N
3167	13	1224	2	1340	\N	0	\N	\N	4	1	2	f	1340	\N	\N
3168	107	1224	2	1255	\N	0	\N	\N	5	1	2	f	1255	\N	\N
3169	130	1224	2	678	\N	0	\N	\N	6	1	2	f	678	\N	\N
3170	56	1224	2	30937	\N	0	\N	\N	0	1	2	f	30937	\N	\N
3171	100	1224	2	30937	\N	0	\N	\N	0	1	2	f	30937	\N	\N
3172	7	1224	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
3173	87	1224	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3174	247	1224	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3175	248	1224	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3176	101	1224	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3177	252	1224	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3178	80	1225	2	1	\N	1	\N	\N	1	1	2	f	0	80	\N
3179	80	1225	1	1	\N	1	\N	\N	1	1	2	f	\N	80	\N
3180	235	1226	2	36010	\N	0	\N	\N	1	1	2	f	36010	\N	\N
3181	56	1226	2	36010	\N	0	\N	\N	0	1	2	f	36010	\N	\N
3182	58	1227	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
3183	120	1227	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3184	7	1227	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3185	246	1227	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3186	42	1228	2	25252	\N	0	\N	\N	1	1	2	f	25252	\N	\N
3187	56	1228	2	25252	\N	0	\N	\N	0	1	2	f	25252	\N	\N
3188	75	1229	2	4706	\N	0	\N	\N	1	1	2	f	4706	\N	\N
3189	249	1230	2	886891	\N	886891	\N	\N	1	1	2	f	0	116	\N
3190	177	1230	2	1	\N	1	\N	\N	2	1	2	f	0	116	\N
3191	56	1230	2	886891	\N	886891	\N	\N	0	1	2	f	0	116	\N
3192	100	1230	2	886891	\N	886891	\N	\N	0	1	2	f	0	116	\N
3193	116	1230	1	1054453	\N	1054453	\N	\N	1	1	2	f	\N	\N	\N
3194	15	1231	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3195	195	1232	2	1014475	\N	818219	\N	\N	1	1	2	f	196256	\N	\N
3196	189	1232	2	244387	\N	\N	\N	\N	2	1	2	f	244387	\N	\N
3197	8	1232	1	417555	\N	417555	\N	\N	1	1	2	f	\N	195	\N
3198	249	1232	1	352031	\N	352031	\N	\N	2	1	2	f	\N	195	\N
3199	13	1232	1	2571	\N	2571	\N	\N	3	1	2	f	\N	195	\N
3200	168	1232	1	640	\N	640	\N	\N	4	1	2	f	\N	195	\N
3201	174	1232	1	280	\N	280	\N	\N	5	1	2	f	\N	195	\N
3202	247	1232	1	9	\N	9	\N	\N	6	1	2	f	\N	195	\N
3203	56	1232	1	352031	\N	352031	\N	\N	0	1	2	f	\N	195	\N
3204	100	1232	1	352031	\N	352031	\N	\N	0	1	2	f	\N	195	\N
3205	7	1232	1	86	\N	86	\N	\N	0	1	2	f	\N	195	\N
3206	246	1232	1	9	\N	9	\N	\N	0	1	2	f	\N	195	\N
3207	180	1233	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
3208	105	1234	2	187	\N	0	\N	\N	1	1	2	f	187	\N	\N
3209	150	1234	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3210	30	1235	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3211	16	1236	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
3212	81	1237	2	2131	\N	0	\N	\N	1	1	2	f	2131	\N	\N
3213	253	1237	2	313	\N	0	\N	\N	2	1	2	f	313	\N	\N
3214	120	1237	2	2131	\N	0	\N	\N	0	1	2	f	2131	\N	\N
3215	7	1237	2	1618	\N	0	\N	\N	0	1	2	f	1618	\N	\N
3216	246	1237	2	1618	\N	0	\N	\N	0	1	2	f	1618	\N	\N
3217	88	1238	2	935591	\N	0	\N	\N	1	1	2	f	935591	\N	\N
3218	128	1239	2	18175	\N	18175	\N	\N	1	1	2	f	0	\N	\N
3219	214	1245	2	65	\N	0	\N	\N	1	1	2	f	65	\N	\N
3220	10	1245	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
3221	81	1246	2	2569	\N	0	\N	\N	1	1	2	f	2569	\N	\N
3222	120	1246	2	2569	\N	0	\N	\N	0	1	2	f	2569	\N	\N
3223	7	1246	2	1908	\N	0	\N	\N	0	1	2	f	1908	\N	\N
3224	246	1246	2	1908	\N	0	\N	\N	0	1	2	f	1908	\N	\N
3225	253	1247	2	10515	\N	10515	\N	\N	1	1	2	f	\N	8	\N
3226	81	1247	2	146	\N	\N	\N	\N	2	1	2	f	146	\N	\N
3227	120	1247	2	146	\N	\N	\N	\N	0	1	2	f	146	\N	\N
3228	7	1247	2	111	\N	\N	\N	\N	0	1	2	f	111	\N	\N
3229	246	1247	2	111	\N	\N	\N	\N	0	1	2	f	111	\N	\N
3230	8	1247	1	10515	\N	10515	\N	\N	1	1	2	f	\N	253	\N
3231	237	1248	2	217680	\N	0	\N	\N	1	1	2	f	217680	\N	\N
3232	181	1251	2	2906	\N	0	\N	\N	1	1	2	f	2906	\N	\N
3233	56	1251	2	2906	\N	0	\N	\N	0	1	2	f	2906	\N	\N
3234	235	1252	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
3235	56	1252	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
3236	176	1253	2	8028	\N	8028	\N	\N	1	1	2	f	0	78	\N
3237	78	1253	1	8028	\N	8028	\N	\N	1	1	2	f	\N	176	\N
3238	253	1254	2	2408	\N	2408	\N	\N	1	1	2	f	0	\N	\N
3239	8	1254	1	2222	\N	2222	\N	\N	1	1	2	f	\N	253	\N
3240	103	1255	2	157238	\N	157238	\N	\N	1	1	2	f	0	\N	\N
3241	202	1255	1	40471	\N	40471	\N	\N	1	1	2	f	\N	103	\N
3242	249	1255	1	39194	\N	39194	\N	\N	2	1	2	f	\N	103	\N
3243	101	1255	1	31765	\N	31765	\N	\N	3	1	2	f	\N	103	\N
3244	207	1255	1	16866	\N	16866	\N	\N	4	1	2	f	\N	103	\N
3245	174	1255	1	5200	\N	5200	\N	\N	5	1	2	f	\N	103	\N
3246	107	1255	1	1644	\N	1644	\N	\N	6	1	2	f	\N	103	\N
3247	130	1255	1	207	\N	207	\N	\N	7	1	2	f	\N	103	\N
3248	13	1255	1	16	\N	16	\N	\N	8	1	2	f	\N	103	\N
3249	56	1255	1	39194	\N	39194	\N	\N	0	1	2	f	\N	103	\N
3250	100	1255	1	39194	\N	39194	\N	\N	0	1	2	f	\N	103	\N
3251	129	1255	1	5651	\N	5651	\N	\N	0	1	2	f	\N	103	\N
3252	14	1255	1	332	\N	332	\N	\N	0	1	2	f	\N	103	\N
3253	87	1255	1	33	\N	33	\N	\N	0	1	2	f	\N	103	\N
3254	7	1255	1	1	\N	1	\N	\N	0	1	2	f	\N	103	\N
3255	216	1256	2	41	\N	0	\N	\N	1	1	2	f	41	\N	\N
3256	208	1257	2	1518	\N	0	\N	\N	1	1	2	f	1518	\N	\N
3257	44	1258	2	10358	\N	0	\N	\N	1	1	2	f	10358	\N	\N
3258	56	1258	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
3259	58	1259	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
3260	120	1259	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3261	7	1259	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3262	246	1259	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3263	223	1260	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
3264	196	1261	2	129809	\N	0	\N	\N	1	1	2	f	129809	\N	\N
3265	178	1264	2	1	\N	1	\N	\N	1	1	2	f	0	249	\N
3266	56	1264	2	1	\N	1	\N	\N	0	1	2	f	0	249	\N
3267	100	1264	2	1	\N	1	\N	\N	0	1	2	f	0	249	\N
3268	249	1264	1	1	\N	1	\N	\N	1	1	2	f	\N	178	\N
3269	56	1264	1	1	\N	1	\N	\N	0	1	2	f	\N	178	\N
3270	100	1264	1	1	\N	1	\N	\N	0	1	2	f	\N	178	\N
3271	127	1266	2	28135	\N	28135	\N	\N	1	1	2	f	0	8	\N
3272	129	1266	2	11	\N	11	\N	\N	0	1	2	f	0	8	\N
3273	8	1266	1	28135	\N	28135	\N	\N	1	1	2	f	\N	127	\N
3274	237	1267	2	217681	\N	217681	\N	\N	1	1	2	f	0	134	\N
3275	134	1267	1	217681	\N	217681	\N	\N	1	1	2	f	\N	237	\N
3276	246	1268	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
3277	7	1268	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
3278	120	1268	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3279	8	1269	2	29398	\N	27711	\N	\N	1	1	2	f	1687	\N	\N
3280	7	1269	2	1	\N	1	\N	\N	0	1	2	f	\N	8	\N
3281	8	1269	1	27711	\N	27711	\N	\N	1	1	2	f	\N	8	\N
3282	128	1270	2	4194	\N	0	\N	\N	1	1	2	f	4194	\N	\N
3283	38	1271	2	72	\N	0	\N	\N	1	1	2	f	72	\N	\N
3284	8	1271	2	72	\N	0	\N	\N	0	1	2	f	72	\N	\N
3285	70	1272	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3286	29	1274	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3287	208	1276	2	3525	\N	3525	\N	\N	1	1	2	f	0	75	\N
3288	126	1276	2	1279	\N	1279	\N	\N	2	1	2	f	0	75	\N
3289	75	1276	1	4804	\N	4804	\N	\N	1	1	2	f	\N	\N	\N
3290	150	1277	2	862	\N	0	\N	\N	1	1	2	f	862	\N	\N
3291	105	1277	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3292	183	1278	2	189	\N	0	\N	\N	1	1	2	f	189	\N	\N
3293	60	1279	2	40830	\N	0	\N	\N	1	1	2	f	40830	\N	\N
3294	56	1279	2	40830	\N	0	\N	\N	0	1	2	f	40830	\N	\N
3295	177	1280	2	5270557	\N	0	\N	\N	1	1	2	f	5270557	\N	\N
3296	129	1280	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
3297	235	1282	2	33136	\N	0	\N	\N	1	1	2	f	33136	\N	\N
3298	56	1282	2	33136	\N	0	\N	\N	0	1	2	f	33136	\N	\N
3299	101	1283	2	37235	\N	0	\N	\N	1	1	2	f	37235	\N	\N
3300	8	1285	2	2009	\N	1010	\N	\N	1	1	2	f	999	\N	\N
3301	8	1285	1	20	\N	20	\N	\N	1	1	2	f	\N	8	\N
3302	258	1286	2	249	\N	0	\N	\N	1	1	2	f	249	\N	\N
3303	213	1286	2	246	\N	0	\N	\N	2	1	2	f	246	\N	\N
3304	56	1286	2	249	\N	0	\N	\N	0	1	2	f	249	\N	\N
3305	8	1287	2	4547	\N	0	\N	\N	1	1	2	f	4547	\N	\N
3306	189	1289	2	244387	\N	244387	\N	\N	1	1	2	f	0	106	\N
3307	106	1289	1	245011	\N	245011	\N	\N	1	1	2	f	\N	189	\N
3308	258	1290	2	12724	\N	0	\N	\N	1	1	2	f	12724	\N	\N
3309	56	1290	2	12724	\N	0	\N	\N	0	1	2	f	12724	\N	\N
3310	25	1291	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
3311	192	1291	2	246	\N	0	\N	\N	2	1	2	f	246	\N	\N
3312	223	1291	2	246	\N	0	\N	\N	3	1	2	f	246	\N	\N
3313	180	1292	2	26546	\N	26546	\N	\N	1	1	2	f	0	\N	\N
3314	8	1292	1	22587	\N	22587	\N	\N	1	1	2	f	\N	180	\N
3315	29	1293	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
3316	174	1296	2	3356	\N	0	\N	\N	1	1	2	f	3356	\N	\N
3317	233	1297	2	2364670	\N	2364670	\N	\N	1	1	2	f	0	\N	\N
3318	36	1297	2	484238	\N	484238	\N	\N	2	1	2	f	0	\N	\N
3319	202	1297	1	2767315	\N	2767315	\N	\N	1	1	2	f	\N	\N	\N
3320	87	1297	1	48002	\N	48002	\N	\N	2	1	2	f	\N	\N	\N
3321	249	1297	1	853	\N	853	\N	\N	3	1	2	f	\N	\N	\N
3322	101	1297	1	711	\N	711	\N	\N	4	1	2	f	\N	36	\N
3323	255	1297	1	33	\N	33	\N	\N	5	1	2	f	\N	233	\N
3324	246	1297	1	14	\N	14	\N	\N	6	1	2	f	\N	36	\N
3325	56	1297	1	853	\N	853	\N	\N	0	1	2	f	\N	\N	\N
3326	100	1297	1	853	\N	853	\N	\N	0	1	2	f	\N	\N	\N
3327	107	1297	1	402	\N	402	\N	\N	0	1	2	f	\N	\N	\N
3328	7	1297	1	14	\N	14	\N	\N	0	1	2	f	\N	36	\N
3329	224	1299	2	1961446	\N	0	\N	\N	1	1	2	f	1961446	\N	\N
3330	58	1301	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
3331	120	1301	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
3332	7	1301	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3333	246	1301	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3334	19	1303	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
3335	8	1304	2	9188	\N	0	\N	\N	1	1	2	f	9188	\N	\N
3336	97	1304	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
3337	201	1304	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
3338	122	1304	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3339	230	1304	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3340	119	1304	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3341	229	1304	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3342	19	1305	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
3343	215	1306	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
3344	179	1307	2	1925943	\N	1925943	\N	\N	1	1	2	f	0	8	\N
3345	8	1307	1	1925674	\N	1925674	\N	\N	1	1	2	f	\N	179	\N
3346	107	1308	2	1582	\N	0	\N	\N	1	1	2	f	1582	\N	\N
3347	87	1308	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3348	7	1308	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3349	253	1309	2	2215	\N	2215	\N	\N	1	1	2	f	\N	8	\N
3350	81	1309	2	155	\N	\N	\N	\N	2	1	2	f	155	\N	\N
3351	120	1309	2	155	\N	\N	\N	\N	0	1	2	f	155	\N	\N
3352	7	1309	2	120	\N	\N	\N	\N	0	1	2	f	120	\N	\N
3353	246	1309	2	120	\N	\N	\N	\N	0	1	2	f	120	\N	\N
3354	8	1309	1	2215	\N	2215	\N	\N	1	1	2	f	\N	253	\N
3355	84	1310	2	3604	\N	0	\N	\N	1	1	2	f	3604	\N	\N
3356	56	1310	2	3604	\N	0	\N	\N	0	1	2	f	3604	\N	\N
3357	48	1311	2	434	\N	0	\N	\N	1	1	2	f	434	\N	\N
3358	149	1312	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
3359	97	1312	1	17	\N	17	\N	\N	1	1	2	f	\N	149	\N
3360	9	1312	1	5	\N	5	\N	\N	0	1	2	f	\N	149	\N
3361	122	1312	1	4	\N	4	\N	\N	0	1	2	f	\N	149	\N
3362	230	1312	1	1	\N	1	\N	\N	0	1	2	f	\N	149	\N
3363	215	1313	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
3364	101	1314	2	38644	\N	0	\N	\N	1	1	2	f	38644	\N	\N
3365	179	1315	2	1925993	\N	1925993	\N	\N	1	1	2	f	0	193	\N
3366	193	1315	1	1925993	\N	1925993	\N	\N	1	1	2	f	\N	179	\N
3367	21	1316	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
3368	260	1317	2	258	\N	0	\N	\N	1	1	2	f	258	\N	\N
3369	188	1318	2	591647	\N	591647	\N	\N	1	1	2	f	0	\N	\N
3370	96	1318	2	89221	\N	89221	\N	\N	2	1	2	f	0	189	\N
3371	222	1318	2	774	\N	774	\N	\N	3	1	2	f	0	24	\N
3372	24	1318	1	437249	\N	437249	\N	\N	1	1	2	f	\N	188	\N
3373	189	1318	1	244387	\N	244387	\N	\N	2	1	2	f	\N	\N	\N
3374	116	1320	2	1054569	\N	1054569	\N	\N	1	1	2	f	\N	\N	\N
3375	13	1320	2	33	\N	\N	\N	\N	0	1	2	f	33	\N	\N
3376	202	1320	1	1054496	\N	1054496	\N	\N	1	1	2	f	\N	116	\N
3377	177	1320	1	1	\N	1	\N	\N	0	1	2	f	\N	116	\N
3378	81	1322	2	150	\N	0	\N	\N	1	1	2	f	150	\N	\N
3379	120	1322	2	150	\N	0	\N	\N	0	1	2	f	150	\N	\N
3380	7	1322	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
3381	246	1322	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
3382	45	1323	2	13546	\N	0	\N	\N	1	1	2	f	13546	\N	\N
3383	235	1325	2	36010	\N	0	\N	\N	1	1	2	f	36010	\N	\N
3384	56	1325	2	36010	\N	0	\N	\N	0	1	2	f	36010	\N	\N
3385	235	1326	2	520	\N	0	\N	\N	1	1	2	f	520	\N	\N
3386	56	1326	2	520	\N	0	\N	\N	0	1	2	f	520	\N	\N
3387	261	1327	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
3388	29	1328	2	53	\N	0	\N	\N	1	1	2	f	53	\N	\N
3389	202	1329	2	30271	\N	0	\N	\N	1	1	2	f	30271	\N	\N
3390	38	1330	2	170	\N	170	\N	\N	1	1	2	f	0	39	\N
3391	8	1330	2	170	\N	170	\N	\N	0	1	2	f	0	39	\N
3392	39	1330	1	170	\N	170	\N	\N	1	1	2	f	\N	38	\N
3393	99	1330	1	170	\N	170	\N	\N	0	1	2	f	\N	38	\N
3394	257	1331	2	26906	\N	26906	\N	\N	1	1	2	f	0	2	\N
3395	2	1331	1	26906	\N	26906	\N	\N	1	1	2	f	\N	257	\N
3396	201	1332	2	5	\N	5	\N	\N	1	1	2	f	0	201	\N
3397	201	1332	1	5	\N	5	\N	\N	1	1	2	f	\N	201	\N
3398	15	1333	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
3399	213	1334	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
3400	253	1335	2	12187	\N	0	\N	\N	1	1	2	f	12187	\N	\N
3401	81	1335	2	4819	\N	0	\N	\N	2	1	2	f	4819	\N	\N
3402	120	1335	2	4819	\N	0	\N	\N	0	1	2	f	4819	\N	\N
3403	7	1335	2	3672	\N	0	\N	\N	0	1	2	f	3672	\N	\N
3404	246	1335	2	3672	\N	0	\N	\N	0	1	2	f	3672	\N	\N
3405	76	1336	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
3406	105	1336	2	533	\N	0	\N	\N	2	1	2	f	533	\N	\N
3407	150	1336	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3408	128	1337	2	90650	\N	0	\N	\N	1	1	2	f	90650	\N	\N
3409	21	1338	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
3410	42	1339	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
3411	56	1339	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
3412	231	1340	2	17016	\N	17016	\N	\N	1	1	2	f	0	253	\N
3413	11	1340	2	7203	\N	7203	\N	\N	2	1	2	f	0	128	\N
3414	120	1340	2	9023	\N	9023	\N	\N	0	1	2	f	0	\N	\N
3415	7	1340	2	8395	\N	8395	\N	\N	0	1	2	f	0	\N	\N
3416	246	1340	2	8395	\N	8395	\N	\N	0	1	2	f	0	\N	\N
3417	253	1340	1	17016	\N	17016	\N	\N	1	1	2	f	\N	231	\N
3418	128	1340	1	7203	\N	7203	\N	\N	2	1	2	f	\N	11	\N
3419	29	1341	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3420	29	1342	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
3421	61	1343	2	170	\N	0	\N	\N	1	1	2	f	170	\N	\N
3422	97	1344	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
3423	83	1345	2	5455	\N	5455	\N	\N	1	1	2	f	0	89	\N
3424	89	1345	1	18263	\N	18263	\N	\N	1	1	2	f	\N	\N	\N
3425	56	1346	2	105793	\N	105793	\N	\N	1	1	2	f	0	\N	\N
3426	84	1346	2	36127	\N	36127	\N	\N	0	1	2	f	0	\N	\N
3427	181	1346	2	35097	\N	35097	\N	\N	0	1	2	f	0	\N	\N
3428	235	1346	2	34569	\N	34569	\N	\N	0	1	2	f	0	\N	\N
3429	212	1346	1	96155	\N	96155	\N	\N	1	1	2	f	\N	56	\N
3430	160	1347	2	233718	\N	0	\N	\N	1	1	2	f	233718	\N	\N
3431	88	1350	2	935797	\N	0	\N	\N	1	1	2	f	935797	\N	\N
3432	253	1351	2	379	\N	0	\N	\N	1	1	2	f	379	\N	\N
3433	128	1351	2	225	\N	0	\N	\N	2	1	2	f	225	\N	\N
3434	234	1353	2	33847	\N	0	\N	\N	1	1	2	f	33847	\N	\N
3435	56	1353	2	33846	\N	0	\N	\N	0	1	2	f	33846	\N	\N
3436	48	1356	2	5053	\N	0	\N	\N	1	1	2	f	5053	\N	\N
3437	253	1357	2	1161	\N	0	\N	\N	1	1	2	f	1161	\N	\N
3438	128	1357	2	827	\N	0	\N	\N	2	1	2	f	827	\N	\N
3439	136	1358	2	84	\N	0	\N	\N	1	1	2	f	84	\N	\N
3440	157	1359	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
3441	44	1360	2	2471	\N	0	\N	\N	1	1	2	f	2471	\N	\N
3442	56	1360	2	2471	\N	0	\N	\N	0	1	2	f	2471	\N	\N
3443	114	1361	2	889	\N	0	\N	\N	1	1	2	f	889	\N	\N
3444	172	1363	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
3445	4	1364	2	359673	\N	0	\N	\N	1	1	2	f	359673	\N	\N
3446	187	1364	2	91	\N	0	\N	\N	2	1	2	f	91	\N	\N
3447	251	1365	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
3448	250	1365	1	12	\N	12	\N	\N	1	1	2	f	\N	251	\N
3449	149	1365	1	8	\N	8	\N	\N	2	1	2	f	\N	251	\N
3450	228	1366	2	8	\N	8	\N	\N	1	1	2	f	0	199	\N
3451	199	1366	1	8	\N	8	\N	\N	1	1	2	f	\N	228	\N
3452	215	1367	2	49	\N	0	\N	\N	1	1	2	f	49	\N	\N
3453	204	1368	2	5130	\N	5130	\N	\N	1	1	2	f	0	\N	\N
3454	120	1368	2	5130	\N	5130	\N	\N	0	1	2	f	0	\N	\N
3455	7	1368	2	5053	\N	5053	\N	\N	0	1	2	f	0	\N	\N
3456	246	1368	2	5053	\N	5053	\N	\N	0	1	2	f	0	\N	\N
3457	253	1369	2	16775	\N	0	\N	\N	1	1	2	f	16775	\N	\N
3458	128	1369	2	7175	\N	0	\N	\N	2	1	2	f	7175	\N	\N
3459	81	1369	2	206	\N	0	\N	\N	3	1	2	f	206	\N	\N
3460	120	1369	2	206	\N	0	\N	\N	0	1	2	f	206	\N	\N
3461	7	1369	2	172	\N	0	\N	\N	0	1	2	f	172	\N	\N
3462	246	1369	2	172	\N	0	\N	\N	0	1	2	f	172	\N	\N
3463	42	1370	2	17922	\N	0	\N	\N	1	1	2	f	17922	\N	\N
3464	56	1370	2	17922	\N	0	\N	\N	0	1	2	f	17922	\N	\N
3465	129	1371	2	381	\N	0	\N	\N	1	1	2	f	381	\N	\N
3466	235	1373	2	32485	\N	0	\N	\N	1	1	2	f	32485	\N	\N
3467	56	1373	2	32485	\N	0	\N	\N	0	1	2	f	32485	\N	\N
3468	209	1374	2	5548	\N	0	\N	\N	1	1	2	f	5548	\N	\N
3469	15	1375	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
3470	7	1375	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3471	58	1376	2	187	\N	187	\N	\N	1	1	2	f	0	\N	\N
3472	120	1376	2	187	\N	187	\N	\N	0	1	2	f	0	\N	\N
3473	7	1376	2	152	\N	152	\N	\N	0	1	2	f	0	\N	\N
3474	246	1376	2	152	\N	152	\N	\N	0	1	2	f	0	\N	\N
3475	244	1378	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
3476	20	1379	2	9351	\N	0	\N	\N	1	1	2	f	9351	\N	\N
3477	48	1380	2	432	\N	0	\N	\N	1	1	2	f	432	\N	\N
3478	81	1381	2	1443	\N	0	\N	\N	1	1	2	f	1443	\N	\N
3479	253	1381	2	159	\N	0	\N	\N	2	1	2	f	159	\N	\N
3480	128	1381	2	27	\N	0	\N	\N	3	1	2	f	27	\N	\N
3481	120	1381	2	1443	\N	0	\N	\N	0	1	2	f	1443	\N	\N
3482	7	1381	2	1125	\N	0	\N	\N	0	1	2	f	1125	\N	\N
3483	246	1381	2	1125	\N	0	\N	\N	0	1	2	f	1125	\N	\N
3484	234	1382	2	23876	\N	0	\N	\N	1	1	2	f	23876	\N	\N
3485	56	1382	2	23876	\N	0	\N	\N	0	1	2	f	23876	\N	\N
3486	51	1383	2	437249	\N	0	\N	\N	1	1	2	f	437249	\N	\N
3487	75	1383	2	4705	\N	0	\N	\N	2	1	2	f	4705	\N	\N
3488	16	1385	2	280	\N	0	\N	\N	1	1	2	f	280	\N	\N
3489	102	1386	2	45244	\N	0	\N	\N	1	1	2	f	45244	\N	\N
3490	7	1386	2	45187	\N	0	\N	\N	0	1	2	f	45187	\N	\N
3491	247	1386	2	110	\N	0	\N	\N	0	1	2	f	110	\N	\N
3492	84	1387	2	4673	\N	0	\N	\N	1	1	2	f	4673	\N	\N
3493	56	1387	2	4673	\N	0	\N	\N	0	1	2	f	4673	\N	\N
3494	103	1388	2	6273	\N	0	\N	\N	1	1	2	f	6273	\N	\N
3495	7	1388	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3496	248	1388	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3497	247	1388	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3498	48	1389	2	787	\N	0	\N	\N	1	1	2	f	787	\N	\N
3499	180	1390	2	30752	\N	30752	\N	\N	1	1	2	f	0	78	\N
3500	208	1390	2	1536	\N	1536	\N	\N	2	1	2	f	0	78	\N
3501	78	1390	1	32288	\N	32288	\N	\N	1	1	2	f	\N	\N	\N
3502	29	1391	2	47	\N	0	\N	\N	1	1	2	f	47	\N	\N
3503	231	1392	2	6930	\N	0	\N	\N	1	1	2	f	6930	\N	\N
3504	81	1392	2	68	\N	0	\N	\N	2	1	2	f	68	\N	\N
3505	120	1392	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
3506	7	1392	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3507	246	1392	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3508	47	1393	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3509	163	1393	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3510	15	1394	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
3511	7	1394	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3512	178	1395	2	1660640	\N	1660640	\N	\N	1	1	2	f	0	\N	\N
3513	73	1395	2	561039	\N	561039	\N	\N	2	1	2	f	0	8	\N
3514	256	1395	2	37226	\N	37226	\N	\N	3	1	2	f	0	8	\N
3515	56	1395	2	1388002	\N	1388002	\N	\N	0	1	2	f	0	\N	\N
3516	100	1395	2	1388002	\N	1388002	\N	\N	0	1	2	f	0	\N	\N
3517	8	1395	1	2256395	\N	2256395	\N	\N	1	1	2	f	\N	178	\N
3518	37	1396	2	78371	\N	0	\N	\N	1	1	2	f	78371	\N	\N
3519	60	1396	2	40828	\N	0	\N	\N	2	1	2	f	40828	\N	\N
3520	105	1396	2	550	\N	0	\N	\N	3	1	2	f	550	\N	\N
3521	56	1396	2	40828	\N	0	\N	\N	0	1	2	f	40828	\N	\N
3522	150	1396	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3523	81	1397	2	2829	\N	0	\N	\N	1	1	2	f	2829	\N	\N
3524	120	1397	2	2829	\N	0	\N	\N	0	1	2	f	2829	\N	\N
3525	7	1397	2	2115	\N	0	\N	\N	0	1	2	f	2115	\N	\N
3526	246	1397	2	2115	\N	0	\N	\N	0	1	2	f	2115	\N	\N
3527	253	1398	2	10500	\N	10500	\N	\N	1	1	2	f	0	\N	\N
3528	8	1398	1	10324	\N	10324	\N	\N	1	1	2	f	\N	253	\N
3529	181	1399	2	2913	\N	0	\N	\N	1	1	2	f	2913	\N	\N
3530	56	1399	2	2913	\N	0	\N	\N	0	1	2	f	2913	\N	\N
3531	111	1400	2	567	\N	0	\N	\N	1	1	2	f	567	\N	\N
3532	48	1401	2	171	\N	0	\N	\N	1	1	2	f	171	\N	\N
3533	33	1402	2	4153	\N	4153	\N	\N	1	1	2	f	0	8	\N
3534	8	1402	1	4153	\N	4153	\N	\N	1	1	2	f	\N	33	\N
3535	253	1403	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
3536	81	1403	2	8920	\N	0	\N	\N	2	1	2	f	8920	\N	\N
3537	231	1403	2	6930	\N	0	\N	\N	3	1	2	f	6930	\N	\N
3538	120	1403	2	8920	\N	0	\N	\N	0	1	2	f	8920	\N	\N
3539	7	1403	2	6498	\N	0	\N	\N	0	1	2	f	6498	\N	\N
3540	246	1403	2	6498	\N	0	\N	\N	0	1	2	f	6498	\N	\N
3541	253	1404	2	2951	\N	2951	\N	\N	1	1	2	f	\N	\N	\N
3542	128	1404	2	891	\N	891	\N	\N	2	1	2	f	\N	8	\N
3543	81	1404	2	165	\N	\N	\N	\N	3	1	2	f	165	\N	\N
3544	120	1404	2	165	\N	\N	\N	\N	0	1	2	f	165	\N	\N
3545	7	1404	2	128	\N	\N	\N	\N	0	1	2	f	128	\N	\N
3546	246	1404	2	128	\N	\N	\N	\N	0	1	2	f	128	\N	\N
3547	8	1404	1	3744	\N	3744	\N	\N	1	1	2	f	\N	\N	\N
3548	235	1406	2	2000	\N	0	\N	\N	1	1	2	f	2000	\N	\N
3549	56	1406	2	2000	\N	0	\N	\N	0	1	2	f	2000	\N	\N
3550	125	1407	2	94481	\N	94481	\N	\N	1	1	2	f	0	\N	\N
3551	56	1407	2	69579	\N	69579	\N	\N	0	1	2	f	0	\N	\N
3552	100	1407	2	69579	\N	69579	\N	\N	0	1	2	f	0	\N	\N
3553	8	1407	1	57510	\N	57510	\N	\N	1	1	2	f	\N	125	\N
3554	249	1408	2	84054	\N	0	\N	\N	1	1	2	f	84054	\N	\N
3555	56	1408	2	84054	\N	0	\N	\N	0	1	2	f	84054	\N	\N
3556	100	1408	2	84054	\N	0	\N	\N	0	1	2	f	84054	\N	\N
3557	101	1409	2	25209	\N	25209	\N	\N	1	1	2	f	0	\N	\N
3558	14	1409	2	1	\N	1	\N	\N	0	1	2	f	0	8	\N
3559	8	1409	1	25159	\N	25159	\N	\N	1	1	2	f	\N	101	\N
3560	33	1409	1	6	\N	6	\N	\N	2	1	2	f	\N	101	\N
3561	250	1410	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
3562	253	1411	2	22790	\N	0	\N	\N	1	1	2	f	22790	\N	\N
3563	128	1411	2	11182	\N	0	\N	\N	2	1	2	f	11182	\N	\N
3564	84	1412	2	4831	\N	0	\N	\N	1	1	2	f	4831	\N	\N
3565	56	1412	2	4831	\N	0	\N	\N	0	1	2	f	4831	\N	\N
3566	88	1413	2	935516	\N	935516	\N	\N	1	1	2	f	0	\N	\N
3567	249	1413	1	767469	\N	767469	\N	\N	1	1	2	f	\N	88	\N
3568	56	1413	1	767469	\N	767469	\N	\N	0	1	2	f	\N	88	\N
3569	100	1413	1	767469	\N	767469	\N	\N	0	1	2	f	\N	88	\N
3570	128	1414	2	6051	\N	3284	\N	\N	1	1	2	f	2767	\N	\N
3571	60	1415	2	19505	\N	0	\N	\N	1	1	2	f	19505	\N	\N
3572	56	1415	2	19505	\N	0	\N	\N	0	1	2	f	19505	\N	\N
3573	107	1416	2	1481	\N	0	\N	\N	1	1	2	f	1481	\N	\N
3574	87	1416	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3575	7	1416	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3576	261	1417	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
3577	253	1418	2	7147	\N	7147	\N	\N	1	1	2	f	0	8	\N
3578	8	1418	1	7147	\N	7147	\N	\N	1	1	2	f	\N	253	\N
3579	130	1420	2	470	\N	470	\N	\N	1	1	2	f	0	\N	\N
3580	8	1420	1	457	\N	457	\N	\N	1	1	2	f	\N	130	\N
3581	33	1420	1	5	\N	5	\N	\N	2	1	2	f	\N	130	\N
3582	128	1421	2	4184	\N	0	\N	\N	1	1	2	f	4184	\N	\N
3583	48	1422	2	5053	\N	0	\N	\N	1	1	2	f	5053	\N	\N
3584	29	1423	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
3585	253	1424	2	16584	\N	10583	\N	\N	1	1	2	f	6001	\N	\N
3586	128	1424	2	7187	\N	4433	\N	\N	2	1	2	f	2754	\N	\N
3587	8	1424	1	15016	\N	15016	\N	\N	1	1	2	f	\N	\N	\N
3588	29	1425	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
3589	246	1426	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
3590	7	1426	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
3591	120	1426	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
3592	44	1427	2	6750	\N	0	\N	\N	1	1	2	f	6750	\N	\N
3593	56	1427	2	6745	\N	0	\N	\N	0	1	2	f	6745	\N	\N
3594	82	1428	2	2	\N	2	\N	\N	1	1	2	f	0	78	\N
3595	78	1428	1	2	\N	2	\N	\N	1	1	2	f	\N	82	\N
3596	84	1429	2	2336	\N	0	\N	\N	1	1	2	f	2336	\N	\N
3597	56	1429	2	2336	\N	0	\N	\N	0	1	2	f	2336	\N	\N
3598	128	1430	2	1196	\N	1196	\N	\N	1	1	2	f	0	8	\N
3599	8	1430	1	1196	\N	1196	\N	\N	1	1	2	f	\N	128	\N
3600	48	1431	2	285	\N	0	\N	\N	1	1	2	f	285	\N	\N
3601	180	1432	2	5665	\N	0	\N	\N	1	1	2	f	5665	\N	\N
3602	44	1433	2	1274	\N	0	\N	\N	1	1	2	f	1274	\N	\N
3603	56	1433	2	1274	\N	0	\N	\N	0	1	2	f	1274	\N	\N
3604	81	1434	2	102	\N	0	\N	\N	1	1	2	f	102	\N	\N
3605	120	1434	2	102	\N	0	\N	\N	0	1	2	f	102	\N	\N
3606	7	1434	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
3607	246	1434	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
3608	162	1437	2	506	\N	0	\N	\N	1	1	2	f	506	\N	\N
3609	76	1440	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
3610	105	1440	2	535	\N	0	\N	\N	2	1	2	f	535	\N	\N
3611	150	1440	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
3612	186	1441	2	1141210	\N	1141210	\N	\N	1	1	2	f	0	\N	\N
3613	129	1441	2	169	\N	169	\N	\N	2	1	2	f	0	\N	\N
3614	13	1441	1	949087	\N	949087	\N	\N	1	1	2	f	\N	\N	\N
3615	14	1441	1	1868	\N	1868	\N	\N	2	1	2	f	\N	186	\N
3616	249	1441	1	221	\N	221	\N	\N	3	1	2	f	\N	186	\N
3617	56	1441	1	221	\N	221	\N	\N	0	1	2	f	\N	186	\N
3618	100	1441	1	221	\N	221	\N	\N	0	1	2	f	\N	186	\N
3619	261	1443	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
3620	213	1444	2	246	\N	246	\N	\N	1	1	2	f	0	223	\N
3621	223	1444	1	246	\N	246	\N	\N	1	1	2	f	\N	213	\N
3622	246	1445	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
3623	7	1445	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
3624	120	1445	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
3625	8	1446	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
3626	99	1446	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
3627	201	1447	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
3628	155	1447	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
3629	118	1447	2	561	\N	561	\N	\N	0	1	2	f	0	\N	\N
3630	201	1447	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
3631	118	1447	1	109	\N	109	\N	\N	0	1	2	f	\N	\N	\N
3632	142	1448	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
3633	81	1449	2	114	\N	0	\N	\N	1	1	2	f	114	\N	\N
3634	120	1449	2	114	\N	0	\N	\N	0	1	2	f	114	\N	\N
3635	7	1449	2	83	\N	0	\N	\N	0	1	2	f	83	\N	\N
3636	246	1449	2	83	\N	0	\N	\N	0	1	2	f	83	\N	\N
3637	81	1450	2	811	\N	0	\N	\N	1	1	2	f	811	\N	\N
3638	120	1450	2	811	\N	0	\N	\N	0	1	2	f	811	\N	\N
3639	7	1450	2	609	\N	0	\N	\N	0	1	2	f	609	\N	\N
3640	246	1450	2	609	\N	0	\N	\N	0	1	2	f	609	\N	\N
3641	42	1451	2	25252	\N	25252	\N	\N	1	1	2	f	0	\N	\N
3642	56	1451	2	25252	\N	25252	\N	\N	0	1	2	f	0	\N	\N
3643	77	1452	2	73335	\N	0	\N	\N	1	1	2	f	73335	\N	\N
3644	244	1452	2	24959	\N	0	\N	\N	2	1	2	f	24959	\N	\N
3645	174	1453	2	3814	\N	0	\N	\N	1	1	2	f	3814	\N	\N
3646	259	1454	2	975	\N	975	\N	\N	1	1	2	f	0	161	\N
3647	63	1454	2	615	\N	615	\N	\N	0	1	2	f	0	161	\N
3648	137	1454	2	272	\N	272	\N	\N	0	1	2	f	0	161	\N
3649	138	1454	2	88	\N	88	\N	\N	0	1	2	f	0	161	\N
3650	161	1454	1	975	\N	975	\N	\N	1	1	2	f	\N	259	\N
3651	259	1454	1	975	\N	975	\N	\N	0	1	2	f	\N	259	\N
3652	129	1455	2	110446	\N	110446	\N	\N	1	1	2	f	0	\N	\N
3653	7	1455	2	38	\N	38	\N	\N	0	1	2	f	0	207	\N
3654	207	1455	2	37	\N	37	\N	\N	0	1	2	f	0	129	\N
3655	248	1455	2	25	\N	25	\N	\N	0	1	2	f	0	207	\N
3656	177	1455	2	21	\N	21	\N	\N	0	1	2	f	0	207	\N
3657	12	1455	2	11	\N	11	\N	\N	0	1	2	f	0	207	\N
3658	127	1455	2	11	\N	11	\N	\N	0	1	2	f	0	207	\N
3659	120	1455	2	11	\N	11	\N	\N	0	1	2	f	0	207	\N
3660	246	1455	2	11	\N	11	\N	\N	0	1	2	f	0	207	\N
3661	247	1455	2	2	\N	2	\N	\N	0	1	2	f	0	207	\N
3662	59	1455	2	1	\N	1	\N	\N	0	1	2	f	0	207	\N
3663	252	1455	2	1	\N	1	\N	\N	0	1	2	f	0	207	\N
3664	207	1455	1	109715	\N	109715	\N	\N	1	1	2	f	\N	129	\N
3665	129	1455	1	37	\N	37	\N	\N	0	1	2	f	\N	129	\N
3666	253	1456	2	62850	\N	62850	\N	\N	1	1	2	f	0	\N	\N
3667	128	1456	2	32737	\N	32737	\N	\N	2	1	2	f	0	\N	\N
3668	8	1457	2	221870	\N	0	\N	\N	1	1	2	f	221870	\N	\N
3669	7	1457	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3670	81	1458	2	809	\N	0	\N	\N	1	1	2	f	809	\N	\N
3671	120	1458	2	809	\N	0	\N	\N	0	1	2	f	809	\N	\N
3672	7	1458	2	597	\N	0	\N	\N	0	1	2	f	597	\N	\N
3673	246	1458	2	597	\N	0	\N	\N	0	1	2	f	597	\N	\N
3674	101	1459	2	1865742	\N	1865742	\N	\N	1	1	2	f	0	179	\N
3675	249	1459	2	1782124	\N	1782124	\N	\N	2	1	2	f	0	178	\N
3676	202	1459	2	1470549	\N	1470549	\N	\N	3	1	2	f	0	35	\N
3677	207	1459	2	467607	\N	467607	\N	\N	4	1	2	f	0	\N	\N
3678	174	1459	2	264768	\N	264768	\N	\N	5	1	2	f	0	125	\N
3679	107	1459	2	29802	\N	29802	\N	\N	6	1	2	f	0	\N	\N
3680	103	1459	2	18138	\N	18138	\N	\N	7	1	2	f	0	\N	\N
3681	130	1459	2	13343	\N	13343	\N	\N	8	1	2	f	0	82	\N
3682	13	1459	2	10829	\N	10829	\N	\N	9	1	2	f	0	256	\N
3683	56	1459	2	1782124	\N	1782124	\N	\N	0	1	2	f	0	178	\N
3684	100	1459	2	1782124	\N	1782124	\N	\N	0	1	2	f	0	178	\N
3685	129	1459	2	211531	\N	211531	\N	\N	0	1	2	f	0	\N	\N
3686	14	1459	2	24763	\N	24763	\N	\N	0	1	2	f	0	\N	\N
3687	87	1459	2	20762	\N	20762	\N	\N	0	1	2	f	0	\N	\N
3688	7	1459	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
3689	179	1459	1	1916104	\N	1916104	\N	\N	1	1	2	f	\N	\N	\N
3690	178	1459	1	1846534	\N	1846534	\N	\N	2	1	2	f	\N	\N	\N
3691	35	1459	1	1490291	\N	1490291	\N	\N	3	1	2	f	\N	\N	\N
3692	254	1459	1	478636	\N	478636	\N	\N	4	1	2	f	\N	\N	\N
3693	125	1459	1	266220	\N	266220	\N	\N	5	1	2	f	\N	\N	\N
3694	205	1459	1	222475	\N	222475	\N	\N	6	1	2	f	\N	\N	\N
3695	256	1459	1	37137	\N	37137	\N	\N	7	1	2	f	\N	\N	\N
3696	180	1459	1	29797	\N	29797	\N	\N	8	1	2	f	\N	\N	\N
3697	257	1459	1	27017	\N	27017	\N	\N	9	1	2	f	\N	\N	\N
3698	127	1459	1	25693	\N	25693	\N	\N	10	1	2	f	\N	\N	\N
3699	255	1459	1	22653	\N	22653	\N	\N	11	1	2	f	\N	\N	\N
3700	12	1459	1	18110	\N	18110	\N	\N	12	1	2	f	\N	\N	\N
3701	82	1459	1	13666	\N	13666	\N	\N	13	1	2	f	\N	\N	\N
3702	208	1459	1	1536	\N	1536	\N	\N	14	1	2	f	\N	\N	\N
3703	124	1459	1	1512	\N	1512	\N	\N	15	1	2	f	\N	\N	\N
3704	126	1459	1	935	\N	935	\N	\N	16	1	2	f	\N	\N	\N
3705	176	1459	1	61	\N	61	\N	\N	17	1	2	f	\N	\N	\N
3706	56	1459	1	1809636	\N	1809636	\N	\N	0	1	2	f	\N	\N	\N
3707	100	1459	1	1809636	\N	1809636	\N	\N	0	1	2	f	\N	\N	\N
3708	129	1459	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
3709	33	1460	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
3710	74	1461	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
3711	190	1461	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
3712	221	1461	2	1512	\N	1512	\N	\N	3	1	2	f	0	52	\N
3713	52	1461	1	4536	\N	4536	\N	\N	1	1	2	f	\N	\N	\N
3714	234	1462	2	26913	\N	0	\N	\N	1	1	2	f	26913	\N	\N
3715	56	1462	2	26913	\N	0	\N	\N	0	1	2	f	26913	\N	\N
3716	44	1463	2	9510	\N	9510	\N	\N	1	1	2	f	0	\N	\N
3717	56	1463	2	9473	\N	9473	\N	\N	0	1	2	f	0	\N	\N
3718	210	1464	2	30099	\N	0	\N	\N	1	1	2	f	30099	\N	\N
3719	74	1465	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
3720	190	1465	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
3721	52	1465	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
3722	128	1466	2	3466	\N	0	\N	\N	1	1	2	f	3466	\N	\N
3723	129	1467	2	331	\N	0	\N	\N	1	1	2	f	331	\N	\N
3724	165	1468	2	91	\N	0	\N	\N	1	1	2	f	91	\N	\N
3725	23	1473	2	75	\N	75	\N	\N	1	1	2	f	0	\N	\N
3726	92	1475	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
3727	145	1476	2	1870403	\N	0	\N	\N	1	1	2	f	1870400	\N	\N
3728	248	1477	2	230240	\N	0	\N	\N	1	1	2	f	230240	\N	\N
3729	7	1477	2	230059	\N	0	\N	\N	0	1	2	f	230059	\N	\N
3730	247	1477	2	183394	\N	0	\N	\N	0	1	2	f	183394	\N	\N
3731	129	1477	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
3732	87	1477	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
3733	14	1477	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
3734	120	1477	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
3735	103	1477	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
3736	246	1477	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3737	48	1478	2	568	\N	0	\N	\N	1	1	2	f	568	\N	\N
3738	253	1479	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
3739	258	1480	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
3740	56	1480	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
3741	258	1480	1	3	\N	3	\N	\N	1	1	2	f	\N	258	\N
3742	56	1480	1	3	\N	3	\N	\N	0	1	2	f	\N	258	\N
3743	253	1481	2	4822	\N	0	\N	\N	1	1	2	f	4822	\N	\N
3744	128	1481	2	2153	\N	0	\N	\N	2	1	2	f	2153	\N	\N
3745	101	1482	2	27665	\N	0	\N	\N	1	1	2	f	27665	\N	\N
3746	237	1483	2	70822	\N	70822	\N	\N	1	1	2	f	0	\N	\N
3747	35	1484	2	743080	\N	743080	\N	\N	1	1	2	f	0	\N	\N
3748	255	1484	2	14526	\N	14526	\N	\N	2	1	2	f	0	\N	\N
3749	249	1484	1	226012	\N	226012	\N	\N	1	1	2	f	\N	35	\N
3750	202	1484	1	27482	\N	27482	\N	\N	2	1	2	f	\N	35	\N
3751	56	1484	1	226012	\N	226012	\N	\N	0	1	2	f	\N	35	\N
3752	100	1484	1	226012	\N	226012	\N	\N	0	1	2	f	\N	35	\N
3753	29	1485	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
3754	156	1486	2	411027	\N	0	\N	\N	1	1	2	f	411027	\N	\N
3755	246	1487	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
3756	7	1487	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
3757	120	1487	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
3758	145	1488	2	1961457	\N	1961457	\N	\N	1	1	2	f	0	\N	\N
3759	224	1488	1	1961437	\N	1961437	\N	\N	1	1	2	f	\N	\N	\N
3760	246	1489	2	258	\N	258	\N	\N	1	1	2	f	0	212	\N
3761	7	1489	2	258	\N	258	\N	\N	0	1	2	f	0	212	\N
3762	120	1489	2	253	\N	253	\N	\N	0	1	2	f	0	212	\N
3763	212	1489	1	258	\N	258	\N	\N	1	1	2	f	\N	246	\N
3764	198	1490	2	750	\N	0	\N	\N	1	1	2	f	750	\N	\N
3765	235	1492	2	32485	\N	0	\N	\N	1	1	2	f	32485	\N	\N
3766	56	1492	2	32485	\N	0	\N	\N	0	1	2	f	32485	\N	\N
3767	172	1494	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
3768	81	1495	2	1927	\N	0	\N	\N	1	1	2	f	1927	\N	\N
3769	253	1495	2	321	\N	0	\N	\N	2	1	2	f	321	\N	\N
3770	120	1495	2	1927	\N	0	\N	\N	0	1	2	f	1927	\N	\N
3771	7	1495	2	1438	\N	0	\N	\N	0	1	2	f	1438	\N	\N
3772	246	1495	2	1438	\N	0	\N	\N	0	1	2	f	1438	\N	\N
3773	58	1497	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
3774	120	1497	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3775	7	1497	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3776	246	1497	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
3777	56	1498	2	1989253	\N	0	\N	\N	1	1	2	f	1989253	\N	\N
3778	100	1498	2	1812561	\N	0	\N	\N	0	1	2	f	1812561	\N	\N
3779	178	1498	2	1583248	\N	0	\N	\N	0	1	2	f	1583248	\N	\N
3780	125	1498	2	226388	\N	0	\N	\N	0	1	2	f	226388	\N	\N
3781	84	1498	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
3782	235	1498	2	35694	\N	0	\N	\N	0	1	2	f	35694	\N	\N
3783	181	1498	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
3784	234	1498	2	33661	\N	0	\N	\N	0	1	2	f	33661	\N	\N
3785	42	1498	2	25252	\N	0	\N	\N	0	1	2	f	25252	\N	\N
3786	44	1498	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
3787	249	1498	2	1310	\N	0	\N	\N	0	1	2	f	1310	\N	\N
3788	258	1498	2	253	\N	0	\N	\N	0	1	2	f	253	\N	\N
3789	8	1499	2	162	\N	20	\N	\N	1	1	2	f	142	\N	\N
3790	8	1499	1	20	\N	20	\N	\N	1	1	2	f	\N	8	\N
3791	246	1500	2	523576	\N	0	\N	\N	1	1	2	f	523576	\N	\N
3792	7	1500	2	523477	\N	0	\N	\N	0	1	2	f	523477	\N	\N
3793	120	1500	2	156247	\N	0	\N	\N	0	1	2	f	156247	\N	\N
3794	247	1500	2	147972	\N	0	\N	\N	0	1	2	f	147972	\N	\N
3795	231	1500	2	3865	\N	0	\N	\N	0	1	2	f	3865	\N	\N
3796	57	1500	2	3454	\N	0	\N	\N	0	1	2	f	3454	\N	\N
3797	123	1500	2	2850	\N	0	\N	\N	0	1	2	f	2850	\N	\N
3798	11	1500	2	1675	\N	0	\N	\N	0	1	2	f	1675	\N	\N
3799	232	1500	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
3800	34	1500	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3801	58	1500	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3802	81	1500	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
3803	204	1500	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
3804	211	1500	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
3805	129	1500	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
3806	248	1500	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3807	58	1501	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
3808	120	1501	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
3809	7	1501	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
3810	246	1501	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
3811	151	1502	2	19518	\N	0	\N	\N	1	1	2	f	19518	\N	\N
3812	154	1503	2	69	\N	0	\N	\N	1	1	2	f	69	\N	\N
3813	253	1504	2	11989	\N	0	\N	\N	1	1	2	f	11989	\N	\N
3814	81	1504	2	5281	\N	0	\N	\N	2	1	2	f	5281	\N	\N
3815	120	1504	2	5281	\N	0	\N	\N	0	1	2	f	5281	\N	\N
3816	7	1504	2	3999	\N	0	\N	\N	0	1	2	f	3999	\N	\N
3817	246	1504	2	3999	\N	0	\N	\N	0	1	2	f	3999	\N	\N
3818	250	1505	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
3819	94	1505	1	8	\N	8	\N	\N	1	1	2	f	\N	250	\N
3820	128	1506	2	1376	\N	1376	\N	\N	1	1	2	f	0	8	\N
3821	8	1506	1	1376	\N	1376	\N	\N	1	1	2	f	\N	128	\N
3822	174	1507	2	1750	\N	0	\N	\N	1	1	2	f	1750	\N	\N
3823	235	1508	2	7456	\N	0	\N	\N	1	1	2	f	7456	\N	\N
3824	56	1508	2	7456	\N	0	\N	\N	0	1	2	f	7456	\N	\N
3825	180	1509	2	301267	\N	301267	\N	\N	1	1	2	f	0	53	\N
3826	208	1509	2	3079	\N	3079	\N	\N	2	1	2	f	0	53	\N
3827	53	1509	1	304346	\N	304346	\N	\N	1	1	2	f	\N	\N	\N
3828	101	1510	2	1761	\N	0	\N	\N	1	1	2	f	1761	\N	\N
3829	225	1511	2	956051	\N	956051	\N	\N	1	1	2	f	0	\N	\N
3830	8	1511	1	954053	\N	954053	\N	\N	1	1	2	f	\N	225	\N
3831	79	1512	2	51956	\N	51956	\N	\N	1	1	2	f	0	\N	\N
3832	8	1512	1	51860	\N	51860	\N	\N	1	1	2	f	\N	79	\N
3833	33	1512	1	81	\N	81	\N	\N	2	1	2	f	\N	79	\N
3834	253	1513	2	7726	\N	0	\N	\N	1	1	2	f	7726	\N	\N
3835	128	1513	2	3063	\N	0	\N	\N	2	1	2	f	3063	\N	\N
3836	48	1514	2	1153	\N	0	\N	\N	1	1	2	f	1153	\N	\N
3837	12	1516	2	17347	\N	0	\N	\N	1	1	2	f	17347	\N	\N
3838	238	1516	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
3839	129	1516	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
3840	108	1517	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
3841	8	1518	2	1194	\N	0	\N	\N	1	1	2	f	1194	\N	\N
3842	181	1519	2	3700	\N	0	\N	\N	1	1	2	f	3700	\N	\N
3843	56	1519	2	3700	\N	0	\N	\N	0	1	2	f	3700	\N	\N
3844	260	1521	2	28	\N	0	\N	\N	1	1	2	f	28	\N	\N
3845	204	1523	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
3846	120	1523	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
3847	7	1523	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
3848	246	1523	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
3849	202	1524	2	37618	\N	0	\N	\N	1	1	2	f	37618	\N	\N
3850	246	1525	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
3851	7	1525	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
3852	120	1525	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
3853	47	1526	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3854	163	1526	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
3855	44	1527	2	3435	\N	0	\N	\N	1	1	2	f	3435	\N	\N
3856	56	1527	2	3430	\N	0	\N	\N	0	1	2	f	3430	\N	\N
3857	213	1528	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
3858	215	1529	2	213	\N	213	\N	\N	1	1	2	f	0	\N	\N
3859	253	1530	2	16456	\N	0	\N	\N	1	1	2	f	16456	\N	\N
3860	128	1530	2	7152	\N	0	\N	\N	2	1	2	f	7152	\N	\N
3861	81	1530	2	6162	\N	0	\N	\N	3	1	2	f	6162	\N	\N
3862	120	1530	2	6162	\N	0	\N	\N	0	1	2	f	6162	\N	\N
3863	7	1530	2	4654	\N	0	\N	\N	0	1	2	f	4654	\N	\N
3864	246	1530	2	4654	\N	0	\N	\N	0	1	2	f	4654	\N	\N
3865	21	1531	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
3866	29	1532	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
3867	58	1533	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
3868	120	1533	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
3869	7	1533	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3870	246	1533	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
3871	249	1535	2	74474	\N	74474	\N	\N	1	1	2	f	0	\N	\N
3872	13	1535	2	1285	\N	1285	\N	\N	2	1	2	f	0	\N	\N
3873	56	1535	2	74474	\N	74474	\N	\N	0	1	2	f	0	\N	\N
3874	100	1535	2	74474	\N	74474	\N	\N	0	1	2	f	0	\N	\N
3875	8	1535	1	4969	\N	4969	\N	\N	1	1	2	f	\N	\N	\N
3876	35	1536	2	1499269	\N	0	\N	\N	1	1	2	f	1499269	\N	\N
3877	253	1537	2	61841	\N	61841	\N	\N	1	1	2	f	0	\N	\N
3878	128	1537	2	32895	\N	32895	\N	\N	2	1	2	f	0	\N	\N
3879	12	1538	2	6850943	\N	6850943	\N	\N	1	1	2	f	0	\N	\N
3880	238	1538	2	58	\N	58	\N	\N	0	1	2	f	0	125	\N
3881	129	1538	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
3882	101	1538	1	1775203	\N	1775203	\N	\N	1	1	2	f	\N	12	\N
3883	100	1538	1	1687088	\N	1687088	\N	\N	2	1	2	f	\N	12	\N
3884	202	1538	1	1325521	\N	1325521	\N	\N	3	1	2	f	\N	12	\N
3885	207	1538	1	386588	\N	386588	\N	\N	4	1	2	f	\N	12	\N
3886	174	1538	1	247525	\N	247525	\N	\N	5	1	2	f	\N	12	\N
3887	35	1538	1	59151	\N	59151	\N	\N	6	1	2	f	\N	12	\N
3888	179	1538	1	47677	\N	47677	\N	\N	7	1	2	f	\N	12	\N
3889	107	1538	1	26980	\N	26980	\N	\N	8	1	2	f	\N	12	\N
3890	36	1538	1	19739	\N	19739	\N	\N	9	1	2	f	\N	12	\N
3891	254	1538	1	18254	\N	18254	\N	\N	10	1	2	f	\N	12	\N
3892	130	1538	1	12525	\N	12525	\N	\N	11	1	2	f	\N	12	\N
3893	205	1538	1	9408	\N	9408	\N	\N	12	1	2	f	\N	12	\N
3894	13	1538	1	9196	\N	9196	\N	\N	13	1	2	f	\N	12	\N
3895	180	1538	1	1889	\N	1889	\N	\N	14	1	2	f	\N	12	\N
3896	257	1538	1	576	\N	576	\N	\N	15	1	2	f	\N	12	\N
3897	256	1538	1	576	\N	576	\N	\N	16	1	2	f	\N	12	\N
3898	82	1538	1	531	\N	531	\N	\N	17	1	2	f	\N	12	\N
3899	176	1538	1	101	\N	101	\N	\N	18	1	2	f	\N	12	\N
3900	255	1538	1	47	\N	47	\N	\N	19	1	2	f	\N	12	\N
3901	103	1538	1	1	\N	1	\N	\N	20	1	2	f	\N	12	\N
3902	56	1538	1	1687088	\N	1687088	\N	\N	0	1	2	f	\N	12	\N
3903	249	1538	1	1672015	\N	1672015	\N	\N	0	1	2	f	\N	12	\N
3904	129	1538	1	186733	\N	186733	\N	\N	0	1	2	f	\N	12	\N
3905	178	1538	1	55946	\N	55946	\N	\N	0	1	2	f	\N	12	\N
3906	14	1538	1	22546	\N	22546	\N	\N	0	1	2	f	\N	12	\N
3907	87	1538	1	22025	\N	22025	\N	\N	0	1	2	f	\N	12	\N
3908	125	1538	1	7408	\N	7408	\N	\N	0	1	2	f	\N	\N	\N
3909	7	1538	1	64	\N	64	\N	\N	0	1	2	f	\N	12	\N
3910	128	1539	2	2543	\N	0	\N	\N	1	1	2	f	2543	\N	\N
3911	88	1540	2	935591	\N	935591	\N	\N	1	1	2	f	0	8	\N
3912	8	1540	1	935591	\N	935591	\N	\N	1	1	2	f	\N	88	\N
3913	48	1541	2	1085	\N	0	\N	\N	1	1	2	f	1085	\N	\N
3914	45	1542	2	13546	\N	0	\N	\N	1	1	2	f	13546	\N	\N
3915	258	1544	2	36	\N	36	\N	\N	1	1	2	f	0	258	\N
3916	56	1544	2	24	\N	24	\N	\N	0	1	2	f	0	258	\N
3917	258	1544	1	28	\N	28	\N	\N	1	1	2	f	\N	258	\N
3918	56	1544	1	28	\N	28	\N	\N	0	1	2	f	\N	258	\N
3919	239	1545	2	840	\N	0	\N	\N	1	1	2	f	840	\N	\N
3920	99	1545	2	840	\N	0	\N	\N	0	1	2	f	840	\N	\N
3921	81	1546	2	7848	\N	0	\N	\N	1	1	2	f	7848	\N	\N
3922	231	1546	2	5079	\N	0	\N	\N	2	1	2	f	5079	\N	\N
3923	120	1546	2	7848	\N	0	\N	\N	0	1	2	f	7848	\N	\N
3924	7	1546	2	5679	\N	0	\N	\N	0	1	2	f	5679	\N	\N
3925	246	1546	2	5679	\N	0	\N	\N	0	1	2	f	5679	\N	\N
3926	209	1547	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
3927	258	1549	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
3928	56	1549	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3929	78	1550	2	1961437	\N	1961437	\N	\N	1	1	2	f	0	145	\N
3930	145	1550	1	1961456	\N	1961456	\N	\N	1	1	2	f	\N	\N	\N
3931	124	1551	2	1512	\N	1512	\N	\N	1	1	2	f	0	74	\N
3932	74	1551	1	1512	\N	1512	\N	\N	1	1	2	f	\N	124	\N
3933	37	1552	2	145250	\N	0	\N	\N	1	1	2	f	145250	\N	\N
3934	29	1553	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
3935	234	1554	2	19765	\N	0	\N	\N	1	1	2	f	19765	\N	\N
3936	56	1554	2	19765	\N	0	\N	\N	0	1	2	f	19765	\N	\N
3937	128	1555	2	70	\N	0	\N	\N	1	1	2	f	70	\N	\N
3938	33	1556	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
3939	15	1557	2	49	\N	0	\N	\N	1	1	2	f	49	\N	\N
3940	7	1557	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3941	8	1558	2	133659	\N	132553	\N	\N	1	1	2	f	1106	\N	\N
3942	8	1558	1	128996	\N	128996	\N	\N	1	1	2	f	\N	8	\N
3943	129	1559	2	32850	\N	32850	\N	\N	1	1	2	f	0	166	\N
3944	7	1559	2	29	\N	29	\N	\N	0	1	2	f	0	166	\N
3945	248	1559	2	25	\N	25	\N	\N	0	1	2	f	0	166	\N
3946	177	1559	2	7	\N	7	\N	\N	0	1	2	f	0	166	\N
3947	12	1559	2	3	\N	3	\N	\N	0	1	2	f	0	166	\N
3948	127	1559	2	3	\N	3	\N	\N	0	1	2	f	0	166	\N
3949	120	1559	2	3	\N	3	\N	\N	0	1	2	f	0	166	\N
3950	246	1559	2	3	\N	3	\N	\N	0	1	2	f	0	166	\N
3951	247	1559	2	2	\N	2	\N	\N	0	1	2	f	0	166	\N
3952	252	1559	2	1	\N	1	\N	\N	0	1	2	f	0	166	\N
3953	166	1559	1	32850	\N	32850	\N	\N	1	1	2	f	\N	129	\N
3954	97	1560	2	6064	\N	6064	\N	\N	1	1	2	f	0	\N	\N
3955	229	1560	2	1789	\N	1789	\N	\N	0	1	2	f	0	\N	\N
3956	122	1560	2	15	\N	15	\N	\N	0	1	2	f	0	122	\N
3957	119	1560	2	10	\N	10	\N	\N	0	1	2	f	0	119	\N
3958	9	1560	2	6	\N	6	\N	\N	0	1	2	f	0	97	\N
3959	230	1560	2	3	\N	3	\N	\N	0	1	2	f	0	122	\N
3960	32	1560	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
3961	97	1560	1	320	\N	320	\N	\N	1	1	2	f	\N	\N	\N
3962	119	1560	1	32	\N	32	\N	\N	0	1	2	f	\N	97	\N
3963	122	1560	1	17	\N	17	\N	\N	0	1	2	f	\N	97	\N
3964	9	1560	1	2	\N	2	\N	\N	0	1	2	f	\N	9	\N
3965	230	1560	1	2	\N	2	\N	\N	0	1	2	f	\N	122	\N
3966	229	1560	1	2	\N	2	\N	\N	0	1	2	f	\N	97	\N
3967	208	1561	2	1496	\N	0	\N	\N	1	1	2	f	1496	\N	\N
3968	15	1563	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
3969	7	1564	2	179519	\N	179519	\N	\N	1	1	2	f	0	\N	\N
3970	246	1564	2	179368	\N	179368	\N	\N	0	1	2	f	0	\N	\N
3971	120	1564	2	168939	\N	168939	\N	\N	0	1	2	f	0	\N	\N
3972	231	1564	2	8076	\N	8076	\N	\N	0	1	2	f	0	\N	\N
3973	11	1564	2	3449	\N	3449	\N	\N	0	1	2	f	0	\N	\N
3974	247	1564	2	170	\N	170	\N	\N	0	1	2	f	0	\N	\N
3975	34	1564	2	120	\N	120	\N	\N	0	1	2	f	0	\N	\N
3976	58	1564	2	113	\N	113	\N	\N	0	1	2	f	0	\N	\N
3977	123	1564	2	73	\N	73	\N	\N	0	1	2	f	0	\N	\N
3978	81	1564	2	72	\N	72	\N	\N	0	1	2	f	0	\N	\N
3979	211	1564	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
3980	204	1564	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
3981	252	1564	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
3982	129	1564	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
3983	248	1564	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
3984	120	1564	1	2	\N	2	\N	\N	1	1	2	f	\N	246	\N
3985	7	1564	1	2	\N	2	\N	\N	0	1	2	f	\N	246	\N
3986	246	1564	1	2	\N	2	\N	\N	0	1	2	f	\N	246	\N
3987	47	1565	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
3988	163	1565	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
3989	102	1566	2	230368	\N	230368	\N	\N	1	1	2	f	0	248	\N
3990	7	1566	2	230229	\N	230229	\N	\N	0	1	2	f	0	248	\N
3991	247	1566	2	32	\N	32	\N	\N	0	1	2	f	0	248	\N
3992	248	1566	1	230242	\N	230242	\N	\N	1	1	2	f	\N	\N	\N
3993	7	1566	1	230061	\N	230061	\N	\N	0	1	2	f	\N	\N	\N
3994	247	1566	1	183394	\N	183394	\N	\N	0	1	2	f	\N	102	\N
3995	129	1566	1	25	\N	25	\N	\N	0	1	2	f	\N	102	\N
3996	87	1566	1	7	\N	7	\N	\N	0	1	2	f	\N	102	\N
3997	14	1566	1	6	\N	6	\N	\N	0	1	2	f	\N	102	\N
3998	120	1566	1	3	\N	3	\N	\N	0	1	2	f	\N	102	\N
3999	103	1566	1	2	\N	2	\N	\N	0	1	2	f	\N	102	\N
4000	246	1566	1	1	\N	1	\N	\N	0	1	2	f	\N	102	\N
4001	47	1567	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
4002	163	1567	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4003	8	1568	2	398	\N	0	\N	\N	1	1	2	f	398	\N	\N
4004	119	1568	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
4005	201	1568	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
4006	97	1568	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4007	69	1569	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
4008	253	1570	2	16425	\N	0	\N	\N	1	1	2	f	16425	\N	\N
4009	81	1570	2	678	\N	0	\N	\N	2	1	2	f	678	\N	\N
4010	120	1570	2	678	\N	0	\N	\N	0	1	2	f	678	\N	\N
4011	7	1570	2	499	\N	0	\N	\N	0	1	2	f	499	\N	\N
4012	246	1570	2	499	\N	0	\N	\N	0	1	2	f	499	\N	\N
4013	60	1571	2	4592	\N	0	\N	\N	1	1	2	f	4592	\N	\N
4014	76	1571	2	2403	\N	0	\N	\N	2	1	2	f	2403	\N	\N
4015	105	1571	2	533	\N	0	\N	\N	3	1	2	f	533	\N	\N
4016	56	1571	2	4592	\N	0	\N	\N	0	1	2	f	4592	\N	\N
4017	150	1571	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
4018	49	1572	2	472	\N	0	\N	\N	1	1	2	f	472	\N	\N
4019	253	1573	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
4020	128	1573	2	2767	\N	0	\N	\N	2	1	2	f	2767	\N	\N
4021	214	1574	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
4022	10	1574	2	66	\N	0	\N	\N	0	1	2	f	66	\N	\N
4023	8	1575	1	34708	\N	34708	\N	\N	1	1	2	f	\N	\N	\N
4024	7	1576	2	54	\N	0	\N	\N	1	1	2	f	54	\N	\N
4025	102	1576	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
4026	172	1576	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
4027	248	1576	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4028	268	1577	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
4029	253	1578	2	13597	\N	7340	\N	\N	1	1	2	f	6257	\N	\N
4030	128	1578	2	5237	\N	2470	\N	\N	2	1	2	f	2767	\N	\N
4031	81	1579	2	121	\N	0	\N	\N	1	1	2	f	121	\N	\N
4032	120	1579	2	121	\N	0	\N	\N	0	1	2	f	121	\N	\N
4033	7	1579	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
4034	246	1579	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
4035	29	1581	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
4036	127	1583	2	31132	\N	31132	\N	\N	1	1	2	f	0	8	\N
4037	129	1583	2	18	\N	18	\N	\N	0	1	2	f	0	8	\N
4038	8	1583	1	31132	\N	31132	\N	\N	1	1	2	f	\N	127	\N
4039	181	1584	2	18566	\N	0	\N	\N	1	1	2	f	18566	\N	\N
4040	56	1584	2	18566	\N	0	\N	\N	0	1	2	f	18566	\N	\N
4041	29	1585	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
4042	128	1586	2	7149	\N	0	\N	\N	1	1	2	f	7149	\N	\N
4043	107	1587	2	2241	\N	0	\N	\N	1	1	2	f	2241	\N	\N
4044	87	1587	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4045	7	1587	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4046	69	1588	1	208	\N	208	\N	\N	1	1	2	f	\N	\N	\N
4047	159	1589	2	225	\N	0	\N	\N	1	1	2	f	225	\N	\N
4048	111	1590	2	565	\N	0	\N	\N	1	1	2	f	565	\N	\N
4049	206	1591	2	18633	\N	0	\N	\N	1	1	2	f	18633	\N	\N
4050	67	1591	2	41	\N	0	\N	\N	2	1	2	f	41	\N	\N
4051	180	1594	2	27973	\N	27973	\N	\N	1	1	2	f	0	59	\N
4052	59	1594	1	27973	\N	27973	\N	\N	1	1	2	f	\N	180	\N
4053	19	1595	2	202	\N	202	\N	\N	1	1	2	f	0	\N	\N
4054	133	1595	2	202	\N	202	\N	\N	2	1	2	f	0	38	\N
4055	38	1595	1	403	\N	403	\N	\N	1	1	2	f	\N	\N	\N
4056	39	1595	1	1	\N	1	\N	\N	2	1	2	f	\N	19	\N
4057	8	1595	1	403	\N	403	\N	\N	0	1	2	f	\N	\N	\N
4058	99	1595	1	1	\N	1	\N	\N	0	1	2	f	\N	19	\N
4059	8	1596	2	163	\N	31	\N	\N	1	1	2	f	132	\N	\N
4060	7	1596	2	2	\N	2	\N	\N	0	1	2	f	\N	8	\N
4061	8	1596	1	31	\N	31	\N	\N	1	1	2	f	\N	8	\N
4062	228	1597	2	2	\N	2	\N	\N	1	1	2	f	0	31	\N
4063	31	1597	1	2	\N	2	\N	\N	1	1	2	f	\N	228	\N
4064	83	1598	2	5455	\N	0	\N	\N	1	1	2	f	5455	\N	\N
4065	111	1599	2	1221	\N	0	\N	\N	1	1	2	f	1221	\N	\N
4066	83	1600	2	3772	\N	0	\N	\N	1	1	2	f	3772	\N	\N
4067	37	1600	2	694	\N	0	\N	\N	2	1	2	f	694	\N	\N
4068	196	1601	2	14029	\N	14029	\N	\N	1	1	2	f	0	\N	\N
4069	8	1601	1	12928	\N	12928	\N	\N	1	1	2	f	\N	196	\N
4070	33	1601	1	1	\N	1	\N	\N	2	1	2	f	\N	196	\N
4071	58	1602	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
4072	120	1602	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
4073	7	1602	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
4074	246	1602	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
4075	174	1603	2	3966	\N	0	\N	\N	1	1	2	f	3966	\N	\N
4076	127	1604	2	25693	\N	25693	\N	\N	1	1	2	f	0	52	\N
4077	129	1604	2	11	\N	11	\N	\N	0	1	2	f	0	52	\N
4078	52	1604	1	25693	\N	25693	\N	\N	1	1	2	f	\N	127	\N
4079	106	1605	2	244983	\N	244983	\N	\N	1	1	2	f	0	\N	\N
4080	128	1606	2	7096	\N	4430	\N	\N	1	1	2	f	2666	\N	\N
4081	8	1606	1	4430	\N	4430	\N	\N	1	1	2	f	\N	128	\N
4082	107	1607	2	1635	\N	0	\N	\N	1	1	2	f	1635	\N	\N
4083	87	1607	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4084	7	1607	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4085	7	1608	2	2856113	\N	2856113	\N	\N	1	1	2	f	\N	7	\N
4086	56	1608	2	79190	\N	79190	\N	\N	2	1	2	f	\N	56	\N
4087	91	1608	2	16	\N	16	\N	\N	3	1	2	f	\N	91	\N
4088	246	1608	2	2853924	\N	2853924	\N	\N	0	1	2	f	\N	7	\N
4089	120	1608	2	2853921	\N	2853921	\N	\N	0	1	2	f	\N	7	\N
4090	235	1608	2	40521	\N	40521	\N	\N	0	1	2	f	\N	235	\N
4091	181	1608	2	38669	\N	38669	\N	\N	0	1	2	f	\N	181	\N
4092	8	1608	2	9358	\N	526	\N	\N	0	1	2	f	8832	\N	\N
4093	129	1608	2	1688	\N	1688	\N	\N	0	1	2	f	\N	120	\N
4094	7	1608	1	2854237	\N	2854237	\N	\N	1	1	2	f	\N	7	\N
4095	56	1608	1	79190	\N	79190	\N	\N	2	1	2	f	\N	56	\N
4096	91	1608	1	16	\N	16	\N	\N	3	1	2	f	\N	91	\N
4097	246	1608	1	2853933	\N	2853933	\N	\N	0	1	2	f	\N	7	\N
4098	120	1608	1	2853915	\N	2853915	\N	\N	0	1	2	f	\N	7	\N
4099	235	1608	1	40521	\N	40521	\N	\N	0	1	2	f	\N	235	\N
4100	181	1608	1	38669	\N	38669	\N	\N	0	1	2	f	\N	181	\N
4101	129	1608	1	1060	\N	1060	\N	\N	0	1	2	f	\N	7	\N
4102	8	1608	1	525	\N	525	\N	\N	0	1	2	f	\N	8	\N
4103	247	1608	1	6	\N	6	\N	\N	0	1	2	f	\N	120	\N
4104	246	1609	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
4105	7	1609	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
4106	120	1609	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
4107	128	1610	2	867	\N	867	\N	\N	1	1	2	f	0	8	\N
4108	8	1610	1	867	\N	867	\N	\N	1	1	2	f	\N	128	\N
4109	234	1611	2	30512	\N	0	\N	\N	1	1	2	f	30512	\N	\N
4110	56	1611	2	30511	\N	0	\N	\N	0	1	2	f	30511	\N	\N
4111	235	1612	2	13358	\N	0	\N	\N	1	1	2	f	13358	\N	\N
4112	56	1612	2	13358	\N	0	\N	\N	0	1	2	f	13358	\N	\N
4113	151	1613	2	234	\N	234	\N	\N	1	1	2	f	0	115	\N
4114	115	1613	1	234	\N	234	\N	\N	1	1	2	f	\N	151	\N
4115	234	1614	2	33925	\N	0	\N	\N	1	1	2	f	33925	\N	\N
4116	56	1614	2	33924	\N	0	\N	\N	0	1	2	f	33924	\N	\N
4117	75	1615	2	4411	\N	0	\N	\N	1	1	2	f	4411	\N	\N
4118	209	1616	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
4119	69	1617	2	87	\N	0	\N	\N	1	1	2	f	87	\N	\N
4120	42	1618	2	24222	\N	24222	\N	\N	1	1	2	f	0	\N	\N
4121	56	1618	2	24222	\N	24222	\N	\N	0	1	2	f	0	\N	\N
4122	108	1619	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
4123	44	1620	2	10358	\N	0	\N	\N	1	1	2	f	10358	\N	\N
4124	56	1620	2	10285	\N	0	\N	\N	0	1	2	f	10285	\N	\N
4125	7	1621	2	708987	\N	0	\N	\N	1	1	2	f	708987	\N	\N
4126	85	1621	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
4127	98	1621	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
4128	121	1621	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
4129	47	1621	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
4130	251	1621	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
4131	153	1621	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
4132	246	1621	2	480116	\N	0	\N	\N	0	1	2	f	480116	\N	\N
4133	247	1621	2	386153	\N	0	\N	\N	0	1	2	f	386153	\N	\N
4134	248	1621	2	198192	\N	0	\N	\N	0	1	2	f	198192	\N	\N
4135	120	1621	2	161880	\N	0	\N	\N	0	1	2	f	161880	\N	\N
4136	252	1621	2	30474	\N	0	\N	\N	0	1	2	f	30474	\N	\N
4137	231	1621	2	4211	\N	0	\N	\N	0	1	2	f	4211	\N	\N
4138	57	1621	2	3821	\N	0	\N	\N	0	1	2	f	3821	\N	\N
4139	123	1621	2	2873	\N	0	\N	\N	0	1	2	f	2873	\N	\N
4140	11	1621	2	1774	\N	0	\N	\N	0	1	2	f	1774	\N	\N
4141	102	1621	2	230	\N	0	\N	\N	0	1	2	f	230	\N	\N
4142	232	1621	2	134	\N	0	\N	\N	0	1	2	f	134	\N	\N
4143	34	1621	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
4144	58	1621	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
4145	81	1621	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
4146	211	1621	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
4147	129	1621	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
4148	204	1621	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
4149	107	1621	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4150	172	1621	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
4151	87	1621	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
4152	14	1621	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4153	103	1621	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4154	163	1621	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4155	253	1622	2	384	\N	0	\N	\N	1	1	2	f	384	\N	\N
4156	128	1622	2	225	\N	0	\N	\N	2	1	2	f	225	\N	\N
4157	204	1624	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
4158	120	1624	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
4159	7	1624	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
4160	246	1624	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
4161	112	1625	2	6719312	\N	6719312	\N	\N	1	1	2	f	0	8	\N
4162	28	1625	2	630215	\N	630215	\N	\N	2	1	2	f	0	8	\N
4163	13	1625	2	1300	\N	1300	\N	\N	3	1	2	f	0	8	\N
4164	113	1625	2	411336	\N	411336	\N	\N	0	1	2	f	0	8	\N
4165	8	1625	1	10365772	\N	10365772	\N	\N	1	1	2	f	\N	\N	\N
4166	228	1626	2	2	\N	2	\N	\N	1	1	2	f	0	31	\N
4167	31	1626	1	2	\N	2	\N	\N	1	1	2	f	\N	228	\N
4168	193	1627	2	1877847	\N	1877797	\N	\N	1	1	2	f	50	8	\N
4169	8	1627	1	1866497	\N	1866497	\N	\N	1	1	2	f	\N	\N	\N
4170	33	1627	1	201	\N	201	\N	\N	0	1	2	f	\N	193	\N
4171	207	1628	2	167807	\N	0	\N	\N	1	1	2	f	167807	\N	\N
4172	202	1628	2	71620	\N	0	\N	\N	2	1	2	f	71620	\N	\N
4173	249	1628	2	70439	\N	0	\N	\N	3	1	2	f	70439	\N	\N
4174	101	1628	2	61237	\N	0	\N	\N	4	1	2	f	61237	\N	\N
4175	174	1628	2	9045	\N	0	\N	\N	5	1	2	f	9045	\N	\N
4176	103	1628	2	6214	\N	0	\N	\N	6	1	2	f	6214	\N	\N
4177	87	1628	2	1499	\N	0	\N	\N	7	1	2	f	1499	\N	\N
4178	13	1628	2	1285	\N	0	\N	\N	8	1	2	f	1285	\N	\N
4179	130	1628	2	553	\N	0	\N	\N	9	1	2	f	553	\N	\N
4180	177	1628	2	21	\N	0	\N	\N	10	1	2	f	21	\N	\N
4181	12	1628	2	11	\N	0	\N	\N	11	1	2	f	11	\N	\N
4182	127	1628	2	11	\N	0	\N	\N	12	1	2	f	11	\N	\N
4183	120	1628	2	11	\N	0	\N	\N	13	1	2	f	11	\N	\N
4184	59	1628	2	1	\N	0	\N	\N	14	1	2	f	1	\N	\N
4185	129	1628	2	110159	\N	0	\N	\N	0	1	2	f	110159	\N	\N
4186	56	1628	2	70439	\N	0	\N	\N	0	1	2	f	70439	\N	\N
4187	100	1628	2	70439	\N	0	\N	\N	0	1	2	f	70439	\N	\N
4188	14	1628	2	3259	\N	0	\N	\N	0	1	2	f	3259	\N	\N
4189	107	1628	2	1171	\N	0	\N	\N	0	1	2	f	1171	\N	\N
4190	7	1628	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
4191	248	1628	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
4192	247	1628	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
4193	246	1628	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4194	252	1628	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4195	169	1629	2	912803	\N	912803	\N	\N	1	1	2	f	0	8	\N
4196	8	1629	1	909099	\N	909099	\N	\N	1	1	2	f	\N	\N	\N
4197	33	1629	1	1951	\N	1951	\N	\N	0	1	2	f	\N	169	\N
4198	212	1630	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
4199	106	1631	2	2704	\N	0	\N	\N	1	1	2	f	2704	\N	\N
4200	178	1632	2	2328029	\N	2328029	\N	\N	1	1	2	f	0	233	\N
4201	256	1632	2	39086	\N	39086	\N	\N	2	1	2	f	0	233	\N
4202	56	1632	2	1840552	\N	1840552	\N	\N	0	1	2	f	0	233	\N
4203	100	1632	2	1840552	\N	1840552	\N	\N	0	1	2	f	0	233	\N
4204	233	1632	1	2367115	\N	2367115	\N	\N	1	1	2	f	\N	\N	\N
4205	26	1633	2	6428537	\N	0	\N	\N	1	1	2	f	6428537	\N	\N
4206	30	1634	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
4207	260	1635	2	32	\N	0	\N	\N	1	1	2	f	32	\N	\N
4208	241	1636	2	114979	\N	0	\N	\N	1	1	2	f	114979	\N	\N
4209	253	1638	2	3184	\N	0	\N	\N	1	1	2	f	3184	\N	\N
4210	58	1639	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
4211	120	1639	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
4212	7	1639	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4213	246	1639	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4214	225	1641	2	454343	\N	454343	\N	\N	1	1	2	f	0	8	\N
4215	8	1641	1	453192	\N	453192	\N	\N	1	1	2	f	\N	225	\N
4216	33	1641	1	984	\N	984	\N	\N	0	1	2	f	\N	225	\N
4217	178	1642	2	1029077	\N	1029077	\N	\N	1	1	2	f	0	226	\N
4218	113	1642	2	479066	\N	479066	\N	\N	2	1	2	f	0	226	\N
4219	205	1642	2	222475	\N	222475	\N	\N	3	1	2	f	0	226	\N
4220	256	1642	2	7228	\N	7228	\N	\N	4	1	2	f	0	226	\N
4221	56	1642	2	730783	\N	730783	\N	\N	0	1	2	f	0	226	\N
4222	100	1642	2	730783	\N	730783	\N	\N	0	1	2	f	0	226	\N
4223	112	1642	2	411336	\N	411336	\N	\N	0	1	2	f	0	226	\N
4224	226	1642	1	1737846	\N	1737846	\N	\N	1	1	2	f	\N	\N	\N
4225	81	1643	2	133	\N	0	\N	\N	1	1	2	f	133	\N	\N
4226	120	1643	2	133	\N	0	\N	\N	0	1	2	f	133	\N	\N
4227	7	1643	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
4228	246	1643	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
4229	97	1644	2	6900	\N	6900	\N	\N	1	1	2	f	0	\N	\N
4230	99	1644	2	941	\N	941	\N	\N	2	1	2	f	0	\N	\N
4231	258	1644	2	527	\N	527	\N	\N	3	1	2	f	0	\N	\N
4232	155	1644	2	54	\N	54	\N	\N	4	1	2	f	0	\N	\N
4233	110	1644	2	36	\N	36	\N	\N	5	1	2	f	0	\N	\N
4234	201	1644	2	14	\N	14	\N	\N	6	1	2	f	0	\N	\N
4235	184	1644	2	4	\N	4	\N	\N	7	1	2	f	0	\N	\N
4236	172	1644	2	4	\N	4	\N	\N	8	1	2	f	0	\N	\N
4237	6	1644	2	1	\N	1	\N	\N	9	1	2	f	0	172	\N
4238	118	1644	2	676	\N	676	\N	\N	0	1	2	f	0	\N	\N
4239	56	1644	2	435	\N	435	\N	\N	0	1	2	f	0	61	\N
4240	122	1644	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
4241	119	1644	2	14	\N	14	\N	\N	0	1	2	f	0	172	\N
4242	9	1644	2	4	\N	4	\N	\N	0	1	2	f	0	172	\N
4243	230	1644	2	3	\N	3	\N	\N	0	1	2	f	0	172	\N
4244	32	1644	2	1	\N	1	\N	\N	0	1	2	f	0	172	\N
4245	229	1644	2	1	\N	1	\N	\N	0	1	2	f	0	172	\N
4246	120	1644	1	1910	\N	1910	\N	\N	1	1	2	f	\N	\N	\N
4247	61	1644	1	253	\N	253	\N	\N	2	1	2	f	\N	258	\N
4248	172	1644	1	96	\N	96	\N	\N	3	1	2	f	\N	\N	\N
4249	7	1644	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
4250	8	1645	2	1846	\N	1839	\N	\N	1	1	2	f	7	\N	\N
4251	8	1645	1	1832	\N	1832	\N	\N	1	1	2	f	\N	8	\N
4252	76	1646	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
4253	105	1646	2	550	\N	0	\N	\N	2	1	2	f	550	\N	\N
4254	150	1646	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
4255	126	1647	2	935	\N	935	\N	\N	1	1	2	f	0	143	\N
4256	143	1647	1	935	\N	935	\N	\N	1	1	2	f	\N	126	\N
4257	133	1648	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
4258	210	1649	2	36469	\N	0	\N	\N	1	1	2	f	36469	\N	\N
4259	88	1650	2	935750	\N	0	\N	\N	1	1	2	f	935750	\N	\N
4260	60	1651	2	24921	\N	0	\N	\N	1	1	2	f	24921	\N	\N
4261	76	1651	2	2294	\N	0	\N	\N	2	1	2	f	2294	\N	\N
4262	150	1651	2	837	\N	0	\N	\N	3	1	2	f	837	\N	\N
4263	120	1651	2	348	\N	0	\N	\N	4	1	2	f	348	\N	\N
4264	56	1651	2	24921	\N	0	\N	\N	0	1	2	f	24921	\N	\N
4265	105	1651	2	525	\N	0	\N	\N	0	1	2	f	525	\N	\N
4266	7	1651	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
4267	246	1651	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
4268	180	1652	2	28817	\N	28817	\N	\N	1	1	2	f	0	\N	\N
4269	151	1652	1	19518	\N	19518	\N	\N	1	1	2	f	\N	180	\N
4270	215	1652	1	6812	\N	6812	\N	\N	2	1	2	f	\N	180	\N
4271	8	1653	2	221872	\N	0	\N	\N	1	1	2	f	221872	\N	\N
4272	7	1653	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
4273	174	1654	2	11718	\N	0	\N	\N	1	1	2	f	11718	\N	\N
4274	49	1655	2	472	\N	0	\N	\N	1	1	2	f	472	\N	\N
4275	257	1656	2	26681	\N	0	\N	\N	1	1	2	f	26681	\N	\N
4276	108	1657	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
4277	84	1658	2	36450	\N	0	\N	\N	1	1	2	f	36450	\N	\N
4278	56	1658	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
4279	212	1659	2	2646	\N	0	\N	\N	1	1	2	f	2646	\N	\N
4280	83	1660	2	5455	\N	0	\N	\N	1	1	2	f	5455	\N	\N
4281	76	1660	2	2403	\N	0	\N	\N	2	1	2	f	2403	\N	\N
4282	42	1660	2	1030	\N	0	\N	\N	3	1	2	f	1030	\N	\N
4283	56	1660	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
4284	179	1661	2	726817	\N	726817	\N	\N	1	1	2	f	0	244	\N
4285	244	1661	1	726817	\N	726817	\N	\N	1	1	2	f	\N	179	\N
4286	74	1662	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
4287	190	1662	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
4288	52	1662	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
4289	74	1664	2	1512	\N	1512	\N	\N	1	1	2	f	0	52	\N
4290	190	1664	2	1512	\N	1512	\N	\N	2	1	2	f	0	52	\N
4291	52	1664	1	3024	\N	3024	\N	\N	1	1	2	f	\N	\N	\N
4292	157	1665	2	58	\N	0	\N	\N	1	1	2	f	58	\N	\N
4293	88	1666	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
4294	253	1667	2	5652	\N	5652	\N	\N	1	1	2	f	0	8	\N
4295	8	1667	1	5652	\N	5652	\N	\N	1	1	2	f	\N	253	\N
4296	8	1668	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
4297	85	1670	2	57	\N	57	\N	\N	1	1	2	f	0	\N	\N
4298	153	1670	2	5	\N	5	\N	\N	2	1	2	f	0	153	\N
4299	65	1670	1	56	\N	56	\N	\N	1	1	2	f	\N	85	\N
4300	85	1670	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
4301	153	1670	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
4302	228	1671	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
4303	204	1672	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
4304	120	1672	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
4305	7	1672	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
4306	246	1672	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
4307	180	1673	2	719	\N	719	\N	\N	1	1	2	f	0	198	\N
4308	12	1673	2	31	\N	31	\N	\N	2	1	2	f	0	198	\N
4309	198	1673	1	750	\N	750	\N	\N	1	1	2	f	\N	\N	\N
4310	253	1675	2	652	\N	0	\N	\N	1	1	2	f	652	\N	\N
4311	174	1676	2	9772	\N	0	\N	\N	1	1	2	f	9772	\N	\N
4312	235	1677	2	4268	\N	0	\N	\N	1	1	2	f	4268	\N	\N
4313	56	1677	2	4268	\N	0	\N	\N	0	1	2	f	4268	\N	\N
4314	129	1678	2	110160	\N	0	\N	\N	1	1	2	f	110160	\N	\N
4315	7	1678	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
4316	207	1678	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
4317	248	1678	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
4318	177	1678	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
4319	12	1678	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4320	127	1678	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4321	120	1678	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4322	246	1678	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4323	247	1678	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4324	59	1678	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4325	252	1678	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4326	253	1679	2	291	\N	0	\N	\N	1	1	2	f	291	\N	\N
4327	128	1679	2	140	\N	0	\N	\N	2	1	2	f	140	\N	\N
4328	253	1680	2	2015	\N	0	\N	\N	1	1	2	f	2015	\N	\N
4329	231	1680	2	1115	\N	0	\N	\N	2	1	2	f	1115	\N	\N
4330	120	1680	2	1115	\N	0	\N	\N	0	1	2	f	1115	\N	\N
4331	7	1680	2	1093	\N	0	\N	\N	0	1	2	f	1093	\N	\N
4332	246	1680	2	1093	\N	0	\N	\N	0	1	2	f	1093	\N	\N
4333	15	1681	2	554	\N	0	\N	\N	1	1	2	f	554	\N	\N
4334	7	1681	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4335	29	1682	2	2	\N	2	\N	\N	1	1	2	f	0	29	\N
4336	29	1682	1	2	\N	2	\N	\N	1	1	2	f	\N	29	\N
4337	47	1683	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
4338	163	1683	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
4339	172	1684	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
4340	219	1685	2	150682	\N	0	\N	\N	1	1	2	f	150682	\N	\N
4341	186	1686	2	13806107	\N	13806107	\N	\N	1	1	2	f	0	\N	\N
4342	249	1686	1	13518453	\N	13518453	\N	\N	1	1	2	f	\N	186	\N
4343	56	1686	1	13518453	\N	13518453	\N	\N	0	1	2	f	\N	186	\N
4344	100	1686	1	13518453	\N	13518453	\N	\N	0	1	2	f	\N	186	\N
4345	84	1687	2	36422	\N	0	\N	\N	1	1	2	f	36422	\N	\N
4346	56	1687	2	36422	\N	0	\N	\N	0	1	2	f	36422	\N	\N
4347	257	1688	2	25552	\N	0	\N	\N	1	1	2	f	25552	\N	\N
4348	7	1689	2	753536	\N	0	\N	\N	1	1	2	f	753536	\N	\N
4349	97	1689	2	235	\N	0	\N	\N	2	1	2	f	235	\N	\N
4350	265	1689	2	87	\N	0	\N	\N	3	1	2	f	87	\N	\N
4351	155	1689	2	48	\N	0	\N	\N	4	1	2	f	48	\N	\N
4352	110	1689	2	36	\N	0	\N	\N	5	1	2	f	36	\N	\N
4353	184	1689	2	4	\N	0	\N	\N	6	1	2	f	4	\N	\N
4354	250	1689	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
4355	246	1689	2	523577	\N	0	\N	\N	0	1	2	f	523577	\N	\N
4356	247	1689	2	331366	\N	0	\N	\N	0	1	2	f	331366	\N	\N
4357	248	1689	2	230241	\N	0	\N	\N	0	1	2	f	230241	\N	\N
4358	120	1689	2	156250	\N	0	\N	\N	0	1	2	f	156250	\N	\N
4359	231	1689	2	3865	\N	0	\N	\N	0	1	2	f	3865	\N	\N
4360	57	1689	2	3454	\N	0	\N	\N	0	1	2	f	3454	\N	\N
4361	123	1689	2	2850	\N	0	\N	\N	0	1	2	f	2850	\N	\N
4362	11	1689	2	1675	\N	0	\N	\N	0	1	2	f	1675	\N	\N
4363	118	1689	2	196	\N	0	\N	\N	0	1	2	f	196	\N	\N
4364	232	1689	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
4365	34	1689	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
4366	58	1689	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
4367	129	1689	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
4368	81	1689	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
4369	204	1689	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
4370	211	1689	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
4371	87	1689	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
4372	14	1689	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4373	103	1689	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4374	88	1690	2	935524	\N	935524	\N	\N	1	1	2	f	0	8	\N
4375	8	1690	1	935524	\N	935524	\N	\N	1	1	2	f	\N	88	\N
4376	253	1691	2	19435	\N	19435	\N	\N	1	1	2	f	0	\N	\N
4377	128	1691	2	15273	\N	15273	\N	\N	2	1	2	f	0	\N	\N
4378	129	1692	2	1462	\N	1462	\N	\N	1	1	2	f	0	187	\N
4379	187	1692	1	1462	\N	1462	\N	\N	1	1	2	f	\N	129	\N
4380	48	1693	2	581	\N	0	\N	\N	1	1	2	f	581	\N	\N
4381	128	1695	2	81	\N	0	\N	\N	1	1	2	f	81	\N	\N
4382	128	1696	2	941	\N	0	\N	\N	1	1	2	f	941	\N	\N
4383	235	1697	2	2501	\N	0	\N	\N	1	1	2	f	2501	\N	\N
4384	56	1697	2	2501	\N	0	\N	\N	0	1	2	f	2501	\N	\N
4385	253	1698	2	5415	\N	0	\N	\N	1	1	2	f	5415	\N	\N
4386	81	1698	2	124	\N	0	\N	\N	2	1	2	f	124	\N	\N
4387	120	1698	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
4388	7	1698	2	95	\N	0	\N	\N	0	1	2	f	95	\N	\N
4389	246	1698	2	95	\N	0	\N	\N	0	1	2	f	95	\N	\N
4390	15	1699	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
4391	7	1699	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4392	44	1700	2	386	\N	0	\N	\N	1	1	2	f	386	\N	\N
4393	56	1700	2	386	\N	0	\N	\N	0	1	2	f	386	\N	\N
4394	48	1701	2	491	\N	0	\N	\N	1	1	2	f	491	\N	\N
4395	231	1702	2	6930	\N	6930	\N	\N	1	1	2	f	\N	\N	\N
4396	11	1702	2	2846	\N	2846	\N	\N	2	1	2	f	\N	\N	\N
4397	81	1702	2	41	\N	\N	\N	\N	3	1	2	f	41	\N	\N
4398	120	1702	2	41	\N	\N	\N	\N	0	1	2	f	41	\N	\N
4399	7	1702	2	31	\N	\N	\N	\N	0	1	2	f	31	\N	\N
4400	246	1702	2	31	\N	\N	\N	\N	0	1	2	f	31	\N	\N
4401	38	1702	1	9645	\N	9645	\N	\N	1	1	2	f	\N	\N	\N
4402	33	1702	1	131	\N	131	\N	\N	2	1	2	f	\N	\N	\N
4403	8	1702	1	9645	\N	9645	\N	\N	0	1	2	f	\N	\N	\N
4404	217	1703	2	1124	\N	0	\N	\N	1	1	2	f	1124	\N	\N
4405	171	1704	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
4406	105	1705	2	550	\N	0	\N	\N	1	1	2	f	550	\N	\N
4407	150	1705	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
4408	234	1706	2	33949	\N	0	\N	\N	1	1	2	f	33949	\N	\N
4409	56	1706	2	33948	\N	0	\N	\N	0	1	2	f	33948	\N	\N
4410	8	1707	2	650	\N	8	\N	\N	1	1	2	f	642	\N	\N
4411	8	1707	1	8	\N	8	\N	\N	1	1	2	f	\N	8	\N
4412	29	1708	2	98	\N	98	\N	\N	1	1	2	f	0	54	\N
4413	54	1708	1	98	\N	98	\N	\N	1	1	2	f	\N	29	\N
4414	133	1709	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
4415	127	1710	2	25693	\N	0	\N	\N	1	1	2	f	25693	\N	\N
4416	208	1710	2	1535	\N	0	\N	\N	2	1	2	f	1535	\N	\N
4417	129	1710	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4418	84	1711	2	36127	\N	0	\N	\N	1	1	2	f	36127	\N	\N
4419	56	1711	2	36127	\N	0	\N	\N	0	1	2	f	36127	\N	\N
4420	235	1713	2	2408	\N	0	\N	\N	1	1	2	f	2408	\N	\N
4421	56	1713	2	2408	\N	0	\N	\N	0	1	2	f	2408	\N	\N
4422	235	1714	2	4316	\N	0	\N	\N	1	1	2	f	4316	\N	\N
4423	56	1714	2	4316	\N	0	\N	\N	0	1	2	f	4316	\N	\N
4424	246	1715	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
4425	7	1715	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
4426	120	1715	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
4427	258	1716	2	253	\N	253	\N	\N	1	1	2	f	0	\N	\N
4428	213	1716	2	246	\N	246	\N	\N	2	1	2	f	0	\N	\N
4429	56	1716	2	253	\N	253	\N	\N	0	1	2	f	0	\N	\N
4430	216	1717	2	185	\N	0	\N	\N	1	1	2	f	185	\N	\N
4431	107	1718	2	1582	\N	0	\N	\N	1	1	2	f	1582	\N	\N
4432	87	1718	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4433	7	1718	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
4434	90	1719	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
4435	30	1720	2	2	\N	2	\N	\N	1	1	2	f	0	228	\N
4436	228	1720	1	2	\N	2	\N	\N	1	1	2	f	\N	30	\N
4437	179	1721	2	214805	\N	214805	\N	\N	1	1	2	f	0	77	\N
4438	77	1721	1	214805	\N	214805	\N	\N	1	1	2	f	\N	179	\N
4439	207	1722	2	405664	\N	405664	\N	\N	1	1	2	f	0	186	\N
4440	129	1722	2	97	\N	97	\N	\N	0	1	2	f	0	186	\N
4441	7	1722	2	1	\N	1	\N	\N	0	1	2	f	0	186	\N
4442	186	1722	1	408460	\N	408460	\N	\N	1	1	2	f	\N	\N	\N
4443	58	1723	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
4444	120	1723	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
4445	7	1723	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4446	246	1723	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4447	29	1724	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
4448	186	1725	2	15117462	\N	15117462	\N	\N	1	1	2	f	0	\N	\N
4449	112	1725	2	7130648	\N	7130648	\N	\N	2	1	2	f	0	\N	\N
4450	26	1725	2	6429420	\N	6429420	\N	\N	3	1	2	f	0	\N	\N
4451	56	1725	2	6079891	\N	6079891	\N	\N	4	1	2	f	0	\N	\N
4452	177	1725	2	5276501	\N	5276501	\N	\N	5	1	2	f	0	\N	\N
4453	2	1725	2	3878965	\N	3878965	\N	\N	6	1	2	f	0	\N	\N
4454	233	1725	2	2367115	\N	2367115	\N	\N	7	1	2	f	0	\N	\N
4455	104	1725	2	2334482	\N	2334482	\N	\N	8	1	2	f	0	\N	\N
4456	7	1725	2	2199165	\N	2199165	\N	\N	9	1	2	f	0	\N	\N
4457	145	1725	2	1961505	\N	1961505	\N	\N	10	1	2	f	0	\N	\N
4458	224	1725	2	1961500	\N	1961500	\N	\N	11	1	2	f	0	\N	\N
4459	78	1725	2	1961497	\N	1961497	\N	\N	12	1	2	f	0	\N	\N
4460	193	1725	2	1926031	\N	1926031	\N	\N	13	1	2	f	0	\N	\N
4461	179	1725	2	1925942	\N	1925942	\N	\N	14	1	2	f	0	\N	\N
4462	1	1725	2	1909205	\N	1909205	\N	\N	15	1	2	f	0	\N	\N
4463	169	1725	2	1854424	\N	1854424	\N	\N	16	1	2	f	0	\N	\N
4464	226	1725	2	1737846	\N	1737846	\N	\N	17	1	2	f	0	\N	\N
4465	35	1725	2	1499564	\N	1499564	\N	\N	18	1	2	f	0	\N	\N
4466	4	1725	2	1474985	\N	1474985	\N	\N	19	1	2	f	0	\N	\N
4467	243	1725	2	1206662	\N	1206662	\N	\N	20	1	2	f	0	\N	\N
4468	116	1725	2	1054932	\N	1054932	\N	\N	21	1	2	f	0	\N	\N
4469	59	1725	2	1031071	\N	1031071	\N	\N	22	1	2	f	0	\N	\N
4470	195	1725	2	1015273	\N	1015273	\N	\N	23	1	2	f	0	\N	\N
4471	225	1725	2	956051	\N	956051	\N	\N	24	1	2	f	0	\N	\N
4472	88	1725	2	935516	\N	935516	\N	\N	25	1	2	f	0	\N	\N
4473	170	1725	2	903214	\N	903214	\N	\N	26	1	2	f	0	\N	\N
4474	244	1725	2	726836	\N	726836	\N	\N	27	1	2	f	0	\N	\N
4475	3	1725	2	719345	\N	719345	\N	\N	28	1	2	f	0	\N	\N
4476	194	1725	2	714841	\N	714841	\N	\N	29	1	2	f	0	\N	\N
4477	28	1725	2	630215	\N	630215	\N	\N	30	1	2	f	0	\N	\N
4478	188	1725	2	591647	\N	591647	\N	\N	31	1	2	f	0	\N	\N
4479	73	1725	2	561539	\N	561539	\N	\N	32	1	2	f	0	\N	\N
4480	227	1725	2	509915	\N	509915	\N	\N	33	1	2	f	0	\N	\N
4481	166	1725	2	505915	\N	505915	\N	\N	34	1	2	f	0	\N	\N
4482	36	1725	2	484238	\N	484238	\N	\N	35	1	2	f	0	\N	\N
4483	254	1725	2	478636	\N	478636	\N	\N	36	1	2	f	0	\N	\N
4484	24	1725	2	437249	\N	437249	\N	\N	37	1	2	f	0	\N	\N
4485	51	1725	2	437249	\N	437249	\N	\N	38	1	2	f	0	\N	\N
4486	72	1725	2	437249	\N	437249	\N	\N	39	1	2	f	0	\N	\N
4487	156	1725	2	411027	\N	411027	\N	\N	40	1	2	f	0	\N	\N
4488	53	1725	2	304346	\N	304346	\N	\N	41	1	2	f	0	\N	\N
4489	160	1725	2	253720	\N	253720	\N	\N	42	1	2	f	0	\N	\N
4490	106	1725	2	244983	\N	244983	\N	\N	43	1	2	f	0	\N	\N
4491	189	1725	2	244387	\N	244387	\N	\N	44	1	2	f	0	\N	\N
4492	196	1725	2	225689	\N	225689	\N	\N	45	1	2	f	0	\N	\N
4493	205	1725	2	222475	\N	222475	\N	\N	46	1	2	f	0	\N	\N
4494	237	1725	2	217681	\N	217681	\N	\N	47	1	2	f	0	\N	\N
4495	77	1725	2	214825	\N	214825	\N	\N	48	1	2	f	0	\N	\N
4496	197	1725	2	192230	\N	192230	\N	\N	49	1	2	f	0	\N	\N
4497	41	1725	2	182542	\N	182542	\N	\N	50	1	2	f	0	\N	\N
4498	219	1725	2	170684	\N	170684	\N	\N	51	1	2	f	0	\N	\N
4499	79	1725	2	152307	\N	152307	\N	\N	52	1	2	f	0	\N	\N
4500	37	1725	2	145250	\N	145250	\N	\N	53	1	2	f	0	\N	\N
4501	108	1725	2	123830	\N	123830	\N	\N	54	1	2	f	0	\N	\N
4502	241	1725	2	103007	\N	103007	\N	\N	55	1	2	f	0	\N	\N
4503	96	1725	2	89221	\N	89221	\N	\N	56	1	2	f	0	\N	\N
4504	202	1725	2	71620	\N	71620	\N	\N	57	1	2	f	0	\N	\N
4505	272	1725	2	64126	\N	64126	\N	\N	58	1	2	f	0	\N	\N
4506	52	1725	2	63206	\N	63206	\N	\N	59	1	2	f	0	\N	\N
4507	101	1725	2	61235	\N	61235	\N	\N	60	1	2	f	0	\N	\N
4508	144	1725	2	53586	\N	53586	\N	\N	61	1	2	f	0	\N	\N
4509	18	1725	2	45913	\N	45913	\N	\N	62	1	2	f	0	\N	\N
4510	256	1725	2	37226	\N	37226	\N	\N	63	1	2	f	0	\N	\N
4511	210	1725	2	36540	\N	36540	\N	\N	64	1	2	f	0	\N	\N
4512	27	1725	2	34219	\N	34219	\N	\N	65	1	2	f	0	\N	\N
4513	180	1725	2	30940	\N	30940	\N	\N	66	1	2	f	0	\N	\N
4514	187	1725	2	29143	\N	29143	\N	\N	67	1	2	f	0	\N	\N
4515	257	1725	2	27017	\N	27017	\N	\N	68	1	2	f	0	\N	\N
4516	127	1725	2	25704	\N	25704	\N	\N	69	1	2	f	0	\N	\N
4517	167	1725	2	25693	\N	25693	\N	\N	70	1	2	f	0	\N	\N
4518	86	1725	2	25152	\N	25152	\N	\N	71	1	2	f	0	\N	\N
4519	255	1725	2	22851	\N	22851	\N	\N	72	1	2	f	0	\N	\N
4520	151	1725	2	19518	\N	19518	\N	\N	73	1	2	f	0	\N	\N
4521	240	1725	2	19363	\N	19363	\N	\N	74	1	2	f	0	\N	\N
4522	46	1725	2	19068	\N	19068	\N	\N	75	1	2	f	0	\N	\N
4523	206	1725	2	18700	\N	18700	\N	\N	76	1	2	f	0	\N	\N
4524	12	1725	2	18228	\N	18228	\N	\N	77	1	2	f	0	\N	\N
4525	253	1725	2	17016	\N	17016	\N	\N	78	1	2	f	0	\N	\N
4526	114	1725	2	16679	\N	16679	\N	\N	79	1	2	f	0	\N	\N
4527	117	1725	2	15841	\N	15841	\N	\N	80	1	2	f	0	\N	\N
4528	82	1725	2	13691	\N	13691	\N	\N	81	1	2	f	0	\N	\N
4529	45	1725	2	13546	\N	13546	\N	\N	82	1	2	f	0	\N	\N
4530	20	1725	2	9351	\N	9351	\N	\N	83	1	2	f	0	\N	\N
4531	174	1725	2	9045	\N	9045	\N	\N	84	1	2	f	0	\N	\N
4532	176	1725	2	8032	\N	1	\N	\N	85	1	2	f	0	\N	\N
4533	262	1725	2	1	\N	\N	\N	\N	85	1	2	f	0	\N	\N
4534	212	1725	2	7804	\N	7804	\N	\N	86	1	2	f	0	\N	\N
4535	158	1725	2	7625	\N	7625	\N	\N	87	1	2	f	0	\N	\N
4536	97	1725	2	7427	\N	7427	\N	\N	88	1	2	f	0	\N	\N
4537	128	1725	2	7203	\N	7203	\N	\N	89	1	2	f	0	\N	\N
4538	218	1725	2	5923	\N	5923	\N	\N	90	1	2	f	0	\N	\N
4539	209	1725	2	5548	\N	5548	\N	\N	91	1	2	f	0	\N	\N
4540	83	1725	2	5455	\N	5455	\N	\N	92	1	2	f	0	\N	\N
4541	92	1725	2	5149	\N	5149	\N	\N	93	1	2	f	0	\N	\N
4542	48	1725	2	5053	\N	5053	\N	\N	94	1	2	f	0	\N	\N
4543	50	1725	2	4837	\N	4837	\N	\N	95	1	2	f	0	\N	\N
4544	75	1725	2	4804	\N	4804	\N	\N	96	1	2	f	0	\N	\N
4545	76	1725	2	2403	\N	2403	\N	\N	97	1	2	f	0	\N	\N
4546	264	1725	2	2022	\N	2022	\N	\N	98	1	2	f	0	\N	\N
4547	259	1725	2	1992	\N	1992	\N	\N	99	1	2	f	0	\N	\N
4548	143	1725	2	1870	\N	1870	\N	\N	100	1	2	f	0	\N	\N
4549	175	1725	2	1657	\N	1657	\N	\N	101	1	2	f	0	\N	\N
4550	208	1725	2	1536	\N	1536	\N	\N	102	1	2	f	0	\N	\N
4551	74	1725	2	1512	\N	1512	\N	\N	103	1	2	f	0	\N	\N
4552	124	1725	2	1512	\N	1512	\N	\N	104	1	2	f	0	\N	\N
4553	190	1725	2	1512	\N	1512	\N	\N	105	1	2	f	0	\N	\N
4554	221	1725	2	1512	\N	1512	\N	\N	106	1	2	f	0	\N	\N
4555	13	1725	2	1285	\N	1285	\N	\N	107	1	2	f	0	\N	\N
4556	99	1725	2	1180	\N	1180	\N	\N	108	1	2	f	0	\N	\N
4557	217	1725	2	1124	\N	1124	\N	\N	109	1	2	f	0	\N	\N
4558	152	1725	2	968	\N	968	\N	\N	110	1	2	f	0	\N	\N
4559	126	1725	2	935	\N	935	\N	\N	111	1	2	f	0	\N	\N
4560	150	1725	2	866	\N	866	\N	\N	112	1	2	f	0	\N	\N
4561	222	1725	2	774	\N	774	\N	\N	113	1	2	f	0	\N	\N
4562	198	1725	2	750	\N	750	\N	\N	114	1	2	f	0	\N	\N
4563	25	1725	2	738	\N	738	\N	\N	115	1	2	f	0	\N	\N
4564	168	1725	2	640	\N	640	\N	\N	116	1	2	f	0	\N	\N
4565	111	1725	2	611	\N	611	\N	\N	117	1	2	f	0	\N	\N
4566	130	1725	2	553	\N	553	\N	\N	118	1	2	f	0	\N	\N
4567	162	1725	2	506	\N	506	\N	\N	119	1	2	f	0	\N	\N
4568	49	1725	2	472	\N	472	\N	\N	120	1	2	f	0	\N	\N
4569	21	1725	2	456	\N	456	\N	\N	121	1	2	f	0	\N	\N
4570	220	1725	2	456	\N	456	\N	\N	122	1	2	f	0	\N	\N
4571	66	1725	2	415	\N	415	\N	\N	123	1	2	f	0	\N	\N
4572	141	1725	2	397	\N	397	\N	\N	124	1	2	f	0	\N	\N
4573	71	1725	2	320	\N	320	\N	\N	125	1	2	f	0	\N	\N
4574	16	1725	2	284	\N	284	\N	\N	126	1	2	f	0	\N	\N
4575	260	1725	2	258	\N	258	\N	\N	127	1	2	f	0	\N	\N
4576	192	1725	2	246	\N	246	\N	\N	128	1	2	f	0	\N	\N
4577	213	1725	2	246	\N	246	\N	\N	129	1	2	f	0	\N	\N
4578	223	1725	2	246	\N	246	\N	\N	130	1	2	f	0	\N	\N
4579	115	1725	2	234	\N	234	\N	\N	131	1	2	f	0	\N	\N
4580	159	1725	2	225	\N	225	\N	\N	132	1	2	f	0	\N	\N
4581	33	1725	2	218	\N	218	\N	\N	133	1	2	f	0	201	\N
4582	93	1725	2	218	\N	218	\N	\N	134	1	2	f	0	\N	\N
4583	215	1725	2	216	\N	216	\N	\N	135	1	2	f	0	\N	\N
4584	69	1725	2	208	\N	208	\N	\N	136	1	2	f	0	\N	\N
4585	19	1725	2	202	\N	202	\N	\N	137	1	2	f	0	\N	\N
4586	133	1725	2	202	\N	202	\N	\N	138	1	2	f	0	\N	\N
4587	183	1725	2	189	\N	189	\N	\N	139	1	2	f	0	\N	\N
4588	216	1725	2	185	\N	185	\N	\N	140	1	2	f	0	\N	\N
4589	61	1725	2	170	\N	170	\N	\N	141	1	2	f	0	\N	\N
4590	22	1725	2	168	\N	168	\N	\N	142	1	2	f	0	\N	\N
4591	269	1725	2	165	\N	165	\N	\N	143	1	2	f	0	\N	\N
4592	10	1725	2	150	\N	150	\N	\N	144	1	2	f	0	\N	\N
4593	38	1725	2	146	\N	146	\N	\N	145	1	2	f	0	\N	\N
4594	29	1725	2	130	\N	130	\N	\N	146	1	2	f	0	\N	\N
4595	261	1725	2	114	\N	114	\N	\N	147	1	2	f	0	\N	\N
4596	54	1725	2	98	\N	98	\N	\N	148	1	2	f	0	\N	\N
4597	132	1725	2	97	\N	97	\N	\N	149	1	2	f	0	\N	\N
4598	109	1725	2	94	\N	94	\N	\N	150	1	2	f	0	\N	\N
4599	250	1725	2	93	\N	93	\N	\N	151	1	2	f	0	\N	\N
4600	263	1725	2	92	\N	92	\N	\N	152	1	2	f	0	\N	\N
4601	268	1725	2	92	\N	92	\N	\N	153	1	2	f	0	\N	\N
4602	165	1725	2	91	\N	91	\N	\N	154	1	2	f	0	\N	\N
4603	164	1725	2	90	\N	90	\N	\N	155	1	2	f	0	\N	\N
4604	265	1725	2	87	\N	87	\N	\N	156	1	2	f	0	\N	\N
4605	136	1725	2	84	\N	84	\N	\N	157	1	2	f	0	\N	\N
4606	271	1725	2	78	\N	78	\N	\N	158	1	2	f	0	\N	\N
4607	154	1725	2	69	\N	69	\N	\N	159	1	2	f	0	\N	\N
4608	157	1725	2	58	\N	58	\N	\N	160	1	2	f	0	\N	\N
4609	40	1725	2	57	\N	57	\N	\N	161	1	2	f	0	\N	\N
4610	65	1725	2	56	\N	56	\N	\N	162	1	2	f	0	\N	\N
4611	85	1725	2	56	\N	56	\N	\N	163	1	2	f	0	\N	\N
4612	121	1725	2	56	\N	56	\N	\N	164	1	2	f	0	\N	\N
4613	173	1725	2	56	\N	56	\N	\N	165	1	2	f	0	\N	\N
4614	155	1725	2	54	\N	54	\N	\N	166	1	2	f	0	\N	\N
4615	89	1725	2	48	\N	48	\N	\N	167	1	2	f	0	\N	\N
4616	70	1725	2	46	\N	46	\N	\N	168	1	2	f	0	\N	\N
4617	135	1725	2	45	\N	45	\N	\N	169	1	2	f	0	\N	\N
4618	67	1725	2	41	\N	41	\N	\N	170	1	2	f	0	\N	\N
4619	140	1725	2	40	\N	40	\N	\N	171	1	2	f	0	\N	\N
4620	110	1725	2	36	\N	36	\N	\N	172	1	2	f	0	\N	\N
4621	91	1725	2	35	\N	35	\N	\N	173	1	2	f	0	\N	\N
4622	149	1725	2	26	\N	26	\N	\N	174	1	2	f	0	\N	\N
4623	201	1725	2	21	\N	21	\N	\N	175	1	2	f	0	\N	\N
4624	95	1725	2	18	\N	18	\N	\N	176	1	2	f	0	\N	\N
4625	242	1725	2	14	\N	14	\N	\N	177	1	2	f	0	\N	\N
4626	64	1725	2	11	\N	11	\N	\N	178	1	2	f	0	\N	\N
4627	267	1725	2	11	\N	11	\N	\N	179	1	2	f	0	\N	\N
4628	17	1725	2	10	\N	10	\N	\N	180	1	2	f	0	\N	\N
4629	184	1725	2	8	\N	8	\N	\N	181	1	2	f	0	\N	\N
4630	68	1725	2	8	\N	8	\N	\N	182	1	2	f	0	\N	\N
4631	146	1725	2	8	\N	8	\N	\N	183	1	2	f	0	\N	\N
4632	228	1725	2	8	\N	8	\N	\N	184	1	2	f	0	\N	\N
4633	245	1725	2	8	\N	8	\N	\N	185	1	2	f	0	\N	\N
4634	266	1725	2	8	\N	8	\N	\N	186	1	2	f	0	\N	\N
4635	153	1725	2	7	\N	7	\N	\N	187	1	2	f	0	\N	\N
4636	90	1725	2	6	\N	6	\N	\N	188	1	2	f	0	\N	\N
4637	23	1725	2	5	\N	5	\N	\N	189	1	2	f	0	\N	\N
4638	43	1725	2	5	\N	5	\N	\N	190	1	2	f	0	\N	\N
4639	142	1725	2	5	\N	5	\N	\N	191	1	2	f	0	\N	\N
4640	236	1725	2	5	\N	5	\N	\N	192	1	2	f	0	\N	\N
4641	270	1725	2	5	\N	5	\N	\N	193	1	2	f	0	\N	\N
4642	31	1725	2	4	\N	4	\N	\N	194	1	2	f	0	\N	\N
4643	134	1725	2	4	\N	4	\N	\N	195	1	2	f	0	\N	\N
4644	5	1725	2	3	\N	3	\N	\N	196	1	2	f	0	\N	\N
4645	94	1725	2	3	\N	3	\N	\N	197	1	2	f	0	\N	\N
4646	171	1725	2	3	\N	3	\N	\N	198	1	2	f	0	\N	\N
4647	182	1725	2	3	\N	3	\N	\N	199	1	2	f	0	\N	\N
4648	191	1725	2	3	\N	3	\N	\N	200	1	2	f	0	\N	\N
4649	47	1725	2	2	\N	2	\N	\N	201	1	2	f	0	\N	\N
4650	30	1725	2	2	\N	2	\N	\N	202	1	2	f	0	\N	\N
4651	55	1725	2	2	\N	2	\N	\N	203	1	2	f	0	\N	\N
4652	98	1725	2	2	\N	2	\N	\N	204	1	2	f	0	\N	\N
4653	131	1725	2	2	\N	2	\N	\N	205	1	2	f	0	\N	\N
4654	199	1725	2	2	\N	2	\N	\N	206	1	2	f	0	\N	\N
4655	200	1725	2	2	\N	2	\N	\N	207	1	2	f	0	\N	\N
4656	238	1725	2	2	\N	2	\N	\N	208	1	2	f	0	\N	\N
4657	251	1725	2	2	\N	2	\N	\N	209	1	2	f	0	\N	\N
4658	6	1725	2	1	\N	1	\N	\N	210	1	2	f	0	\N	\N
4659	80	1725	2	1	\N	1	\N	\N	211	1	2	f	0	\N	\N
4660	203	1725	2	1	\N	1	\N	\N	212	1	2	f	0	\N	\N
4661	100	1725	2	5643455	\N	5643455	\N	\N	0	1	2	f	0	\N	\N
4662	178	1725	2	5022382	\N	5022382	\N	\N	0	1	2	f	0	\N	\N
4663	246	1725	2	1363417	\N	1363417	\N	\N	0	1	2	f	0	\N	\N
4664	247	1725	2	1095829	\N	1095829	\N	\N	0	1	2	f	0	\N	\N
4665	113	1725	2	890402	\N	890402	\N	\N	0	1	2	f	0	\N	\N
4666	125	1725	2	718996	\N	718996	\N	\N	0	1	2	f	0	\N	\N
4667	248	1725	2	643741	\N	643741	\N	\N	0	1	2	f	0	\N	\N
4668	120	1725	2	480663	\N	480663	\N	\N	0	1	2	f	0	\N	\N
4669	8	1725	2	256278	\N	256278	\N	\N	0	1	2	f	0	\N	\N
4670	249	1725	2	211317	\N	211317	\N	\N	0	1	2	f	0	\N	\N
4671	207	1725	2	167808	\N	167808	\N	\N	0	1	2	f	0	\N	\N
4672	129	1725	2	110291	\N	110291	\N	\N	0	1	2	f	0	\N	\N
4673	252	1725	2	99225	\N	99225	\N	\N	0	1	2	f	0	\N	\N
4674	102	1725	2	93019	\N	93019	\N	\N	0	1	2	f	0	\N	\N
4675	60	1725	2	81654	\N	81654	\N	\N	0	1	2	f	0	\N	\N
4676	84	1725	2	72900	\N	72900	\N	\N	0	1	2	f	0	\N	\N
4677	235	1725	2	72024	\N	72024	\N	\N	0	1	2	f	0	\N	\N
4678	181	1725	2	70194	\N	70194	\N	\N	0	1	2	f	0	\N	\N
4679	234	1725	2	67697	\N	67697	\N	\N	0	1	2	f	0	\N	\N
4680	42	1725	2	50504	\N	50504	\N	\N	0	1	2	f	0	\N	\N
4681	231	1725	2	23083	\N	23083	\N	\N	0	1	2	f	0	\N	\N
4682	44	1725	2	20643	\N	20643	\N	\N	0	1	2	f	0	\N	\N
4683	57	1725	2	10731	\N	10731	\N	\N	0	1	2	f	0	\N	\N
4684	11	1725	2	9744	\N	9744	\N	\N	0	1	2	f	0	\N	\N
4685	123	1725	2	8584	\N	8584	\N	\N	0	1	2	f	0	\N	\N
4686	103	1725	2	6219	\N	6219	\N	\N	0	1	2	f	0	\N	\N
4687	14	1725	2	3279	\N	3279	\N	\N	0	1	2	f	0	\N	\N
4688	229	1725	2	1797	\N	1797	\N	\N	0	1	2	f	0	\N	\N
4689	87	1725	2	1519	\N	1519	\N	\N	0	1	2	f	0	\N	\N
4690	63	1725	2	1230	\N	1230	\N	\N	0	1	2	f	0	\N	\N
4691	107	1725	2	1173	\N	1173	\N	\N	0	1	2	f	0	\N	\N
4692	258	1725	2	962	\N	962	\N	\N	0	1	2	f	0	\N	\N
4693	118	1725	2	861	\N	861	\N	\N	0	1	2	f	0	\N	\N
4694	15	1725	2	673	\N	673	\N	\N	0	1	2	f	0	\N	\N
4695	105	1725	2	554	\N	554	\N	\N	0	1	2	f	0	\N	\N
4696	137	1725	2	544	\N	544	\N	\N	0	1	2	f	0	\N	\N
4697	232	1725	2	360	\N	360	\N	\N	0	1	2	f	0	\N	\N
4698	34	1725	2	240	\N	240	\N	\N	0	1	2	f	0	\N	\N
4699	58	1725	2	227	\N	227	\N	\N	0	1	2	f	0	\N	\N
4700	138	1725	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
4701	214	1725	2	148	\N	148	\N	\N	0	1	2	f	0	\N	\N
4702	81	1725	2	144	\N	144	\N	\N	0	1	2	f	0	\N	\N
4703	211	1725	2	102	\N	102	\N	\N	0	1	2	f	0	\N	\N
4704	204	1725	2	98	\N	98	\N	\N	0	1	2	f	0	\N	\N
4705	239	1725	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
4706	185	1725	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
4707	148	1725	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
4708	39	1725	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
4709	122	1725	2	47	\N	47	\N	\N	0	1	2	f	0	\N	\N
4710	161	1725	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
4711	119	1725	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
4712	172	1725	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
4713	9	1725	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
4714	230	1725	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
4715	32	1725	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
4716	62	1725	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
4717	139	1725	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
4718	147	1725	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
4719	163	1725	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
4720	201	1725	1	241512	\N	241512	\N	\N	1	1	2	f	\N	\N	\N
4721	118	1725	1	73337341	\N	73337341	\N	\N	0	1	2	f	\N	\N	\N
4722	181	1726	2	5518	\N	0	\N	\N	1	1	2	f	5518	\N	\N
4723	56	1726	2	5518	\N	0	\N	\N	0	1	2	f	5518	\N	\N
4724	33	1727	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
4725	49	1728	2	472	\N	0	\N	\N	1	1	2	f	472	\N	\N
4726	235	1729	2	36008	\N	0	\N	\N	1	1	2	f	36008	\N	\N
4727	56	1729	2	36008	\N	0	\N	\N	0	1	2	f	36008	\N	\N
4728	181	1730	2	5501	\N	0	\N	\N	1	1	2	f	5501	\N	\N
4729	56	1730	2	5501	\N	0	\N	\N	0	1	2	f	5501	\N	\N
4730	169	1732	2	484066	\N	0	\N	\N	1	1	2	f	484066	\N	\N
4731	39	1733	2	170	\N	170	\N	\N	1	1	2	f	0	38	\N
4732	99	1733	2	170	\N	170	\N	\N	0	1	2	f	0	38	\N
4733	38	1733	1	170	\N	170	\N	\N	1	1	2	f	\N	39	\N
4734	8	1733	1	170	\N	170	\N	\N	0	1	2	f	\N	39	\N
4735	58	1734	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
4736	120	1734	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
4737	7	1734	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4738	246	1734	2	33	\N	0	\N	\N	0	1	2	f	33	\N	\N
4739	48	1735	2	75	\N	0	\N	\N	1	1	2	f	75	\N	\N
4740	18	1736	2	43913	\N	0	\N	\N	1	1	2	f	43913	\N	\N
4741	158	1736	2	7624	\N	0	\N	\N	2	1	2	f	7624	\N	\N
4742	264	1736	2	1954	\N	0	\N	\N	3	1	2	f	1954	\N	\N
4743	141	1736	2	397	\N	0	\N	\N	4	1	2	f	397	\N	\N
4744	164	1736	2	89	\N	0	\N	\N	5	1	2	f	89	\N	\N
4745	102	1737	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
4746	7	1737	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
4747	246	1738	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
4748	7	1738	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
4749	120	1738	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
4750	248	1739	2	37979	\N	37979	\N	\N	1	1	2	f	0	\N	\N
4751	7	1739	2	37956	\N	37956	\N	\N	0	1	2	f	0	\N	\N
4752	247	1739	2	28467	\N	28467	\N	\N	0	1	2	f	0	252	\N
4753	129	1739	2	14	\N	14	\N	\N	0	1	2	f	0	252	\N
4754	120	1739	2	1	\N	1	\N	\N	0	1	2	f	0	252	\N
4755	252	1739	1	37980	\N	37980	\N	\N	1	1	2	f	\N	248	\N
4756	7	1739	1	37956	\N	37956	\N	\N	0	1	2	f	\N	248	\N
4757	247	1739	1	23277	\N	23277	\N	\N	0	1	2	f	\N	248	\N
4758	120	1739	1	9	\N	9	\N	\N	0	1	2	f	\N	248	\N
4759	14	1739	1	1	\N	1	\N	\N	0	1	2	f	\N	248	\N
4760	57	1739	1	1	\N	1	\N	\N	0	1	2	f	\N	248	\N
4761	129	1739	1	1	\N	1	\N	\N	0	1	2	f	\N	129	\N
4762	43	1740	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
4763	226	1741	2	1729356	\N	1729356	\N	\N	1	1	2	f	0	8	\N
4764	8	1741	1	1728105	\N	1728105	\N	\N	1	1	2	f	\N	226	\N
4765	102	1742	2	9482	\N	0	\N	\N	1	1	2	f	9482	\N	\N
4766	7	1742	2	9472	\N	0	\N	\N	0	1	2	f	9472	\N	\N
4767	247	1742	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
4768	250	1743	2	77	\N	77	\N	\N	1	1	2	f	0	\N	\N
4769	98	1743	2	1	\N	1	\N	\N	2	1	2	f	0	247	\N
4770	251	1743	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
4771	33	1743	2	1	\N	1	\N	\N	4	1	2	f	0	247	\N
4772	247	1743	1	74	\N	74	\N	\N	1	1	2	f	\N	\N	\N
4773	93	1744	2	218	\N	0	\N	\N	1	1	2	f	218	\N	\N
4774	22	1744	2	168	\N	0	\N	\N	2	1	2	f	168	\N	\N
4775	267	1744	2	11	\N	0	\N	\N	3	1	2	f	11	\N	\N
4776	68	1744	2	8	\N	0	\N	\N	4	1	2	f	8	\N	\N
4777	266	1744	2	8	\N	0	\N	\N	5	1	2	f	8	\N	\N
4778	270	1744	2	5	\N	0	\N	\N	6	1	2	f	5	\N	\N
4779	13	1745	2	1729	\N	0	\N	\N	1	1	2	f	1729	\N	\N
4780	234	1746	2	23883	\N	0	\N	\N	1	1	2	f	23883	\N	\N
4781	56	1746	2	23883	\N	0	\N	\N	0	1	2	f	23883	\N	\N
4782	234	1748	2	33843	\N	0	\N	\N	1	1	2	f	33843	\N	\N
4783	56	1748	2	33842	\N	0	\N	\N	0	1	2	f	33842	\N	\N
4784	58	1749	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
4785	120	1749	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
4786	7	1749	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
4787	246	1749	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
4788	128	1750	2	4427	\N	0	\N	\N	1	1	2	f	4427	\N	\N
4789	235	1751	2	36008	\N	0	\N	\N	1	1	2	f	36008	\N	\N
4790	56	1751	2	36008	\N	0	\N	\N	0	1	2	f	36008	\N	\N
4791	36	1752	2	484237	\N	484237	\N	\N	1	1	2	f	0	177	\N
4792	177	1752	1	484237	\N	484237	\N	\N	1	1	2	f	\N	36	\N
4793	15	1753	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
4794	196	1754	2	192230	\N	192230	\N	\N	1	1	2	f	0	197	\N
4795	197	1754	1	192230	\N	192230	\N	\N	1	1	2	f	\N	196	\N
4796	107	1755	2	448	\N	448	\N	\N	1	1	2	f	0	\N	\N
4797	7	1755	2	16	\N	16	\N	\N	0	1	2	f	0	107	\N
4798	107	1755	1	413	\N	413	\N	\N	1	1	2	f	\N	107	\N
4799	87	1755	1	16	\N	16	\N	\N	0	1	2	f	\N	107	\N
4800	160	1756	2	233718	\N	0	\N	\N	1	1	2	f	233718	\N	\N
4801	181	1757	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
4802	56	1757	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
4803	235	1759	2	8638	\N	0	\N	\N	1	1	2	f	8638	\N	\N
4804	56	1759	2	8638	\N	0	\N	\N	0	1	2	f	8638	\N	\N
4805	31	1760	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
4806	48	1762	2	859	\N	0	\N	\N	1	1	2	f	859	\N	\N
4807	58	1763	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
4808	120	1763	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
4809	7	1763	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
4810	246	1763	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
4811	220	1764	2	456	\N	0	\N	\N	1	1	2	f	456	\N	\N
4812	180	1766	2	30940	\N	30940	\N	\N	1	1	2	f	0	177	\N
4813	177	1766	1	30940	\N	30940	\N	\N	1	1	2	f	\N	180	\N
4814	88	1767	2	935516	\N	935516	\N	\N	1	1	2	f	0	\N	\N
4815	42	1768	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
4816	56	1768	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
4817	235	1769	2	32753	\N	0	\N	\N	1	1	2	f	32753	\N	\N
4818	56	1769	2	32753	\N	0	\N	\N	0	1	2	f	32753	\N	\N
4819	129	1770	2	69855	\N	69855	\N	\N	1	1	2	f	0	4	\N
4820	177	1770	2	55	\N	55	\N	\N	0	1	2	f	0	4	\N
4821	127	1770	2	12	\N	12	\N	\N	0	1	2	f	0	4	\N
4822	4	1770	1	69855	\N	69855	\N	\N	1	1	2	f	\N	129	\N
4823	48	1771	2	724	\N	0	\N	\N	1	1	2	f	724	\N	\N
4824	207	1773	2	119313	\N	0	\N	\N	1	1	2	f	119313	\N	\N
4825	103	1773	2	7504	\N	0	\N	\N	2	1	2	f	7504	\N	\N
4826	107	1773	2	3649	\N	0	\N	\N	3	1	2	f	3649	\N	\N
4827	177	1773	2	21	\N	0	\N	\N	4	1	2	f	21	\N	\N
4828	12	1773	2	11	\N	0	\N	\N	5	1	2	f	11	\N	\N
4829	127	1773	2	11	\N	0	\N	\N	6	1	2	f	11	\N	\N
4830	120	1773	2	11	\N	0	\N	\N	7	1	2	f	11	\N	\N
4831	59	1773	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
4832	129	1773	2	107864	\N	0	\N	\N	0	1	2	f	107864	\N	\N
4833	7	1773	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
4834	248	1773	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
4835	246	1773	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
4836	87	1773	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
4837	247	1773	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
4838	252	1773	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4839	81	1774	2	2343	\N	0	\N	\N	1	1	2	f	2343	\N	\N
4840	253	1774	2	191	\N	0	\N	\N	2	1	2	f	191	\N	\N
4841	120	1774	2	2343	\N	0	\N	\N	0	1	2	f	2343	\N	\N
4842	7	1774	2	1736	\N	0	\N	\N	0	1	2	f	1736	\N	\N
4843	246	1774	2	1736	\N	0	\N	\N	0	1	2	f	1736	\N	\N
4844	59	1775	2	1030459	\N	0	\N	\N	1	1	2	f	1030459	\N	\N
4845	129	1775	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
4846	8	1776	2	5522	\N	5522	\N	\N	1	1	2	f	0	\N	\N
4847	272	1777	2	21671	\N	0	\N	\N	1	1	2	f	21671	\N	\N
4848	7	1778	2	46759	\N	4	\N	\N	1	1	2	f	46755	\N	\N
4849	215	1778	2	214	\N	214	\N	\N	2	1	2	f	\N	214	\N
4850	250	1778	2	77	\N	77	\N	\N	3	1	2	f	\N	\N	\N
4851	265	1778	2	72	\N	\N	\N	\N	4	1	2	f	72	\N	\N
4852	98	1778	2	2	\N	2	\N	\N	5	1	2	f	\N	\N	\N
4853	251	1778	2	2	\N	1	\N	\N	6	1	2	f	1	\N	\N
4854	102	1778	2	46146	\N	\N	\N	\N	0	1	2	f	46146	\N	\N
4855	246	1778	2	665	\N	\N	\N	\N	0	1	2	f	665	\N	\N
4856	120	1778	2	660	\N	\N	\N	\N	0	1	2	f	660	\N	\N
4857	172	1778	2	11	\N	5	\N	\N	0	1	2	f	6	\N	\N
4858	247	1778	2	5	\N	\N	\N	\N	0	1	2	f	5	\N	\N
4859	10	1778	1	236	\N	236	\N	\N	1	1	2	f	\N	\N	\N
4860	203	1778	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
4861	214	1778	1	219	\N	219	\N	\N	0	1	2	f	\N	\N	\N
4862	180	1779	2	30940	\N	0	\N	\N	1	1	2	f	30940	\N	\N
4863	149	1780	2	6	\N	6	\N	\N	1	1	2	f	0	250	\N
4864	250	1780	1	6	\N	6	\N	\N	1	1	2	f	\N	149	\N
4865	124	1781	2	1351	\N	1351	\N	\N	1	1	2	f	0	\N	\N
4866	129	1781	1	1074	\N	1074	\N	\N	1	1	2	f	\N	124	\N
4867	235	1782	2	33464	\N	0	\N	\N	1	1	2	f	33464	\N	\N
4868	56	1782	2	33464	\N	0	\N	\N	0	1	2	f	33464	\N	\N
4869	178	1783	2	1855886	\N	1855886	\N	\N	1	1	2	f	0	\N	\N
4870	56	1783	2	1583248	\N	1583248	\N	\N	0	1	2	f	0	\N	\N
4871	100	1783	2	1583248	\N	1583248	\N	\N	0	1	2	f	0	\N	\N
4872	174	1783	1	1845275	\N	1845275	\N	\N	1	1	2	f	\N	178	\N
4873	209	1784	2	324	\N	0	\N	\N	1	1	2	f	324	\N	\N
4874	178	1785	2	1855886	\N	1855886	\N	\N	1	1	2	f	0	\N	\N
4875	125	1785	2	266220	\N	266220	\N	\N	2	1	2	f	0	\N	\N
4876	256	1785	2	37226	\N	37226	\N	\N	3	1	2	f	0	\N	\N
4877	82	1785	2	13691	\N	13691	\N	\N	4	1	2	f	0	\N	\N
4878	56	1785	2	1809636	\N	1809636	\N	\N	0	1	2	f	0	\N	\N
4879	100	1785	2	1809636	\N	1809636	\N	\N	0	1	2	f	0	\N	\N
4880	8	1785	1	72209	\N	72209	\N	\N	1	1	2	f	\N	\N	\N
4881	167	1786	2	13305	\N	0	\N	\N	1	1	2	f	13305	\N	\N
4882	26	1787	2	5149745	\N	0	\N	\N	1	1	2	f	5149745	\N	\N
4883	84	1788	2	36450	\N	0	\N	\N	1	1	2	f	36450	\N	\N
4884	56	1788	2	36450	\N	0	\N	\N	0	1	2	f	36450	\N	\N
4885	218	1789	2	5923	\N	0	\N	\N	1	1	2	f	5923	\N	\N
4886	16	1790	2	267	\N	0	\N	\N	1	1	2	f	267	\N	\N
4887	246	1791	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
4888	7	1791	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
4889	120	1791	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
4890	141	1792	2	397	\N	0	\N	\N	1	1	2	f	397	\N	\N
4891	37	1793	2	709	\N	0	\N	\N	1	1	2	f	709	\N	\N
4892	16	1794	2	280	\N	0	\N	\N	1	1	2	f	280	\N	\N
4893	168	1795	2	7892	\N	7892	\N	\N	1	1	2	f	0	\N	\N
4894	249	1795	1	6086	\N	6086	\N	\N	1	1	2	f	\N	168	\N
4895	56	1795	1	6086	\N	6086	\N	\N	0	1	2	f	\N	168	\N
4896	100	1795	1	6086	\N	6086	\N	\N	0	1	2	f	\N	168	\N
4897	124	1796	2	1474	\N	1474	\N	\N	1	1	2	f	0	\N	\N
4898	126	1796	2	930	\N	930	\N	\N	2	1	2	f	0	\N	\N
4899	103	1796	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
4900	129	1796	1	1	\N	1	\N	\N	2	1	2	f	\N	124	\N
4901	15	1797	2	933	\N	933	\N	\N	1	1	2	f	0	154	\N
4902	7	1797	2	12	\N	12	\N	\N	0	1	2	f	0	154	\N
4903	154	1797	1	933	\N	933	\N	\N	1	1	2	f	\N	15	\N
4904	51	1798	2	437249	\N	437249	\N	\N	1	1	2	f	\N	72	\N
4905	72	1798	2	437249	\N	\N	\N	\N	2	1	2	f	437249	\N	\N
4906	72	1798	1	437249	\N	437249	\N	\N	1	1	2	f	\N	51	\N
4907	37	1799	2	145250	\N	145250	\N	\N	1	1	2	f	0	17	\N
4908	17	1799	1	145250	\N	145250	\N	\N	1	1	2	f	\N	37	\N
4909	16	1800	2	283	\N	0	\N	\N	1	1	2	f	283	\N	\N
4910	209	1801	2	324	\N	0	\N	\N	1	1	2	f	324	\N	\N
4911	249	1802	2	70493	\N	0	\N	\N	1	1	2	f	70493	\N	\N
4912	174	1802	2	9051	\N	0	\N	\N	2	1	2	f	9051	\N	\N
4913	56	1802	2	70493	\N	0	\N	\N	0	1	2	f	70493	\N	\N
4914	100	1802	2	70493	\N	0	\N	\N	0	1	2	f	70493	\N	\N
4915	101	1803	2	33862	\N	33861	\N	\N	1	1	2	f	1	\N	\N
4916	8	1803	1	33455	\N	33455	\N	\N	1	1	2	f	\N	101	\N
4917	253	1804	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
4918	128	1804	2	4436	\N	0	\N	\N	2	1	2	f	4436	\N	\N
4919	93	1804	2	218	\N	0	\N	\N	3	1	2	f	218	\N	\N
4920	22	1804	2	168	\N	0	\N	\N	4	1	2	f	168	\N	\N
4921	267	1804	2	11	\N	0	\N	\N	5	1	2	f	11	\N	\N
4922	68	1804	2	8	\N	0	\N	\N	6	1	2	f	8	\N	\N
4923	266	1804	2	8	\N	0	\N	\N	7	1	2	f	8	\N	\N
4924	270	1804	2	5	\N	0	\N	\N	8	1	2	f	5	\N	\N
4925	167	1806	2	6793	\N	6793	\N	\N	1	1	2	f	0	59	\N
4926	59	1806	1	6793	\N	6793	\N	\N	1	1	2	f	\N	167	\N
4927	129	1806	1	1	\N	1	\N	\N	0	1	2	f	\N	167	\N
4928	212	1807	2	4354	\N	4354	\N	\N	1	1	2	f	\N	\N	\N
4929	8	1807	2	4272	\N	3485	\N	\N	2	1	2	f	787	\N	\N
4930	259	1807	2	996	\N	996	\N	\N	3	1	2	f	\N	\N	\N
4931	213	1807	2	971	\N	971	\N	\N	4	1	2	f	\N	\N	\N
4932	135	1807	2	177	\N	177	\N	\N	5	1	2	f	\N	\N	\N
4933	154	1807	2	114	\N	114	\N	\N	6	1	2	f	\N	\N	\N
4934	140	1807	2	92	\N	92	\N	\N	7	1	2	f	\N	\N	\N
4935	99	1807	2	41	\N	41	\N	\N	8	1	2	f	\N	\N	\N
4936	201	1807	2	4	\N	4	\N	\N	9	1	2	f	\N	201	\N
4937	10	1807	2	1	\N	1	\N	\N	10	1	2	f	\N	214	\N
4938	250	1807	2	1	\N	1	\N	\N	11	1	2	f	\N	\N	\N
4939	38	1807	2	693	\N	693	\N	\N	0	1	2	f	\N	\N	\N
4940	63	1807	2	615	\N	615	\N	\N	0	1	2	f	\N	\N	\N
4941	137	1807	2	272	\N	272	\N	\N	0	1	2	f	\N	\N	\N
4942	138	1807	2	88	\N	88	\N	\N	0	1	2	f	\N	\N	\N
4943	161	1807	2	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
4944	39	1807	2	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
4945	212	1807	1	1654	\N	1654	\N	\N	1	1	2	f	\N	\N	\N
4946	8	1807	1	343	\N	343	\N	\N	2	1	2	f	\N	\N	\N
4947	213	1807	1	71	\N	71	\N	\N	3	1	2	f	\N	38	\N
4948	154	1807	1	67	\N	67	\N	\N	4	1	2	f	\N	38	\N
4949	66	1807	1	44	\N	44	\N	\N	5	1	2	f	\N	135	\N
4950	201	1807	1	4	\N	4	\N	\N	6	1	2	f	\N	201	\N
4951	39	1807	1	1	\N	1	\N	\N	7	1	2	f	\N	39	\N
4952	214	1807	1	1	\N	1	\N	\N	8	1	2	f	\N	10	\N
4953	38	1807	1	124	\N	124	\N	\N	0	1	2	f	\N	\N	\N
4954	7	1807	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
4955	10	1807	1	1	\N	1	\N	\N	0	1	2	f	\N	10	\N
4956	99	1807	1	1	\N	1	\N	\N	0	1	2	f	\N	39	\N
4957	129	1808	2	274	\N	0	\N	\N	1	1	2	f	274	\N	\N
4958	19	1809	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
4959	48	1810	2	260	\N	0	\N	\N	1	1	2	f	260	\N	\N
4960	8	1812	2	221870	\N	0	\N	\N	1	1	2	f	221870	\N	\N
4961	7	1812	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
4962	44	1813	2	3124	\N	0	\N	\N	1	1	2	f	3124	\N	\N
4963	56	1813	2	3119	\N	0	\N	\N	0	1	2	f	3119	\N	\N
4964	181	1814	2	29793	\N	0	\N	\N	1	1	2	f	29793	\N	\N
4965	56	1814	2	29793	\N	0	\N	\N	0	1	2	f	29793	\N	\N
4966	26	1815	2	6428508	\N	0	\N	\N	1	1	2	f	6428508	\N	\N
4967	10	1815	2	5485927	\N	0	\N	\N	2	1	2	f	5485927	\N	\N
4968	177	1815	2	5275916	\N	0	\N	\N	3	1	2	f	5275916	\N	\N
4969	2	1815	2	3650472	\N	0	\N	\N	4	1	2	f	3650472	\N	\N
4970	104	1815	2	2334482	\N	0	\N	\N	5	1	2	f	2334482	\N	\N
4971	78	1815	2	1961381	\N	0	\N	\N	6	1	2	f	1961381	\N	\N
4972	59	1815	2	1030219	\N	0	\N	\N	7	1	2	f	1030219	\N	\N
4973	7	1815	2	868948	\N	0	\N	\N	8	1	2	f	868948	\N	\N
4974	227	1815	2	509915	\N	0	\N	\N	9	1	2	f	509915	\N	\N
4975	56	1815	2	438455	\N	0	\N	\N	10	1	2	f	438455	\N	\N
4976	53	1815	2	304019	\N	0	\N	\N	11	1	2	f	304019	\N	\N
4977	202	1815	2	71620	\N	0	\N	\N	12	1	2	f	71620	\N	\N
4978	101	1815	2	61237	\N	0	\N	\N	13	1	2	f	61237	\N	\N
4979	256	1815	2	36723	\N	0	\N	\N	14	1	2	f	36723	\N	\N
4980	151	1815	2	19518	\N	0	\N	\N	15	1	2	f	19518	\N	\N
4981	253	1815	2	17016	\N	0	\N	\N	16	1	2	f	17016	\N	\N
4982	117	1815	2	15841	\N	0	\N	\N	17	1	2	f	15841	\N	\N
4983	82	1815	2	13805	\N	0	\N	\N	18	1	2	f	13805	\N	\N
4984	174	1815	2	11801	\N	0	\N	\N	19	1	2	f	11801	\N	\N
4985	97	1815	2	7376	\N	0	\N	\N	20	1	2	f	7376	\N	\N
4986	128	1815	2	7203	\N	0	\N	\N	21	1	2	f	7203	\N	\N
4987	209	1815	2	5548	\N	0	\N	\N	22	1	2	f	5548	\N	\N
4988	48	1815	2	5053	\N	0	\N	\N	23	1	2	f	5053	\N	\N
4989	212	1815	2	2646	\N	0	\N	\N	24	1	2	f	2646	\N	\N
4990	99	1815	2	2465	\N	0	\N	\N	25	1	2	f	2465	\N	\N
4991	13	1815	2	1340	\N	0	\N	\N	26	1	2	f	1340	\N	\N
4992	259	1815	2	996	\N	0	\N	\N	27	1	2	f	996	\N	\N
4993	66	1815	2	830	\N	0	\N	\N	28	1	2	f	830	\N	\N
4994	130	1815	2	678	\N	0	\N	\N	29	1	2	f	678	\N	\N
4995	111	1815	2	611	\N	0	\N	\N	30	1	2	f	611	\N	\N
4996	16	1815	2	275	\N	0	\N	\N	31	1	2	f	275	\N	\N
4997	33	1815	2	219	\N	0	\N	\N	32	1	2	f	219	\N	\N
4998	215	1815	2	216	\N	0	\N	\N	33	1	2	f	216	\N	\N
4999	69	1815	2	208	\N	0	\N	\N	34	1	2	f	208	\N	\N
5000	133	1815	2	202	\N	0	\N	\N	35	1	2	f	202	\N	\N
5001	183	1815	2	197	\N	0	\N	\N	36	1	2	f	197	\N	\N
5002	216	1815	2	186	\N	0	\N	\N	37	1	2	f	186	\N	\N
5003	22	1815	2	168	\N	0	\N	\N	38	1	2	f	168	\N	\N
5004	40	1815	2	114	\N	0	\N	\N	39	1	2	f	114	\N	\N
5005	132	1815	2	97	\N	0	\N	\N	40	1	2	f	97	\N	\N
5006	250	1815	2	92	\N	0	\N	\N	41	1	2	f	92	\N	\N
5007	265	1815	2	87	\N	0	\N	\N	42	1	2	f	87	\N	\N
5008	38	1815	2	73	\N	0	\N	\N	43	1	2	f	73	\N	\N
5009	154	1815	2	69	\N	0	\N	\N	44	1	2	f	69	\N	\N
5010	201	1815	2	60	\N	0	\N	\N	45	1	2	f	60	\N	\N
5011	65	1815	2	56	\N	0	\N	\N	46	1	2	f	56	\N	\N
5012	85	1815	2	56	\N	0	\N	\N	47	1	2	f	56	\N	\N
5013	121	1815	2	56	\N	0	\N	\N	48	1	2	f	56	\N	\N
5014	173	1815	2	56	\N	0	\N	\N	49	1	2	f	56	\N	\N
5015	155	1815	2	54	\N	0	\N	\N	50	1	2	f	54	\N	\N
5016	89	1815	2	48	\N	0	\N	\N	51	1	2	f	48	\N	\N
5017	135	1815	2	45	\N	0	\N	\N	52	1	2	f	45	\N	\N
5018	70	1815	2	38	\N	0	\N	\N	53	1	2	f	38	\N	\N
5019	110	1815	2	36	\N	0	\N	\N	54	1	2	f	36	\N	\N
5020	91	1815	2	35	\N	0	\N	\N	55	1	2	f	35	\N	\N
5021	64	1815	2	11	\N	0	\N	\N	56	1	2	f	11	\N	\N
5022	267	1815	2	11	\N	0	\N	\N	57	1	2	f	11	\N	\N
5023	17	1815	2	10	\N	0	\N	\N	58	1	2	f	10	\N	\N
5024	68	1815	2	8	\N	0	\N	\N	59	1	2	f	8	\N	\N
5025	266	1815	2	8	\N	0	\N	\N	60	1	2	f	8	\N	\N
5026	90	1815	2	6	\N	0	\N	\N	61	1	2	f	6	\N	\N
5027	23	1815	2	5	\N	0	\N	\N	62	1	2	f	5	\N	\N
5028	43	1815	2	5	\N	0	\N	\N	63	1	2	f	5	\N	\N
5029	142	1815	2	5	\N	0	\N	\N	64	1	2	f	5	\N	\N
5030	236	1815	2	5	\N	0	\N	\N	65	1	2	f	5	\N	\N
5031	270	1815	2	5	\N	0	\N	\N	66	1	2	f	5	\N	\N
5032	184	1815	2	4	\N	0	\N	\N	67	1	2	f	4	\N	\N
5033	134	1815	2	4	\N	0	\N	\N	68	1	2	f	4	\N	\N
5034	94	1815	2	3	\N	0	\N	\N	69	1	2	f	3	\N	\N
5035	182	1815	2	3	\N	0	\N	\N	70	1	2	f	3	\N	\N
5036	98	1815	2	2	\N	0	\N	\N	71	1	2	f	2	\N	\N
5037	131	1815	2	2	\N	0	\N	\N	72	1	2	f	2	\N	\N
5038	251	1815	2	2	\N	0	\N	\N	73	1	2	f	2	\N	\N
5039	6	1815	2	1	\N	0	\N	\N	74	1	2	f	1	\N	\N
5040	153	1815	2	1	\N	0	\N	\N	75	1	2	f	1	\N	\N
5041	214	1815	2	5412772	\N	0	\N	\N	0	1	2	f	5412772	\N	\N
5042	246	1815	2	554689	\N	0	\N	\N	0	1	2	f	554689	\N	\N
5043	247	1815	2	354885	\N	0	\N	\N	0	1	2	f	354885	\N	\N
5044	100	1815	2	330901	\N	0	\N	\N	0	1	2	f	330901	\N	\N
5045	125	1815	2	269357	\N	0	\N	\N	0	1	2	f	269357	\N	\N
5046	8	1815	2	260234	\N	0	\N	\N	0	1	2	f	260234	\N	\N
5047	248	1815	2	230258	\N	0	\N	\N	0	1	2	f	230258	\N	\N
5048	120	1815	2	197364	\N	0	\N	\N	0	1	2	f	197364	\N	\N
5049	207	1815	2	167770	\N	0	\N	\N	0	1	2	f	167770	\N	\N
5050	249	1815	2	101376	\N	0	\N	\N	0	1	2	f	101376	\N	\N
5051	102	1815	2	46371	\N	0	\N	\N	0	1	2	f	46371	\N	\N
5052	252	1815	2	37981	\N	0	\N	\N	0	1	2	f	37981	\N	\N
5053	84	1815	2	36422	\N	0	\N	\N	0	1	2	f	36422	\N	\N
5054	235	1815	2	36012	\N	0	\N	\N	0	1	2	f	36012	\N	\N
5055	181	1815	2	35097	\N	0	\N	\N	0	1	2	f	35097	\N	\N
5056	34	1815	2	21005	\N	0	\N	\N	0	1	2	f	21005	\N	\N
5057	231	1815	2	15007	\N	0	\N	\N	0	1	2	f	15007	\N	\N
5058	81	1815	2	10292	\N	0	\N	\N	0	1	2	f	10292	\N	\N
5059	103	1815	2	6558	\N	0	\N	\N	0	1	2	f	6558	\N	\N
5060	11	1815	2	6295	\N	0	\N	\N	0	1	2	f	6295	\N	\N
5061	211	1815	2	3837	\N	0	\N	\N	0	1	2	f	3837	\N	\N
5062	57	1815	2	3455	\N	0	\N	\N	0	1	2	f	3455	\N	\N
5063	14	1815	2	3351	\N	0	\N	\N	0	1	2	f	3351	\N	\N
5064	123	1815	2	2861	\N	0	\N	\N	0	1	2	f	2861	\N	\N
5065	229	1815	2	1795	\N	0	\N	\N	0	1	2	f	1795	\N	\N
5066	87	1815	2	1506	\N	0	\N	\N	0	1	2	f	1506	\N	\N
5067	239	1815	2	1425	\N	0	\N	\N	0	1	2	f	1425	\N	\N
5068	107	1815	2	1261	\N	0	\N	\N	0	1	2	f	1261	\N	\N
5069	118	1815	2	858	\N	0	\N	\N	0	1	2	f	858	\N	\N
5070	15	1815	2	671	\N	0	\N	\N	0	1	2	f	671	\N	\N
5071	63	1815	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
5072	137	1815	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
5073	58	1815	2	114	\N	0	\N	\N	0	1	2	f	114	\N	\N
5074	232	1815	2	113	\N	0	\N	\N	0	1	2	f	113	\N	\N
5075	129	1815	2	96	\N	0	\N	\N	0	1	2	f	96	\N	\N
5076	138	1815	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
5077	148	1815	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
5078	204	1815	2	49	\N	0	\N	\N	0	1	2	f	49	\N	\N
5079	185	1815	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
5080	39	1815	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
5081	122	1815	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
5082	161	1815	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
5083	172	1815	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
5084	119	1815	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
5085	9	1815	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
5086	32	1815	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
5087	62	1815	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
5088	230	1815	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
5089	139	1815	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
5090	147	1815	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
5091	19	1816	2	202	\N	0	\N	\N	1	1	2	f	202	\N	\N
5092	176	1817	2	8500	\N	2	\N	\N	1	1	2	f	0	78	\N
5093	262	1817	2	2	\N	\N	\N	\N	1	1	2	f	0	78	\N
5094	78	1817	1	8502	\N	8502	\N	\N	1	1	2	f	\N	\N	\N
5095	181	1819	2	33069	\N	0	\N	\N	1	1	2	f	33069	\N	\N
5096	56	1819	2	33069	\N	0	\N	\N	0	1	2	f	33069	\N	\N
5097	235	1820	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
5098	56	1820	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
5099	209	1821	2	2859	\N	0	\N	\N	1	1	2	f	2859	\N	\N
5100	174	1822	2	9149	\N	0	\N	\N	1	1	2	f	9149	\N	\N
5101	101	1823	2	34646	\N	34646	\N	\N	1	1	2	f	0	\N	\N
5102	8	1823	1	34630	\N	34630	\N	\N	1	1	2	f	\N	101	\N
5103	33	1823	1	16	\N	16	\N	\N	2	1	2	f	\N	101	\N
5104	253	1824	2	2291	\N	2291	\N	\N	1	1	2	f	0	\N	\N
5105	8	1824	1	2145	\N	2145	\N	\N	1	1	2	f	\N	253	\N
5106	178	1825	2	3605	\N	0	\N	\N	1	1	2	f	3605	\N	\N
5107	256	1825	2	663	\N	0	\N	\N	2	1	2	f	663	\N	\N
5108	125	1825	2	27	\N	0	\N	\N	3	1	2	f	27	\N	\N
5109	56	1825	2	2707	\N	0	\N	\N	0	1	2	f	2707	\N	\N
5110	100	1825	2	2707	\N	0	\N	\N	0	1	2	f	2707	\N	\N
5111	253	1827	2	8420	\N	0	\N	\N	1	1	2	f	8420	\N	\N
5112	107	1828	2	1203	\N	1203	\N	\N	1	1	2	f	0	\N	\N
5113	87	1828	2	6	\N	6	\N	\N	0	1	2	f	0	8	\N
5114	7	1828	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
5115	8	1828	1	1194	\N	1194	\N	\N	1	1	2	f	\N	107	\N
5116	217	1829	2	1124	\N	0	\N	\N	1	1	2	f	1124	\N	\N
5117	130	1830	2	576	\N	576	\N	\N	1	1	2	f	0	\N	\N
5118	8	1830	1	571	\N	571	\N	\N	1	1	2	f	\N	130	\N
5119	14	1831	2	3214	\N	0	\N	\N	1	1	2	f	3214	\N	\N
5120	7	1831	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
5121	247	1831	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
5122	248	1831	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
5123	101	1831	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5124	252	1831	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5125	48	1832	2	263	\N	0	\N	\N	1	1	2	f	263	\N	\N
5126	60	1833	2	53586	\N	53586	\N	\N	1	1	2	f	0	144	\N
5127	56	1833	2	53586	\N	53586	\N	\N	0	1	2	f	0	144	\N
5128	144	1833	1	53586	\N	53586	\N	\N	1	1	2	f	\N	60	\N
5129	79	1834	2	57612	\N	0	\N	\N	1	1	2	f	57612	\N	\N
5130	253	1835	2	4463	\N	0	\N	\N	1	1	2	f	4463	\N	\N
5131	29	1836	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
5132	209	1837	2	327	\N	0	\N	\N	1	1	2	f	327	\N	\N
5133	120	1838	2	150	\N	0	\N	\N	1	1	2	f	150	\N	\N
5134	34	1838	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
5135	7	1838	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
5136	246	1838	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
5137	211	1838	2	30	\N	0	\N	\N	0	1	2	f	30	\N	\N
5138	48	1839	2	385	\N	0	\N	\N	1	1	2	f	385	\N	\N
5139	92	1840	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
5140	125	1841	2	152119	\N	152119	\N	\N	1	1	2	f	0	79	\N
5141	56	1841	2	127669	\N	127669	\N	\N	0	1	2	f	0	79	\N
5142	100	1841	2	127669	\N	127669	\N	\N	0	1	2	f	0	79	\N
5143	79	1841	1	152119	\N	152119	\N	\N	1	1	2	f	\N	125	\N
5144	29	1842	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
5145	157	1843	2	58	\N	0	\N	\N	1	1	2	f	58	\N	\N
5146	81	1844	2	98	\N	0	\N	\N	1	1	2	f	98	\N	\N
5147	120	1844	2	98	\N	0	\N	\N	0	1	2	f	98	\N	\N
5148	7	1844	2	78	\N	0	\N	\N	0	1	2	f	78	\N	\N
5149	246	1844	2	78	\N	0	\N	\N	0	1	2	f	78	\N	\N
5150	44	1845	2	4329	\N	0	\N	\N	1	1	2	f	4329	\N	\N
5151	56	1845	2	4324	\N	0	\N	\N	0	1	2	f	4324	\N	\N
5152	151	1846	2	19158	\N	0	\N	\N	1	1	2	f	19158	\N	\N
5153	80	1847	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
5154	8	1848	2	79	\N	22	\N	\N	1	1	2	f	57	\N	\N
5155	8	1848	1	22	\N	22	\N	\N	1	1	2	f	\N	8	\N
5156	69	1849	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
5157	29	1850	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
5158	237	1851	2	217681	\N	0	\N	\N	1	1	2	f	217681	\N	\N
5159	272	1852	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
5160	235	1853	2	2361	\N	0	\N	\N	1	1	2	f	2361	\N	\N
5161	56	1853	2	2361	\N	0	\N	\N	0	1	2	f	2361	\N	\N
5162	8	1854	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
5163	253	1855	2	16569	\N	10566	\N	\N	1	1	2	f	6003	\N	\N
5164	128	1855	2	7186	\N	4433	\N	\N	2	1	2	f	2753	\N	\N
5165	8	1855	1	14999	\N	14999	\N	\N	1	1	2	f	\N	\N	\N
5166	42	1856	2	11831	\N	0	\N	\N	1	1	2	f	11831	\N	\N
5167	246	1856	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
5168	56	1856	2	11831	\N	0	\N	\N	0	1	2	f	11831	\N	\N
5169	7	1856	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
5170	120	1856	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
5171	125	1857	2	238331	\N	0	\N	\N	1	1	2	f	238331	\N	\N
5172	56	1857	2	203167	\N	0	\N	\N	0	1	2	f	203167	\N	\N
5173	100	1857	2	203167	\N	0	\N	\N	0	1	2	f	203167	\N	\N
5174	33	1858	2	215	\N	0	\N	\N	1	1	2	f	215	\N	\N
5175	60	1859	2	40827	\N	0	\N	\N	1	1	2	f	40827	\N	\N
5176	56	1859	2	40827	\N	0	\N	\N	0	1	2	f	40827	\N	\N
5177	101	1860	2	9796	\N	9796	\N	\N	1	1	2	f	0	\N	\N
5178	77	1860	1	9790	\N	9790	\N	\N	1	1	2	f	\N	101	\N
5179	97	1861	2	363	\N	0	\N	\N	1	1	2	f	363	\N	\N
5180	155	1861	2	54	\N	0	\N	\N	2	1	2	f	54	\N	\N
5181	110	1861	2	36	\N	0	\N	\N	3	1	2	f	36	\N	\N
5182	201	1861	2	6	\N	0	\N	\N	4	1	2	f	6	\N	\N
5183	172	1861	2	6	\N	0	\N	\N	5	1	2	f	6	\N	\N
5184	236	1861	2	5	\N	0	\N	\N	6	1	2	f	5	\N	\N
5185	184	1861	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
5186	94	1861	2	3	\N	0	\N	\N	8	1	2	f	3	\N	\N
5187	182	1861	2	3	\N	0	\N	\N	9	1	2	f	3	\N	\N
5188	216	1861	2	3	\N	0	\N	\N	10	1	2	f	3	\N	\N
5189	6	1861	2	1	\N	0	\N	\N	11	1	2	f	1	\N	\N
5190	33	1861	2	1	\N	0	\N	\N	12	1	2	f	1	\N	\N
5191	118	1861	2	248	\N	0	\N	\N	0	1	2	f	248	\N	\N
5192	119	1861	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
5193	9	1861	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
5194	122	1861	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
5195	32	1861	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
5196	62	1861	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
5197	230	1861	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
5198	48	1862	2	353	\N	0	\N	\N	1	1	2	f	353	\N	\N
5199	8	1863	1	190318	\N	190318	\N	\N	1	1	2	f	\N	\N	\N
5200	81	1864	2	8866	\N	0	\N	\N	1	1	2	f	8866	\N	\N
5201	120	1864	2	8866	\N	0	\N	\N	0	1	2	f	8866	\N	\N
5202	7	1864	2	6469	\N	0	\N	\N	0	1	2	f	6469	\N	\N
5203	246	1864	2	6469	\N	0	\N	\N	0	1	2	f	6469	\N	\N
5204	16	1865	2	236	\N	0	\N	\N	1	1	2	f	236	\N	\N
5205	44	1866	2	10315	\N	0	\N	\N	1	1	2	f	10315	\N	\N
5206	56	1866	2	10273	\N	0	\N	\N	0	1	2	f	10273	\N	\N
5207	33	1867	2	213	\N	0	\N	\N	1	1	2	f	213	\N	\N
5208	58	1868	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
5209	120	1868	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
5210	7	1868	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5211	246	1868	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5212	240	1869	2	5008	\N	5008	\N	\N	1	1	2	f	0	\N	\N
5213	8	1869	1	4909	\N	4909	\N	\N	1	1	2	f	\N	240	\N
5214	27	1870	2	8828	\N	0	\N	\N	1	1	2	f	8828	\N	\N
5215	150	1871	2	508	\N	0	\N	\N	1	1	2	f	508	\N	\N
5216	105	1871	2	420	\N	0	\N	\N	0	1	2	f	420	\N	\N
5217	127	1872	2	42605	\N	42605	\N	\N	1	1	2	f	0	\N	\N
5218	129	1872	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
5219	76	1874	2	2403	\N	0	\N	\N	1	1	2	f	2403	\N	\N
5220	105	1874	2	533	\N	0	\N	\N	2	1	2	f	533	\N	\N
5221	150	1874	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
5222	84	1875	2	30328	\N	0	\N	\N	1	1	2	f	30328	\N	\N
5223	56	1875	2	30328	\N	0	\N	\N	0	1	2	f	30328	\N	\N
5224	234	1876	2	28694	\N	0	\N	\N	1	1	2	f	28694	\N	\N
5225	56	1876	2	28694	\N	0	\N	\N	0	1	2	f	28694	\N	\N
5226	164	1877	2	90	\N	0	\N	\N	1	1	2	f	90	\N	\N
5227	271	1877	2	78	\N	0	\N	\N	2	1	2	f	78	\N	\N
5228	234	1878	2	28694	\N	0	\N	\N	1	1	2	f	28694	\N	\N
5229	56	1878	2	28694	\N	0	\N	\N	0	1	2	f	28694	\N	\N
5230	174	1879	2	2006	\N	0	\N	\N	1	1	2	f	2006	\N	\N
5231	183	1880	2	190	\N	0	\N	\N	1	1	2	f	190	\N	\N
5232	120	1881	2	26355	\N	0	\N	\N	1	1	2	f	26355	\N	\N
5233	253	1881	2	17016	\N	0	\N	\N	2	1	2	f	17016	\N	\N
5234	7	1881	2	19982	\N	0	\N	\N	0	1	2	f	19982	\N	\N
5235	246	1881	2	19982	\N	0	\N	\N	0	1	2	f	19982	\N	\N
5236	34	1881	2	13206	\N	0	\N	\N	0	1	2	f	13206	\N	\N
5237	231	1881	2	11142	\N	0	\N	\N	0	1	2	f	11142	\N	\N
5238	81	1881	2	8938	\N	0	\N	\N	0	1	2	f	8938	\N	\N
5239	246	1882	2	606	\N	0	\N	\N	1	1	2	f	606	\N	\N
5240	7	1882	2	606	\N	0	\N	\N	0	1	2	f	606	\N	\N
5241	120	1882	2	601	\N	0	\N	\N	0	1	2	f	601	\N	\N
5242	235	1883	2	2067	\N	0	\N	\N	1	1	2	f	2067	\N	\N
5243	56	1883	2	2067	\N	0	\N	\N	0	1	2	f	2067	\N	\N
5244	58	1884	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
5245	120	1884	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
5246	7	1884	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
5247	246	1884	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
5248	58	1885	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
5249	120	1885	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
5250	7	1885	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5251	246	1885	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5252	179	1886	2	1859858	\N	0	\N	\N	1	1	2	f	1859858	\N	\N
5253	257	1886	2	26993	\N	0	\N	\N	2	1	2	f	26993	\N	\N
5254	202	1887	2	78307	\N	0	\N	\N	1	1	2	f	78307	\N	\N
5255	33	1888	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
5256	8	1889	2	17032	\N	0	\N	\N	1	1	2	f	17032	\N	\N
5257	99	1889	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
5258	38	1889	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5259	7	1889	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5260	175	1892	2	1751	\N	0	\N	\N	1	1	2	f	1751	\N	\N
5261	8	1894	2	132288	\N	130174	\N	\N	1	1	2	f	2114	\N	\N
5262	8	1894	1	130095	\N	130095	\N	\N	1	1	2	f	\N	8	\N
5263	81	1898	2	2141	\N	0	\N	\N	1	1	2	f	2141	\N	\N
5264	253	1898	2	209	\N	0	\N	\N	2	1	2	f	209	\N	\N
5265	120	1898	2	2141	\N	0	\N	\N	0	1	2	f	2141	\N	\N
5266	7	1898	2	1567	\N	0	\N	\N	0	1	2	f	1567	\N	\N
5267	246	1898	2	1567	\N	0	\N	\N	0	1	2	f	1567	\N	\N
5268	58	1899	2	51	\N	0	\N	\N	1	1	2	f	51	\N	\N
5269	120	1899	2	50	\N	0	\N	\N	0	1	2	f	50	\N	\N
5270	7	1899	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5271	246	1899	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
5272	235	1900	2	3941	\N	0	\N	\N	1	1	2	f	3941	\N	\N
5273	56	1900	2	3941	\N	0	\N	\N	0	1	2	f	3941	\N	\N
5274	171	1901	2	3	\N	3	\N	\N	1	1	2	f	0	5	\N
5275	5	1901	1	3	\N	3	\N	\N	1	1	2	f	\N	171	\N
5276	128	1902	2	2078	\N	2078	\N	\N	1	1	2	f	0	8	\N
5277	8	1902	1	2078	\N	2078	\N	\N	1	1	2	f	\N	128	\N
5278	44	1904	2	432	\N	0	\N	\N	1	1	2	f	432	\N	\N
5279	56	1904	2	432	\N	0	\N	\N	0	1	2	f	432	\N	\N
5280	235	1905	2	4508	\N	0	\N	\N	1	1	2	f	4508	\N	\N
5281	56	1905	2	4508	\N	0	\N	\N	0	1	2	f	4508	\N	\N
5282	114	1906	2	329	\N	0	\N	\N	1	1	2	f	329	\N	\N
5283	1	1907	2	1827922	\N	1827922	\N	\N	1	1	2	f	0	\N	\N
5284	8	1907	1	1828058	\N	1828058	\N	\N	1	1	2	f	\N	\N	\N
5285	33	1907	1	32	\N	32	\N	\N	2	1	2	f	\N	1	\N
5286	128	1909	2	3030	\N	0	\N	\N	1	1	2	f	3030	\N	\N
5287	37	1910	2	338	\N	0	\N	\N	1	1	2	f	338	\N	\N
5288	48	1911	2	756	\N	0	\N	\N	1	1	2	f	756	\N	\N
5289	263	1912	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
5290	107	1914	2	1220	\N	0	\N	\N	1	1	2	f	1220	\N	\N
5291	87	1914	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
5292	7	1914	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5293	44	1916	2	2193	\N	0	\N	\N	1	1	2	f	2193	\N	\N
5294	56	1916	2	2193	\N	0	\N	\N	0	1	2	f	2193	\N	\N
5295	246	1918	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
5296	7	1918	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
5297	120	1918	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
5298	180	1919	2	30940	\N	0	\N	\N	1	1	2	f	30940	\N	\N
5299	253	1920	2	5522	\N	0	\N	\N	1	1	2	f	5522	\N	\N
5300	128	1921	2	1898	\N	1898	\N	\N	1	1	2	f	0	8	\N
5301	8	1921	1	1898	\N	1898	\N	\N	1	1	2	f	\N	128	\N
5302	166	1922	2	29199	\N	0	\N	\N	1	1	2	f	29199	\N	\N
5303	29	1923	2	22	\N	0	\N	\N	1	1	2	f	22	\N	\N
5304	112	1924	2	6719312	\N	6719312	\N	\N	1	1	2	f	0	8	\N
5305	28	1924	2	630215	\N	630215	\N	\N	2	1	2	f	0	8	\N
5306	227	1924	2	509915	\N	509915	\N	\N	3	1	2	f	0	8	\N
5307	13	1924	2	1306	\N	1306	\N	\N	4	1	2	f	0	8	\N
5308	113	1924	2	411336	\N	411336	\N	\N	0	1	2	f	0	8	\N
5309	8	1924	1	10875693	\N	10875693	\N	\N	1	1	2	f	\N	\N	\N
5310	204	1925	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
5311	120	1925	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
5312	7	1925	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
5313	246	1925	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
5314	253	1926	2	10527	\N	0	\N	\N	1	1	2	f	10527	\N	\N
5315	154	1927	2	69	\N	0	\N	\N	1	1	2	f	69	\N	\N
5316	130	1928	2	692	\N	0	\N	\N	1	1	2	f	692	\N	\N
5317	253	1929	2	383	\N	0	\N	\N	1	1	2	f	383	\N	\N
5318	48	1930	2	1025	\N	0	\N	\N	1	1	2	f	1025	\N	\N
5319	242	1931	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
5320	234	1932	2	32868	\N	0	\N	\N	1	1	2	f	32868	\N	\N
5321	56	1932	2	32868	\N	0	\N	\N	0	1	2	f	32868	\N	\N
5322	258	1933	2	527	\N	0	\N	\N	1	1	2	f	527	\N	\N
5323	213	1933	2	246	\N	0	\N	\N	2	1	2	f	246	\N	\N
5324	56	1933	2	435	\N	0	\N	\N	0	1	2	f	435	\N	\N
5325	253	1934	2	3389	\N	3389	\N	\N	1	1	2	f	0	8	\N
5326	8	1934	1	3389	\N	3389	\N	\N	1	1	2	f	\N	253	\N
5327	84	1936	2	4673	\N	0	\N	\N	1	1	2	f	4673	\N	\N
5328	56	1936	2	4673	\N	0	\N	\N	0	1	2	f	4673	\N	\N
5329	169	1937	2	1853924	\N	1853924	\N	\N	1	1	2	f	0	8	\N
5330	8	1937	1	1845872	\N	1845872	\N	\N	1	1	2	f	\N	\N	\N
5331	42	1938	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
5332	56	1938	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
5333	193	1939	2	1893162	\N	0	\N	\N	1	1	2	f	1893162	\N	\N
5334	176	1940	2	8873	\N	1	\N	\N	1	1	2	f	0	78	\N
5335	262	1940	2	1	\N	\N	\N	\N	1	1	2	f	0	78	\N
5336	78	1940	1	8874	\N	8874	\N	\N	1	1	2	f	\N	\N	\N
5337	197	1941	2	1973	\N	1973	\N	\N	1	1	2	f	0	73	\N
5338	73	1941	1	1973	\N	1973	\N	\N	1	1	2	f	\N	197	\N
5339	55	1942	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
5340	107	1943	2	2853	\N	0	\N	\N	1	1	2	f	2853	\N	\N
5341	87	1943	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
5342	7	1943	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5343	251	1944	2	1	\N	1	\N	\N	1	1	2	f	0	247	\N
5344	33	1944	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
5345	247	1944	1	1	\N	1	\N	\N	1	1	2	f	\N	251	\N
5346	209	1946	2	5220	\N	0	\N	\N	1	1	2	f	5220	\N	\N
5347	176	1947	2	8028	\N	1	\N	\N	1	1	2	f	0	78	\N
5348	262	1947	2	1	\N	\N	\N	\N	1	1	2	f	0	78	\N
5349	78	1947	1	8029	\N	8029	\N	\N	1	1	2	f	\N	\N	\N
5350	16	1948	2	275	\N	0	\N	\N	1	1	2	f	275	\N	\N
5351	196	1949	2	69726	\N	69726	\N	\N	1	1	2	f	0	\N	\N
5352	249	1949	1	69714	\N	69714	\N	\N	1	1	2	f	\N	196	\N
5353	56	1949	1	69714	\N	69714	\N	\N	0	1	2	f	\N	196	\N
5354	100	1949	1	69714	\N	69714	\N	\N	0	1	2	f	\N	196	\N
5355	151	1950	2	17162	\N	0	\N	\N	1	1	2	f	17162	\N	\N
5356	88	1951	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
5357	207	1951	2	167807	\N	0	\N	\N	2	1	2	f	167807	\N	\N
5358	202	1951	2	71620	\N	0	\N	\N	3	1	2	f	71620	\N	\N
5359	249	1951	2	70439	\N	0	\N	\N	4	1	2	f	70439	\N	\N
5360	101	1951	2	61235	\N	0	\N	\N	5	1	2	f	61235	\N	\N
5361	174	1951	2	9045	\N	0	\N	\N	6	1	2	f	9045	\N	\N
5362	103	1951	2	6214	\N	0	\N	\N	7	1	2	f	6214	\N	\N
5363	87	1951	2	1499	\N	0	\N	\N	8	1	2	f	1499	\N	\N
5364	13	1951	2	1285	\N	0	\N	\N	9	1	2	f	1285	\N	\N
5365	130	1951	2	553	\N	0	\N	\N	10	1	2	f	553	\N	\N
5366	177	1951	2	21	\N	0	\N	\N	11	1	2	f	21	\N	\N
5367	12	1951	2	11	\N	0	\N	\N	12	1	2	f	11	\N	\N
5368	127	1951	2	11	\N	0	\N	\N	13	1	2	f	11	\N	\N
5369	120	1951	2	11	\N	0	\N	\N	14	1	2	f	11	\N	\N
5370	59	1951	2	1	\N	0	\N	\N	15	1	2	f	1	\N	\N
5371	129	1951	2	110159	\N	0	\N	\N	0	1	2	f	110159	\N	\N
5372	56	1951	2	70439	\N	0	\N	\N	0	1	2	f	70439	\N	\N
5373	100	1951	2	70439	\N	0	\N	\N	0	1	2	f	70439	\N	\N
5374	14	1951	2	3259	\N	0	\N	\N	0	1	2	f	3259	\N	\N
5375	107	1951	2	1171	\N	0	\N	\N	0	1	2	f	1171	\N	\N
5376	7	1951	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
5377	248	1951	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
5378	247	1951	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
5379	246	1951	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
5380	252	1951	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5381	225	1952	2	508523	\N	0	\N	\N	1	1	2	f	508523	\N	\N
5382	127	1953	2	53533	\N	53533	\N	\N	1	1	2	f	0	\N	\N
5383	129	1953	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
5384	129	1953	1	139	\N	139	\N	\N	1	1	2	f	\N	127	\N
5385	103	1953	1	42	\N	42	\N	\N	2	1	2	f	\N	127	\N
5386	88	1954	2	935516	\N	0	\N	\N	1	1	2	f	935516	\N	\N
5387	8	1955	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
5388	99	1955	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
5389	215	1956	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
5390	8	1957	2	192	\N	192	\N	\N	1	1	2	f	0	8	\N
5391	7	1957	2	2	\N	2	\N	\N	0	1	2	f	0	8	\N
5392	8	1957	1	192	\N	192	\N	\N	1	1	2	f	\N	8	\N
5393	258	1959	2	235	\N	235	\N	\N	1	1	2	f	0	\N	\N
5394	56	1959	2	235	\N	235	\N	\N	0	1	2	f	0	\N	\N
5395	149	1961	2	6	\N	6	\N	\N	1	1	2	f	0	250	\N
5396	250	1961	1	6	\N	6	\N	\N	1	1	2	f	\N	149	\N
5397	8	1962	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
5398	212	1963	2	7804	\N	0	\N	\N	1	1	2	f	7804	\N	\N
5399	259	1963	2	996	\N	0	\N	\N	2	1	2	f	996	\N	\N
5400	63	1963	2	615	\N	0	\N	\N	0	1	2	f	615	\N	\N
5401	137	1963	2	272	\N	0	\N	\N	0	1	2	f	272	\N	\N
5402	138	1963	2	88	\N	0	\N	\N	0	1	2	f	88	\N	\N
5403	161	1963	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
5404	86	1965	2	24385	\N	0	\N	\N	1	1	2	f	24385	\N	\N
5405	151	1965	2	19518	\N	0	\N	\N	2	1	2	f	19518	\N	\N
5406	253	1966	2	16365	\N	10485	\N	\N	1	1	2	f	5880	\N	\N
5407	8	1966	1	10349	\N	10349	\N	\N	1	1	2	f	\N	253	\N
5408	172	1967	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
5409	79	1968	2	61961	\N	0	\N	\N	1	1	2	f	61961	\N	\N
5410	253	1970	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
5411	181	1971	2	27509	\N	0	\N	\N	1	1	2	f	27509	\N	\N
5412	56	1971	2	27509	\N	0	\N	\N	0	1	2	f	27509	\N	\N
5413	215	1972	2	166	\N	0	\N	\N	1	1	2	f	166	\N	\N
5414	253	1973	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
5415	176	1974	2	8873	\N	1	\N	\N	1	1	2	f	0	78	\N
5416	262	1974	2	1	\N	\N	\N	\N	1	1	2	f	0	78	\N
5417	78	1974	1	8874	\N	8874	\N	\N	1	1	2	f	\N	\N	\N
5418	60	1975	2	40828	\N	0	\N	\N	1	1	2	f	40828	\N	\N
5419	56	1975	2	40828	\N	0	\N	\N	0	1	2	f	40828	\N	\N
5420	15	1976	2	255	\N	0	\N	\N	1	1	2	f	255	\N	\N
5421	7	1976	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5422	43	1977	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
5423	253	1978	2	10759	\N	0	\N	\N	1	1	2	f	10759	\N	\N
5424	107	1979	2	492	\N	492	\N	\N	1	1	2	f	0	\N	\N
5425	8	1979	1	290	\N	290	\N	\N	1	1	2	f	\N	107	\N
5426	235	1981	2	32684	\N	0	\N	\N	1	1	2	f	32684	\N	\N
5427	56	1981	2	32684	\N	0	\N	\N	0	1	2	f	32684	\N	\N
5428	15	1982	2	671	\N	0	\N	\N	1	1	2	f	671	\N	\N
5429	7	1982	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
5430	128	1983	2	2767	\N	0	\N	\N	1	1	2	f	2767	\N	\N
5431	8	1984	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
5432	263	1985	2	92	\N	0	\N	\N	1	1	2	f	92	\N	\N
5433	8	1986	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
5434	7	1986	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5435	58	1987	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
5436	120	1987	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
5437	7	1987	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
5438	246	1987	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
5439	48	1988	2	359	\N	0	\N	\N	1	1	2	f	359	\N	\N
5440	113	1989	2	479066	\N	479066	\N	\N	1	1	2	f	0	8	\N
5441	112	1989	2	411336	\N	411336	\N	\N	0	1	2	f	0	\N	\N
5442	8	1989	1	474446	\N	474446	\N	\N	1	1	2	f	\N	113	\N
5443	33	1989	1	52	\N	52	\N	\N	0	1	2	f	\N	113	\N
5444	253	1990	2	6790	\N	0	\N	\N	1	1	2	f	6790	\N	\N
5445	235	1991	2	35949	\N	0	\N	\N	1	1	2	f	35949	\N	\N
5446	56	1991	2	35949	\N	0	\N	\N	0	1	2	f	35949	\N	\N
5447	234	1992	2	30363	\N	0	\N	\N	1	1	2	f	30363	\N	\N
5448	56	1992	2	30363	\N	0	\N	\N	0	1	2	f	30363	\N	\N
5449	120	1993	2	348	\N	0	\N	\N	1	1	2	f	348	\N	\N
5450	7	1993	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
5451	246	1993	2	348	\N	0	\N	\N	0	1	2	f	348	\N	\N
5452	253	1994	2	6257	\N	0	\N	\N	1	1	2	f	6257	\N	\N
5453	8	1995	2	5573	\N	0	\N	\N	1	1	2	f	5573	\N	\N
5454	246	1995	2	665	\N	0	\N	\N	2	1	2	f	665	\N	\N
5455	61	1995	2	170	\N	0	\N	\N	3	1	2	f	170	\N	\N
5456	99	1995	2	76	\N	0	\N	\N	4	1	2	f	76	\N	\N
5457	250	1995	2	5	\N	0	\N	\N	5	1	2	f	5	\N	\N
5458	251	1995	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
5459	172	1995	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
5460	7	1995	2	665	\N	0	\N	\N	0	1	2	f	665	\N	\N
5461	120	1995	2	660	\N	0	\N	\N	0	1	2	f	660	\N	\N
5462	239	1995	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
5463	185	1995	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
5464	139	1995	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
5465	247	1995	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5466	92	1996	2	5149	\N	0	\N	\N	1	1	2	f	5149	\N	\N
5467	44	1997	2	6380	\N	0	\N	\N	1	1	2	f	6380	\N	\N
5468	56	1997	2	6380	\N	0	\N	\N	0	1	2	f	6380	\N	\N
5469	8	1998	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
5470	7	1998	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
5471	217	1999	2	1124	\N	0	\N	\N	1	1	2	f	1124	\N	\N
5472	108	2000	2	123830	\N	0	\N	\N	1	1	2	f	123830	\N	\N
5473	42	2001	2	1030	\N	0	\N	\N	1	1	2	f	1030	\N	\N
5474	56	2001	2	1030	\N	0	\N	\N	0	1	2	f	1030	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	3	209	2855	\N	1	\N
2	4	209	2855	\N	1	\N
3	7	248	38032	\N	1	\N
4	7	129	14	\N	0	\N
5	7	247	28482	\N	0	\N
6	7	7	37990	\N	0	\N
7	7	120	1	\N	0	\N
8	8	247	28471	\N	0	\N
9	8	7	37971	\N	0	\N
10	8	120	1	\N	0	\N
11	8	129	14	\N	0	\N
12	8	248	37990	\N	1	\N
13	9	247	23257	\N	0	\N
14	9	7	23281	\N	0	\N
15	9	248	23291	\N	1	\N
16	10	7	9	\N	0	\N
17	10	247	9	\N	0	\N
18	10	248	9	\N	1	\N
19	11	7	1	\N	0	\N
20	11	248	1	\N	1	\N
21	11	247	1	\N	0	\N
22	12	7	1	\N	0	\N
23	12	247	1	\N	0	\N
24	12	248	1	\N	1	\N
25	13	7	1	\N	0	\N
26	13	129	1	\N	1	\N
27	13	248	1	\N	0	\N
28	14	252	38032	\N	1	\N
29	14	120	9	\N	0	\N
30	14	14	1	\N	0	\N
31	14	57	1	\N	0	\N
32	14	129	1	\N	0	\N
33	14	7	37990	\N	0	\N
34	14	247	23291	\N	0	\N
35	15	120	9	\N	0	\N
36	15	57	1	\N	0	\N
37	15	14	1	\N	0	\N
38	15	129	1	\N	0	\N
39	15	7	37971	\N	0	\N
40	15	247	23281	\N	0	\N
41	15	252	37990	\N	1	\N
42	16	120	9	\N	0	\N
43	16	7	28471	\N	0	\N
44	16	57	1	\N	0	\N
45	16	252	28482	\N	1	\N
46	16	247	23257	\N	0	\N
47	16	14	1	\N	0	\N
48	17	252	14	\N	1	\N
49	17	7	14	\N	0	\N
50	17	129	1	\N	0	\N
51	18	7	1	\N	0	\N
52	18	252	1	\N	1	\N
53	19	154	9045	\N	1	\N
54	20	154	1165	\N	1	\N
55	21	154	6	\N	1	\N
56	22	154	2	\N	1	\N
57	23	7	2	\N	0	\N
58	23	174	9045	\N	1	\N
59	23	107	1165	\N	2	\N
60	23	87	6	\N	0	\N
61	27	8	105	\N	1	\N
62	30	107	105	\N	1	\N
63	47	34	100	\N	0	\N
64	47	246	148766	\N	0	\N
65	47	58	96	\N	0	\N
66	47	123	4	\N	0	\N
67	47	247	1	\N	0	\N
68	47	11	1466	\N	0	\N
69	47	231	3684	\N	0	\N
70	47	7	148840	\N	1	\N
71	47	120	129174	\N	0	\N
72	47	129	22	\N	0	\N
73	47	81	93	\N	0	\N
74	47	211	46	\N	0	\N
75	47	204	40	\N	0	\N
76	48	123	4	\N	0	\N
77	48	231	3684	\N	0	\N
78	48	247	1	\N	0	\N
79	48	34	100	\N	0	\N
80	48	7	148745	\N	1	\N
81	48	120	129089	\N	0	\N
82	48	11	1466	\N	0	\N
83	48	81	93	\N	0	\N
84	48	246	148565	\N	0	\N
85	48	129	22	\N	0	\N
86	48	204	40	\N	0	\N
87	48	211	46	\N	0	\N
88	48	58	96	\N	0	\N
89	49	34	90	\N	0	\N
90	49	81	84	\N	0	\N
91	49	247	1	\N	0	\N
92	49	11	1466	\N	0	\N
93	49	204	40	\N	0	\N
94	49	123	4	\N	0	\N
95	49	7	110714	\N	1	\N
96	49	246	110657	\N	0	\N
97	49	211	46	\N	0	\N
98	49	58	90	\N	0	\N
99	49	120	109377	\N	0	\N
100	49	231	3684	\N	0	\N
101	50	7	21	\N	0	\N
102	50	246	21	\N	0	\N
103	50	120	21	\N	1	\N
104	50	129	5	\N	0	\N
105	51	7	5	\N	0	\N
106	51	246	5	\N	0	\N
107	51	120	5	\N	1	\N
108	52	246	4	\N	0	\N
109	52	7	4	\N	0	\N
110	52	120	4	\N	1	\N
111	53	246	1	\N	1	\N
112	53	7	1	\N	0	\N
113	54	7	1	\N	0	\N
114	54	120	1	\N	1	\N
115	54	246	1	\N	0	\N
116	55	120	1	\N	0	\N
117	55	14	5	\N	0	\N
118	55	129	21	\N	0	\N
119	55	7	148745	\N	0	\N
120	55	248	148840	\N	1	\N
121	55	247	110714	\N	0	\N
122	55	87	4	\N	0	\N
123	55	103	1	\N	0	\N
124	56	248	148766	\N	1	\N
125	56	87	4	\N	0	\N
126	56	103	1	\N	0	\N
127	56	120	1	\N	0	\N
128	56	129	21	\N	0	\N
129	56	7	148565	\N	0	\N
130	56	247	110657	\N	0	\N
131	56	14	5	\N	0	\N
132	57	120	1	\N	0	\N
133	57	7	129089	\N	0	\N
134	57	248	129174	\N	1	\N
135	57	129	21	\N	0	\N
136	57	87	4	\N	0	\N
137	57	247	109377	\N	0	\N
138	57	14	5	\N	0	\N
139	58	7	3684	\N	0	\N
140	58	248	3684	\N	1	\N
141	58	247	3684	\N	0	\N
142	59	248	1466	\N	1	\N
143	59	247	1466	\N	0	\N
144	59	7	1466	\N	0	\N
145	60	248	100	\N	1	\N
146	60	247	90	\N	0	\N
147	60	7	100	\N	0	\N
148	61	248	96	\N	1	\N
149	61	247	90	\N	0	\N
150	61	7	96	\N	0	\N
151	62	247	84	\N	0	\N
152	62	7	93	\N	0	\N
153	62	248	93	\N	1	\N
154	63	247	46	\N	0	\N
155	63	248	46	\N	1	\N
156	63	7	46	\N	0	\N
157	64	247	40	\N	0	\N
158	64	7	40	\N	0	\N
159	64	248	40	\N	1	\N
160	65	248	22	\N	1	\N
161	65	7	22	\N	0	\N
162	65	129	5	\N	0	\N
163	66	7	4	\N	0	\N
164	66	248	4	\N	1	\N
165	66	247	4	\N	0	\N
166	67	248	1	\N	1	\N
167	67	7	1	\N	0	\N
168	67	247	1	\N	0	\N
169	76	8	53503	\N	1	\N
170	77	79	53503	\N	1	\N
171	79	8	13613	\N	1	\N
172	80	82	13613	\N	1	\N
173	81	78	9172	\N	1	\N
174	82	78	1	\N	1	\N
175	83	176	9172	\N	1	\N
176	83	262	1	\N	1	\N
177	85	8	419	\N	1	\N
178	86	8	419	\N	1	\N
179	92	196	222686	\N	1	\N
180	93	205	222686	\N	1	\N
181	94	8	3598	\N	1	\N
182	95	253	3598	\N	1	\N
183	97	251	2	\N	1	\N
184	99	250	2	\N	1	\N
185	100	59	479066	\N	1	\N
186	101	59	411336	\N	1	\N
187	102	112	411336	\N	0	\N
188	102	113	479066	\N	1	\N
189	109	8	4433	\N	1	\N
190	110	128	4433	\N	1	\N
191	117	8	4430	\N	1	\N
192	118	128	4430	\N	1	\N
193	130	56	1	\N	0	\N
194	130	101	1873556	\N	1	\N
195	130	100	1	\N	0	\N
196	130	14	16	\N	0	\N
197	130	249	1	\N	2	\N
198	131	100	1789480	\N	0	\N
199	131	249	1789480	\N	1	\N
200	131	56	1789480	\N	0	\N
201	132	100	1	\N	0	\N
202	132	202	1477782	\N	1	\N
203	132	249	1	\N	2	\N
204	132	56	1	\N	0	\N
205	133	129	39	\N	0	\N
206	133	207	467567	\N	1	\N
207	133	7	4	\N	0	\N
208	134	174	264768	\N	1	\N
209	135	207	37	\N	0	\N
210	135	129	211489	\N	1	\N
211	135	7	7	\N	0	\N
212	136	13	10878	\N	1	\N
213	137	7	32	\N	0	\N
214	137	87	194	\N	0	\N
215	137	107	30623	\N	1	\N
216	138	101	1	\N	0	\N
217	138	14	24747	\N	1	\N
218	140	87	20571	\N	1	\N
219	140	107	90	\N	0	\N
220	141	103	18210	\N	1	\N
221	142	130	13365	\N	1	\N
222	143	103	13	\N	1	\N
223	143	129	2	\N	2	\N
224	144	103	12	\N	1	\N
225	144	129	1	\N	2	\N
226	145	103	11	\N	1	\N
227	147	249	1529137	\N	1	\N
228	147	174	225380	\N	2	\N
229	147	56	1529137	\N	0	\N
230	147	100	1529137	\N	0	\N
231	148	249	1529137	\N	1	\N
232	148	174	225380	\N	2	\N
233	148	100	1529137	\N	0	\N
234	148	56	1529137	\N	0	\N
235	149	103	11	\N	1	\N
236	150	179	1873556	\N	1	\N
237	150	257	1	\N	0	\N
238	151	100	1529137	\N	0	\N
239	151	56	1529137	\N	0	\N
240	151	178	1789480	\N	1	\N
241	151	179	1	\N	0	\N
242	151	35	1	\N	0	\N
243	152	35	1477782	\N	1	\N
244	153	205	37	\N	0	\N
245	153	254	467567	\N	1	\N
246	154	100	225380	\N	0	\N
247	154	56	225380	\N	0	\N
248	154	125	264768	\N	1	\N
249	155	180	30623	\N	1	\N
250	155	255	90	\N	2	\N
251	156	208	13	\N	2	\N
252	156	12	18210	\N	1	\N
253	156	126	11	\N	4	\N
254	156	124	12	\N	3	\N
255	156	129	11	\N	0	\N
256	157	82	13365	\N	1	\N
257	158	256	10878	\N	1	\N
258	159	179	1	\N	0	\N
259	159	56	1529137	\N	0	\N
260	159	178	1789480	\N	1	\N
261	159	100	1529137	\N	0	\N
262	159	35	1	\N	0	\N
263	160	178	1789480	\N	1	\N
264	160	179	1	\N	0	\N
265	160	35	1	\N	0	\N
266	160	100	1529137	\N	0	\N
267	160	56	1529137	\N	0	\N
268	161	254	39	\N	2	\N
269	161	208	2	\N	3	\N
270	161	124	1	\N	4	\N
271	161	205	211489	\N	1	\N
272	162	257	24747	\N	1	\N
273	162	179	16	\N	2	\N
274	163	255	20571	\N	1	\N
275	163	180	194	\N	2	\N
276	164	180	32	\N	1	\N
277	164	205	7	\N	2	\N
278	164	254	4	\N	3	\N
279	166	7	2961	\N	0	\N
280	166	246	2961	\N	2	\N
281	166	107	5006	\N	1	\N
282	167	4	5006	\N	1	\N
283	168	4	2961	\N	1	\N
284	169	4	2961	\N	1	\N
285	199	213	3	\N	1	\N
286	199	215	2	\N	2	\N
287	199	8	1	\N	6	\N
288	199	15	2	\N	3	\N
289	199	175	1	\N	5	\N
290	199	64	1	\N	4	\N
291	200	250	3	\N	1	\N
292	201	250	2	\N	1	\N
293	202	250	2	\N	1	\N
294	203	250	1	\N	1	\N
295	204	250	1	\N	1	\N
296	205	250	1	\N	1	\N
297	212	196	1512	\N	1	\N
298	213	124	1512	\N	1	\N
299	214	56	18516	\N	0	\N
300	214	181	18516	\N	1	\N
301	215	181	18516	\N	1	\N
302	215	56	18516	\N	0	\N
303	216	235	18516	\N	1	\N
304	216	56	18516	\N	0	\N
305	217	235	18516	\N	1	\N
306	217	56	18516	\N	0	\N
307	220	8	1182	\N	1	\N
308	221	8	1182	\N	1	\N
309	228	8	3078	\N	1	\N
310	229	253	3078	\N	1	\N
311	230	8	394773	\N	1	\N
312	231	169	394773	\N	1	\N
313	257	154	46419	\N	1	\N
314	258	154	46363	\N	1	\N
315	259	154	229	\N	1	\N
316	260	7	46363	\N	0	\N
317	260	247	229	\N	0	\N
318	260	102	46419	\N	1	\N
319	269	67	41	\N	1	\N
320	270	206	41	\N	1	\N
321	271	177	2367115	\N	1	\N
322	272	233	2367115	\N	1	\N
323	289	228	2	\N	1	\N
324	290	30	2	\N	1	\N
325	296	212	2610	\N	1	\N
326	297	212	2610	\N	1	\N
327	298	13	1628	\N	1	\N
328	299	27	1628	\N	1	\N
329	305	8	24710	\N	1	\N
330	306	8	1523	\N	1	\N
331	307	208	1523	\N	2	\N
332	307	167	24710	\N	1	\N
333	308	174	767741	\N	1	\N
334	309	88	767741	\N	1	\N
335	315	7	360	\N	0	\N
336	315	107	661	\N	1	\N
337	315	246	360	\N	2	\N
338	316	27	661	\N	1	\N
339	317	27	360	\N	1	\N
340	318	27	360	\N	1	\N
341	320	8	88407	\N	1	\N
342	321	8	37	\N	1	\N
343	322	8	35	\N	1	\N
344	323	8	25	\N	1	\N
345	324	8	21	\N	1	\N
346	325	8	11	\N	1	\N
347	326	8	11	\N	1	\N
348	327	8	11	\N	1	\N
349	328	8	11	\N	1	\N
350	329	8	2	\N	1	\N
351	330	8	1	\N	1	\N
352	331	8	1	\N	1	\N
353	332	177	21	\N	0	\N
354	332	129	88407	\N	1	\N
355	332	246	11	\N	0	\N
356	332	252	1	\N	0	\N
357	332	59	1	\N	0	\N
358	332	127	11	\N	0	\N
359	332	248	25	\N	0	\N
360	332	247	2	\N	0	\N
361	332	12	11	\N	0	\N
362	332	7	37	\N	0	\N
363	332	120	11	\N	0	\N
364	332	207	35	\N	0	\N
365	349	133	19971	\N	1	\N
366	350	133	19971	\N	1	\N
367	351	56	19971	\N	0	\N
368	351	234	19971	\N	1	\N
369	356	33	197	\N	1	\N
370	357	47	1	\N	1	\N
371	357	163	1	\N	0	\N
372	358	47	1	\N	1	\N
373	358	163	1	\N	0	\N
374	359	123	197	\N	1	\N
375	360	47	1	\N	1	\N
376	360	163	1	\N	0	\N
377	361	47	1	\N	1	\N
378	361	163	1	\N	0	\N
379	374	33	6	\N	2	\N
380	374	8	49033	\N	1	\N
381	375	79	49033	\N	1	\N
382	376	79	6	\N	1	\N
383	378	8	58	\N	0	\N
384	378	38	58	\N	1	\N
385	379	38	57	\N	1	\N
386	379	8	57	\N	0	\N
387	380	38	43	\N	1	\N
388	380	8	43	\N	0	\N
389	381	8	43	\N	0	\N
390	381	38	43	\N	1	\N
391	382	7	43	\N	0	\N
392	382	58	58	\N	1	\N
393	382	246	43	\N	0	\N
394	382	120	57	\N	0	\N
395	383	58	58	\N	1	\N
396	383	246	43	\N	0	\N
397	383	7	43	\N	0	\N
398	383	120	57	\N	0	\N
399	396	8	10566	\N	1	\N
400	397	253	10566	\N	1	\N
401	405	8	805852	\N	1	\N
402	406	35	805852	\N	1	\N
403	408	177	2493	\N	1	\N
404	409	167	2493	\N	1	\N
405	414	258	577	\N	1	\N
406	414	56	543	\N	0	\N
407	415	56	372	\N	0	\N
408	415	258	406	\N	1	\N
409	416	258	577	\N	1	\N
410	416	56	406	\N	0	\N
411	417	258	543	\N	1	\N
412	417	56	372	\N	0	\N
413	418	56	36534	\N	0	\N
414	418	235	36534	\N	1	\N
415	419	210	36534	\N	1	\N
416	420	210	36534	\N	1	\N
417	421	8	10419	\N	1	\N
418	422	8	4432	\N	1	\N
419	423	128	4432	\N	2	\N
420	423	253	10419	\N	1	\N
421	453	102	24	\N	0	\N
422	453	247	1	\N	0	\N
423	453	7	26	\N	1	\N
424	453	248	4	\N	0	\N
425	455	7	1	\N	1	\N
426	456	102	52	\N	1	\N
427	456	7	52	\N	0	\N
428	456	248	7	\N	2	\N
429	457	248	4	\N	1	\N
430	458	7	1	\N	1	\N
431	459	102	24	\N	1	\N
432	459	7	23	\N	0	\N
433	476	7	1	\N	1	\N
434	478	120	1	\N	2	\N
435	478	102	23	\N	0	\N
436	478	246	1	\N	0	\N
437	478	7	26	\N	0	\N
438	478	247	52	\N	1	\N
439	478	8	1	\N	3	\N
440	479	7	24	\N	0	\N
441	479	247	52	\N	1	\N
442	479	102	24	\N	0	\N
443	480	248	4	\N	0	\N
444	480	247	7	\N	1	\N
445	480	7	4	\N	0	\N
446	481	7	1	\N	1	\N
447	485	114	16679	\N	1	\N
448	486	114	2	\N	1	\N
449	487	129	2	\N	0	\N
450	487	127	16679	\N	1	\N
451	494	99	74	\N	2	\N
452	494	8	40569	\N	1	\N
453	494	38	421	\N	0	\N
454	494	185	64	\N	0	\N
455	494	139	4	\N	0	\N
456	495	8	468	\N	1	\N
457	496	8	10517	\N	1	\N
458	497	8	5593	\N	1	\N
459	498	38	421	\N	1	\N
460	498	8	421	\N	0	\N
461	499	99	32	\N	0	\N
462	499	185	32	\N	1	\N
463	500	99	40569	\N	1	\N
464	500	39	421	\N	0	\N
465	500	8	468	\N	2	\N
466	500	185	5593	\N	0	\N
467	500	239	10517	\N	0	\N
468	501	99	74	\N	1	\N
469	501	139	32	\N	0	\N
470	502	39	421	\N	1	\N
471	502	99	421	\N	0	\N
472	503	99	64	\N	1	\N
473	503	139	32	\N	0	\N
474	504	99	4	\N	1	\N
475	516	8	36128	\N	1	\N
476	517	202	36128	\N	1	\N
477	519	177	25693	\N	1	\N
478	519	129	10	\N	0	\N
479	520	167	25693	\N	1	\N
480	521	167	10	\N	1	\N
481	532	247	1	\N	1	\N
482	533	250	1	\N	1	\N
483	535	8	1708	\N	1	\N
484	535	33	6	\N	2	\N
485	536	174	1708	\N	1	\N
486	537	174	6	\N	1	\N
487	539	8	35468	\N	1	\N
488	539	33	30	\N	2	\N
489	540	101	35468	\N	1	\N
490	541	101	30	\N	1	\N
491	565	8	7	\N	1	\N
492	567	250	7	\N	1	\N
493	573	10	344	\N	0	\N
494	573	214	344	\N	1	\N
495	574	10	1	\N	0	\N
496	574	214	1	\N	1	\N
497	575	15	344	\N	1	\N
498	575	7	1	\N	0	\N
499	576	7	1	\N	0	\N
500	576	15	344	\N	1	\N
501	577	8	1285	\N	1	\N
502	578	13	1285	\N	1	\N
503	580	214	5	\N	0	\N
504	580	10	22	\N	1	\N
505	581	10	1	\N	1	\N
506	582	10	1	\N	1	\N
507	584	250	22	\N	1	\N
508	584	251	1	\N	2	\N
509	584	98	1	\N	3	\N
510	585	250	5	\N	1	\N
511	594	56	83954	\N	0	\N
512	594	174	17	\N	2	\N
513	594	100	83954	\N	0	\N
514	594	249	83954	\N	1	\N
515	595	27	83954	\N	1	\N
516	596	27	17	\N	1	\N
517	597	27	83954	\N	1	\N
518	598	27	83954	\N	1	\N
519	618	228	2	\N	1	\N
520	619	30	2	\N	1	\N
521	620	29	8	\N	1	\N
522	621	228	8	\N	1	\N
523	622	8	1404	\N	1	\N
524	623	180	1404	\N	1	\N
525	624	249	1439467	\N	1	\N
526	624	56	1439467	\N	0	\N
527	624	100	1439467	\N	0	\N
528	625	56	3	\N	0	\N
529	625	100	3	\N	0	\N
530	625	249	3	\N	1	\N
531	626	197	3	\N	0	\N
532	626	73	1439467	\N	1	\N
533	627	197	3	\N	0	\N
534	627	73	1439467	\N	1	\N
535	628	197	3	\N	0	\N
536	628	73	1439467	\N	1	\N
537	634	240	19363	\N	1	\N
538	635	127	19363	\N	1	\N
539	638	7	813	\N	3	\N
540	638	247	1	\N	0	\N
541	638	120	779	\N	0	\N
542	638	234	8723	\N	1	\N
543	638	180	5726	\N	2	\N
544	638	53	612	\N	4	\N
545	638	246	784	\N	0	\N
546	638	56	8723	\N	0	\N
547	639	117	8723	\N	1	\N
548	640	117	5726	\N	1	\N
549	641	117	813	\N	1	\N
550	642	117	612	\N	1	\N
551	643	117	8723	\N	1	\N
552	644	117	784	\N	1	\N
553	645	117	779	\N	1	\N
554	646	117	1	\N	1	\N
555	659	262	1	\N	1	\N
556	660	254	1	\N	1	\N
557	715	8	348	\N	1	\N
558	716	129	348	\N	1	\N
559	735	8	105598	\N	1	\N
560	736	8	3733	\N	1	\N
561	737	8	3733	\N	1	\N
562	738	8	77	\N	1	\N
563	739	56	3733	\N	0	\N
564	739	100	3733	\N	0	\N
565	739	178	105598	\N	1	\N
566	739	256	77	\N	0	\N
567	741	87	9968	\N	0	\N
568	741	107	529962	\N	1	\N
569	741	7	1797	\N	0	\N
570	742	87	2809	\N	0	\N
571	742	107	465394	\N	1	\N
572	742	7	92	\N	0	\N
573	743	107	221337	\N	1	\N
574	743	87	1519	\N	0	\N
575	743	7	58	\N	0	\N
576	744	107	50677	\N	1	\N
577	745	87	1268	\N	0	\N
578	745	107	412754	\N	1	\N
579	746	107	412754	\N	1	\N
580	746	87	1268	\N	0	\N
581	747	256	50677	\N	4	\N
582	747	100	412754	\N	0	\N
583	747	254	465394	\N	2	\N
584	747	205	221337	\N	3	\N
585	747	178	529962	\N	1	\N
586	747	56	412754	\N	0	\N
587	748	254	2809	\N	2	\N
588	748	100	1268	\N	0	\N
589	748	178	9968	\N	1	\N
590	748	205	1519	\N	3	\N
591	748	56	1268	\N	0	\N
592	749	178	1797	\N	1	\N
593	749	254	92	\N	2	\N
594	749	205	58	\N	3	\N
595	756	251	12	\N	1	\N
596	757	251	10	\N	1	\N
597	759	250	12	\N	1	\N
598	759	149	10	\N	2	\N
599	780	8	84	\N	0	\N
600	780	38	84	\N	1	\N
601	781	136	84	\N	1	\N
602	782	136	84	\N	1	\N
603	790	8	1251	\N	1	\N
604	791	8	3	\N	1	\N
605	792	8	2	\N	1	\N
606	793	107	1251	\N	1	\N
607	793	87	3	\N	0	\N
608	793	7	2	\N	0	\N
609	798	200	2	\N	1	\N
610	799	31	2	\N	1	\N
611	805	169	1854277	\N	1	\N
612	806	169	1582839	\N	1	\N
613	807	169	1582839	\N	1	\N
614	808	56	1582839	\N	0	\N
615	808	100	1582839	\N	0	\N
616	808	178	1854277	\N	1	\N
617	809	8	202	\N	0	\N
618	809	38	202	\N	1	\N
619	810	133	202	\N	1	\N
620	811	133	202	\N	1	\N
621	825	8	400199	\N	1	\N
622	826	169	400199	\N	1	\N
623	827	8	3219	\N	1	\N
624	828	8	7	\N	1	\N
625	829	8	6	\N	1	\N
626	830	8	6	\N	1	\N
627	831	8	1	\N	1	\N
628	832	8	1	\N	1	\N
629	833	252	1	\N	0	\N
630	833	101	1	\N	0	\N
631	833	14	3219	\N	1	\N
632	833	247	6	\N	0	\N
633	833	248	6	\N	0	\N
634	833	7	7	\N	0	\N
635	836	8	913	\N	1	\N
636	837	13	913	\N	1	\N
637	854	167	25693	\N	1	\N
638	855	167	11	\N	1	\N
639	856	127	25693	\N	1	\N
640	856	129	11	\N	0	\N
641	858	52	1512	\N	1	\N
642	859	221	1512	\N	1	\N
643	867	107	161351	\N	1	\N
644	867	7	22	\N	0	\N
645	867	87	1033	\N	0	\N
646	868	87	188	\N	0	\N
647	868	107	31776	\N	1	\N
648	868	7	5	\N	0	\N
649	869	107	25	\N	1	\N
650	870	107	21	\N	1	\N
651	871	107	11	\N	1	\N
652	872	107	11	\N	1	\N
653	873	107	1	\N	1	\N
654	874	107	1	\N	1	\N
655	875	7	22	\N	0	\N
656	875	107	109809	\N	1	\N
657	875	87	901	\N	0	\N
658	876	7	5	\N	0	\N
659	876	87	188	\N	0	\N
660	876	107	31776	\N	1	\N
661	877	7	5	\N	0	\N
662	877	107	31776	\N	1	\N
663	877	87	188	\N	0	\N
664	878	107	39	\N	1	\N
665	879	107	11	\N	1	\N
666	880	107	11	\N	1	\N
667	881	107	2	\N	1	\N
668	882	246	11	\N	0	\N
669	882	252	1	\N	7	\N
670	882	207	161351	\N	1	\N
671	882	59	1	\N	8	\N
672	882	100	31776	\N	0	\N
673	882	248	25	\N	3	\N
674	882	120	11	\N	0	\N
675	882	127	11	\N	6	\N
676	882	129	109809	\N	0	\N
677	882	12	11	\N	5	\N
678	882	249	31776	\N	2	\N
679	882	247	2	\N	0	\N
680	882	177	21	\N	4	\N
681	882	56	31776	\N	0	\N
682	882	7	39	\N	0	\N
683	883	100	188	\N	0	\N
684	883	249	188	\N	2	\N
685	883	129	901	\N	0	\N
686	883	56	188	\N	0	\N
687	883	207	1033	\N	1	\N
688	884	100	5	\N	0	\N
689	884	56	5	\N	0	\N
690	884	129	22	\N	1	\N
691	884	207	22	\N	0	\N
692	884	249	5	\N	2	\N
693	885	76	2403	\N	1	\N
694	886	76	16	\N	1	\N
695	887	105	16	\N	0	\N
696	887	150	2403	\N	1	\N
697	892	8	28802	\N	1	\N
698	893	202	28802	\N	1	\N
699	903	249	1435895	\N	1	\N
700	903	100	1435895	\N	0	\N
701	903	56	1435895	\N	0	\N
702	904	249	29143	\N	1	\N
703	904	56	29143	\N	0	\N
704	904	100	29143	\N	0	\N
705	905	187	29143	\N	2	\N
706	905	4	1435895	\N	1	\N
707	906	187	29143	\N	2	\N
708	906	4	1435895	\N	1	\N
709	907	4	1435895	\N	1	\N
710	907	187	29143	\N	2	\N
711	908	8	6868	\N	1	\N
712	909	8	2843	\N	1	\N
713	910	11	2843	\N	2	\N
714	910	231	6868	\N	1	\N
715	913	194	714819	\N	1	\N
716	914	8	475007	\N	1	\N
717	915	179	714819	\N	1	\N
718	916	194	475007	\N	1	\N
719	919	8	1728221	\N	1	\N
720	920	8	304025	\N	1	\N
721	920	33	15	\N	2	\N
722	921	53	304025	\N	2	\N
723	921	226	1728221	\N	1	\N
724	922	53	15	\N	1	\N
725	923	8	2455	\N	1	\N
726	924	8	557	\N	1	\N
727	925	128	557	\N	2	\N
728	925	253	2455	\N	1	\N
729	932	59	21843	\N	1	\N
730	933	59	1411	\N	1	\N
731	934	124	1411	\N	2	\N
732	934	272	21843	\N	1	\N
733	970	8	2	\N	1	\N
734	971	101	2	\N	1	\N
735	973	87	338	\N	0	\N
736	973	107	7387	\N	1	\N
737	974	180	7387	\N	1	\N
738	975	180	338	\N	1	\N
739	1005	99	1122	\N	1	\N
740	1006	99	941	\N	1	\N
741	1007	97	941	\N	0	\N
742	1007	229	1122	\N	1	\N
743	1008	103	77	\N	1	\N
744	1009	143	77	\N	1	\N
745	1013	27	34219	\N	1	\N
746	1014	196	34219	\N	1	\N
747	1018	113	264867	\N	1	\N
748	1018	112	264867	\N	0	\N
749	1019	113	37	\N	1	\N
750	1019	112	37	\N	0	\N
751	1020	112	1	\N	0	\N
752	1020	113	1	\N	1	\N
753	1021	129	37	\N	0	\N
754	1021	7	1	\N	0	\N
755	1021	207	264867	\N	1	\N
756	1022	7	1	\N	0	\N
757	1022	207	264867	\N	1	\N
758	1022	129	37	\N	0	\N
759	1024	8	192	\N	1	\N
760	1025	8	2	\N	1	\N
761	1026	8	192	\N	1	\N
762	1026	7	2	\N	0	\N
763	1029	80	1	\N	1	\N
764	1030	80	1	\N	1	\N
765	1031	118	112	\N	0	\N
766	1032	118	112	\N	0	\N
767	1033	118	12	\N	0	\N
768	1034	153	12	\N	3	\N
769	1034	65	112	\N	1	\N
770	1034	85	112	\N	2	\N
771	1037	154	16533	\N	1	\N
772	1038	154	66	\N	1	\N
773	1039	7	66	\N	0	\N
774	1039	15	16533	\N	1	\N
775	1056	91	84	\N	1	\N
776	1057	136	84	\N	1	\N
777	1058	8	477026	\N	1	\N
778	1059	169	477026	\N	1	\N
779	1061	8	63994	\N	1	\N
780	1062	8	63994	\N	1	\N
781	1063	8	63994	\N	1	\N
782	1064	249	63994	\N	1	\N
783	1064	56	63994	\N	0	\N
784	1064	100	63994	\N	0	\N
785	1065	250	19	\N	2	\N
786	1065	149	21	\N	1	\N
787	1066	250	1	\N	1	\N
788	1067	250	21	\N	1	\N
789	1068	250	19	\N	1	\N
790	1068	149	1	\N	2	\N
791	1069	10	671	\N	0	\N
792	1069	214	671	\N	1	\N
793	1070	10	2	\N	0	\N
794	1070	214	2	\N	1	\N
795	1071	15	671	\N	1	\N
796	1071	7	2	\N	0	\N
797	1072	7	2	\N	0	\N
798	1072	15	671	\N	1	\N
799	1073	221	1512	\N	1	\N
800	1074	124	1512	\N	1	\N
801	1077	148	56	\N	3	\N
802	1077	121	56	\N	1	\N
803	1077	173	56	\N	2	\N
804	1078	148	4	\N	1	\N
805	1078	7	1	\N	0	\N
806	1079	85	56	\N	1	\N
807	1079	153	4	\N	2	\N
808	1080	85	56	\N	1	\N
809	1081	85	56	\N	1	\N
810	1082	153	1	\N	1	\N
811	1085	33	49	\N	2	\N
812	1085	8	11711	\N	1	\N
813	1086	82	11711	\N	1	\N
814	1087	82	49	\N	1	\N
815	1094	7	1054650	\N	0	\N
816	1094	246	1056634	\N	1	\N
817	1094	248	1383	\N	0	\N
818	1094	120	1053068	\N	0	\N
819	1094	247	1383	\N	0	\N
820	1095	120	422646	\N	0	\N
821	1095	7	422838	\N	1	\N
822	1095	246	422646	\N	0	\N
823	1096	120	278086	\N	0	\N
824	1096	7	278697	\N	1	\N
825	1096	246	278086	\N	0	\N
826	1097	252	2113	\N	0	\N
827	1097	120	262375	\N	0	\N
828	1097	7	265025	\N	1	\N
829	1097	246	259897	\N	0	\N
830	1098	120	186667	\N	0	\N
831	1098	246	186667	\N	0	\N
832	1098	7	186747	\N	1	\N
833	1099	120	41179	\N	0	\N
834	1099	246	41179	\N	0	\N
835	1099	7	41192	\N	1	\N
836	1100	129	6	\N	0	\N
837	1100	252	14	\N	0	\N
838	1100	246	11294	\N	0	\N
839	1100	120	11329	\N	0	\N
840	1100	247	2	\N	0	\N
841	1100	7	11368	\N	1	\N
842	1101	7	4715	\N	0	\N
843	1101	120	4689	\N	0	\N
844	1101	246	4765	\N	1	\N
845	1102	246	2430	\N	0	\N
846	1102	7	2431	\N	0	\N
847	1102	120	2496	\N	1	\N
848	1103	246	1784	\N	0	\N
849	1103	120	1784	\N	0	\N
850	1103	7	1787	\N	1	\N
851	1114	120	422646	\N	0	\N
852	1114	7	422838	\N	1	\N
853	1114	246	422646	\N	0	\N
854	1115	7	422838	\N	1	\N
855	1115	120	422646	\N	0	\N
856	1115	246	422646	\N	0	\N
857	1116	102	11	\N	0	\N
858	1116	252	747	\N	0	\N
859	1116	7	130472	\N	1	\N
860	1116	246	129552	\N	0	\N
861	1116	120	129964	\N	0	\N
862	1117	7	6520	\N	0	\N
863	1117	246	6486	\N	0	\N
864	1117	120	6552	\N	1	\N
865	1118	246	3353	\N	0	\N
866	1118	7	3353	\N	0	\N
867	1118	120	3353	\N	1	\N
868	1119	7	7	\N	1	\N
869	1119	120	6	\N	0	\N
870	1119	246	6	\N	0	\N
871	1124	107	4715	\N	8	\N
872	1124	116	1054650	\N	1	\N
873	1124	14	6520	\N	0	\N
874	1124	100	422838	\N	0	\N
875	1124	56	422838	\N	0	\N
876	1124	129	130472	\N	0	\N
877	1124	202	278697	\N	3	\N
878	1124	7	7	\N	0	\N
879	1124	130	1787	\N	10	\N
880	1124	13	2431	\N	9	\N
881	1124	174	41192	\N	6	\N
882	1124	87	3353	\N	0	\N
883	1124	249	422838	\N	2	\N
884	1124	101	186747	\N	5	\N
885	1124	207	265025	\N	4	\N
886	1124	103	11368	\N	7	\N
887	1125	116	1056634	\N	1	\N
888	1125	130	1784	\N	10	\N
889	1125	13	2430	\N	9	\N
890	1125	174	41179	\N	6	\N
891	1125	87	3353	\N	0	\N
892	1125	103	11294	\N	7	\N
893	1125	129	129552	\N	0	\N
894	1125	107	4765	\N	8	\N
895	1125	56	422646	\N	0	\N
896	1125	7	6	\N	0	\N
897	1125	101	186667	\N	5	\N
898	1125	14	6486	\N	0	\N
899	1125	202	278086	\N	3	\N
900	1125	249	422646	\N	2	\N
901	1125	100	422646	\N	0	\N
902	1125	207	259897	\N	4	\N
903	1126	107	4689	\N	8	\N
904	1126	174	41179	\N	6	\N
905	1126	56	422646	\N	0	\N
906	1126	202	278086	\N	3	\N
907	1126	130	1784	\N	10	\N
908	1126	116	1053068	\N	1	\N
909	1126	101	186667	\N	5	\N
910	1126	103	11329	\N	7	\N
911	1126	249	422646	\N	2	\N
912	1126	100	422646	\N	0	\N
913	1126	7	6	\N	0	\N
914	1126	207	262375	\N	4	\N
915	1126	129	129964	\N	0	\N
916	1126	87	3353	\N	0	\N
917	1126	14	6552	\N	0	\N
918	1126	13	2496	\N	9	\N
919	1127	207	2113	\N	1	\N
920	1127	129	747	\N	0	\N
921	1127	103	14	\N	2	\N
922	1128	116	1383	\N	1	\N
923	1128	103	2	\N	2	\N
924	1129	116	1383	\N	1	\N
925	1130	129	11	\N	1	\N
926	1131	103	6	\N	1	\N
927	1142	8	265042	\N	1	\N
928	1143	8	64471	\N	1	\N
929	1144	8	225599	\N	1	\N
930	1145	8	225599	\N	1	\N
931	1146	56	225599	\N	0	\N
932	1146	100	225599	\N	0	\N
933	1146	27	64471	\N	2	\N
934	1146	125	265042	\N	1	\N
935	1147	8	497	\N	1	\N
936	1148	114	497	\N	1	\N
937	1149	8	19518	\N	1	\N
938	1150	151	19518	\N	1	\N
939	1156	272	64126	\N	1	\N
940	1157	196	64126	\N	1	\N
941	1158	8	509915	\N	1	\N
942	1159	227	509915	\N	1	\N
943	1160	13	303	\N	2	\N
944	1160	101	2249729	\N	1	\N
945	1160	100	1	\N	0	\N
946	1160	14	26384	\N	0	\N
947	1160	56	1	\N	0	\N
948	1160	249	1	\N	3	\N
949	1161	101	461550	\N	1	\N
950	1161	14	6410	\N	0	\N
951	1162	36	461550	\N	2	\N
952	1162	233	2249729	\N	1	\N
953	1163	233	303	\N	1	\N
954	1164	233	1	\N	1	\N
955	1165	36	6410	\N	2	\N
956	1165	233	26384	\N	1	\N
957	1166	233	1	\N	1	\N
958	1167	233	1	\N	1	\N
959	1168	8	904	\N	1	\N
960	1169	77	904	\N	1	\N
961	1202	1	1909165	\N	1	\N
962	1203	8	1825	\N	1	\N
963	1204	179	1909165	\N	1	\N
964	1205	1	1825	\N	1	\N
965	1208	8	30915	\N	1	\N
966	1209	180	30915	\N	1	\N
967	1210	8	10327	\N	1	\N
968	1211	8	4428	\N	1	\N
969	1212	128	4428	\N	2	\N
970	1212	253	10327	\N	1	\N
971	1216	8	41	\N	1	\N
972	1217	8	41	\N	1	\N
973	1228	29	3	\N	1	\N
974	1229	54	3	\N	1	\N
975	1232	29	10	\N	1	\N
976	1233	54	10	\N	1	\N
977	1234	29	3	\N	1	\N
978	1235	54	3	\N	1	\N
979	1236	29	56	\N	1	\N
980	1237	146	8	\N	1	\N
981	1238	55	2	\N	1	\N
982	1239	54	56	\N	1	\N
983	1240	245	8	\N	1	\N
984	1241	199	2	\N	1	\N
985	1243	29	13	\N	1	\N
986	1244	54	13	\N	1	\N
987	1249	241	73088	\N	1	\N
988	1250	241	29919	\N	1	\N
989	1251	37	73088	\N	1	\N
990	1251	144	29919	\N	2	\N
991	1252	52	1512	\N	1	\N
992	1253	52	1512	\N	1	\N
993	1254	52	1512	\N	1	\N
994	1255	221	1512	\N	1	\N
995	1255	190	1512	\N	2	\N
996	1255	74	1512	\N	3	\N
997	1261	177	17931	\N	1	\N
998	1261	59	29	\N	2	\N
999	1261	129	11	\N	0	\N
1000	1262	177	2	\N	1	\N
1001	1263	177	11	\N	0	\N
1002	1263	129	11	\N	1	\N
1003	1264	12	17931	\N	1	\N
1004	1264	129	11	\N	0	\N
1005	1264	238	2	\N	2	\N
1006	1265	12	29	\N	1	\N
1007	1266	12	11	\N	1	\N
1008	1266	129	11	\N	0	\N
1009	1274	8	10566	\N	1	\N
1010	1275	8	4433	\N	1	\N
1011	1276	128	4433	\N	2	\N
1012	1276	253	10566	\N	1	\N
1013	1278	103	1	\N	1	\N
1014	1279	126	1	\N	1	\N
1015	1285	52	1418	\N	1	\N
1016	1286	52	1417	\N	1	\N
1017	1287	52	1414	\N	1	\N
1018	1288	221	1414	\N	3	\N
1019	1288	190	1417	\N	2	\N
1020	1288	74	1418	\N	1	\N
1021	1297	8	2319	\N	1	\N
1022	1298	197	2319	\N	1	\N
1023	1317	8	478435	\N	1	\N
1024	1318	8	222475	\N	1	\N
1025	1319	254	478435	\N	1	\N
1026	1319	205	222475	\N	2	\N
1027	1323	8	6664208	\N	1	\N
1028	1323	33	437	\N	0	\N
1029	1324	8	407688	\N	1	\N
1030	1324	33	52	\N	2	\N
1031	1325	113	407688	\N	0	\N
1032	1325	112	6664208	\N	1	\N
1033	1326	112	437	\N	1	\N
1034	1326	113	52	\N	0	\N
1035	1328	130	1816309	\N	1	\N
1036	1329	130	260630	\N	1	\N
1037	1330	130	1802469	\N	1	\N
1038	1331	130	1802469	\N	1	\N
1039	1332	178	1816309	\N	1	\N
1040	1332	56	1802469	\N	0	\N
1041	1332	125	260630	\N	2	\N
1042	1332	100	1802469	\N	0	\N
1043	1333	130	71606	\N	1	\N
1044	1334	130	9038	\N	1	\N
1045	1335	130	71606	\N	1	\N
1046	1336	130	71606	\N	1	\N
1047	1337	249	71606	\N	1	\N
1048	1337	56	71606	\N	0	\N
1049	1337	100	71606	\N	0	\N
1050	1337	174	9038	\N	2	\N
1051	1338	30	2	\N	1	\N
1052	1339	171	2	\N	1	\N
1053	1372	38	58	\N	1	\N
1054	1372	8	58	\N	0	\N
1055	1373	135	58	\N	1	\N
1056	1374	135	58	\N	1	\N
1057	1375	250	39	\N	1	\N
1058	1376	149	39	\N	1	\N
1059	1396	26	1925993	\N	1	\N
1060	1397	26	1855897	\N	1	\N
1061	1398	26	1499564	\N	1	\N
1062	1399	26	478887	\N	1	\N
1063	1400	26	266277	\N	1	\N
1064	1401	26	222475	\N	1	\N
1065	1402	26	37226	\N	1	\N
1066	1403	26	30940	\N	1	\N
1067	1404	26	27017	\N	1	\N
1068	1405	26	25693	\N	1	\N
1069	1406	26	22653	\N	1	\N
1070	1407	26	18216	\N	1	\N
1071	1408	26	13698	\N	1	\N
1072	1409	26	1536	\N	1	\N
1073	1410	26	1512	\N	1	\N
1074	1411	26	935	\N	1	\N
1075	1412	26	61	\N	1	\N
1076	1413	26	2	\N	1	\N
1077	1414	26	1809693	\N	1	\N
1078	1415	26	1809693	\N	1	\N
1079	1416	26	22	\N	1	\N
1080	1417	129	22	\N	0	\N
1081	1417	254	478887	\N	4	\N
1082	1417	12	18216	\N	12	\N
1083	1417	176	61	\N	17	\N
1084	1417	205	222475	\N	6	\N
1085	1417	125	266277	\N	5	\N
1086	1417	56	1809693	\N	0	\N
1087	1417	126	935	\N	16	\N
1088	1417	35	1499564	\N	3	\N
1089	1417	127	25693	\N	10	\N
1090	1417	208	1536	\N	14	\N
1091	1417	179	1925993	\N	1	\N
1092	1417	180	30940	\N	8	\N
1093	1417	100	1809693	\N	0	\N
1094	1417	82	13698	\N	13	\N
1095	1417	257	27017	\N	9	\N
1096	1417	255	22653	\N	11	\N
1097	1417	238	2	\N	18	\N
1098	1417	256	37226	\N	7	\N
1099	1417	124	1512	\N	15	\N
1100	1417	178	1855897	\N	2	\N
1101	1418	242	4	\N	1	\N
1102	1419	242	4	\N	1	\N
1103	1420	242	2	\N	1	\N
1104	1421	242	2	\N	1	\N
1105	1422	246	2	\N	0	\N
1106	1422	58	4	\N	1	\N
1107	1422	120	4	\N	0	\N
1108	1422	7	2	\N	0	\N
1109	1430	29	99	\N	1	\N
1110	1431	29	99	\N	1	\N
1111	1437	15	52242	\N	1	\N
1112	1437	7	1741	\N	0	\N
1113	1438	7	1740	\N	0	\N
1114	1438	15	52181	\N	1	\N
1115	1439	7	5	\N	0	\N
1116	1439	15	261	\N	1	\N
1117	1440	102	52242	\N	1	\N
1118	1440	7	52181	\N	0	\N
1119	1440	247	261	\N	0	\N
1120	1441	102	1741	\N	1	\N
1121	1441	7	1740	\N	0	\N
1122	1441	247	5	\N	0	\N
1123	1442	8	10566	\N	1	\N
1124	1443	253	10566	\N	1	\N
1125	1446	8	1469992	\N	1	\N
1126	1447	35	1469992	\N	1	\N
1127	1452	8	937120	\N	1	\N
1128	1453	8	167821	\N	1	\N
1129	1454	8	25	\N	1	\N
1130	1455	8	21	\N	1	\N
1131	1456	8	11	\N	1	\N
1132	1457	8	11	\N	1	\N
1133	1458	8	1	\N	1	\N
1134	1459	8	1	\N	1	\N
1135	1460	8	110159	\N	1	\N
1136	1461	8	39	\N	1	\N
1137	1462	8	11	\N	1	\N
1138	1463	8	11	\N	1	\N
1139	1464	8	2	\N	1	\N
1140	1465	177	21	\N	4	\N
1141	1465	129	110159	\N	0	\N
1142	1465	246	11	\N	0	\N
1143	1465	252	1	\N	7	\N
1144	1465	88	937120	\N	1	\N
1145	1465	59	1	\N	8	\N
1146	1465	127	11	\N	6	\N
1147	1465	248	25	\N	3	\N
1148	1465	247	2	\N	0	\N
1149	1465	12	11	\N	5	\N
1150	1465	7	39	\N	0	\N
1151	1465	120	11	\N	0	\N
1152	1465	207	167821	\N	2	\N
1153	1473	8	1172	\N	1	\N
1154	1474	8	6	\N	1	\N
1155	1475	8	2	\N	1	\N
1156	1476	107	1172	\N	1	\N
1157	1476	87	6	\N	0	\N
1158	1476	7	2	\N	0	\N
1159	1484	110	216	\N	1	\N
1160	1485	118	216	\N	0	\N
1161	1498	8	4430	\N	1	\N
1162	1499	128	4430	\N	1	\N
1163	1506	8	189350	\N	1	\N
1164	1507	197	189350	\N	1	\N
1165	1526	120	76	\N	0	\N
1166	1526	246	476	\N	2	\N
1167	1526	7	476	\N	0	\N
1168	1526	95	18	\N	3	\N
1169	1526	206	18700	\N	1	\N
1170	1527	100	1418	\N	1	\N
1171	1527	56	1418	\N	0	\N
1172	1528	56	197	\N	0	\N
1173	1528	100	197	\N	1	\N
1174	1529	180	18700	\N	1	\N
1175	1530	178	1418	\N	1	\N
1176	1530	125	197	\N	2	\N
1177	1531	180	476	\N	1	\N
1178	1532	180	18	\N	1	\N
1179	1533	125	197	\N	2	\N
1180	1533	178	1418	\N	1	\N
1181	1534	180	476	\N	1	\N
1182	1535	180	76	\N	1	\N
1183	1548	8	5950	\N	1	\N
1184	1553	253	5950	\N	1	\N
1185	1554	8	2492	\N	1	\N
1186	1555	8	2492	\N	1	\N
1187	1556	243	1206643	\N	1	\N
1188	1557	8	1203711	\N	1	\N
1189	1557	33	9	\N	0	\N
1190	1558	179	1206643	\N	1	\N
1191	1559	243	1203711	\N	1	\N
1192	1560	243	9	\N	1	\N
1193	1572	14	178	\N	3	\N
1194	1572	249	268	\N	2	\N
1195	1572	56	268	\N	0	\N
1196	1572	13	66463	\N	1	\N
1197	1572	100	268	\N	0	\N
1198	1573	73	66463	\N	1	\N
1199	1574	73	268	\N	1	\N
1200	1575	73	178	\N	1	\N
1201	1576	73	268	\N	1	\N
1202	1577	73	268	\N	1	\N
1203	1578	230	2	\N	0	\N
1204	1578	97	14	\N	1	\N
1205	1578	122	8	\N	0	\N
1206	1579	230	2	\N	0	\N
1207	1579	97	8	\N	0	\N
1208	1579	122	12	\N	1	\N
1209	1580	230	2	\N	1	\N
1210	1580	97	2	\N	0	\N
1211	1580	122	2	\N	0	\N
1212	1581	62	1	\N	1	\N
1213	1582	32	1	\N	1	\N
1214	1583	230	2	\N	0	\N
1215	1583	97	14	\N	1	\N
1216	1583	122	8	\N	0	\N
1217	1584	97	8	\N	0	\N
1218	1584	122	12	\N	1	\N
1219	1584	230	2	\N	0	\N
1220	1585	122	2	\N	0	\N
1221	1585	230	2	\N	1	\N
1222	1585	97	2	\N	0	\N
1223	1586	62	1	\N	1	\N
1224	1587	32	1	\N	1	\N
1225	1597	8	1592	\N	1	\N
1226	1598	8	2	\N	1	\N
1227	1599	8	1592	\N	1	\N
1228	1599	7	2	\N	0	\N
1229	1600	8	10680	\N	0	\N
1230	1600	38	10680	\N	1	\N
1231	1600	33	79	\N	2	\N
1232	1601	8	4384	\N	0	\N
1233	1601	33	52	\N	2	\N
1234	1601	38	4384	\N	1	\N
1235	1602	38	57	\N	1	\N
1236	1602	8	57	\N	0	\N
1237	1603	38	46	\N	1	\N
1238	1603	8	46	\N	0	\N
1239	1604	8	46	\N	0	\N
1240	1604	38	46	\N	1	\N
1241	1607	8	29	\N	0	\N
1242	1607	38	29	\N	1	\N
1243	1609	8	28	\N	0	\N
1244	1609	38	28	\N	1	\N
1245	1610	7	46	\N	0	\N
1246	1610	246	46	\N	0	\N
1247	1610	120	57	\N	3	\N
1248	1610	34	29	\N	0	\N
1249	1610	253	10680	\N	1	\N
1250	1610	128	4384	\N	2	\N
1251	1610	211	28	\N	0	\N
1252	1611	128	52	\N	2	\N
1253	1611	253	79	\N	1	\N
1254	1612	246	46	\N	0	\N
1255	1612	34	29	\N	0	\N
1256	1612	128	4384	\N	2	\N
1257	1612	253	10680	\N	1	\N
1258	1612	7	46	\N	0	\N
1259	1612	120	57	\N	3	\N
1260	1612	211	28	\N	0	\N
1261	1613	215	2	\N	1	\N
1262	1614	8	2	\N	1	\N
1263	1621	225	788642	\N	1	\N
1264	1622	225	1	\N	1	\N
1265	1623	225	788642	\N	1	\N
1266	1624	225	788642	\N	1	\N
1267	1625	56	788642	\N	0	\N
1268	1625	177	1	\N	2	\N
1269	1625	100	788642	\N	0	\N
1270	1625	249	788642	\N	1	\N
1271	1635	236	2	\N	1	\N
1272	1636	80	2	\N	1	\N
1273	1649	131	3	\N	2	\N
1274	1649	17	7	\N	1	\N
1275	1650	17	7	\N	1	\N
1276	1651	17	3	\N	1	\N
1277	1665	2	1925993	\N	1	\N
1278	1666	179	1925993	\N	1	\N
1279	1667	78	1647611	\N	1	\N
1280	1668	78	116070	\N	1	\N
1281	1669	78	33914	\N	1	\N
1282	1670	78	26690	\N	1	\N
1283	1671	78	21662	\N	1	\N
1284	1672	78	13505	\N	1	\N
1285	1673	78	101948	\N	1	\N
1286	1674	78	101948	\N	1	\N
1287	1675	257	26690	\N	4	\N
1288	1675	179	1647611	\N	1	\N
1289	1675	178	116070	\N	2	\N
1290	1675	125	21662	\N	5	\N
1291	1675	256	33914	\N	3	\N
1292	1675	56	101948	\N	0	\N
1293	1675	82	13505	\N	6	\N
1294	1675	100	101948	\N	0	\N
1295	1680	59	4804	\N	1	\N
1296	1681	75	4804	\N	1	\N
1297	1687	8	240943	\N	1	\N
1298	1688	8	222794	\N	1	\N
1299	1689	8	222794	\N	1	\N
1300	1690	56	222794	\N	0	\N
1301	1690	100	222794	\N	0	\N
1302	1690	125	240943	\N	1	\N
1303	1711	215	671	\N	1	\N
1304	1712	215	2	\N	1	\N
1305	1713	7	2	\N	0	\N
1306	1713	15	671	\N	1	\N
1307	1720	8	231327	\N	1	\N
1308	1721	8	231305	\N	1	\N
1309	1722	8	231305	\N	1	\N
1310	1723	56	231305	\N	0	\N
1311	1723	100	231305	\N	0	\N
1312	1723	178	231327	\N	1	\N
1313	1724	8	36968	\N	1	\N
1314	1725	8	11523	\N	1	\N
1315	1726	256	36968	\N	1	\N
1316	1726	82	11523	\N	2	\N
1317	1727	33	264637	\N	1	\N
1318	1728	33	135	\N	1	\N
1319	1729	131	48	\N	1	\N
1320	1730	33	73	\N	1	\N
1321	1731	33	40	\N	1	\N
1322	1732	33	32	\N	1	\N
1323	1733	33	21	\N	1	\N
1324	1734	33	4	\N	1	\N
1325	1735	33	3	\N	1	\N
1326	1736	8	264637	\N	1	\N
1327	1736	7	3	\N	0	\N
1328	1736	239	40	\N	0	\N
1329	1736	38	73	\N	0	\N
1330	1736	99	135	\N	2	\N
1331	1736	39	21	\N	0	\N
1332	1736	185	32	\N	0	\N
1333	1736	139	4	\N	0	\N
1334	1737	89	48	\N	1	\N
1335	1746	184	32	\N	1	\N
1336	1746	155	1	\N	3	\N
1337	1746	201	14	\N	2	\N
1338	1746	97	1	\N	4	\N
1339	1746	118	314	\N	0	\N
1340	1747	201	6	\N	1	\N
1341	1747	118	3	\N	0	\N
1342	1748	118	7	\N	0	\N
1343	1749	118	6	\N	0	\N
1344	1750	118	5	\N	0	\N
1345	1751	118	4	\N	0	\N
1346	1752	118	4	\N	0	\N
1347	1753	118	2	\N	0	\N
1348	1754	118	2	\N	0	\N
1349	1755	97	32	\N	1	\N
1350	1756	122	6	\N	0	\N
1351	1756	97	14	\N	1	\N
1352	1757	97	1	\N	1	\N
1353	1758	97	1	\N	1	\N
1354	1759	32	2	\N	0	\N
1355	1759	62	7	\N	0	\N
1356	1759	229	5	\N	0	\N
1357	1759	9	6	\N	0	\N
1358	1759	122	3	\N	0	\N
1359	1759	119	4	\N	0	\N
1360	1759	147	4	\N	0	\N
1361	1759	97	314	\N	1	\N
1362	1759	230	2	\N	0	\N
1363	1760	64	926	\N	1	\N
1364	1761	64	2	\N	1	\N
1365	1762	7	2	\N	0	\N
1366	1762	15	926	\N	1	\N
1367	1774	8	2365714	\N	1	\N
1368	1775	8	484212	\N	1	\N
1369	1776	36	484212	\N	2	\N
1370	1776	233	2365714	\N	1	\N
1371	1809	190	1512	\N	1	\N
1372	1810	124	1512	\N	1	\N
1373	1819	7	1086	\N	0	\N
1374	1819	8	105685	\N	1	\N
1375	1820	237	105685	\N	1	\N
1376	1821	237	1086	\N	1	\N
1377	1822	8	29832	\N	1	\N
1378	1822	33	12	\N	2	\N
1379	1823	101	29832	\N	1	\N
1380	1824	101	12	\N	1	\N
1381	1831	8	419	\N	1	\N
1382	1832	8	419	\N	1	\N
1383	1838	192	246	\N	2	\N
1384	1838	25	738	\N	1	\N
1385	1839	213	738	\N	1	\N
1386	1840	213	246	\N	1	\N
1387	1851	8	6257	\N	2	\N
1388	1851	91	10759	\N	1	\N
1389	1852	8	2767	\N	2	\N
1390	1852	91	4436	\N	1	\N
1391	1853	91	194	\N	1	\N
1392	1854	91	150	\N	1	\N
1393	1855	91	150	\N	1	\N
1394	1856	91	101	\N	1	\N
1395	1857	91	93	\N	1	\N
1396	1858	120	194	\N	3	\N
1397	1858	246	150	\N	0	\N
1398	1858	211	93	\N	0	\N
1399	1858	253	10759	\N	1	\N
1400	1858	128	4436	\N	2	\N
1401	1858	7	150	\N	0	\N
1402	1858	34	101	\N	0	\N
1403	1859	128	2767	\N	2	\N
1404	1859	253	6257	\N	1	\N
1405	1864	8	18291	\N	1	\N
1406	1865	180	18291	\N	1	\N
1407	1868	129	4310	\N	1	\N
1408	1869	208	4310	\N	1	\N
1409	1881	8	38305	\N	1	\N
1410	1881	33	2	\N	2	\N
1411	1882	101	38305	\N	1	\N
1412	1883	101	2	\N	1	\N
1413	1913	8	4427	\N	1	\N
1414	1914	128	4427	\N	1	\N
1415	1931	143	935	\N	1	\N
1416	1932	126	935	\N	1	\N
1417	1933	8	10556	\N	1	\N
1418	1934	253	10556	\N	1	\N
1419	1935	8	56025	\N	1	\N
1420	1936	79	56025	\N	1	\N
1421	1945	56	36067	\N	0	\N
1422	1945	181	36067	\N	1	\N
1423	1946	210	36067	\N	1	\N
1424	1947	210	36067	\N	1	\N
1425	1979	78	1	\N	1	\N
1426	1980	262	1	\N	1	\N
1427	1985	8	61834	\N	1	\N
1428	1986	8	1	\N	1	\N
1429	1987	101	61834	\N	1	\N
1430	1987	14	1	\N	0	\N
1431	1995	235	36448	\N	1	\N
1432	1995	56	36448	\N	0	\N
1433	1996	56	36448	\N	0	\N
1434	1996	235	36448	\N	1	\N
1435	1997	84	36448	\N	1	\N
1436	1997	56	36448	\N	0	\N
1437	1998	56	36448	\N	0	\N
1438	1998	84	36448	\N	1	\N
1439	2032	52	1512	\N	1	\N
1440	2033	52	1512	\N	1	\N
1441	2034	190	1512	\N	1	\N
1442	2034	74	1512	\N	2	\N
1443	2035	8	705597	\N	1	\N
1444	2036	35	705597	\N	1	\N
1445	2045	2	6168	\N	1	\N
1446	2046	2	1	\N	1	\N
1447	2051	14	6168	\N	1	\N
1448	2051	101	1	\N	0	\N
1449	2056	59	485429	\N	1	\N
1450	2057	36	485429	\N	1	\N
1451	2062	8	3406	\N	1	\N
1452	2063	8	3406	\N	1	\N
1453	2086	245	8	\N	1	\N
1454	2087	228	8	\N	1	\N
1455	2089	8	70896	\N	1	\N
1456	2090	202	70896	\N	1	\N
1457	2101	52	1512	\N	1	\N
1458	2102	52	1512	\N	1	\N
1459	2103	190	1512	\N	1	\N
1460	2103	74	1512	\N	2	\N
1461	2108	201	8	\N	1	\N
1462	2108	118	5902	\N	0	\N
1463	2109	118	1794	\N	0	\N
1464	2110	201	5	\N	1	\N
1465	2110	118	2	\N	0	\N
1466	2111	118	8	\N	0	\N
1467	2112	118	6	\N	0	\N
1468	2113	118	4	\N	0	\N
1469	2114	118	4	\N	0	\N
1470	2115	118	1	\N	0	\N
1471	2115	201	1	\N	1	\N
1472	2116	118	2	\N	0	\N
1473	2117	122	5	\N	0	\N
1474	2117	97	8	\N	1	\N
1475	2117	32	1	\N	0	\N
1476	2118	32	1	\N	0	\N
1477	2118	62	8	\N	0	\N
1478	2118	229	1794	\N	0	\N
1479	2118	9	6	\N	0	\N
1480	2118	122	2	\N	0	\N
1481	2118	119	4	\N	0	\N
1482	2118	147	4	\N	0	\N
1483	2118	97	5902	\N	1	\N
1484	2118	230	2	\N	0	\N
1485	2122	8	2312129	\N	1	\N
1486	2123	233	2312129	\N	1	\N
1487	2129	8	304023	\N	1	\N
1488	2129	33	4	\N	2	\N
1489	2130	53	304023	\N	1	\N
1490	2131	53	4	\N	1	\N
1491	2136	99	32	\N	0	\N
1492	2136	139	32	\N	1	\N
1493	2137	99	32	\N	0	\N
1494	2137	139	32	\N	1	\N
1495	2138	185	32	\N	1	\N
1496	2138	99	32	\N	0	\N
1497	2139	99	32	\N	0	\N
1498	2139	185	32	\N	1	\N
1499	2144	8	10558	\N	1	\N
1500	2145	8	4432	\N	1	\N
1501	2150	128	4432	\N	2	\N
1502	2150	253	10558	\N	1	\N
1503	2151	8	1461783	\N	1	\N
1504	2152	8	29143	\N	1	\N
1505	2153	8	9515	\N	1	\N
1506	2154	174	9515	\N	3	\N
1507	2154	4	1461783	\N	1	\N
1508	2154	187	29143	\N	2	\N
1509	2160	196	775	\N	1	\N
1510	2161	205	775	\N	1	\N
1511	2187	8	25221	\N	1	\N
1512	2188	180	25221	\N	1	\N
1513	2191	177	2334482	\N	1	\N
1514	2192	104	2334482	\N	1	\N
1515	2203	8	18834	\N	1	\N
1516	2203	99	11	\N	2	\N
1517	2204	138	272	\N	0	\N
1518	2204	259	975	\N	1	\N
1519	2204	161	88	\N	0	\N
1520	2204	137	615	\N	0	\N
1521	2205	89	45	\N	1	\N
1522	2206	99	2	\N	1	\N
1523	2207	259	615	\N	0	\N
1524	2207	137	615	\N	1	\N
1525	2208	259	272	\N	0	\N
1526	2208	138	272	\N	1	\N
1527	2209	259	88	\N	0	\N
1528	2209	161	88	\N	1	\N
1529	2210	8	18834	\N	1	\N
1530	2211	63	615	\N	0	\N
1531	2211	138	88	\N	0	\N
1532	2211	259	975	\N	1	\N
1533	2211	137	272	\N	0	\N
1534	2212	89	45	\N	1	\N
1535	2213	99	2	\N	2	\N
1536	2213	8	11	\N	1	\N
1537	2214	63	615	\N	1	\N
1538	2214	259	615	\N	0	\N
1539	2215	259	272	\N	0	\N
1540	2215	137	272	\N	1	\N
1541	2216	259	88	\N	0	\N
1542	2216	138	88	\N	1	\N
1543	2252	133	38106	\N	1	\N
1544	2253	133	573	\N	1	\N
1545	2254	133	38106	\N	1	\N
1546	2255	133	573	\N	1	\N
1547	2256	133	568	\N	1	\N
1548	2257	7	573	\N	0	\N
1549	2257	56	38106	\N	0	\N
1550	2257	60	38106	\N	1	\N
1551	2257	120	568	\N	0	\N
1552	2257	246	573	\N	2	\N
1553	2270	102	52	\N	1	\N
1554	2270	7	52	\N	0	\N
1555	2271	102	52	\N	1	\N
1556	2271	7	52	\N	0	\N
1557	2272	7	52	\N	0	\N
1558	2272	102	52	\N	1	\N
1559	2273	102	52	\N	1	\N
1560	2273	7	52	\N	0	\N
1561	2275	66	44	\N	3	\N
1562	2275	154	67	\N	2	\N
1563	2275	38	73	\N	0	\N
1564	2275	7	2	\N	0	\N
1565	2275	8	931	\N	1	\N
1566	2275	99	6	\N	4	\N
1567	2276	8	6	\N	1	\N
1568	2277	99	6	\N	2	\N
1569	2277	8	931	\N	1	\N
1570	2278	8	67	\N	1	\N
1571	2279	8	44	\N	1	\N
1572	2280	8	6	\N	1	\N
1573	2281	8	73	\N	1	\N
1574	2282	8	2	\N	1	\N
1575	2283	8	4428	\N	1	\N
1576	2284	128	4428	\N	1	\N
1577	2291	8	350	\N	1	\N
1578	2292	8	6	\N	1	\N
1579	2293	8	350	\N	1	\N
1580	2293	7	6	\N	0	\N
1581	2299	120	40827	\N	1	\N
1582	2299	246	40827	\N	0	\N
1583	2299	7	40827	\N	0	\N
1584	2300	120	5455	\N	1	\N
1585	2300	7	5455	\N	0	\N
1586	2300	246	5455	\N	0	\N
1587	2301	120	862	\N	1	\N
1588	2301	7	862	\N	0	\N
1589	2301	246	862	\N	0	\N
1590	2302	120	40827	\N	1	\N
1591	2302	7	40827	\N	0	\N
1592	2302	246	40827	\N	0	\N
1593	2303	246	550	\N	0	\N
1594	2303	7	550	\N	0	\N
1595	2303	120	550	\N	1	\N
1596	2304	83	5455	\N	2	\N
1597	2304	56	40827	\N	0	\N
1598	2304	60	40827	\N	1	\N
1599	2304	150	862	\N	3	\N
1600	2304	105	550	\N	0	\N
1601	2305	56	40827	\N	0	\N
1602	2305	83	5455	\N	2	\N
1603	2305	105	550	\N	0	\N
1604	2305	60	40827	\N	1	\N
1605	2305	150	862	\N	3	\N
1606	2306	60	40827	\N	1	\N
1607	2306	105	550	\N	0	\N
1608	2306	56	40827	\N	0	\N
1609	2306	83	5455	\N	2	\N
1610	2306	150	862	\N	3	\N
1611	2309	15	17455	\N	1	\N
1612	2309	7	78	\N	0	\N
1613	2310	154	17455	\N	1	\N
1614	2311	154	78	\N	1	\N
1615	2314	196	716	\N	1	\N
1616	2315	205	716	\N	1	\N
1617	2317	3	719328	\N	1	\N
1618	2318	33	61	\N	0	\N
1619	2318	8	712357	\N	1	\N
1620	2319	179	719328	\N	1	\N
1621	2320	3	712357	\N	1	\N
1622	2321	3	61	\N	1	\N
1623	2322	7	2856439	\N	1	\N
1624	2322	120	2854237	\N	0	\N
1625	2322	246	2854240	\N	0	\N
1626	2322	129	1688	\N	0	\N
1627	2323	91	16	\N	1	\N
1628	2324	7	2856125	\N	1	\N
1629	2324	120	2853933	\N	0	\N
1630	2324	246	2853936	\N	0	\N
1631	2324	129	1688	\N	0	\N
1632	2325	7	2856107	\N	1	\N
1633	2325	129	1688	\N	0	\N
1634	2325	120	2853915	\N	0	\N
1635	2325	246	2853918	\N	0	\N
1636	2326	8	525	\N	1	\N
1637	2327	7	1236	\N	1	\N
1638	2327	246	1060	\N	0	\N
1639	2327	120	1060	\N	0	\N
1640	2327	129	90	\N	0	\N
1641	2328	7	6	\N	0	\N
1642	2328	246	6	\N	0	\N
1643	2328	120	6	\N	1	\N
1644	2329	120	2856107	\N	0	\N
1645	2329	246	2856125	\N	0	\N
1646	2329	129	1236	\N	0	\N
1647	2329	7	2856439	\N	1	\N
1648	2329	247	6	\N	0	\N
1649	2330	91	16	\N	1	\N
1650	2331	246	2853936	\N	0	\N
1651	2331	120	2853918	\N	0	\N
1652	2331	129	1060	\N	0	\N
1653	2331	7	2854240	\N	1	\N
1654	2331	247	6	\N	0	\N
1655	2332	246	2853933	\N	0	\N
1656	2332	120	2853915	\N	0	\N
1657	2332	7	2854237	\N	1	\N
1658	2332	129	1060	\N	0	\N
1659	2332	247	6	\N	0	\N
1660	2333	120	1688	\N	1	\N
1661	2333	246	1688	\N	0	\N
1662	2333	7	1688	\N	0	\N
1663	2333	129	90	\N	0	\N
1664	2334	8	525	\N	1	\N
1665	2346	8	702263	\N	1	\N
1666	2346	33	911	\N	2	\N
1667	2347	8	207751	\N	1	\N
1668	2348	77	207751	\N	2	\N
1669	2348	244	702263	\N	1	\N
1670	2349	244	911	\N	1	\N
1671	2357	59	1534	\N	1	\N
1672	2358	208	1534	\N	1	\N
1673	2363	212	26	\N	1	\N
1674	2374	212	26	\N	1	\N
1675	2375	170	803170	\N	1	\N
1676	2376	170	99962	\N	1	\N
1677	2377	257	99962	\N	2	\N
1678	2377	179	803170	\N	1	\N
1679	2379	99	941	\N	1	\N
1680	2381	99	941	\N	1	\N
1681	2382	112	411336	\N	0	\N
1682	2382	113	479066	\N	1	\N
1683	2383	254	479066	\N	1	\N
1684	2384	254	411336	\N	1	\N
1685	2392	209	30328	\N	1	\N
1686	2393	209	30328	\N	1	\N
1687	2394	84	30328	\N	1	\N
1688	2394	56	30328	\N	0	\N
1689	2396	37	142530	\N	1	\N
1690	2397	37	1721	\N	1	\N
1691	2398	37	20	\N	1	\N
1692	2399	105	1721	\N	2	\N
1693	2399	144	142530	\N	1	\N
1694	2399	150	20	\N	0	\N
1695	2402	8	1152	\N	1	\N
1696	2404	13	1152	\N	1	\N
1697	2414	212	7479	\N	1	\N
1698	2415	212	7479	\N	1	\N
1699	2426	258	8	\N	1	\N
1700	2426	56	8	\N	0	\N
1701	2427	56	8	\N	0	\N
1702	2427	258	8	\N	1	\N
1703	2428	258	8	\N	1	\N
1704	2428	56	8	\N	0	\N
1705	2429	56	8	\N	0	\N
1706	2429	258	8	\N	1	\N
1707	2470	59	935	\N	1	\N
1708	2471	126	935	\N	1	\N
1709	2478	8	4433	\N	1	\N
1710	2479	128	4433	\N	1	\N
1711	2482	8	3479	\N	1	\N
1712	2483	253	3479	\N	1	\N
1713	2527	242	10	\N	1	\N
1714	2528	242	10	\N	1	\N
1715	2529	242	6	\N	1	\N
1716	2530	242	6	\N	1	\N
1717	2531	246	6	\N	0	\N
1718	2531	58	10	\N	1	\N
1719	2531	120	10	\N	0	\N
1720	2531	7	6	\N	0	\N
1721	2532	8	3650368	\N	1	\N
1722	2532	33	104	\N	0	\N
1723	2533	2	3650368	\N	1	\N
1724	2534	2	104	\N	1	\N
1725	2536	247	148038	\N	0	\N
1726	2536	57	3454	\N	0	\N
1727	2536	211	23	\N	0	\N
1728	2536	248	1	\N	0	\N
1729	2536	102	42	\N	2	\N
1730	2536	7	523980	\N	0	\N
1731	2536	120	156355	\N	0	\N
1732	2536	204	24	\N	0	\N
1733	2536	246	524230	\N	1	\N
1734	2536	232	113	\N	0	\N
1735	2536	58	48	\N	0	\N
1736	2536	129	11	\N	0	\N
1737	2536	81	31	\N	0	\N
1738	2536	34	50	\N	0	\N
1739	2536	123	2850	\N	0	\N
1740	2536	231	3865	\N	0	\N
1741	2536	11	1675	\N	0	\N
1742	2537	123	2852	\N	0	\N
1743	2537	102	42	\N	2	\N
1744	2537	231	3865	\N	0	\N
1745	2537	247	148009	\N	0	\N
1746	2537	232	113	\N	0	\N
1747	2537	57	3454	\N	0	\N
1748	2537	34	50	\N	0	\N
1749	2537	7	523835	\N	0	\N
1750	2537	120	156287	\N	0	\N
1751	2537	11	1675	\N	0	\N
1752	2537	81	31	\N	0	\N
1753	2537	246	523869	\N	1	\N
1754	2537	129	11	\N	0	\N
1755	2537	58	48	\N	0	\N
1756	2537	211	23	\N	0	\N
1757	2537	204	24	\N	0	\N
1758	2537	248	1	\N	0	\N
1759	2538	102	42	\N	0	\N
1760	2538	34	1	\N	0	\N
1761	2538	247	3	\N	0	\N
1762	2538	81	1	\N	0	\N
1763	2538	7	87	\N	1	\N
1764	2538	246	45	\N	0	\N
1765	2538	211	1	\N	0	\N
1766	2538	58	1	\N	0	\N
1767	2538	120	11	\N	0	\N
1768	2539	102	524230	\N	1	\N
1769	2539	7	523869	\N	0	\N
1770	2539	247	45	\N	0	\N
1771	2540	7	42	\N	0	\N
1772	2540	247	42	\N	0	\N
1773	2540	102	42	\N	1	\N
1774	2541	102	523980	\N	1	\N
1775	2541	7	523835	\N	0	\N
1776	2541	247	87	\N	0	\N
1777	2542	102	156355	\N	1	\N
1778	2542	7	156287	\N	0	\N
1779	2542	247	11	\N	0	\N
1780	2543	102	148038	\N	1	\N
1781	2543	7	148009	\N	0	\N
1782	2543	247	3	\N	0	\N
1783	2544	7	3865	\N	0	\N
1784	2544	102	3865	\N	1	\N
1785	2545	102	3454	\N	1	\N
1786	2545	7	3454	\N	0	\N
1787	2546	7	2852	\N	1	\N
1788	2546	102	2850	\N	0	\N
1789	2547	7	1675	\N	0	\N
1790	2547	102	1675	\N	1	\N
1791	2548	7	113	\N	0	\N
1792	2548	102	113	\N	1	\N
1793	2549	7	50	\N	0	\N
1794	2549	247	1	\N	0	\N
1795	2549	102	50	\N	1	\N
1796	2550	102	48	\N	1	\N
1797	2550	7	48	\N	0	\N
1798	2550	247	1	\N	0	\N
1799	2551	247	1	\N	0	\N
1800	2551	7	31	\N	0	\N
1801	2551	102	31	\N	1	\N
1802	2552	102	24	\N	1	\N
1803	2552	7	24	\N	0	\N
1804	2553	102	23	\N	1	\N
1805	2553	247	1	\N	0	\N
1806	2553	7	23	\N	0	\N
1807	2554	102	11	\N	1	\N
1808	2554	7	11	\N	0	\N
1809	2555	102	1	\N	1	\N
1810	2555	7	1	\N	0	\N
1811	2556	216	6	\N	1	\N
1812	2557	134	6	\N	1	\N
1813	2565	8	1585	\N	1	\N
1814	2566	128	1585	\N	1	\N
1815	2567	59	4134	\N	1	\N
1816	2568	59	6	\N	1	\N
1817	2569	59	2	\N	1	\N
1818	2570	7	2	\N	0	\N
1819	2570	107	4134	\N	1	\N
1820	2570	87	6	\N	0	\N
1821	2574	8	924630	\N	1	\N
1822	2575	88	924630	\N	1	\N
1823	2580	177	13593	\N	1	\N
1824	2581	82	13593	\N	1	\N
1825	2583	86	25152	\N	1	\N
1826	2584	257	25152	\N	1	\N
1827	2585	8	28135	\N	1	\N
1828	2586	8	13	\N	1	\N
1829	2587	129	13	\N	0	\N
1830	2587	127	28135	\N	1	\N
1831	2604	78	18216	\N	1	\N
1832	2605	78	2	\N	1	\N
1833	2606	78	11	\N	1	\N
1834	2607	238	2	\N	2	\N
1835	2607	129	11	\N	0	\N
1836	2607	12	18216	\N	1	\N
1837	2608	2	1925993	\N	1	\N
1838	2609	179	1925993	\N	1	\N
1839	2619	8	1054923	\N	1	\N
1840	2620	8	1289	\N	1	\N
1841	2621	116	1054923	\N	1	\N
1842	2621	13	1289	\N	2	\N
1843	2626	8	68440	\N	1	\N
1844	2627	79	68440	\N	1	\N
1845	2634	52	1512	\N	1	\N
1846	2635	52	1512	\N	1	\N
1847	2636	52	1512	\N	1	\N
1848	2637	221	1512	\N	1	\N
1849	2637	190	1512	\N	2	\N
1850	2637	74	1512	\N	3	\N
1851	2641	8	15117462	\N	1	\N
1852	2642	8	73893	\N	1	\N
1853	2643	8	1285	\N	1	\N
1854	2644	8	330	\N	1	\N
1855	2645	8	73893	\N	1	\N
1856	2646	8	73893	\N	1	\N
1857	2647	129	330	\N	4	\N
1858	2647	249	73893	\N	2	\N
1859	2647	56	73893	\N	0	\N
1860	2647	100	73893	\N	0	\N
1861	2647	13	1285	\N	3	\N
1862	2647	186	15117462	\N	1	\N
1863	2648	104	2068262	\N	1	\N
1864	2649	104	266220	\N	1	\N
1865	2650	177	2	\N	1	\N
1866	2651	104	1893288	\N	1	\N
1867	2652	104	1893288	\N	1	\N
1868	2653	178	2068262	\N	1	\N
1869	2653	125	266220	\N	2	\N
1870	2653	56	1893288	\N	0	\N
1871	2653	100	1893288	\N	0	\N
1872	2654	82	2	\N	1	\N
1873	2661	228	2	\N	1	\N
1874	2662	30	2	\N	1	\N
1875	2684	8	100790	\N	1	\N
1876	2685	79	100790	\N	1	\N
1877	2688	8	35411	\N	1	\N
1878	2689	101	35411	\N	1	\N
1879	2703	174	68468	\N	1	\N
1880	2704	174	68468	\N	1	\N
1881	2705	174	68468	\N	1	\N
1882	2706	100	68468	\N	0	\N
1883	2706	249	68468	\N	1	\N
1884	2706	56	68468	\N	0	\N
1885	2745	8	178	\N	1	\N
1886	2746	8	2	\N	1	\N
1887	2747	8	178	\N	1	\N
1888	2747	7	2	\N	0	\N
1889	2749	7	2	\N	0	\N
1890	2749	15	670	\N	1	\N
1891	2750	215	670	\N	1	\N
1892	2751	215	2	\N	1	\N
1893	2754	8	1695228	\N	1	\N
1894	2755	8	160911	\N	1	\N
1895	2756	8	1686526	\N	1	\N
1896	2757	8	1686526	\N	1	\N
1897	2758	56	1686526	\N	0	\N
1898	2758	100	1686526	\N	0	\N
1899	2758	178	1695228	\N	1	\N
1900	2758	125	160911	\N	2	\N
1901	2759	8	598800	\N	1	\N
1902	2760	169	598800	\N	1	\N
1903	2761	73	559566	\N	1	\N
1904	2762	254	559566	\N	1	\N
1905	2763	8	6716303	\N	1	\N
1906	2764	8	630079	\N	1	\N
1907	2765	8	1302	\N	1	\N
1908	2766	8	411056	\N	1	\N
1909	2767	113	411056	\N	0	\N
1910	2767	112	6716303	\N	1	\N
1911	2767	28	630079	\N	2	\N
1912	2767	13	1302	\N	3	\N
1913	2777	52	1512	\N	1	\N
1914	2778	52	1512	\N	1	\N
1915	2779	190	1512	\N	1	\N
1916	2779	74	1512	\N	2	\N
1917	2787	172	8	\N	1	\N
1918	2787	7	5	\N	0	\N
1919	2788	250	8	\N	1	\N
1920	2789	250	5	\N	1	\N
1921	2797	8	25688	\N	1	\N
1922	2798	8	11	\N	1	\N
1923	2799	129	11	\N	0	\N
1924	2799	127	25688	\N	1	\N
1925	2801	59	935	\N	1	\N
1926	2802	126	935	\N	1	\N
1927	2803	102	754327	\N	1	\N
1928	2803	247	77	\N	0	\N
1929	2803	7	754084	\N	0	\N
1930	2804	123	212	\N	1	\N
1931	2805	47	1	\N	1	\N
1932	2805	163	1	\N	0	\N
1933	2806	7	523869	\N	0	\N
1934	2806	102	524231	\N	1	\N
1935	2806	247	45	\N	0	\N
1936	2807	102	331655	\N	1	\N
1937	2807	247	31	\N	0	\N
1938	2807	7	331514	\N	0	\N
1939	2808	247	32	\N	0	\N
1940	2808	102	230741	\N	1	\N
1941	2808	7	230460	\N	0	\N
1942	2809	7	156289	\N	0	\N
1943	2809	247	11	\N	0	\N
1944	2809	102	156358	\N	1	\N
1945	2810	102	3865	\N	1	\N
1946	2810	7	3865	\N	0	\N
1947	2811	7	3454	\N	0	\N
1948	2811	102	3454	\N	1	\N
1949	2812	102	2850	\N	0	\N
1950	2812	7	2852	\N	1	\N
1951	2813	7	1675	\N	0	\N
1952	2813	102	1675	\N	1	\N
1953	2814	102	113	\N	1	\N
1954	2814	7	113	\N	0	\N
1955	2815	7	50	\N	0	\N
1956	2815	102	50	\N	1	\N
1957	2815	247	1	\N	0	\N
1958	2816	102	48	\N	1	\N
1959	2816	7	48	\N	0	\N
1960	2816	247	1	\N	0	\N
1961	2817	102	36	\N	1	\N
1962	2817	7	36	\N	0	\N
1963	2818	102	31	\N	1	\N
1964	2818	7	31	\N	0	\N
1965	2818	247	1	\N	0	\N
1966	2819	7	24	\N	0	\N
1967	2819	102	24	\N	1	\N
1968	2820	102	23	\N	1	\N
1969	2820	7	23	\N	0	\N
1970	2820	247	1	\N	0	\N
1971	2821	102	7	\N	1	\N
1972	2821	7	7	\N	0	\N
1973	2822	7	6	\N	0	\N
1974	2822	102	6	\N	1	\N
1975	2823	7	2	\N	0	\N
1976	2823	102	2	\N	1	\N
1977	2824	47	1	\N	1	\N
1978	2824	163	1	\N	0	\N
1979	2825	232	113	\N	0	\N
1980	2825	58	48	\N	0	\N
1981	2825	129	36	\N	0	\N
1982	2825	7	754327	\N	1	\N
1983	2825	87	7	\N	0	\N
1984	2825	247	331655	\N	0	\N
1985	2825	248	230741	\N	0	\N
1986	2825	120	156358	\N	0	\N
1987	2825	231	3865	\N	0	\N
1988	2825	11	1675	\N	0	\N
1989	2825	211	23	\N	0	\N
1990	2825	246	524231	\N	0	\N
1991	2825	123	2850	\N	0	\N
1992	2825	34	50	\N	0	\N
1993	2825	14	6	\N	0	\N
1994	2825	57	3454	\N	0	\N
1995	2825	81	31	\N	0	\N
1996	2825	204	24	\N	0	\N
1997	2825	103	2	\N	0	\N
1998	2826	33	212	\N	1	\N
1999	2827	47	1	\N	1	\N
2000	2827	163	1	\N	0	\N
2001	2828	120	156289	\N	0	\N
2002	2828	57	3454	\N	0	\N
2003	2828	58	48	\N	0	\N
2004	2828	14	6	\N	0	\N
2005	2828	246	523869	\N	0	\N
2006	2828	34	50	\N	0	\N
2007	2828	11	1675	\N	0	\N
2008	2828	204	24	\N	0	\N
2009	2828	129	36	\N	0	\N
2010	2828	7	754084	\N	1	\N
2011	2828	231	3865	\N	0	\N
2012	2828	247	331514	\N	0	\N
2013	2828	248	230460	\N	0	\N
2014	2828	232	113	\N	0	\N
2015	2828	123	2852	\N	0	\N
2016	2828	81	31	\N	0	\N
2017	2828	87	7	\N	0	\N
2018	2828	211	23	\N	0	\N
2019	2828	103	2	\N	0	\N
2020	2829	120	11	\N	0	\N
2021	2829	248	32	\N	0	\N
2022	2829	7	77	\N	1	\N
2023	2829	247	31	\N	0	\N
2024	2829	34	1	\N	0	\N
2025	2829	81	1	\N	0	\N
2026	2829	246	45	\N	0	\N
2027	2829	58	1	\N	0	\N
2028	2829	211	1	\N	0	\N
2029	2830	47	1	\N	1	\N
2030	2830	163	1	\N	0	\N
2031	2832	8	28142	\N	1	\N
2032	2833	8	12	\N	1	\N
2033	2834	129	12	\N	0	\N
2034	2834	127	28142	\N	1	\N
2035	2861	8	1014395	\N	1	\N
2036	2862	8	878078	\N	1	\N
2037	2862	33	5	\N	2	\N
2038	2878	170	878078	\N	2	\N
2039	2878	195	1014395	\N	1	\N
2040	2879	170	5	\N	1	\N
2041	2893	8	1728187	\N	1	\N
2042	2894	226	1728187	\N	1	\N
2043	2895	51	437249	\N	1	\N
2044	2896	24	437249	\N	1	\N
2045	2897	201	3	\N	1	\N
2046	2898	201	3	\N	1	\N
2047	2899	59	1536	\N	1	\N
2048	2900	208	1536	\N	1	\N
2049	2901	13	76984	\N	1	\N
2050	2903	4	76984	\N	1	\N
2051	2922	8	350	\N	1	\N
2052	2923	129	350	\N	1	\N
2053	2929	8	21116	\N	1	\N
2054	2930	233	21116	\N	1	\N
2055	2937	8	18834	\N	1	\N
2056	2938	8	18834	\N	1	\N
2057	2940	247	2	\N	1	\N
2058	2941	33	2	\N	1	\N
2059	2944	8	10497	\N	1	\N
2060	2949	253	10497	\N	1	\N
2061	2954	182	1	\N	1	\N
2062	2955	80	1	\N	1	\N
2063	2990	8	34	\N	1	\N
2064	2991	8	2	\N	1	\N
2065	2992	8	34	\N	1	\N
2066	2992	7	2	\N	0	\N
2067	3022	96	89807	\N	2	\N
2068	3022	188	592849	\N	1	\N
2069	3022	222	774	\N	3	\N
2070	3023	36	592849	\N	1	\N
2071	3024	36	89807	\N	1	\N
2072	3025	36	774	\N	1	\N
2073	3026	101	1053895	\N	1	\N
2074	3026	36	1	\N	2	\N
2075	3026	14	273	\N	0	\N
2076	3028	14	1228	\N	1	\N
2077	3028	13	139	\N	2	\N
2078	3029	116	1053895	\N	1	\N
2079	3030	13	139	\N	1	\N
2080	3031	116	1	\N	1	\N
2081	3032	13	1228	\N	1	\N
2082	3032	116	273	\N	2	\N
2083	3040	207	220519	\N	1	\N
2084	3040	129	37	\N	0	\N
2085	3040	7	4	\N	0	\N
2086	3041	205	220519	\N	1	\N
2087	3042	205	37	\N	1	\N
2088	3043	205	4	\N	1	\N
2089	3053	8	5477	\N	1	\N
2090	3054	8	3066	\N	1	\N
2091	3055	128	3066	\N	2	\N
2092	3055	253	5477	\N	1	\N
2093	3060	28	629419	\N	1	\N
2094	3062	28	629419	\N	1	\N
2095	3063	28	629419	\N	1	\N
2096	3075	249	629419	\N	1	\N
2097	3075	100	629419	\N	0	\N
2098	3075	56	629419	\N	0	\N
2099	3077	215	40	\N	1	\N
2100	3078	215	40	\N	1	\N
2101	3086	195	1016465	\N	1	\N
2102	3087	36	1016465	\N	1	\N
2103	3090	8	30928	\N	1	\N
2104	3091	180	30928	\N	1	\N
2105	3097	100	19815	\N	0	\N
2106	3097	249	19815	\N	1	\N
2107	3097	56	19815	\N	0	\N
2108	3097	202	4524	\N	2	\N
2109	3102	202	19815	\N	1	\N
2110	3103	202	4524	\N	1	\N
2111	3104	202	19815	\N	1	\N
2112	3105	202	19815	\N	1	\N
2113	3106	8	25675	\N	1	\N
2114	3107	8	11	\N	1	\N
2115	3108	129	11	\N	0	\N
2116	3108	127	25675	\N	1	\N
2117	3118	258	253	\N	1	\N
2118	3118	56	253	\N	0	\N
2119	3119	250	1	\N	1	\N
2120	3120	61	253	\N	1	\N
2121	3123	251	1	\N	1	\N
2122	3124	61	253	\N	1	\N
2123	3143	8	1850	\N	1	\N
2124	3143	33	15	\N	2	\N
2125	3144	174	1850	\N	1	\N
2126	3145	174	15	\N	1	\N
2127	3148	227	29442	\N	1	\N
2128	3149	227	60	\N	1	\N
2129	3150	227	2	\N	1	\N
2130	3151	7	2	\N	0	\N
2131	3151	87	60	\N	0	\N
2132	3151	107	29442	\N	1	\N
2133	3153	50	216	\N	1	\N
2134	3154	129	216	\N	1	\N
2135	3178	80	1	\N	1	\N
2136	3179	80	1	\N	1	\N
2137	3189	116	886891	\N	1	\N
2138	3190	116	1	\N	1	\N
2139	3191	116	886891	\N	1	\N
2140	3192	116	886891	\N	1	\N
2141	3193	100	886891	\N	0	\N
2142	3193	249	886891	\N	1	\N
2143	3193	56	886891	\N	0	\N
2144	3193	177	1	\N	2	\N
2145	3195	246	9	\N	0	\N
2146	3195	13	2571	\N	3	\N
2147	3195	249	352003	\N	2	\N
2148	3195	247	9	\N	6	\N
2149	3195	56	352003	\N	0	\N
2150	3195	100	352003	\N	0	\N
2151	3195	8	417554	\N	1	\N
2152	3195	7	86	\N	0	\N
2153	3195	174	252	\N	5	\N
2154	3195	168	640	\N	4	\N
2155	3197	195	417554	\N	1	\N
2156	3198	195	352003	\N	1	\N
2157	3199	195	2571	\N	1	\N
2158	3200	195	640	\N	1	\N
2159	3201	195	252	\N	1	\N
2160	3202	195	9	\N	1	\N
2161	3203	195	352003	\N	1	\N
2162	3204	195	352003	\N	1	\N
2163	3205	195	86	\N	1	\N
2164	3206	195	9	\N	1	\N
2165	3225	8	10515	\N	1	\N
2166	3230	253	10515	\N	1	\N
2167	3236	78	8028	\N	1	\N
2168	3237	176	8028	\N	1	\N
2169	3238	8	2222	\N	1	\N
2170	3239	253	2222	\N	1	\N
2171	3240	129	5651	\N	0	\N
2172	3240	207	16866	\N	4	\N
2173	3240	14	332	\N	0	\N
2174	3240	130	207	\N	7	\N
2175	3240	249	39194	\N	2	\N
2176	3240	107	1644	\N	6	\N
2177	3240	101	31765	\N	3	\N
2178	3240	87	33	\N	0	\N
2179	3240	202	40471	\N	1	\N
2180	3240	13	16	\N	8	\N
2181	3240	174	5200	\N	5	\N
2182	3240	56	39194	\N	0	\N
2183	3240	100	39194	\N	0	\N
2184	3240	7	1	\N	0	\N
2185	3241	103	40471	\N	1	\N
2186	3242	103	39194	\N	1	\N
2187	3243	103	31765	\N	1	\N
2188	3244	103	16866	\N	1	\N
2189	3245	103	5200	\N	1	\N
2190	3246	103	1644	\N	1	\N
2191	3247	103	207	\N	1	\N
2192	3248	103	16	\N	1	\N
2193	3249	103	39194	\N	1	\N
2194	3250	103	39194	\N	1	\N
2195	3251	103	5651	\N	1	\N
2196	3252	103	332	\N	1	\N
2197	3253	103	33	\N	1	\N
2198	3254	103	1	\N	1	\N
2199	3265	100	1	\N	0	\N
2200	3265	249	1	\N	1	\N
2201	3265	56	1	\N	0	\N
2202	3266	249	1	\N	1	\N
2203	3266	56	1	\N	0	\N
2204	3266	100	1	\N	0	\N
2205	3267	249	1	\N	1	\N
2206	3267	100	1	\N	0	\N
2207	3267	56	1	\N	0	\N
2208	3268	100	1	\N	0	\N
2209	3268	56	1	\N	0	\N
2210	3268	178	1	\N	1	\N
2211	3269	56	1	\N	0	\N
2212	3269	178	1	\N	1	\N
2213	3269	100	1	\N	0	\N
2214	3270	178	1	\N	1	\N
2215	3270	100	1	\N	0	\N
2216	3270	56	1	\N	0	\N
2217	3271	8	28135	\N	1	\N
2218	3272	8	11	\N	1	\N
2219	3273	129	11	\N	0	\N
2220	3273	127	28135	\N	1	\N
2221	3274	134	217681	\N	1	\N
2222	3275	237	217681	\N	1	\N
2223	3279	8	27711	\N	1	\N
2224	3280	8	1	\N	1	\N
2225	3281	8	27711	\N	1	\N
2226	3281	7	1	\N	0	\N
2227	3287	75	3525	\N	1	\N
2228	3288	75	1279	\N	1	\N
2229	3289	126	1279	\N	2	\N
2230	3289	208	3525	\N	1	\N
2231	3300	8	20	\N	1	\N
2232	3301	8	20	\N	1	\N
2233	3306	106	244983	\N	1	\N
2234	3307	189	244983	\N	1	\N
2235	3313	8	22587	\N	1	\N
2236	3314	180	22587	\N	1	\N
2237	3317	87	38130	\N	2	\N
2238	3317	100	1	\N	0	\N
2239	3317	255	33	\N	3	\N
2240	3317	56	1	\N	0	\N
2241	3317	249	1	\N	4	\N
2242	3317	202	2302162	\N	1	\N
2243	3317	107	315	\N	0	\N
2244	3318	249	852	\N	3	\N
2245	3318	101	711	\N	4	\N
2246	3318	87	9872	\N	2	\N
2247	3318	100	852	\N	0	\N
2248	3318	107	87	\N	0	\N
2249	3318	7	14	\N	0	\N
2250	3318	202	465749	\N	1	\N
2251	3318	56	852	\N	0	\N
2252	3318	246	14	\N	5	\N
2253	3319	233	2302162	\N	1	\N
2254	3319	36	465749	\N	2	\N
2255	3320	233	38130	\N	1	\N
2256	3320	36	9872	\N	2	\N
2257	3321	36	852	\N	1	\N
2258	3321	233	1	\N	2	\N
2259	3322	36	711	\N	1	\N
2260	3323	233	33	\N	1	\N
2261	3324	36	14	\N	1	\N
2262	3325	233	1	\N	2	\N
2263	3325	36	852	\N	1	\N
2264	3326	36	852	\N	1	\N
2265	3326	233	1	\N	2	\N
2266	3327	36	87	\N	2	\N
2267	3327	233	315	\N	1	\N
2268	3328	36	14	\N	1	\N
2269	3344	8	1925674	\N	1	\N
2270	3345	179	1925674	\N	1	\N
2271	3349	8	2215	\N	1	\N
2272	3354	253	2215	\N	1	\N
2273	3358	9	5	\N	0	\N
2274	3358	230	1	\N	0	\N
2275	3358	97	17	\N	1	\N
2276	3358	122	4	\N	0	\N
2277	3359	149	17	\N	1	\N
2278	3360	149	5	\N	1	\N
2279	3361	149	4	\N	1	\N
2280	3362	149	1	\N	1	\N
2281	3365	193	1925993	\N	1	\N
2282	3366	179	1925993	\N	1	\N
2283	3369	24	436475	\N	1	\N
2284	3369	189	155166	\N	2	\N
2285	3370	189	89221	\N	1	\N
2286	3371	24	774	\N	1	\N
2287	3372	188	436475	\N	1	\N
2288	3372	222	774	\N	0	\N
2289	3373	188	155166	\N	1	\N
2290	3373	96	89221	\N	2	\N
2291	3374	202	1054496	\N	1	\N
2292	3374	177	1	\N	2	\N
2293	3376	116	1054496	\N	1	\N
2294	3377	116	1	\N	1	\N
2295	3390	39	170	\N	1	\N
2296	3390	99	170	\N	0	\N
2297	3391	99	170	\N	0	\N
2298	3391	39	170	\N	1	\N
2299	3392	38	170	\N	1	\N
2300	3392	8	170	\N	0	\N
2301	3393	8	170	\N	0	\N
2302	3393	38	170	\N	1	\N
2303	3394	2	26906	\N	1	\N
2304	3395	257	26906	\N	1	\N
2305	3396	201	5	\N	1	\N
2306	3397	201	5	\N	1	\N
2307	3412	253	17016	\N	1	\N
2308	3413	128	7203	\N	1	\N
2309	3414	128	2767	\N	2	\N
2310	3414	253	6256	\N	1	\N
2311	3415	253	5786	\N	1	\N
2312	3415	128	2609	\N	2	\N
2313	3416	253	5786	\N	1	\N
2314	3416	128	2609	\N	2	\N
2315	3417	231	17016	\N	1	\N
2316	3417	7	5786	\N	0	\N
2317	3417	120	6256	\N	0	\N
2318	3417	246	5786	\N	0	\N
2319	3418	120	2767	\N	0	\N
2320	3418	11	7203	\N	1	\N
2321	3418	7	2609	\N	0	\N
2322	3418	246	2609	\N	0	\N
2323	3423	89	5455	\N	1	\N
2324	3424	83	5455	\N	1	\N
2325	3425	212	96155	\N	1	\N
2326	3426	212	32457	\N	1	\N
2327	3427	212	31524	\N	1	\N
2328	3428	212	32174	\N	1	\N
2329	3429	56	96155	\N	1	\N
2330	3429	235	32174	\N	0	\N
2331	3429	84	32457	\N	0	\N
2332	3429	181	31524	\N	0	\N
2333	3447	149	8	\N	2	\N
2334	3447	250	12	\N	1	\N
2335	3448	251	12	\N	1	\N
2336	3449	251	8	\N	1	\N
2337	3450	199	8	\N	1	\N
2338	3451	228	8	\N	1	\N
2339	3499	78	30752	\N	1	\N
2340	3500	78	1536	\N	1	\N
2341	3501	180	30752	\N	1	\N
2342	3501	208	1536	\N	2	\N
2343	3512	8	1658298	\N	1	\N
2344	3513	8	560871	\N	1	\N
2345	3514	8	37226	\N	1	\N
2346	3515	8	1387642	\N	1	\N
2347	3516	8	1387642	\N	1	\N
2348	3517	56	1387642	\N	0	\N
2349	3517	100	1387642	\N	0	\N
2350	3517	178	1658298	\N	1	\N
2351	3517	73	560871	\N	0	\N
2352	3517	256	37226	\N	0	\N
2353	3527	8	10324	\N	1	\N
2354	3528	253	10324	\N	1	\N
2355	3533	8	4153	\N	1	\N
2356	3534	33	4153	\N	1	\N
2357	3541	8	2853	\N	1	\N
2358	3542	8	891	\N	1	\N
2359	3547	128	891	\N	2	\N
2360	3547	253	2853	\N	1	\N
2361	3550	8	57510	\N	1	\N
2362	3551	8	57510	\N	1	\N
2363	3552	8	57510	\N	1	\N
2364	3553	56	57510	\N	0	\N
2365	3553	100	57510	\N	0	\N
2366	3553	125	57510	\N	1	\N
2367	3557	8	25159	\N	1	\N
2368	3557	33	6	\N	2	\N
2369	3558	8	1	\N	1	\N
2370	3559	101	25159	\N	1	\N
2371	3559	14	1	\N	0	\N
2372	3560	101	6	\N	1	\N
2373	3566	56	767469	\N	0	\N
2374	3566	249	767469	\N	1	\N
2375	3566	100	767469	\N	0	\N
2376	3567	88	767469	\N	1	\N
2377	3568	88	767469	\N	1	\N
2378	3569	88	767469	\N	1	\N
2379	3577	8	7147	\N	1	\N
2380	3578	253	7147	\N	1	\N
2381	3579	33	5	\N	2	\N
2382	3579	8	457	\N	1	\N
2383	3580	130	457	\N	1	\N
2384	3581	130	5	\N	1	\N
2385	3585	8	10583	\N	1	\N
2386	3586	8	4433	\N	1	\N
2387	3587	128	4433	\N	2	\N
2388	3587	253	10583	\N	1	\N
2389	3594	78	2	\N	1	\N
2390	3595	82	2	\N	1	\N
2391	3598	8	1196	\N	1	\N
2392	3599	128	1196	\N	1	\N
2393	3612	14	1868	\N	2	\N
2394	3612	56	221	\N	0	\N
2395	3612	100	221	\N	0	\N
2396	3612	249	221	\N	3	\N
2397	3612	13	948949	\N	1	\N
2398	3613	13	138	\N	1	\N
2399	3614	129	138	\N	2	\N
2400	3614	186	948949	\N	1	\N
2401	3615	186	1868	\N	1	\N
2402	3616	186	221	\N	1	\N
2403	3617	186	221	\N	1	\N
2404	3618	186	221	\N	1	\N
2405	3620	223	246	\N	1	\N
2406	3621	213	246	\N	1	\N
2407	3627	201	6	\N	1	\N
2408	3628	118	5	\N	0	\N
2409	3629	201	4	\N	1	\N
2410	3629	118	175	\N	0	\N
2411	3630	118	4	\N	0	\N
2412	3630	201	6	\N	1	\N
2413	3631	118	175	\N	0	\N
2414	3631	155	5	\N	1	\N
2415	3646	259	975	\N	0	\N
2416	3646	161	975	\N	1	\N
2417	3647	259	615	\N	0	\N
2418	3647	161	615	\N	1	\N
2419	3648	161	272	\N	1	\N
2420	3648	259	272	\N	0	\N
2421	3649	259	88	\N	0	\N
2422	3649	161	88	\N	1	\N
2423	3650	137	272	\N	0	\N
2424	3650	63	615	\N	0	\N
2425	3650	259	975	\N	1	\N
2426	3650	138	88	\N	0	\N
2427	3651	63	615	\N	0	\N
2428	3651	138	88	\N	0	\N
2429	3651	259	975	\N	1	\N
2430	3651	137	272	\N	0	\N
2431	3652	207	109715	\N	1	\N
2432	3652	129	37	\N	0	\N
2433	3653	207	38	\N	1	\N
2434	3654	129	37	\N	1	\N
2435	3654	207	37	\N	0	\N
2436	3655	207	25	\N	1	\N
2437	3656	207	21	\N	1	\N
2438	3657	207	11	\N	1	\N
2439	3658	207	11	\N	1	\N
2440	3659	207	11	\N	1	\N
2441	3660	207	11	\N	1	\N
2442	3661	207	2	\N	1	\N
2443	3662	207	1	\N	1	\N
2444	3663	207	1	\N	1	\N
2445	3664	129	109715	\N	1	\N
2446	3664	127	11	\N	0	\N
2447	3664	177	21	\N	0	\N
2448	3664	248	25	\N	0	\N
2449	3664	246	11	\N	0	\N
2450	3664	12	11	\N	0	\N
2451	3664	207	37	\N	0	\N
2452	3664	252	1	\N	0	\N
2453	3664	7	38	\N	0	\N
2454	3664	120	11	\N	0	\N
2455	3664	59	1	\N	0	\N
2456	3664	247	2	\N	0	\N
2457	3665	207	37	\N	0	\N
2458	3665	129	37	\N	1	\N
2459	3674	257	1	\N	0	\N
2460	3674	179	1865741	\N	1	\N
2461	3675	35	1	\N	0	\N
2462	3675	100	1529137	\N	0	\N
2463	3675	56	1529137	\N	0	\N
2464	3675	178	1782122	\N	1	\N
2465	3675	179	1	\N	0	\N
2466	3676	35	1470549	\N	1	\N
2467	3677	254	467567	\N	1	\N
2468	3677	205	37	\N	2	\N
2469	3678	100	225380	\N	0	\N
2470	3678	125	264768	\N	1	\N
2471	3678	56	225380	\N	0	\N
2472	3679	255	90	\N	2	\N
2473	3679	180	29712	\N	1	\N
2474	3680	129	11	\N	0	\N
2475	3680	208	13	\N	2	\N
2476	3680	124	12	\N	3	\N
2477	3680	12	18106	\N	1	\N
2478	3680	126	11	\N	4	\N
2479	3681	82	13343	\N	1	\N
2480	3682	256	10829	\N	1	\N
2481	3683	179	1	\N	0	\N
2482	3683	35	1	\N	0	\N
2483	3683	178	1782122	\N	1	\N
2484	3683	56	1529137	\N	0	\N
2485	3683	100	1529137	\N	0	\N
2486	3684	100	1529137	\N	0	\N
2487	3684	178	1782122	\N	1	\N
2488	3684	179	1	\N	0	\N
2489	3684	56	1529137	\N	0	\N
2490	3684	35	1	\N	0	\N
2491	3685	208	2	\N	3	\N
2492	3685	254	39	\N	2	\N
2493	3685	124	1	\N	4	\N
2494	3685	205	211489	\N	1	\N
2495	3686	179	16	\N	2	\N
2496	3686	257	24747	\N	1	\N
2497	3687	180	191	\N	2	\N
2498	3687	255	20571	\N	1	\N
2499	3688	254	4	\N	3	\N
2500	3688	205	7	\N	2	\N
2501	3688	180	53	\N	1	\N
2502	3689	56	1	\N	0	\N
2503	3689	14	16	\N	0	\N
2504	3689	100	1	\N	0	\N
2505	3689	249	1	\N	2	\N
2506	3689	101	1865741	\N	1	\N
2507	3690	56	1782122	\N	0	\N
2508	3690	100	1782122	\N	0	\N
2509	3690	249	1782122	\N	1	\N
2510	3691	202	1470549	\N	1	\N
2511	3691	249	1	\N	2	\N
2512	3691	56	1	\N	0	\N
2513	3691	100	1	\N	0	\N
2514	3692	129	39	\N	0	\N
2515	3692	7	4	\N	0	\N
2516	3692	207	467567	\N	1	\N
2517	3693	174	264768	\N	1	\N
2518	3694	7	7	\N	0	\N
2519	3694	129	211489	\N	1	\N
2520	3694	207	37	\N	0	\N
2521	3695	13	10829	\N	1	\N
2522	3696	87	191	\N	0	\N
2523	3696	107	29712	\N	1	\N
2524	3696	7	53	\N	0	\N
2525	3697	101	1	\N	0	\N
2526	3697	14	24747	\N	1	\N
2527	3699	107	90	\N	0	\N
2528	3699	87	20571	\N	1	\N
2529	3700	103	18106	\N	1	\N
2530	3701	130	13343	\N	1	\N
2531	3702	129	2	\N	2	\N
2532	3702	103	13	\N	1	\N
2533	3703	103	12	\N	1	\N
2534	3703	129	1	\N	2	\N
2535	3704	103	11	\N	1	\N
2536	3706	249	1529137	\N	1	\N
2537	3706	56	1529137	\N	0	\N
2538	3706	100	1529137	\N	0	\N
2539	3706	174	225380	\N	2	\N
2540	3707	174	225380	\N	2	\N
2541	3707	249	1529137	\N	1	\N
2542	3707	100	1529137	\N	0	\N
2543	3707	56	1529137	\N	0	\N
2544	3708	103	11	\N	1	\N
2545	3710	52	1512	\N	1	\N
2546	3711	52	1512	\N	1	\N
2547	3712	52	1512	\N	1	\N
2548	3713	221	1512	\N	1	\N
2549	3713	190	1512	\N	2	\N
2550	3713	74	1512	\N	3	\N
2551	3719	52	1512	\N	1	\N
2552	3720	52	1512	\N	1	\N
2553	3721	190	1512	\N	1	\N
2554	3721	74	1512	\N	2	\N
2555	3739	258	3	\N	1	\N
2556	3739	56	3	\N	0	\N
2557	3740	56	3	\N	0	\N
2558	3740	258	3	\N	1	\N
2559	3741	258	3	\N	1	\N
2560	3741	56	3	\N	0	\N
2561	3742	56	3	\N	0	\N
2562	3742	258	3	\N	1	\N
2563	3747	100	226012	\N	0	\N
2564	3747	202	27482	\N	2	\N
2565	3747	249	226012	\N	1	\N
2566	3747	56	226012	\N	0	\N
2567	3749	35	226012	\N	1	\N
2568	3750	35	27482	\N	1	\N
2569	3751	35	226012	\N	1	\N
2570	3752	35	226012	\N	1	\N
2571	3758	224	1961455	\N	1	\N
2572	3759	145	1961455	\N	1	\N
2573	3760	212	258	\N	1	\N
2574	3761	212	258	\N	1	\N
2575	3762	212	253	\N	1	\N
2576	3763	7	258	\N	0	\N
2577	3763	120	253	\N	0	\N
2578	3763	246	258	\N	1	\N
2579	3789	8	20	\N	1	\N
2580	3790	8	20	\N	1	\N
2581	3818	94	8	\N	1	\N
2582	3819	250	8	\N	1	\N
2583	3820	8	1376	\N	1	\N
2584	3821	128	1376	\N	1	\N
2585	3825	53	301267	\N	1	\N
2586	3826	53	3079	\N	1	\N
2587	3827	208	3079	\N	2	\N
2588	3827	180	301267	\N	1	\N
2589	3829	8	954053	\N	1	\N
2590	3830	225	954053	\N	1	\N
2591	3831	33	81	\N	2	\N
2592	3831	8	51860	\N	1	\N
2593	3832	79	51860	\N	1	\N
2594	3833	79	81	\N	1	\N
2595	3871	8	4223	\N	1	\N
2596	3872	8	746	\N	1	\N
2597	3873	8	4223	\N	1	\N
2598	3874	8	4223	\N	1	\N
2599	3875	249	4223	\N	1	\N
2600	3875	56	4223	\N	0	\N
2601	3875	100	4223	\N	0	\N
2602	3875	13	746	\N	2	\N
2603	3879	100	1687088	\N	2	\N
2604	3879	35	59151	\N	6	\N
2605	3879	101	1775203	\N	1	\N
2606	3879	174	247525	\N	5	\N
2607	3879	176	101	\N	18	\N
2608	3879	255	47	\N	19	\N
2609	3879	103	1	\N	20	\N
2610	3879	202	1325521	\N	3	\N
2611	3879	254	18254	\N	10	\N
2612	3879	125	7350	\N	0	\N
2613	3879	257	576	\N	15	\N
2614	3879	207	386588	\N	4	\N
2615	3879	179	47677	\N	7	\N
2616	3879	178	55946	\N	0	\N
2617	3879	249	1672015	\N	0	\N
2618	3879	107	26980	\N	8	\N
2619	3879	56	1687088	\N	0	\N
2620	3879	13	9196	\N	13	\N
2621	3879	256	576	\N	16	\N
2622	3879	129	186733	\N	0	\N
2623	3879	180	1889	\N	14	\N
2624	3879	205	9408	\N	12	\N
2625	3879	87	22025	\N	0	\N
2626	3879	7	64	\N	0	\N
2627	3879	36	19739	\N	9	\N
2628	3879	130	12525	\N	11	\N
2629	3879	14	22546	\N	0	\N
2630	3879	82	531	\N	17	\N
2631	3880	125	58	\N	1	\N
2632	3882	12	1775203	\N	1	\N
2633	3883	12	1687088	\N	1	\N
2634	3884	12	1325521	\N	1	\N
2635	3885	12	386588	\N	1	\N
2636	3886	12	247525	\N	1	\N
2637	3887	12	59151	\N	1	\N
2638	3888	12	47677	\N	1	\N
2639	3889	12	26980	\N	1	\N
2640	3890	12	19739	\N	1	\N
2641	3891	12	18254	\N	1	\N
2642	3892	12	12525	\N	1	\N
2643	3893	12	9408	\N	1	\N
2644	3894	12	9196	\N	1	\N
2645	3895	12	1889	\N	1	\N
2646	3896	12	576	\N	1	\N
2647	3897	12	576	\N	1	\N
2648	3898	12	531	\N	1	\N
2649	3899	12	101	\N	1	\N
2650	3900	12	47	\N	1	\N
2651	3901	12	1	\N	1	\N
2652	3902	12	1687088	\N	1	\N
2653	3903	12	1672015	\N	1	\N
2654	3904	12	186733	\N	1	\N
2655	3905	12	55946	\N	1	\N
2656	3906	12	22546	\N	1	\N
2657	3907	12	22025	\N	1	\N
2658	3908	12	7350	\N	1	\N
2659	3908	238	58	\N	2	\N
2660	3909	12	64	\N	1	\N
2661	3911	8	935591	\N	1	\N
2662	3912	88	935591	\N	1	\N
2663	3915	258	72	\N	1	\N
2664	3915	56	72	\N	0	\N
2665	3916	56	48	\N	0	\N
2666	3916	258	48	\N	1	\N
2667	3917	258	72	\N	1	\N
2668	3917	56	48	\N	0	\N
2669	3918	258	72	\N	1	\N
2670	3918	56	48	\N	0	\N
2671	3929	145	1961437	\N	1	\N
2672	3930	78	1961437	\N	1	\N
2673	3931	74	1512	\N	1	\N
2674	3932	124	1512	\N	1	\N
2675	3941	8	128996	\N	1	\N
2676	3942	8	128996	\N	1	\N
2677	3943	166	32850	\N	1	\N
2678	3944	166	29	\N	1	\N
2679	3945	166	25	\N	1	\N
2680	3946	166	7	\N	1	\N
2681	3947	166	3	\N	1	\N
2682	3948	166	3	\N	1	\N
2683	3949	166	3	\N	1	\N
2684	3950	166	3	\N	1	\N
2685	3951	166	2	\N	1	\N
2686	3952	166	1	\N	1	\N
2687	3953	12	3	\N	0	\N
2688	3953	7	29	\N	0	\N
2689	3953	248	25	\N	0	\N
2690	3953	177	7	\N	0	\N
2691	3953	127	3	\N	0	\N
2692	3953	129	32850	\N	1	\N
2693	3953	246	3	\N	0	\N
2694	3953	120	3	\N	0	\N
2695	3953	247	2	\N	0	\N
2696	3953	252	1	\N	0	\N
2697	3954	229	2	\N	0	\N
2698	3954	230	2	\N	0	\N
2699	3954	97	551	\N	1	\N
2700	3954	119	32	\N	0	\N
2701	3954	122	17	\N	0	\N
2702	3954	9	2	\N	0	\N
2703	3956	230	2	\N	0	\N
2704	3956	97	15	\N	0	\N
2705	3956	9	2	\N	0	\N
2706	3956	122	15	\N	1	\N
2707	3957	119	10	\N	1	\N
2708	3957	97	10	\N	0	\N
2709	3958	97	6	\N	1	\N
2710	3958	9	2	\N	0	\N
2711	3958	122	5	\N	0	\N
2712	3959	97	3	\N	0	\N
2713	3959	9	1	\N	0	\N
2714	3959	122	3	\N	1	\N
2715	3961	9	6	\N	0	\N
2716	3961	230	3	\N	0	\N
2717	3961	97	551	\N	1	\N
2718	3961	119	10	\N	0	\N
2719	3961	122	15	\N	0	\N
2720	3962	119	10	\N	0	\N
2721	3962	97	32	\N	1	\N
2722	3963	97	17	\N	1	\N
2723	3963	122	15	\N	0	\N
2724	3963	9	5	\N	0	\N
2725	3963	230	3	\N	0	\N
2726	3964	9	2	\N	1	\N
2727	3964	230	1	\N	0	\N
2728	3964	122	2	\N	0	\N
2729	3964	97	2	\N	0	\N
2730	3965	122	2	\N	1	\N
2731	3965	97	2	\N	0	\N
2732	3966	97	2	\N	1	\N
2733	3969	7	2	\N	0	\N
2734	3969	120	2	\N	1	\N
2735	3969	246	2	\N	0	\N
2736	3970	7	2	\N	0	\N
2737	3970	120	2	\N	1	\N
2738	3970	246	2	\N	0	\N
2739	3984	246	2	\N	1	\N
2740	3984	7	2	\N	0	\N
2741	3985	246	2	\N	1	\N
2742	3985	7	2	\N	0	\N
2743	3986	246	2	\N	1	\N
2744	3986	7	2	\N	0	\N
2745	3989	247	183617	\N	0	\N
2746	3989	248	230740	\N	1	\N
2747	3989	7	230389	\N	0	\N
2748	3989	120	3	\N	0	\N
2749	3989	103	2	\N	0	\N
2750	3989	14	6	\N	0	\N
2751	3989	246	1	\N	0	\N
2752	3989	87	7	\N	0	\N
2753	3989	129	25	\N	0	\N
2754	3990	103	2	\N	0	\N
2755	3990	247	183505	\N	0	\N
2756	3990	87	7	\N	0	\N
2757	3990	7	230291	\N	0	\N
2758	3990	120	2	\N	0	\N
2759	3990	14	6	\N	0	\N
2760	3990	129	25	\N	0	\N
2761	3990	248	230459	\N	1	\N
2762	3991	247	28	\N	0	\N
2763	3991	7	32	\N	0	\N
2764	3991	248	32	\N	1	\N
2765	3992	102	230740	\N	1	\N
2766	3992	7	230459	\N	0	\N
2767	3992	247	32	\N	0	\N
2768	3993	102	230389	\N	1	\N
2769	3993	7	230291	\N	0	\N
2770	3993	247	32	\N	0	\N
2771	3994	102	183617	\N	1	\N
2772	3994	7	183505	\N	0	\N
2773	3994	247	28	\N	0	\N
2774	3995	102	25	\N	1	\N
2775	3995	7	25	\N	0	\N
2776	3996	7	7	\N	0	\N
2777	3996	102	7	\N	1	\N
2778	3997	102	6	\N	1	\N
2779	3997	7	6	\N	0	\N
2780	3998	102	3	\N	1	\N
2781	3998	7	2	\N	0	\N
2782	3999	7	2	\N	0	\N
2783	3999	102	2	\N	1	\N
2784	4000	102	1	\N	1	\N
2785	4036	8	31132	\N	1	\N
2786	4037	8	18	\N	1	\N
2787	4038	129	18	\N	0	\N
2788	4038	127	31132	\N	1	\N
2789	4051	59	27973	\N	1	\N
2790	4052	180	27973	\N	1	\N
2791	4053	39	1	\N	2	\N
2792	4053	38	201	\N	1	\N
2793	4053	99	1	\N	0	\N
2794	4053	8	201	\N	0	\N
2795	4054	8	202	\N	0	\N
2796	4054	38	202	\N	1	\N
2797	4055	19	201	\N	2	\N
2798	4055	133	202	\N	1	\N
2799	4056	19	1	\N	1	\N
2800	4057	133	202	\N	1	\N
2801	4057	19	201	\N	2	\N
2802	4058	19	1	\N	1	\N
2803	4059	8	31	\N	1	\N
2804	4060	8	2	\N	1	\N
2805	4061	8	31	\N	1	\N
2806	4061	7	2	\N	0	\N
2807	4062	31	2	\N	1	\N
2808	4063	228	2	\N	1	\N
2809	4068	33	1	\N	2	\N
2810	4068	8	12928	\N	1	\N
2811	4069	196	12928	\N	1	\N
2812	4070	196	1	\N	1	\N
2813	4076	52	25693	\N	1	\N
2814	4077	52	11	\N	1	\N
2815	4078	129	11	\N	0	\N
2816	4078	127	25693	\N	1	\N
2817	4080	8	4430	\N	1	\N
2818	4081	128	4430	\N	1	\N
2819	4085	247	6	\N	0	\N
2820	4085	7	2856439	\N	1	\N
2821	4085	120	2856107	\N	0	\N
2822	4085	246	2856125	\N	0	\N
2823	4085	129	1236	\N	0	\N
2824	4086	181	38669	\N	0	\N
2825	4086	56	79190	\N	1	\N
2826	4086	235	40521	\N	0	\N
2827	4087	91	16	\N	1	\N
2828	4088	7	2854240	\N	1	\N
2829	4088	120	2853918	\N	0	\N
2830	4088	246	2853936	\N	0	\N
2831	4088	129	1060	\N	0	\N
2832	4088	247	6	\N	0	\N
2833	4089	7	2854237	\N	1	\N
2834	4089	247	6	\N	0	\N
2835	4089	129	1060	\N	0	\N
2836	4089	120	2853915	\N	0	\N
2837	4089	246	2853933	\N	0	\N
2838	4090	56	40521	\N	0	\N
2839	4090	235	40521	\N	1	\N
2840	4091	56	38669	\N	0	\N
2841	4091	181	38669	\N	1	\N
2842	4092	8	525	\N	1	\N
2843	4093	7	1688	\N	0	\N
2844	4093	246	1688	\N	0	\N
2845	4093	120	1688	\N	1	\N
2846	4093	129	90	\N	0	\N
2847	4094	120	2854237	\N	0	\N
2848	4094	246	2854240	\N	0	\N
2849	4094	129	1688	\N	0	\N
2850	4094	7	2856439	\N	1	\N
2851	4095	235	40521	\N	0	\N
2852	4095	181	38669	\N	0	\N
2853	4095	56	79190	\N	1	\N
2854	4096	91	16	\N	1	\N
2855	4097	246	2853936	\N	0	\N
2856	4097	120	2853933	\N	0	\N
2857	4097	129	1688	\N	0	\N
2858	4097	7	2856125	\N	1	\N
2859	4098	246	2853918	\N	0	\N
2860	4098	120	2853915	\N	0	\N
2861	4098	7	2856107	\N	1	\N
2862	4098	129	1688	\N	0	\N
2863	4099	56	40521	\N	0	\N
2864	4099	235	40521	\N	1	\N
2865	4100	56	38669	\N	0	\N
2866	4100	181	38669	\N	1	\N
2867	4101	120	1060	\N	0	\N
2868	4101	246	1060	\N	0	\N
2869	4101	7	1236	\N	1	\N
2870	4101	129	90	\N	0	\N
2871	4102	8	525	\N	1	\N
2872	4103	120	6	\N	1	\N
2873	4103	7	6	\N	0	\N
2874	4103	246	6	\N	0	\N
2875	4107	8	867	\N	1	\N
2876	4108	128	867	\N	1	\N
2877	4113	115	234	\N	1	\N
2878	4114	151	234	\N	1	\N
2879	4161	8	6716407	\N	1	\N
2880	4162	8	630079	\N	1	\N
2881	4163	8	1300	\N	1	\N
2882	4164	8	411064	\N	1	\N
2883	4165	113	411064	\N	0	\N
2884	4165	112	6716407	\N	1	\N
2885	4165	28	630079	\N	2	\N
2886	4165	13	1300	\N	3	\N
2887	4166	31	2	\N	1	\N
2888	4167	228	2	\N	1	\N
2889	4168	33	201	\N	0	\N
2890	4168	8	1866460	\N	1	\N
2891	4169	193	1866460	\N	1	\N
2892	4170	193	201	\N	1	\N
2893	4195	33	1951	\N	0	\N
2894	4195	8	909025	\N	1	\N
2895	4196	169	909025	\N	1	\N
2896	4197	169	1951	\N	1	\N
2897	4200	233	2328029	\N	1	\N
2898	4201	233	39086	\N	1	\N
2899	4202	233	1840552	\N	1	\N
2900	4203	233	1840552	\N	1	\N
2901	4204	178	2328029	\N	1	\N
2902	4204	100	1840552	\N	0	\N
2903	4204	256	39086	\N	2	\N
2904	4204	56	1840552	\N	0	\N
2905	4214	33	984	\N	0	\N
2906	4214	8	453192	\N	1	\N
2907	4215	225	453192	\N	1	\N
2908	4216	225	984	\N	1	\N
2909	4217	226	1029077	\N	1	\N
2910	4218	226	479066	\N	1	\N
2911	4219	226	222475	\N	1	\N
2912	4220	226	7228	\N	1	\N
2913	4221	226	730783	\N	1	\N
2914	4222	226	730783	\N	1	\N
2915	4223	226	411336	\N	1	\N
2916	4224	256	7228	\N	4	\N
2917	4224	100	730783	\N	0	\N
2918	4224	112	411336	\N	0	\N
2919	4224	113	479066	\N	2	\N
2920	4224	205	222475	\N	3	\N
2921	4224	178	1029077	\N	1	\N
2922	4224	56	730783	\N	0	\N
2923	4229	120	969	\N	1	\N
2924	4229	172	67	\N	2	\N
2925	4230	120	939	\N	1	\N
2926	4231	61	435	\N	1	\N
2927	4232	172	5	\N	1	\N
2928	4234	172	4	\N	1	\N
2929	4237	172	1	\N	1	\N
2930	4238	120	2	\N	2	\N
2931	4238	7	18	\N	0	\N
2932	4238	172	19	\N	1	\N
2933	4239	61	435	\N	1	\N
2934	4240	172	17	\N	1	\N
2935	4241	172	14	\N	1	\N
2936	4242	172	4	\N	1	\N
2937	4243	172	3	\N	1	\N
2938	4244	172	1	\N	1	\N
2939	4245	172	1	\N	1	\N
2940	4246	97	969	\N	1	\N
2941	4246	118	2	\N	0	\N
2942	4246	99	939	\N	2	\N
2943	4247	258	435	\N	1	\N
2944	4247	56	435	\N	0	\N
2945	4248	119	14	\N	0	\N
2946	4248	229	1	\N	0	\N
2947	4248	9	4	\N	0	\N
2948	4248	230	3	\N	0	\N
2949	4248	201	4	\N	3	\N
2950	4248	97	67	\N	1	\N
2951	4248	122	17	\N	0	\N
2952	4248	155	5	\N	2	\N
2953	4248	32	1	\N	0	\N
2954	4248	118	19	\N	0	\N
2955	4248	6	1	\N	4	\N
2956	4249	118	18	\N	0	\N
2957	4250	8	1832	\N	1	\N
2958	4251	8	1832	\N	1	\N
2959	4255	143	935	\N	1	\N
2960	4256	126	935	\N	1	\N
2961	4268	215	6812	\N	2	\N
2962	4268	151	19518	\N	1	\N
2963	4269	180	19518	\N	1	\N
2964	4270	180	6812	\N	1	\N
2965	4284	244	726817	\N	1	\N
2966	4285	179	726817	\N	1	\N
2967	4286	52	1512	\N	1	\N
2968	4287	52	1512	\N	1	\N
2969	4288	190	1512	\N	1	\N
2970	4288	74	1512	\N	2	\N
2971	4289	52	1512	\N	1	\N
2972	4290	52	1512	\N	1	\N
2973	4291	190	1512	\N	1	\N
2974	4291	74	1512	\N	2	\N
2975	4294	8	5652	\N	1	\N
2976	4295	253	5652	\N	1	\N
2977	4297	153	1	\N	2	\N
2978	4297	65	56	\N	1	\N
2979	4298	153	5	\N	1	\N
2980	4299	85	56	\N	1	\N
2981	4301	85	1	\N	2	\N
2982	4301	153	5	\N	1	\N
2983	4307	198	719	\N	1	\N
2984	4308	198	31	\N	1	\N
2985	4309	12	31	\N	2	\N
2986	4309	180	719	\N	1	\N
2987	4335	29	2	\N	1	\N
2988	4336	29	2	\N	1	\N
2989	4341	56	13518453	\N	0	\N
2990	4341	100	13518453	\N	0	\N
2991	4341	249	13518453	\N	1	\N
2992	4342	186	13518453	\N	1	\N
2993	4343	186	13518453	\N	1	\N
2994	4344	186	13518453	\N	1	\N
2995	4374	8	935524	\N	1	\N
2996	4375	88	935524	\N	1	\N
2997	4378	187	1462	\N	1	\N
2998	4379	129	1462	\N	1	\N
2999	4395	33	79	\N	2	\N
3000	4395	38	6851	\N	1	\N
3001	4395	8	6851	\N	0	\N
3002	4396	8	2794	\N	0	\N
3003	4396	38	2794	\N	1	\N
3004	4396	33	52	\N	2	\N
3005	4401	11	2794	\N	2	\N
3006	4401	231	6851	\N	1	\N
3007	4402	231	79	\N	1	\N
3008	4402	11	52	\N	2	\N
3009	4403	11	2794	\N	2	\N
3010	4403	231	6851	\N	1	\N
3011	4410	8	8	\N	1	\N
3012	4411	8	8	\N	1	\N
3013	4412	54	98	\N	1	\N
3014	4413	29	98	\N	1	\N
3015	4435	228	2	\N	1	\N
3016	4436	30	2	\N	1	\N
3017	4437	77	214805	\N	1	\N
3018	4438	179	214805	\N	1	\N
3019	4439	186	405664	\N	1	\N
3020	4440	186	97	\N	1	\N
3021	4441	186	1	\N	1	\N
3022	4442	207	405664	\N	1	\N
3023	4442	129	97	\N	0	\N
3024	4442	7	1	\N	0	\N
3025	4448	118	15117462	\N	0	\N
3026	4449	118	7130648	\N	0	\N
3027	4450	118	6429420	\N	0	\N
3028	4451	118	2028461	\N	0	\N
3029	4452	118	5276501	\N	0	\N
3030	4453	118	3878965	\N	0	\N
3031	4454	118	2367115	\N	0	\N
3032	4456	118	3234017	\N	0	\N
3033	4456	201	3	\N	1	\N
3034	4457	118	1961505	\N	0	\N
3035	4458	118	1961500	\N	0	\N
3036	4459	118	1961497	\N	0	\N
3037	4460	118	1926031	\N	0	\N
3038	4461	118	1925942	\N	0	\N
3039	4462	118	1909205	\N	0	\N
3040	4463	118	1854424	\N	0	\N
3041	4464	118	1737846	\N	0	\N
3042	4465	118	1499564	\N	0	\N
3043	4467	118	1206662	\N	0	\N
3044	4468	118	1054932	\N	0	\N
3045	4469	118	1031071	\N	0	\N
3046	4471	118	956051	\N	0	\N
3047	4472	118	935516	\N	0	\N
3048	4473	118	903214	\N	0	\N
3049	4474	118	726836	\N	0	\N
3050	4479	118	561539	\N	0	\N
3051	4481	118	505915	\N	0	\N
3052	4482	118	484238	\N	0	\N
3053	4483	118	478636	\N	0	\N
3054	4488	118	304346	\N	0	\N
3055	4492	118	225689	\N	0	\N
3056	4493	118	222475	\N	0	\N
3057	4496	118	192230	\N	0	\N
3058	4504	118	71620	\N	0	\N
3059	4505	118	64126	\N	0	\N
3060	4507	118	61234	\N	0	\N
3061	4509	118	45913	\N	0	\N
3062	4510	118	37226	\N	0	\N
3063	4511	118	36540	\N	0	\N
3064	4512	118	34219	\N	0	\N
3065	4513	118	30940	\N	0	\N
3066	4515	118	27017	\N	0	\N
3067	4516	118	11	\N	0	\N
3068	4519	118	22851	\N	0	\N
3069	4520	118	19518	\N	0	\N
3070	4524	118	18228	\N	0	\N
3071	4525	118	17016	\N	0	\N
3072	4528	118	13691	\N	0	\N
3073	4531	118	9045	\N	0	\N
3074	4534	118	7804	\N	0	\N
3075	4535	118	7625	\N	0	\N
3076	4536	118	7427	\N	0	\N
3077	4537	118	7203	\N	0	\N
3078	4539	118	5548	\N	0	\N
3079	4542	118	5053	\N	0	\N
3080	4546	118	2022	\N	0	\N
3081	4555	118	1285	\N	0	\N
3082	4556	201	1080	\N	1	\N
3083	4556	118	24	\N	0	\N
3084	4558	118	968	\N	0	\N
3085	4566	118	553	\N	0	\N
3086	4571	118	415	\N	0	\N
3087	4572	118	397	\N	0	\N
3088	4575	118	258	\N	0	\N
3089	4581	201	218	\N	1	\N
3090	4582	118	218	\N	0	\N
3091	4583	118	216	\N	0	\N
3092	4586	118	202	\N	0	\N
3093	4588	118	185	\N	0	\N
3094	4590	118	168	\N	0	\N
3095	4591	118	165	\N	0	\N
3096	4592	118	74	\N	0	\N
3097	4593	201	73	\N	1	\N
3098	4593	118	73	\N	0	\N
3099	4597	118	97	\N	0	\N
3100	4603	118	90	\N	0	\N
3101	4606	118	78	\N	0	\N
3102	4607	118	69	\N	0	\N
3103	4608	118	58	\N	0	\N
3104	4609	118	57	\N	0	\N
3105	4610	118	56	\N	0	\N
3106	4611	118	56	\N	0	\N
3107	4612	118	56	\N	0	\N
3108	4613	118	56	\N	0	\N
3109	4614	118	54	\N	0	\N
3110	4615	118	48	\N	0	\N
3111	4617	118	45	\N	0	\N
3112	4619	118	40	\N	0	\N
3113	4621	118	35	\N	0	\N
3114	4623	118	21	\N	0	\N
3115	4626	118	11	\N	0	\N
3116	4627	118	11	\N	0	\N
3117	4628	118	10	\N	0	\N
3118	4629	118	12	\N	0	\N
3119	4630	118	8	\N	0	\N
3120	4634	118	8	\N	0	\N
3121	4635	118	7	\N	0	\N
3122	4638	118	5	\N	0	\N
3123	4640	118	5	\N	0	\N
3124	4641	118	5	\N	0	\N
3125	4647	118	3	\N	0	\N
3126	4653	118	2	\N	0	\N
3127	4658	118	1	\N	0	\N
3128	4659	118	1	\N	0	\N
3129	4661	118	1880075	\N	0	\N
3130	4662	118	1855886	\N	0	\N
3131	4663	118	1984537	\N	0	\N
3132	4664	118	1868127	\N	0	\N
3133	4665	118	890402	\N	0	\N
3134	4666	118	266220	\N	0	\N
3135	4667	118	1010529	\N	0	\N
3136	4668	118	804219	\N	0	\N
3137	4669	118	76	\N	0	\N
3138	4669	201	256202	\N	1	\N
3139	4670	118	70439	\N	0	\N
3140	4671	118	167808	\N	0	\N
3141	4672	118	110306	\N	0	\N
3142	4673	118	145798	\N	0	\N
3143	4674	118	93477	\N	0	\N
3144	4675	118	40827	\N	0	\N
3145	4676	118	36450	\N	0	\N
3146	4677	118	36012	\N	0	\N
3147	4678	118	35097	\N	0	\N
3148	4681	118	31505	\N	0	\N
3149	4683	118	18373	\N	0	\N
3150	4684	118	13292	\N	0	\N
3151	4685	118	14352	\N	0	\N
3152	4686	118	6221	\N	0	\N
3153	4687	118	33	\N	0	\N
3154	4688	118	1797	\N	0	\N
3155	4689	118	1531	\N	0	\N
3156	4691	118	1173	\N	0	\N
3157	4693	118	865	\N	0	\N
3158	4694	118	673	\N	0	\N
3159	4697	118	628	\N	0	\N
3160	4698	118	310	\N	0	\N
3161	4699	118	291	\N	0	\N
3162	4701	118	74	\N	0	\N
3163	4702	118	185	\N	0	\N
3164	4703	118	130	\N	0	\N
3165	4704	118	148	\N	0	\N
3166	4705	201	40	\N	1	\N
3167	4706	201	32	\N	1	\N
3168	4707	118	61	\N	0	\N
3169	4708	118	24	\N	0	\N
3170	4708	201	24	\N	1	\N
3171	4709	118	47	\N	0	\N
3172	4711	118	30	\N	0	\N
3173	4712	118	27	\N	0	\N
3174	4713	118	21	\N	0	\N
3175	4714	118	14	\N	0	\N
3176	4715	118	10	\N	0	\N
3177	4716	118	10	\N	0	\N
3178	4717	201	4	\N	1	\N
3179	4718	118	8	\N	0	\N
3180	4720	38	73	\N	0	\N
3181	4720	239	40	\N	0	\N
3182	4720	99	1080	\N	2	\N
3183	4720	139	4	\N	0	\N
3184	4720	185	32	\N	0	\N
3185	4720	33	218	\N	3	\N
3186	4720	7	3	\N	0	\N
3187	4720	8	256202	\N	1	\N
3188	4720	39	24	\N	0	\N
3189	4721	196	225689	\N	30	\N
3190	4721	32	10	\N	0	\N
3191	4721	204	148	\N	0	\N
3192	4721	205	222475	\N	31	\N
3193	4721	233	2367115	\N	7	\N
3194	4721	249	70439	\N	0	\N
3195	4721	8	76	\N	0	\N
3196	4721	127	11	\N	89	\N
3197	4721	270	5	\N	94	\N
3198	4721	164	90	\N	68	\N
3199	4721	78	1961497	\N	11	\N
3200	4721	7	3234017	\N	6	\N
3201	4721	248	1010529	\N	0	\N
3202	4721	246	1984537	\N	0	\N
3203	4721	173	56	\N	75	\N
3204	4721	121	56	\N	76	\N
3205	4721	256	37226	\N	37	\N
3206	4721	207	167808	\N	0	\N
3207	4721	174	9045	\N	47	\N
3208	4721	84	36450	\N	0	\N
3209	4721	209	5548	\N	52	\N
3210	4721	62	10	\N	0	\N
3211	4721	154	69	\N	72	\N
3212	4721	236	5	\N	95	\N
3213	4721	10	74	\N	0	\N
3214	4721	40	57	\N	74	\N
3215	4721	18	45913	\N	36	\N
3216	4721	271	78	\N	69	\N
3217	4721	224	1961500	\N	10	\N
3218	4721	27	34219	\N	39	\N
3219	4721	247	1868127	\N	0	\N
3220	4721	229	1797	\N	0	\N
3221	4721	153	7	\N	93	\N
3222	4721	35	1499564	\N	17	\N
3223	4721	100	1880075	\N	0	\N
3224	4721	179	1925942	\N	13	\N
3225	4721	101	61234	\N	35	\N
3226	4721	88	935516	\N	22	\N
3227	4721	91	35	\N	83	\N
3228	4721	184	12	\N	86	\N
3229	4721	1	1909205	\N	14	\N
3230	4721	243	1206662	\N	18	\N
3231	4721	116	1054932	\N	19	\N
3232	4721	9	21	\N	0	\N
3233	4721	178	1855886	\N	0	\N
3234	4721	235	36012	\N	0	\N
3235	4721	66	415	\N	58	\N
3236	4721	133	202	\N	63	\N
3237	4721	193	1926031	\N	12	\N
3238	4721	2	3878965	\N	5	\N
3239	4721	197	192230	\N	32	\N
3240	4721	11	13292	\N	0	\N
3241	4721	12	18228	\N	44	\N
3242	4721	180	30940	\N	40	\N
3243	4721	151	19518	\N	43	\N
3244	4721	87	1531	\N	0	\N
3245	4721	181	35097	\N	0	\N
3246	4721	210	36540	\N	38	\N
3247	4721	39	24	\N	84	\N
3248	4721	64	11	\N	87	\N
3249	4721	65	56	\N	77	\N
3250	4721	157	58	\N	73	\N
3251	4721	17	10	\N	90	\N
3252	4721	264	2022	\N	54	\N
3253	4721	93	218	\N	61	\N
3254	4721	166	505915	\N	26	\N
3255	4721	272	64126	\N	34	\N
3256	4721	118	865	\N	0	\N
3257	4721	122	47	\N	0	\N
3258	4721	102	93477	\N	0	\N
3259	4721	123	14352	\N	0	\N
3260	4721	82	13691	\N	46	\N
3261	4721	59	1031071	\N	20	\N
3262	4721	177	5276501	\N	4	\N
3263	4721	13	1285	\N	55	\N
3264	4721	267	11	\N	88	\N
3265	4721	269	165	\N	66	\N
3266	4721	172	27	\N	0	\N
3267	4721	6	1	\N	99	\N
3268	4721	232	628	\N	0	\N
3269	4721	38	73	\N	71	\N
3270	4721	182	3	\N	97	\N
3271	4721	214	74	\N	70	\N
3272	4721	158	7625	\N	49	\N
3273	4721	43	5	\N	96	\N
3274	4721	48	5053	\N	53	\N
3275	4721	186	15117462	\N	1	\N
3276	4721	145	1961505	\N	9	\N
3277	4721	169	1854424	\N	15	\N
3278	4721	119	30	\N	0	\N
3279	4721	120	804219	\N	0	\N
3280	4721	81	185	\N	0	\N
3281	4721	211	130	\N	0	\N
3282	4721	85	56	\N	78	\N
3283	4721	202	71620	\N	33	\N
3284	4721	107	1173	\N	0	\N
3285	4721	130	553	\N	57	\N
3286	4721	128	7203	\N	51	\N
3287	4721	253	17016	\N	45	\N
3288	4721	89	48	\N	80	\N
3289	4721	14	33	\N	0	\N
3290	4721	216	185	\N	64	\N
3291	4721	68	8	\N	91	\N
3292	4721	140	40	\N	82	\N
3293	4721	22	168	\N	65	\N
3294	4721	26	6429420	\N	3	\N
3295	4721	58	291	\N	0	\N
3296	4721	255	22851	\N	42	\N
3297	4721	56	2028461	\N	8	\N
3298	4721	103	6221	\N	0	\N
3299	4721	152	968	\N	56	\N
3300	4721	131	2	\N	98	\N
3301	4721	260	258	\N	60	\N
3302	4721	155	54	\N	79	\N
3303	4721	141	397	\N	59	\N
3304	4721	244	726836	\N	24	\N
3305	4721	170	903214	\N	23	\N
3306	4721	147	8	\N	0	\N
3307	4721	80	1	\N	100	\N
3308	4721	148	61	\N	0	\N
3309	4721	57	18373	\N	0	\N
3310	4721	254	478636	\N	28	\N
3311	4721	257	27017	\N	41	\N
3312	4721	125	266220	\N	0	\N
3313	4721	60	40827	\N	0	\N
3314	4721	212	7804	\N	48	\N
3315	4721	99	24	\N	0	\N
3316	4721	132	97	\N	67	\N
3317	4721	135	45	\N	81	\N
3318	4721	266	8	\N	92	\N
3319	4721	73	561539	\N	25	\N
3320	4721	113	890402	\N	0	\N
3321	4721	226	1737846	\N	16	\N
3322	4721	53	304346	\N	29	\N
3323	4721	225	956051	\N	21	\N
3324	4721	97	7427	\N	50	\N
3325	4721	201	21	\N	85	\N
3326	4721	230	14	\N	0	\N
3327	4721	252	145798	\N	0	\N
3328	4721	231	31505	\N	0	\N
3329	4721	36	484238	\N	27	\N
3330	4721	129	110306	\N	0	\N
3331	4721	34	310	\N	0	\N
3332	4721	215	216	\N	62	\N
3333	4721	15	673	\N	0	\N
3334	4721	112	7130648	\N	2	\N
3335	4731	38	170	\N	1	\N
3336	4731	8	170	\N	0	\N
3337	4732	8	170	\N	0	\N
3338	4732	38	170	\N	1	\N
3339	4733	39	170	\N	1	\N
3340	4733	99	170	\N	0	\N
3341	4734	99	170	\N	0	\N
3342	4734	39	170	\N	1	\N
3343	4750	247	23291	\N	0	\N
3344	4750	252	38032	\N	1	\N
3345	4750	57	1	\N	0	\N
3346	4750	7	37990	\N	0	\N
3347	4750	120	9	\N	0	\N
3348	4750	14	1	\N	0	\N
3349	4750	129	1	\N	0	\N
3350	4751	247	23281	\N	0	\N
3351	4751	57	1	\N	0	\N
3352	4751	7	37971	\N	0	\N
3353	4751	120	9	\N	0	\N
3354	4751	14	1	\N	0	\N
3355	4751	129	1	\N	0	\N
3356	4751	252	37990	\N	1	\N
3357	4752	252	28482	\N	1	\N
3358	4752	247	23257	\N	0	\N
3359	4752	57	1	\N	0	\N
3360	4752	7	28471	\N	0	\N
3361	4752	120	9	\N	0	\N
3362	4752	14	1	\N	0	\N
3363	4753	252	14	\N	1	\N
3364	4753	7	14	\N	0	\N
3365	4753	129	1	\N	0	\N
3366	4754	7	1	\N	0	\N
3367	4754	252	1	\N	1	\N
3368	4755	247	28482	\N	0	\N
3369	4755	129	14	\N	0	\N
3370	4755	248	38032	\N	1	\N
3371	4755	7	37990	\N	0	\N
3372	4755	120	1	\N	0	\N
3373	4756	120	1	\N	0	\N
3374	4756	129	14	\N	0	\N
3375	4756	7	37971	\N	0	\N
3376	4756	247	28471	\N	0	\N
3377	4756	248	37990	\N	1	\N
3378	4757	248	23291	\N	1	\N
3379	4757	7	23281	\N	0	\N
3380	4757	247	23257	\N	0	\N
3381	4758	7	9	\N	0	\N
3382	4758	248	9	\N	1	\N
3383	4758	247	9	\N	0	\N
3384	4759	248	1	\N	1	\N
3385	4759	7	1	\N	0	\N
3386	4759	247	1	\N	0	\N
3387	4760	7	1	\N	0	\N
3388	4760	247	1	\N	0	\N
3389	4760	248	1	\N	1	\N
3390	4761	248	1	\N	0	\N
3391	4761	7	1	\N	0	\N
3392	4761	129	1	\N	1	\N
3393	4763	8	1728105	\N	1	\N
3394	4764	226	1728105	\N	1	\N
3395	4768	247	72	\N	1	\N
3396	4769	247	1	\N	1	\N
3397	4771	247	1	\N	1	\N
3398	4772	250	72	\N	1	\N
3399	4772	33	1	\N	3	\N
3400	4772	98	1	\N	2	\N
3401	4791	177	485429	\N	1	\N
3402	4792	36	485429	\N	1	\N
3403	4794	197	192230	\N	1	\N
3404	4795	196	192230	\N	1	\N
3405	4796	87	22	\N	0	\N
3406	4796	107	429	\N	1	\N
3407	4797	87	6	\N	0	\N
3408	4797	107	16	\N	1	\N
3409	4798	107	429	\N	1	\N
3410	4798	7	16	\N	0	\N
3411	4799	107	22	\N	1	\N
3412	4799	7	6	\N	0	\N
3413	4812	177	30940	\N	1	\N
3414	4813	180	30940	\N	1	\N
3415	4819	4	69855	\N	1	\N
3416	4820	4	55	\N	1	\N
3417	4821	4	12	\N	1	\N
3418	4822	177	55	\N	0	\N
3419	4822	127	12	\N	0	\N
3420	4822	129	69855	\N	1	\N
3421	4849	214	214	\N	1	\N
3422	4849	10	214	\N	0	\N
3423	4850	203	1	\N	2	\N
3424	4850	214	5	\N	0	\N
3425	4850	10	21	\N	1	\N
3426	4852	10	1	\N	1	\N
3427	4853	203	1	\N	1	\N
3428	4859	215	214	\N	1	\N
3429	4859	250	21	\N	2	\N
3430	4859	98	1	\N	3	\N
3431	4860	250	1	\N	2	\N
3432	4860	251	1	\N	1	\N
3433	4861	215	214	\N	1	\N
3434	4861	250	5	\N	2	\N
3435	4863	250	6	\N	1	\N
3436	4864	149	6	\N	1	\N
3437	4865	129	1074	\N	1	\N
3438	4866	124	1074	\N	1	\N
3439	4869	174	1845266	\N	1	\N
3440	4870	174	1579958	\N	1	\N
3441	4871	174	1579958	\N	1	\N
3442	4872	100	1579958	\N	0	\N
3443	4872	178	1845266	\N	1	\N
3444	4872	56	1579958	\N	0	\N
3445	4874	8	36315	\N	1	\N
3446	4875	8	27439	\N	1	\N
3447	4876	8	5035	\N	1	\N
3448	4877	8	3420	\N	1	\N
3449	4878	8	41632	\N	1	\N
3450	4879	8	41632	\N	1	\N
3451	4880	56	41632	\N	0	\N
3452	4880	100	41632	\N	1	\N
3453	4880	178	36315	\N	0	\N
3454	4880	125	27439	\N	0	\N
3455	4880	256	5035	\N	2	\N
3456	4880	82	3420	\N	3	\N
3457	4893	56	6086	\N	0	\N
3458	4893	100	6086	\N	0	\N
3459	4893	249	6086	\N	1	\N
3460	4894	168	6086	\N	1	\N
3461	4895	168	6086	\N	1	\N
3462	4896	168	6086	\N	1	\N
3463	4897	129	1	\N	2	\N
3464	4897	103	1	\N	1	\N
3465	4898	103	2	\N	1	\N
3466	4899	126	2	\N	1	\N
3467	4899	124	1	\N	2	\N
3468	4900	124	1	\N	1	\N
3469	4901	154	933	\N	1	\N
3470	4902	154	12	\N	1	\N
3471	4903	7	12	\N	0	\N
3472	4903	15	933	\N	1	\N
3473	4904	72	437249	\N	1	\N
3474	4906	51	437249	\N	1	\N
3475	4907	17	145250	\N	1	\N
3476	4908	37	145250	\N	1	\N
3477	4915	8	33455	\N	1	\N
3478	4916	101	33455	\N	1	\N
3479	4925	59	6793	\N	1	\N
3480	4925	129	1	\N	0	\N
3481	4926	167	6793	\N	1	\N
3482	4927	167	1	\N	1	\N
3483	4928	7	1	\N	3	\N
3484	4928	8	36	\N	0	\N
3485	4928	38	36	\N	2	\N
3486	4928	212	1600	\N	1	\N
3487	4929	154	67	\N	3	\N
3488	4929	213	71	\N	2	\N
3489	4929	8	177	\N	1	\N
3490	4929	7	2	\N	0	\N
3491	4932	66	44	\N	1	\N
3492	4933	8	76	\N	1	\N
3493	4933	38	38	\N	0	\N
3494	4934	212	54	\N	1	\N
3495	4935	99	1	\N	0	\N
3496	4935	8	4	\N	1	\N
3497	4935	39	1	\N	2	\N
3498	4936	201	8	\N	1	\N
3499	4937	10	1	\N	0	\N
3500	4937	214	1	\N	1	\N
3501	4939	8	135	\N	1	\N
3502	4939	7	1	\N	0	\N
3503	4939	213	71	\N	2	\N
3504	4939	154	67	\N	3	\N
3505	4944	8	4	\N	1	\N
3506	4944	39	1	\N	2	\N
3507	4944	99	1	\N	0	\N
3508	4945	140	54	\N	2	\N
3509	4945	212	1600	\N	1	\N
3510	4946	38	135	\N	0	\N
3511	4946	99	4	\N	0	\N
3512	4946	39	4	\N	4	\N
3513	4946	212	36	\N	3	\N
3514	4946	8	177	\N	1	\N
3515	4946	154	76	\N	2	\N
3516	4947	8	71	\N	0	\N
3517	4947	38	71	\N	1	\N
3518	4948	8	67	\N	0	\N
3519	4948	38	67	\N	1	\N
3520	4949	135	44	\N	1	\N
3521	4950	201	8	\N	1	\N
3522	4951	39	1	\N	1	\N
3523	4951	99	1	\N	0	\N
3524	4952	10	1	\N	1	\N
3525	4953	212	36	\N	2	\N
3526	4953	154	38	\N	1	\N
3527	4954	212	1	\N	2	\N
3528	4954	38	1	\N	0	\N
3529	4954	8	2	\N	1	\N
3530	4955	10	1	\N	1	\N
3531	4956	99	1	\N	0	\N
3532	4956	39	1	\N	1	\N
3533	5092	78	8500	\N	1	\N
3534	5093	78	2	\N	1	\N
3535	5094	176	8500	\N	1	\N
3536	5094	262	2	\N	1	\N
3537	5101	8	34630	\N	1	\N
3538	5101	33	16	\N	2	\N
3539	5102	101	34630	\N	1	\N
3540	5103	101	16	\N	1	\N
3541	5104	8	2145	\N	1	\N
3542	5105	253	2145	\N	1	\N
3543	5112	8	1200	\N	1	\N
3544	5113	8	6	\N	1	\N
3545	5114	8	2	\N	1	\N
3546	5115	107	1200	\N	1	\N
3547	5115	87	6	\N	0	\N
3548	5115	7	2	\N	0	\N
3549	5117	8	571	\N	1	\N
3550	5118	130	571	\N	1	\N
3551	5126	144	53586	\N	1	\N
3552	5127	144	53586	\N	1	\N
3553	5128	60	53586	\N	1	\N
3554	5128	56	53586	\N	0	\N
3555	5140	79	152119	\N	1	\N
3556	5141	79	127669	\N	1	\N
3557	5142	79	127669	\N	1	\N
3558	5143	100	127669	\N	0	\N
3559	5143	56	127669	\N	0	\N
3560	5143	125	152119	\N	1	\N
3561	5154	8	22	\N	1	\N
3562	5155	8	22	\N	1	\N
3563	5163	8	10566	\N	1	\N
3564	5164	8	4433	\N	1	\N
3565	5165	128	4433	\N	2	\N
3566	5165	253	10566	\N	1	\N
3567	5177	77	9790	\N	1	\N
3568	5178	101	9790	\N	1	\N
3569	5212	8	4909	\N	1	\N
3570	5213	240	4909	\N	1	\N
3571	5261	8	130095	\N	1	\N
3572	5262	8	130095	\N	1	\N
3573	5274	5	3	\N	1	\N
3574	5275	171	3	\N	1	\N
3575	5276	8	2078	\N	1	\N
3576	5277	128	2078	\N	1	\N
3577	5283	33	32	\N	2	\N
3578	5283	8	1827890	\N	1	\N
3579	5284	1	1827890	\N	1	\N
3580	5285	1	32	\N	1	\N
3581	5300	8	1898	\N	1	\N
3582	5301	128	1898	\N	1	\N
3583	5304	8	6716407	\N	1	\N
3584	5305	8	630079	\N	1	\N
3585	5306	8	509915	\N	1	\N
3586	5307	8	1306	\N	1	\N
3587	5308	8	411064	\N	1	\N
3588	5309	227	509915	\N	3	\N
3589	5309	113	411064	\N	0	\N
3590	5309	112	6716407	\N	1	\N
3591	5309	28	630079	\N	2	\N
3592	5309	13	1306	\N	4	\N
3593	5325	8	3389	\N	1	\N
3594	5326	253	3389	\N	1	\N
3595	5329	8	1845752	\N	1	\N
3596	5330	169	1845752	\N	1	\N
3597	5334	78	8873	\N	1	\N
3598	5335	78	1	\N	1	\N
3599	5336	176	8873	\N	1	\N
3600	5336	262	1	\N	1	\N
3601	5337	73	1973	\N	1	\N
3602	5338	197	1973	\N	1	\N
3603	5343	247	1	\N	1	\N
3604	5345	251	1	\N	1	\N
3605	5347	78	8028	\N	1	\N
3606	5348	78	1	\N	1	\N
3607	5349	176	8028	\N	1	\N
3608	5349	262	1	\N	1	\N
3609	5351	56	69714	\N	0	\N
3610	5351	249	69714	\N	1	\N
3611	5351	100	69714	\N	0	\N
3612	5352	196	69714	\N	1	\N
3613	5353	196	69714	\N	1	\N
3614	5354	196	69714	\N	1	\N
3615	5382	103	42	\N	2	\N
3616	5382	129	139	\N	1	\N
3617	5384	127	139	\N	1	\N
3618	5385	127	42	\N	1	\N
3619	5390	8	192	\N	1	\N
3620	5391	8	2	\N	1	\N
3621	5392	8	192	\N	1	\N
3622	5392	7	2	\N	0	\N
3623	5395	250	6	\N	1	\N
3624	5396	149	6	\N	1	\N
3625	5406	8	10349	\N	1	\N
3626	5407	253	10349	\N	1	\N
3627	5415	78	8873	\N	1	\N
3628	5416	78	1	\N	1	\N
3629	5417	176	8873	\N	1	\N
3630	5417	262	1	\N	1	\N
3631	5424	8	290	\N	1	\N
3632	5425	107	290	\N	1	\N
3633	5440	8	474446	\N	1	\N
3634	5440	33	52	\N	0	\N
3635	5441	8	407688	\N	1	\N
3636	5441	33	52	\N	2	\N
3637	5442	113	474446	\N	1	\N
3638	5442	112	407688	\N	0	\N
3639	5443	112	52	\N	0	\N
3640	5443	113	52	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
81	n_1	http://reference.eionet.europa.eu/aq/ontology/	0	f	0
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
69		http://rdfdata.eionet.europa.eu/airquality/ontology/	0	t	0
17	openlinks	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
70	geonames	http://www.geonames.org/ontology#	0	f	0
71	sdmxdim	http://purl.org/linked-data/sdmx/2009/dimension#	0	f	0
72	dcmit	http://purl.org/dc/dcmitype/	0	f	0
73	qb	http://purl.org/linked-data/cube#	0	f	0
74	xhv	http://www.w3.org/1999/xhtml/vocab#	0	f	0
75	ov	http://open.vocab.org/terms/	0	f	0
76	dcam	http://purl.org/dc/dcam/	0	f	0
77	sdmxa	http://purl.org/linked-data/sdmx/2009/attribute#	0	f	0
78	scovo	http://purl.org/NET/scovo#	0	f	0
79	vs	http://www.w3.org/2003/06/sw-vocab-status/ns#	0	f	0
80	adms	http://www.w3.org/ns/adms#	0	f	0
82	n_2	http://cr.eionet.europa.eu/ontologies/contreg.rdf#	0	f	0
83	n_3	http://rdfdata.eionet.europa.eu/article17/ontology/	0	f	0
84	n_4	http://rod.eionet.europa.eu/schema.rdf#	0	f	0
85	n_5	http://rdfdata.eionet.europa.eu/msfd/ontology/	0	f	0
86	n_6	http://rdfdata.eionet.europa.eu/wise/ontology/	0	f	0
87	n_7	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/	0	f	0
88	n_8	http://rdfdata.eionet.europa.eu/eea/ontology/	0	f	0
89	n_9	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv/	0	f	0
90	n_10	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv/	0	f	0
91	ramon	http://rdfdata.eionet.europa.eu/ramon/ontology/	0	f	0
92	code	http://telegraphis.net/ontology/measurement/code#	0	f	0
93	n_11	http://psi.oasis-open.org/iso/639/#	0	f	0
94	n_12	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv/	0	f	0
95	n_13	http://rdfdata.eionet.europa.eu/waterbase/ontology/	0	f	0
96	n_14	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv/	0	f	0
97	n_15	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv/	0	f	0
98	api	http://purl.org/linked-data/api/vocab#	0	f	0
99	n_16	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv/	0	f	0
100	n_17	http://rdfdata.eionet.europa.eu/article17/	0	f	0
101	n_18	http://rdfdata.eionet.europa.eu/inspire-m/ontology/	0	f	0
102	n_19	http://rdfdata.eionet.europa.eu/uwwtd/ontology/	0	f	0
103	n_20	http://rdfdata.eionet.europa.eu/ghg/ontology/	0	f	0
104	n_21	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv/	0	f	0
105	n_22	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv/	0	f	0
106	n_23	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv/	0	f	0
107	n_24	http://eunis.eea.europa.eu/rdf/schema.rdf#	0	f	0
108	spin	http://spinrdf.org/spin#	0	f	0
109	n_25	http://dd.eionet.europa.eu/schema.rdf#	0	f	0
110	n_26	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#	0	f	0
111	n_27	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv/	0	f	0
112	n_28	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv/	0	f	0
113	n_29	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv/	0	f	0
114	n_30	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv/	0	f	0
115	n_31	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv/	0	f	0
116	n_32	http://rdfdata.eionet.europa.eu/ippc/ontology/	0	f	0
117	geographis	http://telegraphis.net/ontology/geography/geography#	0	f	0
118	n_33	http://rdfdata.eionet.europa.eu/article17/generalreport/	0	f	0
119	n_34	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv/	0	f	0
120	n_35	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv/	0	f	0
121	n_36	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv/	0	f	0
122	n_37	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv/	0	f	0
123	n_38	http://telegraphis.net/ontology/measurement/measurement#	0	f	0
124	n_39	http://dd.eionet.europa.eu/tables/8286/rdf/	0	f	0
125	n_40	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv/	0	f	0
126	n_41	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv/	0	f	0
127	n_42	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv/	0	f	0
128	n_43	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#	0	f	0
129	n_44	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#	0	f	0
130	n_45	http://dd.eionet.europa.eu/property/	0	f	0
131	n_46	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv#	0	f	0
132	n_47	http://dd.eionet.europa.eu/tables/8286/rdf#	0	f	0
133	n_48	http://www.snee.com/ns/	0	f	0
134	n_49	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv#	0	f	0
135	n_50	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv#	0	f	0
136	n_51	http://xmlns.org/foaf/0.1/	0	f	0
137	n_52	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#	0	f	0
138	n_53	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#	0	f	0
139	n_54	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv#	0	f	0
140	n_55	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv#	0	f	0
141	wdrs	http://www.w3.org/2007/05/powder-s#	0	f	0
142	n_56	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv#	0	f	0
143	n_57	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#	0	f	0
144	n_58	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv#	0	f	0
145	n_59	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv#	0	f	0
146	n_60	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#	0	f	0
147	n_61	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#	0	f	0
148	n_62	http://discomap.eea.europa.eu//#	0	f	0
149	n_63	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv#	0	f	0
150	n_64	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv#	0	f	0
151	n_65	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv#	0	f	0
152	n_66	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv#	0	f	0
153	n_67	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#	0	f	0
154	n_68	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#	0	f	0
155	n_69	http://rdfdata.eionet.europa.eu/eurostat/property#	0	f	0
156	sdmxm	http://purl.org/linked-data/sdmx/2009/measure#	0	f	0
157	opensearch	http://a9.com/-/spec/opensearch/1.1/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_cr_eionet_europa_eu	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_cr_eionet_europa_eu	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://cr.eionet.europa.eu/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://cr.eionet.europa.eu/sparql", "correlationId": "3692239771482203805", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": "base", "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:27:41.375Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://xmlns.com/foaf/0.1/name	75	\N	8	name	name	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://rdfdata.eionet.europa.eu/uwwtd/ontology/forrcaSensitiveArea	2859	\N	102	forrcaSensitiveArea	forrcaSensitiveArea	f	2859	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.w3.org/2004/02/skos/core#note	19061	\N	4	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://cr.eionet.europa.eu/ontologies/contreg.rdf#attachmentOf	37950	\N	82	attachmentOf	attachmentOf	f	37950	\N	\N	f	f	252	248	\N	t	f	\N	\N	\N	t	f	f
5	http://purl.org/dc/terms/spatial	10204	\N	5	spatial	spatial	f	10204	\N	\N	f	f	\N	154	\N	t	f	\N	\N	\N	t	f	f
6	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv23	1	\N	101	DSv23	DSv23	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv21	1	\N	101	DSv21	DSv21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv22	1	\N	101	DSv22	DSv22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Region	5149	\N	128	Region	Region	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv_Num2	1	\N	101	DSv_Num2	DSv_Num2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv_Num3	1	\N	101	DSv_Num3	DSv_Num3	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv_Num1	1	\N	101	DSv_Num1	DSv_Num1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://rdfdata.eionet.europa.eu/wise/ontology/ANALYSIS_METHOD	5544	\N	86	ANALYSIS_METHOD	ANALYSIS_METHOD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://reference.eionet.europa.eu/aq/ontology/zoneType	1230	\N	81	zoneType	zoneType	f	1230	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://reference.eionet.europa.eu/aq/ontology/temporalResolutionNum	3221	\N	81	temporalResolutionNum	temporalResolutionNum	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPDischargeEstimated	520	\N	102	uwwPDischargeEstimated	uwwPDischargeEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#sameEEAGlossary	1	\N	110	sameEEAGlossary	sameEEAGlossary	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwAccidents	32485	\N	102	uwwAccidents	uwwAccidents	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#numberofinhabitants	456	\N	129	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_magnitude_ci	168	\N	83	coverage_trend_magnitude_ci	coverage_trend_magnitude_ci	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggAccOverflowNumber	2729	\N	102	aggAccOverflowNumber	aggAccOverflowNumber	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://rdfdata.eionet.europa.eu/article17/generalreport/measures	17	\N	118	measures	measures	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://cr.eionet.europa.eu/ontologies/contreg.rdf#feedbackFor	149204	\N	82	feedbackFor	feedbackFor	f	149204	\N	\N	f	f	248	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://purl.org/dc/elements/1.1/description	108	\N	6	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://rdfdata.eionet.europa.eu/article17/ontology/annex_ii	269	\N	83	annex_ii	annex_ii	f	0	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://rdfdata.eionet.europa.eu/airquality/ontology/heightFacadesUOM	56843	\N	69	heightFacadesUOM	heightFacadesUOM	f	56843	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.openlinksw.com/schemas/virtrdf#qmfSqlvalOfShortTmpl	53	\N	17	qmfSqlvalOfShortTmpl	qmfSqlvalOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://rdfdata.eionet.europa.eu/airquality/ontology/aggregationTimeZone	13691	\N	69	aggregationTimeZone	aggregationTimeZone	f	13691	\N	\N	f	f	82	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://rdfdata.eionet.europa.eu/airquality/ontology/accuracyMeasurements	9173	\N	69	accuracyMeasurements	accuracyMeasurements	f	9173	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
32	http://rdfdata.eionet.europa.eu/airquality/ontology/website	1891809	\N	69	website	website	f	0	\N	\N	f	f	145	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://dd.eionet.europa.eu/property/measurementEquipment	1047	\N	130	measurementEquipment	measurementEquipment	f	419	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://reference.eionet.europa.eu/aq/ontology/commentExceedanceAdjustment	142	\N	81	commentExceedanceAdjustment	commentExceedanceAdjustment	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://rdfdata.eionet.europa.eu/article17/ontology/annex_iv	127	\N	83	annex_iv	annex_iv	f	0	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv3	1	\N	101	NSv3	NSv3	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv4	1	\N	101	NSv4	NSv4	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceDescriptionFinal	222686	\N	69	exceedanceDescriptionFinal	exceedanceDescriptionFinal	f	222686	\N	\N	f	f	205	196	\N	t	f	\N	\N	\N	t	f	f
39	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_habitat_trend	3598	\N	83	conclusion_habitat_trend	conclusion_habitat_trend	f	3598	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
40	http://xmlns.com/foaf/0.1/homepage	89	\N	8	homepage	homepage	f	89	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://rdfdata.eionet.europa.eu/airquality/ontology/classificationDate	479066	\N	69	classificationDate	classificationDate	f	479066	\N	\N	f	f	113	59	\N	t	f	\N	\N	\N	t	f	f
42	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggChangesComment	5230	\N	102	aggChangesComment	aggChangesComment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwUV	35949	\N	102	uwwUV	uwwUV	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/2004/02/skos/core#hiddenLabel	798	\N	4	hiddenLabel	hiddenLabel	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://purl.org/dc/terms/contributor	175	\N	5	contributor	contributor	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://purl.org/dc/terms/abstract	854	\N	5	abstract	abstract	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1490	http://rdfdata.eionet.europa.eu/airquality/ontology/upperCorner	750	\N	69	upperCorner	upperCorner	f	0	\N	\N	f	f	198	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://rod.eionet.europa.eu/schema.rdf#startOfPeriod	45111	\N	84	startOfPeriod	startOfPeriod	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_method	4430	\N	83	[Method used for area estimation (coverage_method)]	coverage_method	f	4430	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
63	http://rdfdata.eionet.europa.eu/wise/ontology/EU_CD	40828	\N	86	[EU Code (EU_CD)]	EU_CD	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://rdfdata.eionet.europa.eu/article17/ontology/habitatcode	14053	\N	83	habitatcode	habitatcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://reference.eionet.europa.eu/aq/ontology/station_lon	935516	\N	81	[Longitude of measurement station (station_lon)]	station_lon	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://rdfdata.eionet.europa.eu/wise/ontology/MEASURED_AS	7047	\N	86	MEASURED_AS	MEASURED_AS	f	0	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_surface_area	6922	\N	83	[Surface area of the habitat type in km2 (coverage_surface_area)]	coverage_surface_area	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://rdfdata.eionet.europa.eu/article17/generalreportcoverage	22	\N	100	generalreportcoverage	generalreportcoverage	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://rdfdata.eionet.europa.eu/airquality/ontology/declarationFor	6428170	\N	69	declarationFor	declarationFor	f	6428170	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://rdfdata.eionet.europa.eu/msfd/ontology/postcode	282	\N	85	postcode	postcode	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://reference.eionet.europa.eu/aq/ontology/spatialExtent	170232	\N	81	spatialExtent	spatialExtent	f	73559	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_sources	1008	\N	83	range_trend_long_sources	range_trend_long_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://www.openlinksw.com/schemas/virtrdf#qmfLongOfShortTmpl	45	\N	17	qmfLongOfShortTmpl	qmfLongOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://rdfdata.eionet.europa.eu/wise/ontology/UpwardTrendPollutant	868	\N	86	UpwardTrendPollutant	UpwardTrendPollutant	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_GW_Level_Amplitude_Min	457	\N	86	Annual_GW_Level_Amplitude_Min	Annual_GW_Level_Amplitude_Min	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://rdfdata.eionet.europa.eu/ramon/ontology/name	8876	\N	91	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.openlinksw.com/schemas/virtrdf#qmfSparqlEbvOfShortTmpl	37	\N	17	qmfSparqlEbvOfShortTmpl	qmfSparqlEbvOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://rod.eionet.europa.eu/schema.rdf#guidelinesName	505	\N	84	guidelinesName	guidelinesName	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://rdfdata.eionet.europa.eu/msfd/ontology/auth_CD	246	\N	85	auth_CD	auth_CD	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://telegraphis.net/ontology/measurement/code#inCodeScheme	984	\N	92	inCodeScheme	inCodeScheme	f	984	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://purl.org/dc/terms/extent	755	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://rod.eionet.europa.eu/schema.rdf#clientDescription	61	\N	84	clientDescription	clientDescription	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://rod.eionet.europa.eu/schema.rdf#clientPostalCode	64	\N	84	clientPostalCode	clientPostalCode	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaHydrologie	5220	\N	102	rcaHydrologie	rcaHydrologie	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.openlinksw.com/schemas/virtrdf#qmfBoolTmpl	42	\N	17	qmfBoolTmpl	qmfBoolTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://rdfs.org/ns/void#exampleResource	25	\N	16	exampleResource	exampleResource	f	25	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://reference.eionet.europa.eu/aq/ontology/dataQualityDescription	3054	\N	81	dataQualityDescription	dataQualityDescription	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://rdfdata.eionet.europa.eu/airquality/ontology/macroExceedanceSituation	1512	\N	69	macroExceedanceSituation	macroExceedanceSituation	f	1512	\N	\N	f	f	124	196	\N	t	f	\N	\N	\N	t	f	f
75	http://rdfdata.eionet.europa.eu/uwwtd/ontology/foraggID	19043	\N	102	foraggID	foraggID	f	19043	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWFDSubUnit	10189	\N	102	dcpWFDSubUnit	dcpWFDSubUnit	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://dd.eionet.europa.eu/property/primaryObservationTime	1194	\N	130	primaryObservationTime	primaryObservationTime	f	1194	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://rod.eionet.europa.eu/schema.rdf#guidelinesURI	458	\N	84	guidelinesURI	guidelinesURI	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://rdfdata.eionet.europa.eu/article17/generalreport/legal-texts	35	\N	118	legal-texts	legal-texts	f	0	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_population_trend	3078	\N	83	natura2000_population_trend	natura2000_population_trend	f	3078	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
81	http://rdfdata.eionet.europa.eu/airquality/ontology/trafficEmissionsUOM	394994	\N	69	trafficEmissionsUOM	trafficEmissionsUOM	f	394773	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_date	9734	\N	83	habitat_date	habitat_date	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi12	1	\N	101	MDi12	MDi12	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi11	1	\N	101	MDi11	MDi11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi14	1	\N	101	MDi14	MDi14	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi13	1	\N	101	MDi13	MDi13	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://cr.eionet.europa.eu/ontologies/contreg.rdf#contentLastModified	760497	\N	82	contentLastModified	contentLastModified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi21	1	\N	101	MDi21	MDi21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1491	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi41	1	\N	101	NSi41	NSi41	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://rod.eionet.europa.eu/schema.rdf#locality	46333	\N	84	locality	locality	f	46333	\N	\N	f	f	102	154	\N	t	f	\N	\N	\N	t	f	f
90	http://www.openlinksw.com/schemas/virtrdf#qmvcColumnName	8	\N	17	qmvcColumnName	qmvcColumnName	f	0	\N	\N	f	f	146	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://rdfdata.eionet.europa.eu/airquality/ontology/totalPopulation	985	\N	69	totalPopulation	totalPopulation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://purl.org/dc/terms/valid	415	\N	5	valid	valid	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://rdfdata.eionet.europa.eu/airquality/ontology/surfaceMembers	67	\N	69	surfaceMembers	surfaceMembers	f	41	\N	\N	f	f	206	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://rdfdata.eionet.europa.eu/airquality/ontology/observingTime	2367115	\N	69	observingTime	observingTime	f	2367115	\N	\N	f	f	233	177	\N	t	f	\N	\N	\N	t	f	f
95	http://www.geonames.org/ontology#featureClass	416	\N	70	featureClass	featureClass	f	416	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslWWReuseExplain	10	\N	102	mslWWReuseExplain	mslWWReuseExplain	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv#ctrycd	140681	\N	131	ctrycd	ctrycd	f	0	\N	\N	f	f	219	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://rdfdata.eionet.europa.eu/airquality/ontology/change	18215	\N	69	change	change	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://rdfdata.eionet.europa.eu/article17/generalreport/non-territorial-plan	1177	\N	118	non-territorial-plan	non-territorial-plan	f	1177	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://dd.eionet.europa.eu/property/LongitudeMin	45	\N	130	LongitudeMin	LongitudeMin	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.openlinksw.com/schemas/virtrdf#qmSubjectMap	2	\N	17	qmSubjectMap	qmSubjectMap	f	2	\N	\N	f	f	30	228	\N	t	f	\N	\N	\N	t	f	f
102	http://rdfdata.eionet.europa.eu/article17/ontology/forSpecies	16972	\N	83	forSpecies	forSpecies	f	16972	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://rdfdata.eionet.europa.eu/ramon/ontology/hasPart	2610	\N	91	hasPart	hasPart	f	2610	\N	\N	f	f	212	212	\N	t	f	\N	\N	\N	t	f	f
104	http://rdfdata.eionet.europa.eu/airquality/ontology/modelUsed	4759	\N	69	modelUsed	modelUsed	f	4759	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi23	1	\N	101	MDi23	MDi23	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://reference.eionet.europa.eu/aq/ontology/observingTimeStart	1054932	\N	81	observingTimeStart	observingTimeStart	f	0	\N	\N	f	f	116	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://rdfdata.eionet.europa.eu/airquality/ontology/expectedConcentration	927	\N	69	expectedConcentration	expectedConcentration	f	0	\N	\N	f	f	143	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi22	1	\N	101	MDi22	MDi22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi24	1	\N	101	MDi24	MDi24	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://rdfdata.eionet.europa.eu/waterbase/ontology/wFD_EU_CD	4314	\N	95	wFD_EU_CD	wFD_EU_CD	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://rdfdata.eionet.europa.eu/article17/ontology/population_alt_size_unit	4836	\N	83	population_alt_size_unit	population_alt_size_unit	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://rdfdata.eionet.europa.eu/airquality/ontology/status	26233	\N	69	status	status	f	26233	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
113	http://reference.eionet.europa.eu/aq/ontology/station	935516	\N	81	station	station	f	935516	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://rdfdata.eionet.europa.eu/article17/ontology/range_period	218	\N	83	range_period	range_period	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#AnnualTrafficFlow	5149	\N	128	AnnualTrafficFlow	AnnualTrafficFlow	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://rdfdata.eionet.europa.eu/airquality/ontology/spatialExtent	3520	\N	69	spatialExtent	spatialExtent	f	1662	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaAPhos	5548	\N	102	rcaAPhos	rcaAPhos	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://reference.eionet.europa.eu/aq/ontology/finalDeductionMethod	89214	\N	81	finalDeductionMethod	finalDeductionMethod	f	89214	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://rdfdata.eionet.europa.eu/wise/ontology/CHEM_SURVEIL	119974	\N	86	CHEM_SURVEIL	CHEM_SURVEIL	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rptCulture	52	\N	102	rptCulture	rptCulture	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://rdfdata.eionet.europa.eu/article17/generalreport/other-plan	4430	\N	118	other-plan	other-plan	f	4430	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://xmlns.com/foaf/0.1/mbox	41	\N	8	mbox	mbox	f	41	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://www.geonames.org/ontology#wikipediaArticle	313	\N	70	wikipediaArticle	wikipediaArticle	f	313	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://dd.eionet.europa.eu/tables/8286/rdf#forRBD	19971	\N	132	forRBD	forRBD	f	19971	\N	\N	f	f	234	133	\N	t	f	\N	\N	\N	t	f	f
125	http://rdfdata.eionet.europa.eu/inspire-m/ontology/discovery	125	\N	101	discovery	discovery	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://rod.eionet.europa.eu/schema.rdf#link	46285	\N	84	link	link	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://purl.org/dc/terms/hasPart	209	\N	5	hasPart	hasPart	f	209	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://rdfdata.eionet.europa.eu/article17/ontology/quality	19495	\N	83	quality	quality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_magnitude_ci	608	\N	83	population_trend_long_magnitude_ci	population_trend_long_magnitude_ci	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaPlants	329	\N	102	rcaPlants	rcaPlants	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://dd.eionet.europa.eu/property/PopulationDifference	45	\N	130	PopulationDifference	PopulationDifference	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_population	16569	\N	83	[Conclusion on population (conclusion_population)]	conclusion_population	f	10566	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://rdfdata.eionet.europa.eu/article17/ontology/population_type_of_estimate	135	\N	83	population_type_of_estimate	population_type_of_estimate	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend	23592	\N	83	[Range trend (range_trend)]	range_trend	f	14945	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://rdfdata.eionet.europa.eu/airquality/ontology/dispersionRegional	49112	\N	69	dispersionRegional	dispersionRegional	f	49112	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://reference.eionet.europa.eu/aq/ontology/trafficSpeed	2501	\N	81	trafficSpeed	trafficSpeed	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://rdfdata.eionet.europa.eu/article17/generalreportforCountry	66	\N	100	generalreportforCountry	generalreportforCountry	f	66	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://rdfdata.eionet.europa.eu/wise/ontology/EURBDCode	460	\N	86	EURBDCode	EURBDCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	20	\N	1	rest	rest	f	20	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://rdfdata.eionet.europa.eu/wise/ontology/forWB	155810	\N	86	forWB	forWB	f	155810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://rdfdata.eionet.europa.eu/msfd/ontology/countryCode	60	\N	85	countryCode	countryCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://www.openlinksw.com/schemas/virtrdf#qmfDatatypeTmpl	2	\N	17	qmfDatatypeTmpl	qmfDatatypeTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://www.snee.com/ns/epaudio-sample	114	\N	133	epaudio-sample	epaudio-sample	f	114	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://rod.eionet.europa.eu/schema.rdf#endOfPeriod	45139	\N	84	endOfPeriod	endOfPeriod	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://rdfdata.eionet.europa.eu/article17/generalreport/type-plan	3998	\N	118	type-plan	type-plan	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://www.openlinksw.com/schemas/virtrdf#qmfStrsqlvalOfShortTmpl	53	\N	17	qmfStrsqlvalOfShortTmpl	qmfStrsqlvalOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaDateArt54	210	\N	102	rcaDateArt54	rcaDateArt54	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv#icaocode	94	\N	134	icaocode	icaocode	f	0	\N	\N	f	f	109	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://rdfdata.eionet.europa.eu/airquality/ontology/buildingDistanceUOM	805852	\N	69	buildingDistanceUOM	buildingDistanceUOM	f	805852	\N	\N	f	f	35	8	\N	t	f	\N	\N	\N	t	f	f
150	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaDateArt58	20	\N	102	rcaDateArt58	rcaDateArt58	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://rdfdata.eionet.europa.eu/airquality/ontology/implementationActualTimePeriod	2493	\N	69	implementationActualTimePeriod	implementationActualTimePeriod	f	2493	\N	\N	f	f	167	177	\N	t	f	\N	\N	\N	t	f	f
152	http://rdfdata.eionet.europa.eu/article17/generalreportdatabase_date	66	\N	100	generalreportdatabase_date	generalreportdatabase_date	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://www.geonames.org/ontology#parentFeature	533	\N	70	parentFeature	parentFeature	f	533	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://rdfdata.eionet.europa.eu/uwwtd/ontology/foraucUwwCode	36540	\N	102	foraucUwwCode	foraucUwwCode	f	36540	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggSewageNetwork	1552	\N	102	aggSewageNetwork	aggSewageNetwork	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv#ReferenceDataSet	225	\N	135	ReferenceDataSet	ReferenceDataSet	f	0	\N	\N	f	f	159	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://rdfdata.eionet.europa.eu/article17/ontology/range_map	9854	\N	83	range_map	range_map	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://rdfdata.eionet.europa.eu/article17/ontology/additional_distribution_map	9822	\N	83	additional_distribution_map	additional_distribution_map	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://cr.eionet.europa.eu/ontologies/contreg.rdf#useOwlSameAs	82	\N	82	useOwlSameAs	useOwlSameAs	f	0	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://rdfdata.eionet.europa.eu/eea/ontology/nationality	69	\N	88	nationality	nationality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_GW_Level_Amplitude_Max	482	\N	86	Annual_GW_Level_Amplitude_Max	Annual_GW_Level_Amplitude_Max	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://rdfdata.eionet.europa.eu/airquality/ontology/numberExceedances	90830	\N	69	numberExceedances	numberExceedances	f	0	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://eunis.eea.europa.eu/rdf/schema.rdf#hasCDDASites	611	\N	107	hasCDDASites	hasCDDASites	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://rod.eionet.europa.eu/schema.rdf#loccode	69	\N	84	loccode	loccode	f	0	\N	\N	f	f	154	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaCode	5548	\N	102	rcaCode	rcaCode	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Comment	5149	\N	128	Comment	Comment	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv#annualtraffic	94	\N	134	annualtraffic	annualtraffic	f	0	\N	\N	f	f	109	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://dd.eionet.europa.eu/property/minimumSPO	162	\N	130	minimumSPO	minimumSPO	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://www.openlinksw.com/schemas/virtrdf#qmfIsrefOfShortTmpl	31	\N	17	qmfIsrefOfShortTmpl	qmfIsrefOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://cr.eionet.europa.eu/ontologies/contreg.rdf#redirectedTo	980926	\N	82	redirectedTo	redirectedTo	f	980926	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://rod.eionet.europa.eu/schema.rdf#eeaGroup	5	\N	84	eeaGroup	eeaGroup	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwState	36012	\N	102	uwwState	uwwState	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1492	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBadDesign	32485	\N	102	uwwBadDesign	uwwBadDesign	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1493	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi22	1	\N	101	NSi22	NSi22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://rdfdata.eionet.europa.eu/airquality/ontology/expectedImpact	16679	\N	69	expectedImpact	expectedImpact	f	16679	\N	\N	f	f	127	114	\N	t	f	\N	\N	\N	t	f	f
193	http://rdfdata.eionet.europa.eu/article17/ontology/population_reasons	13972	\N	83	[Reasons for reported trend (population_reasons)]	population_reasons	f	7715	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://rdfdata.eionet.europa.eu/wise/ontology/WELL_OR_SPRING	40824	\N	86	WELL_OR_SPRING	WELL_OR_SPRING	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/numberofinhabitants	549	\N	87	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwDateClosing	311	\N	102	uwwDateClosing	uwwDateClosing	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://www.w3.org/2004/02/skos/core#member	41114	\N	4	member	member	f	41114	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://purl.org/dc/elements/1.1/coverage	157	\N	6	coverage	coverage	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://rdfdata.eionet.europa.eu/article17/generalreportsites_total_area	51	\N	100	generalreportsites_total_area	generalreportsites_total_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://rdfdata.eionet.europa.eu/wise/ontology/length	202	\N	86	length	length	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_trend_period	10491	\N	83	habitat_trend_period	habitat_trend_period	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://rdfdata.eionet.europa.eu/airquality/ontology/individualName	1961543	\N	69	individualName	individualName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://reference.eionet.europa.eu/aq/ontology/buildingDistanceUOM	36128	\N	81	buildingDistanceUOM	buildingDistanceUOM	f	36128	\N	\N	f	f	202	8	\N	t	f	\N	\N	\N	t	f	f
186	http://rdfdata.eionet.europa.eu/article17/generalreporttitle	14	\N	100	generalreporttitle	generalreporttitle	f	0	\N	\N	f	f	242	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://rdfdata.eionet.europa.eu/airquality/ontology/implementationPlannedTimePeriod	25693	\N	69	implementationPlannedTimePeriod	implementationPlannedTimePeriod	f	25693	\N	\N	f	f	167	177	\N	t	f	\N	\N	\N	t	f	f
188	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long_magnitude_ci	168	\N	83	coverage_trend_long_magnitude_ci	coverage_trend_long_magnitude_ci	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDisposalLandfill	49	\N	102	mslDisposalLandfill	mslDisposalLandfill	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://rdfdata.eionet.europa.eu/article17/ontology/forHabitat	4002	\N	83	forHabitat	forHabitat	f	4002	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conRemarks	3	\N	102	conRemarks	conRemarks	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://xmlns.org/foaf/0.1/homepage	8	\N	136	homepage	homepage	f	8	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://reference.eionet.europa.eu/aq/ontology/dispersionRegional	1737	\N	81	dispersionRegional	dispersionRegional	f	1737	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentTypeDescription	486612	\N	69	assessmentTypeDescription	assessmentTypeDescription	f	0	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://reference.eionet.europa.eu/aq/ontology/durationUnit	35830	\N	81	durationUnit	durationUnit	f	35830	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://rod.eionet.europa.eu/schema.rdf#restricted	753314	\N	84	restricted	restricted	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://rdfdata.eionet.europa.eu/wise/ontology/CLASSIFICATION	182	\N	86	CLASSIFICATION	CLASSIFICATION	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://rdfdata.eionet.europa.eu/wise/ontology/RBDName	202	\N	86	RBDName	RBDName	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://purl.org/dc/terms/subject	32	\N	5	subject	subject	f	24	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://dd.eionet.europa.eu/property/LongitudeMax	45	\N	130	LongitudeMax	LongitudeMax	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://rdfdata.eionet.europa.eu/article17/ontology/HabitatTypeTypicalSpecies	36923	\N	83	HabitatTypeTypicalSpecies	HabitatTypeTypicalSpecies	f	36923	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://purl.org/dc/terms/published	1	\N	5	published	published	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://purl.org/linked-data/sdmx/2009/dimension#freq	111996	\N	71	freq	freq	f	111996	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#icaocode	92	\N	137	icaocode	icaocode	f	0	\N	\N	f	f	263	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://rod.eionet.europa.eu/schema.rdf#otherClient	344	\N	84	otherClient	otherClient	f	344	\N	\N	f	f	15	214	\N	t	f	\N	\N	\N	t	f	f
207	http://reference.eionet.europa.eu/aq/ontology/organisationLevel	1291	\N	81	organisationLevel	organisationLevel	f	1291	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://rdfdata.eionet.europa.eu/article17/generalreport/marine_number	104	\N	118	marine_number	marine_number	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://purl.org/dc/terms/publisher	177	\N	5	publisher	publisher	f	86	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://rdfdata.eionet.europa.eu/airquality/ontology/edition	119	\N	69	edition	edition	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://rdfdata.eionet.europa.eu/airquality/ontology/postCode	1471798	\N	69	postCode	postCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://rdfdata.eionet.europa.eu/wise/ontology/Thickness_Min	385	\N	86	Thickness_Min	Thickness_Min	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://purl.org/dc/elements/1.1/issued	1	\N	6	issued	issued	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://rdfdata.eionet.europa.eu/airquality/ontology/geometryMember	18	\N	69	geometryMember	geometryMember	f	0	\N	\N	f	f	95	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://rdfdata.eionet.europa.eu/wise/ontology/EUGroundWaterBodyCode	25252	\N	86	EUGroundWaterBodyCode	EUGroundWaterBodyCode	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://dd.eionet.europa.eu/property/baselineValue	29	\N	130	baselineValue	baselineValue	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://rdfdata.eionet.europa.eu/airquality/ontology/stationUsed	85327	\N	69	stationUsed	stationUsed	f	85327	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODIncomingCalculated	4288	\N	102	uwwCODIncomingCalculated	uwwCODIncomingCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://rdfdata.eionet.europa.eu/waterbase/ontology/geology	2433	\N	95	geology	geology	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://www.w3.org/2002/07/owl#imports	1	\N	7	imports	imports	f	1	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwID	36450	\N	102	uwwID	uwwID	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://reference.eionet.europa.eu/aq/ontology/natlStationCode	9545	\N	81	natlStationCode	natlStationCode	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDisposalOthers	30	\N	102	mslDisposalOthers	mslDisposalOthers	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://rdfdata.eionet.europa.eu/waterbase/ontology/purpose	2708	\N	95	purpose	purpose	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://rdfdata.eionet.europa.eu/article17/generalreport/areas-of-conservation	52	\N	118	areas-of-conservation	areas-of-conservation	f	52	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://rdfdata.eionet.europa.eu/inspire-m/ontology/name	246	\N	101	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://www.openlinksw.com/schemas/virtrdf#qmGraphMap	2	\N	17	qmGraphMap	qmGraphMap	f	2	\N	\N	f	f	30	228	\N	t	f	\N	\N	\N	t	f	f
228	http://www.openlinksw.com/schemas/virtrdf#qmvFormat	8	\N	17	qmvFormat	qmvFormat	f	8	\N	\N	f	f	228	29	\N	t	f	\N	\N	\N	t	f	f
229	http://rdfdata.eionet.europa.eu/airquality/ontology/zoneType	30841	\N	69	zoneType	zoneType	f	30841	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://rdfdata.eionet.europa.eu/airquality/ontology/samplingPointAssessmentMetadata	1468619	\N	69	samplingPointAssessmentMetadata	samplingPointAssessmentMetadata	f	1468619	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://eunis.eea.europa.eu/rdf/schema.rdf#geoCoverage	611	\N	107	geoCoverage	geoCoverage	f	611	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conCity	52	\N	102	conCity	conCity	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://dd.eionet.europa.eu/property/isNumericConceptIdentifiers	209	\N	130	isNumericConceptIdentifiers	isNumericConceptIdentifiers	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaRemarks	940	\N	102	rcaRemarks	rcaRemarks	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://dd.eionet.europa.eu/property/minimumPopulation	162	\N	130	minimumPopulation	minimumPopulation	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://rdfdata.eionet.europa.eu/airquality/ontology/costs	19363	\N	69	costs	costs	f	19363	\N	\N	f	f	127	240	\N	t	f	\N	\N	\N	t	f	f
237	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaCIDOtherDirective	1158	\N	102	rcaCIDOtherDirective	rcaCIDOtherDirective	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://rdfdata.eionet.europa.eu/airquality/ontology/finalImplementationCosts	291	\N	69	finalImplementationCosts	finalImplementationCosts	f	0	\N	\N	f	f	240	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://spinrdf.org/spin#violationRoot	15841	\N	108	violationRoot	violationRoot	f	15841	\N	\N	f	f	117	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://rdfdata.eionet.europa.eu/inspire-m/ontology/view	125	\N	101	view	view	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://www.openlinksw.com/schemas/virtrdf#qmfLanguageTmpl	4	\N	17	qmfLanguageTmpl	qmfLanguageTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#referenceyear	506	\N	138	referenceyear	referenceyear	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv#UniqueRailId	13546	\N	139	UniqueRailId	UniqueRailId	f	0	\N	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpGroundWaterReferenceDate	6601	\N	102	dcpGroundWaterReferenceDate	dcpGroundWaterReferenceDate	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv#UniqueRoadIdForCalculation	411027	\N	140	UniqueRoadIdForCalculation	UniqueRoadIdForCalculation	f	0	\N	\N	f	f	156	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv1_DS	1	\N	101	MDv1_DS	MDv1_DS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://reference.eionet.europa.eu/aq/ontology/datacoveragePct	935728	\N	81	datacoveragePct	datacoveragePct	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpReceivingWaterReferenceDate	4324	\N	102	dcpReceivingWaterReferenceDate	dcpReceivingWaterReferenceDate	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://rdfdata.eionet.europa.eu/airquality/ontology/officialJournalIdentification	234	\N	69	officialJournalIdentification	officialJournalIdentification	f	0	\N	\N	f	f	115	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://rdfdata.eionet.europa.eu/airquality/ontology/CompetentAuthorities	1	\N	69	CompetentAuthorities	CompetentAuthorities	f	1	\N	\N	f	f	254	262	\N	t	f	\N	\N	\N	t	f	f
252	http://rdfdata.eionet.europa.eu/inspire-m/ontology/actualArea	208	\N	101	actualArea	actualArea	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Data_source	5149	\N	128	Data_source	Data_source	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://rdfdata.eionet.europa.eu/airquality/ontology/author	3077	\N	69	author	author	f	0	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
255	http://rdfdata.eionet.europa.eu/wise/ontology/Permanent_Pasture	589	\N	86	Permanent_Pasture	Permanent_Pasture	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://rdfdata.eionet.europa.eu/airquality/ontology/description	1048091	\N	69	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://rdfdata.eionet.europa.eu/airquality/ontology/localId	6430136	\N	69	localId	localId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://rdfdata.eionet.europa.eu/airquality/ontology/dateType	437249	\N	69	dateType	dateType	f	0	\N	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://rdfdata.eionet.europa.eu/ramon/ontology/enddate	644	\N	91	enddate	enddate	f	0	\N	\N	f	f	212	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#name	456	\N	129	name	name	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
261	http://rdfdata.eionet.europa.eu/eea/ontology/isoCode	202	\N	88	isoCode	isoCode	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://rdfdata.eionet.europa.eu/eea/ontology/areaPercent	84	\N	88	areaPercent	areaPercent	f	0	\N	\N	f	f	136	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://rdfdata.eionet.europa.eu/airquality/ontology/heatingEmissions	407647	\N	69	heatingEmissions	heatingEmissions	f	0	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingDBOther	419	\N	69	reportingDBOther	reportingDBOther	f	0	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://reference.eionet.europa.eu/aq/ontology/caAdminUnit	1593	\N	81	caAdminUnit	caAdminUnit	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterBodyName	5299	\N	95	waterBodyName	waterBodyName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://rdfdata.eionet.europa.eu/airquality/ontology/comment	152593	\N	69	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
489	http://rdfdata.eionet.europa.eu/wise/ontology/ASSOC_WB	103007	\N	86	ASSOC_WB	ASSOC_WB	f	103007	\N	\N	f	f	\N	241	\N	t	f	\N	\N	\N	t	f	f
268	http://eunis.eea.europa.eu/rdf/schema.rdf#totalNumber	405	\N	107	totalNumber	totalNumber	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://www.w3.org/2004/02/skos/core#editorialNote	7185	\N	4	editorialNote	editorialNote	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://rdfdata.eionet.europa.eu/ramon/ontology/sectionAndCode	996	\N	91	sectionAndCode	sectionAndCode	f	0	\N	\N	f	f	259	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterBodyID	7596	\N	95	waterBodyID	waterBodyID	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://rdfdata.eionet.europa.eu/waterbase/ontology/seaAreaName	4061	\N	95	seaAreaName	seaAreaName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://reference.eionet.europa.eu/aq/ontology/adjustmentType	348	\N	81	adjustmentType	adjustmentType	f	348	\N	\N	f	f	129	8	\N	t	f	\N	\N	\N	t	f	f
274	http://rdfdata.eionet.europa.eu/article17/ontology/memberstate	30344	\N	83	memberstate	memberstate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://rdfdata.eionet.europa.eu/msfd/ontology/membership	265	\N	85	membership	membership	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://www.openlinksw.com/schemas/virtrdf#qmvColumnsFormKey	8	\N	17	qmvColumnsFormKey	qmvColumnsFormKey	f	0	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucAggName	36532	\N	102	aucAggName	aucAggName	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://rdfdata.eionet.europa.eu/msfd/ontology/coordination	9	\N	85	coordination	coordination	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://www.w3.org/2004/02/skos/core#altfLabel	1	\N	4	altfLabel	altfLabel	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/uniqueroadid	45913	\N	87	uniqueroadid	uniqueroadid	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODDischargeMeasured	2519	\N	102	uwwBODDischargeMeasured	uwwBODDischargeMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://rdfdata.eionet.europa.eu/airquality/ontology/involvedIn	105675	\N	69	involvedIn	involvedIn	f	105675	\N	\N	f	f	178	8	\N	t	f	\N	\N	\N	t	f	f
283	http://rdfs.org/ns/void#uriPattern	1	\N	16	uriPattern	uriPattern	f	0	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://rdfdata.eionet.europa.eu/airquality/ontology/zone	1289578	\N	69	zone	zone	f	1289578	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
285	http://reference.eionet.europa.eu/aq/ontology/operationalActivityEnd	28634	\N	81	operationalActivityEnd	operationalActivityEnd	f	0	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://rdfdata.eionet.europa.eu/waterbase/ontology/impactStation	2744	\N	95	impactStation	impactStation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaName	5548	\N	102	rcaName	rcaName	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/2007/05/powder-s#describedby	24	\N	141	describedby	describedby	f	24	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://rdfdata.eionet.europa.eu/airquality/ontology/infrastructureServices	4	\N	69	infrastructureServices	infrastructureServices	f	0	\N	\N	f	f	272	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv#ctrycd	5923	\N	142	ctrycd	ctrycd	f	0	\N	\N	f	f	218	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#Size	506	\N	138	Size	Size	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://purl.org/dc/terms/modified	7649	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://rdfdata.eionet.europa.eu/eea/ontology/inCountry	84	\N	88	inCountry	inCountry	f	84	\N	\N	f	f	136	38	\N	t	f	\N	\N	\N	t	f	f
294	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaANitro	5548	\N	102	rcaANitro	rcaANitro	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://rdfdata.eionet.europa.eu/article17/ontology/transboundary_assessment	670	\N	83	transboundary_assessment	transboundary_assessment	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://rdfdata.eionet.europa.eu/ramon/ontology/definition	30	\N	91	definition	definition	f	0	\N	\N	f	f	259	\N	\N	t	f	\N	\N	\N	t	f	f
297	http://reference.eionet.europa.eu/aq/ontology/environmentalDomain	1554	\N	81	environmentalDomain	environmentalDomain	f	1554	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://rdfdata.eionet.europa.eu/article17/generalreport/total_area	104	\N	118	total_area	total_area	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#ctryname	92	\N	143	ctryname	ctryname	f	0	\N	\N	f	f	268	\N	\N	t	f	\N	\N	\N	t	f	f
300	http://reference.eionet.europa.eu/aq/ontology/distanceJunction	3026	\N	81	distanceJunction	distanceJunction	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
301	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwTSSPerf	13957	\N	102	uwwTSSPerf	uwwTSSPerf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_magnitude	9024	\N	83	[Range trend magnitude in km2 (range_trend_magnitude)]	range_trend_magnitude	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://www.openlinksw.com/schemas/virtrdf#qmvftConds	2	\N	17	qmvftConds	qmvftConds	f	2	\N	\N	f	f	31	200	\N	t	f	\N	\N	\N	t	f	f
303	http://rdfdata.eionet.europa.eu/airquality/ontology/altitude	266220	\N	69	altitude	altitude	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
304	http://dd.eionet.europa.eu/tables/8286/rdf#Year_BW	33849	\N	132	Year_BW	Year_BW	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
305	http://rdfdata.eionet.europa.eu/airquality/ontology/relevantEmissions	1854277	\N	69	relevantEmissions	relevantEmissions	f	1854277	\N	\N	f	f	178	169	\N	t	f	\N	\N	\N	t	f	f
306	http://rdfdata.eionet.europa.eu/wise/ontology/country	202	\N	86	country	country	f	202	\N	\N	f	f	133	38	\N	t	f	\N	\N	\N	t	f	f
307	http://rdfdata.eionet.europa.eu/wise/ontology/STANDARDS	5183	\N	86	STANDARDS	STANDARDS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrLanguage	1	\N	17	qmfValRange-rvrLanguage	qmfValRange-rvrLanguage	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://purl.org/linked-data/sdmx/2009/attribute#unitMeasure	111996	\N	77	unitMeasure	unitMeasure	f	111996	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://www.w3.org/2004/02/skos/core#prefLabel	498217	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
312	http://rdfdata.eionet.europa.eu/wise/ontology/ReasonsForFailure	7954	\N	86	ReasonsForFailure	ReasonsForFailure	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
313	http://rdfdata.eionet.europa.eu/airquality/ontology/heatingEmissionsUOM	400307	\N	69	heatingEmissionsUOM	heatingEmissionsUOM	f	400199	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://reference.eionet.europa.eu/aq/ontology/temporalResolutionUnit	3219	\N	81	temporalResolutionUnit	temporalResolutionUnit	f	3219	\N	\N	f	f	14	8	\N	t	f	\N	\N	\N	t	f	f
315	http://rdfdata.eionet.europa.eu/ramon/ontology/edition	5158	\N	91	edition	edition	f	0	\N	\N	f	f	212	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://rdfdata.eionet.europa.eu/article17/ontology/backgroundColor	8	\N	83	backgroundColor	backgroundColor	f	0	\N	\N	f	f	266	\N	\N	t	f	\N	\N	\N	t	f	f
317	http://reference.eionet.europa.eu/aq/ontology/resultNature	1345	\N	81	resultNature	resultNature	f	1345	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://rdfdata.eionet.europa.eu/airquality/ontology/numUnits	3879164	\N	69	numUnits	numUnits	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://rdfdata.eionet.europa.eu/airquality/ontology/demonstrationReport	459818	\N	69	demonstrationReport	demonstrationReport	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
320	http://www.w3.org/2003/01/geo/wgs84_pos#long	1989170	\N	25	long	long	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://rod.eionet.europa.eu/schema.rdf#localityType	69	\N	84	localityType	localityType	f	0	\N	\N	f	f	154	\N	\N	t	f	\N	\N	\N	t	f	f
322	http://dd.eionet.europa.eu/schema.rdf#hasSchema	296	\N	109	hasSchema	hasSchema	f	296	\N	\N	f	f	132	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://rdfdata.eionet.europa.eu/airquality/ontology/plannedImplementation	25693	\N	69	plannedImplementation	plannedImplementation	f	25693	\N	\N	f	f	127	167	\N	t	f	\N	\N	\N	t	f	f
324	http://rdfdata.eionet.europa.eu/airquality/ontology/kerbDistance	716968	\N	69	kerbDistance	kerbDistance	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
325	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi2	1	\N	101	DSi2	DSi2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
326	http://rdfdata.eionet.europa.eu/airquality/ontology/fromWithinMS	1512	\N	69	fromWithinMS	fromWithinMS	f	1512	\N	\N	f	f	221	52	\N	t	f	\N	\N	\N	t	f	f
327	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi1	1	\N	101	DSi1	DSi1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
328	http://rdfdata.eionet.europa.eu/article17/generalreport/marine_area	104	\N	118	marine_area	marine_area	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWaterbodyID	32126	\N	102	dcpWaterbodyID	dcpWaterbodyID	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
330	http://rdfdata.eionet.europa.eu/article17/ontology/alternative_speciesname	1259	\N	83	alternative_speciesname	alternative_speciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
331	http://reference.eionet.europa.eu/aq/ontology/zone	309839	\N	81	zone	zone	f	309839	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
332	http://rdfdata.eionet.europa.eu/wise/ontology/SUB_PROGRAMME	2403	\N	86	SUB_PROGRAMME	SUB_PROGRAMME	f	2403	\N	\N	f	f	150	76	\N	t	f	\N	\N	\N	t	f	f
333	http://rdfdata.eionet.europa.eu/inspire-m/ontology/discoveryAccessibility	2	\N	101	discoveryAccessibility	discoveryAccessibility	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
334	http://www.w3.org/ns/prov#wasDerivedFrom	2	\N	26	wasDerivedFrom	wasDerivedFrom	f	2	\N	\N	f	f	201	\N	\N	t	f	\N	\N	\N	t	f	f
335	http://cr.eionet.europa.eu/ontologies/contreg.rdf#user	2	\N	82	user	user	f	2	\N	\N	f	f	248	\N	\N	t	f	\N	\N	\N	t	f	f
336	http://reference.eionet.europa.eu/aq/ontology/kerbDistanceUOM	28802	\N	81	kerbDistanceUOM	kerbDistanceUOM	f	28802	\N	\N	f	f	202	8	\N	t	f	\N	\N	\N	t	f	f
337	http://reference.eionet.europa.eu/aq/ontology/observingTimeEnd	233226	\N	81	observingTimeEnd	observingTimeEnd	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
338	http://rdfdata.eionet.europa.eu/waterbase/ontology/riverName	9173	\N	95	riverName	riverName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
339	http://rdfdata.eionet.europa.eu/article17/generalreport/community-importance	52	\N	118	community-importance	community-importance	f	52	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
340	http://rdfdata.eionet.europa.eu/wise/ontology/Reference_Year	2280	\N	86	Reference_Year	Reference_Year	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
341	http://reference.eionet.europa.eu/aq/ontology/stationUsed	1468087	\N	81	stationUsed	stationUsed	f	1468087	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://rdfdata.eionet.europa.eu/article17/ontology/distribution_method	9711	\N	83	distribution_method	distribution_method	f	9711	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
343	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggCode	35097	\N	102	aggCode	aggCode	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
344	http://rdfdata.eionet.europa.eu/airquality/ontology/samplingMethod	1423998	\N	69	samplingMethod	samplingMethod	f	1423976	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
345	http://rdfdata.eionet.europa.eu/airquality/ontology/endPosition	2170882	\N	69	endPosition	endPosition	f	0	\N	\N	f	f	177	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://rdfdata.eionet.europa.eu/airquality/ontology/protectionTarget	2033713	\N	69	protectionTarget	protectionTarget	f	2033713	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1494	http://purl.org/vocab/vann/preferredNamespacePrefix	1	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
347	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_range_trend	3012	\N	83	conclusion_range_trend	conclusion_range_trend	f	3012	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
348	http://rod.eionet.europa.eu/schema.rdf#nextdeadline2	420	\N	84	nextdeadline2	nextdeadline2	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://rdfdata.eionet.europa.eu/article17/ontology/spa_population_method	137	\N	83	spa_population_method	spa_population_method	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://rdfdata.eionet.europa.eu/airquality/ontology/referenceYear	23254	\N	69	referenceYear	referenceYear	f	23254	\N	\N	f	f	\N	59	\N	t	f	\N	\N	\N	t	f	f
351	http://reference.eionet.europa.eu/aq/ontology/inspireVersion	537059	\N	81	inspireVersion	inspireVersion	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
352	http://rdfdata.eionet.europa.eu/inspire-m/ontology/relevantArea	208	\N	101	relevantArea	relevantArea	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
353	http://rdfdata.eionet.europa.eu/airquality/ontology/classificationReport	387177	\N	69	classificationReport	classificationReport	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
355	http://rdfdata.eionet.europa.eu/wise/ontology/IND_SUPPLY	19505	\N	86	IND_SUPPLY	IND_SUPPLY	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://rdfdata.eionet.europa.eu/wise/ontology/SAMPLING_METHOD	6065	\N	86	SAMPLING_METHOD	SAMPLING_METHOD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
357	http://rdfdata.eionet.europa.eu/inspire-m/ontology/nnConformity	37	\N	101	nnConformity	nnConformity	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
358	http://purl.org/dc/terms/alternative	215	\N	5	alternative	alternative	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
359	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conFax	19	\N	102	conFax	conFax	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conInstitution	58	\N	102	conInstitution	conInstitution	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://rdfdata.eionet.europa.eu/uwwtd/ontology/bigCity	968	\N	102	bigCity	bigCity	f	0	\N	\N	f	f	152	\N	\N	t	f	\N	\N	\N	t	f	f
362	http://www.openlinksw.com/schemas/virtrdf#qmfIsnumericOfShortTmpl	19	\N	17	qmfIsnumericOfShortTmpl	qmfIsnumericOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
363	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv#UniqueRailIdForCalculation	19068	\N	144	UniqueRailIdForCalculation	UniqueRailIdForCalculation	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaPlantsCapacity	327	\N	102	rcaPlantsCapacity	rcaPlantsCapacity	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
365	http://reference.eionet.europa.eu/aq/ontology/samplingMethod	7	\N	81	samplingMethod	samplingMethod	f	7	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLongWhenRef	4	\N	17	qmfIsSubformatOfLongWhenRef	qmfIsSubformatOfLongWhenRef	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
367	http://rdfdata.eionet.europa.eu/airquality/ontology/predecessor	7980	\N	69	predecessor	predecessor	f	7980	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://rdfdata.eionet.europa.eu/ippc/ontology/name	197	\N	116	name	name	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://rdfdata.eionet.europa.eu/airquality/ontology/otherMeasurementMethod	11593	\N	69	otherMeasurementMethod	otherMeasurementMethod	f	0	\N	\N	f	f	243	\N	\N	t	f	\N	\N	\N	t	f	f
370	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNIncomingMeasured	2109	\N	102	uwwNIncomingMeasured	uwwNIncomingMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
371	http://www.geonames.org/ontology#shortName	46	\N	70	shortName	shortName	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
372	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_reasons_for_change_b	10759	\N	83	habitat_reasons_for_change_b	habitat_reasons_for_change_b	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://rdfdata.eionet.europa.eu/article17/generalreportreintro_alternative_speciesname	178	\N	100	generalreportreintro_alternative_speciesname	generalreportreintro_alternative_speciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
374	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_reasons_for_change_a	10759	\N	83	habitat_reasons_for_change_a	habitat_reasons_for_change_a	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
375	http://rdfdata.eionet.europa.eu/article17/generalreporttranspose_directive	66	\N	100	generalreporttranspose_directive	generalreporttranspose_directive	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
376	http://www.openlinksw.com/schemas/virtrdf#qmvftAlias	2	\N	17	qmvftAlias	qmvftAlias	f	0	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
377	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslWWReuseOther	45	\N	102	mslWWReuseOther	mslWWReuseOther	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_reasons_for_change_c	10759	\N	83	habitat_reasons_for_change_c	habitat_reasons_for_change_c	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://www.snee.com/ns/eppay-range	46	\N	133	eppay-range	eppay-range	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
380	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPeriodOver	35097	\N	102	aggPeriodOver	aggPeriodOver	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWaterBodyType	36450	\N	102	dcpWaterBodyType	dcpWaterBodyType	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
382	http://rdfdata.eionet.europa.eu/article17/generalreportReintroductionOfSpecies	178	\N	100	generalreportReintroductionOfSpecies	generalreportReintroductionOfSpecies	f	178	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
383	http://rdfdata.eionet.europa.eu/wise/ontology/level	58	\N	86	level	level	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
384	http://rdfdata.eionet.europa.eu/wise/ontology/areaKM	202	\N	86	areaKM	areaKM	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv#CountryCode	182542	\N	145	CountryCode	CountryCode	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
386	http://dd.eionet.europa.eu/schema.rdf#usesVocabulary	2730	\N	109	usesVocabulary	usesVocabulary	f	2730	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://rdfdata.eionet.europa.eu/airquality/ontology/measuresApplied	76664	\N	69	measuresApplied	measuresApplied	f	76664	\N	\N	f	f	143	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://eunis.eea.europa.eu/rdf/schema.rdf#nationalLaw	570	\N	107	nationalLaw	nationalLaw	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
389	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPressureTest	27509	\N	102	aggPressureTest	aggPressureTest	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceArea	34219	\N	69	exceedanceArea	exceedanceArea	f	34219	\N	\N	f	f	196	27	\N	t	f	\N	\N	\N	t	f	f
391	http://www.openlinksw.com/schemas/virtrdf#qmfIidOfShortTmpl	57	\N	17	qmfIidOfShortTmpl	qmfIidOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODDischargeMeasured	2512	\N	102	uwwCODDischargeMeasured	uwwCODDischargeMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
393	http://reference.eionet.europa.eu/aq/ontology/assessmentThreshold	264867	\N	81	assessmentThreshold	assessmentThreshold	f	264867	\N	\N	f	f	207	113	\N	t	f	\N	\N	\N	t	f	f
394	http://www.openlinksw.com/schemas/virtrdf#qmfTypemaxTmpl	39	\N	17	qmfTypemaxTmpl	qmfTypemaxTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://dd.eionet.europa.eu/property/hasObjectiveType	192	\N	130	hasObjectiveType	hasObjectiveType	f	192	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
396	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODDischargeCalculated	4517	\N	102	uwwCODDischargeCalculated	uwwCODDischargeCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
397	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
398	http://cr.eionet.europa.eu/ontologies/contreg.rdf#allowSubObjectType	236	\N	82	allowSubObjectType	allowSubObjectType	f	236	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
399	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggExplanationOther	753	\N	102	aggExplanationOther	aggExplanationOther	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://rod.eionet.europa.eu/schema.rdf#formalReporter	16534	\N	84	formalReporter	formalReporter	f	16534	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://rdfdata.eionet.europa.eu/inspire-m/ontology/URL	37	\N	101	URL	URL	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
402	http://rdfdata.eionet.europa.eu/article17/generalreportcommission_opinion	184	\N	100	generalreportcommission_opinion	generalreportcommission_opinion	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://rdfdata.eionet.europa.eu/uwwtd/ontology/repCode	52	\N	102	repCode	repCode	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://purl.org/linked-data/api/vocab#extendedMetadataVersion	1	\N	98	extendedMetadataVersion	extendedMetadataVersion	f	1	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
406	http://rdfdata.eionet.europa.eu/airquality/ontology/referenceAQPlan	1522	\N	69	referenceAQPlan	referenceAQPlan	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
407	http://rdfdata.eionet.europa.eu/wise/ontology/QUALITY_ELEMENT	12808	\N	86	QUALITY_ELEMENT	QUALITY_ELEMENT	f	12808	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv12	1	\N	101	MDv12	MDv12	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv13	1	\N	101	MDv13	MDv13	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
410	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfNiceSqlvalTmpl	6	\N	17	qmfShortOfNiceSqlvalTmpl	qmfShortOfNiceSqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv11	1	\N	101	MDv11	MDv11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
412	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODDischargeCalculated	4532	\N	102	uwwBODDischargeCalculated	uwwBODDischargeCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rptFormRA	52	\N	102	rptFormRA	rptFormRA	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
415	http://rdfdata.eionet.europa.eu/eea/ontology/inBioGeoRegion	84	\N	88	inBioGeoRegion	inBioGeoRegion	f	84	\N	\N	f	f	136	91	\N	t	f	\N	\N	\N	t	f	f
416	http://rdfdata.eionet.europa.eu/airquality/ontology/industrialEmissionsUOM	477026	\N	69	industrialEmissionsUOM	industrialEmissionsUOM	f	477026	\N	\N	f	f	169	8	\N	t	f	\N	\N	\N	t	f	f
417	http://rdfdata.eionet.europa.eu/airquality/ontology/otherAnalyticalTechnique	5400	\N	69	otherAnalyticalTechnique	otherAnalyticalTechnique	f	0	\N	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
418	http://rdfdata.eionet.europa.eu/article17/generalreportreintro_common_speciesname	178	\N	100	generalreportreintro_common_speciesname	generalreportreintro_common_speciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://reference.eionet.europa.eu/aq/ontology/measurementRegime	74141	\N	81	measurementRegime	measurementRegime	f	74141	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
420	http://rdfs.org/ns/void#subset	45	\N	16	subset	subset	f	45	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
421	http://rod.eionet.europa.eu/schema.rdf#requester	671	\N	84	requester	requester	f	671	\N	\N	f	f	15	214	\N	t	f	\N	\N	\N	t	f	f
422	http://rdfdata.eionet.europa.eu/airquality/ontology/regionalBackground	1512	\N	69	regionalBackground	regionalBackground	f	1512	\N	\N	f	f	124	221	\N	t	f	\N	\N	\N	t	f	f
423	http://dd.eionet.europa.eu/tables/8286/rdf#SpecGeoCon	33849	\N	132	SpecGeoCon	SpecGeoCon	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
424	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv14	1	\N	101	MDv14	MDv14	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
425	http://cr.eionet.europa.eu/ontologies/contreg.rdf#hasFile	222	\N	82	hasFile	hasFile	f	222	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
426	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv23	1	\N	101	MDv23	MDv23	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
427	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv24	1	\N	101	MDv24	MDv24	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
428	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv21	1	\N	101	MDv21	MDv21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1495	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_magnitude_min	2248	\N	83	population_trend_magnitude_min	population_trend_magnitude_min	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
429	http://rdfdata.eionet.europa.eu/wise/ontology/HydrogeologicalCharacteristics	24222	\N	86	HydrogeologicalCharacteristics	HydrogeologicalCharacteristics	f	24222	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
430	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv22	1	\N	101	MDv22	MDv22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
462	http://reference.eionet.europa.eu/aq/ontology/station_lat	935516	\N	81	[Latitude of measurement station (station_lat)]	station_lat	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
431	http://rdfdata.eionet.europa.eu/airquality/ontology/networkType	11818	\N	69	networkType	networkType	f	11818	\N	\N	f	f	82	\N	\N	t	f	\N	\N	\N	t	f	f
433	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv#CountryCode	19068	\N	144	CountryCode	CountryCode	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
434	http://purl.org/dc/terms/rights	3	\N	5	rights	rights	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
435	http://rdfdata.eionet.europa.eu/uwwtd/ontology/bigCountryCode	968	\N	102	bigCountryCode	bigCountryCode	f	0	\N	\N	f	f	152	\N	\N	t	f	\N	\N	\N	t	f	f
436	http://dd.eionet.europa.eu/tables/8286/rdf#WBID	27297	\N	132	WBID	WBID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
437	http://rdfdata.eionet.europa.eu/wise/ontology/Artificial_Recharge_Purpose	45	\N	86	Artificial_Recharge_Purpose	Artificial_Recharge_Purpose	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
438	http://purl.org/dc/terms/source	2409467	\N	5	source	source	f	2408850	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
439	http://rdfdata.eionet.europa.eu/ippc/ontology/permitLink	90	\N	116	permitLink	permitLink	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
440	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggGenerated	35097	\N	102	aggGenerated	aggGenerated	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
441	http://rdfdata.eionet.europa.eu/airquality/ontology/changeAEIStations	86681	\N	69	changeAEIStations	changeAEIStations	f	0	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
442	http://rdfdata.eionet.europa.eu/wise/ontology/forStation	40827	\N	86	forStation	forStation	f	40827	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
443	http://rdfdata.eionet.europa.eu/msfd/ontology/city	283	\N	85	city	city	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
444	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indCodePlant	258	\N	102	indCodePlant	indCodePlant	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
445	http://rdfdata.eionet.europa.eu/airquality/ontology/areaClassification	329755	\N	69	areaClassification	areaClassification	f	329755	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
446	http://rdfdata.eionet.europa.eu/airquality/ontology/specificationOfHours	503	\N	69	specificationOfHours	specificationOfHours	f	503	\N	\N	f	f	114	\N	\N	t	f	\N	\N	\N	t	f	f
447	http://rdfdata.eionet.europa.eu/airquality/ontology/level	19518	\N	69	level	level	f	19518	\N	\N	f	f	151	8	\N	t	f	\N	\N	\N	t	f	f
448	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPercWithoutTreatment	35097	\N	102	aggPercWithoutTreatment	aggPercWithoutTreatment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
449	http://www.openlinksw.com/schemas/virtrdf#qmfMapsOnlyNullToNull	40	\N	17	qmfMapsOnlyNullToNull	qmfMapsOnlyNullToNull	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
450	http://rdfdata.eionet.europa.eu/waterbase/ontology/remarks	967	\N	95	remarks	remarks	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
451	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceExposure	64126	\N	69	exceedanceExposure	exceedanceExposure	f	64126	\N	\N	f	f	196	272	\N	t	f	\N	\N	\N	t	f	f
452	http://reference.eionet.europa.eu/aq/ontology/pollutantCode	509915	\N	81	pollutantCode	pollutantCode	f	509915	\N	\N	f	f	227	8	\N	t	f	\N	\N	\N	t	f	f
453	http://rdfdata.eionet.europa.eu/airquality/ontology/procedure	2851980	\N	69	procedure	procedure	f	2851980	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
454	http://rdfdata.eionet.europa.eu/airquality/ontology/SamplingEquipment	904	\N	69	SamplingEquipment	SamplingEquipment	f	904	\N	\N	f	f	77	8	\N	t	f	\N	\N	\N	t	f	f
455	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_enhance	50566	\N	83	broad_evaluation_enhance	broad_evaluation_enhance	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
456	http://rdfdata.eionet.europa.eu/article17/generalreportinfo_on_network	44	\N	100	generalreportinfo_on_network	generalreportinfo_on_network	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
457	http://rdfdata.eionet.europa.eu/wise/ontology/ASSOC_DOC_REF	4258	\N	86	ASSOC_DOC_REF	ASSOC_DOC_REF	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
458	http://rdfdata.eionet.europa.eu/inspire-m/ontology/email	1	\N	101	email	email	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
459	http://reference.eionet.europa.eu/aq/ontology/numberExceedancesFinal	44009	\N	81	numberExceedancesFinal	numberExceedancesFinal	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
460	http://rdfdata.eionet.europa.eu/waterbase/ontology/lengthFromSource	1562	\N	95	lengthFromSource	lengthFromSource	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
461	http://www.openlinksw.com/schemas/virtrdf#qmfIslitOfShortTmpl	31	\N	17	qmfIslitOfShortTmpl	qmfIslitOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
463	http://rdfdata.eionet.europa.eu/eea/ontology/shortName	94	\N	88	shortName	shortName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
464	http://rdfdata.eionet.europa.eu/airquality/ontology/equivalenceDemonstration	1910990	\N	69	equivalenceDemonstration	equivalenceDemonstration	f	1910990	\N	\N	f	f	179	1	\N	t	f	\N	\N	\N	t	f	f
465	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggForecast	4438	\N	102	aggForecast	aggForecast	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
466	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumDiscServ	1	\N	101	NSv_NumDiscServ	NSv_NumDiscServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
467	http://rdfdata.eionet.europa.eu/airquality/ontology/aqdZoneType	30940	\N	69	aqdZoneType	aqdZoneType	f	30940	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
468	http://rdfdata.eionet.europa.eu/article17/ontology/pressures_method	14755	\N	83	pressures_method	pressures_method	f	14755	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
469	http://rdfdata.eionet.europa.eu/wise/ontology/Area	2103	\N	86	Area	Area	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
470	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPIncomingEstimated	520	\N	102	uwwPIncomingEstimated	uwwPIncomingEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1496	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi21	1	\N	101	NSi21	NSi21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
471	http://dd.eionet.europa.eu/property/currencyOfCountry	41	\N	130	currencyOfCountry	currencyOfCountry	f	41	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
472	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWFDSubUnitReferenceDate	632	\N	102	dcpWFDSubUnitReferenceDate	dcpWFDSubUnitReferenceDate	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
473	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv12_RelArea	1	\N	101	DSv12_RelArea	DSv12_RelArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
474	http://rdfdata.eionet.europa.eu/article17/ontology/population_additional_info	1583	\N	83	population_additional_info	population_additional_info	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
475	http://rdfdata.eionet.europa.eu/uwwtd/ontology/bigCityID	968	\N	102	bigCityID	bigCityID	f	0	\N	\N	f	f	152	\N	\N	t	f	\N	\N	\N	t	f	f
476	http://www.w3.org/2003/01/geo/wgs84_pos#alt	12	\N	25	alt	alt	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
477	http://rdfdata.eionet.europa.eu/airquality/ontology/pass	437121	\N	69	pass	pass	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
478	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	54	29	\N	t	f	\N	\N	\N	t	f	f
479	http://reference.eionet.europa.eu/aq/ontology/comment	23915	\N	81	comment	comment	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
480	http://rdfs.org/ns/void#triples	1	\N	16	triples	triples	f	0	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
481	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	54	29	\N	t	f	\N	\N	\N	t	f	f
482	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	54	29	\N	t	f	\N	\N	\N	t	f	f
483	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
484	http://www.openlinksw.com/schemas/virtrdf#qmfLanguageOfShortTmpl	31	\N	17	qmfLanguageOfShortTmpl	qmfLanguageOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
485	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	54	29	\N	t	f	\N	\N	\N	t	f	f
486	http://rdfdata.eionet.europa.eu/airquality/ontology/natlStationCode	265755	\N	69	natlStationCode	natlStationCode	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
487	http://rdfdata.eionet.europa.eu/wise/ontology/ProtAreaExemptions	1320	\N	86	ProtAreaExemptions	ProtAreaExemptions	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
488	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#ctrycd	456	\N	146	ctrycd	ctrycd	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
490	http://rdfdata.eionet.europa.eu/airquality/ontology/total	4536	\N	69	total	total	f	4536	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
491	http://rdfdata.eionet.europa.eu/wise/ontology/UpwardTrendComment	2239	\N	86	UpwardTrendComment	UpwardTrendComment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
492	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi1	1	\N	101	MDi1	MDi1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
493	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDi2	1	\N	101	MDi2	MDi2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
494	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conEmail	54	\N	102	conEmail	conEmail	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
495	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_atlas_reference	15	\N	100	generalreportnational_bird_atlas_reference	generalreportnational_bird_atlas_reference	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
496	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingPeriod	17950	\N	69	reportingPeriod	reportingPeriod	f	17950	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
497	http://telegraphis.net/ontology/geography/geography#capital	241	\N	117	capital	capital	f	241	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
498	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#country	456	\N	146	country	country	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
499	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCode	36012	\N	102	uwwCode	uwwCode	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
500	http://reference.eionet.europa.eu/aq/ontology/usedAQD	77608	\N	81	usedAQD	usedAQD	f	0	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
502	http://creativecommons.org/ns#attributionURL	170	\N	23	attributionURL	attributionURL	f	170	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
503	http://rdfdata.eionet.europa.eu/airquality/ontology/sourceApportionment	904	\N	69	sourceApportionment	sourceApportionment	f	904	\N	\N	f	f	126	\N	\N	t	f	\N	\N	\N	t	f	f
504	http://www.openlinksw.com/schemas/virtrdf#qmvftXmlIndex	3	\N	17	qmvftXmlIndex	qmvftXmlIndex	f	0	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
505	http://rdfdata.eionet.europa.eu/article17/ontology/population_methods	5861	\N	83	population_methods	population_methods	f	5861	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
506	http://rdfdata.eionet.europa.eu/wise/ontology/GroundWaterBodyStatus	1030	\N	86	GroundWaterBodyStatus	GroundWaterBodyStatus	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
507	http://rdfdata.eionet.europa.eu/wise/ontology/Internat_1	81	\N	86	Internat_1	Internat_1	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
508	http://rdfdata.eionet.europa.eu/airquality/ontology/other	4249	\N	69	other	other	f	4249	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
509	http://rdfdata.eionet.europa.eu/airquality/ontology/codeOfScenario	919	\N	69	codeOfScenario	codeOfScenario	f	0	\N	\N	f	f	126	\N	\N	t	f	\N	\N	\N	t	f	f
510	http://www.w3.org/1999/xhtml/vocab#next	1	\N	74	next	next	f	1	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
511	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPTotPerf	32761	\N	102	uwwPTotPerf	uwwPTotPerf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
512	http://rdfdata.eionet.europa.eu/airquality/ontology/distanceSource	607059	\N	69	distanceSource	distanceSource	f	0	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
513	http://psi.oasis-open.org/iso/639/#code-a2	171	\N	93	code-a2	code-a2	f	0	\N	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
514	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Length_M	123830	\N	147	Length_M	Length_M	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
515	http://rdfdata.eionet.europa.eu/airquality/ontology/adjustmentSource	2319	\N	69	adjustmentSource	adjustmentSource	f	2319	\N	\N	f	f	197	8	\N	t	f	\N	\N	\N	t	f	f
516	http://rdfdata.eionet.europa.eu/waterbase/ontology/qA_station_issues	129	\N	95	qA_station_issues	qA_station_issues	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
517	http://rdfdata.eionet.europa.eu/article17/ontology/type_administrative	50566	\N	83	type_administrative	type_administrative	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
518	http://rdfdata.eionet.europa.eu/wise/ontology/OPERAT	862	\N	86	OPERAT	OPERAT	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
519	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedance	225659	\N	69	exceedance	exceedance	f	0	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
520	http://rdfdata.eionet.europa.eu/waterbase/ontology/hMWB	3649	\N	95	hMWB	hMWB	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
521	http://www.w3.org/1999/02/22-rdf-syntax-ns#resouce	3	\N	1	resouce	resouce	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
522	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrRestrictions	172	\N	17	qmfValRange-rvrRestrictions	qmfValRange-rvrRestrictions	f	172	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
523	http://rdfdata.eionet.europa.eu/article17/generalreportcoherence_measures	51	\N	100	generalreportcoherence_measures	generalreportcoherence_measures	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
524	http://rdfdata.eionet.europa.eu/wise/ontology/OTHER_NETWORKS	7733	\N	86	OTHER_NETWORKS	OTHER_NETWORKS	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
525	http://rdfdata.eionet.europa.eu/article17/ontology/BirdPressureThreat	20022	\N	83	BirdPressureThreat	BirdPressureThreat	f	20022	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
526	http://rdfdata.eionet.europa.eu/airquality/ontology/pollutant	701111	\N	69	pollutant	pollutant	f	701111	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
527	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_quality_explanation	9869	\N	83	habitat_quality_explanation	habitat_quality_explanation	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
528	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_range	9841	\N	83	complementary_favourable_range	complementary_favourable_range	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
529	http://rdfdata.eionet.europa.eu/wise/ontology/ValueStatusProtectedArea	19227	\N	86	ValueStatusProtectedArea	ValueStatusProtectedArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
530	http://reference.eionet.europa.eu/aq/ontology/exceedanceAttainment	6719312	\N	81	exceedanceAttainment	exceedanceAttainment	f	6719312	\N	\N	f	f	112	\N	\N	t	f	\N	\N	\N	t	f	f
531	http://rdfdata.eionet.europa.eu/article17/generalreportproject_year	187	\N	100	generalreportproject_year	generalreportproject_year	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
532	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_population_max	4871	\N	83	natura2000_population_max	natura2000_population_max	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
533	http://rdfdata.eionet.europa.eu/airquality/ontology/belongsTo	2118770	\N	69	belongsTo	belongsTo	f	2119010	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
534	http://reference.eionet.europa.eu/aq/ontology/belongsTo	85193	\N	81	belongsTo	belongsTo	f	85193	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
535	http://www.openlinksw.com/schemas/virtrdf#qsDefaultMap	2	\N	17	qsDefaultMap	qsDefaultMap	f	2	\N	\N	f	f	171	30	\N	t	f	\N	\N	\N	t	f	f
536	http://rdfdata.eionet.europa.eu/airquality/ontology/estimatedImplementationCosts	3527	\N	69	estimatedImplementationCosts	estimatedImplementationCosts	f	0	\N	\N	f	f	240	\N	\N	t	f	\N	\N	\N	t	f	f
537	http://spinrdf.org/spin#violationPath	15061	\N	108	violationPath	violationPath	f	15061	\N	\N	f	f	117	\N	\N	t	f	\N	\N	\N	t	f	f
538	http://discomap.eea.europa.eu//#ServiceURL	224	\N	148	ServiceURL	ServiceURL	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
539	http://reference.eionet.europa.eu/aq/ontology/numericalExceedanceFinal	63744	\N	81	numericalExceedanceFinal	numericalExceedanceFinal	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
540	http://www.w3.org/2004/02/skos/core#notation	212382	\N	4	notation	notation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
541	http://rdfdata.eionet.europa.eu/airquality/ontology/catalogSymbol	238998	\N	69	catalogSymbol	catalogSymbol	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
542	http://rdfdata.eionet.europa.eu/wise/ontology/Depth_to_GW_Min	617	\N	86	Depth_to_GW_Min	Depth_to_GW_Min	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
543	http://rdfdata.eionet.europa.eu/eea/ontology/officialOf	58	\N	88	officialOf	officialOf	f	58	\N	\N	f	f	135	38	\N	t	f	\N	\N	\N	t	f	f
544	http://rdfs.org/ns/void#target	40	\N	16	target	target	f	40	\N	\N	f	f	149	\N	\N	t	f	\N	\N	\N	t	f	f
545	http://rdfdata.eionet.europa.eu/uwwtd/ontology/declarationFor	150873	\N	102	declarationFor	declarationFor	f	150873	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
546	http://dd.eionet.europa.eu/tables/8286/rdf#Longitude_BW	33948	\N	132	Longitude_BW	Longitude_BW	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
547	http://rdfdata.eionet.europa.eu/article17/generalreport/type-management	2458	\N	118	type-management	type-management	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
548	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfUriTmpl	31	\N	17	qmfShortOfUriTmpl	qmfShortOfUriTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
549	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaCRelevantDirective	1769	\N	102	rcaCRelevantDirective	rcaCRelevantDirective	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
550	http://rdfdata.eionet.europa.eu/article17/generalreportspa_marine_number	15	\N	100	generalreportspa_marine_number	generalreportspa_marine_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
551	http://rdfdata.eionet.europa.eu/wise/ontology/forProgramme	54994	\N	86	forProgramme	forProgramme	f	54994	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
552	http://rdfdata.eionet.europa.eu/airquality/ontology/inspireId	6428693	\N	69	inspireId	inspireId	f	6428599	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
553	http://rdfdata.eionet.europa.eu/article17/generalreportOtherPublications	15	\N	100	generalreportOtherPublications	generalreportOtherPublications	f	4	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
554	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_sources	1006	\N	83	range_trend_sources	range_trend_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
555	http://telegraphis.net/ontology/geography/geography#isoAlpha2	246	\N	117	isoAlpha2	isoAlpha2	f	0	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
556	http://rdfdata.eionet.europa.eu/waterbase/ontology/artificialWB	3997	\N	95	artificialWB	artificialWB	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
596	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_date	7159	\N	83	[Date of coverage determination (coverage_date)]	coverage_date	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
557	http://www.openlinksw.com/schemas/virtrdf#inheritFrom	99	\N	17	inheritFrom	inheritFrom	f	99	\N	\N	f	f	29	29	\N	t	f	\N	\N	\N	t	f	f
558	http://telegraphis.net/ontology/geography/geography#isoAlpha3	246	\N	117	isoAlpha3	isoAlpha3	f	0	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
559	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/name	165	\N	87	name	name	f	0	\N	\N	f	f	269	\N	\N	t	f	\N	\N	\N	t	f	f
560	http://dd.eionet.europa.eu/property/exceedanceThreshold	192	\N	130	exceedanceThreshold	exceedanceThreshold	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
561	http://rdfdata.eionet.europa.eu/wise/ontology/Forest_and_Woodland	594	\N	86	Forest_and_Woodland	Forest_and_Woodland	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
562	http://www.openlinksw.com/schemas/virtrdf#loadAs	8	\N	17	loadAs	loadAs	f	8	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
563	http://rod.eionet.europa.eu/schema.rdf#obligation	52161	\N	84	obligation	obligation	f	52161	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
565	http://www.openlinksw.com/schemas/virtrdf#qmvftTableName	2	\N	17	qmvftTableName	qmvftTableName	f	0	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
566	http://reference.eionet.europa.eu/aq/ontology/numericalExceedanceBase	95	\N	81	numericalExceedanceBase	numericalExceedanceBase	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
567	http://rdfdata.eionet.europa.eu/airquality/ontology/inletHeightUOM	1469992	\N	69	inletHeightUOM	inletHeightUOM	f	1469992	\N	\N	f	f	35	8	\N	t	f	\N	\N	\N	t	f	f
568	http://reference.eionet.europa.eu/aq/ontology/changeDocumentation	516	\N	81	changeDocumentation	changeDocumentation	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
569	http://rdfdata.eionet.europa.eu/waterbase/ontology/alkalinityAverage	2460	\N	95	alkalinityAverage	alkalinityAverage	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
570	http://rdfdata.eionet.europa.eu/airquality/ontology/reasonOther	1108	\N	69	reasonOther	reasonOther	f	0	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
571	http://reference.eionet.europa.eu/aq/ontology/pollutant	1215178	\N	81	pollutant	pollutant	f	1215178	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
572	http://rdfdata.eionet.europa.eu/wise/ontology/GWB_NAME	23279	\N	86	GWB_NAME	GWB_NAME	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
573	http://telegraphis.net/ontology/measurement/measurement#unit	246	\N	123	unit	unit	f	246	\N	\N	f	f	223	\N	\N	t	f	\N	\N	\N	t	f	f
574	http://purl.org/linked-data/sdmx/2009/dimension#sex	37642	\N	71	sex	sex	f	37642	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
575	http://reference.eionet.europa.eu/aq/ontology/numericalExceedanceAdjustment	94	\N	81	numericalExceedanceAdjustment	numericalExceedanceAdjustment	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
576	http://rdfdata.eionet.europa.eu/wise/ontology/DEPTH	33879	\N	86	DEPTH	DEPTH	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
577	http://rdfdata.eionet.europa.eu/wise/ontology/GoodQuantitativeStatusExemptionComment	771	\N	86	GoodQuantitativeStatusExemptionComment	GoodQuantitativeStatusExemptionComment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
578	http://reference.eionet.europa.eu/aq/ontology/aqdZoneType	1166	\N	81	aqdZoneType	aqdZoneType	f	1166	\N	\N	f	f	107	8	\N	t	f	\N	\N	\N	t	f	f
579	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumDownServ	1	\N	101	NSv_NumDownServ	NSv_NumDownServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
580	http://rdfdata.eionet.europa.eu/airquality/ontology/explanation	437249	\N	69	explanation	explanation	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
581	http://rdfdata.eionet.europa.eu/wise/ontology/LinkSurfaceWaterBodies	9613	\N	86	LinkSurfaceWaterBodies	LinkSurfaceWaterBodies	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
582	http://rdfdata.eionet.europa.eu/inspire-m/ontology/hasSpatialDataService	46	\N	101	hasSpatialDataService	hasSpatialDataService	f	46	\N	\N	f	f	\N	70	\N	t	f	\N	\N	\N	t	f	f
583	http://purl.org/dc/elements/1.1/subject	258	\N	6	subject	subject	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
584	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conStreet	49	\N	102	conStreet	conStreet	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
585	http://rod.eionet.europa.eu/schema.rdf#continuousReporting	671	\N	84	continuousReporting	continuousReporting	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
586	http://purl.org/dc/dcam/memberOf	36	\N	76	memberOf	memberOf	f	36	\N	\N	f	f	\N	110	\N	t	f	\N	\N	\N	t	f	f
587	http://rdfdata.eionet.europa.eu/wise/ontology/WFD_GW_body_code	717	\N	86	WFD_GW_body_code	WFD_GW_body_code	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
588	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODIncomingEstimated	520	\N	102	uwwBODIncomingEstimated	uwwBODIncomingEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
589	http://rdfdata.eionet.europa.eu/article17/generalreport/description	89	\N	118	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
590	http://rdfdata.eionet.europa.eu/inspire-m/ontology/organizationName	1	\N	101	organizationName	organizationName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
591	http://dd.eionet.europa.eu/tables/8286/rdf#ShortName	17901	\N	132	ShortName	ShortName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
592	http://www.openlinksw.com/schemas/virtrdf#qmf01uriOfShortTmpl	2	\N	17	qmf01uriOfShortTmpl	qmf01uriOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
593	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpSurfaceWaters	35667	\N	102	dcpSurfaceWaters	dcpSurfaceWaters	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
594	http://www.openlinksw.com/schemas/virtrdf#qmfDatatypeOfShortTmpl	31	\N	17	qmfDatatypeOfShortTmpl	qmfDatatypeOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
595	http://rdfdata.eionet.europa.eu/wise/ontology/Layered	18734	\N	86	Layered	Layered	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
597	http://dbpedia.org/ontology/conservationStatus	1657	\N	10	conservationStatus	conservationStatus	f	0	\N	\N	f	f	175	\N	\N	t	f	\N	\N	\N	t	f	f
598	http://rdfdata.eionet.europa.eu/eea/ontology/isMarine	35	\N	88	isMarine	isMarine	f	0	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
1497	http://rdfdata.eionet.europa.eu/article17/generalreportsac_marine_number	51	\N	100	generalreportsac_marine_number	generalreportsac_marine_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
599	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_method	4430	\N	83	coverage_trend_method	coverage_trend_method	f	4430	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
600	http://reference.eionet.europa.eu/aq/ontology/description	3372	\N	81	description	description	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
601	http://rdfdata.eionet.europa.eu/airquality/ontology/adjustmentType	190753	\N	69	adjustmentType	adjustmentType	f	190753	\N	\N	f	f	197	\N	\N	t	f	\N	\N	\N	t	f	f
602	http://dd.eionet.europa.eu/property/exceedanceThresholdExtra	192	\N	130	exceedanceThresholdExtra	exceedanceThresholdExtra	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
603	http://rdfdata.eionet.europa.eu/wise/ontology/Water_Abstractions_Purpose	745	\N	86	Water_Abstractions_Purpose	Water_Abstractions_Purpose	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
604	http://rdfdata.eionet.europa.eu/waterbase/ontology/altitude	6637	\N	95	altitude	altitude	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
605	http://rdfdata.eionet.europa.eu/inspire-m/ontology/language	1	\N	101	language	language	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
606	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwHistorie	1177	\N	102	uwwHistorie	uwwHistorie	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
607	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaParameterP	5220	\N	102	rcaParameterP	rcaParameterP	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
608	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaParameterN	5220	\N	102	rcaParameterN	rcaParameterN	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
609	http://rdfdata.eionet.europa.eu/eea/ontology/code	174	\N	88	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
610	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indBranch	257	\N	102	indBranch	indBranch	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
611	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpIrrigation	1471	\N	102	dcpIrrigation	dcpIrrigation	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
612	http://rdfdata.eionet.europa.eu/airquality/ontology/geometry	40315	\N	69	geometry	geometry	f	21846	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
613	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumTransfServ	1	\N	101	NSv_NumTransfServ	NSv_NumTransfServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
614	http://rdfdata.eionet.europa.eu/article17/generalreport/education	25	\N	118	education	education	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
615	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Reference_Year	123830	\N	147	Reference_Year	Reference_Year	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
616	http://rdfdata.eionet.europa.eu/article17/ontology/distribution_map	9856	\N	83	distribution_map	distribution_map	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
617	http://rdfdata.eionet.europa.eu/airquality/ontology/percentileExceedance	212	\N	69	percentileExceedance	percentileExceedance	f	0	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
618	http://rdfdata.eionet.europa.eu/article17/ontology/population_size_unit	6118	\N	83	population_size_unit	population_size_unit	f	5950	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
619	http://dd.eionet.europa.eu/property/speciesInstrument	4015	\N	130	speciesInstrument	speciesInstrument	f	2492	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
620	http://rdfdata.eionet.europa.eu/airquality/ontology/measurementMethod	2410933	\N	69	measurementMethod	measurementMethod	f	2410933	\N	\N	f	f	179	243	\N	t	f	\N	\N	\N	t	f	f
621	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_sources	2208	\N	83	population_trend_sources	population_trend_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
622	http://rdfdata.eionet.europa.eu/ramon/ontology/code	8840	\N	91	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
623	http://rdfdata.eionet.europa.eu/airquality/ontology/modelAssessmentMetadata	105952	\N	69	modelAssessmentMetadata	modelAssessmentMetadata	f	105952	\N	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
624	http://www.w3.org/2002/07/owl#inverseOf	20	\N	7	inverseOf	inverseOf	f	20	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
625	http://rdfdata.eionet.europa.eu/airquality/ontology/residentPopulation	30935	\N	69	residentPopulation	residentPopulation	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
626	http://rdfdata.eionet.europa.eu/article17/generalreportsites_total_number	51	\N	100	generalreportsites_total_number	generalreportsites_total_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
627	http://rdfdata.eionet.europa.eu/wise/ontology/DIST_CD	348	\N	86	DIST_CD	DIST_CD	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
628	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv#UniqueRoadId	223717	\N	149	UniqueRoadId	UniqueRoadId	f	0	\N	\N	f	f	160	\N	\N	t	f	\N	\N	\N	t	f	f
629	http://dd.eionet.europa.eu/property/relatedPollutant	1644	\N	130	relatedPollutant	relatedPollutant	f	1608	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
630	http://rdfdata.eionet.europa.eu/article17/ontology/forCountry	30344	\N	83	forCountry	forCountry	f	30344	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
631	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#seeAlso	5	\N	110	seeAlso	seeAlso	f	5	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
632	http://rdfdata.eionet.europa.eu/eea/ontology/booleanAsString	4	\N	88	booleanAsString	booleanAsString	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
633	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_quality	117	\N	83	population_trend_quality	population_trend_quality	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
634	http://rdfdata.eionet.europa.eu/airquality/ontology/heavy-dutyFraction	45279	\N	69	heavy-dutyFraction	heavy-dutyFraction	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
635	http://reference.eionet.europa.eu/aq/ontology/relevantEmissions	955581	\N	81	relevantEmissions	relevantEmissions	f	955581	\N	\N	f	f	\N	225	\N	t	f	\N	\N	\N	t	f	f
636	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_atlas_title	15	\N	100	generalreportnational_bird_atlas_title	generalreportnational_bird_atlas_title	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
637	http://telegraphis.net/ontology/geography/geography#isoShortName	492	\N	117	isoShortName	isoShortName	f	0	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
638	http://rdfdata.eionet.europa.eu/airquality/ontology/mobile	2122106	\N	69	mobile	mobile	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
639	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	80	236	\N	t	f	\N	\N	\N	t	f	f
640	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCollectingSystem	36012	\N	102	uwwCollectingSystem	uwwCollectingSystem	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
641	http://rdfdata.eionet.europa.eu/airquality/ontology/expectedExceedances	350	\N	69	expectedExceedances	expectedExceedances	f	0	\N	\N	f	f	143	\N	\N	t	f	\N	\N	\N	t	f	f
642	http://www.w3.org/2002/07/owl#unionOf	5	\N	7	unionOf	unionOf	f	5	\N	\N	f	f	201	\N	\N	t	f	\N	\N	\N	t	f	f
643	http://rdfdata.eionet.europa.eu/airquality/ontology/qaReport	1555990	\N	69	qaReport	qaReport	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
644	http://www.w3.org/2002/07/owl#versionInfo	15	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
645	http://rdfdata.eionet.europa.eu/wise/ontology/QuantitativeStatusValue	24222	\N	86	QuantitativeStatusValue	QuantitativeStatusValue	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
646	http://rdfdata.eionet.europa.eu/airquality/ontology/otherDates	13577	\N	69	otherDates	otherDates	f	0	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
647	http://dd.eionet.europa.eu/property/Area	45	\N	130	Area	Area	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
648	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/airportname	168	\N	87	airportname	airportname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
649	http://rdfdata.eionet.europa.eu/wise/ontology/partOf	10	\N	86	partOf	partOf	f	10	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
650	http://rdfdata.eionet.europa.eu/article17/generalreport/deterioration-measures	25	\N	118	deterioration-measures	deterioration-measures	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
651	http://rdfdata.eionet.europa.eu/article17/ontology/location_both	50566	\N	83	location_both	location_both	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
652	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggCapacity	27509	\N	102	aggCapacity	aggCapacity	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
653	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_sources	2381	\N	83	population_trend_long_sources	population_trend_long_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
654	http://rdfdata.eionet.europa.eu/article17/ontology/pollution_qualifier	4118	\N	83	pollution_qualifier	pollution_qualifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
655	http://rdfdata.eionet.europa.eu/wise/ontology/REASON	955	\N	86	REASON	REASON	f	0	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
656	http://rdfdata.eionet.europa.eu/article17/ontology/distribution_date	9281	\N	83	distribution_date	distribution_date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
657	http://rdfdata.eionet.europa.eu/airquality/ontology/duration	1925993	\N	69	duration	duration	f	1925993	\N	\N	f	f	179	2	\N	t	f	\N	\N	\N	t	f	f
658	http://rdfdata.eionet.europa.eu/airquality/ontology/responsibleParty	1859452	\N	69	responsibleParty	responsibleParty	f	1859452	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
659	http://rod.eionet.europa.eu/schema.rdf#clientAcronym	73	\N	84	clientAcronym	clientAcronym	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
660	http://rdfdata.eionet.europa.eu/wise/ontology/INTERNETWORKS	77	\N	86	INTERNETWORKS	INTERNETWORKS	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
661	http://rdfdata.eionet.europa.eu/airquality/ontology/publicationDate	4804	\N	69	publicationDate	publicationDate	f	4804	\N	\N	f	f	75	59	\N	t	f	\N	\N	\N	t	f	f
662	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_population_min	5168	\N	83	natura2000_population_min	natura2000_population_min	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
663	http://rdfdata.eionet.europa.eu/wise/ontology/Depth_to_GW_Max	588	\N	86	Depth_to_GW_Max	Depth_to_GW_Max	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
664	http://rdfs.org/ns/void#uriRegexPattern	5	\N	16	uriRegexPattern	uriRegexPattern	f	0	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
665	http://rdfdata.eionet.europa.eu/wise/ontology/EUSubUnitCode	1030	\N	86	EUSubUnitCode	EUSubUnitCode	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
666	http://rdfdata.eionet.europa.eu/airquality/ontology/altitudeUOM	262278	\N	69	altitudeUOM	altitudeUOM	f	262227	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
667	http://rdfdata.eionet.europa.eu/wise/ontology/SignificantTrendReversal	24222	\N	86	SignificantTrendReversal	SignificantTrendReversal	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
668	http://rdfdata.eionet.europa.eu/airquality/ontology/otherSamplingMethod	5262	\N	69	otherSamplingMethod	otherSamplingMethod	f	0	\N	\N	f	f	194	\N	\N	t	f	\N	\N	\N	t	f	f
669	http://rdfdata.eionet.europa.eu/airquality/ontology/organisationName	1961538	\N	69	organisationName	organisationName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
670	http://rdfdata.eionet.europa.eu/ramon/ontology/iSIC4Code	996	\N	91	iSIC4Code	iSIC4Code	f	0	\N	\N	f	f	259	\N	\N	t	f	\N	\N	\N	t	f	f
671	http://rdfdata.eionet.europa.eu/wise/ontology/PROGRAMME_CD	54994	\N	86	PROGRAMME_CD	PROGRAMME_CD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
672	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv#IcaoCode	225	\N	135	IcaoCode	IcaoCode	f	0	\N	\N	f	f	159	\N	\N	t	f	\N	\N	\N	t	f	f
673	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPercStringentTreatment	3723	\N	102	aggPercStringentTreatment	aggPercStringentTreatment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
674	http://purl.org/dc/terms/hasVersion	247	\N	5	hasVersion	hasVersion	f	247	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
675	http://rod.eionet.europa.eu/schema.rdf#instrument	671	\N	84	instrument	instrument	f	671	\N	\N	f	f	15	215	\N	t	f	\N	\N	\N	t	f	f
676	http://eunis.eea.europa.eu/rdf/schema.rdf#code	611	\N	107	code	code	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
678	http://rdfdata.eionet.europa.eu/article17/generalreportspa_total_number	15	\N	100	generalreportspa_total_number	generalreportspa_total_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
679	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingDB	332675	\N	69	reportingDB	reportingDB	f	332675	\N	\N	f	f	178	8	\N	t	f	\N	\N	\N	t	f	f
680	http://rdfdata.eionet.europa.eu/article17/generalreportcommission_informed_year	176	\N	100	generalreportcommission_informed_year	generalreportcommission_informed_year	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
681	http://rdfdata.eionet.europa.eu/airquality/ontology/organisationLevel	48671	\N	69	organisationLevel	organisationLevel	f	48671	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
682	http://www.w3.org/2004/02/skos/core#inScheme	216868	\N	4	inScheme	inScheme	f	216868	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
683	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpGroundWater	4477	\N	102	dcpGroundWater	dcpGroundWater	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
684	http://rdfdata.eionet.europa.eu/article17/ontology/population_sources	2414	\N	83	population_sources	population_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
685	http://rdfdata.eionet.europa.eu/wise/ontology/EUCD_RBD	197	\N	86	EUCD_RBD	EUCD_RBD	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
687	http://www.w3.org/2000/01/rdf-schema#range	5892	\N	2	range	range	f	5892	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
688	http://rod.eionet.europa.eu/schema.rdf#issue	926	\N	84	issue	issue	f	926	\N	\N	f	f	15	64	\N	t	f	\N	\N	\N	t	f	f
689	http://www.openlinksw.com/schemas/virtrdf#qmvaTableName	2	\N	17	qmvaTableName	qmvaTableName	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
690	http://cr.eionet.europa.eu/ontologies/contreg.rdf#tag	3	\N	82	tag	tag	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
691	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_quality	115	\N	83	population_trend_long_quality	population_trend_long_quality	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
692	http://rdfdata.eionet.europa.eu/wise/ontology/NO_SITES	17462	\N	86	NO_SITES	NO_SITES	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
693	http://reference.eionet.europa.eu/aq/ontology/commentExceedanceBase	145	\N	81	commentExceedanceBase	commentExceedanceBase	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
694	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#annualtraffic	92	\N	143	annualtraffic	annualtraffic	f	0	\N	\N	f	f	268	\N	\N	t	f	\N	\N	\N	t	f	f
695	http://rdfdata.eionet.europa.eu/airquality/ontology/observedProperty	2850757	\N	69	observedProperty	observedProperty	f	2850757	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
696	http://rdfdata.eionet.europa.eu/wise/ontology/ExemptionComment	718	\N	86	ExemptionComment	ExemptionComment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
697	http://rdfdata.eionet.europa.eu/wise/ontology/WB_LOCATION	40831	\N	86	WB_LOCATION	WB_LOCATION	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
698	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaC	5548	\N	102	rcaC	rcaC	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
699	http://rdfdata.eionet.europa.eu/wise/ontology/forGroundWaterBody	25252	\N	86	forGroundWaterBody	forGroundWaterBody	f	25252	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
700	http://reference.eionet.europa.eu/aq/ontology/endPosition	935516	\N	81	endPosition	endPosition	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
701	http://rod.eionet.europa.eu/schema.rdf#primaryRepository	257	\N	84	primaryRepository	primaryRepository	f	257	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
702	http://open.vocab.org/terms/describes	2	\N	75	describes	describes	f	2	\N	\N	f	f	\N	201	\N	t	f	\N	\N	\N	t	f	f
703	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv#CountryCode	91	\N	150	CountryCode	CountryCode	f	0	\N	\N	f	f	165	\N	\N	t	f	\N	\N	\N	t	f	f
704	http://rdfdata.eionet.europa.eu/waterbase/ontology/wFDstation	3619	\N	95	wFDstation	wFDstation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
705	http://purl.org/dc/terms/date	523269	\N	5	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
706	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaB	5548	\N	102	rcaB	rcaB	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
707	http://rod.eionet.europa.eu/schema.rdf#dataSteward	7	\N	84	dataSteward	dataSteward	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
708	http://rdfdata.eionet.europa.eu/airquality/ontology/localIncrement	1512	\N	69	localIncrement	localIncrement	f	1512	\N	\N	f	f	124	190	\N	t	f	\N	\N	\N	t	f	f
709	http://rdfdata.eionet.europa.eu/article17/generalreportyear	14	\N	100	generalreportyear	generalreportyear	f	0	\N	\N	f	f	242	\N	\N	t	f	\N	\N	\N	t	f	f
710	http://rdfdata.eionet.europa.eu/wise/ontology/ScaleExplanation	3731	\N	86	ScaleExplanation	ScaleExplanation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
711	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaAbsenceRisk	5220	\N	102	rcaAbsenceRisk	rcaAbsenceRisk	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
712	http://rdfdata.eionet.europa.eu/wise/ontology/DESIGN_CONSIDERATIONS	505	\N	86	DESIGN_CONSIDERATIONS	DESIGN_CONSIDERATIONS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
713	http://rdfdata.eionet.europa.eu/waterbase/ontology/catchmentName	7013	\N	95	catchmentName	catchmentName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
714	http://purl.org/linked-data/sdmx/2009/dimension#refArea	217681	\N	71	refArea	refArea	f	217681	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
715	http://reference.eionet.europa.eu/aq/ontology/measurementEquipment	29941	\N	81	measurementEquipment	measurementEquipment	f	29941	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
716	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv#ctrycd	94	\N	134	ctrycd	ctrycd	f	0	\N	\N	f	f	109	\N	\N	t	f	\N	\N	\N	t	f	f
717	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#airportname	92	\N	137	airportname	airportname	f	0	\N	\N	f	f	263	\N	\N	t	f	\N	\N	\N	t	f	f
718	http://dd.eionet.europa.eu/tables/8286/rdf#NWUnitName	19984	\N	132	NWUnitName	NWUnitName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
719	http://rdfdata.eionet.europa.eu/wise/ontology/ProtAreaExemptionComment	481	\N	86	ProtAreaExemptionComment	ProtAreaExemptionComment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
720	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggBestTechnicalKnowledge	5461	\N	102	aggBestTechnicalKnowledge	aggBestTechnicalKnowledge	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
721	http://dd.eionet.europa.eu/property/measuresPollutant	494	\N	130	measuresPollutant	measuresPollutant	f	419	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
722	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#hasWikipediaArticle	3006	\N	110	hasWikipediaArticle	hasWikipediaArticle	f	3006	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
723	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv#ReferenceDataSet	1124	\N	151	ReferenceDataSet	ReferenceDataSet	f	0	\N	\N	f	f	217	\N	\N	t	f	\N	\N	\N	t	f	f
724	http://rdfdata.eionet.europa.eu/airquality/ontology/quantity	17781	\N	69	quantity	quantity	f	0	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
894	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNUTS	34569	\N	102	uwwNUTS	uwwNUTS	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
725	http://rdfdata.eionet.europa.eu/wise/ontology/WFD_GW_body_confirmed	1611	\N	86	WFD_GW_body_confirmed	WFD_GW_body_confirmed	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
726	http://rdfdata.eionet.europa.eu/wise/ontology/Thickness_Mean	286	\N	86	Thickness_Mean	Thickness_Mean	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
727	http://telegraphis.net/ontology/measurement/code#hasCode	984	\N	92	hasCode	hasCode	f	984	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
728	http://cr.eionet.europa.eu/ontologies/contreg.rdf#sparqlQuery	129	\N	82	sparqlQuery	sparqlQuery	f	0	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
729	http://rdfdata.eionet.europa.eu/wise/ontology/GoodQuantitativeStatusExemption	1711	\N	86	GoodQuantitativeStatusExemption	GoodQuantitativeStatusExemption	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
730	http://rdfdata.eionet.europa.eu/airquality/ontology/beginLifespanVersion	30896	\N	69	beginLifespanVersion	beginLifespanVersion	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
731	http://dbpedia.org/property/binomial	1661	\N	19	binomial	binomial	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
732	http://reference.eionet.europa.eu/aq/ontology/timecoveragePct	935732	\N	81	timecoveragePct	timecoveragePct	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
733	http://rdfdata.eionet.europa.eu/wise/ontology/PROT_AREA_ASSOC	25252	\N	86	PROT_AREA_ASSOC	PROT_AREA_ASSOC	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
734	http://rdfdata.eionet.europa.eu/wise/ontology/SignificantImpactTypes	7191	\N	86	SignificantImpactTypes	SignificantImpactTypes	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
735	http://reference.eionet.europa.eu/aq/ontology/dataQualityReport	3027	\N	81	dataQualityReport	dataQualityReport	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
736	http://rdfdata.eionet.europa.eu/article17/ontology/region	24530	\N	83	region	region	f	24530	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
737	http://rdfdata.eionet.europa.eu/wise/ontology/SUBSITES	34407	\N	86	SUBSITES	SUBSITES	f	0	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
738	http://www.w3.org/2002/07/owl#equivalentClass	1	\N	7	equivalentClass	equivalentClass	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
739	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggName	35097	\N	102	aggName	aggName	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
740	http://purl.org/dc/elements/1.1/date	2	\N	6	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
741	http://rdfdata.eionet.europa.eu/airquality/ontology/areaUOM	29718	\N	69	areaUOM	areaUOM	f	29718	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
742	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODIncomingEstimated	520	\N	102	uwwCODIncomingEstimated	uwwCODIncomingEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
743	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceSituation	5253	\N	69	exceedanceSituation	exceedanceSituation	f	5253	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
744	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#UniqueRoadID	123830	\N	147	UniqueRoadID	UniqueRoadID	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
745	http://rdfdata.eionet.europa.eu/wise/ontology/ChemicalExemption	4414	\N	86	ChemicalExemption	ChemicalExemption	f	4414	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
746	http://rod.eionet.europa.eu/schema.rdf#clientShortName	5	\N	84	clientShortName	clientShortName	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
747	http://rdfdata.eionet.europa.eu/wise/ontology/URL	19543	\N	86	URL	URL	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
748	http://reference.eionet.europa.eu/aq/ontology/measurementMethod	38488	\N	81	measurementMethod	measurementMethod	f	38488	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
749	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwOtherPerf	4877	\N	102	uwwOtherPerf	uwwOtherPerf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
750	http://rdfdata.eionet.europa.eu/article17/generalreportmeasures_impact	35	\N	100	generalreportmeasures_impact	generalreportmeasures_impact	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
751	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNDischargeCalculated	4039	\N	102	uwwNDischargeCalculated	uwwNDischargeCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
752	http://rdfdata.eionet.europa.eu/msfd/ontology/competentAuthorityName	283	\N	85	competentAuthorityName	competentAuthorityName	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
753	http://rdfdata.eionet.europa.eu/wise/ontology/Associated_Aquatic_Ecosystems_Purpose	407	\N	86	Associated_Aquatic_Ecosystems_Purpose	Associated_Aquatic_Ecosystems_Purpose	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
754	http://reference.eionet.europa.eu/aq/ontology/type	3259	\N	81	type	type	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
755	http://purl.org/dc/elements/1.1/modified	1	\N	6	modified	modified	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
756	http://rdfdata.eionet.europa.eu/article17/ontology/area_reasons_for_change_b	4436	\N	83	area_reasons_for_change_b	area_reasons_for_change_b	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
757	http://rdfdata.eionet.europa.eu/article17/ontology/area_reasons_for_change_a	4436	\N	83	area_reasons_for_change_a	area_reasons_for_change_a	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
758	http://rdfdata.eionet.europa.eu/article17/ontology/area_reasons_for_change_c	4436	\N	83	area_reasons_for_change_c	area_reasons_for_change_c	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
759	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_noeffect	50566	\N	83	broad_evaluation_noeffect	broad_evaluation_noeffect	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
760	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggNUTS	35097	\N	102	aggNUTS	aggNUTS	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
761	http://purl.org/dc/terms/isVersionOf	443	\N	5	isVersionOf	isVersionOf	f	443	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
762	http://dd.eionet.europa.eu/tables/8286/rdf#BWType	33849	\N	132	BWType	BWType	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
763	http://reference.eionet.europa.eu/aq/ontology/assessmentTypeDescription	13590054	\N	81	assessmentTypeDescription	assessmentTypeDescription	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
764	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi4	1	\N	101	NSi4	NSi4	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
765	http://rdfdata.eionet.europa.eu/wise/ontology/REASON_DELAYED	55	\N	86	REASON_DELAYED	REASON_DELAYED	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
766	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi2	1	\N	101	NSi2	NSi2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
767	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi3	1	\N	101	NSi3	NSi3	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1498	http://www.w3.org/2003/01/geo/wgs84_pos#lat	1989170	\N	25	lat	lat	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
768	http://rdfdata.eionet.europa.eu/article17/ontology/structure_and_functions_method	4427	\N	83	structure_and_functions_method	structure_and_functions_method	f	4427	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
769	http://rdfdata.eionet.europa.eu/inspire-m/ontology/documentYear	1	\N	101	documentYear	documentYear	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
770	http://rdfdata.eionet.europa.eu/wise/ontology/PollutantCausingExemption	5543	\N	86	PollutantCausingExemption	PollutantCausingExemption	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
771	http://rdfdata.eionet.europa.eu/article17/generalreportsitecode	187	\N	100	generalreportsitecode	generalreportsitecode	f	187	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
772	http://rdfdata.eionet.europa.eu/article17/ontology/threats_method	14827	\N	83	threats_method	threats_method	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
773	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi1	1	\N	101	NSi1	NSi1	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
774	http://rdfdata.eionet.europa.eu/wise/ontology/StatusProtectedAreas	25252	\N	86	StatusProtectedAreas	StatusProtectedAreas	f	25252	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
775	http://rod.eionet.europa.eu/schema.rdf#released	276114	\N	84	released	released	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
776	http://rdfdata.eionet.europa.eu/wise/ontology/QuantitativeStatus	24222	\N	86	QuantitativeStatus	QuantitativeStatus	f	24222	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
777	http://rdfdata.eionet.europa.eu/airquality/ontology/projectionScenario	935	\N	69	projectionScenario	projectionScenario	f	935	\N	\N	f	f	126	143	\N	t	f	\N	\N	\N	t	f	f
778	http://rdfdata.eionet.europa.eu/wise/ontology/GeologicalFormation	17295	\N	86	GeologicalFormation	GeologicalFormation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
779	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_method	10556	\N	83	habitat_method	habitat_method	f	10556	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
780	http://rdfdata.eionet.europa.eu/airquality/ontology/streetWidthUOM	61071	\N	69	streetWidthUOM	streetWidthUOM	f	61071	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
781	http://purl.org/dc/terms/language	60	\N	5	language	language	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
782	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#uniqueagglomerationid	506	\N	138	uniqueagglomerationid	uniqueagglomerationid	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
783	http://reference.eionet.europa.eu/aq/ontology/caWebsite	1485	\N	81	caWebsite	caWebsite	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
784	http://rdfdata.eionet.europa.eu/uwwtd/ontology/foraucAggCode	36540	\N	102	foraucAggCode	foraucAggCode	f	36540	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
785	http://rdfdata.eionet.europa.eu/airquality/ontology/EUStationCode	266220	\N	69	EUStationCode	EUStationCode	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
786	http://purl.org/dc/terms/title	838852	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
787	http://rdfdata.eionet.europa.eu/article17/generalreportproject_impact	184	\N	100	generalreportproject_impact	generalreportproject_impact	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
788	http://rdfdata.eionet.europa.eu/airquality/ontology/nation-wideQualityAssurance	1	\N	69	nation-wideQualityAssurance	nation-wideQualityAssurance	f	1	\N	\N	f	f	262	78	\N	t	f	\N	\N	\N	t	f	f
789	http://rdfdata.eionet.europa.eu/wise/ontology/SignificantUpwardTrends	24222	\N	86	SignificantUpwardTrends	SignificantUpwardTrends	f	24222	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
790	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv13_RelArea	1	\N	101	DSv13_RelArea	DSv13_RelArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
791	http://dd.eionet.europa.eu/property/vocabularyType	209	\N	130	vocabularyType	vocabularyType	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
792	http://rdfdata.eionet.europa.eu/wise/ontology/CYCLE	48328	\N	86	CYCLE	CYCLE	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
793	http://reference.eionet.europa.eu/aq/ontology/measurementType	61906	\N	81	measurementType	measurementType	f	61906	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
794	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpMSProvide	4673	\N	102	dcpMSProvide	dcpMSProvide	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
795	http://rdfdata.eionet.europa.eu/article17/ontology/range_sources	1084	\N	83	range_sources	range_sources	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
796	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/annualtraffic	76	\N	87	annualtraffic	annualtraffic	f	0	\N	\N	f	f	271	\N	\N	t	f	\N	\N	\N	t	f	f
797	http://rdfdata.eionet.europa.eu/uwwtd/ontology/foruwwID	36450	\N	102	foruwwID	foruwwID	f	36450	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
798	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv12_ActArea	1	\N	101	DSv12_ActArea	DSv12_ActArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
799	http://dd.eionet.europa.eu/tables/8286/rdf#BWID	33845	\N	132	BWID	BWID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
800	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggCalculation	35097	\N	102	aggCalculation	aggCalculation	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
801	http://rdfdata.eionet.europa.eu/wise/ontology/Depth_to_GW_Mean	318	\N	86	Depth_to_GW_Mean	Depth_to_GW_Mean	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
802	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2014.csv#airportname	94	\N	134	airportname	airportname	f	0	\N	\N	f	f	109	\N	\N	t	f	\N	\N	\N	t	f	f
803	http://rdfdata.eionet.europa.eu/wise/ontology/areaM	202	\N	86	areaM	areaM	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
804	http://www.openlinksw.com/schemas/virtrdf#item	139	\N	17	item	item	f	139	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
805	http://reference.eionet.europa.eu/aq/ontology/reportingEnd	238446	\N	81	reportingEnd	reportingEnd	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
806	http://rdfdata.eionet.europa.eu/wise/ontology/OTHER_SUPPLY	17380	\N	86	OTHER_SUPPLY	OTHER_SUPPLY	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
807	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggDilutionRates	27509	\N	102	aggDilutionRates	aggDilutionRates	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
808	http://cr.eionet.europa.eu/project/noise/MRail_2010_2015.csv#ReferenceDataSet	19068	\N	144	ReferenceDataSet	ReferenceDataSet	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
809	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODDischargeEstimated	520	\N	102	uwwBODDischargeEstimated	uwwBODDischargeEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1499	http://dd.eionet.europa.eu/property/aq_zonetype	162	\N	130	aq_zonetype	aq_zonetype	f	20	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
810	http://rdfdata.eionet.europa.eu/airquality/ontology/offRoadMobileMachinery	3024	\N	69	offRoadMobileMachinery	offRoadMobileMachinery	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
811	http://rdfdata.eionet.europa.eu/airquality/ontology/kerbDistanceUOM	705645	\N	69	kerbDistanceUOM	kerbDistanceUOM	f	705645	\N	\N	f	f	35	8	\N	t	f	\N	\N	\N	t	f	f
812	http://dd.eionet.europa.eu/property/SurfaceArea	45	\N	130	SurfaceArea	SurfaceArea	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
813	http://rdfdata.eionet.europa.eu/article17/ontology/notChangedByMemberState	167	\N	83	notChangedByMemberState	notChangedByMemberState	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
814	http://rdfdata.eionet.europa.eu/wise/ontology/AverageThickness	5241	\N	86	AverageThickness	AverageThickness	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
815	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#annualtraffic	92	\N	137	annualtraffic	annualtraffic	f	0	\N	\N	f	f	263	\N	\N	t	f	\N	\N	\N	t	f	f
816	http://reference.eionet.europa.eu/aq/ontology/temporalResolution	117692	\N	81	temporalResolution	temporalResolution	f	117692	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
817	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_additional_info	618	\N	83	range_trend_additional_info	range_trend_additional_info	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
818	http://rdfdata.eionet.europa.eu/airquality/ontology/resultTime	483641	\N	69	resultTime	resultTime	f	483641	\N	\N	f	f	36	59	\N	t	f	\N	\N	\N	t	f	f
819	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_additional_info	2600	\N	83	population_trend_additional_info	population_trend_additional_info	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
820	http://www.w3.org/2004/02/skos/core#related	3406	\N	4	related	related	f	3406	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
821	http://rdfdata.eionet.europa.eu/article17/ontology/presence	470	\N	83	presence	presence	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
822	http://www.geonames.org/ontology#countryCode	166	\N	70	countryCode	countryCode	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
823	http://cr.eionet.europa.eu/ontologies/contreg.rdf#errorMessage	43740	\N	82	errorMessage	errorMessage	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
824	http://www.openlinksw.com/schemas/virtrdf#qmvColumns	8	\N	17	qmvColumns	qmvColumns	f	8	\N	\N	f	f	228	245	\N	t	f	\N	\N	\N	t	f	f
825	http://rdfs.org/ns/void#sparqlEndpoint	8	\N	16	sparqlEndpoint	sparqlEndpoint	f	8	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
826	http://reference.eionet.europa.eu/aq/ontology/inletHeightUOM	70896	\N	81	inletHeightUOM	inletHeightUOM	f	70896	\N	\N	f	f	202	8	\N	t	f	\N	\N	\N	t	f	f
827	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_period	3601	\N	83	population_trend_long_period	population_trend_long_period	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
828	http://www.geonames.org/ontology#officialName	19956	\N	70	officialName	officialName	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
829	http://rdfdata.eionet.europa.eu/article17/generalreport/published	42	\N	118	published	published	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
830	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucUwwCode	36540	\N	102	aucUwwCode	aucUwwCode	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
831	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaNDischargedCalculated	3	\N	102	rcaNDischargedCalculated	rcaNDischargedCalculated	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
832	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLong	8	\N	17	qmfIsSubformatOfLong	qmfIsSubformatOfLong	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
833	http://rdfdata.eionet.europa.eu/airquality/ontology/traffic	3024	\N	69	traffic	traffic	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
834	http://psi.oasis-open.org/iso/639/#code-a3t	472	\N	93	code-a3t	code-a3t	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
835	http://rdfdata.eionet.europa.eu/wise/ontology/CONFIDENCE	3365	\N	86	CONFIDENCE	CONFIDENCE	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
836	http://www.w3.org/2000/01/rdf-schema#domain	7704	\N	2	domain	domain	f	7704	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
837	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucPercC2T	5642	\N	102	aucPercC2T	aucPercC2T	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
838	http://psi.oasis-open.org/iso/639/#code-a3b	472	\N	93	code-a3b	code-a3b	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
839	http://rdfdata.eionet.europa.eu/airquality/ontology/processType	2365155	\N	69	processType	processType	f	2365155	\N	\N	f	f	233	\N	\N	t	f	\N	\N	\N	t	f	f
840	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_maintain	50566	\N	83	broad_evaluation_maintain	broad_evaluation_maintain	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
841	http://rdfdata.eionet.europa.eu/airquality/ontology/usedAQD	1851626	\N	69	usedAQD	usedAQD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
842	http://www.openlinksw.com/schemas/virtrdf#qmfIsSubformatOfLongWhenEqToSql	2	\N	17	qmfIsSubformatOfLongWhenEqToSql	qmfIsSubformatOfLongWhenEqToSql	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
843	http://rdfdata.eionet.europa.eu/airquality/ontology/pollutantCode	304329	\N	69	pollutantCode	pollutantCode	f	304329	\N	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
844	http://rdfdata.eionet.europa.eu/article17/ontology/pressure_threatname	20022	\N	83	pressure_threatname	pressure_threatname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
845	http://rdfdata.eionet.europa.eu/wise/ontology/LENGTH	755	\N	86	LENGTH	LENGTH	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
846	http://dd.eionet.europa.eu/property/maximumValue	1194	\N	130	maximumValue	maximumValue	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
847	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_population_method	3480	\N	83	complementary_favourable_population_method	complementary_favourable_population_method	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
848	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#subGroupOf	32	\N	110	subGroupOf	subGroupOf	f	32	\N	\N	f	f	185	139	\N	t	f	\N	\N	\N	t	f	f
849	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#country	456	\N	129	country	country	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
850	http://reference.eionet.europa.eu/aq/ontology/demonstrationReport	13094	\N	81	demonstrationReport	demonstrationReport	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
851	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggRemarks	4669	\N	102	aggRemarks	aggRemarks	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
852	http://rdfdata.eionet.europa.eu/article17/ontology/range_method	15108	\N	83	range_method	range_method	f	14990	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
853	http://reference.eionet.europa.eu/aq/ontology/areaClassification	1500467	\N	81	areaClassification	areaClassification	f	1500467	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
854	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggC1	35097	\N	102	aggC1	aggC1	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
855	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggC2	35097	\N	102	aggC2	aggC2	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
856	http://rdfdata.eionet.europa.eu/article17/ontology/population_alt_minimum_size	4857	\N	83	population_alt_minimum_size	population_alt_minimum_size	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
857	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceDescriptionBase	775	\N	69	exceedanceDescriptionBase	exceedanceDescriptionBase	f	775	\N	\N	f	f	205	196	\N	t	f	\N	\N	\N	t	f	f
858	http://rdfdata.eionet.europa.eu/article17/ontology/BirdMeasure	15858	\N	83	BirdMeasure	BirdMeasure	f	15858	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
859	http://rod.eionet.europa.eu/schema.rdf#clientCity	68	\N	84	clientCity	clientCity	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
860	http://rod.eionet.europa.eu/schema.rdf#lastUpdate	887	\N	84	lastUpdate	lastUpdate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
861	http://rdfdata.eionet.europa.eu/article17/generalreport/type-management-body	1364	\N	118	type-management-body	type-management-body	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
862	http://rdfdata.eionet.europa.eu/airquality/ontology/changeDocumentation	7064	\N	69	changeDocumentation	changeDocumentation	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
863	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#ctrycd	506	\N	138	ctrycd	ctrycd	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
864	http://reference.eionet.europa.eu/aq/ontology/surfaceArea	1504128	\N	81	surfaceArea	surfaceArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
865	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwName	36012	\N	102	uwwName	uwwName	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
866	http://rdfdata.eionet.europa.eu/waterbase/ontology/nationalStationName	9814	\N	95	nationalStationName	nationalStationName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
867	http://rdfdata.eionet.europa.eu/wise/ontology/AREA	21546	\N	86	AREA	AREA	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
868	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_period	4442	\N	83	range_trend_long_period	range_trend_long_period	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
869	http://rdfdata.eionet.europa.eu/airquality/ontology/environmentalDomain	30892	\N	69	environmentalDomain	environmentalDomain	f	30892	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
870	http://rdfdata.eionet.europa.eu/airquality/ontology/trafficEmissions	402228	\N	69	trafficEmissions	trafficEmissions	f	0	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
871	http://rdfdata.eionet.europa.eu/article17/generalreport/sitename	10711	\N	118	sitename	sitename	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
872	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfSqlvalTmpl	31	\N	17	qmfShortOfSqlvalTmpl	qmfShortOfSqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
873	http://rdfdata.eionet.europa.eu/airquality/ontology/activityTime	2334482	\N	69	activityTime	activityTime	f	2334482	\N	\N	f	f	104	177	\N	t	f	\N	\N	\N	t	f	f
874	http://rdfdata.eionet.europa.eu/msfd/ontology/regionalCoordination	270	\N	85	regionalCoordination	regionalCoordination	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
875	http://rdfdata.eionet.europa.eu/msfd/ontology/uRL	283	\N	85	uRL	uRL	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
876	http://open.vocab.org/terms/defines	2	\N	75	defines	defines	f	2	\N	\N	f	f	\N	201	\N	t	f	\N	\N	\N	t	f	f
877	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_redlist_reference	15	\N	100	generalreportnational_bird_redlist_reference	generalreportnational_bird_redlist_reference	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
878	http://www.openlinksw.com/schemas/virtrdf#isGcResistantType	2	\N	17	isGcResistantType	isGcResistantType	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
879	http://rdfdata.eionet.europa.eu/wise/ontology/DRINK_WATER	22037	\N	86	DRINK_WATER	DRINK_WATER	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
880	http://rdfdata.eionet.europa.eu/wise/ontology/TypeOfProtectedArea	23018	\N	86	TypeOfProtectedArea	TypeOfProtectedArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
881	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#airportname	92	\N	143	airportname	airportname	f	0	\N	\N	f	f	268	\N	\N	t	f	\N	\N	\N	t	f	f
882	http://www.w3.org/2004/02/skos/core#broader	20601	\N	4	broader	broader	f	20149	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
883	http://xmlns.com/foaf/0.1/maker	5	\N	8	maker	maker	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
884	http://www.openlinksw.com/schemas/DAV#ownerUser	777	\N	18	ownerUser	ownerUser	f	777	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
885	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslRemarks	17	\N	102	mslRemarks	mslRemarks	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
886	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv#UniqueRailId	9351	\N	152	UniqueRailId	UniqueRailId	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
887	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#referenceyear	114	\N	153	referenceyear	referenceyear	f	0	\N	\N	f	f	261	\N	\N	t	f	\N	\N	\N	t	f	f
888	http://rod.eionet.europa.eu/schema.rdf#dataUsedFor	114	\N	84	dataUsedFor	dataUsedFor	f	114	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
889	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucAggCode	36540	\N	102	aucAggCode	aucAggCode	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
890	http://rdfdata.eionet.europa.eu/airquality/ontology/totalEmissions	1870	\N	69	totalEmissions	totalEmissions	f	0	\N	\N	f	f	143	\N	\N	t	f	\N	\N	\N	t	f	f
891	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Reference_Year	5149	\N	128	Reference_Year	Reference_Year	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
892	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_range_unknown	15195	\N	83	complementary_favourable_range_unknown	complementary_favourable_range_unknown	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
893	http://rdfdata.eionet.europa.eu/article17/generalreportspa_marine_area	15	\N	100	generalreportspa_marine_area	generalreportspa_marine_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
895	http://purl.org/dc/terms/identifier	154	\N	5	identifier	identifier	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
896	http://rdfdata.eionet.europa.eu/article17/generalreport/region	104	\N	118	region	region	f	104	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1500	http://www.w3.org/ns/dcat#byteSize	523260	\N	15	byteSize	byteSize	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
897	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggAccOverflows	27509	\N	102	aggAccOverflows	aggAccOverflows	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
898	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWFDRBD	19660	\N	102	dcpWFDRBD	dcpWFDRBD	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
899	http://rdfdata.eionet.europa.eu/waterbase/ontology/seaRegionName	4392	\N	95	seaRegionName	seaRegionName	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
900	http://reference.eionet.europa.eu/aq/ontology/cadenceNum	37272	\N	81	cadenceNum	cadenceNum	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
901	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Data_source	123830	\N	147	Data_source	Data_source	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
902	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpReceivingWater	9691	\N	102	dcpReceivingWater	dcpReceivingWater	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
903	http://rdfdata.eionet.europa.eu/wise/ontology/TRANSBOUNDARY	16908	\N	86	TRANSBOUNDARY	TRANSBOUNDARY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
904	http://dd.eionet.europa.eu/property/maximumPopulation	162	\N	130	maximumPopulation	maximumPopulation	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
905	http://rdfdata.eionet.europa.eu/wise/ontology/forRBD	41433	\N	86	forRBD	forRBD	f	41433	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
906	http://www.geonames.org/ontology#locationMap	170	\N	70	locationMap	locationMap	f	170	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
907	http://rdfdata.eionet.europa.eu/waterbase/ontology/region	6612	\N	95	region	region	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
908	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaCDateOtherDirective	1184	\N	102	rcaCDateOtherDirective	rcaCDateOtherDirective	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
909	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNRemoval	34820	\N	102	uwwNRemoval	uwwNRemoval	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
910	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long_magnitude_min	63	\N	83	coverage_trend_long_magnitude_min	coverage_trend_long_magnitude_min	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
911	http://rdfdata.eionet.europa.eu/airquality/ontology/lowerCorner	750	\N	69	lowerCorner	lowerCorner	f	0	\N	\N	f	f	198	\N	\N	t	f	\N	\N	\N	t	f	f
912	http://cr.eionet.europa.eu/ontologies/contreg.rdf#userBookmark	9	\N	82	userBookmark	userBookmark	f	9	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
913	http://purl.org/dc/elements/1.1/source	53	\N	6	source	source	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
914	http://www.openlinksw.com/schemas/virtrdf#qmfIsuriOfShortTmpl	31	\N	17	qmfIsuriOfShortTmpl	qmfIsuriOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
915	http://www.w3.org/2004/02/skos/core#exactMatch	38448	\N	4	exactMatch	exactMatch	f	18886	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
916	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_area_method	4428	\N	83	natura2000_area_method	natura2000_area_method	f	4428	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
917	http://rdfdata.eionet.europa.eu/article17/ontology/population_additional_locality	2433	\N	83	population_additional_locality	population_additional_locality	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
918	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfTypedsqlvalTmpl	31	\N	17	qmfShortOfTypedsqlvalTmpl	qmfShortOfTypedsqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
919	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#size	456	\N	129	size	size	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
920	http://rdfdata.eionet.europa.eu/wise/ontology/CommentQuantitativeStatusValue	1924	\N	86	CommentQuantitativeStatusValue	CommentQuantitativeStatusValue	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
921	http://rdfdata.eionet.europa.eu/wise/ontology/GENERATEDBY	182	\N	86	GENERATEDBY	GENERATEDBY	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
922	http://dd.eionet.europa.eu/property/assessmentThreshold	370	\N	130	assessmentThreshold	assessmentThreshold	f	350	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
923	http://www.openlinksw.com/schemas/virtrdf#isSpecialPredicate	5	\N	17	isSpecialPredicate	isSpecialPredicate	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
924	http://reference.eionet.europa.eu/aq/ontology/rodPeriod	3188	\N	81	rodPeriod	rodPeriod	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
925	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumViewServ	1	\N	101	NSv_NumViewServ	NSv_NumViewServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
926	http://rdfdata.eionet.europa.eu/airquality/ontology/otherSamplingEquipment	650	\N	69	otherSamplingEquipment	otherSamplingEquipment	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
927	http://rdfdata.eionet.europa.eu/airquality/ontology/trafficVolume	106995	\N	69	trafficVolume	trafficVolume	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
928	http://rdfdata.eionet.europa.eu/wise/ontology/inDeclaration	60498	\N	86	inDeclaration	inDeclaration	f	60498	\N	\N	f	f	\N	120	\N	t	f	\N	\N	\N	t	f	f
929	http://rdfdata.eionet.europa.eu/msfd/ontology/street	283	\N	85	street	street	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
930	http://rdfdata.eionet.europa.eu/airquality/ontology/ecosystemAreaExposed	4262	\N	69	ecosystemAreaExposed	ecosystemAreaExposed	f	0	\N	\N	f	f	272	\N	\N	t	f	\N	\N	\N	t	f	f
931	http://rod.eionet.europa.eu/schema.rdf#providerFor	17483	\N	84	providerFor	providerFor	f	17483	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
932	http://reference.eionet.europa.eu/aq/ontology/distanceSource	557472	\N	81	distanceSource	distanceSource	f	0	\N	\N	f	f	225	\N	\N	t	f	\N	\N	\N	t	f	f
933	http://www.w3.org/2002/07/owl#equivalentProperty	3	\N	7	equivalentProperty	equivalentProperty	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
934	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceDescriptionAdjustment	716	\N	69	exceedanceDescriptionAdjustment	exceedanceDescriptionAdjustment	f	716	\N	\N	f	f	205	196	\N	t	f	\N	\N	\N	t	f	f
935	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv#Ctry_2	9351	\N	152	Ctry_2	Ctry_2	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
936	http://rdfdata.eionet.europa.eu/airquality/ontology/analyticalTechnique	1432618	\N	69	analyticalTechnique	analyticalTechnique	f	1432618	\N	\N	f	f	179	3	\N	t	f	\N	\N	\N	t	f	f
937	http://purl.org/dc/terms/isReplacedBy	2863265	\N	5	isReplacedBy	isReplacedBy	f	2854462	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
938	http://rdfdata.eionet.europa.eu/wise/ontology/countryCode	202	\N	86	countryCode	countryCode	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
939	http://rdfdata.eionet.europa.eu/eea/ontology/detCode	1303	\N	88	detCode	detCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
940	http://rdfdata.eionet.europa.eu/article17/generalreportachievements	66	\N	100	generalreportachievements	generalreportachievements	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
941	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDischargeOthers	22	\N	102	mslDischargeOthers	mslDischargeOthers	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
942	http://dd.eionet.europa.eu/property/registrationStatus	210	\N	130	registrationStatus	registrationStatus	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
943	http://rdfdata.eionet.europa.eu/airquality/ontology/equipment	922043	\N	69	equipment	equipment	f	921962	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
944	http://reference.eionet.europa.eu/aq/ontology/qaReport	31976	\N	81	qaReport	qaReport	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
945	http://rdfdata.eionet.europa.eu/wise/ontology/Permanent_Crops	430	\N	86	Permanent_Crops	Permanent_Crops	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
946	http://rdfdata.eionet.europa.eu/article17/generalreportmonitoring_schemes	66	\N	100	generalreportmonitoring_schemes	generalreportmonitoring_schemes	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
947	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#uniqueagglomerationid	456	\N	129	uniqueagglomerationid	uniqueagglomerationid	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
948	http://rdfdata.eionet.europa.eu/airquality/ontology/adoptionDate	1534	\N	69	adoptionDate	adoptionDate	f	1534	\N	\N	f	f	208	59	\N	t	f	\N	\N	\N	t	f	f
949	http://rdfdata.eionet.europa.eu/wise/ontology/END_DATE	122	\N	86	END_DATE	END_DATE	f	0	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
950	http://www.w3.org/2000/01/rdf-schema#seeAlso	292	\N	2	seeAlso	seeAlso	f	290	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
951	http://rdfdata.eionet.europa.eu/airquality/ontology/processParameter	903132	\N	69	processParameter	processParameter	f	903132	\N	\N	f	f	\N	170	\N	t	f	\N	\N	\N	t	f	f
952	http://rdfdata.eionet.europa.eu/airquality/ontology/electronicMailAddress	1911147	\N	69	electronicMailAddress	electronicMailAddress	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
953	http://www.snee.com/ns/eplocation	46	\N	133	eplocation	eplocation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
954	http://xmlns.com/foaf/0.1/isPrimaryTopicOf	1385	\N	8	isPrimaryTopicOf	isPrimaryTopicOf	f	1385	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
955	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentThreshold	479066	\N	69	assessmentThreshold	assessmentThreshold	f	479066	\N	\N	f	f	254	113	\N	t	f	\N	\N	\N	t	f	f
956	http://reference.eionet.europa.eu/aq/ontology/updated	935591	\N	81	updated	updated	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
957	http://rdfdata.eionet.europa.eu/eea/ontology/art17Code	16	\N	88	art17Code	art17Code	f	0	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
958	http://rdfdata.eionet.europa.eu/airquality/ontology/surfaceArea	25859	\N	69	surfaceArea	surfaceArea	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
959	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwMicroFiltration	35949	\N	102	uwwMicroFiltration	uwwMicroFiltration	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
960	http://purl.org/linked-data/api/vocab#page	1	\N	98	page	page	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
961	http://rdfdata.eionet.europa.eu/uwwtd/ontology/forrcaID	30328	\N	102	forrcaID	forrcaID	f	30328	\N	\N	f	f	84	209	\N	t	f	\N	\N	\N	t	f	f
962	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv#IcaoCode	91	\N	150	IcaoCode	IcaoCode	f	0	\N	\N	f	f	165	\N	\N	t	f	\N	\N	\N	t	f	f
963	http://rdfdata.eionet.europa.eu/wise/ontology/PARAMETER	144251	\N	86	PARAMETER	PARAMETER	f	144251	\N	\N	f	f	\N	37	\N	t	f	\N	\N	\N	t	f	f
964	http://rdfdata.eionet.europa.eu/airquality/ontology/distanceJunction	105038	\N	69	distanceJunction	distanceJunction	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
965	http://reference.eionet.europa.eu/aq/ontology/processType	52108	\N	81	processType	processType	f	1285	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
966	http://dd.eionet.europa.eu/property/acceptedDate	205730	\N	130	acceptedDate	acceptedDate	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
967	http://purl.org/linked-data/sdmx/2009/attribute#obsStatus	1656	\N	77	obsStatus	obsStatus	f	1656	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
968	http://rod.eionet.europa.eu/schema.rdf#nextReporting	171	\N	84	nextReporting	nextReporting	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
969	http://rdfdata.eionet.europa.eu/article17/ontology/subspecies_name	1461	\N	83	subspecies_name	subspecies_name	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
970	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaType	5548	\N	102	rcaType	rcaType	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
971	http://rdfdata.eionet.europa.eu/ramon/ontology/partOf	7686	\N	91	partOf	partOf	f	7686	\N	\N	f	f	212	\N	\N	t	f	\N	\N	\N	t	f	f
972	http://rod.eionet.europa.eu/schema.rdf#comment	687	\N	84	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
973	http://reference.eionet.europa.eu/aq/ontology/area	1458	\N	81	area	area	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
974	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#name	472	\N	154	name	name	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
975	http://xmlns.com/foaf/0.1/page	5	\N	8	page	page	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
976	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NnServiceType	37	\N	101	NnServiceType	NnServiceType	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
977	http://www.geonames.org/ontology#parentCountry	8	\N	70	parentCountry	parentCountry	f	8	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
978	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_redlist_year	15	\N	100	generalreportnational_bird_redlist_year	generalreportnational_bird_redlist_year	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
979	http://cr.eionet.europa.eu/ontologies/contreg.rdf#mediaType	1555629	\N	82	mediaType	mediaType	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
980	http://rdfdata.eionet.europa.eu/article17/ontology/range_reasons_for_change_a	15195	\N	83	range_reasons_for_change_a	range_reasons_for_change_a	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1021	http://rdfdata.eionet.europa.eu/airquality/ontology/shortName	19518	\N	69	shortName	shortName	f	0	\N	\N	f	f	151	\N	\N	t	f	\N	\N	\N	t	f	f
981	http://rdfdata.eionet.europa.eu/article17/ontology/range_reasons_for_change_b	15195	\N	83	range_reasons_for_change_b	range_reasons_for_change_b	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1547	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaHydraulic	5220	\N	102	rcaHydraulic	rcaHydraulic	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
982	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpCode	36450	\N	102	dcpCode	dcpCode	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
983	http://rdfdata.eionet.europa.eu/article17/generalreport/memberstate	25	\N	118	memberstate	memberstate	f	0	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
984	http://rdfdata.eionet.europa.eu/airquality/ontology/attainmentYear	935	\N	69	attainmentYear	attainmentYear	f	935	\N	\N	f	f	126	59	\N	t	f	\N	\N	\N	t	f	f
985	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_magnitude_min	1604	\N	83	range_trend_long_magnitude_min	range_trend_long_magnitude_min	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
987	http://rdfdata.eionet.europa.eu/wise/ontology/memberStateRBDCode	202	\N	86	memberStateRBDCode	memberStateRBDCode	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
988	http://www.openlinksw.com/schemas/virtrdf#qmfShortOfLongTmpl	31	\N	17	qmfShortOfLongTmpl	qmfShortOfLongTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
989	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_future_trends	3479	\N	83	conclusion_future_trends	conclusion_future_trends	f	3479	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
990	http://www.geonames.org/ontology#postalCode	1	\N	70	postalCode	postalCode	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
991	http://rdfdata.eionet.europa.eu/article17/ontology/population_additional_problems	2923	\N	83	population_additional_problems	population_additional_problems	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
992	http://rdfdata.eionet.europa.eu/uwwtd/ontology/bigID	1086	\N	102	bigID	bigID	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
993	http://rdfdata.eionet.europa.eu/wise/ontology/LON	40830	\N	86	LON	LON	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
994	http://rod.eionet.europa.eu/schema.rdf#lastHarvested	586	\N	84	lastHarvested	lastHarvested	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
995	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#ICAOcode	114	\N	153	ICAOcode	ICAOcode	f	0	\N	\N	f	f	261	\N	\N	t	f	\N	\N	\N	t	f	f
996	http://cr.eionet.europa.eu/ontologies/contreg.rdf#lastRefreshed	985127	\N	82	lastRefreshed	lastRefreshed	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
997	http://rdfdata.eionet.europa.eu/wise/ontology/Petrographic_Description	1004	\N	86	Petrographic_Description	Petrographic_Description	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
998	http://www.openlinksw.com/schemas/virtrdf#qmfBoolOfShortTmpl	47	\N	17	qmfBoolOfShortTmpl	qmfBoolOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
999	http://rdfdata.eionet.europa.eu/article17/generalreportMonitoringPublications	15	\N	100	generalreportMonitoringPublications	generalreportMonitoringPublications	f	10	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1000	http://rdfdata.eionet.europa.eu/airquality/ontology/unit	3878892	\N	69	unit	unit	f	3878892	\N	\N	f	f	2	8	\N	t	f	\N	\N	\N	t	f	f
1001	http://rdfdata.eionet.europa.eu/wise/ontology/Hydraulic_Conductivity_Mean	359	\N	86	Hydraulic_Conductivity_Mean	Hydraulic_Conductivity_Mean	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1002	http://rod.eionet.europa.eu/schema.rdf#hasFile	523485	\N	84	hasFile	hasFile	f	523485	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
1003	http://cr.eionet.europa.eu/ontologies/contreg.rdf#hasSparqlBookmark	12	\N	82	hasSparqlBookmark	hasSparqlBookmark	f	12	\N	\N	f	f	\N	216	\N	t	f	\N	\N	\N	t	f	f
1004	http://reference.eionet.europa.eu/aq/ontology/streetWidth	1886	\N	81	streetWidth	streetWidth	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1005	http://rdfdata.eionet.europa.eu/wise/ontology/Other	589	\N	86	Other	Other	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1006	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggChanges	35097	\N	102	aggChanges	aggChanges	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1007	http://dd.eionet.europa.eu/property/LatitudeMax	45	\N	130	LatitudeMax	LatitudeMax	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1008	http://rdfdata.eionet.europa.eu/article17/ontology/ranking	256607	\N	83	ranking	ranking	f	221790	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1009	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_future_trend	1585	\N	83	conclusion_future_trend	conclusion_future_trend	f	1585	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1010	http://reference.eionet.europa.eu/aq/ontology/residentPopulationYear	4116	\N	81	residentPopulationYear	residentPopulationYear	f	4116	\N	\N	f	f	107	59	\N	t	f	\N	\N	\N	t	f	f
1011	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggID	19043	\N	102	aggID	aggID	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1012	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long_magnitude_max	55	\N	83	coverage_trend_long_magnitude_max	coverage_trend_long_magnitude_max	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1013	http://reference.eionet.europa.eu/aq/ontology/aggregationType	935516	\N	81	aggregationType	aggregationType	f	935516	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1014	http://rdfdata.eionet.europa.eu/article17/generalreportmeasures_setout_number	44	\N	100	generalreportmeasures_setout_number	generalreportmeasures_setout_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1058	http://rdfdata.eionet.europa.eu/wise/ontology/Location	2144	\N	86	Location	Location	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1015	http://rdfdata.eionet.europa.eu/airquality/ontology/operationActivityPeriod	13593	\N	69	operationActivityPeriod	operationActivityPeriod	f	13593	\N	\N	f	f	82	177	\N	t	f	\N	\N	\N	t	f	f
1016	http://rdfdata.eionet.europa.eu/airquality/ontology/documentation	1411007	\N	69	documentation	documentation	f	25152	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1017	http://rdfdata.eionet.europa.eu/airquality/ontology/administrativeLevel	28135	\N	69	administrativeLevel	administrativeLevel	f	28135	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1018	http://rdfdata.eionet.europa.eu/eea/ontology/hasFigure	14	\N	88	hasFigure	hasFigure	f	14	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
1019	http://rod.eionet.europa.eu/schema.rdf#lastModifiedBy	835	\N	84	lastModifiedBy	lastModifiedBy	f	835	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1020	http://rod.eionet.europa.eu/schema.rdf#responsibleRole	144	\N	84	responsibleRole	responsibleRole	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1104	http://purl.org/dc/terms/isPartOf	753524	\N	5	isPartOf	isPartOf	f	753524	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1022	http://www.openlinksw.com/schemas/virtrdf#qmvcAlias	8	\N	17	qmvcAlias	qmvcAlias	f	0	\N	\N	f	f	146	\N	\N	t	f	\N	\N	\N	t	f	f
1024	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_period	17057	\N	83	[Population trend period (population_trend_period)]	population_trend_period	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1023	http://rdfdata.eionet.europa.eu/wise/ontology/REPORTING_LEVEL_DESCRIPTION	42	\N	86	REPORTING_LEVEL_DESCRIPTION	REPORTING_LEVEL_DESCRIPTION	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
1025	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingAuthority	18214	\N	69	reportingAuthority	reportingAuthority	f	18215	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1026	http://rdfdata.eionet.europa.eu/airquality/ontology/cadence	1925993	\N	69	cadence	cadence	f	1925993	\N	\N	f	f	179	2	\N	t	f	\N	\N	\N	t	f	f
1027	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv1_ActArea	1	\N	101	DSv1_ActArea	DSv1_ActArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1028	http://dd.eionet.europa.eu/property/errorType	659	\N	130	errorType	errorType	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1029	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	20	\N	1	first	first	f	20	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1030	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDischargeShips	22	\N	102	mslDischargeShips	mslDischargeShips	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1031	http://reference.eionet.europa.eu/aq/ontology/observedProperty	1056221	\N	81	observedProperty	observedProperty	f	1056221	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
1032	http://rdfdata.eionet.europa.eu/article17/generalreportsites_marine_area	51	\N	100	generalreportsites_marine_area	generalreportsites_marine_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1033	http://rdfdata.eionet.europa.eu/airquality/ontology/trafficSpeedUOM	69943	\N	69	trafficSpeedUOM	trafficSpeedUOM	f	69943	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1034	http://rod.eionet.europa.eu/schema.rdf#clientEmail	41	\N	84	clientEmail	clientEmail	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
1035	http://purl.org/dc/terms/format	9	\N	5	format	format	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1036	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBOD5Perf	33429	\N	102	uwwBOD5Perf	uwwBOD5Perf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1037	http://rdfdata.eionet.europa.eu/airquality/ontology/transboundary	4536	\N	69	transboundary	transboundary	f	4536	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1038	http://rdfdata.eionet.europa.eu/airquality/ontology/buildingDistance	815747	\N	69	buildingDistance	buildingDistance	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
1039	http://rod.eionet.europa.eu/schema.rdf#dateComments	259	\N	84	dateComments	dateComments	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1040	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaDateDesignation	5438	\N	102	rcaDateDesignation	rcaDateDesignation	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1041	http://reference.eionet.europa.eu/aq/ontology/assessmentType	15193037	\N	81	assessmentType	assessmentType	f	15193037	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1042	http://rdfdata.eionet.europa.eu/airquality/ontology/operationalActivityPeriod	2334484	\N	69	operationalActivityPeriod	operationalActivityPeriod	f	2334484	\N	\N	f	f	\N	104	\N	t	f	\N	\N	\N	t	f	f
1043	http://rdfdata.eionet.europa.eu/inspire-m/ontology/monitoringDate	1	\N	101	monitoringDate	monitoringDate	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1044	http://rdfdata.eionet.europa.eu/article17/generalreportachievements_trans	66	\N	100	generalreportachievements_trans	generalreportachievements_trans	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1045	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv#UniqueRoadId	182542	\N	145	UniqueRoadId	UniqueRoadId	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
1046	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#name	506	\N	138	name	name	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
1047	http://www.openlinksw.com/schemas/virtrdf#qmPredicateMap	2	\N	17	qmPredicateMap	qmPredicateMap	f	2	\N	\N	f	f	30	228	\N	t	f	\N	\N	\N	t	f	f
1048	http://rdfdata.eionet.europa.eu/msfd/ontology/responsibilities	283	\N	85	responsibilities	responsibilities	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1049	http://rdfdata.eionet.europa.eu/ippc/ontology/address	196	\N	116	address	address	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
1050	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_atlas_year	15	\N	100	generalreportnational_bird_atlas_year	generalreportnational_bird_atlas_year	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1051	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentMethodNS	1342	\N	69	assessmentMethodNS	assessmentMethodNS	f	0	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
1052	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_Precipitation_Mean	579	\N	86	Annual_Precipitation_Mean	Annual_Precipitation_Mean	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1053	http://cr.eionet.europa.eu/ontologies/contreg.rdf#feedbackStatus	230054	\N	82	feedbackStatus	feedbackStatus	f	0	\N	\N	f	f	248	\N	\N	t	f	\N	\N	\N	t	f	f
1054	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfLongTmpl	2	\N	17	qmfExistingShortOfLongTmpl	qmfExistingShortOfLongTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1055	http://rod.eionet.europa.eu/schema.rdf#eeaProgramme	5	\N	84	eeaProgramme	eeaProgramme	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1056	http://rdfdata.eionet.europa.eu/airquality/ontology/distanceJunctionUOM	104138	\N	69	distanceJunctionUOM	distanceJunctionUOM	f	104138	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1057	http://reference.eionet.europa.eu/aq/ontology/trafficEmissions	508444	\N	81	trafficEmissions	trafficEmissions	f	0	\N	\N	f	f	225	\N	\N	t	f	\N	\N	\N	t	f	f
1059	http://reference.eionet.europa.eu/aq/ontology/cadenceUnit	35856	\N	81	cadenceUnit	cadenceUnit	f	35856	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1060	http://rod.eionet.europa.eu/schema.rdf#guidelines	441	\N	84	guidelines	guidelines	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1061	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_longterm	50566	\N	83	broad_evaluation_longterm	broad_evaluation_longterm	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1062	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_magnitude_max	1304	\N	83	range_trend_magnitude_max	range_trend_magnitude_max	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1063	http://www.openlinksw.com/schemas/virtrdf#qmfSparqlEbvTmpl	29	\N	17	qmfSparqlEbvTmpl	qmfSparqlEbvTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1501	http://rdfdata.eionet.europa.eu/article17/generalreportsites_with_plans	22	\N	100	generalreportsites_with_plans	generalreportsites_with_plans	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1064	http://rdfdata.eionet.europa.eu/article17/ontology/season	115	\N	83	season	season	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1065	http://reference.eionet.europa.eu/aq/ontology/broader	70483	\N	81	broader	broader	f	70483	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
1066	http://rdfdata.eionet.europa.eu/article17/ontology/measurename	15858	\N	83	measurename	measurename	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1067	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNIncomingEstimated	520	\N	102	uwwNIncomingEstimated	uwwNIncomingEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1068	http://rdfdata.eionet.europa.eu/wise/ontology/Main_Infrastructures	326	\N	86	Main_Infrastructures	Main_Infrastructures	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1069	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwMethodWasteWaterTreated	8055	\N	102	uwwMethodWasteWaterTreated	uwwMethodWasteWaterTreated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1070	http://rdfdata.eionet.europa.eu/wise/ontology/OtherRelevantPollutantExemption	3627	\N	86	OtherRelevantPollutantExemption	OtherRelevantPollutantExemption	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1071	http://cr.eionet.europa.eu/ontologies/contreg.rdf#harvestedStatements	890353	\N	82	harvestedStatements	harvestedStatements	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1072	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNDischargeEstimated	520	\N	102	uwwNDischargeEstimated	uwwNDischargeEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1073	http://rdfdata.eionet.europa.eu/wise/ontology/FREQUENCY	48484	\N	86	FREQUENCY	FREQUENCY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1074	http://dd.eionet.europa.eu/property/hasProtectionTarget	815	\N	130	hasProtectionTarget	hasProtectionTarget	f	178	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1075	http://rdfdata.eionet.europa.eu/article17/generalreport/sitecode	10711	\N	118	sitecode	sitecode	f	10711	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1076	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaGIS	3082	\N	102	rcaGIS	rcaGIS	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1077	http://rod.eionet.europa.eu/schema.rdf#hasObligation	670	\N	84	hasObligation	hasObligation	f	670	\N	\N	f	f	215	15	\N	t	f	\N	\N	\N	t	f	f
1078	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#numberofinhabitants	456	\N	146	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
1080	http://rdfdata.eionet.europa.eu/airquality/ontology/measurementRegime	2121767	\N	69	measurementRegime	measurementRegime	f	2121767	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1081	http://www.snee.com/ns/epcategory	46	\N	133	epcategory	epcategory	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1082	http://rdfdata.eionet.europa.eu/airquality/ontology/distanceSourceUOM	598800	\N	69	distanceSourceUOM	distanceSourceUOM	f	598800	\N	\N	f	f	169	8	\N	t	f	\N	\N	\N	t	f	f
1083	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentMethods	559566	\N	69	assessmentMethods	assessmentMethods	f	559566	\N	\N	f	f	254	73	\N	t	f	\N	\N	\N	t	f	f
1084	http://reference.eionet.europa.eu/aq/ontology/reportingMetric	10368816	\N	81	reportingMetric	reportingMetric	f	10368816	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1085	http://reference.eionet.europa.eu/aq/ontology/designationPeriodEnd	81	\N	81	designationPeriodEnd	designationPeriodEnd	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1086	http://rdfdata.eionet.europa.eu/article17/ontology/location	19525	\N	83	location	location	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1087	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv#referenceyear	140681	\N	131	referenceyear	referenceyear	f	0	\N	\N	f	f	219	\N	\N	t	f	\N	\N	\N	t	f	f
1088	http://rod.eionet.europa.eu/schema.rdf#blockedByQA	46060	\N	84	blockedByQA	blockedByQA	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
1089	http://rdfdata.eionet.europa.eu/article17/generalreportmeasures_applied_number	44	\N	100	generalreportmeasures_applied_number	generalreportmeasures_applied_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1090	http://rdfdata.eionet.europa.eu/airquality/ontology/heatAndPowerProduction	3024	\N	69	heatAndPowerProduction	heatAndPowerProduction	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1091	http://rdfdata.eionet.europa.eu/article17/ontology/range_reasons_for_change_c	15195	\N	83	range_reasons_for_change_c	range_reasons_for_change_c	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1092	http://rod.eionet.europa.eu/schema.rdf#dataCustodian	7	\N	84	dataCustodian	dataCustodian	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1093	http://dd.eionet.europa.eu/tables/8286/rdf#Latitude_BW	33948	\N	132	Latitude_BW	Latitude_BW	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1094	http://reference.eionet.europa.eu/aq/ontology/unit	935516	\N	81	unit	unit	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1095	http://rdfdata.eionet.europa.eu/msfd/ontology/regionalCoorperation	9	\N	85	regionalCoorperation	regionalCoorperation	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1096	http://rdfs.org/ns/void#vocabulary	55	\N	16	vocabulary	vocabulary	f	55	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
1097	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2014.csv#Ctry_2	182542	\N	145	Ctry_2	Ctry_2	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
1098	http://rdfdata.eionet.europa.eu/waterbase/ontology/recordReported	10358	\N	95	recordReported	recordReported	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1099	http://rdfdata.eionet.europa.eu/article17/generalreportplans_under_prep	22	\N	100	generalreportplans_under_prep	generalreportplans_under_prep	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1100	http://rdfdata.eionet.europa.eu/airquality/ontology/measureType	25688	\N	69	measureType	measureType	f	25688	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1146	http://www.openlinksw.com/schemas/virtrdf#qmfName	130	\N	17	qmfName	qmfName	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1101	http://rdfdata.eionet.europa.eu/wise/ontology/ProtectedAreaCode	58203	\N	86	ProtectedAreaCode	ProtectedAreaCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1102	http://eunis.eea.europa.eu/rdf/schema.rdf#nationalLawReference	531	\N	107	nationalLawReference	nationalLawReference	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
1103	http://rdfdata.eionet.europa.eu/airquality/ontology/startYear	935	\N	69	startYear	startYear	f	935	\N	\N	f	f	126	59	\N	t	f	\N	\N	\N	t	f	f
1105	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indOrganicLoad	32	\N	102	indOrganicLoad	indOrganicLoad	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
1106	http://rdfdata.eionet.europa.eu/airquality/ontology/spatialScale	28142	\N	69	spatialScale	spatialScale	f	28142	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1107	http://www.w3.org/2004/02/skos/core#definition	274154	\N	4	definition	definition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1108	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwChlorination	35949	\N	102	uwwChlorination	uwwChlorination	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1109	http://rdfdata.eionet.europa.eu/ramon/ontology/migCode	5	\N	91	migCode	migCode	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
1110	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indNamePlant	257	\N	102	indNamePlant	indNamePlant	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
1111	http://reference.eionet.europa.eu/aq/ontology/assessmentMethodNS	27	\N	81	assessmentMethodNS	assessmentMethodNS	f	0	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
1112	http://www.openlinksw.com/schemas/virtrdf#qmfWrapDistinct	2	\N	17	qmfWrapDistinct	qmfWrapDistinct	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1113	http://rdfdata.eionet.europa.eu/article17/ontology/spa_population_unit	155	\N	83	spa_population_unit	spa_population_unit	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1114	http://rdfs.org/ns/void#uriSpace	3	\N	16	uriSpace	uriSpace	f	0	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
1115	http://rdfdata.eionet.europa.eu/airquality/ontology/name	3451993	\N	69	name	name	f	1918675	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1116	http://rdfdata.eionet.europa.eu/wise/ontology/QUANTITATIVE	118271	\N	86	QUANTITATIVE	QUANTITATIVE	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1117	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslReuseOthers	43	\N	102	mslReuseOthers	mslReuseOthers	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1118	http://rdfdata.eionet.europa.eu/eea/ontology/publishingCode	94	\N	88	publishingCode	publishingCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1119	http://rdfdata.eionet.europa.eu/ippc/ontology/prtrId	189	\N	116	prtrId	prtrId	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
1120	http://rdfdata.eionet.europa.eu/airquality/ontology/reportingMetric	1729358	\N	69	reportingMetric	reportingMetric	f	1729358	\N	\N	f	f	226	\N	\N	t	f	\N	\N	\N	t	f	f
1121	http://rdfdata.eionet.europa.eu/airquality/ontology/specification	437249	\N	69	specification	specification	f	437249	\N	\N	f	f	24	51	\N	t	f	\N	\N	\N	t	f	f
1122	http://www.w3.org/2002/07/owl#disjointWith	3	\N	7	disjointWith	disjointWith	f	3	\N	\N	f	f	201	201	\N	t	f	\N	\N	\N	t	f	f
1123	http://rdfdata.eionet.europa.eu/airquality/ontology/firstExceedanceYear	1536	\N	69	firstExceedanceYear	firstExceedanceYear	f	1536	\N	\N	f	f	208	59	\N	t	f	\N	\N	\N	t	f	f
1124	http://reference.eionet.europa.eu/aq/ontology/modelUsed	216767	\N	81	modelUsed	modelUsed	f	216767	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1125	http://rod.eionet.europa.eu/schema.rdf#nextdeadline	520	\N	84	nextdeadline	nextdeadline	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1126	http://rdfdata.eionet.europa.eu/article17/ontology/range_additional_info	370	\N	83	range_additional_info	range_additional_info	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1127	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggState	35097	\N	102	aggState	aggState	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1128	http://rdfdata.eionet.europa.eu/airquality/ontology/dataQualityReport	25410	\N	69	dataQualityReport	dataQualityReport	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
1129	http://dd.eionet.europa.eu/property/LatitudeMin	45	\N	130	LatitudeMin	LatitudeMin	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1130	http://reference.eionet.europa.eu/aq/ontology/caTelephone	1522	\N	81	caTelephone	caTelephone	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1131	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_method	135	\N	83	range_trend_method	range_trend_method	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1132	http://reference.eionet.europa.eu/aq/ontology/adjustmentSource	350	\N	81	adjustmentSource	adjustmentSource	f	350	\N	\N	f	f	129	8	\N	t	f	\N	\N	\N	t	f	f
1133	http://rdfdata.eionet.europa.eu/airquality/ontology/stationInfo	113310	\N	69	stationInfo	stationInfo	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
1134	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_population_op	6706	\N	83	complementary_favourable_population_op	complementary_favourable_population_op	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1135	http://rdfdata.eionet.europa.eu/eea/ontology/casnum	796	\N	88	casnum	casnum	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1136	http://rdfdata.eionet.europa.eu/airquality/ontology/resultNature	2365155	\N	69	resultNature	resultNature	f	2365155	\N	\N	f	f	233	\N	\N	t	f	\N	\N	\N	t	f	f
1137	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaParameterOther	5220	\N	102	rcaParameterOther	rcaParameterOther	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1138	http://reference.eionet.europa.eu/aq/ontology/beginPosition	935516	\N	81	beginPosition	beginPosition	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1139	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslWWReuseAgri	45	\N	102	mslWWReuseAgri	mslWWReuseAgri	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1140	http://reference.eionet.europa.eu/aq/ontology/EUStationCode	11142	\N	81	EUStationCode	EUStationCode	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1141	http://www.w3.org/2004/02/skos/core#narrower	29810	\N	4	narrower	narrower	f	18834	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1142	http://creativecommons.org/ns#license	177	\N	23	license	license	f	177	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1143	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#numberofinhabitants	472	\N	154	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
1144	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv#ReferenceDataSet	411027	\N	140	ReferenceDataSet	ReferenceDataSet	f	0	\N	\N	f	f	156	\N	\N	t	f	\N	\N	\N	t	f	f
1145	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_method	10652	\N	83	population_trend_method	population_trend_method	f	10497	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1147	http://rdfdata.eionet.europa.eu/wise/ontology/START_DATE	160	\N	86	START_DATE	START_DATE	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1502	http://rdfdata.eionet.europa.eu/airquality/ontology/dateEnteredIntoForce	19518	\N	69	dateEnteredIntoForce	dateEnteredIntoForce	f	0	\N	\N	f	f	151	\N	\N	t	f	\N	\N	\N	t	f	f
1148	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	80	182	\N	t	f	\N	\N	\N	t	f	f
1149	http://rod.eionet.europa.eu/schema.rdf#coordinator	94	\N	84	coordinator	coordinator	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1150	http://rdfdata.eionet.europa.eu/article17/ontology/score	8	\N	83	score	score	f	0	\N	\N	f	f	266	\N	\N	t	f	\N	\N	\N	t	f	f
1151	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_range_method	6287	\N	83	complementary_favourable_range_method	complementary_favourable_range_method	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1152	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucUwwName	36535	\N	102	aucUwwName	aucUwwName	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
1153	http://reference.eionet.europa.eu/aq/ontology/caEmail	1549	\N	81	caEmail	caEmail	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1154	http://rdfdata.eionet.europa.eu/inspire-m/ontology/memberState	1	\N	101	memberState	memberState	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1155	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_justification	2767	\N	83	coverage_justification	coverage_justification	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1156	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_magnitude_min	1272	\N	83	range_trend_magnitude_min	range_trend_magnitude_min	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1157	http://www.openlinksw.com/schemas/virtrdf#qmfIsBijection	47	\N	17	qmfIsBijection	qmfIsBijection	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1158	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/uniquerailid	9647	\N	87	uniquerailid	uniquerailid	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1159	http://dd.eionet.europa.eu/tables/8286/rdf#BWKey	24003	\N	132	BWKey	BWKey	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1160	http://purl.org/dc/terms/description	16352	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1161	http://rdfdata.eionet.europa.eu/waterbase/ontology/representativeStation	5566	\N	95	representativeStation	representativeStation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1162	http://reference.eionet.europa.eu/aq/ontology/operationActivityPeriodBegin	683	\N	81	operationActivityPeriodBegin	operationActivityPeriodBegin	f	0	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
1163	http://dd.eionet.europa.eu/property/exceedanceMetric	164	\N	130	exceedanceMetric	exceedanceMetric	f	34	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1164	http://cr.eionet.europa.eu/ontologies/contreg.rdf#byteSize	764764	\N	82	byteSize	byteSize	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1165	http://rod.eionet.europa.eu/schema.rdf#coordinatorUrl	31	\N	84	coordinatorUrl	coordinatorUrl	f	31	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1166	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_area_unknown	4436	\N	83	complementary_favourable_area_unknown	complementary_favourable_area_unknown	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1167	http://rdfs.org/ns/void#dataDump	83	\N	16	dataDump	dataDump	f	83	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
1168	http://rdfdata.eionet.europa.eu/airquality/ontology/resultQuality	681642	\N	69	resultQuality	resultQuality	f	681698	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
1169	http://reference.eionet.europa.eu/aq/ontology/procedure	1991452	\N	81	procedure	procedure	f	1991452	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1170	http://rdfdata.eionet.europa.eu/eea/ontology/name	1491	\N	88	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1171	http://rdfdata.eionet.europa.eu/article17/ontology/population_additional_method	1555	\N	83	population_additional_method	population_additional_method	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1172	http://rdfdata.eionet.europa.eu/airquality/ontology/assessment	222400	\N	69	assessment	assessment	f	222400	\N	\N	f	f	205	\N	\N	t	f	\N	\N	\N	t	f	f
1173	http://rdfdata.eionet.europa.eu/article17/generalreport/type-instrument	1165	\N	118	type-instrument	type-instrument	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1174	http://rod.eionet.europa.eu/schema.rdf#isTerminated	887	\N	84	isTerminated	isTerminated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1175	http://www.geonames.org/ontology#childrenFeatures	168	\N	70	childrenFeatures	childrenFeatures	f	168	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
1176	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#icaocode	92	\N	143	icaocode	icaocode	f	0	\N	\N	f	f	268	\N	\N	t	f	\N	\N	\N	t	f	f
1177	http://rdfdata.eionet.europa.eu/article17/generalreport/preparation	4115	\N	118	preparation	preparation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1178	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterbaseID	10358	\N	95	waterbaseID	waterbaseID	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1179	http://rdfdata.eionet.europa.eu/eurostat/property#iccs	3532	\N	155	iccs	iccs	f	3532	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
1180	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_assessment_trend	8966	\N	83	conclusion_assessment_trend	conclusion_assessment_trend	f	8966	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1181	http://rdfdata.eionet.europa.eu/article17/generalreportsac_marine_area	51	\N	100	generalreportsac_marine_area	generalreportsac_marine_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1182	http://reference.eionet.europa.eu/aq/ontology/environmentalObjective	760869	\N	81	environmentalObjective	environmentalObjective	f	760869	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1183	http://rdfdata.eionet.europa.eu/wise/ontology/SUB_CD	2403	\N	86	SUB_CD	SUB_CD	f	0	\N	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
1184	http://rod.eionet.europa.eu/schema.rdf#parentInstrument	40	\N	84	parentInstrument	parentInstrument	f	40	\N	\N	f	f	215	215	\N	t	f	\N	\N	\N	t	f	f
1186	http://reference.eionet.europa.eu/aq/ontology/operationActivityPeriodEnd	40	\N	81	operationActivityPeriodEnd	operationActivityPeriodEnd	f	0	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
1187	http://rdfdata.eionet.europa.eu/airquality/ontology/parameter	1015273	\N	69	parameter	parameter	f	1015273	\N	\N	f	f	36	195	\N	t	f	\N	\N	\N	t	f	f
1188	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaArt54Applied	5548	\N	102	rcaArt54Applied	rcaArt54Applied	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1189	http://purl.org/NET/scovo#dimension	8	\N	78	dimension	dimension	f	8	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1190	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv11_ActArea	1	\N	101	DSv11_ActArea	DSv11_ActArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1191	http://rdfdata.eionet.europa.eu/airquality/ontology/trafficSpeed	70859	\N	69	trafficSpeed	trafficSpeed	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1221	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_pressures	18683	\N	83	[Main coverage pressures (coverage_pressures)]	coverage_pressures	f	18683	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1192	http://rdfdata.eionet.europa.eu/airquality/ontology/timeExtensionExemption	30958	\N	69	timeExtensionExemption	timeExtensionExemption	f	30958	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1193	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rptMStateKey	52	\N	102	rptMStateKey	rptMStateKey	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1194	http://telegraphis.net/ontology/geography/geography#currency	246	\N	117	currency	currency	f	246	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
1195	http://rdfdata.eionet.europa.eu/wise/ontology/intCode	4	\N	86	intCode	intCode	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
1196	http://reference.eionet.europa.eu/aq/ontology/sampledFeature	40719	\N	81	sampledFeature	sampledFeature	f	40719	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1197	http://rdfdata.eionet.europa.eu/airquality/ontology/timeScale	25675	\N	69	timeScale	timeScale	f	25675	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1198	http://rdfdata.eionet.europa.eu/inspire-m/ontology/userRequest	37	\N	101	userRequest	userRequest	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
1199	http://rdfdata.eionet.europa.eu/airquality/ontology/locatorDesignator	1941231	\N	69	locatorDesignator	locatorDesignator	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1200	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv#UniqueRailID	5923	\N	142	UniqueRailID	UniqueRailID	f	0	\N	\N	f	f	218	\N	\N	t	f	\N	\N	\N	t	f	f
1201	http://www.openlinksw.com/schemas/virtrdf#qmfCmpFuncName	39	\N	17	qmfCmpFuncName	qmfCmpFuncName	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1202	http://rdfdata.eionet.europa.eu/ghg/ontology/commonName	4	\N	103	commonName	commonName	f	0	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
1203	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPercSecTreatment	3706	\N	102	aggPercSecTreatment	aggPercSecTreatment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1204	http://rdfdata.eionet.europa.eu/wise/ontology/Main_Aquifer_Type	1178	\N	86	Main_Aquifer_Type	Main_Aquifer_Type	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1205	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/uniqueagglomerationid	165	\N	87	uniqueagglomerationid	uniqueagglomerationid	f	0	\N	\N	f	f	269	\N	\N	t	f	\N	\N	\N	t	f	f
1206	http://xmlns.com/foaf/0.1/primaryTopic	177	\N	8	primaryTopic	primaryTopic	f	177	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1207	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_population_unknown	10759	\N	83	complementary_favourable_population_unknown	complementary_favourable_population_unknown	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1208	http://purl.org/linked-data/sdmx/2009/dimension#age	37642	\N	71	age	age	f	37642	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
1209	http://www.openlinksw.com/schemas/virtrdf#noInherit	56	\N	17	noInherit	noInherit	f	56	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1210	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaNIncomingMeasured	327	\N	102	rcaNIncomingMeasured	rcaNIncomingMeasured	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1211	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODIncomingMeasured	2478	\N	102	uwwBODIncomingMeasured	uwwBODIncomingMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1212	http://reference.eionet.europa.eu/aq/ontology/changeDescription	6556	\N	81	changeDescription	changeDescription	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
1213	http://rdfdata.eionet.europa.eu/article17/generalreportspa_terrestrial_area	15	\N	100	generalreportspa_terrestrial_area	generalreportspa_terrestrial_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1214	http://reference.eionet.europa.eu/aq/ontology/populationExposed	208370	\N	81	populationExposed	populationExposed	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1215	http://reference.eionet.europa.eu/aq/ontology/commentExceedanceFinal	7020	\N	81	commentExceedanceFinal	commentExceedanceFinal	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1216	http://reference.eionet.europa.eu/aq/ontology/dispersionLocal	1878	\N	81	dispersionLocal	dispersionLocal	f	1878	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1217	http://rdfdata.eionet.europa.eu/waterbase/ontology/rBDname	9242	\N	95	rBDname	rBDname	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1218	http://rdfdata.eionet.europa.eu/wise/ontology/NaturalBackgroundLevels	7354	\N	86	NaturalBackgroundLevels	NaturalBackgroundLevels	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1219	http://reference.eionet.europa.eu/aq/ontology/pollutants	29424	\N	81	pollutants	pollutants	f	29424	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1220	http://rdfdata.eionet.europa.eu/article17/generalreport/coverage	2512	\N	118	coverage	coverage	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1222	http://reference.eionet.europa.eu/aq/ontology/exposureExceedanceBase	216	\N	81	exposureExceedanceBase	exposureExceedanceBase	f	216	\N	\N	f	f	129	50	\N	t	f	\N	\N	\N	t	f	f
1223	http://reference.eionet.europa.eu/aq/ontology/responsibleParty	11374	\N	81	responsibleParty	responsibleParty	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1224	http://reference.eionet.europa.eu/aq/ontology/name	49347	\N	81	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1225	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	80	80	\N	t	f	\N	\N	\N	t	f	f
1226	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPrimaryTreatment	36010	\N	102	uwwPrimaryTreatment	uwwPrimaryTreatment	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1227	http://rdfdata.eionet.europa.eu/article17/generalreportcountry	51	\N	100	generalreportcountry	generalreportcountry	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1228	http://rdfdata.eionet.europa.eu/wise/ontology/GWB_MS_CD	25252	\N	86	GWB_MS_CD	GWB_MS_CD	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1229	http://rdfdata.eionet.europa.eu/airquality/ontology/publisher	4706	\N	69	publisher	publisher	f	0	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
1230	http://reference.eionet.europa.eu/aq/ontology/observingCapability	1054453	\N	81	observingCapability	observingCapability	f	1054453	\N	\N	f	f	\N	116	\N	t	f	\N	\N	\N	t	f	f
1231	http://rod.eionet.europa.eu/schema.rdf#typeInformation	2	\N	84	typeInformation	typeInformation	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1232	http://rdfdata.eionet.europa.eu/airquality/ontology/value	1258862	\N	69	value	value	f	818219	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1503	http://rod.eionet.europa.eu/schema.rdf#isEEAMember	69	\N	84	isEEAMember	isEEAMember	f	0	\N	\N	f	f	154	\N	\N	t	f	\N	\N	\N	t	f	f
1233	http://rdfdata.eionet.europa.eu/airquality/ontology/endLifespanVersion	228	\N	69	endLifespanVersion	endLifespanVersion	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1234	http://rdfdata.eionet.europa.eu/wise/ontology/RELATED_PROGRAMMES	235	\N	86	RELATED_PROGRAMMES	RELATED_PROGRAMMES	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1235	http://www.openlinksw.com/schemas/virtrdf#qmTableName	2	\N	17	qmTableName	qmTableName	f	0	\N	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
1236	http://rdfdata.eionet.europa.eu/msfd/ontology/country	283	\N	85	country	country	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1237	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_magnitude_max	2444	\N	83	population_trend_magnitude_max	population_trend_magnitude_max	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1238	http://reference.eionet.europa.eu/aq/ontology/datacapturePct	935591	\N	81	datacapturePct	datacapturePct	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1240	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi44	1	\N	101	NSi44	NSi44	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1241	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi45	1	\N	101	NSi45	NSi45	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1242	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi42	1	\N	101	NSi42	NSi42	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1243	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi43	1	\N	101	NSi43	NSi43	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1244	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_notevaluated	50566	\N	83	broad_evaluation_notevaluated	broad_evaluation_notevaluated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1245	http://rod.eionet.europa.eu/schema.rdf#clientCountry	65	\N	84	clientCountry	clientCountry	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
1246	http://rdfdata.eionet.europa.eu/article17/ontology/spa_population_max	2569	\N	83	spa_population_max	spa_population_max	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1247	http://rdfdata.eionet.europa.eu/article17/ontology/population_method	10661	\N	83	population_method	population_method	f	10515	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1248	http://purl.org/linked-data/sdmx/2009/measure#obsValue	217680	\N	156	obsValue	obsValue	f	0	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
1249	http://rdfdata.eionet.europa.eu/wise/ontology/OtherPressureDescription	406	\N	86	OtherPressureDescription	OtherPressureDescription	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1250	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv1_RelArea	1	\N	101	DSv1_RelArea	DSv1_RelArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1251	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggSewerOverflows_pe	2906	\N	102	aggSewerOverflows_pe	aggSewerOverflows_pe	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1252	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwOther	35949	\N	102	uwwOther	uwwOther	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1253	http://rdfdata.eionet.europa.eu/airquality/ontology/nationWideQualityAssurance	8028	\N	69	nationWideQualityAssurance	nationWideQualityAssurance	f	8028	\N	\N	f	f	176	78	\N	t	f	\N	\N	\N	t	f	f
1254	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_trend_long	2408	\N	83	habitat_trend_long	habitat_trend_long	f	2408	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1255	http://reference.eionet.europa.eu/aq/ontology/content	157238	\N	81	content	content	f	157238	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
1256	http://cr.eionet.europa.eu/ontologies/contreg.rdf#useInference	41	\N	82	useInference	useInference	f	0	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
1257	http://rdfdata.eionet.europa.eu/airquality/ontology/timeTable	1518	\N	69	timeTable	timeTable	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
1258	http://rdfdata.eionet.europa.eu/waterbase/ontology/nationalStationID	10358	\N	95	nationalStationID	nationalStationID	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1259	http://rdfdata.eionet.europa.eu/article17/generalreportsites_terrestrial_area	51	\N	100	generalreportsites_terrestrial_area	generalreportsites_terrestrial_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1260	http://telegraphis.net/ontology/measurement/measurement#quantityMeasured	246	\N	123	quantityMeasured	quantityMeasured	f	246	\N	\N	f	f	223	\N	\N	t	f	\N	\N	\N	t	f	f
1261	http://rdfdata.eionet.europa.eu/airquality/ontology/numericalExceedance	129809	\N	69	numericalExceedance	numericalExceedance	f	0	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
1262	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv11	1	\N	101	NSv11	NSv11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1263	http://rdfdata.eionet.europa.eu/article17/ontology/sources	20022	\N	83	sources	sources	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1264	http://rdfdata.eionet.europa.eu/airquality/ontology/supersedes	1	\N	69	supersedes	supersedes	f	1	\N	\N	f	f	178	249	\N	t	f	\N	\N	\N	t	f	f
1265	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv12	1	\N	101	NSv12	NSv12	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1266	http://rdfdata.eionet.europa.eu/airquality/ontology/sourceSectors	28135	\N	69	sourceSectors	sourceSectors	f	28135	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1267	http://purl.org/linked-data/cube#dataSet	217681	\N	73	dataSet	dataSet	f	217681	\N	\N	f	f	237	134	\N	t	f	\N	\N	\N	t	f	f
1268	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslSludgeProduction	52	\N	102	mslSludgeProduction	mslSludgeProduction	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1269	http://dd.eionet.europa.eu/property/inCountry	29398	\N	130	inCountry	inCountry	f	27711	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1270	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_area_min	4194	\N	83	natura2000_area_min	natura2000_area_min	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1271	http://rdfdata.eionet.europa.eu/eea/ontology/iso3	72	\N	88	iso3	iso3	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
1272	http://rdfdata.eionet.europa.eu/inspire-m/ontology/mdConformity	2	\N	101	mdConformity	mdConformity	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
1273	http://rdfdata.eionet.europa.eu/wise/ontology/UpwardTrend	24222	\N	86	UpwardTrend	UpwardTrend	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1274	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfUriTmpl	2	\N	17	qmfExistingShortOfUriTmpl	qmfExistingShortOfUriTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1275	http://rdfdata.eionet.europa.eu/article17/ontology/broad_evaluation_unknown	50566	\N	83	broad_evaluation_unknown	broad_evaluation_unknown	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1276	http://rdfdata.eionet.europa.eu/airquality/ontology/publication	4804	\N	69	publication	publication	f	4804	\N	\N	f	f	\N	75	\N	t	f	\N	\N	\N	t	f	f
1277	http://rdfdata.eionet.europa.eu/wise/ontology/SURVEIL	862	\N	86	SURVEIL	SURVEIL	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
1278	http://rdfdata.eionet.europa.eu/ippc/ontology/country	189	\N	116	country	country	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
1279	http://rdfdata.eionet.europa.eu/wise/ontology/LAT	40830	\N	86	LAT	LAT	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
1280	http://rdfdata.eionet.europa.eu/airquality/ontology/beginPosition	5269957	\N	69	beginPosition	beginPosition	f	0	\N	\N	f	f	177	\N	\N	t	f	\N	\N	\N	t	f	f
1281	http://rdfdata.eionet.europa.eu/article17/ontology/type_legal	50566	\N	83	type_legal	type_legal	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1282	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCapacity	33136	\N	102	uwwCapacity	uwwCapacity	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1283	http://reference.eionet.europa.eu/aq/ontology/durationNum	37235	\N	81	durationNum	durationNum	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1284	http://purl.org/dc/terms/requires	9	\N	5	requires	requires	f	9	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1285	http://www.w3.org/2004/02/skos/core#relatedMatch	2009	\N	4	relatedMatch	relatedMatch	f	1010	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1286	http://www.geonames.org/ontology#population	412	\N	70	population	population	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1287	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#source	4547	\N	110	source	source	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1288	http://discomap.eea.europa.eu//#Type	246	\N	148	Type	Type	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1289	http://rdfdata.eionet.europa.eu/airquality/ontology/valueUnit	244387	\N	69	valueUnit	valueUnit	f	244387	\N	\N	f	f	189	106	\N	t	f	\N	\N	\N	t	f	f
1290	http://www.geonames.org/ontology#alternateName	7825	\N	70	alternateName	alternateName	f	0	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
1291	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	1238	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1292	http://rdfdata.eionet.europa.eu/airquality/ontology/LAU	26546	\N	69	LAU	LAU	f	26546	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1293	http://www.openlinksw.com/schemas/virtrdf#qmfIsblankOfShortTmpl	31	\N	17	qmfIsblankOfShortTmpl	qmfIsblankOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1294	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv32	1	\N	101	NSv32	NSv32	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1295	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv33	1	\N	101	NSv33	NSv33	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1296	http://reference.eionet.europa.eu/aq/ontology/trafficVolume	3356	\N	81	trafficVolume	trafficVolume	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1297	http://rdfdata.eionet.europa.eu/airquality/ontology/featureOfInterest	2848312	\N	69	featureOfInterest	featureOfInterest	f	2848312	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1298	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv31	1	\N	101	NSv31	NSv31	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1299	http://rdfdata.eionet.europa.eu/airquality/ontology/adminUnit	1961552	\N	69	adminUnit	adminUnit	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1300	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv34	1	\N	101	NSv34	NSv34	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1301	http://rdfdata.eionet.europa.eu/article17/generalreportmemberstate	66	\N	100	generalreportmemberstate	generalreportmemberstate	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1302	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv35	1	\N	101	NSv35	NSv35	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1303	http://rdfdata.eionet.europa.eu/eea/ontology/maxy	202	\N	88	maxy	maxy	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
1304	http://www.w3.org/2004/02/skos/core#scopeNote	9199	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1305	http://rdfdata.eionet.europa.eu/eea/ontology/maxx	202	\N	88	maxx	maxx	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
1306	http://rod.eionet.europa.eu/schema.rdf#ecAccession	13	\N	84	ecAccession	ecAccession	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1307	http://rdfdata.eionet.europa.eu/airquality/ontology/measurementType	1925943	\N	69	measurementType	measurementType	f	1925943	\N	\N	f	f	179	8	\N	t	f	\N	\N	\N	t	f	f
1308	http://reference.eionet.europa.eu/aq/ontology/caIndividualName	1576	\N	81	caIndividualName	caIndividualName	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1309	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_method	2370	\N	83	population_trend_long_method	population_trend_long_method	f	2215	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1310	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpRemarks	3604	\N	102	dcpRemarks	dcpRemarks	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1311	http://rdfdata.eionet.europa.eu/wise/ontology/Max_Length	434	\N	86	Max_Length	Max_Length	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1312	http://rdfs.org/ns/void#linkPredicate	42	\N	16	linkPredicate	linkPredicate	f	42	\N	\N	f	f	149	\N	\N	t	f	\N	\N	\N	t	f	f
1313	http://rod.eionet.europa.eu/schema.rdf#ecEntryIntoForce	50	\N	84	ecEntryIntoForce	ecEntryIntoForce	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1314	http://reference.eionet.europa.eu/aq/ontology/detectionLimit	38644	\N	81	detectionLimit	detectionLimit	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1315	http://rdfdata.eionet.europa.eu/airquality/ontology/dataQuality	1925993	\N	69	dataQuality	dataQuality	f	1925993	\N	\N	f	f	179	193	\N	t	f	\N	\N	\N	t	f	f
1316	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#size	456	\N	146	size	size	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
1317	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indState	258	\N	102	indState	indState	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
1318	http://rdfdata.eionet.europa.eu/airquality/ontology/result	681642	\N	69	result	result	f	681642	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1319	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv21	1	\N	101	NSv21	NSv21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1363	http://purl.org/dc/elements/1.1/contributor	5	\N	6	contributor	contributor	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1504	http://rdfdata.eionet.europa.eu/article17/ontology/population_maximum_size	17270	\N	83	population_maximum_size	population_maximum_size	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1320	http://reference.eionet.europa.eu/aq/ontology/featureOfInterest	1054602	\N	81	featureOfInterest	featureOfInterest	f	1054569	\N	\N	f	f	116	202	\N	t	f	\N	\N	\N	t	f	f
1321	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv22	1	\N	101	NSv22	NSv22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1322	http://rdfdata.eionet.europa.eu/article17/ontology/spa_population_trend	150	\N	83	spa_population_trend	spa_population_trend	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1323	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv#Ctry_2	13546	\N	139	Ctry_2	Ctry_2	f	0	\N	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
1324	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv23	1	\N	101	NSv23	NSv23	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1325	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwSecondaryTreatment	36010	\N	102	uwwSecondaryTreatment	uwwSecondaryTreatment	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1326	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODDischargeEstimated	520	\N	102	uwwCODDischargeEstimated	uwwCODDischargeEstimated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1327	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#airportname	114	\N	153	airportname	airportname	f	0	\N	\N	f	f	261	\N	\N	t	f	\N	\N	\N	t	f	f
1328	http://www.openlinksw.com/schemas/virtrdf#qmfSqlvalTmpl	53	\N	17	qmfSqlvalTmpl	qmfSqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1329	http://reference.eionet.europa.eu/aq/ontology/kerbDistance	30271	\N	81	kerbDistance	kerbDistance	f	0	\N	\N	f	f	202	\N	\N	t	f	\N	\N	\N	t	f	f
1330	http://rdfdata.eionet.europa.eu/eea/ontology/memberOf	170	\N	88	memberOf	memberOf	f	170	\N	\N	f	f	38	39	\N	t	f	\N	\N	\N	t	f	f
1331	http://rdfdata.eionet.europa.eu/airquality/ontology/temporalResolution	26906	\N	69	temporalResolution	temporalResolution	f	26906	\N	\N	f	f	257	2	\N	t	f	\N	\N	\N	t	f	f
1332	http://www.w3.org/2002/07/owl#complementOf	5	\N	7	complementOf	complementOf	f	5	\N	\N	f	f	201	201	\N	t	f	\N	\N	\N	t	f	f
1333	http://rod.eionet.europa.eu/schema.rdf#productKeyword	1	\N	84	productKeyword	productKeyword	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1334	http://telegraphis.net/ontology/geography/geography#isoNumeric	246	\N	117	isoNumeric	isoNumeric	f	0	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
1335	http://rdfdata.eionet.europa.eu/article17/ontology/population_minimum_size	17006	\N	83	population_minimum_size	population_minimum_size	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1336	http://rdfdata.eionet.europa.eu/wise/ontology/SUBSITES_METHOD	2936	\N	86	SUBSITES_METHOD	SUBSITES_METHOD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1337	http://rdfdata.eionet.europa.eu/article17/ontology/typicalSpecies	90650	\N	83	typicalSpecies	typicalSpecies	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1338	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#name	456	\N	146	name	name	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
1339	http://rdfdata.eionet.europa.eu/wise/ontology/Natural	1030	\N	86	Natural	Natural	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1340	http://rdfdata.eionet.europa.eu/article17/ontology/hasRegionalReport	24219	\N	83	hasRegionalReport	hasRegionalReport	f	24219	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1341	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfSqlvalTmpl	2	\N	17	qmfExistingShortOfSqlvalTmpl	qmfExistingShortOfSqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1342	http://www.openlinksw.com/schemas/virtrdf#qmfValRange-rvrDatatype	7	\N	17	qmfValRange-rvrDatatype	qmfValRange-rvrDatatype	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1343	http://creativecommons.org/ns#attributionName	170	\N	23	attributionName	attributionName	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
1344	http://www.w3.org/2003/06/sw-vocab-status/ns#term_status	3	\N	79	term_status	term_status	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
1345	http://rdfdata.eionet.europa.eu/wise/ontology/forQualityElement	18263	\N	86	forQualityElement	forQualityElement	f	18263	\N	\N	f	f	\N	89	\N	t	f	\N	\N	\N	t	f	f
1346	http://rdfdata.eionet.europa.eu/uwwtd/ontology/hasNUTS	105793	\N	102	hasNUTS	hasNUTS	f	105793	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
1347	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv#Ctry_2	223717	\N	149	Ctry_2	Ctry_2	f	0	\N	\N	f	f	160	\N	\N	t	f	\N	\N	\N	t	f	f
1348	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv43	1	\N	101	NSv43	NSv43	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1349	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv44	1	\N	101	NSv44	NSv44	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1350	http://reference.eionet.europa.eu/aq/ontology/inserted	935797	\N	81	inserted	inserted	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1352	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv41	1	\N	101	NSv41	NSv41	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1353	http://dd.eionet.europa.eu/tables/8286/rdf#BWaterCat	33847	\N	132	BWaterCat	BWaterCat	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1354	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv42	1	\N	101	NSv42	NSv42	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1355	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv45	1	\N	101	NSv45	NSv45	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1356	http://rdfdata.eionet.europa.eu/wise/ontology/CountryCode	5053	\N	86	CountryCode	CountryCode	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1357	http://rdfdata.eionet.europa.eu/article17/ontology/justification	1988	\N	83	justification	justification	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1358	http://rdfdata.eionet.europa.eu/eea/ontology/areaKM	84	\N	88	areaKM	areaKM	f	0	\N	\N	f	f	136	\N	\N	t	f	\N	\N	\N	t	f	f
1359	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conZIP	52	\N	102	conZIP	conZIP	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
1360	http://rdfdata.eionet.europa.eu/waterbase/ontology/alkalinityLevel	2471	\N	95	alkalinityLevel	alkalinityLevel	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1361	http://rdfdata.eionet.europa.eu/airquality/ontology/levelOfConcentration	889	\N	69	levelOfConcentration	levelOfConcentration	f	0	\N	\N	f	f	114	\N	\N	t	f	\N	\N	\N	t	f	f
1362	http://rdfdata.eionet.europa.eu/wise/ontology/ChemicalStatusValue	24222	\N	86	ChemicalStatusValue	ChemicalStatusValue	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1364	http://reference.eionet.europa.eu/aq/ontology/roadLength	359764	\N	81	roadLength	roadLength	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1365	http://xmlns.com/foaf/0.1/topic	25	\N	8	topic	topic	f	25	\N	\N	f	f	251	\N	\N	t	f	\N	\N	\N	t	f	f
1505	http://rdfs.org/ns/void#feature	25	\N	16	feature	feature	f	25	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
1366	http://www.openlinksw.com/schemas/virtrdf#qmvATables	8	\N	17	qmvATables	qmvATables	f	8	\N	\N	f	f	228	199	\N	t	f	\N	\N	\N	t	f	f
1367	http://rod.eionet.europa.eu/schema.rdf#issuedBy	49	\N	84	issuedBy	issuedBy	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1368	http://rdfdata.eionet.europa.eu/article17/generalreport/management-plan	5130	\N	118	management-plan	management-plan	f	5130	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
1370	http://rdfdata.eionet.europa.eu/wise/ontology/OUT_OF_RBD	17922	\N	86	OUT_OF_RBD	OUT_OF_RBD	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1371	http://reference.eionet.europa.eu/aq/ontology/exceedanceBase	381	\N	81	exceedanceBase	exceedanceBase	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1372	http://rdfdata.eionet.europa.eu/article17/generalreportreintroduction_period	178	\N	100	generalreportreintroduction_period	generalreportreintroduction_period	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1373	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBadPerformance	32485	\N	102	uwwBadPerformance	uwwBadPerformance	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1374	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaState	5548	\N	102	rcaState	rcaState	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1375	http://rod.eionet.europa.eu/schema.rdf#reportingFrequencyDetail	45	\N	84	reportingFrequencyDetail	reportingFrequencyDetail	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1376	http://rdfdata.eionet.europa.eu/article17/generalreportCompensationMeasure	187	\N	100	generalreportCompensationMeasure	generalreportCompensationMeasure	f	187	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1377	http://rdfdata.eionet.europa.eu/article17/ontology/location_outside	50566	\N	83	location_outside	location_outside	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1378	http://rdfdata.eionet.europa.eu/airquality/ontology/otherMeasurementEquipment	175	\N	69	otherMeasurementEquipment	otherMeasurementEquipment	f	0	\N	\N	f	f	244	\N	\N	t	f	\N	\N	\N	t	f	f
1379	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2014.csv#CountryCode	9351	\N	152	CountryCode	CountryCode	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
1380	http://rdfdata.eionet.europa.eu/wise/ontology/Max_Width	432	\N	86	Max_Width	Max_Width	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1381	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_magnitude_max	1629	\N	83	range_trend_long_magnitude_max	range_trend_long_magnitude_max	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1382	http://dd.eionet.europa.eu/tables/8286/rdf#RBDSUID	23876	\N	132	RBDSUID	RBDSUID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1383	http://rdfdata.eionet.europa.eu/airquality/ontology/title	441954	\N	69	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1384	http://rdfdata.eionet.europa.eu/article17/generalreportsitename	187	\N	100	generalreportsitename	generalreportsitename	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1385	http://rdfdata.eionet.europa.eu/msfd/ontology/competentAuthorityNameNL	280	\N	85	competentAuthorityNameNL	competentAuthorityNameNL	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1386	http://rod.eionet.europa.eu/schema.rdf#period	45158	\N	84	period	period	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
1387	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpNotAffect	4673	\N	102	dcpNotAffect	dcpNotAffect	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1388	http://reference.eionet.europa.eu/aq/ontology/change	6273	\N	81	change	change	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
1389	http://rdfdata.eionet.europa.eu/wise/ontology/Associated_Aquatic_Ecosystems	787	\N	86	Associated_Aquatic_Ecosystems	Associated_Aquatic_Ecosystems	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1390	http://rdfdata.eionet.europa.eu/airquality/ontology/competentAuthority	32288	\N	69	competentAuthority	competentAuthority	f	32288	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1391	http://www.openlinksw.com/schemas/virtrdf#qmfIsStable	47	\N	17	qmfIsStable	qmfIsStable	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1392	http://rdfdata.eionet.europa.eu/article17/ontology/sensitive_species	6998	\N	83	sensitive_species	sensitive_species	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1393	http://www.w3.org/1999/xhtml/vocab#first	1	\N	74	first	first	f	1	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
1394	http://rod.eionet.europa.eu/schema.rdf#isEEAPrimary	671	\N	84	isEEAPrimary	isEEAPrimary	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1395	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentType	2258905	\N	69	assessmentType	assessmentType	f	2258905	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1396	http://rdfdata.eionet.europa.eu/wise/ontology/CHEM_OPERAT	119749	\N	86	CHEM_OPERAT	CHEM_OPERAT	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1397	http://rdfdata.eionet.europa.eu/article17/ontology/spa_population_min	2829	\N	83	spa_population_min	spa_population_min	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1398	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_trend	10500	\N	83	habitat_trend	habitat_trend	f	10500	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1399	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggSewerOverflows_m3	2913	\N	102	aggSewerOverflows_m3	aggSewerOverflows_m3	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1400	http://eunis.eea.europa.eu/rdf/schema.rdf#nationalCategory	567	\N	107	nationalCategory	nationalCategory	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
1401	http://rdfdata.eionet.europa.eu/wise/ontology/Main_Infrastructures_Purpose	171	\N	86	Main_Infrastructures_Purpose	Main_Infrastructures_Purpose	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1402	http://www.w3.org/2004/02/skos/core#hasTopConcept	4153	\N	4	hasTopConcept	hasTopConcept	f	4153	\N	\N	f	f	33	8	\N	t	f	\N	\N	\N	t	f	f
1403	http://rdfdata.eionet.europa.eu/article17/ontology/speciescode	26609	\N	83	speciescode	speciescode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1404	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long	4007	\N	83	range_trend_long	range_trend_long	f	3842	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1405	http://www.openlinksw.com/schemas/virtrdf#version	1	\N	17	version	version	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1406	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwSpecification	2000	\N	102	uwwSpecification	uwwSpecification	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1424	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_assessment	23771	\N	83	[Conclusion on overall assessment (conclusion_assessment)]	conclusion_assessment	f	15016	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1407	http://rdfdata.eionet.europa.eu/airquality/ontology/meteoParams	94481	\N	69	meteoParams	meteoParams	f	94481	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
1408	http://reference.eionet.europa.eu/aq/ontology/operationalActivityBegin	84054	\N	81	operationalActivityBegin	operationalActivityBegin	f	0	\N	\N	f	f	249	\N	\N	t	f	\N	\N	\N	t	f	f
1409	http://reference.eionet.europa.eu/aq/ontology/analyticalTechnique	25209	\N	81	analyticalTechnique	analyticalTechnique	f	25209	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1410	http://rdfs.org/ns/void#statItem	8	\N	16	statItem	statItem	f	8	\N	\N	f	f	250	\N	\N	t	f	\N	\N	\N	t	f	f
1411	http://rdfdata.eionet.europa.eu/article17/ontology/published	33972	\N	83	published	published	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1412	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWaterBodyReferenceDate	4831	\N	102	dcpWaterBodyReferenceDate	dcpWaterBodyReferenceDate	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1413	http://reference.eionet.europa.eu/aq/ontology/samplingPoint	935516	\N	81	samplingPoint	samplingPoint	f	935516	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1415	http://rdfdata.eionet.europa.eu/wise/ontology/IRRIGATION	19505	\N	86	IRRIGATION	IRRIGATION	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
1416	http://reference.eionet.europa.eu/aq/ontology/caOrganisationName	1474	\N	81	caOrganisationName	caOrganisationName	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1417	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#annualtraffic	114	\N	153	annualtraffic	annualtraffic	f	0	\N	\N	f	f	261	\N	\N	t	f	\N	\N	\N	t	f	f
1418	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_population_method	7147	\N	83	natura2000_population_method	natura2000_population_method	f	7147	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
1419	http://rdfdata.eionet.europa.eu/article17/generalreportlocation_number	178	\N	100	generalreportlocation_number	generalreportlocation_number	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1420	http://reference.eionet.europa.eu/aq/ontology/networkType	470	\N	81	networkType	networkType	f	470	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
1421	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_area_max	4184	\N	83	natura2000_area_max	natura2000_area_max	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1422	http://rdfdata.eionet.europa.eu/wise/ontology/id	5053	\N	86	id	id	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1423	http://www.openlinksw.com/schemas/virtrdf#qmfCustomString1	12	\N	17	qmfCustomString1	qmfCustomString1	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1425	http://www.openlinksw.com/schemas/virtrdf#qmfColumnCount	31	\N	17	qmfColumnCount	qmfColumnCount	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1426	http://rdfdata.eionet.europa.eu/uwwtd/ontology/repVersion	22	\N	102	repVersion	repVersion	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1427	http://rdfdata.eionet.europa.eu/waterbase/ontology/referenceStation	6750	\N	95	referenceStation	referenceStation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1428	http://rdfdata.eionet.europa.eu/airquality/ontology/ResponsibleParty	2	\N	69	ResponsibleParty	ResponsibleParty	f	2	\N	\N	f	f	82	78	\N	t	f	\N	\N	\N	t	f	f
1429	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpWFDRBDReferenceDate	2336	\N	102	dcpWFDRBDReferenceDate	dcpWFDRBDReferenceDate	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1430	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long_method	1196	\N	83	coverage_trend_long_method	coverage_trend_long_method	f	1196	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1431	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_GW_Level_Amplitude_Mean	285	\N	86	Annual_GW_Level_Amplitude_Mean	Annual_GW_Level_Amplitude_Mean	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1432	http://rdfdata.eionet.europa.eu/airquality/ontology/shapefileLink	5665	\N	69	shapefileLink	shapefileLink	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1433	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterColourAverage	1274	\N	95	waterColourAverage	waterColourAverage	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1434	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_quality	102	\N	83	range_trend_quality	range_trend_quality	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1435	http://rdfdata.eionet.europa.eu/article17/generalreportproject_title	187	\N	100	generalreportproject_title	generalreportproject_title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1436	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi11	1	\N	101	NSi11	NSi11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1437	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2016.csv#numberofinhabitants	506	\N	138	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	162	\N	\N	t	f	\N	\N	\N	t	f	f
1438	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi12	1	\N	101	NSi12	NSi12	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1439	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumAllServ	1	\N	101	NSv_NumAllServ	NSv_NumAllServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1440	http://rdfdata.eionet.europa.eu/wise/ontology/SITE_METHOD	2938	\N	86	SITE_METHOD	SITE_METHOD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1441	http://reference.eionet.europa.eu/aq/ontology/modelAssessmentMetadata	1141379	\N	81	modelAssessmentMetadata	modelAssessmentMetadata	f	1141379	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1442	http://www.snee.com/ns/epinfluences	46	\N	133	epinfluences	epinfluences	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1443	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2016.csv#ctrycd	114	\N	153	ctrycd	ctrycd	f	0	\N	\N	f	f	261	\N	\N	t	f	\N	\N	\N	t	f	f
1444	http://telegraphis.net/ontology/geography/geography#landArea	246	\N	117	landArea	landArea	f	246	\N	\N	f	f	213	223	\N	t	f	\N	\N	\N	t	f	f
1445	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDisposalIncineration	43	\N	102	mslDisposalIncineration	mslDisposalIncineration	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1446	http://rdfdata.eionet.europa.eu/eea/ontology/category	45	\N	88	category	category	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1447	http://www.w3.org/2000/01/rdf-schema#subClassOf	548	\N	2	subClassOf	subClassOf	f	548	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1448	http://rdfdata.eionet.europa.eu/eea/ontology/dpsirOrder	5	\N	88	dpsirOrder	dpsirOrder	f	0	\N	\N	f	f	142	\N	\N	t	f	\N	\N	\N	t	f	f
1449	http://rdfdata.eionet.europa.eu/article17/ontology/national_plan_adopted	114	\N	83	national_plan_adopted	national_plan_adopted	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1489	http://rdfdata.eionet.europa.eu/wise/ontology/forCountry	258	\N	86	forCountry	forCountry	f	258	\N	\N	f	f	246	212	\N	t	f	\N	\N	\N	t	f	f
1450	http://rdfdata.eionet.europa.eu/article17/ontology/measures_taken	811	\N	83	measures_taken	measures_taken	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1451	http://rdfdata.eionet.europa.eu/wise/ontology/PressuresAndImpacts	25252	\N	86	PressuresAndImpacts	PressuresAndImpacts	f	25252	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1452	http://rdfdata.eionet.europa.eu/airquality/ontology/otherEquipment	98294	\N	69	otherEquipment	otherEquipment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1548	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv13_ActArea	1	\N	101	DSv13_ActArea	DSv13_ActArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1453	http://reference.eionet.europa.eu/aq/ontology/stationInfo	3814	\N	81	stationInfo	stationInfo	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1454	http://rdfdata.eionet.europa.eu/ramon/ontology/inSection	975	\N	91	inSection	inSection	f	975	\N	\N	f	f	259	161	\N	t	f	\N	\N	\N	t	f	f
1455	http://reference.eionet.europa.eu/aq/ontology/assessment	110446	\N	81	assessment	assessment	f	110446	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1456	http://rdfdata.eionet.europa.eu/article17/ontology/threat	95587	\N	83	threat	threat	f	95587	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1457	http://www.w3.org/ns/adms#status	205886	\N	80	status	status	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1458	http://rdfdata.eionet.europa.eu/article17/ontology/further_information	809	\N	83	further_information	further_information	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1459	http://reference.eionet.europa.eu/aq/ontology/hasDeclaration	6398376	\N	81	hasDeclaration	hasDeclaration	f	6398376	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1460	http://dd.eionet.europa.eu/property/isNotationsEqualIdentifiers	209	\N	130	isNotationsEqualIdentifiers	isNotationsEqualIdentifiers	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
1461	http://rdfdata.eionet.europa.eu/airquality/ontology/natural	4536	\N	69	natural	natural	f	4536	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1462	http://dd.eionet.europa.eu/tables/8286/rdf#WBName	26913	\N	132	WBName	WBName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1463	http://rdfdata.eionet.europa.eu/waterbase/ontology/forRBD	9510	\N	95	forRBD	forRBD	f	9510	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1464	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucMethodPercEnteringUWWTP	30099	\N	102	aucMethodPercEnteringUWWTP	aucMethodPercEnteringUWWTP	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
1465	http://rdfdata.eionet.europa.eu/airquality/ontology/agriculture	3024	\N	69	agriculture	agriculture	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1466	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_area	3466	\N	83	complementary_favourable_area	complementary_favourable_area	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1467	http://reference.eionet.europa.eu/aq/ontology/exceedanceAdjustment	331	\N	81	exceedanceAdjustment	exceedanceAdjustment	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1468	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Airports_v2013.csv#AirportName	91	\N	150	AirportName	AirportName	f	0	\N	\N	f	f	165	\N	\N	t	f	\N	\N	\N	t	f	f
1469	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi33	1	\N	101	NSi33	NSi33	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1470	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi34	1	\N	101	NSi34	NSi34	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1471	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi31	1	\N	101	NSi31	NSi31	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1472	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi32	1	\N	101	NSi32	NSi32	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1473	http://rdfdata.eionet.europa.eu/ramon/ontology/hasNace	75	\N	91	hasNace	hasNace	f	75	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
1474	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSi35	1	\N	101	NSi35	NSi35	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1475	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Length_M	5149	\N	128	Length_M	Length_M	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
1476	http://rdfdata.eionet.europa.eu/airquality/ontology/telephoneVoice	1870505	\N	69	telephoneVoice	telephoneVoice	f	0	\N	\N	f	f	145	\N	\N	t	f	\N	\N	\N	t	f	f
1477	http://cr.eionet.europa.eu/ontologies/contreg.rdf#feedbackMessage	230054	\N	82	feedbackMessage	feedbackMessage	f	0	\N	\N	f	f	248	\N	\N	t	f	\N	\N	\N	t	f	f
1478	http://rdfdata.eionet.europa.eu/wise/ontology/Urban_Areas	568	\N	86	Urban_Areas	Urban_Areas	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1480	http://www.geonames.org/ontology#parentADM1	4	\N	70	parentADM1	parentADM1	f	4	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
1481	http://rdfdata.eionet.europa.eu/article17/ontology/other_relevant_information	6975	\N	83	other_relevant_information	other_relevant_information	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1482	http://reference.eionet.europa.eu/aq/ontology/documentation	27665	\N	81	documentation	documentation	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1483	http://rdfdata.eionet.europa.eu/eurostat/property#landuse	70822	\N	155	landuse	landuse	f	70822	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
1484	http://rdfdata.eionet.europa.eu/airquality/ontology/sampledFeature	757606	\N	69	sampledFeature	sampledFeature	f	757606	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1485	http://www.openlinksw.com/schemas/virtrdf#qmfExistingShortOfTypedsqlvalTmpl	2	\N	17	qmfExistingShortOfTypedsqlvalTmpl	qmfExistingShortOfTypedsqlvalTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1486	http://cr.eionet.europa.eu/project/noise/MRoad_2010_2015.csv#CountryCode	411027	\N	140	CountryCode	CountryCode	f	0	\N	\N	f	f	156	\N	\N	t	f	\N	\N	\N	t	f	f
1487	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslDischargePipelines	22	\N	102	mslDischargePipelines	mslDischargePipelines	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1488	http://rdfdata.eionet.europa.eu/airquality/ontology/address	1961462	\N	69	address	address	f	1961462	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1506	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_area_trend	1376	\N	83	conclusion_area_trend	conclusion_area_trend	f	1376	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1507	http://reference.eionet.europa.eu/aq/ontology/heightFacades	1750	\N	81	heightFacades	heightFacades	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1508	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwRemarks	7456	\N	102	uwwRemarks	uwwRemarks	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1509	http://rdfdata.eionet.europa.eu/airquality/ontology/pollutants	304346	\N	69	pollutants	pollutants	f	304346	\N	\N	f	f	\N	53	\N	t	f	\N	\N	\N	t	f	f
1510	http://reference.eionet.europa.eu/aq/ontology/otherMeasurementMethod	1761	\N	81	otherMeasurementMethod	otherMeasurementMethod	f	0	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1511	http://reference.eionet.europa.eu/aq/ontology/stationClassification	956051	\N	81	stationClassification	stationClassification	f	956051	\N	\N	f	f	225	\N	\N	t	f	\N	\N	\N	t	f	f
1512	http://rdfdata.eionet.europa.eu/airquality/ontology/dispersionLocal	51956	\N	69	dispersionLocal	dispersionLocal	f	51956	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1513	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_range_op	10789	\N	83	complementary_favourable_range_op	complementary_favourable_range_op	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1514	http://rdfdata.eionet.europa.eu/wise/ontology/No_of_Horizon	1153	\N	86	No_of_Horizon	No_of_Horizon	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1515	http://rdfdata.eionet.europa.eu/article17/generalreportimpact	3	\N	100	generalreportimpact	generalreportimpact	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1516	http://rdfdata.eionet.europa.eu/airquality/ontology/changeDescription	17345	\N	69	changeDescription	changeDescription	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1517	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Country	123830	\N	147	Country	Country	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
1518	http://dd.eionet.europa.eu/property/minimumValue	1194	\N	130	minimumValue	minimumValue	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1519	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggPercPrimTreatment	3700	\N	102	aggPercPrimTreatment	aggPercPrimTreatment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1520	http://rdfdata.eionet.europa.eu/article17/ontology/type_oneoff	50566	\N	83	type_oneoff	type_oneoff	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1521	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indConditions	28	\N	102	indConditions	indConditions	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
1522	http://rdfdata.eionet.europa.eu/wise/ontology/CAPACITY	4354	\N	86	CAPACITY	CAPACITY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1523	http://rdfdata.eionet.europa.eu/article17/generalreport/coherence-measures	25	\N	118	coherence-measures	coherence-measures	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
1524	http://reference.eionet.europa.eu/aq/ontology/buildingDistance	37618	\N	81	buildingDistance	buildingDistance	f	0	\N	\N	f	f	202	\N	\N	t	f	\N	\N	\N	t	f	f
1525	http://rdfdata.eionet.europa.eu/uwwtd/ontology/repSituationAt	52	\N	102	repSituationAt	repSituationAt	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1526	http://purl.org/linked-data/api/vocab#definition	1	\N	98	definition	definition	f	1	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
1527	http://rdfdata.eionet.europa.eu/waterbase/ontology/fluxStation	3435	\N	95	fluxStation	fluxStation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1528	http://telegraphis.net/ontology/geography/geography#onContinent	246	\N	117	onContinent	onContinent	f	246	\N	\N	f	f	213	\N	\N	t	f	\N	\N	\N	t	f	f
1529	http://rod.eionet.europa.eu/schema.rdf#instrumentURL	213	\N	84	instrumentURL	instrumentURL	f	213	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1531	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2012.csv#uniqueagglomerationid	456	\N	146	uniqueagglomerationid	uniqueagglomerationid	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
1532	http://www.openlinksw.com/schemas/virtrdf#qmfTypeminTmpl	39	\N	17	qmfTypeminTmpl	qmfTypeminTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1533	http://rdfdata.eionet.europa.eu/article17/generalreportprotection_of_species	66	\N	100	generalreportprotection_of_species	generalreportprotection_of_species	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1534	http://rdfdata.eionet.europa.eu/wise/ontology/SignificantPresureTypes	17094	\N	86	SignificantPresureTypes	SignificantPresureTypes	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1535	http://reference.eionet.europa.eu/aq/ontology/mediaMonitored	75759	\N	81	mediaMonitored	mediaMonitored	f	75759	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1536	http://rdfdata.eionet.europa.eu/airquality/ontology/inletHeight	1499269	\N	69	inletHeight	inletHeight	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
1537	http://rdfdata.eionet.europa.eu/article17/ontology/pressure	94736	\N	83	pressure	pressure	f	94736	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1538	http://rdfdata.eionet.europa.eu/airquality/ontology/content	6850405	\N	69	content	content	f	6850405	\N	\N	f	f	12	\N	\N	t	f	\N	\N	\N	t	f	f
1539	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_area_method	2543	\N	83	complementary_favourable_area_method	complementary_favourable_area_method	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1540	http://reference.eionet.europa.eu/aq/ontology/observationVerification	935591	\N	81	observationVerification	observationVerification	f	935591	\N	\N	f	f	88	8	\N	t	f	\N	\N	\N	t	f	f
1541	http://rdfdata.eionet.europa.eu/wise/ontology/Main_Recharge_Source	1085	\N	86	Main_Recharge_Source	Main_Recharge_Source	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1542	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2013.csv#CountryCode	13546	\N	139	CountryCode	CountryCode	f	0	\N	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
1543	http://rdfdata.eionet.europa.eu/wise/ontology/VerticalOrientation	5078	\N	86	VerticalOrientation	VerticalOrientation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1544	http://www.geonames.org/ontology#neighbour	14	\N	70	neighbour	neighbour	f	14	\N	\N	f	f	258	258	\N	t	f	\N	\N	\N	t	f	f
1545	http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#acronymLabel	840	\N	110	acronymLabel	acronymLabel	f	0	\N	\N	f	f	239	\N	\N	t	f	\N	\N	\N	t	f	f
1546	http://rdfdata.eionet.europa.eu/article17/ontology/common_speciesname	12927	\N	83	common_speciesname	common_speciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1549	http://www.geonames.org/ontology#nearbyFeatures	2	\N	70	nearbyFeatures	nearbyFeatures	f	2	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
1550	http://rdfdata.eionet.europa.eu/airquality/ontology/contact	1961437	\N	69	contact	contact	f	1961437	\N	\N	f	f	78	145	\N	t	f	\N	\N	\N	t	f	f
1551	http://rdfdata.eionet.europa.eu/airquality/ontology/urbanBackground	1512	\N	69	urbanBackground	urbanBackground	f	1512	\N	\N	f	f	124	74	\N	t	f	\N	\N	\N	t	f	f
1552	http://rdfdata.eionet.europa.eu/wise/ontology/PARAMETER_CD	145250	\N	86	PARAMETER_CD	PARAMETER_CD	f	0	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
1553	http://www.openlinksw.com/schemas/virtrdf#qmfUriIdOffset	39	\N	17	qmfUriIdOffset	qmfUriIdOffset	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1554	http://dd.eionet.europa.eu/tables/8286/rdf#NWUnitID	19765	\N	132	NWUnitID	NWUnitID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1555	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_magnitude_max	70	\N	83	coverage_trend_magnitude_max	coverage_trend_magnitude_max	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1556	http://dd.eionet.europa.eu/property/version	209	\N	130	version	version	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
1557	http://rod.eionet.europa.eu/schema.rdf#reportingFrequency	49	\N	84	reportingFrequency	reportingFrequency	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1558	http://www.w3.org/2004/02/skos/core#broadMatch	133659	\N	4	broadMatch	broadMatch	f	132553	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1559	http://reference.eionet.europa.eu/aq/ontology/exposureExceedanceFinal	32850	\N	81	exposureExceedanceFinal	exposureExceedanceFinal	f	32850	\N	\N	f	f	129	166	\N	t	f	\N	\N	\N	t	f	f
1560	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	7694	\N	2	subPropertyOf	subPropertyOf	f	7694	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1561	http://rdfdata.eionet.europa.eu/airquality/ontology/referenceImplementation	1496	\N	69	referenceImplementation	referenceImplementation	f	0	\N	\N	f	f	208	\N	\N	t	f	\N	\N	\N	t	f	f
1562	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv2	1	\N	101	DSv2	DSv2	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1563	http://rod.eionet.europa.eu/schema.rdf#eeaStrategicArea	1	\N	84	eeaStrategicArea	eeaStrategicArea	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1564	http://cr.eionet.europa.eu/ontologies/contreg.rdf#xmlSchema	181126	\N	82	xmlSchema	xmlSchema	f	181126	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1565	http://a9.com/-/spec/opensearch/1.1/startIndex	1	\N	157	startIndex	startIndex	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
1566	http://cr.eionet.europa.eu/ontologies/contreg.rdf#hasFeedback	230056	\N	82	hasFeedback	hasFeedback	f	230056	\N	\N	f	f	\N	248	\N	t	f	\N	\N	\N	t	f	f
1567	http://a9.com/-/spec/opensearch/1.1/itemsPerPage	1	\N	157	itemsPerPage	itemsPerPage	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
1568	http://www.w3.org/2004/02/skos/core#example	400	\N	4	example	example	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1569	http://rdfdata.eionet.europa.eu/inspire-m/ontology/download	125	\N	101	download	download	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
1570	http://rdfdata.eionet.europa.eu/article17/ontology/population_date	17103	\N	83	population_date	population_date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1571	http://rdfdata.eionet.europa.eu/wise/ontology/ADDITIONAL_REQS	7528	\N	86	ADDITIONAL_REQS	ADDITIONAL_REQS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1572	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#size	472	\N	154	size	size	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
1573	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_other_information	9024	\N	83	complementary_other_information	complementary_other_information	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1574	http://rod.eionet.europa.eu/schema.rdf#clientAddress	66	\N	84	clientAddress	clientAddress	f	0	\N	\N	f	f	214	\N	\N	t	f	\N	\N	\N	t	f	f
1575	http://rdfdata.eionet.europa.eu/article17/ontology/forMeasure	50566	\N	83	forMeasure	forMeasure	f	50566	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1576	http://purl.org/dc/elements/1.1/title	278	\N	6	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1577	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2013.csv#ctrycd	92	\N	143	ctrycd	ctrycd	f	0	\N	\N	f	f	268	\N	\N	t	f	\N	\N	\N	t	f	f
1579	http://rdfdata.eionet.europa.eu/article17/ontology/plan	121	\N	83	plan	plan	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1580	http://rdfdata.eionet.europa.eu/ramon/ontology/maxX	1778	\N	91	maxX	maxX	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1581	http://www.openlinksw.com/schemas/virtrdf#qmfUriOfShortTmpl	45	\N	17	qmfUriOfShortTmpl	qmfUriOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1582	http://rdfdata.eionet.europa.eu/ramon/ontology/maxY	1778	\N	91	maxY	maxY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1583	http://rdfdata.eionet.europa.eu/airquality/ontology/classification	31132	\N	69	classification	classification	f	31132	\N	\N	f	f	127	8	\N	t	f	\N	\N	\N	t	f	f
1584	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggMethodWithoutTreatment	18566	\N	102	aggMethodWithoutTreatment	aggMethodWithoutTreatment	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1585	http://www.openlinksw.com/schemas/virtrdf#qmfShortTmpl	31	\N	17	qmfShortTmpl	qmfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1587	http://reference.eionet.europa.eu/aq/ontology/residentPopulation	2234	\N	81	residentPopulation	residentPopulation	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1588	http://rdfdata.eionet.europa.eu/inspire-m/ontology/hasSpatialDataSet	208	\N	101	hasSpatialDataSet	hasSpatialDataSet	f	208	\N	\N	f	f	\N	69	\N	t	f	\N	\N	\N	t	f	f
1589	http://cr.eionet.europa.eu/project/noise/MAir_2010_2015.csv#CountryCode	225	\N	135	CountryCode	CountryCode	f	0	\N	\N	f	f	159	\N	\N	t	f	\N	\N	\N	t	f	f
1590	http://eunis.eea.europa.eu/rdf/schema.rdf#nationalLawAgency	565	\N	107	nationalLawAgency	nationalLawAgency	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
1591	http://rdfdata.eionet.europa.eu/airquality/ontology/surfaceMember	18674	\N	69	surfaceMember	surfaceMember	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1592	http://rdfdata.eionet.europa.eu/wise/ontology/TypeOfAssociation	19631	\N	86	TypeOfAssociation	TypeOfAssociation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1593	http://www.snee.com/ns/epavailable-for	46	\N	133	epavailable-for	epavailable-for	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1594	http://rdfdata.eionet.europa.eu/airquality/ontology/residentPopulationYear	27973	\N	69	residentPopulationYear	residentPopulationYear	f	27973	\N	\N	f	f	180	59	\N	t	f	\N	\N	\N	t	f	f
1595	http://rdfdata.eionet.europa.eu/eea/ontology/forCountry	404	\N	88	forCountry	forCountry	f	404	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1596	http://dd.eionet.europa.eu/property/aggregationProcess	163	\N	130	aggregationProcess	aggregationProcess	f	31	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1597	http://www.openlinksw.com/schemas/virtrdf#qmvFText	2	\N	17	qmvFText	qmvFText	f	2	\N	\N	f	f	228	31	\N	t	f	\N	\N	\N	t	f	f
1598	http://rdfdata.eionet.europa.eu/wise/ontology/QE_CD	18263	\N	86	QE_CD	QE_CD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1599	http://eunis.eea.europa.eu/rdf/schema.rdf#description	1221	\N	107	description	description	f	0	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
1600	http://rdfdata.eionet.europa.eu/wise/ontology/FREQ_METHOD	6352	\N	86	FREQ_METHOD	FREQ_METHOD	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1601	http://rdfdata.eionet.europa.eu/airquality/ontology/reason	14029	\N	69	reason	reason	f	14029	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
1602	http://rdfdata.eionet.europa.eu/article17/generalreportnational_bird_redlist_title	15	\N	100	generalreportnational_bird_redlist_title	generalreportnational_bird_redlist_title	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1603	http://reference.eionet.europa.eu/aq/ontology/closed	3966	\N	81	closed	closed	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1604	http://rdfdata.eionet.europa.eu/airquality/ontology/reductionOfEmissions	25693	\N	69	reductionOfEmissions	reductionOfEmissions	f	25693	\N	\N	f	f	127	52	\N	t	f	\N	\N	\N	t	f	f
1605	http://rdfdata.eionet.europa.eu/airquality/ontology/unitsSystem	244387	\N	69	unitsSystem	unitsSystem	f	244387	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
1607	http://reference.eionet.europa.eu/aq/ontology/designationPeriod	1628	\N	81	designationPeriod	designationPeriod	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1608	http://purl.org/dc/terms/replaces	2942485	\N	5	replaces	replaces	f	2933653	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1609	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslReuseSoilAgriculture	50	\N	102	mslReuseSoilAgriculture	mslReuseSoilAgriculture	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1610	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long	867	\N	83	coverage_trend_long	coverage_trend_long	f	867	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1611	http://dd.eionet.europa.eu/tables/8286/rdf#Coordsys_BW	30512	\N	132	Coordsys_BW	Coordsys_BW	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1612	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwInformation	13358	\N	102	uwwInformation	uwwInformation	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1613	http://rdfdata.eionet.europa.eu/airquality/ontology/journalCitation	234	\N	69	journalCitation	journalCitation	f	234	\N	\N	f	f	151	115	\N	t	f	\N	\N	\N	t	f	f
1614	http://dd.eionet.europa.eu/tables/8286/rdf#AccessKey	33925	\N	132	AccessKey	AccessKey	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1615	http://rdfdata.eionet.europa.eu/airquality/ontology/webLink	4411	\N	69	webLink	webLink	f	0	\N	\N	f	f	75	\N	\N	t	f	\N	\N	\N	t	f	f
1616	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaPDischargedCalculated	3	\N	102	rcaPDischargedCalculated	rcaPDischargedCalculated	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1617	http://rdfdata.eionet.europa.eu/inspire-m/ontology/structureCompliance	87	\N	101	structureCompliance	structureCompliance	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
1618	http://rdfdata.eionet.europa.eu/wise/ontology/ChemicalStatus	24222	\N	86	ChemicalStatus	ChemicalStatus	f	24222	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1619	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Comment	123830	\N	147	Comment	Comment	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
1620	http://rdfdata.eionet.europa.eu/waterbase/ontology/countryCode	10358	\N	95	countryCode	countryCode	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1621	http://cr.eionet.europa.eu/ontologies/contreg.rdf#firstSeen	806367	\N	82	firstSeen	firstSeen	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1623	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv_Num	1	\N	101	DSv_Num	DSv_Num	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1624	http://rdfdata.eionet.europa.eu/article17/generalreport/forCountry	25	\N	118	forCountry	forCountry	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
1625	http://reference.eionet.europa.eu/aq/ontology/objectiveType	10368813	\N	81	objectiveType	objectiveType	f	10368813	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
1626	http://www.openlinksw.com/schemas/virtrdf#qmvGeo	2	\N	17	qmvGeo	qmvGeo	f	2	\N	\N	f	f	228	31	\N	t	f	\N	\N	\N	t	f	f
1627	http://rdfdata.eionet.europa.eu/airquality/ontology/detectionLimitUOM	1877847	\N	69	detectionLimitUOM	detectionLimitUOM	f	1877797	\N	\N	f	f	193	8	\N	t	f	\N	\N	\N	t	f	f
1628	http://reference.eionet.europa.eu/aq/ontology/inspireId	504194	\N	81	inspireId	inspireId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1629	http://rdfdata.eionet.europa.eu/airquality/ontology/mainEmissionSources	912876	\N	69	mainEmissionSources	mainEmissionSources	f	912876	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
1630	http://rdfdata.eionet.europa.eu/ramon/ontology/hasCapital	36	\N	91	hasCapital	hasCapital	f	36	\N	\N	f	f	212	\N	\N	t	f	\N	\N	\N	t	f	f
1631	http://rdfdata.eionet.europa.eu/airquality/ontology/identifier	2704	\N	69	identifier	identifier	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
1632	http://rdfdata.eionet.europa.eu/airquality/ontology/observingCapability	2367115	\N	69	observingCapability	observingCapability	f	2367115	\N	\N	f	f	\N	233	\N	t	f	\N	\N	\N	t	f	f
1633	http://rdfdata.eionet.europa.eu/airquality/ontology/namespace	6429203	\N	69	namespace	namespace	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
1634	http://www.openlinksw.com/schemas/virtrdf#qmMatchingFlags	2	\N	17	qmMatchingFlags	qmMatchingFlags	f	2	\N	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
1635	http://rdfdata.eionet.europa.eu/uwwtd/ontology/indDateCompiliance	32	\N	102	indDateCompiliance	indDateCompiliance	f	0	\N	\N	f	f	260	\N	\N	t	f	\N	\N	\N	t	f	f
1606	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend	7096	\N	83	[Area trend (coverage_trend)]	coverage_trend	f	4430	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1636	http://rdfdata.eionet.europa.eu/wise/ontology/WB_CD	114979	\N	86	WB_CD	WB_CD	f	0	\N	\N	f	f	241	\N	\N	t	f	\N	\N	\N	t	f	f
1637	http://rdfdata.eionet.europa.eu/inspire-m/ontology/MDv2_DS	1	\N	101	MDv2_DS	MDv2_DS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1638	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_trend_long_period	3184	\N	83	habitat_trend_long_period	habitat_trend_long_period	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1639	http://rdfdata.eionet.europa.eu/article17/generalreportmeasures_setout_perc	44	\N	100	generalreportmeasures_setout_perc	generalreportmeasures_setout_perc	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1640	http://rdfdata.eionet.europa.eu/wise/ontology/ChemicalExemptionType	4414	\N	86	ChemicalExemptionType	ChemicalExemptionType	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1641	http://reference.eionet.europa.eu/aq/ontology/mainEmissionSources	454343	\N	81	mainEmissionSources	mainEmissionSources	f	454343	\N	\N	f	f	225	8	\N	t	f	\N	\N	\N	t	f	f
1642	http://rdfdata.eionet.europa.eu/airquality/ontology/environmentalObjective	1737846	\N	69	environmentalObjective	environmentalObjective	f	1737846	\N	\N	f	f	\N	226	\N	t	f	\N	\N	\N	t	f	f
1643	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_method	133	\N	83	range_trend_long_method	range_trend_long_method	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1644	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	8690	\N	2	isDefinedBy	isDefinedBy	f	8690	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1645	http://dd.eionet.europa.eu/property/recommendedUnit	1846	\N	130	recommendedUnit	recommendedUnit	f	1839	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1646	http://rdfdata.eionet.europa.eu/wise/ontology/SITES_AFFECTED	2953	\N	86	SITES_AFFECTED	SITES_AFFECTED	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1647	http://rdfdata.eionet.europa.eu/airquality/ontology/baselineScenario	935	\N	69	baselineScenario	baselineScenario	f	935	\N	\N	f	f	126	143	\N	t	f	\N	\N	\N	t	f	f
1648	http://rdfdata.eionet.europa.eu/wise/ontology/RBDNameNL	202	\N	86	RBDNameNL	RBDNameNL	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
1649	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aucPercEnteringUWWTP	36469	\N	102	aucPercEnteringUWWTP	aucPercEnteringUWWTP	f	0	\N	\N	f	f	210	\N	\N	t	f	\N	\N	\N	t	f	f
1650	http://reference.eionet.europa.eu/aq/ontology/airqualityValue	935750	\N	81	airqualityValue	airqualityValue	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1651	http://rdfdata.eionet.europa.eu/wise/ontology/NAME	28925	\N	86	NAME	NAME	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1652	http://rdfdata.eionet.europa.eu/airquality/ontology/legalBasis	28817	\N	69	legalBasis	legalBasis	f	28817	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1653	http://dd.eionet.europa.eu/property/statusModified	205888	\N	130	statusModified	statusModified	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1654	http://reference.eionet.europa.eu/aq/ontology/open	11718	\N	81	open	open	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1655	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#uniqueagglomerationid	472	\N	154	uniqueagglomerationid	uniqueagglomerationid	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
1699	http://rod.eionet.europa.eu/schema.rdf#isFlagged	671	\N	84	isFlagged	isFlagged	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1656	http://rdfdata.eionet.europa.eu/airquality/ontology/spatialResolution	26681	\N	69	spatialResolution	spatialResolution	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
1657	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#Region	123830	\N	147	Region	Region	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
1658	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpState	36450	\N	102	dcpState	dcpState	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1659	http://rdfdata.eionet.europa.eu/ramon/ontology/startdate	2646	\N	91	startdate	startdate	f	0	\N	\N	f	f	212	\N	\N	t	f	\N	\N	\N	t	f	f
1660	http://rdfdata.eionet.europa.eu/wise/ontology/CATEGORY	8888	\N	86	CATEGORY	CATEGORY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1661	http://rdfdata.eionet.europa.eu/airquality/ontology/measurementEquipment	726817	\N	69	measurementEquipment	measurementEquipment	f	726817	\N	\N	f	f	179	244	\N	t	f	\N	\N	\N	t	f	f
1662	http://rdfdata.eionet.europa.eu/airquality/ontology/commercialAndResidential	3024	\N	69	commercialAndResidential	commercialAndResidential	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1663	http://rdfdata.eionet.europa.eu/wise/ontology/CommentValueStatusProtArea	19679	\N	86	CommentValueStatusProtArea	CommentValueStatusProtArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1664	http://rdfdata.eionet.europa.eu/airquality/ontology/shipping	3024	\N	69	shipping	shipping	f	3024	\N	\N	f	f	\N	52	\N	t	f	\N	\N	\N	t	f	f
1665	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conPhone	58	\N	102	conPhone	conPhone	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
1666	http://reference.eionet.europa.eu/aq/ontology/samplingpoint_lon	935516	\N	81	samplingpoint_lon	samplingpoint_lon	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1667	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_population_unit	5652	\N	83	natura2000_population_unit	natura2000_population_unit	f	5652	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
1668	http://rdfdata.eionet.europa.eu/eea/ontology/booleanValue	4	\N	88	booleanValue	booleanValue	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1669	http://rdfdata.eionet.europa.eu/article17/ontology/type_recurrent	50566	\N	83	type_recurrent	type_recurrent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1670	http://cr.eionet.europa.eu/ontologies/contreg.rdf#hasFolder	80	\N	82	hasFolder	hasFolder	f	80	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1671	http://www.openlinksw.com/schemas/virtrdf#qmvTableName	8	\N	17	qmvTableName	qmvTableName	f	0	\N	\N	f	f	228	\N	\N	t	f	\N	\N	\N	t	f	f
1672	http://rdfdata.eionet.europa.eu/article17/generalreport/surveillance-system	25	\N	118	surveillance-system	surveillance-system	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
1673	http://rdfdata.eionet.europa.eu/airquality/ontology/boundedBy	750	\N	69	boundedBy	boundedBy	f	750	\N	\N	f	f	\N	198	\N	t	f	\N	\N	\N	t	f	f
1674	http://rdfdata.eionet.europa.eu/wise/ontology/SignificantPressureTypes	1108	\N	86	SignificantPressureTypes	SignificantPressureTypes	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1675	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_magnitude_ci	652	\N	83	population_trend_magnitude_ci	population_trend_magnitude_ci	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1676	http://reference.eionet.europa.eu/aq/ontology/altitude	9772	\N	81	altitude	altitude	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1677	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPIncomingCalculated	4268	\N	102	uwwPIncomingCalculated	uwwPIncomingCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1678	http://reference.eionet.europa.eu/aq/ontology/exceedanceFinal	110160	\N	81	exceedanceFinal	exceedanceFinal	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1680	http://rdfdata.eionet.europa.eu/article17/ontology/speciesauthor	21373	\N	83	speciesauthor	speciesauthor	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1681	http://rod.eionet.europa.eu/schema.rdf#reportingFrequencyMonths	554	\N	84	reportingFrequencyMonths	reportingFrequencyMonths	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1682	http://www.openlinksw.com/schemas/virtrdf#qmfSubFormatForRefs	2	\N	17	qmfSubFormatForRefs	qmfSubFormatForRefs	f	2	\N	\N	f	f	29	29	\N	t	f	\N	\N	\N	t	f	f
1683	http://purl.org/linked-data/api/vocab#items	1	\N	98	items	items	f	1	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
1684	http://purl.org/dc/elements/1.1/creator	4	\N	6	creator	creator	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1685	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2016.csv#UniqueRoadID	140681	\N	131	UniqueRoadID	UniqueRoadID	f	0	\N	\N	f	f	219	\N	\N	t	f	\N	\N	\N	t	f	f
1686	http://reference.eionet.europa.eu/aq/ontology/samplingPointAssessmentMetadata	13806107	\N	81	samplingPointAssessmentMetadata	samplingPointAssessmentMetadata	f	13806107	\N	\N	f	f	186	249	\N	t	f	\N	\N	\N	t	f	f
1687	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpName	36422	\N	102	dcpName	dcpName	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1688	http://rdfdata.eionet.europa.eu/airquality/ontology/dataQualityDescription	25552	\N	69	dataQualityDescription	dataQualityDescription	f	0	\N	\N	f	f	257	\N	\N	t	f	\N	\N	\N	t	f	f
1689	http://purl.org/dc/terms/issued	753652	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1690	http://reference.eionet.europa.eu/aq/ontology/observationValidity	935524	\N	81	observationValidity	observationValidity	f	935524	\N	\N	f	f	88	8	\N	t	f	\N	\N	\N	t	f	f
1691	http://rdfdata.eionet.europa.eu/article17/ontology/measure	34708	\N	83	measure	measure	f	34708	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1692	http://reference.eionet.europa.eu/aq/ontology/areaExceedanceBase	1462	\N	81	areaExceedanceBase	areaExceedanceBase	f	1462	\N	\N	f	f	129	187	\N	t	f	\N	\N	\N	t	f	f
1693	http://rdfdata.eionet.europa.eu/wise/ontology/Arable_Land	581	\N	86	Arable_Land	Arable_Land	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1694	http://rdfdata.eionet.europa.eu/wise/ontology/CommentChemicalStatusValue	3181	\N	86	CommentChemicalStatusValue	CommentChemicalStatusValue	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1695	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_magnitude_min	81	\N	83	coverage_trend_magnitude_min	coverage_trend_magnitude_min	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1696	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_long_period	941	\N	83	coverage_trend_long_period	coverage_trend_long_period	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1697	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODIncomingMeasured	2501	\N	102	uwwCODIncomingMeasured	uwwCODIncomingMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1698	http://rdfdata.eionet.europa.eu/article17/ontology/population_quality	5539	\N	83	population_quality	population_quality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1743	http://purl.org/dc/terms/license	85	\N	5	license	license	f	85	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1700	http://rdfdata.eionet.europa.eu/waterbase/ontology/subsiteLocation	386	\N	95	subsiteLocation	subsiteLocation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1701	http://rdfdata.eionet.europa.eu/wise/ontology/Overlying_Strata	491	\N	86	Overlying_Strata	Overlying_Strata	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1702	http://rdfdata.eionet.europa.eu/article17/ontology/country	9817	\N	83	country	country	f	9776	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1703	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv#CountryCode	1124	\N	151	CountryCode	CountryCode	f	0	\N	\N	f	f	217	\N	\N	t	f	\N	\N	\N	t	f	f
1704	http://www.openlinksw.com/schemas/virtrdf#qsMatchingFlags	2	\N	17	qsMatchingFlags	qsMatchingFlags	f	2	\N	\N	f	f	171	\N	\N	t	f	\N	\N	\N	t	f	f
1705	http://rdfdata.eionet.europa.eu/wise/ontology/NO_SITES_DW	550	\N	86	NO_SITES_DW	NO_SITES_DW	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
1706	http://dd.eionet.europa.eu/tables/8286/rdf#BWName	33949	\N	132	BWName	BWName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1707	http://dd.eionet.europa.eu/property/mandatoryUnit	650	\N	130	mandatoryUnit	mandatoryUnit	f	8	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1708	http://www.openlinksw.com/schemas/virtrdf#qmfSuperFormats	98	\N	17	qmfSuperFormats	qmfSuperFormats	f	98	\N	\N	f	f	29	54	\N	t	f	\N	\N	\N	t	f	f
1709	http://rdfdata.eionet.europa.eu/wise/ontology/international	202	\N	86	international	international	f	0	\N	\N	f	f	133	\N	\N	t	f	\N	\N	\N	t	f	f
1710	http://rdfdata.eionet.europa.eu/airquality/ontology/code	27228	\N	69	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1711	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpNUTS	36127	\N	102	dcpNUTS	dcpNUTS	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1712	http://rdfdata.eionet.europa.eu/article17/generalreport/reintroduction-of-species	1	\N	118	reintroduction-of-species	reintroduction-of-species	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1713	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNDischargeMeasured	2408	\N	102	uwwNDischargeMeasured	uwwNDischargeMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1714	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPDischargeCalculated	4316	\N	102	uwwPDischargeCalculated	uwwPDischargeCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1715	http://rdfdata.eionet.europa.eu/uwwtd/ontology/repReportedPeriod	52	\N	102	repReportedPeriod	repReportedPeriod	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1716	http://www.geonames.org/ontology#featureCode	416	\N	70	featureCode	featureCode	f	416	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1717	http://purl.org/dc/elements/1.1/format	129	\N	6	format	format	f	0	\N	\N	f	f	216	\N	\N	t	f	\N	\N	\N	t	f	f
1759	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwWasteWaterTreated	8638	\N	102	uwwWasteWaterTreated	uwwWasteWaterTreated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1718	http://reference.eionet.europa.eu/aq/ontology/designationPeriodBegin	1575	\N	81	designationPeriodBegin	designationPeriodBegin	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1719	http://rdfdata.eionet.europa.eu/ghg/ontology/formula	6	\N	103	formula	formula	f	0	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
1720	http://www.openlinksw.com/schemas/virtrdf#qmObjectMap	2	\N	17	qmObjectMap	qmObjectMap	f	2	\N	\N	f	f	30	228	\N	t	f	\N	\N	\N	t	f	f
1721	http://rdfdata.eionet.europa.eu/airquality/ontology/samplingEquipment	214805	\N	69	samplingEquipment	samplingEquipment	f	214805	\N	\N	f	f	179	77	\N	t	f	\N	\N	\N	t	f	f
1722	http://reference.eionet.europa.eu/aq/ontology/assessmentMethods	408460	\N	81	assessmentMethods	assessmentMethods	f	408460	\N	\N	f	f	\N	186	\N	t	f	\N	\N	\N	t	f	f
1723	http://rdfdata.eionet.europa.eu/article17/generalreportmeasures_applied_perc	44	\N	100	generalreportmeasures_applied_perc	generalreportmeasures_applied_perc	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1724	http://www.openlinksw.com/schemas/virtrdf#qmf01blankOfShortTmpl	2	\N	17	qmf01blankOfShortTmpl	qmf01blankOfShortTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1726	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggExistMaintenancePlan	5518	\N	102	aggExistMaintenancePlan	aggExistMaintenancePlan	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1727	http://dd.eionet.europa.eu/property/userModified	209	\N	130	userModified	userModified	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
1728	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2014.csv#ctrycd	472	\N	154	ctrycd	ctrycd	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
1729	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwOtherTreatment	36008	\N	102	uwwOtherTreatment	uwwOtherTreatment	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1730	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggHaveRegistrationSystem	5501	\N	102	aggHaveRegistrationSystem	aggHaveRegistrationSystem	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1731	http://rdfdata.eionet.europa.eu/wise/ontology/OtherImpactDescription	262	\N	86	OtherImpactDescription	OtherImpactDescription	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1732	http://rdfdata.eionet.europa.eu/airquality/ontology/industrialEmissions	484066	\N	69	industrialEmissions	industrialEmissions	f	0	\N	\N	f	f	169	\N	\N	t	f	\N	\N	\N	t	f	f
1733	http://rdfdata.eionet.europa.eu/eea/ontology/hasMember	170	\N	88	hasMember	hasMember	f	170	\N	\N	f	f	39	38	\N	t	f	\N	\N	\N	t	f	f
1734	http://rdfdata.eionet.europa.eu/article17/generalreportgeneral_info	44	\N	100	generalreportgeneral_info	generalreportgeneral_info	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1735	http://rdfdata.eionet.europa.eu/wise/ontology/QA_datatype_errors	75	\N	86	QA_datatype_errors	QA_datatype_errors	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1736	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/reportingentityuniquecode	53977	\N	87	reportingentityuniquecode	reportingentityuniquecode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1737	http://purl.org/dc/elements/1.1/identifier	52	\N	6	identifier	identifier	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
1738	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslWWReuseInd	45	\N	102	mslWWReuseInd	mslWWReuseInd	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1739	http://cr.eionet.europa.eu/ontologies/contreg.rdf#hasAttachment	37953	\N	82	hasAttachment	hasAttachment	f	37953	\N	\N	f	f	248	\N	\N	t	f	\N	\N	\N	t	f	f
1740	http://cr.eionet.europa.eu/ontologies/contreg.rdf#userSaveTime	5	\N	82	userSaveTime	userSaveTime	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1741	http://rdfdata.eionet.europa.eu/airquality/ontology/objectiveType	1729356	\N	69	objectiveType	objectiveType	f	1729356	\N	\N	f	f	226	8	\N	t	f	\N	\N	\N	t	f	f
1742	http://rod.eionet.europa.eu/schema.rdf#coverageNote	9465	\N	84	coverageNote	coverageNote	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
1744	http://rdfdata.eionet.europa.eu/article17/ontology/name	418	\N	83	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1745	http://reference.eionet.europa.eu/aq/ontology/observingTimeBegin	1729	\N	81	observingTimeBegin	observingTimeBegin	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
1746	http://dd.eionet.europa.eu/tables/8286/rdf#RBDSUName	23883	\N	132	RBDSUName	RBDSUName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1747	http://discomap.eea.europa.eu//#Description	218	\N	148	Description	Description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1748	http://dd.eionet.europa.eu/tables/8286/rdf#Closed	33843	\N	132	Closed	Closed	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1749	http://rdfdata.eionet.europa.eu/article17/generalreportsites_marine_number	51	\N	100	generalreportsites_marine_number	generalreportsites_marine_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1750	http://rdfdata.eionet.europa.eu/article17/ontology/typical_species_method	4427	\N	83	typical_species_method	typical_species_method	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1751	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPRemoval	36008	\N	102	uwwPRemoval	uwwPRemoval	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1752	http://rdfdata.eionet.europa.eu/airquality/ontology/phenomenonTime	483641	\N	69	phenomenonTime	phenomenonTime	f	483641	\N	\N	f	f	36	177	\N	t	f	\N	\N	\N	t	f	f
1753	http://rod.eionet.europa.eu/schema.rdf#helpdeskMail	7	\N	84	helpdeskMail	helpdeskMail	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1754	http://rdfdata.eionet.europa.eu/airquality/ontology/deductionAssessmentMethod	192230	\N	69	deductionAssessmentMethod	deductionAssessmentMethod	f	192230	\N	\N	f	f	196	197	\N	t	f	\N	\N	\N	t	f	f
1755	http://reference.eionet.europa.eu/aq/ontology/predecessor	432	\N	81	predecessor	predecessor	f	432	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1756	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2013.csv#CountryCode	223717	\N	149	CountryCode	CountryCode	f	0	\N	\N	f	f	160	\N	\N	t	f	\N	\N	\N	t	f	f
1757	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggOtherMeasures	27509	\N	102	aggOtherMeasures	aggOtherMeasures	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1758	http://rdfdata.eionet.europa.eu/wise/ontology/LinkTerrestrialEcosystems	9216	\N	86	LinkTerrestrialEcosystems	LinkTerrestrialEcosystems	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1725	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	88736610	\N	1	type	type	f	88736610	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
1760	http://www.openlinksw.com/schemas/virtrdf#qmvftColumnName	4	\N	17	qmvftColumnName	qmvftColumnName	f	0	\N	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
1761	http://www.snee.com/ns/epname	46	\N	133	epname	epname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1762	http://rdfdata.eionet.europa.eu/wise/ontology/Stratigraphy	859	\N	86	Stratigraphy	Stratigraphy	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1763	http://rdfdata.eionet.europa.eu/article17/generalreportinformation_on_network	22	\N	100	generalreportinformation_on_network	generalreportinformation_on_network	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1764	http://cr.eionet.europa.eu/project/noise/DF1_DF5_Aggl_v2013.csv#ctrycd	456	\N	129	ctrycd	ctrycd	f	0	\N	\N	f	f	220	\N	\N	t	f	\N	\N	\N	t	f	f
1765	http://rdfdata.eionet.europa.eu/article17/generalreport/impact	7	\N	118	impact	impact	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1766	http://rdfdata.eionet.europa.eu/airquality/ontology/designationPeriod	30940	\N	69	designationPeriod	designationPeriod	f	30940	\N	\N	f	f	180	177	\N	t	f	\N	\N	\N	t	f	f
1767	http://reference.eionet.europa.eu/aq/ontology/sample	935516	\N	81	sample	sample	f	935516	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1768	http://rdfdata.eionet.europa.eu/wise/ontology/Scale	12877	\N	86	Scale	Scale	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1769	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNTotPerf	32753	\N	102	uwwNTotPerf	uwwNTotPerf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1770	http://reference.eionet.europa.eu/aq/ontology/areaExceedanceFinal	69855	\N	81	areaExceedanceFinal	areaExceedanceFinal	f	69855	\N	\N	f	f	129	4	\N	t	f	\N	\N	\N	t	f	f
1771	http://rdfdata.eionet.europa.eu/wise/ontology/National_Code	724	\N	86	National_Code	National_Code	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1772	http://rdfdata.eionet.europa.eu/wise/ontology/AverageDepth	5220	\N	86	AverageDepth	AverageDepth	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1773	http://reference.eionet.europa.eu/aq/ontology/reportingBegin	238241	\N	81	reportingBegin	reportingBegin	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1774	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_magnitude_max	2534	\N	83	population_trend_long_magnitude_max	population_trend_long_magnitude_max	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1775	http://rdfdata.eionet.europa.eu/airquality/ontology/timePosition	1029863	\N	69	timePosition	timePosition	f	0	\N	\N	f	f	59	\N	\N	t	f	\N	\N	\N	t	f	f
1776	http://www.w3.org/2004/02/skos/core#closeMatch	5522	\N	4	closeMatch	closeMatch	f	5522	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1777	http://rdfdata.eionet.europa.eu/airquality/ontology/populationExposed	21671	\N	69	populationExposed	populationExposed	f	0	\N	\N	f	f	272	\N	\N	t	f	\N	\N	\N	t	f	f
1778	http://purl.org/dc/terms/creator	47114	\N	5	creator	creator	f	309	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1779	http://rdfdata.eionet.europa.eu/airquality/ontology/zoneCode	30940	\N	69	zoneCode	zoneCode	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1780	http://rdfs.org/ns/void#subjectsTarget	6	\N	16	subjectsTarget	subjectsTarget	f	6	\N	\N	f	f	149	250	\N	t	f	\N	\N	\N	t	f	f
1781	http://rdfdata.eionet.europa.eu/airquality/ontology/parentExceedanceSituation	1351	\N	69	parentExceedanceSituation	parentExceedanceSituation	f	1351	\N	\N	f	f	124	\N	\N	t	f	\N	\N	\N	t	f	f
1782	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwCODPerf	33464	\N	102	uwwCODPerf	uwwCODPerf	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1783	http://rdfdata.eionet.europa.eu/airquality/ontology/broader	1855886	\N	69	broader	broader	f	1855886	\N	\N	f	f	178	\N	\N	t	f	\N	\N	\N	t	f	f
1784	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaNDischargedMeasured	324	\N	102	rcaNDischargedMeasured	rcaNDischargedMeasured	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1785	http://rdfdata.eionet.europa.eu/airquality/ontology/mediaMonitored	2173023	\N	69	mediaMonitored	mediaMonitored	f	2173023	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1786	http://rdfdata.eionet.europa.eu/airquality/ontology/monitoringProgressIndicators	13305	\N	69	monitoringProgressIndicators	monitoringProgressIndicators	f	0	\N	\N	f	f	167	\N	\N	t	f	\N	\N	\N	t	f	f
1787	http://rdfdata.eionet.europa.eu/airquality/ontology/versionId	5150292	\N	69	versionId	versionId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1788	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpTypeOfReceivingArea	36450	\N	102	dcpTypeOfReceivingArea	dcpTypeOfReceivingArea	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1789	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2016.csv#referenceyear	5923	\N	142	referenceyear	referenceyear	f	0	\N	\N	f	f	218	\N	\N	t	f	\N	\N	\N	t	f	f
1790	http://rdfdata.eionet.europa.eu/msfd/ontology/reference	267	\N	85	reference	reference	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1791	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rptMStateValue	52	\N	102	rptMStateValue	rptMStateValue	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1792	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/agglomerationname	397	\N	87	agglomerationname	agglomerationname	f	0	\N	\N	f	f	141	\N	\N	t	f	\N	\N	\N	t	f	f
1793	http://rdfdata.eionet.europa.eu/wise/ontology/METHOD	709	\N	86	METHOD	METHOD	f	0	\N	\N	f	f	37	\N	\N	t	f	\N	\N	\N	t	f	f
1794	http://rdfdata.eionet.europa.eu/msfd/ontology/cityNL	280	\N	85	cityNL	cityNL	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1795	http://rdfdata.eionet.europa.eu/airquality/ontology/samplingPoint	7892	\N	69	samplingPoint	samplingPoint	f	7892	\N	\N	f	f	168	\N	\N	t	f	\N	\N	\N	t	f	f
1796	http://rdfdata.eionet.europa.eu/airquality/ontology/usedInPlan	2404	\N	69	usedInPlan	usedInPlan	f	2404	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1797	http://rod.eionet.europa.eu/schema.rdf#voluntaryReporter	933	\N	84	voluntaryReporter	voluntaryReporter	f	933	\N	\N	f	f	15	154	\N	t	f	\N	\N	\N	t	f	f
1798	http://rdfdata.eionet.europa.eu/airquality/ontology/date	874498	\N	69	date	date	f	437249	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1799	http://rdfdata.eionet.europa.eu/wise/ontology/forParameter	145250	\N	86	forParameter	forParameter	f	145250	\N	\N	f	f	37	17	\N	t	f	\N	\N	\N	t	f	f
1800	http://rdfdata.eionet.europa.eu/msfd/ontology/legalStatus	283	\N	85	legalStatus	legalStatus	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1801	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaPDischargedMeasured	324	\N	102	rcaPDischargedMeasured	rcaPDischargedMeasured	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1802	http://reference.eionet.europa.eu/aq/ontology/mobile	79544	\N	81	mobile	mobile	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1803	http://reference.eionet.europa.eu/aq/ontology/detectionLimitUOM	33862	\N	81	detectionLimitUOM	detectionLimitUOM	f	33861	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1804	http://rdfdata.eionet.europa.eu/article17/ontology/code	240643	\N	83	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1805	http://rdfdata.eionet.europa.eu/article17/generalreportsuccessful	178	\N	100	generalreportsuccessful	generalreportsuccessful	f	178	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1806	http://rdfdata.eionet.europa.eu/airquality/ontology/plannedFullEffectDate	6793	\N	69	plannedFullEffectDate	plannedFullEffectDate	f	6793	\N	\N	f	f	167	59	\N	t	f	\N	\N	\N	t	f	f
1807	http://www.w3.org/2002/07/owl#sameAs	11071	\N	7	sameAs	sameAs	f	10284	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1808	http://reference.eionet.europa.eu/aq/ontology/numberExceedancesBase	274	\N	81	numberExceedancesBase	numberExceedancesBase	f	0	\N	\N	f	f	129	\N	\N	t	f	\N	\N	\N	t	f	f
1809	http://rdfdata.eionet.europa.eu/eea/ontology/minx	202	\N	88	minx	minx	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
1810	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_Precipitation_Max	260	\N	86	Annual_Precipitation_Max	Annual_Precipitation_Max	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1811	http://rdfdata.eionet.europa.eu/inspire-m/ontology/SDSv_Num	1	\N	101	SDSv_Num	SDSv_Num	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1812	http://dd.eionet.europa.eu/property/notAcceptedDate	205886	\N	130	notAcceptedDate	notAcceptedDate	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1813	http://rdfdata.eionet.europa.eu/waterbase/ontology/largestStation	3124	\N	95	largestStation	largestStation	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1814	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggMethodC2	29793	\N	102	aggMethodC2	aggMethodC2	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1815	http://www.w3.org/2000/01/rdf-schema#label	29531367	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1816	http://rdfdata.eionet.europa.eu/eea/ontology/miny	202	\N	88	miny	miny	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
1817	http://rdfdata.eionet.europa.eu/airquality/ontology/approvalMeasurementSystems	8502	\N	69	approvalMeasurementSystems	approvalMeasurementSystems	f	8502	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1818	http://rdfdata.eionet.europa.eu/article17/generalreportadditional_info	178	\N	100	generalreportadditional_info	generalreportadditional_info	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1819	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggMethodC1	33069	\N	102	aggMethodC1	aggMethodC1	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1820	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwSandFiltration	35949	\N	102	uwwSandFiltration	uwwSandFiltration	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1821	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaSensitiveArea	2859	\N	102	rcaSensitiveArea	rcaSensitiveArea	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1822	http://reference.eionet.europa.eu/aq/ontology/municipality	9149	\N	81	municipality	municipality	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1823	http://reference.eionet.europa.eu/aq/ontology/equivalenceDemonstrated	34646	\N	81	equivalenceDemonstrated	equivalenceDemonstrated	f	34646	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1824	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long	2291	\N	83	population_trend_long	population_trend_long	f	2291	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1825	http://rdfdata.eionet.europa.eu/airquality/ontology/additionalDescription	4295	\N	69	additionalDescription	additionalDescription	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1826	http://rdfdata.eionet.europa.eu/article17/generalreportspeciesname	178	\N	100	generalreportspeciesname	generalreportspeciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1827	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_surface_area	8420	\N	83	habitat_surface_area	habitat_surface_area	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1828	http://reference.eionet.europa.eu/aq/ontology/timeExtensionExemption	1197	\N	81	timeExtensionExemption	timeExtensionExemption	f	1197	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1829	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv#numberofinhabitants	1124	\N	151	numberofinhabitants	numberofinhabitants	f	0	\N	\N	f	f	217	\N	\N	t	f	\N	\N	\N	t	f	f
1830	http://reference.eionet.europa.eu/aq/ontology/aggregationTimeZone	576	\N	81	aggregationTimeZone	aggregationTimeZone	f	576	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
1874	http://rdfdata.eionet.europa.eu/wise/ontology/DEVIATIONS	2936	\N	86	DEVIATIONS	DEVIATIONS	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1831	http://reference.eionet.europa.eu/aq/ontology/spatialResolution	3214	\N	81	spatialResolution	spatialResolution	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
1832	http://rdfdata.eionet.europa.eu/wise/ontology/Annual_Precipitation_Min	263	\N	86	Annual_Precipitation_Min	Annual_Precipitation_Min	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1833	http://rdfdata.eionet.europa.eu/wise/ontology/PROGRAMME	53586	\N	86	PROGRAMME	PROGRAMME	f	53586	\N	\N	f	f	60	144	\N	t	f	\N	\N	\N	t	f	f
1834	http://rdfdata.eionet.europa.eu/airquality/ontology/heightFacades	57612	\N	69	heightFacades	heightFacades	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1835	http://rdfdata.eionet.europa.eu/article17/ontology/population_alt_maximum_size	4463	\N	83	population_alt_maximum_size	population_alt_maximum_size	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1836	http://www.openlinksw.com/schemas/virtrdf#qmfLongTmpl	45	\N	17	qmfLongTmpl	qmfLongTmpl	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1837	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaPIncomingMeasured	327	\N	102	rcaPIncomingMeasured	rcaPIncomingMeasured	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1838	http://rdfdata.eionet.europa.eu/article17/ontology/addedByMemberState	150	\N	83	addedByMemberState	addedByMemberState	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
1839	http://rdfdata.eionet.europa.eu/wise/ontology/Thickness_Max	385	\N	86	Thickness_Max	Thickness_Max	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1840	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#UniqueRailID	5149	\N	128	UniqueRailID	UniqueRailID	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
1841	http://rdfdata.eionet.europa.eu/airquality/ontology/dispersionSituation	152119	\N	69	dispersionSituation	dispersionSituation	f	152119	\N	\N	f	f	125	79	\N	t	f	\N	\N	\N	t	f	f
1842	http://www.openlinksw.com/schemas/virtrdf#qmfDtpOfNiceSqlval	6	\N	17	qmfDtpOfNiceSqlval	qmfDtpOfNiceSqlval	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1843	http://rdfdata.eionet.europa.eu/uwwtd/ontology/conName	58	\N	102	conName	conName	f	0	\N	\N	f	f	157	\N	\N	t	f	\N	\N	\N	t	f	f
1844	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_long_quality	98	\N	83	range_trend_long_quality	range_trend_long_quality	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1845	http://rdfdata.eionet.europa.eu/waterbase/ontology/SeaConventionArea	4329	\N	95	SeaConventionArea	SeaConventionArea	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1846	http://rdfdata.eionet.europa.eu/airquality/ontology/identificationNumber	19158	\N	69	identificationNumber	identificationNumber	f	0	\N	\N	f	f	151	\N	\N	t	f	\N	\N	\N	t	f	f
1847	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
1848	http://dd.eionet.europa.eu/property/broaderMetric	79	\N	130	broaderMetric	broaderMetric	f	22	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1849	http://rdfdata.eionet.europa.eu/inspire-m/ontology/viewDownload	125	\N	101	viewDownload	viewDownload	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
1850	http://www.openlinksw.com/schemas/virtrdf#qmfOkForAnySqlvalue	31	\N	17	qmfOkForAnySqlvalue	qmfOkForAnySqlvalue	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1851	http://purl.org/linked-data/sdmx/2009/dimension#timePeriod	217681	\N	71	timePeriod	timePeriod	f	0	\N	\N	f	f	237	\N	\N	t	f	\N	\N	\N	t	f	f
1852	http://rdfdata.eionet.europa.eu/airquality/ontology/sensitivePopulation	10	\N	69	sensitivePopulation	sensitivePopulation	f	0	\N	\N	f	f	272	\N	\N	t	f	\N	\N	\N	t	f	f
1853	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPDischargeMeasured	2361	\N	102	uwwPDischargeMeasured	uwwPDischargeMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1854	http://dd.eionet.europa.eu/property/baselineYearMax	29	\N	130	baselineYearMax	baselineYearMax	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1855	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_range	23755	\N	83	conclusion_range	conclusion_range	f	14999	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1856	http://rdfdata.eionet.europa.eu/wise/ontology/METADATA	11859	\N	86	METADATA	METADATA	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1857	http://rdfdata.eionet.europa.eu/airquality/ontology/municipality	238331	\N	69	municipality	municipality	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
1858	http://dd.eionet.europa.eu/property/dateModified	211	\N	130	dateModified	dateModified	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
1859	http://rdfdata.eionet.europa.eu/wise/ontology/NO_SUBSITES	40827	\N	86	NO_SUBSITES	NO_SUBSITES	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
1860	http://reference.eionet.europa.eu/aq/ontology/samplingEquipment	9796	\N	81	samplingEquipment	samplingEquipment	f	9796	\N	\N	f	f	101	\N	\N	t	f	\N	\N	\N	t	f	f
1861	http://www.w3.org/2000/01/rdf-schema#comment	475	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1862	http://rdfdata.eionet.europa.eu/wise/ontology/Hydraulic_Conductivity_Min	353	\N	86	Hydraulic_Conductivity_Min	Hydraulic_Conductivity_Min	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1863	http://rdfdata.eionet.europa.eu/article17/ontology/forPressureThreat	210344	\N	83	forPressureThreat	forPressureThreat	f	210344	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1864	http://rdfdata.eionet.europa.eu/article17/ontology/euringcode	8866	\N	83	euringcode	euringcode	f	0	\N	\N	f	f	81	\N	\N	t	f	\N	\N	\N	t	f	f
1865	http://rdfdata.eionet.europa.eu/msfd/ontology/acronym	236	\N	85	acronym	acronym	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1866	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterCategory	10315	\N	95	waterCategory	waterCategory	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1867	http://dd.eionet.europa.eu/property/workingUser	209	\N	130	workingUser	workingUser	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
1868	http://rdfdata.eionet.europa.eu/article17/generalreportsac_total_area	51	\N	100	generalreportsac_total_area	generalreportsac_total_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1869	http://rdfdata.eionet.europa.eu/airquality/ontology/currency	5008	\N	69	currency	currency	f	5008	\N	\N	f	f	240	\N	\N	t	f	\N	\N	\N	t	f	f
1870	http://rdfdata.eionet.europa.eu/airquality/ontology/roadLength	8828	\N	69	roadLength	roadLength	f	0	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
1871	http://rdfdata.eionet.europa.eu/wise/ontology/PROGRAMME_LEVEL	928	\N	86	PROGRAMME_LEVEL	PROGRAMME_LEVEL	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1872	http://rdfdata.eionet.europa.eu/airquality/ontology/usedForScenario	42605	\N	69	usedForScenario	usedForScenario	f	42605	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
1873	http://rdfdata.eionet.europa.eu/article17/ontology/type_contractual	50566	\N	83	type_contractual	type_contractual	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1875	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaID	30328	\N	102	rcaID	rcaID	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1876	http://dd.eionet.europa.eu/tables/8286/rdf#RBDID	28694	\N	132	RBDID	RBDID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1877	http://rdfdata.eionet.europa.eu/noisedataflow/ontology/icaocode	168	\N	87	icaocode	icaocode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1878	http://dd.eionet.europa.eu/tables/8286/rdf#RBDName	28694	\N	132	RBDName	RBDName	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1879	http://reference.eionet.europa.eu/aq/ontology/heavyDutyFraction	2006	\N	81	heavyDutyFraction	heavyDutyFraction	f	0	\N	\N	f	f	174	\N	\N	t	f	\N	\N	\N	t	f	f
1880	http://rdfdata.eionet.europa.eu/ippc/ontology/type	190	\N	116	type	type	f	0	\N	\N	f	f	183	\N	\N	t	f	\N	\N	\N	t	f	f
1881	http://rdfdata.eionet.europa.eu/article17/ontology/speciesname	87225	\N	83	speciesname	speciesname	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1883	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwPIncomingMeasured	2067	\N	102	uwwPIncomingMeasured	uwwPIncomingMeasured	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1884	http://rdfdata.eionet.europa.eu/article17/generalreportgeneral_information	22	\N	100	generalreportgeneral_information	generalreportgeneral_information	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1927	http://rod.eionet.europa.eu/schema.rdf#localityName	69	\N	84	localityName	localityName	f	0	\N	\N	f	f	154	\N	\N	t	f	\N	\N	\N	t	f	f
1882	http://rdfdata.eionet.europa.eu/wise/ontology/C_CD	606	\N	86	[Country Code (C_CD)]	C_CD	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1885	http://rdfdata.eionet.europa.eu/article17/generalreportsac_total_number	51	\N	100	generalreportsac_total_number	generalreportsac_total_number	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1886	http://rdfdata.eionet.europa.eu/airquality/ontology/type	1886851	\N	69	type	type	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1887	http://reference.eionet.europa.eu/aq/ontology/inletHeight	78307	\N	81	inletHeight	inletHeight	f	0	\N	\N	f	f	202	\N	\N	t	f	\N	\N	\N	t	f	f
1888	http://creativecommons.org/ns#morePermissions	7	\N	23	morePermissions	morePermissions	f	7	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1889	http://www.w3.org/2004/02/skos/core#altLabel	17040	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1890	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSv11_RelArea	1	\N	101	DSv11_RelArea	DSv11_RelArea	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1891	http://www.snee.com/ns/epyear-established	46	\N	133	epyear-established	epyear-established	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1892	http://dbpedia.org/property/id	1753	\N	19	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1893	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi12	1	\N	101	DSi12	DSi12	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1894	http://www.w3.org/2004/02/skos/core#narrowMatch	132288	\N	4	narrowMatch	narrowMatch	f	130174	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
1895	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi11	1	\N	101	DSi11	DSi11	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1896	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi13	1	\N	101	DSi13	DSi13	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1897	http://www.snee.com/ns/epvideo-sample	55	\N	133	epvideo-sample	epvideo-sample	f	55	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1898	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_long_magnitude_min	2350	\N	83	population_trend_long_magnitude_min	population_trend_long_magnitude_min	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1899	http://rdfdata.eionet.europa.eu/article17/generalreportsac_terrestrial_area	51	\N	100	generalreportsac_terrestrial_area	generalreportsac_terrestrial_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1900	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwNIncomingCalculated	3941	\N	102	uwwNIncomingCalculated	uwwNIncomingCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1901	http://www.openlinksw.com/schemas/virtrdf#qsUserMaps	3	\N	17	qsUserMaps	qsUserMaps	f	3	\N	\N	f	f	171	5	\N	t	f	\N	\N	\N	t	f	f
1902	http://rdfdata.eionet.europa.eu/article17/ontology/natura2000_area_trend	2078	\N	83	natura2000_area_trend	natura2000_area_trend	f	2078	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1903	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi21	1	\N	101	DSi21	DSi21	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1904	http://rdfdata.eionet.europa.eu/waterbase/ontology/waterColourLevel	432	\N	95	waterColourLevel	waterColourLevel	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1905	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwBODIncomingCalculated	4508	\N	102	uwwBODIncomingCalculated	uwwBODIncomingCalculated	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1906	http://rdfdata.eionet.europa.eu/airquality/ontology/numberOfExceedances	329	\N	69	numberOfExceedances	numberOfExceedances	f	0	\N	\N	f	f	114	\N	\N	t	f	\N	\N	\N	t	f	f
1907	http://rdfdata.eionet.europa.eu/airquality/ontology/equivalenceDemonstrated	1828178	\N	69	equivalenceDemonstrated	equivalenceDemonstrated	f	1828178	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1908	http://purl.org/dc/elements/1.1/rights	2	\N	6	rights	rights	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1909	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_area_op	3030	\N	83	complementary_favourable_area_op	complementary_favourable_area_op	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1910	http://rdfdata.eionet.europa.eu/wise/ontology/CYCLE_DESCRIPTION	2303	\N	86	CYCLE_DESCRIPTION	CYCLE_DESCRIPTION	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1911	http://rdfdata.eionet.europa.eu/wise/ontology/Artificial_Recharge	756	\N	86	Artificial_Recharge	Artificial_Recharge	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1912	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#ctrycd	92	\N	137	ctrycd	ctrycd	f	0	\N	\N	f	f	263	\N	\N	t	f	\N	\N	\N	t	f	f
1913	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi23	1	\N	101	DSi23	DSi23	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1914	http://reference.eionet.europa.eu/aq/ontology/zoneCode	1214	\N	81	zoneCode	zoneCode	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1915	http://rdfdata.eionet.europa.eu/inspire-m/ontology/DSi22	1	\N	101	DSi22	DSi22	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1916	http://rdfdata.eionet.europa.eu/waterbase/ontology/riverDischarge	2193	\N	95	riverDischarge	riverDischarge	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1917	http://rdfdata.eionet.europa.eu/wise/ontology/PollutantsCausingFailure	9219	\N	86	PollutantsCausingFailure	PollutantsCausingFailure	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1918	http://rdfdata.eionet.europa.eu/uwwtd/ontology/mslWWReusePerc	21	\N	102	mslWWReusePerc	mslWWReusePerc	f	0	\N	\N	f	f	246	\N	\N	t	f	\N	\N	\N	t	f	f
1919	http://rdfdata.eionet.europa.eu/airquality/ontology/area	30940	\N	69	area	area	f	0	\N	\N	f	f	180	\N	\N	t	f	\N	\N	\N	t	f	f
1920	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_favourable_population	5522	\N	83	complementary_favourable_population	complementary_favourable_population	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1921	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_structure_trend	1898	\N	83	conclusion_structure_trend	conclusion_structure_trend	f	1898	\N	\N	f	f	128	8	\N	t	f	\N	\N	\N	t	f	f
1922	http://reference.eionet.europa.eu/aq/ontology/ecosystemAreaExposed	29199	\N	81	ecosystemAreaExposed	ecosystemAreaExposed	f	0	\N	\N	f	f	166	\N	\N	t	f	\N	\N	\N	t	f	f
1923	http://www.openlinksw.com/schemas/virtrdf#qmfHasCheapSqlval	22	\N	17	qmfHasCheapSqlval	qmfHasCheapSqlval	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
1924	http://reference.eionet.europa.eu/aq/ontology/protectionTarget	10878734	\N	81	protectionTarget	protectionTarget	f	10878734	\N	\N	f	f	\N	8	\N	t	f	\N	\N	\N	t	f	f
1925	http://rdfdata.eionet.europa.eu/article17/generalreport/conservation-measures	25	\N	118	conservation-measures	conservation-measures	f	25	\N	\N	f	f	204	\N	\N	t	f	\N	\N	\N	t	f	f
1926	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_quality	10527	\N	83	habitat_quality	habitat_quality	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1928	http://reference.eionet.europa.eu/aq/ontology/operationActivityPeriod	692	\N	81	operationActivityPeriod	operationActivityPeriod	f	0	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
1929	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_population	383	\N	83	conclusion_n2000_population	conclusion_n2000_population	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1930	http://rdfdata.eionet.europa.eu/wise/ontology/Water_Abstractions	1025	\N	86	Water_Abstractions	Water_Abstractions	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1931	http://rdfdata.eionet.europa.eu/article17/generalreportreference	14	\N	100	generalreportreference	generalreportreference	f	0	\N	\N	f	f	242	\N	\N	t	f	\N	\N	\N	t	f	f
1932	http://dd.eionet.europa.eu/tables/8286/rdf#GroupID	32868	\N	132	GroupID	GroupID	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1933	http://www.geonames.org/ontology#name	579	\N	70	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1934	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_population_trend	3389	\N	83	conclusion_population_trend	conclusion_population_trend	f	3389	\N	\N	f	f	253	8	\N	t	f	\N	\N	\N	t	f	f
1935	http://rdfdata.eionet.europa.eu/article17/ontology/location_inside	50566	\N	83	location_inside	location_inside	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1936	http://rdfdata.eionet.europa.eu/uwwtd/ontology/dcpCOMAccept	4673	\N	102	dcpCOMAccept	dcpCOMAccept	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
1937	http://rdfdata.eionet.europa.eu/airquality/ontology/stationClassification	1853936	\N	69	stationClassification	stationClassification	f	1853936	\N	\N	f	f	169	8	\N	t	f	\N	\N	\N	t	f	f
1938	http://rdfdata.eionet.europa.eu/wise/ontology/TypologyCode	1030	\N	86	TypologyCode	TypologyCode	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
1939	http://rdfdata.eionet.europa.eu/airquality/ontology/detectionLimit	1893292	\N	69	detectionLimit	detectionLimit	f	0	\N	\N	f	f	193	\N	\N	t	f	\N	\N	\N	t	f	f
1940	http://rdfdata.eionet.europa.eu/airquality/ontology/analysisAssessmentMethod	8874	\N	69	analysisAssessmentMethod	analysisAssessmentMethod	f	8874	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1941	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentMethod	1973	\N	69	assessmentMethod	assessmentMethod	f	1973	\N	\N	f	f	197	73	\N	t	f	\N	\N	\N	t	f	f
1942	http://www.openlinksw.com/schemas/virtrdf#qmvaAlias	2	\N	17	qmvaAlias	qmvaAlias	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
1943	http://reference.eionet.europa.eu/aq/ontology/beginLifespanVersion	2839	\N	81	beginLifespanVersion	beginLifespanVersion	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1944	http://purl.org/dc/terms/licence	2	\N	5	licence	licence	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1945	http://rdfdata.eionet.europa.eu/wise/ontology/DepthRange	5039	\N	86	DepthRange	DepthRange	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1946	http://rdfdata.eionet.europa.eu/uwwtd/ontology/rcaMorphology	5220	\N	102	rcaMorphology	rcaMorphology	f	0	\N	\N	f	f	209	\N	\N	t	f	\N	\N	\N	t	f	f
1947	http://rdfdata.eionet.europa.eu/airquality/ontology/cooperationMSCommission	8029	\N	69	cooperationMSCommission	cooperationMSCommission	f	8029	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1948	http://rdfdata.eionet.europa.eu/msfd/ontology/MSCACode	275	\N	85	MSCACode	MSCACode	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
1949	http://rdfdata.eionet.europa.eu/airquality/ontology/methodsFulfillingDQO	69726	\N	69	methodsFulfillingDQO	methodsFulfillingDQO	f	69726	\N	\N	f	f	196	\N	\N	t	f	\N	\N	\N	t	f	f
1950	http://rdfdata.eionet.europa.eu/airquality/ontology/officialDocumentNumber	17162	\N	69	officialDocumentNumber	officialDocumentNumber	f	0	\N	\N	f	f	151	\N	\N	t	f	\N	\N	\N	t	f	f
1951	http://reference.eionet.europa.eu/aq/ontology/inspireNamespace	1439708	\N	81	inspireNamespace	inspireNamespace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1952	http://reference.eionet.europa.eu/aq/ontology/heatingEmissions	508523	\N	81	heatingEmissions	heatingEmissions	f	0	\N	\N	f	f	225	\N	\N	t	f	\N	\N	\N	t	f	f
1953	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceAffected	53533	\N	69	exceedanceAffected	exceedanceAffected	f	53533	\N	\N	f	f	127	\N	\N	t	f	\N	\N	\N	t	f	f
1954	http://reference.eionet.europa.eu/aq/ontology/samplingpoint_lat	935516	\N	81	samplingpoint_lat	samplingpoint_lat	f	0	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
1955	http://rdfdata.eionet.europa.eu/eea/ontology/formula	26	\N	88	formula	formula	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1956	http://rod.eionet.europa.eu/schema.rdf#lastModified	26	\N	84	lastModified	lastModified	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1957	http://dd.eionet.europa.eu/property/hasReportingMetric	192	\N	130	hasReportingMetric	hasReportingMetric	f	192	\N	\N	f	f	8	8	\N	t	f	\N	\N	\N	t	f	f
1958	http://rdfdata.eionet.europa.eu/inspire-m/ontology/NSv_NumInvkServ	1	\N	101	NSv_NumInvkServ	NSv_NumInvkServ	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1959	http://www.geonames.org/ontology#neighbouringFeatures	155	\N	70	neighbouringFeatures	neighbouringFeatures	f	155	\N	\N	f	f	258	\N	\N	t	f	\N	\N	\N	t	f	f
1960	http://rdfdata.eionet.europa.eu/ramon/ontology/minY	1778	\N	91	minY	minY	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1961	http://rdfs.org/ns/void#objectsTarget	6	\N	16	objectsTarget	objectsTarget	f	6	\N	\N	f	f	149	250	\N	t	f	\N	\N	\N	t	f	f
1962	http://dd.eionet.europa.eu/property/reductionTarget	29	\N	130	reductionTarget	reductionTarget	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1963	http://rdfdata.eionet.europa.eu/ramon/ontology/level	8800	\N	91	level	level	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1964	http://rdfdata.eionet.europa.eu/ramon/ontology/minX	1778	\N	91	minX	minX	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1965	http://rdfdata.eionet.europa.eu/airquality/ontology/link	43903	\N	69	link	link	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1967	http://purl.org/vocab/vann/preferredNamespaceUri	1	\N	24	preferredNamespaceUri	preferredNamespaceUri	f	0	\N	\N	f	f	172	\N	\N	t	f	\N	\N	\N	t	f	f
1968	http://rdfdata.eionet.europa.eu/airquality/ontology/streetWidth	61961	\N	69	streetWidth	streetWidth	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
1969	http://rdfdata.eionet.europa.eu/article17/generalreport/total_number	104	\N	118	total_number	total_number	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1966	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend	16365	\N	83	[Population trend (population_trend)]	population_trend	f	10485	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1970	http://rdfdata.eionet.europa.eu/article17/ontology/population_reasons_for_change_a	10759	\N	83	population_reasons_for_change_a	population_reasons_for_change_a	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1971	http://rdfdata.eionet.europa.eu/uwwtd/ontology/aggVideoInspections	27509	\N	102	aggVideoInspections	aggVideoInspections	f	0	\N	\N	f	f	181	\N	\N	t	f	\N	\N	\N	t	f	f
1972	http://rod.eionet.europa.eu/schema.rdf#celexref	166	\N	84	celexref	celexref	f	0	\N	\N	f	f	215	\N	\N	t	f	\N	\N	\N	t	f	f
1973	http://rdfdata.eionet.europa.eu/article17/ontology/population_reasons_for_change_b	10759	\N	83	population_reasons_for_change_b	population_reasons_for_change_b	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1974	http://rdfdata.eionet.europa.eu/airquality/ontology/assessmentAirQuality	8874	\N	69	assessmentAirQuality	assessmentAirQuality	f	8874	\N	\N	f	f	\N	78	\N	t	f	\N	\N	\N	t	f	f
1975	http://rdfdata.eionet.europa.eu/wise/ontology/MS_CD	40828	\N	86	MS_CD	MS_CD	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
1976	http://rod.eionet.europa.eu/schema.rdf#validSince	255	\N	84	validSince	validSince	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1977	http://cr.eionet.europa.eu/ontologies/contreg.rdf#userHistory	5	\N	82	userHistory	userHistory	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1978	http://rdfdata.eionet.europa.eu/article17/ontology/population_reasons_for_change_c	10759	\N	83	population_reasons_for_change_c	population_reasons_for_change_c	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1979	http://reference.eionet.europa.eu/aq/ontology/region	492	\N	81	region	region	f	492	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
1980	http://discomap.eea.europa.eu//#Name	224	\N	148	Name	Name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1981	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwLoadEnteringUWWTP	32684	\N	102	uwwLoadEnteringUWWTP	uwwLoadEnteringUWWTP	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1982	http://rod.eionet.europa.eu/schema.rdf#isEEACore	671	\N	84	isEEACore	isEEACore	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
1984	http://dd.eionet.europa.eu/property/baselineYearMin	29	\N	130	baselineYearMin	baselineYearMin	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1985	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorAirports_v2012.csv#ctryname	92	\N	137	ctryname	ctryname	f	0	\N	\N	f	f	263	\N	\N	t	f	\N	\N	\N	t	f	f
1986	http://dd.eionet.europa.eu/property/Population	45	\N	130	Population	Population	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1987	http://rdfdata.eionet.europa.eu/article17/generalreportspa_total_area	15	\N	100	generalreportspa_total_area	generalreportspa_total_area	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
1988	http://rdfdata.eionet.europa.eu/wise/ontology/Hydraulic_Conductivity_Max	359	\N	86	Hydraulic_Conductivity_Max	Hydraulic_Conductivity_Max	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
1989	http://rdfdata.eionet.europa.eu/airquality/ontology/exceedanceAttainment	479066	\N	69	exceedanceAttainment	exceedanceAttainment	f	479066	\N	\N	f	f	113	8	\N	t	f	\N	\N	\N	t	f	f
1990	http://rdfdata.eionet.europa.eu/article17/ontology/habitat_area_suitable	6790	\N	83	habitat_area_suitable	habitat_area_suitable	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1991	http://rdfdata.eionet.europa.eu/uwwtd/ontology/uwwOzonation	35949	\N	102	uwwOzonation	uwwOzonation	f	0	\N	\N	f	f	235	\N	\N	t	f	\N	\N	\N	t	f	f
1992	http://dd.eionet.europa.eu/tables/8286/rdf#Change	30363	\N	132	Change	Change	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
1993	http://rdfdata.eionet.europa.eu/wise/ontology/REPORTING_LEVEL	348	\N	86	REPORTING_LEVEL	REPORTING_LEVEL	f	0	\N	\N	f	f	120	\N	\N	t	f	\N	\N	\N	t	f	f
1995	http://purl.org/dc/terms/created	7269	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1996	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRailways_v2015.csv#Country	5149	\N	128	Country	Country	f	0	\N	\N	f	f	92	\N	\N	t	f	\N	\N	\N	t	f	f
1997	http://rdfdata.eionet.europa.eu/waterbase/ontology/catchmentArea	6380	\N	95	catchmentArea	catchmentArea	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
1998	http://dd.eionet.europa.eu/property/AreaDifference	45	\N	130	AreaDifference	AreaDifference	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
1999	http://cr.eionet.europa.eu/project/noise/MAgg_2010_2015.csv#UniqueAgglomerationId	1124	\N	151	UniqueAgglomerationId	UniqueAgglomerationId	f	0	\N	\N	f	f	217	\N	\N	t	f	\N	\N	\N	t	f	f
2000	http://cr.eionet.europa.eu/project/noise/DF1_DF5_MajorRoads_v2015.csv#AnnualTrafficFlow	123830	\N	147	AnnualTrafficFlow	AnnualTrafficFlow	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
2001	http://rdfdata.eionet.europa.eu/wise/ontology/ReferenceDataSet	1030	\N	86	ReferenceDataSet	ReferenceDataSet	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_area	225	\N	83	[Conclusion within Natura 2000 sites on area (conclusion_n2000_area)]	conclusion_n2000_area	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_structure	7186	\N	83	[Conclusion on structure and function (conclusion_structure)]	conclusion_structure	f	4433	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://rdfdata.eionet.europa.eu/article17/ontology/complementary_species_assessment	9024	\N	83	[Typical species assessment (complementary_species_assessment)]	complementary_species_assessment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://rdfdata.eionet.europa.eu/article17/ontology/population_pressures	40033	\N	83	[Main population pressures (population_pressures)]	population_pressures	f	40033	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
354	http://rdfdata.eionet.europa.eu/article17/ontology/range_date	9024	\N	83	[Date of range determination (range_date)]	range_date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_quality	2546	\N	83	[Quality of data on area (coverage_quality)]	coverage_quality	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
413	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_habitat	287	\N	83	[Conclusion within Natura 2000 sites on habitat f.. (conclusion_n2000_habitat)]	conclusion_n2000_habitat	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
432	http://rdfdata.eionet.europa.eu/article17/ontology/population_threats	40291	\N	83	[Population threats (population_threats)]	population_threats	f	40291	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1994	http://rdfdata.eionet.europa.eu/article17/ontology/population_trend_magnitude	6257	\N	83	[Population trend magnitude (population_trend_magnitude)]	population_trend_magnitude	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
501	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_future	23755	\N	83	[Conclusion on future prospects (conclusion_future)]	conclusion_future	f	14999	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
564	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_habitat	16576	\N	83	[Conclusion on habitat for the species (conclusion_habitat)]	conclusion_habitat	f	10566	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
677	http://rdfdata.eionet.europa.eu/wise/ontology/GW_body_code	5053	\N	86	[GW body code (GW_body_code)]	GW_body_code	f	0	\N	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
686	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_structure	418	\N	83	[Conclusion within Natura 2000 sites on structure.. (conclusion_n2000_structure)]	conclusion_n2000_structure	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
986	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_area	7187	\N	83	[Conclusion on area (conclusion_area)]	conclusion_area	f	4433	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1079	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_methods	3021	\N	83	[Method used for coverage estimation (coverage_methods)]	coverage_methods	f	3021	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1185	http://rdfdata.eionet.europa.eu/article17/ontology/range_quality	8606	\N	83	[Quality of data concerning range (range_quality)]	range_quality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1239	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_threats	18175	\N	83	[Coverage threats (coverage_threats)]	coverage_threats	f	18175	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1351	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_assessment	604	\N	83	[Conclusion within Natura 2000 sites on overall a.. (conclusion_n2000_assessment)]	conclusion_n2000_assessment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1369	http://rdfdata.eionet.europa.eu/article17/ontology/range_trend_period	24156	\N	83	[Range trend period (range_trend_period)]	range_trend_period	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1414	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_reasons	6051	\N	83	[Reasons for reported trend in coverage (coverage_reasons)]	coverage_reasons	f	3284	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1479	http://rdfdata.eionet.europa.eu/article17/ontology/population_justification	6257	\N	83	[Justification of % thresholds for trends (population_justification)]	population_justification	f	0	\N	\N	f	f	253	\N	\N	t	f	\N	\N	\N	t	f	f
1530	http://rdfdata.eionet.europa.eu/article17/ontology/range_surface_area	29770	\N	83	[Surface area of range in km2 (range_surface_area)]	range_surface_area	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1578	http://rdfdata.eionet.europa.eu/article17/ontology/range_reasons	18834	\N	83	[Reasons for reported trend (range_reasons)]	range_reasons	f	9810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1586	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_period	7149	\N	83	[Area trend period (coverage_trend_period)]	coverage_trend_period	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
1622	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_future	609	\N	83	[Conclusion within Natura 2000 sites on future pr.. (conclusion_n2000_future)]	conclusion_n2000_future	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1679	http://rdfdata.eionet.europa.eu/article17/ontology/conclusion_n2000_range	431	\N	83	[Conclusion within Natura 2000 sites on range (conclusion_n2000_range)]	conclusion_n2000_range	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
1983	http://rdfdata.eionet.europa.eu/article17/ontology/coverage_trend_magnitude	2767	\N	83	[Area trend magnitude in km2 (coverage_trend_magnitude)]	coverage_trend_magnitude	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_cr_eionet_europa_eu; Owner: -
--

COPY http_cr_eionet_europa_eu.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	3	8	note	en
2	4	8	Attachment of	\N
3	5	8	Spatial Coverage	en
4	5	8	Spatial Coverage	en-us
5	14	8	Type of air quality zone	\N
6	22	8	Measures taken	\N
7	23	8	Conclusion within Natura 2000 sites on area	\N
8	24	8	Feedback for	\N
9	25	8	Description	en
10	27	8	priorVersion	\N
11	44	8	hidden label	en
12	45	8	Conclusion on structure and function	\N
13	46	8	Abstract	en
14	46	8	Abstract	en-us
15	47	8	Start of period	\N
16	48	8	Method used for area estimation	\N
17	49	8	Habitat code	\N
18	59	8	Name	\N
19	63	8	EU Code	\N
20	65	8	Extent	en
21	65	8	Extent	en-us
22	66	8	Description	\N
23	67	8	Longitude of measurement station	\N
24	68	8	Postal code	\N
25	71	8	Surface area of the habitat type in km2	\N
26	79	8	Legal texts	\N
27	87	8	Content last modified	\N
28	89	8	Locality	\N
29	92	8	Date Valid	en
30	92	8	Date Valid	en-us
31	99	8	Non-territorial planning instruments	\N
32	113	8	Station	\N
33	118	8	Exceedance declared for zone	\N
34	121	8	Other territorial planning instrument	\N
35	126	8	Link to delivery	\N
36	127	8	Has Part	en
37	127	8	Has Part	en-us
38	131	8	Contributor	en
39	131	8	Contributor	en-us
40	134	8	Disperion regional	\N
41	135	8	Traffic speed	\N
42	138	8	rest	\N
43	141	8	Conclusion on population	\N
44	144	8	End of period	\N
45	145	8	Title and year of territorial planning instrument	\N
46	155	8	Range trend	\N
47	160	8	Use Owl SameAs	\N
48	161	8	Nationality	\N
49	165	8	ROD Locality code	\N
50	171	8	Redirected to	\N
51	172	8	EEA group	\N
52	178	8	has member	en
53	179	8	Coverage	en
54	183	8	Typical species assessment	\N
55	193	8	Reasons for reported trend	\N
56	194	8	Dispersion regional	\N
57	200	8	Subject	en
58	200	8	Subject	en-us
59	202	8	Typical Species in Habitat type	\N
60	206	8	Other clients	\N
61	209	8	Publisher	en
62	209	8	Publisher	en-us
63	220	8	imports	\N
64	222	8	National station code	\N
65	225	8	Special areas of conservation	\N
66	247	8	Main population pressures	\N
67	248	8	Data coverage (%)	\N
68	269	8	editorial note	en
69	274	8	Coverage	\N
70	287	8	Name	\N
71	292	8	Date Modified	en
72	292	8	Date Modified	en-us
73	300	8	Distance junction	\N
74	308	8	Range trend magnitude in km2	\N
75	311	8	preferred label	en
76	315	8	Edition	\N
77	321	8	Type of locality	\N
78	322	8	Has schema	\N
79	331	8	Air quality zone	\N
80	335	8	User	\N
81	339	8	Sites of community importance	\N
82	348	8	Deadline for 2nd period	\N
83	354	8	Date of range determination	\N
84	358	8	Alternative Title	en
85	358	8	Alternative Title	en-us
86	361	8	City	\N
87	386	8	Uses vocabulary	\N
88	398	8	Allowed types	\N
89	404	8	Quality of data on area	\N
90	413	8	Conclusion within Natura 2000 sites on habitat for the species	\N
91	419	8	Measurement regime	\N
92	421	8	Requesting client	\N
93	432	8	Population threats	\N
94	434	8	Rights	en
95	434	8	Rights	en-us
96	438	8	Source	en
97	438	8	Source	en-us
98	462	8	Latitude of measurement station	\N
99	463	8	Short form name	\N
100	500	8	Used for AQD	\N
101	501	8	Conclusion on future prospects	\N
102	513	8	Alpha-2 code	en
103	513	8	Code alpha-2	fr
104	528	8	Favourable reference range (km2)	\N
105	533	8	Belongs to network	\N
106	534	8	Belongs to network	\N
107	540	8	notation	en
108	543	8	Official language of	\N
109	547	8	Title of comprehensive management plan and year adopted	\N
110	563	8	Obligation	\N
111	564	8	Conclusion on habitat for the species	\N
112	571	8	Air pollutant	\N
113	583	8	Subject	en
114	596	8	Date of coverage determination	\N
115	598	8	Marine region	\N
116	609	8	Code	\N
117	614	8	Education and information	\N
118	622	8	Code	\N
119	624	8	inverseOf	\N
120	627	8	River basin district	\N
121	634	8	Heavy duty fraction	\N
122	635	8	Relevant emissions	\N
123	639	8	feature	\N
124	642	8	unionOf	\N
125	644	8	versionInfo	\N
126	650	8	Measures to avoid deterioration	\N
127	659	8	Acronym	\N
128	674	8	Has Version	en
129	674	8	Has Version	en-us
130	675	8	Legislation Instrument	\N
131	677	8	GW body code	\N
132	682	8	is in scheme	en
133	685	8	European RBD Code	\N
134	686	8	Conclusion within Natura 2000 sites on structure and function	\N
135	687	8	range	\N
136	688	8	Environmental issue	\N
137	690	8	Tag	\N
138	700	8	End time	\N
139	705	8	Date	en
140	705	8	Date	en-us
141	707	8	Data Steward	\N
142	728	8	SPARQL query	\N
143	736	8	Biogeographic region or marine region	\N
144	738	8	equivalentClass	\N
145	739	8	Name	\N
146	740	8	Date	en
147	746	8	Short name	\N
148	761	8	Is Version Of	en
149	761	8	Is Version Of	en-us
150	775	8	Release date	\N
151	781	8	Language	en
152	781	8	Language	en-us
153	786	8	Title	en
154	786	8	Title	en-us
155	820	8	has related	en
156	823	8	Error message	\N
157	829	8	Published reports or websites	\N
158	834	8	Alpha-3 terminological code	en
159	834	8	Code alpha-3 terminologie	fr
160	836	8	domain	\N
161	838	8	Alpha-3 bibliographic code	en
162	838	8	Code alpha-3 bibliographique	fr
163	853	8	Area of measurement station	\N
164	859	8	City	\N
165	860	8	Last update	\N
166	861	8	Title of management body and year established	\N
167	865	8	Name	\N
168	871	8	Site name	\N
169	882	8	has broader	en
170	894	8	NUTS	\N
171	895	8	Identifier	en
172	895	8	Identifier	en-us
173	912	8	User bookmark	\N
174	913	8	Source	en
175	915	8	has exact match	en
176	927	8	Traffic volume	\N
177	931	8	Has obligation	\N
178	933	8	equivalentProperty	\N
179	937	8	Is Replaced By	en
180	937	8	Is Replaced By	en-us
181	950	8	seeAlso	\N
182	964	8	Distance to junction	\N
183	971	8	Has parent region	\N
184	972	8	General Comment	\N
185	979	8	Media type	\N
186	983	8	Coverage	\N
187	986	8	Conclusion on area	\N
188	993	8	Longitude	\N
189	996	8	Last refreshed	\N
190	1002	8	File in delivery	\N
191	1004	8	Street width	\N
192	1013	8	Data aggregation process	\N
193	1018	8	Figure	\N
194	1019	8	Last modified by	\N
195	1020	8	Role responsible for reporting	\N
196	1024	8	Population trend period	\N
197	1029	8	first	\N
198	1034	8	Email	\N
199	1035	8	Format	en
200	1035	8	Format	en-us
201	1041	8	Assessment type	\N
202	1055	8	EEA programme	\N
203	1060	8	Guidelines for reporting	\N
204	1071	8	Number of harvested statements	\N
205	1075	8	Site code	\N
206	1079	8	Method used for coverage estimation	\N
207	1084	8	Data reporting metric	\N
208	1088	8	Blocked by QA	\N
209	1092	8	Data Custodian	\N
210	1094	8	Unit of air pollution level	\N
211	1104	8	Is Part Of	en
212	1104	8	Is Part Of	en-us
213	1107	8	definition	en
214	1110	8	Plant name	\N
215	1118	8	Publishing code	\N
216	1122	8	disjointWith	\N
217	1125	8	Next Deadline	\N
218	1138	8	Reporting year	\N
219	1140	8	Air Quality station EoI code	\N
220	1141	8	has narrower	en
221	1148	8	supported language	\N
222	1152	8	Name	\N
223	1160	8	Description	en
224	1160	8	Description	en-us
225	1164	8	Size	\N
226	1169	8	Procedure	\N
227	1170	8	Name	\N
228	1173	8	Title and year of non-territorial planning instrument	\N
229	1174	8	Obligation terminated	\N
230	1177	8	Comprehensive management plan in preparation?	\N
231	1185	8	Quality of data concerning range	\N
232	1191	8	Traffic speed	\N
233	1216	8	Dispersion local	\N
234	1220	8	% site covered by instrument	\N
235	1221	8	Main coverage pressures	\N
236	1224	8	Name	\N
237	1225	8	endpoint	\N
238	1230	8	Observing capability	\N
239	1231	8	Type of information	\N
240	1238	8	Data capture (%)	\N
241	1239	8	Coverage threats	\N
242	1245	8	Country	\N
243	1279	8	Latitude	\N
244	1284	8	Requires	en
245	1284	8	Requires	en-us
246	1285	8	has related match	en
247	1291	8	value	\N
248	1296	8	Traffic volume	\N
249	1304	8	scope note	en
250	1329	8	Distance to kerb	\N
251	1330	8	Member of	\N
252	1332	8	complementOf	\N
253	1333	8	Product keyword	\N
254	1344	8	term status	\N
255	1346	8	NUTS	\N
256	1351	8	Conclusion within Natura 2000 sites on overall assessment	\N
257	1363	8	Contributor	en
258	1368	8	Management plans and Management bodies	\N
259	1369	8	Range trend period	\N
260	1386	8	Delivery period	\N
261	1394	8	Eionet core data flow	\N
262	1402	8	has top concept	en
263	1409	8	Analytical technique	\N
264	1411	8	Published sources and/or websites	\N
265	1413	8	Sampling point	\N
266	1414	8	Reasons for reported trend in coverage	\N
267	1424	8	Conclusion on overall assessment	\N
268	1447	8	subClassOf	\N
269	1466	8	Favourable reference area (km2)	\N
270	1479	8	Justification of % thresholds for trends	\N
271	1507	8	Height of facades	\N
272	1511	8	Type of measurement station	\N
273	1512	8	Dispersion local	\N
274	1530	8	Surface area of range in km2	\N
275	1535	8	Media monitored	\N
276	1540	8	Data verification	\N
277	1558	8	has broader match	en
278	1560	8	subPropertyOf	\N
279	1563	8	EEA strategic area	\N
280	1564	8	XML Schema/DTD	\N
281	1566	8	Has feedback	\N
282	1568	8	example	en
283	1574	8	Address	\N
284	1576	8	Title	en
285	1578	8	Reasons for reported trend	\N
286	1586	8	Area trend period	\N
287	1595	8	For country	\N
288	1606	8	Area trend	\N
289	1608	8	Replaces	en
290	1608	8	Replaces	en-us
291	1621	8	First seen	\N
292	1622	8	Conclusion within Natura 2000 sites on future prospects	\N
293	1628	8	INSPIRE ID	\N
294	1644	8	isDefinedBy	\N
295	1650	8	Air pollution level	\N
296	1651	8	Name (native language)	\N
297	1654	8	Opened date	\N
298	1666	8	Sampling point longitude	\N
299	1676	8	Altitude	\N
300	1678	8	Adjustment used in Zone	\N
301	1679	8	Conclusion within Natura 2000 sites on range	\N
302	1680	8	Author	\N
303	1684	8	Creator	en
304	1687	8	Name	\N
305	1689	8	Date Issued	en
306	1689	8	Date Issued	en-us
307	1690	8	Observation validity	\N
308	1711	8	NUTS	\N
309	1712	8	(Re-)introduction of species	\N
310	1717	8	Format	en
311	1725	8	type	\N
312	1733	8	Has member	\N
313	1737	8	Identifier	en
314	1739	8	Has attachment	\N
315	1740	8	User save time	\N
316	1742	8	Coverage note	\N
317	1743	8	License	en
318	1743	8	License	en-us
319	1744	8	Name	\N
320	1753	8	Helpdesk mail	\N
321	1767	8	Sample	\N
322	1776	8	has close match	en
323	1778	8	Creator	en
324	1778	8	Creator	en-us
325	1802	8	Is mobile station	\N
326	1804	8	Code	\N
327	1807	8	sameAs	\N
328	1815	8	label	\N
329	1822	8	Municipality	\N
330	1834	8	Height of facades	\N
331	1843	8	Name	\N
332	1847	8	result format	\N
333	1855	8	Conclusion on range	\N
334	1861	8	comment	\N
335	1881	8	Scientific name	\N
336	1882	8	Country Code	\N
337	1889	8	alternative label	en
338	1894	8	has narrower match	en
339	1908	8	Rights	en
340	1914	8	Air quality zone code	\N
341	1927	8	Name	\N
342	1929	8	Conclusion within Natura 2000 sites on population	\N
343	1951	8	INSPIRE namespace	\N
344	1954	8	Sampling point latitude	\N
345	1956	8	Last modified date	\N
346	1963	8	Level	\N
347	1966	8	Population trend	\N
348	1968	8	Street width	\N
349	1972	8	CELEX reference	\N
350	1982	8	Used for EEA Core Set of Indicators	\N
351	1983	8	Area trend magnitude in km2	\N
352	1994	8	Population trend magnitude	\N
353	1995	8	Date Created	en
354	1995	8	Date Created	en-us
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cc_rels_id_seq', 25, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.class_annots_id_seq', 151, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.classes_id_seq', 272, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cp_rels_id_seq', 5474, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cpc_rels_id_seq', 3640, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.ns_id_seq', 157, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.properties_id_seq', 2001, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_cr_eionet_europa_eu; Owner: -
--

SELECT pg_catalog.setval('http_cr_eionet_europa_eu.property_annots_id_seq', 354, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_cr_eionet_europa_eu.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_cr_eionet_europa_eu.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_cr_eionet_europa_eu.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_cr_eionet_europa_eu.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_cr_eionet_europa_eu.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_cr_eionet_europa_eu.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_cr_eionet_europa_eu.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_cr_eionet_europa_eu.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_cr_eionet_europa_eu.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_cr_eionet_europa_eu.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_cr_eionet_europa_eu.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_cr_eionet_europa_eu.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_cr_eionet_europa_eu.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_cr_eionet_europa_eu.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_cr_eionet_europa_eu.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_cr_eionet_europa_eu.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_cr_eionet_europa_eu.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_cr_eionet_europa_eu.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_cr_eionet_europa_eu.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_cr_eionet_europa_eu.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_classes_data ON http_cr_eionet_europa_eu.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_classes_iri ON http_cr_eionet_europa_eu.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_cr_eionet_europa_eu.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_cr_eionet_europa_eu.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_cr_eionet_europa_eu.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_cr_eionet_europa_eu.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_cr_eionet_europa_eu.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_cr_eionet_europa_eu.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_instances_test ON http_cr_eionet_europa_eu.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_cr_eionet_europa_eu.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_cr_eionet_europa_eu.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_cr_eionet_europa_eu.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_cr_eionet_europa_eu.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_cr_eionet_europa_eu.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_cr_eionet_europa_eu.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_cr_eionet_europa_eu.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_cr_eionet_europa_eu.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_properties_data ON http_cr_eionet_europa_eu.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_cr_eionet_europa_eu; Owner: -
--

CREATE INDEX idx_properties_iri ON http_cr_eionet_europa_eu.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_cr_eionet_europa_eu.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_cr_eionet_europa_eu.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_cr_eionet_europa_eu.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_cr_eionet_europa_eu.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_cr_eionet_europa_eu.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_cr_eionet_europa_eu.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_cr_eionet_europa_eu.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_cr_eionet_europa_eu.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_cr_eionet_europa_eu.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_cr_eionet_europa_eu.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_cr_eionet_europa_eu.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_cr_eionet_europa_eu.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_cr_eionet_europa_eu.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_cr_eionet_europa_eu.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_cr_eionet_europa_eu.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_cr_eionet_europa_eu.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_cr_eionet_europa_eu.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_cr_eionet_europa_eu.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_cr_eionet_europa_eu.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_cr_eionet_europa_eu.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_cr_eionet_europa_eu; Owner: -
--

ALTER TABLE ONLY http_cr_eionet_europa_eu.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_cr_eionet_europa_eu.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

