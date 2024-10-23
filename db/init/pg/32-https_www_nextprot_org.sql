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
-- Name: https_www_nextprot_org; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA https_www_nextprot_org;


--
-- Name: SCHEMA https_www_nextprot_org; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA https_www_nextprot_org IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: https_www_nextprot_org; Owner: -
--

CREATE FUNCTION https_www_nextprot_org.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: https_www_nextprot_org; Owner: -
--

CREATE FUNCTION https_www_nextprot_org.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: https_www_nextprot_org; Owner: -
--

COMMENT ON TABLE https_www_nextprot_org._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: https_www_nextprot_org; Owner: -
--

COMMENT ON COLUMN https_www_nextprot_org.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.properties (
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
-- Name: c_links; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((https_www_nextprot_org.classes c1
     JOIN https_www_nextprot_org.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN https_www_nextprot_org.properties p ON ((cp1.property_id = p.id)))
     JOIN https_www_nextprot_org.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN https_www_nextprot_org.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: https_www_nextprot_org; Owner: -
--

CREATE TABLE https_www_nextprot_org.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE https_www_nextprot_org.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_www_nextprot_org.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_cc_rels AS
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
   FROM https_www_nextprot_org.cc_rels r,
    https_www_nextprot_org.classes c1,
    https_www_nextprot_org.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_classes_ns AS
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
    https_www_nextprot_org.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_www_nextprot_org.classes c
     LEFT JOIN https_www_nextprot_org.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_classes_ns_main AS
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
   FROM https_www_nextprot_org.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM https_www_nextprot_org.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_classes_ns_plus AS
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
    https_www_nextprot_org.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM https_www_nextprot_org.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_www_nextprot_org.classes c
     LEFT JOIN https_www_nextprot_org.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_classes_ns_main_plus AS
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
   FROM https_www_nextprot_org.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM https_www_nextprot_org.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_classes_ns_main_v01 AS
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
   FROM (https_www_nextprot_org.v_classes_ns v
     LEFT JOIN https_www_nextprot_org.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_cp_rels AS
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
    https_www_nextprot_org.tapprox((r.cnt)::integer) AS cnt_x,
    https_www_nextprot_org.tapprox(r.object_cnt) AS object_cnt_x,
    https_www_nextprot_org.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM https_www_nextprot_org.cp_rels r,
    https_www_nextprot_org.classes c,
    https_www_nextprot_org.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_cp_rels_card AS
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
   FROM https_www_nextprot_org.cp_rels r,
    https_www_nextprot_org.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_properties_ns AS
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
    https_www_nextprot_org.tapprox(p.cnt) AS cnt_x,
    https_www_nextprot_org.tapprox(p.object_cnt) AS object_cnt_x,
    https_www_nextprot_org.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (https_www_nextprot_org.properties p
     LEFT JOIN https_www_nextprot_org.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_cp_sources_single AS
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
   FROM ((https_www_nextprot_org.v_cp_rels_card r
     JOIN https_www_nextprot_org.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_www_nextprot_org.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_cp_targets_single AS
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
   FROM ((https_www_nextprot_org.v_cp_rels_card r
     JOIN https_www_nextprot_org.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_www_nextprot_org.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    https_www_nextprot_org.tapprox((r.cnt)::integer) AS cnt_x
   FROM https_www_nextprot_org.pp_rels r,
    https_www_nextprot_org.properties p1,
    https_www_nextprot_org.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_properties_sources AS
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
   FROM (https_www_nextprot_org.v_properties_ns v
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
           FROM https_www_nextprot_org.cp_rels r,
            https_www_nextprot_org.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_properties_sources_single AS
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
   FROM (https_www_nextprot_org.v_properties_ns v
     LEFT JOIN https_www_nextprot_org.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_properties_targets AS
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
   FROM (https_www_nextprot_org.v_properties_ns v
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
           FROM https_www_nextprot_org.cp_rels r,
            https_www_nextprot_org.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: https_www_nextprot_org; Owner: -
--

CREATE VIEW https_www_nextprot_org.v_properties_targets_single AS
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
   FROM (https_www_nextprot_org.v_properties_ns v
     LEFT JOIN https_www_nextprot_org.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	32	118	1	\N	\N
2	33	86	1	\N	\N
3	45	32	1	\N	\N
4	58	32	1	\N	\N
5	91	63	1	\N	\N
6	101	150	1	\N	\N
7	103	32	1	\N	\N
8	119	32	1	\N	\N
9	158	32	1	\N	\N
10	160	63	1	\N	\N
11	175	32	1	\N	\N
12	176	32	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	2	8	Expression profile	\N
2	3	8	Domain	\N
3	4	8	Variant	\N
4	5	8	UniProtKB keyword annotation	\N
5	6	8	Subcellular location	\N
6	7	8	Mature protein	\N
7	8	8	Isoform	\N
8	9	8	Enzyme classification	\N
9	10	8	Miscellaneous	\N
10	11	8	Developmental stage expression information	\N
11	12	8	Glycosylation site	\N
12	13	8	Kinetic Vmax	\N
13	14	8	Coiled-coil region	\N
14	15	8	Variant information	\N
15	16	8	Intramembrane region	\N
16	17	8	Phenotype variation	\N
17	18	8	NCI thesaurus term	\N
18	19	8	Redox potential	\N
19	20	8	International Non proprietary Name	\N
20	21	8	Peroxisome transit peptide	\N
21	22	8	Cross reference	\N
22	26	8	SRM peptide mapping	\N
23	27	8	Short name	\N
24	28	8	Small molecule interaction	\N
25	29	8	Non-terminal residue	\N
26	30	8	Disease-related variant	\N
27	31	8	UniProtKB subcellular location term	\N
28	33	8	FunctionalProperty	\N
29	34	8	neXtProt metal term	\N
30	37	8	Pathway	\N
31	38	8	Topological domain	\N
32	39	8	Turn	\N
33	40	8	Cofactor information	\N
34	41	8	Pharmaceutical	\N
35	42	8	MeSH anatomy term	\N
36	43	8	Allergen	\N
37	44	8	PH dependence	\N
38	45	8	Observed expression	\N
39	47	8	Binary interaction	\N
40	48	8	GO cellular component	\N
41	49	8	Antibody mapping	\N
42	50	8	GO biological process term	\N
43	51	8	Active site	\N
44	52	8	Catalytic activity	\N
45	53	8	Enzyme classification number	\N
46	54	8	Repeat	\N
47	55	8	neXtProt family term	\N
48	56	8	Disulfide bond	\N
49	57	8	NCI Metathesaurus term	\N
50	58	8	Database	\N
51	59	8	neXtProt topology term	\N
52	60	8	Temperature dependence	\N
53	61	8	Non-consecutive residue	\N
54	64	8	Mutagenesis	\N
55	65	8	Protein	\N
56	66	8	Compositionally biased region	\N
57	67	8	Activity regulation	\N
58	68	8	Interacting region	\N
59	69	8	ORF name	\N
60	70	8	Miscellaneous site	\N
61	71	8	Mammalian phenotype term	\N
62	72	8	Kinetic note	\N
63	73	8	Family name	\N
64	74	8	neXtProt history	\N
65	76	8	AnnotationProperty	\N
66	77	8	Peptide mapping	\N
67	78	8	GO biological process	\N
68	79	8	Subcellular location information	\N
69	80	8	GO molecular function	\N
70	81	8	UniProtKB disease term	\N
71	82	8	Helix	\N
72	83	8	Domain information	\N
73	84	8	Proteoform	\N
74	85	8	MeSH term	\N
75	86	8	ObjectProperty	\N
76	87	8	Protein property	\N
77	88	8	Organelle term	\N
78	89	8	neXtProt protein property term	\N
79	91	8	OntologyProperty	\N
80	92	8	Modified residue	\N
81	93	8	PTM information	\N
82	94	8	Short sequence motif	\N
83	95	8	Gene	\N
84	96	8	Protein name	\N
85	97	8	Transmembrane region	\N
86	98	8	Initiator methionine	\N
87	99	8	Selenocysteine	\N
88	100	8	MIM term	\N
89	101	8	Large scale publication	\N
90	102	8	Mammalian phenotype	\N
91	103	8	GO qualifier	\N
92	104	8	Absorption max	\N
93	105	8	Bgee developmental stage term	\N
94	106	8	UniProt history	\N
95	108	8	Ontology	\N
96	109	8	Expression information	\N
97	110	8	Interaction information	\N
98	111	8	Binding site	\N
99	112	8	Induction	\N
100	113	8	Evidence	\N
101	114	8	Transport activity	\N
102	115	8	GO molecular function term	\N
103	116	8	Caution	\N
104	117	8	UniProtKB subcellular topology term	\N
105	118	8	Thing	\N
106	119	8	Source	\N
107	120	8	neXtProt modification effect term	\N
108	121	8	Non-standard amino acid term	\N
109	124	8	Identifier	\N
110	125	8	Class	\N
111	128	8	Function information	\N
112	129	8	Miscellaneous region	\N
113	130	8	PDB mapping	\N
114	131	8	Enzyme classification name	\N
115	132	8	Cofactor	\N
116	133	8	Sequence caution	\N
117	134	8	Kinetic KM	\N
118	135	8	Cleavage site	\N
119	136	8	Signal peptide	\N
120	137	8	Zinc finger region	\N
121	138	8	Maturation peptide	\N
122	139	8	neXtProt domain term	\N
123	140	8	Electrophysiological parameter	\N
124	141	8	Cellosaurus term	\N
125	142	8	UniProtKB subcellular orientation term	\N
126	143	8	Evidence code term	\N
127	144	8	Allergen name	\N
128	145	8	Protein sequence	\N
129	146	8	Person	\N
130	147	8	Consortium	\N
131	149	8	Interaction mapping	\N
132	150	8	Publication	\N
133	151	8	DNA-binding region	\N
134	152	8	UniProtKB keyword	\N
135	153	8	Cleaved region name	\N
136	154	8	Lipid moiety-binding region	\N
137	155	8	PSI-MI Molecular Interaction term	\N
138	156	8	DatatypeProperty	\N
139	157	8	Functional region name	\N
140	158	8	Severity	\N
141	159	8	Ion channel electrophysiology term	\N
142	160	8	TransitiveProperty	\N
143	162	8	Sequence conflict	\N
144	163	8	Disease	\N
145	164	8	Cross-link	\N
146	165	8	Beta strand	\N
147	166	8	Protein isoform name	\N
148	167	8	Gene name	\N
149	168	8	Experimental context	\N
150	169	8	GO cellular component term	\N
151	170	8	UniPathway term	\N
152	171	8	CD Antigen name	\N
153	172	8	Mitochondrial transit peptide	\N
154	173	8	neXtProt human anatomy term	\N
155	174	8	UniProtKB post-translational modification term	\N
156	175	8	Protein existence	\N
157	176	8	Quality qualifier	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
22	http://nextprot.org/rdf#Xref	190643857	\N	t	69	Xref	Xref	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	190643857
82	http://nextprot.org/rdf#Helix	170627	\N	t	69	Helix	Helix	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	511881
2	http://nextprot.org/rdf#ExpressionProfile	21831239	\N	t	69	ExpressionProfile	ExpressionProfile	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	88453967
3	http://nextprot.org/rdf#Domain	44624	\N	t	69	Domain	Domain	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	133872
4	http://nextprot.org/rdf#Variant	20466403	\N	t	69	Variant	Variant	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40947393
5	http://nextprot.org/rdf#UniprotKeyword	518692	\N	t	69	UniprotKeyword	UniprotKeyword	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1037384
6	http://nextprot.org/rdf#SubcellularLocation	122332	\N	t	69	SubcellularLocation	SubcellularLocation	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	366996
7	http://nextprot.org/rdf#MatureProtein	44610	\N	t	69	MatureProtein	MatureProtein	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	133830
8	http://nextprot.org/rdf#Isoform	42382	\N	t	69	Isoform	Isoform	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159581
9	http://nextprot.org/rdf#EnzymeClassification	11996	\N	t	69	EnzymeClassification	EnzymeClassification	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23992
10	http://nextprot.org/rdf#Miscellaneous	6175	\N	t	69	Miscellaneous	Miscellaneous	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12350
11	http://nextprot.org/rdf#DevelopmentalStageInfo	2073	\N	t	69	DevelopmentalStageInfo	DevelopmentalStageInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6219
12	http://nextprot.org/rdf#GlycosylationSite	49375	\N	t	69	GlycosylationSite	GlycosylationSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	148125
13	http://nextprot.org/rdf#KineticVmax	987	\N	t	69	KineticVmax	KineticVmax	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2961
14	http://nextprot.org/rdf#CoiledCoilRegion	6795	\N	t	69	CoiledCoilRegion	CoiledCoilRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20385
15	http://nextprot.org/rdf#VariantInfo	1598	\N	t	69	VariantInfo	VariantInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3196
16	http://nextprot.org/rdf#IntramembraneRegion	948	\N	t	69	IntramembraneRegion	IntramembraneRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2844
17	http://nextprot.org/rdf#PhenotypicVariation	76998	\N	t	69	PhenotypicVariation	PhenotypicVariation	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	153996
18	http://nextprot.org/rdf#NciThesaurusCv	45624	\N	t	69	NciThesaurusCv	NciThesaurusCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	681274
19	http://nextprot.org/rdf#RedoxPotential	11	\N	t	69	RedoxPotential	RedoxPotential	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	33
20	http://nextprot.org/rdf#InternationalNonproprietaryName	18	\N	t	69	InternationalNonproprietaryName	InternationalNonproprietaryName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	36
21	http://nextprot.org/rdf#PeroxisomeTransitPeptide	4	\N	t	69	PeroxisomeTransitPeptide	PeroxisomeTransitPeptide	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
26	http://nextprot.org/rdf#SrmPeptideMapping	399480	\N	t	69	SrmPeptideMapping	SrmPeptideMapping	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1198440
27	http://nextprot.org/rdf#ShortName	15946	\N	t	69	ShortName	ShortName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	47838
28	http://nextprot.org/rdf#SmallMoleculeInteraction	122441	\N	t	69	SmallMoleculeInteraction	SmallMoleculeInteraction	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	367323
29	http://nextprot.org/rdf#NonTerminalResidue	323	\N	t	69	NonTerminalResidue	NonTerminalResidue	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	646
30	http://nextprot.org/rdf#DiseaseRelatedVariant	2152	\N	t	69	DiseaseRelatedVariant	DiseaseRelatedVariant	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4304
31	http://nextprot.org/rdf#UniprotSubcellularLocationCv	540	\N	t	69	UniprotSubcellularLocationCv	UniprotSubcellularLocationCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	125441
32	http://www.w3.org/2002/07/owl#NamedIndividual	391	\N	t	7	NamedIndividual	NamedIndividual	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	504108715
33	http://www.w3.org/2002/07/owl#FunctionalProperty	1	\N	t	7	FunctionalProperty	FunctionalProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
34	http://nextprot.org/rdf#NextprotMetalCv	45	\N	t	69	NextprotMetalCv	NextprotMetalCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	111
37	http://nextprot.org/rdf#Pathway	139183	\N	t	69	Pathway	Pathway	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	417549
38	http://nextprot.org/rdf#TopologicalDomain	33105	\N	t	69	TopologicalDomain	TopologicalDomain	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	99315
39	http://nextprot.org/rdf#Turn	44006	\N	t	69	Turn	Turn	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	132018
40	http://nextprot.org/rdf#CofactorInfo	2122	\N	t	69	CofactorInfo	CofactorInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6366
41	http://nextprot.org/rdf#Pharmaceutical	90	\N	t	69	Pharmaceutical	Pharmaceutical	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	270
42	http://nextprot.org/rdf#MeshAnatomyCv	1841	\N	t	69	MeshAnatomyCv	MeshAnatomyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15623
43	http://nextprot.org/rdf#Allergen	14	\N	t	69	Allergen	Allergen	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	42
44	http://nextprot.org/rdf#PhDependence	652	\N	t	69	PhDependence	PhDependence	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1956
45	http://nextprot.org/rdf#ObservedExpression	5	\N	t	69	ObservedExpression	ObservedExpression	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23945784
46	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
47	http://nextprot.org/rdf#BinaryInteraction	1578137	\N	t	69	BinaryInteraction	BinaryInteraction	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4751053
48	http://nextprot.org/rdf#GoCellularComponent	175584	\N	t	69	GoCellularComponent	GoCellularComponent	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	529005
49	http://nextprot.org/rdf#AntibodyMapping	42611	\N	t	69	AntibodyMapping	AntibodyMapping	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	127833
50	http://nextprot.org/rdf#GoBiologicalProcessCv	27993	\N	t	69	GoBiologicalProcessCv	GoBiologicalProcessCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	870103
51	http://nextprot.org/rdf#ActiveSite	7167	\N	t	69	ActiveSite	ActiveSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21501
52	http://nextprot.org/rdf#CatalyticActivity	22714	\N	t	69	CatalyticActivity	CatalyticActivity	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68142
53	http://nextprot.org/rdf#EnzymeClassificationCv	7120	\N	t	69	EnzymeClassificationCv	EnzymeClassificationCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	65209
54	http://nextprot.org/rdf#Repeat	32966	\N	t	69	Repeat	Repeat	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	98898
55	http://nextprot.org/rdf#NextprotFamilyCv	5313	\N	t	69	NextprotFamilyCv	NextprotFamilyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22782
56	http://nextprot.org/rdf#DisulfideBond	35060	\N	t	69	DisulfideBond	DisulfideBond	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	105180
57	http://nextprot.org/rdf#NciMetathesaurusCv	2690	\N	t	69	NciMetathesaurusCv	NciMetathesaurusCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8305
58	http://nextprot.org/rdf#Database	170	\N	t	69	Database	Database	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	262187672
59	http://nextprot.org/rdf#NextprotTopologyCv	18	\N	t	69	NextprotTopologyCv	NextprotTopologyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	72702
60	http://nextprot.org/rdf#TemperatureDependence	114	\N	t	69	TemperatureDependence	TemperatureDependence	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	342
61	http://nextprot.org/rdf#NonConsecutiveResidue	1	\N	t	69	NonConsecutiveResidue	NonConsecutiveResidue	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
62	https://schema.org/Person	1	\N	t	70	Person	Person	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
63	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	142	\N	t	1	Property	Property	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	102
64	http://nextprot.org/rdf#Mutagenesis	89586	\N	t	69	Mutagenesis	Mutagenesis	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	205706
65	http://nextprot.org/rdf#Entry	20389	\N	t	69	Entry	Entry	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1339860
66	http://nextprot.org/rdf#CompositionallyBiasedRegion	53622	\N	t	69	CompositionallyBiasedRegion	CompositionallyBiasedRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	160866
67	http://nextprot.org/rdf#ActivityRegulation	3963	\N	t	69	ActivityRegulation	ActivityRegulation	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11889
68	http://nextprot.org/rdf#InteractingRegion	4656	\N	t	69	InteractingRegion	InteractingRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13968
69	http://nextprot.org/rdf#ORFName	2637	\N	t	69	ORFName	ORFName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13165
70	http://nextprot.org/rdf#MiscellaneousSite	4516	\N	t	69	MiscellaneousSite	MiscellaneousSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13548
71	http://nextprot.org/rdf#MammalianPhenotypeCv	13463	\N	t	69	MammalianPhenotypeCv	MammalianPhenotypeCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	143950
72	http://nextprot.org/rdf#KineticNote	574	\N	t	69	KineticNote	KineticNote	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1722
73	http://nextprot.org/rdf#FamilyName	14453	\N	t	69	FamilyName	FamilyName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14453
74	http://nextprot.org/rdf#NextprotHistory	20395	\N	t	69	NextprotHistory	NextprotHistory	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20395
75	http://www.w3.org/2000/01/rdf-schema#Class	15	\N	t	2	Class	Class	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	443
76	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
77	http://nextprot.org/rdf#PeptideMapping	8855603	\N	t	69	PeptideMapping	PeptideMapping	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26566809
78	http://nextprot.org/rdf#GoBiologicalProcess	338501	\N	t	69	GoBiologicalProcess	GoBiologicalProcess	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1033044
79	http://nextprot.org/rdf#SubcellularLocationNote	14585	\N	t	69	SubcellularLocationNote	SubcellularLocationNote	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43755
80	http://nextprot.org/rdf#GoMolecularFunction	161948	\N	t	69	GoMolecularFunction	GoMolecularFunction	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	511611
81	http://nextprot.org/rdf#UniprotDiseaseCv	6322	\N	t	69	UniprotDiseaseCv	UniprotDiseaseCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	129516
83	http://nextprot.org/rdf#DomainInfo	12852	\N	t	69	DomainInfo	DomainInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25704
84	http://nextprot.org/rdf#Proteoform	39487	\N	t	69	Proteoform	Proteoform	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39487
85	http://nextprot.org/rdf#MeshCv	4909	\N	t	69	MeshCv	MeshCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49360
86	http://www.w3.org/2002/07/owl#ObjectProperty	136	\N	t	7	ObjectProperty	ObjectProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	106
87	http://nextprot.org/rdf#ProteinProperty	225	\N	t	69	ProteinProperty	ProteinProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2780
88	http://nextprot.org/rdf#OrganelleCv	2	\N	t	69	OrganelleCv	OrganelleCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	887
89	http://nextprot.org/rdf#NextprotProteinPropertyCv	7	\N	t	69	NextprotProteinPropertyCv	NextprotProteinPropertyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	232
91	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
92	http://nextprot.org/rdf#ModifiedResidue	320598	\N	t	69	ModifiedResidue	ModifiedResidue	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	961794
93	http://nextprot.org/rdf#PtmInfo	23226	\N	t	69	PtmInfo	PtmInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	46452
94	http://nextprot.org/rdf#ShortSequenceMotif	7886	\N	t	69	ShortSequenceMotif	ShortSequenceMotif	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23658
95	http://nextprot.org/rdf#Gene	20476	\N	t	69	Gene	Gene	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20519
96	http://nextprot.org/rdf#ProteinName	52163	\N	t	69	ProteinName	ProteinName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	136100
97	http://nextprot.org/rdf#TransmembraneRegion	38631	\N	t	69	TransmembraneRegion	TransmembraneRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	115893
98	http://nextprot.org/rdf#InitiatorMethionine	3265	\N	t	69	InitiatorMethionine	InitiatorMethionine	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9795
99	http://nextprot.org/rdf#Selenocysteine	53	\N	t	69	Selenocysteine	Selenocysteine	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159
100	http://nextprot.org/rdf#OmimCv	2634	\N	t	69	OmimCv	OmimCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6854
101	http://nextprot.org/rdf#LargeScalePublication	1963	\N	t	69	LargeScalePublication	LargeScalePublication	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3335227
102	http://nextprot.org/rdf#MammalianPhenotype	430	\N	t	69	MammalianPhenotype	MammalianPhenotype	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1031
103	http://nextprot.org/rdf#GoQualifier	6	\N	t	69	GoQualifier	GoQualifier	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	243798
104	http://nextprot.org/rdf#AbsorptionMax	3	\N	t	69	AbsorptionMax	AbsorptionMax	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
105	http://nextprot.org/rdf#BgeeDevelopmentalStageCv	193	\N	t	69	BgeeDevelopmentalStageCv	BgeeDevelopmentalStageCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2255
106	http://nextprot.org/rdf#UniprotHistory	20395	\N	t	69	UniprotHistory	UniprotHistory	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20395
108	http://www.w3.org/2002/07/owl#Ontology	2	\N	t	7	Ontology	Ontology	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	757
109	http://nextprot.org/rdf#ExpressionInfo	129846	\N	t	69	ExpressionInfo	ExpressionInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	389538
110	http://nextprot.org/rdf#InteractionInfo	31753	\N	t	69	InteractionInfo	InteractionInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95259
111	http://nextprot.org/rdf#BindingSite	54564	\N	t	69	BindingSite	BindingSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	163692
112	http://nextprot.org/rdf#Induction	4837	\N	t	69	Induction	Induction	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9674
113	http://nextprot.org/rdf#Evidence	73897474	\N	t	69	Evidence	Evidence	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	177942174
114	http://nextprot.org/rdf#TransportActivity	4993	\N	t	69	TransportActivity	TransportActivity	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14979
115	http://nextprot.org/rdf#GoMolecularFunctionCv	11271	\N	t	69	GoMolecularFunctionCv	GoMolecularFunctionCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	264990
116	http://nextprot.org/rdf#Caution	4181	\N	t	69	Caution	Caution	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8362
117	http://nextprot.org/rdf#UniprotSubcellularTopologyCv	11	\N	t	69	UniprotSubcellularTopologyCv	UniprotSubcellularTopologyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
118	http://www.w3.org/2002/07/owl#Thing	391	\N	t	7	Thing	Thing	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	504108715
119	http://nextprot.org/rdf#Source	199	\N	t	69	Source	Source	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	86957545
120	http://nextprot.org/rdf#NextprotModificationEffectCv	13	\N	t	69	NextprotModificationEffectCv	NextprotModificationEffectCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	79198
121	http://nextprot.org/rdf#NonStandardAminoAcidCv	1	\N	t	69	NonStandardAminoAcidCv	NonStandardAminoAcidCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	54
122	http://nextprot.org/rdf#EvocDevelopmentalStageCv	157	\N	t	69	EvocDevelopmentalStageCv	EvocDevelopmentalStageCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	775
123	http://nextprot.org/rdf#SequenceOntologyCv	12	\N	t	69	SequenceOntologyCv	SequenceOntologyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
124	http://nextprot.org/rdf#Identifier	797122	\N	t	69	Identifier	Identifier	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	797122
125	http://www.w3.org/2002/07/owl#Class	208	\N	t	7	Class	Class	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	327956454
128	http://nextprot.org/rdf#FunctionInfo	39739	\N	t	69	FunctionInfo	FunctionInfo	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	119217
129	http://nextprot.org/rdf#MiscellaneousRegion	67380	\N	t	69	MiscellaneousRegion	MiscellaneousRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	202140
130	http://nextprot.org/rdf#PdbMapping	132986	\N	t	69	PdbMapping	PdbMapping	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	398958
131	http://nextprot.org/rdf#EnzymeName	5385	\N	t	69	EnzymeName	EnzymeName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16155
132	http://nextprot.org/rdf#Cofactor	4738	\N	t	69	Cofactor	Cofactor	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14214
133	http://nextprot.org/rdf#SequenceCaution	33504	\N	t	69	SequenceCaution	SequenceCaution	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67008
134	http://nextprot.org/rdf#KineticKM	2401	\N	t	69	KineticKM	KineticKM	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7203
135	http://nextprot.org/rdf#CleavageSite	1628	\N	t	69	CleavageSite	CleavageSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4884
136	http://nextprot.org/rdf#SignalPeptide	6207	\N	t	69	SignalPeptide	SignalPeptide	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18621
137	http://nextprot.org/rdf#ZincFingerRegion	16460	\N	t	69	ZincFingerRegion	ZincFingerRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49380
138	http://nextprot.org/rdf#Propeptide	1388	\N	t	69	Propeptide	Propeptide	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4164
139	http://nextprot.org/rdf#NextprotDomainCv	969	\N	t	69	NextprotDomainCv	NextprotDomainCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	87684
140	http://nextprot.org/rdf#ElectrophysiologicalParameter	376	\N	t	69	ElectrophysiologicalParameter	ElectrophysiologicalParameter	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10522
141	http://nextprot.org/rdf#NextprotCellosaurusCv	144568	\N	t	69	NextprotCellosaurusCv	NextprotCellosaurusCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	380876
142	http://nextprot.org/rdf#UniprotSubcellularOrientationCv	10	\N	t	69	UniprotSubcellularOrientationCv	UniprotSubcellularOrientationCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10
143	http://nextprot.org/rdf#EvidenceCodeOntologyCv	2010	\N	t	69	EvidenceCodeOntologyCv	EvidenceCodeOntologyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73916871
144	http://nextprot.org/rdf#AllergenName	6	\N	t	69	AllergenName	AllergenName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
145	http://nextprot.org/rdf#ProteinSequence	42388	\N	t	69	ProteinSequence	ProteinSequence	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	42388
146	http://nextprot.org/rdf#Person	4494676	\N	t	69	Person	Person	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4494676
147	http://nextprot.org/rdf#Consortium	7138	\N	t	69	Consortium	Consortium	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7138
149	http://nextprot.org/rdf#InteractionMapping	19109	\N	t	69	InteractionMapping	InteractionMapping	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57327
150	http://nextprot.org/rdf#Publication	574779	\N	t	69	Publication	Publication	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4841292
151	http://nextprot.org/rdf#DnaBindingRegion	1435	\N	t	69	DnaBindingRegion	DnaBindingRegion	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4305
152	http://nextprot.org/rdf#UniprotKeywordCv	1192	\N	t	69	UniprotKeywordCv	UniprotKeywordCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	527614
153	http://nextprot.org/rdf#CleavedRegionName	1756	\N	t	69	CleavedRegionName	CleavedRegionName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3923
154	http://nextprot.org/rdf#LipidationSite	1920	\N	t	69	LipidationSite	LipidationSite	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5760
155	http://nextprot.org/rdf#PsiMiCv	1389	\N	t	69	PsiMiCv	PsiMiCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	974937
156	http://www.w3.org/2002/07/owl#DatatypeProperty	56	\N	t	7	DatatypeProperty	DatatypeProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
157	http://nextprot.org/rdf#FunctionalRegionName	266	\N	t	69	FunctionalRegionName	FunctionalRegionName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	621
158	http://nextprot.org/rdf#Severity	3	\N	t	69	Severity	Severity	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12077
159	http://nextprot.org/rdf#NextprotIcepoCv	51	\N	t	69	NextprotIcepoCv	NextprotIcepoCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	568
160	http://www.w3.org/2002/07/owl#TransitiveProperty	1	\N	t	7	TransitiveProperty	TransitiveProperty	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
162	http://nextprot.org/rdf#SequenceConflict	84323	\N	t	69	SequenceConflict	SequenceConflict	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	168646
163	http://nextprot.org/rdf#Disease	41528	\N	t	69	Disease	Disease	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	126724
164	http://nextprot.org/rdf#CrossLink	47581	\N	t	69	CrossLink	CrossLink	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	142743
165	http://nextprot.org/rdf#BetaStrand	182078	\N	t	69	BetaStrand	BetaStrand	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	546234
166	http://nextprot.org/rdf#IsoformName	49802	\N	t	69	IsoformName	IsoformName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	107024
167	http://nextprot.org/rdf#GeneName	42576	\N	t	69	GeneName	GeneName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	192535
168	http://nextprot.org/rdf#ExperimentalContext	13531	\N	t	69	ExperimentalContext	ExperimentalContext	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27068498
169	http://nextprot.org/rdf#GoCellularComponentCv	4039	\N	t	69	GoCellularComponentCv	GoCellularComponentCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	226345
170	http://nextprot.org/rdf#UnipathwayCv	2560	\N	t	69	UnipathwayCv	UnipathwayCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31745
171	http://nextprot.org/rdf#CDAntigenName	398	\N	t	69	CDAntigenName	CDAntigenName	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	796
172	http://nextprot.org/rdf#MitochondrialTransitPeptide	881	\N	t	69	MitochondrialTransitPeptide	MitochondrialTransitPeptide	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2643
173	http://nextprot.org/rdf#NextprotAnatomyCv	1453	\N	t	69	NextprotAnatomyCv	NextprotAnatomyCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21851848
174	http://nextprot.org/rdf#UniprotPtmCv	696	\N	t	69	UniprotPtmCv	UniprotPtmCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	420741
175	http://nextprot.org/rdf#ProteinExistence	5	\N	t	69	ProteinExistence	ProteinExistence	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20394
176	http://nextprot.org/rdf#QualityQualifier	3	\N	t	69	QualityQualifier	QualityQualifier	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	130741445
177	http://nextprot.org/rdf#NextprotAnnotationCv	87	\N	t	69	NextprotAnnotationCv	NextprotAnnotationCv	288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	389
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	8	1	2	7167	\N	7167	\N	\N	1	1	2	f	0	51	\N
2	51	1	1	7167	\N	7167	\N	\N	1	1	2	f	\N	8	\N
3	8	2	2	21963158	\N	21963158	\N	\N	1	1	2	f	0	\N	\N
4	2	2	1	21831239	\N	21831239	\N	\N	1	1	2	f	\N	8	\N
5	109	2	1	129846	\N	129846	\N	\N	2	1	2	f	\N	8	\N
6	11	2	1	2073	\N	2073	\N	\N	3	1	2	f	\N	8	\N
8	8	4	2	56355	\N	56355	\N	\N	1	1	2	f	0	\N	\N
9	7	4	1	44610	\N	44610	\N	\N	1	1	2	f	\N	8	\N
10	136	4	1	6207	\N	6207	\N	\N	2	1	2	f	\N	8	\N
11	98	4	1	3265	\N	3265	\N	\N	3	1	2	f	\N	8	\N
12	138	4	1	1388	\N	1388	\N	\N	4	1	2	f	\N	8	\N
13	172	4	1	881	\N	881	\N	\N	5	1	2	f	\N	8	\N
14	21	4	1	4	\N	4	\N	\N	6	1	2	f	\N	8	\N
16	8	6	2	323	\N	323	\N	\N	1	1	2	f	0	29	\N
17	29	6	1	323	\N	323	\N	\N	1	1	2	f	\N	8	\N
18	130	7	2	132986	\N	0	\N	\N	1	1	2	f	132986	\N	\N
19	8	8	2	338501	\N	338501	\N	\N	1	1	2	f	0	78	\N
20	78	8	1	338501	\N	338501	\N	\N	1	1	2	f	\N	8	\N
21	2	9	2	21831239	\N	21831239	\N	\N	1	1	2	f	0	173	\N
22	5	9	2	518692	\N	518692	\N	\N	2	1	2	f	0	152	\N
23	78	9	2	338501	\N	338501	\N	\N	3	1	2	f	0	50	\N
24	92	9	2	320598	\N	320598	\N	\N	4	1	2	f	0	174	\N
25	48	9	2	175584	\N	175584	\N	\N	5	1	2	f	0	169	\N
26	80	9	2	161948	\N	161948	\N	\N	6	1	2	f	0	115	\N
27	6	9	2	122332	\N	122332	\N	\N	7	1	2	f	0	31	\N
28	17	9	2	76998	\N	76998	\N	\N	8	1	2	f	0	120	\N
29	12	9	2	49375	\N	49375	\N	\N	9	1	2	f	0	174	\N
30	164	9	2	47581	\N	47581	\N	\N	10	1	2	f	0	174	\N
31	3	9	2	44624	\N	44624	\N	\N	11	1	2	f	0	139	\N
32	97	9	2	38631	\N	38631	\N	\N	12	1	2	f	0	59	\N
33	38	9	2	33105	\N	33105	\N	\N	13	1	2	f	0	59	\N
34	54	9	2	24601	\N	24601	\N	\N	14	1	2	f	0	139	\N
35	163	9	2	17609	\N	17609	\N	\N	15	1	2	f	0	\N	\N
36	137	9	2	16307	\N	16307	\N	\N	16	1	2	f	0	139	\N
37	73	9	2	14453	\N	14453	\N	\N	17	1	2	f	0	55	\N
38	52	9	2	12153	\N	12153	\N	\N	18	1	2	f	0	53	\N
39	9	9	2	11996	\N	11996	\N	\N	19	1	2	f	0	53	\N
40	37	9	2	3133	\N	3133	\N	\N	20	1	2	f	0	170	\N
41	30	9	2	2152	\N	2152	\N	\N	21	1	2	f	0	120	\N
42	154	9	2	1920	\N	1920	\N	\N	22	1	2	f	0	174	\N
43	151	9	2	1183	\N	1183	\N	\N	23	1	2	f	0	139	\N
44	16	9	2	948	\N	948	\N	\N	24	1	2	f	0	59	\N
45	172	9	2	881	\N	881	\N	\N	25	1	2	f	0	88	\N
46	102	9	2	430	\N	430	\N	\N	26	1	2	f	0	71	\N
47	140	9	2	376	\N	376	\N	\N	27	1	2	f	0	159	\N
48	87	9	2	225	\N	225	\N	\N	28	1	2	f	0	89	\N
49	99	9	2	53	\N	53	\N	\N	29	1	2	f	0	121	\N
50	21	9	2	4	\N	4	\N	\N	30	1	2	f	0	88	\N
51	173	9	1	21831239	\N	21831239	\N	\N	1	1	2	f	\N	2	\N
52	152	9	1	518692	\N	518692	\N	\N	2	1	2	f	\N	5	\N
53	174	9	1	419474	\N	419474	\N	\N	3	1	2	f	\N	\N	\N
54	50	9	1	338501	\N	338501	\N	\N	4	1	2	f	\N	78	\N
55	169	9	1	175584	\N	175584	\N	\N	5	1	2	f	\N	48	\N
56	115	9	1	161948	\N	161948	\N	\N	6	1	2	f	\N	80	\N
57	31	9	1	122332	\N	122332	\N	\N	7	1	2	f	\N	6	\N
58	139	9	1	86715	\N	86715	\N	\N	8	1	2	f	\N	\N	\N
59	120	9	1	79150	\N	79150	\N	\N	9	1	2	f	\N	\N	\N
60	59	9	1	72684	\N	72684	\N	\N	10	1	2	f	\N	\N	\N
61	53	9	1	24149	\N	24149	\N	\N	11	1	2	f	\N	\N	\N
62	81	9	1	17314	\N	17314	\N	\N	12	1	2	f	\N	163	\N
63	55	9	1	14453	\N	14453	\N	\N	13	1	2	f	\N	73	\N
64	170	9	1	3133	\N	3133	\N	\N	14	1	2	f	\N	37	\N
65	88	9	1	885	\N	885	\N	\N	15	1	2	f	\N	\N	\N
66	71	9	1	430	\N	430	\N	\N	16	1	2	f	\N	102	\N
67	159	9	1	376	\N	376	\N	\N	17	1	2	f	\N	140	\N
68	18	9	1	295	\N	295	\N	\N	18	1	2	f	\N	163	\N
69	89	9	1	225	\N	225	\N	\N	19	1	2	f	\N	87	\N
70	121	9	1	53	\N	53	\N	\N	20	1	2	f	\N	99	\N
71	65	10	2	46967	\N	46967	\N	\N	1	1	2	f	0	\N	\N
72	8	10	2	42382	\N	42382	\N	\N	2	1	2	f	0	166	\N
73	95	10	2	20373	\N	20373	\N	\N	3	1	2	f	0	167	\N
74	166	10	1	42382	\N	42382	\N	\N	1	1	2	f	\N	8	\N
75	167	10	1	40746	\N	40746	\N	\N	2	1	2	f	\N	\N	\N
76	96	10	1	20389	\N	20389	\N	\N	3	1	2	f	\N	65	\N
77	131	10	1	4683	\N	4683	\N	\N	4	1	2	f	\N	65	\N
78	153	10	1	1345	\N	1345	\N	\N	5	1	2	f	\N	65	\N
79	157	10	1	177	\N	177	\N	\N	6	1	2	f	\N	65	\N
82	8	13	2	67380	\N	67380	\N	\N	1	1	2	f	0	129	\N
83	129	13	1	67380	\N	67380	\N	\N	1	1	2	f	\N	8	\N
84	8	14	2	6795	\N	6795	\N	\N	1	1	2	f	0	14	\N
85	14	14	1	6795	\N	6795	\N	\N	1	1	2	f	\N	8	\N
86	8	15	2	987	\N	987	\N	\N	1	1	2	f	0	13	\N
87	13	15	1	987	\N	987	\N	\N	1	1	2	f	\N	8	\N
88	8	16	2	4742	\N	4742	\N	\N	1	1	2	f	0	\N	\N
89	134	16	1	2401	\N	2401	\N	\N	1	1	2	f	\N	8	\N
90	13	16	1	987	\N	987	\N	\N	2	1	2	f	\N	8	\N
91	44	16	1	652	\N	652	\N	\N	3	1	2	f	\N	8	\N
92	72	16	1	574	\N	574	\N	\N	4	1	2	f	\N	8	\N
93	60	16	1	114	\N	114	\N	\N	5	1	2	f	\N	8	\N
94	19	16	1	11	\N	11	\N	\N	6	1	2	f	\N	8	\N
95	104	16	1	3	\N	3	\N	\N	7	1	2	f	\N	8	\N
96	125	17	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
97	125	17	1	4	\N	4	\N	\N	1	1	2	f	\N	125	\N
98	8	18	2	44006	\N	44006	\N	\N	1	1	2	f	0	39	\N
99	39	18	1	44006	\N	44006	\N	\N	1	1	2	f	\N	8	\N
100	8	19	2	39739	\N	39739	\N	\N	1	1	2	f	0	128	\N
101	128	19	1	39739	\N	39739	\N	\N	1	1	2	f	\N	8	\N
103	8	21	2	182078	\N	182078	\N	\N	1	1	2	f	0	165	\N
104	165	21	1	182078	\N	182078	\N	\N	1	1	2	f	\N	8	\N
105	8	22	2	948	\N	948	\N	\N	1	1	2	f	0	16	\N
106	16	22	1	948	\N	948	\N	\N	1	1	2	f	\N	8	\N
108	108	24	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
110	8	26	2	2401	\N	2401	\N	\N	1	1	2	f	0	134	\N
111	134	26	1	2401	\N	2401	\N	\N	1	1	2	f	\N	8	\N
113	8	28	2	25389326	\N	25389326	\N	\N	1	1	2	f	0	\N	\N
114	84	28	2	76998	\N	76998	\N	\N	2	1	2	f	0	17	\N
115	2	28	1	21831239	\N	21831239	\N	\N	1	1	2	f	\N	8	\N
116	47	28	1	1578137	\N	1578137	\N	\N	2	1	2	f	\N	8	\N
117	5	28	1	518692	\N	518692	\N	\N	3	1	2	f	\N	8	\N
118	78	28	1	338501	\N	338501	\N	\N	4	1	2	f	\N	8	\N
119	48	28	1	175584	\N	175584	\N	\N	5	1	2	f	\N	8	\N
120	80	28	1	161948	\N	161948	\N	\N	6	1	2	f	\N	8	\N
121	37	28	1	139183	\N	139183	\N	\N	7	1	2	f	\N	8	\N
122	109	28	1	129846	\N	129846	\N	\N	8	1	2	f	\N	8	\N
123	28	28	1	122441	\N	122441	\N	\N	9	1	2	f	\N	8	\N
124	6	28	1	122332	\N	122332	\N	\N	10	1	2	f	\N	8	\N
125	17	28	1	76998	\N	76998	\N	\N	11	1	2	f	\N	84	\N
126	163	28	1	41528	\N	41528	\N	\N	12	1	2	f	\N	8	\N
127	128	28	1	39739	\N	39739	\N	\N	13	1	2	f	\N	8	\N
128	133	28	1	33504	\N	33504	\N	\N	14	1	2	f	\N	8	\N
129	110	28	1	31753	\N	31753	\N	\N	15	1	2	f	\N	8	\N
130	93	28	1	23226	\N	23226	\N	\N	16	1	2	f	\N	8	\N
131	52	28	1	22714	\N	22714	\N	\N	17	1	2	f	\N	8	\N
132	79	28	1	14585	\N	14585	\N	\N	18	1	2	f	\N	8	\N
133	83	28	1	12852	\N	12852	\N	\N	19	1	2	f	\N	8	\N
134	9	28	1	11996	\N	11996	\N	\N	20	1	2	f	\N	8	\N
135	10	28	1	6175	\N	6175	\N	\N	21	1	2	f	\N	8	\N
136	114	28	1	4993	\N	4993	\N	\N	22	1	2	f	\N	8	\N
137	112	28	1	4837	\N	4837	\N	\N	23	1	2	f	\N	8	\N
138	132	28	1	4738	\N	4738	\N	\N	24	1	2	f	\N	8	\N
139	116	28	1	4181	\N	4181	\N	\N	25	1	2	f	\N	8	\N
140	67	28	1	3963	\N	3963	\N	\N	26	1	2	f	\N	8	\N
141	134	28	1	2401	\N	2401	\N	\N	27	1	2	f	\N	8	\N
142	40	28	1	2122	\N	2122	\N	\N	28	1	2	f	\N	8	\N
143	11	28	1	2073	\N	2073	\N	\N	29	1	2	f	\N	8	\N
144	15	28	1	1598	\N	1598	\N	\N	30	1	2	f	\N	8	\N
145	13	28	1	987	\N	987	\N	\N	31	1	2	f	\N	8	\N
146	44	28	1	652	\N	652	\N	\N	32	1	2	f	\N	8	\N
147	72	28	1	574	\N	574	\N	\N	33	1	2	f	\N	8	\N
148	60	28	1	114	\N	114	\N	\N	34	1	2	f	\N	8	\N
149	41	28	1	90	\N	90	\N	\N	35	1	2	f	\N	8	\N
150	43	28	1	14	\N	14	\N	\N	36	1	2	f	\N	8	\N
151	19	28	1	11	\N	11	\N	\N	37	1	2	f	\N	8	\N
152	104	28	1	3	\N	3	\N	\N	38	1	2	f	\N	8	\N
154	108	30	2	1	\N	1	\N	\N	1	1	2	f	0	62	\N
155	62	30	1	1	\N	1	\N	\N	1	1	2	f	\N	108	\N
156	8	31	2	132986	\N	132986	\N	\N	1	1	2	f	0	130	\N
157	130	31	1	132986	\N	132986	\N	\N	1	1	2	f	\N	8	\N
158	113	32	2	70750485	\N	70750485	\N	\N	1	1	2	f	0	58	\N
159	58	32	1	70750485	\N	70750485	\N	\N	1	1	2	f	\N	113	\N
160	118	32	1	70750485	\N	70750485	\N	\N	0	1	2	f	\N	113	\N
161	32	32	1	70750485	\N	70750485	\N	\N	0	1	2	f	\N	113	\N
162	8	33	2	21831239	\N	21831239	\N	\N	1	1	2	f	0	2	\N
163	2	33	1	21831239	\N	21831239	\N	\N	1	1	2	f	\N	8	\N
164	113	34	2	243792	\N	243792	\N	\N	1	1	2	f	0	103	\N
165	103	34	1	243792	\N	243792	\N	\N	1	1	2	f	\N	113	\N
166	118	34	1	243792	\N	243792	\N	\N	0	1	2	f	\N	113	\N
167	32	34	1	243792	\N	243792	\N	\N	0	1	2	f	\N	113	\N
168	8	35	2	31374461	\N	31374461	\N	\N	1	1	2	f	0	\N	\N
169	84	35	2	2152	\N	2152	\N	\N	2	1	2	f	0	30	\N
170	4	35	1	20466403	\N	20466403	\N	\N	1	1	2	f	\N	8	\N
171	77	35	1	8855603	\N	8855603	\N	\N	2	1	2	f	\N	8	\N
172	26	35	1	399480	\N	399480	\N	\N	3	1	2	f	\N	8	\N
173	92	35	1	320598	\N	320598	\N	\N	4	1	2	f	\N	8	\N
174	165	35	1	182078	\N	182078	\N	\N	5	1	2	f	\N	8	\N
175	82	35	1	170627	\N	170627	\N	\N	6	1	2	f	\N	8	\N
176	130	35	1	132986	\N	132986	\N	\N	7	1	2	f	\N	8	\N
177	64	35	1	89586	\N	89586	\N	\N	8	1	2	f	\N	8	\N
178	162	35	1	84323	\N	84323	\N	\N	9	1	2	f	\N	8	\N
179	129	35	1	67380	\N	67380	\N	\N	10	1	2	f	\N	8	\N
180	111	35	1	54564	\N	54564	\N	\N	11	1	2	f	\N	8	\N
181	66	35	1	53622	\N	53622	\N	\N	12	1	2	f	\N	8	\N
182	12	35	1	49375	\N	49375	\N	\N	13	1	2	f	\N	8	\N
183	164	35	1	47581	\N	47581	\N	\N	14	1	2	f	\N	8	\N
184	3	35	1	44624	\N	44624	\N	\N	15	1	2	f	\N	8	\N
185	7	35	1	44610	\N	44610	\N	\N	16	1	2	f	\N	8	\N
186	39	35	1	44006	\N	44006	\N	\N	17	1	2	f	\N	8	\N
187	49	35	1	42611	\N	42611	\N	\N	18	1	2	f	\N	8	\N
188	97	35	1	38631	\N	38631	\N	\N	19	1	2	f	\N	8	\N
189	56	35	1	35060	\N	35060	\N	\N	20	1	2	f	\N	8	\N
190	38	35	1	33105	\N	33105	\N	\N	21	1	2	f	\N	8	\N
191	54	35	1	32966	\N	32966	\N	\N	22	1	2	f	\N	8	\N
192	149	35	1	19109	\N	19109	\N	\N	23	1	2	f	\N	8	\N
193	137	35	1	16460	\N	16460	\N	\N	24	1	2	f	\N	8	\N
194	94	35	1	7886	\N	7886	\N	\N	25	1	2	f	\N	8	\N
195	51	35	1	7167	\N	7167	\N	\N	26	1	2	f	\N	8	\N
196	14	35	1	6795	\N	6795	\N	\N	27	1	2	f	\N	8	\N
197	136	35	1	6207	\N	6207	\N	\N	28	1	2	f	\N	8	\N
198	68	35	1	4656	\N	4656	\N	\N	29	1	2	f	\N	8	\N
199	70	35	1	4516	\N	4516	\N	\N	30	1	2	f	\N	8	\N
200	98	35	1	3265	\N	3265	\N	\N	31	1	2	f	\N	8	\N
201	30	35	1	2152	\N	2152	\N	\N	32	1	2	f	\N	84	\N
202	154	35	1	1920	\N	1920	\N	\N	33	1	2	f	\N	8	\N
203	135	35	1	1628	\N	1628	\N	\N	34	1	2	f	\N	8	\N
204	151	35	1	1435	\N	1435	\N	\N	35	1	2	f	\N	8	\N
205	138	35	1	1388	\N	1388	\N	\N	36	1	2	f	\N	8	\N
206	16	35	1	948	\N	948	\N	\N	37	1	2	f	\N	8	\N
207	172	35	1	881	\N	881	\N	\N	38	1	2	f	\N	8	\N
208	29	35	1	323	\N	323	\N	\N	39	1	2	f	\N	8	\N
209	99	35	1	53	\N	53	\N	\N	40	1	2	f	\N	8	\N
210	21	35	1	4	\N	4	\N	\N	41	1	2	f	\N	8	\N
211	61	35	1	1	\N	1	\N	\N	42	1	2	f	\N	8	\N
212	8	36	2	1435	\N	1435	\N	\N	1	1	2	f	0	151	\N
213	151	36	1	1435	\N	1435	\N	\N	1	1	2	f	\N	8	\N
214	77	37	2	8855603	\N	0	\N	\N	1	1	2	f	8855603	\N	\N
215	26	37	2	399480	\N	0	\N	\N	2	1	2	f	399480	\N	\N
216	8	38	2	114	\N	114	\N	\N	1	1	2	f	0	60	\N
217	60	38	1	114	\N	114	\N	\N	1	1	2	f	\N	8	\N
218	22	39	2	190643857	\N	0	\N	\N	1	1	2	f	190643857	\N	\N
219	124	39	2	797122	\N	0	\N	\N	2	1	2	f	797122	\N	\N
220	58	40	2	170	\N	0	\N	\N	1	1	2	f	170	\N	\N
221	32	40	2	170	\N	0	\N	\N	0	1	2	f	170	\N	\N
222	118	40	2	170	\N	0	\N	\N	0	1	2	f	170	\N	\N
223	8	41	2	32966	\N	32966	\N	\N	1	1	2	f	0	54	\N
224	54	41	1	32966	\N	32966	\N	\N	1	1	2	f	\N	8	\N
225	113	42	2	5159359	\N	0	\N	\N	1	1	2	f	5159359	\N	\N
227	8	44	2	6175	\N	6175	\N	\N	1	1	2	f	0	10	\N
228	10	44	1	6175	\N	6175	\N	\N	1	1	2	f	\N	8	\N
229	77	45	2	13060071	\N	13060071	\N	\N	1	1	2	f	0	119	\N
230	119	45	1	13060071	\N	13060071	\N	\N	1	1	2	f	\N	77	\N
231	118	45	1	13060071	\N	13060071	\N	\N	0	1	2	f	\N	77	\N
232	32	45	1	13060071	\N	13060071	\N	\N	0	1	2	f	\N	77	\N
233	108	46	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
234	125	47	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
238	77	50	2	8855603	\N	0	\N	\N	1	1	2	f	8855603	\N	\N
239	26	50	2	399480	\N	0	\N	\N	2	1	2	f	399480	\N	\N
240	150	51	2	566897	\N	0	\N	\N	1	1	2	f	566897	\N	\N
241	101	51	2	1887	\N	0	\N	\N	0	1	2	f	1887	\N	\N
242	65	52	2	20389	\N	0	\N	\N	1	1	2	f	20389	\N	\N
243	86	53	2	106	\N	106	\N	\N	1	1	2	f	0	86	\N
244	63	53	2	105	\N	105	\N	\N	2	1	2	f	0	\N	\N
245	86	53	1	106	\N	106	\N	\N	1	1	2	f	\N	86	\N
246	63	53	1	102	\N	102	\N	\N	0	1	2	f	\N	86	\N
247	168	54	2	4632	\N	4632	\N	\N	1	1	2	f	0	173	\N
248	173	54	1	4632	\N	4632	\N	\N	1	1	2	f	\N	168	\N
249	8	55	2	12852	\N	12852	\N	\N	1	1	2	f	0	83	\N
250	83	55	1	12852	\N	12852	\N	\N	1	1	2	f	\N	8	\N
252	8	57	2	3265	\N	3265	\N	\N	1	1	2	f	0	98	\N
253	98	57	1	3265	\N	3265	\N	\N	1	1	2	f	\N	8	\N
254	8	58	2	4516	\N	4516	\N	\N	1	1	2	f	0	70	\N
255	70	58	1	4516	\N	4516	\N	\N	1	1	2	f	\N	8	\N
256	146	59	2	4494676	\N	0	\N	\N	1	1	2	f	4494676	\N	\N
257	65	59	2	121151	\N	121151	\N	\N	2	1	2	f	0	\N	\N
258	8	59	2	49802	\N	49802	\N	\N	3	1	2	f	0	166	\N
259	95	59	2	45229	\N	45229	\N	\N	4	1	2	f	0	\N	\N
260	147	59	2	7138	\N	0	\N	\N	5	1	2	f	7138	\N	\N
261	167	59	1	85166	\N	85166	\N	\N	1	1	2	f	\N	\N	\N
262	96	59	1	52163	\N	52163	\N	\N	2	1	2	f	\N	65	\N
263	166	59	1	49802	\N	49802	\N	\N	3	1	2	f	\N	8	\N
264	27	59	1	15946	\N	15946	\N	\N	4	1	2	f	\N	65	\N
265	131	59	1	5385	\N	5385	\N	\N	5	1	2	f	\N	65	\N
266	69	59	1	5276	\N	5276	\N	\N	6	1	2	f	\N	\N	\N
267	153	59	1	1756	\N	1756	\N	\N	7	1	2	f	\N	65	\N
268	171	59	1	398	\N	398	\N	\N	8	1	2	f	\N	65	\N
269	157	59	1	266	\N	266	\N	\N	9	1	2	f	\N	65	\N
270	20	59	1	18	\N	18	\N	\N	10	1	2	f	\N	65	\N
271	144	59	1	6	\N	6	\N	\N	11	1	2	f	\N	65	\N
273	95	61	2	20476	\N	0	\N	\N	1	1	2	f	20476	\N	\N
276	113	63	2	27068498	\N	27068498	\N	\N	1	1	2	f	0	168	\N
277	168	63	1	27068498	\N	27068498	\N	\N	1	1	2	f	\N	113	\N
278	125	64	1	78	\N	78	\N	\N	1	1	2	f	\N	\N	\N
279	32	64	1	17	\N	17	\N	\N	2	1	2	f	\N	\N	\N
280	118	64	1	17	\N	17	\N	\N	0	1	2	f	\N	\N	\N
281	103	64	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
282	175	64	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
283	176	64	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
284	158	64	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
285	18	65	2	559496	\N	559496	\N	\N	1	1	2	f	0	18	\N
286	50	65	2	502416	\N	502416	\N	\N	2	1	2	f	0	50	\N
287	141	65	2	163787	\N	163787	\N	\N	3	1	2	f	0	141	\N
288	71	65	2	130057	\N	130057	\N	\N	4	1	2	f	0	71	\N
289	115	65	2	84168	\N	84168	\N	\N	5	1	2	f	0	115	\N
290	169	65	2	46119	\N	46119	\N	\N	6	1	2	f	0	169	\N
291	85	65	2	36871	\N	36871	\N	\N	7	1	2	f	0	85	\N
292	53	65	2	27980	\N	27980	\N	\N	8	1	2	f	0	53	\N
293	170	65	2	22096	\N	22096	\N	\N	9	1	2	f	0	170	\N
294	143	65	2	17385	\N	17385	\N	\N	10	1	2	f	0	143	\N
295	173	65	2	13973	\N	13973	\N	\N	11	1	2	f	0	173	\N
296	42	65	2	13230	\N	13230	\N	\N	12	1	2	f	0	42	\N
297	155	65	2	7636	\N	7636	\N	\N	13	1	2	f	0	155	\N
298	55	65	2	3016	\N	3016	\N	\N	14	1	2	f	0	55	\N
299	31	65	2	2027	\N	2027	\N	\N	15	1	2	f	0	31	\N
300	152	65	2	1590	\N	1590	\N	\N	16	1	2	f	0	152	\N
301	105	65	2	822	\N	822	\N	\N	17	1	2	f	0	105	\N
302	122	65	2	503	\N	503	\N	\N	18	1	2	f	0	122	\N
303	177	65	2	302	\N	302	\N	\N	19	1	2	f	0	177	\N
304	159	65	2	141	\N	141	\N	\N	20	1	2	f	0	159	\N
305	120	65	2	35	\N	35	\N	\N	21	1	2	f	0	120	\N
306	117	65	2	14	\N	14	\N	\N	22	1	2	f	0	117	\N
307	18	65	1	559496	\N	559496	\N	\N	1	1	2	f	\N	18	\N
308	50	65	1	502416	\N	502416	\N	\N	2	1	2	f	\N	50	\N
309	141	65	1	163787	\N	163787	\N	\N	3	1	2	f	\N	141	\N
310	71	65	1	130057	\N	130057	\N	\N	4	1	2	f	\N	71	\N
311	115	65	1	84168	\N	84168	\N	\N	5	1	2	f	\N	115	\N
312	169	65	1	46119	\N	46119	\N	\N	6	1	2	f	\N	169	\N
313	85	65	1	36871	\N	36871	\N	\N	7	1	2	f	\N	85	\N
314	53	65	1	27980	\N	27980	\N	\N	8	1	2	f	\N	53	\N
315	170	65	1	22096	\N	22096	\N	\N	9	1	2	f	\N	170	\N
316	143	65	1	17385	\N	17385	\N	\N	10	1	2	f	\N	143	\N
317	173	65	1	13973	\N	13973	\N	\N	11	1	2	f	\N	173	\N
318	42	65	1	13230	\N	13230	\N	\N	12	1	2	f	\N	42	\N
319	155	65	1	7636	\N	7636	\N	\N	13	1	2	f	\N	155	\N
320	55	65	1	3016	\N	3016	\N	\N	14	1	2	f	\N	55	\N
321	31	65	1	2027	\N	2027	\N	\N	15	1	2	f	\N	31	\N
322	152	65	1	1590	\N	1590	\N	\N	16	1	2	f	\N	152	\N
323	105	65	1	822	\N	822	\N	\N	17	1	2	f	\N	105	\N
324	122	65	1	503	\N	503	\N	\N	18	1	2	f	\N	122	\N
325	177	65	1	302	\N	302	\N	\N	19	1	2	f	\N	177	\N
326	159	65	1	141	\N	141	\N	\N	20	1	2	f	\N	159	\N
327	120	65	1	35	\N	35	\N	\N	21	1	2	f	\N	120	\N
328	117	65	1	14	\N	14	\N	\N	22	1	2	f	\N	117	\N
330	77	67	2	8855603	\N	0	\N	\N	1	1	2	f	8855603	\N	\N
331	26	67	2	399480	\N	0	\N	\N	2	1	2	f	399480	\N	\N
333	22	70	2	338882	\N	0	\N	\N	1	1	2	f	338882	\N	\N
334	141	70	2	144568	\N	0	\N	\N	2	1	2	f	144568	\N	\N
335	96	70	2	52163	\N	0	\N	\N	3	1	2	f	52163	\N	\N
336	166	70	2	49802	\N	0	\N	\N	4	1	2	f	49802	\N	\N
337	18	70	2	45624	\N	0	\N	\N	5	1	2	f	45624	\N	\N
338	167	70	2	42576	\N	0	\N	\N	6	1	2	f	42576	\N	\N
339	84	70	2	39487	\N	0	\N	\N	7	1	2	f	39487	\N	\N
340	50	70	2	27993	\N	0	\N	\N	8	1	2	f	27993	\N	\N
341	27	70	2	15946	\N	0	\N	\N	9	1	2	f	15946	\N	\N
342	71	70	2	13463	\N	0	\N	\N	10	1	2	f	13463	\N	\N
343	115	70	2	11271	\N	0	\N	\N	11	1	2	f	11271	\N	\N
344	53	70	2	7120	\N	0	\N	\N	12	1	2	f	7120	\N	\N
345	81	70	2	6322	\N	0	\N	\N	13	1	2	f	6322	\N	\N
346	131	70	2	5385	\N	0	\N	\N	14	1	2	f	5385	\N	\N
347	55	70	2	5313	\N	0	\N	\N	15	1	2	f	5313	\N	\N
348	85	70	2	4909	\N	0	\N	\N	16	1	2	f	4909	\N	\N
349	169	70	2	4039	\N	0	\N	\N	17	1	2	f	4039	\N	\N
350	57	70	2	2690	\N	0	\N	\N	18	1	2	f	2690	\N	\N
351	69	70	2	2637	\N	0	\N	\N	19	1	2	f	2637	\N	\N
352	100	70	2	2634	\N	0	\N	\N	20	1	2	f	2634	\N	\N
353	170	70	2	2560	\N	0	\N	\N	21	1	2	f	2560	\N	\N
354	143	70	2	2010	\N	0	\N	\N	22	1	2	f	2010	\N	\N
355	42	70	2	1841	\N	0	\N	\N	23	1	2	f	1841	\N	\N
356	153	70	2	1756	\N	0	\N	\N	24	1	2	f	1756	\N	\N
357	173	70	2	1453	\N	0	\N	\N	25	1	2	f	1453	\N	\N
358	155	70	2	1389	\N	0	\N	\N	26	1	2	f	1389	\N	\N
359	152	70	2	1192	\N	0	\N	\N	27	1	2	f	1192	\N	\N
360	139	70	2	969	\N	0	\N	\N	28	1	2	f	969	\N	\N
361	174	70	2	696	\N	0	\N	\N	29	1	2	f	696	\N	\N
362	31	70	2	540	\N	0	\N	\N	30	1	2	f	540	\N	\N
363	171	70	2	398	\N	0	\N	\N	31	1	2	f	398	\N	\N
364	32	70	2	391	\N	0	\N	\N	32	1	2	f	391	\N	\N
365	157	70	2	266	\N	0	\N	\N	33	1	2	f	266	\N	\N
366	105	70	2	193	\N	0	\N	\N	34	1	2	f	193	\N	\N
367	125	70	2	174	\N	0	\N	\N	35	1	2	f	174	\N	\N
368	122	70	2	157	\N	0	\N	\N	36	1	2	f	157	\N	\N
369	63	70	2	142	\N	0	\N	\N	37	1	2	f	142	\N	\N
370	86	70	2	136	\N	0	\N	\N	38	1	2	f	136	\N	\N
371	177	70	2	87	\N	0	\N	\N	39	1	2	f	87	\N	\N
372	156	70	2	56	\N	0	\N	\N	40	1	2	f	56	\N	\N
373	159	70	2	51	\N	0	\N	\N	41	1	2	f	51	\N	\N
374	34	70	2	45	\N	0	\N	\N	42	1	2	f	45	\N	\N
375	20	70	2	18	\N	0	\N	\N	43	1	2	f	18	\N	\N
376	59	70	2	18	\N	0	\N	\N	44	1	2	f	18	\N	\N
377	120	70	2	13	\N	0	\N	\N	45	1	2	f	13	\N	\N
378	123	70	2	12	\N	0	\N	\N	46	1	2	f	12	\N	\N
379	117	70	2	11	\N	0	\N	\N	47	1	2	f	11	\N	\N
380	142	70	2	10	\N	0	\N	\N	48	1	2	f	10	\N	\N
381	89	70	2	7	\N	0	\N	\N	49	1	2	f	7	\N	\N
382	144	70	2	6	\N	0	\N	\N	50	1	2	f	6	\N	\N
383	88	70	2	2	\N	0	\N	\N	51	1	2	f	2	\N	\N
384	121	70	2	1	\N	0	\N	\N	52	1	2	f	1	\N	\N
385	118	70	2	391	\N	0	\N	\N	0	1	2	f	391	\N	\N
386	119	70	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
387	58	70	2	170	\N	0	\N	\N	0	1	2	f	170	\N	\N
388	75	70	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
389	103	70	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
390	45	70	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
391	175	70	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
392	91	70	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
393	158	70	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
394	176	70	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
395	33	70	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
396	76	70	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
397	160	70	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
398	108	71	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
399	8	72	2	139183	\N	139183	\N	\N	1	1	2	f	0	37	\N
400	37	72	1	139183	\N	139183	\N	\N	1	1	2	f	\N	8	\N
401	145	73	2	42388	\N	0	\N	\N	1	1	2	f	42388	\N	\N
402	95	73	2	20476	\N	0	\N	\N	2	1	2	f	20476	\N	\N
405	8	76	2	161948	\N	161948	\N	\N	1	1	2	f	0	80	\N
406	80	76	1	161948	\N	161948	\N	\N	1	1	2	f	\N	8	\N
407	8	77	2	1628	\N	1628	\N	\N	1	1	2	f	0	135	\N
408	135	77	1	1628	\N	1628	\N	\N	1	1	2	f	\N	8	\N
409	62	78	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
412	8	81	2	1	\N	1	\N	\N	1	1	2	f	0	61	\N
413	61	81	1	1	\N	1	\N	\N	1	1	2	f	\N	8	\N
414	65	82	2	20389	\N	20389	\N	\N	1	1	2	f	0	175	\N
415	175	82	1	20389	\N	20389	\N	\N	1	1	2	f	\N	65	\N
416	118	82	1	20389	\N	20389	\N	\N	0	1	2	f	\N	65	\N
417	32	82	1	20389	\N	20389	\N	\N	0	1	2	f	\N	65	\N
420	8	84	2	129846	\N	129846	\N	\N	1	1	2	f	0	109	\N
421	109	84	1	129846	\N	129846	\N	\N	1	1	2	f	\N	8	\N
425	4	88	2	20466403	\N	0	\N	\N	1	1	2	f	20466403	\N	\N
426	64	88	2	89586	\N	0	\N	\N	2	1	2	f	89586	\N	\N
427	162	88	2	84323	\N	0	\N	\N	3	1	2	f	84323	\N	\N
428	113	89	2	163019087	\N	163019087	\N	\N	1	1	2	f	0	\N	\N
429	65	89	2	31881582	\N	31881582	\N	\N	2	1	2	f	0	\N	\N
430	22	89	1	189262255	\N	189262255	\N	\N	1	1	2	f	\N	\N	\N
431	150	89	1	4841292	\N	4841292	\N	\N	2	1	2	f	\N	\N	\N
432	124	89	1	797122	\N	797122	\N	\N	3	1	2	f	\N	65	\N
433	101	89	1	3335227	\N	3335227	\N	\N	0	1	2	f	\N	\N	\N
434	95	90	2	20389	\N	20389	\N	\N	1	1	2	f	0	65	\N
435	65	90	1	20389	\N	20389	\N	\N	1	1	2	f	\N	95	\N
436	47	91	2	1578137	\N	0	\N	\N	1	1	2	f	1578137	\N	\N
437	4	93	2	20093379	\N	0	\N	\N	1	1	2	f	20093379	\N	\N
438	64	93	2	83249	\N	0	\N	\N	2	1	2	f	83249	\N	\N
439	168	94	2	1125	\N	1125	\N	\N	1	1	2	f	0	105	\N
440	105	94	1	1125	\N	1125	\N	\N	1	1	2	f	\N	168	\N
441	8	95	2	11996	\N	11996	\N	\N	1	1	2	f	0	9	\N
442	9	95	1	11996	\N	11996	\N	\N	1	1	2	f	\N	8	\N
445	130	98	2	121509	\N	0	\N	\N	1	1	2	f	121509	\N	\N
450	106	100	2	20395	\N	0	\N	\N	1	1	2	f	20395	\N	\N
451	4	101	2	91708	\N	91708	\N	\N	1	1	2	f	0	81	\N
452	8	101	2	41528	\N	41528	\N	\N	2	1	2	f	0	163	\N
453	168	101	2	11261	\N	11261	\N	\N	3	1	2	f	0	\N	\N
454	64	101	2	1	\N	1	\N	\N	4	1	2	f	0	81	\N
455	81	101	1	91709	\N	91709	\N	\N	1	1	2	f	\N	\N	\N
456	163	101	1	41528	\N	41528	\N	\N	2	1	2	f	\N	8	\N
457	18	101	1	8690	\N	8690	\N	\N	3	1	2	f	\N	168	\N
458	57	101	1	2571	\N	2571	\N	\N	4	1	2	f	\N	168	\N
460	8	103	2	170627	\N	170627	\N	\N	1	1	2	f	0	82	\N
461	82	103	1	170627	\N	170627	\N	\N	1	1	2	f	\N	8	\N
465	8	106	2	235824	\N	235824	\N	\N	1	1	2	f	0	\N	\N
466	73	106	2	127	\N	0	\N	\N	2	1	2	f	127	\N	\N
467	129	106	1	67380	\N	67380	\N	\N	1	1	2	f	\N	8	\N
468	66	106	1	53622	\N	53622	\N	\N	2	1	2	f	\N	8	\N
469	3	106	1	44624	\N	44624	\N	\N	3	1	2	f	\N	8	\N
470	54	106	1	32966	\N	32966	\N	\N	4	1	2	f	\N	8	\N
471	137	106	1	16460	\N	16460	\N	\N	5	1	2	f	\N	8	\N
472	94	106	1	7886	\N	7886	\N	\N	6	1	2	f	\N	8	\N
473	14	106	1	6795	\N	6795	\N	\N	7	1	2	f	\N	8	\N
474	68	106	1	4656	\N	4656	\N	\N	8	1	2	f	\N	8	\N
475	151	106	1	1435	\N	1435	\N	\N	9	1	2	f	\N	8	\N
476	8	107	2	707078	\N	707078	\N	\N	1	1	2	f	0	\N	\N
477	78	107	1	338501	\N	338501	\N	\N	1	1	2	f	\N	8	\N
478	80	107	1	161948	\N	161948	\N	\N	2	1	2	f	\N	8	\N
479	37	107	1	139183	\N	139183	\N	\N	3	1	2	f	\N	8	\N
480	128	107	1	39739	\N	39739	\N	\N	4	1	2	f	\N	8	\N
481	52	107	1	22714	\N	22714	\N	\N	5	1	2	f	\N	8	\N
482	114	107	1	4993	\N	4993	\N	\N	6	1	2	f	\N	8	\N
483	141	108	2	210904	\N	210904	\N	\N	1	1	2	f	0	\N	\N
484	18	108	2	112793	\N	112793	\N	\N	2	1	2	f	0	\N	\N
485	50	108	2	29186	\N	29186	\N	\N	3	1	2	f	0	\N	\N
486	81	108	2	20493	\N	20493	\N	\N	4	1	2	f	0	\N	\N
487	115	108	2	18874	\N	18874	\N	\N	5	1	2	f	0	\N	\N
488	71	108	2	13463	\N	13463	\N	\N	6	1	2	f	0	71	\N
489	53	108	2	13080	\N	13080	\N	\N	7	1	2	f	0	\N	\N
490	85	108	2	12489	\N	12489	\N	\N	8	1	2	f	0	\N	\N
491	152	108	2	7332	\N	7332	\N	\N	9	1	2	f	0	\N	\N
492	100	108	2	6854	\N	6854	\N	\N	10	1	2	f	0	\N	\N
493	170	108	2	6516	\N	6516	\N	\N	11	1	2	f	0	\N	\N
494	57	108	2	5734	\N	5734	\N	\N	12	1	2	f	0	\N	\N
495	55	108	2	5313	\N	5313	\N	\N	13	1	2	f	0	55	\N
496	169	108	2	4642	\N	4642	\N	\N	14	1	2	f	0	\N	\N
497	42	108	2	2393	\N	2393	\N	\N	15	1	2	f	0	\N	\N
498	143	108	2	2012	\N	2012	\N	\N	16	1	2	f	0	143	\N
499	173	108	2	2004	\N	2004	\N	\N	17	1	2	f	0	\N	\N
500	155	108	2	1414	\N	1414	\N	\N	18	1	2	f	0	\N	\N
501	174	108	2	1267	\N	1267	\N	\N	19	1	2	f	0	\N	\N
502	31	108	2	1082	\N	1082	\N	\N	20	1	2	f	0	\N	\N
503	139	108	2	969	\N	969	\N	\N	21	1	2	f	0	139	\N
504	105	108	2	308	\N	308	\N	\N	22	1	2	f	0	\N	\N
505	122	108	2	272	\N	272	\N	\N	23	1	2	f	0	\N	\N
506	34	108	2	111	\N	111	\N	\N	24	1	2	f	0	\N	\N
507	177	108	2	87	\N	87	\N	\N	25	1	2	f	0	177	\N
508	159	108	2	51	\N	51	\N	\N	26	1	2	f	0	159	\N
509	59	108	2	18	\N	18	\N	\N	27	1	2	f	0	59	\N
510	117	108	2	15	\N	15	\N	\N	28	1	2	f	0	\N	\N
511	120	108	2	13	\N	13	\N	\N	29	1	2	f	0	120	\N
512	123	108	2	12	\N	12	\N	\N	30	1	2	f	0	123	\N
513	142	108	2	10	\N	10	\N	\N	31	1	2	f	0	142	\N
514	89	108	2	7	\N	7	\N	\N	32	1	2	f	0	89	\N
515	88	108	2	2	\N	2	\N	\N	33	1	2	f	0	88	\N
516	121	108	2	1	\N	1	\N	\N	34	1	2	f	0	121	\N
517	141	108	1	210904	\N	210904	\N	\N	1	1	2	f	\N	\N	\N
518	18	108	1	112793	\N	112793	\N	\N	2	1	2	f	\N	\N	\N
519	50	108	1	29186	\N	29186	\N	\N	3	1	2	f	\N	\N	\N
520	81	108	1	20493	\N	20493	\N	\N	4	1	2	f	\N	\N	\N
521	115	108	1	18874	\N	18874	\N	\N	5	1	2	f	\N	\N	\N
522	71	108	1	13463	\N	13463	\N	\N	6	1	2	f	\N	71	\N
523	53	108	1	13080	\N	13080	\N	\N	7	1	2	f	\N	\N	\N
524	85	108	1	12489	\N	12489	\N	\N	8	1	2	f	\N	\N	\N
525	152	108	1	7332	\N	7332	\N	\N	9	1	2	f	\N	\N	\N
526	100	108	1	6854	\N	6854	\N	\N	10	1	2	f	\N	\N	\N
527	170	108	1	6516	\N	6516	\N	\N	11	1	2	f	\N	\N	\N
528	57	108	1	5734	\N	5734	\N	\N	12	1	2	f	\N	\N	\N
529	55	108	1	5313	\N	5313	\N	\N	13	1	2	f	\N	55	\N
530	169	108	1	4642	\N	4642	\N	\N	14	1	2	f	\N	\N	\N
531	42	108	1	2393	\N	2393	\N	\N	15	1	2	f	\N	\N	\N
532	143	108	1	2012	\N	2012	\N	\N	16	1	2	f	\N	143	\N
533	173	108	1	2004	\N	2004	\N	\N	17	1	2	f	\N	\N	\N
534	155	108	1	1414	\N	1414	\N	\N	18	1	2	f	\N	\N	\N
535	174	108	1	1267	\N	1267	\N	\N	19	1	2	f	\N	\N	\N
536	31	108	1	1082	\N	1082	\N	\N	20	1	2	f	\N	\N	\N
537	139	108	1	969	\N	969	\N	\N	21	1	2	f	\N	139	\N
538	105	108	1	308	\N	308	\N	\N	22	1	2	f	\N	\N	\N
539	122	108	1	272	\N	272	\N	\N	23	1	2	f	\N	\N	\N
540	34	108	1	111	\N	111	\N	\N	24	1	2	f	\N	\N	\N
541	177	108	1	87	\N	87	\N	\N	25	1	2	f	\N	177	\N
542	159	108	1	51	\N	51	\N	\N	26	1	2	f	\N	159	\N
543	59	108	1	18	\N	18	\N	\N	27	1	2	f	\N	59	\N
544	117	108	1	15	\N	15	\N	\N	28	1	2	f	\N	\N	\N
545	120	108	1	13	\N	13	\N	\N	29	1	2	f	\N	120	\N
546	123	108	1	12	\N	12	\N	\N	30	1	2	f	\N	123	\N
547	142	108	1	10	\N	10	\N	\N	31	1	2	f	\N	142	\N
548	89	108	1	7	\N	7	\N	\N	32	1	2	f	\N	89	\N
549	88	108	1	2	\N	2	\N	\N	33	1	2	f	\N	88	\N
550	121	108	1	1	\N	1	\N	\N	34	1	2	f	\N	121	\N
551	113	109	2	5159359	\N	0	\N	\N	1	1	2	f	5159359	\N	\N
557	8	114	2	518692	\N	518692	\N	\N	1	1	2	f	0	5	\N
558	5	114	1	518692	\N	518692	\N	\N	1	1	2	f	\N	8	\N
559	150	115	2	4501738	\N	4501738	\N	\N	1	1	2	f	0	\N	\N
560	101	115	2	30702	\N	30702	\N	\N	0	1	2	f	0	\N	\N
561	146	115	1	4494600	\N	4494600	\N	\N	1	1	2	f	\N	150	\N
562	147	115	1	7138	\N	7138	\N	\N	2	1	2	f	\N	150	\N
563	46	116	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
564	8	117	2	53622	\N	53622	\N	\N	1	1	2	f	0	66	\N
565	66	117	1	53622	\N	53622	\N	\N	1	1	2	f	\N	8	\N
566	8	118	2	1578137	\N	1578137	\N	\N	1	1	2	f	0	47	\N
567	47	118	1	1578137	\N	1578137	\N	\N	1	1	2	f	\N	8	\N
568	8	119	2	9449789	\N	9449789	\N	\N	1	1	2	f	0	\N	\N
569	77	119	1	8855603	\N	8855603	\N	\N	1	1	2	f	\N	8	\N
570	26	119	1	399480	\N	399480	\N	\N	2	1	2	f	\N	8	\N
571	130	119	1	132986	\N	132986	\N	\N	3	1	2	f	\N	8	\N
572	49	119	1	42611	\N	42611	\N	\N	4	1	2	f	\N	8	\N
573	149	119	1	19109	\N	19109	\N	\N	5	1	2	f	\N	8	\N
574	145	120	2	42388	\N	0	\N	\N	1	1	2	f	42388	\N	\N
575	125	121	2	3	\N	3	\N	\N	1	1	2	f	0	125	\N
576	125	121	1	3	\N	3	\N	\N	1	1	2	f	\N	125	\N
578	150	123	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
579	101	123	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
580	8	124	2	262697	\N	262697	\N	\N	1	1	2	f	0	2	\N
581	2	124	1	262697	\N	262697	\N	\N	1	1	2	f	\N	8	\N
582	8	125	2	1388	\N	1388	\N	\N	1	1	2	f	0	138	\N
583	138	125	1	1388	\N	1388	\N	\N	1	1	2	f	\N	8	\N
584	8	126	2	540276	\N	540276	\N	\N	1	1	2	f	0	2	\N
585	2	126	1	540276	\N	540276	\N	\N	1	1	2	f	\N	8	\N
586	8	127	2	4993	\N	4993	\N	\N	1	1	2	f	0	114	\N
587	114	127	1	4993	\N	4993	\N	\N	1	1	2	f	\N	8	\N
590	113	129	2	23945784	\N	23945784	\N	\N	1	1	2	f	0	45	\N
591	45	129	1	23945784	\N	23945784	\N	\N	1	1	2	f	\N	113	\N
592	118	129	1	23945784	\N	23945784	\N	\N	0	1	2	f	\N	113	\N
593	32	129	1	23945784	\N	23945784	\N	\N	0	1	2	f	\N	113	\N
594	8	130	2	49375	\N	49375	\N	\N	1	1	2	f	0	12	\N
595	12	130	1	49375	\N	49375	\N	\N	1	1	2	f	\N	8	\N
598	65	133	2	20389	\N	20389	\N	\N	1	1	2	f	0	\N	\N
600	2	135	2	14697941	\N	0	\N	\N	1	1	2	f	14697941	\N	\N
601	5	135	2	518692	\N	0	\N	\N	2	1	2	f	518692	\N	\N
602	78	135	2	324056	\N	0	\N	\N	3	1	2	f	324056	\N	\N
603	92	135	2	320598	\N	0	\N	\N	4	1	2	f	320598	\N	\N
604	48	135	2	175379	\N	0	\N	\N	5	1	2	f	175379	\N	\N
605	80	135	2	161776	\N	0	\N	\N	6	1	2	f	161776	\N	\N
606	37	135	2	139183	\N	0	\N	\N	7	1	2	f	139183	\N	\N
607	130	135	2	132986	\N	0	\N	\N	8	1	2	f	132986	\N	\N
608	109	135	2	129846	\N	0	\N	\N	9	1	2	f	129846	\N	\N
609	6	135	2	122332	\N	0	\N	\N	10	1	2	f	122332	\N	\N
610	162	135	2	84323	\N	0	\N	\N	11	1	2	f	84323	\N	\N
611	17	135	2	76998	\N	0	\N	\N	12	1	2	f	76998	\N	\N
612	4	135	2	72568	\N	0	\N	\N	13	1	2	f	72568	\N	\N
613	129	135	2	67380	\N	0	\N	\N	14	1	2	f	67380	\N	\N
614	64	135	2	64111	\N	0	\N	\N	15	1	2	f	64111	\N	\N
615	111	135	2	54564	\N	0	\N	\N	16	1	2	f	54564	\N	\N
616	66	135	2	53622	\N	0	\N	\N	17	1	2	f	53622	\N	\N
617	12	135	2	49375	\N	0	\N	\N	18	1	2	f	49375	\N	\N
618	164	135	2	47581	\N	0	\N	\N	19	1	2	f	47581	\N	\N
619	3	135	2	44624	\N	0	\N	\N	20	1	2	f	44624	\N	\N
620	7	135	2	44610	\N	0	\N	\N	21	1	2	f	44610	\N	\N
621	163	135	2	41528	\N	0	\N	\N	22	1	2	f	41528	\N	\N
622	128	135	2	39739	\N	0	\N	\N	23	1	2	f	39739	\N	\N
623	97	135	2	38631	\N	0	\N	\N	24	1	2	f	38631	\N	\N
624	133	135	2	33504	\N	0	\N	\N	25	1	2	f	33504	\N	\N
625	38	135	2	33105	\N	0	\N	\N	26	1	2	f	33105	\N	\N
626	54	135	2	32934	\N	0	\N	\N	27	1	2	f	32934	\N	\N
627	110	135	2	31753	\N	0	\N	\N	28	1	2	f	31753	\N	\N
628	93	135	2	23226	\N	0	\N	\N	29	1	2	f	23226	\N	\N
629	52	135	2	22714	\N	0	\N	\N	30	1	2	f	22714	\N	\N
630	149	135	2	19109	\N	0	\N	\N	31	1	2	f	19109	\N	\N
631	137	135	2	16459	\N	0	\N	\N	32	1	2	f	16459	\N	\N
632	79	135	2	14585	\N	0	\N	\N	33	1	2	f	14585	\N	\N
633	83	135	2	12852	\N	0	\N	\N	34	1	2	f	12852	\N	\N
634	9	135	2	11996	\N	0	\N	\N	35	1	2	f	11996	\N	\N
635	134	135	2	9179	\N	0	\N	\N	36	1	2	f	9179	\N	\N
636	94	135	2	7886	\N	0	\N	\N	37	1	2	f	7886	\N	\N
637	10	135	2	6175	\N	0	\N	\N	38	1	2	f	6175	\N	\N
638	51	135	2	5476	\N	0	\N	\N	39	1	2	f	5476	\N	\N
639	114	135	2	4993	\N	0	\N	\N	40	1	2	f	4993	\N	\N
640	112	135	2	4837	\N	0	\N	\N	41	1	2	f	4837	\N	\N
641	68	135	2	4656	\N	0	\N	\N	42	1	2	f	4656	\N	\N
642	70	135	2	4516	\N	0	\N	\N	43	1	2	f	4516	\N	\N
643	116	135	2	4181	\N	0	\N	\N	44	1	2	f	4181	\N	\N
644	67	135	2	3963	\N	0	\N	\N	45	1	2	f	3963	\N	\N
645	13	135	2	3510	\N	0	\N	\N	46	1	2	f	3510	\N	\N
646	98	135	2	3265	\N	0	\N	\N	47	1	2	f	3265	\N	\N
647	30	135	2	2152	\N	0	\N	\N	48	1	2	f	2152	\N	\N
648	40	135	2	2122	\N	0	\N	\N	49	1	2	f	2122	\N	\N
649	11	135	2	2073	\N	0	\N	\N	50	1	2	f	2073	\N	\N
650	154	135	2	1920	\N	0	\N	\N	51	1	2	f	1920	\N	\N
651	135	135	2	1628	\N	0	\N	\N	52	1	2	f	1628	\N	\N
652	15	135	2	1598	\N	0	\N	\N	53	1	2	f	1598	\N	\N
653	56	135	2	1374	\N	0	\N	\N	54	1	2	f	1374	\N	\N
654	151	135	2	1283	\N	0	\N	\N	55	1	2	f	1283	\N	\N
655	16	135	2	948	\N	0	\N	\N	56	1	2	f	948	\N	\N
656	172	135	2	881	\N	0	\N	\N	57	1	2	f	881	\N	\N
657	138	135	2	706	\N	0	\N	\N	58	1	2	f	706	\N	\N
658	44	135	2	652	\N	0	\N	\N	59	1	2	f	652	\N	\N
659	72	135	2	574	\N	0	\N	\N	60	1	2	f	574	\N	\N
660	102	135	2	430	\N	0	\N	\N	61	1	2	f	430	\N	\N
661	32	135	2	384	\N	0	\N	\N	62	1	2	f	384	\N	\N
662	87	135	2	225	\N	0	\N	\N	63	1	2	f	225	\N	\N
663	125	135	2	172	\N	0	\N	\N	64	1	2	f	172	\N	\N
664	86	135	2	136	\N	0	\N	\N	65	1	2	f	136	\N	\N
665	63	135	2	119	\N	0	\N	\N	66	1	2	f	119	\N	\N
666	60	135	2	114	\N	0	\N	\N	67	1	2	f	114	\N	\N
667	41	135	2	90	\N	0	\N	\N	68	1	2	f	90	\N	\N
668	156	135	2	56	\N	0	\N	\N	69	1	2	f	56	\N	\N
669	99	135	2	53	\N	0	\N	\N	70	1	2	f	53	\N	\N
670	136	135	2	28	\N	0	\N	\N	71	1	2	f	28	\N	\N
671	43	135	2	14	\N	0	\N	\N	72	1	2	f	14	\N	\N
672	19	135	2	11	\N	0	\N	\N	73	1	2	f	11	\N	\N
673	21	135	2	4	\N	0	\N	\N	74	1	2	f	4	\N	\N
674	104	135	2	3	\N	0	\N	\N	75	1	2	f	3	\N	\N
675	108	135	2	1	\N	0	\N	\N	76	1	2	f	1	\N	\N
676	118	135	2	384	\N	0	\N	\N	0	1	2	f	384	\N	\N
677	119	135	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
678	58	135	2	170	\N	0	\N	\N	0	1	2	f	170	\N	\N
679	45	135	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
680	175	135	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
681	176	135	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
682	103	135	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
683	33	135	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
684	160	135	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
686	8	137	2	39487	\N	39487	\N	\N	1	1	2	f	0	84	\N
687	84	137	1	39487	\N	39487	\N	\N	1	1	2	f	\N	8	\N
688	150	138	2	563133	\N	0	\N	\N	1	1	2	f	563133	\N	\N
689	101	138	2	1883	\N	0	\N	\N	0	1	2	f	1883	\N	\N
691	63	140	2	140	\N	140	\N	\N	1	1	2	f	0	\N	\N
692	86	140	2	136	\N	136	\N	\N	2	1	2	f	0	125	\N
693	156	140	2	56	\N	56	\N	\N	3	1	2	f	0	125	\N
694	91	140	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
695	33	140	2	1	\N	1	\N	\N	0	1	2	f	0	125	\N
696	160	140	2	1	\N	1	\N	\N	0	1	2	f	0	125	\N
697	125	140	1	196	\N	196	\N	\N	1	1	2	f	\N	\N	\N
698	75	140	1	18	\N	18	\N	\N	0	1	2	f	\N	63	\N
699	95	141	2	20476	\N	0	\N	\N	1	1	2	f	20476	\N	\N
700	168	142	2	13531	\N	13531	\N	\N	1	1	2	f	0	\N	\N
705	150	146	2	76	\N	76	\N	\N	1	1	2	f	0	146	\N
706	101	146	2	4	\N	4	\N	\N	0	1	2	f	0	146	\N
707	146	146	1	76	\N	76	\N	\N	1	1	2	f	\N	150	\N
708	8	147	2	652	\N	652	\N	\N	1	1	2	f	0	44	\N
709	44	147	1	652	\N	652	\N	\N	1	1	2	f	\N	8	\N
710	84	148	2	2152	\N	2152	\N	\N	1	1	2	f	0	30	\N
711	30	148	1	2152	\N	2152	\N	\N	1	1	2	f	\N	84	\N
712	8	149	2	4549214	\N	4549214	\N	\N	1	1	2	f	0	2	\N
713	2	149	1	4549214	\N	4549214	\N	\N	1	1	2	f	\N	8	\N
714	106	150	2	20395	\N	0	\N	\N	1	1	2	f	20395	\N	\N
715	95	151	2	20476	\N	0	\N	\N	1	1	2	f	20476	\N	\N
717	8	153	2	41632	\N	41632	\N	\N	1	1	2	f	0	\N	\N
718	163	153	1	41528	\N	41528	\N	\N	1	1	2	f	\N	8	\N
719	41	153	1	90	\N	90	\N	\N	2	1	2	f	\N	8	\N
720	43	153	1	14	\N	14	\N	\N	3	1	2	f	\N	8	\N
721	8	154	2	19109	\N	19109	\N	\N	1	1	2	f	0	149	\N
722	149	154	1	19109	\N	19109	\N	\N	1	1	2	f	\N	8	\N
726	113	157	2	16808370	\N	0	\N	\N	1	1	2	f	16808370	\N	\N
727	4	158	2	20466403	\N	0	\N	\N	1	1	2	f	20466403	\N	\N
728	64	158	2	89586	\N	0	\N	\N	2	1	2	f	89586	\N	\N
729	162	158	2	84323	\N	0	\N	\N	3	1	2	f	84323	\N	\N
730	168	159	2	6185	\N	6185	\N	\N	1	1	2	f	0	141	\N
731	113	159	2	704	\N	0	\N	\N	2	1	2	f	704	\N	\N
732	141	159	1	6185	\N	6185	\N	\N	1	1	2	f	\N	168	\N
734	8	162	2	20466403	\N	20466403	\N	\N	1	1	2	f	0	4	\N
735	4	162	1	20466403	\N	20466403	\N	\N	1	1	2	f	\N	8	\N
738	8	165	2	47581	\N	47581	\N	\N	1	1	2	f	0	164	\N
739	164	165	1	47581	\N	47581	\N	\N	1	1	2	f	\N	8	\N
740	8	166	2	72684	\N	72684	\N	\N	1	1	2	f	0	\N	\N
741	97	166	1	38631	\N	38631	\N	\N	1	1	2	f	\N	8	\N
742	38	166	1	33105	\N	33105	\N	\N	2	1	2	f	\N	8	\N
743	16	166	1	948	\N	948	\N	\N	3	1	2	f	\N	8	\N
744	8	167	2	4738	\N	4738	\N	\N	1	1	2	f	0	132	\N
745	132	167	1	4738	\N	4738	\N	\N	1	1	2	f	\N	8	\N
746	8	168	2	312501	\N	312501	\N	\N	1	1	2	f	0	\N	\N
747	48	168	1	175584	\N	175584	\N	\N	1	1	2	f	\N	8	\N
748	6	168	1	122332	\N	122332	\N	\N	2	1	2	f	\N	8	\N
749	79	168	1	14585	\N	14585	\N	\N	3	1	2	f	\N	8	\N
752	8	170	2	42388	\N	42388	\N	\N	1	1	2	f	0	145	\N
753	145	170	1	42388	\N	42388	\N	\N	1	1	2	f	\N	8	\N
754	65	171	2	14453	\N	14453	\N	\N	1	1	2	f	0	73	\N
755	73	171	1	14453	\N	14453	\N	\N	1	1	2	f	\N	65	\N
756	32	172	2	391	\N	391	\N	\N	1	1	2	f	0	108	\N
757	125	172	2	172	\N	172	\N	\N	2	1	2	f	0	108	\N
758	86	172	2	136	\N	136	\N	\N	3	1	2	f	0	108	\N
759	63	172	2	119	\N	119	\N	\N	4	1	2	f	0	108	\N
760	156	172	2	56	\N	56	\N	\N	5	1	2	f	0	108	\N
761	108	172	2	3	\N	3	\N	\N	6	1	2	f	0	\N	\N
762	118	172	2	391	\N	391	\N	\N	0	1	2	f	0	108	\N
763	119	172	2	199	\N	199	\N	\N	0	1	2	f	0	108	\N
764	58	172	2	170	\N	170	\N	\N	0	1	2	f	0	108	\N
765	103	172	2	6	\N	6	\N	\N	0	1	2	f	0	108	\N
766	45	172	2	5	\N	5	\N	\N	0	1	2	f	0	108	\N
767	175	172	2	5	\N	5	\N	\N	0	1	2	f	0	108	\N
768	158	172	2	3	\N	3	\N	\N	0	1	2	f	0	108	\N
769	176	172	2	3	\N	3	\N	\N	0	1	2	f	0	108	\N
770	33	172	2	1	\N	1	\N	\N	0	1	2	f	0	108	\N
771	160	172	2	1	\N	1	\N	\N	0	1	2	f	0	108	\N
772	108	172	1	757	\N	757	\N	\N	1	1	2	f	\N	\N	\N
774	113	174	2	73897473	\N	0	\N	\N	1	1	2	f	73897473	\N	\N
775	8	175	2	67875	\N	67875	\N	\N	1	1	2	f	0	\N	\N
776	111	175	1	54564	\N	54564	\N	\N	1	1	2	f	\N	8	\N
777	51	175	1	7167	\N	7167	\N	\N	2	1	2	f	\N	8	\N
778	70	175	1	4516	\N	4516	\N	\N	3	1	2	f	\N	8	\N
779	135	175	1	1628	\N	1628	\N	\N	4	1	2	f	\N	8	\N
780	145	176	2	42388	\N	0	\N	\N	1	1	2	f	42388	\N	\N
781	8	177	2	3963	\N	3963	\N	\N	1	1	2	f	0	67	\N
782	67	177	1	3963	\N	3963	\N	\N	1	1	2	f	\N	8	\N
785	125	180	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
788	8	183	2	35060	\N	35060	\N	\N	1	1	2	f	0	56	\N
789	56	183	1	35060	\N	35060	\N	\N	1	1	2	f	\N	8	\N
790	113	184	2	965891	\N	965891	\N	\N	1	1	2	f	0	\N	\N
791	155	184	1	965887	\N	965887	\N	\N	1	1	2	f	\N	113	\N
792	8	185	2	399480	\N	399480	\N	\N	1	1	2	f	0	26	\N
793	26	185	1	399480	\N	399480	\N	\N	1	1	2	f	\N	8	\N
794	74	186	2	20395	\N	0	\N	\N	1	1	2	f	20395	\N	\N
795	106	186	2	20395	\N	0	\N	\N	2	1	2	f	20395	\N	\N
796	46	187	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
797	150	188	2	36	\N	0	\N	\N	1	1	2	f	36	\N	\N
798	101	188	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
799	8	189	2	320598	\N	320598	\N	\N	1	1	2	f	0	92	\N
800	92	189	1	320598	\N	320598	\N	\N	1	1	2	f	\N	8	\N
801	125	190	2	30	\N	30	\N	\N	1	1	2	f	0	\N	\N
802	46	191	2	1	\N	1	\N	\N	1	1	2	f	0	46	\N
803	46	191	1	1	\N	1	\N	\N	1	1	2	f	\N	46	\N
804	108	192	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
806	8	195	2	17282025	\N	17282025	\N	\N	1	1	2	f	0	2	\N
807	2	195	1	17282025	\N	17282025	\N	\N	1	1	2	f	\N	8	\N
808	8	196	2	122441	\N	122441	\N	\N	1	1	2	f	0	28	\N
809	28	196	1	122441	\N	122441	\N	\N	1	1	2	f	\N	8	\N
810	8	197	2	44624	\N	44624	\N	\N	1	1	2	f	0	3	\N
811	3	197	1	44624	\N	44624	\N	\N	1	1	2	f	\N	8	\N
812	8	198	2	326038	\N	326038	\N	\N	1	1	2	f	0	2	\N
813	2	198	1	326038	\N	326038	\N	\N	1	1	2	f	\N	8	\N
814	8	200	2	14	\N	14	\N	\N	1	1	2	f	0	43	\N
815	43	200	1	14	\N	14	\N	\N	1	1	2	f	\N	8	\N
816	8	201	2	16460	\N	16460	\N	\N	1	1	2	f	0	137	\N
817	137	201	1	16460	\N	16460	\N	\N	1	1	2	f	\N	8	\N
819	113	204	2	676515	\N	0	\N	\N	1	1	2	f	676515	\N	\N
820	8	205	2	6207	\N	6207	\N	\N	1	1	2	f	0	136	\N
821	136	205	1	6207	\N	6207	\N	\N	1	1	2	f	\N	8	\N
822	8	206	2	574	\N	574	\N	\N	1	1	2	f	0	72	\N
823	72	206	1	574	\N	574	\N	\N	1	1	2	f	\N	8	\N
824	8	208	2	31753	\N	31753	\N	\N	1	1	2	f	0	110	\N
825	110	208	1	31753	\N	31753	\N	\N	1	1	2	f	\N	8	\N
826	8	209	2	4181	\N	4181	\N	\N	1	1	2	f	0	116	\N
827	116	209	1	4181	\N	4181	\N	\N	1	1	2	f	\N	8	\N
830	8	212	2	54564	\N	54564	\N	\N	1	1	2	f	0	111	\N
831	111	212	1	54564	\N	54564	\N	\N	1	1	2	f	\N	8	\N
832	8	213	2	89586	\N	89586	\N	\N	1	1	2	f	0	64	\N
833	64	213	1	89586	\N	89586	\N	\N	1	1	2	f	\N	8	\N
834	8	214	2	1598	\N	1598	\N	\N	1	1	2	f	0	15	\N
835	15	214	1	1598	\N	1598	\N	\N	1	1	2	f	\N	8	\N
836	150	215	2	563097	\N	0	\N	\N	1	1	2	f	563097	\N	\N
837	101	215	2	1881	\N	0	\N	\N	0	1	2	f	1881	\N	\N
839	49	217	2	42611	\N	0	\N	\N	1	1	2	f	42611	\N	\N
840	8	218	2	4656	\N	4656	\N	\N	1	1	2	f	0	68	\N
841	68	218	1	4656	\N	4656	\N	\N	1	1	2	f	\N	8	\N
842	145	219	2	42388	\N	0	\N	\N	1	1	2	f	42388	\N	\N
843	175	220	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
844	32	220	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
845	118	220	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
846	62	221	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
849	46	223	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
852	8	226	2	11	\N	11	\N	\N	1	1	2	f	0	19	\N
853	19	226	1	11	\N	11	\N	\N	1	1	2	f	\N	8	\N
854	125	227	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
855	2	228	2	21831239	\N	0	\N	\N	1	1	2	f	21831239	\N	\N
856	4	228	2	20466403	\N	0	\N	\N	2	1	2	f	20466403	\N	\N
857	77	228	2	8855603	\N	0	\N	\N	3	1	2	f	8855603	\N	\N
858	47	228	2	1578137	\N	0	\N	\N	4	1	2	f	1578137	\N	\N
859	5	228	2	518692	\N	0	\N	\N	5	1	2	f	518692	\N	\N
860	26	228	2	399480	\N	0	\N	\N	6	1	2	f	399480	\N	\N
861	78	228	2	338501	\N	0	\N	\N	7	1	2	f	338501	\N	\N
862	92	228	2	320598	\N	0	\N	\N	8	1	2	f	320598	\N	\N
863	165	228	2	182078	\N	0	\N	\N	9	1	2	f	182078	\N	\N
864	48	228	2	175584	\N	0	\N	\N	10	1	2	f	175584	\N	\N
865	82	228	2	170627	\N	0	\N	\N	11	1	2	f	170627	\N	\N
866	80	228	2	161948	\N	0	\N	\N	12	1	2	f	161948	\N	\N
867	37	228	2	139183	\N	0	\N	\N	13	1	2	f	139183	\N	\N
868	130	228	2	132986	\N	0	\N	\N	14	1	2	f	132986	\N	\N
869	109	228	2	129846	\N	0	\N	\N	15	1	2	f	129846	\N	\N
870	28	228	2	122441	\N	0	\N	\N	16	1	2	f	122441	\N	\N
871	6	228	2	122332	\N	0	\N	\N	17	1	2	f	122332	\N	\N
872	64	228	2	89586	\N	0	\N	\N	18	1	2	f	89586	\N	\N
873	162	228	2	84323	\N	0	\N	\N	19	1	2	f	84323	\N	\N
874	17	228	2	76998	\N	0	\N	\N	20	1	2	f	76998	\N	\N
875	129	228	2	67380	\N	0	\N	\N	21	1	2	f	67380	\N	\N
876	111	228	2	54564	\N	0	\N	\N	22	1	2	f	54564	\N	\N
877	66	228	2	53622	\N	0	\N	\N	23	1	2	f	53622	\N	\N
878	12	228	2	49375	\N	0	\N	\N	24	1	2	f	49375	\N	\N
879	164	228	2	47581	\N	0	\N	\N	25	1	2	f	47581	\N	\N
880	3	228	2	44624	\N	0	\N	\N	26	1	2	f	44624	\N	\N
881	7	228	2	44610	\N	0	\N	\N	27	1	2	f	44610	\N	\N
882	39	228	2	44006	\N	0	\N	\N	28	1	2	f	44006	\N	\N
883	49	228	2	42611	\N	0	\N	\N	29	1	2	f	42611	\N	\N
884	163	228	2	41528	\N	0	\N	\N	30	1	2	f	41528	\N	\N
885	128	228	2	39739	\N	0	\N	\N	31	1	2	f	39739	\N	\N
886	97	228	2	38631	\N	0	\N	\N	32	1	2	f	38631	\N	\N
887	56	228	2	35060	\N	0	\N	\N	33	1	2	f	35060	\N	\N
888	133	228	2	33504	\N	0	\N	\N	34	1	2	f	33504	\N	\N
889	38	228	2	33105	\N	0	\N	\N	35	1	2	f	33105	\N	\N
890	54	228	2	32966	\N	0	\N	\N	36	1	2	f	32966	\N	\N
891	110	228	2	31753	\N	0	\N	\N	37	1	2	f	31753	\N	\N
892	93	228	2	23226	\N	0	\N	\N	38	1	2	f	23226	\N	\N
893	52	228	2	22714	\N	0	\N	\N	39	1	2	f	22714	\N	\N
894	149	228	2	19109	\N	0	\N	\N	40	1	2	f	19109	\N	\N
895	137	228	2	16460	\N	0	\N	\N	41	1	2	f	16460	\N	\N
896	79	228	2	14585	\N	0	\N	\N	42	1	2	f	14585	\N	\N
897	83	228	2	12852	\N	0	\N	\N	43	1	2	f	12852	\N	\N
898	9	228	2	11996	\N	0	\N	\N	44	1	2	f	11996	\N	\N
899	94	228	2	7886	\N	0	\N	\N	45	1	2	f	7886	\N	\N
900	51	228	2	7167	\N	0	\N	\N	46	1	2	f	7167	\N	\N
901	14	228	2	6795	\N	0	\N	\N	47	1	2	f	6795	\N	\N
902	136	228	2	6207	\N	0	\N	\N	48	1	2	f	6207	\N	\N
903	10	228	2	6175	\N	0	\N	\N	49	1	2	f	6175	\N	\N
904	114	228	2	4993	\N	0	\N	\N	50	1	2	f	4993	\N	\N
905	112	228	2	4837	\N	0	\N	\N	51	1	2	f	4837	\N	\N
906	132	228	2	4738	\N	0	\N	\N	52	1	2	f	4738	\N	\N
907	68	228	2	4656	\N	0	\N	\N	53	1	2	f	4656	\N	\N
908	70	228	2	4516	\N	0	\N	\N	54	1	2	f	4516	\N	\N
909	116	228	2	4181	\N	0	\N	\N	55	1	2	f	4181	\N	\N
910	67	228	2	3963	\N	0	\N	\N	56	1	2	f	3963	\N	\N
911	98	228	2	3265	\N	0	\N	\N	57	1	2	f	3265	\N	\N
912	134	228	2	2401	\N	0	\N	\N	58	1	2	f	2401	\N	\N
913	30	228	2	2152	\N	0	\N	\N	59	1	2	f	2152	\N	\N
914	40	228	2	2122	\N	0	\N	\N	60	1	2	f	2122	\N	\N
915	11	228	2	2073	\N	0	\N	\N	61	1	2	f	2073	\N	\N
916	154	228	2	1920	\N	0	\N	\N	62	1	2	f	1920	\N	\N
917	135	228	2	1628	\N	0	\N	\N	63	1	2	f	1628	\N	\N
918	15	228	2	1598	\N	0	\N	\N	64	1	2	f	1598	\N	\N
919	151	228	2	1435	\N	0	\N	\N	65	1	2	f	1435	\N	\N
920	138	228	2	1388	\N	0	\N	\N	66	1	2	f	1388	\N	\N
921	13	228	2	987	\N	0	\N	\N	67	1	2	f	987	\N	\N
922	16	228	2	948	\N	0	\N	\N	68	1	2	f	948	\N	\N
923	172	228	2	881	\N	0	\N	\N	69	1	2	f	881	\N	\N
924	44	228	2	652	\N	0	\N	\N	70	1	2	f	652	\N	\N
925	72	228	2	574	\N	0	\N	\N	71	1	2	f	574	\N	\N
926	102	228	2	430	\N	0	\N	\N	72	1	2	f	430	\N	\N
927	140	228	2	376	\N	0	\N	\N	73	1	2	f	376	\N	\N
928	29	228	2	323	\N	0	\N	\N	74	1	2	f	323	\N	\N
929	87	228	2	225	\N	0	\N	\N	75	1	2	f	225	\N	\N
930	60	228	2	114	\N	0	\N	\N	76	1	2	f	114	\N	\N
931	41	228	2	90	\N	0	\N	\N	77	1	2	f	90	\N	\N
932	99	228	2	53	\N	0	\N	\N	78	1	2	f	53	\N	\N
933	43	228	2	14	\N	0	\N	\N	79	1	2	f	14	\N	\N
934	19	228	2	11	\N	0	\N	\N	80	1	2	f	11	\N	\N
935	21	228	2	4	\N	0	\N	\N	81	1	2	f	4	\N	\N
936	104	228	2	3	\N	0	\N	\N	82	1	2	f	3	\N	\N
937	61	228	2	1	\N	0	\N	\N	83	1	2	f	1	\N	\N
938	8	229	2	881	\N	881	\N	\N	1	1	2	f	0	172	\N
939	172	229	1	881	\N	881	\N	\N	1	1	2	f	\N	8	\N
940	150	230	2	1042717	\N	1042717	\N	\N	1	1	2	f	0	22	\N
941	101	230	2	3657	\N	3657	\N	\N	0	1	2	f	0	22	\N
942	22	230	1	1042717	\N	1042717	\N	\N	1	1	2	f	\N	150	\N
943	113	231	2	73897474	\N	73897474	\N	\N	1	1	2	f	0	143	\N
944	143	231	1	73897474	\N	73897474	\N	\N	1	1	2	f	\N	113	\N
947	8	234	2	53	\N	53	\N	\N	1	1	2	f	0	99	\N
948	99	234	1	53	\N	53	\N	\N	1	1	2	f	\N	8	\N
949	8	235	2	1743154	\N	1743154	\N	\N	1	1	2	f	0	\N	\N
950	47	235	1	1578137	\N	1578137	\N	\N	1	1	2	f	\N	8	\N
951	28	235	1	122441	\N	122441	\N	\N	2	1	2	f	\N	8	\N
952	110	235	1	31753	\N	31753	\N	\N	3	1	2	f	\N	8	\N
953	132	235	1	4738	\N	4738	\N	\N	4	1	2	f	\N	8	\N
954	67	235	1	3963	\N	3963	\N	\N	5	1	2	f	\N	8	\N
955	40	235	1	2122	\N	2122	\N	\N	6	1	2	f	\N	8	\N
956	8	236	2	38631	\N	38631	\N	\N	1	1	2	f	0	97	\N
957	97	236	1	38631	\N	38631	\N	\N	1	1	2	f	\N	8	\N
958	2	237	2	10819190	\N	10819190	\N	\N	1	1	2	f	0	113	\N
959	78	237	2	1545	\N	1545	\N	\N	2	1	2	f	0	113	\N
960	80	237	2	1119	\N	1119	\N	\N	3	1	2	f	0	113	\N
961	48	237	2	594	\N	594	\N	\N	4	1	2	f	0	113	\N
962	47	237	2	218	\N	218	\N	\N	5	1	2	f	0	113	\N
963	30	237	2	114	\N	114	\N	\N	6	1	2	f	0	113	\N
964	93	237	2	51	\N	51	\N	\N	7	1	2	f	0	113	\N
965	92	237	2	3	\N	3	\N	\N	8	1	2	f	0	113	\N
966	113	237	1	10822834	\N	10822834	\N	\N	1	1	2	f	\N	\N	\N
967	8	238	2	44610	\N	44610	\N	\N	1	1	2	f	0	7	\N
968	7	238	1	44610	\N	44610	\N	\N	1	1	2	f	\N	8	\N
969	22	239	2	338885	\N	338885	\N	\N	1	1	2	f	0	\N	\N
970	65	239	2	20389	\N	20389	\N	\N	2	1	2	f	0	\N	\N
971	8	240	2	122332	\N	122332	\N	\N	1	1	2	f	0	6	\N
972	6	240	1	122332	\N	122332	\N	\N	1	1	2	f	\N	8	\N
973	113	241	2	5159359	\N	0	\N	\N	1	1	2	f	5159359	\N	\N
974	8	242	2	42611	\N	42611	\N	\N	1	1	2	f	0	49	\N
975	49	242	1	42611	\N	42611	\N	\N	1	1	2	f	\N	8	\N
979	8	246	2	33504	\N	33504	\N	\N	1	1	2	f	0	133	\N
980	133	246	1	33504	\N	33504	\N	\N	1	1	2	f	\N	8	\N
981	108	247	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
982	95	248	2	2639	\N	2639	\N	\N	1	1	2	f	0	69	\N
983	65	248	2	2637	\N	2637	\N	\N	2	1	2	f	0	69	\N
984	69	248	1	5276	\N	5276	\N	\N	1	1	2	f	\N	\N	\N
985	150	249	2	570055	\N	0	\N	\N	1	1	2	f	570055	\N	\N
986	101	249	2	1907	\N	0	\N	\N	0	1	2	f	1907	\N	\N
987	150	250	2	563133	\N	0	\N	\N	1	1	2	f	563133	\N	\N
988	101	250	2	1883	\N	0	\N	\N	0	1	2	f	1883	\N	\N
989	113	252	2	5159359	\N	0	\N	\N	1	1	2	f	5159359	\N	\N
990	65	253	2	71547	\N	71547	\N	\N	1	1	2	f	0	\N	\N
991	95	253	2	22217	\N	22217	\N	\N	2	1	2	f	0	167	\N
992	8	253	2	7420	\N	7420	\N	\N	3	1	2	f	0	166	\N
993	167	253	1	44420	\N	44420	\N	\N	1	1	2	f	\N	\N	\N
994	96	253	1	31774	\N	31774	\N	\N	2	1	2	f	\N	65	\N
995	27	253	1	15946	\N	15946	\N	\N	3	1	2	f	\N	65	\N
996	166	253	1	7420	\N	7420	\N	\N	4	1	2	f	\N	8	\N
997	131	253	1	702	\N	702	\N	\N	5	1	2	f	\N	65	\N
998	153	253	1	411	\N	411	\N	\N	6	1	2	f	\N	65	\N
999	171	253	1	398	\N	398	\N	\N	7	1	2	f	\N	65	\N
1000	157	253	1	89	\N	89	\N	\N	8	1	2	f	\N	65	\N
1001	20	253	1	18	\N	18	\N	\N	9	1	2	f	\N	65	\N
1002	144	253	1	6	\N	6	\N	\N	10	1	2	f	\N	65	\N
1005	62	255	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1007	22	257	2	190643857	\N	190643857	\N	\N	1	1	2	f	0	\N	\N
1008	124	257	2	797122	\N	797122	\N	\N	2	1	2	f	0	58	\N
1009	58	257	1	191437187	\N	191437187	\N	\N	1	1	2	f	\N	\N	\N
1010	118	257	1	191437187	\N	191437187	\N	\N	0	1	2	f	\N	\N	\N
1011	32	257	1	191437187	\N	191437187	\N	\N	0	1	2	f	\N	\N	\N
1012	125	258	2	472	\N	472	\N	\N	1	1	2	f	0	125	\N
1013	75	258	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1014	125	258	1	472	\N	472	\N	\N	1	1	2	f	\N	125	\N
1015	75	258	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1016	4	259	2	20466403	\N	0	\N	\N	1	1	2	f	20466403	\N	\N
1017	77	259	2	8855603	\N	0	\N	\N	2	1	2	f	8855603	\N	\N
1018	26	259	2	399480	\N	0	\N	\N	3	1	2	f	399480	\N	\N
1019	92	259	2	320598	\N	0	\N	\N	4	1	2	f	320598	\N	\N
1020	165	259	2	182078	\N	0	\N	\N	5	1	2	f	182078	\N	\N
1021	82	259	2	170627	\N	0	\N	\N	6	1	2	f	170627	\N	\N
1022	130	259	2	132986	\N	0	\N	\N	7	1	2	f	132986	\N	\N
1023	64	259	2	89586	\N	0	\N	\N	8	1	2	f	89586	\N	\N
1024	162	259	2	84323	\N	0	\N	\N	9	1	2	f	84323	\N	\N
1025	129	259	2	67373	\N	0	\N	\N	10	1	2	f	67373	\N	\N
1026	111	259	2	54564	\N	0	\N	\N	11	1	2	f	54564	\N	\N
1027	66	259	2	53622	\N	0	\N	\N	12	1	2	f	53622	\N	\N
1028	12	259	2	49375	\N	0	\N	\N	13	1	2	f	49375	\N	\N
1029	164	259	2	47581	\N	0	\N	\N	14	1	2	f	47581	\N	\N
1030	3	259	2	44624	\N	0	\N	\N	15	1	2	f	44624	\N	\N
1031	7	259	2	44486	\N	0	\N	\N	16	1	2	f	44486	\N	\N
1032	39	259	2	44006	\N	0	\N	\N	17	1	2	f	44006	\N	\N
1033	49	259	2	42611	\N	0	\N	\N	18	1	2	f	42611	\N	\N
1034	97	259	2	38631	\N	0	\N	\N	19	1	2	f	38631	\N	\N
1035	56	259	2	35050	\N	0	\N	\N	20	1	2	f	35050	\N	\N
1036	38	259	2	33103	\N	0	\N	\N	21	1	2	f	33103	\N	\N
1037	54	259	2	32966	\N	0	\N	\N	22	1	2	f	32966	\N	\N
1038	95	259	2	20476	\N	0	\N	\N	23	1	2	f	20476	\N	\N
1039	149	259	2	19109	\N	0	\N	\N	24	1	2	f	19109	\N	\N
1040	137	259	2	16460	\N	0	\N	\N	25	1	2	f	16460	\N	\N
1041	94	259	2	7886	\N	0	\N	\N	26	1	2	f	7886	\N	\N
1042	51	259	2	7167	\N	0	\N	\N	27	1	2	f	7167	\N	\N
1043	14	259	2	6795	\N	0	\N	\N	28	1	2	f	6795	\N	\N
1044	136	259	2	6192	\N	0	\N	\N	29	1	2	f	6192	\N	\N
1045	68	259	2	4656	\N	0	\N	\N	30	1	2	f	4656	\N	\N
1046	70	259	2	4516	\N	0	\N	\N	31	1	2	f	4516	\N	\N
1047	98	259	2	3265	\N	0	\N	\N	32	1	2	f	3265	\N	\N
1048	154	259	2	1920	\N	0	\N	\N	33	1	2	f	1920	\N	\N
1049	135	259	2	1628	\N	0	\N	\N	34	1	2	f	1628	\N	\N
1050	151	259	2	1435	\N	0	\N	\N	35	1	2	f	1435	\N	\N
1051	138	259	2	1382	\N	0	\N	\N	36	1	2	f	1382	\N	\N
1052	16	259	2	948	\N	0	\N	\N	37	1	2	f	948	\N	\N
1053	172	259	2	789	\N	0	\N	\N	38	1	2	f	789	\N	\N
1054	29	259	2	323	\N	0	\N	\N	39	1	2	f	323	\N	\N
1055	99	259	2	53	\N	0	\N	\N	40	1	2	f	53	\N	\N
1056	21	259	2	4	\N	0	\N	\N	41	1	2	f	4	\N	\N
1057	61	259	2	1	\N	0	\N	\N	42	1	2	f	1	\N	\N
1058	8	260	2	33105	\N	33105	\N	\N	1	1	2	f	0	38	\N
1059	38	260	1	33105	\N	33105	\N	\N	1	1	2	f	\N	8	\N
1060	8	261	2	4	\N	4	\N	\N	1	1	2	f	0	21	\N
1061	21	261	1	4	\N	4	\N	\N	1	1	2	f	\N	8	\N
1062	63	262	2	139	\N	139	\N	\N	1	1	2	f	0	\N	\N
1063	86	262	2	136	\N	136	\N	\N	2	1	2	f	0	125	\N
1064	156	262	2	56	\N	56	\N	\N	3	1	2	f	0	\N	\N
1065	91	262	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1066	33	262	2	1	\N	1	\N	\N	0	1	2	f	0	125	\N
1067	160	262	2	1	\N	1	\N	\N	0	1	2	f	0	125	\N
1068	125	262	1	146	\N	146	\N	\N	1	1	2	f	\N	\N	\N
1069	75	262	1	8	\N	8	\N	\N	0	1	2	f	\N	63	\N
1070	125	263	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
1071	84	265	2	41121	\N	41121	\N	\N	1	1	2	f	0	\N	\N
1072	64	265	1	26534	\N	26534	\N	\N	1	1	2	f	\N	84	\N
1073	4	265	1	14587	\N	14587	\N	\N	2	1	2	f	\N	84	\N
1074	8	266	2	14585	\N	14585	\N	\N	1	1	2	f	0	79	\N
1075	79	266	1	14585	\N	14585	\N	\N	1	1	2	f	\N	8	\N
1076	146	267	2	6655	\N	0	\N	\N	1	1	2	f	6655	\N	\N
1077	8	268	2	454587	\N	454587	\N	\N	1	1	2	f	0	\N	\N
1078	92	268	1	320598	\N	320598	\N	\N	1	1	2	f	\N	8	\N
1079	12	268	1	49375	\N	49375	\N	\N	2	1	2	f	\N	8	\N
1080	164	268	1	47581	\N	47581	\N	\N	3	1	2	f	\N	8	\N
1081	56	268	1	35060	\N	35060	\N	\N	4	1	2	f	\N	8	\N
1082	154	268	1	1920	\N	1920	\N	\N	5	1	2	f	\N	8	\N
1083	99	268	1	53	\N	53	\N	\N	6	1	2	f	\N	8	\N
1085	8	270	2	2122	\N	2122	\N	\N	1	1	2	f	0	40	\N
1086	40	270	1	2122	\N	2122	\N	\N	1	1	2	f	\N	8	\N
1087	106	271	2	20395	\N	0	\N	\N	1	1	2	f	20395	\N	\N
1089	150	273	2	563097	\N	0	\N	\N	1	1	2	f	563097	\N	\N
1090	101	273	2	1881	\N	0	\N	\N	0	1	2	f	1881	\N	\N
1091	4	274	2	20466403	\N	0	\N	\N	1	1	2	f	20466403	\N	\N
1092	77	274	2	8855603	\N	0	\N	\N	2	1	2	f	8855603	\N	\N
1093	26	274	2	399480	\N	0	\N	\N	3	1	2	f	399480	\N	\N
1094	92	274	2	320598	\N	0	\N	\N	4	1	2	f	320598	\N	\N
1095	165	274	2	182078	\N	0	\N	\N	5	1	2	f	182078	\N	\N
1096	82	274	2	170627	\N	0	\N	\N	6	1	2	f	170627	\N	\N
1097	130	274	2	132986	\N	0	\N	\N	7	1	2	f	132986	\N	\N
1098	64	274	2	89586	\N	0	\N	\N	8	1	2	f	89586	\N	\N
1099	162	274	2	84323	\N	0	\N	\N	9	1	2	f	84323	\N	\N
1100	129	274	2	67377	\N	0	\N	\N	10	1	2	f	67377	\N	\N
1101	111	274	2	54564	\N	0	\N	\N	11	1	2	f	54564	\N	\N
1102	66	274	2	53622	\N	0	\N	\N	12	1	2	f	53622	\N	\N
1103	12	274	2	49375	\N	0	\N	\N	13	1	2	f	49375	\N	\N
1104	164	274	2	47581	\N	0	\N	\N	14	1	2	f	47581	\N	\N
1105	3	274	2	44624	\N	0	\N	\N	15	1	2	f	44624	\N	\N
1106	7	274	2	44439	\N	0	\N	\N	16	1	2	f	44439	\N	\N
1107	39	274	2	44006	\N	0	\N	\N	17	1	2	f	44006	\N	\N
1108	49	274	2	42611	\N	0	\N	\N	18	1	2	f	42611	\N	\N
1109	97	274	2	38631	\N	0	\N	\N	19	1	2	f	38631	\N	\N
1110	56	274	2	35055	\N	0	\N	\N	20	1	2	f	35055	\N	\N
1111	38	274	2	33098	\N	0	\N	\N	21	1	2	f	33098	\N	\N
1112	54	274	2	32966	\N	0	\N	\N	22	1	2	f	32966	\N	\N
1113	149	274	2	19109	\N	0	\N	\N	23	1	2	f	19109	\N	\N
1114	137	274	2	16460	\N	0	\N	\N	24	1	2	f	16460	\N	\N
1115	94	274	2	7886	\N	0	\N	\N	25	1	2	f	7886	\N	\N
1116	51	274	2	7167	\N	0	\N	\N	26	1	2	f	7167	\N	\N
1117	14	274	2	6795	\N	0	\N	\N	27	1	2	f	6795	\N	\N
1118	136	274	2	6207	\N	0	\N	\N	28	1	2	f	6207	\N	\N
1119	68	274	2	4656	\N	0	\N	\N	29	1	2	f	4656	\N	\N
1120	70	274	2	4516	\N	0	\N	\N	30	1	2	f	4516	\N	\N
1121	98	274	2	3265	\N	0	\N	\N	31	1	2	f	3265	\N	\N
1122	154	274	2	1920	\N	0	\N	\N	32	1	2	f	1920	\N	\N
1123	135	274	2	1628	\N	0	\N	\N	33	1	2	f	1628	\N	\N
1124	151	274	2	1435	\N	0	\N	\N	34	1	2	f	1435	\N	\N
1125	138	274	2	1378	\N	0	\N	\N	35	1	2	f	1378	\N	\N
1126	16	274	2	948	\N	0	\N	\N	36	1	2	f	948	\N	\N
1127	172	274	2	881	\N	0	\N	\N	37	1	2	f	881	\N	\N
1128	29	274	2	323	\N	0	\N	\N	38	1	2	f	323	\N	\N
1129	99	274	2	53	\N	0	\N	\N	39	1	2	f	53	\N	\N
1130	21	274	2	4	\N	0	\N	\N	40	1	2	f	4	\N	\N
1131	61	274	2	1	\N	0	\N	\N	41	1	2	f	1	\N	\N
1132	8	275	2	84323	\N	84323	\N	\N	1	1	2	f	0	162	\N
1133	162	275	1	84323	\N	84323	\N	\N	1	1	2	f	\N	8	\N
1134	8	276	2	2073	\N	2073	\N	\N	1	1	2	f	0	11	\N
1135	11	276	1	2073	\N	2073	\N	\N	1	1	2	f	\N	8	\N
1136	113	277	2	12075	\N	12075	\N	\N	1	1	2	f	0	\N	\N
1137	158	277	1	12074	\N	12074	\N	\N	1	1	2	f	\N	113	\N
1138	118	277	1	12074	\N	12074	\N	\N	0	1	2	f	\N	113	\N
1139	32	277	1	12074	\N	12074	\N	\N	0	1	2	f	\N	113	\N
1140	150	278	2	574779	\N	0	\N	\N	1	1	2	f	574779	\N	\N
1141	101	278	2	1963	\N	0	\N	\N	0	1	2	f	1963	\N	\N
1142	8	279	2	396711	\N	396711	\N	\N	1	1	2	f	0	\N	\N
1143	165	279	1	182078	\N	182078	\N	\N	1	1	2	f	\N	8	\N
1144	82	279	1	170627	\N	170627	\N	\N	2	1	2	f	\N	8	\N
1145	39	279	1	44006	\N	44006	\N	\N	3	1	2	f	\N	8	\N
1146	65	280	2	42382	\N	42382	\N	\N	1	1	2	f	0	8	\N
1147	8	280	1	42382	\N	42382	\N	\N	1	1	2	f	\N	65	\N
1150	8	282	2	22714	\N	22714	\N	\N	1	1	2	f	0	52	\N
1151	52	282	1	22714	\N	22714	\N	\N	1	1	2	f	\N	8	\N
1152	8	283	2	42382	\N	0	\N	\N	1	1	2	f	42382	\N	\N
1153	8	284	2	1920	\N	1920	\N	\N	1	1	2	f	0	154	\N
1154	154	284	1	1920	\N	1920	\N	\N	1	1	2	f	\N	8	\N
1155	32	285	2	199	\N	38	\N	\N	1	1	2	f	161	\N	\N
1156	118	285	2	199	\N	38	\N	\N	0	1	2	f	161	\N	\N
1157	58	285	2	161	\N	0	\N	\N	0	1	2	f	161	\N	\N
1158	119	285	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
1159	96	286	2	52376	\N	52376	\N	\N	1	1	2	f	0	\N	\N
1160	167	286	2	24816	\N	24816	\N	\N	2	1	2	f	0	\N	\N
1161	166	286	2	7420	\N	7420	\N	\N	3	1	2	f	0	166	\N
1162	153	286	2	899	\N	899	\N	\N	4	1	2	f	0	\N	\N
1163	157	286	2	330	\N	330	\N	\N	5	1	2	f	0	\N	\N
1164	96	286	1	31774	\N	31774	\N	\N	1	1	2	f	\N	96	\N
1165	167	286	1	22203	\N	22203	\N	\N	2	1	2	f	\N	167	\N
1166	27	286	1	15946	\N	15946	\N	\N	3	1	2	f	\N	\N	\N
1167	166	286	1	7420	\N	7420	\N	\N	4	1	2	f	\N	166	\N
1168	131	286	1	5385	\N	5385	\N	\N	5	1	2	f	\N	\N	\N
1169	69	286	1	2613	\N	2613	\N	\N	6	1	2	f	\N	167	\N
1170	153	286	1	411	\N	411	\N	\N	7	1	2	f	\N	153	\N
1171	157	286	1	89	\N	89	\N	\N	8	1	2	f	\N	157	\N
1173	22	288	2	190643857	\N	190643857	\N	\N	1	1	2	f	0	125	\N
1174	113	288	2	73897474	\N	73897474	\N	\N	2	1	2	f	0	125	\N
1175	2	288	2	21831239	\N	21831239	\N	\N	3	1	2	f	0	125	\N
1176	4	288	2	20466403	\N	20466403	\N	\N	4	1	2	f	0	125	\N
1177	77	288	2	8855603	\N	8855603	\N	\N	5	1	2	f	0	125	\N
1178	146	288	2	4494676	\N	4494676	\N	\N	6	1	2	f	0	125	\N
1179	47	288	2	1578137	\N	1578137	\N	\N	7	1	2	f	0	125	\N
1180	124	288	2	797122	\N	797122	\N	\N	8	1	2	f	0	125	\N
1181	150	288	2	576742	\N	576742	\N	\N	9	1	2	f	0	125	\N
1182	5	288	2	518692	\N	518692	\N	\N	10	1	2	f	0	125	\N
1183	26	288	2	399480	\N	399480	\N	\N	11	1	2	f	0	125	\N
1184	78	288	2	338501	\N	338501	\N	\N	12	1	2	f	0	125	\N
1185	92	288	2	320598	\N	320598	\N	\N	13	1	2	f	0	125	\N
1186	165	288	2	182078	\N	182078	\N	\N	14	1	2	f	0	125	\N
1187	48	288	2	175584	\N	175584	\N	\N	15	1	2	f	0	125	\N
1188	82	288	2	170627	\N	170627	\N	\N	16	1	2	f	0	125	\N
1189	80	288	2	161948	\N	161948	\N	\N	17	1	2	f	0	125	\N
1190	141	288	2	144568	\N	144568	\N	\N	18	1	2	f	0	125	\N
1191	37	288	2	139183	\N	139183	\N	\N	19	1	2	f	0	125	\N
1192	130	288	2	132986	\N	132986	\N	\N	20	1	2	f	0	125	\N
1193	109	288	2	129846	\N	129846	\N	\N	21	1	2	f	0	125	\N
1194	28	288	2	122441	\N	122441	\N	\N	22	1	2	f	0	125	\N
1195	6	288	2	122332	\N	122332	\N	\N	23	1	2	f	0	125	\N
1196	64	288	2	89586	\N	89586	\N	\N	24	1	2	f	0	125	\N
1197	162	288	2	84323	\N	84323	\N	\N	25	1	2	f	0	125	\N
1198	17	288	2	76998	\N	76998	\N	\N	26	1	2	f	0	125	\N
1199	129	288	2	67380	\N	67380	\N	\N	27	1	2	f	0	125	\N
1200	111	288	2	54564	\N	54564	\N	\N	28	1	2	f	0	125	\N
1201	66	288	2	53622	\N	53622	\N	\N	29	1	2	f	0	125	\N
1202	96	288	2	52163	\N	52163	\N	\N	30	1	2	f	0	125	\N
1203	166	288	2	49802	\N	49802	\N	\N	31	1	2	f	0	125	\N
1204	12	288	2	49375	\N	49375	\N	\N	32	1	2	f	0	125	\N
1205	164	288	2	47581	\N	47581	\N	\N	33	1	2	f	0	125	\N
1206	18	288	2	45624	\N	45624	\N	\N	34	1	2	f	0	125	\N
1207	3	288	2	44624	\N	44624	\N	\N	35	1	2	f	0	125	\N
1208	7	288	2	44610	\N	44610	\N	\N	36	1	2	f	0	125	\N
1209	39	288	2	44006	\N	44006	\N	\N	37	1	2	f	0	125	\N
1210	49	288	2	42611	\N	42611	\N	\N	38	1	2	f	0	125	\N
1211	167	288	2	42576	\N	42576	\N	\N	39	1	2	f	0	125	\N
1212	145	288	2	42388	\N	42388	\N	\N	40	1	2	f	0	125	\N
1213	8	288	2	42382	\N	42382	\N	\N	41	1	2	f	0	125	\N
1214	163	288	2	41528	\N	41528	\N	\N	42	1	2	f	0	125	\N
1215	128	288	2	39739	\N	39739	\N	\N	43	1	2	f	0	125	\N
1216	84	288	2	39487	\N	39487	\N	\N	44	1	2	f	0	125	\N
1217	97	288	2	38631	\N	38631	\N	\N	45	1	2	f	0	125	\N
1218	56	288	2	35060	\N	35060	\N	\N	46	1	2	f	0	125	\N
1219	133	288	2	33504	\N	33504	\N	\N	47	1	2	f	0	125	\N
1220	38	288	2	33105	\N	33105	\N	\N	48	1	2	f	0	125	\N
1221	54	288	2	32966	\N	32966	\N	\N	49	1	2	f	0	125	\N
1222	110	288	2	31753	\N	31753	\N	\N	50	1	2	f	0	125	\N
1223	50	288	2	27993	\N	27993	\N	\N	51	1	2	f	0	125	\N
1224	93	288	2	23226	\N	23226	\N	\N	52	1	2	f	0	125	\N
1225	52	288	2	22714	\N	22714	\N	\N	53	1	2	f	0	125	\N
1226	95	288	2	20476	\N	20476	\N	\N	54	1	2	f	0	125	\N
1227	74	288	2	20395	\N	20395	\N	\N	55	1	2	f	0	125	\N
1228	106	288	2	20395	\N	20395	\N	\N	56	1	2	f	0	125	\N
1229	65	288	2	20389	\N	20389	\N	\N	57	1	2	f	0	125	\N
1230	149	288	2	19109	\N	19109	\N	\N	58	1	2	f	0	125	\N
1231	137	288	2	16460	\N	16460	\N	\N	59	1	2	f	0	125	\N
1232	27	288	2	15946	\N	15946	\N	\N	60	1	2	f	0	125	\N
1233	79	288	2	14585	\N	14585	\N	\N	61	1	2	f	0	125	\N
1234	73	288	2	14453	\N	14453	\N	\N	62	1	2	f	0	125	\N
1235	168	288	2	13531	\N	13531	\N	\N	63	1	2	f	0	125	\N
1236	71	288	2	13463	\N	13463	\N	\N	64	1	2	f	0	125	\N
1237	83	288	2	12852	\N	12852	\N	\N	65	1	2	f	0	125	\N
1238	9	288	2	11996	\N	11996	\N	\N	66	1	2	f	0	125	\N
1239	115	288	2	11271	\N	11271	\N	\N	67	1	2	f	0	125	\N
1240	94	288	2	7886	\N	7886	\N	\N	68	1	2	f	0	125	\N
1241	51	288	2	7167	\N	7167	\N	\N	69	1	2	f	0	125	\N
1242	147	288	2	7138	\N	7138	\N	\N	70	1	2	f	0	125	\N
1243	53	288	2	7120	\N	7120	\N	\N	71	1	2	f	0	125	\N
1244	14	288	2	6795	\N	6795	\N	\N	72	1	2	f	0	125	\N
1245	81	288	2	6322	\N	6322	\N	\N	73	1	2	f	0	125	\N
1246	136	288	2	6207	\N	6207	\N	\N	74	1	2	f	0	125	\N
1247	10	288	2	6175	\N	6175	\N	\N	75	1	2	f	0	125	\N
1248	131	288	2	5385	\N	5385	\N	\N	76	1	2	f	0	125	\N
1249	55	288	2	5313	\N	5313	\N	\N	77	1	2	f	0	125	\N
1250	114	288	2	4993	\N	4993	\N	\N	78	1	2	f	0	125	\N
1251	85	288	2	4909	\N	4909	\N	\N	79	1	2	f	0	125	\N
1252	112	288	2	4837	\N	4837	\N	\N	80	1	2	f	0	125	\N
1253	132	288	2	4738	\N	4738	\N	\N	81	1	2	f	0	125	\N
1254	68	288	2	4656	\N	4656	\N	\N	82	1	2	f	0	125	\N
1255	70	288	2	4516	\N	4516	\N	\N	83	1	2	f	0	125	\N
1256	116	288	2	4181	\N	4181	\N	\N	84	1	2	f	0	125	\N
1257	169	288	2	4039	\N	4039	\N	\N	85	1	2	f	0	125	\N
1258	67	288	2	3963	\N	3963	\N	\N	86	1	2	f	0	125	\N
1259	98	288	2	3265	\N	3265	\N	\N	87	1	2	f	0	125	\N
1260	57	288	2	2690	\N	2690	\N	\N	88	1	2	f	0	125	\N
1261	69	288	2	2637	\N	2637	\N	\N	89	1	2	f	0	125	\N
1262	100	288	2	2634	\N	2634	\N	\N	90	1	2	f	0	125	\N
1263	170	288	2	2560	\N	2560	\N	\N	91	1	2	f	0	125	\N
1264	134	288	2	2401	\N	2401	\N	\N	92	1	2	f	0	125	\N
1265	30	288	2	2152	\N	2152	\N	\N	93	1	2	f	0	125	\N
1266	40	288	2	2122	\N	2122	\N	\N	94	1	2	f	0	125	\N
1267	11	288	2	2073	\N	2073	\N	\N	95	1	2	f	0	125	\N
1268	143	288	2	2010	\N	2010	\N	\N	96	1	2	f	0	125	\N
1269	154	288	2	1920	\N	1920	\N	\N	97	1	2	f	0	125	\N
1270	42	288	2	1841	\N	1841	\N	\N	98	1	2	f	0	125	\N
1271	153	288	2	1756	\N	1756	\N	\N	99	1	2	f	0	125	\N
1272	135	288	2	1628	\N	1628	\N	\N	100	1	2	f	0	125	\N
1273	15	288	2	1598	\N	1598	\N	\N	101	1	2	f	0	125	\N
1274	173	288	2	1453	\N	1453	\N	\N	102	1	2	f	0	125	\N
1275	151	288	2	1435	\N	1435	\N	\N	103	1	2	f	0	125	\N
1276	155	288	2	1389	\N	1389	\N	\N	104	1	2	f	0	125	\N
1277	138	288	2	1388	\N	1388	\N	\N	105	1	2	f	0	125	\N
1278	152	288	2	1192	\N	1192	\N	\N	106	1	2	f	0	125	\N
1279	32	288	2	1173	\N	1173	\N	\N	107	1	2	f	0	\N	\N
1280	13	288	2	987	\N	987	\N	\N	108	1	2	f	0	125	\N
1281	139	288	2	969	\N	969	\N	\N	109	1	2	f	0	125	\N
1282	16	288	2	948	\N	948	\N	\N	110	1	2	f	0	125	\N
1283	172	288	2	881	\N	881	\N	\N	111	1	2	f	0	125	\N
1284	174	288	2	696	\N	696	\N	\N	112	1	2	f	0	125	\N
1285	44	288	2	652	\N	652	\N	\N	113	1	2	f	0	125	\N
1286	72	288	2	574	\N	574	\N	\N	114	1	2	f	0	125	\N
1287	31	288	2	540	\N	540	\N	\N	115	1	2	f	0	125	\N
1288	102	288	2	430	\N	430	\N	\N	116	1	2	f	0	125	\N
1289	171	288	2	398	\N	398	\N	\N	117	1	2	f	0	125	\N
1290	140	288	2	376	\N	376	\N	\N	118	1	2	f	0	125	\N
1291	29	288	2	323	\N	323	\N	\N	119	1	2	f	0	125	\N
1292	63	288	2	266	\N	266	\N	\N	120	1	2	f	0	\N	\N
1293	157	288	2	266	\N	266	\N	\N	121	1	2	f	0	125	\N
1294	86	288	2	252	\N	252	\N	\N	122	1	2	f	0	\N	\N
1295	87	288	2	225	\N	225	\N	\N	123	1	2	f	0	125	\N
1296	125	288	2	208	\N	208	\N	\N	124	1	2	f	0	\N	\N
1297	105	288	2	193	\N	193	\N	\N	125	1	2	f	0	125	\N
1298	122	288	2	157	\N	157	\N	\N	126	1	2	f	0	\N	\N
1300	60	288	2	114	\N	114	\N	\N	128	1	2	f	0	125	\N
1302	41	288	2	90	\N	90	\N	\N	130	1	2	f	0	125	\N
1303	177	288	2	87	\N	87	\N	\N	131	1	2	f	0	\N	\N
1304	156	288	2	58	\N	58	\N	\N	132	1	2	f	0	\N	\N
1305	99	288	2	53	\N	53	\N	\N	133	1	2	f	0	125	\N
1306	159	288	2	51	\N	51	\N	\N	134	1	2	f	0	125	\N
1307	34	288	2	45	\N	45	\N	\N	135	1	2	f	0	125	\N
1308	20	288	2	18	\N	18	\N	\N	136	1	2	f	0	125	\N
1309	59	288	2	18	\N	18	\N	\N	137	1	2	f	0	125	\N
1310	43	288	2	14	\N	14	\N	\N	138	1	2	f	0	125	\N
1311	120	288	2	13	\N	13	\N	\N	139	1	2	f	0	125	\N
1312	123	288	2	12	\N	12	\N	\N	140	1	2	f	0	\N	\N
1313	19	288	2	11	\N	11	\N	\N	141	1	2	f	0	125	\N
1314	117	288	2	11	\N	11	\N	\N	142	1	2	f	0	125	\N
1315	142	288	2	10	\N	10	\N	\N	143	1	2	f	0	125	\N
1319	89	288	2	7	\N	7	\N	\N	147	1	2	f	0	125	\N
1320	76	288	2	6	\N	6	\N	\N	148	1	2	f	0	\N	\N
1321	144	288	2	6	\N	6	\N	\N	149	1	2	f	0	125	\N
1322	21	288	2	4	\N	4	\N	\N	150	1	2	f	0	125	\N
1325	104	288	2	3	\N	3	\N	\N	153	1	2	f	0	125	\N
1329	88	288	2	2	\N	2	\N	\N	157	1	2	f	0	125	\N
1330	108	288	2	2	\N	2	\N	\N	158	1	2	f	0	\N	\N
1333	46	288	2	1	\N	1	\N	\N	161	1	2	f	0	\N	\N
1334	61	288	2	1	\N	1	\N	\N	162	1	2	f	0	125	\N
1335	62	288	2	1	\N	1	\N	\N	163	1	2	f	0	\N	\N
1336	121	288	2	1	\N	1	\N	\N	164	1	2	f	0	125	\N
1337	101	288	2	3926	\N	3926	\N	\N	0	1	2	f	0	125	\N
1338	118	288	2	1173	\N	1173	\N	\N	0	1	2	f	0	\N	\N
1339	119	288	2	597	\N	597	\N	\N	0	1	2	f	0	\N	\N
1340	58	288	2	510	\N	510	\N	\N	0	1	2	f	0	\N	\N
1341	103	288	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1342	45	288	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1343	75	288	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1344	175	288	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1345	158	288	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1346	176	288	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1347	91	288	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1348	33	288	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1349	160	288	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1350	125	288	1	327955555	\N	327955555	\N	\N	1	1	2	f	\N	\N	\N
1351	75	288	1	413	\N	413	\N	\N	0	1	2	f	\N	\N	\N
1352	17	289	2	76998	\N	76998	\N	\N	1	1	2	f	0	\N	\N
1353	30	289	2	2152	\N	2152	\N	\N	2	1	2	f	0	\N	\N
1354	80	289	1	25767	\N	25767	\N	\N	1	1	2	f	\N	17	\N
1355	78	289	1	17541	\N	17541	\N	\N	2	1	2	f	\N	17	\N
1356	47	289	1	16642	\N	16642	\N	\N	3	1	2	f	\N	17	\N
1357	140	289	1	10522	\N	10522	\N	\N	4	1	2	f	\N	17	\N
1358	87	289	1	2780	\N	2780	\N	\N	5	1	2	f	\N	17	\N
1359	48	289	1	2253	\N	2253	\N	\N	6	1	2	f	\N	17	\N
1360	163	289	1	2140	\N	2140	\N	\N	7	1	2	f	\N	30	\N
1361	102	289	1	1031	\N	1031	\N	\N	8	1	2	f	\N	17	\N
1362	84	290	2	76998	\N	76998	\N	\N	1	1	2	f	0	17	\N
1363	17	290	1	76998	\N	76998	\N	\N	1	1	2	f	\N	84	\N
1364	95	291	2	20476	\N	0	\N	\N	1	1	2	f	20476	\N	\N
1365	108	292	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1366	8	293	2	8855603	\N	8855603	\N	\N	1	1	2	f	0	77	\N
1367	77	293	1	8855603	\N	8855603	\N	\N	1	1	2	f	\N	8	\N
1370	65	295	2	20519	\N	20519	\N	\N	1	1	2	f	0	95	\N
1371	95	295	1	20519	\N	20519	\N	\N	1	1	2	f	\N	65	\N
1374	113	297	2	73897474	\N	73897474	\N	\N	1	1	2	f	0	176	\N
1375	2	297	2	21831239	\N	21831239	\N	\N	2	1	2	f	0	176	\N
1376	4	297	2	20466403	\N	20466403	\N	\N	3	1	2	f	0	176	\N
1377	77	297	2	8855603	\N	8855603	\N	\N	4	1	2	f	0	176	\N
1378	47	297	2	1578137	\N	1578137	\N	\N	5	1	2	f	0	176	\N
1379	5	297	2	518692	\N	518692	\N	\N	6	1	2	f	0	176	\N
1380	26	297	2	399480	\N	399480	\N	\N	7	1	2	f	0	176	\N
1381	78	297	2	338501	\N	338501	\N	\N	8	1	2	f	0	176	\N
1382	92	297	2	320598	\N	320598	\N	\N	9	1	2	f	0	176	\N
1383	165	297	2	182078	\N	182078	\N	\N	10	1	2	f	0	176	\N
1384	48	297	2	175584	\N	175584	\N	\N	11	1	2	f	0	176	\N
1385	82	297	2	170627	\N	170627	\N	\N	12	1	2	f	0	176	\N
1386	80	297	2	161948	\N	161948	\N	\N	13	1	2	f	0	176	\N
1387	37	297	2	139183	\N	139183	\N	\N	14	1	2	f	0	176	\N
1388	130	297	2	132986	\N	132986	\N	\N	15	1	2	f	0	176	\N
1389	109	297	2	129846	\N	129846	\N	\N	16	1	2	f	0	176	\N
1390	28	297	2	122441	\N	122441	\N	\N	17	1	2	f	0	176	\N
1391	6	297	2	122332	\N	122332	\N	\N	18	1	2	f	0	176	\N
1392	64	297	2	89586	\N	89586	\N	\N	19	1	2	f	0	176	\N
1393	162	297	2	84323	\N	84323	\N	\N	20	1	2	f	0	176	\N
1394	17	297	2	76998	\N	76998	\N	\N	21	1	2	f	0	176	\N
1395	129	297	2	67380	\N	67380	\N	\N	22	1	2	f	0	176	\N
1396	111	297	2	54564	\N	54564	\N	\N	23	1	2	f	0	176	\N
1397	66	297	2	53622	\N	53622	\N	\N	24	1	2	f	0	176	\N
1398	12	297	2	49375	\N	49375	\N	\N	25	1	2	f	0	176	\N
1399	164	297	2	47581	\N	47581	\N	\N	26	1	2	f	0	176	\N
1400	3	297	2	44624	\N	44624	\N	\N	27	1	2	f	0	176	\N
1401	7	297	2	44610	\N	44610	\N	\N	28	1	2	f	0	176	\N
1402	39	297	2	44006	\N	44006	\N	\N	29	1	2	f	0	176	\N
1403	49	297	2	42611	\N	42611	\N	\N	30	1	2	f	0	176	\N
1404	163	297	2	41528	\N	41528	\N	\N	31	1	2	f	0	176	\N
1405	128	297	2	39739	\N	39739	\N	\N	32	1	2	f	0	176	\N
1406	97	297	2	38631	\N	38631	\N	\N	33	1	2	f	0	176	\N
1407	56	297	2	35060	\N	35060	\N	\N	34	1	2	f	0	176	\N
1408	133	297	2	33504	\N	33504	\N	\N	35	1	2	f	0	176	\N
1409	38	297	2	33105	\N	33105	\N	\N	36	1	2	f	0	176	\N
1410	54	297	2	32966	\N	32966	\N	\N	37	1	2	f	0	176	\N
1411	110	297	2	31753	\N	31753	\N	\N	38	1	2	f	0	176	\N
1412	93	297	2	23226	\N	23226	\N	\N	39	1	2	f	0	176	\N
1413	52	297	2	22714	\N	22714	\N	\N	40	1	2	f	0	176	\N
1414	149	297	2	19109	\N	19109	\N	\N	41	1	2	f	0	176	\N
1415	137	297	2	16460	\N	16460	\N	\N	42	1	2	f	0	176	\N
1416	79	297	2	14585	\N	14585	\N	\N	43	1	2	f	0	176	\N
1417	83	297	2	12852	\N	12852	\N	\N	44	1	2	f	0	176	\N
1418	9	297	2	11996	\N	11996	\N	\N	45	1	2	f	0	176	\N
1419	94	297	2	7886	\N	7886	\N	\N	46	1	2	f	0	176	\N
1420	51	297	2	7167	\N	7167	\N	\N	47	1	2	f	0	176	\N
1421	14	297	2	6795	\N	6795	\N	\N	48	1	2	f	0	176	\N
1422	136	297	2	6207	\N	6207	\N	\N	49	1	2	f	0	176	\N
1423	10	297	2	6175	\N	6175	\N	\N	50	1	2	f	0	176	\N
1424	114	297	2	4993	\N	4993	\N	\N	51	1	2	f	0	176	\N
1425	112	297	2	4837	\N	4837	\N	\N	52	1	2	f	0	176	\N
1426	132	297	2	4738	\N	4738	\N	\N	53	1	2	f	0	176	\N
1427	68	297	2	4656	\N	4656	\N	\N	54	1	2	f	0	176	\N
1428	70	297	2	4516	\N	4516	\N	\N	55	1	2	f	0	176	\N
1429	116	297	2	4181	\N	4181	\N	\N	56	1	2	f	0	176	\N
1430	67	297	2	3963	\N	3963	\N	\N	57	1	2	f	0	176	\N
1431	98	297	2	3265	\N	3265	\N	\N	58	1	2	f	0	176	\N
1432	134	297	2	2401	\N	2401	\N	\N	59	1	2	f	0	176	\N
1433	30	297	2	2152	\N	2152	\N	\N	60	1	2	f	0	176	\N
1434	40	297	2	2122	\N	2122	\N	\N	61	1	2	f	0	176	\N
1435	11	297	2	2073	\N	2073	\N	\N	62	1	2	f	0	176	\N
1436	154	297	2	1920	\N	1920	\N	\N	63	1	2	f	0	176	\N
1437	135	297	2	1628	\N	1628	\N	\N	64	1	2	f	0	176	\N
1438	15	297	2	1598	\N	1598	\N	\N	65	1	2	f	0	176	\N
1439	151	297	2	1435	\N	1435	\N	\N	66	1	2	f	0	176	\N
1440	138	297	2	1388	\N	1388	\N	\N	67	1	2	f	0	176	\N
1441	13	297	2	987	\N	987	\N	\N	68	1	2	f	0	176	\N
1442	16	297	2	948	\N	948	\N	\N	69	1	2	f	0	176	\N
1443	172	297	2	881	\N	881	\N	\N	70	1	2	f	0	176	\N
1444	44	297	2	652	\N	652	\N	\N	71	1	2	f	0	176	\N
1445	72	297	2	574	\N	574	\N	\N	72	1	2	f	0	176	\N
1446	102	297	2	430	\N	430	\N	\N	73	1	2	f	0	176	\N
1447	140	297	2	376	\N	376	\N	\N	74	1	2	f	0	176	\N
1448	29	297	2	323	\N	323	\N	\N	75	1	2	f	0	176	\N
1449	87	297	2	225	\N	225	\N	\N	76	1	2	f	0	176	\N
1450	60	297	2	114	\N	114	\N	\N	77	1	2	f	0	176	\N
1451	41	297	2	90	\N	90	\N	\N	78	1	2	f	0	176	\N
1452	99	297	2	53	\N	53	\N	\N	79	1	2	f	0	176	\N
1453	43	297	2	14	\N	14	\N	\N	80	1	2	f	0	176	\N
1454	19	297	2	11	\N	11	\N	\N	81	1	2	f	0	176	\N
1455	21	297	2	4	\N	4	\N	\N	82	1	2	f	0	176	\N
1456	104	297	2	3	\N	3	\N	\N	83	1	2	f	0	176	\N
1457	61	297	2	1	\N	1	\N	\N	84	1	2	f	0	176	\N
1458	176	297	1	130741442	\N	130741442	\N	\N	1	1	2	f	\N	\N	\N
1459	118	297	1	130741442	\N	130741442	\N	\N	0	1	2	f	\N	\N	\N
1460	32	297	1	130741442	\N	130741442	\N	\N	0	1	2	f	\N	\N	\N
1461	77	298	2	68177767	\N	68177767	\N	\N	1	1	2	f	0	113	\N
1462	2	298	2	51909409	\N	51909409	\N	\N	2	1	2	f	0	113	\N
1463	4	298	2	37265428	\N	37265428	\N	\N	3	1	2	f	0	113	\N
1464	47	298	2	3534248	\N	3534248	\N	\N	4	1	2	f	0	113	\N
1465	92	298	2	1649930	\N	1649930	\N	\N	5	1	2	f	0	113	\N
1466	5	298	2	430177	\N	430177	\N	\N	6	1	2	f	0	113	\N
1467	78	298	2	406957	\N	406957	\N	\N	7	1	2	f	0	113	\N
1468	26	298	2	399480	\N	399480	\N	\N	8	1	2	f	0	113	\N
1469	80	298	2	346652	\N	346652	\N	\N	9	1	2	f	0	113	\N
1470	130	298	2	265972	\N	265972	\N	\N	10	1	2	f	0	113	\N
1471	48	298	2	236790	\N	236790	\N	\N	11	1	2	f	0	113	\N
1472	165	298	2	182078	\N	182078	\N	\N	12	1	2	f	0	113	\N
1473	82	298	2	170627	\N	170627	\N	\N	13	1	2	f	0	113	\N
1474	28	298	2	163154	\N	163154	\N	\N	14	1	2	f	0	113	\N
1475	6	298	2	147507	\N	147507	\N	\N	15	1	2	f	0	113	\N
1476	109	298	2	145237	\N	145237	\N	\N	16	1	2	f	0	113	\N
1477	37	298	2	140407	\N	140407	\N	\N	17	1	2	f	0	113	\N
1478	128	298	2	116177	\N	116177	\N	\N	18	1	2	f	0	113	\N
1479	110	298	2	115473	\N	115473	\N	\N	19	1	2	f	0	113	\N
1480	64	298	2	102581	\N	102581	\N	\N	20	1	2	f	0	113	\N
1481	111	298	2	94932	\N	94932	\N	\N	21	1	2	f	0	113	\N
1482	162	298	2	91207	\N	91207	\N	\N	22	1	2	f	0	113	\N
1483	17	298	2	85411	\N	85411	\N	\N	23	1	2	f	0	113	\N
1484	163	298	2	80474	\N	80474	\N	\N	24	1	2	f	0	113	\N
1485	12	298	2	68185	\N	68185	\N	\N	25	1	2	f	0	113	\N
1486	129	298	2	68185	\N	68185	\N	\N	26	1	2	f	0	113	\N
1487	164	298	2	61232	\N	61232	\N	\N	27	1	2	f	0	113	\N
1488	66	298	2	53622	\N	53622	\N	\N	28	1	2	f	0	113	\N
1489	56	298	2	48579	\N	48579	\N	\N	29	1	2	f	0	113	\N
1490	3	298	2	45100	\N	45100	\N	\N	30	1	2	f	0	113	\N
1491	39	298	2	44006	\N	44006	\N	\N	31	1	2	f	0	113	\N
1492	49	298	2	42611	\N	42611	\N	\N	32	1	2	f	0	113	\N
1493	97	298	2	39639	\N	39639	\N	\N	33	1	2	f	0	113	\N
1494	93	298	2	37666	\N	37666	\N	\N	34	1	2	f	0	113	\N
1495	52	298	2	35330	\N	35330	\N	\N	35	1	2	f	0	113	\N
1496	38	298	2	33849	\N	33849	\N	\N	36	1	2	f	0	113	\N
1497	133	298	2	33504	\N	33504	\N	\N	37	1	2	f	0	113	\N
1498	54	298	2	33354	\N	33354	\N	\N	38	1	2	f	0	113	\N
1499	7	298	2	22765	\N	22765	\N	\N	39	1	2	f	0	113	\N
1500	79	298	2	20625	\N	20625	\N	\N	40	1	2	f	0	113	\N
1501	149	298	2	19571	\N	19571	\N	\N	41	1	2	f	0	113	\N
1502	137	298	2	16615	\N	16615	\N	\N	42	1	2	f	0	113	\N
1503	83	298	2	15218	\N	15218	\N	\N	43	1	2	f	0	113	\N
1504	9	298	2	11996	\N	11996	\N	\N	44	1	2	f	0	113	\N
1505	51	298	2	9487	\N	9487	\N	\N	45	1	2	f	0	113	\N
1506	94	298	2	8105	\N	8105	\N	\N	46	1	2	f	0	113	\N
1507	67	298	2	7940	\N	7940	\N	\N	47	1	2	f	0	113	\N
1508	112	298	2	6887	\N	6887	\N	\N	48	1	2	f	0	113	\N
1509	136	298	2	6843	\N	6843	\N	\N	49	1	2	f	0	113	\N
1510	14	298	2	6833	\N	6833	\N	\N	50	1	2	f	0	113	\N
1511	132	298	2	6699	\N	6699	\N	\N	51	1	2	f	0	113	\N
1512	10	298	2	6539	\N	6539	\N	\N	52	1	2	f	0	113	\N
1513	116	298	2	5822	\N	5822	\N	\N	53	1	2	f	0	113	\N
1514	98	298	2	5770	\N	5770	\N	\N	54	1	2	f	0	113	\N
1515	114	298	2	4993	\N	4993	\N	\N	55	1	2	f	0	113	\N
1516	68	298	2	4974	\N	4974	\N	\N	56	1	2	f	0	113	\N
1517	70	298	2	4841	\N	4841	\N	\N	57	1	2	f	0	113	\N
1518	140	298	2	4591	\N	4591	\N	\N	58	1	2	f	0	113	\N
1519	40	298	2	3036	\N	3036	\N	\N	59	1	2	f	0	113	\N
1520	11	298	2	2369	\N	2369	\N	\N	60	1	2	f	0	113	\N
1521	30	298	2	2286	\N	2286	\N	\N	61	1	2	f	0	113	\N
1522	15	298	2	2196	\N	2196	\N	\N	62	1	2	f	0	113	\N
1523	154	298	2	2103	\N	2103	\N	\N	63	1	2	f	0	113	\N
1524	135	298	2	1761	\N	1761	\N	\N	64	1	2	f	0	113	\N
1525	151	298	2	1601	\N	1601	\N	\N	65	1	2	f	0	113	\N
1526	138	298	2	1427	\N	1427	\N	\N	66	1	2	f	0	113	\N
1527	16	298	2	1044	\N	1044	\N	\N	67	1	2	f	0	113	\N
1528	172	298	2	971	\N	971	\N	\N	68	1	2	f	0	113	\N
1529	29	298	2	323	\N	323	\N	\N	69	1	2	f	0	113	\N
1530	41	298	2	94	\N	94	\N	\N	70	1	2	f	0	113	\N
1531	99	298	2	55	\N	55	\N	\N	71	1	2	f	0	113	\N
1532	43	298	2	18	\N	18	\N	\N	72	1	2	f	0	113	\N
1533	21	298	2	4	\N	4	\N	\N	73	1	2	f	0	113	\N
1534	61	298	2	1	\N	1	\N	\N	74	1	2	f	0	113	\N
1535	113	298	1	167119340	\N	167119340	\N	\N	1	1	2	f	\N	\N	\N
1537	8	300	2	4837	\N	4837	\N	\N	1	1	2	f	0	112	\N
1538	112	300	1	4837	\N	4837	\N	\N	1	1	2	f	\N	8	\N
1542	8	303	2	7886	\N	7886	\N	\N	1	1	2	f	0	94	\N
1543	94	303	1	7886	\N	7886	\N	\N	1	1	2	f	\N	8	\N
1544	8	304	2	175584	\N	175584	\N	\N	1	1	2	f	0	48	\N
1545	48	304	1	175584	\N	175584	\N	\N	1	1	2	f	\N	8	\N
1546	65	305	2	40790	\N	40790	\N	\N	1	1	2	f	0	\N	\N
1547	74	305	1	20395	\N	20395	\N	\N	1	1	2	f	\N	65	\N
1548	106	305	1	20395	\N	20395	\N	\N	2	1	2	f	\N	65	\N
1562	108	311	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1563	8	312	2	3	\N	3	\N	\N	1	1	2	f	0	104	\N
1564	104	312	1	3	\N	3	\N	\N	1	1	2	f	\N	8	\N
1565	47	313	2	1578256	\N	1578256	\N	\N	1	1	2	f	0	\N	\N
1566	28	313	2	122441	\N	122441	\N	\N	2	1	2	f	0	22	\N
1567	111	313	2	51011	\N	51011	\N	\N	3	1	2	f	0	22	\N
1568	149	313	2	19109	\N	19109	\N	\N	4	1	2	f	0	65	\N
1569	132	313	2	4738	\N	4738	\N	\N	5	1	2	f	0	22	\N
1570	65	313	1	1319471	\N	1319471	\N	\N	1	1	2	f	\N	\N	\N
1571	22	313	1	338885	\N	338885	\N	\N	2	1	2	f	\N	\N	\N
1572	8	313	1	117199	\N	117199	\N	\N	3	1	2	f	\N	47	\N
1573	32	314	2	391	\N	0	\N	\N	1	1	2	f	391	\N	\N
1574	125	314	2	172	\N	0	\N	\N	2	1	2	f	172	\N	\N
1575	86	314	2	136	\N	0	\N	\N	3	1	2	f	136	\N	\N
1576	63	314	2	119	\N	0	\N	\N	4	1	2	f	119	\N	\N
1577	156	314	2	56	\N	0	\N	\N	5	1	2	f	56	\N	\N
1578	118	314	2	391	\N	0	\N	\N	0	1	2	f	391	\N	\N
1579	119	314	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
1580	58	314	2	170	\N	0	\N	\N	0	1	2	f	170	\N	\N
1581	103	314	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1582	45	314	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1583	175	314	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1584	158	314	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1585	176	314	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1586	33	314	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1587	160	314	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1590	125	317	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1591	49	318	2	42611	\N	0	\N	\N	1	1	2	f	42611	\N	\N
1592	8	319	2	23226	\N	23226	\N	\N	1	1	2	f	0	93	\N
1593	93	319	1	23226	\N	23226	\N	\N	1	1	2	f	\N	8	\N
1594	150	320	2	563133	\N	0	\N	\N	1	1	2	f	563133	\N	\N
1595	101	320	2	1883	\N	0	\N	\N	0	1	2	f	1883	\N	\N
1596	8	321	2	90	\N	90	\N	\N	1	1	2	f	0	41	\N
1597	41	321	1	90	\N	90	\N	\N	1	1	2	f	\N	8	\N
1598	113	322	2	73897474	\N	0	\N	\N	1	1	2	f	73897474	\N	\N
1599	108	323	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1600	141	324	2	144568	\N	0	\N	\N	1	1	2	f	144568	\N	\N
1601	170	324	2	2560	\N	0	\N	\N	2	1	2	f	2560	\N	\N
1602	152	324	2	1192	\N	0	\N	\N	3	1	2	f	1192	\N	\N
1603	113	325	2	73897474	\N	73897474	\N	\N	1	1	2	f	0	119	\N
1604	119	325	1	73897474	\N	73897474	\N	\N	1	1	2	f	\N	113	\N
1605	118	325	1	73897474	\N	73897474	\N	\N	0	1	2	f	\N	113	\N
1606	32	325	1	73897474	\N	73897474	\N	\N	0	1	2	f	\N	113	\N
1607	74	326	2	20395	\N	0	\N	\N	1	1	2	f	20395	\N	\N
1608	106	326	2	20395	\N	0	\N	\N	2	1	2	f	20395	\N	\N
1609	46	327	2	1	\N	1	\N	\N	1	1	2	f	0	46	\N
1610	46	327	1	1	\N	1	\N	\N	1	1	2	f	\N	46	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	1	51	7167	\N	1	\N
2	2	8	7167	\N	1	\N
3	3	11	2073	\N	3	\N
4	3	2	21831239	\N	1	\N
5	3	109	129846	\N	2	\N
6	4	8	21831239	\N	1	\N
7	5	8	129846	\N	1	\N
8	6	8	2073	\N	1	\N
9	8	172	881	\N	5	\N
10	8	136	6207	\N	2	\N
11	8	21	4	\N	6	\N
12	8	7	44610	\N	1	\N
13	8	138	1388	\N	4	\N
14	8	98	3265	\N	3	\N
15	9	8	44610	\N	1	\N
16	10	8	6207	\N	1	\N
17	11	8	3265	\N	1	\N
18	12	8	1388	\N	1	\N
19	13	8	881	\N	1	\N
20	14	8	4	\N	1	\N
21	16	29	323	\N	1	\N
22	17	8	323	\N	1	\N
23	19	78	338501	\N	1	\N
24	20	8	338501	\N	1	\N
25	21	173	21831239	\N	1	\N
26	22	152	518692	\N	1	\N
27	23	50	338501	\N	1	\N
28	24	174	320598	\N	1	\N
29	25	169	175584	\N	1	\N
30	26	115	161948	\N	1	\N
31	27	31	122332	\N	1	\N
32	28	120	76998	\N	1	\N
33	29	174	49375	\N	1	\N
34	30	174	47581	\N	1	\N
35	31	139	44624	\N	1	\N
36	32	59	38631	\N	1	\N
37	33	59	33105	\N	1	\N
38	34	139	24601	\N	1	\N
39	35	18	295	\N	2	\N
40	35	81	17314	\N	1	\N
41	36	139	16307	\N	1	\N
42	37	55	14453	\N	1	\N
43	38	53	12153	\N	1	\N
44	39	53	11996	\N	1	\N
45	40	170	3133	\N	1	\N
46	41	120	2152	\N	1	\N
47	42	174	1920	\N	1	\N
48	43	139	1183	\N	1	\N
49	44	59	948	\N	1	\N
50	45	88	881	\N	1	\N
51	46	71	430	\N	1	\N
52	47	159	376	\N	1	\N
53	48	89	225	\N	1	\N
54	49	121	53	\N	1	\N
55	50	88	4	\N	1	\N
56	51	2	21831239	\N	1	\N
57	52	5	518692	\N	1	\N
58	53	92	320598	\N	1	\N
59	53	12	49375	\N	2	\N
60	53	164	47581	\N	3	\N
61	53	154	1920	\N	4	\N
62	54	78	338501	\N	1	\N
63	55	48	175584	\N	1	\N
64	56	80	161948	\N	1	\N
65	57	6	122332	\N	1	\N
66	58	54	24601	\N	2	\N
67	58	151	1183	\N	4	\N
68	58	3	44624	\N	1	\N
69	58	137	16307	\N	3	\N
70	59	30	2152	\N	2	\N
71	59	17	76998	\N	1	\N
72	60	38	33105	\N	2	\N
73	60	97	38631	\N	1	\N
74	60	16	948	\N	3	\N
75	61	9	11996	\N	2	\N
76	61	52	12153	\N	1	\N
77	62	163	17314	\N	1	\N
78	63	73	14453	\N	1	\N
79	64	37	3133	\N	1	\N
80	65	172	881	\N	1	\N
81	65	21	4	\N	2	\N
82	66	102	430	\N	1	\N
83	67	140	376	\N	1	\N
84	68	163	295	\N	1	\N
85	69	87	225	\N	1	\N
86	70	99	53	\N	1	\N
87	71	153	1345	\N	4	\N
88	71	157	177	\N	5	\N
89	71	96	20389	\N	1	\N
90	71	167	20373	\N	2	\N
91	71	131	4683	\N	3	\N
92	72	166	42382	\N	1	\N
93	73	167	20373	\N	1	\N
94	74	8	42382	\N	1	\N
95	75	65	20373	\N	1	\N
96	75	95	20373	\N	2	\N
97	76	65	20389	\N	1	\N
98	77	65	4683	\N	1	\N
99	78	65	1345	\N	1	\N
100	79	65	177	\N	1	\N
101	82	129	67380	\N	1	\N
102	83	8	67380	\N	1	\N
103	84	14	6795	\N	1	\N
104	85	8	6795	\N	1	\N
105	86	13	987	\N	1	\N
106	87	8	987	\N	1	\N
107	88	44	652	\N	3	\N
108	88	72	574	\N	4	\N
109	88	104	3	\N	7	\N
110	88	19	11	\N	6	\N
111	88	134	2401	\N	1	\N
112	88	13	987	\N	2	\N
113	88	60	114	\N	5	\N
114	89	8	2401	\N	1	\N
115	90	8	987	\N	1	\N
116	91	8	652	\N	1	\N
117	92	8	574	\N	1	\N
118	93	8	114	\N	1	\N
119	94	8	11	\N	1	\N
120	95	8	3	\N	1	\N
121	96	125	4	\N	1	\N
122	97	125	4	\N	1	\N
123	98	39	44006	\N	1	\N
124	99	8	44006	\N	1	\N
125	100	128	39739	\N	1	\N
126	101	8	39739	\N	1	\N
127	103	165	182078	\N	1	\N
128	104	8	182078	\N	1	\N
129	105	16	948	\N	1	\N
130	106	8	948	\N	1	\N
131	110	134	2401	\N	1	\N
132	111	8	2401	\N	1	\N
133	113	6	122332	\N	10	\N
134	113	78	338501	\N	4	\N
135	113	48	175584	\N	5	\N
136	113	72	574	\N	32	\N
137	113	44	652	\N	31	\N
138	113	116	4181	\N	24	\N
139	113	104	3	\N	37	\N
140	113	93	23226	\N	15	\N
141	113	114	4993	\N	21	\N
142	113	40	2122	\N	27	\N
143	113	5	518692	\N	3	\N
144	113	11	2073	\N	28	\N
145	113	2	21831239	\N	1	\N
146	113	19	11	\N	36	\N
147	113	47	1578137	\N	2	\N
148	113	10	6175	\N	20	\N
149	113	163	41528	\N	11	\N
150	113	67	3963	\N	25	\N
151	113	28	122441	\N	9	\N
152	113	132	4738	\N	23	\N
153	113	43	14	\N	35	\N
154	113	80	161948	\N	6	\N
155	113	83	12852	\N	18	\N
156	113	133	33504	\N	13	\N
157	113	134	2401	\N	26	\N
158	113	41	90	\N	34	\N
159	113	79	14585	\N	17	\N
160	113	9	11996	\N	19	\N
161	113	13	987	\N	30	\N
162	113	109	129846	\N	8	\N
163	113	110	31753	\N	14	\N
164	113	37	139183	\N	7	\N
165	113	112	4837	\N	22	\N
166	113	15	1598	\N	29	\N
167	113	60	114	\N	33	\N
168	113	128	39739	\N	12	\N
169	113	52	22714	\N	16	\N
170	114	17	76998	\N	1	\N
171	115	8	21831239	\N	1	\N
172	116	8	1578137	\N	1	\N
173	117	8	518692	\N	1	\N
174	118	8	338501	\N	1	\N
175	119	8	175584	\N	1	\N
176	120	8	161948	\N	1	\N
177	121	8	139183	\N	1	\N
178	122	8	129846	\N	1	\N
179	123	8	122441	\N	1	\N
180	124	8	122332	\N	1	\N
181	125	84	76998	\N	1	\N
182	126	8	41528	\N	1	\N
183	127	8	39739	\N	1	\N
184	128	8	33504	\N	1	\N
185	129	8	31753	\N	1	\N
186	130	8	23226	\N	1	\N
187	131	8	22714	\N	1	\N
188	132	8	14585	\N	1	\N
189	133	8	12852	\N	1	\N
190	134	8	11996	\N	1	\N
191	135	8	6175	\N	1	\N
192	136	8	4993	\N	1	\N
193	137	8	4837	\N	1	\N
194	138	8	4738	\N	1	\N
195	139	8	4181	\N	1	\N
196	140	8	3963	\N	1	\N
197	141	8	2401	\N	1	\N
198	142	8	2122	\N	1	\N
199	143	8	2073	\N	1	\N
200	144	8	1598	\N	1	\N
201	145	8	987	\N	1	\N
202	146	8	652	\N	1	\N
203	147	8	574	\N	1	\N
204	148	8	114	\N	1	\N
205	149	8	90	\N	1	\N
206	150	8	14	\N	1	\N
207	151	8	11	\N	1	\N
208	152	8	3	\N	1	\N
209	154	62	1	\N	1	\N
210	155	108	1	\N	1	\N
211	156	130	132986	\N	1	\N
212	157	8	132986	\N	1	\N
213	158	58	70750485	\N	1	\N
214	158	118	70750485	\N	0	\N
215	158	32	70750485	\N	0	\N
216	159	113	70750485	\N	1	\N
217	160	113	70750485	\N	1	\N
218	161	113	70750485	\N	1	\N
219	162	2	21831239	\N	1	\N
220	163	8	21831239	\N	1	\N
221	164	103	243792	\N	1	\N
222	164	118	243792	\N	0	\N
223	164	32	243792	\N	0	\N
224	165	113	243792	\N	1	\N
225	166	113	243792	\N	1	\N
226	167	113	243792	\N	1	\N
227	168	51	7167	\N	26	\N
228	168	82	170627	\N	6	\N
229	168	70	4516	\N	30	\N
230	168	172	881	\N	37	\N
231	168	149	19109	\N	23	\N
232	168	12	49375	\N	13	\N
233	168	111	54564	\N	11	\N
234	168	99	53	\N	39	\N
235	168	26	399480	\N	3	\N
236	168	68	4656	\N	29	\N
237	168	137	16460	\N	24	\N
238	168	38	33105	\N	21	\N
239	168	3	44624	\N	15	\N
240	168	165	182078	\N	5	\N
241	168	94	7886	\N	25	\N
242	168	136	6207	\N	28	\N
243	168	54	32966	\N	22	\N
244	168	151	1435	\N	34	\N
245	168	16	948	\N	36	\N
246	168	154	1920	\N	32	\N
247	168	29	323	\N	38	\N
248	168	21	4	\N	40	\N
249	168	4	20466403	\N	1	\N
250	168	7	44610	\N	16	\N
251	168	77	8855603	\N	2	\N
252	168	97	38631	\N	19	\N
253	168	135	1628	\N	33	\N
254	168	56	35060	\N	20	\N
255	168	138	1388	\N	35	\N
256	168	14	6795	\N	27	\N
257	168	66	53622	\N	12	\N
258	168	129	67380	\N	10	\N
259	168	130	132986	\N	7	\N
260	168	164	47581	\N	14	\N
261	168	64	89586	\N	8	\N
262	168	98	3265	\N	31	\N
263	168	92	320598	\N	4	\N
264	168	162	84323	\N	9	\N
265	168	49	42611	\N	18	\N
266	168	39	44006	\N	17	\N
267	168	61	1	\N	41	\N
268	169	30	2152	\N	1	\N
269	170	8	20466403	\N	1	\N
270	171	8	8855603	\N	1	\N
271	172	8	399480	\N	1	\N
272	173	8	320598	\N	1	\N
273	174	8	182078	\N	1	\N
274	175	8	170627	\N	1	\N
275	176	8	132986	\N	1	\N
276	177	8	89586	\N	1	\N
277	178	8	84323	\N	1	\N
278	179	8	67380	\N	1	\N
279	180	8	54564	\N	1	\N
280	181	8	53622	\N	1	\N
281	182	8	49375	\N	1	\N
282	183	8	47581	\N	1	\N
283	184	8	44624	\N	1	\N
284	185	8	44610	\N	1	\N
285	186	8	44006	\N	1	\N
286	187	8	42611	\N	1	\N
287	188	8	38631	\N	1	\N
288	189	8	35060	\N	1	\N
289	190	8	33105	\N	1	\N
290	191	8	32966	\N	1	\N
291	192	8	19109	\N	1	\N
292	193	8	16460	\N	1	\N
293	194	8	7886	\N	1	\N
294	195	8	7167	\N	1	\N
295	196	8	6795	\N	1	\N
296	197	8	6207	\N	1	\N
297	198	8	4656	\N	1	\N
298	199	8	4516	\N	1	\N
299	200	8	3265	\N	1	\N
300	201	84	2152	\N	1	\N
301	202	8	1920	\N	1	\N
302	203	8	1628	\N	1	\N
303	204	8	1435	\N	1	\N
304	205	8	1388	\N	1	\N
305	206	8	948	\N	1	\N
306	207	8	881	\N	1	\N
307	208	8	323	\N	1	\N
308	209	8	53	\N	1	\N
309	210	8	4	\N	1	\N
310	211	8	1	\N	1	\N
311	212	151	1435	\N	1	\N
312	213	8	1435	\N	1	\N
313	216	60	114	\N	1	\N
314	217	8	114	\N	1	\N
315	223	54	32966	\N	1	\N
316	224	8	32966	\N	1	\N
317	227	10	6175	\N	1	\N
318	228	8	6175	\N	1	\N
319	229	32	13060071	\N	0	\N
320	229	118	13060071	\N	0	\N
321	229	119	13060071	\N	1	\N
322	230	77	13060071	\N	1	\N
323	231	77	13060071	\N	1	\N
324	232	77	13060071	\N	1	\N
327	243	63	102	\N	0	\N
328	243	86	106	\N	1	\N
329	244	63	102	\N	0	\N
330	244	86	103	\N	1	\N
331	245	63	103	\N	0	\N
332	245	86	106	\N	1	\N
333	246	63	102	\N	0	\N
334	246	86	102	\N	1	\N
335	247	173	4632	\N	1	\N
336	248	168	4632	\N	1	\N
337	249	83	12852	\N	1	\N
338	250	8	12852	\N	1	\N
339	252	98	3265	\N	1	\N
340	253	8	3265	\N	1	\N
341	254	70	4516	\N	1	\N
342	255	8	4516	\N	1	\N
343	257	69	2637	\N	5	\N
344	257	171	398	\N	7	\N
345	257	153	1756	\N	6	\N
346	257	157	266	\N	8	\N
347	257	96	52163	\N	1	\N
348	257	27	15946	\N	3	\N
349	257	167	42576	\N	2	\N
350	257	131	5385	\N	4	\N
351	257	20	18	\N	9	\N
352	257	144	6	\N	10	\N
353	258	166	49802	\N	1	\N
354	259	69	2639	\N	2	\N
355	259	167	42590	\N	1	\N
356	261	65	42576	\N	2	\N
357	261	95	42590	\N	1	\N
358	262	65	52163	\N	1	\N
359	263	8	49802	\N	1	\N
360	264	65	15946	\N	1	\N
361	265	65	5385	\N	1	\N
362	266	95	2639	\N	1	\N
363	266	65	2637	\N	2	\N
364	267	65	1756	\N	1	\N
365	268	65	398	\N	1	\N
366	269	65	266	\N	1	\N
367	270	65	18	\N	1	\N
368	271	65	6	\N	1	\N
371	276	168	27068498	\N	1	\N
372	277	113	27068498	\N	1	\N
373	285	18	559496	\N	1	\N
374	286	50	502416	\N	1	\N
375	287	141	163787	\N	1	\N
376	288	71	130057	\N	1	\N
377	289	115	84168	\N	1	\N
378	290	169	46119	\N	1	\N
379	291	85	36871	\N	1	\N
380	292	53	27980	\N	1	\N
381	293	170	22096	\N	1	\N
382	294	143	17385	\N	1	\N
383	295	173	13973	\N	1	\N
384	296	42	13230	\N	1	\N
385	297	155	7636	\N	1	\N
386	298	55	3016	\N	1	\N
387	299	31	2027	\N	1	\N
388	300	152	1590	\N	1	\N
389	301	105	822	\N	1	\N
390	302	122	503	\N	1	\N
391	303	177	302	\N	1	\N
392	304	159	141	\N	1	\N
393	305	120	35	\N	1	\N
394	306	117	14	\N	1	\N
395	307	18	559496	\N	1	\N
396	308	50	502416	\N	1	\N
397	309	141	163787	\N	1	\N
398	310	71	130057	\N	1	\N
399	311	115	84168	\N	1	\N
400	312	169	46119	\N	1	\N
401	313	85	36871	\N	1	\N
402	314	53	27980	\N	1	\N
403	315	170	22096	\N	1	\N
404	316	143	17385	\N	1	\N
405	317	173	13973	\N	1	\N
406	318	42	13230	\N	1	\N
407	319	155	7636	\N	1	\N
408	320	55	3016	\N	1	\N
409	321	31	2027	\N	1	\N
410	322	152	1590	\N	1	\N
411	323	105	822	\N	1	\N
412	324	122	503	\N	1	\N
413	325	177	302	\N	1	\N
414	326	159	141	\N	1	\N
415	327	120	35	\N	1	\N
416	328	117	14	\N	1	\N
417	399	37	139183	\N	1	\N
418	400	8	139183	\N	1	\N
419	405	80	161948	\N	1	\N
420	406	8	161948	\N	1	\N
421	407	135	1628	\N	1	\N
422	408	8	1628	\N	1	\N
423	412	61	1	\N	1	\N
424	413	8	1	\N	1	\N
425	414	118	20389	\N	0	\N
426	414	32	20389	\N	0	\N
427	414	175	20389	\N	1	\N
428	415	65	20389	\N	1	\N
429	416	65	20389	\N	1	\N
430	417	65	20389	\N	1	\N
433	420	109	129846	\N	1	\N
434	421	8	129846	\N	1	\N
437	428	150	3146989	\N	2	\N
438	428	101	2465625	\N	0	\N
439	428	22	159872098	\N	1	\N
440	429	124	797122	\N	3	\N
441	429	101	869602	\N	0	\N
442	429	22	29390157	\N	1	\N
443	429	150	1694303	\N	2	\N
444	430	65	29390157	\N	2	\N
445	430	113	159872098	\N	1	\N
446	431	113	3146989	\N	1	\N
447	431	65	1694303	\N	2	\N
448	432	65	797122	\N	1	\N
449	433	65	869602	\N	2	\N
450	433	113	2465625	\N	1	\N
451	434	65	20389	\N	1	\N
452	435	95	20389	\N	1	\N
453	439	105	1125	\N	1	\N
454	440	168	1125	\N	1	\N
455	441	9	11996	\N	1	\N
456	442	8	11996	\N	1	\N
457	451	81	91708	\N	1	\N
458	452	163	41528	\N	1	\N
459	453	18	8690	\N	1	\N
460	453	57	2571	\N	2	\N
461	454	81	1	\N	1	\N
462	455	4	91708	\N	1	\N
463	455	64	1	\N	2	\N
464	456	8	41528	\N	1	\N
465	457	168	8690	\N	1	\N
466	458	168	2571	\N	1	\N
467	460	82	170627	\N	1	\N
468	461	8	170627	\N	1	\N
471	465	68	4656	\N	8	\N
472	465	137	16460	\N	5	\N
473	465	3	44624	\N	3	\N
474	465	94	7886	\N	6	\N
475	465	54	32966	\N	4	\N
476	465	151	1435	\N	9	\N
477	465	66	53622	\N	2	\N
478	465	14	6795	\N	7	\N
479	465	129	67380	\N	1	\N
480	467	8	67380	\N	1	\N
481	468	8	53622	\N	1	\N
482	469	8	44624	\N	1	\N
483	470	8	32966	\N	1	\N
484	471	8	16460	\N	1	\N
485	472	8	7886	\N	1	\N
486	473	8	6795	\N	1	\N
487	474	8	4656	\N	1	\N
488	475	8	1435	\N	1	\N
489	476	78	338501	\N	1	\N
490	476	114	4993	\N	6	\N
491	476	80	161948	\N	2	\N
492	476	37	139183	\N	3	\N
493	476	128	39739	\N	4	\N
494	476	52	22714	\N	5	\N
495	477	8	338501	\N	1	\N
496	478	8	161948	\N	1	\N
497	479	8	139183	\N	1	\N
498	480	8	39739	\N	1	\N
499	481	8	22714	\N	1	\N
500	482	8	4993	\N	1	\N
501	483	18	66336	\N	2	\N
502	483	141	144568	\N	1	\N
503	484	57	833	\N	3	\N
504	484	141	66336	\N	1	\N
505	484	18	45624	\N	2	\N
506	485	170	655	\N	2	\N
507	485	50	27993	\N	1	\N
508	485	155	21	\N	4	\N
509	485	152	517	\N	3	\N
510	486	85	7123	\N	1	\N
511	486	152	4581	\N	3	\N
512	486	81	6322	\N	2	\N
513	486	100	2467	\N	4	\N
514	487	53	5056	\N	2	\N
515	487	170	2397	\N	3	\N
516	487	155	4	\N	5	\N
517	487	115	11271	\N	1	\N
518	487	152	146	\N	4	\N
519	488	71	13463	\N	1	\N
520	489	53	7120	\N	1	\N
521	489	170	904	\N	3	\N
522	489	115	5056	\N	2	\N
523	490	57	457	\N	3	\N
524	490	81	7123	\N	1	\N
525	490	85	4909	\N	2	\N
526	491	50	517	\N	4	\N
527	491	81	4581	\N	1	\N
528	491	34	66	\N	8	\N
529	491	174	571	\N	3	\N
530	491	31	97	\N	7	\N
531	491	115	146	\N	6	\N
532	491	152	1192	\N	2	\N
533	491	117	4	\N	9	\N
534	491	169	158	\N	5	\N
535	492	57	1753	\N	3	\N
536	492	100	2634	\N	1	\N
537	492	81	2467	\N	2	\N
538	493	53	904	\N	3	\N
539	493	50	655	\N	4	\N
540	493	170	2560	\N	1	\N
541	493	115	2397	\N	2	\N
542	494	57	2690	\N	1	\N
543	494	100	1753	\N	2	\N
544	494	85	457	\N	4	\N
545	494	42	1	\N	5	\N
546	494	18	833	\N	3	\N
547	495	55	5313	\N	1	\N
548	496	169	4039	\N	1	\N
549	496	31	445	\N	2	\N
550	496	152	158	\N	3	\N
551	497	57	1	\N	3	\N
552	497	42	1841	\N	1	\N
553	497	173	551	\N	2	\N
554	498	143	2012	\N	1	\N
555	499	173	1453	\N	1	\N
556	499	42	551	\N	2	\N
557	500	155	1389	\N	1	\N
558	500	115	4	\N	3	\N
559	500	50	21	\N	2	\N
560	501	174	696	\N	1	\N
561	501	152	571	\N	2	\N
562	502	31	540	\N	1	\N
563	502	152	97	\N	3	\N
564	502	169	445	\N	2	\N
565	503	139	969	\N	1	\N
566	504	105	193	\N	1	\N
567	504	122	115	\N	2	\N
568	505	105	115	\N	2	\N
569	505	122	157	\N	1	\N
570	506	152	66	\N	1	\N
571	506	34	45	\N	2	\N
572	507	177	87	\N	1	\N
573	508	159	51	\N	1	\N
574	509	59	18	\N	1	\N
575	510	117	11	\N	1	\N
576	510	152	4	\N	2	\N
577	511	120	13	\N	1	\N
578	512	123	12	\N	1	\N
579	513	142	10	\N	1	\N
580	514	89	7	\N	1	\N
581	515	88	2	\N	1	\N
582	516	121	1	\N	1	\N
583	517	18	66336	\N	2	\N
584	517	141	144568	\N	1	\N
585	518	141	66336	\N	1	\N
586	518	18	45624	\N	2	\N
587	518	57	833	\N	3	\N
588	519	152	517	\N	3	\N
589	519	50	27993	\N	1	\N
590	519	170	655	\N	2	\N
591	519	155	21	\N	4	\N
592	520	152	4581	\N	3	\N
593	520	85	7123	\N	1	\N
594	520	81	6322	\N	2	\N
595	520	100	2467	\N	4	\N
596	521	152	146	\N	4	\N
597	521	115	11271	\N	1	\N
598	521	155	4	\N	5	\N
599	521	170	2397	\N	3	\N
600	521	53	5056	\N	2	\N
601	522	71	13463	\N	1	\N
602	523	115	5056	\N	2	\N
603	523	170	904	\N	3	\N
604	523	53	7120	\N	1	\N
605	524	81	7123	\N	1	\N
606	524	57	457	\N	3	\N
607	524	85	4909	\N	2	\N
608	525	81	4581	\N	1	\N
609	525	34	66	\N	8	\N
610	525	31	97	\N	7	\N
611	525	50	517	\N	4	\N
612	525	152	1192	\N	2	\N
613	525	115	146	\N	6	\N
614	525	174	571	\N	3	\N
615	525	117	4	\N	9	\N
616	525	169	158	\N	5	\N
617	526	57	1753	\N	3	\N
618	526	100	2634	\N	1	\N
619	526	81	2467	\N	2	\N
620	527	115	2397	\N	2	\N
621	527	50	655	\N	4	\N
622	527	170	2560	\N	1	\N
623	527	53	904	\N	3	\N
624	528	57	2690	\N	1	\N
625	528	100	1753	\N	2	\N
626	528	85	457	\N	4	\N
627	528	18	833	\N	3	\N
628	528	42	1	\N	5	\N
629	529	55	5313	\N	1	\N
630	530	169	4039	\N	1	\N
631	530	31	445	\N	2	\N
632	530	152	158	\N	3	\N
633	531	42	1841	\N	1	\N
634	531	173	551	\N	2	\N
635	531	57	1	\N	3	\N
636	532	143	2012	\N	1	\N
637	533	173	1453	\N	1	\N
638	533	42	551	\N	2	\N
639	534	155	1389	\N	1	\N
640	534	115	4	\N	3	\N
641	534	50	21	\N	2	\N
642	535	174	696	\N	1	\N
643	535	152	571	\N	2	\N
644	536	31	540	\N	1	\N
645	536	152	97	\N	3	\N
646	536	169	445	\N	2	\N
647	537	139	969	\N	1	\N
648	538	105	193	\N	1	\N
649	538	122	115	\N	2	\N
650	539	122	157	\N	1	\N
651	539	105	115	\N	2	\N
652	540	152	66	\N	1	\N
653	540	34	45	\N	2	\N
654	541	177	87	\N	1	\N
655	542	159	51	\N	1	\N
656	543	59	18	\N	1	\N
657	544	117	11	\N	1	\N
658	544	152	4	\N	2	\N
659	545	120	13	\N	1	\N
660	546	123	12	\N	1	\N
661	547	142	10	\N	1	\N
662	548	89	7	\N	1	\N
663	549	88	2	\N	1	\N
664	550	121	1	\N	1	\N
667	557	5	518692	\N	1	\N
668	558	8	518692	\N	1	\N
669	559	147	7138	\N	2	\N
670	559	146	4494600	\N	1	\N
671	560	146	30606	\N	1	\N
672	560	147	96	\N	2	\N
673	561	101	30606	\N	0	\N
674	561	150	4494600	\N	1	\N
675	562	150	7138	\N	1	\N
676	562	101	96	\N	0	\N
677	564	66	53622	\N	1	\N
678	565	8	53622	\N	1	\N
679	566	47	1578137	\N	1	\N
680	567	8	1578137	\N	1	\N
681	568	149	19109	\N	5	\N
682	568	26	399480	\N	2	\N
683	568	77	8855603	\N	1	\N
684	568	130	132986	\N	3	\N
685	568	49	42611	\N	4	\N
686	569	8	8855603	\N	1	\N
687	570	8	399480	\N	1	\N
688	571	8	132986	\N	1	\N
689	572	8	42611	\N	1	\N
690	573	8	19109	\N	1	\N
691	575	125	3	\N	1	\N
692	576	125	3	\N	1	\N
693	580	2	262697	\N	1	\N
694	581	8	262697	\N	1	\N
695	582	138	1388	\N	1	\N
696	583	8	1388	\N	1	\N
697	584	2	540276	\N	1	\N
698	585	8	540276	\N	1	\N
699	586	114	4993	\N	1	\N
700	587	8	4993	\N	1	\N
703	590	118	23945784	\N	0	\N
704	590	32	23945784	\N	0	\N
705	590	45	23945784	\N	1	\N
706	591	113	23945784	\N	1	\N
707	592	113	23945784	\N	1	\N
708	593	113	23945784	\N	1	\N
709	594	12	49375	\N	1	\N
710	595	8	49375	\N	1	\N
711	686	84	39487	\N	1	\N
712	687	8	39487	\N	1	\N
713	691	125	121	\N	1	\N
714	691	75	18	\N	0	\N
715	692	125	136	\N	1	\N
716	693	125	56	\N	1	\N
717	694	75	4	\N	0	\N
718	695	125	1	\N	1	\N
719	696	125	1	\N	1	\N
720	697	86	136	\N	1	\N
721	697	63	121	\N	2	\N
722	697	156	56	\N	3	\N
723	697	33	1	\N	0	\N
724	697	160	1	\N	0	\N
725	698	91	4	\N	0	\N
726	698	63	18	\N	1	\N
729	705	146	76	\N	1	\N
730	706	146	4	\N	1	\N
731	707	101	4	\N	0	\N
732	707	150	76	\N	1	\N
733	708	44	652	\N	1	\N
734	709	8	652	\N	1	\N
735	710	30	2152	\N	1	\N
736	711	84	2152	\N	1	\N
737	712	2	4549214	\N	1	\N
738	713	8	4549214	\N	1	\N
739	717	163	41528	\N	1	\N
740	717	43	14	\N	3	\N
741	717	41	90	\N	2	\N
742	718	8	41528	\N	1	\N
743	719	8	90	\N	1	\N
744	720	8	14	\N	1	\N
745	721	149	19109	\N	1	\N
746	722	8	19109	\N	1	\N
749	730	141	6185	\N	1	\N
750	732	168	6185	\N	1	\N
751	734	4	20466403	\N	1	\N
752	735	8	20466403	\N	1	\N
753	738	164	47581	\N	1	\N
754	739	8	47581	\N	1	\N
755	740	38	33105	\N	2	\N
756	740	16	948	\N	3	\N
757	740	97	38631	\N	1	\N
758	741	8	38631	\N	1	\N
759	742	8	33105	\N	1	\N
760	743	8	948	\N	1	\N
761	744	132	4738	\N	1	\N
762	745	8	4738	\N	1	\N
763	746	6	122332	\N	2	\N
764	746	48	175584	\N	1	\N
765	746	79	14585	\N	3	\N
766	747	8	175584	\N	1	\N
767	748	8	122332	\N	1	\N
768	749	8	14585	\N	1	\N
771	752	145	42388	\N	1	\N
772	753	8	42388	\N	1	\N
773	754	73	14453	\N	1	\N
774	755	65	14453	\N	1	\N
775	756	108	391	\N	1	\N
776	757	108	172	\N	1	\N
777	758	108	136	\N	1	\N
778	759	108	119	\N	1	\N
779	760	108	56	\N	1	\N
780	762	108	391	\N	1	\N
781	763	108	199	\N	1	\N
782	764	108	170	\N	1	\N
783	765	108	6	\N	1	\N
784	766	108	5	\N	1	\N
785	767	108	5	\N	1	\N
786	768	108	3	\N	1	\N
787	769	108	3	\N	1	\N
788	770	108	1	\N	1	\N
789	771	108	1	\N	1	\N
790	772	175	5	\N	0	\N
791	772	156	56	\N	5	\N
792	772	118	391	\N	0	\N
793	772	119	199	\N	0	\N
794	772	160	1	\N	0	\N
795	772	125	172	\N	2	\N
796	772	45	5	\N	0	\N
797	772	176	3	\N	0	\N
798	772	63	119	\N	4	\N
799	772	86	136	\N	3	\N
800	772	58	170	\N	0	\N
801	772	103	6	\N	0	\N
802	772	33	1	\N	0	\N
803	772	158	3	\N	0	\N
804	772	32	391	\N	1	\N
805	775	51	7167	\N	2	\N
806	775	70	4516	\N	3	\N
807	775	111	54564	\N	1	\N
808	775	135	1628	\N	4	\N
809	776	8	54564	\N	1	\N
810	777	8	7167	\N	1	\N
811	778	8	4516	\N	1	\N
812	779	8	1628	\N	1	\N
813	781	67	3963	\N	1	\N
814	782	8	3963	\N	1	\N
815	788	56	35060	\N	1	\N
816	789	8	35060	\N	1	\N
817	790	155	965887	\N	1	\N
818	791	113	965887	\N	1	\N
819	792	26	399480	\N	1	\N
820	793	8	399480	\N	1	\N
821	799	92	320598	\N	1	\N
822	800	8	320598	\N	1	\N
823	802	46	1	\N	1	\N
824	803	46	1	\N	1	\N
825	806	2	17282025	\N	1	\N
826	807	8	17282025	\N	1	\N
827	808	28	122441	\N	1	\N
828	809	8	122441	\N	1	\N
829	810	3	44624	\N	1	\N
830	811	8	44624	\N	1	\N
831	812	2	326038	\N	1	\N
832	813	8	326038	\N	1	\N
833	814	43	14	\N	1	\N
834	815	8	14	\N	1	\N
835	816	137	16460	\N	1	\N
836	817	8	16460	\N	1	\N
837	820	136	6207	\N	1	\N
838	821	8	6207	\N	1	\N
839	822	72	574	\N	1	\N
840	823	8	574	\N	1	\N
841	824	110	31753	\N	1	\N
842	825	8	31753	\N	1	\N
843	826	116	4181	\N	1	\N
844	827	8	4181	\N	1	\N
845	830	111	54564	\N	1	\N
846	831	8	54564	\N	1	\N
847	832	64	89586	\N	1	\N
848	833	8	89586	\N	1	\N
849	834	15	1598	\N	1	\N
850	835	8	1598	\N	1	\N
851	840	68	4656	\N	1	\N
852	841	8	4656	\N	1	\N
855	852	19	11	\N	1	\N
856	853	8	11	\N	1	\N
857	938	172	881	\N	1	\N
858	939	8	881	\N	1	\N
859	940	22	1042717	\N	1	\N
860	941	22	3657	\N	1	\N
861	942	150	1042717	\N	1	\N
862	942	101	3657	\N	0	\N
863	943	143	73897474	\N	1	\N
864	944	113	73897474	\N	1	\N
865	947	99	53	\N	1	\N
866	948	8	53	\N	1	\N
867	949	40	2122	\N	6	\N
868	949	47	1578137	\N	1	\N
869	949	28	122441	\N	2	\N
870	949	67	3963	\N	5	\N
871	949	132	4738	\N	4	\N
872	949	110	31753	\N	3	\N
873	950	8	1578137	\N	1	\N
874	951	8	122441	\N	1	\N
875	952	8	31753	\N	1	\N
876	953	8	4738	\N	1	\N
877	954	8	3963	\N	1	\N
878	955	8	2122	\N	1	\N
879	956	97	38631	\N	1	\N
880	957	8	38631	\N	1	\N
881	958	113	10819190	\N	1	\N
882	959	113	1545	\N	1	\N
883	960	113	1119	\N	1	\N
884	961	113	594	\N	1	\N
885	962	113	218	\N	1	\N
886	963	113	114	\N	1	\N
887	964	113	51	\N	1	\N
888	965	113	3	\N	1	\N
889	966	80	1119	\N	3	\N
890	966	78	1545	\N	2	\N
891	966	47	218	\N	5	\N
892	966	30	114	\N	6	\N
893	966	92	3	\N	8	\N
894	966	93	51	\N	7	\N
895	966	48	594	\N	4	\N
896	966	2	10819190	\N	1	\N
897	967	7	44610	\N	1	\N
898	968	8	44610	\N	1	\N
899	971	6	122332	\N	1	\N
900	972	8	122332	\N	1	\N
901	974	49	42611	\N	1	\N
902	975	8	42611	\N	1	\N
903	979	133	33504	\N	1	\N
904	980	8	33504	\N	1	\N
905	982	69	2639	\N	1	\N
906	983	69	2637	\N	1	\N
907	984	95	2639	\N	1	\N
908	984	65	2637	\N	2	\N
909	990	171	398	\N	6	\N
910	990	153	411	\N	5	\N
911	990	157	89	\N	7	\N
912	990	96	31774	\N	1	\N
913	990	27	15946	\N	3	\N
914	990	167	22203	\N	2	\N
915	990	131	702	\N	4	\N
916	990	20	18	\N	8	\N
917	990	144	6	\N	9	\N
918	991	167	22217	\N	1	\N
919	992	166	7420	\N	1	\N
920	993	65	22203	\N	2	\N
921	993	95	22217	\N	1	\N
922	994	65	31774	\N	1	\N
923	995	65	15946	\N	1	\N
924	996	8	7420	\N	1	\N
925	997	65	702	\N	1	\N
926	998	65	411	\N	1	\N
927	999	65	398	\N	1	\N
928	1000	65	89	\N	1	\N
929	1001	65	18	\N	1	\N
930	1002	65	6	\N	1	\N
933	1007	58	190640065	\N	1	\N
934	1007	32	190640065	\N	0	\N
935	1007	118	190640065	\N	0	\N
936	1008	118	797122	\N	0	\N
937	1008	58	797122	\N	1	\N
938	1008	32	797122	\N	0	\N
939	1009	22	190640065	\N	1	\N
940	1009	124	797122	\N	2	\N
941	1010	124	797122	\N	2	\N
942	1010	22	190640065	\N	1	\N
943	1011	22	190640065	\N	1	\N
944	1011	124	797122	\N	2	\N
945	1012	125	472	\N	1	\N
946	1013	75	4	\N	0	\N
947	1014	125	472	\N	1	\N
948	1015	75	4	\N	0	\N
949	1058	38	33105	\N	1	\N
950	1059	8	33105	\N	1	\N
951	1060	21	4	\N	1	\N
952	1061	8	4	\N	1	\N
953	1062	125	119	\N	1	\N
954	1062	75	8	\N	0	\N
955	1063	125	136	\N	1	\N
956	1064	125	6	\N	1	\N
957	1065	75	4	\N	0	\N
958	1066	125	1	\N	1	\N
959	1067	125	1	\N	1	\N
960	1068	86	136	\N	1	\N
961	1068	63	119	\N	2	\N
962	1068	156	6	\N	3	\N
963	1068	33	1	\N	0	\N
964	1068	160	1	\N	0	\N
965	1069	91	4	\N	0	\N
966	1069	63	8	\N	1	\N
967	1071	64	26534	\N	1	\N
968	1071	4	14587	\N	2	\N
969	1072	84	26534	\N	1	\N
970	1073	84	14587	\N	1	\N
971	1074	79	14585	\N	1	\N
972	1075	8	14585	\N	1	\N
973	1077	12	49375	\N	2	\N
974	1077	99	53	\N	6	\N
975	1077	154	1920	\N	5	\N
976	1077	56	35060	\N	4	\N
977	1077	164	47581	\N	3	\N
978	1077	92	320598	\N	1	\N
979	1078	8	320598	\N	1	\N
980	1079	8	49375	\N	1	\N
981	1080	8	47581	\N	1	\N
982	1081	8	35060	\N	1	\N
983	1082	8	1920	\N	1	\N
984	1083	8	53	\N	1	\N
985	1085	40	2122	\N	1	\N
986	1086	8	2122	\N	1	\N
987	1132	162	84323	\N	1	\N
988	1133	8	84323	\N	1	\N
989	1134	11	2073	\N	1	\N
990	1135	8	2073	\N	1	\N
991	1136	158	12074	\N	1	\N
992	1136	118	12074	\N	0	\N
993	1136	32	12074	\N	0	\N
994	1137	113	12074	\N	1	\N
995	1138	113	12074	\N	1	\N
996	1139	113	12074	\N	1	\N
997	1142	82	170627	\N	2	\N
998	1142	165	182078	\N	1	\N
999	1142	39	44006	\N	3	\N
1000	1143	8	182078	\N	1	\N
1001	1144	8	170627	\N	1	\N
1002	1145	8	44006	\N	1	\N
1003	1146	8	42382	\N	1	\N
1004	1147	65	42382	\N	1	\N
1007	1150	52	22714	\N	1	\N
1008	1151	8	22714	\N	1	\N
1009	1153	154	1920	\N	1	\N
1010	1154	8	1920	\N	1	\N
1011	1159	131	5210	\N	3	\N
1012	1159	27	15392	\N	2	\N
1013	1159	96	31774	\N	1	\N
1014	1160	69	2613	\N	2	\N
1015	1160	167	22203	\N	1	\N
1016	1161	166	7420	\N	1	\N
1017	1162	27	477	\N	1	\N
1018	1162	131	11	\N	3	\N
1019	1162	153	411	\N	2	\N
1020	1163	27	77	\N	3	\N
1021	1163	131	164	\N	1	\N
1022	1163	157	89	\N	2	\N
1023	1164	96	31774	\N	1	\N
1024	1165	167	22203	\N	1	\N
1025	1166	157	77	\N	3	\N
1026	1166	153	477	\N	2	\N
1027	1166	96	15392	\N	1	\N
1028	1167	166	7420	\N	1	\N
1029	1168	96	5210	\N	1	\N
1030	1168	157	164	\N	2	\N
1031	1168	153	11	\N	3	\N
1032	1169	167	2613	\N	1	\N
1033	1170	153	411	\N	1	\N
1034	1171	157	89	\N	1	\N
1035	1173	125	190643857	\N	1	\N
1036	1174	125	73897474	\N	1	\N
1037	1175	125	21831239	\N	1	\N
1038	1176	125	20466403	\N	1	\N
1039	1177	125	8855603	\N	1	\N
1040	1178	125	4494676	\N	1	\N
1041	1179	125	1578137	\N	1	\N
1042	1180	125	797122	\N	1	\N
1043	1181	125	576742	\N	1	\N
1044	1182	125	518692	\N	1	\N
1045	1183	125	399480	\N	1	\N
1046	1184	125	338501	\N	1	\N
1047	1185	125	320598	\N	1	\N
1048	1186	125	182078	\N	1	\N
1049	1187	125	175584	\N	1	\N
1050	1188	125	170627	\N	1	\N
1051	1189	125	161948	\N	1	\N
1052	1190	125	144568	\N	1	\N
1053	1191	125	139183	\N	1	\N
1054	1192	125	132986	\N	1	\N
1055	1193	125	129846	\N	1	\N
1056	1194	125	122441	\N	1	\N
1057	1195	125	122332	\N	1	\N
1058	1196	125	89586	\N	1	\N
1059	1197	125	84323	\N	1	\N
1060	1198	125	76998	\N	1	\N
1061	1199	125	67380	\N	1	\N
1062	1200	125	54564	\N	1	\N
1063	1201	125	53622	\N	1	\N
1064	1202	125	52163	\N	1	\N
1065	1203	125	49802	\N	1	\N
1066	1204	125	49375	\N	1	\N
1067	1205	125	47581	\N	1	\N
1068	1206	125	45624	\N	1	\N
1069	1207	125	44624	\N	1	\N
1070	1208	125	44610	\N	1	\N
1071	1209	125	44006	\N	1	\N
1072	1210	125	42611	\N	1	\N
1073	1211	125	42576	\N	1	\N
1074	1212	125	42388	\N	1	\N
1075	1213	125	42382	\N	1	\N
1076	1214	125	41528	\N	1	\N
1077	1215	125	39739	\N	1	\N
1078	1216	125	39487	\N	1	\N
1079	1217	125	38631	\N	1	\N
1080	1218	125	35060	\N	1	\N
1081	1219	125	33504	\N	1	\N
1082	1220	125	33105	\N	1	\N
1083	1221	125	32966	\N	1	\N
1084	1222	125	31753	\N	1	\N
1085	1223	125	27993	\N	1	\N
1086	1224	125	23226	\N	1	\N
1087	1225	125	22714	\N	1	\N
1088	1226	125	20476	\N	1	\N
1089	1227	125	20395	\N	1	\N
1090	1228	125	20395	\N	1	\N
1091	1229	125	20389	\N	1	\N
1092	1230	125	19109	\N	1	\N
1093	1231	125	16460	\N	1	\N
1094	1232	125	15946	\N	1	\N
1095	1233	125	14585	\N	1	\N
1096	1234	125	14453	\N	1	\N
1097	1235	125	13531	\N	1	\N
1098	1236	125	13463	\N	1	\N
1099	1237	125	12852	\N	1	\N
1100	1238	125	11996	\N	1	\N
1101	1239	125	11271	\N	1	\N
1102	1240	125	7886	\N	1	\N
1103	1241	125	7167	\N	1	\N
1104	1242	125	7138	\N	1	\N
1105	1243	125	7120	\N	1	\N
1106	1244	125	6795	\N	1	\N
1107	1245	125	6322	\N	1	\N
1108	1246	125	6207	\N	1	\N
1109	1247	125	6175	\N	1	\N
1110	1248	125	5385	\N	1	\N
1111	1249	125	5313	\N	1	\N
1112	1250	125	4993	\N	1	\N
1113	1251	125	4909	\N	1	\N
1114	1252	125	4837	\N	1	\N
1115	1253	125	4738	\N	1	\N
1116	1254	125	4656	\N	1	\N
1117	1255	125	4516	\N	1	\N
1118	1256	125	4181	\N	1	\N
1119	1257	125	4039	\N	1	\N
1120	1258	125	3963	\N	1	\N
1121	1259	125	3265	\N	1	\N
1122	1260	125	2690	\N	1	\N
1123	1261	125	2637	\N	1	\N
1124	1262	125	2634	\N	1	\N
1125	1263	125	2560	\N	1	\N
1126	1264	125	2401	\N	1	\N
1127	1265	125	2152	\N	1	\N
1128	1266	125	2122	\N	1	\N
1129	1267	125	2073	\N	1	\N
1130	1268	125	2010	\N	1	\N
1131	1269	125	1920	\N	1	\N
1132	1270	125	1841	\N	1	\N
1133	1271	125	1756	\N	1	\N
1134	1272	125	1628	\N	1	\N
1135	1273	125	1598	\N	1	\N
1136	1274	125	1453	\N	1	\N
1137	1275	125	1435	\N	1	\N
1138	1276	125	1389	\N	1	\N
1139	1277	125	1388	\N	1	\N
1140	1278	125	1192	\N	1	\N
1141	1279	125	782	\N	1	\N
1142	1280	125	987	\N	1	\N
1143	1281	125	969	\N	1	\N
1144	1282	125	948	\N	1	\N
1145	1283	125	881	\N	1	\N
1146	1284	125	696	\N	1	\N
1147	1285	125	652	\N	1	\N
1148	1286	125	574	\N	1	\N
1149	1287	125	540	\N	1	\N
1150	1288	125	430	\N	1	\N
1151	1289	125	398	\N	1	\N
1152	1290	125	376	\N	1	\N
1153	1291	125	323	\N	1	\N
1154	1292	75	124	\N	0	\N
1155	1293	125	266	\N	1	\N
1156	1294	75	137	\N	0	\N
1157	1295	125	225	\N	1	\N
1158	1296	75	208	\N	0	\N
1159	1297	125	193	\N	1	\N
1160	1300	125	114	\N	1	\N
1161	1302	125	90	\N	1	\N
1162	1304	75	56	\N	0	\N
1163	1305	125	53	\N	1	\N
1164	1306	125	51	\N	1	\N
1165	1307	125	45	\N	1	\N
1166	1308	125	18	\N	1	\N
1167	1309	125	18	\N	1	\N
1168	1310	125	14	\N	1	\N
1169	1311	125	13	\N	1	\N
1170	1313	125	11	\N	1	\N
1171	1314	125	11	\N	1	\N
1172	1315	125	10	\N	1	\N
1173	1319	125	7	\N	1	\N
1174	1320	75	5	\N	0	\N
1175	1321	125	6	\N	1	\N
1176	1322	125	4	\N	1	\N
1177	1325	125	3	\N	1	\N
1178	1329	125	2	\N	1	\N
1179	1330	75	2	\N	0	\N
1180	1334	125	1	\N	1	\N
1181	1336	125	1	\N	1	\N
1182	1337	125	3926	\N	1	\N
1183	1338	125	782	\N	1	\N
1184	1339	125	398	\N	1	\N
1185	1340	125	340	\N	1	\N
1186	1341	125	12	\N	1	\N
1187	1342	125	10	\N	1	\N
1188	1344	125	10	\N	1	\N
1189	1345	125	6	\N	1	\N
1190	1346	125	6	\N	1	\N
1191	1347	75	4	\N	0	\N
1192	1348	75	2	\N	0	\N
1193	1349	75	1	\N	0	\N
1194	1350	110	31753	\N	50	\N
1195	1350	162	84323	\N	25	\N
1196	1350	78	338501	\N	12	\N
1197	1350	150	576742	\N	9	\N
1198	1350	9	11996	\N	66	\N
1199	1350	83	12852	\N	65	\N
1200	1350	133	33504	\N	47	\N
1201	1350	29	323	\N	119	\N
1202	1350	84	39487	\N	44	\N
1203	1350	101	3926	\N	0	\N
1204	1350	102	430	\N	116	\N
1205	1350	60	114	\N	123	\N
1206	1350	87	225	\N	121	\N
1207	1350	19	11	\N	132	\N
1208	1350	20	18	\N	128	\N
1209	1350	105	193	\N	122	\N
1210	1350	4	20466403	\N	4	\N
1211	1350	167	42576	\N	39	\N
1212	1350	152	1192	\N	106	\N
1213	1350	137	16460	\N	59	\N
1214	1350	15	1598	\N	101	\N
1215	1350	41	90	\N	124	\N
1216	1350	175	10	\N	0	\N
1217	1350	44	652	\N	113	\N
1218	1350	51	7167	\N	69	\N
1219	1350	97	38631	\N	45	\N
1220	1350	54	32966	\N	49	\N
1221	1350	170	2560	\N	91	\N
1222	1350	18	45624	\N	34	\N
1223	1350	172	881	\N	110	\N
1224	1350	142	10	\N	134	\N
1225	1350	155	1389	\N	104	\N
1226	1350	43	14	\N	130	\N
1227	1350	21	4	\N	137	\N
1228	1350	37	139183	\N	19	\N
1229	1350	27	15946	\N	60	\N
1230	1350	134	2401	\N	92	\N
1231	1350	98	3265	\N	87	\N
1232	1350	168	13531	\N	63	\N
1233	1350	139	969	\N	108	\N
1234	1350	173	1453	\N	102	\N
1235	1350	59	18	\N	129	\N
1236	1350	158	6	\N	0	\N
1237	1350	104	3	\N	138	\N
1238	1350	64	89586	\N	24	\N
1239	1350	65	20389	\N	57	\N
1240	1350	95	20476	\N	54	\N
1241	1350	8	42382	\N	41	\N
1242	1350	96	52163	\N	30	\N
1243	1350	66	53622	\N	29	\N
1244	1350	136	6207	\N	74	\N
1245	1350	171	398	\N	117	\N
1246	1350	57	2690	\N	88	\N
1247	1350	119	398	\N	0	\N
1248	1350	22	190643857	\N	1	\N
1249	1350	124	797122	\N	8	\N
1250	1350	93	23226	\N	52	\N
1251	1350	49	42611	\N	38	\N
1252	1350	112	4837	\N	80	\N
1253	1350	82	170627	\N	16	\N
1254	1350	53	7120	\N	71	\N
1255	1350	67	3963	\N	86	\N
1256	1350	116	4181	\N	84	\N
1257	1350	135	1628	\N	100	\N
1258	1350	138	1388	\N	105	\N
1259	1350	140	376	\N	118	\N
1260	1350	71	13463	\N	64	\N
1261	1350	174	696	\N	112	\N
1262	1350	72	574	\N	114	\N
1263	1350	73	14453	\N	62	\N
1264	1350	147	7138	\N	70	\N
1265	1350	149	19109	\N	58	\N
1266	1350	129	67380	\N	27	\N
1267	1350	166	49802	\N	31	\N
1268	1350	52	22714	\N	53	\N
1269	1350	10	6175	\N	75	\N
1270	1350	151	1435	\N	103	\N
1271	1350	13	987	\N	107	\N
1272	1350	153	1756	\N	99	\N
1273	1350	118	782	\N	0	\N
1274	1350	31	540	\N	115	\N
1275	1350	121	1	\N	140	\N
1276	1350	89	7	\N	135	\N
1277	1350	74	20395	\N	55	\N
1278	1350	92	320598	\N	13	\N
1279	1350	3	44624	\N	35	\N
1280	1350	109	129846	\N	21	\N
1281	1350	6	122332	\N	23	\N
1282	1350	163	41528	\N	42	\N
1283	1350	164	47581	\N	33	\N
1284	1350	80	161948	\N	17	\N
1285	1350	50	27993	\N	51	\N
1286	1350	114	4993	\N	78	\N
1287	1350	115	11271	\N	67	\N
1288	1350	68	4656	\N	82	\N
1289	1350	132	4738	\N	81	\N
1290	1350	11	2073	\N	95	\N
1291	1350	55	5313	\N	77	\N
1292	1350	56	35060	\N	46	\N
1293	1350	70	4516	\N	83	\N
1294	1350	169	4039	\N	85	\N
1295	1350	99	53	\N	125	\N
1296	1350	143	2010	\N	96	\N
1297	1350	120	13	\N	131	\N
1298	1350	159	51	\N	126	\N
1299	1350	106	20395	\N	56	\N
1300	1350	146	4494676	\N	6	\N
1301	1350	5	518692	\N	10	\N
1302	1350	94	7886	\N	68	\N
1303	1350	38	33105	\N	48	\N
1304	1350	39	44006	\N	37	\N
1305	1350	131	5385	\N	76	\N
1306	1350	154	1920	\N	97	\N
1307	1350	16	948	\N	109	\N
1308	1350	85	4909	\N	79	\N
1309	1350	32	782	\N	111	\N
1310	1350	88	2	\N	139	\N
1311	1350	61	1	\N	141	\N
1312	1350	34	45	\N	127	\N
1313	1350	145	42388	\N	40	\N
1314	1350	47	1578137	\N	7	\N
1315	1350	2	21831239	\N	3	\N
1316	1350	26	399480	\N	11	\N
1317	1350	111	54564	\N	28	\N
1318	1350	128	39739	\N	43	\N
1319	1350	7	44610	\N	36	\N
1320	1350	130	132986	\N	20	\N
1321	1350	81	6322	\N	73	\N
1322	1350	40	2122	\N	94	\N
1323	1350	69	2637	\N	89	\N
1324	1350	14	6795	\N	72	\N
1325	1350	30	2152	\N	93	\N
1326	1350	100	2634	\N	90	\N
1327	1350	144	6	\N	136	\N
1328	1350	103	12	\N	0	\N
1329	1350	157	266	\N	120	\N
1330	1350	77	8855603	\N	5	\N
1331	1350	48	175584	\N	15	\N
1332	1350	79	14585	\N	61	\N
1333	1350	165	182078	\N	14	\N
1334	1350	113	73897474	\N	2	\N
1335	1350	28	122441	\N	22	\N
1336	1350	12	49375	\N	32	\N
1337	1350	17	76998	\N	26	\N
1338	1350	141	144568	\N	18	\N
1339	1350	42	1841	\N	98	\N
1340	1350	117	11	\N	133	\N
1341	1350	58	340	\N	0	\N
1342	1350	176	6	\N	0	\N
1343	1350	45	10	\N	0	\N
1344	1351	33	2	\N	0	\N
1345	1351	156	56	\N	4	\N
1346	1351	86	137	\N	2	\N
1347	1351	108	2	\N	6	\N
1348	1351	76	5	\N	5	\N
1349	1351	91	4	\N	0	\N
1350	1351	125	208	\N	1	\N
1351	1351	63	124	\N	3	\N
1352	1351	160	1	\N	0	\N
1353	1352	78	17541	\N	2	\N
1354	1352	80	25767	\N	1	\N
1355	1352	48	2253	\N	6	\N
1356	1352	140	10522	\N	4	\N
1357	1352	102	1031	\N	7	\N
1358	1352	87	2780	\N	5	\N
1359	1352	47	16642	\N	3	\N
1360	1353	163	2140	\N	1	\N
1361	1354	17	25767	\N	1	\N
1362	1355	17	17541	\N	1	\N
1363	1356	17	16642	\N	1	\N
1364	1357	17	10522	\N	1	\N
1365	1358	17	2780	\N	1	\N
1366	1359	17	2253	\N	1	\N
1367	1360	30	2140	\N	1	\N
1368	1361	17	1031	\N	1	\N
1369	1362	17	76998	\N	1	\N
1370	1363	84	76998	\N	1	\N
1371	1366	77	8855603	\N	1	\N
1372	1367	8	8855603	\N	1	\N
1375	1370	95	20519	\N	1	\N
1376	1371	65	20519	\N	1	\N
1379	1374	118	73897474	\N	0	\N
1380	1374	32	73897474	\N	0	\N
1381	1374	176	73897474	\N	1	\N
1382	1375	176	21831239	\N	1	\N
1383	1375	32	21831239	\N	0	\N
1384	1375	118	21831239	\N	0	\N
1385	1376	118	20466403	\N	0	\N
1386	1376	176	20466403	\N	1	\N
1387	1376	32	20466403	\N	0	\N
1388	1377	32	8855603	\N	0	\N
1389	1377	118	8855603	\N	0	\N
1390	1377	176	8855603	\N	1	\N
1391	1378	32	1578137	\N	0	\N
1392	1378	118	1578137	\N	0	\N
1393	1378	176	1578137	\N	1	\N
1394	1379	32	518692	\N	0	\N
1395	1379	118	518692	\N	0	\N
1396	1379	176	518692	\N	1	\N
1397	1380	32	399480	\N	0	\N
1398	1380	176	399480	\N	1	\N
1399	1380	118	399480	\N	0	\N
1400	1381	32	338501	\N	0	\N
1401	1381	118	338501	\N	0	\N
1402	1381	176	338501	\N	1	\N
1403	1382	118	320598	\N	0	\N
1404	1382	32	320598	\N	0	\N
1405	1382	176	320598	\N	1	\N
1406	1383	118	182078	\N	0	\N
1407	1383	176	182078	\N	1	\N
1408	1383	32	182078	\N	0	\N
1409	1384	118	175584	\N	0	\N
1410	1384	32	175584	\N	0	\N
1411	1384	176	175584	\N	1	\N
1412	1385	118	170627	\N	0	\N
1413	1385	32	170627	\N	0	\N
1414	1385	176	170627	\N	1	\N
1415	1386	176	161948	\N	1	\N
1416	1386	118	161948	\N	0	\N
1417	1386	32	161948	\N	0	\N
1418	1387	32	139183	\N	0	\N
1419	1387	118	139183	\N	0	\N
1420	1387	176	139183	\N	1	\N
1421	1388	118	132986	\N	0	\N
1422	1388	176	132986	\N	1	\N
1423	1388	32	132986	\N	0	\N
1424	1389	176	129846	\N	1	\N
1425	1389	118	129846	\N	0	\N
1426	1389	32	129846	\N	0	\N
1427	1390	176	122441	\N	1	\N
1428	1390	32	122441	\N	0	\N
1429	1390	118	122441	\N	0	\N
1430	1391	118	122332	\N	0	\N
1431	1391	176	122332	\N	1	\N
1432	1391	32	122332	\N	0	\N
1433	1392	118	89586	\N	0	\N
1434	1392	32	89586	\N	0	\N
1435	1392	176	89586	\N	1	\N
1436	1393	32	84323	\N	0	\N
1437	1393	118	84323	\N	0	\N
1438	1393	176	84323	\N	1	\N
1439	1394	176	76998	\N	1	\N
1440	1394	118	76998	\N	0	\N
1441	1394	32	76998	\N	0	\N
1442	1395	32	67380	\N	0	\N
1443	1395	176	67380	\N	1	\N
1444	1395	118	67380	\N	0	\N
1445	1396	118	54564	\N	0	\N
1446	1396	176	54564	\N	1	\N
1447	1396	32	54564	\N	0	\N
1448	1397	32	53622	\N	0	\N
1449	1397	176	53622	\N	1	\N
1450	1397	118	53622	\N	0	\N
1451	1398	176	49375	\N	1	\N
1452	1398	118	49375	\N	0	\N
1453	1398	32	49375	\N	0	\N
1454	1399	176	47581	\N	1	\N
1455	1399	118	47581	\N	0	\N
1456	1399	32	47581	\N	0	\N
1457	1400	118	44624	\N	0	\N
1458	1400	176	44624	\N	1	\N
1459	1400	32	44624	\N	0	\N
1460	1401	32	44610	\N	0	\N
1461	1401	176	44610	\N	1	\N
1462	1401	118	44610	\N	0	\N
1463	1402	32	44006	\N	0	\N
1464	1402	118	44006	\N	0	\N
1465	1402	176	44006	\N	1	\N
1466	1403	176	42611	\N	1	\N
1467	1403	118	42611	\N	0	\N
1468	1403	32	42611	\N	0	\N
1469	1404	32	41528	\N	0	\N
1470	1404	118	41528	\N	0	\N
1471	1404	176	41528	\N	1	\N
1472	1405	118	39739	\N	0	\N
1473	1405	176	39739	\N	1	\N
1474	1405	32	39739	\N	0	\N
1475	1406	118	38631	\N	0	\N
1476	1406	176	38631	\N	1	\N
1477	1406	32	38631	\N	0	\N
1478	1407	32	35060	\N	0	\N
1479	1407	176	35060	\N	1	\N
1480	1407	118	35060	\N	0	\N
1481	1408	32	33504	\N	0	\N
1482	1408	118	33504	\N	0	\N
1483	1408	176	33504	\N	1	\N
1484	1409	176	33105	\N	1	\N
1485	1409	118	33105	\N	0	\N
1486	1409	32	33105	\N	0	\N
1487	1410	176	32966	\N	1	\N
1488	1410	118	32966	\N	0	\N
1489	1410	32	32966	\N	0	\N
1490	1411	32	31753	\N	0	\N
1491	1411	176	31753	\N	1	\N
1492	1411	118	31753	\N	0	\N
1493	1412	118	23226	\N	0	\N
1494	1412	32	23226	\N	0	\N
1495	1412	176	23226	\N	1	\N
1496	1413	118	22714	\N	0	\N
1497	1413	176	22714	\N	1	\N
1498	1413	32	22714	\N	0	\N
1499	1414	32	19109	\N	0	\N
1500	1414	118	19109	\N	0	\N
1501	1414	176	19109	\N	1	\N
1502	1415	118	16460	\N	0	\N
1503	1415	176	16460	\N	1	\N
1504	1415	32	16460	\N	0	\N
1505	1416	176	14585	\N	1	\N
1506	1416	118	14585	\N	0	\N
1507	1416	32	14585	\N	0	\N
1508	1417	118	12852	\N	0	\N
1509	1417	176	12852	\N	1	\N
1510	1417	32	12852	\N	0	\N
1511	1418	176	11996	\N	1	\N
1512	1418	32	11996	\N	0	\N
1513	1418	118	11996	\N	0	\N
1514	1419	118	7886	\N	0	\N
1515	1419	176	7886	\N	1	\N
1516	1419	32	7886	\N	0	\N
1517	1420	118	7167	\N	0	\N
1518	1420	176	7167	\N	1	\N
1519	1420	32	7167	\N	0	\N
1520	1421	118	6795	\N	0	\N
1521	1421	32	6795	\N	0	\N
1522	1421	176	6795	\N	1	\N
1523	1422	118	6207	\N	0	\N
1524	1422	32	6207	\N	0	\N
1525	1422	176	6207	\N	1	\N
1526	1423	32	6175	\N	0	\N
1527	1423	118	6175	\N	0	\N
1528	1423	176	6175	\N	1	\N
1529	1424	176	4993	\N	1	\N
1530	1424	118	4993	\N	0	\N
1531	1424	32	4993	\N	0	\N
1532	1425	118	4837	\N	0	\N
1533	1425	176	4837	\N	1	\N
1534	1425	32	4837	\N	0	\N
1535	1426	32	4738	\N	0	\N
1536	1426	176	4738	\N	1	\N
1537	1426	118	4738	\N	0	\N
1538	1427	118	4656	\N	0	\N
1539	1427	176	4656	\N	1	\N
1540	1427	32	4656	\N	0	\N
1541	1428	176	4516	\N	1	\N
1542	1428	118	4516	\N	0	\N
1543	1428	32	4516	\N	0	\N
1544	1429	176	4181	\N	1	\N
1545	1429	32	4181	\N	0	\N
1546	1429	118	4181	\N	0	\N
1547	1430	118	3963	\N	0	\N
1548	1430	32	3963	\N	0	\N
1549	1430	176	3963	\N	1	\N
1550	1431	176	3265	\N	1	\N
1551	1431	118	3265	\N	0	\N
1552	1431	32	3265	\N	0	\N
1553	1432	176	2401	\N	1	\N
1554	1432	32	2401	\N	0	\N
1555	1432	118	2401	\N	0	\N
1556	1433	118	2152	\N	0	\N
1557	1433	32	2152	\N	0	\N
1558	1433	176	2152	\N	1	\N
1559	1434	176	2122	\N	1	\N
1560	1434	118	2122	\N	0	\N
1561	1434	32	2122	\N	0	\N
1562	1435	32	2073	\N	0	\N
1563	1435	176	2073	\N	1	\N
1564	1435	118	2073	\N	0	\N
1565	1436	118	1920	\N	0	\N
1566	1436	32	1920	\N	0	\N
1567	1436	176	1920	\N	1	\N
1568	1437	118	1628	\N	0	\N
1569	1437	32	1628	\N	0	\N
1570	1437	176	1628	\N	1	\N
1571	1438	32	1598	\N	0	\N
1572	1438	118	1598	\N	0	\N
1573	1438	176	1598	\N	1	\N
1574	1439	32	1435	\N	0	\N
1575	1439	176	1435	\N	1	\N
1576	1439	118	1435	\N	0	\N
1577	1440	32	1388	\N	0	\N
1578	1440	118	1388	\N	0	\N
1579	1440	176	1388	\N	1	\N
1580	1441	176	987	\N	1	\N
1581	1441	118	987	\N	0	\N
1582	1441	32	987	\N	0	\N
1583	1442	176	948	\N	1	\N
1584	1442	118	948	\N	0	\N
1585	1442	32	948	\N	0	\N
1586	1443	118	881	\N	0	\N
1587	1443	32	881	\N	0	\N
1588	1443	176	881	\N	1	\N
1589	1444	176	652	\N	1	\N
1590	1444	32	652	\N	0	\N
1591	1444	118	652	\N	0	\N
1592	1445	118	574	\N	0	\N
1593	1445	176	574	\N	1	\N
1594	1445	32	574	\N	0	\N
1595	1446	176	430	\N	1	\N
1596	1446	32	430	\N	0	\N
1597	1446	118	430	\N	0	\N
1598	1447	118	376	\N	0	\N
1599	1447	32	376	\N	0	\N
1600	1447	176	376	\N	1	\N
1601	1448	118	323	\N	0	\N
1602	1448	32	323	\N	0	\N
1603	1448	176	323	\N	1	\N
1604	1449	32	225	\N	0	\N
1605	1449	118	225	\N	0	\N
1606	1449	176	225	\N	1	\N
1607	1450	176	114	\N	1	\N
1608	1450	118	114	\N	0	\N
1609	1450	32	114	\N	0	\N
1610	1451	118	90	\N	0	\N
1611	1451	176	90	\N	1	\N
1612	1451	32	90	\N	0	\N
1613	1452	118	53	\N	0	\N
1614	1452	176	53	\N	1	\N
1615	1452	32	53	\N	0	\N
1616	1453	118	14	\N	0	\N
1617	1453	32	14	\N	0	\N
1618	1453	176	14	\N	1	\N
1619	1454	32	11	\N	0	\N
1620	1454	118	11	\N	0	\N
1621	1454	176	11	\N	1	\N
1622	1455	118	4	\N	0	\N
1623	1455	32	4	\N	0	\N
1624	1455	176	4	\N	1	\N
1625	1456	118	3	\N	0	\N
1626	1456	32	3	\N	0	\N
1627	1456	176	3	\N	1	\N
1628	1457	118	1	\N	0	\N
1629	1457	32	1	\N	0	\N
1630	1457	176	1	\N	1	\N
1631	1458	2	21831239	\N	2	\N
1632	1458	49	42611	\N	30	\N
1633	1458	80	161948	\N	13	\N
1634	1458	109	129846	\N	16	\N
1635	1458	98	3265	\N	58	\N
1636	1458	28	122441	\N	17	\N
1637	1458	60	114	\N	77	\N
1638	1458	79	14585	\N	43	\N
1639	1458	54	32966	\N	37	\N
1640	1458	12	49375	\N	25	\N
1641	1458	38	33105	\N	36	\N
1642	1458	165	182078	\N	10	\N
1643	1458	9	11996	\N	45	\N
1644	1458	44	652	\N	71	\N
1645	1458	102	430	\N	73	\N
1646	1458	41	90	\N	78	\N
1647	1458	26	399480	\N	7	\N
1648	1458	164	47581	\N	26	\N
1649	1458	137	16460	\N	42	\N
1650	1458	40	2122	\N	61	\N
1651	1458	151	1435	\N	66	\N
1652	1458	134	2401	\N	59	\N
1653	1458	16	948	\N	69	\N
1654	1458	17	76998	\N	21	\N
1655	1458	56	35060	\N	34	\N
1656	1458	3	44624	\N	27	\N
1657	1458	5	518692	\N	6	\N
1658	1458	7	44610	\N	28	\N
1659	1458	163	41528	\N	31	\N
1660	1458	154	1920	\N	63	\N
1661	1458	51	7167	\N	47	\N
1662	1458	87	225	\N	76	\N
1663	1458	129	67380	\N	22	\N
1664	1458	110	31753	\N	38	\N
1665	1458	116	4181	\N	56	\N
1666	1458	14	6795	\N	48	\N
1667	1458	52	22714	\N	40	\N
1668	1458	112	4837	\N	52	\N
1669	1458	94	7886	\N	46	\N
1670	1458	83	12852	\N	44	\N
1671	1458	70	4516	\N	55	\N
1672	1458	99	53	\N	79	\N
1673	1458	140	376	\N	74	\N
1674	1458	29	323	\N	75	\N
1675	1458	4	20466403	\N	3	\N
1676	1458	66	53622	\N	24	\N
1677	1458	6	122332	\N	18	\N
1678	1458	130	132986	\N	15	\N
1679	1458	97	38631	\N	33	\N
1680	1458	111	54564	\N	23	\N
1681	1458	114	4993	\N	51	\N
1682	1458	92	320598	\N	9	\N
1683	1458	48	175584	\N	11	\N
1684	1458	162	84323	\N	20	\N
1685	1458	82	170627	\N	12	\N
1686	1458	64	89586	\N	19	\N
1687	1458	136	6207	\N	49	\N
1688	1458	68	4656	\N	54	\N
1689	1458	11	2073	\N	62	\N
1690	1458	13	987	\N	68	\N
1691	1458	72	574	\N	72	\N
1692	1458	30	2152	\N	60	\N
1693	1458	104	3	\N	83	\N
1694	1458	21	4	\N	82	\N
1695	1458	128	39739	\N	32	\N
1696	1458	93	23226	\N	39	\N
1697	1458	149	19109	\N	41	\N
1698	1458	132	4738	\N	53	\N
1699	1458	172	881	\N	70	\N
1700	1458	61	1	\N	84	\N
1701	1458	77	8855603	\N	4	\N
1702	1458	10	6175	\N	50	\N
1703	1458	67	3963	\N	57	\N
1704	1458	43	14	\N	80	\N
1705	1458	113	73897474	\N	1	\N
1706	1458	47	1578137	\N	5	\N
1707	1458	78	338501	\N	8	\N
1708	1458	133	33504	\N	35	\N
1709	1458	37	139183	\N	14	\N
1710	1458	39	44006	\N	29	\N
1711	1458	15	1598	\N	65	\N
1712	1458	138	1388	\N	67	\N
1713	1458	135	1628	\N	64	\N
1714	1458	19	11	\N	81	\N
1715	1459	48	175584	\N	11	\N
1716	1459	154	1920	\N	63	\N
1717	1459	137	16460	\N	42	\N
1718	1459	52	22714	\N	40	\N
1719	1459	43	14	\N	80	\N
1720	1459	41	90	\N	78	\N
1721	1459	128	39739	\N	32	\N
1722	1459	130	132986	\N	15	\N
1723	1459	82	170627	\N	12	\N
1724	1459	98	3265	\N	58	\N
1725	1459	97	38631	\N	33	\N
1726	1459	64	89586	\N	19	\N
1727	1459	165	182078	\N	10	\N
1728	1459	99	53	\N	79	\N
1729	1459	60	114	\N	77	\N
1730	1459	104	3	\N	83	\N
1731	1459	29	323	\N	75	\N
1732	1459	92	320598	\N	9	\N
1733	1459	6	122332	\N	18	\N
1734	1459	14	6795	\N	48	\N
1735	1459	3	44624	\N	27	\N
1736	1459	72	574	\N	72	\N
1737	1459	87	225	\N	76	\N
1738	1459	21	4	\N	82	\N
1739	1459	5	518692	\N	6	\N
1740	1459	93	23226	\N	39	\N
1741	1459	163	41528	\N	31	\N
1742	1459	83	12852	\N	44	\N
1743	1459	136	6207	\N	49	\N
1744	1459	67	3963	\N	57	\N
1745	1459	17	76998	\N	21	\N
1746	1459	30	2152	\N	60	\N
1747	1459	19	11	\N	81	\N
1748	1459	113	73897474	\N	1	\N
1749	1459	4	20466403	\N	3	\N
1750	1459	109	129846	\N	16	\N
1751	1459	164	47581	\N	26	\N
1752	1459	78	338501	\N	8	\N
1753	1459	54	32966	\N	37	\N
1754	1459	149	19109	\N	41	\N
1755	1459	112	4837	\N	52	\N
1756	1459	51	7167	\N	47	\N
1757	1459	40	2122	\N	61	\N
1758	1459	135	1628	\N	64	\N
1759	1459	140	376	\N	74	\N
1760	1459	94	7886	\N	46	\N
1761	1459	68	4656	\N	54	\N
1762	1459	44	652	\N	71	\N
1763	1459	16	948	\N	69	\N
1764	1459	2	21831239	\N	2	\N
1765	1459	77	8855603	\N	4	\N
1766	1459	7	44610	\N	28	\N
1767	1459	79	14585	\N	43	\N
1768	1459	162	84323	\N	20	\N
1769	1459	10	6175	\N	50	\N
1770	1459	38	33105	\N	36	\N
1771	1459	111	54564	\N	23	\N
1772	1459	70	4516	\N	55	\N
1773	1459	172	881	\N	70	\N
1774	1459	61	1	\N	84	\N
1775	1459	47	1578137	\N	5	\N
1776	1459	26	399480	\N	7	\N
1777	1459	80	161948	\N	13	\N
1778	1459	12	49375	\N	25	\N
1779	1459	114	4993	\N	51	\N
1780	1459	39	44006	\N	29	\N
1781	1459	13	987	\N	68	\N
1782	1459	66	53622	\N	24	\N
1783	1459	110	31753	\N	38	\N
1784	1459	37	139183	\N	14	\N
1785	1459	116	4181	\N	56	\N
1786	1459	56	35060	\N	34	\N
1787	1459	9	11996	\N	45	\N
1788	1459	15	1598	\N	65	\N
1789	1459	28	122441	\N	17	\N
1790	1459	138	1388	\N	67	\N
1791	1459	102	430	\N	73	\N
1792	1459	49	42611	\N	30	\N
1793	1459	129	67380	\N	22	\N
1794	1459	133	33504	\N	35	\N
1795	1459	132	4738	\N	53	\N
1796	1459	11	2073	\N	62	\N
1797	1459	151	1435	\N	66	\N
1798	1459	134	2401	\N	59	\N
1799	1460	5	518692	\N	6	\N
1800	1460	110	31753	\N	38	\N
1801	1460	48	175584	\N	11	\N
1802	1460	78	338501	\N	8	\N
1803	1460	163	41528	\N	31	\N
1804	1460	37	139183	\N	14	\N
1805	1460	149	19109	\N	41	\N
1806	1460	10	6175	\N	50	\N
1807	1460	28	122441	\N	17	\N
1808	1460	87	225	\N	76	\N
1809	1460	19	11	\N	81	\N
1810	1460	29	323	\N	75	\N
1811	1460	2	21831239	\N	2	\N
1812	1460	26	399480	\N	7	\N
1813	1460	129	67380	\N	22	\N
1814	1460	14	6795	\N	48	\N
1815	1460	56	35060	\N	34	\N
1816	1460	15	1598	\N	65	\N
1817	1460	151	1435	\N	66	\N
1818	1460	41	90	\N	78	\N
1819	1460	66	53622	\N	24	\N
1820	1460	162	84323	\N	20	\N
1821	1460	154	1920	\N	63	\N
1822	1460	132	4738	\N	53	\N
1823	1460	138	1388	\N	67	\N
1824	1460	11	2073	\N	62	\N
1825	1460	60	114	\N	77	\N
1826	1460	77	8855603	\N	4	\N
1827	1460	7	44610	\N	28	\N
1828	1460	93	23226	\N	39	\N
1829	1460	82	170627	\N	12	\N
1830	1460	67	3963	\N	57	\N
1831	1460	44	652	\N	71	\N
1832	1460	104	3	\N	83	\N
1833	1460	47	1578137	\N	5	\N
1834	1460	92	320598	\N	9	\N
1835	1460	54	32966	\N	37	\N
1836	1460	137	16460	\N	42	\N
1837	1460	102	430	\N	73	\N
1838	1460	140	376	\N	74	\N
1839	1460	43	14	\N	80	\N
1840	1460	21	4	\N	82	\N
1841	1460	113	73897474	\N	1	\N
1842	1460	39	44006	\N	29	\N
1843	1460	52	22714	\N	40	\N
1844	1460	94	7886	\N	46	\N
1845	1460	164	47581	\N	26	\N
1846	1460	133	33504	\N	35	\N
1847	1460	130	132986	\N	15	\N
1848	1460	97	38631	\N	33	\N
1849	1460	64	89586	\N	19	\N
1850	1460	111	54564	\N	23	\N
1851	1460	112	4837	\N	52	\N
1852	1460	136	6207	\N	49	\N
1853	1460	40	2122	\N	61	\N
1854	1460	135	1628	\N	64	\N
1855	1460	17	76998	\N	21	\N
1856	1460	30	2152	\N	60	\N
1857	1460	61	1	\N	84	\N
1858	1460	80	161948	\N	13	\N
1859	1460	109	129846	\N	16	\N
1860	1460	116	4181	\N	56	\N
1861	1460	165	182078	\N	10	\N
1862	1460	9	11996	\N	45	\N
1863	1460	83	12852	\N	44	\N
1864	1460	70	4516	\N	55	\N
1865	1460	68	4656	\N	54	\N
1866	1460	172	881	\N	70	\N
1867	1460	99	53	\N	79	\N
1868	1460	13	987	\N	68	\N
1869	1460	72	574	\N	72	\N
1870	1460	6	122332	\N	18	\N
1871	1460	128	39739	\N	32	\N
1872	1460	98	3265	\N	58	\N
1873	1460	114	4993	\N	51	\N
1874	1460	51	7167	\N	47	\N
1875	1460	134	2401	\N	59	\N
1876	1460	49	42611	\N	30	\N
1877	1460	4	20466403	\N	3	\N
1878	1460	79	14585	\N	43	\N
1879	1460	12	49375	\N	25	\N
1880	1460	38	33105	\N	36	\N
1881	1460	3	44624	\N	27	\N
1882	1460	16	948	\N	69	\N
1883	1461	113	68177767	\N	1	\N
1884	1462	113	51909409	\N	1	\N
1885	1463	113	37265428	\N	1	\N
1886	1464	113	3534248	\N	1	\N
1887	1465	113	1649930	\N	1	\N
1888	1466	113	430177	\N	1	\N
1889	1467	113	406957	\N	1	\N
1890	1468	113	399480	\N	1	\N
1891	1469	113	346652	\N	1	\N
1892	1470	113	265972	\N	1	\N
1893	1471	113	236790	\N	1	\N
1894	1472	113	182078	\N	1	\N
1895	1473	113	170627	\N	1	\N
1896	1474	113	163154	\N	1	\N
1897	1475	113	147507	\N	1	\N
1898	1476	113	145237	\N	1	\N
1899	1477	113	140407	\N	1	\N
1900	1478	113	116177	\N	1	\N
1901	1479	113	115473	\N	1	\N
1902	1480	113	102581	\N	1	\N
1903	1481	113	94932	\N	1	\N
1904	1482	113	91207	\N	1	\N
1905	1483	113	85411	\N	1	\N
1906	1484	113	80474	\N	1	\N
1907	1485	113	68185	\N	1	\N
1908	1486	113	68185	\N	1	\N
1909	1487	113	61232	\N	1	\N
1910	1488	113	53622	\N	1	\N
1911	1489	113	48579	\N	1	\N
1912	1490	113	45100	\N	1	\N
1913	1491	113	44006	\N	1	\N
1914	1492	113	42611	\N	1	\N
1915	1493	113	39639	\N	1	\N
1916	1494	113	37666	\N	1	\N
1917	1495	113	35330	\N	1	\N
1918	1496	113	33849	\N	1	\N
1919	1497	113	33504	\N	1	\N
1920	1498	113	33354	\N	1	\N
1921	1499	113	22765	\N	1	\N
1922	1500	113	20625	\N	1	\N
1923	1501	113	19571	\N	1	\N
1924	1502	113	16615	\N	1	\N
1925	1503	113	15218	\N	1	\N
1926	1504	113	11996	\N	1	\N
1927	1505	113	9487	\N	1	\N
1928	1506	113	8105	\N	1	\N
1929	1507	113	7940	\N	1	\N
1930	1508	113	6887	\N	1	\N
1931	1509	113	6843	\N	1	\N
1932	1510	113	6833	\N	1	\N
1933	1511	113	6699	\N	1	\N
1934	1512	113	6539	\N	1	\N
1935	1513	113	5822	\N	1	\N
1936	1514	113	5770	\N	1	\N
1937	1515	113	4993	\N	1	\N
1938	1516	113	4974	\N	1	\N
1939	1517	113	4841	\N	1	\N
1940	1518	113	4591	\N	1	\N
1941	1519	113	3036	\N	1	\N
1942	1520	113	2369	\N	1	\N
1943	1521	113	2286	\N	1	\N
1944	1522	113	2196	\N	1	\N
1945	1523	113	2103	\N	1	\N
1946	1524	113	1761	\N	1	\N
1947	1525	113	1601	\N	1	\N
1948	1526	113	1427	\N	1	\N
1949	1527	113	1044	\N	1	\N
1950	1528	113	971	\N	1	\N
1951	1529	113	323	\N	1	\N
1952	1530	113	94	\N	1	\N
1953	1531	113	55	\N	1	\N
1954	1532	113	18	\N	1	\N
1955	1533	113	4	\N	1	\N
1956	1534	113	1	\N	1	\N
1957	1535	78	406957	\N	7	\N
1958	1535	80	346652	\N	9	\N
1959	1535	64	102581	\N	20	\N
1960	1535	94	8105	\N	46	\N
1961	1535	112	6887	\N	48	\N
1962	1535	40	3036	\N	59	\N
1963	1535	38	33849	\N	36	\N
1964	1535	149	19571	\N	41	\N
1965	1535	165	182078	\N	12	\N
1966	1535	135	1761	\N	64	\N
1967	1535	6	147507	\N	15	\N
1968	1535	4	37265428	\N	3	\N
1969	1535	128	116177	\N	18	\N
1970	1535	77	68177767	\N	1	\N
1971	1535	79	20625	\N	40	\N
1972	1535	83	15218	\N	43	\N
1973	1535	111	94932	\N	21	\N
1974	1535	68	4974	\N	56	\N
1975	1535	98	5770	\N	54	\N
1976	1535	16	1044	\N	67	\N
1977	1535	43	18	\N	72	\N
1978	1535	47	3534248	\N	4	\N
1979	1535	39	44006	\N	31	\N
1980	1535	56	48579	\N	29	\N
1981	1535	136	6843	\N	49	\N
1982	1535	67	7940	\N	47	\N
1983	1535	137	16615	\N	42	\N
1984	1535	17	85411	\N	23	\N
1985	1535	30	2286	\N	61	\N
1986	1535	99	55	\N	71	\N
1987	1535	129	68185	\N	26	\N
1988	1535	92	1649930	\N	5	\N
1989	1535	26	399480	\N	8	\N
1990	1535	133	33504	\N	37	\N
1991	1535	116	5822	\N	53	\N
1992	1535	93	37666	\N	34	\N
1993	1535	151	1601	\N	65	\N
1994	1535	172	971	\N	68	\N
1995	1535	5	430177	\N	6	\N
1996	1535	66	53622	\N	28	\N
1997	1535	154	2103	\N	63	\N
1998	1535	12	68185	\N	25	\N
1999	1535	37	140407	\N	17	\N
2000	1535	130	265972	\N	10	\N
2001	1535	132	6699	\N	51	\N
2002	1535	70	4841	\N	57	\N
2003	1535	138	1427	\N	66	\N
2004	1535	11	2369	\N	60	\N
2005	1535	140	4591	\N	58	\N
2006	1535	162	91207	\N	22	\N
2007	1535	109	145237	\N	16	\N
2008	1535	164	61232	\N	27	\N
2009	1535	3	45100	\N	30	\N
2010	1535	14	6833	\N	50	\N
2011	1535	9	11996	\N	44	\N
2012	1535	29	323	\N	69	\N
2013	1535	54	33354	\N	38	\N
2014	1535	7	22765	\N	39	\N
2015	1535	52	35330	\N	35	\N
2016	1535	114	4993	\N	55	\N
2017	1535	41	94	\N	70	\N
2018	1535	61	1	\N	74	\N
2019	1535	21	4	\N	73	\N
2020	1535	48	236790	\N	11	\N
2021	1535	163	80474	\N	24	\N
2022	1535	97	39639	\N	33	\N
2023	1535	10	6539	\N	52	\N
2024	1535	28	163154	\N	14	\N
2025	1535	51	9487	\N	45	\N
2026	1535	15	2196	\N	62	\N
2027	1535	2	51909409	\N	2	\N
2028	1535	49	42611	\N	32	\N
2029	1535	110	115473	\N	19	\N
2030	1535	82	170627	\N	13	\N
2031	1537	112	4837	\N	1	\N
2032	1538	8	4837	\N	1	\N
2035	1542	94	7886	\N	1	\N
2036	1543	8	7886	\N	1	\N
2037	1544	48	175584	\N	1	\N
2038	1545	8	175584	\N	1	\N
2039	1546	74	20395	\N	1	\N
2040	1546	106	20395	\N	2	\N
2041	1547	65	20395	\N	1	\N
2042	1548	65	20395	\N	1	\N
2055	1563	104	3	\N	1	\N
2056	1564	8	3	\N	1	\N
2057	1565	65	1300362	\N	1	\N
2058	1565	22	160695	\N	2	\N
2059	1565	8	117199	\N	3	\N
2060	1566	22	122441	\N	1	\N
2061	1567	22	51011	\N	1	\N
2062	1568	65	19109	\N	1	\N
2063	1569	22	4738	\N	1	\N
2064	1570	149	19109	\N	2	\N
2065	1570	47	1300362	\N	1	\N
2066	1571	28	122441	\N	2	\N
2067	1571	47	160695	\N	1	\N
2068	1571	111	51011	\N	3	\N
2069	1571	132	4738	\N	4	\N
2070	1572	47	117199	\N	1	\N
2071	1592	93	23226	\N	1	\N
2072	1593	8	23226	\N	1	\N
2073	1596	41	90	\N	1	\N
2074	1597	8	90	\N	1	\N
2075	1603	118	73897474	\N	0	\N
2076	1603	119	73897474	\N	1	\N
2077	1603	32	73897474	\N	0	\N
2078	1604	113	73897474	\N	1	\N
2079	1605	113	73897474	\N	1	\N
2080	1606	113	73897474	\N	1	\N
2081	1609	46	1	\N	1	\N
2082	1610	46	1	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://nextprot.org/rdf#	0	t	0
17	openlinks	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
70	sdo	https://schema.org/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	https_www_nextprot_org	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	https_www_nextprot_org	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://sparql.nextprot.org/	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "https://sparql.nextprot.org/", "correlationId": "8720413343224215747", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:25:28.883Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://nextprot.org/rdf#activeSite	7167	\N	69	activeSite	activeSite	f	7167	\N	\N	f	f	8	51	\N	t	f	\N	\N	\N	t	f	f
2	http://nextprot.org/rdf#expression	21963158	\N	69	expression	expression	f	21963158	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://nextprot.org/rdf#processingProduct	56355	\N	69	processingProduct	processingProduct	f	56355	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://nextprot.org/rdf#nonTerminalResidue	323	\N	69	nonTerminalResidue	nonTerminalResidue	f	323	\N	\N	f	f	8	29	\N	t	f	\N	\N	\N	t	f	f
7	http://nextprot.org/rdf#method	132986	\N	69	method	method	f	0	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://nextprot.org/rdf#goBiologicalProcess	338501	\N	69	goBiologicalProcess	goBiologicalProcess	f	338501	\N	\N	f	f	8	78	\N	t	f	\N	\N	\N	t	f	f
9	http://nextprot.org/rdf#term	23867632	\N	69	term	term	f	23867632	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://nextprot.org/rdf#recommendedName	109722	\N	69	recommendedName	recommendedName	f	109722	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://nextprot.org/rdf#miscellaneousRegion	67380	\N	69	miscellaneousRegion	miscellaneousRegion	f	67380	\N	\N	f	f	8	129	\N	t	f	\N	\N	\N	t	f	f
14	http://nextprot.org/rdf#coiledCoilRegion	6795	\N	69	coiledCoilRegion	coiledCoilRegion	f	6795	\N	\N	f	f	8	14	\N	t	f	\N	\N	\N	t	f	f
15	http://nextprot.org/rdf#kineticVmax	987	\N	69	kineticVmax	kineticVmax	f	987	\N	\N	f	f	8	13	\N	t	f	\N	\N	\N	t	f	f
16	http://nextprot.org/rdf#biophysicochemicalProperty	4742	\N	69	biophysicochemicalProperty	biophysicochemicalProperty	f	4742	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.w3.org/2002/07/owl#equivalentClass	7	\N	7	equivalentClass	equivalentClass	f	7	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://nextprot.org/rdf#turn	44006	\N	69	turn	turn	f	44006	\N	\N	f	f	8	39	\N	t	f	\N	\N	\N	t	f	f
19	http://nextprot.org/rdf#functionInfo	39739	\N	69	functionInfo	functionInfo	f	39739	\N	\N	f	f	8	128	\N	t	f	\N	\N	\N	t	f	f
21	http://nextprot.org/rdf#betaStrand	182078	\N	69	betaStrand	betaStrand	f	182078	\N	\N	f	f	8	165	\N	t	f	\N	\N	\N	t	f	f
22	http://nextprot.org/rdf#intramembraneRegion	948	\N	69	intramembraneRegion	intramembraneRegion	f	948	\N	\N	f	f	8	16	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://nextprot.org/rdf#kineticKM	2401	\N	69	kineticKM	kineticKM	f	2401	\N	\N	f	f	8	134	\N	t	f	\N	\N	\N	t	f	f
28	http://nextprot.org/rdf#generalAnnotation	25466324	\N	69	generalAnnotation	generalAnnotation	f	25466324	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://purl.org/dc/terms/creator	1	\N	5	creator	creator	f	1	\N	\N	f	f	108	62	\N	t	f	\N	\N	\N	t	f	f
31	http://nextprot.org/rdf#pdbMapping	132986	\N	69	pdbMapping	pdbMapping	f	132986	\N	\N	f	f	8	130	\N	t	f	\N	\N	\N	t	f	f
32	http://nextprot.org/rdf#fromDatabase	70750485	\N	69	fromDatabase	fromDatabase	f	70750485	\N	\N	f	f	113	58	\N	t	f	\N	\N	\N	t	f	f
33	http://nextprot.org/rdf#expressionProfile	21831239	\N	69	expressionProfile	expressionProfile	f	21831239	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
34	http://nextprot.org/rdf#goQualifier	243792	\N	69	goQualifier	goQualifier	f	243792	\N	\N	f	f	113	103	\N	t	f	\N	\N	\N	t	f	f
35	http://nextprot.org/rdf#positionalAnnotation	31376613	\N	69	positionalAnnotation	positionalAnnotation	f	31376613	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://nextprot.org/rdf#dnaBindingRegion	1435	\N	69	dnaBindingRegion	dnaBindingRegion	f	1435	\N	\N	f	f	8	151	\N	t	f	\N	\N	\N	t	f	f
37	http://nextprot.org/rdf#proteotypic	9255083	\N	69	proteotypic	proteotypic	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://nextprot.org/rdf#temperatureDependence	114	\N	69	temperatureDependence	temperatureDependence	f	114	\N	\N	f	f	8	60	\N	t	f	\N	\N	\N	t	f	f
39	http://nextprot.org/rdf#accession	191440979	\N	69	accession	accession	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://nextprot.org/rdf#category	170	\N	69	category	category	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://nextprot.org/rdf#repeat	32966	\N	69	repeat	repeat	f	32966	\N	\N	f	f	8	54	\N	t	f	\N	\N	\N	t	f	f
42	http://nextprot.org/rdf#alleleCount	5159359	\N	69	alleleCount	alleleCount	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://nextprot.org/rdf#miscellaneous	6175	\N	69	miscellaneous	miscellaneous	f	6175	\N	\N	f	f	8	10	\N	t	f	\N	\N	\N	t	f	f
45	http://nextprot.org/rdf#peptideSource	13060071	\N	69	peptideSource	peptideSource	f	13060071	\N	\N	f	f	77	119	\N	t	f	\N	\N	\N	t	f	f
46	http://purl.org/dc/terms/modified	774	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://nextprot.org/rdf#ttlGenerationDate	1	\N	69	ttlGenerationDate	ttlGenerationDate	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://nextprot.org/rdf#peptideUniqueness	9255083	\N	69	peptideUniqueness	peptideUniqueness	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://nextprot.org/rdf#journal	566897	\N	69	journal	journal	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://nextprot.org/rdf#isoformCount	20389	\N	69	isoformCount	isoformCount	f	0	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	108	\N	2	subPropertyOf	subPropertyOf	f	108	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://nextprot.org/rdf#tissue	4632	\N	69	tissue	tissue	f	4632	\N	\N	f	f	168	173	\N	t	f	\N	\N	\N	t	f	f
55	http://nextprot.org/rdf#domainInfo	12852	\N	69	domainInfo	domainInfo	f	12852	\N	\N	f	f	8	83	\N	t	f	\N	\N	\N	t	f	f
57	http://nextprot.org/rdf#initiatorMethionine	3265	\N	69	initiatorMethionine	initiatorMethionine	f	3265	\N	\N	f	f	8	98	\N	t	f	\N	\N	\N	t	f	f
58	http://nextprot.org/rdf#miscellaneousSite	4516	\N	69	miscellaneousSite	miscellaneousSite	f	4516	\N	\N	f	f	8	70	\N	t	f	\N	\N	\N	t	f	f
59	http://nextprot.org/rdf#name	4717996	\N	69	name	name	f	216182	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://nextprot.org/rdf#strand	20476	\N	69	strand	strand	f	0	\N	\N	f	f	95	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://nextprot.org/rdf#experimentalContext	27068498	\N	69	experimentalContext	experimentalContext	f	27068498	\N	\N	f	f	113	168	\N	t	f	\N	\N	\N	t	f	f
64	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	96	\N	1	first	first	f	96	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://nextprot.org/rdf#childOf	1633664	\N	69	childOf	childOf	f	1633664	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://nextprot.org/rdf#peptideName	9255083	\N	69	peptideName	peptideName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://purl.org/dc/terms/extent	755	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.w3.org/2000/01/rdf-schema#label	839322	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://purl.org/dc/terms/title	1	\N	5	title	title	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://nextprot.org/rdf#pathway	139183	\N	69	pathway	pathway	f	139183	\N	\N	f	f	8	37	\N	t	f	\N	\N	\N	t	f	f
73	http://nextprot.org/rdf#length	62864	\N	69	length	length	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://nextprot.org/rdf#goMolecularFunction	161948	\N	69	goMolecularFunction	goMolecularFunction	f	161948	\N	\N	f	f	8	80	\N	t	f	\N	\N	\N	t	f	f
77	http://nextprot.org/rdf#cleavageSite	1628	\N	69	cleavageSite	cleavageSite	f	1628	\N	\N	f	f	8	135	\N	t	f	\N	\N	\N	t	f	f
78	https://schema.org/affiliation	1	\N	70	affiliation	affiliation	f	1	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://nextprot.org/rdf#nonConsecutiveResidue	1	\N	69	nonConsecutiveResidue	nonConsecutiveResidue	f	1	\N	\N	f	f	8	61	\N	t	f	\N	\N	\N	t	f	f
82	http://nextprot.org/rdf#existence	20389	\N	69	existence	existence	f	20389	\N	\N	f	f	65	175	\N	t	f	\N	\N	\N	t	f	f
84	http://nextprot.org/rdf#expressionInfo	129846	\N	69	expressionInfo	expressionInfo	f	129846	\N	\N	f	f	8	109	\N	t	f	\N	\N	\N	t	f	f
88	http://nextprot.org/rdf#original	20640312	\N	69	original	original	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://nextprot.org/rdf#reference	194900669	\N	69	reference	reference	f	194900669	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://nextprot.org/rdf#bestGeneMapping	20389	\N	69	bestGeneMapping	bestGeneMapping	f	20389	\N	\N	f	f	95	65	\N	t	f	\N	\N	\N	t	f	f
91	http://nextprot.org/rdf#selfInteraction	1578137	\N	69	selfInteraction	selfInteraction	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://nextprot.org/rdf#hgvs	20176628	\N	69	hgvs	hgvs	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://nextprot.org/rdf#developmentalStage	1125	\N	69	developmentalStage	developmentalStage	f	1125	\N	\N	f	f	168	105	\N	t	f	\N	\N	\N	t	f	f
95	http://nextprot.org/rdf#enzymeClassification	11996	\N	69	enzymeClassification	enzymeClassification	f	11996	\N	\N	f	f	8	9	\N	t	f	\N	\N	\N	t	f	f
98	http://nextprot.org/rdf#resolution	121509	\N	69	resolution	resolution	f	0	\N	\N	f	f	130	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://nextprot.org/rdf#lastSequenceUpdate	20395	\N	69	lastSequenceUpdate	lastSequenceUpdate	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://nextprot.org/rdf#disease	144498	\N	69	disease	disease	f	144498	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://nextprot.org/rdf#helix	170627	\N	69	helix	helix	f	170627	\N	\N	f	f	8	82	\N	t	f	\N	\N	\N	t	f	f
106	http://nextprot.org/rdf#region	235951	\N	69	region	region	f	235824	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://nextprot.org/rdf#function	707078	\N	69	function	function	f	707078	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://nextprot.org/rdf#related	479721	\N	69	related	related	f	479721	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://nextprot.org/rdf#alleleNumber	5159359	\N	69	alleleNumber	alleleNumber	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://nextprot.org/rdf#uniprotKeyword	518692	\N	69	uniprotKeyword	uniprotKeyword	f	518692	\N	\N	f	f	8	5	\N	t	f	\N	\N	\N	t	f	f
115	http://nextprot.org/rdf#author	4501738	\N	69	author	author	f	4501738	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://nextprot.org/rdf#compositionallyBiasedRegion	53622	\N	69	compositionallyBiasedRegion	compositionallyBiasedRegion	f	53622	\N	\N	f	f	8	66	\N	t	f	\N	\N	\N	t	f	f
118	http://nextprot.org/rdf#binaryInteraction	1578137	\N	69	binaryInteraction	binaryInteraction	f	1578137	\N	\N	f	f	8	47	\N	t	f	\N	\N	\N	t	f	f
119	http://nextprot.org/rdf#mapping	9449789	\N	69	mapping	mapping	f	9449789	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://nextprot.org/rdf#isoelectricPoint	42388	\N	69	isoelectricPoint	isoelectricPoint	f	0	\N	\N	f	f	145	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://www.w3.org/2002/07/owl#complementOf	3	\N	7	complementOf	complementOf	f	3	\N	\N	f	f	125	125	\N	t	f	\N	\N	\N	t	f	f
123	http://nextprot.org/rdf#publisher	34	\N	69	publisher	publisher	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://nextprot.org/rdf#highExpression	262697	\N	69	highExpression	highExpression	f	262697	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
125	http://nextprot.org/rdf#propeptide	1388	\N	69	propeptide	propeptide	f	1388	\N	\N	f	f	8	138	\N	t	f	\N	\N	\N	t	f	f
126	http://nextprot.org/rdf#mediumExpression	540276	\N	69	mediumExpression	mediumExpression	f	540276	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
127	http://nextprot.org/rdf#transportActivity	4993	\N	69	transportActivity	transportActivity	f	4993	\N	\N	f	f	8	114	\N	t	f	\N	\N	\N	t	f	f
129	http://nextprot.org/rdf#observedExpression	23945784	\N	69	observedExpression	observedExpression	f	23945784	\N	\N	f	f	113	45	\N	t	f	\N	\N	\N	t	f	f
130	http://nextprot.org/rdf#glycosylationSite	49375	\N	69	glycosylationSite	glycosylationSite	f	49375	\N	\N	f	f	8	12	\N	t	f	\N	\N	\N	t	f	f
133	http://nextprot.org/rdf#swissprotPage	20389	\N	69	swissprotPage	swissprotPage	f	20389	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://www.w3.org/2000/01/rdf-schema#comment	17836951	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://nextprot.org/rdf#proteoform	39487	\N	69	proteoform	proteoform	f	39487	\N	\N	f	f	8	84	\N	t	f	\N	\N	\N	t	f	f
138	http://nextprot.org/rdf#year	563133	\N	69	year	year	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://www.w3.org/2000/01/rdf-schema#domain	215	\N	2	domain	domain	f	215	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://nextprot.org/rdf#band	20476	\N	69	band	band	f	0	\N	\N	f	f	95	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://nextprot.org/rdf#metadata	13531	\N	69	metadata	metadata	f	13531	\N	\N	f	f	168	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://nextprot.org/rdf#editor	76	\N	69	editor	editor	f	76	\N	\N	f	f	150	146	\N	t	f	\N	\N	\N	t	f	f
147	http://nextprot.org/rdf#phDependence	652	\N	69	phDependence	phDependence	f	652	\N	\N	f	f	8	44	\N	t	f	\N	\N	\N	t	f	f
148	http://nextprot.org/rdf#diseaseRelatedVariant	2152	\N	69	diseaseRelatedVariant	diseaseRelatedVariant	f	2152	\N	\N	f	f	84	30	\N	t	f	\N	\N	\N	t	f	f
221	https://schema.org/email	1	\N	70	email	email	f	0	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://nextprot.org/rdf#undetectedExpression	4549214	\N	69	undetectedExpression	undetectedExpression	f	4549214	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
150	http://nextprot.org/rdf#sequenceVersion	20395	\N	69	sequenceVersion	sequenceVersion	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://nextprot.org/rdf#begin	20476	\N	69	begin	begin	f	0	\N	\N	f	f	95	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://nextprot.org/rdf#medical	41632	\N	69	medical	medical	f	41632	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://nextprot.org/rdf#interactionMapping	19109	\N	69	interactionMapping	interactionMapping	f	19109	\N	\N	f	f	8	149	\N	t	f	\N	\N	\N	t	f	f
157	http://nextprot.org/rdf#expressionScore	16808370	\N	69	expressionScore	expressionScore	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://nextprot.org/rdf#variation	20640312	\N	69	variation	variation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://nextprot.org/rdf#cellLine	6889	\N	69	cellLine	cellLine	f	6185	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	96	\N	1	rest	rest	f	96	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://nextprot.org/rdf#variant	20466403	\N	69	variant	variant	f	20466403	\N	\N	f	f	8	4	\N	t	f	\N	\N	\N	t	f	f
165	http://nextprot.org/rdf#crossLink	47581	\N	69	crossLink	crossLink	f	47581	\N	\N	f	f	8	164	\N	t	f	\N	\N	\N	t	f	f
166	http://nextprot.org/rdf#topology	72684	\N	69	topology	topology	f	72684	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://nextprot.org/rdf#cofactor	4738	\N	69	cofactor	cofactor	f	4738	\N	\N	f	f	8	132	\N	t	f	\N	\N	\N	t	f	f
168	http://nextprot.org/rdf#cellularComponent	312501	\N	69	cellularComponent	cellularComponent	f	312501	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://nextprot.org/rdf#sequence	42388	\N	69	sequence	sequence	f	42388	\N	\N	f	f	8	145	\N	t	f	\N	\N	\N	t	f	f
171	http://nextprot.org/rdf#familyName	14453	\N	69	familyName	familyName	f	14453	\N	\N	f	f	65	73	\N	t	f	\N	\N	\N	t	f	f
172	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	760	\N	2	isDefinedBy	isDefinedBy	f	760	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://nextprot.org/rdf#negative	73897474	\N	69	negative	negative	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://nextprot.org/rdf#site	67875	\N	69	site	site	f	67875	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://nextprot.org/rdf#chain	42388	\N	69	chain	chain	f	0	\N	\N	f	f	145	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://nextprot.org/rdf#activityRegulation	3963	\N	69	activityRegulation	activityRegulation	f	3963	\N	\N	f	f	8	67	\N	t	f	\N	\N	\N	t	f	f
180	http://nextprot.org/rdf#genomeAssembly	1	\N	69	genomeAssembly	genomeAssembly	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://nextprot.org/rdf#disulfideBond	35060	\N	69	disulfideBond	disulfideBond	f	35060	\N	\N	f	f	8	56	\N	t	f	\N	\N	\N	t	f	f
184	http://nextprot.org/rdf#interactionDetectionMethod	965891	\N	69	interactionDetectionMethod	interactionDetectionMethod	f	965891	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://nextprot.org/rdf#srmPeptideMapping	399480	\N	69	srmPeptideMapping	srmPeptideMapping	f	399480	\N	\N	f	f	8	26	\N	t	f	\N	\N	\N	t	f	f
186	http://nextprot.org/rdf#updated	40790	\N	69	updated	updated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://nextprot.org/rdf#city	36	\N	69	city	city	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://nextprot.org/rdf#modifiedResidue	320598	\N	69	modifiedResidue	modifiedResidue	f	320598	\N	\N	f	f	8	92	\N	t	f	\N	\N	\N	t	f	f
190	http://www.w3.org/2002/07/owl#unionOf	30	\N	7	unionOf	unionOf	f	30	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	46	46	\N	t	f	\N	\N	\N	t	f	f
192	http://www.w3.org/2002/07/owl#versionInfo	2	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://nextprot.org/rdf#detectedExpression	17282025	\N	69	detectedExpression	detectedExpression	f	17282025	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
196	http://nextprot.org/rdf#smallMoleculeInteraction	122441	\N	69	smallMoleculeInteraction	smallMoleculeInteraction	f	122441	\N	\N	f	f	8	28	\N	t	f	\N	\N	\N	t	f	f
197	http://nextprot.org/rdf#domain	44624	\N	69	domain	domain	f	44624	\N	\N	f	f	8	3	\N	t	f	\N	\N	\N	t	f	f
198	http://nextprot.org/rdf#lowExpression	326038	\N	69	lowExpression	lowExpression	f	326038	\N	\N	f	f	8	2	\N	t	f	\N	\N	\N	t	f	f
200	http://nextprot.org/rdf#allergen	14	\N	69	allergen	allergen	f	14	\N	\N	f	f	8	43	\N	t	f	\N	\N	\N	t	f	f
201	http://nextprot.org/rdf#zincFingerRegion	16460	\N	69	zincFingerRegion	zincFingerRegion	f	16460	\N	\N	f	f	8	137	\N	t	f	\N	\N	\N	t	f	f
204	http://nextprot.org/rdf#numberOfExperiments	676515	\N	69	numberOfExperiments	numberOfExperiments	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://nextprot.org/rdf#signalPeptide	6207	\N	69	signalPeptide	signalPeptide	f	6207	\N	\N	f	f	8	136	\N	t	f	\N	\N	\N	t	f	f
206	http://nextprot.org/rdf#kineticNote	574	\N	69	kineticNote	kineticNote	f	574	\N	\N	f	f	8	72	\N	t	f	\N	\N	\N	t	f	f
208	http://nextprot.org/rdf#interactionInfo	31753	\N	69	interactionInfo	interactionInfo	f	31753	\N	\N	f	f	8	110	\N	t	f	\N	\N	\N	t	f	f
209	http://nextprot.org/rdf#caution	4181	\N	69	caution	caution	f	4181	\N	\N	f	f	8	116	\N	t	f	\N	\N	\N	t	f	f
212	http://nextprot.org/rdf#bindingSite	54564	\N	69	bindingSite	bindingSite	f	54564	\N	\N	f	f	8	111	\N	t	f	\N	\N	\N	t	f	f
213	http://nextprot.org/rdf#mutagenesis	89586	\N	69	mutagenesis	mutagenesis	f	89586	\N	\N	f	f	8	64	\N	t	f	\N	\N	\N	t	f	f
214	http://nextprot.org/rdf#variantInfo	1598	\N	69	variantInfo	variantInfo	f	1598	\N	\N	f	f	8	15	\N	t	f	\N	\N	\N	t	f	f
215	http://nextprot.org/rdf#issue	563097	\N	69	issue	issue	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://nextprot.org/rdf#antibodyUniqueness	42611	\N	69	antibodyUniqueness	antibodyUniqueness	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://nextprot.org/rdf#interactingRegion	4656	\N	69	interactingRegion	interactingRegion	f	4656	\N	\N	f	f	8	68	\N	t	f	\N	\N	\N	t	f	f
219	http://nextprot.org/rdf#molecularWeight	42388	\N	69	molecularWeight	molecularWeight	f	0	\N	\N	f	f	145	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://nextprot.org/rdf#level	5	\N	69	level	level	f	0	\N	\N	f	f	175	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://nextprot.org/rdf#redoxPotential	11	\N	69	redoxPotential	redoxPotential	f	11	\N	\N	f	f	8	19	\N	t	f	\N	\N	\N	t	f	f
227	http://nextprot.org/rdf#databaseRelease	1	\N	69	databaseRelease	databaseRelease	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://nextprot.org/rdf#entryAnnotationId	56843968	\N	69	entryAnnotationId	entryAnnotationId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://nextprot.org/rdf#mitochondrialTransitPeptide	881	\N	69	mitochondrialTransitPeptide	mitochondrialTransitPeptide	f	881	\N	\N	f	f	8	172	\N	t	f	\N	\N	\N	t	f	f
230	http://nextprot.org/rdf#from	1042717	\N	69	from	from	f	1042717	\N	\N	f	f	150	22	\N	t	f	\N	\N	\N	t	f	f
231	http://nextprot.org/rdf#evidenceCode	73897474	\N	69	evidenceCode	evidenceCode	f	73897474	\N	\N	f	f	113	143	\N	t	f	\N	\N	\N	t	f	f
234	http://nextprot.org/rdf#selenocysteine	53	\N	69	selenocysteine	selenocysteine	f	53	\N	\N	f	f	8	99	\N	t	f	\N	\N	\N	t	f	f
235	http://nextprot.org/rdf#interaction	1743154	\N	69	interaction	interaction	f	1743154	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://nextprot.org/rdf#transmembraneRegion	38631	\N	69	transmembraneRegion	transmembraneRegion	f	38631	\N	\N	f	f	8	97	\N	t	f	\N	\N	\N	t	f	f
237	http://nextprot.org/rdf#negativeEvidence	10822834	\N	69	negativeEvidence	negativeEvidence	f	10822834	\N	\N	f	f	\N	113	\N	t	f	\N	\N	\N	t	f	f
238	http://nextprot.org/rdf#matureProtein	44610	\N	69	matureProtein	matureProtein	f	44610	\N	\N	f	f	8	7	\N	t	f	\N	\N	\N	t	f	f
239	http://www.w3.org/2004/02/skos/core#exactMatch	359274	\N	4	exactMatch	exactMatch	f	359274	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://nextprot.org/rdf#subcellularLocation	122332	\N	69	subcellularLocation	subcellularLocation	f	122332	\N	\N	f	f	8	6	\N	t	f	\N	\N	\N	t	f	f
241	http://nextprot.org/rdf#homozygoteCount	5159359	\N	69	homozygoteCount	homozygoteCount	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://nextprot.org/rdf#antibodyMapping	42611	\N	69	antibodyMapping	antibodyMapping	f	42611	\N	\N	f	f	8	49	\N	t	f	\N	\N	\N	t	f	f
246	http://nextprot.org/rdf#sequenceCaution	33504	\N	69	sequenceCaution	sequenceCaution	f	33504	\N	\N	f	f	8	133	\N	t	f	\N	\N	\N	t	f	f
247	http://purl.org/dc/terms/description	1	\N	5	description	description	f	0	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://nextprot.org/rdf#orfName	5276	\N	69	orfName	orfName	f	5276	\N	\N	f	f	\N	69	\N	t	f	\N	\N	\N	t	f	f
249	http://nextprot.org/rdf#title	570055	\N	69	title	title	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://nextprot.org/rdf#firstPage	563133	\N	69	firstPage	firstPage	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://nextprot.org/rdf#alleleFrequency	5159359	\N	69	alleleFrequency	alleleFrequency	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://nextprot.org/rdf#alternativeName	101184	\N	69	alternativeName	alternativeName	f	101184	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	https://schema.org/name	1	\N	70	name	name	f	0	\N	\N	f	f	62	\N	\N	t	f	\N	\N	\N	t	f	f
257	http://nextprot.org/rdf#provenance	191440979	\N	69	provenance	provenance	f	191440979	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://www.w3.org/2000/01/rdf-schema#subClassOf	487	\N	2	subClassOf	subClassOf	f	487	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://nextprot.org/rdf#end	31394681	\N	69	end	end	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://nextprot.org/rdf#topologicalDomain	33105	\N	69	topologicalDomain	topologicalDomain	f	33105	\N	\N	f	f	8	38	\N	t	f	\N	\N	\N	t	f	f
261	http://nextprot.org/rdf#peroxisomeTransitPeptide	4	\N	69	peroxisomeTransitPeptide	peroxisomeTransitPeptide	f	4	\N	\N	f	f	8	21	\N	t	f	\N	\N	\N	t	f	f
262	http://www.w3.org/2000/01/rdf-schema#range	214	\N	2	range	range	f	214	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://www.w3.org/2002/07/owl#oneOf	4	\N	7	oneOf	oneOf	f	4	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://www.w3.org/2002/07/owl#equivalentProperty	1	\N	7	equivalentProperty	equivalentProperty	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://nextprot.org/rdf#difference	41121	\N	69	difference	difference	f	41121	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://nextprot.org/rdf#subcellularLocationNote	14585	\N	69	subcellularLocationNote	subcellularLocationNote	f	14585	\N	\N	f	f	8	79	\N	t	f	\N	\N	\N	t	f	f
267	http://nextprot.org/rdf#suffix	6655	\N	69	suffix	suffix	f	0	\N	\N	f	f	146	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://nextprot.org/rdf#ptm	454587	\N	69	ptm	ptm	f	454587	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://nextprot.org/rdf#cofactorInfo	2122	\N	69	cofactorInfo	cofactorInfo	f	2122	\N	\N	f	f	8	40	\N	t	f	\N	\N	\N	t	f	f
271	http://nextprot.org/rdf#version	20395	\N	69	version	version	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://nextprot.org/rdf#volume	563097	\N	69	volume	volume	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://nextprot.org/rdf#start	31374265	\N	69	start	start	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://nextprot.org/rdf#sequenceConflict	84323	\N	69	sequenceConflict	sequenceConflict	f	84323	\N	\N	f	f	8	162	\N	t	f	\N	\N	\N	t	f	f
276	http://nextprot.org/rdf#developmentalStageInfo	2073	\N	69	developmentalStageInfo	developmentalStageInfo	f	2073	\N	\N	f	f	8	11	\N	t	f	\N	\N	\N	t	f	f
277	http://nextprot.org/rdf#severity	12075	\N	69	severity	severity	f	12075	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://nextprot.org/rdf#pubType	574779	\N	69	pubType	pubType	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://nextprot.org/rdf#secondaryStructure	396711	\N	69	secondaryStructure	secondaryStructure	f	396711	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://nextprot.org/rdf#isoform	42382	\N	69	isoform	isoform	f	42382	\N	\N	f	f	65	8	\N	t	f	\N	\N	\N	t	f	f
282	http://nextprot.org/rdf#catalyticActivity	22714	\N	69	catalyticActivity	catalyticActivity	f	22714	\N	\N	f	f	8	52	\N	t	f	\N	\N	\N	t	f	f
283	http://nextprot.org/rdf#swissprotDisplayed	42382	\N	69	swissprotDisplayed	swissprotDisplayed	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://nextprot.org/rdf#lipidationSite	1920	\N	69	lipidationSite	lipidationSite	f	1920	\N	\N	f	f	8	154	\N	t	f	\N	\N	\N	t	f	f
285	http://www.w3.org/2000/01/rdf-schema#seeAlso	199	\N	2	seeAlso	seeAlso	f	38	\N	\N	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://nextprot.org/rdf#otherName	85841	\N	69	otherName	otherName	f	85841	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://nextprot.org/rdf#impactedObject	79150	\N	69	impactedObject	impactedObject	f	79150	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://nextprot.org/rdf#phenotypicVariation	76998	\N	69	phenotypicVariation	phenotypicVariation	f	76998	\N	\N	f	f	84	17	\N	t	f	\N	\N	\N	t	f	f
291	http://nextprot.org/rdf#chromosome	20476	\N	69	chromosome	chromosome	f	0	\N	\N	f	f	95	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.w3.org/2002/07/owl#imports	1	\N	7	imports	imports	f	1	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://nextprot.org/rdf#peptideMapping	8855603	\N	69	peptideMapping	peptideMapping	f	8855603	\N	\N	f	f	8	77	\N	t	f	\N	\N	\N	t	f	f
295	http://nextprot.org/rdf#gene	20519	\N	69	gene	gene	f	20519	\N	\N	f	f	65	95	\N	t	f	\N	\N	\N	t	f	f
297	http://nextprot.org/rdf#quality	130741442	\N	69	quality	quality	f	130741442	\N	\N	f	f	\N	176	\N	t	f	\N	\N	\N	t	f	f
298	http://nextprot.org/rdf#evidence	167119340	\N	69	evidence	evidence	f	167119340	\N	\N	f	f	\N	113	\N	t	f	\N	\N	\N	t	f	f
300	http://nextprot.org/rdf#induction	4837	\N	69	induction	induction	f	4837	\N	\N	f	f	8	112	\N	t	f	\N	\N	\N	t	f	f
303	http://nextprot.org/rdf#shortSequenceMotif	7886	\N	69	shortSequenceMotif	shortSequenceMotif	f	7886	\N	\N	f	f	8	94	\N	t	f	\N	\N	\N	t	f	f
304	http://nextprot.org/rdf#goCellularComponent	175584	\N	69	goCellularComponent	goCellularComponent	f	175584	\N	\N	f	f	8	48	\N	t	f	\N	\N	\N	t	f	f
305	http://nextprot.org/rdf#history	40790	\N	69	history	history	f	40790	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://purl.org/dc/terms/license	1	\N	5	license	license	f	1	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
312	http://nextprot.org/rdf#absorptionMax	3	\N	69	absorptionMax	absorptionMax	f	3	\N	\N	f	f	8	104	\N	t	f	\N	\N	\N	t	f	f
313	http://nextprot.org/rdf#interactant	1775555	\N	69	interactant	interactant	f	1775555	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://nextprot.org/rdf#sourceFile	757	\N	69	sourceFile	sourceFile	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
317	http://nextprot.org/rdf#apiRelease	1	\N	69	apiRelease	apiRelease	f	0	\N	\N	f	f	125	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://nextprot.org/rdf#antibodyName	42611	\N	69	antibodyName	antibodyName	f	0	\N	\N	f	f	49	\N	\N	t	f	\N	\N	\N	t	f	f
319	http://nextprot.org/rdf#ptmInfo	23226	\N	69	ptmInfo	ptmInfo	f	23226	\N	\N	f	f	8	93	\N	t	f	\N	\N	\N	t	f	f
320	http://nextprot.org/rdf#lastPage	563133	\N	69	lastPage	lastPage	f	0	\N	\N	f	f	150	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://nextprot.org/rdf#pharmaceutical	90	\N	69	pharmaceutical	pharmaceutical	f	90	\N	\N	f	f	8	41	\N	t	f	\N	\N	\N	t	f	f
322	http://nextprot.org/rdf#assocType	73897474	\N	69	assocType	assocType	f	0	\N	\N	f	f	113	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://purl.org/dc/terms/created	774	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
324	http://nextprot.org/rdf#termType	148320	\N	69	termType	termType	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
325	http://nextprot.org/rdf#assignedBy	73897474	\N	69	assignedBy	assignedBy	f	73897474	\N	\N	f	f	113	119	\N	t	f	\N	\N	\N	t	f	f
326	http://nextprot.org/rdf#integrated	40790	\N	69	integrated	integrated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	327957044	\N	1	type	type	f	327957044	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
327	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	46	46	\N	t	f	\N	\N	\N	t	f	f
302	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
307	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: https_www_nextprot_org; Owner: -
--

COPY https_www_nextprot_org.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	active site	\N
2	2	8	expression	\N
3	4	8	processing product	\N
4	6	8	non-terminal residue	\N
5	7	8	method	\N
6	8	8	go biological process	\N
7	9	8	term	\N
8	10	8	recommended name	\N
9	13	8	miscellaneous region	\N
10	14	8	coiled-coil region	\N
11	15	8	kinetic vmax	\N
12	16	8	biophysicochemical property	\N
13	17	8	equivalentClass	\N
14	18	8	turn	\N
15	19	8	function information	\N
16	21	8	beta strand	\N
17	22	8	intramembrane region	\N
18	24	8	priorVersion	\N
19	26	8	kinetic km	\N
20	28	8	general annotation	\N
21	31	8	pdb mapping	\N
22	32	8	from database	\N
23	33	8	expression profile	\N
24	34	8	go qualifier	\N
25	35	8	positional annotation	\N
26	36	8	dna-binding region	\N
27	37	8	proteotypic	\N
28	38	8	temperature dependence	\N
29	39	8	accession	\N
30	40	8	category	\N
31	41	8	repeat	\N
32	42	8	allele count	\N
33	44	8	miscellaneous	\N
34	45	8	peptide source	\N
35	50	8	peptide uniqueness	\N
36	51	8	journal	\N
37	52	8	isoform count	\N
38	54	8	tissue	\N
39	55	8	domain information	\N
40	57	8	initiator methionine	\N
41	58	8	miscellaneous site	\N
42	59	8	name	\N
43	61	8	chromosome strand	\N
44	63	8	experimental context	\N
45	65	8	child of	\N
46	67	8	peptide name	\N
47	72	8	pathway	\N
48	73	8	length	\N
49	76	8	go molecular function	\N
50	77	8	cleavage site	\N
51	81	8	non-consecutive residue	\N
52	82	8	existence	\N
53	84	8	expression information	\N
54	88	8	original	\N
55	89	8	reference	\N
56	90	8	best gene mapping	\N
57	91	8	self-interaction	\N
58	93	8	hgvs	\N
59	94	8	developmental stage	\N
60	95	8	enzyme classification	\N
61	100	8	last sequence update	\N
62	101	8	disease	\N
63	103	8	helix	\N
64	106	8	region	\N
65	107	8	function	\N
66	108	8	related	\N
67	109	8	allele number	\N
68	114	8	uniprot keyword	\N
69	115	8	author	\N
70	117	8	compositionally biased region	\N
71	118	8	binary interaction	\N
72	119	8	mapping	\N
73	120	8	isoelectric point	\N
74	121	8	complementOf	\N
75	123	8	publisher	\N
76	124	8	high expression	\N
77	125	8	maturation peptide	\N
78	126	8	medium expression	\N
79	127	8	transport activity	\N
80	129	8	observed expression	\N
81	130	8	glycosylation site	\N
82	133	8	swissprot page	\N
83	137	8	proteoform	\N
84	138	8	year	\N
85	141	8	chromosomal band	\N
86	142	8	metadata	\N
87	146	8	editor	\N
88	147	8	pH dependence	\N
89	148	8	disease-related variant	\N
90	149	8	undetected expression	\N
91	150	8	sequence version	\N
92	151	8	begin	\N
93	153	8	medical	\N
94	154	8	interaction mapping	\N
95	157	8	expression score	\N
96	158	8	variation	\N
97	159	8	cell line	\N
98	162	8	variant	\N
99	165	8	cross-link	\N
100	166	8	topology	\N
101	167	8	cofactor	\N
102	168	8	cellular component	\N
103	170	8	protein sequence	\N
104	171	8	family name	\N
105	174	8	negative	\N
106	175	8	site	\N
107	176	8	chain	\N
108	177	8	activity regulation	\N
109	183	8	disulfide bond	\N
110	184	8	interaction detection method	\N
111	185	8	srm peptide mapping	\N
112	186	8	updated	\N
113	188	8	city	\N
114	189	8	modified residue	\N
115	190	8	unionOf	\N
116	192	8	versionInfo	\N
117	195	8	detected expression	\N
118	196	8	small molecule interaction	\N
119	197	8	domain	\N
120	198	8	low expression	\N
121	200	8	allergen	\N
122	201	8	zinc finger region	\N
123	204	8	number of experiments	\N
124	205	8	signal peptide	\N
125	206	8	kinetic note	\N
126	208	8	interaction information	\N
127	209	8	caution	\N
128	212	8	binding site	\N
129	213	8	mutagenesis	\N
130	214	8	variant information	\N
131	215	8	issue	\N
132	217	8	antibody uniqueness	\N
133	218	8	interacting region	\N
134	219	8	molecular weight	\N
135	220	8	protein existence level	\N
136	226	8	redox potential	\N
137	228	8	entry annotation id	\N
138	229	8	mitochondrial transit peptide	\N
139	230	8	from	\N
140	231	8	evidence code	\N
141	234	8	selenocysteine	\N
142	235	8	interaction	\N
143	236	8	transmembrane region	\N
144	237	8	negative evidence	\N
145	238	8	mature protein	\N
146	240	8	subcellular location	\N
147	241	8	homozygote allele count	\N
148	242	8	antibody mapping	\N
149	246	8	sequence caution	\N
150	248	8	orf name	\N
151	249	8	title	\N
152	250	8	first page	\N
153	252	8	allele frequency	\N
154	253	8	alternative name	\N
155	257	8	provenance	\N
156	259	8	end	\N
157	260	8	topological domain	\N
158	261	8	peroxisome transit peptide	\N
159	263	8	oneOf	\N
160	264	8	equivalentProperty	\N
161	265	8	difference	\N
162	266	8	subcellular location information	\N
163	267	8	suffix	\N
164	268	8	ptm	\N
165	270	8	cofactor information	\N
166	271	8	version	\N
167	273	8	volume	\N
168	274	8	start	\N
169	275	8	sequence conflict	\N
170	276	8	developmental stage expression information	\N
171	277	8	severity	\N
172	278	8	publication type	\N
173	279	8	secondary structure	\N
174	280	8	isoform	\N
175	282	8	catalytic activity	\N
176	283	8	swissprot displayed	\N
177	284	8	lipid moiety-binding region	\N
178	286	8	other name	\N
179	289	8	impacted object	\N
180	290	8	phenotype variation	\N
181	291	8	chromosome	\N
182	292	8	imports	\N
183	293	8	peptide mapping	\N
184	295	8	gene	\N
185	297	8	quality	\N
186	298	8	evidence	\N
187	300	8	induction	\N
188	303	8	short sequence motif	\N
189	304	8	go cellular component	\N
190	305	8	history	\N
191	312	8	absorption max	\N
192	313	8	interactant	\N
193	318	8	antibody name	\N
194	319	8	ptm information	\N
195	320	8	last page	\N
196	321	8	pharmaceutical	\N
197	325	8	assigned by	\N
198	326	8	integrated	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cc_rels_id_seq', 12, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.class_annots_id_seq', 157, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.classes_id_seq', 177, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cp_rels_id_seq', 1610, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cpc_rels_id_seq', 2082, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.ns_id_seq', 70, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.properties_id_seq', 327, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: https_www_nextprot_org; Owner: -
--

SELECT pg_catalog.setval('https_www_nextprot_org.property_annots_id_seq', 198, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON https_www_nextprot_org.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON https_www_nextprot_org.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON https_www_nextprot_org.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON https_www_nextprot_org.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON https_www_nextprot_org.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON https_www_nextprot_org.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON https_www_nextprot_org.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON https_www_nextprot_org.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON https_www_nextprot_org.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON https_www_nextprot_org.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON https_www_nextprot_org.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON https_www_nextprot_org.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON https_www_nextprot_org.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON https_www_nextprot_org.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON https_www_nextprot_org.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON https_www_nextprot_org.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON https_www_nextprot_org.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON https_www_nextprot_org.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_cc_rels_data ON https_www_nextprot_org.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_classes_cnt ON https_www_nextprot_org.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_classes_data ON https_www_nextprot_org.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_classes_iri ON https_www_nextprot_org.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON https_www_nextprot_org.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON https_www_nextprot_org.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON https_www_nextprot_org.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_cp_rels_data ON https_www_nextprot_org.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON https_www_nextprot_org.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_instances_local_name ON https_www_nextprot_org.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_instances_test ON https_www_nextprot_org.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_data ON https_www_nextprot_org.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON https_www_nextprot_org.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON https_www_nextprot_org.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON https_www_nextprot_org.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON https_www_nextprot_org.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON https_www_nextprot_org.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON https_www_nextprot_org.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_properties_cnt ON https_www_nextprot_org.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_properties_data ON https_www_nextprot_org.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: https_www_nextprot_org; Owner: -
--

CREATE INDEX idx_properties_iri ON https_www_nextprot_org.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES https_www_nextprot_org.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES https_www_nextprot_org.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES https_www_nextprot_org.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_www_nextprot_org.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES https_www_nextprot_org.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_www_nextprot_org.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_www_nextprot_org.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_www_nextprot_org.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES https_www_nextprot_org.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES https_www_nextprot_org.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_www_nextprot_org.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_www_nextprot_org.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_www_nextprot_org.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES https_www_nextprot_org.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_www_nextprot_org.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_www_nextprot_org.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_www_nextprot_org.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES https_www_nextprot_org.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES https_www_nextprot_org.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_www_nextprot_org.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_www_nextprot_org.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES https_www_nextprot_org.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES https_www_nextprot_org.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_www_nextprot_org.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES https_www_nextprot_org.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES https_www_nextprot_org.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES https_www_nextprot_org.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES https_www_nextprot_org.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: https_www_nextprot_org; Owner: -
--

ALTER TABLE ONLY https_www_nextprot_org.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_www_nextprot_org.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

