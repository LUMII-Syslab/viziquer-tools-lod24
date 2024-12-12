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
-- Name: http_id_eaufrance_fr_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_id_eaufrance_fr_sparql;


--
-- Name: SCHEMA http_id_eaufrance_fr_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_id_eaufrance_fr_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE FUNCTION http_id_eaufrance_fr_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE FUNCTION http_id_eaufrance_fr_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COMMENT ON TABLE http_id_eaufrance_fr_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COMMENT ON COLUMN http_id_eaufrance_fr_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_id_eaufrance_fr_sparql.classes c1
     JOIN http_id_eaufrance_fr_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_id_eaufrance_fr_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_id_eaufrance_fr_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_id_eaufrance_fr_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE TABLE http_id_eaufrance_fr_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE http_id_eaufrance_fr_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_id_eaufrance_fr_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_cc_rels AS
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
   FROM http_id_eaufrance_fr_sparql.cc_rels r,
    http_id_eaufrance_fr_sparql.classes c1,
    http_id_eaufrance_fr_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_classes_ns AS
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
    http_id_eaufrance_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_id_eaufrance_fr_sparql.classes c
     LEFT JOIN http_id_eaufrance_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_classes_ns_main AS
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
   FROM http_id_eaufrance_fr_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_id_eaufrance_fr_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_classes_ns_plus AS
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
    http_id_eaufrance_fr_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_id_eaufrance_fr_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_id_eaufrance_fr_sparql.classes c
     LEFT JOIN http_id_eaufrance_fr_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_classes_ns_main_plus AS
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
   FROM http_id_eaufrance_fr_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_id_eaufrance_fr_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_id_eaufrance_fr_sparql.v_classes_ns v
     LEFT JOIN http_id_eaufrance_fr_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_cp_rels AS
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
    http_id_eaufrance_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_id_eaufrance_fr_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_id_eaufrance_fr_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_id_eaufrance_fr_sparql.cp_rels r,
    http_id_eaufrance_fr_sparql.classes c,
    http_id_eaufrance_fr_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_cp_rels_card AS
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
   FROM http_id_eaufrance_fr_sparql.cp_rels r,
    http_id_eaufrance_fr_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_properties_ns AS
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
    http_id_eaufrance_fr_sparql.tapprox(p.cnt) AS cnt_x,
    http_id_eaufrance_fr_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_id_eaufrance_fr_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_id_eaufrance_fr_sparql.properties p
     LEFT JOIN http_id_eaufrance_fr_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_cp_sources_single AS
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
   FROM ((http_id_eaufrance_fr_sparql.v_cp_rels_card r
     JOIN http_id_eaufrance_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_id_eaufrance_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_cp_targets_single AS
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
   FROM ((http_id_eaufrance_fr_sparql.v_cp_rels_card r
     JOIN http_id_eaufrance_fr_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_id_eaufrance_fr_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_id_eaufrance_fr_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_id_eaufrance_fr_sparql.pp_rels r,
    http_id_eaufrance_fr_sparql.properties p1,
    http_id_eaufrance_fr_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_properties_sources AS
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
   FROM (http_id_eaufrance_fr_sparql.v_properties_ns v
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
           FROM http_id_eaufrance_fr_sparql.cp_rels r,
            http_id_eaufrance_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_properties_sources_single AS
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
   FROM (http_id_eaufrance_fr_sparql.v_properties_ns v
     LEFT JOIN http_id_eaufrance_fr_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_properties_targets AS
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
   FROM (http_id_eaufrance_fr_sparql.v_properties_ns v
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
           FROM http_id_eaufrance_fr_sparql.cp_rels r,
            http_id_eaufrance_fr_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE VIEW http_id_eaufrance_fr_sparql.v_properties_targets_single AS
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
   FROM (http_id_eaufrance_fr_sparql.v_properties_ns v
     LEFT JOIN http_id_eaufrance_fr_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	17	16	1	\N	\N
2	18	16	1	\N	\N
3	19	43	1	\N	\N
4	20	80	1	\N	\N
5	29	28	1	\N	\N
6	41	38	1	\N	\N
7	42	17	1	\N	\N
8	44	43	1	\N	\N
9	48	13	1	\N	\N
10	51	16	1	\N	\N
11	52	51	1	\N	\N
12	55	25	1	\N	\N
13	75	43	1	\N	\N
14	78	13	1	\N	\N
15	79	13	1	\N	\N
16	81	80	1	\N	\N
17	82	80	1	\N	\N
18	86	85	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	14	8	AnnotationProperty	\N
2	15	8	Ontology	\N
3	40	8	Class	\N
4	41	8	OntologyProperty	\N
5	46	8	InverseFunctionalProperty	\N
6	59	8	DatatypeProperty	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
31	http://id.eaufrance.fr/ddd/COM/4/Commune	66	\N	t	80	Commune	Commune	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	66
1	http://id.eaufrance.fr/ddd/INC/1.0/Naf	137517	\N	t	71	Naf	Naf	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	137517
2	http://id.eaufrance.fr/ddd/par/3/ParametrePhysique	1244	\N	t	72	ParametrePhysique	ParametrePhysique	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	120545
3	http://id.eaufrance.fr/ddd/par/3/ValeursPossiblesParametre	12634	\N	t	72	ValeursPossiblesParametre	ValeursPossiblesParametre	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12634
4	http://id.eaufrance.fr/ddd/par/3/ParPhysiqueQual	142	\N	t	72	ParPhysiqueQual	ParPhysiqueQual	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	142
5	http://id.eaufrance.fr/ddd/par/3/ParHydrobioQual	128	\N	t	72	ParHydrobioQual	ParHydrobioQual	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	128
6	http://id.eaufrance.fr/ddd/par/3/ParametreSynthese	844	\N	t	72	ParametreSynthese	ParametreSynthese	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1266
7	http://www.w3.org/2000/01/rdf-schema#Datatype	1	\N	t	2	Datatype	Datatype	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
13	http://www.w3.org/2000/01/rdf-schema#Class	57	\N	t	2	Class	Class	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	379
14	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
15	http://www.w3.org/2002/07/owl#Ontology	3	\N	t	7	Ontology	Ontology	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
16	http://www.w3.org/2004/02/skos/core#Concept	74476	\N	t	4	Concept	Concept	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	366006
17	http://rs.tdwg.org/dwc/terms/Taxon	67831	\N	t	73	Taxon	Taxon	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	190782
18	http://id.eaufrance.fr/ddd/par/3/Parametre	5858	\N	t	72	Parametre	Parametre	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159145
19	http://www.w3.org/ns/org#OrganizationalCollaboration	1910	\N	t	37	OrganizationalCollaboration	OrganizationalCollaboration	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8788
20	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	t	74	C_AKJ315005-tax	C_AKJ315005-tax	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
21	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	4	\N	t	7	inverseFunctionalProperty	inverseFunctionalProperty	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
23	http://rdf.insee.fr/def/geo#Commune	36681	\N	t	75	Commune	Commune	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	410515
24	http://owl.sandre.eaufrance.fr/odp/1.1#OuvrageDepollution	20419	\N	t	76	OuvrageDepollution	OuvrageDepollution	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	289
25	http://www.w3.org/2002/07/owl#NamedIndividual	591	\N	t	7	NamedIndividual	NamedIndividual	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	147429
26	http://somewhere/ApplicationSchema#PlaceOfInterest	6	\N	t	77	PlaceOfInterest	PlaceOfInterest	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
27	http://www.opengis.net/rdf#Point	5	\N	t	78	Point	Point	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
28	http://www.w3.org/2001/vcard-rdf/3.0#work	2	\N	t	79	work	work	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
29	http://www.w3.org/2001/vcard-rdf/3.0#voice	2	\N	t	79	voice	voice	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
30	http://id.eaufrance.fr/ddd/COM/4/Pays	159899	\N	t	80	Pays	Pays	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159899
32	http://id.eaufrance.fr/ddd/par/3/TraductionNomParametre	1211	\N	t	72	TraductionNomParametre	TraductionNomParametre	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1211
33	http://id.eaufrance.fr/ddd/par/3/ParPhysiqueQuant	480	\N	t	72	ParPhysiqueQuant	ParPhysiqueQuant	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	480
34	http://id.eaufrance.fr/ddd/par/3/ParSyntheseQual	274	\N	t	72	ParSyntheseQual	ParSyntheseQual	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	274
38	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	259	\N	t	1	Property	Property	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
39	http://www.w3.org/ns/sparql-service-description#Service	5	\N	t	27	Service	Service	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	50
40	http://www.w3.org/2002/07/owl#Class	4	\N	t	7	Class	Class	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	599
41	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
42	http://id.eaufrance.fr/ddd/APT/2.1/AppelTaxon	67831	\N	t	81	AppelTaxon	AppelTaxon	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	190782
43	http://id.eaufrance.fr/ddd/INC/1.0/Interlocuteur	159899	\N	t	71	Interlocuteur	Interlocuteur	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1249925
44	http://www.w3.org/ns/org#FormalOrganization	157053	\N	t	37	FormalOrganization	FormalOrganization	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1236169
45	http://id.eaufrance.fr/ddd/INC/1.0/Adresse	158777	\N	t	71	Adresse	Adresse	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	158777
46	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	3	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
47	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
48	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
49	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
50	http://www.openlinksw.com/ontology/acl#Scope	1	\N	t	82	Scope	Scope	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
51	http://purl.org/net/provenance/ns#DataItem	787	\N	t	83	DataItem	DataItem	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16079
52	http://id.eaufrance.fr/ddd/MAT/3.1/Nomenclature	787	\N	t	84	Nomenclature	Nomenclature	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16079
53	http://owl.sandre.eaufrance.fr/pmo/1.2#PointMesure	786	\N	t	85	PointMesure	PointMesure	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	786
54	http://owl.sandre.eaufrance.fr/pmo/1.2#Prlvt	104095	\N	t	85	Prlvt	Prlvt	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	104095
55	http://owl.sandre.eaufrance.fr/par/2.3#UniteMesure	591	\N	t	86	UniteMesure	UniteMesure	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	147429
56	http://owl.sandre.eaufrance.fr/mat/2#Message	12	\N	t	87	Message	Message	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
57	http://owl.sandre.eaufrance.fr/scl/1.1#SystemeCollecte	19706	\N	t	88	SystemeCollecte	SystemeCollecte	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
58	http://owl.sandre.eaufrance.fr/com/3#Commune	195	\N	t	89	Commune	Commune	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	603
59	http://www.w3.org/2002/07/owl#DatatypeProperty	10	\N	t	7	DatatypeProperty	DatatypeProperty	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
60	http://www.opengis.net/rdf#Polygon	4	\N	t	78	Polygon	Polygon	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
61	http://id.eaufrance.fr/ddd/INC/1.0/Etablissement	157053	\N	t	71	Etablissement	Etablissement	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	157053
62	http://id.eaufrance.fr/ddd/INC/1.0/Service	936	\N	t	71	Service	Service	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	936
63	http://id.eaufrance.fr/ddd/INC/1.0/Structure	1910	\N	t	71	Structure	Structure	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1910
64	http://id.eaufrance.fr/ddd/par/3/ParametreChimique	7956	\N	t	72	ParametreChimique	ParametreChimique	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40684
65	http://id.eaufrance.fr/ddd/par/3/ParametreHydrobiologique	954	\N	t	72	ParametreHydrobiologique	ParametreHydrobiologique	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1431
66	http://id.eaufrance.fr/ddd/par/3/ParHydrobioQuant	349	\N	t	72	ParHydrobioQuant	ParHydrobioQuant	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	349
67	http://id.eaufrance.fr/ddd/par/3/ParametreMicrobiologique	718	\N	t	72	ParametreMicrobiologique	ParametreMicrobiologique	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1077
72	http://id.eaufrance.fr/ddd/INC/1.0/CdAlternatifInt	314317	\N	t	71	CdAlternatifInt	CdAlternatifInt	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	314317
73	http://id.eaufrance.fr/ddd/APT/2.1/CodeAlternatif	122960	\N	t	81	CodeAlternatif	CodeAlternatif	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122960
74	http://www.openlinksw.com/schemas/VAD#	3	\N	t	90			175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://www.w3.org/ns/org#OrganizationalUnit	936	\N	t	37	OrganizationalUnit	OrganizationalUnit	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4968
76	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	t	36	BusinessEntity	BusinessEntity	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
77	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
78	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
79	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
80	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
81	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	t	74	C_AAB316003-tax	C_AAB316003-tax	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
82	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	t	74	C_AKE112003-tax	C_AKE112003-tax	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
83	http://id.eaufrance.fr/ddd/MAT/3.1/Element	16079	\N	t	84	Element	Element	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32944
84	http://owl.sandre.eaufrance.fr/pmo/1.2#Analyse	147429	\N	t	85	Analyse	Analyse	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	147429
85	http://www.w3.org/1999/02/22-rdf-syntax-ns#Bag	3	\N	t	1	Bag	Bag	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	35
86	http://www.w3.org/2000/01/rdf-schema#member	1	\N	t	2	member	member	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
87	http://www.opengis.net/rdf#LineString	1	\N	t	78	LineString	LineString	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
88	http://www.w3.org/2001/vcard-rdf/3.0#internet	2	\N	t	79	internet	internet	175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	43	1	2	159899	\N	159899	\N	\N	1	1	2	f	\N	43	\N
2	16	1	2	74476	\N	5858	\N	\N	2	1	2	f	68618	\N	\N
3	44	1	2	157053	\N	157053	\N	\N	0	1	2	f	\N	44	\N
4	17	1	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
5	42	1	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
6	18	1	2	5858	\N	5858	\N	\N	0	1	2	f	\N	18	\N
7	64	1	2	3978	\N	3978	\N	\N	0	1	2	f	\N	18	\N
8	19	1	2	1910	\N	1910	\N	\N	0	1	2	f	\N	19	\N
9	75	1	2	936	\N	936	\N	\N	0	1	2	f	\N	75	\N
10	51	1	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
11	52	1	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
12	2	1	2	622	\N	622	\N	\N	0	1	2	f	\N	2	\N
13	65	1	2	477	\N	477	\N	\N	0	1	2	f	\N	65	\N
14	6	1	2	422	\N	422	\N	\N	0	1	2	f	\N	6	\N
15	67	1	2	359	\N	359	\N	\N	0	1	2	f	\N	67	\N
16	43	1	1	159899	\N	159899	\N	\N	1	1	2	f	\N	43	\N
17	18	1	1	5858	\N	5858	\N	\N	2	1	2	f	\N	18	\N
18	44	1	1	157053	\N	157053	\N	\N	0	1	2	f	\N	44	\N
19	16	1	1	5858	\N	5858	\N	\N	0	1	2	f	\N	18	\N
20	64	1	1	3978	\N	3978	\N	\N	0	1	2	f	\N	18	\N
21	19	1	1	1910	\N	1910	\N	\N	0	1	2	f	\N	19	\N
22	75	1	1	936	\N	936	\N	\N	0	1	2	f	\N	75	\N
23	2	1	1	622	\N	622	\N	\N	0	1	2	f	\N	2	\N
24	65	1	1	477	\N	477	\N	\N	0	1	2	f	\N	65	\N
25	6	1	1	422	\N	422	\N	\N	0	1	2	f	\N	6	\N
26	67	1	1	359	\N	359	\N	\N	0	1	2	f	\N	67	\N
27	24	2	2	20701	\N	0	\N	\N	1	1	2	f	20701	\N	\N
29	84	4	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
30	23	5	2	36681	\N	0	\N	\N	1	1	2	f	36681	\N	\N
35	43	9	2	150125	\N	0	\N	\N	1	1	2	f	150125	\N	\N
36	44	9	2	147279	\N	0	\N	\N	0	1	2	f	147279	\N	\N
37	19	9	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
38	75	9	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
39	64	10	2	9274	\N	9274	\N	\N	1	1	2	f	0	\N	\N
41	26	12	2	4	\N	4	\N	\N	1	1	2	f	0	27	\N
42	27	12	1	4	\N	4	\N	\N	1	1	2	f	\N	26	\N
43	15	13	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
46	43	16	2	788	\N	\N	\N	\N	1	1	2	f	788	\N	\N
47	76	16	2	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
48	44	16	2	598	\N	\N	\N	\N	0	1	2	f	598	\N	\N
49	19	16	2	117	\N	\N	\N	\N	0	1	2	f	117	\N	\N
50	75	16	2	73	\N	\N	\N	\N	0	1	2	f	73	\N	\N
51	17	17	2	67795	\N	67795	\N	\N	1	1	2	f	0	17	\N
52	16	17	2	67795	\N	67795	\N	\N	0	1	2	f	0	42	\N
53	42	17	2	67795	\N	67795	\N	\N	0	1	2	f	0	42	\N
54	17	17	1	67795	\N	67795	\N	\N	1	1	2	f	\N	17	\N
55	16	17	1	67795	\N	67795	\N	\N	0	1	2	f	\N	17	\N
56	42	17	1	67795	\N	67795	\N	\N	0	1	2	f	\N	42	\N
57	72	18	2	314317	\N	314317	\N	\N	1	1	2	f	0	\N	\N
58	3	20	2	146	\N	0	\N	\N	1	1	2	f	146	\N	\N
59	65	21	2	349	\N	349	\N	\N	1	1	2	f	0	66	\N
60	66	21	1	349	\N	349	\N	\N	1	1	2	f	\N	65	\N
62	18	23	2	1473	\N	0	\N	\N	1	1	2	f	1473	\N	\N
63	16	23	2	1473	\N	0	\N	\N	0	1	2	f	1473	\N	\N
64	64	23	2	943	\N	0	\N	\N	0	1	2	f	943	\N	\N
65	2	23	2	161	\N	0	\N	\N	0	1	2	f	161	\N	\N
66	6	23	2	147	\N	0	\N	\N	0	1	2	f	147	\N	\N
67	65	23	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
68	67	23	2	94	\N	0	\N	\N	0	1	2	f	94	\N	\N
69	23	24	2	36681	\N	0	\N	\N	1	1	2	f	36681	\N	\N
73	25	27	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
74	55	27	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
75	83	28	2	786	\N	0	\N	\N	1	1	2	f	786	\N	\N
76	38	29	2	47	\N	47	\N	\N	1	1	2	f	0	\N	\N
77	46	29	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
78	14	29	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
79	13	29	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
80	22	29	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
81	14	29	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
82	13	29	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
83	38	29	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
85	43	31	2	788	\N	0	\N	\N	1	1	2	f	788	\N	\N
86	44	31	2	598	\N	0	\N	\N	0	1	2	f	598	\N	\N
87	19	31	2	117	\N	0	\N	\N	0	1	2	f	117	\N	\N
88	75	31	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
89	40	32	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
90	74	33	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
92	74	36	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
93	18	37	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
94	16	37	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
95	64	37	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
96	2	37	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
97	65	37	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
98	6	37	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
99	67	37	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
100	74	38	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
101	25	39	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
102	55	39	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
103	24	40	2	20412	\N	0	\N	\N	1	1	2	f	20412	\N	\N
106	16	43	2	74476	\N	0	\N	\N	1	1	2	f	74476	\N	\N
107	17	43	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
108	42	43	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
109	18	43	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
110	64	43	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
111	51	43	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
112	52	43	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
113	2	43	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
114	65	43	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
115	6	43	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
116	67	43	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
117	88	44	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
118	49	45	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
120	31	47	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
123	38	49	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
124	85	49	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
126	45	51	2	7130	\N	0	\N	\N	1	1	2	f	7130	\N	\N
129	67	53	2	1176	\N	1176	\N	\N	1	1	2	f	0	\N	\N
130	38	54	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
131	15	54	1	1	\N	1	\N	\N	1	1	2	f	\N	38	\N
132	83	55	2	16078	\N	0	\N	\N	1	1	2	f	16078	\N	\N
133	77	57	2	3	\N	3	\N	\N	1	1	2	f	0	49	\N
134	49	57	1	3	\N	3	\N	\N	1	1	2	f	\N	77	\N
140	74	62	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
143	17	64	2	67831	\N	67831	\N	\N	1	1	2	f	0	\N	\N
144	16	64	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
145	42	64	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
146	56	65	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
148	61	67	2	157053	\N	0	\N	\N	1	1	2	f	157053	\N	\N
149	25	68	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
150	55	68	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
151	77	69	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
156	33	72	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
157	34	73	2	1217	\N	1217	\N	\N	1	1	2	f	0	3	\N
158	3	73	1	1217	\N	1217	\N	\N	1	1	2	f	\N	34	\N
159	64	74	2	3268	\N	0	\N	\N	1	1	2	f	3268	\N	\N
160	65	75	2	128	\N	128	\N	\N	1	1	2	f	0	5	\N
161	5	75	1	128	\N	128	\N	\N	1	1	2	f	\N	65	\N
162	43	76	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
163	16	76	2	74476	\N	0	\N	\N	2	1	2	f	74476	\N	\N
164	44	76	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
165	17	76	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
166	42	76	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
167	18	76	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
168	64	76	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
169	19	76	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
170	75	76	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
171	51	76	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
172	52	76	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
173	2	76	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
174	65	76	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
175	6	76	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
176	67	76	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
177	43	77	2	159899	\N	159899	\N	\N	1	1	2	f	0	\N	\N
178	44	77	2	157053	\N	157053	\N	\N	0	1	2	f	0	\N	\N
179	19	77	2	1910	\N	1910	\N	\N	0	1	2	f	0	\N	\N
180	75	77	2	936	\N	936	\N	\N	0	1	2	f	0	\N	\N
181	6	78	2	422	\N	422	\N	\N	1	1	2	f	0	6	\N
182	16	78	2	422	\N	422	\N	\N	0	1	2	f	0	6	\N
183	18	78	2	422	\N	422	\N	\N	0	1	2	f	0	6	\N
184	6	78	1	422	\N	422	\N	\N	1	1	2	f	\N	6	\N
185	17	79	2	122960	\N	122960	\N	\N	1	1	2	f	0	73	\N
186	16	79	2	122960	\N	122960	\N	\N	0	1	2	f	0	73	\N
187	42	79	2	122960	\N	122960	\N	\N	0	1	2	f	0	73	\N
188	73	79	1	122960	\N	122960	\N	\N	1	1	2	f	\N	42	\N
190	77	81	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
191	74	82	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
192	17	83	2	64980	\N	0	\N	\N	1	1	2	f	64980	\N	\N
193	16	83	2	64980	\N	0	\N	\N	0	1	2	f	64980	\N	\N
194	42	83	2	64980	\N	0	\N	\N	0	1	2	f	64980	\N	\N
196	45	85	2	140452	\N	0	\N	\N	1	1	2	f	140452	\N	\N
197	1	86	2	137517	\N	0	\N	\N	1	1	2	f	137517	\N	\N
198	84	87	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
199	43	88	2	159899	\N	159899	\N	\N	1	1	2	f	0	\N	\N
200	44	88	2	157053	\N	157053	\N	\N	0	1	2	f	0	\N	\N
201	19	88	2	1910	\N	1910	\N	\N	0	1	2	f	0	\N	\N
202	75	88	2	936	\N	936	\N	\N	0	1	2	f	0	\N	\N
205	24	90	2	1393	\N	1393	\N	\N	1	1	2	f	0	53	\N
206	57	90	2	132	\N	132	\N	\N	2	1	2	f	0	53	\N
207	53	90	1	786	\N	786	\N	\N	1	1	2	f	\N	\N	\N
210	61	92	2	157053	\N	0	\N	\N	1	1	2	f	157053	\N	\N
211	66	94	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
212	84	95	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
213	61	96	2	37208	\N	0	\N	\N	1	1	2	f	37208	\N	\N
214	6	97	2	422	\N	0	\N	\N	1	1	2	f	422	\N	\N
216	49	99	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
217	72	100	2	314317	\N	314317	\N	\N	1	1	2	f	0	43	\N
218	45	100	2	158777	\N	158777	\N	\N	2	1	2	f	0	43	\N
219	61	100	2	157053	\N	157053	\N	\N	3	1	2	f	0	44	\N
220	73	100	2	122960	\N	122960	\N	\N	4	1	2	f	0	17	\N
221	83	100	2	16079	\N	16079	\N	\N	5	1	2	f	0	51	\N
222	63	100	2	1910	\N	1910	\N	\N	6	1	2	f	0	19	\N
223	62	100	2	936	\N	936	\N	\N	7	1	2	f	0	75	\N
224	43	100	1	632993	\N	632993	\N	\N	1	1	2	f	\N	\N	\N
225	16	100	1	139039	\N	139039	\N	\N	2	1	2	f	\N	\N	\N
226	44	100	1	624929	\N	624929	\N	\N	0	1	2	f	\N	\N	\N
227	17	100	1	122960	\N	122960	\N	\N	0	1	2	f	\N	73	\N
228	42	100	1	122960	\N	122960	\N	\N	0	1	2	f	\N	73	\N
229	52	100	1	16079	\N	16079	\N	\N	0	1	2	f	\N	83	\N
230	51	100	1	16079	\N	16079	\N	\N	0	1	2	f	\N	83	\N
231	19	100	1	4968	\N	4968	\N	\N	0	1	2	f	\N	\N	\N
232	75	100	1	3096	\N	3096	\N	\N	0	1	2	f	\N	\N	\N
233	83	102	2	8614	\N	0	\N	\N	1	1	2	f	8614	\N	\N
234	18	102	2	5858	\N	0	\N	\N	2	1	2	f	5858	\N	\N
235	16	102	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
236	64	102	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
237	2	102	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
238	65	102	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
239	6	102	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
240	67	102	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
241	53	103	2	786	\N	0	\N	\N	1	1	2	f	786	\N	\N
244	67	107	2	359	\N	359	\N	\N	1	1	2	f	0	67	\N
245	16	107	2	359	\N	359	\N	\N	0	1	2	f	0	67	\N
246	18	107	2	359	\N	359	\N	\N	0	1	2	f	0	67	\N
247	67	107	1	359	\N	359	\N	\N	1	1	2	f	\N	67	\N
248	15	108	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
249	77	108	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
250	38	108	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
251	47	108	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
252	76	108	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
253	15	108	1	1	\N	1	\N	\N	1	1	2	f	\N	38	\N
254	64	109	2	1867	\N	0	\N	\N	1	1	2	f	1867	\N	\N
256	3	111	2	12634	\N	12634	\N	\N	1	1	2	f	0	\N	\N
257	72	112	2	314317	\N	0	\N	\N	1	1	2	f	314317	\N	\N
258	25	113	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
259	55	113	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
260	83	114	2	8614	\N	0	\N	\N	1	1	2	f	8614	\N	\N
261	39	115	2	50	\N	50	\N	\N	1	1	2	f	0	\N	\N
262	43	116	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
263	44	116	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
264	19	116	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
265	75	116	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
266	40	117	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
267	17	118	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
268	16	118	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
269	42	118	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
270	15	119	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
271	27	120	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
272	60	120	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
273	87	120	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
274	43	121	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
275	44	121	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
276	19	121	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
277	75	121	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
278	25	122	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
279	55	122	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
280	64	123	2	735	\N	0	\N	\N	1	1	2	f	735	\N	\N
281	63	125	2	1865	\N	0	\N	\N	1	1	2	f	1865	\N	\N
282	77	126	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
283	77	127	2	3	\N	3	\N	\N	1	1	2	f	0	47	\N
284	47	127	1	3	\N	3	\N	\N	1	1	2	f	\N	77	\N
285	74	128	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
286	66	130	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
289	18	133	2	1211	\N	1211	\N	\N	1	1	2	f	0	32	\N
290	16	133	2	1211	\N	1211	\N	\N	0	1	2	f	0	32	\N
291	64	133	2	1171	\N	1171	\N	\N	0	1	2	f	0	32	\N
292	2	133	2	28	\N	28	\N	\N	0	1	2	f	0	32	\N
293	65	133	2	10	\N	10	\N	\N	0	1	2	f	0	32	\N
294	67	133	2	2	\N	2	\N	\N	0	1	2	f	0	32	\N
295	32	133	1	1211	\N	1211	\N	\N	1	1	2	f	\N	18	\N
296	61	134	2	137517	\N	137517	\N	\N	1	1	2	f	0	1	\N
297	1	134	1	137517	\N	137517	\N	\N	1	1	2	f	\N	61	\N
298	54	135	2	147429	\N	147429	\N	\N	1	1	2	f	0	84	\N
299	84	135	1	147429	\N	147429	\N	\N	1	1	2	f	\N	54	\N
300	76	136	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
302	6	138	2	148	\N	0	\N	\N	1	1	2	f	148	\N	\N
305	43	140	2	158777	\N	158777	\N	\N	1	1	2	f	0	45	\N
306	44	140	2	157052	\N	157052	\N	\N	0	1	2	f	0	45	\N
307	75	140	2	933	\N	933	\N	\N	0	1	2	f	0	45	\N
308	19	140	2	792	\N	792	\N	\N	0	1	2	f	0	45	\N
309	45	140	1	158777	\N	158777	\N	\N	1	1	2	f	\N	43	\N
310	39	141	2	25	\N	25	\N	\N	1	1	2	f	0	\N	\N
311	77	142	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
312	48	142	1	1	\N	1	\N	\N	1	1	2	f	\N	77	\N
313	78	142	1	1	\N	1	\N	\N	2	1	2	f	\N	77	\N
314	13	142	1	2	\N	2	\N	\N	0	1	2	f	\N	77	\N
315	51	143	2	787	\N	0	\N	\N	1	1	2	f	787	\N	\N
316	16	143	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
317	52	143	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
318	83	144	2	14693	\N	0	\N	\N	1	1	2	f	14693	\N	\N
319	3	146	2	12634	\N	0	\N	\N	1	1	2	f	12634	\N	\N
322	84	149	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
323	4	150	2	1036	\N	1036	\N	\N	1	1	2	f	0	3	\N
324	3	150	1	1036	\N	1036	\N	\N	1	1	2	f	\N	4	\N
325	54	151	2	104095	\N	104095	\N	\N	1	1	2	f	0	\N	\N
326	43	152	2	159899	\N	159899	\N	\N	1	1	2	f	\N	\N	\N
327	16	152	2	74476	\N	5858	\N	\N	2	1	2	f	68618	\N	\N
328	44	152	2	157053	\N	157053	\N	\N	0	1	2	f	\N	\N	\N
329	17	152	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
330	42	152	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
331	18	152	2	5858	\N	5858	\N	\N	0	1	2	f	\N	\N	\N
332	64	152	2	3978	\N	3978	\N	\N	0	1	2	f	\N	\N	\N
333	19	152	2	1910	\N	1910	\N	\N	0	1	2	f	\N	\N	\N
334	75	152	2	936	\N	936	\N	\N	0	1	2	f	\N	\N	\N
335	51	152	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
336	52	152	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
337	2	152	2	622	\N	622	\N	\N	0	1	2	f	\N	\N	\N
338	65	152	2	477	\N	477	\N	\N	0	1	2	f	\N	\N	\N
339	6	152	2	422	\N	422	\N	\N	0	1	2	f	\N	\N	\N
340	67	152	2	359	\N	359	\N	\N	0	1	2	f	\N	\N	\N
343	56	154	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
344	18	155	2	5858	\N	5858	\N	\N	1	1	2	f	0	\N	\N
345	16	155	2	5858	\N	5858	\N	\N	0	1	2	f	0	\N	\N
346	64	155	2	3978	\N	3978	\N	\N	0	1	2	f	0	\N	\N
347	2	155	2	622	\N	622	\N	\N	0	1	2	f	0	\N	\N
348	65	155	2	477	\N	477	\N	\N	0	1	2	f	0	\N	\N
349	6	155	2	422	\N	422	\N	\N	0	1	2	f	0	\N	\N
350	67	155	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
351	83	156	2	16079	\N	16078	\N	\N	1	1	2	f	1	\N	\N
352	83	156	1	16078	\N	16078	\N	\N	1	1	2	f	\N	83	\N
353	18	157	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
354	16	157	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
355	64	157	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
356	2	157	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
357	65	157	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
358	6	157	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
359	67	157	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
361	43	160	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
362	16	160	2	74476	\N	0	\N	\N	2	1	2	f	74476	\N	\N
363	44	160	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
364	17	160	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
365	42	160	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
366	18	160	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
367	64	160	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
368	19	160	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
369	75	160	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
370	51	160	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
371	52	160	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
372	2	160	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
373	65	160	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
374	6	160	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
375	67	160	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
376	38	161	2	167	\N	167	\N	\N	1	1	2	f	0	\N	\N
377	41	161	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
378	79	161	1	2	\N	2	\N	\N	1	1	2	f	\N	38	\N
379	40	161	1	2	\N	2	\N	\N	2	1	2	f	\N	38	\N
380	48	161	1	1	\N	1	\N	\N	3	1	2	f	\N	38	\N
381	13	161	1	45	\N	45	\N	\N	0	1	2	f	\N	38	\N
382	17	162	2	67831	\N	67831	\N	\N	1	1	2	f	0	\N	\N
383	16	162	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
384	42	162	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
385	67	163	2	211	\N	211	\N	\N	1	1	2	f	0	3	\N
386	3	163	1	211	\N	211	\N	\N	1	1	2	f	\N	67	\N
388	2	165	2	142	\N	142	\N	\N	1	1	2	f	0	4	\N
389	4	165	1	142	\N	142	\N	\N	1	1	2	f	\N	2	\N
390	75	169	2	936	\N	936	\N	\N	1	1	2	f	0	62	\N
391	43	169	2	936	\N	936	\N	\N	0	1	2	f	0	62	\N
392	62	169	1	936	\N	936	\N	\N	1	1	2	f	\N	75	\N
393	51	170	2	787	\N	0	\N	\N	1	1	2	f	787	\N	\N
394	16	170	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
395	52	170	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
398	38	172	2	34	\N	34	\N	\N	1	1	2	f	0	85	\N
399	85	172	2	2	\N	2	\N	\N	0	1	2	f	0	85	\N
400	85	172	1	35	\N	35	\N	\N	1	1	2	f	\N	\N	\N
401	86	172	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
402	51	173	2	787	\N	0	\N	\N	1	1	2	f	787	\N	\N
403	16	173	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
404	52	173	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
405	73	174	2	122960	\N	122960	\N	\N	1	1	2	f	0	\N	\N
406	43	175	2	319798	\N	319798	\N	\N	1	1	2	f	0	\N	\N
407	72	175	2	314317	\N	314317	\N	\N	2	1	2	f	0	\N	\N
408	16	175	2	223428	\N	223428	\N	\N	3	1	2	f	0	\N	\N
409	30	175	2	159899	\N	159899	\N	\N	4	1	2	f	0	\N	\N
410	45	175	2	158777	\N	158777	\N	\N	5	1	2	f	0	\N	\N
411	61	175	2	157053	\N	157053	\N	\N	6	1	2	f	0	\N	\N
412	84	175	2	147429	\N	147429	\N	\N	7	1	2	f	0	\N	\N
413	1	175	2	137517	\N	137517	\N	\N	8	1	2	f	0	\N	\N
414	73	175	2	122960	\N	122960	\N	\N	9	1	2	f	0	\N	\N
415	54	175	2	104095	\N	104095	\N	\N	10	1	2	f	0	\N	\N
416	23	175	2	36681	\N	36681	\N	\N	11	1	2	f	0	\N	\N
417	24	175	2	20701	\N	20701	\N	\N	12	1	2	f	0	\N	\N
418	57	175	2	19730	\N	19730	\N	\N	13	1	2	f	0	\N	\N
419	83	175	2	16079	\N	16079	\N	\N	14	1	2	f	0	\N	\N
420	3	175	2	12634	\N	12634	\N	\N	15	1	2	f	0	\N	\N
421	63	175	2	1910	\N	1910	\N	\N	16	1	2	f	0	\N	\N
422	32	175	2	1211	\N	1211	\N	\N	17	1	2	f	0	\N	\N
423	25	175	2	1182	\N	1182	\N	\N	18	1	2	f	0	\N	\N
424	62	175	2	936	\N	936	\N	\N	19	1	2	f	0	\N	\N
425	53	175	2	786	\N	786	\N	\N	20	1	2	f	0	\N	\N
426	33	175	2	480	\N	480	\N	\N	21	1	2	f	0	\N	\N
427	66	175	2	349	\N	349	\N	\N	22	1	2	f	0	\N	\N
428	34	175	2	274	\N	274	\N	\N	23	1	2	f	0	\N	\N
429	38	175	2	265	\N	265	\N	\N	24	1	2	f	0	\N	\N
430	58	175	2	195	\N	195	\N	\N	25	1	2	f	0	\N	\N
432	4	175	2	142	\N	142	\N	\N	27	1	2	f	0	\N	\N
433	5	175	2	128	\N	128	\N	\N	28	1	2	f	0	\N	\N
436	31	175	2	66	\N	66	\N	\N	31	1	2	f	0	\N	\N
442	39	175	2	25	\N	25	\N	\N	37	1	2	f	0	\N	\N
444	56	175	2	14	\N	14	\N	\N	39	1	2	f	0	\N	\N
445	59	175	2	10	\N	10	\N	\N	40	1	2	f	0	\N	\N
446	80	175	2	6	\N	6	\N	\N	41	1	2	f	0	\N	\N
447	26	175	2	6	\N	6	\N	\N	42	1	2	f	0	\N	\N
448	27	175	2	5	\N	5	\N	\N	43	1	2	f	0	\N	\N
450	28	175	2	4	\N	4	\N	\N	45	1	2	f	0	\N	\N
451	22	175	2	4	\N	3	\N	\N	46	1	2	f	0	\N	\N
452	46	175	2	3	\N	\N	\N	\N	46	1	2	f	0	\N	\N
453	40	175	2	4	\N	4	\N	\N	47	1	2	f	0	\N	\N
454	60	175	2	4	\N	4	\N	\N	48	1	2	f	0	\N	\N
457	15	175	2	3	\N	3	\N	\N	51	1	2	f	0	\N	\N
458	49	175	2	3	\N	3	\N	\N	53	1	2	f	0	\N	\N
459	74	175	2	3	\N	3	\N	\N	54	1	2	f	0	\N	\N
460	77	175	2	3	\N	3	\N	\N	55	1	2	f	0	\N	\N
461	48	175	2	2	\N	2	\N	\N	56	1	2	f	0	\N	\N
462	78	175	2	2	\N	2	\N	\N	57	1	2	f	0	\N	\N
463	79	175	2	2	\N	2	\N	\N	58	1	2	f	0	\N	\N
464	86	175	2	2	\N	2	\N	\N	59	1	2	f	0	\N	\N
465	88	175	2	2	\N	2	\N	\N	60	1	2	f	0	\N	\N
466	7	175	2	1	\N	1	\N	\N	61	1	2	f	0	\N	\N
467	21	175	2	1	\N	1	\N	\N	62	1	2	f	0	\N	\N
468	47	175	2	1	\N	1	\N	\N	63	1	2	f	0	\N	\N
469	50	175	2	1	\N	1	\N	\N	64	1	2	f	0	\N	\N
470	76	175	2	1	\N	1	\N	\N	65	1	2	f	0	\N	\N
471	87	175	2	1	\N	1	\N	\N	66	1	2	f	0	\N	\N
472	44	175	2	314106	\N	314106	\N	\N	0	1	2	f	0	\N	\N
473	17	175	2	203493	\N	203493	\N	\N	0	1	2	f	0	\N	\N
474	42	175	2	203493	\N	203493	\N	\N	0	1	2	f	0	\N	\N
475	18	175	2	17574	\N	17574	\N	\N	0	1	2	f	0	\N	\N
476	64	175	2	15912	\N	15912	\N	\N	0	1	2	f	0	\N	\N
477	19	175	2	3820	\N	3820	\N	\N	0	1	2	f	0	\N	\N
478	2	175	2	2488	\N	2488	\N	\N	0	1	2	f	0	\N	\N
479	51	175	2	2361	\N	2361	\N	\N	0	1	2	f	0	\N	\N
480	52	175	2	2361	\N	2361	\N	\N	0	1	2	f	0	\N	\N
481	65	175	2	1908	\N	1908	\N	\N	0	1	2	f	0	\N	\N
482	75	175	2	1872	\N	1872	\N	\N	0	1	2	f	0	\N	\N
483	6	175	2	1688	\N	1688	\N	\N	0	1	2	f	0	\N	\N
484	67	175	2	1436	\N	1436	\N	\N	0	1	2	f	0	\N	\N
485	55	175	2	1182	\N	1182	\N	\N	0	1	2	f	0	\N	\N
486	13	175	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
487	41	175	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
488	14	175	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
489	85	175	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
490	29	175	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
491	20	175	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
492	81	175	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
493	82	175	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
494	40	175	1	591	\N	591	\N	\N	1	1	2	f	\N	55	\N
495	13	175	1	35	\N	35	\N	\N	0	1	2	f	\N	\N	\N
497	15	177	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
498	57	179	2	19730	\N	0	\N	\N	1	1	2	f	19730	\N	\N
500	17	181	2	67831	\N	67831	\N	\N	1	1	2	f	0	\N	\N
501	16	181	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
502	42	181	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
505	74	183	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
508	43	185	2	159899	\N	159899	\N	\N	1	1	2	f	\N	43	\N
509	16	185	2	74476	\N	5858	\N	\N	2	1	2	f	68618	\N	\N
510	44	185	2	157053	\N	157053	\N	\N	0	1	2	f	\N	44	\N
511	17	185	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
512	42	185	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
513	18	185	2	5858	\N	5858	\N	\N	0	1	2	f	\N	18	\N
514	64	185	2	3978	\N	3978	\N	\N	0	1	2	f	\N	18	\N
515	19	185	2	1910	\N	1910	\N	\N	0	1	2	f	\N	19	\N
516	75	185	2	936	\N	936	\N	\N	0	1	2	f	\N	75	\N
517	51	185	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
518	52	185	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
519	2	185	2	622	\N	622	\N	\N	0	1	2	f	\N	2	\N
520	65	185	2	477	\N	477	\N	\N	0	1	2	f	\N	65	\N
521	6	185	2	422	\N	422	\N	\N	0	1	2	f	\N	6	\N
522	67	185	2	359	\N	359	\N	\N	0	1	2	f	\N	67	\N
523	43	185	1	159899	\N	159899	\N	\N	1	1	2	f	\N	43	\N
524	18	185	1	5858	\N	5858	\N	\N	2	1	2	f	\N	18	\N
525	44	185	1	157053	\N	157053	\N	\N	0	1	2	f	\N	44	\N
526	16	185	1	5858	\N	5858	\N	\N	0	1	2	f	\N	18	\N
527	64	185	1	3978	\N	3978	\N	\N	0	1	2	f	\N	18	\N
528	19	185	1	1910	\N	1910	\N	\N	0	1	2	f	\N	19	\N
529	75	185	1	936	\N	936	\N	\N	0	1	2	f	\N	75	\N
530	2	185	1	622	\N	622	\N	\N	0	1	2	f	\N	2	\N
531	65	185	1	477	\N	477	\N	\N	0	1	2	f	\N	65	\N
532	6	185	1	422	\N	422	\N	\N	0	1	2	f	\N	6	\N
533	67	185	1	359	\N	359	\N	\N	0	1	2	f	\N	67	\N
535	76	187	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
536	45	188	2	158563	\N	0	\N	\N	1	1	2	f	158563	\N	\N
544	18	194	2	5858	\N	5858	\N	\N	1	1	2	f	0	\N	\N
545	16	194	2	5858	\N	5858	\N	\N	0	1	2	f	0	\N	\N
546	64	194	2	3978	\N	3978	\N	\N	0	1	2	f	0	\N	\N
547	2	194	2	622	\N	622	\N	\N	0	1	2	f	0	\N	\N
548	65	194	2	477	\N	477	\N	\N	0	1	2	f	0	\N	\N
549	6	194	2	422	\N	422	\N	\N	0	1	2	f	0	\N	\N
550	67	194	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
551	25	195	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
552	55	195	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
553	56	196	2	285	\N	285	\N	\N	1	1	2	f	0	24	\N
554	24	196	1	289	\N	289	\N	\N	1	1	2	f	\N	56	\N
555	25	197	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
556	55	197	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
557	24	198	2	20412	\N	0	\N	\N	1	1	2	f	20412	\N	\N
558	24	199	2	20701	\N	20701	\N	\N	1	1	2	f	0	\N	\N
559	57	199	2	19704	\N	19704	\N	\N	2	1	2	f	0	\N	\N
560	23	199	1	38160	\N	38160	\N	\N	1	1	2	f	\N	\N	\N
561	39	200	2	25	\N	25	\N	\N	1	1	2	f	0	39	\N
562	39	200	1	25	\N	25	\N	\N	1	1	2	f	\N	39	\N
563	43	201	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
564	16	201	2	74476	\N	0	\N	\N	2	1	2	f	74476	\N	\N
565	44	201	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
566	17	201	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
567	42	201	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
568	18	201	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
569	64	201	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
570	19	201	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
571	75	201	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
572	51	201	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
573	52	201	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
574	2	201	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
575	65	201	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
576	6	201	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
577	67	201	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
579	25	203	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
580	55	203	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
581	61	204	2	151407	\N	0	\N	\N	1	1	2	f	151407	\N	\N
582	18	205	2	5858	\N	5858	\N	\N	1	1	2	f	0	\N	\N
583	16	205	2	5858	\N	5858	\N	\N	0	1	2	f	0	\N	\N
584	64	205	2	3978	\N	3978	\N	\N	0	1	2	f	0	\N	\N
585	2	205	2	622	\N	622	\N	\N	0	1	2	f	0	\N	\N
586	65	205	2	477	\N	477	\N	\N	0	1	2	f	0	\N	\N
587	6	205	2	422	\N	422	\N	\N	0	1	2	f	0	\N	\N
588	67	205	2	359	\N	359	\N	\N	0	1	2	f	0	\N	\N
590	77	207	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
591	24	208	2	20412	\N	0	\N	\N	1	1	2	f	20412	\N	\N
592	17	209	2	22396	\N	0	\N	\N	1	1	2	f	22396	\N	\N
593	16	209	2	22396	\N	0	\N	\N	0	1	2	f	22396	\N	\N
594	42	209	2	22396	\N	0	\N	\N	0	1	2	f	22396	\N	\N
596	21	211	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
597	76	211	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
598	31	212	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
599	43	213	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
600	16	213	2	68618	\N	0	\N	\N	2	1	2	f	68618	\N	\N
601	44	213	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
602	17	213	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
603	42	213	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
604	19	213	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
605	75	213	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
606	51	213	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
607	52	213	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
608	77	214	2	1	\N	1	\N	\N	1	1	2	f	0	79	\N
609	79	214	1	1	\N	1	\N	\N	1	1	2	f	\N	77	\N
610	13	214	1	1	\N	1	\N	\N	0	1	2	f	\N	77	\N
611	3	215	2	12634	\N	0	\N	\N	1	1	2	f	12634	\N	\N
612	83	216	2	786	\N	0	\N	\N	1	1	2	f	786	\N	\N
613	77	217	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
614	61	218	2	157053	\N	0	\N	\N	1	1	2	f	157053	\N	\N
615	32	219	2	1211	\N	0	\N	\N	1	1	2	f	1211	\N	\N
616	73	220	2	123205	\N	0	\N	\N	1	1	2	f	123205	\N	\N
617	84	221	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
618	77	222	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
620	17	226	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
621	16	226	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
622	42	226	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
623	83	227	2	16079	\N	0	\N	\N	1	1	2	f	16079	\N	\N
624	32	228	2	1211	\N	0	\N	\N	1	1	2	f	1211	\N	\N
625	15	229	2	1	\N	1	\N	\N	1	1	2	f	0	76	\N
626	76	229	1	1	\N	1	\N	\N	1	1	2	f	\N	15	\N
627	44	231	2	157053	\N	157053	\N	\N	1	1	2	f	0	61	\N
628	43	231	2	157053	\N	157053	\N	\N	0	1	2	f	0	61	\N
629	61	231	1	157053	\N	157053	\N	\N	1	1	2	f	\N	44	\N
630	43	232	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
631	16	232	2	68618	\N	0	\N	\N	2	1	2	f	68618	\N	\N
632	83	232	2	786	\N	0	\N	\N	3	1	2	f	786	\N	\N
633	74	232	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
634	44	232	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
635	17	232	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
636	42	232	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
637	19	232	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
638	75	232	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
639	51	232	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
640	52	232	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
641	43	233	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
642	44	233	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
643	19	233	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
644	75	233	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
645	63	234	2	1910	\N	0	\N	\N	1	1	2	f	1910	\N	\N
646	61	235	2	157051	\N	157051	\N	\N	1	1	2	f	0	\N	\N
647	17	235	2	71305	\N	71305	\N	\N	2	1	2	f	0	\N	\N
648	76	235	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
649	16	235	2	71305	\N	71305	\N	\N	0	1	2	f	0	\N	\N
650	42	235	2	71305	\N	71305	\N	\N	0	1	2	f	0	\N	\N
651	56	236	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
657	76	241	2	3	\N	3	\N	\N	1	1	2	f	0	77	\N
658	77	241	1	3	\N	3	\N	\N	1	1	2	f	\N	76	\N
659	17	242	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
660	16	242	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
661	42	242	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
662	51	243	2	787	\N	787	\N	\N	1	1	2	f	0	83	\N
663	16	243	2	787	\N	787	\N	\N	0	1	2	f	0	83	\N
664	52	243	2	787	\N	787	\N	\N	0	1	2	f	0	83	\N
665	83	243	1	787	\N	787	\N	\N	1	1	2	f	\N	51	\N
667	38	245	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
668	43	246	2	150125	\N	0	\N	\N	1	1	2	f	150125	\N	\N
669	16	246	2	74476	\N	0	\N	\N	2	1	2	f	74476	\N	\N
670	25	246	2	591	\N	0	\N	\N	3	1	2	f	591	\N	\N
671	38	246	2	170	\N	0	\N	\N	4	1	2	f	170	\N	\N
672	40	246	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
673	47	246	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
674	48	246	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
675	50	246	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
676	78	246	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
677	79	246	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
678	15	246	2	1	\N	0	\N	\N	11	1	2	f	1	\N	\N
679	44	246	2	147279	\N	0	\N	\N	0	1	2	f	147279	\N	\N
680	17	246	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
681	42	246	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
682	18	246	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
683	64	246	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
684	19	246	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
685	75	246	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
686	51	246	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
687	52	246	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
688	2	246	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
689	55	246	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
690	65	246	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
691	6	246	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
692	67	246	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
693	13	246	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
694	41	246	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
695	14	246	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
696	83	247	2	16078	\N	0	\N	\N	1	1	2	f	16078	\N	\N
697	66	248	2	350	\N	350	\N	\N	1	1	2	f	0	\N	\N
698	43	249	2	150125	\N	0	\N	\N	1	1	2	f	150125	\N	\N
699	16	249	2	75687	\N	0	\N	\N	2	1	2	f	75687	\N	\N
700	83	249	2	16078	\N	0	\N	\N	3	1	2	f	16078	\N	\N
701	44	249	2	147279	\N	0	\N	\N	0	1	2	f	147279	\N	\N
702	17	249	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
703	42	249	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
704	18	249	2	7069	\N	0	\N	\N	0	1	2	f	7069	\N	\N
705	64	249	2	5149	\N	0	\N	\N	0	1	2	f	5149	\N	\N
706	19	249	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
707	75	249	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
708	51	249	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
709	52	249	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
710	2	249	2	650	\N	0	\N	\N	0	1	2	f	650	\N	\N
711	65	249	2	487	\N	0	\N	\N	0	1	2	f	487	\N	\N
712	6	249	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
713	67	249	2	361	\N	0	\N	\N	0	1	2	f	361	\N	\N
714	18	250	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
715	16	250	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
716	64	250	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
717	2	250	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
718	65	250	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
719	6	250	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
720	67	250	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
721	28	251	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
722	88	251	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
723	29	251	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
725	50	253	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
726	17	254	2	67831	\N	67831	\N	\N	1	1	2	f	0	44	\N
727	16	254	2	67831	\N	67831	\N	\N	0	1	2	f	0	44	\N
728	42	254	2	67831	\N	67831	\N	\N	0	1	2	f	0	44	\N
729	44	254	1	67831	\N	67831	\N	\N	1	1	2	f	\N	42	\N
730	43	254	1	67831	\N	67831	\N	\N	0	1	2	f	\N	17	\N
736	53	257	2	786	\N	0	\N	\N	1	1	2	f	786	\N	\N
737	17	258	2	67831	\N	67831	\N	\N	1	1	2	f	0	\N	\N
738	16	258	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
739	42	258	2	67831	\N	67831	\N	\N	0	1	2	f	0	\N	\N
740	61	259	2	125067	\N	0	\N	\N	1	1	2	f	125067	\N	\N
741	58	260	2	195	\N	0	\N	\N	1	1	2	f	195	\N	\N
744	39	263	2	200	\N	200	\N	\N	1	1	2	f	0	\N	\N
745	18	264	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
746	16	264	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
747	64	264	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
748	2	264	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
749	65	264	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
750	6	264	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
751	67	264	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
752	17	265	2	31544	\N	0	\N	\N	1	1	2	f	31544	\N	\N
753	16	265	2	31544	\N	0	\N	\N	0	1	2	f	31544	\N	\N
754	42	265	2	31544	\N	0	\N	\N	0	1	2	f	31544	\N	\N
755	45	266	2	143381	\N	0	\N	\N	1	1	2	f	143381	\N	\N
756	40	268	2	2	\N	2	\N	\N	1	1	2	f	0	40	\N
757	40	268	1	2	\N	2	\N	\N	1	1	2	f	\N	40	\N
763	72	273	2	333100	\N	0	\N	\N	1	1	2	f	333100	\N	\N
764	57	274	2	19705	\N	0	\N	\N	1	1	2	f	19705	\N	\N
765	38	275	2	91	\N	0	\N	\N	1	1	2	f	91	\N	\N
766	49	275	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
767	77	275	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
768	80	275	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
769	15	275	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
770	48	275	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
771	50	275	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
772	78	275	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
773	79	275	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
774	13	275	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
775	20	275	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
776	81	275	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
777	82	275	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
778	85	275	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
779	18	276	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
780	16	276	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
781	64	276	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
782	2	276	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
783	65	276	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
784	6	276	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
785	67	276	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
786	5	277	2	10170	\N	10170	\N	\N	1	1	2	f	0	3	\N
787	3	277	1	10170	\N	10170	\N	\N	1	1	2	f	\N	5	\N
788	18	278	2	1593	\N	0	\N	\N	1	1	2	f	1593	\N	\N
789	16	278	2	1593	\N	0	\N	\N	0	1	2	f	1593	\N	\N
790	64	278	2	1117	\N	0	\N	\N	0	1	2	f	1117	\N	\N
791	65	278	2	224	\N	0	\N	\N	0	1	2	f	224	\N	\N
792	67	278	2	136	\N	0	\N	\N	0	1	2	f	136	\N	\N
793	2	278	2	114	\N	0	\N	\N	0	1	2	f	114	\N	\N
794	6	278	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
795	1	279	2	137517	\N	137517	\N	\N	1	1	2	f	0	\N	\N
796	43	280	2	12803	\N	0	\N	\N	1	1	2	f	12803	\N	\N
797	44	280	2	12488	\N	0	\N	\N	0	1	2	f	12488	\N	\N
798	75	280	2	228	\N	0	\N	\N	0	1	2	f	228	\N	\N
799	19	280	2	87	\N	0	\N	\N	0	1	2	f	87	\N	\N
801	38	282	2	279	\N	279	\N	\N	1	1	2	f	0	\N	\N
802	41	282	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
803	48	282	1	13	\N	13	\N	\N	1	1	2	f	\N	38	\N
804	79	282	1	6	\N	6	\N	\N	2	1	2	f	\N	38	\N
805	78	282	1	4	\N	4	\N	\N	3	1	2	f	\N	38	\N
806	40	282	1	2	\N	2	\N	\N	4	1	2	f	\N	38	\N
807	13	282	1	262	\N	262	\N	\N	0	1	2	f	\N	38	\N
808	31	284	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
811	45	287	2	32562	\N	0	\N	\N	1	1	2	f	32562	\N	\N
812	43	288	2	159898	\N	159898	\N	\N	1	1	2	f	0	44	\N
813	16	288	2	68618	\N	68618	\N	\N	2	1	2	f	0	44	\N
814	44	288	2	157052	\N	157052	\N	\N	0	1	2	f	0	44	\N
815	17	288	2	67831	\N	67831	\N	\N	0	1	2	f	0	44	\N
816	42	288	2	67831	\N	67831	\N	\N	0	1	2	f	0	44	\N
817	19	288	2	1910	\N	1910	\N	\N	0	1	2	f	0	44	\N
818	75	288	2	936	\N	936	\N	\N	0	1	2	f	0	44	\N
819	51	288	2	787	\N	787	\N	\N	0	1	2	f	0	44	\N
820	52	288	2	787	\N	787	\N	\N	0	1	2	f	0	44	\N
821	44	288	1	228516	\N	228516	\N	\N	1	1	2	f	\N	\N	\N
822	43	288	1	228516	\N	228516	\N	\N	0	1	2	f	\N	\N	\N
826	84	291	2	147429	\N	147429	\N	\N	1	1	2	f	0	18	\N
827	18	291	1	147429	\N	147429	\N	\N	1	1	2	f	\N	84	\N
828	16	291	1	147429	\N	147429	\N	\N	0	1	2	f	\N	84	\N
829	2	291	1	118679	\N	118679	\N	\N	0	1	2	f	\N	84	\N
830	64	291	1	28750	\N	28750	\N	\N	0	1	2	f	\N	84	\N
835	83	294	2	14693	\N	0	\N	\N	1	1	2	f	14693	\N	\N
836	18	294	2	5858	\N	0	\N	\N	2	1	2	f	5858	\N	\N
837	16	294	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
838	64	294	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
839	2	294	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
840	65	294	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
841	6	294	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
842	67	294	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
843	65	295	2	477	\N	477	\N	\N	1	1	2	f	0	65	\N
844	16	295	2	477	\N	477	\N	\N	0	1	2	f	0	65	\N
845	18	295	2	477	\N	477	\N	\N	0	1	2	f	0	65	\N
846	65	295	1	477	\N	477	\N	\N	1	1	2	f	\N	65	\N
857	18	301	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
858	16	301	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
859	64	301	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
860	2	301	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
861	65	301	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
862	6	301	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
863	67	301	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
865	2	303	2	622	\N	622	\N	\N	1	1	2	f	0	2	\N
866	16	303	2	622	\N	622	\N	\N	0	1	2	f	0	2	\N
867	18	303	2	622	\N	622	\N	\N	0	1	2	f	0	2	\N
868	2	303	1	622	\N	622	\N	\N	1	1	2	f	\N	2	\N
869	2	304	2	480	\N	480	\N	\N	1	1	2	f	0	33	\N
870	33	304	1	480	\N	480	\N	\N	1	1	2	f	\N	2	\N
871	54	305	2	104095	\N	0	\N	\N	1	1	2	f	104095	\N	\N
874	56	307	2	26	\N	26	\N	\N	1	1	2	f	0	57	\N
875	57	307	1	26	\N	26	\N	\N	1	1	2	f	\N	56	\N
883	18	312	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
884	16	312	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
885	64	312	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
886	2	312	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
887	65	312	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
888	6	312	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
889	67	312	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
892	18	314	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
893	16	314	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
894	64	314	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
895	2	314	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
896	65	314	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
897	6	314	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
898	67	314	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
899	43	315	2	314317	\N	314317	\N	\N	1	1	2	f	0	72	\N
900	44	315	2	310824	\N	310824	\N	\N	0	1	2	f	0	72	\N
901	19	315	2	2266	\N	2266	\N	\N	0	1	2	f	0	72	\N
902	75	315	2	1227	\N	1227	\N	\N	0	1	2	f	0	72	\N
903	72	315	1	314317	\N	314317	\N	\N	1	1	2	f	\N	43	\N
906	51	317	2	16079	\N	16079	\N	\N	1	1	2	f	0	83	\N
907	16	317	2	16079	\N	16079	\N	\N	0	1	2	f	0	83	\N
908	52	317	2	16079	\N	16079	\N	\N	0	1	2	f	0	83	\N
909	83	317	1	16079	\N	16079	\N	\N	1	1	2	f	\N	51	\N
915	74	321	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
917	18	324	2	3978	\N	3978	\N	\N	1	1	2	f	0	64	\N
918	16	324	2	3978	\N	3978	\N	\N	0	1	2	f	0	64	\N
919	64	324	2	3978	\N	3978	\N	\N	0	1	2	f	0	64	\N
920	64	324	1	3978	\N	3978	\N	\N	1	1	2	f	\N	18	\N
923	47	327	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
924	76	327	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
926	62	329	2	936	\N	0	\N	\N	1	1	2	f	936	\N	\N
927	39	330	2	25	\N	25	\N	\N	1	1	2	f	0	39	\N
928	39	330	1	25	\N	25	\N	\N	1	1	2	f	\N	39	\N
929	43	331	2	159899	\N	159899	\N	\N	1	1	2	f	0	30	\N
930	44	331	2	157053	\N	157053	\N	\N	0	1	2	f	0	30	\N
931	19	331	2	1910	\N	1910	\N	\N	0	1	2	f	0	30	\N
932	75	331	2	936	\N	936	\N	\N	0	1	2	f	0	30	\N
933	30	331	1	159899	\N	159899	\N	\N	1	1	2	f	\N	43	\N
934	65	332	2	477	\N	477	\N	\N	1	1	2	f	0	\N	\N
935	49	333	2	3	\N	3	\N	\N	1	1	2	f	0	80	\N
936	80	333	1	3	\N	3	\N	\N	1	1	2	f	\N	49	\N
937	20	333	1	1	\N	1	\N	\N	0	1	2	f	\N	49	\N
938	81	333	1	1	\N	1	\N	\N	0	1	2	f	\N	49	\N
939	82	333	1	1	\N	1	\N	\N	0	1	2	f	\N	49	\N
943	84	337	2	147429	\N	0	\N	\N	1	1	2	f	147429	\N	\N
944	18	338	2	8548	\N	8548	\N	\N	1	1	2	f	0	\N	\N
945	16	338	2	8548	\N	8548	\N	\N	0	1	2	f	0	\N	\N
946	64	338	2	7174	\N	7174	\N	\N	0	1	2	f	0	\N	\N
947	2	338	2	660	\N	660	\N	\N	0	1	2	f	0	\N	\N
948	65	338	2	374	\N	374	\N	\N	0	1	2	f	0	\N	\N
949	67	338	2	340	\N	340	\N	\N	0	1	2	f	0	\N	\N
950	76	339	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
951	74	340	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
952	84	341	2	147429	\N	147429	\N	\N	1	1	2	f	0	\N	\N
953	30	342	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
956	17	345	2	53363	\N	0	\N	\N	1	1	2	f	53363	\N	\N
957	16	345	2	53363	\N	0	\N	\N	0	1	2	f	53363	\N	\N
958	42	345	2	53363	\N	0	\N	\N	0	1	2	f	53363	\N	\N
959	58	346	2	195	\N	195	\N	\N	1	1	2	f	0	\N	\N
960	30	347	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
965	18	350	2	4998	\N	4998	\N	\N	1	1	2	f	0	\N	\N
966	16	350	2	4998	\N	4998	\N	\N	0	1	2	f	0	\N	\N
967	64	350	2	3250	\N	3250	\N	\N	0	1	2	f	0	\N	\N
968	2	350	2	505	\N	505	\N	\N	0	1	2	f	0	\N	\N
969	67	350	2	472	\N	472	\N	\N	0	1	2	f	0	\N	\N
970	6	350	2	420	\N	420	\N	\N	0	1	2	f	0	\N	\N
971	65	350	2	351	\N	351	\N	\N	0	1	2	f	0	\N	\N
980	84	355	2	147429	\N	147429	\N	\N	1	1	2	f	0	25	\N
981	25	355	1	147429	\N	147429	\N	\N	1	1	2	f	\N	84	\N
982	55	355	1	147429	\N	147429	\N	\N	0	1	2	f	\N	84	\N
987	83	358	2	16079	\N	0	\N	\N	1	1	2	f	16079	\N	\N
992	17	361	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
993	16	361	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
994	42	361	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
997	66	364	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
998	53	365	2	104095	\N	104095	\N	\N	1	1	2	f	0	54	\N
999	54	365	1	104095	\N	104095	\N	\N	1	1	2	f	\N	53	\N
1002	18	367	2	5858	\N	0	\N	\N	1	1	2	f	5858	\N	\N
1003	16	367	2	5858	\N	0	\N	\N	0	1	2	f	5858	\N	\N
1004	64	367	2	3978	\N	0	\N	\N	0	1	2	f	3978	\N	\N
1005	2	367	2	622	\N	0	\N	\N	0	1	2	f	622	\N	\N
1006	65	367	2	477	\N	0	\N	\N	0	1	2	f	477	\N	\N
1007	6	367	2	422	\N	0	\N	\N	0	1	2	f	422	\N	\N
1008	67	367	2	359	\N	0	\N	\N	0	1	2	f	359	\N	\N
1014	43	371	2	159899	\N	159899	\N	\N	1	1	2	f	\N	\N	\N
1015	16	371	2	74476	\N	5858	\N	\N	2	1	2	f	68618	\N	\N
1016	44	371	2	157053	\N	157053	\N	\N	0	1	2	f	\N	\N	\N
1017	17	371	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
1018	42	371	2	67831	\N	\N	\N	\N	0	1	2	f	67831	\N	\N
1019	18	371	2	5858	\N	5858	\N	\N	0	1	2	f	\N	\N	\N
1020	64	371	2	3978	\N	3978	\N	\N	0	1	2	f	\N	\N	\N
1021	19	371	2	1910	\N	1910	\N	\N	0	1	2	f	\N	\N	\N
1022	75	371	2	936	\N	936	\N	\N	0	1	2	f	\N	\N	\N
1023	51	371	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
1024	52	371	2	787	\N	\N	\N	\N	0	1	2	f	787	\N	\N
1025	2	371	2	622	\N	622	\N	\N	0	1	2	f	\N	\N	\N
1026	65	371	2	477	\N	477	\N	\N	0	1	2	f	\N	\N	\N
1027	6	371	2	422	\N	422	\N	\N	0	1	2	f	\N	\N	\N
1028	67	371	2	359	\N	359	\N	\N	0	1	2	f	\N	\N	\N
1030	51	373	2	787	\N	0	\N	\N	1	1	2	f	787	\N	\N
1031	16	373	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
1032	52	373	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
1034	32	375	2	1211	\N	1211	\N	\N	1	1	2	f	0	\N	\N
1036	48	378	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1037	78	378	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1038	79	378	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
1039	13	378	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
1040	13	378	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
1041	25	379	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
1042	55	379	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
1043	17	380	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
1044	16	380	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1045	42	380	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1046	22	381	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1047	46	381	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1048	14	381	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
1049	43	382	2	159899	\N	159899	\N	\N	1	1	2	f	0	\N	\N
1050	44	382	2	157053	\N	157053	\N	\N	0	1	2	f	0	\N	\N
1051	19	382	2	1910	\N	1910	\N	\N	0	1	2	f	0	\N	\N
1052	75	382	2	936	\N	936	\N	\N	0	1	2	f	0	\N	\N
1053	62	383	2	185	\N	0	\N	\N	1	1	2	f	185	\N	\N
1055	33	385	2	485	\N	485	\N	\N	1	1	2	f	0	\N	\N
1056	45	386	2	662	\N	0	\N	\N	1	1	2	f	662	\N	\N
1057	23	388	2	218128	\N	218128	\N	\N	1	1	2	f	0	\N	\N
1058	23	388	1	218128	\N	218128	\N	\N	1	1	2	f	\N	\N	\N
1059	74	389	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1060	76	390	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1061	82	390	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1062	77	390	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
1063	80	390	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1065	19	392	2	1910	\N	1910	\N	\N	1	1	2	f	0	63	\N
1066	43	392	2	1910	\N	1910	\N	\N	0	1	2	f	0	63	\N
1067	63	392	1	1910	\N	1910	\N	\N	1	1	2	f	\N	19	\N
1068	26	393	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1069	60	393	1	4	\N	4	\N	\N	1	1	2	f	\N	26	\N
1070	87	393	1	1	\N	1	\N	\N	2	1	2	f	\N	26	\N
1071	27	393	1	1	\N	1	\N	\N	3	1	2	f	\N	26	\N
1072	17	394	2	67831	\N	0	\N	\N	1	1	2	f	67831	\N	\N
1073	16	394	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1074	42	394	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1075	61	395	2	41540	\N	0	\N	\N	1	1	2	f	41540	\N	\N
1076	53	396	2	786	\N	0	\N	\N	1	1	2	f	786	\N	\N
1077	6	397	2	274	\N	274	\N	\N	1	1	2	f	0	34	\N
1078	34	397	1	274	\N	274	\N	\N	1	1	2	f	\N	6	\N
1086	74	402	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1102	77	407	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1103	45	408	2	317488	\N	317488	\N	\N	1	1	2	f	0	\N	\N
1104	23	408	1	154227	\N	154227	\N	\N	1	1	2	f	\N	45	\N
1105	58	408	1	603	\N	603	\N	\N	2	1	2	f	\N	45	\N
1106	31	408	1	66	\N	66	\N	\N	3	1	2	f	\N	45	\N
1126	28	412	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
1127	29	412	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1128	50	413	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1129	18	414	2	5499	\N	5499	\N	\N	1	1	2	f	0	\N	\N
1130	16	414	2	5499	\N	5499	\N	\N	0	1	2	f	0	\N	\N
1131	64	414	2	3978	\N	3978	\N	\N	0	1	2	f	0	\N	\N
1132	2	414	2	622	\N	622	\N	\N	0	1	2	f	0	\N	\N
1133	65	414	2	477	\N	477	\N	\N	0	1	2	f	0	\N	\N
1134	6	414	2	422	\N	422	\N	\N	0	1	2	f	0	\N	\N
1135	51	415	2	787	\N	787	\N	\N	1	1	2	f	0	44	\N
1136	16	415	2	787	\N	787	\N	\N	0	1	2	f	0	44	\N
1137	52	415	2	787	\N	787	\N	\N	0	1	2	f	0	44	\N
1138	44	415	1	787	\N	787	\N	\N	1	1	2	f	\N	51	\N
1139	43	415	1	787	\N	787	\N	\N	0	1	2	f	\N	51	\N
1140	25	416	2	591	\N	0	\N	\N	1	1	2	f	591	\N	\N
1141	55	416	2	591	\N	0	\N	\N	0	1	2	f	591	\N	\N
1142	67	417	2	27	\N	27	\N	\N	1	1	2	f	0	42	\N
1143	17	417	1	27	\N	27	\N	\N	1	1	2	f	\N	67	\N
1144	16	417	1	27	\N	27	\N	\N	0	1	2	f	\N	67	\N
1145	42	417	1	27	\N	27	\N	\N	0	1	2	f	\N	67	\N
1146	43	418	2	159899	\N	0	\N	\N	1	1	2	f	159899	\N	\N
1147	16	418	2	68618	\N	0	\N	\N	2	1	2	f	68618	\N	\N
1148	83	418	2	786	\N	0	\N	\N	3	1	2	f	786	\N	\N
1149	74	418	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
1150	44	418	2	157053	\N	0	\N	\N	0	1	2	f	157053	\N	\N
1151	17	418	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1152	42	418	2	67831	\N	0	\N	\N	0	1	2	f	67831	\N	\N
1153	19	418	2	1910	\N	0	\N	\N	0	1	2	f	1910	\N	\N
1154	75	418	2	936	\N	0	\N	\N	0	1	2	f	936	\N	\N
1155	51	418	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
1156	52	418	2	787	\N	0	\N	\N	0	1	2	f	787	\N	\N
1157	18	419	2	4004	\N	0	\N	\N	1	1	2	f	4004	\N	\N
1158	16	419	2	4004	\N	0	\N	\N	0	1	2	f	4004	\N	\N
1159	64	419	2	3915	\N	0	\N	\N	0	1	2	f	3915	\N	\N
1160	2	419	2	43	\N	0	\N	\N	0	1	2	f	43	\N	\N
1161	67	419	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
1162	65	419	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1163	18	420	2	279	\N	0	\N	\N	1	1	2	f	279	\N	\N
1164	16	420	2	279	\N	0	\N	\N	0	1	2	f	279	\N	\N
1165	67	420	2	112	\N	0	\N	\N	0	1	2	f	112	\N	\N
1166	64	420	2	99	\N	0	\N	\N	0	1	2	f	99	\N	\N
1167	2	420	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
1168	65	420	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	1	44	157053	\N	0	\N
2	1	43	159899	\N	1	\N
3	1	19	1910	\N	0	\N
4	1	75	936	\N	0	\N
5	2	16	5858	\N	0	\N
6	2	18	5858	\N	1	\N
7	2	67	359	\N	0	\N
8	2	2	622	\N	0	\N
9	2	65	477	\N	0	\N
10	2	64	3978	\N	0	\N
11	2	6	422	\N	0	\N
12	3	44	157053	\N	1	\N
13	3	43	157053	\N	0	\N
14	6	18	5858	\N	1	\N
15	6	65	477	\N	0	\N
16	6	67	359	\N	0	\N
17	6	16	5858	\N	0	\N
18	6	6	422	\N	0	\N
19	6	2	622	\N	0	\N
20	6	64	3978	\N	0	\N
21	7	16	3978	\N	0	\N
22	7	18	3978	\N	1	\N
23	7	64	3978	\N	0	\N
24	8	19	1910	\N	1	\N
25	8	43	1910	\N	0	\N
26	9	75	936	\N	1	\N
27	9	43	936	\N	0	\N
28	12	16	622	\N	0	\N
29	12	2	622	\N	1	\N
30	12	18	622	\N	0	\N
31	13	16	477	\N	0	\N
32	13	65	477	\N	1	\N
33	13	18	477	\N	0	\N
34	14	16	422	\N	0	\N
35	14	6	422	\N	1	\N
36	14	18	422	\N	0	\N
37	15	16	359	\N	0	\N
38	15	18	359	\N	0	\N
39	15	67	359	\N	1	\N
40	16	19	1910	\N	0	\N
41	16	75	936	\N	0	\N
42	16	43	159899	\N	1	\N
43	16	44	157053	\N	0	\N
44	17	16	5858	\N	0	\N
45	17	18	5858	\N	1	\N
46	17	64	3978	\N	0	\N
47	17	6	422	\N	0	\N
48	17	2	622	\N	0	\N
49	17	65	477	\N	0	\N
50	17	67	359	\N	0	\N
51	18	43	157053	\N	0	\N
52	18	44	157053	\N	1	\N
53	19	16	5858	\N	0	\N
54	19	2	622	\N	0	\N
55	19	65	477	\N	0	\N
56	19	64	3978	\N	0	\N
57	19	67	359	\N	0	\N
58	19	6	422	\N	0	\N
59	19	18	5858	\N	1	\N
60	20	64	3978	\N	0	\N
61	20	16	3978	\N	0	\N
62	20	18	3978	\N	1	\N
63	21	19	1910	\N	1	\N
64	21	43	1910	\N	0	\N
65	22	75	936	\N	1	\N
66	22	43	936	\N	0	\N
67	23	2	622	\N	1	\N
68	23	16	622	\N	0	\N
69	23	18	622	\N	0	\N
70	24	65	477	\N	1	\N
71	24	18	477	\N	0	\N
72	24	16	477	\N	0	\N
73	25	6	422	\N	1	\N
74	25	18	422	\N	0	\N
75	25	16	422	\N	0	\N
76	26	18	359	\N	0	\N
77	26	16	359	\N	0	\N
78	26	67	359	\N	1	\N
81	41	27	4	\N	1	\N
82	42	26	4	\N	1	\N
83	51	16	67795	\N	0	\N
84	51	17	67795	\N	1	\N
85	51	42	67795	\N	0	\N
86	52	16	67795	\N	0	\N
87	52	42	67795	\N	1	\N
88	52	17	67795	\N	0	\N
89	53	16	67795	\N	0	\N
90	53	42	67795	\N	1	\N
91	53	17	67795	\N	0	\N
92	54	17	67795	\N	1	\N
93	54	42	67795	\N	0	\N
94	54	16	67795	\N	0	\N
95	55	16	67795	\N	0	\N
96	55	17	67795	\N	1	\N
97	55	42	67795	\N	0	\N
98	56	16	67795	\N	0	\N
99	56	42	67795	\N	1	\N
100	56	17	67795	\N	0	\N
101	59	66	349	\N	1	\N
102	60	65	349	\N	1	\N
105	79	13	2	\N	0	\N
106	82	13	2	\N	0	\N
111	130	15	1	\N	1	\N
112	131	38	1	\N	1	\N
113	133	49	3	\N	1	\N
114	134	77	3	\N	1	\N
123	157	3	1217	\N	1	\N
124	158	34	1217	\N	1	\N
125	160	5	128	\N	1	\N
126	161	65	128	\N	1	\N
127	181	6	422	\N	1	\N
128	182	6	422	\N	1	\N
129	183	6	422	\N	1	\N
130	184	6	422	\N	1	\N
131	184	18	422	\N	0	\N
132	184	16	422	\N	0	\N
133	185	73	122960	\N	1	\N
134	186	73	122960	\N	1	\N
135	187	73	122960	\N	1	\N
136	188	42	122960	\N	1	\N
137	188	17	122960	\N	0	\N
138	188	16	122960	\N	0	\N
141	205	53	1393	\N	1	\N
142	206	53	132	\N	1	\N
143	207	57	132	\N	2	\N
144	207	24	1393	\N	1	\N
147	217	44	310824	\N	0	\N
148	217	43	314317	\N	1	\N
149	217	75	1227	\N	0	\N
150	217	19	2266	\N	0	\N
151	218	44	157052	\N	0	\N
152	218	19	792	\N	0	\N
153	218	43	158777	\N	1	\N
154	218	75	933	\N	0	\N
155	219	43	157053	\N	0	\N
156	219	44	157053	\N	1	\N
157	220	16	122960	\N	0	\N
158	220	17	122960	\N	1	\N
159	220	42	122960	\N	0	\N
160	221	16	16079	\N	0	\N
161	221	51	16079	\N	1	\N
162	221	52	16079	\N	0	\N
163	222	19	1910	\N	1	\N
164	222	43	1910	\N	0	\N
165	223	43	936	\N	0	\N
166	223	75	936	\N	1	\N
167	224	61	157053	\N	3	\N
168	224	62	936	\N	5	\N
169	224	72	314317	\N	1	\N
170	224	45	158777	\N	2	\N
171	224	63	1910	\N	4	\N
172	225	73	122960	\N	1	\N
173	225	83	16079	\N	2	\N
174	226	72	310824	\N	1	\N
175	226	45	157052	\N	3	\N
176	226	61	157053	\N	2	\N
177	227	73	122960	\N	1	\N
178	228	73	122960	\N	1	\N
179	229	83	16079	\N	1	\N
180	230	83	16079	\N	1	\N
181	231	45	792	\N	3	\N
182	231	63	1910	\N	2	\N
183	231	72	2266	\N	1	\N
184	232	62	936	\N	2	\N
185	232	72	1227	\N	1	\N
186	232	45	933	\N	3	\N
187	244	67	359	\N	1	\N
188	245	67	359	\N	1	\N
189	246	67	359	\N	1	\N
190	247	18	359	\N	0	\N
191	247	16	359	\N	0	\N
192	247	67	359	\N	1	\N
193	250	15	1	\N	1	\N
194	253	38	1	\N	1	\N
195	283	47	3	\N	1	\N
196	284	77	3	\N	1	\N
197	289	32	1211	\N	1	\N
198	290	32	1211	\N	1	\N
199	291	32	1171	\N	1	\N
200	292	32	28	\N	1	\N
201	293	32	10	\N	1	\N
202	294	32	2	\N	1	\N
203	295	64	1171	\N	0	\N
204	295	18	1211	\N	1	\N
205	295	16	1211	\N	0	\N
206	295	2	28	\N	0	\N
207	295	65	10	\N	0	\N
208	295	67	2	\N	0	\N
209	296	1	137517	\N	1	\N
210	297	61	137517	\N	1	\N
211	298	84	147429	\N	1	\N
212	299	54	147429	\N	1	\N
215	305	45	158777	\N	1	\N
216	306	45	157052	\N	1	\N
217	307	45	933	\N	1	\N
218	308	45	792	\N	1	\N
219	309	44	157052	\N	0	\N
220	309	19	792	\N	0	\N
221	309	43	158777	\N	1	\N
222	309	75	933	\N	0	\N
223	311	13	2	\N	0	\N
224	311	78	1	\N	1	\N
225	311	48	1	\N	2	\N
226	312	77	1	\N	1	\N
227	313	77	1	\N	1	\N
228	314	77	2	\N	1	\N
229	323	3	1036	\N	1	\N
230	324	4	1036	\N	1	\N
233	351	83	16078	\N	1	\N
234	352	83	16078	\N	1	\N
235	376	48	1	\N	3	\N
236	376	79	2	\N	1	\N
237	376	40	2	\N	2	\N
238	376	13	45	\N	0	\N
239	377	13	4	\N	0	\N
240	378	38	2	\N	1	\N
241	379	38	2	\N	1	\N
242	380	38	1	\N	1	\N
243	381	41	4	\N	0	\N
244	381	38	45	\N	1	\N
245	385	3	211	\N	1	\N
246	386	67	211	\N	1	\N
247	388	4	142	\N	1	\N
248	389	2	142	\N	1	\N
249	390	62	936	\N	1	\N
250	391	62	936	\N	1	\N
251	392	43	936	\N	0	\N
252	392	75	936	\N	1	\N
255	398	86	8	\N	0	\N
256	398	85	34	\N	1	\N
257	399	86	1	\N	0	\N
258	399	85	2	\N	1	\N
259	400	38	34	\N	1	\N
260	400	85	2	\N	0	\N
261	401	38	8	\N	1	\N
262	401	85	1	\N	0	\N
263	423	40	591	\N	1	\N
264	429	13	5	\N	0	\N
265	445	13	10	\N	0	\N
266	447	13	6	\N	0	\N
267	452	13	3	\N	0	\N
268	453	13	4	\N	0	\N
269	457	13	3	\N	0	\N
270	485	40	591	\N	1	\N
271	487	13	4	\N	0	\N
272	488	13	5	\N	0	\N
273	494	55	591	\N	1	\N
274	494	25	591	\N	0	\N
275	495	41	4	\N	4	\N
276	495	59	10	\N	1	\N
277	495	26	6	\N	2	\N
278	495	15	3	\N	6	\N
279	495	46	3	\N	7	\N
280	495	40	4	\N	5	\N
281	495	38	5	\N	0	\N
282	495	14	5	\N	3	\N
287	508	44	157053	\N	0	\N
288	508	43	159899	\N	1	\N
289	508	19	1910	\N	0	\N
290	508	75	936	\N	0	\N
291	509	16	5858	\N	0	\N
292	509	18	5858	\N	1	\N
293	509	67	359	\N	0	\N
294	509	2	622	\N	0	\N
295	509	65	477	\N	0	\N
296	509	64	3978	\N	0	\N
297	509	6	422	\N	0	\N
298	510	44	157053	\N	1	\N
299	510	43	157053	\N	0	\N
300	513	18	5858	\N	1	\N
301	513	65	477	\N	0	\N
302	513	67	359	\N	0	\N
303	513	16	5858	\N	0	\N
304	513	6	422	\N	0	\N
305	513	2	622	\N	0	\N
306	513	64	3978	\N	0	\N
307	514	16	3978	\N	0	\N
308	514	18	3978	\N	1	\N
309	514	64	3978	\N	0	\N
310	515	19	1910	\N	1	\N
311	515	43	1910	\N	0	\N
312	516	75	936	\N	1	\N
313	516	43	936	\N	0	\N
314	519	16	622	\N	0	\N
315	519	2	622	\N	1	\N
316	519	18	622	\N	0	\N
317	520	16	477	\N	0	\N
318	520	65	477	\N	1	\N
319	520	18	477	\N	0	\N
320	521	16	422	\N	0	\N
321	521	6	422	\N	1	\N
322	521	18	422	\N	0	\N
323	522	16	359	\N	0	\N
324	522	18	359	\N	0	\N
325	522	67	359	\N	1	\N
326	523	19	1910	\N	0	\N
327	523	75	936	\N	0	\N
328	523	43	159899	\N	1	\N
329	523	44	157053	\N	0	\N
330	524	16	5858	\N	0	\N
331	524	18	5858	\N	1	\N
332	524	64	3978	\N	0	\N
333	524	6	422	\N	0	\N
334	524	2	622	\N	0	\N
335	524	65	477	\N	0	\N
336	524	67	359	\N	0	\N
337	525	43	157053	\N	0	\N
338	525	44	157053	\N	1	\N
339	526	16	5858	\N	0	\N
340	526	2	622	\N	0	\N
341	526	65	477	\N	0	\N
342	526	64	3978	\N	0	\N
343	526	67	359	\N	0	\N
344	526	6	422	\N	0	\N
345	526	18	5858	\N	1	\N
346	527	64	3978	\N	0	\N
347	527	16	3978	\N	0	\N
348	527	18	3978	\N	1	\N
349	528	19	1910	\N	1	\N
350	528	43	1910	\N	0	\N
351	529	75	936	\N	1	\N
352	529	43	936	\N	0	\N
353	530	2	622	\N	1	\N
354	530	16	622	\N	0	\N
355	530	18	622	\N	0	\N
356	531	65	477	\N	1	\N
357	531	18	477	\N	0	\N
358	531	16	477	\N	0	\N
359	532	6	422	\N	1	\N
360	532	18	422	\N	0	\N
361	532	16	422	\N	0	\N
362	533	18	359	\N	0	\N
363	533	16	359	\N	0	\N
364	533	67	359	\N	1	\N
369	553	24	556	\N	1	\N
370	554	56	556	\N	1	\N
371	558	23	20415	\N	1	\N
372	559	23	17898	\N	1	\N
373	560	57	17898	\N	2	\N
374	560	24	20415	\N	1	\N
375	561	39	125	\N	1	\N
376	562	39	125	\N	1	\N
377	608	13	1	\N	0	\N
378	608	79	1	\N	1	\N
379	609	77	1	\N	1	\N
380	610	77	1	\N	1	\N
381	625	76	1	\N	1	\N
382	626	15	1	\N	1	\N
383	627	61	157053	\N	1	\N
384	628	61	157053	\N	1	\N
385	629	43	157053	\N	0	\N
386	629	44	157053	\N	1	\N
391	657	77	3	\N	1	\N
392	658	76	3	\N	1	\N
393	662	83	787	\N	1	\N
394	663	83	787	\N	1	\N
395	664	83	787	\N	1	\N
396	665	16	787	\N	0	\N
397	665	51	787	\N	1	\N
398	665	52	787	\N	0	\N
399	726	43	67831	\N	0	\N
400	726	44	67831	\N	1	\N
401	727	43	67831	\N	0	\N
402	727	44	67831	\N	1	\N
403	728	44	67831	\N	1	\N
404	728	43	67831	\N	0	\N
405	729	42	67831	\N	1	\N
406	729	17	67831	\N	0	\N
407	729	16	67831	\N	0	\N
408	730	17	67831	\N	1	\N
409	730	16	67831	\N	0	\N
410	730	42	67831	\N	0	\N
411	756	40	2	\N	1	\N
412	757	40	2	\N	1	\N
415	786	3	10170	\N	1	\N
416	787	5	10170	\N	1	\N
417	801	48	13	\N	1	\N
418	801	79	6	\N	2	\N
419	801	40	2	\N	4	\N
420	801	78	4	\N	3	\N
421	801	13	262	\N	0	\N
422	802	13	4	\N	0	\N
423	803	38	13	\N	1	\N
424	804	38	6	\N	1	\N
425	805	38	4	\N	1	\N
426	806	38	2	\N	1	\N
427	807	41	4	\N	0	\N
428	807	38	262	\N	1	\N
429	812	44	159898	\N	1	\N
430	812	43	159898	\N	0	\N
431	813	43	68618	\N	0	\N
432	813	44	68618	\N	1	\N
433	814	44	157052	\N	1	\N
434	814	43	157052	\N	0	\N
435	815	43	67831	\N	0	\N
436	815	44	67831	\N	1	\N
437	816	44	67831	\N	1	\N
438	816	43	67831	\N	0	\N
439	817	43	1910	\N	0	\N
440	817	44	1910	\N	1	\N
441	818	44	936	\N	1	\N
442	818	43	936	\N	0	\N
443	819	43	787	\N	0	\N
444	819	44	787	\N	1	\N
445	820	44	787	\N	1	\N
446	820	43	787	\N	0	\N
447	821	43	159898	\N	1	\N
448	821	44	157052	\N	0	\N
449	821	75	936	\N	0	\N
450	821	51	787	\N	0	\N
451	821	52	787	\N	0	\N
452	821	42	67831	\N	0	\N
453	821	17	67831	\N	0	\N
454	821	19	1910	\N	0	\N
455	821	16	68618	\N	2	\N
456	822	51	787	\N	0	\N
457	822	17	67831	\N	0	\N
458	822	19	1910	\N	0	\N
459	822	75	936	\N	0	\N
460	822	16	68618	\N	2	\N
461	822	42	67831	\N	0	\N
462	822	43	159898	\N	1	\N
463	822	44	157052	\N	0	\N
464	822	52	787	\N	0	\N
467	826	16	147429	\N	0	\N
468	826	2	118679	\N	0	\N
469	826	18	147429	\N	1	\N
470	826	64	28750	\N	0	\N
471	827	84	147429	\N	1	\N
472	828	84	147429	\N	1	\N
473	829	84	118679	\N	1	\N
474	830	84	28750	\N	1	\N
479	843	65	477	\N	1	\N
480	844	65	477	\N	1	\N
481	845	65	477	\N	1	\N
482	846	65	477	\N	1	\N
483	846	18	477	\N	0	\N
484	846	16	477	\N	0	\N
495	865	2	622	\N	1	\N
496	866	2	622	\N	1	\N
497	867	2	622	\N	1	\N
498	868	2	622	\N	1	\N
499	868	16	622	\N	0	\N
500	868	18	622	\N	0	\N
501	869	33	480	\N	1	\N
502	870	2	480	\N	1	\N
505	874	57	49	\N	1	\N
506	875	56	49	\N	1	\N
515	899	72	314317	\N	1	\N
516	900	72	310824	\N	1	\N
517	901	72	2266	\N	1	\N
518	902	72	1227	\N	1	\N
519	903	43	314317	\N	1	\N
520	903	44	310824	\N	0	\N
521	903	75	1227	\N	0	\N
522	903	19	2266	\N	0	\N
525	906	83	16079	\N	1	\N
526	907	83	16079	\N	1	\N
527	908	83	16079	\N	1	\N
528	909	16	16079	\N	0	\N
529	909	51	16079	\N	1	\N
530	909	52	16079	\N	0	\N
535	917	64	3978	\N	1	\N
536	918	64	3978	\N	1	\N
537	919	64	3978	\N	1	\N
538	920	64	3978	\N	0	\N
539	920	16	3978	\N	0	\N
540	920	18	3978	\N	1	\N
541	927	39	125	\N	1	\N
542	928	39	125	\N	1	\N
543	929	30	159899	\N	1	\N
544	930	30	157053	\N	1	\N
545	931	30	1910	\N	1	\N
546	932	30	936	\N	1	\N
547	933	75	936	\N	0	\N
548	933	43	159899	\N	1	\N
549	933	44	157053	\N	0	\N
550	933	19	1910	\N	0	\N
551	935	80	3	\N	1	\N
552	935	81	1	\N	0	\N
553	935	20	1	\N	0	\N
554	935	82	1	\N	0	\N
555	936	49	3	\N	1	\N
556	937	49	1	\N	1	\N
557	938	49	1	\N	1	\N
558	939	49	1	\N	1	\N
573	980	25	147429	\N	1	\N
574	980	55	147429	\N	0	\N
575	981	84	147429	\N	1	\N
576	982	84	147429	\N	1	\N
585	998	54	104095	\N	1	\N
586	999	53	104095	\N	1	\N
593	1039	13	32	\N	0	\N
594	1040	13	32	\N	0	\N
595	1057	23	218038	\N	1	\N
596	1058	23	218038	\N	1	\N
597	1065	63	1910	\N	1	\N
598	1066	63	1910	\N	1	\N
599	1067	43	1910	\N	0	\N
600	1067	19	1910	\N	1	\N
601	1068	87	1	\N	2	\N
602	1068	60	4	\N	1	\N
603	1068	27	1	\N	3	\N
604	1069	26	4	\N	1	\N
605	1070	26	1	\N	1	\N
606	1071	26	1	\N	1	\N
607	1077	34	274	\N	1	\N
608	1078	6	274	\N	1	\N
629	1103	58	603	\N	2	\N
630	1103	31	66	\N	3	\N
631	1103	23	154227	\N	1	\N
632	1104	45	154227	\N	1	\N
633	1105	45	603	\N	1	\N
634	1106	45	66	\N	1	\N
651	1135	43	787	\N	0	\N
652	1135	44	787	\N	1	\N
653	1136	43	787	\N	0	\N
654	1136	44	787	\N	1	\N
655	1137	44	787	\N	1	\N
656	1137	43	787	\N	0	\N
657	1138	51	787	\N	1	\N
658	1138	52	787	\N	0	\N
659	1138	16	787	\N	0	\N
660	1139	51	787	\N	1	\N
661	1139	16	787	\N	0	\N
662	1139	52	787	\N	0	\N
663	1142	16	27	\N	0	\N
664	1142	42	27	\N	1	\N
665	1142	17	27	\N	0	\N
666	1143	67	27	\N	1	\N
667	1144	67	27	\N	1	\N
668	1145	67	27	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
74	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
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
70	xhv	http://www.w3.org/1999/xhtml/vocab#	0	f	0
73	dwc	http://rs.tdwg.org/dwc/terms/	0	f	0
75	igeo	http://rdf.insee.fr/def/geo#	0	f	0
82	oplacl	http://www.openlinksw.com/ontology/acl#	0	f	0
83	prv	http://purl.org/net/provenance/ns#	0	f	0
84	n_9	http://id.eaufrance.fr/ddd/MAT/3.1/	0	f	0
92	rdfa	http://www.w3.org/ns/rdfa#	0	f	0
93	sirene	https://sireneld.io/vocab/sirene#	0	f	0
17	virtrdf	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
71	eau	http://id.eaufrance.fr/ddd/INC/1.0/	0	f	0
72	e	http://id.eaufrance.fr/ddd/par/3/	0	t	0
85	e-pmo	http://owl.sandre.eaufrance.fr/pmo/1.2#	0	f	0
86	e-par	http://owl.sandre.eaufrance.fr/par/2.3#	0	f	0
87	e-mat	http://owl.sandre.eaufrance.fr/mat/2#	0	f	0
88	e-sci	http://owl.sandre.eaufrance.fr/scl/1.1#	0	f	0
89	e-com	http://owl.sandre.eaufrance.fr/com/3#	0	f	0
76	e-odp	http://owl.sandre.eaufrance.fr/odp/1.1#	0	f	0
77	app-s	http://somewhere/ApplicationSchema#	0	f	0
78	opengis	http://www.opengis.net/rdf#	0	f	0
79	vcard-rdf	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
80	e-com-4	http://id.eaufrance.fr/ddd/COM/4/	0	f	0
81	e-apt	http://id.eaufrance.fr/ddd/APT/2.1/	0	f	0
90	vad	http://www.openlinksw.com/schemas/VAD#	0	f	0
91	virtdav	http://www.openlinksw.com/virtdav#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_id_eaufrance_fr_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_id_eaufrance_fr_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://id.eaufrance.fr/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://id.eaufrance.fr/sparql", "correlationId": "1674945958831113023", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "propertyLevelOnly", "calculateImportanceIndexes": "base", "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-09-06T06:25:45.127Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://xmlns.com/foaf/0.1/page	234375	\N	8	page	page	f	165757	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://owl.sandre.eaufrance.fr/odp/1.1#CdOuvrageDepollution	20419	\N	76	CdOuvrageDepollution	CdOuvrageDepollution	f	0	1	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://owl.sandre.eaufrance.fr/pmo/1.2#RsAnalyse	147429	\N	85	RsAnalyse	RsAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://rdf.insee.fr/def/geo#nom	36681	\N	75	nom	nom	f	0	1	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://id.eaufrance.fr/ddd/INC/1.0/MnInterlocuteur	150125	\N	71	MnInterlocuteur	MnInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://id.eaufrance.fr/ddd/par/3/parChimEstExprimeEn	9274	\N	72	parChimEstExprimeEn	parChimEstExprimeEn	f	9274	-1	-1	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://somewhere/ApplicationSchema#hasPointGeometry	4	\N	77	hasPointGeometry	hasPointGeometry	f	4	1	1	f	f	26	27	\N	t	f	\N	\N	\N	t	f	f
13	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	1	1	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://xmlns.com/foaf/0.1/homepage	789	\N	8	homepage	homepage	f	1	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://id.eaufrance.fr/ddd/APT/2.1/AppelTaxonParent	67795	\N	81	AppelTaxonParent	AppelTaxonParent	f	67795	1	-1	f	f	17	17	\N	t	f	\N	\N	\N	t	f	f
18	http://id.eaufrance.fr/ddd/INC/1.0/StruCdAlternInterlocuteur	314317	\N	71	StruCdAlternInterlocuteur	StruCdAlternInterlocuteur	f	314317	1	-1	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://purl.org/dc/terms/abstract	71570	\N	5	abstract	abstract	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://id.eaufrance.fr/ddd/par/3/DefValeursPossiblesParametre	146	\N	72	DefValeursPossiblesParametre	DefValeursPossiblesParametre	f	0	1	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://id.eaufrance.fr/ddd/par/3/ParHydrobioQuant	349	\N	72	ParHydrobioQuant	ParHydrobioQuant	f	349	1	1	f	f	65	66	\N	t	f	\N	\N	\N	t	f	f
23	http://id.eaufrance.fr/ddd/par/3/ComParametre	1473	\N	72	ComParametre	ComParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://rdf.insee.fr/def/geo#codeCommune	36681	\N	75	codeCommune	codeCommune	f	0	1	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://owl.sandre.eaufrance.fr/par/2.3#StUniteMesure	591	\N	86	StUniteMesure	StUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://id.eaufrance.fr/ddd/MAT/3.1/DateCreationElement	786	\N	84	DateCreationElement	DateCreationElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	457	\N	2	subPropertyOf	subPropertyOf	f	457	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://id.eaufrance.fr/ddd/INC/1.0/WebInterlocuteur	788	\N	71	WebInterlocuteur	WebInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	2	\N	1	first	first	f	2	1	1	f	f	\N	40	\N	t	f	\N	\N	\N	t	f	f
33	http://www.openlinksw.com/schemas/VAD#versionNumber	2	\N	90	versionNumber	versionNumber	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://purl.org/dc/terms/format	27252	\N	5	format	format	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://www.openlinksw.com/virtdav#dynRdfExtractor	2	\N	91	dynRdfExtractor	dynRdfExtractor	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://id.eaufrance.fr/ddd/par/3/DateCreationParametre	5858	\N	72	DateCreationParametre	DateCreationParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://purl.org/dc/terms/extent	3411	\N	5	extent	extent	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://owl.sandre.eaufrance.fr/par/2.3#DateMajUniteMesure	591	\N	86	DateMajUniteMesure	DateMajUniteMesure	f	0	-1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://owl.sandre.eaufrance.fr/odp/1.1#DateMiseServiceOuvrageDepollution	20271	\N	76	DateMiseServiceOuvrageDepollution	DateMiseServiceOuvrageDepollution	f	0	1	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://purl.org/dc/terms/audience	623	\N	5	audience	audience	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://purl.org/dc/elements/1.1/title	74476	\N	6	title	title	f	0	1	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	2	\N	79	EMAIL	EMAIL	f	2	1	1	f	f	\N	88	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	1	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://id.eaufrance.fr/ddd/COM/4/LbCommune	66	\N	80	LbCommune	LbCommune	f	0	1	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://www.w3.org/ns/rdfa#term	26	\N	92	term	term	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://id.eaufrance.fr/ddd/INC/1.0/LieuDitAdresse	7130	\N	71	LieuDitAdresse	LieuDitAdresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://id.eaufrance.fr/ddd/par/3/parMicrobioEstExprimeEn	1176	\N	72	parMicrobioEstExprimeEn	parMicrobioEstExprimeEn	f	1176	-1	-1	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	1	1	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://id.eaufrance.fr/ddd/MAT/3.1/LbElement	16078	\N	84	LbElement	LbElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	1	1	f	f	77	49	\N	t	f	\N	\N	\N	t	f	f
62	http://www.openlinksw.com/schemas/VAD#versionBuild	2	\N	90	versionBuild	versionBuild	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://id.eaufrance.fr/ddd/APT/2.1/NiveauTaxonomique	67831	\N	81	NiveauTaxonomique	NiveauTaxonomique	f	67831	1	-1	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://owl.sandre.eaufrance.fr/mat/2#APourEmetteur	12	\N	87	APourEmetteur	APourEmetteur	f	12	1	1	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://id.eaufrance.fr/ddd/INC/1.0/NomEtab	157053	\N	71	NomEtab	NomEtab	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://owl.sandre.eaufrance.fr/par/2.3#RefUniteMesure	591	\N	86	RefUniteMesure	RefUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	-1	-1	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://id.eaufrance.fr/ddd/par/3/BorneBasseParPhyQuant	5	\N	72	BorneBasseParPhyQuant	BorneBasseParPhyQuant	f	0	1	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://id.eaufrance.fr/ddd/par/3/parSyntAPourResultat	1217	\N	72	parSyntAPourResultat	parSyntAPourResultat	f	1217	-1	1	f	f	34	3	\N	t	f	\N	\N	\N	t	f	f
74	http://id.eaufrance.fr/ddd/par/3/CdCASSubstanceChimique	3268	\N	72	CdCASSubstanceChimique	CdCASSubstanceChimique	f	0	1	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://id.eaufrance.fr/ddd/par/3/ParHydrobioQual	128	\N	72	ParHydrobioQual	ParHydrobioQual	f	128	1	1	f	f	65	5	\N	t	f	\N	\N	\N	t	f	f
76	http://purl.org/dc/elements/1.1/subject	234375	\N	6	subject	subject	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://id.eaufrance.fr/ddd/INC/1.0/StInterlocuteur	159899	\N	71	StInterlocuteur	StInterlocuteur	f	159899	1	-1	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://id.eaufrance.fr/ddd/par/3/ParametreSynthese	422	\N	72	ParametreSynthese	ParametreSynthese	f	422	1	1	f	f	6	6	\N	t	f	\N	\N	\N	t	f	f
79	http://id.eaufrance.fr/ddd/APT/2.1/CodeAlternatifAp	122960	\N	81	CodeAlternatifAp	CodeAlternatifAp	f	122960	-1	1	f	f	17	73	\N	t	f	\N	\N	\N	t	f	f
81	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	-1	-1	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://www.openlinksw.com/schemas/VAD#packageName	2	\N	90	packageName	packageName	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://id.eaufrance.fr/ddd/APT/2.1/AuteurAppelTaxon	64980	\N	81	AuteurAppelTaxon	AuteurAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://id.eaufrance.fr/ddd/INC/1.0/NumLbVoieAdresse	140452	\N	71	NumLbVoieAdresse	NumLbVoieAdresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://id.eaufrance.fr/ddd/INC/1.0/CodeNAF	137517	\N	71	CodeNAF	CodeNAF	f	0	1	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://owl.sandre.eaufrance.fr/pmo/1.2#QualRsAnalyse	147429	\N	85	QualRsAnalyse	QualRsAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://id.eaufrance.fr/ddd/INC/1.0/EtatInterlocuteur	159899	\N	71	EtatInterlocuteur	EtatInterlocuteur	f	159899	1	-1	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://owl.sandre.eaufrance.fr/odp/1.1#APourPointMesure	786	\N	76	APourPointMesure	APourPointMesure	f	786	-1	1	f	f	\N	53	\N	t	f	\N	\N	\N	t	f	f
92	https://sireneld.io/vocab/sirene#siret	157053	\N	93	siret	siret	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://purl.org/dc/terms/contributor	86779	\N	5	contributor	contributor	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://id.eaufrance.fr/ddd/par/3/BorneBasseParHydQuant	6	\N	72	BorneBasseParHydQuant	BorneBasseParHydQuant	f	0	1	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://owl.sandre.eaufrance.fr/pmo/1.2#DateAnalyse	147429	\N	85	DateAnalyse	DateAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://id.eaufrance.fr/ddd/INC/1.0/DateFinActEtab	37208	\N	71	DateFinActEtab	DateFinActEtab	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://id.eaufrance.fr/ddd/par/3/DsCalculParSynthese	422	\N	72	DsCalculParSynthese	DsCalculParSynthese	f	0	1	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	1	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://purl.org/dc/terms/isPartOf	772032	\N	5	isPartOf	isPartOf	f	772032	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	2	\N	1	rest	rest	f	2	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://www.w3.org/2004/02/skos/core#definition	14472	\N	4	definition	definition	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://owl.sandre.eaufrance.fr/pmo/1.2#LocGlobalePointMesure	786	\N	85	LocGlobalePointMesure	LocGlobalePointMesure	f	0	1	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://www.w3.org/1999/xhtml/vocab#stylesheet	1	\N	70	stylesheet	stylesheet	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://id.eaufrance.fr/ddd/par/3/ParametreMicrobiologique	359	\N	72	ParametreMicrobiologique	ParametreMicrobiologique	f	359	1	1	f	f	67	67	\N	t	f	\N	\N	\N	t	f	f
108	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	10	\N	2	isDefinedBy	isDefinedBy	f	10	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://id.eaufrance.fr/ddd/par/3/NomIUPACSubstanceChimique	1867	\N	72	NomIUPACSubstanceChimique	NomIUPACSubstanceChimique	f	0	1	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://id.eaufrance.fr/ddd/par/3/StValeursPossiblesParametre	12634	\N	72	StValeursPossiblesParametre	StValeursPossiblesParametre	f	12634	1	-1	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://id.eaufrance.fr/ddd/INC/1.0/OrCdAlternInterlocuteur	314317	\N	71	OrCdAlternInterlocuteur	OrCdAlternInterlocuteur	f	0	1	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://owl.sandre.eaufrance.fr/par/2.3#CdUniteReference	591	\N	86	CdUniteReference	CdUniteReference	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://id.eaufrance.fr/ddd/MAT/3.1/DefElement	8614	\N	84	DefElement	DefElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://www.w3.org/ns/sparql-service-description#feature	10	\N	27	feature	feature	f	10	-1	1	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://id.eaufrance.fr/ddd/INC/1.0/DateMAJInterlocuteur	159899	\N	71	DateMAJInterlocuteur	DateMAJInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://www.w3.org/2002/07/owl#unionOf	1	\N	7	unionOf	unionOf	f	1	1	1	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://id.eaufrance.fr/ddd/APT/2.1/DateCreationAppelTaxon	67831	\N	81	DateCreationAppelTaxon	DateCreationAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	1	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://www.opengis.net/rdf#asWKT	10	\N	78	asWKT	asWKT	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://id.eaufrance.fr/ddd/INC/1.0/DateCreInterlocuteur	159899	\N	71	DateCreInterlocuteur	DateCreInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://owl.sandre.eaufrance.fr/par/2.3#NomIntUniteMesure	591	\N	86	NomIntUniteMesure	NomIntUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://id.eaufrance.fr/ddd/par/3/FormuleBruteSubstanceChimique	735	\N	72	FormuleBruteSubstanceChimique	FormuleBruteSubstanceChimique	f	0	1	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://id.eaufrance.fr/ddd/INC/1.0/SigleStructure	1865	\N	71	SigleStructure	SigleStructure	f	0	1	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	-1	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	1	-1	f	f	77	47	\N	t	f	\N	\N	\N	t	f	f
128	http://www.openlinksw.com/schemas/VAD#packageTitle	2	\N	90	packageTitle	packageTitle	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://id.eaufrance.fr/ddd/par/3/BorneHauteParHydQuant	6	\N	72	BorneHauteParHydQuant	BorneHauteParHydQuant	f	0	1	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://id.eaufrance.fr/ddd/par/3/aCommeTraduction	1211	\N	72	aCommeTraduction	aCommeTraduction	f	1211	1	1	f	f	18	32	\N	t	f	\N	\N	\N	t	f	f
134	http://id.eaufrance.fr/ddd/INC/1.0/Naf	137517	\N	71	Naf	Naf	f	137517	1	1	f	f	61	1	\N	t	f	\N	\N	\N	t	f	f
135	http://owl.sandre.eaufrance.fr/pmo/1.2#APourAnalyse	147429	\N	85	APourAnalyse	APourAnalyse	f	147429	-1	1	f	f	54	84	\N	t	f	\N	\N	\N	t	f	f
136	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	1	1	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://id.eaufrance.fr/ddd/par/3/ParSyntheseQuant	148	\N	72	ParSyntheseQuant	ParSyntheseQuant	f	0	1	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://id.eaufrance.fr/ddd/INC/1.0/AdresseInterlocuteur	158777	\N	71	AdresseInterlocuteur	AdresseInterlocuteur	f	158777	1	1	f	f	43	45	\N	t	f	\N	\N	\N	t	f	f
141	http://www.w3.org/ns/sparql-service-description#supportedLanguage	5	\N	27	supportedLanguage	supportedLanguage	f	5	1	1	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	-1	1	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://id.eaufrance.fr/ddd/MAT/3.1/DateMajNomenclature	787	\N	84	DateMajNomenclature	DateMajNomenclature	f	0	1	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://id.eaufrance.fr/ddd/MAT/3.1/MnElement	14693	\N	84	MnElement	MnElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://purl.org/dc/terms/issued	40509	\N	5	issued	issued	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://id.eaufrance.fr/ddd/par/3/CdValeursPossiblesParametre	12634	\N	72	CdValeursPossiblesParametre	CdValeursPossiblesParametre	f	0	1	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://owl.sandre.eaufrance.fr/pmo/1.2#StatutRsAnalyse	147429	\N	85	StatutRsAnalyse	StatutRsAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://id.eaufrance.fr/ddd/par/3/parPhysiqueAPourResultat	1036	\N	72	parPhysiqueAPourResultat	parPhysiqueAPourResultat	f	1036	-1	1	f	f	4	3	\N	t	f	\N	\N	\N	t	f	f
151	http://owl.sandre.eaufrance.fr/pmo/1.2#APourSupport	104095	\N	85	APourSupport	APourSupport	f	104095	1	-1	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://www.w3.org/2004/02/skos/core#inScheme	234375	\N	4	inScheme	inScheme	f	165757	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://owl.sandre.eaufrance.fr/mat/2#APourDestinataire	8	\N	87	APourDestinataire	APourDestinataire	f	8	1	1	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://id.eaufrance.fr/ddd/par/3/Contributor	5858	\N	72	Contributor	Contributor	f	5858	1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://id.eaufrance.fr/ddd/MAT/3.1/StElement	16079	\N	84	StElement	StElement	f	16078	1	-1	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://id.eaufrance.fr/ddd/par/3/LbCourtParametre	5858	\N	72	LbCourtParametre	LbCourtParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://purl.org/dc/terms/subject	554659	\N	5	subject	subject	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://purl.org/dc/elements/1.1/publisher	234375	\N	6	publisher	publisher	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.w3.org/2000/01/rdf-schema#range	167	\N	2	range	range	f	167	1	-1	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://id.eaufrance.fr/ddd/APT/2.1/ThemeTaxon	67831	\N	81	ThemeTaxon	ThemeTaxon	f	67831	1	-1	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://id.eaufrance.fr/ddd/par/3/parMicrobioAPourResultat	211	\N	72	parMicrobioAPourResultat	parMicrobioAPourResultat	f	211	-1	1	f	f	67	3	\N	t	f	\N	\N	\N	t	f	f
165	http://id.eaufrance.fr/ddd/par/3/ParPhysiqueQual	142	\N	72	ParPhysiqueQual	ParPhysiqueQual	f	142	1	1	f	f	2	4	\N	t	f	\N	\N	\N	t	f	f
166	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	2	\N	79	Pcode	Pcode	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://purl.org/dc/elements/1.1/format	3871	\N	6	format	format	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://purl.org/dc/terms/publisher	114286	\N	5	publisher	publisher	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://id.eaufrance.fr/ddd/INC/1.0/Service	936	\N	71	Service	Service	f	936	1	1	f	f	75	62	\N	t	f	\N	\N	\N	t	f	f
170	http://id.eaufrance.fr/ddd/MAT/3.1/LbNomenclature	787	\N	84	LbNomenclature	LbNomenclature	f	0	1	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://www.w3.org/2000/01/rdf-schema#member	35	\N	2	member	member	f	35	1	-1	f	f	\N	85	\N	t	f	\N	\N	\N	t	f	f
173	http://id.eaufrance.fr/ddd/MAT/3.1/DateCreationNomenclature	787	\N	84	DateCreationNomenclature	DateCreationNomenclature	f	0	1	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://id.eaufrance.fr/ddd/APT/2.1/OrgCdAlternatif	122960	\N	81	OrgCdAlternatif	OrgCdAlternatif	f	122960	1	-1	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://www.w3.org/2002/07/owl#imports	2	\N	7	imports	imports	f	2	1	1	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://www.w3.org/2001/vcard-rdf/3.0#City	2	\N	79	City	City	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://owl.sandre.eaufrance.fr/scl/1.1#CdSystemeCollecte	19706	\N	88	CdSystemeCollecte	CdSystemeCollecte	f	0	1	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://id.eaufrance.fr/ddd/APT/2.1/StAppelTaxon	67831	\N	81	StAppelTaxon	StAppelTaxon	f	67831	1	-1	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://www.openlinksw.com/schemas/VAD#releaseDate	2	\N	90	releaseDate	releaseDate	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://purl.org/dc/elements/1.1/identifier	234375	\N	6	identifier	identifier	f	165757	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	1	\N	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://id.eaufrance.fr/ddd/INC/1.0/LgAcheAdresse	158563	\N	71	LgAcheAdresse	LgAcheAdresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://id.eaufrance.fr/ddd/par/3/StParametre	5858	\N	72	StParametre	StParametre	f	5858	1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://owl.sandre.eaufrance.fr/par/2.3#SymUniteMesure	591	\N	86	SymUniteMesure	SymUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://owl.sandre.eaufrance.fr/mat/2#APourOuvrageDepollution	148	\N	87	APourOuvrageDepollution	APourOuvrageDepollution	f	148	-1	1	f	f	56	24	\N	t	f	\N	\N	\N	t	f	f
197	http://owl.sandre.eaufrance.fr/par/2.3#DsUniteMesure	591	\N	86	DsUniteMesure	DsUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
198	http://owl.sandre.eaufrance.fr/odp/1.1#CapaciteNom	20271	\N	76	CapaciteNom	CapaciteNom	f	0	1	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://owl.sandre.eaufrance.fr/odp/1.1#APourCommune	40111	\N	76	APourCommune	APourCommune	f	40111	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://www.w3.org/ns/sparql-service-description#endpoint	5	\N	27	endpoint	endpoint	f	5	1	1	f	f	39	39	\N	t	f	\N	\N	\N	t	f	f
201	http://purl.org/dc/elements/1.1/language	234375	\N	6	language	language	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://owl.sandre.eaufrance.fr/par/2.3#DateCreUniteMesure	591	\N	86	DateCreUniteMesure	DateCreUniteMesure	f	0	-1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://id.eaufrance.fr/ddd/INC/1.0/DateCreEtab	151407	\N	71	DateCreEtab	DateCreEtab	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://id.eaufrance.fr/ddd/par/3/NatParametre	5858	\N	72	NatParametre	NatParametre	f	5858	1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	-1	-1	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://owl.sandre.eaufrance.fr/odp/1.1#NomOuvrageDepollution	20271	\N	76	NomOuvrageDepollution	NomOuvrageDepollution	f	0	1	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://id.eaufrance.fr/ddd/APT/2.1/NomCommunAppelTaxon	22396	\N	81	NomCommunAppelTaxon	NomCommunAppelTaxon	f	0	-1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	1965257	\N	1	type	type	f	1965257	-1	-1	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
211	http://www.w3.org/2002/07/owl#equivalentClass	63	\N	7	equivalentClass	equivalentClass	f	63	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://id.eaufrance.fr/ddd/COM/4/CdCommune	66	\N	80	CdCommune	CdCommune	f	0	1	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://purl.org/dc/elements/1.1/date	228517	\N	6	date	date	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	1	1	f	f	77	79	\N	t	f	\N	\N	\N	t	f	f
215	http://id.eaufrance.fr/ddd/par/3/LbValeursPossiblesParametre	12634	\N	72	LbValeursPossiblesParametre	LbValeursPossiblesParametre	f	0	1	\N	f	f	3	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://id.eaufrance.fr/ddd/MAT/3.1/DateMajElement	786	\N	84	DateMajElement	DateMajElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	1	-1	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://id.eaufrance.fr/ddd/INC/1.0/CdSIRETEtab	157053	\N	71	CdSIRETEtab	CdSIRETEtab	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://id.eaufrance.fr/ddd/par/3/CdNomTradPar	1211	\N	72	CdNomTradPar	CdNomTradPar	f	0	1	\N	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://id.eaufrance.fr/ddd/APT/2.1/CdAlternatif	123205	\N	81	CdAlternatif	CdAlternatif	f	0	-1	\N	f	f	73	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://owl.sandre.eaufrance.fr/pmo/1.2#InSituAnalyse	147429	\N	85	InSituAnalyse	InSituAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	-1	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://purl.org/dc/terms/creator	257738	\N	5	creator	creator	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://purl.org/dc/terms/type	90187	\N	5	type	type	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://id.eaufrance.fr/ddd/APT/2.1/RedacteurFicheAppelTaxon	67831	\N	81	RedacteurFicheAppelTaxon	RedacteurFicheAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://id.eaufrance.fr/ddd/MAT/3.1/CdElement	16079	\N	84	CdElement	CdElement	f	0	1	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://id.eaufrance.fr/ddd/par/3/NomTradParametre	1211	\N	72	NomTradParametre	NomTradParametre	f	0	1	\N	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	1	1	f	f	15	76	\N	t	f	\N	\N	\N	t	f	f
230	http://purl.org/dc/terms/rightsHolder	73113	\N	5	rightsHolder	rightsHolder	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://id.eaufrance.fr/ddd/INC/1.0/Etablissement	157053	\N	71	Etablissement	Etablissement	f	157053	1	1	f	f	44	61	\N	t	f	\N	\N	\N	t	f	f
232	http://purl.org/dc/terms/modified	232759	\N	5	modified	modified	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://id.eaufrance.fr/ddd/INC/1.0/CdInterlocuteur	159899	\N	71	CdInterlocuteur	CdInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://id.eaufrance.fr/ddd/INC/1.0/NomStructure	1910	\N	71	NomStructure	NomStructure	f	0	1	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://www.w3.org/2002/07/owl#sameAs	228358	\N	7	sameAs	sameAs	f	228358	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://owl.sandre.eaufrance.fr/mat/2#APourScenario	12	\N	87	APourScenario	APourScenario	f	12	1	-1	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://purl.org/dc/terms/language	84386	\N	5	language	language	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	-1	1	f	f	76	77	\N	t	f	\N	\N	\N	t	f	f
242	http://id.eaufrance.fr/ddd/APT/2.1/CdAppelTaxon	67831	\N	81	CdAppelTaxon	CdAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://id.eaufrance.fr/ddd/MAT/3.1/StNomenclature	787	\N	84	StNomenclature	StNomenclature	f	787	1	-1	f	f	51	83	\N	t	f	\N	\N	\N	t	f	f
245	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	1	-1	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://www.w3.org/2000/01/rdf-schema#label	225423	\N	2	label	label	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://purl.org/dc/terms/title	103378	\N	5	title	title	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://id.eaufrance.fr/ddd/par/3/parHydrobioEstExprimeEn	350	\N	72	parHydrobioEstExprimeEn	parHydrobioEstExprimeEn	f	350	-1	-1	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://www.w3.org/2004/02/skos/core#prefLabel	241890	\N	4	prefLabel	prefLabel	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://id.eaufrance.fr/ddd/par/3/CdParametre	5858	\N	72	CdParametre	CdParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	4	\N	1	value	value	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://www.openlinksw.com/ontology/acl#hasApplicableAccess	2	\N	82	hasApplicableAccess	hasApplicableAccess	f	2	-1	1	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://id.eaufrance.fr/ddd/APT/2.1/Contributor	67831	\N	81	Contributor	Contributor	f	67831	1	-1	f	f	17	44	\N	t	f	\N	\N	\N	t	f	f
257	http://owl.sandre.eaufrance.fr/pmo/1.2#NumeroPointMesure	786	\N	85	NumeroPointMesure	NumeroPointMesure	f	0	1	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://id.eaufrance.fr/ddd/APT/2.1/TypeAppelTaxon	67831	\N	81	TypeAppelTaxon	TypeAppelTaxon	f	67831	1	-1	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://id.eaufrance.fr/ddd/INC/1.0/EtabSiege	125067	\N	71	EtabSiege	EtabSiege	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://owl.sandre.eaufrance.fr/com/3#NomCommune	195	\N	89	NomCommune	NomCommune	f	0	1	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://www.w3.org/ns/sparql-service-description#resultFormat	40	\N	27	resultFormat	resultFormat	f	40	-1	1	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://id.eaufrance.fr/ddd/par/3/ParametreCalcule	5858	\N	72	ParametreCalcule	ParametreCalcule	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://id.eaufrance.fr/ddd/APT/2.1/ComAppelTaxon	31544	\N	81	ComAppelTaxon	ComAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://id.eaufrance.fr/ddd/INC/1.0/DestinataireAdresse	143381	\N	71	DestinataireAdresse	DestinataireAdresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://purl.org/dc/terms/coverage	576679	\N	5	coverage	coverage	f	531606	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://www.w3.org/2002/07/owl#complementOf	2	\N	7	complementOf	complementOf	f	2	1	1	f	f	40	40	\N	t	f	\N	\N	\N	t	f	f
273	http://id.eaufrance.fr/ddd/INC/1.0/CdAlternInterlocuteur	333100	\N	71	CdAlternInterlocuteur	CdAlternInterlocuteur	f	0	-1	\N	f	f	72	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://owl.sandre.eaufrance.fr/scl/1.1#LbSystemeCollecte	19693	\N	88	LbSystemeCollecte	LbSystemeCollecte	f	0	-1	\N	f	f	57	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://www.w3.org/2000/01/rdf-schema#comment	144	\N	2	comment	comment	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://id.eaufrance.fr/ddd/par/3/NomParametre	5858	\N	72	NomParametre	NomParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://id.eaufrance.fr/ddd/par/3/parHydrobioAPourResultat	10170	\N	72	parHydrobioAPourResultat	parHydrobioAPourResultat	f	10170	-1	1	f	f	5	3	\N	t	f	\N	\N	\N	t	f	f
278	http://id.eaufrance.fr/ddd/par/3/ReferenceParametre	1593	\N	72	ReferenceParametre	ReferenceParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://id.eaufrance.fr/ddd/INC/1.0/LbNAF	137517	\N	71	LbNAF	LbNAF	f	137517	1	-1	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://id.eaufrance.fr/ddd/INC/1.0/ComInterlocuteur	12803	\N	71	ComInterlocuteur	ComInterlocuteur	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://www.w3.org/2000/01/rdf-schema#domain	279	\N	2	domain	domain	f	279	-1	-1	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://purl.org/dc/terms/alternative	271	\N	5	alternative	alternative	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://id.eaufrance.fr/ddd/COM/4/OrCdCommune	66	\N	80	OrCdCommune	OrCdCommune	f	0	1	\N	f	f	31	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://id.eaufrance.fr/ddd/INC/1.0/Compl2Adresse	32562	\N	71	Compl2Adresse	Compl2Adresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://purl.org/dc/elements/1.1/contributor	265771	\N	6	contributor	contributor	f	228516	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://owl.sandre.eaufrance.fr/pmo/1.2#APourParametre	147429	\N	85	APourParametre	APourParametre	f	147429	1	-1	f	f	84	18	\N	t	f	\N	\N	\N	t	f	f
294	http://www.w3.org/2004/02/skos/core#altLabel	20551	\N	4	altLabel	altLabel	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://id.eaufrance.fr/ddd/par/3/ParametreHydrobiologique	477	\N	72	ParametreHydrobiologique	ParametreHydrobiologique	f	477	1	1	f	f	65	65	\N	t	f	\N	\N	\N	t	f	f
301	http://id.eaufrance.fr/ddd/par/3/AuteurParametre	5858	\N	72	AuteurParametre	AuteurParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://id.eaufrance.fr/ddd/par/3/ParametrePhysique	622	\N	72	ParametrePhysique	ParametrePhysique	f	622	1	1	f	f	2	2	\N	t	f	\N	\N	\N	t	f	f
304	http://id.eaufrance.fr/ddd/par/3/ParPhysiqueQuant	480	\N	72	ParPhysiqueQuant	ParPhysiqueQuant	f	480	1	1	f	f	2	33	\N	t	f	\N	\N	\N	t	f	f
305	http://owl.sandre.eaufrance.fr/pmo/1.2#DatePrlvt	104095	\N	85	DatePrlvt	DatePrlvt	f	0	1	\N	f	f	54	\N	\N	t	f	\N	\N	\N	t	f	f
307	http://owl.sandre.eaufrance.fr/mat/2#APourSystemeCollecte	14	\N	87	APourSystemeCollecte	APourSystemeCollecte	f	14	-1	1	f	f	56	57	\N	t	f	\N	\N	\N	t	f	f
312	http://id.eaufrance.fr/ddd/par/3/DfParametre	5858	\N	72	DfParametre	DfParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://id.eaufrance.fr/ddd/par/3/LbLongParametre	5858	\N	72	LbLongParametre	LbLongParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
315	http://id.eaufrance.fr/ddd/INC/1.0/CdAlternatifInt	314317	\N	71	CdAlternatifInt	CdAlternatifInt	f	314317	-1	1	f	f	43	72	\N	t	f	\N	\N	\N	t	f	f
317	http://id.eaufrance.fr/ddd/MAT/3.1/Element	16079	\N	84	Element	Element	f	16079	-1	1	f	f	51	83	\N	t	f	\N	\N	\N	t	f	f
321	http://www.openlinksw.com/schemas/VAD#packageDeveloper	2	\N	90	packageDeveloper	packageDeveloper	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
322	http://www.w3.org/2001/vcard-rdf/3.0#Street	2	\N	79	Street	Street	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
324	http://id.eaufrance.fr/ddd/par/3/ParametreChimique	3978	\N	72	ParametreChimique	ParametreChimique	f	3978	1	1	f	f	18	64	\N	t	f	\N	\N	\N	t	f	f
327	http://www.w3.org/2001/vcard-rdf/3.0#ADR	2	\N	79	ADR	ADR	f	2	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://id.eaufrance.fr/ddd/INC/1.0/NomService	936	\N	71	NomService	NomService	f	0	1	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
330	http://www.w3.org/ns/sparql-service-description#url	5	\N	27	url	url	f	5	1	1	f	f	39	39	\N	t	f	\N	\N	\N	t	f	f
331	http://id.eaufrance.fr/ddd/INC/1.0/PaysInterlocuteur	159899	\N	71	PaysInterlocuteur	PaysInterlocuteur	f	159899	1	1	f	f	43	30	\N	t	f	\N	\N	\N	t	f	f
332	http://id.eaufrance.fr/ddd/par/3/aPourSupport	477	\N	72	aPourSupport	aPourSupport	f	477	1	-1	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
333	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	1	1	f	f	49	80	\N	t	f	\N	\N	\N	t	f	f
337	http://owl.sandre.eaufrance.fr/pmo/1.2#CdRemAnalyse	147429	\N	85	CdRemAnalyse	CdRemAnalyse	f	0	1	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
338	http://id.eaufrance.fr/ddd/par/3/GroupeParametres	8548	\N	72	GroupeParametres	GroupeParametres	f	8548	-1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
339	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	1	1	f	f	76	\N	\N	t	f	\N	\N	\N	t	f	f
340	http://www.openlinksw.com/schemas/DAV#ownerUser	3456	\N	18	ownerUser	ownerUser	f	3456	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
341	http://owl.sandre.eaufrance.fr/pmo/1.2#APourFractionAnalysee	147429	\N	85	APourFractionAnalysee	APourFractionAnalysee	f	147429	1	-1	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://id.eaufrance.fr/ddd/COM/4/NomPays	159899	\N	80	NomPays	NomPays	f	0	1	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
345	http://id.eaufrance.fr/ddd/APT/2.1/RefBiblioAppelTaxon	53363	\N	81	RefBiblioAppelTaxon	RefBiblioAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://owl.sandre.eaufrance.fr/com/3#Intersecte	195	\N	89	Intersecte	Intersecte	f	195	1	-1	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
347	http://id.eaufrance.fr/ddd/COM/4/CdPays	159899	\N	80	CdPays	CdPays	f	0	1	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://id.eaufrance.fr/ddd/par/3/Methode	4998	\N	72	Methode	Methode	f	4998	-1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
355	http://owl.sandre.eaufrance.fr/pmo/1.2#APourUniteMesure	147429	\N	85	APourUniteMesure	APourUniteMesure	f	147429	1	-1	f	f	84	25	\N	t	f	\N	\N	\N	t	f	f
358	http://purl.org/dc/terms/identifier	263708	\N	5	identifier	identifier	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://id.eaufrance.fr/ddd/APT/2.1/NomLatinAppelTaxon	67831	\N	81	NomLatinAppelTaxon	NomLatinAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://id.eaufrance.fr/ddd/par/3/PasParHydQuant	1	\N	72	PasParHydQuant	PasParHydQuant	f	0	1	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
365	http://owl.sandre.eaufrance.fr/pmo/1.2#APourPrelevement	104095	\N	85	APourPrelevement	APourPrelevement	f	104095	-1	1	f	f	53	54	\N	t	f	\N	\N	\N	t	f	f
367	http://id.eaufrance.fr/ddd/par/3/DateMajParametre	5858	\N	72	DateMajParametre	DateMajParametre	f	0	1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
371	http://purl.org/dc/elements/1.1/source	355118	\N	6	source	source	f	165757	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://id.eaufrance.fr/ddd/MAT/3.1/CdNomenclature	787	\N	84	CdNomenclature	CdNomenclature	f	0	1	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
375	http://id.eaufrance.fr/ddd/par/3/LangueNomTradPar	1211	\N	72	LangueNomTradPar	LangueNomTradPar	f	1211	1	-1	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://www.w3.org/2000/01/rdf-schema#subClassOf	79	\N	2	subClassOf	subClassOf	f	79	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://owl.sandre.eaufrance.fr/par/2.3#LbUniteMesure	591	\N	86	LbUniteMesure	LbUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
380	http://rs.tdwg.org/dwc/terms/scientificName	67831	\N	73	scientificName	scientificName	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://www.w3.org/2002/07/owl#equivalentProperty	192	\N	7	equivalentProperty	equivalentProperty	f	192	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
382	http://id.eaufrance.fr/ddd/INC/1.0/TypeInterlocuteur	159899	\N	71	TypeInterlocuteur	TypeInterlocuteur	f	159899	1	-1	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
383	http://id.eaufrance.fr/ddd/INC/1.0/SigleService	185	\N	71	SigleService	SigleService	f	0	1	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://id.eaufrance.fr/ddd/par/3/parPhysiqueEstExprimeEn	485	\N	72	parPhysiqueEstExprimeEn	parPhysiqueEstExprimeEn	f	485	-1	-1	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
386	http://id.eaufrance.fr/ddd/INC/1.0/Compl3Adresse	662	\N	71	Compl3Adresse	Compl3Adresse	f	0	1	\N	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://www.w3.org/2001/vcard-rdf/3.0#Country	2	\N	79	Country	Country	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://owl.sandre.eaufrance.fr/com/3#APourCommuneAdjacente	218418	\N	89	APourCommuneAdjacente	APourCommuneAdjacente	f	218418	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
389	http://www.openlinksw.com/schemas/VAD#packageDownload	4	\N	90	packageDownload	packageDownload	f	0	-1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://www.w3.org/2000/01/rdf-schema#seeAlso	5	\N	2	seeAlso	seeAlso	f	5	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://id.eaufrance.fr/ddd/INC/1.0/Structure	1910	\N	71	Structure	Structure	f	1910	1	1	f	f	19	63	\N	t	f	\N	\N	\N	t	f	f
393	http://somewhere/ApplicationSchema#hasExactGeometry	6	\N	77	hasExactGeometry	hasExactGeometry	f	6	1	1	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
394	http://id.eaufrance.fr/ddd/APT/2.1/DateMajAppelTaxon	67831	\N	81	DateMajAppelTaxon	DateMajAppelTaxon	f	0	1	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://id.eaufrance.fr/ddd/INC/1.0/DateDebActEtab	41540	\N	71	DateDebActEtab	DateDebActEtab	f	0	1	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
396	http://owl.sandre.eaufrance.fr/pmo/1.2#LbPointMesure	786	\N	85	LbPointMesure	LbPointMesure	f	0	1	\N	f	f	53	\N	\N	t	f	\N	\N	\N	t	f	f
397	http://id.eaufrance.fr/ddd/par/3/ParSyntheseQual	274	\N	72	ParSyntheseQual	ParSyntheseQual	f	274	1	1	f	f	6	34	\N	t	f	\N	\N	\N	t	f	f
402	http://www.openlinksw.com/schemas/VAD#packageCopyright	2	\N	90	packageCopyright	packageCopyright	f	0	1	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	4	\N	1	_5	_5	f	4	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	12	\N	1	_3	_3	f	11	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
406	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	4	\N	1	_4	_4	f	4	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
407	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	-1	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://id.eaufrance.fr/ddd/INC/1.0/Commune	317488	\N	71	Commune	Commune	f	317488	-1	-1	f	f	45	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	171	\N	1	_1	_1	f	119	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	28	\N	1	_2	_2	f	26	1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
412	http://www.w3.org/2001/vcard-rdf/3.0#TEL	2	\N	79	TEL	TEL	f	2	1	1	f	f	\N	28	\N	t	f	\N	\N	\N	t	f	f
413	http://www.openlinksw.com/ontology/acl#hasDefaultAccess	2	\N	82	hasDefaultAccess	hasDefaultAccess	f	2	-1	1	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://id.eaufrance.fr/ddd/par/3/TypeParametre	5499	\N	72	TypeParametre	TypeParametre	f	5499	1	-1	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
415	http://id.eaufrance.fr/ddd/MAT/3.1/Contributor	787	\N	84	Contributor	Contributor	f	787	1	-1	f	f	51	44	\N	t	f	\N	\N	\N	t	f	f
416	http://owl.sandre.eaufrance.fr/par/2.3#AuteurUniteMesure	591	\N	86	AuteurUniteMesure	AuteurUniteMesure	f	0	1	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
417	http://id.eaufrance.fr/ddd/par/3/aPourNomScientifique	27	\N	72	aPourNomScientifique	aPourNomScientifique	f	27	1	-1	f	f	67	17	\N	t	f	\N	\N	\N	t	f	f
418	http://purl.org/dc/terms/created	232759	\N	5	created	created	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://id.eaufrance.fr/ddd/par/3/LbSynonymeParametre	4004	\N	72	LbSynonymeParametre	LbSynonymeParametre	f	0	-1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
420	http://id.eaufrance.fr/ddd/par/3/LbPolysemeParametre	279	\N	72	LbPolysemeParametre	LbPolysemeParametre	f	0	-1	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
399	http://www.w3.org/1999/02/22-rdf-syntax-ns#_9	1	\N	1	_9	_9	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://www.w3.org/1999/02/22-rdf-syntax-ns#_27	1	\N	1	_27	_27	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.w3.org/1999/02/22-rdf-syntax-ns#_28	1	\N	1	_28	_28	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://www.w3.org/1999/02/22-rdf-syntax-ns#_29	1	\N	1	_29	_29	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://www.w3.org/1999/02/22-rdf-syntax-ns#_23	1	\N	1	_23	_23	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://www.w3.org/1999/02/22-rdf-syntax-ns#_24	1	\N	1	_24	_24	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://www.w3.org/1999/02/22-rdf-syntax-ns#_25	1	\N	1	_25	_25	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
300	http://www.w3.org/1999/02/22-rdf-syntax-ns#_26	1	\N	1	_26	_26	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://www.w3.org/1999/02/22-rdf-syntax-ns#_30	1	\N	1	_30	_30	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://www.w3.org/1999/02/22-rdf-syntax-ns#_31	1	\N	1	_31	_31	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://www.w3.org/1999/02/22-rdf-syntax-ns#_32	1	\N	1	_32	_32	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://www.w3.org/1999/02/22-rdf-syntax-ns#_33	1	\N	1	_33	_33	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://www.w3.org/1999/02/22-rdf-syntax-ns#_34	1	\N	1	_34	_34	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://www.w3.org/1999/02/22-rdf-syntax-ns#_35	1	\N	1	_35	_35	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
320	http://www.w3.org/1999/02/22-rdf-syntax-ns#_36	1	\N	1	_36	_36	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
348	http://www.w3.org/1999/02/22-rdf-syntax-ns#_10	1	\N	1	_10	_10	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://www.w3.org/1999/02/22-rdf-syntax-ns#_11	1	\N	1	_11	_11	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
351	http://www.w3.org/1999/02/22-rdf-syntax-ns#_16	1	\N	1	_16	_16	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
352	http://www.w3.org/1999/02/22-rdf-syntax-ns#_17	1	\N	1	_17	_17	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
353	http://www.w3.org/1999/02/22-rdf-syntax-ns#_18	1	\N	1	_18	_18	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
354	http://www.w3.org/1999/02/22-rdf-syntax-ns#_19	1	\N	1	_19	_19	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://www.w3.org/1999/02/22-rdf-syntax-ns#_12	1	\N	1	_12	_12	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
357	http://www.w3.org/1999/02/22-rdf-syntax-ns#_13	1	\N	1	_13	_13	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
359	http://www.w3.org/1999/02/22-rdf-syntax-ns#_14	1	\N	1	_14	_14	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://www.w3.org/1999/02/22-rdf-syntax-ns#_15	1	\N	1	_15	_15	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://www.w3.org/1999/02/22-rdf-syntax-ns#_20	1	\N	1	_20	_20	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://www.w3.org/1999/02/22-rdf-syntax-ns#_21	1	\N	1	_21	_21	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://www.w3.org/1999/02/22-rdf-syntax-ns#_22	1	\N	1	_22	_22	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://www.w3.org/1999/02/22-rdf-syntax-ns#_7	1	\N	1	_7	_7	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://www.w3.org/1999/02/22-rdf-syntax-ns#_8	1	\N	1	_8	_8	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://www.w3.org/1999/02/22-rdf-syntax-ns#_6	1	\N	1	_6	_6	f	1	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

COPY http_id_eaufrance_fr_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	13	8	priorVersion	\N
2	117	8	unionOf	\N
3	119	8	versionInfo	\N
4	177	8	imports	\N
5	211	8	equivalentClass	\N
6	235	8	sameAs	\N
7	268	8	complementOf	\N
8	381	8	equivalentProperty	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cc_rels_id_seq', 18, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.class_annots_id_seq', 6, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.classes_id_seq', 88, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cp_rels_id_seq', 1168, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cpc_rels_id_seq', 668, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.ns_id_seq', 93, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.properties_id_seq', 420, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

SELECT pg_catalog.setval('http_id_eaufrance_fr_sparql.property_annots_id_seq', 8, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_id_eaufrance_fr_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_id_eaufrance_fr_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_id_eaufrance_fr_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_id_eaufrance_fr_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_id_eaufrance_fr_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_id_eaufrance_fr_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_id_eaufrance_fr_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_id_eaufrance_fr_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_id_eaufrance_fr_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_id_eaufrance_fr_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_id_eaufrance_fr_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_id_eaufrance_fr_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_id_eaufrance_fr_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_id_eaufrance_fr_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_id_eaufrance_fr_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_id_eaufrance_fr_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_id_eaufrance_fr_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_id_eaufrance_fr_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_id_eaufrance_fr_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_id_eaufrance_fr_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_id_eaufrance_fr_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_id_eaufrance_fr_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_id_eaufrance_fr_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_id_eaufrance_fr_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_id_eaufrance_fr_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_id_eaufrance_fr_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_id_eaufrance_fr_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_id_eaufrance_fr_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_id_eaufrance_fr_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_id_eaufrance_fr_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_id_eaufrance_fr_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_id_eaufrance_fr_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_id_eaufrance_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_id_eaufrance_fr_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_id_eaufrance_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_id_eaufrance_fr_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_id_eaufrance_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_id_eaufrance_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_id_eaufrance_fr_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_id_eaufrance_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_id_eaufrance_fr_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_id_eaufrance_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_id_eaufrance_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_id_eaufrance_fr_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_id_eaufrance_fr_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_id_eaufrance_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_id_eaufrance_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_id_eaufrance_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_id_eaufrance_fr_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_id_eaufrance_fr_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_id_eaufrance_fr_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_id_eaufrance_fr_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_id_eaufrance_fr_sparql; Owner: -
--

ALTER TABLE ONLY http_id_eaufrance_fr_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_id_eaufrance_fr_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

