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
-- Name: http_kaiko_getalp_org_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_kaiko_getalp_org_sparql;


--
-- Name: SCHEMA http_kaiko_getalp_org_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_kaiko_getalp_org_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE FUNCTION http_kaiko_getalp_org_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE FUNCTION http_kaiko_getalp_org_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COMMENT ON TABLE http_kaiko_getalp_org_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COMMENT ON COLUMN http_kaiko_getalp_org_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_kaiko_getalp_org_sparql.classes c1
     JOIN http_kaiko_getalp_org_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_kaiko_getalp_org_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_kaiko_getalp_org_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_kaiko_getalp_org_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE TABLE http_kaiko_getalp_org_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE http_kaiko_getalp_org_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_kaiko_getalp_org_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_cc_rels AS
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
   FROM http_kaiko_getalp_org_sparql.cc_rels r,
    http_kaiko_getalp_org_sparql.classes c1,
    http_kaiko_getalp_org_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_classes_ns AS
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
    http_kaiko_getalp_org_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_kaiko_getalp_org_sparql.classes c
     LEFT JOIN http_kaiko_getalp_org_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_classes_ns_main AS
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
   FROM http_kaiko_getalp_org_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_kaiko_getalp_org_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_classes_ns_plus AS
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
    http_kaiko_getalp_org_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_kaiko_getalp_org_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_kaiko_getalp_org_sparql.classes c
     LEFT JOIN http_kaiko_getalp_org_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_classes_ns_main_plus AS
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
   FROM http_kaiko_getalp_org_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_kaiko_getalp_org_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_kaiko_getalp_org_sparql.v_classes_ns v
     LEFT JOIN http_kaiko_getalp_org_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_cp_rels AS
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
    http_kaiko_getalp_org_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_kaiko_getalp_org_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_kaiko_getalp_org_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_kaiko_getalp_org_sparql.cp_rels r,
    http_kaiko_getalp_org_sparql.classes c,
    http_kaiko_getalp_org_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_cp_rels_card AS
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
   FROM http_kaiko_getalp_org_sparql.cp_rels r,
    http_kaiko_getalp_org_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_properties_ns AS
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
    http_kaiko_getalp_org_sparql.tapprox(p.cnt) AS cnt_x,
    http_kaiko_getalp_org_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_kaiko_getalp_org_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_kaiko_getalp_org_sparql.properties p
     LEFT JOIN http_kaiko_getalp_org_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_cp_sources_single AS
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
   FROM ((http_kaiko_getalp_org_sparql.v_cp_rels_card r
     JOIN http_kaiko_getalp_org_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_kaiko_getalp_org_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_cp_targets_single AS
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
   FROM ((http_kaiko_getalp_org_sparql.v_cp_rels_card r
     JOIN http_kaiko_getalp_org_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_kaiko_getalp_org_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_kaiko_getalp_org_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_kaiko_getalp_org_sparql.pp_rels r,
    http_kaiko_getalp_org_sparql.properties p1,
    http_kaiko_getalp_org_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_properties_sources AS
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
   FROM (http_kaiko_getalp_org_sparql.v_properties_ns v
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
           FROM http_kaiko_getalp_org_sparql.cp_rels r,
            http_kaiko_getalp_org_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_properties_sources_single AS
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
   FROM (http_kaiko_getalp_org_sparql.v_properties_ns v
     LEFT JOIN http_kaiko_getalp_org_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_properties_targets AS
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
   FROM (http_kaiko_getalp_org_sparql.v_properties_ns v
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
           FROM http_kaiko_getalp_org_sparql.cp_rels r,
            http_kaiko_getalp_org_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE VIEW http_kaiko_getalp_org_sparql.v_properties_targets_single AS
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
   FROM (http_kaiko_getalp_org_sparql.v_properties_ns v
     LEFT JOIN http_kaiko_getalp_org_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	4	2	1	\N	\N
2	6	65	1	\N	\N
3	7	92	1	\N	\N
4	8	65	1	\N	\N
5	9	93	1	\N	\N
6	11	102	1	\N	\N
7	15	92	1	\N	\N
8	16	92	1	\N	\N
9	17	37	1	\N	\N
10	17	3	1	\N	\N
11	18	65	1	\N	\N
12	19	32	1	\N	\N
13	20	65	1	\N	\N
14	21	32	1	\N	\N
15	22	3	1	\N	\N
16	29	32	1	\N	\N
17	30	92	1	\N	\N
18	31	92	1	\N	\N
19	32	65	1	\N	\N
20	33	115	1	\N	\N
21	35	41	1	\N	\N
22	36	65	1	\N	\N
23	37	92	1	\N	\N
24	38	37	1	\N	\N
25	38	3	1	\N	\N
26	40	11	1	\N	\N
27	42	25	1	\N	\N
28	44	65	1	\N	\N
29	45	65	1	\N	\N
30	46	37	1	\N	\N
31	46	3	1	\N	\N
32	47	37	1	\N	\N
33	47	3	1	\N	\N
34	48	65	1	\N	\N
35	49	3	1	\N	\N
36	50	25	1	\N	\N
37	53	14	1	\N	\N
38	54	14	1	\N	\N
39	55	14	1	\N	\N
40	56	65	1	\N	\N
41	57	92	1	\N	\N
42	58	65	1	\N	\N
43	59	79	1	\N	\N
44	60	92	1	\N	\N
45	61	92	1	\N	\N
46	62	65	1	\N	\N
47	63	92	1	\N	\N
48	66	99	1	\N	\N
49	71	65	1	\N	\N
50	72	65	1	\N	\N
51	73	92	1	\N	\N
52	74	92	1	\N	\N
53	75	65	1	\N	\N
54	76	65	1	\N	\N
55	77	37	1	\N	\N
56	77	3	1	\N	\N
57	79	65	1	\N	\N
58	80	40	1	\N	\N
59	82	11	1	\N	\N
60	85	25	1	\N	\N
61	86	65	1	\N	\N
62	87	92	1	\N	\N
63	88	100	1	\N	\N
64	88	3	1	\N	\N
65	89	65	1	\N	\N
66	90	37	1	\N	\N
67	90	3	1	\N	\N
68	94	25	1	\N	\N
69	95	92	1	\N	\N
70	96	92	1	\N	\N
71	97	92	1	\N	\N
72	98	92	1	\N	\N
73	99	65	1	\N	\N
74	100	92	1	\N	\N
75	101	32	1	\N	\N
76	102	81	1	\N	\N
77	105	3	1	\N	\N
78	106	37	1	\N	\N
79	106	3	1	\N	\N
80	107	92	1	\N	\N
81	108	65	1	\N	\N
82	109	92	1	\N	\N
83	111	3	1	\N	\N
84	113	115	1	\N	\N
85	116	37	1	\N	\N
86	116	3	1	\N	\N
87	117	37	1	\N	\N
88	117	3	1	\N	\N
89	118	37	1	\N	\N
90	118	3	1	\N	\N
91	119	92	1	\N	\N
92	120	37	1	\N	\N
93	120	3	1	\N	\N
94	121	92	1	\N	\N
95	122	87	1	\N	\N
96	122	3	1	\N	\N
97	124	65	1	\N	\N
98	126	99	1	\N	\N
99	127	3	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	2	8	Ontology	\N
2	2	8	Ontology	\N
3	3	8	NamedIndividual	\N
4	8	8	Affix	de
6	8	8	affiks	af
8	8	8	affisso	it
10	8	8	affix	en
12	8	8	affix	nl
14	8	8	affix	sv
16	8	8	affixe	fr
18	8	8	afijo	es
20	8	8	aplică	ro
22	8	8	аффикс	ru
24	9	8	Measure property	en
25	23	8	FunctionalProperty	\N
26	23	8	FunctionalProperty	\N
27	24	8	Class	\N
28	24	8	Class	\N
29	25	8	Class	\N
30	26	8	List	\N
31	28	8	Document	\N
32	32	8	Mehrwortausdruck	de
34	32	8	espressione di gruppi di parole	it
36	32	8	expresie din mai multe cuvinte	ro
38	32	8	expresión multipalabra	es
40	32	8	expression à mots multiples	fr
42	32	8	flerordsuttryck	sv
44	32	8	multi-word expression	en
46	32	8	multiwoorduitdrukking	af
48	32	8	mutliwoorduitdrukking	nl
50	32	8	словосочетание	ru
52	33	8	SymmetricProperty	\N
53	33	8	SymmetricProperty	\N
54	39	8	Dimension property	en
124	78	8	sens lexical	ro
126	78	8	senso lessicale	it
128	78	8	signification lexicale	fr
55	50	8	Agent Class	en
63	51	8	Form	de
65	51	8	Forma	pt
67	51	8	form	en
69	51	8	form	sv
71	51	8	forma	es
73	51	8	forma	it
75	51	8	forme	fr
77	51	8	formă	ro
79	51	8	vorm	af
81	51	8	vorm	nl
83	51	8	форма	ru
85	52	8	Statement	\N
86	64	8	Datatype	\N
87	65	8	Lexikoneintrag	de
89	65	8	entrada léxica	es
91	65	8	entrata lessicale	it
93	65	8	entrée lexicale	fr
95	65	8	leksikale inskrywing	af
97	65	8	lexical entry	en
99	65	8	lexikaal item	nl
101	65	8	lexikoningång	sv
103	65	8	înregistrare lexicală	ro
105	65	8	словарная единица	ru
107	66	8	modal verb	en
108	67	8	OntologyProperty	\N
109	67	8	OntologyProperty	\N
110	68	8	Restriction	\N
111	68	8	Restriction	\N
112	78	8	acepción léxica	es
114	78	8	leksikale sin	af
116	78	8	lexical sense	en
118	78	8	lexikaal zin	nl
120	78	8	lexikalischer Sinn	de
122	78	8	lexikonbetydelse	sv
130	78	8	лексический смысл	ru
132	79	8	Wort	de
134	79	8	cuvânt	ro
136	79	8	mot	fr
138	79	8	ord	sv
140	79	8	palabra	es
142	79	8	parola	it
144	79	8	woord	af
146	79	8	woord	nl
148	79	8	word	en
150	79	8	слово	ru
152	80	8	Resource	\N
153	83	8	Property	\N
154	92	8	Thing	\N
155	92	8	Thing	\N
156	92	8	Thing	\N
157	93	8	DatatypeProperty	\N
158	93	8	DatatypeProperty	\N
159	103	8	InverseFunctionalProperty	\N
160	103	8	InverseFunctionalProperty	\N
161	111	8	Data structure definition	en
162	113	8	TransitiveProperty	\N
163	113	8	TransitiveProperty	\N
164	114	8	AnnotationProperty	\N
165	114	8	AnnotationProperty	\N
166	115	8	ObjectProperty	\N
167	115	8	ObjectProperty	\N
168	125	8	Lexicon	nl
169	125	8	Lexikon	de
170	125	8	Lexique	fr
171	125	8	Lessico	it
172	125	8	leksikon	af
173	125	8	lexicon	en
174	125	8	lexicon	ro
175	125	8	lexicón	es
176	125	8	lexikon	sv
177	125	8	лексикон	ru
178	126	8	main verb	\N
179	126	8	plain verb	\N
180	126	8	main verb	en
181	127	8	Data set	en
182	128	8	Observation	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://etytree-virtuoso.wmflabs.org/dbnaryetymology#EtymologyEntry	45564	\N	t	76	EtymologyEntry	EtymologyEntry	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68595
2	http://www.w3.org/2002/07/owl#Ontology	26	\N	t	7	Ontology	Ontology	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3319
3	http://www.w3.org/2002/07/owl#NamedIndividual	620	\N	t	7	NamedIndividual	NamedIndividual	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	72239286
4	http://purl.org/vocommons/voaf#Vocabulary	8	\N	t	35	Vocabulary	Vocabulary	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2549
5	http://www.lexinfo.net/ontology/2.0/lexinfo#AbbreviatedForm	531	\N	t	69	AbbreviatedForm	AbbreviatedForm	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25601
6	http://www.lexinfo.net/ontology/2.0/lexinfo#Pronoun	24009	\N	t	69	Pronoun	Pronoun	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	76382
7	http://www.lexinfo.net/ontology/2.0/lexinfo#TemporalQualifier	6	\N	t	69	TemporalQualifier	TemporalQualifier	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	http://www.w3.org/ns/lemon/ontolex#Affix	3350	\N	t	77	Affix	Affix	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8113
9	http://purl.org/linked-data/cube#MeasureProperty	26	\N	t	70	MeasureProperty	MeasureProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	142
10	http://kaiko.getalp.org/dbnary#Translation	11135166	\N	t	78	Translation	Translation	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	http://schema.org/Article	3	\N	t	9	Article	Article	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10
12	http://www.w3.org/2001/vcard-rdf/3.0#internet	26	\N	t	79	internet	internet	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
13	http://purl.org/goodrelations/v1#TypeAndQuantityNode	6	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
14	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	6	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
15	http://www.lexinfo.net/ontology/2.0/lexinfo#Case	64	\N	t	69	Case	Case	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1224
16	http://www.lexinfo.net/ontology/2.0/lexinfo#Dating	4	\N	t	69	Dating	Dating	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://www.lexinfo.net/ontology/2.0/lexinfo#FusedPrepositionPOS	6	\N	t	69	FusedPrepositionPOS	FusedPrepositionPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://www.lexinfo.net/ontology/2.0/lexinfo#Infix	91	\N	t	69	Infix	Infix	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	235
19	http://www.lexinfo.net/ontology/2.0/lexinfo#NounPhrase	306249	\N	t	69	NounPhrase	NounPhrase	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	965656
20	http://www.lexinfo.net/ontology/2.0/lexinfo#Preposition	11956	\N	t	69	Preposition	Preposition	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57580
21	http://www.lexinfo.net/ontology/2.0/lexinfo#PrepositionPhrase	4419	\N	t	69	PrepositionPhrase	PrepositionPhrase	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21769
22	http://kaiko.getalp.org/dbnary#NymProperty	16	\N	t	78	NymProperty	NymProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1453768
23	http://www.w3.org/2002/07/owl#FunctionalProperty	27	\N	t	7	FunctionalProperty	FunctionalProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114
24	http://www.w3.org/2002/07/owl#Class	2089	\N	t	7	Class	Class	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	281250444
25	http://www.w3.org/2000/01/rdf-schema#Class	332	\N	t	2	Class	Class	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	967575
26	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	1	\N	t	1	List	List	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	655
27	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
28	http://xmlns.com/foaf/0.1/Document	6	\N	t	8	Document	Document	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
29	http://www.lexinfo.net/ontology/2.0/lexinfo#AdjectivePhrase	14262	\N	t	69	AdjectivePhrase	AdjectivePhrase	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37096
30	http://www.lexinfo.net/ontology/2.0/lexinfo#ModificationType	6	\N	t	69	ModificationType	ModificationType	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
31	http://www.lexinfo.net/ontology/2.0/lexinfo#Voice	6	\N	t	69	Voice	Voice	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
32	http://www.w3.org/ns/lemon/ontolex#MultiWordExpression	748954	\N	t	77	MultiWordExpression	MultiWordExpression	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2434647
33	http://www.w3.org/2002/07/owl#SymmetricProperty	7	\N	t	7	SymmetricProperty	SymmetricProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
34	http://purl.org/goodrelations/v1#BusinessEntity	2	\N	t	36	BusinessEntity	BusinessEntity	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
35	http://www.w3.org/2001/vcard-rdf/3.0#voice	26	\N	t	79	voice	voice	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
36	http://www.lexinfo.net/ontology/2.0/lexinfo#Numeral	21804	\N	t	69	Numeral	Numeral	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91802
37	http://www.lexinfo.net/ontology/2.0/lexinfo#PartOfSpeech	226	\N	t	69	PartOfSpeech	PartOfSpeech	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	38298126
38	http://www.lexinfo.net/ontology/2.0/lexinfo#ParticlePOS	28	\N	t	69	ParticlePOS	ParticlePOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9668
39	http://purl.org/linked-data/cube#DimensionProperty	9	\N	t	70	DimensionProperty	DimensionProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	120
40	http://www.w3.org/ns/ldp#Resource	1	\N	t	74	Resource	Resource	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://www.w3.org/2001/vcard-rdf/3.0#work	26	\N	t	79	work	work	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
42	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
43	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	6	\N	t	7	inverseFunctionalProperty	inverseFunctionalProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
44	http://www.lexinfo.net/ontology/2.0/lexinfo#Affix	1318	\N	t	69	Affix	Affix	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13853
45	http://www.lexinfo.net/ontology/2.0/lexinfo#Interjection	15313	\N	t	69	Interjection	Interjection	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53679
46	http://www.lexinfo.net/ontology/2.0/lexinfo#NounPOS	10	\N	t	69	NounPOS	NounPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19766104
47	http://www.lexinfo.net/ontology/2.0/lexinfo#NumeralPOS	22	\N	t	69	NumeralPOS	NumeralPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56584
48	http://www.lexinfo.net/ontology/2.0/lexinfo#Suffix	15789	\N	t	69	Suffix	Suffix	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	71875
49	http://www.lexinfo.net/ontology/2.0/lexinfo#Tense	10	\N	t	69	Tense	Tense	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6264986
50	http://purl.org/dc/terms/AgentClass	8	\N	t	5	AgentClass	AgentClass	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	304
51	http://www.w3.org/ns/lemon/ontolex#Form	32771703	\N	t	77	Form	Form	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32772026
52	http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement	837080	\N	t	1	Statement	Statement	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
53	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	2	\N	t	80	C_AKJ315005-tax	C_AKJ315005-tax	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
54	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	2	\N	t	80	C_AAB316003-tax	C_AAB316003-tax	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
55	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	2	\N	t	80	C_AKE112003-tax	C_AKE112003-tax	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
56	http://www.lexinfo.net/ontology/2.0/lexinfo#Adverb	168761	\N	t	69	Adverb	Adverb	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	448131
57	http://www.lexinfo.net/ontology/2.0/lexinfo#Aspect	10	\N	t	69	Aspect	Aspect	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	271200
58	http://www.lexinfo.net/ontology/2.0/lexinfo#Conjunction	5882	\N	t	69	Conjunction	Conjunction	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25903
59	http://www.lexinfo.net/ontology/2.0/lexinfo#Determiner	5073	\N	t	69	Determiner	Determiner	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20420
60	http://www.lexinfo.net/ontology/2.0/lexinfo#Frequency	6	\N	t	69	Frequency	Frequency	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1488
61	http://www.lexinfo.net/ontology/2.0/lexinfo#NormativeAuthorization	14	\N	t	69	NormativeAuthorization	NormativeAuthorization	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
62	http://www.lexinfo.net/ontology/2.0/lexinfo#Particle	427111	\N	t	69	Particle	Particle	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	880484
63	http://www.lexinfo.net/ontology/2.0/lexinfo#TermElement	22	\N	t	69	TermElement	TermElement	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67354
64	http://www.w3.org/2000/01/rdf-schema#Datatype	103	\N	t	2	Datatype	Datatype	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	115
65	http://www.w3.org/ns/lemon/ontolex#LexicalEntry	20892348	\N	t	77	LexicalEntry	LexicalEntry	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56039199
66	http://purl.org/olia/olia.owl#ModalVerb	2	\N	t	81	ModalVerb	ModalVerb	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	180
67	http://www.w3.org/2002/07/owl#OntologyProperty	9	\N	t	7	OntologyProperty	OntologyProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
68	http://www.w3.org/2002/07/owl#Restriction	681	\N	t	7	Restriction	Restriction	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	681
69	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
70	http://www.openlinksw.com/schemas/VSPX#	1	\N	t	82			215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
71	http://www.lexinfo.net/ontology/2.0/lexinfo#Adjective	1365952	\N	t	69	Adjective	Adjective	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3591060
72	http://www.lexinfo.net/ontology/2.0/lexinfo#Adposition	7	\N	t	69	Adposition	Adposition	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
73	http://www.lexinfo.net/ontology/2.0/lexinfo#Animacy	6	\N	t	69	Animacy	Animacy	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
74	http://www.lexinfo.net/ontology/2.0/lexinfo#Finiteness	4	\N	t	69	Finiteness	Finiteness	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://www.lexinfo.net/ontology/2.0/lexinfo#Noun	5318526	\N	t	69	Noun	Noun	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15157593
76	http://www.lexinfo.net/ontology/2.0/lexinfo#Symbol	2532	\N	t	69	Symbol	Symbol	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6846
77	http://www.lexinfo.net/ontology/2.0/lexinfo#VerbPOS	14	\N	t	69	VerbPOS	VerbPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13770740
78	http://www.w3.org/ns/lemon/ontolex#LexicalSense	14880090	\N	t	77	LexicalSense	LexicalSense	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22724400
79	http://www.w3.org/ns/lemon/ontolex#Word	10201099	\N	t	77	Word	Word	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28015203
80	http://www.w3.org/2000/01/rdf-schema#Resource	1	\N	t	2	Resource	Resource	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
81	http://schema.org/TechArticle	6	\N	t	9	TechArticle	TechArticle	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
82	http://schema.org/WebPage	1	\N	t	9	WebPage	WebPage	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10
83	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	1109	\N	t	1	Property	Property	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4367
84	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	2	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
85	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
86	http://www.lexinfo.net/ontology/2.0/lexinfo#Article	743	\N	t	69	Article	Article	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2644
87	http://www.lexinfo.net/ontology/2.0/lexinfo#Cliticness	6	\N	t	69	Cliticness	Cliticness	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
88	http://www.lexinfo.net/ontology/2.0/lexinfo#Mood	6	\N	t	69	Mood	Mood	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4609700
89	http://www.lexinfo.net/ontology/2.0/lexinfo#Prefix	9718	\N	t	69	Prefix	Prefix	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	55572
90	http://www.lexinfo.net/ontology/2.0/lexinfo#PronounPOS	52	\N	t	69	PronounPOS	PronounPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	59810
91	http://kaiko.getalp.org/dbnary#Gloss	1080545	\N	t	78	Gloss	Gloss	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7996308
92	http://www.w3.org/2002/07/owl#Thing	542	\N	t	7	Thing	Thing	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	70106124
93	http://www.w3.org/2002/07/owl#DatatypeProperty	320	\N	t	7	DatatypeProperty	DatatypeProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	914
94	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32
95	http://www.lexinfo.net/ontology/2.0/lexinfo#Degree	6	\N	t	69	Degree	Degree	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
96	http://www.lexinfo.net/ontology/2.0/lexinfo#ReferentType	4	\N	t	69	ReferentType	ReferentType	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1306748
97	http://www.lexinfo.net/ontology/2.0/lexinfo#SymbolPOS	28	\N	t	69	SymbolPOS	SymbolPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4532
98	http://www.lexinfo.net/ontology/2.0/lexinfo#TermType	64	\N	t	69	TermType	TermType	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159244
99	http://www.lexinfo.net/ontology/2.0/lexinfo#Verb	5887058	\N	t	69	Verb	Verb	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12744577
100	http://www.lexinfo.net/ontology/2.0/lexinfo#VerbFormMood	14	\N	t	69	VerbFormMood	VerbFormMood	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7351160
101	http://www.lexinfo.net/ontology/2.0/lexinfo#VerbPhrase	89650	\N	t	69	VerbPhrase	VerbPhrase	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	236936
102	http://schema.org/CreativeWork	5	\N	t	9	CreativeWork	CreativeWork	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
103	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	24	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	71
104	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
105	http://www.lexinfo.net/ontology/2.0/lexinfo#AdjectivePOS	18	\N	t	69	AdjectivePOS	AdjectivePOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3933944
106	http://www.lexinfo.net/ontology/2.0/lexinfo#ArticlePOS	6	\N	t	69	ArticlePOS	ArticlePOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1908
107	http://www.lexinfo.net/ontology/2.0/lexinfo#Person	6	\N	t	69	Person	Person	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6259310
108	http://www.lexinfo.net/ontology/2.0/lexinfo#ProperNoun	411171	\N	t	69	ProperNoun	ProperNoun	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1167721
109	http://www.lexinfo.net/ontology/2.0/lexinfo#Register	22	\N	t	69	Register	Register	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
110	http://purl.org/dc/dcam/VocabularyEncodingScheme	72	\N	t	72	VocabularyEncodingScheme	VocabularyEncodingScheme	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
111	http://purl.org/linked-data/cube#DataStructureDefinition	10	\N	t	70	DataStructureDefinition	DataStructureDefinition	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
112	http://kaiko.getalp.org/dbnary#Page	20201416	\N	t	78	Page	Page	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5147317
113	http://www.w3.org/2002/07/owl#TransitiveProperty	6	\N	t	7	TransitiveProperty	TransitiveProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	300484
114	http://www.w3.org/2002/07/owl#AnnotationProperty	75	\N	t	7	AnnotationProperty	AnnotationProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	322
115	http://www.w3.org/2002/07/owl#ObjectProperty	629	\N	t	7	ObjectProperty	ObjectProperty	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1760577
116	http://www.lexinfo.net/ontology/2.0/lexinfo#AdpositionPOS	10	\N	t	69	AdpositionPOS	AdpositionPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	35710
117	http://www.lexinfo.net/ontology/2.0/lexinfo#AdverbPOS	8	\N	t	69	AdverbPOS	AdverbPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	588078
118	http://www.lexinfo.net/ontology/2.0/lexinfo#ConjunctionPOS	6	\N	t	69	ConjunctionPOS	ConjunctionPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17070
119	http://www.lexinfo.net/ontology/2.0/lexinfo#Definiteness	8	\N	t	69	Definiteness	Definiteness	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	132
120	http://www.lexinfo.net/ontology/2.0/lexinfo#DeterminerPOS	22	\N	t	69	DeterminerPOS	DeterminerPOS	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12524
121	http://www.lexinfo.net/ontology/2.0/lexinfo#Gender	10	\N	t	69	Gender	Gender	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4103964
122	http://www.lexinfo.net/ontology/2.0/lexinfo#Negative	4	\N	t	69	Negative	Negative	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
123	http://www.lexinfo.net/ontology/2.0/lexinfo#Number	466	\N	t	69	Number	Number	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6462477
124	http://www.lexinfo.net/ontology/2.0/lexinfo#Postposition	1753	\N	t	69	Postposition	Postposition	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4640
125	http://www.w3.org/ns/lemon/lime#Lexicon	50	\N	t	83	Lexicon	Lexicon	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
126	http://purl.org/olia/olia.owl#MainVerb	2	\N	t	81	MainVerb	MainVerb	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	131
127	http://purl.org/linked-data/cube#DataSet	10	\N	t	70	DataSet	DataSet	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	233118
128	http://purl.org/linked-data/cube#Observation	116559	\N	t	70	Observation	Observation	215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	125	1	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
2	51	2	2	1733464	\N	0	\N	\N	1	1	2	f	1733464	\N	\N
3	52	2	2	151022	\N	0	\N	\N	2	1	2	f	151022	\N	\N
4	78	2	2	160	\N	0	\N	\N	3	1	2	f	160	\N	\N
5	51	3	2	592	\N	592	\N	\N	1	1	2	f	0	\N	\N
6	15	3	1	1184	\N	1184	\N	\N	1	1	2	f	\N	\N	\N
7	92	3	1	1184	\N	1184	\N	\N	0	1	2	f	\N	\N	\N
8	3	3	1	1184	\N	1184	\N	\N	0	1	2	f	\N	\N	\N
9	102	4	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
10	28	4	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
11	81	4	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
12	51	5	2	3132493	\N	3132493	\N	\N	1	1	2	f	0	\N	\N
13	49	5	1	6264986	\N	6264986	\N	\N	1	1	2	f	\N	\N	\N
14	3	5	1	6264986	\N	6264986	\N	\N	0	1	2	f	\N	\N	\N
15	92	5	1	5821372	\N	5821372	\N	\N	0	1	2	f	\N	\N	\N
16	10	6	2	34420	\N	0	\N	\N	1	1	2	f	34420	\N	\N
17	112	7	2	21391441	\N	21391441	\N	\N	1	1	2	f	0	\N	\N
18	1	7	2	27278	\N	27278	\N	\N	2	1	2	f	0	\N	\N
19	65	7	1	20755485	\N	20755485	\N	\N	1	1	2	f	\N	\N	\N
20	1	7	1	2329	\N	2329	\N	\N	2	1	2	f	\N	\N	\N
21	79	7	1	10207579	\N	10207579	\N	\N	0	1	2	f	\N	\N	\N
22	99	7	1	5888008	\N	5888008	\N	\N	0	1	2	f	\N	\N	\N
23	75	7	1	5321767	\N	5321767	\N	\N	0	1	2	f	\N	\N	\N
24	71	7	1	1367266	\N	1367266	\N	\N	0	1	2	f	\N	\N	\N
25	32	7	1	759200	\N	759200	\N	\N	0	1	2	f	\N	\N	\N
26	62	7	1	427125	\N	427125	\N	\N	0	1	2	f	\N	\N	\N
27	108	7	1	411589	\N	411589	\N	\N	0	1	2	f	\N	\N	\N
28	19	7	1	314367	\N	314367	\N	\N	0	1	2	f	\N	\N	\N
29	56	7	1	168990	\N	168990	\N	\N	0	1	2	f	\N	\N	\N
30	101	7	1	90160	\N	90160	\N	\N	0	1	2	f	\N	\N	\N
31	6	7	1	24046	\N	24046	\N	\N	0	1	2	f	\N	\N	\N
32	36	7	1	21860	\N	21860	\N	\N	0	1	2	f	\N	\N	\N
33	48	7	1	15800	\N	15800	\N	\N	0	1	2	f	\N	\N	\N
34	45	7	1	15390	\N	15390	\N	\N	0	1	2	f	\N	\N	\N
35	29	7	1	14487	\N	14487	\N	\N	0	1	2	f	\N	\N	\N
36	20	7	1	11993	\N	11993	\N	\N	0	1	2	f	\N	\N	\N
37	89	7	1	9736	\N	9736	\N	\N	0	1	2	f	\N	\N	\N
38	58	7	1	5897	\N	5897	\N	\N	0	1	2	f	\N	\N	\N
39	59	7	1	5103	\N	5103	\N	\N	0	1	2	f	\N	\N	\N
40	21	7	1	4480	\N	4480	\N	\N	0	1	2	f	\N	\N	\N
41	8	7	1	3350	\N	3350	\N	\N	0	1	2	f	\N	\N	\N
42	76	7	1	2538	\N	2538	\N	\N	0	1	2	f	\N	\N	\N
43	124	7	1	1753	\N	1753	\N	\N	0	1	2	f	\N	\N	\N
44	44	7	1	1318	\N	1318	\N	\N	0	1	2	f	\N	\N	\N
45	86	7	1	749	\N	749	\N	\N	0	1	2	f	\N	\N	\N
46	5	7	1	519	\N	519	\N	\N	0	1	2	f	\N	\N	\N
47	123	7	1	458	\N	458	\N	\N	0	1	2	f	\N	\N	\N
48	18	7	1	91	\N	91	\N	\N	0	1	2	f	\N	\N	\N
49	72	7	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
50	66	7	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
51	126	7	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
52	102	8	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
53	2	8	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
54	81	8	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
55	11	8	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
56	28	8	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
57	82	8	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
58	80	8	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
59	40	8	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
60	10	9	2	11136841	\N	0	\N	\N	1	1	2	f	11136841	\N	\N
61	69	10	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
62	51	11	2	3284069	\N	3284069	\N	\N	1	1	2	f	0	\N	\N
63	3	11	1	6568098	\N	6568098	\N	\N	1	1	2	f	\N	\N	\N
64	24	11	1	40	\N	40	\N	\N	2	1	2	f	\N	\N	\N
65	92	11	1	6568098	\N	6568098	\N	\N	0	1	2	f	\N	\N	\N
66	100	11	1	6296898	\N	6296898	\N	\N	0	1	2	f	\N	\N	\N
67	88	11	1	4609698	\N	4609698	\N	\N	0	1	2	f	\N	\N	\N
68	57	11	1	271200	\N	271200	\N	\N	0	1	2	f	\N	\N	\N
69	102	12	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
70	28	12	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
71	81	12	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
72	11	12	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
73	80	12	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
74	40	12	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
75	81	12	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
76	28	12	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
77	11	12	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
78	102	12	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
79	82	12	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
80	128	13	2	116587	\N	0	\N	\N	1	1	2	f	116587	\N	\N
81	24	14	2	1197	\N	1197	\N	\N	1	1	2	f	0	\N	\N
82	34	14	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
83	27	14	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
84	25	14	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
85	24	14	1	496	\N	496	\N	\N	1	1	2	f	\N	\N	\N
86	68	14	1	136	\N	136	\N	\N	2	1	2	f	\N	\N	\N
87	50	14	1	16	\N	16	\N	\N	3	1	2	f	\N	\N	\N
88	25	14	1	30	\N	30	\N	\N	0	1	2	f	\N	\N	\N
89	3	15	2	1136	\N	0	\N	\N	1	1	2	f	1136	\N	\N
90	115	15	2	244	\N	0	\N	\N	2	1	2	f	244	\N	\N
91	93	15	2	20	\N	4	\N	\N	3	1	2	f	16	\N	\N
92	92	15	2	1136	\N	0	\N	\N	0	1	2	f	1136	\N	\N
93	37	15	2	464	\N	0	\N	\N	0	1	2	f	464	\N	\N
94	15	15	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
95	98	15	2	124	\N	0	\N	\N	0	1	2	f	124	\N	\N
96	90	15	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
97	38	15	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
98	97	15	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
99	123	15	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
100	120	15	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
101	109	15	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
102	47	15	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
103	100	15	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
104	121	15	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
105	105	15	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
106	61	15	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
107	63	15	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
108	46	15	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
109	77	15	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
110	73	15	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
111	60	15	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
112	88	15	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
113	5	15	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
114	116	15	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
115	57	15	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
116	117	15	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
117	106	15	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
118	119	15	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
119	49	15	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
120	31	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
121	7	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
122	87	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
123	95	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
124	118	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
125	107	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
126	17	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
127	30	15	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
128	74	15	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
129	16	15	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
130	122	15	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
131	96	15	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
132	65	16	2	675	\N	0	\N	\N	1	1	2	f	675	\N	\N
133	69	17	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
134	42	17	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
135	24	17	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
136	25	17	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
137	2	18	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
138	69	19	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
139	28	20	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
140	2	20	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
141	128	21	2	2154	\N	0	\N	\N	1	1	2	f	2154	\N	\N
142	2	22	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
143	4	22	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
144	125	23	2	150	\N	0	\N	\N	1	1	2	f	150	\N	\N
145	68	24	2	44	\N	0	\N	\N	1	1	2	f	44	\N	\N
146	2	25	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
147	24	26	2	240	\N	0	\N	\N	1	1	2	f	240	\N	\N
148	69	27	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
149	34	28	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
150	125	29	2	50	\N	50	\N	\N	1	1	2	f	0	\N	\N
151	2	29	2	11	\N	9	\N	\N	2	1	2	f	2	\N	\N
152	3	29	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
153	4	29	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
154	51	30	2	2837584	\N	2837584	\N	\N	1	1	2	f	0	\N	\N
155	24	30	1	2837580	\N	2837580	\N	\N	1	1	2	f	\N	\N	\N
156	2	31	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
157	4	31	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
158	102	32	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
159	28	32	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
160	81	32	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
161	11	32	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
162	80	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
163	40	32	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
164	2	32	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
165	10	33	2	2905214	\N	0	\N	\N	1	1	2	f	2905214	\N	\N
166	52	33	2	19493	\N	0	\N	\N	2	1	2	f	19493	\N	\N
167	51	34	2	9092770	\N	0	\N	\N	1	1	2	f	9092770	\N	\N
168	125	35	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
169	34	35	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
170	2	35	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
171	2	36	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
172	34	36	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
173	65	37	2	499	\N	499	\N	\N	1	1	2	f	0	\N	\N
174	99	37	2	465	\N	465	\N	\N	0	1	2	f	0	\N	\N
175	24	37	1	499	\N	499	\N	\N	1	1	2	f	\N	\N	\N
176	34	38	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
177	55	38	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
178	14	38	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
179	2	39	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
180	51	40	2	653374	\N	653374	\N	\N	1	1	2	f	0	\N	\N
181	96	40	1	1306748	\N	1306748	\N	\N	1	1	2	f	\N	\N	\N
182	92	40	1	1306748	\N	1306748	\N	\N	0	1	2	f	\N	\N	\N
183	3	40	1	1306748	\N	1306748	\N	\N	0	1	2	f	\N	\N	\N
184	51	41	2	7974109	\N	7974109	\N	\N	1	1	2	f	0	\N	\N
185	24	41	1	7974105	\N	7974105	\N	\N	1	1	2	f	\N	\N	\N
186	2	42	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
187	81	42	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
188	28	42	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
189	11	42	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
190	102	42	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
191	82	42	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
192	128	43	2	116587	\N	116587	\N	\N	1	1	2	f	0	\N	\N
193	127	43	1	233118	\N	233118	\N	\N	1	1	2	f	\N	\N	\N
194	3	43	1	233118	\N	233118	\N	\N	0	1	2	f	\N	\N	\N
195	83	44	2	1664	\N	1664	\N	\N	1	1	2	f	0	\N	\N
196	114	44	2	72	\N	72	\N	\N	0	1	2	f	0	\N	\N
197	50	44	1	256	\N	256	\N	\N	1	1	2	f	\N	\N	\N
198	64	44	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
199	24	44	1	16	\N	16	\N	\N	3	1	2	f	\N	\N	\N
200	25	44	1	1536	\N	1536	\N	\N	0	1	2	f	\N	\N	\N
201	125	45	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
202	2	45	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
203	70	45	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
204	3	45	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
205	4	45	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
206	28	46	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
207	102	46	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
208	81	46	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
209	128	47	2	4308	\N	0	\N	\N	1	1	2	f	4308	\N	\N
210	51	48	2	1824620	\N	1824620	\N	\N	1	1	2	f	0	\N	\N
211	65	48	2	227382	\N	227382	\N	\N	2	1	2	f	0	\N	\N
212	75	48	2	226771	\N	226771	\N	\N	0	1	2	f	0	\N	\N
213	108	48	2	4510	\N	4510	\N	\N	0	1	2	f	0	\N	\N
214	32	48	2	2223	\N	2223	\N	\N	0	1	2	f	0	\N	\N
215	76	48	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
216	6	48	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
217	48	48	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
218	71	48	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
219	99	48	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
220	45	48	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
221	86	48	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
222	56	48	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
223	121	48	1	4103964	\N	4103964	\N	\N	1	1	2	f	\N	\N	\N
224	92	48	1	4103964	\N	4103964	\N	\N	0	1	2	f	\N	\N	\N
225	3	48	1	4103964	\N	4103964	\N	\N	0	1	2	f	\N	\N	\N
226	83	49	2	5439	\N	5439	\N	\N	1	1	2	f	0	\N	\N
227	115	49	2	709	\N	709	\N	\N	2	1	2	f	0	\N	\N
228	114	49	2	278	\N	278	\N	\N	3	1	2	f	0	\N	\N
229	93	49	2	122	\N	122	\N	\N	4	1	2	f	0	\N	\N
230	103	49	2	20	\N	20	\N	\N	5	1	2	f	0	\N	\N
231	43	49	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
232	24	49	2	2	\N	2	\N	\N	6	1	2	f	0	\N	\N
233	33	49	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
234	23	49	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
235	113	49	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
236	25	49	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
237	83	49	1	3096	\N	3096	\N	\N	1	1	2	f	\N	\N	\N
238	115	49	1	725	\N	725	\N	\N	2	1	2	f	\N	\N	\N
239	114	49	1	272	\N	272	\N	\N	3	1	2	f	\N	\N	\N
240	93	49	1	61	\N	61	\N	\N	4	1	2	f	\N	\N	\N
241	24	49	1	2	\N	2	\N	\N	5	1	2	f	\N	\N	\N
242	43	49	1	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
243	103	49	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
244	113	49	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
245	33	49	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
246	25	49	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
247	34	50	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
248	102	50	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
249	28	50	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
250	81	50	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
251	102	50	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
252	28	50	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
253	81	50	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
254	91	51	2	626375	\N	0	\N	\N	1	1	2	f	626375	\N	\N
255	1	52	2	57542	\N	57542	\N	\N	1	1	2	f	0	\N	\N
256	1	52	1	36071	\N	36071	\N	\N	1	1	2	f	\N	\N	\N
257	102	53	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
258	28	53	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
259	81	53	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
260	24	54	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
261	115	54	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
262	128	55	2	116587	\N	0	\N	\N	1	1	2	f	116587	\N	\N
263	125	55	2	50	\N	0	\N	\N	2	1	2	f	50	\N	\N
264	24	56	1	2099	\N	2099	\N	\N	1	1	2	f	\N	\N	\N
265	68	56	1	369	\N	369	\N	\N	2	1	2	f	\N	\N	\N
266	115	56	1	97	\N	97	\N	\N	3	1	2	f	\N	\N	\N
267	26	56	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
268	103	56	1	48	\N	48	\N	\N	0	1	2	f	\N	\N	\N
269	25	56	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
270	23	56	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
271	65	57	2	20739092	\N	20739092	\N	\N	1	1	2	f	0	\N	\N
272	125	57	2	50	\N	50	\N	\N	2	1	2	f	0	\N	\N
273	79	57	2	10201385	\N	10201385	\N	\N	0	1	2	f	0	\N	\N
274	99	57	2	5887076	\N	5887076	\N	\N	0	1	2	f	0	\N	\N
275	75	57	2	5318600	\N	5318600	\N	\N	0	1	2	f	0	\N	\N
276	71	57	2	1365974	\N	1365974	\N	\N	0	1	2	f	0	\N	\N
277	32	57	2	748996	\N	748996	\N	\N	0	1	2	f	0	\N	\N
278	62	57	2	427113	\N	427113	\N	\N	0	1	2	f	0	\N	\N
279	108	57	2	411181	\N	411181	\N	\N	0	1	2	f	0	\N	\N
280	19	57	2	306253	\N	306253	\N	\N	0	1	2	f	0	\N	\N
281	56	57	2	168761	\N	168761	\N	\N	0	1	2	f	0	\N	\N
282	101	57	2	89652	\N	89652	\N	\N	0	1	2	f	0	\N	\N
283	6	57	2	24009	\N	24009	\N	\N	0	1	2	f	0	\N	\N
284	36	57	2	21808	\N	21808	\N	\N	0	1	2	f	0	\N	\N
285	48	57	2	15789	\N	15789	\N	\N	0	1	2	f	0	\N	\N
286	45	57	2	15313	\N	15313	\N	\N	0	1	2	f	0	\N	\N
287	29	57	2	14262	\N	14262	\N	\N	0	1	2	f	0	\N	\N
288	20	57	2	11958	\N	11958	\N	\N	0	1	2	f	0	\N	\N
289	89	57	2	9718	\N	9718	\N	\N	0	1	2	f	0	\N	\N
290	58	57	2	5882	\N	5882	\N	\N	0	1	2	f	0	\N	\N
291	59	57	2	5077	\N	5077	\N	\N	0	1	2	f	0	\N	\N
292	21	57	2	4419	\N	4419	\N	\N	0	1	2	f	0	\N	\N
293	8	57	2	3350	\N	3350	\N	\N	0	1	2	f	0	\N	\N
294	76	57	2	2532	\N	2532	\N	\N	0	1	2	f	0	\N	\N
295	124	57	2	1753	\N	1753	\N	\N	0	1	2	f	0	\N	\N
296	44	57	2	1318	\N	1318	\N	\N	0	1	2	f	0	\N	\N
297	86	57	2	743	\N	743	\N	\N	0	1	2	f	0	\N	\N
298	5	57	2	519	\N	519	\N	\N	0	1	2	f	0	\N	\N
299	123	57	2	448	\N	448	\N	\N	0	1	2	f	0	\N	\N
300	18	57	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
301	72	57	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
302	66	57	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
303	126	57	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
304	51	58	2	5192	\N	5192	\N	\N	1	1	2	f	0	\N	\N
305	24	58	1	5192	\N	5192	\N	\N	1	1	2	f	\N	\N	\N
306	34	59	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
307	69	59	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
308	51	60	2	4122587	\N	4122587	\N	\N	1	1	2	f	0	\N	\N
309	24	60	1	4122587	\N	4122587	\N	\N	1	1	2	f	\N	\N	\N
310	63	61	2	32800	\N	0	\N	\N	1	1	2	f	32800	\N	\N
311	92	61	2	32800	\N	0	\N	\N	0	1	2	f	32800	\N	\N
312	3	61	2	32800	\N	0	\N	\N	0	1	2	f	32800	\N	\N
313	78	62	2	2478170	\N	2478170	\N	\N	1	1	2	f	0	\N	\N
314	24	62	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
315	114	62	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
316	83	62	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
317	68	63	2	174	\N	0	\N	\N	1	1	2	f	174	\N	\N
318	70	64	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
319	83	65	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
320	93	65	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
321	25	65	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
322	65	66	2	20739489	\N	0	\N	\N	1	1	2	f	20739489	\N	\N
323	1	66	2	43243	\N	0	\N	\N	2	1	2	f	43243	\N	\N
324	83	66	2	4513	\N	0	\N	\N	3	1	2	f	4513	\N	\N
325	24	66	2	1908	\N	0	\N	\N	4	1	2	f	1908	\N	\N
326	115	66	2	1801	\N	0	\N	\N	5	1	2	f	1801	\N	\N
327	3	66	2	1150	\N	0	\N	\N	6	1	2	f	1150	\N	\N
328	64	66	2	775	\N	0	\N	\N	7	1	2	f	775	\N	\N
329	93	66	2	629	\N	0	\N	\N	8	1	2	f	629	\N	\N
330	110	66	2	576	\N	0	\N	\N	9	1	2	f	576	\N	\N
331	114	66	2	204	\N	0	\N	\N	10	1	2	f	204	\N	\N
332	50	66	2	64	\N	0	\N	\N	11	1	2	f	64	\N	\N
333	67	66	2	17	\N	0	\N	\N	12	1	2	f	17	\N	\N
334	2	66	2	17	\N	0	\N	\N	13	1	2	f	17	\N	\N
335	81	66	2	6	\N	0	\N	\N	14	1	2	f	6	\N	\N
336	84	66	2	4	\N	0	\N	\N	15	1	2	f	4	\N	\N
337	26	66	2	1	\N	0	\N	\N	16	1	2	f	1	\N	\N
338	79	66	2	10201584	\N	0	\N	\N	0	1	2	f	10201584	\N	\N
339	99	66	2	5887091	\N	0	\N	\N	0	1	2	f	5887091	\N	\N
340	75	66	2	5318669	\N	0	\N	\N	0	1	2	f	5318669	\N	\N
341	71	66	2	1366017	\N	0	\N	\N	0	1	2	f	1366017	\N	\N
342	32	66	2	748999	\N	0	\N	\N	0	1	2	f	748999	\N	\N
343	62	66	2	427114	\N	0	\N	\N	0	1	2	f	427114	\N	\N
344	108	66	2	411199	\N	0	\N	\N	0	1	2	f	411199	\N	\N
345	19	66	2	306253	\N	0	\N	\N	0	1	2	f	306253	\N	\N
346	56	66	2	168773	\N	0	\N	\N	0	1	2	f	168773	\N	\N
347	101	66	2	89652	\N	0	\N	\N	0	1	2	f	89652	\N	\N
348	6	66	2	24013	\N	0	\N	\N	0	1	2	f	24013	\N	\N
349	36	66	2	21808	\N	0	\N	\N	0	1	2	f	21808	\N	\N
350	48	66	2	15789	\N	0	\N	\N	0	1	2	f	15789	\N	\N
351	45	66	2	15315	\N	0	\N	\N	0	1	2	f	15315	\N	\N
352	29	66	2	14262	\N	0	\N	\N	0	1	2	f	14262	\N	\N
353	20	66	2	11959	\N	0	\N	\N	0	1	2	f	11959	\N	\N
354	89	66	2	9718	\N	0	\N	\N	0	1	2	f	9718	\N	\N
355	58	66	2	5885	\N	0	\N	\N	0	1	2	f	5885	\N	\N
356	59	66	2	5077	\N	0	\N	\N	0	1	2	f	5077	\N	\N
357	21	66	2	4419	\N	0	\N	\N	0	1	2	f	4419	\N	\N
358	8	66	2	3350	\N	0	\N	\N	0	1	2	f	3350	\N	\N
359	76	66	2	2535	\N	0	\N	\N	0	1	2	f	2535	\N	\N
360	124	66	2	1753	\N	0	\N	\N	0	1	2	f	1753	\N	\N
361	25	66	2	1725	\N	0	\N	\N	0	1	2	f	1725	\N	\N
362	44	66	2	1318	\N	0	\N	\N	0	1	2	f	1318	\N	\N
363	92	66	2	1060	\N	0	\N	\N	0	1	2	f	1060	\N	\N
364	86	66	2	743	\N	0	\N	\N	0	1	2	f	743	\N	\N
365	5	66	2	539	\N	0	\N	\N	0	1	2	f	539	\N	\N
366	123	66	2	488	\N	0	\N	\N	0	1	2	f	488	\N	\N
367	37	66	2	460	\N	0	\N	\N	0	1	2	f	460	\N	\N
368	23	66	2	218	\N	0	\N	\N	0	1	2	f	218	\N	\N
369	15	66	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
370	103	66	2	126	\N	0	\N	\N	0	1	2	f	126	\N	\N
371	98	66	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
372	90	66	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
373	18	66	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
374	9	66	2	70	\N	0	\N	\N	0	1	2	f	70	\N	\N
375	38	66	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
376	97	66	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
377	120	66	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
378	47	66	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
379	105	66	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
380	61	66	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
381	63	66	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
382	46	66	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
383	77	66	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
384	33	66	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
385	109	66	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
386	60	66	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
387	100	66	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
388	116	66	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
389	57	66	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
390	121	66	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
391	39	66	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
392	117	66	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
393	73	66	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
394	119	66	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
395	49	66	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
396	31	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
397	7	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
398	106	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
399	87	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
400	95	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
401	118	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
402	107	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
403	17	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
404	88	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
405	30	66	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
406	43	66	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
407	113	66	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
408	74	66	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
409	16	66	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
410	122	66	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
411	96	66	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
412	72	66	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
413	102	66	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
414	4	66	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
415	11	66	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
416	28	66	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
417	85	66	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
418	94	66	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
419	42	66	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
420	66	66	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
421	126	66	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
422	82	66	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
423	80	66	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
424	40	66	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
425	125	67	2	100	\N	0	\N	\N	1	1	2	f	100	\N	\N
426	2	67	2	12	\N	0	\N	\N	2	1	2	f	12	\N	\N
427	4	67	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
428	3	67	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
429	68	68	2	75	\N	60	\N	\N	1	1	2	f	15	\N	\N
430	3	68	1	120	\N	120	\N	\N	1	1	2	f	\N	\N	\N
431	92	68	1	120	\N	120	\N	\N	0	1	2	f	\N	\N	\N
432	37	68	1	50	\N	50	\N	\N	0	1	2	f	\N	\N	\N
433	15	68	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
434	63	68	1	30	\N	30	\N	\N	0	1	2	f	\N	\N	\N
435	46	68	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
436	116	68	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
437	52	69	2	837932	\N	837932	\N	\N	1	1	2	f	0	\N	\N
438	112	69	1	765661	\N	765661	\N	\N	1	1	2	f	\N	\N	\N
439	65	69	1	150246	\N	150246	\N	\N	2	1	2	f	\N	\N	\N
440	79	69	1	140451	\N	140451	\N	\N	0	1	2	f	\N	\N	\N
441	75	69	1	85531	\N	85531	\N	\N	0	1	2	f	\N	\N	\N
442	99	69	1	34667	\N	34667	\N	\N	0	1	2	f	\N	\N	\N
443	71	69	1	10670	\N	10670	\N	\N	0	1	2	f	\N	\N	\N
444	108	69	1	5770	\N	5770	\N	\N	0	1	2	f	\N	\N	\N
445	44	69	1	4771	\N	4771	\N	\N	0	1	2	f	\N	\N	\N
446	32	69	1	1684	\N	1684	\N	\N	0	1	2	f	\N	\N	\N
447	89	69	1	1671	\N	1671	\N	\N	0	1	2	f	\N	\N	\N
448	48	69	1	1669	\N	1669	\N	\N	0	1	2	f	\N	\N	\N
449	56	69	1	1244	\N	1244	\N	\N	0	1	2	f	\N	\N	\N
450	19	69	1	747	\N	747	\N	\N	0	1	2	f	\N	\N	\N
451	36	69	1	695	\N	695	\N	\N	0	1	2	f	\N	\N	\N
452	20	69	1	599	\N	599	\N	\N	0	1	2	f	\N	\N	\N
453	101	69	1	515	\N	515	\N	\N	0	1	2	f	\N	\N	\N
454	6	69	1	421	\N	421	\N	\N	0	1	2	f	\N	\N	\N
455	62	69	1	209	\N	209	\N	\N	0	1	2	f	\N	\N	\N
456	59	69	1	190	\N	190	\N	\N	0	1	2	f	\N	\N	\N
457	45	69	1	172	\N	172	\N	\N	0	1	2	f	\N	\N	\N
458	58	69	1	142	\N	142	\N	\N	0	1	2	f	\N	\N	\N
459	124	69	1	76	\N	76	\N	\N	0	1	2	f	\N	\N	\N
460	29	69	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
461	123	69	1	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
462	21	69	1	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
463	86	69	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
464	76	69	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
465	2	70	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
466	4	70	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
467	111	71	2	260	\N	260	\N	\N	1	1	2	f	0	\N	\N
468	3	71	2	260	\N	260	\N	\N	0	1	2	f	0	\N	\N
469	13	72	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
470	12	73	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
471	51	74	2	3230101	\N	3230101	\N	\N	1	1	2	f	0	\N	\N
472	123	74	1	6460202	\N	6460202	\N	\N	1	1	2	f	\N	\N	\N
473	92	74	1	6460202	\N	6460202	\N	\N	0	1	2	f	\N	\N	\N
474	3	74	1	6460202	\N	6460202	\N	\N	0	1	2	f	\N	\N	\N
475	91	75	2	787180	\N	0	\N	\N	1	1	2	f	787180	\N	\N
476	78	75	2	346	\N	0	\N	\N	2	1	2	f	346	\N	\N
477	41	75	2	26	\N	0	\N	\N	3	1	2	f	26	\N	\N
478	12	75	2	26	\N	0	\N	\N	4	1	2	f	26	\N	\N
479	35	75	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
480	68	76	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
481	83	77	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
482	93	77	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
483	2	77	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
484	125	78	2	20892137	\N	20892137	\N	\N	1	1	2	f	0	\N	\N
485	65	78	1	20738713	\N	20738713	\N	\N	1	1	2	f	\N	\N	\N
486	79	78	1	10201099	\N	10201099	\N	\N	0	1	2	f	\N	\N	\N
487	99	78	1	5887058	\N	5887058	\N	\N	0	1	2	f	\N	\N	\N
488	75	78	1	5318526	\N	5318526	\N	\N	0	1	2	f	\N	\N	\N
489	71	78	1	1365952	\N	1365952	\N	\N	0	1	2	f	\N	\N	\N
490	32	78	1	748954	\N	748954	\N	\N	0	1	2	f	\N	\N	\N
491	62	78	1	427111	\N	427111	\N	\N	0	1	2	f	\N	\N	\N
492	108	78	1	411171	\N	411171	\N	\N	0	1	2	f	\N	\N	\N
493	19	78	1	306249	\N	306249	\N	\N	0	1	2	f	\N	\N	\N
494	56	78	1	168761	\N	168761	\N	\N	0	1	2	f	\N	\N	\N
495	101	78	1	89650	\N	89650	\N	\N	0	1	2	f	\N	\N	\N
496	6	78	1	24009	\N	24009	\N	\N	0	1	2	f	\N	\N	\N
497	36	78	1	21804	\N	21804	\N	\N	0	1	2	f	\N	\N	\N
498	48	78	1	15789	\N	15789	\N	\N	0	1	2	f	\N	\N	\N
499	45	78	1	15313	\N	15313	\N	\N	0	1	2	f	\N	\N	\N
500	29	78	1	14262	\N	14262	\N	\N	0	1	2	f	\N	\N	\N
501	20	78	1	11956	\N	11956	\N	\N	0	1	2	f	\N	\N	\N
502	89	78	1	9718	\N	9718	\N	\N	0	1	2	f	\N	\N	\N
503	58	78	1	5882	\N	5882	\N	\N	0	1	2	f	\N	\N	\N
504	59	78	1	5073	\N	5073	\N	\N	0	1	2	f	\N	\N	\N
505	21	78	1	4419	\N	4419	\N	\N	0	1	2	f	\N	\N	\N
506	8	78	1	3350	\N	3350	\N	\N	0	1	2	f	\N	\N	\N
507	76	78	1	2532	\N	2532	\N	\N	0	1	2	f	\N	\N	\N
508	124	78	1	1753	\N	1753	\N	\N	0	1	2	f	\N	\N	\N
509	44	78	1	1318	\N	1318	\N	\N	0	1	2	f	\N	\N	\N
510	86	78	1	743	\N	743	\N	\N	0	1	2	f	\N	\N	\N
511	5	78	1	519	\N	519	\N	\N	0	1	2	f	\N	\N	\N
512	123	78	1	448	\N	448	\N	\N	0	1	2	f	\N	\N	\N
513	18	78	1	91	\N	91	\N	\N	0	1	2	f	\N	\N	\N
514	72	78	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
515	66	78	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
516	126	78	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
517	115	79	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
518	83	79	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
519	24	79	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
520	113	79	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
521	114	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
522	93	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
523	112	80	2	2562361	\N	2562361	\N	\N	1	1	2	f	0	\N	\N
524	65	80	1	2499530	\N	2499530	\N	\N	1	1	2	f	\N	\N	\N
525	79	80	1	2201146	\N	2201146	\N	\N	0	1	2	f	\N	\N	\N
526	75	80	1	1237244	\N	1237244	\N	\N	0	1	2	f	\N	\N	\N
527	99	80	1	280070	\N	280070	\N	\N	0	1	2	f	\N	\N	\N
528	71	80	1	235716	\N	235716	\N	\N	0	1	2	f	\N	\N	\N
529	108	80	1	72571	\N	72571	\N	\N	0	1	2	f	\N	\N	\N
530	48	80	1	30854	\N	30854	\N	\N	0	1	2	f	\N	\N	\N
531	89	80	1	27324	\N	27324	\N	\N	0	1	2	f	\N	\N	\N
532	32	80	1	26419	\N	26419	\N	\N	0	1	2	f	\N	\N	\N
533	56	80	1	23236	\N	23236	\N	\N	0	1	2	f	\N	\N	\N
534	36	80	1	14562	\N	14562	\N	\N	0	1	2	f	\N	\N	\N
535	19	80	1	11541	\N	11541	\N	\N	0	1	2	f	\N	\N	\N
536	20	80	1	9387	\N	9387	\N	\N	0	1	2	f	\N	\N	\N
537	6	80	1	5899	\N	5899	\N	\N	0	1	2	f	\N	\N	\N
538	44	80	1	5695	\N	5695	\N	\N	0	1	2	f	\N	\N	\N
539	45	80	1	3239	\N	3239	\N	\N	0	1	2	f	\N	\N	\N
540	59	80	1	2717	\N	2717	\N	\N	0	1	2	f	\N	\N	\N
541	101	80	1	2461	\N	2461	\N	\N	0	1	2	f	\N	\N	\N
542	58	80	1	2399	\N	2399	\N	\N	0	1	2	f	\N	\N	\N
543	62	80	1	1780	\N	1780	\N	\N	0	1	2	f	\N	\N	\N
544	124	80	1	885	\N	885	\N	\N	0	1	2	f	\N	\N	\N
545	29	80	1	600	\N	600	\N	\N	0	1	2	f	\N	\N	\N
546	76	80	1	428	\N	428	\N	\N	0	1	2	f	\N	\N	\N
547	5	80	1	380	\N	380	\N	\N	0	1	2	f	\N	\N	\N
548	21	80	1	323	\N	323	\N	\N	0	1	2	f	\N	\N	\N
549	86	80	1	260	\N	260	\N	\N	0	1	2	f	\N	\N	\N
550	123	80	1	116	\N	116	\N	\N	0	1	2	f	\N	\N	\N
551	18	80	1	53	\N	53	\N	\N	0	1	2	f	\N	\N	\N
552	8	80	1	47	\N	47	\N	\N	0	1	2	f	\N	\N	\N
553	24	81	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
554	83	81	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
555	13	81	2	6	\N	0	\N	\N	3	1	2	f	6	\N	\N
556	14	81	2	6	\N	0	\N	\N	4	1	2	f	6	\N	\N
557	102	81	2	5	\N	0	\N	\N	5	1	2	f	5	\N	\N
558	2	81	2	2	\N	0	\N	\N	6	1	2	f	2	\N	\N
559	25	81	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
560	81	81	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
561	11	81	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
562	115	81	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
563	53	81	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
564	54	81	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
565	55	81	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
566	28	81	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
567	82	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
568	85	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
569	94	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
570	42	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
571	93	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
572	80	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
573	40	81	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
574	69	82	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
575	13	82	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
576	51	83	2	2803343	\N	2803343	\N	\N	1	1	2	f	0	\N	\N
577	24	83	1	2803339	\N	2803339	\N	\N	1	1	2	f	\N	\N	\N
578	3	84	2	1136	\N	1136	\N	\N	1	1	2	f	0	\N	\N
579	115	84	2	272	\N	272	\N	\N	2	1	2	f	0	\N	\N
580	93	84	2	20	\N	20	\N	\N	3	1	2	f	0	\N	\N
581	92	84	2	1136	\N	1136	\N	\N	0	1	2	f	0	\N	\N
582	37	84	2	464	\N	464	\N	\N	0	1	2	f	0	\N	\N
583	15	84	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
584	98	84	2	124	\N	124	\N	\N	0	1	2	f	0	\N	\N
585	90	84	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
586	38	84	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
587	97	84	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
588	123	84	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
589	120	84	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
590	109	84	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
591	47	84	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
592	100	84	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
593	121	84	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
594	105	84	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
595	61	84	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
596	63	84	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
597	46	84	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
598	77	84	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
599	73	84	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
600	60	84	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
601	88	84	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
602	5	84	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
603	116	84	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
604	57	84	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
605	117	84	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
606	106	84	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
607	119	84	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
608	49	84	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
609	31	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
610	7	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
611	87	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
612	95	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
613	118	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
614	107	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
615	17	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
616	30	84	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
617	74	84	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
618	16	84	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
619	122	84	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
620	96	84	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
621	83	84	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
622	65	85	2	20739092	\N	0	\N	\N	1	1	2	f	20739092	\N	\N
623	128	85	2	65052	\N	0	\N	\N	2	1	2	f	65052	\N	\N
624	125	85	2	50	\N	0	\N	\N	3	1	2	f	50	\N	\N
625	79	85	2	10201385	\N	0	\N	\N	0	1	2	f	10201385	\N	\N
626	99	85	2	5887076	\N	0	\N	\N	0	1	2	f	5887076	\N	\N
627	75	85	2	5318600	\N	0	\N	\N	0	1	2	f	5318600	\N	\N
628	71	85	2	1365974	\N	0	\N	\N	0	1	2	f	1365974	\N	\N
629	32	85	2	748996	\N	0	\N	\N	0	1	2	f	748996	\N	\N
630	62	85	2	427113	\N	0	\N	\N	0	1	2	f	427113	\N	\N
631	108	85	2	411181	\N	0	\N	\N	0	1	2	f	411181	\N	\N
632	19	85	2	306253	\N	0	\N	\N	0	1	2	f	306253	\N	\N
633	56	85	2	168761	\N	0	\N	\N	0	1	2	f	168761	\N	\N
634	101	85	2	89652	\N	0	\N	\N	0	1	2	f	89652	\N	\N
635	6	85	2	24009	\N	0	\N	\N	0	1	2	f	24009	\N	\N
636	36	85	2	21808	\N	0	\N	\N	0	1	2	f	21808	\N	\N
637	48	85	2	15789	\N	0	\N	\N	0	1	2	f	15789	\N	\N
638	45	85	2	15313	\N	0	\N	\N	0	1	2	f	15313	\N	\N
639	29	85	2	14262	\N	0	\N	\N	0	1	2	f	14262	\N	\N
640	20	85	2	11958	\N	0	\N	\N	0	1	2	f	11958	\N	\N
641	89	85	2	9718	\N	0	\N	\N	0	1	2	f	9718	\N	\N
642	58	85	2	5882	\N	0	\N	\N	0	1	2	f	5882	\N	\N
643	59	85	2	5077	\N	0	\N	\N	0	1	2	f	5077	\N	\N
644	21	85	2	4419	\N	0	\N	\N	0	1	2	f	4419	\N	\N
645	8	85	2	3350	\N	0	\N	\N	0	1	2	f	3350	\N	\N
646	76	85	2	2532	\N	0	\N	\N	0	1	2	f	2532	\N	\N
647	124	85	2	1753	\N	0	\N	\N	0	1	2	f	1753	\N	\N
648	44	85	2	1318	\N	0	\N	\N	0	1	2	f	1318	\N	\N
649	86	85	2	743	\N	0	\N	\N	0	1	2	f	743	\N	\N
650	5	85	2	519	\N	0	\N	\N	0	1	2	f	519	\N	\N
651	123	85	2	448	\N	0	\N	\N	0	1	2	f	448	\N	\N
652	18	85	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
653	72	85	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
654	66	85	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
655	126	85	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
656	51	86	2	18068	\N	18068	\N	\N	1	1	2	f	0	\N	\N
657	24	86	1	18068	\N	18068	\N	\N	1	1	2	f	\N	\N	\N
658	2	87	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
659	65	88	2	10195	\N	10195	\N	\N	1	1	2	f	0	\N	\N
660	51	88	2	225	\N	225	\N	\N	2	1	2	f	0	\N	\N
661	79	88	2	10124	\N	10124	\N	\N	0	1	2	f	0	\N	\N
662	99	88	2	71	\N	71	\N	\N	0	1	2	f	0	\N	\N
663	24	88	1	10420	\N	10420	\N	\N	1	1	2	f	\N	\N	\N
664	69	89	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
665	115	90	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
666	104	91	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
667	2	92	2	118	\N	118	\N	\N	1	1	2	f	0	\N	\N
668	28	92	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
669	83	92	1	100	\N	100	\N	\N	1	1	2	f	\N	\N	\N
670	24	92	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
671	2	92	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
672	93	92	1	82	\N	82	\N	\N	0	1	2	f	\N	\N	\N
673	115	92	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
674	103	92	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
675	51	93	2	2218476	\N	2218476	\N	\N	1	1	2	f	0	\N	\N
676	99	93	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
677	65	93	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
678	24	93	1	2218484	\N	2218484	\N	\N	1	1	2	f	\N	\N	\N
679	102	94	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
680	2	94	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
681	81	94	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
682	11	94	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
683	28	94	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
684	82	94	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
685	80	94	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
686	40	94	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
687	70	95	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
688	4	96	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
689	2	96	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
690	2	97	2	411	\N	411	\N	\N	1	1	2	f	0	\N	\N
691	102	97	2	205	\N	205	\N	\N	2	1	2	f	0	\N	\N
692	81	97	2	205	\N	205	\N	\N	0	1	2	f	0	\N	\N
693	11	97	2	203	\N	203	\N	\N	0	1	2	f	0	\N	\N
694	82	97	2	201	\N	201	\N	\N	0	1	2	f	0	\N	\N
695	28	97	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
696	80	97	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
697	40	97	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
698	83	97	1	388	\N	388	\N	\N	1	1	2	f	\N	\N	\N
699	24	97	1	88	\N	88	\N	\N	2	1	2	f	\N	\N	\N
700	13	97	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
701	2	97	1	6	\N	6	\N	\N	4	1	2	f	\N	\N	\N
702	69	97	1	3	\N	3	\N	\N	5	1	2	f	\N	\N	\N
703	34	97	1	2	\N	2	\N	\N	6	1	2	f	\N	\N	\N
704	84	97	1	2	\N	2	\N	\N	7	1	2	f	\N	\N	\N
705	93	97	1	143	\N	143	\N	\N	0	1	2	f	\N	\N	\N
706	25	97	1	82	\N	82	\N	\N	0	1	2	f	\N	\N	\N
707	115	97	1	79	\N	79	\N	\N	0	1	2	f	\N	\N	\N
708	85	97	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
709	94	97	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
710	42	97	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
711	43	97	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
712	24	98	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
713	24	98	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
714	51	99	2	451864	\N	451864	\N	\N	1	1	2	f	0	\N	\N
715	24	99	1	451798	\N	451798	\N	\N	1	1	2	f	\N	\N	\N
716	119	99	1	132	\N	132	\N	\N	2	1	2	f	\N	\N	\N
717	92	99	1	132	\N	132	\N	\N	0	1	2	f	\N	\N	\N
718	3	99	1	132	\N	132	\N	\N	0	1	2	f	\N	\N	\N
719	128	100	2	2154	\N	0	\N	\N	1	1	2	f	2154	\N	\N
720	105	101	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
721	24	101	2	8	\N	0	\N	\N	2	1	2	f	8	\N	\N
722	3	101	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
723	3	102	1	130	\N	130	\N	\N	1	1	2	f	\N	\N	\N
724	93	102	1	125	\N	125	\N	\N	0	1	2	f	\N	\N	\N
725	39	102	1	120	\N	120	\N	\N	0	1	2	f	\N	\N	\N
726	9	102	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
727	115	102	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
728	24	103	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
729	83	103	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
730	43	103	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
731	51	104	2	744	\N	744	\N	\N	1	1	2	f	0	\N	\N
732	60	104	1	1488	\N	1488	\N	\N	1	1	2	f	\N	\N	\N
733	92	104	1	1488	\N	1488	\N	\N	0	1	2	f	\N	\N	\N
734	3	104	1	1488	\N	1488	\N	\N	0	1	2	f	\N	\N	\N
735	24	105	2	466	\N	466	\N	\N	1	1	2	f	0	\N	\N
736	68	106	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
737	64	106	1	33	\N	33	\N	\N	1	1	2	f	\N	\N	\N
738	78	107	2	7544	\N	7544	\N	\N	1	1	2	f	0	\N	\N
739	65	107	2	4003	\N	4003	\N	\N	2	1	2	f	0	\N	\N
740	79	107	2	3403	\N	3403	\N	\N	0	1	2	f	0	\N	\N
741	32	107	2	547	\N	547	\N	\N	0	1	2	f	0	\N	\N
742	112	107	1	14846	\N	14846	\N	\N	1	1	2	f	\N	\N	\N
743	78	108	2	1106	\N	0	\N	\N	1	1	2	f	1106	\N	\N
744	2	109	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
745	69	110	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
746	83	111	2	3865	\N	0	\N	\N	1	1	2	f	3865	\N	\N
747	3	111	2	1236	\N	0	\N	\N	2	1	2	f	1236	\N	\N
748	24	111	2	1188	\N	0	\N	\N	3	1	2	f	1188	\N	\N
749	64	111	2	775	\N	0	\N	\N	4	1	2	f	775	\N	\N
750	115	111	2	708	\N	0	\N	\N	5	1	2	f	708	\N	\N
751	110	111	2	576	\N	0	\N	\N	6	1	2	f	576	\N	\N
752	93	111	2	292	\N	0	\N	\N	7	1	2	f	292	\N	\N
753	114	111	2	196	\N	0	\N	\N	8	1	2	f	196	\N	\N
754	50	111	2	64	\N	0	\N	\N	9	1	2	f	64	\N	\N
755	2	111	2	27	\N	0	\N	\N	10	1	2	f	27	\N	\N
756	67	111	2	9	\N	0	\N	\N	11	1	2	f	9	\N	\N
757	13	111	2	6	\N	0	\N	\N	12	1	2	f	6	\N	\N
758	14	111	2	6	\N	0	\N	\N	13	1	2	f	6	\N	\N
759	69	111	2	3	\N	0	\N	\N	14	1	2	f	3	\N	\N
760	28	111	2	3	\N	0	\N	\N	15	1	2	f	3	\N	\N
761	26	111	2	1	\N	0	\N	\N	16	1	2	f	1	\N	\N
762	25	111	2	1553	\N	0	\N	\N	0	1	2	f	1553	\N	\N
763	92	111	2	1080	\N	0	\N	\N	0	1	2	f	1080	\N	\N
764	37	111	2	464	\N	0	\N	\N	0	1	2	f	464	\N	\N
765	15	111	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
766	98	111	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
767	90	111	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
768	23	111	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
769	38	111	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
770	97	111	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
771	9	111	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
772	120	111	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
773	123	111	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
774	47	111	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
775	103	111	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
776	105	111	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
777	109	111	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
778	100	111	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
779	22	111	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
780	61	111	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
781	63	111	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
782	46	111	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
783	77	111	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
784	88	111	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
785	5	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
786	116	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
787	57	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
788	121	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
789	49	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
790	111	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
791	127	111	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
792	39	111	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
793	117	111	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
794	106	111	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
795	119	111	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
796	4	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
797	31	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
798	73	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
799	7	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
800	87	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
801	60	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
802	95	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
803	118	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
804	107	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
805	17	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
806	30	111	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
807	43	111	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
808	74	111	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
809	16	111	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
810	122	111	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
811	96	111	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
812	33	111	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
813	113	111	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
814	81	111	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
815	53	111	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
816	54	111	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
817	55	111	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
818	102	111	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
819	85	111	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
820	94	111	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
821	42	111	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
822	83	112	2	59	\N	59	\N	\N	1	1	2	f	0	\N	\N
823	93	112	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
824	115	112	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
825	24	112	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
826	25	112	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
827	94	112	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
828	102	113	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
829	28	113	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
830	81	113	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
831	10	115	2	7330012	\N	7330012	\N	\N	1	1	2	f	0	\N	\N
832	52	115	2	668351	\N	668351	\N	\N	2	1	2	f	0	\N	\N
833	91	115	1	7996308	\N	7996308	\N	\N	1	1	2	f	\N	\N	\N
834	51	116	2	1315396	\N	1315396	\N	\N	1	1	2	f	0	\N	\N
835	65	116	2	410	\N	410	\N	\N	2	1	2	f	0	\N	\N
836	71	116	2	394	\N	394	\N	\N	0	1	2	f	0	\N	\N
837	32	116	2	37	\N	37	\N	\N	0	1	2	f	0	\N	\N
838	6	116	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
839	36	116	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
840	56	116	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
841	75	116	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
842	24	116	1	1315806	\N	1315806	\N	\N	1	1	2	f	\N	\N	\N
843	115	117	2	133	\N	0	\N	\N	1	1	2	f	133	\N	\N
844	83	117	2	65	\N	0	\N	\N	2	1	2	f	65	\N	\N
845	24	117	2	64	\N	0	\N	\N	3	1	2	f	64	\N	\N
846	93	117	2	52	\N	0	\N	\N	4	1	2	f	52	\N	\N
847	103	117	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
848	23	117	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
849	25	117	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
850	114	117	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
851	3	117	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
852	9	117	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
853	33	117	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
854	127	118	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
855	3	118	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
856	111	118	1	20	\N	20	\N	\N	1	1	2	f	\N	\N	\N
857	3	118	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
858	78	119	2	1735594	\N	1735594	\N	\N	1	1	2	f	0	\N	\N
859	65	119	2	558678	\N	558678	\N	\N	2	1	2	f	0	\N	\N
860	112	119	2	3725	\N	3725	\N	\N	3	1	2	f	0	\N	\N
861	79	119	2	307398	\N	307398	\N	\N	0	1	2	f	0	\N	\N
862	75	119	2	100918	\N	100918	\N	\N	0	1	2	f	0	\N	\N
863	99	119	2	33151	\N	33151	\N	\N	0	1	2	f	0	\N	\N
864	71	119	2	26914	\N	26914	\N	\N	0	1	2	f	0	\N	\N
865	32	119	2	15725	\N	15725	\N	\N	0	1	2	f	0	\N	\N
866	19	119	2	4019	\N	4019	\N	\N	0	1	2	f	0	\N	\N
867	56	119	2	3157	\N	3157	\N	\N	0	1	2	f	0	\N	\N
868	108	119	2	2569	\N	2569	\N	\N	0	1	2	f	0	\N	\N
869	36	119	2	2342	\N	2342	\N	\N	0	1	2	f	0	\N	\N
870	101	119	2	1846	\N	1846	\N	\N	0	1	2	f	0	\N	\N
871	89	119	2	589	\N	589	\N	\N	0	1	2	f	0	\N	\N
872	45	119	2	533	\N	533	\N	\N	0	1	2	f	0	\N	\N
873	6	119	2	356	\N	356	\N	\N	0	1	2	f	0	\N	\N
874	20	119	2	305	\N	305	\N	\N	0	1	2	f	0	\N	\N
875	21	119	2	281	\N	281	\N	\N	0	1	2	f	0	\N	\N
876	48	119	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
877	58	119	2	230	\N	230	\N	\N	0	1	2	f	0	\N	\N
878	29	119	2	213	\N	213	\N	\N	0	1	2	f	0	\N	\N
879	62	119	2	87	\N	87	\N	\N	0	1	2	f	0	\N	\N
880	59	119	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
881	8	119	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
882	76	119	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
883	86	119	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
884	5	119	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
885	66	119	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
886	126	119	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
887	123	119	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
888	18	119	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
889	112	119	1	2463777	\N	2463777	\N	\N	1	1	2	f	\N	\N	\N
890	78	120	2	8544	\N	8544	\N	\N	1	1	2	f	0	\N	\N
891	65	120	2	2417	\N	2417	\N	\N	2	1	2	f	0	\N	\N
892	112	120	2	512	\N	512	\N	\N	3	1	2	f	0	\N	\N
893	79	120	2	2228	\N	2228	\N	\N	0	1	2	f	0	\N	\N
894	75	120	2	169	\N	169	\N	\N	0	1	2	f	0	\N	\N
895	32	120	2	166	\N	166	\N	\N	0	1	2	f	0	\N	\N
896	108	120	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
897	19	120	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
898	112	120	1	16192	\N	16192	\N	\N	1	1	2	f	\N	\N	\N
899	83	121	2	1258	\N	1258	\N	\N	1	1	2	f	0	\N	\N
900	115	121	2	453	\N	453	\N	\N	2	1	2	f	0	\N	\N
901	93	121	2	447	\N	447	\N	\N	3	1	2	f	0	\N	\N
902	114	121	2	20	\N	20	\N	\N	4	1	2	f	0	\N	\N
903	67	121	2	17	\N	17	\N	\N	5	1	2	f	0	\N	\N
904	3	121	2	82	\N	82	\N	\N	0	1	2	f	0	\N	\N
905	22	121	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
906	23	121	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
907	103	121	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
908	113	121	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
909	33	121	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
910	9	121	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
911	43	121	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
912	24	121	1	1045	\N	1045	\N	\N	1	1	2	f	\N	\N	\N
913	25	121	1	705	\N	705	\N	\N	0	1	2	f	\N	\N	\N
914	94	121	1	25	\N	25	\N	\N	0	1	2	f	\N	\N	\N
915	42	121	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
916	85	121	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
917	78	122	2	512435	\N	512435	\N	\N	1	1	2	f	0	\N	\N
918	65	122	2	81153	\N	81153	\N	\N	2	1	2	f	0	\N	\N
919	112	122	2	1982	\N	1982	\N	\N	3	1	2	f	0	\N	\N
920	75	122	2	28847	\N	28847	\N	\N	0	1	2	f	0	\N	\N
921	79	122	2	7324	\N	7324	\N	\N	0	1	2	f	0	\N	\N
922	99	122	2	3317	\N	3317	\N	\N	0	1	2	f	0	\N	\N
923	32	122	2	1378	\N	1378	\N	\N	0	1	2	f	0	\N	\N
924	71	122	2	1218	\N	1218	\N	\N	0	1	2	f	0	\N	\N
925	19	122	2	423	\N	423	\N	\N	0	1	2	f	0	\N	\N
926	108	122	2	288	\N	288	\N	\N	0	1	2	f	0	\N	\N
927	76	122	2	75	\N	75	\N	\N	0	1	2	f	0	\N	\N
928	56	122	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
929	101	122	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
930	36	122	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
931	48	122	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
932	5	122	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
933	89	122	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
934	45	122	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
935	62	122	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
936	20	122	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
937	112	122	1	618201	\N	618201	\N	\N	1	1	2	f	\N	\N	\N
938	128	123	2	5004	\N	0	\N	\N	1	1	2	f	5004	\N	\N
939	102	124	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
940	28	124	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
941	81	124	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
942	2	125	2	28	\N	23	\N	\N	1	1	2	f	5	\N	\N
943	3	125	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
944	4	125	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
945	2	126	2	81	\N	80	\N	\N	1	1	2	f	1	\N	\N
946	4	126	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
947	68	127	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
948	65	128	2	20738834	\N	0	\N	\N	1	1	2	f	20738834	\N	\N
949	91	128	2	7500	\N	7500	\N	\N	2	1	2	f	0	\N	\N
950	79	128	2	10201385	\N	0	\N	\N	0	1	2	f	10201385	\N	\N
951	99	128	2	5887076	\N	0	\N	\N	0	1	2	f	5887076	\N	\N
952	75	128	2	5318600	\N	0	\N	\N	0	1	2	f	5318600	\N	\N
953	71	128	2	1365974	\N	0	\N	\N	0	1	2	f	1365974	\N	\N
954	32	128	2	748996	\N	0	\N	\N	0	1	2	f	748996	\N	\N
955	62	128	2	427113	\N	0	\N	\N	0	1	2	f	427113	\N	\N
956	108	128	2	411181	\N	0	\N	\N	0	1	2	f	411181	\N	\N
957	19	128	2	306253	\N	0	\N	\N	0	1	2	f	306253	\N	\N
958	56	128	2	168761	\N	0	\N	\N	0	1	2	f	168761	\N	\N
959	101	128	2	89652	\N	0	\N	\N	0	1	2	f	89652	\N	\N
960	6	128	2	24009	\N	0	\N	\N	0	1	2	f	24009	\N	\N
961	36	128	2	21808	\N	0	\N	\N	0	1	2	f	21808	\N	\N
962	48	128	2	15789	\N	0	\N	\N	0	1	2	f	15789	\N	\N
963	45	128	2	15313	\N	0	\N	\N	0	1	2	f	15313	\N	\N
964	29	128	2	14262	\N	0	\N	\N	0	1	2	f	14262	\N	\N
965	20	128	2	11958	\N	0	\N	\N	0	1	2	f	11958	\N	\N
966	89	128	2	9718	\N	0	\N	\N	0	1	2	f	9718	\N	\N
967	58	128	2	5882	\N	0	\N	\N	0	1	2	f	5882	\N	\N
968	59	128	2	5077	\N	0	\N	\N	0	1	2	f	5077	\N	\N
969	21	128	2	4419	\N	0	\N	\N	0	1	2	f	4419	\N	\N
970	8	128	2	3350	\N	0	\N	\N	0	1	2	f	3350	\N	\N
971	76	128	2	2532	\N	0	\N	\N	0	1	2	f	2532	\N	\N
972	124	128	2	1753	\N	0	\N	\N	0	1	2	f	1753	\N	\N
973	44	128	2	1318	\N	0	\N	\N	0	1	2	f	1318	\N	\N
974	86	128	2	743	\N	0	\N	\N	0	1	2	f	743	\N	\N
975	5	128	2	519	\N	0	\N	\N	0	1	2	f	519	\N	\N
976	123	128	2	448	\N	0	\N	\N	0	1	2	f	448	\N	\N
977	18	128	2	91	\N	0	\N	\N	0	1	2	f	91	\N	\N
978	72	128	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
979	66	128	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
980	126	128	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
981	3	128	1	15000	\N	15000	\N	\N	1	1	2	f	\N	\N	\N
982	92	128	1	15000	\N	15000	\N	\N	0	1	2	f	\N	\N	\N
983	37	128	1	14980	\N	14980	\N	\N	0	1	2	f	\N	\N	\N
984	46	128	1	8348	\N	8348	\N	\N	0	1	2	f	\N	\N	\N
985	105	128	1	3490	\N	3490	\N	\N	0	1	2	f	\N	\N	\N
986	77	128	1	2322	\N	2322	\N	\N	0	1	2	f	\N	\N	\N
987	117	128	1	638	\N	638	\N	\N	0	1	2	f	\N	\N	\N
988	116	128	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
989	118	128	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
990	98	128	1	16	\N	16	\N	\N	0	1	2	f	\N	\N	\N
991	90	128	1	16	\N	16	\N	\N	0	1	2	f	\N	\N	\N
992	106	128	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
993	120	128	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
994	63	128	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
995	51	129	2	1720696	\N	1720696	\N	\N	1	1	2	f	0	\N	\N
996	24	129	1	1720696	\N	1720696	\N	\N	1	1	2	f	\N	\N	\N
997	28	130	2	145	\N	145	\N	\N	1	1	2	f	0	\N	\N
998	81	130	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
999	83	130	1	123	\N	123	\N	\N	1	1	2	f	\N	\N	\N
1000	24	130	1	22	\N	22	\N	\N	2	1	2	f	\N	\N	\N
1001	93	130	1	92	\N	92	\N	\N	0	1	2	f	\N	\N	\N
1002	115	130	1	31	\N	31	\N	\N	0	1	2	f	\N	\N	\N
1003	103	130	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1004	43	130	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1005	10	131	2	11102418	\N	11102418	\N	\N	1	1	2	f	0	\N	\N
1006	83	132	2	118	\N	0	\N	\N	1	1	2	f	118	\N	\N
1007	24	132	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
1008	93	132	2	93	\N	0	\N	\N	0	1	2	f	93	\N	\N
1009	115	132	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
1010	103	132	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1011	43	132	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1012	13	133	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1013	115	134	2	48	\N	48	\N	\N	1	1	2	f	0	\N	\N
1014	83	134	2	20	\N	20	\N	\N	2	1	2	f	0	\N	\N
1015	103	134	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1016	113	134	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1017	23	134	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1018	115	134	1	47	\N	47	\N	\N	1	1	2	f	\N	\N	\N
1019	83	134	1	19	\N	19	\N	\N	2	1	2	f	\N	\N	\N
1020	23	134	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
1021	113	134	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1022	103	134	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1023	51	135	2	3129655	\N	3129655	\N	\N	1	1	2	f	0	\N	\N
1024	107	135	1	6259310	\N	6259310	\N	\N	1	1	2	f	\N	\N	\N
1025	92	135	1	6259310	\N	6259310	\N	\N	0	1	2	f	\N	\N	\N
1026	3	135	1	6259310	\N	6259310	\N	\N	0	1	2	f	\N	\N	\N
1027	4	136	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1028	2	136	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1029	4	136	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1030	2	136	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1031	26	137	1	654	\N	654	\N	\N	1	1	2	f	\N	\N	\N
1032	78	138	2	14906330	\N	14906330	\N	\N	1	1	2	f	0	\N	\N
1033	83	138	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
1034	24	138	2	8	\N	0	\N	\N	3	1	2	f	8	\N	\N
1035	115	138	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
1036	114	138	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1037	33	138	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1038	113	138	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1039	23	138	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1040	93	138	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1041	128	139	2	5005	\N	0	\N	\N	1	1	2	f	5005	\N	\N
1042	83	140	2	4027	\N	4027	\N	\N	1	1	2	f	0	\N	\N
1043	3	140	2	1086	\N	1084	\N	\N	2	1	2	f	2	\N	\N
1044	24	140	2	1001	\N	906	\N	\N	3	1	2	f	95	\N	\N
1045	115	140	2	791	\N	786	\N	\N	4	1	2	f	5	\N	\N
1046	64	140	2	775	\N	775	\N	\N	5	1	2	f	0	\N	\N
1047	110	140	2	576	\N	576	\N	\N	6	1	2	f	0	\N	\N
1048	93	140	2	281	\N	271	\N	\N	7	1	2	f	10	\N	\N
1049	114	140	2	195	\N	195	\N	\N	8	1	2	f	0	\N	\N
1050	50	140	2	64	\N	64	\N	\N	9	1	2	f	0	\N	\N
1051	2	140	2	12	\N	12	\N	\N	10	1	2	f	0	\N	\N
1052	67	140	2	9	\N	9	\N	\N	11	1	2	f	0	\N	\N
1053	34	140	2	6	\N	6	\N	\N	12	1	2	f	0	\N	\N
1054	13	140	2	6	\N	6	\N	\N	13	1	2	f	0	\N	\N
1055	84	140	2	4	\N	4	\N	\N	14	1	2	f	0	\N	\N
1056	69	140	2	3	\N	3	\N	\N	15	1	2	f	0	\N	\N
1057	26	140	2	1	\N	1	\N	\N	16	1	2	f	0	\N	\N
1058	25	140	2	1526	\N	1526	\N	\N	0	1	2	f	0	\N	\N
1059	92	140	2	1084	\N	1084	\N	\N	0	1	2	f	0	\N	\N
1060	37	140	2	452	\N	452	\N	\N	0	1	2	f	0	\N	\N
1061	98	140	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
1062	15	140	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
1063	90	140	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
1064	38	140	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1065	97	140	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1066	120	140	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1067	63	140	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1068	109	140	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1069	47	140	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1070	123	140	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1071	105	140	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1072	61	140	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1073	100	140	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1074	77	140	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1075	103	140	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
1076	23	140	2	24	\N	23	\N	\N	0	1	2	f	1	\N	\N
1077	5	140	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1078	116	140	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1079	57	140	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1080	121	140	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1081	46	140	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1082	117	140	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1083	119	140	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1084	49	140	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1085	31	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1086	73	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1087	7	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1088	106	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1089	87	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1090	60	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1091	95	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1092	118	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1093	107	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1094	17	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1095	88	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1096	30	140	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1097	43	140	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1098	74	140	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1099	16	140	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1100	122	140	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1101	96	140	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1102	33	140	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1103	113	140	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1104	9	140	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1105	85	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1106	94	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1107	42	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1108	39	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1109	2	140	1	3251	\N	3251	\N	\N	1	1	2	f	\N	\N	\N
1110	82	140	1	7	\N	7	\N	\N	2	1	2	f	\N	\N	\N
1111	4	140	1	2535	\N	2535	\N	\N	0	1	2	f	\N	\N	\N
1112	3	140	1	2380	\N	2380	\N	\N	0	1	2	f	\N	\N	\N
1113	11	140	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1114	102	140	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1115	81	140	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1116	4	142	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1117	2	142	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1118	115	143	2	47	\N	47	\N	\N	1	1	2	f	0	\N	\N
1119	33	143	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1120	34	144	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
1121	84	144	2	26	\N	26	\N	\N	2	1	2	f	0	\N	\N
1122	65	145	2	14881264	\N	14881264	\N	\N	1	1	2	f	0	\N	\N
1123	79	145	2	7053615	\N	7053615	\N	\N	0	1	2	f	0	\N	\N
1124	75	145	2	3700678	\N	3700678	\N	\N	0	1	2	f	0	\N	\N
1125	99	145	2	2429252	\N	2429252	\N	\N	0	1	2	f	0	\N	\N
1126	71	145	2	846262	\N	846262	\N	\N	0	1	2	f	0	\N	\N
1127	32	145	2	644919	\N	644919	\N	\N	0	1	2	f	0	\N	\N
1128	108	145	2	444410	\N	444410	\N	\N	0	1	2	f	0	\N	\N
1129	62	145	2	391699	\N	391699	\N	\N	0	1	2	f	0	\N	\N
1130	19	145	2	212633	\N	212633	\N	\N	0	1	2	f	0	\N	\N
1131	56	145	2	168214	\N	168214	\N	\N	0	1	2	f	0	\N	\N
1132	101	145	2	51241	\N	51241	\N	\N	0	1	2	f	0	\N	\N
1133	36	145	2	22240	\N	22240	\N	\N	0	1	2	f	0	\N	\N
1134	6	145	2	21261	\N	21261	\N	\N	0	1	2	f	0	\N	\N
1135	48	145	2	17110	\N	17110	\N	\N	0	1	2	f	0	\N	\N
1136	45	145	2	16744	\N	16744	\N	\N	0	1	2	f	0	\N	\N
1137	20	145	2	16272	\N	16272	\N	\N	0	1	2	f	0	\N	\N
1138	29	145	2	14065	\N	14065	\N	\N	0	1	2	f	0	\N	\N
1139	89	145	2	12060	\N	12060	\N	\N	0	1	2	f	0	\N	\N
1140	58	145	2	7509	\N	7509	\N	\N	0	1	2	f	0	\N	\N
1141	21	145	2	5347	\N	5347	\N	\N	0	1	2	f	0	\N	\N
1142	8	145	2	4216	\N	4216	\N	\N	0	1	2	f	0	\N	\N
1143	59	145	2	3907	\N	3907	\N	\N	0	1	2	f	0	\N	\N
1144	76	145	2	2879	\N	2879	\N	\N	0	1	2	f	0	\N	\N
1145	124	145	2	2404	\N	2404	\N	\N	0	1	2	f	0	\N	\N
1146	44	145	2	2184	\N	2184	\N	\N	0	1	2	f	0	\N	\N
1147	86	145	2	752	\N	752	\N	\N	0	1	2	f	0	\N	\N
1148	123	145	2	476	\N	476	\N	\N	0	1	2	f	0	\N	\N
1149	5	145	2	263	\N	263	\N	\N	0	1	2	f	0	\N	\N
1150	18	145	2	111	\N	111	\N	\N	0	1	2	f	0	\N	\N
1151	72	145	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1152	66	145	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1153	126	145	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1154	78	145	1	14880532	\N	14880532	\N	\N	1	1	2	f	\N	\N	\N
1155	68	146	2	173	\N	173	\N	\N	1	1	2	f	0	\N	\N
1156	24	146	1	318	\N	318	\N	\N	1	1	2	f	\N	\N	\N
1157	24	147	2	135	\N	135	\N	\N	1	1	2	f	0	\N	\N
1158	25	147	2	96	\N	96	\N	\N	0	1	2	f	0	\N	\N
1159	94	147	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1160	24	147	1	129	\N	129	\N	\N	1	1	2	f	\N	\N	\N
1161	25	147	1	96	\N	96	\N	\N	0	1	2	f	\N	\N	\N
1162	104	148	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1163	2	149	2	529	\N	529	\N	\N	1	1	2	f	0	\N	\N
1164	83	149	1	306	\N	306	\N	\N	1	1	2	f	\N	\N	\N
1165	24	149	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
1166	93	149	1	199	\N	199	\N	\N	0	1	2	f	\N	\N	\N
1167	115	149	1	74	\N	74	\N	\N	0	1	2	f	\N	\N	\N
1168	25	149	1	41	\N	41	\N	\N	0	1	2	f	\N	\N	\N
1169	103	149	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1170	43	149	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1171	85	149	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1172	94	149	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1173	42	149	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1174	128	150	2	4308	\N	0	\N	\N	1	1	2	f	4308	\N	\N
1175	104	151	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1176	24	152	2	159	\N	159	\N	\N	1	1	2	f	0	\N	\N
1177	25	152	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1178	3	153	2	1036	\N	0	\N	\N	1	1	2	f	1036	\N	\N
1179	24	153	2	939	\N	0	\N	\N	2	1	2	f	939	\N	\N
1180	115	153	2	226	\N	0	\N	\N	3	1	2	f	226	\N	\N
1181	2	153	2	26	\N	0	\N	\N	4	1	2	f	26	\N	\N
1182	93	153	2	16	\N	0	\N	\N	5	1	2	f	16	\N	\N
1183	92	153	2	1032	\N	0	\N	\N	0	1	2	f	1032	\N	\N
1184	37	153	2	452	\N	0	\N	\N	0	1	2	f	452	\N	\N
1185	15	153	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
1186	98	153	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
1187	90	153	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
1188	38	153	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
1189	97	153	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
1190	120	153	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
1191	47	153	2	44	\N	0	\N	\N	0	1	2	f	44	\N	\N
1192	123	153	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
1193	105	153	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1194	61	153	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1195	63	153	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1196	77	153	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1197	109	153	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1198	100	153	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
1199	5	153	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1200	116	153	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1201	57	153	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1202	121	153	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1203	46	153	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1204	117	153	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1205	119	153	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1206	49	153	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1207	31	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1208	73	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1209	7	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1210	106	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1211	87	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1212	60	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1213	95	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1214	118	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1215	107	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1216	17	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1217	88	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1218	30	153	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1219	4	153	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1220	74	153	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1221	16	153	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1222	122	153	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1223	96	153	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1224	13	154	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
1225	14	154	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
1226	53	154	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1227	54	154	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1228	55	154	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1229	128	155	2	2154	\N	0	\N	\N	1	1	2	f	2154	\N	\N
1230	125	156	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
1231	128	157	2	5004	\N	0	\N	\N	1	1	2	f	5004	\N	\N
1232	9	158	1	130	\N	130	\N	\N	1	1	2	f	\N	\N	\N
1233	93	158	1	130	\N	130	\N	\N	0	1	2	f	\N	\N	\N
1234	3	158	1	130	\N	130	\N	\N	0	1	2	f	\N	\N	\N
1235	51	159	2	33092159	\N	0	\N	\N	1	1	2	f	33092159	\N	\N
1236	65	159	2	3384	\N	0	\N	\N	2	1	2	f	3384	\N	\N
1237	32	159	2	2594	\N	0	\N	\N	0	1	2	f	2594	\N	\N
1238	79	159	2	780	\N	0	\N	\N	0	1	2	f	780	\N	\N
1239	108	159	2	633	\N	0	\N	\N	0	1	2	f	633	\N	\N
1240	19	159	2	218	\N	0	\N	\N	0	1	2	f	218	\N	\N
1241	75	159	2	59	\N	0	\N	\N	0	1	2	f	59	\N	\N
1242	45	159	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
1243	101	159	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1244	29	159	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1245	71	159	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
1246	56	159	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
1247	99	159	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1248	21	159	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1249	20	159	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1250	58	159	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1251	59	159	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1252	6	159	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1253	76	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1254	34	160	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1255	65	161	2	153659	\N	153659	\N	\N	1	1	2	f	0	\N	\N
1256	79	161	2	122509	\N	122509	\N	\N	0	1	2	f	0	\N	\N
1257	32	161	2	18772	\N	18772	\N	\N	0	1	2	f	0	\N	\N
1258	75	161	2	16263	\N	16263	\N	\N	0	1	2	f	0	\N	\N
1259	99	161	2	4155	\N	4155	\N	\N	0	1	2	f	0	\N	\N
1260	71	161	2	2624	\N	2624	\N	\N	0	1	2	f	0	\N	\N
1261	108	161	2	2508	\N	2508	\N	\N	0	1	2	f	0	\N	\N
1262	19	161	2	1389	\N	1389	\N	\N	0	1	2	f	0	\N	\N
1263	56	161	2	1064	\N	1064	\N	\N	0	1	2	f	0	\N	\N
1264	6	161	2	1046	\N	1046	\N	\N	0	1	2	f	0	\N	\N
1265	48	161	2	882	\N	882	\N	\N	0	1	2	f	0	\N	\N
1266	45	161	2	754	\N	754	\N	\N	0	1	2	f	0	\N	\N
1267	36	161	2	706	\N	706	\N	\N	0	1	2	f	0	\N	\N
1268	20	161	2	439	\N	439	\N	\N	0	1	2	f	0	\N	\N
1269	101	161	2	428	\N	428	\N	\N	0	1	2	f	0	\N	\N
1270	58	161	2	376	\N	376	\N	\N	0	1	2	f	0	\N	\N
1271	59	161	2	319	\N	319	\N	\N	0	1	2	f	0	\N	\N
1272	62	161	2	276	\N	276	\N	\N	0	1	2	f	0	\N	\N
1273	89	161	2	273	\N	273	\N	\N	0	1	2	f	0	\N	\N
1274	29	161	2	148	\N	148	\N	\N	0	1	2	f	0	\N	\N
1275	21	161	2	110	\N	110	\N	\N	0	1	2	f	0	\N	\N
1276	124	161	2	55	\N	55	\N	\N	0	1	2	f	0	\N	\N
1277	86	161	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1278	76	161	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
1279	8	161	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
1280	44	161	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1281	123	161	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1282	65	161	1	153635	\N	153635	\N	\N	1	1	2	f	\N	\N	\N
1283	115	162	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1284	83	162	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1285	69	163	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
1286	70	164	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1287	69	165	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1288	84	165	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1289	4	166	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
1290	2	166	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1291	34	167	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1292	102	167	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1293	2	167	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
1294	28	167	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1295	81	167	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1296	70	168	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1297	10	169	2	18986177	\N	18986177	\N	\N	1	1	2	f	0	\N	\N
1298	65	169	1	11136141	\N	11136141	\N	\N	1	1	2	f	\N	\N	\N
1299	78	169	1	7824156	\N	7824156	\N	\N	2	1	2	f	\N	\N	\N
1300	112	169	1	37670	\N	37670	\N	\N	3	1	2	f	\N	\N	\N
1301	79	169	1	5233234	\N	5233234	\N	\N	0	1	2	f	\N	\N	\N
1302	75	169	1	2751313	\N	2751313	\N	\N	0	1	2	f	\N	\N	\N
1303	32	169	1	878038	\N	878038	\N	\N	0	1	2	f	\N	\N	\N
1304	99	169	1	597751	\N	597751	\N	\N	0	1	2	f	\N	\N	\N
1305	71	169	1	559130	\N	559130	\N	\N	0	1	2	f	\N	\N	\N
1306	19	169	1	328077	\N	328077	\N	\N	0	1	2	f	\N	\N	\N
1307	108	169	1	263481	\N	263481	\N	\N	0	1	2	f	\N	\N	\N
1308	56	169	1	79967	\N	79967	\N	\N	0	1	2	f	\N	\N	\N
1309	101	169	1	52671	\N	52671	\N	\N	0	1	2	f	\N	\N	\N
1310	36	169	1	32557	\N	32557	\N	\N	0	1	2	f	\N	\N	\N
1311	6	169	1	21644	\N	21644	\N	\N	0	1	2	f	\N	\N	\N
1312	20	169	1	19985	\N	19985	\N	\N	0	1	2	f	\N	\N	\N
1313	45	169	1	18387	\N	18387	\N	\N	0	1	2	f	\N	\N	\N
1314	21	169	1	12293	\N	12293	\N	\N	0	1	2	f	\N	\N	\N
1315	58	169	1	11302	\N	11302	\N	\N	0	1	2	f	\N	\N	\N
1316	29	169	1	7504	\N	7504	\N	\N	0	1	2	f	\N	\N	\N
1317	48	169	1	7445	\N	7445	\N	\N	0	1	2	f	\N	\N	\N
1318	59	169	1	7328	\N	7328	\N	\N	0	1	2	f	\N	\N	\N
1319	89	169	1	6169	\N	6169	\N	\N	0	1	2	f	\N	\N	\N
1320	62	169	1	3618	\N	3618	\N	\N	0	1	2	f	\N	\N	\N
1321	5	169	1	1673	\N	1673	\N	\N	0	1	2	f	\N	\N	\N
1322	8	169	1	1366	\N	1366	\N	\N	0	1	2	f	\N	\N	\N
1323	123	169	1	1149	\N	1149	\N	\N	0	1	2	f	\N	\N	\N
1324	76	169	1	1113	\N	1113	\N	\N	0	1	2	f	\N	\N	\N
1325	86	169	1	842	\N	842	\N	\N	0	1	2	f	\N	\N	\N
1326	44	169	1	751	\N	751	\N	\N	0	1	2	f	\N	\N	\N
1327	66	169	1	168	\N	168	\N	\N	0	1	2	f	\N	\N	\N
1328	124	169	1	144	\N	144	\N	\N	0	1	2	f	\N	\N	\N
1329	126	169	1	89	\N	89	\N	\N	0	1	2	f	\N	\N	\N
1330	2	170	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1331	2	170	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1332	128	171	2	2154	\N	0	\N	\N	1	1	2	f	2154	\N	\N
1333	4	172	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
1334	28	172	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
1335	2	172	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1336	3	172	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1337	81	172	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1338	102	172	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1339	34	173	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1340	128	174	2	40069	\N	40069	\N	\N	1	1	2	f	0	\N	\N
1341	22	174	1	80082	\N	80082	\N	\N	1	1	2	f	\N	\N	\N
1342	115	174	1	80082	\N	80082	\N	\N	0	1	2	f	\N	\N	\N
1343	3	174	1	80082	\N	80082	\N	\N	0	1	2	f	\N	\N	\N
1344	65	175	2	262669	\N	262669	\N	\N	1	1	2	f	0	\N	\N
1345	78	175	2	245779	\N	245779	\N	\N	2	1	2	f	0	\N	\N
1346	112	175	2	2417	\N	2417	\N	\N	3	1	2	f	0	\N	\N
1347	75	175	2	196235	\N	196235	\N	\N	0	1	2	f	0	\N	\N
1348	79	175	2	23566	\N	23566	\N	\N	0	1	2	f	0	\N	\N
1349	99	175	2	12131	\N	12131	\N	\N	0	1	2	f	0	\N	\N
1350	71	175	2	6298	\N	6298	\N	\N	0	1	2	f	0	\N	\N
1351	48	175	2	2933	\N	2933	\N	\N	0	1	2	f	0	\N	\N
1352	32	175	2	2428	\N	2428	\N	\N	0	1	2	f	0	\N	\N
1353	89	175	2	1968	\N	1968	\N	\N	0	1	2	f	0	\N	\N
1354	19	175	2	710	\N	710	\N	\N	0	1	2	f	0	\N	\N
1355	108	175	2	379	\N	379	\N	\N	0	1	2	f	0	\N	\N
1356	56	175	2	360	\N	360	\N	\N	0	1	2	f	0	\N	\N
1357	5	175	2	294	\N	294	\N	\N	0	1	2	f	0	\N	\N
1358	20	175	2	229	\N	229	\N	\N	0	1	2	f	0	\N	\N
1359	6	175	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
1360	126	175	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
1361	58	175	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1362	76	175	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1363	36	175	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1364	101	175	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1365	21	175	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1366	86	175	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1367	112	175	1	528437	\N	528437	\N	\N	1	1	2	f	\N	\N	\N
1368	83	176	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
1369	115	176	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1370	93	176	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1371	24	176	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1372	25	176	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1373	65	177	2	163	\N	163	\N	\N	1	1	2	f	0	\N	\N
1374	78	177	2	59	\N	59	\N	\N	2	1	2	f	0	\N	\N
1375	112	177	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
1376	79	177	2	142	\N	142	\N	\N	0	1	2	f	0	\N	\N
1377	99	177	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1378	32	177	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1379	75	177	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1380	19	177	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1381	112	177	1	288	\N	288	\N	\N	1	1	2	f	\N	\N	\N
1382	65	178	2	19792703	\N	19792703	\N	\N	1	1	2	f	0	\N	\N
1383	51	178	2	162983	\N	162983	\N	\N	2	1	2	f	0	\N	\N
1384	79	178	2	10201361	\N	10201361	\N	\N	0	1	2	f	0	\N	\N
1385	99	178	2	5887107	\N	5887107	\N	\N	0	1	2	f	0	\N	\N
1386	75	178	2	5322151	\N	5322151	\N	\N	0	1	2	f	0	\N	\N
1387	71	178	2	1366116	\N	1366116	\N	\N	0	1	2	f	0	\N	\N
1388	32	178	2	728043	\N	728043	\N	\N	0	1	2	f	0	\N	\N
1389	62	178	2	427125	\N	427125	\N	\N	0	1	2	f	0	\N	\N
1390	108	178	2	414411	\N	414411	\N	\N	0	1	2	f	0	\N	\N
1391	19	178	2	306253	\N	306253	\N	\N	0	1	2	f	0	\N	\N
1392	56	178	2	168827	\N	168827	\N	\N	0	1	2	f	0	\N	\N
1393	101	178	2	89652	\N	89652	\N	\N	0	1	2	f	0	\N	\N
1394	6	178	2	24027	\N	24027	\N	\N	0	1	2	f	0	\N	\N
1395	36	178	2	21909	\N	21909	\N	\N	0	1	2	f	0	\N	\N
1396	48	178	2	15789	\N	15789	\N	\N	0	1	2	f	0	\N	\N
1397	45	178	2	15315	\N	15315	\N	\N	0	1	2	f	0	\N	\N
1398	29	178	2	14262	\N	14262	\N	\N	0	1	2	f	0	\N	\N
1399	20	178	2	11974	\N	11974	\N	\N	0	1	2	f	0	\N	\N
1400	89	178	2	9718	\N	9718	\N	\N	0	1	2	f	0	\N	\N
1401	58	178	2	5887	\N	5887	\N	\N	0	1	2	f	0	\N	\N
1402	59	178	2	5077	\N	5077	\N	\N	0	1	2	f	0	\N	\N
1403	8	178	2	3190	\N	3190	\N	\N	0	1	2	f	0	\N	\N
1404	76	178	2	2604	\N	2604	\N	\N	0	1	2	f	0	\N	\N
1405	124	178	2	1760	\N	1760	\N	\N	0	1	2	f	0	\N	\N
1406	44	178	2	1318	\N	1318	\N	\N	0	1	2	f	0	\N	\N
1407	86	178	2	752	\N	752	\N	\N	0	1	2	f	0	\N	\N
1408	5	178	2	519	\N	519	\N	\N	0	1	2	f	0	\N	\N
1409	123	178	2	448	\N	448	\N	\N	0	1	2	f	0	\N	\N
1410	18	178	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
1411	72	178	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1412	66	178	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1413	126	178	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1414	3	178	1	39568506	\N	39568506	\N	\N	1	1	2	f	\N	\N	\N
1415	24	178	1	175087	\N	175087	\N	\N	2	1	2	f	\N	\N	\N
1416	115	178	1	4030	\N	4030	\N	\N	3	1	2	f	\N	\N	\N
1417	93	178	1	10	\N	10	\N	\N	4	1	2	f	\N	\N	\N
1418	92	178	1	39568506	\N	39568506	\N	\N	0	1	2	f	\N	\N	\N
1419	37	178	1	38283096	\N	38283096	\N	\N	0	1	2	f	\N	\N	\N
1420	46	178	1	19757736	\N	19757736	\N	\N	0	1	2	f	\N	\N	\N
1421	77	178	1	13768418	\N	13768418	\N	\N	0	1	2	f	\N	\N	\N
1422	105	178	1	3930454	\N	3930454	\N	\N	0	1	2	f	\N	\N	\N
1423	100	178	1	1054262	\N	1054262	\N	\N	0	1	2	f	\N	\N	\N
1424	117	178	1	587440	\N	587440	\N	\N	0	1	2	f	\N	\N	\N
1425	98	178	1	159228	\N	159228	\N	\N	0	1	2	f	\N	\N	\N
1426	63	178	1	67320	\N	67320	\N	\N	0	1	2	f	\N	\N	\N
1427	90	178	1	59794	\N	59794	\N	\N	0	1	2	f	\N	\N	\N
1428	47	178	1	56584	\N	56584	\N	\N	0	1	2	f	\N	\N	\N
1429	116	178	1	35650	\N	35650	\N	\N	0	1	2	f	\N	\N	\N
1430	5	178	1	22510	\N	22510	\N	\N	0	1	2	f	\N	\N	\N
1431	118	178	1	17048	\N	17048	\N	\N	0	1	2	f	\N	\N	\N
1432	120	178	1	12520	\N	12520	\N	\N	0	1	2	f	\N	\N	\N
1433	38	178	1	9668	\N	9668	\N	\N	0	1	2	f	\N	\N	\N
1434	97	178	1	4532	\N	4532	\N	\N	0	1	2	f	\N	\N	\N
1435	106	178	1	1904	\N	1904	\N	\N	0	1	2	f	\N	\N	\N
1436	123	178	1	66	\N	66	\N	\N	0	1	2	f	\N	\N	\N
1437	109	178	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1438	88	178	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1439	69	179	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1440	24	179	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1441	25	179	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1442	85	179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1443	94	179	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1444	104	180	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1445	2	181	2	19	\N	16	\N	\N	1	1	2	f	3	\N	\N
1446	4	181	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1447	83	182	2	3520	\N	0	\N	\N	1	1	2	f	3520	\N	\N
1448	64	182	2	768	\N	0	\N	\N	2	1	2	f	768	\N	\N
1449	110	182	2	576	\N	0	\N	\N	3	1	2	f	576	\N	\N
1450	50	182	2	64	\N	0	\N	\N	4	1	2	f	64	\N	\N
1451	24	182	2	16	\N	0	\N	\N	5	1	2	f	16	\N	\N
1452	4	182	2	4	\N	0	\N	\N	6	1	2	f	4	\N	\N
1453	25	182	2	1408	\N	0	\N	\N	0	1	2	f	1408	\N	\N
1454	114	182	2	160	\N	0	\N	\N	0	1	2	f	160	\N	\N
1455	43	182	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1456	2	182	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1457	3	182	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1458	11	183	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1459	102	183	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1460	81	183	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1461	82	183	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1462	80	183	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1463	40	183	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1464	68	184	2	115	\N	0	\N	\N	1	1	2	f	115	\N	\N
1465	4	185	2	8	\N	4	\N	\N	1	1	2	f	4	\N	\N
1466	2	185	2	8	\N	4	\N	\N	0	1	2	f	4	\N	\N
1467	3	185	2	8	\N	4	\N	\N	0	1	2	f	4	\N	\N
1468	125	186	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
1469	70	187	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1470	83	188	2	2945	\N	0	\N	\N	1	1	2	f	2945	\N	\N
1471	64	188	2	192	\N	0	\N	\N	2	1	2	f	192	\N	\N
1472	125	188	2	100	\N	0	\N	\N	3	1	2	f	100	\N	\N
1473	24	188	2	16	\N	0	\N	\N	4	1	2	f	16	\N	\N
1474	2	188	2	6	\N	0	\N	\N	5	1	2	f	6	\N	\N
1475	25	188	2	192	\N	0	\N	\N	0	1	2	f	192	\N	\N
1476	114	188	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
1477	43	188	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1478	4	188	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1479	3	188	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1480	115	188	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1481	128	189	2	4308	\N	0	\N	\N	1	1	2	f	4308	\N	\N
1482	68	190	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
1483	24	190	1	127	\N	127	\N	\N	1	1	2	f	\N	\N	\N
1484	68	191	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1485	28	192	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1486	2	192	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1487	51	193	2	2573868	\N	2573868	\N	\N	1	1	2	f	0	\N	\N
1488	24	193	1	2573868	\N	2573868	\N	\N	1	1	2	f	\N	\N	\N
1489	24	194	2	2163	\N	2163	\N	\N	1	1	2	f	0	\N	\N
1490	64	194	2	7	\N	7	\N	\N	2	1	2	f	0	\N	\N
1491	115	194	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
1492	25	194	2	800	\N	800	\N	\N	0	1	2	f	0	\N	\N
1493	83	194	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1494	85	194	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1495	94	194	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1496	42	194	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1497	24	194	1	1909	\N	1909	\N	\N	1	1	2	f	\N	\N	\N
1498	68	194	1	176	\N	176	\N	\N	2	1	2	f	\N	\N	\N
1499	50	194	1	32	\N	32	\N	\N	3	1	2	f	\N	\N	\N
1500	25	194	1	819	\N	819	\N	\N	0	1	2	f	\N	\N	\N
1501	81	195	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1502	28	195	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
1503	102	195	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1504	11	195	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1505	82	195	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1506	80	195	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1507	40	195	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1508	2	195	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
1509	51	196	2	59066	\N	59066	\N	\N	1	1	2	f	0	\N	\N
1510	24	196	1	59066	\N	59066	\N	\N	1	1	2	f	\N	\N	\N
1511	68	197	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
1512	128	198	2	5005	\N	0	\N	\N	1	1	2	f	5005	\N	\N
1513	4	199	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
1514	2	199	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1515	83	200	2	1563	\N	1563	\N	\N	1	1	2	f	0	\N	\N
1516	115	200	2	659	\N	659	\N	\N	2	1	2	f	0	\N	\N
1517	93	200	2	386	\N	386	\N	\N	3	1	2	f	0	\N	\N
1518	114	200	2	80	\N	80	\N	\N	4	1	2	f	0	\N	\N
1519	67	200	2	17	\N	17	\N	\N	5	1	2	f	0	\N	\N
1520	3	200	2	150	\N	150	\N	\N	0	1	2	f	0	\N	\N
1521	22	200	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
1522	9	200	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1523	103	200	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
1524	23	200	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
1525	39	200	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1526	113	200	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
1527	43	200	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1528	33	200	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1529	24	200	1	695	\N	695	\N	\N	1	1	2	f	\N	\N	\N
1530	64	200	1	18	\N	18	\N	\N	2	1	2	f	\N	\N	\N
1531	83	200	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
1532	25	200	1	407	\N	407	\N	\N	0	1	2	f	\N	\N	\N
1533	42	200	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1534	94	200	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1535	25	201	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1536	83	202	2	116	\N	116	\N	\N	1	1	2	f	0	\N	\N
1537	114	202	2	26	\N	26	\N	\N	2	1	2	f	0	\N	\N
1538	93	202	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1539	115	202	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1540	103	202	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1541	83	202	1	213	\N	213	\N	\N	1	1	2	f	\N	\N	\N
1542	114	202	1	50	\N	50	\N	\N	2	1	2	f	\N	\N	\N
1543	115	202	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
1544	93	202	1	13	\N	13	\N	\N	0	1	2	f	\N	\N	\N
1545	103	202	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1546	23	202	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1547	43	202	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1548	2	203	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1549	65	204	2	12033488	\N	12033488	\N	\N	1	1	2	f	0	\N	\N
1550	79	204	2	3876430	\N	3876430	\N	\N	0	1	2	f	0	\N	\N
1551	99	204	2	3449273	\N	3449273	\N	\N	0	1	2	f	0	\N	\N
1552	71	204	2	2564707	\N	2564707	\N	\N	0	1	2	f	0	\N	\N
1553	75	204	2	1663006	\N	1663006	\N	\N	0	1	2	f	0	\N	\N
1554	32	204	2	212591	\N	212591	\N	\N	0	1	2	f	0	\N	\N
1555	19	204	2	81031	\N	81031	\N	\N	0	1	2	f	0	\N	\N
1556	108	204	2	69925	\N	69925	\N	\N	0	1	2	f	0	\N	\N
1557	56	204	2	26924	\N	26924	\N	\N	0	1	2	f	0	\N	\N
1558	6	204	2	5584	\N	5584	\N	\N	0	1	2	f	0	\N	\N
1559	36	204	2	5175	\N	5175	\N	\N	0	1	2	f	0	\N	\N
1560	29	204	2	2496	\N	2496	\N	\N	0	1	2	f	0	\N	\N
1561	48	204	2	601	\N	601	\N	\N	0	1	2	f	0	\N	\N
1562	76	204	2	508	\N	508	\N	\N	0	1	2	f	0	\N	\N
1563	66	204	2	421	\N	421	\N	\N	0	1	2	f	0	\N	\N
1564	126	204	2	421	\N	421	\N	\N	0	1	2	f	0	\N	\N
1565	8	204	2	246	\N	246	\N	\N	0	1	2	f	0	\N	\N
1566	86	204	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
1567	44	204	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
1568	59	204	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1569	45	204	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1570	21	204	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1571	51	204	1	12033308	\N	12033308	\N	\N	1	1	2	f	\N	\N	\N
1572	52	205	2	837932	\N	837932	\N	\N	1	1	2	f	0	\N	\N
1573	65	205	1	605449	\N	605449	\N	\N	1	1	2	f	\N	\N	\N
1574	112	205	1	245156	\N	245156	\N	\N	2	1	2	f	\N	\N	\N
1575	78	205	1	19712	\N	19712	\N	\N	3	1	2	f	\N	\N	\N
1576	75	205	1	443212	\N	443212	\N	\N	0	1	2	f	\N	\N	\N
1577	99	205	1	57023	\N	57023	\N	\N	0	1	2	f	\N	\N	\N
1578	71	205	1	52326	\N	52326	\N	\N	0	1	2	f	\N	\N	\N
1579	79	205	1	31694	\N	31694	\N	\N	0	1	2	f	\N	\N	\N
1580	62	205	1	20641	\N	20641	\N	\N	0	1	2	f	\N	\N	\N
1581	32	205	1	20352	\N	20352	\N	\N	0	1	2	f	\N	\N	\N
1582	56	205	1	5933	\N	5933	\N	\N	0	1	2	f	\N	\N	\N
1583	19	205	1	4675	\N	4675	\N	\N	0	1	2	f	\N	\N	\N
1584	20	205	1	3660	\N	3660	\N	\N	0	1	2	f	\N	\N	\N
1585	108	205	1	3139	\N	3139	\N	\N	0	1	2	f	\N	\N	\N
1586	101	205	1	1479	\N	1479	\N	\N	0	1	2	f	\N	\N	\N
1587	45	205	1	1178	\N	1178	\N	\N	0	1	2	f	\N	\N	\N
1588	89	205	1	954	\N	954	\N	\N	0	1	2	f	\N	\N	\N
1589	6	205	1	363	\N	363	\N	\N	0	1	2	f	\N	\N	\N
1590	36	205	1	324	\N	324	\N	\N	0	1	2	f	\N	\N	\N
1591	48	205	1	318	\N	318	\N	\N	0	1	2	f	\N	\N	\N
1592	58	205	1	281	\N	281	\N	\N	0	1	2	f	\N	\N	\N
1593	21	205	1	237	\N	237	\N	\N	0	1	2	f	\N	\N	\N
1594	76	205	1	223	\N	223	\N	\N	0	1	2	f	\N	\N	\N
1595	29	205	1	198	\N	198	\N	\N	0	1	2	f	\N	\N	\N
1596	126	205	1	38	\N	38	\N	\N	0	1	2	f	\N	\N	\N
1597	86	205	1	35	\N	35	\N	\N	0	1	2	f	\N	\N	\N
1598	124	205	1	29	\N	29	\N	\N	0	1	2	f	\N	\N	\N
1599	59	205	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
1600	66	205	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1601	2	207	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
1602	3	207	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1603	4	207	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1604	1	208	2	48939	\N	48939	\N	\N	1	1	2	f	0	\N	\N
1605	1	208	1	28763	\N	28763	\N	\N	1	1	2	f	\N	\N	\N
1606	128	209	2	105128	\N	0	\N	\N	1	1	2	f	105128	\N	\N
1607	2	210	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
1608	4	210	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1609	1	211	2	1755	\N	1755	\N	\N	1	1	2	f	0	\N	\N
1610	1	211	1	1432	\N	1432	\N	\N	1	1	2	f	\N	\N	\N
1611	2	212	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1612	4	212	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1613	3	212	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1614	1	214	2	216135	\N	216135	\N	\N	1	1	2	f	0	\N	\N
1615	64	214	2	774	\N	774	\N	\N	2	1	2	f	0	\N	\N
1616	110	214	2	512	\N	512	\N	\N	3	1	2	f	0	\N	\N
1617	2	214	2	11	\N	7	\N	\N	4	1	2	f	4	\N	\N
1618	34	214	2	6	\N	6	\N	\N	5	1	2	f	0	\N	\N
1619	83	214	2	3	\N	3	\N	\N	6	1	2	f	0	\N	\N
1620	55	214	2	2	\N	2	\N	\N	7	1	2	f	0	\N	\N
1621	69	214	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
1622	14	214	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1623	25	214	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1624	115	214	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1625	65	215	2	45956719	\N	45956719	\N	\N	1	1	2	f	0	\N	\N
1626	51	215	2	32771717	\N	32771717	\N	\N	2	1	2	f	0	\N	\N
1627	112	215	2	20617862	\N	20617862	\N	\N	3	1	2	f	0	\N	\N
1628	78	215	2	14880250	\N	14880250	\N	\N	4	1	2	f	0	\N	\N
1629	10	215	2	11136838	\N	11136838	\N	\N	5	1	2	f	0	\N	\N
1630	91	215	2	1080561	\N	1080561	\N	\N	6	1	2	f	0	\N	\N
1631	52	215	2	837932	\N	837932	\N	\N	7	1	2	f	0	\N	\N
1632	128	215	2	116587	\N	116587	\N	\N	8	1	2	f	0	\N	\N
1633	1	215	2	45564	\N	45564	\N	\N	9	1	2	f	0	\N	\N
1634	83	215	2	5014	\N	5014	\N	\N	10	1	2	f	0	\N	\N
1635	3	215	2	4162	\N	4162	\N	\N	11	1	2	f	0	\N	\N
1636	24	215	2	2693	\N	2693	\N	\N	12	1	2	f	0	\N	\N
1637	115	215	2	1374	\N	1374	\N	\N	13	1	2	f	0	\N	\N
1638	93	215	2	806	\N	806	\N	\N	14	1	2	f	0	\N	\N
1639	64	215	2	781	\N	781	\N	\N	15	1	2	f	0	\N	\N
1640	68	215	2	681	\N	681	\N	\N	16	1	2	f	0	\N	\N
1641	110	215	2	576	\N	576	\N	\N	17	1	2	f	0	\N	\N
1642	114	215	2	348	\N	348	\N	\N	18	1	2	f	0	\N	\N
1643	50	215	2	128	\N	128	\N	\N	19	1	2	f	0	\N	\N
1644	103	215	2	76	\N	76	\N	\N	20	1	2	f	0	\N	\N
1645	43	215	2	18	\N	18	\N	\N	20	1	2	f	0	\N	\N
1646	2	215	2	52	\N	52	\N	\N	21	1	2	f	0	\N	\N
1647	41	215	2	52	\N	52	\N	\N	22	1	2	f	0	\N	\N
1648	125	215	2	50	\N	50	\N	\N	23	1	2	f	0	\N	\N
1649	67	215	2	31	\N	31	\N	\N	24	1	2	f	0	\N	\N
1650	12	215	2	26	\N	26	\N	\N	25	1	2	f	0	\N	\N
1651	14	215	2	24	\N	24	\N	\N	26	1	2	f	0	\N	\N
1652	81	215	2	20	\N	20	\N	\N	27	1	2	f	0	\N	\N
1653	13	215	2	12	\N	12	\N	\N	29	1	2	f	0	\N	\N
1654	28	215	2	11	\N	11	\N	\N	30	1	2	f	0	\N	\N
1655	34	215	2	4	\N	4	\N	\N	31	1	2	f	0	\N	\N
1656	84	215	2	4	\N	4	\N	\N	32	1	2	f	0	\N	\N
1657	69	215	2	3	\N	3	\N	\N	33	1	2	f	0	\N	\N
1658	26	215	2	1	\N	1	\N	\N	34	1	2	f	0	\N	\N
1659	104	215	2	1	\N	1	\N	\N	35	1	2	f	0	\N	\N
1660	27	215	2	1	\N	1	\N	\N	36	1	2	f	0	\N	\N
1661	70	215	2	1	\N	1	\N	\N	37	1	2	f	0	\N	\N
1662	79	215	2	28127031	\N	28127031	\N	\N	0	1	2	f	0	\N	\N
1663	99	215	2	14874822	\N	14874822	\N	\N	0	1	2	f	0	\N	\N
1664	75	215	2	13644575	\N	13644575	\N	\N	0	1	2	f	0	\N	\N
1665	71	215	2	3765767	\N	3765767	\N	\N	0	1	2	f	0	\N	\N
1666	32	215	2	1915194	\N	1915194	\N	\N	0	1	2	f	0	\N	\N
1667	108	215	2	1225300	\N	1225300	\N	\N	0	1	2	f	0	\N	\N
1668	19	215	2	918759	\N	918759	\N	\N	0	1	2	f	0	\N	\N
1669	62	215	2	857782	\N	857782	\N	\N	0	1	2	f	0	\N	\N
1670	56	215	2	448110	\N	448110	\N	\N	0	1	2	f	0	\N	\N
1671	101	215	2	268956	\N	268956	\N	\N	0	1	2	f	0	\N	\N
1672	6	215	2	70391	\N	70391	\N	\N	0	1	2	f	0	\N	\N
1673	36	215	2	62320	\N	62320	\N	\N	0	1	2	f	0	\N	\N
1674	45	215	2	44072	\N	44072	\N	\N	0	1	2	f	0	\N	\N
1675	29	215	2	42786	\N	42786	\N	\N	0	1	2	f	0	\N	\N
1676	48	215	2	31578	\N	31578	\N	\N	0	1	2	f	0	\N	\N
1677	20	215	2	30223	\N	30223	\N	\N	0	1	2	f	0	\N	\N
1678	89	215	2	19436	\N	19436	\N	\N	0	1	2	f	0	\N	\N
1679	58	215	2	17180	\N	17180	\N	\N	0	1	2	f	0	\N	\N
1680	59	215	2	15231	\N	15231	\N	\N	0	1	2	f	0	\N	\N
1681	21	215	2	13257	\N	13257	\N	\N	0	1	2	f	0	\N	\N
1682	8	215	2	6700	\N	6700	\N	\N	0	1	2	f	0	\N	\N
1683	76	215	2	5964	\N	5964	\N	\N	0	1	2	f	0	\N	\N
1684	124	215	2	5246	\N	5246	\N	\N	0	1	2	f	0	\N	\N
1685	92	215	2	3744	\N	3744	\N	\N	0	1	2	f	0	\N	\N
1686	44	215	2	2636	\N	2636	\N	\N	0	1	2	f	0	\N	\N
1687	86	215	2	2172	\N	2172	\N	\N	0	1	2	f	0	\N	\N
1688	37	215	2	1804	\N	1804	\N	\N	0	1	2	f	0	\N	\N
1689	25	215	2	1792	\N	1792	\N	\N	0	1	2	f	0	\N	\N
1690	123	215	2	1292	\N	1292	\N	\N	0	1	2	f	0	\N	\N
1691	5	215	2	1134	\N	1134	\N	\N	0	1	2	f	0	\N	\N
1692	90	215	2	416	\N	416	\N	\N	0	1	2	f	0	\N	\N
1693	98	215	2	408	\N	408	\N	\N	0	1	2	f	0	\N	\N
1694	15	215	2	384	\N	384	\N	\N	0	1	2	f	0	\N	\N
1695	38	215	2	224	\N	224	\N	\N	0	1	2	f	0	\N	\N
1696	97	215	2	220	\N	220	\N	\N	0	1	2	f	0	\N	\N
1697	120	215	2	184	\N	184	\N	\N	0	1	2	f	0	\N	\N
1698	18	215	2	182	\N	182	\N	\N	0	1	2	f	0	\N	\N
1699	47	215	2	176	\N	176	\N	\N	0	1	2	f	0	\N	\N
1700	9	215	2	154	\N	154	\N	\N	0	1	2	f	0	\N	\N
1701	63	215	2	132	\N	132	\N	\N	0	1	2	f	0	\N	\N
1702	109	215	2	132	\N	132	\N	\N	0	1	2	f	0	\N	\N
1703	105	215	2	128	\N	128	\N	\N	0	1	2	f	0	\N	\N
1704	77	215	2	112	\N	112	\N	\N	0	1	2	f	0	\N	\N
1705	100	215	2	96	\N	96	\N	\N	0	1	2	f	0	\N	\N
1706	22	215	2	96	\N	96	\N	\N	0	1	2	f	0	\N	\N
1707	23	215	2	87	\N	87	\N	\N	0	1	2	f	0	\N	\N
1708	61	215	2	84	\N	84	\N	\N	0	1	2	f	0	\N	\N
1709	116	215	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
1710	46	215	2	80	\N	80	\N	\N	0	1	2	f	0	\N	\N
1711	117	215	2	64	\N	64	\N	\N	0	1	2	f	0	\N	\N
1712	57	215	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1713	121	215	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1714	106	215	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1715	49	215	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
1716	39	215	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
1717	35	215	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
1718	118	215	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1719	119	215	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1720	17	215	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1721	88	215	2	48	\N	48	\N	\N	0	1	2	f	0	\N	\N
1722	87	215	2	44	\N	44	\N	\N	0	1	2	f	0	\N	\N
1723	111	215	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1724	127	215	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
1725	31	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1726	73	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1727	7	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1728	60	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1729	95	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1730	107	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1731	30	215	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
1732	122	215	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
1733	4	215	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1734	33	215	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1735	74	215	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1736	16	215	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1737	96	215	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1738	113	215	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
1739	102	215	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1740	72	215	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1741	11	215	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1742	53	215	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1743	54	215	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1744	55	215	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1745	66	215	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1746	126	215	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1747	80	215	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1748	40	215	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1749	82	215	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1750	85	215	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1751	94	215	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1752	42	215	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1753	24	215	1	252170775	\N	252170775	\N	\N	1	1	2	f	\N	\N	\N
1754	25	215	1	963716	\N	963716	\N	\N	0	1	2	f	\N	\N	\N
1755	65	216	2	201580	\N	201580	\N	\N	1	1	2	f	0	\N	\N
1756	79	216	2	167200	\N	167200	\N	\N	0	1	2	f	0	\N	\N
1757	75	216	2	159369	\N	159369	\N	\N	0	1	2	f	0	\N	\N
1758	32	216	2	34380	\N	34380	\N	\N	0	1	2	f	0	\N	\N
1759	19	216	2	34279	\N	34279	\N	\N	0	1	2	f	0	\N	\N
1760	108	216	2	7810	\N	7810	\N	\N	0	1	2	f	0	\N	\N
1761	71	216	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1762	99	216	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1763	29	216	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1764	24	216	1	201562	\N	201562	\N	\N	1	1	2	f	\N	\N	\N
1765	128	217	2	4308	\N	0	\N	\N	1	1	2	f	4308	\N	\N
1766	2	219	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
1767	4	219	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1768	3	219	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1769	2	219	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
1770	4	219	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
1771	78	220	2	22549	\N	22549	\N	\N	1	1	2	f	0	\N	\N
1772	65	220	2	3840	\N	3840	\N	\N	2	1	2	f	0	\N	\N
1773	112	220	2	503	\N	503	\N	\N	3	1	2	f	0	\N	\N
1774	79	220	2	3203	\N	3203	\N	\N	0	1	2	f	0	\N	\N
1775	32	220	2	431	\N	431	\N	\N	0	1	2	f	0	\N	\N
1776	75	220	2	361	\N	361	\N	\N	0	1	2	f	0	\N	\N
1777	108	220	2	200	\N	200	\N	\N	0	1	2	f	0	\N	\N
1778	19	220	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
1779	71	220	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1780	99	220	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1781	112	220	1	31145	\N	31145	\N	\N	1	1	2	f	\N	\N	\N
1782	28	221	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1783	2	221	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1784	81	222	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1785	2	222	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
1786	34	222	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
1787	102	222	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1788	11	222	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1789	28	222	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1790	82	222	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1791	80	222	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1792	40	222	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1793	78	223	2	14880250	\N	0	\N	\N	1	1	2	f	14880250	\N	\N
1794	91	223	2	537204	\N	0	\N	\N	2	1	2	f	537204	\N	\N
1795	65	224	2	20892727	\N	20892727	\N	\N	1	1	2	f	0	\N	\N
1796	79	224	2	10201385	\N	10201385	\N	\N	0	1	2	f	0	\N	\N
1797	99	224	2	5887076	\N	5887076	\N	\N	0	1	2	f	0	\N	\N
1798	75	224	2	5318600	\N	5318600	\N	\N	0	1	2	f	0	\N	\N
1799	71	224	2	1365974	\N	1365974	\N	\N	0	1	2	f	0	\N	\N
1800	32	224	2	748996	\N	748996	\N	\N	0	1	2	f	0	\N	\N
1801	62	224	2	427113	\N	427113	\N	\N	0	1	2	f	0	\N	\N
1802	108	224	2	411181	\N	411181	\N	\N	0	1	2	f	0	\N	\N
1803	19	224	2	306253	\N	306253	\N	\N	0	1	2	f	0	\N	\N
1804	56	224	2	168761	\N	168761	\N	\N	0	1	2	f	0	\N	\N
1805	101	224	2	89652	\N	89652	\N	\N	0	1	2	f	0	\N	\N
1806	6	224	2	24009	\N	24009	\N	\N	0	1	2	f	0	\N	\N
1807	36	224	2	21808	\N	21808	\N	\N	0	1	2	f	0	\N	\N
1808	48	224	2	15789	\N	15789	\N	\N	0	1	2	f	0	\N	\N
1809	45	224	2	15313	\N	15313	\N	\N	0	1	2	f	0	\N	\N
1810	29	224	2	14262	\N	14262	\N	\N	0	1	2	f	0	\N	\N
1811	20	224	2	11958	\N	11958	\N	\N	0	1	2	f	0	\N	\N
1812	89	224	2	9718	\N	9718	\N	\N	0	1	2	f	0	\N	\N
1813	58	224	2	5882	\N	5882	\N	\N	0	1	2	f	0	\N	\N
1814	59	224	2	5077	\N	5077	\N	\N	0	1	2	f	0	\N	\N
1815	21	224	2	4419	\N	4419	\N	\N	0	1	2	f	0	\N	\N
1816	8	224	2	3350	\N	3350	\N	\N	0	1	2	f	0	\N	\N
1817	76	224	2	2532	\N	2532	\N	\N	0	1	2	f	0	\N	\N
1818	124	224	2	1753	\N	1753	\N	\N	0	1	2	f	0	\N	\N
1819	44	224	2	1318	\N	1318	\N	\N	0	1	2	f	0	\N	\N
1820	86	224	2	743	\N	743	\N	\N	0	1	2	f	0	\N	\N
1821	5	224	2	519	\N	519	\N	\N	0	1	2	f	0	\N	\N
1822	123	224	2	448	\N	448	\N	\N	0	1	2	f	0	\N	\N
1823	18	224	2	91	\N	91	\N	\N	0	1	2	f	0	\N	\N
1824	72	224	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
1825	66	224	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1826	126	224	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1827	51	224	1	20738718	\N	20738718	\N	\N	1	1	2	f	\N	\N	\N
1828	69	228	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1829	28	229	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1830	81	229	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1831	102	229	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1832	2	229	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1833	34	232	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1834	41	233	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
1835	35	233	1	26	\N	26	\N	\N	0	1	2	f	\N	\N	\N
1836	2	234	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1837	4	234	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1838	3	234	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1839	2	235	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1840	78	236	2	268457	\N	268457	\N	\N	1	1	2	f	0	\N	\N
1841	65	236	2	125742	\N	125742	\N	\N	2	1	2	f	0	\N	\N
1842	112	236	2	1950	\N	1950	\N	\N	3	1	2	f	0	\N	\N
1843	79	236	2	66248	\N	66248	\N	\N	0	1	2	f	0	\N	\N
1844	75	236	2	15510	\N	15510	\N	\N	0	1	2	f	0	\N	\N
1845	71	236	2	11740	\N	11740	\N	\N	0	1	2	f	0	\N	\N
1846	99	236	2	10466	\N	10466	\N	\N	0	1	2	f	0	\N	\N
1847	32	236	2	1589	\N	1589	\N	\N	0	1	2	f	0	\N	\N
1848	56	236	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
1849	19	236	2	329	\N	329	\N	\N	0	1	2	f	0	\N	\N
1850	89	236	2	309	\N	309	\N	\N	0	1	2	f	0	\N	\N
1851	101	236	2	145	\N	145	\N	\N	0	1	2	f	0	\N	\N
1852	20	236	2	114	\N	114	\N	\N	0	1	2	f	0	\N	\N
1853	21	236	2	85	\N	85	\N	\N	0	1	2	f	0	\N	\N
1854	108	236	2	83	\N	83	\N	\N	0	1	2	f	0	\N	\N
1855	6	236	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
1856	48	236	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
1857	29	236	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1858	45	236	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
1859	36	236	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1860	62	236	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1861	58	236	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1862	59	236	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1863	76	236	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1864	8	236	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1865	126	236	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1866	5	236	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1867	112	236	1	425944	\N	425944	\N	\N	1	1	2	f	\N	\N	\N
1868	68	237	2	681	\N	681	\N	\N	1	1	2	f	0	\N	\N
1869	115	237	1	1201	\N	1201	\N	\N	1	1	2	f	\N	\N	\N
1870	83	237	1	104	\N	104	\N	\N	2	1	2	f	\N	\N	\N
1871	93	237	1	59	\N	59	\N	\N	3	1	2	f	\N	\N	\N
1872	23	237	1	74	\N	74	\N	\N	0	1	2	f	\N	\N	\N
1873	3	237	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1874	9	237	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1875	103	237	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1876	83	238	2	64	\N	64	\N	\N	1	1	2	f	0	\N	\N
1877	25	238	1	64	\N	64	\N	\N	0	1	2	f	\N	\N	\N
1878	34	239	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1879	69	239	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1880	68	240	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1881	24	240	1	33	\N	33	\N	\N	1	1	2	f	\N	\N	\N
1882	25	240	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1883	125	241	2	50	\N	0	\N	\N	1	1	2	f	50	\N	\N
1884	2	241	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1885	70	241	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1886	51	242	2	2584362	\N	2584362	\N	\N	1	1	2	f	0	\N	\N
1887	24	242	1	2584358	\N	2584358	\N	\N	1	1	2	f	\N	\N	\N
1888	11	243	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1889	102	243	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1890	81	243	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1891	82	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1892	80	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1893	40	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1894	2	243	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1895	52	244	2	837932	\N	837932	\N	\N	1	1	2	f	0	\N	\N
1896	115	244	1	1674160	\N	1674160	\N	\N	1	1	2	f	\N	\N	\N
1897	3	244	1	1373686	\N	1373686	\N	\N	0	1	2	f	\N	\N	\N
1898	22	244	1	1373686	\N	1373686	\N	\N	0	1	2	f	\N	\N	\N
1899	113	244	1	300474	\N	300474	\N	\N	0	1	2	f	\N	\N	\N
1900	104	245	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://www.lexinfo.net/ontology/2.0/lexinfo#	0	t	0
70	qb	http://purl.org/linked-data/cube#	0	f	0
71	xhv	http://www.w3.org/1999/xhtml/vocab#	0	f	0
72	dcam	http://purl.org/dc/dcam/	0	f	0
73	vs	http://www.w3.org/2003/06/sw-vocab-status/ns#	0	f	0
74	ldp	http://www.w3.org/ns/ldp#	0	f	0
75	ov	http://open.vocab.org/terms/	0	f	0
77	ontolex	http://www.w3.org/ns/lemon/ontolex#	0	f	0
78	dbnary	http://kaiko.getalp.org/dbnary#	0	f	0
80	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
81	olia	http://purl.org/olia/olia.owl#	0	f	0
83	lime	http://www.w3.org/ns/lemon/lime#	0	f	0
85	sdo	https://schema.org/	0	f	0
86	wdrs	http://www.w3.org/2007/05/powder-s#	0	f	0
87	dcr	http://www.isocat.org/ns/dcr.rdf#	0	f	0
88	vartrans	http://www.w3.org/ns/lemon/vartrans#	0	f	0
89	grddl	http://www.w3.org/2003/g/data-view#	0	f	0
76	ethym	http://etytree-virtuoso.wmflabs.org/dbnaryetymology#	0	f	0
79	vcard-rdf	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
82	vspx	http://www.openlinksw.com/schemas/VSPX#	0	f	0
84	dc-11	http://purl.org/dc/elements/1.1/#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_kaiko_getalp_org_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_kaiko_getalp_org_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://kaiko.getalp.org/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://kaiko.getalp.org/sparql", "correlationId": "8108044040731206766", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:33:23.155Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://xmlns.com/foaf/0.1/page	50	\N	8	page	page	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://www.w3.org/2004/02/skos/core#note	1884723	\N	4	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.lexinfo.net/ontology/2.0/lexinfo#case	592	\N	69	case	case	f	592	\N	\N	f	f	51	15	\N	t	f	\N	\N	\N	t	f	f
4	http://creativecommons.org/ns#attributionURL	2	\N	23	attributionURL	attributionURL	f	2	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://www.lexinfo.net/ontology/2.0/lexinfo#tense	3132493	\N	69	tense	tense	f	3132493	\N	\N	f	f	51	49	\N	t	f	\N	\N	\N	t	f	f
6	http://kaiko.getalp.org/dbnary#targetLanguageCode	34406	\N	78	targetLanguageCode	targetLanguageCode	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://kaiko.getalp.org/dbnary#describes	20765966	\N	78	describes	describes	f	20765966	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://schema.org/dateCreated	6	\N	9	dateCreated	dateCreated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://kaiko.getalp.org/dbnary#writtenForm	11135169	\N	78	writtenForm	writtenForm	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.lexinfo.net/ontology/2.0/lexinfo#verbFormMood	3284069	\N	69	verbFormMood	verbFormMood	f	3284069	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/1999/xhtml/vocab#canonical	6	\N	71	canonical	canonical	f	6	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://kaiko.getalp.org/dbnary#observationLanguage	116559	\N	78	observationLanguage	observationLanguage	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://www.w3.org/2002/07/owl#equivalentClass	679	\N	7	equivalentClass	equivalentClass	f	679	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://purl.org/dc/elements/1.1/#creator	700	\N	84	creator	creator	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://www.lexinfo.net/ontology/2.0/lexinfo#abbreviationFor	675	\N	69	abbreviationFor	abbreviationFor	f	0	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	69	42	\N	t	f	\N	\N	\N	t	f	f
18	http://purl.org/dc/elements/1.1/date	1	\N	6	date	date	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
20	https://schema.org/creator	4	\N	85	creator	creator	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://kaiko.getalp.org/dbnary#translationsWithNoGloss	2154	\N	78	translationsWithNoGloss	translationsWithNoGloss	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://purl.org/dc/elements/1.1/description	8	\N	6	description	description	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://www.w3.org/ns/lemon/lime#linguisticCatalog	150	\N	83	linguisticCatalog	linguisticCatalog	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/2002/07/owl#minQualifiedCardinality	44	\N	7	minQualifiedCardinality	minQualifiedCardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/2002/07/owl#priorVersion	3	\N	7	priorVersion	priorVersion	f	3	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://www.lexinfo.net/ontology/2.0/lexinfo#example	120	\N	69	example	example	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://schema.org/logo	1	\N	9	logo	logo	f	1	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://purl.org/dc/terms/creator	57	\N	5	creator	creator	f	55	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://purl.org/olia/olia.owl#hasMood	2837580	\N	81	hasMood	hasMood	f	2837580	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
31	http://purl.org/dc/elements/1.1/modified	7	\N	6	modified	modified	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://www.w3.org/1999/xhtml/vocab#describes	6	\N	71	describes	describes	f	6	\N	\N	f	f	\N	2	\N	t	f	\N	\N	\N	t	f	f
33	http://kaiko.getalp.org/dbnary#usage	2924096	\N	78	usage	usage	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://www.w3.org/ns/lemon/ontolex#phoneticRep	9092770	\N	77	phoneticRep	phoneticRep	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://xmlns.com/foaf/0.1/homepage	52	\N	8	homepage	homepage	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://purl.org/goodrelations/v1#BusinessEntity	2	\N	36	BusinessEntity	BusinessEntity	f	2	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://purl.org/olia/olia.owl#hasSeparability	499	\N	81	hasSeparability	hasSeparability	f	499	\N	\N	f	f	65	24	\N	t	f	\N	\N	\N	t	f	f
38	http://schema.org/mentions	3	\N	9	mentions	mentions	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://purl.org/dc/terms/abstract	2	\N	5	abstract	abstract	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.lexinfo.net/ontology/2.0/lexinfo#referentType	653374	\N	69	referentType	referentType	f	653374	\N	\N	f	f	51	96	\N	t	f	\N	\N	\N	t	f	f
41	http://purl.org/olia/olia.owl#hasNumber	7974105	\N	81	hasNumber	hasNumber	f	7974105	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/2007/05/powder-s#describedby	3	\N	86	describedby	describedby	f	3	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://purl.org/linked-data/cube#dataSet	116559	\N	70	dataSet	dataSet	f	116559	\N	\N	f	f	128	127	\N	t	f	\N	\N	\N	t	f	f
44	http://purl.org/dc/dcam/rangeIncludes	208	\N	72	rangeIncludes	rangeIncludes	f	208	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/dc/terms/modified	1522	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://creativecommons.org/ns#License	2	\N	23	License	License	f	2	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.lexinfo.net/ontology/2.0/lexinfo#gender	2051982	\N	69	gender	gender	f	2051982	\N	\N	f	f	\N	121	\N	t	f	\N	\N	\N	t	f	f
49	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	1603	\N	2	subPropertyOf	subPropertyOf	f	1603	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/2002/07/owl#sameAs	5	\N	7	sameAs	sameAs	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://kaiko.getalp.org/dbnary#rank	626371	\N	78	rank	rank	f	0	\N	\N	f	f	91	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://etytree-virtuoso.wmflabs.org/dbnaryetymology#etymologicallyRelatedTo	57542	\N	76	etymologicallyRelatedTo	etymologicallyRelatedTo	f	57542	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/1999/xhtml/vocab#license	2	\N	71	license	license	f	2	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://www.w3.org/2002/07/owl#deprecated	32	\N	7	deprecated	deprecated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://kaiko.getalp.org/dbnary#wiktionaryDumpVersion	116609	\N	78	wiktionaryDumpVersion	wiktionaryDumpVersion	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	1538	\N	1	first	first	f	1538	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/dc/terms/language	20738762	\N	5	language	language	f	20738762	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://purl.org/olia/olia.owl#hasReferentType	5192	\N	81	hasReferentType	hasReferentType	f	5192	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
59	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	34	69	\N	t	f	\N	\N	\N	t	f	f
60	http://purl.org/olia/olia.owl#hasCase	4122587	\N	81	hasCase	hasCase	f	4122587	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
61	http://www.lexinfo.net/ontology/2.0/lexinfo#root	16400	\N	69	root	root	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://www.w3.org/2004/02/skos/core#example	2477888	\N	4	example	example	f	2477886	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.w3.org/2002/07/owl#cardinality	174	\N	7	cardinality	cardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://purl.org/dc/terms/extent	1457	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://www.w3.org/2000/01/rdf-schema#label	20787359	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/dc/terms/title	116	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://www.w3.org/2002/07/owl#hasValue	75	\N	7	hasValue	hasValue	f	60	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://www.w3.org/1999/02/22-rdf-syntax-ns#object	837080	\N	1	object	object	f	837080	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://purl.org/dc/elements/1.1/title	10	\N	6	title	title	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://purl.org/linked-data/cube#component	130	\N	70	component	component	f	130	\N	\N	f	f	111	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://purl.org/goodrelations/v1#amountOfThisGood	6	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	26	\N	79	EMAIL	EMAIL	f	26	\N	\N	f	f	\N	12	\N	t	f	\N	\N	\N	t	f	f
74	http://www.lexinfo.net/ontology/2.0/lexinfo#number	3230101	\N	69	number	number	f	3230101	\N	\N	f	f	51	123	\N	t	f	\N	\N	\N	t	f	f
75	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	18497494	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://www.w3.org/2002/07/owl#qualifiedCardinality	21	\N	7	qualifiedCardinality	qualifiedCardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/ns/lemon/lime#entry	20892137	\N	83	entry	entry	f	20892137	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://www.w3.org/2004/02/skos/core#scopeNote	11	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://kaiko.getalp.org/dbnary#derivedFrom	2498308	\N	78	derivedFrom	derivedFrom	f	2498308	\N	\N	f	f	112	65	\N	t	f	\N	\N	\N	t	f	f
81	http://schema.org/comment	58	\N	9	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	69	13	\N	t	f	\N	\N	\N	t	f	f
83	http://purl.org/olia/olia.owl#hasTense	2803339	\N	81	hasTense	hasTense	f	2803339	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
84	http://www.isocat.org/ns/dcr.rdf#datcat	714	\N	87	datcat	datcat	f	714	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://www.w3.org/ns/lemon/lime#language	20803814	\N	83	language	language	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://purl.org/olia/olia.owl#hasSyntacticFunction	18068	\N	81	hasSyntacticFunction	hasSyntacticFunction	f	18068	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
87	https://schema.org/dateModified	1	\N	85	dateModified	dateModified	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://purl.org/olia/olia.owl#hasValency	10420	\N	81	hasValency	hasValency	f	10420	\N	\N	f	f	\N	24	\N	t	f	\N	\N	\N	t	f	f
89	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://www.lexinfo.net/ontology/2.0/lexinfo#relatedTerm	10	\N	69	relatedTerm	relatedTerm	f	0	\N	\N	f	f	115	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
92	https://schema.org/about	120	\N	85	about	about	f	120	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://purl.org/olia/olia.owl#hasVoice	2218484	\N	81	hasVoice	hasVoice	f	2218484	\N	\N	f	f	\N	24	\N	t	f	\N	\N	\N	t	f	f
94	http://schema.org/dateModified	6	\N	9	dateModified	dateModified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://www.openlinksw.com/schemas/VSPX#type	1	\N	82	type	type	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://www.w3.org/ns/lemon/vartrans#versionInfo	1	\N	88	versionInfo	versionInfo	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://schema.org/about	424	\N	9	about	about	f	424	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://www.w3.org/2002/07/owl#complementOf	4	\N	7	complementOf	complementOf	f	4	\N	\N	f	f	24	24	\N	t	f	\N	\N	\N	t	f	f
99	http://purl.org/olia/olia.owl#hasDefiniteness	451864	\N	81	hasDefiniteness	hasDefiniteness	f	451864	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://open.vocab.org/terms/defines	337	\N	75	defines	defines	f	337	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://kaiko.getalp.org/dbnary#translationsWithSenseNumber	2154	\N	78	translationsWithSenseNumber	translationsWithSenseNumber	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.lexinfo.net/ontology/2.0/lexinfo#languageSpecific	8	\N	69	languageSpecific	languageSpecific	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://purl.org/linked-data/cube#dimension	65	\N	70	dimension	dimension	f	65	\N	\N	f	f	\N	3	\N	t	f	\N	\N	\N	t	f	f
103	http://www.w3.org/2004/02/skos/core#related	4	\N	4	related	related	f	4	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://www.lexinfo.net/ontology/2.0/lexinfo#frequency	744	\N	69	frequency	frequency	f	744	\N	\N	f	f	51	60	\N	t	f	\N	\N	\N	t	f	f
105	http://www.w3.org/2002/07/owl#intersectionOf	466	\N	7	intersectionOf	intersectionOf	f	466	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://www.w3.org/2002/07/owl#onDataRange	11	\N	7	onDataRange	onDataRange	f	11	\N	\N	f	f	68	64	\N	t	f	\N	\N	\N	t	f	f
107	http://kaiko.getalp.org/dbnary#approximateSynonym	11547	\N	78	approximateSynonym	approximateSynonym	f	11547	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
108	http://purl.org/dc/terms/bibliographicCitation	843076	\N	5	bibliographicCitation	bibliographicCitation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	https://schema.org/dateCreated	1	\N	85	dateCreated	dateCreated	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://www.w3.org/2000/01/rdf-schema#comment	3238	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://schema.org/domainIncludes	35	\N	9	domainIncludes	domainIncludes	f	35	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://creativecommons.org/ns#attributionName	2	\N	23	attributionName	attributionName	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://xmlns.com/foaf/0.1/mbox	5	\N	8	mbox	mbox	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://kaiko.getalp.org/dbnary#gloss	7996259	\N	78	gloss	gloss	f	7996259	\N	\N	f	f	\N	91	\N	t	f	\N	\N	\N	t	f	f
116	http://purl.org/olia/olia.owl#hasInflectionType	1315806	\N	81	hasInflectionType	hasInflectionType	f	1315806	\N	\N	f	f	\N	24	\N	t	f	\N	\N	\N	t	f	f
117	http://www.w3.org/2003/06/sw-vocab-status/ns#term_status	193	\N	73	term_status	term_status	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://purl.org/linked-data/cube#structure	10	\N	70	structure	structure	f	10	\N	\N	f	f	127	111	\N	t	f	\N	\N	\N	t	f	f
119	http://kaiko.getalp.org/dbnary#synonym	2296359	\N	78	synonym	synonym	f	2296359	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
120	http://kaiko.getalp.org/dbnary#holonym	11281	\N	78	holonym	holonym	f	11281	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
121	http://www.w3.org/2000/01/rdf-schema#domain	1019	\N	2	domain	domain	f	1019	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://kaiko.getalp.org/dbnary#hypernym	594905	\N	78	hypernym	hypernym	f	594905	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
123	http://kaiko.getalp.org/dbnary#lexicalEntryCount	5004	\N	78	lexicalEntryCount	lexicalEntryCount	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://schema.org/author	2	\N	9	author	author	f	2	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://purl.org/dc/terms/contributor	22	\N	5	contributor	contributor	f	17	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://purl.org/dc/elements/1.1/contributor	61	\N	6	contributor	contributor	f	60	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://www.w3.org/2002/07/owl#maxCardinality	2	\N	7	maxCardinality	maxCardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://kaiko.getalp.org/dbnary#partOfSpeech	20745954	\N	78	partOfSpeech	partOfSpeech	f	7500	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://purl.org/olia/olia.owl#hasDegree	1720696	\N	81	hasDegree	hasDegree	f	1720696	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
130	http://xmlns.com/foaf/0.1/topic	145	\N	8	topic	topic	f	145	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://kaiko.getalp.org/dbnary#targetLanguage	11100760	\N	78	targetLanguage	targetLanguage	f	11100760	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://www.w3.org/2004/02/skos/core#altLabel	122	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	6	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://www.w3.org/2002/07/owl#inverseOf	34	\N	7	inverseOf	inverseOf	f	34	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://www.lexinfo.net/ontology/2.0/lexinfo#person	3129655	\N	69	person	person	f	3129655	\N	\N	f	f	51	107	\N	t	f	\N	\N	\N	t	f	f
136	http://www.w3.org/ns/lemon/vartrans#imports	1	\N	88	imports	imports	f	1	\N	\N	f	f	4	4	\N	t	f	\N	\N	\N	t	f	f
137	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	1538	\N	1	rest	rest	f	1538	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://www.w3.org/2004/02/skos/core#definition	14905862	\N	4	definition	definition	f	14905830	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://kaiko.getalp.org/dbnary#pageCount	5005	\N	78	pageCount	pageCount	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	2796	\N	2	isDefinedBy	isDefinedBy	f	2686	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://www.w3.org/2001/vcard-rdf/3.0#Street	26	\N	79	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://purl.org/dc/elements/1.1/rights	6	\N	6	rights	rights	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://www.w3.org/2002/07/owl#propertyChainAxiom	25	\N	7	propertyChainAxiom	propertyChainAxiom	f	25	\N	\N	f	f	115	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://www.w3.org/2001/vcard-rdf/3.0#ADR	26	\N	79	ADR	ADR	f	26	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://www.w3.org/ns/lemon/ontolex#sense	14880428	\N	77	sense	sense	f	14880428	\N	\N	f	f	65	78	\N	t	f	\N	\N	\N	t	f	f
146	http://www.w3.org/2002/07/owl#someValuesFrom	173	\N	7	someValuesFrom	someValuesFrom	f	173	\N	\N	f	f	68	24	\N	t	f	\N	\N	\N	t	f	f
147	http://www.w3.org/2002/07/owl#disjointWith	101	\N	7	disjointWith	disjointWith	f	101	\N	\N	f	f	24	24	\N	t	f	\N	\N	\N	t	f	f
148	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://kaiko.getalp.org/dbnary#recallMeasure	4308	\N	78	recallMeasure	recallMeasure	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://www.w3.org/2002/07/owl#unionOf	162	\N	7	unionOf	unionOf	f	162	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://www.w3.org/2002/07/owl#versionInfo	1602	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://purl.org/goodrelations/v1#typeOfGood	6	\N	36	typeOfGood	typeOfGood	f	6	\N	\N	f	f	13	14	\N	t	f	\N	\N	\N	t	f	f
206	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	26	\N	79	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://kaiko.getalp.org/dbnary#translationsWithSenseNumberAndTextualGloss	2154	\N	78	translationsWithSenseNumberAndTextualGloss	translationsWithSenseNumberAndTextualGloss	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://www.w3.org/ns/lemon/lime#lexicalEntries	50	\N	83	lexicalEntries	lexicalEntries	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://kaiko.getalp.org/dbnary#translationsCount	5004	\N	78	translationsCount	translationsCount	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://purl.org/linked-data/cube#measure	65	\N	70	measure	measure	f	65	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
159	http://www.w3.org/ns/lemon/ontolex#writtenRep	33249162	\N	77	writtenRep	writtenRep	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.w3.org/ns/lemon/vartrans#lexicalRel	153635	\N	88	lexicalRel	lexicalRel	f	153635	\N	\N	f	f	65	65	\N	t	f	\N	\N	\N	t	f	f
162	http://www.w3.org/1999/xhtml/vocab#related	1	\N	71	related	related	f	1	\N	\N	f	f	115	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://www.openlinksw.com/schemas/DAV#ownerUser	1458	\N	18	ownerUser	ownerUser	f	1458	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	69	84	\N	t	f	\N	\N	\N	t	f	f
166	http://creativecommons.org/ns#licence	6	\N	23	licence	licence	f	6	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://schema.org/name	4	\N	9	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://www.openlinksw.com/schemas/VSPX#pageId	1	\N	82	pageId	pageId	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://kaiko.getalp.org/dbnary#isTranslationOf	18983221	\N	78	isTranslationOf	isTranslationOf	f	18983221	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://www.w3.org/2002/07/owl#versionIRI	3	\N	7	versionIRI	versionIRI	f	3	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://kaiko.getalp.org/dbnary#translationsWithTextualGloss	2154	\N	78	translationsWithTextualGloss	translationsWithTextualGloss	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://creativecommons.org/ns#license	12	\N	23	license	license	f	12	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://kaiko.getalp.org/dbnary#nymRelation	40041	\N	78	nymRelation	nymRelation	f	40041	\N	\N	f	f	128	22	\N	t	f	\N	\N	\N	t	f	f
175	http://kaiko.getalp.org/dbnary#hyponym	510013	\N	78	hyponym	hyponym	f	510013	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
176	http://schema.org/rangeIncludes	8	\N	9	rangeIncludes	rangeIncludes	f	8	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://kaiko.getalp.org/dbnary#troponym	223	\N	78	troponym	troponym	f	223	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
178	http://www.lexinfo.net/ontology/2.0/lexinfo#partOfSpeech	19955308	\N	69	partOfSpeech	partOfSpeech	f	19955308	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	69	24	\N	t	f	\N	\N	\N	t	f	f
180	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://purl.org/dc/elements/1.1/creator	15	\N	6	creator	creator	f	12	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://purl.org/dc/terms/issued	786	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://schema.org/license	3	\N	9	license	license	f	3	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://www.w3.org/2002/07/owl#minCardinality	115	\N	7	minCardinality	minCardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://purl.org/dc/terms/rights	4	\N	5	rights	rights	f	2	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
186	http://purl.org/dc/terms/source	50	\N	5	source	source	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://www.openlinksw.com/schemas/VSPX#title	1	\N	82	title	title	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://purl.org/dc/terms/description	521	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://kaiko.getalp.org/dbnary#precisionMeasure	4308	\N	78	precisionMeasure	precisionMeasure	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://www.w3.org/2002/07/owl#onClass	66	\N	7	onClass	onClass	f	66	\N	\N	f	f	68	24	\N	t	f	\N	\N	\N	t	f	f
191	http://www.w3.org/2002/07/owl#maxQualifiedCardinality	12	\N	7	maxQualifiedCardinality	maxQualifiedCardinality	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
192	https://schema.org/name	4	\N	85	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://purl.org/olia/olia.owl#hasGender	2573868	\N	81	hasGender	hasGender	f	2573868	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
194	http://www.w3.org/2000/01/rdf-schema#subClassOf	1804	\N	2	subClassOf	subClassOf	f	1804	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://purl.org/dc/terms/subject	9	\N	5	subject	subject	f	9	\N	\N	f	f	\N	2	\N	t	f	\N	\N	\N	t	f	f
196	http://www.lexinfo.net/ontology/2.0/lexinfo#animacy	59066	\N	69	animacy	animacy	f	59066	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
197	http://www.w3.org/2002/07/owl#hasSelf	46	\N	7	hasSelf	hasSelf	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://kaiko.getalp.org/dbnary#lexicalSenseCount	5005	\N	78	lexicalSenseCount	lexicalSenseCount	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://purl.org/dc/elements/1.1/publisher	6	\N	6	publisher	publisher	f	6	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://www.w3.org/2000/01/rdf-schema#range	1068	\N	2	range	range	f	1068	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://www.w3.org/2002/07/owl#oneOf	1	\N	7	oneOf	oneOf	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://www.w3.org/2002/07/owl#equivalentProperty	205	\N	7	equivalentProperty	equivalentProperty	f	205	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://www.w3.org/2003/g/data-view#namespaceTransformation	1	\N	89	namespaceTransformation	namespaceTransformation	f	1	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://www.w3.org/ns/lemon/ontolex#otherForm	12033306	\N	77	otherForm	otherForm	f	12033306	\N	\N	f	f	65	51	\N	t	f	\N	\N	\N	t	f	f
205	http://www.w3.org/1999/02/22-rdf-syntax-ns#subject	837080	\N	1	subject	subject	f	837080	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://purl.org/dc/terms/publisher	11	\N	5	publisher	publisher	f	11	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://etytree-virtuoso.wmflabs.org/dbnaryetymology#etymologicallyDerivesFrom	48939	\N	76	etymologicallyDerivesFrom	etymologicallyDerivesFrom	f	48939	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://kaiko.getalp.org/dbnary#count	105100	\N	78	count	count	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://purl.org/dc/elements/1.1/issued	7	\N	6	issued	issued	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://etytree-virtuoso.wmflabs.org/dbnaryetymology#etymologicallyEquivalentTo	1755	\N	76	etymologicallyEquivalentTo	etymologicallyEquivalentTo	f	1755	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://purl.org/vocab/vann/preferredNamespaceUri	11	\N	24	preferredNamespaceUri	preferredNamespaceUri	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://www.w3.org/2001/vcard-rdf/3.0#Country	26	\N	79	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://www.w3.org/2000/01/rdf-schema#seeAlso	216315	\N	2	seeAlso	seeAlso	f	216313	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://purl.org/olia/olia.owl#hasCountability	201562	\N	81	hasCountability	hasCountability	f	201562	\N	\N	f	f	65	24	\N	t	f	\N	\N	\N	t	f	f
217	http://kaiko.getalp.org/dbnary#enhancementMethod	4308	\N	78	enhancementMethod	enhancementMethod	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://www.w3.org/2001/vcard-rdf/3.0#City	26	\N	79	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://www.w3.org/2002/07/owl#imports	28	\N	7	imports	imports	f	28	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://kaiko.getalp.org/dbnary#meronym	26691	\N	78	meronym	meronym	f	26691	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
221	https://schema.org/comment	4	\N	85	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://schema.org/creator	9	\N	9	creator	creator	f	9	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://kaiko.getalp.org/dbnary#senseNumber	15417292	\N	78	senseNumber	senseNumber	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://www.w3.org/ns/lemon/ontolex#canonicalForm	20892347	\N	77	canonicalForm	canonicalForm	f	20892347	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://xmlns.com/foaf/0.1/primaryTopic	6	\N	8	primaryTopic	primaryTopic	f	6	\N	\N	f	f	28	2	\N	t	f	\N	\N	\N	t	f	f
230	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://www.w3.org/2001/vcard-rdf/3.0#TEL	26	\N	79	TEL	TEL	f	26	\N	\N	f	f	\N	41	\N	t	f	\N	\N	\N	t	f	f
234	http://purl.org/vocab/vann/preferredNamespacePrefix	11	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://purl.org/dc/terms/license	4	\N	5	license	license	f	4	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://kaiko.getalp.org/dbnary#antonym	395357	\N	78	antonym	antonym	f	395357	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
237	http://www.w3.org/2002/07/owl#onProperty	681	\N	7	onProperty	onProperty	f	681	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://purl.org/dc/dcam/domainIncludes	8	\N	72	domainIncludes	domainIncludes	f	8	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://schema.org/offers	3	\N	9	offers	offers	f	3	\N	\N	f	f	34	69	\N	t	f	\N	\N	\N	t	f	f
240	http://www.w3.org/2002/07/owl#allValuesFrom	19	\N	7	allValuesFrom	allValuesFrom	f	19	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.org/dc/terms/created	1510	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://purl.org/olia/olia.owl#hasPerson	2584358	\N	81	hasPerson	hasPerson	f	2584358	\N	\N	f	f	51	24	\N	t	f	\N	\N	\N	t	f	f
243	http://schema.org/mainEntity	3	\N	9	mainEntity	mainEntity	f	3	\N	\N	f	f	11	2	\N	t	f	\N	\N	\N	t	f	f
244	http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate	837080	\N	1	predicate	predicate	f	837080	\N	\N	f	f	52	115	\N	t	f	\N	\N	\N	t	f	f
245	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	104	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://kaiko.getalp.org/dbnary#f1Measure	4308	\N	78	[F1 Measure (f1Measure)]	f1Measure	f	0	\N	\N	f	f	128	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	127032003	\N	1	type	type	f	127032003	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

COPY http_kaiko_getalp_org_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	page	\N
2	2	8	note	en
3	3	8	case	\N
4	3	8	case	\N
5	5	8	tense	\N
6	5	8	tense	\N
7	11	8	verb form mood	\N
8	11	8	verb form mood	\N
9	13	8	Observation Language	en
11	14	8	equivalentClass	\N
12	14	8	equivalentClass	\N
13	16	8	abbreviationFor	\N
14	16	8	abbreviationFor	\N
15	21	8	Translations with no gloss	en
17	23	8	banca categorie linguistiche	it
18	23	8	banque de catégories linguistiques	fr
19	23	8	conjunto de categoríes lingüísticas	es
20	23	8	linguistische Kategorienmodell	de
21	23	8	lingustic catalog	en
22	23	8	verzameling van taalkundige categories	nl
23	23	8	лингвистический каталог	ru
24	24	8	minQualifiedCardinality	\N
25	25	8	priorVersion	\N
26	25	8	priorVersion	\N
27	26	8	example	\N
28	26	8	example	\N
29	29	8	Creator	en
37	30	8	has mood	en
38	34	8	fonetiese voorstelling	af
40	34	8	fonetische voorstelling	nl
42	34	8	fonetisk representation 	sv
44	34	8	phonetic representation	en
46	34	8	phonetische Darstellung	de
48	34	8	rappresentazione fonetica	it
50	34	8	representación fonética	es
52	34	8	reprezentare fonetică	ro
54	34	8	représentation phonétique	fr
56	34	8	фонетическое представление	ru
58	35	8	homepage	\N
59	37	8	has separability	en
60	39	8	Abstract	en
68	40	8	referent type	\N
69	40	8	referent type	\N
70	41	8	has number	en
71	43	8	data set	en
72	45	8	Date Modified	en
80	47	8	F1 Measure	en
82	48	8	grammatical gender	\N
83	48	8	grammatical gender	\N
84	49	8	subPropertyOf	\N
85	50	8	sameAs	\N
86	50	8	sameAs	\N
87	54	8	deprecated	\N
88	55	8	Wiktionary Dump Version	en
90	56	8	first	\N
91	57	8	Language	en
99	58	8	has referent type	en
100	60	8	has case	en
101	61	8	root	\N
102	61	8	root	\N
103	62	8	example	en
104	63	8	cardinality	\N
105	63	8	cardinality	\N
106	64	8	Extent	en
114	66	8	label	\N
115	67	8	Title	en
123	68	8	hasValue	\N
124	68	8	hasValue	\N
125	69	8	object	\N
126	71	8	component specification	en
127	74	8	grammatical number	\N
128	74	8	grammatical number	\N
129	75	8	value	\N
130	76	8	qualifiedCardinality	\N
131	78	8	Eintrag	de
132	78	8	Item	nl
133	78	8	entrada	es
134	78	8	entrada	pt
135	78	8	entrata	it
136	78	8	entry	en
137	78	8	entrée	fr
138	78	8	ingång	sv
139	78	8	inskrywing	af
140	78	8	înregistrare	ro
141	78	8	запись	ru
142	79	8	scope note	en
143	83	8	has tense	en
144	85	8	Sprache	de
145	85	8	idioma	pt
146	85	8	language	en
147	85	8	langue	fr
148	85	8	lengua	es
149	85	8	limbă	ro
150	85	8	lingua	it
151	85	8	språk	sv
152	85	8	taal	af
153	85	8	taal	nl
154	85	8	язык	ru
155	86	8	has syntactic function	en
156	88	8	has valency	en
157	90	8	relatedTerm	\N
158	90	8	relatedTerm	\N
159	93	8	has voice	en
160	98	8	complementOf	\N
161	98	8	complementOf	\N
162	99	8	has definiteness	en
163	100	8	Translations with a sense number but no textual gloss	en
165	102	8	dimension	en
166	103	8	has related	en
167	104	8	frequency	\N
168	104	8	frequency	\N
169	105	8	intersectionOf	\N
170	105	8	intersectionOf	\N
171	106	8	onDataRange	\N
260	159	8	rappresentazione scritta	it
262	159	8	representación escrita	es
264	159	8	representação escrita	pt
172	108	8	Bibliographic Citation	en
180	111	8	comment	\N
181	114	8	personal mailbox	\N
182	116	8	has inflection type	en
183	117	8	term status	\N
184	118	8	structure	en
185	121	8	domain	\N
186	123	8	count of Lexical Entries	en
266	159	8	reprezentare scrisă	ro
268	159	8	représentation écrite	fr
270	159	8	schriftliche Darstellung	de
188	125	8	Contributor	en
196	127	8	maxCardinality	\N
197	127	8	maxCardinality	\N
198	129	8	has degree	en
199	130	8	topic	\N
200	132	8	alternative label	en
201	134	8	inverseOf	\N
202	134	8	inverseOf	\N
203	135	8	person	\N
204	135	8	person	\N
205	137	8	rest	\N
206	138	8	definition	en
207	139	8	count of Pages	en
209	140	8	isDefinedBy	\N
210	145	8	Sinn	de
212	145	8	acepción	es
214	145	8	betydelse	sv
216	145	8	sens	ro
218	145	8	sense	en
220	145	8	senso	it
222	145	8	sentido	pt
224	145	8	signification	fr
226	145	8	sinne	af
228	145	8	zin	nl
230	145	8	смысл	ru
232	146	8	someValuesFrom	\N
233	146	8	someValuesFrom	\N
234	147	8	disjointWith	\N
235	147	8	disjointWith	\N
236	150	8	Recall	en
238	152	8	unionOf	\N
239	152	8	unionOf	\N
240	153	8	versionInfo	\N
241	153	8	versionInfo	\N
242	155	8	Translations with a sense number and textual gloss	en
244	156	8	leksikale inskrywing	af
245	156	8	словарная единица	ru
246	156	8	Lexikoneinträge	de
247	156	8	entradas lexicas	pt
248	156	8	entradas léxicas	es
249	156	8	entrate lessicali	it
250	156	8	lexical entries	en
251	156	8	lexie	fr
252	156	8	lexikaal items	nl
253	156	8	lexikoningångar	sv
254	156	8	înregistrari lexicale	ro
255	157	8	count of Translations	en
257	158	8	measure	en
258	159	8	geskrewe voorstelling	af
272	159	8	schriftlijke voorstelling	nl
274	159	8	skriven form 	sv
276	159	8	written representation	en
278	159	8	письменное представление	ru
280	160	8	maker	\N
281	161	8	lexical relation	en
282	161	8	lexikaal relatie	nl
283	161	8	lexikalische Beziehung	de
284	161	8	relación léxica	es
285	161	8	relation lexicale	fr
286	161	8	relazione lessicale	it
287	161	8	лексическое отношение	ru
288	170	8	versionIRI	\N
289	171	8	Translations with a textual gloss but no sense number	en
291	173	8	logo	\N
292	174	8	Nym relation	en
294	178	8	part of speech	\N
295	178	8	part of speech	\N
306	185	8	Rights	en
314	186	8	Source	en
322	188	8	Description	en
296	182	8	Date Issued	en
304	184	8	minCardinality	\N
305	184	8	minCardinality	\N
330	189	8	Precision	en
332	190	8	onClass	\N
333	191	8	maxQualifiedCardinality	\N
334	193	8	has gender	en
335	194	8	subClassOf	\N
336	195	8	Subject	en
347	198	8	count of Lexical Senses	en
344	196	8	animacy	\N
345	196	8	animacy	\N
346	197	8	hasSelf	\N
349	200	8	range	\N
350	201	8	oneOf	\N
351	201	8	oneOf	\N
352	202	8	equivalentProperty	\N
353	202	8	equivalentProperty	\N
354	204	8	altra forma	it
356	204	8	altă formă	ro
358	204	8	ander form	af
360	204	8	andere Form	de
362	204	8	andere vorm	nl
364	204	8	annan form	sv
366	204	8	autre forme	fr
368	204	8	other form	en
370	204	8	otra forma	es
372	204	8	outra forma	pt
374	204	8	другая форма	ru
376	205	8	subject	\N
377	207	8	Publisher	en
385	209	8	count	en
387	214	8	seeAlso	\N
388	215	8	type	\N
389	216	8	has countability	en
390	217	8	Name of the enhancement method	en
392	219	8	imports	\N
393	219	8	imports	\N
394	224	8	canonical form	en
396	224	8	canonieke vorm	nl
398	224	8	forma canonica	it
400	224	8	forma canonica	pt
402	224	8	forma canónica	es
404	224	8	forme canonique	fr
406	224	8	formă canonică	ro
408	224	8	kanoniese vorm	af
410	224	8	kanonische Form	de
412	224	8	kanonisk form 	sv
414	224	8	каноническая форма	ru
416	229	8	primary topic	\N
417	235	8	License	en
425	237	8	onProperty	\N
426	237	8	onProperty	\N
427	240	8	allValuesFrom	\N
428	240	8	allValuesFrom	\N
429	241	8	Date Created	en
437	242	8	has person	en
438	244	8	predicate	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cc_rels_id_seq', 99, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.class_annots_id_seq', 182, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.classes_id_seq', 128, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cp_rels_id_seq', 1900, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.ns_id_seq', 89, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.properties_id_seq', 245, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

SELECT pg_catalog.setval('http_kaiko_getalp_org_sparql.property_annots_id_seq', 438, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_kaiko_getalp_org_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_kaiko_getalp_org_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_kaiko_getalp_org_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_kaiko_getalp_org_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_kaiko_getalp_org_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_kaiko_getalp_org_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_kaiko_getalp_org_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_kaiko_getalp_org_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_kaiko_getalp_org_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_kaiko_getalp_org_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_kaiko_getalp_org_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_kaiko_getalp_org_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_kaiko_getalp_org_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_kaiko_getalp_org_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_kaiko_getalp_org_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_kaiko_getalp_org_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_kaiko_getalp_org_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_kaiko_getalp_org_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_kaiko_getalp_org_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_kaiko_getalp_org_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_kaiko_getalp_org_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_kaiko_getalp_org_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_kaiko_getalp_org_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_kaiko_getalp_org_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_kaiko_getalp_org_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_kaiko_getalp_org_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_kaiko_getalp_org_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_kaiko_getalp_org_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_kaiko_getalp_org_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_kaiko_getalp_org_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_kaiko_getalp_org_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_kaiko_getalp_org_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_kaiko_getalp_org_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_kaiko_getalp_org_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_kaiko_getalp_org_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_kaiko_getalp_org_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_kaiko_getalp_org_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_kaiko_getalp_org_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_kaiko_getalp_org_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_kaiko_getalp_org_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_kaiko_getalp_org_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_kaiko_getalp_org_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_kaiko_getalp_org_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_kaiko_getalp_org_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_kaiko_getalp_org_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_kaiko_getalp_org_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_kaiko_getalp_org_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_kaiko_getalp_org_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_kaiko_getalp_org_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_kaiko_getalp_org_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_kaiko_getalp_org_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_kaiko_getalp_org_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_kaiko_getalp_org_sparql; Owner: -
--

ALTER TABLE ONLY http_kaiko_getalp_org_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_kaiko_getalp_org_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

